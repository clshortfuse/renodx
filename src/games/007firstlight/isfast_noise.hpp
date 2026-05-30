/*
 * Copyright (C) 2026 Musa Haji
 * Copyright (C) 2026 Lazorr
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <cstdint>
#include <mutex>
#include <span>
#include <vector>

#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "assets/noise/fast_noise_rg8.h"

namespace firstlight::isfast {

namespace detail {

inline reshade::api::resource fast_noise_resource = {0};
inline reshade::api::resource_view fast_noise_srv = {0};
inline std::atomic<bool> fast_noise_created{false};
inline reshade::api::device* fast_noise_owner_device = nullptr;
inline reshade::api::device* pending_device = nullptr;

inline constexpr uint32_t NOISE_WIDTH = 128u;
inline constexpr uint32_t NOISE_HEIGHT = 128u;
inline constexpr uint32_t NOISE_SLICES = 32u;
inline constexpr uint32_t NOISE_TEXEL_COUNT = NOISE_WIDTH * NOISE_HEIGHT * NOISE_SLICES;
inline constexpr uint32_t NOISE_BYTES_PER_ELEMENT = static_cast<uint32_t>(sizeof(float) * 2u);
inline constexpr uint64_t NOISE_BUFFER_BYTES = static_cast<uint64_t>(NOISE_TEXEL_COUNT) * NOISE_BYTES_PER_ELEMENT;

inline void CreateNoiseBuffer(reshade::api::device* device) {
  if (fast_noise_created.load()) return;

  static_assert(sizeof(__fast_noise_rg8_base) == NOISE_WIDTH * NOISE_HEIGHT * 2u * NOISE_SLICES,
                "Embedded IS-FAST noise data size mismatch");

  std::vector<float> decoded(NOISE_TEXEL_COUNT * 2u);
  for (uint32_t i = 0u; i < NOISE_TEXEL_COUNT; ++i) {
    decoded[i * 2u + 0u] = static_cast<float>(__fast_noise_rg8_base[i * 2u + 0u]) / 255.0f;
    decoded[i * 2u + 1u] = static_cast<float>(__fast_noise_rg8_base[i * 2u + 1u]) / 255.0f;
  }

  reshade::api::subresource_data initial_data = {};
  initial_data.data = decoded.data();
  initial_data.row_pitch = static_cast<uint32_t>(NOISE_BUFFER_BYTES);
  initial_data.slice_pitch = static_cast<uint32_t>(NOISE_BUFFER_BYTES);

  reshade::api::resource_desc buffer_desc(
      NOISE_BUFFER_BYTES,
      reshade::api::memory_heap::gpu_only,
      reshade::api::resource_usage::shader_resource);

  if (!device->create_resource(buffer_desc, &initial_data,
                               reshade::api::resource_usage::shader_resource, &fast_noise_resource)) {
    reshade::log::message(reshade::log::level::error,
                          "007firstlight: Failed to create IS-FAST noise buffer resource");
    return;
  }

  reshade::api::resource_view_desc srv_desc(
      reshade::api::format::r32_typeless,
      0u,
      static_cast<uint64_t>(NOISE_BUFFER_BYTES / sizeof(uint32_t)));

  if (!device->create_resource_view(fast_noise_resource,
                                    reshade::api::resource_usage::shader_resource, srv_desc, &fast_noise_srv)) {
    reshade::log::message(reshade::log::level::error,
                          "007firstlight: Failed to create SRV for IS-FAST noise buffer");
    device->destroy_resource(fast_noise_resource);
    fast_noise_resource = {0};
    return;
  }

  fast_noise_created.store(true);
  fast_noise_owner_device = device;
  reshade::log::message(reshade::log::level::info,
                        "007firstlight: IS-FAST noise buffer created for deferred shadow filtering");
}

inline void DestroyNoiseBuffer(reshade::api::device* device) {
  if (!fast_noise_created.load()) return;
  if (fast_noise_srv.handle != 0u) {
    device->destroy_resource_view(fast_noise_srv);
    fast_noise_srv = {0};
  }
  if (fast_noise_resource.handle != 0u) {
    device->destroy_resource(fast_noise_resource);
    fast_noise_resource = {0};
  }
  fast_noise_created.store(false);
  fast_noise_owner_device = nullptr;
}

inline reshade::api::resource_view GetNoiseShaderResourceView(reshade::api::command_list* cmd_list) {
  if (!fast_noise_created.load()) {
    static std::mutex creation_mutex;
    std::lock_guard lock(creation_mutex);
    if (!fast_noise_created.load()) {
      reshade::api::device* device = cmd_list != nullptr ? cmd_list->get_device() : pending_device;
      if (device != nullptr) {
        pending_device = device;
        CreateNoiseBuffer(device);
      }
    }
  }
  return fast_noise_srv;
}

}  // namespace detail

inline void AddShader(renodx::mods::shader::CustomShaders& custom_shaders, uint32_t crc32, std::span<const uint8_t> code) {
  custom_shaders[crc32] = {
      .crc32 = crc32,
      .code = code,
      .views = {
          {
              .type = reshade::api::descriptor_type::buffer_shader_resource_view,
              .slot = 0,
              .space = 50u,
              .get_view = &detail::GetNoiseShaderResourceView,
          },
      },
  };
}

inline void AddShaders(renodx::mods::shader::CustomShaders& custom_shaders) {
  AddShader(custom_shaders, 0x91447257, __0x91447257);
  AddShader(custom_shaders, 0xABDB27F9, __0xABDB27F9);
  AddShader(custom_shaders, 0x1D61DE2A, __0x1D61DE2A);
  AddShader(custom_shaders, 0x5BF99A8E, __0x5BF99A8E);
  AddShader(custom_shaders, 0x9A4B52C5, __0x9A4B52C5);
  AddShader(custom_shaders, 0x3C2C790A, __0x3C2C790A);
  AddShader(custom_shaders, 0xC02773BA, __0xC02773BA);
  AddShader(custom_shaders, 0x7ACD617D, __0x7ACD617D);
  AddShader(custom_shaders, 0x6BE10C9B, __0x6BE10C9B);
  AddShader(custom_shaders, 0x025B6584, __0x025B6584);
  AddShader(custom_shaders, 0x33EEFA91, __0x33EEFA91);
}

inline void OnInitDevice(reshade::api::device* device) {
  detail::pending_device = device;
}

inline void OnDestroyDevice(reshade::api::device* device) {
  if (detail::fast_noise_created.load() && device == detail::fast_noise_owner_device) {
    detail::DestroyNoiseBuffer(device);
  }
  if (device == detail::pending_device) {
    detail::pending_device = nullptr;
  }
}

}  // namespace firstlight::isfast