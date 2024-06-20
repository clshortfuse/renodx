/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

// #define DEBUG_LEVEL_0
// #define DEBUG_LEVEL_1
// #define DEBUG_LEVEL_2

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include "d3d11_1.h"

#include <embed/0x3C2773E3.h>
#include <embed/0x960502CC.h>
#include <embed/0xB6E26AC7.h>
#include <embed/0xCC71BBE3.h>
#include <embed/0xDE5120BF.h>
#include <embed/0xE126DD24.h>

#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/mutex.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Personal 5 Royal";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0xDE5120BF),
  CustomShaderEntry(0xCC71BBE3),
  CustomShaderEntry(0x3C2773E3),
  CustomShaderEntry(0xE126DD24),
  CustomShaderEntry(0xB6E26AC7),
  CustomShaderEntry(0x960502CC),
  // CustomShaderEntry(0xCF70BF33),
  // CustomShaderEntry(0xDE5120BF),
  // CustomShaderEntry(0xCC71BBE3),
  // CustomShaderEntry(0x027109D8),
  // CustomShaderEntry(0xE126DD24),
  // CustomShaderEntry(0xAB823647),
  // CustomShaderEntry(0x9C35A562),
  // CustomShaderEntry(0xB6E26AC7),
  // CustomShaderEntry(0xD70EB7CA),
  // CustomShaderEntry(0x960502CC),
  // CustomShaderEntry(0x4016ED43),
  // CustomShaderEntry(0xBB722F0A),
  // CustomShaderEntry(0x0D85D1F6),
  // CustomShaderEntry(0xC6D14699),
  // CustomShaderEntry(0x53D4388A)
};

ShaderInjectData shaderInjection;

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
    .key = "colorGradeLUTStrength",
    .binding = &shaderInjection.colorGradeLUTStrength,
    .defaultValue = 100.f,
    .label = "LUT Strength",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeLUTScaling",
    .binding = &shaderInjection.colorGradeLUTScaling,
    .defaultValue = 100.f,
    .label = "LUT Scaling",
    .section = "Color Grading",
    .tooltip = "Scales the color grade LUT to full range when size is clamped.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  }
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
  UserSettingUtil::updateUserSetting("colorGradeLUTStrength", 100.f);
  UserSettingUtil::updateUserSetting("colorGradeLUTScaling", 0.f);
}

struct __declspec(uuid("5958c7c4-19b2-4300-af4d-c6802d6c7635")) DeviceData {
  std::shared_mutex mutex;
  reshade::api::pipeline min_alpha_pipeline = {0};
  reshade::api::pipeline max_alpha_pipeline = {0};
};

struct __declspec(uuid("452ac839-081c-4891-9880-8533c0a63666")) CommandListData {
  std::shared_mutex mutex;
  reshade::api::pipeline lastOutputMerger;
};

static void on_init_device(reshade::api::device* device) {
  device->create_private_data<DeviceData>();
}

static void on_destroy_device(reshade::api::device* device) {
  device->destroy_private_data<DeviceData>();
}

static void on_init_command_list(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<CommandListData>();
}

static void on_destroy_command_list(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

static void on_present(
  reshade::api::command_queue* queue,
  reshade::api::swapchain* swapchain,
  const reshade::api::rect* source_rect,
  const reshade::api::rect* dest_rect,
  uint32_t dirty_rect_count,
  const reshade::api::rect* dirty_rects
) {
  shaderInjection.uiState = UI_STATE__NONE;
  auto device = swapchain->get_device();
  auto &data = device->get_private_data<DeviceData>();
  std::unique_lock lock(data.mutex);
}

static bool on_ui_draw(reshade::api::command_list* cmd_list, uint32_t index_count, uint32_t instance_count, uint32_t first_index, int32_t vertex_offset, uint32_t first_instance) {
  std::vector<reshade::api::resource_view> currentTargets;
  reshade::api::resource_view currentDepthStencil;

  {
    SwapchainUtil::CommandListData &swapchainState = cmd_list->get_private_data<SwapchainUtil::CommandListData>();
    std::shared_lock swapchainCommandListLock(swapchainState.mutex);
    currentTargets = swapchainState.currentRenderTargets;
    currentDepthStencil = swapchainState.currentDepthStencil;
  }

  auto device = cmd_list->get_device();
  auto &data = device->get_private_data<DeviceData>();
  std::shared_lock readOnlyLock(data.mutex);

  if (!data.min_alpha_pipeline.handle) {
    reshade::api::blend_desc blend_desc = {};
    blend_desc.blend_enable[0] = true;
    blend_desc.alpha_blend_op[0] = reshade::api::blend_op::min;
    blend_desc.render_target_write_mask[0] = 0x8;
    auto subobjects = reshade::api::pipeline_subobject{
      .type = reshade::api::pipeline_subobject_type::blend_state,
      .count = 1,
      .data = &blend_desc,
    };

    readOnlyLock.unlock();
    {
      std::unique_lock lock(data.mutex);
      device->create_pipeline({0xFFFFFFFFFFFFFFFF}, 1, &subobjects, &data.min_alpha_pipeline);
    }
    readOnlyLock.lock();
  }

  if (!data.max_alpha_pipeline.handle) {
    reshade::api::blend_desc blend_desc = {};
    blend_desc.blend_enable[0] = true;
    blend_desc.alpha_blend_op[0] = reshade::api::blend_op::max;
    blend_desc.render_target_write_mask[0] = 0x8;
    auto subobjects = reshade::api::pipeline_subobject{
      .type = reshade::api::pipeline_subobject_type::blend_state,
      .count = 1,
      .data = &blend_desc,
    };

    readOnlyLock.unlock();
    {
      std::unique_lock lock(data.mutex);
      device->create_pipeline({0xFFFFFFFFFFFFFFFF}, 1, &subobjects, &data.max_alpha_pipeline);
    }
    readOnlyLock.lock();
  }

  cmd_list->bind_render_targets_and_depth_stencil(currentTargets.size(), currentTargets.data(), {0});
  shaderInjection.uiState = UI_STATE__MIN_ALPHA;
  ShaderReplaceMod::handlePreDraw(cmd_list);  // Performs push
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, data.min_alpha_pipeline);
  cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);

  shaderInjection.uiState = UI_STATE__MAX_ALPHA;
  ShaderReplaceMod::handlePreDraw(cmd_list);  // Performs push
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, data.max_alpha_pipeline);
  cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);

  shaderInjection.uiState = UI_STATE__DRAWING;
  ShaderReplaceMod::handlePreDraw(cmd_list);  // Performs push
  auto &commandListData = cmd_list->get_private_data<CommandListData>();
  std::shared_lock lock(data.mutex);
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, commandListData.lastOutputMerger);
  cmd_list->bind_render_targets_and_depth_stencil(currentTargets.size(), currentTargets.data(), currentDepthStencil);

  return false;
}

static bool on_draw_indexed(reshade::api::command_list* cmd_list, uint32_t index_count, uint32_t instance_count, uint32_t first_index, int32_t vertex_offset, uint32_t first_instance) {
  uint32_t shaderHash;
  {
    ShaderUtil::CommandListData &shaderState = cmd_list->get_private_data<ShaderUtil::CommandListData>();
    std::shared_lock shaderCommandListLock(shaderState.mutex);
    shaderHash = shaderState.currentShaderHash;
  }

  if (shaderHash == 0xb6e26ac7) {
    shaderInjection.uiState = UI_STATE__DRAWING;
    return false;
  }

  if (shaderInjection.uiState == UI_STATE__DRAWING) {
    if (
      shaderHash == 0xE126DD24
      || shaderHash == 0xCC71BBE3
      || shaderHash == 0x3C2773E3
      || shaderHash == 0x960502CC
    ) {
      return on_ui_draw(cmd_list, index_count, instance_count, first_index, vertex_offset, first_instance);
    }
  }
  return false;
}


static void on_bind_pipeline(
  reshade::api::command_list* cmd_list,
  reshade::api::pipeline_stage type,
  reshade::api::pipeline pipeline
) {
  if (type != reshade::api::pipeline_stage::output_merger) return;
  if (type != reshade::api::pipeline_stage::output_merger) return;
  auto &data = cmd_list->get_private_data<CommandListData>();
  std::unique_lock lock(data.mutex);
  data.lastOutputMerger = pipeline;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:

      // ShaderReplaceMod::forcePipelineCloning = true;

      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {
          .oldFormat = reshade::api::format::r10g10b10a2_unorm,
          .newFormat = reshade::api::format::r16g16b16a16_float,
          .aspectRatio = 16.f / 9.f,
        }
      );

      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {
          .oldFormat = reshade::api::format::r10g10b10a2_unorm,
          .newFormat = reshade::api::format::r16g16b16a16_float,
        }
      );

      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {
          .oldFormat = reshade::api::format::r8g8b8a8_typeless,
          .newFormat = reshade::api::format::r16g16b16a16_typeless,
          .aspectRatio = 16.f / 9.f,
        }
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {
          .oldFormat = reshade::api::format::r8g8b8a8_typeless,
          .newFormat = reshade::api::format::r16g16b16a16_typeless,
        }
      );

      if (!reshade::register_addon(hModule)) return FALSE;
      reshade::register_event<reshade::addon_event::init_device>(on_init_device);
      reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
      reshade::register_event<reshade::addon_event::init_command_list>(on_init_command_list);
      reshade::register_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);
      reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
      reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);
      reshade::unregister_addon(hModule);
      break;
  }

  ShaderUtil::use(fdwReason);  // First to trace
  UserSettingUtil::use(fdwReason, &userSettings, &onPresetOff);
  SwapChainUpgradeMod::use(fdwReason);
  ShaderReplaceMod::use(fdwReason, customShaders, &shaderInjection);

  if (fdwReason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::draw_indexed>(on_draw_indexed);
    reshade::register_event<reshade::addon_event::present>(on_present);
  }
  return TRUE;
}
