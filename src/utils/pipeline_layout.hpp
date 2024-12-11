/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <include/reshade.hpp>
#include <include/reshade_api_pipeline.hpp>
#include <shared_mutex>
#include <unordered_map>
#include <vector>

namespace renodx::utils::pipeline_layout {

static bool is_primary_hook = false;

struct PipelineLayoutData {
  std::vector<reshade::api::pipeline_layout_param> params;
  std::vector<std::vector<reshade::api::descriptor_range>> ranges;
};
struct __declspec(uuid("96f1f53b-90cb-4929-92d7-9a7a1a5c2493")) DeviceData {
  std::unordered_map<uint64_t, PipelineLayoutData> pipeline_layout_data;

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

static void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  if (!is_primary_hook) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  PipelineLayoutData& layout_data = data.pipeline_layout_data[layout.handle];
  layout_data.params.assign(params, params + param_count);
  layout_data.ranges.resize(param_count);

  for (uint32_t i = 0; i < param_count; ++i) {
    const auto& param = params[i];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      auto& ranges = layout_data.ranges[i];
      ranges.assign(
          param.descriptor_table.ranges,
          param.descriptor_table.ranges + param.descriptor_table.count);
      layout_data.params[i] = param;
      layout_data.params[i].descriptor_table.ranges = ranges.data();
    }
  }
}

static void OnDestroyPipelineLayout(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout) {
  if (!is_primary_hook) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.pipeline_layout_data.erase(layout.handle);
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
