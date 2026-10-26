/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <windows.h>

#include <array>
#include <cstddef>
#include <cstdint>

#include <include/reshade.hpp>

#include "../../utils/bitwise.hpp"
#include "../../utils/data.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"

namespace rdr2vk::resource_fixes {
namespace internal {

// The SDK headers select this path at compile time, even on newer ReShade runtimes.
#if RESHADE_API_VERSION < 20
static void OnEndRenderPass(reshade::api::command_list* cmd_list) {
  if (cmd_list->get_device()->get_api() != reshade::api::device_api::vulkan) return;
  auto* cmd_list_data = renodx::utils::data::Get<renodx::utils::resource::upgrade::CommandListData>(cmd_list);
  if (cmd_list_data == nullptr || cmd_list_data->pending_render_pass_render_targets.empty()) return;

  // Load-op clears are real writes even if the pass records no draw. Run before
  // the shared end callback, which would otherwise discard these pending clones.
  renodx::utils::resource::upgrade::HandlePendingRenderPassRenderTargets(cmd_list, cmd_list_data);
}
#endif

static bool OnCopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source, std::uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest, std::uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  auto* device = cmd_list->get_device();
  if (device->get_api() != reshade::api::device_api::vulkan) return false;
  const auto* shared = renodx::utils::resource::upgrade::shared.data;
  if (shared != nullptr && shared->use_auto_cloning) return false;

  struct Endpoint {
    reshade::api::resource resource;
    reshade::api::format format = reshade::api::format::unknown;
    bool upgraded = false;
  };
  std::array endpoints = {Endpoint{.resource = source}, Endpoint{.resource = dest}};
  for (std::size_t index = 0; index < endpoints.size(); ++index) {
    auto& endpoint = endpoints[index];
    const auto required_usage = (index == 0 ? reshade::api::resource_usage::copy_source : reshade::api::resource_usage::copy_dest);
    renodx::utils::resource::GetLiveResourceInfo(endpoint.resource, [&](const auto& info) {
      // The shared callback already handles enabled clones. Do not issue a second copy.
      if (info.device != device || info.clone_enabled
          || info.desc.type != reshade::api::resource_type::texture_2d || info.desc.texture.samples != 1
          || !renodx::utils::bitwise::HasFlag(info.desc.usage, required_usage)) return;
      switch (info.desc.texture.format) {
        case reshade::api::format::r16g16b16a16_float:
        case reshade::api::format::r11g11b10_float:
        case reshade::api::format::r8g8b8a8_unorm:
        case reshade::api::format::b8g8r8a8_unorm:
        case reshade::api::format::r10g10b10a2_unorm:
          endpoint.format = info.desc.texture.format;
          endpoint.upgraded = info.upgraded;
          break;
        default:
          break;
      }
    });
    if (endpoint.format == reshade::api::format::unknown) return false;
  }
  if ((!endpoints[0].upgraded && !endpoints[1].upgraded)
      || renodx::utils::resource::AreCopyFormatsCompatible(endpoints[0].format, endpoints[1].format)
      || !device->check_capability(reshade::api::device_caps::blit)) return false;

  // Native Vulkan copies arrive as region events. With no clone redirection the
  // shared handler falls through, leaving an invalid copy after a direct upgrade.
  cmd_list->copy_texture_region(source, source_subresource, source_box, dest, dest_subresource, dest_box, filter);
  return true;
}

}  // namespace internal

static void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
#if RESHADE_API_VERSION < 20
    reshade::register_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
#endif
    reshade::register_event<reshade::addon_event::copy_texture_region>(internal::OnCopyTextureRegion);
  } else if (reason == DLL_PROCESS_DETACH) {
#if RESHADE_API_VERSION < 20
    reshade::unregister_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
#endif
    reshade::unregister_event<reshade::addon_event::copy_texture_region>(internal::OnCopyTextureRegion);
  }
}

}  // namespace rdr2vk::resource_fixes