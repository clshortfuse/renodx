/*
 * Copyright (C) 2026 Hlib Omelchenko
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

float current_settings_mode = 0;  // 0 = Simple, 1 = Advanced.

bool IsVanillaPlus() { return shader_injection.toneMapType != TONE_MAP_VANILLA; }

bool IsAdvanced() { return current_settings_mode >= 1.f; }

bool SetSwapchainPresentFlag(reshade::api::command_list* cmd_list) {
  shader_injection.fxSwapchainPresent = renodx::utils::swapchain::HasBackBufferRenderTarget(cmd_list) ? 1.f : 0.f;
  return true;
}

bool SetVideoActiveFlag(reshade::api::command_list*) {
  shader_injection.fxVideoActive = 1.f;
  return true;
}

renodx::mods::shader::CustomShaders custom_shaders = {
    // RCAS gate, main 1:1 present rows.
    CustomShaderEntryCallback(0xF5B0DBFA, SetSwapchainPresentFlag),  // main (BT.2020)
    CustomShaderEntryCallback(0xBE69B105, SetSwapchainPresentFlag),  // main lut3d (BT.2020)
    CustomShaderEntryCallback(0x9FCE7944, SetSwapchainPresentFlag),  // main (P3)
    CustomShaderEntryCallback(0x3196D1D2, SetSwapchainPresentFlag),  // main lut3d (P3)
    CustomShaderEntryCallback(0xD0200425, SetSwapchainPresentFlag),  // main (no-matrix)
    CustomShaderEntryCallback(0xFED81CFB, SetSwapchainPresentFlag),  // main lut3d (no-matrix)
    // FMV YUV->RGB decode. No replacement code; the entry only raises fxVideoActive.
    {0x7ED07F45, {.crc32 = 0x7ED07F45, .on_draw = SetVideoActiveFlag}},
    __ALL_CUSTOM_SHADERS};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .tooltip = "Simple hides the advanced color grading and effect controls.",
        .labels = {"Simple", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "Vanilla+", "PsychoV-24"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 100.f,
        .max = 4000.f,
        .is_enabled = IsVanillaPlus,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .can_reset = true,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = IsVanillaPlus,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .can_reset = true,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = IsVanillaPlus,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_enabled = IsVanillaPlus,
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .tooltip = "Scene exposure. 1.0 = vanilla.",
        .min = 0.25f,
        .max = 4.f,
        .format = "%.2f",
        .is_enabled = IsVanillaPlus,
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .tooltip = "Adjusts highlight brightness. 50 = vanilla.",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .tooltip = "Adjusts shadow brightness. 50 = vanilla.",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .tooltip = "Adjusts contrast. 50 = vanilla.",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .tooltip = "Adjusts overall saturation. 50 = vanilla.",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.colorGradeHighlightSaturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHueShift",
        .binding = &shader_injection.colorGradeHueShift,
        .default_value = 0.f,
        .label = "Hue Shift",
        .section = "Color Grading",
        .tooltip = "Shifts highlight hue toward the per-channel (SDR-display) look. 0 = vanilla.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == TONE_MAP_VANILLA_PLUS; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTSampling",
        .binding = &shader_injection.customLutTetrahedral,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "LUT Sampling",
        .section = "Color Grading",
        .tooltip = "Interpolation of the game's native grade LUT. Tetrahedral reduces banding; Trilinear = vanilla.",
        .labels = {"Trilinear", "Tetrahedral"},
        .is_enabled = IsVanillaPlus,
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .tooltip = "Scales the game's bloom. 50 = vanilla, 0 = off.",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "FxVignette",
        .binding = &shader_injection.fxVignette,
        .default_value = 50.f,
        .label = "Vignette",
        .section = "Effects",
        .tooltip = "Scales the game's vignette. 50 = vanilla, 0 = off.",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "FxChromaticAberration",
        .binding = &shader_injection.fxChromaticAberration,
        .default_value = 100.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tooltip = "Scales the game's chromatic aberration. 100 = vanilla, 0 = off (requires the in-game CA setting on).",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "FxSharpness",
        .binding = &shader_injection.fxSharpness,
        .default_value = 0.f,
        .label = "RCAS Sharpening",
        .section = "Effects",
        .tooltip = "Adds RCAS, as implemented by Lilium for HDR. Disable other sharpening (DLAA / ReShade) to avoid double-sharpening.",
        .max = 100.f,
        .is_enabled = IsVanillaPlus,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainType",
        .binding = &shader_injection.fxFilmGrainType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Film Grain Type",
        .section = "Effects",
        .tooltip = "Vanilla keeps the game's own grain. Monochrome / Colored use RenoDX perceptual grain "
                   "(reduces banding).",
        .labels = {"Vanilla", "Monochrome", "Colored"},
        .is_enabled = IsVanillaPlus,
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "Film Grain",
        .section = "Effects",
        .tooltip = "Film grain strength. Reduces banding.",
        .max = 100.f,
        .is_enabled = []() { return IsVanillaPlus() && shader_injection.fxFilmGrainType != FILM_GRAIN_VANILLA; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "FxHDRVideos",
        .binding = &shader_injection.fxHDRVideos,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "HDR Videos",
        .section = "Effects",
        .tooltip = "Inverse tonemaps SDR videos (BT.2446a)",
        .labels = {"Off", "On"},
        .is_enabled = IsVanillaPlus,
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .key = "FxVideoNits",
        .binding = &shader_injection.fxVideoNits,
        .default_value = 500.f,
        .can_reset = true,
        .label = "Video Brightness",
        .section = "Effects",
        .tooltip = "Sets the peak brightness for video content in nits",
        .min = 100.f,
        .max = 1000.f,
        .is_enabled = []() { return IsVanillaPlus() && shader_injection.fxHDRVideos != 0.f; },
        .is_visible = IsAdvanced,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() { renodx::utils::settings::ResetSettings(); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/", "2fJJMBReAW"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/", "qVSPcABQF4"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Requires HDR on in game",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Vanilla+: set the in-game Graphics -> Screen Calibration -> Peak Brightness to MAX; the addon's Peak Brightness sets your display peak.",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Vanilla = untouched native HDR (all other controls disabled).",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Thanks and credits to Lilium (EndlesslyFlowering) for the RCAS implementation.",
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::ResetSettings();
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},            // Vanilla: the game's own bytecode runs.
      {"ColorGradeLUTSampling", 0.f},  // Trilinear: the vanilla sampling mode.
  });
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (!peak.has_value()) return;
  auto* peak_setting = renodx::utils::settings::FindSetting("ToneMapPeakNits");
  if (peak_setting != nullptr) {
    peak_setting->default_value = roundf(peak.value());
  }
  fired_on_init_swapchain = true;
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  shader_injection.fxVideoActive = 0.f;       // Re-set by the 0x7ED07F45 callback when video decodes.
  shader_injection.fxSwapchainPresent = 0.f;  // Re-set by SetSwapchainPresentFlag per present draw.
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX Native HDR Fix for Mass Effect: Andromeda";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::SetUseHDR10(true);
        // Frostbite BitBlt swapchain: Windows scans out HDR only in exclusive fullscreen, so
        // virtualize it (prevent_full_screen) and keep the flip-model + HDR10 colorspace outside
        // it (force_borderless; false makes the game's Fullscreen mode present black).
        renodx::mods::swapchain::force_borderless = true;
        renodx::mods::swapchain::prevent_full_screen = true;
        renodx::mods::swapchain::use_resource_cloning = true;
        // Clone the graded buffer to fp16
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::r10g10b10a2_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .usage_include = reshade::api::resource_usage::render_target,
        });

        initialized = true;
      }

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason, {&shader_injection.customRandom,
                                          &shader_injection.customRandom2,
                                          &shader_injection.customRandom3});
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
