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
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x0A67EFF4),  // bloom
    CustomShaderEntry(0xA380E737),  // tonemap+scale
    CustomShaderEntry(0xF1FC454C),  // tonemap
    CustomShaderEntry(0xEF7E426D),  // tonemap la
    CustomShaderEntry(0xF3C7B934),  // output
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = renodx::templates::settings::CreateDefaultSettings({
    {"ToneMapType", &shader_injection.tone_map_type},
    {"ToneMapPeakNits", &shader_injection.peak_white_nits},
    {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
    {"ToneMapUINits", &shader_injection.graphics_white_nits},
    {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
    {"ToneMapScaling", &shader_injection.tone_map_per_channel},
    {"ToneMapWorkingColorSpace", &shader_injection.tone_map_working_color_space},
    {"ToneMapHueProcessor", &shader_injection.tone_map_hue_processor},
    {"ToneMapHueCorrection", &shader_injection.tone_map_hue_correction},
    {"ToneMapHueShift", &shader_injection.tone_map_hue_shift},
    {"SceneGradeStrength", &shader_injection.color_grade_strength},
    {"ColorGradeExposure", &shader_injection.tone_map_exposure},
    {"ColorGradeHighlights", &shader_injection.tone_map_highlights},
    {"ColorGradeShadows", &shader_injection.tone_map_shadows},
    {"ColorGradeContrast", &shader_injection.tone_map_contrast},
    {"ColorGradeSaturation", &shader_injection.tone_map_saturation},
    {"ColorGradeHighlightSaturation", &shader_injection.tone_map_highlight_saturation},
    {"ColorGradeBlowout", &shader_injection.tone_map_blowout},
    {"ColorGradeFlare", &shader_injection.tone_map_flare},
    {"FxBloom", &shader_injection.custom_bloom},
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

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Zelda : Echoes of Wisdom";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
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
