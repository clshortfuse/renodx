/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <d3d9.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <windef.h>
#include <windows.h>

#include <atomic>
#include <cassert>
#include <cstdint>
#include <include/reshade_api_device.hpp>
#include <include/reshade_api_format.hpp>
#include <memory>
#include <unordered_map>

#include <include/reshade.hpp>

#include "./cross_addon.hpp"
#include "./data.hpp"
#include "./device_upgrade.hpp"
#include "./directx.hpp"
#include "./draw.hpp"
#include "./resource.hpp"
#include "./resource_upgrade.hpp"

namespace renodx::utils::device_proxy {

struct __declspec(uuid("c6ae1da2-a798-4a94-9ec9-02d728ba0aef")) SharedData {
  std::atomic<bool> use_device_proxy = false;
  std::atomic<bool> remove_device_proxy = false;
  std::atomic<reshade::api::format> target_format = reshade::api::format::r16g16b16a16_float;
  std::atomic<reshade::api::color_space> target_color_space = reshade::api::color_space::extended_srgb_linear;
  std::atomic<reshade::api::format> target_intermediate_format = reshade::api::format::r16g16b16a16_float;
  std::atomic<bool> settings_dirty = false;
  std::atomic<bool> is_creating_proxy_device = false;
  std::atomic<bool> is_creating_proxy_swapchain = false;
  std::atomic<uintptr_t> proxy_native_device = 0u;
  std::atomic<reshade::api::device*> proxy_reshade_device = nullptr;
};

static cross_addon::Shared<SharedData> shared;
static bool use_device_proxy = false;
static reshade::api::format target_format = reshade::api::format::unknown;
static reshade::api::color_space target_color_space = reshade::api::color_space::unknown;
static reshade::api::format target_intermediate_format = reshade::api::format::unknown;
static bool device_proxy_wait_idle_source = false;
static bool device_proxy_wait_idle_destination = false;
static reshade::api::resource last_device_proxy_shared_resource = {0u};

static thread_local bool is_creating_proxy_device = false;
static thread_local bool is_creating_proxy_swapchain = false;

static IDXGISwapChain1* proxy_swap_chain = nullptr;
static ID3D11Device* proxy_device = nullptr;
static ID3D11DeviceContext* proxy_device_context = nullptr;
static reshade::api::device* proxy_device_reshade = nullptr;
static reshade::api::device* proxied_device_reshade = nullptr;
static reshade::api::swapchain* proxy_swapchain_reshade = nullptr;
static reshade::api::resource proxy_device_resource = {0u};

static bool IsProxyNativeDevice(const reshade::api::device* device) {
  if (device == nullptr) return false;
  const auto native_device = device->get_native();
  if (native_device == 0u) return false;
  if (native_device == reinterpret_cast<uint64_t>(proxy_device)) return true;

  if (shared.data == nullptr) return false;
  return native_device == shared.data->proxy_native_device;
}

inline bool IsCreatingProxyDevice() {
  return is_creating_proxy_device
         || (shared.data != nullptr && shared.data->is_creating_proxy_device);
}

inline bool IsCreatingProxySwapchain() {
  return is_creating_proxy_swapchain
         || (shared.data != nullptr && shared.data->is_creating_proxy_swapchain);
}

inline bool IsProxyDevice(const reshade::api::device* device) {
  if (device == nullptr) return false;
  if (device == proxy_device_reshade || IsProxyNativeDevice(device)) return true;

  return shared.data != nullptr
         && device == shared.data->proxy_reshade_device;
}

static void* swap_chain_device_proxy = nullptr;
static std::atomic<bool> proxy_device_needs_resize = false;
static std::atomic<uint32_t> proxy_resize_width = 0;
static std::atomic<uint32_t> proxy_resize_height = 0;
static std::atomic<UINT> proxy_present_flags = DXGI_PRESENT_ALLOW_TEARING;
static std::atomic<uint32_t> proxy_swapchain_last_width = 0;
static std::atomic<uint32_t> proxy_swapchain_last_height = 0;
static std::atomic<uintptr_t> proxy_swapchain_last_hwnd = 0;
static std::atomic<bool> proxy_present_test_pending = true;
static std::atomic<uint32_t> proxy_invalid_call_streak = 0;
static std::atomic<uint32_t> proxy_teardown_deferred_presents = 0;
static std::atomic<bool> proxy_same_hwnd_flip_established = false;

static bool device_proxy_creation_failed = false;
static renodx::utils::resource::ResourceUpgradeInfo proxy_clone_target = {
    .new_format = reshade::api::format::r16g16b16a16_float,
    .use_resource_view_hot_swap = true,
    .usage_set =
        static_cast<uint32_t>(reshade::api::resource_usage::shader_resource
                              | reshade::api::resource_usage::render_target),
    .view_upgrades = utils::resource::VIEW_UPGRADES_RGBA16F,
    .use_resource_view_cloning_and_upgrade = true,
};
static renodx::utils::draw::SwapchainProxyPass local_proxy_swapchain_settings = {};
static bool local_proxy_swapchain_settings_valid = false;
static bool local_proxy_settings_dirty = false;
static uintptr_t local_proxy_swapchain_hwnd_override = 0u;
static bool local_proxy_same_hwnd_non_flip_bootstrap = false;
static std::unordered_map<uint64_t, std::unique_ptr<renodx::utils::draw::SwapchainProxyPass>> proxy_swapchain_passes;

struct ProxySharedResourcePair {
  reshade::api::resource host_shared_resource = {0u};
  reshade::api::resource proxy_shared_resource = {0u};
};
struct ProxySharedResourceSource {
  reshade::api::device* device = nullptr;
  reshade::api::resource_desc desc;
  reshade::api::resource_desc clone_desc;
  reshade::api::resource_usage initial_state = reshade::api::resource_usage::undefined;
};
static std::unordered_map<uint64_t, ProxySharedResourcePair> proxy_shared_resources_by_clone;

// Methods
static void DestroyProxySharedResourcesForHandle(uint64_t handle);

static void DeactivateProxyCloneForResource(const reshade::api::resource& resource) {
  if (resource.handle == 0u) return;
  std::vector<uint64_t> resource_view_handles;
  renodx::utils::resource::UpdateResourceInfo(resource, [&](renodx::utils::resource::ResourceInfo* info) {
    if (info->clone_target == &proxy_clone_target && info->clone_can_deactivate) {
      info->clone_enabled = false;
      info->clone_can_deactivate = false;
      resource_view_handles.assign(info->resource_view_handles.begin(), info->resource_view_handles.end());
    }
  });
  renodx::utils::resource::upgrade::UpdateResourceViewsCloneState(resource_view_handles, false, false);
}

static void ResetProxyCloneForResource(const reshade::api::resource& resource) {
  if (resource.handle == 0u) return;

  reshade::api::device* device = nullptr;
  reshade::api::resource clone = {0u};
  bool has_proxy_clone_target = false;
  const auto found_info = renodx::utils::resource::GetResourceInfo(resource, [&](const renodx::utils::resource::ResourceInfo& info) {
    if (info.destroyed) return;
    has_proxy_clone_target = info.clone_target == &proxy_clone_target;
    if (!has_proxy_clone_target) return;
    device = info.device;
    clone = info.clone;
  });
  if (!found_info || !has_proxy_clone_target) return;

  std::vector<std::pair<uint64_t, uint64_t>> stale_clone_views;
  renodx::utils::resource::ForEachResourceViewInfo([&](const auto& view_info) {
    if (view_info.destroyed) return;
    if (view_info.original_resource.handle != resource.handle) return;
    if (view_info.clone.handle == 0u) return;
    stale_clone_views.emplace_back(view_info.view.handle, view_info.clone.handle);
  });
  for (const auto& [owner_view_handle, clone_view_handle] : stale_clone_views) {
    renodx::utils::resource::UpdateResourceViewInfo({owner_view_handle}, [&](renodx::utils::resource::ResourceViewInfo* owner_view_info) {
      if (owner_view_info->clone.handle != clone_view_handle) return;
      owner_view_info->clone = {0u};
      owner_view_info->clone_resource = {0u};
      owner_view_info->clone_desc = {};
    });
    if (device != nullptr) {
      device->destroy_resource_view({clone_view_handle});
    }
  }

  DestroyProxySharedResourcesForHandle(clone.handle);
  if (clone.handle != 0u && device != nullptr) {
    device->destroy_resource(clone);
  }
  renodx::utils::resource::UpdateResourceInfo(resource, [&](renodx::utils::resource::ResourceInfo* info) {
    if (info->clone_target != &proxy_clone_target) return;
    info->clone = {0u};
    info->clone_desc = {};
  });
}

static void DeactivateProxySwapchainClones(reshade::api::swapchain* swapchain) {
  if (swapchain == nullptr) return;
  const uint32_t back_buffer_count = swapchain->get_back_buffer_count();
  for (uint32_t index = 0; index < back_buffer_count; ++index) {
    DeactivateProxyCloneForResource(swapchain->get_back_buffer(index));
  }
}

static void ResetProxySwapchainCloneResources(reshade::api::swapchain* swapchain) {
  if (swapchain == nullptr) return;
  const uint32_t back_buffer_count = swapchain->get_back_buffer_count();
  for (uint32_t index = 0; index < back_buffer_count; ++index) {
    ResetProxyCloneForResource(swapchain->get_back_buffer(index));
  }
}

static void DestroyProxySharedResourcePair(ProxySharedResourcePair& pair) {
  if (pair.host_shared_resource.handle != 0u && proxied_device_reshade != nullptr) {
    proxied_device_reshade->destroy_resource(pair.host_shared_resource);
    pair.host_shared_resource = {0u};
  }

  if (pair.proxy_shared_resource.handle != 0u) {
    if (last_device_proxy_shared_resource.handle == pair.proxy_shared_resource.handle) {
      last_device_proxy_shared_resource = {0u};
    }
    if (proxy_device_reshade != nullptr) {
      proxy_device_reshade->destroy_resource(pair.proxy_shared_resource);
    }
    pair.proxy_shared_resource = {0u};
  }
}

static void DestroyProxySharedResourcesForHandle(uint64_t handle) {
  if (handle == 0u) return;

  if (auto it = proxy_shared_resources_by_clone.find(handle);
      it != proxy_shared_resources_by_clone.end()) {
    auto pair = it->second;
    proxy_shared_resources_by_clone.erase(it);
    DestroyProxySharedResourcePair(pair);
    return;
  }

  for (auto it_pair = proxy_shared_resources_by_clone.begin();
       it_pair != proxy_shared_resources_by_clone.end(); ++it_pair) {
    const auto& pair = it_pair->second;
    if (pair.host_shared_resource.handle != handle
        && pair.proxy_shared_resource.handle != handle) {
      continue;
    }

    auto pair_copy = it_pair->second;
    proxy_shared_resources_by_clone.erase(it_pair);
    DestroyProxySharedResourcePair(pair_copy);
    return;
  }
}

static void OnDestroyTrackedResourceInfo(renodx::utils::resource::ResourceInfo* info) {
  if (!shared.IsEventHandler()) return;
  if (info == nullptr) return;
  DestroyProxySharedResourcesForHandle(info->resource.handle);
  DestroyProxySharedResourcesForHandle(info->clone.handle);
}

static void DestroyProxyDeviceResources(reshade::api::device* device) {
  std::unordered_map<uint64_t, ProxySharedResourcePair> pairs;
  pairs.swap(proxy_shared_resources_by_clone);
  for (auto& [clone_handle, pair] : pairs) {
    DestroyProxySharedResourcePair(pair);
  }
  last_device_proxy_shared_resource = {0u};
  if (device == nullptr) return;
  if (proxy_device_resource.handle != 0u) {
    device->destroy_resource(proxy_device_resource);
    proxy_device_resource = {0u};
  }
}

static void SetProxyEnabled(bool enabled) {
  use_device_proxy = enabled;
  if (enabled) {
    device_proxy_creation_failed = false;
  }
  if (shared.data == nullptr) return;
  if (shared.data->use_device_proxy == enabled) return;
  shared.data->use_device_proxy = enabled;
  shared.data->settings_dirty = true;
}

static bool UseProxyRequested() {
  return use_device_proxy || (shared.data != nullptr && shared.data->use_device_proxy);
}

static void SetProxyRemovePending(bool pending) {
  if (shared.data == nullptr) return;
  if (shared.data->remove_device_proxy == pending) return;
  shared.data->remove_device_proxy = pending;
  shared.data->settings_dirty = true;
}

static void SetTargetFormat(reshade::api::format format) {
  target_format = format;
  if (shared.data == nullptr) return;
  if (shared.data->target_format == format) return;
  shared.data->target_format = format;
  local_proxy_settings_dirty = true;
  shared.data->settings_dirty = true;
}

static void SetTargetColorSpace(reshade::api::color_space color_space) {
  target_color_space = color_space;
  if (shared.data == nullptr) return;
  if (shared.data->target_color_space == color_space) return;
  shared.data->target_color_space = color_space;
  local_proxy_settings_dirty = true;
  shared.data->settings_dirty = true;
}

static void SetIntermediateFormat(reshade::api::format format) {
  target_intermediate_format = format;
  if (shared.data == nullptr) return;
  if (shared.data->target_intermediate_format == format) return;
  shared.data->target_intermediate_format = format;
  local_proxy_settings_dirty = true;
  shared.data->settings_dirty = true;
}

static void SetProxySettings(const renodx::utils::draw::SwapchainProxyPass& settings) {
  local_proxy_swapchain_settings = settings;
  local_proxy_swapchain_settings_valid = true;
  local_proxy_settings_dirty = true;
}

static void SetSameHwndNonFlipBootstrap(bool enabled) {
  const bool changed = local_proxy_same_hwnd_non_flip_bootstrap != enabled;
  local_proxy_same_hwnd_non_flip_bootstrap = enabled;
  if (changed) {
    local_proxy_settings_dirty = true;
  }
}

static void DestroyProxySwapchainPasses(reshade::api::device* device) {
  for (auto& [handle, pass] : proxy_swapchain_passes) {
    if (pass) {
      pass->pass.DestroyAll(device);
    }
  }
  proxy_swapchain_passes.clear();
}

static ID3D11Device* GetDeviceProxy(const reshade::api::resource_desc& host_resource_desc, HWND hwnd = nullptr) {
  if (!shared.IsEventHandler()) return nullptr;
  if (shared.data == nullptr) return nullptr;
  if (device_proxy_creation_failed) return nullptr;
  if (proxy_device != nullptr && proxy_swap_chain != nullptr) {
    return proxy_device;
  }
  if (!renodx::utils::directx::Initialize()) return nullptr;

  // New: Moved factory to after device

  DXGI_SWAP_CHAIN_FULLSCREEN_DESC fullscreen_desc = {};
  DXGI_SWAP_CHAIN_DESC1 sc_desc = {};
  sc_desc.BufferCount = 2u;
  sc_desc.Width = host_resource_desc.texture.width;
  sc_desc.Height = host_resource_desc.texture.height;
  const reshade::api::format current_target_format = shared.data->target_format;
  switch (current_target_format) {
    default:
      assert(false);
    case reshade::api::format::r16g16b16a16_float:
      sc_desc.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
      break;
    case reshade::api::format::r10g10b10a2_unorm:
      sc_desc.Format = DXGI_FORMAT_R10G10B10A2_UNORM;
      break;
    case reshade::api::format::r8g8b8a8_unorm:
      sc_desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
      break;
  }
  fullscreen_desc.RefreshRate.Numerator = 0;
  fullscreen_desc.RefreshRate.Denominator = 0;
  sc_desc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
  auto* output_window = hwnd != nullptr ? hwnd : GetDesktopWindow();
  auto* override_window = reinterpret_cast<HWND>(local_proxy_swapchain_hwnd_override);
  if (override_window != nullptr) {
    if (IsWindow(override_window) != FALSE) {
      output_window = override_window;
    } else {
      local_proxy_swapchain_hwnd_override = 0u;
    }
  }
  sc_desc.SampleDesc.Count = 1;
  fullscreen_desc.Windowed = TRUE;
  sc_desc.SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD;
  sc_desc.Flags = 0;

  sc_desc.Stereo = FALSE;
  sc_desc.SampleDesc.Quality = 0;
  sc_desc.AlphaMode = DXGI_ALPHA_MODE_UNSPECIFIED;
  sc_desc.Scaling = DXGI_SCALING_STRETCH;
  fullscreen_desc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;

  if (proxy_device == nullptr) {
    UINT create_flags = D3D11_CREATE_DEVICE_SINGLETHREADED;
    D3D_FEATURE_LEVEL feature_level;

    assert(is_creating_proxy_device == false);
    assert(proxy_device_reshade == nullptr);
    is_creating_proxy_device = true;
    if (shared.data != nullptr) shared.data->is_creating_proxy_device = true;
    const HRESULT create_device_hr = renodx::utils::directx::pD3D11CreateDevice(
        nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr, create_flags,
        nullptr, 0, D3D11_SDK_VERSION, &proxy_device, &feature_level, &proxy_device_context);
    is_creating_proxy_device = false;
    if (shared.data != nullptr) shared.data->is_creating_proxy_device = false;
    if (FAILED(create_device_hr)) {
      proxy_device = nullptr;
      proxy_device_context = nullptr;
      return nullptr;
    }
    if (proxy_device_reshade == nullptr) {
      reshade::log::message(reshade::log::level::error, "utils::device_proxy::GetDeviceProxy(D3D11CreateDevice succeeded but Reshade device is null)");
      // Reshade is not hooked to DX11
      assert(proxy_device_reshade != nullptr);
      if (proxy_device != nullptr) {
        proxy_device->Release();
        proxy_device = nullptr;
      }
      device_proxy_creation_failed = true;
      return nullptr;
    }
  } else if (proxy_device_context == nullptr) {
    proxy_device->GetImmediateContext(&proxy_device_context);
  }

  IUnknown* swapchain_creator = proxy_device;

  if (proxy_swap_chain != nullptr) {
    return proxy_device;
  }

  IDXGIFactory2* dxgi_factory = nullptr;

  {
    RECT client_rect = {};
    if (output_window == nullptr || IsWindow(output_window) == FALSE || GetClientRect(output_window, &client_rect) == 0) {
      std::stringstream s;
      s << "utils::device_proxy::GetDeviceProxy(abort: invalid hwnd, hwnd=";
      s << PRINT_PTR(reinterpret_cast<uintptr_t>(output_window));
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      return nullptr;
    }
    const auto client_width = client_rect.right - client_rect.left;
    const auto client_height = client_rect.bottom - client_rect.top;
    if (client_width <= 0 || client_height <= 0) {
      std::stringstream s;
      s << "utils::device_proxy::GetDeviceProxy(abort: zero client size, hwnd=";
      s << PRINT_PTR(reinterpret_cast<uintptr_t>(output_window));
      s << ", rect=" << client_rect.left << "," << client_rect.top;
      s << " " << client_width << "x" << client_height;
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      return nullptr;
    }
  }

  if (FAILED(renodx::utils::directx::pCreateDXGIFactory1(IID_PPV_ARGS(&dxgi_factory)))) {
    reshade::log::message(reshade::log::level::error, "utils::device_proxy::GetDeviceProxy(CreateDXGIFactory1 failed)");
    return nullptr;
  }

  bool tearing_supported = false;
  {
    IDXGIFactory5* dxgi_factory5 = nullptr;
    if (SUCCEEDED(dxgi_factory->QueryInterface(IID_PPV_ARGS(&dxgi_factory5)))) {
      BOOL allow_tearing = FALSE;
      if (SUCCEEDED(dxgi_factory5->CheckFeatureSupport(
              DXGI_FEATURE_PRESENT_ALLOW_TEARING,
              &allow_tearing,
              sizeof(allow_tearing)))) {
        tearing_supported = (allow_tearing != FALSE);
      }
      dxgi_factory5->Release();
    }
  }
  // Some same-HWND flip only stabilize if the session performs a
  // throwaway non-flip create first, then creates the real flip swapchain.
  if ((hwnd != nullptr && output_window == hwnd)
      && local_proxy_same_hwnd_non_flip_bootstrap
      && !proxy_same_hwnd_flip_established.load()) {
    DXGI_SWAP_CHAIN_DESC1 bootstrap_desc = sc_desc;
    bootstrap_desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    bootstrap_desc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;
    bootstrap_desc.Flags = 0;

    IDXGISwapChain1* bootstrap_swap_chain = nullptr;
    is_creating_proxy_swapchain = true;
    if (shared.data != nullptr) shared.data->is_creating_proxy_swapchain = true;
    const auto bootstrap_hr = dxgi_factory->CreateSwapChainForHwnd(
        swapchain_creator,
        output_window,
        &bootstrap_desc,
        fullscreen_desc.Windowed == TRUE ? nullptr : &fullscreen_desc,
        nullptr,
        &bootstrap_swap_chain);
    is_creating_proxy_swapchain = false;
    if (shared.data != nullptr) shared.data->is_creating_proxy_swapchain = false;
    if (FAILED(bootstrap_hr)) {
      std::stringstream s;
      s << "utils::device_proxy::GetDeviceProxy(non-flip bootstrap CreateSwapChainForHwnd failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(bootstrap_hr) << std::dec << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
    } else {
      bootstrap_swap_chain->Release();
      bootstrap_swap_chain = nullptr;
    }
  }

  sc_desc.Flags = tearing_supported ? DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING : 0;
  proxy_present_flags = tearing_supported ? DXGI_PRESENT_ALLOW_TEARING : 0u;

  is_creating_proxy_swapchain = true;
  shared.data->is_creating_proxy_swapchain = true;
  const auto hr = dxgi_factory->CreateSwapChainForHwnd(
      swapchain_creator,
      output_window,
      &sc_desc,
      &fullscreen_desc,
      nullptr,
      &proxy_swap_chain);
  is_creating_proxy_swapchain = false;
  shared.data->is_creating_proxy_swapchain = false;
  if (FAILED(hr)) {
    {
      RECT rect = {};
      const bool has_rect = (output_window != nullptr && GetWindowRect(output_window, &rect) != 0);
      std::stringstream s;
      s << "utils::device_proxy::GetDeviceProxy(CreateSwapChainForHwnd failed: ";
      s << "hr=0x" << std::hex << static_cast<uint32_t>(hr) << std::dec;
      s << "hwnd=" << PRINT_PTR(reinterpret_cast<uintptr_t>(output_window));
      s << ", size=" << sc_desc.Width << "x" << sc_desc.Height;
      s << ", format=" << sc_desc.Format;
      s << ", swap_effect=" << sc_desc.SwapEffect;
      s << ", flags=0x" << std::hex << sc_desc.Flags << std::dec;
      s << ", windowed=" << (fullscreen_desc.Windowed == TRUE ? "true" : "false");
      if (has_rect) {
        s << ", rect=" << rect.left << "," << rect.top;
        s << " " << (rect.right - rect.left) << "x" << (rect.bottom - rect.top);
      } else {
        s << ", rect=unknown";
      }
      s << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
    }

    if (dxgi_factory != nullptr) {
      dxgi_factory->Release();
    }
    proxy_swap_chain = nullptr;
    return nullptr;
  }

  proxy_swapchain_last_width = sc_desc.Width;
  proxy_swapchain_last_height = sc_desc.Height;
  proxy_swapchain_last_hwnd = reinterpret_cast<uintptr_t>(output_window);
  proxy_present_test_pending = true;
  proxy_invalid_call_streak = 0;

  // New (Mark window association to prevent full screen changes)
  {
    const UINT window_associate_flags = DXGI_MWA_NO_WINDOW_CHANGES | DXGI_MWA_NO_ALT_ENTER | DXGI_MWA_NO_PRINT_SCREEN;
    auto result = dxgi_factory->MakeWindowAssociation(output_window, window_associate_flags);
    if (FAILED(result)) {
      reshade::log::message(reshade::log::level::error, "utils::device_proxy::GetDeviceProxy(MakeWindowAssociation failed)");
    }
  }

  // Cleanup local references (do not release d3d11Device, it's returned)
  if (dxgi_factory != nullptr) {
    dxgi_factory->Release();
    dxgi_factory = nullptr;
  }

  IDXGISwapChain3* swap_chain_3 = nullptr;
  if (SUCCEEDED(proxy_swap_chain->QueryInterface(IID_PPV_ARGS(&swap_chain_3)))) {
    DXGI_COLOR_SPACE_TYPE dxgi_color_space;
    const reshade::api::color_space target_color_space = shared.data->target_color_space;
    switch (target_color_space) {
      default:
        assert(false && "Unsupported target color space");
      case reshade::api::color_space::extended_srgb_linear:
        dxgi_color_space = DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709;
        break;
      case reshade::api::color_space::hdr10_st2084:
        dxgi_color_space = DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020;
        break;
      case reshade::api::color_space::srgb_nonlinear:
        dxgi_color_space = DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709;
        break;
    }

    const HRESULT color_space_hr = swap_chain_3->SetColorSpace1(dxgi_color_space);
    if (FAILED(color_space_hr)) {
      std::stringstream s;
      s << "utils::device_proxy::GetDeviceProxy(SetColorSpace1 failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(color_space_hr) << std::dec;
      s << ", color_space=" << target_color_space << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
    swap_chain_3->Release();
  }

  return proxy_device;
}

[[deprecated("Use GetDeviceProxy(resource_desc) instead")]]
static ID3D11Device* GetDeviceProxy(renodx::utils::resource::ResourceInfo* host_resource_info, HWND hwnd = nullptr) {
  if (host_resource_info == nullptr) return nullptr;
  return GetDeviceProxy(host_resource_info->desc, hwnd);
}

// clang-format off



























































































// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format on

static ProxySharedResourcePair GetProxySharedResourcePair(
    const ProxySharedResourceSource& source_resource_info,
    const reshade::api::resource& source_clone,
    HWND hwnd) {
  if (shared.data == nullptr) return {};
  if (source_resource_info.device == nullptr) return {};
  if (source_clone.handle == 0u) return {};

  auto existing = proxy_shared_resources_by_clone.find(source_clone.handle);
  if (existing != proxy_shared_resources_by_clone.end()) {
    const bool valid = existing->second.host_shared_resource.handle != 0u
                       && existing->second.proxy_shared_resource.handle != 0u;
    if (valid) {
      return existing->second;
    }
    auto stale_pair = existing->second;
    proxy_shared_resources_by_clone.erase(existing);
    DestroyProxySharedResourcePair(stale_pair);
  }

  auto proxy_source_desc = source_resource_info.clone_desc;
  if (proxy_source_desc.type == reshade::api::resource_type::unknown) {
    proxy_source_desc = source_resource_info.desc;
  }

  if (GetDeviceProxy(proxy_source_desc, hwnd) == nullptr || proxy_device_reshade == nullptr) {
    assert(false && "GetProxySharedResourcePair called but proxy device is not available");
    return {};
  }

  auto new_desc = source_resource_info.clone_desc;
  if (new_desc.type == reshade::api::resource_type::unknown) {
    new_desc = source_resource_info.desc;
  }
  new_desc.texture.format = shared.data->target_intermediate_format;
  new_desc.usage = static_cast<reshade::api::resource_usage>(
      static_cast<uint32_t>(new_desc.usage)
      | static_cast<uint32_t>(reshade::api::resource_usage::copy_source
                              | reshade::api::resource_usage::copy_dest));
  if (new_desc.heap == reshade::api::memory_heap::custom) {
    new_desc.heap = reshade::api::memory_heap::gpu_only;
  }
  if (new_desc.type == reshade::api::resource_type::surface) {
    new_desc.type = reshade::api::resource_type::texture_2d;
  }

  // Override original flags
  new_desc.flags = reshade::api::resource_flags::shared;
  if (source_resource_info.device->get_api() == reshade::api::device_api::opengl) {
    new_desc.flags |= reshade::api::resource_flags::shared_nt_handle;
  }

  reshade::api::resource new_proxy_resource = {0u};
  reshade::api::resource new_host_shared_resource = {0u};
  void* new_shared_handle = nullptr;
  if (!proxy_device_reshade->create_resource(
          new_desc,
          nullptr,
          source_resource_info.initial_state,
          &new_proxy_resource,
          &new_shared_handle)) {
    std::stringstream s;
    s << "utils::device_proxy::GetProxySharedResourcePair(create proxy shared resource failed: ";
    s << "resource=" << PRINT_PTR(source_clone.handle);
    s << ", host_api=" << source_resource_info.device->get_api();
    s << ", proxy_api=" << proxy_device_reshade->get_api();
    s << ", format=" << new_desc.texture.format;
    s << ", usage=0x" << std::hex << static_cast<uint32_t>(new_desc.usage);
    s << ", initial_state=0x" << static_cast<uint32_t>(source_resource_info.initial_state) << std::dec;
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return {};
  }
  if (new_proxy_resource.handle == 0u || new_shared_handle == nullptr) {
    if (new_proxy_resource.handle != 0u) {
      proxy_device_reshade->destroy_resource(new_proxy_resource);
    }
    reshade::log::message(
        reshade::log::level::error,
        "utils::device_proxy::GetProxySharedResourcePair(create proxy shared resource returned invalid resource/handle)");
    return {};
  }

  void* host_shared_handle = new_shared_handle;
  if (!source_resource_info.device->create_resource(
          new_desc,
          nullptr,
          source_resource_info.initial_state,
          &new_host_shared_resource,
          &host_shared_handle)) {
    proxy_device_reshade->destroy_resource(new_proxy_resource);
    std::stringstream s;
    s << "utils::device_proxy::GetProxySharedResourcePair(create host shared resource failed: ";
    s << "resource=" << PRINT_PTR(source_clone.handle);
    s << ", host_api=" << source_resource_info.device->get_api();
    s << ", proxy_api=" << proxy_device_reshade->get_api();
    s << ", initial_state=0x" << std::hex << static_cast<uint32_t>(source_resource_info.initial_state) << std::dec;
    s << ", shared_handle_in=" << PRINT_PTR(reinterpret_cast<uintptr_t>(new_shared_handle));
    s << ", shared_handle_out=" << PRINT_PTR(reinterpret_cast<uintptr_t>(host_shared_handle));
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return {};
  }
  if (new_host_shared_resource.handle == 0u) {
    proxy_device_reshade->destroy_resource(new_proxy_resource);
    reshade::log::message(
        reshade::log::level::error,
        "utils::device_proxy::GetProxySharedResourcePair(create host shared resource returned invalid resource)");
    return {};
  }

  renodx::utils::resource::UpsertResourceInfo(new_proxy_resource, [&](renodx::utils::resource::ResourceInfo* info, const bool inserted) {
    (void)inserted;
    *info = {
        .device = proxy_device_reshade,
        .desc = new_desc,
        .resource = new_proxy_resource,
        .destroyed = false,
        .initial_state = source_resource_info.initial_state,
    };
  });

  renodx::utils::resource::UpsertResourceInfo(new_host_shared_resource, [&](renodx::utils::resource::ResourceInfo* info, const bool inserted) {
    (void)inserted;
    *info = {
        .device = source_resource_info.device,
        .desc = new_desc,
        .resource = new_host_shared_resource,
        .destroyed = false,
        .initial_state = source_resource_info.initial_state,
    };
  });

  ProxySharedResourcePair pair = {
      .host_shared_resource = new_host_shared_resource,
      .proxy_shared_resource = new_proxy_resource,
  };
  proxy_shared_resources_by_clone[source_clone.handle] = pair;

  return pair;
}

// Old DrawSwapChainProxy
static void OnPresentForProxyDevice(reshade::api::device* device, reshade::api::command_queue* queue, reshade::api::swapchain* swapchain) {
  auto* cmd_list = queue->get_immediate_command_list();
  if (!local_proxy_swapchain_settings_valid) {
    return;
  }
  if (last_device_proxy_shared_resource.handle == 0u) {
    return;
  }

  const auto proxy_swapchain_settings = local_proxy_swapchain_settings;

  {
    reshade::api::resource proxy_temp_resource = last_device_proxy_shared_resource;
    if (proxy_temp_resource.handle == 0u) return;

    bool proxy_temp_resource_valid = false;
    reshade::api::resource_desc proxy_temp_desc = {};
    renodx::utils::resource::GetResourceInfo(proxy_temp_resource, [&](const renodx::utils::resource::ResourceInfo& shared_info) {
      proxy_temp_resource_valid = !shared_info.destroyed && shared_info.device == device;
      if (proxy_temp_resource_valid) {
        proxy_temp_desc = shared_info.desc;
      }
    });
    if (!proxy_temp_resource_valid) {
      last_device_proxy_shared_resource = {0u};
      return;
    }

    if (proxy_temp_desc.texture.format == reshade::api::format::unknown) {
      reshade::log::message(reshade::log::level::error,
                            "utils::device_proxy::OnPresentForProxyDevice(strict failure: proxy shared resource has unknown format)");
      SetProxyRemovePending(true);
      return;
    }

    if (proxy_device_resource.handle != 0u) {
      bool destroy_proxy_device_resource = false;
      renodx::utils::resource::UpdateResourceInfo(proxy_device_resource, [&](renodx::utils::resource::ResourceInfo* info) {
        if (proxy_device_resource.handle != 0u
            && (info->destroyed
                || info->desc.texture.width != proxy_temp_desc.texture.width
                || info->desc.texture.height != proxy_temp_desc.texture.height
                || info->desc.texture.format != proxy_temp_desc.texture.format)) {
          destroy_proxy_device_resource = true;
        }
      });
      if (destroy_proxy_device_resource) {
        device->destroy_resource(proxy_device_resource);
        proxy_device_resource = {0u};
      }
    }

    if (proxy_device_resource.handle == 0u) {
      // Create proxy device resource

      reshade::api::resource_desc new_desc;
      new_desc.type = reshade::api::resource_type::texture_2d;
      new_desc.texture = {
          .width = proxy_temp_desc.texture.width,
          .height = proxy_temp_desc.texture.height,
          .format = proxy_temp_desc.texture.format};
      new_desc.heap = reshade::api::memory_heap::gpu_only;
      new_desc.usage = reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource;
      if (!device->create_resource(new_desc, nullptr, reshade::api::resource_usage::general, &proxy_device_resource)) {
        std::stringstream s;
        s << "utils::device_proxy::OnPresentForProxyDevice(strict failure: create proxy staging resource failed";
        s << ", format=" << new_desc.texture.format;
        s << ", size=" << new_desc.texture.width << "x" << new_desc.texture.height;
        s << ")";
        reshade::log::message(reshade::log::level::error, s.str().c_str());
        SetProxyRemovePending(true);
        return;
      }
      if (proxy_device_resource.handle == 0u) {
        reshade::log::message(
            reshade::log::level::error,
            "utils::device_proxy::OnPresentForProxyDevice(strict failure: proxy staging resource handle is null)");
        SetProxyRemovePending(true);
        return;
      }

      renodx::utils::resource::UpsertResourceInfo(proxy_device_resource, [&](renodx::utils::resource::ResourceInfo* info, const bool inserted) {
        (void)inserted;
        *info = {
            .device = device,
            .desc = new_desc,
            .resource = proxy_device_resource,
            .destroyed = false,
            .initial_state = reshade::api::resource_usage::general,
        };
      });
    }
    cmd_list->copy_resource(proxy_temp_resource, proxy_device_resource);
    queue->flush_immediate_command_list();
    if (device_proxy_wait_idle_destination) {
      queue->wait_idle();
    }
    // swapchain_clone = proxy_device_resource;
  }

  auto back_buffer = swapchain->get_current_back_buffer();
  auto back_buffer_handle = back_buffer.handle;

  auto& pass_data = proxy_swapchain_passes[back_buffer_handle];
  if (!pass_data) {
    auto* pass = new renodx::utils::draw::SwapchainProxyPass{
        .vertex_shader = proxy_swapchain_settings.vertex_shader,
        .pixel_shader = proxy_swapchain_settings.pixel_shader,
        .expected_constant_buffer_index = proxy_swapchain_settings.expected_constant_buffer_index,
        .expected_constant_buffer_space = proxy_swapchain_settings.expected_constant_buffer_space,
        .revert_state = proxy_swapchain_settings.revert_state,
        .use_compatibility_mode = false,
        .proxy_format = proxy_swapchain_settings.proxy_format,
        .shader_injection = proxy_swapchain_settings.shader_injection,
        .shader_injection_size = proxy_swapchain_settings.shader_injection_size,
        .auto_device_flush = false,
    };
    pass_data.reset(pass);
  }
  if (!pass_data->Render(swapchain, queue, &proxy_device_resource)) {
    pass_data->pass.DestroyAll(device);
    proxy_swapchain_passes.erase(back_buffer_handle);
  }
}

static void OnInitDevice(reshade::api::device* device) {
  if (!IsCreatingProxyDevice() && !IsProxyNativeDevice(device)) return;
  proxy_device_reshade = device;
  if (shared.data != nullptr) {
    shared.data->proxy_reshade_device = device;
    shared.data->proxy_native_device = reinterpret_cast<uintptr_t>(proxy_device);
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  // Handle cleanup of the proxied device
  if (device == proxied_device_reshade) {
    if (proxy_device_reshade != nullptr) {
      DestroyProxySwapchainPasses(proxy_device_reshade);
    }
    DestroyProxyDeviceResources(proxy_device_reshade);

    // Tear down proxy device
    if (proxy_swap_chain != nullptr) {
      proxy_swap_chain->Release();
      proxy_swap_chain = nullptr;
    }
    if (proxy_device_context != nullptr) {
      proxy_device_context->Release();
      proxy_device_context = nullptr;
    }
    if (proxy_device != nullptr) {
      proxy_device->Release();
      proxy_device = nullptr;
    }
    proxied_device_reshade = nullptr;

    last_device_proxy_shared_resource = {0u};
  } else if (device == proxy_device_reshade) {
    DestroyProxyDeviceResources(device);
    DestroyProxySwapchainPasses(device);
    last_device_proxy_shared_resource = {0u};
    proxy_device_reshade = nullptr;
    if (shared.data != nullptr && device == shared.data->proxy_reshade_device) {
      shared.data->proxy_reshade_device = nullptr;
      shared.data->proxy_native_device = 0u;
    }
    reshade::log::message(reshade::log::level::info, "utils::device_proxy::OnDestroyDevice(Proxy device destroyed.)");
  }
}

// clang-format off

























// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format on

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (shared.data == nullptr) return;
  if (!shared.data->use_device_proxy) return;

  auto* device = swapchain->get_device();
  if (device == proxy_device_reshade) return;

  if (!resize) return;
  if (proxied_device_reshade == nullptr) return;
  if (device != proxied_device_reshade) return;
  if (proxy_device_reshade == nullptr) return;
  if (proxy_swap_chain == nullptr) return;

  auto primary_swapchain_desc = device->get_resource_desc(swapchain->get_current_back_buffer());

  proxy_resize_width = primary_swapchain_desc.texture.width;
  proxy_resize_height = primary_swapchain_desc.texture.height;
  proxy_device_needs_resize = true;
}

static void ReleaseProxySwapChain() {
  if (proxy_swap_chain == nullptr) return;

  BOOL fullscreen = FALSE;
  const HRESULT fullscreen_hr = proxy_swap_chain->GetFullscreenState(&fullscreen, nullptr);
  if (SUCCEEDED(fullscreen_hr) && fullscreen != FALSE) {
    const HRESULT windowed_hr = proxy_swap_chain->SetFullscreenState(FALSE, nullptr);
    if (FAILED(windowed_hr)) {
      std::stringstream s;
      s << "utils::device_proxy::ReleaseProxySwapChain(SetFullscreenState(false) failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(windowed_hr) << std::dec << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
  }

  proxy_swap_chain->Release();
  proxy_swap_chain = nullptr;
  proxy_swapchain_reshade = nullptr;
}

static void ResetProxyRuntimeStateAfterTeardown() {
  last_device_proxy_shared_resource = {0u};
  proxy_present_test_pending = true;
  proxy_invalid_call_streak = 0;
  proxy_device_needs_resize = false;
  proxy_resize_width = 0;
  proxy_resize_height = 0;
  proxy_teardown_deferred_presents = 0;
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (shared.data == nullptr) return;
  if (!shared.data->use_device_proxy) return;

  auto* device = swapchain->get_device();
  if (device == proxy_device_reshade) return;
  if (device != proxied_device_reshade) return;

  // Stop clone rewrites and clear host clone resources for this swapchain first.
  DeactivateProxySwapchainClones(swapchain);
  ResetProxySwapchainCloneResources(swapchain);

  // Then clear proxy-side resources/passes.
  DestroyProxySwapchainPasses(proxy_device_reshade);
  DestroyProxyDeviceResources(proxy_device_reshade);

  // Any host swapchain destroy is a hard invalidation boundary.
  ReleaseProxySwapChain();
  proxy_present_flags = DXGI_PRESENT_ALLOW_TEARING;
  ResetProxyRuntimeStateAfterTeardown();
}

static bool OnSetFullscreenState(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
  if (shared.data == nullptr) return false;
  if (!shared.data->use_device_proxy) return false;
  auto* device = swapchain->get_device();
  const bool is_proxy = (device == proxy_device_reshade);
  const bool is_proxied = (device == proxied_device_reshade);

  return is_proxy && fullscreen;
}

// clang-format off












































































































































































// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format on

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  if (shared.data == nullptr) return;
  auto* device = swapchain->get_device();
  if (shared.data->remove_device_proxy) {
    // Prefer teardown on the host/proxied present path, but don't get stuck forever
    // when only proxy/non-proxied presents keep arriving (e.g. New Window -> None).
    const bool is_proxy_present = (device == proxy_device_reshade);
    const bool is_non_proxied_present = (proxied_device_reshade != nullptr && device != proxied_device_reshade);
    if (is_proxy_present || is_non_proxied_present) {
      const bool abort_teardown = (++proxy_teardown_deferred_presents < 8);
      if (abort_teardown) return;

      std::stringstream s;
      s << "utils::device_proxy::OnPresent(forcing teardown after deferred presents: ";
      s << "reason=" << (is_proxy_present ? "proxy device present" : "non-proxied present");
      reshade::log::message(reshade::log::level::warning, s.str().c_str());

      // No reliable host swapchain context in this path. Perform global clone cleanup.
      std::vector<reshade::api::resource> resources;
      renodx::utils::resource::ForEachResourceInfo([&](const auto& info) {
        if (info.destroyed) return;
        if (info.clone_target != &proxy_clone_target) return;
        resources.push_back(info.resource);
      });
      for (const auto& resource : resources) {
        DeactivateProxyCloneForResource(resource);
        ResetProxyCloneForResource(resource);
      }
    } else {
      proxy_teardown_deferred_presents = 0;
    }

    if (queue != nullptr) {
      // Ensure all queued host work is complete before destroying cloned/shared resources.
      queue->flush_immediate_command_list();
      queue->wait_idle();
    }
    if (proxy_device_context != nullptr) {
      // Drain any pending proxy-side D3D11 work before resource teardown.
      proxy_device_context->Flush();
    }
    if (device != nullptr && device == proxied_device_reshade) {
      // Stop clone rewrites, restore original RT binding, then destroy clone resources.
      DeactivateProxySwapchainClones(swapchain);

      if (queue != nullptr) {
        auto* cmd_list = queue->get_immediate_command_list();
        if (cmd_list != nullptr) {
          auto& rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);
          if (!rtvs.empty()) {
            std::vector<reshade::api::resource_view> original_rtvs;
            original_rtvs.reserve(rtvs.size());
            original_rtvs.insert(original_rtvs.end(), rtvs.begin(), rtvs.end());
            for (auto& rtv : original_rtvs) {
              if (rtv.handle == 0u) continue;
              reshade::api::resource_view fallback = {0u};
              const auto found_view_info = renodx::utils::resource::GetResourceViewInfo(rtv, [&](const renodx::utils::resource::ResourceViewInfo& view_info) {
                if (view_info.destroyed) return;
                if (!view_info.is_clone || view_info.fallback.handle == 0u) return;
                fallback = view_info.fallback;
              });
              if (!found_view_info || fallback.handle == 0u) continue;
              rtv = fallback;
            }

            auto dsv = renodx::utils::swapchain::GetDepthStencil(cmd_list);
            if (dsv.handle != 0u) {
              reshade::api::resource_view fallback = {0u};
              renodx::utils::resource::GetResourceViewInfo(dsv, [&](const renodx::utils::resource::ResourceViewInfo& dsv_info) {
                if (dsv_info.destroyed) return;
                if (!dsv_info.is_clone || dsv_info.fallback.handle == 0u) return;
                fallback = dsv_info.fallback;
              });
              if (fallback.handle != 0u) dsv = fallback;
            }

            if (cmd_list->get_device()->get_api() == reshade::api::device_api::opengl) {
              cmd_list->bind_render_targets_and_depth_stencil(
                  static_cast<uint32_t>(original_rtvs.size()),
                  original_rtvs.data(),
                  {0u});
            } else {
              cmd_list->bind_render_targets_and_depth_stencil(
                  static_cast<uint32_t>(original_rtvs.size()),
                  original_rtvs.data(),
                  dsv);
            }
            queue->flush_immediate_command_list();
          }
        }
      }

      ResetProxySwapchainCloneResources(swapchain);
    }
    if (proxy_device_reshade != nullptr) {
      DestroyProxySwapchainPasses(proxy_device_reshade);
      DestroyProxyDeviceResources(proxy_device_reshade);
    }
    if (proxy_swap_chain != nullptr) {
      ReleaseProxySwapChain();
    }
    ResetProxyRuntimeStateAfterTeardown();
    SetProxyRemovePending(false);
    SetProxyEnabled(false);
    return;
  }
  proxy_teardown_deferred_presents = 0;

  if (!shared.data->use_device_proxy) return;

  if (device == proxy_device_reshade) {
    OnPresentForProxyDevice(device, queue, swapchain);
    return;
  }
  if (device != proxied_device_reshade) {
    if (proxied_device_reshade != nullptr) return;
    // First present with a new device, mark as proxied device.
    proxied_device_reshade = device;
  }

  const bool local_settings_dirty = local_proxy_settings_dirty;
  local_proxy_settings_dirty = false;
  const bool shared_settings_dirty = shared.data->settings_dirty.exchange(false);
  if (local_settings_dirty || shared_settings_dirty) {
    const reshade::api::format current_target_format = shared.data->target_format;
    const reshade::api::color_space target_color_space = shared.data->target_color_space;
    const reshade::api::format current_target_intermediate_format = shared.data->target_intermediate_format;
    std::stringstream s;
    s << "utils::device_proxy::OnPresent(reconfiguring proxy runtime after settings change: ";
    s << "target_format=" << current_target_format;
    s << ", target_color_space=" << target_color_space;
    s << ", target_intermediate_format=" << current_target_intermediate_format;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    if (proxy_device_reshade != nullptr) {
      DestroyProxySwapchainPasses(proxy_device_reshade);
      DestroyProxyDeviceResources(proxy_device_reshade);
    }
    ResetProxySwapchainCloneResources(swapchain);
    if (proxy_swap_chain != nullptr) {
      ReleaseProxySwapChain();
    }
    last_device_proxy_shared_resource = {0u};
  }

  auto current_back_buffer = swapchain->get_current_back_buffer();
  auto host_resource_desc = renodx::utils::resource::GetResourceDesc(device, current_back_buffer);
  if (host_resource_desc.type == reshade::api::resource_type::unknown) {
    assert(host_resource_desc.type != reshade::api::resource_type::unknown);
    return;
  }

  HWND hwnd = static_cast<HWND>(swapchain->get_hwnd());
  auto* new_device = GetDeviceProxy(host_resource_desc, hwnd);
  if (new_device == nullptr) {
    reshade::log::message(reshade::log::level::warning, "utils::device_proxy::OnPresent(GetDeviceProxy returned null)");
    return;
  }
  if (proxy_device_needs_resize.exchange(false)) {
    if (proxy_swap_chain == nullptr) {
      proxy_device_needs_resize.store(true);
      proxy_present_test_pending.store(true);
      return;
    }
    auto width = proxy_resize_width.load();
    auto height = proxy_resize_height.load();

    DXGI_SWAP_CHAIN_DESC1 sc_desc = {};
    const HRESULT desc_hr = proxy_swap_chain->GetDesc1(&sc_desc);
    if (FAILED(desc_hr)) {
      std::stringstream s;
      s << "utils::device_proxy::OnPresent(GetDesc1 before resize failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(desc_hr) << std::dec << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      proxy_device_needs_resize.store(true);
      proxy_present_test_pending.store(true);
      return;
    }

    if (width == 0u) width = (sc_desc.Width != 0u) ? sc_desc.Width : proxy_swapchain_last_width.load();
    if (height == 0u) height = (sc_desc.Height != 0u) ? sc_desc.Height : proxy_swapchain_last_height.load();
    if (width == 0u || height == 0u) {
      reshade::log::message(reshade::log::level::warning,
                            "utils::device_proxy::OnPresent(skip resize: invalid target size)");
      proxy_device_needs_resize.store(true);
      proxy_present_test_pending.store(true);
      return;
    }

    if (proxy_device_reshade != nullptr) {
      DestroyProxySwapchainPasses(proxy_device_reshade);
      DestroyProxyDeviceResources(proxy_device_reshade);
    }
    last_device_proxy_shared_resource = {0u};

    const HRESULT resize_hr =
        proxy_swap_chain->ResizeBuffers(sc_desc.BufferCount, width, height, sc_desc.Format, sc_desc.Flags);
    if (FAILED(resize_hr)) {
      std::stringstream s;
      s << "utils::device_proxy::OnPresent(ResizeBuffers failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(resize_hr) << std::dec;
      s << ", size=" << width << "x" << height;
      s << ", format=" << sc_desc.Format;
      s << ", flags=0x" << std::hex << sc_desc.Flags << std::dec << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      proxy_device_needs_resize.store(true);
      proxy_present_test_pending.store(true);
      return;
    }

#ifdef DXGI_PRESENT_RESTART
    BOOL fullscreen = FALSE;
    if (SUCCEEDED(proxy_swap_chain->GetFullscreenState(&fullscreen, nullptr)) && (fullscreen != FALSE)) {
      (void)proxy_swap_chain->Present(0, DXGI_PRESENT_RESTART);
    }
#endif

    proxy_swapchain_last_width.store(width);
    proxy_swapchain_last_height.store(height);
    proxy_invalid_call_streak.store(0);
    proxy_present_test_pending.store(true);
  }

  const reshade::api::format current_target_intermediate_format = shared.data->target_intermediate_format;
  proxy_clone_target.new_format = current_target_intermediate_format;
  switch (current_target_intermediate_format) {
    default:
      assert(false && "Unsupported format for proxy clone target");
      proxy_clone_target.new_format = reshade::api::format::r16g16b16a16_float;
    case reshade::api::format::r16g16b16a16_float:
      proxy_clone_target.view_upgrades = utils::resource::VIEW_UPGRADES_RGBA16F;
      break;
    case reshade::api::format::r8g8b8a8_unorm:
      proxy_clone_target.view_upgrades = utils::resource::VIEW_UPGRADES_RGBA8_UNORM;
      break;
    case reshade::api::format::r10g10b10a2_unorm:
      proxy_clone_target.view_upgrades = utils::resource::VIEW_UPGRADES_R10G10B10A2_UNORM;
      break;
  }

  reshade::api::resource swapchain_clone = {0u};
  ProxySharedResourcePair shared_pair = {};
  ProxySharedResourceSource shared_resource_source = {};
  bool needs_rtv_rewrite = false;
  bool needs_clone_setup = true;
  const auto found_existing_clone = renodx::utils::resource::GetResourceInfo(current_back_buffer, [&](const renodx::utils::resource::ResourceInfo& resource_info) {
    shared_resource_source.device = resource_info.device;
    shared_resource_source.desc = resource_info.desc;
    shared_resource_source.clone_desc = resource_info.clone_desc;
    shared_resource_source.initial_state = resource_info.initial_state;

    if (!resource_info.clone_enabled) return;
    if (resource_info.clone_target != &proxy_clone_target) return;
    if (resource_info.clone.handle == 0u) return;

    swapchain_clone = resource_info.clone;
    needs_clone_setup = false;
  });
  if (!found_existing_clone) {
    assert(found_existing_clone);
    return;
  }

  if (needs_clone_setup) {
    bool needs_clone_creation = false;
    std::vector<uint64_t> resource_view_handles;
    renodx::utils::resource::UpdateResourceInfo(current_back_buffer, [&](renodx::utils::resource::ResourceInfo* resource_info) {
      if (!resource_info->clone_enabled) {
        resource_info->clone_enabled = true;
        resource_info->clone_can_deactivate = true;
        resource_view_handles.assign(resource_info->resource_view_handles.begin(), resource_info->resource_view_handles.end());
        needs_rtv_rewrite = true;
      } else if (!resource_info->clone_can_deactivate) {
        resource_info->clone_can_deactivate = true;
        resource_view_handles.assign(resource_info->resource_view_handles.begin(), resource_info->resource_view_handles.end());
        needs_rtv_rewrite = true;
      }
      if (resource_info->clone_target != &proxy_clone_target) {
        resource_info->clone_target = &proxy_clone_target;
        needs_rtv_rewrite = true;
      }
      if (resource_info->clone.handle == 0u) {
        needs_clone_creation = true;
        needs_rtv_rewrite = true;
      } else {
        swapchain_clone = resource_info->clone;
      }

      shared_resource_source.device = resource_info->device;
      shared_resource_source.desc = resource_info->desc;
      shared_resource_source.clone_desc = resource_info->clone_desc;
      shared_resource_source.initial_state = resource_info->initial_state;
    });
    renodx::utils::resource::upgrade::UpdateResourceViewsCloneState(resource_view_handles, true, true);
    if (needs_clone_creation) {
      swapchain_clone = renodx::utils::resource::upgrade::CloneResource(current_back_buffer);
      renodx::utils::resource::GetResourceInfo(current_back_buffer, [&](const renodx::utils::resource::ResourceInfo& resource_info) {
        shared_resource_source.device = resource_info.device;
        shared_resource_source.desc = resource_info.desc;
        shared_resource_source.clone_desc = resource_info.clone_desc;
        shared_resource_source.initial_state = resource_info.initial_state;
      });
    }
  }

  if (swapchain_clone.handle == 0u) {
    std::stringstream s;
    s << "utils::device_proxy::OnPresent(clone creation failed";
    s << ", format=" << current_target_intermediate_format;
    s << ", backbuffer=" << PRINT_PTR(current_back_buffer.handle);
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    SetProxyRemovePending(true);
    return;
  }
  if (needs_rtv_rewrite) {
    auto* cmd_list = queue->get_immediate_command_list();
    auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);
    auto dsv = renodx::utils::swapchain::GetDepthStencil(cmd_list);
    renodx::utils::resource::upgrade::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), dsv);
  }

  shared_pair = GetProxySharedResourcePair(shared_resource_source, swapchain_clone, hwnd);
  if (shared_pair.host_shared_resource.handle == 0u
      || shared_pair.proxy_shared_resource.handle == 0u) {
    reshade::log::message(
        reshade::log::level::error,
        "utils::device_proxy::OnPresent(shared intermediate creation failed; disabling proxy creation retries)");
    device_proxy_creation_failed = true;
    SetProxyEnabled(false);
    SetProxyRemovePending(true);
    return;
  }

  // Ready to copy to the shared resource.
  // Serialize the copy + publish step to avoid races with the DX11 consumer
  // claiming the shared handle. When keyed mutex is available this is not
  // needed, but for the DX9 fallback we rely on a CPU-side handoff.
  // Should DXGIKeyedMutex acquire

  // Backport fix for Reshade DX9 resource copying.
  if (device->get_api() == reshade::api::device_api::d3d9) {
    auto* native = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
    auto* src_res = reinterpret_cast<IDirect3DResource9*>(swapchain_clone.handle);
    auto* dst_res = reinterpret_cast<IDirect3DResource9*>(shared_pair.host_shared_resource.handle);
    IDirect3DSurface9* src_surface;
    IDirect3DSurface9* dst_surface;

    switch (src_res->GetType()) {
      case D3DRTYPE_SURFACE:
        src_surface = static_cast<IDirect3DSurface9*>(src_res);
        break;
      case D3DRTYPE_TEXTURE: {
        auto* tex = static_cast<IDirect3DTexture9*>(src_res);
        tex->GetSurfaceLevel(0, &src_surface);
        break;
      }
      default:
        assert(false);
    }

    switch (dst_res->GetType()) {
      case D3DRTYPE_SURFACE:
        dst_surface = static_cast<IDirect3DSurface9*>(dst_res);
        break;
      case D3DRTYPE_TEXTURE: {
        auto* tex = static_cast<IDirect3DTexture9*>(dst_res);
        tex->GetSurfaceLevel(0, &dst_surface);
        break;
      }
      default:
        assert(false);
    }

    const HRESULT copy_hr = native->StretchRect(src_surface, nullptr, dst_surface, nullptr, D3DTEXF_NONE);
    if (FAILED(copy_hr)) {
      std::stringstream s;
      s << "utils::device_proxy::OnPresent(copy handoff->host_shared StretchRect failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(copy_hr) << std::dec;
      s << ", src=" << PRINT_PTR(swapchain_clone.handle);
      s << ", dst=" << PRINT_PTR(shared_pair.host_shared_resource.handle);
      s << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
    }
    assert(SUCCEEDED(copy_hr));
  } else {
    queue->get_immediate_command_list()->copy_resource(swapchain_clone, shared_pair.host_shared_resource);
  }

  queue->flush_immediate_command_list();
  if (device_proxy_wait_idle_source) {
    // Should DXGIKeyedMutex release.
    queue->wait_idle();
  }

  // Publish the shared resource handoff for proxy consumption.
  last_device_proxy_shared_resource = shared_pair.proxy_shared_resource;

  UINT present_flags =
      (proxy_swap_chain == nullptr) ? 0u : proxy_present_flags.load();
  if (proxy_swap_chain != nullptr
      && proxy_present_test_pending.load()
      && present_flags != 0u) {
    const HRESULT test_hr = proxy_swap_chain->Present(0, DXGI_PRESENT_TEST);
    if (FAILED(test_hr)) {
      const uint32_t streak = proxy_invalid_call_streak.fetch_add(1) + 1;
      if (streak == 1u || streak == 4u) {
        std::stringstream s;
        s << "utils::device_proxy::OnPresent(Proxy Present TEST failed: hr=0x";
        s << std::hex << static_cast<uint32_t>(test_hr) << std::dec;
        s << ", flags=0x" << std::hex << present_flags << std::dec;
        s << ", streak=" << streak << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
      }

      // Avoid an endless TEST-fail loop after reset/transition; force normal
      // recovery path once the transient state does not clear quickly.
      if (streak >= 4u) {
        proxy_device_needs_resize.store(true);
        proxy_present_test_pending.store(false);
        reshade::log::message(reshade::log::level::warning,
                              "utils::device_proxy::OnPresent(promoting TEST failure to resize recovery)");
      }
      return;
    }

    proxy_invalid_call_streak.store(0);
    proxy_present_test_pending.store(false);
  }

  const HRESULT present_hr = proxy_swap_chain->Present(0, present_flags);
  if (FAILED(present_hr)) {
    if (present_hr == DXGI_ERROR_INVALID_CALL) {
      const uint32_t streak = proxy_invalid_call_streak.fetch_add(1) + 1;
      if (streak >= 2u) {
        proxy_device_needs_resize.store(true);
        proxy_present_test_pending.store(true);
        reshade::log::message(reshade::log::level::warning,
                              "utils::device_proxy::OnPresent(schedule resize recovery after invalid-call)");
      }
    }
    std::stringstream s;
    s << "utils::device_proxy::OnPresent(Proxy Present failed: hr=0x";
    s << std::hex << static_cast<uint32_t>(present_hr) << std::dec;
    s << ", flags=0x" << std::hex << present_flags << std::dec << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
  } else {
    proxy_invalid_call_streak.store(0);
  }
}
static void Use(DWORD fdw_reason) {
  renodx::utils::resource::upgrade::use_resource_cloning = true;

  if (fdw_reason == DLL_PROCESS_ATTACH) {
    renodx::utils::resource::Use(fdw_reason);
    renodx::utils::resource::upgrade::Use(fdw_reason);
  }

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (shared.RegisterModule([](SharedData& data) {
            if (use_device_proxy) {
              data.use_device_proxy = true;
            }
            if (target_format != reshade::api::format::unknown) {
              data.target_format = target_format;
            }
            if (target_color_space != reshade::api::color_space::unknown) {
              data.target_color_space = target_color_space;
            }
            if (target_intermediate_format != reshade::api::format::unknown) {
              data.target_intermediate_format = target_intermediate_format;
            }
            if (use_device_proxy
                || target_format != reshade::api::format::unknown
                || target_color_space != reshade::api::color_space::unknown
                || target_intermediate_format != reshade::api::format::unknown) {
              data.settings_dirty = true;
            }
          })) {
        reshade::log::message(reshade::log::level::info, "utils::device_proxy attached.");
      }
      renodx::utils::device_upgrade::Use(fdw_reason);

      shared.RegisterEvent<reshade::addon_event::init_device>(OnInitDevice);
      shared.RegisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      shared.RegisterEvent<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      shared.RegisterEvent<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      shared.RegisterEvent<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
      shared.RegisterEvent<reshade::addon_event::present>(OnPresent);

      renodx::utils::resource::RegisterOnDestroyResourceInfoCallback(&OnDestroyTrackedResourceInfo);

      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::device_upgrade::Use(fdw_reason);

      shared.UnregisterEvent<reshade::addon_event::init_device>(OnInitDevice);
      shared.UnregisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      shared.UnregisterEvent<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      shared.UnregisterEvent<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      shared.UnregisterEvent<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
      shared.UnregisterEvent<reshade::addon_event::present>(OnPresent);
      renodx::utils::resource::UnregisterOnDestroyResourceInfoCallback(&OnDestroyTrackedResourceInfo);
      shared.UnregisterModule();

      break;
  }

  if (fdw_reason == DLL_PROCESS_DETACH) {
    renodx::utils::resource::upgrade::Use(fdw_reason);
    renodx::utils::resource::Use(fdw_reason);
  }
}

}  // namespace renodx::utils::device_proxy
