/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <atomic>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "shared.h"

namespace {

ShaderInjectData shader_injection;

std::atomic_bool tone_map_lut_invalidated = false;
std::atomic_bool ui_lut_invalidated = false;
float applied_tone_map_type = 1.f;
float applied_ui_nits = 203.f;

void SetToneMapLutInvalidated(bool invalidated) {
  tone_map_lut_invalidated.store(invalidated, std::memory_order_relaxed);
}

void SetUiLutInvalidated(bool invalidated) {
  ui_lut_invalidated.store(invalidated, std::memory_order_relaxed);
}

bool ToneMapLutValuesDirty() {
  return shader_injection.tone_map_type != applied_tone_map_type;
}

bool UiLutValuesDirty() {
  return shader_injection.graphics_white_nits != applied_ui_nits;
}

void RefreshToneMapLutDirtyState() {
  SetToneMapLutInvalidated(ToneMapLutValuesDirty());
}

void RefreshUiLutDirtyState() {
  SetUiLutInvalidated(UiLutValuesDirty());
}

void MarkToneMapLutApplied() {
  applied_tone_map_type = shader_injection.tone_map_type;
  RefreshToneMapLutDirtyState();
}

void MarkUiLutApplied() {
  applied_ui_nits = shader_injection.graphics_white_nits;
  RefreshUiLutDirtyState();
}

void InitializeAppliedValues() {
  applied_tone_map_type = shader_injection.tone_map_type;
  applied_ui_nits = shader_injection.graphics_white_nits;
}

void OnToneMapLutBuilderDrawn(reshade::api::command_list* /*cmd_list*/) {
  MarkToneMapLutApplied();
}

void OnUiLutBuilderDrawn(reshade::api::command_list* /*cmd_list*/) {
  MarkUiLutApplied();
}

void OnToneMapLutControlledSettingChanged(float /*previous*/, float /*current*/) {
  RefreshToneMapLutDirtyState();
}

void OnUiNitsSettingChanged(float /*previous*/, float /*current*/) {
  RefreshUiLutDirtyState();
}

void OnPresetChangedInvalidateIfChanged() {
  RefreshToneMapLutDirtyState();
  RefreshUiLutDirtyState();
}

renodx::mods::shader::CustomShaders custom_shaders = {
    {0x551A03A4, {
                     .crc32 = 0x551A03A4,
                     .code = __0x551A03A4,
                     .on_drawn = &OnToneMapLutBuilderDrawn,
                 }},  // ToneMap LutBuilder
    {0x2339C673, {
                     .crc32 = 0x2339C673,
                     .code = __0x2339C673,
                     .on_drawn = &OnUiLutBuilderDrawn,
                 }},  // UI - sRGB to HDR
    __ALL_CUSTOM_SHADERS};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Toggle in-game HDR setting or restart game to apply changes to Tone Mapper.",
        .section = "Tone Mapping",
        .tint = 0xFF0000,
        .is_visible = []() { return tone_map_lut_invalidated.load(std::memory_order_relaxed); },
        .is_sticky = false,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type. Toggle in-game HDR setting or restart game to take effect.",
        .labels = {"Vanilla", "Vanilla+", "ACES"},
        .on_change_value = &OnToneMapLutControlledSettingChanged,
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
        .default_value = 50.f,
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
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Restart game to apply changes to UI Brightness.",
        .section = "Miscellaneous",
        .tint = 0xFF0000,
        .is_visible = []() { return ui_lut_invalidated.load(std::memory_order_relaxed); },
        .is_sticky = false,
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
        .on_change_value = &OnUiNitsSettingChanged,
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
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
          RefreshToneMapLutDirtyState();
          RefreshUiLutDirtyState();
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

  RefreshToneMapLutDirtyState();
  RefreshUiLutDirtyState();
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Assassin's Creed: Shadows";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::utils::settings::on_preset_changed_callbacks.emplace_back(&OnPresetChangedInvalidateIfChanged);
        initialized = true;
      }
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    InitializeAppliedValues();
    RefreshToneMapLutDirtyState();
    RefreshUiLutDirtyState();
  }
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
