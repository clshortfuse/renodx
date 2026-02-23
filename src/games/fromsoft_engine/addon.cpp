/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <cstddef>
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

renodx::utils::settings::Setting* CreateDefault0PercentSetting(const renodx::utils::settings::Setting& setting) {
  auto* new_setting = new renodx::utils::settings::Setting(setting);
  if (new_setting->default_value == NULL) {
    new_setting->default_value = 0.f;
  }
  new_setting->parse = [](float value) { return value * 0.01f; };
  return new_setting;
}

renodx::utils::settings::Setting* CreateDefault50PercentSetting(const renodx::utils::settings::Setting& setting) {
  auto* new_setting = new renodx::utils::settings::Setting(setting);
  if (new_setting->default_value == NULL) {
    new_setting->default_value = 50.f;
  }
  new_setting->parse = [](float value) { return value * 0.02f; };
  return new_setting;
}

renodx::utils::settings::Setting* CreateDefault100PercentSetting(const renodx::utils::settings::Setting& setting) {
  auto* new_setting = new renodx::utils::settings::Setting(setting);
  if (new_setting->default_value == NULL) {
    new_setting->default_value = 100.f;
  }
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
    renodx::templates::settings::CreateSetting({
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
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminosity scales colors consistently",
        .labels = {"Luminosity", "Per Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
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
        .default_value = 50.f,
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
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    CreateDefault50PercentSetting({
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .label = "Saturation",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    CreateDefault50PercentSetting({
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    CreateDefault0PercentSetting({
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .is_visible = []() { return current_settings_mode >= 1; },
    }),
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeStrength",
        .binding = &shader_injection.custom_lut_strength,
        .default_value = 100.f,
        .label = "Color Grade Strength",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTScaling",
        .binding = &shader_injection.custom_lut_scaling,
        .default_value = 100.f,
        .label = "LUT Scaling",
        .section = "Color Grading",
        .tooltip = "Scales the color grade LUT to full range when size is clamped.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    renodx::templates::settings::CreateSetting({
        .key = "FxPostProcessCA",
        .binding = &shader_injection.custom_fx_chromatic_aberration,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tooltip = "Enable chromatic aberration",
        .labels = {"Disabled", "Enabled"},
        .is_visible = []() { return current_settings_mode >= 2; },
    }),
    CreateMultiLabelSetting({
        .key = "FxGrainType",
        .binding = &shader_injection.custom_grain_type,
        .default_value = 0.f,
        .label = "Grain Type",
        .section = "Effects",
        .labels = {"Vanilla (Dithering Noise)", "Perceptual"},
        .is_visible = []() { return current_settings_mode >= 2; },
    }),
    CreateDefault50PercentSetting({
        .key = "FxGrainStrength",
        .binding = &shader_injection.custom_grain_strength,
        .label = "Grain Strength",
        .section = "Effects",
        .is_visible = []() { return current_settings_mode >= 2; },
    }),
    new renodx::utils::settings::Setting{
        .key = "ColorGradeColorSpace",
        .binding = &shader_injection.color_grade_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Color Space",
        .section = "Custom Color Grading",
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
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/XUhv", "tR54yc");
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
        .label = " - Ingame HDR must be turned ON!",
        .section = "Instructions",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Game mod by Ritsu, RenoDX Framework by ShortFuse.",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Special thanks to Musa for the support!",
        .section = "About",
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
      {"ToneMapGammaCorrection", 0.f},
      {"ToneMapScaling", 1.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeStrength", 100.f},
      {"ColorGradeLUTScaling", 0.f},
      {"FxPostProcessCA", 0.f},
      {"FxGrainType", 0.f},
      {"FxGrainStrength", 50.f},
      {"ColorGradeColorSpace", 0.f},  // US CRT
  });
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = roundf(peak.value());
  } else {
    settings[2]->default_value = 1000.f;
  }
  settings[2]->can_reset = true;

  settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);

  fired_on_init_swapchain = true;
}

void OnInitDevice(reshade::api::device* device) {
  std::vector<renodx::utils::resource::ResourceUpgradeInfo> upgrade_infos = {};

  int vendor_id;
  auto retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
  if (retrieved) {
    if (vendor_id == 0x10de) {  // rgba16 for NVIDIA
      upgrade_infos.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
      });
    } else if (vendor_id == 0x1002) {  // rgb9e5 for AMD
      upgrade_infos.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r9g9b9e5,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
      });
    }
  }

  renodx::utils::resource::upgrade::SetUpgradeInfos(device, upgrade_infos);
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Fromsoft Engine";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::utils::resource::upgrade::Use(fdw_reason);  // fp11 upgrades

      /* renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        if (params.size() >= 8) return false;

        return true;
      }; */

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;

        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::SetUseHDR10();

        renodx::utils::random::binds.push_back(&shader_injection.custom_random);
        initialized = true;
      }

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);  // fp11 upgrades
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::resource::upgrade::Use(fdw_reason);  // fp11 upgrades

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);  // fp11 upgrades
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::random::Use(fdw_reason);

  return TRUE;
}
