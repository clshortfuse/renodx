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
#include <memory>
#include <mutex>
#include <shared_mutex>
#include <thread>
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
static bool bypass_dx9_ex_upgrade = false;
static bool device_proxy_wait_idle_source = false;
static bool device_proxy_wait_idle_destination = false;
static void* last_device_proxy_shared_handle = nullptr;
static reshade::api::resource last_device_proxy_shared_resource = {0u};
static std::shared_mutex g_last_device_proxy_mutex;

static thread_local bool is_creating_proxy_device = false;

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

static HANDLE device_proxy_sync_event;
static std::atomic<bool> device_proxy_exit_thread = false;
static std::atomic<bool> device_proxy_thread_running = false;
static bool use_device_proxy_thread = false;
static bool device_proxy_creation_failed = false;

static reshade::api::format target_format = reshade::api::format::r16g16b16a16_float;
static reshade::api::color_space target_color_space = reshade::api::color_space::extended_srgb_linear;
static renodx::utils::resource::ResourceUpgradeInfo proxy_upgrade_target = {
    .new_format = reshade::api::format::r16g16b16a16_float,
    .use_shared_handle = true,
    .usage_set =
        static_cast<uint32_t>(reshade::api::resource_usage::copy_source
                              | reshade::api::resource_usage::copy_dest),
    .use_resource_view_cloning_and_upgrade = true,
};
static renodx::utils::resource::ResourceUpgradeInfo proxy_clone_target = {
    .new_format = reshade::api::format::r16g16b16a16_float,
    .usage_set =
        static_cast<uint32_t>(reshade::api::resource_usage::shader_resource
                              | reshade::api::resource_usage::render_target),
    .use_resource_view_cloning_and_upgrade = true,
};
static renodx::utils::draw::SwapchainProxyPass proxy_swapchain_settings = {};
static bool proxy_swapchain_settings_valid = false;
static std::unordered_map<uint64_t, std::unique_ptr<renodx::utils::draw::SwapchainProxyPass>> proxy_swapchain_passes;

// Methods

static void DestroyProxyDeviceResources(reshade::api::device* device) {
  if (device == nullptr) return;
  if (proxy_device_resource.handle != 0u) {
    device->destroy_resource(proxy_device_resource);
    if (auto* info = renodx::utils::resource::GetResourceInfoUnsafe(proxy_device_resource, false)) {
      info->destroyed = true;
    }
    proxy_device_resource.handle = 0u;
  }
}

static void SetTargetFormat(reshade::api::format format) {
  target_format = format;
}

static void SetTargetColorSpace(reshade::api::color_space color_space) {
  target_color_space = color_space;
}

static void SetProxySettings(const renodx::utils::draw::SwapchainProxyPass& settings) {
  proxy_swapchain_settings = settings;
  proxy_swapchain_settings_valid = true;
  proxy_clone_target.new_format = proxy_swapchain_settings.proxy_format;
  if (proxy_clone_target.new_format == reshade::api::format::r10g10b10a2_unorm) {
    proxy_clone_target.view_upgrades = utils::resource::VIEW_UPGRADES_R10G10B10A2_UNORM;
  } else {
    proxy_clone_target.view_upgrades = utils::resource::VIEW_UPGRADES_RGBA16F;
  }
}

static void DeviceProxyThread() {
  device_proxy_thread_running = true;
  do {
    WaitForSingleObject(device_proxy_sync_event, INFINITE);

    if (device_proxy_exit_thread) break;
    UINT present_flags =
        (proxy_swap_chain == nullptr) ? 0u : proxy_present_flags.load(std::memory_order_relaxed);
    if (proxy_swap_chain == nullptr) {
      continue;
    }
    const HRESULT hr = proxy_swap_chain->Present(0, present_flags);
    if (FAILED(hr) && hr == DXGI_ERROR_INVALID_CALL) {
      const uint32_t streak = proxy_invalid_call_streak.fetch_add(1, std::memory_order_relaxed) + 1;
      if (streak >= 2u) {
        proxy_device_needs_resize.store(true, std::memory_order_relaxed);
        proxy_present_test_pending.store(true, std::memory_order_relaxed);
        reshade::log::message(reshade::log::level::warning,
                              "utils::device_proxy::DeviceProxyThread(schedule resize recovery after invalid-call)");
      }
    } else if (SUCCEEDED(hr)) {
      proxy_invalid_call_streak.store(0, std::memory_order_relaxed);
    }
  } while (true);
  device_proxy_thread_running = false;
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
  sc_desc.BufferCount = 2;
  sc_desc.Width = host_resource_info->desc.texture.width;
  sc_desc.Height = host_resource_info->desc.texture.height;
  if (target_format == reshade::api::format::r10g10b10a2_unorm) {
    sc_desc.Format = DXGI_FORMAT_R10G10B10A2_UNORM;
  } else {
    sc_desc.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
  }
  fullscreen_desc.RefreshRate.Numerator = 0;
  fullscreen_desc.RefreshRate.Denominator = 0;
  sc_desc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
  auto* output_window = hwnd != nullptr ? static_cast<HWND>(hwnd) : GetDesktopWindow();
  sc_desc.SampleDesc.Count = 1;
  fullscreen_desc.Windowed = TRUE;
  sc_desc.SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD;
  sc_desc.Flags = 0;

  sc_desc.Stereo = FALSE;
  sc_desc.SampleDesc.Quality = 0;
  sc_desc.AlphaMode = DXGI_ALPHA_MODE_UNSPECIFIED;
  sc_desc.Scaling = DXGI_SCALING_NONE;
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
  sc_desc.Flags = tearing_supported ? DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING : 0;
  proxy_present_flags.store(
      tearing_supported ? DXGI_PRESENT_ALLOW_TEARING : 0u,
      std::memory_order_relaxed);

  const auto hr = dxgi_factory->CreateSwapChainForHwnd(
      swapchain_creator,
      output_window,
      &sc_desc,
      &fullscreen_desc,
      nullptr,
      &proxy_swap_chain);
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

  proxy_swapchain_last_width.store(sc_desc.Width);
  proxy_swapchain_last_height.store(sc_desc.Height);
  proxy_swapchain_last_hwnd.store(reinterpret_cast<uintptr_t>(output_window));
  proxy_present_test_pending.store(true, std::memory_order_relaxed);
  proxy_invalid_call_streak.store(0, std::memory_order_relaxed);
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
    if (target_color_space == reshade::api::color_space::hdr10_st2084) {
      swapChain3->SetColorSpace1(DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020);
    } else {
      swapChain3->SetColorSpace1(DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709);
    }
    swapChain3->Release();
  }

  if (use_device_proxy_thread) {
    assert(device_proxy_thread_running == false);
    device_proxy_exit_thread = false;
    static std::thread device_proxy_render_thread(DeviceProxyThread);
    device_proxy_render_thread.detach();
  }

  return proxy_device;
}

// clang-format off



























































































// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format off

// Old DrawSwapChainProxy
static void OnPresentForProxyDevice(reshade::api::device* device, reshade::api::command_queue* queue, reshade::api::swapchain* swapchain) {
  auto* cmd_list = queue->get_immediate_command_list();
  auto current_back_buffer = swapchain->get_current_back_buffer();

  if (!proxy_swapchain_settings_valid) {
    return;
  }
  if (last_device_proxy_shared_handle == nullptr && last_device_proxy_shared_resource.handle == 0u) {
    return;
  }

  auto* resource_info = renodx::utils::resource::GetResourceInfoUnsafe(current_back_buffer);
  if (resource_info == nullptr) return;


  {
    const std::lock_guard<std::shared_mutex> lock(g_last_device_proxy_mutex);
    assert(last_device_proxy_shared_handle != nullptr);
    if (last_device_proxy_shared_handle == nullptr) return;
#ifndef RENODX_PROXY_DEVICE_D3D12
    ID3D11Texture2D* shared_texture = nullptr;
    reshade::api::resource proxy_temp_resource = last_device_proxy_shared_resource;
    if (proxy_temp_resource.handle == 0u) {
      if (FAILED(proxy_device->OpenSharedResource(last_device_proxy_shared_handle, IID_PPV_ARGS(&shared_texture)))) {
        reshade::log::message(reshade::log::level::error,
                              "utils::device_proxy::OnPresent(OpenSharedResource failed.)");
        return;
      }
      proxy_temp_resource = {reinterpret_cast<uintptr_t>(shared_texture)};
    }
#else
    ID3D12Resource* shared_texture = nullptr;
    if (FAILED(proxy_device->OpenSharedHandle(last_device_proxy_shared_handle, IID_PPV_ARGS(&shared_texture)))) {
      reshade::log::message(reshade::log::level::error,
                            "utils::device_proxy::OnPresent(OpenSharedHandle failed.)");
      return;
    }
#endif
    if (proxy_device_resource.handle == 0u) {
      // Create proxy device resource

      reshade::api::resource_desc new_desc;
      new_desc.type = reshade::api::resource_type::texture_2d;
      new_desc.texture = {
          .width = resource_info->desc.texture.width,
          .height = resource_info->desc.texture.height,
          .format = reshade::api::format::r16g16b16a16_float};
      new_desc.heap = reshade::api::memory_heap::gpu_only;
      new_desc.usage = reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource;
      device->create_resource(new_desc, nullptr, reshade::api::resource_usage::general, &proxy_device_resource);

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
    if (shared_texture != nullptr) {
      shared_texture->Release();
      shared_texture = nullptr;
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
#ifdef DEBUG_LEVEL_2
    reshade::log::message(reshade::log::level::warning, "utils::device_proxy::OnPresentForProxyDevice(SwapchainProxyPass::Render failed)");
#endif
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
  renodx::utils::resource::upgrade::SetSharedHandleCreatorDevice(device);
  renodx::utils::data::Delete<renodx::utils::resource::upgrade::DeviceData>(device);
}

static void OnDestroyDevice(reshade::api::device* device) {
  // Handle cleanup of the proxied device
  if (device == proxied_device_reshade) {
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
    if (device_proxy_thread_running) {
      device_proxy_exit_thread = true;
      SetEvent(device_proxy_sync_event);
      while (device_proxy_thread_running) {
        YieldProcessor();
        Sleep(0);
      }
    }

    proxy_swapchain_settings_valid = false;
  } else if (device == proxy_device_reshade) {
    DestroyProxyDeviceResources(device);
    DestroyProxySwapchainPasses(device);
    proxy_swapchain_settings_valid = false;
    renodx::utils::resource::upgrade::SetSharedHandleCreatorDevice(nullptr);
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

static void ReleaseProxySwapChain(const char* reason = nullptr) {
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

  if (reason != nullptr) {
    reshade::log::message(reshade::log::level::debug, reason);
  }
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!use_device_proxy) return;

  auto* device = swapchain->get_device();
  if (device == proxy_device_reshade) return;
  if (device != proxied_device_reshade) return;

  // A proxied swapchain was destroyed (or resized). Ensure no stale proxy resources remain.
  DestroyProxySwapchainPasses(proxy_device_reshade);
  DestroyProxyDeviceResources(proxy_device_reshade);

  {
    const std::lock_guard<std::shared_mutex> lock(g_last_device_proxy_mutex);
    last_device_proxy_shared_handle = nullptr;
    last_device_proxy_shared_resource = {0u};
  }

  if (resize) {
    // A host DX9 reset is a hard invalidation boundary for proxy-side state.
    // Recreate the DX11 swapchain on next present instead of relying on ResizeBuffers only.
    ReleaseProxySwapChain("utils::device_proxy::OnDestroySwapchain(recreate proxy swapchain after host reset)");

    proxy_present_test_pending.store(true, std::memory_order_relaxed);
  }

  if (!resize) {
    ReleaseProxySwapChain();
    proxy_present_flags.store(DXGI_PRESENT_ALLOW_TEARING, std::memory_order_relaxed);
  }

  proxy_device_needs_resize = false;
  proxy_resize_width = 0;
  proxy_resize_height = 0;
  proxy_invalid_call_streak.store(0, std::memory_order_relaxed);
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
  if (!use_device_proxy) return;
  {
    auto* device = swapchain->get_device();
    if (device == proxy_device_reshade) {
      OnPresentForProxyDevice(device, queue, swapchain);
      return;
    }
    if (proxied_device_reshade == nullptr) {
      // First present with a new device, mark as proxied device
      proxied_device_reshade = device;
    } else if (device != proxied_device_reshade) {
      // Ignore if not proxied device
      return;
    }

    auto current_back_buffer = swapchain->get_current_back_buffer();
    auto* resource_info = renodx::utils::resource::GetResourceInfoUnsafe(current_back_buffer);
    if (resource_info == nullptr) {
      assert(resource_info != nullptr);
      return;
    }

    HWND hwnd = static_cast<HWND>(swapchain->get_hwnd());
    // if (hwnd != nullptr) {
    //   const BOOL is_visible = IsWindowVisible(hwnd);
    //   const BOOL is_iconic = IsIconic(hwnd);
    //   const bool window_active = (is_visible != FALSE) && (is_iconic == FALSE);
    //   if (!window_active) {
    //     return;
    //   }
    // }

    auto* new_device = GetDeviceProxy(resource_info, hwnd);
    if (new_device == nullptr) {
#ifdef DEBUG_LEVEL_2
      {
        std::stringstream s;
        s << "utils::device_proxy::OnPresent(skip: GetDeviceProxy failed, hwnd=";
        s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
        s << ", backbuffer=" << PRINT_PTR(current_back_buffer.handle) << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
      }
#endif
      return;
    }
    if (resource_info == nullptr) return;

    reshade::api::resource swapchain_clone;

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
      {
        const std::lock_guard<std::shared_mutex> lock(g_last_device_proxy_mutex);
        last_device_proxy_shared_handle = nullptr;
        last_device_proxy_shared_resource = {0u};
      }

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

    auto& resource_clone = resource_info->clone;
    if (resource_clone.handle == 0u) {
      // Original swapchain, mark for cloning
      if (!resource_info->clone_enabled || resource_info->clone_target == nullptr) {
        resource_info->clone_enabled = true;
        resource_info->clone_target = &proxy_clone_target;
      }
      renodx::utils::resource::upgrade::CloneResource(resource_info);
      auto* cmd_list = queue->get_immediate_command_list();
      auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);
      auto dsv = renodx::utils::swapchain::GetDepthStencil(cmd_list);
      renodx::utils::resource::upgrade::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), dsv);
    }
    if (resource_clone.handle == 0u) return;
    swapchain_clone = resource_clone;

    // Get ResourceCloneInfo
    auto* resource_clone_info = renodx::utils::resource::GetResourceInfo(resource_clone);
    if (resource_clone_info == nullptr) return;
    if (resource_clone_info->clone.handle == 0u) {
      resource_clone_info->clone_target = &proxy_upgrade_target;
      renodx::utils::resource::upgrade::CloneResource(resource_clone_info);
    }
    if (resource_clone_info->clone.handle == 0u) return;
    if (resource_clone_info->shared_handle == nullptr) return;

    // Ready to copy
    // Copy to shared resource

    // Serialize the copy + publish step to avoid races with the DX11 consumer
    // claiming the shared handle. When keyed mutex is available this is not
    // needed, but for the DX9 fallback we rely on a CPU-side handoff.

    {
      const std::lock_guard<std::shared_mutex> lock(g_last_device_proxy_mutex);

      // Should DXGIKeyedMutex acquire

      // Backport fix for Reshade DX9 resource copying
      if (device->get_api() == reshade::api::device_api::d3d9) {
        auto* native = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
        auto* src_res = reinterpret_cast<IDirect3DResource9*>(swapchain_clone.handle);
        auto* dst_res = reinterpret_cast<IDirect3DResource9*>(resource_clone_info->clone.handle);
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

        const HRESULT hr = native->StretchRect(src_surface, nullptr, dst_surface, nullptr, D3DTEXF_NONE);

        assert(SUCCEEDED(hr));
      } else {
        queue->get_immediate_command_list()->copy_resource(swapchain_clone, resource_clone_info->clone);
      }

      // Should DXGIKeyedMutex acquire
      queue->flush_immediate_command_list();
      if (device_proxy_wait_idle_source) {
        // Should DXGIKeyedMutex release
        queue->wait_idle();
      }

      // Publish the shared handle and resource under the lock so the consumer
      // cannot observe a partially-written handoff.
      last_device_proxy_shared_handle = resource_clone_info->shared_handle;
      last_device_proxy_shared_resource = resource_clone_info->proxy_resource;
    }

    // Trigger a DX11 Present which will start the swapchain proxy steps on DX11
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
    if (use_device_proxy_thread) {
      SetEvent(device_proxy_sync_event);  // Signal the DX11 render thread
    } else {
      const HRESULT hr = proxy_swap_chain->Present(0, present_flags);
      if (FAILED(hr)) {
        if (hr == DXGI_ERROR_INVALID_CALL) {
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
        s << std::hex << static_cast<uint32_t>(hr) << std::dec;
        s << ", flags=0x" << std::hex << present_flags << std::dec << ")";
        reshade::log::message(reshade::log::level::error, s.str().c_str());
      } else {
        proxy_invalid_call_streak.store(0, std::memory_order_relaxed);
      }
    }
  }
}

static void Use(DWORD fdw_reason) {
  renodx::utils::resource::Use(fdw_reason);

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

      // Create sync event for device proxy thread
      device_proxy_sync_event = CreateEvent(nullptr, FALSE, FALSE, nullptr);

      break;
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      if (device_proxy_sync_event != nullptr) {
        CloseHandle(device_proxy_sync_event);
        device_proxy_sync_event = nullptr;
      }
#if RESHADE_API_VERSION >= 17
      reshade::unregister_event<reshade::addon_event::create_device>(OnCreateDevice);
#endif

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      break;
  }
}

}  // namespace renodx::utils::device_proxy
