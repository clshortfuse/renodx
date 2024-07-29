/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./resource.hpp"

namespace renodx::utils::swapchain {

struct __declspec(uuid("25b7ec11-a51f-4884-a6f7-f381d198b9af")) SwapchainData {
  reshade::api::swapchain_desc original_descc;
  reshade::api::swapchain_desc current_desc;
  std::unordered_set<uint64_t> back_buffers;
  std::shared_mutex mutex;
};

struct __declspec(uuid("4721e307-0cf3-4293-b4a5-40d0a4e62544")) DeviceData {
  std::unordered_set<reshade::api::swapchain*> swapchains;
  std::unordered_set<uint64_t> back_buffers;
  reshade::api::resource_desc back_buffer_desc;
  std::shared_mutex mutex;
};

struct __declspec(uuid("3cf9a628-8518-4509-84c3-9fbe9a295212")) CommandListData {
  std::vector<reshade::api::resource_view> current_render_targets;
  reshade::api::resource_view current_depth_stencil;
  bool has_swapchain_render_target_dirty = true;
  bool has_swapchain_render_target;
};

static std::shared_mutex mutex;

static void OnInitDevice(reshade::api::device* device) {
  auto& data = device->create_private_data<DeviceData>();
}

static void OnDestroyDevice(reshade::api::device* device) {
  device->destroy_private_data<DeviceData>();
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  auto& swapchain_data = swapchain->create_private_data<SwapchainData>();
  const size_t back_buffer_count = swapchain->get_back_buffer_count();
  for (uint32_t index = 0; index < back_buffer_count; index++) {
    auto buffer = swapchain->get_back_buffer(index);
    swapchain_data.back_buffers.emplace(buffer.handle);
  }
  auto* device = swapchain->get_device();
  if (device != nullptr) {
    auto& device_data = device->get_private_data<DeviceData>();
    const std::unique_lock lock(device_data.mutex);
    device_data.swapchains.emplace(swapchain);

    for (uint32_t index = 0; index < back_buffer_count; index++) {
      auto buffer = swapchain->get_back_buffer(index);
      device_data.back_buffers.emplace(buffer.handle);
      if (index == 0) {
        auto desc = device->get_resource_desc(buffer);
        device_data.back_buffer_desc = desc;
      }
    }
  }
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain) {
  auto& swapchain_data = swapchain->get_private_data<SwapchainData>();
  auto* device = swapchain->get_device();
  if (device != nullptr) {
    auto& device_data = device->get_private_data<DeviceData>();
    const std::unique_lock lock(device_data.mutex);
    device_data.swapchains.erase(swapchain);
    for (const uint64_t handle : swapchain_data.back_buffers) {
      device_data.back_buffers.erase(handle);
    }
  }
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  auto& data = cmd_list->create_private_data<CommandListData>();
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

static bool IsBackBuffer(reshade::api::device* device, reshade::api::resource resource) {
  bool result = false;
  {
    auto& device_data = device->get_private_data<DeviceData>();
    const std::shared_lock lock(device_data.mutex);
    result = device_data.back_buffers.contains(resource.handle);
  }
  return result;
}

static bool IsBackBuffer(reshade::api::command_list* cmd_list, reshade::api::resource resource) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;
  return IsBackBuffer(device, resource);
}

static reshade::api::resource_desc GetBackBufferDesc(reshade::api::device* device) {
  reshade::api::resource_desc desc = {};
  {
    auto& device_data = device->get_private_data<DeviceData>();
    const std::shared_lock lock(device_data.mutex);
    desc = device_data.back_buffer_desc;
  }
  return desc;
}

static reshade::api::resource_desc GetBackBufferDesc(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return {};
  return GetBackBufferDesc(device);
}

static void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
  const bool found_swapchain_rtv = false;
  cmd_list_data.current_render_targets.assign(rtvs, rtvs + count);
  cmd_list_data.current_depth_stencil = dsv;
  uint32_t counted = 0;
  for (uint32_t i = 0; i < count; i++) {
    const reshade::api::resource_view rtv = rtvs[i];
    if (rtv.handle != 0u) {
      counted++;
    }
  }
  cmd_list_data.current_render_targets.resize(counted);
  cmd_list_data.has_swapchain_render_target_dirty = true;
}

static bool HasBackBufferRenderTarget(reshade::api::command_list* cmd_list) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();

  if (!cmd_list_data.has_swapchain_render_target_dirty) {
    return cmd_list_data.has_swapchain_render_target;
  }

  const uint32_t count = cmd_list_data.current_render_targets.size();
  if (count == 0u) {
    cmd_list_data.has_swapchain_render_target_dirty = false;
    cmd_list_data.has_swapchain_render_target = false;
    return false;
  }
  auto* device = cmd_list->get_device();
  auto& device_data = device->get_private_data<DeviceData>();
  const std::shared_lock device_lock(device_data.mutex);

  bool found_swapchain_rtv = false;
  for (uint32_t i = 0; i < count; i++) {
    const reshade::api::resource_view rtv = cmd_list_data.current_render_targets[i];
    auto resource = renodx::utils::resource::GetResourceFromResourceView(device, rtv);
    if ((resource.handle != 0u) && device_data.back_buffers.contains(resource.handle)) {
      found_swapchain_rtv = true;
      break;
    }
  }

  cmd_list_data.has_swapchain_render_target_dirty = false;
  cmd_list_data.has_swapchain_render_target = found_swapchain_rtv;
  return found_swapchain_rtv;
}

static std::vector<reshade::api::resource_view>& GetRenderTargets(reshade::api::command_list* cmd_list) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
  return cmd_list_data.current_render_targets;
};

static reshade::api::resource_view& GetDepthStencil(reshade::api::command_list* cmd_list) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
  return cmd_list_data.current_depth_stencil;
};

static bool attached = false;

inline void Use(DWORD fdw_reason) {
  renodx::utils::resource::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

      break;
  }
}
}  // namespace renodx::utils::swapchain
