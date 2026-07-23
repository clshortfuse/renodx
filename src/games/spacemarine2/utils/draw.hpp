/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <cstddef>
#include <cstdint>
#include <include/reshade.hpp>
#include <memory>
#include <span>
#include <unordered_map>
#include <vector>

#include "../../../mods/swapchain_v2.hpp"
#include "../../../utils/data.hpp"
#include "../../../utils/render.hpp"
#include "../../../utils/resource.hpp"
#include "../../../utils/resource_upgrade.hpp"

namespace custom::draw {

static void LogFailure(const char* message) {
  reshade::log::message(reshade::log::level::error, message);
}

using PrepareShaderResource = bool (*)(
    reshade::api::command_list*,
    reshade::api::resource*,
    reshade::api::resource_view*);
using RestoreShaderResource = void (*)(reshade::api::command_list*);

struct AdditionalShaderResource {
  PrepareShaderResource prepare = nullptr;
  RestoreShaderResource restore = nullptr;
};

static std::vector<AdditionalShaderResource> additional_shader_resources;
static bool use_original_swapchain_as_shader_resource = false;

static void AddShaderResource(
    PrepareShaderResource prepare,
    RestoreShaderResource restore = nullptr) {
  additional_shader_resources.push_back({.prepare = prepare, .restore = restore});
}

struct SwapchainProxyPass {
  renodx::utils::render::RenderPass pass;
  std::span<const std::uint8_t> vertex_shader;
  std::span<const std::uint8_t> pixel_shader;
  int32_t expected_constant_buffer_index = -1;
  uint32_t expected_constant_buffer_space = 0;
  bool revert_state = false;
  bool use_compatibility_mode = false;
  reshade::api::format proxy_format = reshade::api::format::unknown;
  const float* shader_injection = nullptr;
  size_t shader_injection_size = 0;
  bool auto_device_flush = true;
  reshade::api::resource swapchain_scratch = {0u};
  reshade::api::resource_view swapchain_scratch_srv = {0u};

  void Destroy(reshade::api::device* device) {
    pass.DestroyAll(device);
    if (swapchain_scratch_srv.handle != 0u) {
      device->destroy_resource_view(swapchain_scratch_srv);
      swapchain_scratch_srv = {0u};
    }
    if (swapchain_scratch.handle != 0u) {
      device->destroy_resource(swapchain_scratch);
      swapchain_scratch = {0u};
    }
  }

  bool EnsureSwapchainScratch(
      reshade::api::device* device,
      reshade::api::resource current_back_buffer) {
    if (swapchain_scratch.handle != 0u && swapchain_scratch_srv.handle != 0u) return true;

    const auto back_buffer_desc = device->get_resource_desc(current_back_buffer);
    if (back_buffer_desc.type != reshade::api::resource_type::texture_2d) {
      LogFailure("spacemarine2::draw::EnsureSwapchainScratch failed: backbuffer is not texture_2d");
      return false;
    }

    auto scratch_desc = back_buffer_desc;
    scratch_desc.texture.format = reshade::api::format_to_typeless(back_buffer_desc.texture.format);
    scratch_desc.heap = reshade::api::memory_heap::gpu_only;
    scratch_desc.usage = reshade::api::resource_usage::copy_dest
                         | reshade::api::resource_usage::shader_resource;
    scratch_desc.flags = reshade::api::resource_flags::none;
    if (!device->create_resource(
            scratch_desc,
            nullptr,
            reshade::api::resource_usage::shader_resource,
            &swapchain_scratch)) {
          LogFailure("spacemarine2::draw::EnsureSwapchainScratch failed: create_resource");
      return false;
    }

    const reshade::api::resource_view_desc srv_desc(
        reshade::api::resource_view_type::texture_2d,
        reshade::api::format_to_default_typed(back_buffer_desc.texture.format),
        0u,
        1u,
        0u,
        1u);
    if (!device->create_resource_view(
            swapchain_scratch,
            reshade::api::resource_usage::shader_resource,
            srv_desc,
            &swapchain_scratch_srv)) {
          LogFailure("spacemarine2::draw::EnsureSwapchainScratch failed: create_resource_view");
      device->destroy_resource(swapchain_scratch);
      swapchain_scratch = {0u};
      return false;
    }
    return true;
  }

  bool Render(
      reshade::api::swapchain* swapchain,
      reshade::api::command_queue* queue,
      const reshade::api::resource* swapchain_clone_override = nullptr) {
    auto* cmd_list = queue->get_immediate_command_list();
    const auto current_back_buffer = swapchain->get_current_back_buffer();
    auto* device = swapchain->get_device();
    if (cmd_list == nullptr || current_back_buffer.handle == 0u || device == nullptr) {
      LogFailure("spacemarine2::draw::Render failed: missing command list, backbuffer, or device");
      return false;
    }

    reshade::api::resource existing_clone = {0u};
    bool destroyed = false;
    const auto found_resource_info = renodx::utils::resource::GetResourceInfo(
        current_back_buffer,
        [&](const renodx::utils::resource::ResourceInfo& info) {
          existing_clone = info.clone;
          destroyed = info.destroyed;
        });
    if (!found_resource_info) {
      LogFailure("spacemarine2::draw::Render failed: no backbuffer ResourceInfo");
      return false;
    }
    if (destroyed) {
      LogFailure("spacemarine2::draw::Render failed: backbuffer ResourceInfo is destroyed");
      return false;
    }

    reshade::api::resource swapchain_clone = {0u};
    if (swapchain_clone_override != nullptr && swapchain_clone_override->handle != 0u) {
      swapchain_clone = *swapchain_clone_override;
    } else if (use_compatibility_mode) {
      swapchain_clone = existing_clone.handle != 0u
                            ? existing_clone
                            : renodx::utils::resource::upgrade::CloneResource(current_back_buffer);
      if (swapchain_clone.handle == 0u) {
        LogFailure("spacemarine2::draw::Render failed: compatibility clone unavailable");
        return false;
      }
      cmd_list->copy_resource(current_back_buffer, swapchain_clone);
    } else {
      if (existing_clone.handle == 0u) {
        LogFailure("spacemarine2::draw::Render failed: swapchain clone unavailable");
        return false;
      }
      swapchain_clone = existing_clone;
    }

    std::vector<reshade::api::resource> shader_resources = {swapchain_clone};
    std::vector<reshade::api::resource_view> shader_resource_views = {{0u}};
    if (use_original_swapchain_as_shader_resource) {
      if (!EnsureSwapchainScratch(device, current_back_buffer)) {
        LogFailure("spacemarine2::draw::Render failed: scratch unavailable");
        return false;
      }

      cmd_list->barrier(
          current_back_buffer,
          reshade::api::resource_usage::render_target,
          reshade::api::resource_usage::copy_source);
      cmd_list->barrier(
          swapchain_scratch,
          reshade::api::resource_usage::shader_resource,
          reshade::api::resource_usage::copy_dest);
      cmd_list->copy_resource(current_back_buffer, swapchain_scratch);
      cmd_list->barrier(
          current_back_buffer,
          reshade::api::resource_usage::copy_source,
          reshade::api::resource_usage::render_target);
      cmd_list->barrier(
          swapchain_scratch,
          reshade::api::resource_usage::copy_dest,
          reshade::api::resource_usage::shader_resource);

      shader_resources.push_back(swapchain_scratch);
      shader_resource_views.push_back(swapchain_scratch_srv);
    }

    std::vector<RestoreShaderResource> restore_callbacks;
    for (const auto& additional_resource : additional_shader_resources) {
      if (additional_resource.prepare == nullptr) continue;

      reshade::api::resource resource = {0u};
      reshade::api::resource_view view = {0u};
      if (!additional_resource.prepare(cmd_list, &resource, &view)) {
        LogFailure("spacemarine2::draw::Render failed: additional SRV preparation");
        for (const auto restore : restore_callbacks) restore(cmd_list);
        return false;
      }
      if (resource.handle == 0u || view.handle == 0u) {
        LogFailure("spacemarine2::draw::Render failed: additional SRV returned a null handle");
        for (const auto restore : restore_callbacks) restore(cmd_list);
        return false;
      }
      shader_resources.push_back(resource);
      shader_resource_views.push_back(view);
      if (additional_resource.restore != nullptr) {
        restore_callbacks.push_back(additional_resource.restore);
      }
    }

    auto& render_pass = pass;
    const bool render_target_changed =
        render_pass.render_target_slots.resources.size() != 1u
        || render_pass.render_target_slots.resources[0].handle != current_back_buffer.handle;
    if (render_target_changed) {
      render_pass.render_target_slots.views.clear();
      render_pass.render_target_slots.view_descs.clear();
      render_pass.render_target_slots.resources = {current_back_buffer};
      render_pass.render_target_slots.resource_descs.clear();
    }

    bool shader_resources_changed =
        render_pass.shader_resource_slots.resources.size() != shader_resources.size()
        || render_pass.shader_resource_slots.views.size() != shader_resource_views.size();
    for (size_t i = 0u; !shader_resources_changed && i < shader_resources.size(); ++i) {
      shader_resources_changed =
          render_pass.shader_resource_slots.resources[i].handle != shader_resources[i].handle
          || render_pass.shader_resource_slots.views[i].handle != shader_resource_views[i].handle;
    }
    if (shader_resources_changed) {
      renodx::utils::render::RenderPass::DestroyGeneratedViews(
          device,
          &render_pass.shader_resource_slots.generated_views);
      render_pass.shader_resource_slots.views.clear();
      render_pass.shader_resource_slots.view_descs.clear();
      render_pass.shader_resource_slots.resources = shader_resources;
      render_pass.shader_resource_slots.resource_descs.clear();

      if (shader_resource_views[0].handle == 0u) {
        const auto swapchain_resource_desc = device->get_resource_desc(swapchain_clone);
        shader_resource_views[0] = render_pass.shader_resource_slots.GenerateResourceView(
            cmd_list,
            swapchain_clone,
            swapchain_resource_desc);
        if (shader_resource_views[0].handle == 0u) {
          LogFailure("spacemarine2::draw::Render failed: swapchain clone SRV creation");
          for (const auto restore : restore_callbacks) restore(cmd_list);
          return false;
        }
      }
      render_pass.shader_resource_slots.views = shader_resource_views;
    }

    render_pass.revert_state_after_render = revert_state;
    render_pass.pipeline_subobjects.vertex_shader = vertex_shader;
    render_pass.pipeline_subobjects.pixel_shader = pixel_shader;
    render_pass.pipeline_subobjects.compute_shader = {};

    if (render_pass.sampler_descs.empty()) {
      render_pass.sampler_descs.emplace_back();
    }
    render_pass.push_constants.clear();

    if (shader_injection_size != 0u) {
      const bool is_modern_api = device->get_api() == reshade::api::device_api::d3d12
                                 || device->get_api() == reshade::api::device_api::vulkan;
      uint8_t register_index = static_cast<uint8_t>(expected_constant_buffer_index);
      if (expected_constant_buffer_index == -1) {
        register_index = is_modern_api ? 0u : 13u;
      }
      const auto register_space = static_cast<uint8_t>(
          is_modern_api ? expected_constant_buffer_space : 0u);
      const renodx::utils::render::ConstantBuffersSlots slot = {
          .slot = register_index,
          .space = register_space,
      };
      render_pass.push_constants[slot] = std::span<const float>(shader_injection, shader_injection_size);
    }

    if (auto_device_flush && device->get_api() != reshade::api::device_api::d3d12) {
      render_pass.flush_after_render = true;
    }

    const bool rendered = render_pass.Render(cmd_list, queue);
    for (const auto restore : restore_callbacks) restore(cmd_list);
    if (!rendered) LogFailure("spacemarine2::draw::Render failed: RenderPass::Render");
    return rendered;
  }
};

namespace internal {

struct __declspec(uuid("a7912745-74a9-4a76-894a-95bd859c1607")) DeviceData {
  std::unordered_map<uint64_t, std::unique_ptr<SwapchainProxyPass>> passes;
};

static bool attached = false;

static void DestroyPasses(reshade::api::device* device, DeviceData* data) {
  if (device == nullptr || data == nullptr) return;
  for (auto& [handle, pass] : data->passes) {
    if (pass != nullptr) pass->Destroy(device);
  }
  data->passes.clear();
}

static void OnInitDevice(reshade::api::device* device) {
  renodx::utils::data::Create<DeviceData>(device);
}

static void OnDestroyDevice(reshade::api::device* device) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data != nullptr) DestroyPasses(device, data);
  device->destroy_private_data<DeviceData>();
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain != nullptr ? swapchain->get_device() : nullptr;
  auto* data = device != nullptr ? renodx::utils::data::Get<DeviceData>(device) : nullptr;
  if (data != nullptr) DestroyPasses(device, data);
}

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  if (renodx::utils::device_proxy::UseProxyRequested()) return;

  auto* device = swapchain != nullptr ? swapchain->get_device() : nullptr;
  auto* data = device != nullptr ? renodx::utils::data::Get<DeviceData>(device) : nullptr;
  auto* swapchain_data = device != nullptr
                             ? renodx::utils::data::Get<renodx::mods::swapchain::v2::DeviceData>(device)
                             : nullptr;
  if (data == nullptr || swapchain_data == nullptr) {
    LogFailure("spacemarine2::draw::OnPresent failed: missing draw or swapchain device data");
    return;
  }

  const auto back_buffer_handle = swapchain->get_current_back_buffer().handle;
  auto& proxy_pass = data->passes[back_buffer_handle];
  if (proxy_pass == nullptr) {
    proxy_pass = std::make_unique<SwapchainProxyPass>(SwapchainProxyPass{
        .vertex_shader = swapchain_data->swap_chain_proxy_vertex_shader,
        .pixel_shader = swapchain_data->swap_chain_proxy_pixel_shader,
        .expected_constant_buffer_index = swapchain_data->expected_constant_buffer_index,
        .expected_constant_buffer_space = swapchain_data->expected_constant_buffer_space,
        .revert_state = swapchain_data->swapchain_proxy_revert_state,
        .use_compatibility_mode = renodx::mods::swapchain::v2::UsingSwapchainCompatibilityMode(),
        .proxy_format = renodx::mods::swapchain::v2::swap_chain_proxy_format,
        .shader_injection = renodx::mods::swapchain::v2::shader_injection,
        .shader_injection_size = renodx::mods::swapchain::v2::shader_injection_size,
    });
  }

  if (!proxy_pass->Render(swapchain, queue)) {
    proxy_pass->Destroy(device);
    data->passes.erase(back_buffer_handle);
  }
}

}  // namespace internal

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      reshade::unregister_event<reshade::addon_event::present>(renodx::mods::swapchain::v2::OnPresent);
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::present>(internal::OnPresent);
      break;

    case DLL_PROCESS_DETACH:
      if (!internal::attached) return;
      internal::attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);
      break;
  }
}

}  // namespace custom::draw