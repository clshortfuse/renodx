/*
 * Copyright (C) 2023 Ersh
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#include <array>

#define DEBUG_LEVEL_0

#include <embed/0xCD84F54A.h>
#include <embed/0xC7690164.h>
#include <embed/0x67991225.h>
#include <embed/0xE75890F6.h>
#include <embed/0x2FC8F3F8.h>
#include <embed/0x0D85D1F6.h>
#include <embed/0xDE5120BF.h>
#include <embed/0xE126DD24.h>
#include <embed/0xCC71BBE3.h>
#include <embed/0x3C2773E3.h>
#include <embed/0xFFFFFFFF.h>  // clampalpha compute shader

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./p5r.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Persona 5 Royal";

ShaderReplaceMod::CustomShaders customShaders = {
  //CustomShaderEntry(0xCD84F54A),  // PreTonemap
  //CustomShaderEntry(0xC7690164),  // HDR
  //CustomShaderEntry(0x67991225),  // HDR
  //CustomShaderEntry(0xE75890F6),  // HDR
  //CustomShaderEntry(0x2FC8F3F8),  // PostTonemap
  //CustomShaderEntry(0x0D85D1F6),  // PostTonemap
  CustomSwapchainShader(0xDE5120BF),  // Output
  //CustomShaderEntry(0xE126DD24),      // UIDrawColor
  //CustomShaderEntry(0xCC71BBE3),      // UIDrawTexture
  //CustomShaderEntry(0x3C2773E3),      // UIMenu
};

static bool is_ui_shader(uint32_t hash) {
return hash == 0xE126DD24
  || hash == 0xCC71BBE3
  || hash == 0x3C2773E3;
}

struct __declspec(uuid("776ea285-c5a0-4974-a5b4-c0c16feab20a")) device_data {
  std::map<reshade::api::resource, reshade::api::resource_view> main_target_uavs = {};
  reshade::api::pipeline clamp_alpha_compute_pipeline = {};
};

struct __declspec(uuid("274fb646-cb2c-4f70-acc0-19e892164bc3")) state_tracking_data {
  void apply_render_targets(reshade::api::command_list* cmd_list) const {
    if (!render_targets.empty() || depth_stencil != 0)
      cmd_list->bind_render_targets_and_depth_stencil(static_cast<uint32_t>(render_targets.size()), render_targets.data(), depth_stencil);
  }

  void apply_pipelines(reshade::api::command_list* cmd_list) const {
    for (const auto &[stages, pipeline] : pipelines)
      cmd_list->bind_pipeline(stages, pipeline);
  }

  void apply_pipeline_states(reshade::api::command_list* cmd_list) const {
    if (primitive_topology != reshade::api::primitive_topology::undefined)
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::primitive_topology, static_cast<uint32_t>(primitive_topology));
    if (blend_constant != 0)
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::blend_constant, blend_constant);
    if (sample_mask != 0xFFFFFFFF)
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::sample_mask, sample_mask);
    if (front_stencil_reference_value != 0)
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::front_stencil_reference_value, front_stencil_reference_value);
    if (back_stencil_reference_value != 0)
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::back_stencil_reference_value, back_stencil_reference_value);
  }

  void apply_viewports(reshade::api::command_list* cmd_list) const {
    if (!viewports.empty())
      cmd_list->bind_viewports(0, static_cast<uint32_t>(viewports.size()), viewports.data());
  }

  void apply_scissor_rects(reshade::api::command_list* cmd_list) const {
    if (!scissor_rects.empty())
      cmd_list->bind_scissor_rects(0, static_cast<uint32_t>(scissor_rects.size()), scissor_rects.data());
  }

  void apply_descriptor_tables(reshade::api::command_list* cmd_list) const {
    for (const auto &[stages, descriptor_state] : descriptor_tables)
      cmd_list->bind_descriptor_tables(stages, descriptor_state.first, 0, static_cast<uint32_t>(descriptor_state.second.size()), descriptor_state.second.data());
  }

  void apply(reshade::api::command_list* cmd_list) const {
    apply_render_targets(cmd_list);
    apply_pipelines(cmd_list);
    apply_pipeline_states(cmd_list);
    apply_viewports(cmd_list);
    apply_scissor_rects(cmd_list);
    apply_descriptor_tables(cmd_list);
  }

  void clear() {
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

ShaderInjectData shaderInjection;

bool afterTonemapping = false;

constexpr reshade::api::pipeline_layout pipelineLayout{0xFFFFFFFFFFFFFFFF};

// clang-format off
UserSettingUtil::UserSettings userSettings = {
  new UserSettingUtil::UserSetting {
    .key = "toneMapType",
    .binding = &shaderInjection.toneMapType,
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .defaultValue = 3.f,
    .canReset = false,
    .label = "Tone Mapper",
    .section = "Tone Mapping",
    .tooltip = "Sets the tone mapper type",
    .labels = {"Vanilla", "None", "ACES", "RenoDRT"}
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapPeakNits",
    .binding = &shaderInjection.toneMapPeakNits,
    .defaultValue = 1000.f,
    .canReset = false,
    .label = "Peak Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of peak white in nits",
    .min = 48.f,
    .max = 4000.f
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapGameNits",
    .binding = &shaderInjection.toneMapGameNits,
    .defaultValue = 203.f,
    .canReset = false,
    .label = "Game Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of 100%% white in nits",
    .min = 48.f,
    .max = 500.f
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapUINits",
    .binding = &shaderInjection.toneMapUINits,
    .defaultValue = 203.f,
    .canReset = false,
    .label = "UI Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the brightness of UI and HUD elements in nits",
    .min = 48.f,
    .max = 500.f
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapGammaCorrection",
    .binding = &shaderInjection.toneMapGammaCorrection,
    .valueType = UserSettingUtil::UserSettingValueType::boolean,
    .canReset = false,
    .label = "Gamma Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeExposure",
    .binding = &shaderInjection.colorGradeExposure,
    .defaultValue = 1.f,
    .label = "Exposure",
    .section = "Color Grading",
    .max = 10.f,
    .format = "%.2f"
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeHighlights",
    .binding = &shaderInjection.colorGradeHighlights,
    .defaultValue = 50.f,
    .label = "Highlights",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeShadows",
    .binding = &shaderInjection.colorGradeShadows,
    .defaultValue = 50.f,
    .label = "Shadows",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeContrast",
    .binding = &shaderInjection.colorGradeContrast,
    .defaultValue = 50.f,
    .label = "Contrast",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeSaturation",
    .binding = &shaderInjection.colorGradeSaturation,
    .defaultValue = 50.f,
    .label = "Saturation",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeBlowout",
    .binding = &shaderInjection.colorGradeBlowout,
    .defaultValue = 20.f,
    .label = "Blowout",
    .section = "Color Grading",
    .tooltip = "Controls highlight desaturation due to overexposure.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
};
// clang-format on

static void onPresetOff() {
  UserSettingUtil::updateUserSetting("toneMapType", 0.f);
  UserSettingUtil::updateUserSetting("toneMapPeakNits", 203.f);
  UserSettingUtil::updateUserSetting("toneMapGameNits", 203.f);
  UserSettingUtil::updateUserSetting("toneMapUINits", 203.f);
  UserSettingUtil::updateUserSetting("toneMapGammaCorrection", 0);
  UserSettingUtil::updateUserSetting("colorGradeExposure", 1.f);
  UserSettingUtil::updateUserSetting("colorGradeHighlights", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeShadows", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeContrast", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeSaturation", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeBlowout", 0.f);
}

static void create_custom_shader(reshade::api::device* device, const uint8_t* shader_code, size_t shader_code_size, reshade::api::pipeline_subobject_type type, reshade::api::pipeline &pipeline) {
  reshade::api::shader_desc shaderDesc = {};
  shaderDesc.code = shader_code;
  shaderDesc.code_size = shader_code_size;

  reshade::api::pipeline_subobject pipelineSubobject;
  pipelineSubobject.type = type;
  pipelineSubobject.count = 1;
  pipelineSubobject.data = &shaderDesc;
  device->create_pipeline(pipelineLayout, 1, &pipelineSubobject, &pipeline);
}

static void create_custom_shaders(reshade::api::device* device) {
  auto &data = device->get_private_data<device_data>();

  create_custom_shader(device, _0xFFFFFFFF, sizeof(_0xFFFFFFFF), reshade::api::pipeline_subobject_type::compute_shader, data.clamp_alpha_compute_pipeline);
}

static void destroy_custom_shaders(reshade::api::device* device) {
  auto &data = device->get_private_data<device_data>();

  device->destroy_pipeline(data.clamp_alpha_compute_pipeline);
}

static void on_init_device(reshade::api::device* device) {
  auto &data = device->create_private_data<device_data>();

  create_custom_shaders(device);
}

static void on_destroy_device(reshade::api::device* device) {
  destroy_custom_shaders(device);

  device->destroy_private_data<device_data>();
}

static void on_init_command_list(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<state_tracking_data>();
}

static void on_destroy_command_list(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<state_tracking_data>();
}

static void on_destroy_resource(reshade::api::device* device, reshade::api::resource resource) {
  auto &data = device->get_private_data<device_data>();

  if (auto it = data.main_target_uavs.find(resource); it != data.main_target_uavs.end()) {
    device->destroy_resource_view(it->second);
    data.main_target_uavs.erase(it);
  }
}

static bool create_uav(reshade::api::command_list* cmd_list, reshade::api::resource target, reshade::api::resource_view &uav) {
  return cmd_list->get_device()->create_resource_view(target, reshade::api::resource_usage::unordered_access, reshade::api::resource_view_desc(reshade::api::format::r16g16b16a16_float), &uav);
}

static void on_bind_render_targets_and_depth_stencil(reshade::api::command_list* cmd_list, uint32_t count, const reshade::api::resource_view* rtvs, reshade::api::resource_view dsv) {
  auto &state = cmd_list->get_private_data<state_tracking_data>();
  state.render_targets.assign(rtvs, rtvs + count);
  state.depth_stencil = dsv;

  if (afterTonemapping) {
    ShaderUtil::CommandListData &shaderState = cmd_list->get_private_data<ShaderUtil::CommandListData>();
    uint32_t shaderHash = shaderState.currentShaderHash;
    if (rtvs && rtvs->handle != 0) {
      if (is_ui_shader(shaderHash)) {
        auto device = cmd_list->get_device();
        auto &data = device->get_private_data<device_data>();

        auto target = device->get_resource_from_view(*rtvs);
        auto &entry = data.main_target_uavs[target];

        if (entry.handle == 0) {
          create_uav(cmd_list, target, entry);
        }
      }
    }
  }
}

static void clamp_alpha(reshade::api::command_list* cmd_list) {
  const auto &current_state = cmd_list->get_private_data<state_tracking_data>();
  auto device = cmd_list->get_device();
  auto &data = device->get_private_data<device_data>();

  if (!current_state.render_targets.empty() && current_state.render_targets[0].handle != 0) {
    auto &target = current_state.render_targets[0];
    auto resource = device->get_resource_from_view(target);
    auto &uav = data.main_target_uavs[resource];

    if (uav.handle == 0) {
      if (!create_uav(cmd_list, resource, uav)) {
        return;
      }
    }

    reshade::api::resource_desc main_target_desc = device->get_resource_desc(resource);
    uint32_t textureWidth = main_target_desc.texture.width;
    uint32_t textureHeight = main_target_desc.texture.height;

    constexpr uint32_t threadGroupSizeX = 32;
    constexpr uint32_t threadGroupSizeY = 32;

    auto numGroupsX = (textureWidth + threadGroupSizeX - 1) / threadGroupSizeX;
    auto numGroupsY = (textureHeight + threadGroupSizeY - 1) / threadGroupSizeY;

    cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_compute, data.clamp_alpha_compute_pipeline);

    //cmd_list->barrier(resource, reshade::api::resource_usage::render_target, reshade::api::resource_usage::unordered_access);

    cmd_list->push_descriptors(reshade::api::shader_stage::all_compute, pipelineLayout, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::texture_unordered_access_view, &uav});
    cmd_list->dispatch(numGroupsX, numGroupsY, 1);

    //cmd_list->barrier(resource, reshade::api::resource_usage::unordered_access, reshade::api::resource_usage::render_target);

    current_state.apply(cmd_list);
  }
}

static void on_bind_pipeline(reshade::api::command_list* cmd_list, reshade::api::pipeline_stage type, reshade::api::pipeline pipeline) {
  auto &state = cmd_list->get_private_data<state_tracking_data>();
  state.pipelines[type] = pipeline;

  ShaderUtil::CommandListData &shaderState = cmd_list->get_private_data<ShaderUtil::CommandListData>();
  uint32_t shaderHash = shaderState.currentShaderHash;

  if (afterTonemapping && is_ui_shader(shaderHash) && type == reshade::api::pipeline_stage::output_merger) {
    clamp_alpha(cmd_list);
  }

  if (shaderHash == 0xB6E26AC7) {
    afterTonemapping = true;
  }
}

static void on_bind_pipeline_states(reshade::api::command_list* cmd_list, uint32_t count, const reshade::api::dynamic_state* states, const uint32_t* values) {
  auto &state = cmd_list->get_private_data<state_tracking_data>();

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
    }
  }
}

static void on_bind_viewports(reshade::api::command_list* cmd_list, uint32_t first, uint32_t count, const reshade::api::viewport* viewports) {
  auto &state = cmd_list->get_private_data<state_tracking_data>();

  const uint32_t total_count = first + count;
  if (state.viewports.size() < total_count)
    state.viewports.resize(total_count);

  for (uint32_t i = 0; i < count; ++i)
    state.viewports[i + first] = viewports[i];
}

static void on_bind_scissor_rects(reshade::api::command_list* cmd_list, uint32_t first, uint32_t count, const reshade::api::rect* rects) {
  auto &state = cmd_list->get_private_data<state_tracking_data>();

  const uint32_t total_count = first + count;
  if (state.scissor_rects.size() < total_count)
    state.scissor_rects.resize(total_count);

  for (uint32_t i = 0; i < count; ++i)
    state.scissor_rects[i + first] = rects[i];
}

static void on_bind_descriptor_tables(reshade::api::command_list* cmd_list, reshade::api::shader_stage stages, reshade::api::pipeline_layout layout, uint32_t first, uint32_t count, const reshade::api::descriptor_table* tables) {
  auto &state = cmd_list->get_private_data<state_tracking_data>().descriptor_tables[stages];

  if (layout != state.first)
    state.second.clear();  // Layout changed, which resets all descriptor table bindings
  state.first = layout;

  const uint32_t total_count = first + count;
  if (state.second.size() < total_count)
    state.second.resize(total_count);

  for (uint32_t i = 0; i < count; ++i)
    state.second[i + first] = tables[i];
}

static void on_reset_command_list(reshade::api::command_list* cmd_list) {
  auto &state = cmd_list->get_private_data<state_tracking_data>();
  state.clear();
}

static void on_present(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain, const reshade::api::rect* source_rect, const reshade::api::rect* dest_rect, uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  afterTonemapping = false;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
#ifndef NDEBUG
      while (!IsDebuggerPresent()) {
        Sleep(100);
      }
#endif
      if (!reshade::register_addon(hModule)) return FALSE;

      ShaderReplaceMod::expectedConstantBufferIndex = 10;

      auto pushTarget = [](int32_t a_index) {
        /*SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
          {.oldFormat = reshade::api::format::r8g8b8a8_unorm,
           .newFormat = reshade::api::format::r16g16b16a16_float,
           .index = a_index,
           .aspectRatio = 16.f / 9.f
          }
        );*/
        SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
          {.oldFormat = reshade::api::format::r8g8b8a8_typeless,
           .newFormat = reshade::api::format::r16g16b16a16_float,
           .index = a_index,
           .aspectRatio = 16.f / 9.f,
           .usageSet = (uint32_t)reshade::api::resource_usage::unordered_access
          }
        );
        SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
          {.oldFormat = reshade::api::format::r10g10b10a2_unorm,
           .newFormat = reshade::api::format::r16g16b16a16_float,
           .index = a_index,
           .aspectRatio = 16.f / 9.f
          }
        );
      };

      pushTarget(-1);

      reshade::register_event<reshade::addon_event::init_device>(on_init_device);
      reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
      reshade::register_event<reshade::addon_event::destroy_resource>(on_destroy_resource);
      reshade::register_event<reshade::addon_event::init_command_list>(on_init_command_list);
      reshade::register_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(on_bind_render_targets_and_depth_stencil);
      reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline_states>(on_bind_pipeline_states);
      reshade::register_event<reshade::addon_event::bind_viewports>(on_bind_viewports);
      reshade::register_event<reshade::addon_event::bind_scissor_rects>(on_bind_scissor_rects);
      reshade::register_event<reshade::addon_event::bind_descriptor_tables>(on_bind_descriptor_tables);
      reshade::register_event<reshade::addon_event::reset_command_list>(on_reset_command_list);
      reshade::register_event<reshade::addon_event::present>(on_present);

      UserSettingUtil::use(fdwReason, &userSettings, &onPresetOff);
      SwapChainUpgradeMod::use(fdwReason);
      ShaderReplaceMod::use(fdwReason, customShaders, &shaderInjection);

      break;

    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
      reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(on_destroy_resource);
      reshade::unregister_event<reshade::addon_event::init_command_list>(on_init_command_list);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(on_bind_render_targets_and_depth_stencil);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline_states>(on_bind_pipeline_states);
      reshade::unregister_event<reshade::addon_event::bind_viewports>(on_bind_viewports);
      reshade::unregister_event<reshade::addon_event::bind_scissor_rects>(on_bind_scissor_rects);
      reshade::unregister_event<reshade::addon_event::bind_descriptor_tables>(on_bind_descriptor_tables);
      reshade::unregister_event<reshade::addon_event::reset_command_list>(on_reset_command_list);
      reshade::unregister_event<reshade::addon_event::present>(on_present);

      reshade::unregister_addon(hModule);
      break;
  }  

  return TRUE;
}
