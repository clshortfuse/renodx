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
#include <span>
#include <unordered_map>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "./cross_addon.hpp"
#include "./data.hpp"
#include "./hash.hpp"
#if defined(DEBUG_LEVEL_1) || defined(DEBUG_LEVEL_2)
#include "./format.hpp"
#endif

namespace renodx::utils::descriptor {

static std::atomic_bool trace_descriptor_tables = false;

struct AllocatedLayoutDescriptorTables {
  reshade::api::device* device = nullptr;
  cross_addon::vector<reshade::api::descriptor_table> tables;
};

struct __declspec(uuid("9c947e94-c631-4baf-b0e8-044d2cdf7426")) SharedData {
  bool trace_descriptor_tables = false;
  cross_addon::parallel_node_hash_map<uint64_t, AllocatedLayoutDescriptorTables, std::shared_mutex>
      allocated_descriptor_tables_by_layout;
};

static cross_addon::Shared<SharedData> shared;

struct DescriptorHeapSlot {
  reshade::api::descriptor_type type = reshade::api::descriptor_type::sampler;
  union {
    reshade::api::resource_view resource_view;
    reshade::api::buffer_range buffer_range;
  };

  constexpr DescriptorHeapSlot() : resource_view({0}) {}

  [[nodiscard]] static constexpr bool HasResourceViewType(
      reshade::api::descriptor_type type) noexcept {
    switch (type) {
      case reshade::api::descriptor_type::sampler_with_resource_view:
      case reshade::api::descriptor_type::texture_shader_resource_view:
      case reshade::api::descriptor_type::texture_unordered_access_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::acceleration_structure:
        return true;
      default:
        return false;
    }
  }

  [[nodiscard]] constexpr bool HasResourceView() const noexcept {
    return HasResourceViewType(type);
  }
};

struct __declspec(uuid("018fa2c9-7a8b-76dc-bc84-87c53574223f")) DeviceData {
  // <descriptor_table.handle[index], <resourceView.handle>>
  std::unordered_map<std::pair<uint64_t, uint32_t>, reshade::api::descriptor_table_update, hash::HashPair> table_descriptor_resource_views;
  std::unordered_map<uint64_t, std::vector<DescriptorHeapSlot>> heaps;

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
    case reshade::api::descriptor_type::texture_shader_resource_view:
    case reshade::api::descriptor_type::texture_unordered_access_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::acceleration_structure:        {
      auto resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[index];
      return resource_view;
    }
    default:
      break;
  }
  return reshade::api::resource_view{0};
}

static reshade::api::descriptor_table_update CloneDescriptorUpdateWithResourceView(
    const reshade::api::descriptor_table_update& update,
    const reshade::api::resource_view& view,
    const uint32_t& index = 0) {
  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view: {
      auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index];
      return reshade::api::descriptor_table_update{
          .table = update.table,
          .binding = update.binding + index,
          .count = 1,
          .type = update.type,
          .descriptors = new reshade::api::sampler_with_resource_view{
              .sampler = item.sampler,
              .view = view,
          },
      };
    }
    case reshade::api::descriptor_type::texture_shader_resource_view:
    case reshade::api::descriptor_type::texture_unordered_access_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::acceleration_structure:        {
      return reshade::api::descriptor_table_update{
          .table = update.table,
          .binding = update.binding + index,
          .count = 1,
          .type = update.type,
          .descriptors = new reshade::api::resource_view{view.handle},
      };
    }
    default:
      break;
  }
  return {};
}

static bool FlushResourceViewInDescriptorTable(
    reshade::api::device* device,
    const reshade::api::resource& resource) {
  return true;
}

static void OnInitDevice(reshade::api::device* device) {
  renodx::utils::data::Create<DeviceData>(device);
}

// Create DescriptorTables with RSVs
static bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (count == 0u) return false;
  if (!shared.data->trace_descriptor_tables) return false;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return false;
  const std::unique_lock lock(data->mutex);

  for (uint32_t i = 0; i < count; ++i) {
    const auto& update = updates[i];

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::descriptor::OnUpdateDescriptorTables(Getting heap: "
        << PRINT_PTR(update.table.handle)
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
        << PRINT_PTR(update.table.handle)
        << "[" << update.binding << "] + " << update.array_offset
        << " = " << PRINT_PTR(heap.handle)
        << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif

    auto& heap_data = data->heaps[heap.handle];

    auto total_size = offset + update.count;
    if (total_size > heap_data.size()) {
#ifdef DEBUG_LEVEL_2
      std::stringstream s;
      s << "utils::descriptor::OnUpdateDescriptorTables(Heap ";
      s << PRINT_PTR(heap.handle);
      s << " resized ";
      s << heap_data.size() << " => " << total_size;
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      heap_data.resize(total_size);
    }

    for (uint32_t k = 0; k < update.count; ++k) {
      auto& descriptor = heap_data[offset + k];
      descriptor.type = update.type;
      descriptor.resource_view = {0};

#ifdef DEBUG_LEVEL_2

      std::stringstream s;
      s << "utils::descriptor::OnUpdateDescriptorTables(Log heap: ";
      s << PRINT_PTR(heap.handle);
      s << "[" << offset + k << "]: ";
#endif

      switch (update.type) {
        case reshade::api::descriptor_type::sampler:
#ifdef DEBUG_LEVEL_2
          s << PRINT_PTR(static_cast<const reshade::api::sampler*>(update.descriptors)[k].handle);
#endif
          break;
        case reshade::api::descriptor_type::sampler_with_resource_view:
          descriptor.resource_view = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[k].view;
#ifdef DEBUG_LEVEL_2
          s << PRINT_PTR(static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[k].view.handle);
#endif
          break;
        case reshade::api::descriptor_type::texture_shader_resource_view:
        case reshade::api::descriptor_type::texture_unordered_access_view:
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::acceleration_structure:
          descriptor.resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[k];
#ifdef DEBUG_LEVEL_2
          s << PRINT_PTR(static_cast<const reshade::api::resource_view*>(update.descriptors)[k].handle);
#endif
          break;
        case reshade::api::descriptor_type::constant_buffer:
        case reshade::api::descriptor_type::shader_storage_buffer:
          descriptor.buffer_range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[k];
#ifdef DEBUG_LEVEL_2
          s << PRINT_PTR(static_cast<const reshade::api::buffer_range*>(update.descriptors)[k].buffer.handle);
#endif
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
  if (count == 0u) return false;
  if (!shared.data->trace_descriptor_tables) return false;
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return false;
  const std::unique_lock lock(data->mutex);

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
    auto& dst_pool_data = data->heaps[dst_heap.handle];

    auto min_source_size = src_offset + copy.count;
    if (min_source_size > src_pool_data.size()) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "utils::descriptor::OnCopyDescriptorTables(Source Heap ";
      s << static_cast<uintptr_t>(src_heap.handle);
      s << " undersized ";
      s << src_pool_data.size() << " => " << min_source_size;
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
      continue;
    }

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
      case reshade::api::descriptor_type::texture_shader_resource_view: // shader_resource_view alias
      case reshade::api::descriptor_type::texture_unordered_access_view: // unordered_access_view alias
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::acceleration_structure:
        descriptor_size = sizeof(reshade::api::resource_view) * update.count;
        break;
      case reshade::api::descriptor_type::constant_buffer:
      case reshade::api::descriptor_type::shader_storage_buffer:
#if RESHADE_API_VERSION >= 20
      case reshade::api::descriptor_type::constant_buffer_with_dynamic_offset:
      case reshade::api::descriptor_type::shader_storage_buffer_with_dynamic_offset:
#else
      case static_cast<reshade::api::descriptor_type>(8u):  // VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC
      case static_cast<reshade::api::descriptor_type>(9u):  // VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC
#endif
        descriptor_size = sizeof(reshade::api::buffer_range) * update.count;
        break;
      default:
        break;
    }
    // Use nullptr for unknown descriptor types so DestroyDescriptorTableUpdates
    // does not attempt to free caller-owned memory.
    if (descriptor_size == 0) {
      clone[i].descriptors = nullptr;
    } else {
      clone[i].descriptors = malloc(descriptor_size);
      memcpy(const_cast<void*>(clone[i].descriptors), update.descriptors, descriptor_size);
    }
  }
  return clone;
}

static void DestroyDescriptorTableUpdates(std::span<reshade::api::descriptor_table_update> updates) {
  for (auto& update : updates) {
    free(const_cast<void*>(update.descriptors));
    update.descriptors = nullptr;
  }
}

static void DestroyDescriptorTableUpdates(reshade::api::descriptor_table_update* updates, uint32_t count) {
  if (updates == nullptr) return;
  DestroyDescriptorTableUpdates({updates, updates + count});
  free(updates);
}

static void FreeDescriptorTables(
    reshade::api::device* device,
    std::span<const reshade::api::descriptor_table> descriptor_tables) {
  std::vector<reshade::api::descriptor_table> valid_tables;
  valid_tables.reserve(descriptor_tables.size());
  for (const auto table : descriptor_tables) {
    if (table.handle != 0u) valid_tables.push_back(table);
  }
  if (!valid_tables.empty()) {
    device->free_descriptor_tables(static_cast<uint32_t>(valid_tables.size()), valid_tables.data());
  }
}

static void FreeAllocatedDescriptorTables(
    reshade::api::device* device,
    const reshade::api::pipeline_layout& layout) {
  if (layout.handle == 0u) return;
  shared.data->allocated_descriptor_tables_by_layout.erase_if(layout.handle, [&](auto& pair) {
    FreeDescriptorTables(device, pair.second.tables);
    return true;
  });
}

[[nodiscard]] static bool GetAllocatedDescriptorTable(
    const reshade::api::pipeline_layout& layout,
    uint32_t layout_param,
    reshade::api::descriptor_table* out_table) {
  if (layout.handle == 0u || out_table == nullptr) return false;
  bool found = false;
  shared.data->allocated_descriptor_tables_by_layout.if_contains(layout.handle, [&](const auto& pair) {
    if (layout_param >= pair.second.tables.size()) return;
    if (pair.second.tables[layout_param].handle == 0u) return;
    *out_table = pair.second.tables[layout_param];
    found = true;
  });
  return found;
}

[[nodiscard]] static bool GetOrAllocateDescriptorTable(
    reshade::api::device* device,
    const reshade::api::pipeline_layout& cache_layout,
    const reshade::api::pipeline_layout& allocation_layout,
    uint32_t layout_param,
    reshade::api::descriptor_table* out_table) {
  if (device == nullptr || cache_layout.handle == 0u || allocation_layout.handle == 0u || out_table == nullptr) {
    return false;
  }
  if (GetAllocatedDescriptorTable(cache_layout, layout_param, out_table)) return true;

  reshade::api::descriptor_table table = {};
  if (!device->allocate_descriptor_table(allocation_layout, layout_param, &table) || table.handle == 0u) {
    return false;
  }

  shared.data->allocated_descriptor_tables_by_layout.lazy_emplace_l(
      cache_layout.handle,
      [&](auto& pair) {
        pair.second.device = device;
        if (pair.second.tables.size() <= layout_param) {
          pair.second.tables.resize(layout_param + 1u);
        }
        pair.second.tables[layout_param] = table;
      },
      [&](const auto& ctor) {
        AllocatedLayoutDescriptorTables data = {.device = device};
        data.tables.resize(layout_param + 1u);
        data.tables[layout_param] = table;
        ctor(cache_layout.handle, std::move(data));
      });

  *out_table = table;
  return true;
}

static void OnDestroyDevice(reshade::api::device* device) {
  cross_addon::vector<uint64_t> layout_handles;
  shared.data->allocated_descriptor_tables_by_layout.for_each([&](const auto& pair) {
    if (pair.second.device != device) return;
    FreeDescriptorTables(device, pair.second.tables);
    layout_handles.push_back(pair.first);
  });
  for (const auto layout_handle : layout_handles) {
    shared.data->allocated_descriptor_tables_by_layout.erase(layout_handle);
  }
  renodx::utils::data::Delete<DeviceData>(device);
}

static void OnDestroyPipelineLayout(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout) {
  FreeAllocatedDescriptorTables(device, layout);
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (shared.RegisterModule([](SharedData& data) {
        data.trace_descriptor_tables = data.trace_descriptor_tables || trace_descriptor_tables;
      })) {
        reshade::log::message(reshade::log::level::info, "DescriptorTableUtil attached.");
      }
      shared.RegisterEvent<reshade::addon_event::init_device>(OnInitDevice);
      shared.RegisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      shared.RegisterEvent<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);
      shared.RegisterEvent<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables, trace_descriptor_tables);
      shared.RegisterEvent<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables, trace_descriptor_tables);

      break;
    case DLL_PROCESS_DETACH:
      shared.UnregisterEvent<reshade::addon_event::init_device>(OnInitDevice);
      shared.UnregisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      shared.UnregisterEvent<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);
      shared.UnregisterEvent<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
      shared.UnregisterEvent<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
      shared.UnregisterModule();

      break;
  }
}
}  // namespace renodx::utils::descriptor
