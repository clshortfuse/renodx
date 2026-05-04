/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define NOMINMAX

#include <chrono>
#include <random>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

float g_draw_ssao_filter = 1.f;

float SetSDR();

float SetHDR();

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x20133A8B),  // Final
    // CustomShaderEntry(0x1920DC80),  // SSAO2
    CustomShaderEntry(0x1920DC80),  // SSAO4
    CustomShaderEntry(0x99D271BE),  // Lutsample
    CustomShaderEntry(0x103B8DEE),  // Sun Shafts 1
    CustomShaderEntry(0xBCC908FC),  // Sun Shafts 2
    CustomShaderEntry(0x9325D090),  // Sun Shafts 3 (+ intermediate pass)
    CustomShaderEntry(0xF70A0EED),  // Lutbuilder
    {
        0xF369BD33,
        {
            // SSAO3 bypass
            .crc32 = 0xF369BD33,
            .on_draw = [](auto* cmd_list) {
              return g_draw_ssao_filter == 1.f;
            },
        },
    },
};

const std::unordered_map<std::string, float> FANTASY_HDR_VALUES = {
        {"ToneMapConfiguration", 1.f},
        {"ColorGradeExposure", 0.70f},
        {"ColorGradeHighlights", 74.f},
        {"ColorGradeShadows", 53.f},
        {"ColorGradeContrast", 50.f},
        {"ColorGradeSaturation", 62.f},
        {"ColorGradeHighlightSaturation", 50.f},
        {"ColorGradeBlowout", 58.f},
        {"ColorGradeFlare", 72.f},
        {"SceneGradeLutStrength", 95.f},
        {"FxChromaticAberration", 0.f},
        {"FxLensDirt", 0.f},
        {"FxSunShafts", 52.f},
};

const std::unordered_map<std::string, float> FILMIC_HDR_VALUES = {
        {"ToneMapConfiguration", 1.f},
        {"ColorGradeExposure", 1.15f},
        {"ColorGradeHighlights", 66.f},
        {"ColorGradeShadows", 55.f},
        {"ColorGradeContrast", 50.f},
        {"ColorGradeSaturation", 55.f},
        {"ColorGradeHighlightSaturation", 50.f},
        {"ColorGradeBlowout", 75.f},
        {"ColorGradeFlare", 86.f},
        {"FxBloom", 60.f},
        {"FxSunShafts", 36.f},
};

const std::unordered_map<std::string, float> VANILLA_SDR_VALUES = {
        {"ToneMapType", 0.f},
        {"GammaCorrection", 0.f},
        {"ToneMapPeakNits", 80.f},
        {"ToneMapGameNits", 80.f},
        {"ToneMapUINits", 80.f},
};

const std::unordered_map<std::string, float> VANILLA_PLUS_SDR_VALUES = {
        {"ToneMapConfiguration", 1.f},
        {"GammaCorrection", 0.f},
        {"ToneMapPeakNits", 80.f},
        {"ToneMapGameNits", 80.f},
        {"ToneMapUINits", 80.f},
        {"ColorGradeHighlights", 70.f},
        {"ColorGradeContrast", 60.f},
        {"ColorGradeSaturation", 54.f},
        {"ColorGradeBlowout", 50.f},
        {"FxSunShafts", 44.f},
};


ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {

    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &RENODX_RENDER_MODE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Advanced"},
        .is_global = true,
    },
    //     new renodx::utils::settings::Setting{
    //     .key = "OutputMode",
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 1.f,
    //     .can_reset = false,
    //     .label = "",
    //     .section = "Output Mode",
    //     .labels = {"SDR", "HDR"},
    //     .parse = [](float value) { if (value == 0){
    //         return SetSDR();
    //     }  
    //         return SetHDR();
    //  },
    //     .is_global = true,
    // },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &RENODX_TONE_MAP_TYPE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .parse = [](float value) { return value * 3.f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapConfiguration",
    //     .binding = &CUSTOM_TONE_MAP_CONFIGURATION,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .can_reset = true,
    //     .label = "Tonemapping Behavior",
    //     .section = "Tone Mapping",
    //     .tooltip = "Set whether the RenoDRT Tonemapper behaves like an upgraded Vanilla tonemapper or uses Custom properties.",
    //     .labels = {"Vanilla", "Custom"},
    //     //.is_enabled = []() { return RENODX_TONE_MAP_TYPE == 3; },
    //     .is_visible = []() { return (settings[0]->GetValue() >= 1); },
    // },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &RENODX_PEAK_WHITE_NITS,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        //.is_visible = []() { return settings[1]->GetValue() == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &RENODX_DIFFUSE_WHITE_NITS,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        //.is_visible = []() { return settings[1]->GetValue() == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &RENODX_GRAPHICS_WHITE_NITS,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        //.is_visible = []() { return settings[1]->GetValue() == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &RENODX_GAMMA_CORRECTION,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        //.is_visible = []() { return settings[0]->GetValue() >= 1 && settings[1]->GetValue() == 1; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapHueProcessor",
    //     .binding = &RENODX_TONE_MAP_HUE_PROCESSOR,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 1.f,
    //     .label = "Hue Processor",
    //     .section = "Tone Mapping",
    //     .tooltip = "Selects hue processor",
    //     .labels = {"OKLab", "ICtCp"},
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 2; },
    // },
// new renodx::utils::settings::Setting{
//         .key = "SceneGradeHueCorrection",
//         .binding = &shader_injection.scene_grade_hue_correction,
//         .default_value = 100.f,
//         .label = "Hue Correction",
//         .section = "Scene Grading",
//         .max = 100.f,
//         .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
//         .parse = [](float value) { return value * 0.01f; },
//         .is_visible = []() { return settings[0]->GetValue() >= 2; },
//     },
//             new renodx::utils::settings::Setting{
//         .key = "SceneGradeHueShift",
//         .binding = &shader_injection.scene_grade_hue_shift,
//         .default_value = 100.f,
//         .label = "Hue Shift",
//         .section = "Scene Grading",
//         .max = 100.f,
//         .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
//         .parse = [](float value) { return value * 0.01f; },
//         .is_visible = []() { return settings[0]->GetValue() >= 2; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "SceneGradeSaturationCorrection",
//         .binding = &shader_injection.scene_grade_saturation_correction,
//         .default_value = 100.f,
//         .label = "Saturation Correction",
//         .section = "Scene Grading",
//         .max = 100.f,
//         .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
//         .parse = [](float value) { return value * 0.01f; },
//         .is_visible = []() { return settings[0]->GetValue() >= 2; },
//     },
    new renodx::utils::settings::Setting{
        .key = "SceneGradeBlowoutRestoration",
        .binding = &shader_injection.scene_grade_blowout_restoration,
        .default_value = 100.f,
        .label = "Blowout Restoration",
        .section = "Scene Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
            new renodx::utils::settings::Setting{
        .key = "SceneGradeLutStrength",
        .binding = &CUSTOM_LUT_STRENGTH,
        .default_value = 100.f,
        .label = "Grading Strength",
        .section = "Scene Grading",
        .tooltip = "Adjusts how much the original grading affects the image.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 3; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
        new renodx::utils::settings::Setting{
        .key = "SceneGradeLutScaling",
        .binding = &CUSTOM_LUT_SCALING,
        .default_value = 100.f,
        .label = "LUT Scaling",
        .section = "Scene Grading",
        .tooltip = "Scales the black/white point of the grading to use the full range.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &RENODX_TONE_MAP_EXPOSURE,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &RENODX_TONE_MAP_HIGHLIGHTS,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &RENODX_TONE_MAP_SHADOWS,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &RENODX_TONE_MAP_CONTRAST,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &RENODX_TONE_MAP_SATURATION,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &RENODX_TONE_MAP_BLOWOUT,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return fmax(value * 0.01f, 0.000001f); },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &RENODX_TONE_MAP_FLARE,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 3; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxChromaticAberration",
        .binding = &CUSTOM_CHROMATIC_ABERRATION,
        .default_value = 50.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tooltip = "Adjust the intensity of color fringing.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &CUSTOM_BLOOM,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxLensDirt",
        .binding = &CUSTOM_LENS_DIRT,
        .default_value = 50.f,
        .label = "Lens Dirt",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxSunShafts",
        .binding = &CUSTOM_SUN_SHAFTS,
        .default_value = 50.f,
        .label = "Sun Shafts",
        .section = "Effects",
        .tooltip = "Adjust the intensity of sun shafts.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },

    new renodx::utils::settings::Setting{
        .key = "DrawSSAOFilter",
        .binding = &g_draw_ssao_filter,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.0f,
        .label = "SSAO Filtering",
        .section = "Effects",
        .tooltip = "Toggles SSAO filtering. Off is sharper. Off recommended with TAA enabled.",
        .labels = {"Off", "On"},
        //.is_global = true,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        //.is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "FxFilmGrain",
    //     .binding = &shader_injection.custom_film_grain,
    //     .default_value = 0.f,
    //     .label = "Film Grain",
    //     .section = "Custom Effects",
    //     .tooltip = "Controls new perceptual film grain. Reduces banding.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Fantasy HDR",
        .section = "Presets",
        .group = "button-line-1",
        .tint = 0x2f4858,
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            //if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
            if (FANTASY_HDR_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, FANTASY_HDR_VALUES.at(setting->key));
            } else {
              renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
            }
          }
        },
        //.is_visible = []() { return settings[1]->GetValue() == 1; },
        
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Filmic HDR",
        .section = "Presets",
        .group = "button-line-1",
        .tint = 0x2f4858,
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            //if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
            if (FILMIC_HDR_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, FILMIC_HDR_VALUES.at(setting->key));
            } else {
              renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
            }
          }
        },
        //.is_visible = []() { return settings[1]->GetValue() == 1; },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Vanilla SDR",
        .section = "Presets",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            //if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
            if (VANILLA_SDR_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, VANILLA_SDR_VALUES.at(setting->key));
            } else {
              renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
            }
          }
        },
        //.is_visible = []() { return settings[1]->GetValue() == 0; },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Vanilla+ SDR",
        .section = "Presets",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            //if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
            if (VANILLA_PLUS_SDR_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, VANILLA_PLUS_SDR_VALUES.at(setting->key));
            } else {
              renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
            }
          }
        },
        //.is_visible = []() { return settings[1]->GetValue() == 0; },
    },

        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-2",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::Launch(
              "https://discord.gg/QgXDCfccRy");
        },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More RenoDX Mods",
        .section = "Links",
        .group = "button-line-3",
        .on_change = []() {
          renodx::utils::platform::Launch(
              "https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-3",
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Donate (Ko-fi)",
        .section = "Links",
        .group = "button-line-3",
        .on_change = []() {
          renodx::utils::platform::Launch("https://ko-fi.com/kickfister");
        },
    },
};  // namespace

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
  renodx::utils::settings::UpdateSetting("FxChromaticAberration", 50.f);
  renodx::utils::settings::UpdateSetting("FxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("FxSunShafts", 50.f);
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  static std::mt19937 random_generator(std::chrono::system_clock::now().time_since_epoch().count());
  static auto random_range = static_cast<float>(std::mt19937::max() - std::mt19937::min());
  CUSTOM_RANDOM = static_cast<float>(random_generator() + std::mt19937::min()) / random_range;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Valheim";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::swapchain::use_resource_cloning = true;
      // renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      // renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      renodx::mods::swapchain::force_borderless = true;
      renodx::mods::swapchain::force_screen_tearing = true;
      
      renodx::mods::shader::force_pipeline_cloning = true;

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.ignore_size = true,
          .use_resource_view_cloning = true,
          .aspect_ratio = -1,
      });
    //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r8g8b8a8_typeless,
    //                                                                  .new_format = reshade::api::format::r16g16b16a16_float,
    //                                                                  //.ignore_size = true,
    //                                                                  .dimensions = {.height = 32u}});

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
