/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <algorithm>

#include <deps/imgui/imgui.h>

#include <embed/shaders.h>

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
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
    CustomShaderEntry(0xCE7EB8C7),  // flim grain overlay v23
    CustomShaderEntry(0xC83E64DF),  // hud
    CustomShaderEntry(0x11C9D257),  // hud_221
    CustomShaderEntry(0x066EBCF7),  // hud v23
    CustomShaderEntry(0xDE517511),  // menu
    CustomShaderEntry(0x89C4A7A4),  // new_menu
    CustomShaderEntry(0x18CFEFF4),  // new_menu_renderless
    CustomShaderEntry(0xFDE6BBAC),  // menu_221_no_render
    CustomShaderEntry(0xD46D9215),  // menu_221
    CustomShaderEntry(0x3BF1C870),  // menu v23
    CustomShaderEntry(0xFBFF99B4),  // new_hud
    CustomShaderEntry(0x80CEFAE4),  // film_grain_new
    CustomShaderEntry(0xE87F9B2E),  // film_grain_221
    CustomShaderEntry(0x21C2AF18),  // composite2
    CustomShaderEntry(0xA8520658),  // composite2_array_multisample
    CustomShaderEntry(0x04D8EA44),  // composite2_array_multisample_blend_rtv1
    CustomShaderEntry(0x4A2023A1),  // composite2_blend_rtv1
    CustomShaderEntry(0x4E63FBE2),  // composite2_multisample
    CustomShaderEntry(0xED7139C7),  // composite2_multisample_blend_rtv1

};

ShaderInjectData shader_injection;

auto last_is_hdr = false;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip =
            "Sets the value of peak white in nits."
            "\nDefault: Windows HDR Peak",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits."
                   "\nDefault: Reference white value for Windows HDR Peak",
        .min = 48.f,
        .max = 1000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a 2.2 EOTF"
                   "\nDefault: On with HDR",
        .labels = {"Off", "UI/Menu Only", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 4.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Applies hue shift emulation before tonemapping",
        .labels = {"None", "Reinhard", "ACES BT709", "ACES AP1", "Filmic"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueProcessor",
        .binding = &shader_injection.toneMapHueProcessor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPerChannel",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Per Channel",
        .section = "Tone Mapping",
        .tooltip = "Applies tonemapping per-channel instead of by luminance",
        .labels = {"Off", "On"},
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
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
        .key = "colorGradeHighlightSaturation",
        .binding = &shader_injection.colorGradeHighlightSaturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
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
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
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
        .key = "processingLUTScaling",
        .binding = &shader_injection.processingLUTScaling,
        .default_value = 100.f,
        .label = "LUT Scaling",
        .section = "Processing",
        .tooltip = "Scales the color grade LUT to full range when size is clamped.",
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
        .key = "processingInternalSampling",
        .binding = &shader_injection.processingInternalSampling,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Internal Sampling",
        .section = "Processing",
        .tooltip = "Selects whether to use the vanilla sampling or PQ for the game's internal rendering LUT.",
        .labels = {"Vanilla", "PQ"},
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
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
  renodx::utils::settings::UpdateSetting("sceneGradingHue", 50.f);
  renodx::utils::settings::UpdateSetting("sceneGradingSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("sceneGradingStrength", 50.f);

  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxVignette", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 0.f);

  renodx::utils::settings::UpdateSetting("processingLUTScaling", 0.f);
  renodx::utils::settings::UpdateSetting("processingLUTOrder", 1.f);
  renodx::utils::settings::UpdateSetting("processingInternalSampling", 0.f);
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  last_is_hdr = renodx::utils::swapchain::IsHDRColorSpace(swapchain);
  if (!last_is_hdr) {
    settings[1]->default_value = 80.f;
    settings[2]->default_value = 80.f;
    settings[3]->default_value = 0.f;
    return;
  }

  settings[3]->default_value = 2.f;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  auto white_level = 203.f;
  if (peak.has_value()) {
    settings[1]->default_value = peak.value();
  } else {
    settings[1]->default_value = 1000.f;
  }

  settings[2]->default_value = renodx::utils::swapchain::ComputeReferenceWhite(settings[1]->default_value);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };
      renodx::mods::shader::expected_constant_buffer_index = 14;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
