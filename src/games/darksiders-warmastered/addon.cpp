/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define NOMINMAX

// #include <chrono>
// #include <random>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/random.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

// const std::unordered_map<std::string, float> HDR_LOOK_VALUES = {
//     {"ToneMapWhiteClip", 100.f},
//     {"ColorGradeExposure", 0.50f},
//     {"ColorGradeShadows", 53.f},
//     {"ColorGradeContrast", 54.f},
//     {"ColorGradeSaturation", 53.f},
//     {"ToneMapHDRBoost", 35.f},
// };

auto last_is_hdr = false;

renodx::utils::settings::Settings settings = {

    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &RENODX_RENDER_MODE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &RENODX_TONE_MAP_TYPE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "Hermite Spline"},
        .parse = [](float value) { return value; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &RENODX_PEAK_WHITE_NITS,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        //.is_visible = []() { return settings[1]->GetValue() == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &RENODX_DIFFUSE_WHITE_NITS,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        //.is_visible = []() { return settings[1]->GetValue() == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &RENODX_GRAPHICS_WHITE_NITS,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        //.is_visible = []() { return settings[1]->GetValue() == 1; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "GammaCorrection",
    //     .binding = &RENODX_GAMMA_CORRECTION,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 1.f,
    //     .label = "Gamma Correction",
    //     .section = "Tone Mapping",
    //     .tooltip = "Emulates a display EOTF.",
    //     .labels = {"Off", "2.2", "BT.1886"},
    //     .is_visible = []() { return settings[0]->GetValue() >= 1; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapWhiteClip",
    //     .binding = &RENODX_TONE_MAP_WHITE_CLIP,
    //     .default_value = 45.f,
    //     .label = "White Clip",
    //     .section = "Tone Mapping",
    //     .tooltip = "Sets the brightness of UI and HUD elements in nits",
    //     .min = 2.f,
    //     .max = 100.f,
    //     .is_visible = []() { return settings[0]->GetValue() >= 1; },
    // },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHDRBoost",
        .binding = &shader_injection.hdr_boost,
        .default_value = 35.f,
        .label = "HDR Boost",
        .section = "Tone Mapping",
        .max = 50.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Vanilla",
        .section = "Presets",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "HDR Look",
    //     .section = "Presets",
    //     .group = "button-line-1",
    //     .on_change = []() {
    //       for (auto* setting : settings) {
    //         if (setting->key.empty()) continue;
    //         if (!setting->can_reset) continue;
    //         if (setting->is_global) continue;
    //         //if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
    //         if (HDR_LOOK_VALUES.contains(setting->key)) {
    //           renodx::utils::settings::UpdateSetting(setting->key, HDR_LOOK_VALUES.at(setting->key));
    //         } else {
    //           renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
    //         }
    //       }
    //     },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapHueProcessor",
    //     .binding = &RENODX_TONE_MAP_HUE_PROCESSOR,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Hue Processor",
    //     .section = "Scene Grading",
    //     .tooltip = "Selects hue processor",
    //     .labels = {"OKLab", "ICtCp", "darkTable UCS"},
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1; },
    // },
// new renodx::utils::settings::Setting{
//         .key = "SceneGradeHueCorrection",
//         .binding = &shader_injection.tone_map_hue_correction,
//         .default_value = 0.f,
//         .label = "Hue Correction",
//         .section = "Scene Grading",
//         .max = 100.f,
//         .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
//         .parse = [](float value) { return value * 0.01f; },
//         .is_visible = []() { return settings[0]->GetValue() >= 1; },
//     },
        new renodx::utils::settings::Setting{
        .key = "SceneGradePerChannelBlowout",
        .binding = &shader_injection.scene_grade_per_channel_blowout,
        .default_value = 65.f,
        .label = "Per Channel Blowout",
        .section = "Scene Grading",
        .tooltip = "Simulates the highlight desaturation of per-channel tonemapping.",
        .max = 90.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return (0.01f * pow(100.f - value, 2.f)); },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "SceneGradeHueShift",
        .binding = &shader_injection.scene_grade_per_channel_hue_shift,
        .default_value = 100.f,
        .label = "Per Channel Hue Shift",
        .section = "Scene Grading",
        .tooltip = "Simulates the hue shifting of per-channel tonemapping. Effect is tied to Per Channel Blowout.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0 && SCENE_GRADE_PER_CHANNEL_BLOWOUT > 0.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
            new renodx::utils::settings::Setting{
        .key = "SceneGradeHueClip",
        .binding = &shader_injection.scene_grade_hue_clip,
        .default_value = 0.f,
        .label = "Hue Clip",
        .section = "Scene Grading",
        .tooltip = "Simulates the color of highlight clipping in SDR games with no tonemapper.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0 && SCENE_GRADE_PER_CHANNEL_BLOWOUT > 0.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "SceneGradeHighlightStrength",
    //     .binding = &SCENE_GRADE_HIGHLIGHT_STRENGTH,
    //     .default_value = 100.f,
    //     .label = "Tonemapping Highlight Strength",
    //     .section = "Scene Grading",
    //     .tooltip = "Adjusts how much the original tonemapper's highlight curve affects the image.",
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "SceneGradeShadowStrength",
    //     .binding = &SCENE_GRADE_SHADOW_STRENGTH,
    //     .default_value = 100.f,
    //     .label = "Tonemapping Shadow Strength",
    //     .section = "Scene Grading",
    //     .tooltip = "Adjusts how much the original tonemapper's shadow curve affects the image.",
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1; },
    // },
// new renodx::utils::settings::Setting{
//         .key = "SceneGradeLUTStrength",
//         .binding = &SCENE_GRADE_LUT_STRENGTH,
//         .default_value = 100.f,
//         .label = "LUT Strength",
//         .section = "Scene Grading",
//         .tooltip = "Adjusts how much the original grading affects the image.",
//         .max = 100.f,
//         .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
//         .parse = [](float value) { return value * 0.01f; },
//         .is_visible = []() { return settings[0]->GetValue() >= 1; },
//     },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &RENODX_TONE_MAP_EXPOSURE,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &RENODX_TONE_MAP_HIGHLIGHTS,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &RENODX_TONE_MAP_SHADOWS,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &RENODX_TONE_MAP_CONTRAST,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &RENODX_TONE_MAP_SATURATION,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &RENODX_TONE_MAP_BLOWOUT,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return fmax(value * 0.01f, 0.000001f); },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &RENODX_TONE_MAP_FLARE,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.0001f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxChromaticAberration",
        .binding = &shader_injection.custom_chromatic_aberration,
        .default_value = 100.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tooltip = "Controls color fringing effect.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxVignette",
        .binding = &shader_injection.custom_vignette,
        .default_value = 100.f,
        .label = "Vignette",
        .section = "Effects",
        .tooltip = "Controls vignette effect.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxSharpening",
        .binding = &shader_injection.custom_sharpening,
        .default_value = 100.f,
        .label = "Sharpening",
        .section = "Effects",
        .tooltip = "Controls the strength of the vanilla sharpening filter.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_film_grain,
        .default_value = 0.f,
        .label = "Film Grain",
        .section = "Effects",
        .tooltip = "Controls new perceptual film grain. Reduces banding.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxVideoITM",
        .binding = &shader_injection.custom_video_itm,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1,
        .label = "Video AutoHDR",
        .section = "Effects",
        .tooltip = "Inverse tone maps prerendered video. Subtle = 2x game brightness, Strong = peak brightness.",
        .labels = {"Off", "Subtle", "Strong"},
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE > 0; },
        .parse = [](float value) { return value; },
    },
    //     new renodx::utils::settings::Setting{
    //     .key = "ColorGradeLutScaling",
    //     .binding = &CUSTOM_LUT_SCALING,
    //     .default_value = 100.f,
    //     .label = "LUT Scaling",
    //     .section = "Color Grading",
    //     .tooltip = "Scales the black/white point of the grading to use the full range.",
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1; },
    // },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::Launch(
              "https://discord.gg/QgXDCfccRy");
        },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More RenoDX Mods",
        .section = "Links",
        .group = "button-line-3",
        .on_change = []() {
          renodx::utils::platform::Launch(
              "https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-3",
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Donate (Ko-fi)",
        .section = "Links",
        .group = "button-line-3",
        .on_change = []() {
          renodx::utils::platform::Launch("https://ko-fi.com/kickfister");
        },
    },
};  // namespace

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapWhiteClip", 100.f);
  renodx::utils::settings::UpdateSetting("ToneMapHDRBoost", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
  renodx::utils::settings::UpdateSetting("FxChromaticAberration", 100.f);
  renodx::utils::settings::UpdateSetting("FxVignette", 100.f);
  renodx::utils::settings::UpdateSetting("FxSharpening", 100.f);
  renodx::utils::settings::UpdateSetting("FxFilmGrain", 0.f);
}

//bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  //if (fired_on_init_swapchain) return;
  //last_is_hdr = renodx::utils::swapchain::IsHDRColorSpace(swapchain);
  //fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Darksiders Warmastered";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::swapchain::use_resource_cloning = true;
      //renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      //renodx::mods::swapchain::swapchain_proxy_compatibility_mode = true;

      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      //renodx::mods::swapchain::force_borderless = true;
      renodx::mods::swapchain::prevent_full_screen = true;

      //renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      //renodx::mods::shader::allow_multiple_push_constants = true;
      //renodx::mods::shader::force_pipeline_cloning = true;
      //renodx::mods::shader::use_pipeline_layout_cloning = true;
      
      renodx::mods::swapchain::SetUseHDR10();

      renodx::utils::random::binds.push_back(&shader_injection.custom_random);  // film grain

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          //.dimensions = {.width=renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER, .height=renodx::utils::resource::ResourceUpgradeInfo::ANY},
          //.aspect_ratio = -1,
      });
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          //.dimensions = {.width=renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER, .height=renodx::utils::resource::ResourceUpgradeInfo::ANY},
          //.aspect_ratio = -1,
      });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::utils::random::Use(fdw_reason);

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  
  //renodx::mods::swapchain::Use(fdw_reason);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
