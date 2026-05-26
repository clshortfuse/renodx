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

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdio>
#include <functional>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

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

struct ViewBinding {
  reshade::api::descriptor_type type = static_cast<reshade::api::descriptor_type>(0u);
  uint32_t slot = 0u;
  uint32_t space = 50u;
  std::function<reshade::api::resource_view(reshade::api::command_list*)> get_view = nullptr;
};

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
  std::vector<ViewBinding> views = {};
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

inline CustomShader CreateBypassShader(std::uint32_t crc32) {
  CustomShader shader = {};
  shader.crc32 = crc32;
  shader.on_draw = &renodx::mods::shader::internal::OnBypassShaderDraw;
  return shader;
}

inline CustomShader CreateCustomShader(std::uint32_t crc32, std::span<const std::uint8_t> code) {
  CustomShader shader = {};
  shader.crc32 = crc32;
  shader.code = code;
  return shader;
}

inline CustomShader CreateCountedShader(std::uint32_t crc32, std::span<const std::uint8_t> code, int32_t index) {
  auto shader = CreateCustomShader(crc32, code);
  shader.index = index;
  return shader;
}

inline CustomShader CreateSwapchainShader(std::uint32_t crc32, std::span<const std::uint8_t> code) {
  auto shader = CreateCustomShader(crc32, code);
  shader.on_replace = (renodx::mods::shader::invoked_custom_swapchain_shader =
                           &renodx::utils::swapchain::HasBackBufferRenderTarget);
  return shader;
}

inline CustomShader CreateCallbackShader(
    std::uint32_t crc32,
    std::span<const std::uint8_t> code,
    std::function<bool(reshade::api::command_list*)> callback) {
  auto shader = CreateCustomShader(crc32, code);
  shader.on_replace = callback;
  return shader;
}

inline CustomShader CreateDirectXShader(
    std::uint32_t crc32,
    std::span<const std::uint8_t> dx11_code,
    std::span<const std::uint8_t> dx12_code) {
  CustomShader shader = {};
  shader.crc32 = crc32;
  shader.code_by_device = {
      {reshade::api::device_api::d3d11, dx11_code},
      {reshade::api::device_api::d3d12, dx12_code},
  };
  return shader;
}

// clang-format off
#define BypassShaderEntry(__crc32__)               {__crc32__, renodx::mods::shader::CreateBypassShader(__crc32__)}
#define CustomShaderEntry(crc32)                   {crc32, renodx::mods::shader::CreateCustomShader(crc32, __##crc32)}
#define CustomCountedShader(crc32, index)          {crc32, renodx::mods::shader::CreateCountedShader(crc32, __##crc32, index)}
#define CustomSwapchainShader(crc32)               {crc32, renodx::mods::shader::CreateSwapchainShader(crc32, __##crc32)}
#define CustomShaderEntryCallback(crc32, callback) {crc32, renodx::mods::shader::CreateCallbackShader(crc32, __##crc32, callback)}
// clang-format on
#define RENODX_JOIN_MACRO(x, y) x##y
#define CustomDirectXShaders(__crc32__)                       \
  {                                                           \
      __crc32__, renodx::mods::shader::CreateDirectXShader(   \
                     __crc32__,                               \
                     RENODX_JOIN_MACRO(__##__crc32__, _dx11), \
                     RENODX_JOIN_MACRO(__##__crc32__, _dx12))}

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
static renodx::utils::data::ParallelNodeHashMap<uint32_t, CustomShader> custom_shaders;

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
  std::vector<reshade::api::descriptor_range> injected_descriptor_ranges;
  std::optional<reshade::api::pipeline_layout_param> injected_descriptor_param = std::nullopt;
};

static void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::shader::OnInitDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  auto* data = renodx::utils::data::Create<DeviceData>(device);
  data->expected_constant_buffer_index = expected_constant_buffer_index;
  data->injected_descriptor_ranges.clear();
  data->injected_descriptor_param = std::nullopt;

  for (const auto& [shader_hash, custom_shader] : custom_shaders) {
    (void)shader_hash;
    for (const auto& view_binding : custom_shader.views) {
      assert(view_binding.get_view != nullptr);

      auto range_it = std::ranges::find_if(
          data->injected_descriptor_ranges,
          [&](const reshade::api::descriptor_range& range) {
            return range.type == view_binding.type
                   && range.dx_register_space == view_binding.space;
          });

      if (range_it == data->injected_descriptor_ranges.end()) {
        data->injected_descriptor_ranges.push_back({
            .binding = 0u,
            .dx_register_index = view_binding.slot,
            .dx_register_space = view_binding.space,
            .count = 1u,
            .visibility = reshade::api::shader_stage::all,
            .array_size = 1u,
            .type = view_binding.type,
        });
        continue;
      }

      const uint32_t min_slot = std::min(range_it->dx_register_index, view_binding.slot);
      const uint32_t max_slot = std::max(
          range_it->dx_register_index + range_it->count - 1u,
          view_binding.slot);
      range_it->dx_register_index = min_slot;
      range_it->count = max_slot - min_slot + 1u;
    }
  }

  std::ranges::sort(
      data->injected_descriptor_ranges,
      [](const reshade::api::descriptor_range& lhs, const reshade::api::descriptor_range& rhs) {
        if (lhs.type != rhs.type) return lhs.type < rhs.type;
        if (lhs.dx_register_space != rhs.dx_register_space) return lhs.dx_register_space < rhs.dx_register_space;
        return lhs.dx_register_index < rhs.dx_register_index;
      });

  uint32_t binding = 0u;
  for (auto& range : data->injected_descriptor_ranges) {
    range.binding = binding;
    binding += range.count;
  }

  if (!data->injected_descriptor_ranges.empty()) {
    if (data->injected_descriptor_ranges.size() > 1u) {
      reshade::api::pipeline_layout_param descriptor_param = {};
      descriptor_param.type = reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges;
      descriptor_param.descriptor_table.count = static_cast<uint32_t>(data->injected_descriptor_ranges.size());
      descriptor_param.descriptor_table.ranges = data->injected_descriptor_ranges.data();
      data->injected_descriptor_param = descriptor_param;
    } else {
      data->injected_descriptor_param = reshade::api::pipeline_layout_param(
          reshade::api::descriptor_range{
              .binding = 0,
              .dx_register_index = data->injected_descriptor_ranges.front().dx_register_index,
              .dx_register_space = data->injected_descriptor_ranges.front().dx_register_space,
              .count = binding,
              .visibility = reshade::api::shader_stage::all,
              .array_size = 1,
              .type = data->injected_descriptor_ranges.front().type,
          });
    }
  }
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
      if (device_api == reshade::api::device_api::d3d12
          && param.descriptor_table.count != 0u
          && param.descriptor_table.ranges[0].count != 0u) {
        dword_count += 1u;
      }
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
      if (device_api == reshade::api::device_api::d3d12) {
        if (param.push_descriptors.count != 0u) {
          if (param.push_descriptors.count == 1u && param.push_descriptors.binding == 0u) {
            switch (param.push_descriptors.type) {
              case reshade::api::descriptor_type::constant_buffer:
              case reshade::api::descriptor_type::buffer_shader_resource_view:
              case reshade::api::descriptor_type::buffer_unordered_access_view:
              case reshade::api::descriptor_type::acceleration_structure:
                dword_count += 2u;
                break;
              default:
                dword_count += 1u;
                break;
            }
          } else {
            dword_count += 1u;
          }
        }
      } else {
        dword_count += 2u;
      }
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        if (
            param.push_descriptors.dx_register_space == data->expected_constant_buffer_space
            && cbv_index < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
          cbv_index = param.push_descriptors.dx_register_index + param.push_descriptors.count;
        }
      }
    } else if (is_dx && param.type == reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers) {
      if (device_api == reshade::api::device_api::d3d12) {
        if (param.descriptor_table_with_static_samplers.count != 0u
            && param.descriptor_table_with_static_samplers.ranges[0].count != 0u) {
          for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
            const auto& range = param.descriptor_table_with_static_samplers.ranges[range_index];
            if (range.count == 0u) continue;
            if (range.type == reshade::api::descriptor_type::sampler && range.static_samplers != nullptr) continue;
            dword_count += 1u;
            break;
          }
        }
      } else {
        dword_count += 1u;
      }
      for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
        const auto& range = param.descriptor_table_with_static_samplers.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (
              range.dx_register_space == data->expected_constant_buffer_space
              && cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
    } else if (is_dx && param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers) {
      const bool static_sampler_param = param.descriptor_table_with_static_samplers.count != 0u
                                        && param.descriptor_table_with_static_samplers.ranges[0].static_samplers != nullptr;
      if (static_sampler_param && pdss_index == -1) pdss_index = param_index;
      if (static_sampler_param) {
        // Static samplers are not root parameters and do not count against the D3D12 root signature DWORD budget.
      } else if (device_api == reshade::api::device_api::d3d12) {
        if (param.descriptor_table_with_static_samplers.count != 0u
            && param.descriptor_table_with_static_samplers.ranges[0].count != 0u) {
          if (param.descriptor_table_with_static_samplers.count == 1u
              && param.descriptor_table_with_static_samplers.ranges[0].count == 1u
              && param.descriptor_table_with_static_samplers.ranges[0].binding == 0u) {
            switch (param.descriptor_table_with_static_samplers.ranges[0].type) {
              case reshade::api::descriptor_type::constant_buffer:
              case reshade::api::descriptor_type::buffer_shader_resource_view:
              case reshade::api::descriptor_type::buffer_unordered_access_view:
              case reshade::api::descriptor_type::acceleration_structure:
                dword_count += 2u;
                break;
              default:
                dword_count += 1u;
                break;
            }
          } else {
            for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
              const auto& range = param.descriptor_table_with_static_samplers.ranges[range_index];
              if (range.count == 0u) continue;
              if (range.type == reshade::api::descriptor_type::sampler && range.static_samplers != nullptr) continue;
              dword_count += 1u;
              break;
            }
          }
        }
      } else {
        dword_count += 2;
      }
      for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
        auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (
              range.dx_register_space == data->expected_constant_buffer_space
              && cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
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

  auto descriptor_type = static_cast<reshade::api::descriptor_type>(0u);
  int32_t descriptor_register_index = 0;
  uint32_t descriptor_register_space = 50u;
  uint32_t descriptor_count = 0u;
  const reshade::api::descriptor_range* descriptor_ranges = nullptr;
  uint32_t descriptor_range_count = 0u;
  const bool has_descriptor_injection = data != nullptr && !data->injected_descriptor_ranges.empty();
  if (has_descriptor_injection) {
    descriptor_ranges = data->injected_descriptor_ranges.data();
    descriptor_range_count = static_cast<uint32_t>(data->injected_descriptor_ranges.size());
    descriptor_type = data->injected_descriptor_ranges.front().type;
    descriptor_register_index = static_cast<int32_t>(data->injected_descriptor_ranges.front().dx_register_index);
    descriptor_register_space = data->injected_descriptor_ranges.front().dx_register_space;
    for (const auto& range : data->injected_descriptor_ranges) {
      descriptor_count += range.count;
    }
  }
  const auto* injected_descriptor_param =
      has_descriptor_injection && data->injected_descriptor_param.has_value()
          ? &data->injected_descriptor_param.value()
          : nullptr;
  assert(!has_descriptor_injection || injected_descriptor_param != nullptr);

  const bool has_constant_injection = shader_injection_size != 0u;
  const uint32_t added_params =
      (has_constant_injection ? 1u : 0u)
      + (has_descriptor_injection ? 1u : 0u);
  if (added_params == 0u) {
    return false;
  }

  const uint32_t old_count = param_count;
  const uint32_t new_count = old_count + added_params;
  auto* new_params = reinterpret_cast<reshade::api::pipeline_layout_param*>(malloc(sizeof(reshade::api::pipeline_layout_param) * new_count));

  uint32_t injection_index = old_count;
  uint32_t descriptor_injection_index = old_count;
  uint32_t insert_index = old_count;
  uint32_t descriptor_injection_cost = 0u;
  uint32_t constant_injection_cost = 0u;
  if (has_descriptor_injection) {
    const auto descriptor_param = *injected_descriptor_param;
    if (device_api == reshade::api::device_api::d3d12) {
      if (descriptor_param.type == reshade::api::pipeline_layout_param_type::push_descriptors
          && descriptor_param.push_descriptors.count != 0u) {
        if (descriptor_param.push_descriptors.count == 1u && descriptor_param.push_descriptors.binding == 0u) {
          switch (descriptor_param.push_descriptors.type) {
            case reshade::api::descriptor_type::constant_buffer:
            case reshade::api::descriptor_type::buffer_shader_resource_view:
            case reshade::api::descriptor_type::buffer_unordered_access_view:
            case reshade::api::descriptor_type::acceleration_structure:
              descriptor_injection_cost = 2u;
              break;
            default:
              descriptor_injection_cost = 1u;
              break;
          }
        } else {
          descriptor_injection_cost = 1u;
        }
      } else if (descriptor_param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges
                 && descriptor_param.descriptor_table.count != 0u
                 && descriptor_param.descriptor_table.ranges[0].count != 0u) {
        if (descriptor_param.descriptor_table.count == 1u
            && descriptor_param.descriptor_table.ranges[0].count == 1u
            && descriptor_param.descriptor_table.ranges[0].binding == 0u) {
          switch (descriptor_param.descriptor_table.ranges[0].type) {
            case reshade::api::descriptor_type::constant_buffer:
            case reshade::api::descriptor_type::buffer_shader_resource_view:
            case reshade::api::descriptor_type::buffer_unordered_access_view:
            case reshade::api::descriptor_type::acceleration_structure:
              descriptor_injection_cost = 2u;
              break;
            default:
              descriptor_injection_cost = 1u;
              break;
          }
        } else {
          descriptor_injection_cost = 1u;
        }
      }
    } else {
      descriptor_injection_cost = 2u;
    }
  }

  if (!is_dx || pdss_index == -1) {
    memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * old_count);
  } else {
    memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * pdss_index);
    insert_index = pdss_index;
    memcpy(new_params + pdss_index + added_params, params + pdss_index, sizeof(reshade::api::pipeline_layout_param) * (old_count - pdss_index));
  }

  if (has_constant_injection) {
    injection_index = insert_index++;

    const uint32_t slots = shader_injection_size;
    const uint32_t used_dword_count = dword_count + descriptor_injection_cost;
    const uint32_t remaining_dword_count = used_dword_count >= 64u ? 0u : 64u - used_dword_count;
    if (remaining_dword_count == 0u) {
      std::stringstream s;
      s << "mods::shader::OnCreatePipelineLayout(";
      s << "no dword budget left for constant injection";
      s << ", root_dwords: " << dword_count;
      s << ", descriptor_injection_cost: " << descriptor_injection_cost;
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      free(new_params);
      return false;
    }

    constant_injection_cost = std::min(slots, remaining_dword_count);
    new_params[injection_index] = reshade::api::pipeline_layout_param(
        reshade::api::constant_range{
            .binding = 0,
            .dx_register_index = cbv_index,
            .dx_register_space = data->expected_constant_buffer_space,
            .count = constant_injection_cost,
            .visibility = reshade::api::shader_stage::all,
        });

    if (slots > remaining_dword_count) {
      std::stringstream s;
      s << "mods::shader::OnCreatePipelineLayout(";
      s << "shader injection oversized: ";
      s << slots << "/" << remaining_dword_count;
      s << ", root_dwords: " << dword_count;
      s << ", descriptor_injection_cost: " << descriptor_injection_cost;
      s << " )";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
  }

  if (has_descriptor_injection) {
    descriptor_injection_index = insert_index++;
    new_params[descriptor_injection_index] = *injected_descriptor_param;
  }

  created_params.push_back(new_params);
  param_count = new_count;
  params = new_params;

  const uint32_t final_dword_count = dword_count + constant_injection_cost + descriptor_injection_cost;
  std::stringstream s;
  s << "mods::shader::OnCreatePipelineLayout(";
  if (has_constant_injection && is_dx) {
    s << "will insert cbuffer " << cbv_index;
  } else if (has_constant_injection) {
    s << "will insert push constants ";
  }
  if (has_constant_injection) {
    s << " at root_index " << injection_index;
    s << " with slot count " << shader_injection_size;
  }
  if (has_descriptor_injection) {
    if (has_constant_injection) s << ", ";
    s << "will insert descriptor type " << descriptor_type;
    s << " at root_index " << descriptor_injection_index;
    s << " mapped to register " << descriptor_register_index;
    s << " space " << descriptor_register_space;
    s << " count " << descriptor_count;
  }
  s << " creating new size of " << new_count;
  if (device_api == reshade::api::device_api::d3d12) {
    s << ", root_dwords: " << dword_count << " => " << final_dword_count;
    s << ", constant_injection_cost: " << constant_injection_cost;
    s << ", descriptor_injection_cost: " << descriptor_injection_cost;
  }
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
  int32_t descriptor_injection_index = -1;
  auto device_api = device->get_api();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;

  uint32_t cbv_index = 0;
  uint32_t pc_count = 0;
  uint32_t pdss_index = -1;
  uint32_t dword_count = 0;

  bool is_dx = (device_api == reshade::api::device_api::d3d9
                || device_api == reshade::api::device_api::d3d11
                || device_api == reshade::api::device_api::d3d12);
  auto descriptor_type = static_cast<reshade::api::descriptor_type>(0u);
  int32_t descriptor_register_index = 0;
  uint32_t descriptor_register_space = 50u;
  uint32_t descriptor_count = 0u;
  const reshade::api::descriptor_range* descriptor_ranges = nullptr;
  uint32_t descriptor_range_count = 0u;
  const bool has_descriptor_injection = data != nullptr && !data->injected_descriptor_ranges.empty();
  if (has_descriptor_injection) {
    descriptor_ranges = data->injected_descriptor_ranges.data();
    descriptor_range_count = static_cast<uint32_t>(data->injected_descriptor_ranges.size());
    descriptor_type = data->injected_descriptor_ranges.front().type;
    descriptor_register_index = static_cast<int32_t>(data->injected_descriptor_ranges.front().dx_register_index);
    descriptor_register_space = data->injected_descriptor_ranges.front().dx_register_space;
    for (const auto& range : data->injected_descriptor_ranges) {
      descriptor_count += range.count;
    }
  }
  const auto* injected_descriptor_param =
      has_descriptor_injection && data->injected_descriptor_param.has_value()
          ? &data->injected_descriptor_param.value()
          : nullptr;
  assert(!has_descriptor_injection || injected_descriptor_param != nullptr);

  const bool has_constant_injection = shader_injection_size != 0u;

  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    auto param = params[param_index];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      if (device_api == reshade::api::device_api::d3d12
          && param.descriptor_table.count != 0u
          && param.descriptor_table.ranges[0].count != 0u) {
        dword_count += 1u;
      }
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
      if (device_api == reshade::api::device_api::d3d12) {
        dword_count += param.push_constants.count;
      }
      pc_count++;
      if (
          param.push_constants.dx_register_space == data->expected_constant_buffer_space
          && cbv_index < param.push_constants.dx_register_index + param.push_constants.count) {
        cbv_index = param.push_constants.dx_register_index + param.push_constants.count;
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      if (device_api == reshade::api::device_api::d3d12 && param.push_descriptors.count != 0u) {
        if (param.push_descriptors.count == 1u && param.push_descriptors.binding == 0u) {
          switch (param.push_descriptors.type) {
            case reshade::api::descriptor_type::constant_buffer:
            case reshade::api::descriptor_type::buffer_shader_resource_view:
            case reshade::api::descriptor_type::buffer_unordered_access_view:
            case reshade::api::descriptor_type::acceleration_structure:
              dword_count += 2u;
              break;
            default:
              dword_count += 1u;
              break;
          }
        } else {
          dword_count += 1u;
        }
      }
      if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
        if (
            param.push_descriptors.dx_register_space == data->expected_constant_buffer_space
            && cbv_index < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
          cbv_index = param.push_descriptors.dx_register_index + param.push_descriptors.count;
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers) {
      if (device_api == reshade::api::device_api::d3d12
          && param.descriptor_table_with_static_samplers.count != 0u
          && param.descriptor_table_with_static_samplers.ranges[0].count != 0u) {
        for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
          const auto& range = param.descriptor_table_with_static_samplers.ranges[range_index];
          if (range.count == 0u) continue;
          if (range.type == reshade::api::descriptor_type::sampler && range.static_samplers != nullptr) continue;
          dword_count += 1u;
          break;
        }
      }
      for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
        auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (
              range.dx_register_space == data->expected_constant_buffer_space
              && cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers) {
      const bool static_sampler_param = param.descriptor_table_with_static_samplers.count != 0u
                                        && param.descriptor_table_with_static_samplers.ranges[0].static_samplers != nullptr;
      if (!static_sampler_param
          && device_api == reshade::api::device_api::d3d12
          && param.descriptor_table_with_static_samplers.count != 0u
          && param.descriptor_table_with_static_samplers.ranges[0].count != 0u) {
        if (param.descriptor_table_with_static_samplers.count == 1u
            && param.descriptor_table_with_static_samplers.ranges[0].count == 1u
            && param.descriptor_table_with_static_samplers.ranges[0].binding == 0u) {
          switch (param.descriptor_table_with_static_samplers.ranges[0].type) {
            case reshade::api::descriptor_type::constant_buffer:
            case reshade::api::descriptor_type::buffer_shader_resource_view:
            case reshade::api::descriptor_type::buffer_unordered_access_view:
            case reshade::api::descriptor_type::acceleration_structure:
              dword_count += 2u;
              break;
            default:
              dword_count += 1u;
              break;
          }
        } else {
          for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
            const auto& range = param.descriptor_table_with_static_samplers.ranges[range_index];
            if (range.count == 0u) continue;
            if (range.type == reshade::api::descriptor_type::sampler && range.static_samplers != nullptr) continue;
            dword_count += 1u;
            break;
          }
        }
      }
      if (static_sampler_param && pdss_index == -1) pdss_index = param_index;
      for (uint32_t range_index = 0; range_index < param.descriptor_table_with_static_samplers.count; ++range_index) {
        auto range = param.descriptor_table_with_static_samplers.ranges[range_index];
        if (range.type == reshade::api::descriptor_type::constant_buffer) {
          if (
              range.dx_register_space == data->expected_constant_buffer_space
              && cbv_index < range.dx_register_index + range.count) {
            cbv_index = range.dx_register_index + range.count;
          }
        }
      }
    }
  }

  reshade::api::pipeline_layout injection_layout = layout;
  if (device_api == reshade::api::device_api::d3d9) {
    if (has_constant_injection) {
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
    }

  } else if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
    if (data->use_pipeline_layout_cloning) {
      const uint32_t old_count = param_count;
      uint32_t new_count = old_count;
      reshade::api::pipeline_layout_param* new_params = nullptr;
      const uint32_t added_params =
          (has_constant_injection ? 1u : 0u)
          + (has_descriptor_injection ? 1u : 0u);
      if (added_params != 0u) {
        if (data->expected_constant_buffer_index != -1) {
          cbv_index = data->expected_constant_buffer_index;
        }

        new_count = old_count + added_params;

        new_params = reinterpret_cast<reshade::api::pipeline_layout_param*>(malloc(sizeof(reshade::api::pipeline_layout_param) * new_count));
        uint32_t insert_index = old_count;
        if (!is_dx || pdss_index == -1) {
          memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * old_count);
        } else {
          memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * pdss_index);
          insert_index = pdss_index;
          memcpy(new_params + pdss_index + added_params, params + pdss_index, sizeof(reshade::api::pipeline_layout_param) * (old_count - pdss_index));
        }

        if (has_constant_injection) {
          injection_index = static_cast<int32_t>(insert_index++);

          const uint32_t slots = shader_injection_size;
          uint32_t descriptor_injection_cost = 0u;
          if (has_descriptor_injection) {
            const auto descriptor_param = *injected_descriptor_param;
            if (descriptor_param.type == reshade::api::pipeline_layout_param_type::push_descriptors
                && descriptor_param.push_descriptors.count != 0u) {
              if (descriptor_param.push_descriptors.count == 1u && descriptor_param.push_descriptors.binding == 0u) {
                switch (descriptor_param.push_descriptors.type) {
                  case reshade::api::descriptor_type::constant_buffer:
                  case reshade::api::descriptor_type::buffer_shader_resource_view:
                  case reshade::api::descriptor_type::buffer_unordered_access_view:
                  case reshade::api::descriptor_type::acceleration_structure:
                    descriptor_injection_cost = 2u;
                    break;
                  default:
                    descriptor_injection_cost = 1u;
                    break;
                }
              } else {
                descriptor_injection_cost = 1u;
              }
            } else if (descriptor_param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges
                       && descriptor_param.descriptor_table.count != 0u
                       && descriptor_param.descriptor_table.ranges[0].count != 0u) {
              if (descriptor_param.descriptor_table.count == 1u
                  && descriptor_param.descriptor_table.ranges[0].count == 1u
                  && descriptor_param.descriptor_table.ranges[0].binding == 0u) {
                switch (descriptor_param.descriptor_table.ranges[0].type) {
                  case reshade::api::descriptor_type::constant_buffer:
                  case reshade::api::descriptor_type::buffer_shader_resource_view:
                  case reshade::api::descriptor_type::buffer_unordered_access_view:
                  case reshade::api::descriptor_type::acceleration_structure:
                    descriptor_injection_cost = 2u;
                    break;
                  default:
                    descriptor_injection_cost = 1u;
                    break;
                }
              } else {
                descriptor_injection_cost = 1u;
              }
            }
          }
          const uint32_t used_dword_count = dword_count + descriptor_injection_cost;
          const uint32_t remaining_dword_count = used_dword_count >= 64u ? 0u : 64u - used_dword_count;

          new_params[injection_index] = reshade::api::pipeline_layout_param(
              reshade::api::constant_range{
                  .binding = 0,
                  .dx_register_index = cbv_index,
                  .dx_register_space = data->expected_constant_buffer_space,
                  .count = std::min(slots, remaining_dword_count),
                  .visibility = reshade::api::shader_stage::all,
              });

          if (slots > remaining_dword_count) {
            std::stringstream s;
            s << "mods::shader::OnInitPipelineLayout(";
            s << PRINT_PTR(layout.handle);
            s << "shader injection oversized: ";
            s << slots << "/" << remaining_dword_count;
            s << ", root_dwords: " << dword_count;
            s << ", descriptor_injection_cost: " << descriptor_injection_cost;
            s << " )";
            reshade::log::message(reshade::log::level::warning, s.str().c_str());
            free(new_params);
            new_params = nullptr;
            return;
          }
        }

        if (has_descriptor_injection) {
          descriptor_injection_index = static_cast<int32_t>(insert_index++);
          new_params[descriptor_injection_index] = *injected_descriptor_param;
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
      if (has_constant_injection) {
        s << ", b" << cbv_index << ",space" << data->expected_constant_buffer_space;
        s << ", param_index: " << injection_index;
        s << ", slots : " << shader_injection_size;
      }
      if (has_descriptor_injection) {
        s << ", descriptor_index: " << descriptor_injection_index;
        s << ", descriptor_register: " << descriptor_register_index;
        s << ", descriptor_space: " << descriptor_register_space;
        s << ", descriptor_count: " << descriptor_count;
      }
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
        switch (params[param_index].type) {
          case reshade::api::pipeline_layout_param_type::push_constants:
            if (has_constant_injection && params[param_index].push_constants.dx_register_space == data->expected_constant_buffer_space) {
              injection_index = static_cast<int32_t>(param_index);
              cbv_index = params[param_index].push_constants.dx_register_index;
            }
            break;
          case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
            if (has_descriptor_injection && descriptor_range_count > 1u && params[param_index].descriptor_table.count == descriptor_range_count) {
              const auto matches_descriptor_range = [](const auto& lhs, const auto& rhs) {
                return lhs.binding == rhs.binding
                       && lhs.dx_register_index == rhs.dx_register_index
                       && lhs.dx_register_space == rhs.dx_register_space
                       && lhs.count == rhs.count
                       && lhs.type == rhs.type;
              };
              if (std::ranges::equal(
                      std::span(params[param_index].descriptor_table.ranges, descriptor_range_count),
                      std::span(descriptor_ranges, descriptor_range_count),
                      matches_descriptor_range)) {
                descriptor_injection_index = static_cast<int32_t>(param_index);
              }
            }
            break;
          case reshade::api::pipeline_layout_param_type::push_descriptors:
            if (has_descriptor_injection
                && params[param_index].push_descriptors.type == descriptor_type
                && params[param_index].push_descriptors.dx_register_index == static_cast<uint32_t>(descriptor_register_index)
                && params[param_index].push_descriptors.dx_register_space == descriptor_register_space
                && params[param_index].push_descriptors.count == descriptor_count) {
              descriptor_injection_index = static_cast<int32_t>(param_index);
            }
            break;
          default:
            break;
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
    if (has_constant_injection) {
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
  }

  {
    // Should update before fanning out to others and any pipeline creation
    utils::pipeline_layout::UpdatePipelineLayoutData(layout, [&](utils::pipeline_layout::PipelineLayoutData& pipeline_data) {
      pipeline_data.layout = layout;
      pipeline_data.replacement_layout = injection_layout;
      pipeline_data.injection_index = injection_index;
      pipeline_data.injection_layout = injection_layout;
      pipeline_data.injection_register_index = cbv_index;
      pipeline_data.descriptor_push_locations.clear();
      if (has_descriptor_injection && descriptor_injection_index != -1) {
        for (const auto& range : data->injected_descriptor_ranges) {
          for (uint32_t offset = 0u; offset < range.count; ++offset) {
            pipeline_data.descriptor_push_locations.insert_or_assign(
                {
                    range.type,
                    range.dx_register_index + offset,
                    range.dx_register_space,
                },
                utils::pipeline_layout::DescriptorPushLocation{
                    static_cast<uint32_t>(descriptor_injection_index),
                    range.binding + offset,
                });
          }
        }
      }
      pipeline_data.failed_injection = false;
    });
  }

  std::stringstream s;
  s << "mods::shader::OnInitPipelineLayout(";
  s << PRINT_PTR(layout.handle);
  s << ", injection index: " << injection_index;
  s << ", descriptor injection index: " << descriptor_injection_index;
  s << ", descriptor injection count: " << (has_descriptor_injection ? descriptor_count : 0u);
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
  if (!utils::pipeline_layout::GetPipelineLayoutData(layout, [&](const auto& layout_data) {
        cloned_layout = layout_data->injection_layout;
      })) {
    // not found
    return;
  }

#ifdef DEBUG_LEVEL_2
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

  if (!utils::pipeline_layout::GetPipelineLayoutData(layout, [&](const auto& layout_data) {
        cloned_layout = layout_data->injection_layout;
      })) {
    // not found
    return;
  }

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

  if (!utils::pipeline_layout::GetPipelineLayoutData(layout, [&](const auto& pipeline_data) {
        cloned_layout = pipeline_data->injection_layout;
      })) {
    // not found
    return;
  }

  for (uint32_t i = 0; i < count; ++i) {
#ifdef DEBUG_LEVEL_2
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
  DrawResponse response = {.bypass_draw = false};

  if (state.pipeline == 0u) return response;

  const auto& shader_hash = renodx::utils::shader::GetCurrentShaderHash(&state, index);
  if (shader_hash == 0u) return response;
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

    return response;  // move to next shader
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
      response.bypass_draw = true;
      return response;
    }
  }

  response.on_drawn = custom_shader_info.on_drawn;

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
      return response;
    }
  }

  bool should_inject = true;
  if (custom_shader_info.on_inject != nullptr) {
    should_inject = custom_shader_info.on_inject(cmd_list);
  }

  utils::shader::BuildReplacementPipeline(state.pipeline_details);

  // Perform Push
  if (shader_injection_size != 0 && should_inject) {
    if (state.pipeline_details->injection_layout == 0u || state.pipeline_details->injection_index == -1) {
#ifdef DEBUG_LEVEL_1
      utils::pipeline_layout::UpdatePipelineLayoutData(state.pipeline_details->layout, [&](utils::pipeline_layout::PipelineLayoutData& mutable_layout_data) {
        if (mutable_layout_data.failed_injection) return;
        mutable_layout_data.failed_injection = true;
        std::stringstream s;
        s << "mods::shader::PushShaderInjections(did not find modded pipeline root index";
        s << ", layout: " << PRINT_PTR(state.pipeline_details->layout.handle);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
      });
#endif
      return response;
    }

    renodx::utils::constants::PushShaderInjections(
        cmd_list,
        state.pipeline_details->injection_layout,
        static_cast<uint32_t>(state.pipeline_details->injection_index),
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
          response.injection_register_index = state.pipeline_details->injection_register_index;
          break;
        }
        default:
          break;
      }
    }
  }

  if (!custom_shader_info.views.empty()) {
    if (state.pipeline_details->injection_layout == 0u) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "mods::shader::HandleStatesAndBypass(";
      s << "descriptor push unavailable for shader ";
      s << PRINT_CRC32(custom_shader_info.crc32);
      s << ": injection layout missing";
      s << ", pipeline: " << PRINT_PTR(state.pipeline_details->pipeline.handle);
      s << ", original layout: " << PRINT_PTR(state.pipeline_details->layout.handle);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    } else if (state.pipeline_details->descriptor_push_locations.empty()) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "mods::shader::HandleStatesAndBypass(";
      s << "descriptor push unavailable for shader ";
      s << PRINT_CRC32(custom_shader_info.crc32);
      s << ": descriptor push locations missing";
      s << ", pipeline: " << PRINT_PTR(state.pipeline_details->pipeline.handle);
      s << ", injection layout: " << PRINT_PTR(state.pipeline_details->injection_layout.handle);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    } else {
      struct PendingViewPush {
        uint32_t layout_param = 0u;
        uint32_t binding = 0u;
        reshade::api::descriptor_type type = static_cast<reshade::api::descriptor_type>(0u);
        reshade::api::resource_view view = {0u};
      };

      std::vector<PendingViewPush> pending_view_pushes;
      pending_view_pushes.reserve(custom_shader_info.views.size());

      bool has_missing_view = false;
      for (const auto& view_binding : custom_shader_info.views) {
        const auto location_it = state.pipeline_details->descriptor_push_locations
                                     .find({view_binding.type, view_binding.slot, view_binding.space});
        if (location_it == state.pipeline_details->descriptor_push_locations.end()) {
#ifdef DEBUG_LEVEL_0
          std::stringstream s;
          s << "mods::shader::HandleStatesAndBypass(";
          s << "view binding location missing for shader ";
          s << PRINT_CRC32(custom_shader_info.crc32);
          s << ": type=" << view_binding.type;
          s << ", slot=" << view_binding.slot;
          s << ", space=" << view_binding.space;
          s << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
          has_missing_view = true;
          break;
        }

        assert(view_binding.get_view != nullptr);
        const auto view = view_binding.get_view(cmd_list);
        if (view.handle == 0u) {
#ifdef DEBUG_LEVEL_0
          std::stringstream s;
          s << "mods::shader::HandleStatesAndBypass(";
          s << "view binding returned null for shader ";
          s << PRINT_CRC32(custom_shader_info.crc32);
          s << ", slot=" << view_binding.slot;
          s << ", space=" << view_binding.space;
          s << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
          has_missing_view = true;
          break;
        }

        pending_view_pushes.push_back({
            .layout_param = location_it->second.first,
            .binding = location_it->second.second,
            .type = view_binding.type,
            .view = view,
        });
      }

      if (has_missing_view) {
        return response;
      }

      const auto descriptor_stages =
          index == renodx::utils::shader::COMPUTE_INDEX
              ? reshade::api::shader_stage::all_compute
              : reshade::api::shader_stage::all_graphics;

      std::ranges::sort(
          pending_view_pushes,
          [](const PendingViewPush& lhs, const PendingViewPush& rhs) {
            if (lhs.layout_param != rhs.layout_param) return lhs.layout_param < rhs.layout_param;
            if (lhs.type != rhs.type) return lhs.type < rhs.type;
            return lhs.binding < rhs.binding;
          });

      std::vector<reshade::api::resource_view> descriptor_views;
      descriptor_views.reserve(pending_view_pushes.size());
      size_t span_begin = 0u;
      while (span_begin < pending_view_pushes.size()) {
        const auto& first_view_push = pending_view_pushes[span_begin];
        descriptor_views.clear();
        descriptor_views.push_back(first_view_push.view);

        size_t span_end = span_begin + 1u;
        uint32_t previous_binding = first_view_push.binding;
        while (span_end < pending_view_pushes.size()) {
          const auto& next_view_push = pending_view_pushes[span_end];
          if (next_view_push.layout_param != first_view_push.layout_param
              || next_view_push.type != first_view_push.type
              || next_view_push.binding != previous_binding + 1u) {
            break;
          }
          descriptor_views.push_back(next_view_push.view);
          previous_binding = next_view_push.binding;
          ++span_end;
        }

        cmd_list->push_descriptors(
            descriptor_stages,
            state.pipeline_details->injection_layout,
            first_view_push.layout_param,
            reshade::api::descriptor_table_update{
                .table = {},
                .binding = first_view_push.binding,
                .array_offset = 0,
                .count = static_cast<uint32_t>(descriptor_views.size()),
                .type = first_view_push.type,
                .descriptors = descriptor_views.data(),
            });

        span_begin = span_end;
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

inline bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
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
      if (details != nullptr && details->injection_layout != 0u && details->injection_index != -1) {
        renodx::utils::constants::PushShaderInjections(
            cmd_list,
            details->injection_layout,
            static_cast<uint32_t>(details->injection_index),
            false,
            {shader_injection, shader_injection_size});
      }
    }
  }
}

static bool attached = false;

template <typename T = float*, std::ranges::range CustomShaderList>
  requires std::convertible_to<std::ranges::range_value_t<CustomShaderList>, CustomShader>
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
      for (const auto& custom_shader : new_custom_shaders) {
        custom_shaders.emplace(custom_shader.crc32, custom_shader);
        if (custom_shader.on_replace != nullptr) using_custom_replace = true;
        if (custom_shader.on_inject != nullptr) using_custom_inject = true;
        if (custom_shader.index != -1) using_counted_shaders = true;
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
          for (const auto& [hash, shader] : (custom_shaders)) {
            for (const auto& [device, code] : shader.code_by_device) {
              renodx::utils::shader::UpdateReplacements({{hash, code}}, false, true, {device});
            }
            if (!shader.code.empty()) {
              renodx::utils::shader::QueueRuntimeReplacement(hash, shader.code);
            }
          }
        } else {
          for (const auto& [hash, shader] : (custom_shaders)) {
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

template <typename T = float*, std::ranges::range CustomShaderPairs>
  requires std::convertible_to<std::ranges::range_value_t<CustomShaderPairs>, std::pair<uint32_t, CustomShader>>
static void Use(DWORD fdw_reason, const CustomShaderPairs& new_custom_shaders, T* new_injections = nullptr) {
  std::vector<CustomShader> shaders;
  shaders.reserve(new_custom_shaders.size());
  for (const auto& pair : new_custom_shaders) {
    shaders.push_back(pair.second);
  }
  Use<T>(fdw_reason, shaders, new_injections);
}

}  // namespace renodx::mods::shader