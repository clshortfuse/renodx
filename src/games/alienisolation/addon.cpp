/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x8AFBFA0F.h> // Tonemap
// #include <embed/0x007F7E1C.h> // SMAA
#include <embed/0x043049C7.h> // Video
#include <embed/0xCC0C2DF3.h> // UI - gamma adjust slider notch, line above settings explanations
#include <embed/0x72826F5B.h> // UI - some text
#include <embed/0xD98FBA78.h> // UI - button prompts
#include <embed/0xC38B68F9.h> // UI - most text
#include <embed/0xF1A79FBF.h> // UI - nav elements, pause menu blur
#include <embed/0x335B9229.h> // HUD - health bar 

#include <embed/0xA6B73F9E.h> // UI - digital flashes when searching container, startup video with autodesk logo
#include <embed/0xE7CF0218.h> // UI - transparent element under health bar

// left unchanged, still including so it's marked in devkit
#include <embed/0xF42FA869.h> // UI - red text background when searching container
#include <embed/0xB95A4E01.h> // UI - cxmul red text background when searching container


#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x8AFBFA0F),      // tonemap
    // CustomSwapchainShader(0xB95A4E01),  // Copy
    // CustomShaderEntry(0x007F7E1C),   // SMAA?

    CustomSwapchainShader(0x043049C7),  // Video
    CustomSwapchainShader(0xCC0C2DF3),  // UI - gamma adjust slider notch, line above settings explanations
    CustomSwapchainShader(0x72826F5B),  // UI - some text
    CustomSwapchainShader(0xD98FBA78),  // UI - button prompts
    CustomSwapchainShader(0xF1A79FBF),  // UI - nav elements, pause menu blur
    CustomSwapchainShader(0x335B9229),  // HUD - health bar, interact prompts
    CustomSwapchainShader(0xC38B68F9),  // UI - most text


    CustomSwapchainShader(0xA6B73F9E),  // UI - digital flashes when searching container, startup video with autodesk logo
    CustomSwapchainShader(0xE7CF0218),  // UI - transparent element under health bar

    CustomSwapchainShader(0xF42FA869),  // UI - red text background when searching container, not used
    CustomSwapchainShader(0xB95A4E01),  // UI - cxmul red text background when searching container, not used
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 4.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "Vanilla+ (DICE)"},
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
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100%% white in nits",
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
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 50.f,
        .can_reset = false,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates hue shifting from the vanilla tonemapper",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
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
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
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
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.01f; },
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
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "Film Grain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* name = "RenoDX";
extern "C" __declspec(dllexport) const char* description = "RenoDX for Alien Isolation";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_index = 11;
      renodx::mods::shader::trace_unmodified_shaders = true;
      renodx::mods::swapchain::SetUseHDR10(true);
      
      // renodx::mods::swapchain::force_borderless = false;
      // renodx::mods::swapchain::prevent_full_screen = false;
    //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
    //       .old_format = reshade::api::format::r8g8b8a8_unorm,
    //       .new_format = reshade::api::format::r16g16b16a16_float,
    //   });
    //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
    //       .old_format = reshade::api::format::r8g8b8a8_typeless,
    //       .new_format = reshade::api::format::r16g16b16a16_float,
    //   });
    //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
    //       .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
    //       .new_format = reshade::api::format::r16g16b16a16_float,
    //   });
    //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
    //       .old_format = reshade::api::format::r10g10b10a2_unorm,
    //       .new_format = reshade::api::format::r16g16b16a16_float,
    //   });

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
