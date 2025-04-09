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
int game = 0;   // 1 = HRR, 2 = SW(2013), 3 = SW2 (sdr), 4 = SW2 (hdr)
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
    CustomShaderEntryCallback(0x8FACEF64, [](reshade::api::command_list* cmd_list) {  // videos
    game = 1;
    return true;
    }),
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
    CustomShaderEntryCallback(0x48B48F7B, [](reshade::api::command_list* cmd_list) {  // videos
    game = 2;
    return true;
    }),
    CustomShaderEntry(0xA36BCFE2),  // lens dirt
    CustomShaderEntry(0xA4F44331),  // lens dirt
    CustomShaderEntry(0x3708D87A),  // lens flare
    CustomShaderEntry(0x6720BADB),  // interactable items outline
    CustomShaderEntry(0x4E5E174F),  // something
    // Shadow Warrior 2
    CustomShaderEntry(0x4D593A55),  // UI
    CustomShaderEntry(0x7DE48FFA),  // UI
    CustomShaderEntry(0x57D8F01E),  // UI
    CustomShaderEntry(0x838B4310),  // UI
    CustomShaderEntry(0x5B0B9295),  // UI
    CustomShaderEntry(0x320A7BCC),  // UI
    CustomShaderEntry(0xDB333004),  // UI
    CustomShaderEntry(0x7DC0A614),  // UI
    CustomShaderEntry(0xA505992D),  // UI
    CustomShaderEntry(0xA3A17C66),  // UI
    CustomShaderEntry(0xE6D30E69),  // UI
    CustomShaderEntry(0xCACDD090),  // UI
    CustomShaderEntry(0x10CE0E36),  // UI
    CustomShaderEntry(0xCBB34038),  // gamma
    CustomShaderEntryCallback(0x6756A138, [](reshade::api::command_list* cmd_list) {  // videos
    game = 3;
    return true;
    }),
    CustomShaderEntryCallback(0x93FC2429, [](reshade::api::command_list* cmd_list) {  // tonemap
    shader_injection.isLinearSpace = true;
    game = 4;
    return true;
    }),
    CustomShaderEntryCallback(0x231B3B55, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;   // tracks CA here
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xF99C69EC, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xB0BE7319, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xF8AD6A63, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA351E23F, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xC4FE0520, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x7AE71A38, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x268326F2, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x45995B20, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xF1B4BC09, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x4C5412CF, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x5D4B2922, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x40F026C4, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x55B4E2D7, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x5B14FEDD, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x075F0A3D, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x121503C6, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xBDF52042, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x19AFABC4, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xFB2559D5, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x291AE833, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x4C3AFED2, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x0664A14D, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x32F90855, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x72C9BB0F, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xB7D80646, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xE07F2B70, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x7CF50E75, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x275B517F, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x0771DF62, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xC570E91E, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x3A533147, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x69D2640C, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x1C67E14B, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xDE6FB1B6, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xC0B87AA2, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x9FE92A9D, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xF4EA7010, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xEAC729D8, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xF47ECC50, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x946F6BD1, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x64117C6A, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x88536DF4, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x50BC4290, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x53421D31, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x1541870E, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xE797E530, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xB31BA649, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x330C6A5B, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x900E377D, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xBE6C39BD, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x4B59870B, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x207BE732, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xF8CE1E2A, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x3776EC3D, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xE82075EC, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xED55AF5C, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x5DFBBB7C, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x885495F4, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xD76F33B7, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xE29265B1, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 2;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xD8B52567, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x2744DD30, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x83402A8B, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x4D3E5269, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xBEE1E334, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x27C1C43B, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xF3B1D674, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x31AE8CA6, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x2E26D10C, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xE6A0DEE7, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x9BB66660, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x17C9E4CA, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x037CC98B, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xC573DB4C, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x9FBA649D, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xF69CD003, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x393CB504, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x724C6971, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x62E8D8A4, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x08BB0F87, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x4F081694, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xC06D82E9, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x304EBCD0, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x6F206DC4, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x52DC5990, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x2DAE9396, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xB7D0CEC3, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xCBBB1122, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x55D4EA9A, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x858AE537, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA8EC5856, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xE18B30E8, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x7F2DAD13, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xB568643C, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xAB144A18, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x9CDD78C7, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x3F4868D6, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xFD30895E, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xBA1D4C3E, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x33D69819, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xA5A83291, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x230F6B5A, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xEC673508, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x8667F96E, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = true;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xCE924A58, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x99BB12A1, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xA81E83DB, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x5F1C7813, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x6697D0DC, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x481CFC2F, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x518FA0B1, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x306345AC, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x3B47B8DF, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x5DB10347, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xC1FF843E, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xD093E1BF, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x7A4B1159, [](reshade::api::command_list* cmd_list) {  // tonemap
    postprocessing_level = 1;
    is_grain_used = false;
    is_vignette_used = false;
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
        .is_enabled = []() { return shader_injection.toneMapType == 3.f || shader_injection.toneMapType == 4.f; },
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
        .is_visible = []() { return shader_injection.toneMapType == 2.f || shader_injection.toneMapType == 4.f; },
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
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
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
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .parse = [](float value) { return fmax(0.00001f, value * 0.01f); },
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
        .key = "colorGradeClip",
        .binding = &shader_injection.colorGradeClip,
        .default_value = 4000.f,
        .label = "Clipping",
        .section = "Color Grading",
        .tooltip = "Clip point for white in nits",
        .tint = 0xF6AC1C,
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.toneMapType == 4.f; },
        .parse = [](float value) { return value / 250.f; },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_visible = []() { return lens_effects_active || game >= 3; },
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
        .is_visible = []() { return game == 1 || game == 2; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDRT HDR Look",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0x01A8DF,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("toneMapPerChannel", 0.f);
          renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 80.f);
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeBlowout", 80.f);
          renodx::utils::settings::UpdateSetting("colorGradeDechroma", 65.f);
          renodx::utils::settings::UpdateSetting("colorGradeFlare", 80.f);
        },
        .is_visible = []() { return game == 4 && shader_injection.toneMapType == 3.f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDRT HDR Look 2",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0x01A8DF,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("toneMapPerChannel", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeShadows", 45.f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 70.f);
          renodx::utils::settings::UpdateSetting("colorGradeSaturation", 80.f);
          renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeDechroma", 80.f);
          renodx::utils::settings::UpdateSetting("colorGradeFlare", 10.f);
        },
        .is_visible = []() { return game == 4 && shader_injection.toneMapType == 3.f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reinhard+ HDR Look",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0x01A8DF,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("toneMapPerChannel", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeHighlights", 45.f);
          renodx::utils::settings::UpdateSetting("colorGradeShadows", 60.f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 65.f);
          renodx::utils::settings::UpdateSetting("colorGradeSaturation", 80.f);
          renodx::utils::settings::UpdateSetting("colorGradeBlowout", 65.f);
          renodx::utils::settings::UpdateSetting("colorGradeDechroma", 80.f);
        },
        .is_visible = []() { return game == 4 && shader_injection.toneMapType == 4.f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "HDR has to be enabled in game settings (requires Fullscreen Mode)!!!",
        .section = "Notes",
        .is_visible = []() { return game == 3; },
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
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", game == 4 ? 1050.f : 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", game == 4 ? 120.f : 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", game == 4 ? 120.f : 203.f);
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

bool fired_on_init_swapchain = false;
bool game_check = false;

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
    static std::mt19937 random_generator(std::chrono::system_clock::now().time_since_epoch().count());
    static auto random_range = static_cast<float>(std::mt19937::max() - std::mt19937::min());
  shader_injection.random = static_cast<float>(random_generator() + std::mt19937::min()) / random_range;
    if(game_check) return;
    if(game != 0) {
    game_check = true;
    if(game >= 3){
    settings[1]->labels = {"Vanilla", "None", "ACES", "RenoDRT", "Reinhard+"};
    settings[6]->labels = {"Per Channel", "Luminance"};
    settings[6]->is_enabled = []() { return shader_injection.toneMapType == 3.f; };
    settings[7]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
    settings[8]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
    settings[9]->is_visible = []() { return shader_injection.toneMapType >= 5.f; };
    settings[15]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
    settings[16]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
    settings[18]->tooltip = "Requires Bloom ON in game settings.",
    settings[20]->is_visible = []() { return is_sharpen_used; };
    }
    }
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Hard Reset Redux, Shadow Warrior (2013) & 2";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
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
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  return TRUE;
}