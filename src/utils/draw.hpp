/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <include/reshade.hpp>

#include <d3d11.h>
#include <d3d12.h>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <memory>
#include <mutex>
#include <shared_mutex>
#include <span>
#include <utility>

#include "./mutex.hpp"
#include "./render.hpp"
#include "./resource.hpp"
#include "./resource_upgrade.hpp"

namespace renodx::utils::draw {

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

  void Destroy(reshade::api::device* device) {
    pass.DestroyAll(device);
  }

  bool Render(
      reshade::api::swapchain* swapchain,
      reshade::api::command_queue* queue,
      const reshade::api::resource* swapchain_clone_override = nullptr) {
    auto* cmd_list = queue->get_immediate_command_list();
    auto current_back_buffer = swapchain->get_current_back_buffer();
    auto* device = swapchain->get_device();

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::draw::SwapchainProxyPass::Render(";
      s << "bb=" << PRINT_PTR(current_back_buffer.handle);
      s << ", queue=" << PRINT_PTR(reinterpret_cast<uintptr_t>(queue));
      s << ", cmd_list=" << PRINT_PTR(reinterpret_cast<uintptr_t>(cmd_list));
      s << ", device=" << PRINT_PTR(reinterpret_cast<uintptr_t>(device));
      s << ", proxy_format=" << proxy_format;
      s << ", compat=" << (use_compatibility_mode ? "true" : "false");
      s << ", vs=" << vertex_shader.size();
      s << ", ps=" << pixel_shader.size();
      s << ", injection=" << shader_injection_size;
      s << ", expected_cb=" << expected_constant_buffer_index;
      s << ", expected_space=" << expected_constant_buffer_space;
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
#endif

    reshade::api::resource existing_clone = {0u};
    const auto found_resource_info = utils::resource::GetResourceInfo(current_back_buffer, [&](const utils::resource::ResourceInfo& info) {
      existing_clone = info.clone;
    });
    if (!found_resource_info) {
      std::stringstream s;
      s << "utils::draw::SwapchainProxyPass::Render(failed: no resource_info";
      s << ", bb=" << PRINT_PTR(current_back_buffer.handle);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      return false;
    }

    utils::resource::GetResourceInfo(current_back_buffer, [&](const utils::resource::ResourceInfo& info) {
#ifdef DEBUG_LEVEL_2
      {
        std::stringstream s;
        s << "utils::draw::SwapchainProxyPass::Render(resource clone_enabled=" << (info.clone_enabled ? "true" : "false");
        s << ", clone_target=" << PRINT_PTR(reinterpret_cast<uintptr_t>(info.clone_target));
        if (info.clone_target != nullptr) {
          s << ", clone_target_format=" << info.clone_target->new_format;
        }
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
      {
        std::stringstream s;
        s << "utils::draw::SwapchainProxyPass::Render(resource handles";
        s << " bb=" << PRINT_PTR(current_back_buffer.handle);
        s << " res=" << PRINT_PTR(info.resource.handle);
        s << " clone=" << PRINT_PTR(info.clone.handle);
        s << " proxy_res=" << PRINT_PTR(info.proxy_resource.handle);
        s << " proxy_clone_srv=" << PRINT_PTR(info.swap_chain_proxy_clone_srv.handle);
        s << " proxy_rtv=" << PRINT_PTR(info.swap_chain_proxy_rtv.handle);
        s << " is_swap_chain=" << (info.is_swap_chain ? "true" : "false");
        s << " upgraded=" << (info.upgraded ? "true" : "false");
        const auto desc_format = (info.desc.type == reshade::api::resource_type::buffer)
                                     ? reshade::api::format::unknown
                                     : info.desc.texture.format;
        const auto clone_desc_format = (info.clone_desc.type == reshade::api::resource_type::buffer)
                                           ? reshade::api::format::unknown
                                           : info.clone_desc.texture.format;
        s << " fmt=" << desc_format;
        s << " clone_fmt=" << clone_desc_format;
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
#else
      (void)info;
#endif
    });

    reshade::api::resource swapchain_clone;

    if (swapchain_clone_override != nullptr && swapchain_clone_override->handle != 0u) {
      swapchain_clone = *swapchain_clone_override;
    } else if (use_compatibility_mode) {
      swapchain_clone = renodx::utils::resource::upgrade::GetResourceClone(current_back_buffer);
      if (swapchain_clone.handle == 0u) {
        std::stringstream s;
        s << "utils::draw::SwapchainProxyPass::Render(failed: no clone after CloneResource";
        s << ", bb=" << PRINT_PTR(current_back_buffer.handle);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        return false;
      }

#ifdef DEBUG_LEVEL_2
      {
        std::stringstream s;
        s << "utils::draw::SwapchainProxyPass::Render(copy_resource begin";
        s << " bb=" << PRINT_PTR(current_back_buffer.handle);
        s << " clone=" << PRINT_PTR(swapchain_clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
#endif
      cmd_list->copy_resource(current_back_buffer, swapchain_clone);
#ifdef DEBUG_LEVEL_2
      reshade::log::message(reshade::log::level::info, "utils::draw::SwapchainProxyPass::Render(copy_resource end)");
#endif
    } else {
      if (existing_clone.handle == 0u) {
        std::stringstream s;
        s << "utils::draw::SwapchainProxyPass::Render(failed: no clone, compat=false";
        s << ", bb=" << PRINT_PTR(current_back_buffer.handle);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        return false;
      }
      swapchain_clone = existing_clone;
    }

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::draw::SwapchainProxyPass::Render(clone=" << PRINT_PTR(swapchain_clone.handle) << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
#endif

    auto& pass = this->pass;
    const bool render_target_changed =
        pass.render_target_slots.resources.size() != 1
        || pass.render_target_slots.resources[0].handle != current_back_buffer.handle;
    if (render_target_changed) {
      pass.render_target_slots.views.clear();
      pass.render_target_slots.view_descs.clear();
      pass.render_target_slots.resources = {current_back_buffer};
      pass.render_target_slots.resource_descs.clear();
    }

    const bool shader_resource_changed =
        pass.shader_resource_slots.resources.size() != 1
        || pass.shader_resource_slots.resources[0].handle != swapchain_clone.handle;
    if (shader_resource_changed) {
      pass.shader_resource_slots.views.clear();
      pass.shader_resource_slots.view_descs.clear();
      pass.shader_resource_slots.resources = {swapchain_clone};
      pass.shader_resource_slots.resource_descs.clear();
    }
#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::draw::SwapchainProxyPass::Render(bind resources";
      s << " rt=" << PRINT_PTR(pass.render_target_slots.resources[0].handle);
      s << " srv=" << PRINT_PTR(pass.shader_resource_slots.resources[0].handle);
      s << " proxy_format=" << proxy_format;
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
#endif
    pass.revert_state_after_render = revert_state;
    pass.pipeline_subobjects.vertex_shader = vertex_shader;
    pass.pipeline_subobjects.pixel_shader = pixel_shader;
    pass.pipeline_subobjects.compute_shader = {};

    if (pass.sampler_descs.empty()) {
      pass.sampler_descs.push_back(reshade::api::sampler_desc{});
    }
    pass.push_constants.clear();

    if (shader_injection_size != 0u) {
      const bool is_modern_api = device->get_api() == reshade::api::device_api::d3d12
                                 || device->get_api() == reshade::api::device_api::vulkan;
      uint8_t register_index;
      if (expected_constant_buffer_index == -1) {
        register_index = is_modern_api ? 0 : 13;
      } else {
        register_index = static_cast<uint8_t>(expected_constant_buffer_index);
      }
      uint8_t register_space = is_modern_api
                                   ? static_cast<uint8_t>(expected_constant_buffer_space)
                                   : 0;
      const renodx::utils::render::ConstantBuffersSlots slot = {
          .slot = register_index,
          .space = register_space,
      };
      pass.push_constants[slot] = std::span<const float>(shader_injection, shader_injection_size);
    }

    if (auto_device_flush && device->get_api() != reshade::api::device_api::d3d12) {
      pass.flush_after_render = true;
    }

    if (!pass.Render(cmd_list, queue)) {
#ifdef DEBUG_LEVEL_2
      reshade::log::message(reshade::log::level::warning, "utils::draw::SwapchainProxyPass::Render(RenderPass::Render failed)");
#endif
      return false;
    }

    return true;
  }
};

}  // namespace renodx::utils::draw
