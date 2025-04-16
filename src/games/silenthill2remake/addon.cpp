/*
 * Copyright (C) 2024 Ersh
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <embed/0x063CCF18.h>
#include <embed/0x421733C7.h>
#include <embed/0x72A44486.h>
#include <embed/0x77178C51.h>
#include <embed/0x865E53FC.h>
#include <embed/0xDA6D5332.h>
#include <embed/0x99145AE9.h>
#include <embed/0x309584F8.h>
#include <embed/0xFDFD3CB7.h>
#include <embed/0x1E7B589F.h>
#include <embed/0x9DF2DDD4.h>
#include <embed/0x507B8FB6.h>
#include <embed/0xA0A20D27.h>
#include <embed/0x18A5ACE1.h>
#include <embed/0x68E782E2.h>
#include <embed/0xBBB5CA7B.h>
#include <embed/0x4CC68F73.h>
#include <embed/0x9EB78561.h>
#include <embed/0xC496B5C3.h>
#include <embed/0x39235257.h>

#include <embed/0x1BC9EFE2.h>
#include <embed/0x3CB03848.h>
#include <embed/0x4B7B660D.h>
#include <embed/0x82F211C7.h>
#include <embed/0x95CC270F.h>
#include <embed/0x394B5831.h>
#include <embed/0x43713652.h>
#include <embed/0xBF32ABFA.h>

#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x063CCF18),
    CustomShaderEntry(0x421733C7),
    CustomShaderEntry(0x72A44486),
    CustomShaderEntry(0x77178C51),
    CustomShaderEntry(0x865E53FC),
    CustomShaderEntry(0xDA6D5332),
    CustomShaderEntry(0x99145AE9),
    CustomShaderEntry(0x309584F8),
    CustomShaderEntry(0xFDFD3CB7),
    CustomShaderEntry(0x1E7B589F),
    CustomShaderEntry(0x9DF2DDD4),
    CustomShaderEntry(0x507B8FB6),
    CustomShaderEntry(0xA0A20D27),
    CustomShaderEntry(0x18A5ACE1),
    CustomShaderEntry(0x68E782E2),
    CustomShaderEntry(0xBBB5CA7B),
    CustomShaderEntry(0x4CC68F73),
    CustomShaderEntry(0x9EB78561),
    CustomShaderEntry(0xC496B5C3),
    CustomShaderEntry(0x39235257),

    CustomShaderEntry(0x1BC9EFE2),
    CustomShaderEntry(0x3CB03848),
    CustomShaderEntry(0x4B7B660D),
    CustomShaderEntry(0x82F211C7),
    CustomShaderEntry(0x95CC270F),
    CustomShaderEntry(0x394B5831),
    CustomShaderEntry(0x43713652),
    CustomShaderEntry(0xBF32ABFA),
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "type",
        .binding = &shader_injection.type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .label = "Black Floor Fix Type",
        .section = "Fix",
        .tooltip = "Sets the black floor fix type.",
        .labels = {"Vanilla", "Fix black floor only", "Add gamma offset", "Add contrast offset"},
    },
    new renodx::utils::settings::Setting{
        .key = "magicNumber",
        .binding = &shader_injection.magicNumber,
        .default_value = 30.f,
        .label = "Offset Multiplier",
        .section = "Fix",
        .tooltip = "Sets the value of the gamma or contrast offset multiplier.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.type > 1; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "RenoDX by ShortFuse. Silent Hill 2 Remake mod by Ersh.",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/Z7kXxw5VDR");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Ersh's Ko-Fi",
        .section = "About",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/ershin");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "About",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
        },
    },
};

void OnPresetOff() {
    renodx::utils::settings::UpdateSetting("type", 0.f);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX - Silent Hill 2 Remake";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };
      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  return TRUE;
}
