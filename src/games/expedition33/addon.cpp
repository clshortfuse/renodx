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

float current_settings_mode = 0;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({renodx::templates::settings::CreateDefaultSettings({
                                                                                            {"ToneMapType", &shader_injection.tone_map_type},
                                                                                            {"ToneMapPeakNits", &shader_injection.peak_white_nits},
                                                                                            {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
                                                                                            {"ToneMapUINits", &shader_injection.graphics_white_nits},
                                                                                            {"SceneGradeSaturationCorrection", &shader_injection.scene_grade_saturation_correction},
                                                                                            {"SceneGradeHueCorrection", &shader_injection.scene_grade_hue_correction},
                                                                                            {"SceneGradeBlowoutRestoration", &shader_injection.scene_grade_blowout_restoration},
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
                                                                                                .key = "FxGrainStrength",
                                                                                                .binding = &shader_injection.custom_grain_strength,
                                                                                                .default_value = 0.f,
                                                                                                .label = "Grain Strength",
                                                                                                .section = "Effects",
                                                                                                .parse = [](float value) { return value * 0.01f; },
                                                                                            }), */
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

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

bool initialized = false;

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
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

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
        }); 
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::b8g8r8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            // .usage_include = reshade::api::resource_usage::render_target,
        });

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r11g11b10_float,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
        });

        // Upgrade internal LUT
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
        });

        renodx::mods::swapchain::force_borderless = false;
        renodx::mods::swapchain::prevent_full_screen = false;

        renodx::utils::random::binds.push_back(&shader_injection.custom_random);
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
