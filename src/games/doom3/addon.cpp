/*

 * Copyright (C) 2024 Carlos Lopez

 * SPDX-License-Identifier: MIT

 */



#define ImTextureID ImU64



#define DEBUG_LEVEL_0

#define RENODX_MODS_SWAPCHAIN_VERSION 2



#ifndef RENODX_WAIT_FOR_DEBUGGER

#define RENODX_WAIT_FOR_DEBUGGER 0

#endif



#include <Windows.h>



#include <deps/imgui/imgui.h>

#include <include/reshade.hpp>



#include <embed/shaders.h>



#include <sstream>

#include <string>

#include <unordered_map>



#include "../../mods/shader.hpp"

#include "../../mods/swapchain.hpp"

#include "../../utils/settings.hpp"

#include "./shared.h"
#include "./hidden_cursor.hpp"
#include "./opengl_framebuffer.hpp"



#ifndef RENODX_PSYCHOV30_SLIDER_LAYOUT_VERSION

#error "DOOM3: shared.h is outdated. Replace shared.h with the PsychoV30 slider version from the same package."

#endif



namespace {



renodx::mods::shader::CustomShaders custom_shaders = {

    // CustomShaderEntry(0x00000000),

    // CustomSwapchainShader(0x00000000),

    // BypassShaderEntry(0x00000000),

    //__ALL_CUSTOM_SHADERS

};



ShaderInjectData shader_injection;



float current_settings_mode = 0;



constexpr float TONE_MAP_TYPE_VANILLA = 0.f;

using doom3::opengl::TONE_MAP_TYPE_RENODRT;

using doom3::opengl::TONE_MAP_TYPE_PSYCHOV30;



inline bool IsCustomToneMapperEnabled() {

  return shader_injection.tone_map_type != TONE_MAP_TYPE_VANILLA;

}



inline bool IsRenoDRTEnabled() {

  return shader_injection.tone_map_type == TONE_MAP_TYPE_RENODRT;

}



inline bool IsPsychoV30Enabled() {

  return shader_injection.tone_map_type == TONE_MAP_TYPE_PSYCHOV30;

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

        .default_value = 1.f,

        .can_reset = true,

        .label = "Tone Mapper",

        .section = "Tone Mapping",

        .tooltip = "Forward HDR mapping of the preserved FP16 scene composite. Bypass skips custom tone mapping; RenoDRT and PsychoV30 operate on the unclamped scene before final scRGB encoding.",

        .labels = {"Bypass", "RenoDRT", "PsychoV30"},

        .parse = [](float value) {

          if (value < 0.5f) return TONE_MAP_TYPE_VANILLA;

          if (value < 1.5f) return TONE_MAP_TYPE_RENODRT;

          return TONE_MAP_TYPE_PSYCHOV30;

        },

        .is_visible = []() { return current_settings_mode >= 1; },

    },

    new renodx::utils::settings::Setting{

        .key = "ToneMapPeakNits",

        .binding = &shader_injection.peak_white_nits,

        .default_value = 1000.f,

        .can_reset = false,

        .label = "Peak Brightness",

        .section = "Tone Mapping",

        .tooltip = "Sets the value of peak white in nits",

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

        .tooltip = "Sets the brightness of UI and HUD elements in nits (used when Tone Map Before UI is on)",

        .min = 48.f,

        .max = 500.f,

    },

    new renodx::utils::settings::Setting{

        .key = "ToneMapBeforeUI",

        .binding = &shader_injection.custom_tone_map_before_ui,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 1.f,

        .label = "Tone Map Before UI",

        .section = "Tone Mapping",

        .tooltip = "Tone maps the 3D scene before Doom 3 draws its HUD and menus, so the UI is not tone mapped and uses UI Brightness.",

        .labels = {"Off", "On"},

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

    },

    new renodx::utils::settings::Setting{

        .key = "GammaCorrection",

        .binding = &shader_injection.gamma_correction,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 1.f,

        .label = "Gamma Correction",

        .section = "Tone Mapping",

        .tooltip = "Emulates a display EOTF.",

        .labels = {"Off", "2.2", "BT.1886"},

        .is_visible = []() { return current_settings_mode >= 1; },

    },

    new renodx::utils::settings::Setting{

        .key = "ToneMapScaling",

        .binding = &shader_injection.tone_map_per_channel,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Scaling",

        .section = "Tone Mapping",

        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",

        .labels = {"Luminance", "Per Channel"},

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

        .is_visible = []() { return current_settings_mode >= 2; },

    },

    new renodx::utils::settings::Setting{

        .key = "ToneMapWorkingColorSpace",

        .binding = &shader_injection.tone_map_working_color_space,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Working Color Space",

        .section = "Tone Mapping",

        .labels = {"BT709", "BT2020", "AP1"},

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

        .is_visible = []() { return false; },

    },

    new renodx::utils::settings::Setting{

        .key = "ToneMapHueProcessor",

        .binding = &shader_injection.tone_map_hue_processor,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Hue Processor",

        .section = "Tone Mapping",

        .tooltip = "Selects hue processor",

        .labels = {"OKLab", "ICtCp", "darkTable UCS"},

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

        .is_visible = []() { return false; },

    },

    new renodx::utils::settings::Setting{

        .key = "ToneMapHueCorrection",

        .binding = &shader_injection.tone_map_hue_correction,

        .default_value = 0.f,

        .label = "Hue Correction",

        .section = "Tone Mapping",

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

        .default_value = 50.f,

        .label = "Hue Shift",

        .section = "Tone Mapping",

        .tooltip = "Hue-shift emulation strength.",

        .min = 0.f,

        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

        .parse = [](float value) { return value * 0.01f; },

        .is_visible = []() { return false; },

    },

    new renodx::utils::settings::Setting{

        .key = "ToneMapClampColorSpace",

        .binding = &shader_injection.tone_map_clamp_color_space,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Clamp Color Space",

        .section = "Tone Mapping",

        .tooltip = "Hue-shift emulation strength.",

        .labels = {"None", "BT709", "BT2020", "AP1"},

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

        .parse = [](float value) { return value - 1.f; },

        .is_visible = []() { return false; },

    },

    new renodx::utils::settings::Setting{

        .key = "ToneMapClampPeak",

        .binding = &shader_injection.tone_map_clamp_peak,

        .value_type = renodx::utils::settings::SettingValueType::INTEGER,

        .default_value = 0.f,

        .label = "Clamp Peak",

        .section = "Tone Mapping",

        .tooltip = "Hue-shift emulation strength.",

        .labels = {"None", "BT709", "BT2020", "AP1"},

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

        .parse = [](float value) { return value - 1.f; },

        .is_visible = []() { return false; },

    },

    new renodx::utils::settings::Setting{

        .key = "ColorGradeExposure",

        .binding = &shader_injection.tone_map_exposure,

        .default_value = 1.f,

        .label = "Exposure",

        .section = "Color Grading",

        .max = 2.f,

        .format = "%.2f",

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

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

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

        .is_enabled = []() { return IsRenoDRTEnabled(); },

        .parse = [](float value) { return value * 0.02f; },

    },

    new renodx::utils::settings::Setting{

        .key = "PsychoV30Compression",
        .binding = &shader_injection.psychov30_compression,
        .default_value = 0.f,
        .label = "PsychoV30 Compression",
        .section = "Color Grading",
        .tooltip = "PsychoV30 response compression. 0 = auto; 50 = 1.00; 100 = 2.00; 200 = 4.00.",
        .min = 0.f,
        .max = 400.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV30Enabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV30ConeResponse",
        .binding = &shader_injection.psychov30_cone_response,
        .default_value = 50.f,
        .label = "PsychoV30 Cone Response",
        .section = "Color Grading",
        .tooltip = "PsychoV30 cone-response exponent. 50 = 1.00 neutral.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV30Enabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV30PurityScale",
        .binding = &shader_injection.psychov30_purity_scale,
        .default_value = 100.f,
        .label = "PsychoV30 Purity",
        .section = "Color Grading",
        .tooltip = "Adaptation-relative LMS purity scale. 100% = neutral.",
        .min = 0.f,
        .max = 200.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsPsychoV30Enabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV30GamutCompression",
        .binding = &shader_injection.psychov30_gamut_compression,
        .default_value = 100.f,
        .label = "PsychoV30 Gamut Compression",
        .section = "Color Grading",
        .tooltip = "PsychoV30 target-volume projection strength.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsPsychoV30Enabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV30GamutMode",
        .binding = &shader_injection.psychov30_gamut_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "PsychoV30 Target Gamut",
        .section = "Color Grading",
        .labels = {"BT709", "BT2020"},
        .is_enabled = []() { return IsPsychoV30Enabled(); },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{
        .key = "PsychoV30SourceBoundary",
        .binding = &shader_injection.psychov30_source_boundary,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "PsychoV30 Source Boundary",
        .section = "Color Grading",
        .tooltip = "Selects the source-boundary treatment used by PsychoV30.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsPsychoV30Enabled(); },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{

        .key = "ColorGradeScene",

        .binding = &shader_injection.color_grade_strength,

        .default_value = 100.f,

        .label = "Scene Grading",

        .section = "Color Grading",

        .tooltip = "Scene grading as applied by the game",

        .max = 100.f,

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

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

                   "\nDefault: US CRT",

        .labels = {

            "US Modern",

            "JPN Modern",

            "US CRT",

            "JPN CRT",

        },

        .is_visible = []() { return current_settings_mode >= 1; },

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

            return value - 1.f; },

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

            return value - 1.f; },

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

        .default_value = 1.f,

        .label = "Clamp Color Space",

        .section = "Display Output",

        .labels = {"None", "BT709", "BT2020", "AP1"},

        .is_enabled = []() { return IsCustomToneMapperEnabled(); },

        .parse = [](float value) { return value - 1.f; },

        .is_visible = []() { return false; },

    },

};



const std::unordered_map<std::string, reshade::api::format> UPGRADE_TARGETS = {

    /* {"R8G8B8A8_TYPELESS", reshade::api::format::r8g8b8a8_typeless},

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

    {"R16G16B16A16_TYPELESS", reshade::api::format::r16g16b16a16_typeless}, */

};



void OnPresetOff() {

  //   renodx::utils::settings::UpdateSetting("toneMapType", 0.f);

  //   renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);

  //   renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);

  //   renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);

  //   renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);

  //   renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);

  //   renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);

  //   renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);

  //   renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);

  //   renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);

  //   renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);

  //   renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);

}



const auto UPGRADE_TYPE_NONE = 0.f;

const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;

const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;

const auto UPGRADE_TYPE_ANY = 3.f;


bool IsSteamLaunchEnvironment() {
  char value[64] = {};
  if (GetEnvironmentVariableA("SteamAppId", value, static_cast<DWORD>(sizeof(value))) != 0) return true;
  if (GetEnvironmentVariableA("SteamGameId", value, static_cast<DWORD>(sizeof(value))) != 0) return true;
  if (GetEnvironmentVariableA("SteamOverlayGameId", value, static_cast<DWORD>(sizeof(value))) != 0) return true;
  return false;
}

#if RESHADE_API_VERSION >= 17
bool OnCreateSteamAuxiliarySwapchain(reshade::api::device_api device_api,
                                      reshade::api::swapchain_desc& desc,
                                      void* hwnd) {
#else
bool OnCreateSteamAuxiliarySwapchain(reshade::api::swapchain_desc& desc,
                                      void* hwnd) {
  const auto device_api = reshade::api::device_api::d3d11;
#endif
  if (!IsSteamLaunchEnvironment()) return false;
  if (device_api != reshade::api::device_api::d3d11) return false;
  if (hwnd == nullptr) return false;

  char class_name[64] = {};
  if (GetClassNameA(static_cast<HWND>(hwnd), class_name, static_cast<int>(sizeof(class_name))) <= 0) return false;
  if (std::string(class_name) != "SDL_app") return false;

  // Signature observed only for the competing Steam-side D3D11 swapchain:
  //   BGRA8, 2 buffers, FLIP_SEQUENTIAL, flags 0x802, same SDL HWND.
  // RenoDX's real HDR proxy is FP16 + FLIP_DISCARD, so it cannot match this.
  constexpr uint32_t kFlipSequential = 3u;   // DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL
  constexpr uint32_t kDiscard = 0u;          // DXGI_SWAP_EFFECT_DISCARD
  constexpr uint32_t kAllowTearing = 0x800u; // DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING
  constexpr uint32_t kObservedAuxFlags = 0x802u;

  if (desc.back_buffer.texture.format != reshade::api::format::b8g8r8a8_unorm) return false;
  if (desc.back_buffer_count != 2u) return false;
  if (desc.present_mode != kFlipSequential) return false;
  if ((desc.present_flags & kObservedAuxFlags) != kObservedAuxFlags) return false;
  if (desc.fullscreen_state) return false;

  // If RenoDX (or another flip-model chain) already owns this HWND, leave the
  // auxiliary request unchanged. DXGI will reject it just like the successful
  // non-Steam launch, where the RenoDX HDR proxy wins the HWND first.
  if (renodx::mods::swapchain::flip_swapchains_by_window.contains(static_cast<HWND>(hwnd))) {
    reshade::log::message(
        reshade::log::level::info,
        "[RenoDX] [Doom3 GL] Steam auxiliary D3D11 flip swapchain arrived after the HDR owner; leaving it unchanged so DXGI can reject it.");
    return false;
  }

  // If the auxiliary chain wins the race before RenoDX, do not let it occupy
  // the single flip-model slot for this HWND. Convert only this exact request
  // to legacy blt/discard and remove tearing. This preserves the caller while
  // keeping the HWND available for RenoDX's FP16 FLIP_DISCARD proxy.
  desc.present_mode = kDiscard;
  desc.present_flags &= ~kAllowTearing;
  desc.fullscreen_state = false;

  reshade::log::message(
      reshade::log::level::warning,
      "[RenoDX] [Doom3 GL] Steam auxiliary BGRA8 flip swapchain matched; forcing legacy DISCARD so it cannot steal the Doom 3 flip-model HWND from the HDR proxy.");
  return true;
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

}



bool initialized = false;



}  // namespace



extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";

extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Generic)";



BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {

  switch (fdw_reason) {

    case DLL_PROCESS_ATTACH:

      if (!reshade::register_addon(h_module)) return FALSE;

      // Steam can race RenoDX with an auxiliary BGRA8 flip-model D3D11
      // swapchain on Doom 3's SDL HWND. Register this before mods::swapchain
      // attaches so the exact auxiliary signature can be de-flipped first.
      reshade::register_event<reshade::addon_event::create_swapchain>(OnCreateSteamAuxiliarySwapchain);



#if RENODX_WAIT_FOR_DEBUGGER

      OutputDebugStringA("[RenoDX Addon] Waiting for debugger before initialization...\n");

      while (IsDebuggerPresent() == FALSE) {

        Sleep(100);

      }

      DebugBreak();

#endif



      if (!initialized) {

        renodx::mods::shader::force_pipeline_cloning = true;

        renodx::mods::shader::expected_constant_buffer_space = 50;

        renodx::mods::shader::expected_constant_buffer_index = 13;

        renodx::mods::shader::allow_multiple_push_constants = true;



        renodx::mods::swapchain::expected_constant_buffer_index = 13;

        renodx::mods::swapchain::expected_constant_buffer_space = 50;

        renodx::mods::swapchain::use_resource_cloning = true;

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



        {

          auto* setting = new renodx::utils::settings::Setting{

              .key = "SwapChainForceBorderless",

              .value_type = renodx::utils::settings::SettingValueType::INTEGER,

              .default_value = 0.f,

              .label = "Force Borderless",

              .section = "Display Output",

              .tooltip = "Forces fullscreen to be borderless for proper HDR",

              .labels = {

                  "Disabled",

                  "Enabled",

              },

              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::force_borderless = (current == 1.f); },

              .is_global = true,

              .is_visible = []() { return current_settings_mode >= 2; },

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

              .is_visible = []() { return current_settings_mode >= 2; },

          };

          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);

          renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);

          settings.push_back(setting);

        }



        {

          auto* setting = new renodx::utils::settings::Setting{

              .key = "SwapChainEncoding",

              .binding = &shader_injection.swap_chain_encoding,

              .value_type = renodx::utils::settings::SettingValueType::INTEGER,

              .default_value = 5.f,

              .label = "Encoding",

              .section = "Display Output",

              .labels = {"None", "SRGB", "2.2", "2.4", "HDR10", "scRGB"},

              .is_enabled = []() { return IsCustomToneMapperEnabled(); },

              .on_change_value = [](float previous, float current) {

                bool is_hdr10 = current == 4;

                shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f);

                // return void

              },

              .is_global = true,

              .is_visible = []() { return current_settings_mode >= 2; },

          };

          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);

          bool is_hdr10 = setting->GetValue() == 4;

          renodx::mods::swapchain::SetUseHDR10(is_hdr10);

          renodx::mods::swapchain::use_resize_buffer = setting->GetValue() < 4;

          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;

          settings.push_back(setting);

        }



        {

          auto* setting = new renodx::utils::settings::Setting{

              .key = "SwapChainDeviceProxy",

              .value_type = renodx::utils::settings::SettingValueType::INTEGER,

              // BO2 currently requires the proxy shader for correct scRGB/nits scaling.

              // The proxy-off direct test bypassed that scaling and peaked near 80 nits.

              .default_value = 1.f,

              .label = "Use Display Proxy",

              .section = "Display Proxy",

              .labels = {"Off", "On"},

              .is_global = true,

              .is_visible = []() { return current_settings_mode >= 2; },

          };

          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);

          bool use_device_proxy = setting->GetValue() == 1.f;

          renodx::mods::swapchain::use_device_proxy = use_device_proxy;

          renodx::mods::swapchain::set_color_space = !use_device_proxy;

          if (use_device_proxy) {

            reshade::register_event<reshade::addon_event::present>(OnPresent);

          } else {

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

              .is_visible = []() { return current_settings_mode >= 2; },

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

              .is_visible = []() { return current_settings_mode >= 2; },

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

            renodx::mods::swapchain::resource_upgrade_infos.push_back({

                .old_format = format,

                .new_format = reshade::api::format::r16g16b16a16_float,

                .ignore_size = (value == UPGRADE_TYPE_ANY),

                .use_resource_view_cloning = true,

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

       // Upgrade Doom 3 scene render targets at supported aspect ratios.

const reshade::api::format scene_intermediate_formats[] = {

    reshade::api::format::r8g8b8a8_unorm,

    reshade::api::format::r8g8b8a8_typeless,

    reshade::api::format::r8g8b8a8_unorm_srgb,

    reshade::api::format::b8g8r8a8_unorm,

    reshade::api::format::r10g10b10a2_unorm,

    reshade::api::format::b10g10r10a2_unorm,

};



const float scene_intermediate_aspect_ratios[] = {

    16.f / 9.f,    // Standard widescreen

    16.f / 10.f,

    24.f / 10.f,   // 3840x1600

    43.f / 18.f,   // 3440x1440

    64.f / 27.f,   // 5120x2160

};



for (const auto old_format : scene_intermediate_formats) {

  for (const float aspect_ratio : scene_intermediate_aspect_ratios) {

    renodx::mods::swapchain::resource_upgrade_infos.push_back({

        .old_format = old_format,

        .new_format = reshade::api::format::r16g16b16a16_float,

        .ignore_size = false,

        .aspect_ratio = aspect_ratio,

        .aspect_ratio_tolerance = 0.001f,
        .use_resource_view_cloning = true,
        .use_resource_view_hot_swap = false,
        .usage_include = reshade::api::resource_usage::render_target,

        .name = "Scene Intermediate",

    });

  }

}



        initialized = true;

      }



      break;

    case DLL_PROCESS_DETACH:

      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_event<reshade::addon_event::create_swapchain>(OnCreateSteamAuxiliarySwapchain);

      reshade::unregister_addon(h_module);

      break;

  }



  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  doom3::opengl::Use(fdw_reason, &shader_injection);
  doom3::cursor::Use(fdw_reason);



  return TRUE;

}
