/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>

#include <cstdio>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "../utils/descriptor.hpp"
#include "../utils/float16.hpp"
#include "../utils/format.hpp"
#include "../utils/hash.hpp"
#include "../utils/resource.hpp"
#include "../utils/swapchain.hpp"

namespace renodx::mods::swapchain {

struct SwapChainUpgradeTarget {
  reshade::api::format old_format = reshade::api::format::r8g8b8a8_unorm;
  reshade::api::format new_format = reshade::api::format::r16g16b16a16_float;
  int32_t index = -1;
  bool ignore_size = false;
  uint32_t shader_hash = 0;
  bool use_resource_view_cloning = false;
  bool use_resource_view_hot_swap = false;
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
  reshade::api::resource_usage state = reshade::api::resource_usage::undefined;

  const float ASPECT_RATIO_IGNORE = -1.f;
  const float ASPECT_RATIO_BACK_BUFFER = 0.f;
  float aspect_ratio = ASPECT_RATIO_IGNORE;

  uint32_t usage_set = 0;
  uint32_t usage_unset = 0;

  bool ignore_reset = false;

  std::unordered_map<
      std::pair<reshade::api::resource_usage, reshade::api::format>,
      reshade::api::format, utils::hash::HashPair>
      view_upgrades;

  std::pair<uint8_t, uint8_t> dimensions = {0, 0};
  std::pair<uint8_t, uint8_t> new_dimensions = {0, 0};

  [[nodiscard]]
  bool CheckResourceDesc(
      reshade::api::resource_desc desc,
      reshade::api::resource_desc back_buffer_desc,
      reshade::api::resource_usage state = reshade::api::resource_usage::undefined) const {
    if (desc.texture.format != this->old_format) return false;
    if (this->usage != reshade::api::resource_usage::undefined) {
      if (this->usage != desc.usage) return false;
    }
    if (this->state != reshade::api::resource_usage::undefined) {
      if (this->state != state) return false;
    }
    if (!this->ignore_size) {
      if (this->dimensions.first != 0 && this->dimensions.second != 0) {
        if (desc.texture.width != this->dimensions.first) return false;
        if (desc.texture.height != this->dimensions.second) return false;
      } else {
        if (this->aspect_ratio == ASPECT_RATIO_IGNORE) {
          if (desc.texture.width != back_buffer_desc.texture.width) return false;
          if (desc.texture.height != back_buffer_desc.texture.height) return false;
        } else {
          const float view_ratio = static_cast<float>(desc.texture.width) / static_cast<float>(desc.texture.height);
          float target_ratio;
          if (this->aspect_ratio == ASPECT_RATIO_BACK_BUFFER) {
            target_ratio = back_buffer_desc.texture.width / back_buffer_desc.texture.height;
          } else {
            target_ratio = this->aspect_ratio;
          }
          static const float tolerance = 0.0001f;
          const float diff = std::abs(view_ratio - target_ratio);
          if (diff > tolerance) return false;
        }
      }
    }
    return true;
  }

  float resource_tag = -1;

  uint32_t counted = 0;
  bool completed = false;
};

static bool use_shared_device = false;
static bool use_resource_cloning = false;
static bool use_resource_fallbacks = false;
static bool use_resize_buffer = false;
static bool use_resize_buffer_on_set_full_screen = false;
static bool use_resize_buffer_on_demand = false;
static bool use_resize_buffer_on_present = false;
static bool upgrade_unknown_resource_views = false;
static bool upgrade_resource_views = true;
static bool prevent_full_screen = true;
static bool force_borderless = true;

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
  reshade::api::resource original_resource;
  reshade::api::resource_view original_resource_view;

  SwapChainUpgradeTarget* applied_target = nullptr;
  bool upgraded_resource_needs_view_clone = false;
  bool upgraded_resource_view = false;
  bool resource_upgrade_finished = false;
  bool prevent_full_screen = false;

  // <originalResource.handle, SwapChainUpgradeTarget>
  std::unordered_map<uint64_t, SwapChainUpgradeTarget*> resource_upgrade_targets;

  std::unordered_map<uint64_t, reshade::api::resource> upgraded_resources;
  // <originalResource.handle, clonedResource.handle>
  std::unordered_map<uint64_t, uint64_t> cloned_resources;
  // <clonedResource.handle>
  std::unordered_set<uint64_t> permanent_cloned_resources;
  std::unordered_set<uint64_t> enabled_cloned_resources;
  std::unordered_map<uint64_t, reshade::api::resource_view> upgraded_resource_views;

  // <originalResourceView.handle>
  std::unordered_set<uint64_t> resource_views_cloned;

  // <OriginalResourceView.handle, CloneResourceView.handle>
  std::unordered_map<uint64_t, uint64_t> render_target_resource_view_clones;
  // <OriginalResourceView.handle, CloneResourceView.handle>
  std::unordered_map<uint64_t, uint64_t> uav_resource_view_clones;
  // <OriginalResourceView.handle, CloneResourceView.handle>
  std::unordered_map<uint64_t, uint64_t> shader_resource_view_clones;

  // <resource.handle, CloneResourceView.handle>
  std::unordered_map<uint64_t, uint64_t> resource_render_target_resource_clones;
  // <resource.handle, CloneResourceView.handle>
  std::unordered_map<uint64_t, uint64_t> resource_ua_vs;
  // <resource.handle, CloneResourceView.handle>
  std::unordered_map<uint64_t, uint64_t> resource_uav_clones;
  // <resource.handle, CloneResourceView.handle>
  std::unordered_map<uint64_t, uint64_t> resource_sr_vs;
  // <resource.handle, CloneResourceView.handle>
  std::unordered_map<uint64_t, uint64_t> resource_srv_clones;

  std::unordered_set<uint64_t> resources_that_need_resource_view_clones;

  // <resource.handle, resourceClone.handle>
  std::unordered_map<uint64_t, uint64_t> resource_clones;
  std::unordered_map<uint64_t, uint32_t> pipeline_to_shader_hash_map;
  std::shared_mutex mutex;
  std::unordered_map<uint64_t, reshade::api::resource> rebuilt_buffers;

  // <descriptor_table.handle[index], <clone_resource_view.handle>>
  std::unordered_map<std::pair<uint64_t, uint32_t>, uint64_t, utils::hash::HashPair> table_descriptor_resource_view_replacements;

  // <descriptor_heap.handle, std::map<base_offset, descriptor_table>>
  std::unordered_map<uint64_t, std::unordered_map<uint32_t, HeapDescriptorInfo*>> heap_descriptor_infos;

  std::unordered_map<uint64_t, uint64_t> descriptor_table_clones;
  std::unordered_set<uint64_t> active_descriptor_table_clones;
};

struct __declspec(uuid("0a2b51ad-ef13-4010-81a4-37a4a0f857a6")) CommandListData {
  std::vector<BoundDescriptorInfo> unbound_descriptors;
  std::vector<PushDescriptorInfo> unpushed_updates;
};

static std::vector<SwapChainUpgradeTarget> swap_chain_upgrade_targets = {};

static reshade::api::format target_format = reshade::api::format::r16g16b16a16_float;
static reshade::api::color_space target_color_space = reshade::api::color_space::extended_srgb_linear;

static void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::swapchain::OnInitDevice(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  auto& data = device->create_private_data<DeviceData>();
  data.prevent_full_screen = prevent_full_screen;
}

static void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::swapchain::OnDestroyDevice(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<CommandListData>();
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

// Clones resource and schedules render target assignments
// Will also fix descriptor tables that are using
static reshade::api::resource CloneResource(
    reshade::api::device* device,
    DeviceData* private_data,
    const reshade::api::resource_desc& new_desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  reshade::api::resource clone_resource = {0};

  device->create_resource(
      new_desc,
      nullptr,
      initial_state,
      &clone_resource);
  private_data->cloned_resources[resource.handle] = clone_resource.handle;
  private_data->resources_that_need_resource_view_clones.insert(resource.handle);
  return clone_resource;
}

// Before CreatePipelineState
static bool OnCreateSwapchain(reshade::api::swapchain_desc& desc, void* hwnd) {
  auto old_format = desc.back_buffer.texture.format;
  auto old_present_mode = desc.present_mode;
  auto old_present_flags = desc.present_flags;
  auto old_buffer_count = desc.back_buffer_count;

  if (!use_resize_buffer) {
    desc.back_buffer.texture.format = target_format;

    if (desc.back_buffer_count == 1) {
      // 0 is only for resize, so if game uses more than 2 buffers, that will be retained
      desc.back_buffer_count = 2;
    }
  }

  switch (desc.present_mode) {
    case static_cast<uint32_t>(DXGI_SWAP_EFFECT_SEQUENTIAL):
      desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL);
      break;
    case static_cast<uint32_t>(DXGI_SWAP_EFFECT_DISCARD):
      desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD);
      break;
  }

  if (!use_resize_buffer) {
    if (prevent_full_screen) {
      desc.present_flags &= ~DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;
    }
    desc.present_flags |= DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;
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
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  return (old_format != desc.back_buffer.texture.format)
         || (old_present_mode != desc.present_mode)
         || (old_present_flags != desc.present_flags);
}

static void CheckSwapchainSize(
    reshade::api::swapchain* swapchain,
    reshade::api::resource_desc buffer_desc) {
  if (!prevent_full_screen && !force_borderless) return;
  HWND output_window = static_cast<HWND>(swapchain->get_hwnd());
  if (output_window == nullptr) {
    reshade::log_message(reshade::log_level::debug, "No HWND?");
    return;
  }

  auto* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

  if (prevent_full_screen) {
    IDXGIFactory* factory;
    if (SUCCEEDED(native_swapchain->GetParent(IID_PPV_ARGS(&factory)))) {
      factory->MakeWindowAssociation(output_window, DXGI_MWA_NO_WINDOW_CHANGES);
      reshade::log_message(reshade::log_level::debug, "checkSwapchainSize(set DXGI_MWA_NO_WINDOW_CHANGES)");
      factory->Release();
      factory = nullptr;
    } else {
      reshade::log_message(reshade::log_level::error, "checkSwapchainSize(could not find DXGI factory)");
    }
  }

  if (force_borderless) {
    RECT window_rect = {};
    GetClientRect(output_window, &window_rect);

    const int screen_width = GetSystemMetrics(SM_CXSCREEN);
    const int screen_height = GetSystemMetrics(SM_CYSCREEN);
    const int window_width = window_rect.right - window_rect.left;
    const int window_height = window_rect.bottom - window_rect.top;

    std::stringstream s;
    s << "mods::swapchain::CheckSwapchainSize(";
    s << "screenWidth: " << screen_width;
    s << ", screenHeight: " << screen_height;
    s << ", bufferWidth: " << buffer_desc.texture.width;
    s << ", bufferHeight: " << buffer_desc.texture.height;
    s << ", windowWidth: " << window_width;
    s << ", windowHeight: " << window_height;
    s << ", windowTop: " << window_rect.top;
    s << ", windowLeft: " << window_rect.left;
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());

    if (screen_width != buffer_desc.texture.width) return;
    if (screen_height != buffer_desc.texture.height) return;
    // if (window_rect.top == 0 && window_rect.left == 0) return;
    SetWindowLongPtr(output_window, GWL_STYLE, WS_VISIBLE | WS_POPUP);
    SetWindowPos(output_window, HWND_TOP, 0, 0, screen_width, screen_height, SWP_FRAMECHANGED);
  }
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

static void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  auto* device = swapchain->get_device();
  if (device == nullptr) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  reshade::log_message(reshade::log_level::debug, "initSwapChain(reset resource upgrade)");
  data.resource_upgrade_finished = false;
  const uint32_t len = swap_chain_upgrade_targets.size();
  // Reset
  for (uint32_t i = 0; i < len; i++) {
    renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
    if (target->ignore_reset) continue;
    target->counted = 0;
    target->completed = false;
  }

  auto device_back_buffer_desc = renodx::utils::swapchain::GetBackBufferDesc(device);
  CheckSwapchainSize(swapchain, device_back_buffer_desc);

  if (use_resize_buffer && device_back_buffer_desc.texture.format != target_format) {
    if (use_resize_buffer_on_demand || use_resize_buffer_on_present) {
      reshade::register_event<reshade::addon_event::present>(OnPresentForResizeBuffer);
    } else if (!use_resize_buffer_on_set_full_screen) {
      renodx::utils::swapchain::ResizeBuffer(swapchain, target_format, target_color_space);
    }
    return;
  }
  renodx::utils::swapchain::ChangeColorSpace(swapchain, target_color_space);
}

static bool OnCreateResource(
    reshade::api::device* device,
    reshade::api::resource_desc& desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state) {
  if (device == nullptr) {
    std::stringstream s;
    s << "mods::swapchain::OnCreateResource(Empty device)";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
    return false;
  }
  switch (desc.type) {
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      break;
    case reshade::api::resource_type::unknown:
      reshade::log_message(reshade::log_level::warning, "Unknown resource type");
    default:
      return false;
  }

  auto& private_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(private_data.mutex);
  if (private_data.resource_upgrade_finished) return false;

  auto device_back_buffer_desc = renodx::utils::swapchain::GetBackBufferDesc(device);
  if (device_back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnCreateResource(Unknown device ";
    s << reinterpret_cast<void*>(device);
    s << ")";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
    return false;
  }

  const uint32_t len = swap_chain_upgrade_targets.size();

  const float resource_tag = -1;

  SwapChainUpgradeTarget* found_target = nullptr;
  bool all_completed = true;
  bool found_exact = false;
  for (uint32_t i = 0; i < len; i++) {
    renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
    std::stringstream s;
    if (target->completed) continue;
    if (
        !target->use_resource_view_cloning
        && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
      s << "mods::swapchain::OnCreateResource(counting target";
      s << ", format: " << target->old_format;
      s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
      s << ", index: " << target->index;
      s << ", counted: " << target->counted;
      // s << ", data: " << reinterpret_cast<void*>(initial_data);
      s << ") [" << i << "/" << len << "]";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());

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
    private_data.resource_upgrade_finished = true;
  }

  std::stringstream s;
  s << "mods::swapchain::OnCreateResource(upgrading";
  s << ", flags: 0x" << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", state: 0x" << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
  s << ", format: " << desc.texture.format << " => " << found_target->new_format;
  s << ", width: " << desc.texture.width;
  s << ", height: " << desc.texture.height;
  s << ", usage: " << desc.usage << "(" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec << ")";
  s << ", complete: " << all_completed;
  reshade::api::resource original_resource = {0};
  if (use_resource_fallbacks) {
    device->create_resource(
        desc,
        initial_data,
        initial_state,
        &original_resource);
    s << ", fallback: " << reinterpret_cast<void*>(original_resource.handle);
  }

  s << ")";
  reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
          ? reshade::log_level::warning
          : reshade::log_level::info,
      s.str().c_str());

  desc.texture.format = found_target->new_format;

  if (found_target->new_dimensions.first != 0u) {
    desc.texture.width = found_target->new_dimensions.first;
  }
  if (found_target->new_dimensions.second != 0u) {
    desc.texture.height = found_target->new_dimensions.second;
  }

  desc.usage = static_cast<reshade::api::resource_usage>(static_cast<uint32_t>(desc.usage) | found_target->usage_set & ~found_target->usage_unset);

  private_data.original_resource = original_resource;
  private_data.applied_target = found_target;
  return true;
}

static void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (device == nullptr) {
    std::stringstream s;
    s << "mods::swapchain::OnInitResource(Empty device)";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
    return;
  }

  auto& private_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(private_data.mutex);

  switch (desc.type) {
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      break;
    case reshade::api::resource_type::unknown:
      reshade::log_message(reshade::log_level::warning, "Unknown resource type");
    default:
      if (private_data.applied_target != nullptr) {
        reshade::log_message(reshade::log_level::warning, "Modified??");
        private_data.applied_target = nullptr;
      }
      return;
  }

  std::stringstream s;
  s << "mods::swapchain::OnInitResource(tracking ";
  s << reinterpret_cast<void*>(resource.handle);
  s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", state: " << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
  s << ", width: " << desc.texture.width;
  s << ", height: " << desc.texture.height;
  s << ", format: " << desc.texture.format;
  if (private_data.applied_target != nullptr) {
    if (private_data.applied_target->resource_tag != -1) {
      renodx::utils::resource::SetResourceTag(device, resource, private_data.applied_target->resource_tag);
    }
    private_data.resource_upgrade_targets[resource.handle] = private_data.applied_target;
    private_data.applied_target = nullptr;

    private_data.upgraded_resources[resource.handle] = private_data.original_resource;
    if (private_data.original_resource.handle != 0u) {
      s << ", fallback: " << reinterpret_cast<void*>(private_data.original_resource.handle);
      private_data.original_resource = {0};
    } else {
      s << ", fallback: (none)";
    }
  } else if (use_resource_cloning) {
    if (private_data.resource_upgrade_finished) return;
    auto device_back_buffer_desc = renodx::utils::swapchain::GetBackBufferDesc(device);
    if (device_back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::OnInitResource(Unknown device ";
      s << reinterpret_cast<void*>(device);
      s << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
      return;
    }

    const uint32_t len = swap_chain_upgrade_targets.size();

    renodx::mods::swapchain::SwapChainUpgradeTarget* found_target = nullptr;
    bool all_completed = true;
    bool found_exact = false;
    for (uint32_t i = 0; i < len; i++) {
      renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
      std::stringstream s;
      if (target->completed) continue;
      if (
          target->use_resource_view_cloning
          && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
        s << "mods::swapchain::OnInitResource(counting target";
        s << ", format: " << target->old_format;
        s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
        s << ", index: " << target->index;
        s << ", counted: " << target->counted;
        s << ") [" << i << "/" << len << "]";
#ifdef DEBUG_LEVEL_0
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
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
      reshade::log_message(reshade::log_level::debug, "All resource cloning completed.");
#endif
      private_data.resource_upgrade_finished = true;
    }

    reshade::api::resource_desc new_desc = desc;
    new_desc.texture.format = found_target->new_format;
    new_desc.usage = static_cast<reshade::api::resource_usage>(static_cast<uint32_t>(desc.usage) | found_target->usage_set & ~found_target->usage_unset);

    const reshade::api::resource cloned_resource = CloneResource(
        device,
        &private_data,
        new_desc,
        initial_data,
        initial_state,
        resource);
    if (found_target->resource_tag != -1) {
      renodx::utils::resource::SetResourceTag(device, resource, found_target->resource_tag);
    }
    if (!found_target->use_resource_view_hot_swap) {
      private_data.permanent_cloned_resources.insert(cloned_resource.handle);
      private_data.enabled_cloned_resources.insert(cloned_resource.handle);
    }
    private_data.resource_upgrade_targets[resource.handle] = found_target;
    s << ", newformat: " << new_desc.texture.format;
    s << ", clone: " << reinterpret_cast<void*>(cloned_resource.handle);
    s << ", hotswap: " << (found_target->use_resource_view_hot_swap ? "true" : "false");
  } else {
    // Nothing to do
    return;
  }

  s << ")";

#ifdef DEBUG_LEVEL_1
  reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
          ? reshade::log_level::warning
          : reshade::log_level::info,
      s.str().c_str());
#endif
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  renodx::utils::resource::RemoveResourceTag(device, resource);

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::OnDestroyResource(destroy resource";
    s << ", resource: " << reinterpret_cast<void*>(resource.handle);
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
  }
#endif

  data.resource_upgrade_targets.erase(resource.handle);

  if (
      auto pair = data.upgraded_resources.find(resource.handle);
      pair != data.upgraded_resources.end()) {
    device->destroy_resource(pair->second);
    data.upgraded_resources.erase(resource.handle);
  }

  if (use_resource_cloning) {
    if (
        auto pair = data.cloned_resources.find(resource.handle);
        pair != data.cloned_resources.end()) {
      auto clone_resource = reshade::api::resource{pair->second};
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::OnDestroyResource(destroy cloned resource and views";
      s << ", resource: " << reinterpret_cast<void*>(resource.handle);
      s << ", clone: " << reinterpret_cast<void*>(clone_resource.handle);
      s << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

      data.enabled_cloned_resources.erase(clone_resource.handle);
      data.permanent_cloned_resources.erase(clone_resource.handle);
      device->destroy_resource(clone_resource);
      data.cloned_resources.erase(resource.handle);
    }
  }
}

static bool OnCopyBufferToTexture(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint64_t source_offset,
    uint32_t row_length,
    uint32_t slice_height,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box) {
  auto* device = cmd_list->get_device();
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  if (
      auto pair = data.upgraded_resources.find(dest.handle);
      pair != data.upgraded_resources.end()) {
    const reshade::api::resource fallback_resource = {pair->second.handle};

    if (
        auto pair = data.rebuilt_buffers.find(source.handle);
        pair != data.rebuilt_buffers.end()) {
      const reshade::api::resource rebuilt_buffer = {pair->second};

      cmd_list->copy_buffer_to_texture(
          rebuilt_buffer,
          source_offset * 2,
          row_length,
          slice_height,
          dest,
          dest_subresource,
          dest_box);
      std::stringstream s;
      s << "mods::swapchain::OnCopyBufferToTexture(used buffer: ";
      s << reinterpret_cast<void*>(rebuilt_buffer.handle);
      s << " for ";
      s << reinterpret_cast<void*>(source.handle);
      s << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
      return true;
    }

    std::stringstream s;
    s << "mods::swapchain::OnCopyBufferToTexture(buffer not built for: ";
    s << reinterpret_cast<void*>(source.handle);
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());

    auto fallback_desc = device->get_resource_desc(fallback_resource);

    // auto buffer_desc = device->get_resource_desc(source);
    void* mapped_ptr;
    if (device->map_buffer_region(source, source_offset, ~0ull, reshade::api::map_access::read_only, &mapped_ptr)) {
      std::stringstream s;
      s << "mods::swapchain::OnCopyBufferToTexture(got data)";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());

      reshade::api::subresource_data old_resource_data;

      old_resource_data.data = mapped_ptr;

      auto* data_p = static_cast<uint8_t*>(old_resource_data.data);
      // Add sufficient padding for block compressed textures that are not a multiple of 4 in all dimensions
      std::vector<uint16_t> rgba16_pixel_data(fallback_desc.texture.height * fallback_desc.texture.width * 4);

      {
        std::stringstream s;
        s << "mods::swapchain::OnCopyBufferToTexture(will build ";
        s << rgba16_pixel_data.size();
        s << ", row pitch: " << old_resource_data.row_pitch;
        s << ", slice_path: " << old_resource_data.slice_pitch;
        s << ", height: " << fallback_desc.texture.height;
        s << ", width: " << fallback_desc.texture.width;
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

      for (size_t y = 0; y < fallback_desc.texture.height; ++y, data_p += old_resource_data.row_pitch) {
        for (size_t x = 0; x < fallback_desc.texture.width; ++x) {
          const uint8_t* const src = data_p + x * 4;
          uint16_t* const dst = rgba16_pixel_data.data() + ((y * fallback_desc.texture.width + x) * 4);

          dst[0] = Float2Half(src[0] / 255.0f);
          dst[1] = Float2Half(src[1] / 255.0f);
          dst[2] = Float2Half(src[2] / 255.0f);
          dst[3] = Float2Half(src[3] / 255.0f);
        }
      }

      {
        std::stringstream s;
        s << "mods::swapchain::OnCopyBufferToTexture(will unmap)";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }
      device->unmap_buffer_region(source);

      // Create new buffer
      reshade::api::resource_desc new_buffer_desc;
      new_buffer_desc.type = reshade::api::resource_type::buffer;
      new_buffer_desc.buffer.size = rgba16_pixel_data.size() * sizeof(uint16_t);
      reshade::api::resource new_resource;
      reshade::api::subresource_data new_data;
      new_data.data = rgba16_pixel_data.data();
      new_data.row_pitch = fallback_desc.texture.width;
      new_data.slice_pitch = new_data.row_pitch * fallback_desc.texture.height;

      {
        std::stringstream s;
        s << "mods::swapchain::OnCopyBufferToTexture(will create new texture: ";
        s << new_buffer_desc.buffer.size;
        s << " from ";
        s << reinterpret_cast<void*>(rgba16_pixel_data.data());
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

      if (device->create_resource(
              new_buffer_desc,
              &new_data,
              reshade::api::resource_usage::general,
              &new_resource)) {
        data.rebuilt_buffers[source.handle] = new_resource;
        std::stringstream s;
        s << "mods::swapchain::OnCopyBufferToTexture(made new resource: ";
        s << reinterpret_cast<void*>(new_resource.handle);
        s << " for ";
        s << reinterpret_cast<void*>(source.handle);
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
        cmd_list->copy_buffer_to_texture(
            new_resource,
            source_offset * 2,
            row_length,
            slice_height,
            dest,
            dest_subresource,
            dest_box);

      } else {
        reshade::log_message(reshade::log_level::error, "mods::swapchain::OnCopyBufferToTexture(failed to make)");
      }

    } else {
      std::stringstream s;
      s << "mods::swapchain::OnCopyBufferToTexture(no got data)";
      reshade::log_message(reshade::log_level::error, s.str().c_str());
    }
    {
      std::stringstream s;
      s << "mods::swapchain::OnCopyBufferToTexture(done)";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
    return true;
  }

  return false;
}

static bool OnCreateResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc& desc) {
  if (resource.handle == 0u) return false;
  bool expected = false;

  auto& private_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(private_data.mutex);

  if (!upgrade_unknown_resource_views && desc.format == reshade::api::format::unknown) {
    return false;
  }
  reshade::api::resource_view_desc new_desc = desc;
  const reshade::api::resource_desc resource_desc = device->get_resource_desc(resource);
  if (upgrade_resource_views && renodx::utils::swapchain::IsBackBuffer(device, resource)) {
    if (resource_desc.texture.format != reshade::api::format::r32_typeless) {
      new_desc.format = target_format;
      expected = true;
    }
  } else if (auto pair = private_data.resource_upgrade_targets.find(resource.handle);
             pair != private_data.resource_upgrade_targets.end()) {
    auto* target = pair->second;
    bool found_upgrade = false;
    if (auto pair2 = target->view_upgrades.find({usage_type, desc.format});
        pair2 != target->view_upgrades.end()) {
      new_desc.format = pair2->second;
      found_upgrade = true;
    }
    if (!found_upgrade) {
      switch (desc.format) {
        case reshade::api::format::r8g8b8a8_typeless:
        case reshade::api::format::b8g8r8a8_typeless:
        case reshade::api::format::r10g10b10a2_typeless:
          new_desc.format = reshade::api::format::r16g16b16a16_typeless;
          break;
        case reshade::api::format::r8g8b8a8_unorm:
        case reshade::api::format::b8g8r8a8_unorm:
        case reshade::api::format::r8g8b8a8_snorm:
          // Should upgrade shader
          new_desc.format = target_format;
          break;
        case reshade::api::format::r8g8b8a8_unorm_srgb:
        case reshade::api::format::b8g8r8a8_unorm_srgb:
          new_desc.format = target_format;
          break;
        case reshade::api::format::b10g10r10a2_unorm:
        case reshade::api::format::r10g10b10a2_unorm:
          // Should upgrade shader
          new_desc.format = target_format;
          break;
        default: {
          std::stringstream s;
          s << "mods::swapchain::OnCreateResourceView(";
          s << "unexpected case(" << desc.format << ")";
          s << ")";
          reshade::log_message(reshade::log_level::warning, s.str().c_str());
          break;
        }
      }
    }
    expected = true;
  } else if (resource_desc.texture.format == target_format || resource_desc.texture.format == reshade::api::format::r16g16b16a16_typeless) {
    switch (new_desc.format) {
      case reshade::api::format::r8g8b8a8_typeless:
      case reshade::api::format::b8g8r8a8_typeless:
      case reshade::api::format::r10g10b10a2_typeless:
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
      default: {
        std::stringstream s;
        s << "mods::swapchain::OnCreateResourceView(";
        s << "unexpected case(" << desc.format << ")";
        s << ")";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        break;
      }
    }
  } else {
    return false;
  }

  const bool changed = (desc.format != new_desc.format);
  std::stringstream s;
  s << "mods::swapchain::OnCreateResourceView(" << (changed ? "upgrading" : "logging");
  s << ", expected: " << (expected ? "true" : "false");
  s << ", view type: " << desc.type;
  s << ", view format: " << desc.format << " => " << new_desc.format;
  s << ", resource: " << reinterpret_cast<void*>(resource.handle);
  s << ", resource width: " << resource_desc.texture.width;
  s << ", resource height: " << resource_desc.texture.height;
  s << ", resource format: " << resource_desc.texture.format;
  s << ", resource usage: " << usage_type;
  s << ")";

  if (!changed) {
#ifdef DEBUG_LEVEL_1
    reshade::log_message(
        desc.format == reshade::api::format::unknown
            ? reshade::log_level::warning
            : reshade::log_level::info,
        s.str().c_str());
#endif
    return false;
  }
  if (use_resource_fallbacks) {
    reshade::api::resource_view original_resource_view = {0};
    reshade::api::resource original_resource = resource;
    {
      if (
          auto pair = private_data.upgraded_resources.find(resource.handle);
          pair != private_data.upgraded_resources.end()) {
        original_resource = pair->second;
        device->create_resource_view(
            original_resource,
            usage_type,
            desc,
            &original_resource_view);
        private_data.original_resource_view = original_resource_view;
      } else {
        private_data.original_resource_view = {};
      }
    }
  } else if (
      use_resource_cloning
      && private_data.resources_that_need_resource_view_clones.contains(resource.handle)) {
    // Upgrade on init instead (allows resource view handle reuse)
    return false;
  }

  reshade::log_message(
      desc.format == reshade::api::format::unknown
          ? reshade::log_level::warning
          : reshade::log_level::info,
      s.str().c_str());
  desc.format = new_desc.format;
  private_data.upgraded_resource_view = true;
  return true;
}

static void ReleaseResourceView(
    reshade::api::device* device,
    DeviceData& data,  // mutex locked
    reshade::api::resource_view view) {
  if (
      auto pair = data.upgraded_resource_views.find(view.handle);
      pair != data.upgraded_resource_views.end()) {
    device->destroy_resource_view(pair->second);
    data.upgraded_resource_views.erase(view.handle);
  }

  if (data.resource_views_cloned.contains(view.handle)) {
    if (
        auto pair = data.uav_resource_view_clones.find(view.handle);
        pair != data.uav_resource_view_clones.end()) {
      device->destroy_resource_view(reshade::api::resource_view{pair->second});
      data.uav_resource_view_clones.erase(view.handle);
    }

    if (
        auto pair = data.shader_resource_view_clones.find(view.handle);
        pair != data.shader_resource_view_clones.end()) {
      device->destroy_resource_view(reshade::api::resource_view{pair->second});
      data.shader_resource_view_clones.erase(view.handle);
    }

    if (
        auto pair = data.render_target_resource_view_clones.find(view.handle);
        pair != data.render_target_resource_view_clones.end()) {
      device->destroy_resource_view(reshade::api::resource_view{pair->second});
      data.render_target_resource_view_clones.erase(view.handle);
    }
    data.resource_views_cloned.erase(view.handle);
  }
}

static void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  if (resource.handle == 0u) return;
#ifdef DEBUG_LEVEL_2
  reshade::log_message(reshade::log_level::debug, "mods::swapchain::OnInitResourceView()");
#endif
  auto& private_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(private_data.mutex);

  ReleaseResourceView(device, private_data, view);
  if (
      use_resource_cloning
      && private_data.resources_that_need_resource_view_clones.contains(resource.handle)
      && private_data.cloned_resources.contains(resource.handle)) {
    reshade::api::resource_view_desc new_desc = desc;
    switch (desc.format) {
      case reshade::api::format::r8g8b8a8_typeless:
      case reshade::api::format::b8g8r8a8_typeless:
      case reshade::api::format::r10g10b10a2_typeless:
        new_desc.format = reshade::api::format::r16g16b16a16_typeless;
        break;
      case reshade::api::format::r8g8b8a8_unorm:
      case reshade::api::format::b8g8r8a8_unorm:
      case reshade::api::format::r8g8b8a8_snorm:
        // Should upgrade shader
        new_desc.format = target_format;
        break;
      case reshade::api::format::r8g8b8a8_unorm_srgb:
      case reshade::api::format::b8g8r8a8_unorm_srgb:
        new_desc.format = target_format;
        break;
      case reshade::api::format::b10g10r10a2_unorm:
      case reshade::api::format::r10g10b10a2_unorm:
        // Should upgrade shader
        new_desc.format = target_format;
        break;
      default:
        break;
    }

    reshade::api::resource_view cloned_resource_view = {0};
    reshade::api::resource cloned_resource_view_resource = resource;

    if (
        auto pair = private_data.cloned_resources.find(resource.handle);
        pair != private_data.cloned_resources.end()) {
      cloned_resource_view_resource = {pair->second};
    }

    device->create_resource_view(
        cloned_resource_view_resource,
        usage_type,
        new_desc,
        &cloned_resource_view);
    std::stringstream s;
    s << "mods::swapchain::OnInitResourceView(made clone: ";
    s << reinterpret_cast<void*>(view.handle);
    s << " => ";
    s << reinterpret_cast<void*>(cloned_resource_view.handle);
    s << ", resource: " << reinterpret_cast<void*>(resource.handle);
    if (cloned_resource_view_resource.handle != resource.handle) {
      s << " => " << reinterpret_cast<void*>(cloned_resource_view_resource.handle);
    }

    private_data.resource_views_cloned.insert(view.handle);

    if (usage_type == reshade::api::resource_usage::render_target) {
      private_data.render_target_resource_view_clones[view.handle] = cloned_resource_view.handle;
      private_data.resource_render_target_resource_clones[resource.handle] = cloned_resource_view.handle;
      s << ", type: render_target";
    }
    if (usage_type == reshade::api::resource_usage::unordered_access) {
      private_data.uav_resource_view_clones[view.handle] = cloned_resource_view.handle;
      private_data.resource_uav_clones[resource.handle] = cloned_resource_view.handle;
      private_data.resource_ua_vs[resource.handle] = view.handle;
      s << ", type: uav";
    }

    if (usage_type == reshade::api::resource_usage::shader_resource) {
      private_data.shader_resource_view_clones[view.handle] = cloned_resource_view.handle;
      private_data.resource_srv_clones[resource.handle] = cloned_resource_view.handle;
      private_data.resource_sr_vs[resource.handle] = view.handle;
      s << ", type: shader_resource";
    }
    renodx::utils::resource::SetResourceFromResourceView(device, cloned_resource_view, cloned_resource_view_resource);

    s << ")";
#ifdef DEBUG_LEVEL_1
    reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
  } else {
    if (use_resource_cloning) {
      const bool was_cloned = private_data.resource_views_cloned.contains(resource.handle);
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::OnInitResourceView(unused view ";
      s << reinterpret_cast<void*>(view.handle);
      s << ", resource: " << reinterpret_cast<void*>(resource.handle);
      s << ", was cloned: " << (was_cloned ? "true" : "false");
      s << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
      if (was_cloned) {
        private_data.resource_views_cloned.erase(resource.handle);

        // TODO(clshortfuse): Clean up all other descriptors
      }
      // Clean incorrect resource view?
    }
  }

  if (private_data.upgraded_resource_view) {
    private_data.upgraded_resource_view = false;
    if (private_data.original_resource_view.handle != 0u) {
      private_data.upgraded_resource_views[view.handle] = private_data.original_resource_view;
      private_data.original_resource_view = {0};
    }
  }
#ifdef DEBUG_LEVEL_2
  reshade::log_message(reshade::log_level::debug, "init_resource_view(done)");
#endif
}

static void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  ReleaseResourceView(device, data, view);
}

static reshade::api::resource_view FindReplacementResourceView(
    DeviceData& data,
    reshade::api::resource_view resource_view,
    reshade::api::resource_usage usage) {
#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::swapchain::FindReplacementResourceView(looking for : ";
  s << reinterpret_cast<void*>(resource_view.handle);
  s << ", usage: " << usage;
  s << ")";
  reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

  std::unordered_map<uint64_t, uint64_t>* view_clones_map;
  switch (usage) {
    case reshade::api::resource_usage::shader_resource:
      view_clones_map = &data.shader_resource_view_clones;
      break;
    case reshade::api::resource_usage::unordered_access:
      view_clones_map = &data.uav_resource_view_clones;
      break;
    case reshade::api::resource_usage::render_target:
      view_clones_map = &data.render_target_resource_view_clones;
      break;
    default:
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::FindReplacementResourceView(unknown usage: ";
      s << reinterpret_cast<void*>(resource_view.handle);
      s << ", usage: " << usage;
      s << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      return resource_view;
  }

  auto pair2 = view_clones_map->find(resource_view.handle);
  if (pair2 != view_clones_map->end()) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::FindReplacementResourceView(found: ";
    s << "rsv: " << reinterpret_cast<void*>(resource_view.handle);
    s << " => ";
    s << "res: " << reinterpret_cast<void*>(pair2->second);
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    return reshade::api::resource_view{pair2->second};
  }
#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::FindReplacementResourceView(no clone exists: ";
    s << "rsv: " << reinterpret_cast<void*>(resource_view.handle);
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
  }
#endif
  return resource_view;
}

static bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  if (renodx::utils::swapchain::IsBackBuffer(cmd_list, source)) return true;
  if (renodx::utils::swapchain::IsBackBuffer(cmd_list, dest)) return true;
  return false;
}

static reshade::api::descriptor_table_update CloneDescriptorUpdateWithResourceView(
    const reshade::api::descriptor_table_update update,
    reshade::api::resource_view view,
    uint32_t index = 0) {
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
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::shader_resource_view:

    case reshade::api::descriptor_type::unordered_access_view: {
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

static reshade::api::resource_view FindReplacementResourceView(
    DeviceData& data,
    reshade::api::resource_view resource_view,
    reshade::api::descriptor_type type) {
  switch (type) {
    case reshade::api::descriptor_type::sampler_with_resource_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::shader_resource_view:
      return FindReplacementResourceView(data, resource_view, reshade::api::resource_usage::shader_resource);
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::unordered_access_view:
      return FindReplacementResourceView(data, resource_view, reshade::api::resource_usage::unordered_access);
    default:
      return FindReplacementResourceView(data, resource_view, reshade::api::resource_usage::undefined);
  }
}

static bool LogDescriptorTableReplacement(
    DeviceData& data,  // Should be mutex locked
    const reshade::api::descriptor_table table,
    const uint32_t index,
    const reshade::api::resource_view view = {0}) {
#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::LogDescriptorTableReplacement(";
    s << reinterpret_cast<void*>(table.handle);
    s << "[" << index << "]";
    s << ", view " << reinterpret_cast<void*>(view.handle);
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
  auto old_size = data.table_descriptor_resource_view_replacements.size();
#endif

  auto primary_key = std::pair<uint64_t, uint32_t>(table.handle, index);
  if (view.handle != 0u) {
    data.table_descriptor_resource_view_replacements[primary_key] = view.handle;
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "mods::swapchain::LogDescriptorTableReplacement(insert ";
      s << reinterpret_cast<void*>(table.handle);
      s << "[" << index << "]";
      s << ", view " << reinterpret_cast<void*>(view.handle);
      s << ", size " << old_size << " => " << data.table_descriptor_resource_view_replacements.size();
      s << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
    for (auto pair : data.table_descriptor_resource_view_replacements) {
      auto key = pair.first;
      {
        std::stringstream s;
        s << "mods::swapchain::LogDescriptorTableReplacement(list ";
        s << reinterpret_cast<void*>(key.first);
        s << "[" << key.second << "]";
        s << ", view " << reinterpret_cast<void*>(pair.second);
        s << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
    }
#endif

    return true;
  }

  data.table_descriptor_resource_view_replacements.erase(primary_key);
#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::LogDescriptorTableReplacement(remove ";
    s << reinterpret_cast<void*>(table.handle);
    s << "[" << index << "]";
    s << ", view " << reinterpret_cast<void*>(view.handle);
    s << ", size " << old_size << " => " << data.table_descriptor_resource_view_replacements.size();
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
#endif
  return false;
}

static bool FlushResourceViewInDescriptorTable(
    reshade::api::device* device,
    reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  // std::shared_lock lock(data.mutex);

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::FlushResourceViewInDescriptorTable(resource: ";
    s << reinterpret_cast<void*>(resource.handle);
    s << ", device: " << reinterpret_cast<void*>(device);
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
  }
#endif

  if (auto uav_clone_handles = data.resource_uav_clones.find(resource.handle);
      uav_clone_handles != data.resource_uav_clones.end()) {
    auto uav_clone_handle = uav_clone_handles->second;
    if (
        auto uav_handles = data.resource_ua_vs.find(resource.handle);
        uav_handles != data.resource_ua_vs.end()) {
      auto uav_handle = uav_handles->second;
      auto& descriptor_table_data = device->get_private_data<renodx::utils::descriptor::DeviceData>();
      const std::unique_lock lock(descriptor_table_data.mutex);
      if (
          auto locations = descriptor_table_data.resource_view_table_description_locations.find(uav_handle);
          locations != descriptor_table_data.resource_view_table_description_locations.end()) {
        auto set = *locations->second;
        for (auto primary_key : set) {
          bool replace = false;
          if (
              auto replacements = data.table_descriptor_resource_view_replacements.find(primary_key);
              replacements != data.table_descriptor_resource_view_replacements.end()) {
            replace = replacements->second != uav_clone_handle;  // Wrong clone
          } else {
            replace = true;
          }

          if (replace) {
            if (auto update_pair = descriptor_table_data.table_descriptor_resource_views.find(primary_key);
                update_pair != descriptor_table_data.table_descriptor_resource_views.end()) {
              auto update = update_pair->second;
              auto new_view = reshade::api::resource_view{uav_clone_handle};
              auto new_update = CloneDescriptorUpdateWithResourceView(update, new_view);
              device->update_descriptors(new_update);
              LogDescriptorTableReplacement(data, new_update.table, new_update.binding, new_view);
            }
          }
        }
      }
    }
  }

  if (auto srv_clone_handles = data.resource_srv_clones.find(resource.handle);
      srv_clone_handles != data.resource_srv_clones.end()) {
    auto srv_clone_handle = srv_clone_handles->second;
    if (
        auto srv_handles = data.resource_sr_vs.find(resource.handle);
        srv_handles != data.resource_sr_vs.end()) {
      auto srv_handle = srv_handles->second;
      auto& descriptor_table_data = device->get_private_data<renodx::utils::descriptor::DeviceData>();
      const std::unique_lock lock(descriptor_table_data.mutex);
      if (
          auto locations = descriptor_table_data.resource_view_table_description_locations.find(srv_handle);
          locations != descriptor_table_data.resource_view_table_description_locations.end()) {
        auto set = *locations->second;
        for (auto primary_key : set) {
          bool replace = false;
          if (
              auto replacements = data.table_descriptor_resource_view_replacements.find(primary_key);
              replacements != data.table_descriptor_resource_view_replacements.end()) {
            replace = replacements->second != srv_clone_handle;  // Wrong clone
          } else {
            replace = true;
          }

          if (replace) {
            if (auto update_pair = descriptor_table_data.table_descriptor_resource_views.find(primary_key);
                update_pair != descriptor_table_data.table_descriptor_resource_views.end()) {
              auto update = update_pair->second;
              auto new_view = reshade::api::resource_view{srv_clone_handle};
              auto new_update = CloneDescriptorUpdateWithResourceView(update, new_view);
              device->update_descriptors(new_update);
              LogDescriptorTableReplacement(data, new_update.table, new_update.binding, new_view);
            }
          }
        }
      }
    }
  }

  return true;
}

static void OnPresentForDescriptorReset(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  reshade::unregister_event<reshade::addon_event::present>(OnPresentForDescriptorReset);
  auto* device = swapchain->get_device();
  if (device == nullptr) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  if (data.enabled_cloned_resources.empty()) return;
#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::swapchain::OnPresentForDescriptorReset(reset on present";
  s << ", count: ";
  s << data.table_descriptor_resource_view_replacements.size();
  s << ")";
  reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
  data.enabled_cloned_resources.clear();

  for (auto item : data.permanent_cloned_resources) {
    data.enabled_cloned_resources.insert(item);
  }
}

static bool ActivateCloneHotSwap(
    reshade::api::device* device,
    reshade::api::resource_view resource_view) {
  auto resource = renodx::utils::resource::GetResourceFromResourceView(device, resource_view);
  if (resource.handle == 0u) {
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(no handle for rsv ";
    s << reinterpret_cast<void*>(resource_view.handle);
    s << ")";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
    return false;
  }
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  reshade::api::resource clone_resource;

  auto cloned_resource_pair = data.cloned_resources.find(resource.handle);
  if (cloned_resource_pair == data.cloned_resources.end()) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(";
    if (renodx::utils::swapchain::IsBackBuffer(device, resource)) {
      s << ("backbuffer ");
    }
    s << "not cloned ";
    s << reinterpret_cast<void*>(resource.handle);
    s << ")";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
    // Resource is not a cloned resource (fail)
    return false;
  }

  clone_resource = reshade::api::resource{cloned_resource_pair->second};

  if (data.enabled_cloned_resources.contains(clone_resource.handle)) {
    // Already activated
    return false;
  }

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(activating res: ";
    s << reinterpret_cast<void*>(resource.handle);
    s << " => clone: ";
    s << reinterpret_cast<void*>(clone_resource.handle);
    s << ")";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
  }
  if (!data.resource_srv_clones.contains(resource.handle)) {
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(no srv, res: ";
    s << reinterpret_cast<void*>(resource.handle);
    s << " => clone: ";
    s << reinterpret_cast<void*>(clone_resource.handle);
    s << ")";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
  }

  if (!data.resource_uav_clones.contains(resource.handle)) {
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(no uav, res: ";
    s << reinterpret_cast<void*>(resource.handle);
    s << " => clone: ";
    s << reinterpret_cast<void*>(clone_resource.handle);
    s << ")";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
  }
#endif

  // data.pendingResourceViewUpdateFlush.insert(resource.handle);
  // flushResourceViewInDescriptorTable(device, resource);

#ifdef DEBUG_LEVEL_1

#endif

  // reshade::register_event<reshade::addon_event::present>(on_present_for_descriptor_reset);
  data.enabled_cloned_resources.insert(clone_resource.handle);
  return true;
}

// Create DescriptorTables with RSVs
static bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (count == 0u) return false;
#ifdef DEBUG_LEVEL_2
  reshade::log_message(reshade::log_level::debug, "mods::swapchain::OnUpdateDescriptorTables()");
#endif
  reshade::api::descriptor_table_update* new_updates = nullptr;
  bool changed = false;
  bool active = false;

  for (uint32_t i = 0; i < count; i++) {
    const auto& update = updates[i];
    if (update.table.handle == 0u) continue;
    for (uint32_t j = 0; j < update.count; j++) {
      switch (update.type) {
        case reshade::api::descriptor_type::sampler_with_resource_view: {
          auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
          auto resource_view = item.view;
          auto& data = device->get_private_data<DeviceData>();
          const std::unique_lock lock(data.mutex);
          auto new_resource_view = FindReplacementResourceView(
              data,
              resource_view,
              reshade::api::resource_usage::shader_resource);
          if (new_resource_view.handle == 0) {
            std::stringstream s;
            s << "mods::swapchain::OnUpdateDescriptorTables(invalid resource view clone for : ";
            s << reinterpret_cast<void*>(resource_view.handle);
            s << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
            break;
          }
          if (resource_view.handle == new_resource_view.handle) break;

          auto new_resource = renodx::utils::resource::GetResourceFromResourceView(device, new_resource_view);
          if (new_resource.handle == 0u) break;

#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "mods::swapchain::OnUpdateDescriptorTables(found clonable: ";
          s << reinterpret_cast<void*>(new_resource_view.handle);
          s << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
          if (!changed) {
            new_updates = renodx::utils::descriptor::CloneDescriptorTableUpdates(updates, count);
          }

          // NOLINTNEXTLINE(google-readability-casting)
          ((reshade::api::sampler_with_resource_view*)(new_updates[i].descriptors))[j].view = new_resource_view;
          changed = true;
          if (data.enabled_cloned_resources.contains(new_resource.handle)) {
            active = true;
          }
          break;
        }
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::shader_resource_view:

        case reshade::api::descriptor_type::unordered_access_view: {
          auto resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          auto& data = device->get_private_data<DeviceData>();
          const std::unique_lock lock(data.mutex);
          auto new_resource_view = FindReplacementResourceView(
              data,
              resource_view,
              update.type);
          if (new_resource_view.handle == 0) {
            std::stringstream s;
            s << "mods::swapchain::OnUpdateDescriptorTables(invalid resource view clone for : ";
            s << reinterpret_cast<void*>(resource_view.handle);
            s << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
            break;
          }
          if (resource_view.handle == new_resource_view.handle) break;
          auto new_resource = renodx::utils::resource::GetResourceFromResourceView(device, new_resource_view);
          if (new_resource.handle == 0u) break;

#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "mods::swapchain::OnUpdateDescriptorTables(found clonable: ";
          s << reinterpret_cast<void*>(new_resource_view.handle);
          s << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

          if (!changed) {
            new_updates = renodx::utils::descriptor::CloneDescriptorTableUpdates(updates, count);
          }

          // NOLINTNEXTLINE(google-readability-casting)
          ((reshade::api::resource_view*)(new_updates[i].descriptors))[j] = new_resource_view;
          changed = true;
          if (data.enabled_cloned_resources.contains(new_resource.handle)) {
            active = true;
          }
          break;
        }
        default:
          break;
      }
    }
  }

  if (changed) {
    // auto original_table_handle = updates[0].table.handle;
    auto& data = device->get_private_data<DeviceData>();
    const std::unique_lock lock(data.mutex);

    uint32_t base_offset = 0;
    reshade::api::descriptor_heap heap = {0};
    device->get_descriptor_heap_offset(updates[0].table, 0, 0, &heap, &base_offset);

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnUpdateDescriptorTables(caching descriptor table: ";
    s << reinterpret_cast<void*>(updates[0].table.handle);
    s << ", count: " << count;
    s << ", active: " << (active ? "true" : "false");
    s << ", heap: " << reinterpret_cast<void*>(heap.handle);
    s << "[" << base_offset << "]";
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

    const std::vector<reshade::api::descriptor_table_update> vector(new_updates, new_updates + count);

    if (
        auto pair = data.heap_descriptor_infos.find(heap.handle);
        pair != data.heap_descriptor_infos.end()) {
      auto& map = pair->second;
      if (auto pair2 = map.find(base_offset); pair2 != map.end()) {
        map[base_offset]->updates = vector;
        map[base_offset]->replacement_descriptor_handle = 0;
        map[base_offset]->is_active = active;
      } else {
        map[base_offset] = new HeapDescriptorInfo{
            .updates = vector,
            .is_active = active,
        };
      }
    } else {
      data.heap_descriptor_infos[heap.handle] = {{
          base_offset,
          new HeapDescriptorInfo{
              .updates = vector,
              .is_active = active,
          },
      }};
    }

  } else {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnUpdateDescriptorTables(no clonable.)";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
  }
#ifdef DEBUG_LEVEL_2
  reshade::log_message(reshade::log_level::debug, "mods::swapchain::OnUpdateDescriptorTables(done)");
#endif
  return false;
}

static bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (!use_resource_cloning) return false;
#ifdef DEBUG_LEVEL_2
  reshade::log_message(reshade::log_level::debug, "mods::swapchain::OnCopyDescriptorTables()");
#endif
  for (uint32_t i = 0; i < count; i++) {
    const auto& copy = copies[i];
    for (uint32_t j = 0; j < copy.count; j++) {
      auto& data = device->get_private_data<DeviceData>();
      const std::unique_lock lock(data.mutex);

      reshade::api::descriptor_heap source_heap = {0};
      uint32_t source_base_offset = 0;
      device->get_descriptor_heap_offset(copy.source_table, copy.source_binding + j, copy.source_array_offset, &source_heap, &source_base_offset);
      reshade::api::descriptor_heap dest_heap = {0};
      uint32_t dest_base_offset = 0;
      device->get_descriptor_heap_offset(copy.dest_table, copy.dest_binding + j, copy.dest_array_offset, &dest_heap, &dest_base_offset);

      bool erase = false;
      if (auto pair = data.heap_descriptor_infos.find(source_heap.handle); pair != data.heap_descriptor_infos.end()) {
        auto& source_map = pair->second;
        if (auto pair2 = source_map.find(source_base_offset); pair2 != source_map.end()) {
          if (dest_heap.handle == source_heap.handle) {
            source_map[dest_base_offset] = source_map[source_base_offset];
          } else {
            if (auto pair3 = data.heap_descriptor_infos.find(dest_heap.handle); pair3 != data.heap_descriptor_infos.end()) {
              auto& dest_map = pair3->second;
              dest_map[dest_base_offset] = source_map[source_base_offset];
            } else {
              data.heap_descriptor_infos[dest_heap.handle] = {{
                  dest_base_offset,
                  source_map[source_base_offset],
              }};
            }
          }
#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "mods::swapchain::OnCopyDescriptorTables(cloning heap: ";
          s << reinterpret_cast<void*>(source_heap.handle);
          s << "[" << source_base_offset << "]";
          s << " => ";
          s << reinterpret_cast<void*>(dest_heap.handle);
          s << "[" << dest_base_offset << "]";
          s << ", table: " << reinterpret_cast<void*>(source_map[source_base_offset]->replacement_descriptor_handle);
          s << ", size: " << source_map[source_base_offset]->updates.size();
          s << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
        } else {
          erase = true;
        }
      } else {
        erase = true;
      }
      if (erase) {
        if (auto pair3 = data.heap_descriptor_infos.find(dest_heap.handle); pair3 != data.heap_descriptor_infos.end()) {
          auto& dest_map = pair3->second;
          dest_map.erase(dest_base_offset);
        }
      }
    }
  }

#ifdef DEBUG_LEVEL_2
  reshade::log_message(reshade::log_level::debug, "copy_descriptor_tables(done)");
#endif

  return false;
}

static void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  if (count == 0u) return;
#ifdef DEBUG_LEVEL_2
  reshade::log_message(reshade::log_level::debug, "mods::swapchain::OnBindDescriptorTables()");
#endif
  auto* device = cmd_list->get_device();
  reshade::api::descriptor_table* new_tables = nullptr;
  bool built_new_tables = false;
  bool active = false;

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  reshade::api::descriptor_heap heap = {0};
  uint32_t base_offset = 0;
  for (uint32_t i = 0; i < count; ++i) {
    device->get_descriptor_heap_offset(tables[i], 0, 0, &heap, &base_offset);

    HeapDescriptorInfo* info = nullptr;
    bool found_info = false;
    if (auto pair = data.heap_descriptor_infos.find(heap.handle); pair != data.heap_descriptor_infos.end()) {
      auto& map = pair->second;
      if (auto pair2 = map.find(base_offset); pair2 != map.end()) {
        info = pair2->second;
        found_info = true;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(found heap info: ";
        s << reinterpret_cast<void*>(heap.handle);
        s << "[" << base_offset << "]";
        s << ", handle: " << reinterpret_cast<void*>(info->replacement_descriptor_handle);
        s << ", size: " << info->updates.size();
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      }
    }
    if (found_info) {
      if (info->replacement_descriptor_handle == 0) {
        reshade::api::descriptor_table new_table = {0};
        bool allocated = device->allocate_descriptor_table(layout, first + i, &new_table);
        if (new_table.handle == 0) {
          std::stringstream s;
          s << "mods::swapchain::OnBindDescriptorTables(could not allocate new table: ";
          s << reinterpret_cast<void*>(tables[i].handle);
          s << " via ";
          s << reinterpret_cast<void*>(layout.handle);
          s << "[" << first + i << "]";
          s << ", allocated: " << (allocated ? "true" : "false");
          s << ")";
          reshade::log_message(reshade::log_level::warning, s.str().c_str());

          allocated = device->allocate_descriptor_table({0}, 0u, &new_table);
          if (new_table.handle == 0) {
            std::stringstream s;
            s << "mods::swapchain::OnBindDescriptorTables(could not allocate new table (2): ";
            s << reinterpret_cast<void*>(tables[i].handle);
            s << " via ";
            s << reinterpret_cast<void*>(0);
            s << "[" << first + i << "]";
            s << ", allocated: " << (allocated ? "true" : "false");
            s << ")";
            reshade::log_message(reshade::log_level::error, s.str().c_str());
            continue;
          }
          info->replacement_descriptor_handle = new_table.handle;
        }
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(allocate new table pre-bind: ";
        s << reinterpret_cast<void*>(tables[i].handle);
        s << " => ";
        s << reinterpret_cast<void*>(new_table.handle);
        s << " via ";
        s << reinterpret_cast<void*>(layout.handle);
        s << "[" << first + i << "]";
        s << ", updates: " << reinterpret_cast<void*>(&info->updates);
        s << " (" << info->updates.size() << ")";
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
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
        s2 << reinterpret_cast<void*>(&info->updates);
        s2 << ", size" << len;
        s2 << ")";
        reshade::log_message(reshade::log_level::debug, s2.str().c_str());
#endif
        device->update_descriptor_tables(len, update_data);
        info->replacement_descriptor_handle = new_table.handle;
      } else {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(no base_offset: ";
        s << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
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
        s << reinterpret_cast<void*>(tables[i].handle);
        s << " => ";
        s << reinterpret_cast<void*>(new_tables[i].handle);
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
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
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    cmd_list->bind_descriptor_tables(stages, layout, first, count, new_tables);
  } else if (built_new_tables) {
    auto& cmd_data = cmd_list->get_private_data<CommandListData>();
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnBindDescriptorTables(storing unbound descriptor)";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    cmd_data.unbound_descriptors.push_back({
        .stages = stages,
        .layout = layout,
        .first = first,
        .count = count,
        .tables = {new_tables[0], new_tables[count - 1]},
    });
  }
#ifdef DEBUG_LEVEL_2
  reshade::log_message(reshade::log_level::debug, "mods::swapchain::OnBindDescriptorTables(done)");
#endif
}

// Set DescriptorTables RSVs
static void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (update.count == 0u) return;
  auto* device = cmd_list->get_device();

  reshade::api::descriptor_table_update new_update;
  bool changed = false;
  bool active = false;

  for (uint32_t i = 0; i < update.count; i++) {
    // if (!update.table.handle) continue;
    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        auto resource_view = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i].view;
        if (resource_view.handle == 0) continue;
        auto& data = device->get_private_data<DeviceData>();
        const std::unique_lock lock(data.mutex);
        auto new_resource_view = FindReplacementResourceView(
            data,
            resource_view,
            reshade::api::resource_usage::shader_resource);
        if (resource_view.handle == new_resource_view.handle) break;
        auto new_resource = renodx::utils::resource::GetResourceFromResourceView(device, new_resource_view);
        if (new_resource.handle == 0u) break;

        if (!changed) {
          new_update = renodx::utils::descriptor::CloneDescriptorTableUpdates(&update, 1)[0];
        }

        // NOLINTNEXTLINE(google-readability-casting)
        ((reshade::api::sampler_with_resource_view*)(new_update.descriptors))[i].view = new_resource_view;
        changed = true;
        if (data.enabled_cloned_resources.contains(new_resource.handle)) {
          active = true;
        }
        break;
      }
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::unordered_access_view:        {
        auto resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        if (resource_view.handle == 0) continue;
        auto& data = device->get_private_data<DeviceData>();
        const std::unique_lock lock(data.mutex);
        auto new_resource_view = FindReplacementResourceView(
            data,
            resource_view,
            update.type);
        if (new_resource_view.handle == 0) {
          std::stringstream s;
          s << "mods::swapchain::OnPushDescriptors(invalid resource view clone for : ";
          s << reinterpret_cast<void*>(resource_view.handle);
          s << ")";
          reshade::log_message(reshade::log_level::warning, s.str().c_str());
          break;
        }
        if (resource_view.handle == new_resource_view.handle) break;
        auto new_resource = renodx::utils::resource::GetResourceFromResourceView(device, new_resource_view);
        if (new_resource.handle == 0u) break;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnPushDescriptors(found clonable: ";
        s << reinterpret_cast<void*>(new_resource_view.handle);
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

        if (!changed) {
          new_update = renodx::utils::descriptor::CloneDescriptorTableUpdates(&update, 1)[0];
        }

        // NOLINTNEXTLINE(google-readability-casting)
        ((reshade::api::resource_view*)(new_update.descriptors))[i] = new_resource_view;
        changed = true;
        if (data.enabled_cloned_resources.contains(new_resource.handle)) {
          active = true;
        }
        break;
      }
      default:
        break;
    }
  }

  if (active) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnPushDescriptors(apply push)";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    cmd_list->push_descriptors(stages, layout, layout_param, new_update);
  } else if (changed) {
    auto& cmd_data = cmd_list->get_private_data<CommandListData>();
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnPushDescriptors(storing unpushed descriptor)";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    cmd_data.unpushed_updates.push_back({
        .stages = stages,
        .layout = layout,
        .layout_param = layout_param,
        .update = new_update,
    });
  }
#ifdef DEBUG_LEVEL_2
  reshade::log_message(reshade::log_level::debug, "push_descriptors(done)");
#endif
}

static void RewriteRenderTargets(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (count == 0u) return;

  auto* device = cmd_list->get_device();

  size_t last_non_null = -1;

  const size_t size = count * sizeof(reshade::api::resource_view);
  auto* new_rtvs = static_cast<reshade::api::resource_view*>(malloc(size));
  memcpy(new_rtvs, rtvs, count);
  bool changed = false;
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  for (uint32_t i = 0; i < count; i++) {
    const reshade::api::resource_view resource_view = rtvs[i];
    if (resource_view.handle == 0u) continue;
    last_non_null = i;

    auto new_resource_view = FindReplacementResourceView(
        data,
        resource_view,
        reshade::api::resource_usage::render_target);

    if (resource_view.handle == new_resource_view.handle) continue;
    auto new_resource = renodx::utils::resource::GetResourceFromResourceView(device, new_resource_view);
    if (new_resource.handle == 0u) continue;

    if (
        auto enabled_cloned_resource = data.enabled_cloned_resources.find(new_resource.handle);
        enabled_cloned_resource != data.enabled_cloned_resources.end()) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::RewriteRenderTargets(rewrite ";
      s << reinterpret_cast<void*>(resource_view.handle);
      s << " => ";
      s << reinterpret_cast<void*>(new_resource_view.handle);
      s << ", res: " << reinterpret_cast<void*>(new_resource.handle);
      s << ") [" << i << "]";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      changed = true;
      new_rtvs[i] = new_resource_view;
    } else {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::RewriteRenderTargets(ignore ";
      s << reinterpret_cast<void*>(resource_view.handle);
      s << " => ";
      s << reinterpret_cast<void*>(new_resource_view.handle);
      s << ") [" << i << "]";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    }
  }
  if (!changed) return;
  cmd_list->bind_render_targets_and_depth_stencil(last_non_null + 1, new_rtvs, dsv);
}

static void DiscardDescriptors(reshade::api::command_list* cmd_list) {
  auto& cmd_data = cmd_list->get_private_data<CommandListData>();
  cmd_data.unbound_descriptors.clear();
  cmd_data.unpushed_updates.clear();
}

static void FlushDescriptors(reshade::api::command_list* cmd_list) {
  auto& cmd_data = cmd_list->get_private_data<CommandListData>();
  for (auto info : cmd_data.unbound_descriptors) {
    cmd_list->bind_descriptor_tables(
        info.stages,
        info.layout,
        info.first,
        info.count,
        info.tables.data());
  }
  cmd_data.unbound_descriptors.clear();

  for (auto info : cmd_data.unpushed_updates) {
    cmd_list->push_descriptors(
        info.stages,
        info.layout,
        info.layout_param,
        info.update);
  }
  cmd_data.unpushed_updates.clear();
}

// Set render target RSV
static void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (count == 0u) return;

  RewriteRenderTargets(cmd_list, count, rtvs, dsv);
}

static bool OnClearRenderTargetView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  if (auto pair = data.render_target_resource_view_clones.find(rtv.handle);
      pair != data.render_target_resource_view_clones.end()) {
    cmd_list->clear_render_target_view(
        reshade::api::resource_view{pair->second},
        color,
        rect_count,
        rects);
  }
  return false;
}

static bool OnClearUnorderedAccessViewUint(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const uint32_t values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  if (auto pair = data.uav_resource_view_clones.find(uav.handle);
      pair != data.uav_resource_view_clones.end()) {
    cmd_list->clear_unordered_access_view_uint(
        reshade::api::resource_view{pair->second},
        values,
        rect_count,
        rects);
  }
  return false;
}

static bool OnClearUnorderedAccessViewFloat(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const float values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  if (auto pair = data.uav_resource_view_clones.find(uav.handle);
      pair != data.uav_resource_view_clones.end()) {
    cmd_list->clear_unordered_access_view_float(
        reshade::api::resource_view{pair->second},
        values,
        rect_count,
        rects);
  }
  return false;
}

static void OnBarrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states) {
  if (count == 0u) return;
  auto* device = cmd_list->get_device();
  if (device == nullptr) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  for (uint32_t i = 0; i < count; i++) {
    const auto& resource = resources[i];
    const auto& old_state = old_states[i];
    const auto& new_state = new_states[i];

    if (
        auto pair = data.cloned_resources.find(resource.handle);
        pair != data.cloned_resources.end()) {
      auto clone_resource = reshade::api::resource{pair->second};
      if (data.enabled_cloned_resources.contains(clone_resource.handle)) {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBarrier(apply barrier clone: ";
        s << reinterpret_cast<void*>(resource.handle);
        s << " => ";
        s << reinterpret_cast<void*>(clone_resource.handle);
        s << ", state: " << old_state << " => " << new_state;
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
        cmd_list->barrier(clone_resource, old_state, new_state);
      }
    }
  }
}

static bool OnSetFullscreenState(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
  if (use_resize_buffer && use_resize_buffer_on_set_full_screen) {
    renodx::utils::swapchain::ResizeBuffer(swapchain, target_format, target_color_space);
  }
  auto* device = swapchain->get_device();
  if (device == nullptr) return false;
  auto& private_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(private_data.mutex);
  reshade::log_message(reshade::log_level::debug, "mods::swapchain::OnSetFullscreenState(reset resource upgrade)");
  private_data.resource_upgrade_finished = false;
  const uint32_t len = swap_chain_upgrade_targets.size();
  // Reset
  for (uint32_t i = 0; i < len; i++) {
    renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
    if (target->ignore_reset) continue;
    target->counted = 0;
    target->completed = false;
  }

  if (!fullscreen) return false;
  if (private_data.prevent_full_screen) {
    HWND output_window = static_cast<HWND>(swapchain->get_hwnd());
    if (output_window != nullptr) {
      auto device_back_buffer_desc = renodx::utils::swapchain::GetBackBufferDesc(device);
      // HMONITOR monitor = (HMONITOR)hmonitor;
      const uint32_t screen_width = GetSystemMetrics(SM_CXSCREEN);
      const uint32_t screen_height = GetSystemMetrics(SM_CYSCREEN);
      const uint32_t texture_width = device_back_buffer_desc.texture.width;
      const uint32_t texture_height = device_back_buffer_desc.texture.height;
      const uint32_t top = floor((screen_height - texture_height) / 2.f);
      const uint32_t left = floor((screen_width - texture_width) / 2.f);
      SetWindowLongPtr(output_window, GWL_STYLE, WS_VISIBLE | WS_POPUP);
      SetWindowPos(output_window, HWND_TOP, left, top, texture_width, texture_height, SWP_FRAMECHANGED);
    }
    reshade::log_message(reshade::log_level::info, "Preventing fullscreen");
    return true;
  }
  return false;
}

static void SetUseHDR10(bool value = true) {
  if (value) {
    target_format = reshade::api::format::r10g10b10a2_unorm;
    target_color_space = reshade::api::color_space::hdr10_st2084;
  } else {
    target_format = reshade::api::format::r16g16b16a16_float;
    target_color_space = reshade::api::color_space::extended_srgb_linear;
  }
}

static void SetUpgradeResourceViews(bool value = true) {
  upgrade_resource_views = value;
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::swapchain::Use(fdw_reason);
  if (use_resource_cloning) {
    renodx::utils::descriptor::Use(fdw_reason);
  }

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log_message(reshade::log_level::info, "mods::swapchain attached.");
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::register_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::create_resource>(OnCreateResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);

      reshade::register_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);
      reshade::register_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
      reshade::register_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);

      // reshade::register_event<reshade::addon_event::copy_resource>(on_copy_resource);

      if (use_resource_cloning) {
        reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
        reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

        reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
        reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
        reshade::register_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
        reshade::register_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
        reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
        reshade::register_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
        reshade::register_event<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint);
        reshade::register_event<reshade::addon_event::clear_unordered_access_view_float>(OnClearUnorderedAccessViewFloat);

        // reshade::register_event<reshade::addon_event::copy_buffer_to_texture>(on_copy_buffer_to_texture);
        // reshade::register_event<reshade::addon_event::barrier>(on_barrier);
      }

      reshade::register_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::unregister_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      reshade::unregister_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::unregister_event<reshade::addon_event::create_resource>(OnCreateResource);

      reshade::unregister_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);
      reshade::unregister_event<reshade::addon_event::init_resource_view>(OnInitResourceView);

      reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);

      break;
  }
}
}  // namespace renodx::mods::swapchain
