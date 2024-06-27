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
    std::unordered_map<uint64_t, float> resourceTags;
    std::unordered_set<uint64_t> resources;
    std::shared_mutex mutex;
  };

  static void on_init_device(reshade::api::device* device) {
    device->create_private_data<DeviceData>();
  }

  static void on_destroy_device(reshade::api::device* device) {
    device->destroy_private_data<DeviceData>();
  }

  static void on_init_resource(
    reshade::api::device* device,
    const reshade::api::resource_desc &desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource
  ) {
    if (!resource.handle) return;
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    data.resources.insert(resource.handle);
  }

  static void on_destroy_resource(reshade::api::device* device, reshade::api::resource resource) {
    if (!resource.handle) return;
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    data.resources.erase(resource.handle);
  }

  static void on_init_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc &desc,
    reshade::api::resource_view view
  ) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    if (!resource.handle) {
      data.resourceViewResources.erase(view.handle);
      return;
    }
#ifdef DEBUG_LEVEL_1
    if (data.resourceViewResources.contains(view.handle)) {
      std::stringstream s;
      s << "ResourceUtil::init_resource_view("
        << "Redefinition of: " << (void*)view.handle
        << ", res: " << (void*)resource.handle;
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
    }
#endif
    data.resourceViewResources[view.handle] = resource.handle;

#ifdef DEBUG_LEVEL_2
    std::stringstream s;
    s << "ResourceUtil::on_init_resource_view("
      << "view: " << (void*)view.handle
      << ", res: " << (void*)resource.handle
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
  }

  static void on_destroy_resource_view(
    reshade::api::device* device,
    reshade::api::resource_view view
  ) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    data.resourceViewResources.erase(view.handle);
  }

  static reshade::api::resource getResourceFromResourceView(
    reshade::api::device* device,
    reshade::api::resource_view resourceView
  ) {
    auto &data = device->get_private_data<DeviceData>();
    std::shared_lock lock(data.mutex);

    if (
      auto pair = data.resourceViewResources.find(resourceView.handle);
      pair != data.resourceViewResources.end()
    ) {
      return {pair->second};
    }

    return {0};
  }

  static reshade::api::resource getResourceFromResourceView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view resourceView
  ) {
    auto device = cmd_list->get_device();
    return getResourceFromResourceView(device, resourceView);
  }

  static void setResourceFromResourceView(
    reshade::api::device* device,
    reshade::api::resource_view resourceView,
    reshade::api::resource resource
  ) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    data.resourceViewResources[resourceView.handle] = resource.handle;
  }

  static void setResourceFromResourceView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view resourceView,
    reshade::api::resource resource
  ) {
    auto device = cmd_list->get_device();
    return setResourceFromResourceView(device, resourceView, resource);
  }

  static void removeResourceFromResourceView(reshade::api::device* device, reshade::api::resource_view resourceView) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    data.resourceViewResources.erase(resourceView.handle);
  }

  static void removeResourceFromResourceView(reshade::api::command_list* cmd_list, reshade::api::resource_view resourceView) {
    auto device = cmd_list->get_device();
    return removeResourceFromResourceView(device, resourceView);
  }

  static float getResourceTag(reshade::api::device* device, reshade::api::resource resource) {
    auto &data = device->get_private_data<DeviceData>();
    std::shared_lock lock(data.mutex);
    auto pair = data.resourceTags.find(resource.handle);
    if (pair == data.resourceTags.end()) return -1;
    return pair->second;
  }

  static float getResourceTag(reshade::api::device* device, reshade::api::resource_view resourceView) {
    auto &data = device->get_private_data<DeviceData>();
    std::shared_lock lock(data.mutex);
    auto rvPairs = data.resourceViewResources.find(resourceView.handle);
    if (rvPairs == data.resourceViewResources.end()) return -1;
    auto rPairs = data.resourceTags.find(rvPairs->second);
    if (rPairs == data.resourceTags.end()) return -1;
    return rPairs->second;
  }

  static void setResourceTag(reshade::api::device* device, reshade::api::resource resource, float tag) {
    auto &data = device->get_private_data<DeviceData>();
    std::shared_lock lock(data.mutex);
    data.resourceTags[resource.handle] = tag;
  }

  static void removeResourceTag(reshade::api::device* device, reshade::api::resource resource) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    data.resourceTags.erase(resource.handle);
  }

  static bool attached = false;

  static void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        if (attached) return;
        attached = true;
        reshade::log_message(reshade::log_level::info, "ResourceUtil attached.");

        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::register_event<reshade::addon_event::init_resource>(on_init_resource);
        reshade::register_event<reshade::addon_event::destroy_resource>(on_destroy_resource);
        reshade::register_event<reshade::addon_event::init_resource_view>(on_init_resource_view);
        reshade::register_event<reshade::addon_event::destroy_resource_view>(on_destroy_resource_view);
        break;

      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
        reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::unregister_event<reshade::addon_event::init_resource>(on_init_resource);
        reshade::unregister_event<reshade::addon_event::destroy_resource>(on_destroy_resource);
        reshade::unregister_event<reshade::addon_event::init_resource_view>(on_init_resource_view);
        reshade::unregister_event<reshade::addon_event::destroy_resource_view>(on_destroy_resource_view);
        break;
    }
  }
}  // namespace ResourceUtil
