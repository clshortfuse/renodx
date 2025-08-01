/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x00000000),

    // final
    CustomShaderEntry(0x3D461B1A),  // game
    CustomShaderEntry(0x224A8BF5),  // main menu

    // tonemap
    CustomShaderEntry(0x59F328E3),  // game
    CustomShaderEntry(0x1744B1D4),  // main menu

    // extra
    CustomShaderEntry(0x8F563B81),  // fulscreen fx slide
    CustomShaderEntry(0x8324B585),  // rec709 disabled

    // ui
    CustomShaderEntry(0x11920281),
    CustomShaderEntry(0x2B62907A),
    CustomShaderEntry(0x3DE15138),
    CustomShaderEntry(0x54AFA103),
    CustomShaderEntry(0x5AC2F001),
    CustomShaderEntry(0x835A90CD),
    CustomShaderEntry(0x95E507B2),
    CustomShaderEntry(0x9CFEB747),
    CustomShaderEntry(0xB00EE6B3),
    CustomShaderEntry(0xBC5DA296),
    CustomShaderEntry(0xBCC9B252),
    CustomShaderEntry(0xC1B964B5),
    CustomShaderEntry(0xED7F350C),

    // CustomSwapchainShader(0x00000000),

    // BypassShaderEntry(0x00000000)

};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

const std::unordered_map<std::string, float> PRESET_RENODRT = {
    {"ToneMapType", 3.f},
    {"ColorGradeExposure", 1.f},
    {"ColorGradeHighlights", 50.f},
    {"ColorGradeShadows", 50.f},
    {"ColorGradeSaturation", 50.f},
    {"ColorGradeHighlightSaturation", 50.f},
    {"ColorGradeBlowout", 0.f},
    {"ColorGradeFlare", 35.f},
};

const std::unordered_map<std::string, float> PRESET_ACES = {
    {"ToneMapType", 2.f},
    {"ColorGradeExposure", 1.5f},
    {"ColorGradeHighlights", 50.f},
    {"ColorGradeShadows", 60.f},
    {"ColorGradeSaturation", 50.f},
    {"ColorGradeHighlightSaturation", 50.f},
    {"ColorGradeBlowout", 0.f},
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .group = "button-line-1",
        .on_change = []() {
          for (auto setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
          renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: RenoDRT",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (PRESET_RENODRT.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_RENODRT.at(setting->key));
            }
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: ACES",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (PRESET_ACES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, PRESET_ACES.at(setting->key));
            }
          }
        },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla (Unsupported)", "None", "ACES", "RenoDRT"},
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
        .min = 1.f,
        .max = 10000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 1.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 1.f,
        .max = 500.f,
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
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
        .key = "ExtraTradeOffRatio",
        .binding = &shader_injection.custom_tradeoff_ratio,
        .default_value = 10.f,
        .label = "Brightness Tradeoff Ratio",
        .section = "Extra",
        .tooltip = "The lower the value, the more accurate (R11G11B10_FLOAT) and higher max brightness (<30 reaches 10000nits) can be achieved, at the cost of overly bright fullscreen overlay shaders.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ExtraFullscreenShaderGamma",
        .binding = &shader_injection.custom_fullscreen_shader_gamma,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = true,
        .label = "Fullscreen Overlay Shader Gamma Correction",
        .section = "Extra",
        .tooltip = "Sets the gamma correction for fullscreen overlay shaders.",
        .labels = {"sRGB", "2.2", "2.4"},
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ExtraFullscreenShaderSaturation",
    //     .binding = &shader_injection.custom_fullscreen_shader_saturation,
    //     .default_value = 75.f,
    //     .label = "Fullscreen Overlay Shader Saturation",
    //     .section = "Extra",
    //     .tooltip = "Sets the saturation for fullscreen overlay shaders.",
    //     .max = 200.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    new renodx::utils::settings::Setting{
        .key = "ExtraBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Extra",
        .max = 500.f,
        .parse = [](float value) { return pow(value * 0.01f, 2.f); },
    },
    new renodx::utils::settings::Setting{
        .key = "ExtraSlideLensDirt",
        .binding = &shader_injection.custom_slide_lens_dirt,
        .default_value = 20.f,
        .label = "Slide Lens Dirt",
        .section = "Extra",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ExtraShowHUD",
        .binding = &shader_injection.custom_show_hud,
        .default_value = 1.f,
        .label = "Show HUD",
        .section = "Extra",
        .max = 1.f,
        .parse = [](float value) { return value; },
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
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Intermediate Encoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.gamma_correction + 1.f;
            return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.intermediate_encoding;
            return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Gamma Correction",
        .section = "Display Output",
        .labels = {"None", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Don't use Fullscreen.\n- Both HDR10 and scRGB seems to work.\n- Game settings for Rec.709 and sRGB doesn't do anything.\n- Majority of the LUTs need black level lowering.\n- Try ACES w/ high exposure. Some LUTs favor its hue shift.",
        .section = "Info",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "(Made by XgarhontX)",
        .section = "Info",
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDRDen Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
};

// const std::unordered_map<std::string, reshade::api::format> UPGRADE_TARGETS = {
//     // {"R8G8B8A8_TYPELESS", reshade::api::format::r8g8b8a8_typeless},
//     // {"B8G8R8A8_TYPELESS", reshade::api::format::b8g8r8a8_typeless},
//     {"R8G8B8A8_UNORM", reshade::api::format::r8g8b8a8_unorm},
//     // {"B8G8R8A8_UNORM", reshade::api::format::b8g8r8a8_unorm},
//     // {"R8G8B8A8_SNORM", reshade::api::format::r8g8b8a8_snorm},
//     // {"R8G8B8A8_UNORM_SRGB", reshade::api::format::r8g8b8a8_unorm_srgb},
//     // {"B8G8R8A8_UNORM_SRGB", reshade::api::format::b8g8r8a8_unorm_srgb},
//     // {"R10G10B10A2_TYPELESS", reshade::api::format::r10g10b10a2_typeless},
//     // {"R10G10B10A2_UNORM", reshade::api::format::r10g10b10a2_unorm},
//     // {"B10G10R10A2_UNORM", reshade::api::format::b10g10r10a2_unorm},
//     {"R11G11B10_FLOAT", reshade::api::format::r11g11b10_float},
//     // {"R16G16B16A16_TYPELESS", reshade::api::format::r16g16b16a16_typeless},
// };

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

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Call of Duty: Black Ops 3)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

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

        // {
        //   auto* setting = new renodx::utils::settings::Setting{
        //       .key = "SwapChainForceBorderless",
        //       .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        //       .default_value = 0.f,
        //       .label = "Force Borderless",
        //       .section = "Display Output",
        //       .tooltip = "Forces fullscreen to be borderless for proper HDR",
        //       .labels = {
        //           "Disabled",
        //           "Enabled",
        //       },
        //       .on_change_value = [](float previous, float current) { renodx::mods::swapchain::force_borderless = (current == 1.f); },
        //       .is_global = true,
        //       .is_visible = []() { return current_settings_mode >= 2; },
        //   };
        //   renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
        //   renodx::mods::swapchain::force_borderless = (setting->GetValue() == 1.f);
        //   settings.push_back(setting);
        // }

        {
          //   auto* setting = new renodx::utils::settings::Setting{
          //       .key = "SwapChainPreventFullscreen",
          //       .value_type = renodx::utils::settings::SettingValueType::INTEGER,
          //       .default_value = 0.f,
          //       .label = "Prevent Fullscreen",
          //       .section = "Display Output",
          //       .tooltip = "Prevent exclusive fullscreen for proper HDR",
          //       .labels = {
          //           "Disabled",
          //           "Enabled",
          //       },
          //       .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
          //       .is_global = true,
          //       .is_visible = []() { return current_settings_mode >= 2; },
          //   };
          //   renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          //   renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
          //   settings.push_back(setting);
          renodx::mods::swapchain::prevent_full_screen = true;
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 5.f,
              .label = "Encoding (Restart Required)",
              .section = "Display Output",
              .labels = {"None", "SRGB (Unsupported)", "2.2 (Unsupported)", "2.4 (Unsupported)", "HDR10", "scRGB"},
              .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
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

          //   bool is_hdr10 = true;
          //   renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          //   renodx::mods::swapchain::use_resize_buffer = false;
          //   shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
        }

        //     for (const auto& [key, format] : UPGRADE_TARGETS) {
        //       auto* setting = new renodx::utils::settings::Setting{
        //           .key = "Upgrade_" + key,
        //           .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        //           .default_value = 0.f,
        //           .label = key,
        //           .section = "Resource Upgrades",
        //           .labels = {
        //               "Off",
        //               "Output size",
        //               "Output ratio",
        //               "Any size",
        //           },
        //           .is_global = true,
        //           .is_visible = []() { return settings[0]->GetValue() >= 2; },
        //       };
        //       renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
        //       settings.push_back(setting);

        //       auto value = setting->GetValue();
        //       if (value > 0) {
        //         renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //             .old_format = format,
        //             .new_format = reshade::api::format::r16g16b16a16_float,
        //             .ignore_size = (value == UPGRADE_TYPE_ANY),
        //             .use_resource_view_cloning = true,
        //             .aspect_ratio = static_cast<float>((value == UPGRADE_TYPE_OUTPUT_RATIO)
        //                                                    ? renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER
        //                                                    : renodx::mods::swapchain::SwapChainUpgradeTarget::ANY),
        //             .usage_include = reshade::api::resource_usage::render_target,
        //         });
        //         std::stringstream s;
        //         s << "Applying user resource upgrade for ";
        //         s << format << ": " << value;
        //         reshade::log::message(reshade::log::level::info, s.str().c_str());
        //       }
        //     }

        //     initialized = true;
        //   }

        //  RGBA8
        // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //     .old_format = reshade::api::format::r8g8b8a8_unorm,
        //     .new_format = reshade::api::format::r16g16b16a16_float,
        //     .ignore_size = true,
        //     .use_resource_view_cloning = true,
        //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,  // to catch lower internal res maybe
        //     .usage_include = reshade::api::resource_usage::resolve_source,
        // });
        // std::stringstream s;
        // s << "Applying user resource upgrade for r8g8b8a8_unorm";
        // reshade::log::message(reshade::log::level::info, s.str().c_str());

        /*
         * Can't do this, it crashes the renderer.
         */
        // //  RGBA8_UNORM_SRGB
        // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //     .old_format = reshade::api::format::r11g11b10_float,
        //     .new_format = reshade::api::format::r16g16b16_float,
        //     .ignore_size = true,
        //     .use_resource_view_cloning = true,
        //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::ANY,
        //     .usage_include = reshade::api::resource_usage::render_target,
        // });

        // std::stringstream s1;
        // s1 << "Applying user resource upgrade for r11g11b10_float";
        // reshade::log::message(reshade::log::level::info, s1.str().c_str());
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
