/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

renodx::utils::settings::Setting* CreateDefault0PercentSetting(const renodx::utils::settings::Setting& setting) {
  auto* new_setting = new renodx::utils::settings::Setting(setting);
  new_setting->default_value = 0.f;
  new_setting->parse = [](float value) { return value * 0.01f; };
  return new_setting;
}

renodx::utils::settings::Setting* CreateDefault50PercentSetting(const renodx::utils::settings::Setting& setting) {
  auto* new_setting = new renodx::utils::settings::Setting(setting);
  new_setting->default_value = 50.f;
  new_setting->parse = [](float value) { return value * 0.02f; };
  return new_setting;
}

renodx::utils::settings::Setting* CreateDefault100PercentSetting(const renodx::utils::settings::Setting& setting) {
  auto* new_setting = new renodx::utils::settings::Setting(setting);
  new_setting->default_value = 100.f;
  new_setting->parse = [](float value) { return value * 0.01f; };
  return new_setting;
}

renodx::utils::settings::Setting* CreateMultiLabelSetting(const renodx::utils::settings::Setting& setting) {
  auto* new_setting = new renodx::utils::settings::Setting(setting);
  new_setting->value_type = renodx::utils::settings::SettingValueType::INTEGER;
  return new_setting;
}

ShaderInjectData shader_injection;

float current_settings_mode = 0;

renodx::utils::settings::Settings settings = {
    CreateMultiLabelSetting({
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    }),
    CreateMultiLabelSetting({
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .default_value = 2.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "SDR"},
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    },
    CreateDefault0PercentSetting({
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .is_enabled = []() { return shader_injection.tone_map_type > 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    }),
    CreateMultiLabelSetting({
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .default_value = 2.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2 (Per Channel)", "2.2 (Per Channel, Hue Preserving)"},
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance & Channel Blend", "Per Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type == 2; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUnderUI",
        .binding = &shader_injection.tone_map_under_ui,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Tone Map Under UI",
        .section = "Tone Mapping",
        .tooltip = "Tone map the scene under the UI elements",
        .labels = {"Off", "On"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 3; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    CreateDefault50PercentSetting({
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .label = "Highlights",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 3; },
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    CreateDefault50PercentSetting({
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .label = "Shadows",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 3; },
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    CreateDefault50PercentSetting({
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .label = "Contrast",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 3; },
    }),
    CreateDefault50PercentSetting({
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .label = "Saturation",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 3; },
    }),
    CreateDefault50PercentSetting({
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 3; },
    }),
    CreateDefault0PercentSetting({
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
    }),
    CreateDefault0PercentSetting({
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
    }),
    CreateDefault100PercentSetting({
        .key = "FxBloom",
        .binding = &shader_injection.custom_bloom,
        .label = "Bloom",
        .section = "Effects",
    }),
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
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
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/musaqh"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"GammaCorrection", 0.f},
      {"ToneMapHueCorrection", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"FxBloom", 100.f},
  });
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
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Dead Island 2";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_index = 13;

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // auto detect peak and paper white

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // auto detect peak and paper white
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
