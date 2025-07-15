/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({
    renodx::templates::settings::CreateDefaultSettings({
        {"ToneMapType", &shader_injection.tone_map_type},
        {"ToneMapPeakNits", &shader_injection.peak_white_nits},
        {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
        {"ToneMapUINits", &shader_injection.graphics_white_nits},
        {"SceneGradeStrength", &shader_injection.scene_grade_strength},
        {"ColorGradeExposure", &shader_injection.tone_map_exposure},
        {"ColorGradeHighlights", &shader_injection.tone_map_highlights},
        {"ColorGradeShadows", &shader_injection.tone_map_shadows},
        {"ColorGradeContrast", &shader_injection.tone_map_contrast},
        {"ColorGradeSaturation", &shader_injection.tone_map_saturation},
        {"ColorGradeHighlightSaturation", &shader_injection.tone_map_highlight_saturation},
        {"ColorGradeBlowout", &shader_injection.tone_map_blowout},
        {"ColorGradeFlare", &shader_injection.tone_map_flare},
        {"FxBloom", &shader_injection.custom_bloom},
        {"FxVignette", &shader_injection.custom_vignette},
    }),

    {
        renodx::templates::settings::CreateSetting({
            .key = "FXFilmGrain",
            .binding = &shader_injection.custom_film_grain,
            .default_value = 50.f,
            .label = "Film Grain",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),

        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Reset All",
            .section = "Options",
            .group = "button-line-1",
            .on_change = []() { renodx::utils::settings::ResetSettings(); },
        },

        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Match",
            .section = "Options",
            .group = "button-line-1",
            .on_change = []() {
              renodx::utils::settings::ResetSettings();
              renodx::utils::settings::UpdateSettings({
                  {"ToneMapGameNits", 250.f},
                  {"ColorGradeExposure", 1.2f},
                  {"ColorGradeHighlights", 60.f},
                  {"ColorGradeSaturation", 55.f},
              });
            },
        },
    },
});

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 250.f},
      {"ToneMapUINits", 325.f},
      {"ToneMapGammaCorrection", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"FxBloom", 50.f},
      {"FxVignette", 50.f},
      {"FXFilmGrain", 50.f},
  });
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Mass Effect : Legendary Edition";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::utils::random::binds.push_back(&shader_injection.custom_random);

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
