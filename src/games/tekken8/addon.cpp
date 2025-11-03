/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({
    renodx::templates::settings::CreateDefaultSettings({
        {
            "ToneMapType",
            {
                .binding = &shader_injection.tone_map_type,
                .default_value = 3.f,
                .labels = {"UE ACES (HDR)", "None", "ACES", "Vanilla+ (ACES + UE Filmic Blend)"},
                .parse = [](float value) { return value; },
            },
        },
        {"ToneMapPeakNits", {.binding = &shader_injection.peak_white_nits}},
        {"ToneMapGameNits", {.binding = &shader_injection.diffuse_white_nits}},
        {"ToneMapUINits", {.binding = &shader_injection.graphics_white_nits}},
        {"ToneMapScaling", {.binding = &shader_injection.tone_map_per_channel}},
        // {"ToneMapGammaCorrection", {.binding = &shader_injection.tone_map_gamma_correction, .labels = {"2.2", "BT.1886"}, .parse = [](float value) { return value + 1.f; }, .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 2; }}},
        /* {"SceneGradeSaturationCorrection", &shader_injection.scene_grade_saturation_correction},
        {"SceneGradeHueCorrection", &shader_injection.scene_grade_hue_correction},
        {"SceneGradeBlowoutRestoration", &shader_injection.scene_grade_blowout_restoration}, */
        {"ColorGradeExposure", {.binding = &shader_injection.tone_map_exposure, .default_value = 0.75f}},
        {"ColorGradeHighlights", {.binding = &shader_injection.tone_map_highlights}},
        {"ColorGradeShadows", {.binding = &shader_injection.tone_map_shadows}},
        {"ColorGradeContrast", {.binding = &shader_injection.tone_map_contrast}},
        {"ColorGradeSaturation", {.binding = &shader_injection.tone_map_saturation}},
        {"ColorGradeHighlightSaturation", {.binding = &shader_injection.tone_map_highlight_saturation}},
        {"ColorGradeBlowout", {.binding = &shader_injection.tone_map_blowout}},
        {"ColorGradeFlare", {.binding = &shader_injection.tone_map_flare}},
    }),
    {
        new renodx::utils::settings::Setting{
            .key = "lightStrength",
            .binding = &shader_injection.custom_lights_strength,
            .default_value = 50.f,
            .label = "Lights Strength",
            .section = "Lighting",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
        },
        /* new renodx::utils::settings::Setting{
            .key = "heroLightStrength",
            .binding = &shader_injection.custom_hero_light_strength,
            .default_value = 25.f,
            .label = "Character Light Strength",
            .section = "Lighting",
            .tooltip = "ONLY AFFECTS CERTAIN STAGES",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
        }, */
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Discord",
            .section = "Links",
            .group = "button-line-2",
            .tooltip = "RenoDX server",
            .tint = 0x5865F2,
            .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/F6AU", "TeWJHM"); },
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
            .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
            .section = "About",
        },
    },
});

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 3.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
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
  if (peak.has_value()) {
    settings[2]->default_value = roundf(peak.value());
  } else {
    settings[2]->default_value = 1000.f;
  }
  settings[2]->can_reset = true;

  settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);
  fired_on_init_swapchain = true;
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX Tekken 8";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      // while (IsDebuggerPresent() == 0) Sleep(100);

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::swapchain::force_borderless = true;
        renodx::mods::swapchain::prevent_full_screen = true;

        renodx::mods::swapchain::use_resize_buffer = true;
        renodx::mods::swapchain::use_resize_buffer_on_demand = true;
        renodx::mods::swapchain::set_color_space = false;
        renodx::mods::swapchain::SetUseHDR10(true);

        initialized = true;
      }

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
