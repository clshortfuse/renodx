/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x0F2CC0D1.h>
#include <embed/0x13EEBAE5.h>
#include <embed/0x153BE4A2.h>
#include <embed/0x21C1F78D.h>
#include <embed/0x261AE7AB.h>
#include <embed/0x33F1B3F8.h>
#include <embed/0x34AEF9A7.h>
#include <embed/0x43E69DB9.h>
#include <embed/0x4FB4DA20.h>
#include <embed/0x61CC29E6.h>
#include <embed/0x72826F5B.h>
#include <embed/0x8024E8B5.h>
#include <embed/0x80802E60.h>
#include <embed/0x83660755.h>
#include <embed/0x8CAC3BD9.h>
#include <embed/0x8E032125.h>
#include <embed/0x8F009507.h>
#include <embed/0xB14DB0F4.h>
#include <embed/0xB74B05F4.h>
#include <embed/0xCC4CAE26.h>
#include <embed/0xECFC10A2.h>

#include <chrono>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include "../common/shaderReplaceMod.hpp"
#include "../common/swapChainUpgradeMod.hpp"
#include "../common/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Fallout 4";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Fallout 4";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomSwapchainShader(0x72826F5B),  // cursor
  CustomSwapchainShader(0x21C1F78D),  // ui compsite
  CustomSwapchainShader(0xB14DB0F4),  // ui boxes
  CustomSwapchainShader(0x0F2CC0D1),  // video
  CustomSwapchainShader(0x8F009507),  // renderselect
  CustomShaderEntry(0x80802E60),      // luts
  CustomShaderEntry(0xB74B05F4),      // vignette
  BypassShaderEntry(0x48292339),
  CustomShaderEntry(0x8CAC3BD9),  // taa (sdr only)
  CustomShaderEntry(0x61CC29E6),  // taa2 (sdr only)
  CustomShaderEntry(0x8024E8B5),  // tonemap
  CustomShaderEntry(0x4FB4DA20),  // fxaa (clamping bt709)
  CustomShaderEntry(0x83660755),
  CustomSwapchainShader(0x13EEBAE5),
  CustomSwapchainShader(0x153BE4A2),
  CustomSwapchainShader(0x261AE7AB),
  CustomSwapchainShader(0x33F1B3F8),
  CustomSwapchainShader(0x34AEF9A7),
  CustomSwapchainShader(0x43E69DB9),
  // CustomSwapchainShader(0x86EC0382),
  CustomSwapchainShader(0x8E032125),
  CustomSwapchainShader(0xCC4CAE26),
  CustomSwapchainShader(0xECFC10A2)

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
    .key = "fxVignette",
    .binding = &shaderInjection.fxVignette,
    .defaultValue = 50.f,
    .label = "Vignette",
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
  UserSettingUtil::updateUserSetting("fxVignette", 50.f);
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
      SwapChainUpgradeMod::forceBorderless = false;
      SwapChainUpgradeMod::preventFullScreen = false;
      // ShaderReplaceMod::forcePipelineCloning = true;
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
  ShaderReplaceMod::use(fdwReason, &customShaders, &shaderInjection);

  return TRUE;
}
