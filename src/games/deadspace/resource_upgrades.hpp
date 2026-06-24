/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <vector>

#include <include/reshade.hpp>

#include "../../utils/resource_upgrade.hpp"
#include "../../utils/settings.hpp"
#include "shared.h"

namespace deadspace::resource_upgrades {

#if DEADSPACE_ENABLE_RESOURCE_UPGRADES

inline std::atomic_bool restart_required = false;
inline renodx::utils::settings::Setting* setting = nullptr;

inline void OnSettingChanged(float previous, float current) {
  if (previous != current) {
    restart_required.store(true, std::memory_order_relaxed);
  }
}

inline renodx::utils::settings::Setting* CreateRestartWarningSetting() {
  return new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = "WARNING: Resource format changes require a restart to apply.",
      .section = "Advanced",
      .tint = 0xFF3B30,
      .is_visible = []() { return restart_required.load(std::memory_order_relaxed); },
      .is_sticky = true,
  };
}

inline renodx::utils::settings::Setting* CreateSetting() {
  return setting = new renodx::utils::settings::Setting{
             .key = "FxUpgradeResources",
             .value_type = renodx::utils::settings::SettingValueType::INTEGER,
             .default_value = 1.f,
             .label = "Render Format",
             .section = "Advanced",
             .tooltip = "Upgrades HDR render resources to R16G16B16A16F to add wide gamut support and improve bit depth (requires restart). Disabled on AMD GPUs.",
             .labels = {"R11G11B10F", "R16G16B16A16F"},
             .on_change_value = &OnSettingChanged,
             .is_global = true,
         };
}

inline void OnInitDevice(reshade::api::device* device) {
  std::vector<renodx::utils::resource::ResourceUpgradeInfo> upgrade_infos = {};

  if (setting != nullptr && setting->GetValue() == 1.f) {
    int vendor_id = 0;
    auto retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
    if (retrieved && vendor_id != 0x1002) {  // Do not apply on AMD GPUs.
      upgrade_infos.push_back({
          // ACES LUTbuilder
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .dimensions = {.width = 33, .height = 33, .depth = 33},
          .usage_include = reshade::api::resource_usage::unordered_access,
      });
      upgrade_infos.push_back({
          // Outer LUTbuilder
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .dimensions = {.width = 32, .height = 32, .depth = 32},
          .usage_include = reshade::api::resource_usage::unordered_access,
      });
      upgrade_infos.push_back({
          // Render
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

inline void Register() {
  renodx::utils::resource::upgrade::use_resource_cloning_dx12_only = true;
  renodx::utils::resource::upgrade::Use(DLL_PROCESS_ATTACH);
  reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
}

inline void Unregister() {
  renodx::utils::resource::upgrade::Use(DLL_PROCESS_DETACH);
  reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
}

#else

inline void Register() {}
inline void Unregister() {}

#endif  // DEADSPACE_ENABLE_RESOURCE_UPGRADES

}  // namespace deadspace::resource_upgrades