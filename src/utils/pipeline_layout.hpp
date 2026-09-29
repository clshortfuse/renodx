/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <cstdint>
#include <functional>
#include <optional>
#include <shared_mutex>

#include <include/reshade.hpp>

#include "./cross_addon.hpp"
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
  int32_t injection_constant_buffer_offset = 0;
  gtl::node_hash_map<
      DescriptorBindingKey,
      DescriptorPushLocation,
      DescriptorBindingKeyHash,
      gtl::EqualTo<DescriptorBindingKey>,
      cross_addon::allocator<std::pair<const DescriptorBindingKey, DescriptorPushLocation>>>
      descriptor_push_locations;
  // Not immutable: updated during runtime; read only through synchronized access.
  bool failed_injection = false;
#if RESHADE_API_VERSION >= 20
  cross_addon::vector<cross_addon::vector<reshade::api::descriptor_range_with_flags>> ranges_with_flags;
#else
  cross_addon::vector<cross_addon::vector<reshade::api::descriptor_range_with_static_samplers>> ranges_with_static_samplers;
#endif
};

using PipelineLayoutDataMap = cross_addon::parallel_node_hash_map<uint64_t, PipelineLayoutData, std::shared_mutex>;

struct __declspec(uuid("080a74f2-9a2a-4af6-bb2c-8d083e0a354d")) Data {
  PipelineLayoutDataMap pipeline_layout_data;
};

static cross_addon::Shared<Data> shared;

// The node value stays at the same address while this layout key is alive, even
// if other entries are inserted. Read settled layout fields only after layout
// initialization callbacks finish; the map lock does not follow this pointer.
// Do not retain it past destroy_pipeline_layout or read fields being modified
// (such as failed_injection). Pointers into params/ranges are only stable while
// those vectors remain unchanged. Use the callback overload for mutable-phase
// reads.
[[nodiscard]] static const PipelineLayoutData* GetPipelineLayoutData(const reshade::api::pipeline_layout& layout) {
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

struct DescriptorLocation {
  uint32_t binding = 0u;
  uint32_t array_offset = 0u;
  uint32_t register_slot = 0u;
  uint32_t register_space = 0u;
  reshade::api::shader_stage shader_visibility = {};
};

static std::optional<DescriptorLocation> FindDescriptorLocation(
    const reshade::api::pipeline_layout_param& param,
    reshade::api::device_api device_api,
  const reshade::api::descriptor_table_update& update,
    uint32_t descriptor_index) {
  const auto resolve_ranges = [&](uint32_t count, const auto* ranges) -> std::optional<DescriptorLocation> {
    if (device_api == reshade::api::device_api::d3d9
        || device_api == reshade::api::device_api::d3d10
        || device_api == reshade::api::device_api::d3d11
        || device_api == reshade::api::device_api::d3d12) {
      const uint32_t current_binding = update.binding + descriptor_index;
      for (uint32_t index = 0u; index < count; ++index) {
        const auto& range = ranges[index];
        if (range.type != update.type || current_binding < range.binding) continue;
        const uint32_t range_offset = current_binding - range.binding;
        if (range.count != UINT32_MAX && range_offset >= range.count) continue;
        return DescriptorLocation{
            .binding = current_binding,
            .array_offset = update.array_offset,
            .register_slot = range.dx_register_index + range_offset,
            .register_space = range.dx_register_space,
            .shader_visibility = range.visibility,
        };
      }
      return std::nullopt;
    }
    if (device_api != reshade::api::device_api::opengl
        && device_api != reshade::api::device_api::vulkan) return std::nullopt;

    uint32_t current_binding = update.binding;
    uint32_t current_array_offset = update.array_offset;
    for (uint32_t spill = 0u; spill <= count; ++spill) {
      const auto* matching_range = static_cast<const reshade::api::descriptor_range*>(nullptr);
      for (uint32_t index = 0u; index < count; ++index) {
        if (ranges[index].type == update.type
            && ranges[index].binding == current_binding) {
          matching_range = &ranges[index];
          break;
        }
      }
      if (matching_range == nullptr
          || (matching_range->count != UINT32_MAX
              && current_array_offset >= matching_range->count)) {
        return std::nullopt;
      }

      if (matching_range->count == UINT32_MAX
          || descriptor_index < matching_range->count - current_array_offset) {
        return DescriptorLocation{
            .binding = current_binding,
            .array_offset = current_array_offset + descriptor_index,
          .shader_visibility = matching_range->visibility,
        };
      }
      descriptor_index -= matching_range->count - current_array_offset;
      ++current_binding;
      current_array_offset = 0u;
    }
    return std::nullopt;
  };

  switch (param.type) {
    case reshade::api::pipeline_layout_param_type::push_descriptors:
      return resolve_ranges(1u, &param.push_descriptors);
    case reshade::api::pipeline_layout_param_type::descriptor_table:
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
      return resolve_ranges(
          param.descriptor_table.count,
          param.descriptor_table.ranges);
#if RESHADE_API_VERSION >= 20
    case reshade::api::pipeline_layout_param_type::descriptor_table_with_flags:
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges_and_flags:
      return resolve_ranges(
          param.descriptor_table_with_flags.count,
          param.descriptor_table_with_flags.ranges);
#else
    case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
      return resolve_ranges(
          param.descriptor_table_with_static_samplers.count,
          param.descriptor_table_with_static_samplers.ranges);
#endif
    case reshade::api::pipeline_layout_param_type::push_constants:
      return std::nullopt;
  }
  return std::nullopt;
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
  #if RESHADE_API_VERSION >= 20
    layout_data.ranges_with_flags.resize(param_count);
  #else
    layout_data.ranges_with_static_samplers.resize(param_count);
  #endif

    for (uint32_t i = 0; i < param_count; ++i) {
      const auto& param = params[i];
      switch (param.type) {
        case reshade::api::pipeline_layout_param_type::descriptor_table:
        case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
          if (param.descriptor_table.count == 0u) continue;
          {
            layout_data.ranges[i].assign(
                param.descriptor_table.ranges,
                param.descriptor_table.ranges + param.descriptor_table.count);
            layout_data.params[i].descriptor_table.ranges = layout_data.ranges[i].data();
          }
          break;
#if RESHADE_API_VERSION >= 20
        case reshade::api::pipeline_layout_param_type::descriptor_table_with_flags:
        case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges_and_flags:
          if (param.descriptor_table_with_flags.count == 0u) continue;
          {
            auto& copied_ranges = layout_data.ranges_with_flags[i];
            copied_ranges.assign(
                param.descriptor_table_with_flags.ranges,
                param.descriptor_table_with_flags.ranges
                    + param.descriptor_table_with_flags.count);
            size_t static_sampler_count = 0u;
            for (const auto& range : copied_ranges) {
              if (range.static_samplers != nullptr && range.count != UINT32_MAX) {
                static_sampler_count += range.count;
              }
            }
            auto& copied_samplers = layout_data.static_samplers[i];
            copied_samplers.reserve(static_sampler_count);
            for (const auto& range : copied_ranges) {
              if (range.static_samplers == nullptr || range.count == UINT32_MAX) continue;
              copied_samplers.insert(
                  copied_samplers.end(),
                  range.static_samplers,
                  range.static_samplers + range.count);
            }
            size_t static_sampler_offset = 0u;
            for (auto& range : copied_ranges) {
              if (range.static_samplers == nullptr || range.count == UINT32_MAX) {
                range.static_samplers = nullptr;
                continue;
              }
              range.static_samplers = copied_samplers.data() + static_sampler_offset;
              static_sampler_offset += range.count;
            }
            layout_data.params[i].descriptor_table_with_flags.ranges = copied_ranges.data();
          }
          break;
#else
        case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
        case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
          if (param.descriptor_table_with_static_samplers.count == 0u) continue;
          {
            auto& copied_ranges = layout_data.ranges_with_static_samplers[i];
            copied_ranges.assign(
                param.descriptor_table_with_static_samplers.ranges,
                param.descriptor_table_with_static_samplers.ranges
                    + param.descriptor_table_with_static_samplers.count);
            size_t static_sampler_count = 0u;
            for (const auto& range : copied_ranges) {
              if (range.static_samplers != nullptr && range.count != UINT32_MAX) {
                static_sampler_count += range.count;
              }
            }
            auto& copied_samplers = layout_data.static_samplers[i];
            copied_samplers.reserve(static_sampler_count);
            for (const auto& range : copied_ranges) {
              if (range.static_samplers == nullptr || range.count == UINT32_MAX) continue;
              copied_samplers.insert(
                  copied_samplers.end(),
                  range.static_samplers,
                  range.static_samplers + range.count);
            }
            size_t static_sampler_offset = 0u;
            for (auto& range : copied_ranges) {
              if (range.static_samplers == nullptr || range.count == UINT32_MAX) {
                range.static_samplers = nullptr;
                continue;
              }
              range.static_samplers = copied_samplers.data() + static_sampler_offset;
              static_sampler_offset += range.count;
            }
            layout_data.params[i].descriptor_table_with_static_samplers.ranges =
                copied_ranges.data();
          }
          break;
#endif
        case reshade::api::pipeline_layout_param_type::push_constants:
        case reshade::api::pipeline_layout_param_type::push_descriptors:
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
