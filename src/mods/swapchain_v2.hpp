/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <d3d9.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <windef.h>

#include <frozen/unordered_map.h>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <include/reshade_api_device.hpp>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <sstream>
#include <string>
#include <thread>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "../utils/bitwise.hpp"
#include "../utils/data.hpp"
#include "../utils/device_proxy.hpp"
#include "../utils/draw.hpp"
#include "../utils/format.hpp"
#include "../utils/mutex.hpp"
#include "../utils/pipeline.hpp"
#include "../utils/resource.hpp"
#include "../utils/resource_upgrade.hpp"
#include "../utils/state.hpp"
#include "../utils/swapchain.hpp"
#include "../utils/windowing.hpp"

namespace renodx::mods::swapchain::v2 {

using ResourceUpgradeInfo = utils::resource::ResourceUpgradeInfo;
using SwapChainUpgradeTarget = utils::resource::ResourceUpgradeInfo;

struct __declspec(uuid("d8712fa7-66e5-45e2-9e07-80fe6354f507")) DeviceData {
  std::shared_mutex mutex;

  std::unordered_map<reshade::api::swapchain*, reshade::api::swapchain_desc> upgraded_swapchains;

  reshade::api::resource_desc primary_swapchain_desc;

  bool prevent_full_screen = false;
  bool fake_fullscreen_pending = false;

  reshade::api::pipeline_layout swap_chain_proxy_layout = {0};
  reshade::api::pipeline swap_chain_proxy_pipeline = {0};
  reshade::api::sampler swap_chain_proxy_sampler = {0};

  std::span<const std::uint8_t> swap_chain_proxy_vertex_shader;
  std::span<const std::uint8_t> swap_chain_proxy_pixel_shader;
  int32_t expected_constant_buffer_index = -1;
  uint32_t expected_constant_buffer_space = 0;
  bool swapchain_proxy_revert_state = false;

  // When proxying, use this clone info on swap chain and its views
  utils::resource::ResourceUpgradeInfo swap_chain_clone_info = {
      .new_format = reshade::api::format::r16g16b16a16_float,
      .usage_set =
          static_cast<uint32_t>(
              reshade::api::resource_usage::shader_resource
              | reshade::api::resource_usage::render_target),
      .use_resource_view_cloning_and_upgrade = true,
  };

  // When upgrading, use this upgrade info on swap chain and its views
  utils::resource::ResourceUpgradeInfo swap_chain_upgrade_info = {
      .new_format = reshade::api::format::r16g16b16a16_float,
      .usage_set =
          static_cast<uint32_t>(
              reshade::api::resource_usage::shader_resource
              | reshade::api::resource_usage::render_target),
      .use_resource_view_cloning_and_upgrade = true,
  };

  HWND primary_swapchain_window = nullptr;

  // <swap_chain_back_buffer_handle, SwapchainProxyPass*>
  std::unordered_map<uint64_t, renodx::utils::draw::SwapchainProxyPass*> swapchain_proxy_passes;
};

// Variables

static bool attached = false;
static std::vector<utils::resource::ResourceUpgradeInfo> resource_upgrade_infos = {};

// Legacy name
[[deprecated("Use resource_upgrade_infos instead")]]
static std::vector<utils::resource::ResourceUpgradeInfo>& swap_chain_upgrade_targets = resource_upgrade_infos;
static reshade::api::format target_format = reshade::api::format::r16g16b16a16_float;
static reshade::api::color_space target_color_space = reshade::api::color_space::extended_srgb_linear;
static bool set_color_space = true;
static bool use_shared_device = false;
static bool& use_resource_cloning = utils::resource::upgrade::use_resource_cloning;
static bool use_resize_buffer = false;
static bool use_resize_buffer_on_set_full_screen = false;
static bool use_resize_buffer_on_demand = false;
static bool use_resize_buffer_on_present = false;
static bool& device_proxy_wait_idle_source = utils::device_proxy::device_proxy_wait_idle_source;
static bool& device_proxy_wait_idle_destination = utils::device_proxy::device_proxy_wait_idle_destination;
static bool upgrade_resource_views = true;
static bool prevent_full_screen = true;
static bool force_borderless = true;
static bool force_screen_tearing = true;
static bool swapchain_proxy_compatibility_mode = true;
static bool swapchain_proxy_revert_state = false;
static bool& use_device_proxy = utils::device_proxy::use_device_proxy;
static bool& use_auto_cloning = utils::resource::upgrade::use_auto_cloning;
static bool prevent_multiple_flip_swapchains_per_window = true;

static bool bypass_dummy_windows = true;
[[deprecated("Use use_auto_cloning instead")]]
static bool& use_auto_upgrade = utils::resource::upgrade::use_auto_cloning;
static std::unordered_set<std::string> ignored_window_class_names = {};
static std::unordered_set<reshade::api::device_api> ignored_device_apis = {};
static reshade::api::format swap_chain_proxy_format = reshade::api::format::r16g16b16a16_float;
static std::span<const std::uint8_t> swap_chain_proxy_vertex_shader = {};
static std::span<const std::uint8_t> swap_chain_proxy_pixel_shader = {};
static int32_t expected_constant_buffer_index = -1;
static uint32_t expected_constant_buffer_space = 0;
static float* shader_injection = nullptr;
static size_t shader_injection_size = 0;
struct SwapChainProxyShaders {
  std::span<const std::uint8_t> vertex_shader;
  std::span<const std::uint8_t> pixel_shader;
};
static std::unordered_map<reshade::api::device_api, SwapChainProxyShaders> swap_chain_proxy_shaders = {};
static thread_local std::optional<reshade::api::swapchain_desc> original_swapchain_desc;
static thread_local std::optional<reshade::api::swapchain_desc> upgraded_swapchain_desc;
static thread_local std::optional<reshade::api::resource> local_original_resource;
static thread_local std::optional<reshade::api::resource_desc> local_original_resource_desc;
static thread_local std::optional<reshade::api::resource_view_desc> local_original_resource_view_desc;
static utils::data::ParallelNodeHashMap<HWND, std::unordered_set<reshade::api::swapchain*>, std::shared_mutex> flip_swapchains_by_window;

// Methods

static void DeviceProxyThread() {
  // Moved to utils::device_proxy
}

static ID3D11Device* GetDeviceProxy(renodx::utils::resource::ResourceInfo* host_resource_info, HWND hwnd = nullptr) {
  return renodx::utils::device_proxy::GetDeviceProxy(host_resource_info, hwnd);
}

// clang-format off











































// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format on

static bool UsingSwapchainCompatibilityMode() {
  return swapchain_proxy_compatibility_mode && (target_format == swap_chain_proxy_format);
}

static void RemoveWindowBorder(HWND window) {
  renodx::utils::windowing::RemoveWindowBorder(window);
}

static void CheckSwapchainSize(
    reshade::api::swapchain* swapchain,
    const reshade::api::resource_desc& buffer_desc) {
  if (!prevent_full_screen && !force_borderless) return;
  HWND output_window = static_cast<HWND>(swapchain->get_hwnd());
  if (output_window == nullptr) {
    reshade::log::message(reshade::log::level::debug, "No HWND?");
    return;
  }

  if (utils::swapchain::IsDXGI(swapchain)) {
    auto* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    if (prevent_full_screen) {
      IDXGIFactory2* factory;
      if (SUCCEEDED(native_swapchain->GetParent(IID_PPV_ARGS(&factory)))) {
        factory->MakeWindowAssociation(output_window, DXGI_MWA_NO_WINDOW_CHANGES);
        reshade::log::message(reshade::log::level::debug, "mods::swapchain::CheckSwapchainSize(set DXGI_MWA_NO_WINDOW_CHANGES)");
        factory->Release();
        factory = nullptr;
      } else {
        reshade::log::message(reshade::log::level::error, "mods::swapchain::CheckSwapchainSize(could not find DXGI factory)");
      }
    }
  }

  if (force_borderless) {
    utils::windowing::RemoveWindowBorder(output_window);

    HMONITOR monitor = MonitorFromWindow(output_window, MONITOR_DEFAULTTONEAREST);
    if (monitor == nullptr) {
      reshade::log::message(reshade::log::level::error, "mods::swapchain::OnSetFullscreenState(could not get monitor)");
      return;
    }
    MONITORINFO monitor_info = {};
    monitor_info.cbSize = sizeof(MONITORINFO);

    GetMonitorInfo(monitor, &monitor_info);

    const int screen_width = monitor_info.rcMonitor.right - monitor_info.rcMonitor.left;
    const int screen_height = monitor_info.rcMonitor.bottom - monitor_info.rcMonitor.top;

    std::stringstream s;
    s << "mods::swapchain::CheckSwapchainSize(";
    s << "screen_width: " << screen_width;
    s << ", screen_height: " << screen_height;
    s << ", buffer_width: " << buffer_desc.texture.width;
    s << ", buffer_height: " << buffer_desc.texture.height;
    s << ", buffer_format: " << buffer_desc.texture.format;
    s << ", target_format: " << target_format;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    if (screen_width != buffer_desc.texture.width) return;
    if (screen_height != buffer_desc.texture.height) return;
    // if (window_rect.top == 0 && window_rect.left == 0) return;

    utils::windowing::SetWindowPositionAndSize(
        output_window,
        monitor_info.rcMonitor.left,
        monitor_info.rcMonitor.top,
        buffer_desc.texture.width,
        buffer_desc.texture.height);
  }
}

static bool OnSwapchainWindowMessage(
    HWND hwnd,
    UINT msg,
    WPARAM wparam,
    LPARAM lparam,
    LRESULT* out_result,
    void* callback_context) {
  if (msg == WM_ACTIVATEAPP && (wparam != FALSE)) {
    utils::windowing::RestoreWindowIfMinimized(hwnd, true);
  }
  return false;
}

static reshade::api::descriptor_table_update CloneDescriptorUpdateWithResourceView(
    const reshade::api::descriptor_table_update& update,
    const reshade::api::resource_view& view,
    const uint32_t& index = 0) {
  return renodx::utils::descriptor::CloneDescriptorUpdateWithResourceView(update, view, index);
}

static bool FlushResourceViewInDescriptorTable(
    reshade::api::device* device,
    const reshade::api::resource& resource) {
  return renodx::utils::resource::upgrade::FlushResourceViewInDescriptorTable(device, resource);
}

inline bool ActivateCloneHotSwap(
    reshade::api::device* device,
    const reshade::api::resource_view& resource_view) {
  return utils::resource::upgrade::ActivateCloneHotSwap(device, resource_view);
}

inline bool DeactivateCloneHotSwap(
    reshade::api::device* device,
    const reshade::api::resource_view& resource_view) {
  return utils::resource::upgrade::DeactivateCloneHotSwap(device, resource_view);
}

inline reshade::api::resource CloneResource(utils::resource::ResourceInfo* resource_info) {
  return renodx::utils::resource::upgrade::CloneResource(resource_info);
}

inline reshade::api::resource CloneResource(const reshade::api::resource& resource) {
  return renodx::utils::resource::upgrade::CloneResource(resource);
}

inline void SetupSwapchainProxyLayout(reshade::api::device* device, DeviceData* data) {
  // moved to utils::device_proxy
}

inline reshade::api::resource GetResourceClone(utils::resource::ResourceInfo* resource_info = nullptr) {
  return utils::resource::upgrade::GetResourceClone(resource_info);
}

inline reshade::api::resource GetResourceClone(const reshade::api::resource& resource) {
  return utils::resource::upgrade::GetResourceClone(resource);
}

inline reshade::api::resource_view GetResourceViewClone(
    utils::resource::ResourceViewInfo* resource_view_info = nullptr) {
  return utils::resource::upgrade::GetResourceViewClone(resource_view_info);
}

inline reshade::api::resource_view GetResourceViewClone(const reshade::api::resource_view& view) {
  return utils::resource::upgrade::GetResourceViewClone(view);
}

inline reshade::api::resource_view* ApplyRenderTargetClones(
    const reshade::api::resource_view* rtvs,
    const uint32_t& count) {
  return utils::resource::upgrade::ApplyRenderTargetClones(rtvs, count);
}

inline reshade::api::render_pass_render_target_desc* ApplyRenderTargetClones(
    const reshade::api::render_pass_render_target_desc* rts,
    const uint32_t& count) {
  return utils::resource::upgrade::ApplyRenderTargetClones(rts, count);
}

inline void RewriteRenderTargets(
    reshade::api::command_list* cmd_list,
    const uint32_t& count,
    const reshade::api::resource_view* rtvs,
    const reshade::api::resource_view& dsv) {
  renodx::utils::resource::upgrade::RewriteRenderTargets(cmd_list, count, rtvs, dsv);
}

inline void DiscardDescriptors(reshade::api::command_list* cmd_list) {
  utils::resource::upgrade::DiscardDescriptors(cmd_list);
}

inline void FlushDescriptors(reshade::api::command_list* cmd_list) {
  utils::resource::upgrade::FlushDescriptors(cmd_list);
}

inline void DrawSwapChainProxy(reshade::api::swapchain* swapchain, reshade::api::command_queue* queue) {
}

static void SetUseHDR10(const bool& value = true) {
  if (value) {
    target_format = reshade::api::format::r10g10b10a2_unorm;
    target_color_space = reshade::api::color_space::hdr10_st2084;
  } else {
    target_format = reshade::api::format::r16g16b16a16_float;
    target_color_space = reshade::api::color_space::extended_srgb_linear;
  }
  utils::device_proxy::SetTargetFormat(target_format);
  utils::device_proxy::SetTargetColorSpace(target_color_space);
}

inline void SetUpgradeResourceViews(const bool& value = true) {
  upgrade_resource_views = value;
}

// Hooks

static void OnInitDevice(reshade::api::device* device) {
  if (ignored_device_apis.contains(device->get_api())) {
    std::stringstream s;
    s << "mods::swapchain::OnInitDevice(Abort from ignored device api: ";
    s << static_cast<uint32_t>(device->get_api());
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return;
  }
  std::stringstream s;
  s << "mods::swapchain::OnInitDevice(";
  s << PRINT_PTR((uintptr_t)(device));
  s << ", native: " << PRINT_PTR((uintptr_t)(device->get_native()));
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  auto* data = renodx::utils::data::Create<DeviceData>(device);

  renodx::utils::resource::upgrade::SetUpgradeInfos(device, resource_upgrade_infos);

  const bool prevent_exclusive = use_device_proxy || prevent_full_screen;
  data->prevent_full_screen = prevent_exclusive;

  if (prevent_exclusive && device->get_api() == reshade::api::device_api::d3d9) {
    auto* native_device = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
    const HRESULT hr = native_device->SetDialogBoxMode(TRUE);
    if (FAILED(hr)) {
      std::stringstream s;
      s << "mods::swapchain::OnInitDevice(SetDialogBoxMode failed: hr=0x";
      s << std::hex << static_cast<uint32_t>(hr) << std::dec << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    } else {
#ifdef DEBUG_LEVEL_0
      reshade::log::message(reshade::log::level::debug,
                            "mods::swapchain::OnInitDevice(SetDialogBoxMode enabled)");
#endif
    }
  }

  if (!swap_chain_proxy_shaders.empty()) {
    if (auto pair = swap_chain_proxy_shaders.find(device->get_api());
        pair != swap_chain_proxy_shaders.end()) {
      data->swap_chain_proxy_vertex_shader = pair->second.vertex_shader;
      data->swap_chain_proxy_pixel_shader = pair->second.pixel_shader;
    }
  } else {
    data->swap_chain_proxy_vertex_shader = swap_chain_proxy_vertex_shader;
    data->swap_chain_proxy_pixel_shader = swap_chain_proxy_pixel_shader;
  }
  data->swapchain_proxy_revert_state = swapchain_proxy_revert_state;
  data->expected_constant_buffer_index = expected_constant_buffer_index;
  data->expected_constant_buffer_space = expected_constant_buffer_space;

  if (utils::device_proxy::use_device_proxy) {
    renodx::utils::draw::SwapchainProxyPass proxy_settings;
    proxy_settings.vertex_shader = data->swap_chain_proxy_vertex_shader;
    proxy_settings.pixel_shader = data->swap_chain_proxy_pixel_shader;
    proxy_settings.expected_constant_buffer_index = data->expected_constant_buffer_index;
    proxy_settings.expected_constant_buffer_space = data->expected_constant_buffer_space;
    proxy_settings.revert_state = data->swapchain_proxy_revert_state;
    proxy_settings.use_compatibility_mode = UsingSwapchainCompatibilityMode();
    proxy_settings.proxy_format = swap_chain_proxy_format;
    proxy_settings.shader_injection = shader_injection;
    proxy_settings.shader_injection_size = shader_injection_size;
    renodx::utils::device_proxy::SetProxySettings(proxy_settings);
  }
}

static void DestroySwapchainProxyItems(reshade::api::device* device, DeviceData* data) {
  for (auto& [handle, pass] : data->swapchain_proxy_passes) {
    assert(pass != nullptr);
    pass->Destroy(device);
  }
  data->swapchain_proxy_passes.clear();
}

static void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::swapchain::OnDestroyDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;

  DestroySwapchainProxyItems(device, data);
  renodx::utils::data::Delete(device, data);
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
}

static bool ShouldModifySwapchain(HWND hwnd, reshade::api::device_api device_api) {
  if (!ignored_device_apis.empty()) {
    if (ignored_device_apis.contains(device_api)) {
      std::stringstream s;
      s << "mods::swapchain::ShouldModifySwapchain(Abort from ignored device api: ";
      s << static_cast<uint32_t>(device_api);
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
      return false;
    }
  }

  if (renodx::utils::platform::IsToolWindow(hwnd)) {
    std::stringstream s;
    s << "mods::swapchain::ShouldModifySwapchain(Tool Window: ";
    s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return false;
  }

  auto class_name = renodx::utils::platform::GetWindowClassName(hwnd);
  {
    std::stringstream s;
    s << "mods::swapchain::ShouldModifySwapchain(Checking class name: ";
    s << class_name;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  if (bypass_dummy_windows) {
    auto lower_case_view = class_name | std::views::transform([](auto c) { return std::tolower(c); });
    if (!std::ranges::search(lower_case_view, std::string("dummy")).empty()) {
      std::stringstream s;
      s << "mods::swapchain::ShouldModifySwapchain(Dummy window: ";
      s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
      return false;
    }
  }

  if (!ignored_window_class_names.empty()) {
    if (!class_name.empty()) {
      if (ignored_window_class_names.contains(class_name)) {
        std::stringstream s;
        s << "mods::swapchain::ShouldModifySwapchain(Ignored class name: ";
        s << class_name;
        s << ", hwnd: ";
        s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
        return false;
      }
    }
  }

  return true;
}

// Before CreatePipelineState
#if RESHADE_API_VERSION >= 17
static bool OnCreateSwapchain(reshade::api::device_api device_api, reshade::api::swapchain_desc& desc, void* hwnd) {
#else
static bool OnCreateSwapchain(reshade::api::swapchain_desc& desc, void* hwnd) {
  reshade::api::device_api device_api = reshade::api::device_api::d3d11;
#endif
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnCreateSwapchain()");
  original_swapchain_desc = desc;
  upgraded_swapchain_desc.reset();

  if (!renodx::utils::bitwise::HasFlag(desc.back_buffer.usage, reshade::api::resource_usage::render_target)) {
    return false;
  }

  bool is_dxgi = false;
  switch (device_api) {
    case reshade::api::device_api::d3d10:
    case reshade::api::device_api::d3d11:
    case reshade::api::device_api::d3d12:
      is_dxgi = true;
    case reshade::api::device_api::d3d9:
    case reshade::api::device_api::opengl:
    case reshade::api::device_api::vulkan:
      break;
    default:
      assert(false);
      break;
  }

  if (!ShouldModifySwapchain(static_cast<HWND>(hwnd), device_api)) {
    std::stringstream s;
    s << "mods::swapchain::OnCreateSwapchain(Abort from ShouldModifySwapchain: ";
    s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return false;
  }

  auto old_fullscreen_state = desc.fullscreen_state;
  auto old_fullscreen_refresh_rate = desc.fullscreen_refresh_rate;
  auto old_format = desc.back_buffer.texture.format;
  auto old_present_mode = desc.present_mode;
  auto old_present_flags = desc.present_flags;
  auto old_buffer_count = desc.back_buffer_count;

  if (is_dxgi) {
    if (!use_resize_buffer && !use_device_proxy) {
      desc.back_buffer.texture.format = target_format;

      if (desc.back_buffer_count == 1) {
        // 0 is only for resize, so if game uses more than 2 buffers, that will be retained
        desc.back_buffer_count = 2;
      }
    }

    if (!use_device_proxy) {
      switch (desc.present_mode) {
        case static_cast<uint32_t>(DXGI_SWAP_EFFECT_SEQUENTIAL):
          desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL);
          break;
        case static_cast<uint32_t>(DXGI_SWAP_EFFECT_DISCARD):
          desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD);
          break;
      }
    }

    if (!use_resize_buffer) {
      if (prevent_full_screen) {
        desc.present_flags &= ~DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;
      }
      if (force_screen_tearing) {
        if (desc.present_mode != static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL)
            && desc.present_mode != static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD)) {
          reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnCreateSwapchain(Force ALLOW_TEARING flag with non-flip present mode)");
        } else {
          desc.present_flags |= DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;
        }
      }
    }
  } else if (device_api == reshade::api::device_api::d3d9) {
    if (prevent_full_screen || use_device_proxy) {
      desc.present_flags &= ~D3DPRESENTFLAG_LOCKABLE_BACKBUFFER;
      // desc.present_mode |= D3DSWAPEFFECT_FLIPEX;
    }
  } else if (device_api == reshade::api::device_api::opengl) {
    // Nothing for now
  }
  if (prevent_full_screen || use_device_proxy) {
    if (desc.fullscreen_state) {
      desc.fullscreen_state = false;
      desc.fullscreen_refresh_rate = 0.0f;
    }
  }

  bool changed = (old_format != desc.back_buffer.texture.format)
                 || (old_present_mode != desc.present_mode)
                 || (old_present_flags != desc.present_flags)
                 || (old_fullscreen_state != desc.fullscreen_state)
                 || (old_fullscreen_refresh_rate != desc.fullscreen_refresh_rate);

  if (prevent_multiple_flip_swapchains_per_window
      && is_dxgi
      && (desc.present_mode == static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL)
          || desc.present_mode == static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD))
      && flip_swapchains_by_window.contains(static_cast<HWND>(hwnd))) {
    // https://learn.microsoft.com/en-us/windows/win32/api/d3d11/nf-d3d11-id3d11devicecontext-flush#deferred-destruction-issues-with-flip-presentation-swap-chains
    // Must flush other flip devices
    // Abort any modification and let it display in SDR
    reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnCreateSwapchain(Flip swapchain already exists for this window, aborting modification)");
    return false;
  }

  if (!changed) {
    std::stringstream s;
    s << "mods::swapchain::OnCreateSwapchain(Abort from unchanged desc: ";
    s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return false;
  }

  std::stringstream s;
  s << "mods::swapchain::OnCreateSwapchain(";
  s << "swap: " << old_format << " => " << desc.back_buffer.texture.format;
  s << ", present mode: 0x" << std::hex << old_present_mode << std::dec << " => 0x" << std::hex << desc.present_mode << std::dec;
  s << ", present flag: 0x" << std::hex << old_present_flags << std::dec;

  static constexpr auto DXGI_SWAP_CHAIN_FLAG_NAMES = frozen::make_unordered_map<uint32_t, const char*>({
      {DXGI_SWAP_CHAIN_FLAG_NONPREROTATED, "NONPREROTATED"},
      {DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH, "ALLOW_MODE_SWITCH"},
      {DXGI_SWAP_CHAIN_FLAG_GDI_COMPATIBLE, "GDI_COMPATIBLE"},
      {DXGI_SWAP_CHAIN_FLAG_RESTRICTED_CONTENT, "RESTRICTED_CONTENT"},
      {DXGI_SWAP_CHAIN_FLAG_RESTRICT_SHARED_RESOURCE_DRIVER, "RESTRICT_SHARED_RESOURCE_DRIVER"},
      {DXGI_SWAP_CHAIN_FLAG_DISPLAY_ONLY, "DISPLAY_ONLY"},
      {DXGI_SWAP_CHAIN_FLAG_FRAME_LATENCY_WAITABLE_OBJECT, "FRAME_LATENCY_WAITABLE_OBJECT"},
      {DXGI_SWAP_CHAIN_FLAG_FOREGROUND_LAYER, "FOREGROUND_LAYER"},
      {DXGI_SWAP_CHAIN_FLAG_FULLSCREEN_VIDEO, "FULLSCREEN_VIDEO"},
      {DXGI_SWAP_CHAIN_FLAG_YUV_VIDEO, "YUV_VIDEO"},
      {DXGI_SWAP_CHAIN_FLAG_HW_PROTECTED, "HW_PROTECTED"},
      {DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING, "ALLOW_TEARING"},
      {DXGI_SWAP_CHAIN_FLAG_RESTRICTED_TO_ALL_HOLOGRAPHIC_DISPLAYS, "RESTRICTED_TO_ALL_HOLOGRAPHIC_DISPLAYS"},
  });
  {
    bool has_flag = false;
    for (const auto& [flag_value, flag_string] : DXGI_SWAP_CHAIN_FLAG_NAMES) {
      if (renodx::utils::bitwise::HasFlag(old_present_flags, flag_value)) {
        s << (has_flag ? " | " : " (") << flag_string;
        has_flag = true;
      }
    }
    if (has_flag) s << ")";
  }

  s << " => ";
  s << "0x" << std::hex << desc.present_flags << std::dec;

  if (old_present_flags != desc.present_flags) {
    bool has_flag = false;
    for (const auto& [flag_value, flag_string] : DXGI_SWAP_CHAIN_FLAG_NAMES) {
      if (renodx::utils::bitwise::HasFlag(desc.present_flags, flag_value)) {
        s << (has_flag ? " | " : " (") << flag_string;
        has_flag = true;
      }
    }
    if (has_flag) s << ")";
  }

  s << ", buffers:" << old_buffer_count << " => " << desc.back_buffer_count;
  s << ", fullscreen:" << old_fullscreen_state << " => " << desc.fullscreen_state;
  s << ", refresh:" << old_fullscreen_refresh_rate << " => " << desc.fullscreen_refresh_rate;
  s << ", width: " << desc.back_buffer.texture.width;
  s << ", height: " << desc.back_buffer.texture.height;
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  upgraded_swapchain_desc = desc;

  return true;
}

static void OnPresentForResizeBuffer(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  if (use_resize_buffer_on_demand && !use_resize_buffer_on_present) return;
  reshade::unregister_event<reshade::addon_event::present>(OnPresentForResizeBuffer);
  renodx::utils::swapchain::ResizeBuffer(swapchain, target_format, target_color_space);
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  std::stringstream s;
  s << "mods::swapchain::OnInitSwapchain(";
  s << PRINT_PTR(reinterpret_cast<uintptr_t>(swapchain));
  s << ", resize: " << (resize ? "true" : "false");
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());

  auto* device = swapchain->get_device();

  HWND hwnd = static_cast<HWND>(swapchain->get_hwnd());

  if (!resize && utils::swapchain::IsDXGI(swapchain)) {
    if (hwnd != nullptr) {
      const auto& desc = upgraded_swapchain_desc.has_value() ? upgraded_swapchain_desc.value() : original_swapchain_desc.value();

      if (desc.present_mode == static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL)
          || desc.present_mode == static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD)) {
        flip_swapchains_by_window[hwnd].insert(swapchain);
      }
    }
  }

  if (use_device_proxy && device == utils::device_proxy::proxy_device_reshade) {
    // Don't modify proxy device swapchains
    reshade::log::message(reshade::log::level::info, "mods::swapchain::OnInitSwapchain(Abort for proxy device swapchain.)");
    return;
  }

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;

  auto abort_modification = [=]() {
    data->upgraded_swapchains.erase(swapchain);
    if (data->upgraded_swapchains.empty()) {
      DestroySwapchainProxyItems(device, data);
      renodx::utils::data::Delete(device, data);
    }
  };

  if (!ShouldModifySwapchain(hwnd, device->get_api())) {
    std::stringstream s;
    s << "mods::swapchain::OnInitSwapchain(Abort from ShouldModifySwapchain: ";
    s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    abort_modification();
    return;
  }

  auto primary_swapchain_desc = device->get_resource_desc(swapchain->get_current_back_buffer());

  bool upgraded_resource_format = false;

  {
    const std::unique_lock lock(data->mutex);
    if (upgraded_swapchain_desc.has_value()) {
      data->upgraded_swapchains[swapchain] = upgraded_swapchain_desc.value();
      data->swap_chain_upgrade_info.new_format = upgraded_swapchain_desc.value().back_buffer.texture.format;

      if (original_swapchain_desc->fullscreen_state && !upgraded_swapchain_desc->fullscreen_state) {
        data->fake_fullscreen_pending = true;
        utils::windowing::HookSwapchainWindowProc(hwnd, OnSwapchainWindowMessage, nullptr);
        std::stringstream s;
        s << "mods::swapchain::OnInitSwapchain(fake_fullscreen_pending=1, hwnd="
          << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd))
          << ", reason=virtualize_initial_fullscreen)";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }

      if (original_swapchain_desc->back_buffer.texture.format != upgraded_swapchain_desc->back_buffer.texture.format) {
        upgraded_resource_format = true;
        data->swap_chain_upgrade_info.new_format = upgraded_swapchain_desc->back_buffer.texture.format;
        if (upgraded_swapchain_desc->back_buffer.texture.format == reshade::api::format::r10g10b10a2_unorm) {
          data->swap_chain_upgrade_info.view_upgrades = utils::resource::VIEW_UPGRADES_R10G10B10A2_UNORM;
        }
      }
      upgraded_swapchain_desc.reset();
    } else {
      data->swap_chain_upgrade_info.new_format = primary_swapchain_desc.texture.format;
    }
    data->primary_swapchain_desc = primary_swapchain_desc;
    data->primary_swapchain_window = hwnd;
    {
      std::stringstream s;
      s << "mods::swapchain::OnInitSwapchain(Primary swapchain desc: ";
      s << primary_swapchain_desc.texture.width << "x" << primary_swapchain_desc.texture.height;
      s << ", format: " << primary_swapchain_desc.texture.format;
      s << ", hwnd: " << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
      s << ", device: " << PRINT_PTR(reinterpret_cast<uintptr_t>(device));
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }

    if (use_device_proxy) {
      return;
    }

    // Handle directly here instead of OnInitResourceInfo
    const auto back_buffer_count = swapchain->get_back_buffer_count();
    for (uint32_t index = 0; index < back_buffer_count; ++index) {
      const auto buffer = swapchain->get_back_buffer(index);
      utils::resource::ResourceInfo* info = nullptr;
      utils::resource::store->resource_infos.if_contains(
          buffer.handle, [&info](std::pair<const uint64_t, utils::resource::ResourceInfo>& pair) {
            info = &pair.second;
          });
      if (info == nullptr || !info->is_swap_chain) continue;
      if (info->desc.texture.width != primary_swapchain_desc.texture.width
          || info->desc.texture.height != primary_swapchain_desc.texture.height) {
        continue;
      }
      if (upgraded_resource_format) {
        info->upgrade_target = &data->swap_chain_upgrade_info;
      }
      if (use_resource_cloning && !data->swap_chain_proxy_pixel_shader.empty()) {
        if (!UsingSwapchainCompatibilityMode()) {
          info->clone_enabled = true;
        }
        if (info->clone_target != nullptr) {
          reshade::log::message(reshade::log::level::info, "mods::swapchain::OnInitSwapchain(Overriding existing clone target.)");
        }
        info->clone_target = &data->swap_chain_clone_info;
      }
    }
  }

  CheckSwapchainSize(swapchain, primary_swapchain_desc);

  if (use_resize_buffer && primary_swapchain_desc.texture.format != target_format) {
    if (use_resize_buffer_on_demand || use_resize_buffer_on_present) {
      reshade::register_event<reshade::addon_event::present>(OnPresentForResizeBuffer);
    } else if (!use_resize_buffer_on_set_full_screen) {
      renodx::utils::swapchain::ResizeBuffer(swapchain, target_format, target_color_space);
    }
    return;
  }

  if (set_color_space) {
    renodx::utils::swapchain::ChangeColorSpace(swapchain, target_color_space);
  }
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();
  HWND hwnd = static_cast<HWND>(swapchain->get_hwnd());

  if (!resize && hwnd != nullptr && utils::swapchain::IsDXGI(swapchain)) {
    const auto& desc = upgraded_swapchain_desc.has_value() ? upgraded_swapchain_desc.value() : original_swapchain_desc.value();

    if (desc.present_mode == static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL)
        || desc.present_mode == static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD)) {
      if (auto pair = flip_swapchains_by_window.find(hwnd);
          pair != flip_swapchains_by_window.end()) {
        pair->second.erase(swapchain);
        if (pair->second.empty()) {
          flip_swapchains_by_window.erase(pair);
        }
      }
    }
  }

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;

  bool should_unhook_wndproc = false;

  {
    const std::unique_lock lock(data->mutex);
    data->upgraded_swapchains.erase(swapchain);

    if (!resize && data->prevent_full_screen && hwnd != nullptr) {
      bool has_other_swapchain_on_window = false;
      for (const auto& [tracked_swapchain, tracked_desc] : data->upgraded_swapchains) {
        (void)tracked_desc;
        if (tracked_swapchain == nullptr) continue;
        if (static_cast<HWND>(tracked_swapchain->get_hwnd()) == hwnd) {
          has_other_swapchain_on_window = true;
          break;
        }
      }
      should_unhook_wndproc = !has_other_swapchain_on_window;
    }

    DestroySwapchainProxyItems(device, data);
  }

  if (should_unhook_wndproc) {
    utils::windowing::UnhookSwapchainWindowProc(hwnd);
  }

  std::stringstream s;
  s << "mods::swapchain::OnDestroySwapchain(";
  s << PRINT_PTR(reinterpret_cast<uintptr_t>(swapchain));
  s << ", resize: " << (resize ? "true" : "false");
  if (!resize) {
    s << ", unhook_wndproc: " << (should_unhook_wndproc ? "true" : "false");
  }
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
}

static bool IsUpgraded(reshade::api::swapchain* swapchain) {
  auto* data = renodx::utils::data::Get<DeviceData>(swapchain->get_device());
  if (data == nullptr) return false;
  return data->upgraded_swapchains.contains(swapchain);
}

inline bool OnCreateResource(
    reshade::api::device* device,
    reshade::api::resource_desc& desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state) {
  return true;
}

inline void OnInitResourceInfo(renodx::utils::resource::ResourceInfo* resource_info) {
}

inline void OnDestroyResourceInfo(utils::resource::ResourceInfo* info) {
}

inline bool OnCopyBufferToTexture(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint64_t source_offset,
    uint32_t row_length,
    uint32_t slice_height,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box) {
  return false;
}

inline bool OnCreateResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc& desc) {
  return false;
}

inline void OnInitResourceViewInfo(utils::resource::ResourceViewInfo* resource_view_info) {
}

inline void OnDestroyResourceViewInfo(utils::resource::ResourceViewInfo* resource_view_info) {
}

inline bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  return false;
}

inline bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  return false;
}

inline bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  return false;
}

inline void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
}

inline void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
}

inline void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
}

static void OnBeginRenderPass(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::render_pass_render_target_desc* rts,
    const reshade::api::render_pass_depth_stencil_desc* ds) {
}

static void OnEndRenderPass(reshade::api::command_list* cmd_list) {
}

inline bool OnClearRenderTargetView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  return false;
}

inline bool OnClearUnorderedAccessViewUint(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const uint32_t values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  return false;
}

inline bool OnClearUnorderedAccessViewFloat(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const float values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  return false;
}

inline bool OnResolveTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    uint32_t dest_x,
    uint32_t dest_y,
    uint32_t dest_z,
    reshade::api::format format) {
  return false;
}

inline void OnBarrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states) {
}

inline bool OnCopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  return false;
}

static bool OnSetFullscreenState(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
  auto* device = swapchain->get_device();
  if (device == utils::device_proxy::proxy_device_reshade) return false;

  auto* private_data = renodx::utils::data::Get<DeviceData>(device);
  if (private_data == nullptr) return false;

  if (use_resize_buffer && use_resize_buffer_on_set_full_screen) {
    renodx::utils::swapchain::ResizeBuffer(swapchain, target_format, target_color_space);
  }

  if (!private_data->prevent_full_screen) {
    return false;
  }

  // Fullscreen requests are virtualized: mark pending and apply once the
  // window is in a foreground/visible present path.
  if (fullscreen) {
    private_data->fake_fullscreen_pending = true;
    {
      std::stringstream s;
      s << "mods::swapchain::OnSetFullscreenState(fake_fullscreen_pending=1, hwnd="
        << PRINT_PTR(reinterpret_cast<uintptr_t>(swapchain->get_hwnd()))
        << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
    return true;
  }

  private_data->fake_fullscreen_pending = false;
  {
    std::stringstream s;
    s << "mods::swapchain::OnSetFullscreenState(fake_fullscreen_pending=0, hwnd="
      << PRINT_PTR(reinterpret_cast<uintptr_t>(swapchain->get_hwnd()))
      << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
  return false;
}

inline void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  auto* device = swapchain->get_device();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;

  if (data->fake_fullscreen_pending) {
    auto* const hwnd = static_cast<HWND>(swapchain->get_hwnd());
    const bool can_apply = utils::windowing::CanApplyFakeFullscreen(hwnd);
    if (can_apply && utils::windowing::ApplyFakeFullscreen(swapchain, data->primary_swapchain_desc)) {
      data->fake_fullscreen_pending = false;
      std::stringstream s;
      s << "mods::swapchain::OnPresent(fake_fullscreen_pending=0, hwnd="
        << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd))
        << ", reason=applied_fake_fullscreen)";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }

  if (use_device_proxy) {
    return;
  }

  const auto back_buffer_handle = swapchain->get_current_back_buffer().handle;
  auto pass_pointer = data->swapchain_proxy_passes.find(back_buffer_handle);
  renodx::utils::draw::SwapchainProxyPass* proxy_pass = nullptr;
  if (pass_pointer == data->swapchain_proxy_passes.end()) {
    proxy_pass = new renodx::utils::draw::SwapchainProxyPass{
        .vertex_shader = data->swap_chain_proxy_vertex_shader,
        .pixel_shader = data->swap_chain_proxy_pixel_shader,
        .expected_constant_buffer_index = data->expected_constant_buffer_index,
        .expected_constant_buffer_space = data->expected_constant_buffer_space,
        .revert_state = data->swapchain_proxy_revert_state,
        .use_compatibility_mode = UsingSwapchainCompatibilityMode(),
        .proxy_format = swap_chain_proxy_format,
        .shader_injection = shader_injection,
        .shader_injection_size = shader_injection_size,
    };
    data->swapchain_proxy_passes[back_buffer_handle] = proxy_pass;
  } else {
    proxy_pass = pass_pointer->second;
  }
  assert(proxy_pass != nullptr);

  if (!proxy_pass->Render(swapchain, queue)) {
    proxy_pass->Destroy(device);
    data->swapchain_proxy_passes.erase(back_buffer_handle);
  }
}

template <typename T = float*>
static void Use(DWORD fdw_reason, T* new_injections = nullptr) {
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::swapchain::Use(fdw_reason);
  if (use_device_proxy) {
    renodx::utils::device_proxy::Use(fdw_reason);
  }
  if (swapchain_proxy_revert_state) {
    renodx::utils::state::Use(fdw_reason);
  }
  renodx::utils::resource::upgrade::Use(fdw_reason);
  if (use_resource_cloning) {
    // renodx::utils::descriptor::Use(fdw_reason);
  }

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "mods::swapchain attached.");
#if RESHADE_API_VERSION >= 17
      // create_device handled by utils::device_proxy
#endif
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

      // renodx::utils::resource::store->on_init_resource_info_callbacks.emplace_back(&OnInitResourceInfo);
      // renodx::utils::resource::store->on_destroy_resource_info_callbacks.emplace_back(&OnDestroyResourceInfo);

      if (use_resource_cloning) {
        if ((!swap_chain_proxy_pixel_shader.empty() || !swap_chain_proxy_shaders.empty())) {
          // Create swapchain proxy
          reshade::register_event<reshade::addon_event::present>(OnPresent);
          if (new_injections != nullptr) {
            shader_injection_size = sizeof(T) / sizeof(uint32_t);
            shader_injection = reinterpret_cast<float*>(new_injections);
          }
        }
      }

      reshade::register_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);

      break;
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
#if RESHADE_API_VERSION >= 17
      // create_device handled by utils::device_proxy
#endif

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::unregister_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

      // renodx::utils::resource::on_init_resource_info_callbacks.erase(&OnInitResourceInfo);
      // renodx::utils::resource::on_destroy_resource_info_callbacks.erase(&OnDestroyResourceInfo);
      // renodx::utils::resource::on_init_resource_view_info_callbacks.erase(&OnInitResourceViewInfo);
      // renodx::utils::resource::on_destroy_resource_view_info_callbacks.erase(&OnDestroyResourceViewInfo);

      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);

      break;
  }
}
}  // namespace renodx::mods::swapchain::v2
