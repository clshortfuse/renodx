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
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"


namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    // LUT builders
    CustomShaderEntry(0x47A1239F),  // ACES
    CustomShaderEntry(0xBE750C14),  // Neutral

    // Other post processing
    CustomShaderEntry(0xABF2B519),
    CustomShaderEntry(0x7A37E8BA),
    CustomShaderEntry(0xAF565E99),
    CustomShaderEntry(0xAFBE175C),
    CustomShaderEntry(0xD25C43B1),
    CustomShaderEntry(0x62B04FA9),

    // Final
    CustomShaderEntry(0x20133A8B),

    // UI
    CustomShaderEntry(0x9232F9CC),
    CustomShaderEntry(0x4F036BB9),
    CustomShaderEntry(0x55B0DCB7),
    CustomShaderEntry(0x915C6643),
    CustomShaderEntry(0xC1457489),
    CustomShaderEntry(0xC8B9F878),
    CustomShaderEntry(0x8E2521B8),
    CustomShaderEntry(0x066C98CB),
    CustomShaderEntry(0x04615C32),
    CustomShaderEntry(0x510352D9),
};

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
        .labels = {"Vanilla", "None", "ACES / Exponential Rolloff"},
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
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off (sRGB)", "2.2"},
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    CreateDefault50PercentSetting({
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .label = "Highlights",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    CreateDefault50PercentSetting({
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .label = "Shadows",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    CreateDefault50PercentSetting({
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .label = "Contrast",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
    }),
    CreateDefault50PercentSetting({
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .label = "Saturation",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
    }),
    CreateDefault0PercentSetting({
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
    }),
    CreateDefault100PercentSetting({
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game",
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    CreateMultiLabelSetting({
        .key = "colorGradeLUTSampling",
        .binding = &shader_injection.custom_lut_tetrahedral,
        .default_value = 1.f,
        .label = "LUT Sampling",
        .section = "Color Grading",
        .labels = {"Trilinear", "Tetrahedral"},
        .is_visible = []() { return current_settings_mode >= 2; },
    }),
    CreateMultiLabelSetting({
        .key = "FxGrainType",
        .binding = &shader_injection.custom_grain_type,
        .default_value = 1.f,
        .label = "Grain Type",
        .section = "Effects",
        .labels = {"Vanilla (Noise)", "Perceptual"},
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    CreateDefault50PercentSetting({
        .key = "FxGrainStrength",
        .binding = &shader_injection.custom_grain_strength,
        .label = "Grain Strength",
        .section = "Effects",
        .is_enabled = []() { return shader_injection.custom_grain_type > 0; },
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
          renodx::utils::platform::Launch(
              "https://discord.gg/"
              "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::Launch("https://ko-fi.com/musaqh"); },
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
      {"ColorGradeScene", 100.f},
      {"FxGrainType", 0.f},
      {"FxGrainStrength", 50.f},
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
  bool was_upgraded = renodx::mods::swapchain::IsUpgraded(swapchain);
  if (was_upgraded) {
    settings[2]->default_value = 100.f;
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Beyond Blue";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_index = 13;

      //  RGBA8_typeless
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
      });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // auto detect peak and paper white

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // auto detect peak and paper white
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
