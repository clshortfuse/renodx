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

bool OnInspectCopyTextureToBuffer(
    reshade::api::command_list* cmd_list,
  reshade::api::resource source,
  uint32_t source_subresource,
  const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint64_t dest_offset,
  uint32_t row_length,
  uint32_t slice_height) {
  if (GetEnvironmentVariableW(L"RENODX_TRANSFER_INSPECT_UPGRADED", nullptr, 0u) == 0u) return false;

  renodx::utils::resource::upgrade::CopyRedirectTexture source_texture;
  if (!renodx::utils::resource::upgrade::GetCopyRedirectTexture(source, &source_texture)
    || source_texture.clone.handle == 0u) {
    return false;
  }

  cmd_list->copy_texture_to_buffer(
    source_texture.clone,
    source_subresource,
    source_box,
      dest,
      dest_offset,
    row_length,
    slice_height);
  reshade::log::message(
      reshade::log::level::info,
    "Copied upgraded texture into the application buffer for test inspection.");
  return false;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX Resource Upgrade Transfer Test";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "D3D12 resource transfer regression test";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD reason, LPVOID) {
  switch (reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      if (GetEnvironmentVariableW(L"RENODX_TRANSFER_DIRECT_UPGRADE", nullptr, 0u) != 0u) {
        for (auto& upgrade_info : UPGRADE_INFOS) {
          upgrade_info.use_resource_view_cloning = false;
        }
      }
      if (GetEnvironmentVariableW(L"RENODX_TRANSFER_PRESERVE_COPY_USAGE", nullptr, 0u) != 0u) {
        renodx::utils::resource::upgrade::use_vulkan_copy_usage = false;
      }
      renodx::utils::resource::upgrade::use_resource_cloning = true;
      renodx::utils::resource::upgrade::Use(reason);
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::copy_texture_to_buffer>(OnInspectCopyTextureToBuffer);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::copy_texture_to_buffer>(OnInspectCopyTextureToBuffer);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      renodx::utils::resource::upgrade::Use(reason);
      reshade::unregister_addon(h_module);
      break;
    default:
      break;
  }
  return TRUE;
}