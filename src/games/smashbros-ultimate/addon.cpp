/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
// #define DEBUG_LEVEL_1
// #define DEBUG_LEVEL_2

#define RENODX_MODS_SWAPCHAIN_VERSION 2

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

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({
    renodx::templates::settings::CreateDefaultSettings({
        {"ToneMapType", &shader_injection.tone_map_type},
        {"ToneMapPeakNits", &shader_injection.peak_white_nits},
        {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
        {"ToneMapUINits", &shader_injection.graphics_white_nits},
        {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
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
            .key = "FxBloom",
            .binding = &shader_injection.custom_bloom,
            .default_value = 25.f,
            .label = "Bloom Strength",
            .section = "Color Grading",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return settings[0]->GetValue() >= 2.f; },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "RenoDX Discord",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0x5865F2,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://discord.gg/kSTf", "EbcCpC");
            },
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
  });
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Smash Bros Ultimate";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  const auto target_format = reshade::api::format::r16g16b16a16_float;
  const auto view_upgrades = renodx::utils::resource::VIEW_UPGRADES_RGBA16F;
  auto common_aspect_ratio = 16.f / 9.f;
  auto common_ignore_size = false;
  auto weird_aspect_ratio = 3840.f / 1986.f;
  const renodx::utils::resource::ResourceUpgradeInfo::Dimensions min_dimensions = {
      .width = 720,
      .height = renodx::utils::resource::ResourceUpgradeInfo::ANY,
      .depth = renodx::utils::resource::ResourceUpgradeInfo::ANY,
  };
  const auto common_resource_view_cloning = true;

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::target_format = target_format;
      renodx::mods::shader::minimum_constant_buffer_stages = reshade::api::shader_stage::pixel;
      renodx::mods::swapchain::ignored_device_apis = {
          reshade::api::device_api::d3d11,
      };
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      renodx::mods::swapchain::SetUseHDR10(true);
      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
          .new_format = target_format,
          .ignore_size = common_ignore_size,
          .use_resource_view_cloning = common_resource_view_cloning,
          .aspect_ratio = common_aspect_ratio,
          .view_upgrades = view_upgrades,
          .min_dimensions = min_dimensions,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = target_format,
          .ignore_size = common_ignore_size,
          .use_resource_view_cloning = common_resource_view_cloning,
          .aspect_ratio = common_aspect_ratio,
          .view_upgrades = view_upgrades,
          .min_dimensions = min_dimensions,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r10g10b10a2_typeless,
          .new_format = target_format,
          .ignore_size = common_ignore_size,
          .use_resource_view_cloning = common_resource_view_cloning,
          .aspect_ratio = common_aspect_ratio,
          .view_upgrades = view_upgrades,
          .min_dimensions = min_dimensions,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = target_format,
          .ignore_size = common_ignore_size,
          .use_resource_view_cloning = common_resource_view_cloning,
          .aspect_ratio = common_aspect_ratio,
          .view_upgrades = view_upgrades,
          .min_dimensions = min_dimensions,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = target_format,
          .ignore_size = common_ignore_size,
          .use_resource_view_cloning = common_resource_view_cloning,
          .aspect_ratio = weird_aspect_ratio,
          .view_upgrades = view_upgrades,
          .min_dimensions = min_dimensions,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
          .new_format = target_format,
          .ignore_size = common_ignore_size,
          .use_resource_view_cloning = common_resource_view_cloning,
          .aspect_ratio = common_aspect_ratio,
          .view_upgrades = view_upgrades,
          .min_dimensions = min_dimensions,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = target_format,
          .ignore_size = common_ignore_size,
          .use_resource_view_cloning = common_resource_view_cloning,
          .aspect_ratio = common_aspect_ratio,
          .view_upgrades = view_upgrades,
          .min_dimensions = min_dimensions,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = target_format,
          .ignore_size = common_ignore_size,
          .use_resource_view_cloning = common_resource_view_cloning,
          .aspect_ratio = weird_aspect_ratio,
          .view_upgrades = view_upgrades,
          .min_dimensions = min_dimensions,
      });

        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::b8g8r8a8_unorm,
            .new_format = target_format,
            .ignore_size = common_ignore_size,
            .use_resource_view_cloning = common_resource_view_cloning,
            .aspect_ratio = common_aspect_ratio,
            .view_upgrades = view_upgrades,
            .min_dimensions = min_dimensions,
        });

        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::b8g8r8a8_unorm,
            .new_format = target_format,
            .ignore_size = common_ignore_size,
            .use_resource_view_cloning = common_resource_view_cloning,
            .aspect_ratio = weird_aspect_ratio,
            .view_upgrades = view_upgrades,
            .min_dimensions = min_dimensions,
        });

        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::b8g8r8a8_typeless,
            .new_format = target_format,
            .ignore_size = common_ignore_size,
            .use_resource_view_cloning = common_resource_view_cloning,
            .aspect_ratio = common_aspect_ratio,
            .view_upgrades = view_upgrades,
            .min_dimensions = min_dimensions,
        });

        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::b8g8r8a8_typeless,
            .new_format = target_format,
            .ignore_size = common_ignore_size,
            .use_resource_view_cloning = common_resource_view_cloning,
            .aspect_ratio = weird_aspect_ratio,
            .view_upgrades = view_upgrades,
            .min_dimensions = min_dimensions,
        });

      if (!initialized) {
        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(DLL_PROCESS_ATTACH);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::utils::resource::upgrade::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
