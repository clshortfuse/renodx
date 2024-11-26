/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/0x4EAF2BC7.h>  // PostFX
#include <embed/0xEEEE53C5.h>  // PostFX - Optics

#include <embed/0xCCC43328.h>  // PostFX - Aiming
#include <embed/0xE93AD74D.h>  // PostFX - Aiming + Optics

#include <embed/0x632ABCB2.h>  // PostFX - Cutscene DoF + Optics
#include <embed/0x9761FB07.h>  // PostFX - Cutscene DoF

#include <embed/0xE033AAAD.h>  // Mini Eye Adaptation

#include <embed/0x56F79BAD.h>  // PQ Encoding

#include "../../mods/shader.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x4EAF2BC7),  // PostFX
    CustomShaderEntry(0xEEEE53C5),  // PostFX - Optics

    CustomShaderEntry(0xCCC43328),  // PostFX - Aiming
    CustomShaderEntry(0xE93AD74D),  // PostFX - Aiming + Optics

    CustomShaderEntry(0x9761FB07),  // PostFX - Cutscene DoF
    CustomShaderEntry(0x632ABCB2),  // PostFX - Cutscene DoF + Optics

    CustomShaderEntry(0xE033AAAD),  // Mini Eye Adaptation

    CustomShaderEntry(0x56F79BAD),  // PQ Encoding
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
        .labels = {"Vanilla", "Vanilla+", "Vanilla+ Boosted"},
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
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Red Dead Redemption";

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