/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
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
        {"ToneMapType", {.binding = &shader_injection.tone_map_type}},
        {"ToneMapPeakNits",
         {
             .binding = &shader_injection.peak_white_nits,
             .on_change_value = [](float previous, float current) {
               settings[3]->default_value = renodx::utils::swapchain::ComputeReferenceWhite(current);
             },
         }},
        {"ToneMapGameNits", {.binding = &shader_injection.diffuse_white_nits}},
        {"ToneMapUINits", {.binding = &shader_injection.graphics_white_nits}},
        {"ToneMapGammaCorrection", {.binding = &shader_injection.gamma_correction}},
        {"ColorGradeExposure", {.binding = &shader_injection.tone_map_exposure}},
        {"ColorGradeHighlights", {.binding = &shader_injection.tone_map_highlights}},
        {"ColorGradeShadows", {.binding = &shader_injection.tone_map_shadows}},
        {"ColorGradeContrast", {.binding = &shader_injection.tone_map_contrast}},
        {"ColorGradeSaturation", {.binding = &shader_injection.tone_map_saturation}},
        {"ColorGradeHighlightSaturation", {.binding = &shader_injection.tone_map_highlight_saturation}},
        {"ColorGradeBlowout", {
                                  .binding = &shader_injection.tone_map_blowout,
                                  .default_value = 50.f,
                              }},
        {"ColorGradeFlare", {.binding = &shader_injection.tone_map_flare}},
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
            .key = "ColorGradeLUTSampling",
            .binding = &shader_injection.custom_lut_sampling,
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 1.f,
            .label = "LUT Sampling",
            .section = "Color Grading",
            .labels = {"Trilinear", "Tetrahedral"},
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
            .key = "FxFilmGrain",
            .binding = &shader_injection.custom_film_grain,
            .default_value = 50.f,
            .label = "FilmGrain",
            .section = "Effects",
            .max = 100.f,
            .parse = [](float value) { return value * 0.02f; },
        },
        new renodx::utils::settings::Setting{
            .key = "FxVanillaToneMap",
            .binding = &shader_injection.custom_vanilla_by_luminance,
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 1.f,
            .label = "Vanilla Tone Mapping",
            .section = "Effects",
            .labels = {"Per-Channel", "Luminance"},
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
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Look",
            .section = "Options",
            .group = "button-line-1",
            .on_change = []() {
              renodx::utils::settings::ResetSettings();
              renodx::utils::settings::UpdateSettings({
                  {"ToneMapGameNits", renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->GetValue())},
                  {"ColorGradeShadows", 55.f},
                  {"ColorGradeHighlights", 55.f},
                  {"ColorGradeContrast", 60.f},
                  {"ColorGradeSaturation", 80.f},
                  {"ColorGradeBlowout", 80.f},
                  {"FxBloom", 15.f},
              });
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
      {"ColorGradeLUTStrength", 100.f},
      {"ColorGradeLUTScaling", 0.f},
      {"ColorGradeLUTSampling", 0.f},
      {"FxBloom", 50.f},
      {"FXFilmGrain", 50.f},
      {"FxVanillaToneMap", 0.f},
  });
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Starfield";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      // while (IsDebuggerPresent() == 0) Sleep(100);

      //   renodx::mods::shader::on_create_pipeline_layout = [](reshade::api::device* device, auto params) {
      //     if (device->get_api() != reshade::api::device_api::d3d12) return false;
      //     bool has_tbl = std::ranges::any_of(params, [](auto param) {
      //       return (param.type == reshade::api::pipeline_layout_param_type::descriptor_table);
      //     });
      //     if (!has_tbl) return false;
      //     switch (params.size()) {
      //       case 3:  return true;
      //       case 15: return true;
      //       default:
      //         break;
      //     }
      //     return false;
      //   };

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::expected_constant_buffer_space = 50;

      renodx::utils::random::binds.push_back(&shader_injection.custom_random);

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;

      // Frame Gen
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .usage_include = reshade::api::resource_usage::render_target
                           | reshade::api::resource_usage::copy_dest,
      });

      // RGBA8 Resource Pool and Render
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .aspect_ratio = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
          .usage_include = reshade::api::resource_usage::render_target,
      });

      // Primary render (reduces banding)
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .aspect_ratio = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
          .usage_include = reshade::api::resource_usage::render_target,
      });

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
