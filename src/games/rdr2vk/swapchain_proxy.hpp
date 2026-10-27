/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <windows.h>

#include <algorithm>
#include <array>
#include <bit>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <deque>
#include <iterator>
#include <memory>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <system_error>
#include <utility>
#include <vector>

#include <embed/scene_brightness.h>
#include <include/reshade.hpp>

#include "../../mods/swapchain_v2.hpp"
#include "../../utils/command_action.hpp"
#include "../../utils/data.hpp"
#include "../../utils/descriptor.hpp"
#include "../../utils/detour.hpp"
#include "../../utils/draw.hpp"
#include "../../utils/log.hpp"
#include "../../utils/pipeline.hpp"
#include "../../utils/render.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/state.hpp"
#include "../../utils/windowing.hpp"
#include "./shared.h"

namespace rdr2vk::swapchain_proxy {
namespace internal {

// Both blits copy their input unchanged. They also serve menus, so we only
// count them as scene output when their input came from a known scene shader.
static constexpr std::uint32_t SCENE_BLIT_SHADER = 0x1FC46AC9u;
static constexpr std::uint32_t SCENE_BLIT_MSAA_SHADER = 0xF60E4A26u;
static constexpr std::uint32_t SCENE_FXAA_SHADER = 0x599298B6u;
static constexpr std::uint32_t SCENE_TAA_SHARPEN_SHADER = 0xEF9E7CFCu;

// Declare only the Vulkan types needed to watch acquisition and submission.
// This keeps the addon from requiring Vulkan SDK headers in the build setup.
using VkDevice = struct VkDevice_T*;
using VkQueue = struct VkQueue_T*;
using VkCommandBuffer = struct VkCommandBuffer_T*;
using VkSwapchainKHR = struct VkSwapchainKHR_T*;
using VkSemaphore = struct VkSemaphore_T*;
using VkFence = struct VkFence_T*;
using VkResult = std::int32_t;
// Submit structures are opaque here: the hooks forward the original arrays.
struct VkSubmitInfo;
struct VkSubmitInfo2;
struct VkCommandBufferBeginInfo {
  std::uint32_t type;
  const void* next;
  std::uint32_t flags;
  const void* inheritance;
};
struct VkAcquireNextImageInfoKHR {
  std::uint32_t type;
  const void* next;
  VkSwapchainKHR swapchain;
  std::uint64_t timeout;
  VkSemaphore semaphore;
  VkFence fence;
  std::uint32_t device_mask;
};
using PFN_vkVoidFunction = void(WINAPI*)();
using PFN_vkGetDeviceProcAddr = PFN_vkVoidFunction(WINAPI*)(VkDevice, const char*);
using PFN_vkAcquireNextImageKHR = VkResult(WINAPI*)(VkDevice, VkSwapchainKHR, std::uint64_t, VkSemaphore, VkFence, std::uint32_t*);
using PFN_vkAcquireNextImage2KHR = VkResult(WINAPI*)(VkDevice, const VkAcquireNextImageInfoKHR*, std::uint32_t*);
using PFN_vkBeginCommandBuffer = VkResult(WINAPI*)(VkCommandBuffer, const VkCommandBufferBeginInfo*);
using PFN_vkQueueSubmit = VkResult(WINAPI*)(VkQueue, std::uint32_t, const VkSubmitInfo*, VkFence);
using PFN_vkQueueSubmit2 = VkResult(WINAPI*)(VkQueue, std::uint32_t, const VkSubmitInfo2*, VkFence);
static constexpr VkResult VK_SUCCESS = 0;
static constexpr VkResult VK_SUBOPTIMAL_KHR = 1000001003;
static constexpr std::uint32_t VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT = 2;
static constexpr std::uint32_t VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT = 4;
static_assert(sizeof(void*) == 8 && sizeof(VkCommandBufferBeginInfo) == 32 && sizeof(VkAcquireNextImageInfoKHR) == 56);
static_assert(offsetof(VkCommandBufferBeginInfo, flags) == 16
              && offsetof(VkAcquireNextImageInfoKHR, swapchain) == 16);

struct BackBufferSubmission {
  // Accumulate what has been submitted for this acquired image. CPU recording
  // order is not reliable: a worker can record the HUD before the scene.
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
  bool scene = false;
  bool ui = false;
  bool brightness = false;
  bool failed = false;

  constexpr bool ApplyRecording(bool scene_write, bool ui_write, bool has_brightness_pass, bool invalid_recording) {
    // Select only the first UI boundary after scene output. A later scene write
    // would invalidate that boundary, so reject it rather than scale the HUD.
    failed |= invalid_recording || (scene_write && ui);
    const bool first_scene_ui = ui_write && (scene || scene_write) && !ui;
    if (first_scene_ui) {
      brightness = has_brightness_pass && !failed;
      failed |= !brightness;
    }
    scene |= scene_write;
    ui |= ui_write;
    return first_scene_ui && brightness && !failed;
  }
};

static_assert([] {
  BackBufferSubmission parallel;
  if (parallel.ApplyRecording(true, false, false, false)) return false;
  if (!parallel.ApplyRecording(false, true, true, false)) return false;
  if (parallel.ApplyRecording(false, true, true, false) || parallel.failed) return false;
  BackBufferSubmission menu;
  if (menu.ApplyRecording(false, true, true, false) || menu.brightness || menu.failed) return false;
  BackBufferSubmission no_ui;
  no_ui.ApplyRecording(true, false, false, false);
  if (!no_ui.scene || no_ui.ui || no_ui.brightness || no_ui.failed) return false;
  BackBufferSubmission same_list;
  if (!same_list.ApplyRecording(true, true, true, false)) return false;
  BackBufferSubmission missing;
  missing.ApplyRecording(true, false, false, false);
  if (missing.ApplyRecording(false, true, false, false) || !missing.failed) return false;
  BackBufferSubmission stale;
  if (stale.ApplyRecording(true, true, true, true) || !stale.failed) return false;
  BackBufferSubmission late;
  late.ApplyRecording(false, true, true, false);
  if (late.ApplyRecording(true, false, false, false) || !late.failed) return false;
  // A new acquisition must not inherit an earlier image generation's UI.
  parallel = {};
  return parallel.ApplyRecording(true, true, true, false) && !parallel.failed;
}());

struct ShaderInjectionBuffer {
  reshade::api::resource buffer = {0};
  ShaderInjectData* data = nullptr;
};

static void DestroyShaderInjectionBuffer(reshade::api::device* device, ShaderInjectionBuffer* injection) {
  if (injection->buffer.handle == 0) return;
  if (injection->data != nullptr) {
    device->unmap_buffer_region(injection->buffer);
  }
  device->destroy_resource(injection->buffer);
  *injection = {};
}

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
  reshade::api::resource scene_copy = {0};
  renodx::utils::render::RenderPass scene_scale_pass;
  reshade::api::resource shader_injection = {0};
  std::uint64_t acquisition_id = 0;
  BackBufferSubmission submitted;
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

struct RecordedBackBuffer {
  // This list's evidence is kept separate until its position in the queue is known.
  BackBufferReference owner;
  reshade::api::resource scene_source = {0};
  bool scene_source_after_ui = false;
  bool scene_source_local = false;
  std::uint64_t acquisition_id = 0;
  ShaderInjectionBuffer* brightness = nullptr;
  bool brightness_not_required = false;
  bool scene = false;
  bool ui = false;
  bool late_scene = false;
  std::uint32_t ui_shader = 0;
  std::uint32_t late_scene_shader = 0;
  bool late_scene_from_secondary = false;
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
};

// Keep evidence with the command list, not the worker thread or a CPU frame.
// Vulkan requires the game to finish using a list before resetting it.
struct __declspec(uuid("3d714413-6741-470a-b0a8-6d443d0c7dbe")) CommandListData {
  std::optional<reshade::api::render_pass_render_target_desc> target;
  std::optional<reshade::api::render_pass_depth_stencil_desc> depth;
  std::vector<RecordedBackBuffer> back_buffers;
  std::deque<ShaderInjectionBuffer> shader_injections;
  std::size_t used_injections = 0;
  bool can_suspend = false;
  std::uint32_t active_queries = 0;
  std::vector<reshade::api::resource> scene_resources;
};

static renodx::utils::data::ParallelFlatHashMap<
    reshade::api::swapchain*, std::shared_ptr<SwapchainState>, std::shared_mutex>
    swapchains;

struct PipelineColorWrites {
  reshade::api::device* device;
  std::optional<std::uint8_t> mask;
  bool dynamic = false;
};
static renodx::utils::data::ParallelFlatHashMap<
    std::uint64_t, PipelineColorWrites, std::shared_mutex>
    pipeline_color_writes;

struct PendingBackBuffer {
  BackBufferReference owner;
  std::uint64_t acquisition_id;
  BackBufferSubmission submitted;
  ShaderInjectionBuffer* selected = nullptr;
  std::vector<reshade::api::resource> scene_resources;
};

// ReShade reports lists before Vulkan says whether submission succeeded.
// Collect their changes during that call and keep them only if it succeeds.
static thread_local std::vector<PendingBackBuffer>* pending_submissions = nullptr;
static thread_local std::optional<std::uint32_t> command_buffer_flags;
static PFN_vkAcquireNextImageKHR acquire_next_image = nullptr;
static PFN_vkAcquireNextImage2KHR acquire_next_image2 = nullptr;
static PFN_vkBeginCommandBuffer begin_command_buffer = nullptr;
static PFN_vkQueueSubmit queue_submit = nullptr;
static PFN_vkQueueSubmit2 queue_submit2 = nullptr;
static std::vector<renodx::utils::detour::Function> lifecycle_hooks;

static std::vector<SwapchainEntry> GetDeviceSwapchains(reshade::api::device* device) {
  std::vector<SwapchainEntry> entries;
  swapchains.for_each([&](const auto& entry) {
    const auto& [swapchain, state] = entry;
    if (state->device == device) {
      entries.push_back({.swapchain = swapchain, .state = state});
    }
  });
  return entries;
}

static BackBufferReference FindBackBuffer(
    reshade::api::device* device, const CommandListData& recording, reshade::api::resource resource) {
  for (const auto& recorded : recording.back_buffers) {
    if (recorded.owner.original != resource && recorded.owner.clone != resource) continue;
    const std::shared_lock lock(recorded.owner.state->mutex);
    if (!recorded.owner.state->closing) return recorded.owner;
  }
  // Release the registry locks before taking any swapchain state lock.
  for (const auto& [swapchain, state] : GetDeviceSwapchains(device)) {
    const std::shared_lock lock(state->mutex);
    if (state->closing) continue;
    for (std::uint32_t index = 0; index < state->back_buffers.size(); ++index) {
      const auto& buffer = state->back_buffers[index];
      if (buffer.back_buffer == resource || buffer.clone == resource) {
        return {.state = state, .index = index, .original = buffer.back_buffer, .clone = buffer.clone};
      }
    }
  }
  return {};
}

static RecordedBackBuffer* GetRecordedBackBuffer(CommandListData* recording, const BackBufferReference& owner) {
  for (auto& buffer : recording->back_buffers) {
    if (buffer.owner.state == owner.state && buffer.owner.index == owner.index) return &buffer;
  }
  const std::shared_lock lock(owner.state->mutex);
  if (owner.state->closing || owner.index >= owner.state->back_buffers.size()) return nullptr;
  recording->back_buffers.push_back({.owner = owner, .acquisition_id = owner.state->back_buffers[owner.index].acquisition_id});
  return &recording->back_buffers.back();
}

static bool RenderSceneBrightness(
    reshade::api::command_list* cmd_list, BackBufferState* buffer,
    reshade::api::resource_usage usage, const ShaderInjectionBuffer* injection = nullptr) {
  if (buffer->scene_failed) return false;
  const bool fallback = injection == nullptr;
  const auto* values = (fallback ? reinterpret_cast<const ShaderInjectData*>(buffer->proxy.shader_injection) : injection->data);
  if (values == nullptr) return false;
  if (!(values->diffuse_white_nits > 0.f) || !std::isfinite(values->diffuse_white_nits)
      || !(values->graphics_white_nits > 0.f) || !std::isfinite(values->graphics_white_nits)) {
    buffer->scene_failed = true;
    renodx::utils::log::e("rdr2vk: invalid scene/UI brightness values; waiting for swapchain recreation.");
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

  // Every use ends in copy_dest, after synchronizing its shader reads. Preserve
  // that layout/dependency across lists even though this copy overwrites it all.
  cmd_list->barrier(buffer->scene_copy, reshade::api::resource_usage::copy_dest, reshade::api::resource_usage::copy_dest);
  cmd_list->barrier(buffer->clone, usage, reshade::api::resource_usage::copy_source);
  cmd_list->copy_resource(buffer->clone, buffer->scene_copy);
  cmd_list->barrier(buffer->scene_copy, reshade::api::resource_usage::copy_dest, reshade::api::resource_usage::shader_resource);
  cmd_list->barrier(buffer->clone, reshade::api::resource_usage::copy_source, reshade::api::resource_usage::render_target);
  // Scale the decoded scene by Game Brightness / UI Brightness. The final
  // proxy multiplies everything by UI Brightness, leaving the scene at Game
  // Brightness and the HUD at UI Brightness. The shader leaves alpha unchanged.
  // Settings and the enable switch share the existing shared.h buffer.
  // Push bindings avoid using up ReShade's limited descriptor-set pool.
  auto& pass = buffer->scene_scale_pass;
  const reshade::api::buffer_range injection_range = {
      .buffer = (fallback ? buffer->shader_injection : injection->buffer), .offset = 0, .size = sizeof(ShaderInjectData)};
  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, pass.layout, 0,
                             {.binding = 0, .count = 1, .type = reshade::api::descriptor_type::texture_shader_resource_view, .descriptors = pass.shader_resource_slots.views.data()});
  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, pass.layout, 0,
                             {.binding = 1, .count = 1, .type = reshade::api::descriptor_type::constant_buffer, .descriptors = &injection_range});
  const bool rendered = pass.Render(cmd_list);
  cmd_list->barrier(buffer->clone, reshade::api::resource_usage::render_target, usage);
  cmd_list->barrier(buffer->scene_copy, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::copy_dest);
  if (!rendered) {
    buffer->scene_failed = true;
    renodx::utils::log::e("rdr2vk: scene brightness pass failed; waiting for swapchain recreation.");
  }
  return rendered;
}

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

  // Shader/configuration fields are set once by the earlier device-init callback.
  // Do not hold the core swapchain mutex while querying the resource registry.
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

  // Create all clones before rendering workers can request them from a render-pass
  // callback. The shared registry still owns them and retires them with each backbuffer.
  // Do this after validating every backbuffer and without holding registry/state locks.
  for (std::uint32_t index = 0; index < back_buffer_count; ++index) {
    auto& buffer = state->back_buffers[index];
    const auto clone = renodx::utils::resource::upgrade::GetResourceClone(buffer.back_buffer);
    if (clone.handle == 0) {
      renodx::utils::log::e("rdr2vk::swapchain_proxy: backbuffer clone initialization failed; index=", index);
      RetireSwapchain(state);
      return;
    }
    // Shape is immutable for this image. Validate it before any pass can use it.
    bool valid_clone = false;
    renodx::utils::resource::GetLiveResourceInfo(clone, [&](const auto& info) {
      valid_clone = info.device == device && info.is_clone && info.fallback == buffer.back_buffer
                    && info.desc.type == reshade::api::resource_type::texture_2d
                    && info.desc.texture.format == reshade::api::format::r16g16b16a16_float
                    && info.desc.texture.width == width && info.desc.texture.height == height
                    && info.desc.texture.depth_or_layers == 1 && info.desc.texture.samples == 1;
    });
    if (!valid_clone) {
      renodx::utils::log::e("rdr2vk::swapchain_proxy: incompatible float clone; index=", index);
      RetireSwapchain(state);
      return;
    }
    buffer.clone = clone;
    const reshade::api::resource_desc scene_desc(
        width, height, 1, 1, reshade::api::format::r16g16b16a16_float, 1,
        reshade::api::memory_heap::gpu_only,
        reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource);
    const reshade::api::resource_view_desc scene_view_desc(reshade::api::format::r16g16b16a16_float);
    auto& pass = buffer.scene_scale_pass;
    // RenderPass owns these views, including cleanup after partial initialization.
    auto& source_views = pass.shader_resource_slots.generated_views;
    auto& target_views = pass.render_target_slots.generated_views;
    source_views.resize(1);
    target_views.resize(1);
    bool created_scene_resources = device->create_resource(scene_desc, nullptr, reshade::api::resource_usage::copy_dest, &buffer.scene_copy);
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
    // A disabled pass discards every fragment, leaving menu/UI color and
    // alpha untouched. The attachment therefore has to LOAD, not discard.
    pass.render_target_load_op = reshade::api::render_pass_load_op::load;
    if (!device->check_capability(reshade::api::device_caps::partial_push_descriptor_updates)) {
      renodx::utils::log::e("rdr2vk: Vulkan push descriptors are required for scene brightness.");
      RetireSwapchain(state);
      return;
    }
    if (!device->create_resource({sizeof(ShaderInjectData), reshade::api::memory_heap::gpu_only, reshade::api::resource_usage::constant_buffer | reshade::api::resource_usage::copy_dest}, nullptr, reshade::api::resource_usage::constant_buffer, &buffer.shader_injection)) {
      renodx::utils::log::e("rdr2vk: could not create shared shader injection buffer.");
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

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::vulkan) {
    renodx::utils::data::Create<CommandListData>(cmd_list);
  }
}

static void OnResetCommandList(reshade::api::command_list* cmd_list) {
  if (auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list); recording != nullptr) {
    recording->target.reset();
    recording->depth.reset();
    recording->back_buffers.clear();
    recording->used_injections = 0;
    recording->scene_resources.clear();
    // A secondary list can draw inside a pass only through inheritance. Without
    // CONTINUE, a later begin_render_pass belongs to this primary list.
    recording->can_suspend = command_buffer_flags.has_value() && (*command_buffer_flags & (VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT | VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT)) == 0;
    recording->active_queries = 0;
  }
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list); recording != nullptr) {
    for (auto& injection : recording->shader_injections) {
      DestroyShaderInjectionBuffer(cmd_list->get_device(), &injection);
    }
  }
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

static void OnBeginRenderPass(
    reshade::api::command_list* cmd_list, std::uint32_t count,
    const reshade::api::render_pass_render_target_desc* targets,
    const reshade::api::render_pass_depth_stencil_desc* depth) {
  auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (recording == nullptr) return;
  // Only a single-color pass can be interrupted by the pre-UI path.
  recording->target = (count == 1 ? std::optional{targets[0]} : std::nullopt);
  recording->depth = (depth != nullptr ? std::optional{*depth} : std::nullopt);
}

static void OnEndRenderPass(reshade::api::command_list* cmd_list) {
  if (auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list); recording != nullptr) {
    recording->target.reset();
    recording->depth.reset();
  }
}

static void OnInitPipeline(
    reshade::api::device* device, [[maybe_unused]] reshade::api::pipeline_layout layout,
    std::uint32_t count, const reshade::api::pipeline_subobject* subobjects, reshade::api::pipeline pipeline) {
  if (device->get_api() != reshade::api::device_api::vulkan) return;
  PipelineColorWrites writes = {.device = device};
  for (std::uint32_t index = 0; index < count; ++index) {
    const auto& object = subobjects[index];
    if (object.type == reshade::api::pipeline_subobject_type::blend_state && object.count != 0) {
      writes.mask = static_cast<const reshade::api::blend_desc*>(object.data)->render_target_write_mask[0];
    } else if (object.type == reshade::api::pipeline_subobject_type::dynamic_pipeline_states) {
      for (const auto state : std::span(static_cast<const reshade::api::dynamic_state*>(object.data), object.count)) {
        writes.dynamic |= state == reshade::api::dynamic_state::render_target_write_mask;
      }
    }
  }
  pipeline_color_writes.insert_or_assign(pipeline.handle, writes);
}

static void OnDestroyPipeline([[maybe_unused]] reshade::api::device* device, reshade::api::pipeline pipeline) {
  pipeline_color_writes.erase(pipeline.handle);
}

static bool OnBeginQuery(
    reshade::api::command_list* cmd_list, [[maybe_unused]] reshade::api::query_heap heap,
    [[maybe_unused]] reshade::api::query_type type, [[maybe_unused]] std::uint32_t index) {
  if (auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list); recording != nullptr) {
    ++recording->active_queries;
  }
  return false;
}

static bool OnEndQuery(
    reshade::api::command_list* cmd_list, [[maybe_unused]] reshade::api::query_heap heap,
    reshade::api::query_type type, [[maybe_unused]] std::uint32_t index) {
  if (auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list);
      recording != nullptr && recording->active_queries != 0 && type != reshade::api::query_type::timestamp) {
    --recording->active_queries;
  }
  return false;
}

static void OnSceneDrawn(reshade::api::command_list* cmd_list) {
  auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (recording == nullptr) return;
  if (!recording->target.has_value()) return;
  const auto resource = cmd_list->get_device()->get_resource_from_view(recording->target->view);
  if (resource.handle == 0) return;
  if (std::find(recording->scene_resources.begin(), recording->scene_resources.end(), resource) == recording->scene_resources.end()) {
    recording->scene_resources.push_back(resource);
  }
  const auto owner = FindBackBuffer(cmd_list->get_device(), *recording, resource);
  if (owner.state == nullptr) return;
  auto* buffer = GetRecordedBackBuffer(recording, owner);
  if (buffer == nullptr) return;
  if (buffer->ui && buffer->late_scene_shader == 0) {
    buffer->late_scene_shader = renodx::utils::state::GetCurrentShaderHash(cmd_list, reshade::api::pipeline_stage::pixel_shader);
  }
  buffer->late_scene |= buffer->ui;
  buffer->scene = true;
  buffer->usage = reshade::api::resource_usage::render_target;
}

// Observe scene output without changing the game's shader math.
static constexpr auto ON_SCENE_OUTPUT = []<typename Context>(Context& context)
    -> renodx::utils::command_action::CallbackResult<Context> {
  auto* recording = renodx::utils::data::Get<CommandListData>(context.cmd_list);
  if (recording == nullptr || !recording->target.has_value()) return {};
  if (context.matched_shader_hash == SCENE_BLIT_SHADER || context.matched_shader_hash == SCENE_BLIT_MSAA_SHADER
      || context.matched_shader_hash == SCENE_TAA_SHARPEN_SHADER) {
    // Blits and TAA sharpening read the finished scene from different bindings.
    // Check the actual input instead of assuming every use contains scene color.
    const std::uint32_t source_binding = (context.matched_shader_hash == SCENE_TAA_SHARPEN_SHADER ? 156u : 186u);
    auto* device = context.cmd_list->get_device();
    const auto tables = renodx::utils::state::CopyBoundDescriptorTables(
        context.cmd_list, renodx::utils::state::PipelineBindPoint::GRAPHICS);
    if (!tables.has_value() || !tables->known || !tables->tables.has(1)) return {};
    reshade::api::descriptor_heap heap = {};
    std::uint32_t offset = 0;
    if (!renodx::utils::descriptor::TryGetDescriptorHeapOffset(
            device, tables->tables.get(1), source_binding, 0, &heap, &offset)) return {};
    auto* descriptors = renodx::utils::data::Get<renodx::utils::descriptor::DeviceData>(device);
    if (descriptors == nullptr) return {};
    reshade::api::resource_view source_view = {};
    {
      const std::shared_lock lock(descriptors->mutex);
      const auto found = descriptors->heaps.find(heap.handle);
      if (found != descriptors->heaps.end() && offset < found->second.size() && found->second[offset].HasResourceView()) {
        source_view = found->second[offset].resource_view;
      }
    }
    if (source_view.handle == 0) return {};

    // Offscreen copies do not establish scene output on the backbuffer.
    const auto source = device->get_resource_from_view(source_view);
    const auto target = device->get_resource_from_view(recording->target->view);
    const auto owner = FindBackBuffer(device, *recording, target);
    if (owner.state == nullptr) return {};
    auto* buffer = GetRecordedBackBuffer(recording, owner);
    if (buffer == nullptr) return {};
    // Remember which texture this blit reads. Submission order tells us whether
    // an earlier list produced scene color in it; recording timestamps cannot.
    buffer->scene_source = source;
    buffer->scene_source_after_ui = buffer->ui;
    buffer->scene_source_local =
        std::find(recording->scene_resources.begin(), recording->scene_resources.end(), source)
        != recording->scene_resources.end();
    buffer->usage = reshade::api::resource_usage::render_target;
    return {};
  }
  // FXAA is already a known scene output. Observe it after the game's draw.
  return {.post_callback = [](Context& completed, const void*) { OnSceneDrawn(completed.cmd_list); }};
};

static bool OnBeforeUIDraw(reshade::api::command_list* cmd_list) {
  auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (recording == nullptr || !recording->target.has_value()) return true;
  auto* device = cmd_list->get_device();
  auto target = *recording->target;
  // UI atlases and pause-background copies are not the end of the scene.
  // Only UI drawn onto the actual backbuffer can start brightness scaling.
  const auto resource = device->get_resource_from_view(target.view);
  if (resource.handle == 0) return true;
  const auto owner = FindBackBuffer(device, *recording, resource);
  if (owner.state == nullptr) return true;
  for (auto& recorded : recording->back_buffers) {
    if ((recorded.owner.original == resource || recorded.owner.clone == resource) && recorded.ui) {
      recorded.usage = reshade::api::resource_usage::render_target;
      return true;
    }
  }
  std::optional<std::uint8_t> color_write_mask;
  pipeline_color_writes.if_contains(
      renodx::utils::state::GetBoundShaderPipeline(cmd_list, reshade::api::pipeline_stage::pixel_shader).handle,
      [&](const auto& entry) {
        const auto& [pipeline, writes] = entry;
        if (writes.device != device) return;
        if (writes.dynamic) {
          const auto* snapshot = renodx::utils::state::internal::GetTrackedSnapshotData(cmd_list);
          if (snapshot == nullptr) return;
          const auto value = snapshot->dynamic_states.find(reshade::api::dynamic_state::render_target_write_mask);
          if (value != snapshot->dynamic_states.end()) {
            color_write_mask = static_cast<std::uint8_t>(value->second);
          }
        } else {
          color_write_mask = writes.mask;
        }
      });
  if (color_write_mask.has_value() && (*color_write_mask & 7) == 0) return true;
  auto* recorded = GetRecordedBackBuffer(recording, owner);
  if (recorded == nullptr) return true;
  recorded->ui = true;
  recorded->usage = reshade::api::resource_usage::render_target;
  recorded->ui_shader = renodx::utils::state::GetCurrentShaderHash(cmd_list, reshade::api::pipeline_stage::pixel_shader);

  const std::unique_lock lock(owner.state->mutex);
  if (owner.state->closing || owner.index >= owner.state->back_buffers.size()) return true;
  auto& buffer = owner.state->back_buffers[owner.index];
  const auto* settings = reinterpret_cast<const ShaderInjectData*>(buffer.proxy.shader_injection);
  if (settings == nullptr) return true;
  if (settings->diffuse_white_nits > 0.f && std::isfinite(settings->diffuse_white_nits)
      && settings->diffuse_white_nits == settings->graphics_white_nits) {
    recorded->brightness_not_required = true;
    return true;
  }
  // Record a disabled pass now, even if another worker has not recorded the
  // scene yet. Enable it later only if submission order proves it follows scene.
  if (buffer.scene_failed || buffer.acquisition_id == 0 || recorded->acquisition_id != buffer.acquisition_id
      || !recording->can_suspend || !color_write_mask.has_value()) return true;

  auto depth = recording->depth;
  const bool preserved_color = target.store_op == reshade::api::render_pass_store_op::store;
  const bool preserved_depth = !depth.has_value()
                               || (depth->depth_store_op == reshade::api::render_pass_store_op::store
                                   && depth->stencil_store_op == reshade::api::render_pass_store_op::store);
  if (!preserved_color || !preserved_depth || recording->active_queries != 0) {
    // A menu/mask pass can legitimately be non-suspendable. Its missing
    // brightness pass is checked at submission only if it follows scene output.
    return true;
  }

  // Generic snapshot replay also rebinds render targets, which Vulkan does not support.
  // Copy the tracked Vulkan graphics state and restore the attachments ourselves.
  const auto* handle = renodx::utils::state::internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr || handle->api != reshade::api::device_api::vulkan) {
    buffer.scene_failed = true;
    renodx::utils::log::e("rdr2vk: missing graphics state for scene brightness.");
    return true;
  }
  using VulkanState = renodx::utils::state::internal::CommandListState<reshade::api::device_api::vulkan>;
  auto saved_state = static_cast<const VulkanState*>(handle->state)->snapshot;
  saved_state.render_targets_known = false;
  renodx::utils::resource::GetResourceViewInfo(target.view, [&](const auto& info) {
    if (!info.destroyed && info.clone.handle != 0) {
      target.view = info.clone;
    }
  });
  if (device->get_resource_from_view(target.view) != owner.clone) {
    buffer.scene_failed = true;
    renodx::utils::log::e("rdr2vk: UI attachment does not resolve to the tracked float backbuffer clone.");
    return true;
  }
  target.load_op = reshade::api::render_pass_load_op::load;
  reshade::api::resource depth_resource = {};
  if (depth.has_value()) {
    renodx::utils::resource::GetResourceViewInfo(depth->view, [&](const auto& info) {
      if (info.clone.handle != 0) {
        depth->view = info.clone;
      }
    });
    depth_resource = device->get_resource_from_view(depth->view);
    depth->depth_load_op = reshade::api::render_pass_load_op::load;
    depth->stencil_load_op = reshade::api::render_pass_load_op::load;
  }

  if (recording->used_injections == recording->shader_injections.size()) {
    auto& injection = recording->shader_injections.emplace_back();
    void* mapped = nullptr;
    if (!device->create_resource(
            reshade::api::resource_desc(sizeof(*injection.data), reshade::api::memory_heap::cpu_to_gpu, reshade::api::resource_usage::constant_buffer),
            nullptr, reshade::api::resource_usage::constant_buffer, &injection.buffer)
        || !device->map_buffer_region(injection.buffer, 0, sizeof(*injection.data), reshade::api::map_access::write_only, &mapped)) {
      DestroyShaderInjectionBuffer(device, &injection);
      recording->shader_injections.pop_back();
      buffer.scene_failed = true;
      renodx::utils::log::e("rdr2vk: could not create command-list shader injection buffer.");
      return true;
    }
    injection.data = static_cast<ShaderInjectData*>(mapped);
  }
  // Each recording needs its own settings upload: several workers can record
  // competing UI boundaries. Only the selected upload will enable its pass.
  auto* injection = &recording->shader_injections[recording->used_injections++];
  *injection->data = *settings;
  injection->data->scene_brightness_enabled = 0.f;

  // Finish any deferred clear before copying the scene. Resume the game's pass
  // without clearing it again, then restore the graphics state for the UI draw.
  renodx::utils::resource::upgrade::HandlePendingRenderPassRenderTargets(cmd_list);
  cmd_list->end_render_pass();
  if (depth_resource.handle != 0) {
    cmd_list->barrier(depth_resource, reshade::api::resource_usage::depth_stencil, reshade::api::resource_usage::depth_stencil);
  }
  if (RenderSceneBrightness(cmd_list, &buffer, reshade::api::resource_usage::render_target, injection)) {
    recorded->brightness = injection;
  }
  cmd_list->begin_render_pass(1, &target, (depth.has_value() ? &*depth : nullptr));
  saved_state.ApplyGraphics(cmd_list);
  return true;
}

static void OnBarrier(
    reshade::api::command_list* cmd_list, std::uint32_t count,
    const reshade::api::resource* resources, [[maybe_unused]] const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states) {
  auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (recording == nullptr) return;
  for (std::uint32_t index = 0; index < count; ++index) {
    for (auto& recorded : recording->back_buffers) {
      if (resources[index] == recorded.owner.original || resources[index] == recorded.owner.clone) {
        recorded.usage = new_states[index];
      }
    }
  }
}

static void OnExecuteSecondaryCommandList(
    reshade::api::command_list* cmd_list, reshade::api::command_list* secondary_cmd_list) {
  auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list);
  const auto* secondary = renodx::utils::data::Get<CommandListData>(secondary_cmd_list);
  if (recording == nullptr || secondary == nullptr) return;
  for (const auto& child : secondary->back_buffers) {
    auto* buffer = GetRecordedBackBuffer(recording, child.owner);
    if (buffer == nullptr) continue;
    if (child.scene_source.handle != 0) {
      buffer->scene_source = child.scene_source;
      buffer->scene_source_after_ui = child.scene_source_after_ui || buffer->ui;
      buffer->scene_source_local = child.scene_source_local || std::find(recording->scene_resources.begin(), recording->scene_resources.end(), child.scene_source) != recording->scene_resources.end();
    }
    if (buffer->acquisition_id != child.acquisition_id) {
      buffer->late_scene = true;
    }
    if (child.late_scene || (buffer->ui && child.scene)) {
      buffer->late_scene_from_secondary = true;
      if (buffer->late_scene_shader == 0) {
        buffer->late_scene_shader = child.late_scene_shader;
      }
    }
    buffer->late_scene |= child.late_scene || (buffer->ui && child.scene);
    buffer->scene |= child.scene;
    if (!buffer->ui && child.ui) {
      buffer->brightness_not_required = child.brightness_not_required;
    }
    buffer->ui |= child.ui;
    if (buffer->ui_shader == 0) {
      buffer->ui_shader = child.ui_shader;
    }
    if (child.usage != reshade::api::resource_usage::undefined) {
      buffer->usage = child.usage;
    }
  }
  recording->scene_resources.insert(recording->scene_resources.end(), secondary->scene_resources.begin(), secondary->scene_resources.end());
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  // Vulkan can reuse a destroyed texture's handle. Do not let a new texture
  // inherit the old texture's scene classification.
  swapchains.for_each([&](const auto& entry) {
    const auto& [chain, state] = entry;
    if (chain->get_device() != device) return;
    const std::unique_lock lock(state->mutex);
    for (auto& buffer : state->back_buffers) {
      std::erase(buffer.submitted_scene_resources, resource);
    }
  });
}

static void OnExecuteCommandList(reshade::api::command_queue* queue, reshade::api::command_list* cmd_list) {
  auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (recording == nullptr) return;
  const auto publish_scene_resources = [&]() {
    // Publish outputs after checking this list's blits. Otherwise a scene write
    // later in the list could incorrectly validate an earlier blit.
    if (pending_submissions == nullptr || recording->scene_resources.empty()) return;
    swapchains.for_each([&](const auto& entry) {
      const auto& [chain, state] = entry;
      if (chain->get_device() != cmd_list->get_device()) return;
      const std::unique_lock lock(state->mutex);
      if (state->closing) return;
      for (std::uint32_t index = 0; index < state->back_buffers.size(); ++index) {
        auto& image = state->back_buffers[index];
        auto found = std::find_if(pending_submissions->begin(), pending_submissions->end(), [&](const auto& pending) {
          return pending.owner.state == state && pending.owner.index == index;
        });
        if (found == pending_submissions->end()) {
          pending_submissions->push_back({
              .owner = {.state = state, .index = index, .original = image.back_buffer, .clone = image.clone},
              .acquisition_id = image.acquisition_id,
              .submitted = image.submitted,
              .scene_resources = image.submitted_scene_resources,
          });
          found = std::prev(pending_submissions->end());
        }
        for (const auto resource : recording->scene_resources) {
          if (std::find(found->scene_resources.begin(), found->scene_resources.end(), resource) == found->scene_resources.end()) {
            found->scene_resources.push_back(resource);
          }
        }
      }
    });
  };
  for (const auto& recorded : recording->back_buffers) {
    const auto& state = recorded.owner.state;
    const std::unique_lock lock(state->mutex);
    if (state->closing || recorded.owner.index >= state->back_buffers.size()) continue;
    auto& buffer = state->back_buffers[recorded.owner.index];
    if (state->queue == nullptr) {
      state->queue = queue;
    }
    if (pending_submissions == nullptr) {
      buffer.submitted.failed = true;
      if (!buffer.ordering_reported) {
        buffer.ordering_reported = true;
        renodx::utils::log::e("rdr2vk: Vulkan submission was not observed by the lifecycle hook.");
      }
      continue;
    }
    PendingBackBuffer* pending_buffer = nullptr;
    for (auto& pending : *pending_submissions) {
      if (pending.owner.state == state && pending.owner.index == recorded.owner.index) {
        pending_buffer = &pending;
        break;
      }
    }
    if (pending_buffer == nullptr) {
      pending_submissions->push_back({.owner = recorded.owner, .acquisition_id = buffer.acquisition_id, .submitted = buffer.submitted, .scene_resources = buffer.submitted_scene_resources});
      pending_buffer = &pending_submissions->back();
    }
    // Decide whether this list writes scene color before selecting its UI pass.
    auto* submitted = &pending_buffer->submitted;
    const bool scene = recorded.scene || recorded.scene_source_local
                       || (recorded.scene_source.handle != 0
                           && std::find(pending_buffer->scene_resources.begin(), pending_buffer->scene_resources.end(), recorded.scene_source)
                                  != pending_buffer->scene_resources.end());

    // Reject stale or unsafe recordings instead of applying a partial correction.
    const bool stale_recording = recorded.acquisition_id == 0 || recorded.acquisition_id != buffer.acquisition_id;
    const bool scene_after_ui = scene && submitted->ui;
    const bool queue_changed = state->queue != nullptr && state->queue != queue;
    const bool repeated_recording = recorded.brightness != nullptr && recorded.brightness->data->scene_brightness_enabled != 0.f;
    const bool first_scene_ui = recorded.ui && (submitted->scene || scene) && !submitted->ui;
    const bool has_brightness_pass = recorded.brightness_not_required || recorded.brightness != nullptr;
    const bool invalid_recording = stale_recording || recorded.late_scene
                                   || (scene && recorded.scene_source_after_ui)
                                   || queue_changed || repeated_recording;

    // Only the first valid UI boundary after scene output enables its upload.
    const bool enable = submitted->ApplyRecording(
        scene, recorded.ui, has_brightness_pass && !buffer.scene_failed, invalid_recording);
    if (recorded.brightness != nullptr) {
      recorded.brightness->data->scene_brightness_enabled = (enable ? 1.f : 0.f);
      if (enable) {
        pending_buffer->selected = recorded.brightness;
      }
    }
    // A later failure also disables any pass selected earlier in this submission.
    if (submitted->failed) {
      if (pending_buffer->selected != nullptr) {
        pending_buffer->selected->data->scene_brightness_enabled = 0.f;
      }
      if (!buffer.ordering_reported) {
        renodx::utils::log::e(
            "rdr2vk: unsupported scene/UI submission; backbuffer=", renodx::utils::log::AsPtr(buffer.back_buffer.handle),
            "; acquisition=", buffer.acquisition_id,
            "; list=", renodx::utils::log::AsPtr(cmd_list),
            "; stale_recording=", stale_recording,
            "; late_scene=", recorded.late_scene,
            "; late_scene_shader=", renodx::utils::log::AsHex(recorded.late_scene_shader),
            "; late_scene_from_secondary=", recorded.late_scene_from_secondary,
            "; scene_source_after_ui=", recorded.scene_source_after_ui,
            "; scene_after_ui=", scene_after_ui,
            "; missing_brightness=", first_scene_ui && !has_brightness_pass,
            "; queue_changed=", queue_changed,
            "; repeated_recording=", repeated_recording,
            "; list_ui_shader=", renodx::utils::log::AsHex(recorded.ui_shader),
            ". Skipping scene brightness for this acquired image.");
        buffer.ordering_reported = true;
      }
    }
    if (recorded.usage != reshade::api::resource_usage::undefined) {
      submitted->usage = recorded.usage;
    }
  }
  publish_scene_resources();
}

static void CommitBackBuffers(const std::vector<PendingBackBuffer>& pending_buffers, VkResult result) {
  for (const auto& pending : pending_buffers) {
    const std::unique_lock lock(pending.owner.state->mutex);
    if (pending.owner.state->closing || pending.owner.index >= pending.owner.state->back_buffers.size()) continue;
    auto& buffer = pending.owner.state->back_buffers[pending.owner.index];
    if (buffer.acquisition_id != pending.acquisition_id) continue;
    if (result == VK_SUCCESS) {
      buffer.submitted = pending.submitted;
      buffer.submitted_scene_resources = pending.scene_resources;
    } else {
      // No accepted submission is inferred from ReShade's pre-submit event.
      buffer.submitted.failed = true;
    }
  }
}

static VkResult WINAPI QueueSubmit(VkQueue queue, std::uint32_t count, const VkSubmitInfo* submits, VkFence fence) {
  std::vector<PendingBackBuffer> pending;
  auto* outer = std::exchange(pending_submissions, &pending);
  const auto result = queue_submit(queue, count, submits, fence);
  pending_submissions = outer;
  CommitBackBuffers(pending, result);
  return result;
}

static VkResult WINAPI QueueSubmit2(VkQueue queue, std::uint32_t count, const VkSubmitInfo2* submits, VkFence fence) {
  std::vector<PendingBackBuffer> pending;
  auto* outer = std::exchange(pending_submissions, &pending);
  const auto result = queue_submit2(queue, count, submits, fence);
  pending_submissions = outer;
  CommitBackBuffers(pending, result);
  return result;
}

static void OnAcquireBackBuffer(VkSwapchainKHR swapchain, std::uint32_t index) {
  std::shared_ptr<SwapchainState> state;
  swapchains.for_each([&](const auto& entry) {
    const auto& [chain, registered] = entry;
    if (chain->get_native() == reinterpret_cast<std::uint64_t>(swapchain)) {
      state = registered;
    }
  });
  if (state == nullptr) return;
  const std::unique_lock lock(state->mutex);
  if (state->closing || index >= state->back_buffers.size()) return;
  auto& buffer = state->back_buffers[index];
  ++buffer.acquisition_id;
  buffer.submitted = {};
  buffer.submitted_scene_resources.clear();
  // Acquisition can precede the GPU semaphore signal. Mapped shader data stays
  // with its command-list lifetime, not the CPU acquisition call.
}

static VkResult WINAPI AcquireNextImage(
    VkDevice device, VkSwapchainKHR swapchain, std::uint64_t timeout,
    VkSemaphore semaphore, VkFence fence, std::uint32_t* index) {
  const auto result = acquire_next_image(device, swapchain, timeout, semaphore, fence, index);
  if ((result == VK_SUCCESS || result == VK_SUBOPTIMAL_KHR) && index != nullptr) {
    OnAcquireBackBuffer(swapchain, *index);
  }
  return result;
}

static VkResult WINAPI AcquireNextImage2(
    VkDevice device, const VkAcquireNextImageInfoKHR* info, std::uint32_t* index) {
  const auto result = acquire_next_image2(device, info, index);
  if ((result == VK_SUCCESS || result == VK_SUBOPTIMAL_KHR) && info != nullptr && index != nullptr) {
    OnAcquireBackBuffer(info->swapchain, *index);
  }
  return result;
}

static VkResult WINAPI BeginCommandBuffer(VkCommandBuffer buffer, const VkCommandBufferBeginInfo* info) {
  const auto outer = std::exchange(command_buffer_flags, (info != nullptr ? std::optional{info->flags} : std::nullopt));
  const auto result = begin_command_buffer(buffer, info);
  command_buffer_flags = outer;
  return result;
}

static void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::vulkan || !lifecycle_hooks.empty()) return;
  const auto get = reinterpret_cast<PFN_vkGetDeviceProcAddr>(
      GetProcAddress(reshade::internal::get_reshade_module_handle(), "vkGetDeviceProcAddr"));
  if (get == nullptr) {
    renodx::utils::log::e("rdr2vk: ReShade Vulkan lifecycle entry points are unavailable.");
    return;
  }
  auto* const native = std::bit_cast<VkDevice>(device->get_native());
  acquire_next_image = reinterpret_cast<PFN_vkAcquireNextImageKHR>(get(native, "vkAcquireNextImageKHR"));
  acquire_next_image2 = reinterpret_cast<PFN_vkAcquireNextImage2KHR>(get(native, "vkAcquireNextImage2KHR"));
  begin_command_buffer = reinterpret_cast<PFN_vkBeginCommandBuffer>(get(native, "vkBeginCommandBuffer"));
  queue_submit = reinterpret_cast<PFN_vkQueueSubmit>(get(native, "vkQueueSubmit"));
  queue_submit2 = reinterpret_cast<PFN_vkQueueSubmit2>(get(native, "vkQueueSubmit2"));
  if (queue_submit2 == nullptr) {
    queue_submit2 = reinterpret_cast<PFN_vkQueueSubmit2>(get(native, "vkQueueSubmit2KHR"));
  }
  if (acquire_next_image == nullptr || begin_command_buffer == nullptr || queue_submit == nullptr) {
    renodx::utils::log::e("rdr2vk: required Vulkan lifecycle entry points are unavailable.");
    return;
  }
  lifecycle_hooks = {
      {&acquire_next_image, AcquireNextImage},
      {&begin_command_buffer, BeginCommandBuffer},
      {&queue_submit, QueueSubmit},
  };
  if (acquire_next_image2 != nullptr) {
    lifecycle_hooks.emplace_back(&acquire_next_image2, AcquireNextImage2);
  }
  if (queue_submit2 != nullptr) {
    lifecycle_hooks.emplace_back(&queue_submit2, QueueSubmit2);
  }
  try {
    renodx::utils::detour::Install(lifecycle_hooks);
  } catch (const std::system_error& error) {
    lifecycle_hooks.clear();
    renodx::utils::log::e("rdr2vk: Vulkan lifecycle hooks failed; error=", error.code().value());
  }
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
  if (buffer.clone != clone) {
    fail("float clone changed after descriptor initialization");
    return;
  }

  bool valid_clone = false;
  renodx::utils::resource::GetLiveResourceInfo(clone, [&](const auto& info) {
    valid_clone = info.device == device && info.is_clone && info.fallback.handle == buffer.back_buffer.handle;
  });
  if (!valid_clone) {
    fail("float clone is unavailable or incompatible");
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
        renodx::utils::log::e("rdr2vk: scene brightness fallback has no known image state.");
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
    // Even partial initialization may have recorded commands. Keep everything alive
    // until the owning queue is drained during retirement, rather than retry per frame.
    fail("proxy rendering failed");
  }
  // Acquisition, not presentation or CPU frame timing, starts the next image use.
}

static void OnDestroyCommandQueue(reshade::api::command_queue* queue) {
  // Snapshot ownership only. Never wait on a state mutex under a registry lock.
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
  std::vector<std::uint64_t> retired_pipelines;
  pipeline_color_writes.for_each([&](const auto& entry) {
    const auto& [pipeline, writes] = entry;
    if (writes.device == device) {
      retired_pipelines.push_back(pipeline);
    }
  });
  for (const auto pipeline : retired_pipelines) {
    pipeline_color_writes.erase(pipeline);
  }
  for (const auto& [swapchain, state] : GetDeviceSwapchains(device)) {
    swapchains.erase_if(swapchain, [&](const auto& entry) {
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

using internal::OnBeforeUIDraw;
using internal::OnSceneDrawn;

static void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    renodx::utils::descriptor::trace_descriptor_tables = true;
    renodx::utils::descriptor::Use(reason);
    // Keep core swapchain/clone setup, replacing only this addon's proxy owner.
    reshade::unregister_event<reshade::addon_event::present>(renodx::mods::swapchain::v2::OnPresent);
    reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
    reshade::register_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
    reshade::register_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
    reshade::register_event<reshade::addon_event::destroy_command_queue>(internal::OnDestroyCommandQueue);
    reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
    reshade::register_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
    reshade::register_event<reshade::addon_event::present>(internal::OnPresent);
    reshade::register_event<reshade::addon_event::init_command_list>(internal::OnInitCommandList);
    reshade::register_event<reshade::addon_event::destroy_command_list>(internal::OnDestroyCommandList);
    reshade::register_event<reshade::addon_event::reset_command_list>(internal::OnResetCommandList);
    reshade::register_event<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
    reshade::register_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
    reshade::register_event<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
    reshade::register_event<reshade::addon_event::destroy_pipeline>(internal::OnDestroyPipeline);
    reshade::register_event<reshade::addon_event::begin_query>(internal::OnBeginQuery);
    reshade::register_event<reshade::addon_event::end_query>(internal::OnEndQuery);
    reshade::register_event<reshade::addon_event::barrier>(internal::OnBarrier);
    reshade::register_event<reshade::addon_event::execute_command_list>(internal::OnExecuteCommandList);
    reshade::register_event<reshade::addon_event::execute_secondary_command_list>(internal::OnExecuteSecondaryCommandList);
    for (const auto hash : {internal::SCENE_BLIT_SHADER, internal::SCENE_BLIT_MSAA_SHADER, internal::SCENE_FXAA_SHADER, internal::SCENE_TAA_SHARPEN_SHADER}) {
      renodx::utils::command_action::Filter filter = {};
      filter.shader_hash = hash;
      filter.command_types = renodx::utils::command_action::COMMAND_TYPE_DIRECT_DRAW;
      renodx::utils::command_action::Register(internal::ON_SCENE_OUTPUT, filter);
    }
  } else if (reason == DLL_PROCESS_DETACH) {
    renodx::utils::descriptor::Use(reason);
    if (!internal::lifecycle_hooks.empty()) {
      try {
        renodx::utils::detour::Uninstall(internal::lifecycle_hooks);
        internal::lifecycle_hooks.clear();
      } catch (const std::system_error& error) {
        renodx::utils::log::e("rdr2vk: Vulkan lifecycle hook removal failed; error=", error.code().value());
      }
    }
    renodx::utils::command_action::Unregister(internal::ON_SCENE_OUTPUT);
    reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
    reshade::unregister_event<reshade::addon_event::init_command_list>(internal::OnInitCommandList);
    reshade::unregister_event<reshade::addon_event::destroy_command_list>(internal::OnDestroyCommandList);
    reshade::unregister_event<reshade::addon_event::reset_command_list>(internal::OnResetCommandList);
    reshade::unregister_event<reshade::addon_event::destroy_resource>(internal::OnDestroyResource);
    reshade::unregister_event<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
    reshade::unregister_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
    reshade::unregister_event<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
    reshade::unregister_event<reshade::addon_event::destroy_pipeline>(internal::OnDestroyPipeline);
    reshade::unregister_event<reshade::addon_event::begin_query>(internal::OnBeginQuery);
    reshade::unregister_event<reshade::addon_event::end_query>(internal::OnEndQuery);
    reshade::unregister_event<reshade::addon_event::barrier>(internal::OnBarrier);
    reshade::unregister_event<reshade::addon_event::execute_command_list>(internal::OnExecuteCommandList);
    reshade::unregister_event<reshade::addon_event::execute_secondary_command_list>(internal::OnExecuteSecondaryCommandList);
    reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);
    reshade::unregister_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
    reshade::unregister_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
    reshade::unregister_event<reshade::addon_event::destroy_command_queue>(internal::OnDestroyCommandQueue);
    reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
  }
}

}  // namespace rdr2vk::swapchain_proxy