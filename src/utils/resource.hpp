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

static bool is_primary_hook = false;

struct __declspec(uuid("3ca7d390-8d24-4491-a15f-1d558542ab2c")) DeviceData {
  std::unordered_map<uint64_t, float> resource_tags;
  std::unordered_set<uint64_t> resources;
  std::shared_mutex mutex;
};

static void OnInitDevice(reshade::api::device* device) {
  auto* data = &device->get_private_data<DeviceData>();
  if (data != nullptr) return;

  data = &device->create_private_data<DeviceData>();

  is_primary_hook = true;
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (!is_primary_hook) return;
  device->destroy_private_data<DeviceData>();
}

static void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (!is_primary_hook) return;
  if (resource.handle == 0) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resources.insert(resource.handle);
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  if (!is_primary_hook) return;
  if (resource.handle == 0) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resources.erase(resource.handle);
}

static float GetResourceTag(reshade::api::device* device, reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  auto pair = data.resource_tags.find(resource.handle);
  if (pair == data.resource_tags.end()) return -1;
  return pair->second;
}

static float GetResourceTag(reshade::api::device* device, reshade::api::resource_view resource_view) {
  auto resource = device->get_resource_from_view(resource_view);
  if (resource.handle == 0u) return -1;

  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  auto r_pairs = data.resource_tags.find(resource.handle);
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
      reshade::log::message(reshade::log::level::info, "ResourceUtil attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      break;

    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      break;
  }
}
}  // namespace renodx::utils::resource
