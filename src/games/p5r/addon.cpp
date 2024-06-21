/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

// #define DEBUG_LEVEL_0
// #define DEBUG_LEVEL_1
// #define DEBUG_LEVEL_2

#include <algorithm>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/0xB6E26AC7.h>
#include <embed/0xDE5120BF.h>

#include <embed/0x0D85D1F6.h>
#include <embed/0xC6D14699.h>

#include <embed/0x060C3E22.h>
#include <embed/0x23A501DC.h>
#include <embed/0x2944b564.h>
#include <embed/0x3C2773E3.h>
#include <embed/0x4016ED43.h>
#include <embed/0x5C4DD977.h>
#include <embed/0x7C0751EF.h>
#include <embed/0x960502CC.h>
#include <embed/0xAB823647.h>
#include <embed/0xB6E26AC7.h>
#include <embed/0xCC71BBE3.h>
#include <embed/0xCF70BF33.h>
#include <embed/0xD434C03A.h>
#include <embed/0xE126DD24.h>
#include <embed/0xEBBDB212.h>

#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/mutex.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Persona 5 Royal";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0xB6E26AC7),
  CustomShaderEntry(0xDE5120BF),

  CustomShaderEntry(0x0D85D1F6),
  CustomShaderEntry(0xC6D14699),

  CustomShaderEntry(0x060C3E22),
  CustomShaderEntry(0x23A501DC),
  CustomShaderEntry(0x2944B564),
  CustomShaderEntry(0x3C2773E3),
  CustomShaderEntry(0x4016ED43),
  CustomShaderEntry(0x5C4DD977),
  CustomShaderEntry(0x7C0751EF),
  CustomShaderEntry(0x960502CC),
  CustomShaderEntry(0xAB823647),
  CustomShaderEntry(0xB6E26AC7),
  CustomShaderEntry(0xCC71BBE3),
  CustomShaderEntry(0xCF70BF33),
  CustomShaderEntry(0xD434C03A),
  CustomShaderEntry(0xE126DD24),
  CustomShaderEntry(0xEBBDB212)

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
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeColorSpace",
    .binding = &shaderInjection.colorGradeColorSpace,
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .defaultValue = 3.f,
    .canReset = false,
    .label = "Color Space",
    .section = "Color Grading",
    .tooltip = "Selects color space gamut when clamping",
    .labels = {"None", "BT709", "BT2020", "AP1"}
  },
  new UserSettingUtil::UserSetting {
    .key = "fxBloom",
    .binding = &shaderInjection.fxBloom,
    .defaultValue = 50.f,
    .label = "Bloom",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
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
  UserSettingUtil::updateUserSetting("colorGradeLUTStrength", 100.f);
  UserSettingUtil::updateUserSetting("colorGradeLUTScaling", 0.f);
  UserSettingUtil::updateUserSetting("colorGradeColorSpace", 1.f);
  UserSettingUtil::updateUserSetting("fxBloom", 50.f);
}

struct __declspec(uuid("5958c7c4-19b2-4300-af4d-c6802d6c7635")) DeviceData {
  std::shared_mutex mutex;
  reshade::api::pipeline min_alpha_pipeline = {0};
  reshade::api::pipeline max_alpha_pipeline = {0};
  reshade::api::pipeline_layout injectionLayout = {0};
  std::unordered_set<uint64_t> unsafe_blend_pipelines = {};
};

struct __declspec(uuid("452ac839-081c-4891-9880-8533c0a63666")) CommandListData {
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

static bool g_completed_render = false;

static void on_present(
  reshade::api::command_queue* queue,
  reshade::api::swapchain* swapchain,
  const reshade::api::rect* source_rect,
  const reshade::api::rect* dest_rect,
  uint32_t dirty_rect_count,
  const reshade::api::rect* dirty_rects
) {
  g_completed_render = false;
}

static std::unordered_set<uint32_t> g_8bitHashes = {
  0x060C3E22,
  0x23A501DC,
  0x2944b564,
  0x3C2773E3,
  0x4016ED43,
  0x5C4DD977,
  0x7C0751EF,
  0x960502CC,
  0xAB823647,
  0xB6E26AC7,
  0xCC71BBE3,
  0xCF70BF33,
  0xD434C03A,
  0xE126DD24,
  0xEBBDB212,
};

static void pushConstants(reshade::api::command_list* cmd_list, reshade::api::pipeline_layout layout) {
  static float shaderInjectionSize = sizeof(shaderInjection) / sizeof(uint32_t);
  cmd_list->push_constants(
    reshade::api::shader_stage::all_graphics,  // Used by reshade to specify graphics or compute
    layout,
    0,
    0,
    shaderInjectionSize,
    &shaderInjection
  );
}

static bool on_draw_indexed(
  reshade::api::command_list* cmd_list,
  uint32_t index_count,
  uint32_t instance_count,
  uint32_t first_index,
  int32_t vertex_offset,
  uint32_t first_instance
) {
  if (!shaderInjection.colorGradeLUTScaling) return false;
  auto &commandListData = cmd_list->get_private_data<CommandListData>();
  if (commandListData.lastOutputMerger.handle == 0) return false;

  ShaderUtil::CommandListData &shaderState = cmd_list->get_private_data<ShaderUtil::CommandListData>();

  if (shaderState.currentShaderHash == 0xC6D14699) return false;  // Video
  if (shaderState.currentShaderHash == 0xB6E26AC7) {
    g_completed_render = true;
    return false;
  }
  if (!g_completed_render) return false;
  if (!g_8bitHashes.contains(shaderState.currentShaderHash)) return false;

  SwapchainUtil::CommandListData &swapchainState = cmd_list->get_private_data<SwapchainUtil::CommandListData>();

  if (!swapchainState.currentRenderTargets.size()) return false;
  const auto target0 = swapchainState.currentRenderTargets[0];

  auto device = cmd_list->get_device();

  auto resourceTag = ResourceUtil::getResourceTag(device, target0);
  if (resourceTag != 1.f) return false;

  auto &data = device->get_private_data<DeviceData>();
  std::shared_lock readOnlyLock(data.mutex);
  if (data.unsafe_blend_pipelines.contains(commandListData.lastOutputMerger.handle)) {
    if (!data.min_alpha_pipeline.handle) {
      using namespace reshade::api;
      blend_desc blend_desc = {};
      blend_desc.blend_enable[0] = true;
      blend_desc.alpha_blend_op[0] = blend_op::min;
      blend_desc.render_target_write_mask[0] = 0x8;

      auto subobjects = pipeline_subobject{
        .type = pipeline_subobject_type::blend_state,
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
      using namespace reshade::api;
      blend_desc blend_desc = {};
      blend_desc.blend_enable[0] = true;
      blend_desc.alpha_blend_op[0] = blend_op::max;
      blend_desc.render_target_write_mask[0] = 0x8;
      auto subobjects = pipeline_subobject{
        .type = pipeline_subobject_type::blend_state,
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

    if (!data.injectionLayout.handle) {
      auto &shaderReplaceDeviceData = device->get_private_data<ShaderReplaceMod::DeviceData>();
      std::shared_lock lock(shaderReplaceDeviceData.mutex);
      if (
        auto pair = shaderReplaceDeviceData.moddedPipelineLayouts.find(0xFFFFFFFFFFFFFFFF);
        pair != shaderReplaceDeviceData.moddedPipelineLayouts.end()
      ) {
        readOnlyLock.unlock();
        {
          std::unique_lock lock(data.mutex);
          data.injectionLayout = pair->second;
        }
        readOnlyLock.lock();
      } else {
        return false;
      }
    }

    cmd_list->bind_render_targets_and_depth_stencil(swapchainState.currentRenderTargets.size(), swapchainState.currentRenderTargets.data(), {0});

    shaderInjection.clampState = CLAMP_STATE__MIN_ALPHA;
    pushConstants(cmd_list, data.injectionLayout);
    cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, data.min_alpha_pipeline);
    cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);

    shaderInjection.clampState = CLAMP_STATE__MAX_ALPHA;
    pushConstants(cmd_list, data.injectionLayout);
    cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, data.max_alpha_pipeline);
    cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);
    cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, commandListData.lastOutputMerger);
    cmd_list->bind_render_targets_and_depth_stencil(swapchainState.currentRenderTargets.size(), swapchainState.currentRenderTargets.data(), swapchainState.currentDepthStencil);
  }

  shaderInjection.clampState = CLAMP_STATE__OUTPUT;
  pushConstants(cmd_list, data.injectionLayout);
  cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);
  shaderInjection.clampState = CLAMP_STATE__NONE;

  return true;
}

// After CreatePipelineState
static void on_init_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline_layout layout,
  uint32_t subobjectCount,
  const reshade::api::pipeline_subobject* subobjects,
  reshade::api::pipeline pipeline
) {
  bool unsafe = false;
  for (uint32_t i = 0; i < subobjectCount; ++i) {
    if (unsafe) break;

    const auto &subobject = subobjects[i];
    if (subobject.type != reshade::api::pipeline_subobject_type::blend_state) continue;
    for (uint32_t j = 0; j < subobject.count; ++j) {
      auto &desc = static_cast<reshade::api::blend_desc*>(subobject.data)[j];
      if (!desc.blend_enable) continue;

      if (desc.render_target_write_mask[0] & 0x1 || desc.render_target_write_mask[0] & 0x2 || desc.render_target_write_mask[0] & 0x4) {
        if (desc.color_blend_op[0] != reshade::api::blend_op::min && desc.color_blend_op[0] != reshade::api::blend_op::max) {
          if (
            desc.source_color_blend_factor[0] == reshade::api::blend_factor::dest_alpha
            || desc.source_color_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
            || desc.dest_color_blend_factor[0] == reshade::api::blend_factor::dest_alpha
            || desc.dest_color_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
          ) {
            unsafe = true;
            break;
          }
        }
      }
      if (desc.render_target_write_mask[0] & 0x8) {
        if (desc.alpha_blend_op[0] == reshade::api::blend_op::min || desc.alpha_blend_op[0] == reshade::api::blend_op::max) {
          unsafe = true;
          break;
        }
        if (
          desc.source_alpha_blend_factor[0] == reshade::api::blend_factor::dest_alpha
          || desc.source_alpha_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
          || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::one
          || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::dest_alpha
          || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
        ) {
          unsafe = true;
          break;
        }
      }
    }
  }
  if (unsafe) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    data.unsafe_blend_pipelines.emplace(pipeline.handle);
  }
}

static void on_bind_pipeline(
  reshade::api::command_list* cmd_list,
  reshade::api::pipeline_stage type,
  reshade::api::pipeline pipeline
) {
  if (type != reshade::api::pipeline_stage::output_merger) return;
  auto &data = cmd_list->get_private_data<CommandListData>();
  data.lastOutputMerger = pipeline;
}

static void on_destroy_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline pipeline
) {
  auto &data = device->get_private_data<DeviceData>();
  std::unique_lock lock(data.mutex);
  data.unsafe_blend_pipelines.erase(pipeline.handle);
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:

      ShaderReplaceMod::expectedConstantBufferIndex = 7u;

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
          .resourceTag = 1.f,
        }
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {
          .oldFormat = reshade::api::format::r8g8b8a8_typeless,
          .newFormat = reshade::api::format::r16g16b16a16_typeless,
          .resourceTag = 1.f,
        }
      );

      shaderInjection.clampState = CLAMP_STATE__NONE;

      if (!reshade::register_addon(hModule)) return FALSE;
      reshade::register_event<reshade::addon_event::init_device>(on_init_device);
      reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
      reshade::register_event<reshade::addon_event::init_command_list>(on_init_command_list);
      reshade::register_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);
      reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
      reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);
      reshade::unregister_addon(hModule);
      break;
  }

  ResourceUtil::use(fdwReason);
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
