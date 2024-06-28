/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x10A3CFDD.h>
#include <embed/0x156045DD.h>
#include <embed/0x231D2C5F.h>
#include <embed/0x496A13D7.h>
#include <embed/0x77E6AD1C.h>
#include <embed/0x7C03A997.h>
#include <embed/0xA4621F49.h>
#include <embed/0xA558B81D.h>
#include <embed/0xE45962D5.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
  CustomShaderEntry(0x231D2C5F),
  CustomShaderEntry(0xA4621F49),
  CustomShaderEntry(0x7C03A997),
  CustomShaderEntry(0x77E6AD1C),
  CustomShaderEntry(0xA558B81D),
  CustomShaderEntry(0xE45962D5),
  CustomShaderEntry(0x156045DD),
  CustomShaderEntry(0x496A13D7),
  CustomShaderEntry(0x10A3CFDD)

};

ShaderInjectData shader_injection;

// clang-format off
renodx::utils::settings::Settings settings = {
  new renodx::utils::settings::Setting {
    .key = "toneMapType",
    .binding = &shader_injection.toneMapType,
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 3.f,
    .can_reset = false,
    .label = "Tone Mapper",
    .section = "Tone Mapping",
    .tooltip = "Sets the tone mapper type",
    .labels = {"Vanilla", "None", "ACES", "RenoDRT"}
  },
  new renodx::utils::settings::Setting {
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
  new renodx::utils::settings::Setting {
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
  new renodx::utils::settings::Setting {
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
  new renodx::utils::settings::Setting {
    .key = "toneMapGammaCorrection",
    .binding = &shader_injection.toneMapGammaCorrection,
    .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    .default_value = 1.f,
    .can_reset = false,
    .label = "Gamma Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
  },
  new renodx::utils::settings::Setting {
    .key = "colorGradeExposure",
    .binding = &shader_injection.colorGradeExposure,
    .default_value = 1.f,
    .label = "Exposure",
    .section = "Color Grading",
    .max = 10.f,
    .format = "%.2f"
  },
  new renodx::utils::settings::Setting {
    .key = "colorGradeHighlights",
    .binding = &shader_injection.colorGradeHighlights,
    .default_value = 50.f,
    .label = "Highlights",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::settings::Setting {
    .key = "colorGradeShadows",
    .binding = &shader_injection.colorGradeShadows,
    .default_value = 50.f,
    .label = "Shadows",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::settings::Setting {
    .key = "colorGradeContrast",
    .binding = &shader_injection.colorGradeContrast,
    .default_value = 50.f,
    .label = "Contrast",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::settings::Setting {
    .key = "colorGradeSaturation",
    .binding = &shader_injection.colorGradeSaturation,
    .default_value = 50.f,
    .label = "Saturation",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::settings::Setting {
    .key = "colorGradeColorFilter",
    .binding = &shader_injection.colorGradeColorFilter,
    .default_value = 100.f,
    .label = "Color Filter",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; }
  },
    new renodx::utils::settings::Setting {
    .key = "fxDoF",
    .binding = &shader_injection.fxDoF,
    .default_value = 50.f,
    .label = "Depth of Field",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::settings::Setting {
    .key = "fxBloom",
    .binding = &shader_injection.fxBloom,
    .default_value = 50.f,
    .label = "Bloom",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::settings::Setting {
    .key = "fxMask",
    .binding = &shader_injection.fxMask,
    .default_value = 50.f,
    .label = "Mask",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::settings::Setting {
    .key = "fxFilmGrain",
    .binding = &shader_injection.fxFilmGrain,
    .default_value = 50.f,
    .label = "Film Grain",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::settings::Setting {
    .key = "fxMotionBlur",
    .binding = &shader_injection.fxMotionBlur,
    .default_value = 50.f,
    .label = "Motion Blur",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new renodx::utils::settings::Setting {
    .key = "fxBlackWhite",
    .binding = &shader_injection.fxBlackWhite,
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 1.f,
    .label = "Black & White",
    .section = "Effects",
    .tooltip = "Method used to apply black and white effect.",
    .labels = {"Vanilla", "By Luminance", "By Chrominance"}
  }
};

// clang-format on

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeColorFilter", 100.f);
  renodx::utils::settings::UpdateSetting("fxDoF", 50.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxMask", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
  renodx::utils::settings::UpdateSetting("fxMotionBlur", 50.f);
  renodx::utils::settings::UpdateSetting("fxBlackWhite", 0.f);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* name = "RenoDX";
extern "C" __declspec(dllexport) const char* description = "RenoDX for LA Noire";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::expected_constant_buffer_index = 11;
      renodx::mods::shader::trace_unmodified_shaders = true;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::prevent_full_screen = false;
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back(
        {reshade::api::format::r8g8b8a8_unorm, reshade::api::format::r16g16b16a16_float}
      );

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
