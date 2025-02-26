/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <atomic>
#include <cassert>
#include <cstdio>

#include <shared_mutex>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <variant>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./data.hpp"
#include "./hash.hpp"
#include "./pipeline_layout.hpp"
#if defined(DEBUG_LEVEL_1) || defined(DEBUG_LEVEL_2)
#include "./format.hpp"
#endif

namespace renodx::utils::descriptor {

static bool is_primary_hook = false;
static std::atomic_bool trace_descriptor_tables = false;

struct __declspec(uuid("018fa2c9-7a8b-76dc-bc84-87c53574223f")) DeviceData {
  // <descriptor_table.handle[index], <resourceView.handle>>
  std::unordered_map<std::pair<uint64_t, uint32_t>, reshade::api::descriptor_table_update, hash::HashPair> table_descriptor_resource_views;
  std::unordered_map<
      uint64_t,
      std::vector<
          std::pair<
              reshade::api::descriptor_type,
              std::variant<
                  reshade::api::sampler,
                  reshade::api::sampler_with_resource_view,
                  reshade::api::resource_view,
                  reshade::api::buffer_range>>>>
      heaps;
  std::unordered_map<uint64_t, std::unordered_set<uint32_t>> resource_view_heap_locations;

  bool trace_descriptor_tables = false;
  std::shared_mutex mutex;
};

static reshade::api::resource_view GetResourceViewFromDescriptorUpdate(
    const reshade::api::descriptor_table_update update,
    uint32_t index = 0) {
  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view: {
      auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index];
      return item.view;
    }
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::shader_resource_view:
    case reshade::api::descriptor_type::unordered_access_view:        {
      auto resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[index];
      return resource_view;
    }
    default:
      break;
  }
  return reshade::api::resource_view{0};
}

static void OnInitDevice(reshade::api::device* device) {
  DeviceData* data;
  bool created = renodx::utils::data::CreateOrGet(device, data);
  if (!created) {
    trace_descriptor_tables = data->trace_descriptor_tables;
    return;
  }

  data->trace_descriptor_tables = trace_descriptor_tables;

  is_primary_hook = true;
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (!is_primary_hook) return;
  device->destroy_private_data<DeviceData>();
}

// Create DescriptorTables with RSVs
static bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (!is_primary_hook) return false;
  if (count == 0u) return false;
  if (!trace_descriptor_tables) return false;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  const std::unique_lock lock(data->mutex);

  if (!data->trace_descriptor_tables) return false;

  for (uint32_t i = 0; i < count; ++i) {
    const auto& update = updates[i];

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::descriptor::OnUpdateDescriptorTables(Getting heap: "
        << static_cast<uintptr_t>(update.table.handle)
        << "[" << update.binding << "] + " << update.array_offset
        << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif

    uint32_t offset;
    reshade::api::descriptor_heap heap;
    device->get_descriptor_heap_offset(update.table, update.binding, update.array_offset, &heap, &offset);

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::descriptor::OnUpdateDescriptorTables(Got heap: "
        << static_cast<uintptr_t>(update.table.handle)
        << "[" << update.binding << "] + " << update.array_offset
        << " = " << static_cast<uintptr_t>(heap.handle)
        << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif

    auto& heap_data = data->heaps[heap.handle];
    auto& heap_set = data->resource_view_heap_locations[heap.handle];

    auto total_size = offset + update.count;
    if (total_size > heap_data.size()) {
#ifdef DEBUG_LEVEL_2
      std::stringstream s;
      s << "utils::descriptor::OnUpdateDescriptorTables(Heap ";
      s << static_cast<uintptr_t>(heap.handle);
      s << " resized ";
      s << heap_data.size() << " => " << total_size;
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      heap_data.resize(total_size);
    }

    for (uint32_t k = 0; k < update.count; ++k) {
      auto& descriptor = heap_data[offset + k];

      descriptor.first = update.type;

#ifdef DEBUG_LEVEL_2

      std::stringstream s;
      s << "utils::descriptor::OnUpdateDescriptorTables(Log heap: ";
      s << static_cast<uintptr_t>(heap.handle);
      s << "[" << offset + k << "]:";
#endif

      switch (update.type) {
        case reshade::api::descriptor_type::sampler:
          descriptor.second = static_cast<const reshade::api::sampler*>(update.descriptors)[k];
#ifdef DEBUG_LEVEL_2
          s << reinterpret_cast<uintptr_t>(static_cast<const reshade::api::sampler*>(update.descriptors)[k].handle);
#endif
          break;
        case reshade::api::descriptor_type::sampler_with_resource_view:
          descriptor.second = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[k];

#ifdef DEBUG_LEVEL_2
          s << reinterpret_cast<uintptr_t>(static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[k].view.handle);
#endif
          break;
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::texture_shader_resource_view:
        case reshade::api::descriptor_type::texture_unordered_access_view:
          // case reshade::api::descriptor_type::shader_resource_view:
          // case reshade::api::descriptor_type::unordered_access_view:
          descriptor.second = static_cast<const reshade::api::resource_view*>(update.descriptors)[k];
          heap_set.emplace(offset + k);
#ifdef DEBUG_LEVEL_2
          s << reinterpret_cast<uintptr_t>(static_cast<const reshade::api::resource_view*>(update.descriptors)[k].handle);
#endif
          break;
        case reshade::api::descriptor_type::constant_buffer:
        case reshade::api::descriptor_type::acceleration_structure:
        case reshade::api::descriptor_type::shader_storage_buffer:
          descriptor.second = static_cast<const reshade::api::buffer_range*>(update.descriptors)[k];
          break;
        default:
          break;
      }
#ifdef DEBUG_LEVEL_2
      s << " (" << update.type << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    }
  }
  return false;
}

static bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (!is_primary_hook) return false;
  if (count == 0u) return false;
  if (!trace_descriptor_tables) return false;
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  const std::unique_lock lock(data->mutex);
  if (!data->trace_descriptor_tables) return false;

  for (uint32_t i = 0; i < count; ++i) {
    const reshade::api::descriptor_table_copy& copy = copies[i];

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::descriptor::OnCopyDescriptorTables(Getting heap: "
        << static_cast<uintptr_t>(copy.source_table.handle)
        << "[" << copy.source_binding << "] + " << copy.source_array_offset
        << " => "
        << static_cast<uintptr_t>(copy.dest_table.handle)
        << "[" << copy.dest_binding << "] + " << copy.dest_array_offset
        << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif

    uint32_t src_offset;
    reshade::api::descriptor_heap src_heap;
    device->get_descriptor_heap_offset(
        copy.source_table,
        copy.source_binding,
        copy.source_array_offset,
        &src_heap, &src_offset);

    uint32_t dst_offset;
    reshade::api::descriptor_heap dst_heap;
    device->get_descriptor_heap_offset(
        copy.dest_table,
        copy.dest_binding,
        copy.dest_array_offset,
        &dst_heap, &dst_offset);
#ifdef DEBUG_LEVEL_2
    std::stringstream s;
    s << "utils::descriptor::OnCopyDescriptorTables(copy descriptor table entry: "
      << static_cast<uintptr_t>(copy.source_table.handle)
      << "[" << copy.source_binding << "] + " << copy.source_array_offset
      << " => "
      << static_cast<uintptr_t>(copy.dest_table.handle)
      << "[" << copy.dest_binding << "] + " << copy.dest_array_offset
      << ", src_heap: " << static_cast<uintptr_t>(src_heap.handle) << "[" << src_offset << "]"
      << ", dest_heap: " << static_cast<uintptr_t>(dst_heap.handle) << "[" << dst_offset << "]"
      << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

    auto& src_pool_data = data->heaps[src_heap.handle];
    auto& src_known = data->resource_view_heap_locations[src_heap.handle];
    auto& dst_pool_data = data->heaps[dst_heap.handle];
    auto& dest_known = data->resource_view_heap_locations[dst_heap.handle];

    auto min_source_size = src_offset + copy.count;
    assert(min_source_size <= src_pool_data.size());

    auto total_size = dst_offset + copy.count;
    if (total_size > dst_pool_data.size()) {
#ifdef DEBUG_LEVEL_2
      std::stringstream s;
      s << "utils::descriptor::OnCopyDescriptorTables(Destination Heap ";
      s << static_cast<uintptr_t>(dst_heap.handle);
      s << " resized ";
      s << dst_pool_data.size() << " => " << total_size;
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      dst_pool_data.resize(total_size);
    }

    for (uint32_t k = 0; k < copy.count; ++k) {
      dst_pool_data[dst_offset + k] = src_pool_data[src_offset + k];
      if (src_known.contains(src_offset + k)) {
        dest_known.emplace(dst_offset + k);
      }
    }
  }
  return false;
}

static void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  if (!is_primary_hook) return;
  if (!trace_descriptor_tables) return;
  if (count == 0u) return;
  auto* device = cmd_list->get_device();
  auto* layout_data = pipeline_layout::GetPipelineLayoutData(layout);

  assert(layout_data != nullptr);

  auto& info = *layout_data;
  for (uint32_t i = 0; i < count; ++i) {
    const auto layout_index = first + i;

    assert(layout_index < info.params.size());
    const auto& param = info.params.at(layout_index);
    assert(param.type == reshade::api::pipeline_layout_param_type::descriptor_table
           || param.type == reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers);

    info.tables[layout_index] = tables[i];
  }
}

static reshade::api::descriptor_table_update* CloneDescriptorTableUpdates(
    const reshade::api::descriptor_table_update* updates,
    uint32_t count) {
  const size_t size = sizeof(reshade::api::descriptor_table_update) * count;
  auto* clone = static_cast<reshade::api::descriptor_table_update*>(malloc(size));
  memcpy(clone, updates, size);
  for (size_t i = 0; i < count; ++i) {
    const auto& update = updates[i];
    size_t descriptor_size = 0;
    switch (update.type) {
      case reshade::api::descriptor_type::sampler:
        descriptor_size = sizeof(reshade::api::sampler) * update.count;
        break;
      case reshade::api::descriptor_type::sampler_with_resource_view:
        descriptor_size = sizeof(reshade::api::sampler_with_resource_view) * update.count;
        break;
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::unordered_access_view:
        descriptor_size = sizeof(reshade::api::resource_view) * update.count;
        break;
      case reshade::api::descriptor_type::constant_buffer:
      case reshade::api::descriptor_type::shader_storage_buffer:
        descriptor_size = sizeof(reshade::api::buffer_range) * update.count;
        break;
      case reshade::api::descriptor_type::acceleration_structure:
        descriptor_size = sizeof(reshade::api::resource_view) * update.count;
        break;
      default:
        break;
    }
    clone[i].descriptors = malloc(descriptor_size);
    memcpy(const_cast<void*>(clone[i].descriptors), update.descriptors, descriptor_size);
  }
  return clone;
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  utils::pipeline_layout::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "DescriptorTableUtil attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
      reshade::register_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
      reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
      reshade::unregister_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
      reshade::unregister_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);

      break;
  }
}
}  // namespace renodx::utils::descriptor
