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
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

    renodx::mods::shader::CustomShaders custom_shaders = {
        CustomShaderEntry(0xC0A30480), // Output 1
        CustomShaderEntry(0x2724B9C9), // Output 2
        CustomShaderEntry(0xB9397F62), // Output 3
        CustomShaderEntry(0x3483F079), // Output 4
        CustomShaderEntry(0x289F2576), // UI 1
        CustomShaderEntry(0x384FC9E6), // UI 2
        CustomShaderEntry(0xEE90D7DD), // UI 3
        CustomShaderEntry(0x498A6414)  // UI 4
      };

ShaderInjectData shader_injection;

float current_settings_mode = 3;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla","RenoDRT"},
        .parse = [](float value) { return value * 3.f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
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
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxDoF",
        .binding = &shader_injection.custom_dof,
        .default_value = 100.f,
        .label = "Depth of Field",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxVignette",
        .binding = &shader_injection.custom_vignette,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Vignette",
        .section = "Effects",
        .tooltip = "Custom removes vignette processing on highlights.",
        .labels = {"Off", "Custom", "On"},
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "RenoDX by ShortFuse, game mod by Bit Viper.",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "HDR Den Discord",
      .section = "About",
      .group = "button-line-1",
      .tint = 0x5865F2,
      .on_change = []() {
        renodx::utils::platform::Launch(
            "https://discord.gg/"
            "5WZXDpmbpP");
      },
    },
    new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "RenoDX Github",
      .section = "About",
      .group = "button-line-1",
      .on_change = []() {
        renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx");
      },
    },
    new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "Bit Viper's Ko-Fi",
      .section = "About",
      .group = "button-line-1",
      .on_change = []() {
        renodx::utils::platform::Launch("https://ko-fi.com/bitviper");
      },
    },
    new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "HDR Den's Ko-Fi",
      .section = "About",
      .group = "button-line-1",
      .on_change = []() {
        renodx::utils::platform::Launch("https://ko-fi.com/hdrden");
      },
    },
    new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "ShortFuse's Ko-Fi",
      .section = "About",
      .group = "button-line-1",
      .on_change = []() {
        renodx::utils::platform::Launch("https://ko-fi.com/shortfuse");
      },
    },
    new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "Reset All",
      .section = "Options",
      .group = "button-line-2",
      .on_change = []() {
        for (auto setting : settings) {
          if (setting->key.empty()) continue;
          if (!setting->can_reset) continue;
          renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
        }
      },
    },
};

void OnPresetOff() {
    renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
    renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
    renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
    renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
    renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
    renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
    renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
    renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
    renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
    renodx::utils::settings::UpdateSetting("ColorGradeLUTStrength", 100.f);
    renodx::utils::settings::UpdateSetting("ColorGradeLUTScaling", 0.f);
    renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
    renodx::utils::settings::UpdateSetting("fxDoF", 100.f);
    renodx::utils::settings::UpdateSetting("fxVignette", 2.f);
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

  settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);
  fired_on_init_swapchain = true;
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for DiRT Rally 2.0";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::prevent_full_screen = true;
        renodx::mods::swapchain::force_borderless = true;
        renodx::mods::swapchain::swapchain_proxy_revert_state = true;
        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
            {
                reshade::api::device_api::d3d12,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
                },
            },
        };

        //  RGBA8_Typeless
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_typeless,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::ANY
          });
  
          //  RGBA8_UNORM_SRGB
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
            .new_format = reshade::api::format::r16g16b16a16_typeless,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::ANY
          });

          //  BGRA8_UNORM
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::b8g8r8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_typeless,
            .ignore_size = true,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::ANY
          });

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
