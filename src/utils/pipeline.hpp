/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <include/reshade.hpp>
#include <span>
#include <unordered_map>
#include <vector>
#include "./format.hpp"

namespace renodx::utils::pipeline {

static reshade::api::pipeline_subobject* ClonePipelineSubObjects(const reshade::api::pipeline_subobject* subobjects, uint32_t subobject_count) {
  auto* new_subobjects = new reshade::api::pipeline_subobject[subobject_count];
  memcpy(new_subobjects, subobjects, sizeof(reshade::api::pipeline_subobject) * subobject_count);
  for (uint32_t i = 0; i < subobject_count; ++i) {
    const auto& subobject = subobjects[i];
#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::pipeline::ClonePipelineSubObjects(cloning " << subobjects[i].type << "[" << i << "]";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
    switch (subobject.type) {
      case reshade::api::pipeline_subobject_type::vertex_shader:
      case reshade::api::pipeline_subobject_type::hull_shader:
      case reshade::api::pipeline_subobject_type::domain_shader:
      case reshade::api::pipeline_subobject_type::geometry_shader:
      case reshade::api::pipeline_subobject_type::compute_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:
      case reshade::api::pipeline_subobject_type::amplification_shader:
      case reshade::api::pipeline_subobject_type::mesh_shader:
      case reshade::api::pipeline_subobject_type::raygen_shader:
      case reshade::api::pipeline_subobject_type::any_hit_shader:
      case reshade::api::pipeline_subobject_type::closest_hit_shader:
      case reshade::api::pipeline_subobject_type::miss_shader:
      case reshade::api::pipeline_subobject_type::intersection_shader:
      case reshade::api::pipeline_subobject_type::callable_shader:      {
        new_subobjects[i].data = malloc(sizeof(reshade::api::shader_desc));
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::shader_desc));
        auto* old_desc = static_cast<reshade::api::shader_desc*>(subobject.data);
        auto* new_desc = static_cast<reshade::api::shader_desc*>(new_subobjects[i].data);
        if (old_desc->code_size != 0u) {
          void* code_copy = malloc(old_desc->code_size);
          memcpy(code_copy, old_desc->code, old_desc->code_size);
          new_desc->code = code_copy;
        }

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::pipeline::ClonePipelineSubObjects(cloning ";
        s << subobject.type;
        s << " with " << PRINT_CRC32(compute_crc32(static_cast<const uint8_t*>(old_desc->code), old_desc->code_size));
        s << " => " << PRINT_CRC32(compute_crc32(static_cast<const uint8_t*>(new_desc->code), new_desc->code_size));
        s << " (" << old_desc->code_size << " bytes)";
        s << " from " << old_desc->code;
        s << " to " << new_desc->code;
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        break;
      }
      case reshade::api::pipeline_subobject_type::input_layout:
        new_subobjects[i].data = malloc(sizeof(reshade::api::input_element) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::input_element) * subobject.count);
        for (uint32_t j = 0; j < subobject.count; j++) {
          auto* old_input_elements = static_cast<reshade::api::input_element*>(subobject.data);
          auto* new_input_elements = static_cast<reshade::api::input_element*>(new_subobjects[i].data);
          new_input_elements[j].semantic = _strdup(old_input_elements[j].semantic);
        }
        break;
      case reshade::api::pipeline_subobject_type::stream_output_state:
        new_subobjects[i].data = malloc(sizeof(reshade::api::stream_output_desc) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::stream_output_desc) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::blend_state:
        new_subobjects[i].data = malloc(sizeof(reshade::api::blend_desc) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::blend_desc) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::rasterizer_state:
        new_subobjects[i].data = malloc(sizeof(reshade::api::rasterizer_desc) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::rasterizer_desc) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::depth_stencil_state:
        new_subobjects[i].data = malloc(sizeof(reshade::api::depth_stencil_desc) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::depth_stencil_desc) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::primitive_topology:
        new_subobjects[i].data = malloc(sizeof(reshade::api::primitive_topology) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::primitive_topology) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::depth_stencil_format:
      case reshade::api::pipeline_subobject_type::render_target_formats:
        new_subobjects[i].data = malloc(sizeof(reshade::api::format) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::format) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::sample_mask:
      case reshade::api::pipeline_subobject_type::sample_count:
      case reshade::api::pipeline_subobject_type::viewport_count:
      case reshade::api::pipeline_subobject_type::max_vertex_count:
      case reshade::api::pipeline_subobject_type::max_payload_size:
      case reshade::api::pipeline_subobject_type::max_attribute_size:
      case reshade::api::pipeline_subobject_type::max_recursion_depth:
        new_subobjects[i].data = malloc(sizeof(uint32_t) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(uint32_t) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::dynamic_pipeline_states:
        new_subobjects[i].data = malloc(sizeof(reshade::api::dynamic_state) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::dynamic_state) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::libraries:
      case reshade::api::pipeline_subobject_type::shader_groups:
        new_subobjects[i].data = malloc(sizeof(reshade::api::shader_group) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::shader_group) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::flags:
        new_subobjects[i].data = malloc(sizeof(reshade::api::pipeline_flags) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::pipeline_flags) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::unknown:
        break;
    }
  }

  return new_subobjects;
}

static void DestroyPipelineSubobjects(std::span<reshade::api::pipeline_subobject> subobjects) {
  for (auto& subobject : subobjects) {
    switch (subobject.type) {
      case reshade::api::pipeline_subobject_type::vertex_shader:
      case reshade::api::pipeline_subobject_type::compute_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:   {
        auto* desc = static_cast<reshade::api::shader_desc*>(subobject.data);
        free(const_cast<void*>(desc->code));
        desc->code = nullptr;
        break;
      }
      default:
        break;
    }

    free(subobject.data);
    subobject.data = nullptr;
  }
}

static void DestroyPipelineSubobjects(reshade::api::pipeline_subobject* subobjects, uint32_t subobject_count) {
  DestroyPipelineSubobjects({subobjects, subobjects + subobject_count});
  delete[] subobjects;
}

static bool HasSDRAlphaBlend(std::span<const reshade::api::pipeline_subobject> subobjects) {
  for (const auto& subobject : subobjects) {
    if (subobject.type != reshade::api::pipeline_subobject_type::blend_state) continue;
    for (uint32_t j = 0; j < subobject.count; ++j) {
      auto& desc = static_cast<reshade::api::blend_desc*>(subobject.data)[j];
      if (!desc.blend_enable[0]) continue;

      if (((desc.render_target_write_mask[0] & 0x1) != 0)
          || ((desc.render_target_write_mask[0] & 0x2) != 0)
          || ((desc.render_target_write_mask[0] & 0x4) != 0)) {
        if (desc.color_blend_op[0] != reshade::api::blend_op::min
            && desc.color_blend_op[0] != reshade::api::blend_op::max) {
          if (
              desc.source_color_blend_factor[0] == reshade::api::blend_factor::dest_alpha
              || desc.source_color_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
              || desc.dest_color_blend_factor[0] == reshade::api::blend_factor::dest_alpha
              || desc.dest_color_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha) {
            return true;
          }
        }
      }
      if ((desc.render_target_write_mask[0] & 0x8) != 0) {
        if (desc.alpha_blend_op[0] == reshade::api::blend_op::min
            || desc.alpha_blend_op[0] == reshade::api::blend_op::max) {
          return true;
        }
        if (
            desc.source_alpha_blend_factor[0] == reshade::api::blend_factor::dest_alpha
            || desc.source_alpha_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
            || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::one
            || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::dest_alpha
            || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha) {
          return true;
        }
      }
    }
  }
  return false;
}

static reshade::api::pipeline CreateRenderPipeline(
    reshade::api::device* device,
    const reshade::api::pipeline_layout layout,
    const std::unordered_map<reshade::api::pipeline_subobject_type, std::vector<std::uint8_t>>& shaders,
    const reshade::api::format render_target_format = reshade::api::format::r16g16b16a16_float) {
  auto format = render_target_format;
  uint32_t num_vertices = 3;
  auto topology = reshade::api::primitive_topology::triangle_list;
  reshade::api::blend_desc blend_state = {};
  reshade::api::rasterizer_desc rasterizer_state = {.cull_mode = reshade::api::cull_mode::none};
  reshade::api::depth_stencil_desc depth_stencil_state = {.depth_enable = false};

  std::vector<reshade::api::pipeline_subobject> subobjects = {
      {.type = reshade::api::pipeline_subobject_type::render_target_formats, .count = 1, .data = &format},
      {.type = reshade::api::pipeline_subobject_type::max_vertex_count, .count = 1, .data = &num_vertices},
      {.type = reshade::api::pipeline_subobject_type::primitive_topology, .count = 1, .data = &topology},
      {.type = reshade::api::pipeline_subobject_type::blend_state, .count = 1, .data = &blend_state},
      {.type = reshade::api::pipeline_subobject_type::rasterizer_state, .count = 1, .data = &rasterizer_state},
      {.type = reshade::api::pipeline_subobject_type::depth_stencil_state, .count = 1, .data = &depth_stencil_state},
  };

  std::vector<reshade::api::shader_desc> shader_descriptions;
  for (const auto& [type, shader] : shaders) {
    shader_descriptions.push_back({
        .code = shader.data(),
        .code_size = shader.size(),
    });
    subobjects.push_back({.type = type, .count = 1, .data = &shader_descriptions.back()});
  }

  reshade::api::pipeline pipeline;
  if (device->create_pipeline(layout, static_cast<uint32_t>(subobjects.size()), subobjects.data(), &pipeline)) {
    return pipeline;
  }
  return {0};
}
}  // namespace renodx::utils::pipeline
