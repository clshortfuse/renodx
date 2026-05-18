/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <include/reshade_api_format.hpp>
#define ImTextureID                   ImU64
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
#include "./ryujinxlog.hpp"
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
    }),
    {
        new renodx::utils::settings::Setting{
            .key = "SDRBlendFactor",
            .binding = &shader_injection.tone_map_sdr_blend_factor,
            .default_value = 18.f,
            .label = "SDR Blend Factor",
            .section = "Tone Mapping",
            .tooltip = "Blends SDR to look more faithful to the art style",
            .min = 0.f,
            .max = 60.f,
            .is_enabled = []() { return shader_injection.tone_map_type > 0.f; },
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },
        new renodx::utils::settings::Setting{
            .key = "ColorGradeScene",
            .binding = &shader_injection.scene_grade_strength,
            .default_value = 70.f,
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
            .default_value = 65.f,
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
            .key = "VanillaSaturation",
            .binding = &shader_injection.vanilla_saturation,
            .default_value = 100.f,
            .label = "Vanilla Saturation",
            .section = "Color Grading",
            .tooltip = "Controls intensity of saturation applied by the game",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },

        new renodx::utils::settings::Setting{
            .key = "FxHueClip",
            .binding = &shader_injection.custom_bloom,
            .default_value = 100.f,
            .label = "Bloom",
            .section = "Effects",
            .tooltip = "Controls vanilla bloom strength",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
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
            .label = "Ritsu's Ko-Fi",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/ritsucecil"); },
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
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Den's Ko-Fi",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/hdrden"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "NX Optimizer",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0x7B1ED9,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://www.nxoptimizer.com/"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "Game mod by souperman9, tonemapper updated by Musa, RenoDX Framework by ShortFuse, RenoVK fork by Ritsu. \nSpecial thanks to MaxLastBreath, Izueh, Marat, and miru97",
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
      {"FxSaturationClip", 0.f},
  });
}

bool initialized = false;

const auto RYUJINX_PROCESS_NAME = std::string_view("Ryujinx.exe");
const auto RYUJINX_LOADED_TITLE_MARKER = std::string_view("Application Loaded:");
const std::array<std::string_view, 2> ACCEPTED_RYUJINX_TITLES = {
    "0100f2c0115b6000",
    "the legend of zelda: tears of the kingdom",
};

bool ShouldAttachForRyujinx(const std::filesystem::path& process_path) {
  const std::array<std::filesystem::path, 2> candidate_log_paths = {
      process_path.parent_path() / "logs",
      process_path.parent_path() / "portable" / "Logs",
  };

  return ryujinxlog::DoesLatestLogLastMatchingLineContainAny({
      .line_marker = RYUJINX_LOADED_TITLE_MARKER,
      .accepted_terms = ACCEPTED_RYUJINX_TITLES,
      .logs_paths = candidate_log_paths,
  });
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for The Legend of Zelda: Tears of the Kingdom";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  const auto target_format = reshade::api::format::r16g16b16a16_float;
  const auto view_upgrades = renodx::utils::resource::VIEW_UPGRADES_RGBA16F;

  const renodx::utils::resource::ResourceUpgradeInfo::Dimensions min_dimensions = {
      .width = 1600,
      .height = 900,
      .depth = renodx::utils::resource::ResourceUpgradeInfo::ANY,
  };

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      if (!reshade::register_addon(h_module)) return FALSE;
      auto process_path = renodx::utils::platform::GetCurrentProcessPath();
      auto filename = process_path.filename().string();

      if (filename == RYUJINX_PROCESS_NAME && !ShouldAttachForRyujinx(process_path)) return FALSE;

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::target_format = target_format;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;

      // Always set to true for Vulkan
      renodx::mods::shader::allow_multiple_push_constants = true;

      auto common_aspect_ratio = 16.f / 9.f;
      auto common_aspect_ratio_tolerance = 10000.f;

      /*
        If expand_existing_constant_buffer is set to false renoDX will add new cbuffer range (instead of reusing the game's).
        This behaviour is overridden if renoDX finds a cbuffer that targets all shader_stages in minimum_constant_buffer_stages.
        e.g. If a game's cbuffer range targets all stages, renoDX will expand it regardless of expand_existing_constant_buffer value.
        Remove the stages you're not injecting to.
      */
      renodx::mods::shader::minimum_constant_buffer_stages = reshade::api::shader_stage::pixel;

      static std::vector<uint32_t> hashes = {0xEF015FAB, 0x7D419515, 0xC7B41AEE};  // final buffer

      for (uint32_t hash : hashes) {
        for (int i = 0; i < 3; i++) {
          renodx::mods::swapchain::resource_upgrade_infos.push_back({
              .old_format = reshade::api::format::r8g8b8a8_typeless,
              .new_format = target_format,
              .shader_hash = hash,
              //   .ignore_size = true,  // risky...?
              .use_resource_view_cloning = true,
              //.view_format = reshade::api::format::r8g8b8a8_unorm_srgb,
              .aspect_ratio = common_aspect_ratio,
              .aspect_ratio_tolerance = common_aspect_ratio_tolerance,
              .ignore_reset = true,
              .view_upgrades = view_upgrades,
              .min_dimensions = min_dimensions,
          });
        }
      }
      //   for (int i = 0; i < 3; i++) {
      //     renodx::mods::swapchain::resource_upgrade_infos.push_back({
      //         .old_format = reshade::api::format::r8g8b8a8_typeless,
      //         .new_format = target_format,
      //         .shader_hash = 0xEF015FAB,
      //         //   .ignore_size = true,  // risky...?
      //         .use_resource_view_cloning = true,
      //         //.view_format = reshade::api::format::r8g8b8a8_unorm_srgb,
      //         .aspect_ratio = common_aspect_ratio,
      //         .aspect_ratio_tolerance = common_aspect_ratio_tolerance,
      //         .ignore_reset = true,
      //         .view_upgrades = view_upgrades,
      //         .min_dimensions = min_dimensions,
      //     });

      //     // new ryujinx...
      //     renodx::mods::swapchain::resource_upgrade_infos.push_back({
      //         .old_format = reshade::api::format::r8g8b8a8_typeless,
      //         .new_format = target_format,
      //         .shader_hash = 0x7D419515,
      //         //   .ignore_size = true,  // risky...?
      //         .use_resource_view_cloning = true,
      //         //.view_format = reshade::api::format::r8g8b8a8_unorm_srgb,
      //         .aspect_ratio = common_aspect_ratio,
      //         .aspect_ratio_tolerance = common_aspect_ratio_tolerance,
      //         .ignore_reset = true,
      //         .view_upgrades = view_upgrades,
      //         .min_dimensions = min_dimensions,
      //     });

      //     // intel version
      //     renodx::mods::swapchain::resource_upgrade_infos.push_back({
      //         .old_format = reshade::api::format::r8g8b8a8_typeless,
      //         .new_format = target_format,
      //         .shader_hash = 0xC7B41AEE,
      //         //   .ignore_size = true,  // risky...?
      //         .use_resource_view_cloning = true,
      //         //.view_format = reshade::api::format::r8g8b8a8_unorm_srgb,
      //         .aspect_ratio = common_aspect_ratio,
      //         .aspect_ratio_tolerance = common_aspect_ratio_tolerance,
      //         .ignore_reset = true,
      //         .view_upgrades = view_upgrades,
      //         .min_dimensions = min_dimensions,
      //     });
      //   }

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = target_format,
          .ignore_size = true,
          .shader_hash = 0xF3C7B934,
          //   .ignore_size = true,  // risky...?
          .use_resource_view_cloning = true,
          .view_upgrades = view_upgrades,
      });

      if (!initialized) {
        // renodx::utils::random::binds.push_back(&shader_injection.swap_chain_output_dither_seed);
        initialized = true;
      }

      // Register event handlers
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    }
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  // renodx::utils::random::Use(DLL_PROCESS_ATTACH);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
