/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x0BD2C9BA.h>
#include <embed/0x121F4325.h>
#include <embed/0x192E4012.h>
#include <embed/0x2A6705F5.h>
#include <embed/0x353A9EDA.h>
#include <embed/0x3C417D7D.h>
#include <embed/0x528CB4B5.h>
#include <embed/0x82BED845.h>
#include <embed/0x9BA33763.h>
#include <embed/0x9D9CE449.h>
#include <embed/0xA293670C.h>
#include <embed/0xB2DE2A96.h>
#include <embed/0xB3A6A785.h>
#include <embed/0xD5E94F6D.h>
#include <embed/0xE6453EB0.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Just Cause 4";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Just Cause 4";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomSwapchainShader(0x2A6705F5),  // 00
  CustomSwapchainShader(0xA293670C),  // 01
  CustomSwapchainShader(0x121F4325),  // 02
  CustomSwapchainShader(0x0BD2C9BA),  // 03
  CustomSwapchainShader(0x9BA33763),  // 04
  CustomSwapchainShader(0xE6453EB0),  // 05
  CustomSwapchainShader(0x192E4012),  // 06
  CustomSwapchainShader(0x3C417D7D),  // 07
  CustomSwapchainShader(0x9D9CE449),  // game video
  CustomSwapchainShader(0x353A9EDA),  // 08
  CustomSwapchainShader(0xD5E94F6D),  // 13 game overlay
  CustomSwapchainShader(0x82BED845),  // xx
  CustomShaderEntry(0xB3A6A785),
  CustomShaderEntry(0x528CB4B5),
  CustomShaderEntry(0xB2DE2A96)

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
    .key = "fxLensFlare",
    .binding = &shaderInjection.fxLensFlare,
    .defaultValue = 50.f,
    .label = "Lens Flare",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
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
    .key = "fxVignette",
    .binding = &shaderInjection.fxVignette,
    .defaultValue = 50.f,
    .label = "Vignette",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "fxMotionBlur",
    .binding = &shaderInjection.fxMotionBlur,
    .defaultValue = 0.f,
    .label = "Motion Blur",
    .section = "Effects",
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
  UserSettingUtil::updateUserSetting("colorGradingLutStrength", 100.f);
  UserSettingUtil::updateUserSetting("colorGradingLutScaling", 0.f);
  UserSettingUtil::updateUserSetting("fxLensFlare", 50.f);
  UserSettingUtil::updateUserSetting("fxBloom", 50.f);
  UserSettingUtil::updateUserSetting("fxVignette", 50.f);
  // UserSettingUtil::updateUserSetting("fxMotionBlur", 100.f);
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:

      // ShaderReplaceMod::usePipelineLayoutCloning = true;
      // ShaderReplaceMod::forcePipelineCloning = true;
      // ShaderReplaceMod::traceUnmodifiedShaders = true;
      // ShaderReplaceMod::expectedConstantBufferSpace = 1u;

      // SwapChainUpgradeMod::forceBorderless = false;
      // SwapChainUpgradeMod::preventFullScreen = false;

      // SwapChainUpgradeMod::useResizeBuffer = true;
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 0}
      );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 2}
      // );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 1}
      // );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 2}
      // );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r10g10b10a2_typeless, reshade::api::format::r16g16b16a16_typeless, 0}
      // );
      if (!reshade::register_addon(hModule)) return FALSE;
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(hModule);
      break;
  }

  UserSettingUtil::use(fdwReason, &userSettings, &onPresetOff);
  SwapChainUpgradeMod::use(fdwReason);
  ShaderReplaceMod::use(fdwReason, customShaders, &shaderInjection);

  return TRUE;
}
