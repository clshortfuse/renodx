/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <windows.h>

#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <memory>
#include <memory_resource>
#include <mutex>
#include <shared_mutex>
#include <type_traits>
#include <utility>
#include <vector>

#include <embed/scene_brightness.h>
#include <include/reshade.hpp>

#include "../../mods/swapchain_v2.hpp"
#include "../../utils/data.hpp"
#include "../../utils/draw.hpp"
#include "../../utils/log.hpp"
#include "../../utils/pipeline.hpp"
#include "../../utils/render.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/windowing.hpp"
#include "./diagnostics_config.hpp"
#include "./shared.h"

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
#include "./diagnostics/recorder.hpp"
#endif

namespace rdr2vk::output {

struct RecordedDrawSummary {
  bool scene_write = false;
  bool ui_write = false;
  bool has_brightness_pass = false;
  bool invalid_recording = false;
};

struct AcceptedDraws {
  // These facts describe accepted GPU work for one acquired image, not GPU
  // completion. Recording order alone cannot establish scene/UI order.
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
  bool scene = false;
  bool ui = false;
  bool brightness = false;
  bool failed = false;

  constexpr bool ApplyRecording(const RecordedDrawSummary& recording) {
    // Only the first UI write after scene drawing can select brightness work.
    // A later scene write is unsafe: adjusting it would also change the UI.
    failed |= recording.invalid_recording || (recording.scene_write && ui);
    const bool first_scene_ui = recording.ui_write && (scene || recording.scene_write) && !ui;
    if (first_scene_ui) {
      brightness = recording.has_brightness_pass && !failed;
      failed |= !brightness;
    }
    scene |= recording.scene_write;
    ui |= recording.ui_write;
    return first_scene_ui && brightness && !failed;
  }
};

// Check every combination, including overlapping scene/UI/brightness/failure
// facts. ApplyRecording must leave the separately tracked resource usage alone.
static_assert([] {
  for (std::uint32_t previous = 0; previous < 16; ++previous) {
    for (std::uint32_t next = 0; next < 16; ++next) {
      AcceptedDraws accepted = {
          .usage = reshade::api::resource_usage::render_target,
          .scene = (previous & 1) != 0,
          .ui = (previous & 2) != 0,
          .brightness = (previous & 4) != 0,
          .failed = (previous & 8) != 0,
      };
      const RecordedDrawSummary recording = {
          .scene_write = (next & 1) != 0,
          .ui_write = (next & 2) != 0,
          .has_brightness_pass = (next & 4) != 0,
          .invalid_recording = (next & 8) != 0,
      };
      const bool boundary = !accepted.ui && recording.ui_write && (accepted.scene || recording.scene_write);
      const bool rejected = accepted.failed || recording.invalid_recording
                            || (accepted.ui && recording.scene_write)
                            || (boundary && !recording.has_brightness_pass);
      const bool expected_brightness = (boundary ? !rejected : accepted.brightness);
      const bool expected_scene = accepted.scene || recording.scene_write;
      const bool expected_ui = accepted.ui || recording.ui_write;
      if (accepted.ApplyRecording(recording) != (boundary && !rejected)
          || accepted.scene != expected_scene || accepted.ui != expected_ui
          || accepted.brightness != expected_brightness || accepted.failed != rejected
          || accepted.usage != reshade::api::resource_usage::render_target) return false;
    }
  }
  AcceptedDraws accepted;
  if (accepted.ApplyRecording({.scene_write = true})) return false;
  if (!accepted.ApplyRecording({.ui_write = true, .has_brightness_pass = true})) return false;
  if (accepted.ApplyRecording({.ui_write = true, .has_brightness_pass = true}) || accepted.failed) return false;
  accepted = {};
  return accepted.ApplyRecording({.scene_write = true, .ui_write = true, .has_brightness_pass = true})
         && !accepted.failed;
}());

// Command-list recordings own these mapped uploads. Keep this layout unchanged
// because the recording's private data retains stable pointers to its entries.
struct SettingsUpload {
  reshade::api::resource buffer = {0};
  ShaderInjectData* data = nullptr;
};

static_assert(std::is_standard_layout_v<SettingsUpload> && sizeof(SettingsUpload) == 16
              && offsetof(SettingsUpload, buffer) == 0 && offsetof(SettingsUpload, data) == 8);

inline void DestroySettingsUpload(reshade::api::device* device, SettingsUpload* upload) {
  if (upload->buffer.handle == 0) return;
  if (upload->data != nullptr) {
    device->unmap_buffer_region(upload->buffer);
  }
  device->destroy_resource(upload->buffer);
  *upload = {};
}

struct BackBufferState {
  // The fixed-size vector owns these GPU objects. Copying or replacing an entry
  // would duplicate handles or skip the cleanup that waits for the GPU.
  BackBufferState() = default;
  BackBufferState(const BackBufferState&) = delete;
  BackBufferState& operator=(const BackBufferState&) = delete;
  BackBufferState(BackBufferState&&) = default;
  BackBufferState& operator=(BackBufferState&&) = delete;

  reshade::api::resource back_buffer = {0};
  reshade::api::resource clone = {0};
  renodx::utils::draw::SwapchainProxyPass proxy;
  reshade::api::resource scene_copy = {0};
  renodx::utils::render::RenderPass scene_scale_pass;
  reshade::api::resource shader_injection = {0};
  std::uint64_t acquisition_id = 0;
  AcceptedDraws submitted;
  std::vector<reshade::api::resource> submitted_scene_resources;
  bool ordering_reported = false;
  bool scene_failed = false;
  bool failed = false;
};

struct SwapchainState {
  std::shared_mutex mutex;
  reshade::api::device* device = nullptr;
  reshade::api::command_queue* queue = nullptr;
  bool closing = false;
  std::vector<BackBufferState> back_buffers;
};

struct SwapchainEntry {
  reshade::api::swapchain* swapchain;
  std::shared_ptr<SwapchainState> state;
};

struct BackBufferReference {
  std::shared_ptr<SwapchainState> state;
  std::uint32_t index = 0;
  reshade::api::resource original = {0};
  reshade::api::resource clone = {0};
};

namespace internal {

static renodx::utils::data::ParallelFlatHashMap<
    reshade::api::swapchain*, std::shared_ptr<SwapchainState>, std::shared_mutex>
    swapchains;

}  // namespace internal

// Copy CPU owners while the registry is locked, then release it before taking
// a state lock. The device pointer is immutable after registry publication.
inline std::pmr::vector<SwapchainEntry> GetDeviceSwapchains(
    reshade::api::device* device,
    std::pmr::memory_resource* storage = std::pmr::get_default_resource()) {
  std::pmr::vector<SwapchainEntry> entries(storage);
  // Hot-path callers supply stack storage for four owners. Reserve once so
  // geometric vector growth does not consume that small arena unnecessarily.
  if (storage != std::pmr::get_default_resource()) {
    entries.reserve(4);
  }
  internal::swapchains.for_each([&](const auto& entry) {
    const auto& [swapchain, state] = entry;
    if (state->device == device) {
      entries.push_back({.swapchain = swapchain, .state = state});
    }
  });
  return entries;
}

// The native wrappers call this only after SUCCESS or SUBOPTIMAL. Acquisition
// starts a new image use but does not prove its GPU semaphore has signaled.
inline void OnAcquireBackBuffer(std::uint64_t native_swapchain, std::uint32_t index) {
  std::shared_ptr<SwapchainState> state;
  internal::swapchains.for_each([&](const auto& entry) {
    const auto& [swapchain, registered_state] = entry;
    if (swapchain->get_native() == native_swapchain) {
      state = registered_state;
    }
  });
  if (state == nullptr) return;
  const std::unique_lock lock(state->mutex);
  if (state->closing || index >= state->back_buffers.size()) return;
  auto& buffer = state->back_buffers[index];
  ++buffer.acquisition_id;
  buffer.submitted = {};
  buffer.submitted_scene_resources.clear();
  // Mapped settings stay with their command list and are reused only at reset.
}

// The caller holds the owning state's lock and supplies the known image usage.
// An upload selects pre-UI work; nullptr uses the no-UI presentation settings.
inline bool RenderSceneBrightness(
    reshade::api::command_list* cmd_list, BackBufferState* buffer,
    reshade::api::resource_usage usage, const SettingsUpload* upload = nullptr) {
  if (buffer->scene_failed) return false;
  const bool fallback = upload == nullptr;
  const auto* values = (fallback ? reinterpret_cast<const ShaderInjectData*>(buffer->proxy.shader_injection) : upload->data);
  if (values == nullptr) return false;
  if (!(values->diffuse_white_nits > 0.f) || !std::isfinite(values->diffuse_white_nits)
      || !(values->graphics_white_nits > 0.f) || !std::isfinite(values->graphics_white_nits)) {
    buffer->scene_failed = true;
    renodx::utils::log::e("rdr2vk: invalid Game/UI Brightness values; waiting for the game to recreate its output buffers.");
    return false;
  }
  if (fallback && values->diffuse_white_nits == values->graphics_white_nits) return true;
  if (usage == reshade::api::resource_usage::undefined || buffer->scene_copy.handle == 0) return false;
  if (fallback) {
    ShaderInjectData settings = *values;
    settings.scene_brightness_enabled = 1.f;
    cmd_list->barrier(buffer->shader_injection, reshade::api::resource_usage::constant_buffer, reshade::api::resource_usage::copy_dest);
    cmd_list->update_buffer_region(&settings, buffer->shader_injection, 0, sizeof(settings));
    cmd_list->barrier(buffer->shader_injection, reshade::api::resource_usage::copy_dest, reshade::api::resource_usage::constant_buffer);
  }

  // The last use left this image in copy_dest after its shader reads. Keep the
  // barrier so those reads finish before this list overwrites the image.
  cmd_list->barrier(buffer->scene_copy, reshade::api::resource_usage::copy_dest, reshade::api::resource_usage::copy_dest);
  cmd_list->barrier(buffer->clone, usage, reshade::api::resource_usage::copy_source);
  cmd_list->copy_resource(buffer->clone, buffer->scene_copy);
  cmd_list->barrier(buffer->scene_copy, reshade::api::resource_usage::copy_dest, reshade::api::resource_usage::shader_resource);
  cmd_list->barrier(buffer->clone, reshade::api::resource_usage::copy_source, reshade::api::resource_usage::render_target);
  // Scale the decoded scene by Game Brightness / UI Brightness. Final output
  // multiplies everything by UI Brightness. The shader leaves alpha unchanged.
  // Bind the shared settings layout directly, without ReShade's limited pool.
  auto& pass = buffer->scene_scale_pass;
  const reshade::api::buffer_range injection_range = {
      .buffer = (fallback ? buffer->shader_injection : upload->buffer), .offset = 0, .size = sizeof(ShaderInjectData)};
  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, pass.layout, 0,
                             {.binding = 0, .count = 1, .type = reshade::api::descriptor_type::texture_shader_resource_view, .descriptors = pass.shader_resource_slots.views.data()});
  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, pass.layout, 0,
                             {.binding = 1, .count = 1, .type = reshade::api::descriptor_type::constant_buffer, .descriptors = &injection_range});
  const bool rendered = pass.Render(cmd_list);
  cmd_list->barrier(buffer->clone, reshade::api::resource_usage::render_target, usage);
  cmd_list->barrier(buffer->scene_copy, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::copy_dest);
  if (!rendered) {
    buffer->scene_failed = true;
    renodx::utils::log::e("rdr2vk: could not draw the scene brightness pass; waiting for the game to recreate its output buffers.");
  }
  return rendered;
}

namespace internal {

static void RetireSwapchain(const std::shared_ptr<SwapchainState>& state) {
  std::vector<BackBufferState> retired_buffers;
  const reshade::api::command_queue* queue = nullptr;
  {
    const std::unique_lock lock(state->mutex);
    if (state->closing) return;
    state->closing = true;
    retired_buffers.swap(state->back_buffers);
    queue = std::exchange(state->queue, nullptr);
  }

  // Presentation uses the game's semaphores. Wait only at this existing cleanup
  // boundary, with no registry/state lock held, never during normal frames.
  if (queue != nullptr) {
    queue->wait_idle();
  }
  for (auto& buffer : retired_buffers) {
    buffer.scene_scale_pass.DestroyAll(state->device);
    if (buffer.shader_injection.handle != 0) {
      state->device->destroy_resource(buffer.shader_injection);
    }
    if (buffer.scene_copy.handle != 0) {
      state->device->destroy_resource(buffer.scene_copy);
    }
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
  // Earlier device initialization set the shaders. Do not hold the shared
  // swapchain lock while looking up texture information.
  if (swapchain_data->swap_chain_proxy_vertex_shader.empty()
      || swapchain_data->swap_chain_proxy_pixel_shader.empty()) return;

  const auto back_buffer_count = swapchain->get_back_buffer_count();
  if (back_buffer_count == 0) return;

  auto state = std::make_shared<SwapchainState>();
  state->device = device;
  state->back_buffers.resize(back_buffer_count);
  std::uint32_t width = 0;
  std::uint32_t height = 0;

  for (std::uint32_t index = 0; index < back_buffer_count; ++index) {
    auto& buffer = state->back_buffers[index];
    buffer.back_buffer = swapchain->get_back_buffer(index);
    if (buffer.back_buffer.handle == 0) return;

    bool valid_back_buffer = false;
    renodx::utils::resource::GetLiveResourceInfo(buffer.back_buffer, [&](const auto& info) {
      if (index == 0) {
        width = info.desc.texture.width;
        height = info.desc.texture.height;
      }
      valid_back_buffer = info.device == device && info.is_swap_chain
                          && info.clone_enabled && info.clone_target != nullptr
                          && info.clone_target->new_format == reshade::api::format::r16g16b16a16_float
                          && info.desc.type == reshade::api::resource_type::texture_2d
                          && info.desc.texture.depth_or_layers == 1 && info.desc.texture.samples == 1
                          && info.desc.texture.width == width && info.desc.texture.height == height;
    });
    if (!valid_back_buffer || width == 0 || height == 0) return;

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

  // Create clones before workers request them while recording. Shared resource
  // code still owns them. Check all backbuffers first, without registry/state locks.
  for (std::uint32_t index = 0; index < back_buffer_count; ++index) {
    auto& buffer = state->back_buffers[index];
    const auto clone = renodx::utils::resource::upgrade::GetResourceClone(buffer.back_buffer);
    if (clone.handle == 0) {
      renodx::utils::log::e("rdr2vk::output: could not create the HDR backbuffer clone; index=", index);
      RetireSwapchain(state);
      return;
    }
    // Bindings are immutable for this backbuffer lifetime, including its clone.
    bool valid_clone = false;
    renodx::utils::resource::GetLiveResourceInfo(clone, [&](const auto& info) {
      valid_clone = info.device == device && info.is_clone && info.fallback == buffer.back_buffer
                    && info.desc.type == reshade::api::resource_type::texture_2d
                    && info.desc.texture.format == reshade::api::format::r16g16b16a16_float
                    && info.desc.texture.width == width && info.desc.texture.height == height
                    && info.desc.texture.depth_or_layers == 1 && info.desc.texture.samples == 1;
    });
    if (!valid_clone) {
      renodx::utils::log::e("rdr2vk::output: HDR backbuffer clone has the wrong size, format, or owner; index=", index);
      RetireSwapchain(state);
      return;
    }
    buffer.clone = clone;
    const reshade::api::resource_view_desc scene_view_desc(reshade::api::format::r16g16b16a16_float);
    auto& pass = buffer.scene_scale_pass;
    // RenderPass owns these views even when a later setup step fails.
    auto& source_views = pass.shader_resource_slots.generated_views;
    auto& target_views = pass.render_target_slots.generated_views;
    source_views.resize(1);
    target_views.resize(1);
    bool created_scene_resources = device->create_resource(
        reshade::api::resource_desc(width, height, 1, 1, reshade::api::format::r16g16b16a16_float, 1,
                                    reshade::api::memory_heap::gpu_only,
                                    reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource),
        nullptr, reshade::api::resource_usage::copy_dest, &buffer.scene_copy);
    if (created_scene_resources) {
      created_scene_resources = device->create_resource_view(
          buffer.scene_copy, reshade::api::resource_usage::shader_resource, scene_view_desc, &source_views.front());
    }
    if (created_scene_resources) {
      created_scene_resources = device->create_resource_view(
          clone, reshade::api::resource_usage::render_target, scene_view_desc, &target_views.front());
    }
    if (!created_scene_resources) {
      renodx::utils::log::e("rdr2vk: could not create scene brightness resources; index=", index);
      RetireSwapchain(state);
      return;
    }
    pass.render_target_slots.views = target_views;
    pass.shader_resource_slots.views = source_views;
    pass.pipeline_subobjects.vertex_shader = swapchain_data->swap_chain_proxy_vertex_shader;
    pass.pipeline_subobjects.pixel_shader = __scene_brightness;
    pass.auto_generate_render_target_formats = false;
    pass.auto_generate_viewport = false;
    pass.viewports.resize(1);
    pass.viewports[0].width = static_cast<float>(width);
    pass.viewports[0].height = static_cast<float>(height);
    pass.viewports[0].max_depth = 1.f;
    pass.auto_generate_scissors = false;
    pass.scissors = {{.right = static_cast<std::int32_t>(width), .bottom = static_cast<std::int32_t>(height)}};
    pass.revert_state_after_render = false;
    // A disabled pass writes no pixels. LOAD keeps existing menu/UI color and alpha.
    pass.render_target_load_op = reshade::api::render_pass_load_op::load;
    if (!device->check_capability(reshade::api::device_caps::partial_push_descriptor_updates)) {
      renodx::utils::log::e("rdr2vk: Vulkan push descriptors are required for scene brightness.");
      RetireSwapchain(state);
      return;
    }
    if (!device->create_resource({sizeof(ShaderInjectData), reshade::api::memory_heap::gpu_only, reshade::api::resource_usage::constant_buffer | reshade::api::resource_usage::copy_dest}, nullptr, reshade::api::resource_usage::constant_buffer, &buffer.shader_injection)) {
      renodx::utils::log::e("rdr2vk: could not create the shared shader settings buffer.");
      RetireSwapchain(state);
      return;
    }
    const std::array ranges = {
        reshade::api::descriptor_range{.binding = 0, .count = 1, .type = reshade::api::descriptor_type::texture_shader_resource_view},
        reshade::api::descriptor_range{.binding = 1, .count = 1, .type = reshade::api::descriptor_type::constant_buffer},
    };
    reshade::api::pipeline_layout_param descriptors(static_cast<std::uint32_t>(ranges.size()), ranges.data());
    descriptors.type = reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges;
    if (!device->create_pipeline_layout(1, &descriptors, &pass.layout)) {
      renodx::utils::log::e("rdr2vk: could not create scene brightness layout.");
      RetireSwapchain(state);
      return;
    }
    pass.generated_layout = true;
    pass.pipeline = renodx::utils::pipeline::CreateRenderPipeline(device, pass.layout, pass.pipeline_subobjects);
    pass.generated_pipeline = true;
    if (pass.pipeline.handle == 0) {
      renodx::utils::log::e("rdr2vk: could not create scene brightness pipeline.");
      RetireSwapchain(state);
      return;
    }
    pass.auto_generate_descriptor_table_updates = false;
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
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  diagnostics::RecordSync({.kind = "present", .device = device->get_native(), .object = queue->get_native()});
#endif

  // Window changes can recreate the swapchain: no output lock may be held here.
  auto* swapchain_data = renodx::utils::data::Get<renodx::mods::swapchain::v2::DeviceData>(device);
  if (swapchain_data == nullptr) return;
  if (swapchain_data->fake_fullscreen_pending) {
    const auto buffer_desc = swapchain_data->primary_swapchain_resource_desc;
    auto* hwnd = static_cast<HWND>(swapchain->get_hwnd());
    if (renodx::utils::windowing::CanApplyFakeFullscreen(hwnd)) {
      const bool applied = renodx::utils::windowing::ApplyFakeFullscreen(swapchain, buffer_desc);
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
    renodx::utils::log::e("rdr2vk::output: ", reason,
                          "; backbuffer=", renodx::utils::log::AsPtr(buffer.back_buffer.handle),
                          ". Waiting for the game to recreate its output buffers.");
  };

  if (buffer.back_buffer.handle != swapchain->get_back_buffer(index).handle) {
    fail("backbuffer changed without the swapchain being recreated");
    return;
  }
  if (state->queue != nullptr && state->queue != queue) {
    fail("presentation queue changed without the swapchain being recreated");
    return;
  }

  reshade::api::resource clone = {0};
  renodx::utils::resource::GetLiveResourceInfo(buffer.back_buffer, [&](const auto& info) {
    if (info.device != device || !info.is_swap_chain || !info.clone_enabled) return;
    clone = info.clone;
  });
  // Setup already created the clone. Never create or retry it at presentation.
  if (clone.handle == 0) {
    fail("the HDR backbuffer clone created during setup is missing");
    return;
  }
  if (buffer.clone != clone) {
    fail("the HDR backbuffer clone changed after its bindings were set up");
    return;
  }

  bool valid_clone = false;
  renodx::utils::resource::GetLiveResourceInfo(clone, [&](const auto& info) {
    valid_clone = info.device == device && info.is_clone && info.fallback.handle == buffer.back_buffer.handle;
  });
  if (!valid_clone) {
    fail("the HDR backbuffer clone is missing or belongs to a different backbuffer");
    return;
  }

  if (state->queue == nullptr) {
    state->queue = queue;
  }
  if (buffer.submitted.scene && !buffer.submitted.ui && !buffer.submitted.brightness
      && !buffer.submitted.failed && !buffer.scene_failed) {
    if (RenderSceneBrightness(queue->get_immediate_command_list(), &buffer, buffer.submitted.usage)) {
      buffer.submitted.brightness = true;
    } else {
      if (!buffer.scene_failed) {
        renodx::utils::log::e("rdr2vk: cannot adjust scene brightness before output because the image state is unknown.");
      }
      buffer.scene_failed = true;
    }
  }
  const bool transition_scene = buffer.submitted.usage != reshade::api::resource_usage::undefined
                                && buffer.submitted.usage != reshade::api::resource_usage::shader_resource;
  auto* cmd_list = queue->get_immediate_command_list();
  if (transition_scene) {
    cmd_list->barrier(clone, buffer.submitted.usage, reshade::api::resource_usage::shader_resource);
  }
  const bool rendered = buffer.proxy.Render(swapchain, queue, &clone);
  if (transition_scene) {
    cmd_list->barrier(clone, reshade::api::resource_usage::shader_resource, buffer.submitted.usage);
  }
  if (!rendered) {
    // Failed setup can still record GPU commands. Retain objects until queue-safe
    // cleanup rather than destroying them here or retrying every frame.
    fail("could not draw the final HDR output");
  }
  // Image-use facts reset at successful acquisition, not at presentation.
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  // A freed handle can be reused for unrelated storage. Forget accepted sources
  // without taking a state lock under a registry lock.
  alignas(SwapchainEntry) std::array<std::byte, sizeof(SwapchainEntry) * 4> owner_bytes;
  std::pmr::monotonic_buffer_resource owner_storage(owner_bytes.data(), owner_bytes.size());
  for (const auto& [swapchain, state] : GetDeviceSwapchains(device, &owner_storage)) {
    const std::unique_lock lock(state->mutex);
    for (auto& buffer : state->back_buffers) {
      std::erase(buffer.submitted_scene_resources, resource);
    }
  }
}

static void OnDestroyCommandQueue(reshade::api::command_queue* queue) {
  for (const auto& [swapchain, state] : GetDeviceSwapchains(queue->get_device())) {
    {
      const std::shared_lock lock(state->mutex);
      if (state->closing || state->queue != queue) continue;
    }
    swapchains.erase_if(swapchain, [&](const auto& entry) {
      const auto& [chain, registered_state] = entry;
      return registered_state.get() == state.get();
    });
    RetireSwapchain(state);
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  for (const auto& [swapchain, state] : GetDeviceSwapchains(device)) {
    swapchains.erase_if(swapchain, [&](const auto& entry) {
      const auto& [chain, registered_state] = entry;
      return registered_state.get() == state.get();
    });
    const std::unique_lock lock(state->mutex);
    if (state->queue != nullptr) {
      renodx::utils::log::e("rdr2vk::output: the device was destroyed before the output queue was cleaned up.");
    }
    // Queue wrappers are already gone. GPU cleanup belongs in swapchain/queue
    // destruction, not this callback; do not call the driver here.
    state->closing = true;
    state->queue = nullptr;
    state->back_buffers.clear();
  }
}

}  // namespace internal

inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    // Keep shared swapchain/clone setup and replace only the stock v2 present.
    reshade::unregister_event<reshade::addon_event::present>(renodx::mods::swapchain::v2::OnPresent);
    reshade::register_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
    reshade::register_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
    reshade::register_event<reshade::addon_event::destroy_command_queue>(internal::OnDestroyCommandQueue);
    reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
    reshade::register_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
    reshade::register_event<reshade::addon_event::present>(internal::OnPresent);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);
    reshade::unregister_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
    reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
    reshade::unregister_event<reshade::addon_event::destroy_command_queue>(internal::OnDestroyCommandQueue);
    reshade::unregister_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
    reshade::unregister_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
  }
}

}  // namespace rdr2vk::output