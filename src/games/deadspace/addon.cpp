/*
 * Copyright (C) 2026 Musa Haji
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
#include "pipeline_layouts.hpp"
#include "resource_upgrades.hpp"

namespace {

ShaderInjectData shader_injection;

std::atomic_bool tone_map_lut_invalidated = false;
float applied_tone_map_type = 1.f;
float applied_peak_nits = 1000.f;
float applied_override_game_brightness = 0.f;
float applied_game_nits = 152.32879f;
float applied_tone_map_working_color_space = 1.f;

void SetToneMapLutInvalidated(bool invalidated) {
    tone_map_lut_invalidated.store(invalidated, std::memory_order_relaxed);
}

bool ToneMapLutValuesDirty() {
    return shader_injection.tone_map_type != applied_tone_map_type
                 || shader_injection.peak_white_nits != applied_peak_nits
                 || shader_injection.override_game_brightness != applied_override_game_brightness
                 || shader_injection.diffuse_white_nits != applied_game_nits
                 || shader_injection.tone_map_working_color_space != applied_tone_map_working_color_space;
}

void RefreshToneMapLutDirtyState() {
    SetToneMapLutInvalidated(ToneMapLutValuesDirty());
}

void MarkToneMapLutApplied() {
    applied_tone_map_type = shader_injection.tone_map_type;
    applied_peak_nits = shader_injection.peak_white_nits;
    applied_override_game_brightness = shader_injection.override_game_brightness;
    applied_game_nits = shader_injection.diffuse_white_nits;
    applied_tone_map_working_color_space = shader_injection.tone_map_working_color_space;
    RefreshToneMapLutDirtyState();
}

void InitializeAppliedValues() {
    applied_tone_map_type = shader_injection.tone_map_type;
    applied_peak_nits = shader_injection.peak_white_nits;
    applied_override_game_brightness = shader_injection.override_game_brightness;
    applied_game_nits = shader_injection.diffuse_white_nits;
    applied_tone_map_working_color_space = shader_injection.tone_map_working_color_space;
}

void OnToneMapLutBuilderDrawn(reshade::api::command_list* /*cmd_list*/) {
    MarkToneMapLutApplied();
}

void OnToneMapLutControlledSettingChanged(float /*previous*/, float /*current*/) {
    RefreshToneMapLutDirtyState();
}

void OnPresetChangedInvalidateIfChanged() {
    RefreshToneMapLutDirtyState();
}

renodx::mods::shader::CustomShaders custom_shaders = {
        {0xEC2192B4, {
                                         .crc32 = 0xEC2192B4,
                                         .code = __0xEC2192B4,
                                         .on_drawn = &OnToneMapLutBuilderDrawn,
                                 }},
        {0x6F0456CD, {
                                         .crc32 = 0x6F0456CD,
                                         .code = __0x6F0456CD,
                                         .on_drawn = &OnToneMapLutBuilderDrawn,
                                 }},
        {0xD97D273F, {
                                         .crc32 = 0xD97D273F,
                                         .code = __0xD97D273F,
                                         .on_drawn = &OnToneMapLutBuilderDrawn,
                                 }},
        __ALL_CUSTOM_SHADERS};

bool ShouldInjectShaderCBuffer(
    reshade::api::device* device,
    std::span<const reshade::api::pipeline_layout_param> params) {
  if (device->get_api() != reshade::api::device_api::d3d12) return false;

  const bool allow_injection = deadspace::pipeline_layouts::ShouldInjectPipelineLayout(params, false);

  return allow_injection;
}

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .labels = {"Vanilla", "RenoDX"},
        .on_change_value = &OnToneMapLutControlledSettingChanged,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the peak white brightness in nits.",
        .min = 100.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .on_change_value = &OnToneMapLutControlledSettingChanged,
    },
    new renodx::utils::settings::Setting{
        .key = "OverrideGameBrightness",
        .binding = &shader_injection.override_game_brightness,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "Override Game Brightness",
        .section = "Tone Mapping",
        .labels = {"Off", "On"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .on_change_value = &OnToneMapLutControlledSettingChanged,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 152.32879f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets diffuse white brightness in nits.",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.override_game_brightness != 0.f && shader_injection.tone_map_type != 0.f; },
        .on_change_value = &OnToneMapLutControlledSettingChanged,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"AP1", "LMS"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .on_change_value = &OnToneMapLutControlledSettingChanged,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Move the in-game brightness slider back and forth to apply settings.",
        .section = "Tone Mapping",
        .tint = 0xFF0000,
        .is_visible = []() { return tone_map_lut_invalidated.load(std::memory_order_relaxed); },
        .is_sticky = true,
    },
    new renodx::utils::settings::Setting{
        .key = "OverrideUIBrightness",
        .binding = &shader_injection.override_ui_brightness,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "Override UI Brightness",
        .section = "UI",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 200.f,
        .label = "UI Brightness",
        .section = "UI",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.override_ui_brightness != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "UIEOTFEmulation",
        .binding = &shader_injection.sdr_eotf_emulation_ui,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "UI SDR EOTF Emulation",
        .section = "UI",
        .tooltip = "Emulates a 2.2 EOTF for the UI",
        .labels = {"Off", "2.2"},
    },
    new renodx::utils::settings::Setting{
        .key = "UIVisibility",
        .binding = &shader_injection.custom_ui_visibility,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "UI Visibility",
        .section = "UI",
        .labels = {"Hide", "Show"},
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeDechroma",
        .binding = &shader_injection.tone_map_dechroma,
        .default_value = 0.f,
        .label = "Dechroma",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/glare compensation.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
// new renodx::utils::settings::Setting{
//   .key = "FxBloom",
//   .binding = &shader_injection.custom_bloom,
//   .default_value = 100.f,
//   .label = "Bloom",
//   .section = "Effects",
//   .max = 100.f,
//   .parse = [](float value) { return value * 0.01f; },
// },
// new renodx::utils::settings::Setting{
//   .key = "FxGrainType",
//   .binding = &shader_injection.custom_grain_type,
//   .value_type = renodx::utils::settings::SettingValueType::INTEGER,
//   .default_value = 0.f,
//   .label = "Grain Type",
//   .section = "Effects",
//   .labels = {"Vanilla", "None"},
// },
// new renodx::utils::settings::Setting{
//   .key = "FxGrainStrength",
//   .binding = &shader_injection.custom_grain_strength,
//   .default_value = 100.f,
//   .label = "Grain Strength",
//   .section = "Effects",
//   .max = 100.f,
//   .parse = [](float value) { return value * 0.01f; },
// },
#if DEADSPACE_ENABLE_RESOURCE_UPGRADES
    deadspace::resource_upgrades::CreateRestartWarningSetting(),
    deadspace::resource_upgrades::CreateSetting(),
#endif
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "t9v7wx9NTD");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "GitHub",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "musaqh");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "shortfuse");
        },
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
      {"ToneMapPeakNits", 10000.f},
      {"OverrideGameBrightness", 0.f},
      {"ToneMapGameNits", 152.32879f},
      {"ToneMapWorkingColorSpace", 0.f},
      {"OverrideUIBrightness", 0.f},
      {"ToneMapUINits", 200.f},
      {"UIEOTFEmulation", 0.f},
      {"UIVisibility", 1.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeDechroma", 0.f},
      {"ColorGradeFlare", 0.f},
  });

    RefreshToneMapLutDirtyState();
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Dead Space (2023)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto params) {
        if (device->get_api() != reshade::api::device_api::d3d12) return false;  // So overlays don't kill the game
        return ShouldInjectShaderCBuffer(device, params);
      };
      renodx::mods::shader::on_create_pipeline_layout = [](reshade::api::device* device, auto params) {
        if (device->get_api() != reshade::api::device_api::d3d12) return false;  // So overlays don't kill the game
        return ShouldInjectShaderCBuffer(device, params);
      };

      if (!initialized) {
        renodx::utils::settings::use_presets = false;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 0;
        renodx::mods::shader::force_pipeline_cloning = true;
                renodx::utils::settings::on_preset_changed_callbacks.emplace_back(&OnPresetChangedInvalidateIfChanged);

        initialized = true;
      }
#if DEADSPACE_ENABLE_RESOURCE_UPGRADES
      deadspace::resource_upgrades::Register();
#endif

      break;
    case DLL_PROCESS_DETACH:
#if DEADSPACE_ENABLE_RESOURCE_UPGRADES
      deadspace::resource_upgrades::Unregister();
#endif

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
    if (fdw_reason == DLL_PROCESS_ATTACH) {
        InitializeAppliedValues();
        RefreshToneMapLutDirtyState();
    }
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
