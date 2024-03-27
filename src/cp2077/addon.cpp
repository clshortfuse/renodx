/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <embed/0x298A6BB0.h>
#include <embed/0x5DF649A9.h>
#include <embed/0x61DBBA5C.h>
#include <embed/0x71F27445.h>
#include <embed/0x745E34E1.h>
#include <embed/0x97CA5A85.h>
#include <embed/0xA61F2FEE.h>
#include <embed/0xB489149F.h>
#include <embed/0xBF8489D2.h>
#include <embed/0xC783FBA1.h>
#include <embed/0xC83E64DF.h>
#include <embed/0xCBFFC2A3.h>
#include <embed/0xD2BBEBD9.h>
#include <embed/0xDE517511.h>
#include <embed/0xE57907C4.h>
#include <filesystem>
#include <fstream>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../common/shaderReplaceMod.hpp"
#include "../common/userSettingUtil.hpp"
#include "./cp2077.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - CP2077";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

static ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0xCBFFC2A3),  // output
  CustomShaderEntry(0x298A6BB0),  // composite multisample
  CustomShaderEntry(0xBF8489D2),  // composite multisample lowbit
  CustomShaderEntry(0x5DF649A9),  // composite
  CustomShaderEntry(0xA61F2FEE),  // composite lowbit
  CustomShaderEntry(0x71F27445),  // tonemapper
  CustomShaderEntry(0x61DBBA5C),  // tonemapper sdr
  CustomShaderEntry(0x97CA5A85),  // tonemapper lowbit
  CustomShaderEntry(0x745E34E1),  // tonemapper sdr lowbit
  CustomShaderEntry(0xC783FBA1),  // film grain overlay
  CustomShaderEntry(0xC83E64DF),  // hud
  CustomShaderEntry(0xD2BBEBD9),  // film grain gen
  CustomShaderEntry(0xDE517511),  // menu
  CustomShaderEntry(0xB489149F),  // menu3
  CustomShaderEntry(0xE57907C4)   // menu4
};

ShaderInjectData shaderInjection;

// clang-format off
UserSettingUtil::UserSettings userSettings = {
  new UserSettingUtil::UserSetting {
    .key = "toneMapType",
    .binding = &shaderInjection.toneMapType,
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .defaultValue = 2.f,
    .label = "Tone Mapper",
    .section = "Tone Mapping",
    .tooltip = "Sets the tone mapper type",
    .labels = {"Vanilla", "None", "ACES", "OpenDRT"}
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapPeakNits",
    .binding = &shaderInjection.toneMapPeakNits,
    .defaultValue = 1000.f,
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
    .label = "Game Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of 100%% white in nits",
    .min = 48.f,
    .max = 500.f
  },
    new UserSettingUtil::UserSetting {
    .key = "toneMapGammaCorrection",
    .binding = &shaderInjection.toneMapGammaCorrection,
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .defaultValue = 0.f,
    .label = "Gamma Correction",
    .section = "Tone Mapping",
    .tooltip = "Adjusts for 2.2 pure gamma instead of sRGB piecewise EOTF",
    .labels = { "None", "Menus Only", "Always"}
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
    .key = "colorGradeWhitePoint",
    .binding = &shaderInjection.colorGradeWhitePoint,
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .defaultValue = 1.f,
    .label = "White Point",
    .section = "Color Grading",
    .tooltip = "Selects whether to force the game's whitepoint",
    .labels = { "D60", "Vanilla", "D65"},
    .parse = [](float value) { return value - 1.f; }
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
    .label = "Custom Film Grain",
    .section = "Effects",
    .tooltip = "Adjusts the strength of the custom perceptual film grain",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "processingLUTCorrection",
    .binding = &shaderInjection.processingLUTCorrection,
    .defaultValue = 50.f,
    .label = "LUT Correction",
    .section = "Processing",
    .tooltip = "Selects the strength of LUT correction process when color grading LUTs are not full range.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "processingLUTOrder",
    .binding = &shaderInjection.processingLUTOrder,
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .defaultValue = 1.f,
    .label = "LUT Order",
    .section = "Processing",
    .tooltip = "Selects whether to force when color grading LUTs are applied.",
    .labels = {"Before Tone Map", "Vanilla", "After Tone Map" },
    .parse = [](float value) { return value - 1.f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "processingInternalSampling",
    .binding = &shaderInjection.processingInternalSampling,
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .defaultValue = 1.f,
    .label = "Internal Sampling",
    .section = "Processing",
    .tooltip = "Selects whether to use the vanilla sampling or PQ for the game's internal rendering LUT.",
    .labels = {"Vanilla", "PQ" }
  },
#ifdef DEBUG_SLIDERS
  new UserSettingUtil::UserSetting {
    .key = "debug01",
    .binding = &shaderInjection.debug01,
    .defaultValue = 50.f,
    .label = "Debug 01",
    .section = "Debug",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  }
#endif
};

// clang-format on

static void onPresetOff() {
  UserSettingUtil::updateUserSetting("toneMapType", 0);
  UserSettingUtil::updateUserSetting("toneMapPeakNits", 1000.f);
  UserSettingUtil::updateUserSetting("toneMapGameNits", 203.f);
  UserSettingUtil::updateUserSetting("toneMapGammaCorrection", 0);
  UserSettingUtil::updateUserSetting("colorGradeExposure", 1.f);
  UserSettingUtil::updateUserSetting("colorGradeHighlights", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeShadows", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeContrast", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeSaturation", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeWhitePoint", 1);
  UserSettingUtil::updateUserSetting("colorGradeLUTStrength", 100.f);
  UserSettingUtil::updateUserSetting("colorGradeSceneGrading", 100.f);
  UserSettingUtil::updateUserSetting("fxBloom", 50.f);
  UserSettingUtil::updateUserSetting("fxVignette", 50.f);
  UserSettingUtil::updateUserSetting("fxFilmGrain", 0.f);
  UserSettingUtil::updateUserSetting("processingLUTCorrection", 0.f);
  UserSettingUtil::updateUserSetting("processingLUTOrder", 1.f);
  UserSettingUtil::updateUserSetting("processingInternalSampling", 0.f);
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

      ShaderReplaceMod::expectedConstantBufferIndex = 14;
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(hModule);
      break;
  }

  UserSettingUtil::use(fdwReason, &userSettings, &onPresetOff);

  ShaderReplaceMod::use(fdwReason, &customShaders, &shaderInjection);

  return TRUE;
}
