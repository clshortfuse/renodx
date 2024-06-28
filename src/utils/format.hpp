/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "dxgiformat.h"

#include <iomanip>
#include <ios>
#include <ostream>

#include <include/reshade.hpp>

#define PRINT_CRC32(crc32) "0x" << std::hex << std::setw(8) << std::setfill('0') << crc32 << std::setfill(' ') << std::dec

inline std::ostream& operator<<(std::ostream& os, const reshade::api::device_api value) {
  switch (value) {
    case reshade::api::device_api::d3d9:   return os << "d3d9";
    case reshade::api::device_api::d3d10:  return os << "d3d10";
    case reshade::api::device_api::d3d11:  return os << "d3d11";
    case reshade::api::device_api::d3d12:  return os << "d3d12";
    case reshade::api::device_api::opengl: return os << "opengl";
    case reshade::api::device_api::vulkan: return os << "vulkan";
    default:                               return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::shader_stage value) {
  switch (value) {
    case reshade::api::shader_stage::vertex:          return os << "vertex";
    case reshade::api::shader_stage::hull:            return os << "hull";
    case reshade::api::shader_stage::domain:          return os << "domain";
    case reshade::api::shader_stage::geometry:        return os << "geometry";
    case reshade::api::shader_stage::pixel:           return os << "pixel";
    case reshade::api::shader_stage::compute:         return os << "compute";
    case reshade::api::shader_stage::amplification:   return os << "amplification";
    case reshade::api::shader_stage::mesh:            return os << "mesh";
    case reshade::api::shader_stage::raygen:          return os << "raygen";
    case reshade::api::shader_stage::any_hit:         return os << "any_hit";
    case reshade::api::shader_stage::closest_hit:     return os << "closest_hit";
    case reshade::api::shader_stage::miss:            return os << "miss";
    case reshade::api::shader_stage::intersection:    return os << "intersection";
    case reshade::api::shader_stage::callable:        return os << "callable";
    case reshade::api::shader_stage::all:             return os << "all";
    case reshade::api::shader_stage::all_graphics:    return os << "all_graphics";
    case reshade::api::shader_stage::all_ray_tracing: return os << "all_raytracing";
    default:                                          return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const boolean value) {
  return os << ((value != 0u) ? "true" : "false");
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::blend_factor value) {
  switch (value) {
    case reshade::api::blend_factor::zero:                     return os << "zero";
    case reshade::api::blend_factor::one:                      return os << "one";
    case reshade::api::blend_factor::source_color:             return os << "source_color";
    case reshade::api::blend_factor::one_minus_source_color:   return os << "one_minus_source_color";
    case reshade::api::blend_factor::dest_color:               return os << "dest_color";
    case reshade::api::blend_factor::one_minus_dest_color:     return os << "one_minus_dest_color";
    case reshade::api::blend_factor::source_alpha:             return os << "source_alpha";
    case reshade::api::blend_factor::one_minus_source_alpha:   return os << "one_minus_source_alpha";
    case reshade::api::blend_factor::dest_alpha:               return os << "dest_alpha";
    case reshade::api::blend_factor::one_minus_dest_alpha:     return os << "one_minus_dest_alpha";
    case reshade::api::blend_factor::constant_color:           return os << "constant_color";
    case reshade::api::blend_factor::one_minus_constant_color: return os << "one_minus_constant_color";
    case reshade::api::blend_factor::constant_alpha:           return os << "constant_alpha";
    case reshade::api::blend_factor::one_minus_constant_alpha: return os << "one_minus_constant_alpha";
    case reshade::api::blend_factor::source_alpha_saturate:    return os << "source_alpha_saturate";
    case reshade::api::blend_factor::source1_color:            return os << "source1_color";
    case reshade::api::blend_factor::one_minus_source1_color:  return os << "one_minus_source1_color";
    case reshade::api::blend_factor::source1_alpha:            return os << "source1_alpha";
    case reshade::api::blend_factor::one_minus_source1_alpha:  return os << "one_minus_source1_alpha";
    default:                                                   return os << "unknown";
  };
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::blend_op value) {
  switch (value) {
    case reshade::api::blend_op::add:              return os << "add";
    case reshade::api::blend_op::subtract:         return os << "subtract";
    case reshade::api::blend_op::reverse_subtract: return os << "reverse_subtract";
    case reshade::api::blend_op::min:              return os << "min";
    case reshade::api::blend_op::max:              return os << "max";
    default:                                       return os << "unknown";
  };
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::pipeline_stage value) {
  switch (value) {
    case reshade::api::pipeline_stage::vertex_shader:        return os << "vertex_shader";
    case reshade::api::pipeline_stage::hull_shader:          return os << "hull_shader";
    case reshade::api::pipeline_stage::domain_shader:        return os << "domain_shader";
    case reshade::api::pipeline_stage::geometry_shader:      return os << "geometry_shader";
    case reshade::api::pipeline_stage::pixel_shader:         return os << "pixel_shader";
    case reshade::api::pipeline_stage::compute_shader:       return os << "compute_shader";
    case reshade::api::pipeline_stage::amplification_shader: return os << "amplification_shader";
    case reshade::api::pipeline_stage::mesh_shader:          return os << "mesh_shader";
    case reshade::api::pipeline_stage::input_assembler:      return os << "input_assembler";
    case reshade::api::pipeline_stage::stream_output:        return os << "stream_output";
    case reshade::api::pipeline_stage::rasterizer:           return os << "rasterizer";
    case reshade::api::pipeline_stage::depth_stencil:        return os << "depth_stencil";
    case reshade::api::pipeline_stage::output_merger:        return os << "output_merger";
    case reshade::api::pipeline_stage::all:                  return os << "all";
    case reshade::api::pipeline_stage::all_graphics:         return os << "all_graphics";
    case reshade::api::pipeline_stage::all_ray_tracing:      return os << "all_ray_tracing";
    case reshade::api::pipeline_stage::all_shader_stages:    return os << "all_shader_stages";
    default:                                                 return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::descriptor_type value) {
  switch (value) {
    case reshade::api::descriptor_type::sampler:                      return os << "sampler";
    case reshade::api::descriptor_type::sampler_with_resource_view:   return os << "sampler_with_resource_view";
    case reshade::api::descriptor_type::shader_resource_view:         return os << "shader_resource_view";
    case reshade::api::descriptor_type::unordered_access_view:        return os << "unordered_access_view";
    case reshade::api::descriptor_type::buffer_shader_resource_view:  return os << "buffer_shader_resource_view";
    case reshade::api::descriptor_type::buffer_unordered_access_view: return os << "buffer_unordered_access_view";
    case reshade::api::descriptor_type::constant_buffer:              return os << "constant_buffer";
    case reshade::api::descriptor_type::shader_storage_buffer:        return os << "shader_storage_buffer";
    case reshade::api::descriptor_type::acceleration_structure:       return os << "acceleration_structure";
    default:                                                          return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::dynamic_state value) {
  switch (value) {
    case reshade::api::dynamic_state::alpha_test_enable:               return os << "alpha_test_enable";
    case reshade::api::dynamic_state::alpha_reference_value:           return os << "alpha_reference_value";
    case reshade::api::dynamic_state::alpha_func:                      return os << "alpha_func";
    case reshade::api::dynamic_state::srgb_write_enable:               return os << "srgb_write_enable";
    case reshade::api::dynamic_state::primitive_topology:              return os << "primitive_topology";
    case reshade::api::dynamic_state::sample_mask:                     return os << "sample_mask";
    case reshade::api::dynamic_state::alpha_to_coverage_enable:        return os << "alpha_to_coverage_enable";
    case reshade::api::dynamic_state::blend_enable:                    return os << "blend_enable";
    case reshade::api::dynamic_state::logic_op_enable:                 return os << "logic_op_enable";
    case reshade::api::dynamic_state::color_blend_op:                  return os << "color_blend_op";
    case reshade::api::dynamic_state::source_color_blend_factor:       return os << "src_color_blend_factor";
    case reshade::api::dynamic_state::dest_color_blend_factor:         return os << "dst_color_blend_factor";
    case reshade::api::dynamic_state::alpha_blend_op:                  return os << "alpha_blend_op";
    case reshade::api::dynamic_state::source_alpha_blend_factor:       return os << "src_alpha_blend_factor";
    case reshade::api::dynamic_state::dest_alpha_blend_factor:         return os << "dst_alpha_blend_factor";
    case reshade::api::dynamic_state::logic_op:                        return os << "logic_op";
    case reshade::api::dynamic_state::blend_constant:                  return os << "blend_constant";
    case reshade::api::dynamic_state::render_target_write_mask:        return os << "render_target_write_mask";
    case reshade::api::dynamic_state::fill_mode:                       return os << "fill_mode";
    case reshade::api::dynamic_state::cull_mode:                       return os << "cull_mode";
    case reshade::api::dynamic_state::front_counter_clockwise:         return os << "front_counter_clockwise";
    case reshade::api::dynamic_state::depth_bias:                      return os << "depth_bias";
    case reshade::api::dynamic_state::depth_bias_clamp:                return os << "depth_bias_clamp";
    case reshade::api::dynamic_state::depth_bias_slope_scaled:         return os << "depth_bias_slope_scaled";
    case reshade::api::dynamic_state::depth_clip_enable:               return os << "depth_clip_enable";
    case reshade::api::dynamic_state::scissor_enable:                  return os << "scissor_enable";
    case reshade::api::dynamic_state::multisample_enable:              return os << "multisample_enable";
    case reshade::api::dynamic_state::antialiased_line_enable:         return os << "antialiased_line_enable";
    case reshade::api::dynamic_state::depth_enable:                    return os << "depth_enable";
    case reshade::api::dynamic_state::depth_write_mask:                return os << "depth_write_mask";
    case reshade::api::dynamic_state::depth_func:                      return os << "depth_func";
    case reshade::api::dynamic_state::stencil_enable:                  return os << "stencil_enable";
    case reshade::api::dynamic_state::front_stencil_read_mask:         return os << "front_stencil_read_mask";
    case reshade::api::dynamic_state::front_stencil_write_mask:        return os << "front_stencil_write_mask";
    case reshade::api::dynamic_state::front_stencil_reference_value:   return os << "front_stencil_reference_value";
    case reshade::api::dynamic_state::front_stencil_func:              return os << "front_stencil_func";
    case reshade::api::dynamic_state::front_stencil_pass_op:           return os << "front_stencil_pass_op";
    case reshade::api::dynamic_state::front_stencil_fail_op:           return os << "front_stencil_fail_op";
    case reshade::api::dynamic_state::front_stencil_depth_fail_op:     return os << "front_stencil_depth_fail_op";
    case reshade::api::dynamic_state::back_stencil_read_mask:          return os << "back_stencil_read_mask";
    case reshade::api::dynamic_state::back_stencil_write_mask:         return os << "back_stencil_write_mask";
    case reshade::api::dynamic_state::back_stencil_reference_value:    return os << "back_stencil_reference_value";
    case reshade::api::dynamic_state::back_stencil_func:               return os << "back_stencil_func";
    case reshade::api::dynamic_state::back_stencil_pass_op:            return os << "back_stencil_pass_op";
    case reshade::api::dynamic_state::back_stencil_fail_op:            return os << "back_stencil_fail_op";
    case reshade::api::dynamic_state::back_stencil_depth_fail_op:      return os << "back_stencil_depth_fail_op";
    case reshade::api::dynamic_state::ray_tracing_pipeline_stack_size: return os << "ray_tracing_pipeline_stack_size";
    case reshade::api::dynamic_state::unknown:
    default:                                                           return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::resource_usage value) {
  switch (value) {
    case reshade::api::resource_usage::index_buffer:              return os << "index_buffer";
    case reshade::api::resource_usage::vertex_buffer:             return os << "vertex_buffer";
    case reshade::api::resource_usage::constant_buffer:           return os << "constant_buffer";
    case reshade::api::resource_usage::stream_output:             return os << "stream_output";
    case reshade::api::resource_usage::indirect_argument:         return os << "indirect_argument";
    case reshade::api::resource_usage::depth_stencil:
    case reshade::api::resource_usage::depth_stencil_read:
    case reshade::api::resource_usage::depth_stencil_write:       return os << "depth_stencil";
    case reshade::api::resource_usage::render_target:             return os << "render_target";
    case reshade::api::resource_usage::shader_resource:
    case reshade::api::resource_usage::shader_resource_pixel:
    case reshade::api::resource_usage::shader_resource_non_pixel: return os << "shader_resource";
    case reshade::api::resource_usage::unordered_access:          return os << "unordered_access";
    case reshade::api::resource_usage::copy_dest:                 return os << "copy_dest";
    case reshade::api::resource_usage::copy_source:               return os << "copy_source";
    case reshade::api::resource_usage::resolve_dest:              return os << "resolve_dest";
    case reshade::api::resource_usage::resolve_source:            return os << "resolve_source";
    case reshade::api::resource_usage::acceleration_structure:    return os << "acceleration_structure";
    case reshade::api::resource_usage::general:                   return os << "general";
    case reshade::api::resource_usage::present:                   return os << "present";
    case reshade::api::resource_usage::cpu_access:                return os << "cpu_access";
    case reshade::api::resource_usage::undefined:
    default:                                                      return os << "undefined";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::format value) {
  switch (value) {
    case reshade::api::format::r1_unorm:              return os << "r1_unorm";
    case reshade::api::format::l8_unorm:              return os << "l8_unorm";
    case reshade::api::format::a8_unorm:              return os << "a8_unorm";
    case reshade::api::format::r8_typeless:           return os << "r8_typeless";
    case reshade::api::format::r8_uint:               return os << "r8_uint";
    case reshade::api::format::r8_sint:               return os << "r8_sint";
    case reshade::api::format::r8_unorm:              return os << "r8_unorm";
    case reshade::api::format::r8_snorm:              return os << "r8_snorm";
    case reshade::api::format::l8a8_unorm:            return os << "l8a8_unorm";
    case reshade::api::format::r8g8_typeless:         return os << "r8g8_typeless";
    case reshade::api::format::r8g8_uint:             return os << "r8g8_uint";
    case reshade::api::format::r8g8_sint:             return os << "r8g8_sint";
    case reshade::api::format::r8g8_unorm:            return os << "r8g8_unorm";
    case reshade::api::format::r8g8_snorm:            return os << "r8g8_snorm";
    case reshade::api::format::r8g8b8a8_typeless:     return os << "r8g8b8a8_typeless";
    case reshade::api::format::r8g8b8a8_uint:         return os << "r8g8b8a8_uint";
    case reshade::api::format::r8g8b8a8_sint:         return os << "r8g8b8a8_sint";
    case reshade::api::format::r8g8b8a8_unorm:        return os << "r8g8b8a8_unorm";
    case reshade::api::format::r8g8b8a8_unorm_srgb:   return os << "r8g8b8a8_unorm_srgb";
    case reshade::api::format::r8g8b8a8_snorm:        return os << "r8g8b8a8_snorm";
    case reshade::api::format::r8g8b8x8_unorm:        return os << "r8g8b8x8_unorm";
    case reshade::api::format::r8g8b8x8_unorm_srgb:   return os << "r8g8b8x8_unorm_srgb";
    case reshade::api::format::b8g8r8a8_typeless:     return os << "b8g8r8a8_typeless";
    case reshade::api::format::b8g8r8a8_unorm:        return os << "b8g8r8a8_unorm";
    case reshade::api::format::b8g8r8a8_unorm_srgb:   return os << "b8g8r8a8_unorm_srgb";
    case reshade::api::format::b8g8r8x8_typeless:     return os << "b8g8r8x8_typeless";
    case reshade::api::format::b8g8r8x8_unorm:        return os << "b8g8r8x8_unorm";
    case reshade::api::format::b8g8r8x8_unorm_srgb:   return os << "b8g8r8x8_unorm_srgb";
    case reshade::api::format::r10g10b10a2_typeless:  return os << "r10g10b10a2_typeless";
    case reshade::api::format::r10g10b10a2_uint:      return os << "r10g10b10a2_uint";
    case reshade::api::format::r10g10b10a2_unorm:     return os << "r10g10b10a2_unorm";
    case reshade::api::format::r10g10b10a2_xr_bias:   return os << "r10g10b10a2_xr_bias";
    case reshade::api::format::b10g10r10a2_typeless:  return os << "b10g10r10a2_typeless";
    case reshade::api::format::b10g10r10a2_uint:      return os << "b10g10r10a2_uint";
    case reshade::api::format::b10g10r10a2_unorm:     return os << "b10g10r10a2_unorm";
    case reshade::api::format::l16_unorm:             return os << "l16_unorm";
    case reshade::api::format::r16_typeless:          return os << "r16_typeless";
    case reshade::api::format::r16_uint:              return os << "r16_uint";
    case reshade::api::format::r16_sint:              return os << "r16_sint";
    case reshade::api::format::r16_unorm:             return os << "r16_unorm";
    case reshade::api::format::r16_snorm:             return os << "r16_snorm";
    case reshade::api::format::r16_float:             return os << "r16_float";
    case reshade::api::format::l16a16_unorm:          return os << "l16a16_unorm";
    case reshade::api::format::r16g16_typeless:       return os << "r16g16_typeless";
    case reshade::api::format::r16g16_uint:           return os << "r16g16_uint";
    case reshade::api::format::r16g16_sint:           return os << "r16g16_sint";
    case reshade::api::format::r16g16_unorm:          return os << "r16g16_unorm";
    case reshade::api::format::r16g16_snorm:          return os << "r16g16_snorm";
    case reshade::api::format::r16g16_float:          return os << "r16g16_float";
    case reshade::api::format::r16g16b16a16_typeless: return os << "r16g16b16a16_typeless";
    case reshade::api::format::r16g16b16a16_uint:     return os << "r16g16b16a16_uint";
    case reshade::api::format::r16g16b16a16_sint:     return os << "r16g16b16a16_sint";
    case reshade::api::format::r16g16b16a16_unorm:    return os << "r16g16b16a16_unorm";
    case reshade::api::format::r16g16b16a16_snorm:    return os << "r16g16b16a16_snorm";
    case reshade::api::format::r16g16b16a16_float:    return os << "r16g16b16a16_float";
    case reshade::api::format::r32_typeless:          return os << "r32_typeless";
    case reshade::api::format::r32_uint:              return os << "r32_uint";
    case reshade::api::format::r32_sint:              return os << "r32_sint";
    case reshade::api::format::r32_float:             return os << "r32_float";
    case reshade::api::format::r32g32_typeless:       return os << "r32g32_typeless";
    case reshade::api::format::r32g32_uint:           return os << "r32g32_uint";
    case reshade::api::format::r32g32_sint:           return os << "r32g32_sint";
    case reshade::api::format::r32g32_float:          return os << "r32g32_float";
    case reshade::api::format::r32g32b32_typeless:    return os << "r32g32b32_typeless";
    case reshade::api::format::r32g32b32_uint:        return os << "r32g32b32_uint";
    case reshade::api::format::r32g32b32_sint:        return os << "r32g32b32_sint";
    case reshade::api::format::r32g32b32_float:       return os << "r32g32b32_float";
    case reshade::api::format::r32g32b32a32_typeless: return os << "r32g32b32a32_typeless";
    case reshade::api::format::r32g32b32a32_uint:     return os << "r32g32b32a32_uint";
    case reshade::api::format::r32g32b32a32_sint:     return os << "r32g32b32a32_sint";
    case reshade::api::format::r32g32b32a32_float:    return os << "r32g32b32a32_float";
    case reshade::api::format::r9g9b9e5:              return os << "r9g9b9e5";
    case reshade::api::format::r11g11b10_float:       return os << "r11g11b10_float";
    case reshade::api::format::b5g6r5_unorm:          return os << "b5g6r5_unorm";
    case reshade::api::format::b5g5r5a1_unorm:        return os << "b5g5r5a1_unorm";
    case reshade::api::format::b5g5r5x1_unorm:        return os << "b5g5r5x1_unorm";
    case reshade::api::format::b4g4r4a4_unorm:        return os << "b4g4r4a4_unorm";
    case reshade::api::format::a4b4g4r4_unorm:        return os << "a4b4g4r4_unorm";
    case reshade::api::format::s8_uint:               return os << "s8_uint";
    case reshade::api::format::d16_unorm:             return os << "d16_unorm";
    case reshade::api::format::d16_unorm_s8_uint:     return os << "d16_unorm_s8_uint";
    case reshade::api::format::d24_unorm_x8_uint:     return os << "d24_unorm_x8_uint";
    case reshade::api::format::d24_unorm_s8_uint:     return os << "d24_unorm_s8_uint";
    case reshade::api::format::d32_float:             return os << "d32_float";
    case reshade::api::format::d32_float_s8_uint:     return os << "d32_float_s8_uint";
    case reshade::api::format::r24_g8_typeless:       return os << "r24_g8_typeless";
    case reshade::api::format::r24_unorm_x8_uint:     return os << "r24_unorm_x8_uint";
    case reshade::api::format::x24_unorm_g8_uint:     return os << "x24_unorm_g8_uint";
    case reshade::api::format::r32_g8_typeless:       return os << "r32_g8_typeless";
    case reshade::api::format::r32_float_x8_uint:     return os << "r32_float_x8_uint";
    case reshade::api::format::x32_float_g8_uint:     return os << "x32_float_g8_uint";
    case reshade::api::format::bc1_typeless:          return os << "bc1_typeless";
    case reshade::api::format::bc1_unorm:             return os << "bc1_unorm";
    case reshade::api::format::bc1_unorm_srgb:        return os << "bc1_unorm_srgb";
    case reshade::api::format::bc2_typeless:          return os << "bc2_typeless";
    case reshade::api::format::bc2_unorm:             return os << "bc2_unorm";
    case reshade::api::format::bc2_unorm_srgb:        return os << "bc2_unorm_srgb";
    case reshade::api::format::bc3_typeless:          return os << "bc3_typeless";
    case reshade::api::format::bc3_unorm:             return os << "bc3_unorm";
    case reshade::api::format::bc3_unorm_srgb:        return os << "bc3_unorm_srgb";
    case reshade::api::format::bc4_typeless:          return os << "bc4_typeless";
    case reshade::api::format::bc4_unorm:             return os << "bc4_unorm";
    case reshade::api::format::bc4_snorm:             return os << "bc4_snorm";
    case reshade::api::format::bc5_typeless:          return os << "bc5_typeless";
    case reshade::api::format::bc5_unorm:             return os << "bc5_unorm";
    case reshade::api::format::bc5_snorm:             return os << "bc5_snorm";
    case reshade::api::format::bc6h_typeless:         return os << "bc6h_typeless";
    case reshade::api::format::bc6h_ufloat:           return os << "bc6h_ufloat";
    case reshade::api::format::bc6h_sfloat:           return os << "bc6h_sfloat";
    case reshade::api::format::bc7_typeless:          return os << "bc7_typeless";
    case reshade::api::format::bc7_unorm:             return os << "bc7_unorm";
    case reshade::api::format::bc7_unorm_srgb:        return os << "bc7_unorm_srgb";
    case reshade::api::format::r8g8_b8g8_unorm:       return os << "r8g8_b8g8_unorm";
    case reshade::api::format::g8r8_g8b8_unorm:       return os << "g8r8_g8b8_unorm";
    case reshade::api::format::intz:                  return os << "intz";
    case reshade::api::format::unknown:
    default:                                          return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::pipeline_layout_param_type value) {
  switch (value) {
    case reshade::api::pipeline_layout_param_type::push_constants:               return os << "push_constants";
    case reshade::api::pipeline_layout_param_type::descriptor_table:             return os << "descriptor_table";
    case reshade::api::pipeline_layout_param_type::push_descriptors:             return os << "push_descriptors";
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges: return os << "push_descriptors_with_ranges";
    default:                                                                     return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::color_space value) {
  switch (value) {
    case reshade::api::color_space::srgb_nonlinear:       return os << "srgb_nonlinear";
    case reshade::api::color_space::extended_srgb_linear: return os << "extended_srgb_linear";
    case reshade::api::color_space::hdr10_st2084:         return os << "hdr10_st2084";
    case reshade::api::color_space::hdr10_hlg:            return os << "hdr10_hlg";
    case reshade::api::color_space::unknown:
    default:                                              return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::resource_view_type value) {
  switch (value) {
    case reshade::api::resource_view_type::buffer:                       return os << "buffer";
    case reshade::api::resource_view_type::texture_1d:                   return os << "texture_1d";
    case reshade::api::resource_view_type::texture_1d_array:             return os << "texture_1d_array";
    case reshade::api::resource_view_type::texture_2d:                   return os << "texture_2d";
    case reshade::api::resource_view_type::texture_2d_array:             return os << "texture_2d_array";
    case reshade::api::resource_view_type::texture_2d_multisample:       return os << "texture_2d_multisample";
    case reshade::api::resource_view_type::texture_2d_multisample_array: return os << "texture_2d_multisample_array";
    case reshade::api::resource_view_type::texture_3d:                   return os << "texture_3d";
    case reshade::api::resource_view_type::texture_cube:                 return os << "texture_cube";
    case reshade::api::resource_view_type::texture_cube_array:           return os << "texture_cube_array";
    case reshade::api::resource_view_type::acceleration_structure:       return os << "acceleration_structure";
    case reshade::api::resource_view_type::unknown:
    default:                                                             return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::pipeline_subobject_type value) {
  switch (value) {
    case reshade::api::pipeline_subobject_type::vertex_shader:           return os << "vertex_shader";
    case reshade::api::pipeline_subobject_type::hull_shader:             return os << "hull_shader";
    case reshade::api::pipeline_subobject_type::domain_shader:           return os << "domain_shader";
    case reshade::api::pipeline_subobject_type::geometry_shader:         return os << "geometry_shader";
    case reshade::api::pipeline_subobject_type::pixel_shader:            return os << "pixel_shader";
    case reshade::api::pipeline_subobject_type::compute_shader:          return os << "compute_shader";
    case reshade::api::pipeline_subobject_type::input_layout:            return os << "input_layout";
    case reshade::api::pipeline_subobject_type::stream_output_state:     return os << "stream_output_state";
    case reshade::api::pipeline_subobject_type::blend_state:             return os << "blend_state";
    case reshade::api::pipeline_subobject_type::rasterizer_state:        return os << "rasterizer_state";
    case reshade::api::pipeline_subobject_type::depth_stencil_state:     return os << "depth_stencil_state";
    case reshade::api::pipeline_subobject_type::primitive_topology:      return os << "primitive_topology";
    case reshade::api::pipeline_subobject_type::depth_stencil_format:    return os << "depth_stencil_format";
    case reshade::api::pipeline_subobject_type::render_target_formats:   return os << "render_target_formats";
    case reshade::api::pipeline_subobject_type::sample_mask:             return os << "sample_mask";
    case reshade::api::pipeline_subobject_type::sample_count:            return os << "sample_count";
    case reshade::api::pipeline_subobject_type::viewport_count:          return os << "viewport_count";
    case reshade::api::pipeline_subobject_type::dynamic_pipeline_states: return os << "dynamic_pipeline_states";
    case reshade::api::pipeline_subobject_type::max_vertex_count:        return os << "max_vertex_count";
    case reshade::api::pipeline_subobject_type::amplification_shader:    return os << "amplification_shader";
    case reshade::api::pipeline_subobject_type::mesh_shader:             return os << "mesh_shader";
    case reshade::api::pipeline_subobject_type::raygen_shader:           return os << "raygen_shader";
    case reshade::api::pipeline_subobject_type::any_hit_shader:          return os << "any_hit_shader";
    case reshade::api::pipeline_subobject_type::closest_hit_shader:      return os << "closest_hit_shader";
    case reshade::api::pipeline_subobject_type::miss_shader:             return os << "miss_shader";
    case reshade::api::pipeline_subobject_type::intersection_shader:     return os << "intersection_shader";
    case reshade::api::pipeline_subobject_type::callable_shader:         return os << "callable_shader";
    case reshade::api::pipeline_subobject_type::libraries:               return os << "libraries";
    case reshade::api::pipeline_subobject_type::shader_groups:           return os << "shader_groups";
    case reshade::api::pipeline_subobject_type::max_payload_size:        return os << "max_payload_size";
    case reshade::api::pipeline_subobject_type::max_attribute_size:      return os << "max_attribute_size";
    case reshade::api::pipeline_subobject_type::max_recursion_depth:     return os << "max_recursion_depth";
    case reshade::api::pipeline_subobject_type::flags:                   return os << "flags";
    default:
    case reshade::api::pipeline_subobject_type::unknown:                 return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::indirect_command value) {
  switch (value) {
    case reshade::api::indirect_command::draw:          return os << "draw";
    case reshade::api::indirect_command::draw_indexed:  return os << "draw_indexed";
    case reshade::api::indirect_command::dispatch:      return os << "dispatch";
    case reshade::api::indirect_command::dispatch_mesh: return os << "dispatch_mesh";
    case reshade::api::indirect_command::dispatch_rays: return os << "dispatch_rays";
    default:
    case reshade::api::indirect_command::unknown:       return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const reshade::api::resource_type value) {
  switch (value) {
    case reshade::api::resource_type::buffer:     return os << "buffer";
    case reshade::api::resource_type::texture_1d: return os << "texture_1d";
    case reshade::api::resource_type::texture_2d: return os << "texture_2d";
    case reshade::api::resource_type::texture_3d: return os << "texture_3d";
    case reshade::api::resource_type::surface:    return os << "surface";
    default:
    case reshade::api::resource_type::unknown:    return os << "unknown";
  }
}

inline std::ostream& operator<<(std::ostream& os, const DXGI_FORMAT value) {
  switch (value) {
    case DXGI_FORMAT_R32G32B32A32_TYPELESS:                   return os << "DXGI_FORMAT_R32G32B32A32_TYPELESS";
    case DXGI_FORMAT_R32G32B32A32_FLOAT:                      return os << "DXGI_FORMAT_R32G32B32A32_FLOAT";
    case DXGI_FORMAT_R32G32B32A32_UINT:                       return os << "DXGI_FORMAT_R32G32B32A32_UINT";
    case DXGI_FORMAT_R32G32B32A32_SINT:                       return os << "DXGI_FORMAT_R32G32B32A32_SINT";
    case DXGI_FORMAT_R32G32B32_TYPELESS:                      return os << "DXGI_FORMAT_R32G32B32_TYPELESS";
    case DXGI_FORMAT_R32G32B32_FLOAT:                         return os << "DXGI_FORMAT_R32G32B32_FLOAT";
    case DXGI_FORMAT_R32G32B32_UINT:                          return os << "DXGI_FORMAT_R32G32B32_UINT";
    case DXGI_FORMAT_R32G32B32_SINT:                          return os << "DXGI_FORMAT_R32G32B32_SINT";
    case DXGI_FORMAT_R16G16B16A16_TYPELESS:                   return os << "DXGI_FORMAT_R16G16B16A16_TYPELESS";
    case DXGI_FORMAT_R16G16B16A16_FLOAT:                      return os << "DXGI_FORMAT_R16G16B16A16_FLOAT";
    case DXGI_FORMAT_R16G16B16A16_UNORM:                      return os << "DXGI_FORMAT_R16G16B16A16_UNORM";
    case DXGI_FORMAT_R16G16B16A16_UINT:                       return os << "DXGI_FORMAT_R16G16B16A16_UINT";
    case DXGI_FORMAT_R16G16B16A16_SNORM:                      return os << "DXGI_FORMAT_R16G16B16A16_SNORM";
    case DXGI_FORMAT_R16G16B16A16_SINT:                       return os << "DXGI_FORMAT_R16G16B16A16_SINT";
    case DXGI_FORMAT_R32G32_TYPELESS:                         return os << "DXGI_FORMAT_R32G32_TYPELESS";
    case DXGI_FORMAT_R32G32_FLOAT:                            return os << "DXGI_FORMAT_R32G32_FLOAT";
    case DXGI_FORMAT_R32G32_UINT:                             return os << "DXGI_FORMAT_R32G32_UINT";
    case DXGI_FORMAT_R32G32_SINT:                             return os << "DXGI_FORMAT_R32G32_SINT";
    case DXGI_FORMAT_R32G8X24_TYPELESS:                       return os << "DXGI_FORMAT_R32G8X24_TYPELESS";
    case DXGI_FORMAT_D32_FLOAT_S8X24_UINT:                    return os << "DXGI_FORMAT_D32_FLOAT_S8X24_UINT";
    case DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS:                return os << "DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS";
    case DXGI_FORMAT_X32_TYPELESS_G8X24_UINT:                 return os << "DXGI_FORMAT_X32_TYPELESS_G8X24_UINT";
    case DXGI_FORMAT_R10G10B10A2_TYPELESS:                    return os << "DXGI_FORMAT_R10G10B10A2_TYPELESS";
    case DXGI_FORMAT_R10G10B10A2_UNORM:                       return os << "DXGI_FORMAT_R10G10B10A2_UNORM";
    case DXGI_FORMAT_R10G10B10A2_UINT:                        return os << "DXGI_FORMAT_R10G10B10A2_UINT";
    case DXGI_FORMAT_R11G11B10_FLOAT:                         return os << "DXGI_FORMAT_R11G11B10_FLOAT";
    case DXGI_FORMAT_R8G8B8A8_TYPELESS:                       return os << "DXGI_FORMAT_R8G8B8A8_TYPELESS";
    case DXGI_FORMAT_R8G8B8A8_UNORM:                          return os << "DXGI_FORMAT_R8G8B8A8_UNORM";
    case DXGI_FORMAT_R8G8B8A8_UNORM_SRGB:                     return os << "DXGI_FORMAT_R8G8B8A8_UNORM_SRGB";
    case DXGI_FORMAT_R8G8B8A8_UINT:                           return os << "DXGI_FORMAT_R8G8B8A8_UINT";
    case DXGI_FORMAT_R8G8B8A8_SNORM:                          return os << "DXGI_FORMAT_R8G8B8A8_SNORM";
    case DXGI_FORMAT_R8G8B8A8_SINT:                           return os << "DXGI_FORMAT_R8G8B8A8_SINT";
    case DXGI_FORMAT_R16G16_TYPELESS:                         return os << "DXGI_FORMAT_R16G16_TYPELESS";
    case DXGI_FORMAT_R16G16_FLOAT:                            return os << "DXGI_FORMAT_R16G16_FLOAT";
    case DXGI_FORMAT_R16G16_UNORM:                            return os << "DXGI_FORMAT_R16G16_UNORM";
    case DXGI_FORMAT_R16G16_UINT:                             return os << "DXGI_FORMAT_R16G16_UINT";
    case DXGI_FORMAT_R16G16_SNORM:                            return os << "DXGI_FORMAT_R16G16_SNORM";
    case DXGI_FORMAT_R16G16_SINT:                             return os << "DXGI_FORMAT_R16G16_SINT";
    case DXGI_FORMAT_R32_TYPELESS:                            return os << "DXGI_FORMAT_R32_TYPELESS";
    case DXGI_FORMAT_D32_FLOAT:                               return os << "DXGI_FORMAT_D32_FLOAT";
    case DXGI_FORMAT_R32_FLOAT:                               return os << "DXGI_FORMAT_R32_FLOAT";
    case DXGI_FORMAT_R32_UINT:                                return os << "DXGI_FORMAT_R32_UINT";
    case DXGI_FORMAT_R32_SINT:                                return os << "DXGI_FORMAT_R32_SINT";
    case DXGI_FORMAT_R24G8_TYPELESS:                          return os << "DXGI_FORMAT_R24G8_TYPELESS";
    case DXGI_FORMAT_D24_UNORM_S8_UINT:                       return os << "DXGI_FORMAT_D24_UNORM_S8_UINT";
    case DXGI_FORMAT_R24_UNORM_X8_TYPELESS:                   return os << "DXGI_FORMAT_R24_UNORM_X8_TYPELESS";
    case DXGI_FORMAT_X24_TYPELESS_G8_UINT:                    return os << "DXGI_FORMAT_X24_TYPELESS_G8_UINT";
    case DXGI_FORMAT_R8G8_TYPELESS:                           return os << "DXGI_FORMAT_R8G8_TYPELESS";
    case DXGI_FORMAT_R8G8_UNORM:                              return os << "DXGI_FORMAT_R8G8_UNORM";
    case DXGI_FORMAT_R8G8_UINT:                               return os << "DXGI_FORMAT_R8G8_UINT";
    case DXGI_FORMAT_R8G8_SNORM:                              return os << "DXGI_FORMAT_R8G8_SNORM";
    case DXGI_FORMAT_R8G8_SINT:                               return os << "DXGI_FORMAT_R8G8_SINT";
    case DXGI_FORMAT_R16_TYPELESS:                            return os << "DXGI_FORMAT_R16_TYPELESS";
    case DXGI_FORMAT_R16_FLOAT:                               return os << "DXGI_FORMAT_R16_FLOAT";
    case DXGI_FORMAT_D16_UNORM:                               return os << "DXGI_FORMAT_D16_UNORM";
    case DXGI_FORMAT_R16_UNORM:                               return os << "DXGI_FORMAT_R16_UNORM";
    case DXGI_FORMAT_R16_UINT:                                return os << "DXGI_FORMAT_R16_UINT";
    case DXGI_FORMAT_R16_SNORM:                               return os << "DXGI_FORMAT_R16_SNORM";
    case DXGI_FORMAT_R16_SINT:                                return os << "DXGI_FORMAT_R16_SINT";
    case DXGI_FORMAT_R8_TYPELESS:                             return os << "DXGI_FORMAT_R8_TYPELESS";
    case DXGI_FORMAT_R8_UNORM:                                return os << "DXGI_FORMAT_R8_UNORM";
    case DXGI_FORMAT_R8_UINT:                                 return os << "DXGI_FORMAT_R8_UINT";
    case DXGI_FORMAT_R8_SNORM:                                return os << "DXGI_FORMAT_R8_SNORM";
    case DXGI_FORMAT_R8_SINT:                                 return os << "DXGI_FORMAT_R8_SINT";
    case DXGI_FORMAT_A8_UNORM:                                return os << "DXGI_FORMAT_A8_UNORM";
    case DXGI_FORMAT_R1_UNORM:                                return os << "DXGI_FORMAT_R1_UNORM";
    case DXGI_FORMAT_R9G9B9E5_SHAREDEXP:                      return os << "DXGI_FORMAT_R9G9B9E5_SHAREDEXP";
    case DXGI_FORMAT_R8G8_B8G8_UNORM:                         return os << "DXGI_FORMAT_R8G8_B8G8_UNORM";
    case DXGI_FORMAT_G8R8_G8B8_UNORM:                         return os << "DXGI_FORMAT_G8R8_G8B8_UNORM";
    case DXGI_FORMAT_BC1_TYPELESS:                            return os << "DXGI_FORMAT_BC1_TYPELESS";
    case DXGI_FORMAT_BC1_UNORM:                               return os << "DXGI_FORMAT_BC1_UNORM";
    case DXGI_FORMAT_BC1_UNORM_SRGB:                          return os << "DXGI_FORMAT_BC1_UNORM_SRGB";
    case DXGI_FORMAT_BC2_TYPELESS:                            return os << "DXGI_FORMAT_BC2_TYPELESS";
    case DXGI_FORMAT_BC2_UNORM:                               return os << "DXGI_FORMAT_BC2_UNORM";
    case DXGI_FORMAT_BC2_UNORM_SRGB:                          return os << "DXGI_FORMAT_BC2_UNORM_SRGB";
    case DXGI_FORMAT_BC3_TYPELESS:                            return os << "DXGI_FORMAT_BC3_TYPELESS";
    case DXGI_FORMAT_BC3_UNORM:                               return os << "DXGI_FORMAT_BC3_UNORM";
    case DXGI_FORMAT_BC3_UNORM_SRGB:                          return os << "DXGI_FORMAT_BC3_UNORM_SRGB";
    case DXGI_FORMAT_BC4_TYPELESS:                            return os << "DXGI_FORMAT_BC4_TYPELESS";
    case DXGI_FORMAT_BC4_UNORM:                               return os << "DXGI_FORMAT_BC4_UNORM";
    case DXGI_FORMAT_BC4_SNORM:                               return os << "DXGI_FORMAT_BC4_SNORM";
    case DXGI_FORMAT_BC5_TYPELESS:                            return os << "DXGI_FORMAT_BC5_TYPELESS";
    case DXGI_FORMAT_BC5_UNORM:                               return os << "DXGI_FORMAT_BC5_UNORM";
    case DXGI_FORMAT_BC5_SNORM:                               return os << "DXGI_FORMAT_BC5_SNORM";
    case DXGI_FORMAT_B5G6R5_UNORM:                            return os << "DXGI_FORMAT_B5G6R5_UNORM";
    case DXGI_FORMAT_B5G5R5A1_UNORM:                          return os << "DXGI_FORMAT_B5G5R5A1_UNORM";
    case DXGI_FORMAT_B8G8R8A8_UNORM:                          return os << "DXGI_FORMAT_B8G8R8A8_UNORM";
    case DXGI_FORMAT_B8G8R8X8_UNORM:                          return os << "DXGI_FORMAT_B8G8R8X8_UNORM";
    case DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM:              return os << "DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM";
    case DXGI_FORMAT_B8G8R8A8_TYPELESS:                       return os << "DXGI_FORMAT_B8G8R8A8_TYPELESS";
    case DXGI_FORMAT_B8G8R8A8_UNORM_SRGB:                     return os << "DXGI_FORMAT_B8G8R8A8_UNORM_SRGB";
    case DXGI_FORMAT_B8G8R8X8_TYPELESS:                       return os << "DXGI_FORMAT_B8G8R8X8_TYPELESS";
    case DXGI_FORMAT_B8G8R8X8_UNORM_SRGB:                     return os << "DXGI_FORMAT_B8G8R8X8_UNORM_SRGB";
    case DXGI_FORMAT_BC6H_TYPELESS:                           return os << "DXGI_FORMAT_BC6H_TYPELESS";
    case DXGI_FORMAT_BC6H_UF16:                               return os << "DXGI_FORMAT_BC6H_UF16";
    case DXGI_FORMAT_BC6H_SF16:                               return os << "DXGI_FORMAT_BC6H_SF16";
    case DXGI_FORMAT_BC7_TYPELESS:                            return os << "DXGI_FORMAT_BC7_TYPELESS";
    case DXGI_FORMAT_BC7_UNORM:                               return os << "DXGI_FORMAT_BC7_UNORM";
    case DXGI_FORMAT_BC7_UNORM_SRGB:                          return os << "DXGI_FORMAT_BC7_UNORM_SRGB";
    case DXGI_FORMAT_AYUV:                                    return os << "DXGI_FORMAT_AYUV";
    case DXGI_FORMAT_Y410:                                    return os << "DXGI_FORMAT_Y410";
    case DXGI_FORMAT_Y416:                                    return os << "DXGI_FORMAT_Y416";
    case DXGI_FORMAT_NV12:                                    return os << "DXGI_FORMAT_NV12";
    case DXGI_FORMAT_P010:                                    return os << "DXGI_FORMAT_P010";
    case DXGI_FORMAT_P016:                                    return os << "DXGI_FORMAT_P016";
    case DXGI_FORMAT_420_OPAQUE:                              return os << "DXGI_FORMAT_420_OPAQUE";
    case DXGI_FORMAT_YUY2:                                    return os << "DXGI_FORMAT_YUY2";
    case DXGI_FORMAT_Y210:                                    return os << "DXGI_FORMAT_Y210";
    case DXGI_FORMAT_Y216:                                    return os << "DXGI_FORMAT_Y216";
    case DXGI_FORMAT_NV11:                                    return os << "DXGI_FORMAT_NV11";
    case DXGI_FORMAT_AI44:                                    return os << "DXGI_FORMAT_AI44";
    case DXGI_FORMAT_IA44:                                    return os << "DXGI_FORMAT_IA44";
    case DXGI_FORMAT_P8:                                      return os << "DXGI_FORMAT_P8";
    case DXGI_FORMAT_A8P8:                                    return os << "DXGI_FORMAT_A8P8";
    case DXGI_FORMAT_B4G4R4A4_UNORM:                          return os << "DXGI_FORMAT_B4G4R4A4_UNORM";
    case DXGI_FORMAT_P208:                                    return os << "DXGI_FORMAT_P208";
    case DXGI_FORMAT_V208:                                    return os << "DXGI_FORMAT_V208";
    case DXGI_FORMAT_V408:                                    return os << "DXGI_FORMAT_V408";
    case DXGI_FORMAT_SAMPLER_FEEDBACK_MIN_MIP_OPAQUE:         return os << "DXGI_FORMAT_SAMPLER_FEEDBACK_MIN_MIP_OPAQUE";
    case DXGI_FORMAT_SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE: return os << "DXGI_FORMAT_SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE";
    case DXGI_FORMAT_FORCE_UINT:                              return os << "DXGI_FORMAT_FORCE_UINT";
    case DXGI_FORMAT_UNKNOWN:
      return os << "DXGI_FORMAT_UNKNOWN";
    default:
      return os << "unknown";
  }
}
