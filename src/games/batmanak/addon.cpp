/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x0C142BB2.h>
#include <embed/0x12200F17.h>
#include <embed/0x2AC7F89E.h>
#include <embed/0x2C2D0899.h>
#include <embed/0x311E0BDA.h>
#include <embed/0x3A4E0B90.h>
#include <embed/0x420BA351.h>
#include <embed/0x45741188.h>
#include <embed/0x5DAD9473.h>
#include <embed/0x7527C8AD.h>
#include <embed/0x8CBD2352.h>
#include <embed/0x8D4B625A.h>
#include <embed/0x8F20CC31.h>
#include <embed/0x931FF3DD.h>
#include <embed/0x93793FBB.h>
#include <embed/0x978BFB09.h>
#include <embed/0xB42A7F40.h>
#include <embed/0xB4B3061C.h>
#include <embed/0xB6B56605.h>
#include <embed/0xBD36EC09.h>
#include <embed/0xC6D12ACD.h>
#include <embed/0xCD1E0E4C.h>
#include <embed/0xD6A846C8.h>
#include <embed/0xDB45CCFE.h>
#include <embed/0xDB56A8CA.h>
#include <embed/0xF01CCC7E.h>
#include <embed/0xF3B4727D.h>
#include <embed/0xFE8B44FC.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Batman: Arkham Knight";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomSwapchainShader(0x2C2D0899),  // UI Text and Text Shadow (With alpha)
  CustomSwapchainShader(0x5DAD9473),  // ui
  CustomSwapchainShader(0x311E0BDA),  // ui
  CustomSwapchainShader(0x2AC7F89E),  // ui
  CustomSwapchainShader(0x7527C8AD),  // ui
  CustomSwapchainShader(0xF3B4727D),  // ui
  CustomSwapchainShader(0x8D4B625A),  // ui
  CustomSwapchainShader(0xBD36EC09),  // ui
  CustomSwapchainShader(0x420BA351),  // ui
  CustomSwapchainShader(0xFE8B44FC),  // ui
  CustomSwapchainShader(0xB4B3061C),  // ui
  CustomSwapchainShader(0xDB56A8CA),  // ui
  CustomSwapchainShader(0x45741188),  // ui
  CustomSwapchainShader(0x8CBD2352),  // ui
  CustomSwapchainShader(0xD6A846C8),  // unknown
  CustomSwapchainShader(0x0C142BB2),  // unknown
  CustomSwapchainShader(0x8F20CC31),  // unknown
  CustomSwapchainShader(0x931FF3DD),  // unknown
  CustomSwapchainShader(0x93793FBB),  // unknown
  CustomSwapchainShader(0xC6D12ACD),  // unknown
  CustomSwapchainShader(0xCD1E0E4C),  // unknown video
  CustomSwapchainShader(0xDB45CCFE),  // unknown
  CustomSwapchainShader(0x12200F17),  // video
  CustomShaderEntry(0xB6B56605),      // tonemap
  CustomShaderEntry(0x978BFB09),      // tonemap + motionblur
  CustomShaderEntry(0xF01CCC7E),      // tonemap + fx
  CustomShaderEntry(0x3A4E0B90),      // tonemap + fx + motionblur
  CustomShaderEntry(0xB42A7F40)       // lens flare
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
    .labels = {"Vanilla", "None", "ACES", "RenoDX"}
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
    .defaultValue = 1.f,
    .canReset = false,
    .label = "Gamma Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapHueCorrection",
    .binding = &shaderInjection.toneMapHueCorrection,
    .defaultValue = 100.f,
    .label = "Hue Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates hue shifting from the vanilla tonemapper",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
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
    .defaultValue = 0.f,
    .label = "Blowout",
    .section = "Color Grading",
    .tooltip = "Controls highlight desaturation due to overexposure.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeExpandGamut",
    .binding = &shaderInjection.colorGradeExpandGamut,
    .defaultValue = 0.f,
    .label = "Gamut Expansion",
    .section = "Color Grading",
    .tooltip = "Generates HDR colors (BT.2020) from bright saturated SDR (BT.709) ones.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
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
    .key = "fxBloom",
    .binding = &shaderInjection.fxBloom,
    .defaultValue = 50.f,
    .label = "Bloom",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
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
  UserSettingUtil::updateUserSetting("toneMapHueCorrection", 0.f);
  UserSettingUtil::updateUserSetting("colorGradeExposure", 1.f);
  UserSettingUtil::updateUserSetting("colorGradeHighlights", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeShadows", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeContrast", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeSaturation", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeExpandGamut", 0.f);
  UserSettingUtil::updateUserSetting("colorGradeLUTStrength", 100.f);
  UserSettingUtil::updateUserSetting("colorGradeBlowout", 0.f);
  UserSettingUtil::updateUserSetting("fxBloom", 50.f);
  UserSettingUtil::updateUserSetting("fxLensFlare", 50.f);
  UserSettingUtil::updateUserSetting("fxVignette", 50.f);
  UserSettingUtil::updateUserSetting("fxFilmGrain", 50.f);
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

      ShaderReplaceMod::traceUnmodifiedShaders = true;
      SwapChainUpgradeMod::forceBorderless = false;
      SwapChainUpgradeMod::preventFullScreen = true;
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_unorm, reshade::api::format::r16g16b16a16_float, 3}
      );

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
