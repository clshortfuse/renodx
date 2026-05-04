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
#include <include/reshade_api_device.hpp>

#include "./data.hpp"
#include "./directx.hpp"
#include "./draw.hpp"
#include "./resource.hpp"
#include "./resource_upgrade.hpp"
#include "./windowing.hpp"

namespace renodx::utils::device_proxy {

static bool attached = false;

// Variables
static bool use_device_proxy = false;
static bool remove_device_proxy = false;
static bool bypass_dx9_ex_upgrade = false;
static bool device_proxy_wait_idle_source = false;
static bool device_proxy_wait_idle_destination = false;
static reshade::api::resource last_device_proxy_shared_resource = {0u};

static thread_local bool is_creating_proxy_device = false;
static thread_local bool is_creating_proxy_swapchain = false;

static IDXGISwapChain1* proxy_swap_chain = nullptr;
static ID3D11Device* proxy_device = nullptr;
static ID3D11DeviceContext* proxy_device_context = nullptr;
static ID3D12Device* proxy_device_12 = nullptr;
static ID3D12CommandQueue* proxy_command_queue = nullptr;
static reshade::api::device* proxy_device_reshade = nullptr;
static reshade::api::device* proxied_device_reshade = nullptr;
static reshade::api::swapchain* proxy_swapchain_reshade = nullptr;
static reshade::api::resource proxy_device_resource = {0u};

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
static std::atomic<uintptr_t> proxy_swapchain_hwnd_override = 0;
static std::atomic<bool> proxy_settings_dirty = false;
static std::atomic<uint32_t> proxy_teardown_deferred_presents = 0;
static std::atomic<bool> proxy_same_hwnd_non_flip_bootstrap = false;
static std::atomic<bool> proxy_same_hwnd_flip_established = false;

static bool device_proxy_creation_failed = false;

static reshade::api::format target_format = reshade::api::format::r16g16b16a16_float;
static reshade::api::color_space target_color_space = reshade::api::color_space::extended_srgb_linear;
static reshade::api::format target_intermediate_format = reshade::api::format::r16g16b16a16_float;
static renodx::utils::resource::ResourceUpgradeInfo proxy_clone_target = {
    .new_format = reshade::api::format::r16g16b16a16_float,
    .use_resource_view_hot_swap = true,
    .usage_set =
        static_cast<uint32_t>(reshade::api::resource_usage::shader_resource
                              | reshade::api::resource_usage::render_target),
    .view_upgrades = utils::resource::VIEW_UPGRADES_RGBA16F,
    .use_resource_view_cloning_and_upgrade = true,
};
static renodx::utils::draw::SwapchainProxyPass proxy_swapchain_settings = {};
static bool proxy_swapchain_settings_valid = false;
static std::unordered_map<uint64_t, std::unique_ptr<renodx::utils::draw::SwapchainProxyPass>> proxy_swapchain_passes;

struct ProxySharedResourcePair {
  reshade::api::resource host_shared_resource = {0u};
  reshade::api::resource proxy_shared_resource = {0u};
};
static std::unordered_map<uint64_t, ProxySharedResourcePair> proxy_shared_resources_by_clone;

// Methods
static void DestroyProxySharedResourcesForHandle(uint64_t handle);

static void DeactivateProxyCloneForResource(const reshade::api::resource& resource) {
  if (resource.handle == 0u) return;
  renodx::utils::resource::store->resource_infos.if_contains(resource.handle, [&](auto& pair) {
    auto& info = pair.second;
    if (info.clone_target == &proxy_clone_target) {
      info.clone_enabled = false;
    }
  });
}

static void ResetProxyCloneForResource(const reshade::api::resource& resource) {
  if (resource.handle == 0u) return;

  auto* info = renodx::utils::resource::GetResourceInfoUnsafe(resource, false);
  if (info == nullptr) return;
  if (info->clone_target != &proxy_clone_target) return;

  std::vector<std::pair<uint64_t, uint64_t>> stale_clone_views;
  renodx::utils::resource::store->resource_view_infos.for_each([&](const auto& pair) {
    const auto& view_info = pair.second;
    if (view_info.destroyed) return;
    if (view_info.resource_info != info) return;
    if (view_info.clone.handle == 0u) return;
    stale_clone_views.emplace_back(view_info.view.handle, view_info.clone.handle);
  });
  for (const auto& [owner_view_handle, clone_view_handle] : stale_clone_views) {
    if (info->device != nullptr) {
      info->device->destroy_resource_view({clone_view_handle});
    }
    renodx::utils::resource::store->resource_view_infos.if_contains_unsafe(owner_view_handle, [&](auto& owner_pair) {
      auto& owner_view_info = owner_pair.second;
      if (owner_view_info.clone.handle == clone_view_handle) {
        owner_view_info.clone = {0u};
        owner_view_info.clone_resource = {0u};
        owner_view_info.clone_desc = {};
      }
    });
  }

  DestroyProxySharedResourcesForHandle(info->clone.handle);
  if (info->clone.handle != 0u && info->device != nullptr) {
    info->device->destroy_resource(info->clone);
  }
  info->clone = {0u};
  info->clone_desc = {};
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
    if (auto* info = renodx::utils::resource::GetResourceInfoUnsafe(proxy_device_resource, false)) {
      info->destroyed = true;
    }
    proxy_device_resource = {0u};
  }
}

static void SetTargetFormat(reshade::api::format format) {
  if (target_format != format) {
    proxy_settings_dirty = true;
    target_format = format;
  }
}

static void SetTargetColorSpace(reshade::api::color_space color_space) {
  if (target_color_space != color_space) {
    proxy_settings_dirty = true;
    target_color_space = color_space;
  }
}

static void SetIntermediateFormat(reshade::api::format format) {
  if (target_intermediate_format != format) {
    proxy_settings_dirty = true;
    target_intermediate_format = format;
  }
}

static void SetProxySettings(const renodx::utils::draw::SwapchainProxyPass& settings) {
  proxy_swapchain_settings = settings;
  proxy_swapchain_settings_valid = true;
}

static void SetSameHwndNonFlipBootstrap(bool enabled) {
  const bool changed =
      proxy_same_hwnd_non_flip_bootstrap.exchange(enabled, std::memory_order_relaxed) != enabled;
  if (changed) {
    proxy_settings_dirty = true;
  }
}

static void SetSwapchainHwndOverride(HWND hwnd) {
  proxy_swapchain_hwnd_override = reinterpret_cast<uintptr_t>(hwnd);
}

static HWND GetSwapchainHwndOverride() {
  return reinterpret_cast<HWND>(proxy_swapchain_hwnd_override.load());
}

static void DestroyProxySwapchainPasses(reshade::api::device* device) {
  for (auto& [handle, pass] : proxy_swapchain_passes) {
    if (pass) {
      pass->pass.DestroyAll(device);
    }
  }
  proxy_swapchain_passes.clear();
}

static ID3D11Device* GetDeviceProxy(renodx::utils::resource::ResourceInfo* host_resource_info, HWND hwnd = nullptr) {
  if (device_proxy_creation_failed) return nullptr;
  if (proxy_device != nullptr && proxy_swap_chain != nullptr) {
    return proxy_device;
  }
  if (!renodx::utils::directx::Initialize()) return nullptr;

  // New: Moved factory to after device

  DXGI_SWAP_CHAIN_FULLSCREEN_DESC fullscreen_desc = {};
  DXGI_SWAP_CHAIN_DESC1 sc_desc = {};
  sc_desc.BufferCount = 2u;
  sc_desc.Width = host_resource_info->desc.texture.width;
  sc_desc.Height = host_resource_info->desc.texture.height;
  switch (target_format) {
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
  auto* output_window = hwnd != nullptr ? static_cast<HWND>(hwnd) : GetDesktopWindow();
  auto* override_window = GetSwapchainHwndOverride();
  if (override_window != nullptr) {
    if (IsWindow(override_window) != FALSE) {
      output_window = override_window;
    } else {
      SetSwapchainHwndOverride(nullptr);
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

#ifndef RENODX_PROXY_DEVICE_D3D12
  if (proxy_device == nullptr) {
    UINT create_flags = D3D11_CREATE_DEVICE_SINGLETHREADED;
    D3D_FEATURE_LEVEL feature_level;

    assert(is_creating_proxy_device == false);
    assert(proxy_device_reshade == nullptr);
    is_creating_proxy_device = true;
    if (FAILED(renodx::utils::directx::pD3D11CreateDevice(
            nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr, create_flags,
            nullptr, 0, D3D11_SDK_VERSION, &proxy_device, &feature_level, &proxy_device_context))) {
      is_creating_proxy_device = false;
      proxy_device = nullptr;
      proxy_device_context = nullptr;
      return nullptr;
    }
    is_creating_proxy_device = false;
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

#else
  // UINT create_flags = D3D11_CREATE_DEVICE_SINGLETHREADED;
  D3D_FEATURE_LEVEL feature_level = D3D_FEATURE_LEVEL_12_0;

  if (proxy_device == nullptr) {
    assert(is_creating_proxy_device == false);
    assert(proxy_device_reshade == nullptr);
    is_creating_proxy_device = true;

    if (FAILED(renodx::utils::directx::pD3D12CreateDevice(
            nullptr, feature_level, IID_PPV_ARGS(&proxy_device)))) {
      is_creating_proxy_device = false;
      proxy_device = nullptr;
      return nullptr;
    }

    is_creating_proxy_device = false;
    assert(proxy_device_reshade != nullptr);
  }

  if (proxy_command_queue == nullptr) {
    // Create swapchain for HWND
    // For D3D12, the swapchain must be created from a command queue, not the device.
    D3D12_COMMAND_QUEUE_DESC queue_desc = {};
    queue_desc.Type = D3D12_COMMAND_LIST_TYPE_DIRECT;
    queue_desc.Priority = D3D12_COMMAND_QUEUE_PRIORITY_NORMAL;
    queue_desc.Flags = D3D12_COMMAND_QUEUE_FLAG_NONE;
    queue_desc.NodeMask = 0;
    if (FAILED(proxy_device->CreateCommandQueue(&queue_desc, IID_PPV_ARGS(&proxy_command_queue)))) {
      if (proxy_device != nullptr) {
        proxy_device->Release();
        proxy_device = nullptr;
      }
      return nullptr;
    }
    assert(proxy_command_queue != nullptr);
  }
#endif

  IUnknown* swapchain_creator = nullptr;
#ifndef RENODX_PROXY_DEVICE_D3D12
  swapchain_creator = proxy_device;
#else
  swapchain_creator = proxy_command_queue;
#endif

  if (proxy_swap_chain != nullptr) {
    return proxy_device;
  }

  IDXGIFactory2* dxgi_factory = nullptr;

  {
    RECT client_rect = {};
    if (output_window == nullptr || !IsWindow(output_window) || GetClientRect(output_window, &client_rect) == 0) {
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
  {
    std::stringstream s;
    s << "utils::device_proxy::GetDeviceProxy(tearing_supported=" << (tearing_supported ? "true" : "false") << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }

  // Some same-HWND flip only stabilize if the session performs a
  // throwaway non-flip create first, then creates the real flip swapchain.
  if ((hwnd != nullptr && output_window == hwnd)
      && proxy_same_hwnd_non_flip_bootstrap.load(std::memory_order_relaxed)
      && !proxy_same_hwnd_flip_established.load(std::memory_order_relaxed)) {
    DXGI_SWAP_CHAIN_DESC1 bootstrap_desc = sc_desc;
    bootstrap_desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    bootstrap_desc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;
    bootstrap_desc.Flags = 0;

    IDXGISwapChain1* bootstrap_swap_chain = nullptr;
    is_creating_proxy_swapchain = true;
    const auto bootstrap_hr = dxgi_factory->CreateSwapChainForHwnd(
        swapchain_creator,
        output_window,
        &bootstrap_desc,
        fullscreen_desc.Windowed == TRUE ? nullptr : &fullscreen_desc,
        nullptr,
        &bootstrap_swap_chain);
    is_creating_proxy_swapchain = false;
    if (FAILED(bootstrap_hr)) {
      std::stringstream s;
      s << "utils::device_proxy::GetDeviceProxy(non-flip bootstrap CreateSwapChainForHwnd failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(bootstrap_hr) << std::dec << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
    } else {
      reshade::log::message(
          reshade::log::level::info,
          "utils::device_proxy::GetDeviceProxy(created one-off non-flip bootstrap swapchain)");

      bootstrap_swap_chain->Release();
      bootstrap_swap_chain = nullptr;
    }
  }

  sc_desc.Flags = tearing_supported ? DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING : 0;
  proxy_present_flags = tearing_supported ? DXGI_PRESENT_ALLOW_TEARING : 0u;

  is_creating_proxy_swapchain = true;
  const auto hr = dxgi_factory->CreateSwapChainForHwnd(
      swapchain_creator,
      output_window,
      &sc_desc,
      &fullscreen_desc,
      nullptr,
      &proxy_swap_chain);
  is_creating_proxy_swapchain = false;
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
  reshade::log::message(reshade::log::level::info, "utils::device_proxy::GetDeviceProxy(Swapchain created successfully)");

  // New (Mark window association to prevent full screen changes)
  {
    const UINT window_associate_flags = DXGI_MWA_NO_WINDOW_CHANGES | DXGI_MWA_NO_ALT_ENTER | DXGI_MWA_NO_PRINT_SCREEN;
    auto result = dxgi_factory->MakeWindowAssociation(output_window, window_associate_flags);
    if (FAILED(result)) {
      reshade::log::message(reshade::log::level::error, "utils::device_proxy::GetDeviceProxy(MakeWindowAssociation failed)");
    } else {
      std::stringstream s;
      s << "utils::device_proxy::GetDeviceProxy(MakeWindowAssociation flags=0x";
      s << std::hex << window_associate_flags << std::dec << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
  }

  // Cleanup local references (do not release d3d11Device, it's returned)
  if (dxgi_factory != nullptr) {
    dxgi_factory->Release();
    dxgi_factory = nullptr;
  }

  IDXGISwapChain3* swapChain3 = nullptr;
  if (SUCCEEDED(proxy_swap_chain->QueryInterface(IID_PPV_ARGS(&swapChain3)))) {
    DXGI_COLOR_SPACE_TYPE dxgi_color_space;
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

    const HRESULT color_space_hr = swapChain3->SetColorSpace1(dxgi_color_space);
    if (FAILED(color_space_hr)) {
      std::stringstream s;
      s << "utils::device_proxy::GetDeviceProxy(SetColorSpace1 failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(color_space_hr) << std::dec;
      s << ", color_space=" << target_color_space << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
    swapChain3->Release();
  }

  return proxy_device;
}

// clang-format off



























































































// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format on

static ProxySharedResourcePair GetProxySharedResourcePair(
    renodx::utils::resource::ResourceInfo* source_resource_info,
    const reshade::api::resource& source_clone,
    HWND hwnd) {
  if (source_resource_info == nullptr) return {};
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

  if (GetDeviceProxy(source_resource_info, hwnd) == nullptr || proxy_device_reshade == nullptr) {
    assert(false && "GetProxySharedResourcePair called but proxy device is not available");
    return {};
  }

  auto new_desc = source_resource_info->clone_desc;
  if (new_desc.type == reshade::api::resource_type::unknown) {
    new_desc = source_resource_info->desc;
  }
  new_desc.texture.format = target_intermediate_format;
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
  if (source_resource_info->device->get_api() == reshade::api::device_api::opengl) {
    new_desc.flags |= reshade::api::resource_flags::shared_nt_handle;
  }

  reshade::api::resource new_proxy_resource = {0u};
  reshade::api::resource new_host_shared_resource = {0u};
  void* new_shared_handle = nullptr;
  if (!proxy_device_reshade->create_resource(
          new_desc,
          nullptr,
          source_resource_info->initial_state,
          &new_proxy_resource,
          &new_shared_handle)) {
    std::stringstream s;
    s << "utils::device_proxy::GetProxySharedResourcePair(create proxy resource failed: ";
    s << "resource=" << PRINT_PTR(source_clone.handle);
    s << ", proxy_api=" << proxy_device_reshade->get_api();
    s << ", initial_state=0x" << std::hex << static_cast<uint32_t>(source_resource_info->initial_state) << std::dec;
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
        "utils::device_proxy::GetProxySharedResourcePair(create proxy resource returned invalid shared resource/handle)");
    return {};
  }

  void* host_shared_handle = new_shared_handle;
  if (!source_resource_info->device->create_resource(
          new_desc,
          nullptr,
          source_resource_info->initial_state,
          &new_host_shared_resource,
          &host_shared_handle)) {
    proxy_device_reshade->destroy_resource(new_proxy_resource);
    std::stringstream s;
    s << "utils::device_proxy::GetProxySharedResourcePair(create host shared resource failed: ";
    s << "resource=" << PRINT_PTR(source_clone.handle);
    s << ", host_api=" << source_resource_info->device->get_api();
    s << ", proxy_api=" << proxy_device_reshade->get_api();
    s << ", initial_state=0x" << std::hex << static_cast<uint32_t>(source_resource_info->initial_state) << std::dec;
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

  renodx::utils::resource::store->resource_infos[new_proxy_resource.handle] = {
      .device = proxy_device_reshade,
      .desc = new_desc,
      .resource = new_proxy_resource,
      .destroyed = false,
      .initial_state = source_resource_info->initial_state,
  };

  renodx::utils::resource::store->resource_infos[new_host_shared_resource.handle] = {
      .device = source_resource_info->device,
      .desc = new_desc,
      .resource = new_host_shared_resource,
      .destroyed = false,
      .initial_state = source_resource_info->initial_state,
  };

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
  if (!proxy_swapchain_settings_valid) {
    return;
  }
  if (last_device_proxy_shared_resource.handle == 0u) {
    return;
  }

  {
    reshade::api::resource proxy_temp_resource = last_device_proxy_shared_resource;
    if (proxy_temp_resource.handle == 0u) return;

    bool proxy_temp_resource_valid = false;
    reshade::api::resource_desc proxy_temp_desc = {};
    renodx::utils::resource::store->resource_infos.if_contains_unsafe(
        proxy_temp_resource.handle,
        [&](auto& pair) {
          const auto& shared_info = pair.second;
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
      remove_device_proxy = true;
      return;
    }

    if (proxy_device_resource.handle != 0u) {
      auto* proxy_resource_info = renodx::utils::resource::GetResourceInfoUnsafe(proxy_device_resource, false);
      if (proxy_resource_info == nullptr
          || proxy_resource_info->destroyed
          || proxy_resource_info->desc.texture.width != proxy_temp_desc.texture.width
          || proxy_resource_info->desc.texture.height != proxy_temp_desc.texture.height
          || proxy_resource_info->desc.texture.format != proxy_temp_desc.texture.format) {
        if (proxy_device_resource.handle != 0u) {
          device->destroy_resource(proxy_device_resource);
          if (proxy_resource_info != nullptr) {
            proxy_resource_info->destroyed = true;
          }
          proxy_device_resource = {0u};
        }
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
        remove_device_proxy = true;
        return;
      }
      if (proxy_device_resource.handle == 0u) {
        reshade::log::message(
            reshade::log::level::error,
            "utils::device_proxy::OnPresentForProxyDevice(strict failure: proxy staging resource handle is null)");
        remove_device_proxy = true;
        return;
      }

      // (New) Log resource info for proxy device resource
      renodx::utils::resource::store->resource_infos[proxy_device_resource.handle] = {
          .device = device,
          .desc = new_desc,
          .resource = proxy_device_resource,
          .destroyed = false,
          .initial_state = reshade::api::resource_usage::general,
      };
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

static bool OnCreateDevice(reshade::api::device_api api, uint32_t& api_version) {
  if (!use_device_proxy) return false;
  if (api != reshade::api::device_api::d3d9) return false;
  if (api_version == 0x9100) return false;
  if (bypass_dx9_ex_upgrade) return false;

  api_version = 0x9100;  // 0x9000 -> 0x9100, upgrade Direct3D 9 to Direct3D 9Ex
  return true;
}

static void OnInitDevice(reshade::api::device* device) {
  if (!is_creating_proxy_device) return;
  proxy_device_reshade = device;
  renodx::utils::data::Delete<renodx::utils::resource::upgrade::DeviceData>(device);
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
    if (proxy_command_queue != nullptr) {
      proxy_command_queue->Release();
      proxy_command_queue = nullptr;
    }
    if (proxy_device != nullptr) {
      proxy_device->Release();
      proxy_device = nullptr;
    }
    proxied_device_reshade = nullptr;
    if (proxy_device_12 != nullptr) {
      proxy_device_12->Release();
      proxy_device_12 = nullptr;
    }

    proxy_swapchain_settings_valid = false;
    last_device_proxy_shared_resource = {0u};
  } else if (device == proxy_device_reshade) {
    DestroyProxyDeviceResources(device);
    DestroyProxySwapchainPasses(device);
    proxy_swapchain_settings_valid = false;
    last_device_proxy_shared_resource = {0u};
    proxy_device_reshade = nullptr;
    reshade::log::message(reshade::log::level::info, "utils::device_proxy::OnDestroyDevice(Proxy device destroyed.)");
  }
}

// clang-format off

























// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format on

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!use_device_proxy) return;

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
  if (!use_device_proxy) return;

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
  if (!use_device_proxy) return false;
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
  auto* device = swapchain->get_device();
  if (remove_device_proxy) {
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
      renodx::utils::resource::store->resource_infos.for_each([&](const auto& pair) {
        const auto& info = pair.second;
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
            std::vector<reshade::api::resource_view> original_rtvs = rtvs;
            for (auto& rtv : original_rtvs) {
              if (rtv.handle == 0u) continue;
              auto* view_info = renodx::utils::resource::GetResourceViewInfo(rtv);
              if (view_info == nullptr || !view_info->is_clone || view_info->fallback.handle == 0u) continue;
              rtv = view_info->fallback;
            }

            auto dsv = renodx::utils::swapchain::GetDepthStencil(cmd_list);
            if (dsv.handle != 0u) {
              auto* dsv_info = renodx::utils::resource::GetResourceViewInfo(dsv);
              if (dsv_info != nullptr && dsv_info->is_clone && dsv_info->fallback.handle != 0u) {
                dsv = dsv_info->fallback;
              }
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
    remove_device_proxy = false;
    use_device_proxy = false;
    return;
  }
  proxy_teardown_deferred_presents = 0;

  if (!use_device_proxy) return;

  if (device == proxy_device_reshade) {
    OnPresentForProxyDevice(device, queue, swapchain);
    return;
  }
  if (device != proxied_device_reshade) {
    if (proxied_device_reshade != nullptr) return;
    // First present with a new device, mark as proxied device.
    proxied_device_reshade = device;
  }

  if (proxy_settings_dirty.exchange(false, std::memory_order_relaxed)) {
    std::stringstream s;
    s << "utils::device_proxy::OnPresent(reconfiguring proxy runtime after settings change: ";
    s << "target_format=" << target_format;
    s << ", target_color_space=" << target_color_space;
    s << ", target_intermediate_format=" << target_intermediate_format;
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
  auto* resource_info = renodx::utils::resource::GetResourceInfoUnsafe(current_back_buffer);
  if (resource_info == nullptr) {
    assert(resource_info != nullptr);
    return;
  }

  HWND hwnd = static_cast<HWND>(swapchain->get_hwnd());
  auto* new_device = GetDeviceProxy(resource_info, hwnd);
  if (new_device == nullptr) {
    return;
  }
  if (proxy_device_needs_resize.exchange(false)) {
    if (proxy_swap_chain == nullptr) {
      proxy_device_needs_resize.store(true, std::memory_order_relaxed);
      proxy_present_test_pending.store(true, std::memory_order_relaxed);
      return;
    }
    auto width = proxy_resize_width.load(std::memory_order_relaxed);
    auto height = proxy_resize_height.load(std::memory_order_relaxed);

    DXGI_SWAP_CHAIN_DESC1 sc_desc = {};
    const HRESULT desc_hr = proxy_swap_chain->GetDesc1(&sc_desc);
    if (FAILED(desc_hr)) {
      std::stringstream s;
      s << "utils::device_proxy::OnPresent(GetDesc1 before resize failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(desc_hr) << std::dec << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      proxy_device_needs_resize.store(true, std::memory_order_relaxed);
      proxy_present_test_pending.store(true, std::memory_order_relaxed);
      return;
    }

    if (width == 0u) width = (sc_desc.Width != 0u) ? sc_desc.Width : proxy_swapchain_last_width.load();
    if (height == 0u) height = (sc_desc.Height != 0u) ? sc_desc.Height : proxy_swapchain_last_height.load();
    if (width == 0u || height == 0u) {
      reshade::log::message(reshade::log::level::warning,
                            "utils::device_proxy::OnPresent(skip resize: invalid target size)");
      proxy_device_needs_resize.store(true, std::memory_order_relaxed);
      proxy_present_test_pending.store(true, std::memory_order_relaxed);
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
      proxy_device_needs_resize.store(true, std::memory_order_relaxed);
      proxy_present_test_pending.store(true, std::memory_order_relaxed);
      return;
    }

#ifdef DXGI_PRESENT_RESTART
    BOOL fullscreen = FALSE;
    if (SUCCEEDED(proxy_swap_chain->GetFullscreenState(&fullscreen, nullptr)) && (fullscreen != FALSE)) {
      (void)proxy_swap_chain->Present(0, DXGI_PRESENT_RESTART);
    }
#endif

    proxy_swapchain_last_width.store(width, std::memory_order_relaxed);
    proxy_swapchain_last_height.store(height, std::memory_order_relaxed);
    proxy_invalid_call_streak.store(0, std::memory_order_relaxed);
    proxy_present_test_pending.store(true, std::memory_order_relaxed);
  }

  reshade::api::resource swapchain_clone = {0u};
  ProxySharedResourcePair shared_pair = {};
  auto& resource_clone = resource_info->clone;
  proxy_clone_target.new_format = target_intermediate_format;
  switch (target_intermediate_format) {
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

  bool needs_rtv_rewrite = false;
  if (!resource_info->clone_enabled) {
    resource_info->clone_enabled = true;
    needs_rtv_rewrite = true;
  }
  if (resource_info->clone_target == nullptr
      || resource_info->clone_target != &proxy_clone_target) {
    resource_info->clone_target = &proxy_clone_target;
    needs_rtv_rewrite = true;
  }
  if (resource_clone.handle == 0u) {
    // Original swapchain, mark for cloning.
    renodx::utils::resource::upgrade::CloneResource(resource_info);
    needs_rtv_rewrite = true;
  }
  if (resource_clone.handle == 0u) {
    std::stringstream s;
    s << "utils::device_proxy::OnPresent(clone creation failed";
    s << ", format=" << target_intermediate_format;
    s << ", backbuffer=" << PRINT_PTR(current_back_buffer.handle);
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    remove_device_proxy = true;
    return;
  }
  if (needs_rtv_rewrite) {
    auto* cmd_list = queue->get_immediate_command_list();
    auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);
    auto dsv = renodx::utils::swapchain::GetDepthStencil(cmd_list);
    renodx::utils::resource::upgrade::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), dsv);
  }

  swapchain_clone = resource_clone;
  shared_pair = GetProxySharedResourcePair(resource_info, resource_clone, hwnd);
  if (shared_pair.host_shared_resource.handle == 0u
      || shared_pair.proxy_shared_resource.handle == 0u) {
    reshade::log::message(
        reshade::log::level::error,
        "utils::device_proxy::OnPresent(shared intermediate creation failed)");
    remove_device_proxy = true;
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
      (proxy_swap_chain == nullptr) ? 0u : proxy_present_flags.load(std::memory_order_relaxed);
  if (proxy_swap_chain != nullptr
      && proxy_present_test_pending.load(std::memory_order_relaxed)
      && present_flags != 0u) {
    const HRESULT test_hr = proxy_swap_chain->Present(0, DXGI_PRESENT_TEST);
    if (FAILED(test_hr)) {
      const uint32_t streak = proxy_invalid_call_streak.fetch_add(1, std::memory_order_relaxed) + 1;
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
        proxy_device_needs_resize.store(true, std::memory_order_relaxed);
        proxy_present_test_pending.store(false, std::memory_order_relaxed);
        reshade::log::message(reshade::log::level::warning,
                              "utils::device_proxy::OnPresent(promoting TEST failure to resize recovery)");
      }
      return;
    }

    proxy_invalid_call_streak.store(0, std::memory_order_relaxed);
    proxy_present_test_pending.store(false, std::memory_order_relaxed);
  }

  const HRESULT present_hr = proxy_swap_chain->Present(0, present_flags);
  if (FAILED(present_hr)) {
    if (present_hr == DXGI_ERROR_INVALID_CALL) {
      const uint32_t streak = proxy_invalid_call_streak.fetch_add(1, std::memory_order_relaxed) + 1;
      if (streak >= 2u) {
        proxy_device_needs_resize.store(true, std::memory_order_relaxed);
        proxy_present_test_pending.store(true, std::memory_order_relaxed);
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
    proxy_invalid_call_streak.store(0, std::memory_order_relaxed);
  }
}
static void Use(DWORD fdw_reason) {
  renodx::utils::resource::upgrade::use_resource_cloning = true;

  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::resource::upgrade::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "utils::device_proxy attached.");
#if RESHADE_API_VERSION >= 17
      reshade::register_event<reshade::addon_event::create_device>(OnCreateDevice);
#endif

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      renodx::utils::resource::RegisterOnDestroyResourceInfoCallback(&OnDestroyTrackedResourceInfo);

      break;
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
#if RESHADE_API_VERSION >= 17
      reshade::unregister_event<reshade::addon_event::create_device>(OnCreateDevice);
#endif

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      renodx::utils::resource::UnregisterOnDestroyResourceInfoCallback(&OnDestroyTrackedResourceInfo);

      break;
  }
}

}  // namespace renodx::utils::device_proxy
