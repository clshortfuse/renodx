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
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({renodx::templates::settings::CreateDefaultSettings({
                                                                                            {"ToneMapType", &shader_injection.tone_map_type},
                                                                                            {"ToneMapPeakNits", &shader_injection.peak_white_nits},
                                                                                            {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
                                                                                            {"ToneMapUINits", &shader_injection.graphics_white_nits},
                                                                                            /* {"SceneGradeSaturationCorrection", &shader_injection.scene_grade_saturation_correction},
                                                                                            {"SceneGradeHueCorrection", &shader_injection.scene_grade_hue_correction},
                                                                                            {"SceneGradeBlowoutRestoration", &shader_injection.scene_grade_blowout_restoration}, */
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
                                                                                            /* renodx::templates::settings::CreateSetting({
                                                                                                .key = "FxGrainType",
                                                                                                .binding = &shader_injection.custom_grain_type,
                                                                                                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                                                                                                .default_value = 1.f,
                                                                                                .label = "Grain Type",
                                                                                                .section = "Effects",
                                                                                                .tooltip = "Replaces film grain with perceptual",
                                                                                                .labels = {"Vanilla", "Perceptual"},
                                                                                                .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 2; },
                                                                                            }),
                                                                                            renodx::templates::settings::CreateSetting({
                                                                                                .key = "FxGrainStrength",
                                                                                                .binding = &shader_injection.custom_grain_strength,
                                                                                                .default_value = 25.f,
                                                                                                .label = "Perceptual Grain Strength",
                                                                                                .section = "Effects",
                                                                                                .is_enabled = []() { return shader_injection.custom_grain_type != 0; },
                                                                                                .parse = [](float value) { return value * 0.01f; },
                                                                                                .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 2; },
                                                                                            }), */
                                                                                            renodx::templates::settings::CreateSetting({
                                                                                                .key = "FxPostProcessGrain",
                                                                                                .binding = &shader_injection.custom_enable_post_filmgrain,
                                                                                                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                                                                                                .default_value = 1.f,
                                                                                                .label = "Film Grain",
                                                                                                .section = "Effects",
                                                                                                .tooltip = "Enable cutscenes film grain",
                                                                                                .labels = {"Disabled", "Enabled"},
                                                                                                .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 2; },
                                                                                            }),
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
                                                                                                .label = "Game mod by Ritsu, RenoDX Framework by ShortFuse.",
                                                                                                .section = "About",
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
bool initialized = false;

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

  settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);
  fired_on_init_swapchain = true;
}

void OnInitDevice(reshade::api::device* device) {
  int vendor_id;
  auto retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
  if (retrieved && vendor_id == 0x10de) {  // Nvidia vendor ID
    // Bugs out AMD GPUs
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r11g11b10_float,
                                                                   .new_format = reshade::api::format::r16g16b16a16_typeless,
                                                                   .use_resource_view_cloning = true});
  }
}
}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Expedition 33";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        auto param_count = params.size();

        if (params.size() >= 20) return false;

        return true;
      };

      if (!initialized) {
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        // For puredark FG mod compatibility
        renodx::mods::shader::use_pipeline_layout_cloning = false;
        renodx::mods::shader::force_pipeline_cloning = false;
        renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::SetUseHDR10();
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

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::b8g8r8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
        });
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::b8g8r8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            // .usage_include = reshade::api::resource_usage::render_target,
        });

        // Some mod causing issues?
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
                                                                       .new_format = reshade::api::format::r16g16b16a16_float,
                                                                       .use_resource_view_cloning = true,
                                                                       .aspect_ratio = 3780.f / 2128.f});

        // Ultrawide
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
                                                                       .new_format = reshade::api::format::r16g16b16a16_float,
                                                                       .use_resource_view_cloning = true,
                                                                       .aspect_ratio = 3044.f / 1276.f});

        // Ultrawide DLAA
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
                                                                       .new_format = reshade::api::format::r16g16b16a16_float,
                                                                       .use_resource_view_cloning = true,
                                                                       .aspect_ratio = 3840.f / 1608.f});

        // Fixes DLAA lol
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .aspect_ratio = 3044.f / 1712.f,
        });

        // Portrait letterboxes screens
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .aspect_ratio = 2880.f / 2160.f,
        });

        // Everything else
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
                                                                       .new_format = reshade::api::format::r16g16b16a16_float,
                                                                       .use_resource_view_cloning = true});

        renodx::mods::swapchain::force_borderless = false;
        renodx::mods::swapchain::prevent_full_screen = false;

        renodx::utils::random::binds.push_back(&shader_injection.custom_random);
        initialized = true;
      }

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
