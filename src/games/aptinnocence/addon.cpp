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
#include "../../utils/settings.hpp"
#include "../../utils/date.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

bool is_vignette_enabled = false;
bool is_grain_enabled = false;
bool is_CA_enabled = false;
bool is_DoF_enabled = false;
bool is_bloom_enabled = false;
bool is_sharpen_used = false;
bool is_pp_disabled = false;

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xB5DC058C),      // videos
    CustomShaderEntryCallback(0xE6BB6773, [](reshade::api::command_list* cmd_list) {      // tonemap
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xD7192C56, [](reshade::api::command_list* cmd_list) {      // tonemap 2
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xF2243AFF, [](reshade::api::command_list* cmd_list) {      // tonemap 3
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x5AF10FE1, [](reshade::api::command_list* cmd_list) {      // tonemap 4
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x33AB5404, [](reshade::api::command_list* cmd_list) {      // tonemap 5
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    is_pp_disabled = true;
    return true;
    }),
    CustomShaderEntryCallback(0xBEE9C40B, [](reshade::api::command_list* cmd_list) {      // tonemap 6
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x71C6DC6C, [](reshade::api::command_list* cmd_list) {  // tonemap 7
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xBFDFDB81, [](reshade::api::command_list* cmd_list) {  // tonemap 8
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA57B2A6D, [](reshade::api::command_list* cmd_list) {  // tonemap 9
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xABA0921A, [](reshade::api::command_list* cmd_list) {  // tonemap 10
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x50C4614E, [](reshade::api::command_list* cmd_list) {  // tonemap 11
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x4D27EFE4, [](reshade::api::command_list* cmd_list) {  // tonemap 12
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x02752086, [](reshade::api::command_list* cmd_list) {  // tonemap 13
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x1E95DFAA, [](reshade::api::command_list* cmd_list) {  // tonemap 14
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x1EAC2755, [](reshade::api::command_list* cmd_list) {  // tonemap 15
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xB08D4631, [](reshade::api::command_list* cmd_list) {  // tonemap 16
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x40D01156, [](reshade::api::command_list* cmd_list) {  // tonemap 17
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x16B3D4EA, [](reshade::api::command_list* cmd_list) {  // tonemap 18
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x467FA5E8, [](reshade::api::command_list* cmd_list) {  // tonemap 19
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x6BD6CCF2, [](reshade::api::command_list* cmd_list) {  // tonemap 20
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x35394394, [](reshade::api::command_list* cmd_list) {  // tonemap 21
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x861391DC, [](reshade::api::command_list* cmd_list) {  // tonemap 22
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x2AD07A02, [](reshade::api::command_list* cmd_list) {  // tonemap 23
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x9051A7A9, [](reshade::api::command_list* cmd_list) {  // tonemap 24
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xEFEDB0D0, [](reshade::api::command_list* cmd_list) {  // tonemap 25
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xBCC02A24, [](reshade::api::command_list* cmd_list) {  // tonemap 26
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x0502EF4A, [](reshade::api::command_list* cmd_list) {  // tonemap 27
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x261B3413, [](reshade::api::command_list* cmd_list) {  // tonemap 28
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x5A4546CF, [](reshade::api::command_list* cmd_list) {  // tonemap 29
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x516235E2, [](reshade::api::command_list* cmd_list) {  // tonemap 30
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xD4020FAA, [](reshade::api::command_list* cmd_list) {  // tonemap 31
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x43BB0F12, [](reshade::api::command_list* cmd_list) {  // tonemap 32
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xCFDE7F0C, [](reshade::api::command_list* cmd_list) {  // tonemap 33
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x0BE823E1, [](reshade::api::command_list* cmd_list) {  // tonemap 34
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xDB64B2BB, [](reshade::api::command_list* cmd_list) {  // tonemap 35
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xCE06587B, [](reshade::api::command_list* cmd_list) {  // tonemap 36
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x01DE0656, [](reshade::api::command_list* cmd_list) {  // tonemap 37
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x74C290ED, [](reshade::api::command_list* cmd_list) {  // tonemap 38
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x844E8541, [](reshade::api::command_list* cmd_list) {  // tonemap 39
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x4029D69D, [](reshade::api::command_list* cmd_list) {  // tonemap 40
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA8D32BBB, [](reshade::api::command_list* cmd_list) {  // tonemap 41
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xE4863DCF, [](reshade::api::command_list* cmd_list) {  // tonemap 42
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xDB93313F, [](reshade::api::command_list* cmd_list) {  // tonemap 43
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xEB551321, [](reshade::api::command_list* cmd_list) {  // tonemap 44
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xB11E80DD, [](reshade::api::command_list* cmd_list) {  // tonemap 45
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x0A6C1673, [](reshade::api::command_list* cmd_list) {  // tonemap 46
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x00D8F487, [](reshade::api::command_list* cmd_list) {  // tonemap 47
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xF35DA225, [](reshade::api::command_list* cmd_list) {  // tonemap 48
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x25B30D2A, [](reshade::api::command_list* cmd_list) {  // tonemap 49
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x909013F7, [](reshade::api::command_list* cmd_list) {  // tonemap 50
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x9EE29144, [](reshade::api::command_list* cmd_list) {  // tonemap 51
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xC4C8EDDD, [](reshade::api::command_list* cmd_list) {  // tonemap 52
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA12D3746, [](reshade::api::command_list* cmd_list) {  // tonemap 53
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x5DBD59DA, [](reshade::api::command_list* cmd_list) {  // tonemap 54
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x85D588FD, [](reshade::api::command_list* cmd_list) {  // tonemap 55
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x8CAD268A, [](reshade::api::command_list* cmd_list) {  // tonemap 56
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xB32D7EBA, [](reshade::api::command_list* cmd_list) {  // tonemap 57
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x035059E4, [](reshade::api::command_list* cmd_list) {  // tonemap 58
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x597228FA, [](reshade::api::command_list* cmd_list) {  // tonemap 59
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x255A96DB, [](reshade::api::command_list* cmd_list) {  // tonemap 60
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x63E8AB08, [](reshade::api::command_list* cmd_list) {  // tonemap 61
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x959A3AF5, [](reshade::api::command_list* cmd_list) {  // tonemap 62
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x066605F5, [](reshade::api::command_list* cmd_list) {  // tonemap 63
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xCE610F96, [](reshade::api::command_list* cmd_list) {  // tonemap 64
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA01B0251, [](reshade::api::command_list* cmd_list) {  // tonemap 65
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x56D076D5, [](reshade::api::command_list* cmd_list) {  // tonemap 66
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x653632FF, [](reshade::api::command_list* cmd_list) {  // tonemap 67
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xB005022A, [](reshade::api::command_list* cmd_list) {  // tonemap 68
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xCA4C7F6E, [](reshade::api::command_list* cmd_list) {  // tonemap 69
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xE3F00C37, [](reshade::api::command_list* cmd_list) {  // tonemap 70
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x2339F1B3, [](reshade::api::command_list* cmd_list) {  // tonemap 71
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xC2956128, [](reshade::api::command_list* cmd_list) {  // tonemap 72
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xAEBDF7AA, [](reshade::api::command_list* cmd_list) {  // tonemap 73
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x0326D4CA, [](reshade::api::command_list* cmd_list) {  // tonemap 74
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x8DDB9366, [](reshade::api::command_list* cmd_list) {  // tonemap 75
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xADCA1C5F, [](reshade::api::command_list* cmd_list) {  // tonemap 76
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x4DAFFF3D, [](reshade::api::command_list* cmd_list) {  // tonemap 77
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x66FAEF88, [](reshade::api::command_list* cmd_list) {  // tonemap 78
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xAFB77956, [](reshade::api::command_list* cmd_list) {  // tonemap 79
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x8482C5D3, [](reshade::api::command_list* cmd_list) {  // tonemap 80
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xEFC1F305, [](reshade::api::command_list* cmd_list) {  // tonemap 81
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xBC6EF18F, [](reshade::api::command_list* cmd_list) {  // tonemap 82
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x555A8762, [](reshade::api::command_list* cmd_list) {  // tonemap 83
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x1565A261, [](reshade::api::command_list* cmd_list) {  // tonemap 84
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xC4E27A54, [](reshade::api::command_list* cmd_list) {  // tonemap 85
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x5FEF8F53, [](reshade::api::command_list* cmd_list) {  // tonemap 86
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA2273C02, [](reshade::api::command_list* cmd_list) {  // tonemap 87
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x2F905EC9, [](reshade::api::command_list* cmd_list) {  // tonemap 88
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xEDC2424D, [](reshade::api::command_list* cmd_list) {  // tonemap 89
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x1BB00117, [](reshade::api::command_list* cmd_list) {  // tonemap 90
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x1DFA514E, [](reshade::api::command_list* cmd_list) {  // tonemap 91
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x7D28E177, [](reshade::api::command_list* cmd_list) {  // tonemap 92
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x85FB39A3, [](reshade::api::command_list* cmd_list) {  // tonemap 93
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x16080FD2, [](reshade::api::command_list* cmd_list) {  // tonemap 94
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x04126082, [](reshade::api::command_list* cmd_list) {  // tonemap 95
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x0B316689, [](reshade::api::command_list* cmd_list) {  // tonemap 96
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x24C4FD62, [](reshade::api::command_list* cmd_list) {  // tonemap 97
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xB3914B14, [](reshade::api::command_list* cmd_list) {  // tonemap 98
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x1345B102, [](reshade::api::command_list* cmd_list) {  // tonemap 99
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xDD331269, [](reshade::api::command_list* cmd_list) {  // tonemap 100
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x0CC2075D, [](reshade::api::command_list* cmd_list) {  // tonemap 101
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x9C37C1D9, [](reshade::api::command_list* cmd_list) {  // tonemap 102
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x68333490, [](reshade::api::command_list* cmd_list) {  // tonemap 103
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xA900199B, [](reshade::api::command_list* cmd_list) {  // tonemap 104
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xBE0A06A2, [](reshade::api::command_list* cmd_list) {  // tonemap 105
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x5E5602ED, [](reshade::api::command_list* cmd_list) {  // tonemap 106
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x9BBD5A1C, [](reshade::api::command_list* cmd_list) {  // tonemap 107
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x46EA6003, [](reshade::api::command_list* cmd_list) {  // tonemap 108
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x2935CA66, [](reshade::api::command_list* cmd_list) {  // tonemap 109
    is_vignette_enabled = false;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x17943E7D, [](reshade::api::command_list* cmd_list) {  // tonemap 110
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x26130AF5, [](reshade::api::command_list* cmd_list) {  // tonemap 111
    is_vignette_enabled = false;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x6C3C86DA, [](reshade::api::command_list* cmd_list) {  // tonemap 112
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x816D20DE, [](reshade::api::command_list* cmd_list) {  // tonemap 113
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x11ACF198, [](reshade::api::command_list* cmd_list) {  // tonemap 114
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x54C8FFE4, [](reshade::api::command_list* cmd_list) {  // tonemap 115
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x77EEDC99, [](reshade::api::command_list* cmd_list) {  // tonemap 116
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xD18F2C1B, [](reshade::api::command_list* cmd_list) {  // tonemap 117
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xEC579C44, [](reshade::api::command_list* cmd_list) {  // tonemap 118
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xFC92FC89, [](reshade::api::command_list* cmd_list) {  // tonemap 119
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x357951FE, [](reshade::api::command_list* cmd_list) {  // tonemap 120
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xC6178618, [](reshade::api::command_list* cmd_list) {  // tonemap 121
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x6AEA77DC, [](reshade::api::command_list* cmd_list) {  // tonemap 122
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x66135DC8, [](reshade::api::command_list* cmd_list) {  // tonemap 123
    is_vignette_enabled = true;
    is_grain_enabled = false;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x8A35C041, [](reshade::api::command_list* cmd_list) {  // tonemap 124
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xCD0E9660, [](reshade::api::command_list* cmd_list) {  // tonemap 125
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xD7F6CD5F, [](reshade::api::command_list* cmd_list) {  // tonemap 126
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xF1BA177B, [](reshade::api::command_list* cmd_list) {  // tonemap 127
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x32E1A18D, [](reshade::api::command_list* cmd_list) {  // tonemap 128
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0xD93DEDCD, [](reshade::api::command_list* cmd_list) {  // tonemap 129
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = true;
    is_DoF_enabled = false;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x3200CCB7, [](reshade::api::command_list* cmd_list) {  // tonemap 130
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0xD18FD7EC, [](reshade::api::command_list* cmd_list) {  // tonemap 131
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = true;
    return true;
    }),
    CustomShaderEntryCallback(0x0B3A9151, [](reshade::api::command_list* cmd_list) {  // tonemap 132
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x7A8541CB, [](reshade::api::command_list* cmd_list) {  // tonemap 133
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = true;
    is_bloom_enabled = false;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x25F05C9E, [](reshade::api::command_list* cmd_list) {  // tonemap 134
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntryCallback(0x6842A427, [](reshade::api::command_list* cmd_list) {  // tonemap 135
    is_vignette_enabled = true;
    is_grain_enabled = true;
    is_CA_enabled = false;
    is_DoF_enabled = false;
    is_bloom_enabled = true;
    is_sharpen_used = false;
    return true;
    }),
    CustomShaderEntry(0x16D5DBDF),      // final
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
        .tint = 0xD82D19,
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
        .tint = 0xF26E1C,
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
        .tint = 0xF26E1C,
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
        .tint = 0xF26E1C,
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
        .tint = 0xF2971D,
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
        .tint = 0xF2971D,
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
        .tint = 0xF2971D,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tint = 0xF2971D,
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
        .tint = 0xAC7C38,
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
        .tint = 0x3A5953,
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
        .tint = 0x96AD50,
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
        .tint = 0x142616,
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
        .tint = 0x3A5953,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .tint = 0x3A5953,
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
        .tint = 0x3A5953,
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
        .tint = 0x3A5953,
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
        .tint = 0x3A5953,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .tint = 0x3A5953,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1 && !is_pp_disabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTScaling",
        .binding = &shader_injection.colorGradeLUTScaling,
        .default_value = 100.f,
        .label = "LUT Scaling",
        .section = "Color Grading",
        .tint = 0x3A5953,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2 && !is_pp_disabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxAutoExposure",
        .binding = &shader_injection.fxAutoExposure,
        .default_value = 100.f,
        .label = "Auto Exposure",
        .section = "Effects",
        .tint = 0xEC4E1B,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return !is_pp_disabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxChroma",
        .binding = &shader_injection.fxChroma,
        .default_value = 50.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tint = 0xEC4E1B,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return is_CA_enabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxSharpen",
        .binding = &shader_injection.fxSharpen,
        .default_value = 50.f,
        .label = "Sharpening",
        .section = "Effects",
        .tooltip = "Slider disabled when game is paused (available in photo mode instead).",
        .tint = 0xEC4E1B,
        .max = 100.f,
        .is_enabled = []() { return is_sharpen_used; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .tint = 0xEC4E1B,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return is_bloom_enabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxLens",
        .binding = &shader_injection.fxLens,
        .default_value = 50.f,
        .label = "Lens Dirt/Flare",
        .section = "Effects",
        .tint = 0xEC4E1B,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return is_bloom_enabled && current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxDoF",
        .binding = &shader_injection.fxDoF,
        .default_value = 100.f,
        .label = "Depth of Field",
        .section = "Effects",
        .tooltip = "Slider disabled when game is paused (available in photo mode instead).",
        .tint = 0xEC4E1B,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return is_DoF_enabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxVignette",
        .binding = &shader_injection.fxVignette,
        .default_value = 100.f,
        .label = "Vignette",
        .section = "Effects",
        .tint = 0xEC4E1B,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return is_vignette_enabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "Film Grain",
        .section = "Effects",
        .tint = 0xEC4E1B,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return is_grain_enabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrainType",
        .binding = &shader_injection.fxFilmGrainType,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Film Grain Type",
        .section = "Effects",
        .labels = {"Vanilla", "Perceptual"},
        .tint = 0xEC4E1B,
        .is_visible = []() { return is_grain_enabled; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0x0D1D34,
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
          renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 100.f); },
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
          renodx::utils::settings::UpdateSetting("colorGradeFlare", 20.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 100.f); },
        .is_visible = []() { return shader_injection.toneMapType == 3.f; },
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
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
  renodx::utils::settings::UpdateSetting("fxAutoExposure", 100.f);
  renodx::utils::settings::UpdateSetting("fxChroma", 50.f);
  renodx::utils::settings::UpdateSetting("fxSharpen", 50.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxLens", 50.f);
  renodx::utils::settings::UpdateSetting("fxDoF", 100.f);
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
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for A Plague Tale: Innocence";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::prevent_full_screen = true;

      // RGBA8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = true,
          .usage_include = reshade::api::resource_usage::render_target,
      });
      // RGBA8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = false,
      });
      // RGB10A2_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = true,
      });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  return TRUE;
}
