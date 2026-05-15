/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cstdint>
#include <optional>
#include <sstream>

#include <include/reshade.hpp>

#include "./data.hpp"
#include "./descriptor.hpp"
#include "./format.hpp"
#include "./hash.hpp"
#include "./cross_addon.hpp"
#include "./pipeline_layout.hpp"
#include "./resource.hpp"
#include "./shader.hpp"

namespace renodx::utils::trace {

inline constexpr GUID D3D_DEBUG_OBJECT_NAME_GUID = {0x429b8c22, 0x9188, 0x4b0c, {0x87, 0x42, 0xac, 0xb0, 0xbf, 0x85, 0xc2, 0x00}};
inline constexpr GUID D3D_DEBUG_OBJECT_NAME_W_GUID = {0x4cca5fd8, 0x921f, 0x42c8, {0x85, 0x66, 0x70, 0xca, 0xf2, 0xa9, 0xb7, 0x41}};

static reshade::api::device* trace_scheduled_device = nullptr;
static reshade::api::device* trace_running_device = nullptr;
static std::atomic_bool trace_pipeline_creation = false;
static std::atomic_uint32_t trace_initial_frame_count = 0;
static std::atomic_bool trace_all = false;

template <class T>
std::optional<std::string> GetD3DName(T* obj) {
  if (obj == nullptr) return std::nullopt;

  byte data[128] = {};
  UINT size = sizeof(data);
  if (obj->GetPrivateData(D3D_DEBUG_OBJECT_NAME_GUID, &size, data) == S_OK) {
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
    if (obj->GetPrivateData(D3D_DEBUG_OBJECT_NAME_W_GUID, &size, data) == S_OK) {
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

struct __declspec(uuid("14db1087-1a47-4f0c-b513-fd9cb4bc252f")) SharedData {};

static cross_addon::Shared<SharedData> shared;

const bool TRACE_NAMES = false;

static uint32_t present_count = 0;

static constexpr uint32_t TRACE_DESCRIPTOR_LOG_LIMIT = 256;

static uint64_t GetResourceByViewHandle(DeviceData* data, uint64_t handle) {
  if (handle == 0) return 0;
  return renodx::utils::resource::GetResourceFromView({handle}).handle;
}

static std::string GetResourceNameByViewHandle(DeviceData* data, uint64_t handle) {
  if (!TRACE_NAMES) return "?";
  if (handle == 0) return "?";
  const auto resource_handle = renodx::utils::resource::GetResourceFromView({handle}).handle;
  if (resource_handle == 0u) return "?";

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

static bool IsTrackedDevice(reshade::api::device* device) {
  return device != nullptr
         && renodx::utils::data::Get<DeviceData>(device) != nullptr;
}

static bool IsTrackedCommandList(reshade::api::command_list* cmd_list) {
  return cmd_list != nullptr && IsTrackedDevice(cmd_list->get_device());
}

static void OnInitDevice(reshade::api::device* device) {
  const auto device_api = device->get_api();

  std::stringstream s;
  s << "init_device(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ", api: " << device_api;
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  DeviceData* data = nullptr;
  renodx::utils::data::CreateOrGet<DeviceData>(device, data);
  if (data == nullptr) return;

  data->device_api = device_api;
}

static void OnDestroyDevice(reshade::api::device* device) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data != nullptr) {
    std::stringstream s;
    s << "destroy_device(";
    s << reinterpret_cast<uintptr_t>(device);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
  renodx::utils::data::Delete<DeviceData>(device);
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* data = renodx::utils::data::Get<DeviceData>(swapchain->get_device());
  if (data == nullptr) return;
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
  auto* data = renodx::utils::data::Get<DeviceData>(swapchain->get_device());
  if (data == nullptr) return;
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
  if (!IsTrackedDevice(device)) return false;

  LogLayout(param_count, params, {0});

  return false;
}

// AfterCreateRootSignature
static void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  if (!IsTrackedDevice(device)) return;
  if (layout.handle == 0u) {
    assert(layout.handle != 0u);
  }
  LogLayout(param_count, params, layout);

  const bool found_visiblity = false;
  uint32_t cbv_index = 0;
  uint32_t push_constant_params = 0;
  uint32_t push_constant_count = 0;
  uint32_t dword_count = 0;

  for (const auto& param : std::span(params, param_count)) {
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      dword_count += 1;
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      dword_count += param.push_constants.count;
      push_constant_params++;
      push_constant_count += param.push_constants.count;
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      dword_count += 2;
    }
  }

  std::stringstream s;
  s << "OnInitPipelineLayout(";
  s << PRINT_PTR(layout.handle);
  s << ", params: " << param_count;
  s << " , push constant params: " << push_constant_params;
  s << " , push constant count: " << push_constant_count;
  s << " , dword count: " << dword_count;
  s << " , available slots: " << 64u - dword_count;
  s << " )";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static bool OnCreatePipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  if (!IsTrackedDevice(device)) return false;
  if (!trace_pipeline_creation || trace_running_device != device) return false;
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
            auto shader_hash = renodx::utils::hash::ComputeCRC32(static_cast<const uint8_t*>(desc.code), desc.code_size);
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
  if (!IsTrackedDevice(device)) return;
  if (trace_running_device != device && !trace_pipeline_creation) return;
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
            auto shader_hash = renodx::utils::hash::ComputeCRC32(static_cast<const uint8_t*>(desc.code), desc.code_size);
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
  if (!IsTrackedDevice(device)) return;
  if (trace_running_device != device) return;
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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return;
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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (trace_running_device != cmd_list->get_device()) return;

  std::stringstream s;
  s << "bind_pipeline(";
  s << PRINT_PTR(pipeline.handle);

  renodx::utils::shader::PipelineShaderDetails* details = nullptr;
  if (pipeline.handle != 0u && stages != reshade::api::pipeline_stage::ray_tracing_shader) {
    details = renodx::utils::shader::GetPipelineShaderDetails(pipeline);
  }
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
  if (!IsTrackedCommandList(cmd_list)) return false;
  if (!trace_all && trace_running_device != cmd_list->get_device()) return false;

  std::stringstream s;
  s << "on_draw";
  s << "(" << vertex_count;
  s << ", " << instance_count;
  s << ", " << first_vertex;
  s << ", " << first_instance;
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  return false;
}

static bool OnDispatch(reshade::api::command_list* cmd_list, uint32_t group_count_x, uint32_t group_count_y, uint32_t group_count_z) {
  if (!IsTrackedCommandList(cmd_list)) return false;
  if (!trace_all && trace_running_device != cmd_list->get_device()) return false;

  std::stringstream s;
  s << "on_dispatch";
  s << "(" << group_count_x;
  s << ", " << group_count_y;
  s << ", " << group_count_z;
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  return false;
}

static bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  if (!IsTrackedCommandList(cmd_list)) return false;
  if (!trace_all && trace_running_device != cmd_list->get_device()) return false;

  std::stringstream s;
  s << "on_draw_indexed";
  s << "(" << index_count;
  s << ", " << instance_count;
  s << ", " << first_index;
  s << ", " << vertex_offset;
  s << ", " << first_instance;
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  return false;
}

static bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride) {
  if (!IsTrackedCommandList(cmd_list)) return false;
  if (!trace_all && trace_running_device != cmd_list->get_device()) return false;

  std::stringstream s;
  s << "on_draw_or_dispatch_indirect(" << type;
  s << ", " << PRINT_PTR(buffer.handle);
  s << ", " << offset;
  s << ", " << draw_count;
  s << ", " << stride;
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

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
  if (!IsTrackedCommandList(cmd_list)) return false;
  if (!trace_all && trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return false;

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
  if (!IsTrackedCommandList(cmd_list)) return false;
  if (!trace_all && trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return false;

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
  if (!IsTrackedCommandList(cmd_list)) return false;
  if (!trace_all && trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return false;

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
  if (!IsTrackedCommandList(cmd_list)) return false;

  if (!trace_all && trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return false;
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
  if (!IsTrackedCommandList(cmd_list)) return false;

  if (!trace_all && trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return false;
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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (!trace_all && trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return;
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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return;
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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return;
  std::stringstream s;
  s << "OnEndRenderPass()";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (!IsTrackedCommandList(cmd_list)) return;
  if (!trace_all && trace_running_device != cmd_list->get_device()) {
    // log trace all state
    if (trace_all) {
      reshade::log::message(reshade::log::level::info, "on_bind_render_targets_and_depth_stencil(?)");
    }
    return;
  }

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
      if (rtv.handle != 0u) {
        s << ", res: " << PRINT_PTR(GetResourceByViewHandle(data, rtv.handle));
        s << ", name: " << GetResourceNameByViewHandle(data, rtv.handle);
      }
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
  if (!IsTrackedDevice(device)) return;

  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return;

  bool warn = false;
  std::stringstream s;
  s << "utils::trace::OnInitResource(" << PRINT_PTR(resource.handle);
  s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", state: " << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
  s << ", type: " << desc.type;
  s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;

  switch (desc.type) {
    case reshade::api::resource_type::buffer:
      s << ", size: " << desc.buffer.size;
      s << ", stride: " << desc.buffer.stride;
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
  if (!IsTrackedDevice(device)) return;

  auto* data = renodx::utils::data::Get<DeviceData>(device);

  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  data->resource_names.erase(resource.handle);
  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return;

  std::stringstream s;
  s << "utils::trace::OnDestroyResource(";
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
  if (!IsTrackedDevice(device)) return;

  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return;
  std::stringstream s;
  s << "utils::trace::OnInitResourceView(" << PRINT_PTR(view.handle);
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
  if (!IsTrackedDevice(device)) return;
  if (trace_running_device != device && present_count >= trace_initial_frame_count) return;
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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (!trace_all && trace_running_device != cmd_list->get_device()) return;
  auto* device = cmd_list->get_device();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  const std::shared_lock lock(data->mutex);
  const uint32_t log_count = std::min(update.count, TRACE_DESCRIPTOR_LOG_LIMIT);
  for (uint32_t i = 0; i < log_count; i++) {
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
        if (item.view.handle != 0u) {
          s << ", res: " << PRINT_PTR(GetResourceByViewHandle(data, item.view.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
        }
        break;
      }
      case reshade::api::descriptor_type::texture_shader_resource_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:  {
        s << log_heap();
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", shaderrsv: " << PRINT_PTR(item.handle);
        if (item.handle != 0u) {
          s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        }
        break;
      }
      case reshade::api::descriptor_type::texture_unordered_access_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:  {
        s << log_heap();
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        s << ", uav: " << PRINT_PTR(item.handle);
        if (item.handle != 0u) {
          s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
          // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
        }
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
  if (update.count > log_count) {
    std::stringstream s;
    s << "push_descriptors(" << PRINT_PTR(layout.handle);
    s << "[" << layout_param << "]";
    s << ", binding: " << update.binding;
    s << ", type: " << update.type;
    s << ") truncated " << (update.count - log_count) << " descriptor(s)";
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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (!trace_all && trace_running_device != cmd_list->get_device()) return;
  auto* device = cmd_list->get_device();
  if (count == 0 && layout.handle == 0u) {
    reshade::log::message(reshade::log::level::info, "bind_descriptor_table(empty)");
    return;
  }

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
  }

  pipeline_layout::GetPipelineLayoutData(layout, [&](const auto& local_layout_data) {
    const auto& layout_data = *local_layout_data;

    for (uint32_t i = 0; i < count; ++i) {
      auto layout_index = first + i;
      if (layout_index >= layout_data.params.size()) continue;

      const auto& param = layout_data.params.at(layout_index);

      uint32_t descriptor_table_count = 0;
      const reshade::api::descriptor_range* descriptor_table_ranges = nullptr;
      switch (param.type) {
        case reshade::api::pipeline_layout_param_type::descriptor_table:
          descriptor_table_count = param.descriptor_table.count;
          descriptor_table_ranges = param.descriptor_table.ranges;
          break;
        case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
          descriptor_table_count = param.descriptor_table_with_static_samplers.count;
          descriptor_table_ranges = param.descriptor_table_with_static_samplers.ranges;
          break;
        default:
          continue;
      }

      for (uint32_t k = 0; k < descriptor_table_count; ++k) {
        const auto& range = descriptor_table_ranges[k];

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

        const uint32_t log_count = std::min(range.count, TRACE_DESCRIPTOR_LOG_LIMIT);
        auto heap_pair = descriptor_data->heaps.find(heap.handle);
        if (heap_pair == descriptor_data->heaps.end()) continue;
        const auto& heap_data = heap_pair->second;
        for (uint32_t j = 0; j < log_count; ++j) {
          auto offset = base_offset + j;
          if (offset >= heap_data.size()) continue;
          const auto& descriptor = heap_data[offset];
          if (!descriptor.HasResourceView()) continue;

          auto resource_view = descriptor.resource_view;
          bool is_uav = false;
          switch (descriptor.type) {
            case reshade::api::descriptor_type::sampler_with_resource_view:
              break;
            case reshade::api::descriptor_type::buffer_unordered_access_view:
            case reshade::api::descriptor_type::texture_unordered_access_view:
              is_uav = true;
              // fallthrough
            case reshade::api::descriptor_type::buffer_shader_resource_view:
            case reshade::api::descriptor_type::texture_shader_resource_view:
              break;
            case reshade::api::descriptor_type::constant_buffer:
            case reshade::api::descriptor_type::shader_storage_buffer:
            case reshade::api::descriptor_type::acceleration_structure:
              break;
            default:
              break;
          }

          std::stringstream s;
          s << "bind_descriptor_table(" << PRINT_PTR(layout.handle);
          s << "[" << layout_index << "]";
          s << ", rsv: " << PRINT_PTR(resource_view.handle);
          if (resource_view.handle != 0u) {
            auto* data = renodx::utils::data::Get<DeviceData>(device);
            const std::shared_lock lock(data->mutex);
            s << ", res: " << PRINT_PTR(GetResourceByViewHandle(data, resource_view.handle));
          }
          s << ", param: " << param.type;
          switch (device->get_api()) {
            case reshade::api::device_api::d3d9:
            case reshade::api::device_api::d3d10:
            case reshade::api::device_api::d3d11:
            case reshade::api::device_api::d3d12:
              s << ", dx_index: " << (range.dx_register_index + j);
              s << ", dx_space: " << range.dx_register_space;
              break;
            case reshade::api::device_api::opengl:
            case reshade::api::device_api::vulkan: {
              const auto effective_array_size = std::max(range.array_size, 1u);
              uint32_t slot_binding = range.binding;
              uint32_t slot_array_index = 0u;
              if (j < effective_array_size) {
                slot_array_index = j;
              } else {
                slot_binding += 1u + (j - effective_array_size);
              }
              s << ", binding: " << slot_binding;
              s << ", array_index: " << slot_array_index;
              break;
            }
            default:
              break;
          }
          s << ", j: " << j;
          s << ")";
          reshade::log::message(reshade::log::level::info, s.str().c_str());
        }
        if (range.count > log_count) {
          std::stringstream s;
          s << "bind_descriptor_table(" << PRINT_PTR(layout.handle);
          s << "[" << layout_index << "]";
          s << ", table: " << PRINT_PTR(tables[i].handle);
          switch (device->get_api()) {
            case reshade::api::device_api::d3d9:
            case reshade::api::device_api::d3d10:
            case reshade::api::device_api::d3d11:
            case reshade::api::device_api::d3d12:
              s << ", dx_index: " << range.dx_register_index;
              s << ", dx_space: " << range.dx_register_space;
              break;
            case reshade::api::device_api::opengl:
            case reshade::api::device_api::vulkan:
              s << ", binding: " << range.binding;
              s << ", array_index: 0";
              break;
            default:
              break;
          }
          s << ") truncated " << (range.count - log_count) << " descriptor(s)";
          reshade::log::message(reshade::log::level::info, s.str().c_str());
        }
      }
    }
  });
}

static bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (!IsTrackedDevice(device)) return false;
  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return false;

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

    const uint32_t log_count = std::min(copy.count, TRACE_DESCRIPTOR_LOG_LIMIT);
    for (uint32_t j = 0; j < log_count; j++) {
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
    if (copy.count > log_count) {
      std::stringstream s;
      s << "copy_descriptor_tables(";
      s << PRINT_PTR(copy.source_table.handle);
      s << "[" << copy.source_binding << "]";
      s << "[" << copy.source_array_offset << "]";
      s << " => ";
      s << PRINT_PTR(copy.dest_table.handle);
      s << "[" << copy.dest_binding << "]";
      s << "[" << copy.dest_array_offset << "]";
      s << ") truncated " << (copy.count - log_count) << " descriptor(s)";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }

  return false;
}

static bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (!IsTrackedDevice(device)) return false;

  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return false;

  for (uint32_t i = 0; i < count; i++) {
    const auto& update = updates[i];

    const uint32_t log_count = std::min(update.count, TRACE_DESCRIPTOR_LOG_LIMIT);
    for (uint32_t j = 0; j < log_count; j++) {
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
          if (item.view.handle != 0u) {
            auto* data = renodx::utils::data::Get<DeviceData>(device);
            const std::shared_lock lock(data->mutex);
            s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.view.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          }
          break;
        }
        case reshade::api::descriptor_type::buffer_shader_resource_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", b-srv: " << PRINT_PTR(item.handle);
          if (item.handle != 0u) {
            auto* data = renodx::utils::data::Get<DeviceData>(device);
            const std::shared_lock lock(data->mutex);
            s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          }
          break;
        }
        case reshade::api::descriptor_type::buffer_unordered_access_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", b-uav: " << PRINT_PTR(item.handle);
          if (item.handle != 0u) {
            auto* data = renodx::utils::data::Get<DeviceData>(device);
            const std::shared_lock lock(data->mutex);
            s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.view.handle);
          }
          break;
        }
        case reshade::api::descriptor_type::texture_shader_resource_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", srv: " << PRINT_PTR(item.handle);
          if (item.handle != 0u) {
            auto* data = renodx::utils::data::Get<DeviceData>(device);
            const std::shared_lock lock(data->mutex);
            s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          }
          break;
        }
        case reshade::api::descriptor_type::texture_unordered_access_view: {
          auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          s << ", uav: " << PRINT_PTR(item.handle);
          if (item.handle != 0u) {
            auto* data = renodx::utils::data::Get<DeviceData>(device);
            const std::shared_lock lock(data->mutex);
            s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
            // s << ", name: " << getResourceNameByViewHandle(data, item.handle);
          }
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
          if (item.handle != 0u) {
            auto* data = renodx::utils::data::Get<DeviceData>(device);
            const std::shared_lock lock(data->mutex);
            s << ", res:" << PRINT_PTR(GetResourceByViewHandle(data, item.handle));
          }
          break;
        }
        default:
          break;
      }
      s << ") [" << i << "]";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
    if (update.count > log_count) {
      std::stringstream s;
      s << "update_descriptor_tables(";
      s << PRINT_PTR(update.table.handle);
      s << "[" << update.binding << "]";
      s << ", type: " << update.type;
      s << ") truncated " << (update.count - log_count) << " descriptor(s)";
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
  if (!IsTrackedCommandList(cmd_list)) return false;

  if (!trace_all && trace_running_device != cmd_list->get_device()) return false;
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
  if (!IsTrackedCommandList(cmd_list)) return false;

  if (!trace_all && trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return false;
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
  if (!IsTrackedCommandList(cmd_list)) return false;

  if (!trace_all && trace_running_device != cmd_list->get_device() && present_count >= trace_initial_frame_count) return false;
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
  if (!IsTrackedDevice(device)) return;
  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return;
  std::stringstream s;
  s << "map_buffer_region(";
  s << PRINT_PTR(resource.handle);
  s << ")";

  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnUnmapBufferRegion(
    reshade::api::device* device,
    reshade::api::resource resource) {
  if (!IsTrackedDevice(device)) return;
  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return;

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
  if (!IsTrackedDevice(device)) return;
  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return;
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
  if (!IsTrackedDevice(device)) return false;
  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return false;
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
  if (!IsTrackedDevice(device)) return false;
  if (!trace_all && trace_running_device != device && present_count >= trace_initial_frame_count) return false;
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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (trace_running_device != cmd_list->get_device()) return;

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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (trace_running_device != cmd_list->get_device()) return;

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
  if (!IsTrackedCommandList(cmd_list)) return;
  if (trace_running_device != cmd_list->get_device()) return;

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
  if (!IsTrackedDevice(queue->get_device())) return;
  if (trace_all || trace_running_device == queue->get_device()) {
    std::stringstream s;
    s << "present(";
    s << PRINT_PTR(swapchain->get_current_back_buffer().handle);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());

    reshade::log::message(reshade::log::level::info, "--- End Frame ---");
    trace_running_device = nullptr;
  } else if (trace_scheduled_device == queue->get_device()) {
    trace_scheduled_device = nullptr;
    trace_running_device = queue->get_device();
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
      internal::shared.RegisterModule();
      internal::shared.RegisterEvent<reshade::addon_event::init_device>(internal::OnInitDevice);
      internal::shared.RegisterEvent<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      // init_command_list
      // destroy_command_list
      // init_command_queue
      // destroy_command_queue
      internal::shared.RegisterEvent<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      // create_swapchain
      internal::shared.RegisterEvent<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      // init_effect_runtime
      // destroy_effect_runtime
      // init_sampler
      // create_sampler
      // destroy_sampler
      internal::shared.RegisterEvent<reshade::addon_event::init_resource>(internal::OnInitResource);
      // create_resource
      internal::shared.RegisterEvent<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
      internal::shared.RegisterEvent<reshade::addon_event::init_resource_view>(internal::OnInitResourceView);
      // create_resource_view
      internal::shared.RegisterEvent<reshade::addon_event::destroy_resource_view>(internal::OnDestroyResourceView);
      internal::shared.RegisterEvent<reshade::addon_event::map_buffer_region>(internal::OnMapBufferRegion);
      internal::shared.RegisterEvent<reshade::addon_event::unmap_buffer_region>(internal::OnUnmapBufferRegion);

      internal::shared.RegisterEvent<reshade::addon_event::map_texture_region>(internal::OnMapTextureRegion);
      // unmap_texture_region
      internal::shared.RegisterEvent<reshade::addon_event::update_buffer_region>(internal::OnUpdateBufferRegion);
      internal::shared.RegisterEvent<reshade::addon_event::update_texture_region>(internal::OnUpdateTextureRegion);
      internal::shared.RegisterEvent<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
      internal::shared.RegisterEvent<reshade::addon_event::create_pipeline>(internal::OnCreatePipeline);
      internal::shared.RegisterEvent<reshade::addon_event::destroy_pipeline>(internal::OnDestroyPipeline);
      internal::shared.RegisterEvent<reshade::addon_event::init_pipeline_layout>(internal::OnInitPipelineLayout);
      internal::shared.RegisterEvent<reshade::addon_event::create_pipeline_layout>(internal::OnCreatePipelineLayout);
      // destroy_pipeline_layout
      internal::shared.RegisterEvent<reshade::addon_event::copy_descriptor_tables>(internal::OnCopyDescriptorTables);
      internal::shared.RegisterEvent<reshade::addon_event::update_descriptor_tables>(internal::OnUpdateDescriptorTables);
      // init_query_heap
      // create_query_heap
      // destroy_query_heap
      // get_query_heap_results
      internal::shared.RegisterEvent<reshade::addon_event::barrier>(internal::OnBarrier);
      internal::shared.RegisterEvent<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
      internal::shared.RegisterEvent<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
      internal::shared.RegisterEvent<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);
      internal::shared.RegisterEvent<reshade::addon_event::bind_pipeline>(internal::OnBindPipeline);
      internal::shared.RegisterEvent<reshade::addon_event::bind_pipeline_states>(internal::OnBindPipelineStates);
      internal::shared.RegisterEvent<reshade::addon_event::bind_viewports>(internal::OnBindViewports);
      internal::shared.RegisterEvent<reshade::addon_event::bind_scissor_rects>(internal::OnBindScissorRects);
      internal::shared.RegisterEvent<reshade::addon_event::push_constants>(internal::OnPushConstants);
      internal::shared.RegisterEvent<reshade::addon_event::push_descriptors>(internal::OnPushDescriptors);
      internal::shared.RegisterEvent<reshade::addon_event::bind_descriptor_tables>(internal::OnBindDescriptorTables);
      // bind_index_buffer
      // bind_vertex_buffers
      // bind_stream_output_buffers
      internal::shared.RegisterEvent<reshade::addon_event::draw>(internal::OnDraw);
      internal::shared.RegisterEvent<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed);
      internal::shared.RegisterEvent<reshade::addon_event::dispatch>(internal::OnDispatch);
      // dispatch_mesh
      // dispatch_rays
      internal::shared.RegisterEvent<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect);
      internal::shared.RegisterEvent<reshade::addon_event::copy_resource>(internal::OnCopyResource);
      // copy_buffer_region
      internal::shared.RegisterEvent<reshade::addon_event::copy_buffer_to_texture>(internal::OnCopyBufferToTexture);
      internal::shared.RegisterEvent<reshade::addon_event::copy_texture_region>(internal::OnCopyTextureRegion);
      internal::shared.RegisterEvent<reshade::addon_event::copy_texture_to_buffer>(internal::OnCopyTextureToBuffer);
      internal::shared.RegisterEvent<reshade::addon_event::resolve_texture_region>(internal::OnResolveTextureRegion);
      internal::shared.RegisterEvent<reshade::addon_event::clear_depth_stencil_view>(internal::OnClearDepthStencilView);
      internal::shared.RegisterEvent<reshade::addon_event::clear_render_target_view>(internal::OnClearRenderTargetView);
      internal::shared.RegisterEvent<reshade::addon_event::clear_unordered_access_view_uint>(internal::OnClearUnorderedAccessViewUint);
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
      internal::shared.RegisterEvent<reshade::addon_event::present>(internal::OnPresent);
      // set_fullscreen_state

      break;
    case DLL_PROCESS_DETACH:
      internal::shared.UnregisterEvent<reshade::addon_event::init_device>(internal::OnInitDevice);
      internal::shared.UnregisterEvent<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      // init_command_list
      // destroy_command_list
      // init_command_queue
      // destroy_command_queue
      internal::shared.UnregisterEvent<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      // create_swapchain
      internal::shared.UnregisterEvent<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      // init_effect_runtime
      // destroy_effect_runtime
      // init_sampler
      // create_sampler
      // destroy_sampler
      internal::shared.UnregisterEvent<reshade::addon_event::init_resource>(internal::OnInitResource);
      // create_resource
      internal::shared.UnregisterEvent<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
      internal::shared.UnregisterEvent<reshade::addon_event::init_resource_view>(internal::OnInitResourceView);
      // create_resource_view
      internal::shared.UnregisterEvent<reshade::addon_event::destroy_resource_view>(internal::OnDestroyResourceView);
      internal::shared.UnregisterEvent<reshade::addon_event::map_buffer_region>(internal::OnMapBufferRegion);
      internal::shared.UnregisterEvent<reshade::addon_event::unmap_buffer_region>(internal::OnUnmapBufferRegion);
      internal::shared.UnregisterEvent<reshade::addon_event::map_texture_region>(internal::OnMapTextureRegion);
      // unmap_texture_region
      internal::shared.UnregisterEvent<reshade::addon_event::update_buffer_region>(internal::OnUpdateBufferRegion);
      internal::shared.UnregisterEvent<reshade::addon_event::update_texture_region>(internal::OnUpdateTextureRegion);
      internal::shared.UnregisterEvent<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
      internal::shared.UnregisterEvent<reshade::addon_event::create_pipeline>(internal::OnCreatePipeline);
      internal::shared.UnregisterEvent<reshade::addon_event::destroy_pipeline>(internal::OnDestroyPipeline);
      internal::shared.UnregisterEvent<reshade::addon_event::init_pipeline_layout>(internal::OnInitPipelineLayout);
      internal::shared.UnregisterEvent<reshade::addon_event::create_pipeline_layout>(internal::OnCreatePipelineLayout);
      // destroy_pipeline_layout
      internal::shared.UnregisterEvent<reshade::addon_event::copy_descriptor_tables>(internal::OnCopyDescriptorTables);
      internal::shared.UnregisterEvent<reshade::addon_event::update_descriptor_tables>(internal::OnUpdateDescriptorTables);
      // init_query_heap
      // create_query_heap
      // destroy_query_heap
      // get_query_heap_results
      internal::shared.UnregisterEvent<reshade::addon_event::barrier>(internal::OnBarrier);
      internal::shared.UnregisterEvent<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
      internal::shared.UnregisterEvent<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
      internal::shared.UnregisterEvent<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);
      internal::shared.UnregisterEvent<reshade::addon_event::bind_pipeline>(internal::OnBindPipeline);
      internal::shared.UnregisterEvent<reshade::addon_event::bind_pipeline_states>(internal::OnBindPipelineStates);
      internal::shared.UnregisterEvent<reshade::addon_event::bind_viewports>(internal::OnBindViewports);
      internal::shared.UnregisterEvent<reshade::addon_event::bind_scissor_rects>(internal::OnBindScissorRects);
      internal::shared.UnregisterEvent<reshade::addon_event::push_constants>(internal::OnPushConstants);
      internal::shared.UnregisterEvent<reshade::addon_event::push_descriptors>(internal::OnPushDescriptors);
      internal::shared.UnregisterEvent<reshade::addon_event::bind_descriptor_tables>(internal::OnBindDescriptorTables);
      // bind_index_buffer
      // bind_vertex_buffers
      // bind_stream_output_buffers
      internal::shared.UnregisterEvent<reshade::addon_event::draw>(internal::OnDraw);
      internal::shared.UnregisterEvent<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed);
      internal::shared.UnregisterEvent<reshade::addon_event::dispatch>(internal::OnDispatch);
      // dispatch_mesh
      // dispatch_rays
      internal::shared.UnregisterEvent<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect);
      internal::shared.UnregisterEvent<reshade::addon_event::copy_resource>(internal::OnCopyResource);
      // copy_buffer_region
      internal::shared.UnregisterEvent<reshade::addon_event::copy_buffer_to_texture>(internal::OnCopyBufferToTexture);
      internal::shared.UnregisterEvent<reshade::addon_event::copy_texture_region>(internal::OnCopyTextureRegion);
      internal::shared.UnregisterEvent<reshade::addon_event::copy_texture_to_buffer>(internal::OnCopyTextureToBuffer);
      internal::shared.UnregisterEvent<reshade::addon_event::resolve_texture_region>(internal::OnResolveTextureRegion);
      internal::shared.UnregisterEvent<reshade::addon_event::clear_depth_stencil_view>(internal::OnClearDepthStencilView);
      internal::shared.UnregisterEvent<reshade::addon_event::clear_render_target_view>(internal::OnClearRenderTargetView);
      internal::shared.UnregisterEvent<reshade::addon_event::clear_unordered_access_view_uint>(internal::OnClearUnorderedAccessViewUint);
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
      internal::shared.UnregisterEvent<reshade::addon_event::present>(internal::OnPresent);
      // set_fullscreen_state
      internal::shared.UnregisterModule();
      break;
  }
}
}  // namespace renodx::utils::trace
