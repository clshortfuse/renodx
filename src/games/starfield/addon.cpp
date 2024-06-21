/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

// #define DEBUG_LEVEL_0
// #define DEBUG_LEVEL_1

#include <embed/0x054D0CB8.h>
#include <embed/0x0A152BB1.h>
#include <embed/0x0D5ADD1F.h>
#include <embed/0x17FAB08F.h>
#include <embed/0x1C18052A.h>
#include <embed/0x32580F53.h>
#include <embed/0x3B344832.h>
#include <embed/0x4348FFAE.h>
#include <embed/0x58E74610.h>
#include <embed/0xAC5319C5.h>
#include <embed/0xE9D9E225.h>
#include <embed/0xEED8A831.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/ShaderUtil.hpp"
#include "../../utils/SwapchainUtil.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Starfield";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomSwapchainShader(0x0D5ADD1F),  // output
  CustomShaderEntry(0xAC5319C5),      // film grain
  CustomShaderEntry(0x0A152BB1),      // HDRComposite
  CustomShaderEntry(0x054D0CB8),      // HDRComposite (no bloom)
  CustomShaderEntry(0x3B344832),      // HDRComposite (lut only)
  CustomShaderEntry(0x17FAB08F),      // PostSharpen
  CustomShaderEntry(0x1C18052A),      // CAS1
  CustomShaderEntry(0x58E74610),      // CAS2
  CustomShaderEntry(0x4348FFAE),      // CAS3
  CustomShaderEntry(0xEED8A831),      // CAS4
  // CustomShaderEntry(0xE9D9E225),   // ui
  CustomShaderEntry(0x32580F53)  // movie,
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
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .canReset = false,
    .label = "Gamma Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates an EOTF",
    .labels = { "Off", "2.2", "2.4"}
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
    .key = "colorGradeSceneGrading",
    .binding = &shaderInjection.colorGradeSceneGrading,
    .defaultValue = 100.f,
    .label = "Scene Grading",
    .section = "Color Grading",
    .tooltip = "Selects the strength of the game's custom scene grading.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
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
  new UserSettingUtil::UserSetting {
    .key = "fxFilmGrain",
    .binding = &shaderInjection.fxFilmGrain,
    .defaultValue = 50.f,
    .label = "FilmGrain",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
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
  // UserSettingUtil::updateUserSetting("colorGradeLUTScaling", 0.f);
}

static bool handlePreDraw(reshade::api::command_list* cmd_list, bool isDispatch = false) {
  ShaderUtil::CommandListData &shaderState = cmd_list->get_private_data<ShaderUtil::CommandListData>();

  // flow
  // 0x0a152bb1 (tonemapper) (r11g11b10 => rgb8a_unorm tRender)
  // 0x17FAB08F (sharpen?)   (rgb8a_unorm tRender => rgb8a_unorm tComposite)
  // 0xe9d9e225 (ui)         (rgb8a_unorm tUI => rgb8a_unorm tComposite)
  if (
    !isDispatch
    && (shaderState.currentShaderHash == 0x0a152bb1     // tonemapper
        || shaderState.currentShaderHash == 0x054D0CB8  // tonemapper
        || shaderState.currentShaderHash == 0x3B344832  // tonemapper
        || shaderState.currentShaderHash == 0x17fab08f  // sharpener
        || shaderState.currentShaderHash == 0x32580F53  // movie
        || shaderState.currentShaderHash == 0xe9d9e225  // ui
        || shaderState.currentShaderHash == 0x0d5add1f  // copy
    )
  ) {
    SwapchainUtil::CommandListData &swapchainState = cmd_list->get_private_data<SwapchainUtil::CommandListData>();

    bool changed = false;
    uint32_t renderTargetCount = swapchainState.currentRenderTargets.size();
    for (uint32_t i = 0; i < renderTargetCount; i++) {
      auto render_target = swapchainState.currentRenderTargets[i];
      if (render_target.handle == 0) continue;
      std::stringstream s;
      if (SwapChainUpgradeMod::activateCloneHotSwap(cmd_list->get_device(), render_target)) {
        changed = true;
      }
    }
    if (changed) {
      // Change render targets to desired
      SwapChainUpgradeMod::rewriteRenderTargets(
        cmd_list,
        renderTargetCount,
        swapchainState.currentRenderTargets.data(),
        swapchainState.currentDepthStencil
      );
      SwapChainUpgradeMod::flushDescriptors(cmd_list);
    }
  } else {
    SwapChainUpgradeMod::discardDescriptors(cmd_list);
  }

  return false;
}

static bool on_draw(reshade::api::command_list* cmd_list, uint32_t vertex_count, uint32_t instance_count, uint32_t first_vertex, uint32_t first_instance) {
  return handlePreDraw(cmd_list);
}

static bool on_draw_indexed(reshade::api::command_list* cmd_list, uint32_t index_count, uint32_t instance_count, uint32_t first_index, int32_t vertex_offset, uint32_t first_instance) {
  return handlePreDraw(cmd_list);
}

static bool on_draw_or_dispatch_indirect(reshade::api::command_list* cmd_list, reshade::api::indirect_command type, reshade::api::resource buffer, uint64_t offset, uint32_t draw_count, uint32_t stride) {
  return handlePreDraw(cmd_list);
}

static bool on_dispatch(reshade::api::command_list* cmd_list, uint32_t group_count_x, uint32_t group_count_y, uint32_t group_count_z) {
  return handlePreDraw(cmd_list, true);
}

static auto start = std::chrono::steady_clock::now();

static void on_present(
  reshade::api::command_queue* queue,
  reshade::api::swapchain* swapchain,
  const reshade::api::rect* source_rect,
  const reshade::api::rect* dest_rect,
  uint32_t dirty_rect_count,
  const reshade::api::rect* dirty_rects
) {
  auto end = std::chrono::steady_clock::now();
  shaderInjection.elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  if (fdwReason == DLL_PROCESS_ATTACH && !reshade::register_addon(hModule)) return FALSE;

  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      ShaderReplaceMod::forcePipelineCloning = true;
      ShaderReplaceMod::allowMultiplePushConstants = true;
      // ShaderReplaceMod::expectedConstantBufferIndex = 3;
      ShaderReplaceMod::expectedConstantBufferSpace = 9;
      ShaderReplaceMod::retainDX12LayoutParams = true;
      SwapChainUpgradeMod::useResourceCloning = true;
      SwapChainUpgradeMod::useResizeBuffer = true;
      SwapChainUpgradeMod::useResizeBufferOnSetFullScreen = true;
      SwapChainUpgradeMod::preventFullScreen = true;

      // RGBA8 Resource pool
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {
          .oldFormat = reshade::api::format::r8g8b8a8_typeless,
          .newFormat = reshade::api::format::r16g16b16a16_float,
          .index = 0,
          .useResourceViewCloning = true,
          .useResourceViewHotSwap = false,
        }
      );

      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {
          .oldFormat = reshade::api::format::r8g8b8a8_typeless,
          .newFormat = reshade::api::format::r16g16b16a16_float,
          .ignoreSize = true,
          .useResourceViewCloning = true,
          .useResourceViewHotSwap = true,
        }
      );
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(hModule);
      break;
  }

  UserSettingUtil::use(fdwReason, &userSettings, &onPresetOff);
  SwapChainUpgradeMod::use(fdwReason);
  ShaderReplaceMod::use(fdwReason, customShaders, &shaderInjection);

  ShaderUtil::use(fdwReason);
  if (fdwReason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::draw>(on_draw);
    reshade::register_event<reshade::addon_event::draw_indexed>(on_draw_indexed);
    reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(on_draw_or_dispatch_indirect);
    reshade::register_event<reshade::addon_event::dispatch>(on_dispatch);

    reshade::register_event<reshade::addon_event::present>(on_present);
  }

  return TRUE;
}
