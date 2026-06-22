/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
// #define DEBUG_LEVEL_1
// #define DEBUG_LEVEL_2
// #define DEBUG_LEVEL_3

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/settings.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

namespace upgrade_luts {

std::atomic_bool restart_required = false;
renodx::utils::settings::Setting* setting = nullptr;

void OnSettingChanged(float previous, float current) {
  if (previous != current) {
    restart_required.store(true, std::memory_order_relaxed);
  }
}

void OnInitDevice(reshade::api::device* device) {
  std::vector<renodx::utils::resource::ResourceUpgradeInfo> upgrade_infos = {};

  if (setting != nullptr && setting->GetValue() == 1.f) {
    int vendor_id;
    auto retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
    if (retrieved && vendor_id != 0x1002) {  // Do not apply on AMD GPUs.
      upgrade_infos.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .dimensions = {.width = 33, .height = 33, .depth = 33},
          .usage_include = reshade::api::resource_usage::unordered_access,
      });
      upgrade_infos.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .dimensions = {.width = 32, .height = 32, .depth = 32},
          .usage_include = reshade::api::resource_usage::unordered_access,
      });
      upgrade_infos.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .dimensions = {.width = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
                         .height = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
                         .depth = 1},
          .usage_include = reshade::api::resource_usage::render_target,
          .usage_exclude = reshade::api::resource_usage::unordered_access,
      });
    }
  }

  renodx::utils::resource::upgrade::SetUpgradeInfos(device, upgrade_infos);
}

}  // namespace upgrade_luts

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "WARNING: LUT Format changes require a restart to apply.",
        .section = "Advanced",
        .tint = 0xFF3B30,
        .is_visible = []() { return upgrade_luts::restart_required.load(std::memory_order_relaxed); },
        .is_sticky = true,
    },
    upgrade_luts::setting = new renodx::utils::settings::Setting{
        .key = "FxUpgradeLuts",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "LUT Format",
        .section = "Advanced",
        .tooltip = "Upgrades the LUT textures and full-resolution R11G11B10F render targets to R16G16B16A16F (requires restart). Disabled on AMD GPUs.",
        .labels = {"R11G11B10F", "R16G16B16A16F"},
        .on_change_value = &upgrade_luts::OnSettingChanged,
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "t9v7wx9NTD");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "musaqh");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "shortfuse");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Dead Space (2023)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;  // So overlays dont kill the game
      };

      // Replacement-only mod: do not inject cbuffers/root constants into Hitman root signatures to ensure stability
      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto) {
        return false;
      };

      renodx::utils::resource::upgrade::Use(fdw_reason);

      if (!initialized) {
        renodx::utils::settings::use_presets = false;
        // renodx::mods::shader::force_pipeline_cloning = true;

        initialized = true;
      }
      reshade::register_event<reshade::addon_event::init_device>(upgrade_luts::OnInitDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // detect peak nits

      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::resource::upgrade::Use(fdw_reason);

      reshade::unregister_event<reshade::addon_event::init_device>(upgrade_luts::OnInitDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // detect peak nits

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings);
  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}
