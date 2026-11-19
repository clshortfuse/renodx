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

// ============================================================================
// Tone mapper helpers
// ============================================================================

bool IsRenoDRT() {
  return shader_injection.tone_map_type
         == GEARSRELOADED_TONE_MAP_TYPE_RENODRT;
}

bool IsPsychoV30() {
  return shader_injection.tone_map_type
         == GEARSRELOADED_TONE_MAP_TYPE_PSYCHOV30;
}

bool IsCustomToneMapper() {
  return shader_injection.tone_map_type
         != GEARSRELOADED_TONE_MAP_TYPE_VANILLA;
}

// Vanilla keeps the original game bytecode and its HDR sliders.
bool OnReplaceShader(reshade::api::command_list*) {
  return IsCustomToneMapper();
}

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntryCallback(0x53E6E14A, &OnReplaceShader),
    CustomShaderEntryCallback(0x2E1C1BBE, &OnReplaceShader),
    CustomShaderEntryCallback(0x13AE6CC9, &OnReplaceShader),
    CustomShaderEntryCallback(0xD3EA3D95, &OnReplaceShader),
    CustomShaderEntryCallback(0xCCF1C731, &OnReplaceShader),
    CustomShaderEntryCallback(0x42F14792, &OnReplaceShader),
};

// ============================================================================
// Settings
// ============================================================================

renodx::utils::settings::Settings settings = {

    // ------------------------------------------------------------------------
    // General
    // ------------------------------------------------------------------------

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

    // ------------------------------------------------------------------------
    // Tone Mapper
    // ------------------------------------------------------------------------

    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        // UI index 1 = RenoDRT.
        .default_value = 1.f,

        .can_reset = true,

        .label = "Tone Mapper",
        .section = "Tone Mapping",

        .tooltip = "Vanilla uses the in-game HDR sliders. RenoDRT, PsychoV30 and PrismTM use the RenoDX brightness controls.",

        .labels = {
            "Vanilla",
            "RenoDRT",
            "PsychoV30",
            "PrismTM",
        },

        // Convert UI index -> actual internal tone mapper ID.
        .parse = [](float value) {
          if (value < 0.5f) {
            return GEARSRELOADED_TONE_MAP_TYPE_VANILLA;
          }

          if (value < 1.5f) {
            return GEARSRELOADED_TONE_MAP_TYPE_RENODRT;
          }

          if (value < 2.5f) {
            return GEARSRELOADED_TONE_MAP_TYPE_PSYCHOV30;
          }

          return GEARSRELOADED_TONE_MAP_TYPE_PRISM; },

        .is_visible = []() { return true; },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,

        .default_value = 2700.f,
        .can_reset = false,

        .label = "Peak Brightness",
        .section = "Tone Mapping",

        .tooltip = "Sets the RenoDX output peak in nits, overriding the in-game HDR peak slider.",

        .min = 48.f,
        .max = 4000.f,
        .is_enabled = &IsCustomToneMapper,
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,

        .default_value = 140.f,

        .label = "Game Brightness",
        .section = "Tone Mapping",

        .tooltip = "Sets scene paper white in nits, overriding the in-game HDR brightness control.",

        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsCustomToneMapper,
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,

        .default_value = 300.f,

        .label = "UI Brightness",
        .section = "Tone Mapping",

        .min = 48.f,
        .max = 500.f,

        .is_enabled = &IsCustomToneMapper,

        .is_visible = []() { return true; },

    },

    // ------------------------------------------------------------------------
    // RenoDRT advanced controls
    // ------------------------------------------------------------------------

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

    // ------------------------------------------------------------------------
    // Shared grading controls
    // ------------------------------------------------------------------------

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

    // ========================================================================
    // PsychoV30
    // ========================================================================

    new renodx::utils::settings::Setting{
        .key = "PsychoV30Purity",
        .binding = &shader_injection.psychov30_purity_scale,

        .default_value = 100.f,

        .label = "Purity",
        .section = "PsychoV30",

        .tooltip = "Feeds PsychoV30's original purity_scale parameter.",

        .min = 0.f,
        .max = 200.f,

        .format = "%.0f%%",

        .is_enabled = []() { return IsPsychoV30(); },

        .parse = [](float value) { return value * 0.01f; },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV30ConeResponse",
        .binding = &shader_injection.psychov30_cone_response_exponent,

        .default_value = 50.f,

        .label = "Cone Response",
        .section = "PsychoV30",

        .tooltip = "Feeds PsychoV30's original cone_response_exponent parameter.",

        .min = 0.0f,
        .max = 100.f,

        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV30(); },

        .parse = [](float value) { return value * 0.02f; },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV30GamutCompression",
        .binding = &shader_injection.psychov30_gamut_compression,

        .default_value = 100.f,

        .label = "Gamut Compression",
        .section = "PsychoV30",

        .tooltip = "Feeds PsychoV30's original gamut_compression parameter.",

        .min = 0.f,
        .max = 100.f,

        .format = "%.0f%%",

        .is_enabled = []() { return IsPsychoV30(); },

        .parse = [](float value) { return value * 0.01f; },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV30GamutTarget",
        .binding = &shader_injection.psychov30_gamut_target,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        // Preserve PsychoV30's supplied default: nonzero = BT.2020.
        .default_value = 1.f,

        .label = "Gamut Target",
        .section = "PsychoV30",

        .tooltip = "Selects PsychoV30's existing gamut_compression_mode argument. "
                   "The PsychoV30 shader itself is not modified.",

        .labels = {
            "BT.709",
            "BT.2020",
        },

        .is_enabled = []() { return IsPsychoV30(); },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV30Compression",
        .binding = &shader_injection.psychov30_compression,

        .default_value = 1.f,

        .label = "Compression",
        .section = "PsychoV30",

        .tooltip = "Feeds PsychoV30's original compression parameter. "
                   "0 selects PsychoV30's automatic mode.",

        .min = 0.f,
        .max = 4.f,

        .format = "%.2f",

        .is_enabled = []() { return IsPsychoV30(); },

        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    // ------------------------------------------------------------------------
    // Scene grading
    // ------------------------------------------------------------------------

    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,

        .default_value = 100.f,

        .label = "Scene Grading",
        .section = "Color Grading",

        .tooltip = "Preserves the artist LUT without the native Hable or HDR shoulder.",

        .min = 0.f,
        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapper(); },

        .parse = [](float value) { return value * 0.01f; },
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
    "RenoDX - Gears Reloaded";

extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "RenoDX for Gears Reloaded";

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
