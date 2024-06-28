/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <deps/imgui/imgui.h>

#include <embed/0x298A6BB0.h>
#include <embed/0x341CEB87.h>
#include <embed/0x5DF649A9.h>
#include <embed/0x61DBBA5C.h>
#include <embed/0x71F27445.h>
#include <embed/0x745E34E1.h>
#include <embed/0x97CA5A85.h>
#include <embed/0xA61F2FEE.h>
#include <embed/0xBF8489D2.h>
#include <embed/0xC783FBA1.h>
#include <embed/0xC83E64DF.h>
#include <embed/0xCBFFC2A3.h>
#include <embed/0xDE517511.h>

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"
#include "../../utils/user_setting.hpp"
#include "./cp2077.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
  CustomShaderEntry(0xCBFFC2A3),  // output
  CustomShaderEntry(0x341CEB87),  // upscale
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
  CustomShaderEntry(0xDE517511)   // menu
};

ShaderInjectData shader_injection;

// clang-format off
renodx::utils::user_settings::UserSettings user_settings = {
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapType",
    .binding = &shader_injection.toneMapType,
    .value_type = renodx::utils::user_settings::UserSettingValueType::INTEGER,
    .default_value = 3.f,
    .can_reset = false,
    .label = "Tone Mapper",
    .section = "Tone Mapping",
    .tooltip = "Sets the tone mapper type",
    .labels = {"Vanilla", "None", "ACES", "RenoDRT"}
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapPeakNits",
    .binding = &shader_injection.toneMapPeakNits,
    .default_value = 1000.f,
    .can_reset = false,
    .label = "Peak Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of peak white in nits",
    .min = 48.f,
    .max = 4000.f
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapGameNits",
    .binding = &shader_injection.toneMapGameNits,
    .default_value = 203.f,
    .can_reset = false,
    .label = "Game Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of 100%% white in nits",
    .min = 48.f,
    .max = 1000.f
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapGammaCorrection",
    .binding = &shader_injection.toneMapGammaCorrection,
    .value_type = renodx::utils::user_settings::UserSettingValueType::INTEGER,
    .default_value = 0.f,
    .can_reset = false,
    .label = "Gamma Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
    .labels = { "Off", "UI/Menu Only", "On"}
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeExposure",
    .binding = &shader_injection.colorGradeExposure,
    .default_value = 1.f,
    .label = "Exposure",
    .section = "Color Grading",
    .max = 10.f,
    .format = "%.2f"
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeHighlights",
    .binding = &shader_injection.colorGradeHighlights,
    .default_value = 50.f,
    .label = "Highlights",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeShadows",
    .binding = &shader_injection.colorGradeShadows,
    .default_value = 50.f,
    .label = "Shadows",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeContrast",
    .binding = &shader_injection.colorGradeContrast,
    .default_value = 50.f,
    .label = "Contrast",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeSaturation",
    .binding = &shader_injection.colorGradeSaturation,
    .default_value = 50.f,
    .label = "Saturation",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeWhitePoint",
    .binding = &shader_injection.colorGradeWhitePoint,
    .value_type = renodx::utils::user_settings::UserSettingValueType::INTEGER,
    .default_value = 1.f,
    .label = "White Point",
    .section = "Color Grading",
    .tooltip = "Selects whether to force the game's whitepoint",
    .labels = { "D60", "Vanilla", "D65"},
    .parse = [](float value) { return value - 1.f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeLUTStrength",
    .binding = &shader_injection.colorGradeLUTStrength,
    .default_value = 100.f,
    .label = "LUT Strength",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeSceneGrading",
    .binding = &shader_injection.colorGradeSceneGrading,
    .default_value = 100.f,
    .label = "Scene Grading",
    .section = "Color Grading",
    .tooltip = "Selects the strength of the game's custom scene grading.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "fxBloom",
    .binding = &shader_injection.fxBloom,
    .default_value = 50.f,
    .label = "Bloom",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "fxVignette",
    .binding = &shader_injection.fxVignette,
    .default_value = 50.f,
    .label = "Vignette",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "fxFilmGrain",
    .binding = &shader_injection.fxFilmGrain,
    .default_value = 50.f,
    .label = "Custom Film Grain",
    .section = "Effects",
    .tooltip = "Adjusts the strength of the custom perceptual film grain",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "processingLUTCorrection",
    .binding = &shader_injection.processingLUTCorrection,
    .default_value = 50.f,
    .label = "LUT Correction",
    .section = "Processing",
    .tooltip = "Selects the strength of LUT correction process when color grading LUTs are not full range.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "processingLUTOrder",
    .binding = &shader_injection.processingLUTOrder,
    .value_type = renodx::utils::user_settings::UserSettingValueType::INTEGER,
    .default_value = 1.f,
    .label = "LUT Order",
    .section = "Processing",
    .tooltip = "Selects whether to force when color grading LUTs are applied.",
    .labels = {"Before Tone Map", "Vanilla", "After Tone Map" },
    .parse = [](float value) { return value - 1.f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "processingInternalSampling",
    .binding = &shader_injection.processingInternalSampling,
    .value_type = renodx::utils::user_settings::UserSettingValueType::INTEGER,
    .default_value = 1.f,
    .label = "Internal Sampling",
    .section = "Processing",
    .tooltip = "Selects whether to use the vanilla sampling or PQ for the game's internal rendering LUT.",
    .labels = {"Vanilla", "PQ" }
  },
};

// clang-format on

void OnPresetOff() {
  renodx::utils::user_settings::UpdateUserSetting("toneMapType", 0);
  renodx::utils::user_settings::UpdateUserSetting("toneMapPeakNits", 1000.f);
  renodx::utils::user_settings::UpdateUserSetting("toneMapGameNits", 203.f);
  renodx::utils::user_settings::UpdateUserSetting("toneMapGammaCorrection", 0);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeExposure", 1.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeHighlights", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeShadows", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeContrast", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeSaturation", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeWhitePoint", 1);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeSceneGrading", 100.f);
  renodx::utils::user_settings::UpdateUserSetting("fxBloom", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("fxVignette", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("fxFilmGrain", 0.f);
  renodx::utils::user_settings::UpdateUserSetting("processingLUTCorrection", 0.f);
  renodx::utils::user_settings::UpdateUserSetting("processingLUTOrder", 1.f);
  renodx::utils::user_settings::UpdateUserSetting("processingInternalSampling", 0.f);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      renodx::mods::shader::expected_constant_buffer_index = 14;

      if (!reshade::register_addon(h_module)) return FALSE;

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::user_settings::Use(fdw_reason, &user_settings, &OnPresetOff);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
