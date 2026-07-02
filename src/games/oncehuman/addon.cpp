/*
 * =====================================================================================
 * RenoDX HDR Addon for Once Human
 * Engine: NetEase NeoX
 * API: DirectX 11 & DirectX 12
 *
 * Details:
 * - Upgrades the 8-bit swapchain to fp16.
 * - Replaces the game's baked SDR tonemap/LUT output with RenoDX tonemapping.
 * - A single binary serves both APIs: sm5 (DXBC) for D3D11, sm6 (DXIL) for D3D12.
 *
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 * =====================================================================================
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

// Custom shader replacements for tonemap / output passes.
renodx::mods::shader::CustomShaders custom_shaders = {
    // DX11 (sm5 / DXBC) passes.
    CustomShaderEntry(0x97189CC3),  // tonemap + color grade (gameplay)
    CustomShaderEntry(0x9CBB8C92),  // tonemap + color grade (gameplay variant)
    CustomShaderEntry(0x0FAF8922),  // tonemap + color grade (menu / inventory)
    CustomShaderEntry(0x0C0D9DB1),  // tonemap + color grade (menu / inventory variant)
    CustomShaderEntry(0x6AEF81FE),  // post sharpen / AA -> swapchain
    // DX12 (sm6 / DXIL) passes. sm5 and sm6 hashes differ, so registering both is safe.
    CustomShaderEntry(0x80419ACE),  // tonemap + color grade (gameplay)
    CustomShaderEntry(0x2FC428AF),  // tonemap + color grade (gameplay variant)
    CustomShaderEntry(0xEC5A7D52),  // tonemap + color grade (menu / inventory)
    CustomShaderEntry(0x4506D824),  // tonemap + color grade (menu / inventory variant)
    CustomShaderEntry(0x51731F8B),  // post sharpen / AA -> swapchain
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

// Captured at construction for post-init updates (peak brightness detection, HDR toggle).
renodx::utils::settings::Setting* peak_brightness_setting = nullptr;
renodx::utils::settings::Setting* output_mode_setting = nullptr;

// Sync swapchain encoding with the SDR/HDR toggle (container switch needs a restart).
void SyncSwapChainOutput() {
  if (output_mode_setting == nullptr) return;
  const bool is_hdr = (output_mode_setting->GetValue() != 0.f);
  shader_injection.swap_chain_encoding = is_hdr ? 4.f : 1.f;              // HDR10 : sRGB
  shader_injection.swap_chain_encoding_color_space = is_hdr ? 1.f : 0.f;  // BT2020 : BT709
  renodx::mods::swapchain::SetUseHDR10(is_hdr);
  renodx::mods::swapchain::use_resize_buffer = !is_hdr;
}

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,  // RenoDRT
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        // 0 = Vanilla, 3 = RenoDRT (matches is_enabled checks).
        .parse = [](float value) { return value == 0.f ? 0.f : 3.f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    peak_brightness_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,  // overwritten with detected display peak
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits. Reset returns to the display's detected peak.",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,  // 2.4
        .label = "Scene Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF for the scene.",
        .labels = {"Off", "2.2", "2.4"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,  // 2.2
        .label = "UI Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Gamma correction applied to the UI / swapchain output.",
        .labels = {"None", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        // Baked LUT is dark; parse doubles slider value for +1 stop correction.
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .parse = [](float value) { return value * 2.f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxVignette",
        .binding = &shader_injection.vignette_strength,
        .default_value = 100.f,
        .label = "Vignette",
        .section = "Effects",
        .tooltip = "Strength of the game's vignette (edge darkening).",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxChromaticAberration",
        .binding = &shader_injection.chromatic_aberration_strength,
        .default_value = 100.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tooltip = "Strength of the game's chromatic aberration (edge color fringing).",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.bloom_strength,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Effects",
        .tooltip = "Strength of the game's bloom.",
        .min = 0.f,
        .max = 200.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Display Output",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US Modern",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    // Output Mode — persisted value loaded in DLL_PROCESS_ATTACH.
    output_mode_setting = new renodx::utils::settings::Setting{
        .key = "OutputMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,  // HDR
        .can_reset = false,
        .label = "Output Mode",
        .section = "Display Output",
        .tooltip = "Selects the swapchain output path."
                   "\nSDR: 8-bit sRGB / BT.709."
                   "\nHDR: 10-bit PQ (HDR10) / BT.2020."
                   "\nSwitching SDR <-> HDR requires a game restart.",
        .labels = {"SDR", "HDR"},
        .on_change_value = [](float, float) { SyncSwapChainOutput(); },
        .is_global = true,
    },
    // ---- About ----
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "RenoDX for Once Human",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Addon by NatsumeLS",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- RenoDX by ShortFuse",
        .section = "About",
    },
};

// Set Peak Brightness default to the display's detected peak (first init only).
bool fired_on_init_swapchain = false;
void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  float peak_nits = renodx::utils::swapchain::GetPeakNits(swapchain).value_or(1000.f);
  if (peak_nits < peak_brightness_setting->min) peak_nits = peak_brightness_setting->min;
  if (peak_nits > peak_brightness_setting->max) peak_nits = peak_brightness_setting->max;
  peak_brightness_setting->default_value = peak_nits;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Once Human)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      // Pipeline cloning + injection constant buffer (b13, space50).
      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::allow_multiple_push_constants = true;

      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::set_color_space = true;

      // Swapchain proxy shaders (dual-target sm5.0/sm5.1 for DX11/DX12).
      renodx::mods::swapchain::swap_chain_proxy_shaders = {
          {
              reshade::api::device_api::d3d11,
              {
                  .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                  .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
              },
          },
          {
              reshade::api::device_api::d3d12,
              {
                  .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
                  .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
              },
          },
      };

      for (int i = 0; i < 4; i++) {
        // Upgrade r8 render targets to fp16 so HDR values survive to output.
        // We use index to ONLY upgrade the swapchain back buffers (created first),
        // preventing UI canvases from being upgraded and freezing the game.
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .index = i,
            // View cloning: keeps original r8 for buffer->texture uploads; DX12 crashes without it.
            .use_resource_view_cloning = true,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .index = i,
            .use_resource_view_cloning = true,
            .usage_include = reshade::api::resource_usage::render_target,
        });
      }

      // Load and apply persisted SDR/HDR choice.
      renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, output_mode_setting);
      SyncSwapChainOutput();

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, nullptr);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
