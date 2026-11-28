/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64
#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;
float current_settings_mode = 0.f;

// Tone mapper helpers

bool IsRenoDRT() {
  return shader_injection.tone_map_type
         == GEARS5_TONE_MAP_TYPE_RENODRT;
}

bool IsPsycho() {
  return shader_injection.tone_map_type == GEARS5_TONE_MAP_TYPE_PSYCHOV35;
}

bool IsCustomToneMapper() {
  return shader_injection.tone_map_type
         != GEARS5_TONE_MAP_TYPE_VANILLA;
}

// Attach this callback to custom tone-map passes so Vanilla keeps the original bytecode.
bool OnReplaceShader(reshade::api::command_list*) {
  return IsCustomToneMapper();
}

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntryCallback(0xEA1C6FF4, &OnReplaceShader),
    CustomShaderEntryCallback(0xC29D7F6F, &OnReplaceShader),
    CustomShaderEntryCallback(0xF930FE01, &OnReplaceShader),
    CustomShaderEntryCallback(0x4BEE8631, &OnReplaceShader),
    CustomShaderEntryCallback(0x47FB02F4, &OnReplaceShader),
    CustomShaderEntryCallback(0x5BB15E0E, &OnReplaceShader),
    CustomShaderEntryCallback(0x2916AE8A, &OnReplaceShader),

    // Raster counterparts used when Async Compute is disabled.
    CustomShaderEntryCallback(0x18E1E866, &OnReplaceShader),
    CustomShaderEntryCallback(0xEC96FD43, &OnReplaceShader),
    CustomShaderEntryCallback(0xE0F20958, &OnReplaceShader),
    CustomShaderEntryCallback(0xC508355B, &OnReplaceShader),
    CustomShaderEntryCallback(0x4334A02D, &OnReplaceShader),
    CustomShaderEntryCallback(0x8EA022B9, &OnReplaceShader),
    CustomShaderEntryCallback(0xD703EC94, &OnReplaceShader),
};

// Settings

renodx::utils::settings::Settings settings = {

    // General

    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,

        .value_type =
            renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,
        .can_reset = false,

        .label = "Settings Mode",

        .labels = {
            "Simple",
            "Intermediate",
            "Advanced",
        },

        .is_global = true,
    },

    // Tone Mapper

    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 2.f,

        .can_reset = true,

        .label = "Tone Mapper",
        .section = "Tone Mapping",

        .tooltip = "Custom mappers replace the native HDR expansion. Vanilla+ extends the SDR filmic curve while retaining its toe, midgray and artist grading. Vanilla restores the game shaders.",

        .labels = {
            "Vanilla",
            "RenoDRT",
            "PsychoV35",
            "PrismTM",
            "Vanilla+",
        },

        // Convert UI index -> actual internal tone mapper ID.
        .parse = [](float value) {
          if (value < 0.5f) {
            return GEARS5_TONE_MAP_TYPE_VANILLA;
          }

          if (value < 1.5f) {
            return GEARS5_TONE_MAP_TYPE_RENODRT;
          }

          if (value < 2.5f) {
            return GEARS5_TONE_MAP_TYPE_PSYCHOV35;
          }

          if (value < 3.5f) {
            return GEARS5_TONE_MAP_TYPE_PRISM;
          }

          return GEARS5_TONE_MAP_TYPE_VANILLA_PLUS; },

        .is_visible = []() { return true; },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,

        .default_value = 1000.f,
        .can_reset = false,

        .label = "Peak Brightness",
        .section = "Tone Mapping",

        .tooltip = "HDR output peak in nits, independent of the game's HDR calibration sliders.",

        .min = 48.f,
        .max = 4000.f,
        .is_enabled = &IsCustomToneMapper,
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,

        .default_value = 203.f,

        .label = "Game Brightness",
        .section = "Tone Mapping",

        .tooltip = "Scene reference white in nits, independent of the game's HDR brightness slider.",

        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsCustomToneMapper,
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "UI white in nits. UI colors are limited to this value, with a hard maximum of 203 nits.",
        .min = 48.f,
        .max = 203.f,
        .is_enabled = &IsCustomToneMapper,
    },

    // RenoDRT advanced controls

    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Scaling",
        .section = "Tone Mapping",

        .labels = {
            "Luminance",
            "Per Channel",
        },

        .is_enabled = &IsRenoDRT,
        .is_visible = []() {
          return current_settings_mode >= 2.f;
        },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Working Color Space",
        .section = "Tone Mapping",

        .labels = {
            "BT709",
            "BT2020",
            "AP1",
        },

        .is_enabled = []() { return IsRenoDRT(); },

        .is_visible = []() { return current_settings_mode >= 2.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Hue Processor",
        .section = "Tone Mapping",

        .labels = {
            "OKLab",
            "ICtCp",
            "darkTable UCS",
        },

        .is_enabled = []() { return IsRenoDRT(); },

        .is_visible = []() { return current_settings_mode >= 2.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,

        .default_value = 100.f,

        .label = "Hue Correction",
        .section = "Tone Mapping",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsRenoDRT(); },

        .parse = [](float value) { return value * 0.01f; },

        .is_visible = []() { return current_settings_mode >= 2.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,

        .default_value = 0.f,

        .label = "Hue Shift",
        .section = "Tone Mapping",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsRenoDRT(); },

        .parse = [](float value) { return value * 0.01f; },

        .is_visible = []() { return current_settings_mode >= 2.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Clamp Color Space",
        .section = "Tone Mapping",

        .labels = {
            "None",
            "BT709",
            "BT2020",
            "AP1",
        },

        .is_enabled = []() { return IsRenoDRT(); },

        .parse = [](float value) { return value - 1.f; },

        .is_visible = []() { return current_settings_mode >= 2.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Clamp Peak",
        .section = "Tone Mapping",

        .labels = {
            "None",
            "BT709",
            "BT2020",
            "AP1",
        },

        .is_enabled = []() { return IsRenoDRT(); },

        .parse = [](float value) { return value - 1.f; },

        .is_visible = []() { return current_settings_mode >= 2.f; },
    },

    // Shared grading controls

    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,

        .default_value = 1.f,

        .label = "Exposure",
        .section = "Color Grading",

        .min = 0.f,
        .max = 2.f,

        .format = "%.2f",

        .is_enabled = []() { return IsCustomToneMapper(); },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,

        .default_value = 50.f,

        .label = "Highlights",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapper(); },

        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,

        .default_value = 50.f,

        .label = "Shadows",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapper(); },

        .parse = [](float value) { return value * 0.02f; },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,

        .default_value = 50.f,

        .label = "Contrast",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapper(); },

        .parse = [](float value) { return value * 0.02f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,

        .default_value = 50.f,

        .label = "Saturation",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapper(); },

        .parse = [](float value) { return value * 0.02f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,

        .default_value = 50.f,

        .label = "Highlight Saturation",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapper(); },

        .parse = [](float value) { return value * 0.02f; },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,

        .default_value = 0.f,

        .label = "Blowout",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapper(); },

        .parse = [](float value) { return value * 0.01f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,

        .default_value = 0.f,

        .label = "Flare",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapper(); },

        .parse = [](float value) { return value * 0.02f; },
    },

    // PsychoV35

    new renodx::utils::settings::Setting{
        .key = "PsychoV35Purity",
        .binding = &shader_injection.psychov35_purity_scale,

        .default_value = 100.f,

        .label = "Purity",
        .section = "PsychoV35",

        .tooltip = "Feeds the selected Psycho mapper's purity_scale parameter.",

        .min = 0.f,
        .max = 200.f,

        .format = "%.0f%%",

        .is_enabled = []() { return IsPsycho(); },

        .parse = [](float value) { return value * 0.01f; },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV35ConeResponse",
        .binding = &shader_injection.psychov35_cone_response_exponent,

        .default_value = 50.f,

        .label = "Cone Response",
        .section = "PsychoV35",

        .tooltip = "Feeds the selected Psycho mapper's cone_response_exponent parameter.",

        .min = 0.0f,
        .max = 100.f,

        .format = "%.2f",
        .is_enabled = []() { return IsPsycho(); },

        .parse = [](float value) { return value * 0.02f; },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV35GamutCompression",
        .binding = &shader_injection.psychov35_gamut_compression,

        .default_value = 100.f,

        .label = "Gamut Compression",
        .section = "PsychoV35",

        .tooltip = "Feeds the selected Psycho mapper's gamut_compression parameter.",

        .min = 0.f,
        .max = 100.f,

        .format = "%.0f%%",

        .is_enabled = []() { return IsPsycho(); },

        .parse = [](float value) { return value * 0.01f; },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV35GamutTarget",
        .binding = &shader_injection.psychov35_gamut_target,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        // PsychoV35 target zero is BT.709.
        .default_value = 0.f,

        .label = "Gamut Target",
        .section = "PsychoV35",

        .tooltip = "Selects the Psycho mapper target gamut. "
                   "Uses the shared PsychoV35 implementation.",

        .labels = {
            "BT.709",
            "BT.2020",
        },

        .is_enabled = []() { return IsPsycho(); },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV35Compression",
        .binding = &shader_injection.psychov35_compression,

        .default_value = 1.f,

        .label = "Compression",
        .section = "PsychoV35",

        .tooltip = "Feeds the selected Psycho mapper's compression parameter. "
                   "0 selects automatic compression.",

        .min = 0.f,
        .max = 4.f,

        .format = "%.2f",

        .is_enabled = []() { return IsPsycho(); },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting(
      "ToneMapType",
      0.f);
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME =
    "RenoDX - Gears 5";

extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "Gears 5 HDR tone mapping with PsychoV35, PrismTM, RenoDRT and Vanilla+";

BOOL APIENTRY DllMain(
    HMODULE h_module,
    DWORD fdw_reason,
    LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:

      if (!reshade::register_addon(h_module)) {
        return FALSE;
      }

      if (!initialized) {
        // Match the generic scaffold's shared.h injection binding.
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::allow_multiple_push_constants = true;

        initialized = true;
      }

      break;

    case DLL_PROCESS_DETACH:

      reshade::unregister_addon(h_module);

      break;
  }

  renodx::utils::settings::Use(
      fdw_reason,
      &settings,
      &OnPresetOff);

  renodx::mods::shader::Use(
      fdw_reason,
      custom_shaders,
      &shader_injection);

  return TRUE;
}
