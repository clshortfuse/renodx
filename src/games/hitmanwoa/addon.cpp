/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

#if ENABLE_SHADER_TOGGLE
namespace shader_toggle {
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

void Initialize() {
  g_current_use_shaders = -1.0f;
  reshade::register_event<reshade::addon_event::present>(OnPresent);
}

void Cleanup() {
  reshade::unregister_event<reshade::addon_event::present>(OnPresent);
}

renodx::utils::settings::Setting* GetSetting() {
  return new renodx::utils::settings::Setting{
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
}  // namespace shader_toggle
#endif

renodx::utils::settings::Settings settings = {
#if ENABLE_SHADER_TOGGLE
    shader_toggle::GetSetting(),
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
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- GAMMA CORRECTION slider controls game brightness (paper white)\n"
                             "- MAX. INTENSITY slider controls peak brightness\n"
                             "- Formula for peak brightness: MAX. INTENSITY slider * paper white / 2\n"
                             "- e.g. MAX.INTENSITY 10.00 and GAMMA CORRECTION 1.00 = 200 nits paper white, 1000 nits peak\n"
                             "+--------+-------------+\n"
                             "| Slider | Paper White |\n"
                             "+--------+-------------+\n"
                             "|  0.80  |     100     |\n"
                             "+--------+-------------+\n"
                             "|  0.82  |     108     |\n"
                             "+--------+-------------+\n"
                             "|  0.85  |     117     |\n"
                             "+--------+-------------+\n"
                             "|  0.88  |     128     |\n"
                             "+--------+-------------+\n"
                             "|  0.90  |     140     |\n"
                             "+--------+-------------+\n"
                             "|  0.93  |     152     |\n"
                             "+--------+-------------+\n"
                             "|  0.95  |     167     |\n"
                             "+--------+-------------+\n"
                             "|  0.97  |     181     |\n"
                             "+--------+-------------+\n"
                             "|  1.00  |     200     |\n"
                             "+--------+-------------+\n"
                             "|  1.02  |     221     |\n"
                             "+--------+-------------+\n"
                             "|  1.05  |     242     |\n"
                             "+--------+-------------+\n"
                             "|  1.07  |     268     |\n"
                             "+--------+-------------+\n"
                             "|  1.10  |     300     |\n"
                             "+--------+-------------+\n"
                             "|  1.12  |     331     |\n"
                             "+--------+-------------+\n"
                             "|  1.15  |     370     |\n"
                             "+--------+-------------+\n"
                             "|  1.18  |     416     |\n"
                             "+--------+-------------+\n"
                             "|  1.20  |     468     |\n"
                             "+--------+-------------+\n"),
        .section = "About",
    },
};

#if FORCE_HDR10
bool hdr10_init_event_registered = false;

void OnInitSwapchainForceHDR10(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();
  if (device == nullptr) return;

  const auto desc = device->get_resource_desc(swapchain->get_current_back_buffer());
  const bool hdr_back_buffer =
      desc.texture.format == reshade::api::format::r10g10b10a2_unorm || desc.texture.format == reshade::api::format::r10g10b10a2_typeless;

  const auto current_space = swapchain->get_color_space();

  if (hdr_back_buffer && current_space != reshade::api::color_space::hdr10_st2084) {
    renodx::utils::swapchain::ChangeColorSpace(swapchain, reshade::api::color_space::hdr10_st2084);
  } else if (!hdr_back_buffer && current_space == reshade::api::color_space::hdr10_st2084) {
    renodx::utils::swapchain::ChangeColorSpace(swapchain, reshade::api::color_space::srgb_nonlinear);
  }
}
#endif

bool initialized = false;

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for HITMAN World of Assassination";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::utils::settings::use_presets = false;

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;  // So overlays dont kill the game
      };

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::utils::shader::use_replace_async = true;

#if FORCE_HDR10
        if (!hdr10_init_event_registered) {
          reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchainForceHDR10);
          hdr10_init_event_registered = true;
        }
#endif

#if ENABLE_SHADER_TOGGLE
        shader_toggle::Initialize();
#endif
        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
#if FORCE_HDR10
      if (hdr10_init_event_registered) {
        reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchainForceHDR10);
        hdr10_init_event_registered = false;
      }
#endif

#if ENABLE_SHADER_TOGGLE
      shader_toggle::Cleanup();
#endif

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings);

  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}