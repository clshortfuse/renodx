/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#pragma comment(lib, "dxguid.lib")

#include <d3d11.h>
#include <d3d12.h>
#include <Windows.h>

#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <shared_mutex>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <crc32_hash.hpp>
#include "../utils/descriptor.hpp"
#include "../utils/format.hpp"
#include "../utils/pipeline.hpp"
#include "../utils/shader_compiler.hpp"

#define ICON_FK_REFRESH u8"\uf021"
#define ICON_FK_FLOPPY  u8"\uf0c7"

namespace {
struct CachedPipeline {
  reshade::api::pipeline pipeline;
  reshade::api::device* device;
  reshade::api::pipeline_layout layout;
  reshade::api::pipeline_subobject* subobjects_cache;
  uint32_t subobject_count;
  bool cloned;
  reshade::api::pipeline pipeline_clone;
  std::filesystem::path hlsl_path;
  std::string compilation_error;
  // Original shader hash (for now we only support one)
  uint32_t shader_hash;
  // If true, this pipeline is currently being "tested"
  bool test;
};

struct InstructionState {
  reshade::addon_event action;
  std::vector<uint64_t> textures;
  std::vector<uint64_t> uavs;
  std::vector<uint64_t> render_targets;
  uint32_t shader;
};

struct CachedShader {
  void* data = nullptr;
  size_t size = 0;
  reshade::api::pipeline_subobject_type type;
  int32_t index = -1;
  std::string disasm;
};

std::shared_mutex s_mutex;

struct __declspec(uuid("3b70b2b2-52dc-4637-bd45-c1171c4c322e")) DeviceData {
  // <resource.handle, resource_view.handle>
  std::unordered_map<uint64_t, uint64_t> resource_views;
  // <resource.handle, vector<resource_view.handle>>
  std::unordered_map<uint64_t, std::vector<uint64_t>> resource_views_by_resource;
  std::unordered_map<uint64_t, std::string> resource_names;
  std::unordered_set<uint64_t> resources;
  std::shared_mutex mutex;
  reshade::api::device_api device_api;
};

std::unordered_set<uint64_t> compute_shader_layouts;

std::unordered_map<uint64_t, CachedPipeline*> pipeline_cache_by_pipeline_handle;
std::unordered_map<uint32_t, std::unordered_set<CachedPipeline*>> pipeline_caches_by_shader_hash;
std::unordered_map<uint32_t, CachedShader*> shader_cache;

std::unordered_set<uint64_t> pipelines_to_reload;
static_assert(sizeof(reshade::api::pipeline::handle) == sizeof(uint64_t));
// Map of "reshade::api::pipeline::handle"
std::unordered_map<uint64_t, reshade::api::device*> pipelines_to_destroy;
std::unordered_set<uint32_t> shaders_to_dump;

// All the shaders we have already dumped
std::unordered_set<uint32_t> dumped_shaders;
// All the shaders the user has (and has had) as custom in the live folder
std::unordered_set<uint32_t> custom_shader_files;

//std::unordered_set<uint64_t> pipeline_clones;

std::vector<uint32_t> trace_shader_hashes;
std::vector<uint64_t> trace_pipeline_handles;
std::vector<InstructionState> instructions;

constexpr uint32_t MAX_SHADER_DEFINES = 3;

// Settings
bool auto_dump = false;
bool auto_live_reload = false;
bool list_unique = false;
std::vector<std::string> shader_defines;

bool trace_scheduled = false;
bool trace_running = false;
bool needs_unload_shaders = false;
bool needs_load_shaders = false;
bool needs_auto_load_update = auto_live_reload;
bool cloned_pipelines_changed = false;
uint32_t cloned_pipeline_count = 0;
uint32_t shader_cache_count = 0;
uint32_t shader_cache_size = 0;
uint32_t resource_count = 0;
uint32_t resource_view_count = 0;
uint32_t trace_count = 0;
uint32_t present_count = 0;

const uint32_t MAX_PRESENT_COUNT = 60;
bool force_all = false;
bool trace_names = false;

// Forward declares:
void ToggleLiveWatching();
void DumpShader(uint32_t shader_hash, bool auto_detect_type);

inline void GetD3DName(ID3D11DeviceChild* obj, std::string& name) {
  if (obj == nullptr) {
    return;
  }

  // NOLINTNEXTLINE(modernize-avoid-c-arrays)
  char c_name[128] = {};
  UINT size = sizeof(name);
  if (obj->GetPrivateData(WKPDID_D3DDebugObjectName, &size, c_name) == S_OK) {
    name = c_name;
  }
}

inline void GetD3DName(ID3D12Resource* obj, std::string& name) {
  if (obj == nullptr) {
    return;
  }

  // NOLINTNEXTLINE(modernize-avoid-c-arrays)
  char c_name[128] = {};
  UINT size = sizeof(name);
  if (obj->GetPrivateData(WKPDID_D3DDebugObjectName, &size, c_name) == S_OK) {
    name = c_name;
  }
}

uint64_t GetResourceByViewHandle(DeviceData& data, uint64_t handle) {
  if (
      auto pair = data.resource_views.find(handle);
      pair != data.resource_views.end()) return pair->second;

  return 0;
}

std::string GetResourceNameByViewHandle(DeviceData& data, uint64_t handle) {
  if (!trace_names) return "?";
  auto resource_handle = GetResourceByViewHandle(data, handle);
  if (resource_handle == 0) return "?";
  if (!data.resources.contains(resource_handle)) return "?";

  if (
      auto pair = data.resource_names.find(resource_handle);
      pair != data.resource_names.end()) return pair->second;

  std::string name;
  if (data.device_api == reshade::api::device_api::d3d11) {
    auto* native_resource = reinterpret_cast<ID3D11DeviceChild*>(resource_handle);
    GetD3DName(native_resource, name);
  } else if (data.device_api == reshade::api::device_api::d3d12) {
    auto* native_resource = reinterpret_cast<ID3D12Resource*>(resource_handle);
    GetD3DName(native_resource, name);
  } else {
    name = "?";
  }
  if (!name.empty()) {
    data.resource_names[resource_handle] = name;
  }
  return name;
}

std::filesystem::path GetShaderPath() {
  // NOLINTNEXTLINE(modernize-avoid-c-arrays)
  wchar_t file_prefix[MAX_PATH] = L"";
  GetModuleFileNameW(nullptr, file_prefix, ARRAYSIZE(file_prefix));

  std::filesystem::path dump_path = file_prefix;
  dump_path = dump_path.parent_path();
  dump_path /= ".\\renodx-dev";
  return dump_path;
}

void DestroyPipelineSubojects(reshade::api::pipeline_subobject* subojects, uint32_t subobject_count) {
  for (uint32_t i = 0; i < subobject_count; ++i) {
    auto& suboject = subojects[i];

    switch (suboject.type) {
      case reshade::api::pipeline_subobject_type::compute_shader:
        [[fallthrough]];
      case reshade::api::pipeline_subobject_type::pixel_shader: {
        auto* desc = static_cast<reshade::api::shader_desc*>(suboject.data);
        delete desc->code;
        desc->code = nullptr;
      } break;
      default:
        break;
    }

    delete suboject.data;
    suboject.data = nullptr;
  }
  delete[] subojects;  // NOLINT
}

void UnloadCustomShaders(const std::unordered_set<uint64_t>& pipelines_filter = std::unordered_set<uint64_t>(), bool immediate = false) {
  for (auto& pair : pipeline_cache_by_pipeline_handle) {
    auto& cached_pipeline = pair.second;
    if (cached_pipeline == nullptr || (!pipelines_filter.empty() && !pipelines_filter.contains(cached_pipeline->pipeline.handle))) continue;

    cached_pipeline->test = false;  // Disable testing here, otherwise we might not always have a way to do it
    if (!cached_pipeline->cloned) continue;
    cached_pipeline->cloned = false;  // This stops the cloned pipeline from being used in the next frame, allowing us to destroy it
    cached_pipeline->compilation_error.clear();
    cloned_pipeline_count--;
    cloned_pipelines_changed = true;

    if (immediate) {
      cached_pipeline->device->destroy_pipeline(reshade::api::pipeline{cached_pipeline->pipeline_clone.handle});
    } else {
      pipelines_to_destroy[cached_pipeline->pipeline_clone.handle] = cached_pipeline->device;
    }
    cached_pipeline->pipeline_clone = {0};
  }
}

void LoadCustomShaders(const std::unordered_set<uint64_t>& pipelines_filter = std::unordered_set<uint64_t>()) {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  reshade::log_message(reshade::log_level::debug, "loadCustomShaders()");

  // Clear all previously loaded custom shaders
  UnloadCustomShaders(pipelines_filter);

  auto directory = GetShaderPath();
  if (!std::filesystem::exists(directory)) {
    std::filesystem::create_directory(directory);
  }

  directory /= ".\\live";

  if (!std::filesystem::exists(directory)) {
    std::filesystem::create_directory(directory);
    return;
  }

  for (const auto& entry : std::filesystem::directory_iterator(directory)) {
    if (!entry.is_regular_file()) {
      reshade::log_message(reshade::log_level::warning, "loadCustomShaders(not a regular file)");
      continue;
    }
    const auto& entry_path = entry.path();
    if (!entry_path.has_extension()) {
      std::stringstream s;
      s << "loadCustomShaders(Missing extension: ";
      s << entry_path.string();
      s << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      continue;
    }
    uint32_t shader_hash;
    std::vector<uint8_t> code;
    bool is_hlsl = false;

    if (entry_path.extension().compare(".hlsl") == 0) {
      auto filename = entry_path.filename();
      auto filename_string = filename.string();
      auto length = filename_string.length();

      if (length < strlen("0x12345678.xx_x_x.hlsl")) continue;
      std::string shader_target = filename_string.substr(length - strlen("xx_x_x.hlsl"), strlen("xx_x_x"));
      if (shader_target[2] != '_') continue;
      if (shader_target[4] != '_') continue;
      // uint32_t versionMajor = shader_target[3] - '0';
      const std::string hash_string = filename_string.substr(length - strlen("12345678.xx_x_x.hlsl"), 8);
      shader_hash = std::stoul(hash_string, nullptr, 16);

      // Early out before compiling to avoid stutters with live reload
      if (!pipelines_filter.empty()) {
        bool pipeline_found = false;
        for (const auto& pipeline_pair : pipeline_cache_by_pipeline_handle) {
          if (pipeline_pair.second->shader_hash != shader_hash) continue;
          if (pipelines_filter.contains(pipeline_pair.first)) {
            pipeline_found = true;
          }
          break;
        }
        if (!pipeline_found) {
          continue;
        }
      }

      {
        std::stringstream s;
        s << "loadCustomShaders(Compiling file: ";
        s << entry_path.string();
        s << ", hash: " << PRINT_CRC32(shader_hash);
        s << ", target: " << shader_target;
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

      std::string compilation_error_string;
      code = renodx::utils::shader::compiler::CompileShaderFromFile(
          entry_path.c_str(),
          shader_target.c_str(),
          shader_defines,
          &compilation_error_string);
      if (code.empty()) {
        std::stringstream s;
        s << "loadCustomShaders(Compilation failed: ";
        s << entry_path.string();
        s << ")";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());

        auto pipelines_pair = pipeline_caches_by_shader_hash.find(shader_hash);
        if (pipelines_pair != pipeline_caches_by_shader_hash.end()) {
          for (auto& pipeline : pipelines_pair->second)
          {
            pipeline->compilation_error = compilation_error_string;
          }
        }

        continue;
      }

      is_hlsl = true;
      {
        std::stringstream s;
        s << "loadCustomShaders(Shader built with size: " << code.size() << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

    } else if (entry_path.extension().compare(".cso") == 0) {
      auto filename = entry_path.filename();
      auto filename_string = filename.string();
      if (filename_string.size() != 14) {
        std::stringstream s;
        s << "loadCustomShaders(Invalid cso file format: ";
        s << filename_string;
        s << ")";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        continue;
      }
      shader_hash = std::stoul(filename_string.substr(2, 8), nullptr, 16);

      if (!pipelines_filter.empty()) {
        bool pipeline_found = false;
        for (const auto& pipeline_pair : pipeline_cache_by_pipeline_handle) {
          if (pipeline_pair.second->shader_hash != shader_hash) continue;
          if (pipelines_filter.contains(pipeline_pair.first)) {
            pipeline_found = true;
          }
          break;
        }
        if (!pipeline_found) {
          continue;
        }
      }

      std::ifstream file(entry_path, std::ios::binary);
      file.seekg(0, std::ios::end);
      code.resize(file.tellg());
      {
        std::stringstream s;
        s << "loadCustomShaders(Reading " << code.size() << " from " << filename_string << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }
      if (!code.empty()) {
        file.seekg(0, std::ios::beg);
        file.read(reinterpret_cast<char*>(code.data()), code.size());
      }
    } else {
      std::stringstream s;
      s << "loadCustomShaders(Skipping file: ";
      s << entry_path.string();
      s << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      continue;
    }

    // These are never removed for now (e.g. if the user delete a custom shader file), it wouldn't be very useful
    if (!custom_shader_files.contains(shader_hash))
    {
      custom_shader_files.emplace(shader_hash);
    }

    auto pipelines_pair = pipeline_caches_by_shader_hash.find(shader_hash);
    if (pipelines_pair == pipeline_caches_by_shader_hash.end()) {
      std::stringstream s;
      s << "loadCustomShaders(Unknown hash: ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      continue;
    }

    // Re-clone all the pipelines that used this shader hash
    for (CachedPipeline* cached_pipeline : pipelines_pair->second) {
      if (is_hlsl) {
        cached_pipeline->hlsl_path = entry_path;
      } else {
        cached_pipeline->hlsl_path.clear();
      }
      cached_pipeline->compilation_error.clear();

      {
        std::stringstream s;
        s << "loadCustomShaders(Read ";
        s << code.size() << " bytes ";
        s << " from " << entry_path.string();
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

      // DX12 can use PSO objects that need to be cloned

      const uint32_t subobject_count = cached_pipeline->subobject_count;
      reshade::api::pipeline_subobject* subobjects = cached_pipeline->subobjects_cache;
      reshade::api::pipeline_subobject* new_subobjects = renodx::utils::pipeline::ClonePipelineSubObjects(subobject_count, subobjects);

      {
        std::stringstream s;
        s << "loadCustomShaders(Cloning pipeline ";
        s << reinterpret_cast<void*>(cached_pipeline->pipeline.handle);
        s << " with " << subobject_count << " object(s)";
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }
      reshade::log_message(reshade::log_level::debug, "Iterating pipeline...");

      for (uint32_t i = 0; i < subobject_count; ++i) {
  #ifdef DEBUG_LEVEL_2
        reshade::log_message(reshade::log_level::debug, "Checking subobject...");
  #endif
        const auto& subobject = subobjects[i];
        switch (subobject.type) {
          case reshade::api::pipeline_subobject_type::compute_shader:
            [[fallthrough]];
          case reshade::api::pipeline_subobject_type::pixel_shader:
            break;
          default:
            continue;
        }
  #if 0
        const reshade::api::shader_desc& desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);

        if (desc.code_size == 0) {
          reshade::log_message(reshade::log_level::warning, "Code size 0");
          continue;
        }

        reshade::log_message(reshade::log_level::debug, "Computing hash...");
        // Pipeline has a pixel shader with code. Hash code and check
        auto shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);
        if (hash != shader_hash) {
          reshade::log_message(reshade::log_level::warning, "");
          continue;
        }
  #endif

        auto& clone_subject = new_subobjects[i];

        auto* new_desc = static_cast<reshade::api::shader_desc*>(clone_subject.data);

        new_desc->code_size = code.size();
        new_desc->code = malloc(code.size());
        // TODO(clshortfuse): Workaround leak
        memcpy(const_cast<void*>(new_desc->code), code.data(), code.size());

        auto new_hash = compute_crc32(static_cast<const uint8_t*>(new_desc->code), new_desc->code_size);

        std::stringstream s;
        s << "loadCustomShaders(Injected pipeline data";
        s << " with " << PRINT_CRC32(new_hash);
        s << " (" << code.size() << " bytes)";
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

      {
        std::stringstream s;
        s << "Creating pipeline clone (";
        s << "hash: " << PRINT_CRC32(shader_hash);
        s << ", layout: " << reinterpret_cast<void*>(cached_pipeline->layout.handle);
        s << ", subobject_count: " << subobject_count;
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

      reshade::api::pipeline pipeline_clone;
      const bool built_pipeline_ok = cached_pipeline->device->create_pipeline(
          cached_pipeline->layout,
          subobject_count,
          new_subobjects,
          &pipeline_clone);
      std::stringstream s;
      s << "loadCustomShaders(cloned ";
      s << reinterpret_cast<void*>(cached_pipeline->pipeline.handle);
      s << " => " << reinterpret_cast<void*>(pipeline_clone.handle);
      s << ", layout: " << reinterpret_cast<void*>(cached_pipeline->layout.handle);
      s << ", size: " << subobject_count;
      s << ", " << (built_pipeline_ok ? "OK" : "FAILED!");
      s << ")";
      reshade::log_message(built_pipeline_ok ? reshade::log_level::info : reshade::log_level::error, s.str().c_str());

      if (built_pipeline_ok) {
        assert(!cached_pipeline->cloned && cached_pipeline->pipeline_clone.handle == 0);
        cached_pipeline->cloned = true;
        cached_pipeline->pipeline_clone = pipeline_clone;
        cloned_pipeline_count++;
        cloned_pipelines_changed = true;
      }
      // Clean up unused cloned subobjects
      else {
        DestroyPipelineSubojects(new_subobjects, subobject_count);
        new_subobjects = nullptr;
      }
    }
  }
}

std::optional<std::string> ReadTextFile(const std::filesystem::path& path) {
  std::vector<uint8_t> data;
  std::optional<std::string> result;
  std::ifstream file(path, std::ios::binary);
  file.seekg(0, std::ios::end);
  const size_t file_size = file.tellg();
  if (file_size == 0) return result;

  data.resize(file_size);
  file.seekg(0, std::ios::beg).read(reinterpret_cast<char*>(data.data()), file_size);
  result = std::string(reinterpret_cast<const char*>(data.data()), file_size);
  return result;
}

OVERLAPPED overlapped;
HANDLE m_target_dir_handle = INVALID_HANDLE_VALUE;

bool needs_watcher_init = true;

std::aligned_storage_t<1U << 18, std::max<size_t>(alignof(FILE_NOTIFY_EXTENDED_INFORMATION), alignof(FILE_NOTIFY_INFORMATION))> watch_buffer;

void CALLBACK HandleEventCallback(DWORD error_code, DWORD bytes_transferred, LPOVERLAPPED overlapped) {
  reshade::log_message(reshade::log_level::info, "Live callback.");
  LoadCustomShaders();
  ToggleLiveWatching();
}

void CheckForLiveUpdate() {
  if (auto_live_reload) {
    WaitForSingleObjectEx(overlapped.hEvent, 0, TRUE);
  }
}

void ToggleLiveWatching() {
  if (auto_live_reload) {
    auto directory = GetShaderPath();
    if (!std::filesystem::exists(directory)) {
      std::filesystem::create_directory(directory);
    }

    directory /= ".\\live";

    if (!std::filesystem::exists(directory)) {
      std::filesystem::create_directory(directory);
    }

    reshade::log_message(reshade::log_level::info, "Watching live.");

    // Clean up any previous handle for safety
    if (m_target_dir_handle != INVALID_HANDLE_VALUE) {
      CancelIoEx(m_target_dir_handle, &overlapped);
    }

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
      reshade::log_message(reshade::log_level::error, "ToggleLiveWatching(targetHandle: invalid)");
      return;
    }
    {
      std::stringstream s;
      s << "ToggleLiveWatching(targetHandle: ";
      s << reinterpret_cast<void*>(m_target_dir_handle);
      reshade::log_message(reshade::log_level::info, s.str().c_str());
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

    if (success == S_OK) {
      reshade::log_message(reshade::log_level::info, "ToggleLiveWatching(ReadDirectoryChangesExW: Listening.)");
    } else {
      std::stringstream s;
      s << "ToggleLiveWatching(ReadDirectoryChangesExW: Failed: ";
      s << GetLastError();
      s << ")";
      reshade::log_message(reshade::log_level::error, s.str().c_str());
    }

    LoadCustomShaders();
  } else {
    reshade::log_message(reshade::log_level::info, "Cancelling live.");
    CancelIoEx(m_target_dir_handle, &overlapped);
  }
}

void LogLayout(
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    const reshade::api::pipeline_layout layout) {
  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    auto param = params[param_index];
    switch (param.type) {
      case reshade::api::pipeline_layout_param_type::descriptor_table:
        for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
          auto range = param.descriptor_table.ranges[range_index];
          std::stringstream s;
          s << "logPipelineLayout(";
          s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
          s << " | TBL";
          s << " | " << reinterpret_cast<void*>(&param.descriptor_table.ranges);
          s << " | ";
          switch (range.type) {
            case reshade::api::descriptor_type::sampler:
              s << "SMP";
              break;
            case reshade::api::descriptor_type::sampler_with_resource_view:
              s << "SMPRV";
              break;
            case reshade::api::descriptor_type::texture_shader_resource_view:
              s << "TSRV";
              break;
            case reshade::api::descriptor_type::texture_unordered_access_view:
              s << "TUAV";
              break;
            case reshade::api::descriptor_type::constant_buffer:
              s << "CBV";
              break;
            case reshade::api::descriptor_type::shader_storage_buffer:
              s << "SSB";
              break;
            case reshade::api::descriptor_type::acceleration_structure:
              s << "ACC";
              break;
            default:
              s << "??? (0x" << std::hex << static_cast<uint32_t>(range.type) << std::dec << ")";
          }

          s << ", array_size: " << range.array_size;
          s << ", binding: " << range.binding;
          s << ", count: " << range.count;
          s << ", register: " << range.dx_register_index;
          s << ", space: " << range.dx_register_space;
          s << ", visibility: " << range.visibility;
          s << ")";
          s << " [" << range_index << "/" << param.descriptor_table.count << "]";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
        break;
      case reshade::api::pipeline_layout_param_type::push_constants: {
        std::stringstream s;
        s << "logPipelineLayout(";
        s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
        s << " | PC";
        s << ", binding: " << param.push_constants.binding;
        s << ", count " << param.push_constants.count;
        s << ", register: " << param.push_constants.dx_register_index;
        s << ", space: " << param.push_constants.dx_register_space;
        s << ", visibility " << param.push_constants.visibility;
        s << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
        break;
      }
      case reshade::api::pipeline_layout_param_type::push_descriptors: {
        std::stringstream s;
        s << "logPipelineLayout(";
        s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
        s << " | PD |";
        s << " array_size: " << param.push_descriptors.array_size;
        s << ", binding: " << param.push_descriptors.binding;
        s << ", count " << param.push_descriptors.count;
        s << ", register: " << param.push_descriptors.dx_register_index;
        s << ", space: " << param.push_descriptors.dx_register_space;
        s << ", type: " << param.push_descriptors.type;
        s << ", visibility " << param.push_descriptors.visibility;
        s << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
        break;
      }
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges: {
        std::stringstream s;
        s << "logPipelineLayout(";
        s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
        s << " | PDR?? | ";
        s << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
        break;
      }
#if RESHADE_API_VERSION >= 13
      case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
        for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
          auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
          std::stringstream s;
          s << "logPipelineLayout(";
          s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
          s << " | TBLSS";
          s << " | " << reinterpret_cast<void*>(&param.descriptor_table.ranges);
          s << " | ";
          if (range.static_samplers == nullptr) {
            s << " null ";
          } else {
            s << ", filter: " << static_cast<uint32_t>(range.static_samplers->filter);
            s << ", address_u: " << static_cast<uint32_t>(range.static_samplers->address_u);
            s << ", address_v: " << static_cast<uint32_t>(range.static_samplers->address_v);
            s << ", address_w: " << static_cast<uint32_t>(range.static_samplers->address_w);
            s << ", mip_lod_bias: " << static_cast<uint32_t>(range.static_samplers->mip_lod_bias);
            s << ", max_anisotropy: " << static_cast<uint32_t>(range.static_samplers->max_anisotropy);
            s << ", compare_op: " << static_cast<uint32_t>(range.static_samplers->compare_op);
            s << ", border_color: [" << range.static_samplers->border_color[0] << ", " << range.static_samplers->border_color[1] << ", " << range.static_samplers->border_color[2] << ", " << range.static_samplers->border_color[3] << "]";
            s << ", min_lod: " << range.static_samplers->min_lod;
            s << ", max_lod: " << range.static_samplers->max_lod;
          }
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
        break;
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
        for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
          auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
          std::stringstream s;
          s << "logPipelineLayout(";
          s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
          s << " | PDSS";
          s << " | " << reinterpret_cast<void*>(&range);
          s << " | ";
          if (range.static_samplers == nullptr) {
            s << "not";
          } else {
            s << "filter: " << static_cast<uint32_t>(range.static_samplers->filter);
            s << ", address_u: " << static_cast<uint32_t>(range.static_samplers->address_u);
            s << ", address_v: " << static_cast<uint32_t>(range.static_samplers->address_v);
            s << ", address_w: " << static_cast<uint32_t>(range.static_samplers->address_w);
            s << ", mip_lod_bias: " << static_cast<uint32_t>(range.static_samplers->mip_lod_bias);
            s << ", max_anisotropy: " << static_cast<uint32_t>(range.static_samplers->max_anisotropy);
            s << ", compare_op: " << static_cast<uint32_t>(range.static_samplers->compare_op);
            s << ", border_color: [" << range.static_samplers->border_color[0] << ", " << range.static_samplers->border_color[1] << ", " << range.static_samplers->border_color[2] << ", " << range.static_samplers->border_color[3] << "]";
            s << ", min_lod: " << range.static_samplers->min_lod;
            s << ", max_lod: " << range.static_samplers->max_lod;
          }
          s << ")";
          s << " [" << range_index << "/" << param.descriptor_table.count << "]";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
        break;
#endif
      default: {
        std::stringstream s;
        s << "logPipelineLayout(";
        s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
        s << " | ??? (0x" << std::hex << static_cast<uint32_t>(param.type) << std::dec << ")";
        s << " | " << param.type;
        s << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
    }
  }
}

void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "init_device(";
  s << reinterpret_cast<void*>(device);
  s << ", api: " << device->get_api();
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  auto& data = device->create_private_data<DeviceData>();
  data.device_api = device->get_api();
}

void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "destroy_device(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  const size_t back_buffer_count = swapchain->get_back_buffer_count();

  for (uint32_t index = 0; index < back_buffer_count; index++) {
    auto buffer = swapchain->get_back_buffer(index);

    std::stringstream s;
    s << "init_swapchain(";
    s << "buffer:" << reinterpret_cast<void*>(buffer.handle);
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  std::stringstream s;
  s << "init_swapchain";
  s << "(colorspace: " << swapchain->get_color_space();
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

bool OnCreatePipelineLayout(
    reshade::api::device* device,
    uint32_t& param_count,
    reshade::api::pipeline_layout_param*& params) {
  // noop
  return false;
}

// AfterCreateRootSignature
void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  LogLayout(param_count, params, layout);

  const bool found_visiblity = false;
  uint32_t cbv_index = 0;
  uint32_t pc_count = 0;

  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    auto param = params[param_index];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
        auto range = param.descriptor_table.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      pc_count++;
      if (cbv_index < param.push_constants.dx_register_index + param.push_constants.count) {
        cbv_index = param.push_constants.dx_register_index + param.push_constants.count;
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        if (cbv_index < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
          cbv_index = param.push_descriptors.dx_register_index + param.push_descriptors.count;
        }
      }
    }
  }

  const uint32_t max_count = 64u - (param_count + 1u) + 1u;

  std::stringstream s;
  s << "on_init_pipeline_layout++(";
  s << reinterpret_cast<void*>(layout.handle);
  s << " , max injections: " << (max_count);
  s << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

// After CreatePipelineState
void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  if (subobject_count == 0) {
    std::stringstream s;
    s << "on_init_pipeline(";
    s << reinterpret_cast<void*>(pipeline.handle);
    s << ", layout:" << reinterpret_cast<void*>(layout.handle);
    s << ", subobjects: " << (subobject_count);
    s << " )";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return;
  }

  reshade::api::pipeline_subobject* new_subobjects = renodx::utils::pipeline::ClonePipelineSubObjects(subobject_count, subobjects);

  auto* cached_pipeline = new CachedPipeline{
      pipeline,
      device,
      layout,
      new_subobjects,
      subobject_count};

  bool found_replaceable_shader = false;
  bool found_custom_shader_file = false;

  for (uint32_t i = 0; i < subobject_count; ++i) {
    const auto& subobject = subobjects[i];
    for (uint32_t j = 0; j < subobject.count; ++j) {
      std::stringstream s;
      s << "on_init_pipeline(";
      s << reinterpret_cast<void*>(pipeline.handle);
      s << "[" << i << "][" << j << "]";
      s << ", layout:" << reinterpret_cast<void*>(layout.handle);
      s << ", type: " << subobject.type;
      switch (subobject.type) {
        case reshade::api::pipeline_subobject_type::vertex_shader:
          [[fallthrough]];
        case reshade::api::pipeline_subobject_type::hull_shader:
          [[fallthrough]];
        case reshade::api::pipeline_subobject_type::domain_shader:
          [[fallthrough]];
        case reshade::api::pipeline_subobject_type::geometry_shader:
          // reshade::api::shader_desc &desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data[j]);
          break;
        case reshade::api::pipeline_subobject_type::blend_state:
          break;  // Disabled for now
          {
            auto& desc = static_cast<reshade::api::blend_desc*>(subobject.data)[j];
            s << ", alpha_to_coverage_enable: " << desc.alpha_to_coverage_enable;
            s << ", source_color_blend_factor: " << desc.source_color_blend_factor[0];
            s << ", dest_color_blend_factor: " << desc.dest_color_blend_factor[0];
            s << ", color_blend_op: " << desc.color_blend_op[0];
            s << ", source_alpha_blend_factor: " << desc.source_alpha_blend_factor[0];
            s << ", dest_alpha_blend_factor: " << desc.dest_alpha_blend_factor[0];
            s << ", alpha_blend_op: " << desc.alpha_blend_op[0];
            s << ", render_target_write_mask: " << std::hex << desc.render_target_write_mask[0] << std::dec;
          }
          break;
        case reshade::api::pipeline_subobject_type::compute_shader:
          [[fallthrough]];
        case reshade::api::pipeline_subobject_type::pixel_shader: {
          // reshade::api::shader_desc* desc = (static_cast<reshade::api::shader_desc*>(subobject.data))[j];
          auto* new_desc = static_cast<reshade::api::shader_desc*>(new_subobjects[i].data);
          if (new_desc->code_size == 0) break;
          auto shader_hash = compute_crc32(static_cast<const uint8_t*>(new_desc->code), new_desc->code_size);

          // Delete any previous shader with the same hash (unlikely to happen, but safer nonetheless)
          if (auto previous_shader_pair = shader_cache.find(shader_hash); previous_shader_pair != shader_cache.end() && previous_shader_pair->second != nullptr) {
            auto& previous_shader = previous_shader_pair->second;
            // Make sure that two shaders have the same hash, their code size also matches (theoretically we could check even more, but the chances hashes overlapping is extremely small)
            assert(previous_shader->size == new_desc->code_size);
            shader_cache_count--;
            shader_cache_size -= previous_shader->size;
            delete previous_shader->data;
            delete previous_shader;
          }

          // Cache shader
          auto* cache = new CachedShader{
              malloc(new_desc->code_size),
              new_desc->code_size,
              subobject.type};
          memcpy(cache->data, new_desc->code, cache->size);
          shader_cache_count++;
          shader_cache_size += cache->size;
          shader_cache[shader_hash] = cache;
          shaders_to_dump.emplace(shader_hash);

          // Indexes
          cached_pipeline->shader_hash = shader_hash;

          // Make sure we didn't already have a valid pipeline in there (this should never happen)
          auto pipelines_pair = pipeline_caches_by_shader_hash.find(shader_hash);
          if (pipelines_pair != pipeline_caches_by_shader_hash.end()) {
            pipelines_pair->second.emplace(cached_pipeline);
          } else {
            pipeline_caches_by_shader_hash[shader_hash] = { cached_pipeline };
          }
          found_replaceable_shader = true;
          found_custom_shader_file |= custom_shader_files.contains(shader_hash);

          // Metrics
          {
            std::stringstream s2;
            s2 << "caching shader(";
            s2 << "hash: " << PRINT_CRC32(shader_hash);
            s2 << ", type: " << subobject.type;
            s2 << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle);
            s2 << ")";
            reshade::log_message(reshade::log_level::info, s2.str().c_str());
          }
          break;
        }
        default:
          break;
      }

      s << " )";

      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }
  if (!found_replaceable_shader) {
    delete cached_pipeline;
    cached_pipeline = nullptr;
    DestroyPipelineSubojects(new_subobjects, subobject_count);
    new_subobjects = nullptr;
    return;
  }
  pipeline_cache_by_pipeline_handle[pipeline.handle] = cached_pipeline;

  // Automatically load any custom shaders that might have been bound to this pipeline.
  // To avoid this slowing down everything, we only do it if we detect the user already had a matching shader in its custom shaders folder.
  // Note that this will only load newly created (first used) shaders, but if the user had unloaded other shaders manually, they will stay unloaded.
  if (auto_live_reload && found_custom_shader_file) {
    // Immediately cloning and replacing the pipeline is unsafe, we need to delay it to the next frame.
    pipelines_to_reload.emplace(pipeline.handle);
#if 0 // Unsafe, this hangs the game (even if it seems like it should be safe given it doesn't do anything other than create a cloned pipeline without binding it yet).
    LoadCustomShaders(pipelines_to_reload);
    pipelines_to_reload.clear();
#endif
  }
}

void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  uint32_t changed = 0;
  changed |= compute_shader_layouts.erase(pipeline.handle);

  if (
      auto pipeline_cache_pair = pipeline_cache_by_pipeline_handle.find(pipeline.handle);
      pipeline_cache_pair != pipeline_cache_by_pipeline_handle.end()) {
    auto& cached_pipeline = pipeline_cache_pair->second;

    if (cached_pipeline != nullptr) {
      // Clean other references to the pipeline
      for (auto& pipelines_cache_pair : pipeline_caches_by_shader_hash) {
        auto& cached_pipelines = pipelines_cache_pair.second;
        cached_pipelines.erase(cached_pipeline);
      }

      // Destroy our cloned version of the pipeline (and leave the original intact)
      if (cached_pipeline->cloned) {
        cached_pipeline->cloned = false;
        cached_pipeline->device->destroy_pipeline(cached_pipeline->pipeline_clone);
        cached_pipeline->compilation_error.clear();
        cloned_pipeline_count--;
        cloned_pipelines_changed = true;
      }
      free(cached_pipeline);
      cached_pipeline = nullptr;
    }
    pipeline_cache_by_pipeline_handle.erase(pipeline.handle);
    changed++;
  }

  if (changed == 0) return;

  std::stringstream s;
  s << "on_destroy_pipeline(";
  s << reinterpret_cast<void*>(pipeline.handle);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

// AfterSetPipelineState
void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stages,
    reshade::api::pipeline pipeline) {
  if (trace_running) {
    switch (stages) {
      case reshade::api::pipeline_stage::pixel_shader:
      case reshade::api::pipeline_stage::compute_shader:
        break;
      default:
      case reshade::api::pipeline_stage::output_merger: {
        std::stringstream s;
        s << "bind_pipeline(" << reinterpret_cast<void*>(pipeline.handle);
        s << ", stages: " << stages << " (" << std::hex << static_cast<uint32_t>(stages) << std::dec << ")";
        s << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
        break;
      }
    }
  }
  const std::unique_lock<std::shared_mutex> lock(s_mutex);

  auto pair = pipeline_cache_by_pipeline_handle.find(pipeline.handle);
  if (pair == pipeline_cache_by_pipeline_handle.end() || pair->second == nullptr) return;

  auto* cached_pipeline = pair->second;

  if (cached_pipeline->test) {
    // This will make the shader output black, or skip drawing, so we can easily detect it. This might not be very safe but seems to work in DX11.
    // TODO: replace the pipeline with a shader that outputs all "SV_Target" as purple for more visiblity
    cmd_list->bind_pipeline(stages, reshade::api::pipeline{0});
  }
  else if (cached_pipeline->cloned) {
    if (trace_running) {
      std::stringstream s;
      s << "bind_pipeline(swapping pipeline " << reinterpret_cast<void*>(pipeline.handle);
      s << " => " << reinterpret_cast<void*>(cached_pipeline->pipeline_clone.handle);
      s << ", stages: " << stages << "(" << std::hex << static_cast<uint32_t>(stages) << ")";
      s << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }

    cmd_list->bind_pipeline(stages, cached_pipeline->pipeline_clone);
  }

  if (!trace_running) return;

  // const bool is_compute_shader = compute_shader_layouts.contains(cached_pipeline->layout.handle);

  bool add_pipeline_trace = true;
  if (list_unique) {
    auto trace_count = trace_shader_hashes.size();
    for (auto index = 0; index < trace_count; index++) {
      auto hash = trace_shader_hashes.at(index);
      if (hash == cached_pipeline->shader_hash) {
        trace_shader_hashes.erase(trace_shader_hashes.begin() + index);
        add_pipeline_trace = false;
        break;
      }
    }
  }

  // Pipelines are always "unique"
  if (add_pipeline_trace) {
    trace_pipeline_handles.push_back(cached_pipeline->pipeline.handle);
  }

  if (cached_pipeline->shader_hash != 0) {
    trace_shader_hashes.push_back(cached_pipeline->shader_hash);
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.shader = cached_pipeline->shader_hash;
  }

  std::stringstream s;
  s << "bind_pipeline(";
  s << trace_pipeline_handles.size() << ": ";
  s << reinterpret_cast<void*>(cached_pipeline->pipeline.handle);
  s << ", " << reinterpret_cast<void*>(cached_pipeline->layout.handle);
  s << ", stages: " << stages << " (" << std::hex << static_cast<uint32_t>(stages) << std::dec << ")";
  s << ", " << PRINT_CRC32(cached_pipeline->shader_hash);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

void OnBindPipelineStates(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::dynamic_state* states,
    const uint32_t* values) {
  if (!trace_running) return;

  for (uint32_t i = 0; i < count; i++) {
    std::stringstream s;
    s << "bind_pipeline_state";
    s << "(" << states[i];
    s << ", " << values[i];
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

void ResetInstructionState() {
  const size_t count = instructions.size();
  const InstructionState old_state = instructions.at(count - 1);
  instructions.resize(count + 1);
  InstructionState new_state = instructions.at(count);
  new_state.render_targets = old_state.render_targets;
  new_state.textures = old_state.textures;
  new_state.shader = old_state.shader;
}

bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  if (trace_running) {
    std::stringstream s;
    s << "on_draw";
    s << "(" << vertex_count;
    s << ", " << instance_count;
    s << ", " << first_vertex;
    s << ", " << first_instance;
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::draw;
    // resetInstructionState();
  }
  return false;
}

bool OnDispatch(reshade::api::command_list* cmd_list, uint32_t group_count_x, uint32_t group_count_y, uint32_t group_count_z) {
  if (trace_running) {
    std::stringstream s;
    s << "on_dispatch";
    s << "(" << group_count_x;
    s << ", " << group_count_y;
    s << ", " << group_count_z;
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::dispatch;
    // resetInstructionState();
  }
  return false;
}

bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  if (trace_running) {
    std::stringstream s;
    s << "on_draw_indexed";
    s << "(" << index_count;
    s << ", " << instance_count;
    s << ", " << first_index;
    s << ", " << vertex_offset;
    s << ", " << first_instance;
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::draw_indexed;
    // resetInstructionState();
  }
  return false;
}

bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride) {
  if (trace_running) {
    std::stringstream s;
    s << "on_draw_or_dispatch_indirect(" << type;
    s << ", " << reinterpret_cast<void*>(buffer.handle);
    s << ", " << offset;
    s << ", " << draw_count;
    s << ", " << stride;
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::draw_or_dispatch_indirect;
    // resetInstructionState();
  }
  return false;
}

bool OnCopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_texture_region";
  s << "(" << reinterpret_cast<void*>(source.handle);
  s << ", " << (source_subresource);
  s << ", " << reinterpret_cast<void*>(dest.handle);
  s << ", " << static_cast<uint32_t>(filter);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  return false;
}

bool OnCopyTextureToBuffer(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint64_t dest_offset,
    uint32_t row_length,
    uint32_t slice_height) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_texture_region(" << reinterpret_cast<void*>(source.handle);
  s << "[" << source_subresource << "]";
  if (source_box != nullptr) {
    s << "(" << source_box->top << ", " << source_box->left << ", " << source_box->front << ")";
  }
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << "[" << dest_offset << "]";
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  return false;
}

bool OnCopyBufferToTexture(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint64_t source_offset,
    uint32_t row_length,
    uint32_t slice_height,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_texture_region";
  s << "(" << reinterpret_cast<void*>(source.handle);
  s << "[" << source_offset << "]";
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << "[" << dest_subresource << "]";
  if (dest_box != nullptr) {
    s << "(" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")";
  }
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  return false;
}

bool OnResolveTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    int32_t dest_x,
    int32_t dest_y,
    int32_t dest_z,
    reshade::api::format format) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_resolve_texture_region";
  s << "(" << reinterpret_cast<void*>(source.handle);
  s << ": " << (source_subresource);
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << ": " << (dest_subresource);
  s << ", (" << dest_x << ", " << dest_y << ", " << dest_z << ") ";
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  return false;
}

bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_resource";
  s << "(" << reinterpret_cast<void*>(source.handle);
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  return false;
}

void OnBarrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  for (uint32_t i = 0; i < count; i++) {
    std::stringstream s;
    s << "on_barrier(" << reinterpret_cast<void*>(resources[i].handle);
    s << ", " << std::hex << static_cast<uint32_t>(old_states[i]) << std::dec << " (" << old_states[i] << ")";
    s << " => " << std::hex << static_cast<uint32_t>(new_states[i]) << std::dec << " (" << new_states[i] << ")";
    s << ") [" << i << "]";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (!trace_running) return;

  if (count != 0) {
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.renderTargets.clear();
    auto* device = cmd_list->get_device();
    auto& data = device->get_private_data<DeviceData>();
    const std::shared_lock lock(data.mutex);
    for (uint32_t i = 0; i < count; i++) {
      auto rtv = rtvs[i];
      // if (rtv.handle) {
      //   state.renderTargets.push_back(rtv.handle);
      // }
      std::stringstream s;
      s << "on_bind_render_targets(";
      s << reinterpret_cast<void*>(rtv.handle);
      s << ", res: " << reinterpret_cast<void*>(GetResourceByViewHandle(data, rtv.handle));
      s << ", name: " << GetResourceNameByViewHandle(data, rtv.handle);
      s << ")";
      s << "[" << i << "]";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }
  if (dsv.handle != 0) {
    std::stringstream s;
    s << "on_bind_depth_stencil(";
    s << reinterpret_cast<void*>(dsv.handle);
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resources.emplace(resource.handle);

  if (!force_all && !trace_running && present_count >= MAX_PRESENT_COUNT) return;

  bool warn = false;
  std::stringstream s;
  s << "init_resource(" << reinterpret_cast<void*>(resource.handle);
  s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", state: " << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
  s << ", type: " << desc.type;
  s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;

  switch (desc.type) {
    case reshade::api::resource_type::buffer:
      s << ", size: " << desc.buffer.size;
      s << ", stride: " << desc.buffer.stride;
      if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
      break;
    case reshade::api::resource_type::texture_1d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::surface:
      s << ", width: " << desc.texture.width;
      s << ", height: " << desc.texture.height;
      s << ", levels: " << desc.texture.levels;
      s << ", format: " << desc.texture.format;
      if (desc.texture.format == reshade::api::format::unknown) {
        warn = true;
      }
      break;
    default:
    case reshade::api::resource_type::unknown:
      break;
  }

  s << ")";
  reshade::log_message(
      warn
          ? reshade::log_level::warning
          : reshade::log_level::info,
      s.str().c_str());
}

void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resources.erase(resource.handle);
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;

  std::stringstream s;
  s << "on_destroy_resource(";
  s << reinterpret_cast<void*>(resource.handle);
  s << ")";
  reshade::log_message(reshade::log_level::debug, s.str().c_str());
}

void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  if (data.resource_views.contains(view.handle)) {
    if (trace_running || present_count < MAX_PRESENT_COUNT) {
      std::stringstream s;
      s << "init_resource_view(reused view: ";
      s << reinterpret_cast<void*>(view.handle);
      s << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
    if (resource.handle == 0) {
      data.resource_views.erase(view.handle);
      return;
    }
  }
  if (resource.handle != 0) {
    data.resource_views.emplace(view.handle, resource.handle);
  }

  if (!force_all && !trace_running && present_count >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "init_resource_view(" << reinterpret_cast<void*>(view.handle);
  s << ", view type: " << desc.type << " (0x" << std::hex << static_cast<uint32_t>(desc.type) << std::dec << ")";
  s << ", view format: " << desc.format << " (0x" << std::hex << static_cast<uint32_t>(desc.format) << std::dec << ")";
  s << ", resource: " << reinterpret_cast<void*>(resource.handle);
  s << ", resource usage: " << usage_type << " 0x" << std::hex << static_cast<uint32_t>(usage_type) << std::dec;
  // if (desc.type == reshade::api::resource_view_type::buffer) return;
  if (resource.handle != 0) {
    const auto resource_desc = device->get_resource_desc(resource);
    s << ", resource type: " << resource_desc.type;

    switch (resource_desc.type) {
      default:
      case reshade::api::resource_type::unknown:
        break;
      case reshade::api::resource_type::buffer:
        // if (!traceRunning) return;
        return;
        s << ", buffer offset: " << desc.buffer.offset;
        s << ", buffer size: " << desc.buffer.size;
        break;
      case reshade::api::resource_type::texture_1d:
      case reshade::api::resource_type::texture_2d:
      case reshade::api::resource_type::surface:
        s << ", texture format: " << resource_desc.texture.format;
        s << ", texture width: " << resource_desc.texture.width;
        s << ", texture height: " << resource_desc.texture.height;
        break;
      case reshade::api::resource_type::texture_3d:
        s << ", texture format: " << resource_desc.texture.format;
        s << ", texture width: " << resource_desc.texture.width;
        s << ", texture height: " << resource_desc.texture.height;
        s << ", texture depth: " << resource_desc.texture.depth_or_layers;
        break;
    }
  }
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  std::stringstream s;
  s << "on_destroy_resource_view(";
  s << reinterpret_cast<void*>(view.handle);
  s << ")";
  reshade::log_message(reshade::log_level::debug, s.str().c_str());

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resource_views.erase(view.handle);
}

void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  auto* device = cmd_list->get_device();
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  for (uint32_t i = 0; i < update.count; i++) {
    std::stringstream s;
    s << "push_descriptors(" << reinterpret_cast<void*>(layout.handle);
    s << "[" << layout_param << "]";
    s << "[" << update.binding + i << "]";
    s << ", type: " << update.type;

    auto log_heap = [=]() {
      std::stringstream s2;
      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(update.table, update.binding + i, 0, &heap, &base_offset);
      s2 << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
      return s2.str();
    };

    switch (update.type) {
      case reshade::api::descriptor_type::sampler: {
        s << log_heap();
        auto item = static_cast<const reshade::api::sampler*>(update.descriptors)[i];
        s << ", sampler: " << reinterpret_cast<void*>(item.handle);
        break;
      }
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        s << log_heap();
        auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i];
        s << ", sampler: " << reinterpret_cast<void*>(item.sampler.handle);
        s << ", rsv: " << reinterpret_cast<void*>(item.view.handle);
        s << ", res: " << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.view.handle));
        // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
        break;
      }
      case reshade::api::descriptor_type::buffer_shader_resource_view:

      case reshade::api::descriptor_type::shader_resource_view: {
        s << log_heap();
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", shaderrsv: " << reinterpret_cast<void*>(item.handle);
        s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
        // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        break;
      }
      case reshade::api::descriptor_type::buffer_unordered_access_view:

      case reshade::api::descriptor_type::unordered_access_view: {
        s << log_heap();
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", uav: " << reinterpret_cast<void*>(item.handle);
        s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
        // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        break;
      }
      case reshade::api::descriptor_type::acceleration_structure: {
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", accl: " << reinterpret_cast<void*>(item.handle);
        break;
      }
      case reshade::api::descriptor_type::constant_buffer: {
        auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
        s << ", buffer: " << reinterpret_cast<void*>(item.buffer.handle);
        s << ", size: " << item.size;
        s << ", offset: " << item.offset;
        break;
      }
      default:
        s << ", type: " << update.type;
        break;
    }

    s << ")";
    s << "[" << update.binding + i << " / " << update.count << "]";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  auto* device = cmd_list->get_device();
  for (uint32_t i = 0; i < count; ++i) {
    std::stringstream s;
    s << "bind_descriptor_table(" << reinterpret_cast<void*>(layout.handle);
    s << "[" << (first + i) << "]";
    s << ", stages: " << stages << "(" << std::hex << static_cast<uint32_t>(stages) << std::dec << ")";
    s << ", table: " << reinterpret_cast<void*>(tables[i].handle);
    uint32_t base_offset = 0;
    reshade::api::descriptor_heap heap = {0};
    device->get_descriptor_heap_offset(tables[i], 0, 0, &heap, &base_offset);
    s << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";

    auto& descriptor_data = device->get_private_data<renodx::utils::descriptor::DeviceData>();
    const std::shared_lock decriptor_lock(descriptor_data.mutex);
    for (uint32_t j = 0; j < 13; ++j) {
      auto origin_primary_key = std::pair<uint64_t, uint32_t>(tables[i].handle, j);
      if (auto pair = descriptor_data.table_descriptor_resource_views.find(origin_primary_key);
          pair != descriptor_data.table_descriptor_resource_views.end()) {
        auto update = pair->second;
        auto view = renodx::utils::descriptor::GetResourceViewFromDescriptorUpdate(update);
        if (view.handle != 0) {
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", rsv[" << j << "]: " << reinterpret_cast<void*>(view.handle);
          s << ", res[" << j << "]: " << reinterpret_cast<void*>(GetResourceByViewHandle(data, view.handle));
        }
      }
    }

    s << ") [" << i << "]";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;

  for (uint32_t i = 0; i < count; i++) {
    const auto& copy = copies[i];

    for (uint32_t j = 0; j < copy.count; j++) {
      std::stringstream s;
      s << "copy_descriptor_tables(";
      s << reinterpret_cast<void*>(copy.source_table.handle);
      s << "[" << copy.source_binding + j << "]";
      s << " => ";
      s << reinterpret_cast<void*>(copy.dest_table.handle);
      s << "[" << copy.dest_binding + j << "]";

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(
          copy.source_table, copy.source_binding + j, copy.source_array_offset, &heap, &base_offset);
      s << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
      device->get_descriptor_heap_offset(
          copy.dest_table, copy.dest_binding + j, copy.dest_array_offset, &heap, &base_offset);
      s << " => " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";

      auto& descriptor_data = device->get_private_data<renodx::utils::descriptor::DeviceData>();
      const std::shared_lock decriptor_lock(descriptor_data.mutex);
      auto origin_primary_key = std::pair<uint64_t, uint32_t>(copy.source_table.handle, copy.source_binding + j);
      if (auto pair = descriptor_data.table_descriptor_resource_views.find(origin_primary_key);
          pair != descriptor_data.table_descriptor_resource_views.end()) {
        auto update = pair->second;
        auto view = renodx::utils::descriptor::GetResourceViewFromDescriptorUpdate(update);
        if (view.handle != 0) {
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", rsv: " << reinterpret_cast<void*>(view.handle);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, view.handle));
        }
      }

      s << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }

  return false;
}

bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;

  for (uint32_t i = 0; i < count; i++) {
    const auto& update = updates[i];

    for (uint32_t j = 0; j < update.count; j++) {
      std::stringstream s;
      s << "update_descriptor_tables(";
      s << reinterpret_cast<void*>(update.table.handle);
      s << "[" << update.binding + j << "]";

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(update.table, update.binding + j, 0, &heap, &base_offset);
      s << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
      switch (update.type) {
        case reshade::api::descriptor_type::sampler: {
          auto item = static_cast<const reshade::api::sampler*>(update.descriptors)[j];
          s << ", sampler: " << reinterpret_cast<void*>(item.handle);
          break;
        }
        case reshade::api::descriptor_type::sampler_with_resource_view: {
          auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
          s << ", sampler: " << reinterpret_cast<void*>(item.sampler.handle);
          s << ", rsv: " << reinterpret_cast<void*>(item.view.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.view.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          break;
        }
        case reshade::api::descriptor_type::buffer_shader_resource_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", b-srv: " << reinterpret_cast<void*>(item.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          break;
        }
        case reshade::api::descriptor_type::buffer_unordered_access_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", b-uav: " << reinterpret_cast<void*>(item.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          break;
        }
        case reshade::api::descriptor_type::shader_resource_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", srv: " << reinterpret_cast<void*>(item.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          break;
        }
        case reshade::api::descriptor_type::unordered_access_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", uav: " << reinterpret_cast<void*>(item.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res: " << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          break;
        }
        case reshade::api::descriptor_type::constant_buffer: {
          auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[j];
          s << ", buffer: " << reinterpret_cast<void*>(item.buffer.handle);
          s << ", size: " << item.size;
          s << ", offset: " << item.offset;
          break;
        }
        case reshade::api::descriptor_type::shader_storage_buffer: {
          auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[j];
          s << ", buffer: " << reinterpret_cast<void*>(item.buffer.handle);
          s << ", size: " << item.size;
          s << ", offset: " << item.offset;
          break;
        }
        case reshade::api::descriptor_type::acceleration_structure:
          s << ", accl: unknown";
          break;
        default:
          break;
      }
      s << ") [" << i << "]";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }
  return false;
}

bool OnClearRenderTargetView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_clear_render_target_view(";
  s << reinterpret_cast<void*>(rtv.handle);
  s << ")";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
  return false;
}

bool OnClearUnorderedAccessViewUint(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const uint32_t values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_clear_unordered_access_view_uint(";
  s << reinterpret_cast<void*>(uav.handle);
  s << ")";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
  return false;
}

void OnPushConstants(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    uint32_t first,
    uint32_t count,
    const void* values) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "push_constants(" << reinterpret_cast<void*>(layout.handle);
  s << "[" << layout_param << "]";
  s << ", stage: " << std::hex << static_cast<uint32_t>(stages) << std::dec << " (" << stages << ")";
  s << ", count: " << count;
  s << "{ 0x";
  for (uint32_t i = 0; i < count; i++) {
    s << std::hex << static_cast<const uint32_t*>(values)[i] << std::dec << ", ";
  }
  s << " })";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

void OnMapBufferRegion(
    reshade::api::device* device,
    reshade::api::resource resource,
    uint64_t offset,
    uint64_t size,
    reshade::api::map_access access,
    void** data) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "map_buffer_region(";
  s << reinterpret_cast<void*>(resource.handle);
  s << ")";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

void OnMapTextureRegion(
    reshade::api::device* device,
    reshade::api::resource resource,
    uint32_t subresource,
    const reshade::api::subresource_box* box,
    reshade::api::map_access access,
    reshade::api::subresource_data* data) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "map_texture_region(";
  s << reinterpret_cast<void*>(resource.handle);
  s << "[" << subresource << "]";
  s << ")";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

void OnReshadePresent(reshade::api::effect_runtime* runtime) {
  if (trace_running) {
    reshade::log_message(reshade::log_level::info, "present()");
    reshade::log_message(reshade::log_level::info, "--- End Frame ---");
    trace_count = trace_pipeline_handles.size();
    trace_running = false;
  } else if (trace_scheduled) {
    trace_scheduled = false;
    trace_shader_hashes.clear();
    trace_pipeline_handles.clear();
    // instructions.clear();
    // resetInstructionState();
    trace_running = true;
    reshade::log_message(reshade::log_level::info, "--- Frame ---");
  }
  if (present_count <= MAX_PRESENT_COUNT) {
    present_count++;
  }

  // Dump new shaders here so it's more thread safe
  if (auto_dump) {
    for (auto shader_to_dump : shaders_to_dump) {
      if (!dumped_shaders.contains(shader_to_dump)) {
        DumpShader(shader_to_dump, true);
      }
    }
    shaders_to_dump.clear();
  }

  // Load new shaders here so it's more thread safe
  if (auto_live_reload && !pipelines_to_reload.empty()) {
    LoadCustomShaders(pipelines_to_reload);
  }
  pipelines_to_reload.clear();

  // Destroy the cloned pipelines in the following frame to avoid crashes
  for (auto pair : pipelines_to_destroy) {
    pair.second->destroy_pipeline(reshade::api::pipeline{pair.first});
  }
  pipelines_to_destroy.clear();

  if (needs_unload_shaders) {
    UnloadCustomShaders();
    needs_unload_shaders = false;
  }
  if (needs_load_shaders) {
    LoadCustomShaders();
    needs_load_shaders = false;
  }

  if (needs_auto_load_update) {
    ToggleLiveWatching();
    needs_auto_load_update = false;
  }
  CheckForLiveUpdate();
}

void DumpShader(uint32_t shader_hash, bool auto_detect_type = true) {
  auto dump_path = GetShaderPath();

  if (!std::filesystem::exists(dump_path)) {
    std::filesystem::create_directory(dump_path);
  }
  dump_path /= ".\\dump";
  if (!std::filesystem::exists(dump_path)) {
    std::filesystem::create_directory(dump_path);
  }

  wchar_t hash_string[11];
  swprintf_s(hash_string, L"0x%08X", shader_hash);

  dump_path /= hash_string;

  auto* cached_shader = shader_cache.find(shader_hash)->second;

  // Automatically find the shader type and append it to the name (a bit hacky). This can make dumping relevantly slower.
  if (auto_detect_type) {
    if (cached_shader->disasm.empty()) {
      auto disasm_code = renodx::utils::shader::compiler::DisassembleShader(cached_shader->data, cached_shader->size);
      if (disasm_code.has_value()) {
        cached_shader->disasm.assign(disasm_code.value());
      } else {
        cached_shader->disasm.assign("DECOMPILATION FAILED");
      }
    }

    // TODO: implement vertex and compute shaders detection too
    if (cached_shader->type == reshade::api::pipeline_subobject_type::pixel_shader) {
      static const std::string template_pixel_shader_name = "ps_";
      static const std::string template_pixel_shader_full_name = template_pixel_shader_name  + "x_x";

      const auto type_index = cached_shader->disasm.find(template_pixel_shader_name);
      if (type_index != std::string::npos) {
        const std::string type = cached_shader->disasm.substr(type_index, template_pixel_shader_full_name.length());
        dump_path += "_";
        dump_path += type;
      }
    }
  }

  dump_path += L".cso";

  std::ofstream file(dump_path, std::ios::binary);

  file.write(static_cast<const char*>(cached_shader->data), cached_shader->size);

  if (!dumped_shaders.contains(shader_hash)) {
    dumped_shaders.emplace(shader_hash);
  }
}

// @see https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
void OnRegisterOverlay(reshade::api::effect_runtime* runtime) {
  if (ImGui::Button("Trace")) {
    trace_scheduled = true;
  }
  ImGui::SameLine();
  ImGui::Checkbox("List Unique Shaders Only", &list_unique);

  ImGui::SameLine();
  ImGui::PushID("##DumpShaders");
  if (ImGui::Button(std::format("Dump Shaders ({})", shader_cache_count).c_str())) {
    for (auto shader : shader_cache) {
      DumpShader(shader.first, true);
    }
    shaders_to_dump.clear();
  }
  ImGui::PopID();

  ImGui::SameLine();
  ImGui::PushID("##AutoDumpCheckBox");
  ImGui::Checkbox("Auto Dump", &auto_dump);
  ImGui::PopID();

  if (ImGui::Button(std::format("Unload Shaders ({})", cloned_pipeline_count).c_str())) {
    needs_unload_shaders = true;
  }
  ImGui::SameLine();
  if (ImGui::Button("Load Shaders")) {
    needs_unload_shaders = false;
    needs_load_shaders = true;
  }

  ImGui::SameLine();
  ImGui::PushID("##LiveReloadCheckBox");
  if (ImGui::Checkbox("Live Reload", &auto_live_reload)) {
    needs_auto_load_update = true;
  }
  ImGui::PopID();

  ImGui::Text("Cached Shaders Size: %d", shader_cache_size);
  static int32_t selected_index = -1;
  bool changed_selected = false;
  if (ImGui::BeginTabBar("##MyTabBar", ImGuiTabBarFlags_None)) {
    ImGui::PushID("##ShadersTab");
    auto handle_shader_tab = ImGui::BeginTabItem(std::format("Traced Shaders ({})", trace_count).c_str());
    ImGui::PopID();
    if (handle_shader_tab) {
      if (ImGui::BeginChild("HashList", ImVec2(100, -FLT_MIN), ImGuiChildFlags_ResizeX)) {
        if (ImGui::BeginListBox("##HashesListbox", ImVec2(-FLT_MIN, -FLT_MIN))) {
          if (!trace_running) {
            for (auto index = 0; index < trace_count; index++) {
              auto pipeline_handle = trace_pipeline_handles.at(index);
              const bool is_selected = (selected_index == index);
              const auto pipeline_pair = pipeline_cache_by_pipeline_handle.find(pipeline_handle);
              // Just pick the first pipeline associated to the shader here, they should all be the same as far as we are concerned
              const bool is_valid = pipeline_pair != pipeline_cache_by_pipeline_handle.end() && pipeline_pair->second != nullptr;
              std::stringstream name;
              auto text_color = IM_COL32(255, 255, 255, 255);

              if (is_valid) {
                const auto pipeline = pipeline_pair->second;

                name << std::setfill('0') << std::setw(3) << index << std::setw(0);
                name << " - " << PRINT_CRC32(pipeline->shader_hash);

                // Find if the shader has been modified
                if (pipeline->cloned) {
                  if (!pipeline->hlsl_path.empty()) {
                    name << "* - ";

                    // TODO: add support for more name variations
                    static const std::string full_template_name = "0x12345678.xx_x_x.hlsl";
                    static const auto characters_to_remove_from_end = full_template_name.length();
                    auto filename_string = pipeline->hlsl_path.filename().string();
                    filename_string.erase(filename_string.length() - min(characters_to_remove_from_end, filename_string.length()));
                    if (filename_string.ends_with("_"))
                    {
                      filename_string.erase(filename_string.length() - 1);
                    }
                    name << filename_string;
                  }
                  else {
                    name << "*";
                  }

                  text_color = IM_COL32(0, 255, 0, 255);
                }
                // Highlight loading error
                if (!pipeline->compilation_error.empty()) {
                  text_color = IM_COL32(255, 0, 0, 255);
                }
              } else {
                text_color = IM_COL32(255, 0, 0, 255);
                name << " - ERROR: CANNOT FIND PIPELINE";
              }

              ImGui::PushStyleColor(ImGuiCol_Text, text_color);
              if (ImGui::Selectable(name.str().c_str(), is_selected)) {
                selected_index = index;
                changed_selected = true;
              }
              ImGui::PopStyleColor();

              if (is_selected) {
                ImGui::SetItemDefaultFocus();
              }
            }
          }
          ImGui::EndListBox();
        }
        ImGui::EndChild();
      }

      ImGui::SameLine();
      if (ImGui::BeginChild("##ShaderDetails", ImVec2(0, 0))) {
        ImGui::BeginDisabled(selected_index == -1);
        if (ImGui::BeginTabBar("##ShadersCodeTab", ImGuiTabBarFlags_None)) {
          const bool open_disassembly_tab_item = ImGui::BeginTabItem("Disassembly");
          static bool opened_disassembly_tab_item = false;
          if (open_disassembly_tab_item) {
            static std::string disasm_string;
            if (selected_index >= 0 && trace_pipeline_handles.size() >= selected_index + 1 && (changed_selected || opened_disassembly_tab_item != open_disassembly_tab_item)) {
              const auto pipeline_handle = trace_pipeline_handles.at(selected_index);
              if (auto pipeline_pair = pipeline_cache_by_pipeline_handle.find(pipeline_handle); pipeline_pair != pipeline_cache_by_pipeline_handle.end() && pipeline_pair->second != nullptr) {
                auto* cache = shader_cache.contains(pipeline_pair->second->shader_hash) ? shader_cache[pipeline_pair->second->shader_hash] : nullptr;
                if (cache && cache->disasm.empty()) {
                  auto disasm_code = renodx::utils::shader::compiler::DisassembleShader(cache->data, cache->size);
                  if (disasm_code.has_value()) {
                    cache->disasm.assign(disasm_code.value());
                  } else {
                    cache->disasm.assign("DECOMPILATION FAILED");
                  }
                }
                disasm_string.assign(cache ? cache->disasm : "");
              }
            }

            if (ImGui::BeginChild("DisassemblyCode")) {
              ImGui::InputTextMultiline(
                  "##disassemblyCode",
                  const_cast<char*>(disasm_string.c_str()),
                  disasm_string.length(),
                  ImVec2(-FLT_MIN, -FLT_MIN),
                  ImGuiInputTextFlags_ReadOnly);
              ImGui::EndChild();  // DisassemblyCode
            }
            ImGui::EndTabItem();  // Disassembly
          }
          opened_disassembly_tab_item = open_disassembly_tab_item;

          ImGui::PushID("##LiveTabItem");
          const bool open_live_tab_item = ImGui::BeginTabItem("Live");
          ImGui::PopID();
          static bool opened_live_tab_item = false;
          if (open_live_tab_item) {
            static std::string hlsl_string;
            static bool hlsl_error = false;
            if (selected_index >= 0 && trace_pipeline_handles.size() >= selected_index + 1 && (changed_selected || opened_live_tab_item != open_live_tab_item || cloned_pipelines_changed)) {
              auto pipeline_handle = trace_pipeline_handles.at(selected_index);
              
              if (
                  auto pipeline_pair = pipeline_cache_by_pipeline_handle.find(pipeline_handle);
                  pipeline_pair != pipeline_cache_by_pipeline_handle.end() && pipeline_pair->second != nullptr) {

                const auto pipeline = pipeline_pair->second; 
                // If the custom shader has a compilation error, print that, otherwise read the file text
                if (!pipeline->compilation_error.empty()) {
                  hlsl_string = pipeline->compilation_error;
                  hlsl_error = true;
                } else if (!pipeline->hlsl_path.empty()) {
                  auto result = ReadTextFile(pipeline->hlsl_path);
                  if (result.has_value()) {
                    hlsl_string.assign(result.value());
                    hlsl_error = false;
                  } else {
                    hlsl_string.assign("FAILED TO READ FILE");
                    hlsl_error = true;
                  }
                } else {
                  hlsl_string.clear();
                  hlsl_error = false;
                }
              }
            }
            opened_live_tab_item = open_live_tab_item;

            // Attemping this breaks ImGui
            // if (ImGui::BeginChild("##LiveCodeToolbar", ImVec2(-FLT_MIN, 0))) {
            //   ImGui::EndChild();
            // }

            if (ImGui::BeginChild("LiveCode")) {
              ImGui::PushStyleColor(ImGuiCol_Text, hlsl_error ? IM_COL32(255, 0, 0, 255) : IM_COL32(255, 255, 255, 255));
              ImGui::InputTextMultiline(
                  "##liveCode",
                  const_cast<char*>(hlsl_string.c_str()),
                  hlsl_string.length(),
                  ImVec2(-FLT_MIN, -FLT_MIN));
              ImGui::PopStyleColor();
              ImGui::EndChild();
            }
            ImGui::EndTabItem();  // Live
          }
          
          ImGui::PushID("##SettingsTabItem");
          const bool open_settings_tab_item = ImGui::BeginTabItem("Settings");
          ImGui::PopID();
          if (open_settings_tab_item && selected_index >= 0 && trace_pipeline_handles.size() >= selected_index + 1) {
            auto pipeline_handle = trace_pipeline_handles.at(selected_index);
            if (auto pipeline_pair = pipeline_cache_by_pipeline_handle.find(pipeline_handle); pipeline_pair != pipeline_cache_by_pipeline_handle.end() && pipeline_pair->second != nullptr) {
              bool test_pipeline = pipeline_pair->second->test;  // Fall back on reading the first pipeline that uses this shader hash
              if (ImGui::BeginChild("Settings")) {
                ImGui::Checkbox("Test Shader (skips drawing, or draws black)", &test_pipeline);
                ImGui::EndChild();
              }
              pipeline_pair->second->test = test_pipeline;
            }

            ImGui::EndTabItem();  // Settings
          }

          ImGui::EndTabBar();  // ShadersCodeTab
        }
        ImGui::EndDisabled();
        ImGui::EndChild();  // ##ShaderDetails
      }
      ImGui::EndTabItem();  // Shaders
    }

#if 0  // TODO: implement
    if (ImGui::BeginTabItem("Events")) {
      ImGui::EndTabItem();
    }
    if (ImGui::BeginTabItem("Resources")) {
      ImGui::EndTabItem();
    }
#endif
    if (ImGui::BeginTabItem("Shader Defines")) {
      // TODO: make this dynamic with + and - buttons
      static std::string defines_titles[MAX_SHADER_DEFINES*2];
      static char defines_text[MAX_SHADER_DEFINES*2][50];

      for (int i = 0; i < (MAX_SHADER_DEFINES * 2) - 1; i += 2) {
        if (defines_titles[i].empty()) {
          defines_titles[i] = "Define " + std::to_string(i/2) + " Name";
          defines_titles[i+1] = "Define " + std::to_string(i/2) + " Value";
        }
        // ImGUI doesn't work with std::string data, it seems to need c style char arrays.
        ImGui::PushID(defines_titles[i].data());
        ImGui::InputTextWithHint("", defines_titles[i].data(), &defines_text[i][0], IM_ARRAYSIZE(defines_text[i]), ImGuiInputTextFlags_CharsNoBlank | ImGuiInputTextFlags_AlwaysOverwrite);
        ImGui::PopID();
        ImGui::SameLine();
        ImGui::PushID(defines_titles[i+1].data());
        ImGui::InputTextWithHint("", defines_titles[i+1].data(), &defines_text[i+1][0], IM_ARRAYSIZE(defines_text[i+1]), ImGuiInputTextFlags_CharsNoBlank | ImGuiInputTextFlags_AlwaysOverwrite);
        ImGui::PopID();
        shader_defines[i] = &defines_text[i][0];
        shader_defines[i+1] = &defines_text[i+1][0];
      }

      ImGui::EndTabItem();
    }

    ImGui::EndTabBar();
  }

  cloned_pipelines_changed = false;
}

void Init() {
  // Add all the shaders we have already dumped to the dumped list to avoid live re-dumping them
  auto dump_path = GetShaderPath();
  if (std::filesystem::exists(dump_path)) {
    dump_path /= ".\\dump";
    if (std::filesystem::exists(dump_path)) {
      for (const auto& entry : std::filesystem::directory_iterator(dump_path)) {
        if (!entry.is_regular_file()) continue;
        const auto& entry_path = entry.path();
        if (entry_path.extension() != ".cso") continue;
        const auto& entry_path_string = entry_path.filename().string();
        if (entry_path_string.starts_with("0x") && entry_path_string.length() > 2 + 8) {
          const std::string hash = entry_path_string.substr(2, 8);
          dumped_shaders.emplace(std::stoul(hash, nullptr, 16));
        }
      }
    }
  }

  // Pre-allocate shader defines
  shader_defines.assign(MAX_SHADER_DEFINES * 2, "");
}
}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX DevKit";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX DevKit Module";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::utils::descriptor::Use(fdw_reason);

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      reshade::register_event<reshade::addon_event::create_pipeline_layout>(OnCreatePipelineLayout);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);

      reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);

      reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);

      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::register_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
      reshade::register_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);

      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      reshade::register_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
      reshade::register_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
      reshade::register_event<reshade::addon_event::push_constants>(OnPushConstants);

      reshade::register_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
      reshade::register_event<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint);

      reshade::register_event<reshade::addon_event::map_buffer_region>(OnMapBufferRegion);
      reshade::register_event<reshade::addon_event::map_texture_region>(OnMapTextureRegion);

      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);

      reshade::register_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      reshade::register_event<reshade::addon_event::copy_texture_to_buffer>(OnCopyTextureToBuffer);
      reshade::register_event<reshade::addon_event::copy_buffer_to_texture>(OnCopyBufferToTexture);
      reshade::register_event<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);

      reshade::register_event<reshade::addon_event::copy_resource>(OnCopyResource);

      reshade::register_event<reshade::addon_event::barrier>(OnBarrier);

      reshade::register_event<reshade::addon_event::reshade_present>(OnReshadePresent);

      reshade::register_overlay("RenoDX (DevKit)", OnRegisterOverlay);

      Init();

      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::descriptor::Use(fdw_reason);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);

      reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);

      reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);

      reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);

      reshade::unregister_event<reshade::addon_event::reshade_present>(OnReshadePresent);

      reshade::unregister_overlay("RenoDX (DevKit)", OnRegisterOverlay);

      reshade::unregister_addon(h_module);
      break;
  }

  // ResourceWatcher::Use(fdwReason);

  return TRUE;
}
