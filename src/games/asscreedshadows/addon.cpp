/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
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
#include "shared.h"

namespace {

ShaderInjectData shader_injection;

int tone_map_lut_invalidated = 0;
int ui_lut_invalidated = 0;

bool OnToneMapLutBuilderReplace(reshade::api::command_list* cmd_list) {
  tone_map_lut_invalidated = 0;
  return true;
}

bool OnUILutBuilderReplace(reshade::api::command_list* cmd_list) {
  ui_lut_invalidated = 0;
  return true;
}

void OnOptimizableToneMapSettingChange() {
  tone_map_lut_invalidated = 1;
};

void OnOptimizableUISettingChange() {
  ui_lut_invalidated = 1;
};

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xAE262C33),  // Local ToneMap

    CustomShaderEntry(0xAF2BDFB5),                                       // Sample LUT + Bloom
    CustomShaderEntry(0xF65A634F),                                       // Color Grade + ToneMap LutBuilder
    CustomShaderEntryCallback(0x551A03A4, &OnToneMapLutBuilderReplace),  // ToneMap LutBuilder

    CustomShaderEntryCallback(0x2339C673, &OnUILutBuilderReplace),  // UI - sRGB to HDR
    CustomShaderEntry(0xBD751592),                                  // UI - Video sRGB to HDR
};

const std::unordered_map<std::string, float> HDR_LOOK_VALUES = {
    {"ToneMapType", 1.f},
    {"LocalToneMapType", 1.f},
    {"ColorGradeFlare", 36.f},
    {"FxBloom", 50.f},
    {"FxBloomScaling", 100.f},
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type. Toggle in-game HDR setting or restart game to take effect.",
        .labels = {"Vanilla", "Vanilla+", "ACES"},
        .on_change = &OnOptimizableToneMapSettingChange,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Toggle in-game HDR setting or restart game to apply changes to Tone Mapper.",
        .section = "Tone Mapping",
        .tint = 0xFF0000,
        .is_visible = []() { return tone_map_lut_invalidated != 0.f; },
        .is_sticky = true,
    },
    new renodx::utils::settings::Setting{
        .key = "LocalToneMapType",
        .binding = &shader_injection.custom_local_tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Local Tone Map Type",
        .section = "Local Tone Mapping",
        .tooltip = "Sets the local tone mapper type. Enhanced preserves hues and prevents shadows smearing.",
        .labels = {"Vanilla", "Enhanced"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapLocalToneMapShoulder",
        .binding = &shader_injection.custom_local_tonemap_shoulder,
        .default_value = 100.f,
        .label = "Local Tonemap Shoulder",
        .section = "Local Tone Mapping",
        .tooltip = "Adjust the strength of local tonemapping shoulder",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapLocalToneMapToe",
        .binding = &shader_injection.custom_local_tonemap_toe,
        .default_value = 100.f,
        .label = "Local Tonemap Toe",
        .section = "Local Tone Mapping",
        .tooltip = "Adjust the strength of local tonemapping toe",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "Exposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
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
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorFilterStrength",
        .binding = &shader_injection.custom_color_filter_strength,
        .default_value = 100.f,
        .label = "Color Filter Strength",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloomScaling",
        .binding = &shader_injection.custom_bloom_scaling,
        .default_value = 100.f,
        .label = "Bloom Scaling",
        .section = "Effects",
        .tooltip = "Scales the black floor of the bloom effect.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Miscellaneous",
        .tooltip = "Sets the brightness of UI and HUD elements in nits. Requires a game restart to take effect.",
        .min = 48.f,
        .max = 500.f,
        .on_change = &OnOptimizableUISettingChange,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Restart game to apply changes to UI Brightness.",
        .section = "Miscellaneous",
        .tint = 0xFF0000,
        .is_visible = []() { return ui_lut_invalidated != 0.f; },
        .is_sticky = true,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->key == "ToneMapUINits") {
              if (setting->value != setting->default_value) OnOptimizableUISettingChange();
            } else if (setting->key == "ToneMapType") {
              if (setting->value != setting->default_value) OnOptimizableToneMapSettingChange();
            }
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Recommended Settings",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (HDR_LOOK_VALUES.contains(setting->key)) {
              if (setting->key == "ToneMapUINits") {
                if (setting->value != setting->default_value) OnOptimizableUISettingChange();
              } else if (setting->key == "ToneMapType") {
                if (setting->value != setting->default_value) OnOptimizableToneMapSettingChange();
              }

              renodx::utils::settings::UpdateSetting(setting->key, HDR_LOOK_VALUES.at(setting->key));
            } else {
              renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
            }
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
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
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Requires HDR on in game"),
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Adjust paper white using the in-game exposure setting\n"
                             "- Adjust peak brightness using the in-game peak setting"),
        .section = "About",
    },
};

void OnPresetOff() {
  auto* tone_map_setting = renodx::utils::settings::FindSetting("ToneMapType");
  if (tone_map_setting != nullptr && tone_map_setting->value != 0.f) {
    OnOptimizableToneMapSettingChange();
  }
  auto* ui_nits_setting = renodx::utils::settings::FindSetting("ToneMapUINits");
  if (ui_nits_setting != nullptr && ui_nits_setting->value != 203.f) {
    OnOptimizableUISettingChange();
  }

  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"LocalToneMapType", 0.f},
      {"ToneMapLocalToneMapToe", 100.f},
      {"ToneMapLocalToneMapShoulder", 100.f},
      {"Exposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorFilterStrength", 100.f},
      {"FxBloom", 100.f},
      {"FxBloomScaling", 0.f},
      {"ToneMapUINits", 203.f},
  });
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Assassin's Creed: Shadows";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::force_pipeline_cloning = true;
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}