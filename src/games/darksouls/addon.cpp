/*
 * Copyright (C) 2024 Carlos Lopez
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0xDFCB6E8B.h>    // Far DoF
// #include <embed/0xE638B2D7.h> // Near DoF
// #include <embed/0x65E2CEE4.h> // Fog Color
#include <embed/0x6FDD08FC.h>    // Bloom
#include <embed/0xF87B3349.h>    // Tonemap
#include <embed/0x64F62639.h>    // UI - some minor elements
#include <embed/0x809881A3.h>    // UI - most elements
#include <embed/0x6024AB96.h>    // UI - Text
#include <embed/0xB0850BF3.h>    // UI? - need to figure out what this does
#include <embed/0xAB7CF260.h>    // Gamma


#include <chrono>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Dark Souls: Remastered";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Dark Souls: Remastered";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0xDFCB6E8B),              // Far DoF
  // CustomShaderEntry(0xE638B2D7),           // Near DoF
  // CustomShaderEntry(0x65E2CEE4),           // Fog Color
  CustomShaderEntry(0x6FDD08FC),              // Bloom  
  CustomShaderEntry(0xF87B3349),              // Tonemap  
  CustomShaderEntry(0x64F62639),              // UI - some elements (found in character creator)
  CustomShaderEntry(0x809881A3),              // UI - most elements
  CustomShaderEntry(0x6024AB96),              // UI - Text
  CustomShaderEntry(0xB0850BF3),              // UI? - not sure what this does
  CustomSwapchainShader(0xAB7CF260),          // Gamma  
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
    .defaultValue = 1,
    .canReset = false,
    .label = "Gamma Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapHueCorrection",
    .binding = &shaderInjection.toneMapHueCorrection,
    .valueType = UserSettingUtil::UserSettingValueType::boolean,
    .defaultValue = 1,
    .canReset = false,
    .label = "Hue Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates hue shifting from the vanilla tonemapper",
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeExposure",
    .binding = &shaderInjection.colorGradeExposure,
    .defaultValue = 1.f,
    .label = "Exposure",
    .section = "Color Grading",
    .max = 20.f,
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
    .defaultValue = 70.f,
    .label = "Blowout",
    .section = "Color Grading",
    .tooltip = "Controls highlight desaturation due to overexposure.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeLUTStrength",
    .binding = &shaderInjection.colorGradeLUTStrength,
    .defaultValue = 100.f,
    .label = "Color Filter Strength",
    .section = "Color Grading",
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
    .defaultValue = 0.f,
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
  UserSettingUtil::updateUserSetting("toneMapHueCorrection", 0);
  UserSettingUtil::updateUserSetting("colorGradeExposure", 1.f);
  UserSettingUtil::updateUserSetting("colorGradeHighlights", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeShadows", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeContrast", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeSaturation", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeBlowout", 70.f);
  UserSettingUtil::updateUserSetting("colorGradeLUTStrength", 100.f);
  UserSettingUtil::updateUserSetting("fxBloom", 50.f);
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

      // ShaderReplaceMod::forcePipelineCloning = true;    
      ShaderReplaceMod::expectedConstantBufferIndex = 11;
      ShaderReplaceMod::traceUnmodifiedShaders = true;
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_unorm, reshade::api::format::r16g16b16a16_float} 
      // );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_float} 
      // );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_unorm_srgb, reshade::api::format::r16g16b16a16_float}
      // );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::b8g8r8a8_unorm, reshade::api::format::r16g16b16a16_float, 0}
      );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r10g10b10a2_unorm, reshade::api::format::r16g16b16a16_float}
      // );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r11g11b10_float, reshade::api::format::r16g16b16a16_float}
      // );
      
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
