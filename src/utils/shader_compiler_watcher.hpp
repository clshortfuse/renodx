#pragma once

#include <algorithm>
#include <charconv>
#include <chrono>
#include <exception>
#include <filesystem>
#include <include/reshade.hpp>

#include <Windows.h>

#include <atomic>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <sstream>
#include <string>
#include <system_error>
#include <thread>
#include <unordered_map>
#include <unordered_set>
#include <variant>
#include <vector>
#include "./format.hpp"
#include "./hlsl_dependencies.hpp"
#include "./path.hpp"
#include "./shader_compiler_directx.hpp"

namespace renodx::utils::shader::compiler::watcher {

static std::atomic_size_t custom_shaders_count = 0;

struct CustomShader {
  std::variant<std::exception, std::vector<uint8_t>> compilation;
  bool is_hlsl = false;
  bool is_glsl = false;
  std::filesystem::path file_path;
  uint32_t shader_hash = 0u;
  bool removed = false;

  [[nodiscard]] bool IsCompilationOK() const {
    return std::holds_alternative<std::vector<uint8_t>>(compilation);
  }

  [[nodiscard]] std::vector<uint8_t>& GetCompilationData() {
    return std::get<std::vector<uint8_t>>(compilation);
  }

  [[nodiscard]] const std::vector<uint8_t>& GetCompilationData() const {
    return std::get<std::vector<uint8_t>>(compilation);
  }

  [[nodiscard]] std::exception& GetCompilationException() {
    return std::get<std::exception>(compilation);
  }

  [[nodiscard]] const std::exception& GetCompilationException() const {
    return std::get<std::exception>(compilation);
  }

  [[nodiscard]] std::string GetFileAlias() const {
    if (!is_hlsl) return "";
    static const auto CHARACTERS_TO_REMOVE_FROM_END = std::string("0x12345678.xx_x_x.hlsl").length();
    auto filename = file_path.filename().string();
    filename.erase(filename.length() - (std::min)(CHARACTERS_TO_REMOVE_FROM_END, filename.length()));
    if (filename.ends_with("_")) {
      filename.erase(filename.length() - 1);
    }
    return filename;
  }
};

namespace internal {

static std::atomic_bool shared_watcher_enabled = false;
static std::atomic_bool shared_watcher_running = false;
static std::atomic_bool shared_shaders_changed = false;
static std::atomic_bool shared_compile_pending = false;
static std::optional<std::thread> worker_thread;

static std::shared_mutex mutex;
static std::unordered_map<uint32_t, CustomShader> custom_shaders_cache;
static std::unordered_map<uint32_t, CustomShader> pending_custom_shaders_cache;
struct DependencyMetadata {
  std::filesystem::path path;
  bool exists = false;
  std::filesystem::file_time_type last_write_time = std::filesystem::file_time_type::min();

  bool operator==(const DependencyMetadata&) const = default;
};
struct BuildMetadata {
  std::filesystem::path file_path;
  std::vector<DependencyMetadata> dependencies;
  std::size_t defines_revision = 0u;
};
static std::unordered_map<uint32_t, BuildMetadata> build_metadata_cache;
static std::vector<std::pair<std::string, std::string>> shared_shader_defines;
static std::size_t shared_shader_defines_revision = 0u;
static std::string live_path;
static std::filesystem::path watched_directory;

static OVERLAPPED overlapped;
static HANDLE m_target_dir_handle = INVALID_HANDLE_VALUE;
static std::aligned_storage_t<1U << 18, std::max<size_t>(alignof(FILE_NOTIFY_EXTENDED_INFORMATION), alignof(FILE_NOTIFY_INFORMATION))> watch_buffer;

static std::filesystem::path GetEffectiveLiveDirectory() {
  if (!live_path.empty()) {
    return std::filesystem::path(live_path).lexically_normal();
  }
  return renodx::utils::path::GetLiveOutputPath().lexically_normal();
}

static std::filesystem::path NormalizePathForComparison(const std::filesystem::path& path) {
  std::error_code error_code;
  auto normalized_path = std::filesystem::weakly_canonical(path, error_code);
  if (!error_code) {
    return normalized_path;
  }

  error_code.clear();
  normalized_path = std::filesystem::absolute(path, error_code);
  if (!error_code) {
    return normalized_path.lexically_normal();
  }

  return path.lexically_normal();
}

static bool HasHexPrefix(const std::string& text, std::size_t offset) {
  return text.size() >= offset + 2u
         && text[offset] == '0'
         && (text[offset + 1u] == 'x' || text[offset + 1u] == 'X');
}

static bool AreShadersEquivalent(const CustomShader& lhs, const CustomShader& rhs) {
  if (lhs.is_hlsl != rhs.is_hlsl
      || lhs.is_glsl != rhs.is_glsl
      || lhs.file_path != rhs.file_path
      || lhs.shader_hash != rhs.shader_hash
      || lhs.removed != rhs.removed) {
    return false;
  }

  if (lhs.IsCompilationOK() != rhs.IsCompilationOK()) {
    return false;
  }

  if (lhs.IsCompilationOK()) {
    return lhs.GetCompilationData() == rhs.GetCompilationData();
  }

  return std::string(lhs.GetCompilationException().what()) == rhs.GetCompilationException().what();
}

static void QueueShaderUpdate(uint32_t shader_hash, const CustomShader& custom_shader) {
  pending_custom_shaders_cache[shader_hash] = custom_shader;
  shared_shaders_changed = true;
}

static std::vector<DependencyMetadata> CollectDependencyMetadata(const std::filesystem::path& entry_path, bool is_hlsl) {
  std::vector<DependencyMetadata> dependencies;
  if (is_hlsl) {
    for (const auto& dependency : renodx::utils::shader::dependencies::CollectDependencies(entry_path)) {
      auto last_write_time = std::filesystem::file_time_type::min();
      if (dependency.exists) {
        std::error_code error_code;
        last_write_time = std::filesystem::last_write_time(dependency.path, error_code);
        if (error_code) {
          last_write_time = std::filesystem::file_time_type::min();
        }
      }
      dependencies.push_back(DependencyMetadata{
          .path = dependency.path,
          .exists = dependency.exists,
          .last_write_time = last_write_time,
      });
    }
    return dependencies;
  }

  auto normalized_path = NormalizePathForComparison(entry_path);
  dependencies.push_back(DependencyMetadata{
      .path = normalized_path,
      .exists = false,
      .last_write_time = std::filesystem::file_time_type::min(),
  });
  std::error_code error_code;
  dependencies.front().exists = std::filesystem::exists(normalized_path, error_code) && !error_code;
  if (dependencies.front().exists) {
    error_code.clear();
    dependencies.front().last_write_time = std::filesystem::last_write_time(normalized_path, error_code);
    if (error_code) {
      dependencies.front().last_write_time = std::filesystem::file_time_type::min();
    }
  }
  return dependencies;
}

static CustomShader CompileShader(
    const std::filesystem::path& entry_path,
    uint32_t shader_hash,
    bool is_hlsl,
    bool is_glsl,
    const std::string& shader_target) {
  CustomShader custom_shader = {
      .is_hlsl = is_hlsl,
      .is_glsl = is_glsl,
      .file_path = entry_path,
      .shader_hash = shader_hash,
      .removed = false,
  };

  if (is_hlsl) {
    {
      std::stringstream s;
      s << "loadCustomShaders(Compiling file: ";
      s << entry_path.string();
      s << ", hash: " << PRINT_CRC32(shader_hash);
      s << ", target: " << shader_target;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }

    try {
      custom_shader.compilation = renodx::utils::shader::compiler::directx::CompileShaderFromFile(
          entry_path.c_str(),
          shader_target.c_str(),
          shared_shader_defines);
    } catch (std::exception& exception) {
      custom_shader.compilation = exception;
      std::stringstream s;
      s << "loadCustomShaders(Compilation failed: ";
      s << entry_path.string();
      s << ", " << custom_shader.GetCompilationException().what();
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
    return custom_shader;
  }

  try {
    custom_shader.compilation = utils::path::ReadBinaryFile(entry_path);
  } catch (std::exception& exception) {
    custom_shader.compilation = exception;
    std::stringstream s;
    s << "loadCustomShaders(Failed to load file: ";
    s << entry_path.string();
    s << ", " << custom_shader.GetCompilationException().what();
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }

  return custom_shader;
}

static bool CompileCustomShaders() {
  const std::unique_lock lock(mutex);

  const auto directory = GetEffectiveLiveDirectory();
  std::unordered_set<uint32_t> shader_hashes_processed = {};
  bool has_updates = false;
  try {
    if (!std::filesystem::exists(directory)) {
      std::filesystem::create_directories(directory);
    }

    std::vector<std::filesystem::path> shader_file_paths;
    for (const auto& entry : std::filesystem::recursive_directory_iterator(
             directory,
             std::filesystem::directory_options::skip_permission_denied)) {
      if (!entry.is_regular_file()) continue;

      const auto entry_path = NormalizePathForComparison(entry.path());

      if (!entry_path.has_stem() || !entry_path.has_extension()) continue;

      shader_file_paths.push_back(entry_path);
    }

    // Duplicate hashes are ignored after the first match, so process paths in a stable order:
    // the first path alphabetically wins.
    std::sort(shader_file_paths.begin(), shader_file_paths.end(), [](const auto& lhs, const auto& rhs) {
      return lhs.native() < rhs.native();
    });

    for (const auto& entry_path : shader_file_paths) {
      const bool is_hlsl = entry_path.extension().compare(".hlsl") == 0;
      const bool is_cso = entry_path.extension().compare(".cso") == 0;
      const bool is_glsl = entry_path.extension().compare(".glsl") == 0;
      const bool is_spv = entry_path.extension().compare(".spv") == 0;
      if (!is_hlsl && !is_cso && !is_spv && !is_glsl) continue;

      auto basename = entry_path.stem().string();
      std::string hash_string;
      std::string shader_target;
      if (is_hlsl) {
        auto length = basename.length();
        if (length < strlen("0x12345678.xx_x_x")) continue;
        const auto hash_prefix_offset = length - strlen("0x12345678.xx_x_x");
        if (!HasHexPrefix(basename, hash_prefix_offset)) continue;
        shader_target = basename.substr(length - strlen("xx_x_x"), strlen("xx_x_x"));
        if (shader_target[2] != '_') continue;
        if (shader_target[4] != '_') continue;
        // uint32_t versionMajor = shader_target[3] - '0';
        hash_string = basename.substr(length - strlen("12345678.xx_x_x"), 8);
      } else if (is_cso || is_spv || is_glsl) {
        // Binary files must start with 0x12345678. The rest of the basename is ignored.
        if (basename.size() < 10 || !HasHexPrefix(basename, 0u)) {
          std::stringstream s;
          s << "CompileCustomShaders(Invalid file format: ";
          s << basename;
          s << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
          continue;
        }
        hash_string = basename.substr(2, 8);
      }

      uint32_t shader_hash = 0u;
      const auto [hash_end, hash_error] = std::from_chars(
          hash_string.data(),
          hash_string.data() + hash_string.size(),
          shader_hash,
          16);
      if (hash_error != std::errc{} || hash_end != hash_string.data() + hash_string.size()) {
        std::stringstream s;
        s << "CompileCustomShaders(Invalid shader hash: ";
        s << hash_string;
        s << ", at " << entry_path;
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        continue;
      }

      if (shader_hashes_processed.contains(shader_hash)) {
        std::stringstream s;
        s << "CompileCustomShaders(Ignoring duplicate shader: ";
        s << PRINT_CRC32(shader_hash);
        s << ", at " << entry_path;
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        continue;
      }

      BuildMetadata next_build_metadata = {
          .file_path = entry_path,
          .dependencies = CollectDependencyMetadata(entry_path, is_hlsl),
          .defines_revision = shared_shader_defines_revision,
      };
      shader_hashes_processed.emplace(shader_hash);

      const auto previous_build_metadata = build_metadata_cache.find(shader_hash);
      const auto previous_shader = custom_shaders_cache.find(shader_hash);
      const bool has_previous_shader = previous_shader != custom_shaders_cache.end();
      const bool cached_build_is_identical = previous_build_metadata != build_metadata_cache.end()
                                             && has_previous_shader
                                             && previous_build_metadata->second.file_path == entry_path
                                             && previous_build_metadata->second.defines_revision == shared_shader_defines_revision
                                             && std::ranges::equal(
                                                 previous_build_metadata->second.dependencies,
                                                 next_build_metadata.dependencies);
      if (cached_build_is_identical) {
        continue;
      }

      auto custom_shader = CompileShader(entry_path, shader_hash, is_hlsl, is_glsl, shader_target);

      build_metadata_cache[shader_hash] = std::move(next_build_metadata);

      if (!has_previous_shader || !AreShadersEquivalent(previous_shader->second, custom_shader)) {
        QueueShaderUpdate(shader_hash, custom_shader);
        has_updates = true;
      }

      custom_shaders_cache[shader_hash] = std::move(custom_shader);
    }
  } catch (std::exception& ex) {
    reshade::log::message(reshade::log::level::error, ex.what());
    return false;
  }

  for (auto iterator = build_metadata_cache.begin(); iterator != build_metadata_cache.end();) {
    const auto shader_hash = iterator->first;
    if (shader_hashes_processed.contains(shader_hash)) {
      ++iterator;
      continue;
    }

    iterator = build_metadata_cache.erase(iterator);
    if (auto custom_shader = custom_shaders_cache.find(shader_hash); custom_shader != custom_shaders_cache.end()) {
      auto removed_shader = custom_shader->second;
      removed_shader.removed = true;
      QueueShaderUpdate(shader_hash, removed_shader);
      custom_shaders_cache.erase(custom_shader);
      has_updates = true;
    }
  }

  custom_shaders_count = custom_shaders_cache.size();
  if (!has_updates && pending_custom_shaders_cache.empty()) {
    shared_shaders_changed = false;
  }
  return has_updates;
}

static void CALLBACK HandleEventCallback(DWORD error_code, DWORD bytes_transferred, LPOVERLAPPED overlapped) {
  if (error_code == ERROR_OPERATION_ABORTED) {
    return;
  }
  shared_watcher_running = false;
  shared_compile_pending = true;
}

static bool EnableLiveWatcher(const std::filesystem::path& directory) {
  std::filesystem::create_directories(directory);

  reshade::log::message(reshade::log::level::info, "Watching live.");

  watched_directory = NormalizePathForComparison(directory);
  m_target_dir_handle = CreateFileW(
      directory.c_str(),
      FILE_LIST_DIRECTORY,
      (FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE),
      NULL,  // NOLINT
      OPEN_EXISTING,
      (FILE_FLAG_BACKUP_SEMANTICS | FILE_FLAG_OVERLAPPED),
      NULL  // NOLINT
  );
  if (m_target_dir_handle == INVALID_HANDLE_VALUE) {
    reshade::log::message(reshade::log::level::error, "ToggleLiveWatching(targetHandle: invalid)");
    return false;
  }
  {
    std::stringstream s;
    s << "ToggleLiveWatching(targetHandle: ";
    s << reinterpret_cast<uintptr_t>(m_target_dir_handle);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  memset(&watch_buffer, 0, sizeof(watch_buffer));
  overlapped = {0};
  overlapped.hEvent = CreateEvent(NULL, TRUE, FALSE, NULL);  // NOLINT
  if (overlapped.hEvent == nullptr) {
    CloseHandle(m_target_dir_handle);
    m_target_dir_handle = INVALID_HANDLE_VALUE;
    watched_directory.clear();
    std::stringstream s;
    s << "ToggleLiveWatching(CreateEvent: Failed: ";
    s << GetLastError();
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }

  const BOOL success = ReadDirectoryChangesExW(
      m_target_dir_handle,
      &watch_buffer,
      sizeof(watch_buffer),
      TRUE,
      FILE_NOTIFY_CHANGE_FILE_NAME
          | FILE_NOTIFY_CHANGE_DIR_NAME
          | FILE_NOTIFY_CHANGE_ATTRIBUTES
          | FILE_NOTIFY_CHANGE_SIZE
          | FILE_NOTIFY_CHANGE_CREATION
          | FILE_NOTIFY_CHANGE_LAST_WRITE,
      NULL,  // NOLINT
      &overlapped,
      &HandleEventCallback,
      ReadDirectoryNotifyExtendedInformation);

  if (success == FALSE) {
    CloseHandle(m_target_dir_handle);
    m_target_dir_handle = INVALID_HANDLE_VALUE;
    CloseHandle(overlapped.hEvent);
    overlapped.hEvent = nullptr;
    watched_directory.clear();
    std::stringstream s;
    s << "ToggleLiveWatching(ReadDirectoryChangesExW: Failed: ";
    s << GetLastError();
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }
  reshade::log::message(reshade::log::level::info, "ToggleLiveWatching(ReadDirectoryChangesExW: Listening.)");
  return true;
}

static void DisableLiveWatcher(bool cancel_pending = true) {
  if (m_target_dir_handle != INVALID_HANDLE_VALUE) {
    if (cancel_pending) {
      reshade::log::message(reshade::log::level::info, "Cancelling live.");
      CancelIoEx(m_target_dir_handle, &overlapped);
    }
    CloseHandle(m_target_dir_handle);
    m_target_dir_handle = INVALID_HANDLE_VALUE;
  }
  if (overlapped.hEvent != nullptr) {
    CloseHandle(overlapped.hEvent);
    overlapped.hEvent = nullptr;
  }
  watched_directory.clear();
}

static void Watch() {
  while (true) {
    {
      if (!shared_watcher_enabled) {
        DisableLiveWatcher();
        shared_watcher_running = false;
        return;
      }
      std::filesystem::path effective_directory;
      {
        const std::shared_lock state_lock(mutex);
        effective_directory = NormalizePathForComparison(GetEffectiveLiveDirectory());
      }
      if (shared_watcher_running && effective_directory != watched_directory) {
        DisableLiveWatcher();
        shared_watcher_running = false;
      }
      if (!shared_watcher_running) {
        DisableLiveWatcher(false);
        if (EnableLiveWatcher(effective_directory)) {
          shared_watcher_running = true;
        }
      }
      if (shared_compile_pending.exchange(false)) {
        CompileCustomShaders();
      }
    }

    if (shared_watcher_running) {
      WaitForSingleObjectEx(overlapped.hEvent, 100, TRUE);
    } else {
      std::this_thread::sleep_for(std::chrono::milliseconds(1000));
    }
  }
}
}  // namespace internal

static void Start() {
  internal::shared_compile_pending = true;
  if (internal::worker_thread.has_value()) return;
  internal::shared_watcher_enabled = true;
  internal::worker_thread = std::thread(internal::Watch);
}

static void Stop() {
  if (!internal::worker_thread.has_value()) return;
  internal::shared_watcher_enabled = false;
  internal::worker_thread->join();
  internal::worker_thread.reset();
}

static bool IsEnabled() {
  return internal::shared_watcher_enabled;
}

// Retrieves and consumes all compiled shareds
static std::unordered_map<uint32_t, CustomShader> FlushCompiledShaders() {
  const std::unique_lock lock(internal::mutex);
  std::unordered_map<uint32_t, CustomShader> copy = internal::pending_custom_shaders_cache;
  internal::pending_custom_shaders_cache.clear();
  internal::shared_shaders_changed = false;
  return copy;
}

static std::unordered_map<uint32_t, CustomShader> GetCompiledShaders() {
  const std::shared_lock lock(internal::mutex);
  return internal::custom_shaders_cache;
}

static bool HasChanged() {
  return internal::shared_shaders_changed;
}

static bool CompileSync() {
  return internal::CompileCustomShaders();
}

template <class T>
static void SetShaderDefines(const T& defines) {
  const std::unique_lock lock(internal::mutex);
  internal::shared_shader_defines.clear();
  for (const auto& pair : defines) {
    internal::shared_shader_defines.emplace_back(pair);
  }
  internal::shared_shader_defines_revision += 1u;
  internal::shared_compile_pending = true;
}

static void SetShaderDefines(const std::vector<std::pair<std::string, std::string>>& defines) {
  const std::unique_lock lock(internal::mutex);
  internal::shared_shader_defines = defines;
  internal::shared_shader_defines_revision += 1u;
  internal::shared_compile_pending = true;
}

static std::string GetLivePath() {
  const std::shared_lock lock(internal::mutex);
  return internal::live_path;
}

static void SetLivePath(const std::string& live_path) {
  const std::unique_lock lock(internal::mutex);
  internal::live_path.assign(live_path);
  internal::shared_compile_pending = true;
}

static void RequestCompile() {
  internal::shared_compile_pending = true;
}

}  // namespace renodx::utils::shader::compiler::watcher
