/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#define NOMINMAX

#include <chrono>
#include <random>


#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"


namespace {

ShaderInjectData shader_injection;

/*int executed_shader_count = 0;  // Counter for executed post-process shaders

bool UpdateTonemappedState(reshade::api::command_list* cmd_list) {
  ++executed_shader_count;

  // Value updates before shader is run,
  // so set `isTonemapped` to 1.f only after the second shader is found
  if (executed_shader_count >= 2) {
    IS_TONEMAPPED = 1.f;
  }
  return true;  // Allow the shader to execute
}

void ResetShaderCount() {
  executed_shader_count = 0;            // Reset the counter
  IS_TONEMAPPED = 0.f;  // Reset tonemapped state
}*/

float sunshaft_check = 0.f;
//int sunshaft_count = 0;

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xB9D8E2E6),  // book
    CustomShaderEntry(0x2C4D7C55),  // exposure
    CustomShaderEntry(0x476C8032),  // gamma
    CustomShaderEntry(0xC3A894A3),  // video
    CustomShaderEntry(0x53C984D4),  // subtitles
    CustomShaderEntry(0xD45FAC70),  // sunrays2
    //CustomShaderEntry(0xD50CABBC),  // bloom
    //CustomShaderEntry(0xF7BE1DE7),  // sunrays1
    CustomShaderEntryCallback(0x35D82084, [](reshade::api::command_list* cmd_list) {  // sunrays3
    sunshaft_check += 1.f;
    shader_injection.custom_sunshaft_count += 1.f;
    return true;
    }),
    CustomShaderEntry(0x8B7E874F),  // ui
    //UpgradeRTVShader(0x880A17D3),
    //UpgradeRTVReplaceShader(0x476C8032),
    //------LoS2------//
    CustomShaderEntry(0xC39D4062),  // videos
    CustomShaderEntry(0xEF036E36),  // subtitles
    CustomShaderEntry(0x0BBBF840),  // tonemap
    CustomShaderEntry(0x3DC8491D),  // tonemap
    CustomShaderEntry(0x8EFA952B),  // tonemap
    CustomShaderEntry(0x09E1F794),  // tonemap
    CustomShaderEntry(0x86DAD59B),  // tonemap
    CustomShaderEntry(0xB9E4C979),  // tonemap
    CustomShaderEntry(0xC9D34264),  // tonemap
    CustomShaderEntry(0x0E1E3B4D),  // sharpen
    CustomShaderEntry(0x450587EA),  // gamma
};



const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

const std::unordered_map<std::string, float> HDR_LOOK_VALUES = {
    {"ToneMapHueProcessor", 1.f},
    {"ColorGradeHighlights", 60.f},
    {"ColorGradeContrast", 50.f},
    {"ColorGradeSaturation", 80.f},
    {"ColorGradeHighlightSaturation", 45.f},
    {"ColorGradeBlowout", 75.f},
    {"ColorGradeFlare", 60.f},
    {"FxCustomExposure", 75.f},
    {"ToneMapWhiteClip", 20.f},
    {"FxSunRayIntensity", 100.f},
};

const std::unordered_map<std::string, float> CANNOT_PRESET_VALUES = {
    {"ToneMapPeakNits", 0},
    {"ToneMapGameNits", 0},
    {"ToneMapUINits", 0},
    {"GammaCorrection", 0},
    {"FxFilmGrainStrength", 0},
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &RENODX_TONE_MAP_TYPE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
        .parse = [](float value) { return value; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &RENODX_PEAK_WHITE_NITS,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
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
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &RENODX_TONE_MAP_HUE_PROCESSOR,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp"},
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &RENODX_TONE_MAP_HUE_SHIFT,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &RENODX_TONE_MAP_WORKING_COLOR_SPACE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &RENODX_TONE_MAP_HUE_CORRECTION,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &RENODX_GAMMA_CORRECTION,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &RENODX_TONE_MAP_PER_CHANNEL,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWhiteClip",
        .binding = &shader_injection.tone_map_white_clip,
        .default_value = 10.f,
        .label = "White Clip",
        .section = "Tone Mapping",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &RENODX_TONE_MAP_EXPOSURE,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &RENODX_TONE_MAP_HIGHLIGHTS,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
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
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Color Grading",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US CRT",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainStrength",
        .binding = &CUSTOM_FILM_GRAIN_STRENGTH,
        .default_value = 30.f,
        .label = "Film Grain Strength",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxCustomExposure",
        .binding = &CUSTOM_EXPOSURE,
        .default_value = 50.f,
        .label = "Auto Exposure Strength",
        .section = "Effects",
        .tooltip = "Adjust the exposure level",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "FxVignette",
    //     .binding = &CUSTOM_VIGNETTE,
    //     .default_value = 50.f,
    //     .label = "Vignette",
    //     .section = "Effects",
    //     .tooltip = "Adjust the intensity of vignetting in the corners.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.02f; },
    // },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &CUSTOM_BLOOM,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .tooltip = "Adjust the intensity of bloom.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxSunRayIntensity",
        .binding = &CUSTOM_SUN_RAY_INTENSITY,
        .default_value = 50.f,
        .label = "Sun Ray Intensity",
        .section = "Effects",
        .tooltip = "Adjust the intensity of Sun Rays.",
        .max = 200.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxSunRayLength",
        .binding = &CUSTOM_SUN_RAY_LENGTH,
        .default_value = 100.f,
        .label = "Sun Ray Length",
        .section = "Effects",
        .tooltip = "Adjust the length of Sun Rays. 100 is full screen.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "FxDOF",
    //     .binding = &CUSTOM_DOF,
    //     .default_value = 100.f,
    //     .label = "Depth of Field",
    //     .section = "Effects",
    //     .tooltip = "Adjust the intensity of Depth of Field.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Look",
        .section = "Presets",
        .group = "button-line-1",
        .tint = 0x2f4858,
        .on_change = []() {
            for (auto* setting : settings) {
              if (setting->key.empty()) continue;
              if (!setting->can_reset) continue;
              if (setting->is_global) continue;
              if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
              if (HDR_LOOK_VALUES.contains(setting->key)) {
                renodx::utils::settings::UpdateSetting(setting->key, HDR_LOOK_VALUES.at(setting->key));
              } else {
                renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
              }
            }
            renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
          },
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Experimental",
    //     .section = "Presets",
    //     .group = "button-line-1",
    //     .tint = 0x2f4858,
    //     .on_change = []() {
    //       for (auto* setting : settings) {
    //         if (setting->key.empty()) continue;
    //         if (!setting->can_reset) continue;
    //         if (setting->is_global) continue;
    //         if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
    //         if (CUSTOM_VALUES.contains(setting->key)) {
    //           renodx::utils::settings::UpdateSetting(setting->key, CUSTOM_VALUES.at(setting->key));
    //         } else {
    //           renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
    //         }
    //       }
    //     },
    // },

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
          renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
        },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Options",
        .group = "button-line-3",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::Launch(
              "https://discord.gg/"
              "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Options",
        .group = "button-line-3",
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = " - IMPORTANT: Game must be in WINDOWED MODE, otherwise some resources fail to upgrade and will clamp the game to SDR!\r\n - Newer dgvoodoo2 versions may break the mod!\r\n - Exercise caution if modifying the dgvoodoo2 configuration file!",
        .section = "Instructions",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Game mod by Jon (OopyDoopy/Kickfister) and Voosh",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "RenoDX framework created by Shortfuse! HDR Analysis made possible by Lilium!",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "This build was compiled on " + build_date + " at " + build_time + ".",
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  // renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 1.f);
  // renodx::utils::settings::UpdateSetting("ToneMapHueShift", 1.f);
  // renodx::utils::settings::UpdateSetting("ToneMapWorkingColorSpace", 1.f);
  // renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 1.f);
  renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);
  // renodx::utils::settings::UpdateSetting("ToneMapScaling", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeShadows", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeContrast", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 1.f);
  // renodx::utils::settings::UpdateSetting("ColorGradeFlare", 1.f);
  renodx::utils::settings::UpdateSetting("FxCustomExposure", 50.f);
  renodx::utils::settings::UpdateSetting("FxSunRayIntensity", 50.f);
  renodx::utils::settings::UpdateSetting("FxSunRayLength", 100.f);
  renodx::utils::settings::UpdateSetting("FxFilmGrainStrength", 0.f);
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

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
    //ResetShaderCount();
    static std::mt19937 random_generator(std::chrono::system_clock::now().time_since_epoch().count());
    static auto random_range = static_cast<float>(std::mt19937::max() - std::mt19937::min());
  CUSTOM_RANDOM = static_cast<float>(random_generator() + std::mt19937::min()) / random_range;
  shader_injection.custom_sunshaft_check = sunshaft_check;
  sunshaft_check = 0.f;
  shader_injection.custom_sunshaft_count = 0.f;
}


}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Castlevania Lords of Shadow 1 & 2";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::force_borderless = true;

      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;


    //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
    //       .old_format = reshade::api::format::r8g8b8a8_typeless,
    //       .new_format = reshade::api::format::r16g16b16a16_float,
    //       .ignore_size = true,
    //       .use_resource_view_cloning = true,
    //       .use_resource_view_hot_swap = true,
    //   });
    //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
    //     .old_format = reshade::api::format::r8g8b8a8_unorm,
    //     .new_format = reshade::api::format::r16g16b16a16_float,
    //     .ignore_size = true,
    //     .use_resource_view_cloning = true,
    //     .use_resource_view_hot_swap = true,
    // });
    // Always upgrade first of format
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .index = 0,
          .ignore_size = true,
          .use_resource_view_cloning = true,
      });
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r8g8b8a8_typeless,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .use_resource_view_cloning = true,
        .aspect_ratio = 16.f / 9.f,
    });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
      });
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r8g8b8a8_unorm,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .index = 0,
        .ignore_size = true,
        .use_resource_view_cloning = true,
    });
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r8g8b8a8_unorm,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .use_resource_view_cloning = true,
        .aspect_ratio = 16.f / 9.f,
    });
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r8g8b8a8_unorm,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .use_resource_view_cloning = true,
        .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
    });
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;

    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
