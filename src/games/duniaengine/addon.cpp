/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define NOMINMAX

#include <chrono>
#include <random>
#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

#define UpgradeRTVReplaceShader(value)         \
  {                                            \
    value,                                     \
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

#define UpgradeRTVShader(value)                \
  {                                            \
    value,                                     \
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

int game = 0; // 1 = Avatar/FC2, 2 = FC3, 3 = FC BD, 4 = FC4, 5 = FC P, 
renodx::mods::shader::CustomShaders custom_shaders = {
    // James Cameron's Avatar The Game
    CustomShaderEntryCallback(0xDC7BCE83, [](reshade::api::command_list* cmd_list) {  // videos
      if(game != 0) return true;
    game = 1;
    return true;
    }),
    UpgradeRTVReplaceShader(0xDE02EA5F),  // grading
    UpgradeRTVShader(0x493FAD66),   // effect
    UpgradeRTVShader(0x19D470F2),   // effect
    UpgradeRTVShader(0x6996C9BA),   // effect
    UpgradeRTVShader(0x8EF5C754),   // effect
    UpgradeRTVShader(0xDD953319),   // effect
    UpgradeRTVShader(0x287D7227),   // effect
    // Far Cry 2
    CustomShaderEntryCallback(0x7399DA1F, [](reshade::api::command_list* cmd_list) {  // videos
      if(game != 0) return true;
    game = 1;
    return true;
    }),
    UpgradeRTVReplaceShader(0x8B2AB983),  // grading
    UpgradeRTVReplaceShader(0x52A3DCD5),  // grading
    CustomShaderEntry(0x2DE809A9),  // bloom sample (black square bug fix)
    UpgradeRTVShader(0x556ADFB0),   // effect
    UpgradeRTVShader(0x381C7189),   // effect
    UpgradeRTVShader(0x073DC55B),   // effect
    UpgradeRTVShader(0x7D27F432),   // effect
    // Far Cry 3
    UpgradeRTVReplaceShader(0x67E0BEC3),  // tonemap
    UpgradeRTVReplaceShader(0x129E838C),  // tonemap
    UpgradeRTVReplaceShader(0xD529C189),  // tonemap (shroom trip)
    UpgradeRTVReplaceShader(0xDB4C6627),  // tonemap (shroom trip)
    UpgradeRTVShader(0xD79CE03E),   // effect
    UpgradeRTVShader(0x3771A7FE),   // effect
    UpgradeRTVShader(0xE976E21B),   // effect
    CustomShaderEntry(0x06AC2C1D),  // AA
    CustomShaderEntry(0x8D8A00F8),  // effect
    UpgradeRTVReplaceShader(0x172215B1),  // effect
    CustomShaderEntry(0xB5FBCC2B),  // effect
    UpgradeRTVReplaceShader(0xC69EBB3D),  // effect
    CustomShaderEntry(0xF29207EF),  // effect
    CustomShaderEntry(0x3E5B1161),  // effect
    CustomShaderEntry(0xC7C99EFC),  // effect
    CustomShaderEntry(0xEC102A39),  // effect
    CustomShaderEntry(0x8E890F88),  // effect
    CustomShaderEntry(0xB9C79B5F),  // effect
    CustomShaderEntry(0x29CD18B6),  // effect
    CustomShaderEntry(0xC450C211),  // effect
    CustomShaderEntry(0x568F7B61),  // effect
    CustomShaderEntry(0x6FF02A67),  // effect
    CustomShaderEntry(0x8333D6F1),  // effect
    CustomShaderEntry(0x86DBC4B9),  // underwater effect
    CustomShaderEntry(0x0BFBC3A9),  // water splash
    CustomShaderEntry(0x1CA344D0),  // water splash
    CustomShaderEntryCallback(0xDEA4BACD, [](reshade::api::command_list* cmd_list) {  // UI
      if(game != 0) return true;
    game = 2;
    return true;
    }),
    CustomShaderEntry(0x7905FD45),  // videos
    // Far Cry 3
    CustomShaderEntryCallback(0x1FF398C9, [](reshade::api::command_list* cmd_list) {  // videos
      if(game != 0) return true;
    game = 3;
    return true;
    }),
    UpgradeRTVReplaceShader(0x2D942350),   // tonemap (cybereye)
    UpgradeRTVReplaceShader(0x9400448D),   // tonemap (cybereye)
    CustomShaderEntry(0x1C7F67A4),  // effect
    CustomShaderEntry(0x1F33196A),  // effect
    CustomShaderEntry(0x6E2A0D6F),  // effect
    CustomShaderEntry(0x12E98EAA),  // effect
    CustomShaderEntry(0x0364C9A7),  // effect
    CustomShaderEntry(0x36914D4C),  // effect
    CustomShaderEntry(0xA3F537D2),  // effect
    CustomShaderEntry(0xD7500557),  // effect
    CustomShaderEntry(0xF1F4D4DD),  // effect
    CustomShaderEntry(0xF18C2172),  // effect
    UpgradeRTVReplaceShader(0x85145482),  // film grain
    CustomShaderEntry(0xAC102B92),  // lines
    CustomShaderEntry(0xA6A9C3BD),  // blast
    CustomShaderEntry(0x94CF318C),  // blast
    // Far Cry 4
    //UpgradeRTVReplaceShader(0x45A69747),  // tonemap
    //UpgradeRTVShader(0x4F35D53E),  // SMAA
    //UpgradeRTVShader(0x8E13E570),  // Temporal smthing
    // Far Cry Primal
    UpgradeRTVReplaceShader(0x01F1B6F2),  // tonemap
    UpgradeRTVReplaceShader(0x2D0E0227),  // tonemap
    UpgradeRTVReplaceShader(0x5D90F346),  // tonemap
    UpgradeRTVReplaceShader(0x65A18F98),  // tonemap
    UpgradeRTVReplaceShader(0x594E52B0),  // tonemap
    UpgradeRTVReplaceShader(0x1458B56B),  // tonemap
    UpgradeRTVReplaceShader(0x03306A38),  // tonemap
    UpgradeRTVReplaceShader(0x02938160),  // tonemap
    UpgradeRTVReplaceShader(0x4671847D),  // tonemap
    UpgradeRTVReplaceShader(0x28537390),  // tonemap
    UpgradeRTVReplaceShader(0xA9B38DFF),  // tonemap
    UpgradeRTVReplaceShader(0xA0717E6A),  // tonemap
    UpgradeRTVReplaceShader(0xB7B2B52B),  // tonemap
    UpgradeRTVReplaceShader(0xD08DF143),  // tonemap
    UpgradeRTVReplaceShader(0xEE739C51),  // tonemap
    UpgradeRTVReplaceShader(0xEFB860C8),  // tonemap
    UpgradeRTVReplaceShader(0xF0A0145B),  // tonemap
    CustomShaderEntry(0xE3D68DA2),  // exposure
    CustomShaderEntry(0xA1E8AD3F),  // AA
    UpgradeRTVShader(0x9EBEC83E),   // AA
    CustomShaderEntryCallback(0x30F66CC7, [](reshade::api::command_list* cmd_list) {  // videos
      if(game != 0) return true;
    game = 5;
    return true;
    }),
};

float current_settings_mode = 0;
renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .tint = 0x01A8DF,
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT (Daniele)", "RenoDRT (Reinhard)"},
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPerChannel",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Per Channel", "Luminance"},
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
      .key = "toneMapColorSpace",
      .binding = &shader_injection.toneMapColorSpace,
      .value_type = renodx::utils::settings::SettingValueType::INTEGER,
      .default_value = 2.f,
      .label = "Working Color Space",
      .section = "Tone Mapping",
      .labels = {"BT709", "BT2020", "AP1"},
      .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
      .is_visible = []() { return current_settings_mode >= 2 && game >= 5; },
  },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueProcessor",
        .binding = &shader_injection.toneMapHueProcessor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .labels = {"OKLab", "ICtCp", "darktable UCS"},
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
      .key = "ToneMapHueShift",
      .binding = &shader_injection.toneMapHueShift,
      .default_value = 50.f,
      .label = "Hue Shift",
      .section = "Tone Mapping",
      .tooltip = "Hue-shift emulation strength.",
      .min = 0.f,
      .max = 100.f,
      .is_enabled = []() { return shader_injection.toneMapType >= 3.f && shader_injection.toneMapPerChannel == 0.f; },
      .parse = [](float value) { return value * 0.01f; },
      .is_visible = []() { return current_settings_mode >= 1; },
  },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapShoulderStart",
        .binding = &shader_injection.toneMapShoulderStart,
        .default_value = 0.25f,
        .label = "Rolloff/Shoulder Start",
        .section = "Tone Mapping",
        .tint = 0xAC7C38,
        .max = 0.99f,
        .format = "%.2f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .tint = 0x01A8DF,
        .max = 10.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .tint = 0x01A8DF,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .tint = 0x01A8DF,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .tint = 0x01A8DF,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .tint = 0x01A8DF,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 50.f,
        .label = "Highlights Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlights color.",
        .tint = 0x01A8DF,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeDechroma",
        .binding = &shader_injection.colorGradeDechroma,
        .default_value = 50.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .tint = 0x01A8DF,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .parse = [](float value) { return fmax(0.00001f, value * 0.01f); },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 25.f,
        .label = "Flare",
        .section = "Color Grading",
        .tint = 0x01A8DF,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3.f || shader_injection.toneMapType == 4.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
      .key = "colorGradeClip",
      .binding = &shader_injection.colorGradeClip,
      .default_value = 4000.f,
      .label = "Clipping",
      .section = "Color Grading",
      .tooltip = "Clip point for white in nits",
      .tint = 0x01A8DF,
      .min = 48.f,
      .max = 4000.f,
      .is_enabled = []() { return shader_injection.toneMapType == 4.f; },
      .parse = [](float value) { return value / 250.f; },
      .is_visible = []() { return current_settings_mode >= 1; },
  },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .tint = 0x01A8DF,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 1.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTSampling",
        .binding = &shader_injection.colorGradeLUTSampling,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "LUT Sampling",
        .section = "Color Grading",
        .labels = {"Trilinear", "Tetrahedral"},
        .tint = 0x01A8DF,
        .is_enabled = []() { return shader_injection.toneMapType != 1.f; },
        .is_visible = []() { return current_settings_mode >= 2 && game != 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "upgradePerChannel",
        .binding = &shader_injection.upgradePerChannel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Restoration Method",
        .section = "Color Grading",
        .labels = {"Luminance", "Per Channel"},
        .tint = 0x01A8DF,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
      .key = "fxAutoExposure",
      .binding = &shader_injection.fxAutoExposure,
      .default_value = 100.f,
      .label = "Auto Exposure",
      .section = "Effects",
      .max = 100.f,
      .parse = [](float value) { return value * 0.01f; },
      .is_visible = []() { return current_settings_mode >= 1; },
  },
    new renodx::utils::settings::Setting{
      .key = "fxVignette",
      .binding = &shader_injection.fxVignette,
      .default_value = 100.f,
      .label = "Vignette",
      .section = "Effects",
      .max = 100.f,
      .parse = [](float value) { return value * 0.01f; },
      .is_visible = []() { return game >= 4; },
  },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "Film Grain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
      .key = "fxFilmGrainType",
      .binding = &shader_injection.fxFilmGrainType,
      .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
      .default_value = 1.f,
      .label = "Film Grain Type",
      .section = "Effects",
      .labels = {"Vanilla", "Perceptual"},
      .is_visible = []() { return shader_injection.fxFilmGrain != 0.f; },
  },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0xFE8F20,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("toneMapPerChannel", 0.f);
          renodx::utils::settings::UpdateSetting("toneMapColorSpace", 2.f);
          renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeDechroma", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeFlare", 25.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 1.f);
        },
    },
    new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "RenoDRT HDR Look",
      .section = "Color Grading Templates",
      .group = "button-line-1",
      .tint = 0x01A8DF,
      .on_change = []() {
        renodx::utils::settings::UpdateSetting("toneMapType", 3.f);
        renodx::utils::settings::UpdateSetting("toneMapPerChannel", 0.f);
        renodx::utils::settings::UpdateSetting("toneMapColorSpace", 2.f);
        renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 0.f);
        renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 80.f);
        renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
        renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
        renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
        renodx::utils::settings::UpdateSetting("colorGradeContrast", 45.f);
        renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
        renodx::utils::settings::UpdateSetting("colorGradeBlowout", 80.f);
        renodx::utils::settings::UpdateSetting("colorGradeDechroma", 65.f);
        renodx::utils::settings::UpdateSetting("colorGradeFlare", 80.f);
        renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
        renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 1.f);
      },
      .is_visible = []() { return shader_injection.toneMapType == 3.f && game != 1; },
  },
  new renodx::utils::settings::Setting{
    .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    .label = "RenoDRT HDR Look 2",
    .section = "Color Grading Templates",
    .group = "button-line-1",
    .tint = 0x01A8DF,
    .on_change = []() {
      renodx::utils::settings::UpdateSetting("toneMapType", 3.f);
      renodx::utils::settings::UpdateSetting("toneMapPerChannel", 1.f);
      renodx::utils::settings::UpdateSetting("toneMapColorSpace", 0.f);
      renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
      renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100.f);
      renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
      renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
      renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
      renodx::utils::settings::UpdateSetting("colorGradeContrast", 75.f);
      renodx::utils::settings::UpdateSetting("colorGradeSaturation", 80.f);
      renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
      renodx::utils::settings::UpdateSetting("colorGradeDechroma", 80.f);
      renodx::utils::settings::UpdateSetting("colorGradeFlare", 25.f);
      renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
      renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 1.f);
    },
    .is_visible = []() { return shader_injection.toneMapType == 3.f && game != 1; },
},
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reinhard+ HDR Look",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0x01A8DF,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("toneMapType", 4.f);
          renodx::utils::settings::UpdateSetting("toneMapColorSpace", 2.f);
          renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 0.f);
          renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeHighlights", 45.f);
          renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 75.f);
          renodx::utils::settings::UpdateSetting("colorGradeSaturation", 80.f);
          renodx::utils::settings::UpdateSetting("colorGradeBlowout", 65.f);
          renodx::utils::settings::UpdateSetting("colorGradeDechroma", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 1.f);
        },
        .is_visible = []() { return shader_injection.toneMapType == 4.f && game != 1; },
    },
    new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "HDR Look",
      .section = "Color Grading Templates",
      .group = "button-line-1",
      .tint = 0x38F6FC,
      .on_change = []() {
        renodx::utils::settings::UpdateSetting("toneMapPerChannel", 0.f);
        renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
        renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100.f);
        renodx::utils::settings::UpdateSetting("toneMapShoulderStart", 0.33f);
        renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
        renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
        renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
        renodx::utils::settings::UpdateSetting("colorGradeContrast", 75.f);
        renodx::utils::settings::UpdateSetting("colorGradeSaturation", 75.f);
        renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
        renodx::utils::settings::UpdateSetting("colorGradeDechroma", 80.f);
        renodx::utils::settings::UpdateSetting("colorGradeFlare", 25.f);
        renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);},
        .is_visible = []() { return game == 1; },
  },
    new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = "Currently identifying game...",
      .section = "Notes",
      .is_visible = []() { return game == 0; },
  },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "About",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/XUhv", "tR54yc");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "About",
        .group = "button-line-2",
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Version: " + std::string(renodx::utils::date::ISO_DATE),
        .section = "About",
        .tooltip = std::string(__DATE__),
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapShoulderStart", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 0.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxAutoExposure", 100.f);
  renodx::utils::settings::UpdateSetting("fxLines", 50.f);
  renodx::utils::settings::UpdateSetting("fxVignette", 100.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrainType", 0.f);
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }
}

bool game_check = false;

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
    static std::mt19937 random_generator(std::chrono::system_clock::now().time_since_epoch().count());
    static auto random_range = static_cast<float>(std::mt19937::max() - std::mt19937::min());
  shader_injection.random = static_cast<float>(random_generator() + std::mt19937::min()) / random_range;
  if(game_check) return;
  if(game != 0) {
    game_check = true;
  if(game == 1){
    settings[1]->labels = {"Vanilla", "None", "Frostbite", "RenoDRT (Reinhard)", "RenoDRT (Daniele)", "DICE"};
    settings[6]->labels = {"Luminance", "Per Channel"};
    settings[6]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
    settings[8]->is_enabled = []() { return shader_injection.toneMapType >= 2.f; };
    settings[9]->is_enabled = []() { return shader_injection.toneMapType >= 2.f; };
    settings[10]->is_visible = []() { return shader_injection.toneMapType == 2.f || shader_injection.toneMapType == 5.f ; },
    settings[16]->is_enabled = []() { return shader_injection.toneMapType >= 2.f; };
    settings[17]->is_enabled = []() { return shader_injection.toneMapType >= 2.f; };
    settings[19]->label = "Vanilla Grading Strength";
    settings[25]->default_value = 0.f;
    settings[25]->is_visible = []() { return shader_injection.fxFilmGrainType != 0.f ; };
    settings[26]->labels = {"Vanilla (none)", "Perceptual"};
    settings[26]->is_visible = []() { return true ; };
    settings[32]->label = "Bloom should be enabled in game settings.";
  }
  if(game == 2){
    settings[23]->is_visible = []() { return false ; };
    settings[25]->is_visible = []() { return false ; };
    settings[26]->is_visible = []() { return false ; };
    settings[32]->label = "Game's Calibration settings only apply to UI and videos.";
    settings[32]->is_visible = []() { return true ; };
  }
  if(game == 3){
    settings[23]->label = "Lines";
    settings[25]->tooltip = "Requires Post FX set to Medium or above.";
    settings[26]->tooltip = "Requires Post FX set to Medium or above.";
    settings[32]->label = "Game's Calibration settings only apply to UI and videos.";
    settings[32]->is_visible = []() { return true ; };
  }
  if(game == 5){
    settings[32]->label = "Game's Color Settings only apply to UI and videos.";
    settings[32]->is_visible = []() { return true ; };
  }
}
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Dunia Engine";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::use_resource_cloning = true;
      //renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      
      // FC2 / Avatar
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r8g8b8a8_unorm,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .ignore_size = true,
        .use_resource_view_cloning = true,
        .use_resource_view_hot_swap = true,
    });
      // FC3+
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .ignore_size = true,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
      });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}