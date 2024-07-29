/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

// #define DEBUG_LEVEL_1

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <cstdint>
#include <cstdio>

#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "../utils/format.hpp"
#include "../utils/mutex.hpp"
#include "../utils/resource.hpp"
#include "../utils/shader.hpp"
#include "../utils/swapchain.hpp"

namespace renodx::mods::shader {
struct CustomShader {
  uint32_t crc32;
  std::vector<uint8_t> code;
  bool swap_chain_only;
  int32_t index = -1;
};

using CustomShaders = std::unordered_map<uint32_t, CustomShader>;

// clang-format off
#define CustomSwapchainShader(crc32) { crc32, { crc32, std::vector<uint8_t>(_##crc32, _##crc32 + sizeof(_##crc32)), true } }
#define CustomShaderEntry(crc32) { crc32, { crc32, std::vector<uint8_t>(_##crc32, _##crc32 + sizeof(_##crc32)) } }
#define BypassShaderEntry(crc32) { crc32, { crc32, std::vector<uint8_t>(0) } }
#define CustomCountedShader(crc32, index) { crc32, { crc32, std::vector<uint8_t>(_##crc32, _##crc32 + sizeof(_##crc32)), false, ##index} }
// clang-format on

static thread_local std::vector<reshade::api::pipeline_layout_param*> created_params;

static float* shader_injection = nullptr;
static size_t shader_injection_size = 0;
static bool use_pipeline_layout_cloning = false;
static bool force_pipeline_cloning = false;
static bool trace_unmodified_shaders = false;
static bool allow_multiple_push_constants = false;
static float* resource_tag_float = nullptr;
static int32_t expected_constant_buffer_index = -1;
static uint32_t expected_constant_buffer_space = 0;

static CustomShaders custom_shaders;

static bool using_swap_chain_only = false;
static bool using_bypass = false;
static bool using_counted_shaders = false;

struct __declspec(uuid("018e7b9c-23fd-7863-baf8-a8dad2a6db9d")) DeviceData {
  std::unordered_map<uint64_t, int32_t> modded_pipeline_root_indexes;
  std::unordered_map<uint64_t, reshade::api::pipeline_layout> modded_pipeline_layouts;
  std::unordered_set<uint32_t> unmodified_shaders;
  std::unordered_set<uint64_t> back_buffers;
  std::unordered_set<uint64_t> back_buffer_resource_views;
  std::unordered_map<uint32_t, uint32_t> counted_shaders;
  bool use_pipeline_layout_cloning = false;
  // bool force_pipeline_cloning = false;
  bool trace_unmodified_shaders = false;
  int32_t expected_constant_buffer_index = -1;
  uint32_t expected_constant_buffer_space = 0;
  std::shared_mutex mutex;

  CustomShaders custom_shaders;
};

static void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::shader::OnInitDevice(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  auto& data = device->create_private_data<DeviceData>();
  data.use_pipeline_layout_cloning = use_pipeline_layout_cloning;
  data.trace_unmodified_shaders = trace_unmodified_shaders;
  data.expected_constant_buffer_index = expected_constant_buffer_index;
  data.expected_constant_buffer_space = expected_constant_buffer_space;
  data.custom_shaders = custom_shaders;
}

static void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::shader::OnDestroyDevice(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

// Shader Injection
static bool OnCreatePipelineLayout(
    reshade::api::device* device,
    uint32_t& param_count,
    reshade::api::pipeline_layout_param*& params) {
  uint32_t cbv_index = 0;
  uint32_t pc_count = 0;
  if (param_count == -1) {
    std::stringstream s;
    s << "mods::shader::OnCreatePipelineLayout(";
    s << "Wrong param count: " << param_count;
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
    return false;
  }

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    auto param = params[param_index];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
        auto range = param.descriptor_table.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (
              range.dx_register_space == data.expected_constant_buffer_space
              && cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      pc_count++;
      if (
          param.push_constants.dx_register_space == data.expected_constant_buffer_space
          && cbv_index < param.push_constants.dx_register_index + param.push_constants.count) {
        cbv_index = param.push_constants.dx_register_index + param.push_constants.count;
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        if (
            param.push_descriptors.dx_register_space == data.expected_constant_buffer_space
            && cbv_index < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
          cbv_index = param.push_descriptors.dx_register_index + param.push_descriptors.count;
        }
      }
#if RESHADE_API_VERSION >= 13
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers) {
      for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
        auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
        if (range.static_samplers != nullptr) {
          if (range.type == reshade::api::descriptor_type::constant_buffer) {
            if (
                range.dx_register_space == data.expected_constant_buffer_space
                && cbv_index < range.dx_register_index + range.count) {
              cbv_index = range.dx_register_index + range.count;
            }
          }
        }
      }
#endif
    }
  }

  if (data.expected_constant_buffer_index != -1 && cbv_index != data.expected_constant_buffer_index) {
    std::stringstream s;
    s << "mods::shader::OnCreatePipelineLayout(";
    s << "Pipeline layout index mismatch, actual: " << cbv_index;
    s << ", expected: " << data.expected_constant_buffer_index;
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
    return false;
  }

  if (pc_count != 0 && !allow_multiple_push_constants) {
    std::stringstream s;
    s << "mods::shader::OnCreatePipelineLayout(";
    s << "Pipeline layout already has push constants: " << pc_count;
    s << " with cbvIndex: " << cbv_index;
    s << ")";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
    return false;
  }

  const uint32_t old_count = param_count;
  const uint32_t new_count = old_count + 1;
  auto* new_params = reinterpret_cast<reshade::api::pipeline_layout_param*>(malloc(sizeof(reshade::api::pipeline_layout_param) * new_count));

  // Store reference to free later
  created_params.push_back(new_params);

  // Copy up to size of old
  memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * old_count);

  // Fill in extra param
  const uint32_t slots = shader_injection_size;
  const uint32_t max_count = 64u - (old_count + 1u) + 1u;

  new_params[old_count] = reshade::api::pipeline_layout_param(
      reshade::api::constant_range{
          .binding = 0,
          .dx_register_index = cbv_index,
          .dx_register_space = data.expected_constant_buffer_space,
          .count = (slots > max_count) ? max_count : slots,
          .visibility = reshade::api::shader_stage::all,
      });

  param_count = new_count;
  params = new_params;

  if (slots > max_count) {
    std::stringstream s;
    s << "mods::shader::OnCreatePipelineLayout(";
    s << "shader injection oversized: ";
    s << slots << "/" << max_count;
    s << " )";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
  }

  std::stringstream s;
  s << "mods::shader::OnCreatePipelineLayout(";
  s << "will insert cbuffer " << cbv_index;
  s << " at root_index " << old_count;
  s << " with slot count " << slots;
  s << " creating new size of " << (old_count + 1u + slots);
  s << ", newParams: " << reinterpret_cast<void*>(new_params);
  s << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  return true;
}

// AfterCreateRootSignature
static void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  int32_t injection_index = -1;
  auto device_api = device->get_api();
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  uint32_t cbv_index = 0;
  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    auto param = params[param_index];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
        auto range = param.descriptor_table.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (
              range.dx_register_space == data.expected_constant_buffer_space
              && cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      if (
          param.push_constants.dx_register_space == data.expected_constant_buffer_space
          && cbv_index < param.push_constants.dx_register_index + param.push_constants.count) {
        cbv_index = param.push_constants.dx_register_index + param.push_constants.count;
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        if (
            param.push_descriptors.dx_register_space == data.expected_constant_buffer_space
            && cbv_index < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
          cbv_index = param.push_descriptors.dx_register_index + param.push_descriptors.count;
        }
      }
#if RESHADE_API_VERSION >= 13
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers) {
      for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
        auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
        if (range.static_samplers != nullptr) {
          if (range.type == reshade::api::descriptor_type::constant_buffer) {
            if (
                range.dx_register_space == data.expected_constant_buffer_space
                && cbv_index < range.dx_register_index + range.count) {
              cbv_index = range.dx_register_index + range.count;
            }
          }
        }
      }
#endif
    }
  }

  if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
    if (data.use_pipeline_layout_cloning) {
      const uint32_t old_count = param_count;
      uint32_t new_count = old_count;
      reshade::api::pipeline_layout_param* new_params = nullptr;
      if (shader_injection_size != 0u) {
        new_count = old_count + 1;
        new_params = reinterpret_cast<reshade::api::pipeline_layout_param*>(malloc(sizeof(reshade::api::pipeline_layout_param) * new_count));
        // Copy up to size of old
        memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * old_count);

        // Fill in extra param
        const uint32_t slots = shader_injection_size;
        const uint32_t max_count = 64u - (old_count + 1u) + 1u;

        new_params[old_count] = reshade::api::pipeline_layout_param(
            reshade::api::constant_range{
                .binding = 0,
                .dx_register_index = cbv_index,
                .dx_register_space = data.expected_constant_buffer_space,
                .count = (slots > max_count) ? max_count : slots,
                .visibility = reshade::api::shader_stage::all,
            });

        injection_index = param_count - 1;

        if (slots > max_count) {
          std::stringstream s;
          s << "mods::shader::OnInitPipelineLayout(";
          s << reinterpret_cast<void*>(layout.handle);
          s << "shader injection oversized: ";
          s << slots << "/" << max_count;
          s << " )";
          reshade::log_message(reshade::log_level::warning, s.str().c_str());
          free(new_params);
          new_params = nullptr;
          return;
        }
      } else {
        new_params = reinterpret_cast<reshade::api::pipeline_layout_param*>(malloc(sizeof(reshade::api::pipeline_layout_param) * old_count));
        memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * old_count);
      }

      reshade::api::pipeline_layout new_layout;
      auto result = device->create_pipeline_layout(new_count, &new_params[0], &new_layout);
      free(new_params);
      new_params = nullptr;
      std::stringstream s;
      s << "mods::shader::OnInitPipelineLayout(Cloning D3D12 Layout ";
      s << reinterpret_cast<void*>(layout.handle);
      s << " => ";
      s << reinterpret_cast<void*>(new_layout.handle);
      s << ", cbvIndex: " << cbv_index;
      s << ", param_index: " << injection_index;
      s << ", slots : " << shader_injection_size;
      s << ": " << (result ? "OK" : "FAILED");
      s << ")";
      reshade::log_message(result ? reshade::log_level::info : reshade::log_level::error, s.str().c_str());
      data.modded_pipeline_layouts[layout.handle] = new_layout;
    } else {
      if (created_params.empty()) {
        // No injected params
        std::stringstream s;
        s << "mods::shader::OnInitPipelineLayout(";
        s << "Params not created for: ";
        s << reinterpret_cast<void*>(layout.handle);
        s << ")";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        return;
      };

      for (reshade::api::pipeline_layout_param* injected_params : created_params) {
        free(injected_params);
      }

      created_params.clear();

      if (param_count > 0) {
        if (params[param_count - 1].type == reshade::api::pipeline_layout_param_type::push_constants) {
          injection_index = param_count - 1;
        }
      }
      if (injection_index == -1) {
        std::stringstream s;
        s << "mods::shader::OnInitPipelineLayout(";
        s << "Injection index not found for ";
        s << reinterpret_cast<void*>(layout.handle);
        s << " )";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        return;
      }
    }

  } else {
    if (data.expected_constant_buffer_index != -1 && cbv_index != data.expected_constant_buffer_index) {
      std::stringstream s;
      s << "mods::shader::OnInitPipelineLayout(";
      s << "Forcing cbuffer index ";
      s << reinterpret_cast<void*>(layout.handle);
      s << ": " << cbv_index;
      s << " )";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      cbv_index = data.expected_constant_buffer_index;
    }
    if (cbv_index == 14) {
      cbv_index = 13;
      std::stringstream s;
      s << "mods::shader::OnInitPipelineLayout(";
      s << "Using last slot for buffer injection ";
      s << reinterpret_cast<void*>(layout.handle);
      s << ": " << cbv_index;
      s << " )";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
    }

    // device->create_pipeline_layout(1)

    reshade::api::pipeline_layout_param new_params;
    new_params.type = reshade::api::pipeline_layout_param_type::push_constants;
    // newParams.push_constants.binding = 0;
    new_params.push_constants.count = 1;
    new_params.push_constants.dx_register_index = cbv_index;
    new_params.push_constants.dx_register_space = data.expected_constant_buffer_space;
    new_params.push_constants.visibility = reshade::api::shader_stage::all;

    reshade::api::pipeline_layout new_layout;
    auto result = device->create_pipeline_layout(1, &new_params, &new_layout);
    std::stringstream s;
    s << "mods::shader::OnInitPipelineLayout(";
    s << "Creating D3D11 Layout ";
    s << reinterpret_cast<void*>(new_layout.handle);
    s << ": " << result;
    s << " )";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
    data.modded_pipeline_layouts[layout.handle] = new_layout;
    injection_index = cbv_index;
  }

  data.modded_pipeline_root_indexes[layout.handle] = injection_index;

  std::stringstream s;
  s << "mods::shader::OnInitPipelineLayout(";
  s << "Using injection index for ";
  s << reinterpret_cast<void*>(layout.handle);
  s << ": " << injection_index;
  s << ", cbvIndex:" << cbv_index;
  s << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

static void OnDestroyPipelineLayout(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout) {
  uint32_t changed = 0u;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  changed |= data.modded_pipeline_root_indexes.erase(layout.handle);
  if (changed == 0u) return;

  std::stringstream s;
  s << "mods::shader::OnDestroyPipelineLayout(";
  s << reinterpret_cast<void*>(layout.handle);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

inline void OnPushConstants(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    uint32_t first,
    uint32_t count,
    const void* values) {
  auto& data = cmd_list->get_device()->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  auto pair = data.modded_pipeline_layouts.find(layout.handle);
  if (pair == data.modded_pipeline_layouts.end()) return;
  auto cloned_layout = pair->second;

#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::shader::OnPushConstants(clone push ";
  s << reinterpret_cast<void*>(layout.handle);
  s << " => " << reinterpret_cast<void*>(cloned_layout.handle);
  s << ", param: " << layout_param;
  s << ", first: " << first;
  s << ", count: " << count;
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif

  cmd_list->push_constants(stages, cloned_layout, layout_param, first, count, values);
}

inline void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  auto& data = cmd_list->get_device()->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  auto pair = data.modded_pipeline_layouts.find(layout.handle);
  if (pair == data.modded_pipeline_layouts.end()) return;
  auto cloned_layout = pair->second;

#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::shader::OnPushDescriptors(clone push " << reinterpret_cast<void*>(layout.handle);
  s << " => " << reinterpret_cast<void*>(cloned_layout.handle);
  s << ", param: " << layout_param;
  s << ", table: " << reinterpret_cast<void*>(update.table.handle);
  s << ", binding: " << update.binding;
  s << ", array_offset: " << update.array_offset;
  s << ", count: " << update.count;
  s << ", type: " << update.type;
  switch (update.type) {
    case reshade::api::descriptor_type::constant_buffer: {
      // NOLINTNEXTLINE(google-readability-casting)
      auto* range = (reshade::api::buffer_range*)update.descriptors;
      s << ", buffer: " << reinterpret_cast<void*>(range->buffer.handle);
      s << ", offset: " << range->offset;
      s << ", size: " << range->size;
      break;
    }
    default:
      break;
  }
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
  cmd_list->push_descriptors(stages, cloned_layout, layout_param, update);
}

inline void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  auto& data = cmd_list->get_device()->get_private_data<DeviceData>();
  auto pair = data.modded_pipeline_layouts.find(layout.handle);
  if (pair == data.modded_pipeline_layouts.end()) return;
  auto cloned_layout = pair->second;

  for (uint32_t i = 0; i < count; ++i) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::shader::OnBindDescriptorTables(clone bind " << reinterpret_cast<void*>(layout.handle);
    s << " => " << reinterpret_cast<void*>(cloned_layout.handle);
    s << ", stages: 0x" << std::hex << static_cast<uint32_t>(stages) << std::dec << " (" << stages << ")";
    s << ", param: " << first + i;
    s << ", table: " << reinterpret_cast<void*>(tables[i].handle);
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
    cmd_list->bind_descriptor_table(stages, cloned_layout, (first + i), tables[i]);
  }
}

static bool HandlePreDraw(reshade::api::command_list* cmd_list, bool is_dispatch = false) {
  auto* device = cmd_list->get_device();
  auto& device_data = device->get_private_data<DeviceData>();
  const std::unique_lock local_device_lock(device_data.mutex);

  auto& shader_state = renodx::utils::shader::GetCurrentState(cmd_list);

  float resource_tag = -1;

  if (!is_dispatch && resource_tag_float != nullptr) {
    auto& swapchain_state = cmd_list->get_private_data<renodx::utils::swapchain::CommandListData>();
    if (!swapchain_state.current_render_targets.empty()) {
      auto rv = swapchain_state.current_render_targets.at(0);
      resource_tag = renodx::utils::resource::GetResourceTag(device, rv);
    }
  }

  const uint32_t shader_hash = is_dispatch ? shader_state.GetCurrentComputeShaderHash()
                                           : shader_state.GetCurrentPixelShaderHash();

  auto custom_shader_info_pair = device_data.custom_shaders.find(shader_hash);
  if (custom_shader_info_pair == device_data.custom_shaders.end()) {
    // Unrecognized shader

    if (
        !is_dispatch
        && device_data.trace_unmodified_shaders
        && renodx::utils::swapchain::HasBackBufferRenderTarget(cmd_list)
        && !device_data.unmodified_shaders.contains(shader_hash)) {
      std::stringstream s;
      s << "mods::shader::HandlePreDraw(unmodified shader writing to swapchain: ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      device_data.unmodified_shaders.emplace(shader_hash);
    }
    return false;
  }

#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::shader::HandlePreDraw(found shader: ";
  s << PRINT_CRC32(shader_hash);
  s << ")";
  reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

  auto custom_shader_info = custom_shader_info_pair->second;

  if (custom_shader_info.swap_chain_only && !renodx::utils::swapchain::HasBackBufferRenderTarget(cmd_list)) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::shader::HandlePreDraw(aborting because swapchain only: ";
    s << PRINT_CRC32(shader_hash);
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    return false;
  }

  auto& shader_device_state = device->get_private_data<renodx::utils::shader::DeviceData>();
  const std::shared_lock shader_device_lock(shader_device_state.mutex);

  if (shader_injection_size != 0) {
    if (shader_state.pipeline_layout.handle != 0u) {
      const reshade::api::pipeline_layout layout = shader_state.pipeline_layout;
      auto injection_layout = layout;
      auto device_api = device->get_api();
      reshade::api::shader_stage stage = reshade::api::shader_stage::all_graphics;
      uint32_t param_index = 0;
      if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
        if (
            auto pair = device_data.modded_pipeline_root_indexes.find(layout.handle);
            pair != device_data.modded_pipeline_root_indexes.end()) {
          param_index = pair->second;
          stage = is_dispatch
                      ? reshade::api::shader_stage::all_compute
                      : reshade::api::shader_stage::all_graphics;
        } else {
          std::stringstream s;
          s << "mods::shader::HandlePreDraw(did not find modded pipeline root index";
          s << ", pipeline: " << reinterpret_cast<void*>(shader_state.pipeline_layout.handle);
          s << ")";
          reshade::log_message(reshade::log_level::warning, s.str().c_str());
          return false;
        }

      } else {
        // Must be done before draw
        stage = is_dispatch
                    ? reshade::api::shader_stage::compute
                    : reshade::api::shader_stage::pixel;

        if (
            auto pair = device_data.modded_pipeline_layouts.find(layout.handle);
            pair != device_data.modded_pipeline_layouts.end()) {
          injection_layout = pair->second;
        } else {
          std::stringstream s;
          s << "mods::shader::HandlePreDraw(did not find modded pipeline layout";
          s << ", pipeline: " << reinterpret_cast<void*>(shader_state.pipeline_layout.handle);
          s << ")";
          reshade::log_message(reshade::log_level::warning, s.str().c_str());
          return false;
        }
      }

#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::shader::HandlePreDraw(pushing constants: ";
      s << PRINT_CRC32(shader_hash);
      s << ", layout: " << reinterpret_cast<void*>(injection_layout.handle) << "[" << param_index << "]";
      s << ", stage: " << stage;
      s << ", resource_tag: " << resource_tag;
      s << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

      if (resource_tag_float != nullptr) {
        const std::unique_lock lock(renodx::utils::mutex::global_mutex);
        *resource_tag_float = resource_tag;
      }

      const std::shared_lock lock(renodx::utils::mutex::global_mutex);
      cmd_list->push_constants(
          stage,  // Used by reshade to specify graphics or compute
          injection_layout,
          param_index,
          0,
          shader_injection_size,
          shader_injection);
    }
  }
  return false;
}

static bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  return HandlePreDraw(cmd_list);
}

static bool OnDispatch(
    reshade::api::command_list* cmd_list,
    uint32_t group_count_x,
    uint32_t group_count_y,
    uint32_t group_count_z) {
  return HandlePreDraw(cmd_list, true);
}

static bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  return HandlePreDraw(cmd_list);
}

static bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride) {
  return HandlePreDraw(cmd_list);
}

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  auto& data = swapchain->get_device()->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.counted_shaders.clear();
}

static bool attached = false;

template <typename T = float*>
static void Use(DWORD fdw_reason, CustomShaders new_custom_shaders, T* new_injections = nullptr) {
  renodx::utils::shader::Use(fdw_reason);
  renodx::utils::swapchain::Use(fdw_reason);
  renodx::utils::resource::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log_message(reshade::log_level::info, "mods::shader attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      if (!trace_unmodified_shaders) {
        for (const auto& [hash, shader] : (new_custom_shaders)) {
          if (shader.swap_chain_only) using_swap_chain_only = true;
          if (shader.code.empty()) using_bypass = true;
          if (shader.index != -1) using_counted_shaders = true;
        }
      }

      if (using_counted_shaders) {
        reshade::register_event<reshade::addon_event::present>(OnPresent);
      }

      if (force_pipeline_cloning || use_pipeline_layout_cloning) {
        for (const auto& [hash, shader] : (new_custom_shaders)) {
          renodx::utils::shader::AddRuntimeReplacement(hash, shader.code);
        }
      } else {
        for (const auto& [hash, shader] : (new_custom_shaders)) {
          if (!shader.swap_chain_only && !shader.code.empty() && shader.index == -1) {
            renodx::utils::shader::AddCompileTimeReplacement(hash, shader.code);
          }
          // Use Runtime as fallback
          renodx::utils::shader::AddRuntimeReplacement(hash, shader.code);
        }
      }

      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);

      custom_shaders = new_custom_shaders;
      {
        std::stringstream s;
        s << "mods::shader(Attached Custom Shaders: " << custom_shaders.size();
        s << " from " << reinterpret_cast<void*>(&new_custom_shaders);
        s << " to " << reinterpret_cast<void*>(&custom_shaders);
        s << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }

      if (mods::shader::use_pipeline_layout_cloning || (new_injections != nullptr)) {
        if (new_injections != nullptr) {
          shader_injection_size = sizeof(T) / sizeof(uint32_t);
          shader_injection = reinterpret_cast<float*>(new_injections);
        }

        if (!mods::shader::use_pipeline_layout_cloning) {
          reshade::register_event<reshade::addon_event::create_pipeline_layout>(OnCreatePipelineLayout);
        }

        reshade::register_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
        reshade::register_event<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);

        if (mods::shader::use_pipeline_layout_cloning) {
          reshade::register_event<reshade::addon_event::push_constants>(OnPushConstants);
          reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
          reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
        }

        std::stringstream s;
        s << "mods::shader(Attached Injections: " << shader_injection_size;
        s << " at " << reinterpret_cast<void*>(shader_injection);
        s << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }

      break;
    case DLL_PROCESS_DETACH:

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);

      reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(OnCreatePipelineLayout);

      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline_layout>(OnDestroyPipelineLayout);

      reshade::unregister_event<reshade::addon_event::push_constants>(OnPushConstants);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);

      break;
  }
}

}  // namespace renodx::mods::shader
