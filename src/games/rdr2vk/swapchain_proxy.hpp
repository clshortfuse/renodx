/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <windows.h>

#include <cstdint>
#include <memory>
#include <mutex>
#include <shared_mutex>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "../../mods/swapchain_v2.hpp"
#include "../../utils/data.hpp"
#include "../../utils/draw.hpp"
#include "../../utils/log.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/windowing.hpp"

namespace rdr2vk::swapchain_proxy {
namespace internal {

struct BackBufferState {
  // The fixed-size vector owns these GPU-bearing entries; copying or replacing
  // an entry would duplicate handles or bypass retirement.
  BackBufferState() = default;
  BackBufferState(const BackBufferState&) = delete;
  BackBufferState& operator=(const BackBufferState&) = delete;
  BackBufferState(BackBufferState&&) = default;
  BackBufferState& operator=(BackBufferState&&) = delete;

  reshade::api::resource back_buffer = {0};
  reshade::api::resource clone = {0};
  renodx::utils::draw::SwapchainProxyPass proxy;
  bool failed = false;
};

struct SwapchainState {
  std::shared_mutex mutex;
  reshade::api::device* device = nullptr;
  reshade::api::command_queue* queue = nullptr;
  bool closing = false;
  std::uint32_t width = 0;
  std::uint32_t height = 0;
  std::vector<BackBufferState> back_buffers;
};

struct SwapchainEntry {
  reshade::api::swapchain* swapchain;
  std::shared_ptr<SwapchainState> state;
};

static renodx::utils::data::ParallelFlatHashMap<
    reshade::api::swapchain*, std::shared_ptr<SwapchainState>, std::shared_mutex>
    swapchains;

static void RetireSwapchain(const std::shared_ptr<SwapchainState>& state) {
  std::vector<BackBufferState> retired_buffers;
  reshade::api::command_queue* queue = nullptr;
  {
    const std::unique_lock lock(state->mutex);
    if (state->closing) return;
    state->closing = true;
    retired_buffers.swap(state->back_buffers);
    queue = std::exchange(state->queue, nullptr);
  }

  // Present submits with application semaphores. Only drain at a lifetime boundary,
  // never from the normal present/failure path, and never while holding registry locks.
  if (queue != nullptr) {
    queue->wait_idle();
  }
  for (auto& buffer : retired_buffers) {
    buffer.proxy.Destroy(state->device);
  }
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, [[maybe_unused]] bool resize) {
  std::shared_ptr<SwapchainState> state;
  swapchains.erase_if(swapchain, [&](const auto& entry) {
    const auto& [chain, registered_state] = entry;
    state = registered_state;
    return true;
  });
  if (state != nullptr) {
    RetireSwapchain(state);
  }
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, [[maybe_unused]] bool resize) {
  // Vulkan can reuse the swapchain object and still report resize=false.
  OnDestroySwapchain(swapchain, false);
  auto* device = swapchain->get_device();
  if (device->get_api() != reshade::api::device_api::vulkan) return;

  const auto* swapchain_data = renodx::utils::data::Get<renodx::mods::swapchain::v2::DeviceData>(device);
  if (swapchain_data == nullptr) return;

  // Shader/configuration fields are set once by the earlier device-init callback.
  // Do not hold the core swapchain mutex while querying the resource registry.
  if (swapchain_data->swap_chain_proxy_vertex_shader.empty()
      || swapchain_data->swap_chain_proxy_pixel_shader.empty()) return;

  const auto back_buffer_count = swapchain->get_back_buffer_count();
  if (back_buffer_count == 0) return;

  auto state = std::make_shared<SwapchainState>();
  state->device = device;
  state->back_buffers.resize(back_buffer_count);

  for (std::uint32_t index = 0; index < back_buffer_count; ++index) {
    auto& buffer = state->back_buffers[index];
    buffer.back_buffer = swapchain->get_back_buffer(index);
    if (buffer.back_buffer.handle == 0) return;

    bool valid_back_buffer = false;
    renodx::utils::resource::GetLiveResourceInfo(buffer.back_buffer, [&](const auto& info) {
      if (index == 0) {
        state->width = info.desc.texture.width;
        state->height = info.desc.texture.height;
      }
      valid_back_buffer = info.device == device && info.is_swap_chain
                          && info.clone_enabled && info.clone_target != nullptr
                          && info.clone_target->new_format == reshade::api::format::r16g16b16a16_float
                          && info.desc.type == reshade::api::resource_type::texture_2d
                          && info.desc.texture.depth_or_layers == 1 && info.desc.texture.samples == 1
                          && info.desc.texture.width == state->width && info.desc.texture.height == state->height;
    });
    if (!valid_back_buffer || state->width == 0 || state->height == 0) return;

    buffer.proxy = {
        .vertex_shader = swapchain_data->swap_chain_proxy_vertex_shader,
        .pixel_shader = swapchain_data->swap_chain_proxy_pixel_shader,
        .expected_constant_buffer_index = swapchain_data->expected_constant_buffer_index,
        .expected_constant_buffer_space = swapchain_data->expected_constant_buffer_space,
        .revert_state = swapchain_data->swapchain_proxy_revert_state,
        .use_compatibility_mode = false,
        .proxy_format = reshade::api::format::r16g16b16a16_float,
        .shader_injection = renodx::mods::swapchain::v2::shader_injection,
        .shader_injection_size = renodx::mods::swapchain::v2::shader_injection_size,
    };
  }

  // Create all clones before rendering workers can request them from a render-pass
  // callback. The shared registry still owns them and retires them with each backbuffer.
  // Do this after validating every backbuffer and without holding registry/state locks.
  for (std::uint32_t index = 0; index < back_buffer_count; ++index) {
    const auto& buffer = state->back_buffers[index];
    const auto clone = renodx::utils::resource::upgrade::GetResourceClone(buffer.back_buffer);
    if (clone.handle == 0) {
      renodx::utils::log::e("rdr2vk::swapchain_proxy: backbuffer clone initialization failed; index=", index);
      return;
    }
  }
  swapchains.try_emplace(swapchain, std::move(state));
}

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    [[maybe_unused]] const reshade::api::rect* source_rect,
    [[maybe_unused]] const reshade::api::rect* dest_rect,
    [[maybe_unused]] std::uint32_t dirty_rect_count,
    [[maybe_unused]] const reshade::api::rect* dirty_rects) {
  if (queue == nullptr || swapchain == nullptr) return;
  auto* device = swapchain->get_device();
  if (device->get_api() != reshade::api::device_api::vulkan
      || queue->get_device() != device || queue->get_immediate_command_list() == nullptr) return;

  // Preserve the stock deferred fullscreen handling, outside our lifetime locks.
  auto* swapchain_data = renodx::utils::data::Get<renodx::mods::swapchain::v2::DeviceData>(device);
  if (swapchain_data == nullptr) return;
  if (swapchain_data->fake_fullscreen_pending) {
    const auto buffer_desc = swapchain_data->primary_swapchain_resource_desc;
    auto* hwnd = static_cast<HWND>(swapchain->get_hwnd());
    if (renodx::utils::windowing::CanApplyFakeFullscreen(hwnd)) {
      const bool applied = renodx::utils::windowing::ApplyFakeFullscreen(swapchain, buffer_desc);
      // Applying the window change can recreate the swapchain and its device data.
      swapchain_data = renodx::utils::data::Get<renodx::mods::swapchain::v2::DeviceData>(device);
      if (swapchain_data == nullptr) return;
      if (applied) {
        swapchain_data->fake_fullscreen_pending = false;
      }
    }
  }

  std::shared_ptr<SwapchainState> state;
  swapchains.if_contains(swapchain, [&](const auto& entry) {
    const auto& [chain, registered_state] = entry;
    state = registered_state;
  });
  if (state == nullptr) return;

  const std::unique_lock lock(state->mutex);
  if (state->closing) return;
  const auto index = swapchain->get_current_back_buffer_index();
  if (index >= state->back_buffers.size()) return;
  auto& buffer = state->back_buffers[index];
  if (buffer.failed) return;

  const auto fail = [&](const char* reason) {
    buffer.failed = true;
    renodx::utils::log::e("rdr2vk::swapchain_proxy: ", reason,
                          "; backbuffer=", renodx::utils::log::AsPtr(buffer.back_buffer.handle),
                          ". Waiting for swapchain recreation.");
  };

  if (buffer.back_buffer.handle != swapchain->get_back_buffer(index).handle) {
    fail("backbuffer changed without a new swapchain lifetime");
    return;
  }
  if (state->queue != nullptr && state->queue != queue) {
    fail("presentation queue changed within a swapchain lifetime");
    return;
  }

  reshade::api::resource clone = {0};
  renodx::utils::resource::GetLiveResourceInfo(buffer.back_buffer, [&](const auto& info) {
    if (info.device != device || !info.is_swap_chain || !info.clone_enabled) return;
    clone = info.clone;
  });
  // Initialization pre-creates the clone. Never allocate or retry it from present.
  if (clone.handle == 0) {
    fail("pre-created float clone is unavailable");
    return;
  }
  if (buffer.clone.handle != 0 && buffer.clone.handle != clone.handle) {
    fail("float clone changed after descriptor initialization");
    return;
  }

  bool valid_clone = false;
  renodx::utils::resource::GetLiveResourceInfo(clone, [&](const auto& info) {
    valid_clone = info.device == device && info.is_clone && info.fallback.handle == buffer.back_buffer.handle;
    // Images cannot change shape/format in place. After accepting this identity,
    // only check that it remains live; recreation establishes a fresh entry.
    if (buffer.clone.handle == 0) {
      valid_clone = valid_clone
                    && info.desc.type == reshade::api::resource_type::texture_2d
                    && info.desc.texture.format == reshade::api::format::r16g16b16a16_float
                    && info.desc.texture.width == state->width && info.desc.texture.height == state->height
                    && info.desc.texture.depth_or_layers == 1 && info.desc.texture.samples == 1;
    }
  });
  if (!valid_clone) {
    fail("float clone is unavailable or incompatible");
    return;
  }

  if (state->queue == nullptr) {
    state->queue = queue;
  }
  if (buffer.clone.handle == 0) {
    buffer.clone = clone;
  }
  if (!buffer.proxy.Render(swapchain, queue, &clone)) {
    // Even partial initialization may have recorded commands. Keep everything alive
    // until the owning queue is drained during retirement, rather than retry per frame.
    fail("proxy rendering failed");
  }
}

static void OnDestroyCommandQueue(reshade::api::command_queue* queue) {
  auto* device = queue->get_device();
  std::vector<SwapchainEntry> candidates;
  // Snapshot ownership only. Never wait on a state mutex under a registry lock.
  swapchains.for_each([&](const auto& entry) {
    const auto& [swapchain, state] = entry;
    if (state->device == device) {
      candidates.push_back({.swapchain = swapchain, .state = state});
    }
  });
  for (const auto& candidate : candidates) {
    const auto& state = candidate.state;
    {
      const std::shared_lock lock(state->mutex);
      if (state->closing || state->queue != queue) continue;
    }
    swapchains.erase_if(candidate.swapchain, [&](const auto& entry) {
      const auto& [chain, registered_state] = entry;
      return registered_state.get() == state.get();
    });
    RetireSwapchain(state);
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  std::vector<SwapchainEntry> retired;
  swapchains.for_each([&](const auto& entry) {
    const auto& [swapchain, state] = entry;
    if (state->device == device) {
      retired.push_back({.swapchain = swapchain, .state = state});
    }
  });
  for (const auto& retired_entry : retired) {
    const auto& state = retired_entry.state;
    swapchains.erase_if(retired_entry.swapchain, [&](const auto& entry) {
      const auto& [chain, registered_state] = entry;
      return registered_state.get() == state.get();
    });
    const std::unique_lock lock(state->mutex);
    if (state->queue != nullptr) {
      renodx::utils::log::e("rdr2vk::swapchain_proxy: device destroyed before proxy queue retirement.");
    }
    // Vulkan queue wrappers are already gone. Normal GPU cleanup happened in
    // destroy_swapchain/destroy_command_queue; do not issue late driver work here.
    state->closing = true;
    state->queue = nullptr;
    state->back_buffers.clear();
  }
}

}  // namespace internal

static void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    // Keep core swapchain/clone setup, replacing only this addon's proxy owner.
    reshade::unregister_event<reshade::addon_event::present>(renodx::mods::swapchain::v2::OnPresent);
    reshade::register_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
    reshade::register_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
    reshade::register_event<reshade::addon_event::destroy_command_queue>(internal::OnDestroyCommandQueue);
    reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
    reshade::register_event<reshade::addon_event::present>(internal::OnPresent);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);
    reshade::unregister_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
    reshade::unregister_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
    reshade::unregister_event<reshade::addon_event::destroy_command_queue>(internal::OnDestroyCommandQueue);
    reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
  }
}

}  // namespace rdr2vk::swapchain_proxy