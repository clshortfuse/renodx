/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <cstdint>
#include <include/reshade.hpp>

#include "../../../mods/shader.hpp"
#include "../../../utils/data.hpp"

namespace custom::passes::output {

static reshade::api::resource_view GetOutputUAV(reshade::api::command_list* cmd_list);

static renodx::mods::shader::CustomShader CreateCustomShader(
  uint32_t crc32,
  std::span<const uint8_t> code) {
  return {
    .crc32 = crc32,
    .code = code,
    .views = {{
      .type = reshade::api::descriptor_type::texture_unordered_access_view,
      .slot = 0u,
      .space = 50u,
      .get_view = &GetOutputUAV,
    }},
  };
}

namespace internal {

struct __declspec(uuid("00d5aac8-68f8-4713-b220-a1b30d0ba79d")) DeviceData {
  reshade::api::resource texture = {0u};
  reshade::api::resource_view srv = {0u};
  reshade::api::resource_view uav = {0u};
  uint32_t width = 0u;
  uint32_t height = 0u;
  reshade::api::resource_usage state = reshade::api::resource_usage::unordered_access;
};

static bool attached = false;

static void DestroyTexture(reshade::api::device* device, DeviceData* data) {
  if (device == nullptr || data == nullptr) return;

  if (data->uav.handle != 0u) {
    device->destroy_resource_view(data->uav);
    data->uav = {0u};
  }
  if (data->srv.handle != 0u) {
    device->destroy_resource_view(data->srv);
    data->srv = {0u};
  }
  if (data->texture.handle != 0u) {
    device->destroy_resource(data->texture);
    data->texture = {0u};
  }

  data->width = 0u;
  data->height = 0u;
  data->state = reshade::api::resource_usage::unordered_access;
}

static bool EnsureTexture(
    reshade::api::device* device,
    DeviceData* data,
    uint32_t width,
    uint32_t height) {
  if (device == nullptr || data == nullptr || width == 0u || height == 0u) return false;
  if (data->texture.handle != 0u && data->width == width && data->height == height) return true;

  DestroyTexture(device, data);

  reshade::api::resource_desc desc = {};
  desc.type = reshade::api::resource_type::texture_2d;
  desc.texture = {
      .width=width,
      .height=height,
      .depth_or_layers=1u,
      .levels=1u,
      .format=reshade::api::format::r16g16b16a16_float,
      .samples=1u,
  };
  desc.heap = reshade::api::memory_heap::gpu_only;
  desc.usage = reshade::api::resource_usage::shader_resource
               | reshade::api::resource_usage::unordered_access;
  desc.flags = reshade::api::resource_flags::none;

  if (!device->create_resource(
          desc,
          nullptr,
          reshade::api::resource_usage::unordered_access,
          &data->texture)) {
    reshade::log::message(reshade::log::level::error, "spacemarine2::output(texture creation failed)");
    return false;
  }

  const reshade::api::resource_view_desc view_desc(
      reshade::api::resource_view_type::texture_2d,
      reshade::api::format::r16g16b16a16_float,
      0u,
      1u,
      0u,
      1u);
  if (!device->create_resource_view(
          data->texture,
          reshade::api::resource_usage::shader_resource,
          view_desc,
          &data->srv)
      || !device->create_resource_view(
          data->texture,
          reshade::api::resource_usage::unordered_access,
          view_desc,
          &data->uav)) {
    reshade::log::message(reshade::log::level::error, "spacemarine2::output(texture view creation failed)");
    DestroyTexture(device, data);
    return false;
  }

  data->width = width;
  data->height = height;
  data->state = reshade::api::resource_usage::unordered_access;
  return true;
}

static void OnInitDevice(reshade::api::device* device) {
  renodx::utils::data::Create<DeviceData>(device);
}

static void OnDestroyDevice(reshade::api::device* device) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data != nullptr) {
    DestroyTexture(device, data);
  }
  device->destroy_private_data<DeviceData>();
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain != nullptr ? swapchain->get_device() : nullptr;
  auto* data = device != nullptr ? renodx::utils::data::Get<DeviceData>(device) : nullptr;
  if (data == nullptr || swapchain->get_back_buffer_count() == 0u) return;

  const auto desc = device->get_resource_desc(swapchain->get_back_buffer(0u));
  if (desc.type != reshade::api::resource_type::texture_2d) return;
  EnsureTexture(device, data, desc.texture.width, desc.texture.height);
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain != nullptr ? swapchain->get_device() : nullptr;
  auto* data = device != nullptr ? renodx::utils::data::Get<DeviceData>(device) : nullptr;
  if (data != nullptr) {
    DestroyTexture(device, data);
  }
}

}  // namespace internal

static reshade::api::resource_view GetOutputUAV(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  auto* data = device != nullptr ? renodx::utils::data::Get<internal::DeviceData>(device) : nullptr;
  if (data == nullptr || data->texture.handle == 0u || data->uav.handle == 0u) {
    assert(false && "spacemarine2::output::GetOutputUAV missing output texture");
    return {0u};
  }

  if (data->state != reshade::api::resource_usage::unordered_access) {
    cmd_list->barrier(data->texture, data->state, reshade::api::resource_usage::unordered_access);
    data->state = reshade::api::resource_usage::unordered_access;
  } else {
    cmd_list->barrier(
        data->texture,
        reshade::api::resource_usage::unordered_access,
        reshade::api::resource_usage::unordered_access);
  }
  return data->uav;
}

static bool GetOutputForProxy(
    reshade::api::command_list* cmd_list,
    reshade::api::resource* resource,
    reshade::api::resource_view* srv) {
  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  auto* data = device != nullptr ? renodx::utils::data::Get<internal::DeviceData>(device) : nullptr;
  if (data == nullptr || data->texture.handle == 0u || data->srv.handle == 0u) return false;

  if (data->state != reshade::api::resource_usage::shader_resource) {
    cmd_list->barrier(data->texture, data->state, reshade::api::resource_usage::shader_resource);
    data->state = reshade::api::resource_usage::shader_resource;
  }
  *resource = data->texture;
  *srv = data->srv;
  return true;
}

static void RestoreOutputUAVState(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  auto* data = device != nullptr ? renodx::utils::data::Get<internal::DeviceData>(device) : nullptr;
  if (data == nullptr || data->texture.handle == 0u) return;
  if (data->state == reshade::api::resource_usage::unordered_access) return;

  cmd_list->barrier(data->texture, data->state, reshade::api::resource_usage::unordered_access);
  data->state = reshade::api::resource_usage::unordered_access;
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      break;

    case DLL_PROCESS_DETACH:
      if (!internal::attached) return;
      internal::attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      break;
  }
}

}  // namespace custom::passes::output