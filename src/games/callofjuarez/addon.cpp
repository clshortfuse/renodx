/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <windows.h>

#include <deps/imgui/imgui.h>
#include <excpt.h>
#include <tlhelp32.h>
#include <array>
#include <include/reshade.hpp>
#include <sstream>

#include <unordered_map>
#include <vector>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/vtable.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x00000000),
    // CustomSwapchainShader(0x00000000),
    // BypassShaderEntry(0x00000000),
    __ALL_CUSTOM_SHADERS
};

float current_settings_mode = 0;
float exclusive_fullscreen_detected = 0.f;
renodx::utils::settings::Setting* exclusive_fullscreen_warning_setting = nullptr;

reshade::api::swapchain* tracked_swapchain = nullptr;
std::optional<reshade::api::color_space> next_color_space = std::nullopt;

renodx::utils::settings::Settings settings = {
    exclusive_fullscreen_warning_setting = new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Exclusive fullscreen detected. Mod automatically swaps it for borderless.",
        .tint = 0xFFF600,
        .is_visible = []() { return exclusive_fullscreen_detected != 0.f; },
        .is_sticky = true,
    },
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
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .parse = [](float value) { return value * 3.f; },
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
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    // new renodx::utils::settings::Setting{
    //     .key = "HDRVideos",
    //     .binding = &shader_injection.Custom_HDR_Videos,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 1.f,
    //     .label = "HDR Videos",
    //     .section = "Tone Mapping",
    //     .tooltip = "Enables HDR inverse tone mapping for in-game videos.",
    //     .labels = {"Off", "On"},
    // },
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
        .default_value = 1.f,
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
        .default_value = 1.f,
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
        .default_value = 2.f,
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
        .default_value = 0.f,
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
        .default_value = 0.f,
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
        .default_value = 2.f,
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
        .default_value = 2.f,
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
        .default_value = 45.f,
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
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 0.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
        //.is_visible = []() { return current_settings_mode >= 2; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "BloomImproved",
        .binding = &shader_injection.Custom_Bloom_Improved,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Improved Bloom toggle",
        .section = "Game FX",
        .tooltip = "Vanilla bloom is low quality single pass blur. This enables additional blur to improve quality.",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "BloomAmount",
        .binding = &shader_injection.Custom_Bloom_Amount,
        .default_value = 50.f,
        .label = "Bloom Amount",
        .section = "Game FX",
        .tooltip = "Bloom effect amount. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "BloomThreshold",
        .binding = &shader_injection.Custom_Bloom_Threshold,
        .default_value = 0.f,
        .label = "Bloom Threshold",
        .section = "Game FX",
        .tooltip = "Bloom contrast on the input texture. 0 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "BloomRadius",
        .binding = &shader_injection.Custom_Bloom_Radius,
        .default_value = 50.f,
        .label = "Bloom Radius",
        .section = "Game FX",
        .tooltip = "New improved Bloom effect radius.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
      new renodx::utils::settings::Setting{
        .key = "ExposureAdaptation",
        .binding = &shader_injection.Custom_Exposure_Adaptation,
        .default_value = 100.f,
        .label = "Exposure Adaptation",
        .section = "Game FX",
        .tooltip = "Eye adaptation is incredibly aggressive, to the point where simple act of reloading the guns makes the screen brightness flicker. 0 - disabled completely, 100 - Vanilla",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "EmissivesGlow",
        .binding = &shader_injection.Custom_Emissives_Glow,
        .default_value = 50.f,
        .label = "Emissives Glow Intensity",
        .section = "Game FX",
        .tooltip = "Emissives glow intensity. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "EmissivesGlowContrast",
        .binding = &shader_injection.Custom_Emissives_Glow_Contrast,
        .default_value = 50.f,
        .label = "Emissives Glow Contrast",
        .section = "Game FX",
        .tooltip = "Emissives glow contrast. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "EmissivesGlowSaturation",
        .binding = &shader_injection.Custom_Emissives_Glow_Saturation,
        .default_value = 50.f,
        .label = "Emissives Glow Saturation",
        .section = "Game FX",
        .tooltip = "Emissives glow saturation. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
        new renodx::utils::settings::Setting{
        .key = "EmissivesFireGlow",
        .binding = &shader_injection.Custom_Emissives_Fire_Glow,
        .default_value = 50.f,
        .label = "Emissives Fire Glow",
        .section = "Game FX",
        .tooltip = "Emissives fire glow amount. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "VolumetricAmount",
        .binding = &shader_injection.Custom_Volumetrics_Amount,
        .default_value = 50.f,
        .label = "Volumetric Amount",
        .section = "Game FX - Sky",
        .tooltip = "Volumetric lighting effect amount. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SkySunSpriteIntensity",
        .binding = &shader_injection.Custom_Sky_SunSpriteIntensity,
        .default_value = 50.f,
        .label = "Sky Sun Sprite Intensity",
        .section = "Game FX - Sky",
        .tooltip = "Sun sprite intensity. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SkyLuminariesGlow",
        .binding = &shader_injection.Custom_Sky_Luminaries_Glow,
        .default_value = 50.f,
        .label = "Sky Luminaries Glow",
        .section = "Game FX - Sky",
        .tooltip = "Sky luminaries (Sun, Moon) glow amount. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SkyLuminariesGlowContrast",
        .binding = &shader_injection.Custom_Sky_Luminaries_Glow_Contrast,
        .default_value = 50.f,
        .label = "Sky Luminaries Glow Contrast",
        .section = "Game FX - Sky",
        .tooltip = "Sky luminaries (Sun, Moon) glow amount contrast. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SkyLuminariesGlowSaturation",
        .binding = &shader_injection.Custom_Sky_Luminaries_Glow_Saturation,
        .default_value = 50.f,
        .label = "Sky Luminaries Glow Saturation",
        .section = "Game FX - Sky",
        .tooltip = "Sky luminaries (Sun, Moon) glow saturation. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SkySkyboxGlow",
        .binding = &shader_injection.Custom_Sky_Skybox_Glow,
        .default_value = 50.f,
        .label = "Sky Skybox Glow",
        .section = "Game FX - Sky",
        .tooltip = "Sky skybox glow amount. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SkySkyboxGlowContrast",
        .binding = &shader_injection.Custom_Sky_Skybox_Glow_Contrast,
        .default_value = 50.f,
        .label = "Sky Skybox Glow Contrast",
        .section = "Game FX - Sky",
        .tooltip = "Sky skybox glow amount contrast. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SkySkyboxGlowSaturation",
        .binding = &shader_injection.Custom_Sky_Skybox_Glow_Saturation,
        .default_value = 50.f,
        .label = "Sky Skybox Glow Saturation",
        .section = "Game FX - Sky",
        .tooltip = "Sky skybox glow saturation. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
        new renodx::utils::settings::Setting{
        .key = "SkyCloudsGlow",
        .binding = &shader_injection.Custom_Sky_Clouds_Glow,
        .default_value = 50.f,
        .label = "Sky Clouds Glow",
        .section = "Game FX - Sky",
        .tooltip = "Sky clouds glow amount. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SkyCloudsGlowContrast",
        .binding = &shader_injection.Custom_Sky_Clouds_Glow_Contrast,
        .default_value = 50.f,
        .label = "Sky Clouds Glow Contrast",
        .section = "Game FX - Sky",
        .tooltip = "Sky clouds glow amount contrast. 50 is vanilla amount.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
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
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
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
        .default_value = 1.f,
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
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .tint = 0xE50067,
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Look",
        .section = "Options",
        .group = "button-line-1",
        .tint = 0x3FD9B9,
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
            {"tonemapGameNits", 203.f},
            {"colorGradeExposure", 1.f},
            {"colorGradeHighlights", 50.f},
            {"colorGradeShadows", 50.f},
            {"colorGradeContrast", 50.f},
            {"colorGradeSaturation", 50.f},
            {"ColorGradeHighlightSaturation", 45.f},
            {"BloomImproved", 1.f},
            {"BloomAmount", 15.f},
            {"BloomThreshold", 15.f},
            {"BloomRadius", 60.f},
            {"ExposureAdaptation", 35.f},
            {"EmissivesGlow", 100.f},
            {"EmissivesGlowContrast", 75.f},
            {"EmissivesGlowSaturation", 75.f},
            {"EmissivesFireGlow", 45.f},
            {"VolumetricAmount", 15.f},
            {"SkySunSpriteIntensity", 65.f},
            {"SkyLuminariesGlow", 100.f},
            {"SkyLuminariesGlowContrast", 70.f},
            {"SkyLuminariesGlowSaturation", 70.f},
            {"SkySkyboxGlow", 100.f},
            {"SkySkyboxGlowContrast", 50.f},
            {"SkySkyboxGlowSaturation", 70.f},
            {"SkyCloudsGlow", 100.f},
            {"SkyCloudsGlowContrast", 70.f},
          });
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
};

bool OnSetFullscreenState(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
  if (fullscreen) {
    exclusive_fullscreen_detected = 1.f;
  }
  return false;
}

const std::unordered_map<std::string, reshade::api::format> UPGRADE_TARGETS = {
    // {"BC3_UNORM", reshade::api::format::bc3_unorm},
    // {"R8G8B8A8_TYPELESS", reshade::api::format::r8g8b8a8_typeless},
    // {"B8G8R8A8_TYPELESS", reshade::api::format::b8g8r8a8_typeless},
    {"R8G8B8A8_UNORM", reshade::api::format::r8g8b8a8_unorm},
    // {"B8G8R8A8_UNORM", reshade::api::format::b8g8r8a8_unorm},
    // {"R8G8B8A8_SNORM", reshade::api::format::r8g8b8a8_snorm},
    // {"R8G8B8A8_UNORM_SRGB", reshade::api::format::r8g8b8a8_unorm_srgb},
    // {"B8G8R8A8_UNORM_SRGB", reshade::api::format::b8g8r8a8_unorm_srgb},
    // {"R10G10B10A2_TYPELESS", reshade::api::format::r10g10b10a2_typeless},
    // {"R10G10B10A2_UNORM", reshade::api::format::r10g10b10a2_unorm},
    // {"B10G10R10A2_UNORM", reshade::api::format::b10g10r10a2_unorm},
    // {"R11G11B10_FLOAT", reshade::api::format::r11g11b10_float},
    // {"R16G16B16A16_TYPELESS", reshade::api::format::r16g16b16a16_typeless},
};

void OnPresetOff() {
    renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
    renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
    renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
    renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
    renodx::utils::settings::UpdateSetting("HDRVideos", 0.f);
    renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
    renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
    renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
    renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
    renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
    renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
    renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 45.f),
    renodx::utils::settings::UpdateSetting("BloomImproved", 0.f);
    renodx::utils::settings::UpdateSetting("BloomAmount", 50.f);
    renodx::utils::settings::UpdateSetting("BloomThreshold", 0.f);
    renodx::utils::settings::UpdateSetting("BloomRadius", 50.f);
    renodx::utils::settings::UpdateSetting("ExposureAdaptation", 100.f);
    renodx::utils::settings::UpdateSetting("EmissivesGlow", 50.f);
    renodx::utils::settings::UpdateSetting("EmissivesGlowContrast", 50.f);
    renodx::utils::settings::UpdateSetting("EmissivesGlowSaturation", 50.f);
    renodx::utils::settings::UpdateSetting("EmissivesFireGlow", 50.f);
    renodx::utils::settings::UpdateSetting("VolumetricAmount", 50.f);
    renodx::utils::settings::UpdateSetting("SkySunSpriteIntensity", 50.f);
    renodx::utils::settings::UpdateSetting("SkyLuminariesGlow", 50.f);
    renodx::utils::settings::UpdateSetting("SkyLuminariesGlowContrast", 50.f);
    renodx::utils::settings::UpdateSetting("SkyLuminariesGlowSaturation", 50.f);
    renodx::utils::settings::UpdateSetting("SkySkyboxGlow", 50.f);
    renodx::utils::settings::UpdateSetting("SkySkyboxGlowContrast", 50.f);
    renodx::utils::settings::UpdateSetting("SkySkyboxGlowSaturation", 50.f);
    renodx::utils::settings::UpdateSetting("SkyCloudsGlow", 50.f);
    renodx::utils::settings::UpdateSetting("SkyCloudsGlowContrast", 50.f);
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  auto* device = queue->get_device();
  //if (device->get_api() == reshade::api::device_api::opengl) {
  //  shader_injection.custom_flip_uv_y = 1.f;
  //}
}

decltype(&TerminateProcess) real_TerminateProcess = nullptr;
BOOL WINAPI HookTerminateProcess(HANDLE hProcess, UINT uExitCode) {
  DWORD targetPid = 0;
  if (hProcess != nullptr) {
    targetPid = GetProcessId(hProcess);
  }
  if (targetPid == 0 || targetPid == GetCurrentProcessId()) {
    OutputDebugStringW(L"HookTerminateProcess: intercepted TerminateProcess for current process\n");
  }
  return real_TerminateProcess(hProcess, uExitCode);
}

decltype(&ExitProcess) real_ExitProcess = nullptr;
VOID WINAPI HookExitProcess(UINT uExitCode) {
  OutputDebugStringW(L"HookExitProcess: intercepted ExitProcess\n");
  real_ExitProcess(uExitCode);
}

extern "C" IMAGE_DOS_HEADER __ImageBase;

void SetupPinnedModule() {
  static bool setup_pinned_module = false;
  static std::array<renodx::utils::vtable::HookItem, 2> g_process_hook_items = {{
      {"ExitProcess", reinterpret_cast<void**>(&real_ExitProcess), reinterpret_cast<void*>(&HookExitProcess)},
      {"TerminateProcess", reinterpret_cast<void**>(&real_TerminateProcess), reinterpret_cast<void*>(&HookTerminateProcess)},
  }};

  if (setup_pinned_module) return;

  HMODULE h_module = nullptr;
  auto ret = GetModuleHandleExW(
      GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
      reinterpret_cast<LPCWSTR>(&__ImageBase),
      &h_module);
  if (ret == 0 || h_module == nullptr) {
    std::stringstream s;
    s << "Failed to pin addon module: " << std::hex << GetLastError();
    reshade::log::message(reshade::log::level::error, s.str().c_str());

    // Attempt to increment instead:

    ret = GetModuleHandleExW(
        GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS,
        reinterpret_cast<LPCWSTR>(&__ImageBase),
        &h_module);

    if (ret == 0 || h_module == nullptr) {
      std::stringstream s;
      s << "Failed to increment addon module ref count: " << std::hex << GetLastError();
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      return;
    }
    reshade::log::message(reshade::log::level::debug, "Incremented addon module");
  } else {
    reshade::log::message(reshade::log::level::debug, "Pinned addon module");
  }

  HMODULE h_kernel = GetModuleHandleW(L"kernel32.dll");
  if (h_kernel == nullptr) {
    reshade::log::message(reshade::log::level::error, "Failed to get handle for kernel32.dll");
  }
  bool hooked = renodx::utils::vtable::Hook(h_kernel, g_process_hook_items);
  if (!hooked) {
    reshade::log::message(reshade::log::level::error, "Failed to hook process termination APIs");
    return;
  }
  reshade::log::message(reshade::log::level::debug, "Hooked process termination APIs");
  setup_pinned_module = true;
}

bool initialized = false;
bool addon_registered = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Generic)";

extern "C" __declspec(dllexport) void AddonInit(HMODULE addon_module, HMODULE reshade_module) {
  if (!addon_registered) {
    if (!reshade::register_addon(addon_module)) return;
  }

  reshade::register_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
  renodx::utils::settings::Use(DLL_PROCESS_ATTACH, &settings, &OnPresetOff);
  renodx::utils::swapchain::Use(DLL_PROCESS_ATTACH);
  renodx::mods::swapchain::Use(DLL_PROCESS_ATTACH, &shader_injection);
  renodx::mods::shader::Use(DLL_PROCESS_ATTACH, custom_shaders, &shader_injection);
  renodx::utils::random::Use(DLL_PROCESS_ATTACH);
  reshade::register_event<reshade::addon_event::present>(OnPresent);
}

extern "C" __declspec(dllexport) void AddonUninit(HMODULE addon_module, HMODULE reshade_module) {
  reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
  renodx::utils::settings::Use(DLL_PROCESS_DETACH, &settings, &OnPresetOff);
  renodx::utils::swapchain::Use(DLL_PROCESS_DETACH);
  renodx::mods::swapchain::Use(DLL_PROCESS_DETACH, &shader_injection);
  renodx::mods::shader::Use(DLL_PROCESS_DETACH, custom_shaders, &shader_injection);
  renodx::utils::random::Use(DLL_PROCESS_DETACH);
  reshade::unregister_event<reshade::addon_event::present>(OnPresent);
  reshade::unregister_addon(addon_module);
  addon_registered = false;
}

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      addon_registered = true;

      if (!initialized) {
        renodx::mods::swapchain::ignored_window_class_names = {
            "SplashScreenClass",
        };
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::SetUseHDR10(false);
        renodx::mods::swapchain::prevent_full_screen = false;
        renodx::mods::swapchain::force_borderless = true;
        renodx::mods::swapchain::swapchain_proxy_revert_state = true;
        renodx::mods::swapchain::use_auto_upgrade = false;
        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::force_screen_tearing = false;
        
        //renodx::mods::swapchain::device_proxy_wait_idle_source = true;
        //renodx::mods::swapchain::device_proxy_wait_idle_destination = true;
        renodx::mods::swapchain::swapchain_proxy_compatibility_mode = true;
        // renodx::mods::swapchain::swap_chain_proxy_shaders = {
        //     {
        //         reshade::api::device_api::d3d10,
        //         {
        //             .vertex_shader = __swap_chain_proxy_vertex_shader_dx10,
        //             .pixel_shader = __swap_chain_proxy_pixel_shader_dx10,
        //         },
        //     },
        //     {
        //         reshade::api::device_api::d3d11,
        //         {
        //             .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
        //             .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
        //         },
        //     },
        //     {
        //         reshade::api::device_api::d3d12,
        //         {
        //             .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
        //             .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
        //         },
        //     },
        // };
        renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
        renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

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
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .usage_include = reshade::api::resource_usage::render_target,
            //.usage_include = reshade::api::resource_usage::resolve_dest,
          });
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
          settings.push_back(setting);
        }

        for (const auto& [key, format] : UPGRADE_TARGETS) {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "Upgrade_" + key,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 3.f,
              .label = key,
              .section = "Resource Upgrades",
              .labels = {
                  "Off",
                  "Output size",
                  "Output ratio",
                  "Any size",
              },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          settings.push_back(setting);

          auto value = setting->GetValue();
          if (value > 0) {
            renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
                .old_format = format,
                .new_format = reshade::api::format::r16g16b16a16_float,
                .ignore_size = (value == UPGRADE_TYPE_ANY),
                .use_resource_view_cloning = true,
                .aspect_ratio = static_cast<float>((value == UPGRADE_TYPE_OUTPUT_RATIO)
                                                       ? renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER
                                                       : renodx::mods::swapchain::SwapChainUpgradeTarget::ANY),
                .usage_include = reshade::api::resource_usage::render_target,
                //.usage_include = reshade::api::resource_usage::resolve_dest,
            });
            std::stringstream s;
            s << "Applying user resource upgrade for ";
            s << format << ": " << value;
            reshade::log::message(reshade::log::level::info, s.str().c_str());
          }
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
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool use_device_proxy = setting->GetValue() == 1.f;
          renodx::mods::swapchain::use_device_proxy = use_device_proxy;
          renodx::mods::swapchain::set_color_space = !use_device_proxy;
          if (use_device_proxy) {
            reshade::register_event<reshade::addon_event::present>(OnPresent);
          } 
          //else {
          //  shader_injection.custom_flip_uv_y = 0.f;
          //}
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

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  //renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  //renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
