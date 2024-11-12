/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <include/reshade.hpp>
#include <optional>

#include "./descriptor.hpp"
#include "./format.hpp"
#include "./shader.hpp"

namespace renodx::utils::trace {

static bool trace_scheduled = false;
static bool trace_running = false;
template <class T>

inline std::optional<std::string> GetD3DName(T* obj) {
  if (obj == nullptr) return std::nullopt;

  char c_name[128] = {};
  UINT size = sizeof(c_name);
  if (obj->GetPrivateData(WKPDID_D3DDebugObjectName, &size, c_name) == S_OK) {
    if (size > 0) return std::string{c_name, c_name + size};
  }
  return std::nullopt;
}

template <class T>
inline std::optional<std::string> GetD3DNameW(T* obj) {
  if (obj == nullptr) return std::nullopt;

  LPCWSTR w_name[128] = {};
  UINT size = sizeof(w_name);
  if (obj->GetPrivateData(WKPDID_D3DDebugObjectNameW, &size, w_name) == S_OK) {
    if (size > 0) {
      auto wstring = std::wstring(reinterpret_cast<wchar_t*>(w_name), reinterpret_cast<wchar_t*>(w_name) + size);
      char c_name[128] = {};
      size_t out_size;
      // wide-character-string-to-multibyte-string
      auto ret = wcstombs_s(&out_size, c_name, size, wstring.data(), wstring.size());
      if (ret == S_OK && out_size > 0) {
        return std::string(c_name, c_name + out_size);
      }
    }
  }
  return GetD3DName(obj);
}

inline std::optional<std::string> GetDebugName(reshade::api::device_api device_api, reshade::api::resource_view resource_view) {
  if (device_api == reshade::api::device_api::d3d11) {
    auto* native_resource = reinterpret_cast<ID3D11DeviceChild*>(resource_view.handle);
    return renodx::utils::trace::GetD3DName(native_resource);
  }
  return std::nullopt;
}
inline std::optional<std::string> GetDebugName(reshade::api::device_api device_api, uint64_t handle) {
  if (device_api == reshade::api::device_api::d3d11) {
    auto* native_resource = reinterpret_cast<ID3D11DeviceChild*>(handle);
    return renodx::utils::trace::GetD3DName(native_resource);
  }
  if (device_api == reshade::api::device_api::d3d12) {
    auto* native_resource = reinterpret_cast<ID3D12DeviceChild*>(handle);
    return renodx::utils::trace::GetD3DNameW(native_resource);
  }
  return std::nullopt;
}

template <typename T>
inline std::optional<std::string> GetDebugName(reshade::api::device_api device_api, T object) {
  return GetDebugName(device_api, object.handle);
}

namespace internal {
struct __declspec(uuid("3b70b2b2-52dc-4637-bd45-c1171c4c322e")) DeviceData {
  // <resource.handle, resource_view.handle>
  std::unordered_map<uint64_t, uint64_t> resource_views;
  // <resource.handle, vector<resource_view.handle>>
  std::unordered_map<uint64_t, std::vector<uint64_t>> resource_views_by_resource;
  std::unordered_map<uint64_t, std::string> resource_names;
  std::unordered_set<uint64_t> resources;
  std::shared_mutex mutex;
  reshade::api::device_api device_api;
};

const bool FORCE_ALL = false;
const bool TRACE_NAMES = false;

static uint32_t present_count = 0;
const uint32_t MAX_PRESENT_COUNT = 60;

static bool attached = false;

inline uint64_t GetResourceByViewHandle(DeviceData& data, uint64_t handle) {
  if (
      auto pair = data.resource_views.find(handle);
      pair != data.resource_views.end()) return pair->second;

  return 0;
}

inline std::string GetResourceNameByViewHandle(DeviceData& data, uint64_t handle) {
  if (!TRACE_NAMES) return "?";
  auto resource_handle = GetResourceByViewHandle(data, handle);
  if (resource_handle == 0) return "?";
  if (!data.resources.contains(resource_handle)) return "?";

  if (
      auto pair = data.resource_names.find(resource_handle);
      pair != data.resource_names.end()) return pair->second;

  std::string name;
  if (data.device_api == reshade::api::device_api::d3d11) {
    auto* native_resource = reinterpret_cast<ID3D11DeviceChild*>(resource_handle);
    auto result = GetD3DName(native_resource);
    if (result.has_value()) {
      name.assign(result.value());
    }
  } else if (data.device_api == reshade::api::device_api::d3d12) {
    auto* native_resource = reinterpret_cast<ID3D12Resource*>(resource_handle);
    auto result = GetD3DNameW(native_resource);
    if (result.has_value()) {
      name.assign(result.value());
    }
  } else {
    name = "?";
  }
  if (!name.empty()) {
    data.resource_names[resource_handle] = name;
  }
  return name;
}

static void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "init_device(";
  s << reinterpret_cast<void*>(device);
  s << ", api: " << device->get_api();
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  auto& data = device->create_private_data<DeviceData>();
  data.device_api = device->get_api();
}

static void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "destroy_device(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  const size_t back_buffer_count = swapchain->get_back_buffer_count();

  for (uint32_t index = 0; index < back_buffer_count; index++) {
    auto buffer = swapchain->get_back_buffer(index);

    std::stringstream s;
    s << "init_swapchain(";
    s << "buffer:" << reinterpret_cast<void*>(buffer.handle);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  std::stringstream s;
  s << "init_swapchain";
  s << "(colorspace: " << swapchain->get_color_space();
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static bool OnCreatePipelineLayout(
    reshade::api::device* device,
    uint32_t& param_count,
    reshade::api::pipeline_layout_param*& params) {
  // noop
  return false;
}

static void LogLayout(
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    const reshade::api::pipeline_layout layout) {
  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    auto param = params[param_index];
    switch (param.type) {
      case reshade::api::pipeline_layout_param_type::descriptor_table:
        for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
          auto range = param.descriptor_table.ranges[range_index];
          std::stringstream s;
          s << "logPipelineLayout(";
          s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
          s << " | TBL";
          s << " | " << reinterpret_cast<void*>(&param.descriptor_table.ranges);
          s << " | ";
          switch (range.type) {
            case reshade::api::descriptor_type::sampler:
              s << "SMP";
              break;
            case reshade::api::descriptor_type::sampler_with_resource_view:
              s << "SMPRV";
              break;
            case reshade::api::descriptor_type::texture_shader_resource_view:
              s << "TSRV";
              break;
            case reshade::api::descriptor_type::texture_unordered_access_view:
              s << "TUAV";
              break;
            case reshade::api::descriptor_type::constant_buffer:
              s << "CBV";
              break;
            case reshade::api::descriptor_type::shader_storage_buffer:
              s << "SSB";
              break;
            case reshade::api::descriptor_type::acceleration_structure:
              s << "ACC";
              break;
            default:
              s << "??? (0x" << std::hex << static_cast<uint32_t>(range.type) << std::dec << ")";
          }

          s << ", array_size: " << range.array_size;
          s << ", binding: " << range.binding;
          s << ", count: " << range.count;
          s << ", register: " << range.dx_register_index;
          s << ", space: " << range.dx_register_space;
          s << ", visibility: " << range.visibility;
          s << ")";
          s << " [" << range_index << "/" << param.descriptor_table.count << "]";
          reshade::log::message(reshade::log::level::info, s.str().c_str());
        }
        break;
      case reshade::api::pipeline_layout_param_type::push_constants: {
        std::stringstream s;
        s << "logPipelineLayout(";
        s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
        s << " | PC";
        s << ", binding: " << param.push_constants.binding;
        s << ", count " << param.push_constants.count;
        s << ", register: " << param.push_constants.dx_register_index;
        s << ", space: " << param.push_constants.dx_register_space;
        s << ", visibility " << param.push_constants.visibility;
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
        break;
      }
      case reshade::api::pipeline_layout_param_type::push_descriptors: {
        std::stringstream s;
        s << "logPipelineLayout(";
        s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
        s << " | PD |";
        s << " array_size: " << param.push_descriptors.array_size;
        s << ", binding: " << param.push_descriptors.binding;
        s << ", count " << param.push_descriptors.count;
        s << ", register: " << param.push_descriptors.dx_register_index;
        s << ", space: " << param.push_descriptors.dx_register_space;
        s << ", type: " << param.push_descriptors.type;
        s << ", visibility " << param.push_descriptors.visibility;
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
        break;
      }
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges: {
        std::stringstream s;
        s << "logPipelineLayout(";
        s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
        s << " | PDR?? | ";
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
        break;
      }
#if RESHADE_API_VERSION >= 13
      case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
        for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
          auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
          std::stringstream s;
          s << "logPipelineLayout(";
          s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
          s << " | TBLSS";
          s << " | " << reinterpret_cast<void*>(&param.descriptor_table.ranges);
          s << " | ";
          if (range.static_samplers == nullptr) {
            s << " null ";
          } else {
            s << ", filter: " << static_cast<uint32_t>(range.static_samplers->filter);
            s << ", address_u: " << static_cast<uint32_t>(range.static_samplers->address_u);
            s << ", address_v: " << static_cast<uint32_t>(range.static_samplers->address_v);
            s << ", address_w: " << static_cast<uint32_t>(range.static_samplers->address_w);
            s << ", mip_lod_bias: " << static_cast<uint32_t>(range.static_samplers->mip_lod_bias);
            s << ", max_anisotropy: " << static_cast<uint32_t>(range.static_samplers->max_anisotropy);
            s << ", compare_op: " << static_cast<uint32_t>(range.static_samplers->compare_op);
            s << ", border_color: [" << range.static_samplers->border_color[0] << ", " << range.static_samplers->border_color[1] << ", " << range.static_samplers->border_color[2] << ", " << range.static_samplers->border_color[3] << "]";
            s << ", min_lod: " << range.static_samplers->min_lod;
            s << ", max_lod: " << range.static_samplers->max_lod;
          }
          reshade::log::message(reshade::log::level::info, s.str().c_str());
        }
        break;
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
        for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
          auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
          std::stringstream s;
          s << "logPipelineLayout(";
          s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
          s << " | PDSS";
          s << " | " << reinterpret_cast<void*>(&range);
          s << " | ";
          if (range.static_samplers == nullptr) {
            s << "not";
          } else {
            s << "filter: " << static_cast<uint32_t>(range.static_samplers->filter);
            s << ", address_u: " << static_cast<uint32_t>(range.static_samplers->address_u);
            s << ", address_v: " << static_cast<uint32_t>(range.static_samplers->address_v);
            s << ", address_w: " << static_cast<uint32_t>(range.static_samplers->address_w);
            s << ", mip_lod_bias: " << static_cast<uint32_t>(range.static_samplers->mip_lod_bias);
            s << ", max_anisotropy: " << static_cast<uint32_t>(range.static_samplers->max_anisotropy);
            s << ", compare_op: " << static_cast<uint32_t>(range.static_samplers->compare_op);
            s << ", border_color: [" << range.static_samplers->border_color[0] << ", " << range.static_samplers->border_color[1] << ", " << range.static_samplers->border_color[2] << ", " << range.static_samplers->border_color[3] << "]";
            s << ", min_lod: " << range.static_samplers->min_lod;
            s << ", max_lod: " << range.static_samplers->max_lod;
          }
          s << ")";
          s << " [" << range_index << "/" << param.descriptor_table.count << "]";
          reshade::log::message(reshade::log::level::info, s.str().c_str());
        }
        break;
#endif
      default: {
        std::stringstream s;
        s << "logPipelineLayout(";
        s << reinterpret_cast<void*>(layout.handle) << "[" << param_index << "]";
        s << " | ??? (0x" << std::hex << static_cast<uint32_t>(param.type) << std::dec << ")";
        s << " | " << param.type;
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
    }
  }
}

// AfterCreateRootSignature
static void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  LogLayout(param_count, params, layout);

  const bool found_visiblity = false;
  uint32_t cbv_index = 0;
  uint32_t pc_count = 0;

  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    auto param = params[param_index];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
        auto range = param.descriptor_table.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      pc_count++;
      if (cbv_index < param.push_constants.dx_register_index + param.push_constants.count) {
        cbv_index = param.push_constants.dx_register_index + param.push_constants.count;
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        if (cbv_index < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
          cbv_index = param.push_descriptors.dx_register_index + param.push_descriptors.count;
        }
      }
    }
  }

  const uint32_t max_count = 64u - (param_count + 1u) + 1u;

  std::stringstream s;
  s << "on_init_pipeline_layout++(";
  s << reinterpret_cast<void*>(layout.handle);
  s << " , max injections: " << (max_count);
  s << " )";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

// After CreatePipelineState
void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  if (subobject_count == 0) {
    std::stringstream s;
    s << "on_init_pipeline(";
    s << reinterpret_cast<void*>(pipeline.handle);
    s << ", layout:" << reinterpret_cast<void*>(layout.handle);
    s << ", subobjects: " << (subobject_count);
    s << " )";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return;
  }

  for (uint32_t i = 0; i < subobject_count; ++i) {
    const auto& subobject = subobjects[i];
    for (uint32_t j = 0; j < subobject.count; ++j) {
      std::stringstream s;
      s << "on_init_pipeline(";
      s << reinterpret_cast<void*>(pipeline.handle);
      s << "[" << i << "][" << j << "]";
      s << ", layout:" << reinterpret_cast<void*>(layout.handle);
      s << ", type: " << subobject.type;
      switch (subobject.type) {
        case reshade::api::pipeline_subobject_type::hull_shader:
        case reshade::api::pipeline_subobject_type::domain_shader:
        case reshade::api::pipeline_subobject_type::geometry_shader:
          // reshade::api::shader_desc &desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data[j]);
          break;
        case reshade::api::pipeline_subobject_type::blend_state:
          break;  // Disabled for now
          {
            auto& desc = static_cast<reshade::api::blend_desc*>(subobject.data)[j];
            s << ", alpha_to_coverage_enable: " << desc.alpha_to_coverage_enable;
            s << ", source_color_blend_factor: " << desc.source_color_blend_factor[0];
            s << ", dest_color_blend_factor: " << desc.dest_color_blend_factor[0];
            s << ", color_blend_op: " << desc.color_blend_op[0];
            s << ", source_alpha_blend_factor: " << desc.source_alpha_blend_factor[0];
            s << ", dest_alpha_blend_factor: " << desc.dest_alpha_blend_factor[0];
            s << ", alpha_blend_op: " << desc.alpha_blend_op[0];
            s << ", render_target_write_mask: " << std::hex << desc.render_target_write_mask[0] << std::dec;
          }
          break;
        case reshade::api::pipeline_subobject_type::vertex_shader:
        case reshade::api::pipeline_subobject_type::compute_shader:
        case reshade::api::pipeline_subobject_type::pixel_shader:   {
          auto& desc = (static_cast<reshade::api::shader_desc*>(subobject.data))[j];
          s << ", shader: ";
          if (desc.code_size == 0) {
            s << "(empty)";
          } else {
            auto shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);
            s << PRINT_CRC32(shader_hash);
          }
          break;
        }
        default:
          break;
      }

      s << " )";

      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }
}

static void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  std::stringstream s;
  s << "on_destroy_pipeline(";
  s << reinterpret_cast<void*>(pipeline.handle);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnPushConstants(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    uint32_t first,
    uint32_t count,
    const void* values) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "push_constants(" << reinterpret_cast<void*>(layout.handle);
  s << "[" << layout_param << "]";
  s << ", stage: " << std::hex << static_cast<uint32_t>(stages) << std::dec << " (" << stages << ")";
  s << ", count: " << count;
  s << "{ 0x";
  for (uint32_t i = 0; i < count; i++) {
    s << std::hex << static_cast<const uint32_t*>(values)[i] << std::dec << ", ";
  }
  s << " })";

  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

// AfterSetPipelineState
static void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stages,
    reshade::api::pipeline pipeline) {
  if (!trace_running) return;

  std::stringstream s;
  s << "bind_pipeline(";
  s << (void*)pipeline.handle;
  auto details = renodx::utils::shader::GetPipelineShaderDetails(cmd_list->get_device(), pipeline);
  if (details.has_value()) {
    s << ", layout" << reinterpret_cast<void*>(details->layout.handle);
    for (auto& [type, shader_hash] : details->shader_hashes_by_type) {
      s << ", " << type << ": " << PRINT_CRC32(shader_hash);
    }
  }
  s << ", stages: " << stages << " (" << std::hex << static_cast<uint32_t>(stages) << std::dec << ")";
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  if (trace_running) {
    std::stringstream s;
    s << "on_draw";
    s << "(" << vertex_count;
    s << ", " << instance_count;
    s << ", " << first_vertex;
    s << ", " << first_instance;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
  return false;
}

static bool OnDispatch(reshade::api::command_list* cmd_list, uint32_t group_count_x, uint32_t group_count_y, uint32_t group_count_z) {
  if (trace_running) {
    std::stringstream s;
    s << "on_dispatch";
    s << "(" << group_count_x;
    s << ", " << group_count_y;
    s << ", " << group_count_z;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::dispatch;
    // resetInstructionState();
  }
  return false;
}

static bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  if (trace_running) {
    std::stringstream s;
    s << "on_draw_indexed";
    s << "(" << index_count;
    s << ", " << instance_count;
    s << ", " << first_index;
    s << ", " << vertex_offset;
    s << ", " << first_instance;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::draw_indexed;
    // resetInstructionState();
  }
  return false;
}

static bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride) {
  if (trace_running) {
    std::stringstream s;
    s << "on_draw_or_dispatch_indirect(" << type;
    s << ", " << reinterpret_cast<void*>(buffer.handle);
    s << ", " << offset;
    s << ", " << draw_count;
    s << ", " << stride;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.action = reshade::addon_event::draw_or_dispatch_indirect;
    // resetInstructionState();
  }
  return false;
}

static bool OnCopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_texture_region";
  s << "(" << reinterpret_cast<void*>(source.handle);
  s << ", " << (source_subresource);
  s << ", " << reinterpret_cast<void*>(dest.handle);
  s << ", " << static_cast<uint32_t>(filter);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  return false;
}

static bool OnCopyTextureToBuffer(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint64_t dest_offset,
    uint32_t row_length,
    uint32_t slice_height) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_texture_region(" << reinterpret_cast<void*>(source.handle);
  s << "[" << source_subresource << "]";
  if (source_box != nullptr) {
    s << "(" << source_box->top << ", " << source_box->left << ", " << source_box->front << ")";
  }
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << "[" << dest_offset << "]";
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  return false;
}

static bool OnCopyBufferToTexture(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint64_t source_offset,
    uint32_t row_length,
    uint32_t slice_height,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_texture_region";
  s << "(" << reinterpret_cast<void*>(source.handle);
  s << "[" << source_offset << "]";
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << "[" << dest_subresource << "]";
  if (dest_box != nullptr) {
    s << "(" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")";
  }
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  return false;
}

static bool OnResolveTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    int32_t dest_x,
    int32_t dest_y,
    int32_t dest_z,
    reshade::api::format format) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_resolve_texture_region";
  s << "(" << reinterpret_cast<void*>(source.handle);
  s << ": " << (source_subresource);
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << ": " << (dest_subresource);
  s << ", (" << dest_x << ", " << dest_y << ", " << dest_z << ") ";
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  return false;
}

static bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_copy_resource";
  s << "(" << reinterpret_cast<void*>(source.handle);
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  return false;
}

static void OnBarrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  for (uint32_t i = 0; i < count; i++) {
    std::stringstream s;
    s << "on_barrier(" << reinterpret_cast<void*>(resources[i].handle);
    s << ", " << std::hex << static_cast<uint32_t>(old_states[i]) << std::dec << " (" << old_states[i] << ")";
    s << " => " << std::hex << static_cast<uint32_t>(new_states[i]) << std::dec << " (" << new_states[i] << ")";
    s << ") [" << i << "]";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
}

static void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (!trace_running) return;

  if (count != 0) {
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.renderTargets.clear();
    auto* device = cmd_list->get_device();
    auto& data = device->get_private_data<DeviceData>();
    const std::shared_lock lock(data.mutex);
    for (uint32_t i = 0; i < count; i++) {
      auto rtv = rtvs[i];
      // if (rtv.handle) {
      //   state.renderTargets.push_back(rtv.handle);
      // }
      std::stringstream s;
      s << "on_bind_render_targets(";
      s << reinterpret_cast<void*>(rtv.handle);
      s << ", res: " << reinterpret_cast<void*>(GetResourceByViewHandle(data, rtv.handle));
      s << ", name: " << GetResourceNameByViewHandle(data, rtv.handle);
      s << ")";
      s << "[" << i << "]";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }
  if (dsv.handle != 0) {
    std::stringstream s;
    s << "on_bind_depth_stencil(";
    s << reinterpret_cast<void*>(dsv.handle);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
}

static void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resources.emplace(resource.handle);

  if (!FORCE_ALL && !trace_running && present_count >= MAX_PRESENT_COUNT) return;

  bool warn = false;
  std::stringstream s;
  s << "init_resource(" << reinterpret_cast<void*>(resource.handle);
  s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", state: " << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
  s << ", type: " << desc.type;
  s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;

  switch (desc.type) {
    case reshade::api::resource_type::buffer:
      s << ", size: " << desc.buffer.size;
      s << ", stride: " << desc.buffer.stride;
      if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
      break;
    case reshade::api::resource_type::texture_1d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::surface:
      s << ", width: " << desc.texture.width;
      s << ", height: " << desc.texture.height;
      s << ", levels: " << desc.texture.levels;
      s << ", format: " << desc.texture.format;
      if (desc.texture.format == reshade::api::format::unknown) {
        warn = true;
      }
      break;
    default:
    case reshade::api::resource_type::unknown:
      break;
  }

  s << ")";
  reshade::log::message(
      warn
          ? reshade::log::level::warning
          : reshade::log::level::info,
      s.str().c_str());
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resources.erase(resource.handle);
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;

  std::stringstream s;
  s << "on_destroy_resource(";
  s << reinterpret_cast<void*>(resource.handle);
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
}

static void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  if (data.resource_views.contains(view.handle)) {
    if (trace_running || present_count < MAX_PRESENT_COUNT) {
      std::stringstream s;
      s << "init_resource_view(reused view: ";
      s << reinterpret_cast<void*>(view.handle);
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
    if (resource.handle == 0) {
      data.resource_views.erase(view.handle);
      return;
    }
  }
  if (resource.handle != 0) {
    data.resource_views.emplace(view.handle, resource.handle);
  }

  if (!FORCE_ALL && !trace_running && present_count >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "init_resource_view(" << reinterpret_cast<void*>(view.handle);
  s << ", view type: " << desc.type << " (0x" << std::hex << static_cast<uint32_t>(desc.type) << std::dec << ")";
  s << ", view format: " << desc.format << " (0x" << std::hex << static_cast<uint32_t>(desc.format) << std::dec << ")";
  s << ", resource: " << reinterpret_cast<void*>(resource.handle);
  s << ", resource usage: " << usage_type << " 0x" << std::hex << static_cast<uint32_t>(usage_type) << std::dec;
  // if (desc.type == reshade::api::resource_view_type::buffer) return;
  if (resource.handle != 0) {
    const auto resource_desc = device->get_resource_desc(resource);
    s << ", resource type: " << resource_desc.type;

    switch (resource_desc.type) {
      default:
      case reshade::api::resource_type::unknown:
        break;
      case reshade::api::resource_type::buffer:
        // if (!traceRunning) return;
        return;
        s << ", buffer offset: " << desc.buffer.offset;
        s << ", buffer size: " << desc.buffer.size;
        break;
      case reshade::api::resource_type::texture_1d:
      case reshade::api::resource_type::texture_2d:
      case reshade::api::resource_type::surface:
        s << ", texture format: " << resource_desc.texture.format;
        s << ", texture width: " << resource_desc.texture.width;
        s << ", texture height: " << resource_desc.texture.height;
        break;
      case reshade::api::resource_type::texture_3d:
        s << ", texture format: " << resource_desc.texture.format;
        s << ", texture width: " << resource_desc.texture.width;
        s << ", texture height: " << resource_desc.texture.height;
        s << ", texture depth: " << resource_desc.texture.depth_or_layers;
        break;
    }
  }
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  std::stringstream s;
  s << "on_destroy_resource_view(";
  s << reinterpret_cast<void*>(view.handle);
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.resource_views.erase(view.handle);
}

static void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (!trace_running) return;
  auto* device = cmd_list->get_device();
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  for (uint32_t i = 0; i < update.count; i++) {
    std::stringstream s;
    s << "push_descriptors(" << reinterpret_cast<void*>(layout.handle);
    s << "[" << layout_param << "]";
    s << "[" << update.binding + i << "]";
    s << ", type: " << update.type;

    auto log_heap = [=]() {
      std::stringstream s2;
      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(update.table, update.binding + i, 0, &heap, &base_offset);
      s2 << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
      return s2.str();
    };

    switch (update.type) {
      case reshade::api::descriptor_type::sampler: {
        s << log_heap();
        auto item = static_cast<const reshade::api::sampler*>(update.descriptors)[i];
        s << ", sampler: " << reinterpret_cast<void*>(item.handle);
        break;
      }
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        s << log_heap();
        auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i];
        s << ", sampler: " << reinterpret_cast<void*>(item.sampler.handle);
        s << ", rsv: " << reinterpret_cast<void*>(item.view.handle);
        s << ", res: " << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.view.handle));
        // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
        break;
      }
      case reshade::api::descriptor_type::buffer_shader_resource_view:

      case reshade::api::descriptor_type::shader_resource_view: {
        s << log_heap();
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", shaderrsv: " << reinterpret_cast<void*>(item.handle);
        s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
        // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        break;
      }
      case reshade::api::descriptor_type::buffer_unordered_access_view:

      case reshade::api::descriptor_type::unordered_access_view: {
        s << log_heap();
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", uav: " << reinterpret_cast<void*>(item.handle);
        s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
        // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        break;
      }
      case reshade::api::descriptor_type::acceleration_structure: {
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", accl: " << reinterpret_cast<void*>(item.handle);
        break;
      }
      case reshade::api::descriptor_type::constant_buffer: {
        auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
        s << ", buffer: " << reinterpret_cast<void*>(item.buffer.handle);
        s << ", size: " << item.size;
        s << ", offset: " << item.offset;
        break;
      }
      default:
        s << ", type: " << update.type;
        break;
    }

    s << ")";
    s << "[" << update.binding + i << " / " << update.count << "]";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
}

static void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  auto* device = cmd_list->get_device();
  for (uint32_t i = 0; i < count; ++i) {
    std::stringstream s;
    s << "bind_descriptor_table(" << reinterpret_cast<void*>(layout.handle);
    s << "[" << (first + i) << "]";
    s << ", stages: " << stages << "(" << std::hex << static_cast<uint32_t>(stages) << std::dec << ")";
    s << ", table: " << reinterpret_cast<void*>(tables[i].handle);
    uint32_t base_offset = 0;
    reshade::api::descriptor_heap heap = {0};
    device->get_descriptor_heap_offset(tables[i], 0, 0, &heap, &base_offset);
    s << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";

    auto& descriptor_data = device->get_private_data<renodx::utils::descriptor::DeviceData>();
    const std::shared_lock decriptor_lock(descriptor_data.mutex);
    for (uint32_t j = 0; j < 13; ++j) {
      auto origin_primary_key = std::pair<uint64_t, uint32_t>(tables[i].handle, j);
      if (auto pair = descriptor_data.table_descriptor_resource_views.find(origin_primary_key);
          pair != descriptor_data.table_descriptor_resource_views.end()) {
        auto update = pair->second;
        auto view = renodx::utils::descriptor::GetResourceViewFromDescriptorUpdate(update);
        if (view.handle != 0) {
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", rsv[" << j << "]: " << reinterpret_cast<void*>(view.handle);
          s << ", res[" << j << "]: " << reinterpret_cast<void*>(GetResourceByViewHandle(data, view.handle));
        }
      }
    }

    s << ") [" << i << "]";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
}

static bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;

  for (uint32_t i = 0; i < count; i++) {
    const auto& copy = copies[i];

    for (uint32_t j = 0; j < copy.count; j++) {
      std::stringstream s;
      s << "copy_descriptor_tables(";
      s << reinterpret_cast<void*>(copy.source_table.handle);
      s << "[" << copy.source_binding + j << "]";
      s << " => ";
      s << reinterpret_cast<void*>(copy.dest_table.handle);
      s << "[" << copy.dest_binding + j << "]";

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(
          copy.source_table, copy.source_binding + j, copy.source_array_offset, &heap, &base_offset);
      s << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
      device->get_descriptor_heap_offset(
          copy.dest_table, copy.dest_binding + j, copy.dest_array_offset, &heap, &base_offset);
      s << " => " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";

      auto& descriptor_data = device->get_private_data<renodx::utils::descriptor::DeviceData>();
      const std::shared_lock decriptor_lock(descriptor_data.mutex);
      auto origin_primary_key = std::pair<uint64_t, uint32_t>(copy.source_table.handle, copy.source_binding + j);
      if (auto pair = descriptor_data.table_descriptor_resource_views.find(origin_primary_key);
          pair != descriptor_data.table_descriptor_resource_views.end()) {
        auto update = pair->second;
        auto view = renodx::utils::descriptor::GetResourceViewFromDescriptorUpdate(update);
        if (view.handle != 0) {
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", rsv: " << reinterpret_cast<void*>(view.handle);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, view.handle));
        }
      }

      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }

  return false;
}

static bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;

  for (uint32_t i = 0; i < count; i++) {
    const auto& update = updates[i];

    for (uint32_t j = 0; j < update.count; j++) {
      std::stringstream s;
      s << "update_descriptor_tables(";
      s << reinterpret_cast<void*>(update.table.handle);
      s << "[" << update.binding + j << "]";

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(update.table, update.binding + j, 0, &heap, &base_offset);
      s << ", heap: " << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
      switch (update.type) {
        case reshade::api::descriptor_type::sampler: {
          auto item = static_cast<const reshade::api::sampler*>(update.descriptors)[j];
          s << ", sampler: " << reinterpret_cast<void*>(item.handle);
          break;
        }
        case reshade::api::descriptor_type::sampler_with_resource_view: {
          auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
          s << ", sampler: " << reinterpret_cast<void*>(item.sampler.handle);
          s << ", rsv: " << reinterpret_cast<void*>(item.view.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.view.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          break;
        }
        case reshade::api::descriptor_type::buffer_shader_resource_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", b-srv: " << reinterpret_cast<void*>(item.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          break;
        }
        case reshade::api::descriptor_type::buffer_unordered_access_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", b-uav: " << reinterpret_cast<void*>(item.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          break;
        }
        case reshade::api::descriptor_type::shader_resource_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", srv: " << reinterpret_cast<void*>(item.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res:" << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          break;
        }
        case reshade::api::descriptor_type::unordered_access_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", uav: " << reinterpret_cast<void*>(item.handle);
          auto& data = device->get_private_data<DeviceData>();
          const std::shared_lock lock(data.mutex);
          s << ", res: " << reinterpret_cast<void*>(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          break;
        }
        case reshade::api::descriptor_type::constant_buffer: {
          auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[j];
          s << ", buffer: " << reinterpret_cast<void*>(item.buffer.handle);
          s << ", size: " << item.size;
          s << ", offset: " << item.offset;
          break;
        }
        case reshade::api::descriptor_type::shader_storage_buffer: {
          auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[j];
          s << ", buffer: " << reinterpret_cast<void*>(item.buffer.handle);
          s << ", size: " << item.size;
          s << ", offset: " << item.offset;
          break;
        }
        case reshade::api::descriptor_type::acceleration_structure:
          s << ", accl: unknown";
          break;
        default:
          break;
      }
      s << ") [" << i << "]";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }
  return false;
}

static bool OnClearRenderTargetView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_clear_render_target_view(";
  s << reinterpret_cast<void*>(rtv.handle);
  s << ")";

  reshade::log::message(reshade::log::level::info, s.str().c_str());
  return false;
}

static bool OnClearUnorderedAccessViewUint(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const uint32_t values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return false;
  std::stringstream s;
  s << "on_clear_unordered_access_view_uint(";
  s << reinterpret_cast<void*>(uav.handle);
  s << ")";

  reshade::log::message(reshade::log::level::info, s.str().c_str());
  return false;
}

static void OnMapBufferRegion(
    reshade::api::device* device,
    reshade::api::resource resource,
    uint64_t offset,
    uint64_t size,
    reshade::api::map_access access,
    void** data) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "map_buffer_region(";
  s << reinterpret_cast<void*>(resource.handle);
  s << ")";

  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnMapTextureRegion(
    reshade::api::device* device,
    reshade::api::resource resource,
    uint32_t subresource,
    const reshade::api::subresource_box* box,
    reshade::api::map_access access,
    reshade::api::subresource_data* data) {
  if (!trace_running && present_count >= MAX_PRESENT_COUNT) return;
  std::stringstream s;
  s << "map_texture_region(";
  s << reinterpret_cast<void*>(resource.handle);
  s << "[" << subresource << "]";
  s << ")";

  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnBindPipelineStates(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::dynamic_state* states,
    const uint32_t* values) {
  if (!trace_running) return;

  for (uint32_t i = 0; i < count; i++) {
    std::stringstream s;
    s << "bind_pipeline_state";
    s << "(" << states[i];
    s << ", " << values[i];
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
}

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  if (trace_running) {
    reshade::log::message(reshade::log::level::info, "present()");
    reshade::log::message(reshade::log::level::info, "--- End Frame ---");
    trace_running = false;
  } else if (trace_scheduled) {
    trace_scheduled = false;
    trace_running = true;
    reshade::log::message(reshade::log::level::info, "--- Frame ---");
  }
  if (present_count <= MAX_PRESENT_COUNT) {
    present_count++;
  }
}
}  // namespace internal

inline void Use(DWORD fdw_reason) {
  renodx::utils::descriptor::Use(fdw_reason);
  renodx::utils::shader::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);

      reshade::register_event<reshade::addon_event::create_pipeline_layout>(internal::OnCreatePipelineLayout);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(internal::OnInitPipelineLayout);

      reshade::register_event<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(internal::OnDestroyPipeline);

      reshade::register_event<reshade::addon_event::bind_pipeline>(internal::OnBindPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline_states>(internal::OnBindPipelineStates);

      reshade::register_event<reshade::addon_event::init_resource>(internal::OnInitResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
      reshade::register_event<reshade::addon_event::init_resource_view>(internal::OnInitResourceView);
      reshade::register_event<reshade::addon_event::destroy_resource_view>(internal::OnDestroyResourceView);

      reshade::register_event<reshade::addon_event::push_descriptors>(internal::OnPushDescriptors);
      reshade::register_event<reshade::addon_event::bind_descriptor_tables>(internal::OnBindDescriptorTables);
      reshade::register_event<reshade::addon_event::copy_descriptor_tables>(internal::OnCopyDescriptorTables);
      reshade::register_event<reshade::addon_event::update_descriptor_tables>(internal::OnUpdateDescriptorTables);
      reshade::register_event<reshade::addon_event::push_constants>(internal::OnPushConstants);

      reshade::register_event<reshade::addon_event::clear_render_target_view>(internal::OnClearRenderTargetView);
      reshade::register_event<reshade::addon_event::clear_unordered_access_view_uint>(internal::OnClearUnorderedAccessViewUint);

      reshade::register_event<reshade::addon_event::map_buffer_region>(internal::OnMapBufferRegion);
      reshade::register_event<reshade::addon_event::map_texture_region>(internal::OnMapTextureRegion);

      reshade::register_event<reshade::addon_event::draw>(internal::OnDraw);
      reshade::register_event<reshade::addon_event::dispatch>(internal::OnDispatch);
      reshade::register_event<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);

      reshade::register_event<reshade::addon_event::copy_texture_region>(internal::OnCopyTextureRegion);
      reshade::register_event<reshade::addon_event::copy_texture_to_buffer>(internal::OnCopyTextureToBuffer);
      reshade::register_event<reshade::addon_event::copy_buffer_to_texture>(internal::OnCopyBufferToTexture);
      reshade::register_event<reshade::addon_event::resolve_texture_region>(internal::OnResolveTextureRegion);

      reshade::register_event<reshade::addon_event::copy_resource>(internal::OnCopyResource);

      reshade::register_event<reshade::addon_event::barrier>(internal::OnBarrier);

      reshade::register_event<reshade::addon_event::present>(internal::OnPresent);

      break;
    case DLL_PROCESS_DETACH:

      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);

      reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(internal::OnCreatePipelineLayout);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(internal::OnInitPipelineLayout);

      reshade::unregister_event<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(internal::OnDestroyPipeline);

      reshade::unregister_event<reshade::addon_event::bind_pipeline>(internal::OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline_states>(internal::OnBindPipelineStates);

      reshade::unregister_event<reshade::addon_event::init_resource>(internal::OnInitResource);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
      reshade::unregister_event<reshade::addon_event::init_resource_view>(internal::OnInitResourceView);
      reshade::unregister_event<reshade::addon_event::destroy_resource_view>(internal::OnDestroyResourceView);

      reshade::unregister_event<reshade::addon_event::push_descriptors>(internal::OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::bind_descriptor_tables>(internal::OnBindDescriptorTables);
      reshade::unregister_event<reshade::addon_event::copy_descriptor_tables>(internal::OnCopyDescriptorTables);
      reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(internal::OnUpdateDescriptorTables);
      reshade::unregister_event<reshade::addon_event::push_constants>(internal::OnPushConstants);

      reshade::unregister_event<reshade::addon_event::clear_render_target_view>(internal::OnClearRenderTargetView);
      reshade::unregister_event<reshade::addon_event::clear_unordered_access_view_uint>(internal::OnClearUnorderedAccessViewUint);

      reshade::unregister_event<reshade::addon_event::map_buffer_region>(internal::OnMapBufferRegion);
      reshade::unregister_event<reshade::addon_event::map_texture_region>(internal::OnMapTextureRegion);

      reshade::unregister_event<reshade::addon_event::draw>(internal::OnDraw);
      reshade::unregister_event<reshade::addon_event::dispatch>(internal::OnDispatch);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);

      reshade::unregister_event<reshade::addon_event::copy_texture_region>(internal::OnCopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_texture_to_buffer>(internal::OnCopyTextureToBuffer);
      reshade::unregister_event<reshade::addon_event::copy_buffer_to_texture>(internal::OnCopyBufferToTexture);
      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(internal::OnResolveTextureRegion);

      reshade::unregister_event<reshade::addon_event::copy_resource>(internal::OnCopyResource);

      reshade::unregister_event<reshade::addon_event::barrier>(internal::OnBarrier);

      reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);
      break;
  }
}
}  // namespace renodx::utils::trace
