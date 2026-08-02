/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define DEBUG_LEVEL_0

#include <array>
#include <include/reshade.hpp>

#include "src/utils/resource_upgrade.hpp"

namespace {

std::array<renodx::utils::resource::ResourceUpgradeInfo, 2> UPGRADE_INFOS = {{
    {
        .old_format = reshade::api::format::r8g8b8a8_unorm,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .ignore_size = false,
        .use_resource_view_cloning = true,
        .dimensions = {.width = 4, .height = 4, .depth = 1},
        .name = "test rgba8 transfer texture",
    },
    {
        .old_format = reshade::api::format::r10g10b10a2_unorm,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .ignore_size = false,
        .use_resource_view_cloning = true,
        .dimensions = {.width = 4, .height = 4, .depth = 1},
        .name = "test rgb10a2 transfer texture",
    },
}};

void OnInitDevice(reshade::api::device* device) {
  renodx::utils::resource::upgrade::SetUpgradeInfos(device, UPGRADE_INFOS);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX Resource Upgrade Transfer Test";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "D3D12 resource transfer regression test";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD reason, LPVOID) {
  switch (reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::utils::resource::upgrade::use_resource_cloning = true;
      renodx::utils::resource::upgrade::Use(reason);
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      renodx::utils::resource::upgrade::Use(reason);
      reshade::unregister_addon(h_module);
      break;
    default:
      break;
  }
  return TRUE;
}