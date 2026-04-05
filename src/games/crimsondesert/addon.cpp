/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0


#include <embed/shaders.h>

#include <atomic>
#include <mutex>
#include <d3d12.h>
#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "../../utils/random.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

bool last_is_hdr = false;
float hdr_settings_toggle = 0.f;

bool debug = false;

// VRS is always disabled — forces full resolution 1x1 shading rate
// Decomp breaks shaders that use VRS so we hardcode to avoid issues 
// with missing or transparent shaders like foliage

float disable_vrs = 1.f;

// --- VRS override via pre-draw injection ---
// The game uses Tier 2 VRS (per primitive via SV_ShadingRate in vertex shaders),
// not per-draw RSSetShadingRate calls. To disable VRS we must inject
// RSSetShadingRate(1X1, {OVERRIDE, OVERRIDE}) before each draw, which tells
// the hardware to ignore the per primitive and per tile shading rates.

using PFN_RSSetShadingRate = void(STDMETHODCALLTYPE*)(
    ID3D12GraphicsCommandList5*, D3D12_SHADING_RATE, const D3D12_SHADING_RATE_COMBINER*);

// 0 = not yet checked, 1 = resolved (may still be null if unsupported), -1 = unsupported
static std::atomic<int> vrs_resolve_state{0};
static std::atomic<PFN_RSSetShadingRate> native_rs_set_shading_rate{nullptr};
static std::mutex vrs_resolve_mutex;

// Pre draw hook: inject RSSetShadingRate(1X1, {OVERRIDE, OVERRIDE}) to disable per primitive VRS
static void OnVRSPreDraw(reshade::api::command_list* cmd_list) {
  if (cmd_list->get_device()->get_api() != reshade::api::device_api::d3d12) return;
  if (disable_vrs == 0.f) return;

  // Fast path: already determined VRS is unsupported on this GPU
  int state = vrs_resolve_state.load(std::memory_order_relaxed);
  if (state == -1) return;

  auto* native_cmd_list = reinterpret_cast<IUnknown*>(cmd_list->get_native());
  if (native_cmd_list == nullptr) return;

  ID3D12GraphicsCommandList5* cmd_list5 = nullptr;
  HRESULT hr = native_cmd_list->QueryInterface(__uuidof(ID3D12GraphicsCommandList5), reinterpret_cast<void**>(&cmd_list5));
  if (FAILED(hr) || cmd_list5 == nullptr) return;

  // Resolve the vtable function pointer once (double-checked lock)
  auto resolved = native_rs_set_shading_rate.load(std::memory_order_relaxed);
  if (resolved == nullptr && state == 0) {
    const std::lock_guard lock(vrs_resolve_mutex);
    resolved = native_rs_set_shading_rate.load(std::memory_order_relaxed);
    if (resolved == nullptr && vrs_resolve_state.load(std::memory_order_relaxed) == 0) {
      // Check VRS Tier 2 support before resolving — AMD exposes the interface
      // but calling RSSetShadingRate without Tier 2 causes DXGI_ERROR_DEVICE_HUNG
      ID3D12Device* device = nullptr;
      hr = cmd_list5->GetDevice(__uuidof(ID3D12Device), reinterpret_cast<void**>(&device));
      if (SUCCEEDED(hr) && device != nullptr) {
        D3D12_FEATURE_DATA_D3D12_OPTIONS6 options6 = {};
        hr = device->CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS6, &options6, sizeof(options6));
        device->Release();

        if (SUCCEEDED(hr) && options6.VariableShadingRateTier >= D3D12_VARIABLE_SHADING_RATE_TIER_2) {
          void** vtable = *reinterpret_cast<void***>(cmd_list5);
          resolved = reinterpret_cast<PFN_RSSetShadingRate>(vtable[77]);
          if (resolved != nullptr) {
            native_rs_set_shading_rate.store(resolved, std::memory_order_relaxed);
            vrs_resolve_state.store(1, std::memory_order_relaxed);
            reshade::log::message(reshade::log::level::info, "VRS: Resolved native RSSetShadingRate function pointer for pre-draw injection");
          }
        } else {
          reshade::log::message(reshade::log::level::warning, "VRS: GPU does not support VRS Tier 2 — VRS override disabled");
          vrs_resolve_state.store(-1, std::memory_order_relaxed);
        }
      } else {
        reshade::log::message(reshade::log::level::warning, "VRS: Could not get ID3D12Device — VRS override disabled");
        vrs_resolve_state.store(-1, std::memory_order_relaxed);
      }
    }
  }

  if (resolved == nullptr) {
    cmd_list5->Release();
    return;
  }

  D3D12_SHADING_RATE_COMBINER combiners[2] = {
    D3D12_SHADING_RATE_COMBINER_OVERRIDE,  // overrides per-primitive (VS SV_ShadingRate)
    D3D12_SHADING_RATE_COMBINER_OVERRIDE   // overrides per-tile (shading rate image)
  };
  resolved(cmd_list5, D3D12_SHADING_RATE_1X1, combiners);
  cmd_list5->Release();
}

static bool OnVRSDraw(reshade::api::command_list* cmd_list, uint32_t, uint32_t, uint32_t, uint32_t) {
  OnVRSPreDraw(cmd_list);
  return false;  // don't skip the draw
}
static bool OnVRSDrawIndexed(reshade::api::command_list* cmd_list, uint32_t, uint32_t, uint32_t, int32_t, uint32_t) {
  OnVRSPreDraw(cmd_list);
  return false;
}
static bool OnVRSDrawOrDispatchIndirect(reshade::api::command_list* cmd_list, reshade::api::indirect_command, reshade::api::resource, uint64_t, uint32_t, uint32_t) {
  OnVRSPreDraw(cmd_list);
  return false;
}

// Rendering Presets
const std::unordered_map<std::string, float> VANILLA_VALUES = {
    {"LocalLightHueCorrection", 0.f},
    {"LocalLightSaturation", 50.f},

    {"ImprovedAutoExposure", 0.f},
    {"AE_DynamismHigh", 50.f},

    {"DisableAWB", 0.f},

    {"FxFilmGrainType", 0.f},
    {"FxChromaticAberration", 100.f},
    {"FxSharpeningType", 0.f},
    {"FxSharpening", 100.f},
    {"FxLensFlareStrength", 100.f},
    {"BloomStrength", 100.f},
    {"FxVignette", 100.f},


    {"SkyScattering", 0.f},
    {"SunMoonAdjustments", 0.f},
    {"MoonDiskSize", 1.f},
    {"ContactShadowQuality", 0.f},
    {"MaterialImprovements", 0.f},
    {"RaytracingQuality", 0.f},
};

const std::unordered_map<std::string, float> RECOMMENDED_VALUES = {
    {"ImprovedAutoExposure", 1.f},
    //{"AE_DynamismHigh", 45.f},
    {"AE_Speed", 50.f},

    {"DisableAWB", 2.f},

    {"FxFilmGrainType", 1.f},
    {"FxFilmGrain", 10.f},
    {"FxChromaticAberration", 0.f},
    {"FxSharpeningType", 1.f},
    {"FxSharpening", 0.f},
    {"FxLensFlareStrength", 100.f},
    {"BloomStrength", 100.f},
    {"FxVignette", 0.f},

    {"SkyScattering", 1.f},
    {"SunMoonAdjustments", 1.f},
    {"MoonDiskSize", 4.f},
    {"ContactShadowQuality", 1.f},
    {"MaterialImprovements", 1.f},
    {"RaytracingQuality", 0.f},
};

const std::unordered_map<std::string, float> MATCH_SDR_VALUES = {
    {"ColorGradeContrastLow", 70.f},
    {"ColorGradeSaturation", 70.f},
};

const std::unordered_map<std::string, float> NEUTRAL_VALUES = {
    {"ColorGradeContrastLow", 50.f},
    {"ColorGradeSaturation", 50.f},
};

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};
//renodx::mods::shader::CustomShaders custom_shaders;

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

float current_settings_mode = 0;

int crimson = 0xD7263D;
int gold = 0xF2C14E;

// Colors
int tone_mapping = gold;
int advanced_tone_mapping = crimson;
int color_grading = gold;
int local_lighting = crimson;
int auto_exposure = gold;
int effects = crimson;
int rendering = gold;
int wiprendering = crimson;

renodx::utils::settings::Setting* tone_map_peak_nits_setting = nullptr;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "SDRHDRToggle",
        .binding = &hdr_settings_toggle,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Mode",
        .tooltip = "Sets the UI mode. This is automatically set based on the detected color space, but this control is provided in case of errors.",
        .labels = {"SDR","HDR"},
        .is_global = true,
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Recommended",
        .section = "Grading Presets",
        .group = "button-line-1",
        .tooltip = "Default settings, which are our hand-tuned adjustments that we feel look good.",
        .on_change = []() {
          for (auto setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (!setting->section.starts_with("Tone Mapping") && 
            !setting->section.starts_with("Color Grading") && 
            !setting->section.starts_with("Advanced Tone Mapping Properties")) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Purist",
    //     .section = "Grading Presets",
    //     .group = "button-line-1",
    //     .tooltip = "Emulates, but improves, the look of the vanilla SDR tonemapper's saturation and contrast, which the native HDR does not adhere to.",
    //     .on_change = []() {
    //       for (auto setting : settings) {
    //         if (setting->key.empty()) continue;
    //         if (!setting->can_reset) continue;
    //         if (!setting->section.starts_with("Tone Mapping") && 
    //         !setting->section.starts_with("Color Grading") && 
    //         !setting->section.starts_with("Advanced Tone Mapping Properties")) continue;
    //         if (MATCH_SDR_VALUES.contains(setting->key)) {
    //           renodx::utils::settings::UpdateSetting(setting->key, MATCH_SDR_VALUES.at(setting->key));
    //           continue;
    //         }
    //         renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
    //       }
    //     },
    //     //.is_visible = []() { return current_settings_mode >= 1.f; },
    // },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Neutral",
        .section = "Grading Presets",
        .group = "button-line-1",
        .tooltip = "Neutral color and contrast.",
        .on_change = []() {
          for (auto setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (!setting->section.starts_with("Tone Mapping") && 
            !setting->section.starts_with("Color Grading") && 
            !setting->section.starts_with("Advanced Tone Mapping Properties")) continue;
            if (NEUTRAL_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, NEUTRAL_VALUES.at(setting->key));
              continue;
            }
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
      .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
      .packed_values = {0u, CUSTOM_FLAGS__TONE_MAP_TYPE},
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type.\nVanilla uses the unmodified vanilla tone mapper with in-game sliders.\nPsychoV uses our custom psychovisual tone mapping system.",
        .labels = {"Vanilla (ACESv2)","PsychoV-17"},
        .tint = tone_mapping,
        .parse = [](float value) { return value; },
        //.is_visible = []() { return hdr_settings_toggle == 1; },
    },
    tone_map_peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .tint = tone_mapping,
        .min = 80.f,
        .max = 4000.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .is_visible = []() { return hdr_settings_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .can_reset = true,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .tint = tone_mapping,
        .min = 80.f,
        .max = 500.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .is_visible = []() { return hdr_settings_toggle == 1; },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Adjust UI brightness with the in-game slider.\n",
        .section = "Tone Mapping",
        //.tint = tone_mapping,
        .is_visible = []() { return hdr_settings_toggle == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "SDRBlackCrushFix",
      .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
      .packed_values = {0u, CUSTOM_FLAGS__SDR_BLACK_CRUSH_FIX},
        .label = "Black Crush Fix",
        .section = "Tone Mapping",
        .tooltip = "Intended for gamma 2.2 displays, this fixes the gamma mismatch causing black levels to crush.",
        .labels = {"Off", "On"},
        .tint = tone_mapping,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .is_visible = []() { return hdr_settings_toggle == 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueRestore",
        .binding = &shader_injection.tone_map_hue_restore,
        .default_value = 10.f,
        .label = "Hue Restore",
        .section = "Advanced Tone Mapping Properties",
        .tooltip = "Hue retention strength.",
        .tint = advanced_tone_mapping,
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
        new renodx::utils::settings::Setting{
        .key = "ToneMapBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Advanced Tone Mapping Properties",
        .tooltip = "Desaturates the brightest portions of the image, also relative to peak brightness.",
        .tint = advanced_tone_mapping,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
      new renodx::utils::settings::Setting{
        .key = "CustomToneMapMidgrayAdjust",
        .binding = &shader_injection.custom_tone_map_midgray_adjust,
        .default_value = 100.f,
        .label = "Midgray Adjust",
        .section = "Advanced Tone Mapping Properties",
        .tooltip = "Controls mid-gray matching with the SDR tone mapper. 100 = Vanilla, 0 = Neutral.",
        .tint = advanced_tone_mapping,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    //     new renodx::utils::settings::Setting{
    //     .key = "ColorGradeStrength",
    //     .binding = &shader_injection.color_grade_strength,
    //     .default_value = 100.f,
    //     .label = "Pre-Tonemap Grade Strength",
    //     .section = "Advanced Tone Mapping Properties",
    //     .tooltip = "Adjusts how much of the game's dynamic grading applies to the image.",
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 1 && hdr_settings_toggle == 1; },
    // },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .tint = color_grading,
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .tint = color_grading,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 40.f,
        .label = "Shadows",
        .section = "Color Grading",
        .tint = color_grading,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .tint = color_grading,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 65.f,
        .label = "Saturation",
        .section = "Color Grading",
        .tint = color_grading,
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },

    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeConeContrast",
    //     .binding = &shader_injection.tone_map_cone_contrast,
    //     .default_value = 50.f,
    //     .label = "Cone Contrast",
    //     .section = "Color Grading",
    //     .tooltip = "Adds contrast primarily to shadowed regions",
    //     .tint = color_grading,
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
    //     .parse = [](float value) { return value * 0.02f; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Recommended",
        .section = "Graphics Presets",
        .group = "button-line-1",
        //.is_enabled = []() { return shader_injection.last_is_hdr; },
        .tooltip = "Settings built and tested at max settings with Ray Reconstruction. There may be graphical issues with other congfigurations.",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            if (!setting->section.starts_with("Rendering") && 
            !setting->section.starts_with("Local Lighting") && 
            !setting->section.starts_with("Effects") && 
            !setting->section.starts_with("Auto Exposure")) continue;
            if (RECOMMENDED_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, RECOMMENDED_VALUES.at(setting->key));
              continue;
            }
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    //     new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Vanilla",
    //     .section = "Graphics Presets",
    //     .group = "button-line-1",
    //     //.is_enabled = []() { return shader_injection.last_is_hdr; },
    //     .on_change = []() {
    //       for (auto* setting : settings) {
    //         if (setting->key.empty()) continue;
    //         if (!setting->can_reset) continue;
    //         if (setting->is_global) continue;
    //         if (RECOMMENDED_SAFE_VALUES.contains(setting->key)) {
    //           renodx::utils::settings::UpdateSetting(setting->key, RECOMMENDED_SAFE_VALUES.at(setting->key));
    //         }
    //       }
    //     },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Vanilla",
        .section = "Graphics Presets",
        .group = "button-line-1",
        //.is_enabled = []() { return shader_injection.last_is_hdr; },
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            if (!setting->section.starts_with("Rendering") && 
            !setting->section.starts_with("Local Lighting") && 
            !setting->section.starts_with("Effects") && 
            !setting->section.starts_with("Auto Exposure")) continue;
            if (VANILLA_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, VANILLA_VALUES.at(setting->key));
              continue;
            }
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .key = "LocalLightHueCorrection",
        .binding = &shader_injection.local_light_hue_correction,
        .default_value = 25.f,
        .can_reset = true,
        .label = "Flame Hue Correction",
        .section = "Local Lighting",
        .tooltip = "Corrects pink/red flame and torch colors toward warm orange/yellow.\n"
                   "Uses MacLeod-Boynton chromaticity rotation in Stockman-Sharp LMS.\n"
                   "0 = no correction (vanilla pink/red), 100 = full warm fire hue.",
        .tint = local_lighting,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "LocalLightSaturation",
        .binding = &shader_injection.local_light_saturation,
        .default_value = 43.f,
        .can_reset = true,
        .label = "Flame Saturation",
        .section = "Local Lighting",
        .tooltip = "Adjusts saturation of local light sources (fire, torches, braziers).\n"
                   "Controls MacLeod-Boynton purity distance from achromatic axis.\n"
                   "0 = fully desaturated, 50 = unchanged, 100 = maximum saturation.",
        .tint = local_lighting,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = "Alternative Auto Exposure was made with HDR output + max settings + RR in mind (other settings may result in overly dark or blown out scenes). It fixes nuclear highlight issues whilst also making night scenes actually dark\n",
    //     .section = "Auto Exposure",
    //     //.tint = auto_exposure,
    //     .is_visible = []() { return current_settings_mode >= 1.f; },
    // },
    new renodx::utils::settings::Setting{
        .key = "ImprovedAutoExposure",
      .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
      .packed_values = {0u, CUSTOM_FLAGS__IMPROVED_AUTO_EXPOSURE, CUSTOM_FLAGS__IMPROVED_AUTO_EXPOSURE_PERCEPTUAL},
        .can_reset = true,
        .label = "Auto Exposure",
        .section = "Auto Exposure",
        .tooltip = "Enables control over the brightness of dark and bright scenes.\nCustom provides control over dark and bright scene brightness, anchored in vanilla behavior.\nCustom Perceptual uses a more advanced system that attempts to emulate the human eye.",
        .labels = {"Vanilla", "Custom", "Custom Perceptual (Experimental)"},
        .tint = auto_exposure,
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    //     new renodx::utils::settings::Setting{
    //     .key = "AE_DarkPowerOutdoor",
    //     .binding = &shader_injection.ae_dark_power_outdoor,
    //     .default_value = 50.f,
    //     .can_reset = true,
    //     .label = "Low Light Exposure Limit",
    //     .section = "Auto Exposure",
    //     .tooltip = "Adjusts the max exposure value that can be applied, controlling how dark the game is allowed to get.",
    //     .tint = auto_exposure,
    //     .max = 100.f,
    //     .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE > 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 1.f; },
    //     //.is_visible = []() { return debug; },
    // },
            new renodx::utils::settings::Setting{
        .key = "AE_DarkExposureLimit",
        .binding = &shader_injection.ae_dark_exposure_limit,
        .default_value = 50.f,
        .can_reset = true,
        .label = "Low Light Exposure Limit",
        .section = "Auto Exposure",
        .tooltip = "Adjusts the max exposure value that can be applied, controlling how dark the game is allowed to get.",
        .tint = auto_exposure,
        .max = 100.f,
        .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE == 2; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
        //.is_visible = []() { return debug; },
    },
    new renodx::utils::settings::Setting{
        .key = "AE_DynamismHigh",
        .binding = &shader_injection.ae_dynamism_high,
        .default_value = 40.f,
        .can_reset = true,
        .label = "Auto Exposure Darkness",
        .section = "Auto Exposure",
        .tooltip = "Controls brightness level of dark scenes. 50 = neutral",
        .tint = auto_exposure,
        .max = 100.f,
        .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE == 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
        //.is_visible = []() { return debug; },
    },
        new renodx::utils::settings::Setting{
        .key = "AE_DynamismLow",
        .binding = &shader_injection.ae_dynamism_low,
        .default_value = 50.f,
        .can_reset = true,
        .label = "Auto Exposure Brightness",
        .section = "Auto Exposure",
        .tooltip = "Controls brightness level of bright scenes. 50 = neutral",
        .tint = auto_exposure,
        .max = 100.f,
        .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE == 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
        //.is_visible = []() { return debug; },
    },
        new renodx::utils::settings::Setting{
        .key = "AE_Speed",
        .binding = &shader_injection.ae_speed,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Adaptation Speed",
        .section = "Auto Exposure",
        .tooltip = "Controls the speed of auto exposure adaptation. 0 = Vanilla speed",
        .tint = auto_exposure,
        .max = 100.f,
        .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
        //.is_visible = []() { return debug; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "AE_DarkPowerIndoor",
    //     .binding = &shader_injection.ae_dark_power_indoor,
    //     .default_value = 55.f,
    //     .can_reset = true,
    //     .label = "Dark Power (Indoor)",
    //     .section = "Auto Exposure",
    //     .tooltip = "Controls how aggressively auto exposure compensates for dark indoor scenes.\n"
    //                "Lower = less brightening of dark areas.",
    //     .tint = auto_exposure,
    //     .max = 100.f,
    //     .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE > 1; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return debug; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "AE_BrightPowerOutdoor",
    //     .binding = &shader_injection.ae_bright_power_outdoor,
    //     .default_value = 100.f,
    //     .can_reset = true,
    //     .label = "Bright Power (Outdoor)",
    //     .section = "Auto Exposure",
    //     .tooltip = "Controls how aggressively auto exposure compensates for bright outdoor scenes.\n"
    //                "Lower = less dimming of bright areas.",
    //     .tint = auto_exposure,
    //     .max = 150.f,
    //     .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE > 1; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return debug; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "AE_BrightPowerIndoor",
    //     .binding = &shader_injection.ae_bright_power_indoor,
    //     .default_value = 100.f,
    //     .can_reset = true,
    //     .label = "Bright Power (Indoor)",
    //     .section = "Auto Exposure",
    //     .tooltip = "Controls how aggressively auto exposure compensates for bright indoor scenes.\n"
    //                "Lower = less dimming of bright areas.",
    //     .tint = auto_exposure,
    //     .max = 100.f,
    //     .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE > 1; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return debug; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "AE_AdaptSpeedBoost",
    //     .binding = &shader_injection.ae_adapt_speed_boost,
    //     .default_value = 30.f,
    //     .can_reset = true,
    //     .label = "Adaptation Speed Boost",
    //     .section = "Auto Exposure",
    //     .tooltip = "Multiplier for temporal adaptation speed.\n"
    //                "Higher = faster eye adaptation.",
    //     .tint = auto_exposure,
    //     .max = 100.f,
    //     .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE > 1; },
    //     .parse = [](float value) { return value * 0.1f; },
    //     .is_visible = []() { return debug; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "AE_EVBias",
    //     .binding = &shader_injection.ae_ev_bias,
    //     .default_value = -1.f,
    //     .can_reset = true,
    //     .label = "EV Bias",
    //     .section = "Auto Exposure",
    //     .tooltip = "Exposure Value bias applied to the final exposure output.\n"
    //                "Negative = darker, Positive = brighter.",
    //     .tint = auto_exposure,
    //     .min = -4.f,
    //     .max = 4.f,
    //     .format = "%.1f EV",
    //     .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE > 1; },
    //     .is_visible = []() { return debug; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "AE_MinLum",
    //     .binding = &shader_injection.ae_min_lum,
    //     .default_value = 1.f,
    //     .can_reset = true,
    //     .label = "Min Luminance",
    //     .section = "Auto Exposure",
    //     .tooltip = "Minimum luminance clamp (overrides per region/ToD values).\n"
    //                "Slider value is multiplied by 0.001.",
    //     .tint = auto_exposure,
    //     .max = 100.f,
    //     .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE > 1; },
    //     .parse = [](float value) { return value * 0.001f; },
    //     .is_visible = []() { return debug; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "AE_MaxLum",
    //     .binding = &shader_injection.ae_max_lum,
    //     .default_value = 100.f,
    //     .can_reset = true,
    //     .label = "Max Luminance",
    //     .section = "Auto Exposure",
    //     .tooltip = "Maximum luminance clamp (overrides per region/ToD values).\n"
    //                "Slider value is multiplied by 0.1.",
    //     .tint = auto_exposure,
    //     .min = 1.f,
    //     .max = 100.f,
    //     .is_enabled = []() { return IMPROVED_AUTO_EXPOSURE > 1; },
    //     .parse = [](float value) { return value * 0.1f; },
    //     .is_visible = []() { return debug; },
    // },
    new renodx::utils::settings::Setting{
        .key = "DisableAWB",
      .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
      .packed_values = {0u, CUSTOM_FLAGS__DISABLE_AWB, CUSTOM_FLAGS__DISABLE_AWB | CUSTOM_FLAGS__DISABLE_HERO_LIGHTS},
        .can_reset = true,
        .label = "Auto White Balance",
        .section = "Auto Exposure",
        .tooltip = "Controls the game's per channel auto white balance and hero lights.\n"
                   "Vanilla = AWB enabled (can cause hue shifts in HDR).\n"
                   "Disable AWB = AWB disabled, hero/fill lights remain.\n"
                   "Disable AWB + Hero Lights = AWB and hero/fill lights disabled.",
        .labels = {"Vanilla", "Disable AWB", "Disable AWB + Hero Lights"},
        .tint = auto_exposure,
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxFilmGrainType",
          .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
          .packed_values = {0u, CUSTOM_FLAGS__FILM_GRAIN_TYPE},
        .label = "Film Grain Type",
        .section = "Effects",
        .tooltip = "Selects between original or RenoDX film grain",
        .labels = {"Vanilla", "Perceptual"},
        .tint = effects,
        //.is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_film_grain,
        .default_value = 10.f,
        .label = "FilmGrain",
        .section = "Effects",
        .tooltip = "Controls new perceptual film grain. Reduces banding.",
        .tint = effects,
        .max = 100.f,
        .is_enabled = []() { return CUSTOM_FILM_GRAIN_TYPE != 0; },
        .parse = [](float value) { return value * 0.01f; },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
            new renodx::utils::settings::Setting{
        .key = "FxChromaticAberration",
        .binding = &shader_injection.custom_chromatic_aberration,
        .default_value = 0.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tooltip = "Adjusts chromatic aberration strength. 100 = Vanilla",
        .tint = effects,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxVignette",
        .binding = &shader_injection.custom_vignette,
        .default_value = 100.f,
        .label = "Vignette",
        .section = "Effects",
        .tooltip = "Adjusts vignette strength. 100 = Vanilla",
        .tint = effects,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxSharpeningType",
      .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
      .packed_values = {0u, CUSTOM_FLAGS__SHARPENING_TYPE},
        .label = "Sharpening Type",
        .section = "Effects",
        .tooltip = "Selects between original or Lilium's RCAS sharpening",
        .labels = {"Vanilla", "RCAS"},
        .tint = effects,
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxSharpening",
        .binding = &shader_injection.custom_sharpening,
        .default_value = 0.f,
        .label = "Sharpening",
        .section = "Effects",
        .tooltip = "Adjusts sharpening strength. 100 = Vanilla",
        .tint = effects,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "FxLensFlareStrength",
        .binding = &shader_injection.lens_flare_strength,
        .default_value = 100.f,
        .label = "Lens Flare Strength",
        .section = "Effects",
        .tooltip = "Controls the intensity of all lens flare effects. 100 = Vanilla, 0 = Off.",
        .tint = effects,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
        new renodx::utils::settings::Setting{
        .key = "BloomStrength",
        .binding = &shader_injection.bloom_strength,
        .default_value = 100.f,
        .can_reset = true,
        .label = "Bloom Strength",
        .section = "Effects",
        .tooltip = "Controls the overall intensity of the bloom effect.\n"
                   "100 = Vanilla strength, 0 = bloom disabled.",
        .tint = effects,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    //     new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = "This section includes graphical changes to various parts of the game\n",
    //     .section = "Rendering",
    //     //.tint = rendering,
    //     .is_visible = []() { return current_settings_mode >= 1.f; },
    // },

        new renodx::utils::settings::Setting{
        .key = "SkyScattering",
          .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
          .packed_values = {0u, CUSTOM_FLAGS__SKY_SCATTERING},
        .can_reset = true,
        .label = "Spectral Sky Scattering",
        .section = "Rendering",
        .tooltip = "Toggles Spectral rendering atmospheric scattering.\n"
                   "Off = vanilla RGB Rayleigh scattering.\n"
                   "On = Garcia Linan spectral rendering scattering.",
        .labels = {"Off", "On"},
        .tint = rendering,
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "SunMoonAdjustments",
          .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
          .packed_values = {0u, CUSTOM_FLAGS__SUN_MOON_ADJUSTMENTS},
        .can_reset = true,
        .label = "Sun Improvements + Moon Adjustments",
        .section = "Rendering",
        .tooltip = "Improves Sun and applies a 10x brightness reduction to the moon disk.\n"
                   "Off = vanilla (Default shimmery sun blob + moon uses sun scale luminance, clips to white ball).\n"
                   "On = Physically based sun additions + moon luminance reduced to reveal texture detail.",
        .labels = {"Off", "On"},
        .tint = rendering,
    },
        new renodx::utils::settings::Setting{
        .key = "MoonDiskSize",
        .binding = &shader_injection.moon_disk_size,
        .default_value = 4.f,
        .can_reset = true,
        .label = "Moon Disk Size",
        .section = "Rendering",
        .tooltip = "Scales the angular size of the moon disk.\n"
                   "1 = vanilla size. 10 = 10x larger.",
        .tint = rendering,
        .min = 1.f,
        .max = 10.f,
        .format = "%.1fx",
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "WARNING: Requires Ray Reconstruction\n",
        .section = "Rendering",
        .tint = 0xaa0000,
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "ContactShadowQuality",
          .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
          .packed_values = {0u, CUSTOM_FLAGS__CONTACT_SHADOW_QUALITY},
        .can_reset = true,
        .label = "Grass/Foliage Improvements (WIP)",
        .section = "Rendering",
        .tooltip = "Toggles contact shadow changes + transmission + AO.\n"
                   "Off = vanilla foliage.\n"
                   "On = improved foliage/grass shadow detail with tighter depth bias and higher opacity to stop abyss occluder shadows for foliage.\n"
                   "Transmission has been added to simulate diffuse scattering through vegetation / base game was completely uniform.\n"
                   "Added shader side simple AO for foliage since the base game lacks it entirely, causing uniform foliage",
        .labels = {"Off", "On"},
        .tint = rendering,
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "MaterialImprovements",
          .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
          .packed_values = {0u, CUSTOM_FLAGS__MATERIAL_IMPROVEMENTS},
        .can_reset = true,
        .label = "Material Improvements",
        .section = "Rendering",
        .tooltip = "Enables all material/lighting improvements:\n"
                   "• EON 2025 energy-preserving diffuse BRDF\n"
                   "• Callisto smooth terminator (SIGGRAPH 2023)\n"
                   "• Geometric specular anti-aliasing (Tokuyoshi 2021)\n"
                   "• Spectral diffraction on metals (Werner et al. 2024)",
        .labels = {"Off", "On"},
        .tint = rendering,
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "THIS SECTION IS EXTREMELY WIP, ATM IT IS JUST SOME RT TWEAKS WE HAVE BEEN EXPERIMENTING WITH. THERE IS A LOT OF NOISE SO ONLY USABLE FOR SCREENSHOTS\n",
        .section = "WIP Rendering",
        //.tint = rendering,
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
        new renodx::utils::settings::Setting{
        .key = "RaytracingQuality",
          .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
          .packed_values = {0u, CUSTOM_FLAGS__RT_QUALITY_BIT0, CUSTOM_FLAGS__RT_QUALITY_BIT1},
        .can_reset = true,
        .label = "Raytracing Improvements",
        .section = "WIP Rendering",
        .tooltip = "Toggles RenoDX raytracing noise improvements.\n"
                   "Off = vanilla white noise (TEA+MCG) for all RT sampling.\n"
                   "SPMIS = R2 blue noise + Stochastic Pairwise MIS spatial resampling.\n"
                   "Debug Noise = visualizes the raw noise texture sample as colour output.",
        .labels = {"Off", "SPMIS", "Debug Noise"},
        .tint = wiprendering,
        .is_visible = []() { return current_settings_mode >= 1.f; },
        //.is_visible = []() { return debug; },
    },
        new renodx::utils::settings::Setting{
        .key = "ShadowDebugMode",
        .binding = SHADOW_DEBUG_MODE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Shadow Debug View",
        .section = "Debug",
        .tooltip = "Visualizes internal shadow layer data. Replaces the shadow buffer output with a diagnostic color.\n"
                   "Off = normal rendering.\n"
                   "Terrain Shadow = grey: dark=shadowed, white=lit.\n"
                   "Dynamic Cascade = cyan=cascade0, yellow=cascade1, dark-red=not covered.\n"
                   "Static Cascade = green=static0, blue=static1, dark-red=not covered.\n"
                   "Active Layer Map = false-color which cascade layer is active per pixel.\n"
                   "Pre-Contact PCF = combined shadow after cascades/near-field, before contact shadows.\n"
                   "Contact Shadow = dark=occluded by screen-space contact shadow.\n"
                   "Depth Delta = heatmap of depth-behind-shadowmap (bias diagnosis).\n"
                   "Penumbra Channel = raw W-channel (gamma-stretched depth advance).\n"
                   "Stencil ID = false-color by material stencil group.\n"
                   "Cascade Seams = yellow highlight at dynamic cascade UV boundaries.",
        .labels = {"Off", "Terrain Shadow", "Dynamic Cascade", "Static Cascade",
                   "Active Layer Map", "Pre-Contact PCF", "Contact Shadow",
                   "Depth Delta", "Penumbra Channel", "Stencil ID", "Cascade Seams"},
        //.is_visible = []() { return current_settings_mode >= 1.f; },
        .is_visible = []() { return debug; },
    },
        new renodx::utils::settings::Setting{
        .key = "ShadowDisableLayer",
        .binding = SHADOW_DISABLE_LAYER,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = true,
        .label = "Shadow Layer Disable",
        .section = "Debug",
        .tooltip = "Disables a specific shadow layer so you can see its contribution by toggling it off.\n"
                   "None = all layers active (normal rendering).\n"
                   "Terrain Shadow = heightmap PCF.\n"
                   "Dynamic Cascade = character/object cascade shadow maps.\n"
                   "Static Cascade = baked environment cascade shadow maps.\n"
                   "Near-Field Contact = ray-marched near-field contact shadows.\n"
                   "Screen-Space Contact = screen-space contact shadow pass.",
        .labels = {"None", "Terrain Shadow", "Dynamic Cascade", "Static Cascade",
                   "Near-Field Contact", "Screen-Space Contact"},
        //.is_visible = []() { return current_settings_mode >= 1.f; },
        .is_visible = []() { return debug; },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-2",
        .on_change = []() {
          for (auto setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
        //.is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
        .label = "Links",
        .section = "Links",
        .group = "button-line-1",
        .on_draw = []() {
          ImGui::TextLinkOpenURL("RenoDX Discord", "https://discord.gg/QgXDCfccRy");
          ImGui::SameLine();
          ImGui::TextLinkOpenURL("Github", "https://github.com/clshortfuse/renodx");
          ImGui::SameLine();
          ImGui::TextLinkOpenURL("More RenoDX Mods", "https://github.com/clshortfuse/renodx/wiki/Mods/");
          ImGui::SameLine();
          ImGui::TextLinkOpenURL("Forge's Ko-Fi", "https://ko-fi.com/forge87682");
          ImGui::SameLine();
          ImGui::TextLinkOpenURL("Jon's Ko-Fi", "https://ko-fi.com/kickfister");
          ImGui::SameLine();
          ImGui::TextLinkOpenURL("ShortFuse's Ko-Fi", "https://ko-fi.com/shortfuse");
          return false;
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Game mod by Forge, Jon (OopyDoopy/Kickfister), and Shortfuse, RenoDX Framework by Shortfuse",
        .section = "About",
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Credit to Lilium for the RCAS implementation!",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "This build was compiled on " + build_date + " at " + build_time + ".",
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 203.f},
      {"SDRBlackCrushFix", 0.f},

      {"ToneMapHueRestore", 10.f},
      {"ToneMapBlowout", 0.f},
      {"ColorGradeStrength", 100.f},

      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeContrastLow", 50.f},
      {"ColorGradeContrastHigh", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeAdaptationContrast", 50.f},
      {"ColorGradeConeContrast", 50.f},

      {"FxFilmGrainType", 0.f},
      {"FxFilmGrain", 50.f},
      {"FxChromaticAberration", 100.f},
      {"FxLensFlareStrength", 100.f},
      {"FxSharpeningType", 0.f},
      {"FxSharpening", 100.f},
      {"FxVignette", 100.f},

      {"BloomQuality", 0.f},
      {"BloomStrength", 100.f},

      {"LocalLightHueCorrection", 0.f},
      {"LocalLightSaturation", 50.f},

      {"SkyScattering", 0.f},
      {"SunMoonAdjustments", 0.f},
      {"MoonDiskSize", 1.f},
      {"ContactShadowQuality", 0.f},
      {"RaytracingQuality", 0.f},
      {"MaterialImprovements", 0.f},
      {"DisableAWB", 0.f},

      {"ImprovedAutoExposure", 0.f},
      {"AE_Dynamism", 40.f},
      {"AE_Speed", 0.f},
  });
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  last_is_hdr = renodx::utils::swapchain::IsHDRColorSpace(swapchain);

  hdr_settings_toggle = last_is_hdr ? 1.f : 0.f;
  renodx::utils::settings::UpdateSetting("SDRHDRToggle", hdr_settings_toggle);

  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    tone_map_peak_nits_setting->default_value = roundf(peak.value());
  } else {
    tone_map_peak_nits_setting->default_value = 1000.f;
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
//extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for AV Approved Game Name (CD)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      // while (IsDebuggerPresent() == 0) Sleep(100);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      // Register VRS override hooks BEFORE mods::shader registers its draw hooks,
      // so our pre draw injection fires first
      reshade::register_event<reshade::addon_event::draw>(OnVRSDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnVRSDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnVRSDrawOrDispatchIndirect);

      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;

      renodx::utils::random::binds.push_back(&shader_injection.custom_random);  // film grain

      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::force_pipeline_cloning = true;

      

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::draw>(OnVRSDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnVRSDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(OnVRSDrawOrDispatchIndirect);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::random::Use(fdw_reason);

  if (fdw_reason == DLL_PROCESS_DETACH) {
    reshade::unregister_addon(h_module);
  }

  return TRUE;
}