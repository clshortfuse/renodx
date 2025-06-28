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

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <initializer_list>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "../utils/bitwise.hpp"
#include "../utils/data.hpp"
#include "../utils/descriptor.hpp"
#include "../utils/format.hpp"
#include "../utils/mutex.hpp"
#include "../utils/pipeline.hpp"
#include "../utils/resource.hpp"
#include "../utils/state.hpp"
#include "../utils/swapchain.hpp"

namespace renodx::mods::swapchain {

static decltype(&D3D11CreateDevice) pD3D11CreateDevice = nullptr;
static decltype(&CreateDXGIFactory1) pCreateDXGIFactory1 = nullptr;

using SwapChainUpgradeTarget = utils::resource::ResourceUpgradeInfo;

struct BoundDescriptorInfo {
  reshade::api::shader_stage stages;
  reshade::api::pipeline_layout layout;
  uint32_t first;
  uint32_t count;
  std::vector<reshade::api::descriptor_table> tables;
};

struct PushDescriptorInfo {
  reshade::api::shader_stage stages;
  reshade::api::pipeline_layout layout;
  uint32_t layout_param;
  reshade::api::descriptor_table_update update;
};

struct HeapDescriptorInfo {
  std::vector<reshade::api::descriptor_table_update> updates;
  uint64_t replacement_descriptor_handle;
  bool is_active;
};

struct __declspec(uuid("809df2f6-e1c7-4d93-9c6e-fa88dd960b7c")) DeviceData {
  std::shared_mutex mutex;

  std::vector<SwapChainUpgradeTarget> swap_chain_upgrade_targets;

  std::unordered_map<reshade::api::swapchain*, reshade::api::swapchain_desc> upgraded_swapchains;

  reshade::api::resource_desc primary_swapchain_desc;

  bool upgraded_resource_view = false;
  bool resource_upgrade_finished = false;
  bool prevent_full_screen = false;

  // <resource_original.handle, SwapChainUpgradeTarget>

  // <descriptor_heap.handle, std::map<base_offset, descriptor_table>>
  std::unordered_map<uint64_t, std::unordered_map<uint32_t, HeapDescriptorInfo*>> heap_descriptor_infos;

  reshade::api::pipeline_layout swap_chain_proxy_layout = {0};
  reshade::api::pipeline swap_chain_proxy_pipeline = {0};
  reshade::api::sampler swap_chain_proxy_sampler = {0};

  std::span<const std::uint8_t> swap_chain_proxy_vertex_shader;
  std::span<const std::uint8_t> swap_chain_proxy_pixel_shader;
  int32_t expected_constant_buffer_index = -1;
  uint32_t expected_constant_buffer_space = 0;
  bool swapchain_proxy_revert_state = false;

  SwapChainUpgradeTarget swap_chain_proxy_upgrade_target = {
      .new_format = reshade::api::format::r16g16b16a16_float,
      .usage_set =
          static_cast<uint32_t>(
              reshade::api::resource_usage::shader_resource
              | reshade::api::resource_usage::render_target),
      .use_resource_view_cloning_and_upgrade = true,
  };

  reshade::api::resource proxy_device_resource = {0};
};

struct __declspec(uuid("0a2b51ad-ef13-4010-81a4-37a4a0f857a6")) CommandListData {
  std::vector<BoundDescriptorInfo> unbound_descriptors;
  std::vector<PushDescriptorInfo> unpushed_updates;
};

// Variables

static bool attached = false;
static std::vector<SwapChainUpgradeTarget> swap_chain_upgrade_targets = {};
static reshade::api::format target_format = reshade::api::format::r16g16b16a16_float;
static reshade::api::color_space target_color_space = reshade::api::color_space::extended_srgb_linear;
static bool set_color_space = true;
static bool use_shared_device = false;
static bool use_resource_cloning = false;
static bool use_resize_buffer = false;
static bool use_resize_buffer_on_set_full_screen = false;
static bool use_resize_buffer_on_demand = false;
static bool use_resize_buffer_on_present = false;
static bool upgrade_unknown_resource_views = false;
static bool upgrade_resource_views = true;
static bool prevent_full_screen = true;
static bool force_borderless = true;
static bool force_screen_tearing = true;
static bool swapchain_proxy_compatibility_mode = true;
static bool swapchain_proxy_revert_state = false;
static bool use_device_proxy = false;
static thread_local void* last_device_proxy_shared_handle = nullptr;
static void* swap_chain_proxy_handle = nullptr;

static thread_local bool is_creating_proxy_device = false;

static IDXGISwapChain1* proxy_swap_chain = nullptr;
static ID3D11Device* proxy_device = nullptr;
static ID3D11DeviceContext* proxy_device_context = nullptr;
static reshade::api::device* proxy_device_reshade = nullptr;
static reshade::api::device* proxied_device_reshade = nullptr;
static reshade::api::swapchain* proxy_swapchain_reshade = nullptr;

static void* swap_chain_device_proxy = nullptr;
static bool bypass_dummy_windows = true;
static bool use_auto_upgrade = false;
static std::unordered_set<std::string> ignored_window_class_names = {};
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
static SwapChainUpgradeTarget auto_upgrade_target = {
    .new_format = reshade::api::format::r16g16b16a16_float,
    .use_resource_view_cloning_and_upgrade = true,
};

static thread_local SwapChainUpgradeTarget* local_applied_target = nullptr;
static thread_local std::optional<reshade::api::swapchain_desc> upgraded_swapchain_desc;
static thread_local std::optional<reshade::api::resource> local_original_resource;
static thread_local std::optional<reshade::api::resource_desc> local_original_resource_desc;
static thread_local std::optional<reshade::api::resource_view_desc> local_original_resource_view_desc;

// Methods

static bool UsingSwapchainProxy() {
  return !swap_chain_proxy_pixel_shader.empty() || !swap_chain_proxy_shaders.empty();
}

static bool UsingSwapchainCompatibilityMode() {
  return swapchain_proxy_compatibility_mode && (target_format == swap_chain_proxy_format);
}

static void RemoveWindowBorder(HWND window) {
  auto current_style = GetWindowLongPtr(window, GWL_STYLE);
  if (current_style != 0) {
    auto new_style = current_style & ~WS_BORDER & ~WS_THICKFRAME & ~WS_DLGFRAME;
    if (new_style != current_style) {
      SetWindowLongPtr(window, GWL_STYLE, new_style);
    }
  }
  auto current_exstyle = GetWindowLongPtr(window, GWL_EXSTYLE);
  if (current_exstyle != 0) {
    auto new_exstyle = current_exstyle & ~WS_EX_CLIENTEDGE & ~WS_EX_WINDOWEDGE;
    if (new_exstyle != current_exstyle) {
      SetWindowLongPtr(window, GWL_EXSTYLE, new_exstyle);
    }
  }
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
    RemoveWindowBorder(output_window);

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
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    if (screen_width != buffer_desc.texture.width) return;
    if (screen_height != buffer_desc.texture.height) return;
    // if (window_rect.top == 0 && window_rect.left == 0) return;

    RECT rect = {NULL};
    if (GetWindowRect(output_window, &rect) != 0) {
      if (rect.left != monitor_info.rcMonitor.left
          || rect.top != monitor_info.rcMonitor.top
          || rect.right - rect.left != screen_width
          || rect.bottom - rect.top != screen_height) {
        SetWindowPos(
            output_window,
            HWND_TOP,
            monitor_info.rcMonitor.left, monitor_info.rcMonitor.top,
            buffer_desc.texture.width, buffer_desc.texture.height,
            SWP_ASYNCWINDOWPOS | SWP_FRAMECHANGED | SWP_NOACTIVATE | SWP_NOZORDER);
      }
    }
  }
}

static reshade::api::descriptor_table_update CloneDescriptorUpdateWithResourceView(
    const reshade::api::descriptor_table_update& update,
    const reshade::api::resource_view& view,
    const uint32_t& index = 0) {
  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view: {
      auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index];
      return reshade::api::descriptor_table_update{
          .table = update.table,
          .binding = update.binding + index,
          .count = 1,
          .type = update.type,
          .descriptors = new reshade::api::sampler_with_resource_view{
              .sampler = item.sampler,
              .view = view,
          },
      };
      break;
    }
    case reshade::api::descriptor_type::texture_shader_resource_view:
    case reshade::api::descriptor_type::texture_unordered_access_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::acceleration_structure:        {
      return reshade::api::descriptor_table_update{
          .table = update.table,
          .binding = update.binding + index,
          .count = 1,
          .type = update.type,
          .descriptors = new reshade::api::resource_view{view.handle},
      };
      break;
    }
    default:
      break;
  }
  return {};
}

static bool FlushResourceViewInDescriptorTable(
    reshade::api::device* device,
    const reshade::api::resource& resource) {
  return true;
}

inline bool ActivateCloneHotSwap(
    reshade::api::device* device,
    const reshade::api::resource_view& resource_view) {
  auto* resource_view_info = utils::resource::GetResourceViewInfo(resource_view);

  if (resource_view_info == nullptr) {
    // Unknown
    return false;
  }

  if (resource_view_info->resource_info == nullptr) {
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(no handle for rsv ";
    s << PRINT_PTR(resource_view.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }

  auto& info = *resource_view_info->resource_info;
  if (info.clone_enabled) return false;

  if (info.clone_target == nullptr) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(";
    if (renodx::utils::swapchain::IsBackBuffer(info.resource)) {
      s << ("backbuffer ");
    }
    s << "not cloned ";
    s << PRINT_PTR(info.resource.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    // Resource is not a cloned resource (fail)
    return false;
  }

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(activating res: ";
    s << PRINT_PTR(info.resource.handle);
    s << " => clone: ";
    s << PRINT_PTR(info.clone.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }

#endif

  info.clone_enabled = true;

  return true;
}

inline bool DeactivateCloneHotSwap(
    reshade::api::device* device,
    const reshade::api::resource_view& resource_view) {
  auto* resource_view_info = utils::resource::GetResourceViewInfo(resource_view);

  if (resource_view_info == nullptr) {
    // Unknown
    return false;
  }

  if (resource_view_info->resource_info == nullptr) {
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(no handle for rsv ";
    s << PRINT_PTR(resource_view.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }

  auto& info = *resource_view_info->resource_info;
  if (!info.clone_enabled) return false;

  info.clone_enabled = false;

  return true;
}

inline reshade::api::resource CloneResource(utils::resource::ResourceInfo* resource_info) {
  if (resource_info == nullptr) return {0u};

  auto& desc = resource_info->desc;
  auto* target = resource_info->clone_target;

  resource_info->clone_desc = resource_info->desc;

  reshade::api::resource_desc& new_desc = resource_info->clone_desc;

  new_desc.texture.format = target->new_format;
  new_desc.usage = static_cast<reshade::api::resource_usage>(
      static_cast<uint32_t>(desc.usage)
      | (target->usage_set & ~target->usage_unset));
  if (new_desc.heap == reshade::api::memory_heap::custom) {
    new_desc.heap = reshade::api::memory_heap::gpu_only;
  }

  auto& initial_state = resource_info->initial_state;
  reshade::api::resource& resource_clone = resource_info->clone;

#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::swapchain::CloneResource(";
  s << PRINT_PTR(resource_info->resource.handle);
  s << ", format: " << desc.texture.format << " => " << new_desc.texture.format;
  s << ", type: " << desc.type;
  s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", heap: " << std::hex << static_cast<uint32_t>(desc.heap) << std::dec;
  s << ", usage: 0x" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
  s << ", new_usage: 0x" << std::hex << static_cast<uint32_t>(new_desc.usage) << std::dec;
  s << ", initial_state: " << initial_state;
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

  void** shared_handle = nullptr;

  if (target->use_shared_handle) {
    new_desc.flags = reshade::api::resource_flags::shared;
    new_desc.type = reshade::api::resource_type::texture_2d;
    shared_handle = &resource_info->shared_handle;
  } else {
    new_desc.flags = reshade::api::resource_flags::none;
  }

  auto* device = resource_info->device;
  if (device->create_resource(
          new_desc,
          nullptr,  // initial_data
          initial_state,
          &resource_clone,
          shared_handle)) {
    auto new_resource_info = utils::resource::CreateResourceInfo(resource_clone);
    new_resource_info.resource = resource_info->resource;
    new_resource_info.clone = resource_clone;
    new_resource_info.is_clone = true;
    resource_info->extra_vram = renodx::utils::resource::ComputeTextureSize(new_desc);

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "mods::swapchain::CloneResource(";
      s << PRINT_PTR(resource_info->resource.handle);
      s << " => " << PRINT_PTR(resource_clone.handle);
      s << ", +vram: " << resource_info->extra_vram;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
  } else {
    resource_clone.handle = 0;
    {
      std::stringstream s;
      s << "mods::swapchain::CloneResource(Failed to clone: ";
      s << PRINT_PTR(resource_info->resource.handle);
      s << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
    }
  }

  // private_data->resources_that_need_resource_view_clones.insert(resource.handle);

  return resource_info->clone;
}

inline reshade::api::resource CloneResource(const reshade::api::resource& resource) {
  return CloneResource(utils::resource::GetResourceInfo(resource));
}

static void SetupSwapchainProxyLayout(reshade::api::device* device, DeviceData* data) {
  if (data->swap_chain_proxy_layout.handle != 0u) return;
  reshade::api::pipeline_layout_param param_sampler;
  param_sampler.type = reshade::api::pipeline_layout_param_type::push_descriptors;
  param_sampler.push_descriptors.count = 1;
  param_sampler.push_descriptors.type = reshade::api::descriptor_type::sampler;

  reshade::api::pipeline_layout_param param_srv;
  param_srv.type = reshade::api::pipeline_layout_param_type::push_descriptors;
  param_srv.push_descriptors.count = 1;
  param_srv.push_descriptors.type = reshade::api::descriptor_type::texture_shader_resource_view;

  std::vector<reshade::api::pipeline_layout_param> new_layout_params = {param_sampler, param_srv};

  if (shader_injection_size != 0u) {
    reshade::api::pipeline_layout_param param_constants;
    param_constants.type = reshade::api::pipeline_layout_param_type::push_constants;
    param_constants.push_constants.count = 1;
    if (device->get_api() == reshade::api::device_api::d3d12 || device->get_api() == reshade::api::device_api::vulkan) {
      param_constants.push_constants.count = shader_injection_size;
    } else {
      param_constants.push_constants.count = 1;
    }
    if (data->expected_constant_buffer_index == -1) {
      if (device->get_api() == reshade::api::device_api::d3d12 || device->get_api() == reshade::api::device_api::vulkan) {
        param_constants.push_constants.dx_register_index = 0;
      } else {
        param_constants.push_constants.dx_register_index = 13;
      }
    } else {
      param_constants.push_constants.dx_register_index = data->expected_constant_buffer_index;
    }
    if (device->get_api() == reshade::api::device_api::d3d12 || device->get_api() == reshade::api::device_api::vulkan) {
      param_constants.push_constants.dx_register_space = data->expected_constant_buffer_space;
    } else {
      param_constants.push_constants.dx_register_space = 0;
    }
    new_layout_params.push_back(param_constants);
  }

#ifdef DEBUG_LEVEL_0
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::SetupSwapchainProxy(Creating pipeline layout)");
#endif

  device->create_pipeline_layout(new_layout_params.size(), new_layout_params.data(), &data->swap_chain_proxy_layout);
}

inline reshade::api::resource GetResourceClone(utils::resource::ResourceInfo* resource_info = nullptr) {
  if (resource_info == nullptr) return {0u};

  if (!resource_info->clone_enabled) {
    return {0};
  }

  if (resource_info->clone.handle != 0) {
    return resource_info->clone;
  }

  CloneResource(resource_info);

  return resource_info->clone;
}

inline reshade::api::resource GetResourceClone(const reshade::api::resource& resource) {
  return GetResourceClone(utils::resource::GetResourceInfo(resource));
}

inline reshade::api::resource_view GetResourceViewClone(
    utils::resource::ResourceViewInfo* resource_view_info = nullptr) {
  if (resource_view_info == nullptr) return {0u};

  auto& target = resource_view_info->clone_target;
  if (target == nullptr) return {0u};

  const auto& resource = resource_view_info->original_resource;

  if (resource.handle == 0 || resource_view_info->resource_info == nullptr) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::GetResourceViewClone(";
    s << PRINT_PTR(resource_view_info->view.handle);
    s << ", no resource";
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    assert(resource.handle != 0 && resource_view_info->resource_info != nullptr);
    return {0u};
  }

  auto& resource_info = resource_view_info->resource_info;

  if (!resource_info->clone_enabled) return {0u};

  if (resource_view_info->clone.handle != 0u) return resource_view_info->clone;

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::GetResourceViewClone(";
    s << PRINT_PTR(resource_view_info->view.handle);
    s << ", original resource: " << PRINT_PTR(resource.handle);
    s << ", creating view clone";
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }
#endif

  auto& resource_clone = resource_info->clone;

  {
    if (resource_clone.handle == 0u) {
      CloneResource(resource_info);
    }

    if (resource_clone == 0u) {
      std::stringstream s;
      s << "mods::swapchain::GetResourceViewClone(Failed to build resource clone: ";
      s << PRINT_PTR(resource_view_info->view.handle);
      s << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      // return NULL_RESOURCE_VIEW;
    } else {
      auto* target = resource_view_info->clone_target;

      resource_view_info->clone_desc = resource_view_info->desc;
      auto& new_desc = resource_view_info->clone_desc;
      auto& usage = resource_view_info->usage;

      if (auto pair2 = target->view_upgrades.find({usage, new_desc.format});
          pair2 != target->view_upgrades.end() && pair2->second != reshade::api::format::unknown) {
        new_desc.format = pair2->second;
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::GetResourceViewClone(";
        s << PRINT_PTR(resource_view_info->view.handle);

        s << ", view_upgrades format: " << new_desc.format;
        s << ", clone: " << PRINT_PTR(resource_clone.handle);
        s << ", type: " << new_desc.type;
        s << ", usage: " << static_cast<uint32_t>(usage) << "(" << usage << ")";
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      } else {
        new_desc.format = target->new_format;
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::GetResourceViewClone(";
        s << PRINT_PTR(resource_view_info->view.handle);
        s << ", fallback format: " << new_desc.format;
        s << ", clone: " << PRINT_PTR(resource_clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      }

      auto* device = resource_view_info->device;
      bool created = device->create_resource_view(
          resource_clone,
          usage,
          new_desc,
          &resource_view_info->clone);
#ifdef DEBUG_LEVEL_1
      {
        std::stringstream s;
        s << "mods::swapchain::GetResourceViewClone(";
        s << PRINT_PTR(resource_view_info->view.handle);
        s << " => " << PRINT_PTR(resource_view_info->clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      }
#endif
    }
  }

  return resource_view_info->clone;
}

inline reshade::api::resource_view GetResourceViewClone(const reshade::api::resource_view& view) {
  return GetResourceViewClone(utils::resource::GetResourceViewInfo(view));
}

inline void RewriteRenderTargets(
    reshade::api::command_list* cmd_list,
    const uint32_t& count,
    const reshade::api::resource_view* rtvs,
    const reshade::api::resource_view& dsv) {
  if (count == 0u) return;

  reshade::api::resource_view* new_rtvs = nullptr;
  bool changed = false;
  std::vector<std::pair<int, utils::resource::ResourceViewInfo*>> infos;

  std::shared_lock lock(utils::resource::store->resource_view_infos_mutex);
  for (uint32_t i = 0; i < count; ++i) {
    const reshade::api::resource_view resource_view = rtvs[i];
    if (resource_view.handle == 0u) continue;
    auto pair = utils::resource::store->resource_view_infos.find(resource_view.handle);
    if (pair != utils::resource::store->resource_view_infos.end()) {
      infos.emplace_back(i, &pair->second);
    }
  }
  lock.unlock();

  for (const auto& [i, info] : infos) {
    auto new_resource_view = GetResourceViewClone(info);
    if (new_resource_view.handle == 0u) continue;

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::RewriteRenderTargets(rewrite ";
    s << PRINT_PTR(info->view.handle);
    s << " => ";
    s << PRINT_PTR(new_resource_view.handle);
    s << ") [" << i << "]";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    if (!changed) {
      const size_t size = count * sizeof(reshade::api::resource_view);
      new_rtvs = static_cast<reshade::api::resource_view*>(malloc(size));
      memcpy(new_rtvs, rtvs, size);
      changed = true;
    }
    new_rtvs[i] = new_resource_view;
  }
  if (!changed) return;
  cmd_list->bind_render_targets_and_depth_stencil(count, new_rtvs, dsv);
  free(new_rtvs);
}

inline void DiscardDescriptors(reshade::api::command_list* cmd_list) {
  return;
  // Not implemented

  auto* cmd_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  cmd_data->unbound_descriptors.clear();
  cmd_data->unpushed_updates.clear();
}

inline void FlushDescriptors(reshade::api::command_list* cmd_list) {
  return;
  // Not implemented
  auto* cmd_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  for (auto info : cmd_data->unbound_descriptors) {
    cmd_list->bind_descriptor_tables(
        info.stages,
        info.layout,
        info.first,
        info.count,
        info.tables.data());
  }
  cmd_data->unbound_descriptors.clear();

  for (auto info : cmd_data->unpushed_updates) {
    cmd_list->push_descriptors(
        info.stages,
        info.layout,
        info.layout_param,
        info.update);
  }
  cmd_data->unpushed_updates.clear();
}

bool LoadDirectXLibraries() {
  if (!pD3D11CreateDevice) {
    HMODULE d3d11Module = GetModuleHandleW(L"d3d11.dll");
    if (!d3d11Module) {
      d3d11Module = LoadLibraryW(L"d3d11.dll");
    }
    if (d3d11Module) {
      pD3D11CreateDevice = reinterpret_cast<decltype(&D3D11CreateDevice)>(GetProcAddress(d3d11Module, "D3D11CreateDevice"));
    }
  }

  if (!pD3D11CreateDevice) {
    return false;
  }
  // Dynamically load CreateDXGIFactory1 from dxgi.dll

  if (!pCreateDXGIFactory1) {
    HMODULE dxgiModule = GetModuleHandleW(L"dxgi.dll");
    if (!dxgiModule) {
      dxgiModule = LoadLibraryW(L"dxgi.dll");
    }
    if (dxgiModule) {
      pCreateDXGIFactory1 = reinterpret_cast<decltype(&CreateDXGIFactory1)>(
          GetProcAddress(dxgiModule, "CreateDXGIFactory1"));
    }
  }

  if (!pCreateDXGIFactory1) {
    return false;
  }
  return true;
}

inline ID3D11Device* GetDeviceProxy(reshade::api::swapchain* swapchain, reshade::api::command_queue* queue) {
  auto* hwnd = swapchain->get_hwnd();
  if (proxy_device != nullptr) {
    return proxy_device;
  }

  if (!LoadDirectXLibraries()) return nullptr;

  // Create a new D3D11 device and HDR10 swapchain
  IDXGIFactory2* dxgi_factory = nullptr;

  if (FAILED(pCreateDXGIFactory1(IID_PPV_ARGS(&dxgi_factory)))) {
    return nullptr;
  }

  auto resource = swapchain->get_current_back_buffer();
  auto* resource_info = utils::resource::GetResourceInfo(resource);

  DXGI_SWAP_CHAIN_FULLSCREEN_DESC fullscreen_desc = {};
  DXGI_SWAP_CHAIN_DESC1 sc_desc = {};
  sc_desc.BufferCount = 2;
  sc_desc.Width = resource_info->desc.texture.width;
  sc_desc.Height = resource_info->desc.texture.height;
  sc_desc.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
  fullscreen_desc.RefreshRate.Numerator = 0;
  fullscreen_desc.RefreshRate.Denominator = 0;
  sc_desc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
  auto* output_window = hwnd != nullptr ? static_cast<HWND>(hwnd) : GetDesktopWindow();
  sc_desc.SampleDesc.Count = 1;
  fullscreen_desc.Windowed = TRUE;
  sc_desc.SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD;
  sc_desc.Flags = DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;

  sc_desc.Stereo = FALSE;
  sc_desc.SampleDesc.Quality = 0;
  sc_desc.AlphaMode = DXGI_ALPHA_MODE_UNSPECIFIED;
  sc_desc.Scaling = DXGI_SCALING_NONE;
  fullscreen_desc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;

  UINT create_flags = D3D11_CREATE_DEVICE_SINGLETHREADED;
  D3D_FEATURE_LEVEL feature_level;

  assert(is_creating_proxy_device == false);
  assert(proxy_device_reshade == nullptr);
  is_creating_proxy_device = true;
  if (FAILED(pD3D11CreateDevice(
          nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr, create_flags,
          nullptr, 0, D3D11_SDK_VERSION, &proxy_device, &feature_level, &proxy_device_context))) {
    is_creating_proxy_device = false;
    if (dxgi_factory != nullptr) {
      dxgi_factory->Release();
    }
    proxy_device = nullptr;
    proxy_device_context = nullptr;
    return nullptr;
  }
  is_creating_proxy_device = false;
  assert(proxy_device_reshade != nullptr);

  // Create swapchain for HWND
  if (FAILED(dxgi_factory->CreateSwapChainForHwnd(
          proxy_device,
          output_window,
          &sc_desc,
          &fullscreen_desc,
          nullptr,
          &proxy_swap_chain))) {
    if (dxgi_factory != nullptr) {
      dxgi_factory->Release();
    }
    if (proxy_device != nullptr) {
      proxy_device->Release();
      proxy_device = nullptr;
    }
    if (proxy_device_context != nullptr) {
      proxy_device_context->Release();
      proxy_device_context = nullptr;
    }
    proxy_swap_chain = nullptr;
    return nullptr;
  }

  // Cleanup local references (do not release d3d11Device, it's returned)
  if (dxgi_factory != nullptr) {
    dxgi_factory->Release();
    dxgi_factory = nullptr;
  }

  IDXGISwapChain3* swapChain3 = nullptr;
  if (SUCCEEDED(proxy_swap_chain->QueryInterface(IID_PPV_ARGS(&swapChain3)))) {
    swapChain3->SetColorSpace1(DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709);
    swapChain3->Release();
  }

  return proxy_device;
}

inline void DrawSwapChainProxy(reshade::api::swapchain* swapchain, reshade::api::command_queue* queue) {
  auto* cmd_list = queue->get_immediate_command_list();
  auto current_back_buffer = swapchain->get_current_back_buffer();
  auto* device = swapchain->get_device();

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;

  std::optional<utils::state::CommandListState> previous_state;
  if (swapchain_proxy_revert_state) {
    auto* current_state = utils::state::GetCurrentState(cmd_list);
    if (current_state != nullptr) {
      previous_state.emplace(*current_state);
    }
  }

  // std::shared_lock data_lock(data.mutex);

  auto* resource_info = utils::resource::GetResourceInfoUnsafe(current_back_buffer);
  if (resource_info == nullptr) return;

  reshade::api::resource swapchain_clone;

  if (use_device_proxy) {
    assert(last_device_proxy_shared_handle != nullptr);
    ID3D11Texture2D* shared_texture = nullptr;
    if (FAILED(proxy_device->OpenSharedResource(last_device_proxy_shared_handle, IID_PPV_ARGS(&shared_texture)))) {
      reshade::log::message(reshade::log::level::error,
                            "mods::swapchain::OnPresent(OpenSharedResource failed.)");
      return;
    }

    if (data->proxy_device_resource.handle == 0u) {
      // Create proxy device resource

      reshade::api::resource_desc new_desc;
      new_desc.type = reshade::api::resource_type::texture_2d;
      new_desc.texture = {
          .width = resource_info->desc.texture.width,
          .height = resource_info->desc.texture.height,
          .format = reshade::api::format::r16g16b16a16_float};
      new_desc.heap = reshade::api::memory_heap::gpu_only;
      new_desc.usage = reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource;
      device->create_resource(new_desc, nullptr, reshade::api::resource_usage::general, &data->proxy_device_resource);
    }
    cmd_list->copy_resource({reinterpret_cast<uintptr_t>(shared_texture)}, data->proxy_device_resource);
    queue->flush_immediate_command_list();
    shared_texture->Release();
    shared_texture = nullptr;
    swapchain_clone = data->proxy_device_resource;

  } else if (UsingSwapchainCompatibilityMode()) {
    auto& resource_clone = resource_info->clone;
    if (resource_clone.handle == 0u) {
      CloneResource(resource_info);
    }
    if (resource_clone.handle == 0u) return;
    swapchain_clone = resource_clone;

    // Copy current swapchain to clone
    cmd_list->copy_resource(current_back_buffer, resource_info->clone);
  } else {
    // Ignore if not activated yet
    if (resource_info->clone.handle == 0u) return;
    swapchain_clone = resource_info->clone;
  }

  std::stringstream s;
  s << "mods::swapchain::DrawSwapChainProxy(";
  s << PRINT_PTR(swapchain_clone.handle);
  s << " => " << PRINT_PTR(current_back_buffer.handle);

  if (data->swap_chain_proxy_layout.handle == 0u) {
    reshade::log::message(reshade::log::level::info, "mods::swapchain::OnPresent(Creating pipeline layout...)");
    SetupSwapchainProxyLayout(device, data);
    if (data->swap_chain_proxy_layout.handle == 0u) {
      reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnPresent(Pipeline layout creation failed.)");
      cmd_list->copy_resource(swapchain_clone, current_back_buffer);
      return;
    }
#ifdef DEBUG_LEVEL_0
    {
      std::stringstream s;
      s << "mods::swapchain::DrawSwapChainProxy(Pipeline layout:";
      s << PRINT_PTR(data->swap_chain_proxy_layout.handle);
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
#endif
  }
  s << ", layout: " << PRINT_PTR(data->swap_chain_proxy_layout.handle);

  // Bind sampler and SRV

  auto& sampler = data->swap_chain_proxy_sampler;
  if (sampler.handle == 0u) {
    reshade::log::message(reshade::log::level::info, "mods::swapchain::OnPresent(Creating sampler...)");
    if (data->swap_chain_proxy_sampler.handle == 0u) {
      device->create_sampler({}, &data->swap_chain_proxy_sampler);
    }

    if (sampler.handle == 0u) {
      reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnPresent(Sampler creation failed.)");
      cmd_list->copy_resource(swapchain_clone, current_back_buffer);
      return;
    }
  }
  s << ", sampler: " << PRINT_PTR(sampler.handle);

  auto& srv = resource_info->swap_chain_proxy_clone_srv;
  if (srv.handle == 0u) {
    reshade::log::message(reshade::log::level::info, "mods::swapchain::OnPresent(Creating SRV...)");
    device->create_resource_view(
        swapchain_clone,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_view_desc(swap_chain_proxy_format),
        &srv);

    if (srv.handle == 0u) {
      reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnPresent(SRV creation failed.)");
      cmd_list->copy_resource(swapchain_clone, current_back_buffer);
      return;
    }
  }
  s << ", srv: " << PRINT_PTR(srv.handle);

  // Create RTV on the fly (reusing existing may cause conflicts)

  auto& rtv = resource_info->swap_chain_proxy_rtv;
  if (rtv.handle == 0u) {
    reshade::log::message(reshade::log::level::info, "mods::swapchain::OnPresent(Creating RTV...)");

    auto& buffer_desc = resource_info->desc;
    // target format instead?
    device->create_resource_view(
        current_back_buffer,
        reshade::api::resource_usage::render_target,
        reshade::api::resource_view_desc(buffer_desc.texture.format),
        &rtv);

    if (rtv.handle == 0u) {
      reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnPresent(RTV creation failed.)");
      cmd_list->copy_resource(swapchain_clone, current_back_buffer);
      return;
    }
  }

  s << ", rtv: " << PRINT_PTR(rtv.handle);

  reshade::api::render_pass_render_target_desc render_target_desc = {.view = rtv};
  cmd_list->begin_render_pass(1, &render_target_desc, nullptr);

  if (data->swap_chain_proxy_pipeline.handle == 0) {
    reshade::log::message(reshade::log::level::info, "mods::swapchain::OnPresent(Creating pipeline...)");
    data->swap_chain_proxy_pipeline = renodx::utils::pipeline::CreateRenderPipeline(
        device,
        data->swap_chain_proxy_layout,
        {
            {reshade::api::pipeline_subobject_type::vertex_shader, data->swap_chain_proxy_vertex_shader},
            {reshade::api::pipeline_subobject_type::pixel_shader, data->swap_chain_proxy_pixel_shader},
        },
        resource_info->desc.texture.format);
    if (data->swap_chain_proxy_pipeline == 0u) {
      reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnPresent(Pipeline creation failed.)");
      cmd_list->copy_resource(swapchain_clone, current_back_buffer);
      return;
    }
  }

  // cmd_list->barrier(
  //     swapchain_clone,
  //     reshade::api::resource_usage::general,
  //     reshade::api::resource_usage::shader_resource);

  cmd_list->push_descriptors(
      reshade::api::shader_stage::all_graphics,
      data->swap_chain_proxy_layout,
      0,
      {
          .table = {},
          .binding = 0,
          .array_offset = 0,
          .count = 1,
          .type = reshade::api::descriptor_type::sampler,
          .descriptors = &sampler,
      });
  cmd_list->push_descriptors(
      reshade::api::shader_stage::all_graphics,
      data->swap_chain_proxy_layout,
      1,
      {
          .table = {},
          .binding = 0,
          .array_offset = 0,
          .count = 1,
          .type = reshade::api::descriptor_type::texture_shader_resource_view,
          .descriptors = &srv,
      });
  if (shader_injection_size != 0u) {
    const std::shared_lock lock(renodx::utils::mutex::global_mutex);
    cmd_list->push_constants(
        reshade::api::shader_stage::all_graphics,  // Used by reshade to specify graphics or compute
        data->swap_chain_proxy_layout,
        2,
        0,
        shader_injection_size,
        shader_injection);
  }

  s << ", pipeline: " << PRINT_PTR(data->swap_chain_proxy_pipeline.handle);
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_graphics, data->swap_chain_proxy_pipeline);
  size_t param_index = -1;

  const reshade::api::viewport viewport = {
      .x = 0.0f,
      .y = 0.0f,
      .width = static_cast<float>(resource_info->desc.texture.width),
      .height = static_cast<float>(resource_info->desc.texture.height),
      .min_depth = 0.0f,
      .max_depth = 1.0f,
  };

  cmd_list->bind_viewports(0, 1, &viewport);
  const reshade::api::rect scissor_rect = {
      .left = 0,
      .top = 0,
      .right = static_cast<int32_t>(resource_info->desc.texture.width),
      .bottom = static_cast<int32_t>(resource_info->desc.texture.height),
  };
  cmd_list->bind_scissor_rects(0, 1, &scissor_rect);
  cmd_list->draw(3, 1, 0, 0);
  cmd_list->end_render_pass();

  if (!use_device_proxy && device->get_api() != reshade::api::device_api::d3d12) {
    // Reshade calls this on DX12
    queue->flush_immediate_command_list();
  }

  if (previous_state.has_value()) {
    previous_state->Apply(cmd_list);
  }

#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
}

static void SetUseHDR10(const bool& value = true) {
  if (value) {
    target_format = reshade::api::format::r10g10b10a2_unorm;
    target_color_space = reshade::api::color_space::hdr10_st2084;
  } else {
    target_format = reshade::api::format::r16g16b16a16_float;
    target_color_space = reshade::api::color_space::extended_srgb_linear;
  }
}

static void SetUpgradeResourceViews(const bool& value = true) {
  upgrade_resource_views = value;
}

// Hooks

static bool OnCreateDevice(reshade::api::device_api api, uint32_t& api_version) {
  if (!use_device_proxy) return false;
  if (api != reshade::api::device_api::d3d9) return false;
  if (api_version == 0x9100) return false;

  api_version = 0x9100;  // 0x9000 -> 0x9100, upgrade Direct3D 9 to Direct3D 9Ex
  return true;
}

static void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::swapchain::OnInitDevice(";
  s << PRINT_PTR((uintptr_t)(device));
  s << ", native: " << PRINT_PTR((uintptr_t)(device->get_native()));
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  auto* data = renodx::utils::data::Create<DeviceData>(device);

  data->swap_chain_upgrade_targets = swap_chain_upgrade_targets;
  data->prevent_full_screen = use_device_proxy || prevent_full_screen;
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

  if (is_creating_proxy_device) {
    proxy_device_reshade = device;
  }
}

static void DestroySwapchainProxyItems(reshade::api::device* device, DeviceData* data) {
  if (data->swap_chain_proxy_sampler.handle != 0u) {
    device->destroy_sampler(data->swap_chain_proxy_sampler);
    data->swap_chain_proxy_sampler.handle = 0u;
  }

  if (data->swap_chain_proxy_layout.handle != 0u) {
    device->destroy_pipeline_layout(data->swap_chain_proxy_layout);
    data->swap_chain_proxy_layout.handle = 0u;
  }

  if (data->swap_chain_proxy_pipeline.handle != 0u) {
    device->destroy_pipeline(data->swap_chain_proxy_pipeline);
    data->swap_chain_proxy_pipeline.handle = 0u;
  }

  if (data->proxy_device_resource.handle != 0u) {
    device->destroy_resource(data->proxy_device_resource);
    data->proxy_device_resource.handle = 0u;
  }
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
    if (proxy_device != nullptr) {
      proxy_device->Release();
      proxy_device = nullptr;
    }
    proxied_device_reshade = nullptr;
  } else if (device == proxy_device_reshade) {
    proxy_device_reshade = nullptr;
  }
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

static bool ShouldModifySwapchainHwnd(HWND hwnd) {
  if (renodx::utils::platform::IsToolWindow(hwnd)) {
    std::stringstream s;
    s << "mods::swapchain::ShouldModifySwapchainHwnd(Tool Window: ";
    s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return false;
  }

  auto class_name = renodx::utils::platform::GetWindowClassName(hwnd);
  {
    std::stringstream s;
    s << "mods::swapchain::ShouldModifySwapchainHwnd(Checking class name: ";
    s << class_name;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  if (bypass_dummy_windows) {
    auto lower_case_view = class_name | std::views::transform([](auto c) { return std::tolower(c); });
    if (!std::ranges::search(lower_case_view, std::string("dummy")).empty()) {
      std::stringstream s;
      s << "mods::swapchain::ShouldModifySwapchainHwnd(Dummy window: ";
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
        s << "mods::swapchain::ShouldModifySwapchainHwnd(Ignored class name: ";
        s << class_name;
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
  upgraded_swapchain_desc.reset();

  if (!renodx::utils::bitwise::HasFlag(desc.back_buffer.usage, reshade::api::resource_usage::render_target)) {
    return false;
  }

  bool is_dxgi = false;
  switch (device_api) {
    default:
    case reshade::api::device_api::d3d10:
    case reshade::api::device_api::d3d11:
    case reshade::api::device_api::d3d12:
      is_dxgi = true;
    case reshade::api::device_api::vulkan:
      break;
  }

  if (!ShouldModifySwapchainHwnd(static_cast<HWND>(hwnd))) {
    std::stringstream s;
    s << "mods::swapchain::OnCreateSwapchain(Abort from ShouldModifySwapchainHwnd: ";
    s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return false;
  }

  auto old_fullscreen_state = desc.fullscreen_state;
  auto old_format = desc.back_buffer.texture.format;
  auto old_present_mode = desc.present_mode;
  auto old_present_flags = desc.present_flags;
  auto old_buffer_count = desc.back_buffer_count;

  if (!use_resize_buffer && is_dxgi && !use_device_proxy) {
    desc.back_buffer.texture.format = target_format;

    if (desc.back_buffer_count == 1) {
      // 0 is only for resize, so if game uses more than 2 buffers, that will be retained
      desc.back_buffer_count = 2;
    }
  }

  if (is_dxgi) {
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
        desc.present_flags |= DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;
      }
    }
  } else if (device_api == reshade::api::device_api::d3d9) {
    if (prevent_full_screen || use_device_proxy) {
      desc.present_flags &= ~D3DPRESENTFLAG_LOCKABLE_BACKBUFFER;
    }
  }

  if (prevent_full_screen || use_device_proxy) {
    if (desc.fullscreen_state) {
      desc.fullscreen_state = false;
    }
  }

  bool changed = (old_format != desc.back_buffer.texture.format)
                 || (old_present_mode != desc.present_mode)
                 || (old_present_flags != desc.present_flags)
                 || (old_fullscreen_state != desc.fullscreen_state);

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
  s << ", present mode:";
  s << "0x" << std::hex << old_present_mode << std::dec;
  s << " => ";
  s << "0x" << std::hex << desc.present_mode << std::dec;
  s << ", present flag:";
  s << "0x" << std::hex << old_present_flags << std::dec;
  s << " => ";
  s << "0x" << std::hex << desc.present_flags << std::dec;
  s << ", buffers:";
  s << old_buffer_count;
  s << " => ";
  s << desc.back_buffer_count;
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
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnInitSwapchain()");

  auto* device = swapchain->get_device();

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;

  auto abort_modification = [=]() {
    DestroySwapchainProxyItems(device, data);
    renodx::utils::data::Delete(device, data);
  };

  HWND hwnd = static_cast<HWND>(swapchain->get_hwnd());

  if (!ShouldModifySwapchainHwnd(hwnd)) {
    std::stringstream s;
    s << "mods::swapchain::OnInitSwapchain(Abort from ShouldModifySwapchainHwnd: ";
    s << PRINT_PTR(reinterpret_cast<uintptr_t>(hwnd));
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    abort_modification();
    return;
  }

  auto primary_swapchain_desc = device->get_resource_desc(swapchain->get_current_back_buffer());

  {
    const std::unique_lock lock(data->mutex);
    if (upgraded_swapchain_desc.has_value()) {
      data->upgraded_swapchains[swapchain] = upgraded_swapchain_desc.value();
      upgraded_swapchain_desc.reset();
    }
    reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnInitSwapchain(reset resource upgrade)");
    data->resource_upgrade_finished = false;
    const uint32_t len = swap_chain_upgrade_targets.size();
    // Reset
    for (uint32_t i = 0; i < len; i++) {
      renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
      if (target->ignore_reset) continue;
      target->counted = 0;
      target->completed = false;
    }
    data->primary_swapchain_desc = primary_swapchain_desc;

    if (use_device_proxy) {
      if (resize && proxy_device_reshade != nullptr && device != proxy_device_reshade && proxy_swap_chain != nullptr) {
        proxy_swap_chain->ResizeBuffers(
            2,
            primary_swapchain_desc.texture.width,
            primary_swapchain_desc.texture.height,
            DXGI_FORMAT_R16G16B16A16_FLOAT,
            DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING);
      }
      return;
    }

    if (UsingSwapchainProxy()) {
      data->swap_chain_proxy_upgrade_target.new_format = swap_chain_proxy_format;
      if (swap_chain_proxy_format == reshade::api::format::r10g10b10a2_unorm) {
        data->swap_chain_proxy_upgrade_target.view_upgrades = utils::resource::VIEW_UPGRADES_R10G10B10A2_UNORM;
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
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  DestroySwapchainProxyItems(device, data);
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnDestroySwapchain()");
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
  local_applied_target = nullptr;
  local_original_resource.reset();
  local_original_resource_desc.reset();

  if (device == nullptr) {
    std::stringstream s;
    s << "mods::swapchain::OnCreateResource(Empty device)";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }
  switch (desc.type) {
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      break;
    case reshade::api::resource_type::unknown:
      reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnCreateResource(Unknown resource type)");
    default:
      return false;
  }

  auto* private_data = renodx::utils::data::Get<DeviceData>(device);
  if (private_data == nullptr) return false;
  if (private_data->resource_upgrade_finished) return false;
  // const std::unique_lock lock(private_data.mutex);

  auto& device_back_buffer_desc = private_data->primary_swapchain_desc;
  if (device_back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnCreateResource(No swapchain desc: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    return false;
  }

  const uint32_t len = private_data->swap_chain_upgrade_targets.size();

  // const float resource_tag = -1;
  auto& swap_chain_upgrade_targets = private_data->swap_chain_upgrade_targets;

  SwapChainUpgradeTarget* found_target = nullptr;
  bool all_completed = true;
  bool found_exact = false;
  for (uint32_t i = 0; i < len; i++) {
    renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
    if (target->completed) continue;
    if (
        !target->use_resource_view_cloning
        && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "mods::swapchain::OnCreateResource(counting target";
      s << ", format: " << target->old_format;
      s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
      s << ", index: " << target->index;
      s << ", counted: " << target->counted;
      // s << ", data: " << PRINT_PTR(initial_data);
      s << ") [" << i << "/" << len << "]";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

      target->counted++;
      if (target->index != -1 && (target->index + 1) == target->counted) {
        found_target = target;
        target->completed = true;
        found_exact = true;
        continue;
      }
      if (target->index == -1) {
        if (!found_exact) {
          found_target = target;
        }
        all_completed = false;
        continue;
      }
    }
    all_completed = false;
  }

  if (found_target == nullptr) return false;

  if (all_completed) {
    private_data->resource_upgrade_finished = true;
  }

  reshade::api::resource original_resource = {0};

  if (initial_data != nullptr) {
    // Create a temporary texture to store the texture data instead
    device->create_resource(
        desc,
        initial_data,
        initial_state,
        &original_resource);
    initial_data = nullptr;
  }

  if (desc.texture.format == reshade::api::format::unknown
#ifdef DEBUG_LEVEL_0
      || true
#endif
  ) {
    std::stringstream s;
    s << "mods::swapchain::OnCreateResource(Upgrading";
    s << ", flags: 0x" << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
    s << ", state: 0x" << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
    s << ", format: " << desc.texture.format << " => " << found_target->new_format;
    s << ", width: " << desc.texture.width;
    s << ", height: " << desc.texture.height;
    s << ", usage: " << desc.usage << "(" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec << ")";
    s << ", complete: " << all_completed;
    if (original_resource.handle != 0u) {
      s << ", fallback: " << PRINT_PTR(original_resource.handle);
    }
    s << ")";

    reshade::log::message(
        desc.texture.format == reshade::api::format::unknown
            ? reshade::log::level::warning
            : reshade::log::level::info,
        s.str().c_str());
  }

  const auto original_desc = desc;
  desc.texture.format = found_target->new_format;

  if (found_target->new_dimensions.width == SwapChainUpgradeTarget::BACK_BUFFER) {
    desc.texture.width = device_back_buffer_desc.texture.width;
  } else if (found_target->new_dimensions.width >= 0) {
    desc.texture.width = found_target->new_dimensions.width;
  }

  if (found_target->new_dimensions.height == SwapChainUpgradeTarget::BACK_BUFFER) {
    desc.texture.height = device_back_buffer_desc.texture.height;
  } else if (found_target->new_dimensions.height >= 0) {
    desc.texture.height = found_target->new_dimensions.height;
  }

  if (found_target->new_dimensions.depth >= 0) {
    desc.texture.depth_or_layers = found_target->new_dimensions.depth;
  }

  desc.usage = static_cast<reshade::api::resource_usage>(
      static_cast<uint32_t>(desc.usage)
      | (found_target->usage_set & ~found_target->usage_unset));

  local_original_resource = original_resource;
  local_original_resource_desc = original_desc;
  local_applied_target = found_target;
  return true;
}

inline void OnInitResourceInfo(renodx::utils::resource::ResourceInfo* resource_info) {
  auto* device = resource_info->device;

  if (device == proxy_device_reshade) return;

  auto& desc = resource_info->desc;

  switch (desc.type) {
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      break;
    case reshade::api::resource_type::unknown:
      reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnInitResource(Unknown resource type)");
    default:
      // if (private_data.applied_target != nullptr) {
      //   reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnInitResource(Modified?)");
      //   private_data.applied_target = nullptr;
      // }
      return;
  }

  // const std::unique_lock lock(private_data.mutex);

  auto& resource = resource_info->resource;
  auto& initial_state = resource_info->initial_state;
  bool changed = false;

  if (local_applied_target != nullptr) {
    changed = true;
    if (local_applied_target->resource_tag != -1) {
      resource_info->resource_tag = local_applied_target->resource_tag;
    }
    resource_info->upgraded = true;
    resource_info->upgrade_target = local_applied_target;
    resource_info->fallback = local_original_resource.value();
    resource_info->fallback_desc = local_original_resource_desc.value();

    resource_info->extra_vram = renodx::utils::resource::ComputeTextureSize(desc)
                                - renodx::utils::resource::ComputeTextureSize(resource_info->fallback_desc);

    local_applied_target = nullptr;

  } else if (use_resource_cloning) {
    auto* private_data = renodx::utils::data::Get<DeviceData>(device);
    if (private_data == nullptr) return;

    if (resource_info->is_swap_chain) {
      if (UsingSwapchainProxy()) {
        if (use_device_proxy || !UsingSwapchainCompatibilityMode()) {
          {
            std::stringstream s;
            s << "mods::swapchain::OnInitResourceInfo(Marking swapchain buffer for cloning: ";
            s << PRINT_PTR(resource_info->resource.handle);
            s << ")";
            reshade::log::message(reshade::log::level::info, s.str().c_str());
          }
          resource_info->clone_enabled = true;
        }
        if (use_device_proxy) {
          resource_info->clone_enabled = true;
          private_data->swap_chain_proxy_upgrade_target.use_shared_handle = true;
          private_data->swap_chain_proxy_upgrade_target.usage_set = static_cast<uint32_t>(reshade::api::resource_usage::render_target);
        }
        resource_info->clone_target = &private_data->swap_chain_proxy_upgrade_target;
      }
      return;
    }

    if (private_data->resource_upgrade_finished) return;
    auto& device_back_buffer_desc = private_data->primary_swapchain_desc;
    if (device_back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::OnInitResource(No swapchain yet: ";
      s << reinterpret_cast<uintptr_t>(device);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
      return;
    }

    const uint32_t len = swap_chain_upgrade_targets.size();

    renodx::mods::swapchain::SwapChainUpgradeTarget* found_target = nullptr;
    bool all_completed = true;
    bool found_exact = false;
    for (uint32_t i = 0; i < len; i++) {
      renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
      if (target->completed) continue;
      if (
          target->use_resource_view_cloning
          && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
#ifdef DEBUG_LEVEL_0
        std::stringstream s;
        s << "mods::swapchain::OnInitResource(counting target";
        s << ", format: " << target->old_format;
        s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
        s << ", index: " << target->index;
        s << ", counted: " << target->counted;
        s << ") [" << i << "/" << len << "]";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        target->counted++;
        if (target->index != -1 && (target->index + 1) == target->counted) {
          found_target = target;
          target->completed = true;
          found_exact = true;
          continue;
        }
        if (target->index == -1) {
          if (!found_exact) {
            found_target = target;
          }
          all_completed = false;
          continue;
        }
      }
      all_completed = false;
    }
    if (found_target == nullptr) return;
    if (all_completed) {
#ifdef DEBUG_LEVEL_0
      reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnInitResource(All resource cloning completed)");
#endif
      private_data->resource_upgrade_finished = true;
    }

    // On the fly generation
    resource_info->clone_target = found_target;
    // resource_info.initial_state = initial_state;
    resource_info->resource_tag = found_target->resource_tag;
    if (found_target->resource_tag != -1) {
      resource_info->resource_tag = found_target->resource_tag;
    }
    if (!found_target->use_resource_view_hot_swap) {
      resource_info->clone_enabled = true;
#ifdef DEBUG_LEVEL_0
      {
        std::stringstream s;
        s << "mods::swapchain::OnInitResource(Marking resource for cloning: ";
        s << PRINT_PTR(resource.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      }
#endif
    }
    changed = true;
  } else {
    // Nothing to do
    return;
  }

#ifdef DEBUG_LEVEL_1
  if (changed
#ifdef DEBUG_LEVEL_2
      || true
#endif
  ) {
    std::stringstream s;
    s << "mods::swapchain::OnInitResource(tracking ";
    s << PRINT_PTR(resource.handle);
    s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
    s << ", state: " << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
    s << ", width: " << desc.texture.width;
    s << ", height: " << desc.texture.height;
    //  s << ", initial_data: " << (initial_data == nullptr ? "false" : "true");
    s << ", format: " << desc.texture.format;
    if (resource_info->resource_tag != -1) {
      s << ", tag: " << resource_info->resource_tag;
    }
    if (resource_info->fallback.handle != 0u) {
      s << ", fallback: " << PRINT_PTR(resource_info->fallback.handle);
    }
    if (resource_info->extra_vram != 0u) {
      s << ", +vram: " << resource_info->extra_vram;
    }
    s << ")";

    reshade::log::message(
        desc.texture.format == reshade::api::format::unknown
            ? reshade::log::level::warning
            : reshade::log::level::info,
        s.str().c_str());
  }
#endif
}

inline void OnDestroyResourceInfo(utils::resource::ResourceInfo* info) {
  auto* device = info->device;

  if (info->is_swap_chain) {
    if (info->swap_chain_proxy_clone_srv.handle != 0u) {
      device->destroy_resource_view(info->swap_chain_proxy_clone_srv);
      info->swap_chain_proxy_clone_srv.handle = 0u;
    }

    if (info->swap_chain_proxy_rtv.handle != 0u) {
      device->destroy_resource_view(info->swap_chain_proxy_rtv);
      info->swap_chain_proxy_rtv.handle = 0u;
    }
  }

  if (info->fallback.handle != 0u) {
    info->device->destroy_resource(info->fallback);
    info->fallback.handle = 0u;
  }
  if (info->clone.handle != 0u) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnDestroyResource(destroy cloned resource and views";
    s << ", resource: " << PRINT_PTR(info->resource.handle);
    s << ", clone: " << PRINT_PTR(info->clone.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    device->destroy_resource(info->clone);
    info->clone.handle = 0u;
  }
  if (info->extra_vram != 0u) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnDestroyResource(";
    s << "Resource: " << PRINT_PTR(info->resource.handle);
    s << ", clone: " << PRINT_PTR(info->clone.handle);
    s << ", -vram: " << info->extra_vram;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    info->extra_vram = 0;
  }
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
  auto original_source_desc = cmd_list->get_device()->get_resource_desc(source);
  auto original_dest_desc = cmd_list->get_device()->get_resource_desc(dest);

  if (original_source_desc.type != reshade::api::resource_type::buffer) {
    std::stringstream s;
    s << "mods::swapchain::OnCopyBufferToTexture(Unexpected source type: ";
    s << original_source_desc.type;
    s << ", resource: " << PRINT_PTR(source.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return true;
  }

  if (original_dest_desc.type != reshade::api::resource_type::texture_2d && original_dest_desc.type != reshade::api::resource_type::texture_3d) {
    std::stringstream s;
    s << "mods::swapchain::OnCopyBufferToTexture(Unexpected dest type: ";
    s << original_dest_desc.type;
    s << ", resource: " << PRINT_PTR(dest.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return true;
  }

  std::shared_lock lock(utils::resource::store->resource_infos_mutex);
  auto source_pair = utils::resource::store->resource_infos.find(source.handle);
  if (source_pair == utils::resource::store->resource_infos.end()) {
    // assert(source_pair != utils::resource::store->resource_infos.end());
    return false;
  }

  auto destination_pair = utils::resource::store->resource_infos.find(dest.handle);
  if (destination_pair == utils::resource::store->resource_infos.end()) {
    assert(destination_pair != utils::resource::store->resource_infos.end());
    return false;
  }

  lock.unlock();

  auto& source_info = source_pair->second;
  auto& destination_info = destination_pair->second;

  const auto source_clone = GetResourceClone(&source_info);
  const auto dest_clone = GetResourceClone(&destination_info);

  if (!source_info.upgraded && !destination_info.upgraded
      && (source_clone.handle == 0u) && (dest_clone.handle == 0u)) return false;

  if (source_clone.handle == 0u) {
    std::stringstream s;
    s << "mods::swapchain::OnCopyBufferToTexture(Unexpected source clone: ";
    s << PRINT_PTR(dest.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return true;
  }

  if (dest_clone.handle == 0u) {
    reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnCopyBufferToTexture(Unreachable?)");
  }

  if (destination_info.desc.texture.format == destination_info.clone_desc.texture.format) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnCopyBufferToTexture(Redirected to clone: ";
    s << PRINT_PTR(dest.handle);
    s << " => " << PRINT_PTR(dest_clone.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->copy_buffer_to_texture(source, source_offset, row_length, slice_height, dest_clone, dest_subresource);

    return true;
    // remap to other
  }
  // Mismatched, copy to original and blit?
  cmd_list->copy_buffer_to_texture(source, source_offset, row_length, slice_height, dest, dest_subresource);

  std::stringstream s;
  s << "mods::swapchain::OnCopyBufferToTexture(mismatched ";
  s << PRINT_PTR(source.handle);
  s << "[" << source_offset << "]";
  s << " => " << PRINT_PTR(dest.handle);
  s << "[" << dest_subresource << "]";
  s << " (" << destination_info.clone_desc.texture.format << ")";
  if (dest_box != nullptr) {
    s << "(" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")";
  }
  s << ")";

  reshade::log::message(reshade::log::level::warning, s.str().c_str());

  if (cmd_list->get_device()->get_api() == reshade::api::device_api::vulkan) {
    // perform blit
    cmd_list->copy_texture_region(dest, dest_subresource, dest_box, dest_clone, dest_subresource, dest_box);
    return true;
  } else {
    // Perform DirectX blit
    return true;
  }

  return true;
}

inline bool OnCreateResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc& desc) {
  local_original_resource_view_desc.reset();
  if (resource.handle == 0u) return false;
  if (device == proxy_device_reshade) return false;
  bool expected = false;
  bool found_upgrade = false;

  switch (desc.type) {
    case reshade::api::resource_view_type::texture_1d:
    case reshade::api::resource_view_type::texture_1d_array:
    case reshade::api::resource_view_type::texture_2d:
    case reshade::api::resource_view_type::texture_2d_array:
    case reshade::api::resource_view_type::texture_2d_multisample:
    case reshade::api::resource_view_type::texture_2d_multisample_array:
    case reshade::api::resource_view_type::texture_3d:
    case reshade::api::resource_view_type::texture_cube:
    case reshade::api::resource_view_type::texture_cube_array:
      break;
    default:
    case reshade::api::resource_view_type::acceleration_structure:
    case reshade::api::resource_view_type::unknown:
    case reshade::api::resource_view_type::buffer:
      return false;
  }

  if (!upgrade_unknown_resource_views && desc.format == reshade::api::format::unknown) {
    return false;
  }

  reshade::api::resource_view_desc new_desc = desc;

  auto* resource_info_pointer = utils::resource::GetResourceInfo(resource);

  if (resource_info_pointer == nullptr) return false;
  auto& resource_info = *resource_info_pointer;

  reshade::api::resource_desc resource_desc = resource_info.desc;
  bool& is_back_buffer = resource_info.is_swap_chain;
  if (upgrade_resource_views && is_back_buffer) {
    if (!use_device_proxy) {
      new_desc.format = target_format;
      expected = true;
      found_upgrade = true;
    }
  } else if (resource_info.upgrade_target != nullptr) {
    auto* target = resource_info.upgrade_target;
    if (auto pair2 = target->view_upgrades.find({usage_type, desc.format});
        pair2 != target->view_upgrades.end() && pair2->second != reshade::api::format::unknown) {
      new_desc.format = pair2->second;
      found_upgrade = true;
    }
    if (!found_upgrade) {
      std::stringstream s;
      s << "mods::swapchain::OnCreateResourceView(";
      s << "unexpected case(" << desc.format << ")";
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
    expected = true;
  } else if (resource_desc.texture.format == target_format || resource_desc.texture.format == reshade::api::format::r16g16b16a16_typeless) {
    switch (new_desc.format) {
      case reshade::api::format::r8g8b8a8_typeless:
      case reshade::api::format::b8g8r8a8_typeless:
      case reshade::api::format::r10g10b10a2_typeless:
      case reshade::api::format::r16g16b16a16_typeless:
        new_desc.format = reshade::api::format::r16g16b16a16_typeless;
        break;
      case reshade::api::format::r8g8b8a8_unorm:
      case reshade::api::format::b8g8r8a8_unorm:
        new_desc.format = target_format;
        break;
      case reshade::api::format::r8g8b8a8_unorm_srgb:
      case reshade::api::format::b8g8r8a8_unorm_srgb:
        // Should upgrade shader
        new_desc.format = target_format;
        break;
      case reshade::api::format::b10g10r10a2_unorm:
      case reshade::api::format::r10g10b10a2_unorm:
        new_desc.format = target_format;
        break;
      case reshade::api::format::r16g16b16a16_float:
        break;
      default: {
        std::stringstream s;
        s << "mods::swapchain::OnCreateResourceView(";
        s << "unexpected case(" << desc.format << ")";
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        break;
      }
    }
  } else {
    return false;
  }

  const bool changed = (desc.format != new_desc.format);

  if (changed && (
#ifdef DEBUG_LEVEL_1
          true ||
#endif
          desc.format == reshade::api::format::unknown)) {
    std::stringstream s;
    s << "mods::swapchain::OnCreateResourceView(" << (changed ? "upgrading" : "logging");
    s << ", found_upgrade: " << (found_upgrade ? "true" : "false");
    s << ", expected: " << (expected ? "true" : "false");
    s << ", view type: " << desc.type;
    s << ", view format: " << desc.format << " => " << new_desc.format;
    s << ", resource: " << PRINT_PTR(resource.handle);
    s << ", resource width: " << resource_desc.texture.width;
    s << ", resource height: " << resource_desc.texture.height;
    s << ", resource format: " << resource_desc.texture.format;
    s << ", resource usage: " << usage_type;
    s << ")";
    reshade::log::message(
        desc.format == reshade::api::format::unknown
            ? reshade::log::level::warning
            : reshade::log::level::info,
        s.str().c_str());
  };

  if (!changed) {
    if (!is_back_buffer) return false;
    if (!UsingSwapchainProxy()) return false;
    if (swap_chain_proxy_format == target_format) return false;
    // Continue to creating a resource clone
  }

  if (use_resource_cloning) {
    if (resource_info.clone_target != nullptr) {
      auto* upgrade_info = resource_info.clone_target;
      if (!upgrade_info->use_resource_view_cloning_and_upgrade) {
        return false;
      }
      // Upgrade on init instead (allows resource view handle reuse)
      // Cloning with upgrade

      // local_original_resource_view =
    }
  }
  if (!changed) return false;

  local_original_resource_view_desc = desc;

  desc.format = new_desc.format;

  return true;
}

inline void OnInitResourceViewInfo(utils::resource::ResourceViewInfo* resource_view_info) {
  if (local_original_resource_view_desc.has_value()) {
    resource_view_info->fallback_desc = local_original_resource_view_desc.value();
    local_original_resource_view_desc.reset();
  }
}

inline void OnDestroyResourceViewInfo(utils::resource::ResourceViewInfo* resource_view_info) {
  if (resource_view_info->resource_info != nullptr && resource_view_info->resource_info->is_swap_chain) {
    reshade::log::message(reshade::log::level::warning, "Destroyed swapchain RTV");
  }
  if (resource_view_info->clone.handle != 0u) {
    resource_view_info->device->destroy_resource_view(resource_view_info->clone);
    resource_view_info->clone.handle = 0u;
  }

  if (resource_view_info->fallback.handle != 0u) {
    resource_view_info->device->destroy_resource_view(resource_view_info->fallback);
    resource_view_info->fallback.handle = 0u;
  }
}

inline bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  // Reshade's get_resource_desc has no lock

  auto source_desc = cmd_list->get_device()->get_resource_desc(source);
  switch (source_desc.type) {
    case reshade::api::resource_type::unknown:
    case reshade::api::resource_type::buffer:
      return false;
    case reshade::api::resource_type::texture_1d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::surface:
    default:
      break;
  }

  auto dest_desc = cmd_list->get_device()->get_resource_desc(dest);

  auto source_new = source;
  auto dest_new = dest;
  auto source_desc_new = source_desc;
  auto dest_desc_new = dest_desc;

  bool can_be_copied = (source_desc_new.texture.format == dest_desc_new.texture.format)
                       || (reshade::api::format_to_typeless(source_desc_new.texture.format)
                           == reshade::api::format_to_typeless(dest_desc_new.texture.format));

  if (use_resource_cloning) {
    std::shared_lock lock(utils::resource::store->resource_infos_mutex);

    auto source_pair = utils::resource::store->resource_infos.find(source.handle);
    if (source_pair == utils::resource::store->resource_infos.end()) {
      assert(source_pair != utils::resource::store->resource_infos.end());
      return false;
    }

    auto destination_pair = utils::resource::store->resource_infos.find(dest.handle);
    if (destination_pair == utils::resource::store->resource_infos.end()) {
      assert(destination_pair != utils::resource::store->resource_infos.end());
      return false;
    }

    lock.unlock();

    auto& source_info = source_pair->second;
    auto& destination_info = destination_pair->second;

    auto source_clone = GetResourceClone(&source_info);
    auto dest_clone = GetResourceClone(&destination_info);

    if (source_clone.handle != 0u) {
      source_desc_new = source_info.clone_desc;
      source_new = source_clone;
    }
    if (dest_clone.handle != 0u) {
      dest_desc_new = destination_info.clone_desc;
      dest_new = dest_clone;
    }
    can_be_copied = (source_desc_new.texture.format == dest_desc_new.texture.format)
                    || (reshade::api::format_to_typeless(source_desc_new.texture.format)
                        == reshade::api::format_to_typeless(dest_desc_new.texture.format));

    if (!can_be_copied && use_auto_upgrade) {
      if (source_info.desc.texture.format != auto_upgrade_target.new_format && source_info.clone_target == nullptr) {
        std::stringstream s;
        s << "mods::swapchain::OnCopyResource(";
        s << "Auto upgrading source: ";
        s << "original: " << PRINT_PTR(source.handle);
        s << ", format: " << source_desc.texture.format;
        s << ", type: " << source_desc.type;
        s << ");";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
        source_info.clone_target = &auto_upgrade_target;
      }
      if (destination_info.desc.texture.format != auto_upgrade_target.new_format && destination_info.clone_target == nullptr) {
        std::stringstream s;
        s << "mods::swapchain::OnCopyResource(";
        s << "Auto upgrading destination: ";
        s << "original: " << PRINT_PTR(dest.handle);
        s << ", format: " << dest_desc.texture.format;
        s << ", type: " << dest_desc.type;
        s << ");";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
        destination_info.clone_target = &auto_upgrade_target;
      }
    }
  }

  // {
  //   std::stringstream s;
  //   s << "mods::swapchain::OnCopyResource(";
  //   s << "attempt resource copy: ";
  //   s << PRINT_PTR(source.handle) << " => " << PRINT_PTR(dest.handle);
  //   s << ", format: " << source_desc.texture.format << " => " << dest_desc.texture.format;
  //   s << ", type: " << source_desc.type << " => " << dest_desc.type;
  //   s << ", clone: " << PRINT_PTR(source_new.handle) << " => " << PRINT_PTR(dest_new.handle);
  //   s << ", clone_format: " << source_desc_new.texture.format << " => " << dest_desc_new.texture.format;
  //   s << ", clone_type: " << source_desc_new.type << " => " << dest_desc_new.type;
  //   s << ");";
  //   reshade::log::message(reshade::log::level::debug, s.str().c_str());
  // }

  if (can_be_copied) {
    cmd_list->copy_resource(source_new, dest_new);
    return true;
  }

  // Mismatched (don't copy);
#ifdef DEBUG_LEVEL_2
  std::stringstream s;
  s << "mods::swapchain::OnCopyResource(";
  s << "prevent resource copy: ";
  s << "original: " << PRINT_PTR(source.handle) << " => " << PRINT_PTR(dest.handle);
  s << ", format: " << source_desc.texture.format << " => " << dest_desc.texture.format;
  s << ", type: " << source_desc.type << " => " << dest_desc.type;
  s << ", clone: " << PRINT_PTR(source_new.handle) << " => " << PRINT_PTR(dest_new.handle);
  s << ", clone_format: " << source_desc_new.texture.format << " => " << dest_desc_new.texture.format;
  s << ", clone_type: " << source_desc_new.type << " => " << dest_desc_new.type;
  s << ");";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

  return true;
}

// Create DescriptorTables with RSVs
inline bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (count == 0u) return false;
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnUpdateDescriptorTables()");
#endif
  reshade::api::descriptor_table_update* new_updates = nullptr;
  bool changed = false;
  bool active = false;

  std::vector<std::pair<std::pair<int, int>, utils::resource::ResourceViewInfo*>> infos;
  {
    std::shared_lock lock(utils::resource::store->resource_view_infos_mutex);
    for (uint32_t i = 0; i < count; ++i) {
      const auto& update = updates[i];
      if (update.table.handle == 0u) continue;
      for (uint32_t j = 0; j < update.count; j++) {
        switch (update.type) {
          case reshade::api::descriptor_type::sampler_with_resource_view: {
            auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
            auto resource_view = item.view;
            if (resource_view.handle == 0u) continue;

            auto pair = utils::resource::store->resource_view_infos.find(resource_view.handle);
            if (pair != utils::resource::store->resource_view_infos.end()) {
              infos.push_back({{i, j}, &pair->second});
            }

          } break;
          case reshade::api::descriptor_type::texture_shader_resource_view:
          case reshade::api::descriptor_type::texture_unordered_access_view:
          case reshade::api::descriptor_type::buffer_shader_resource_view:
          case reshade::api::descriptor_type::buffer_unordered_access_view:
          case reshade::api::descriptor_type::acceleration_structure:        {
            auto resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
            if (resource_view.handle == 0u) continue;

            auto pair = utils::resource::store->resource_view_infos.find(resource_view.handle);
            if (pair != utils::resource::store->resource_view_infos.end()) {
              infos.push_back({{i, j}, &pair->second});
            }
          } break;
          default:
            break;
        }
      }
    }
  }

  for (const auto& [position, info] : infos) {
    const auto [i, j] = position;
    const auto& update = updates[i];

    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        auto resource_view_clone = GetResourceViewClone(info);
        if (resource_view_clone.handle == 0u) continue;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnUpdateDescriptorTables(found clonable: ";
        s << PRINT_PTR(resource_view_clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (!changed) {
          new_updates = renodx::utils::descriptor::CloneDescriptorTableUpdates(updates, count);
        }

        // NOLINTNEXTLINE(google-readability-casting)
        ((reshade::api::sampler_with_resource_view*)(new_updates[i].descriptors))[j].view = resource_view_clone;
        changed = true;
        // if (data.enabled_cloned_resources.contains(new_resource.handle)) {
        //   active = true;
        // }
        break;
      }
      case reshade::api::descriptor_type::texture_shader_resource_view:
      case reshade::api::descriptor_type::texture_unordered_access_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::acceleration_structure:        {
        auto resource_view_clone = GetResourceViewClone(info);
        if (resource_view_clone.handle == 0u) continue;
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnUpdateDescriptorTables(found clonable: ";
        s << PRINT_PTR(resource_view_clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (!changed) {
          new_updates = renodx::utils::descriptor::CloneDescriptorTableUpdates(updates, count);
        }

        // NOLINTNEXTLINE(google-readability-casting)
        ((reshade::api::resource_view*)(new_updates[i].descriptors))[j] = resource_view_clone;
        changed = true;
        // if (data.enabled_cloned_resources.contains(new_resource.handle)) {
        //   active = true;
        // }
        break;
      }
      default:
        break;
    }
  }

  if (changed) {
    device->update_descriptor_tables(count, new_updates);
    // free(new_updates);

  } else {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnUpdateDescriptorTables(no clonable.)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
  }
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnUpdateDescriptorTables(done)");
#endif
  return false;
}

inline bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (!use_resource_cloning) return false;
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnCopyDescriptorTables()");
#endif
  for (uint32_t i = 0; i < count; i++) {
    const auto& copy = copies[i];
    for (uint32_t j = 0; j < copy.count; j++) {
      auto* data = renodx::utils::data::Get<DeviceData>(device);
      if (data == nullptr) return false;
      const std::unique_lock lock(data->mutex);

      reshade::api::descriptor_heap source_heap = {0};
      uint32_t source_base_offset = 0;
      device->get_descriptor_heap_offset(copy.source_table, copy.source_binding + j, copy.source_array_offset, &source_heap, &source_base_offset);
      reshade::api::descriptor_heap dest_heap = {0};
      uint32_t dest_base_offset = 0;
      device->get_descriptor_heap_offset(copy.dest_table, copy.dest_binding + j, copy.dest_array_offset, &dest_heap, &dest_base_offset);

      bool erase = false;
      if (auto pair = data->heap_descriptor_infos.find(source_heap.handle); pair != data->heap_descriptor_infos.end()) {
        auto& source_map = pair->second;
        if (auto pair2 = source_map.find(source_base_offset); pair2 != source_map.end()) {
          if (dest_heap.handle == source_heap.handle) {
            source_map[dest_base_offset] = source_map[source_base_offset];
          } else {
            if (auto pair3 = data->heap_descriptor_infos.find(dest_heap.handle); pair3 != data->heap_descriptor_infos.end()) {
              auto& dest_map = pair3->second;
              dest_map[dest_base_offset] = source_map[source_base_offset];
            } else {
              data->heap_descriptor_infos[dest_heap.handle] = {{
                  dest_base_offset,
                  source_map[source_base_offset],
              }};
            }
          }
#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "mods::swapchain::OnCopyDescriptorTables(cloning heap: ";
          s << PRINT_PTR(source_heap.handle);
          s << "[" << source_base_offset << "]";
          s << " => ";
          s << PRINT_PTR(dest_heap.handle);
          s << "[" << dest_base_offset << "]";
          s << ", table: " << PRINT_PTR(source_map[source_base_offset]->replacement_descriptor_handle);
          s << ", size: " << source_map[source_base_offset]->updates.size();
          s << ")";
          reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        } else {
          erase = true;
        }
      } else {
        erase = true;
      }
      if (erase) {
        if (auto pair3 = data->heap_descriptor_infos.find(dest_heap.handle); pair3 != data->heap_descriptor_infos.end()) {
          auto& dest_map = pair3->second;
          dest_map.erase(dest_base_offset);
        }
      }
    }
  }

#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "copy_descriptor_tables(done)");
#endif

  return false;
}

inline void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  if (count == 0u) return;
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnBindDescriptorTables()");
#endif
  auto* device = cmd_list->get_device();
  reshade::api::descriptor_table* new_tables = nullptr;
  bool built_new_tables = false;
  bool active = false;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  reshade::api::descriptor_heap heap = {0};
  uint32_t base_offset = 0;
  for (uint32_t i = 0; i < count; ++i) {
    device->get_descriptor_heap_offset(tables[i], 0, 0, &heap, &base_offset);

    HeapDescriptorInfo* info = nullptr;
    bool found_info = false;
    if (auto pair = data->heap_descriptor_infos.find(heap.handle); pair != data->heap_descriptor_infos.end()) {
      auto& map = pair->second;
      if (auto pair2 = map.find(base_offset); pair2 != map.end()) {
        info = pair2->second;
        found_info = true;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(found heap info: ";
        s << PRINT_PTR(heap.handle);
        s << "[" << base_offset << "]";
        s << ", handle: " << PRINT_PTR(info->replacement_descriptor_handle);
        s << ", size: " << info->updates.size();
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      }
    }
    if (found_info) {
      if (info->replacement_descriptor_handle == 0) {
        reshade::api::descriptor_table new_table = {0};
        bool allocated = device->allocate_descriptor_table(layout, first + i, &new_table);
        if (new_table.handle == 0u) {
          std::stringstream s;
          s << "mods::swapchain::OnBindDescriptorTables(could not allocate new table: ";
          s << PRINT_PTR(tables[i].handle);
          s << " via ";
          s << PRINT_PTR(layout.handle);
          s << "[" << first + i << "]";
          s << ", allocated: " << (allocated ? "true" : "false");
          s << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());

          allocated = device->allocate_descriptor_table({0}, 0u, &new_table);
          if (new_table.handle == 0u) {
            std::stringstream s;
            s << "mods::swapchain::OnBindDescriptorTables(could not allocate new table (2): ";
            s << PRINT_PTR(tables[i].handle);
            s << " via ";
            s << reinterpret_cast<void*>(0);
            s << "[" << first + i << "]";
            s << ", allocated: " << (allocated ? "true" : "false");
            s << ")";
            reshade::log::message(reshade::log::level::error, s.str().c_str());
            continue;
          }
          info->replacement_descriptor_handle = new_table.handle;
        }
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(allocate new table pre-bind: ";
        s << PRINT_PTR(tables[i].handle);
        s << " => ";
        s << PRINT_PTR(new_table.handle);
        s << " via ";
        s << PRINT_PTR(layout.handle);
        s << "[" << first + i << "]";
        s << ", updates: " << reinterpret_cast<uintptr_t>(&info->updates);
        s << " (" << info->updates.size() << ")";
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        auto* update_data = info->updates.data();
        auto len = info->updates.size();
        for (uint32_t j = 0; j < len; ++j) {
          auto& item = update_data[j];
          item.table = {new_table.handle};
        }
#ifdef DEBUG_LEVEL_1
        std::stringstream s2;
        s2 << "mods::swapchain::OnBindDescriptorTables(updated created table: ";
        s2 << reinterpret_cast<uintptr_t>(&info->updates);
        s2 << ", size" << len;
        s2 << ")";
        reshade::log::message(reshade::log::level::debug, s2.str().c_str());
#endif
        device->update_descriptor_tables(len, update_data);
        info->replacement_descriptor_handle = new_table.handle;
      } else {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(no base_offset: ";
        s << PRINT_PTR(heap.handle) << "[" << base_offset << "]";
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      }

      if (info->replacement_descriptor_handle != 0) {
        if (!built_new_tables) {
          const size_t size = count * sizeof(reshade::api::descriptor_table);
          new_tables = static_cast<reshade::api::descriptor_table*>(malloc(size));
          memcpy(new_tables, tables, size);
          built_new_tables = true;
        }
        new_tables[i].handle = info->replacement_descriptor_handle;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(replace bind: ";
        s << PRINT_PTR(tables[i].handle);
        s << " => ";
        s << PRINT_PTR(new_tables[i].handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (info->is_active) {
          active = true;
        }
      }
    }
  }

  if (active) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnBindDescriptorTables(apply bind)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->bind_descriptor_tables(stages, layout, first, count, new_tables);
  } else if (built_new_tables) {
    auto* cmd_data = renodx::utils::data::Get<CommandListData>(cmd_list);
    if (cmd_data == nullptr) return;
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnBindDescriptorTables(storing unbound descriptor)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_data->unbound_descriptors.push_back({
        .stages = stages,
        .layout = layout,
        .first = first,
        .count = count,
        .tables = {new_tables[0], new_tables[count - 1]},
    });
  }
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnBindDescriptorTables(done)");
#endif
}

// Set DescriptorTables RSVs
inline void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (update.count == 0u) return;

  reshade::api::descriptor_table_update new_update;

#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnPushDescriptors()");
#endif

  bool changed = false;
  bool active = false;

  for (uint32_t i = 0; i < update.count; i++) {
    // if (!update.table.handle) continue;
    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        auto resource_view = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i].view;
        if (resource_view.handle == 0) continue;
        auto clone = GetResourceViewClone(resource_view);
        if (clone.handle == 0) continue;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnPushDescriptors(found clonable: ";
        s << PRINT_PTR(clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (!changed) {
          new_update = renodx::utils::descriptor::CloneDescriptorTableUpdates(&update, 1)[0];
        }

        // NOLINTNEXTLINE(google-readability-casting)
        ((reshade::api::sampler_with_resource_view*)(new_update.descriptors))[i].view = clone;
        changed = true;
        break;
      }
      case reshade::api::descriptor_type::texture_shader_resource_view:
      case reshade::api::descriptor_type::texture_unordered_access_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::acceleration_structure:        {
        auto resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        if (resource_view.handle == 0) continue;
        auto clone = GetResourceViewClone(resource_view);
        if (clone.handle == 0) continue;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnPushDescriptors(found clonable: ";
        s << PRINT_PTR(clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (!changed) {
          new_update = renodx::utils::descriptor::CloneDescriptorTableUpdates(&update, 1)[0];
        }

        // NOLINTNEXTLINE(google-readability-casting)
        ((reshade::api::resource_view*)(new_update.descriptors))[i] = clone;
        changed = true;

        break;
      }
      default:
        break;
    }
  }

  if (changed || active) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnPushDescriptors(apply push)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->push_descriptors(stages, layout, layout_param, new_update);
  } else if (changed) {
    auto* cmd_data = renodx::utils::data::Get<CommandListData>(cmd_list);
    if (cmd_data == nullptr) return;
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnPushDescriptors(storing unpushed descriptor)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_data->unpushed_updates.push_back({
        .stages = stages,
        .layout = layout,
        .layout_param = layout_param,
        .update = new_update,
    });
  }
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "push_descriptors(done)");
#endif
}

// Set render target RSV
inline void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (count == 0u) return;

  RewriteRenderTargets(cmd_list, count, rtvs, dsv);
}

inline bool OnClearRenderTargetView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  auto clone = GetResourceViewClone(rtv);
  if (clone.handle != 0) {
    cmd_list->clear_render_target_view(clone, color, rect_count, rects);
  }
  return false;
}

inline bool OnClearUnorderedAccessViewUint(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const uint32_t values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  auto* info = utils::resource::GetResourceViewInfo(uav);
  if (info == nullptr) return false;
  auto& clone = info->clone;
  if (clone.handle != 0) {
    switch (info->desc.format) {
      case reshade::api::format::r16g16b16a16_float:
      case reshade::api::format::r11g11b10_float:    {
        float values_float[4] = {
            static_cast<float>(values[0]),
            static_cast<float>(values[1]),
            static_cast<float>(values[2]),
            static_cast<float>(values[3]),
        };
        // std::transform(values[0], values[3], values_float, [](uint32_t value) { return static_cast<float>(value); });
        cmd_list->clear_unordered_access_view_float(clone, values_float, rect_count, rects);
        break;
      }
      default:
        cmd_list->clear_unordered_access_view_uint(clone, values, rect_count, rects);
    }
  }
  return false;
}

inline bool OnClearUnorderedAccessViewFloat(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const float values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  auto clone = GetResourceViewClone(uav);

  if (clone.handle != 0) {
    cmd_list->clear_unordered_access_view_float(clone, values, rect_count, rects);
  }
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
  std::shared_lock lock(utils::resource::store->resource_infos_mutex);

  auto source_pair = utils::resource::store->resource_infos.find(source.handle);
  if (source_pair == utils::resource::store->resource_infos.end()) {
    assert(source_pair != utils::resource::store->resource_infos.end());
    return false;
  }

  auto destination_pair = utils::resource::store->resource_infos.find(dest.handle);
  if (destination_pair == utils::resource::store->resource_infos.end()) {
    assert(destination_pair != utils::resource::store->resource_infos.end());
    return false;
  }

  lock.unlock();

  auto& source_info = source_pair->second;
  auto& destination_info = destination_pair->second;

  auto source_format = source_info.desc.texture.format;
  auto destination_format = destination_info.desc.texture.format;

  if (source_format != destination_format) return false;

  auto new_format = source_format;
  if (source_format == reshade::api::format::r16g16b16a16_typeless) {
    new_format = reshade::api::format::r16g16b16a16_float;
  }

  if (format == new_format) return false;

  cmd_list->resolve_texture_region(
      source, source_subresource, source_box,
      dest, dest_subresource, dest_x, dest_y, dest_z,
      new_format);
  return true;
}

inline void OnBarrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states) {
  if (count == 0u) return;

  std::unordered_set<uint64_t> checked_resources;
  std::vector<std::pair<int, utils::resource::ResourceInfo*>> infos;
  {
    std::shared_lock lock(utils::resource::store->resource_infos_mutex);
    for (uint32_t i = 0; i < count; ++i) {
      if (old_states[i] == reshade::api::resource_usage::undefined) continue;
      const auto& resource = resources[i];
      if (resource.handle == 0u) continue;
      bool checked = !checked_resources.insert(resource.handle).second;
      if (checked) continue;
      auto pair = utils::resource::store->resource_infos.find(resource.handle);
      if (pair != utils::resource::store->resource_infos.end()) {
        infos.emplace_back(i, &pair->second);
      }
    }
  }

  // Barriers may have duplicates
  std::unordered_set<uint64_t> applied_barriers;
  for (auto& [i, info] : infos) {
    if (info->clone.handle != 0u) {
      bool inserted = applied_barriers.insert(info->clone.handle).second;
      if (inserted) {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBarrier(apply barrier clone: ";
        s << PRINT_PTR(info->resource.handle);
        s << " => ";
        s << PRINT_PTR(info->clone.handle);
        s << ", state: " << old_states[i] << " => " << new_states[i];
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        cmd_list->barrier(info->clone, old_states[i], new_states[i]);
      }
    }
  }
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
  // Reshade's get_resource_desc has no lock

  auto source_desc = cmd_list->get_device()->get_resource_desc(source);

  // auto source_desc = device->get_resource_desc(source);
  // auto dest_desc = device->get_resource_desc(dest);
  if (source_desc.type != reshade::api::resource_type::texture_2d
      && source_desc.type != reshade::api::resource_type::texture_3d) return false;
  auto dest_desc = cmd_list->get_device()->get_resource_desc(dest);
  if (dest_desc.type != source_desc.type) return false;
  auto source_new = source;
  auto dest_new = dest;
  auto source_desc_new = source_desc;
  auto dest_desc_new = dest_desc;
  if (use_resource_cloning) {
    std::shared_lock lock(utils::resource::store->resource_infos_mutex);
    auto source_pair = utils::resource::store->resource_infos.find(source.handle);
    if (source_pair == utils::resource::store->resource_infos.end()) {
      assert(source_pair != utils::resource::store->resource_infos.end());
      return false;
    }

    auto destination_pair = utils::resource::store->resource_infos.find(dest.handle);
    if (destination_pair == utils::resource::store->resource_infos.end()) {
      assert(destination_pair != utils::resource::store->resource_infos.end());
      return false;
    }

    lock.unlock();

    auto& source_info = source_pair->second;
    auto& destination_info = destination_pair->second;
    auto source_clone = GetResourceClone(&source_info);
    auto dest_clone = GetResourceClone(&destination_info);

    if (source_clone.handle == 0u && dest_clone.handle == 0u) return false;

    if (source_clone.handle != 0u) {
      source_desc_new = source_info.clone_desc;
      source_new = source_clone;
    }
    if (dest_clone.handle != 0u) {
      dest_desc_new = destination_info.clone_desc;
      dest_new = dest_clone;
    }
  }

  bool can_be_copied = (source_desc_new.texture.format == dest_desc_new.texture.format)
                       || (reshade::api::format_to_typeless(source_desc_new.texture.format)
                           == reshade::api::format_to_typeless(dest_desc_new.texture.format));

  if (can_be_copied) {
    cmd_list->copy_texture_region(source_new, source_subresource, source_box, dest_new, dest_subresource, dest_box, filter);
    return true;
  }
  // Mismatched (don't copy);

  std::stringstream s;
  s << "OnCopyTextureRegion";
  s << "(mismatched: " << PRINT_PTR(source.handle);
  s << "[" << source_subresource << "]";
  if (source.handle != source_new.handle) {
    s << "(clone: " << PRINT_PTR(source_new.handle);
  }
  if (source_box != nullptr) {
    s << " (" << source_box->top << ", " << source_box->left << ", " << source_box->front << ")";
  }
  s << " (" << source_desc.texture.format << ")";
  if (source.handle != source_new.handle) {
    s << " (clone: " << source_desc_new.texture.format << ")";
  }
  s << " => " << PRINT_PTR(dest.handle);
  if (dest.handle != dest_new.handle) {
    s << " (clone: " << PRINT_PTR(source_new.handle);
  }
  s << "[" << dest_subresource << "]";
  s << " (" << dest_desc.texture.format << ")";
  if (dest.handle != dest_new.handle) {
    s << " (clone: " << dest_desc_new.texture.format << ")";
  }
  if (dest_box != nullptr) {
    s << " (" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")";
  }
  s << ")";

  reshade::log::message(reshade::log::level::warning, s.str().c_str());

  if (cmd_list->get_device()->get_api() == reshade::api::device_api::vulkan) {
    // perform blit
    cmd_list->copy_texture_region(source, source_subresource, source_box, dest, dest_subresource, dest_box);
    return true;
  } else {
    // Perform DirectX blit
    return true;
  }
}

static bool OnSetFullscreenState(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
  auto* device = swapchain->get_device();
  if (device == proxy_device_reshade) return false;

  auto* private_data = renodx::utils::data::Get<DeviceData>(device);
  if (private_data == nullptr) return false;

  if (use_resize_buffer && use_resize_buffer_on_set_full_screen) {
    renodx::utils::swapchain::ResizeBuffer(swapchain, target_format, target_color_space);
  }

  {
    const std::unique_lock lock(private_data->mutex);
    reshade::log::message(reshade::log::level::info, "mods::swapchain::OnSetFullscreenState(reset resource upgrade)");
    private_data->resource_upgrade_finished = false;
    const uint32_t len = swap_chain_upgrade_targets.size();
    // Reset
    for (uint32_t i = 0; i < len; i++) {
      renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
      if (target->ignore_reset) continue;
      target->counted = 0;
      target->completed = false;
    }
  }

  if (!fullscreen) return false;

  // Ensure resize buffer is called
  // renodx::utils::swapchain::FastResizeBuffer(swapchain);

  if (private_data->prevent_full_screen) {
    HWND output_window = static_cast<HWND>(swapchain->get_hwnd());
    if (output_window != nullptr) {
      HMONITOR monitor = MonitorFromWindow(output_window, MONITOR_DEFAULTTONEAREST);
      if (monitor == nullptr) {
        reshade::log::message(reshade::log::level::error, "mods::swapchain::OnSetFullscreenState(could not get monitor)");
        return false;
      }

      MONITORINFO monitor_info = {};
      monitor_info.cbSize = sizeof(MONITORINFO);

      GetMonitorInfo(monitor, &monitor_info);

      const int screen_width = monitor_info.rcMonitor.right - monitor_info.rcMonitor.left;
      const int screen_height = monitor_info.rcMonitor.bottom - monitor_info.rcMonitor.top;

      const uint32_t texture_width = private_data->primary_swapchain_desc.texture.width;
      const uint32_t texture_height = private_data->primary_swapchain_desc.texture.height;
      // Move to center of screen (game may be lower resolution than screen)
      const uint32_t left = trunc((screen_width - texture_width) / 2.f);
      const uint32_t top = trunc((screen_height - texture_height) / 2.f);

      RemoveWindowBorder(output_window);

      RECT rect = {NULL};
      if (GetWindowRect(output_window, &rect) != 0) {
        auto rect_width = rect.right - rect.left;
        auto rect_height = rect.bottom - rect.top;

        SetWindowPos(
            output_window,
            HWND_TOP,
            monitor_info.rcMonitor.left + left, monitor_info.rcMonitor.top + top,
            texture_width, texture_height,
            SWP_ASYNCWINDOWPOS | SWP_FRAMECHANGED | SWP_NOACTIVATE | SWP_NOZORDER);
      }
    }
    reshade::log::message(reshade::log::level::info, "Preventing fullscreen");
    return true;
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

  if (use_device_proxy && device != proxy_device_reshade) {
    auto* new_device = GetDeviceProxy(swapchain, queue);
    if (new_device == nullptr) return;
    proxied_device_reshade = device;

    auto* cmd_list = queue->get_immediate_command_list();
    auto current_back_buffer = swapchain->get_current_back_buffer();

    auto* data = renodx::utils::data::Get<DeviceData>(device);
    if (data == nullptr) return;

    auto* resource_info = utils::resource::GetResourceInfoUnsafe(current_back_buffer);
    if (resource_info == nullptr) return;

    reshade::api::resource swapchain_clone;

    auto& resource_clone = resource_info->clone;
    if (resource_clone.handle == 0u) {
      CloneResource(resource_info);
    }
    if (resource_clone.handle == 0u) return;
    swapchain_clone = resource_clone;

    if (resource_info->shared_handle == nullptr) return;

    // Ready to copy
    queue->flush_immediate_command_list();
    assert(last_device_proxy_shared_handle == nullptr);
    last_device_proxy_shared_handle = resource_info->shared_handle;

    // Trigger a DX11 Present which will start the swapchain proxy steps on DX11

    auto* native_device = (IDirect3DDevice9*)device->get_native();
    HWND output_window = static_cast<HWND>(swapchain->get_hwnd());
    proxy_swap_chain->Present(0, DXGI_PRESENT_ALLOW_TEARING);
    last_device_proxy_shared_handle = nullptr;
  } else {
    DrawSwapChainProxy(swapchain, queue);
  }
}

template <typename T = float*>
static void Use(DWORD fdw_reason, T* new_injections = nullptr) {
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::swapchain::Use(fdw_reason);
  if (swapchain_proxy_revert_state) {
    renodx::utils::state::Use(fdw_reason);
  }
  if (use_resource_cloning) {
    // renodx::utils::descriptor::Use(fdw_reason);
  }

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "mods::swapchain attached.");
#if RESHADE_API_VERSION >= 17
      reshade::register_event<reshade::addon_event::create_device>(OnCreateDevice);
#endif
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
      reshade::register_event<reshade::addon_event::create_resource>(OnCreateResource);
      reshade::register_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);

      renodx::utils::resource::store->on_init_resource_info_callbacks.emplace_back(&OnInitResourceInfo);
      renodx::utils::resource::store->on_destroy_resource_info_callbacks.emplace_back(&OnDestroyResourceInfo);
      renodx::utils::resource::store->on_init_resource_view_info_callbacks.emplace_back(&OnInitResourceViewInfo);
      renodx::utils::resource::store->on_destroy_resource_view_info_callbacks.emplace_back(&OnDestroyResourceViewInfo);

      reshade::register_event<reshade::addon_event::copy_resource>(OnCopyResource);

      reshade::register_event<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);

      if (use_resource_cloning) {
        // reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
        // reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

        reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
        reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
        reshade::register_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
        // reshade::register_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
        // reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
        reshade::register_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
        reshade::register_event<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint);
        reshade::register_event<reshade::addon_event::clear_unordered_access_view_float>(OnClearUnorderedAccessViewFloat);

        reshade::register_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
        // reshade::register_event<reshade::addon_event::barrier>(OnBarrier);
        reshade::register_event<reshade::addon_event::copy_buffer_to_texture>(OnCopyBufferToTexture);

        if (UsingSwapchainProxy()) {
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
#if RESHADE_API_VERSION >= 17
      reshade::unregister_event<reshade::addon_event::create_device>(OnCreateDevice);
#endif

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::unregister_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

      reshade::unregister_event<reshade::addon_event::create_resource>(OnCreateResource);
      reshade::unregister_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);

      // renodx::utils::resource::on_init_resource_info_callbacks.erase(&OnInitResourceInfo);
      // renodx::utils::resource::on_destroy_resource_info_callbacks.erase(&OnDestroyResourceInfo);
      // renodx::utils::resource::on_init_resource_view_info_callbacks.erase(&OnInitResourceViewInfo);
      // renodx::utils::resource::on_destroy_resource_view_info_callbacks.erase(&OnDestroyResourceViewInfo);

      reshade::unregister_event<reshade::addon_event::copy_resource>(OnCopyResource);

      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);

      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
      // reshade::register_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
      // reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      reshade::unregister_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
      reshade::unregister_event<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint);
      reshade::unregister_event<reshade::addon_event::clear_unordered_access_view_float>(OnClearUnorderedAccessViewFloat);

      reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::barrier>(OnBarrier);
      reshade::unregister_event<reshade::addon_event::copy_buffer_to_texture>(OnCopyBufferToTexture);

      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);

      break;
  }
}
}  // namespace renodx::mods::swapchain
