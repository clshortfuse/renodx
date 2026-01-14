/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "../../utils/random.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

#define RareExposureShaderEntry(value)                            \
  {                                                               \
    value,                                                        \
        {                                                         \
            .crc32 = value,                                       \
            .code = __##value,                                    \
            .on_draw = [](auto cmd_list) {                        \
              shader_injection.custom_exposure_shader_draw = 1.f; \
              return true;                                        \
            },                                                    \
        },                                                        \
  }

#define TypicalExposureShaderEntry(value)                         \
  {                                                               \
    value,                                                        \
        {                                                         \
            .crc32 = value,                                       \
            .code = __##value,                                    \
            .on_drawn = [](auto cmd_list) {                       \
              shader_injection.custom_exposure_shader_draw = 0.f; \
              return true;                                        \
            },                                                    \
        },                                                        \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    // Outputs
    CustomShaderEntry(0xE73DF341),
    CustomShaderEntry(0xBC05143A),
    CustomShaderEntry(0xC584376B),
    CustomShaderEntry(0x8F04163E),

    // lutbuilder
    CustomShaderEntry(0x7B84049A),
    CustomShaderEntry(0xC38C23F4),

    // UI
    CustomShaderEntry(0x8286B55C),
    CustomShaderEntry(0x04039750),

    // Post Process
    TypicalExposureShaderEntry(0xEE56E73B),
    TypicalExposureShaderEntry(0xE188DA93),
    TypicalExposureShaderEntry(0x89476799),
    TypicalExposureShaderEntry(0xF06499FE),
    TypicalExposureShaderEntry(0x8CAFE864),
    TypicalExposureShaderEntry(0x441E59B3),
    TypicalExposureShaderEntry(0x61F644A4),
    TypicalExposureShaderEntry(0x2B137341),
    TypicalExposureShaderEntry(0x53166004),

    // Exposure
    RareExposureShaderEntry(0x4905680A),
    RareExposureShaderEntry(0xE40162EC),

    // Sharpness
    CustomShaderEntry(0xC8169712),
    // CustomShaderEntry(0x243CA65C),

    // Sharpening (Bypass)
    {
        0x243CA65C,
        {
            .crc32 = 0x243CA65C,
            .on_draw = [](auto* cmd_list) {
              return false;
            },
        },
    },
    {
        0x87077D36,
        {
            .crc32 = 0x87077D36,
            .on_draw = [](auto* cmd_list) {
              return false;
            },
        },
    },
};

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

float current_settings_mode = 0;
auto last_is_hdr = false;

const std::unordered_map<std::string, float> FILMIC_LOOK_VALUES = {
    {"ToneMapType", 1.f},
    {"ColorGradeExposure", 1.f},
    {"ColorGradeHighlights", 50.f},
    {"ColorGradeShadows", 48.f},
    {"ColorGradeContrast", 59.f},
    {"ColorGradeSaturation", 56.f},
    {"ColorGradeHighlightSaturation", 40.f},
    {"ColorGradeBlowout", 50.f},
    {"ColorGradeFlare", 50.f},
    {"SwapChainCustomColorSpace", 0.f},
    {"ColorGradeSDRTonemapper", 0.f},
    {"ColorGradeLUTColorStrength", 60.f},
    {"FxLUTScaling", 0.f},
    {"FxExposureType", 1.f},
    {"FxExposureStrength", 75.f},
    {"FxLUTExposureReverse", 1.f},
};

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
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .parse = [](float value) { return value * 3.f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 80.f,
        .max = 4000.f,
        .is_enabled = []() { return last_is_hdr; },
        .is_visible = []() { return current_settings_mode >= 1 && last_is_hdr; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .can_reset = true,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 80.f,
        .max = 500.f,
        .is_visible = []() { return last_is_hdr; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 80.f,
        .max = 500.f,
        .is_visible = []() { return last_is_hdr; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1.f; },
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
        .is_visible = []() { return current_settings_mode >= 1.f; },
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
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1 && last_is_hdr; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Adds highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 50.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1 && last_is_hdr; },
    },
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

    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTColorStrength",
        .binding = &shader_injection.custom_lut_color_strength,
        .default_value = 100.f,
        .label = "Color LUT Strength",
        .section = "Color Grading",
        .tooltip = "Strength of Vanilla's Color LUT",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_film_grain,
        .default_value = 50.f,
        .label = "FilmGrain",
        .section = "Effects",
        .tooltip = "Controls new perceptual film grain.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxVignette",
        .binding = &shader_injection.custom_vignette,
        .default_value = 50.f,
        .label = "Vignette",
        .section = "Effects",
        .tooltip = "Controls Vignette",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxSharpness",
        .binding = &shader_injection.custom_sharpness,
        .default_value = 0.f,
        .label = "RCAS Sharpness",
        .section = "Effects",
        .tooltip = "Controls Lilium's RCAS Sharpness",
        .max = 100.f,
        .parse = [](float value) { return value == 0 ? 0.f : exp2(-(1.f - (value * 0.01f))); },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxLUTScaling",
        .binding = &shader_injection.custom_lut_scaling,
        .default_value = 50.f,
        .label = "LUT Scaling",
        .section = "Effects",
        .tooltip = "Controls lut scaling",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxExposureType",
        .binding = &shader_injection.custom_exposure_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Exposure Type",
        .section = "Effects",
        .tooltip = "Which color to output",
        .labels = {"Vanilla", "Fixed"},
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxExposureStrength",
        .binding = &shader_injection.custom_exposure_strength,
        .default_value = 50.f,
        .can_reset = true,
        .label = "Exposure Strength",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxLUTExposureReverse",
        .binding = &shader_injection.custom_lut_exposure_reverse,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = true,
        .label = "LUT Exposure Reverse",
        .section = "Effects",
        .tooltip = "Use precolor grade exposure or after",
        .labels = {"Post Grade", "Pre Grade"},
        .is_visible = []() { return current_settings_mode >= 2; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxDebanding",
        .binding = &shader_injection.swap_chain_output_dither_bits,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Debanding",
        .section = "Effects",
        .labels = {"None", "8+2 Dither", "10+2 Dither"},
        .parse = [](float value) {
          if (value == 0.f) return 0.f;
          if (value == 1.f) return 8.f;
          if (value == 2.f) return 10.f;
          return 0.f;
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Vanilla+",
        .section = "Presets",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Filmic",
        .section = "Presets",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            if (FILMIC_LOOK_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, FILMIC_LOOK_VALUES.at(setting->key));
            } else {
              renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
            }
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = " - In-Game HDR must be turned ON!\n"
                 " - Game's options are overridden.",
        .section = "Instructions",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL(("https://discord.gg/XUhv") + std::string("tR54yc"));
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Ritsu's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/ritsucecil");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/hdrden");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Game mod by Ritsu, RenoDX Framework by ShortFuse.",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Special thanks to Jon for tuning presets, and to ShortFuse & Lilium for the support!",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Credits to Lilium (& Musa) for RCAS!",
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
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 1000.f);
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
  renodx::utils::settings::UpdateSetting("SwapChainCustomColorSpace", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTColorStrength", 100.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTOutputStrength", 100.f);
  renodx::utils::settings::UpdateSetting("FxFilmGrain", 0.f);
  renodx::utils::settings::UpdateSetting("FxExposureType", 0.f);
  renodx::utils::settings::UpdateSetting("FxExposureStrength", 50.f);
  renodx::utils::settings::UpdateSetting("FxLUTExposureReverse", 0.f);
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  last_is_hdr = renodx::utils::swapchain::IsHDRColorSpace(swapchain);

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = roundf(peak.value());
  } else {
    settings[2]->default_value = 1000.f;
  }

  settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX MH Wilds";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for MH Wilds";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      // while (IsDebuggerPresent() == 0) Sleep(100);

      if (!initialized) {
        renodx::mods::swapchain::SetUseHDR10(true);
        renodx::utils::random::binds.push_back(&shader_injection.custom_random);
        renodx::utils::random::binds.push_back(&shader_injection.swap_chain_output_dither_seed);
      
        initialized = true;
      }
      renodx::mods::shader::on_create_pipeline_layout = [](reshade::api::device* device, auto params) {
        int vendor_id;
        auto retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
        bool is_not_nvidia = !retrieved || vendor_id != 0x10de;

        auto param_count = params.size();

        if (is_not_nvidia) {
          // Give up for now
          if (param_count <= 20) {
            return true;
          }

          /* // AMD water bug
          // outputs & post process
          if (param_count == 15) {
            return true;
          }

          // UI
          if (param_count == 10 && params[1].descriptor_table.count == 1) {
            return true;
          } */
        } else {
          // err on the safe side for Nvidia
          if (param_count <= 20) {
            return true;
          }
        }

        return false;
      };

      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::force_pipeline_cloning = true;

      /* renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
      }); */

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      //reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      //reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason);
  //renodx::utils::swapchain::Use(fdw_reason);
  //renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
