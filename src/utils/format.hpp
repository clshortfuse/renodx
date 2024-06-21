/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <include/reshade.hpp>

#define PRINT_CRC32(crc32) "0x" << std::hex << std::setw(8) << std::setfill('0') << crc32 << std::setfill(' ') << std::dec

namespace {

  inline auto to_string(reshade::api::shader_stage value) {
    switch (value) {
      case reshade::api::shader_stage::vertex:          return "vertex";
      case reshade::api::shader_stage::hull:            return "hull";
      case reshade::api::shader_stage::domain:          return "domain";
      case reshade::api::shader_stage::geometry:        return "geometry";
      case reshade::api::shader_stage::pixel:           return "pixel";
      case reshade::api::shader_stage::compute:         return "compute";
      case reshade::api::shader_stage::amplification:   return "amplification";
      case reshade::api::shader_stage::mesh:            return "mesh";
      case reshade::api::shader_stage::raygen:          return "raygen";
      case reshade::api::shader_stage::any_hit:         return "any_hit";
      case reshade::api::shader_stage::closest_hit:     return "closest_hit";
      case reshade::api::shader_stage::miss:            return "miss";
      case reshade::api::shader_stage::intersection:    return "intersection";
      case reshade::api::shader_stage::callable:        return "callable";
      case reshade::api::shader_stage::all:             return "all";
      case reshade::api::shader_stage::all_graphics:    return "all_graphics";
      case reshade::api::shader_stage::all_ray_tracing: return "all_raytracing";
      default:                                          return "unknown";
    }
  }

  inline auto to_string(boolean value) {
    return value ? "true" : "false";
  }

  inline auto to_string(reshade::api::blend_factor value) {
    switch (value) {
      case reshade::api::blend_factor::zero:                     return "zero";
      case reshade::api::blend_factor::one:                      return "one";
      case reshade::api::blend_factor::source_color:             return "source_color";
      case reshade::api::blend_factor::one_minus_source_color:   return "one_minus_source_color";
      case reshade::api::blend_factor::dest_color:               return "dest_color";
      case reshade::api::blend_factor::one_minus_dest_color:     return "one_minus_dest_color";
      case reshade::api::blend_factor::source_alpha:             return "source_alpha";
      case reshade::api::blend_factor::one_minus_source_alpha:   return "one_minus_source_alpha";
      case reshade::api::blend_factor::dest_alpha:               return "dest_alpha";
      case reshade::api::blend_factor::one_minus_dest_alpha:     return "one_minus_dest_alpha";
      case reshade::api::blend_factor::constant_color:           return "constant_color";
      case reshade::api::blend_factor::one_minus_constant_color: return "one_minus_constant_color";
      case reshade::api::blend_factor::constant_alpha:           return "constant_alpha";
      case reshade::api::blend_factor::one_minus_constant_alpha: return "one_minus_constant_alpha";
      case reshade::api::blend_factor::source_alpha_saturate:    return "source_alpha_saturate";
      case reshade::api::blend_factor::source1_color:            return "source1_color";
      case reshade::api::blend_factor::one_minus_source1_color:  return "one_minus_source1_color";
      case reshade::api::blend_factor::source1_alpha:            return "source1_alpha";
      case reshade::api::blend_factor::one_minus_source1_alpha:  return "one_minus_source1_alpha";
      default:                                                   return "unknown";
    };
  }

  inline auto to_string(reshade::api::blend_op value) {
    switch (value) {
      case reshade::api::blend_op::add:              return "add";
      case reshade::api::blend_op::subtract:         return "subtract";
      case reshade::api::blend_op::reverse_subtract: return "reverse_subtract";
      case reshade::api::blend_op::min:              return "min";
      case reshade::api::blend_op::max:              return "max";
      default:                                       return "unknown";
    };
  }

  inline auto to_string(reshade::api::pipeline_stage value) {
    switch (value) {
      case reshade::api::pipeline_stage::vertex_shader:        return "vertex_shader";
      case reshade::api::pipeline_stage::hull_shader:          return "hull_shader";
      case reshade::api::pipeline_stage::domain_shader:        return "domain_shader";
      case reshade::api::pipeline_stage::geometry_shader:      return "geometry_shader";
      case reshade::api::pipeline_stage::pixel_shader:         return "pixel_shader";
      case reshade::api::pipeline_stage::compute_shader:       return "compute_shader";
      case reshade::api::pipeline_stage::amplification_shader: return "amplification_shader";
      case reshade::api::pipeline_stage::mesh_shader:          return "mesh_shader";
      case reshade::api::pipeline_stage::input_assembler:      return "input_assembler";
      case reshade::api::pipeline_stage::stream_output:        return "stream_output";
      case reshade::api::pipeline_stage::rasterizer:           return "rasterizer";
      case reshade::api::pipeline_stage::depth_stencil:        return "depth_stencil";
      case reshade::api::pipeline_stage::output_merger:        return "output_merger";
      case reshade::api::pipeline_stage::all:                  return "all";
      case reshade::api::pipeline_stage::all_graphics:         return "all_graphics";
      case reshade::api::pipeline_stage::all_ray_tracing:      return "all_ray_tracing";
      case reshade::api::pipeline_stage::all_shader_stages:    return "all_shader_stages";
      default:                                                 return "unknown";
    }
  }

  inline auto to_string(reshade::api::descriptor_type value) {
    switch (value) {
      case reshade::api::descriptor_type::sampler:                      return "sampler";
      case reshade::api::descriptor_type::sampler_with_resource_view:   return "sampler_with_resource_view";
      case reshade::api::descriptor_type::shader_resource_view:         return "shader_resource_view";
      case reshade::api::descriptor_type::unordered_access_view:        return "unordered_access_view";
      case reshade::api::descriptor_type::buffer_shader_resource_view:  return "buffer_shader_resource_view";
      case reshade::api::descriptor_type::buffer_unordered_access_view: return "buffer_unordered_access_view";
      case reshade::api::descriptor_type::constant_buffer:              return "constant_buffer";
      case reshade::api::descriptor_type::shader_storage_buffer:        return "shader_storage_buffer";
      case reshade::api::descriptor_type::acceleration_structure:       return "acceleration_structure";
      default:                                                          return "unknown";
    }
  }

  inline auto to_string(reshade::api::dynamic_state value) {
    switch (value) {
      case reshade::api::dynamic_state::alpha_test_enable:               return "alpha_test_enable";
      case reshade::api::dynamic_state::alpha_reference_value:           return "alpha_reference_value";
      case reshade::api::dynamic_state::alpha_func:                      return "alpha_func";
      case reshade::api::dynamic_state::srgb_write_enable:               return "srgb_write_enable";
      case reshade::api::dynamic_state::primitive_topology:              return "primitive_topology";
      case reshade::api::dynamic_state::sample_mask:                     return "sample_mask";
      case reshade::api::dynamic_state::alpha_to_coverage_enable:        return "alpha_to_coverage_enable";
      case reshade::api::dynamic_state::blend_enable:                    return "blend_enable";
      case reshade::api::dynamic_state::logic_op_enable:                 return "logic_op_enable";
      case reshade::api::dynamic_state::color_blend_op:                  return "color_blend_op";
      case reshade::api::dynamic_state::source_color_blend_factor:       return "src_color_blend_factor";
      case reshade::api::dynamic_state::dest_color_blend_factor:         return "dst_color_blend_factor";
      case reshade::api::dynamic_state::alpha_blend_op:                  return "alpha_blend_op";
      case reshade::api::dynamic_state::source_alpha_blend_factor:       return "src_alpha_blend_factor";
      case reshade::api::dynamic_state::dest_alpha_blend_factor:         return "dst_alpha_blend_factor";
      case reshade::api::dynamic_state::logic_op:                        return "logic_op";
      case reshade::api::dynamic_state::blend_constant:                  return "blend_constant";
      case reshade::api::dynamic_state::render_target_write_mask:        return "render_target_write_mask";
      case reshade::api::dynamic_state::fill_mode:                       return "fill_mode";
      case reshade::api::dynamic_state::cull_mode:                       return "cull_mode";
      case reshade::api::dynamic_state::front_counter_clockwise:         return "front_counter_clockwise";
      case reshade::api::dynamic_state::depth_bias:                      return "depth_bias";
      case reshade::api::dynamic_state::depth_bias_clamp:                return "depth_bias_clamp";
      case reshade::api::dynamic_state::depth_bias_slope_scaled:         return "depth_bias_slope_scaled";
      case reshade::api::dynamic_state::depth_clip_enable:               return "depth_clip_enable";
      case reshade::api::dynamic_state::scissor_enable:                  return "scissor_enable";
      case reshade::api::dynamic_state::multisample_enable:              return "multisample_enable";
      case reshade::api::dynamic_state::antialiased_line_enable:         return "antialiased_line_enable";
      case reshade::api::dynamic_state::depth_enable:                    return "depth_enable";
      case reshade::api::dynamic_state::depth_write_mask:                return "depth_write_mask";
      case reshade::api::dynamic_state::depth_func:                      return "depth_func";
      case reshade::api::dynamic_state::stencil_enable:                  return "stencil_enable";
      case reshade::api::dynamic_state::front_stencil_read_mask:         return "front_stencil_read_mask";
      case reshade::api::dynamic_state::front_stencil_write_mask:        return "front_stencil_write_mask";
      case reshade::api::dynamic_state::front_stencil_reference_value:   return "front_stencil_reference_value";
      case reshade::api::dynamic_state::front_stencil_func:              return "front_stencil_func";
      case reshade::api::dynamic_state::front_stencil_pass_op:           return "front_stencil_pass_op";
      case reshade::api::dynamic_state::front_stencil_fail_op:           return "front_stencil_fail_op";
      case reshade::api::dynamic_state::front_stencil_depth_fail_op:     return "front_stencil_depth_fail_op";
      case reshade::api::dynamic_state::back_stencil_read_mask:          return "back_stencil_read_mask";
      case reshade::api::dynamic_state::back_stencil_write_mask:         return "back_stencil_write_mask";
      case reshade::api::dynamic_state::back_stencil_reference_value:    return "back_stencil_reference_value";
      case reshade::api::dynamic_state::back_stencil_func:               return "back_stencil_func";
      case reshade::api::dynamic_state::back_stencil_pass_op:            return "back_stencil_pass_op";
      case reshade::api::dynamic_state::back_stencil_fail_op:            return "back_stencil_fail_op";
      case reshade::api::dynamic_state::back_stencil_depth_fail_op:      return "back_stencil_depth_fail_op";
      case reshade::api::dynamic_state::ray_tracing_pipeline_stack_size: return "ray_tracing_pipeline_stack_size";
      case reshade::api::dynamic_state::unknown:
      default:                                                           return "unknown";
    }
  }

  inline auto to_string(reshade::api::resource_usage value) {
    switch (value) {
      case reshade::api::resource_usage::index_buffer:              return "index_buffer";
      case reshade::api::resource_usage::vertex_buffer:             return "vertex_buffer";
      case reshade::api::resource_usage::constant_buffer:           return "constant_buffer";
      case reshade::api::resource_usage::stream_output:             return "stream_output";
      case reshade::api::resource_usage::indirect_argument:         return "indirect_argument";
      case reshade::api::resource_usage::depth_stencil:
      case reshade::api::resource_usage::depth_stencil_read:
      case reshade::api::resource_usage::depth_stencil_write:       return "depth_stencil";
      case reshade::api::resource_usage::render_target:             return "render_target";
      case reshade::api::resource_usage::shader_resource:
      case reshade::api::resource_usage::shader_resource_pixel:
      case reshade::api::resource_usage::shader_resource_non_pixel: return "shader_resource";
      case reshade::api::resource_usage::unordered_access:          return "unordered_access";
      case reshade::api::resource_usage::copy_dest:                 return "copy_dest";
      case reshade::api::resource_usage::copy_source:               return "copy_source";
      case reshade::api::resource_usage::resolve_dest:              return "resolve_dest";
      case reshade::api::resource_usage::resolve_source:            return "resolve_source";
      case reshade::api::resource_usage::acceleration_structure:    return "acceleration_structure";
      case reshade::api::resource_usage::general:                   return "general";
      case reshade::api::resource_usage::present:                   return "present";
      case reshade::api::resource_usage::cpu_access:                return "cpu_access";
      case reshade::api::resource_usage::undefined:
      default:                                                      return "undefined";
    }
  }

  inline auto to_string(reshade::api::format value) {
    switch (value) {
      case reshade::api::format::r1_unorm:              return "r1_unorm";
      case reshade::api::format::l8_unorm:              return "l8_unorm";
      case reshade::api::format::a8_unorm:              return "a8_unorm";
      case reshade::api::format::r8_typeless:           return "r8_typeless";
      case reshade::api::format::r8_uint:               return "r8_uint";
      case reshade::api::format::r8_sint:               return "r8_sint";
      case reshade::api::format::r8_unorm:              return "r8_unorm";
      case reshade::api::format::r8_snorm:              return "r8_snorm";
      case reshade::api::format::l8a8_unorm:            return "l8a8_unorm";
      case reshade::api::format::r8g8_typeless:         return "r8g8_typeless";
      case reshade::api::format::r8g8_uint:             return "r8g8_uint";
      case reshade::api::format::r8g8_sint:             return "r8g8_sint";
      case reshade::api::format::r8g8_unorm:            return "r8g8_unorm";
      case reshade::api::format::r8g8_snorm:            return "r8g8_snorm";
      case reshade::api::format::r8g8b8a8_typeless:     return "r8g8b8a8_typeless";
      case reshade::api::format::r8g8b8a8_uint:         return "r8g8b8a8_uint";
      case reshade::api::format::r8g8b8a8_sint:         return "r8g8b8a8_sint";
      case reshade::api::format::r8g8b8a8_unorm:        return "r8g8b8a8_unorm";
      case reshade::api::format::r8g8b8a8_unorm_srgb:   return "r8g8b8a8_unorm_srgb";
      case reshade::api::format::r8g8b8a8_snorm:        return "r8g8b8a8_snorm";
      case reshade::api::format::r8g8b8x8_unorm:        return "r8g8b8x8_unorm";
      case reshade::api::format::r8g8b8x8_unorm_srgb:   return "r8g8b8x8_unorm_srgb";
      case reshade::api::format::b8g8r8a8_typeless:     return "b8g8r8a8_typeless";
      case reshade::api::format::b8g8r8a8_unorm:        return "b8g8r8a8_unorm";
      case reshade::api::format::b8g8r8a8_unorm_srgb:   return "b8g8r8a8_unorm_srgb";
      case reshade::api::format::b8g8r8x8_typeless:     return "b8g8r8x8_typeless";
      case reshade::api::format::b8g8r8x8_unorm:        return "b8g8r8x8_unorm";
      case reshade::api::format::b8g8r8x8_unorm_srgb:   return "b8g8r8x8_unorm_srgb";
      case reshade::api::format::r10g10b10a2_typeless:  return "r10g10b10a2_typeless";
      case reshade::api::format::r10g10b10a2_uint:      return "r10g10b10a2_uint";
      case reshade::api::format::r10g10b10a2_unorm:     return "r10g10b10a2_unorm";
      case reshade::api::format::r10g10b10a2_xr_bias:   return "r10g10b10a2_xr_bias";
      case reshade::api::format::b10g10r10a2_typeless:  return "b10g10r10a2_typeless";
      case reshade::api::format::b10g10r10a2_uint:      return "b10g10r10a2_uint";
      case reshade::api::format::b10g10r10a2_unorm:     return "b10g10r10a2_unorm";
      case reshade::api::format::l16_unorm:             return "l16_unorm";
      case reshade::api::format::r16_typeless:          return "r16_typeless";
      case reshade::api::format::r16_uint:              return "r16_uint";
      case reshade::api::format::r16_sint:              return "r16_sint";
      case reshade::api::format::r16_unorm:             return "r16_unorm";
      case reshade::api::format::r16_snorm:             return "r16_snorm";
      case reshade::api::format::r16_float:             return "r16_float";
      case reshade::api::format::l16a16_unorm:          return "l16a16_unorm";
      case reshade::api::format::r16g16_typeless:       return "r16g16_typeless";
      case reshade::api::format::r16g16_uint:           return "r16g16_uint";
      case reshade::api::format::r16g16_sint:           return "r16g16_sint";
      case reshade::api::format::r16g16_unorm:          return "r16g16_unorm";
      case reshade::api::format::r16g16_snorm:          return "r16g16_snorm";
      case reshade::api::format::r16g16_float:          return "r16g16_float";
      case reshade::api::format::r16g16b16a16_typeless: return "r16g16b16a16_typeless";
      case reshade::api::format::r16g16b16a16_uint:     return "r16g16b16a16_uint";
      case reshade::api::format::r16g16b16a16_sint:     return "r16g16b16a16_sint";
      case reshade::api::format::r16g16b16a16_unorm:    return "r16g16b16a16_unorm";
      case reshade::api::format::r16g16b16a16_snorm:    return "r16g16b16a16_snorm";
      case reshade::api::format::r16g16b16a16_float:    return "r16g16b16a16_float";
      case reshade::api::format::r32_typeless:          return "r32_typeless";
      case reshade::api::format::r32_uint:              return "r32_uint";
      case reshade::api::format::r32_sint:              return "r32_sint";
      case reshade::api::format::r32_float:             return "r32_float";
      case reshade::api::format::r32g32_typeless:       return "r32g32_typeless";
      case reshade::api::format::r32g32_uint:           return "r32g32_uint";
      case reshade::api::format::r32g32_sint:           return "r32g32_sint";
      case reshade::api::format::r32g32_float:          return "r32g32_float";
      case reshade::api::format::r32g32b32_typeless:    return "r32g32b32_typeless";
      case reshade::api::format::r32g32b32_uint:        return "r32g32b32_uint";
      case reshade::api::format::r32g32b32_sint:        return "r32g32b32_sint";
      case reshade::api::format::r32g32b32_float:       return "r32g32b32_float";
      case reshade::api::format::r32g32b32a32_typeless: return "r32g32b32a32_typeless";
      case reshade::api::format::r32g32b32a32_uint:     return "r32g32b32a32_uint";
      case reshade::api::format::r32g32b32a32_sint:     return "r32g32b32a32_sint";
      case reshade::api::format::r32g32b32a32_float:    return "r32g32b32a32_float";
      case reshade::api::format::r9g9b9e5:              return "r9g9b9e5";
      case reshade::api::format::r11g11b10_float:       return "r11g11b10_float";
      case reshade::api::format::b5g6r5_unorm:          return "b5g6r5_unorm";
      case reshade::api::format::b5g5r5a1_unorm:        return "b5g5r5a1_unorm";
      case reshade::api::format::b5g5r5x1_unorm:        return "b5g5r5x1_unorm";
      case reshade::api::format::b4g4r4a4_unorm:        return "b4g4r4a4_unorm";
      case reshade::api::format::a4b4g4r4_unorm:        return "a4b4g4r4_unorm";
      case reshade::api::format::s8_uint:               return "s8_uint";
      case reshade::api::format::d16_unorm:             return "d16_unorm";
      case reshade::api::format::d16_unorm_s8_uint:     return "d16_unorm_s8_uint";
      case reshade::api::format::d24_unorm_x8_uint:     return "d24_unorm_x8_uint";
      case reshade::api::format::d24_unorm_s8_uint:     return "d24_unorm_s8_uint";
      case reshade::api::format::d32_float:             return "d32_float";
      case reshade::api::format::d32_float_s8_uint:     return "d32_float_s8_uint";
      case reshade::api::format::r24_g8_typeless:       return "r24_g8_typeless";
      case reshade::api::format::r24_unorm_x8_uint:     return "r24_unorm_x8_uint";
      case reshade::api::format::x24_unorm_g8_uint:     return "x24_unorm_g8_uint";
      case reshade::api::format::r32_g8_typeless:       return "r32_g8_typeless";
      case reshade::api::format::r32_float_x8_uint:     return "r32_float_x8_uint";
      case reshade::api::format::x32_float_g8_uint:     return "x32_float_g8_uint";
      case reshade::api::format::bc1_typeless:          return "bc1_typeless";
      case reshade::api::format::bc1_unorm:             return "bc1_unorm";
      case reshade::api::format::bc1_unorm_srgb:        return "bc1_unorm_srgb";
      case reshade::api::format::bc2_typeless:          return "bc2_typeless";
      case reshade::api::format::bc2_unorm:             return "bc2_unorm";
      case reshade::api::format::bc2_unorm_srgb:        return "bc2_unorm_srgb";
      case reshade::api::format::bc3_typeless:          return "bc3_typeless";
      case reshade::api::format::bc3_unorm:             return "bc3_unorm";
      case reshade::api::format::bc3_unorm_srgb:        return "bc3_unorm_srgb";
      case reshade::api::format::bc4_typeless:          return "bc4_typeless";
      case reshade::api::format::bc4_unorm:             return "bc4_unorm";
      case reshade::api::format::bc4_snorm:             return "bc4_snorm";
      case reshade::api::format::bc5_typeless:          return "bc5_typeless";
      case reshade::api::format::bc5_unorm:             return "bc5_unorm";
      case reshade::api::format::bc5_snorm:             return "bc5_snorm";
      case reshade::api::format::bc6h_typeless:         return "bc6h_typeless";
      case reshade::api::format::bc6h_ufloat:           return "bc6h_ufloat";
      case reshade::api::format::bc6h_sfloat:           return "bc6h_sfloat";
      case reshade::api::format::bc7_typeless:          return "bc7_typeless";
      case reshade::api::format::bc7_unorm:             return "bc7_unorm";
      case reshade::api::format::bc7_unorm_srgb:        return "bc7_unorm_srgb";
      case reshade::api::format::r8g8_b8g8_unorm:       return "r8g8_b8g8_unorm";
      case reshade::api::format::g8r8_g8b8_unorm:       return "g8r8_g8b8_unorm";
      case reshade::api::format::intz:                  return "intz";
      case reshade::api::format::unknown:
      default:                                          return "unknown";
    }
  }

  inline auto to_string(reshade::api::pipeline_layout_param_type value) {
    switch (value) {
      case reshade::api::pipeline_layout_param_type::push_constants:               return "push_constants";
      case reshade::api::pipeline_layout_param_type::descriptor_table:             return "descriptor_table";
      case reshade::api::pipeline_layout_param_type::push_descriptors:             return "push_descriptors";
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges: return "push_descriptors_with_ranges";
      default:                                                                     return "unknown";
    }
  }

  inline auto to_string(reshade::api::color_space value) {
    switch (value) {
      case reshade::api::color_space::srgb_nonlinear:       return "srgb_nonlinear";
      case reshade::api::color_space::extended_srgb_linear: return "extended_srgb_linear";
      case reshade::api::color_space::hdr10_st2084:         return "hdr10_st2084";
      case reshade::api::color_space::hdr10_hlg:            return "hdr10_hlg";
      case reshade::api::color_space::unknown:
      default:                                              return "unknown";
    }
  }

  inline auto to_string(reshade::api::resource_view_type value) {
    switch (value) {
      case reshade::api::resource_view_type::buffer:                       return "buffer";
      case reshade::api::resource_view_type::texture_1d:                   return "texture_1d";
      case reshade::api::resource_view_type::texture_1d_array:             return "texture_1d_array";
      case reshade::api::resource_view_type::texture_2d:                   return "texture_2d";
      case reshade::api::resource_view_type::texture_2d_array:             return "texture_2d_array";
      case reshade::api::resource_view_type::texture_2d_multisample:       return "texture_2d_multisample";
      case reshade::api::resource_view_type::texture_2d_multisample_array: return "texture_2d_multisample_array";
      case reshade::api::resource_view_type::texture_3d:                   return "texture_3d";
      case reshade::api::resource_view_type::texture_cube:                 return "texture_cube";
      case reshade::api::resource_view_type::texture_cube_array:           return "texture_cube_array";
      case reshade::api::resource_view_type::acceleration_structure:       return "acceleration_structure";
      case reshade::api::resource_view_type::unknown:
      default:                                                             return "unknown";
    }
  }

  inline auto to_string(reshade::api::pipeline_subobject_type value) {
    switch (value) {
      case reshade::api::pipeline_subobject_type::vertex_shader:           return "vertex_shader";
      case reshade::api::pipeline_subobject_type::hull_shader:             return "hull_shader";
      case reshade::api::pipeline_subobject_type::domain_shader:           return "domain_shader";
      case reshade::api::pipeline_subobject_type::geometry_shader:         return "geometry_shader";
      case reshade::api::pipeline_subobject_type::pixel_shader:            return "pixel_shader";
      case reshade::api::pipeline_subobject_type::compute_shader:          return "compute_shader";
      case reshade::api::pipeline_subobject_type::input_layout:            return "input_layout";
      case reshade::api::pipeline_subobject_type::stream_output_state:     return "stream_output_state";
      case reshade::api::pipeline_subobject_type::blend_state:             return "blend_state";
      case reshade::api::pipeline_subobject_type::rasterizer_state:        return "rasterizer_state";
      case reshade::api::pipeline_subobject_type::depth_stencil_state:     return "depth_stencil_state";
      case reshade::api::pipeline_subobject_type::primitive_topology:      return "primitive_topology";
      case reshade::api::pipeline_subobject_type::depth_stencil_format:    return "depth_stencil_format";
      case reshade::api::pipeline_subobject_type::render_target_formats:   return "render_target_formats";
      case reshade::api::pipeline_subobject_type::sample_mask:             return "sample_mask";
      case reshade::api::pipeline_subobject_type::sample_count:            return "sample_count";
      case reshade::api::pipeline_subobject_type::viewport_count:          return "viewport_count";
      case reshade::api::pipeline_subobject_type::dynamic_pipeline_states: return "dynamic_pipeline_states";
      case reshade::api::pipeline_subobject_type::max_vertex_count:        return "max_vertex_count";
      case reshade::api::pipeline_subobject_type::amplification_shader:    return "amplification_shader";
      case reshade::api::pipeline_subobject_type::mesh_shader:             return "mesh_shader";
      case reshade::api::pipeline_subobject_type::raygen_shader:           return "raygen_shader";
      case reshade::api::pipeline_subobject_type::any_hit_shader:          return "any_hit_shader";
      case reshade::api::pipeline_subobject_type::closest_hit_shader:      return "closest_hit_shader";
      case reshade::api::pipeline_subobject_type::miss_shader:             return "miss_shader";
      case reshade::api::pipeline_subobject_type::intersection_shader:     return "intersection_shader";
      case reshade::api::pipeline_subobject_type::callable_shader:         return "callable_shader";
      case reshade::api::pipeline_subobject_type::libraries:               return "libraries";
      case reshade::api::pipeline_subobject_type::shader_groups:           return "shader_groups";
      case reshade::api::pipeline_subobject_type::max_payload_size:        return "max_payload_size";
      case reshade::api::pipeline_subobject_type::max_attribute_size:      return "max_attribute_size";
      case reshade::api::pipeline_subobject_type::max_recursion_depth:     return "max_recursion_depth";
      case reshade::api::pipeline_subobject_type::flags:                   return "flags";
      default:
      case reshade::api::pipeline_subobject_type::unknown:                 return "unknown";
    }
  }

  inline auto to_string(reshade::api::indirect_command value) {
    switch (value) {
      case reshade::api::indirect_command::draw:          return "draw";
      case reshade::api::indirect_command::draw_indexed:  return "draw_indexed";
      case reshade::api::indirect_command::dispatch:      return "dispatch";
      case reshade::api::indirect_command::dispatch_mesh: return "dispatch_mesh";
      case reshade::api::indirect_command::dispatch_rays: return "dispatch_rays";
      default:
      case reshade::api::indirect_command::unknown:       return "unknown";
    }
  }

  inline auto to_string(reshade::api::resource_type value) {
    switch (value) {
      case reshade::api::resource_type::buffer:     return "buffer";
      case reshade::api::resource_type::texture_1d: return "texture_1d";
      case reshade::api::resource_type::texture_2d: return "texture_2d";
      case reshade::api::resource_type::texture_3d: return "texture_3d";
      case reshade::api::resource_type::surface:    return "surface";
      default:
      case reshade::api::resource_type::unknown:    return "unknown";
    }
  }

  inline auto to_string(DXGI_FORMAT value) {
    switch (value) {
      case DXGI_FORMAT_R32G32B32A32_TYPELESS:                   return "DXGI_FORMAT_R32G32B32A32_TYPELESS";
      case DXGI_FORMAT_R32G32B32A32_FLOAT:                      return "DXGI_FORMAT_R32G32B32A32_FLOAT";
      case DXGI_FORMAT_R32G32B32A32_UINT:                       return "DXGI_FORMAT_R32G32B32A32_UINT";
      case DXGI_FORMAT_R32G32B32A32_SINT:                       return "DXGI_FORMAT_R32G32B32A32_SINT";
      case DXGI_FORMAT_R32G32B32_TYPELESS:                      return "DXGI_FORMAT_R32G32B32_TYPELESS";
      case DXGI_FORMAT_R32G32B32_FLOAT:                         return "DXGI_FORMAT_R32G32B32_FLOAT";
      case DXGI_FORMAT_R32G32B32_UINT:                          return "DXGI_FORMAT_R32G32B32_UINT";
      case DXGI_FORMAT_R32G32B32_SINT:                          return "DXGI_FORMAT_R32G32B32_SINT";
      case DXGI_FORMAT_R16G16B16A16_TYPELESS:                   return "DXGI_FORMAT_R16G16B16A16_TYPELESS";
      case DXGI_FORMAT_R16G16B16A16_FLOAT:                      return "DXGI_FORMAT_R16G16B16A16_FLOAT";
      case DXGI_FORMAT_R16G16B16A16_UNORM:                      return "DXGI_FORMAT_R16G16B16A16_UNORM";
      case DXGI_FORMAT_R16G16B16A16_UINT:                       return "DXGI_FORMAT_R16G16B16A16_UINT";
      case DXGI_FORMAT_R16G16B16A16_SNORM:                      return "DXGI_FORMAT_R16G16B16A16_SNORM";
      case DXGI_FORMAT_R16G16B16A16_SINT:                       return "DXGI_FORMAT_R16G16B16A16_SINT";
      case DXGI_FORMAT_R32G32_TYPELESS:                         return "DXGI_FORMAT_R32G32_TYPELESS";
      case DXGI_FORMAT_R32G32_FLOAT:                            return "DXGI_FORMAT_R32G32_FLOAT";
      case DXGI_FORMAT_R32G32_UINT:                             return "DXGI_FORMAT_R32G32_UINT";
      case DXGI_FORMAT_R32G32_SINT:                             return "DXGI_FORMAT_R32G32_SINT";
      case DXGI_FORMAT_R32G8X24_TYPELESS:                       return "DXGI_FORMAT_R32G8X24_TYPELESS";
      case DXGI_FORMAT_D32_FLOAT_S8X24_UINT:                    return "DXGI_FORMAT_D32_FLOAT_S8X24_UINT";
      case DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS:                return "DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS";
      case DXGI_FORMAT_X32_TYPELESS_G8X24_UINT:                 return "DXGI_FORMAT_X32_TYPELESS_G8X24_UINT";
      case DXGI_FORMAT_R10G10B10A2_TYPELESS:                    return "DXGI_FORMAT_R10G10B10A2_TYPELESS";
      case DXGI_FORMAT_R10G10B10A2_UNORM:                       return "DXGI_FORMAT_R10G10B10A2_UNORM";
      case DXGI_FORMAT_R10G10B10A2_UINT:                        return "DXGI_FORMAT_R10G10B10A2_UINT";
      case DXGI_FORMAT_R11G11B10_FLOAT:                         return "DXGI_FORMAT_R11G11B10_FLOAT";
      case DXGI_FORMAT_R8G8B8A8_TYPELESS:                       return "DXGI_FORMAT_R8G8B8A8_TYPELESS";
      case DXGI_FORMAT_R8G8B8A8_UNORM:                          return "DXGI_FORMAT_R8G8B8A8_UNORM";
      case DXGI_FORMAT_R8G8B8A8_UNORM_SRGB:                     return "DXGI_FORMAT_R8G8B8A8_UNORM_SRGB";
      case DXGI_FORMAT_R8G8B8A8_UINT:                           return "DXGI_FORMAT_R8G8B8A8_UINT";
      case DXGI_FORMAT_R8G8B8A8_SNORM:                          return "DXGI_FORMAT_R8G8B8A8_SNORM";
      case DXGI_FORMAT_R8G8B8A8_SINT:                           return "DXGI_FORMAT_R8G8B8A8_SINT";
      case DXGI_FORMAT_R16G16_TYPELESS:                         return "DXGI_FORMAT_R16G16_TYPELESS";
      case DXGI_FORMAT_R16G16_FLOAT:                            return "DXGI_FORMAT_R16G16_FLOAT";
      case DXGI_FORMAT_R16G16_UNORM:                            return "DXGI_FORMAT_R16G16_UNORM";
      case DXGI_FORMAT_R16G16_UINT:                             return "DXGI_FORMAT_R16G16_UINT";
      case DXGI_FORMAT_R16G16_SNORM:                            return "DXGI_FORMAT_R16G16_SNORM";
      case DXGI_FORMAT_R16G16_SINT:                             return "DXGI_FORMAT_R16G16_SINT";
      case DXGI_FORMAT_R32_TYPELESS:                            return "DXGI_FORMAT_R32_TYPELESS";
      case DXGI_FORMAT_D32_FLOAT:                               return "DXGI_FORMAT_D32_FLOAT";
      case DXGI_FORMAT_R32_FLOAT:                               return "DXGI_FORMAT_R32_FLOAT";
      case DXGI_FORMAT_R32_UINT:                                return "DXGI_FORMAT_R32_UINT";
      case DXGI_FORMAT_R32_SINT:                                return "DXGI_FORMAT_R32_SINT";
      case DXGI_FORMAT_R24G8_TYPELESS:                          return "DXGI_FORMAT_R24G8_TYPELESS";
      case DXGI_FORMAT_D24_UNORM_S8_UINT:                       return "DXGI_FORMAT_D24_UNORM_S8_UINT";
      case DXGI_FORMAT_R24_UNORM_X8_TYPELESS:                   return "DXGI_FORMAT_R24_UNORM_X8_TYPELESS";
      case DXGI_FORMAT_X24_TYPELESS_G8_UINT:                    return "DXGI_FORMAT_X24_TYPELESS_G8_UINT";
      case DXGI_FORMAT_R8G8_TYPELESS:                           return "DXGI_FORMAT_R8G8_TYPELESS";
      case DXGI_FORMAT_R8G8_UNORM:                              return "DXGI_FORMAT_R8G8_UNORM";
      case DXGI_FORMAT_R8G8_UINT:                               return "DXGI_FORMAT_R8G8_UINT";
      case DXGI_FORMAT_R8G8_SNORM:                              return "DXGI_FORMAT_R8G8_SNORM";
      case DXGI_FORMAT_R8G8_SINT:                               return "DXGI_FORMAT_R8G8_SINT";
      case DXGI_FORMAT_R16_TYPELESS:                            return "DXGI_FORMAT_R16_TYPELESS";
      case DXGI_FORMAT_R16_FLOAT:                               return "DXGI_FORMAT_R16_FLOAT";
      case DXGI_FORMAT_D16_UNORM:                               return "DXGI_FORMAT_D16_UNORM";
      case DXGI_FORMAT_R16_UNORM:                               return "DXGI_FORMAT_R16_UNORM";
      case DXGI_FORMAT_R16_UINT:                                return "DXGI_FORMAT_R16_UINT";
      case DXGI_FORMAT_R16_SNORM:                               return "DXGI_FORMAT_R16_SNORM";
      case DXGI_FORMAT_R16_SINT:                                return "DXGI_FORMAT_R16_SINT";
      case DXGI_FORMAT_R8_TYPELESS:                             return "DXGI_FORMAT_R8_TYPELESS";
      case DXGI_FORMAT_R8_UNORM:                                return "DXGI_FORMAT_R8_UNORM";
      case DXGI_FORMAT_R8_UINT:                                 return "DXGI_FORMAT_R8_UINT";
      case DXGI_FORMAT_R8_SNORM:                                return "DXGI_FORMAT_R8_SNORM";
      case DXGI_FORMAT_R8_SINT:                                 return "DXGI_FORMAT_R8_SINT";
      case DXGI_FORMAT_A8_UNORM:                                return "DXGI_FORMAT_A8_UNORM";
      case DXGI_FORMAT_R1_UNORM:                                return "DXGI_FORMAT_R1_UNORM";
      case DXGI_FORMAT_R9G9B9E5_SHAREDEXP:                      return "DXGI_FORMAT_R9G9B9E5_SHAREDEXP";
      case DXGI_FORMAT_R8G8_B8G8_UNORM:                         return "DXGI_FORMAT_R8G8_B8G8_UNORM";
      case DXGI_FORMAT_G8R8_G8B8_UNORM:                         return "DXGI_FORMAT_G8R8_G8B8_UNORM";
      case DXGI_FORMAT_BC1_TYPELESS:                            return "DXGI_FORMAT_BC1_TYPELESS";
      case DXGI_FORMAT_BC1_UNORM:                               return "DXGI_FORMAT_BC1_UNORM";
      case DXGI_FORMAT_BC1_UNORM_SRGB:                          return "DXGI_FORMAT_BC1_UNORM_SRGB";
      case DXGI_FORMAT_BC2_TYPELESS:                            return "DXGI_FORMAT_BC2_TYPELESS";
      case DXGI_FORMAT_BC2_UNORM:                               return "DXGI_FORMAT_BC2_UNORM";
      case DXGI_FORMAT_BC2_UNORM_SRGB:                          return "DXGI_FORMAT_BC2_UNORM_SRGB";
      case DXGI_FORMAT_BC3_TYPELESS:                            return "DXGI_FORMAT_BC3_TYPELESS";
      case DXGI_FORMAT_BC3_UNORM:                               return "DXGI_FORMAT_BC3_UNORM";
      case DXGI_FORMAT_BC3_UNORM_SRGB:                          return "DXGI_FORMAT_BC3_UNORM_SRGB";
      case DXGI_FORMAT_BC4_TYPELESS:                            return "DXGI_FORMAT_BC4_TYPELESS";
      case DXGI_FORMAT_BC4_UNORM:                               return "DXGI_FORMAT_BC4_UNORM";
      case DXGI_FORMAT_BC4_SNORM:                               return "DXGI_FORMAT_BC4_SNORM";
      case DXGI_FORMAT_BC5_TYPELESS:                            return "DXGI_FORMAT_BC5_TYPELESS";
      case DXGI_FORMAT_BC5_UNORM:                               return "DXGI_FORMAT_BC5_UNORM";
      case DXGI_FORMAT_BC5_SNORM:                               return "DXGI_FORMAT_BC5_SNORM";
      case DXGI_FORMAT_B5G6R5_UNORM:                            return "DXGI_FORMAT_B5G6R5_UNORM";
      case DXGI_FORMAT_B5G5R5A1_UNORM:                          return "DXGI_FORMAT_B5G5R5A1_UNORM";
      case DXGI_FORMAT_B8G8R8A8_UNORM:                          return "DXGI_FORMAT_B8G8R8A8_UNORM";
      case DXGI_FORMAT_B8G8R8X8_UNORM:                          return "DXGI_FORMAT_B8G8R8X8_UNORM";
      case DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM:              return "DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM";
      case DXGI_FORMAT_B8G8R8A8_TYPELESS:                       return "DXGI_FORMAT_B8G8R8A8_TYPELESS";
      case DXGI_FORMAT_B8G8R8A8_UNORM_SRGB:                     return "DXGI_FORMAT_B8G8R8A8_UNORM_SRGB";
      case DXGI_FORMAT_B8G8R8X8_TYPELESS:                       return "DXGI_FORMAT_B8G8R8X8_TYPELESS";
      case DXGI_FORMAT_B8G8R8X8_UNORM_SRGB:                     return "DXGI_FORMAT_B8G8R8X8_UNORM_SRGB";
      case DXGI_FORMAT_BC6H_TYPELESS:                           return "DXGI_FORMAT_BC6H_TYPELESS";
      case DXGI_FORMAT_BC6H_UF16:                               return "DXGI_FORMAT_BC6H_UF16";
      case DXGI_FORMAT_BC6H_SF16:                               return "DXGI_FORMAT_BC6H_SF16";
      case DXGI_FORMAT_BC7_TYPELESS:                            return "DXGI_FORMAT_BC7_TYPELESS";
      case DXGI_FORMAT_BC7_UNORM:                               return "DXGI_FORMAT_BC7_UNORM";
      case DXGI_FORMAT_BC7_UNORM_SRGB:                          return "DXGI_FORMAT_BC7_UNORM_SRGB";
      case DXGI_FORMAT_AYUV:                                    return "DXGI_FORMAT_AYUV";
      case DXGI_FORMAT_Y410:                                    return "DXGI_FORMAT_Y410";
      case DXGI_FORMAT_Y416:                                    return "DXGI_FORMAT_Y416";
      case DXGI_FORMAT_NV12:                                    return "DXGI_FORMAT_NV12";
      case DXGI_FORMAT_P010:                                    return "DXGI_FORMAT_P010";
      case DXGI_FORMAT_P016:                                    return "DXGI_FORMAT_P016";
      case DXGI_FORMAT_420_OPAQUE:                              return "DXGI_FORMAT_420_OPAQUE";
      case DXGI_FORMAT_YUY2:                                    return "DXGI_FORMAT_YUY2";
      case DXGI_FORMAT_Y210:                                    return "DXGI_FORMAT_Y210";
      case DXGI_FORMAT_Y216:                                    return "DXGI_FORMAT_Y216";
      case DXGI_FORMAT_NV11:                                    return "DXGI_FORMAT_NV11";
      case DXGI_FORMAT_AI44:                                    return "DXGI_FORMAT_AI44";
      case DXGI_FORMAT_IA44:                                    return "DXGI_FORMAT_IA44";
      case DXGI_FORMAT_P8:                                      return "DXGI_FORMAT_P8";
      case DXGI_FORMAT_A8P8:                                    return "DXGI_FORMAT_A8P8";
      case DXGI_FORMAT_B4G4R4A4_UNORM:                          return "DXGI_FORMAT_B4G4R4A4_UNORM";
      case DXGI_FORMAT_P208:                                    return "DXGI_FORMAT_P208";
      case DXGI_FORMAT_V208:                                    return "DXGI_FORMAT_V208";
      case DXGI_FORMAT_V408:                                    return "DXGI_FORMAT_V408";
      case DXGI_FORMAT_SAMPLER_FEEDBACK_MIN_MIP_OPAQUE:         return "DXGI_FORMAT_SAMPLER_FEEDBACK_MIN_MIP_OPAQUE";
      case DXGI_FORMAT_SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE: return "DXGI_FORMAT_SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE";
      case DXGI_FORMAT_FORCE_UINT:                              return "DXGI_FORMAT_FORCE_UINT";
      case DXGI_FORMAT_UNKNOWN:
        return "DXGI_FORMAT_UNKNOWN";
      default:
        return "unknown";
    }
  }

}  // namespace
