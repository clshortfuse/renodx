/*
 * Copyright (C) 2023 Ersh
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#include <array>
#include <map>

#define DEBUG_LEVEL_0

#include <embed/0x0D85D1F6.h>
#include <embed/0x2FC8F3F8.h>
#include <embed/0x3C2773E3.h>
#include <embed/0x67991225.h>
#include <embed/0xC7690164.h>
#include <embed/0xCC71BBE3.h>
#include <embed/0xCD84F54A.h>
#include <embed/0xDE5120BF.h>
#include <embed/0xE126DD24.h>
#include <embed/0xE75890F6.h>
#include <embed/0xFFFFFFFF.h>  // clampalpha compute shader

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./p5r.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0xCD84F54A),  // PreTonemap
    // CustomShaderEntry(0xC7690164),  // HDR
    // CustomShaderEntry(0x67991225),  // HDR
    // CustomShaderEntry(0xE75890F6),  // HDR
    // CustomShaderEntry(0x2FC8F3F8),  // PostTonemap
    // CustomShaderEntry(0x0D85D1F6),  // PostTonemap
    CustomSwapchainShader(0xDE5120BF),  // Output

    // CustomShaderEntry(0xE126DD24),      // UIDrawColor
    // CustomShaderEntry(0xCC71BBE3),      // UIDrawTexture
    // CustomShaderEntry(0x3C2773E3),      // UIMenu
};

bool IsUiShader(uint32_t hash) {
  return hash == 0xE126DD24
         || hash == 0xCC71BBE3
         || hash == 0x3C2773E3;
}

struct __declspec(uuid("776ea285-c5a0-4974-a5b4-c0c16feab20a")) DeviceData {
  std::map<reshade::api::resource, reshade::api::resource_view> main_target_uavs;
  reshade::api::pipeline clamp_alpha_compute_pipeline = {};
};

struct __declspec(uuid("274fb646-cb2c-4f70-acc0-19e892164bc3")) StateTrackingData {
  void ApplyRenderTargets(reshade::api::command_list* cmd_list) const {
    if (!render_targets.empty() || depth_stencil != 0) {
      cmd_list->bind_render_targets_and_depth_stencil(static_cast<uint32_t>(render_targets.size()), render_targets.data(), depth_stencil);
    }
  }

  void ApplyPipelines(reshade::api::command_list* cmd_list) const {
    for (const auto& [stages, pipeline] : pipelines) {
      cmd_list->bind_pipeline(stages, pipeline);
    }
  }

  void ApplyPipelineStates(reshade::api::command_list* cmd_list) const {
    if (primitive_topology != reshade::api::primitive_topology::undefined) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::primitive_topology, static_cast<uint32_t>(primitive_topology));
    }
    if (blend_constant != 0) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::blend_constant, blend_constant);
    }
    if (sample_mask != 0xFFFFFFFF) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::sample_mask, sample_mask);
    }
    if (front_stencil_reference_value != 0) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::front_stencil_reference_value, front_stencil_reference_value);
    }
    if (back_stencil_reference_value != 0) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::back_stencil_reference_value, back_stencil_reference_value);
    }
  }

  void ApplyViewports(reshade::api::command_list* cmd_list) const {
    if (!viewports.empty()) {
      cmd_list->bind_viewports(0, static_cast<uint32_t>(viewports.size()), viewports.data());
    }
  }

  void ApplyScissorRects(reshade::api::command_list* cmd_list) const {
    if (!scissor_rects.empty()) {
      cmd_list->bind_scissor_rects(0, static_cast<uint32_t>(scissor_rects.size()), scissor_rects.data());
    }
  }

  void ApplyDescriptorTables(reshade::api::command_list* cmd_list) const {
    for (const auto& [stages, descriptor_state] : descriptor_tables) {
      cmd_list->bind_descriptor_tables(stages, descriptor_state.first, 0, static_cast<uint32_t>(descriptor_state.second.size()), descriptor_state.second.data());
    }
  }

  void Apply(reshade::api::command_list* cmd_list) const {
    ApplyRenderTargets(cmd_list);
    ApplyPipelines(cmd_list);
    ApplyPipelineStates(cmd_list);
    ApplyViewports(cmd_list);
    ApplyScissorRects(cmd_list);
    ApplyDescriptorTables(cmd_list);
  }

  void Clear() {
    render_targets.clear();
    depth_stencil = {0};
    pipelines.clear();
    primitive_topology = reshade::api::primitive_topology::undefined;
    blend_constant = 0;
    sample_mask = 0xFFFFFFFF;
    front_stencil_reference_value = 0;
    back_stencil_reference_value = 0;
    viewports.clear();
    scissor_rects.clear();
    descriptor_tables.clear();
  }

  std::vector<reshade::api::resource_view> render_targets;
  reshade::api::resource_view depth_stencil = {0};
  std::unordered_map<reshade::api::pipeline_stage, reshade::api::pipeline> pipelines;
  reshade::api::primitive_topology primitive_topology = reshade::api::primitive_topology::undefined;
  uint32_t blend_constant = 0;
  uint32_t sample_mask = 0xFFFFFFFF;
  uint32_t front_stencil_reference_value = 0;
  uint32_t back_stencil_reference_value = 0;
  std::vector<reshade::api::viewport> viewports;
  std::vector<reshade::api::rect> scissor_rects;
  std::unordered_map<reshade::api::shader_stage, std::pair<reshade::api::pipeline_layout, std::vector<reshade::api::descriptor_table>>> descriptor_tables;
};

ShaderInjectData shader_injection;

bool after_tonemapping = false;

constexpr reshade::api::pipeline_layout PIPELINE_LAYOUT{0xFFFFFFFFFFFFFFFF};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .can_reset = false,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 10.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 20.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeBlowout", 0.f);
}

void CreateCustomShader(
    reshade::api::device* device, const uint8_t* shader_code, size_t shader_code_size,
    reshade::api::pipeline_subobject_type type, reshade::api::pipeline& pipeline) {
  reshade::api::shader_desc shader_desc = {};
  shader_desc.code = shader_code;
  shader_desc.code_size = shader_code_size;

  reshade::api::pipeline_subobject pipeline_subobject;
  pipeline_subobject.type = type;
  pipeline_subobject.count = 1;
  pipeline_subobject.data = &shader_desc;
  device->create_pipeline(PIPELINE_LAYOUT, 1, &pipeline_subobject, &pipeline);
}

void CreateCustomShaders(reshade::api::device* device) {
  auto& data = device->get_private_data<DeviceData>();

  CreateCustomShader(
      device, __0xFFFFFFFF.data(), __0xFFFFFFFF.size(),
      reshade::api::pipeline_subobject_type::compute_shader, data.clamp_alpha_compute_pipeline);
}

void DestroyCustomShaders(reshade::api::device* device) {
  auto& data = device->get_private_data<DeviceData>();

  device->destroy_pipeline(data.clamp_alpha_compute_pipeline);
}

void OnInitDevice(reshade::api::device* device) {
  auto& data = device->create_private_data<DeviceData>();

  CreateCustomShaders(device);
}

void OnDestroyDevice(reshade::api::device* device) {
  DestroyCustomShaders(device);

  device->destroy_private_data<DeviceData>();
}

void OnInitCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<StateTrackingData>();
}

void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<StateTrackingData>();
}

void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  auto& data = device->get_private_data<DeviceData>();

  if (auto it = data.main_target_uavs.find(resource); it != data.main_target_uavs.end()) {
    device->destroy_resource_view(it->second);
    data.main_target_uavs.erase(it);
  }
}

bool CreateUav(reshade::api::command_list* cmd_list, reshade::api::resource target, reshade::api::resource_view& uav) {
  return cmd_list->get_device()->create_resource_view(
      target, reshade::api::resource_usage::unordered_access,
      reshade::api::resource_view_desc(reshade::api::format::r16g16b16a16_float), &uav);
}

void OnBindRenderTargetsAndDepthStencil(reshade::api::command_list* cmd_list, uint32_t count,
                                        const reshade::api::resource_view* rtvs, reshade::api::resource_view dsv) {
  auto& state = cmd_list->get_private_data<StateTrackingData>();
  state.render_targets.assign(rtvs, rtvs + count);
  state.depth_stencil = dsv;

  if (after_tonemapping) {
    auto& shader_state = cmd_list->get_private_data<renodx::utils::shader::CommandListData>();
    const uint32_t shader_hash = shader_state.GetCurrentPixelShaderHash();
    if ((rtvs != nullptr) && rtvs->handle != 0) {
      if (IsUiShader(shader_hash)) {
        auto* device = cmd_list->get_device();
        auto& data = device->get_private_data<DeviceData>();

        auto target = device->get_resource_from_view(*rtvs);
        auto& entry = data.main_target_uavs[target];

        if (entry.handle == 0) {
          CreateUav(cmd_list, target, entry);
        }
      }
    }
  }
}

void ClampAlpha(reshade::api::command_list* cmd_list) {
  const auto& current_state = cmd_list->get_private_data<StateTrackingData>();
  auto* device = cmd_list->get_device();
  auto& data = device->get_private_data<DeviceData>();

  if (!current_state.render_targets.empty() && current_state.render_targets[0].handle != 0) {
    const auto& target = current_state.render_targets[0];
    auto resource = device->get_resource_from_view(target);
    auto& uav = data.main_target_uavs[resource];

    if (uav.handle == 0) {
      if (!CreateUav(cmd_list, resource, uav)) {
        return;
      }
    }

    const reshade::api::resource_desc main_target_desc = device->get_resource_desc(resource);
    const uint32_t texture_width = main_target_desc.texture.width;
    const uint32_t texture_height = main_target_desc.texture.height;

    constexpr uint32_t thread_group_size_x = 32;
    constexpr uint32_t thread_group_size_y = 32;

    auto num_groups_x = (texture_width + thread_group_size_x - 1) / thread_group_size_x;
    auto num_groups_y = (texture_height + thread_group_size_y - 1) / thread_group_size_y;

    cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_compute, data.clamp_alpha_compute_pipeline);

    // cmd_list->barrier(resource, reshade::api::resource_usage::render_target, reshade::api::resource_usage::unordered_access);

    cmd_list->push_descriptors(reshade::api::shader_stage::all_compute, PIPELINE_LAYOUT, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::texture_unordered_access_view, &uav});
    cmd_list->dispatch(num_groups_x, num_groups_y, 1);

    // cmd_list->barrier(resource, reshade::api::resource_usage::unordered_access, reshade::api::resource_usage::render_target);

    current_state.Apply(cmd_list);
  }
}

void OnBindPipeline(reshade::api::command_list* cmd_list, reshade::api::pipeline_stage type, reshade::api::pipeline pipeline) {
  auto& state = cmd_list->get_private_data<StateTrackingData>();
  state.pipelines[type] = pipeline;

  auto& shader_state = cmd_list->get_private_data<renodx::utils::shader::CommandListData>();
  const uint32_t shader_hash = shader_state.GetCurrentPixelShaderHash();

  if (after_tonemapping && IsUiShader(shader_hash) && type == reshade::api::pipeline_stage::output_merger) {
    ClampAlpha(cmd_list);
  }

  if (shader_hash == 0xB6E26AC7) {
    after_tonemapping = true;
  }
}

void OnBindPipelineStates(reshade::api::command_list* cmd_list, uint32_t count, const reshade::api::dynamic_state* states, const uint32_t* values) {
  auto& state = cmd_list->get_private_data<StateTrackingData>();

  for (uint32_t i = 0; i < count; ++i) {
    switch (states[i]) {
      case reshade::api::dynamic_state::primitive_topology:
        state.primitive_topology = static_cast<reshade::api::primitive_topology>(values[i]);
        break;
      case reshade::api::dynamic_state::blend_constant:
        state.blend_constant = values[i];
        break;
      case reshade::api::dynamic_state::sample_mask:
        state.sample_mask = values[i];
        break;
      case reshade::api::dynamic_state::front_stencil_reference_value:
        state.front_stencil_reference_value = values[i];
        break;
      case reshade::api::dynamic_state::back_stencil_reference_value:
        state.back_stencil_reference_value = values[i];
        break;
      default:
        break;
    }
  }
}

void OnBindViewports(reshade::api::command_list* cmd_list, uint32_t first, uint32_t count, const reshade::api::viewport* viewports) {
  auto& state = cmd_list->get_private_data<StateTrackingData>();

  const uint32_t total_count = first + count;
  if (state.viewports.size() < total_count) {
    state.viewports.resize(total_count);
  }

  for (uint32_t i = 0; i < count; ++i) {
    state.viewports[i + first] = viewports[i];
  }
}

void OnBindScissorRects(reshade::api::command_list* cmd_list, uint32_t first, uint32_t count, const reshade::api::rect* rects) {
  auto& state = cmd_list->get_private_data<StateTrackingData>();

  const uint32_t total_count = first + count;
  if (state.scissor_rects.size() < total_count) {
    state.scissor_rects.resize(total_count);
  }

  for (uint32_t i = 0; i < count; ++i) {
    state.scissor_rects[i + first] = rects[i];
  }
}

void OnBindDescriptorTables(reshade::api::command_list* cmd_list, reshade::api::shader_stage stages, reshade::api::pipeline_layout layout, uint32_t first, uint32_t count, const reshade::api::descriptor_table* tables) {
  auto& state = cmd_list->get_private_data<StateTrackingData>().descriptor_tables[stages];

  if (layout != state.first) {
    state.second.clear();  // Layout changed, which resets all descriptor table bindings
  }
  state.first = layout;

  const uint32_t total_count = first + count;
  if (state.second.size() < total_count) {
    state.second.resize(total_count);
  }

  for (uint32_t i = 0; i < count; ++i) {
    state.second[i + first] = tables[i];
  }
}

void OnResetCommandList(reshade::api::command_list* cmd_list) {
  auto& state = cmd_list->get_private_data<StateTrackingData>();
  state.Clear();
}

void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain, const reshade::api::rect* source_rect, const reshade::api::rect* dest_rect, uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  after_tonemapping = false;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Persona 5 Royal";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID /*unused*/) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
#ifndef NDEBUG
      while (IsDebuggerPresent() == 0) {
        Sleep(100);
      }
#endif
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::expected_constant_buffer_index = 10;

      auto push_target = [](int32_t a_index) {
        /*renodx::mods::swapchain::swap_chain_upgrade_targets.push_back(
        {.old_format = reshade::api::format::r8g8b8a8_unorm,
         .new_format = reshade::api::format::r16g16b16a16_float,
         .index = a_index,
         .aspect_ratio = 16.f / 9.f
        }
      );*/
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .index = a_index,
            .aspect_ratio = 16.f / 9.f,
            .usage_set = static_cast<uint32_t>(reshade::api::resource_usage::unordered_access),
        });
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .index = a_index,
            .aspect_ratio = 16.f / 9.f,
        });
      };

      push_target(-1);

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);
      reshade::register_event<reshade::addon_event::bind_viewports>(OnBindViewports);
      reshade::register_event<reshade::addon_event::bind_scissor_rects>(OnBindScissorRects);
      reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      reshade::register_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
      renodx::mods::swapchain::Use(fdw_reason);
      renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
      break;
    }

    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);
      reshade::unregister_event<reshade::addon_event::bind_viewports>(OnBindViewports);
      reshade::unregister_event<reshade::addon_event::bind_scissor_rects>(OnBindScissorRects);
      reshade::unregister_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      reshade::unregister_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      reshade::unregister_addon(h_module);
      break;
  }

  return TRUE;
}
