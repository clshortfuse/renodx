/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x0C142BB2.h>
#include <embed/0x12200F17.h>
#include <embed/0x2AC7F89E.h>
#include <embed/0x2C2D0899.h>
#include <embed/0x311E0BDA.h>
#include <embed/0x3A4E0B90.h>
#include <embed/0x420BA351.h>
#include <embed/0x45741188.h>
#include <embed/0x5DAD9473.h>
#include <embed/0x7527C8AD.h>
#include <embed/0x8CBD2352.h>
#include <embed/0x8D4B625A.h>
#include <embed/0x8F20CC31.h>
#include <embed/0x931FF3DD.h>
#include <embed/0x93793FBB.h>
#include <embed/0x978BFB09.h>
#include <embed/0xB42A7F40.h>
#include <embed/0xB4B3061C.h>
#include <embed/0xB6B56605.h>
#include <embed/0xBD36EC09.h>
#include <embed/0xC6D12ACD.h>
#include <embed/0xCD1E0E4C.h>
#include <embed/0xD6A846C8.h>
#include <embed/0xDB45CCFE.h>
#include <embed/0xDB56A8CA.h>
#include <embed/0xF01CCC7E.h>
#include <embed/0xF3B4727D.h>
#include <embed/0xFE8B44FC.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomSwapchainShader(0x2C2D0899),  // UI Text and Text Shadow (With alpha)
    CustomSwapchainShader(0x5DAD9473),  // ui
    CustomSwapchainShader(0x311E0BDA),  // ui
    CustomSwapchainShader(0x2AC7F89E),  // ui
    CustomSwapchainShader(0x7527C8AD),  // ui
    CustomSwapchainShader(0xF3B4727D),  // ui
    CustomSwapchainShader(0x8D4B625A),  // ui
    CustomSwapchainShader(0xBD36EC09),  // ui
    CustomSwapchainShader(0x420BA351),  // ui
    CustomSwapchainShader(0xFE8B44FC),  // ui
    CustomSwapchainShader(0xB4B3061C),  // ui
    CustomSwapchainShader(0xDB56A8CA),  // ui
    CustomSwapchainShader(0x45741188),  // ui
    CustomSwapchainShader(0x8CBD2352),  // ui
    CustomSwapchainShader(0xD6A846C8),  // unknown
    CustomSwapchainShader(0x0C142BB2),  // unknown
    CustomSwapchainShader(0x8F20CC31),  // unknown
    CustomSwapchainShader(0x931FF3DD),  // unknown
    CustomSwapchainShader(0x93793FBB),  // unknown
    CustomSwapchainShader(0xC6D12ACD),  // unknown
    CustomSwapchainShader(0xCD1E0E4C),  // unknown video
    CustomSwapchainShader(0xDB45CCFE),  // unknown
    CustomSwapchainShader(0x12200F17),  // video
    CustomShaderEntry(0xB6B56605),      // tonemap
    CustomShaderEntry(0x978BFB09),      // tonemap + motionblur
    CustomShaderEntry(0xF01CCC7E),      // tonemap + fx
    CustomShaderEntry(0x3A4E0B90),      // tonemap + fx + motionblur
    CustomShaderEntry(0xB42A7F40),      // lens flare
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapBlend",
        .binding = &shader_injection.toneMapBlend,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Tonemap Blend",
        .section = "Tone Mapping",
        .tooltip = "Blends the Custom tonemapper with Vanilla",
        .is_enabled = []() { return shader_injection.toneMapType > 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPerChannel",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Per Channel Tonemapping",
        .section = "Tone Mapping",
        .tooltip = "Sets RenoDRT to Tone Map Per Channel to more closely resemble Vanilla",
        .is_enabled = []() { return shader_injection.toneMapType == 3.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 50.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates hue shifting from the vanilla tonemapper",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType > 1.f && shader_injection.toneMapPerChannel == 1.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 10.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxLensFlare",
        .binding = &shader_injection.fxLensFlare,
        .default_value = 50.f,
        .label = "Lens Flare",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxVignette",
        .binding = &shader_injection.fxVignette,
        .default_value = 50.f,
        .label = "Vignette",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrainType",
        .binding = &shader_injection.fxFilmGrainType,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Film Grain Type",
        .section = "Effects",
        .tooltip = "Use the vanilla film grain or perceptual film grain.",
        .labels = {"Vanilla", "Perceptual"},
        .is_enabled = []() { return shader_injection.toneMapType != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "FilmGrain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Neutral+",
        .section = "Color Grading Templates",
        .group = "templates",
        .tooltip = "Powered by RenoDRT",
        .on_change = []() {
            renodx::utils::settings::UpdateSetting("toneMapType", 3.f);
            renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 1.f);
            renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 0.f);
            renodx::utils::settings::UpdateSetting("toneMapBlend", 1.f);
            renodx::utils::settings::UpdateSetting("toneMapPerChannel", 0);
            renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
            renodx::utils::settings::UpdateSetting("colorGradeHighlights", 45.f);
            renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
            renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
            renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
            renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
            renodx::utils::settings::UpdateSetting("colorGradeBlowout", 2.f);
            renodx::utils::settings::UpdateSetting("colorGradeFlare", 0.f);
            renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
            renodx::utils::settings::UpdateSetting("fxLensFlare", 50.f);
            renodx::utils::settings::UpdateSetting("fxVignette", 50.f);
            renodx::utils::settings::UpdateSetting("fxFilmGrainType", 0.f);
            renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Recommended Settings",
        .section = "Color Grading Templates",
        .group = "templates",
        .tooltip = "Powered by RenoDRT",
        .on_change = []() {
            renodx::utils::settings::UpdateSetting("toneMapType", 3.f);
            renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 1);
            renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 0.f);
            renodx::utils::settings::UpdateSetting("toneMapBlend", 0);
            renodx::utils::settings::UpdateSetting("toneMapPerChannel", 0);
            renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
            renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
            renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
            renodx::utils::settings::UpdateSetting("colorGradeContrast", 80.f);
            renodx::utils::settings::UpdateSetting("colorGradeSaturation", 80.f);
            renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
            renodx::utils::settings::UpdateSetting("colorGradeBlowout", 80.f);
            renodx::utils::settings::UpdateSetting("colorGradeFlare", 0.f);
            renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
            renodx::utils::settings::UpdateSetting("fxLensFlare", 50.f);
            renodx::utils::settings::UpdateSetting("fxVignette", 50.f);
            renodx::utils::settings::UpdateSetting("fxFilmGrainType", 1.f);
            renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
        },
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
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-1",
        .on_change = []() {
          ShellExecute(0, "open", "https://github.com/clshortfuse/renodx/wiki/Mods", 0, 0, SW_SHOW);
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
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          ShellExecute(0, "open", "https://ko-fi.com/shortfuse", 0, 0, SW_SHOW);
        },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapBlend", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPerChannel", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeFlare", 0.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxLensFlare", 50.f);
  renodx::utils::settings::UpdateSetting("fxVignette", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrainType", 0.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[1]->default_value = peak.value();
    settings[1]->can_reset = true;
  }
}


}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Batman: Arkham Knight";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::trace_unmodified_shaders = true;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .index = 3,
      });
      
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
