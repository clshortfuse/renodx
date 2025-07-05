/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cstdint>
#include <cstring>

#include <span>
#include <sstream>
#include <unordered_map>
#include <utility>
#include <vector>

#include <gtl/phmap.hpp>
#include <include/reshade.hpp>

#include "./bitwise.hpp"
#include "./data.hpp"
#include "./format.hpp"
#include "./pipeline_layout.hpp"

namespace renodx::utils::constants {

static std::atomic_bool capture_constant_buffers = false;
static std::atomic_bool capture_push_descriptors = false;

namespace internal {
static bool is_primary_hook = false;

static bool attached = false;
}  // namespace internal

struct BufferRangeData {
  std::vector<uint8_t> cache;
  std::vector<uint8_t> history;
  std::span<uint8_t> mapping;  // only available when mappped
};

struct BoundSlotData {
  reshade::api::pipeline_layout layout = {0u};
  uint32_t param_index = 0;
  reshade::api::shader_stage stages = reshade::api::shader_stage(0u);
  reshade::api::buffer_range buffer_range = {};
  reshade::api::descriptor_table_update update = {};
};

static struct Store {
  data::ParallelNodeHashMap<uint64_t, BufferRangeData> buffer_range_data;
} local_store;

static Store* store = &local_store;

struct __declspec(uuid("1aa69bfe-5467-47e1-9c8e-c6b935198169")) DeviceData {
  Store* store;
  std::unordered_map<uint64_t, std::vector<reshade::api::pipeline_layout_param>> pipeline_layout_params;
};

struct __declspec(uuid("f8805bac-a932-49ef-b0c9-e4db1a8b33fc")) CommandListData {
  data::ParallelNodeHashMap<std::pair<uint8_t, uint8_t>, BoundSlotData> bound_slots;
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
    data->store = store;
  } else {
    std::stringstream s;
    s << "utils::constants::OnInitDevice(Attaching to hook: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
    store = data->store;
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

  if (initial_data == nullptr) {
    if (desc.buffer.size > 64 * 1024) {
      // Invalid size?
      store->buffer_range_data.erase(resource.handle);
      return;
    }
    store->buffer_range_data[resource.handle] = {
        .cache = std::vector<uint8_t>(desc.buffer.size, 0),
        .history = {},
        .mapping = {},
    };
  } else {
    store->buffer_range_data[resource.handle] = {
        .cache = {
            static_cast<uint8_t*>(initial_data->data),
            static_cast<uint8_t*>(initial_data->data) + desc.buffer.size,
        },
        .history = {},
        .mapping = {},
    };
  }
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  if (!internal::is_primary_hook) return;
  if (!capture_constant_buffers) return;

  store->buffer_range_data.modify_if(resource.handle, [&](std::pair<const uint64_t, BufferRangeData>& pair) {
    pair.second = {
        .cache = {},
        .history = pair.second.cache,
        .mapping = {},
    };
  });
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

  store->buffer_range_data.modify_if(resource.handle, [&](std::pair<const uint64_t, BufferRangeData>& pair) {
    uint8_t* start = *(reinterpret_cast<uint8_t**>(mapped_data));
    if (size == UINT64_MAX) {
      auto desc = device->get_resource_desc(resource);
      pair.second.mapping = {
          start + offset,
          start + offset + desc.buffer.size};
    } else {
      pair.second.mapping = {
          start + offset,
          start + offset + size};
    }
  });
}

static void OnUnmapBufferRegion(
    reshade::api::device* device,
    reshade::api::resource resource) {
  if (!internal::is_primary_hook) return;
  if (!capture_constant_buffers) return;
  store->buffer_range_data.modify_if(resource.handle, [&](std::pair<const uint64_t, BufferRangeData>& pair) {
    if (pair.second.mapping.empty()) {
      std::ranges::fill(pair.second.cache, 0);
    } else {
      pair.second.cache.assign(pair.second.mapping.begin(), pair.second.mapping.end());
    }
    pair.second.mapping = {};
  });
}

static bool OnUpdateBufferRegion(
    reshade::api::device* device,
    const void* buffer_data, reshade::api::resource resource,
    uint64_t offset, uint64_t size) {
  if (!internal::is_primary_hook) return false;
  if (!capture_constant_buffers) return false;

  store->buffer_range_data.modify_if(resource.handle, [&](std::pair<const uint64_t, BufferRangeData>& pair) {
    if (pair.second.cache.size() < offset + size) {
      pair.second.cache.resize(offset + size, 0);
    }
    memcpy(pair.second.cache.data() + offset, static_cast<const uint8_t*>(buffer_data) + offset, size);
  });

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
  if (!capture_push_descriptors) return;
  auto* cmd_list_data = cmd_list->get_private_data<CommandListData>();
  if (cmd_list_data == nullptr) return;

  renodx::utils::pipeline_layout::PipelineLayoutData* layout_data = nullptr;
  for (uint32_t i = 0; i < update.count; i++) {
    if (update.type != reshade::api::descriptor_type::constant_buffer) continue;

    if (layout_data == nullptr) {
      layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(layout, true);
      if (layout_data == nullptr) {
        assert(layout_data != nullptr);
        return;
      }
    }

    auto& param = layout_data->params[layout_param];

    uint32_t dx_register_index = param.push_constants.dx_register_index + update.binding + i;
    uint32_t dx_register_space = param.push_constants.dx_register_space;
    const auto& buffer_range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
    auto slot = std::pair<uint32_t, uint32_t>(dx_register_index, dx_register_space);
    auto* data = &cmd_list_data->bound_slots[slot];
    data->layout = layout;
    data->param_index = layout_param;
    data->stages = stages;
    data->buffer_range = buffer_range;
    data->update = update;
    data->update.binding = update.binding + i;
    data->update.descriptors = &data->buffer_range;

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::constants::OnPushDescriptors(";
      s << PRINT_PTR(data->layout.handle);
      s << "[" << data->param_index << "]";
      s << "[" << data->update.binding << "]";
      s << ", dx_register_index: " << dx_register_index;
      s << ", dx_register_space: " << dx_register_space;
      s << ", stages: " << data->stages;
      s << ", buffer_range: " << PRINT_PTR(data->buffer_range.buffer.handle);
      if (data->buffer_range.size == UINT64_MAX) {
        s << "[all]";
      } else if (data->buffer_range.size == 0) {
        s << "[empty]";
      } else {
        s << "[" << data->buffer_range.offset;
        s << " - " << data->buffer_range.offset + data->buffer_range.size << "]";
      }
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
  }
}

inline std::vector<uint8_t> GetResourceCache(reshade::api::device* device, reshade::api::resource resource) {
  std::vector<uint8_t> value;
  store->buffer_range_data.if_contains(resource.handle, [&](const std::pair<const uint64_t, BufferRangeData>& pair) {
    value = pair.second.cache;
  });
  return value;
}

inline std::vector<uint8_t> GetResourceHistory(reshade::api::device* device, reshade::api::resource resource) {
  std::vector<uint8_t> value;
  store->buffer_range_data.if_contains(resource.handle, [&](const std::pair<const uint64_t, BufferRangeData>& pair) {
    value = pair.second.history;
  });
  return value;
}

inline void PushShaderInjections(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param = 0,
    bool is_dispatch = false,
    std::span<float> shader_injection = {},
    uint32_t offset = 0.f,
    float* resource_tag_float = nullptr,
    float resource_tag = 0.f) {
  auto device_api = cmd_list->get_device()->get_api();
  bool use_root_constants = (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan);

#ifdef DEBUG_LEVEL_2
  std::stringstream s;
  s << "utils::constants::PushShaderInjections(";
  s << "layout: " << PRINT_PTR(layout.handle) << "[" << layout_param << "]";
  s << ", dispatch: " << (is_dispatch ? "true" : "false");
  s << ", resource_tag: " << resource_tag;
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

  if (resource_tag_float != nullptr) {
    // const std::unique_lock lock(renodx::utils::mutex::global_mutex);
    *resource_tag_float = resource_tag;
  }

  reshade::api::shader_stage shader_stage;
  if (device_api == reshade::api::device_api::d3d9) {
    shader_stage = reshade::api::shader_stage::pixel;
  } else if (is_dispatch) {
    shader_stage = reshade::api::shader_stage::all_compute;
  } else {
    shader_stage = reshade::api::shader_stage::all_graphics;
  }

  // const std::shared_lock lock(renodx::utils::mutex::global_mutex);
  cmd_list->push_constants(
      shader_stage,
      layout,
      layout_param,
      offset,
      shader_injection.size(),
      shader_injection.data());
}

static bool RevertBufferRange(reshade::api::command_list* cmd_list, uint32_t dx_register_index, uint32_t dx_register_space = 0) {
  auto* cmd_list_data = cmd_list->get_private_data<CommandListData>();
  if (cmd_list_data == nullptr) {
    reshade::log::message(reshade::log::level::warning, "Could not find command list data.");
    return false;
  }

  auto slot = std::pair<uint32_t, uint32_t>(dx_register_index, dx_register_space);
  auto it = cmd_list_data->bound_slots.find(slot);
  if (it == cmd_list_data->bound_slots.end()) return false;
  auto* data = &it->second;

#ifdef DEBUG_LEVEL_2
  {
    std::stringstream s;
    s << "utils::constants::RevertBufferRange(";
    s << PRINT_PTR(data->layout.handle);
    s << "[" << data->param_index << "]";
    s << "[" << data->update.binding << "]";
    s << ", dx_register_index: " << dx_register_index;
    s << ", dx_register_space: " << dx_register_space;
    s << ", stages: " << data->stages;
    s << ", buffer_range: " << PRINT_PTR(data->buffer_range.buffer.handle);
    if (data->buffer_range.size == UINT64_MAX) {
      s << "[all]";
    } else if (data->buffer_range.size == 0) {
      s << "[empty]";
    } else {
      s << "[" << data->buffer_range.offset;
      s << " - " << data->buffer_range.offset + data->buffer_range.size << "]";
    }
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
#endif

  cmd_list->push_descriptors(
      data->stages,
      data->layout,
      data->param_index,
      data->update);

  return true;
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      reshade::log::message(reshade::log::level::info, "utils::constants attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      if (capture_push_descriptors) {
        reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
        reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
        reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      }
      if (capture_constant_buffers) {
        reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
        reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
        reshade::register_event<reshade::addon_event::push_constants>(OnPushConstants);
        reshade::register_event<reshade::addon_event::map_buffer_region>(OnMapBufferRegion);
        reshade::register_event<reshade::addon_event::unmap_buffer_region>(OnUnmapBufferRegion);
        reshade::register_event<reshade::addon_event::update_buffer_region>(OnUpdateBufferRegion);
      }

      break;

    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::unregister_event<reshade::addon_event::push_constants>(OnPushConstants);
      reshade::unregister_event<reshade::addon_event::map_buffer_region>(OnMapBufferRegion);
      reshade::unregister_event<reshade::addon_event::unmap_buffer_region>(OnUnmapBufferRegion);
      reshade::unregister_event<reshade::addon_event::update_buffer_region>(OnUpdateBufferRegion);
      break;
  }
}

}  // namespace renodx::utils::constants