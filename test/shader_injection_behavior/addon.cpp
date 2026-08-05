/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define DEBUG_LEVEL_0

#include <array>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <span>
#include <string>
#include <string_view>
#include <vector>

#include <include/reshade.hpp>

#include "src/mods/shader.hpp"

namespace {

struct InjectionData {
  std::array<float, 4> values = {0.25f, 0.5f, 0.75f, 1.f};
};

namespace shader = renodx::mods::shader;

InjectionData g_injection;
const bool g_legacy_default_space_preserved = shader::ViewBinding{}.space == 50u;
bool g_result_written = false;
bool g_near_limit_seen = false;
bool g_near_limit_passed = false;
bool g_near_limit_mapping_seen = false;
bool g_near_limit_mapping_passed = false;
bool g_near_limit_destroyed = false;
bool g_overflow_seen = false;
bool g_overflow_rejected = false;
bool g_overflow_mapping_seen = false;
bool g_overflow_mapping_absent = false;
bool g_overflow_destroyed = false;
bool g_descriptor_ranges_seen = false;
bool g_descriptor_ranges_owned = false;
bool g_vulkan_descriptor_conflict_nonfatal = false;
bool g_descriptor_ownership_mode = false;
reshade::api::pipeline_layout g_near_limit_layout = {};
reshade::api::pipeline_layout g_overflow_layout = {};

void WriteResultIfReady() {
  if (g_result_written
      || (g_descriptor_ownership_mode && !g_descriptor_ranges_seen)
      || (!g_descriptor_ownership_mode
          && (!g_near_limit_seen
              || !g_near_limit_mapping_seen
              || !g_near_limit_destroyed
              || !g_overflow_seen
              || !g_overflow_mapping_seen
              || !g_overflow_destroyed))) {
    return;
  }

  char* result_path = nullptr;
  size_t result_path_size = 0u;
  if (_dupenv_s(&result_path, &result_path_size, "RENODX_ROOT_SIGNATURE_RESULT") != 0
      || result_path == nullptr) {
    return;
  }

  const bool passed = g_descriptor_ownership_mode
                          ? g_descriptor_ranges_owned
                                && g_vulkan_descriptor_conflict_nonfatal
                          : g_near_limit_passed
                                && g_near_limit_mapping_passed
                                && g_overflow_rejected
                                && g_overflow_mapping_absent
                                && g_legacy_default_space_preserved;
  std::ofstream output(std::filesystem::path(result_path), std::ios::binary);
  std::free(result_path);
  output << (passed ? "PASS\n" : "FAIL\n");
  output << "near_limit_seen=" << g_near_limit_seen << '\n';
  output << "near_limit_passed=" << g_near_limit_passed << '\n';
  output << "near_limit_mapping_seen=" << g_near_limit_mapping_seen << '\n';
  output << "near_limit_mapping_passed=" << g_near_limit_mapping_passed << '\n';
  output << "near_limit_destroyed=" << g_near_limit_destroyed << '\n';
  output << "overflow_seen=" << g_overflow_seen << '\n';
  output << "overflow_rejected=" << g_overflow_rejected << '\n';
  output << "overflow_mapping_seen=" << g_overflow_mapping_seen << '\n';
  output << "overflow_mapping_absent=" << g_overflow_mapping_absent << '\n';
  output << "overflow_destroyed=" << g_overflow_destroyed << '\n';
  output << "descriptor_ranges_seen=" << g_descriptor_ranges_seen << '\n';
  output << "descriptor_ranges_owned=" << g_descriptor_ranges_owned << '\n';
  output << "vulkan_descriptor_conflict_nonfatal=" << g_vulkan_descriptor_conflict_nonfatal << '\n';
  output << "legacy_default_space_preserved=" << g_legacy_default_space_preserved << '\n';
  g_result_written = true;
}

bool TestVulkanDescriptorConflictIsNonfatal() {
  const std::array original_ranges = {
      reshade::api::descriptor_range{
          .binding = 0u,
          .count = 1u,
          .visibility = reshade::api::shader_stage::compute,
          .array_size = 1u,
          .type = reshade::api::descriptor_type::texture_shader_resource_view,
      },
      reshade::api::descriptor_range{
          .binding = 5u,
          .count = 1u,
          .visibility = reshade::api::shader_stage::compute,
          .array_size = 1u,
          .type = reshade::api::descriptor_type::texture_shader_resource_view,
      },
  };
  const std::array injected_ranges = {
      reshade::api::descriptor_range{
          .binding = 0u,
          .count = 1u,
          .visibility = reshade::api::shader_stage::all,
          .array_size = 1u,
          .type = reshade::api::descriptor_type::texture_unordered_access_view,
      },
      reshade::api::descriptor_range{
          .binding = 0u,
          .count = 1u,
          .visibility = reshade::api::shader_stage::all,
          .array_size = 1u,
          .type = reshade::api::descriptor_type::texture_unordered_access_view,
      },
  };
  std::vector<reshade::api::pipeline_layout_param> params = {
      reshade::api::pipeline_layout_param(1u, original_ranges.data()),
      reshade::api::pipeline_layout_param(1u, original_ranges.data() + 1u),
  };
  const std::vector<reshade::api::pipeline_layout_param> injected_params = {
      reshade::api::pipeline_layout_param(1u, injected_ranges.data()),
      reshade::api::pipeline_layout_param(1u, injected_ranges.data() + 1u),
  };
  std::vector<std::vector<reshade::api::descriptor_range>> merged_ranges(params.size());

  const bool merged = shader::MergeVulkanDescriptorParameters(
      injected_params,
      {0u, 1u},
      params,
      merged_ranges);

  return merged
         && params[0].descriptor_table.ranges == original_ranges.data()
         && merged_ranges[0].empty()
         && params[1].descriptor_table.ranges == merged_ranges[1].data()
         && merged_ranges[1].size() == 2u
         && merged_ranges[1][0].binding == 0u
         && merged_ranges[1][1].binding == 5u;
}

uint32_t GetD3D12RootCost(const reshade::api::pipeline_layout_param& param) {
  switch (param.type) {
    case reshade::api::pipeline_layout_param_type::descriptor_table:
      return param.descriptor_table.count != 0u
                     && param.descriptor_table.ranges[0].count != 0u
                 ? 1u
                 : 0u;
    case reshade::api::pipeline_layout_param_type::push_constants:
      return param.push_constants.count;
    case reshade::api::pipeline_layout_param_type::push_descriptors:
      if (param.push_descriptors.count == 0u) return 0u;
      if (param.push_descriptors.count != 1u || param.push_descriptors.binding != 0u) return 1u;
      switch (param.push_descriptors.type) {
        case reshade::api::descriptor_type::constant_buffer:
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::acceleration_structure:
          return 2u;
        default:
          return 1u;
      }
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
      return param.descriptor_table.count != 0u ? 1u : 0u;
    case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers: {
      if (param.descriptor_table_with_static_samplers.count == 0u) return 0u;
      const auto& first = param.descriptor_table_with_static_samplers.ranges[0];
      if (first.static_samplers != nullptr) return 0u;
      if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers) {
        return first.count != 0u ? 1u : 0u;
      }
      if (param.descriptor_table_with_static_samplers.count != 1u
          || first.count != 1u
          || first.binding != 0u) {
        return 1u;
      }
      switch (first.type) {
        case reshade::api::descriptor_type::constant_buffer:
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::acceleration_structure:
          return 2u;
        default:
          return 1u;
      }
    }
    default:
      return 0u;
  }
}

bool OnInspectCreatePipelineLayout(
    reshade::api::device* device,
    uint32_t& param_count,
    reshade::api::pipeline_layout_param*& params) {
  if (device->get_api() != reshade::api::device_api::d3d12) return false;

  auto* data = renodx::utils::data::Get<shader::DeviceData>(device);
  if (data == nullptr || data->injected_descriptor_range_groups.empty()) return false;

  for (uint32_t index = 0u; index < param_count; ++index) {
    const auto& param = params[index];
    if (param.type != reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges
        || param.descriptor_table.count != 2u) {
      continue;
    }
    g_descriptor_ranges_seen = true;
    g_descriptor_ranges_owned = param.descriptor_table.ranges
                                == data->injected_descriptor_range_groups[0].data();
    WriteResultIfReady();
  }
  return false;
}

bool OnInitPipelineLayout(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    std::span<const reshade::api::pipeline_layout_param> params) {
  if (g_result_written || device->get_api() != reshade::api::device_api::d3d12) return true;

  bool near_limit_marker_found = false;
  bool overflow_marker_found = false;
  bool constants_found = false;
  bool descriptor_found = false;
  uint32_t root_cost = 0u;

  for (uint32_t index = 0u; index < params.size(); ++index) {
    const auto& param = params[index];
    root_cost += GetD3D12RootCost(param);

    if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      near_limit_marker_found |= param.push_constants.dx_register_index == 1u
                                 && param.push_constants.dx_register_space == 7u
                                 && param.push_constants.count == 56u;
      overflow_marker_found |= param.push_constants.dx_register_index == 2u
                               && param.push_constants.dx_register_space == 7u
                               && param.push_constants.count == 60u;
      constants_found |= param.push_constants.dx_register_index == 13u
                         && param.push_constants.dx_register_space == 50u
                         && param.push_constants.count == 4u;
      continue;
    }

    if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      descriptor_found |= param.push_descriptors.type == reshade::api::descriptor_type::texture_shader_resource_view
                          && param.push_descriptors.dx_register_index == 3u
                          && param.push_descriptors.dx_register_space == 50u
                          && param.push_descriptors.count == 1u;
      continue;
    }

    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table
        || param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges) {
      for (uint32_t range_index = 0u; range_index < param.descriptor_table.count; ++range_index) {
        const auto& range = param.descriptor_table.ranges[range_index];
        descriptor_found |= range.type == reshade::api::descriptor_type::texture_shader_resource_view
                            && range.dx_register_index == 3u
                            && range.dx_register_space == 50u
                            && range.count == 1u;
      }
    }
  }

  if (near_limit_marker_found) {
    g_near_limit_seen = true;
    g_near_limit_passed = constants_found && descriptor_found && root_cost == 64u;
    g_near_limit_layout = layout;
  } else if (overflow_marker_found) {
    g_overflow_seen = true;
    g_overflow_rejected = !constants_found && !descriptor_found && root_cost == 63u;
    g_overflow_layout = layout;
  }

  return true;
}

void OnAfterInitPipelineLayout(
    reshade::api::device* device,
    uint32_t,
    const reshade::api::pipeline_layout_param*,
    reshade::api::pipeline_layout layout) {
  if (device->get_api() != reshade::api::device_api::d3d12) return;

  if (layout.handle == g_near_limit_layout.handle) {
    g_near_limit_mapping_seen = renodx::utils::pipeline_layout::GetPipelineLayoutData(
        layout,
        [&](const auto* layout_data) {
          const auto location = layout_data->descriptor_push_locations.find({
              reshade::api::descriptor_type::texture_shader_resource_view,
              3u,
              50u,
          });
          g_near_limit_mapping_passed = layout_data->injection_layout.handle == layout.handle
                                        && layout_data->injection_index == 3
                                        && layout_data->injection_register_index == 13
                                        && location != layout_data->descriptor_push_locations.end()
                                        && location->second.first == 4u
                                        && location->second.second == 0u;
        });
  } else if (layout.handle == g_overflow_layout.handle) {
    g_overflow_mapping_seen = renodx::utils::pipeline_layout::GetPipelineLayoutData(
        layout,
        [&](const auto* layout_data) {
          g_overflow_mapping_absent = layout_data->injection_layout.handle == 0u
                                      && layout_data->injection_index == -1
                                      && layout_data->descriptor_push_locations.empty();
        });
  }
}

void OnDestroyTestPipelineLayout(
    reshade::api::device*,
    reshade::api::pipeline_layout layout) {
  if (layout.handle == g_near_limit_layout.handle) g_near_limit_destroyed = true;
  if (layout.handle == g_overflow_layout.handle) g_overflow_destroyed = true;
  WriteResultIfReady();
}

const std::array<renodx::mods::shader::CustomShader, 1> ROOT_SIGNATURE_CUSTOM_SHADERS = {{
  {
    .crc32 = 0x564D5832u,
    .views = {
      {
        .type = reshade::api::descriptor_type::texture_shader_resource_view,
        .slot = 3u,
        .get_view = [](reshade::api::command_list*) {
          return reshade::api::resource_view{};
        },
      },
    },
  },
}};

const std::array<renodx::mods::shader::CustomShader, 1> DESCRIPTOR_OWNERSHIP_CUSTOM_SHADERS = {{
    {
        .crc32 = 0x564D5832u,
        .views = {
            {
                .type = reshade::api::descriptor_type::texture_shader_resource_view,
                .slot = 3u,
                .get_view = [](reshade::api::command_list*) {
                  return reshade::api::resource_view{};
                },
            },
            {
                .type = reshade::api::descriptor_type::texture_unordered_access_view,
                .slot = 4u,
                .get_view = [](reshade::api::command_list*) {
                  return reshade::api::resource_view{};
                },
            },
        },
    },
}};

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX D3D12 Root Signature Test";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "D3D12 shader injection root-signature regression test";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD reason, LPVOID) {
  switch (reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      {
        char* test_mode = nullptr;
        size_t test_mode_size = 0u;
        if (_dupenv_s(
                &test_mode,
                &test_mode_size,
                "RENODX_SHADER_INJECTION_TEST_MODE") == 0
            && test_mode != nullptr) {
          g_descriptor_ownership_mode = std::string_view(test_mode) == "descriptor-ownership";
        }
        std::free(test_mode);
      }
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::expected_constant_buffer_space = 50u;
      renodx::mods::shader::on_init_pipeline_layout = OnInitPipelineLayout;
      if (g_descriptor_ownership_mode) {
        g_vulkan_descriptor_conflict_nonfatal = TestVulkanDescriptorConflictIsNonfatal();
        renodx::mods::shader::Use(reason, DESCRIPTOR_OWNERSHIP_CUSTOM_SHADERS, &g_injection);
      } else {
        renodx::mods::shader::Use(reason, ROOT_SIGNATURE_CUSTOM_SHADERS, &g_injection);
      }
      reshade::register_event<reshade::addon_event::create_pipeline_layout>(OnInspectCreatePipelineLayout);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(OnAfterInitPipelineLayout);
      reshade::register_event<reshade::addon_event::destroy_pipeline_layout>(OnDestroyTestPipelineLayout);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::destroy_pipeline_layout>(OnDestroyTestPipelineLayout);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(OnAfterInitPipelineLayout);
      reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(OnInspectCreatePipelineLayout);
      if (g_descriptor_ownership_mode) {
        renodx::mods::shader::Use(reason, DESCRIPTOR_OWNERSHIP_CUSTOM_SHADERS, &g_injection);
      } else {
        renodx::mods::shader::Use(reason, ROOT_SIGNATURE_CUSTOM_SHADERS, &g_injection);
      }
      renodx::mods::shader::on_init_pipeline_layout = nullptr;
      reshade::unregister_addon(h_module);
      break;
    default:
      break;
  }
  return TRUE;
}