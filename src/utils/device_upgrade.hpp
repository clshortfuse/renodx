/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>

#include <atomic>

#include <include/reshade.hpp>
#include <include/reshade_api_device.hpp>

#include "./cross_addon.hpp"

namespace renodx::utils::device_upgrade {

struct __declspec(uuid("b3f2a1c4-9d7e-4b58-a321-0e5c8f6d2a94")) SharedData {
  std::atomic<bool> dx9ex_upgrade_requested = false;
  std::atomic<bool> dx9ex_upgrade_applied = false;
};

static cross_addon::Shared<SharedData> shared;

static bool use_dx9ex_upgrade = false;

static bool OnCreateDevice(reshade::api::device_api api, uint32_t& api_version) {
  if (!shared.IsEventHandler()) return false;
  if (api != reshade::api::device_api::d3d9) return false;
  if (api_version == 0x9100) return false;

  auto* shared_data = shared.data;
  if (!shared_data->dx9ex_upgrade_requested.load(std::memory_order_relaxed)) return false;

  shared_data->dx9ex_upgrade_applied.store(true, std::memory_order_relaxed);
  api_version = 0x9100;  // 0x9000 -> 0x9100, upgrade Direct3D 9 to Direct3D 9Ex
  return true;
}

static void Use(uint32_t fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (shared.RegisterModule([](SharedData& data) {
        if (use_dx9ex_upgrade) {
          data.dx9ex_upgrade_requested = true;
        }
      })) {
        reshade::log::message(reshade::log::level::info, "utils::device_upgrade attached.");
      }
#if RESHADE_API_VERSION >= 17
      shared.RegisterEvent<reshade::addon_event::create_device>(OnCreateDevice, use_dx9ex_upgrade);
#endif
      break;
    case DLL_PROCESS_DETACH:
#if RESHADE_API_VERSION >= 17
      shared.UnregisterEvent<reshade::addon_event::create_device>(OnCreateDevice);
#endif
      shared.UnregisterModule();
      break;
    default:
      break;
  }
}

}  // namespace renodx::utils::device_upgrade
