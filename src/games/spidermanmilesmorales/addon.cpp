/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/0xB5DBD65C.h>  // Tonemap + Postfx

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xB5DBD65C),  // Tonemap + Postfx
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaAdjustType",
        .binding = &RENODX_GAMMA_ADJUST_TYPE,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Gamma Adjustment Type",
        .section = "Tone Mapper Parameters",
        .tooltip = "Sets the style of Gamma Adjustment, multiplier multiplies the value set by the game by the slider, while fixed overrides it to the value set by the slider",
        .labels = {"Multiplier", "Fixed"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaAdjust",
        .binding = &RENODX_GAMMA_ADJUST_VALUE,
        .default_value = 2.2f,
        .label = "Gamma Adjustment",
        .section = "Tone Mapping",
        .tooltip = "Adjusts gamma",
        .min = 1.f,
        .max = 3.f,
        .format = "%.1f",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Get more RenoDX mods!",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          system("start https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapGammaAdjust", 1.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaAdjustType", 0.f);
}
}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Spider-Man: Miles Morales";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:

    //   renodx::mods::shader::allow_multiple_push_constants = true;
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