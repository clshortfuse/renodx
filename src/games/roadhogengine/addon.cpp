/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

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
int postprocessing_level;
bool is_grain_used;
bool is_sharpen_used;
bool is_vignette_used;
bool lens_effects_active;
bool is_blur;

renodx::mods::shader::CustomShaders custom_shaders = {
    // common
    CustomShaderEntry(0x23F2025E),  // RIP (glitched death screen)
    // Hard Reset Redux
    CustomShaderEntryCallback(0x2FF3AD78, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_vignette_used = true;
    is_sharpen_used = true;
    is_grain_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xEF480D6C, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_vignette_used = true;
    is_sharpen_used = true;
    is_grain_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA8F9150B, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_vignette_used = false;
    is_sharpen_used = true;
    is_grain_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x769FB187, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_vignette_used = false;
    is_sharpen_used = true;
    is_grain_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xBA01D096, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_vignette_used = false;
    is_sharpen_used = true;
    is_grain_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA6B01AE0, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_vignette_used = false;
    is_sharpen_used = false;
    is_grain_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x45405040, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_vignette_used = false;
    is_sharpen_used = false;
    is_grain_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x852CCF05, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_vignette_used = true;
    is_sharpen_used = false;
    is_grain_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x4338D617, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_vignette_used = true;
    is_sharpen_used = false;
    is_grain_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xAD092DF9, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_vignette_used = true;
    is_sharpen_used = true;
    is_grain_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x38396D4E, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_vignette_used = false;
    is_sharpen_used = true;
    is_grain_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xE29A7A29, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_vignette_used = false;
    is_sharpen_used = false;
    is_grain_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x6AEB4E45, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_vignette_used = true;
    is_sharpen_used = false;
    is_grain_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x5D1BC502, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_vignette_used = true;
    is_grain_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x39A21265, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_vignette_used = false;
    is_grain_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x79D405C5, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_vignette_used = false;
    is_grain_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xE56AC1BF, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_vignette_used = true;
    is_grain_used = false;
    return true;
    }),
    CustomShaderEntry(0x8FACEF64),  // videos
    // Shadow Warrior (2013)
    CustomShaderEntryCallback(0x0DA22B92, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x9AB1D1C6, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x52F84B72, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x6211B8A7, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x0A2E234C, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xCFE2B5D1, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xC9470745, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x023970B8, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xF71CDD10, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xEDF935AA, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x4DEE3336, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x13DA4C6C, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x1CDD6909, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x4628A968, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x7248153A, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = false;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x46AC9E79, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = false;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x1CA8E9AB, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x2E4DC470, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xF3FC4807, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x3381FB53, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x8204D9A8, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x12AB1A81, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x0F9652E8, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xA5638A17, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xA63B5F1F, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x1716F0C8, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xF6CEE439, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xCC82A738, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_blur = false;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x879096E7, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x856E9973, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xC04679B1, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x3FBBDFB4, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xA672A600, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x6E60A61D, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x6F10C7B9, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xB306DEC3, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = false;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x16580EDF, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x09A94C41, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = true;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x315506B7, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_blur = true;
    is_sharpen_used = true;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xD2F1B647, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xAECCF67D, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x7353AA61, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x72740BC1, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x6D2ADAEE, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x191D8275, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 0;
    is_blur = true;
    is_sharpen_used = false;
    lens_effects_active = false;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntry(0xA36BCFE2),  // lens dirt
    CustomShaderEntry(0xA4F44331),  // lens dirt
    CustomShaderEntry(0x3708D87A),  // lens flare
    CustomShaderEntry(0x48B48F7B),  // videos
    CustomShaderEntry(0x6720BADB),  // interactable items outline
    CustomShaderEntry(0x4E5E174F),  // something
    // Shadow Warrior 2, maybe
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
        .labels = {"Vanilla", "None", "Frostbite", "RenoDRT", "DICE"},
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
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueProcessor",
        .binding = &shader_injection.toneMapHueProcessor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .labels = {"OKLab", "ICtCp", "darktable UCS"},
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapShoulderStart",
        .binding = &shader_injection.toneMapShoulderStart,
        .default_value = 0.25f,
        .label = "Rolloff/Shoulder Start",
        .section = "Tone Mapping",
        .max = 0.99f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.toneMapType == 2.f || shader_injection.toneMapType == 4.f ; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .tint = 0xF6AC1C,
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
        .tint = 0xF6AC1C,
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
        .tint = 0xF6AC1C,
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
        .tint = 0xF6AC1C,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .tint = 0xF6AC1C,
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
        .tint = 0xF6AC1C,
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
        .tint = 0xF6AC1C,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 25.f,
        .label = "Flare",
        .section = "Color Grading",
        .tint = 0xF6AC1C,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .tint = 0x01A8DF,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return postprocessing_level >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxLens",
        .binding = &shader_injection.fxLens,
        .default_value = 100.f,
        .label = "Lens Flare/Dirt",
        .section = "Effects",
        .tint = 0x01A8DF,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return lens_effects_active; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxSharpen",
        .binding = &shader_injection.fxSharpen,
        .default_value = 50.f,
        .label = "Sharpening",
        .section = "Effects",
        .tint = 0x01A8DF,
        .max = 100.f,
        .is_enabled = []() { return is_sharpen_used; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return postprocessing_level >= 1 && current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBlur",
        .binding = &shader_injection.fxBlur,
        .default_value = 50.f,
        .label = "Blur",
        .section = "Effects",
        .tint = 0x01A8DF,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return is_blur && current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxVignette",
        .binding = &shader_injection.fxVignette,
        .default_value = 100.f,
        .label = "Vignette",
        .section = "Effects",
        .tint = 0x01A8DF,
        .max = 100.f,
        .is_enabled = []() { return is_vignette_used; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "Film Grain",
        .section = "Effects",
        .tint = 0x01A8DF,
        .max = 100.f,
        .is_enabled = []() { return is_grain_used; },
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
        .tint = 0x01A8DF,
        .is_visible = []() { return shader_injection.fxFilmGrain != 0.f && is_grain_used; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0xFE8F20,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("toneMapPerChannel", 0.f);
          renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100.f);
          renodx::utils::settings::UpdateSetting("toneMapShoulderStart", 0.25f);
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeDechroma", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeFlare", 25.f);
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Look",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0x01A8DF,
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
          renodx::utils::settings::UpdateSetting("colorGradeFlare", 20.f);
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "About",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::Launch(
            "https://discord.gg/XUhv"
            "tR54yc");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "About",
        .group = "button-line-2",
        .on_change = []() {
          ShellExecute(0, "open", "https://github.com/clshortfuse/renodx", 0, 0, SW_SHOW);
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
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxLens", 100.f);
  renodx::utils::settings::UpdateSetting("fxSharpen", 50.f);
  renodx::utils::settings::UpdateSetting("fxBlur", 50.f);
  renodx::utils::settings::UpdateSetting("fxVignette", 100.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrainType", 0.f);
}

auto start = std::chrono::steady_clock::now();
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

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  auto end = std::chrono::steady_clock::now();
  shader_injection.elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Hard Reset Redux | Shadow Warrior (2013)";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::use_resource_cloning = true;
      // renodx::mods::swapchain::swapchain_proxy_compatibility_mode = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      //  RGBA8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = false,
      });
      //  RGB10A2_unorm (motion blur & stuff)
      for (auto index : {2,3,4,5,6,7,8,9,10,11,12,13,14,15}) {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r10g10b10a2_unorm,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .index = index,
    });
}
      
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