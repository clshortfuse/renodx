/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x2CA9CD55.h> // text/UI
#include <embed/0xA6AB1C75.h> // text
#include <embed/0xF2CCBA8C.h> // UI
#include <embed/0x69B52EA7.h> // Images
#include <embed/0x6CF04AC0.h> // UI
#include <embed/0x7AAE8C2B.h> // Images
#include <embed/0x28213F99.h> // UI
#include <embed/0x21A11DE7.h> // UI
#include <embed/0x4B3388FE.h> // UI
#include <embed/0x4D248432.h> // UI
#include <embed/0x19558629.h> // UI
#include <embed/0x46A6A1FE.h> // Loading Screen
#include <embed/0xFEA4E7DB.h> // Loading Screen
#include <embed/0xD66588EF.h> // Loading Screen
#include <embed/0x3C8AF2C9.h> // Loading Screen Composite
#include <embed/0x0F2CC0D1.h> // video
#include <embed/0x7684FC16.h> // FXAA
#include <embed/0x2C63040A.h> // LUT
#include <embed/0x160805BC.h> // LUT?
#include <embed/0x3778E664.h> // TAA
#include <embed/0xAF2731D9.h> // TAA
//#include <embed/0x73F96489.h> // TAA?
//#include <embed/0xC9C77523.h> // DOF?

#include <embed/0x1BDD7570.h> // Tonemap
#include <embed/0x2A868728.h> // Tonemap
#include <embed/0x5D002D1E.h> // Tonemap
#include <embed/0xBF6561E2.h> // Tonemap


#include <chrono>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Fallout 76";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Fallout 76";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomSwapchainShader(0x2CA9CD55),  // text/UI
  CustomSwapchainShader(0xA6AB1C75),  // text
  CustomSwapchainShader(0xF2CCBA8C),  // UI
  CustomSwapchainShader(0x69B52EA7),  // Images
  CustomSwapchainShader(0x6CF04AC0),  // UI
  CustomSwapchainShader(0x7AAE8C2B),  // Images
  CustomSwapchainShader(0x28213F99),  // UI
  CustomSwapchainShader(0x21A11DE7),  // UI
  CustomSwapchainShader(0x4B3388FE),  // UI
  CustomSwapchainShader(0x4D248432),  // UI
  CustomSwapchainShader(0x19558629),  // UI
  CustomSwapchainShader(0x0F2CC0D1),  // video
  CustomSwapchainShader(0x19558629),  // Loading Screen
  CustomSwapchainShader(0xFEA4E7DB),  // Loading Screen
  CustomSwapchainShader(0xD66588EF),  // Loading Screen
  CustomSwapchainShader(0x3C8AF2C9),  // Loading Screen
  CustomShaderEntry(0x1BDD7570),      // Tonemap
  CustomShaderEntry(0x2A868728),      // Tonemap
  CustomShaderEntry(0x5D002D1E),      // Tonemap
  CustomShaderEntry(0xBF6561E2),      // Tonemap
  CustomShaderEntry(0x2C63040A),      // LUT
  CustomShaderEntry(0x160805BC),      // LUT?
  CustomShaderEntry(0x7684FC16),      // FXAA
  CustomShaderEntry(0x3778E664),      // TAA
  CustomShaderEntry(0xAF2731D9),      // TAA
  //CustomShaderEntry(0x73F96489),      // TAA?
  
  //CustomShaderEntry(0xC9C77523),      // DOF?




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
    .key = "fxBloom",
    .binding = &shaderInjection.fxBloom,
    .defaultValue = 50.f,
    .label = "Bloom",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "fxAutoExposure",
    .binding = &shaderInjection.fxAutoExposure,
    .defaultValue = 50.f,
    .label = "Auto Exposure",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "fxSceneFilter",
    .binding = &shaderInjection.fxSceneFilter,
    .defaultValue = 50.f,
    .label = "Scene Filter",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "fxDoF",
    .binding = &shaderInjection.fxDoF,
    .defaultValue = 50.f,
    .label = "Depth of Field",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "fxFilmGrain",
    .binding = &shaderInjection.fxFilmGrain,
    .defaultValue = 50.f,
    .label = "Film Grain",
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
  UserSettingUtil::updateUserSetting("fxBloom", 50.f);
  UserSettingUtil::updateUserSetting("fxAutoExposure", 50.f);
  UserSettingUtil::updateUserSetting("fxSceneFilter", 50.f);
  UserSettingUtil::updateUserSetting("fxDoF", 50.f);
  UserSettingUtil::updateUserSetting("fxFilmGrain", 0.f);
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
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:

      ShaderReplaceMod::expectedConstantBufferIndex = 11;
      ShaderReplaceMod::traceUnmodifiedShaders = true;
      if (!reshade::register_addon(hModule)) return FALSE;

      reshade::register_event<reshade::addon_event::present>(on_present);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(hModule);
      reshade::unregister_event<reshade::addon_event::present>(on_present);
      break;
  }

  UserSettingUtil::use(fdwReason, &userSettings, &onPresetOff);
  SwapChainUpgradeMod::use(fdwReason);
  ShaderReplaceMod::use(fdwReason, customShaders, &shaderInjection);

  return TRUE;
}
