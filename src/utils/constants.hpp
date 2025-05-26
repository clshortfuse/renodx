/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cstdint>
#include <cstring>

#include <mutex>
#include <shared_mutex>
#include <span>
#include <sstream>
#include <unordered_map>
#include <vector>

#include <include/reshade.hpp>

#include "./bitwise.hpp"
#include "./data.hpp"
#include "./format.hpp"

namespace renodx::utils::constants {

static bool capture_constant_buffers = true;

namespace internal {
static bool is_primary_hook = false;

static bool attached = false;
}  // namespace internal

struct __declspec(uuid("1aa69bfe-5467-47e1-9c8e-c6b935198169")) DeviceData {
  std::shared_mutex mutex;
  std::unordered_map<uint64_t, std::vector<reshade::api::pipeline_layout_param>> pipeline_layout_params;
  std::unordered_map<uint64_t, std::vector<uint8_t>> buffer_cache;
  std::unordered_map<uint64_t, std::vector<uint8_t>> buffer_history;
  std::unordered_map<uint64_t, std::span<uint8_t>> buffer_mapping;
};

struct __declspec(uuid("f8805bac-a932-49ef-b0c9-e4db1a8b33fc")) CommandListData {
};

static void OnInitDevice(reshade::api::device* device) {
  DeviceData* data;
  bool created = renodx::utils::data::CreateOrGet<DeviceData>(device, data);
  if (!created) return;

  if (created) {
    std::stringstream s;
    s << "utils::constants::OnInitDevice(Hooking device: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
    internal::is_primary_hook = true;
  } else {
    std::stringstream s;
    s << "utils::constants::OnInitDevice(Attaching to hook: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (!internal::is_primary_hook) return;
  device->destroy_private_data<DeviceData>();
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (!internal::is_primary_hook) return;
  cmd_list->create_private_data<CommandListData>();
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (!internal::is_primary_hook) return;
  cmd_list->destroy_private_data<CommandListData>();
}

static void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (!internal::is_primary_hook) return;
  if (!capture_constant_buffers) return;

  if (desc.type != reshade::api::resource_type::buffer) return;

  if (!renodx::utils::bitwise::HasFlag(desc.usage, reshade::api::resource_usage::constant_buffer)) return;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);

  if (initial_data == nullptr) {
    if (desc.buffer.size > 64 * 1024) {
      // Invalid size?
      return;
    }
    data->buffer_cache[resource.handle] = std::vector<uint8_t>(desc.buffer.size, 0);
  } else {
    data->buffer_cache[resource.handle] = {
        static_cast<uint8_t*>(initial_data->data),
        static_cast<uint8_t*>(initial_data->data) + desc.buffer.size,
    };
  }
  data->buffer_mapping[resource.handle] = {};
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  if (!internal::is_primary_hook) return;
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  data->buffer_mapping.erase(resource.handle);
  auto pair = data->buffer_cache.find(resource.handle);
  if (pair != data->buffer_cache.end()) {
    data->buffer_history[resource.handle] = pair->second;
    data->buffer_cache.erase(pair);
  }
}

static void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  if (!internal::is_primary_hook) return;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  std::vector<reshade::api::pipeline_layout_param> cloned_params = {
      params, params + param_count};

  data->pipeline_layout_params[layout.handle] = cloned_params;
}

static void OnMapBufferRegion(
    reshade::api::device* device,
    reshade::api::resource resource,
    uint64_t offset,
    uint64_t size,
    reshade::api::map_access access,
    void** mapped_data) {
  if (!internal::is_primary_hook) return;
  if (!capture_constant_buffers) return;
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  std::shared_lock read_lock(data->mutex);
  auto pair = data->buffer_mapping.find(resource.handle);
  if (pair == data->buffer_mapping.end()) return;
  read_lock.unlock();
  std::unique_lock write_lock(data->mutex);
  uint8_t* start = *(reinterpret_cast<uint8_t**>(mapped_data));
  if (size == UINT64_MAX) {
    auto desc = device->get_resource_desc(resource);
    pair->second = {
        start + offset,
        start + offset + desc.buffer.size};
  } else {
    pair->second = {
        start + offset,
        start + offset + size};
  }
}

static void OnUnmapBufferRegion(
    reshade::api::device* device,
    reshade::api::resource resource) {
  if (!internal::is_primary_hook) return;
  if (!capture_constant_buffers) return;
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  std::shared_lock read_lock(data->mutex);
  auto pair = data->buffer_mapping.find(resource.handle);
  if (pair == data->buffer_mapping.end()) return;
  // Update contents of
  read_lock.unlock();

  std::unique_lock write_lock(data->mutex);

  auto pair2 = data->buffer_cache.find(resource.handle);
  if (pair2 != data->buffer_cache.end()) {
    pair2->second.assign(
        static_cast<uint8_t*>(pair->second.data()),
        static_cast<uint8_t*>(pair->second.data()) + pair->second.size());
  } else {
    std::fill(pair2->second.begin(), pair2->second.end(), 0);
  }

  pair->second = {};
}

static bool OnUpdateBufferRegion(
    reshade::api::device* device,
    const void* buffer_data, reshade::api::resource resource,
    uint64_t offset, uint64_t size) {
  if (!internal::is_primary_hook) return false;
  if (!capture_constant_buffers) return false;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return false;
  std::shared_lock read_lock(data->mutex);
  auto pair = data->buffer_mapping.find(resource.handle);
  if (pair == data->buffer_mapping.end()) return false;
  read_lock.unlock();

  auto pair2 = data->buffer_cache.find(resource.handle);
  auto desc = device->get_resource_desc(resource);
  if (pair2 == data->buffer_cache.end()) {
    auto new_data = std::vector<uint8_t>(desc.buffer.size, 0);
    memcpy(new_data.data() + offset, static_cast<const uint8_t*>(buffer_data) + offset, size);
    data->buffer_cache[resource.handle] = new_data;
  } else {
    memcpy(pair2->second.data() + offset, static_cast<const uint8_t*>(buffer_data) + offset, size);
  }

  return false;
}

static void OnPushConstants(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    uint32_t first,
    uint32_t count,
    const void* values) {
}

static void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (!internal::is_primary_hook) return;
  if (!capture_constant_buffers) return;

  bool fetched_param = false;
  reshade::api::pipeline_layout_param param;

  for (uint32_t i = 0; i < update.count; i++) {
    if (update.type != reshade::api::descriptor_type::constant_buffer) continue;

    if (!fetched_param) {
      auto* device = cmd_list->get_device();
      auto* device_data = renodx::utils::data::Get<DeviceData>(device);
      if (device_data == nullptr) return;
      std::shared_lock lock(device_data->mutex);
      auto pair = device_data->pipeline_layout_params.find(layout.handle);
      if (pair == device_data->pipeline_layout_params.end()) {
        reshade::log::message(reshade::log::level::error, "Could not find handle.");
        // add warning
        return;
      }
      auto layout_params = pair->second;
      param = layout_params[layout_param];
      fetched_param = true;
    }

    uint32_t dx_register_index = param.push_constants.dx_register_index;
    uint32_t dx_register_space = param.push_constants.dx_register_space;
    auto buffer_range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
    auto slot = std::pair<uint32_t, uint32_t>(dx_register_index + update.binding + i, dx_register_space);
  }
}

inline std::vector<uint8_t> GetResourceCache(reshade::api::device* device, reshade::api::resource resource) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return {};
  std::shared_lock read_lock(data->mutex);
  auto pair = data->buffer_cache.find(resource.handle);
  if (pair != data->buffer_cache.end()) return pair->second;
  return {};
}

inline std::vector<uint8_t> GetResourceHistory(reshade::api::device* device, reshade::api::resource resource) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return {};
  std::shared_lock read_lock(data->mutex);
  auto pair = data->buffer_history.find(resource.handle);
  if (pair != data->buffer_history.end()) return pair->second;
  return {};
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      reshade::log::message(reshade::log::level::info, "utils::constants attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::register_event<reshade::addon_event::push_constants>(OnPushConstants);
      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);

      reshade::register_event<reshade::addon_event::map_buffer_region>(OnMapBufferRegion);
      reshade::register_event<reshade::addon_event::unmap_buffer_region>(OnUnmapBufferRegion);
      reshade::register_event<reshade::addon_event::update_buffer_region>(OnUpdateBufferRegion);

      break;

    case DLL_PROCESS_DETACH:

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::unregister_event<reshade::addon_event::push_constants>(OnPushConstants);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      break;
  }
}

}  // namespace renodx::utils::constants