/*
 * Copyright (C) 2025 Carlos Lopez
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

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings(
{renodx::templates::settings::CreateDefaultSettings({
  {"ToneMapType", {.binding = &shader_injection.tone_map_type}},
  {"ToneMapPeakNits",  {.binding = &shader_injection.peak_white_nits}},
  {"ToneMapGameNits",  {.binding = &shader_injection.diffuse_white_nits}},
  {"ToneMapUINits", {.binding =  &shader_injection.graphics_white_nits}},
  {"ToneMapGammaCorrection", {.binding =  &shader_injection.gamma_correction}},
  {"ToneMapHueCorrection", {.binding =  &shader_injection.tone_map_hue_correction, .default_value = 90.f, .tooltip = "Emulates vanilla SDR hue shifts."}},
  {"ToneMapHueShift", {.binding =  &shader_injection.tone_map_hue_shift, .default_value = 75.f, .label = "Chrominance Correction", .tooltip = "Emulates vanilla SDR chrominance/blowout."}},
  {"ToneMapScaling", {.binding =  &shader_injection.tone_map_per_channel}},
  {"ColorGradeExposure",  {.binding = &shader_injection.tone_map_exposure}},
  {"ColorGradeHighlights",  {.binding = &shader_injection.tone_map_highlights}},
  {"ColorGradeShadows",  {.binding = &shader_injection.tone_map_shadows}},
  {"ColorGradeContrast",  {.binding = &shader_injection.tone_map_contrast}},
  {"ColorGradeSaturation",  {.binding = &shader_injection.tone_map_saturation}},
  {"ColorGradeHighlightSaturation", {.binding =  &shader_injection.tone_map_highlight_saturation}},
  {"ColorGradeBlowout", {.binding =  &shader_injection.tone_map_blowout}},
  {"ColorGradeFlare",  {.binding = &shader_injection.tone_map_flare}},
}),
{
  new renodx::utils::settings::Setting{
        .key = "CustomSatStrength",
        .binding = &CUSTOM_SAT_STRENGTH,
        .default_value = 100.f,
        .label = "DX Saturation",
        .section = "Effects",
        .tooltip = "Controls the DX color boost. Disable to match the original release.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
      .key = "CustomSatBrightness",
      .binding = &CUSTOM_SAT_BRIGHTNESS,
      .value_type = renodx::utils::settings::SettingValueType::INTEGER,
      .default_value = 0.f,
      .label = "DX Saturation Brightness Limit",
      .section = "Effects",
      .tooltip = "Prevents DX Saturation from brightening the image.",
      .labels = {"Vanilla / Off", "On"},
      .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomFlareEffect",
        .binding = &CUSTOM_FLARE_EFFECT,
        .default_value = 100.f,
        .label = "DX Sun Flare",
        .section = "Effects",
        .tooltip = "Sun-flare intensity.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "HDR Look",
      .section = "Presets",
      .group = "button-line-1",
      .tint = 0xb5b2b1,
      .on_change = []() {
        renodx::utils::settings::UpdateSetting("ToneMapType", 1.f);
        //renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 1.f);
        //renodx::utils::settings::UpdateSetting("ToneMapWorkingColorSpace", 0.f);
        renodx::utils::settings::UpdateSetting("GammaCorrection", 1.f);
        renodx::utils::settings::UpdateSetting("ToneMapScaling", 0.f);
        renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 90.f);
        renodx::utils::settings::UpdateSetting("ToneMapHueShift", 50.f);
        renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
        renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 55.f);
        renodx::utils::settings::UpdateSetting("ColorGradeShadows", 57.f);
        renodx::utils::settings::UpdateSetting("ColorGradeContrast", 60.f);
        renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 60.f);
        renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
        renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 50.f);
        renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
        renodx::utils::settings::UpdateSetting("CustomSatStrength", 100.f);
        renodx::utils::settings::UpdateSetting("CustomSatBrightness", 1.f);
        renodx::utils::settings::UpdateSetting("CustomFlareEffect", 25.f);
      }
  },
  new renodx::utils::settings::Setting{
    .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    .label = "Contrasty",
    .section = "Presets",
    .group = "button-line-1",
    .tint = 0xb5b2b1,
    .on_change = []() {
        renodx::utils::settings::UpdateSetting("ToneMapType", 1.f);
        renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 1.f);
        renodx::utils::settings::UpdateSetting("ToneMapWorkingColorSpace", 0.f);
        renodx::utils::settings::UpdateSetting("GammaCorrection", 1.f);
        renodx::utils::settings::UpdateSetting("ToneMapScaling", 0.f);
        renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 90.f);
        renodx::utils::settings::UpdateSetting("ToneMapHueShift", 60.f);
        renodx::utils::settings::UpdateSetting("ColorGradeExposure", 0.75f);
        renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 55.f);
        renodx::utils::settings::UpdateSetting("ColorGradeShadows", 52.f);
        renodx::utils::settings::UpdateSetting("ColorGradeContrast", 55.f);
        renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 65.f);
        renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
        renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
        renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
        renodx::utils::settings::UpdateSetting("CustomSatStrength", 50.f);
        renodx::utils::settings::UpdateSetting("CustomSatBrightness", 1.f);
        renodx::utils::settings::UpdateSetting("CustomFlareEffect", 25.f);
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
      .section = "Links",
      .group = "button-line-1",
      .tint = 0x5865F2,
      .on_change = []() {
        renodx::utils::platform::LaunchURL("https://discord.gg/Ce9b", "QHQrSV");
      },
  },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "More RenoDX mods",
      .section = "Links",
      .group = "button-line-1",
      .on_change = []() {
        renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
      },
  },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
      .section = "About",
  },
}});

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapGammaCorrection", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"CustomSatStrength", 100.f},
      {"CustomSatBrightness", 0.f},
      {"CustomFlareEffect", 100.f},
  });
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  settings[2]->can_reset = true;
  if (peak.has_value()) {
    settings[2]->default_value = roundf(peak.value());
  } else {
    settings[2]->default_value = 1000.f;
  }

  //settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);

  fired_on_init_swapchain = true;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Atelier Ryza DX";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      renodx::mods::swapchain::force_borderless = false;     // needed for stability
      renodx::mods::swapchain::prevent_full_screen = false;  // needed for stability

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      //renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      
      renodx::mods::swapchain::SetUseHDR10();

      // BGRA8_typeless
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.use_resource_view_cloning = true,
      });

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          //.use_resource_view_cloning = true,
      });

      // alchemy
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.use_resource_view_cloning = true,
      });


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