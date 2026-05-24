/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <windows.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include <optional>
#include <vector>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

const int CUSTOM_LUT_SHADER = 0x81567E40;
float g_custom_lut_draws = 0.f;
float g_custom_lut_count = 0.f;
ShaderInjectData shader_injection;
const float WARDROBE_RENDER_TAG = 1.f;

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomSwapchainShader(0x20133A8B),  // Final
    CustomShaderEntryCallback(0x81567E40, [](auto*) {
      ++g_custom_lut_count;
      shader_injection.custom_custom_lut_count = g_custom_lut_count;
      return true;
    }),
    CustomShaderEntryCallback(0x49E25D6C, [](auto* cmd_list) {
      bool is_wardrobe_render = false;
      auto render_targets = renodx::utils::swapchain::GetRenderTargets(cmd_list);
      if (render_targets.size() == 1) {
        auto& rtv = render_targets[0];
        const auto original_resource = renodx::utils::resource::GetResourceFromView(cmd_list->get_device(), rtv);
        if (original_resource.handle != 0u) {
          is_wardrobe_render =
              renodx::utils::resource::GetResourceTag(original_resource) == WARDROBE_RENDER_TAG;
        }
      }
      shader_injection.custom_is_wardrobe_render = (is_wardrobe_render ? 1.f : 0.f);
      return true;
    }),
};

float exclusive_fullscreen_detected = 0.f;
renodx::utils::settings::Setting* exclusive_fullscreen_warning_setting = nullptr;
renodx::utils::settings::Setting* output_mode_setting = nullptr;
renodx::utils::settings::Setting* tone_map_type_setting = nullptr;
renodx::utils::settings::Setting* tone_map_peak_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_game_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_ui_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_gamma_correction_setting = nullptr;

std::optional<reshade::api::color_space> next_color_space = std::nullopt;
std::optional<reshade::api::color_space> current_color_space = std::nullopt;

inline bool IsSdrOutputSelected() {
  return output_mode_setting != nullptr && output_mode_setting->GetValue() == 0.f;
}

bool IsHDREnabled() { return !IsSdrOutputSelected(); }

bool IsCustomToneMapperEnabled() { return shader_injection.tone_map_type != RENODX_TONE_MAP_TYPE_VANILLA; }

bool IsRenoDRTEnabled() { return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_RENODRT; }

bool IsPsychoV17Enabled() { return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV17; }

void SyncSwapChainOutputPreset() {
  auto queue_color_space = [](reshade::api::color_space color_space) {
    if (current_color_space.has_value() && current_color_space.value() == color_space) {
      next_color_space = std::nullopt;
      return;
    }
    next_color_space = color_space;
  };

  const bool is_hdr10 = renodx::mods::swapchain::target_format == reshade::api::format::r10g10b10a2_unorm;
  const bool is_sdr_output = IsSdrOutputSelected();

  if (!is_sdr_output) {
    shader_injection.peak_white_nits = tone_map_peak_nits_setting->GetValue();
    shader_injection.diffuse_white_nits = tone_map_game_nits_setting->GetValue();
    shader_injection.graphics_white_nits = tone_map_ui_nits_setting->GetValue();
    shader_injection.swap_chain_output_preset = is_hdr10 ? 1.f : 2.f;
    queue_color_space(is_hdr10
                          ? reshade::api::color_space::hdr10_st2084
                          : reshade::api::color_space::extended_srgb_linear);
    return;
  }

  shader_injection.peak_white_nits = 1.f;
  shader_injection.diffuse_white_nits = 1.f;
  shader_injection.graphics_white_nits = 1.f;
  shader_injection.swap_chain_output_preset = is_hdr10 ? 0.f : 2.f;
  queue_color_space(is_hdr10
                        ? reshade::api::color_space::srgb_nonlinear
                        : reshade::api::color_space::extended_srgb_linear);
}

renodx::utils::settings::Settings settings = {
    exclusive_fullscreen_warning_setting = new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Exclusive fullscreen detected. Use Borderless instead.",
        .tint = 0xFF0000,
        .is_visible = []() { return exclusive_fullscreen_detected != 0.f; },
        .is_sticky = true,
    },
    output_mode_setting = new renodx::utils::settings::Setting{
        .key = "OutputMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Output Mode",
        .section = "Output",
        .tooltip = "Controls the swapchain output path. HDR uses the HDR preset and HDR colorspace. SDR uses the SDR preset and SDR colorspace.",
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
        .tooltip = "Sets the value of peak white in nits",
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
        .tooltip = "Sets the value of 100% white in nits",
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
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDREnabled,
    },
    tone_map_gamma_correction_setting = new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Output",
        .tooltip = "Emulates output decoding used on SDR displays.",
        .labels = {"None", "2.2", "BT.1886"},
    },
    tone_map_type_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Grading",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT", "PsychoV-17"},
        .parse = [](float value) {
          if (value == 1.f) return RENODX_TONE_MAP_TYPE_RENODRT;
          if (value == 2.f) return RENODX_TONE_MAP_TYPE_PSYCHOV17;
          return RENODX_TONE_MAP_TYPE_VANILLA; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Grading",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = &IsRenoDRTEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWhiteClip",
        .binding = &shader_injection.tone_map_white_clip,
        .default_value = 100.f,
        .label = "White Clip",
        .section = "Grading",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = &IsRenoDRTEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapSdrGamutCompression",
        .binding = &shader_injection.custom_sdr_gamut_compression,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR LUT Bridge",
        .section = "Grading",
        .tooltip = "Controls how HDR color is proxied through SDR LUTs.\n"
                   "Gamma Gamut / Max N2 keeps the old split behavior:\n"
                   "main LUT uses max-channel Neutwo scaling; other LUT draws\n"
                   "use gamma-domain gamut compression plus max-channel Neutwo.\n"
                   "Adaptive D65 Gamut + Max N2 gamut-compresses BT.709\n"
                   "against a D65 LMS adaptation state before max-channel Neutwo,\n"
                   "then gamut-decompresses after the LUT.",
        .labels = {"Gamma Gamut / Max N2", "Adaptive D65 Gamut + Max N2"},
        .is_enabled = &IsCustomToneMapperEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Grading",
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
        .key = "ColorGradeConeResponse",
        .binding = &shader_injection.custom_cone_response,
        .default_value = 50.f,
        .label = "Cone Response",
        .section = "Grading",
        .tooltip = "Scales PsychoV cone response.",
        .max = 100.f,
        .is_enabled = &IsPsychoV17Enabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = &IsRenoDRTEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
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
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = &IsRenoDRTEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxHueClip",
        .binding = &shader_injection.custom_hue_clip,
        .default_value = 50.f,
        .label = "Hue Clip",
        .section = "Effects",
        .tooltip = "Emulates the vanilla hue clip effect",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxSaturationClip",
        .binding = &shader_injection.custom_saturation_clip,
        .default_value = 50.f,
        .label = "Saturation Clip",
        .section = "Effects",
        .tooltip = "Emulates the vanilla saturation clip effect",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          SyncSwapChainOutputPreset();
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
              {"ToneMapWhiteClip", 20.f},
              {"ColorGradeHighlights", 50.f},
              {"ColorGradeShadows", 50.f},
              {"ColorGradeContrast", 60.f},
              {"ColorGradeSaturation", 60.f},
              {"ColorGradeBlowout", 25.f},
              {"FxVignette", 50.f},
              {"FxBloom", 25.f},
              {"FxGrainStrength", 25.f},
          });
          if (output_mode_setting->GetValue() == 1.f) {
            auto current_peak = tone_map_peak_nits_setting->GetValue();
            renodx::utils::settings::UpdateSetting("ToneMapGameNits", renodx::utils::swapchain::ComputeReferenceWhite(current_peak));
          } else {
            renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
          }
          SyncSwapChainOutputPreset();
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "PsychoV17",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"ToneMapType", 2.f},
              {"ColorGradeBlowout", 0.f},
              {"ColorGradeConeResponse", 60.f},
          });
          SyncSwapChainOutputPreset();
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Options",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "F6AUTeWJHM");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Options",
        .group = "button-line-2",
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
        .section = "Debug",
        .group = "button-line-3",
        .on_draw = []() {
          ImGui::Text("Custom LUT Draws: %d", static_cast<int>(g_custom_lut_draws));
          return false; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"GammaCorrection", 0.f},
      {"ToneMapHueProcessor", 0.f},
      {"ToneMapHueCorrection", 0.f},
      {"ToneMapHueShift", 0.f},
      {"ToneMapWhiteClip", 1.f},
      {"ToneMapSdrGamutCompression", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeConeResponse", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"FxVignette", 50.f},
      {"FxBloom", 50.f},
      {"FxGrainStrength", 0.f},
  });
  SyncSwapChainOutputPreset();
}

bool OnSetFullscreenState(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
  if (fullscreen) {
    exclusive_fullscreen_detected = 1.f;
  }
  return false;
}

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  g_custom_lut_draws = g_custom_lut_count;
  g_custom_lut_count = 0.f;

  SyncSwapChainOutputPreset();
  if (next_color_space.has_value()) {
    const auto pending_color_space = next_color_space.value();
    renodx::utils::swapchain::ChangeColorSpace(swapchain, pending_color_space);
    current_color_space = pending_color_space;
    next_color_space = std::nullopt;
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Wobbly Life";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::allow_multiple_push_constants = true;

      renodx::mods::swapchain::SetUseHDR10(true);
      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::force_borderless = true;
      renodx::mods::swapchain::use_auto_upgrade = true;
      renodx::mods::swapchain::set_color_space = false;
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .usage_include = reshade::api::resource_usage::render_target,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .aspect_ratio = 640.f / 1440.f,
          .usage_include = reshade::api::resource_usage::render_target,
          .resource_tag = WARDROBE_RENDER_TAG,
      });

      renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
      SyncSwapChainOutputPreset();

      reshade::register_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
      reshade::unregister_addon(h_module);
      next_color_space = std::nullopt;
      current_color_space = std::nullopt;
      renodx::mods::swapchain::set_color_space = true;
      break;
  }

  renodx::utils::swapchain::Use(fdw_reason);
  renodx::utils::random::Use(fdw_reason);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
