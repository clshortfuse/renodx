/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <include/reshade.hpp>
#include <include/reshade_api_pipeline.hpp>
#include <mutex>
#include <shared_mutex>
#include <unordered_map>
#include <vector>

namespace renodx::utils::pipeline_layout {

struct PipelineLayoutData {
  std::vector<reshade::api::pipeline_layout_param> params;
  std::vector<std::vector<reshade::api::descriptor_range>> ranges;
  std::vector<reshade::api::descriptor_table> tables;
  reshade::api::pipeline_layout layout = {0u};
  reshade::api::pipeline_layout replacement_layout = {0u};
  reshade::api::pipeline_layout injection_layout = {0u};
  int32_t injection_index = -1;
  bool failed_injection = false;
};

static std::shared_mutex pipeline_layout_data_mutex;
static std::unordered_map<uint64_t, PipelineLayoutData> pipeline_layout_data;

static PipelineLayoutData* GetPipelineLayoutData(const reshade::api::pipeline_layout& layout, bool create = false) {
  {
    std::shared_lock lock(pipeline_layout_data_mutex);
    auto pair = pipeline_layout_data.find(layout.handle);
    if (pair != pipeline_layout_data.end()) return &pair->second;
    if (!create) return nullptr;
  }

  {
    std::unique_lock write_lock(pipeline_layout_data_mutex);
    auto& info = pipeline_layout_data.insert({layout.handle, PipelineLayoutData({.layout = layout})}).first->second;
    return &info;
  }
}

static void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  auto& layout_data = *GetPipelineLayoutData(layout, true);

  layout_data.params.assign(params, params + param_count);
  layout_data.ranges.resize(param_count);
  layout_data.tables.resize(param_count);

  for (uint32_t i = 0; i < param_count; ++i) {
    const auto& param = params[i];
    switch (param.type) {
      case reshade::api::pipeline_layout_param_type::descriptor_table:
        if (param.descriptor_table.count == 0u) continue;
        {
          auto& ranges = layout_data.ranges[i];
          if (param.descriptor_table.ranges->count != UINT32_MAX) {
            ranges.assign(
                param.descriptor_table.ranges,
                param.descriptor_table.ranges + param.descriptor_table.count);
          } else {
            ranges.assign(
                param.descriptor_table.ranges,
                param.descriptor_table.ranges + 1);
          }
          layout_data.params[i] = param;
          layout_data.params[i].descriptor_table.ranges = ranges.data();
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
  const std::unique_lock lock(pipeline_layout_data_mutex);
  pipeline_layout_data.erase(layout.handle);
}

static void RegisterPipelineLayoutClone(
    reshade::api::pipeline_layout layout_original,
    reshade::api::pipeline_layout layout_clone) {
  auto& layout_data = *GetPipelineLayoutData(layout_original, true);
  layout_data.replacement_layout = layout_clone;
}

static reshade::api::pipeline_layout GetPipelineLayoutClone(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout_original) {
  auto* layout_data = GetPipelineLayoutData(layout_original, false);
  if (layout_data == nullptr) return {0};
  return layout_data->replacement_layout;
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "PipelineLayoutUtil attached.");

      reshade::register_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::register_event<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);

      break;
    case DLL_PROCESS_DETACH:

      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);

      break;
  }
}

}  // namespace renodx::utils::pipeline_layout
