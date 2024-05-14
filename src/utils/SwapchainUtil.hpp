/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <stdio.h>

#include <filesystem>
#include <fstream>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./format.hpp"
#include "./mutex.hpp"
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
    std::shared_mutex mutex;
  };

  struct __declspec(uuid("25b7ec11-a51f-4884-a6f7-f381d198b9af")) CommandListData {
    std::shared_mutex mutex;
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
      if (backBufferCount) {
        deviceData.backBuffers.insert(
          swapchainData.backBuffers.begin(),
          swapchainData.backBuffers.end()
        );
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
    auto &deviceData = device->get_private_data<DeviceData>();
    std::shared_lock lock(deviceData.mutex);
    return deviceData.backBuffers.contains(resource.handle);
  }

  static bool isBackBuffer(reshade::api::command_list* cmd_list, reshade::api::resource resource) {
    auto device = cmd_list->get_device();
    if (device == nullptr) return false;
    return isBackBuffer(device, resource);
  }

  void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::register_event<reshade::addon_event::destroy_swapchain>(on_destroy_swapchain);
        reshade::register_event<reshade::addon_event::init_command_list>(on_init_command_list);
        reshade::register_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);

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
