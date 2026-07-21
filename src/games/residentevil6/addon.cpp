/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */
#include <include/reshade_api_resource.hpp>
#include <Windows.h>
#include <sstream>
#include <unordered_map>
#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define RENODX_MODS_SWAPCHAIN_VERSION 2
#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,
};
ShaderInjectData shader_injection;

float current_settings_mode = 0.f;
float force_windowed_borderless = 1.f;

constexpr float TONE_MAP_TYPE_VANILLA = 0.f;
constexpr float TONE_MAP_TYPE_RENODRT = 3.f;
constexpr float TONE_MAP_TYPE_PSYCHOV22 = 22.f;

inline bool IsAdvancedMode() {
  return current_settings_mode >= 2.f;
}

inline bool IsIntermediateMode() {
  return current_settings_mode >= 1.f;
}

inline bool IsVanillaEnabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_VANILLA;
}

inline bool IsRenoDRTEnabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_RENODRT;
}

inline bool IsPsychoV22Enabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_PSYCHOV22;
}

inline bool IsCustomToneMapperEnabled() {
  return !IsVanillaEnabled();
}

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Settings Mode",
        .section = "Options",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },

    // ------------------------------------------------------------
    // Output
    // ------------------------------------------------------------

    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Output",
        .tooltip = "Sets the value of peak white in nits.",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Output",
        .tooltip = "Sets the value of 100% scene white in nits.",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Output",
        .tooltip = "Sets the brightness of UI and HUD elements in nits.",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Output",
        .tooltip = "Emulates a display EOTF before RenoDX output encoding.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return IsIntermediateMode(); },
    },

    // ------------------------------------------------------------
    // Grading
    // ------------------------------------------------------------

    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Grading",
        .tooltip = "Vanilla keeps the original SDR final shader. RenoDRT uses RenoDX ToneMapPass. PsychoV22 calls psychotm_test22.",
        .labels = {"Vanilla", "RenoDRT", "PsychoV22"},
        .parse = [](float value) {
          if (value == 1.f) return TONE_MAP_TYPE_RENODRT;
          if (value == 2.f) return TONE_MAP_TYPE_PSYCHOV22;
          return TONE_MAP_TYPE_VANILLA;
        },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return IsIntermediateMode(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return IsIntermediateMode(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return IsIntermediateMode(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Grading",
        .tooltip = "Adds or removes highlight color in RenoDRT.",
        .max = 100.f,
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .is_visible = []() { return IsIntermediateMode(); },
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
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Grading",
        .tooltip = "RenoDRT flare/glare compensation.",
        .max = 100.f,
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .is_visible = []() { return IsIntermediateMode(); },
        .parse = [](float value) { return value * 0.02f; },
    },

    // ------------------------------------------------------------
    // PsychoV22
    // ------------------------------------------------------------

    new renodx::utils::settings::Setting{
        .key = "PsychoV22Compression",
        .binding = &shader_injection.psychov22_compression,
        .default_value = 0.f,
        .label = "PsychoV22 Compression",
        .section = "Grading",
        .tooltip = "PsychoV22 shoulder/curve shape. 0 = auto. 50 = 1.00. 100 = 2.00. 200 = 4.00.",
        .min = 0.f,
        .max = 200.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV22Enabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV22ConeResponse",
        .binding = &shader_injection.psychov22_cone_response,
        .default_value = 50.f,
        .label = "PsychoV22 Cone Response",
        .section = "Grading",
        .tooltip = "Scales PsychoV22 cone response. 50 = 1.00 neutral. Higher values increase the PsychoV22 contrast/purity response.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV22Enabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV22GamutCompression",
        .binding = &shader_injection.psychov22_gamut_compression,
        .default_value = 100.f,
        .label = "PsychoV22 Gamut Compression",
        .section = "Grading",
        .tooltip = "PsychoV22 LMS/MB gamut compression strength.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV22Enabled(); },
        .is_visible = []() { return IsAdvancedMode(); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV22GamutMode",
        .binding = &shader_injection.psychov22_gamut_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "PsychoV22 Gamut Mode",
        .section = "Grading",
        .labels = {"BT.709", "BT.2020"},
        .is_enabled = []() { return IsPsychoV22Enabled(); },
        .is_visible = []() { return IsAdvancedMode(); },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Grading",
        .tooltip = "Scene grading as applied by the game.",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Grading",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner.",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .is_visible = []() { return IsAdvancedMode(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Grading",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Grading",
        .tooltip = "Selects RenoDRT hue processor.",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Grading",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,
        .default_value = 0.f,
        .label = "Hue Shift",
        .section = "Grading",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Grading",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Peak",
        .section = "Grading",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },

    // ------------------------------------------------------------
    // Display Output
    // ------------------------------------------------------------

    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Display Output",
        .tooltip = "Selects output color space."
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 NTSC-U."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 NTSC-J.",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Intermediate Encoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) {
          if (value == 0) return shader_injection.gamma_correction + 1.f;
          return value - 1.f;
        },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) {
          if (value == 0) return shader_injection.intermediate_encoding;
          return value - 1.f;
        },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Gamma Correction",
        .section = "Display Output",
        .labels = {"None", "2.2", "2.4"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },

    // ------------------------------------------------------------
    // Processing / Options
    // ------------------------------------------------------------

    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &renodx::utils::swapchain::fps_limit,
        .default_value = 60.f,
        .label = "FPS Limit",
        .section = "Processing",
        .min = 30.f,
        .max = 500.f,
        .parse = [](float value) { return value * 2.f; },
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
            if (setting->is_global) continue;
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
              {"ToneMapType", 1.f},
              {"ToneMapGameNits", 203.f},
              {"ColorGradeHighlights", 55.f},
              {"ColorGradeShadows", 50.f},
              {"ColorGradeContrast", 55.f},
              {"ColorGradeSaturation", 50.f},
              {"ColorGradeBlowout", 0.f},
          });
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "PsychoV22",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"ToneMapType", 2.f},
              {"PsychoV22Compression", 200.f},
              {"PsychoV22ConeResponse", 60.f},
              {"PsychoV22GamutCompression", 100.f},
              {"PsychoV22GamutMode", 1.f},
              {"ColorGradeHighlights", 50.f},
              {"ColorGradeShadows", 50.f},
              {"ColorGradeContrast", 50.f},
              {"ColorGradeSaturation", 50.f},
              {"ColorGradeBlowout", 0.f},
          });
        },
    },
};

const std::unordered_map<std::string, reshade::api::format> UPGRADE_TARGETS = {
    {"R8G8B8A8_TYPELESS", reshade::api::format::r8g8b8a8_typeless},
    {"B8G8R8A8_TYPELESS", reshade::api::format::b8g8r8a8_typeless},
    {"R8G8B8A8_UNORM", reshade::api::format::r8g8b8a8_unorm},
    {"B8G8R8A8_UNORM", reshade::api::format::b8g8r8a8_unorm},
    {"R8G8B8A8_SNORM", reshade::api::format::r8g8b8a8_snorm},
    {"R8G8B8A8_UNORM_SRGB", reshade::api::format::r8g8b8a8_unorm_srgb},
    {"B8G8R8A8_UNORM_SRGB", reshade::api::format::b8g8r8a8_unorm_srgb},
    {"R10G10B10A2_TYPELESS", reshade::api::format::r10g10b10a2_typeless},
    {"R10G10B10A2_UNORM", reshade::api::format::r10g10b10a2_unorm},
    {"B10G10R10A2_UNORM", reshade::api::format::b10g10r10a2_unorm},
    {"R11G11B10_FLOAT", reshade::api::format::r11g11b10_float},
    {"R16G16B16A16_TYPELESS", reshade::api::format::r16g16b16a16_typeless},
};

constexpr float SWAP_CHAIN_ENCODING_HDR10 = 4.f;

// Keeps the swapchain state in sync with the shader setting.
// HDR10 needs both the shader-side HDR10 encoding flag and the swapchain-side HDR10 mode.
// The original callback only changed shader_injection.swap_chain_encoding_color_space,
// so changing the setting could leave the swapchain stuck in the previous output path.
void ApplySwapChainEncoding(float encoding) {
  const bool use_hdr10 = (encoding >= SWAP_CHAIN_ENCODING_HDR10);

  // Force any old saved scRGB value back into the HDR10 path.
  // This avoids stale configs where "5" used to mean scRGB.
  if (use_hdr10) {
    shader_injection.swap_chain_encoding = SWAP_CHAIN_ENCODING_HDR10;
  }

  renodx::mods::swapchain::SetUseHDR10(use_hdr10);

  // SDR modes can use the resize-buffer path. HDR10 should stay on the HDR output/proxy path.
  renodx::mods::swapchain::use_resize_buffer = !use_hdr10;

  // 1 = HDR10 / BT.2020 container for the shader proxy path.
  // 0 = non-HDR10/scRGB-style path.
  shader_injection.swap_chain_encoding_color_space = use_hdr10 ? 1.f : 0.f;
}


void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"GammaCorrection", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"PsychoV22Compression", 200.f},
      {"PsychoV22ConeResponse", 50.f},
      {"PsychoV22GamutCompression", 100.f},
      {"PsychoV22GamutMode", 1.f},
      {"ColorGradeScene", 100.f},
  });
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

void ApplyWindowedBorderless(HWND hwnd) {
  if (force_windowed_borderless < 0.5f) return;
  if (hwnd == nullptr) return;
  if (!IsWindow(hwnd)) return;

  HMONITOR monitor = MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);

  MONITORINFO monitor_info = {};
  monitor_info.cbSize = sizeof(monitor_info);

  if (!GetMonitorInfoW(monitor, &monitor_info)) return;

  const RECT& monitor_rect = monitor_info.rcMonitor;

  LONG_PTR style = GetWindowLongPtrW(hwnd, GWL_STYLE);
  LONG_PTR ex_style = GetWindowLongPtrW(hwnd, GWL_EXSTYLE);

  LONG_PTR borderless_style = style;
  borderless_style &= ~(WS_CAPTION | WS_THICKFRAME | WS_BORDER | WS_DLGFRAME | WS_SYSMENU |
                        WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
  borderless_style |= WS_POPUP | WS_VISIBLE;

  LONG_PTR borderless_ex_style = ex_style;
  borderless_ex_style &= ~(WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE | WS_EX_WINDOWEDGE);

  if (borderless_style != style) {
    SetWindowLongPtrW(hwnd, GWL_STYLE, borderless_style);
  }

  if (borderless_ex_style != ex_style) {
    SetWindowLongPtrW(hwnd, GWL_EXSTYLE, borderless_ex_style);
  }

  RECT window_rect = {};
  GetWindowRect(hwnd, &window_rect);

  const int target_x = monitor_rect.left;
  const int target_y = monitor_rect.top;
  const int target_width = monitor_rect.right - monitor_rect.left;
  const int target_height = monitor_rect.bottom - monitor_rect.top;

  const bool needs_resize =
      window_rect.left != target_x ||
      window_rect.top != target_y ||
      (window_rect.right - window_rect.left) != target_width ||
      (window_rect.bottom - window_rect.top) != target_height;

  if (needs_resize || borderless_style != style || borderless_ex_style != ex_style) {
    SetWindowPos(
        hwnd,
        HWND_TOP,
        target_x,
        target_y,
        target_width,
        target_height,
        SWP_NOOWNERZORDER | SWP_FRAMECHANGED | SWP_SHOWWINDOW);
  }
}

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  auto* device = queue->get_device();
  if (device->get_api() == reshade::api::device_api::opengl) {
    shader_injection.custom_flip_uv_y = 1.f;
  }

  HWND hwnd = nullptr;
  if (swapchain != nullptr) {
    hwnd = reinterpret_cast<HWND>(swapchain->get_hwnd());
  }

  ApplyWindowedBorderless(hwnd);
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Generic)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;
         renodx::mods::shader::constant_buffer_offset = 50 * 4; 
        renodx::mods::swapchain::set_color_space = false; 
        renodx::mods::swapchain::use_device_proxy = true;
        renodx::mods::swapchain::use_resource_cloning = false;
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

        // Always register present so the Windowed Borderless helper can run even if
        // the display proxy is disabled.
        reshade::register_event<reshade::addon_event::present>(OnPresent);

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainForceBorderless",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Force Borderless",
              .section = "Display Output",
              .tooltip = "Forces fullscreen to be borderless for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::force_borderless = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::force_borderless = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainPreventFullscreen",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Prevent Fullscreen",
              .section = "Display Output",
              .tooltip = "Prevent exclusive fullscreen for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainWindowedBorderless",
              .binding = &force_windowed_borderless,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Windowed Borderless",
              .section = "Display Output",
              .tooltip = "Removes the border from a normal windowed game window and stretches it to the monitor using the ReShade/RenoDX addon present hook.",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          force_windowed_borderless = setting->GetValue();
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = SWAP_CHAIN_ENCODING_HDR10,
              .label = "Encoding",
              .section = "Display Output",
              .labels = {"None", "SRGB", "2.2", "2.4", "HDR10"},
              .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
              .on_change_value = [](float previous, float current) {
                ApplySwapChainEncoding(current);
              },
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          ApplySwapChainEncoding(setting->GetValue());
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxy",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Use Display Proxy",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool use_device_proxy = setting->GetValue() == 1.f;
          renodx::mods::swapchain::use_device_proxy = use_device_proxy;
          renodx::mods::swapchain::set_color_space = !use_device_proxy;
          if (!use_device_proxy) {
            shader_injection.custom_flip_uv_y = 0.f;
          }
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyBaseWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Base Wait Idle",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool use_device_proxy =
              renodx::mods::swapchain::device_proxy_wait_idle_source = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyProxyWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Proxy Wait Idle",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool use_device_proxy =
              renodx::mods::swapchain::device_proxy_wait_idle_destination = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        for (const auto& [key, format] : UPGRADE_TARGETS) {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "Upgrade_" + key,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = key,
              .section = "Resource Upgrades",
              .labels = {
                  "Off",
                  "Output size",
                  "Output ratio",
                  "Any size",
              },
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          settings.push_back(setting);

          auto value = setting->GetValue();
          if (value > 0) {
            renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
                .old_format = format,
                .new_format = reshade::api::format::r16g16b16a16_float,
                .ignore_size = (value == UPGRADE_TYPE_ANY),
                .use_resource_view_cloning = false,
                .aspect_ratio = static_cast<float>((value == UPGRADE_TYPE_OUTPUT_RATIO)
                                                       ? renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER
                                                       : renodx::mods::swapchain::SwapChainUpgradeTarget::ANY),
                .usage_include = reshade::api::resource_usage::render_target,
            });
            std::stringstream s;
            s << "Applying user resource upgrade for ";
            s << format << ": " << value;
            reshade::log::message(reshade::log::level::info, s.str().c_str());
          }
        }

        initialized = true;
      }
     renodx::mods::swapchain::resource_upgrade_infos.push_back({
    .old_format = reshade::api::format::r8g8b8a8_unorm,
    .new_format = reshade::api::format::r16g16b16a16_float,
    
});
renodx::mods::swapchain::resource_upgrade_infos.push_back({
    .old_format = reshade::api::format::r8g8b8a8_typeless,
    .new_format = reshade::api::format::r16g16b16a16_float,
    
});
renodx::mods::swapchain::resource_upgrade_infos.push_back({
    .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
    .new_format = reshade::api::format::r16g16b16a16_float,
    
});
/* renodx::mods::swapchain::resource_upgrade_infos.push_back({
    .old_format = reshade::api::format::b8g8r8a8_unorm,
    .new_format = reshade::api::format::r16g16b16a16_float,
    .dimensions = {.width = 960, .height = 540},

    .usage_include = reshade::api::resource_usage::render_target,
   
}); */

renodx::mods::swapchain::resource_upgrade_infos.push_back({
    .old_format = reshade::api::format::b8g8r8a8_unorm,
    .new_format = reshade::api::format::r16g16b16a16_float,
   
});
renodx::mods::swapchain::resource_upgrade_infos.push_back({
    .old_format = reshade::api::format::r10g10b10a2_unorm,
    .new_format = reshade::api::format::r16g16b16a16_float,
    
});
renodx::mods::swapchain::resource_upgrade_infos.push_back({
    .old_format = reshade::api::format::b10g10r10a2_unorm,
    .new_format = reshade::api::format::r16g16b16a16_float,
    
});
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);


  return TRUE;
}