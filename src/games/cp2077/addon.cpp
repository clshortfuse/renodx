/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <deps/imgui/imgui.h>

#include <embed/0x04D8EA44.h>
#include <embed/0x18CFEFF4.h>
#include <embed/0x21C2AF18.h>
#include <embed/0x298A6BB0.h>
#include <embed/0x341CEB87.h>
#include <embed/0x4A2023A1.h>
#include <embed/0x4E63FBE2.h>
#include <embed/0x5DF649A9.h>
#include <embed/0x61DBBA5C.h>
#include <embed/0x71F27445.h>
#include <embed/0x745E34E1.h>
#include <embed/0x80CEFAE4.h>
#include <embed/0x89C4A7A4.h>
#include <embed/0x97CA5A85.h>
#include <embed/0xA61F2FEE.h>
#include <embed/0xA8520658.h>
#include <embed/0xBF8489D2.h>
#include <embed/0xC783FBA1.h>
#include <embed/0xC83E64DF.h>
#include <embed/0xCBFFC2A3.h>
#include <embed/0xDE517511.h>
#include <embed/0xED7139C7.h>
#include <embed/0xFBFF99B4.h>


#include <include/reshade.hpp>
#include "../../mods/shader.hpp"
#include "../../utils/settings.hpp"
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
    CustomShaderEntry(0xDE517511),  // menu
    CustomShaderEntry(0x89C4A7A4),  // new_menu
    CustomShaderEntry(0x18CFEFF4),  // new_menu_renderless
    CustomShaderEntry(0xFBFF99B4),  // new_hud
    CustomShaderEntry(0x80CEFAE4),  // film_grain_new
    CustomShaderEntry(0x21C2AF18),  // composite2
    CustomShaderEntry(0xA8520658),  // composite2_array_multisample
    CustomShaderEntry(0x04D8EA44),  // composite2_array_multisample_blend_rtv1
    CustomShaderEntry(0x4A2023A1),  // composite2_blend_rtv1
    CustomShaderEntry(0x4E63FBE2),  // composite2_multisample
    CustomShaderEntry(0xED7139C7),  // composite2_multisample_blend_rtv1

};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100%% white in nits",
        .min = 48.f,
        .max = 1000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
        .labels = {"Off", "UI/Menu Only", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 4.f,
        .can_reset = false,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Applies hue shift emulation before tonemapping",
        .labels = {"None", "Reinhard", "ACES BT709", "ACES AP1", "Filmic"},
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 10.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 50.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 50.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeWhitePoint",
        .binding = &shader_injection.colorGradeWhitePoint,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "White Point",
        .section = "Color Grading",
        .tooltip = "Selects whether to force the game's whitepoint",
        .labels = {"D60", "Vanilla", "D65"},
        .parse = [](float value) { return value - 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "sceneGradingLift",
        .binding = &shader_injection.sceneGradingLift,
        .default_value = 50.f,
        .label = "Lift",
        .section = "Scene Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "sceneGradingGamma",
        .binding = &shader_injection.sceneGradingGamma,
        .default_value = 50.f,
        .label = "Gamma",
        .section = "Scene Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "sceneGradingGain",
        .binding = &shader_injection.sceneGradingGain,
        .default_value = 50.f,
        .label = "Gain",
        .section = "Scene Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "sceneGradingBlack",
        .binding = &shader_injection.sceneGradingBlack,
        .default_value = 50.f,
        .label = "Black Floor",
        .section = "Scene Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "sceneGradingColor",
        .binding = &shader_injection.sceneGradingColor,
        .default_value = 50.f,
        .label = "Color Fill",
        .section = "Scene Grading", 
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "sceneGradingClip",
        .binding = &shader_injection.sceneGradingClip,
        .default_value = 50.f,
        .label = "White Clip",
        .section = "Scene Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "sceneGradingStrength",
        .binding = &shader_injection.sceneGradingStrength,
        .default_value = 50.f,
        .label = "Strength",
        .section = "Scene Grading",
        .tooltip = "Selects the strength of the game's custom scene grading.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxVignette",
        .binding = &shader_injection.fxVignette,
        .default_value = 50.f,
        .label = "Vignette",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "Custom Film Grain",
        .section = "Effects",
        .tooltip = "Adjusts the strength of the custom perceptual film grain",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "processingLUTCorrection",
        .binding = &shader_injection.processingLUTCorrection,
        .default_value = 50.f,
        .label = "LUT Correction",
        .section = "Processing",
        .tooltip = "Selects the strength of LUT correction process when color grading LUTs are not full range.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "processingLUTOrder",
        .binding = &shader_injection.processingLUTOrder,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "LUT Order",
        .section = "Processing",
        .tooltip = "Selects whether to force when color grading LUTs are applied.",
        .labels = {"Before Tone Map", "Vanilla", "After Tone Map"},
        .parse = [](float value) { return value - 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "processingGlobalGain",
        .binding = &shader_injection.processingGlobalGain,
        .default_value = 50.f,
        .label = "Global Gain",
        .section = "Processing",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "processingGlobalLift",
        .binding = &shader_injection.processingGlobalLift,
        .default_value = 0.f,
        .label = "Global Lift",
        .section = "Processing",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "processingInternalSampling",
        .binding = &shader_injection.processingInternalSampling,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Internal Sampling",
        .section = "Processing",
        .tooltip = "Selects whether to use the vanilla sampling or PQ for the game's internal rendering LUT.",
        .labels = {"Vanilla", "PQ"},
    },
    // new renodx::utils::settings::Setting{
    //     .key = "debugDrawGraph",
    //     .binding = &shader_injection.debugDrawGraph,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Draw Graph",
    //     .section = "Debug",
    //     .tooltip = "Draws graph showing how input/output process",
    //     .labels = {"Off", "On"},
    // },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 1000.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 0);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeWhitePoint", 1);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);

  renodx::utils::settings::UpdateSetting("sceneGradingLift", 50.f);
  renodx::utils::settings::UpdateSetting("sceneGradingGamma", 50.f);
  renodx::utils::settings::UpdateSetting("sceneGradingGain", 50.f);
  renodx::utils::settings::UpdateSetting("sceneGradingBlack", 50.f);
  renodx::utils::settings::UpdateSetting("sceneGradingWhite", 50.f);
  renodx::utils::settings::UpdateSetting("sceneGradingClip", 50.f);
  renodx::utils::settings::UpdateSetting("sceneGradingStrength", 50.f);

  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxVignette", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 0.f);

  renodx::utils::settings::UpdateSetting("processingLUTCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("processingLUTOrder", 1.f);
  renodx::utils::settings::UpdateSetting("processingInternalSampling", 0.f);
  renodx::utils::settings::UpdateSetting("processingGlobalGain", 50.f);
  renodx::utils::settings::UpdateSetting("processingGlobalLift", 50.f);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

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

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
