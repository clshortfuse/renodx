/*
 * CONTROL Resonant only needs RenoDX shader injection for post-processing shaders.
 *
 * Injecting the b0, space50 constants into arbitrary D3D12 root signatures can break the
 * ray-tracing path. In particular, the non-Ray-Reconstruction RT path crashes when one
 * specific root signature is modified, while leaving that layout untouched is stable.
 *
 * This file filters pipeline layouts before RenoDX injection:
 * - Skip layouts that explicitly expose acceleration structures.
 * - Skip the exact non-Ray-Reconstruction RT layout known to crash.
 *
 * The structural filter is shared; the temporary three-parameter diagnostic applies only at creation.
 */

#pragma once

#include <cstdint>
#include <span>
#include <sstream>

#include <include/reshade.hpp>

namespace control_resonant::pipeline_layouts {

using DescriptorType = reshade::api::descriptor_type;
using DescriptorRange = reshade::api::descriptor_range;
using PipelineLayoutParam = reshade::api::pipeline_layout_param;
using PipelineLayoutParamType = reshade::api::pipeline_layout_param_type;

#define DIAGNOSTIC_SKIP_THREE_PARAM_LAYOUTS 0

inline void LogDiagnosticLayout(reshade::api::device* device, std::span<const PipelineLayoutParam> params) {
  std::stringstream s;
  s << "[RenoDX CONTROL] Diagnostic: skipping original 3-param layout, device=" << device;
  for (size_t i = 0; i < params.size(); ++i) {
    const auto& param = params[i];
    s << "; p" << i << "{type=" << static_cast<uint32_t>(param.type);
    // Shared base fields also describe ranges carrying static samplers.
    const auto append_range = [&s](const DescriptorRange& range, uint32_t index) {
      s << ", r" << index << "{type=" << static_cast<uint32_t>(range.type)
        << ", binding=" << range.binding << ", register=" << range.dx_register_index
        << ", space=" << range.dx_register_space << ", count=" << range.count
        << ", array_size=" << range.array_size << ", visibility=" << static_cast<uint32_t>(range.visibility) << "}";
    };
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
          append_range(param.descriptor_table_with_static_samplers.ranges[j], j);
        }
        break;
      default:
        break;
    }
    s << "}";
  }
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

inline bool MatchesRange(const DescriptorRange& range, DescriptorType type, uint32_t register_index, uint32_t register_space, uint32_t count) {
  return range.type == type
         && range.binding == 0u
         && range.dx_register_index == register_index
         && range.dx_register_space == register_space
         && range.count == count;
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

// Captured non-RR RT layouts: original 18/7 and the 22/10 variant observed during RT setting changes.
inline bool IsProblematicRayTracingLayout(std::span<const PipelineLayoutParam> params) {
  if (params.size() != 3u) return false;

  const auto& srv_param = params[0];
  const auto& uav_param = params[1];
  const auto& cbv_param = params[2];

  if (srv_param.type != PipelineLayoutParamType::descriptor_table_with_static_samplers
      || srv_param.descriptor_table_with_static_samplers.count != 1u) return false;

  if (uav_param.type != PipelineLayoutParamType::descriptor_table_with_static_samplers
      || uav_param.descriptor_table_with_static_samplers.count != 1u) return false;

  if (cbv_param.type != PipelineLayoutParamType::push_descriptors_with_static_samplers
      || cbv_param.descriptor_table_with_static_samplers.count != 1u) return false;

  const auto& srv_range = srv_param.descriptor_table_with_static_samplers.ranges[0];
  const auto& uav_range = uav_param.descriptor_table_with_static_samplers.ranges[0];
  if ((srv_range.count != 18u || uav_range.count != 7u) && (srv_range.count != 22u || uav_range.count != 10u)) return false;

  return MatchesRange(srv_range, DescriptorType::shader_resource_view, 0u, 0u, srv_range.count)
         && MatchesRange(uav_range, DescriptorType::unordered_access_view, 0u, 0u, uav_range.count)
         && MatchesRange(cbv_param.descriptor_table_with_static_samplers.ranges[0], DescriptorType::constant_buffer, 0u, 1u, 1u);
}

inline bool ShouldInjectPipelineLayout(std::span<const PipelineLayoutParam> params) {
  if (HasAccelerationStructure(params)) return false;
  if (IsProblematicRayTracingLayout(params)) return false;

  return true;
}

}  // namespace control_resonant::pipeline_layouts