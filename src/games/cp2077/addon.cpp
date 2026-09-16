/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <deps/imgui/imgui.h>

#include "./cp2077.h"

#include <embed/shaders.h>

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xCBFFC2A3),  // output
    CustomShaderEntry(0x341CEB87),  // upscale
    CustomShaderEntry(0x298A6BB0),  // composite multisample
    CustomShaderEntry(0xBF8489D2),  // composite multisample lowbit
    CustomShaderEntry(0x5DF649A9),  // composite
    CustomShaderEntry(0xA61F2FEE),  // composite lowbit
    CustomShaderEntry(0x71F27445),  // tonemapper
    CustomShaderEntry(0x61DBBA5C),  // tonemapper sdr
    CustomShaderEntry(0x97CA5A85),  // tonemapper lowbit
    CustomShaderEntry(0x745E34E1),  // tonemapper sdr lowbit
    CustomShaderEntry(0xC783FBA1),  // film grain overlay
    CustomShaderEntry(0xCE7EB8C7),  // flim grain overlay v23
    CustomShaderEntry(0xC83E64DF),  // hud
    CustomShaderEntry(0x11C9D257),  // hud_221
    CustomShaderEntry(0x066EBCF7),  // hud v23
    CustomShaderEntry(0xDE517511),  // menu
    CustomShaderEntry(0x89C4A7A4),  // new_menu
    CustomShaderEntry(0x18CFEFF4),  // new_menu_renderless
    CustomShaderEntry(0xFDE6BBAC),  // menu_221_no_render
    CustomShaderEntry(0xD46D9215),  // menu_221
    CustomShaderEntry(0x3BF1C870),  // menu v23
    CustomShaderEntry(0xFBFF99B4),  // new_hud
    CustomShaderEntry(0x80CEFAE4),  // film_grain_new
    CustomShaderEntry(0xE87F9B2E),  // film_grain_221
    CustomShaderEntry(0x21C2AF18),  // composite2
    CustomShaderEntry(0xA8520658),  // composite2_array_multisample
    CustomShaderEntry(0x04D8EA44),  // composite2_array_multisample_blend_rtv1
    CustomShaderEntry(0x4A2023A1),  // composite2_blend_rtv1
    CustomShaderEntry(0x4E63FBE2),  // composite2_multisample
    CustomShaderEntry(0xED7139C7),  // composite2_multisample_blend_rtv1
};

ShaderInjectData shader_injection;

constexpr float FALLBACK_PEAK_NITS = 1000.f;
float peak_nits_default = FALLBACK_PEAK_NITS;
bool peak_nits_default_initialized = false;
bool swapchain_seen = false;
bool swapchain_is_hdr = false;
renodx::utils::settings::Setting* tone_map_peak_nits_setting = nullptr;

inline bool IsPsychoVSelected() {
  return shader_injection.toneMapType == TONE_MAPPER_TYPE__PSYCHOV17
         || shader_injection.toneMapType == TONE_MAPPER_TYPE__PSYCHOV22
         || shader_injection.toneMapType == TONE_MAPPER_TYPE__PSYCHOV30;
}

inline bool IsRenoDRTSelected() {
  return shader_injection.toneMapType == TONE_MAPPER_TYPE__RENODX;
}

inline bool IsDetectedSDRSwapchain() {
  return swapchain_seen && !swapchain_is_hdr;
}

renodx::utils::settings::Settings settings = {
    tone_map_peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = FALLBACK_PEAK_NITS,
        .label = "Peak Brightness",
        .section = "Output",
        .tooltip = "Sets the value of peak white in nits."
                   "\nDefault: detected display peak nits (1000 nits fallback)",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return !IsDetectedSDRSwapchain(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Output",
        .tooltip = "Sets the value of 100% white in nits."
                   "\nDefault: 203 nits",
        .min = 48.f,
        .max = 1000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Output",
        .tooltip = "Emulates output decoding used on SDR displays.",
        .labels = {"Off", "UI/Menu Only", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 4.f,
        .label = "Tone Mapper",
        .section = "Grading",
        .tooltip = "Sets the tone mapper type.",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT", "PsychoV-17", "PsychoV-22", "PsychoV-30"},
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Grading",
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 4.f,
        .label = "Hue Correction",
        .section = "Grading",
        .tooltip = "Applies hue shift emulation before tonemapping",
        .labels = {"None", "Reinhard", "ACES BT709", "ACES AP1", "Filmic"},
        .is_visible = []() { return !IsPsychoVSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.toneMapHueProcessor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Hue Processor",
        .section = "Grading",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp"},
        .is_visible = []() { return !IsPsychoVSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeConeResponse",
        .binding = &shader_injection.colorGradeConeResponse,
        .default_value = 50.f,
        .label = "Cone Response",
        .section = "Grading",
        .tooltip = "Controls the PsychoV cone response shaping.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return IsPsychoVSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPsychoVExposureMatch",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FLAGS__PSYCHOV_EXPOSURE_MATCH},
        .label = "Exposure Match",
        .section = "Grading",
        .tooltip = "Matches PsychoV's 18% gray anchor to CP2077's neutral HDR ACES/ODT output.",
        .labels = {"Off", "On"},
        .is_visible = []() { return IsPsychoVSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPsychoVVanillaHDRSlope",
        .binding = &shader_injection.fx_vanilla_hdr_slope,
        .default_value = 100.f,
        .label = "Vanilla HDR Slope",
        .section = "Grading",
        .tooltip = "Blends PsychoV cone response from native to CP2077's neutral HDR ACES/ODT slope.",
        .max = 100.f,
        .is_enabled = []() { return IsPsychoVSelected() && !IsDetectedSDRSwapchain(); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPerChannel",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Per Channel",
        .section = "Grading",
        .tooltip = "Applies tonemapping per-channel instead of by luminance",
        .labels = {"Off", "On"},
        .is_visible = []() { return IsRenoDRTSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.colorGradeHighlightSaturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return IsRenoDRTSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Grading",
        .tooltip = "Controls RenoDRT highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return IsRenoDRTSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return IsRenoDRTSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeWhitePoint",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {CUSTOM_FLAGS__WHITE_POINT_D60, 0u, CUSTOM_FLAGS__WHITE_POINT_D65},
        .label = "White Point",
        .section = "Grading",
        .tooltip = "Selects whether to force the game's whitepoint",
        .labels = {"D60", "Vanilla", "D65"},
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SceneGradingStrength",
        .binding = &shader_injection.sceneGradingStrength,
        .default_value = 50.f,
        .label = "Scene Grading Strength",
        .section = "Grading",
        .tooltip = "Selects the strength of the game's custom scene grading.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxDynamicExposure",
        .binding = &shader_injection.fx_dynamic_exposure,
        .default_value = 0.f,
        .label = "Dynamic Exposure",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxVignette",
        .binding = &shader_injection.fxVignette,
        .default_value = 50.f,
        .label = "Vignette",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainType",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FLAGS__FILM_GRAIN_PERCEPTUAL},
        .label = "Film Grain Type",
        .section = "Effects",
        .labels = {"Vanilla", "Perceptual"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.fx_film_grain_strength,
        .default_value = 50.f,
        .label = "Film Grain Strength",
        .section = "Effects",
        .tooltip = "Adjusts the film grain strength",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ProcessingLUTScaling",
        .binding = &shader_injection.processingLUTScaling,
        .default_value = 100.f,
        .label = "LUT Correction",
        .section = "Processing",
        .tooltip = "Blends the graphic LUT correction with the vanilla LUT.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ProcessingLUTCorrectionMethod",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FLAGS__LUT_CORRECTION_MIDGRAY},
        .label = "LUT Correction Method",
        .section = "Processing",
        .tooltip = "Selects endpoint-based LUT recovery or output-midgray neutral slope extension with N2 reconstruction derived from each LUT's measured output peak.",
        .labels = {"Edge Recovery", "Midgray Slope Extend"},
        .is_enabled = []() { return shader_injection.processingLUTScaling > 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ProcessingLUTBlackFloor",
        .binding = &shader_injection.processing_lut_black_floor,
        .default_value = 100.f,
        .label = "LUT Black Floor",
        .section = "Processing",
        .tooltip = "Removes the modeled LUT black-floor lift around output midgray while retaining the sampled shadow/toe residual.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.processingLUTScaling > 0.f
                                    && renodx::utils::bitwise::HasFlag(shader_injection.custom_flags, CUSTOM_FLAGS__LUT_CORRECTION_MIDGRAY); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ProcessingLUTCeiling",
        .binding = &shader_injection.processing_lut_ceiling,
        .default_value = 100.f,
        .label = "LUT Ceiling",
        .section = "Processing",
        .tooltip = "Controls inverse N2 max-channel reconstruction from each LUT's measured linear output peak. Low-ceiling LUTs receive more expansion; high-headroom LUTs receive less.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.processingLUTScaling > 0.f
                                    && renodx::utils::bitwise::HasFlag(shader_injection.custom_flags, CUSTOM_FLAGS__LUT_CORRECTION_MIDGRAY); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ProcessingLUTOrder",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {CUSTOM_FLAGS__LUT_ORDER_BEFORE, 0u, CUSTOM_FLAGS__LUT_ORDER_AFTER},
        .label = "LUT Order",
        .section = "Processing",
        .tooltip = "Selects whether to force when color grading LUTs are applied.",
        .labels = {"Before Tone Map", "Vanilla", "After Tone Map"},
    },
    new renodx::utils::settings::Setting{
        .key = "ProcessingInternalSamplingEncoding",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FLAGS__SAMPLING_ENCODE_PQ},
        .label = "Internal Sampling Encoding",
        .section = "Processing",
        .tooltip = "Selects whether to use the vanilla sampling or PQ for the game's internal rendering LUT.",
        .labels = {"Vanilla", "PQ"},
    },
    new renodx::utils::settings::Setting{
        .key = "ProcessingInternalSamplingDecoding",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FLAGS__SAMPLING_DECODE_PQ},
        .label = "Internal Sampling Decoding",
        .section = "Processing",
        .tooltip = "Selects whether to use the vanilla sampling or PQ for the game's internal rendering LUT.",
        .labels = {"Vanilla", "PQ"},
    },
    new renodx::utils::settings::Setting{
        .key = "DebugGraph",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .packed_values = {0u, CUSTOM_FLAGS__DEBUG_GRAPH},
        .label = "Debug Graph",
        .section = "Debug",
        .tooltip = "Selects whether to draw the debug graph.",
        .labels = {"Off", "On"},
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
        .label = "SDR Look",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
                            {"ToneMapGammaCorrection", 2.f},
                            {"ToneMapPsychoVVanillaHDRSlope", 0.f},
          }); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    // new renodx::utils::settings::Setting{
    //     .key = "DebugDrawGraph",
    //     .binding = &shader_injection.debugDrawGraph,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Draw Graph",
    //     .section = "Debug",
    //     .tooltip = "Draws graph showing how input/output process",
    //     .labels = {"Off", "On"},
    // },
};

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool /*resize*/) {
  if (swapchain == nullptr) return;

  swapchain_seen = true;
  swapchain_is_hdr = renodx::utils::swapchain::IsHDRColorSpace(swapchain);

  if (peak_nits_default_initialized) return;
  peak_nits_default_initialized = true;
  peak_nits_default = renodx::utils::swapchain::GetPeakNits(swapchain).value_or(FALLBACK_PEAK_NITS);

  const bool was_using_default = tone_map_peak_nits_setting->GetValue() == tone_map_peak_nits_setting->default_value;
  tone_map_peak_nits_setting->default_value = peak_nits_default;
  if (was_using_default) tone_map_peak_nits_setting->Set(peak_nits_default)->Write();
}

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", peak_nits_default},
      {"ToneMapGameNits", 203.f},
      {"ToneMapGammaCorrection", 0.f},
      {"ToneMapHueCorrection", 0.f},
      {"ToneMapHueProcessor", 1.f},
      {"ToneMapPerChannel", 0.f},
      {"ToneMapPsychoVExposureMatch", 1.f},
      {"ToneMapPsychoVVanillaHDRSlope", 100.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeConeResponse", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeWhitePoint", 1.f},
      {"ColorGradeLUTStrength", 100.f},
      {"SceneGradingStrength", 50.f},
      {"FxDynamicExposure", 0.f},
      {"FxBloom", 50.f},
      {"FxVignette", 50.f},
      {"FxFilmGrainType", 0.f},
      {"FxFilmGrain", 50.f},
      {"ProcessingLUTScaling", 0.f},
      {"ProcessingLUTCorrectionMethod", 0.f},
      {"ProcessingLUTBlackFloor", 100.f},
      {"ProcessingLUTCeiling", 100.f},
      {"ProcessingLUTOrder", 1.f},
      {"ProcessingInternalSamplingEncoding", 0.f},
      {"ProcessingInternalSamplingDecoding", 0.f},
      {"DebugGraph", 0.f},
  });
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::expected_constant_buffer_index = 14;
      renodx::mods::shader::use_root_signature_cbv = true;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
