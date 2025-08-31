/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <vector>
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

    CustomShaderEntry(0x57CF6767),  // bloom

    // tonemap
    CustomShaderEntry(0x59F328E3),  // game
    CustomShaderEntry(0x1744B1D4),  // main menu

    // FSFX
    CustomShaderEntry(0x8F563B81),  // fsfx slide
    CustomShaderEntry(0x0A90E591),  // motionblur
    CustomShaderEntry(0xDA908072),  // fsfx blur
    CustomShaderEntry(0xE6F1994E),  // xray outline
    CustomShaderEntry(0x4493183C),  // xray outline 1
    CustomShaderEntry(0x9AF0BA45),  // sight 1
    CustomShaderEntry(0xF0897820),  // sight 2
    CustomShaderEntry(0x423C810B),  // dni

    // FSFX: map specific
    CustomShaderEntry(0x3E9C52D5),  // Shangri-la water
    CustomShaderEntry(0xADBF1975),  // SoE/Revelations Teleport
    CustomShaderEntry(0xCF206106),  // zetsu bubbles

    // final
    CustomShaderEntry(0x3D461B1A),  // game
    CustomShaderEntry(0x224A8BF5),  // main menu

    CustomShaderEntry(0x8324B585),  // rec709 disabled

    // loading movies
    CustomShaderEntry(0x2D7D9715),

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
    CustomShaderEntry(0x030282F6),

    // CustomSwapchainShader(0x00000000),

    // BypassShaderEntry(0x00000000)

};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

// Presets //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void ApplyPresets(const renodx::utils::settings::Settings& settings, const std::vector<std::unordered_map<std::string, float>>& presets) {
  for (auto* setting : settings) {
    // skip if not preset or not resettable
    if (setting->key.empty()) continue;
    if (!setting->can_reset) continue;

    // n
    for (std::unordered_map<std::string, float> preset : presets) {
      if (preset.contains(setting->key)) {
        // get
        float value = preset.at(setting->key);

        // case: reset
        if (value == FLT_MIN) value = setting->default_value;

        // set
        renodx::utils::settings::UpdateSetting(setting->key, value);

        // skip other presets
        continue;
      }
    }
  }

  // save
  renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
}

// const std::unordered_map<std::string, float> PRESET_RENODRT = {
//     {"ToneMapType", FLT_MIN},
//     {"CustomTonemapIsUseSDR", FLT_MIN},
//     {"CustomUntonemapBlackFloorRaise", FLT_MIN},
//     {"CustomBloomHDRLocalContrast", FLT_MIN},

//     {"ColorGradeExposure", FLT_MIN},
//     {"ColorGradeHighlights", FLT_MIN},
//     {"ColorGradeShadows", FLT_MIN},
//     {"ColorGradeContrast", FLT_MIN},
//     {"ColorGradeSaturation", FLT_MIN},
//     {"ColorGradeHighlightSaturation", FLT_MIN},
//     {"ColorGradeBlowout", FLT_MIN},
//     {"ColorGradeFlare", FLT_MIN},
// };
// const std::unordered_map<std::string, float> PRESET_RENODRT_1 = {
//     {"ToneMapType", FLT_MIN},
//     {"CustomTonemapIsUseSDR", 1},
//     {"CustomUntonemapBlackFloorRaise", FLT_MIN},
//     {"CustomBloomHDRLocalContrast", 0.9f},

//     {"ColorGradeExposure", FLT_MIN},
//     {"ColorGradeHighlights", FLT_MIN},
//     {"ColorGradeShadows", FLT_MIN},
//     {"ColorGradeContrast", FLT_MIN},
//     {"ColorGradeSaturation", FLT_MIN},
//     {"ColorGradeHighlightSaturation", FLT_MIN},
//     {"ColorGradeBlowout", FLT_MIN},
//     {"ColorGradeFlare", FLT_MIN},
// };
// const std::unordered_map<std::string, float> PRESET_ACES = {
//     {"ToneMapType", 2.f},
//     {"ColorGradeShadows", 70.f},
//     {"ColorGradeSaturation", 40.f},
// };

// const std::unordered_map<std::string, float> PRESET_SCREENSHOT_1000 = {
//     {"ToneMapPeakNits", 1000.f},
//     {"CustomShowFSFXBlur", 0.f},
//     {"CustomShowHUD", 0.f},
// };

// const std::unordered_map<std::string, float> PRESET_TRADEOFF_HDR = {
//     {"CustomTradeoffRatio", 20.f},
//     {"CustomTradeoffMode", 0.f},
//     // {"CustomTradeoffGammaAmount", 2.2f},
// };
const std::unordered_map<std::string, float> PRESET_TRADEOFF_BALANCED = {
    {"CustomTradeoffRatio", FLT_MIN},
    {"CustomTradeoffMode", FLT_MIN},
};
// const std::unordered_map<std::string, float> PRESET_TRADEOFF_FSFX = {
//     {"CustomTradeoffRatio", 10.f},
//     {"CustomTradeoffMode", 3.f},
// };
// const std::unordered_map<std::string, float> PRESET_TRADEOFF_PQ = {
//     {"CustomTradeoffRatio", 5.f},
//     {"CustomTradeoffMode", 2.f},
// };
const std::unordered_map<std::string, float> PRESET_TRADEOFF_RAW = {
    {"CustomTradeoffRatio", 0.f},
    {"CustomTradeoffMode", 1.f},
};

// Settings //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Regular", "Hardened", "Veteran"},
        .is_global = true,
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
          renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
        },
    },

    // Presets //////////////////////////////////////////////////////////////////////////////////////

    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Preset: RenoDRT (Full HDR)",
    //     .group = "button-line-2",
    //     .tooltip = "Fully use HDR luminance with SDR chrominace as color corrections.\n"
    //                "(Works for all Treyarch maps. since they have minor luma correction.)",
    //     .tint = 0xffad42,
    //     .on_change = []() {
    //       ApplyPresets(settings, {PRESET_RENODRT, PRESET_TRADEOFF_BALANCED});
    //     },
    // },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Preset: RenoDRT (Vanilla+)",
    //     .group = "button-line-2",
    //     .tooltip = "Also consider SDR luma for color corrections, meaning unmodifiable raised black floor, compressed SDR highlights, etc.\n"
    //                "(May be needed for custom maps that heavily rely on these effects.)",
    //     .tint = 0xffad42,
    //     .on_change = []() {
    //       ApplyPresets(settings, {PRESET_RENODRT_1, PRESET_TRADEOFF_BALANCED});
    //     },
    // },

    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Preset: ACES",
    //     .group = "button-line-3",
    //     .tooltip = "ACES hue shifting with heavy contrast. Some maps (e.g. Town Reimagined) can use its flavoring.",
    //     .on_change = []() { ApplyPresets(settings, {PRESET_ACES, PRESET_TRADEOFF_BALANCED}); },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },

    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Preset: Screenshot 1000",
    //     .group = "button-line-3",
    //     .tooltip = "You will get flashbanged by fullscreen overlay shaders!",
    //     .on_change = []() { ApplyPresets(settings, {PRESET_RENODRT, PRESET_TRADEOFF_RAW, PRESET_SCREENSHOT_1000}); },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },

    // Read Me //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Don't use Exclusive Fullscreen.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "In-game settings for Brightness and Rec.709/sRGB doesn't do anything.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Please read \"Luma Prioritization\" tooltip!",
        .section = "Read Me",
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = "",
    //     .section = "Read Me",
    // },

    // Tonemap //////////////////////////////////////////////////////////////////////////////////////

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
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "CustomTonemapIsUseSDR",
        .binding = &shader_injection.custom_tonemap_isusesdr,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Luma Prioritization",
        .section = "Tone Mapping",
        .tooltip = "- Vanilla+: Use HDR color, correcting it with SDR luma and chroma grading, customizable down below.\n"
                   "- SDR Dependent: Like older versions, all of SDR color is used unless HDR luma surpasses SDR range. (Bloom customization only comes into effect in HDR range.)\n",
        .labels = {"Vanilla+", "SDR Dependent (Legacy)"},
        .tint = 0xffad42,
        .is_visible = []() { return shader_injection.tone_map_type > 0 /* && current_settings_mode >= 1 */; },
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
        .max = 4000.f,
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
        .key = "CustomMovieShoulderPow",
        .binding = &shader_injection.custom_mov_shoulderpow,
        .default_value = 2.75f,
        .label = "Movie AutoHDR Power",
        .section = "Tone Mapping",
        .tooltip = "Threshold/Strength for PumboAutoHDR to brighten.",
        .min = 1.f,
        .max = 5.f,
        .format = "%.2f",
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
        // .is_visible = []() { return current_settings_mode >= 0; },
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
        .default_value = 0.f,
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

    // Color Grade //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 0; },
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
        .key = "CustomGradeChroma",
        .binding = &shader_injection.custom_grade_chroma,
        .default_value = 100.f,
        .label = "Chroma Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game on chrominace.\n"
                   "- Like 100%, you want this on to apply LUT.",
        .tint = 0xffad42,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomGradeLuma",
        .binding = &shader_injection.custom_grade_luma,
        .default_value = 100.f,
        .label = "Luma Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game on luminance.\n"
                   "- Turning it in down linearizes the color. You can be the one to apply grading yourself.\n"
                   "- For pretty much all Treyarch maps, it looks pretty good if off.\n"
                   "- Some custom maps relying on extreme contrast grading will probably need it dailed up.",
        .tint = 0xffad42,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0 && shader_injection.custom_tonemap_isusesdr == 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading Final",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game in total.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomUntonemapBlackFloorRaise",
        .binding = &shader_injection.custom_blackfloorraise,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Black Floor Raise",
        .section = "Color Grading",
        .tooltip = "Immitate black floor raise like in Vanilla, preserving that tinted shadow / faded photography look.\n"
                   "- Only takes effect as Luma Grading is decreasing to 0.\n"
                   "- In Vanilla, it is the dev's discretion on what they want to set. Treyarch bounces around either options for different maps.",
        .labels = {"0 nits", "0.025 nits", "0.05 nits"},
        .tint = 0xffad42,
        .format = "%.4f",
        .is_enabled = []() { return shader_injection.tone_map_type > 0 && shader_injection.custom_tonemap_isusesdr == 0 && shader_injection.custom_grade_luma < 1; },
        .parse = [](float value) {
            if (value == 0) return 0.f;
            if (value == 1) return 0.0019f;
            if (value == 2) return 0.0034f;
            return 0.f; },
    },

    // Extra //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "CustomSlideLensDirt",
        .binding = &shader_injection.custom_slide_lens_dirt,
        .default_value = 100.f,
        .label = "Slide Lens Dirt",
        .section = "Extra",
        .tooltip = "The subtle bottom of screen lens dirt when sliding.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomADSSights",
        .binding = &shader_injection.custom_ads_sights,
        .default_value = 50.f,
        .label = "ADS Sights",
        .section = "Extra",
        .tooltip = "Should be all vanilla sights, but maybe I missed some.\n"
                   "Also, if mods do their own sights shader, then it's F.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomXrayOutline",
        .binding = &shader_injection.custom_xray_outline,
        .default_value = 100.f,
        .label = "Xray Outline",
        .section = "Extra",
        .tooltip = "Other players and important items / objectives.",
        .max = 200.f,
        .parse = [](float value) { return value * 0.01; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomMotionBlurScale",
        .binding = &shader_injection.custom_motionblur_scale,
        .default_value = 1.f,
        .label = "Motion Blur Scale",
        .section = "Extra",
        .tooltip = "Motion vector sampling length scale.",
        .min = 0.1f,
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "CustomShowHUD",
        .binding = &shader_injection.custom_show_hud,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "HUD",
        .section = "Extra",
        .tooltip = "Not comprehensive, but should be enough for paused screenshots.",
        // .labels = {"False", "True"},
    },
    new renodx::utils::settings::Setting{
        .key = "CustomShowFSFXBlur",
        .binding = &shader_injection.custom_show_fsfx_blur,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Fullscreen Blur",
        .section = "Extra",
        .tooltip = "Pause screen and crawler fart gas.",
        // .labels = {"False", "True"},
    },

    // Bloom //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "CustomBloomSDRSaturation",
        .binding = &shader_injection.custom_bloom_sdr_saturation,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.0f,
        .label = "Bloom Chroma Saturation",
        .section = "Bloom",
        .tooltip = "Saturation for bloom color.",
        .max = 3.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomBloomSDR",
        .binding = &shader_injection.custom_bloom_sdr,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.0f,
        .label = "Bloom Chroma Final",
        .section = "Bloom",
        .tooltip = "Bloom Chroma (color_sdr_graded) final multiplier.\n"
                   "Needs to work in tandem with Bloom HDR, providing chroma info for it.",
        .max = 1.f,
        .format = "%.2f",
    },

    new renodx::utils::settings::Setting{
        .key = "CustomBloomHDRPower",
        .binding = &shader_injection.custom_bloom_hdr_power,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.65f,
        .label = "Bloom Luma Contrast",
        .section = "Bloom",
        .tooltip = "Contrast power.",
        .min = 0.f,
        .max = 3.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomBloomHDRDodge",
        .binding = &shader_injection.custom_bloom_hdr_dodge,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.f,
        .label = "Bloom Luma Dodge",
        .section = "Bloom",
        .tooltip = "Strength of reducing bloom on dark colors, so it's not just pure addition.",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomBloomHDR",
        .binding = &shader_injection.custom_bloom_hdr,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.0f,
        .label = "Bloom Luma Final",
        .section = "Bloom",
        .tooltip = "Bloom Luma (color_untonemapped) final multiplier.\n"
                   "Needs to work in tandem with Bloom SDR, providing luma info for it.",
        .max = 5.f,
        .format = "%.2f",
    },

    // Pre-ToneMapPass //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "CustomTonemapDebug",
        .binding = &shader_injection.custom_tonemap_debug,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0,
        .label = "Debug View",
        .section = "Pre-ToneMapPass: PreExposure",
        .tooltip = "- Off: Normal rendering.\n"
                   "- Heat Map: Luma categorized by RenoDRT (Pink (shadow), Green (mid), Gray (high), Cyan (clip)).\n"
                   "- Calibration: If needed, calibrate PreExposure so that 1st/2nd matches 3rd for midtones. (color_untonemapped / color_sdr_neutral / color_sdr_graded)",
        .labels = {"Off", "Heat Map", "Calibration"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomPreExposure",
        .binding = &shader_injection.custom_preexposure,
        .default_value = 1.f,
        .label = "PreExposure",
        .section = "Pre-ToneMapPass: PreExposure",
        .tooltip = "Scale the color_untonemapped & color_sdr_neutral input by the multiplier.\n"
                   "- If Luma Grading is on, this will only boost highlights.\n"
                   "- Else it's just exposure.",
        .max = 4.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomPreExposureRatio",
        .binding = &shader_injection.custom_preexposure_ratio,
        .default_value = 1.f,
        .label = "PreExposure Ratio",
        .section = "Pre-ToneMapPass: PreExposure",
        .tooltip = "color_untonemapped to color_sdr_neutral multiplier ratio.\n"
                   "- Regardless of Luma Grading, this acts like exposure.\n"
                   "- However, if Luma Grading is on, changing this can shift where and how the grading applied.",
        .tint = 0xffad42,
        .max = 2.f,
        .format = "%.3f / 1",
        // .is_visible = []() { return current_settings_mode >= 2; },
    },

    // Pre-ToneMapPass //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "CustomDiceShoulder",
        .binding = &shader_injection.custom_dice_shoulderstart,
        .default_value = 20.f,
        .label = "Shoulder Threshold",
        .section = "Pre-ToneMapPass: Untonemapped DICE",
        .tooltip = "Threshold (not linear nits value) to start compressing color_untonemapped.\n"
                   "1 = Game Brightness (Max SDR)\n"
                   "100 = Peak Brightness",
        .min = 0.01f,
        .max = 100.0f,
        .format = "%.2f",
        .parse = [](float value) { return value; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomDicePower",
        .binding = &shader_injection.custom_dice_power,
        .default_value = 0.75f,
        .label = "Shoulder Power",
        .section = "Pre-ToneMapPass: Untonemapped DICE",
        .tooltip = "If color_untonemapped's luminance > threshold, aprroximately color * pow.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
        .parse = [](float value) { return value; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    // Tradeoff //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "To composite Fullscreen Overlay Shaders (e.g. SoE beast mode), there is a tradoff in the HDR image's peak brightness and overlay color space missmatch to composite them somewhat correctly.\n"
                 "All is tuned so hopefully you didn't know it was even a thing at first.",
        .section = "Tradeoff",
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: Default",
        .section = "Tradeoff",
        .group = "button-line-1",
        .tooltip = "Overlays are slightly contrasted, but can values reach RenoDRT's expected value of 100.",
        .on_change = []() { ApplyPresets(settings, {PRESET_TRADEOFF_BALANCED}); },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Preset: Favor HDR (Non-perceptual Gain)",
    //     .section = "Tradeoff",
    //     .group = "button-line-1",
    //     .tooltip = "If Balanced not being enough... somehow."
    //                "\nOverlays will be annoyingly bright.",
    //     .on_change = []() { ApplyPresets(settings, {PRESET_TRADEOFF_HDR}); },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Preset: Favor Overlays (Clipping HDR)",
    //     .section = "Tradeoff",
    //     .group = "button-line-1",
    //     .tooltip = "Overlays are more preserved in linear but you clip the details of brightness.",
    //     .on_change = []() { ApplyPresets(settings, {PRESET_TRADEOFF_FSFX}); },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Preset: PQ (Constrasted Overlays)",
    //     .section = "Tradeoff",
    //     .group = "button-line-2",
    //     .tooltip = "Pretty useless..."
    //                "\nPeak brightness is worst than Balanced."
    //                "\nOverlays have crazy contrast because of PQ curve.",
    //     .on_change = []() { ApplyPresets(settings, {PRESET_TRADEOFF_PQ}); },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: Raw (Screenshots)",
        .section = "Tradeoff",
        .group = "button-line-1",
        .tooltip = "Unplayable, only useful for screenshots."
                   "\nYou will get flashbanged by any unfixed fullscreen overlay fx",
        .on_change = []() { ApplyPresets(settings, {PRESET_TRADEOFF_RAW}); },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomTradeoffRatio",
        .binding = &shader_injection.custom_tradeoff_ratio,
        .default_value = 27.f,  // perfect for out value of 100
        .label = "Brightness Ratio",
        .section = "Tradeoff",
        .tooltip = "Increasing the value lowers overlay fx brightness at the cost of clipping HDR brightness.",
        .max = 100.f,
        .format = "%.2f",
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomTradeoffMode",
        .binding = &shader_injection.custom_tradeoff_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Intermediate Color Space",
        .section = "Tradeoff",
        .tooltip = "Each provides a slightly different (unnoticeable) quantization pattern, and changes contrast of overlay fx.",
        .labels = {"sRGB", /* "Gamma", "PQ", */ "Linear (None)"},
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomTradeoffGammaAmount",
    //     .binding = &shader_injection.custom_tradeoff_gamma_amount,
    //     .value_type = renodx::utils::settings::SettingValueType::FLOAT,
    //     .default_value = 2.2f,
    //     .can_reset = true,
    //     .label = "Tradeoff Gamma Correction",
    //     .section = "Tradeoff",
    //     .min = 0.01f,
    //     .max = 4.f,
    //     .format = "%.2f",
    //     .is_visible = []() { return current_settings_mode >= 1 && shader_injection.custom_tradeoff_mode == 1; },
    // },

    // Display Output //////////////////////////////////////////////////////////////////////////////////////

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
        .default_value = 1.f,
        .label = "Gamma Correction UI",
        .section = "Display Output",
        .labels = {"None", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    // Credits & Buttons //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Game Mod: XgarhontX\n",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "RenoDX: clshortfuse\n",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "PumboAutoHDR (loading movies): Filoppi (Pumbo)",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "HDR Consultant: Scrungus",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Coding Help: Musa",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Bug Hunter: NikkMann",
        .section = "Credits",
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Credits",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "9Bm4RZA8");
        },
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
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Build Date: " + build_date + " - " + build_time,
        .section = "Credits",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("TtoneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTScaling", 0.f);
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

bool initialized = false;

}  // namespace

// DllMain //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// from tombraider2013 de
bool fired_on_init_swapchain = false;
void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  auto white_level = 203.f;
  if (!peak.has_value()) {
    peak = 1000.f;
  }

  // find and set
  for (auto& setting : settings) {
    if (setting->binding != &shader_injection.peak_white_nits) continue;
    setting->default_value = peak.value();
    setting->can_reset = true;
    break;
  }

  // settings[3]->default_value = renodx::utils::swapchain::ComputeReferenceWhite(peak.value());
}

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

        renodx::mods::swapchain::force_borderless = false;
        renodx::mods::swapchain::prevent_full_screen = false;

        // SwapChainEncoding
        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 5.f,
              .label = "Encoding (Restart Required)",
              .section = "Display Output",
              .labels = {"None", "SRGB", "2.2", "2.4", "HDR10", "scRGB (Preferred)"},
              .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
              .on_change_value = [](float previous, float current) {
                bool is_hdr10 = current == 4;
                shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f);
                // return void
              },
              .is_global = true,
              // .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool is_hdr10 = setting->GetValue() == 4;
          renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          renodx::mods::swapchain::use_resize_buffer = setting->GetValue() < 4;
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
          settings.push_back(setting);
        }

        // SafeMode
        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SafeMode",
              .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
              .default_value = 0.f,
              .label = "Resource Upgrade Safe Mode (Read Tooltip)",
              .section = "Display Output",
              .tooltip =
                  "(Restart Required) Turning it on disables the bit depth upgrade for the main color texture (11 to 16-bit).\n"
                  "Doing so stops all NaN visual artifacts (e.g. bloom flashing a box, though it should be fixed) at the cost of quantization / posterization.\n"
                  "Use only if the the artifacts too bothersome, and check if the colors are still presentatable for you.",
              .is_global = true,
              // .is_visible = []() { return settings[0]->GetValue() >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          settings.push_back(setting);

          auto value = setting->GetValue();
          if (value == 0) {
            renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
                .old_format = reshade::api::format::r11g11b10_float,
                .new_format = reshade::api::format::r16g16b16a16_float,  // requires alpha, else it starts lagging. 32bit comepletely breaks math.
                .ignore_size = true,                                     // because resolution scaler
                .use_resource_view_cloning = true,
                .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
                .usage_include = reshade::api::resource_usage::render_target,
            });
          }
        }

        // // LUT
        // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //     .old_format = reshade::api::format::r11g11b10_float,
        //     .new_format = reshade::api::format::r16g16b16a16_float,
        //     .ignore_size = true,
        //     .shader_hash = 0x2807E427,
        //     .use_resource_view_cloning = true,
        //     // .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        //     // .dimensions = {.width = 32, .height = 32, .depth = 32},
        //     // .usage_include = reshade::api::resource_usage::cpu_access,
        // });
      }

      // peak nits
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