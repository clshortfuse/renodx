/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/0x1F9104F3.h>  // Tonemap + Postfx
#include <embed/0x973A39FC.h>  // Tonemap + Postfx - main

// #include <embed/.h>  // Tonemap + Postfx - Vignette
// #include <embed/.h>  // Tonemap + Postfx - Vignette + Lens Flare

// #include <embed/0xF2F4D148.h>  // Hero Filter
// #include <embed/0xEDBB2630.h>  // Villain Filter

#include <embed/0x6737588D.h>  // BT.2020 + PQ Encoding

#include "../../mods/shader.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x973A39FC),  // Tonemap + Postfx - main
    CustomShaderEntry(0x1F9104F3),  // Tonemap + Postfx
    // CustomShaderEntry(),  // Tonemap + Postfx - Vignette
    // CustomShaderEntry(),  // Tonemap + Postfx - Vignette + Lens Flare
    CustomShaderEntry(0x6737588D),  // BT.2020 + PQ Encoding
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "Vanilla+"},
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlightContrastMultiplier",
        .binding = &shader_injection.colorGradeHighlightContrast,
        .default_value = 50.f,
        .label = "Highlight Contrast",
        .section = "Tone Mapper Parameters",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeToeAdjustmentType",
        .binding = &shader_injection.colorGradeToeAdjustmentType,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Toe Adjustment Type",
        .section = "Tone Mapper Parameters",
        .tooltip = "Sets the style of Toe Adjustment, multiplier multiplies the value set by the game by the slider, while fixed overrides it to the value set by the slider",
        .labels = {"Multiplier", "Fixed"},
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadowToe",
        .binding = &shader_injection.colorGradeShadowToe,
        .default_value = 1.f,
        .label = "Shadow Toe",
        .section = "Tone Mapper Parameters",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
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
        .key = "colorGradeLUTScaling",
        .binding = &shader_injection.colorGradeLUTScaling,
        .default_value = 100.f,
        .label = "LUT Scaling",
        .section = "Color Grading",
        .tooltip = "Scales the color grade LUT to full range when size is clamped.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeGammaAdjust",
        .binding = &shader_injection.colorGradeGammaAdjust,
        .default_value = 1.f,
        .label = "Gamma Adjustment (Hue Preserving)",
        .section = "Color Grading",
        .tooltip = "Adjusts gamma on luminance, only affects luminance values below 1.",
        .min = 0.75f,
        .max = 1.25f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
    },    
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadowToe", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlightContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeGammaAdjust", 1.f);
}
}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Resident Evil 4 Remake";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:

      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;

      if (!reshade::register_addon(h_module)) return FALSE;
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}