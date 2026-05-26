/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <cstdint>
#include <functional>
#include <shared_mutex>

#include <include/reshade.hpp>

#include "./cross_addon.hpp"
#include "./data.hpp"
#include "./hash.hpp"
#include "./log.hpp"

namespace renodx::utils::pipeline_layout {

using DescriptorPushLocation = std::pair<uint32_t, uint32_t>;

struct DescriptorBindingKey {
  reshade::api::descriptor_type type = static_cast<reshade::api::descriptor_type>(0u);
  uint32_t slot = 0u;
  uint32_t space = 0u;

  bool operator==(const DescriptorBindingKey& other) const = default;
};

struct DescriptorBindingKeyHash {
  size_t operator()(const DescriptorBindingKey& key) const {
    return hash::HashPair{}(std::make_pair(
        static_cast<uint64_t>(static_cast<uint32_t>(key.type)),
        (static_cast<uint64_t>(key.space) << 32u) | static_cast<uint64_t>(key.slot)));
  }
};

struct PipelineLayoutData {
  cross_addon::vector<reshade::api::pipeline_layout_param> params;
  cross_addon::vector<cross_addon::vector<reshade::api::descriptor_range>> ranges;
  cross_addon::vector<cross_addon::vector<reshade::api::sampler_desc>> static_samplers;
  reshade::api::pipeline_layout layout = {0u};
  reshade::api::pipeline_layout replacement_layout = {0u};
  reshade::api::pipeline_layout injection_layout = {0u};
  int32_t injection_index = -1;
  int32_t injection_register_index = -1;
  cross_addon::unordered_map<DescriptorBindingKey, DescriptorPushLocation, DescriptorBindingKeyHash> descriptor_push_locations;
  bool failed_injection = false;
};

using PipelineLayoutDataMap = cross_addon::parallel_node_hash_map<uint64_t, PipelineLayoutData, std::shared_mutex>;

struct __declspec(uuid("080a74f2-9a2a-4af6-bb2c-8d083e0a354d")) Data {
  PipelineLayoutDataMap pipeline_layout_data;
};

static cross_addon::Shared<Data> shared;

[[deprecated("Use GetPipelineLayoutData<F>")]] [[nodiscard]] static const PipelineLayoutData* GetPipelineLayoutData(const reshade::api::pipeline_layout& layout) {
  const PipelineLayoutData* data = nullptr;

  shared.data->pipeline_layout_data.if_contains(layout.handle, [&data](const std::pair<const uint64_t, PipelineLayoutData>& pair) {
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

template <typename F>
static bool GetPipelineLayoutData(const reshade::api::pipeline_layout& layout, F&& f) {
  if (layout.handle == 0u) return false;

  bool found = false;
  shared.data->pipeline_layout_data.if_contains(layout.handle, [&f, &found](const std::pair<const uint64_t, PipelineLayoutData>& pair) {
    std::invoke(f, &pair.second);
    found = true;
  });
  return found;
}

template <typename F>
static bool CreatePipelineLayoutData(const reshade::api::pipeline_layout& layout, F&& f) {
  return shared.data->pipeline_layout_data.lazy_emplace_l(
      layout.handle,
      [&](std::pair<const uint64_t, PipelineLayoutData>& pair) {
        std::forward<F>(f)(pair.second);
      },
      [&](const PipelineLayoutDataMap::constructor& ctor) {
        PipelineLayoutData data = {.layout = layout};
        std::forward<F>(f)(data);
        ctor(layout.handle, std::move(data));
      });
}

template <typename F>
static bool UpdatePipelineLayoutData(const reshade::api::pipeline_layout& layout, F&& f) {
  bool updated = false;
  shared.data->pipeline_layout_data.modify_if(layout.handle, [&](std::pair<const uint64_t, PipelineLayoutData>& pair) {
    std::forward<F>(f)(pair.second);
    updated = true;
  });
  if (!updated) {
    log::e("utils::pipeline_layout::UpdatePipelineLayoutData(",
           "Pipeline layout not found: ", log::AsPtr(layout.handle),
           ")");
    assert(updated);
  }
  return updated;
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
  CreatePipelineLayoutData(layout, [&](PipelineLayoutData& layout_data) {
    layout_data.params.assign(params, params + param_count);
    layout_data.ranges.resize(param_count);
    layout_data.static_samplers.resize(param_count);

    for (uint32_t i = 0; i < param_count; ++i) {
      const auto& param = params[i];
      switch (param.type) {
        case reshade::api::pipeline_layout_param_type::descriptor_table:
          if (param.descriptor_table.count == 0u) continue;
          {
            layout_data.ranges[i].assign(
                param.descriptor_table.ranges,
                param.descriptor_table.ranges + param.descriptor_table.count);
            layout_data.params[i].descriptor_table.ranges = layout_data.ranges[i].data();
          }
          break;
        case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
          if (param.descriptor_table_with_static_samplers.count == 0u) continue;
          {
            layout_data.ranges[i].reserve(param.descriptor_table_with_static_samplers.count);
            for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
              const auto& range = param.descriptor_table_with_static_samplers.ranges[range_index];
              layout_data.ranges[i].push_back(range);
              if (range.static_samplers != nullptr && range.count != UINT32_MAX) {
                layout_data.static_samplers[i].insert(
                    layout_data.static_samplers[i].end(),
                    range.static_samplers,
                    range.static_samplers + range.count);
              }
            }
          }
          break;
        case reshade::api::pipeline_layout_param_type::push_constants:
        case reshade::api::pipeline_layout_param_type::push_descriptors:
        case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
        case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
          break;
        default:
          // No other known types
          assert(false);
      }
    }
  });
}

static void OnDestroyPipelineLayout(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout) {
  shared.data->pipeline_layout_data.erase(layout.handle);
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (shared.RegisterModule()) {
        reshade::log::message(reshade::log::level::info, "PipelineLayoutUtil attached.");
      }
      shared.RegisterEvent<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      shared.RegisterEvent<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);

      break;
    case DLL_PROCESS_DETACH:
      shared.UnregisterEvent<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      shared.UnregisterEvent<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);
      shared.UnregisterModule();

      break;
  }
}

}  // namespace renodx::utils::pipeline_layout
