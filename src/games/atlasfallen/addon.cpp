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
  {"ToneMapType", &shader_injection.tone_map_type},
  {"ToneMapPeakNits", &shader_injection.peak_white_nits},
  {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
  {"ToneMapUINits", &shader_injection.graphics_white_nits},
  {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
  /*{"ToneMapHueCorrection", &shader_injection.tone_map_hue_correction},
  {"ToneMapHueShift", &shader_injection.tone_map_hue_shift},
  {"ToneMapScaling", &shader_injection.tone_map_per_channel}, 
  {"SceneGradeSaturationCorrection", &shader_injection.scene_grade_saturation_correction},
  {"SceneGradeHueCorrection", &shader_injection.scene_grade_hue_correction},
  {"SceneGradeBlowoutRestoration", &shader_injection.scene_grade_blowout_restoration},
  {"SceneGradeStrength", &shader_injection.scene_grade_strength},*/
  {"ColorGradeExposure", &shader_injection.tone_map_exposure},
  {"ColorGradeHighlights", &shader_injection.tone_map_highlights},
  {"ColorGradeShadows", &shader_injection.tone_map_shadows},
  {"ColorGradeContrast", &shader_injection.tone_map_contrast},
  {"ColorGradeSaturation", &shader_injection.tone_map_saturation},
  {"ColorGradeHighlightSaturation", &shader_injection.tone_map_highlight_saturation},
  {"ColorGradeBlowout", &shader_injection.tone_map_blowout},
  {"ColorGradeFlare", &shader_injection.tone_map_flare},
}),
{
      new renodx::utils::settings::Setting{
        .key = "ToneMapUpradeType",
        .binding = &shader_injection.custom_tonemap_upgrade_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Grading Application",
        .section = "Highlight Saturation Restoration",
        .tooltip = "How the graded image gets upgraded",
        .labels = {"Luminance", "Per Channel+"},
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUpradeStrength",
        .binding = &shader_injection.custom_tonemap_upgrade_strength,
        .default_value = 75.f,
        .label = "Saturation Strength",
        .section = "Highlight Saturation Restoration",
        .is_enabled = []() { return shader_injection.custom_tonemap_upgrade_type == 1.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUpradeHueCorr",
        .binding = &shader_injection.custom_tonemap_upgrade_huecorr,
        .default_value = 90.f,
        .label = "Hue Correction",
        .section = "Highlight Saturation Restoration",
        .is_enabled = []() { return shader_injection.custom_tonemap_upgrade_type == 1.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "DisplayMapType",
        .binding = &shader_injection.custom_display_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Display Map Type",
        .section = "Highlight Saturation Restoration",
        .tooltip = "Sets the display mapper used",
        .labels = {"None", "DICE", "Frostbite", "RenoDRT NeutralSDR", "ToneMapMaxCLL"},
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    //new renodx::utils::settings::Setting{
    //    .key = "DebugSlider1",
    //    .binding = &shader_injection.debug_slider1,
    //    .default_value = 50.f,
    //    .label = "debug_slider1",
    //    .section = "Debug",
    //    .parse = [](float value) { return value * 0.01f; },
    //},
    //new renodx::utils::settings::Setting{
    //    .key = "DebugSlider2",
    //    .binding = &shader_injection.debug_slider2,
    //    .default_value = 50.f,
    //    .label = "debug_slider2",
    //    .section = "Debug",
    //    .parse = [](float value) { return value * 0.01f; },
    //},
    new renodx::utils::settings::Setting{
        .key = "FxChromaticAberration",
        .binding = &shader_injection.custom_chromatic_aberration,
        .default_value = 50.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .parse = [](float value) { return value * 0.02f; },
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
        renodx::utils::settings::UpdateSetting("ToneMapScaling", 0.f);
        renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
        renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 55.f);
        renodx::utils::settings::UpdateSetting("ColorGradeShadows", 57.f);
        renodx::utils::settings::UpdateSetting("ColorGradeContrast", 60.f);
        renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 60.f);
        renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
        renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
        renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
        renodx::utils::settings::UpdateSetting("ToneMapUpradeType", 1.f);
        renodx::utils::settings::UpdateSetting("ToneMapUpradeHueCorr", 90.f);
        renodx::utils::settings::UpdateSetting("ToneMapUpradeStrength", 75.f);
        renodx::utils::settings::UpdateSetting("DisplayMapType", 1.f);
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
        .label = "Having FSR2 or dynamic resolution enabled will crash the game.",
        .section = "Instructions",
    },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = "Game mod by akuru, RenoDX Framework by ShortFuse",
      .section = "About",
  },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "Discord",
      .section = "Links",
      .group = "button-line-1",
      .tint = 0x5865F2,
      .on_change = []() {
        renodx::utils::platform::LaunchURL("https://discord.gg/XUhv", "tR54yc");
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

void OnInitDevice(reshade::api::device* device) {
  int vendor_id;
  auto retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
  if (retrieved && vendor_id == 0x10de) {  // Nvidia vendor ID
    // Bugs out AMD GPUs
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r11g11b10_float,
      .new_format = reshade::api::format::r16g16b16a16_typeless,
      .use_resource_view_cloning = true,
      .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
    });
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Atlas Fallen";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::force_pipeline_cloning = true;

      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      /* renodx::mods::swapchain::use_resize_buffer = true;
      renodx::mods::swapchain::use_resize_buffer_on_demand = true; */
      //renodx::mods::swapchain::force_borderless = false;
      //renodx::mods::swapchain::prevent_full_screen = false;

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      //renodx::mods::swapchain::swapchain_proxy_revert_state = true;

      //renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //  .old_format = reshade::api::format::r11g11b10_float,
      //  .new_format = reshade::api::format::r16g16b16a16_typeless,
      //  .use_resource_view_cloning = true,
      //  .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
      //});
      
      // fp11 upgrades only for nvidia
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}