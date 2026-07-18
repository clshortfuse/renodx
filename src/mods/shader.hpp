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
#include <optional>
#include <span>
#include <sstream>
#include <unordered_map>
#include <vector>

#include <include/reshade.hpp>

#include "../utils/command_action.hpp"
#include "../utils/constants.hpp"
#include "../utils/data.hpp"
#include "../utils/descriptor.hpp"
#include "../utils/device.hpp"
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

inline CustomShader CreateOpenGLVulkanShader(
    std::uint32_t crc32,
    std::span<const std::uint8_t> gl_code,
    std::span<const std::uint8_t> vk_code) {
  CustomShader shader = {};
  shader.crc32 = crc32;
  shader.code_by_device = {
      {reshade::api::device_api::opengl, gl_code},
      {reshade::api::device_api::vulkan, vk_code},
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
#define CustomOpenGLVulkanShaders(__crc32__)                     \
  {                                                              \
      __crc32__, renodx::mods::shader::CreateOpenGLVulkanShader( \
                     __crc32__,                                  \
                     RENODX_JOIN_MACRO(__##__crc32__, _gl),      \
                     RENODX_JOIN_MACRO(__##__crc32__, _vk))}

static thread_local std::vector<reshade::api::pipeline_layout_param*> created_params;
static thread_local std::unordered_map<uint32_t, reshade::api::pipeline_layout_param*> rebuilt_params;

static float* shader_injection = nullptr;
static size_t shader_injection_size = 0;
static bool use_pipeline_layout_cloning = false;
static bool manual_shader_scheduling = false;
static bool force_pipeline_cloning = false;
[[deprecated]] static bool trace_unmodified_shaders = false;  // Deprecated/dead no-op.
static bool allow_multiple_push_constants = false;
static bool push_injections_on_present = false;
static bool revert_constant_buffer_ranges = false;
// static bool force_align_constant_buffers_to_16 = false; // Might need it in the future
static float* resource_tag_float = nullptr;
static int32_t expected_constant_buffer_index = -1;
static uint32_t expected_constant_buffer_space = 0;
static uint32_t constant_buffer_offset = 0;
static auto minimum_constant_buffer_stages = reshade::api::shader_stage::pixel | reshade::api::shader_stage::compute;

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
  std::vector<std::vector<reshade::api::descriptor_range>> injected_descriptor_range_groups;
  std::vector<reshade::api::pipeline_layout_param> injected_descriptor_params;
};

static void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::shader::OnInitDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  auto* data = renodx::utils::data::Create<DeviceData>(device);
  data->expected_constant_buffer_index = expected_constant_buffer_index;
  data->injected_descriptor_range_groups.clear();
  data->injected_descriptor_params.clear();

  const auto device_api = device->get_api();
  if (device_api == reshade::api::device_api::vulkan) {
    std::map<std::pair<uint32_t, reshade::api::descriptor_type>, reshade::api::descriptor_range> descriptor_ranges_by_set;
    uint32_t max_space = 0u;

    for (const auto& [shader_hash, custom_shader] : custom_shaders) {
      (void)shader_hash;
      for (const auto& view_binding : custom_shader.views) {
        assert(view_binding.get_view != nullptr);

        const auto key = std::make_pair(view_binding.space, view_binding.type);
        auto range_it = descriptor_ranges_by_set.find(key);

        if (range_it == descriptor_ranges_by_set.end()) {
          descriptor_ranges_by_set[key] = {
              .binding = view_binding.slot,
              .dx_register_index = view_binding.slot,
              .dx_register_space = view_binding.space,
              .count = 1u,
              .visibility = reshade::api::shader_stage::all,
              .array_size = 1u,
              .type = view_binding.type,
          };
        } else {
          auto& range = range_it->second;
          const uint32_t min_slot = std::min(range.binding, view_binding.slot);
          const uint32_t max_slot = std::max(range.binding + range.count - 1u, view_binding.slot);
          range.binding = min_slot;
          range.dx_register_index = min_slot;
          range.count = max_slot - min_slot + 1u;
        }

        max_space = std::max(max_space, view_binding.space);
      }
    }

    if (!descriptor_ranges_by_set.empty()) {
      data->injected_descriptor_range_groups.resize(max_space + 1);
      for (auto& [key, range] : descriptor_ranges_by_set) {
        data->injected_descriptor_range_groups[key.first].push_back(range);
      }

      data->injected_descriptor_params.reserve(max_space + 1);
      for (uint32_t set = 0; set <= max_space; ++set) {
        const auto& ranges = data->injected_descriptor_range_groups[set];
        if (ranges.empty()) {
          data->injected_descriptor_params.emplace_back(
              static_cast<uint32_t>(0u),
              static_cast<const reshade::api::descriptor_range*>(nullptr));
        } else {
          data->injected_descriptor_params.emplace_back(static_cast<uint32_t>(ranges.size()), ranges.data());
        }
      }
    }
  } else {
    std::vector<reshade::api::descriptor_range> ranges;
    for (const auto& [shader_hash, custom_shader] : custom_shaders) {
      (void)shader_hash;
      for (const auto& view_binding : custom_shader.views) {
        assert(view_binding.get_view != nullptr);

        auto range_it = std::ranges::find_if(
            ranges,
            [&](const reshade::api::descriptor_range& range) {
              return range.type == view_binding.type
                     && range.dx_register_space == view_binding.space;
            });

        if (range_it == ranges.end()) {
          ranges.push_back({
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
        ranges,
        [](const reshade::api::descriptor_range& lhs, const reshade::api::descriptor_range& rhs) {
          if (lhs.type != rhs.type) return lhs.type < rhs.type;
          if (lhs.dx_register_space != rhs.dx_register_space) return lhs.dx_register_space < rhs.dx_register_space;
          return lhs.dx_register_index < rhs.dx_register_index;
        });

    uint32_t binding = 0u;
    for (auto& range : ranges) {
      range.binding = binding;
      binding += range.count;  // Vulkan first range gets binding 0, second one gets binding 2
    }

    if (!ranges.empty()) {
      if (ranges.size() > 1u) {
        reshade::api::pipeline_layout_param descriptor_param = {};
        descriptor_param.type = reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges;
        descriptor_param.descriptor_table.count = static_cast<uint32_t>(ranges.size());
        descriptor_param.descriptor_table.ranges = ranges.data();
        data->injected_descriptor_range_groups.resize(1);
        data->injected_descriptor_range_groups[0] = ranges;
        data->injected_descriptor_params.emplace_back(descriptor_param);
      } else {
        data->injected_descriptor_range_groups.resize(1);
        data->injected_descriptor_range_groups[0] = ranges;
        data->injected_descriptor_params.emplace_back(reshade::api::pipeline_layout_param(
            reshade::api::descriptor_range{
                .binding = 0,
                .dx_register_index = ranges.front().dx_register_index,
                .dx_register_space = ranges.front().dx_register_space,
                .count = binding,
                .visibility = reshade::api::shader_stage::all,
                .array_size = 1,
                .type = ranges.front().type,
            }));
      }
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

// Merge Vulkan descriptor parameters by expanding ranges instead of replacing
static void MergeVulkanDescriptorParameters(
    const std::vector<reshade::api::pipeline_layout_param>& injected_params,
    const std::vector<uint32_t>& existing_set_param_indexes,
    reshade::api::pipeline_layout_param* new_params) {
  const auto existing_sets = static_cast<uint32_t>(existing_set_param_indexes.size());
  for (uint32_t set_index = 0; set_index < injected_params.size() && set_index < existing_sets; ++set_index) {
    const auto& injected_param = injected_params[set_index];
    if (injected_param.descriptor_table.count == 0u) continue;  // empty placeholder set, nothing to merge

    auto& original_param = new_params[existing_set_param_indexes[set_index]];

    // For Vulkan, only merge descriptor tables (push descriptors are not used)
    // This is conservative by design, modders should append new sets
    if (original_param.type == reshade::api::pipeline_layout_param_type::descriptor_table
        && injected_param.type == reshade::api::pipeline_layout_param_type::descriptor_table
        && original_param.descriptor_table.count == 1u
        && injected_param.descriptor_table.count == 1u) {
      auto& orig_range = const_cast<reshade::api::descriptor_range&>(original_param.descriptor_table.ranges[0]);
      const auto& inj_range = injected_param.descriptor_table.ranges[0];
      if (orig_range.type == inj_range.type && orig_range.binding == inj_range.binding) {
        const uint32_t min_binding = std::min(orig_range.binding, inj_range.binding);
        const uint32_t max_binding = std::max(
            orig_range.binding + orig_range.count - 1u,
            inj_range.binding + inj_range.count - 1u);
        orig_range.binding = min_binding;
        orig_range.dx_register_index = min_binding;
        orig_range.count = max_binding - min_binding + 1u;
        continue;
      }
    }

    // Otherwise, leave the existing Vulkan set unchanged. Replacing it breaks compatibility
    // with descriptor sets the game allocates and binds for that set.
  }
}

static std::vector<uint32_t> GetVulkanDescriptorSetParamIndexes(
    const reshade::api::pipeline_layout_param* params,
    uint32_t param_count) {
  std::vector<uint32_t> indexes;
  indexes.reserve(param_count);
  for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
    if (params[param_index].type != reshade::api::pipeline_layout_param_type::push_constants) {
      indexes.push_back(param_index);
    }
  }
  return indexes;
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
  uint32_t vk_pc_offset = 0;
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
  bool is_vulkan = device_api == reshade::api::device_api::vulkan;

  // Track existing push constant range (for Vulkan) so we can extend it
  int32_t vk_expand_pc_index = -1;
  // all shader stages include properietary stages (e.g. Huawei)
  auto pc_unused_stages = is_vulkan ? minimum_constant_buffer_stages : reshade::api::shader_stage::all;
  auto found_full_stage_pc_match = false;

  auto scan_vulkan_pc = [&](const reshade::api::pipeline_layout_param& param, uint32_t param_index) {
    if (!found_full_stage_pc_match) {
      const auto& current_visibility = param.push_constants.visibility;
      // pc param has all relevant stages
      found_full_stage_pc_match = renodx::utils::bitwise::HasFlag(current_visibility, minimum_constant_buffer_stages);

      pc_unused_stages = renodx::utils::bitwise::UnsetFlag(pc_unused_stages, current_visibility);
      // TODO(Ritsu): Handle multiple PCs with single flags (e.g. PC0 compute only, PC1 pixel only)
      // If a pipeline has at least one of the stages
      if (found_full_stage_pc_match || renodx::utils::bitwise::HasAnyFlag(current_visibility, minimum_constant_buffer_stages)) {
        vk_expand_pc_index = param_index;
      }
    }
  };

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
      pc_count++;
      if (is_dx
          && param.push_constants.dx_register_space == data->expected_constant_buffer_space
          && cbv_index < param.push_constants.dx_register_index + param.push_constants.count) {
        cbv_index = param.push_constants.dx_register_index + param.push_constants.count;
      } else if (is_vulkan) {
        vk_pc_offset = std::max(
            vk_pc_offset,
            param.push_constants.binding + param.push_constants.count);
        scan_vulkan_pc(param, param_index);
      } else {
        dword_count += param.push_constants.count;
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

  const bool expand_vulkan_push_constants = is_vulkan && vk_expand_pc_index != -1 && found_full_stage_pc_match;

  if (pc_count != 0 && !allow_multiple_push_constants && !expand_vulkan_push_constants) {
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
  const bool has_descriptor_injection = data != nullptr && !data->injected_descriptor_params.empty();

  if (has_descriptor_injection && !is_vulkan) {
    descriptor_ranges = data->injected_descriptor_range_groups[0].data();
    descriptor_range_count = static_cast<uint32_t>(data->injected_descriptor_range_groups[0].size());
    descriptor_type = data->injected_descriptor_range_groups[0].front().type;
    descriptor_register_index = static_cast<int32_t>(data->injected_descriptor_range_groups[0].front().dx_register_index);
    descriptor_register_space = data->injected_descriptor_range_groups[0].front().dx_register_space;
    for (const auto& range : data->injected_descriptor_range_groups[0]) {
      descriptor_count += range.count;
    }
  }
  const auto* injected_descriptor_param = has_descriptor_injection && !is_vulkan ? data->injected_descriptor_params.data() : nullptr;
  assert(!has_descriptor_injection || injected_descriptor_param != nullptr || (is_vulkan && has_descriptor_injection));

  const bool has_constant_injection = shader_injection_size != 0u;
  uint32_t existing_set_count = 0u;
  if (is_vulkan && has_descriptor_injection) {
    for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
      if (params[param_index].type != reshade::api::pipeline_layout_param_type::push_constants) {
        existing_set_count++;
      }
    }
  }

  uint32_t added_descriptor_param_count = 0u;
  if (has_descriptor_injection) {
    if (is_vulkan) {
      added_descriptor_param_count = data->injected_descriptor_params.size() > existing_set_count
                                         ? static_cast<uint32_t>(data->injected_descriptor_params.size() - existing_set_count)
                                         : 0u;
    } else {
      added_descriptor_param_count = 1u;
    }
  }
  const uint32_t added_params =
      (has_constant_injection && !expand_vulkan_push_constants ? 1u : 0u)
      + added_descriptor_param_count;
  if (!has_descriptor_injection && added_params == 0u && !expand_vulkan_push_constants) {
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
  if (has_descriptor_injection && !is_vulkan) {
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

  if (has_descriptor_injection && is_vulkan) {
    const auto existing_set_param_indexes = GetVulkanDescriptorSetParamIndexes(params, old_count);

    MergeVulkanDescriptorParameters(data->injected_descriptor_params, existing_set_param_indexes, new_params);

    // New Vulkan sets are appended later once the injection index is known.
  }

  if (has_constant_injection) {
    if (expand_vulkan_push_constants) {
#ifdef DEBUG_LEVEL_1
      // Vulkan expand PC: injection_index must point to an existing push constant param.
      assert(static_cast<uint32_t>(vk_expand_pc_index) < old_count && "Vulkan expand PC index out of bounds.");
      assert(params[vk_expand_pc_index].type == reshade::api::pipeline_layout_param_type::push_constants && "Vulkan expand PC target is not a push constant param.");
#endif
      injection_index = static_cast<uint32_t>(vk_expand_pc_index);
    } else {
      injection_index = insert_index++;
    }

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
    if (expand_vulkan_push_constants) {
      new_params[injection_index].push_constants.count += constant_injection_cost;
    } else {
      new_params[injection_index] = reshade::api::pipeline_layout_param(
          reshade::api::constant_range{
              .binding = is_vulkan ? vk_pc_offset : 0,
              .dx_register_index = cbv_index,
              .dx_register_space = data->expected_constant_buffer_space,
              .count = constant_injection_cost,
              .visibility = is_vulkan ? pc_unused_stages : reshade::api::shader_stage::all,
          });
    }

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
    descriptor_injection_index = insert_index;
    if (is_vulkan) {
      // For Vulkan: Add empty descriptor params for sets beyond the existing sets
      const uint32_t existing_sets = existing_set_count;
      for (uint32_t set_index = existing_sets; set_index < data->injected_descriptor_params.size(); ++set_index) {
        new_params[insert_index++] = data->injected_descriptor_params[set_index];
      }
    } else {
      // For DX: Add only the first descriptor param
      new_params[descriptor_injection_index] = *injected_descriptor_param;
      insert_index++;
    }
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
    if (is_vulkan) {
      s << "will insert vulkan descriptor sets from " << descriptor_injection_index;
      s << " count " << data->injected_descriptor_params.size();
    } else {
      s << "will insert descriptor type " << descriptor_type;
      s << " at root_index " << descriptor_injection_index;
      s << " mapped to register " << descriptor_register_index;
      s << " space " << descriptor_register_space;
      s << " count " << descriptor_count;
    }
  }
  s << " creating new size of " << new_count;
  if (device_api == reshade::api::device_api::d3d12) {
    s << ", root_dwords: " << dword_count << " => " << final_dword_count;
    s << ", constant_injection_cost: " << constant_injection_cost;
    s << ", descriptor_injection_cost: " << descriptor_injection_cost;
  } else if (is_vulkan && (has_constant_injection || has_descriptor_injection)) {
    s << ", vulkan_binding_offset: " << vk_pc_offset;
    if (has_descriptor_injection) {
      s << ", descriptor_sets: " << data->injected_descriptor_params.size();
    }
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
  const auto original_layout = layout;
  if (on_init_pipeline_layout != nullptr) {
    if (!on_init_pipeline_layout(device, layout, {params, param_count})) return;
  }
  int32_t injection_index = -1;
  int32_t descriptor_injection_index = -1;
  int32_t injection_constant_buffer_offset = 0;
  auto device_api = device->get_api();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;

  uint32_t cbv_index = 0;
  uint32_t pc_count = 0;
  uint32_t pdss_index = -1;
  uint32_t dword_count = 0;
  uint32_t vk_pc_offset = 0;

  bool is_dx = (device_api == reshade::api::device_api::d3d9
                || device_api == reshade::api::device_api::d3d11
                || device_api == reshade::api::device_api::d3d12);
  bool is_vulkan = device_api == reshade::api::device_api::vulkan;
  int32_t vk_expand_pc_index = -1;
  auto pc_unused_stages = is_vulkan ? minimum_constant_buffer_stages : reshade::api::shader_stage::all;
  auto found_full_stage_pc_match = false;
  auto descriptor_type = static_cast<reshade::api::descriptor_type>(0u);
  int32_t descriptor_register_index = 0;
  uint32_t descriptor_register_space = 50u;
  uint32_t descriptor_count = 0u;
  const reshade::api::descriptor_range* descriptor_ranges = nullptr;
  uint32_t descriptor_range_count = 0u;
  const bool has_descriptor_injection = data != nullptr && !data->injected_descriptor_params.empty();
  if (has_descriptor_injection && !is_vulkan) {
    descriptor_ranges = data->injected_descriptor_range_groups[0].data();
    descriptor_range_count = static_cast<uint32_t>(data->injected_descriptor_range_groups[0].size());
    if (descriptor_range_count > 0u) {
      descriptor_type = data->injected_descriptor_range_groups[0].front().type;
      descriptor_register_index = static_cast<int32_t>(data->injected_descriptor_range_groups[0].front().dx_register_index);
      descriptor_register_space = data->injected_descriptor_range_groups[0].front().dx_register_space;
      for (const auto& range : data->injected_descriptor_range_groups[0]) {
        descriptor_count += range.count;
      }
    }
  }
  const auto* injected_descriptor_param = has_descriptor_injection && !is_vulkan ? data->injected_descriptor_params.data() : nullptr;
  assert(!has_descriptor_injection || injected_descriptor_param != nullptr || (is_vulkan && has_descriptor_injection));

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

      if (is_vulkan) {
        vk_pc_offset = std::max(
            vk_pc_offset,
            param.push_constants.binding + param.push_constants.count);
        if (!found_full_stage_pc_match) {
          const auto& current_visibility = param.push_constants.visibility;
          found_full_stage_pc_match = renodx::utils::bitwise::HasFlag(current_visibility, minimum_constant_buffer_stages);

          pc_unused_stages = renodx::utils::bitwise::UnsetFlag(pc_unused_stages, current_visibility);
          if (found_full_stage_pc_match || renodx::utils::bitwise::HasAnyFlag(current_visibility, minimum_constant_buffer_stages)) {
            vk_expand_pc_index = param_index;
          }
        }
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
  const bool expand_vulkan_push_constants = is_vulkan && vk_expand_pc_index != -1 && found_full_stage_pc_match;
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

  } else if (device_api == reshade::api::device_api::d3d12
             || device_api == reshade::api::device_api::vulkan) {
    if (data->use_pipeline_layout_cloning) {
      const uint32_t old_count = param_count;
      uint32_t new_count = old_count;
      reshade::api::pipeline_layout_param* new_params = nullptr;
      const auto existing_set_param_indexes = is_vulkan
                      ? GetVulkanDescriptorSetParamIndexes(params, old_count)
                                                  : std::vector<uint32_t>{};
      const auto existing_set_count = static_cast<uint32_t>(existing_set_param_indexes.size());
      uint32_t added_descriptor_param_count = 0u;
      if (has_descriptor_injection) {
        if (is_vulkan) {
          added_descriptor_param_count = data->injected_descriptor_params.size() > existing_set_count
                                             ? static_cast<uint32_t>(data->injected_descriptor_params.size() - existing_set_count)
                                             : 0u;
        } else {
          added_descriptor_param_count = 1u;
        }
      }
      const uint32_t added_params =
          (has_constant_injection && !expand_vulkan_push_constants ? 1u : 0u)
          + added_descriptor_param_count;
      if (added_params != 0u || (has_constant_injection && expand_vulkan_push_constants)) {
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

        // Merge descriptor parameters for Vulkan when cloning
        if (is_vulkan && has_descriptor_injection) {
          MergeVulkanDescriptorParameters(data->injected_descriptor_params, existing_set_param_indexes, new_params);
        }

        if (has_constant_injection) {
          if (expand_vulkan_push_constants) {
            injection_index = vk_expand_pc_index;
          } else {
            injection_index = static_cast<int32_t>(insert_index++);
          }

          const uint32_t slots = shader_injection_size;
          uint32_t descriptor_injection_cost = 0u;
          if (has_descriptor_injection && !is_vulkan) {
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
          uint32_t remaining_dword_count = slots;
          if (device_api == reshade::api::device_api::d3d12) {
            const uint32_t used_dword_count = dword_count + descriptor_injection_cost;
            remaining_dword_count = used_dword_count >= 64u ? 0u : 64u - used_dword_count;
          }

          if (expand_vulkan_push_constants) {
            new_params[injection_index].push_constants.count += std::min(slots, remaining_dword_count);
          } else {
            new_params[injection_index] = reshade::api::pipeline_layout_param(
                reshade::api::constant_range{
                    .binding = is_vulkan ? vk_pc_offset : 0,
                    .dx_register_index = cbv_index,
                    .dx_register_space = data->expected_constant_buffer_space,
                    .count = std::min(slots, remaining_dword_count),
                    .visibility = is_vulkan ? pc_unused_stages : reshade::api::shader_stage::all,
                });
          }
          if (is_vulkan) {
            const auto& injection_param = new_params[injection_index].push_constants;
            injection_constant_buffer_offset = static_cast<int32_t>(
                expand_vulkan_push_constants
                    ? injection_param.binding + injection_param.count - std::min(slots, remaining_dword_count)
                    : injection_param.binding);
          }

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
          descriptor_injection_index = static_cast<int32_t>(insert_index);
          if (is_vulkan) {
            descriptor_injection_index = static_cast<int32_t>(existing_set_count);
            for (uint32_t set_index = existing_set_count; set_index < data->injected_descriptor_params.size(); ++set_index) {
              new_params[insert_index++] = data->injected_descriptor_params[set_index];
            }
          } else {
            // For DX: Add the single descriptor param
            new_params[insert_index++] = *injected_descriptor_param;
          }
        }
      } else {
        new_params = reinterpret_cast<reshade::api::pipeline_layout_param*>(malloc(sizeof(reshade::api::pipeline_layout_param) * old_count));
        memcpy(new_params, params, sizeof(reshade::api::pipeline_layout_param) * old_count);
      }

      {
        std::stringstream s;
        s << "mods::shader::OnInitPipelineLayout(Cloning D3D12/Vulkan Layout ";
        s << PRINT_PTR(layout.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      }

      auto result = device->create_pipeline_layout(new_count, &new_params[0], &injection_layout);
      free(new_params);
      new_params = nullptr;
      std::stringstream s;
      s << "mods::shader::OnInitPipelineLayout(Cloning D3D12/Vulkan Layout ";
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
        if (is_vulkan) {
          s << ", descriptor_sets: " << data->injected_descriptor_params.size();
        } else {
          s << ", descriptor_register: " << descriptor_register_index;
          s << ", descriptor_space: " << descriptor_register_space;
          s << ", descriptor_count: " << descriptor_count;
        }
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
      uint32_t vk_injection_end = 0u;
      uint32_t current_set_index = 0u;
      for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
        switch (params[param_index].type) {
          case reshade::api::pipeline_layout_param_type::push_constants:
            if (is_vulkan) {
              vk_injection_end = std::max(
                  vk_injection_end,
                  params[param_index].push_constants.binding + params[param_index].push_constants.count);
            } else if (has_constant_injection && params[param_index].push_constants.dx_register_space == data->expected_constant_buffer_space) {
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
                descriptor_injection_index = static_cast<int32_t>(is_vulkan ? current_set_index : param_index);
              }
            }
            break;
          case reshade::api::pipeline_layout_param_type::push_descriptors:
            if (has_descriptor_injection
                && params[param_index].push_descriptors.type == descriptor_type
                && params[param_index].push_descriptors.dx_register_index == static_cast<uint32_t>(descriptor_register_index)
                && params[param_index].push_descriptors.dx_register_space == descriptor_register_space
                && params[param_index].push_descriptors.count == descriptor_count) {
              descriptor_injection_index = static_cast<int32_t>(is_vulkan ? current_set_index : param_index);
            }
            break;
          default:
            break;
        }
        if (is_vulkan && params[param_index].type != reshade::api::pipeline_layout_param_type::push_constants) {
          current_set_index++;
        }
      }

      // Releasing params will break other addons that listen for init_pipeline_layout (eg: devkit)
      rebuilt_params[layout.handle] = created_params.back();
      created_params.pop_back();

      if (is_vulkan && has_constant_injection) {
        for (uint32_t param_index = 0; param_index < param_count; ++param_index) {
          if (params[param_index].type != reshade::api::pipeline_layout_param_type::push_constants) continue;
          const auto& push_constants = params[param_index].push_constants;
          if (push_constants.binding + push_constants.count == vk_injection_end
              && push_constants.count >= shader_injection_size
              && renodx::utils::bitwise::HasAnyFlag(push_constants.visibility, minimum_constant_buffer_stages)) {
            injection_index = static_cast<int32_t>(param_index);
            break;
          }
        }
      }

      if (has_constant_injection && injection_index == -1) {
        std::stringstream s;
        s << "mods::shader::OnInitPipelineLayout(";
        s << "Injection index not found for ";
        s << PRINT_PTR(layout.handle);
        s << " )";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        return;
      }
      if (is_vulkan && has_constant_injection) {
        const auto& injection_param = params[injection_index];
        const auto binding = static_cast<int32_t>(injection_param.push_constants.binding);
        const auto count = static_cast<int32_t>(injection_param.push_constants.count);
        const auto slots = static_cast<int32_t>(shader_injection_size);
        // Expanded range keeps old binding and increases count; appended range's binding is already the injection offset.
        injection_constant_buffer_offset = count > slots
                                               ? (binding + count - slots)
                                               : binding;
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
      pipeline_data.injection_constant_buffer_offset = injection_constant_buffer_offset;
      pipeline_data.descriptor_push_locations.clear();
      if (has_descriptor_injection && (is_vulkan || descriptor_injection_index != -1)) {
        if (is_vulkan) {
          for (uint32_t set_index = 0u; set_index < data->injected_descriptor_range_groups.size(); ++set_index) {
            const auto& ranges = data->injected_descriptor_range_groups[set_index];
            for (const auto& range : ranges) {
              for (uint32_t offset = 0u; offset < range.count; ++offset) {
                pipeline_data.descriptor_push_locations.insert_or_assign(
                    {
                        range.type,
                        range.dx_register_index + offset,
                        range.dx_register_space,
                    },
                    utils::pipeline_layout::DescriptorPushLocation{
                        set_index,
                        range.binding + offset,
                    });
              }
            }
          }
        } else {
          // For DX: Track locations for the single set (set 0)
          for (const auto& range : data->injected_descriptor_range_groups[0]) {
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
      }
      pipeline_data.failed_injection = false;
    });
  }

  std::stringstream s;
  s << "mods::shader::OnInitPipelineLayout(";
  s << PRINT_PTR(original_layout.handle);
  s << ", injection index: " << injection_index;
  s << ", descriptor injection index: " << descriptor_injection_index;
  s << ", descriptor injection count: " << (has_descriptor_injection ? descriptor_count : 0u);
  s << ", injection layout: " << PRINT_PTR(injection_layout.handle);
  if (is_vulkan) {
    s << ", injection offset: " << injection_constant_buffer_offset;
  }
  if (is_dx) {
    s << ", cbvIndex: " << cbv_index;
  }
  s << ")";
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
    const bool found_layout_data = utils::pipeline_layout::GetPipelineLayoutData(layout, [&](const auto* pipeline_layout_data) {
      cloned_layout = pipeline_layout_data->replacement_layout;
    });
    if (!found_layout_data) return;
    if (cloned_layout == 0u) return;
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
  const bool is_vulkan = cmd_list->get_device()->get_api() == reshade::api::device_api::vulkan;
  reshade::api::pipeline_layout cloned_layout;
  {
    const bool found_layout_data = utils::pipeline_layout::GetPipelineLayoutData(layout, [&](const auto* pipeline_layout_data) {
      cloned_layout = pipeline_layout_data->replacement_layout;
    });
    if (!found_layout_data) return;
    if (cloned_layout == 0u) return;
  }

  cmd_list->push_descriptors(stages, cloned_layout, layout_param, update);
  if (!is_vulkan) {
    // Pushing twice messes up Vulkan's descriptors, unlike DX12
    cmd_list->push_descriptors(stages, layout, layout_param, update);
  }
}

inline void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  const bool is_vulkan = cmd_list->get_device()->get_api() == reshade::api::device_api::vulkan;
  reshade::api::pipeline_layout cloned_layout;
  {
    const bool found_layout_data = utils::pipeline_layout::GetPipelineLayoutData(layout, [&](const auto* pipeline_layout_data) {
      cloned_layout = pipeline_layout_data->replacement_layout;
    });
    if (!found_layout_data) return;
    if (cloned_layout == 0u) return;
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
    if (!is_vulkan) {
      // Avoid replacing in vulkan
      cmd_list->bind_descriptor_table(stages, layout, (first + i), tables[i]);
    }
  }
}

inline constexpr auto OnCommandAction = []<typename T, typename Context>(
                                            Context& context) -> renodx::utils::command_action::CallbackResult<Context> {
  struct DrawResponse {
    bool bypass_draw = false;
    const std::function<void(reshade::api::command_list*)>* on_drawn = nullptr;
    bool revert_constant_buffer_range = false;
  };

  auto* shader_state = renodx::utils::command_action::GetShaderState(&context);
  assert(shader_state != nullptr);
  if (shader_state == nullptr) return {};

  const bool is_dispatch = context.IsDispatch();
  float resource_tag = -1;
  if (!is_dispatch && resource_tag_float != nullptr) {
    auto* swapchain_state = renodx::utils::command_action::GetSwapchainState(&context);
    if (swapchain_state == nullptr) {
      reshade::log::message(reshade::log::level::error, "mods::shader::OnCommandAction(swapchain state is null)");
    } else if (!swapchain_state->current_render_targets.empty()) {
      resource_tag = renodx::utils::resource::GetResourceTag(swapchain_state->current_render_targets.at(0));
    }
  }

  const auto handle_stage = [&](renodx::utils::shader::ShaderStageIndex shader_stage, uint32_t matched_shader_hash = 0u, const CustomShader* matched_custom_shader = nullptr) -> DrawResponse {
    auto& state = shader_state->stage_states[shader_stage];
    DrawResponse response = {};

    if (state.pipeline == 0u) return response;

    renodx::utils::shader::PopulateStageState(&state);
    if (state.pipeline_details == nullptr) return response;

    const uint32_t state_shader_hash = state.pipeline_details->compatible_shader_infos[shader_stage].shader_hash;
    assert(matched_shader_hash == 0u || matched_shader_hash == state_shader_hash);
    const uint32_t shader_hash = matched_shader_hash != 0u ? matched_shader_hash : state_shader_hash;
    if (shader_hash == 0u) return response;

    const CustomShader* custom_shader_info = matched_custom_shader;
    if (custom_shader_info == nullptr) {
      const auto custom_shader_it = custom_shaders.find(shader_hash);
      if (custom_shader_it == custom_shaders.end()) return response;
      custom_shader_info = &custom_shader_it->second;
    }

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::shader::OnCommandAction(found shader: ";
    s << PRINT_CRC32(shader_hash);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

    if (custom_shader_info->on_draw != nullptr) {
      bool should_draw = custom_shader_info->on_draw(context.cmd_list);
      if (!should_draw) {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::shader::OnCommandAction(bypass draw: ";
        s << PRINT_CRC32(shader_hash);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        response.bypass_draw = true;
        return response;
      }
    }

    if (custom_shader_info->on_drawn != nullptr) {
      response.on_drawn = &custom_shader_info->on_drawn;
    }

    if (custom_shader_info->on_replace != nullptr) {
      bool should_replace = custom_shader_info->on_replace(context.cmd_list);
      if (!should_replace) {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::shader::OnCommandAction(Not replacing: ";
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
    if (custom_shader_info->on_inject != nullptr) {
      should_inject = custom_shader_info->on_inject(context.cmd_list);
    }

    utils::shader::BuildReplacementPipeline(state.pipeline_details);

    // Perform Push
    if (shader_injection_size != 0 && should_inject) {
      if (state.pipeline_details->injection_layout == 0u || state.pipeline_details->injection_index == -1) {
        assert(false && "custom shader injection requested but injection layout/index is missing");
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

      auto visibility = reshade::api::shader_stage::all;
      if (!use_pipeline_layout_cloning) {
        visibility = state.pipeline_details->injection_visibility;
      }
      const uint32_t injection_offset = constant_buffer_offset != 0
                                          ? constant_buffer_offset
                                          : state.pipeline_details->injection_constant_buffer_offset;
      renodx::utils::constants::PushShaderInjections(
          context.cmd_list,
          state.pipeline_details->injection_layout,
          static_cast<uint32_t>(state.pipeline_details->injection_index),
          shader_stage == renodx::utils::shader::COMPUTE_INDEX,
          {shader_injection, shader_injection_size},
          injection_offset,
          resource_tag_float,
          resource_tag,
          visibility);
      if (revert_constant_buffer_ranges) {
        switch (context.cmd_list->get_device()->get_api()) {
          case reshade::api::device_api::d3d10:
          case reshade::api::device_api::d3d11:
          case reshade::api::device_api::d3d12: {
            response.revert_constant_buffer_range = true;
            break;
          }
          default:
            break;
        }
      }
    }

    const bool applied_replacement = utils::shader::ApplyReplacement(context.cmd_list, &state);

    if (!custom_shader_info->views.empty()) {
      if (use_pipeline_layout_cloning && !applied_replacement) {
#ifdef DEBUG_LEVEL_0
        std::stringstream s;
        s << "mods::shader::OnCommandAction(";
        s << "descriptor injection unavailable for shader ";
        s << PRINT_CRC32(custom_shader_info->crc32);
        s << ": replacement pipeline was not applied";
        s << ", pipeline: " << PRINT_PTR(state.pipeline_details->pipeline.handle);
        s << ", injection layout: " << PRINT_PTR(state.pipeline_details->injection_layout.handle);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
      } else if (state.pipeline_details->injection_layout == 0u) {
        assert(false && "custom shader view binding requires an injection layout");
#ifdef DEBUG_LEVEL_0
        std::stringstream s;
        s << "mods::shader::OnCommandAction(";
        s << "descriptor push unavailable for shader ";
        s << PRINT_CRC32(custom_shader_info->crc32);
        s << ": injection layout missing";
        s << ", pipeline: " << PRINT_PTR(state.pipeline_details->pipeline.handle);
        s << ", original layout: " << PRINT_PTR(state.pipeline_details->layout.handle);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
      } else if (state.pipeline_details->descriptor_push_locations.empty()) {
        assert(false && "custom shader view binding requires descriptor push locations");
#ifdef DEBUG_LEVEL_0
        std::stringstream s;
        s << "mods::shader::OnCommandAction(";
        s << "descriptor push unavailable for shader ";
        s << PRINT_CRC32(custom_shader_info->crc32);
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

        static thread_local std::vector<PendingViewPush> pending_view_pushes;
        if (pending_view_pushes.size() < custom_shader_info->views.size()) {
          pending_view_pushes.resize(custom_shader_info->views.size());
        }
        uint32_t pending_view_push_count = 0u;

        bool has_missing_view = false;
        for (const auto& view_binding : custom_shader_info->views) {
          const auto location_it = state.pipeline_details->descriptor_push_locations
                                       .find({view_binding.type, view_binding.slot, view_binding.space});
          if (location_it == state.pipeline_details->descriptor_push_locations.end()) {
            assert(false && "custom shader view binding location is missing");
#ifdef DEBUG_LEVEL_0
            std::stringstream s;
            s << "mods::shader::OnCommandAction(";
            s << "view binding location missing for shader ";
            s << PRINT_CRC32(custom_shader_info->crc32);
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
          const auto view = view_binding.get_view(context.cmd_list);
          if (view.handle == 0u) {
            assert(false && "custom shader view binding returned a null view");
#ifdef DEBUG_LEVEL_0
            std::stringstream s;
            s << "mods::shader::OnCommandAction(";
            s << "view binding returned null for shader ";
            s << PRINT_CRC32(custom_shader_info->crc32);
            s << ", slot=" << view_binding.slot;
            s << ", space=" << view_binding.space;
            s << ")";
            reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
            has_missing_view = true;
            break;
          }

          pending_view_pushes[pending_view_push_count++] = {
              .layout_param = location_it->second.first,
              .binding = location_it->second.second,
              .type = view_binding.type,
              .view = view,
          };
        }

        if (has_missing_view) {
          return response;
        }

        const auto descriptor_stages =
            shader_stage == renodx::utils::shader::COMPUTE_INDEX
                ? reshade::api::shader_stage::all_compute
                : reshade::api::shader_stage::all_graphics;

        std::sort(
            pending_view_pushes.begin(),
            pending_view_pushes.begin() + pending_view_push_count,
            [](const PendingViewPush& lhs, const PendingViewPush& rhs) {
              if (lhs.layout_param != rhs.layout_param) return lhs.layout_param < rhs.layout_param;
              if (lhs.type != rhs.type) return lhs.type < rhs.type;
              return lhs.binding < rhs.binding;
            });

        const bool use_descriptor_tables = context.cmd_list->get_device()->get_api() == reshade::api::device_api::vulkan;

        static thread_local std::vector<reshade::api::resource_view> descriptor_views;
        if (descriptor_views.size() < pending_view_push_count) {
          descriptor_views.resize(pending_view_push_count);
        }
        size_t span_begin = 0u;
        while (span_begin < pending_view_push_count) {
          const auto& first_view_push = pending_view_pushes[span_begin];
          descriptor_views[0] = first_view_push.view;
          uint32_t descriptor_view_count = 1u;

          size_t span_end = span_begin + 1u;
          uint32_t previous_binding = first_view_push.binding;
          while (span_end < pending_view_push_count) {
            const auto& next_view_push = pending_view_pushes[span_end];
            if (next_view_push.layout_param != first_view_push.layout_param
                || next_view_push.type != first_view_push.type
                || next_view_push.binding != previous_binding + 1u) {
              break;
            }
            descriptor_views[descriptor_view_count++] = next_view_push.view;
            previous_binding = next_view_push.binding;
            ++span_end;
          }

          reshade::api::descriptor_table table = {};
          if (use_descriptor_tables) {
            if (first_view_push.layout_param < state.pipeline_details->descriptor_tables.size()) {
              table = state.pipeline_details->descriptor_tables[first_view_push.layout_param];
            }

            if (table.handle == 0u) {
              if (!renodx::utils::descriptor::GetOrAllocateDescriptorTable(
                      context.cmd_list->get_device(),
                      state.pipeline_details->layout,
                      state.pipeline_details->injection_layout,
                      first_view_push.layout_param,
                      &table)) {
#ifdef DEBUG_LEVEL_0
                std::stringstream s;
                s << "mods::shader::OnCommandAction(";
                s << "descriptor table allocation failed for shader ";
                s << PRINT_CRC32(custom_shader_info->crc32);
                s << ": set=" << first_view_push.layout_param;
                s << ", pipeline: " << PRINT_PTR(state.pipeline_details->pipeline.handle);
                s << ", injection layout: " << PRINT_PTR(state.pipeline_details->injection_layout.handle);
                s << ")";
                reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
                return response;
              }
            }

            if (state.pipeline_details->descriptor_tables.size() <= first_view_push.layout_param) {
              state.pipeline_details->descriptor_tables.resize(first_view_push.layout_param + 1u);
            }
            state.pipeline_details->descriptor_tables[first_view_push.layout_param] = table;
          }

          const reshade::api::descriptor_table_update update{
              .table = table,
              .binding = first_view_push.binding,
              .array_offset = 0,
              .count = descriptor_view_count,
              .type = first_view_push.type,
              .descriptors = descriptor_views.data(),
          };

          if (use_descriptor_tables) {
            context.cmd_list->get_device()->update_descriptor_tables(1u, &update);
            context.cmd_list->bind_descriptor_tables(
                descriptor_stages,
                state.pipeline_details->injection_layout,
                first_view_push.layout_param,
                1u,
                &table);
          } else {
            context.cmd_list->push_descriptors(
                descriptor_stages,
                state.pipeline_details->injection_layout,
                first_view_push.layout_param,
                update);
          }

          span_begin = span_end;
        }
      }
    }

    return response;
  };

  DrawResponse response = {};
  if (!context.matched_shader_stage.has_value()) {
    if (is_dispatch) {
      response = handle_stage(renodx::utils::shader::COMPUTE_INDEX);
    } else {
      response = handle_stage(renodx::utils::shader::VERTEX_INDEX);
      if (!response.bypass_draw) {
        response = handle_stage(renodx::utils::shader::PIXEL_INDEX);
      }
    }
  } else {
    response = handle_stage(context.matched_shader_stage.value(), context.matched_shader_hash, &context.template GetCallbackData<T>());
  }

  renodx::utils::command_action::CallbackResult<Context> result = {
      .bypass = response.bypass_draw,
  };
  if (response.bypass_draw) return result;

  struct PostCommandAction {
    static void OnDrawn(Context& context, const void* data) {
      const auto* on_drawn = static_cast<const std::function<void(reshade::api::command_list*)>*>(data);
      assert(on_drawn != nullptr);
      if (on_drawn != nullptr && static_cast<bool>(*on_drawn)) {
        (*on_drawn)(context.cmd_list);
      }
    }

    static void RevertConstantBufferRange(Context& context, const void*) {
      auto* shader_state = renodx::utils::command_action::GetShaderState(&context);
      if (shader_state == nullptr) return;
      const auto shader_stage = context.matched_shader_stage.value_or(
          context.IsDispatch() ? renodx::utils::shader::COMPUTE_INDEX : renodx::utils::shader::PIXEL_INDEX);
      auto& state = shader_state->stage_states[shader_stage];
      if (state.pipeline_details == nullptr) {
        renodx::utils::shader::PopulateStageState(&state);
      }
      if (state.pipeline_details == nullptr || state.pipeline_details->injection_register_index == -1) return;

      renodx::utils::constants::RevertBufferRange(
          context.cmd_list,
          static_cast<uint32_t>(state.pipeline_details->injection_register_index),
          0,
          context.IsDispatch() ? reshade::api::shader_stage::compute : reshade::api::shader_stage::pixel);
    }

    static void OnDrawnAndRevertConstantBufferRange(Context& context, const void* data) {
      OnDrawn(context, data);
      RevertConstantBufferRange(context, nullptr);
    }
  };

  if (response.on_drawn != nullptr || response.revert_constant_buffer_range) {
    result.replay = true;
    result.post_callback = response.on_drawn != nullptr
                               ? response.revert_constant_buffer_range
                                     ? PostCommandAction::OnDrawnAndRevertConstantBufferRange
                                     : PostCommandAction::OnDrawn
                           : response.revert_constant_buffer_range
                               ? PostCommandAction::RevertConstantBufferRange
                               : nullptr;
    result.post_data = response.on_drawn;
  }

  return result;
};

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
        const uint32_t injection_offset = constant_buffer_offset != 0
                                              ? constant_buffer_offset
                                              : details->injection_constant_buffer_offset;
        auto visibility = reshade::api::shader_stage::all;
        if (!use_pipeline_layout_cloning) {
          visibility = details->injection_visibility;
        }
        renodx::utils::constants::PushShaderInjections(
            cmd_list,
            details->injection_layout,
            details->injection_index,
            false,
            {shader_injection, shader_injection_size},
            injection_offset,
            nullptr,
            0.f,
            visibility);
      }
    }
  }
}

static bool attached = false;

template <typename T = float*, std::ranges::range CustomShaderList>
  requires std::convertible_to<std::ranges::range_value_t<CustomShaderList>, CustomShader>
static void Use(DWORD fdw_reason, const CustomShaderList& new_custom_shaders, T* new_injections = nullptr) {
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    using_custom_replace = false;
    using_custom_inject = false;
    using_counted_shaders = false;
    for (const auto& custom_shader : new_custom_shaders) {
      if (custom_shader.on_replace != nullptr) using_custom_replace = true;
      if (custom_shader.on_inject != nullptr) using_custom_inject = true;
      if (custom_shader.index != -1) using_counted_shaders = true;
    }
    renodx::utils::shader::use_replace_on_bind = !(using_custom_replace || using_custom_inject);
  }

  renodx::utils::shader::Use(fdw_reason);
  if (resource_tag_float != nullptr) {
    renodx::utils::resource::Use(fdw_reason);
  }
  if (invoked_custom_swapchain_shader != nullptr) {
    renodx::utils::swapchain::Use(fdw_reason);
  }
  renodx::utils::pipeline_layout::Use(fdw_reason);
  renodx::utils::descriptor::Use(fdw_reason);
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
      }

      custom_shaders.rehash(custom_shaders.size());

      if (using_counted_shaders || push_injections_on_present) {
        reshade::register_event<reshade::addon_event::present>(OnPresent);
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

      {
        for (const auto& [hash, shader] : custom_shaders) {
          renodx::utils::command_action::Register(
              OnCommandAction,
              {
                  .shader_hash = hash,
                  .command_types = renodx::utils::command_action::COMMAND_TYPE_DIRECT_DRAW
                                   | renodx::utils::command_action::COMMAND_TYPE_DISPATCH
                                   | renodx::utils::command_action::COMMAND_TYPE_INDIRECT,
              },
              &shader);
        }
      }
      renodx::utils::command_action::Use(fdw_reason);

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

      renodx::utils::command_action::Unregister(OnCommandAction);
      renodx::utils::command_action::Use(fdw_reason);

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
