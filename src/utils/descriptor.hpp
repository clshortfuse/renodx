/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <cstdio>

#include <shared_mutex>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <variant>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./hash.hpp"
#include "./pipeline_layout.hpp"

#ifdef DEBUG_LEVEL_1
#include "./format.hpp"
#endif

namespace renodx::utils::descriptor {

struct __declspec(uuid("018fa2c9-7a8b-76dc-bc84-87c53574223f")) DeviceData {
  // <descriptor_table.handle[index], <resourceView.handle>>
  std::unordered_map<std::pair<uint64_t, uint32_t>, reshade::api::descriptor_table_update, hash::HashPair> table_descriptor_resource_views;
  // Index of table_descriptor_resource_views
  std::unordered_map<uint64_t, std::unordered_set<std::pair<uint64_t, uint32_t>, hash::HashPair>*> resource_view_table_description_locations;
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

  std::shared_mutex mutex;
};

static std::shared_mutex mutex;

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

static reshade::api::descriptor_table_update ShrinkDescriptorUpdateWithResourceView(
    const reshade::api::descriptor_table_update update,
    uint32_t index = 0) {
  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view: {
      auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index];
      return reshade::api::descriptor_table_update{
          .table = update.table,
          .binding = update.binding + index,
          .count = 1,
          .type = update.type,
          .descriptors = new reshade::api::sampler_with_resource_view{item.sampler, item.view}};
    }
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::shader_resource_view:
    case reshade::api::descriptor_type::unordered_access_view:        {
      auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[index];
      return reshade::api::descriptor_table_update{
          .table = update.table,
          .binding = update.binding + index,
          .count = 1,
          .type = update.type,
          .descriptors = new reshade::api::resource_view{item.handle}};
    }
    default:
      break;
  }
  return reshade::api::descriptor_table_update{};
}

// Returns true if changed
static bool LogDescriptorTableResourceView(
    DeviceData& data,  // Should be mutex locked
    const reshade::api::descriptor_table table,
    const uint32_t index,
    const reshade::api::descriptor_table_update update = {}) {
  if (table.handle == 0) return false;

  auto primary_key = std::pair<uint64_t, uint32_t>(table.handle, index);

  auto view = GetResourceViewFromDescriptorUpdate(update, index);

  if (view.handle != 0) {
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "utils::descriptor::LogDescriptorTableResourceView("
        << reinterpret_cast<void*>(table.handle)
        << "[" << index << "]"
        << ", view " << reinterpret_cast<void*>(view.handle)
        << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
#endif
    auto shrunk_update = ShrinkDescriptorUpdateWithResourceView(update, index);
    if (
        auto record = data.table_descriptor_resource_views.find(primary_key);
        record != data.table_descriptor_resource_views.end()) {
      auto old_update = record->second;

      if (
          auto old_index_record = data.resource_view_table_description_locations.find(view.handle);
          old_index_record != data.resource_view_table_description_locations.end()) {
        auto* set = old_index_record->second;
        set->erase(primary_key);
      }
#ifdef DEBUG_LEVEL_1
      {
        std::stringstream s;
        s << "utils::descriptor::LogDescriptorTableResourceView("
          << reinterpret_cast<void*>(table.handle)
          << "[" << index << "]"
          << " replace shrunk view: "
          << shrunk_update.type
          << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
#endif

    } else {
      // Insert new record

#ifdef DEBUG_LEVEL_1
      {
        std::stringstream s;
        s << "utils::descriptor::LogDescriptorTableResourceView("
          << reinterpret_cast<void*>(table.handle)
          << "[" << index << "]"
          << " insert shrunk view: "
          << shrunk_update.type
          << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
#endif
    }
    data.table_descriptor_resource_views[primary_key] = shrunk_update;

    if (
        auto index_record = data.resource_view_table_description_locations.find(view.handle);
        index_record != data.resource_view_table_description_locations.end()) {
// Add entry to set
#ifdef DEBUG_LEVEL_1
      {
        std::stringstream s;
        s << "utils::descriptor::LogDescriptorTableResourceView(updating index "
          << reinterpret_cast<void*>(view.handle)
          << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
#endif
      index_record->second->emplace(primary_key);
    } else {
// Create new set with entry
#ifdef DEBUG_LEVEL_1
      {
        std::stringstream s;
        s << "utils::descriptor::LogDescriptorTableResourceView(creating index "
          << reinterpret_cast<void*>(view.handle)
          << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
#endif
      data.resource_view_table_description_locations.insert({view.handle, new std::unordered_set<std::pair<uint64_t, uint32_t>, hash::HashPair>{primary_key}});
    }
    return true;
  }

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "utils::descriptor::LogDescriptorTableResourceView(remove entry"
      << reinterpret_cast<void*>(table.handle)
      << "[" << index << "]"
      << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
#endif

  // Blank view (remove)
  if (
      auto record = data.table_descriptor_resource_views.find(primary_key);
      record != data.table_descriptor_resource_views.end()) {
    auto old_update = record->second;
    auto old_view = GetResourceViewFromDescriptorUpdate(old_update);
    if (old_view.handle != 0) {
      if (
          auto old_index_record = data.resource_view_table_description_locations.find(old_view.handle);
          old_index_record != data.resource_view_table_description_locations.end()) {
        auto* set = old_index_record->second;
        set->erase(primary_key);
      }
    }
    data.table_descriptor_resource_views.erase(record);
  }

  return false;
}

static void OnInitDevice(reshade::api::device* device) {
  device->create_private_data<DeviceData>();
}

static void OnDestroyDevice(reshade::api::device* device) {
  device->destroy_private_data<DeviceData>();
}

// Create DescriptorTables with RSVs
static bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (count == 0u) return false;

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  for (uint32_t i = 0; i < count; ++i) {
    const auto& update = updates[i];

    uint32_t offset;
    reshade::api::descriptor_heap heap;
    device->get_descriptor_heap_offset(update.table, update.binding, update.array_offset, &heap, &offset);

    auto& heap_data = data.heaps[heap.handle];

    if (offset + update.count > heap_data.size()) {
      heap_data.resize(offset + update.count);
    }

    for (uint32_t k = 0; k < update.count; ++k) {
      auto& descriptor = heap_data[offset + k];

      descriptor.first = update.type;
      reshade::api::resource_view rsv = {0};

      switch (update.type) {
        case reshade::api::descriptor_type::sampler:
          descriptor.second = static_cast<const reshade::api::sampler*>(update.descriptors)[k];
          break;
        case reshade::api::descriptor_type::sampler_with_resource_view:
          descriptor.second = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[k];
          rsv = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[k].view;
          break;
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::texture_shader_resource_view:
        case reshade::api::descriptor_type::texture_unordered_access_view:
          // case reshade::api::descriptor_type::shader_resource_view:
          // case reshade::api::descriptor_type::unordered_access_view:
          descriptor.second = static_cast<const reshade::api::resource_view*>(update.descriptors)[k];
          rsv = static_cast<const reshade::api::resource_view*>(update.descriptors)[k];
          break;
        case reshade::api::descriptor_type::constant_buffer:
        case reshade::api::descriptor_type::acceleration_structure:
        case reshade::api::descriptor_type::shader_storage_buffer:
          descriptor.second = static_cast<const reshade::api::buffer_range*>(update.descriptors)[k];
          break;
        default:
          break;
      }
    }
  }
  return false;
}

static bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (count == 0u) return false;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  for (uint32_t i = 0; i < count; ++i) {
    const reshade::api::descriptor_table_copy& copy = copies[i];

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
      << reinterpret_cast<void*>(copy.source_table.handle)
      << "[" << copy.source_binding << "] + " << copy.source_array_offset
      << " => "
      << reinterpret_cast<void*>(copy.dest_table.handle)
      << "[" << copy.dest_binding << "] + " << copy.dest_array_offset
      << ", src_heap: " << src_heap.handle << "[" << src_offset << "]"
      << ", dest_heap: " << dst_heap.handle << "[" << dst_offset << "]"
      << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

    auto& src_pool_data = data.heaps[src_heap.handle];
    auto& dst_pool_data = data.heaps[dst_heap.handle];

    if (dst_offset + copy.count > dst_pool_data.size()) {
      dst_pool_data.resize(dst_offset + copy.count);
    }

    for (uint32_t k = 0; k < copy.count; ++k) {
      dst_pool_data[dst_offset + k] = src_pool_data[src_offset + k];
    }
  }
  return false;
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

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
      reshade::unregister_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);

      break;
  }
}
}  // namespace renodx::utils::descriptor
