/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <deps/imgui/imgui.h>

#include <embed/0x24182048.h>   // Color Grading - main menu & prologue
#include <embed/0x73E7A34D.h>   // Color Grading - main menu & prologue - sharpening low
#include <embed/0xD7BC63A1.h>   // Color Grading - level 1: Inkwater Marsh

// additional color grading shaders done in batch
#include <embed/0x063548F6.h>
#include <embed/0x0BE6093C.h>
#include <embed/0x0E0EE842.h>
#include <embed/0x1A46FADC.h>
#include <embed/0x1E8FDB7D.h>
#include <embed/0x211F3245.h>
#include <embed/0x28B10677.h>
#include <embed/0x2CEC407A.h>
#include <embed/0x34F7E01C.h>
#include <embed/0x350163E1.h>
#include <embed/0x37E6CB72.h>
#include <embed/0x3F118009.h>
#include <embed/0x3FDCF7AA.h>
#include <embed/0x48CDE62E.h>
#include <embed/0x4A3D4181.h>
#include <embed/0x596B9BD3.h>
#include <embed/0x5B0965E4.h>
#include <embed/0x5CDE4A30.h>
#include <embed/0x613B5403.h>
#include <embed/0x62C79AA3.h>
#include <embed/0x649A0B90.h>
#include <embed/0x7C14BB2C.h>
#include <embed/0x841FAF0A.h>
#include <embed/0x84C7D93E.h>
#include <embed/0x8A303253.h>
#include <embed/0x8B1DE268.h>
#include <embed/0x8D6097D1.h>
#include <embed/0x8D6C34A5.h>
#include <embed/0x8EC5798A.h>
#include <embed/0x9AC0DEEF.h>
#include <embed/0x9B5CC768.h>
#include <embed/0x9DA86DCE.h>
#include <embed/0xA6488EB2.h>
#include <embed/0xABD8D6B7.h>
#include <embed/0xB24C1A54.h>
#include <embed/0xB270CA5B.h>
#include <embed/0xC4128983.h>
#include <embed/0xD9B57ECB.h>
#include <embed/0xDB90C883.h>
#include <embed/0xDE975B11.h>
#include <embed/0xE3F6E54F.h>
#include <embed/0xF017475F.h>
#include <embed/0xF3917C63.h>
#include <embed/0xF7933F3F.h>
#include <embed/0xFCF0717A.h>

#include <embed/0x9D323EA3.h>   // Inverse tonemap, garbage default hdr implementation
#include <embed/0xF9C2BDE1.h>   // DICE, final bt2020 conversion, paper white, and pq encode

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x24182048),   // Color Grading - main menu & prologue
    CustomShaderEntry(0x73E7A34D),   // Color Grading - main menu & prologue - sharpening low
    CustomShaderEntry(0xD7BC63A1),   // Color Grading - level 1

    // additional color grading shaders done in batch
    CustomShaderEntry(0x063548F6),
    CustomShaderEntry(0x0BE6093C),
    CustomShaderEntry(0x0E0EE842),
    CustomShaderEntry(0x1A46FADC),
    CustomShaderEntry(0x1E8FDB7D),
    CustomShaderEntry(0x211F3245),
    CustomShaderEntry(0x28B10677),
    CustomShaderEntry(0x2CEC407A),
    CustomShaderEntry(0x34F7E01C),
    CustomShaderEntry(0x350163E1),
    CustomShaderEntry(0x37E6CB72),
    CustomShaderEntry(0x3F118009),
    CustomShaderEntry(0x3FDCF7AA),
    CustomShaderEntry(0x48CDE62E),
    CustomShaderEntry(0x4A3D4181),
    CustomShaderEntry(0x596B9BD3),
    CustomShaderEntry(0x5B0965E4),
    CustomShaderEntry(0x5CDE4A30),
    CustomShaderEntry(0x613B5403),
    CustomShaderEntry(0x62C79AA3),
    CustomShaderEntry(0x649A0B90),
    CustomShaderEntry(0x7C14BB2C),
    CustomShaderEntry(0x841FAF0A),
    CustomShaderEntry(0x84C7D93E),
    CustomShaderEntry(0x8A303253),
    CustomShaderEntry(0x8B1DE268),
    CustomShaderEntry(0x8D6097D1),
    CustomShaderEntry(0x8D6C34A5),
    CustomShaderEntry(0x8EC5798A),
    CustomShaderEntry(0x9AC0DEEF),
    CustomShaderEntry(0x9B5CC768),
    CustomShaderEntry(0x9DA86DCE),
    CustomShaderEntry(0xA6488EB2),
    CustomShaderEntry(0xABD8D6B7),
    CustomShaderEntry(0xB24C1A54),
    CustomShaderEntry(0xB270CA5B),
    CustomShaderEntry(0xC4128983),
    CustomShaderEntry(0xD9B57ECB),
    CustomShaderEntry(0xDB90C883),
    CustomShaderEntry(0xDE975B11),
    CustomShaderEntry(0xE3F6E54F),
    CustomShaderEntry(0xF017475F),
    CustomShaderEntry(0xF3917C63),
    CustomShaderEntry(0xF7933F3F),
    CustomShaderEntry(0xFCF0717A),

    CustomShaderEntry(0x9D323EA3),  // Inverse tonemap, garbage default hdr implementation
    CustomShaderEntry(0xF9C2BDE1),  // DICE, final bt2020 conversion, paper white, and pq encode
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla (Fake HDR)", "None", "DICE"},
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
        .key = "colorGradeStrength",
        .binding = &shader_injection.colorGradeStrength,
        .default_value = 100.f,
        .label = "Color Grade Strength",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 1000.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeStrength", 100.f);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Ori and the Will of the Wisps";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_index = 11;

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