/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <span>

#include <include/reshade.hpp>

namespace rdr2vk::pipeline_layouts {

// All game shaders we replace are pixel shaders. Leave a layout alone when none
// of its settings or resources can be used by a pixel shader. A layout shared
// with compute shaders still needs our settings if a pixel shader can use it.
// Use this same check before creation and when recording the finished layout.
static bool ShouldInject(std::span<const reshade::api::pipeline_layout_param> params) {
  const auto has_pixel_ranges = [](auto ranges) {
    return std::ranges::any_of(ranges, [](const auto& range) {
      return range.count != 0 && (range.visibility & reshade::api::shader_stage::pixel) != 0;
    });
  };
  for (const auto& param : params) {
    switch (param.type) {
      case reshade::api::pipeline_layout_param_type::push_constants:
        if (has_pixel_ranges(std::span{&param.push_constants, 1})) return true;
        break;
      case reshade::api::pipeline_layout_param_type::push_descriptors:
        if (has_pixel_ranges(std::span{&param.push_descriptors, 1})) return true;
        break;
      case reshade::api::pipeline_layout_param_type::descriptor_table:
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
        if (has_pixel_ranges(std::span{param.descriptor_table.ranges, param.descriptor_table.count})) return true;
        break;
#if RESHADE_API_VERSION >= 20
      case reshade::api::pipeline_layout_param_type::descriptor_table_with_flags:
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges_and_flags:
        if (has_pixel_ranges(std::span{param.descriptor_table_with_flags.ranges, param.descriptor_table_with_flags.count})) return true;
        break;
#else
      case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
        if (has_pixel_ranges(std::span{param.descriptor_table_with_static_samplers.ranges, param.descriptor_table_with_static_samplers.count})) return true;
        break;
#endif
      default:
        break;
    }
  }
  return false;
}

}  // namespace rdr2vk::pipeline_layouts