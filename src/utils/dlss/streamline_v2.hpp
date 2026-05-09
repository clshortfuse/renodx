/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <sl_core_types.h>

#include <cstdlib>
#include <shared_mutex>
#include <vector>

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <sl.h>
#include <sl_dlss.h>
#include <sl_dlss_g.h>

#include <cstdint>
#include <filesystem>
#include <format>
#include <gtl/phmap.hpp>

#include <iostream>
#include <sstream>

#include <include/reshade.hpp>

#include <source/dxgi/dxgi_factory.hpp>

#include "../data.hpp"
#include "../directx.hpp"
#include "../platform.hpp"
#include "../resource.hpp"
#include "./DXGIFactoryWrapper.hpp"
#include "./DXGISwapChainWrapper.hpp"

// https://github.com/NVIDIAGameWorks/Streamline/blob/main/docs/ProgrammingGuide.md
// https://github.com/NVIDIAGameWorks/Streamline/blob/main/docs/ProgrammingGuideDLSS_G.md
// https://github.com/NVIDIAGameWorks/Streamline/blob/main/docs/ProgrammingGuideManualHooking.md

namespace renodx::utils::streamline::v2 {

static decltype(&slInit) Real_slInit = nullptr;
static decltype(&slGetNativeInterface) Real_slGetNativeInterface = nullptr;
static bool streamline_bootstrap_initialized = false;
static bool streamline_bootstrap_init_in_progress = false;
static bool streamline_runtime_initialized = false;
using DLSSGSetOptionsOverrideCallback = void (*)(const sl::ViewportHandle& viewport, sl::DLSSGOptions& options);
static DLSSGSetOptionsOverrideCallback override_dlssg_set_options = nullptr;

static void ProcessDeferredStreamlineUpgrades();

SL_API sl::Result Hooked_slInit(const sl::Preferences& pref, uint64_t sdkVersion = sl::kSDKVersion) {
#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "utils::streamline_v2::slInit(pref = {";
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
  if (pref.flags & sl::PreferenceFlags::eDisableCLStateTracking) {
    s << " eDisableCLStateTracking";
    has_flag = true;
  }
  if (pref.flags & sl::PreferenceFlags::eDisableDebugText) {
    s << " eDisableDebugText";
    has_flag = true;
  }
  if (pref.flags & sl::PreferenceFlags::eUseManualHooking) {
    s << " eUseManualHooking";
    has_flag = true;
  }
  if (pref.flags & sl::PreferenceFlags::eAllowOTA) {
    s << " eAllowOTA";
    has_flag = true;
  }
  if (pref.flags & sl::PreferenceFlags::eBypassOSVersionCheck) {
    s << " eBypassOSVersionCheck";
    has_flag = true;
  }
  if (pref.flags & sl::PreferenceFlags::eUseDXGIFactoryProxy) {
    s << " eUseDXGIFactoryProxy";
    has_flag = true;
  }
  if (pref.flags & sl::PreferenceFlags::eLoadDownloadedPlugins) {
    s << " eLoadDownloadedPlugins";
    has_flag = true;
  }
  if (pref.flags & sl::PreferenceFlags::eUseFrameBasedResourceTagging) {
    s << " eUseFrameBasedResourceTagging";
    has_flag = true;
  }
  if (!has_flag) {
    s << " None";
  }

  if (pref.numFeaturesToLoad > 0) {
    s << ", featuresToLoad: ";
    for (auto i = 0u; i < pref.numFeaturesToLoad; ++i) {
      switch (pref.featuresToLoad[i]) {
        case 0:    s << "DLSS"; break;
        case 1:    s << "NRD_INVALID"; break;
        case 2:    s << "NIS"; break;
        case 3:    s << "Reflex"; break;
        case 4:    s << "PCL"; break;
        case 5:    s << "DeepDVC"; break;
        case 6:    s << "Latewarp"; break;
        case 1000: s << "DLSS_G"; break;
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

  s << ", applicationId: " << pref.applicationId;
  s << ", engine: " << static_cast<uint32_t>(pref.engine);
  // s << ", engineVersion: " << (pref.engineVersion != nullptr ? pref.engineVersion : "nullptr");
  // s << ", projectId: " << (pref.projectId != nullptr ? pref.projectId : "nullptr");
  s << ", renderAPI: " << static_cast<uint32_t>(pref.renderAPI);
  s << " })";
  log::d(s.str());
#endif

  auto pref_copy = pref;
  pref_copy.showConsole = true;
  // pref_copy.flags |= sl::PreferenceFlags::eUseDXGIFactoryProxy;
  // pref_copy.flags |= sl::PreferenceFlags::eDisableDebugText;
  // pref_copy.flags |= sl::PreferenceFlags::eUseManualHooking;
  // pref_copy.flags &= ~sl::PreferenceFlags::eAllowOTA;
  pref_copy.logLevel = sl::LogLevel::eVerbose;

  const wchar_t* pathToLogsAndData = L"./";

  pref_copy.pathToLogsAndData = pathToLogsAndData;
  // pref_copy.flags |= sl::PreferenceFlags::eUseDXGIFactoryProxy;

  if (streamline_bootstrap_initialized && !streamline_bootstrap_init_in_progress) {
    return sl::Result::eOk;
  }

#if defined(DEBUG_LEVEL_1) && !defined(NDEBUG)
  const auto ret = Real_slInit(pref_copy, sdkVersion);
#else
  const auto ret = Real_slInit(pref, sdkVersion);
#endif

  if (ret == sl::Result::eOk || ret == sl::Result::eErrorInitNotCalled) {
    streamline_bootstrap_initialized = true;
    streamline_runtime_initialized = true;
    ProcessDeferredStreamlineUpgrades();
  }

  return ret;
}

using DeviceImplMap = utils::data::ParallelFlatHashMap<ID3D12Device*, reshade::api::device*, std::shared_mutex>;

DeviceImplMap device_impl_map;

struct TrackedCommandListInfo {
  reshade::api::command_list* reshade_command_list = nullptr;
  ID3D12Device* native_device = nullptr;
};

using CommandListMap = utils::data::ParallelFlatHashMap<ID3D12GraphicsCommandList*, TrackedCommandListInfo, std::shared_mutex>;
CommandListMap tracked_command_lists;

struct TrackedCommandQueueInfo {
  reshade::api::command_queue* reshade_queue = nullptr;
  ID3D12Device* native_device = nullptr;
};

using TrackedCommandQueueMap = utils::data::ParallelFlatHashMap<ID3D12CommandQueue*, TrackedCommandQueueInfo, std::shared_mutex>;
TrackedCommandQueueMap tracked_command_queues;

// Result slUpgradeInterface(void** baseInterface)
extern "C" decltype(&slUpgradeInterface) Real_slUpgradeInterface = nullptr;
extern "C" sl::Result Hooked_slUpgradeInterface(void** baseInterface) {
  auto* unknown = static_cast<IUnknown*>(*baseInterface);

  ID3D12CommandQueue* d3d12_command_queue{};
  if (SUCCEEDED(unknown->QueryInterface(&d3d12_command_queue))) {
    d3d12_command_queue->Release();

    auto ret = Real_slUpgradeInterface(baseInterface);
    if (ret != sl::Result::eOk) {
      log::e("utils::streamline_v2::slUpgradeInterface() - Failed to upgrade command queue interface");
      return ret;
    }

    auto* upgraded_unknown = static_cast<IUnknown*>(*baseInterface);
    ID3D12CommandQueue* upgraded_command_queue{};
    if (SUCCEEDED(upgraded_unknown->QueryInterface(&upgraded_command_queue))) {
      upgraded_command_queue->Release();
    }
    return ret;
  }

  ID3D12Device* d3d12_device{};
  if (SUCCEEDED(unknown->QueryInterface(&d3d12_device))) {
    d3d12_device->Release();
    auto ret = Real_slUpgradeInterface(baseInterface);
    if (ret != sl::Result::eOk) {
      log::e("utils::streamline_v2::slUpgradeInterface() - Failed to upgrade interface");
      return ret;
    }
    return ret;
  }

  IDXGIDevice* dxgi_device{};
  if (SUCCEEDED(unknown->QueryInterface(&dxgi_device))) {
    dxgi_device->Release();
    auto ret = Real_slUpgradeInterface(baseInterface);
    if (ret != sl::Result::eOk) {
      log::e("utils::streamline_v2::slUpgradeInterface() - Failed to upgrade interface");
      return ret;
    }
    return ret;
  }

  IDXGISwapChain* dxgi_swap_chain{};
  if (SUCCEEDED(unknown->QueryInterface(&dxgi_swap_chain))) {
    dxgi_swap_chain->Release();
    auto ret = Real_slUpgradeInterface(baseInterface);
    if (ret != sl::Result::eOk) {
      log::e("utils::streamline_v2::slUpgradeInterface() - Failed to upgrade interface");
      return ret;
    }
    return ret;
  }

  IDXGIFactory7* dxgi_factory7{};
  if (SUCCEEDED(unknown->QueryInterface(&dxgi_factory7))) {
    // dxgiFactory7->Release();

    // Upgrade ReShade's internal factory to use the Streamline factory
    DXGIFactory* reshade_factory = nullptr;
    UINT size = sizeof(reshade_factory);
    dxgi_factory7->GetPrivateData(__uuidof(DXGIFactory), &size, &reshade_factory);
    if (reshade_factory == nullptr) {
      log::e("utils::streamline_v2::slUpgradeInterface() - Failed to get DXGIFactory proxy from IDXGIFactory7");
    }
    auto* Real_factory = (IDXGIFactory7*)reshade_factory->_orig;

    Real_slUpgradeInterface((void**)&Real_factory);

    reshade_factory->_orig = Real_factory;

    // Wrap to ensure it doesn't pass active queue for swapchain creation
    auto* factory_wrapper = new DXGIFactoryWrapper(reshade_factory);
    // factory_wrapper->SetSLGetNativeInterface(Real_slGetNativeInterface);
    // factory_wrapper->SetSLUpgradeInterface(Real_slUpgradeInterface);
    *baseInterface = factory_wrapper;

    return sl::Result::eOk;
  }

  assert(false);
  return Real_slUpgradeInterface(baseInterface);
}

extern "C" decltype(&CreateDXGIFactory) Real_CreateDXGIFactory = nullptr;
extern "C" HRESULT Hooked_CreateDXGIFactory(REFIID riid, void** ppFactory) {
  return Real_CreateDXGIFactory(riid, ppFactory);
}

static thread_local bool is_streamline_device = false;

static void UpdateReshadeApiObject(reshade::api::api_object* object, void* orig) {
  assert((void*)object->get_native() == reinterpret_cast<void**>(object)[1]);
  reinterpret_cast<void**>(object)[1] = orig;
}

static bool TryUpgradeTrackedStreamlineDevice(reshade::api::device* device) {
  if (device == nullptr) return false;

  auto* native_device = reinterpret_cast<ID3D12Device*>(static_cast<uintptr_t>(device->get_native()));
  if (native_device == nullptr) {
    return false;
  }

  ID3D12Device14* d3d12_device14{};
  if (FAILED(static_cast<IUnknown*>(native_device)->QueryInterface(&d3d12_device14))) {
    return false;
  }
  d3d12_device14->Release();

  if (Real_slUpgradeInterface == nullptr) {
    return false;
  }

  auto* upgraded_device = native_device;
  auto ret = Real_slUpgradeInterface(reinterpret_cast<void**>(&upgraded_device));
  if (ret != sl::Result::eOk) {
    log::e(std::format(
               "utils::streamline_v2::TryUpgradeTrackedStreamlineDevice() - Failed to upgrade native device {:p}, result: {}",
               (void*)native_device,
               static_cast<uint32_t>(ret))
               .c_str());
    return false;
  }

  if (upgraded_device == native_device) {
    return true;
  }

  UpdateReshadeApiObject(device, upgraded_device);

  device_impl_map.lazy_emplace_l(
      upgraded_device,
      [&device](auto& pair) {
        pair.second = device;
      },
      [upgraded_device, device](const DeviceImplMap::constructor& ctor) {
        ctor(upgraded_device, device);
      });

  return true;
}

static bool TryUpgradeTrackedStreamlineCommandQueue(reshade::api::command_queue* queue) {
  if (queue == nullptr) return false;

  auto* native_command_queue = reinterpret_cast<ID3D12CommandQueue*>(static_cast<uintptr_t>(queue->get_native()));
  if (native_command_queue == nullptr) {
    return false;
  }

  if (Real_slUpgradeInterface == nullptr) {
    return false;
  }

  ID3D12Device* before_device = nullptr;
  if (FAILED(native_command_queue->GetDevice(IID_PPV_ARGS(&before_device)))) {
    before_device = nullptr;
  }

  auto* upgraded_command_queue = native_command_queue;
  auto ret = Real_slUpgradeInterface(reinterpret_cast<void**>(&upgraded_command_queue));
  if (ret != sl::Result::eOk) {
    log::e(std::format(
               "utils::streamline_v2::TryUpgradeTrackedStreamlineCommandQueue() - Failed to upgrade native command queue {:p}, result: {}",
               (void*)native_command_queue,
               static_cast<uint32_t>(ret))
               .c_str());
    if (before_device != nullptr) before_device->Release();
    return false;
  }

  ID3D12Device* after_device = nullptr;
  if (FAILED(upgraded_command_queue->GetDevice(IID_PPV_ARGS(&after_device)))) {
    after_device = nullptr;
  }

  if (upgraded_command_queue == native_command_queue) {
    if (before_device != nullptr) before_device->Release();
    if (after_device != nullptr) after_device->Release();
    return true;
  }

  UpdateReshadeApiObject(queue, upgraded_command_queue);

  TrackedCommandQueueInfo previous_info = {};
  const bool had_previous_info = tracked_command_queues.erase_if(native_command_queue, [&previous_info](auto& pair) {
    previous_info = pair.second;
    return true;
  });
  if (had_previous_info) {
    previous_info.reshade_queue = queue;
    previous_info.native_device = after_device;
    tracked_command_queues.lazy_emplace_l(
        upgraded_command_queue,
        [&previous_info](auto& pair) {
          pair.second = previous_info;
        },
        [&previous_info, upgraded_command_queue](const TrackedCommandQueueMap::constructor& ctor) {
          ctor(upgraded_command_queue, previous_info);
        });
  }

  if (before_device != nullptr) before_device->Release();
  if (after_device != nullptr) after_device->Release();
  return true;
}

static void OnInitDevice(reshade::api::device* device) {
  auto* native_device = reinterpret_cast<ID3D12Device*>(static_cast<uintptr_t>(device->get_native()));

  device_impl_map.lazy_emplace_l(
      native_device,
      [&device](auto& pair) {
        pair.second = device;
      },
      [native_device, device](const DeviceImplMap::constructor& ctor) {
        ctor(native_device, device);
      });

  if (!is_streamline_device) return;
  if (!streamline_runtime_initialized) {
    return;
  }
  TryUpgradeTrackedStreamlineDevice(device);
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (device == nullptr) return;

  std::vector<ID3D12Device*> devices_to_erase = {};
  device_impl_map.for_each([&devices_to_erase, device](const auto& pair) {
    if (pair.second == device) {
      devices_to_erase.push_back(pair.first);
    }
  });
  for (auto* native_device : devices_to_erase) {
    device_impl_map.erase(native_device);
  }
}

static void OnInitCommandQueue(reshade::api::command_queue* queue) {
  if (queue == nullptr) return;
  auto* device = queue->get_device();
  // assert(IsDebuggerPresent());
  if (device == nullptr || device->get_api() != reshade::api::device_api::d3d12) return;

  auto* native_command_queue = reinterpret_cast<ID3D12CommandQueue*>(static_cast<uintptr_t>(queue->get_native()));
  if (native_command_queue == nullptr) {
    return;
  }

  TrackedCommandQueueInfo info = {};
  info.reshade_queue = queue;
  info.native_device = reinterpret_cast<ID3D12Device*>(static_cast<uintptr_t>(device->get_native()));
  tracked_command_queues.lazy_emplace_l(
      native_command_queue,
      [&info](auto& pair) {
        pair.second = info;
      },
      [&info, native_command_queue](const TrackedCommandQueueMap::constructor& ctor) {
        ctor(native_command_queue, info);
      });

  if (!streamline_runtime_initialized) {
    return;
  }

  TryUpgradeTrackedStreamlineCommandQueue(queue);
}

static void OnDestroyCommandQueue(reshade::api::command_queue* queue) {
  if (queue == nullptr) return;

  auto* native_command_queue = reinterpret_cast<ID3D12CommandQueue*>(static_cast<uintptr_t>(queue->get_native()));
  if (native_command_queue == nullptr) return;

  const bool found = tracked_command_queues.erase_if(native_command_queue, [](auto&) {
    return true;
  });

  if (!found) {
    return;
  }
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (cmd_list == nullptr) return;
  auto* device = cmd_list->get_device();
  if (device == nullptr || device->get_api() != reshade::api::device_api::d3d12) return;

  auto* native_command_list = reinterpret_cast<ID3D12GraphicsCommandList*>(static_cast<uintptr_t>(cmd_list->get_native()));
  if (native_command_list == nullptr) {
    return;
  }

  ID3D12Device* native_device = nullptr;
  if (FAILED(native_command_list->GetDevice(IID_PPV_ARGS(&native_device)))) {
    native_device = nullptr;
  }

  TrackedCommandListInfo info = {};
  info.reshade_command_list = cmd_list;
  info.native_device = native_device;
  tracked_command_lists.lazy_emplace_l(
      native_command_list,
      [&info](auto& pair) {
        pair.second = info;
      },
      [&info, native_command_list](const CommandListMap::constructor& ctor) {
        ctor(native_command_list, info);
      });

  if (native_device != nullptr) {
    native_device->Release();
  }
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (cmd_list == nullptr) return;

  auto* native_command_list = reinterpret_cast<ID3D12GraphicsCommandList*>(static_cast<uintptr_t>(cmd_list->get_native()));
  if (native_command_list == nullptr) return;

  const bool found = tracked_command_lists.erase_if(native_command_list, [](auto&) {
    return true;
  });

  if (!found) {
    return;
  }
}

static void ProcessDeferredStreamlineUpgrades() {
  std::vector<reshade::api::device*> devices_to_upgrade;
  std::vector<reshade::api::command_queue*> queues_to_upgrade;

  device_impl_map.for_each([&devices_to_upgrade](const auto& pair) {
    if (pair.second != nullptr) {
      devices_to_upgrade.push_back(pair.second);
    }
  });

  tracked_command_queues.for_each([&queues_to_upgrade](const auto& pair) {
    const auto& info = pair.second;
    if (info.reshade_queue != nullptr) {
      queues_to_upgrade.push_back(info.reshade_queue);
    }
  });

  for (auto* device : devices_to_upgrade) {
    TryUpgradeTrackedStreamlineDevice(device);
  }
  for (auto* queue : queues_to_upgrade) {
    TryUpgradeTrackedStreamlineCommandQueue(queue);
  }
}

extern "C" decltype(&D3D12CreateDevice) Real_D3D12CreateDevice = nullptr;
extern "C" HRESULT Hooked_D3D12CreateDevice(IUnknown* pAdapter, D3D_FEATURE_LEVEL MinimumFeatureLevel, REFIID riid, void** ppDevice) {
  // assert(IsDebuggerPresent());
  renodx::utils::directx::Initialize();

  assert(is_streamline_device == false);
  is_streamline_device = true;
  auto hr = renodx::utils::directx::pD3D12CreateDevice != nullptr
                ? renodx::utils::directx::pD3D12CreateDevice(pAdapter, MinimumFeatureLevel, riid, ppDevice)
                : E_FAIL;
  is_streamline_device = false;

  return hr;
}

extern "C" decltype(&CreateDXGIFactory1) Real_CreateDXGIFactory1 = nullptr;
extern "C" HRESULT Hooked_CreateDXGIFactory1(REFIID riid, void** ppFactory) {
  return Real_CreateDXGIFactory1(riid, ppFactory);
}

static decltype(&CreateDXGIFactory2) Real_CreateDXGIFactory2 = nullptr;
SL_API HRESULT Hooked_CreateDXGIFactory2(UINT flags, REFIID riid, void** ppFactory) {
  renodx::utils::directx::Initialize();
  // Make real ReShade Factory instead of Streamline factory
  IDXGIFactory2* unknown = nullptr;
  auto ret = renodx::utils::directx::pCreateDXGIFactory2(flags, riid, reinterpret_cast<void**>(&unknown));
  if (ret != S_OK) {
    log::e("utils::streamline_v2::CreateDXGIFactory2() - Failed to create DXGIFactory2");
    return ret;
  }
  IDXGIFactory7* dxgi_factory7{};
  if (SUCCEEDED(unknown->QueryInterface(&dxgi_factory7))) {
    dxgi_factory7->Release();

    // Upgrade ReShade's internal factory to use the Streamline factory
    DXGIFactory* reshade_factory = nullptr;
    UINT size = sizeof(reshade_factory);
    dxgi_factory7->GetPrivateData(__uuidof(DXGIFactory), &size, &reshade_factory);
    if (reshade_factory == nullptr) {
      log::e("utils::streamline_v2::CreateDXGIFactory2() - Failed to get DXGIFactory proxy from IDXGIFactory7");
    }
    auto* real_factory = (IDXGIFactory7*)reshade_factory->_orig;

    Real_slUpgradeInterface((void**)&real_factory);  // Now Streamline factory

    reshade_factory->_orig = real_factory;

    *ppFactory = reshade_factory;
  }

  return ret;
}

// slGetNativeInterface

SL_API sl::Result Hooked_slGetNativeInterface(void* proxyInterface, void** baseInterface) {
  ID3D12CommandQueue* d3d12_command_queue{};
  if (SUCCEEDED(static_cast<IUnknown*>(proxyInterface)->QueryInterface(&d3d12_command_queue))) {
    d3d12_command_queue->Release();

    auto ret = Real_slGetNativeInterface(proxyInterface, baseInterface);
    if (ret != sl::Result::eOk) {
      log::e("utils::streamline_v2::slGetNativeInterface() - Failed to get native command queue interface");
      return ret;
    }

    ID3D12CommandQueue* native_command_queue{};
    if (SUCCEEDED(static_cast<IUnknown*>(*baseInterface)->QueryInterface(&native_command_queue))) {
      native_command_queue->Release();
    }
    return ret;
  }

  ID3D12Device* d3d12Device{};
  if (SUCCEEDED(static_cast<IUnknown*>(proxyInterface)->QueryInterface(&d3d12Device))) {
    d3d12Device->Release();
    auto ret = Real_slGetNativeInterface(proxyInterface, baseInterface);
    if (ret != sl::Result::eOk) {
      log::e("utils::streamline_v2::slGetNativeInterface() - Failed to get native interface");
      return ret;
    }
    return ret;
  }

  IDXGIDevice* dxgi_device{};
  if (SUCCEEDED(static_cast<IUnknown*>(proxyInterface)->QueryInterface(&dxgi_device))) {
    dxgi_device->Release();
    auto ret = Real_slGetNativeInterface(proxyInterface, baseInterface);
    if (ret != sl::Result::eOk) {
      log::e("utils::streamline_v2::slGetNativeInterface() - Failed to get native interface");
      return ret;
    }
    return ret;
  }

  IDXGISwapChain4* dxgiSwapChain{};
  if (SUCCEEDED(static_cast<IUnknown*>(proxyInterface)->QueryInterface(&dxgiSwapChain))) {
    // assert(IsDebuggerPresent());
    // dxgiSwapChain->Release();
    IDXGISwapChain* native_directx_swapchain = nullptr;
    auto ret = Real_slGetNativeInterface(proxyInterface, (void**)&native_directx_swapchain);
    if (ret != sl::Result::eOk) {
      log::e("utils::streamline_v2::slGetNativeInterface() - Failed to get native interface");
      return ret;
    }
    // We have no way to create a ReShade swapchain here, so just return the ReShade one, but wrapped with a new pointer
    *baseInterface = new DXGISwapChainWrapper((IDXGISwapChain4*)dxgiSwapChain);
    return ret;
  }

  IDXGIFactory* dxgiFactory{};
  if (SUCCEEDED(static_cast<IUnknown*>(proxyInterface)->QueryInterface(&dxgiFactory))) {
    dxgiFactory->Release();

    auto ret = Real_slGetNativeInterface(proxyInterface, baseInterface);
    if (ret != sl::Result::eOk) {
      log::e("utils::streamline_v2::slGetNativeInterface() - Failed to get native interface");
      return ret;
    }

    return ret;
  }

  return Real_slGetNativeInterface(proxyInterface, baseInterface);
}

static decltype(&slEvaluateFeature) Real_slEvaluateFeature = nullptr;
SL_API sl::Result Hooked_slEvaluateFeature(sl::Feature feature, const sl::FrameToken& frame, const sl::BaseStructure** inputs, uint32_t numInputs, sl::CommandBuffer* cmdBuffer) {
  (void)frame;
  const bool unwrapped = utils::directx::NativeFromReShadeProxy(&cmdBuffer);
  assert((unwrapped || cmdBuffer == nullptr) && "slEvaluateFeature expected a ReShade proxy command buffer.");
  return Real_slEvaluateFeature(feature, frame, inputs, numInputs, cmdBuffer);
}

// slDLSSSetOptions
extern "C" decltype(&slDLSSSetOptions) Real_slDLSSSetOptions = nullptr;
extern "C" sl::Result Hooked_slDLSSSetOptions(const sl::ViewportHandle& viewport, const sl::DLSSOptions& options) {
  sl::DLSSOptions options_copy = options;
  options_copy.colorBuffersHDR = sl::Boolean::eTrue;
  options_copy.useAutoExposure = sl::Boolean::eTrue;

  return Real_slDLSSSetOptions(viewport, options_copy);
}

// slDLSSGSetOptions
extern "C" decltype(&slDLSSGSetOptions) Real_slDLSSGSetOptions = nullptr;
extern "C" sl::Result Hooked_slDLSSGSetOptions(const sl::ViewportHandle& viewport, const sl::DLSSGOptions& options) {
  sl::DLSSGOptions options_copy = options;
  if (override_dlssg_set_options != nullptr) {
    override_dlssg_set_options(viewport, options_copy);
  }

  return Real_slDLSSGSetOptions(viewport, options_copy);
}

extern "C" decltype(&slDLSSGGetState) Real_slDLSSGGetState = nullptr;
extern "C" sl::Result Hooked_slDLSSGGetState(const sl::ViewportHandle& viewport, sl::DLSSGState& state, const sl::DLSSGOptions* options) {
  return Real_slDLSSGGetState(viewport, state, options);
}

static decltype(&slSetD3DDevice) Real_slSetD3DDevice = nullptr;
static sl::Result Hooked_slSetD3DDevice(void* d3dDevice) {
  auto* native_device = static_cast<IUnknown*>(d3dDevice);
  renodx::utils::directx::NativeFromReShadeProxy(&native_device);

  auto* d3d12_device = static_cast<ID3D12Device*>(native_device);
  auto ret = Real_slSetD3DDevice(native_device);
  if (ret != sl::Result::eOk) {
    log::e(std::format(
               "utils::streamline_v2::slSetD3DDevice() - Real_slSetD3DDevice failed for {:p} with result {}",
               (void*)d3d12_device,
               static_cast<uint32_t>(ret))
               .c_str());
    return ret;
  }

  return ret;
}

static decltype(&slGetFeatureFunction) Real_slGetFeatureFunction = nullptr;
SL_API sl::Result Hooked_slGetFeatureFunction(sl::Feature feature, const char* functionName, void*& function) {
  const auto ret = Real_slGetFeatureFunction(feature, functionName, function);
  if (ret != sl::Result::eOk) {
    return ret;
  }

  switch (feature) {
    case sl::kFeatureDLSS:
      if (std::strcmp(functionName, "slDLSSSetOptions") == 0) {
        Real_slDLSSSetOptions = reinterpret_cast<decltype(&slDLSSSetOptions)>(function);
        function = (void*)&Hooked_slDLSSSetOptions;
        return sl::Result::eOk;
      }
      break;
    case sl::kFeatureDLSS_G:
      if (std::strcmp(functionName, "slDLSSGSetOptions") == 0) {
        Real_slDLSSGSetOptions = reinterpret_cast<decltype(&slDLSSGSetOptions)>(function);
        function = (void*)&Hooked_slDLSSGSetOptions;
        return sl::Result::eOk;
      }
      break;
    default:
      break;
  }
  return ret;
}

// Mirror the legacy signature without naming the deprecated API in a type expression.
static sl::Result (*Real_slSetTag)(const sl::ViewportHandle& viewport, const sl::ResourceTag* tags, uint32_t numTags, sl::CommandBuffer* cmdBuffer) = nullptr;
static sl::Result Hooked_slSetTag(const sl::ViewportHandle& viewport, const sl::ResourceTag* tags, uint32_t numTags, sl::CommandBuffer* cmdBuffer) {
#if defined(DEBUG_LEVEL_2)
  for (auto i = 0u; i < numTags; ++i) {
    const auto& tag = tags[i];
    if (tag.resource == nullptr) continue;
    if (tag.resource->native == nullptr) continue;
    std::stringstream s;
    s << "utils::streamline_v2::slSetTag(";
    switch (tag.type) {
      case sl::kBufferTypeDepth:                                      s << "Depth"; break;
      case sl::kBufferTypeMotionVectors:                              s << "Motion Vectors"; break;
      case sl::kBufferTypeHUDLessColor:                               s << "HUDLess Color"; break;
      case sl::kBufferTypeScalingInputColor:                          s << "Scaling Input Color"; break;
      case sl::kBufferTypeScalingOutputColor:                         s << "Scaling Output Color"; break;
      case sl::kBufferTypeNormals:                                    s << "Normals"; break;
      case sl::kBufferTypeRoughness:                                  s << "Roughness"; break;
      case sl::kBufferTypeAlbedo:                                     s << "Albedo"; break;
      case sl::kBufferTypeSpecularAlbedo:                             s << "Specular Albedo"; break;
      case sl::kBufferTypeIndirectAlbedo:                             s << "Indirect Albedo"; break;
      case sl::kBufferTypeSpecularMotionVectors:                      s << "Specular Motion Vectors"; break;
      case sl::kBufferTypeDisocclusionMask:                           s << "Disocclusion Mask"; break;
      case sl::kBufferTypeEmissive:                                   s << "Emissive"; break;
      case sl::kBufferTypeExposure:                                   s << "Exposure"; break;
      case sl::kBufferTypeNormalRoughness:                            s << "Normal Roughness"; break;
      case sl::kBufferTypeDiffuseHitNoisy:                            s << "Diffuse Hit Noisy"; break;
      case sl::kBufferTypeDiffuseHitDenoised:                         s << "Diffuse Hit Denoised"; break;
      case sl::kBufferTypeSpecularHitNoisy:                           s << "Specular Hit Noisy"; break;
      case sl::kBufferTypeSpecularHitDenoised:                        s << "Specular Hit Denoised"; break;
      case sl::kBufferTypeShadowNoisy:                                s << "Shadow Noisy"; break;
      case sl::kBufferTypeShadowDenoised:                             s << "Shadow Denoised"; break;
      case sl::kBufferTypeAmbientOcclusionNoisy:                      s << "Ambient Occlusion Noisy"; break;
      case sl::kBufferTypeAmbientOcclusionDenoised:                   s << "Ambient Occlusion Denoised"; break;
      case sl::kBufferTypeUIColorAndAlpha:                            s << "UI Color And Alpha"; break;
      case sl::kBufferTypeShadowHint:                                 s << "Shadow Hint"; break;
      case sl::kBufferTypeReflectionHint:                             s << "Reflection Hint"; break;
      case sl::kBufferTypeParticleHint:                               s << "Particle Hint"; break;
      case sl::kBufferTypeTransparencyHint:                           s << "Transparency Hint"; break;
      case sl::kBufferTypeAnimatedTextureHint:                        s << "Animated Texture Hint"; break;
      case sl::kBufferTypeBiasCurrentColorHint:                       s << "Bias Current Color Hint"; break;
      case sl::kBufferTypeRaytracingDistance:                         s << "Raytracing Distance"; break;
      case sl::kBufferTypeReflectionMotionVectors:                    s << "Reflection Motion Vectors"; break;
      case sl::kBufferTypePosition:                                   s << "Position"; break;
      case sl::kBufferTypeInvalidDepthMotionHint:                     s << "Invalid Depth Motion Hint"; break;
      case sl::kBufferTypeAlpha:                                      s << "Alpha"; break;
      case sl::kBufferTypeOpaqueColor:                                s << "Opaque Color"; break;
      case sl::kBufferTypeReactiveMaskHint:                           s << "Reactive Mask Hint"; break;
      case sl::kBufferTypeTransparencyAndCompositionMaskHint:         s << "Transparency And Composition Mask Hint"; break;
      case sl::kBufferTypeReflectedAlbedo:                            s << "Reflected Albedo"; break;
      case sl::kBufferTypeColorBeforeParticles:                       s << "Color Before Particles"; break;
      case sl::kBufferTypeColorBeforeTransparency:                    s << "Color Before Transparency"; break;
      case sl::kBufferTypeColorBeforeFog:                             s << "Color Before Fog"; break;
      case sl::kBufferTypeSpecularHitDistance:                        s << "Specular Hit Distance"; break;
      case sl::kBufferTypeSpecularRayDirectionHitDistance:            s << "Specular Ray Direction Hit Distance"; break;
      case sl::kBufferTypeSpecularRayDirection:                       s << "Specular Ray Direction"; break;
      case sl::kBufferTypeDiffuseHitDistance:                         s << "Diffuse Hit Distance"; break;
      case sl::kBufferTypeDiffuseRayDirectionHitDistance:             s << "Diffuse Ray Direction Hit Distance"; break;
      case sl::kBufferTypeDiffuseRayDirection:                        s << "Diffuse Ray Direction"; break;
      case sl::kBufferTypeHiResDepth:                                 s << "HiRes Depth"; break;
      case sl::kBufferTypeLinearDepth:                                s << "Linear Depth"; break;
      case sl::kBufferTypeBidirectionalDistortionField:               s << "Bidirectional Distortion Field"; break;
      case sl::kBufferTypeTransparencyLayer:                          s << "Transparency Layer"; break;
      case sl::kBufferTypeTransparencyLayerOpacity:                   s << "Transparency Layer Opacity"; break;
      case sl::kBufferTypeBackbuffer:                                 s << "Backbuffer"; break;
      case sl::kBufferTypeNoWarpMask:                                 s << "No Warp Mask"; break;
      case sl::kBufferTypeColorAfterParticles:                        s << "Color After Particles"; break;
      case sl::kBufferTypeColorAfterTransparency:                     s << "Color After Transparency"; break;
      case sl::kBufferTypeColorAfterFog:                              s << "Color After Fog"; break;
      case sl::kBufferTypeScreenSpaceSubsurfaceScatteringGuide:       s << "Screen Space Subsurface Scattering Guide"; break;
      case sl::kBufferTypeColorBeforeScreenSpaceSubsurfaceScattering: s << "Color Before Screen Space Subsurface Scattering"; break;
      case sl::kBufferTypeColorAfterScreenSpaceSubsurfaceScattering:  s << "Color After Screen Space Subsurface Scattering"; break;
      case sl::kBufferTypeScreenSpaceRefractionGuide:                 s << "Screen Space Refraction Guide"; break;
      case sl::kBufferTypeColorBeforeScreenSpaceRefraction:           s << "Color Before Screen Space Refraction"; break;
      case sl::kBufferTypeColorAfterScreenSpaceRefraction:            s << "Color After Screen Space Refraction"; break;
      case sl::kBufferTypeDepthOfFieldGuide:                          s << "Depth Of Field Guide"; break;
      case sl::kBufferTypeColorBeforeDepthOfField:                    s << "Color Before Depth Of Field"; break;
      case sl::kBufferTypeColorAfterDepthOfField:                     s << "Color After Depth Of Field"; break;
      case sl::kBufferTypeScalingOutputAlpha:                         s << "Scaling Output Alpha"; break;
      default:
        s << std::format("Unknown ({})", static_cast<uint32_t>(tag.type));
        break;
    }
    s << ": ";
    s << PRINT_PTR((uintptr_t)tag.resource->native);
    s << ", state: ";
    switch ((D3D12_RESOURCE_STATES)tag.resource->state) {
      case D3D12_RESOURCE_STATE_COMMON:                            s << "Common"; break;
      case D3D12_RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER:        s << "Vertex And Constant Buffer"; break;
      case D3D12_RESOURCE_STATE_INDEX_BUFFER:                      s << "Index Buffer"; break;
      case D3D12_RESOURCE_STATE_RENDER_TARGET:                     s << "Render Target"; break;
      case D3D12_RESOURCE_STATE_UNORDERED_ACCESS:                  s << "Unordered Access"; break;
      case D3D12_RESOURCE_STATE_DEPTH_WRITE:                       s << "Depth Write"; break;
      case D3D12_RESOURCE_STATE_DEPTH_READ:                        s << "Depth Read"; break;
      case D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE:         s << "Non Pixel Shader Resource"; break;
      case D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE:             s << "Pixel Shader Resource"; break;
      case D3D12_RESOURCE_STATE_STREAM_OUT:                        s << "Stream Out"; break;
      case D3D12_RESOURCE_STATE_INDIRECT_ARGUMENT:                 s << "Indirect Argument"; break;
      case D3D12_RESOURCE_STATE_COPY_DEST:                         s << "Copy Destination"; break;
      case D3D12_RESOURCE_STATE_COPY_SOURCE:                       s << "Copy Source"; break;
      case D3D12_RESOURCE_STATE_RESOLVE_DEST:                      s << "Resolve Destination"; break;
      case D3D12_RESOURCE_STATE_RESOLVE_SOURCE:                    s << "Resolve Source"; break;
      case D3D12_RESOURCE_STATE_RAYTRACING_ACCELERATION_STRUCTURE: s << "Raytracing Acceleration Structure"; break;
      case D3D12_RESOURCE_STATE_SHADING_RATE_SOURCE:               s << "Shading Rate Source"; break;
      // case D3D12_RESOURCE_STATE_PREDICATION:                       s << "Predication"; break;
      case D3D12_RESOURCE_STATE_VIDEO_DECODE_READ:   s << "Video Decode Read"; break;
      case D3D12_RESOURCE_STATE_VIDEO_DECODE_WRITE:  s << "Video Decode Write"; break;
      case D3D12_RESOURCE_STATE_VIDEO_PROCESS_READ:  s << "Video Process Read"; break;
      case D3D12_RESOURCE_STATE_VIDEO_PROCESS_WRITE: s << "Video Process Write"; break;
      case D3D12_RESOURCE_STATE_VIDEO_ENCODE_READ:   s << "Video Encode Read"; break;
      case D3D12_RESOURCE_STATE_VIDEO_ENCODE_WRITE:  s << "Video Encode Write"; break;
      default:                                       s << std::format("Unknown ({})", (uint32_t)tag.resource->state); break;
    }

    reshade::api::format resource_format = reshade::api::format::unknown;
    uint64_t clone_handle = 0u;
    reshade::api::format clone_format = reshade::api::format::unknown;
    renodx::utils::resource::GetResourceInfo(
        reshade::api::resource{(uint64_t)tag.resource->native},
        [&resource_format, &clone_handle, &clone_format](const renodx::utils::resource::ResourceInfo& info) {
          resource_format = info.desc.texture.format;
          clone_handle = info.clone.handle;
          clone_format = info.clone_desc.texture.format;
        });
    s << ", format: " << resource_format;
    if (clone_handle != 0u) {
      s << ", clone: ";
      s << PRINT_PTR(clone_handle);
      s << ", clone-format: ";
      s << clone_format;
    }

    s << ")";
    log::d(s.str());
  }
#endif

  sl::ResourceTag* new_tags = nullptr;
  std::vector<sl::Resource> rewritten_resources = {};
  for (auto i = 0u; i < numTags; ++i) {
    const auto& tag = tags[i];
    // if (tag.type == sl::kBufferTypeBackbuffer) continue;
    if (tag.resource == nullptr) continue;
    if (tag.resource->native == nullptr) continue;

    // if (tag.type == sl::kBufferTypeUIColorAndAlpha || tag.type == sl::kBufferTypeBackbuffer || tag.type == sl::kBufferTypeHUDLessColor) {
    //   if (new_tags == nullptr) {
    //     auto size = sizeof(sl::ResourceTag) * numTags;
    //     new_tags = reinterpret_cast<sl::ResourceTag*>(malloc(sizeof(sl::ResourceTag) * numTags));
    //     memcpy(new_tags, tags, sizeof(sl::ResourceTag) * numTags);
    //   }

    //   sl::Resource resource = {tag.resource->type, nullptr, new_tags[i].resource->state};
    //   resources.emplace_back(tag.resource->type, nullptr, D3D12_RESOURCE_STATE_COMMON);
    //   auto new_sl_resource_tag = sl::ResourceTag(&resources.back(), tag.type, tag.lifecycle, &tag.extent);
    //   new_tags[i] = new_sl_resource_tag;
    // } else {
    void* redirected_native = tag.resource->native;
    const auto found = renodx::utils::resource::GetResourceInfo(
        reshade::api::resource{(uint64_t)tag.resource->native},
        [&redirected_native](const renodx::utils::resource::ResourceInfo& info) {
          if (info.clone_enabled && info.clone.handle != 0u) {
            redirected_native = reinterpret_cast<void*>(info.clone.handle);
          }
        });
    if (!found) {
      log::e(std::format("utils::streamline_v2::slSetTag() - Resource info not found for resource: {}", (void*)tag.resource->native).c_str());
      continue;
    }

    if (redirected_native != tag.resource->native) {
      if (new_tags == nullptr) {
        auto size = sizeof(sl::ResourceTag) * numTags;
        new_tags = reinterpret_cast<sl::ResourceTag*>(malloc(sizeof(sl::ResourceTag) * numTags));
        memcpy(new_tags, tags, sizeof(sl::ResourceTag) * numTags);
        rewritten_resources.reserve(numTags);
      }

      rewritten_resources.emplace_back(tag.resource->type, redirected_native, tag.resource->state);
      auto new_sl_resource_tag = sl::ResourceTag(&rewritten_resources.back(), tag.type, tag.lifecycle, &tag.extent);
      new_tags[i] = new_sl_resource_tag;
    }
    // }
  }

  const bool unwrapped = utils::directx::NativeFromReShadeProxy(&cmdBuffer);
  assert((unwrapped || cmdBuffer == nullptr) && "slSetTag expected a ReShade proxy command buffer.");

  // return sl::Result::eOk;
  if (new_tags == nullptr) {
    return Real_slSetTag(viewport, tags, numTags, cmdBuffer);
  }

  sl::Result result = Real_slSetTag(viewport, new_tags, numTags, cmdBuffer);
  free(new_tags);
  new_tags = nullptr;
  return result;
}

static decltype(&slSetTagForFrame) Real_slSetTagForFrame = nullptr;
static sl::Result Hooked_slSetTagForFrame(const sl::FrameToken& frame, const sl::ViewportHandle& viewport, const sl::ResourceTag* tags, uint32_t numTags, sl::CommandBuffer* cmdBuffer) {
  (void)frame;
#if defined(DEBUG_LEVEL_2)
  for (auto i = 0u; i < numTags; ++i) {
    const auto& tag = tags[i];
    if (tag.resource == nullptr) continue;
    if (tag.resource->native == nullptr) continue;
    std::stringstream s;
    s << "utils::streamline_v2::slSetTagForFrame(";
    switch (tag.type) {
      case sl::kBufferTypeDepth:                                      s << "Depth"; break;
      case sl::kBufferTypeMotionVectors:                              s << "Motion Vectors"; break;
      case sl::kBufferTypeHUDLessColor:                               s << "HUDLess Color"; break;
      case sl::kBufferTypeScalingInputColor:                          s << "Scaling Input Color"; break;
      case sl::kBufferTypeScalingOutputColor:                         s << "Scaling Output Color"; break;
      case sl::kBufferTypeNormals:                                    s << "Normals"; break;
      case sl::kBufferTypeRoughness:                                  s << "Roughness"; break;
      case sl::kBufferTypeAlbedo:                                     s << "Albedo"; break;
      case sl::kBufferTypeSpecularAlbedo:                             s << "Specular Albedo"; break;
      case sl::kBufferTypeIndirectAlbedo:                             s << "Indirect Albedo"; break;
      case sl::kBufferTypeSpecularMotionVectors:                      s << "Specular Motion Vectors"; break;
      case sl::kBufferTypeDisocclusionMask:                           s << "Disocclusion Mask"; break;
      case sl::kBufferTypeEmissive:                                   s << "Emissive"; break;
      case sl::kBufferTypeExposure:                                   s << "Exposure"; break;
      case sl::kBufferTypeNormalRoughness:                            s << "Normal Roughness"; break;
      case sl::kBufferTypeDiffuseHitNoisy:                            s << "Diffuse Hit Noisy"; break;
      case sl::kBufferTypeDiffuseHitDenoised:                         s << "Diffuse Hit Denoised"; break;
      case sl::kBufferTypeSpecularHitNoisy:                           s << "Specular Hit Noisy"; break;
      case sl::kBufferTypeSpecularHitDenoised:                        s << "Specular Hit Denoised"; break;
      case sl::kBufferTypeShadowNoisy:                                s << "Shadow Noisy"; break;
      case sl::kBufferTypeShadowDenoised:                             s << "Shadow Denoised"; break;
      case sl::kBufferTypeAmbientOcclusionNoisy:                      s << "Ambient Occlusion Noisy"; break;
      case sl::kBufferTypeAmbientOcclusionDenoised:                   s << "Ambient Occlusion Denoised"; break;
      case sl::kBufferTypeUIColorAndAlpha:                            s << "UI Color And Alpha"; break;
      case sl::kBufferTypeShadowHint:                                 s << "Shadow Hint"; break;
      case sl::kBufferTypeReflectionHint:                             s << "Reflection Hint"; break;
      case sl::kBufferTypeParticleHint:                               s << "Particle Hint"; break;
      case sl::kBufferTypeTransparencyHint:                           s << "Transparency Hint"; break;
      case sl::kBufferTypeAnimatedTextureHint:                        s << "Animated Texture Hint"; break;
      case sl::kBufferTypeBiasCurrentColorHint:                       s << "Bias Current Color Hint"; break;
      case sl::kBufferTypeRaytracingDistance:                         s << "Raytracing Distance"; break;
      case sl::kBufferTypeReflectionMotionVectors:                    s << "Reflection Motion Vectors"; break;
      case sl::kBufferTypePosition:                                   s << "Position"; break;
      case sl::kBufferTypeInvalidDepthMotionHint:                     s << "Invalid Depth Motion Hint"; break;
      case sl::kBufferTypeAlpha:                                      s << "Alpha"; break;
      case sl::kBufferTypeOpaqueColor:                                s << "Opaque Color"; break;
      case sl::kBufferTypeReactiveMaskHint:                           s << "Reactive Mask Hint"; break;
      case sl::kBufferTypeTransparencyAndCompositionMaskHint:         s << "Transparency And Composition Mask Hint"; break;
      case sl::kBufferTypeReflectedAlbedo:                            s << "Reflected Albedo"; break;
      case sl::kBufferTypeColorBeforeParticles:                       s << "Color Before Particles"; break;
      case sl::kBufferTypeColorBeforeTransparency:                    s << "Color Before Transparency"; break;
      case sl::kBufferTypeColorBeforeFog:                             s << "Color Before Fog"; break;
      case sl::kBufferTypeSpecularHitDistance:                        s << "Specular Hit Distance"; break;
      case sl::kBufferTypeSpecularRayDirectionHitDistance:            s << "Specular Ray Direction Hit Distance"; break;
      case sl::kBufferTypeSpecularRayDirection:                       s << "Specular Ray Direction"; break;
      case sl::kBufferTypeDiffuseHitDistance:                         s << "Diffuse Hit Distance"; break;
      case sl::kBufferTypeDiffuseRayDirectionHitDistance:             s << "Diffuse Ray Direction Hit Distance"; break;
      case sl::kBufferTypeDiffuseRayDirection:                        s << "Diffuse Ray Direction"; break;
      case sl::kBufferTypeHiResDepth:                                 s << "HiRes Depth"; break;
      case sl::kBufferTypeLinearDepth:                                s << "Linear Depth"; break;
      case sl::kBufferTypeBidirectionalDistortionField:               s << "Bidirectional Distortion Field"; break;
      case sl::kBufferTypeTransparencyLayer:                          s << "Transparency Layer"; break;
      case sl::kBufferTypeTransparencyLayerOpacity:                   s << "Transparency Layer Opacity"; break;
      case sl::kBufferTypeBackbuffer:                                 s << "Backbuffer"; break;
      case sl::kBufferTypeNoWarpMask:                                 s << "No Warp Mask"; break;
      case sl::kBufferTypeColorAfterParticles:                        s << "Color After Particles"; break;
      case sl::kBufferTypeColorAfterTransparency:                     s << "Color After Transparency"; break;
      case sl::kBufferTypeColorAfterFog:                              s << "Color After Fog"; break;
      case sl::kBufferTypeScreenSpaceSubsurfaceScatteringGuide:       s << "Screen Space Subsurface Scattering Guide"; break;
      case sl::kBufferTypeColorBeforeScreenSpaceSubsurfaceScattering: s << "Color Before Screen Space Subsurface Scattering"; break;
      case sl::kBufferTypeColorAfterScreenSpaceSubsurfaceScattering:  s << "Color After Screen Space Subsurface Scattering"; break;
      case sl::kBufferTypeScreenSpaceRefractionGuide:                 s << "Screen Space Refraction Guide"; break;
      case sl::kBufferTypeColorBeforeScreenSpaceRefraction:           s << "Color Before Screen Space Refraction"; break;
      case sl::kBufferTypeColorAfterScreenSpaceRefraction:            s << "Color After Screen Space Refraction"; break;
      case sl::kBufferTypeDepthOfFieldGuide:                          s << "Depth Of Field Guide"; break;
      case sl::kBufferTypeColorBeforeDepthOfField:                    s << "Color Before Depth Of Field"; break;
      case sl::kBufferTypeColorAfterDepthOfField:                     s << "Color After Depth Of Field"; break;
      case sl::kBufferTypeScalingOutputAlpha:                         s << "Scaling Output Alpha"; break;
      default:
        s << std::format("Unknown ({})", static_cast<uint32_t>(tag.type));
        break;
    }
    s << ": ";
    s << PRINT_PTR((uintptr_t)tag.resource->native);
    s << ", state: ";
    switch ((D3D12_RESOURCE_STATES)tag.resource->state) {
      case D3D12_RESOURCE_STATE_COMMON:                            s << "Common"; break;
      case D3D12_RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER:        s << "Vertex And Constant Buffer"; break;
      case D3D12_RESOURCE_STATE_INDEX_BUFFER:                      s << "Index Buffer"; break;
      case D3D12_RESOURCE_STATE_RENDER_TARGET:                     s << "Render Target"; break;
      case D3D12_RESOURCE_STATE_UNORDERED_ACCESS:                  s << "Unordered Access"; break;
      case D3D12_RESOURCE_STATE_DEPTH_WRITE:                       s << "Depth Write"; break;
      case D3D12_RESOURCE_STATE_DEPTH_READ:                        s << "Depth Read"; break;
      case D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE:         s << "Non Pixel Shader Resource"; break;
      case D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE:             s << "Pixel Shader Resource"; break;
      case D3D12_RESOURCE_STATE_STREAM_OUT:                        s << "Stream Out"; break;
      case D3D12_RESOURCE_STATE_INDIRECT_ARGUMENT:                 s << "Indirect Argument"; break;
      case D3D12_RESOURCE_STATE_COPY_DEST:                         s << "Copy Destination"; break;
      case D3D12_RESOURCE_STATE_COPY_SOURCE:                       s << "Copy Source"; break;
      case D3D12_RESOURCE_STATE_RESOLVE_DEST:                      s << "Resolve Destination"; break;
      case D3D12_RESOURCE_STATE_RESOLVE_SOURCE:                    s << "Resolve Source"; break;
      case D3D12_RESOURCE_STATE_RAYTRACING_ACCELERATION_STRUCTURE: s << "Raytracing Acceleration Structure"; break;
      case D3D12_RESOURCE_STATE_SHADING_RATE_SOURCE:               s << "Shading Rate Source"; break;
      // case D3D12_RESOURCE_STATE_PREDICATION:                       s << "Predication"; break;
      case D3D12_RESOURCE_STATE_VIDEO_DECODE_READ:   s << "Video Decode Read"; break;
      case D3D12_RESOURCE_STATE_VIDEO_DECODE_WRITE:  s << "Video Decode Write"; break;
      case D3D12_RESOURCE_STATE_VIDEO_PROCESS_READ:  s << "Video Process Read"; break;
      case D3D12_RESOURCE_STATE_VIDEO_PROCESS_WRITE: s << "Video Process Write"; break;
      case D3D12_RESOURCE_STATE_VIDEO_ENCODE_READ:   s << "Video Encode Read"; break;
      case D3D12_RESOURCE_STATE_VIDEO_ENCODE_WRITE:  s << "Video Encode Write"; break;
      default:                                       s << std::format("Unknown ({})", (uint32_t)tag.resource->state); break;
    }

    reshade::api::format resource_format = reshade::api::format::unknown;
    uint64_t clone_handle = 0u;
    reshade::api::format clone_format = reshade::api::format::unknown;
    renodx::utils::resource::GetResourceInfo(
        reshade::api::resource{(uint64_t)tag.resource->native},
        [&resource_format, &clone_handle, &clone_format](const renodx::utils::resource::ResourceInfo& info) {
          resource_format = info.desc.texture.format;
          clone_handle = info.clone.handle;
          clone_format = info.clone_desc.texture.format;
        });
    s << ", format: " << resource_format;
    if (clone_handle != 0u) {
      s << ", clone: ";
      s << PRINT_PTR(clone_handle);
      s << ", clone-format: ";
      s << clone_format;
    }

    s << ")";
    log::d(s.str());
  }
#endif

  sl::ResourceTag* new_tags = nullptr;
  std::vector<sl::Resource> rewritten_resources = {};
  for (auto i = 0u; i < numTags; ++i) {
    const auto& tag = tags[i];
    if (tag.type == sl::kBufferTypeBackbuffer) continue;
    if (tag.resource == nullptr) continue;
    if (tag.resource->native == nullptr) continue;
    void* redirected_native = tag.resource->native;
    const auto found = renodx::utils::resource::GetResourceInfo(
        reshade::api::resource{(uint64_t)tag.resource->native},
        [&redirected_native](const renodx::utils::resource::ResourceInfo& info) {
          if (info.clone_enabled && info.clone.handle != 0u) {
            redirected_native = reinterpret_cast<void*>(info.clone.handle);
          }
        });
    if (!found) {
      log::e(std::format("utils::streamline_v2::slSetTagForFrame() - Resource info not found for resource: {}", (void*)tag.resource->native).c_str());
      continue;
    }

    if (redirected_native != tag.resource->native) {
      if (new_tags == nullptr) {
        auto size = sizeof(sl::ResourceTag) * numTags;
        new_tags = reinterpret_cast<sl::ResourceTag*>(malloc(sizeof(sl::ResourceTag) * numTags));
        memcpy(new_tags, tags, sizeof(sl::ResourceTag) * numTags);
        rewritten_resources.reserve(numTags);
      }

      rewritten_resources.emplace_back(tag.resource->type, redirected_native, tag.resource->state);
      auto new_sl_resource_tag = sl::ResourceTag(&rewritten_resources.back(), tag.type, tag.lifecycle, &tag.extent);
      new_tags[i] = new_sl_resource_tag;
    }
  }

  const bool unwrapped = utils::directx::NativeFromReShadeProxy(&cmdBuffer);
  assert((unwrapped || cmdBuffer == nullptr) && "slSetTagForFrame expected a ReShade proxy command buffer.");

  if (new_tags == nullptr) {
    return Real_slSetTagForFrame(frame, viewport, tags, numTags, cmdBuffer);
  }

  sl::Result result = Real_slSetTagForFrame(frame, viewport, new_tags, numTags, cmdBuffer);
  free(new_tags);
  new_tags = nullptr;
  return result;
}

static const std::vector<std::tuple<const char*, void**, void*>> INTERPOSER_HOOKS = {
    {"slInit", reinterpret_cast<void**>(&Real_slInit), &Hooked_slInit},
    {"slSetTag", reinterpret_cast<void**>(&Real_slSetTag), &Hooked_slSetTag},
    {"slSetD3DDevice", reinterpret_cast<void**>(&Real_slSetD3DDevice), &Hooked_slSetD3DDevice},
    {"slSetTagForFrame", reinterpret_cast<void**>(&Real_slSetTagForFrame), &Hooked_slSetTagForFrame},
    {"slUpgradeInterface", reinterpret_cast<void**>(&Real_slUpgradeInterface), &Hooked_slUpgradeInterface},
    {"slEvaluateFeature", (void**)&Real_slEvaluateFeature, &Hooked_slEvaluateFeature},
    {"slGetFeatureFunction", (void**)&Real_slGetFeatureFunction, &Hooked_slGetFeatureFunction},
    {"slGetNativeInterface", (void**)&Real_slGetNativeInterface, &Hooked_slGetNativeInterface},
    {"CreateDXGIFactory", (void**)&Real_CreateDXGIFactory, &Hooked_CreateDXGIFactory},
    {"CreateDXGIFactory1", (void**)&Real_CreateDXGIFactory1, &Hooked_CreateDXGIFactory1},
    {"CreateDXGIFactory2", (void**)&Real_CreateDXGIFactory2, &Hooked_CreateDXGIFactory2},
    {"D3D12CreateDevice", (void**)&Real_D3D12CreateDevice, &Hooked_D3D12CreateDevice},
};

}  // namespace renodx::utils::streamline::v2
