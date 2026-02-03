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
float output_mode = 1.f;

// These pointers are key for our ability to update values based on output mode
renodx::utils::settings::Setting* output_mode_setting = nullptr;
renodx::utils::settings::Setting* force_display_hdr_setting = nullptr;
renodx::utils::settings::Setting* tone_map_type_setting = nullptr;
renodx::utils::settings::Setting* tone_map_peak_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_game_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_ui_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_gamma_correction_setting = nullptr;

reshade::api::swapchain* tracked_swapchain = nullptr;
std::optional<reshade::api::color_space> next_color_space = std::nullopt;

void HandleOutputModeChange() {
  float output_mode = output_mode_setting->GetValue();
  bool is_10bit = renodx::mods::swapchain::target_format == reshade::api::format::r10g10b10a2_unorm;
  if (output_mode == 0.f) {
    if (is_10bit) {
      next_color_space = reshade::api::color_space::srgb_nonlinear;
      shader_injection.swap_chain_output_preset = 0.f;
      shader_injection.peak_white_nits = 1.f;
      shader_injection.diffuse_white_nits = 1.f;
      shader_injection.graphics_white_nits = 1.f;
      shader_injection.gamma_correction = 0.f;
    } else {
      shader_injection.swap_chain_output_preset = 2.f;
      shader_injection.peak_white_nits = 80.f;
      shader_injection.diffuse_white_nits = 80.f;
      shader_injection.graphics_white_nits = 80.f;
      shader_injection.gamma_correction = 0;
    }
  } else {
    if (is_10bit) {
      next_color_space = reshade::api::color_space::hdr10_st2084;
    }
    shader_injection.swap_chain_output_preset = 1.f;
    shader_injection.peak_white_nits = tone_map_peak_nits_setting->GetValue();
    shader_injection.diffuse_white_nits = tone_map_game_nits_setting->GetValue();
    shader_injection.graphics_white_nits = tone_map_ui_nits_setting->GetValue();
    shader_injection.gamma_correction = tone_map_gamma_correction_setting->GetValue();
  }
}

bool IsHDREnabled() { return shader_injection.swap_chain_output_preset == 1.f; }

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
    output_mode_setting = new renodx::utils::settings::Setting{
        .key = "OutputMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Output Mode",
        .labels = {"SDR", "HDR"},
        .on_change_value = [](float previous, float current) { HandleOutputModeChange(); },
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
        .labels = {"Vanilla", "Neutwo"},
        .parse = [](float value) { return value; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    tone_map_peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = &IsHDREnabled,
        .parse = [](float value) {
          return (output_mode_setting->GetValue() == 0.f)
                     ? 203.f
                     : value;
        },
    },
    tone_map_game_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDREnabled,
        .parse = [](float value) {
          return (output_mode_setting->GetValue() == 0.f)
                     ? 203.f
                     : value;
        },
    },
    tone_map_ui_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDREnabled,
    },
    tone_map_gamma_correction_setting = new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Tone Mapping",
        .tooltip = "Emulates output decoding used on SDR displays.",
        .labels = {"None", "2.2", "BT.1886"},
        .is_enabled = &IsHDREnabled,
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
        new renodx::utils::settings::Setting{
        .key = "ToneMapHDRBoost",
        .binding = &shader_injection.custom_hdr_boost,
        .default_value = 25.f,
        .label = "HDR Boost",
        .section = "Tone Mapping",
        .max = 50.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return &IsHDREnabled; },
    },
            new renodx::utils::settings::Setting{
        .key = "SceneGradePerChannelBlowout",
        .binding = &shader_injection.scene_grade_per_channel_blowout,
        .default_value = 0.f,
        .label = "Per Channel Blowout",
        .section = "Scene Grading",
        .tooltip = "Simulates the highlight desaturation of per-channel tonemapping.",
        .max = 90.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return (0.01f * pow(100.f - value, 2.f)); },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "SceneGradeHueShift",
        .binding = &shader_injection.scene_grade_per_channel_hue_shift,
        .default_value = 0.f,
        .label = "Per Channel Hue Shift",
        .section = "Scene Grading",
        .tooltip = "Simulates the hue shifting of per-channel tonemapping. Effect is tied to Per Channel Blowout.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0 && shader_injection.scene_grade_per_channel_blowout > 0.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
            new renodx::utils::settings::Setting{
        .key = "SceneGradeHueClip",
        .binding = &shader_injection.scene_grade_hue_clip,
        .default_value = 0.f,
        .label = "Hue Clip",
        .section = "Scene Grading",
        .tooltip = "Simulates the color of highlight clipping in SDR games with no tonemapper.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0 && shader_injection.scene_grade_per_channel_blowout > 0.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
      new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Color Grading",
        .section = "Scene Grading",
        .tooltip = "Color grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .is_visible = []() { return current_settings_mode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 10.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
        .parse = [](float value) { return value * 0.001f; },
        .is_visible = []() { return current_settings_mode == 1; },
    },
    //     new renodx::utils::settings::Setting{
    //     .key = "ColorGradeSaturationClip",
    //     .binding = &shader_injection.saturation_clip,
    //     .default_value = 0.f,
    //     .label = "Saturation Clip",
    //     .section = "Color Grading",
    //     .max = 100.f,
    //     //.is_enabled = []() { return shader_injection.tone_map_type >= 1.f; },
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
        .label = "Reset All",
        .section = "Presets",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
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

void OnPresetChange() {
  HandleOutputModeChange();
}

void OnPresetOff() {
   renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
   //renodx::utils::settings::UpdateSetting("ToneMapTypeSDR", 0.f);
        renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
        renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
        renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
        renodx::utils::settings::UpdateSetting("GammaCorrection", 1.f);
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

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
              //reshade::log::message(reshade::log::level::info, "OnPreset Event Triggered");
  auto* device = queue->get_device();
  auto* data = renodx::utils::data::Get<renodx::mods::swapchain::DeviceData>(device);
  if (data == nullptr) return;
  //reshade::log::message(reshade::log::level::info, "OnPreset Event - data not null");
  //if (!data->upgraded_swapchains.contains(swapchain)) return;
  if (tracked_swapchain != swapchain) {
    //reshade::log::message(reshade::log::level::info, "OnPreset Event tracked_swapchain != swapchain");
    tracked_swapchain = swapchain;
    HandleOutputModeChange();
  } else if (next_color_space.has_value()) {
    //reshade::log::message(reshade::log::level::info, "OnPreset Event - Color Space Change?");
    renodx::utils::swapchain::ChangeColorSpace(tracked_swapchain, next_color_space.value());
    next_color_space = std::nullopt;
  }
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
      renodx::mods::swapchain::set_color_space = true;
      renodx::mods::swapchain::use_device_proxy = true;
      renodx::utils::random::binds.push_back(&shader_injection.custom_random);
      renodx::mods::swapchain::ignored_window_class_names = {
            "SplashScreenClass",
        };
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader_dx11;
      renodx::mods::swapchain::SetUseHDR10();
      renodx::utils::settings::on_preset_changed_callbacks.emplace_back(&HandleOutputModeChange); // SDR presets

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
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      break;
  }
  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
