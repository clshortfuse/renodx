/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x94CF25A1),  // post process + ACEScc LUT + ACES ToneMap
    CustomShaderEntry(0x0FB3C8A5),  // post process + ACES ToneMap
    CustomShaderEntry(0x3AF8585D),  // ACES ToneMap LUTbuilder
    CustomShaderEntry(0xF40407A5),  // Composite Scene + UI
};

namespace shader_toggle {
namespace runtime {
float g_use_shaders = 1.f;          // Controlled by slider
float g_current_use_shaders = 1.f;  // Will be overridden on startup

void OnPresent(
    reshade::api::command_queue*,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect*,
    const reshade::api::rect*,
    uint32_t,
    const reshade::api::rect*) {
  if (g_use_shaders != g_current_use_shaders) {
    reshade::log::message(
        reshade::log::level::info,
        (g_use_shaders != 0.f) ? "Enabling shaders (toggle)" : "Disabling shaders (toggle)");

    auto* device = swapchain->get_device();
    if (device == nullptr) {
      reshade::log::message(reshade::log::level::error, "Device is null in OnPresent");
      g_current_use_shaders = g_use_shaders;
      return;
    }

    if (g_use_shaders != 0.f) {
      for (const auto& [hash, shader] : custom_shaders) {
        renodx::utils::shader::AddRuntimeReplacement(device, hash, shader.code);
      }
      reshade::log::message(
          reshade::log::level::info,
          ("Injected " + std::to_string(custom_shaders.size()) + " shaders").c_str());
    } else {
      renodx::utils::shader::RemoveRuntimeReplacements(device);
      reshade::log::message(reshade::log::level::info, "Removed all shader replacements.");
    }

    g_current_use_shaders = g_use_shaders;
  }
}

void RegisterEvents() {
  g_current_use_shaders = -1.0f;
  reshade::register_event<reshade::addon_event::present>(OnPresent);
}

void UnregisterEvents() {
  reshade::unregister_event<reshade::addon_event::present>(OnPresent);
}

renodx::utils::settings::Setting* GetSetting() {
  return new renodx::utils::settings::Setting{
      .key = "",
      .binding = &g_use_shaders,
      .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
      .default_value = 1.f,
      .label = "Enable Mod",
      .section = "Options",
      .on_change = []() {
        g_current_use_shaders = -1.f;
      },
  };
}
}  // namespace runtime
}  // namespace shader_toggle

renodx::utils::settings::Settings settings = {
    shader_toggle::runtime::GetSetting(),
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/musaqh"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Requires HDR on in game"),
        .section = "About",
    },
};

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Indiana Jones and the Great Circle";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::utils::settings::use_presets = false;
      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::utils::shader::use_replace_async = true;
      shader_toggle::runtime::RegisterEvents();
      break;
    case DLL_PROCESS_DETACH:
      shader_toggle::runtime::UnregisterEvents();
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings);
  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}
