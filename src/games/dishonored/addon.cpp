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
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
__ALL_CUSTOM_SHADERS
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;
float hdr_toggle = 0;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "HDRToggle",
        .binding = &hdr_toggle,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "",
        .section = "Output Mode",
        .labels = {"SDR", "HDR"},
        .on_change = []() { 
            for (auto* setting : settings) {
                if (setting->key.empty()) continue;
                if (!setting->can_reset) continue;
                if (setting->key == "ToneMapPeakNits" || setting->key == "ToneMapGameNits" || setting->key == "ToneMapUINits") {
                    if (hdr_toggle == 0) {
                        renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
                    }
                    else {
                        renodx::utils::settings::UpdateSetting(setting->key, 80.f); 
                    }
                    continue;
                }
                if (setting->key == "GammaCorrection") {
                    if (hdr_toggle == 0) {
                        renodx::utils::settings::UpdateSetting(setting->key, setting->default_value); 
                    }
                    else{
                        renodx::utils::settings::UpdateSetting(setting->key, 0.f); 
                    }
                    continue;
                }
                if (setting->key == "ToneMapType") {
                    if (hdr_toggle == 0) {
                        renodx::utils::settings::UpdateSetting(setting->key, setting->default_value); 
                    }
                    else{
                        renodx::utils::settings::UpdateSetting(setting->key, 1.f); 
                    }
                    continue;
                }
                // if (setting->key == "ToneMapTypeSDR") {
                //     if (hdr_toggle == 0) {
                //         //renodx::utils::settings::UpdateSetting(setting->key, setting->default_value); 
                //     }
                //     else{
                //         renodx::utils::settings::UpdateSetting(setting->key, setting->default_value); 
                //     }
                //     continue;
                // }
            }
        },
        //.is_global = true,
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
        .labels = {"Vanilla", "SDR Tonemapped", "Reinhard Piecewise", "Hermite Spline Per Channel", "Hermite Spline By Luminance"},
        .is_visible = []() { return current_settings_mode == 1.f && hdr_toggle == 1; },
    },
    //     new renodx::utils::settings::Setting{
    //     .key = "ToneMapTypeSDR",
    //     .binding = &shader_injection.tone_map_type_sdr,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 1.f,
    //     .can_reset = true,
    //     .label = "Tone Mapper",
    //     .section = "Tone Mapping",
    //     .tooltip = "Sets the tone mapper type",
    //     .labels = {"Vanilla", "Tonemapped"},
    //     .is_visible = []() { return hdr_toggle == 0.f; },
    // },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        //.is_global = true,
        .is_visible = []() { return hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        //.is_global = true,
        .is_visible = []() { return hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Changing the UI brightness slightly affects the gamma",
        .min = 48.f,
        .max = 500.f,
        //.is_global = true,
        .is_visible = []() { return hdr_toggle == 1; },
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
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
        new renodx::utils::settings::Setting{
        .key = "ToneMapHDRBoost",
        .binding = &shader_injection.custom_hdr_boost,
        .default_value = 10.f,
        .label = "HDR Boost",
        .section = "Tone Mapping",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
        .parse = [](float value) { return value * 0.001f; },
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode == 1 && hdr_toggle == 1; },
    },
    //     new renodx::utils::settings::Setting{
    //     .key = "ColorGradeSaturationClip",
    //     .binding = &shader_injection.saturation_clip,
    //     .default_value = 0.f,
    //     .label = "Saturation Clip",
    //     .section = "Color Grading",
    //     .max = 100.f,
    //     //.is_enabled = []() { return shader_injection.tone_map_type >= 2.f; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode == 1; },
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
        .is_visible = []() { return settings[0]->GetValue() == 1; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxFilmGrainToggle",
        .binding = &shader_injection.custom_film_grain_toggle,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Film Grain Type",
        .section = "Effects",
        .tooltip = "Sets the film grain type.",
        .labels = {"Vanilla", "Perceptual Film Grain"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_film_grain,
        .default_value = 0.f,
        .label = "Film Grain",
        .section = "Effects",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.custom_film_grain_toggle == 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset",
        .section = "About",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (hdr_toggle == 0 && setting->key == "ToneMapPeakNits") {
                //renodx::utils::settings::UpdateSetting(setting->key, 80.f); 
                continue;
            }
            if (hdr_toggle == 0 && setting->key == "ToneMapGameNits") {
                //renodx::utils::settings::UpdateSetting(setting->key, 80.f); 
                continue;
            } 
            if (hdr_toggle == 0 && setting->key == "ToneMapUINits") {
                //renodx::utils::settings::UpdateSetting(setting->key, 80.f); 
                continue;
            }
            if (hdr_toggle == 0 && setting->key == "GammaCorrection") {
                //renodx::utils::settings::UpdateSetting(setting->key, 0.f); 
                continue;
            }
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
          //OnHDRToggle(hdr_toggle, true);
        },
        .is_visible = []() { return hdr_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "F6AUTeWJHM");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "About",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
};

void OnPresetOff() {
   renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
   //renodx::utils::settings::UpdateSetting("ToneMapTypeSDR", 0.f);
   if (hdr_toggle == 1.f){
        renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
        renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
        renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
        renodx::utils::settings::UpdateSetting("GammaCorrection", 1.f);
   }
   else {
        renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 80.f);
        renodx::utils::settings::UpdateSetting("ToneMapGameNits", 80.f);
        renodx::utils::settings::UpdateSetting("ToneMapUINits", 80.f);  
        renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);  
   }
   renodx::utils::settings::UpdateSetting("ToneMapHDRBoost", 0.f);
   renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
   renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
   renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
   renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
   renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
   renodx::utils::settings::UpdateSetting("SwapChainCustomColorSpace", 0.f);
   renodx::utils::settings::UpdateSetting("FxFilmGrainToggle", 0.f);
   renodx::utils::settings::UpdateSetting("FxFilmGrain", 0.f);
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[3]->default_value = roundf(peak.value());
  } else {
    settings[3]->default_value = 1000.f;
  }

  //settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Dishonored";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::constant_buffer_offset = 50 * 4;

      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::prevent_full_screen = false;
      renodx::mods::swapchain::force_screen_tearing = false;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::set_color_space = false;
      renodx::mods::swapchain::use_device_proxy = true;
      renodx::utils::random::binds.push_back(&shader_injection.custom_random);
      renodx::mods::swapchain::ignored_window_class_names = {
            "SplashScreenClass",
        };
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader_dx11;
      renodx::mods::swapchain::SetUseHDR10();

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
      });
            renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r16g16b16a16_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = true,
          .use_resource_view_cloning = true,
      });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      break;
  }
  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
