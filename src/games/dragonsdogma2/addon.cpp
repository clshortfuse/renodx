/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0


#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "../../utils/random.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;


renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

float current_settings_mode = 0;
float is_preset_off = 0;


// const std::unordered_map<std::string, float> HDR_LOOK_VALUES = {
//    // {"ToneMapType", 3.f},
//     {"SceneGradeMethod", 1.f},
//     {"SceneGradeHueShift", 50.f},
//     {"SceneGradeHueCorrection", 50.f},
//     {"SceneGradeSaturationCorrection", 75.f},
//     {"SceneGradeBlowoutRestoration", 80.f},
//     {"ColorGradeExposure", 1.12f},
//     {"ColorGradeHighlights", 52.f},
//     {"ColorGradeShadows", 57.f},
//     {"ColorGradeContrast", 55.f},
//     {"ColorGradeSaturation", 56.f},
//     {"ColorGradeHighlightSaturation", 50.f},
//     {"ColorGradeBlowout", 43.f},
//     {"ColorGradeFlare", 58.f},
//    // {"SwapChainCustomColorSpace", 0.f},
//     //{"LutGradeStrength", 100.f},
//    // {"TonemapGradeStrength", 100.f},
//     //{"FxFilmGrain", 0.f},
//     //{"FxPostProcessingMaxCLL", 40.f},
//     {"FxBloom", 33.f},
//     //{"FxLensDirt", 50.f},
//     {"FxSunShaftStrength", 50.f},
// };


renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Advanced"},
        .is_global = true,
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = "By default, this mod improves the game's tone mapping and uses the in-game calibration sliders.\nSwitch to Advanced mode to access more options.\n ",
    //     .section = "Instructions",
    //     .is_visible = []() { return current_settings_mode == 0.f;}
    // },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Warning: Preset Off does not work.",
        .tint = 0xFF0000,
        .is_visible = []() { return is_preset_off == 1.f;}
    },
    //     new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = "Warning: Must use Vanilla+ for all color grading to be present.",
    //     //.section = "Instructions",
    //     .is_visible = []() { return RENODX_TONE_MAP_TYPE > 0.f;}
    // },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type.\nVanilla+ uses the vanilla tone mapping with improved brightness scaling, unlocked luminance, and improved display mapping.\nRenoDX ACES replaces the game's tone mapper with our ACES implementation.",
        .labels = {"Vanilla+","RenoDX ACES"},
        .parse = [](float value) { return value; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 80.f,
        .max = 4000.f,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 100.f,
        .can_reset = true,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 80.f,
        .max = 500.f,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 100.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 80.f,
        .max = 500.f,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &RENODX_GAMMA_CORRECTION,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "SDR EOTF Emulation",
        .section = "Tone Mapping",
        .tooltip = "Emulates the look of the game when viewed with SDR gamma.",
        .labels = {"Off", "2.2", "2.2 Hue Preserving"},
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "SceneGradeSaturationCorrection",
        .binding = &shader_injection.scene_grade_saturation_correction,
        .default_value = 0.f,
        .label = "Saturation Correction",
        .section = "Advanced Tone Mapping Properties",
        .tooltip = "Correction for saturation adjustments caused by per channel tone mapping. Also restores highlight detail.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "SceneGradeBlowoutRestoration",
        .binding = &shader_injection.scene_grade_blowout_restoration,
        .default_value = 70.f,
        .label = "Blowout Restoration",
        .section = "Advanced Tone Mapping Properties",
        .tooltip = "Restores details in blown-out highlights.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoHueRestore",
        .binding = &shader_injection.psycho_hue_restore,
        .default_value = 10.f,
        .label = "Hue Restore",
        .section = "Advanced Tone Mapping Properties",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
        new renodx::utils::settings::Setting{
        .key = "PsychoBleach",
        .binding = &shader_injection.psycho_bleach,
        .default_value = 0.f,
        .label = "Bleaching",
        .section = "Advanced Tone Mapping Properties",
        //.tooltip = "Adds highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 0; },
        .parse = [](float value) { return fmax(value * 0.01f, 0.000001f); },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 2; },
        .is_visible = []() { return current_settings_mode >= 1.f && RENODX_TONE_MAP_TYPE < 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1 && RENODX_TONE_MAP_TYPE < 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f && RENODX_TONE_MAP_TYPE < 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f && RENODX_TONE_MAP_TYPE < 2; },
    },
        new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        //.tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1 && RENODX_TONE_MAP_TYPE < 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f && RENODX_TONE_MAP_TYPE < 2; },
    },
        new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Adds highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 2; },
        .parse = [](float value) { return fmax(0.0001f, value * 0.01f); },
        .is_visible = []() { return current_settings_mode >= 1 && RENODX_TONE_MAP_TYPE < 2; },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE < 2; },
        .parse = [](float value) { return value * 0.001f; },
        .is_visible = []() { return current_settings_mode >= 1 && RENODX_TONE_MAP_TYPE < 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoExposure",
        .binding = &shader_injection.psycho_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 2; },
        .is_visible = []() { return current_settings_mode >= 1.f && RENODX_TONE_MAP_TYPE == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoHighlights",
        .binding = &shader_injection.psycho_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1 && RENODX_TONE_MAP_TYPE == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoShadows",
        .binding = &shader_injection.psycho_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f && RENODX_TONE_MAP_TYPE == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoContrast",
        .binding = &shader_injection.psycho_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f && RENODX_TONE_MAP_TYPE == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoPurity",
        .binding = &shader_injection.psycho_purity,
        .default_value = 50.f,
        .label = "Purity",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f && RENODX_TONE_MAP_TYPE == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoAdaptationContrast",
        .binding = &shader_injection.psycho_adaptation_contrast,
        .default_value = 50.f,
        .label = "Adaptation Contrast",
        .section = "Color Grading",
        //.tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 2; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1 && RENODX_TONE_MAP_TYPE == 2; },
    },
    //     new renodx::utils::settings::Setting{
    //     .key = "PsychoConeResponse",
    //     .binding = &shader_injection.psycho_cone_response,
    //     .default_value = 50.f,
    //     .label = "Cone Response",
    //     .section = "Color Grading",
    //     //.tooltip = "Adds or removes highlight color.",
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 2; },
    //     .parse = [](float value) { return value * 0.02f; },
    //     .is_visible = []() { return current_settings_mode >= 1 && RENODX_TONE_MAP_TYPE == 2; },
    // },
            new renodx::utils::settings::Setting{
        .key = "FxFilmGrainType",
        .binding = &shader_injection.custom_film_grain_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Film Grain Type",
        .section = "Effects",
        .tooltip = "Selects between original or RenoDX film grain",
        .labels = {"Vanilla", "Perceptual"},
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_film_grain,
        .default_value = 50.f,
        .label = "FilmGrain",
        .section = "Effects",
        .tooltip = "Controls new perceptual film grain. Reduces banding.",
        .max = 100.f,
        .is_enabled = []() { return CUSTOM_FILM_GRAIN_TYPE != 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxVignette",
        .binding = &shader_injection.custom_vignette,
        .default_value = 100.f,
        .label = "Vignette",
        .section = "Effects",
        .tooltip = "Adjusts vignette strength.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-2",
        .on_change = []() {
          for (auto setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Vanilla+",
    //     .section = "Presets",
    //     .group = "button-line-1",
    //     .on_change = []() {
    //       for (auto* setting : settings) {
    //         if (setting->key.empty()) continue;
    //         if (!setting->can_reset) continue;
    //         if (setting->is_global) continue;
    //         renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
    //       }
    //     },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::Launch("https://discord.gg/QgXDCfccRy");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx");
        },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More RenoDX Mods",
        .section = "Links",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx/wiki/Mods/");
        },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Jon's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/kickfister");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Game mod by Jon (OopyDoopy/Kickfister), RenoDX Framework by Shortfuse",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "This build was compiled on " + build_date + " at " + build_time + ".",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .key = "IsPresetOff",
        .binding = &is_preset_off,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .is_visible = []() { return false; },
    }
};

void OnPresetOff() {
//   renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
//   renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 1000.f);
//   renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
//   renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
//   renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
//   renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
//   renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
//   renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
//   renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
//   renodx::utils::settings::UpdateSetting("ColorGradeAdaptiveContrast", 50.f);
//   renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
//   renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
//   //renodx::utils::settings::UpdateSetting("SwapChainCustomColorSpace", 0.f);
//   renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);
//   renodx::utils::settings::UpdateSetting("FxFilmGrainType", 0.f);
//   renodx::utils::settings::UpdateSetting("FxFilmGrain", 50.f);
//   renodx::utils::settings::UpdateSetting("FxVignette", 100.f);
  renodx::utils::settings::UpdateSetting("IsPresetOff", 1.f);
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[3]->default_value = roundf(peak.value());
  } else {
    settings[3]->default_value = 1000.f;
  }

  //settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Dragon's Dogma 2";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
            reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      // while (IsDebuggerPresent() == 0) Sleep(100);

      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;

      renodx::utils::random::binds.push_back(&shader_injection.custom_random);  // film grain

      //renodx::mods::shader::revert_constant_buffer_ranges = true;

      // renodx::mods::swapchain::use_resource_cloning = true;
      // renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      // renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      // renodx::mods::swapchain::swapchain_proxy_revert_state = true;

      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::force_pipeline_cloning = true;
      // renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
      //     return static_cast<bool>(params.size() < 20);
      // };
      //renodx::mods::shader::use_pipeline_layout_cloning = true;
      //renodx::mods::swapchain::use_resource_cloning = true;

      //renodx::utils::shader::use_replace_async = true; 

      // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //     .old_format = reshade::api::format::r8g8b8a8_typeless,
      //     .new_format = reshade::api::format::r16g16b16a16_float,
      // });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::random::Use(fdw_reason);

  return TRUE;
}
