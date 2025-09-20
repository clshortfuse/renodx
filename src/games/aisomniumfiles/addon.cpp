/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

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

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xEE5CA39C), // uberpost/lutsample
    CustomShaderEntry(0x46AE5D9D), // uberpost, somnium scene (green)
    CustomShaderEntry(0x224059A1), // somnia postprocess
    CustomShaderEntry(0xCE0AF0C9), // output success screen
    CustomShaderEntry(0xED466B41), // flowchart menu
    CustomShaderEntry(0xFEB3E510), // UI - menu
    CustomShaderEntry(0x8A6BCB4C), // videos
    CustomShaderEntry(0xEE94CA0F), // overlay, specific somnium scenes
    CustomShaderEntry(0x3F47A4BB), // map in somnia
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &RENODX_TONE_MAP_TYPE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT", "Exponential Rolloff"},
        .parse = [](float value) { return value * 3.f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &RENODX_PEAK_WHITE_NITS,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &RENODX_DIFFUSE_WHITE_NITS,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &RENODX_GRAPHICS_WHITE_NITS,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &RENODX_TONE_MAP_HUE_PROCESSOR,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp"},
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &RENODX_TONE_MAP_WORKING_COLOR_SPACE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &RENODX_TONE_MAP_HUE_SHIFT,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &RENODX_TONE_MAP_HUE_CORRECTION,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &RENODX_GAMMA_CORRECTION,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &RENODX_TONE_MAP_PER_CHANNEL,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &RENODX_TONE_MAP_EXPOSURE,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &RENODX_TONE_MAP_HIGHLIGHTS,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &RENODX_TONE_MAP_SHADOWS,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &RENODX_TONE_MAP_CONTRAST,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &RENODX_TONE_MAP_SATURATION,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &RENODX_TONE_MAP_BLOWOUT,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return fmax(value * 0.01f, 0.000001f); },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &RENODX_TONE_MAP_FLARE,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 3; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxHDRVideos",
        .binding = &CUSTOM_HDR_VIDEOS,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "HDR Videos",
        .section = "Effects",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxHDRVideosPeakNits",
        .binding = &CUSTOM_HDR_VIDEOS_PEAK_NITS,
        .default_value = 400.f,
        .label = "HDR Videos Peak Brightness",
        .section = "Effects",
        .tooltip = "Sets the value of peak white for HDR Videos in nits",
        .min = 48.f,
        .max = 1000.f,
        .is_enabled = []() { return CUSTOM_HDR_VIDEOS != 0; }
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Boosted Faithful",
        .section = "Presets",
        .group = "button-line-1",
        .tint = 0xb5b2b1,
        .on_change = []() {
            renodx::utils::settings::UpdateSetting("ToneMapType", 2.f);
            renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 1.f);
            renodx::utils::settings::UpdateSetting("ToneMapWorkingColorSpace", 0.f);
            renodx::utils::settings::UpdateSetting("GammaCorrection", 1.f);
            renodx::utils::settings::UpdateSetting("ToneMapHueShift", 50.f);
            renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 100.f);
            renodx::utils::settings::UpdateSetting("ToneMapScaling", 0.f);
            renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
            renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 53.f);
            renodx::utils::settings::UpdateSetting("ColorGradeShadows", 53.f);
            renodx::utils::settings::UpdateSetting("ColorGradeContrast", 53.f);
            renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 53.f);
            renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 60.f);
            renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 25.f);
            renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
        }
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Look",
        .section = "Presets",
        .group = "button-line-1",
        .tint = 0xb5b2b1,
        .on_change = []() {
            renodx::utils::settings::UpdateSetting("ToneMapType", 1.f);
            renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 1.f);
            renodx::utils::settings::UpdateSetting("ToneMapWorkingColorSpace", 0.f);
            renodx::utils::settings::UpdateSetting("GammaCorrection", 1.f);
            renodx::utils::settings::UpdateSetting("ToneMapHueShift", 50.f);
            renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 100.f);
            renodx::utils::settings::UpdateSetting("ToneMapScaling", 0.f);
            renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
            renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 60.f);
            renodx::utils::settings::UpdateSetting("ColorGradeShadows", 55.f);
            renodx::utils::settings::UpdateSetting("ColorGradeContrast", 60.f);
            renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
            renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 60.f);
            renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 40.f);
            renodx::utils::settings::UpdateSetting("ColorGradeFlare", 60.f);
        }
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Presets",
        .group = "button-line-1",
        .on_change = []() {
          for (auto setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Game mod by akuru, RenoDX Framework by ShortFuse",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::Launch(("https://discord.gg/Ce9b") + std::string("QHQrSV"));
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More RenoDX mods",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "About",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::Launch("https://ko-fi.com/shortfuse");
        },
    },
new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  // renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 1.f);
  // renodx::utils::settings::UpdateSetting("ToneMapHueShift", 1.f);
  // renodx::utils::settings::UpdateSetting("ToneMapWorkingColorSpace", 1.f);
  // renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 1.f);
  renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);
  // renodx::utils::settings::UpdateSetting("ToneMapScaling", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeShadows", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeContrast", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeFlare", 1.f);
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
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for AI: The Somnium Files";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      renodx::mods::swapchain::swapchain_proxy_revert_state = true;

      //  RG11B10_float (UAV stuff)
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r11g11b10_float,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        //.ignore_size = true,
        .view_upgrades = {
          {{reshade::api::resource_usage::shader_resource,
          reshade::api::format::r11g11b10_float},
          reshade::api::format::r16g16b16a16_float},
          {{reshade::api::resource_usage::unordered_access,
          reshade::api::format::r11g11b10_float},
          reshade::api::format::r16g16b16a16_float},
          {{reshade::api::resource_usage::render_target,
          reshade::api::format::r11g11b10_float},
          reshade::api::format::r16g16b16a16_float},
        }});

      //  RGBA8_typeless
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          //.ignore_size = true,
      });

      //  RGBA8_typeless
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          //.ignore_size = true,
      });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}