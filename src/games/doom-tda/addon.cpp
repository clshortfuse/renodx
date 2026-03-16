/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <atomic>

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xE3A05FA7),  // ACES tonemap
};

#if USE_SHADER_TOGGLE
namespace shader_toggle {
namespace runtime {
float g_use_shaders = 1.f;          // Controlled by slider
float g_current_use_shaders = 1.f;  // Will be overridden on startup
std::atomic_bool g_requires_hdr_refresh = false;

void OnToneMapLutBuilderDrawn(reshade::api::command_list* /*cmd_list*/) {
  g_requires_hdr_refresh.store(false, std::memory_order_relaxed);
}

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
  g_requires_hdr_refresh.store(false, std::memory_order_relaxed);
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
        g_requires_hdr_refresh.store(true, std::memory_order_relaxed);
      },
  };
}
}  // namespace runtime
}  // namespace shader_toggle
#endif

renodx::utils::settings::Settings settings = {
#if USE_SHADER_TOGGLE
    shader_toggle::runtime::GetSetting(),
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Toggle HDR off and on again to apply shader toggle changes.",
        .section = "Options",
        .tint = 0xFF0000,
        .is_visible = []() {
          return shader_toggle::runtime::g_requires_hdr_refresh.load(std::memory_order_relaxed);
        },
        .is_sticky = true,
    },
#endif
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
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for DOOM: The Dark Ages";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::utils::settings::use_presets = false;
#if USE_SHADER_TOGGLE
      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::utils::shader::use_replace_async = true;
      if (auto shader = custom_shaders.find(0xE3A05FA7); shader != custom_shaders.end()) {
        shader->second.on_drawn = &shader_toggle::runtime::OnToneMapLutBuilderDrawn;
      }
      shader_toggle::runtime::RegisterEvents();
#endif
      break;
    case DLL_PROCESS_DETACH:
#if USE_SHADER_TOGGLE
      shader_toggle::runtime::UnregisterEvents();
#endif
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings);
  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}
