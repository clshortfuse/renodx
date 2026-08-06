/*
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64
#define DEBUG_LEVEL_0

#include <atomic>
#include <cmath>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

constexpr float OUTPUT_MODE_AUTO = 0.f;
constexpr float OUTPUT_MODE_SDR = 1.f;
constexpr float OUTPUT_MODE_HDR10 = 2.f;

constexpr float CAS_MODE_VANILLA = 0.f;
constexpr float CAS_MODE_OFF = 1.f;
constexpr float CAS_MODE_RENODX = 2.f;

float ParseToneMapType(float value) {
  if (!std::isfinite(value)) return DETROIT_TONE_MAP_TYPE_RENO_DRT;
  const float rounded = std::round(value);
  if (rounded < DETROIT_TONE_MAP_TYPE_VANILLA
      || rounded > DETROIT_TONE_MAP_TYPE_MAX) {
    return DETROIT_TONE_MAP_TYPE_RENO_DRT;
  }
  return rounded;
}

ShaderInjectData shader_injection;
std::atomic_bool scene_path_seen = false;
std::atomic_bool ui_path_seen = false;

void OnSceneDrawn(reshade::api::command_list*) {
  scene_path_seen.store(true, std::memory_order_relaxed);
}

void OnUiDrawn(reshade::api::command_list*) {
  ui_path_seen.store(true, std::memory_order_relaxed);
}

renodx::mods::shader::CustomShaders custom_shaders = {
    {0xEBFBDDB1, {
                     .crc32 = 0xEBFBDDB1,
                     .code = __0xEBFBDDB1,
                     .on_drawn = &OnSceneDrawn,
                 }},
    {0x2892BFCA, {
                     .crc32 = 0x2892BFCA,
                     .code = __0x2892BFCA,
                     .on_drawn = &OnUiDrawn,
                 }},
    {0x8808E4CC, {
                     .crc32 = 0x8808E4CC,
                     .code = __0x8808E4CC,
                     .on_drawn = &OnUiDrawn,
                 }},
    {0x9827B559, {
                     .crc32 = 0x9827B559,
                     .code = __0x9827B559,
                     .on_drawn = &OnUiDrawn,
                 }},
    CustomShaderEntry(0x94F97DCF),
};

renodx::utils::settings::Settings settings =
    renodx::templates::settings::JoinSettings({
        renodx::templates::settings::CreateDefaultSettings({
            {"ToneMapType",
             {
                 .binding = &shader_injection.tone_map_type,
                 .default_value = DETROIT_TONE_MAP_TYPE_RENO_DRT,
                 .tooltip = "AgX, ACES Fitted, Lottes, Hable and PBR Neutral are adapted to Detroit's scene-linear HDR range. PsychoV-22 matches the selected Cyberpunk 2077 RenoDX operator.",
                 .labels = {
                     "Vanilla",
                     "Reinhard",
                     "RenoDRT",
                     "AgX (HDR Adapted)",
                     "ACES Fitted (HDR Adapted)",
                     "Lottes (HDR Adapted)",
                     "Hable / Uncharted 2 (HDR Adapted)",
                     "Khronos PBR Neutral (HDR Adapted)",
                     "PsychoV-22 (Cyberpunk 2077)",
                     "Detroit DRT",
                 },
                 .parse = &ParseToneMapType,
             }},
            {"ToneMapPeakNits", {
                                    .binding = &shader_injection.peak_white_nits,
                                    .default_value = 1000.f,
                                    .can_reset = false,
                                }},
            {"ToneMapGameNits", {
                                    .binding = &shader_injection.diffuse_white_nits,
                                    .default_value = 203.f,
                                }},
            {"ToneMapUINits", {
                                  .binding = &shader_injection.graphics_white_nits,
                                  .default_value = 203.f,
                                  .is_visible = []() {
                                    return shader_injection.ui_path_active != 0.f;
                                  },
                              }},
            {"ColorGradeExposure", {.binding = &shader_injection.tone_map_exposure}},
            {"ColorGradeHighlights", {.binding = &shader_injection.tone_map_highlights}},
            {"ColorGradeShadows", {.binding = &shader_injection.tone_map_shadows}},
            {"ColorGradeContrast", {.binding = &shader_injection.tone_map_contrast}},
            {"ColorGradeSaturation", {.binding = &shader_injection.tone_map_saturation}},
            {"ColorGradeHighlightSaturation", {.binding = &shader_injection.tone_map_highlight_saturation}},
            {"ColorGradeBlowout", {.binding = &shader_injection.tone_map_blowout}},
            {"ColorGradeFlare", {.binding = &shader_injection.tone_map_flare}},
            {"SceneGradeStrength", {
                                       .binding = &shader_injection.color_grade_strength,
                                       .default_value = 100.f,
                                       .label = "Scene Grading",
                                       .section = "Color Grading",
                                       .tooltip = "Strength of Detroit's original scene color grading.",
                                       .parse = [](float value) { return value * 0.01f; },
                                   }},
        }),
        renodx::templates::settings::CreateSettings({
            {{
                .key = "OutputMode",
                .binding = &shader_injection.output_mode,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = OUTPUT_MODE_AUTO,
                .can_reset = true,
                .label = "Output Mode",
                .section = "Display Output",
                .tooltip = "Auto follows Detroit's native Vulkan swapchain. SDR and HDR10 select the matching shader path but do not switch Windows HDR.",
                .labels = {"Auto", "SDR", "HDR10"},
            }},
            {{
                .key = "CASMode",
                .binding = &shader_injection.cas_mode,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = CAS_MODE_RENODX,
                .can_reset = true,
                .label = "CAS",
                .section = "Sharpening",
                .tooltip = "Vanilla restores Detroit's original 300-nit-clamped CAS for reference. Off disables sharpening; RenoDX Strength keeps HDR headroom.",
                .labels = {"Vanilla", "Off", "RenoDX Strength"},
                .is_visible = []() {
                  return renodx::templates::settings::current_settings_mode >= 1.f;
                },
            }},
            {{
                .key = "CASStrength",
                .binding = &shader_injection.cas_strength,
                .default_value = 100.f,
                .can_reset = true,
                .label = "CAS Strength",
                .section = "Sharpening",
                .tooltip = "HDR-safe CAS sharpening strength.",
                .min = 0.f,
                .max = 100.f,
                .is_enabled = []() { return shader_injection.cas_mode == CAS_MODE_RENODX; },
                .parse = [](float value) { return value * 0.01f; },
                .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 1.f; },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Output Mode cannot enable Windows HDR. Use SDR with Windows HDR off, or HDR10 with Windows HDR on and Auto HDR / RTX HDR off.",
                .section = "Display Output",
                .is_visible = []() {
                  return renodx::templates::settings::current_settings_mode >= 1.f;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Experimental RC for Steam Build 12158144 (Vulkan x64). Late chapters require user validation.",
                .section = "About",
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
                .section = "About",
            }},
        }),
    });

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"OutputMode", OUTPUT_MODE_AUTO},
      {"ToneMapType", DETROIT_TONE_MAP_TYPE_VANILLA},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 300.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"SceneGradeStrength", 100.f},
      {"CASMode", CAS_MODE_VANILLA},
      {"CASStrength", 100.f},
  });
}

void OnPresent(
    reshade::api::command_queue*,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect*,
    const reshade::api::rect*,
    uint32_t,
    const reshade::api::rect*) {
  const auto color_space = swapchain->get_color_space();
  shader_injection.output_is_hdr =
      color_space == reshade::api::color_space::hdr10_st2084
              || color_space == reshade::api::color_space::hdr10_hlg
              || color_space == reshade::api::color_space::extended_srgb_linear
          ? 1.f
          : 0.f;
  shader_injection.scene_path_active =
      scene_path_seen.load(std::memory_order_relaxed) ? 1.f : 0.f;
  shader_injection.ui_path_active =
      ui_path_seen.load(std::memory_order_relaxed) ? 1.f : 0.f;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "RenoDX for Detroit: Become Human (Vulkan, experimental)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::force_pipeline_cloning = true;
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  return TRUE;
}
