/*
 * CONTROL Resonant only needs RenoDX shader injection for post-processing shaders.
 *
 * Injecting the b0, space50 constants into arbitrary D3D12 root signatures can break
 * ray-tracing pipelines. Several RT-related layouts have been observed to crash when
 * modified, while leaving those layouts untouched is stable.
 *
 * This file filters pipeline layouts before RenoDX injection:
 * - Skip layouts that explicitly expose acceleration structures.
 * - Skip exact RT-related layouts known to crash when modified.
 *
 * The structural filter is shared; the temporary three-parameter diagnostic applies only at creation.
 */

#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <span>
#include <sstream>

#include <include/reshade.hpp>

namespace control_resonant::pipeline_layouts {

using DescriptorType = reshade::api::descriptor_type;
using DescriptorRange = reshade::api::descriptor_range;
using PipelineLayoutParam = reshade::api::pipeline_layout_param;
using PipelineLayoutParamType = reshade::api::pipeline_layout_param_type;

inline constexpr bool DIAGNOSTIC_SKIP_THREE_PARAM_LAYOUTS = false;

inline void LogSkippedLayout(reshade::api::device* device, std::span<const PipelineLayoutParam> params, const char* reason) {
  std::stringstream s;
  s << "[RenoDX CONTROL] Skipping pipeline layout injection: " << reason
    << ", device=" << device << ", params=" << params.size();

  const auto append_range = [&s](const DescriptorRange& range, uint32_t index) {
    s << ", r" << index << "{type=" << static_cast<uint32_t>(range.type)
      << ", binding=" << range.binding << ", register=" << range.dx_register_index
      << ", space=" << range.dx_register_space << ", count=" << range.count
      << ", array_size=" << range.array_size << ", visibility=" << static_cast<uint32_t>(range.visibility) << "}";
  };

  for (std::size_t i = 0; i < params.size(); ++i) {
    const auto& param = params[i];
    s << "; p" << i << "{type=" << static_cast<uint32_t>(param.type);

    switch (param.type) {
      case PipelineLayoutParamType::push_constants:
        s << ", binding=" << param.push_constants.binding << ", register=" << param.push_constants.dx_register_index
          << ", space=" << param.push_constants.dx_register_space << ", count=" << param.push_constants.count
          << ", visibility=" << static_cast<uint32_t>(param.push_constants.visibility);
        break;

      case PipelineLayoutParamType::push_descriptors:
        append_range(param.push_descriptors, 0u);
        break;

      case PipelineLayoutParamType::descriptor_table:
      case PipelineLayoutParamType::push_descriptors_with_ranges:
        s << ", ranges=" << param.descriptor_table.count;
        for (uint32_t j = 0; j < param.descriptor_table.count; ++j) {
          append_range(param.descriptor_table.ranges[j], j);
        }
        break;

      case PipelineLayoutParamType::descriptor_table_with_static_samplers:
      case PipelineLayoutParamType::push_descriptors_with_static_samplers:
        s << ", ranges=" << param.descriptor_table_with_static_samplers.count;
        for (uint32_t j = 0; j < param.descriptor_table_with_static_samplers.count; ++j) {
          const auto& range = param.descriptor_table_with_static_samplers.ranges[j];
          append_range(range, j);
          s << ", static_sampler=" << (range.static_samplers != nullptr);
        }
        break;

      default:
        break;
    }

    s << "}";
  }

  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

inline bool HasAccelerationStructure(std::span<const PipelineLayoutParam> params) {
  for (const auto& param : params) {
    switch (param.type) {
      case PipelineLayoutParamType::push_descriptors:
        if (param.push_descriptors.type == DescriptorType::acceleration_structure) return true;
        break;

      case PipelineLayoutParamType::descriptor_table:
      case PipelineLayoutParamType::push_descriptors_with_ranges:
        for (uint32_t i = 0; i < param.descriptor_table.count; ++i) {
          if (param.descriptor_table.ranges[i].type == DescriptorType::acceleration_structure) return true;
        }
        break;

      case PipelineLayoutParamType::descriptor_table_with_static_samplers:
      case PipelineLayoutParamType::push_descriptors_with_static_samplers:
        for (uint32_t i = 0; i < param.descriptor_table_with_static_samplers.count; ++i) {
          if (param.descriptor_table_with_static_samplers.ranges[i].type == DescriptorType::acceleration_structure) return true;
        }
        break;

      default:
        break;
    }
  }

  return false;
}

// Captured crash-prone RT-related layouts observed during RT setting changes.
inline bool IsProblematicRayTracingLayout(std::span<const PipelineLayoutParam> params) {
  if (params.size() != 3u) return false;

  struct ParamSignature {
    PipelineLayoutParamType type;
    DescriptorType descriptor_type;
    uint32_t descriptor_count;
    uint32_t binding = 0u;
    uint32_t register_index = 0u;
    uint32_t register_space = 0u;
  };

  static constexpr std::array<std::array<ParamSignature, 3>, 3> SIGNATURES = {{
      {{
          // RT 18/7
          {.type = PipelineLayoutParamType::descriptor_table_with_static_samplers,
           .descriptor_type = DescriptorType::shader_resource_view,
           .descriptor_count = 18u},
          {.type = PipelineLayoutParamType::descriptor_table_with_static_samplers,
           .descriptor_type = DescriptorType::unordered_access_view,
           .descriptor_count = 7u},
          {.type = PipelineLayoutParamType::push_descriptors_with_static_samplers,
           .descriptor_type = DescriptorType::constant_buffer,
           .descriptor_count = 1u,
           .register_space = 1u},
      }},
      {{
          // RT 22/10
          {.type = PipelineLayoutParamType::descriptor_table_with_static_samplers,
           .descriptor_type = DescriptorType::shader_resource_view,
           .descriptor_count = 22u},
          {.type = PipelineLayoutParamType::descriptor_table_with_static_samplers,
           .descriptor_type = DescriptorType::unordered_access_view,
           .descriptor_count = 10u},
          {.type = PipelineLayoutParamType::push_descriptors_with_static_samplers,
           .descriptor_type = DescriptorType::constant_buffer,
           .descriptor_count = 1u,
           .register_space = 1u},
      }},
      {{
          // RT supporting UAV/CBV/static-sampler layout
          {.type = PipelineLayoutParamType::descriptor_table,
           .descriptor_type = DescriptorType::unordered_access_view,
           .descriptor_count = 1u,
           .binding = 2u},
          {.type = PipelineLayoutParamType::descriptor_table,
           .descriptor_type = DescriptorType::constant_buffer,
           .descriptor_count = 1u},
          {.type = PipelineLayoutParamType::push_descriptors_with_static_samplers,
           .descriptor_type = DescriptorType::sampler,
           .descriptor_count = 1u},
      }},
  }};

  std::array<const DescriptorRange*, 3> ranges{};

  for (std::size_t i = 0; i < params.size(); ++i) {
    const auto& param = params[i];

    switch (param.type) {
      case PipelineLayoutParamType::descriptor_table:
        if (param.descriptor_table.count != 1u) return false;
        ranges[i] = param.descriptor_table.ranges;
        break;

      case PipelineLayoutParamType::descriptor_table_with_static_samplers:
      case PipelineLayoutParamType::push_descriptors_with_static_samplers: {
        if (param.descriptor_table_with_static_samplers.count != 1u) return false;

        ranges[i] = param.descriptor_table_with_static_samplers.ranges;
        break;
      }

      default:
        return false;
    }
  }

  for (const auto& signature : SIGNATURES) {
    bool matches = true;

    for (std::size_t i = 0; i < params.size(); ++i) {
      const auto& expected = signature[i];
      const auto& range = *ranges[i];

      if (params[i].type != expected.type
          || range.type != expected.descriptor_type
          || range.count != expected.descriptor_count
          || range.binding != expected.binding
          || range.dx_register_index != expected.register_index
          || range.dx_register_space != expected.register_space) {
        matches = false;
        break;
      }
    }

    if (matches) return true;
  }

  return false;
}

inline bool ShouldInjectPipelineLayout(std::span<const PipelineLayoutParam> params) {
  if (HasAccelerationStructure(params)) return false;
  if (IsProblematicRayTracingLayout(params)) return false;

  return true;
}

}  // namespace control_resonant::pipeline_layouts