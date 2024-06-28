/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x0F2CC0D1.h>
#include <embed/0x13EEBAE5.h>
#include <embed/0x153BE4A2.h>
#include <embed/0x21C1F78D.h>
#include <embed/0x261AE7AB.h>
#include <embed/0x33F1B3F8.h>
#include <embed/0x34AEF9A7.h>
#include <embed/0x43E69DB9.h>
#include <embed/0x4FB4DA20.h>
#include <embed/0x61CC29E6.h>
#include <embed/0x67685D89.h>
#include <embed/0x676B8B5D.h>
#include <embed/0x72826F5B.h>
#include <embed/0x8024E8B5.h>
#include <embed/0x80802E60.h>
#include <embed/0x83660755.h>
#include <embed/0x8CAC3BD9.h>
#include <embed/0x8E032125.h>
#include <embed/0x8F009507.h>
#include <embed/0xB14DB0F4.h>
#include <embed/0xB74B05F4.h>
#include <embed/0xCC4CAE26.h>
#include <embed/0xECFC10A2.h>
#include <embed/0xFEBC673C.h>

#include <chrono>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
  CustomSwapchainShader(0x72826F5B),  // cursor
  CustomSwapchainShader(0x21C1F78D),  // ui compsite
  CustomSwapchainShader(0xB14DB0F4),  // ui boxes
  CustomSwapchainShader(0x0F2CC0D1),  // video
  CustomSwapchainShader(0x8F009507),  // renderselect
  CustomShaderEntry(0x80802E60),      // luts
  // CustomShaderEntry(0xB74B05F4),      // vignette old (unused)
  // BypassShaderEntry(0x48292339),
  CustomShaderEntry(0x8CAC3BD9),  // taa (sdr only)
  CustomShaderEntry(0x61CC29E6),  // taa2 (sdr only)
  CustomShaderEntry(0x8024E8B5),  // tonemap old a
  CustomShaderEntry(0x676B8B5D),  // tonemap old b
  CustomShaderEntry(0x67685D89),  // tonemapper new a
  CustomShaderEntry(0xFEBC673C),  // tonemapper new b
  CustomShaderEntry(0x4FB4DA20),  // fxaa (clamping bt709)
  CustomShaderEntry(0x83660755),
  CustomSwapchainShader(0x13EEBAE5),
  CustomSwapchainShader(0x153BE4A2),
  CustomSwapchainShader(0x261AE7AB),
  CustomSwapchainShader(0x33F1B3F8),
  CustomSwapchainShader(0x34AEF9A7),
  CustomSwapchainShader(0x43E69DB9),
  // CustomSwapchainShader(0x86EC0382),
  CustomSwapchainShader(0x8E032125),
  CustomSwapchainShader(0xCC4CAE26),
  CustomSwapchainShader(0xECFC10A2)

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
    .default_value = 50.f,
    .label = "Blowout",
    .section = "Color Grading",
    .tooltip = "Controls highlight desaturation due to overexposure.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
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
    .key = "fxBloom",
    .binding = &shader_injection.fxBloom,
    .default_value = 50.f,
    .label = "Bloom",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "fxAutoExposure",
    .binding = &shader_injection.fxAutoExposure,
    .default_value = 50.f,
    .label = "Auto Exposure",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
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
    .key = "fxDoF",
    .binding = &shader_injection.fxDoF,
    .default_value = 50.f,
    .label = "Depth of Field",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::user_settings::UserSetting {
    .key = "fxFilmGrain",
    .binding = &shader_injection.fxFilmGrain,
    .default_value = 50.f,
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
  renodx::utils::user_settings::UpdateUserSetting("colorGradeExposure", 1.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeHighlights", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeShadows", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeContrast", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeSaturation", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeBlowout", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::user_settings::UpdateUserSetting("colorGradeLUTScaling", 0.f);
  renodx::utils::user_settings::UpdateUserSetting("fxBloom", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("fxAutoExposure", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("fxSceneFilter", 50.f);
  renodx::utils::user_settings::UpdateUserSetting("fxDoF", 50.f);
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
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Fallout 4";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:

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
