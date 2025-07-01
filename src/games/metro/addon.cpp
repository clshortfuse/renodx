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
#include "../../utils/random.hpp"
#include "./shared.h"

namespace {

// renodx::mods::shader::CustomShaders custom_shaders = {
//     UpgradeRTVReplaceShader(0x5C867D7E),  // uber1
//     UpgradeRTVReplaceShader(0xF398A1ED),  // uber1 gasmask
//     UpgradeRTVReplaceShader(0xA453ADB1),  // uber2
//     UpgradeRTVReplaceShader(0xFA7FE535),  // uber2 gasmask
// };

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;
float current_settings_mode = 0;

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
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
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
        .is_visible = []() { return current_settings_mode >= 2; },
    },
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
        .key = "ToneMapWhiteClip",
        .binding = &shader_injection.tone_map_white_clip,
        .default_value = 100.f,
        .label = "White Clip",
        .section = "Tone Mapping",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 3; },
        .is_visible = []() { return current_settings_mode >= 2; },
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
        .is_visible = []() { return current_settings_mode >= 2; },
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
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "SceneGradeMethod",
    //     .binding = &CUSTOM_SCENE_GRADE_METHOD,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Tonemap Upgrade Method",
    //     .section = "Scene Grading",
    //     .tooltip = "Selects hue processor",
    //     .labels = {"Vanilla", "Blowout Restoration"},
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
            new renodx::utils::settings::Setting{
        .key = "SceneGradeHueCorrection",
        .binding = &shader_injection.scene_grade_hue_correction,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Scene Grading",
        .max = 100.f,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0 && CUSTOM_SCENE_GRADE_METHOD == 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2.f; },
    },
            new renodx::utils::settings::Setting{
        .key = "SceneGradeHueShift",
        .binding = &shader_injection.scene_grade_hue_shift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Scene Grading",
        .max = 100.f,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0 && CUSTOM_SCENE_GRADE_METHOD == 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SceneGradeSaturationCorrection",
        .binding = &shader_injection.scene_grade_saturation_correction,
        .default_value = 100.f,
        .label = "Saturation Correction",
        .section = "Scene Grading",
        .max = 100.f,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0 && CUSTOM_SCENE_GRADE_METHOD == 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SceneGradeBlowoutRestoration",
        .binding = &shader_injection.scene_grade_blowout_restoration,
        .default_value = 50.f,
        .label = "Blowout Restoration",
        .section = "Scene Grading",
        .max = 100.f,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0 && CUSTOM_SCENE_GRADE_METHOD == 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "ColorGradeStrength",
        .binding = &RENODX_COLOR_GRADE_STRENGTH,
        .default_value = 100.f,
        .label = "Tonemap Grade Strength",
        .section = "Scene Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "CustomColorGradeTwo",
        .binding = &CUSTOM_COLOR_GRADE_TWO,
        .default_value = 100.f,
        .label = "Color Grading Strength",
        .section = "Scene Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f;},
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    //         new renodx::utils::settings::Setting{
    //     .key = "SceneGradeStrength",
    //     .binding = &shader_injection.scene_grade_strength,
    //     .default_value = 100.f,
    //     .label = "Tonemapper Strength",
    //     .section = "Scene Grading",
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 2.f; },
    // },
    //   new renodx::utils::settings::Setting{
    //     .key = "LutGradeStrength",
    //     .binding = &shader_injection.custom_lut_strength,
    //     .default_value = 100.f,
    //     .label = "LUT Grade",
    //     .section = "Scene Grading",
    //     .tooltip = "Strength of the secondary grading pass",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 2.f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapHueProcessor",
    //     .binding = &RENODX_TONE_MAP_HUE_PROCESSOR,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Hue Processor",
    //     .section = "Tone Mapping",
    //     .tooltip = "Selects hue processor",
    //     .labels = {"OKLab", "ICtCp"},
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapHueShift",
    //     .binding = &RENODX_TONE_MAP_HUE_SHIFT,
    //     .default_value = 50.f,
    //     .label = "Hue Shift",
    //     .section = "Tone Mapping",
    //     .tooltip = "Hue-shift emulation strength.",
    //     .min = 0.f,
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapWorkingColorSpace",
    //     .binding = &RENODX_TONE_MAP_WORKING_COLOR_SPACE,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Working Color Space",
    //     .section = "Tone Mapping",
    //     .labels = {"BT709", "BT2020", "AP1"},
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapHueCorrection",
    //     .binding = &RENODX_TONE_MAP_HUE_CORRECTION,
    //     .default_value = 100.f,
    //     .label = "Hue Correction",
    //     .section = "Tone Mapping",
    //     .tooltip = "Hue retention strength.",
    //     .min = 0.f,
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &RENODX_TONE_MAP_EXPOSURE,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &RENODX_TONE_MAP_HIGHLIGHTS,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &RENODX_TONE_MAP_SHADOWS,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &RENODX_TONE_MAP_CONTRAST,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &RENODX_TONE_MAP_SATURATION,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &RENODX_TONE_MAP_BLOWOUT,
        .default_value = 33.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return fmax(value * 0.01f, 0.000001f); },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainStrength",
        .binding = &CUSTOM_FILM_GRAIN_STRENGTH,
        .default_value = 0.f,
        .label = "Film Grain Strength",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
     new renodx::utils::settings::Setting{
        .key = "FxBloomStrength",
        .binding = &CUSTOM_BLOOM_STRENGTH,
        .default_value = 50.f,
        .label = "Bloom Strength",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    //      new renodx::utils::settings::Setting{
    //     .key = "FxLensFlare",
    //     .binding = &CUSTOM_LENS_FLARE,
    //     .default_value = 50.f,
    //     .label = "Lens Flare Strength",
    //     .section = "Effects",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
         new renodx::utils::settings::Setting{
        .key = "FxLensDirt",
        .binding = &CUSTOM_LENS_DIRT,
        .default_value = 50.f,
        .label = "Lens Dirt Strength",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    //     new renodx::utils::settings::Setting{
    //     .key = "FxAntiAliasing",
    //     .binding = &CUSTOM_ANTI_ALIASING,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 1.f,
    //     .label = "FXAA",
    //     .section = "Effects",
    //     .labels = {"Off", "On"},
    //     //.is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeLUTStrength",
    //     .binding = &CUSTOM_LUT_STRENGTH,
    //     .default_value = 100.f,
    //     .label = "LUT Strength",
    //     .section = "Color Grading",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
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
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeLUTSampling",
    //     .binding = &CUSTOM_LUT_TETRAHEDRAL,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 1.f,
    //     .label = "LUT Sampling",
    //     .section = "Color Grading",
    //     .labels = {"Trilinear", "Tetrahedral"},
    //     .is_visible = []() { return current_settings_mode >= 2; },
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
    //     .key = "FxNoise",
    //     .binding = &CUSTOM_NOISE,
    //     .default_value = 50.f,
    //     .label = "Noise",
    //     .section = "Effects",
    //     .tooltip = "Noise pattern added to game in some areas.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "FxScreenGlow",
    //     .binding = &CUSTOM_SCREEN_GLOW,
    //     .default_value = 100.f,
    //     .label = "Screen Glow",
    //     .section = "Effects",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "FxMotionBlur",
    //     .binding = &CUSTOM_MOTION_BLUR,
    //     .default_value = 100.f,
    //     .label = "Motion Blur",
    //     .section = "Effects",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
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
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More RenoDX Mods",
        .section = "Links",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx/wiki/Mods/");
        },
    },
            new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Jon's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/kickfister");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "This build was compiled on " + build_date + " at " + build_time + ".",
        .section = "About",
    },
 };

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapWhiteClip", 100.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 1.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueShift", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapWorkingColorSpace", 1.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 0.f);
  //renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeStrength", 100.f);
  renodx::utils::settings::UpdateSetting("CustomColorGradeTwo", 100.f);
  renodx::utils::settings::UpdateSetting("FxFilmGrainStrength", 0.f);
  renodx::utils::settings::UpdateSetting("FxBloomStrength", 50.f);
  renodx::utils::settings::UpdateSetting("FxLensFlare", 50.f);
  renodx::utils::settings::UpdateSetting("FxLensDirt", 50.f);
  //renodx::utils::settings::UpdateSetting("FxAntiAliasing", 1.f);
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


}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Metro 2033 and Last Light Redux";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      renodx::utils::random::binds.push_back(&shader_injection.custom_random);

      renodx::utils::random::Use(fdw_reason);

      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_index = 13;

      //renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::revert_constant_buffer_ranges = true;
      //renodx::mods::shader::allow_multiple_push_constants = true;
      //renodx::mods::shader::trace_unmodified_shaders = true;
      //renodx::mods::swapchain::use_resize_buffer = true;

      renodx::mods::swapchain::force_borderless = true;
      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::force_screen_tearing = true;
      //renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;



      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          //.ignore_size = true,
          //.use_resource_view_hot_swap = true,
          .aspect_ratio = -1,
          //.usage_include = reshade::api::resource_usage::render_target,
          //.use_resource_view_cloning_and_upgrade = true,
          
      });
    //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
    //     .old_format = reshade::api::format::b8g8r8a8_unorm,
    //     .new_format = reshade::api::format::r16g16b16a16_float,
    //     //.use_resource_view_cloning = true,
    //     .aspect_ratio = -1,
    //     //.use_resource_view_cloning_and_upgrade = true,
    // });


      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  //renodx::mods::swapchain::Use(fdw_reason);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  //renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}
