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
#include "../../utils/log.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"

namespace rdr2vk::resource_fixes {
namespace internal {

static bool descriptor_filters_installed = false;

static bool HasEnabledTextureClone(
    reshade::api::device* device, const reshade::api::descriptor_table_update& update) {
  if (update.count == 0 || update.descriptors == nullptr) return false;
  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view:
    case reshade::api::descriptor_type::texture_shader_resource_view:
    case reshade::api::descriptor_type::texture_unordered_access_view:
      break;
    default:
      // These descriptor types store different kinds of data, not texture views.
      // Return before reading them, especially the game's short-lived buffer views.
      return false;
  }
  for (std::uint32_t index = 0; index < update.count; ++index) {
    const auto view = (update.type == reshade::api::descriptor_type::sampler_with_resource_view
                           ? static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index].view
                           : static_cast<const reshade::api::resource_view*>(update.descriptors)[index]);
    if (view.handle == 0) continue;
    bool enabled = false;
    // Only read our saved view information here. The driver may already have
    // freed the view. Leave clone creation and binding changes to the shared code.
    renodx::utils::resource::GetLiveResourceViewInfo(view, [&](const auto& info) {
      enabled = info.device == device && !info.is_clone && info.clone_enabled
                && info.original_resource.handle != 0 && info.desc.type != reshade::api::resource_view_type::buffer;
    });
    if (enabled) return true;
  }
  return false;
}

static bool OnUpdateDescriptorTables(
    reshade::api::device* device, std::uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (!renodx::utils::resource::upgrade::shared.IsEventHandler()) return false;
  for (std::uint32_t index = 0; index < count; ++index) {
    if (updates[index].table.handle != 0 && HasEnabledTextureClone(device, updates[index])) {
      // If any texture needs its clone, let the shared code handle the whole
      // update. Keep the game's other bindings, including buffers, in that update.
      return renodx::utils::resource::upgrade::OnUpdateDescriptorTables(device, count, updates);
    }
  }
  // Returning false lets the game's original update continue unchanged.
  return false;
}

static void OnPushDescriptors(
    reshade::api::command_list* cmd_list, reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout, std::uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (!renodx::utils::resource::upgrade::shared.IsEventHandler()
      || !HasEnabledTextureClone(cmd_list->get_device(), update)) return;
  // Compute shaders must also use the clone when they read a cloned texture.
  renodx::utils::resource::upgrade::OnPushDescriptors(cmd_list, stages, layout, layout_param, update);
}

// This depends on the headers used to build the addon, not the installed ReShade version.
#if RESHADE_API_VERSION < 20
static void OnEndRenderPass(reshade::api::command_list* cmd_list) {
  if (cmd_list->get_device()->get_api() != reshade::api::device_api::vulkan) return;
  auto* cmd_list_data = renodx::utils::data::Get<renodx::utils::resource::upgrade::CommandListData>(cmd_list);
  if (cmd_list_data == nullptr || cmd_list_data->pending_render_pass_render_targets.empty()) return;

  // A pass can clear a texture without drawing anything. Apply that clear to its
  // clone before the shared end-of-pass callback drops the queued work.
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
      // The shared code already copies enabled clones. Do not copy them twice.
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

  // Vulkan reports these as region copies. When neither texture uses a clone,
  // the shared code leaves the copy alone. Convert it here if an upgrade changed
  // the format, so Vulkan does not receive a copy between incompatible formats.
  cmd_list->copy_texture_region(source, source_subresource, source_box, dest, dest_subresource, dest_box, filter);
  return true;
}

}  // namespace internal

// The shared code first chooses which addon handles resource events. Install
// our checks only if it chose us, and remove them before that shared code shuts
// down. Never replace another addon's callbacks.
static void UseDescriptorFilters(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    if (!renodx::utils::resource::upgrade::shared.IsEventHandler()) {
      renodx::utils::log::w("rdr2vk: another addon handles texture clones; leaving its descriptor callbacks unchanged.");
      return;
    }
    reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(renodx::utils::resource::upgrade::OnUpdateDescriptorTables);
    reshade::unregister_event<reshade::addon_event::push_descriptors>(renodx::utils::resource::upgrade::OnPushDescriptors);
    reshade::register_event<reshade::addon_event::update_descriptor_tables>(internal::OnUpdateDescriptorTables);
    reshade::register_event<reshade::addon_event::push_descriptors>(internal::OnPushDescriptors);
    internal::descriptor_filters_installed = true;
    renodx::utils::log::i("rdr2vk: descriptor updates are checked for clones only when they use a texture with cloning enabled.");
  } else if (reason == DLL_PROCESS_DETACH && internal::descriptor_filters_installed) {
    reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(internal::OnUpdateDescriptorTables);
    reshade::unregister_event<reshade::addon_event::push_descriptors>(internal::OnPushDescriptors);
    if (renodx::utils::resource::upgrade::shared.IsEventHandler()) {
      // The shared code still expects its original callbacks. Put them back so
      // it can remove them or pass control to another addon during shutdown.
      reshade::register_event<reshade::addon_event::update_descriptor_tables>(renodx::utils::resource::upgrade::OnUpdateDescriptorTables);
      reshade::register_event<reshade::addon_event::push_descriptors>(renodx::utils::resource::upgrade::OnPushDescriptors);
    }
    internal::descriptor_filters_installed = false;
  }
}

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