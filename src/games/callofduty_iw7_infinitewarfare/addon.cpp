/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <include/reshade_api_format.hpp>
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

namespace {

#define UpgradeRTVReplaceShader(value)       \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .code = __##value,                 \
          .on_draw = [](auto* cmd_list) {                                                             \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                         \
            bool changed = false;                                                                     \
            for (auto rtv : rtvs) {                                                                   \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv);   \
            }                                                                                         \
            if (changed) {                                                                            \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                    \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0}); \
            }                                                                                         \
            return true; }, \
      },                                     \
  }

#define UpgradeRTVShader(value)              \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .on_draw = [](auto* cmd_list) {                                                           \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                       \
            bool changed = false;                                                                   \
            for (auto rtv : rtvs) {                                                                 \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv); \
            }                                                                                       \
            if (changed) {                                                                          \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                  \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0});      \
            }                                                                                       \
            return true; }, \
      },                                     \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,

    // CustomShaderEntry(0x52C606BB),

    // UpgradeRTVReplaceShader(0x1C6A24CB),
    // UpgradeRTVReplaceShader(0x2B12DBC7),
    // UpgradeRTVReplaceShader(0x2F3B7F2C),
    // UpgradeRTVReplaceShader(0x7A51820D),
    // UpgradeRTVReplaceShader(0x7F9E0A3C),
    // UpgradeRTVReplaceShader(0xBBA34F0E),
    // UpgradeRTVReplaceShader(0xCDF63436),
    // UpgradeRTVReplaceShader(0xCE04D803),
    // UpgradeRTVReplaceShader(0x0C4637FC),
    // UpgradeRTVReplaceShader(0x0D55FC9C),
    // UpgradeRTVReplaceShader(0x1BA413FC),
    // UpgradeRTVReplaceShader(0x1BB45395),
    // UpgradeRTVReplaceShader(0x1D829B4B),
    // UpgradeRTVReplaceShader(0x2B4D40B9),
    // UpgradeRTVReplaceShader(0x2E02DE87),
    // UpgradeRTVReplaceShader(0x2FE884ED),
    // UpgradeRTVReplaceShader(0x3B923E72),
    // UpgradeRTVReplaceShader(0x3DA1F69C),
    // UpgradeRTVReplaceShader(0x4B4ABF52),
    // UpgradeRTVReplaceShader(0x4D8D23AB),
    // UpgradeRTVReplaceShader(0x4E0E11B6),
    // UpgradeRTVReplaceShader(0x7C2BCC2D),
    // UpgradeRTVReplaceShader(0x008BB29C),
    // UpgradeRTVReplaceShader(0x8E9D3EA7),
    // UpgradeRTVReplaceShader(0x8F202D6E),
    // UpgradeRTVReplaceShader(0x9F917F49),
    // UpgradeRTVReplaceShader(0x9F268478),
    // UpgradeRTVReplaceShader(0x30A33426),
    // UpgradeRTVReplaceShader(0x33D5757A),
    // UpgradeRTVReplaceShader(0x38DFFE9F),
    // UpgradeRTVReplaceShader(0x42BDEE04),
    // UpgradeRTVReplaceShader(0x56A28B23),
    // UpgradeRTVReplaceShader(0x58C42E54),
    // UpgradeRTVReplaceShader(0x72D76BF8),
    // UpgradeRTVReplaceShader(0x72D80DD5),
    // UpgradeRTVReplaceShader(0x79B9A670),
    // UpgradeRTVReplaceShader(0x104C4A64),
    // UpgradeRTVReplaceShader(0x128C2AF3),
    // UpgradeRTVReplaceShader(0x0272F122),
    // UpgradeRTVReplaceShader(0x424CE51F),
    // UpgradeRTVReplaceShader(0x550CAF93),
    // UpgradeRTVReplaceShader(0x559EBF65),
    // UpgradeRTVReplaceShader(0x750F2E5D),
    // UpgradeRTVReplaceShader(0x852D8AE0),
    // UpgradeRTVReplaceShader(0x6143D745),
    // UpgradeRTVReplaceShader(0x6892ADE6),
    // UpgradeRTVReplaceShader(0x9477BD05),
    // UpgradeRTVReplaceShader(0x50196E61),
    // UpgradeRTVReplaceShader(0x98188A73),
    // UpgradeRTVReplaceShader(0x329369E2),
    // UpgradeRTVReplaceShader(0x525454BA),
    // UpgradeRTVReplaceShader(0x21388966),
    // UpgradeRTVReplaceShader(0x50007876),
    // UpgradeRTVReplaceShader(0x66088341),
    // UpgradeRTVReplaceShader(0x81651643),
    // UpgradeRTVReplaceShader(0xA2A2C187),
    // UpgradeRTVReplaceShader(0xA6D2768D),
    // UpgradeRTVReplaceShader(0xA7E04084),
    // UpgradeRTVReplaceShader(0xAB026552),
    // UpgradeRTVReplaceShader(0xAF987DB7),
    // UpgradeRTVReplaceShader(0xB1C16579),
    // UpgradeRTVReplaceShader(0xB87F8B33),
    // UpgradeRTVReplaceShader(0xB1883B88),
    // UpgradeRTVReplaceShader(0xBA1F392B),
    // UpgradeRTVReplaceShader(0xBA841E2F),
    // UpgradeRTVReplaceShader(0xBE8F3FB8),
    // UpgradeRTVReplaceShader(0xBE8F9C27),
    // UpgradeRTVReplaceShader(0xC2BAB2D4),
    // UpgradeRTVReplaceShader(0xC29A6092),
    // UpgradeRTVReplaceShader(0xC934F73E),
    // UpgradeRTVReplaceShader(0xC952F645),
    // UpgradeRTVReplaceShader(0xCC3C8490),
    // UpgradeRTVReplaceShader(0xD079AE4D),
    // UpgradeRTVReplaceShader(0xD287D68F),
    // UpgradeRTVReplaceShader(0xD862EF60),
    // UpgradeRTVReplaceShader(0xDEF1EF85),
    // UpgradeRTVReplaceShader(0xE3A61E07),
    // UpgradeRTVReplaceShader(0xE375E0FA),
    // UpgradeRTVReplaceShader(0xEB3D6D60),
    // UpgradeRTVReplaceShader(0xEC069C7D),
    // UpgradeRTVReplaceShader(0xF8C00AA3),
    // UpgradeRTVReplaceShader(0xF5572AF7),
    // UpgradeRTVReplaceShader(0x2FB7C99C),
    // UpgradeRTVReplaceShader(0x3F5724D3),
    // UpgradeRTVReplaceShader(0x4F5A3FD2),
    // UpgradeRTVReplaceShader(0x5E9DAF38),
    // UpgradeRTVReplaceShader(0x06CE6977),
    // UpgradeRTVReplaceShader(0x0097A1F2),
    // UpgradeRTVReplaceShader(0x489AC125),
    // UpgradeRTVReplaceShader(0x1001FEA0),
    // UpgradeRTVReplaceShader(0x7617F28E),
    // UpgradeRTVReplaceShader(0xA3A45957),
    // UpgradeRTVReplaceShader(0xB8AFD22B),
    // UpgradeRTVReplaceShader(0xB25FB97A),
    // UpgradeRTVReplaceShader(0xB57065E4),
    // UpgradeRTVReplaceShader(0xC0024AF6),
    // UpgradeRTVReplaceShader(0xC4222E6A),
    // UpgradeRTVReplaceShader(0xE2BE5836),
    // UpgradeRTVReplaceShader(0xE33E7D75),
    // UpgradeRTVReplaceShader(0xF06AE368),
    // UpgradeRTVReplaceShader(0xFBE8F7FA),
    // UpgradeRTVReplaceShader(0xFE28AD76),
    // UpgradeRTVReplaceShader(0x3F0DE29D),
    // UpgradeRTVReplaceShader(0xA6AFB6CC),
    // UpgradeRTVReplaceShader(0xE972EF90),
    // UpgradeRTVReplaceShader(0x3EF9D893),
    // UpgradeRTVReplaceShader(0x44E69BB0),
    // UpgradeRTVReplaceShader(0x37E8C9B9),
    // UpgradeRTVReplaceShader(0xAE05BB6C),
    // UpgradeRTVReplaceShader(0xC33F2FB3),
    // UpgradeRTVReplaceShader(0x2A81238E),
    // UpgradeRTVReplaceShader(0x070DC315),
    // UpgradeRTVReplaceShader(0x4B5C21A8),
    // UpgradeRTVReplaceShader(0xD2FB79D7),
    // UpgradeRTVReplaceShader(0x3392C9D8),
    // UpgradeRTVReplaceShader(0xAC9DB601),

    // // CustomShaderEntry(0xF755F802),
    // // CustomShaderEntry(0x289D2B25),
    // // CustomShaderEntry(0xDC21AB98),
    // // CustomShaderEntry(0x07DFF47A),
    // // CustomShaderEntry(0x6A5E6ED1),

    // // CustomShaderEntry(0xEDF36DE8),
    // // CustomShaderEntry(0xC9F99849),
    // // CustomShaderEntry(0xFE56F961),
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Regular", "Hardened", "Veteran"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &renodx::utils::swapchain::fps_limit,
        .default_value = 0.f,
        .can_reset = false,
        .label = "FPS Limit",
        // .section = "FPS Limit",
        .tooltip = "Cap by the RenoDX/ReShade overridden swapchain.",
        .min = 0.f,
        .max = 1000.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
          renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
        },
    },

    // ReadMe //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Use Borderless Fullscreen if Exclusive doesn't create HDR output.",
        .section = "Read Me (IMPORTANT)",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Anti-Aliasing is required, as the color gets harmfully encoded otherwise.\n"
                 "You can force disable FXAA below.\n"
                 "(Screen will turn red as warning if otherwise.)",
        .section = "Read Me (IMPORTANT)",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Reset the in-game brightness settings, else you will crush blacks with lowered values.\n"
                 "(The slider should reach the middle of \"D\" in \"Disabled\" of the setting below.)",
        .section = "Read Me (IMPORTANT)",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "In game film grain is very faint, or just not working.\n"
                 "See Extra section for RenoDX film grain.",
        .section = "Read Me (IMPORTANT)",
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = "",
    //     .section = "Read Me (IMPORTANT)",
    // },

    // Tone Mapper //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    // new renodx::utils::settings::Setting{
    //     .key = "CustomTonemapIsUseSDR",
    //     .binding = &shader_injection.custom_tonemap_isusesdr,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .can_reset = true,
    //     .label = "Luma Prioritization",
    //     .section = "Tone Mapping",
    //     .tooltip = "- Vanilla+: Use HDR color, correcting it with SDR luma and chroma grading, customizable down below.\n"
    //                "- SDR Dependent: Like older versions, all of SDR color is used unless HDR luma surpasses SDR range. (Bloom customization only comes into effect in HDR range.)\n",
    //     .labels = {"Vanilla+", "SDR Dependent (Legacy)"},
    //     .tint = 0xffad42,
    //     .is_visible = []() { return shader_injection.tone_map_type > 0 /* && current_settings_mode >= 1 */; },
    // },

    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
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
        .default_value = 1.f,
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
        .is_visible = []() { return current_settings_mode >= 2; },
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

    // Color Grading //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 1; },
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
        .key = "CustomGradeChroma",
        .binding = &shader_injection.custom_grade_chroma,
        .default_value = 85.f,
        .label = "Chroma Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game on chrominace.\n"
                   "- Like 100%, you want this on to apply LUT.",
        .tint = 0xffad42,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomGradeLuma",
        .binding = &shader_injection.custom_grade_luma,
        .default_value = 80.f,
        .label = "Luma Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game on luminance.\n"
                   "- Turning it in down linearizes the color. You can be the one to apply grading yourself.",
        .tint = 0xffad42,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
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
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    // Extra //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "custom_bloom_multiplier",
        .binding = &shader_injection.custom_bloom_multiplier,
        .default_value = 1.f,
        .label = "Bloom",
        .section = "Extra",
        .tooltip = "Amount of bloom.",
        .max = 2.f,
        .format = "%.3f",
    },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomADSSightsMultiplier",
    //     .binding = &shader_injection.custom_adssights_multiplier,
    //     .default_value = 25.f,
    //     .label = "ADS Holographic Sights",
    //     .section = "Extra",
    //     .tooltip = "E.g. red dot. Please bug report unaccounted sights.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    new renodx::utils::settings::Setting{
        .key = "custom_extra_filmgrain",
        .binding = &shader_injection.custom_extra_filmgrain,
        .default_value = 0.f,
        .label = "Film Grain (RenoDX)",
        .section = "Extra",
        .tooltip = "RenoDX (not Vanilla) applied film grain.",
        .max = 0.1f,
        .format = "%.3f",
        // .is_visible = []() { return current_settings_mode >= 2; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomIsUI",
    //     .binding = &shader_injection.custom_is_ui,
    //     .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 1.f,
    //     .label = "UI (Pause Screen)",
    //     .section = "Extra",
    //     .tooltip = "Not comprehensive, but should be enough to pause and take screenshots.",
    // },
    new renodx::utils::settings::Setting{
        .key = "custom_disablefxaa",
        .binding = &shader_injection.custom_disablefxaa,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "Disable FXAA",
        .section = "Extra",
        .tooltip = "Force disable FXAA (set in-game settings first).\n"
                   "For those who don't want any anti-aliasing.",
    },

    // PreExposure //////////////////////////////////////////////////////////////////////////////////////
    // new renodx::utils::settings::Setting{
    //     .key = "CustomTonemapDebug",
    //     .binding = &shader_injection.custom_tonemap_debug,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0,
    //     .label = "Debug View",
    //     .section = "PreExposure",
    //     .tooltip = "- Off: Normal rendering.\n"
    //                "- Heat Map: Luma categorized by RenoDRT (Pink (shadow), Green (mid), Gray (high), Cyan (clip)).\n"
    //                "- Calibration: If needed, calibrate PreExposure so that 1st/2nd matches 3rd for midtones. (color_untonemapped / color_sdr_neutral / color_sdr_graded)",
    //     .labels = {"Off", "Heat Map", "Calibration"},
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    new renodx::utils::settings::Setting{
        .key = "CustomTonemapUnverified",
        .binding = &shader_injection.custom_tonemap_unverified,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0,
        .label = "Identify Unverified",
        .section = "PreExposure",
        .tooltip = "(Debug) Identify (red/green/blue overlay) tonemap/uber variants that are accounted for ToneMapPass(), but are unverified.",
        // .labels = {"Off", "Heat Map", "Calibration"},
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{
        .key = "CustomPreExposureOffsetMultiplier",
        .binding = &shader_injection.custom_preexposure_offset_multiplier,
        .default_value = 1.f,
        .label = "Offset Weight",
        .section = "PreExposure",
        .tooltip = "The amount to brighten, set by current location.",
        .max = 1.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{
        .key = "CustomPreExposureAutoMultiplier",
        .binding = &shader_injection.custom_preexposure_auto_multiplier,
        .default_value = 1.f,
        .label = "AutoExposure Weight",
        .section = "PreExposure",
        .tooltip = "The autoexposure strength.",
        .max = 1.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{
        .key = "CustomPreExposureFinal",
        .binding = &shader_injection.custom_preexposure_final,
        .default_value = 0.1f,
        .label = "Final",
        .section = "PreExposure",
        .tooltip = "The final multiplier for PreExposure.",
        .max = 1.f,
        .format = "%.3f",
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomPreExposureContrast",
        .binding = &shader_injection.custom_preexposure_contrast,
        .default_value = 1.4f,
        .label = "Contrast",
        .section = "PreExposure",
        .tooltip = "The contrast of the untonemapped image.\n"
                   "Set to match vanilla so HDR luma makes more sense.",
        .max = 3.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_blackfloorraise",
        .binding = &shader_injection.custom_blackfloorraise,
        .default_value = 0.001266f,
        .label = "Black Floor Raise",
        .section = "PreExposure",
        .tooltip = "Black floor raise on untonemapped color.\n"
                   "Mimics Vanilla faded photography colored shadows.\n"
                   "Decreasing can crush blacks.",
        .max = 0.001266f,
        .format = "%.7f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    // Frostbite //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "So that untonemapped color is blown out like vanilla color when lerping for Chroma Grade.",
        .section = "Untonemapped Frostbite",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomFrostbiteA",
        .binding = &shader_injection.custom_frostbite_a,
        .default_value = 0.25f,
        .label = "Threshold",
        .section = "Untonemapped Frostbite",
        .tooltip = "Frostbite Threshold (barely any effect).",
        .max = 1.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{
        .key = "CustomFrostbiteB",
        .binding = &shader_injection.custom_frostbite_b,
        .default_value = 0.3f,
        .label = "Highlights Saturation",
        .section = "Untonemapped Frostbite",
        .tooltip = "Frostbite blowout for untonemapped color.",
        .max = 1.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "CustomFrostbiteC",
        .binding = &shader_injection.custom_frostbite_c,
        .default_value = 0.6f,
        .label = "Hue Correct",
        .section = "Untonemapped Frostbite",
        .tooltip = "Frostbite Hue Correct (barely any effect).",
        .max = 1.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    // Credits & Buttons //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Game Mod: XgarhontX\n",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "RenoDX: clshortfuse\n",
        .section = "Credits",
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BULLET,
    //     .label = "PumboAutoHDR (loading movies): Filoppi (Pumbo)",
    //     .section = "Credits",
    // },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Credits",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "9Bm4RZA8");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDRDen Discord",
        .section = "Credits",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More RenoDX Mods",
        .section = "Credits",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Build Date: " + build_date + " - " + build_time,
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "",
        .section = "Credits",
    },

    // Advanced //////////////////////////////////////////////////////////////////////////////////////
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

};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("TtoneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTScaling", 0.f);
}

bool initialized = false;

}  // namespace

// from tombraider2013 de
bool fired_on_init_swapchain = false;
void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  auto white_level = 203.f;
  if (!peak.has_value()) {
    peak = 1000.f;
  }

  // find and set
  for (auto& setting : settings) {
    if (setting->binding != &shader_injection.peak_white_nits) continue;
    setting->default_value = peak.value();
    setting->can_reset = true;
    break;
  }

  // settings[3]->default_value = renodx::utils::swapchain::ComputeReferenceWhite(peak.value());
}

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Call of Duty: Infinite Warfare)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = RENODX_COLORBUFFER_INDEX;
        renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::expected_constant_buffer_index = RENODX_COLORBUFFER_INDEX;
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
        };

        renodx::mods::swapchain::force_borderless = false;
        renodx::mods::swapchain::prevent_full_screen = false;

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 4.f,
              .label = "Encoding",
              .section = "Display Output",
              .labels = {"None (Unknown)", "SRGB (Unsupported)", "2.2 (Unsupported)", "2.4 (Unsupported)", "HDR10 (Faster?)", "scRGB (Best)"},
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

          if (!is_hdr10) {
            renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
                .old_format = reshade::api::format::r11g11b10_float,
                .new_format = reshade::api::format::r16g16b16a16_float,
                .ignore_size = true,
                .use_resource_view_cloning = false,  // doesnt matter?
                // .use_resource_view_hot_swap = true,
                .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
                .usage_include = reshade::api::resource_usage::resolve_dest,
            });
          }
        }

        // tex upgrade
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_typeless,
            .ignore_size = true,
            .use_resource_view_cloning = false,  // false fixes prevframeblur
            // .use_resource_view_hot_swap = true,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::resolve_dest,
        });
        // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //     .old_format = reshade::api::format::r8g8b8a8_unorm,  // Doesn't do anything?
        //     .new_format = reshade::api::format::r16g16b16a16_typeless,
        //     .ignore_size = true,
        //     .use_resource_view_cloning = false,
        //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        //     .usage_include = reshade::api::resource_usage::resolve_dest,
        // });
        // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //     .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,  // Doesn't do anything?
        //     .new_format = reshade::api::format::r16g16b16a16_typeless,
        //     .ignore_size = true,
        //     .use_resource_view_cloning = false,
        //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        //     .usage_include = reshade::api::resource_usage::resolve_dest,
        // });

        initialized = true;

        // random
        renodx::utils::random::binds.push_back(&shader_injection.random_seed);

        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits
      break;
  }

  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
