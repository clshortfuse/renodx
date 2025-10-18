/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

// ShaderInjectData shader_injection;
// float g_use_shaders = 1.0;           // Controlled by slider
// float g_current_use_shaders = 1.0f;  // Will be overridden on startup

renodx::utils::settings::Settings settings = {
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapPeakNits",
    //     .binding = &shader_injection.peak_white_nits,
    //     .default_value = 1000.f,
    //     .label = "Peak Brightness",
    //     .section = "Tone Mapping",
    //     .tooltip = "Sets the value of peak white in nits",
    //     .min = 48.f,
    //     .max = 4000.f,
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapGameNits",
    //     .binding = &shader_injection.diffuse_white_nits,
    //     .default_value = 203.f,
    //     .label = "Game Brightness",
    //     .section = "Tone Mapping",
    //     .tooltip = "Sets the value of 100% white in nits",
    //     .min = 48.f,
    //     .max = 500.f,
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapUINits",
    //     .binding = &shader_injection.graphics_white_nits,
    //     .default_value = 203.f,
    //     .label = "UI Brightness",
    //     .section = "Tone Mapping",
    //     .tooltip = "Sets the brightness of UI and HUD elements in nits",
    //     .min = 48.f,
    //     .max = 500.f,
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapHueCorrection",
    //     .binding = &shader_injection.tone_map_hue_correction,
    //     .default_value = 25.f,
    //     .label = "Hue Correction",
    //     .section = "Tone Mapping",
    //     .tooltip = "Hue retention strength.",
    //     .min = 0.f,
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapGammaCorrection",
    //     .binding = &shader_injection.gamma_correction,
    //     .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 1.f,
    //     .label = "Gamma Correction",
    //     .section = "Tone Mapping",
    //     .tooltip = "Emulates a 2.2 EOTF",
    //     .labels = {"Off", "2.2"},
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeExposure",
    //     .binding = &shader_injection.tone_map_exposure,
    //     .default_value = 1.f,
    //     .label = "Exposure",
    //     .section = "Color Grading",
    //     .max = 2.f,
    //     .format = "%.2f",
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeHighlights",
    //     .binding = &shader_injection.tone_map_highlights,
    //     .default_value = 50.f,
    //     .label = "Highlights",
    //     .section = "Color Grading",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeShadows",
    //     .binding = &shader_injection.tone_map_shadows,
    //     .default_value = 50.f,
    //     .label = "Shadows",
    //     .section = "Color Grading",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeContrast",
    //     .binding = &shader_injection.tone_map_contrast,
    //     .default_value = 50.f,
    //     .label = "Contrast",
    //     .section = "Color Grading",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeSaturation",
    //     .binding = &shader_injection.tone_map_saturation,
    //     .default_value = 50.f,
    //     .label = "Saturation",
    //     .section = "Color Grading",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeHighlightSaturation",
    //     .binding = &shader_injection.tone_map_highlight_saturation,
    //     .default_value = 50.f,
    //     .label = "Highlight Saturation",
    //     .section = "Color Grading",
    //     .tooltip = "Adds or removes highlight color.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeBlowout",
    //     .binding = &shader_injection.tone_map_blowout,
    //     .default_value = 0.f,
    //     .label = "Blowout",
    //     .section = "Color Grading",
    //     .tooltip = "Controls highlight desaturation due to overexposure.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeFlare",
    //     .binding = &shader_injection.tone_map_flare,
    //     .default_value = 0.f,
    //     .label = "Flare",
    //     .section = "Color Grading",
    //     .tooltip = "Flare/Glare Compensation",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeScene",
    //     .binding = &shader_injection.color_grade_strength,
    //     .default_value = 100.f,
    //     .label = "Scene Grading",
    //     .section = "Color Grading",
    //     .tooltip = "Scene grading as applied by the game",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeSceneScaling",
    //     .binding = &shader_injection.color_grade_scaling,
    //     .default_value = 75.f,
    //     .label = "Scene Grading Scaling",
    //     .section = "Color Grading",
    //     .tooltip = "Scales the scene grading to full range when size is clamped.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeLUTSampling",
    //     .binding = &shader_injection.color_grade_lut_sampling,
    //     .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 1.f,
    //     .label = "Internal LUT Sampling",
    //     .section = "Color Grading",
    //     .labels = {"Trilinear", "Tetrahedral"},
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "FxBloom",
    //     .binding = &shader_injection.custom_bloom,
    //     .default_value = 70.f,
    //     .label = "Bloom",
    //     .section = "Effects",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "FxDithering",
    //     .binding = &shader_injection.custom_dithering,
    //     .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 1.f,
    //     .label = "Dithering",
    //     .section = "Effects",
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "FxSharpening",
    //     .binding = &shader_injection.custom_dithering,
    //     .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 1.f,
    //     .label = "Sharpening",
    //     .section = "Effects",
    // },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Reset All",
    //     .section = "Options",
    //     .group = "button-line-1",
    //     .on_change = []() {
    //       for (auto* setting : settings) {
    //         if (setting->key.empty()) continue;
    //         if (!setting->can_reset) continue;
    //         renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
    //       }
    //     },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "EnableHDRShaders",
    //     .binding = &g_use_shaders,
    //     .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 1.f,
    //     .label = "Enable HDR Mod",
    //     .section = "Options",
    //     .on_change = []() {
    //       g_current_use_shaders = -1;  // Any value that guarantees mismatch on next OnPresent
    //     },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
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
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/musaqh"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Requires HDR on in game"),
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- GAMMA CORRECTION slider controls game brightness (paper white)\n"
                             "- MAX. INTENSITY slider controls peak brightness\n"
                             "- Formula for peak brightness: MAX. INTENSITY slider * paper white / 2\n"
                             "- e.g. MAX.INTENSITY 10.00 and GAMMA CORRECTION 1.00 = 200 nits paper white, 1000 nits peak\n"
                             "+--------+-------------+\n"
                             "| Slider | Paper White |\n"
                             "+--------+-------------+\n"
                             "|  0.80  |     100     |\n"
                             "+--------+-------------+\n"
                             "|  0.82  |     108     |\n"
                             "+--------+-------------+\n"
                             "|  0.85  |     117     |\n"
                             "+--------+-------------+\n"
                             "|  0.88  |     128     |\n"
                             "+--------+-------------+\n"
                             "|  0.90  |     140     |\n"
                             "+--------+-------------+\n"
                             "|  0.93  |     152     |\n"
                             "+--------+-------------+\n"
                             "|  0.95  |     167     |\n"
                             "+--------+-------------+\n"
                             "|  0.97  |     181     |\n"
                             "+--------+-------------+\n"
                             "|  1.00  |     200     |\n"
                             "+--------+-------------+\n"
                             "|  1.02  |     221     |\n"
                             "+--------+-------------+\n"
                             "|  1.05  |     242     |\n"
                             "+--------+-------------+\n"
                             "|  1.07  |     268     |\n"
                             "+--------+-------------+\n"
                             "|  1.10  |     300     |\n"
                             "+--------+-------------+\n"
                             "|  1.12  |     331     |\n"
                             "+--------+-------------+\n"
                             "|  1.15  |     370     |\n"
                             "+--------+-------------+\n"
                             "|  1.18  |     416     |\n"
                             "+--------+-------------+\n"
                             "|  1.20  |     468     |\n"
                             "+--------+-------------+\n"),
        .section = "About",
    },
};

// void OnPresetOff() {
//   renodx::utils::settings::UpdateSettings({
//       {"ToneMapType", 0.f},
//       {"ToneMapPeakNits", 1000.f},
//       {"ToneMapGameNits", 260.f},
//       {"ColorGradeExposure", 1.f},
//       {"ColorGradeHighlights", 50.f},
//       {"ColorGradeShadows", 50.f},
//       {"ColorGradeContrast", 50.f},
//       {"ColorGradeSaturation", 50.f},
//       {"ColorGradeHighlightSaturation", 0.f},
//       {"ColorGradeBlowout", 0.f},
//       {"ColorGradeFlare", 0.f},
//       {"ColorGradeScene", 100.f},
//       {"ColorGradeColorSpace", 0.f},
//       {"FxBloom", 100.f},
//       {"FxBloomScaling", 0.f},
//   });
// }

bool fired_on_init_swapchain = false;

// void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
//   if (fired_on_init_swapchain) return;
//   fired_on_init_swapchain = true;
//   auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
//   if (peak.has_value()) {
//     settings[0]->default_value = peak.value();
//     settings[0]->can_reset = true;
//   }
// }

// void OnPresent(
//     reshade::api::command_queue*,
//     reshade::api::swapchain* swapchain,
//     const reshade::api::rect*,
//     const reshade::api::rect*,
//     uint32_t,
//     const reshade::api::rect*) {
//   if (g_use_shaders != g_current_use_shaders) {
//     reshade::log::message(
//         reshade::log::level::info,
//         (g_use_shaders != 0.f) ? "Enabling shaders (toggle)" : "Disabling shaders (toggle)");

//     auto* device = swapchain->get_device();
//     if (device == nullptr) {
//       reshade::log::message(reshade::log::level::error, "Device is null in OnPresent");
//       return;
//     }

//     if (g_use_shaders != 0.f) {
//       for (const auto& [hash, shader] : custom_shaders) {
//         renodx::utils::shader::AddRuntimeReplacement(device, hash, shader.code);

//         // Log hash to confirm shader replacement
//         reshade::log::message(
//             reshade::log::level::info,
//             ("[RenoDX] Injected shader: " + std::to_string(hash)).c_str());
//       }
//     } else {
//       renodx::utils::shader::RemoveRuntimeReplacements(device);
//       reshade::log::message(reshade::log::level::info, "Removed all shader replacements.");
//     }

//     g_current_use_shaders = (g_use_shaders != 0.f);
//   }
// }

bool initialized = false;

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for HITMAN World of Assassination";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::utils::settings::use_presets = false;

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;  // So overlays dont kill the game
      };

      // reshade::register_event<reshade::addon_event::present>(OnPresent);
      // renodx::utils::shader::use_replace_async = true;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;

#if FORCE_HDR10
        renodx::mods::swapchain::SetUseHDR10();
#endif

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      // reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings);

  // Force OnPresent() to trigger shader logic at startup, regardless of previous state
  // g_current_use_shaders = -1.0f;

  // renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders);

#if FORCE_HDR10
  renodx::mods::swapchain::Use(fdw_reason);
#endif
  return TRUE;
}
