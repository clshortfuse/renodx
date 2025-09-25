/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "shared.h"

namespace {

#if ENABLE_SLIDERS
ShaderInjectData shader_injection;
#endif

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

renodx::utils::settings::Settings settings = {
#if ENABLE_SLIDERS
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("\nSliders in this section do not apply in real time.\nOpen and close the journal in order to apply changes.\n\n"),
        .section = "Tone Mapping & Color Grading",
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Sets the tone mapper type",
        .labels = {"UE ACES (HDR)", "None", "ACES", "Vanilla+ (ACES + UE Filmic Blend)", "UE Filmic (SDR)"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 2.f || shader_injection.tone_map_type == 3.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "SDR EOTF Emulation",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Emulates a 2.2 EOTF",
        .labels = {"Off", "2.2 (Per Channel)", "2.2 (By Luminance with Per Channel Chrominance)"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Luminance scales colors consistently while per-channel blows out and hue shifts",
        .labels = {"Luminance & Per Channel Blend", "Per Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type == 3.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 0.f,
        .label = "Hue Correction",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Hue retention strength.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "OverrideBlackClip",
        .binding = &shader_injection.override_black_clip,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Override Black Clip",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Outputs 0.0001 nits for black, prevents crushing.",
        .is_enabled = []() { return shader_injection.tone_map_type == 3.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Tone Mapping & Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Tone Mapping & Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Tone Mapping & Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Tone Mapping & Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Tone Mapping & Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTStrength",
        .binding = &shader_injection.custom_lut_strength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Tone Mapping & Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTScaling",
        .binding = &shader_injection.custom_lut_scaling,
        .default_value = 100.f,
        .label = "LUT Scaling",
        .section = "Tone Mapping & Color Grading",
        .tooltip = "Scales the color grade LUT to full range when size is clamped.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
        .parse = [](float value) { return value * 0.01f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "FixPostProcess",
    //     .binding = &shader_injection.fix_post_process,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 2.f,
    //     .label = "Fix Post Process",
    //     .section = "Color Grading",
    //     .tooltip = "Changes the color space post processing shaders are run in",
    //     .labels = {"Off (BT.2020 PQ)", "BT.709 sRGB Piecewise (most accurate)", "BT.2020 sRGB Piecewise (retains WCG)"},
    //     .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    // },
    new renodx::utils::settings::Setting{
        .key = "FxGrainType",
        .binding = &shader_injection.custom_grain_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Grain Type",
        .section = "Effects",
        .tooltip = "Replaces vanilla film grain with perceptual",
        .labels = {"Vanilla", "Perceptual"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxGrainStrength",
        .binding = &shader_injection.custom_grain_strength,
        .default_value = 50.f,
        .label = "Film Grain",
        .section = "Effects",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.custom_grain_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Other",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "UIGammaCorrection",
        .binding = &shader_injection.gamma_correction_ui,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "UI SDR EOTF Emulation",
        .section = "Other",
        .tooltip = "Emulates a 2.2 EOTF for the UI",
        .labels = {"Off", "2.2"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Match SDR",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"ToneMapGammaCorrection", 1.f},
              {"ToneMapScaling", 1.f},
              {"OverrideBlackClip", 0.f},
          });
        },
    },
#endif
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

};

#if ENABLE_SLIDERS
void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 0.f},
      {"toneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapGammaCorrection", 0.f},
      {"UIGammaCorrection", 0.f},
      {"ToneMapHueCorrection", 0.f},
      {"OverrideBlackClip", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeLUTStrength", 0.f},
      {"ColorGradeLUTScaling", 0.f},
      {"FxGrainType", 0.f},
      {"FxGrainStrength", 50.f},
  });
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }
}
#endif

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Silent Hill F";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

#if ENABLE_SLIDERS
      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        return static_cast<bool>(params.size() < 20);
      };

      if (!initialized) {
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::force_pipeline_cloning = true;

        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // detect peak nits

        initialized = true;
      }
      renodx::utils::random::binds.push_back(&shader_injection.custom_random);  // film grain

#else
      renodx::utils::settings::use_presets = false;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        initialized = true;
      }

#endif

      break;
    case DLL_PROCESS_DETACH:

#if ENABLE_SLIDERS
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // detect peak nits
#endif
      reshade::unregister_addon(h_module);
      break;
  }
#if ENABLE_SLIDERS
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::random::Use(fdw_reason);  // film grain
#else
  renodx::utils::settings::Use(fdw_reason, &settings);
  renodx::mods::shader::Use(fdw_reason, custom_shaders);
#endif

  return TRUE;
}