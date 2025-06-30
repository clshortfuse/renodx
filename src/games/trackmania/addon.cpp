/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <include/reshade_api_resource.hpp>
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

    // DX11 Only
#define UpgradeRTVReplaceShader(value)       \
{                                          \
    value,                                 \
    {                                      \
        .crc32 = value,                    \
        .code = __##value,                 \
        .on_draw = [](auto* cmd_list) {                                                             \
          auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                         \
          bool changed = false;                                                                     \
          for (auto rtv : rtvs) {                                                                   \
            changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv);   \
          }                                                                                         \
          if (changed) {                                                                            \
            renodx::mods::swapchain::FlushDescriptors(cmd_list);                                    \
            renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0}); \
          }                                                                                         \
          return true; }, \
    },                                     \
}

#define UpgradeRTVShader(value)              \
{                                          \
    value,                                 \
    {                                      \
        .crc32 = value,                    \
        .on_draw = [](auto* cmd_list) {                                                           \
          auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                       \
          bool changed = false;                                                                   \
          for (auto rtv : rtvs) {                                                                 \
            changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv); \
          }                                                                                       \
          if (changed) {                                                                          \
            renodx::mods::swapchain::FlushDescriptors(cmd_list);                                  \
            renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0});      \
          }                                                                                       \
          return true; }, \
    },                                     \
}

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x9AD01C26), // Tonemapping
    CustomShaderEntry(0xADC96AE9), // Bloom + Anamorphic Flare
    CustomShaderEntry(0xB456B938), // Intermediate
    CustomShaderEntry(0x20E947AC), // Grading
    
    //UpgradeRTVShader(0x74B8D7F2), // Custom Skin View
    UpgradeRTVShader(0x20211230), // Custom Skin View
};

// renodx::mods::shader::CustomShaders custom_shaders = {
//     UpgradeRTVReplaceShader(0x9AD01C26), // Tonemapping
//     UpgradeRTVReplaceShader(0xADC96AE9), // Bloom + Anamorphic Flare
//     UpgradeRTVReplaceShader(0xB456B938), // Intermediate
//     UpgradeRTVReplaceShader(0x20E947AC), // Grading

//     UpgradeRTVShader(0x659FFF71), // Grading
// };

ShaderInjectData shader_injection;

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

const std::unordered_map<std::string, float> VANILLA_PLUS_VALUES = {
    {"ColorGradeContrast", 60.f},
    {"ColorGradeSaturation", 80.f},
    {"ColorGradeBlowout", 70.f},
    {"ColorGradeStrength", 70.f},
};

// const std::unordered_map<std::string, float> CUSTOM_VALUES = {
//     {"ToneMapConfiguration", 1.f},
//     {"ToneMapScaling", 1.f},
//     {"ColorGradeHighlights", 58.f},
//     {"ColorGradeContrast", 65.f},
//     {"ColorGradeSaturation", 67.f},
//     {"ColorGradeHighlightSaturation", 42.f},
//     {"ColorGradeBlowout", 40.f},
//     {"ColorGradeFlare", 63.f},
// };

const std::unordered_map<std::string, float> CANNOT_PRESET_VALUES = {
    {"ToneMapPeakNits", 0},
    {"ToneMapGameNits", 0},
    {"ToneMapUINits", 0},
    {"GammaCorrection", 0},
    {"FxBloom", 0},
    {"FxAnamorphicFlare", 0},
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
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
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapConfiguration",
    //     .binding = &CUSTOM_TONE_MAP_CONFIGURATION,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .can_reset = true,
    //     .label = "Tonemapping Style",
    //     .section = "Tone Mapping",
    //     .tooltip = "Choose to honor the original tonemapping or use an experimental tonemapper.",
    //     .labels = {"Vanilla", "Experimental"},
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 2; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1; },
    // },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &RENODX_PEAK_WHITE_NITS,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
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
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &RENODX_TONE_MAP_HUE_PROCESSOR,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp"},
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &RENODX_TONE_MAP_HUE_SHIFT,
        .default_value = 0.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 2 /*&& settings[2]->GetValue() == 0*/; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &RENODX_TONE_MAP_WORKING_COLOR_SPACE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &RENODX_TONE_MAP_HUE_CORRECTION,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
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
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &RENODX_TONE_MAP_PER_CHANNEL,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &RENODX_TONE_MAP_EXPOSURE,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &RENODX_TONE_MAP_HIGHLIGHTS,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
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
        .parse = [](float value) { return max(value * 0.01f, 0.000001f); },
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
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeStrength",
        .binding = &shader_injection.tone_map_color_grade_strength,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 100.f,
        .label = "Pre-Tonemapping Grade",
        .section = "Color Grading",
        .tooltip = "Adjust the strength of original tonemappers color grading.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeStrengthTwo",
        .binding = &shader_injection.tone_map_color_grade_strength_two,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 100.f,
        .label = "Post-Tonemapping Grade",
        .section = "Color Grading",
        .tooltip = "Adjust the strength of the second grading pass. Only used in some tracks.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeLUTStrength",
    //     .binding = &CUSTOM_LUT_STRENGTH,
    //     .default_value = 100.f,
    //     .label = "LUT Strength",
    //     .section = "Color Grading",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1 && settings[2]->GetValue() == 1; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeLUTScaling",
    //     .binding = &CUSTOM_LUT_SCALING,
    //     .default_value = 100.f,
    //     .label = "LUT Scaling",
    //     .section = "Color Grading",
    //     .tooltip = "Scales the color grade LUT to full range when size is clamped.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1 /*&& settings[2]->GetValue() == 0*/; },
    // },
    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Color Grading",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US CRT",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeLUTSampling",
    //     .binding = &CUSTOM_LUT_TETRAHEDRAL,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 1.f,
    //     .label = "LUT Sampling",
    //     .section = "Color Grading",
    //     .labels = {"Trilinear", "Tetrahedral"},
    //     .is_visible = []() { return settings[0]->GetValue() >= 1 && settings[2]->GetValue() == 1; },
    // },

    // new renodx::utils::settings::Setting{
    //     .key = "FxChromaticAberration",
    //     .binding = &CUSTOM_CHROMATIC_ABERRATION,
    //     .default_value = 50.f,
    //     .label = "Chromatic Aberration",
    //     .section = "Effects",
    //     .tooltip = "Adjust the intensity of color fringing.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "FxVignette",
    //     .binding = &CUSTOM_VIGNETTE,
    //     .default_value = 50.f,
    //     .label = "Vignette",
    //     .section = "Effects",
    //     .tooltip = "Adjust the intensity of vignetting in the corners.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    new renodx::utils::settings::Setting{
        .key = "FxAutoExposure",
        .binding = &CUSTOM_AUTO_EXPOSURE,
        .default_value = 100.f,
        .label = "Auto Exposure Strength",
        .section = "Effects",
        .tooltip = "Adjust the intensity of Auto Exposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &CUSTOM_BLOOM,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .tooltip = "Adjust the intensity of bloom.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxAnamorphicFlare",
        .binding = &CUSTOM_ANAMORPHIC_LENS_FLARE,
        .default_value = 50.f,
        .label = "Anamorphic Lens Flare",
        .section = "Effects",
        .tooltip = "Adjust the intensity light streaking on areas that receive bloom.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "FxDOF",
    //     .binding = &CUSTOM_DOF,
    //     .default_value = 100.f,
    //     .label = "Depth of Field",
    //     .section = "Effects",
    //     .tooltip = "Adjust the intensity of Depth of Field.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "FxSpeedLines",
    //     .binding = &CUSTOM_SPEED_LINES,
    //     .default_value = 50.f,
    //     .label = "Speed Lines",
    //     .section = "Effects",
    //     .tooltip = "Adjust the intensity of Speed Lines.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Vanilla+",
        .section = "Presets",
        .group = "button-line-1",
        .tint = 0x2f4858,
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
            if (VANILLA_PLUS_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, VANILLA_PLUS_VALUES.at(setting->key));
            } else {
              renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
            }
          }
        },
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Experimental",
    //     .section = "Presets",
    //     .group = "button-line-1",
    //     .tint = 0x2f4858,
    //     .on_change = []() {
    //       for (auto* setting : settings) {
    //         if (setting->key.empty()) continue;
    //         if (!setting->can_reset) continue;
    //         if (setting->is_global) continue;
    //         if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
    //         if (CUSTOM_VALUES.contains(setting->key)) {
    //           renodx::utils::settings::UpdateSetting(setting->key, CUSTOM_VALUES.at(setting->key));
    //         } else {
    //           renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
    //         }
    //       }
    //     },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-2",
        .on_change = []() {
          for (auto setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "HDR Look",
    //     .section = "Options",
    //     .group = "button-line-1",
    //     .on_change = []() {
    //       for (auto setting : settings) {
    //         if (setting->key.empty()) continue;
    //         if (!setting->can_reset) continue;
    //         if (setting->key == "ColorGradeSaturation" || setting->key == "ColorGradeContrast" || setting->key == "ColorGradeBlowout") {
    //           renodx::utils::settings::UpdateSetting(setting->key, 80.f);
    //         } else {
    //           renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
    //         }
    //       }
    //     },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Options",
        .group = "button-line-3",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::Launch(
              "https://discord.gg/"
              "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Options",
        .group = "button-line-3",
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Game mod by Jon (OopyDoopy/Kickfister)",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "RenoDX framework created by Shortfuse! HDR Analysis made possible by Lilium!",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "This build was compiled on " + build_date + " at " + build_time + ".",
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapConfiguration", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  // renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 1.f);
  // renodx::utils::settings::UpdateSetting("ToneMapHueShift", 1.f);
  // renodx::utils::settings::UpdateSetting("ToneMapWorkingColorSpace", 1.f);
  // renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 1.f);
  renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);
  // renodx::utils::settings::UpdateSetting("ToneMapScaling", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeShadows", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeContrast", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeFlare", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTScaling", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTSampling", 0.f);
  renodx::utils::settings::UpdateSetting("FxColorGradeStrength", 100.f);
  renodx::utils::settings::UpdateSetting("FxPostColorGrading", 100.f);
  renodx::utils::settings::UpdateSetting("FxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("FxAnamorphicFlare", 50.f);
  renodx::utils::settings::UpdateSetting("FxAutoExposure", 100.f);
}

bool fired_on_init_swapchain = false;

float buffer_width = GetSystemMetrics(SM_CXSCREEN);
float buffer_height = GetSystemMetrics(SM_CYSCREEN);

//float buffer_width = static_cast<float>(reshade::api::resource_desc().texture.width);
//float buffer_height = static_cast<float>(reshade::api::resource_desc().texture.height);

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }

}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Trackmania";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::swapchain_proxy_revert_state = true;

      //renodx::mods::shader::force_pipeline_cloning = true;

      renodx::mods::shader::expected_constant_buffer_index = 11;
      renodx::mods::swapchain::expected_constant_buffer_index = 11;

      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::force_borderless = false;

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          //.use_resource_view_hot_swap = true,
          //.aspect_ratio = -1,
          //.use_resource_view_cloning_and_upgrade = true,
      });

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.ignore_size = true,
          .use_resource_view_cloning = true,
          //.use_resource_view_hot_swap = true,
          .aspect_ratio = -1,
          //.use_resource_view_cloning_and_upgrade = true,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::b8g8r8a8_typeless,
        .new_format = reshade::api::format::r16g16b16a16_float,
        //.ignore_size = true,
        .use_resource_view_cloning = true,
        //.use_resource_view_hot_swap = true,
        .aspect_ratio = buffer_width / (buffer_height / 1.061946902654867f),
        //.aspect_ratio = 0,
        //.use_resource_view_cloning_and_upgrade = true,
    });
       renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::b8g8r8a8_typeless,
        .new_format = reshade::api::format::r16g16b16a16_float,
        //.ignore_size = true,
        .use_resource_view_cloning = true,
        //.use_resource_view_hot_swap = true,
        .aspect_ratio = 1024.f / 512.f,
        //.aspect_ratio = 0,
        //.use_resource_view_cloning_and_upgrade = true,
    });
       renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::b8g8r8a8_typeless,
        .new_format = reshade::api::format::r16g16b16a16_float,
        //.ignore_size = true,
        .use_resource_view_cloning = true,
        //.use_resource_view_hot_swap = true,
        .aspect_ratio = 1920.f / 540.f,
        //.aspect_ratio = 0,
        //.use_resource_view_cloning_and_upgrade = true,
    });
    //     renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
    //     .old_format = reshade::api::format::b8g8r8a8_typeless,
    //     .new_format = reshade::api::format::r16g16b16a16_float,
    //     //.ignore_size = true,
    //     .use_resource_view_cloning = true,
    //     //.use_resource_view_hot_swap = true,
    //     .aspect_ratio = 616.f / 276.f,
    //     //.aspect_ratio = 0,
    //     //.use_resource_view_cloning_and_upgrade = true,
    // });
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::b8g8r8a8_typeless,
        .new_format = reshade::api::format::r16g16b16a16_float,
        //.ignore_size = true,
        .use_resource_view_cloning = true,
        //.use_resource_view_hot_swap = true,
        .aspect_ratio = (buffer_width - 360) / (buffer_height - 80),
        //.aspect_ratio = 0,
        //.use_resource_view_cloning_and_upgrade = true,
    });
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::b8g8r8a8_typeless,
        .new_format = reshade::api::format::r16g16b16a16_float,
        //.ignore_size = true,
        .use_resource_view_cloning = true,
        //.use_resource_view_hot_swap = true,
        .aspect_ratio = (buffer_width - 560) / (buffer_height - 160),
        //.aspect_ratio = 0,
        //.use_resource_view_cloning_and_upgrade = true,
    });
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::b8g8r8a8_typeless,
        .new_format = reshade::api::format::r16g16b16a16_float,
        //.ignore_size = true,
        .use_resource_view_cloning = true,
        //.use_resource_view_hot_swap = true,
        .aspect_ratio = (buffer_width - 240) / (buffer_height - 96),
        //.aspect_ratio = 0,
        //.use_resource_view_cloning_and_upgrade = true,
    });
       renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r11g11b10_float,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .aspect_ratio = -1,
        .use_resource_view_cloning_and_upgrade = true,
        //.use_resource_view_hot_swap = true,
    });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
