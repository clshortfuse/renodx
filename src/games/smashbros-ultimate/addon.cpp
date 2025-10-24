/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"


namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
  BypassShaderEntry(0x574C469C),
  __ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = renodx::templates::settings::CreateDefaultSettings({
    {"ToneMapType", &shader_injection.tone_map_type},
    {"ToneMapPeakNits", &shader_injection.peak_white_nits},
    {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
    {"ToneMapUINits", &shader_injection.graphics_white_nits},
    {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
    {"ColorGradeExposure", &shader_injection.tone_map_exposure},
    {"ColorGradeHighlights", &shader_injection.tone_map_highlights},
    {"ColorGradeShadows", &shader_injection.tone_map_shadows},
    {"ColorGradeContrast", &shader_injection.tone_map_contrast},
    {"ColorGradeSaturation", &shader_injection.tone_map_saturation},
    {"ColorGradeHighlightSaturation", &shader_injection.tone_map_highlight_saturation},
    {"ColorGradeBlowout", &shader_injection.tone_map_blowout},
    {"ColorGradeFlare", &shader_injection.tone_map_flare},
});

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapGammaCorrection", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
  });
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Smash Bros Ultimate";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::allow_multiple_push_constants = true;
      if (!initialized) {
        renodx::utils::random::binds.push_back(&shader_injection.swap_chain_output_dither_seed);
        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(DLL_PROCESS_ATTACH);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
