/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <shared_mutex>
#include <unordered_map>

#include <include/reshade.hpp>

#include "./format.hpp"

namespace ResourceUtil {

  struct __declspec(uuid("3ca7d390-8d24-4491-a15f-1d558542ab2c")) DeviceData {
    // <resource_view.handle, resource.handle>
    std::unordered_map<uint64_t, uint64_t> resourceViewResources;
    std::shared_mutex mutex;
  };

  static void on_init_device(reshade::api::device* device) {
    auto &data = device->create_private_data<DeviceData>();
  }

  static void on_destroy_device(reshade::api::device* device) {
    device->destroy_private_data<DeviceData>();
  }

  static void on_init_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc &desc,
    reshade::api::resource_view view
  ) {
    if (!resource.handle) return;
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    data.resourceViewResources.emplace(view.handle, resource.handle);
  }

  static reshade::api::resource getResourceFromResourceView(reshade::api::device* device, reshade::api::resource_view resourceView) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    reshade::api::resource resource;
    auto pair = data.resourceViewResources.find(resourceView.handle);
    if (pair != data.resourceViewResources.end()) {
      resource.handle = pair->second;
    }
    return resource;
  }

  static reshade::api::resource getResourceFromResourceView(reshade::api::command_list* cmd_list, reshade::api::resource_view resourceView) {
    auto device = cmd_list->get_device();
    return getResourceFromResourceView(device, resourceView);
  }

  void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
        reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);

        break;
    }
  }
}  // namespace ResourceUtil
