/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <stdio.h>

#include <filesystem>
#include <fstream>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./format.hpp"
#include "./mutex.hpp"

namespace DescriptorTableUtil {

  struct hash_pair {
    /// https://chromium.googlesource.com/chromium/+/02456cb7f063e2d2f6ee3c7cbacbfc239b171ac3/cc/hash_pair.h
    template <class T1, class T2>
    size_t operator()(const std::pair<T1, T2> value) const {
      uint32_t shortRandom1 = 842304669U;
      uint32_t shortRandom2 = 619063811U;
      uint32_t shortRandom3 = 937041849U;
      uint32_t shortRandom4 = 3309708029U;

      uint64_t value1 = value.first;
      uint64_t value2 = value.second;
      uint32_t value1a = static_cast<uint32_t>(value1 & 0xffffffff);
      uint32_t value1b = static_cast<uint32_t>((value1 >> 32) & 0xffffffff);
      uint32_t value2a = static_cast<uint32_t>(value2 & 0xffffffff);
      uint32_t value2b = static_cast<uint32_t>((value2 >> 32) & 0xffffffff);

      uint64_t product1 = static_cast<uint64_t>(value1a) * shortRandom1;
      uint64_t product2 = static_cast<uint64_t>(value1b) * shortRandom2;
      uint64_t product3 = static_cast<uint64_t>(value2a) * shortRandom3;
      uint64_t product4 = static_cast<uint64_t>(value2b) * shortRandom4;

      uint64_t hash64 = product1 + product2 + product3 + product4;

      if (sizeof(std::size_t) >= sizeof(uint64_t))
        return static_cast<std::size_t>(hash64);

      uint64_t oddRandom = 1578233944LL << 32 | 194370989LL;
      uint32_t shiftRandom = 20591U << 16;

      hash64 = hash64 * oddRandom + shiftRandom;
      std::size_t highBits = static_cast<std::size_t>(
        hash64 >> (sizeof(uint64_t) - sizeof(std::size_t))
      );
      return highBits;
    }
  };

  struct __declspec(uuid("018fa2c9-7a8b-76dc-bc84-87c53574223f")) DeviceData {
    // <descriptor_table.handle[index], <resourceView.handle>>
    std::unordered_map<std::pair<uint64_t, uint32_t>, reshade::api::descriptor_table_update, hash_pair> tableDescriptorResourceViews;
    // Index of tableDescriptorResourceViews
    std::unordered_map<uint64_t, std::unordered_set<std::pair<uint64_t, uint32_t>, hash_pair>*> resourceViewTableDescriptionLocations;

    std::shared_mutex mutex;
  };

  static std::shared_mutex mutex;

  static reshade::api::resource_view getResourceViewFromDescriptorUpdate(
    const reshade::api::descriptor_table_update update,
    uint32_t index = 0
  ) {
    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view:
        {
          auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index];
          return item.view;
        }
        break;
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::unordered_access_view:
        {
          auto resourceView = static_cast<const reshade::api::resource_view*>(update.descriptors)[index];
          return resourceView;
        }
        break;
      default:
        break;
    }
    return reshade::api::resource_view{0};
  }

  static reshade::api::descriptor_table_update shrinkDescriptorUpdateWithResourceView(
    const reshade::api::descriptor_table_update update,
    uint32_t index = 0
  ) {
    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view:
        {
          auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index];
          return reshade::api::descriptor_table_update{
            .table = update.table,
            .binding = update.binding + index,
            .count = 1,
            .type = update.type,
            .descriptors = new reshade::api::sampler_with_resource_view{item.sampler, item.view}
          };
        }
        break;
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::unordered_access_view:
        {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[index];
          return reshade::api::descriptor_table_update{
            .table = update.table,
            .binding = update.binding + index,
            .count = 1,
            .type = update.type,
            .descriptors = new reshade::api::resource_view{item.handle}
          };
        }
        break;
      default:
        break;
    }
    return reshade::api::descriptor_table_update{};
  }

  // Returns true if changed
  static bool logDescriptorTableResourceView(
    DeviceData &data,  // Should be mutex locked
    const reshade::api::descriptor_table table,
    const uint32_t index,
    const reshade::api::descriptor_table_update update = {}
  ) {
    if (!table.handle) return false;

    auto primaryKey = std::pair<uint64_t, uint32_t>(table.handle, index);

    auto view = getResourceViewFromDescriptorUpdate(update, index);

    if (view.handle) {
#ifdef DEBUG_LEVEL_1
      {
        std::stringstream s;
        s << "logDescriptorTableResourceView("
          << (void*)table.handle
          << "[" << index << "]"
          << ", view " << (void*)view.handle
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
#endif
      auto shrunkUpdate = shrinkDescriptorUpdateWithResourceView(update, index);
      if (
        auto record = data.tableDescriptorResourceViews.find(primaryKey);
        record != data.tableDescriptorResourceViews.end()
      ) {
        auto oldUpdate = record->second;

        if (
          auto oldIndexRecord = data.resourceViewTableDescriptionLocations.find(view.handle);
          oldIndexRecord != data.resourceViewTableDescriptionLocations.end()
        ) {
          auto set = oldIndexRecord->second;
          set->erase(primaryKey);
        }
#ifdef DEBUG_LEVEL_1
        {
          std::stringstream s;
          s << "logDescriptorTableResourceView("
            << (void*)table.handle
            << "[" << index << "]"
            << " replace shrunk view: "
            << to_string(shrunkUpdate.type)
            << ")";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
#endif

      } else {
        // Insert new record

#ifdef DEBUG_LEVEL_1
        {
          std::stringstream s;
          s << "logDescriptorTableResourceView("
            << (void*)table.handle
            << "[" << index << "]"
            << " insert shrunk view: "
            << to_string(shrunkUpdate.type)
            << ")";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
#endif
      }
      data.tableDescriptorResourceViews[primaryKey] = shrunkUpdate;

      if (
        auto indexRecord = data.resourceViewTableDescriptionLocations.find(view.handle);
        indexRecord != data.resourceViewTableDescriptionLocations.end()
      ) {
// Add entry to set
#ifdef DEBUG_LEVEL_1
        {
          std::stringstream s;
          s << "logDescriptorTableResourceView(updating index "
            << (void*)view.handle
            << ")";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
#endif
        indexRecord->second->emplace(primaryKey);
      } else {
// Create new set with entry
#ifdef DEBUG_LEVEL_1
        {
          std::stringstream s;
          s << "logDescriptorTableResourceView(creating index "
            << (void*)view.handle
            << ")";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
#endif
        data.resourceViewTableDescriptionLocations.insert({view.handle, new std::unordered_set<std::pair<uint64_t, uint32_t>, hash_pair>{primaryKey}}
        );
      }
      return true;
    }

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "logDescriptorTableResourceView(remove entry"
        << (void*)table.handle
        << "[" << index << "]"
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
#endif

    // Blank view (remove)
    if (
      auto record = data.tableDescriptorResourceViews.find(primaryKey);
      record != data.tableDescriptorResourceViews.end()
    ) {
      auto oldUpdate = record->second;
      auto oldView = getResourceViewFromDescriptorUpdate(oldUpdate);
      if (oldView.handle) {
        if (
          auto oldIndexRecord = data.resourceViewTableDescriptionLocations.find(oldView.handle);
          oldIndexRecord != data.resourceViewTableDescriptionLocations.end()
        ) {
          auto set = oldIndexRecord->second;
          set->erase(primaryKey);
        }
      }
      data.tableDescriptorResourceViews.erase(record);
    }

    return false;
  }

  static void on_init_device(reshade::api::device* device) {
    device->create_private_data<DeviceData>();
  }

  static void on_destroy_device(reshade::api::device* device) {
    device->destroy_private_data<DeviceData>();
  }

  // Create DescriptorTables with RSVs
  static bool on_update_descriptor_tables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates
  ) {
    if (!count) return false;

    for (uint32_t i = 0; i < count; i++) {
      auto &update = updates[i];
      for (uint32_t j = 0; j < update.count; j++) {
        if (!update.table.handle) {
          // reshade::log_message(reshade::log_level::warning, "DescriptorTableUtil::on_update_descriptor_tables(empty table).");
          continue;
        }
        auto &data = device->get_private_data<DeviceData>();
        std::unique_lock lock(data.mutex);

        logDescriptorTableResourceView(data, update.table, update.binding + j, update);
      }
    }
    return false;
  }

  static bool on_copy_descriptor_tables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies
  ) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    for (uint32_t i = 0; i < count; i++) {
      auto &copy = copies[i];
      for (uint32_t j = 0; j < copy.count; j++) {
        auto originPrimaryKey = std::pair<uint64_t, uint32_t>(copy.source_table.handle, copy.source_binding + j);
        if (auto pair = data.tableDescriptorResourceViews.find(originPrimaryKey);
            pair != data.tableDescriptorResourceViews.end()) {
          auto update = pair->second;

#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "copy_descriptor_tables(copy descriptor table entry: "
            << reinterpret_cast<void*>(update.table.handle)
            << "[" << update.binding + j << "]"
            << " => "
            << reinterpret_cast<void*>(copy.dest_table.handle)
            << "[" << copy.dest_binding + j << "]"
            << ", view: "
            << reinterpret_cast<void*>(getResourceViewFromDescriptorUpdate(update).handle)
            << ", type: " << to_string(update.type)
            << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

          if (!copy.dest_table.handle) {
            logDescriptorTableResourceView(data, copy.source_table, copy.source_binding + j);
          } else {
            auto clonedUpdate = update;
            clonedUpdate.table = copy.dest_table;
            clonedUpdate.binding = copy.dest_binding + j;
            logDescriptorTableResourceView(data, copy.dest_table, copy.dest_binding + j, clonedUpdate);
          }
        }
      }
    }
    return false;
  }

  // Set DescriptorTables RSVs
  static void on_push_descriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update &update
  ) {
    if (!update.count) return;
    auto device = cmd_list->get_device();

    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);

    for (uint32_t i = 0; i < update.count; i++) {
      if (!update.table.handle) {
        // reshade::log_message(reshade::log_level::warning, "DescriptorTableUtil::on_push_descriptors(empty table).");
        continue;
      }
      logDescriptorTableResourceView(data, update.table, update.binding + i, update);
    }
  }

  static reshade::api::descriptor_table_update* clone_descriptor_table_updates(
    const reshade::api::descriptor_table_update* updates,
    uint32_t count
  ) {
    size_t size = sizeof(reshade::api::descriptor_table_update) * count;
    reshade::api::descriptor_table_update* clone = (reshade::api::descriptor_table_update*)malloc(size);
    memcpy(clone, updates, size);
    for (size_t i = 0; i < count; ++i) {
      auto &update = updates[i];
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
      memcpy((void*)clone[i].descriptors, update.descriptors, descriptor_size);
    }
    return clone;
  }

  static bool attached = false;

  static void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        if (DescriptorTableUtil::attached) return;
        DescriptorTableUtil::attached = true;
        reshade::log_message(reshade::log_level::info, "DescriptorTableUtil attached.");

        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::register_event<reshade::addon_event::push_descriptors>(on_push_descriptors);
        reshade::register_event<reshade::addon_event::update_descriptor_tables>(on_update_descriptor_tables);
        reshade::register_event<reshade::addon_event::copy_descriptor_tables>(on_copy_descriptor_tables);

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
        reshade::unregister_event<reshade::addon_event::push_descriptors>(on_push_descriptors);
        reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(on_update_descriptor_tables);
        reshade::unregister_event<reshade::addon_event::copy_descriptor_tables>(on_copy_descriptor_tables);

        break;
    }
  }
}  // namespace DescriptorTableUtil
