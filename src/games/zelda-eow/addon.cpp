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
int game = 0;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings(
    {
        renodx::templates::settings::CreateDefaultSettings({
            {"ToneMapType", {.binding = &shader_injection.tone_map_type, .value_type = renodx::utils::settings::SettingValueType::INTEGER, .default_value = 2, .label = "Tone Mapper", .section = "Tone Mapping", .tooltip = "Sets the tone mapper type", .labels = {"Vanilla", "Vanilla+", "PsychoV-17"}}},
        }),
        renodx::templates::settings::CreateDefaultSettings({
            {"ToneMapPeakNits", &shader_injection.peak_white_nits},
            {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
            {"ToneMapUINits", &shader_injection.graphics_white_nits},
            {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
        }),
        {
            new renodx::utils::settings::Setting{
                .key = "LutStrength",
                .binding = &shader_injection.lut_strength,
                .default_value = 100.f,
                .label = "Color Grading",
                .section = "Tone Mapping",
                .tooltip = "Controls intensity of color grading applied by the game.",
                .max = 100.f,
                .is_enabled = []() { return shader_injection.tone_map_type != 6.f; },
                .parse = [](float value) { return value * 0.01f; },
                .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f && shader_injection.tone_map_type != 6.f; },
            },
            new renodx::utils::settings::Setting{
                .key = "ColorGradeScene",
                .binding = &shader_injection.scene_grade_strength,
                .default_value = 50.f,
                .label = "Color Shift",
                .section = "Tone Mapping",
                .tooltip = "Emulates SDR color shifts to match vanilla",
                .max = 100.f,
                .is_enabled = []() { return shader_injection.tone_map_type == 3.f; },
                .parse = [](float value) { return value * 0.01f; },
                .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f && shader_injection.tone_map_type == 3.f; },
            },
            new renodx::utils::settings::Setting{
                .key = "ColorGradeConeResponse",
                .binding = &shader_injection.custom_cone_response,
                .default_value = 60.f,
                .label = "Cone Response",
                .section = "Tone Mapping",
                .max = 100.f,
                .is_enabled = []() { return shader_injection.tone_map_type == 6.f; },
                .parse = [](float value) { return value * 0.02f; },
                .is_visible = []() { return shader_injection.tone_map_type == 6.f && renodx::templates::settings::current_settings_mode > 1.f; },
            },
        },

        renodx::templates::settings::CreateDefaultSettings({{"ColorGradeExposure", &shader_injection.tone_map_exposure},
                                                            {"ColorGradeHighlights", &shader_injection.tone_map_highlights},
                                                            {"ColorGradeShadows", &shader_injection.tone_map_shadows},
                                                            {"ColorGradeContrast", &shader_injection.tone_map_contrast},
                                                            {"ColorGradeSaturation", &shader_injection.tone_map_saturation}}),
        {
            new renodx::utils::settings::Setting{
                .key = "ColorGradeHighlightSaturation",
                .binding = &shader_injection.tone_map_highlight_saturation,
                .value_type = renodx::utils::settings::SettingValueType::FLOAT,
                .default_value = 50.f,
                .label = "Highlight Saturation",
                .section = "Color Grading",
                .tooltip = "Adds or removes highlight color.",
                .parse = [](float value) { return value / 50.f; },
                .is_visible = []() { return shader_injection.tone_map_type != 6.f; },
            },
            new renodx::utils::settings::Setting{
                .key = "ColorGradeFlare",
                .binding = &shader_injection.tone_map_flare,
                .value_type = renodx::utils::settings::SettingValueType::FLOAT,
                .default_value = 0.f,
                .label = "Flare",
                .section = "Color Grading",
                .tooltip = "Flare/Glare compensation",
                .parse = [](float value) { return value / 100.f; },
                .is_visible = []() { return shader_injection.tone_map_type != 6.f; },
            },
            new renodx::utils::settings::Setting{
                .key = "FxBloom",
                .binding = &shader_injection.custom_bloom,
                .default_value = 100.f,
                .label = "Bloom",
                .section = "Effects",
                .max = 100.f,
                .parse = [](float value) { return value * 0.01f; },
            },
            new renodx::utils::settings::Setting{
                .key = "FxDof",
                .binding = &shader_injection.custom_dof,
                .default_value = 100.f,
                .label = "Depth of Field",
                .section = "Effects",
                .max = 100.f,
                .parse = [](float value) { return value * 0.01f; },
                .is_visible = []() { return game == 2; },
            },
            new renodx::utils::settings::Setting{
                .key = "FxVignette",
                .binding = &shader_injection.custom_vignette,
                .default_value = 100.f,
                .label = "Vignette",
                .section = "Effects",
                .max = 100.f,
                .parse = [](float value) { return value * 0.01f; },
                .is_visible = []() { return game == 2; },
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
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Game mod and RenoDX framework by ShortFuse, RenoVK fork by Ritsu.",
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
      {"ColorGradeScene", 100.f},
      {"FxVignette", 100.f},
      {"FxDof", 100.f},
      {"LutStrength", 100.f},
  });
}

float res_scale = 1.f;

const auto RYUJINX_PROCESS_NAME = std::string_view("Ryujinx.exe");
const auto RYUJINX_LOADED_TITLE_MARKER = std::string_view("Application Loaded:");
const std::array<std::string_view, 2> LA = {
    "01006bb00c6f0000",
    "the legend of zelda: link's awakening",
};

const std::array<std::string_view, 2> EOW = {
    "01008cf01baac800",
    "the legend of zelda: echoes of wisdom",
};

int ShouldAttachForRyujinx(const std::filesystem::path& process_path) {
  const std::array<std::filesystem::path, 2> candidate_log_paths = {
      process_path.parent_path() / "logs",
      process_path.parent_path() / "portable" / "Logs",
  };
  res_scale = ryujinxlog::GetLatestLogResScale(std::filesystem::path{}, candidate_log_paths);

  int game = 0;
  if (ryujinxlog::DoesLatestLogLastMatchingLineContainAny({
          .line_marker = RYUJINX_LOADED_TITLE_MARKER,
          .accepted_terms = LA,
          .logs_paths = candidate_log_paths,
      })) {
    game = 1;
  }
  else if (ryujinxlog::DoesLatestLogLastMatchingLineContainAny({
                 .line_marker = RYUJINX_LOADED_TITLE_MARKER,
                 .accepted_terms = EOW,
                 .logs_paths = candidate_log_paths,
             })) {
        game = 2;
    }
    return game;
}

      const renodx::utils::resource::ResourceUpgradeInfo::Dimensions MIN_DIMENSIONS = {
          .width = renodx::utils::resource::ResourceUpgradeInfo::ANY,
          .height = static_cast<int16_t>(1079 * res_scale),
          .depth = renodx::utils::resource::ResourceUpgradeInfo::ANY,
      };

void OnInitDevice(reshade::api::device* device) {
  int vendor_id;
  auto retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
  if (retrieved && vendor_id == 0x10de) {  // Nvidia vendor ID
    // Bugs out AMD GPUs
      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_reset = true,
          .min_dimensions = MIN_DIMENSIONS,
      });
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for The Legend of Zelda: Echoes of Wisdom & Link's Awakening";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  const auto target_format = reshade::api::format::r16g16b16a16_float;
  const auto view_upgrades = renodx::utils::resource::VIEW_UPGRADES_RGBA16F;

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      if (!reshade::register_addon(h_module)) return FALSE;
      auto process_path = renodx::utils::platform::GetCurrentProcessPath();
      auto filename = process_path.filename().string();
      game = ShouldAttachForRyujinx(process_path);
      if (filename == RYUJINX_PROCESS_NAME && game == 0) return FALSE;

      const auto log_message = std::string("ResScale: ") + std::to_string(res_scale);
      reshade::log::message(reshade::log::level::info, log_message.c_str());

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

      static std::vector<uint32_t> hashes = {0xEF015FAB};                                              // final buffer
      static std::vector<uint32_t> tonemap_hashes = {0x6AACC705, 0x9063BD29, 0xFA7AFD3A, 0x65F02A9E};  // tonemap

      // for (uint32_t hash : hashes) {
      //   for (int i = 0; i < 3; i++) {
      //     renodx::mods::swapchain::resource_upgrade_infos.push_back({
      //         .old_format = reshade::api::format::r8g8b8a8_typeless,
      //         .new_format = target_format,
      //         .shader_hash = hash,
      //         .use_resource_view_cloning = true,
      //         .min_dimensions = MIN_DIMENSIONS,
      //     });
      //   }
      // }

      for (int i = 0; i < 2; i++) {
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = target_format,
            .index = i,
            .ignore_reset = true,
            .min_dimensions = MIN_DIMENSIONS,
        });
      }

      // Register event handlers
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);   

      break;
    }
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  // renodx::utils::random::Use(DLL_PROCESS_ATTACH);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
