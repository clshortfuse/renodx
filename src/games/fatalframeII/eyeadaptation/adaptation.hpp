/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <cstdint>
#include <include/reshade.hpp>

#include "../../../utils/data.hpp"
#include "../../../utils/render.hpp"
#include "../../../utils/resource.hpp"
#include "../../../utils/shader.hpp"
#include "../../../utils/state.hpp"

namespace custom::passes::adaptation {

struct Config {
  uint32_t histogram_bins = 256u;
  uint32_t transport_buffer_dword_count = 0u;
};

namespace internal {

struct __declspec(uuid("f6950994-3f22-4ea3-a66a-9e0ac0dc7f11")) DeviceData {
  Config config{};
  renodx::utils::render::UnorderedAccessSlots descriptor_slots;
  reshade::api::resource transport_buffer = {0u};
  reshade::api::resource histogram_buffer = {0u};
};

static bool attached = false;
static Config current_config = {};

static void ResetDescriptorSlots(reshade::api::device* device, DeviceData* device_data) {
  if (device == nullptr || device_data == nullptr) return;

  renodx::utils::render::RenderPass::DestroyGeneratedViews(device, &device_data->descriptor_slots.generated_views);
  device_data->descriptor_slots.views.clear();
  device_data->descriptor_slots.view_descs.clear();
  device_data->descriptor_slots.resource_descs.clear();
  device_data->descriptor_slots.resources.clear();

  if (device_data->transport_buffer.handle != 0u) {
    device_data->descriptor_slots.resources.push_back(device_data->transport_buffer);
    device_data->descriptor_slots.view_descs.emplace_back(
        reshade::api::resource_view_type::texture_1d,
        reshade::api::format::r32_uint,
        0,
        1,
        0,
        1);
  }
  if (device_data->histogram_buffer.handle != 0u) {
    device_data->descriptor_slots.resources.push_back(device_data->histogram_buffer);
    device_data->descriptor_slots.view_descs.emplace_back(
        reshade::api::resource_view_type::texture_1d,
        reshade::api::format::r32_uint,
        0,
        1,
        0,
        1);
  }
}

static void DestroyTrackedResources(reshade::api::device* device, DeviceData* device_data) {
  if (device == nullptr || device_data == nullptr) return;

  ResetDescriptorSlots(device, device_data);
  if (device_data->histogram_buffer.handle != 0u) {
    device->destroy_resource(device_data->histogram_buffer);
    device_data->histogram_buffer = {0u};
  }
  if (device_data->transport_buffer.handle != 0u) {
    device->destroy_resource(device_data->transport_buffer);
    device_data->transport_buffer = {0u};
  }
}

static bool EnsureTransportResource(reshade::api::device* device, DeviceData* device_data) {
  if (device == nullptr || device_data == nullptr) return false;
  if (device_data->config.transport_buffer_dword_count == 0u) return true;
  if (device->get_api() != reshade::api::device_api::d3d12) return false;
  if (device_data->transport_buffer.handle != 0u) return true;

  const reshade::api::resource_desc desc(
      reshade::api::resource_type::texture_1d,
      device_data->config.transport_buffer_dword_count,
      1,
      1,
      1,
      reshade::api::format::r32_uint,
      1,
      reshade::api::memory_heap::gpu_only,
      reshade::api::resource_usage::unordered_access);

  if (!device->create_resource(
          desc,
          nullptr,
          reshade::api::resource_usage::unordered_access,
          &device_data->transport_buffer)) {
    reshade::log::message(reshade::log::level::error, "passes::adaptation(transport buffer creation failed)");
    return false;
  }

  ResetDescriptorSlots(device, device_data);
  return true;
}

static bool EnsureHistogramResource(reshade::api::device* device, DeviceData* device_data) {
  if (device == nullptr || device_data == nullptr) return false;
  if (device_data->config.histogram_bins == 0u) return true;
  if (device->get_api() != reshade::api::device_api::d3d12) return false;
  if (device_data->histogram_buffer.handle != 0u) return true;

  const reshade::api::resource_desc desc(
      reshade::api::resource_type::texture_1d,
      device_data->config.histogram_bins,
      1,
      1,
      1,
      reshade::api::format::r32_uint,
      1,
      reshade::api::memory_heap::gpu_only,
      reshade::api::resource_usage::unordered_access);

  if (!device->create_resource(
          desc,
          nullptr,
          reshade::api::resource_usage::unordered_access,
          &device_data->histogram_buffer)) {
    reshade::log::message(reshade::log::level::error, "passes::adaptation(histogram buffer creation failed)");
    return false;
  }

  ResetDescriptorSlots(device, device_data);
  return true;
}

static bool EnsureResources(reshade::api::device* device, DeviceData* device_data) {
  return EnsureTransportResource(device, device_data)
         && EnsureHistogramResource(device, device_data);
}

static void OnInitDevice(reshade::api::device* device) {
  auto* device_data = renodx::utils::data::Create<DeviceData>(device);
  device_data->config = current_config;
}

static void OnDestroyDevice(reshade::api::device* device) {
  auto* device_data = renodx::utils::data::Get<DeviceData>(device);
  if (device_data != nullptr) {
    DestroyTrackedResources(device, device_data);
  }
  device->destroy_private_data<DeviceData>();
}

}  // namespace internal

static reshade::api::resource_view GetDescriptorView(
    reshade::api::command_list* cmd_list,
    uint32_t descriptor_index) {
  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  if (cmd_list == nullptr || device == nullptr) {
    assert(false && "passes::adaptation::GetDescriptorView requires a valid command list and device");
    return {0u};
  }
  if (device->get_api() != reshade::api::device_api::d3d12) {
    assert(false && "passes::adaptation::GetDescriptorView only supports D3D12");
    return {0u};
  }

  auto* device_data = renodx::utils::data::Get<internal::DeviceData>(device);
  if (device_data == nullptr) {
    assert(false && "passes::adaptation::GetDescriptorView missing DeviceData");
    return {0u};
  }
  if (!internal::EnsureResources(device, device_data)) {
    assert(false && "passes::adaptation::GetDescriptorView failed to ensure resources");
    return {0u};
  }
  if (!device_data->descriptor_slots.Populate(cmd_list)) {
    assert(false && "passes::adaptation::GetDescriptorView failed to populate descriptor views");
    return {0u};
  }
  if (descriptor_index >= device_data->descriptor_slots.views.size()
      || descriptor_index >= device_data->descriptor_slots.resources.size()) {
    assert(false && "passes::adaptation::GetDescriptorView descriptor index out of range");
    return {0u};
  }

  const auto& resource = device_data->descriptor_slots.resources[descriptor_index];
  const auto& view = device_data->descriptor_slots.views[descriptor_index];
  if (resource.handle != 0u) {
    cmd_list->barrier(
        resource,
        reshade::api::resource_usage::unordered_access,
        reshade::api::resource_usage::unordered_access);
  }

  return view;
}

static reshade::api::resource_view GetTransportView(reshade::api::command_list* cmd_list) {
  return GetDescriptorView(cmd_list, 0u);
}

static reshade::api::resource_view GetHistogramView(reshade::api::command_list* cmd_list) {
  return GetDescriptorView(cmd_list, 1u);
}

static bool ClearHistogram(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  if (cmd_list == nullptr || device == nullptr) return false;

  auto* device_data = renodx::utils::data::Get<internal::DeviceData>(device);
  if (device_data == nullptr) return false;
  if (!internal::EnsureResources(device, device_data)) return false;
  if (device_data->histogram_buffer.handle == 0u) return false;

  const auto view = GetHistogramView(cmd_list);
  if (view.handle == 0u) return false;

  constexpr uint32_t clear_values[4] = {0u, 0u, 0u, 0u};
  cmd_list->barrier(
      device_data->histogram_buffer,
      reshade::api::resource_usage::unordered_access,
      reshade::api::resource_usage::unordered_access);
  cmd_list->clear_unordered_access_view_uint(view, clear_values, 0u, nullptr);
  cmd_list->barrier(
      device_data->histogram_buffer,
      reshade::api::resource_usage::unordered_access,
      reshade::api::resource_usage::unordered_access);
  return true;
}

static void Use(DWORD fdw_reason, const Config& config = {}) {
  renodx::utils::shader::Use(fdw_reason);
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::state::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      internal::current_config = config;
      if (internal::attached) return;
      internal::attached = true;
      reshade::log::message(reshade::log::level::info, "passes::adaptation attached.");
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      break;

    case DLL_PROCESS_DETACH:
      internal::current_config = {};
      if (!internal::attached) return;
      internal::attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      break;
  }
}

}  // namespace custom::passes::adaptation
