/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <cstdint>
#include <shared_mutex>
#include <sstream>
#include <vector>

#include <include/reshade.hpp>

#include "./data.hpp"
#include "./format.hpp"
#include "./log.hpp"

namespace renodx::utils::pipeline_layout {

struct PipelineLayoutData {
  std::vector<reshade::api::pipeline_layout_param> params;
  std::vector<std::vector<reshade::api::descriptor_range>> ranges;
  std::vector<reshade::api::descriptor_table> tables;
  reshade::api::pipeline_layout layout = {0u};
  reshade::api::pipeline_layout replacement_layout = {0u};
  reshade::api::pipeline_layout injection_layout = {0u};
  int32_t injection_index = -1;
  int32_t injection_register_index = -1;
  bool failed_injection = false;
};

static struct Store {
  data::ParallelNodeHashMap<uint64_t, PipelineLayoutData, std::shared_mutex> pipeline_layout_data;
} local_store;

static Store* store = &local_store;

static bool is_primary_hook = false;

static PipelineLayoutData* GetPipelineLayoutData(const reshade::api::pipeline_layout& layout, bool create = false) {
  if (create) {
    auto [pointer, inserted] = store->pipeline_layout_data.try_emplace_p(layout.handle, PipelineLayoutData({.layout = layout}));
    return &pointer->second;
  }
  PipelineLayoutData* data = nullptr;

  store->pipeline_layout_data.if_contains(layout.handle, [&data](std::pair<const uint64_t, PipelineLayoutData>& pair) {
    data = &pair.second;
  });
  if (data == nullptr) {
    log::e("utils::pipeline_layout::GetPipelineLayout(",
           "Pipeline layout not found: ", log::AsPtr(layout.handle),
           ")");
    assert(data != nullptr);
  }
  return data;
}

struct __declspec(uuid("080a74f2-9a2a-4af6-bb2c-8d083e0a354d")) DeviceData {
  Store* store;
};

static void OnInitDevice(reshade::api::device* device) {
  DeviceData* data;
  bool created = renodx::utils::data::CreateOrGet(device, data);

  if (created) {
    log::d(
        "utils::pipeline_layout::OnInitDevice(Hooking device: ",
        log::AsPtr(device),
        ", api: ", device->get_api(),
        ")");
    is_primary_hook = true;
    data->store = store;
  } else {
    std::stringstream s;
    s << "utils::pipeline_layout::OnInitDevice(Attaching to hook: ";
    s << PRINT_PTR(reinterpret_cast<uintptr_t>(device));
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
    store = data->store;
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (!is_primary_hook) return;
  std::stringstream s;
  s << "utils::resource::OnDestroyDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

static void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  if (layout.handle == 0u) {
    assert(layout.handle != 0u);
    return;
  }
  auto* layout_data = GetPipelineLayoutData(layout, true);

  layout_data->params.assign(params, params + param_count);
  layout_data->ranges.resize(param_count);
  layout_data->tables.resize(param_count);

  for (uint32_t i = 0; i < param_count; ++i) {
    const auto& param = params[i];
    switch (param.type) {
      case reshade::api::pipeline_layout_param_type::descriptor_table:
        if (param.descriptor_table.count == 0u) continue;
        {
          layout_data->ranges[i].assign(
              param.descriptor_table.ranges,
              param.descriptor_table.ranges + param.descriptor_table.count);
          layout_data->params[i].descriptor_table.ranges = layout_data->ranges[i].data();
        }
        break;
      case reshade::api::pipeline_layout_param_type::push_constants:
      case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
      case reshade::api::pipeline_layout_param_type::push_descriptors:
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
        break;
      default:
        // No other known types
        assert(false);
    }
  }
}

static void OnDestroyPipelineLayout(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout) {
  store->pipeline_layout_data.erase(layout.handle);
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "PipelineLayoutUtil attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::register_event<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);

      break;
  }
}

}  // namespace renodx::utils::pipeline_layout
