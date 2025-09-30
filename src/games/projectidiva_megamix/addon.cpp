/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
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

ShaderInjectData shader_injection;

// from batman ak
bool OnToneMapDraw(reshade::api::command_list* cmd_list, float i) {
  shader_injection.callback_tonemap_isdrawn = i;
  return true;
}

renodx::mods::shader::CustomShaders custom_shaders = {
    // __ALL_CUSTOM_SHADERS,

    CustomShaderEntry(0x56443BE9),
    CustomShaderEntry(0x62D69253),
    CustomShaderEntry(0xE67536D6),
    CustomShaderEntry(0xD0162389),
    CustomShaderEntry(0x67B157BC),
    CustomShaderEntry(0x5EE147A2),
    CustomShaderEntry(0x26AF16B8),
    CustomShaderEntry(0x7F6C8EC7),

    CustomShaderEntryCallback(0x7CFCDF1A, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 0.f); }),
    CustomShaderEntryCallback(0x6047C5DE, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 1.f); }),
    CustomShaderEntryCallback(0x8CAB805E, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 2.f); }),
    CustomShaderEntryCallback(0x87371E76, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 3.f); }),
    CustomShaderEntryCallback(0xB3273DF8, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 4.f); }),

    CustomShaderEntryCallback(0x55660220, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 5.f); }),
    CustomShaderEntryCallback(0x29307B56, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 6.f); }),
    CustomShaderEntryCallback(0x5A8C281C, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 7.f); }),
    CustomShaderEntryCallback(0xCBB08175, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 8.f); }),
    CustomShaderEntryCallback(0xD4CB36EE, [](reshade::api::command_list* cmd_list) { return OnToneMapDraw(cmd_list, 9.f); }),

    // // CustomShaderEntry(0x00000000),
    // // CustomSwapchainShader(0x00000000),
    // // BypassShaderEntry(0x00000000)
};

// Presets //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void ApplyPresets(const renodx::utils::settings::Settings& settings, const std::vector<std::unordered_map<std::string, float>>& presets) {
  for (auto* setting : settings) {
    // skip if not exist or not resettable
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
// };

// Settings //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
float current_settings_mode = 0;
renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"NORMAL", "HARD", "EXTREME"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &renodx::utils::swapchain::fps_limit,
        .default_value = 0.f,
        .can_reset = false,
        .label = "FPS Limit",
        .tooltip = "Swapchain FPS limiter.",
        .min = 0.f,
        .max = 1000.f,
        .format = "%.3f",
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
    //     .tint = 0xcc56c2,
    //     .on_change = []() {
    //       ApplyPresets(settings, {PRESET_RENODRT, PRESET_TRADEOFF_BALANCED});
    //     },
    // },

    // Read Me //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Don't use Exclusive Fullscreen (though RenoDX should have already enforced).",
        .section = "Read Me (IMPORTANT)",
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BULLET,
    //     .label = "Those on portable / lower end can activate HDR10 swapchain encoding at the bottom.",
    //     .section = "Read Me (IMPORTANT)",
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "PVs can render sprites and other overlays after ToneMapPass and before HUD,\n"
                 "making them dependent on the UI Brightness slider.",
        .section = "Read Me (IMPORTANT)",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Some gameplay HUD elems are made dimmer (see Extra section) since it will flashbang you otherwise.",
        .section = "Read Me (IMPORTANT)",
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
        .tooltip = "Sets the tone mapper type.\n"
                   "- ACES is not recommended if you want to keep to stay true to the original chroma.",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
    },

    new renodx::utils::settings::Setting{
        .key = "CustomTonemap2ndMode",
        .binding = &shader_injection.custom_tonemap2nd_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Behavior",
        .section = "Tone Mapping",
        .tooltip = "Either use the real linear luminance before SDR tonemapping, or inverse it from the SDR tonemapped.\n"
                   "- Inverse is only useful for SDR capped songs like Catch the Wave, Deep Sea City Underground, etc.\n"
                   "- Auto switches between depending on tone map used.",
        .labels = {"Auto", "Real", "Inverse"},
        .tint = 0x00ad99,
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomTonemap2ndInvPre",
        .binding = &shader_injection.custom_tonemap2nd_inv_preexposure,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 0.75f,
        .can_reset = true,
        .label = "Inv: Pre",
        .section = "Tone Mapping",
        .tooltip = "Multiplier on the color before inverse tonemap.",
        .tint = 0x00ad99,
        .max = 2.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 2 && shader_injection.custom_tonemap2nd_mode != 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomTonemap2ndInvPow",
        .binding = &shader_injection.custom_tonemap2nd_inv_pow,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.3f,
        .can_reset = true,
        .label = "Inv: Power",
        .section = "Tone Mapping",
        .tooltip = "Inverse tonemap power.",
        .tint = 0x00ad99,
        .max = 4.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.custom_tonemap2nd_mode != 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomTonemap2ndInvPost",
        .binding = &shader_injection.custom_tonemap2nd_inv_exposure,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 4.f,
        .can_reset = true,
        .label = "Inv: Post",
        .section = "Tone Mapping",
        .tooltip = "Multiplier on the color after inverse tonemap.",
        .tint = 0x00ad99,
        .max = 8.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 2 && shader_injection.custom_tonemap2nd_mode != 1; },
    },

    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = "",
    //     .section = "Tone Mapping",
    // },

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
    // new renodx::utils::settings::Setting{
    //     .key = "CustomMovieShoulderPow",
    //     .binding = &shader_injection.custom_mov_shoulderpow,
    //     .default_value = 2.75f,
    //     .label = "Movie AutoHDR Threshold",
    //     .section = "Tone Mapping",
    //     .tooltip = "Threshold/Strength for PumboAutoHDR to brighten.",
    //     .min = 1.f,
    //     .max = 5.f,
    //     .format = "%.2f",
    // },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 3; },
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
        .tint = 0xcc56c2,
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
                   "- Turning it in down linearizes the color. You can be the one to apply grading yourself.",
        .tint = 0xcc56c2,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
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

    // Extra //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "CustomSprites",
        .binding = &shader_injection.custom_sprites,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1,
        .label = "Draw Sprites",
        .section = "Extra",
        .tooltip = "Draw or skip all 2D camera canvas textures.",
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomHUDBrightnessHealthBar",
        .binding = &shader_injection.custom_hudbrightness_healthbar,
        .default_value = 30.f,
        .label = "HUD Brightness: Health Bar",
        .section = "Extra",
        .tooltip = "The health bar on top.\n"
                   "This will get very bright when it flashes!",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomHUDBrightnessHealthBarDelta",
        .binding = &shader_injection.custom_hudbrightness_healthbardelta,
        .default_value = 50.f,
        .label = "HUD Brightness: Health Bar Delta",
        .section = "Extra",
        .tooltip = "The small bit showing the change in health.\n"
                   "This will get very bright when it flashes!\n"
                   "Warning: This is very naive right now and could effect other drawn sprites.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomHUDBrightnessProgressBar",
        .binding = &shader_injection.custom_hudbrightness_progressbar,
        .default_value = 40.f,
        .label = "HUD Brightness: Progress Bar",
        .section = "Extra",
        .tooltip = "The progress bar on the bottom.\n"
                   "This will get very bright when it flashes!",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomHUDBrightnessNoteResponse",
        .binding = &shader_injection.custom_hudbrightness_noteresponse,
        .default_value = 75.f,
        .label = "HUD Brightness: Note Response",
        .section = "Extra",
        .tooltip = "The shockwave like effect on spawning of & playing a note.\n"
                   "It gets kinda bright when overlapping.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomHUDBrightnessHoldComboBg",
        .binding = &shader_injection.custom_hudbrightness_holdcombobg,
        .default_value = 50.f,
        .label = "HUD Brightness: Hold Combo BG",
        .section = "Extra",
        .tooltip = "The background of the multiple hold notes combo display.\n"
                   "It gets kinda bright flashing on increment.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },

    new renodx::utils::settings::Setting{
        .key = "CustomBloom",
        .binding = &shader_injection.custom_bloom,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.0f,
        .label = "Bloom Final",
        .section = "Extra",
        .tooltip = "Bloom final multiplier.",
        .max = 2.f,
        .format = "%.2f",
    },

    // Pre-ToneMapPass //////////////////////////////////////////////////////////////////////////////////////

    // new renodx::utils::settings::Setting{
    //     .key = "CustomTonemapDebug",
    //     .binding = &shader_injection.custom_tonemap_debug,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0,
    //     .label = "Debug View",
    //     .section = "Pre-ToneMapPass",
    //     .tooltip = "- Off: Normal rendering.\n"
    //                "- Heat Map: Luma categorized by RenoDRT (Green (black), Pink (shadow), Gray (high), Cyan (clip)).\n"
    //                "- Calibration: If needed, calibrate PreExposure so that 1st/2nd matches 3rd for midtones. (color_untonemapped / color_sdr_neutral / color_sdr_graded)",
    //     .labels = {"Off", "Heat Map", "Calibration"},
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomTonemapIdentify",
    //     .binding = &shader_injection.custom_tonemap_identify,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0,
    //     .label = "Debug Identify",
    //     .section = "Pre-ToneMapPass",
    //     .tooltip = "Identify the Tonemap / Uber shader variant number in 4-bit boolean.",
    //     .labels = {"Off", "By Tonemap", "By CustomShaderEntryCallback cbuffer"},
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = "",
    //     .section = "Pre-ToneMapPass",
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },

    new renodx::utils::settings::Setting{
        .key = "CustomPreExposure",
        .binding = &shader_injection.custom_preexposure,
        .default_value = 1.f,
        .label = "PreExposure",
        .section = "Pre-ToneMapPass",
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
        .section = "Pre-ToneMapPass",
        .tooltip = "color_untonemapped to color_sdr_neutral multiplier ratio.\n"
                   "- Regardless of Luma Grading, this acts like exposure.\n"
                   "- However, if Luma Grading is on, changing this can shift where the grading applied.",
        .tint = 0xcc56c2,
        .max = 2.f,
        .format = "%.3f / 1",
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = "",
    //     .section = "Pre-ToneMapPass",
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomPreExposureComplexFudge",
    //     .binding = &shader_injection.custom_preexposure_complexfudge,
    //     .default_value = 7.f,
    //     .label = "PreExposure Future Tone",
    //     .section = "Pre-ToneMapPass",
    //     .tooltip = "For tonemap/uber variants that uses the complex tonemapper.\n"
    //                "This is the fudge value multiplier on the vanilla exposure multiplier.",
    //     .max = 16.f,
    //     .format = "%.2f",
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },

    // BG Sprites //////////////////////////////////////////////////////////////////////////////////////////
    // new renodx::utils::settings::Setting{
    //     .key = "CustomBGSpritesDebug",
    //     .binding = &shader_injection.custom_bgsprites_debug,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Debug View",
    //     .section = "Camera Canvas Background Sprites",
    //     .tooltip = "- Off: Normal rendering.\n"
    //                "- Only: (Requires Luma Grading off) Blacks out 3D elems when sprites are present.",
    //     .labels = {"Off", "Only"},
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },

    new renodx::utils::settings::Setting{
        .key = "CustomBGSpritesIsInverseTonemap",
        .binding = &shader_injection.custom_bgsprites_isinvtonemap,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Inverse Tonemap",
        .section = "Camera Canvas Background Sprites",
        .tooltip = "Use inverse Reinhard for camera canvas sprites rendered before ToneMapPass().",
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomBGSpritesExposure",
        .binding = &shader_injection.custom_bgsprites_exposure,
        .default_value = 0.18f,
        .label = "Exposure",
        .section = "Camera Canvas Background Sprites",
        .tooltip = "Inverse Reinhard exposure for camera canvas sprites rendered before ToneMapPass().\n",
        .max = 1.f,
        .format = "%.3f",
        .is_enabled = []() { return shader_injection.custom_bgsprites_isinvtonemap; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    // Mov //////////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "CustomMovMultiplier",
        .binding = &shader_injection.custom_mov_multiplier,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Fullscreen Movies",
        .tooltip = "Multiplier (before UpscaleVideoPass()).\n"
                   "- For BRING IT ON, they knew how seizure inducing it is and exported the video without reaching max SDR.",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomMovIsUpscale",
        .binding = &shader_injection.custom_mov_isupscale,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Inverse Tonemap",
        .section = "Fullscreen Movies",
        .tooltip = "UpscaleVideoPass() (BT2446a inverse tonemap)",
        // .tint = 0xcc56c2,
        // .is_visible = []() { return current_settings_mode >= 1; },
    },

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
        .default_value = 2.f,
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
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BULLET,
    //     .label = "PumboAutoHDR: Filoppi (Pumbo)",
    //     .section = "Credits",
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Developement Help & Bug Hunter: MLGSmallSmoke35",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Bug Hunter & Benchmarker: Pikota",
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
void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  //   if (initialized) return;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  //   auto white_level = 203.f;
  if (!peak.has_value()) peak = 1000.f;

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
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Hatsune Miku: Project DIVA Mega Mix+)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      // reset callback_tonemap_isdrawn
      shader_injection.callback_tonemap_isdrawn = 0;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = false;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = false;

        // renodx::mods::swapchain::set_color_space = false;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;  // else swapchain wont decode correctly
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
        renodx::mods::swapchain::prevent_full_screen = true;

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 4.f,
              .label = "Encoding (Restart Required)",
              .section = "Display Output",
              .labels = {"None (Unknown)", "SRGB (Unsupported)", "2.2 (Unsupported)", "2.4 (Unsupported)", "HDR10 (Faster?)", "scRGB (Best)"},
              .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
              .on_change_value = [](float previous, float current) {
                bool is_hdr10 = current == 4;
                shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f);
                // return void
              },
              .is_global = true,
              //   .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool is_hdr10 = setting->GetValue() == 4;
          renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          renodx::mods::swapchain::use_resize_buffer = setting->GetValue() < 4;
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
          settings.push_back(setting);
        }
        // renodx::mods::swapchain::SetUseHDR10(false);
        // renodx::mods::swapchain::use_resize_buffer = false;
        // shader_injection.swap_chain_encoding_color_space = 0.f;

        {
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r8g8b8a8_unorm,
              .new_format = reshade::api::format::r16g16b16a16_float,  // r16g16b16a16_float or r16g16b16a16_typeless, dont matter
              .ignore_size = false,
              .use_resource_view_cloning = false,  // true doesnt matter
              .aspect_ratio = 16. / 9.,
              .aspect_ratio_tolerance = 0.02f,
              .usage_include = reshade::api::resource_usage::resolve_dest,
          });
        }

        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
