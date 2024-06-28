/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_LEVEL_1
// #define DEBUG_LEVEL_2

#include <embed/0x4D868A70.h>
#include <embed/0x8DAE8683.h>
#include <embed/0x93269875.h>
#include <embed/0x9F3842A8.h>
#include <embed/0xBEB7EB31.h>
#include <embed/0xC3126A03.h>
#include <embed/0xC6FA129B.h>
#include <embed/0xC916AF3F.h>
#include <embed/0xCF3E9D48.h>
#include <embed/0xE3729F07.h>
#include <embed/0xF6E7E494.h>
#include <embed/0xFD6093D2.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
  CustomShaderEntry(0xC3126A03),
  // CustomShaderEntry(0xF6E7E494),
  // CustomShaderEntry(0xC6FA129B),
  // CustomShaderEntry(0x9F3842A8),
  // CustomShaderEntry(0x93269875),
  // CustomShaderEntry(0xE3729F07),
  // CustomShaderEntry(0x8DAE8683),
  // CustomShaderEntry(0x4D868A70),
  // CustomShaderEntry(0xBEB7EB31),
  // CustomShaderEntry(0xC916AF3F),
  // CustomShaderEntry(0xCF3E9D48),
  // CustomShaderEntry(0xFD6093D2)
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
    .labels = {"Vanilla", "None", "ACES", "RenoDX" }
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
    .label = "UI Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the brightness of UI and HUD elements in nits",
    .min = 48.f,
    .max = 500.f
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
    .key = "fxBloom",
    .binding = &shader_injection.fxBloom,
    .default_value = 50.f,
    .label = "Bloom",
    .section = "Effects",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  }
};

// clang-format on

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
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* name = "RenoDX";
extern "C" __declspec(dllexport) const char* description = "RenoDX for Hi-Fi Rush";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      // renodx::mods::shader::trace_unmodified_shaders = true;
      // renodx::mods::shader::allowMultiplePushConstants = true;
      // renodx::mods::shader::expected_constant_buffer_index = 1;
      // renodx::mods::shader::usePipelineLayoutCloning = true;

      // renodx::mods::swapchain::setUseHDR10(true);
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back(
        {//
         .old_format = reshade::api::format::b8g8r8a8_typeless,
         .new_format = reshade::api::format::r16g16b16a16_typeless
        }
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
