/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */
#include <include/reshade_api_format.hpp>
#define ImTextureID                   ImU64
#define RENODX_MODS_SWAPCHAIN_VERSION 2

#include <embed/shaders.h>

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

bool is_harry2 = false;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({
    renodx::templates::settings::CreateDefaultSettings({
        {"ToneMapType", &shader_injection.tone_map_type},
        {"ToneMapPeakNits", &shader_injection.peak_white_nits},
        {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
        {"ToneMapUINits", &shader_injection.graphics_white_nits},
        {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
    }),
    {
        new renodx::utils::settings::Setting{
            .key = "ColorGradeScene",
            .binding = &shader_injection.scene_grade_strength,
            .default_value = 50.f,
            .label = "Hue Shift",
            .section = "Tone Mapping",
            .tooltip = "Emulates SDR hue shifts to match vanilla",
            .max = 100.f,
            .is_enabled = []() { return shader_injection.tone_map_type > 0.f; },
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },
        new renodx::utils::settings::Setting{
            .key = "ColorGradeBlowout",
            .binding = &shader_injection.tone_map_blowout,
            .default_value = 50.f,
            .label = "SDR Blowout",
            .section = "Tone Mapping",
            .tooltip = "Emulates SDR blowout to match vanilla",
            .max = 100.f,
            .is_enabled = []() { return shader_injection.tone_map_type > 0.f; },
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },
    },

    renodx::templates::settings::CreateDefaultSettings({
        {"ColorGradeExposure", &shader_injection.tone_map_exposure},
        {"ColorGradeHighlights", &shader_injection.tone_map_highlights},
        {"ColorGradeShadows", &shader_injection.tone_map_shadows},
        {"ColorGradeContrast", &shader_injection.tone_map_contrast},
        {"ColorGradeSaturation", &shader_injection.tone_map_saturation},
        {"ColorGradeHighlightSaturation", &shader_injection.tone_map_highlight_saturation},
        {"ColorGradeFlare", &shader_injection.tone_map_flare},
    }),
    {
        new renodx::utils::settings::Setting{
            .key = "LutStrength",
            .binding = &shader_injection.lut_strength,
            .default_value = 100.f,
            .label = "LUT Strength",
            .section = "Color Grading",
            .tooltip = "Controls intensity of LUT applied by the game.",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },
        new renodx::utils::settings::Setting{
            .key = "DisableLetterbox",
            .binding = &shader_injection.letterbox,
            .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
            .default_value = 1,
            .label = "Disable Letterbox",
            .section = "Effects",
            .tooltip = "Disables letterboxing in cutscenes",
            .is_visible = []() { return !is_harry2; },
        },
        new renodx::utils::settings::Setting{
            .key = "FxBloom",
            .binding = &shader_injection.custom_bloom,
            .value_type = renodx::utils::settings::SettingValueType::FLOAT,
            .default_value = 100.f,
            .label = "Bloom",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        },
        new renodx::utils::settings::Setting{
            .key = "FxVignette",
            .binding = &shader_injection.custom_vignette,
            .value_type = renodx::utils::settings::SettingValueType::FLOAT,
            .default_value = 100.f,
            .label = "Vignette",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        },
        new renodx::utils::settings::Setting{
            .key = "StudStrength",
            .binding = &shader_injection.stud_strength,
            .default_value = 0.f,
            .label = "Stud Brightness",
            .section = "Effects",
            .tooltip = "Boosts stud brightness",
            .max = 100.f,
            .parse = [](float value) { return 1 + (value * 0.01f); },
        },

        // new renodx::utils::settings::Setting{
        //     .key = "FxBloom",
        //     .binding = &shader_injection.custom_bloom,
        //     .default_value = 25.f,
        //     .label = "Bloom Strength",
        //     .section = "Color Grading",
        //     .max = 100.f,
        //     .parse = [](float value) { return value * 0.01f; },
        //     .is_visible = []() { return settings[0]->GetValue() >= 2.f; },
        // },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "RenoDX Discord",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0x5865F2,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/kSTf", "EbcCpC"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Den Discord",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0x5865F2,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/XUhv", "tR54yc"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Github",
            .section = "Links",
            .group = "button-line-1",
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "My Ko-Fi!",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/souperman9"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "ShortFuse's Ko-Fi",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "Game mod by souperman9, RenoDX Framework by ShortFuse.",
            .section = "About",
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
            .section = "About",
        },
    },
});

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  // Reset frame state
}

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
      {"ColorGradeScene", 100.f},
      {"FxHueClip", 100.f},
      {"LutStrength", 0.f},
  });
}

}  // namespace

bool initialized = false;

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Lego Harry Potter Collection";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      if (!reshade::register_addon(h_module)) return FALSE;

      auto process_path = renodx::utils::platform::GetCurrentProcessPath();
      auto filename = process_path.filename().string();
      if (filename == "harry2.exe" || filename == "Harry2.exe") is_harry2 = true;

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .dimensions = {.width = renodx::utils::resource::ResourceUpgradeInfo::ANY, .height = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER},
      });

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        // //renodx::mods::swapchain::SetUseHDR10(true);
        // renodx::mods::swapchain::expected_constant_buffer_index = 13;
        // renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;

        initialized = true;
      }

      break;
    }
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);

      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
