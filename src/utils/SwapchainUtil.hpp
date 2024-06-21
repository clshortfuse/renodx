/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./ResourceUtil.hpp"
#include "./format.hpp"
#include "./pipelineUtil.hpp"

namespace SwapchainUtil {

  struct __declspec(uuid("25b7ec11-a51f-4884-a6f7-f381d198b9af")) SwapchainData {
    reshade::api::swapchain_desc originalDesc;
    reshade::api::swapchain_desc currentDesc;
    std::unordered_set<uint64_t> backBuffers;
    std::shared_mutex mutex;
  };

  struct __declspec(uuid("4721e307-0cf3-4293-b4a5-40d0a4e62544")) DeviceData {
    std::unordered_set<reshade::api::swapchain*> swapchains;
    std::unordered_set<uint64_t> backBuffers;
    reshade::api::resource_desc backBufferDesc;
    std::shared_mutex mutex;
  };

  struct __declspec(uuid("25b7ec11-a51f-4884-a6f7-f381d198b9af")) CommandListData {
    std::vector<reshade::api::resource_view> currentRenderTargets;
    reshade::api::resource_view currentDepthStencil;
    bool hasSwapchainRenderTargetDirty = true;
    bool hasSwapchainRenderTarget;
  };

  static std::shared_mutex mutex;

  static void on_init_device(reshade::api::device* device) {
    auto &data = device->create_private_data<DeviceData>();
  }

  static void on_destroy_device(reshade::api::device* device) {
    device->destroy_private_data<DeviceData>();
  }

  static void on_init_swapchain(reshade::api::swapchain* swapchain) {
    auto &swapchainData = swapchain->create_private_data<SwapchainData>();
    const size_t backBufferCount = swapchain->get_back_buffer_count();
    for (uint32_t index = 0; index < backBufferCount; index++) {
      auto buffer = swapchain->get_back_buffer(index);
      swapchainData.backBuffers.emplace(buffer.handle);
    }
    auto device = swapchain->get_device();
    if (device) {
      auto &deviceData = device->get_private_data<DeviceData>();
      std::unique_lock lock(deviceData.mutex);
      deviceData.swapchains.emplace(swapchain);

      for (uint32_t index = 0; index < backBufferCount; index++) {
        auto buffer = swapchain->get_back_buffer(index);
        deviceData.backBuffers.emplace(buffer.handle);
        if (index == 0) {
          auto desc = device->get_resource_desc(buffer);
          deviceData.backBufferDesc = desc;
        }
      }
    }
  }

  static void on_destroy_swapchain(reshade::api::swapchain* swapchain) {
    auto &swapchainData = swapchain->get_private_data<SwapchainData>();
    auto device = swapchain->get_device();
    if (device) {
      auto &deviceData = device->get_private_data<DeviceData>();
      std::unique_lock lock(deviceData.mutex);
      deviceData.swapchains.erase(swapchain);
      for (uint64_t handle : swapchainData.backBuffers) {
        deviceData.backBuffers.erase(handle);
      }
    }
  }

  static void on_init_command_list(reshade::api::command_list* cmd_list) {
    auto &data = cmd_list->create_private_data<CommandListData>();
  }

  static void on_destroy_command_list(reshade::api::command_list* cmd_list) {
    cmd_list->destroy_private_data<CommandListData>();
  }

  static bool isBackBuffer(reshade::api::device* device, reshade::api::resource resource) {
    bool result = false;
    {
      auto &deviceData = device->get_private_data<DeviceData>();
      std::shared_lock lock(deviceData.mutex);
      result = deviceData.backBuffers.contains(resource.handle);
    }
    return result;
  }

  static bool isBackBuffer(reshade::api::command_list* cmd_list, reshade::api::resource resource) {
    auto device = cmd_list->get_device();
    if (device == nullptr) return false;
    return isBackBuffer(device, resource);
  }

  static reshade::api::resource_desc getBackBufferDesc(reshade::api::device* device) {
    reshade::api::resource_desc desc = {};
    {
      auto &deviceData = device->get_private_data<DeviceData>();
      std::shared_lock lock(deviceData.mutex);
      desc = deviceData.backBufferDesc;
    }
    return desc;
  }

  static reshade::api::resource_desc getBackBufferDesc(reshade::api::command_list* cmd_list) {
    auto device = cmd_list->get_device();
    if (device == nullptr) return {};
    return getBackBufferDesc(device);
  }

  static void on_bind_render_targets_and_depth_stencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv
  ) {
    auto &cmdListData = cmd_list->get_private_data<CommandListData>();
    bool foundSwapchainRTV = false;
    cmdListData.currentRenderTargets.assign(rtvs, rtvs + count);
    cmdListData.currentDepthStencil = dsv;
    uint32_t counted = 0;
    for (uint32_t i = 0; i < count; i++) {
      const reshade::api::resource_view rtv = rtvs[i];
      if (rtv.handle) {
        counted++;
      }
    }
    cmdListData.currentRenderTargets.resize(counted);
    cmdListData.hasSwapchainRenderTargetDirty = true;
  }

  static bool hasBackBufferRenderTarget(reshade::api::command_list* cmd_list) {
    auto &cmdListData = cmd_list->get_private_data<CommandListData>();

    if (!cmdListData.hasSwapchainRenderTargetDirty) {
      return cmdListData.hasSwapchainRenderTarget;
    }

    uint32_t count = cmdListData.currentRenderTargets.size();
    if (!count) {
      cmdListData.hasSwapchainRenderTargetDirty = false;
      cmdListData.hasSwapchainRenderTarget = false;
      return false;
    }
    auto device = cmd_list->get_device();
    auto &deviceData = device->get_private_data<DeviceData>();
    std::shared_lock deviceLock(deviceData.mutex);

    bool foundSwapchainRTV = false;
    for (uint32_t i = 0; i < count; i++) {
      const reshade::api::resource_view rtv = cmdListData.currentRenderTargets[i];
      auto resource = ResourceUtil::getResourceFromResourceView(device, rtv);
      if (resource.handle && deviceData.backBuffers.contains(resource.handle)) {
        foundSwapchainRTV = true;
        break;
      }
    }

    cmdListData.hasSwapchainRenderTargetDirty = false;
    cmdListData.hasSwapchainRenderTarget = foundSwapchainRTV;
    return foundSwapchainRTV;
  }

  static bool attached = false;

  void use(DWORD fdwReason) {
    ResourceUtil::use(fdwReason);
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        if (attached) return;
        attached = true;
        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::register_event<reshade::addon_event::destroy_swapchain>(on_destroy_swapchain);
        reshade::register_event<reshade::addon_event::init_command_list>(on_init_command_list);
        reshade::register_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);
        reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(on_bind_render_targets_and_depth_stencil);

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
        reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::unregister_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::unregister_event<reshade::addon_event::destroy_swapchain>(on_destroy_swapchain);
        reshade::unregister_event<reshade::addon_event::init_command_list>(on_init_command_list);
        reshade::unregister_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);

        break;
    }
  }
}  // namespace SwapchainUtil
