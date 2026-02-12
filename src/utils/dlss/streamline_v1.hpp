/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#define NOMINMAX

#include <cstdlib>
#include <unordered_map>

#include <detours.h>

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>

#include <Dbghelp.h>  // For ImageDirectoryEntryToData
#include <Psapi.h>    // For MODULEINFO
#include <Windows.h>
#include <wrl/client.h>

#pragma comment(lib, "Dbghelp.lib")

#include <cstdint>
#include <filesystem>
#include <format>
#include <gtl/phmap.hpp>

#include <iostream>
#include <sstream>

#include <include/reshade.hpp>
#include "../../../external/reshade/source/dxgi/dxgi_factory.hpp"
#include "../../../external/reshade/source/dxgi/dxgi_swapchain.hpp"
#include "../format.hpp"
#include "../iat_hook.hpp"
#include "../resource.hpp"

// https://github.com/NVIDIAGameWorks/Streamline/blob/main/docs/ProgrammingGuide.md
// https://github.com/NVIDIAGameWorks/Streamline/blob/main/docs/ProgrammingGuideDLSS_G.md
// https://github.com/NVIDIAGameWorks/Streamline/blob/main/docs/ProgrammingGuideManualHooking.md

namespace renodx::utils::streamline::v1 {

#include <streamline_v1/sl.h>

namespace internal {

static bool is_primary_hook = false;

static bool attached = false;
}  // namespace internal

std::unordered_map<void*, void*> fg_wrapped_to_unwrapped;

struct __declspec(uuid("0197a8da-3f36-7bc7-8233-dc4b149e14e7")) SwapchainData {
  reshade::api::swapchain* swapchain = nullptr;
  void* device_wrapper = nullptr;
};

HMODULE sl_interposer_dll = nullptr;
decltype(&sl1::slInit) real_slInit = nullptr;
SL_API bool hooked_slInit(const sl1::Preferences& pref, int applicationId = sl1::kUniqueApplicationId) {
  /*
      //! Optional - In non-production builds it is useful to enable debugging console window
    bool showConsole = false;
    //! Optional - Various logging levels
    LogLevel logLevel = eLogLevelDefault;
    //! Optional - Absolute paths to locations where to look for plugins, first path in the list has the highest priority
    const wchar_t** pathsToPlugins = {};
    //! Optional - Number of paths to search
    uint32_t numPathsToPlugins = 0;
    //! Optional - Absolute path to location where logs and other data should be stored
    //! NOTE: Set this to nullptr in order to disable logging to a file
    const wchar_t* pathToLogsAndData = {};
    //! Optional - Allows resource allocation tracking on the host side
    pfunResourceAllocateCallback* allocateCallback = {};
    //! Optional - Allows resource deallocation tracking on the host side
    pfunResourceReleaseCallback* releaseCallback = {};
    //! Optional - Allows log message tracking including critical errors if they occur
    pfunLogMessageCallback* logMessageCallback = {};
    //! Optional - Flags used to enable or disable advanced options
    PreferenceFlags flags{};
    //! Required - Features to load (assuming appropriate plugins are found), if not specified NO features will be loaded by default
    const Feature* featuresToLoad = {};
    //! Required - Number of features to load, only used when list is not a null pointer
    uint32_t numFeaturesToLoad = 0;
    //! Reserved for future expansion, must be set to null
    void* ext = {};
  */

  std::stringstream s;
  s << "utils::dlss_hook::slInit(pref = {";
  s << " showConsole: " << std::boolalpha << pref.showConsole;
  s << ", logLevel: " << static_cast<uint32_t>(pref.logLevel);
  if (pref.pathsToPlugins != nullptr && pref.numPathsToPlugins > 0)
    for (auto i = 0u; i < pref.numPathsToPlugins; ++i) {
      auto item = pref.pathsToPlugins[i];
      s << ", pathToPlugin[" << i << "]: ";
      if (item == nullptr) {
        s << "nullptr";
        break;
      } else {
        auto path = std::filesystem::path(item);
        s << path.string();
      }
    }
  s << ", pathToLogsAndData: " << (pref.pathToLogsAndData != nullptr ? std::filesystem::path(pref.pathToLogsAndData).string() : "");
  s << ", flags:";
  bool has_flag = false;
  if (pref.flags & sl1::PreferenceFlags::ePreferenceFlagDisableCLStateTracking) {
    s << " DisableCLStateTracking";
    has_flag = true;
  }
  if (pref.flags & sl1::PreferenceFlags::ePreferenceFlagDisableDebugText) {
    s << " DisableDebugText";
    has_flag = true;
  }
  if (!has_flag) {
    s << " None";
  }

  if (pref.numFeaturesToLoad > 0) {
    s << ", featuresToLoad: ";
    for (auto i = 0u; i < pref.numFeaturesToLoad; ++i) {
      switch ((uint32_t)pref.featuresToLoad[i]) {
        case 0:    s << "DLSS"; break;
        case 1:    s << "NRD"; break;
        case 2:    s << "NIS"; break;
        case 3:    s << "Reflex"; break;
        case 4:    s << "PCL"; break;
        case 5:    s << "DeepDVC"; break;
        case 6:    s << "Latewarp"; break;
        case 1000: s << "DLSS_G"; break;  // Undocumented eFeatureDLSS_G;
        case 1001: s << "DLSS_RR"; break;
        case 1002: s << "NvPerf"; break;
        case 1003: s << "DirectSR"; break;
        case 9999: s << "ImGUI"; break;
        default:
          s << std::format("Unknown ({})", static_cast<uint32_t>(pref.featuresToLoad[i]));
          break;
      }

      if (i < pref.numFeaturesToLoad - 1) {
        s << ", ";
      }
    }
  }

  // s << ", applicationId: " << pref.applicationId;
  // s << ", engine: " << static_cast<uint32_t>(pref.engine);
  // s << ", engineVersion: " << (pref.engineVersion != nullptr ? pref.engineVersion : "nullptr");
  // s << ", projectId: " << (pref.projectId != nullptr ? pref.projectId : "nullptr");
  // s << ", renderAPI: " << static_cast<uint32_t>(pref.renderAPI);
  s << " })";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());

  auto pref_copy = pref;
#ifndef NDEBUG
  pref_copy.showConsole = true;
  // pref_copy.flags &= ~sl1::PreferenceFlags::eUseManualHooking;
  pref_copy.logLevel = sl1::LogLevel::eLogLevelVerbose;
#endif

  return real_slInit(pref_copy, applicationId);
}

static gtl::parallel_node_hash_map<uint64_t, sl1::Resource> resource_map;
static gtl::parallel_node_hash_map<sl::BufferType, sl1::Resource> resource_tags;

static decltype(&sl1::slSetTag) real_slSetTag = nullptr;
SL_API bool hooked_slSetTag(const sl1::Resource* resource, sl1::BufferType tag, uint32_t id = 0, const sl1::Extent* extent = nullptr) {
  auto known_resource = resource_tags.find(tag);
  if (known_resource == resource_tags.end() || known_resource->second.native != resource->native) {
    std::stringstream s;
    s << "utils::streamline_v1::slSetTag(";
    switch (tag) {
      case sl1::BufferType::eBufferTypeDepth:                    s << "Depth"; break;
      case sl1::BufferType::eBufferTypeMVec:                     s << "MVec"; break;
      case sl1::BufferType::eBufferTypeHUDLessColor:             s << "HUDLessColor"; break;
      case sl1::BufferType::eBufferTypeScalingInputColor:        s << "ScalingInputColor"; break;
      case sl1::BufferType::eBufferTypeScalingOutputColor:       s << "ScalingOutputColor"; break;
      case sl1::BufferType::eBufferTypeNormals:                  s << "Normals"; break;
      case sl1::BufferType::eBufferTypeRoughness:                s << "Roughness"; break;
      case sl1::BufferType::eBufferTypeAlbedo:                   s << "Albedo"; break;
      case sl1::BufferType::eBufferTypeSpecularAlbedo:           s << "SpecularAlbedo"; break;
      case sl1::BufferType::eBufferTypeIndirectAlbedo:           s << "IndirectAlbedo"; break;
      case sl1::BufferType::eBufferTypeSpecularMVec:             s << "SpecularMVec"; break;
      case sl1::BufferType::eBufferTypeDisocclusionMask:         s << "DisocclusionMask"; break;
      case sl1::BufferType::eBufferTypeEmissive:                 s << "Emissive"; break;
      case sl1::BufferType::eBufferTypeExposure:                 s << "Exposure"; break;
      case sl1::BufferType::eBufferTypeNormalRoughness:          s << "NormalRoughness"; break;
      case sl1::BufferType::eBufferTypeDiffuseHitNoisy:          s << "DiffuseHitNoisy"; break;
      case sl1::BufferType::eBufferTypeDiffuseHitDenoised:       s << "DiffuseHitDenoised"; break;
      case sl1::BufferType::eBufferTypeSpecularHitNoisy:         s << "SpecularHitNoisy"; break;
      case sl1::BufferType::eBufferTypeSpecularHitDenoised:      s << "SpecularHitDenoised"; break;
      case sl1::BufferType::eBufferTypeShadowNoisy:              s << "ShadowNoisy"; break;
      case sl1::BufferType::eBufferTypeShadowDenoised:           s << "ShadowDenoised"; break;
      case sl1::BufferType::eBufferTypeAmbientOcclusionNoisy:    s << "AmbientOcclusionNoisy"; break;
      case sl1::BufferType::eBufferTypeAmbientOcclusionDenoised: s << "AmbientOcclusionDenoised"; break;
      case sl1::BufferType::eBufferTypeUIHint:                   s << "UIHint"; break;
      case sl1::BufferType::eBufferTypeShadowHint:               s << "ShadowHint"; break;
      case sl1::BufferType::eBufferTypeReflectionHint:           s << "ReflectionHint"; break;
      case sl1::BufferType::eBufferTypeParticleHint:             s << "ParticleHint"; break;
      case sl1::BufferType::eBufferTypeTransparencyHint:         s << "TransparencyHint"; break;
      case sl1::BufferType::eBufferTypeAnimatedTextureHint:      s << "AnimatedTextureHint"; break;
      case sl1::BufferType::eBufferTypeBiasCurrentColorHint:     s << "BiasCurrentColorHint"; break;
      case sl1::BufferType::eBufferTypeRaytracingDistance:       s << "RaytracingDistance"; break;
      case sl1::BufferType::eBufferTypeReflectionMotionVectors:  s << "ReflectionMotionVectors"; break;
      case sl1::BufferType::eBufferTypePosition:                 s << "Position"; break;
      case sl1::BufferType::eBufferTypeInvalidDepthMotionHint:   s << "InvalidDepthMotionHint"; break;

      default:
        s << std::format("Unknown ({})", static_cast<uint32_t>(tag));
        break;
    }
    s << ": ";
    s << PRINT_PTR((uintptr_t)resource->native);

    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
    resource_tags[tag] = *resource;
  }

  auto& value = resource_map[(uint64_t)resource->native];
  if (value.native == nullptr) {
    auto* info = renodx::utils::resource::GetResourceInfo(reshade::api::resource{(uint64_t)resource->native});
    if (info == nullptr) {
      reshade::log::message(
          reshade::log::level::error,
          std::format("utils::dlss_hook::slSetTag() - Resource info not found for resource: {}", (void*)resource->native).c_str());
      real_slSetTag(resource, tag, id, extent);
    }
    if (info->clone_info != nullptr) {
      reshade::log::message(reshade::log::level::debug,
                            std::format("utils::dlss_hook::slSetTag() - Using clone resource: {}", (void*)info->clone.handle).c_str());
      value.native = (void*)info->clone.handle;
    } else {
      value.native = resource->native;
    }
    value.type = resource->type;
    value.state = resource->state;
  }

  if (value.native != resource->native) {
    value.state = resource->state;
    return real_slSetTag(&value, tag, id, extent);
  }

  // return sl1::Result::eOk;

  return real_slSetTag(resource, tag, id, extent);
}

bool (*real_slUpgradeInterface)(void** baseInterface) = nullptr;
SL_API bool hooked_slUpgradeInterface(void** baseInterface) {
  reshade::log::message(reshade::log::level::debug, "utils::dlss_hook::slUpgradeInterface()");
  return real_slUpgradeInterface(baseInterface);
}

static const std::vector<std::tuple<const char*, void**, void*>> VTABLE_HOOKS = {
    {"slInit", (void**)&real_slInit, &hooked_slInit},
    {"slSetTag", (void**)&real_slSetTag, &hooked_slSetTag},
    // {"slSetD3DDevice", (void**)&real_slSetD3DDevice, &hooked_slSetD3DDevice},
    // {"slSetTagForFrame", &real_slSetTagForFrame, &hooked_slSetTagForFrame},
    {"slUpgradeInterface", (void**)&real_slUpgradeInterface, &hooked_slUpgradeInterface},
    // {"slGetNativeInterface", (void**)&real_slGetNativeInterface, &hooked_slGetNativeInterface},
    // {"slDLSSSetOptions", (void**)&real_slDLSSSetOptions, &hooked_slDLSSSetOptions},
    // {"CreateDXGIFactory", &real_CreateDXGIFactory, &hooked_CreateDXGIFactory},
    // {"CreateDXGIFactory1", &real_CreateDXGIFactory1, &hooked_CreateDXGIFactory1},
    // {"CreateDXGIFactory2", &real_CreateDXGIFactory2, &hooked_CreateDXGIFactory2},
    // {"D3D12CreateDevice", &real_D3D12CreateDevice, &hooked_D3D12CreateDevice},
};

static const std::vector<std::tuple<const char*, void**, void*>> VTABLE_COMMON_HOOKS = {

    {"slInit", (void**)&real_slInit, &hooked_slInit},
    {"slSetTag", (void**)&real_slSetTag, &hooked_slSetTag},
    // {"slSetD3DDevice", (void**)&real_slSetD3DDevice, &hooked_slSetD3DDevice},
    // {"slSetTagForFrame", &real_slSetTagForFrame, &hooked_slSetTagForFrame},
    {"slUpgradeInterface", (void**)&real_slUpgradeInterface, &hooked_slUpgradeInterface},
    // {"slGetNativeInterface", (void**)&real_slGetNativeInterface, &hooked_slGetNativeInterface},
    // {"slDLSSSetOptions", (void**)&real_slDLSSSetOptions, &hooked_slDLSSSetOptions},
    // {"CreateDXGIFactory", &real_CreateDXGIFactory, &hooked_CreateDXGIFactory},
    // {"CreateDXGIFactory1", &real_CreateDXGIFactory1, &hooked_CreateDXGIFactory1},
    // {"CreateDXGIFactory2", &real_CreateDXGIFactory2, &hooked_CreateDXGIFactory2},
    // {"D3D12CreateDevice", &real_D3D12CreateDevice, &hooked_D3D12CreateDevice},
};

}  // namespace renodx::utils::streamline::v1