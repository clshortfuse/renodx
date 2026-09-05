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
#include "../../utils/settings.hpp"
#include "./shared.h"


namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xCB76A9C1),
    CustomShaderEntry(0xA93248D1),
};


ShaderInjectData shader_injection;
float current_settings_mode = 0.f;


// ============================================================================
// Tone mapper helpers
// ============================================================================

bool IsVanilla() {
  return shader_injection.tone_map_type
      == COLDWAR_TONE_MAP_TYPE_VANILLA;
}


bool IsRenoDRT() {
  return shader_injection.tone_map_type
      == COLDWAR_TONE_MAP_TYPE_RENODRT;
}


bool IsPsychoV30() {
  return shader_injection.tone_map_type
      == COLDWAR_TONE_MAP_TYPE_PSYCHOV30;
}


bool IsPragmap() {
  return shader_injection.tone_map_type
      == COLDWAR_TONE_MAP_TYPE_PRAGMAP;
}


bool IsCustomToneMapper() {
  return !IsVanilla();
}


bool IsRenoDRTOrPsycho() {
  return IsRenoDRT() || IsPsychoV30();
}


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

        .value_type =
            renodx::utils::settings::SettingValueType::INTEGER,

        // UI index 1 = RenoDRT.
        .default_value = 1.f,

        .can_reset = true,

        .label = "Tone Mapper",
        .section = "Tone Mapping",

        .tooltip =
            "Selects the HDR display mapper.",

        .labels = {
            "Vanilla",
            "RenoDRT",
            "PsychoV30",
            "Pragmap",
        },

        // Convert UI index -> actual internal tone mapper ID.
        .parse = [](float value) {
          if (value < 0.5f) {
            return COLDWAR_TONE_MAP_TYPE_VANILLA;
          }

          if (value < 1.5f) {
            return COLDWAR_TONE_MAP_TYPE_RENODRT;
          }

          if (value < 2.5f) {
            return COLDWAR_TONE_MAP_TYPE_PSYCHOV30;
          }

          return COLDWAR_TONE_MAP_TYPE_PRAGMAP;
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,

        .default_value = 1000.f,
        .can_reset = false,

        .label = "Peak Brightness",
        .section = "Tone Mapping",

        .tooltip =
            "Sets the HDR display peak in nits.",

        .min = 48.f,
        .max = 4000.f,
    },


    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,

        .default_value = 203.f,

        .label = "Game Brightness",
        .section = "Tone Mapping",

        .tooltip =
            "Sets reference/diffuse white in nits.",

        .min = 48.f,
        .max = 500.f,
    },


    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,

        .default_value = 203.f,

        .label = "UI Brightness",
        .section = "Tone Mapping",

        .min = 48.f,
        .max = 500.f,

        .is_enabled = []() {
          return true;

        },
        
        .is_visible = []() {
          return false;
        },
       
    },


    // ------------------------------------------------------------------------
    // RenoDRT advanced controls
    // ------------------------------------------------------------------------

    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,

        .value_type =
            renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Scaling",
        .section = "Tone Mapping",

        .labels = {
            "Luminance",
            "Per Channel",
        },

      

        .is_visible = []() {
          return current_settings_mode >= 2.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,

        .value_type =
            renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Working Color Space",
        .section = "Tone Mapping",

        .labels = {
            "BT709",
            "BT2020",
            "AP1",
        },

        .is_enabled = []() {
          return IsRenoDRT();
        },

        .is_visible = []() {
          return false;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,

        .value_type =
            renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Hue Processor",
        .section = "Tone Mapping",

        .labels = {
            "OKLab",
            "ICtCp",
            "darkTable UCS",
        },

        .is_enabled = []() {
          return IsRenoDRT();
        },

        .is_visible = []() {
          return false;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,

        .default_value = 100.f,

        .label = "Hue Correction",
        .section = "Tone Mapping",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.01f;
        },

        .is_enabled = []() {
          return IsRenoDRT();
        },

        .is_visible = []() {
          return false;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,

        .default_value = 50.f,

        .label = "Hue Shift",
        .section = "Tone Mapping",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.01f;
        },

        .is_enabled = []() {
          return IsRenoDRT();
        },

        .is_visible = []() {
          return false;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,

        .value_type =
            renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Clamp Color Space",
        .section = "Tone Mapping",

        .labels = {
            "None",
            "BT709",
            "BT2020",
            "AP1",
        },

        .parse = [](float value) {
          return value - 1.f;
        },

        .is_enabled = []() {
          return IsRenoDRT();
        },

        .is_visible = []() {
          return false;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,

        .value_type =
            renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Clamp Peak",
        .section = "Tone Mapping",

        .labels = {
            "None",
            "BT709",
            "BT2020",
            "AP1",
        },

        .parse = [](float value) {
          return value - 1.f;
        },

        .is_enabled = []() {
          return IsRenoDRT();
        },

        .is_visible = []() {
          return false;
        },
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

        .is_enabled = []() {
          return IsCustomToneMapper();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,

        .default_value = 50.f,

        .label = "Highlights",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.02f;
        },

        .is_enabled = []() {
          return IsCustomToneMapper();
        },
        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,

        .default_value = 50.f,

        .label = "Shadows",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.02f;
        },

         .is_enabled = []() {
          return IsCustomToneMapper();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,

        .default_value = 50.f,

        .label = "Contrast",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.02f;
        },

         .is_enabled = []() {
          return IsCustomToneMapper();
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,

        .default_value = 50.f,

        .label = "Saturation",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.02f;
        },

         .is_enabled = []() {
          return IsCustomToneMapper();
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,

        .default_value = 50.f,

        .label = "Highlight Saturation",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.02f;
        },

        .is_enabled = []() {
          return IsCustomToneMapper();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,

        .default_value = 0.f,

        .label = "Blowout",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.01f;
        },
 .is_enabled = []() {
          return IsCustomToneMapper();
        },
    },


    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,

        .default_value = 0.f,

        .label = "Flare",
        .section = "Color Grading",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.02f;
        },

         .is_enabled = []() {
          return IsCustomToneMapper();
        },
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

        .tooltip =
            "Feeds PsychoV30's original purity_scale parameter.",

        .min = 0.f,
        .max = 200.f,

        .format = "%.0f%%",

        .parse = [](float value) {
          return value * 0.01f;
        },

        .is_enabled = []() {
          return IsPsychoV30();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "PsychoV30ConeResponse",
        .binding = &shader_injection.psychov30_cone_response_exponent,

        .default_value = 50.f,

        .label = "Cone Response",
        .section = "PsychoV30",

        .tooltip =
            "Feeds PsychoV30's original cone_response_exponent parameter.",

        .min = 0.0f,
        .max = 100.f,

        .format = "%.2f",
        .parse = [](float value) { return value * 0.02f; },
        .is_enabled = []() {
          return IsPsychoV30();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "PsychoV30GamutCompression",
        .binding = &shader_injection.psychov30_gamut_compression,

        .default_value = 100.f,

        .label = "Gamut Compression",
        .section = "PsychoV30",

        .tooltip =
            "Feeds PsychoV30's original gamut_compression parameter.",

        .min = 0.f,
        .max = 100.f,

        .format = "%.0f%%",

        .parse = [](float value) {
          return value * 0.01f;
        },

        .is_enabled = []() {
          return IsPsychoV30();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "PsychoV30GamutTarget",
        .binding = &shader_injection.psychov30_gamut_target,

        .value_type =
            renodx::utils::settings::SettingValueType::INTEGER,

        // Preserve PsychoV30's supplied default: nonzero = BT.2020.
        .default_value = 1.f,

        .label = "Gamut Target",
        .section = "PsychoV30",

        .tooltip =
            "Selects PsychoV30's existing gamut_compression_mode argument. "
            "The PsychoV30 shader itself is not modified.",

        .labels = {
            "BT.709",
            "BT.2020",
        },

        .is_enabled = []() {
          return IsPsychoV30();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "PsychoV30Compression",
        .binding = &shader_injection.psychov30_compression,

        .default_value = 1.f,

        .label = "Compression",
        .section = "PsychoV30",

        .tooltip =
            "Feeds PsychoV30's original compression parameter. "
            "0 selects PsychoV30's automatic mode.",

        .min = 0.f,
        .max = 4.f,

        .format = "%.2f",

        .is_enabled = []() {
          return IsPsychoV30();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    // ========================================================================
    // Pragmap
    // ========================================================================
    //
    // IMPORTANT:
    //
    // The original supplied pragmap() function exposes ONLY:
    //
    //   hueStrength
    //   blowoutStrength
    //
    // Therefore these are the only Pragmap-specific parameters exposed here.
    // pragmap.hlsl itself remains untouched.
    //

    new renodx::utils::settings::Setting{
        .key = "PragmapHueStrength",
        .binding = &shader_injection.pragmap_hue_strength,

        .default_value = 75.f,

        .label = "Hue Strength",
        .section = "Pragmap",

        .tooltip =
            "Feeds Pragmap's original hueStrength parameter.",

        .min = 0.f,
        .max = 100.f,

        .format = "%.0f%%",

        .parse = [](float value) {
          return value * 0.01f;
        },

        .is_enabled = []() {
          return IsPragmap();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    new renodx::utils::settings::Setting{
        .key = "PragmapBlowoutStrength",
        .binding = &shader_injection.pragmap_blowout_strength,

        .default_value = 75.f,

        .label = "Blowout",
        .section = "Pragmap",

        .tooltip =
            "Feeds Pragmap's original blowoutStrength parameter.",

        .min = 0.f,
        .max = 100.f,

        .format = "%.0f%%",

        .parse = [](float value) {
          return value * 0.01f;
        },

        .is_enabled = []() {
          return IsPragmap();
        },

        .is_visible = []() {
          return current_settings_mode >= 1.f;
        },
    },


    // ------------------------------------------------------------------------
    // Cold War native scene grade
    // ------------------------------------------------------------------------

    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,

        .default_value = 100.f,

        .label = "Scene Grading",
        .section = "Color Grading",

        .tooltip =
            "Cold War's native HDR scene LUT strength.",

        .min = 0.f,
        .max = 100.f,

        .parse = [](float value) {
          return value * 0.01f;
        },

        .is_enabled = []() {
          return IsCustomToneMapper();
        },
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
    "RenoDX";

extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "RenoDX - Call of Duty Black Ops Cold War native HDR";


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

        // Known-working Cold War injection configuration.
        //
        // Do NOT enable allow_multiple_push_constants for this game.
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::force_pipeline_cloning = true;

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