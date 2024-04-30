/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <include/reshade.hpp>
#include "./format.hpp"

namespace PipelineUtil {
  static reshade::api::pipeline_subobject* clonePipelineSubObjects(uint32_t subobjectCount, const reshade::api::pipeline_subobject* subobjects) {
    reshade::api::pipeline_subobject* newSubobjects = new reshade::api::pipeline_subobject[subobjectCount];
    memcpy(newSubobjects, subobjects, sizeof(reshade::api::pipeline_subobject) * subobjectCount);
    for (uint32_t i = 0; i < subobjectCount; ++i) {
      switch (subobjects[i].type) {
        case reshade::api::pipeline_subobject_type::vertex_shader:
        case reshade::api::pipeline_subobject_type::hull_shader:
        case reshade::api::pipeline_subobject_type::domain_shader:
        case reshade::api::pipeline_subobject_type::geometry_shader:
        case reshade::api::pipeline_subobject_type::compute_shader:
        case reshade::api::pipeline_subobject_type::pixel_shader:
          {
            newSubobjects[i].data = malloc(sizeof(reshade::api::shader_desc));
            memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::shader_desc));
            reshade::api::shader_desc* oldDesc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
            reshade::api::shader_desc* newDesc = static_cast<reshade::api::shader_desc*>(newSubobjects[i].data);
            if (oldDesc->code_size) {
              void* codeCopy = malloc(oldDesc->code_size);
              memcpy(codeCopy, oldDesc->code, oldDesc->code_size);
              newDesc->code = codeCopy;
            }

            std::stringstream s;
            s << "clonePipelineSubObjects(cloning "
              << to_string(subobjects[i].type)
              << " with 0x" << std::hex << compute_crc32(static_cast<const uint8_t*>(oldDesc->code), oldDesc->code_size) << std::dec
              << " => 0x" << std::hex << compute_crc32(static_cast<const uint8_t*>(newDesc->code), newDesc->code_size) << std::dec
              << " (" << oldDesc->code_size << " bytes)"
              << " from " << reinterpret_cast<const void*>(oldDesc->code)
              << " to " << reinterpret_cast<const void*>(newDesc->code)
              << ")";
            reshade::log_message(reshade::log_level::debug, s.str().c_str());
          }
          break;
        case reshade::api::pipeline_subobject_type::input_layout:
          newSubobjects[i].data = malloc(sizeof(reshade::api::input_element) * subobjects[i].count);
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::input_element) * subobjects[i].count);
          for (uint32_t j = 0; j < subobjects[i].count; j++) {
            reshade::api::input_element* old_input_elements = static_cast<reshade::api::input_element*>(subobjects[i].data);
            reshade::api::input_element* new_input_elements = static_cast<reshade::api::input_element*>(newSubobjects[i].data);
            new_input_elements[j].semantic = strdup(old_input_elements[j].semantic);
          }
          break;
        case reshade::api::pipeline_subobject_type::stream_output_state:
          newSubobjects[i].data = malloc(sizeof(reshade::api::stream_output_desc));
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::stream_output_desc));
          break;
        case reshade::api::pipeline_subobject_type::blend_state:
          newSubobjects[i].data = malloc(sizeof(reshade::api::blend_desc));
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::blend_desc));
          break;
        case reshade::api::pipeline_subobject_type::rasterizer_state:
          newSubobjects[i].data = malloc(sizeof(reshade::api::rasterizer_desc));
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::rasterizer_desc));
          break;
        case reshade::api::pipeline_subobject_type::depth_stencil_state:
          newSubobjects[i].data = malloc(sizeof(reshade::api::depth_stencil_desc));
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::depth_stencil_desc));
          break;
        case reshade::api::pipeline_subobject_type::primitive_topology:
          newSubobjects[i].data = malloc(sizeof(reshade::api::primitive_topology));
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::primitive_topology));
          break;
        case reshade::api::pipeline_subobject_type::depth_stencil_format:
          newSubobjects[i].data = malloc(sizeof(reshade::api::format));
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::format));
          break;
        case reshade::api::pipeline_subobject_type::render_target_formats:
          newSubobjects[i].data = malloc(sizeof(reshade::api::format) * subobjects[i].count);
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::format) * subobjects[i].count);
          break;
        case reshade::api::pipeline_subobject_type::sample_mask:
        case reshade::api::pipeline_subobject_type::sample_count:
        case reshade::api::pipeline_subobject_type::viewport_count:
          newSubobjects[i].data = malloc(sizeof(uint32_t));
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(uint32_t));
          break;
        case reshade::api::pipeline_subobject_type::dynamic_pipeline_states:
          newSubobjects[i].data = malloc(sizeof(reshade::api::dynamic_state) * subobjects[i].count);
          memcpy(newSubobjects[i].data, subobjects[i].data, sizeof(reshade::api::dynamic_state) * subobjects[i].count);
          break;
        default:
          break;
      }
    }
    return newSubobjects;
  }

}  // namespace PipelineUtil
