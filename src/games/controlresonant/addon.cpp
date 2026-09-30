/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

// #define DEBUG_LEVEL_0
// #define DEBUG_LEVEL_1
// #define DEBUG_LEVEL_2
// #define DEBUG_LEVEL_3

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "pipeline_layouts.hpp"
#include "shared.h"

namespace {

ShaderInjectData shader_injection;

constexpr float FALLBACK_PEAK_NITS = 1000.f;
float peak_nits_default = FALLBACK_PEAK_NITS;
bool peak_nits_default_initialized = false;
bool swapchain_is_hdr = false;
renodx::utils::settings::Setting* tone_map_peak_nits_setting = nullptr;

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

renodx::utils::settings::Settings settings = {
    tone_map_peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = FALLBACK_PEAK_NITS,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Output",
        .tooltip = "Sets the value of peak white in nits.\nDefault: detected display peak nits (1000 nits fallback)",
        .min = 48.f,
        .max = 10000.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
        .is_visible = []() { return swapchain_is_hdr; },
        .is_logarithmic = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Output",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .is_visible = []() { return swapchain_is_hdr; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Output",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .is_visible = []() { return swapchain_is_hdr; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDX (Vanilla+)", "RenoDX (Customized)", "RenoDX (PsychoV)", "SDR"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHighlightCompression",
        .binding = &shader_injection.tone_map_highlight_compression,
        .default_value = 100.f,
        .label = "Highlight Restraint",
        .section = "Tone Mapping",
        .tooltip = "Controls how strongly upper midtones and lower highlights are restrained to prevent harsh, eye-searing brightness while preserving brighter highlight separation.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return shader_injection.tone_map_type == 1.f || shader_injection.tone_map_type == 2.f || shader_injection.tone_map_type == 3.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGamutClip",
        .binding = &shader_injection.tone_map_gamut_clip,
        .default_value = 100.f,
        .label = "Gamut Clip",
        .section = "Tone Mapping",
        .tooltip = "Controls the strength of Vanilla+ gamut clipping.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return shader_injection.tone_map_type == 1.f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "UIVisibility",
    //     .binding = &shader_injection.custom_ui_visibility,
    //     .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 1.f,
    //     .label = "UI Visibility",
    //     .section = "UI",
    //     .labels = {"Hide", "Show"},
    // },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightContrast",
        .binding = &shader_injection.tone_map_contrast_highlights,
        .default_value = 50.f,
        .label = "Highlight Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadowContrast",
        .binding = &shader_injection.tone_map_contrast_shadows,
        .default_value = 50.f,
        .label = "Shadow Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeDechroma",
        .binding = &shader_injection.tone_map_dechroma,
        .default_value = 0.f,
        .label = "Dechroma",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f && shader_injection.tone_map_type != 4.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTStrength",
        .binding = &shader_injection.color_grade_lut_strength,
        .default_value = 100.f,
        .label = "Color Grade Strength",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeLUTScaling",
    //     .binding = &shader_injection.color_grade_lut_scaling,
    //     .default_value = 0.f,
    //     .label = "LUT Scaling",
    //     .section = "Color Grading",
    //     .tooltip = "Scales the color grade LUT to full range when size is clamped.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "FxGrainStrength",
    //     .binding = &shader_injection.custom_grain_strength,
    //     .default_value = 50.f,
    //     .label = "Custom Film Grain",
    //     .section = "Effects",
    //     .max = 100.f,
    //     .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-0",
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
        .label = "Github",
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

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool /*resize*/) {
  if (swapchain == nullptr) return;

  swapchain_is_hdr = renodx::utils::swapchain::IsHDRColorSpace(swapchain);

  if (!swapchain_is_hdr || peak_nits_default_initialized) return;
  peak_nits_default_initialized = true;
  const auto detected_peak_nits = renodx::utils::swapchain::GetPeakNits(swapchain);
  tone_map_peak_nits_setting->can_reset = detected_peak_nits.has_value() && *detected_peak_nits > 0.f;
  peak_nits_default = (tone_map_peak_nits_setting->can_reset ? *detected_peak_nits : FALLBACK_PEAK_NITS);

  const bool was_using_default = tone_map_peak_nits_setting->GetValue() == tone_map_peak_nits_setting->default_value;
  tone_map_peak_nits_setting->default_value = peak_nits_default;
  if (was_using_default) {
    tone_map_peak_nits_setting->Set(peak_nits_default)->Write();
  }
}

void OnPresent(
    [[maybe_unused]] reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    [[maybe_unused]] const reshade::api::rect* source_rect,
    [[maybe_unused]] const reshade::api::rect* dest_rect,
    [[maybe_unused]] uint32_t dirty_rect_count,
    [[maybe_unused]] const reshade::api::rect* dirty_rects) {
  OnInitSwapchain(swapchain, false);
}

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapPeakNits", peak_nits_default},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapType", 0.f},
      {"ToneMapHighlightCompression", 0.f},
      {"ToneMapGamutClip", 100.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeHighlightContrast", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeShadowContrast", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeDechroma", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeLUTStrength", 100.f},
  });
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for CONTROL Resonant";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto params) {
        if (device->get_api() != reshade::api::device_api::d3d12) return false;
        return control_resonant::pipeline_layouts::ShouldInjectPipelineLayout(params);
      };

      renodx::mods::shader::on_create_pipeline_layout = [](reshade::api::device* device, auto params) {
        if (device->get_api() != reshade::api::device_api::d3d12) return false;
        if (DIAGNOSTIC_SKIP_THREE_PARAM_LAYOUTS && params.size() == 3u) {
          control_resonant::pipeline_layouts::LogDiagnosticLayout(device, params);
          return false;
        }
        return control_resonant::pipeline_layouts::ShouldInjectPipelineLayout(params);
      };

      if (DIAGNOSTIC_SKIP_THREE_PARAM_LAYOUTS) {
        reshade::log::message(reshade::log::level::info,
                              "[RenoDX CONTROL] Diagnostic original 3-param exclusion enabled (creation only).");
      }

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;

        renodx::mods::shader::expected_constant_buffer_index = 0;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}