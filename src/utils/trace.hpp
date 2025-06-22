/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#define NOMINMAX

#include <cstdint>
#include <algorithm>
#include <optional>
#include <sstream>

#include <include/reshade.hpp>

#include "./data.hpp"
#include "./descriptor.hpp"
#include "./format.hpp"
#include "./pipeline_layout.hpp"
#include "./resource.hpp"
#include "./shader.hpp"

namespace renodx::utils::trace {

static bool trace_scheduled = false;
static bool trace_running = false;
static std::atomic_bool trace_pipeline_creation = false;
static std::atomic_uint32_t trace_initial_frame_count = 0;

template <class T>
std::optional<std::string> GetD3DName(T* obj) {
  if (obj == nullptr) return std::nullopt;

  byte data[128] = {};
  UINT size = sizeof(data);
  if (obj->GetPrivateData(WKPDID_D3DDebugObjectName, &size, data) == S_OK) {
    if (size > 0) return std::string{data, data + size};
  }
  return std::nullopt;
}

template <class T>
std::optional<std::string> GetD3DNameW(T* obj) {
  if (obj == nullptr) return std::nullopt;

  char data[128] = {};
  UINT size = sizeof(data);
  try {
    if (obj->GetPrivateData(WKPDID_D3DDebugObjectNameW, &size, data) == S_OK) {
      if (size > 0) {
        const std::wstring object_name{reinterpret_cast<wchar_t*>(data), static_cast<::std::size_t>(size - 1)};  // subtract 1 to exclude the null terminator
        size_t output_size = object_name.length() + 1;                                                           // +1 for null terminator
        auto output_string = std::make_unique<char[]>(output_size);
        size_t chars_converted = 0;
        auto ret = wcstombs_s(&chars_converted, output_string.get(), output_size, object_name.c_str(), object_name.length());

        // wide-character-string-to-multibyte-string_safe
        if (ret == S_OK && chars_converted > 0) {
          return std::string(output_string.get());
        }
      }
    }
  } catch (...) {
  }
  return GetD3DName(obj);
}

static std::optional<std::string> GetDebugName(reshade::api::device_api device_api, reshade::api::resource_view resource_view) {
  if (device_api == reshade::api::device_api::d3d11) {
    auto* native_resource = reinterpret_cast<ID3D11DeviceChild*>(resource_view.handle);
    return GetD3DName(native_resource);
  }
  // D3D12 ResourceView are DescriptorHandles, not objects
  return std::nullopt;
}

static std::optional<std::string> GetDebugName(reshade::api::device_api device_api, uint64_t handle) {
  if (device_api == reshade::api::device_api::d3d11) {
    auto* native_resource = reinterpret_cast<ID3D11DeviceChild*>(handle);
    return GetD3DName(native_resource);
  }
  if (device_api == reshade::api::device_api::d3d12) {
    auto* native_resource = reinterpret_cast<ID3D12DeviceChild*>(handle);
    return GetD3DNameW(native_resource);
  }
  return std::nullopt;
}

template <typename T>
std::optional<std::string> GetDebugName(reshade::api::device_api device_api, T object) {
  return GetDebugName(device_api, object.handle);
}

namespace internal {
struct __declspec(uuid("3b70b2b2-52dc-4637-bd45-c1171c4c322e")) DeviceData {
  // <resource.handle, resource_view.handle>

  std::unordered_map<uint64_t, std::string> resource_names;
  std::shared_mutex mutex;
  reshade::api::device_api device_api;
};

const bool FORCE_ALL = false;
const bool TRACE_NAMES = false;

static uint32_t present_count = 0;

static bool attached = false;

static uint64_t GetResourceByViewHandle(DeviceData* data, uint64_t handle) {
  auto* resource_view_info = renodx::utils::resource::GetResourceViewInfo({handle});
  if (resource_view_info == nullptr) return 0;
  if (resource_view_info->resource_info == nullptr) return 0;
  auto resource_handle = resource_view_info->resource_info->resource.handle;

  return resource_handle;
}

static std::string GetResourceNameByViewHandle(DeviceData* data, uint64_t handle) {
  if (!TRACE_NAMES) return "?";
  auto* resource_view_info = renodx::utils::resource::GetResourceViewInfo({handle});

  if (resource_view_info == nullptr) return "?";
  if (resource_view_info->resource_info == nullptr) return "?";
  auto resource_handle = resource_view_info->resource_info->resource.handle;

  if (
      auto pair = data->resource_names.find(resource_handle);
      pair != data->resource_names.end()) return pair->second;

  std::string name;
  if (data->device_api == reshade::api::device_api::d3d11) {
    auto* native_resource = reinterpret_cast<ID3D11DeviceChild*>(resource_handle);
    auto result = GetD3DName(native_resource);
    if (result.has_value()) {
      name.assign(result.value());
    }
  } else {
    name = "?";
  }
  if (!name.empty()) {
    data->resource_names[resource_handle] = name;
  }
  return name;
}

static bool is_primary_hook = false;
static void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "init_device(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ", api: " << device->get_api();
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  DeviceData* data;
  bool created = renodx::utils::data::CreateOrGet(device, data);
  if (!created) return;
  is_primary_hook = true;

  data->device_api = device->get_api();
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (!is_primary_hook) return;
  std::stringstream s;
  s << "destroy_device(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!is_primary_hook) return;
  const size_t back_buffer_count = swapchain->get_back_buffer_count();

  for (uint32_t index = 0; index < back_buffer_count; index++) {
    auto buffer = swapchain->get_back_buffer(index);

    std::stringstream s;
    s << "init_swapchain(";
    s << "buffer:" << PRINT_PTR(buffer.handle);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  std::stringstream s;
  s << "init_swapchain(";
  s << "device: " << reinterpret_cast<uintptr_t>(swapchain->get_device());
  s << ", colorspace: " << swapchain->get_color_space();

  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!is_primary_hook) return;
  const size_t back_buffer_count = swapchain->get_back_buffer_count();

  for (uint32_t index = 0; index < back_buffer_count; index++) {
    auto buffer = swapchain->get_back_buffer(index);

    std::stringstream s;
    s << "destroy_swapchain(";
    s << "buffer:" << PRINT_PTR(buffer.handle);
    s << ", resize:" << (resize ? "true" : "false");
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  std::stringstream s;
  s << "destroy_swapchain(";
  s << "device: " << reinterpret_cast<uintptr_t>(swapchain->get_device());
  s << ", colorspace: " << swapchain->get_color_space();
  s << ", resize:" << (resize ? "true" : "false");
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
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
          s << PRINT_PTR(layout.handle) << "[" << param_index << "]";
          s << " | TBL";
          s << " | " << reinterpret_cast<uintptr_t>(param.descriptor_table.ranges);
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
            case reshade::api::descriptor_type::buffer_shader_resource_view:
              s << "BSRV";
              break;
            case reshade::api::descriptor_type::buffer_unordered_access_view:
              s << "BUAV";
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
        s << PRINT_PTR(layout.handle) << "[" << param_index << "]";
        s << " | PC | ";
        s << "binding: " << param.push_constants.binding;
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
        s << PRINT_PTR(layout.handle) << "[" << param_index << "]";
        s << " | PD | ";
        s << "array_size: " << param.push_descriptors.array_size;
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
        for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
          auto range = param.descriptor_table.ranges[range_index];
          std::stringstream s;
          s << "logPipelineLayout(";
          s << PRINT_PTR(layout.handle) << "[" << param_index << "]";
          s << " | PDR | ";
          s << PRINT_PTR((uintptr_t)param.descriptor_table.ranges);
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
            case reshade::api::descriptor_type::buffer_shader_resource_view:
              s << "BSRV";
              break;
            case reshade::api::descriptor_type::buffer_unordered_access_view:
              s << "BUAV";
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
        // std::stringstream s;
        // s << "logPipelineLayout(";
        // s << PRINT_PTR(layout.handle) << "[" << param_index << "]";
        // s << " | PDR | ";
        // s << " array_size: " << param.descriptor_table.array_size;
        // s << ", binding: " << param.push_descriptors.binding;
        // s << ", count " << param.push_descriptors.count;
        // s << ", register: " << param.push_descriptors.dx_register_index;
        // s << ", space: " << param.push_descriptors.dx_register_space;
        // s << ", type: " << param.push_descriptors.type;
        // s << ", visibility " << param.push_descriptors.visibility;
        // s << ")";
        // reshade::log::message(reshade::log::level::info, s.str().c_str());
        break;
      }
#if RESHADE_API_VERSION >= 13
      case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
        for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
          const auto& range = param.descriptor_table_with_static_samplers.ranges[range_index];
          std::stringstream s;
          s << "logPipelineLayout(";
          s << PRINT_PTR(layout.handle) << "[" << param_index << "]";
          s << " | TBLSS";
          s << " | " << reinterpret_cast<uintptr_t>(param.descriptor_table.ranges);
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
          const auto& range = param.descriptor_table_with_static_samplers.ranges[range_index];
          std::stringstream s;
          s << "logPipelineLayout(";
          s << PRINT_PTR(layout.handle) << "[" << param_index << "]";
          s << " | PDSS";
          s << " | " << reinterpret_cast<uintptr_t>(&range);
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
        s << PRINT_PTR(layout.handle) << "[" << param_index << "]";
        s << " | ??? (0x" << std::hex << static_cast<uint32_t>(param.type) << std::dec << ")";
        s << " | " << param.type;
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
    }
  }
}

static bool OnCreatePipelineLayout(
    reshade::api::device* device,
    uint32_t& param_count,
    reshade::api::pipeline_layout_param*& params) {
  if (!is_primary_hook) return false;

  LogLayout(param_count, params, {0});

  return false;
}

// AfterCreateRootSignature
static void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  if (!is_primary_hook) return;
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
          cbv_index = std::max(cbv_index, range.dx_register_index + range.count);
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      pc_count++;
      cbv_index = std::max(cbv_index, param.push_constants.dx_register_index + param.push_constants.count);
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        cbv_index = std::max(cbv_index, param.push_descriptors.dx_register_index + param.push_descriptors.count);
      }
    }
  }

  const uint32_t max_count = 64u - (param_count + 1u) + 1u;

  std::stringstream s;
  s << "on_init_pipeline_layout++(";
  s << PRINT_PTR(layout.handle);
  s << " , max injections: " << (max_count);
  s << " )";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static bool OnCreatePipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  if (!is_primary_hook) return false;
  if (!trace_running && !trace_pipeline_creation) return false;
  if (subobject_count == 0) {
    std::stringstream s;
    s << "OnCreatePipeline(";
    s << "layout:" << PRINT_PTR(layout.handle);
    s << ", subobjects: " << (subobject_count);
    s << " )";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return false;
  }

  for (uint32_t i = 0; i < subobject_count; ++i) {
    const auto& subobject = subobjects[i];
    for (uint32_t j = 0; j < subobject.count; ++j) {
      std::stringstream s;
      s << "OnCreatePipeline(";
      s << "[" << i << "][" << j << "]";
      s << ", layout:" << PRINT_PTR(layout.handle);
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
  return false;
}

// After CreatePipelineState
static void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  if (!is_primary_hook) return;
  if (!trace_running && !trace_pipeline_creation) return;
  if (subobject_count == 0) {
    std::stringstream s;
    s << "on_init_pipeline(";
    s << PRINT_PTR(pipeline.handle);
    s << ", layout:" << PRINT_PTR(layout.handle);
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
      s << PRINT_PTR(pipeline.handle);
      s << "[" << i << "][" << j << "]";
      s << ", layout:" << PRINT_PTR(layout.handle);
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
  if (!is_primary_hook) return;
  if (!trace_running) return;
  std::stringstream s;
  s << "on_destroy_pipeline(";
  s << PRINT_PTR(pipeline.handle);
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
  if (!is_primary_hook) return;
  if (!trace_running && present_count >= trace_initial_frame_count) return;
  std::stringstream s;
  s << "push_constants(" << PRINT_PTR(layout.handle);
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
  if (!is_primary_hook) return;
  if (!trace_running) return;

  std::stringstream s;
  s << "bind_pipeline(";
  s << PRINT_PTR(pipeline.handle);
  auto* details = renodx::utils::shader::GetPipelineShaderDetails(pipeline);
  if (details != nullptr) {
    s << ", layout: " << PRINT_PTR(details->layout.handle);
    for (const auto& info : details->subobject_shaders) {
      s << ", " << info.stage << ": " << PRINT_CRC32(info.shader_hash);
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
  if (!is_primary_hook) return false;
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
  if (!is_primary_hook) return false;
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
  if (!is_primary_hook) return false;

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
  if (!is_primary_hook) return false;

  if (trace_running) {
    std::stringstream s;
    s << "on_draw_or_dispatch_indirect(" << type;
    s << ", " << PRINT_PTR(buffer.handle);
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
  if (!is_primary_hook) return false;

  if (!trace_running && present_count >= trace_initial_frame_count) return false;
  auto* device = cmd_list->get_device();
  const auto source_desc = device->get_resource_desc(source);
  const auto dest_desc = device->get_resource_desc(dest);
  std::stringstream s;
  s << "OnCopyTextureRegion";
  s << "(" << PRINT_PTR(source.handle);
  s << ", " << (source_desc.texture.format);
  s << "[" << (source_subresource);
  s << "] => " << PRINT_PTR(dest.handle);
  s << ", " << (dest_desc.texture.format);
  s << "[" << (dest_subresource);
  s << "], filter: " << static_cast<uint32_t>(filter);
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
  if (!is_primary_hook) return false;

  if (!trace_running && present_count >= trace_initial_frame_count) return false;
  std::stringstream s;
  s << "OnCopyTextureToBuffer(" << PRINT_PTR(source.handle);
  s << "[" << source_subresource << "]";
  if (source_box != nullptr) {
    s << "(" << source_box->top << ", " << source_box->left << ", " << source_box->front << ")";
  }
  s << " => " << PRINT_PTR(dest.handle);
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
  if (!is_primary_hook) return false;

  if (!trace_running && present_count >= trace_initial_frame_count) return false;
  std::stringstream s;
  s << "OnCopyBufferToTexture";
  s << "(" << PRINT_PTR(source.handle);
  s << "[" << source_offset << "]";
  s << " => " << PRINT_PTR(dest.handle);
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
    uint32_t dest_x,
    uint32_t dest_y,
    uint32_t dest_z,
    reshade::api::format format) {
  if (!is_primary_hook) return false;

  if (!trace_running && present_count >= trace_initial_frame_count) return false;
  std::stringstream s;
  s << "on_resolve_texture_region";
  s << "(" << PRINT_PTR(source.handle);
  s << ": " << (source_subresource);
  s << " => " << PRINT_PTR(dest.handle);
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
  if (!is_primary_hook) return false;

  if (!trace_running && present_count >= trace_initial_frame_count) return false;
  std::stringstream s;
  s << "on_copy_resource";
  s << "(" << PRINT_PTR(source.handle);
  s << " => " << PRINT_PTR(dest.handle);
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
  if (!is_primary_hook) return;
  if (!trace_running && present_count >= trace_initial_frame_count) return;
  for (uint32_t i = 0; i < count; i++) {
    std::stringstream s;
    s << "on_barrier(" << PRINT_PTR(resources[i].handle);
    s << ", " << std::hex << static_cast<uint32_t>(old_states[i]) << std::dec << " (" << old_states[i] << ")";
    s << " => " << std::hex << static_cast<uint32_t>(new_states[i]) << std::dec << " (" << new_states[i] << ")";
    s << ") [" << i << "]";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
}

static void OnBeginRenderPass(
    reshade::api::command_list* cmd_list,
    uint32_t count, const reshade::api::render_pass_render_target_desc* rts,
    const reshade::api::render_pass_depth_stencil_desc* ds) {
  if (!is_primary_hook) return;
  if (!trace_running && present_count >= trace_initial_frame_count) return;
  for (uint32_t i = 0; i < count; i++) {
    std::stringstream s;
    s << "OnBeginRenderPass(" << PRINT_PTR(rts[i].view.handle);
    s << ", load_op: " << rts->load_op;
    s << ", store_op: " << rts->store_op;
    s << ") [" << i << "]";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
  if (ds != nullptr) {
    std::stringstream s;
    s << "OnBeginRenderPass(dsv: " << PRINT_PTR(ds->view.handle);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
}

static void OnEndRenderPass(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  if (!trace_running && present_count >= trace_initial_frame_count) return;
  std::stringstream s;
  s << "OnEndRenderPass()";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (!is_primary_hook) return;
  if (!trace_running) return;

  if (count != 0) {
    // InstructionState state = instructions.at(instructions.size() - 1);
    // state.renderTargets.clear();
    auto* device = cmd_list->get_device();
    auto* data = renodx::utils::data::Get<DeviceData>(device);
    const std::shared_lock lock(data->mutex);
    for (uint32_t i = 0; i < count; i++) {
      const auto& rtv = rtvs[i];
      std::stringstream s;
      s << "on_bind_render_targets(";
      s << PRINT_PTR(rtv.handle);
      s << ", res: " << PRINT_PTR(GetResourceByViewHandle(data, rtv.handle));
      s << ", name: " << GetResourceNameByViewHandle(data, rtv.handle);
      s << ")";
      s << "[" << i << "]";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }
  if (dsv.handle != 0) {
    std::stringstream s;
    s << "on_bind_depth_stencil(";
    s << PRINT_PTR(dsv.handle);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
  if (count == 0 && dsv.handle == 0) {
    reshade::log::message(reshade::log::level::info, "on_bind_depth_stencil(?)");
  }
}

static void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (!is_primary_hook) return;

  if (!FORCE_ALL && !trace_running && present_count >= trace_initial_frame_count) return;

  bool warn = false;
  std::stringstream s;
  s << "init_resource(" << PRINT_PTR(resource.handle);
  s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", state: " << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
  s << ", type: " << desc.type;
  s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;

  switch (desc.type) {
    case reshade::api::resource_type::buffer:
      s << ", size: " << desc.buffer.size;
      s << ", stride: " << desc.buffer.stride;
      if (!trace_running && present_count >= trace_initial_frame_count) return;
      break;
    case reshade::api::resource_type::texture_1d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::surface:
      s << ", width: " << desc.texture.width;
      s << ", height: " << desc.texture.height;
      s << ", depth/layers: " << desc.texture.depth_or_layers;
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
  if (!is_primary_hook) return;

  auto* data = renodx::utils::data::Get<DeviceData>(device);

  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  data->resource_names.erase(resource.handle);
  if (!trace_running && present_count >= trace_initial_frame_count) return;

  std::stringstream s;
  s << "utils::trace::on_destroy_resource(";
  s << PRINT_PTR(resource.handle);
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
}

static void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  if (!is_primary_hook) return;

  if (!FORCE_ALL && !trace_running && present_count >= trace_initial_frame_count) return;
  std::stringstream s;
  s << "init_resource_view(" << PRINT_PTR(view.handle);
  s << ", view type: " << desc.type << " (0x" << std::hex << static_cast<uint32_t>(desc.type) << std::dec << ")";
  s << ", view format: " << desc.format << " (0x" << std::hex << static_cast<uint32_t>(desc.format) << std::dec << ")";
  s << ", resource: " << PRINT_PTR(resource.handle);
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
  if (!is_primary_hook) return;
  if (!trace_running && present_count >= trace_initial_frame_count) return;
  std::stringstream s;
  s << "utils::trace::on_destroy_resource_view(";
  s << PRINT_PTR(view.handle);
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
}

static void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (!is_primary_hook) return;
  if (!FORCE_ALL && !trace_running) return;
  auto* device = cmd_list->get_device();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  const std::shared_lock lock(data->mutex);
  for (uint32_t i = 0; i < update.count; i++) {
    std::stringstream s;
    s << "push_descriptors(" << PRINT_PTR(layout.handle);
    s << "[" << layout_param << "]";
    s << "[" << update.binding + i << "]";
    s << ", type: " << update.type;
    s << ", stages: " << stages << " (" << std::hex << static_cast<uint32_t>(stages) << std::dec << ")";

    auto log_heap = [&]() {
      if (update.table.handle == 0u) return std::string("");
      std::stringstream s2;
      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(update.table, update.binding + i, 0, &heap, &base_offset);
      s2 << ", heap: " << PRINT_PTR(heap.handle) << "[" << base_offset << "]";
      return s2.str();
    };

    switch (update.type) {
      case reshade::api::descriptor_type::sampler: {
        s << log_heap();
        auto item = static_cast<const reshade::api::sampler*>(update.descriptors)[i];
        s << ", sampler: " << PRINT_PTR(item.handle);
        break;
      }
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        s << log_heap();
        auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i];
        s << ", sampler: " << PRINT_PTR(item.sampler.handle);
        s << ", rsv: " << PRINT_PTR(item.view.handle);
        s << ", res: " << PRINT_PTR(GetResourceByViewHandle(data, item.view.handle));
        // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
        break;
      }
      case reshade::api::descriptor_type::texture_shader_resource_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:  {
        s << log_heap();
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", shaderrsv: " << PRINT_PTR(item.handle);
        s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
        // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        break;
      }
      case reshade::api::descriptor_type::texture_unordered_access_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:  {
        s << log_heap();
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", uav: " << PRINT_PTR(item.handle);
        s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
        // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        break;
      }
      case reshade::api::descriptor_type::acceleration_structure: {
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", accl: " << PRINT_PTR(item.handle);
        break;
      }
      case reshade::api::descriptor_type::constant_buffer: {
        auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
        s << ", buffer: " << PRINT_PTR(item.buffer.handle);
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
  if (!is_primary_hook) return;
  if (!FORCE_ALL && !trace_running) return;
  auto* device = cmd_list->get_device();

  auto* layout_data = pipeline_layout::GetPipelineLayoutData(layout);
  renodx::utils::descriptor::DeviceData* descriptor_data = nullptr;

  for (uint32_t i = 0; i < count; ++i) {
    auto layout_index = first + i;
    {
      std::stringstream s;
      s << "bind_descriptor_table(" << PRINT_PTR(layout.handle);
      s << "[" << layout_index << "]";
      s << ", stages: " << stages << "(" << std::hex << static_cast<uint32_t>(stages) << std::dec << ")";
      s << ", table: " << PRINT_PTR(tables[i].handle);
      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(tables[i], 0, 0, &heap, &base_offset);
      s << ", heap: " << PRINT_PTR(heap.handle) << "[" << base_offset << "]";

      s << ") [" << i << "]";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }

    const auto& param = layout_data->params.at(layout_index);

    for (uint32_t k = 0; k < param.descriptor_table.count; ++k) {
      const auto& range = param.descriptor_table.ranges[k];

      // Skip unbounded ranges
      if (range.count == UINT32_MAX) continue;

      switch (range.type) {
        case reshade::api::descriptor_type::sampler_with_resource_view:
        case reshade::api::descriptor_type::texture_shader_resource_view:
        case reshade::api::descriptor_type::texture_unordered_access_view:
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::acceleration_structure:
          break;
        default:
          assert(false);
        case reshade::api::descriptor_type::sampler:
        case reshade::api::descriptor_type::constant_buffer:
        case reshade::api::descriptor_type::shader_storage_buffer:
          continue;
      }

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(tables[i], range.binding, 0, &heap, &base_offset);

      if (descriptor_data == nullptr) {
        descriptor_data = renodx::utils::data::Get<renodx::utils::descriptor::DeviceData>(device);
      }
      const std::shared_lock descriptor_lock(descriptor_data->mutex);

      for (uint32_t j = 0; j < range.count; ++j) {
        auto heap_pair = descriptor_data->heaps.find(heap.handle);
        if (heap_pair == descriptor_data->heaps.end()) continue;
        const auto& heap_data = heap_pair->second;
        auto offset = base_offset + j;
        if (offset >= heap_data.size()) continue;
        const auto& [descriptor_type, descriptor_data] = heap_data[offset];
        reshade::api::resource_view resource_view = {0};
        bool is_uav = false;
        switch (descriptor_type) {
          case reshade::api::descriptor_type::sampler_with_resource_view:
            resource_view = std::get<reshade::api::sampler_with_resource_view>(descriptor_data).view;
            break;
          case reshade::api::descriptor_type::buffer_unordered_access_view:
          case reshade::api::descriptor_type::texture_unordered_access_view:
            is_uav = true;
            // fallthrough
          case reshade::api::descriptor_type::buffer_shader_resource_view:
          case reshade::api::descriptor_type::texture_shader_resource_view:
            resource_view = std::get<reshade::api::resource_view>(descriptor_data);
            break;
          case reshade::api::descriptor_type::constant_buffer:
          case reshade::api::descriptor_type::shader_storage_buffer:
          case reshade::api::descriptor_type::acceleration_structure:
            break;
          default:
            break;
        }
        // if (resource_view.handle == 0u) continue;
        {
          std::stringstream s;
          s << "bind_descriptor_table(" << PRINT_PTR(layout.handle);
          s << "[" << (layout_index) << "]";
          s << ", rsv: " << PRINT_PTR(resource_view.handle);
          s << ", param: " << param.type;
          s << ", binding: " << range.binding;
          s << ", dx_index: " << range.dx_register_index;
          s << ", dx_space: " << range.dx_register_space;
          s << ", j: " << j;
          s << ")";
          reshade::log::message(reshade::log::level::info, s.str().c_str());
        }
      }
    }
  }
}

static bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (!is_primary_hook) return false;
  if (!FORCE_ALL && !trace_running && present_count >= trace_initial_frame_count) return false;

  renodx::utils::descriptor::DeviceData* descriptor_data = nullptr;

  for (uint32_t i = 0; i < count; i++) {
    const auto& copy = copies[i];

    uint32_t src_offset = 0;
    reshade::api::descriptor_heap src_heap = {0};
    device->get_descriptor_heap_offset(
        copy.source_table, copy.source_binding, copy.source_array_offset, &src_heap, &src_offset);
    uint32_t dest_offset = 0;
    reshade::api::descriptor_heap dest_heap = {0};
    device->get_descriptor_heap_offset(
        copy.dest_table, copy.dest_binding, copy.dest_array_offset, &dest_heap, &dest_offset);

    for (uint32_t j = 0; j < copy.count; j++) {
      std::stringstream s;
      s << "copy_descriptor_tables(";
      s << PRINT_PTR(copy.source_table.handle);
      s << "[" << copy.source_binding << "]";
      s << "[" << copy.source_array_offset << "]";
      s << " => ";
      s << PRINT_PTR(copy.dest_table.handle);
      s << "[" << copy.dest_binding << "]";
      s << "[" << copy.dest_array_offset << "]";

      s << ", heap: " << PRINT_PTR(src_heap.handle) << "[" << src_offset + j << "]";
      s << " => " << PRINT_PTR(dest_heap.handle) << "[" << dest_offset + j << "]";

      if (descriptor_data == nullptr) {
        descriptor_data = renodx::utils::data::Get<renodx::utils::descriptor::DeviceData>(device);
      }
      const std::shared_lock decriptor_lock(descriptor_data->mutex);
      auto origin_primary_key = std::pair<uint64_t, uint32_t>(copy.source_table.handle, copy.source_binding + j);
      if (auto pair = descriptor_data->table_descriptor_resource_views.find(origin_primary_key);
          pair != descriptor_data->table_descriptor_resource_views.end()) {
        auto update = pair->second;
        auto view = renodx::utils::descriptor::GetResourceViewFromDescriptorUpdate(update);
        if (view.handle != 0) {
          auto* data = renodx::utils::data::Get<DeviceData>(device);
          const std::shared_lock lock(data->mutex);
          s << ", rsv: " << PRINT_PTR(view.handle);
          s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, view.handle));
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
  if (!is_primary_hook) return false;

  if (!FORCE_ALL && !trace_running && present_count >= trace_initial_frame_count) return false;

  for (uint32_t i = 0; i < count; i++) {
    const auto& update = updates[i];

    for (uint32_t j = 0; j < update.count; j++) {
      std::stringstream s;
      s << "update_descriptor_tables(";
      s << PRINT_PTR(update.table.handle);
      s << "[" << update.binding + j << "]";

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(update.table, update.binding + j, 0, &heap, &base_offset);
      s << ", heap: " << PRINT_PTR(heap.handle) << "[" << base_offset << "]";
      switch (update.type) {
        case reshade::api::descriptor_type::sampler: {
          auto item = static_cast<const reshade::api::sampler*>(update.descriptors)[j];
          s << ", sampler: " << PRINT_PTR(item.handle);
          break;
        }
        case reshade::api::descriptor_type::sampler_with_resource_view: {
          auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
          s << ", sampler: " << PRINT_PTR(item.sampler.handle);
          s << ", rsv: " << PRINT_PTR(item.view.handle);
          auto* data = renodx::utils::data::Get<DeviceData>(device);
          const std::shared_lock lock(data->mutex);
          s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.view.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          break;
        }
        case reshade::api::descriptor_type::buffer_shader_resource_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", b-srv: " << PRINT_PTR(item.handle);
          auto* data = renodx::utils::data::Get<DeviceData>(device);
          const std::shared_lock lock(data->mutex);
          s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          break;
        }
        case reshade::api::descriptor_type::buffer_unordered_access_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", b-uav: " << PRINT_PTR(item.handle);
          auto* data = renodx::utils::data::Get<DeviceData>(device);
          const std::shared_lock lock(data->mutex);
          s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          break;
        }
        case reshade::api::descriptor_type::texture_shader_resource_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", srv: " << PRINT_PTR(item.handle);
          auto* data = renodx::utils::data::Get<DeviceData>(device);
          const std::shared_lock lock(data->mutex);
          s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          break;
        }
        case reshade::api::descriptor_type::texture_unordered_access_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", uav: " << PRINT_PTR(item.handle);
          auto* data = renodx::utils::data::Get<DeviceData>(device);
          const std::shared_lock lock(data->mutex);
          s << ", res: " << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          break;
        }
        case reshade::api::descriptor_type::constant_buffer: {
          auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[j];
          s << ", buffer: " << PRINT_PTR(item.buffer.handle);
          s << ", size: " << item.size;
          s << ", offset: " << item.offset;
          break;
        }
        case reshade::api::descriptor_type::shader_storage_buffer: {
          auto item = static_cast<const reshade::api::buffer_range*>(update.descriptors)[j];
          s << ", buffer: " << PRINT_PTR(item.buffer.handle);
          s << ", size: " << item.size;
          s << ", offset: " << item.offset;
          break;
        }
        case reshade::api::descriptor_type::acceleration_structure: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", accl: " << PRINT_PTR(item.handle);
          auto* data = renodx::utils::data::Get<DeviceData>(device);
          const std::shared_lock lock(data->mutex);
          s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
          break;
        }
        default:
          break;
      }
      s << ") [" << i << "]";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }
  return false;
}

static bool OnClearDepthStencilView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view dsv,
    const float* depth,
    const uint8_t* stencil,
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (!is_primary_hook) return false;

  if (!trace_running) return false;
  std::stringstream s;
  s << "OnClearDepthStencilView(";
  s << PRINT_PTR(dsv.handle);
  s << ")";

  reshade::log::message(reshade::log::level::info, s.str().c_str());
  return false;
}

static bool OnClearRenderTargetView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (!is_primary_hook) return false;

  if (!trace_running && present_count >= trace_initial_frame_count) return false;
  std::stringstream s;
  s << "OnClearRenderTargetView(";
  s << PRINT_PTR(rtv.handle);
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
  if (!is_primary_hook) return false;

  if (!trace_running && present_count >= trace_initial_frame_count) return false;
  std::stringstream s;
  s << "on_clear_unordered_access_view_uint(";
  s << PRINT_PTR(uav.handle);
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
  if (!is_primary_hook) return;
  if (!trace_running && present_count >= trace_initial_frame_count) return;
  std::stringstream s;
  s << "map_buffer_region(";
  s << PRINT_PTR(resource.handle);
  s << ")";

  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnUnmapBufferRegion(
    reshade::api::device* device,
    reshade::api::resource resource) {
  if (!is_primary_hook) return;
  if (!trace_running && present_count >= trace_initial_frame_count) return;

  std::stringstream s;
  s << "unmap_buffer_region(";
  s << PRINT_PTR(resource.handle);
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
  if (!is_primary_hook) return;
  if (!trace_running && present_count >= trace_initial_frame_count) return;
  std::stringstream s;
  s << "map_texture_region(";
  s << PRINT_PTR(resource.handle);
  s << "[" << subresource << "]";
  s << ")";

  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static bool OnUpdateBufferRegion(
    reshade::api::device* device,
    const void* data, reshade::api::resource resource,
    uint64_t offset, uint64_t size) {
  if (!is_primary_hook) return false;
  if (!trace_running && present_count >= trace_initial_frame_count) return false;
  std::stringstream s;
  s << "OnUpdateBufferRegion(";
  s << PRINT_PTR(resource.handle);
  s << ", offset: " << offset;
  s << ", size: " << offset;
  s << ")";
  return false;
}

static bool OnUpdateTextureRegion(
    reshade::api::device* device,
    const reshade::api::subresource_data& data,
    reshade::api::resource resource,
    uint32_t subresource,
    const reshade::api::subresource_box* box) {
  if (!is_primary_hook) return false;
  if (!trace_running && present_count >= trace_initial_frame_count) return false;
  std::stringstream s;
  s << "OnUpdateTextureRegion(";
  s << PRINT_PTR(resource.handle);
  s << ", subresource: " << subresource;
  s << ")";
  return false;
}

static void OnBindPipelineStates(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::dynamic_state* states,
    const uint32_t* values) {
  if (!is_primary_hook) return;
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

static void OnBindViewports(reshade::api::command_list* cmd_list, uint32_t first, uint32_t count, const reshade::api::viewport* viewports) {
  if (!is_primary_hook) return;
  if (!trace_running) return;

  for (uint32_t i = 0; i < count; i++) {
    auto viewport = viewports[first + i];
    std::stringstream s;
    s << "OnBindViewports";
    s << "(" << viewport.x;
    s << ", " << viewport.y;
    s << ", " << viewport.width;
    s << ", " << viewport.height;
    s << ", depth: [" << viewport.min_depth;
    s << ", " << viewport.max_depth;
    s << "])";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
}

static void OnBindScissorRects(reshade::api::command_list* cmd_list, uint32_t first, uint32_t count, const reshade::api::rect* rects) {
  if (!is_primary_hook) return;
  if (!trace_running) return;

  for (uint32_t i = 0; i < count; i++) {
    auto rect = rects[first + i];
    std::stringstream s;
    s << "OnBindScissorRects";
    s << "(" << rect.top;
    s << ", " << rect.right;
    s << ", " << rect.bottom;
    s << ", " << rect.left;
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
  if (!is_primary_hook) return;
  if (trace_running) {
    std::stringstream s;
    s << "present(";
    s << PRINT_PTR(swapchain->get_current_back_buffer().handle);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());

    reshade::log::message(reshade::log::level::info, "--- End Frame ---");
    trace_running = false;
  } else if (trace_scheduled) {
    trace_scheduled = false;
    trace_running = true;
    reshade::log::message(reshade::log::level::info, "--- Frame ---");
  }
  if (present_count <= trace_initial_frame_count) {
    present_count++;
  }
}
}  // namespace internal

static void Use(DWORD fdw_reason) {
  renodx::utils::descriptor::Use(fdw_reason);
  renodx::utils::shader::Use(fdw_reason);
  renodx::utils::resource::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      // init_command_list
      // destroy_command_list
      // init_command_queue
      // destroy_command_queue
      reshade::register_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      // create_swapchain
      reshade::register_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      // init_effect_runtime
      // destroy_effect_runtime
      // init_sampler
      // create_sampler
      // destroy_sampler
      reshade::register_event<reshade::addon_event::init_resource>(internal::OnInitResource);
      // create_resource
      reshade::register_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
      reshade::register_event<reshade::addon_event::init_resource_view>(internal::OnInitResourceView);
      // create_resource_view
      reshade::register_event<reshade::addon_event::destroy_resource_view>(internal::OnDestroyResourceView);
      reshade::register_event<reshade::addon_event::map_buffer_region>(internal::OnMapBufferRegion);
      reshade::register_event<reshade::addon_event::unmap_buffer_region>(internal::OnUnmapBufferRegion);

      reshade::register_event<reshade::addon_event::map_texture_region>(internal::OnMapTextureRegion);
      // unmap_texture_region
      reshade::register_event<reshade::addon_event::update_buffer_region>(internal::OnUpdateBufferRegion);
      reshade::register_event<reshade::addon_event::update_texture_region>(internal::OnUpdateTextureRegion);
      // reshade::register_event<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
      reshade::register_event<reshade::addon_event::create_pipeline>(internal::OnCreatePipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(internal::OnDestroyPipeline);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(internal::OnInitPipelineLayout);
      reshade::register_event<reshade::addon_event::create_pipeline_layout>(internal::OnCreatePipelineLayout);
      // destroy_pipeline_layout
      reshade::register_event<reshade::addon_event::copy_descriptor_tables>(internal::OnCopyDescriptorTables);
      reshade::register_event<reshade::addon_event::update_descriptor_tables>(internal::OnUpdateDescriptorTables);
      // init_query_heap
      // create_query_heap
      // destroy_query_heap
      // get_query_heap_results
      reshade::register_event<reshade::addon_event::barrier>(internal::OnBarrier);
      reshade::register_event<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
      reshade::register_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::bind_pipeline>(internal::OnBindPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline_states>(internal::OnBindPipelineStates);
      reshade::register_event<reshade::addon_event::bind_viewports>(internal::OnBindViewports);
      reshade::register_event<reshade::addon_event::bind_scissor_rects>(internal::OnBindScissorRects);
      reshade::register_event<reshade::addon_event::push_constants>(internal::OnPushConstants);
      reshade::register_event<reshade::addon_event::push_descriptors>(internal::OnPushDescriptors);
      reshade::register_event<reshade::addon_event::bind_descriptor_tables>(internal::OnBindDescriptorTables);
      // bind_index_buffer
      // bind_vertex_buffers
      // bind_stream_output_buffers
      reshade::register_event<reshade::addon_event::draw>(internal::OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed);
      reshade::register_event<reshade::addon_event::dispatch>(internal::OnDispatch);
      // dispatch_mesh
      // dispatch_rays
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect);
      reshade::register_event<reshade::addon_event::copy_resource>(internal::OnCopyResource);
      // copy_buffer_region
      reshade::register_event<reshade::addon_event::copy_buffer_to_texture>(internal::OnCopyBufferToTexture);
      reshade::register_event<reshade::addon_event::copy_texture_region>(internal::OnCopyTextureRegion);
      reshade::register_event<reshade::addon_event::copy_texture_to_buffer>(internal::OnCopyTextureToBuffer);
      reshade::register_event<reshade::addon_event::resolve_texture_region>(internal::OnResolveTextureRegion);
      reshade::register_event<reshade::addon_event::clear_depth_stencil_view>(internal::OnClearDepthStencilView);
      reshade::register_event<reshade::addon_event::clear_render_target_view>(internal::OnClearRenderTargetView);
      reshade::register_event<reshade::addon_event::clear_unordered_access_view_uint>(internal::OnClearUnorderedAccessViewUint);
      // clear_unordered_access_view_float
      // generate_mipmaps
      // begin_query
      // end_query
      // copy_query_heap_results
      // copy_acceleration_structure
      // build_acceleration_structure
      // reset_command_list
      // close_command_list
      // execute_command_list
      // execute_secondary_command_list
      reshade::register_event<reshade::addon_event::present>(internal::OnPresent);
      // set_fullscreen_state

      break;
    case DLL_PROCESS_DETACH:

      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      // init_command_list
      // destroy_command_list
      // init_command_queue
      // destroy_command_queue
      reshade::unregister_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      // create_swapchain
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      // init_effect_runtime
      // destroy_effect_runtime
      // init_sampler
      // create_sampler
      // destroy_sampler
      reshade::unregister_event<reshade::addon_event::init_resource>(internal::OnInitResource);
      // create_resource
      reshade::unregister_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
      reshade::unregister_event<reshade::addon_event::init_resource_view>(internal::OnInitResourceView);
      // create_resource_view
      reshade::unregister_event<reshade::addon_event::destroy_resource_view>(internal::OnDestroyResourceView);
      reshade::unregister_event<reshade::addon_event::map_buffer_region>(internal::OnMapBufferRegion);
      reshade::unregister_event<reshade::addon_event::unmap_buffer_region>(internal::OnUnmapBufferRegion);
      reshade::unregister_event<reshade::addon_event::map_texture_region>(internal::OnMapTextureRegion);
      // unmap_texture_region
      reshade::unregister_event<reshade::addon_event::update_buffer_region>(internal::OnUpdateBufferRegion);
      reshade::unregister_event<reshade::addon_event::update_texture_region>(internal::OnUpdateTextureRegion);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::create_pipeline>(internal::OnCreatePipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(internal::OnDestroyPipeline);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(internal::OnInitPipelineLayout);
      reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(internal::OnCreatePipelineLayout);
      // destroy_pipeline_layout
      reshade::unregister_event<reshade::addon_event::copy_descriptor_tables>(internal::OnCopyDescriptorTables);
      reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(internal::OnUpdateDescriptorTables);
      // init_query_heap
      // create_query_heap
      // destroy_query_heap
      // get_query_heap_results
      reshade::unregister_event<reshade::addon_event::barrier>(internal::OnBarrier);
      reshade::unregister_event<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
      reshade::unregister_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(internal::OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline_states>(internal::OnBindPipelineStates);
      reshade::unregister_event<reshade::addon_event::bind_viewports>(internal::OnBindViewports);
      reshade::unregister_event<reshade::addon_event::bind_scissor_rects>(internal::OnBindScissorRects);
      reshade::unregister_event<reshade::addon_event::push_constants>(internal::OnPushConstants);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(internal::OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::bind_descriptor_tables>(internal::OnBindDescriptorTables);
      // bind_index_buffer
      // bind_vertex_buffers
      // bind_stream_output_buffers
      reshade::unregister_event<reshade::addon_event::draw>(internal::OnDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::dispatch>(internal::OnDispatch);
      // dispatch_mesh
      // dispatch_rays
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect);
      reshade::unregister_event<reshade::addon_event::copy_resource>(internal::OnCopyResource);
      // copy_buffer_region
      reshade::unregister_event<reshade::addon_event::copy_buffer_to_texture>(internal::OnCopyBufferToTexture);
      reshade::unregister_event<reshade::addon_event::copy_texture_region>(internal::OnCopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_texture_to_buffer>(internal::OnCopyTextureToBuffer);
      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(internal::OnResolveTextureRegion);
      reshade::unregister_event<reshade::addon_event::clear_depth_stencil_view>(internal::OnClearDepthStencilView);
      reshade::unregister_event<reshade::addon_event::clear_render_target_view>(internal::OnClearRenderTargetView);
      reshade::unregister_event<reshade::addon_event::clear_unordered_access_view_uint>(internal::OnClearUnorderedAccessViewUint);
      // clear_unordered_access_view_float
      // generate_mipmaps
      // begin_queryla
      // end_query
      // copy_query_heap_results
      // copy_acceleration_structure
      // build_acceleration_structure
      // reset_command_list
      // close_command_list
      // execute_command_list
      // execute_secondary_command_list
      reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);
      // set_fullscreen_state
      break;
  }
}
}  // namespace renodx::utils::trace
