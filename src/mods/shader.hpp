/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#ifndef NOMINMAX
#define NOMINMAX
#endif

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>

#include <array>
#include <cstdint>
#include <cstdio>
#include <functional>
#include <mutex>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "../utils/constants.hpp"
#include "../utils/data.hpp"
#include "../utils/format.hpp"
#include "../utils/resource.hpp"
#include "../utils/shader.hpp"
#include "../utils/swapchain.hpp"

namespace renodx::mods::shader {

namespace internal {
inline bool OnBypassShaderDraw(reshade::api::command_list* cmd_list) { return false; };
}  // namespace internal

struct CustomShader {
  std::uint32_t crc32;
  std::span<const uint8_t> code;
  int32_t index = -1;
  // return false to abort
  std::function<bool(reshade::api::command_list*)> on_replace = nullptr;
  // return false to abort
  std::function<bool(reshade::api::command_list*)> on_inject = nullptr;
  // return false to abort
  std::function<bool(reshade::api::command_list*)> on_draw = nullptr;
  std::function<void(reshade::api::command_list*)> on_drawn = nullptr;
  std::unordered_map<reshade::api::device_api, std::span<const uint8_t>> code_by_device;
};

using CustomShaders = std::unordered_map<uint32_t, CustomShader>;

template <std::size_t N>
static CustomShaders DefineCustomShaders(const std::pair<uint32_t, CustomShader> (&items)[N]) {
  CustomShaders cs;
  for (const auto& item : items) {
    if (!cs.contains(item.first)) {
      cs.emplace(item.first, item.second);
    }
  }
  return cs;
}

template <std::size_t N>
static CustomShaders DefineCustomShaders(const std::array<std::pair<uint32_t, CustomShader>, N>& items) {
  CustomShaders cs;
  for (const auto& item : items) {
    if (!cs.contains(item.first)) {
      cs.emplace(item.first, item.second);
    }
  }
  return cs;
}

static std::function<bool(reshade::api::command_list*)> invoked_custom_swapchain_shader = nullptr;

// clang-format off
#define BypassShaderEntry(__crc32__)               {__crc32__, {.crc32 = __crc32__, .on_draw = &renodx::mods::shader::internal::OnBypassShaderDraw}}
#define CustomShaderEntry(crc32)                   {crc32, {crc32, __##crc32}}
#define CustomCountedShader(crc32, index)          {crc32, {crc32, __##crc32, ##index}}
#define CustomSwapchainShader(crc32)               {crc32, {crc32, __##crc32, -1, renodx::mods::shader::invoked_custom_swapchain_shader = &renodx::utils::swapchain::HasBackBufferRenderTarget}}
#define CustomShaderEntryCallback(crc32, callback) {crc32, {crc32, __##crc32, -1, callback}}
// clang-format on
#define RENODX_JOIN_MACRO(x, y) x##y
#define CustomDirectXShaders(__crc32__)                                               \
  {                                                                                   \
    __crc32__, {                                                                      \
      .crc32 = __crc32__,                                                             \
      .code_by_device = {                                                             \
          {reshade::api::device_api::d3d11, RENODX_JOIN_MACRO(__##__crc32__, _dx11)}, \
          {reshade::api::device_api::d3d12, RENODX_JOIN_MACRO(__##__crc32__, _dx12)}, \
      },                                                                              \
    }                                                                                 \
  }

static thread_local std::vector<reshade::api::pipeline_layout_param*> created_params;
static thread_local std::unordered_map<uint32_t, reshade::api::pipeline_layout_param*> rebuilt_params;

static float* shader_injection = nullptr;
static size_t shader_injection_size = 0;
static bool use_pipeline_layout_cloning = false;
static bool manual_shader_scheduling = false;
static bool force_pipeline_cloning = false;
static bool trace_unmodified_shaders = false;
static bool allow_multiple_push_constants = false;
static bool push_injections_on_present = false;
static bool revert_constant_buffer_ranges = false;
static float* resource_tag_float = nullptr;
static int32_t expected_constant_buffer_index = -1;
static uint32_t expected_constant_buffer_space = 0;
static uint32_t constant_buffer_offset = 0;

static std::shared_mutex unmodified_shaders_mutex;
static std::unordered_set<uint32_t> unmodified_shaders;
static std::unordered_map<uint32_t, CustomShader> custom_shaders;

static std::unordered_map<uint32_t, uint32_t> counted_shaders;

// Return false to abort
static bool (*on_create_pipeline_layout)(reshade::api::device*, std::span<reshade::api::pipeline_layout_param>) = nullptr;
static bool (*on_init_pipeline_layout)(reshade::api::device*, reshade::api::pipeline_layout, std::span<const reshade::api::pipeline_layout_param>) = nullptr;

static bool using_custom_replace = false;
static bool using_custom_inject = false;
static bool using_counted_shaders = false;

struct __declspec(uuid("018e7b9c-23fd-7863-baf8-a8dad2a6db9d")) DeviceData {
  bool use_pipeline_layout_cloning = false;
  // bool force_pipeline_cloning = false;
  int32_t expected_constant_buffer_index = -1;
  uint32_t expected_constant_buffer_space = 0;
};

static void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::shader::OnInitDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  auto* data = renodx::utils::data::Create<DeviceData>(device);
  data->expected_constant_buffer_index = expected_constant_buffer_index;
  switch (device->get_api()) {
    case reshade::api::device_api::vulkan:
    case reshade::api::device_api::d3d12:
      data->use_pipeline_layout_cloning = use_pipeline_layout_cloning;
      data->expected_constant_buffer_space = expected_constant_buffer_space;
      break;
    default:
      // Guard against unsupported APIs
      break;
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::shader::OnDestroyDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

// Shader Injection
static bool OnCreatePipelineLayout(
    reshade::api::device* device,
    uint32_t& param_count,
    reshade::api::pipeline_layout_param*& params) {
  uint32_t cbv_index = 0;
  uint32_t pc_count = 0;
  uint32_t pdss_index = -1;
  uint32_t dword_count = 0;
  if (param_count == 0) {
    std::stringstream s;
    s << "mods::shader::OnCreatePipelineLayout(";
    s << "Skipping empty pipeline layout creation";
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
    return false;
  }
  if (param_count == -1) {
    std::stringstream s;
    s << "mods::shader::OnCreatePipelineLayout(";
    s << "Wrong param count: " << param_count;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
    return false;
  }

  if (on_create_pipeline_layout != nullptr) {
    if (!on_create_pipeline_layout(device, {params, param_count})) return false;
  }

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) {
    std::stringstream s;
    s << "mods::shader::OnCreatePipelineLayout(";
    s << "Device data not found on ";
    s << PRINT_PTR(std::uintptr_t(device));
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }

  auto device_api = device->get_api();
  bool is_dx = (device_api == reshade::api::device_api::d3d9
                || device_api == reshade::api::device_api::d3d11
                || device_api == reshade::api::device_api::d3d12);

  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    const auto& param = params[param_index];
    if (is_dx && param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      dword_count += 1;
      for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
        const auto& range = param.descriptor_table.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (
              range.dx_register_space == data->expected_constant_buffer_space
              && cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      dword_count += param.push_constants.count;
      pc_count++;
      if (is_dx
          && param.push_constants.dx_register_space == data->expected_constant_buffer_space
          && cbv_index < param.push_constants.dx_register_index + param.push_constants.count) {
        cbv_index = param.push_constants.dx_register_index + param.push_constants.count;
      }
    } else if (is_dx && param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      dword_count += 2;
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        if (
            param.push_descriptors.dx_register_space == data->expected_constant_buffer_space
            && cbv_index < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
          cbv_index = param.push_descriptors.dx_register_index + param.push_descriptors.count;
        }
      }
#if RESHADE_API_VERSION >= 13
    } else if (is_dx && param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers) {
      if (pdss_index == -1) pdss_index = param_index;
      for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
        auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
        if (range.static_samplers != nullptr) {
          if (range.type == reshade::api::descriptor_type::constant_buffer) {
            if (
                range.dx_register_space == data->expected_constant_buffer_space
                && cbv_index < range.dx_register_index + range.count) {
              cbv_index = range.dx_register_index + range.count;
            }
          }
        }
      }
#endif
    }
  }

  if (is_dx) {
    if (data->expected_constant_buffer_index != -1 && cbv_index > data->expected_constant_buffer_index) {
      std::stringstream s;
      s << "mods::shader::OnCreatePipelineLayout(";
      s << "Pipeline layout index mismatch, actual: " << cbv_index;
      s << ", expected: " << data->expected_constant_buffer_index;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
      return false;
    }
    if (data->expected_constant_buffer_index != -1) {
      cbv_index = data->expected_constant_buffer_index;
    }
  }

  if (pc_count != 0 && !allow_multiple_push_constants) {
    std::stringstream s;
    s << "mods::shader::OnCreatePipelineLayout(";
    s << "Pipeline layout already has push constants: " << pc_count;
    if (is_dx) {
      s << " with cbv_index: " << cbv_index;
    }
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }

  const uint32_t old_count = param_count;
  const uint32_t new_count = old_count + 1;
  auto* new_params = reinterpret_cast<reshade::api::pipeline_layout_param*>(malloc(sizeof(reshade::api::pipeline_layout_param) * new_count));

  // Store reference to free later
  created_params.push_back(new_params);

  // Copy up to size of old
  uint32_t injection_index = old_count;

  if (!is_dx || pdss_index == -1) {
    memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * old_count);
  } else {
    // copy upto pdss index, leave slot for push constants, add pdss after
    // avoids reshade adding pc constant buffers
    memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * pdss_index);
    injection_index = pdss_index;
    memcpy(new_params + pdss_index + 1, params + pdss_index, sizeof(reshade::api::pipeline_layout_param) * (old_count - pdss_index));
  }

  // Fill in extra param
  const uint32_t slots = shader_injection_size;
  const uint32_t max_count = 64u - dword_count;

  new_params[injection_index] = reshade::api::pipeline_layout_param(
      reshade::api::constant_range{
          .binding = 0,
          .dx_register_index = cbv_index,
          .dx_register_space = data->expected_constant_buffer_space,
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
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }

  std::stringstream s;
  s << "mods::shader::OnCreatePipelineLayout(";
  if (is_dx) {
    s << "will insert cbuffer " << cbv_index;
  } else {
    s << "will insert push constants ";
  }
  s << " at root_index " << injection_index;
  s << " with slot count " << slots;
  s << " creating new size of " << (old_count + 1u + slots);
  s << ", newParams: " << reinterpret_cast<uintptr_t>(new_params);
  s << " )";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  return true;
}

// AfterCreateRootSignature
static void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  assert(layout.handle != 0u);

  if (on_init_pipeline_layout != nullptr) {
    if (!on_init_pipeline_layout(device, layout, {params, param_count})) return;
  }
  int32_t injection_index = -1;
  auto device_api = device->get_api();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;

  uint32_t cbv_index = 0;
  uint32_t pc_count = 0;
  uint32_t pdss_index = -1;

  bool is_dx = (device_api == reshade::api::device_api::d3d9
                || device_api == reshade::api::device_api::d3d11
                || device_api == reshade::api::device_api::d3d12);

  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    auto param = params[param_index];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      for (uint32_t range_index = 0; range_index < param.descriptor_table.count; ++range_index) {
        auto range = param.descriptor_table.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (
              range.dx_register_space == data->expected_constant_buffer_space
              && cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      pc_count++;
      if (
          param.push_constants.dx_register_space == data->expected_constant_buffer_space
          && cbv_index < param.push_constants.dx_register_index + param.push_constants.count) {
        cbv_index = param.push_constants.dx_register_index + param.push_constants.count;
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        if (
            param.push_descriptors.dx_register_space == data->expected_constant_buffer_space
            && cbv_index < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
          cbv_index = param.push_descriptors.dx_register_index + param.push_descriptors.count;
        }
      }
#if RESHADE_API_VERSION >= 13
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers) {
      if (pdss_index == -1) pdss_index = param_index;
      for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
        auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
        if (range.static_samplers != nullptr) {
          if (range.type == reshade::api::descriptor_type::constant_buffer) {
            if (
                range.dx_register_space == data->expected_constant_buffer_space
                && cbv_index < range.dx_register_index + range.count) {
              cbv_index = range.dx_register_index + range.count;
            }
          }
        }
      }
#endif
    }
  }

  reshade::api::pipeline_layout injection_layout = layout;
  if (device_api == reshade::api::device_api::d3d9) {
    reshade::api::pipeline_layout_param new_params;
    new_params.type = reshade::api::pipeline_layout_param_type::push_constants;
    new_params.push_constants.count = shader_injection_size;
    new_params.push_constants.dx_register_index = 0;
    new_params.push_constants.dx_register_space = 0;
    new_params.push_constants.visibility = reshade::api::shader_stage::all;

    auto result = device->create_pipeline_layout(1, &new_params, &injection_layout);
    std::stringstream s;
    s << "mods::shader::OnInitPipelineLayout(";
    s << "Creating D3D9 Injection Layout ";
    s << PRINT_PTR(injection_layout.handle);
    s << ": " << result;
    s << " )";
    reshade::log::message(reshade::log::level::info, s.str().c_str());

    injection_index = 0;

  } else if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
    if (data->use_pipeline_layout_cloning) {
      const uint32_t old_count = param_count;
      uint32_t new_count = old_count;
      reshade::api::pipeline_layout_param* new_params = nullptr;
      if (shader_injection_size != 0u) {
        if (data->expected_constant_buffer_index != -1) {
          cbv_index = data->expected_constant_buffer_index;
        }

        new_count = old_count + 1;

        new_params = reinterpret_cast<reshade::api::pipeline_layout_param*>(malloc(sizeof(reshade::api::pipeline_layout_param) * new_count));
        // Copy up to size of old
        injection_index = old_count;
        if (!is_dx || pdss_index == -1) {
          memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * old_count);
        } else {
          // copy upto pdss index, leave slot for push constants, add pdss after
          // avoids reshade adding pc constant buffers
          memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * pdss_index);
          injection_index = pdss_index;
          memcpy(new_params + pdss_index + 1, params + pdss_index, sizeof(reshade::api::pipeline_layout_param) * (old_count - pdss_index));
        }

        // Fill in extra param
        const uint32_t slots = shader_injection_size;
        const uint32_t max_count = 64u - (old_count + 1u) + 1u;

        new_params[injection_index] = reshade::api::pipeline_layout_param(
            reshade::api::constant_range{
                .binding = 0,
                .dx_register_index = cbv_index,
                .dx_register_space = data->expected_constant_buffer_space,
                .count = (slots > max_count) ? max_count : slots,
                .visibility = reshade::api::shader_stage::all,
            });

        if (slots > max_count) {
          std::stringstream s;
          s << "mods::shader::OnInitPipelineLayout(";
          s << PRINT_PTR(layout.handle);
          s << "shader injection oversized: ";
          s << slots << "/" << max_count;
          s << " )";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
          free(new_params);
          new_params = nullptr;
          return;
        }
      } else {
        new_params = reinterpret_cast<reshade::api::pipeline_layout_param*>(malloc(sizeof(reshade::api::pipeline_layout_param) * old_count));
        memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * old_count);
      }

      {
        std::stringstream s;
        s << "mods::shader::OnInitPipelineLayout(Cloning D3D12 Layout ";
        s << PRINT_PTR(layout.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      }

      auto result = device->create_pipeline_layout(new_count, &new_params[0], &injection_layout);
      free(new_params);
      new_params = nullptr;
      std::stringstream s;
      s << "mods::shader::OnInitPipelineLayout(Cloning D3D12 Layout ";
      s << PRINT_PTR(layout.handle);
      s << " => ";
      s << PRINT_PTR(injection_layout.handle);
      s << ", b" << cbv_index << ",space" << data->expected_constant_buffer_space;
      s << ", param_index: " << injection_index;
      s << ", slots : " << shader_injection_size;
      s << ": " << (result ? "OK" : "FAILED");
      s << ")";
      reshade::log::message(result ? reshade::log::level::info : reshade::log::level::error, s.str().c_str());

    } else {
      if (created_params.empty()) {
        // No injected params
        std::stringstream s;
        s << "mods::shader::OnInitPipelineLayout(";
        s << "Params not created for: ";
        s << PRINT_PTR(layout.handle);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        return;
      };

      cbv_index = 0;
      for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
        if (params[param_index].type == reshade::api::pipeline_layout_param_type::push_constants) {
          injection_index = param_index;
          cbv_index = params[param_index].push_constants.dx_register_index;
        }
      }

      // Releasing params will break other addons that listen for init_pipeline_layout (eg: devkit)
      rebuilt_params[layout.handle] = created_params.back();
      created_params.pop_back();

      if (injection_index == -1) {
        std::stringstream s;
        s << "mods::shader::OnInitPipelineLayout(";
        s << "Injection index not found for ";
        s << PRINT_PTR(layout.handle);
        s << " )";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        return;
      }
    }

  } else {
    if (data->expected_constant_buffer_index != -1 && cbv_index != data->expected_constant_buffer_index) {
      std::stringstream s;
      s << "mods::shader::OnInitPipelineLayout(";
      s << "Forcing cbuffer index ";
      s << PRINT_PTR(layout.handle);
      s << ": " << data->expected_constant_buffer_index;
      s << " )";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      cbv_index = data->expected_constant_buffer_index;
    }
    if (cbv_index == 14) {
      cbv_index = 13;
      std::stringstream s;
      s << "mods::shader::OnInitPipelineLayout(";
      s << "Using last slot for buffer injection ";
      s << PRINT_PTR(layout.handle);
      s << ": " << cbv_index;
      s << " )";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }

    // device->create_pipeline_layout(1)

    reshade::api::pipeline_layout_param new_params;
    new_params.type = reshade::api::pipeline_layout_param_type::push_constants;
    // newParams.push_constants.binding = 0;
    new_params.push_constants.count = 1;
    new_params.push_constants.dx_register_index = cbv_index;
    new_params.push_constants.dx_register_space = 0;
    new_params.push_constants.visibility = reshade::api::shader_stage::all;

    auto result = device->create_pipeline_layout(1, &new_params, &injection_layout);
    std::stringstream s;
    s << "mods::shader::OnInitPipelineLayout(";
    s << "Creating D3D11 Layout ";
    s << PRINT_PTR(injection_layout.handle);
    s << ": " << result;
    s << " )";
    reshade::log::message(reshade::log::level::info, s.str().c_str());

    injection_index = 0;
  }

  {
    auto& pipeline_data = *utils::pipeline_layout::GetPipelineLayoutData(layout, true);
    pipeline_data.layout = layout;
    pipeline_data.injection_index = injection_index;
    pipeline_data.injection_layout = injection_layout;
    pipeline_data.injection_register_index = cbv_index;
    pipeline_data.failed_injection = false;
  }

  std::stringstream s;
  s << "mods::shader::OnInitPipelineLayout(";
  s << PRINT_PTR(layout.handle);
  s << ", injection index: " << injection_index;
  s << ", injection layout: " << PRINT_PTR(injection_layout.handle);
  if (is_dx) {
    s << ", cbvIndex:" << cbv_index;
  }
  s << " )";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

static void OnDestroyPipelineLayout(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout) {
  assert(layout.handle != 0u);

  bool changed = false;

  if (auto pair = rebuilt_params.find(layout.handle);
      pair != rebuilt_params.end()) {
    changed = true;
    auto& created_params = pair->second;
    // Possible risk of access violation on next event listener
    free(created_params);
    rebuilt_params.erase(pair);
  }

  if (!changed) return;

  std::stringstream s;
  s << "mods::shader::OnDestroyPipelineLayout(";
  s << PRINT_PTR(layout.handle);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

inline void OnPushConstants(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    uint32_t first,
    uint32_t count,
    const void* values) {
  reshade::api::pipeline_layout cloned_layout;
  {
    auto* pipeline_layout_data = utils::pipeline_layout::GetPipelineLayoutData(layout);
    if (pipeline_layout_data == nullptr) return;
    cloned_layout = pipeline_layout_data->replacement_layout;
    if (cloned_layout == 0u) return;
  }

#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::shader::OnPushConstants(clone push ";
  s << PRINT_PTR(layout.handle);
  s << " => " << PRINT_PTR(cloned_layout.handle);
  s << ", param: " << layout_param;
  s << ", first: " << first;
  s << ", count: " << count;
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
#endif

  cmd_list->push_constants(stages, cloned_layout, layout_param, first, count, values);
}

inline void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  reshade::api::pipeline_layout cloned_layout;
  {
    auto* pipeline_layout_data = utils::pipeline_layout::GetPipelineLayoutData(layout);
    if (pipeline_layout_data == nullptr) return;
    cloned_layout = pipeline_layout_data->replacement_layout;
    if (cloned_layout == 0u) return;
  }

#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::shader::OnPushDescriptors(clone push " << PRINT_PTR(layout.handle);
  s << " => " << PRINT_PTR(cloned_layout.handle);
  s << ", param: " << layout_param;
  s << ", table: " << PRINT_PTR(update.table.handle);
  s << ", binding: " << update.binding;
  s << ", array_offset: " << update.array_offset;
  s << ", count: " << update.count;
  s << ", type: " << update.type;
  switch (update.type) {
    case reshade::api::descriptor_type::constant_buffer: {
      // NOLINTNEXTLINE(google-readability-casting)
      auto* range = (reshade::api::buffer_range*)update.descriptors;
      s << ", buffer: " << PRINT_PTR(range->buffer.handle);
      s << ", offset: " << range->offset;
      s << ", size: " << range->size;
      break;
    }
    default:
      break;
  }
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
#endif

  cmd_list->push_descriptors(stages, cloned_layout, layout_param, update);
  // Switch back stage
  cmd_list->push_descriptors(stages, layout, layout_param, update);
}

inline void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  reshade::api::pipeline_layout cloned_layout;
  {
    auto* pipeline_layout_data = utils::pipeline_layout::GetPipelineLayoutData(layout);
    if (pipeline_layout_data == nullptr) return;
    cloned_layout = pipeline_layout_data->replacement_layout;
    if (cloned_layout == 0u) return;
  }

  for (uint32_t i = 0; i < count; ++i) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::shader::OnBindDescriptorTables(clone bind " << PRINT_PTR(layout.handle);
    s << " => " << PRINT_PTR(cloned_layout.handle);
    s << ", stages: 0x" << std::hex << static_cast<uint32_t>(stages) << std::dec << " (" << stages << ")";
    s << ", param: " << first + i;
    s << ", table: " << PRINT_PTR(tables[i].handle);
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
#endif
    cmd_list->bind_descriptor_table(stages, cloned_layout, (first + i), tables[i]);
    cmd_list->bind_descriptor_table(stages, layout, (first + i), tables[i]);
  }
}

struct DrawResponse {
  bool bypass_draw = false;
  int injection_register_index = -1;
  std::function<void(reshade::api::command_list*)> on_drawn = nullptr;
};

inline DrawResponse HandleStatesAndBypass(
    reshade::api::command_list* cmd_list,
    renodx::utils::shader::CommandListData* shader_state,
    const int& index,
    float resource_tag = -1) {
  auto& state = shader_state->stage_states[index];
  if (state.pipeline == 0u) return {.bypass_draw = false};

  const auto& shader_hash = renodx::utils::shader::GetCurrentShaderHash(&state, index);
  if (shader_hash == 0u) return {.bypass_draw = false};
  auto custom_shader_info_pair = custom_shaders.find(shader_hash);
  bool is_custom_shader = custom_shader_info_pair != custom_shaders.end();
  if (!is_custom_shader) {
    if (
        index != renodx::utils::shader::COMPUTE_INDEX
        && trace_unmodified_shaders
        && renodx::utils::swapchain::HasBackBufferRenderTarget(cmd_list)) {
      std::unique_lock lock(unmodified_shaders_mutex);
      if (unmodified_shaders.insert(shader_hash).second) {
        std::stringstream s;
        s << "mods::shader::HandlePreDraw(unmodified ";
        s << state.stage;
        s << " shader writing to swapchain: ";
        s << PRINT_CRC32(shader_hash);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
      }
    }

    return {.bypass_draw = false};  // move to next shader
  }

  auto& custom_shader_info = custom_shader_info_pair->second;
#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::shader::HandlePreDraw(found shader: ";
  s << PRINT_CRC32(shader_hash);
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

  if (custom_shader_info.on_draw != nullptr) {
    bool should_draw = custom_shader_info.on_draw(cmd_list);
    if (!should_draw) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::shader::HandlePreDraw(bypass draw: ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      return {.bypass_draw = true};  // bypass draw
    }
  }

  if (custom_shader_info.on_replace != nullptr) {
    bool should_replace = custom_shader_info.on_replace(cmd_list);
    if (!should_replace) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::shader::HandlePreDraw(Not replacing: ";
      s << PRINT_CRC32(shader_hash);
      s << ", stage:" << state.stage;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      // state.replacement_pipeline = {0u};
      return {.bypass_draw = false};
    }
  }

  bool should_inject = true;
  if (custom_shader_info.on_inject != nullptr) {
    should_inject = custom_shader_info.on_inject(cmd_list);
  }

  DrawResponse response = {.bypass_draw = false};

  if (custom_shader_info.on_drawn != nullptr) {
    response.on_drawn = custom_shader_info.on_drawn;
  }

  utils::shader::BuildReplacementPipeline(state.pipeline_details);

  // Perform Push
  if (shader_injection_size != 0 && should_inject) {
    if (state.pipeline_details->layout_data->injection_index == -1) {
#ifdef DEBUG_LEVEL_1
      if (!state.pipeline_details->layout_data->failed_injection) {
        state.pipeline_details->layout_data->failed_injection = true;
        std::stringstream s;
        s << "mods::shader::PushShaderInjections(did not find modded pipeline root index";
        s << ", layout: " << PRINT_PTR(state.pipeline_details->layout.handle);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
      }
#endif
      return {.bypass_draw = false};
    }

    renodx::utils::constants::PushShaderInjections(
        cmd_list,
        state.pipeline_details->layout_data->injection_layout,
        state.pipeline_details->layout_data->injection_index,
        index == renodx::utils::shader::COMPUTE_INDEX,
        {shader_injection, shader_injection_size},
        constant_buffer_offset,
        resource_tag_float,
        resource_tag);
    if (revert_constant_buffer_ranges) {
      switch (cmd_list->get_device()->get_api()) {
        case reshade::api::device_api::d3d10:
        case reshade::api::device_api::d3d11:
        case reshade::api::device_api::d3d12: {
          response.injection_register_index = state.pipeline_details->layout_data->injection_register_index;
          break;
        }
        default:
          break;
      }
    }
  }

  // Perform bind

  utils::shader::ApplyReplacement(cmd_list, &state);

  return response;
}

inline DrawResponse HandlePreDraw(reshade::api::command_list* cmd_list, bool is_dispatch) {
  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);

  assert(shader_state != nullptr);

  float resource_tag = -1;

  if (!is_dispatch && resource_tag_float != nullptr) {
    auto* swapchain_state = renodx::utils::data::Get<renodx::utils::swapchain::CommandListData>(cmd_list);
    if (swapchain_state == nullptr) {
      reshade::log::message(reshade::log::level::error, "mods::shader::HandlePreDraw(swapchain state is null)");
      return {.bypass_draw = false};
    }
    if (!swapchain_state->current_render_targets.empty()) {
      auto rv = swapchain_state->current_render_targets.at(0);
      resource_tag = renodx::utils::resource::GetResourceTag(rv);
    }
  }

  DrawResponse response;
  if (is_dispatch) {
    response = HandleStatesAndBypass(
        cmd_list, shader_state, renodx::utils::shader::COMPUTE_INDEX, resource_tag);
  } else {
    response = HandleStatesAndBypass(
        cmd_list, shader_state, renodx::utils::shader::VERTEX_INDEX, resource_tag);
    if (!response.bypass_draw) {
      response = HandleStatesAndBypass(
          cmd_list, shader_state, renodx::utils::shader::PIXEL_INDEX, resource_tag);
    }
  }

  return response;
}

inline bool OnDraw(reshade::api::command_list* cmd_list, uint32_t vertex_count, uint32_t instance_count, uint32_t first_vertex, uint32_t first_instance) {
  auto response = HandlePreDraw(cmd_list, false);
  if (response.bypass_draw) return true;
  if (response.on_drawn == nullptr && response.injection_register_index == -1) return false;

  cmd_list->draw(vertex_count, instance_count, first_vertex, first_instance);

  if (response.on_drawn != nullptr) {
    response.on_drawn(cmd_list);
  }
  if (response.injection_register_index != -1) {
    renodx::utils::constants::RevertBufferRange(cmd_list, response.injection_register_index);
  }
  return true;
}

inline bool OnDispatch(
    reshade::api::command_list* cmd_list,
    uint32_t group_count_x,
    uint32_t group_count_y,
    uint32_t group_count_z) {
  auto response = HandlePreDraw(cmd_list, true);
  if (response.bypass_draw) return true;
  if (response.on_drawn == nullptr && response.injection_register_index == -1) return false;

  cmd_list->dispatch(group_count_x, group_count_y, group_count_z);

  if (response.on_drawn != nullptr) {
    response.on_drawn(cmd_list);
  }

  if (response.injection_register_index != -1) {
    renodx::utils::constants::RevertBufferRange(
        cmd_list,
        response.injection_register_index,
        0,
        reshade::api::shader_stage::compute);
  }

  return true;
}

inline bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  auto response = HandlePreDraw(cmd_list, false);
  if (response.bypass_draw) return true;
  if (response.on_drawn == nullptr && response.injection_register_index == -1) return false;

  cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);

  if (response.on_drawn != nullptr) {
    response.on_drawn(cmd_list);
  }

  if (response.injection_register_index != -1) {
    renodx::utils::constants::RevertBufferRange(cmd_list, response.injection_register_index);
  }

  return true;
}

inline bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride) {
  bool is_dispatch = false;
  switch (type) {
    case reshade::api::indirect_command::unknown: {
      {
        auto* cmd_list_data = renodx::utils::shader::GetCurrentState(cmd_list);
        auto shader_hash = renodx::utils::shader::GetCurrentComputeShaderHash(cmd_list_data);
        is_dispatch = (shader_hash != 0u);
      }
      break;
    }
    case reshade::api::indirect_command::dispatch:
    case reshade::api::indirect_command::dispatch_mesh:
    case reshade::api::indirect_command::dispatch_rays:
      is_dispatch = true;
      break;
    default:
      break;
  }

  auto response = HandlePreDraw(cmd_list, is_dispatch);
  if (response.bypass_draw) return true;
  if (response.on_drawn == nullptr && response.injection_register_index == -1) return false;

  cmd_list->draw_or_dispatch_indirect(type, buffer, offset, draw_count, stride);

  if (response.on_drawn != nullptr) {
    response.on_drawn(cmd_list);
  }

  if (response.injection_register_index != -1) {
    renodx::utils::constants::RevertBufferRange(
        cmd_list,
        response.injection_register_index,
        0,
        is_dispatch ? reshade::api::shader_stage::compute : reshade::api::shader_stage::pixel);
  }

  return true;
}

inline void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* /*source_rect*/,
    const reshade::api::rect* /*dest_rect*/,
    uint32_t /*dirty_rect_count*/,
    const reshade::api::rect* /*dirty_rects*/) {
  auto* data = renodx::utils::data::Get<DeviceData>(swapchain->get_device());
  if (data == nullptr) return;

  if (using_counted_shaders) {
    counted_shaders.clear();
  }

  if (push_injections_on_present) {
    auto* cmd_list = queue->get_immediate_command_list();
    auto* state = renodx::utils::shader::GetCurrentState(cmd_list);
    if (state->last_pipeline != 0u) {
      auto* details = renodx::utils::shader::GetPipelineShaderDetails(state->last_pipeline);
      if (details != nullptr) {
        if (details->layout_data != nullptr) {
          if (details->layout_data->injection_layout != 0u) {
            renodx::utils::constants::PushShaderInjections(
                cmd_list,
                details->layout_data->injection_layout,
                details->layout_data->injection_index,
                false,
                {shader_injection, shader_injection_size});
          }
        }
      }
    }
  }
}

static bool attached = false;

template <typename T = float*, std::ranges::range CustomShaderList>
  requires std::convertible_to<std::ranges::range_value_t<CustomShaderList>, std::pair<uint32_t, CustomShader>>
static void Use(DWORD fdw_reason, const CustomShaderList& new_custom_shaders, T* new_injections = nullptr) {
  renodx::utils::shader::Use(fdw_reason);
  if (resource_tag_float != nullptr) {
    renodx::utils::resource::Use(fdw_reason);
  }
  if (trace_unmodified_shaders || invoked_custom_swapchain_shader != nullptr) {
    renodx::utils::swapchain::Use(fdw_reason);
  }
  renodx::utils::pipeline_layout::Use(fdw_reason);
  if (revert_constant_buffer_ranges) {
    renodx::utils::constants::capture_push_descriptors = true;
    renodx::utils::constants::Use(fdw_reason);
  }

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "mods::shader attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      // Copy from wrapper's native map into runtime mutable map
      custom_shaders.clear();
      custom_shaders.reserve(new_custom_shaders.size());
      for (const auto& kv : new_custom_shaders) {
        custom_shaders.emplace(kv.first, kv.second);
        if (kv.second.on_replace != nullptr) using_custom_replace = true;
        if (kv.second.index != -1) using_counted_shaders = true;
      }

      custom_shaders.rehash(custom_shaders.size());

      if (using_counted_shaders || push_injections_on_present) {
        reshade::register_event<reshade::addon_event::present>(OnPresent);
      }

      if (using_custom_replace || using_custom_inject) {
        renodx::utils::shader::use_replace_on_bind = false;
      }

      if (!manual_shader_scheduling) {
        if (force_pipeline_cloning || use_pipeline_layout_cloning) {
          for (const auto& [hash, shader] : (new_custom_shaders)) {
            for (const auto& [device, code] : shader.code_by_device) {
              renodx::utils::shader::UpdateReplacements({{hash, code}}, false, true, {device});
            }
            if (!shader.code.empty()) {
              renodx::utils::shader::QueueRuntimeReplacement(hash, shader.code);
            }
          }
        } else {
          for (const auto& [hash, shader] : (new_custom_shaders)) {
            bool compile_supported = shader.on_replace == nullptr && shader.index == -1;
            for (const auto& [device, code] : shader.code_by_device) {
              renodx::utils::shader::UpdateReplacements({{hash, code}}, compile_supported, true, {device});
            }

            if (!shader.code.empty()) {
              if (compile_supported) {
                renodx::utils::shader::QueueCompileTimeReplacement(hash, shader.code);
              }
              // Use Runtime as fallback
              renodx::utils::shader::QueueRuntimeReplacement(hash, shader.code);
            }
          }
        }
      }

      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);

      {
        std::stringstream s;
        s << "mods::shader(Attached Custom Shaders: " << custom_shaders.size();
        s << " from " << reinterpret_cast<uintptr_t>(&new_custom_shaders);
        s << " to " << reinterpret_cast<uintptr_t>(&custom_shaders);
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
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
        s << " at " << reinterpret_cast<uintptr_t>(shader_injection);
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }

      break;
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

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