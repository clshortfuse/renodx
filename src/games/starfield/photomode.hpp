/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <bit>
#include <cstdint>
#include <sstream>
#include <span>

#include <d3d12.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../utils/format.hpp"
#include "../../utils/render.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/state.hpp"

#include "./shared.h"

namespace custom::passes::photomode {

namespace internal {

struct __declspec(uuid("9e29fb27-86ef-4c34-8d97-9e6fe5b16461")) DeviceData {
  renodx::utils::render::RenderPass readback_blit_pass;
};

static bool attached = false;
static ShaderInjectData* shader_injection = nullptr;
static std::atomic_bool readback_blit_logged = false;
static std::atomic_bool readback_non_direct_logged = false;
static std::atomic_bool readback_unsupported_usage_logged = false;

static void ResetReadbackBlitPass(reshade::api::device* device, renodx::utils::render::RenderPass* pass) {
  if (pass == nullptr) return;
  pass->DestroyAll(device);
  pass->render_target_slots.views.clear();
  pass->render_target_slots.resources.clear();
  pass->render_target_slots.resource_descs.clear();
  pass->render_target_slots.view_descs.clear();
  pass->render_target_slots.render_pass_descs.clear();
  pass->shader_resource_slots.views.clear();
  pass->shader_resource_slots.resources.clear();
  pass->shader_resource_slots.resource_descs.clear();
  pass->shader_resource_slots.view_descs.clear();
  pass->push_constants.clear();
  pass->descriptor_table_updates.clear();
  pass->viewports.clear();
  pass->scissors.clear();
  pass->auto_generate_descriptor_table_updates = true;
  pass->auto_generate_render_target_formats = true;
}

static bool BlitReadbackCloneToSource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource destination,
    reshade::api::resource clone,
    const reshade::api::resource_desc& source_desc,
    const reshade::api::resource_desc& clone_desc) {
  auto* device = cmd_list->get_device();
  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr || clone.handle == 0u || shader_injection == nullptr) return false;

  const auto native_command_list_type = std::bit_cast<ID3D12CommandList*>(static_cast<uintptr_t>(cmd_list->get_native()))->GetType();
  if (native_command_list_type != D3D12_COMMAND_LIST_TYPE_DIRECT) {
    if (!readback_non_direct_logged.exchange(true, std::memory_order_relaxed)) {
      std::stringstream s;
      s << "[Starfield] Skipped readback blit on non-direct D3D12 command list";
      s << ", cmd_list=" << PRINT_PTR(reinterpret_cast<uintptr_t>(cmd_list));
      s << ", cmd_list_native=" << PRINT_PTR(cmd_list->get_native());
      s << ", command_list_type=" << static_cast<uint32_t>(native_command_list_type);
      s << ", destination=" << PRINT_PTR(destination.handle);
      s << ", clone=" << PRINT_PTR(clone.handle);
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
    return false;
  }

  const auto source_usage_flags = static_cast<uint32_t>(source_desc.usage);
  const auto clone_usage_flags = static_cast<uint32_t>(clone_desc.usage);
  if ((source_usage_flags & static_cast<uint32_t>(reshade::api::resource_usage::render_target)) == 0u
      || (clone_usage_flags & static_cast<uint32_t>(reshade::api::resource_usage::shader_resource)) == 0u) {
    if (!readback_unsupported_usage_logged.exchange(true, std::memory_order_relaxed)) {
      std::stringstream s;
      s << "[Starfield] Skipped readback blit because resources do not support required usages";
      s << ", source=" << PRINT_PTR(destination.handle);
      s << ", source_usage=0x" << std::hex << source_usage_flags << std::dec;
      s << ", clone=" << PRINT_PTR(clone.handle);
      s << ", clone_usage=0x" << std::hex << clone_usage_flags << std::dec;
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
    return false;
  }

  const auto target_format = reshade::api::format_to_default_typed(source_desc.texture.format, 0);
  const auto clone_format = reshade::api::format_to_default_typed(clone_desc.texture.format, 0);

  auto& pass = data->readback_blit_pass;
  const bool resources_changed = pass.render_target_slots.resources.size() != 1u
                                 || pass.render_target_slots.resources[0].handle != destination.handle
                                 || pass.shader_resource_slots.resources.size() != 1u
                                 || pass.shader_resource_slots.resources[0].handle != clone.handle;
  const bool formats_changed = pass.render_target_slots.view_descs.size() != 1u
                               || pass.render_target_slots.view_descs[0].format != target_format
                               || pass.shader_resource_slots.view_descs.size() != 1u
                               || pass.shader_resource_slots.view_descs[0].format != clone_format;
  if (resources_changed || formats_changed) {
    ResetReadbackBlitPass(device, &pass);
    pass.render_target_slots.resources = {destination};
    pass.render_target_slots.view_descs = {
        reshade::api::resource_view_desc(reshade::api::resource_view_type::texture_2d, target_format, 0u, 1u, 0u, 1u)};
    pass.shader_resource_slots.resources = {clone};
    pass.shader_resource_slots.view_descs = {
        reshade::api::resource_view_desc(reshade::api::resource_view_type::texture_2d, clone_format, 0u, 1u, 0u, 1u)};
  }

  pass.pipeline_subobjects.vertex_shader = __screenshot_blit_vertex_shader;
  pass.pipeline_subobjects.pixel_shader = __screenshot_blit_pixel_shader;
  pass.pipeline_subobjects.compute_shader = {};
  pass.push_constants[renodx::utils::render::ConstantBuffersSlots{13u, 50u}] = std::span<const float>(
      reinterpret_cast<const float*>(shader_injection),
      sizeof(*shader_injection) / sizeof(float));
  pass.revert_state_after_render = true;

  const reshade::api::resource render_resources[2] = {clone, destination};
  const reshade::api::resource_usage before_render_states[2] = {reshade::api::resource_usage::render_target, reshade::api::resource_usage::copy_source};
  const reshade::api::resource_usage during_render_states[2] = {reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::render_target};
  cmd_list->barrier(2u, render_resources, before_render_states, during_render_states);

  const bool rendered = pass.Render(cmd_list);
  if (!rendered) {
#ifdef DEBUG_LEVEL_0
    reshade::log::message(reshade::log::level::warning, "[Starfield] Readback SDR RenderPass failed");
#endif
  }
  cmd_list->barrier(2u, render_resources, during_render_states, before_render_states);
  return rendered;
}

static bool OnReadbackCopyTextureToBuffer(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint64_t dest_offset,
    uint32_t row_length,
    uint32_t slice_height) {
  if (cmd_list == nullptr || source.handle == 0u) return false;

  auto* device = cmd_list->get_device();
  if (device == nullptr || device->get_api() != reshade::api::device_api::d3d12) return false;

  const auto source_desc = device->get_resource_desc(source);
  if (source_desc.type != reshade::api::resource_type::texture_2d) return false;

  bool source_is_tracked_clone = false;
  bool source_has_clone = false;
  bool source_clone_enabled = false;
  float source_resource_tag = -1.f;
  reshade::api::resource_desc tracked_desc = source_desc;
  reshade::api::resource_desc clone_desc = {};
  reshade::api::resource source_clone = {0u};
  renodx::utils::resource::GetResourceInfo(source, [&](const renodx::utils::resource::ResourceInfo& info) {
    if (info.destroyed) return;
    source_is_tracked_clone = info.is_clone;
    source_has_clone = info.clone.handle != 0u;
    source_clone_enabled = info.clone_enabled;
    source_resource_tag = info.resource_tag;
    tracked_desc = info.desc;
    clone_desc = info.clone_desc;
    source_clone = info.clone;
  });

  (void)source_box;

  const bool tagged_render_readback = !source_is_tracked_clone
                                      && source_resource_tag == CUSTOM_RESOURCE_TAG_RENDER
                                      && source_clone_enabled
                                      && source_has_clone
                                      && source_clone.handle != 0u
                                      && source_subresource == 0u
                                      && tracked_desc.texture.format == reshade::api::format::r8g8b8a8_typeless;
  if (!tagged_render_readback) return false;

  if (!BlitReadbackCloneToSource(cmd_list, source, source_clone, source_desc, clone_desc)) return false;

  if (!readback_blit_logged.exchange(true, std::memory_order_relaxed)) {
    std::stringstream s;
    s << "[Starfield] Blitted HDR clone into tagged render readback source for copy_texture_to_buffer";
    s << ", cmd_list=" << PRINT_PTR(reinterpret_cast<uintptr_t>(cmd_list));
    s << ", cmd_list_native=" << PRINT_PTR(cmd_list->get_native());
    s << ", command_list_type=" << static_cast<uint32_t>(std::bit_cast<ID3D12CommandList*>(static_cast<uintptr_t>(cmd_list->get_native()))->GetType());
    s << ", source=" << PRINT_PTR(source.handle);
    s << ", source_format=" << source_desc.texture.format;
    s << ", source_usage=0x" << std::hex << static_cast<uint32_t>(source_desc.usage) << std::dec;
    s << ", source_size=" << source_desc.texture.width << "x" << source_desc.texture.height;
    s << ", dest=" << PRINT_PTR(dest.handle);
    s << ", dest_offset=" << dest_offset;
    s << ", row_length=" << row_length;
    s << ", slice_height=" << slice_height;
    s << ", resource_tag=" << source_resource_tag;
    s << ", tracked_format=" << tracked_desc.texture.format;
    s << ", clone=" << PRINT_PTR(source_clone.handle);
    s << ", clone_format=" << clone_desc.texture.format;
    s << ", clone_usage=0x" << std::hex << static_cast<uint32_t>(clone_desc.usage) << std::dec;
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  return false;
}

static void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::d3d12 && device->get_private_data<DeviceData>() == nullptr) {
    device->create_private_data<DeviceData>();
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  auto* data = device->get_private_data<DeviceData>();
  if (data != nullptr) {
    ResetReadbackBlitPass(device, &data->readback_blit_pass);
  }
  device->destroy_private_data<DeviceData>();
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr) return;

  auto& pass = data->readback_blit_pass;
  const bool uses_resource = (!pass.render_target_slots.resources.empty()
                              && pass.render_target_slots.resources[0].handle == resource.handle)
                             || (!pass.shader_resource_slots.resources.empty()
                                 && pass.shader_resource_slots.resources[0].handle == resource.handle);
  if (uses_resource) ResetReadbackBlitPass(device, &pass);
}

}  // namespace internal

static void Use(DWORD fdw_reason, ShaderInjectData* new_shader_injection) {
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::state::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      internal::shader_injection = new_shader_injection;
      if (internal::attached) return;
      internal::attached = true;
      reshade::log::message(reshade::log::level::info, "passes::photomode attached.");
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::register_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
      reshade::register_event<reshade::addon_event::copy_texture_to_buffer>(internal::OnReadbackCopyTextureToBuffer);
      break;

    case DLL_PROCESS_DETACH:
      if (!internal::attached) return;
      internal::attached = false;
      reshade::unregister_event<reshade::addon_event::copy_texture_to_buffer>(internal::OnReadbackCopyTextureToBuffer);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      internal::shader_injection = nullptr;
      internal::readback_blit_logged.store(false, std::memory_order_relaxed);
      internal::readback_non_direct_logged.store(false, std::memory_order_relaxed);
      internal::readback_unsupported_usage_logged.store(false, std::memory_order_relaxed);
      break;
  }
}

}  // namespace custom::passes::photomode
