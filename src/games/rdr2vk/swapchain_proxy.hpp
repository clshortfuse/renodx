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
#include "./view_lifetime_trace.hpp"

namespace rdr2vk::swapchain_proxy {
namespace internal {

// Both copy shaders leave their input unchanged. They also serve menus, so we only
// count them as scene output when their input came from a known scene shader.
static constexpr std::uint32_t SCENE_BLIT_SHADER = 0x1FC46AC9u;
static constexpr std::uint32_t SCENE_BLIT_MSAA_SHADER = 0xF60E4A26u;
static constexpr std::uint32_t SCENE_FXAA_SHADER = 0x599298B6u;
static constexpr std::uint32_t SCENE_TAA_SHARPEN_SHADER = 0xEF9E7CFCu;

// Declare the Vulkan types used by our hooks here, so building this addon does
// not require the Vulkan SDK headers.
using VkDevice = struct VkDevice_T*;
using VkQueue = struct VkQueue_T*;
using VkCommandBuffer = struct VkCommandBuffer_T*;
using VkSwapchainKHR = struct VkSwapchainKHR_T*;
using VkSemaphore = struct VkSemaphore_T*;
using VkFence = struct VkFence_T*;
using VkResult = std::int32_t;
// We only pass these pointers to the original function; we never read their fields.
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
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
using PFN_vkDestroyImageView = void(WINAPI*)(VkDevice, std::uint64_t, const void*);
static PFN_vkDestroyImageView destroy_image_view = nullptr;
struct VkBufferViewCreateInfo {
  std::uint32_t type;
  const void* next;
  std::uint32_t flags;
  std::uint64_t buffer;
  std::uint32_t format;
  std::uint64_t offset;
  std::uint64_t range;
};
static_assert(sizeof(VkBufferViewCreateInfo) == 56 && offsetof(VkBufferViewCreateInfo, buffer) == 24
              && offsetof(VkBufferViewCreateInfo, offset) == 40);
using PFN_vkCreateBufferView = VkResult(WINAPI*)(VkDevice, const VkBufferViewCreateInfo*, const void*, std::uint64_t*);
static PFN_vkCreateBufferView create_buffer_view = nullptr;
static PFN_vkDestroyImageView destroy_buffer_view = nullptr;
struct VkWriteDescriptorSet {
  std::uint32_t type;
  const void* next;
  std::uint64_t set;
  std::uint32_t binding;
  std::uint32_t element;
  std::uint32_t count;
  std::uint32_t descriptor_type;
  const void* images;
  const void* buffers;
  const std::uint64_t* views;
};
static_assert(sizeof(VkWriteDescriptorSet) == 64 && offsetof(VkWriteDescriptorSet, views) == 56);
using PFN_vkUpdateDescriptorSets = void(WINAPI*)(VkDevice, std::uint32_t, const VkWriteDescriptorSet*, std::uint32_t, const void*);
static PFN_vkUpdateDescriptorSets update_descriptor_sets = nullptr;
using PFN_vkGetFenceStatus = VkResult(WINAPI*)(VkDevice, VkFence);
using PFN_vkWaitForFences = VkResult(WINAPI*)(VkDevice, std::uint32_t, const std::uint64_t*, std::uint32_t, std::uint64_t);
using PFN_vkResetFences = VkResult(WINAPI*)(VkDevice, std::uint32_t, const std::uint64_t*);
static PFN_vkGetFenceStatus get_fence_status = nullptr;
static PFN_vkWaitForFences wait_for_fences = nullptr;
static PFN_vkResetFences reset_fences = nullptr;
#endif
static constexpr VkResult VK_SUCCESS = 0;
static constexpr VkResult VK_SUBOPTIMAL_KHR = 1000001003;
static constexpr std::uint32_t VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT = 2;
static constexpr std::uint32_t VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT = 4;
static_assert(sizeof(void*) == 8 && sizeof(VkCommandBufferBeginInfo) == 32 && sizeof(VkAcquireNextImageInfoKHR) == 56);
static_assert(offsetof(VkCommandBufferBeginInfo, flags) == 16
              && offsetof(VkAcquireNextImageInfoKHR, swapchain) == 16);

struct BackBufferSubmission {
  // Track what has been sent to the GPU for this use of the image. CPU recording
  // order is not reliable: a worker can record the HUD before the scene.
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
  bool scene = false;
  bool ui = false;
  bool brightness = false;
  bool failed = false;

  constexpr bool ApplyRecording(bool scene_write, bool ui_write, bool has_brightness_pass, bool invalid_recording) {
    // Adjust brightness only before the first UI draw after the scene. Reject
    // later scene writes rather than accidentally changing the HUD's brightness.
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
  // Reusing an acquired image must not carry over the previous use's UI flags.
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
  // This fixed-size vector owns the GPU objects. Copying or replacing an entry
  // would duplicate its handles or skip the cleanup that waits for the GPU.
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
  // Keep this list's records separate until we know its GPU submission order.
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

// Keep drawing records with the command list, not the worker thread or CPU frame.
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
  // Scale the decoded scene by Game Brightness / UI Brightness. The final
  // proxy multiplies everything by UI Brightness, leaving the scene at Game
  // Brightness and the HUD at UI Brightness. The shader leaves alpha unchanged.
  // Settings and the enable switch use the same buffer layout from shared.h.
  // Bind them directly instead of taking sets from ReShade's limited pool.
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
    renodx::utils::log::e("rdr2vk: could not draw the scene brightness pass; waiting for the game to recreate its output buffers.");
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

  // Presentation uses the game's semaphores. Wait for the queue only during
  // cleanup, not during normal frames or error handling. Release registry locks first.
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

  // The earlier device-init callback already set the shaders and configuration.
  // Do not hold the shared swapchain lock while looking up texture information.
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

  // Create the clones before rendering workers can request them while recording
  // a pass. The shared code still owns them and frees them with their backbuffers.
  // Check every backbuffer first, and do not hold registry or state locks here.
  for (std::uint32_t index = 0; index < back_buffer_count; ++index) {
    auto& buffer = state->back_buffers[index];
    const auto clone = renodx::utils::resource::upgrade::GetResourceClone(buffer.back_buffer);
    if (clone.handle == 0) {
      renodx::utils::log::e("rdr2vk::swapchain_proxy: could not create the HDR backbuffer clone; index=", index);
      RetireSwapchain(state);
      return;
    }
    // This image's size and format will not change. Check them before drawing.
    bool valid_clone = false;
    renodx::utils::resource::GetLiveResourceInfo(clone, [&](const auto& info) {
      valid_clone = info.device == device && info.is_clone && info.fallback == buffer.back_buffer
                    && info.desc.type == reshade::api::resource_type::texture_2d
                    && info.desc.texture.format == reshade::api::format::r16g16b16a16_float
                    && info.desc.texture.width == width && info.desc.texture.height == height
                    && info.desc.texture.depth_or_layers == 1 && info.desc.texture.samples == 1;
    });
    if (!valid_clone) {
      renodx::utils::log::e("rdr2vk::swapchain_proxy: HDR backbuffer clone has the wrong size, format, or owner; index=", index);
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
    // RenderPass owns and frees these views, even if a later setup step fails.
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
    // A disabled pass writes no pixels. Use LOAD to keep the existing menu/UI
    // color and alpha instead of discarding them when the pass starts.
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
    // A secondary list can draw inside another list's pass only with CONTINUE.
    // Without that flag, a later begin_render_pass starts this list's own pass.
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
  // We can pause a pass for scene brightness only if it has one color target.
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
    // Copy shaders and TAA sharpening read the finished scene from different bindings.
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

    // The saved binding may refer to a view that was already freed. Read our
    // live records, not the driver. Missing records cannot prove this is the scene.
    reshade::api::resource source = {};
    renodx::utils::resource::GetLiveResourceViewInfo(source_view, [&](const auto& info) {
      if (info.device != device || info.desc.type == reshade::api::resource_view_type::buffer) return;
      source = (info.is_clone ? info.clone_resource : info.original_resource);
    });
    if (source.handle == 0) return {};
    bool live_source = false;
    renodx::utils::resource::GetLiveResourceInfo(source, [&](const auto& info) {
      live_source = info.device == device && info.desc.type == reshade::api::resource_type::texture_2d;
    });
    if (!live_source) return {};
    // Count scene output only when drawing to the backbuffer. Unlike the saved
    // source_view above, this target is bound to the current render pass.
    const auto target = device->get_resource_from_view(recording->target->view);
    const auto owner = FindBackBuffer(device, *recording, target);
    if (owner.state == nullptr) return {};
    auto* buffer = GetRecordedBackBuffer(recording, owner);
    if (buffer == nullptr) return {};
    // Remember which texture this copy reads. Submission order tells us whether
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
    // Some menu and mask passes cannot be paused safely. A missing brightness
    // pass is an error only if submission order puts it after scene drawing.
    return true;
  }

  // The generic restore code also rebinds render targets, which Vulkan cannot do
  // this way. Save the graphics state, but resume the render pass ourselves.
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
    renodx::utils::log::e("rdr2vk: the UI is not drawing to the expected HDR backbuffer clone.");
    return true;
  }
  target.load_op = reshade::api::render_pass_load_op::load;
  // LOAD keeps the existing pixels, so clear values are unused. ReShade's
  // legacy Vulkan cache still hashes them; keep them fixed instead of creating
  // a new render pass and framebuffer whenever the game's clear color changes.
  std::ranges::fill(target.clear_color, 0.f);
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
    depth->clear_depth = 0.f;
    depth->clear_stencil = 0;
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
      renodx::utils::log::e("rdr2vk: could not create the shader settings buffer for this command list.");
      return true;
    }
    injection.data = static_cast<ShaderInjectData*>(mapped);
  }
  // Each recording needs its own settings copy. Several workers may record UI
  // starts; submission order chooses which copy enables its brightness pass.
  auto* injection = &recording->shader_injections[recording->used_injections++];
  *injection->data = *settings;
  injection->data->scene_brightness_enabled = 0.f;

  // Apply any queued clear before copying the scene. Resume the game's pass
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
  // Vulkan can reuse a freed texture's handle. Do not mistake the new texture
  // for scene color just because the old texture held it.
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
    // Check this list's copies before saving its scene outputs. A later scene
    // write must not make an earlier menu copy look like scene output.
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
        renodx::utils::log::e("rdr2vk: the queue-submit hook did not record this Vulkan submission.");
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

    // Do not adjust brightness for an old or unsafe recording.
    const bool stale_recording = recorded.acquisition_id == 0 || recorded.acquisition_id != buffer.acquisition_id;
    const bool scene_after_ui = scene && submitted->ui;
    const bool queue_changed = state->queue != nullptr && state->queue != queue;
    const bool repeated_recording = recorded.brightness != nullptr && recorded.brightness->data->scene_brightness_enabled != 0.f;
    const bool first_scene_ui = recorded.ui && (submitted->scene || scene) && !submitted->ui;
    const bool has_brightness_pass = recorded.brightness_not_required || recorded.brightness != nullptr;
    const bool invalid_recording = stale_recording || recorded.late_scene
                                   || (scene && recorded.scene_source_after_ui)
                                   || queue_changed || repeated_recording;

    // Enable only the brightness pass before the first UI draw after the scene.
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
            "rdr2vk: cannot safely separate scene and UI brightness for this submission; backbuffer=", renodx::utils::log::AsPtr(buffer.back_buffer.handle),
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
            ". Skipping scene brightness for this use of the image.");
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
      // ReShade's earlier callback does not mean Vulkan accepted the submission.
      buffer.submitted.failed = true;
    }
  }
}

static VkResult WINAPI QueueSubmit(VkQueue queue, std::uint32_t count, const VkSubmitInfo* submits, VkFence fence) {
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  const auto request = ++view_lifetime_trace::next_request;
  const auto fence_handle = reinterpret_cast<std::uint64_t>(fence);
  view_lifetime_trace::RecordSync("submit_enter", 0, reinterpret_cast<std::uint64_t>(queue), request, 0, 1, &fence_handle);
#endif
  std::vector<PendingBackBuffer> pending;
  auto* outer = std::exchange(pending_submissions, &pending);
  const auto result = queue_submit(queue, count, submits, fence);
  pending_submissions = outer;
  CommitBackBuffers(pending, result);
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  view_lifetime_trace::RecordSync("submit_return", 0, reinterpret_cast<std::uint64_t>(queue), request, result, 1, &fence_handle);
#endif
  return result;
}

static VkResult WINAPI QueueSubmit2(VkQueue queue, std::uint32_t count, const VkSubmitInfo2* submits, VkFence fence) {
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  const auto request = ++view_lifetime_trace::next_request;
  const auto fence_handle = reinterpret_cast<std::uint64_t>(fence);
  view_lifetime_trace::RecordSync("submit2_enter", 0, reinterpret_cast<std::uint64_t>(queue), request, 0, 1, &fence_handle);
#endif
  std::vector<PendingBackBuffer> pending;
  auto* outer = std::exchange(pending_submissions, &pending);
  const auto result = queue_submit2(queue, count, submits, fence);
  pending_submissions = outer;
  CommitBackBuffers(pending, result);
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  view_lifetime_trace::RecordSync("submit2_return", 0, reinterpret_cast<std::uint64_t>(queue), request, result, 1, &fence_handle);
#endif
  return result;
}

static void OnAcquireBackBuffer(VkSwapchainKHR swapchain, std::uint32_t index) {
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  view_lifetime_trace::RecordSync("acquire", 0, reinterpret_cast<std::uint64_t>(swapchain), 0, 0, index);
#endif
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
  // This call can return before the GPU semaphore signals. Leave mapped shader
  // data with its command list; acquiring an image does not make that data safe to reuse.
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

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
static void WINAPI DestroyImageView(VkDevice device, std::uint64_t view, const void* allocator) {
  // Record both sides so a missing return can locate a crash inside the call.
  // Always call the real function, even if our records say the view was freed.
  const auto outer = view_lifetime_trace::BeginDestroy("vulkan_destroy_enter", reinterpret_cast<std::uint64_t>(device), view);
  destroy_image_view(device, view, allocator);
  view_lifetime_trace::EndDestroy("vulkan_destroy_return", reinterpret_cast<std::uint64_t>(device), view, outer);
}

static VkResult WINAPI CreateBufferView(VkDevice device, const VkBufferViewCreateInfo* info,
                                        const void* allocator, std::uint64_t* view) {
  // Save the old output bytes without treating them as a valid view. A failed
  // replacement may leave an older handle in the game's saved output location.
  std::uint64_t previous_output = 0;
  SIZE_T previous_bytes = 0;
  if (view != nullptr) {
    ReadProcessMemory(GetCurrentProcess(), view, &previous_output, sizeof(previous_output), &previous_bytes);
  }
  const auto outer = std::exchange(view_lifetime_trace::native_call,
                                   view_lifetime_trace::NativeCall{.request = ++view_lifetime_trace::next_request, .creating = true});
  view_lifetime_trace::Record("buffer_create_enter", reinterpret_cast<std::uint64_t>(device), 0);
  const auto result = create_buffer_view(device, info, allocator, view);
  if (result == VK_SUCCESS && info != nullptr && view != nullptr) {
    view_lifetime_trace::Record("buffer_create_return", reinterpret_cast<std::uint64_t>(device), *view,
                                info->buffer, 0, 0, false, false, info->format, info->offset, info->range);
  } else if (result != VK_SUCCESS) {
    // A failed call does not return a valid view. Save its output bytes only
    // for the report; never pass them to Vulkan as a view.
    std::uint64_t returned_output = 0;
    SIZE_T returned_bytes = 0;
    if (view != nullptr) {
      ReadProcessMemory(GetCurrentProcess(), view, &returned_output, sizeof(returned_output), &returned_bytes);
    }
    {
      std::unique_lock lock(view_lifetime_trace::trace.mutex);
      // Save up to 16 creation failures, independently of the other report limits.
      if (view_lifetime_trace::trace.failure_reports < 16) {
        ++view_lifetime_trace::trace.failure_reports;
        if (view_lifetime_trace::trace.failure_reports == 1) {
          // Resource callbacks can take the trace lock. Release it before
          // scanning their registries, then reacquire it only for file output.
          lock.unlock();
          // Read existing records only after an allocation fails. Do not add a
          // second per-frame history just to measure the mod's resource use.
          std::uint64_t live_resources = 0;
          std::uint64_t live_buffers = 0;
          std::uint64_t buffer_bytes = 0;
          std::uint64_t upload_buffers = 0;
          std::uint64_t upload_bytes = 0;
          std::uint64_t live_textures = 0;
          std::uint64_t texture_bytes = 0;
          std::uint64_t upgraded_textures = 0;
          std::uint64_t cloned_textures = 0;
          std::uint64_t live_views = 0;
          std::uint64_t buffer_views = 0;
          std::uint64_t cloned_views = 0;
          if (renodx::utils::resource::shared.data != nullptr) {
            renodx::utils::resource::shared.data->resource_infos.for_each([&](const auto& entry) {
              const auto& [handle, info] = entry;
              if (info.destroyed || info.device == nullptr
                  || info.device->get_native() != reinterpret_cast<std::uint64_t>(device)) return;
              ++live_resources;
              if (info.desc.type == reshade::api::resource_type::buffer) {
                ++live_buffers;
                buffer_bytes += info.desc.buffer.size;
                if (info.desc.heap == reshade::api::memory_heap::cpu_to_gpu) {
                  ++upload_buffers;
                  upload_bytes += info.desc.buffer.size;
                }
              } else if (info.desc.type == reshade::api::resource_type::texture_2d
                         || info.desc.type == reshade::api::resource_type::texture_3d
                         || info.desc.type == reshade::api::resource_type::surface) {
                ++live_textures;
                texture_bytes += renodx::utils::resource::ComputeTextureSize(info.desc);
                upgraded_textures += info.upgraded;
                cloned_textures += info.is_clone;
              }
            });
            renodx::utils::resource::shared.data->resource_view_infos.for_each([&](const auto& entry) {
              const auto& [handle, info] = entry;
              if (info.destroyed || info.device == nullptr
                  || info.device->get_native() != reinterpret_cast<std::uint64_t>(device)) return;
              ++live_views;
              buffer_views += info.desc.type == reshade::api::resource_view_type::buffer;
              cloned_views += info.is_clone;
            });
          }
          std::array<char, 768> totals = {};
          snprintf(totals.data(), totals.size(),
                   "allocation_snapshot resources=%llu buffers=%llu buffer_bytes=%llu upload_buffers=%llu upload_bytes=%llu textures=%llu estimated_texture_bytes=%llu upgraded_textures=%llu cloned_textures=%llu views=%llu buffer_views=%llu cloned_views=%llu\n",
                   live_resources, live_buffers, buffer_bytes, upload_buffers, upload_bytes, live_textures,
                   texture_bytes, upgraded_textures, cloned_textures, live_views, buffer_views, cloned_views);
          lock.lock();
          view_lifetime_trace::WriteText(totals.data());
        }
        std::array<char, 768> line = {};
        snprintf(line.data(), line.size(),
                 "\nBUFFER_CREATE_FAILURE request=%llu thread=%lu result=%d device=%llx output_slot=%p before=%llx before_bytes=%llu after=%llx after_bytes=%llu buffer=%llx format=%u offset=%llx range=%llx\n",
                 view_lifetime_trace::native_call.request, GetCurrentThreadId(), result,
                 reinterpret_cast<std::uint64_t>(device), view, previous_output,
                 static_cast<unsigned long long>(previous_bytes), returned_output,
                 static_cast<unsigned long long>(returned_bytes), (info != nullptr ? info->buffer : 0),
                 (info != nullptr ? info->format : 0), (info != nullptr ? info->offset : 0),
                 (info != nullptr ? info->range : 0));
        view_lifetime_trace::WriteText(line.data());
        view_lifetime_trace::Evidence caller = {.sequence = view_lifetime_trace::trace.sequence + 1};
        caller.frames = CaptureStackBackTrace(0, static_cast<DWORD>(caller.stack.size()), caller.stack.data(), nullptr);
        view_lifetime_trace::WriteEvidence("failed_create_caller", caller);
        view_lifetime_trace::WriteCallerCode(caller);
        view_lifetime_trace::WriteSyncHistory();
        if (view_lifetime_trace::trace.file != INVALID_HANDLE_VALUE) {
          FlushFileBuffers(view_lifetime_trace::trace.file);
        }
      }
    }
  }
  view_lifetime_trace::native_call = outer;
  return result;
}

static void WINAPI DestroyBufferView(VkDevice device, std::uint64_t view, const void* allocator) {
  // The captured crash tried to free the same buffer view twice. Block a repeat
  // only when we recorded its creation and the completed first destroy call.
  if (view_lifetime_trace::SuppressCompletedBufferDestroy(reinterpret_cast<std::uint64_t>(device), view)) return;
  const auto outer = view_lifetime_trace::BeginDestroy("buffer_destroy_enter", reinterpret_cast<std::uint64_t>(device), view);
  destroy_buffer_view(device, view, allocator);
  view_lifetime_trace::EndDestroy("buffer_destroy_return", reinterpret_cast<std::uint64_t>(device), view, outer);
}

static void WINAPI UpdateDescriptorSets(VkDevice device, std::uint32_t count, const VkWriteDescriptorSet* writes,
                                        std::uint32_t copy_count, const void* copies) {
  LARGE_INTEGER counter = {};
  QueryPerformanceCounter(&counter);
  view_lifetime_trace::DescriptorBatch batch = {
      .request = ++view_lifetime_trace::next_request,
      .device = reinterpret_cast<std::uint64_t>(device),
      .counter = counter.QuadPart,
      .writes_address = reinterpret_cast<std::uint64_t>(writes),
      .writes = count,
      .copies = copy_count,
  };
  auto* outer_batch = std::exchange(view_lifetime_trace::active_descriptor_batch, &batch);
  const auto outer_call = std::exchange(view_lifetime_trace::native_call,
                                        view_lifetime_trace::NativeCall{.request = batch.request});
  {
    const std::unique_lock lock(view_lifetime_trace::trace.mutex);
    if (++view_lifetime_trace::trace.descriptor_updates == 1) {
      view_lifetime_trace::WriteText("coverage: native descriptor batch observed\n");
    }
  }
  // Save the input handles before checking histories or calling ReShade. Keep
  // this local copy available to the exception observer until the call returns.
  for (std::uint32_t index = 0; index < count && writes != nullptr; ++index) {
    const auto& write = writes[index];
    // Vulkan descriptor types 4/5 are uniform/storage texel-buffer views.
    if ((write.descriptor_type != 4 && write.descriptor_type != 5) || write.views == nullptr) continue;
    for (std::uint32_t element = 0; element < write.count; ++element) {
      ++batch.references;
      if (batch.captured == batch.inputs.size()) continue;
      batch.inputs[batch.captured++] = {
          .view = write.views[element],
          .descriptor_set = write.set,
          .input_address = reinterpret_cast<std::uint64_t>(write.views + element),
          .binding = write.binding,
          .element = write.element + element,
          .type = write.descriptor_type,
      };
    }
  }
  batch.phase = 1;
  for (std::uint32_t index = 0; index < count && writes != nullptr; ++index) {
    const auto& write = writes[index];
    if ((write.descriptor_type != 4 && write.descriptor_type != 5) || write.views == nullptr) continue;
    for (std::uint32_t element = 0; element < write.count; ++element) {
      view_lifetime_trace::Record("descriptor_reference", batch.device, write.views[element], write.set,
                                  0, 0, false, false, write.descriptor_type, write.binding, write.element + element);
    }
  }
  batch.phase = 2;
  update_descriptor_sets(device, count, writes, copy_count, copies);
  for (std::uint32_t index = 0; index < batch.captured; ++index) {
    const auto& reference = batch.inputs[index];
    view_lifetime_trace::Record("descriptor_return", batch.device, reference.view, reference.descriptor_set,
                                0, 0, false, false, reference.type, reference.binding, reference.element);
  }
  view_lifetime_trace::native_call = outer_call;
  view_lifetime_trace::active_descriptor_batch = outer_batch;
}

static VkResult WINAPI GetFenceStatus(VkDevice device, VkFence fence) {
  const auto result = get_fence_status(device, fence);
  view_lifetime_trace::RecordSync("fence_status", reinterpret_cast<std::uint64_t>(device),
                                  reinterpret_cast<std::uint64_t>(fence), 0, result);
  return result;
}

static VkResult WINAPI WaitForFences(VkDevice device, std::uint32_t count, const std::uint64_t* fences,
                                     std::uint32_t wait_all, std::uint64_t timeout) {
  const auto request = ++view_lifetime_trace::next_request;
  view_lifetime_trace::RecordSync("wait_enter", reinterpret_cast<std::uint64_t>(device), wait_all, request, 0, count, fences);
  const auto result = wait_for_fences(device, count, fences, wait_all, timeout);
  view_lifetime_trace::RecordSync("wait_return", reinterpret_cast<std::uint64_t>(device), wait_all, request, result, count, fences);
  return result;
}

static VkResult WINAPI ResetFences(VkDevice device, std::uint32_t count, const std::uint64_t* fences) {
  const auto request = ++view_lifetime_trace::next_request;
  view_lifetime_trace::RecordSync("reset_enter", reinterpret_cast<std::uint64_t>(device), 0, request, 0, count, fences);
  const auto result = reset_fences(device, count, fences);
  view_lifetime_trace::RecordSync("reset_return", reinterpret_cast<std::uint64_t>(device), 0, request, result, count, fences);
  return result;
}
#endif

static void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::vulkan || !lifecycle_hooks.empty()) return;
  const auto get = reinterpret_cast<PFN_vkGetDeviceProcAddr>(
      GetProcAddress(reshade::internal::get_reshade_module_handle(), "vkGetDeviceProcAddr"));
  if (get == nullptr) {
    renodx::utils::log::e("rdr2vk: could not find ReShade's Vulkan function lookup.");
    return;
  }
  auto* const native = std::bit_cast<VkDevice>(device->get_native());
  acquire_next_image = reinterpret_cast<PFN_vkAcquireNextImageKHR>(get(native, "vkAcquireNextImageKHR"));
  acquire_next_image2 = reinterpret_cast<PFN_vkAcquireNextImage2KHR>(get(native, "vkAcquireNextImage2KHR"));
  begin_command_buffer = reinterpret_cast<PFN_vkBeginCommandBuffer>(get(native, "vkBeginCommandBuffer"));
  queue_submit = reinterpret_cast<PFN_vkQueueSubmit>(get(native, "vkQueueSubmit"));
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  destroy_image_view = reinterpret_cast<PFN_vkDestroyImageView>(get(native, "vkDestroyImageView"));
  create_buffer_view = reinterpret_cast<PFN_vkCreateBufferView>(get(native, "vkCreateBufferView"));
  destroy_buffer_view = reinterpret_cast<PFN_vkDestroyImageView>(get(native, "vkDestroyBufferView"));
  update_descriptor_sets = reinterpret_cast<PFN_vkUpdateDescriptorSets>(get(native, "vkUpdateDescriptorSets"));
  get_fence_status = reinterpret_cast<PFN_vkGetFenceStatus>(get(native, "vkGetFenceStatus"));
  wait_for_fences = reinterpret_cast<PFN_vkWaitForFences>(get(native, "vkWaitForFences"));
  reset_fences = reinterpret_cast<PFN_vkResetFences>(get(native, "vkResetFences"));
#endif
  queue_submit2 = reinterpret_cast<PFN_vkQueueSubmit2>(get(native, "vkQueueSubmit2"));
  if (queue_submit2 == nullptr) {
    queue_submit2 = reinterpret_cast<PFN_vkQueueSubmit2>(get(native, "vkQueueSubmit2KHR"));
  }
  if (acquire_next_image == nullptr || begin_command_buffer == nullptr || queue_submit == nullptr) {
    renodx::utils::log::e("rdr2vk: required Vulkan acquire, command-buffer begin, or queue-submit functions are missing.");
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
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  if (destroy_image_view != nullptr) {
    lifecycle_hooks.emplace_back(&destroy_image_view, DestroyImageView);
  }
  if (update_descriptor_sets != nullptr) {
    lifecycle_hooks.emplace_back(&update_descriptor_sets, UpdateDescriptorSets);
  }
  if (get_fence_status != nullptr && wait_for_fences != nullptr && reset_fences != nullptr) {
    lifecycle_hooks.emplace_back(&get_fence_status, GetFenceStatus);
    lifecycle_hooks.emplace_back(&wait_for_fences, WaitForFences);
    lifecycle_hooks.emplace_back(&reset_fences, ResetFences);
  } else {
    renodx::utils::log::w("rdr2vk: could not record native fence calls; the synchronization history will be incomplete.");
  }
  if (create_buffer_view != nullptr && destroy_buffer_view != nullptr) {
    lifecycle_hooks.emplace_back(&create_buffer_view, CreateBufferView);
    lifecycle_hooks.emplace_back(&destroy_buffer_view, DestroyBufferView);
  } else {
    renodx::utils::log::e("rdr2vk: could not find the buffer-view functions; some crash details cannot be recorded.");
  }
#endif
  try {
    renodx::utils::detour::Install(lifecycle_hooks);
  } catch (const std::system_error& error) {
    lifecycle_hooks.clear();
    renodx::utils::log::e("rdr2vk: could not install the Vulkan tracking hooks; error=", error.code().value());
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
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  view_lifetime_trace::RecordSync("present", device->get_native(), queue->get_native(), 0);
#endif

  // Keep the shared fullscreen handling. Do not hold our state locks while it runs.
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
  // Setup already created the clone. Do not create or retry it during presentation.
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
    // Failed setup may still have recorded GPU commands. Keep its objects alive
    // until cleanup waits for the queue, instead of retrying each frame.
    fail("could not draw the final HDR output");
  }
  // The next image use starts when Vulkan gives it to the game, not at presentation.
}

static void OnDestroyCommandQueue(reshade::api::command_queue* queue) {
  // Copy the shared pointers first. Do not wait for a state lock while holding a registry lock.
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
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  {
    const std::unique_lock lock(view_lifetime_trace::trace.mutex);
    if (view_lifetime_trace::trace.views != nullptr) {
      for (auto& entry : *view_lifetime_trace::trace.views) {
        if (entry.device == device->get_native()) {
          entry = {};
        }
      }
    }
  }
#endif
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
      renodx::utils::log::e("rdr2vk::swapchain_proxy: the device was destroyed before the output queue was cleaned up.");
    }
    // The queue wrappers are already gone. GPU cleanup belongs in
    // destroy_swapchain/destroy_command_queue; do not call the driver here.
    state->closing = true;
    state->queue = nullptr;
    state->back_buffers.clear();
  }
}

}  // namespace internal

using internal::OnBeforeUIDraw;
using internal::OnSceneDrawn;

static void Use(DWORD reason) {
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  view_lifetime_trace::Use(reason);
#endif
  if (reason == DLL_PROCESS_ATTACH) {
    renodx::utils::descriptor::trace_descriptor_tables = true;
    renodx::utils::descriptor::Use(reason);
    // Keep the shared swapchain and clone setup. Replace only our final output callback.
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
        renodx::utils::log::e("rdr2vk: could not remove the Vulkan tracking hooks; error=", error.code().value());
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