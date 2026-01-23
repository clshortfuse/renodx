/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

renodx::utils::settings::Settings settings = {
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
        .label = std::string("- Requires HDR on in game\n"
                             "- Use the in-game sliders to control paper white and peak brightness"),
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

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Resident Evil 7, 2 Remake, 3 Remake, and Village";

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
#if FORCE_HDR10
        if (!hdr10_init_event_registered) {
          reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchainForceHDR10);
          hdr10_init_event_registered = true;
        }
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
      reshade::unregister_addon(h_module);
      break;
  }
  renodx::utils::settings::Use(fdw_reason, &settings);

  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}