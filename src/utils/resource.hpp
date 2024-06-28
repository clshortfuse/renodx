/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <shared_mutex>
#include <unordered_map>
#include <unordered_set>

#include <include/reshade.hpp>

namespace renodx::utils::resource {

struct __declspec(uuid("3ca7d390-8d24-4491-a15f-1d558542ab2c")) DeviceData {
  // <resource_view.handle, resource.handle>
  std::unordered_map<uint64_t, uint64_t> resource_view_resources;
  std::unordered_map<uint64_t, float> resource_tags;
  std::unordered_set<uint64_t> resources;
  std::shared_mutex mutex;
};

static void OnInitDevice(reshade::api::device* device) {
  device->create_private_data<DeviceData>();
}

static void OnDestroyDevice(reshade::api::device* device) {
  device->destroy_private_data<DeviceData>();
}

static void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (resource.handle == 0) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resources.insert(resource.handle);
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  if (resource.handle == 0) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resources.erase(resource.handle);
}

static void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  if (resource.handle == 0) {
    data.resource_view_resources.erase(view.handle);
    return;
  }
#ifdef DEBUG_LEVEL_1
  if (data.resource_view_resources.contains(view.handle)) {
    std::stringstream s;
    s << "utils::resource::OnInitResourceView(";
    s << "Redefinition of: " << reinterpret_cast<void*>(view.handle);
    s << ", res: " << reinterpret_cast<void*>(resource.handle);
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
  }
#endif
  data.resource_view_resources[view.handle] = resource.handle;

#ifdef DEBUG_LEVEL_2
  std::stringstream s;
  s << "utils::resource::OnInitResourceView(";
  s << "view: " << reinterpret_cast<void*>(view.handle);
  s << ", res: " << reinterpret_cast<void*>(resource.handle);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
}

static void OnDestroyResourceView(
    reshade::api::device* device,
    reshade::api::resource_view view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resource_view_resources.erase(view.handle);
}

static reshade::api::resource GetResourceFromResourceView(
    reshade::api::device* device,
    reshade::api::resource_view resource_view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);

  if (
      auto pair = data.resource_view_resources.find(resource_view.handle);
      pair != data.resource_view_resources.end()) {
    return {pair->second};
  }

  return {0};
}

static reshade::api::resource GetResourceFromResourceView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view resource_view) {
  auto* device = cmd_list->get_device();
  return GetResourceFromResourceView(device, resource_view);
}

static void SetResourceFromResourceView(
    reshade::api::device* device,
    reshade::api::resource_view resource_view,
    reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resource_view_resources[resource_view.handle] = resource.handle;
}

static void SetResourceFromResourceView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view resource_view,
    reshade::api::resource resource) {
  auto* device = cmd_list->get_device();
  SetResourceFromResourceView(device, resource_view, resource);
}

static void RemoveResourceFromResourceView(reshade::api::device* device, reshade::api::resource_view resource_view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resource_view_resources.erase(resource_view.handle);
}

static void RemoveResourceFromResourceView(reshade::api::command_list* cmd_list, reshade::api::resource_view resource_view) {
  auto* device = cmd_list->get_device();
  RemoveResourceFromResourceView(device, resource_view);
}

static float GetResourceTag(reshade::api::device* device, reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  auto pair = data.resource_tags.find(resource.handle);
  if (pair == data.resource_tags.end()) return -1;
  return pair->second;
}

static float GetResourceTag(reshade::api::device* device, reshade::api::resource_view resource_view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  auto rv_pairs = data.resource_view_resources.find(resource_view.handle);
  if (rv_pairs == data.resource_view_resources.end()) return -1;
  auto r_pairs = data.resource_tags.find(rv_pairs->second);
  if (r_pairs == data.resource_tags.end()) return -1;
  return r_pairs->second;
}

static void SetResourceTag(reshade::api::device* device, reshade::api::resource resource, float tag) {
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  data.resource_tags[resource.handle] = tag;
}

static void RemoveResourceTag(reshade::api::device* device, reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resource_tags.erase(resource.handle);
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log_message(reshade::log_level::info, "ResourceUtil attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::register_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
      reshade::register_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);
      break;

    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::unregister_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
      reshade::unregister_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);
      break;
  }
}
}  // namespace renodx::utils::resource
