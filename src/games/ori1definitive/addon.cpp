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

    // Manually clamp shaders to fix artifacts
    CustomShaderEntry(0x74F1A9BF),
    CustomShaderEntry(0xA5B9F647),
    CustomShaderEntry(0xBC4BB886),
    CustomShaderEntry(0xC997373E),
    CustomShaderEntry(0xEDD7A595),
    CustomShaderEntry(0xFD5E9187),
    CustomShaderEntry(0x0F10CE07),
    CustomShaderEntry(0xD327EDF9),
    CustomShaderEntry(0xEF83C032),
    // more artifact fixes
    CustomShaderEntry(0xCC3D6FF7),
    CustomShaderEntry(0xD6DBC682),
    CustomShaderEntry(0x9A326CB2),
    CustomShaderEntry(0xA0679E6A),
    CustomShaderEntry(0x69935E20),
    CustomShaderEntry(0xDBE2402A),
    CustomShaderEntry(0x08EC9524),
    CustomShaderEntry(0x791C6897),
    CustomShaderEntry(0x1018F519),
    CustomShaderEntry(0x6743CB50),
    CustomShaderEntry(0xE020E0E3),
    // even more artifact fixes
    CustomShaderEntry(0xF2280F92),
    CustomShaderEntry(0x7EA3E0B2),
    CustomShaderEntry(0x92EF8684),
    CustomShaderEntry(0x95E462F3),
    CustomShaderEntry(0x0422C69E),
    CustomShaderEntry(0xE311E5C3),
    CustomShaderEntry(0x89FC4143),
    CustomShaderEntry(0xB932F19B),
    CustomShaderEntry(0x11507068),
    CustomShaderEntry(0xB8F1C5BC),
    CustomShaderEntry(0x61EDCA76),
    CustomShaderEntry(0x3D449D34),
    CustomShaderEntry(0x1612A2ED),

    CustomShaderEntry(0x470BECFA),  // post processing ubershader
    CustomShaderEntry(0x52BC2F1B),  // final
    CustomShaderEntry(0xB31E6B7C),  // final - no motion blur
    CustomShaderEntry(0x591107A5),  // video final

    // UI
    CustomShaderEntry(0x0B9EF709),
    CustomShaderEntry(0x0CBCCA15),
    CustomShaderEntry(0x3EE35D33),
    CustomShaderEntry(0x06E0FF55),
    CustomShaderEntry(0x32BBB6EC),
    CustomShaderEntry(0x405A953B),
    CustomShaderEntry(0x2776C84A),
    CustomShaderEntry(0xA3665A61),
    CustomShaderEntry(0xE63F1AA1),
    CustomShaderEntry(0xE534D964),
    CustomShaderEntry(0xEEDE4B16),
    CustomShaderEntry(0xF5017B78),
    CustomShaderEntry(0x57172B6F),
    CustomShaderEntry(0x0BC8B7AD),
    CustomShaderEntry(0x89FB32DC),
    CustomShaderEntry(0xF1446A0F),
    // more UI
    CustomShaderEntry(0x0BF7ABF5),
    CustomShaderEntry(0x7E661BCB),
    CustomShaderEntry(0x9EF7455E),
    CustomShaderEntry(0x844C51B1),
    CustomShaderEntry(0x4185B9AB),
    CustomShaderEntry(0x93682B5C),
    CustomShaderEntry(0xB39B9252),
    CustomShaderEntry(0xB56D6357),
    CustomShaderEntry(0xB68ED355),
    CustomShaderEntry(0xCA28B653),
    CustomShaderEntry(0xCCC2E9D3),
    CustomShaderEntry(0xD6874AF6),
    CustomShaderEntry(0xDDCCAB25),
    CustomShaderEntry(0xE6C66A25),
    CustomShaderEntry(0xF976A2A9),
    CustomShaderEntry(0xFE58A410),
    // even more UI
    CustomShaderEntry(0x110CBF45),
    CustomShaderEntry(0x3610A504),

};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {

    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "Exponential Rolloff"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 2; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeStrength",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Color Grade Strength",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScaling",
        .binding = &shader_injection.color_grade_scaling,
        .default_value = 100.f,
        .label = "Color Grade Scaling",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
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
        .label = "Github Discussions",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx/discussions/223");
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
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Game might occasionally have some rendering artifacts"),
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeStrength", 100.f},
      {"ColorGradeScaling", 0.f},
  });
}

void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::d3d11) {
    renodx::mods::shader::expected_constant_buffer_space = 0;
    renodx::mods::swapchain::expected_constant_buffer_space = 0;

    return;
  }

  if (device->get_api() == reshade::api::device_api::d3d12) {
    // Switch over to DX12
    renodx::mods::shader::expected_constant_buffer_space = 50;
    renodx::mods::swapchain::expected_constant_buffer_space = 50;
  }
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[1]->default_value = peak.value();
    settings[1]->can_reset = true;
  }
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Ori and the Blind Forest: Definitive Edition";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;

        // // TODO: find upgrades needed to unclamp crossfade transitions
        // for (auto index : {
        //          0,  // unclamps some stuff
        //          5,  // post processing ubershader
        //      }) {
        //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //       .old_format = reshade::api::format::r8g8b8a8_typeless,
        //       .new_format = reshade::api::format::r16g16b16a16_float,
        //       .index = index,
        //       .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        //       .usage_include = reshade::api::resource_usage::render_target,  // shader_resource and unodered_access are also flags
        //   });
        // }

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::render_target,  // shader_resource and unodered_access are also flags
        });

        initialized = true;
      }

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
