/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#include <optional>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection = {};

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x57A0AE0E),  // Scene effects, color grade, and tone map
    CustomShaderEntry(0x7CE8C479),  // FXAA and final scene blit
    CustomShaderEntry(0x06815A08),  // Updated scene effects, color grade, and tone map
    CustomShaderEntry(0x7C789067),  // Updated FXAA and final scene blit
};

renodx::utils::settings::Setting* output_mode_setting = nullptr;
renodx::utils::settings::Setting* tone_map_peak_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_game_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_ui_nits_setting = nullptr;

std::optional<reshade::api::color_space> next_color_space = std::nullopt;
std::optional<reshade::api::color_space> current_color_space = std::nullopt;

bool IsHDREnabled() {
  return output_mode_setting != nullptr && output_mode_setting->GetValue() != 0.f;
}

bool IsNeutwoEnabled() {
  return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_NEUTWO;
}

bool IsPsychoVEnabled() {
  return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV17
         || shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV30;
}

bool IsCustomToneMapperEnabled() {
  return shader_injection.tone_map_type != RENODX_TONE_MAP_TYPE_VANILLA;
}

bool IsPsychoV30Enabled() {
  return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV30;
}

void SyncSwapChainOutputPreset() {
  if (output_mode_setting == nullptr
      || tone_map_peak_nits_setting == nullptr
      || tone_map_game_nits_setting == nullptr
      || tone_map_ui_nits_setting == nullptr) {
    return;
  }

  const auto queue_color_space = [](reshade::api::color_space color_space) {
    if (current_color_space.has_value() && current_color_space.value() == color_space) {
      next_color_space = std::nullopt;
      return;
    }
    next_color_space = color_space;
  };

  if (IsHDREnabled()) {
    shader_injection.peak_white_nits = tone_map_peak_nits_setting->GetValue();
    shader_injection.diffuse_white_nits = tone_map_game_nits_setting->GetValue();
    shader_injection.graphics_white_nits = tone_map_ui_nits_setting->GetValue();
    shader_injection.swap_chain_output_preset = 1.f;
    queue_color_space(reshade::api::color_space::hdr10_st2084);
    return;
  }

  shader_injection.peak_white_nits = 1.f;
  shader_injection.diffuse_white_nits = 1.f;
  shader_injection.graphics_white_nits = 1.f;
  shader_injection.swap_chain_output_preset = 0.f;
  queue_color_space(reshade::api::color_space::srgb_nonlinear);
}

renodx::utils::settings::Settings settings = {
    output_mode_setting = new renodx::utils::settings::Setting{
        .key = "OutputMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Output Mode",
        .section = "Output",
        .tooltip = "HDR uses PQ/BT.2020. SDR preserves the original sRGB output.",
        .labels = {"SDR", "HDR"},
        .on_change_value = [](float, float) { SyncSwapChainOutputPreset(); },
    },
    tone_map_peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Output",
        .tooltip = "Sets the display peak white in nits.",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = &IsHDREnabled,
    },
    tone_map_game_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Output",
        .tooltip = "Sets diffuse white in nits.",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDREnabled,
    },
    tone_map_ui_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Output",
        .tooltip = "Sets graphics white in nits.",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDREnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Output",
        .tooltip = "Emulates SDR display decoding in HDR output.",
        .labels = {"None", "2.2", "BT.1886"},
        .is_enabled = &IsHDREnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapTypeV2",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Grading",
        .tooltip = "Vanilla preserves the original game tone mapper. Neutwo tone-maps its output-18% tangent extension. PsychoV can use the vanilla output-18% exposure and positive-inflection slope.",
        .labels = {"Vanilla", "Neutwo", "PsychoV-17", "PsychoV-30"},
        .parse = [](float value) {
          if (value == 1.f) return RENODX_TONE_MAP_TYPE_NEUTWO;
          if (value == 2.f) return RENODX_TONE_MAP_TYPE_PSYCHOV17;
          if (value == 3.f) return RENODX_TONE_MAP_TYPE_PSYCHOV30;
          return RENODX_TONE_MAP_TYPE_VANILLA;
        },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Grading",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = &IsNeutwoEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Grading",
        .min = 0.5f,
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = &IsCustomToneMapperEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsCustomToneMapperEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsCustomToneMapperEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsCustomToneMapperEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsCustomToneMapperEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeConeContrast",
        .binding = &shader_injection.tone_map_cone_contrast,
        .default_value = 50.f,
        .label = "Cone Contrast",
        .section = "Grading",
        .tooltip = "Scales PsychoV cone-response contrast after vanilla-slope matching.",
        .max = 100.f,
        .is_enabled = &IsPsychoVEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsNeutwoEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsCustomToneMapperEnabled,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsNeutwoEnabled,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoVVanillaMidgray",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FLAGS__PSYCHOV_VANILLA_MIDGRAY},
        .label = "Midgray Reference",
        .section = "Grading",
        .tooltip = "On uses the active vanilla curve's solved V(x) = 0.18 exposure."
                   "\nOff uses identity exposure before the shared Grading exposure.",
        .labels = {"Off", "On"},
        .is_enabled = &IsPsychoVEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoVVanillaSlope",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FLAGS__PSYCHOV_VANILLA_SLOPE},
        .label = "Slope Reference",
        .section = "Grading",
        .tooltip = "On uses the active vanilla curve's local logarithmic slope at its positive inflection."
                   "\nOff uses identity cone response. Curves without a positive inflection use identity without computing a slope.",
        .labels = {"Off", "On"},
        .is_enabled = &IsPsychoVEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoVGamutCompression",
        .binding = &shader_injection.psychov_gamut_compression,
        .default_value = 1.f,
        .label = "Gamut Compression",
        .section = "Grading",
        .tooltip = "Controls PsychoV gamut compression."
                   "\n0 bypasses gamut mapping; 1 applies the full selected model.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.2f",
        .is_enabled = &IsPsychoVEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoVCompression",
        .binding = &shader_injection.psychov_compression,
        .default_value = 1.f,
        .label = "Compression",
        .section = "Grading",
        .tooltip = "Controls PsychoV-30's finite-response compression power."
                   "\n0 selects automatic compression; positive values select a manual power."
                   "\nPsychoV-17 does not expose this parameter.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = &IsPsychoV30Enabled,
    },
    new renodx::utils::settings::Setting{
        .key = "FxGameSaturationSpace",
        .binding = &shader_injection.custom_saturation_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Game Saturation Space",
        .section = "Effects",
        .tooltip = "Selects how the game's authored saturation is applied."
                   "\nLMS / D65 scales adaptive MacLeod-Boynton chromaticity around D65.",
        .labels = {"BT.709 (Native)", "OKLab", "LMS / D65"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxGameSaturationV2",
        .binding = &shader_injection.custom_game_saturation,
        .default_value = 50.f,
        .label = "Game Saturation",
        .section = "Effects",
        .tooltip = "Scales the game's authored saturation in the selected space.\n0 disables it; 50 preserves vanilla; 100 doubles its deviation from neutral.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxGameLiftV2",
        .binding = &shader_injection.custom_lift,
        .default_value = 50.f,
        .label = "Game Lift",
        .section = "Effects",
        .tooltip = "Scales the game's authored per-channel lift.\n0 disables it; 50 preserves vanilla; 100 doubles it.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxGameGammaV2",
        .binding = &shader_injection.custom_gamma,
        .default_value = 50.f,
        .label = "Game Gamma",
        .section = "Effects",
        .tooltip = "Scales the game's authored per-channel inverse-gamma exponent.\n0 disables it; 50 preserves vanilla; 100 doubles its deviation from neutral.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxGameGainV2",
        .binding = &shader_injection.custom_gain,
        .default_value = 50.f,
        .label = "Game Gain",
        .section = "Effects",
        .tooltip = "Scales the game's authored per-channel gain.\n0 disables it; 50 preserves vanilla; 100 doubles its deviation from neutral.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .tooltip = "Controls the strength of the game's bloom."
                   "\n0 disables bloom; 50 preserves the vanilla strength.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFXAA",
        .binding = &shader_injection.custom_fxaa,
        .default_value = 100.f,
        .label = "FXAA",
        .section = "Effects",
        .tooltip = "Controls the strength of the game's FXAA."
                   "\n0 bypasses FXAA; 100 preserves the vanilla result.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
#ifndef NDEBUG
    new renodx::utils::settings::Setting{
        .key = "DebugCanvas",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FLAGS__DEBUG_CANVAS},
        .label = "PsychoV Canvas",
        .section = "Debug",
        .tooltip = "Shows the live PsychoV reference calculations on screen.",
        .labels = {"Off", "On"},
    },
#endif
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .on_change = []() { renodx::utils::settings::ResetSettings(); },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
#ifndef NDEBUG
      {"DebugCanvas", 1.f},
#endif
      {"ToneMapTypeV2", 0.f},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"GammaCorrection", 0.f},
      {"PsychoVVanillaMidgray", 1.f},
      {"PsychoVVanillaSlope", 1.f},
      {"ColorGradeConeContrast", 50.f},
      {"PsychoVGamutCompression", 1.f},
      {"PsychoVCompression", 1.f},
      {"ToneMapHueProcessor", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"FxGameSaturationSpace", 0.f},
      {"FxGameSaturationV2", 50.f},
      {"FxGameLiftV2", 50.f},
      {"FxGameGammaV2", 50.f},
      {"FxGameGainV2", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"FxBloom", 50.f},
      {"FxFXAA", 100.f},
  });
  SyncSwapChainOutputPreset();
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  (void)queue;
  (void)source_rect;
  (void)dest_rect;
  (void)dirty_rect_count;
  (void)dirty_rects;
  SyncSwapChainOutputPreset();
  if (swapchain == nullptr || !next_color_space.has_value()) return;

  const auto pending_color_space = next_color_space.value();
  if (!renodx::utils::swapchain::ChangeColorSpace(swapchain, pending_color_space)) return;
  current_color_space = pending_color_space;
  next_color_space = std::nullopt;
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "RenoDX module for Order of the Sinking Star Demo";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
          return device->get_api() == reshade::api::device_api::d3d12;
        };
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::use_root_signature_cbv = true;

        renodx::mods::swapchain::SetUseHDR10(true);
        renodx::mods::swapchain::set_color_space = false;
        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::use_resource_cloning_dx12_only = true;
        renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
        renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
        renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        initialized = true;
      }

      renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
      SyncSwapChainOutputPreset();
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
      next_color_space = std::nullopt;
      current_color_space = std::nullopt;
      renodx::mods::swapchain::set_color_space = true;
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}