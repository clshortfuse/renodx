/*
 * Copyright (C) 2024 Carlos Lopez
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x0F2CC0D1.h>  // video
#include <embed/0x19558629.h>  // UI
#include <embed/0x1CA86895.h>  // UI Popup, team popup in bottom right corner
#include <embed/0x21A11DE7.h>  // UI
#include <embed/0x28213F99.h>  // UI
#include <embed/0x2CA9CD55.h>  // text/UI
#include <embed/0x3C8AF2C9.h>  // Loading Screen Composite
#include <embed/0x46A6A1FE.h>  // Loading Screen
#include <embed/0x4B3388FE.h>  // UI
#include <embed/0x4D248432.h>  // UI
#include <embed/0x69B52EA7.h>  // Images
#include <embed/0x6CF04AC0.h>  // UI
#include <embed/0x7AAE8C2B.h>  // Images
#include <embed/0xA6AB1C75.h>  // text
#include <embed/0xD66588EF.h>  // Loading Screen
#include <embed/0xF2CCBA8C.h>  // UI
#include <embed/0xFEA4E7DB.h>  // Loading Screen
//#include <embed/0x7684FC16.h> // FXAA
#include <embed/0x160805BC.h>  // LUT
#include <embed/0x2C63040A.h>  // LUT
#include <embed/0x3778E664.h>  // TAA
#include <embed/0xAF2731D9.h>  // TAA
//#include <embed/0x73F96489.h> // TAA?
//#include <embed/0xC9C77523.h> // DOF?
//#include <embed/0x283C8F43.h> // DOF?
#include <embed/0xA3C662FB.h>  // Pipboy
#include <embed/0xB38E2BDA.h>  // Quickboy

#include <embed/0x1BDD7570.h>  // Tonemap
#include <embed/0x2A868728.h>  // Tonemap
#include <embed/0x5D002D1E.h>  // Tonemap
#include <embed/0xBF6561E2.h>  // Tonemap
//#include <embed/0x438DFC72.h>

#include <chrono>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
  CustomSwapchainShader(0x2CA9CD55),  // text/UI
  CustomSwapchainShader(0xA6AB1C75),  // text
  CustomSwapchainShader(0xF2CCBA8C),  // UI
  CustomSwapchainShader(0x69B52EA7),  // Images
  CustomSwapchainShader(0x6CF04AC0),  // UI
  CustomSwapchainShader(0x7AAE8C2B),  // Images
  CustomSwapchainShader(0x28213F99),  // UI
  CustomSwapchainShader(0x21A11DE7),  // UI
  CustomSwapchainShader(0x4B3388FE),  // UI
  CustomSwapchainShader(0x4D248432),  // UI
  CustomSwapchainShader(0x19558629),  // UI
  CustomSwapchainShader(0x0F2CC0D1),  // video
  CustomSwapchainShader(0x19558629),  // Loading Screen
  CustomSwapchainShader(0xFEA4E7DB),  // Loading Screen
  CustomSwapchainShader(0xD66588EF),  // Loading Screen
  CustomSwapchainShader(0x3C8AF2C9),  // Loading Screen
  CustomSwapchainShader(0x1CA86895),  // UI Popup, team popup in bottom right corner
  CustomShaderEntry(0x1BDD7570),      // Tonemap
  CustomShaderEntry(0x2A868728),      // Tonemap
  CustomShaderEntry(0x5D002D1E),      // Tonemap
  CustomShaderEntry(0xBF6561E2),      // Tonemap
  CustomShaderEntry(0x2C63040A),      // LUT (Linear)
  CustomShaderEntry(0x160805BC),      // LUT (Gamma)
  CustomShaderEntry(0xA3C662FB),      // Pipboy
  CustomShaderEntry(0xB38E2BDA),      // Quickboy

  //CustomShaderEntry(0x7684FC16),      // FXAA
  CustomShaderEntry(0x3778E664),  // TAA
  CustomShaderEntry(0xAF2731D9),  // TAA
  //CustomShaderEntry(0x438DFC72),      // TAA
  //CustomShaderEntry(0x73F96489),      // TAA?

  //CustomShaderEntry(0xC9C77523),      // DOF?
  //CustomShaderEntry(0x283C8F43),      // DOF?

};

ShaderInjectData shader_injection;

// clang-format off
renodx::utils::user_settings::UserSettings user_settings = {
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapType",
    .binding = &shader_injection.toneMapType,
    .value_type = renodx::utils::user_settings::UserSettingValueType::INTEGER,
    .default_value = 3.f,
    .can_reset = false,
    .label = "Tone Mapper",
    .section = "Tone Mapping",
    .tooltip = "Sets the tone mapper type",
    .labels = {"Vanilla", "None", "ACES", "RenoDRT"}
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapPeakNits",
    .binding = &shader_injection.toneMapPeakNits,
    .default_value = 1000.f,
    .can_reset = false,
    .label = "Peak Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of peak white in nits",
    .min = 48.f,
    .max = 4000.f
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapGameNits",
    .binding = &shader_injection.toneMapGameNits,
    .default_value = 203.f,
    .can_reset = false,
    .label = "Game Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of 100%% white in nits",
    .min = 48.f,
    .max = 500.f
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapUINits",
    .binding = &shader_injection.toneMapUINits,
    .default_value = 203.f,
    .can_reset = false,
    .label = "UI Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the brightness of UI and HUD elements in nits",
    .min = 48.f,
    .max = 500.f
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapGammaCorrection",
    .binding = &shader_injection.toneMapGammaCorrection,
    .value_type = renodx::utils::user_settings::UserSettingValueType::BOOLEAN,
    .can_reset = false,
    .label = "Gamma Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "toneMapHueCorrection",
    .binding = &shader_injection.toneMapHueCorrection,
    .value_type = renodx::utils::user_settings::UserSettingValueType::BOOLEAN,
    .default_value = 1,
    .label = "Hue Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates hue shifting from the vanilla tonemapper",
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeExposure",
    .binding = &shader_injection.colorGradeExposure,
    .default_value = 1.f,
    .label = "Exposure",
    .section = "Color Grading",
    .max = 10.f,
    .format = "%.2f"
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeHighlights",
    .binding = &shader_injection.colorGradeHighlights,
    .default_value = 50.f,
    .label = "Highlights",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeShadows",
    .binding = &shader_injection.colorGradeShadows,
    .default_value = 50.f,
    .label = "Shadows",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeContrast",
    .binding = &shader_injection.colorGradeContrast,
    .default_value = 50.f,
    .label = "Contrast",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeSaturation",
    .binding = &shader_injection.colorGradeSaturation,
    .default_value = 50.f,
    .label = "Saturation",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeBlowout",
    .binding = &shader_injection.colorGradeBlowout,
    .default_value = 82.f,
    .label = "Blowout",
    .section = "Color Grading",
    .tooltip = "Controls highlight desaturation due to overexposure.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  // new renodx::utils::user_settings::UserSetting {
  //   .key = "renoDRTFlare",
  //   .binding = &shader_injection.renoDRTFlare,
  //   .default_value = 0.5f,
  //   .label = "renoDRTFlare",
  //   .section = "Tonemapper Settings",
  //   .max = 1.0f,
  //   .format = "%.4f"
  // },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeLUTStrength",
    .binding = &shader_injection.colorGradeLUTStrength,
    .default_value = 100.f,
    .label = "LUT Strength",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "colorGradeLUTScaling",
    .binding = &shader_injection.colorGradeLUTScaling,
    .default_value = 100.f,
    .label = "LUT Scaling",
    .section = "Color Grading",
    .tooltip = "Scales the color grade LUT to full range when size is clamped.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "fxSceneFilter",
    .binding = &shader_injection.fxSceneFilter,
    .default_value = 50.f,
    .label = "Scene Filter",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "fxFilmGrain",
    .binding = &shader_injection.fxFilmGrain,
    .default_value = 0.f,
    .label = "Film Grain",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
};

// clang-format on

void OnPresetOff() {
  renodx::utils::user_settings::UpdateUserSetting("toneMapType", 0.f);
  renodx::utils::user_settings::UpdateUserSetting("toneMapPeakNits", 203.f);
  renodx::utils::user_settings::UpdateUserSetting("toneMapGameNits", 203.f);
  renodx::utils::user_settings::UpdateUserSetting("toneMapUINits", 203.f);
  renodx::utils::user_settings::UpdateUserSetting("toneMapGammaCorrection", 0);
  renodx::utils::user_settings::UpdateUserSetting("toneMapHueCorrection", 1);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeExposure", 1.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeHighlights", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeShadows", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeContrast", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeSaturation", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeLUTScaling", 0.f);
  renodx::utils::user_settings::UpdateUserSetting("fxSceneFilter", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("fxFilmGrain", 0.f);
}

auto start = std::chrono::steady_clock::now();

void OnPresent(
  reshade::api::command_queue* queue,
  reshade::api::swapchain* swapchain,
  const reshade::api::rect* source_rect,
  const reshade::api::rect* dest_rect,
  uint32_t dirty_rect_count,
  const reshade::api::rect* dirty_rects
) {
  auto end = std::chrono::steady_clock::now();
  shader_injection.elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Fallout 76";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_index = 11;
      renodx::mods::shader::trace_unmodified_shaders = true;
      if (!reshade::register_addon(h_module)) return FALSE;

      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      break;
  }

  renodx::utils::user_settings::Use(fdw_reason, &user_settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
