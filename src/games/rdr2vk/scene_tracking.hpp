/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <windows.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <deque>
#include <iterator>
#include <memory_resource>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "../../utils/command_action.hpp"
#include "../../utils/data.hpp"
#include "../../utils/descriptor.hpp"
#include "../../utils/log.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/state.hpp"
#include "./output.hpp"
#include "./shared.h"
#include "./vulkan_types.hpp"

namespace rdr2vk::scene_tracking {

// Copy shaders also serve menus. Their input must be a known scene source;
// FXAA is known scene output, while TAA sharpening needs the same source check.
static constexpr std::uint32_t SCENE_BLIT_SHADER = 0x1FC46AC9u;
static constexpr std::uint32_t SCENE_BLIT_MSAA_SHADER = 0xF60E4A26u;
static constexpr std::uint32_t SCENE_FXAA_SHADER = 0x599298B6u;
static constexpr std::uint32_t SCENE_TAA_SHARPEN_SHADER = 0xEF9E7CFCu;

// One native submission accumulates tentative image-use facts in callback order.
// The owner keeps CPU storage alive, not GPU objects; use its lock and identity
// checks before accessing output. selected borrows a command-list-owned upload.
struct PendingBackBuffer {
  output::BackBufferReference owner;
  std::uint64_t acquisition_id;
  output::AcceptedDraws submitted;
  output::SettingsUpload* selected = nullptr;
  std::vector<reshade::api::resource> scene_resources;
};

namespace internal {

// ReShade reports command lists before the native submit result is known.
// Only the scopes below replace these pointers/flags, including nested calls.
static thread_local std::vector<PendingBackBuffer>* pending_submissions = nullptr;
static thread_local std::optional<std::uint32_t> command_buffer_flags;

}  // namespace internal

// Keep alive around the original QueueSubmit/QueueSubmit2 call. Both wrappers
// publish pending with accepted == (result == VK_SUCCESS). Success means the
// queue accepted the work, not that the GPU finished or uploads can be reused.
class SubmissionScope {
 public:
  std::vector<PendingBackBuffer> pending;

  SubmissionScope() : outer(std::exchange(internal::pending_submissions, &pending)) {}
  ~SubmissionScope() { internal::pending_submissions = outer; }
  SubmissionScope(const SubmissionScope&) = delete;
  SubmissionScope& operator=(const SubmissionScope&) = delete;
  SubmissionScope(SubmissionScope&&) = delete;
  SubmissionScope& operator=(SubmissionScope&&) = delete;

 private:
  std::vector<PendingBackBuffer>* outer;
};

// BeginCommandBuffer can synchronously report a recording reset through ReShade.
// Preserve the enclosing call's flags rather than leaking a nested begin's flags.
class RecordingScope {
 public:
  explicit RecordingScope(std::optional<std::uint32_t> flags)
      : outer(std::exchange(internal::command_buffer_flags, flags)) {}
  ~RecordingScope() { internal::command_buffer_flags = outer; }
  RecordingScope(const RecordingScope&) = delete;
  RecordingScope& operator=(const RecordingScope&) = delete;
  RecordingScope(RecordingScope&&) = delete;
  RecordingScope& operator=(RecordingScope&&) = delete;

 private:
  std::optional<std::uint32_t> outer;
};

namespace internal {

// Recording facts and settings uploads ----------------------------------------

struct RecordedBackBuffer {
  // Recorded is not completed, or even accepted. Keep each list's facts separate
  // until submission order is known. Preserve this embedded private-data layout.
  output::BackBufferReference owner;
  reshade::api::resource scene_source = {0};
  bool scene_source_after_ui = false;
  bool scene_source_local = false;
  std::uint64_t acquisition_id = 0;
  output::SettingsUpload* brightness = nullptr;
  bool brightness_not_required = false;
  bool scene = false;
  bool ui = false;
  bool late_scene = false;
  std::uint32_t ui_shader = 0;
  std::uint32_t late_scene_shader = 0;
  bool late_scene_from_secondary = false;
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
};

// A command list records GPU instructions; workers can record out of submit order.
// Keep the original UUID, field order, and embedded layouts. The deque owns the
// mapped uploads and keeps borrowed brightness/selected pointers stable as it grows.
// Only a legal command-list reset permits reuse; image acquisition does not.
struct __declspec(uuid("3d714413-6741-470a-b0a8-6d443d0c7dbe")) CommandListData {
  std::optional<reshade::api::render_pass_render_target_desc> target;
  std::optional<reshade::api::render_pass_depth_stencil_desc> depth;
  std::vector<RecordedBackBuffer> back_buffers;
  std::deque<output::SettingsUpload> shader_injections;
  std::size_t used_injections = 0;
  bool can_suspend = false;
  std::uint32_t active_queries = 0;
  std::vector<reshade::api::resource> scene_resources;
};

struct PipelineColorWrites {
  reshade::api::device* device;
  std::optional<std::uint8_t> mask;
  bool dynamic = false;
};
static renodx::utils::data::ParallelFlatHashMap<
    std::uint64_t, PipelineColorWrites, std::shared_mutex>
    pipeline_color_writes;

static output::BackBufferReference FindBackBuffer(
    reshade::api::device* device, const CommandListData& recording, reshade::api::resource resource) {
  for (const auto& recorded : recording.back_buffers) {
    if (recorded.owner.original != resource && recorded.owner.clone != resource) continue;
    const std::shared_lock lock(recorded.owner.state->mutex);
    if (!recorded.owner.state->closing) return recorded.owner;
  }
  // Copy CPU owners before taking state locks. Keeping an owner alive does not
  // keep retired GPU objects alive, so closing is checked under that lock.
  // Offscreen draws can repeat this miss. Keep the temporary owner snapshot on
  // the stack for up to four swapchains, with allocation rather than truncation
  // if a device has more. No owner is cached across calls.
  alignas(output::SwapchainEntry) std::array<std::byte, sizeof(output::SwapchainEntry) * 4> owner_bytes;
  std::pmr::monotonic_buffer_resource owner_storage(owner_bytes.data(), owner_bytes.size());
  for (const auto& [swapchain, state] : output::GetDeviceSwapchains(device, &owner_storage)) {
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

static RecordedBackBuffer* GetRecordedBackBuffer(CommandListData* recording, const output::BackBufferReference& owner) {
  for (auto& buffer : recording->back_buffers) {
    if (buffer.owner.state == owner.state && buffer.owner.index == owner.index) return &buffer;
  }
  const std::shared_lock lock(owner.state->mutex);
  if (owner.state->closing || owner.index >= owner.state->back_buffers.size()) return nullptr;
  recording->back_buffers.push_back({.owner = owner, .acquisition_id = owner.state->back_buffers[owner.index].acquisition_id});
  return &recording->back_buffers.back();
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
    // The game must finish using a list before resetting it. Retain its mapped
    // uploads here; destroy them only with the command list, never at acquisition.
    // CONTINUE inherits another list's pass; simultaneous use cannot safely select
    // one mapped enable value. Without these flags a later begin owns its pass.
    recording->can_suspend = command_buffer_flags.has_value()
                             && (*command_buffer_flags & (vulkan::VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT | vulkan::VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT)) == 0;
    recording->active_queries = 0;
  }
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list); recording != nullptr) {
    for (auto& injection : recording->shader_injections) {
      output::DestroySettingsUpload(cmd_list->get_device(), &injection);
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
  // A render pass groups draws with color/depth/stencil targets. We can interrupt
  // only a single-color-target pass, preserving depth distances and stencil masks.
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

// Identifying scene and UI targets --------------------------------------------

// The addon also uses this post-draw callback for its scene shader replacements.
// It observes CPU recording, not completed pixels. Shader roles stay in addon:
// 0xFCD82342 is UI; 0x2C748C70 is scene composition, not a UI boundary.
static void OnSceneDrawRecorded(reshade::api::command_list* cmd_list) {
  auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (recording == nullptr) return;
  if (!recording->target.has_value()) return;
  const auto resource = cmd_list->get_device()->get_resource_from_view(recording->target->view);
  if (resource.handle == 0) return;
  if (std::ranges::find(recording->scene_resources, resource) == recording->scene_resources.end()) {
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
    // A descriptor binding identifies the view sampled by a shader, not owned
    // texture storage. Copy and TAA shaders use different source bindings.
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
      if (found != descriptors->heaps.end()) {
        const auto& [heap_handle, entries] = *found;
        if (offset < entries.size() && entries[offset].HasResourceView()) {
          source_view = entries[offset].resource_view;
        }
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
    // Unlike the saved source view, this target is bound to the current pass.
    // Offscreen pause copies must not become backbuffer scene/UI boundaries.
    const auto target = device->get_resource_from_view(recording->target->view);
    const auto owner = FindBackBuffer(device, *recording, target);
    if (owner.state == nullptr) return {};
    auto* buffer = GetRecordedBackBuffer(recording, owner);
    if (buffer == nullptr) return {};
    // An earlier submitted list may produce this source. Recording timestamps
    // cannot establish that order, so defer that decision until submission.
    buffer->scene_source = source;
    buffer->scene_source_after_ui = buffer->ui;
    buffer->scene_source_local = std::ranges::find(recording->scene_resources, source) != recording->scene_resources.end();
    buffer->usage = reshade::api::resource_usage::render_target;
    return {};
  }
  // FXAA is already a known scene output. Observe it after recording the draw.
  return {.post_callback = [](Context& recorded, const void*) { OnSceneDrawRecorded(recorded.cmd_list); }};
};

// Pre-UI brightness and graphics restoration ----------------------------------

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
            const auto& [dynamic_state, write_mask] = *value;
            color_write_mask = static_cast<std::uint8_t>(write_mask);
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

  // This snapshot saves graphics configuration, not pixels. Generic restoration
  // also rebinds targets, which Vulkan cannot do this way: resume the pass here.
  // Keep the existing API-18 dynamic-offset replay limits; this is not a repair.
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
      output::DestroySettingsUpload(device, &injection);
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

  // Finish pending clears before copying. The barrier orders GPU depth/stencil
  // access, not CPU completion. Resume with LOAD and restore graphics before UI.
  renodx::utils::resource::upgrade::HandlePendingRenderPassRenderTargets(cmd_list);
  cmd_list->end_render_pass();
  if (depth_resource.handle != 0) {
    cmd_list->barrier(depth_resource, reshade::api::resource_usage::depth_stencil, reshade::api::resource_usage::depth_stencil);
  }
  if (output::RenderSceneBrightness(cmd_list, &buffer, reshade::api::resource_usage::render_target, injection)) {
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

// Secondary command lists and submission order --------------------------------

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
      buffer->scene_source_local = child.scene_source_local
                                   || std::ranges::find(recording->scene_resources, child.scene_source) != recording->scene_resources.end();
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
    // Preserve the existing limit: merge UI facts, not the child's brightness
    // upload. An inherited pass cannot be interrupted safely by this algorithm.
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

static void OnExecuteCommandList(reshade::api::command_queue* queue, reshade::api::command_list* cmd_list) {
  auto* recording = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (recording == nullptr) return;
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
                           && std::ranges::find(pending_buffer->scene_resources, recorded.scene_source)
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
    const bool enable = submitted->ApplyRecording({
        .scene_write = scene,
        .ui_write = recorded.ui,
        .has_brightness_pass = has_brightness_pass && !buffer.scene_failed,
        .invalid_recording = invalid_recording,
    });
    if (recorded.brightness != nullptr) {
      recorded.brightness->data->scene_brightness_enabled = (enable ? 1.f : 0.f);
      if (enable) {
        pending_buffer->selected = recorded.brightness;
      }
    }
    // A later failure disables a pass selected earlier in this submission, not
    // one already accepted in a previous submission. Accepted is not completed.
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

  // Check this list's copies before saving its scene outputs. A later scene
  // write must not make an earlier menu copy look like scene output.
  if (pending_submissions == nullptr || recording->scene_resources.empty()) return;
  // Snapshot owners without a heap allocation for the usual one-swapchain case.
  // More than four owners can spill to the standard allocator, never truncate.
  // The arena and copied owners live only for this call, including nested calls.
  alignas(output::SwapchainEntry) std::array<std::byte, sizeof(output::SwapchainEntry) * 4> owner_bytes;
  std::pmr::monotonic_buffer_resource owner_storage(owner_bytes.data(), owner_bytes.size());
  for (const auto& [swapchain, state] : output::GetDeviceSwapchains(cmd_list->get_device(), &owner_storage)) {
    const std::unique_lock lock(state->mutex);
    if (state->closing) continue;
    for (std::uint32_t index = 0; index < state->back_buffers.size(); ++index) {
      auto& image = state->back_buffers[index];
      auto found = std::ranges::find_if(*pending_submissions, [&](const auto& pending) {
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
        if (std::ranges::find(found->scene_resources, resource) == found->scene_resources.end()) {
          found->scene_resources.push_back(resource);
        }
      }
    }
  }
}

// Output owns resource destruction and registry cleanup. This callback retires
// only device-specific pipeline classification; it never releases GPU objects.
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
}

}  // namespace internal

using internal::OnBeforeUIDraw;
using internal::OnSceneDrawRecorded;

// Called once by either native submit wrapper after its original call returns.
// Rejection marks failure but does not publish tentative facts or undo previous
// accepted work, and deliberately does not rewrite the selected upload here.
inline void PublishSubmission(std::vector<PendingBackBuffer>* pending_buffers, bool accepted) {
  for (auto& pending : *pending_buffers) {
    const std::unique_lock lock(pending.owner.state->mutex);
    if (pending.owner.state->closing || pending.owner.index >= pending.owner.state->back_buffers.size()) continue;
    auto& buffer = pending.owner.state->back_buffers[pending.owner.index];
    if (buffer.acquisition_id != pending.acquisition_id) continue;
    if (accepted) {
      buffer.submitted = pending.submitted;
      // This consumes the finished source list. The submit scope releases the
      // displaced storage after unlocking; it must not publish this list twice.
      buffer.submitted_scene_resources.swap(pending.scene_resources);
    } else {
      buffer.submitted.failed = true;
    }
  }
}

inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    // Functional source binding history, independent of optional diagnostics.
    // Preserve its existing descriptor-pool reuse limits; no parallel cache.
    renodx::utils::descriptor::trace_descriptor_tables = true;
    renodx::utils::descriptor::Use(reason);
    reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
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
    for (const auto hash : {SCENE_BLIT_SHADER, SCENE_BLIT_MSAA_SHADER, SCENE_FXAA_SHADER, SCENE_TAA_SHARPEN_SHADER}) {
      renodx::utils::command_action::Register(internal::ON_SCENE_OUTPUT, {
                                                                             .shader_hash = hash,
                                                                             .command_types = renodx::utils::command_action::COMMAND_TYPE_DIRECT_DRAW,
                                                                         });
    }
  } else if (reason == DLL_PROCESS_DETACH) {
    renodx::utils::descriptor::Use(reason);
    renodx::utils::command_action::Unregister(internal::ON_SCENE_OUTPUT);
    reshade::unregister_event<reshade::addon_event::init_command_list>(internal::OnInitCommandList);
    reshade::unregister_event<reshade::addon_event::destroy_command_list>(internal::OnDestroyCommandList);
    reshade::unregister_event<reshade::addon_event::reset_command_list>(internal::OnResetCommandList);
    reshade::unregister_event<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
    reshade::unregister_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
    reshade::unregister_event<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
    reshade::unregister_event<reshade::addon_event::destroy_pipeline>(internal::OnDestroyPipeline);
    reshade::unregister_event<reshade::addon_event::begin_query>(internal::OnBeginQuery);
    reshade::unregister_event<reshade::addon_event::end_query>(internal::OnEndQuery);
    reshade::unregister_event<reshade::addon_event::barrier>(internal::OnBarrier);
    reshade::unregister_event<reshade::addon_event::execute_command_list>(internal::OnExecuteCommandList);
    reshade::unregister_event<reshade::addon_event::execute_secondary_command_list>(internal::OnExecuteSecondaryCommandList);
    reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
  }
}

}  // namespace rdr2vk::scene_tracking