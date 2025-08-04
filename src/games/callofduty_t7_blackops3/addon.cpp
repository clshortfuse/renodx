/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x00000000),

    // final
    CustomShaderEntry(0x3D461B1A),  // game
    CustomShaderEntry(0x224A8BF5),  // main menu

    // tonemap
    CustomShaderEntry(0x59F328E3),  // game
    CustomShaderEntry(0x1744B1D4),  // main menu

    // extra
    CustomShaderEntry(0x8F563B81),  // fsfx slide
    CustomShaderEntry(0x8324B585),  // rec709 disabled
    CustomShaderEntry(0x2D7D9715),  // loading movies
    CustomShaderEntry(0xDA908072),  // fsfx blur
    CustomShaderEntry(0xE6F1994E),  // xray outline
    CustomShaderEntry(0x4493183C),  // xray outline 1

    // map specific
    CustomShaderEntry(0x3E9C52D5),  // Shangri-la water
    CustomShaderEntry(0xADBF1975),  // SoE/Revelations Teleport

    // ui
    CustomShaderEntry(0x3DE15138),
    CustomShaderEntry(0x6868CE30),
    CustomShaderEntry(0xED7F350C),
    CustomShaderEntry(0xC1B964B5),
    CustomShaderEntry(0xBCC9B252),
    CustomShaderEntry(0xBC5DA296),
    CustomShaderEntry(0xB00EE6B3),
    CustomShaderEntry(0x11920281),
    CustomShaderEntry(0x835A90CD),
    CustomShaderEntry(0x95E507B2),
    CustomShaderEntry(0x54AFA103),
    CustomShaderEntry(0x9CFEB747),
    CustomShaderEntry(0x5AC2F001),
    CustomShaderEntry(0x2B62907A),

    // CustomSwapchainShader(0x00000000),

    // BypassShaderEntry(0x00000000)

};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

const std::unordered_map<std::string, float> PRESET_RENODRT = {
    {"ToneMapType", 3.f},
    {"ColorGradeExposure", 1.f},
    {"ColorGradeHighlights", 50.f},
    {"ColorGradeShadows", 50.f},
    {"ColorGradeSaturation", 50.f},
    {"ColorGradeHighlightSaturation", 50.f},
    {"ColorGradeBlowout", 0.f},
    {"ColorGradeFlare", 0.f},
};

const std::unordered_map<std::string, float> PRESET_SCREENSHOT_10000 = {
    {"ToneMapPeakNits", 10000.f},
    {"CustomShowFSFXBlur", 0.f},
    {"CustomShowHUD", 0.f},
};

const std::unordered_map<std::string, float> PRESET_ACES = {
    {"ToneMapType", 2.f},
    {"ColorGradeExposure", 1.5f},
    {"ColorGradeHighlights", 50.f},
    {"ColorGradeShadows", 60.f},
    {"ColorGradeSaturation", 50.f},
    {"ColorGradeHighlightSaturation", 50.f},
    {"ColorGradeBlowout", 0.f},
};

const std::unordered_map<std::string, float> PRESET_TRADEOFF_RAW = {
    {"CustomTradeoffRatio", 0.f},
};
const std::unordered_map<std::string, float> PRESET_TRADEOFF_HDR = {
    {"CustomTradeoffRatio", 1.f},
    {"CustomTradeoffMode", 1.f},
    {"CustomTradeoffGammaAmount", 2.2f}};
const std::unordered_map<std::string, float> PRESET_TRADEOFF_BALANCED = {
    {"CustomTradeoffRatio", 10.f},
    {"CustomTradeoffMode", 1.f},
    {"CustomTradeoffGammaAmount", 2.2f}};
};  // namespace
const std::unordered_map<std::string, float> PRESET_TRADEOFF_FSFX = {
    {"CustomTradeoffRatio", 10.f},
    {"CustomTradeoffMode", 3.f},
};
const std::unordered_map<std::string, float> PRESET_TRADEOFF_PQ = {
    {"CustomTradeoffRatio", 5.f},
    {"CustomTradeoffMode", 2.f},
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .group = "button-line-1",
        .on_change = []() {
          for (auto setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
          renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
        },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: RenoDRT (Balanced Tradeoff)",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (PRESET_RENODRT.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_RENODRT.at(setting->key));
            } else if (PRESET_TRADEOFF_BALANCED.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_TRADEOFF_BALANCED.at(setting->key));
            }
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: ACES (Balanced Tradeoff)",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (PRESET_ACES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_ACES.at(setting->key));
            } else if (PRESET_TRADEOFF_BALANCED.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_TRADEOFF_BALANCED.at(setting->key));
            }
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: Screenshot (No Tradeoff & HUD)",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (PRESET_RENODRT.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_RENODRT.at(setting->key));
            } else if (PRESET_TRADEOFF_RAW.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_TRADEOFF_RAW.at(setting->key));
            } else if (PRESET_SCREENSHOT_10000.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_SCREENSHOT_10000.at(setting->key));
            }
          } },
        // .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- (IMPORTANT) Don't use Exclusive Fullscreen."
                 "\n- (IMPORTANT) check out \"Tradeoff\" section for HDR vs Fullscreen Overlay FX tradeoffs."
                 "\n- Game settings for Brightness and Rec.709/sRGB doesn't do anything."
                 "\n- All of the LUTs need black level lowering."
                 "\n\t- You stick to the orignal intent, as the raised black / shadow is sometimes colored."
                 "\n\t- Else, you can use \"Flare\" or download Black Floor Lowering ReShade shader by Lilium."
                 "\n- Try the ACES preset. Some LUTs (e.g., Town Reimagined) favor its contrast and hue shift.",
        .section = "Read Me",
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
        // .on_change =
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 1.f,
        .max = 10000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 1.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 1.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Peak",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- The game renders fullscreen overlay fx shaders (e.g., SoE portal transition & beast mode) at maximum value (32768).\n"
                 "When they get composited over the linear tonemapped HDR image (median value around 1), you get flashbanged\n"
                 "Fixing this with just RenoDX requires reducing the brightness of each individual shader in the game, which becomes unattainable accounting for custom maps.\n"
                 "By converting the linear HDR image to another color space and brightening, it can be composited better.\n"
                 "This becomes a tradeoff between the fullscreen overlay shader's brightness/contrast and HDR peak brightness (hard to notice, turn Game Brightness to 1 to check).\n",
        .section = "Tradeoff",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: Balanced (Default)",
        .section = "Tradeoff",
        .group = "button-line-1",
        .tooltip = "Though the overlays has a bit more contrast, you perceptually have full range for highlights.",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (PRESET_TRADEOFF_BALANCED.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_TRADEOFF_BALANCED.at(setting->key));
            }
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: Favor HDR (Non-perceptual Gain)",
        .section = "Tradeoff",
        .group = "button-line-1",
        .tooltip = "If Balanced not being enough... somehow."
                   "\nOverlays will be annoyingly bright.",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (PRESET_TRADEOFF_HDR.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_TRADEOFF_HDR.at(setting->key));
            }
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: Favor Overlays (Clipping HDR)",
        .section = "Tradeoff",
        .group = "button-line-1",
        .tooltip = "Overlays are more preserved in linear but you clip the details of brightness.",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (PRESET_TRADEOFF_FSFX.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_TRADEOFF_FSFX.at(setting->key));
            }
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: PQ (Constrasty Overlays)",
        .section = "Tradeoff",
        .group = "button-line-2",
        .tooltip = "Overlays have crazy contrast but not flashbang bright."
                   "\nHDR brightness is along the PQ curve which retains all brightness.",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (PRESET_TRADEOFF_PQ.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_TRADEOFF_PQ.at(setting->key));
            }
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: Raw (Screenshots)",
        .section = "Tradeoff",
        .group = "button-line-2",
        .tooltip = "Unplayable, only useful for screenshots."
                   "\nYou will get flashbanged by any unfixed fullscreen overlay fx",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (PRESET_TRADEOFF_RAW.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_TRADEOFF_RAW.at(setting->key));
            }
          }
        },
    },

    new renodx::utils::settings::Setting{
        .key = "CustomTradeoffRatio",
        .binding = &shader_injection.custom_tradeoff_ratio,
        .default_value = 10.f,
        .label = "Tradeoff Brightness Ratio",
        .section = "Tradeoff",
        .tooltip = "Increasing the value lowers overlay fx brightness at the cost of clipping HDR brightness.",
        .max = 100.f,
        .format = "%.2f",
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomTradeoffMode",
        .binding = &shader_injection.custom_tradeoff_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tradeoff Mode / Color Space",
        .section = "Tradeoff",
        .tooltip = "Each provides a slightly different (unnoticible) quantization pattern, and changes contrast of overlay fx.",
        .labels = {"sRGB", "Gamma", "PQ", "Linear (None)"},
        .is_enabled = []() { return shader_injection.custom_tradeoff_ratio > 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomTradeoffGammaAmount",
        .binding = &shader_injection.custom_tradeoff_gamma_amount,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 2.2f,
        .can_reset = true,
        .label = "Tradeoff Gamma Correction",
        .section = "Tradeoff",
        .min = 0.01f,
        .max = 4.f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.custom_tradeoff_mode == 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "CustomBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Extra",
        .max = 200.f,
        .parse = [](float value) { return pow(value * 0.01f, 2.f); },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomSlideLensDirt",
        .binding = &shader_injection.custom_slide_lens_dirt,
        .default_value = 100.f,
        .label = "Slide Lens Dirt",
        .section = "Extra",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomXrayOutline",
        .binding = &shader_injection.custom_xray_outline,
        .default_value = 100.f,
        .label = "Xray Outline (other players & objectives)",
        .section = "Extra",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomShowHUD",
        .binding = &shader_injection.custom_show_hud,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "HUD (not comprehensive)",
        .section = "Extra",
        // .labels = {"False", "True"},
    },
    new renodx::utils::settings::Setting{
        .key = "CustomShowFSFXBlur",
        .binding = &shader_injection.custom_show_fsfx_blur,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Blur (pause screen & maybe when dazzed)",
        .section = "Extra",
        // .labels = {"False", "True"},
    },

    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Display Output",
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
    new renodx::utils::settings::Setting{
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Intermediate Encoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.gamma_correction + 1.f;
            return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.intermediate_encoding;
            return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Gamma Correction",
        .section = "Display Output",
        .labels = {"None", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Black Ops 3 mod by XgarhontX"
                 "\n- RenoDX by clshortfuse"
                 "\n- PumboAutoHDR shader (used for loading movies) by Filoppi",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Build Date: " + build_date + " - " + build_time,
        .section = "Credits",
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDRDen Discord",
        .section = "Credits",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Credits",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

bool initialized = false;

// namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Call of Duty: Black Ops 3)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        // renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
        // renodx::mods::swapchain::swapchain_proxy_revert_state = true;
        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
            // {
            //     reshade::api::device_api::d3d12,
            //     {
            //         .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
            //         .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
            //     },
            // },
        };

        // {
        //   auto* setting = new renodx::utils::settings::Setting{
        //       .key = "SwapChainForceBorderless",
        //       .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        //       .default_value = 0.f,
        //       .label = "Force Borderless",
        //       .section = "Display Output",
        //       .tooltip = "Forces fullscreen to be borderless for proper HDR",
        //       .labels = {
        //           "Disabled",
        //           "Enabled",
        //       },
        //       .on_change_value = [](float previous, float current) { renodx::mods::swapchain::force_borderless = (current == 1.f); },
        //       .is_global = true,
        //       .is_visible = []() { return current_settings_mode >= 2; },
        //   };
        //   renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
        //   renodx::mods::swapchain::force_borderless = (setting->GetValue() == 1.f);
        //   settings.push_back(setting);
        // }

        {
          //   auto* setting = new renodx::utils::settings::Setting{
          //       .key = "SwapChainPreventFullscreen",
          //       .value_type = renodx::utils::settings::SettingValueType::INTEGER,
          //       .default_value = 0.f,
          //       .label = "Prevent Fullscreen",
          //       .section = "Display Output",
          //       .tooltip = "Prevent exclusive fullscreen for proper HDR",
          //       .labels = {
          //           "Disabled",
          //           "Enabled",
          //       },
          //       .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
          //       .is_global = true,
          //       .is_visible = []() { return current_settings_mode >= 2; },
          //   };
          //   renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          //   renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
          //   settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 5.f,
              .label = "Encoding (Restart Required)",
              .section = "Display Output",
              .labels = {"None", "SRGB (Unsupported)", "2.2 (Unsupported)", "2.4 (Unsupported)", "HDR10", "scRGB"},
              .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
              .on_change_value = [](float previous, float current) {
                bool is_hdr10 = current == 4;
                shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f);
                // return void
              },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool is_hdr10 = setting->GetValue() == 4;
          renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          renodx::mods::swapchain::use_resize_buffer = setting->GetValue() < 4;
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
          settings.push_back(setting);

          //   bool is_hdr10 = true;
          //   renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          //   renodx::mods::swapchain::use_resize_buffer = false;
          //   shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
        }

        //  r8g8b8a8_unorm
        // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //     .old_format = reshade::api::format::r8g8b8a8_unorm,
        //     .new_format = reshade::api::format::r16g16b16a16_float,
        //     .ignore_size = true,
        //     .use_resource_view_cloning = true,
        //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,  // to catch lower internal res maybe
        //     .usage_include = reshade::api::resource_usage::resolve_source,
        // });
        // std::stringstream s;
        // s << "Applying user resource upgrade for r8g8b8a8_unorm";
        // reshade::log::message(reshade::log::level::info, s.str().c_str());

        // r8_unorm
        //  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //      .old_format = reshade::api::format::r8_unorm,
        //      .new_format = reshade::api::format::r16_unorm,
        //      .ignore_size = true,
        //      // .use_resource_view_cloning = true,
        //      .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,  // to catch lower internal res maybe
        //      .usage_include = reshade::api::resource_usage::resolve_source,
        //  });

        //  r11g11b10_float
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r11g11b10_float,
            .new_format = reshade::api::format::r16g16b16a16_float,  // requires alpha, else it starts lagging. 32bit isnt a valid render target. r16g16b16a16_float
            // .index = 0,
            .ignore_size = true,
            .shader_hash = 0x224A8BF5,
            .use_resource_view_cloning = true,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::render_target,
        });
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
