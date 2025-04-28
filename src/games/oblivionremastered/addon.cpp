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

bool g_lut_builder_updated = true;

bool OnLutBuilderDrawn(reshade::api::command_list* cmd_list) {
  g_lut_builder_updated = true;
  return true;
}

renodx::mods::shader::CustomShaders custom_shaders = {
    // Lut Builders
    CustomShaderEntryCallback(0x00C34813, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x35359B86, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x47329E4A, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x484B4E2B, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x56299258, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x57EE8201, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x5D14010F, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x704AB527, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x7D28F020, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x81243B91, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x8AB5FB23, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x92690156, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0x9ECC8B3C, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0xA8DA5452, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0xAF588657, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0xB439D7F0, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0xC3C5B8AD, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0xC51C976F, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0xF890095A, &OnLutBuilderDrawn),
    CustomShaderEntryCallback(0xFF16F46F, &OnLutBuilderDrawn),

    // Output
    CustomShaderEntry(0x70EB957B),
    CustomShaderEntry(0xD1CDE904),
    CustomShaderEntry(0x99B126EC),
    CustomShaderEntry(0x59C7FFCE),
    CustomShaderEntry(0xB6EDB152),
    CustomShaderEntry(0x04C003FD),
    CustomShaderEntry(0x1BD60193),
    CustomShaderEntry(0x8E39B831),
    CustomShaderEntry(0xCC2B95BB),
    CustomShaderEntry(0x9D0421B9),

    // FMV
    CustomShaderEntry(0x1FAA96A2),

};

ShaderInjectData shader_injection;

float g_hdr_upgrade = 2.f;

auto* hdr_upgrade_setting = renodx::templates::settings::CreateSetting({
    .key = "HDRUpgrade",
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 2.f,
    .label = "HDR Upgrade",
    .section = "Processing",
    .tooltip = "Selects how to apply HDR upgrade (restart required)",
    .labels = {"None", "Swap Chain", "Swap Chain + Videos"},
    .is_global = true,
});

void OnSettingChange() {
  g_lut_builder_updated = false;
};

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({
    {
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "Pause and unpause the game to apply changes.",
            .tint = 0xFF0000,
            .is_visible = []() {
              return shader_injection.custom_processing_mode == 0.f
                     && !g_lut_builder_updated;
            },
        },
    },
    renodx::templates::settings::CreateDefaultSettings({
        {"ToneMapType", {.binding = &shader_injection.tone_map_type, .on_change = &OnSettingChange}},
        {"ToneMapPeakNits", {.binding = &shader_injection.peak_white_nits, .on_change = &OnSettingChange}},
        {"ToneMapGameNits", {.binding = &shader_injection.diffuse_white_nits, .on_change = &OnSettingChange}},
        {"ToneMapUINits", {.binding = &shader_injection.graphics_white_nits, .is_enabled = []() { return g_hdr_upgrade >= 1.f; }, .on_change = &OnSettingChange}},
        {"ToneMapGammaCorrection", {.binding = &shader_injection.gamma_correction, .on_change = &OnSettingChange}},
        {"SceneGradeStrength", {.binding = &shader_injection.scene_grade_strength, .on_change = &OnSettingChange}},
        {"SceneGradeHueCorrection", {.binding = &shader_injection.scene_grade_hue_correction, .on_change = &OnSettingChange}},
        {"SceneGradeSaturationCorrection", {.binding = &shader_injection.scene_grade_saturation_correction, .on_change = &OnSettingChange}},
        {"SceneGradeBlowoutRestoration", {.binding = &shader_injection.scene_grade_blowout_restoration, .on_change = &OnSettingChange}},
        {"SceneGradeHueShift", {.binding = &shader_injection.scene_grade_hue_shift, .on_change = &OnSettingChange}},
        {"ColorGradeExposure", {.binding = &shader_injection.tone_map_exposure, .on_change = &OnSettingChange}},
        {"ColorGradeHighlights", {.binding = &shader_injection.tone_map_highlights, .on_change = &OnSettingChange}},
        {"ColorGradeShadows", {.binding = &shader_injection.tone_map_shadows, .on_change = &OnSettingChange}},
        {"ColorGradeContrast", {.binding = &shader_injection.tone_map_contrast, .on_change = &OnSettingChange}},
        {"ColorGradeSaturation", {.binding = &shader_injection.tone_map_saturation, .on_change = &OnSettingChange}},
        {"ColorGradeHighlightSaturation", {.binding = &shader_injection.tone_map_highlight_saturation, .on_change = &OnSettingChange}},
        {"ColorGradeBlowout", {.binding = &shader_injection.tone_map_blowout, .on_change = &OnSettingChange}},
        {"ColorGradeFlare", {.binding = &shader_injection.tone_map_flare, .on_change = &OnSettingChange}},
        {"FxBloom", {.binding = &shader_injection.custom_bloom}},
    }),
    {
        renodx::templates::settings::CreateSetting({
            .key = "FxAutoExposure",
            .binding = &shader_injection.custom_auto_exposure,
            .default_value = 100.f,
            .label = "Auto Exposure",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxChromaticAberration",
            .binding = &shader_injection.custom_chromatic_aberration,
            .default_value = 100.f,
            .label = "Chromatic Aberration",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxEyeAdaptation",
            .binding = &shader_injection.custom_eye_adaptation,
            .default_value = 100.f,
            .label = "Eye Adaptation",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxGrainType",
            .binding = &shader_injection.custom_grain_type,
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 1.f,
            .label = "Grain Type",
            .section = "Effects",
            .labels = {"Vanilla", "Perceptual"},
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxGrainStrength",
            .binding = &shader_injection.custom_grain_strength,
            .default_value = 0.f,
            .label = "Grain Strength",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxHDRVideos",
            .binding = &shader_injection.custom_hdr_videos,
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 2.f,
            .label = "HDR Videos",
            .section = "Effects",
            .labels = {"Off", "BT.2446a", "RenoDRT"},
            .is_enabled = []() { return g_hdr_upgrade >= 2.f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "ProcessingMode",
            .binding = &shader_injection.custom_processing_mode,
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 0.f,
            .label = "Processing Mode",
            .section = "Processing",
            .labels = {"LUT", "Output"},
        }),
        hdr_upgrade_setting,
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Discord",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0x5865F2,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "More Mods",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0x2B3137,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Github",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0x2B3137,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "ShortFuse's Ko-Fi",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0xFF5A16,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
            },
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
      {"FxHDRVideos", 0.f},
      {"FxAutoExposure", 100.f},
      {"FxChromaticAberration", 100.f},
      {"FxEyeAdaptation", 100.f},
      {"FxCustomGrain", 100.f},
      {"FxBloom", 0.f},

  });
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Oblivion Remastered";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::force_pipeline_cloning = true;

        renodx::mods::swapchain::SetUseHDR10(true);
        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
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

        renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
          return static_cast<bool>(params.size() < 20);
        };

        renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, hdr_upgrade_setting);
        g_hdr_upgrade = hdr_upgrade_setting->GetValue();

        if (g_hdr_upgrade >= 1.f) {
          // DLSSFG
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r10g10b10a2_unorm,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              .usage_include = reshade::api::resource_usage::render_target,
          });
          // Internal LUT
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r10g10b10a2_unorm,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .dimensions = {.width = 32, .height = 32, .depth = 32},
          });
        }

        if (g_hdr_upgrade >= 2.f) {
          // FMV
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::b8g8r8a8_typeless,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              .aspect_ratio = 3360.f / 1440.f,
          });

          // FMV
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::b8g8r8a8_typeless,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              .aspect_ratio = 3440.f / 1440.f,
          });
        }

        // // UI
        // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //     .old_format = reshade::api::format::b8g8r8a8_typeless,
        //     .new_format = reshade::api::format::r16g16b16a16_float,
        //     .use_resource_view_cloning = true,
        //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        // });

        renodx::mods::swapchain::force_borderless = false;
        renodx::mods::swapchain::prevent_full_screen = false;
        renodx::mods::swapchain::force_screen_tearing = true;

        renodx::utils::random::binds.push_back(&shader_injection.custom_random);

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  if (g_hdr_upgrade > 0.f) {
    renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  }
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
