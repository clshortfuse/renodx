#pragma once

#include <array>
#include <cstdint>
#include <span>
#include <sstream>

#include <include/reshade.hpp>

#include "shared.h"

namespace deadspace::pipeline_layouts {

using DescriptorType = reshade::api::descriptor_type;
using PipelineLayoutParam = reshade::api::pipeline_layout_param;
using PipelineLayoutParamType = reshade::api::pipeline_layout_param_type;

struct RangeSpec {
  DescriptorType type;
  uint32_t register_index;
  uint32_t register_space;
  uint32_t count;
};

struct ParamSpec {
  PipelineLayoutParamType type;
  DescriptorType descriptor_type;
  uint32_t register_index;
  uint32_t register_space;
  uint32_t count;
  uint32_t range_count;
  std::array<RangeSpec, 2> ranges;
};

struct PipelineLayoutSpec {
  const char* name;
  const ParamSpec* params;
  size_t param_count;
};

constexpr ParamSpec PushDescriptor(
    DescriptorType descriptor_type,
    uint32_t register_index,
    uint32_t register_space,
    uint32_t count) {
  return {
      .type = PipelineLayoutParamType::push_descriptors,
      .descriptor_type = descriptor_type,
      .register_index = register_index,
      .register_space = register_space,
      .count = count,
      .range_count = 0,
      .ranges = {},
  };
}

constexpr RangeSpec Range(
    DescriptorType descriptor_type,
    uint32_t register_index,
    uint32_t register_space,
    uint32_t count) {
  return {
      .type = descriptor_type,
      .register_index = register_index,
      .register_space = register_space,
      .count = count,
  };
}

constexpr ParamSpec DescriptorTable(RangeSpec range) {
  return {
      .type = PipelineLayoutParamType::descriptor_table,
      .descriptor_type = DescriptorType::constant_buffer,
      .register_index = 0,
      .register_space = 0,
      .count = 0,
      .range_count = 1,
      .ranges = {range, {}},
  };
}

inline constexpr std::array CANDIDATE_A_PARAMS = {
    PushDescriptor(DescriptorType::constant_buffer, 3, 0, 1),
    DescriptorTable(Range(DescriptorType::shader_resource_view, 32, 0, 8)),
    PushDescriptor(DescriptorType::constant_buffer, 0, 0, 1),
    DescriptorTable(Range(DescriptorType::shader_resource_view, 0, 0, 32)),
    DescriptorTable(Range(DescriptorType::unordered_access_view, 0, 0, 10)),
    DescriptorTable(Range(DescriptorType::sampler, 0, 0, 8)),
    PushDescriptor(DescriptorType::constant_buffer, 69, 0, 1),
};

inline constexpr std::array CANDIDATE_B_PARAMS = {
    DescriptorTable(Range(DescriptorType::shader_resource_view, 40, 0, 64)),
    DescriptorTable(Range(DescriptorType::sampler, 8, 0, 32)),
    PushDescriptor(DescriptorType::constant_buffer, 4, 0, 1),
    PushDescriptor(DescriptorType::constant_buffer, 5, 0, 1),
    PushDescriptor(DescriptorType::constant_buffer, 6, 0, 1),
};

inline constexpr std::array COMPUTE_LUTBUILDER_PARAMS = {
  PushDescriptor(DescriptorType::unordered_access_view, 0, 0, 1),
  DescriptorTable(Range(DescriptorType::shader_resource_view, 0, 0, 64)),
  DescriptorTable(Range(DescriptorType::unordered_access_view, 0, 0, 8)),
  DescriptorTable(Range(DescriptorType::sampler, 0, 0, 16)),
};

inline constexpr std::array GRAPHICS_COLORGRADE_COMPOSITE_PARAMS = {
  PushDescriptor(DescriptorType::constant_buffer, 0, 0, 1),
  DescriptorTable(Range(DescriptorType::shader_resource_view, 0, 0, 64)),
  PushDescriptor(DescriptorType::constant_buffer, 0, 0, 1),
  DescriptorTable(Range(DescriptorType::shader_resource_view, 0, 0, 64)),
  DescriptorTable(Range(DescriptorType::unordered_access_view, 0, 0, 8)),
  DescriptorTable(Range(DescriptorType::sampler, 0, 0, 16)),
  DescriptorTable(Range(DescriptorType::sampler, 0, 0, 16)),
};

inline constexpr std::array GRAPHICS_COLORGRADE_COMPOSITE_SIMPLE_PARAMS = {
  PushDescriptor(DescriptorType::constant_buffer, 0, 0, 1),
  DescriptorTable(Range(DescriptorType::shader_resource_view, 0, 0, 64)),
  DescriptorTable(Range(DescriptorType::unordered_access_view, 0, 0, 8)),
  DescriptorTable(Range(DescriptorType::sampler, 0, 0, 16)),
};

inline constexpr std::array DENIED_PIPELINE_LAYOUT_SPECS = {
    PipelineLayoutSpec{
        .name = "replacement-candidate-a-after-lutbuilder",
        .params = CANDIDATE_A_PARAMS.data(),
        .param_count = CANDIDATE_A_PARAMS.size(),
    },
    PipelineLayoutSpec{
        .name = "replacement-candidate-b-after-lutbuilder",
        .params = CANDIDATE_B_PARAMS.data(),
        .param_count = CANDIDATE_B_PARAMS.size(),
    },
};

  inline constexpr std::array ALLOWED_PIPELINE_LAYOUT_SPECS = {
    PipelineLayoutSpec{
      .name = "compute-lutbuilder",
      .params = COMPUTE_LUTBUILDER_PARAMS.data(),
      .param_count = COMPUTE_LUTBUILDER_PARAMS.size(),
    },
    PipelineLayoutSpec{
      .name = "graphics-colorgrade-composite",
      .params = GRAPHICS_COLORGRADE_COMPOSITE_PARAMS.data(),
      .param_count = GRAPHICS_COLORGRADE_COMPOSITE_PARAMS.size(),
    },
    PipelineLayoutSpec{
      .name = "graphics-colorgrade-composite-simple",
      .params = GRAPHICS_COLORGRADE_COMPOSITE_SIMPLE_PARAMS.data(),
      .param_count = GRAPHICS_COLORGRADE_COMPOSITE_SIMPLE_PARAMS.size(),
    },
  };

inline bool MatchesRange(const reshade::api::descriptor_range& range, const RangeSpec& spec) {
  return range.type == spec.type &&
         range.dx_register_index == spec.register_index &&
         range.dx_register_space == spec.register_space &&
         range.count == spec.count;
}

inline bool MatchesParam(const PipelineLayoutParam& param, const ParamSpec& spec) {
  if (param.type != spec.type) return false;

  switch (spec.type) {
    case PipelineLayoutParamType::push_descriptors:
      return param.push_descriptors.type == spec.descriptor_type &&
             param.push_descriptors.dx_register_index == spec.register_index &&
             param.push_descriptors.dx_register_space == spec.register_space &&
             param.push_descriptors.count == spec.count;
    case PipelineLayoutParamType::descriptor_table:
      if (param.descriptor_table.count != spec.range_count) return false;
      for (uint32_t range_index = 0; range_index < spec.range_count; ++range_index) {
        if (!MatchesRange(param.descriptor_table.ranges[range_index], spec.ranges[range_index])) return false;
      }
      return true;
    default:
      return false;
  }
}

inline bool MatchesPipelineLayout(std::span<const PipelineLayoutParam> params, const PipelineLayoutSpec& spec) {
  if (params.size() != spec.param_count) return false;

  for (size_t param_index = 0; param_index < spec.param_count; ++param_index) {
    if (!MatchesParam(params[param_index], spec.params[param_index])) return false;
  }

  return true;
}

inline bool IsInjectedShaderCBufferParam(const PipelineLayoutParam& param) {
  return param.type == PipelineLayoutParamType::push_constants &&
         param.push_constants.dx_register_index == 13 &&
         param.push_constants.dx_register_space == 0 &&
         param.push_constants.count >= sizeof(ShaderInjectData) / sizeof(uint32_t);
}

inline bool MatchesPipelineLayoutWithInjectedShaderCBuffer(std::span<const PipelineLayoutParam> params, const PipelineLayoutSpec& spec) {
  if (params.size() != spec.param_count + 1) return false;

  bool skipped_injected_param = false;
  size_t spec_param_index = 0;
  for (size_t param_index = 0; param_index < params.size(); ++param_index) {
    if (!skipped_injected_param && IsInjectedShaderCBufferParam(params[param_index])) {
      skipped_injected_param = true;
      continue;
    }

    if (spec_param_index >= spec.param_count) return false;
    if (!MatchesParam(params[param_index], spec.params[spec_param_index])) return false;
    ++spec_param_index;
  }

  return skipped_injected_param && spec_param_index == spec.param_count;
}

inline const PipelineLayoutSpec* FindDeniedPipelineLayoutSpec(std::span<const PipelineLayoutParam> params) {
  for (const auto& spec : DENIED_PIPELINE_LAYOUT_SPECS) {
    if (MatchesPipelineLayout(params, spec) || MatchesPipelineLayoutWithInjectedShaderCBuffer(params, spec)) return &spec;
  }

  return nullptr;
}

inline const PipelineLayoutSpec* FindAllowedPipelineLayoutSpec(std::span<const PipelineLayoutParam> params) {
  for (const auto& spec : ALLOWED_PIPELINE_LAYOUT_SPECS) {
    if (MatchesPipelineLayout(params, spec) || MatchesPipelineLayoutWithInjectedShaderCBuffer(params, spec)) return &spec;
  }

  return nullptr;
}

inline bool IsDeniedPipelineLayout(std::span<const PipelineLayoutParam> params) {
  return FindDeniedPipelineLayoutSpec(params) != nullptr;
}

inline bool IsAllowedPipelineLayout(std::span<const PipelineLayoutParam> params) {
  return FindAllowedPipelineLayoutSpec(params) != nullptr;
}

inline void AppendPipelineLayoutParam(std::stringstream& s, const PipelineLayoutParam& param, uint32_t param_index) {
  s << ", p" << param_index << "{type=" << static_cast<uint32_t>(param.type);

  switch (param.type) {
    case PipelineLayoutParamType::push_constants:
      s << ", cbv=b" << param.push_constants.dx_register_index;
      s << ", space=" << param.push_constants.dx_register_space;
      s << ", count=" << param.push_constants.count;
      break;
    case PipelineLayoutParamType::push_descriptors:
      s << ", desc=" << static_cast<uint32_t>(param.push_descriptors.type);
      s << ", reg=" << param.push_descriptors.dx_register_index;
      s << ", space=" << param.push_descriptors.dx_register_space;
      s << ", count=" << param.push_descriptors.count;
      break;
    case PipelineLayoutParamType::descriptor_table:
    case PipelineLayoutParamType::push_descriptors_with_ranges:
      s << ", ranges=" << param.descriptor_table.count;
      for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
        const auto& range = param.descriptor_table.ranges[range_index];
        s << ", r" << range_index << "=" << static_cast<uint32_t>(range.type);
        s << ":" << range.dx_register_index;
        s << ":s" << range.dx_register_space;
        s << ":n" << range.count;
      }
      break;
    case PipelineLayoutParamType::descriptor_table_with_static_samplers:
    case PipelineLayoutParamType::push_descriptors_with_static_samplers:
      s << ", ranges=" << param.descriptor_table_with_static_samplers.count;
      for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
        const auto& range = param.descriptor_table_with_static_samplers.ranges[range_index];
        s << ", r" << range_index << "=" << static_cast<uint32_t>(range.type);
        s << ":" << range.dx_register_index;
        s << ":s" << range.dx_register_space;
        s << ":n" << range.count;
      }
      break;
    default:
      break;
  }

  s << "}";
}

inline bool ShouldInjectPipelineLayout(std::span<const PipelineLayoutParam> params, bool allow_all) {
  if (allow_all) return true;
  if (IsDeniedPipelineLayout(params)) return false;
  return IsAllowedPipelineLayout(params);
}

}  // namespace deadspace::pipeline_layouts
