/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <memory>
#include <shared_mutex>
#include <unordered_map>
#include <unordered_set>

#include <include/reshade.hpp>

namespace renodx::utils::resource {

static bool is_primary_hook = false;

struct __declspec(uuid("3ca7d390-8d24-4491-a15f-1d558542ab2c")) DeviceData {
  std::shared_mutex mutex;

  std::unordered_map<uint64_t, float> resource_tags;

  std::unordered_map<uint64_t, reshade::api::resource> resource_view_resources;
  std::unordered_set<uint64_t> empty_resource_views;
  std::unordered_map<uint64_t, std::unordered_set<uint64_t>> resource_resource_views;
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
  auto& view_set = data.resource_resource_views[resource.handle];
  for (const auto view_handle : view_set) {
    data.resource_view_resources.erase(view_handle);
  }
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  if (!is_primary_hook) return;
  if (resource.handle == 0) return;
  auto& data = device->get_private_data<DeviceData>();
  if (std::addressof(data) == nullptr) return;
  const std::unique_lock lock(data.mutex);
  auto& view_set = data.resource_resource_views[resource.handle];
  for (const auto view_handle : view_set) {
    data.resource_view_resources.erase(view_handle);
  }
}

static void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  if (!is_primary_hook) return;
  if (view.handle == 0u) return;
  auto& data = device->get_private_data<DeviceData>();
  if (std::addressof(data) == nullptr) return;
  const std::unique_lock lock(data.mutex);

  auto& tracked_resource = data.resource_view_resources[view.handle];
  // bool reused_handle = tracked_resource.handle != 0u && tracked_resource.handle != resource.handle;

  if (resource.handle == 0u) {
    data.empty_resource_views.emplace(view.handle);
    return;
  }
  data.empty_resource_views.erase(view.handle);
  tracked_resource.handle = resource.handle;

  auto& view_set = data.resource_resource_views[resource.handle];
  view_set.emplace(view.handle);
}

static void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  if (!is_primary_hook) return;
  if (view.handle == 0u) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  if (auto pair = data.resource_view_resources.find(view.handle);
      pair != data.resource_view_resources.end()) {
    auto& tracked_resource = pair->second;
    if (tracked_resource.handle != 0u) {
      if (auto pair2 = data.resource_resource_views.find(tracked_resource.handle);
          pair2 != data.resource_resource_views.end()) {
        auto& view_set = pair2->second;
        view_set.erase(view.handle);
        if (view_set.empty()) {
          data.resource_resource_views.erase(pair2);
        }
      }
    }
  }

  data.resource_view_resources.erase(view.handle);
  data.empty_resource_views.erase(view.handle);
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
  auto pair = data.resource_view_resources.find(resource_view.handle);
  if (pair == data.resource_view_resources.end()) return -1;

  auto resource = pair->second;
  if (resource.handle == 0u) return -1;
  auto r_pairs = data.resource_tags.find(resource.handle);
  if (r_pairs == data.resource_tags.end()) return -1;
  return r_pairs->second;
}

static void SetResourceTag(reshade::api::device* device, reshade::api::resource resource, float tag) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resource_tags[resource.handle] = tag;
}

static void RemoveResourceTag(reshade::api::device* device, reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  if (std::addressof(data) == nullptr) return;
  const std::unique_lock lock(data.mutex);
  data.resource_tags.erase(resource.handle);
}

static bool IsKnownResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  if (view.handle == 0u) return false;

  auto& data = device->get_private_data<DeviceData>();
  if (std::addressof(data) == nullptr) return false;
  const std::shared_lock lock(data.mutex);
  return data.resource_view_resources.contains(view.handle);
}

static reshade::api::resource GetResourceFromView(reshade::api::device* device, reshade::api::resource_view view) {
  if (view.handle == 0u) return {0};

  auto& data = device->get_private_data<DeviceData>();
  if (std::addressof(data) == nullptr) return {0};
  const std::shared_lock lock(data.mutex);
  auto pair = data.resource_view_resources.find(view.handle);
  if (pair == data.resource_view_resources.end()) return {0};
  return {pair->second};
}

static bool IsResourceViewEmpty(reshade::api::device* device, reshade::api::resource_view view) {
  if (view.handle == 0u) return false;

  auto& data = device->get_private_data<DeviceData>();
  if (std::addressof(data) == nullptr) return false;
  const std::shared_lock lock(data.mutex);
  return data.empty_resource_views.contains(view.handle);
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
