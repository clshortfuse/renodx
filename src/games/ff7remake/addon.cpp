/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define NOMINMAX

#include <chrono>
#include <random>
#include <unordered_set>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/path.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x922A71D1),
    CustomShaderEntry(0x4D6F937E),
    CustomShaderEntry(0xD950DA01),
    CustomShaderEntry(0xE87D13A1),
    {0xF68D39B5, {}}  // SDR
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &RENODX_TONE_MAP_TYPE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &RENODX_PEAK_WHITE_NITS,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 80.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &RENODX_DIFFUSE_WHITE_NITS,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 80.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &RENODX_GRAPHICS_WHITE_NITS,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 80.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGammaCorrection",
        .binding = &RENODX_GAMMA_CORRECTION,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"None", "2.2", "2.4/BT.1886"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &RENODX_TONE_MAP_HUE_PROCESSOR,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },

    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrectionMethod",
        .binding = &CUSTOM_HUE_CORRECTION_METHOD,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Correction Method",
        .section = "Tone Mapping",
        .tooltip = "Applies hue shift emulation before tonemapping",
        .labels = {"Default", "ACES AP1", "Filmic", "SDR Grade"},
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },

    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &RENODX_TONE_MAP_HUE_CORRECTION,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue shifts emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.01f; },

    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPerChannel",
        .binding = &RENODX_TONE_MAP_PER_CHANNEL,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Per Channel",
        .section = "Tone Mapping",
        .tooltip = "Applies tonemapping per-channel instead of by luminance",
        .labels = {"Off", "On"},
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &RENODX_TONE_MAP_EXPOSURE,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &RENODX_TONE_MAP_HIGHLIGHTS,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &RENODX_TONE_MAP_SHADOWS,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &RENODX_TONE_MAP_CONTRAST,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &RENODX_TONE_MAP_SATURATION,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE >= 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &RENODX_TONE_MAP_BLOWOUT,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &RENODX_TONE_MAP_FLARE,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeColorSpace",
        .binding = &RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Color Space",
        .section = "Color Grading",
        .tooltip = "Selects grading color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93.",
        .labels = {
            "US Modern",
            "JPN Modern",
        },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTStrength",
        .binding = &CUSTOM_LUT_STRENGTH,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTSampling",
        .binding = &CUSTOM_LUT_TETRAHEDRAL,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "LUT Sampling",
        .section = "Color Grading",
        .labels = {"Trilinear", "Tetrahedral"},
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTExtraction",
        .binding = &CUSTOM_LUT_EXTRACTION,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "LUT Extraction",
        .section = "Color Grading",
        .tooltip = "Selects method for applying original LUT."
                   "\nScale uses the original tonemapping."
                   "\nReconstruct extracts ACES from the LUT.",
        .labels = {"Scale", "Reconstruct"},
    },
    new renodx::utils::settings::Setting{
        .key = "FXBloom",
        .binding = &CUSTOM_BLOOM,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FXVignette",
        .binding = &CUSTOM_VIGNETTE,
        .default_value = 50.f,
        .label = "Vignette",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FXFilmGrain",
        .binding = &CUSTOM_FILM_GRAIN_STRENGTH,
        .default_value = 50.f,
        .label = "Film Grain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FXHDRVideos",
        .binding = &CUSTOM_HDR_VIDEOS,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "HDR Videos",
        .section = "Effects",
        .tooltip = "Uses modified BT.2446a to inverse tonemap SDR videos",
        .labels = {"Off", "BT.2446a", "RenoDRT"},
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          ShellExecute(0, "open", "https://discord.gg/5WZXDpmbpP", 0, 0, SW_SHOW);
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .on_change = []() {
          ShellExecute(0, "open", "https://github.com/clshortfuse/renodx", 0, 0, SW_SHOW);
        },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 1000.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 250.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 250.f);
  renodx::utils::settings::UpdateSetting("ToneMapGammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueCorrectionMethod", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPerChannel", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeFlare", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeColorSpace", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTSampling", 0.f);
  renodx::utils::settings::UpdateSetting("FXBloom", 50.f);
  renodx::utils::settings::UpdateSetting("FXVignette", 50.f);
  renodx::utils::settings::UpdateSetting("FXFilmGrain", 0.f);
  renodx::utils::settings::UpdateSetting("FXHDRVideos", 0.f);
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[1]->default_value = peak.value();
    settings[1]->can_reset = true;
  }
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  static std::mt19937 random_generator(std::chrono::system_clock::now().time_since_epoch().count());
  static auto random_range = static_cast<float>(std::mt19937::max() - std::mt19937::min());
  CUSTOM_RANDOM = static_cast<float>(random_generator() + std::mt19937::min()) / random_range;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Final Fantasy 7 REMAKE INTEGRADE";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  if (fdw_reason == DLL_PROCESS_ATTACH && !reshade::register_addon(h_module)) return FALSE;

  renodx::utils::shader::Use(fdw_reason);
  renodx::utils::swapchain::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };

      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::expected_constant_buffer_space = 50;

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
