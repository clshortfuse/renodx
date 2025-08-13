/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

// Empty addon just for running the game in HDR

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"

#include "../../templates/settings.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

#include <embed/shaders.h>

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,
};

ShaderInjectData shader_injection;
const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({
    renodx::templates::settings::CreateDefaultSettings({
        // {
        //     "ToneMapType",
        //     {
        //         .binding = &shader_injection.tone_map_type,
        //         .default_value = 3.f,
        //         .labels = {"Vanilla (SDR)", "None", "ACES", "Vanilla+ (ACES + UE Filmic Blend)"},
        //         .parse = [](float value) { return value == 0.f ? 4.f : value; },  // hacky way but better than rewriting code
        //     },
        // },
        {"ToneMapPeakNits", {.binding = &shader_injection.peak_white_nits}},
        {"ToneMapGameNits", {.binding = &shader_injection.diffuse_white_nits}},
        {"ToneMapUINits", {.binding = &shader_injection.graphics_white_nits}},
        // {"ToneMapScaling", {.binding = &shader_injection.tone_map_per_channel}},
        {"ColorGradeExposure", {.binding = &shader_injection.tone_map_exposure}},
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
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = " - Native HDR MUST BE ENABLED in game!",
            .section = "Instructions",
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "Special thanks to Shortfuse & the folks at HDR Den for their support! Join the HDR Den discord for help!",
            .section = "About",
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Den Discord",
            .section = "About",
            .group = "button-line-1",
            .tint = 0x5865F2,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://discord.gg/5WZX", "DpmbpP");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Get more RenoDX mods!",
            .section = "About",
            .group = "button-line-1",
            .tint = 0x5865F2,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "ShortFuse's Ko-Fi",
            .section = "About",
            .group = "button-line-1",
            .tint = 0xFF5F5F,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Den's Ko-Fi",
            .section = "About",
            .group = "button-line-1",
            .tint = 0xFF5F5F,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://ko-fi.com/hdrden");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "This build was compiled on " + build_date + " at " + build_time + ".",
            .section = "About",
        },
    },
});

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapDisplay", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 400.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 60.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 120.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX DBZSPARK";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX DBZSPARK";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      if (!initialized) {
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::force_pipeline_cloning = true;

        renodx::mods::swapchain::use_resource_cloning = true;

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .dimensions = {.width = 32, .height = 32, .depth = 32},
        });

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
        });

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r11g11b10_float,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
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
