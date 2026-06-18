/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <atomic>
#include <cstdint>
#include <cstring>
#include <span>
#include <utility>
#include <vector>
#if defined(DEBUG_LEVEL_2)
#include <sstream>
#endif

#include <gtl/phmap.hpp>
#include <include/reshade.hpp>

#include "./bitwise.hpp"
#include "./cross_addon.hpp"
#include "./data.hpp"

#if defined(DEBUG_LEVEL_2)
#include "./format.hpp"
#endif
#include "./pipeline_layout.hpp"

namespace renodx::utils::constants {

static std::atomic_bool capture_constant_buffers = false;
static std::atomic_bool capture_push_descriptors = false;

struct BufferRangeData {
  cross_addon::vector<uint8_t> cache;
  cross_addon::vector<uint8_t> history;
  std::span<uint8_t> mapping;  // only available when mappped
};

struct BoundSlotData {
  reshade::api::pipeline_layout layout = {0u};
  uint32_t param_index = 0;
  reshade::api::shader_stage stages = reshade::api::shader_stage(0u);
  reshade::api::buffer_range buffer_range = {};
  reshade::api::descriptor_table_update update = {};
};

using BufferRangeDataMap = cross_addon::parallel_node_hash_map<uint64_t, BufferRangeData>;

struct __declspec(uuid("1aa69bfe-5467-47e1-9c8e-c6b935198169")) SharedData {
  BufferRangeDataMap buffer_range_data;
  bool capture_constant_buffers = false;
  bool capture_push_descriptors = false;
};

static cross_addon::Shared<SharedData> shared;

struct __declspec(uuid("f8805bac-a932-49ef-b0c9-e4db1a8b33fc")) CommandListData {
  data::ParallelNodeHashMap<std::tuple<uint8_t, uint8_t, reshade::api::shader_stage>, BoundSlotData> bound_slots;
};

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (!shared.data->capture_push_descriptors) return;
  cmd_list->destroy_private_data<CommandListData>();
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (!shared.data->capture_push_descriptors) return;
  cmd_list->create_private_data<CommandListData>();
}

static void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (!shared.data->capture_constant_buffers) return;

  if (desc.type != reshade::api::resource_type::buffer) return;

  if (!renodx::utils::bitwise::HasFlag(desc.usage, reshade::api::resource_usage::constant_buffer)) return;

  if (initial_data == nullptr) {
    if (desc.buffer.size > 64 * 1024) {
      // Invalid size?
      shared.data->buffer_range_data.erase(resource.handle);
      return;
    }
    shared.data->buffer_range_data[resource.handle] = {
        .cache = cross_addon::vector<uint8_t>(desc.buffer.size, 0),
        .history = {},
        .mapping = {},
    };
  } else {
    shared.data->buffer_range_data[resource.handle] = {
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
  if (!shared.data->capture_constant_buffers) return;

  shared.data->buffer_range_data.modify_if(resource.handle, [&](std::pair<const uint64_t, BufferRangeData>& pair) {
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
  if (!shared.data->capture_constant_buffers) return;

  shared.data->buffer_range_data.modify_if(resource.handle, [&](std::pair<const uint64_t, BufferRangeData>& pair) {
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
  if (!shared.data->capture_constant_buffers) return;
  shared.data->buffer_range_data.modify_if(resource.handle, [&](std::pair<const uint64_t, BufferRangeData>& pair) {
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
  if (!shared.data->capture_constant_buffers) return false;

  shared.data->buffer_range_data.modify_if(resource.handle, [&](std::pair<const uint64_t, BufferRangeData>& pair) {
    if (size == UINT64_MAX) {
      pair.second.cache.resize(0);
      return;
    }
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
  if (update.type != reshade::api::descriptor_type::constant_buffer) return;
  if (!shared.data->capture_push_descriptors) return;
  auto* cmd_list_data = cmd_list->get_private_data<CommandListData>();
  if (cmd_list_data == nullptr) return;

  renodx::utils::pipeline_layout::GetPipelineLayoutData(layout, [&](const auto* layout_data) {
    if (layout_param >= layout_data->params.size()) {
      return;
    }

    const auto& param = layout_data->params[layout_param];
    for (uint32_t i = 0; i < update.count; i++) {
      uint32_t dx_register_index = param.push_constants.dx_register_index + update.binding + i;
      uint32_t dx_register_space = param.push_constants.dx_register_space;
      const auto& buffer_range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
      for (const auto stage : {
               reshade::api::shader_stage::vertex,
               reshade::api::shader_stage::pixel,
               reshade::api::shader_stage::compute,
           }) {
        if (!renodx::utils::bitwise::HasFlag(stages, stage)) continue;

        auto* data = &cmd_list_data->bound_slots[{dx_register_index, dx_register_space, stage}];
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
  });
}

inline std::vector<uint8_t> GetResourceCache(reshade::api::device* device, reshade::api::resource resource) {
  std::vector<uint8_t> value;
  shared.data->buffer_range_data.if_contains(resource.handle, [&](const std::pair<const uint64_t, BufferRangeData>& pair) {
    value.assign(pair.second.cache.begin(), pair.second.cache.end());
  });
  return value;
}

inline std::vector<uint8_t> GetResourceHistory(reshade::api::device* device, reshade::api::resource resource) {
  std::vector<uint8_t> value;
  shared.data->buffer_range_data.if_contains(resource.handle, [&](const std::pair<const uint64_t, BufferRangeData>& pair) {
    value.assign(pair.second.history.begin(), pair.second.history.end());
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

static bool RevertBufferRange(
    reshade::api::command_list* cmd_list,
    uint32_t dx_register_index,
    uint32_t dx_register_space = 0,
    reshade::api::shader_stage stage = reshade::api::shader_stage::pixel) {
  auto* cmd_list_data = cmd_list->get_private_data<CommandListData>();
  if (cmd_list_data == nullptr) {
    reshade::log::message(reshade::log::level::warning, "Could not find command list data.");
    return false;
  }

  auto it = cmd_list_data->bound_slots.find({dx_register_index, dx_register_space, stage});
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
      stage,
      data->layout,
      data->param_index,
      data->update);

  return true;
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (shared.RegisterModule([](SharedData& data) {
        if (capture_constant_buffers) {
          data.capture_constant_buffers = true;
        }
        if (capture_push_descriptors) {
          data.capture_push_descriptors = true;
        }
      })) {
        reshade::log::message(reshade::log::level::info, "utils::constants attached.");
      }
      shared.RegisterEvent<reshade::addon_event::init_command_list>(OnInitCommandList, capture_push_descriptors);
      shared.RegisterEvent<reshade::addon_event::destroy_command_list>(OnDestroyCommandList, capture_push_descriptors);
      shared.RegisterEvent<reshade::addon_event::push_descriptors>(OnPushDescriptors, capture_push_descriptors);

      shared.RegisterEvent<reshade::addon_event::init_resource>(OnInitResource, capture_constant_buffers);
      shared.RegisterEvent<reshade::addon_event::destroy_resource>(OnDestroyResource, capture_constant_buffers);
      shared.RegisterEvent<reshade::addon_event::push_constants>(OnPushConstants, capture_constant_buffers);
      shared.RegisterEvent<reshade::addon_event::map_buffer_region>(OnMapBufferRegion, capture_constant_buffers);
      shared.RegisterEvent<reshade::addon_event::unmap_buffer_region>(OnUnmapBufferRegion, capture_constant_buffers);
      shared.RegisterEvent<reshade::addon_event::update_buffer_region>(OnUpdateBufferRegion, capture_constant_buffers);

      break;

    case DLL_PROCESS_DETACH:
      shared.UnregisterEvent<reshade::addon_event::init_command_list>(OnInitCommandList);
      shared.UnregisterEvent<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      shared.UnregisterEvent<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      shared.UnregisterEvent<reshade::addon_event::init_resource>(OnInitResource);
      shared.UnregisterEvent<reshade::addon_event::destroy_resource>(OnDestroyResource);
      shared.UnregisterEvent<reshade::addon_event::push_constants>(OnPushConstants);
      shared.UnregisterEvent<reshade::addon_event::map_buffer_region>(OnMapBufferRegion);
      shared.UnregisterEvent<reshade::addon_event::unmap_buffer_region>(OnUnmapBufferRegion);
      shared.UnregisterEvent<reshade::addon_event::update_buffer_region>(OnUpdateBufferRegion);
      shared.UnregisterModule();
      break;
  }
}

}  // namespace renodx::utils::constants