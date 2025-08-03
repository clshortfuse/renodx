/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
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
        {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
        // {"SceneGradeStrength", &shader_injection.scene_grade_strength},
        {"ColorGradeExposure", &shader_injection.tone_map_exposure},
        {"ColorGradeHighlights", &shader_injection.tone_map_highlights},
        {"ColorGradeShadows", &shader_injection.tone_map_shadows},
        {"ColorGradeContrast", &shader_injection.tone_map_contrast},
        {"ColorGradeSaturation", &shader_injection.tone_map_saturation},
        {"ColorGradeHighlightSaturation", &shader_injection.tone_map_highlight_saturation},
        {"ColorGradeBlowout", &shader_injection.tone_map_blowout},
        {"ColorGradeFlare", &shader_injection.tone_map_flare},
    }),
    {
        new renodx::utils::settings::Setting{
            .key = "ColorGradeLUTStrength",
            .binding = &shader_injection.custom_lut_strength,
            .default_value = 100.f,
            .label = "LUT Strength",
            .section = "Color Grading",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
        },
        new renodx::utils::settings::Setting{
            .key = "ColorGradeLUTScaling",
            .binding = &shader_injection.custom_lut_scaling,
            .default_value = 100.f,
            .label = "LUT Scaling",
            .section = "Color Grading",
            .tooltip = "Scales the color grade LUT to full range when size is clamped.",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
        },
        new renodx::utils::settings::Setting{
            .key = "FxBloom",
            .binding = &shader_injection.custom_bloom,
            .default_value = 50.f,
            .label = "Bloom",
            .section = "Effects",
            .max = 100.f,
            .parse = [](float value) { return value * 0.02f; },
        },
        new renodx::utils::settings::Setting{
            .key = "FxAutoExposure",
            .binding = &shader_injection.custom_autoexposure,
            .default_value = 50.f,
            .label = "Auto Exposure",
            .section = "Effects",
            .max = 100.f,
            .parse = [](float value) { return value * 0.02f; },
        },
        new renodx::utils::settings::Setting{
            .key = "FxSceneFilter",
            .binding = &shader_injection.custom_scene_filter,
            .default_value = 50.f,
            .label = "Scene Filter",
            .section = "Effects",
            .max = 100.f,
            .parse = [](float value) { return value * 0.02f; },
        },
        new renodx::utils::settings::Setting{
            .key = "FxDoF",
            .binding = &shader_injection.custom_dof,
            .default_value = 50.f,
            .label = "Depth of Field",
            .section = "Effects",
            .max = 100.f,
            .parse = [](float value) { return value * 0.02f; },
        },
        new renodx::utils::settings::Setting{
            .key = "FxFilmGrain",
            .binding = &shader_injection.custom_film_grain,
            .default_value = 50.f,
            .label = "Film Grain",
            .section = "Effects",
            .max = 100.f,
            .parse = [](float value) { return value * 0.02f; },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Reset All",
            .section = "Options",
            .group = "button-line-1",
            .on_change = []() {
              for (auto* setting : settings) {
                if (setting->key.empty()) continue;
                if (!setting->can_reset) continue;
                renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
              }
            },
        },
    },
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
      {"FxBloom", 50.f},
      {"FxAutoExposure", 50.f},
      {"FxSceneFilter", 50.f},
      {"FxDoF", 50.f},
      {"FxFilmGrain", 0.f},
  });
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Fallout 4";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::expected_constant_buffer_index = 11;
      renodx::utils::random::binds.push_back(&shader_injection.custom_random);
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
