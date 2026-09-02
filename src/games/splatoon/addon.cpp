/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID                   ImU64
#define RENODX_MODS_SWAPCHAIN_VERSION 2

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/log.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"
#include "./utils/shader_hotswap.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

bool isRyujinx = false;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings(
    {
        renodx::templates::settings::CreateDefaultSettings({
            {"ToneMapType", {.binding = &shader_injection.tone_map_type, .value_type = renodx::utils::settings::SettingValueType::INTEGER, .default_value = 2, .label = "Tone Mapper", .section = "Tone Mapping", .tooltip = "Sets the tone mapper type", .labels = {"Vanilla", "Vanilla+", "PsychoV-22"}}},
        }),
        renodx::templates::settings::CreateDefaultSettings({
            {"ToneMapPeakNits", &shader_injection.peak_white_nits},
            {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
            {"ToneMapUINits", &shader_injection.graphics_white_nits},
            {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
        }),
        {
            new renodx::utils::settings::Setting{
                .key = "ToneMapStrength",
                .binding = &shader_injection.tonemap_strength,
                .default_value = 100.f,
                .label = "Color Grading",
                .section = "Tone Mapping",
                .tooltip = "Controls intensity of tonemap applied by the game.",
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
                .key = "LutStrength",
                .binding = &shader_injection.lut_strength,
                .default_value = 100.f,
                .label = "LUT Strength",
                .section = "Color Grading",
                .tooltip = "Controls intensity of LUT applied by the game.",
                .max = 100.f,
                .parse = [](float value) { return value * 0.01f; },
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
            .label = "My Ko-Fi",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0x6b221a,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/souperman9"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "RenoDX Discord",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0x5865F2,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/kSTf", "EbcCpC"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Den Discord",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0x5865F2,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/XUhv", "tR54yc"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Github",
            .section = "Links",
            .group = "button-line-2",
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Ritsu's Ko-Fi",
            .section = "Links",
            .group = "button-line-3",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/ritsucecil"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "ShortFuse's Ko-Fi",
            .section = "Links",
            .group = "button-line-3",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Den's Ko-Fi",
            .section = "Links",
            .group = "button-line-3",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/hdrden"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "Game mod by souperman9, RenoDX Framework by ShortFuse, RenoVK fork by Ritsu.",
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

constexpr uint64_t USA = 0x0005000010176900ull;
constexpr uint64_t EUR = 0x0005000010176A00ull;
constexpr uint64_t JPN = 0x0005000010162B00ull;

using CemuGetTitleIdFn = uint64_t (*)();

bool IsAcceptedCemuTitleId(uint64_t title_id) {
  return title_id == USA || title_id == EUR || title_id == JPN;
}

bool ShouldAttachForCemu() {
  auto* const process_module = GetModuleHandleW(nullptr);
  if (process_module == nullptr) {
    renodx::utils::log::w("GetModuleHandleW(nullptr) failed");
    return false;
  }

  auto* get_title_id = reinterpret_cast<CemuGetTitleIdFn>(GetProcAddress(process_module, "gameMeta_getTitleId"));
  if (get_title_id == nullptr) {
    renodx::utils::log::w("Export gameMeta_getTitleId not found");
    return false;
  }

  const uint64_t title_id = get_title_id();
  const bool accepted = IsAcceptedCemuTitleId(title_id);
  renodx::utils::log::i(
      "gameMeta_getTitleId=",
      renodx::utils::log::AsHex(title_id),
      ", accepted=",
      accepted ? "true" : "false");
  return accepted;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Splatoon";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  const auto target_format = reshade::api::format::r16g16b16a16_float;
  const auto view_upgrades = renodx::utils::resource::VIEW_UPGRADES_RGBA16F;
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!ShouldAttachForCemu()) return FALSE;

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::target_format = target_format;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;

      // Always set to true for Vulkan
      renodx::mods::shader::allow_multiple_push_constants = true;

      auto common_aspect_ratio = 16.f / 9.f;
      auto common_aspect_ratio_tolerance = 0.00001f;

      const renodx::utils::resource::ResourceUpgradeInfo::Dimensions min_dimensions = {
          .width = 1280,
          .height = 720,
          .depth = renodx::utils::resource::ResourceUpgradeInfo::ANY,
      };

      /*
        If expand_existing_constant_buffer is set to false renoDX will add new cbuffer range (instead of reusing the game's).
        This behaviour is overridden if renoDX finds a cbuffer that targets all shader_stages in minimum_constant_buffer_stages.
        e.g. If a game's cbuffer range targets all stages, renoDX will expand it regardless of expand_existing_constant_buffer value.
        Remove the stages you're not injecting to.
      */
      renodx::mods::shader::minimum_constant_buffer_stages = reshade::api::shader_stage::pixel;

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r10g10b10a2_typeless,
          .new_format = target_format,
          .index = 0,
          .ignore_size = true,  // risky...?
          .min_dimensions = min_dimensions,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r10g10b10a2_typeless,
          .new_format = target_format,
          .index = 1,
          .ignore_size = true,  // risky...?
          .min_dimensions = min_dimensions,
      });

      // Register event handlers
      renodx_custom::utils::shader_hotswap::UseEarly(fdw_reason);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    }
    case DLL_PROCESS_DETACH:
      renodx_custom::utils::shader_hotswap::UseEarly(fdw_reason);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  // renodx::utils::random::Use(DLL_PROCESS_ATTACH);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx_custom::utils::shader_hotswap::UseLate(fdw_reason);

  return TRUE;
}
