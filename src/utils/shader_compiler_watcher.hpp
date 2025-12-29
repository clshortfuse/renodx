#pragma once

#include <algorithm>
#include <chrono>
#include <exception>
#include <filesystem>
#include <include/reshade.hpp>

#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <Windows.h>

#include <atomic>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <thread>
#include <unordered_map>
#include <unordered_set>
#include <variant>
#include <vector>
#include "./format.hpp"
#include "./path.hpp"
#include "./shader_compiler_directx.hpp"
#include "./shader_compiler_slang.hpp"

namespace renodx::utils::shader::compiler::watcher {

static std::atomic_size_t custom_shaders_count = 0;

struct CustomShader {
  std::variant<std::exception, std::vector<uint8_t>> compilation;
  bool is_hlsl = false;
  bool is_glsl = false;
  bool is_slang = false;
  std::filesystem::path file_path;
  uint32_t shader_hash;
  bool removed = false;

  [[nodiscard]] bool IsCompilationOK() const {
    return std::holds_alternative<std::vector<uint8_t>>(compilation);
  }

  [[nodiscard]] std::vector<uint8_t>& GetCompilationData() {
    return std::get<std::vector<uint8_t>>(compilation);
  }

  [[nodiscard]] std::exception& GetCompilationException() {
    return std::get<std::exception>(compilation);
  }

  [[nodiscard]] std::string GetFileAlias() const {
    auto filename = file_path.filename().string();
    if (is_hlsl) {
      static const auto CHARACTERS_TO_REMOVE_FROM_END = std::string("0x12345678.xx_x_x.hlsl").length();
      filename.erase(filename.length() - (std::min)(CHARACTERS_TO_REMOVE_FROM_END, filename.length()));
      if (filename.ends_with("_")) {
        filename.erase(filename.length() - 1);
      }
      return filename;
    }
    if (is_slang) {
      if (auto suffix_pos = filename.rfind(".slang"); suffix_pos != std::string::npos) {
        filename.erase(suffix_pos);
      }
      if (auto target_pos = filename.rfind('.'); target_pos != std::string::npos) {
        filename.erase(target_pos);
      }
      if (auto hash_pos = filename.rfind("_0x"); hash_pos != std::string::npos) {
        filename.erase(hash_pos);
      }
      return filename;
    }
    return "";
  }
};

namespace internal {

static std::atomic_bool shared_watcher_enabled = false;
static std::atomic_bool shared_watcher_running = false;
static std::atomic_bool shared_shaders_changed = false;
static std::atomic_bool shared_compile_pending = false;
static std::optional<std::thread> worker_thread;

constexpr uint32_t MAX_SHADER_DEFINES = 4;
const bool PRECOMPILE_CUSTOM_SHADERS = true;

static std::shared_mutex mutex;
static std::unordered_map<uint32_t, CustomShader> custom_shaders_cache;
static std::vector<std::pair<std::string, std::string>> shared_shader_defines;
static std::string live_path;

static OVERLAPPED overlapped;
static HANDLE m_target_dir_handle = INVALID_HANDLE_VALUE;
static std::aligned_storage_t<1U << 18, std::max<size_t>(alignof(FILE_NOTIFY_EXTENDED_INFORMATION), alignof(FILE_NOTIFY_INFORMATION))> watch_buffer;

static bool CompileCustomShaders() {
  const std::unique_lock lock(mutex);

  std::filesystem::path directory;
  if (live_path.empty()) {
    directory = renodx::utils::path::GetOutputPath();
    if (!std::filesystem::exists(directory)) {
      std::filesystem::create_directory(directory);
      return false;
    }
    directory /= "live";
  } else {
    directory = live_path;
  }
  std::unordered_set<uint32_t> shader_hashes_processed = {};
  std::unordered_set<uint32_t> shader_hashes_failed = {};
  std::unordered_set<uint32_t> shader_hashes_updated = {};
  try {
    if (!std::filesystem::exists(directory)) {
      std::filesystem::create_directory(directory);
      return false;
    }

    for (const auto& entry : std::filesystem::recursive_directory_iterator(directory)) {
      if (!entry.is_regular_file()) continue;

      const auto& entry_path = entry.path();

      if (!entry_path.has_stem() || !entry_path.has_extension()) continue;

      const bool is_hlsl = entry_path.extension().compare(".hlsl") == 0;
      const bool is_cso = entry_path.extension().compare(".cso") == 0;
      const bool is_glsl = entry_path.extension().compare(".glsl") == 0;
      const bool is_spv = entry_path.extension().compare(".spv") == 0;
      const bool is_slang = entry_path.extension().compare(".slang") == 0;
      if (!is_hlsl && !is_cso && !is_spv && !is_glsl && !is_slang) continue;

      auto basename = entry_path.stem().string();
      std::string hash_string;
      std::string shader_target;
      std::string shader_stage;

      if (is_hlsl) {
        auto length = basename.length();
        if (length < strlen("0x12345678.xx_x_x")) continue;
        shader_target = basename.substr(length - strlen("xx_x_x"), strlen("xx_x_x"));
        if (shader_target[2] != '_') continue;
        if (shader_target[4] != '_') continue;
        // uint32_t versionMajor = shader_target[3] - '0';
        hash_string = basename.substr(length - strlen("12345678.xx_x_x"), 8);
      } else if (is_slang) {
        const auto& filename = entry_path.filename().string();
        const auto slang_suffix = filename.rfind(".slang");
        if (slang_suffix == std::string::npos || slang_suffix == 0) continue;
        const auto before_suffix = filename.substr(0, slang_suffix);
        const auto target_dot = before_suffix.rfind('.');
        if (target_dot == std::string::npos || target_dot == 0) continue;
        shader_target = before_suffix.substr(target_dot + 1);
        const auto shader_name = before_suffix.substr(0, target_dot);
        if (shader_name.size() < 10 || shader_name.rfind("0x") != shader_name.size() - 10) continue;
        hash_string = shader_name.substr(shader_name.size() - 8, 8);
      } else if (is_cso || is_spv || is_glsl) {
        // Binaries files must start with 0x12345678. The rest of the basename is ignored.
        if (basename.size() < 10) {
          std::stringstream s;
          s << "CompileCustomShaders(Invalid file format: ";
          s << basename;
          s << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
          continue;
        }
        hash_string = basename.substr(2, 8);
      }

      uint32_t shader_hash;
      try {
        shader_hash = std::stoul(hash_string, nullptr, 16);
      } catch (std::exception& e) {
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

      // Prepare new custom shader entry but hold off unless it actually compiles ()

      CustomShader custom_shader = {
          .is_hlsl = is_hlsl,
          .is_glsl = is_glsl,
          .is_slang = is_slang,
          .file_path = entry_path,
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
          shader_hashes_processed.emplace(shader_hash);
          shader_hashes_failed.erase(shader_hash);
        } catch (std::exception& e) {
          shader_hashes_failed.emplace(shader_hash);
          custom_shader.compilation = e;
          std::stringstream s;
          s << "loadCustomShaders(Compilation failed: ";
          s << entry_path.string();
          s << ", " << custom_shader.GetCompilationException().what();
          s << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
        }

      } else if (is_slang) {
        {
          std::stringstream s;
          s << "loadCustomShaders(Compiling slang file: ";
          s << entry_path.string();
          s << ", hash: " << PRINT_CRC32(shader_hash);
          s << ", target: " << shader_target;
          s << ")";
          reshade::log::message(reshade::log::level::debug, s.str().c_str());
        }

        try {
          custom_shader.compilation = renodx::utils::shader::compiler::slang::CompileShaderFromFile(
              entry_path.c_str(),
              shader_target.c_str(),
              shared_shader_defines);
          shader_hashes_processed.emplace(shader_hash);
          shader_hashes_failed.erase(shader_hash);
        } catch (std::exception& e) {
          shader_hashes_failed.emplace(shader_hash);
          custom_shader.compilation = e;
          std::stringstream s;
          s << "loadCustomShaders(Compilation failed: ";
          s << entry_path.string();
          s << ", " << custom_shader.GetCompilationException().what();
          s << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
        }

      } else if (is_cso || is_spv || is_glsl) {
        try {
          custom_shader.compilation = utils::path::ReadBinaryFile(entry_path);
          shader_hashes_processed.emplace(shader_hash);
          shader_hashes_failed.erase(shader_hash);
        } catch (std::exception& e) {
          custom_shader.compilation = e;
          shader_hashes_failed.emplace(shader_hash);
          continue;
        }
      }

      // Find previous entry
      bool insert_or_replace = true;
      if (auto previous_pair = custom_shaders_cache.find(shader_hash);
          previous_pair != custom_shaders_cache.end()) {
        auto& previous_custom_shader = previous_pair->second;
        if (custom_shader.IsCompilationOK()
            && previous_custom_shader.IsCompilationOK()
            && custom_shader.GetCompilationData() == previous_custom_shader.GetCompilationData()) {
          // Same data, update source
          previous_custom_shader.is_hlsl = is_hlsl;
          previous_custom_shader.is_glsl = is_glsl;
          previous_custom_shader.is_slang = is_slang;
          previous_custom_shader.file_path = entry_path;
          insert_or_replace = false;
        }
      }
      if (insert_or_replace) {
        // New entry
        custom_shaders_cache[shader_hash] = custom_shader;
        shader_hashes_updated.emplace(shader_hash);
      }
    }
  } catch (std::exception& ex) {
    reshade::log::message(reshade::log::level::error, ex.what());
    return false;
  }

  for (auto& [shader_hash, custom_shader] : custom_shaders_cache) {
    if (!shader_hashes_processed.contains(shader_hash)) {
      if (!custom_shader.removed) {
        custom_shader.removed = true;
        shader_hashes_updated.insert(shader_hash);
      }
    }
  }

  if (shader_hashes_updated.size() != 0) {
    custom_shaders_count = custom_shaders_cache.size();
    shared_shaders_changed = true;
    return true;
  }
  return false;
}

static void CALLBACK HandleEventCallback(DWORD error_code, DWORD bytes_transferred, LPOVERLAPPED overlapped) {
  shared_watcher_running = false;
  shared_compile_pending = true;
}

static bool EnableLiveWatcher() {
  auto directory = utils::path::GetOutputPath();
  if (!std::filesystem::exists(directory)) {
    std::filesystem::create_directory(directory);
  }

  directory /= "live";

  if (!std::filesystem::exists(directory)) {
    std::filesystem::create_directory(directory);
  }

  reshade::log::message(reshade::log::level::info, "Watching live.");

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

static void DisableLiveWatcher() {
  reshade::log::message(reshade::log::level::info, "Cancelling live.");
  CancelIoEx(m_target_dir_handle, &overlapped);
  CloseHandle(m_target_dir_handle);
}

static void Watch() {
  while (true) {
    {
      if (!shared_watcher_enabled) {
        DisableLiveWatcher();
        shared_watcher_running = false;
        return;
      }
      if (!shared_watcher_running) {
        if (EnableLiveWatcher()) {
          shared_watcher_running = true;
        }
      }
      if (shared_compile_pending) {
        CompileCustomShaders();
        shared_compile_pending = false;
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
  std::unordered_map<uint32_t, CustomShader> copy = internal::custom_shaders_cache;
  internal::custom_shaders_cache.clear();
  custom_shaders_count = 0;
  internal::shared_shaders_changed = false;
  return copy;
}

static bool HasChanged() {
  return internal::shared_shaders_changed;
}

static bool CompileSync() {
  return internal::CompileCustomShaders();
}

template <class T>
static void SetShaderDefines(T& defines) {
  const std::unique_lock lock(internal::mutex);
  internal::shared_shader_defines.clear();
  for (auto& pair : defines) {
    internal::shared_shader_defines.emplace_back(pair);
  }
}

static void SetShaderDefines(std::vector<std::pair<std::string, std::string>>& defines) {
  const std::unique_lock lock(internal::mutex);
  internal::shared_shader_defines = defines;
}

static std::string GetLivePath() {
  const std::shared_lock lock(internal::mutex);
  return internal::live_path;
}

static void SetLivePath(const std::string& live_path) {
  const std::unique_lock lock(internal::mutex);
  internal::live_path.assign(live_path);
}

static void RequestCompile() {
  internal::shared_compile_pending = true;
}

}  // namespace renodx::utils::shader::compiler::watcher
