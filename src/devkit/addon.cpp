/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#pragma comment(lib, "dxguid.lib")

#include <Windows.h>
#include <d3d11.h>
#include <d3d12.h>
#include <array>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <memory>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <crc32_hash.hpp>
#include "../utils/DescriptorTableUtil.hpp"
#include "../utils/format.hpp"
#include "../utils/pipelineUtil.hpp"
#include "../utils/shaderCompiler.hpp"

#define ICON_FK_REFRESH u8"\uf021"
#define ICON_FK_FLOPPY  u8"\uf0c7"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX DevKit";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX DevKit Module";

struct CachedPipeline {
  reshade::api::pipeline pipeline;
  reshade::api::device* device;
  reshade::api::pipeline_layout layout;
  reshade::api::pipeline_subobject* subobjectsCache;
  uint32_t subobjectCount;
  bool cloned;
  reshade::api::pipeline pipelineClone;
  std::filesystem::path hlslPath;
  uint32_t shaderHash;
};

struct InstructionState {
  reshade::addon_event action;
  std::vector<uint64_t> textures;
  std::vector<uint64_t> uavs;
  std::vector<uint64_t> renderTargets;
  uint32_t shader;
};

struct CachedShader {
  void* data = nullptr;
  size_t size = 0;
  int32_t index = -1;
  std::string disasm = "";
};

std::shared_mutex s_mutex;

struct __declspec(uuid("3b70b2b2-52dc-4637-bd45-c1171c4c322e")) device_data {
  // <resource.handle, resource_view.handle>
  std::unordered_map<uint64_t, uint64_t> resourceViews;
  // <resource.handle, vector<resource_view.handle>>
  std::unordered_map<uint64_t, std::vector<uint64_t>> resourceViewsByResource;
  std::unordered_map<uint64_t, std::string> resourceNames;
  std::unordered_set<uint64_t> resources;
  std::shared_mutex mutex;
  reshade::api::device_api device_api;
};

std::unordered_set<uint64_t> computeShaderLayouts;

std::unordered_map<uint64_t, CachedPipeline*> pipelineCacheByPipelineHandle;
std::unordered_map<uint64_t, reshade::api::device*> pipelinesToDestroy;
std::unordered_map<uint32_t, CachedPipeline*> pipelineCacheByShaderHash;
std::unordered_map<uint32_t, CachedShader*> shaderCache;

std::unordered_set<uint64_t> pipelineClones;

std::vector<uint32_t> traceHashes;
std::vector<InstructionState> instructions;

static bool traceScheduled = false;
static bool traceRunning = false;
static bool needsUnloadShaders = false;
static bool needsLoadShaders = false;
static bool needsAutoLoadUpdate = false;
static bool listUnique = false;
static bool autoLiveReload = false;
static uint32_t shaderCacheCount = 0;
static uint32_t shaderCacheSize = 0;
static uint32_t resourceCount = 0;
static uint32_t resourceViewCount = 0;
static uint32_t traceCount = 0;
static uint32_t presentCount = 0;

static const uint32_t MAX_PRESENT_COUNT = 60;
static bool forceAll = false;
static bool traceNames = false;

inline void GetD3DName(ID3D11DeviceChild* obj, std::string &name) {
  if (!obj) {
    return;
  }

  char c_name[128] = {};
  UINT size = sizeof(name);
  HRESULT hr = obj->GetPrivateData(WKPDID_D3DDebugObjectName, &size, c_name);
  if (hr == S_OK) {
    name = c_name;
  }
}

inline void GetD3DName(ID3D12Resource* obj, std::string &name) {
  if (!obj) {
    return;
  }

  char c_name[128] = {};
  UINT size = sizeof(name);
  HRESULT hr = obj->GetPrivateData(WKPDID_D3DDebugObjectName, &size, c_name);
  if (hr == S_OK) {
    name = c_name;
  }
}

static uint64_t getResourceByViewHandle(device_data &data, uint64_t handle) {
  if (
    auto pair = data.resourceViews.find(handle);
    pair != data.resourceViews.end()
  ) return pair->second;

  return 0;
}

static std::string getResourceNameByViewHandle(device_data &data, uint64_t handle) {
  if (!traceNames) return "?";
  auto resourceHandle = getResourceByViewHandle(data, handle);
  if (resourceHandle == 0) return "?";
  if (!data.resources.contains(resourceHandle)) return "?";

  if (
    auto pair = data.resourceNames.find(resourceHandle);
    pair != data.resourceNames.end()
  ) return pair->second;

  std::string name = "";
  if (data.device_api == reshade::api::device_api::d3d11) {
    ID3D11DeviceChild* nativeResource = reinterpret_cast<ID3D11DeviceChild*>(resourceHandle);
    GetD3DName(nativeResource, name);
  } else if (data.device_api == reshade::api::device_api::d3d12) {
    ID3D12Resource* nativeResource = reinterpret_cast<ID3D12Resource*>(resourceHandle);
    GetD3DName(nativeResource, name);
  } else {
    name = "?";
  }
  if (name.length()) {
    data.resourceNames[resourceHandle] = name;
  }
  return name;
}

std::filesystem::path getShaderPath() {
  wchar_t file_prefix[MAX_PATH] = L"";
  GetModuleFileNameW(nullptr, file_prefix, ARRAYSIZE(file_prefix));

  std::filesystem::path dump_path = file_prefix;
  dump_path = dump_path.parent_path();
  dump_path /= ".\\renodx-dev";
  return dump_path;
}

static void unloadCustomShaders() {
  for (auto pair : pipelineCacheByPipelineHandle) {
    auto cachedPipeline = pair.second;
    if (!cachedPipeline->cloned) continue;
    cachedPipeline->cloned = false;
    pipelinesToDestroy[cachedPipeline->pipelineClone.handle] = cachedPipeline->device;
  }
}

static void loadCustomShaders() {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  reshade::log_message(reshade::log_level::debug, "loadCustomShaders()");

  // Clear all shaders
  unloadCustomShaders();

  auto directory = getShaderPath();
  if (std::filesystem::exists(directory) == false) {
    std::filesystem::create_directory(directory);
  }

  directory /= ".\\live";

  if (std::filesystem::exists(directory) == false) {
    std::filesystem::create_directory(directory);
    return;
  }

  for (const auto &entry : std::filesystem::directory_iterator(directory)) {
    if (!entry.is_regular_file()) {
      reshade::log_message(reshade::log_level::warning, "loadCustomShaders(not a regular file)");
      continue;
    }
    auto entryPath = entry.path();
    if (!entryPath.has_extension()) {
      std::stringstream s;
      s << "loadCustomShaders(Missing extension: "
        << entryPath.string()
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      continue;
    }
    uint32_t shaderHash;
    size_t code_size = 0;
    uint8_t* code = nullptr;
    bool isHLSL = false;

    if (entryPath.extension().compare(".hlsl") == 0) {
      auto filename = entryPath.filename();
      auto filename_string = filename.string();
      auto length = filename_string.length();

      if (length < strlen("0x12345678.xx_x_x.hlsl")) continue;
      std::string shaderTarget = filename_string.substr(length - strlen("xx_x_x.hlsl"), strlen("xx_x_x"));
      if (shaderTarget[2] != '_') continue;
      if (shaderTarget[4] != '_') continue;
      uint32_t versionMajor = shaderTarget[3] - '0';
      std::string hashString = filename_string.substr(length - strlen("12345678.xx_x_x.hlsl"), 8);
      shaderHash = std::stoul(hashString, nullptr, 16);

      {
        std::stringstream s;
        s << "loadCustomShaders(Compiling file: "
          << entryPath.string()
          << ", hash: " << PRINT_CRC32(shaderHash)
          << ", target: " << shaderTarget
          << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

      ID3DBlob* outBlob = ShaderCompilerUtil::compileShaderFromFile(
        entryPath.c_str(),
        shaderTarget.c_str()
      );
      if (outBlob == nullptr) {
        std::stringstream s;
        s << "loadCustomShaders(Compilation failed: "
          << entryPath.string()
          << ")";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        continue;
      }
      code_size = outBlob->GetBufferSize();
      code = reinterpret_cast<uint8_t*>(malloc(code_size));  // Clone to release;
      memcpy(code, outBlob->GetBufferPointer(), code_size);
      outBlob->Release();

      isHLSL = true;
      {
        std::stringstream s;
        s << "loadCustomShaders(Shader built with size: " << code_size << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

    } else if (entryPath.extension().compare(".cso") == 0) {
      auto filename = entryPath.filename();
      auto filename_string = filename.string();
      if (filename_string.size() != 14) {
        std::stringstream s;
        s << "loadCustomShaders(Invalid cso file format: "
          << filename_string
          << ")";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        continue;
      }
      shaderHash = std::stoul(filename_string.substr(2, 8), nullptr, 16);
      std::ifstream file(entryPath, std::ios::binary);
      file.seekg(0, std::ios::end);
      code_size = file.tellg();
      {
        std::stringstream s;
        s << "loadCustomShaders(Reading " << code_size << " from " << filename_string << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }
      code = new uint8_t[code_size];
      file.seekg(0, std::ios::beg);
      file.read((char*)code, code_size);
    } else {
      std::stringstream s;
      s << "loadCustomShaders(Skipping file: "
        << entryPath.string()
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      continue;
    }

    auto pair = pipelineCacheByShaderHash.find(shaderHash);
    if (pair == pipelineCacheByShaderHash.end()) {
      std::stringstream s;
      s << "loadCustomShaders(Unknown hash: "
        << PRINT_CRC32(shaderHash)
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      if (code_size) {
        free(code);
      }
      continue;
    }
    CachedPipeline* cachedPipeline = pair->second;

    if (isHLSL) {
      cachedPipeline->hlslPath = entryPath;
    } else {
      cachedPipeline->hlslPath = "";
    }

    {
      std::stringstream s;
      s << "loadCustomShaders(Read "
        << code_size << " bytes "
        << " from " << entryPath.string()
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }

    // DX12 can use PSO objects that need to be cloned

    uint32_t subobjectCount = cachedPipeline->subobjectCount;
    reshade::api::pipeline_subobject* subobjects = cachedPipeline->subobjectsCache;
    reshade::api::pipeline_subobject* newSubobjects = PipelineUtil::clonePipelineSubObjects(subobjectCount, subobjects);

    {
      std::stringstream s;
      s << "loadCustomShaders(Cloning pipeline "
        << reinterpret_cast<void*>(cachedPipeline->pipeline.handle)
        << " with " << subobjectCount << " object(s)"
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
    reshade::log_message(reshade::log_level::debug, "Iterating pipeline...");

    bool needsClone = false;
    bool foundComputeShader = false;
    bool foundInjection = false;
    for (uint32_t i = 0; i < subobjectCount; ++i) {
#ifdef DEBUG_LEVEL_2
      reshade::log_message(reshade::log_level::debug, "Checking subobject...");
#endif
      const auto subobject = subobjects[i];
      switch (subobject.type) {
        case reshade::api::pipeline_subobject_type::compute_shader:
        case reshade::api::pipeline_subobject_type::pixel_shader:
          break;
        default:
          continue;
      }
      const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);

      // if (desc.code_size == 0) {
      //   reshade::log_message(reshade::log_level::warning, "Code size 0");
      //   continue;
      // }

      // reshade::log_message(reshade::log_level::debug, "Computing hash...");
      // Pipeline has a pixel shader with code. Hash code and check
      // auto shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);
      // if (hash != shader_hash) {
      //   reshade::log_message(reshade::log_level::warning, "");
      //   continue;
      // }

      auto cloneSubject = &newSubobjects[i];

      auto newDesc = static_cast<reshade::api::shader_desc*>(cloneSubject->data);

      newDesc->code = code;
      newDesc->code_size = code_size;

      auto new_hash = compute_crc32(static_cast<const uint8_t*>(newDesc->code), newDesc->code_size);

      std::stringstream s;
      s << "loadCustomShaders(Injected pipeline data"
        << " with " << PRINT_CRC32(new_hash)
        << " (" << code_size << " bytes)"
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }

    {
      std::stringstream s;
      s << "Creating pipeline clone ("
        << "hash: " << PRINT_CRC32(shaderHash)
        << ", layout: " << reinterpret_cast<void*>(cachedPipeline->layout.handle)
        << ", subobjectcount: " << subobjectCount
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }

    reshade::api::pipeline pipelineClone;
    bool builtPipelineOK = cachedPipeline->device->create_pipeline(
      cachedPipeline->layout,
      subobjectCount,
      newSubobjects,
      &pipelineClone
    );
    std::stringstream s;
    s << "loadCustomShaders(cloned "
      << reinterpret_cast<void*>(cachedPipeline->pipeline.handle)
      << " => " << reinterpret_cast<void*>(pipelineClone.handle)
      << ", layout: " << reinterpret_cast<void*>(cachedPipeline->layout.handle)
      << ", size: " << subobjectCount
      << ", " << (builtPipelineOK ? "OK" : "FAILED!")
      << ")";
    reshade::log_message(builtPipelineOK ? reshade::log_level::info : reshade::log_level::error, s.str().c_str());

    if (builtPipelineOK) {
      cachedPipeline->cloned = true;
      cachedPipeline->pipelineClone = pipelineClone;
    }
    // free(code);
  }
}

static char* readTextFile(std::filesystem::path path) {
  std::ifstream file(path, std::ios::binary);
  file.seekg(0, std::ios::end);
  size_t file_size = file.tellg();
  char* contents = reinterpret_cast<char*>(malloc((file_size + 1) * sizeof(char)));
  file.seekg(0, std::ios::beg).read(contents, file_size);
  contents[file_size] = NULL;
  return contents;
}

static OVERLAPPED overlapped;
static HANDLE mTargetDirHandle;

static bool needsWatcherInit = true;

static std::aligned_storage_t<1U << 18, std::max<size_t>(alignof(FILE_NOTIFY_EXTENDED_INFORMATION), alignof(FILE_NOTIFY_INFORMATION))> watchBuffer;

static void toggleLiveWatching();

static void CALLBACK handleEventCallback(DWORD errorCode, DWORD bytesTransferred, LPOVERLAPPED overlapped) {
  reshade::log_message(reshade::log_level::info, "Live callback.");
  loadCustomShaders();
  toggleLiveWatching();
}

static void checkForLiveUpdate() {
  if (autoLiveReload) {
    WaitForSingleObjectEx(overlapped.hEvent, 0, TRUE);
  }
}

static void toggleLiveWatching() {
  if (autoLiveReload) {
    auto directory = getShaderPath();
    if (std::filesystem::exists(directory) == false) {
      std::filesystem::create_directory(directory);
    }

    directory /= ".\\live";

    if (std::filesystem::exists(directory) == false) {
      std::filesystem::create_directory(directory);
    }

    reshade::log_message(reshade::log_level::info, "Watching live.");
    mTargetDirHandle = CreateFile(
      directory.c_str(),
      FILE_LIST_DIRECTORY,
      (FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE),
      NULL,
      OPEN_EXISTING,
      (FILE_FLAG_BACKUP_SEMANTICS | FILE_FLAG_OVERLAPPED),
      NULL
    );
    if (mTargetDirHandle == INVALID_HANDLE_VALUE) {
      reshade::log_message(reshade::log_level::error, "toggleLiveWatching(targetHandle: invalid)");
      return;
    }
    {
      std::stringstream s;
      s << "toggleLiveWatching(targetHandle: ";
      s << reinterpret_cast<void*>(mTargetDirHandle);
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }

    memset(&watchBuffer, 0, sizeof(watchBuffer));
    overlapped = {0};
    overlapped.hEvent = CreateEvent(NULL, TRUE, FALSE, NULL);

    BOOL success = ReadDirectoryChangesExW(
      mTargetDirHandle,
      &watchBuffer,
      sizeof(watchBuffer),
      TRUE,
      FILE_NOTIFY_CHANGE_FILE_NAME
        | FILE_NOTIFY_CHANGE_DIR_NAME
        | FILE_NOTIFY_CHANGE_ATTRIBUTES
        | FILE_NOTIFY_CHANGE_SIZE
        | FILE_NOTIFY_CHANGE_CREATION
        | FILE_NOTIFY_CHANGE_LAST_WRITE,
      NULL,
      &overlapped,
      &handleEventCallback,
      ReadDirectoryNotifyExtendedInformation
    );

    if (success) {
      reshade::log_message(reshade::log_level::info, "toggleLiveWatching(ReadDirectoryChangesExW: Listening.)");
    } else {
      std::stringstream s;
      s << "toggleLiveWatching(ReadDirectoryChangesExW: Failed: ";
      s << GetLastError();
      s << ")";
      reshade::log_message(reshade::log_level::error, s.str().c_str());
    }

    loadCustomShaders();
  } else {
    reshade::log_message(reshade::log_level::info, "Cancelling live.");
    CancelIoEx(mTargetDirHandle, &overlapped);
  }
}

static void logLayout(
  const uint32_t paramCount,
  const reshade::api::pipeline_layout_param* params,
  const reshade::api::pipeline_layout layout
) {
  for (uint32_t paramIndex = 0; paramIndex < paramCount; ++paramIndex) {
    auto param = params[paramIndex];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
        auto range = param.descriptor_table.ranges[rangeIndex];
        std::stringstream s;
        s << "logPipelineLayout("
          << reinterpret_cast<void*>(layout.handle) << "[" << paramIndex << "]"
          << " | TBL"
          << " | " << reinterpret_cast<void*>(&param.descriptor_table.ranges)
          << " | ";
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
            s << "??? (0x" << std::hex << (uint32_t)range.type << std::dec << ")";
        }

        s << ", array_size: " << range.array_size
          << ", binding: " << range.binding
          << ", count: " << range.count
          << ", register: " << range.dx_register_index
          << ", space: " << range.dx_register_space
          << ", visibility: " << to_string(range.visibility)
          << ")"
          << " [" << rangeIndex << "/" << param.descriptor_table.count << "]";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      std::stringstream s;
      s << "logPipelineLayout("
        << reinterpret_cast<void*>(layout.handle) << "[" << paramIndex << "]"
        << " | PC"
        << ", binding: " << param.push_constants.binding
        << ", count " << param.push_constants.count
        << ", register: " << param.push_constants.dx_register_index
        << ", space: " << param.push_constants.dx_register_space
        << ", visibility " << to_string(param.push_constants.visibility)
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      std::stringstream s;
      s << "logPipelineLayout("
        << reinterpret_cast<void*>(layout.handle) << "[" << paramIndex << "]"
        << " | PD |"
        << " array_size: " << param.push_descriptors.array_size
        << ", binding: " << param.push_descriptors.binding
        << ", count " << param.push_descriptors.count
        << ", register: " << param.push_descriptors.dx_register_index
        << ", space: " << param.push_descriptors.dx_register_space
        << ", type: " << to_string(param.push_descriptors.type)
        << ", visibility " << to_string(param.push_descriptors.visibility)
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges) {
      std::stringstream s;
      s << "logPipelineLayout("
        << reinterpret_cast<void*>(layout.handle) << "[" << paramIndex << "]"
        << " | PDR?? | "
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
#if RESHADE_API_VERSION >= 13
    } else if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers) {
      for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table_with_static_samplers.count; ++rangeIndex) {
        auto range = param.descriptor_table_with_static_samplers.ranges[rangeIndex];
        std::stringstream s;
        s << "logPipelineLayout("
          << reinterpret_cast<void*>(layout.handle) << "[" << paramIndex << "]"
          << " | TBLSS"
          << " | " << reinterpret_cast<void*>(&param.descriptor_table.ranges)
          << " | ";
        if (range.static_samplers == nullptr) {
          s << " null ";
        } else {
          s << ", filter: " << (uint32_t)range.static_samplers->filter;
          s << ", address_u: " << (uint32_t)range.static_samplers->address_u;
          s << ", address_v: " << (uint32_t)range.static_samplers->address_v;
          s << ", address_w: " << (uint32_t)range.static_samplers->address_w;
          s << ", mip_lod_bias: " << (uint32_t)range.static_samplers->mip_lod_bias;
          s << ", max_anisotropy: " << (uint32_t)range.static_samplers->max_anisotropy;
          s << ", compare_op: " << (uint32_t)range.static_samplers->compare_op;
          s << ", border_color: [" << range.static_samplers->border_color[0] << ", " << range.static_samplers->border_color[1] << ", " << range.static_samplers->border_color[2] << ", " << range.static_samplers->border_color[3] << "]";
          s << ", min_lod: " << range.static_samplers->min_lod;
          s << ", max_lod: " << range.static_samplers->max_lod;
        }
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers) {
      for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
        auto range = param.descriptor_table_with_static_samplers.ranges[rangeIndex];
        std::stringstream s;
        s << "logPipelineLayout("
          << reinterpret_cast<void*>(layout.handle) << "[" << paramIndex << "]"
          << " | PDSS"
          << " | " << reinterpret_cast<void*>(&range)
          << " | ";
        if (range.static_samplers == nullptr) {
          s << "not";
        } else {
          s << "filter: " << (uint32_t)range.static_samplers->filter
            << ", address_u: " << (uint32_t)range.static_samplers->address_u
            << ", address_v: " << (uint32_t)range.static_samplers->address_v
            << ", address_w: " << (uint32_t)range.static_samplers->address_w
            << ", mip_lod_bias: " << (uint32_t)range.static_samplers->mip_lod_bias
            << ", max_anisotropy: " << (uint32_t)range.static_samplers->max_anisotropy
            << ", compare_op: " << (uint32_t)range.static_samplers->compare_op
            << ", border_color: [" << range.static_samplers->border_color[0] << ", " << range.static_samplers->border_color[1] << ", " << range.static_samplers->border_color[2] << ", " << range.static_samplers->border_color[3] << "]"
            << ", min_lod: " << range.static_samplers->min_lod
            << ", max_lod: " << range.static_samplers->max_lod;
        }
        s << ")"
          << " [" << rangeIndex << "/" << param.descriptor_table.count << "]";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
#endif
    } else {
      std::stringstream s;
      s << "logPipelineLayout("
        << reinterpret_cast<void*>(layout.handle) << "[" << paramIndex << "]"
        << " | ??? (0x" << std::hex << (uint32_t)param.type << std::dec << ")"
        << " | " << to_string(param.type)
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }
}

static void on_init_device(reshade::api::device* device) {
  std::stringstream s;
  s << "init_device("
    << reinterpret_cast<void*>(device)
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  auto &data = device->create_private_data<device_data>();
  data.device_api = device->get_api();
}

static void on_destroy_device(reshade::api::device* device) {
  std::stringstream s;
  s << "destroy_device("
    << reinterpret_cast<void*>(device)
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  device->destroy_private_data<device_data>();
}

static void on_init_swapchain(reshade::api::swapchain* swapchain) {
  const size_t backBufferCount = swapchain->get_back_buffer_count();

  for (uint32_t index = 0; index < backBufferCount; index++) {
    auto buffer = swapchain->get_back_buffer(index);

    std::stringstream s;
    s << "init_swapchain("
      << "buffer:" << reinterpret_cast<void*>(buffer.handle)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  std::stringstream s;
  s << "init_swapchain"
    << "(colorspace: " << to_string(swapchain->get_color_space())
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

static bool on_create_pipeline_layout(
  reshade::api::device* device,
  uint32_t &param_count,
  reshade::api::pipeline_layout_param*&params
) {
  // noop
  return false;
}

// AfterCreateRootSignature
static void on_init_pipeline_layout(
  reshade::api::device* device,
  const uint32_t paramCount,
  const reshade::api::pipeline_layout_param* params,
  reshade::api::pipeline_layout layout
) {
  logLayout(paramCount, params, layout);

  bool foundVisiblity = false;
  uint32_t cbvIndex = 0;
  uint32_t pcCount = 0;

  for (uint32_t paramIndex = 0; paramIndex < paramCount; ++paramIndex) {
    auto param = params[paramIndex];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
        auto range = param.descriptor_table.ranges[rangeIndex];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (cbvIndex < range.dx_register_index + range.count) {
            cbvIndex = range.dx_register_index + range.count;
          }
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      pcCount++;
      if (cbvIndex < param.push_constants.dx_register_index + param.push_constants.count) {
        cbvIndex = param.push_constants.dx_register_index + param.push_constants.count;
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        if (cbvIndex < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
          cbvIndex = param.push_descriptors.dx_register_index + param.push_descriptors.count;
        }
      }
    }
  }

  uint32_t maxCount = 64u - (paramCount + 1u) + 1u;

  std::stringstream s;
  s << "on_init_pipeline_layout++("
    << reinterpret_cast<void*>(layout.handle)
    << " , max injections: " << (maxCount)
    << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

// After CreatePipelineState
static void on_init_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline_layout layout,
  uint32_t subobjectCount,
  const reshade::api::pipeline_subobject* subobjects,
  reshade::api::pipeline pipeline
) {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  if (!subobjectCount) {
    std::stringstream s;
    s << "on_init_pipeline("
      << reinterpret_cast<void*>(pipeline.handle)
      << ", layout:" << reinterpret_cast<void*>(layout.handle)
      << ", subobjects: " << (subobjectCount)
      << " )";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return;
  }

  reshade::api::pipeline_subobject* newSubobjects = PipelineUtil::clonePipelineSubObjects(subobjectCount, subobjects);

  CachedPipeline* cachedPipeline = new CachedPipeline{
    pipeline,
    device,
    layout,
    newSubobjects,
    subobjectCount
  };

  bool foundUsefulShader = false;

  for (uint32_t i = 0; i < subobjectCount; ++i) {
    const auto &subobject = subobjects[i];
    for (uint32_t j = 0; j < subobject.count; ++j) {
      std::stringstream s;
      s << "on_init_pipeline("
        << reinterpret_cast<void*>(pipeline.handle)
        << "[" << i << "][" << j << "]"
        << ", layout:" << reinterpret_cast<void*>(layout.handle)
        << ", type: " << to_string(subobject.type);
      switch (subobject.type) {
        case reshade::api::pipeline_subobject_type::vertex_shader:
        case reshade::api::pipeline_subobject_type::hull_shader:
        case reshade::api::pipeline_subobject_type::domain_shader:
        case reshade::api::pipeline_subobject_type::geometry_shader:
          // reshade::api::shader_desc &desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data[j]);
          break;
        case reshade::api::pipeline_subobject_type::blend_state:
          break;
          {
            auto &desc = static_cast<reshade::api::blend_desc*>(subobject.data)[j];
            s << ", alpha_to_coverage_enable: " << to_string(desc.alpha_to_coverage_enable)
              << ", source_color_blend_factor: " << to_string(desc.source_color_blend_factor[0])
              << ", dest_color_blend_factor: " << to_string(desc.dest_color_blend_factor[0])
              << ", color_blend_op: " << to_string(desc.color_blend_op[0])
              << ", source_alpha_blend_factor: " << to_string(desc.source_alpha_blend_factor[0])
              << ", dest_alpha_blend_factor: " << to_string(desc.dest_alpha_blend_factor[0])
              << ", alpha_blend_op: " << to_string(desc.alpha_blend_op[0])
              << ", render_target_write_mask: " << std::hex << desc.render_target_write_mask[0] << std::dec;
          }
          break;
        case reshade::api::pipeline_subobject_type::compute_shader:
        case reshade::api::pipeline_subobject_type::pixel_shader:
          {
            // reshade::api::shader_desc* desc = (static_cast<reshade::api::shader_desc*>(subobject.data))[j];
            auto newDesc = static_cast<reshade::api::shader_desc*>(newSubobjects[i].data);
            if (newDesc->code_size == 0) break;
            auto shader_hash = compute_crc32(static_cast<const uint8_t*>(newDesc->code), newDesc->code_size);

            // Cache shader
            CachedShader* cache = new CachedShader{
              malloc(newDesc->code_size),
              newDesc->code_size
            };
            memcpy(cache->data, newDesc->code, cache->size);
            shaderCacheCount++;
            shaderCacheSize += cache->size;
            shaderCache[shader_hash] = cache;

            // Indexes
            cachedPipeline->shaderHash = shader_hash;
            pipelineCacheByShaderHash[shader_hash] = cachedPipeline;

            // Metrics
            foundUsefulShader = true;
            {
              std::stringstream s2;
              s2 << "caching shader("
                 << "hash: " << PRINT_CRC32(shader_hash)
                 << ", type: " << to_string(subobject.type)
                 << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle)
                 << ")";
              reshade::log_message(reshade::log_level::info, s2.str().c_str());
            }
          }
          break;
      }

      s << " )";

      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }
  if (!foundUsefulShader) {
    free(newSubobjects);
    return;
  }
  pipelineCacheByPipelineHandle[pipeline.handle] = cachedPipeline;
}

static void on_destroy_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline pipeline
) {
  uint32_t changed = false;
  changed |= computeShaderLayouts.erase(pipeline.handle);

  if (
    auto pipelineCachePair = pipelineCacheByPipelineHandle.find(pipeline.handle);
    pipelineCachePair != pipelineCacheByPipelineHandle.end()
  ) {
    auto cachedPipeline = pipelineCachePair->second;
    if (cachedPipeline->cloned) {
      cachedPipeline->cloned = false;
      cachedPipeline->device->destroy_pipeline(cachedPipeline->pipelineClone);
    }
    free(pipelineCachePair->second);
    pipelineCacheByPipelineHandle.erase(pipeline.handle);
    changed = true;
  }

  if (!changed) return;

  std::stringstream s;
  s << "on_destroy_pipeline("
    << reinterpret_cast<void*>(pipeline.handle)
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

// AfterSetPipelineState
static void on_bind_pipeline(
  reshade::api::command_list* cmd_list,
  reshade::api::pipeline_stage stages,
  reshade::api::pipeline pipeline
) {
  if (traceRunning) {
    switch (stages) {
      case reshade::api::pipeline_stage::pixel_shader:
      case reshade::api::pipeline_stage::compute_shader:
        break;
      default:
      case reshade::api::pipeline_stage::output_merger:
        {
          std::stringstream s;
          s << "bind_pipeline("
            << reinterpret_cast<void*>(pipeline.handle)
            << ", stages: " << to_string(stages) << " (" << std::hex << (uint32_t)stages << std::dec << ")"
            << ")";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
        break;
    }
  }
  const std::unique_lock<std::shared_mutex> lock(s_mutex);

  auto pair = pipelineCacheByPipelineHandle.find(pipeline.handle);
  if (pair == pipelineCacheByPipelineHandle.end()) return;

  auto cachedPipeline = pair->second;

  if (cachedPipeline->cloned) {
    if (traceRunning) {
      std::stringstream s;
      s << "bind_pipeline(swapping pipeline "
        << reinterpret_cast<void*>(pipeline.handle)
        << " => " << reinterpret_cast<void*>(cachedPipeline->pipelineClone.handle)
        << ", stages: " << to_string(stages) << "(" << std::hex << (uint32_t)stages << ")"
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }

    cmd_list->bind_pipeline(stages, cachedPipeline->pipelineClone);
  }

  if (!traceRunning) return;

  bool isComputeShader = computeShaderLayouts.contains(cachedPipeline->layout.handle);

  if (listUnique) {
    auto traceCount = traceHashes.size();
    for (auto index = 0; index < traceCount; index++) {
      auto hash = traceHashes.at(index);
      if (hash == cachedPipeline->shaderHash) {
        traceHashes.erase(traceHashes.begin() + index);
        break;
      }
    }
  }
  if (cachedPipeline->shaderHash) {
    traceHashes.push_back(cachedPipeline->shaderHash);
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.shader = cachedPipeline->shaderHash;
  }

  std::stringstream s;
  s << "bind_pipeline("
    << traceHashes.size() << ": "
    << reinterpret_cast<void*>(cachedPipeline->pipeline.handle)
    << ", " << reinterpret_cast<void*>(cachedPipeline->layout.handle)
    << ", stages: " << to_string(stages) << " (" << std::hex << (uint32_t)stages << std::dec << ")"
    << ", " << PRINT_CRC32(cachedPipeline->shaderHash)
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

static void on_bind_pipeline_states(
  reshade::api::command_list* cmd_list,
  uint32_t count,
  const reshade::api::dynamic_state* states,
  const uint32_t* values
) {
  if (!traceRunning) return;

  for (uint32_t i = 0; i < count; i++) {
    std::stringstream s;
    s << "bind_pipeline_state"
      << "(" << to_string(states[i])
      << ", " << values[i]
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

static void resetInstructionState() {
  size_t count = instructions.size();
  InstructionState oldState = instructions.at(count - 1);
  instructions.resize(count + 1);
  InstructionState newState = instructions.at(count);
  newState.renderTargets = oldState.renderTargets;
  newState.textures = oldState.textures;
  newState.shader = oldState.shader;
}

static bool on_draw(
  reshade::api::command_list* cmd_list,
  uint32_t vertex_count,
  uint32_t instance_count,
  uint32_t first_vertex,
  uint32_t first_instance
) {
  if (traceRunning) {
    std::stringstream s;
    s << "on_draw"
      << "(" << vertex_count
      << ", " << instance_count
      << ", " << first_vertex
      << ", " << first_instance
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::draw;
    // resetInstructionState();
  }
  return false;
}

static bool on_dispatch(reshade::api::command_list* cmd_list, uint32_t group_count_x, uint32_t group_count_y, uint32_t group_count_z) {
  if (traceRunning) {
    std::stringstream s;
    s << "on_dispatch"
      << "(" << group_count_x
      << ", " << group_count_y
      << ", " << group_count_z
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::dispatch;
    // resetInstructionState();
  }
  return false;
}

static bool on_draw_indexed(
  reshade::api::command_list* cmd_list,
  uint32_t index_count,
  uint32_t instance_count,
  uint32_t first_index,
  int32_t vertex_offset,
  uint32_t first_instance
) {
  if (traceRunning) {
    std::stringstream s;
    s << "on_draw_indexed"
      << "(" << index_count
      << ", " << instance_count
      << ", " << first_index
      << ", " << vertex_offset
      << ", " << first_instance
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::draw_indexed;
    // resetInstructionState();
  }
  return false;
}

static bool on_draw_or_dispatch_indirect(
  reshade::api::command_list* cmd_list,
  reshade::api::indirect_command type,
  reshade::api::resource buffer,
  uint64_t offset,
  uint32_t draw_count,
  uint32_t stride
) {
  if (traceRunning) {
    std::stringstream s;
    s << "on_draw_or_dispatch_indirect"
      << "(" << to_string(type)
      << ", " << reinterpret_cast<void*>(buffer.handle)
      << ", " << offset
      << ", " << draw_count
      << ", " << stride
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::draw_or_dispatch_indirect;
    // resetInstructionState();
  }
  return false;
}

static bool on_copy_texture_region(
  reshade::api::command_list* cmd_list,
  reshade::api::resource source,
  uint32_t source_subresource,
  const reshade::api::subresource_box* source_box,
  reshade::api::resource dest,
  uint32_t dest_subresource,
  const reshade::api::subresource_box* dest_box,
  reshade::api::filter_mode filter
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_texture_region"
    << "(" << reinterpret_cast<void*>(source.handle)
    << ", " << (source_subresource)
    << ", " << reinterpret_cast<void*>(dest.handle)
    << ", " << (uint32_t)filter
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  return false;
}

static bool on_copy_texture_to_buffer(
  reshade::api::command_list* cmd_list,
  reshade::api::resource source,
  uint32_t source_subresource,
  const reshade::api::subresource_box* source_box,
  reshade::api::resource dest,
  uint64_t dest_offset,
  uint32_t row_length,
  uint32_t slice_height
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_texture_region"
    << "(" << reinterpret_cast<void*>(source.handle)
    << "[" << source_subresource << "]"
    << "(" << source_box->top << ", " << source_box->left << ", " << source_box->front << ")"
    << " => " << reinterpret_cast<void*>(dest.handle)
    << "[" << dest_offset << "]"
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  return false;
}

static bool on_copy_buffer_to_texture(
  reshade::api::command_list* cmd_list,
  reshade::api::resource source,
  uint64_t source_offset,
  uint32_t row_length,
  uint32_t slice_height,
  reshade::api::resource dest,
  uint32_t dest_subresource,
  const reshade::api::subresource_box* dest_box
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_texture_region"
    << "(" << reinterpret_cast<void*>(source.handle)
    << "[" << source_offset << "]"
    << " => " << reinterpret_cast<void*>(dest.handle)
    << "[" << dest_subresource << "]"
    << "(" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")"
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  return false;
}

static bool on_resolve_texture_region(
  reshade::api::command_list* cmd_list,
  reshade::api::resource source,
  uint32_t source_subresource,
  const reshade::api::subresource_box* source_box,
  reshade::api::resource dest,
  uint32_t dest_subresource,
  int32_t dest_x,
  int32_t dest_y,
  int32_t dest_z,
  reshade::api::format format
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_resolve_texture_region"
    << "(" << reinterpret_cast<void*>(source.handle)
    << ": " << (source_subresource)
    << " => " << reinterpret_cast<void*>(dest.handle)
    << ": " << (dest_subresource)
    << ", (" << dest_x << ", " << dest_y << ", " << dest_z << ") "
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  return false;
}

static bool on_copy_resource(
  reshade::api::command_list* cmd_list,
  reshade::api::resource source,
  reshade::api::resource dest
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_resource"
    << "(" << reinterpret_cast<void*>(source.handle)
    << " => " << reinterpret_cast<void*>(dest.handle)
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  return false;
}

static void on_barrier(
  reshade::api::command_list* cmd_list,
  uint32_t count,
  const reshade::api::resource* resources,
  const reshade::api::resource_usage* old_states,
  const reshade::api::resource_usage* new_states
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return;
  for (uint32_t i = 0; i < count; i++) {
    std::stringstream s;
    s << "on_barrier("
      << reinterpret_cast<void*>(resources[i].handle)
      << ", " << std::hex << (uint32_t)old_states[i] << std::dec << " (" << to_string(old_states[i]) << ")"
      << " => " << std::hex << (uint32_t)new_states[i] << std::dec << " (" << to_string(new_states[i]) << ")"
      << ")"
      << "[" << i << "]";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

static void on_bind_render_targets_and_depth_stencil(
  reshade::api::command_list* cmd_list,
  uint32_t count,
  const reshade::api::resource_view* rtvs,
  reshade::api::resource_view dsv
) {
  if (!traceRunning) return;

  if (count) {
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.renderTargets.clear();
    auto device = cmd_list->get_device();
    auto &data = device->get_private_data<device_data>();
    std::shared_lock lock(data.mutex);
    for (uint32_t i = 0; i < count; i++) {
      auto rtv = rtvs[i];
      // if (rtv.handle) {
      //   state.renderTargets.push_back(rtv.handle);
      // }
      std::stringstream s;
      s << "on_bind_render_targets("
        << reinterpret_cast<void*>(rtv.handle)
        << ", res: " << reinterpret_cast<void*>(getResourceByViewHandle(data, rtv.handle))
        << ", name: " << getResourceNameByViewHandle(data, rtv.handle)
        << ")"
        << "[" << i << "]";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }
  if (dsv.handle) {
    std::stringstream s;
    s << "on_bind_depth_stencil("
      << reinterpret_cast<void*>(dsv.handle)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

static void on_init_resource(
  reshade::api::device* device,
  const reshade::api::resource_desc &desc,
  const reshade::api::subresource_data* initial_data,
  reshade::api::resource_usage initial_state,
  reshade::api::resource resource
) {
  auto &data = device->get_private_data<device_data>();
  std::unique_lock lock(data.mutex);
  data.resources.emplace(resource.handle);

  if (!forceAll && !traceRunning && presentCount >= MAX_PRESENT_COUNT) return;

  bool warn = false;
  std::stringstream s;
  s << "init_resource(";
  s << reinterpret_cast<void*>(resource.handle);
  s << ", flags: " << std::hex << (uint32_t)desc.flags << std::dec
    << ", state: " << std::hex << (uint32_t)initial_state << std::dec
    << ", type: " << to_string(desc.type)
    << ", usage: " << std::hex << (uint32_t)desc.usage << std::dec;

  switch (desc.type) {
    case reshade::api::resource_type::buffer:
      s << ", size: " << desc.buffer.size;
      s << ", stride: " << desc.buffer.stride;
      if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return;
      break;
    case reshade::api::resource_type::texture_1d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::surface:
      s << ", width: " << desc.texture.width
        << ", height: " << desc.texture.height
        << ", levels: " << desc.texture.levels
        << ", format: " << to_string(desc.texture.format);
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
    s.str().c_str()
  );
}

static void on_destroy_resource(reshade::api::device* device, reshade::api::resource resource) {
  auto &data = device->get_private_data<device_data>();
  std::unique_lock lock(data.mutex);
  data.resources.erase(resource.handle);
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return;

  std::stringstream s;
  s << "on_destroy_resource("
    << reinterpret_cast<void*>(resource.handle)
    << ")";
  reshade::log_message(reshade::log_level::debug, s.str().c_str());
}

static void on_init_resource_view(
  reshade::api::device* device,
  reshade::api::resource resource,
  reshade::api::resource_usage usage_type,
  const reshade::api::resource_view_desc &desc,
  reshade::api::resource_view view
) {
  auto &data = device->get_private_data<device_data>();
  std::unique_lock lock(data.mutex);
  if (data.resourceViews.contains(view.handle)) {
    if (traceRunning || presentCount < MAX_PRESENT_COUNT) {
      std::stringstream s;
      s << "init_resource_view(reused view: "
        << reinterpret_cast<void*>(view.handle)
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
    if (!resource.handle) {
      data.resourceViews.erase(view.handle);
      return;
    }
  }
  if (resource.handle) {
    data.resourceViews.emplace(view.handle, resource.handle);
  }

  if (!forceAll && !traceRunning && presentCount >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "init_resource_view("
    << reinterpret_cast<void*>(view.handle)
    << ", view type: " << to_string(desc.type) << " (0x" << std::hex << (uint32_t)desc.type << std::dec << ")"
    << ", view format: " << to_string(desc.format) << " (0x" << std::hex << (uint32_t)desc.format << std::dec << ")"
    << ", resource: " << reinterpret_cast<void*>(resource.handle)
    << ", resource usage: " << to_string(usage_type) << " 0x" << std::hex << (uint32_t)usage_type << std::dec;
  // if (desc.type == reshade::api::resource_view_type::buffer) return;
  if (resource.handle) {
    const auto resourceDesc = device->get_resource_desc(resource);
    s << ", resource type: " << to_string(resourceDesc.type);

    switch (resourceDesc.type) {
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
        s << ", texture format: " << to_string(resourceDesc.texture.format);
        s << ", texture width: " << resourceDesc.texture.width;
        s << ", texture height: " << resourceDesc.texture.height;
        break;
      case reshade::api::resource_type::texture_3d:
        s << ", texture format: " << to_string(resourceDesc.texture.format);
        s << ", texture width: " << resourceDesc.texture.width;
        s << ", texture height: " << resourceDesc.texture.height;
        s << ", texture depth: " << resourceDesc.texture.depth_or_layers;
        break;
    }
  }
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

static void on_destroy_resource_view(reshade::api::device* device, reshade::api::resource_view view) {
  std::stringstream s;
  s << "on_destroy_resource_view("
    << reinterpret_cast<void*>(view.handle)
    << ")";
  reshade::log_message(reshade::log_level::debug, s.str().c_str());

  auto &data = device->get_private_data<device_data>();
  std::unique_lock lock(data.mutex);
  data.resourceViews.erase(view.handle);
}

static void on_push_descriptors(
  reshade::api::command_list* cmd_list,
  reshade::api::shader_stage stages,
  reshade::api::pipeline_layout layout,
  uint32_t layout_param,
  const reshade::api::descriptor_table_update &update
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return;
  auto device = cmd_list->get_device();
  auto &data = device->get_private_data<device_data>();
  std::shared_lock lock(data.mutex);
  for (uint32_t i = 0; i < update.count; i++) {
    std::stringstream s;
    s << "push_descriptors("
      << reinterpret_cast<void*>(layout.handle)
      << "[" << layout_param << "]"
      << "[" << update.binding + i << "]"
      << ", type: " << to_string(update.type);

    auto logHeap = [=]() {
      std::stringstream s2;
      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(update.table, update.binding + i, 0, &heap, &base_offset);
      s2 << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
      return s2.str();
    };

    switch (update.type) {
      case reshade::api::descriptor_type::sampler:
        {
          s << logHeap();
          auto item = static_cast<const reshade::api::sampler*>(update.descriptors)[i];
          s << ", sampler: " << reinterpret_cast<void*>(item.handle);
        }
        break;
      case reshade::api::descriptor_type::sampler_with_resource_view:
        {
          s << logHeap();
          auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i];
          s << ", sampler: " << reinterpret_cast<void*>(item.sampler.handle);
          s << ", rsv: " << reinterpret_cast<void*>(item.view.handle);
          s << ", res: " << reinterpret_cast<void*>(getResourceByViewHandle(data, item.view.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
        }
        break;
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::shader_resource_view:
        {
          s << logHeap();
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
          s << ", shaderrsv: " << reinterpret_cast<void*>(item.handle);
          s << ", res:" << reinterpret_cast<void*>(getResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        }
        break;
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::unordered_access_view:
        {
          s << logHeap();
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
          s << ", uav: " << reinterpret_cast<void*>(item.handle);
          s << ", res:" << reinterpret_cast<void*>(getResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        }
        break;
      case reshade::api::descriptor_type::acceleration_structure:
        {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
          s << ", accl: " << reinterpret_cast<void*>(item.handle);
        }
        break;
      case reshade::api::descriptor_type::constant_buffer:
        {
          auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
          s << ", buffer: " << reinterpret_cast<void*>(item.buffer.handle);
          s << ", size: " << item.size;
          s << ", offset: " << item.offset;
        }
        break;
      default:
        s << ", type: " << to_string(update.type);
        break;
    }

    s << ")";
    s << "[" << update.binding + i << " / " << update.count << "]";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

static void on_bind_descriptor_tables(
  reshade::api::command_list* cmd_list,
  reshade::api::shader_stage stages,
  reshade::api::pipeline_layout layout,
  uint32_t first,
  uint32_t count,
  const reshade::api::descriptor_table* tables
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return;
  auto device = cmd_list->get_device();
  for (uint32_t i = 0; i < count; ++i) {
    std::stringstream s;
    s << "bind_descriptor_table("
      << reinterpret_cast<void*>(layout.handle) << "[" << (first + i) << "]"
      << ", stages: " << to_string(stages) << "(" << std::hex << (uint32_t)stages << std::dec << ")"
      << ", table: " << reinterpret_cast<void*>(tables[i].handle);
    uint32_t base_offset = 0;
    reshade::api::descriptor_heap heap = {0};
    device->get_descriptor_heap_offset(tables[i], 0, 0, &heap, &base_offset);
    s << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";

    DescriptorTableUtil::DeviceData &descriptorData = device->get_private_data<DescriptorTableUtil::DeviceData>();
    std::shared_lock decriptorLock(descriptorData.mutex);
    for (uint32_t j = 0; j < 13; ++j) {
      auto originPrimaryKey = std::pair<uint64_t, uint32_t>(tables[i].handle, j);
      if (auto pair = descriptorData.tableDescriptorResourceViews.find(originPrimaryKey);
          pair != descriptorData.tableDescriptorResourceViews.end()) {
        auto update = pair->second;
        auto view = DescriptorTableUtil::getResourceViewFromDescriptorUpdate(update);
        if (view.handle) {
          auto &data = device->get_private_data<device_data>();
          std::shared_lock lock(data.mutex);
          s << ", rsv[" << j << "]: " << reinterpret_cast<void*>(view.handle);
          s << ", res[" << j << "]: " << reinterpret_cast<void*>(getResourceByViewHandle(data, view.handle));
        }
      }
    }

    s << ") [" << i << "]";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

static bool on_copy_descriptor_tables(
  reshade::api::device* device,
  uint32_t count,
  const reshade::api::descriptor_table_copy* copies
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return false;

  for (uint32_t i = 0; i < count; i++) {
    auto &copy = copies[i];

    for (uint32_t j = 0; j < copy.count; j++) {
      std::stringstream s;
      s << "copy_descriptor_tables("
        << reinterpret_cast<void*>(copy.source_table.handle)
        << "[" << copy.source_binding + j << "]"
        << " => "
        << reinterpret_cast<void*>(copy.dest_table.handle)
        << "[" << copy.dest_binding + j << "]";

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(copy.source_table, copy.source_binding + j, copy.source_array_offset, &heap, &base_offset);
      s << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
      device->get_descriptor_heap_offset(copy.dest_table, copy.dest_binding + j, copy.dest_array_offset, &heap, &base_offset);
      s << " => " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";

      DescriptorTableUtil::DeviceData &descriptorData = device->get_private_data<DescriptorTableUtil::DeviceData>();
      std::shared_lock decriptorLock(descriptorData.mutex);
      auto originPrimaryKey = std::pair<uint64_t, uint32_t>(copy.source_table.handle, copy.source_binding + j);
      if (auto pair = descriptorData.tableDescriptorResourceViews.find(originPrimaryKey);
          pair != descriptorData.tableDescriptorResourceViews.end()) {
        auto update = pair->second;
        auto view = DescriptorTableUtil::getResourceViewFromDescriptorUpdate(update);
        if (view.handle) {
          auto &data = device->get_private_data<device_data>();
          std::shared_lock lock(data.mutex);
          s << ", rsv: " << reinterpret_cast<void*>(view.handle);
          s << ", res:" << reinterpret_cast<void*>(getResourceByViewHandle(data, view.handle));
        }
      }

      s << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }

  return false;
}

static bool on_update_descriptor_tables(
  reshade::api::device* device,
  uint32_t count,
  const reshade::api::descriptor_table_update* updates
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return false;

  for (uint32_t i = 0; i < count; i++) {
    auto &update = updates[i];

    for (uint32_t j = 0; j < update.count; j++) {
      std::stringstream s;
      s << "update_descriptor_tables("
        << reinterpret_cast<void*>(update.table.handle)
        << "[" << update.binding + j << "]";

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(update.table, update.binding + j, 0, &heap, &base_offset);
      s << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
      switch (update.type) {
        case reshade::api::descriptor_type::sampler:
          {
            auto item = static_cast<const reshade::api::sampler*>(update.descriptors)[j];
            s << ", sampler: " << reinterpret_cast<void*>(item.handle);
          }
          break;
        case reshade::api::descriptor_type::sampler_with_resource_view:
          {
            auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
            s << ", sampler: " << reinterpret_cast<void*>(item.sampler.handle);
            s << ", rsv: " << reinterpret_cast<void*>(item.view.handle);
            auto &data = device->get_private_data<device_data>();
            std::shared_lock lock(data.mutex);
            s << ", res:" << reinterpret_cast<void*>(getResourceByViewHandle(data, item.view.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          }
          break;
        case reshade::api::descriptor_type::buffer_shader_resource_view:
          {
            auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
            s << ", b-srv: " << reinterpret_cast<void*>(item.handle);
            auto &data = device->get_private_data<device_data>();
            std::shared_lock lock(data.mutex);
            s << ", res:" << reinterpret_cast<void*>(getResourceByViewHandle(data, item.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          }
          break;
        case reshade::api::descriptor_type::buffer_unordered_access_view:
          {
            auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
            s << ", b-uav: " << reinterpret_cast<void*>(item.handle);
            auto &data = device->get_private_data<device_data>();
            std::shared_lock lock(data.mutex);
            s << ", res:" << reinterpret_cast<void*>(getResourceByViewHandle(data, item.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          }
          break;
        case reshade::api::descriptor_type::shader_resource_view:
          {
            auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
            s << ", srv: " << reinterpret_cast<void*>(item.handle);
            auto &data = device->get_private_data<device_data>();
            std::shared_lock lock(data.mutex);
            s << ", res:" << reinterpret_cast<void*>(getResourceByViewHandle(data, item.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          }
          break;
        case reshade::api::descriptor_type::unordered_access_view:
          {
            auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
            s << ", uav: " << reinterpret_cast<void*>(item.handle);
            auto &data = device->get_private_data<device_data>();
            std::shared_lock lock(data.mutex);
            s << ", res: " << reinterpret_cast<void*>(getResourceByViewHandle(data, item.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          }
          break;
        case reshade::api::descriptor_type::constant_buffer:
          {
            auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[j];
            s << ", buffer: " << reinterpret_cast<void*>(item.buffer.handle);
            s << ", size: " << item.size;
            s << ", offset: " << item.offset;
          }
          break;
        case reshade::api::descriptor_type::shader_storage_buffer:
          {
            auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[j];
            s << ", buffer: " << reinterpret_cast<void*>(item.buffer.handle);
            s << ", size: " << item.size;
            s << ", offset: " << item.offset;
          }
          break;
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

static bool on_clear_render_target_view(
  reshade::api::command_list* cmd_list,
  reshade::api::resource_view rtv,
  const float color[4],
  uint32_t rect_count,
  const reshade::api::rect* rects
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_clear_render_target_view("
    << reinterpret_cast<void*>(rtv.handle)
    << ")";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
  return false;
}

bool on_clear_unordered_access_view_uint(
  reshade::api::command_list* cmd_list,
  reshade::api::resource_view uav,
  const uint32_t values[4],
  uint32_t rect_count,
  const reshade::api::rect* rects
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_clear_unordered_access_view_uint("
    << reinterpret_cast<void*>(uav.handle)
    << ")";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
  return false;
}

void on_push_constants(
  reshade::api::command_list* cmd_list,
  reshade::api::shader_stage stages,
  reshade::api::pipeline_layout layout,
  uint32_t layout_param,
  uint32_t first,
  uint32_t count,
  const void* values
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "push_constants("
    << reinterpret_cast<void*>(layout.handle)
    << "[" << layout_param << "]"
    << ", stage: " << std::hex << (uint32_t)stages << std::dec << " (" << to_string(stages) << ")"
    << ", count: " << count
    << "{ 0x";
  for (uint32_t i = 0; i < count; i++) {
    s << std::hex << static_cast<const uint32_t*>(values)[i] << std::dec << ", ";
  }
  s << " })";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

void on_map_buffer_region(
  reshade::api::device* device,
  reshade::api::resource resource,
  uint64_t offset,
  uint64_t size,
  reshade::api::map_access access,
  void** data
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "map_buffer_region("
    << reinterpret_cast<void*>(resource.handle)
    << ")";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

void on_map_texture_region(
  reshade::api::device* device,
  reshade::api::resource resource,
  uint32_t subresource,
  const reshade::api::subresource_box* box,
  reshade::api::map_access access,
  reshade::api::subresource_data* data
) {
  if (!traceRunning && presentCount >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "map_texture_region("
    << reinterpret_cast<void*>(resource.handle)
    << "[" << subresource << "]"
    << ")";

  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

static void on_reshade_present(reshade::api::effect_runtime* runtime) {
  if (traceRunning) {
    reshade::log_message(reshade::log_level::info, "present()");
    reshade::log_message(reshade::log_level::info, "--- End Frame ---");
    traceCount = traceHashes.size();
    traceRunning = false;
  } else if (traceScheduled) {
    traceScheduled = false;
    traceHashes.clear();
    // instructions.clear();
    // resetInstructionState();
    traceRunning = true;
    reshade::log_message(reshade::log_level::info, "--- Frame ---");
  }
  if (presentCount <= MAX_PRESENT_COUNT) {
    presentCount++;
  }
  if (needsUnloadShaders) {
    unloadCustomShaders();
    needsUnloadShaders = false;
  } else {
    for (auto pair : pipelinesToDestroy) {
      pair.second->destroy_pipeline(reshade::api::pipeline{pair.first});
    }
    pipelinesToDestroy.clear();
  }
  if (needsLoadShaders) {
    loadCustomShaders();
    needsLoadShaders = false;
  }
  if (needsAutoLoadUpdate) {
    toggleLiveWatching();
    needsAutoLoadUpdate = false;
  }
  checkForLiveUpdate();
}

void dumpShader(uint32_t shader_hash) {
  auto dump_path = getShaderPath();

  if (std::filesystem::exists(dump_path) == false) {
    std::filesystem::create_directory(dump_path);
  }
  dump_path /= ".\\dump";
  if (std::filesystem::exists(dump_path) == false) {
    std::filesystem::create_directory(dump_path);
  }

  wchar_t hash_string[11];
  swprintf_s(hash_string, L"0x%08X", shader_hash);

  dump_path /= hash_string;
  dump_path += L".cso";

  auto cachedShader = shaderCache.find(shader_hash)->second;

  std::ofstream file(dump_path, std::ios::binary);

  file.write(static_cast<const char*>(cachedShader->data), cachedShader->size);
}

// @see https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
static void on_register_overlay(reshade::api::effect_runtime* runtime) {
  if (ImGui::Button("Trace")) {
    traceScheduled = true;
  }
  ImGui::SameLine();
  ImGui::Checkbox("List Unique Only", &listUnique);
  ImGui::SameLine();

  ImGui::PushID("##DumpShaders");
  if (ImGui::Button(std::format("Dump Shaders ({})", shaderCacheCount).c_str())) {
    for (auto shader : shaderCache) {
      dumpShader(shader.first);
    }
  }
  ImGui::PopID();

  if (ImGui::Button("Unload Shaders")) {
    needsUnloadShaders = true;
  }
  ImGui::SameLine();
  if (ImGui::Button("Load Shaders")) {
    needsLoadShaders = true;
  }

  ImGui::SameLine();
  ImGui::PushID("##LiveCheckBox");
  if (ImGui::Checkbox("Live", &autoLiveReload)) {
    needsAutoLoadUpdate = true;
  }
  ImGui::PopID();

  ImGui::Text("Cached Shaders Size: %d", shaderCacheSize);
  static int32_t selectedIndex = -1;
  bool changedSelected = false;
  if (ImGui::BeginTabBar("##MyTabBar", ImGuiTabBarFlags_None)) {
    ImGui::PushID("##ShadersTab");
    auto handleShaderTab = ImGui::BeginTabItem(std::format("Shaders ({})", traceCount).c_str());
    ImGui::PopID();
    if (handleShaderTab) {
      if (ImGui::BeginChild("HashList", ImVec2(100, -FLT_MIN), ImGuiChildFlags_ResizeX)) {
        if (ImGui::BeginListBox("##HashesListbox", ImVec2(-FLT_MIN, -FLT_MIN))) {
          if (!traceRunning) {
            for (auto index = 0; index < traceCount; index++) {
              auto hash = traceHashes.at(index);
              const bool isSelected = (selectedIndex == index);
              auto pair = pipelineCacheByShaderHash.find(hash);
              const bool isCloned = pair != pipelineCacheByShaderHash.end() && pair->second->cloned;
              std::stringstream name;
              name << std::setfill('0') << std::setw(3) << index << std::setw(0)
                   << " - " << PRINT_CRC32(hash);
              if (isCloned) {
                name << "*";
              }
              if (ImGui::Selectable(name.str().c_str(), isSelected)) {
                selectedIndex = index;
                changedSelected = true;
              }

              if (isSelected) {
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
        ImGui::BeginDisabled(selectedIndex == -1);
        if (ImGui::BeginTabBar("##ShadersCodeTab", ImGuiTabBarFlags_None)) {
          if (ImGui::BeginTabItem("Disassembly")) {
            static std::string disasmString = "";
            if (changedSelected) {
              auto hash = traceHashes.at(selectedIndex);
              auto cache = shaderCache.find(hash)->second;
              if (cache->disasm.length() == 0) {
                char* disasmCode = ShaderCompilerUtil::disassembleShader(cache->data, cache->size);
                if (disasmCode == nullptr) {
                  cache->disasm.assign("Decompilation failed.");
                } else {
                  cache->disasm.assign(disasmCode);
                  free(disasmCode);
                }
              }
              disasmString.assign(cache->disasm);
            }

            if (ImGui::BeginChild("DisassemblyCode")) {
              ImGui::InputTextMultiline(
                "##disassemblyCode",
                (char*)disasmString.c_str(),
                disasmString.length(),
                ImVec2(-FLT_MIN, -FLT_MIN),
                ImGuiInputTextFlags_ReadOnly
              );
              ImGui::EndChild();  // DisassemblyCode
            }
            ImGui::EndTabItem();  // Disassembly
          }

          ImGui::PushID("##LiveTabItem");
          bool openLiveTabItem = ImGui::BeginTabItem("Live");
          ImGui::PopID();
          if (openLiveTabItem) {
            static std::string hlslString = "";
            if (changedSelected) {
              auto hash = traceHashes.at(selectedIndex);

              if (
                auto pair = pipelineCacheByShaderHash.find(hash);
                pair != pipelineCacheByShaderHash.end() && !pair->second->hlslPath.empty()
              ) {
                hlslString.assign(readTextFile(pair->second->hlslPath));
              } else {
                hlslString.assign("");
              }
            }

            // Attemping this breaks ImGui
            // if (ImGui::BeginChild("##LiveCodeToolbar", ImVec2(-FLT_MIN, 0))) {
            //   ImGui::EndChild();
            // }

            if (ImGui::BeginChild("LiveCode")) {
              ImGui::InputTextMultiline(
                "##liveCode",
                (char*)hlslString.c_str(),
                hlslString.length(),
                ImVec2(-FLT_MIN, -FLT_MIN)
              );
              ImGui::EndChild();
            }
            ImGui::EndTabItem();  // Live
          }

          ImGui::EndTabBar();  // ShadersCodeTab
        }
        ImGui::EndDisabled();
        ImGui::EndChild();  // ##ShaderDetails
      }
      ImGui::EndTabItem();  // Shaders
    }

    if (ImGui::BeginTabItem("Events")) {
      ImGui::EndTabItem();
    }
    if (ImGui::BeginTabItem("Resources")) {
      ImGui::EndTabItem();
    }
    ImGui::EndTabBar();
  }
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

      DescriptorTableUtil::use(fdwReason);

      reshade::register_event<reshade::addon_event::init_device>(on_init_device);
      reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
      reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);

      reshade::register_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);

      reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

      reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline_states>(on_bind_pipeline_states);

      reshade::register_event<reshade::addon_event::init_resource>(on_init_resource);
      reshade::register_event<reshade::addon_event::destroy_resource>(on_destroy_resource);
      reshade::register_event<reshade::addon_event::init_resource_view>(on_init_resource_view);
      reshade::register_event<reshade::addon_event::destroy_resource_view>(on_destroy_resource_view);

      reshade::register_event<reshade::addon_event::push_descriptors>(on_push_descriptors);
      reshade::register_event<reshade::addon_event::bind_descriptor_tables>(on_bind_descriptor_tables);
      reshade::register_event<reshade::addon_event::copy_descriptor_tables>(on_copy_descriptor_tables);
      reshade::register_event<reshade::addon_event::update_descriptor_tables>(on_update_descriptor_tables);
      reshade::register_event<reshade::addon_event::push_constants>(on_push_constants);

      reshade::register_event<reshade::addon_event::clear_render_target_view>(on_clear_render_target_view);
      reshade::register_event<reshade::addon_event::clear_unordered_access_view_uint>(on_clear_unordered_access_view_uint);

      reshade::register_event<reshade::addon_event::map_buffer_region>(on_map_buffer_region);
      reshade::register_event<reshade::addon_event::map_texture_region>(on_map_texture_region);

      reshade::register_event<reshade::addon_event::draw>(on_draw);
      reshade::register_event<reshade::addon_event::dispatch>(on_dispatch);
      reshade::register_event<reshade::addon_event::draw_indexed>(on_draw_indexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(on_draw_or_dispatch_indirect);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(on_bind_render_targets_and_depth_stencil);

      reshade::register_event<reshade::addon_event::copy_texture_region>(on_copy_texture_region);
      reshade::register_event<reshade::addon_event::copy_texture_to_buffer>(on_copy_texture_to_buffer);
      reshade::register_event<reshade::addon_event::copy_buffer_to_texture>(on_copy_buffer_to_texture);
      reshade::register_event<reshade::addon_event::resolve_texture_region>(on_resolve_texture_region);

      reshade::register_event<reshade::addon_event::copy_resource>(on_copy_resource);

      reshade::register_event<reshade::addon_event::barrier>(on_barrier);

      reshade::register_event<reshade::addon_event::reshade_present>(on_reshade_present);

      reshade::register_overlay("RenoDX (DevKit)", on_register_overlay);

      break;
    case DLL_PROCESS_DETACH:
      DescriptorTableUtil::use(fdwReason);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);

      reshade::unregister_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

      reshade::unregister_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

      reshade::unregister_event<reshade::addon_event::copy_texture_region>(on_copy_texture_region);

      reshade::unregister_event<reshade::addon_event::reshade_present>(on_reshade_present);

      reshade::unregister_overlay("RenoDX (DevKit)", on_register_overlay);

      reshade::unregister_addon(hModule);
      break;
  }

  // ResourceWatcher::use(fdwReason);

  return TRUE;
}
