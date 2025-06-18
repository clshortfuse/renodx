/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

#define OutputShaderEntry(value)                           \
  {                                                        \
      value,                                               \
      {                                                    \
          .crc32 = value,                                  \
          .code = __##value,                               \
          .on_drawn = [](auto cmd_list) {                  \
            shader_injection.custom_video_has_drawn = 0.f; \
            shader_injection.custom_ui_has_drawn = 0.f;    \
            return true;                                   \
          },                                               \
      },                                                   \
  }

#define VideoShaderEntry(value)                            \
  {                                                        \
      value,                                               \
      {                                                    \
          .crc32 = value,                                  \
          .code = __##value,                               \
          .on_drawn = [](auto cmd_list) {                  \
            shader_injection.custom_video_has_drawn = 1.f; \
            return true;                                   \
          },                                               \
      },                                                   \
  }

#define UIShaderEntry(value)                             \
  {                                                      \
      value,                                             \
      {                                                  \
          .crc32 = value,                                \
          .code = __##value,                             \
          .on_drawn = [](auto cmd_list) {                \
            shader_injection.custom_ui_has_drawn += 1.f; \
            return true;                                 \
          },                                             \
      },                                                 \
  }
renodx::mods::shader::CustomShaders custom_shaders = {
    VideoShaderEntry(0xA4311A98),
    OutputShaderEntry(0x13D78644),
    UIShaderEntry(0x25CC5A3A),
    __ALL_CUSTOM_SHADERS,
};

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({renodx::templates::settings::CreateDefaultSettings({
                                                                                            {"ToneMapType", &shader_injection.tone_map_type},
                                                                                            {"ToneMapPeakNits", &shader_injection.peak_white_nits},
                                                                                            {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
                                                                                            {"ToneMapUINits", &shader_injection.graphics_white_nits},
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
                                                                                                .key = "CustomLowerWhiteUI",
                                                                                                .binding = &shader_injection.custom_lower_white,
                                                                                                .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
                                                                                                .default_value = 1.f,
                                                                                                .label = "Lower white UI",
                                                                                                .section = "Color Grading",
                                                                                                .tooltip = "Lowers UI elements that are displayed at max nits",
                                                                                                .labels = {"Off", "On"},
                                                                                                .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 2; },
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

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for The Hundred Line Last Defense Academy";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      if (!initialized) {
        /* renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::allow_multiple_push_constants = true; */

        /* renodx::mods::swapchain::force_borderless = true;
        renodx::mods::swapchain::prevent_full_screen = true; */
        // renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::swapchain::use_device_proxy = true;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::set_color_space = false;
        renodx::mods::swapchain::use_resize_buffer = true;
        renodx::mods::swapchain::use_resize_buffer_on_demand = true;

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
            .old_format = reshade::api::format::r8g8b8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        });
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r11g11b10_float,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        });
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
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