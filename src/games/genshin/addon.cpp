/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <mutex>
#include <shared_mutex>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/data.hpp"
#include "../../utils/date.hpp"
#include "../../utils/render.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

float current_settings_mode = 0;

// ReShade effects before UI.
// SDR mode: UI is drawn straight onto the swapchain after the scene copy, so
// effects render right after that copy.
// HDR mode: the composite blends scene and UI in one draw, so it writes only
// the scene, effects render, and the UI is blended back by ui_composite_pass.
// In both modes effects run on the real back buffer (see BackBufferEffects).
// Frames without a scene (inventory) skip effects instead of covering the UI.
constexpr uint32_t SCENE_COPY_SHADER = 0x1A8F4B01;
constexpr uint32_t HDR_COMPOSITE_SHADER = 0xAE711F61;
constexpr uint32_t HDR_COMPOSITE_DUAL_SHADER = 0x0B519C4E;  // two cameras (underwater)

bool effects_handled_this_frame = false;
reshade::api::resource_view last_pixel_srv0 = {0u};
renodx::utils::render::RenderPass ui_composite_pass;

reshade::api::resource_view GetCloneView(const reshade::api::resource_view& view) {
  if (view.handle == 0u) return view;
  reshade::api::resource_view clone = {0u};
  renodx::utils::resource::GetResourceViewInfo(view, [&clone](const renodx::utils::resource::ResourceViewInfo& info) {
    if (!info.destroyed) clone = info.clone;
  });
  return clone.handle != 0u ? clone : view;
}

struct BackBufferTargets {
  reshade::api::resource_view back_buffer = {0u};  // real swapchain RTV
  reshade::api::resource_view scene = {0u};        // float clone RTV the game renders into
};

BackBufferTargets GetBackBufferTargets(reshade::api::command_list* cmd_list) {
  if (!renodx::utils::swapchain::HasBackBufferRenderTarget(cmd_list)) return {};
  auto* cmd_list_data = renodx::utils::data::Get<renodx::utils::swapchain::CommandListData>(cmd_list);
  if (cmd_list_data == nullptr || cmd_list_data->current_render_targets.empty()) return {};
  const auto back_buffer = cmd_list_data->current_render_targets[0];
  return {.back_buffer = back_buffer, .scene = GetCloneView(back_buffer)};
}

// Effects render on the real back buffer in the output encoding (HDR10 or
// scRGB), so ReShade uses its default effect permutation: HDR-aware effects
// compile and see display-encoded data. The scene is encoded into the back
// buffer in reshade_begin_effects and decoded back into the float clone in
// reshade_finish_effects; ReShade restores the application state afterwards.
struct BackBufferEffects {
  bool active = false;
  reshade::api::resource_view back_buffer_rtv = {0u};
  reshade::api::resource_view scene_rtv = {0u};
  reshade::api::resource scene_resource = {0u};
  reshade::api::resource_view scene_srv = {0u};
  reshade::api::resource back_buffer_copy = {0u};
  reshade::api::resource_desc back_buffer_copy_desc = {};
  reshade::api::resource_view back_buffer_copy_srv = {0u};
  renodx::utils::render::RenderPass encode_pass;
  renodx::utils::render::RenderPass decode_pass;
} back_buffer_effects;

// A null back buffer only updates uniforms, but still stops ReShade from
// rendering effects at present on top of the UI.
void RenderEffects(reshade::api::command_list* cmd_list, const BackBufferTargets& targets) {
  effects_handled_this_frame = true;
  auto* device_data = renodx::utils::data::Get<renodx::utils::swapchain::DeviceData>(cmd_list->get_device());
  if (device_data == nullptr) return;

  back_buffer_effects.back_buffer_rtv = targets.back_buffer;
  back_buffer_effects.scene_rtv = targets.scene;
  back_buffer_effects.active = targets.back_buffer.handle != 0u
                               && targets.scene.handle != 0u
                               && targets.scene.handle != targets.back_buffer.handle;
  {
    const std::shared_lock lock(device_data->mutex);
    for (auto* runtime : device_data->effect_runtimes) {
      runtime->render_effects(cmd_list, targets.back_buffer, targets.back_buffer);
    }
  }
  back_buffer_effects.active = false;
}

bool RenderFullscreenPass(
    reshade::api::command_list* cmd_list,
    renodx::utils::render::RenderPass& pass,
    reshade::api::resource_view target,
    reshade::api::resource_view source) {
  auto* device = cmd_list->get_device();
  const auto desc = device->get_resource_desc(device->get_resource_from_view(target));
  const auto format = reshade::api::format_to_default_typed(desc.texture.format, 0);
  if (pass.pipeline_subobjects.render_target_formats.empty()
      || pass.pipeline_subobjects.render_target_formats[0] != format) {
    pass.DestroyAll(device);
    pass.samplers.clear();
    pass.pipeline_subobjects.render_target_formats = {format};
  }

  pass.render_target_slots.views[0] = target;
  pass.shader_resource_slots.views[0] = source;
  pass.viewports = {{
      .width = static_cast<float>(desc.texture.width),
      .height = static_cast<float>(desc.texture.height),
      .max_depth = 1.f,
  }};
  pass.scissors = {{
      .right = static_cast<int32_t>(desc.texture.width),
      .bottom = static_cast<int32_t>(desc.texture.height),
  }};
  return pass.Render(cmd_list);
}

reshade::api::resource_view GetSceneShaderResource(reshade::api::device* device) {
  const auto resource = device->get_resource_from_view(back_buffer_effects.scene_rtv);
  if (resource != back_buffer_effects.scene_resource) {
    if (back_buffer_effects.scene_srv.handle != 0u) {
      device->destroy_resource_view(back_buffer_effects.scene_srv);
      back_buffer_effects.scene_srv = {0u};
    }
    back_buffer_effects.scene_resource = resource;
    const auto desc = device->get_resource_desc(resource);
    device->create_resource_view(
        resource,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format, 0)),
        &back_buffer_effects.scene_srv);
  }
  return back_buffer_effects.scene_srv;
}

reshade::api::resource_view CopyBackBuffer(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list->get_device();
  const auto back_buffer = device->get_resource_from_view(back_buffer_effects.back_buffer_rtv);
  const auto desc = device->get_resource_desc(back_buffer);
  auto& copy_desc = back_buffer_effects.back_buffer_copy_desc;
  if (back_buffer_effects.back_buffer_copy.handle == 0u
      || copy_desc.texture.width != desc.texture.width
      || copy_desc.texture.height != desc.texture.height
      || reshade::api::format_to_typeless(copy_desc.texture.format) != reshade::api::format_to_typeless(desc.texture.format)) {
    if (back_buffer_effects.back_buffer_copy_srv.handle != 0u) {
      device->destroy_resource_view(back_buffer_effects.back_buffer_copy_srv);
      back_buffer_effects.back_buffer_copy_srv = {0u};
    }
    if (back_buffer_effects.back_buffer_copy.handle != 0u) {
      device->destroy_resource(back_buffer_effects.back_buffer_copy);
      back_buffer_effects.back_buffer_copy = {0u};
    }
    copy_desc = reshade::api::resource_desc(
        desc.texture.width, desc.texture.height, 1, 1,
        reshade::api::format_to_typeless(desc.texture.format), 1,
        reshade::api::memory_heap::gpu_only,
        reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource);
    if (!device->create_resource(copy_desc, nullptr, reshade::api::resource_usage::shader_resource, &back_buffer_effects.back_buffer_copy)) {
      return {0u};
    }
    device->create_resource_view(
        back_buffer_effects.back_buffer_copy,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format, 0)),
        &back_buffer_effects.back_buffer_copy_srv);
  }
  cmd_list->copy_resource(back_buffer, back_buffer_effects.back_buffer_copy);
  return back_buffer_effects.back_buffer_copy_srv;
}

void OnBeginEffects(
    reshade::api::effect_runtime*,
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view,
    reshade::api::resource_view) {
  if (!back_buffer_effects.active) return;
  const auto scene_srv = GetSceneShaderResource(cmd_list->get_device());
  if (scene_srv.handle == 0u
      || !RenderFullscreenPass(cmd_list, back_buffer_effects.encode_pass, back_buffer_effects.back_buffer_rtv, scene_srv)) {
    // Leave the float clone untouched if the scene could not be encoded
    back_buffer_effects.active = false;
    reshade::log::message(reshade::log::level::warning, "genshin::OnBeginEffects(scene encode failed)");
  }
}

void OnFinishEffects(
    reshade::api::effect_runtime*,
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view,
    reshade::api::resource_view) {
  if (!back_buffer_effects.active) return;
  const auto copy_srv = CopyBackBuffer(cmd_list);
  if (copy_srv.handle == 0u
      || !RenderFullscreenPass(cmd_list, back_buffer_effects.decode_pass, back_buffer_effects.scene_rtv, copy_srv)) {
    reshade::log::message(reshade::log::level::warning, "genshin::OnFinishEffects(scene decode failed)");
  }
}

void OnSceneCopyDrawn(reshade::api::command_list* cmd_list) {
  if (shader_injection.custom_effects_before_ui == 0.f || effects_handled_this_frame) return;
  const auto targets = GetBackBufferTargets(cmd_list);
  if (targets.back_buffer.handle == 0u) return;
  RenderEffects(cmd_list, targets);
}

void OnHDRCompositeDrawn(reshade::api::command_list* cmd_list) {
  if (shader_injection.custom_effects_before_ui == 0.f) return;
  const auto targets = GetBackBufferTargets(cmd_list);
  if (targets.scene.handle == 0u) return;
  const auto& rtv = targets.scene;
  const auto ui_srv = GetCloneView(last_pixel_srv0);

  if (!effects_handled_this_frame) {
    RenderEffects(cmd_list, targets);
  }

  if (ui_srv.handle == 0u) return;
  if (!RenderFullscreenPass(cmd_list, ui_composite_pass, rtv, ui_srv)) {
    reshade::log::message(reshade::log::level::warning, "genshin::OnHDRCompositeDrawn(UI pass failed)");
  }
}

void SuppressEffectsOnUIOnlyFrame(reshade::api::command_list* cmd_list) {
  if (shader_injection.custom_effects_before_ui == 0.f || effects_handled_this_frame) return;
  if (!renodx::utils::swapchain::HasBackBufferRenderTarget(cmd_list)) return;
  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return;
  const auto pixel_shader_hash = renodx::utils::shader::GetCurrentPixelShaderHash(
      renodx::utils::shader::GetCurrentPixelState(shader_state));
  // Every frame starts with a vertex-only draw on the back buffer; only real
  // pixel draws that are not the scene copy or composite mean UI on screen
  if (pixel_shader_hash == 0u) return;
  if (pixel_shader_hash == SCENE_COPY_SHADER
      || pixel_shader_hash == HDR_COMPOSITE_SHADER
      || pixel_shader_hash == HDR_COMPOSITE_DUAL_SHADER) return;
  RenderEffects(cmd_list, {});
}

bool OnDraw(reshade::api::command_list* cmd_list, uint32_t, uint32_t, uint32_t, uint32_t) {
  SuppressEffectsOnUIOnlyFrame(cmd_list);
  return false;
}

bool OnDrawIndexed(reshade::api::command_list* cmd_list, uint32_t, uint32_t, uint32_t, int32_t, uint32_t) {
  SuppressEffectsOnUIOnlyFrame(cmd_list);
  return false;
}

// HDR mode LUT: the game does not dispatch the LUT builder every frame, and a
// build recorded on a deferred context can be replayed with the settings
// pushed at record time, so RenoDX setting changes would not reliably reach
// the image. Each game LUT is mirrored by an addon-owned LUT instead: the
// builder constants are copied on the GPU next to every game dispatch, the
// replaced builder renders the addon LUT at present with the current
// settings, and the uberposts copy it over the game LUT right before drawing.
constexpr uint32_t LUT_BUILDER_SHADER = 0xF609D63C;
constexpr uint64_t LUT_BUILDER_CONSTANTS_SIZE = 9 * 16;  // cb0[9]

struct LutBuild {
  reshade::api::resource_view game_uav = {0u};
  reshade::api::resource game_lut = {0u};
  reshade::api::resource constants = {0u};  // GPU copy of the game's cb0
  reshade::api::resource lut = {0u};
  reshade::api::resource_view lut_uav = {0u};
  bool rendered = false;
};

// Deferred contexts record on worker threads, so compute bindings are
// tracked per thread
thread_local reshade::api::buffer_range last_compute_cb0 = {};
thread_local reshade::api::resource_view last_compute_uav0 = {0u};
std::mutex lut_builds_mutex;
std::vector<LutBuild> lut_builds;
renodx::utils::render::RenderPass lut_builder_pass;

// D3D11 binds shader resources with push_descriptors. Remember pixel SRV slot
// 0 (the UI buffer when the HDR composite draws) and compute cb0 / u0 (the LUT
// builder's constants and target).
void OnPushDescriptors(
    reshade::api::command_list*,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout,
    uint32_t,
    const reshade::api::descriptor_table_update& update) {
  if (update.binding != 0u || update.count == 0u) return;
  const auto stage_flags = static_cast<uint32_t>(stages);
  if ((stage_flags & static_cast<uint32_t>(reshade::api::shader_stage::pixel)) != 0u
      && update.type == reshade::api::descriptor_type::texture_shader_resource_view) {
    last_pixel_srv0 = static_cast<const reshade::api::resource_view*>(update.descriptors)[0];
  }
  if ((stage_flags & static_cast<uint32_t>(reshade::api::shader_stage::compute)) == 0u) return;
  if (update.type == reshade::api::descriptor_type::constant_buffer) {
    last_compute_cb0 = static_cast<const reshade::api::buffer_range*>(update.descriptors)[0];
  } else if (update.type == reshade::api::descriptor_type::texture_unordered_access_view) {
    last_compute_uav0 = static_cast<const reshade::api::resource_view*>(update.descriptors)[0];
  }
}

void DestroyLutBuild(reshade::api::device* device, const LutBuild& build) {
  if (build.lut_uav.handle != 0u) device->destroy_resource_view(build.lut_uav);
  if (build.lut.handle != 0u) device->destroy_resource(build.lut);
  if (build.constants.handle != 0u) device->destroy_resource(build.constants);
}

bool OnLutBuilderDispatch(reshade::api::command_list* cmd_list) {
  if (last_compute_uav0.handle == 0u || last_compute_cb0.buffer.handle == 0u) return true;
  auto* device = cmd_list->get_device();
  const std::lock_guard lock(lut_builds_mutex);

  auto build = std::ranges::find_if(lut_builds, [](const LutBuild& entry) {
    return entry.game_uav.handle == last_compute_uav0.handle;
  });
  if (build == lut_builds.end()) {
    LutBuild entry = {.game_uav = last_compute_uav0, .game_lut = device->get_resource_from_view(last_compute_uav0)};
    auto lut_desc = device->get_resource_desc(entry.game_lut);
    lut_desc.heap = reshade::api::memory_heap::gpu_only;
    lut_desc.usage = reshade::api::resource_usage::unordered_access | reshade::api::resource_usage::copy_source;
    lut_desc.flags = reshade::api::resource_flags::none;
    if (!device->create_resource(
            reshade::api::resource_desc(
                LUT_BUILDER_CONSTANTS_SIZE,
                reshade::api::memory_heap::gpu_only,
                reshade::api::resource_usage::constant_buffer | reshade::api::resource_usage::copy_dest),
            nullptr, reshade::api::resource_usage::constant_buffer, &entry.constants)
        || !device->create_resource(lut_desc, nullptr, reshade::api::resource_usage::unordered_access, &entry.lut)
        || !device->create_resource_view(
            entry.lut, reshade::api::resource_usage::unordered_access,
            device->get_resource_view_desc(last_compute_uav0), &entry.lut_uav)) {
      DestroyLutBuild(device, entry);
      reshade::log::message(reshade::log::level::warning, "genshin::OnLutBuilderDispatch(LUT mirror creation failed)");
      return true;
    }
    build = lut_builds.insert(lut_builds.end(), entry);
    std::stringstream s;
    s << "genshin::OnLutBuilderDispatch(mirroring LUT " << PRINT_PTR(entry.game_lut.handle)
      << ", constants: " << PRINT_PTR(last_compute_cb0.buffer.handle) << " +" << last_compute_cb0.offset << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
  cmd_list->copy_buffer_region(
      last_compute_cb0.buffer, last_compute_cb0.offset, build->constants, 0, LUT_BUILDER_CONSTANTS_SIZE);
  return true;
}

// Runs on the immediate context at present. The compute bindings used here
// are restored afterwards because Genshin caches bound state across frames.
void RenderLutBuilds(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list->get_device();
  const std::lock_guard lock(lut_builds_mutex);
  if (lut_builds.empty()) return;

  std::erase_if(lut_builds, [&](LutBuild& build) {
    if (!renodx::utils::resource::IsKnownResourceView(build.game_uav)) {
      DestroyLutBuild(device, build);
      reshade::log::message(reshade::log::level::info, "genshin::RenderLutBuilds(game LUT destroyed, dropping mirror)");
      return true;
    }
    const reshade::api::buffer_range constants = {.buffer = build.constants, .size = LUT_BUILDER_CONSTANTS_SIZE};
    cmd_list->push_descriptors(
        reshade::api::shader_stage::compute, {0u}, 0,
        {.binding = 0, .count = 1, .type = reshade::api::descriptor_type::constant_buffer, .descriptors = &constants});
    const auto lut_desc = device->get_resource_desc(build.lut);
    lut_builder_pass.unordered_access_slots.views[0] = build.lut_uav;
    // numthreads(4, 4, 4)
    lut_builder_pass.dispatch_group_counts = std::make_tuple(
        lut_desc.texture.width / 4u, lut_desc.texture.height / 4u, lut_desc.texture.depth_or_layers / 4u);
    build.rendered = lut_builder_pass.Render(cmd_list);
    return false;
  });

  if (last_compute_cb0.buffer.handle != 0u) {
    cmd_list->push_descriptors(
        reshade::api::shader_stage::compute, {0u}, 0,
        {.binding = 0, .count = 1, .type = reshade::api::descriptor_type::constant_buffer, .descriptors = &last_compute_cb0});
  }
  cmd_list->push_descriptors(
      reshade::api::shader_stage::compute, {0u}, 0,
      {.binding = 0, .count = 1, .type = reshade::api::descriptor_type::texture_unordered_access_view, .descriptors = &last_compute_uav0});
}

// Uberposts that sample the LUT in HDR mode
bool OnLutUberpostDraw(reshade::api::command_list* cmd_list) {
  const std::lock_guard lock(lut_builds_mutex);
  for (const auto& build : lut_builds) {
    if (build.rendered && renodx::utils::resource::IsKnownResourceView(build.game_uav)) {
      cmd_list->copy_resource(build.lut, build.game_lut);
    }
  }
  return true;
}

// Genshin's deferred G-buffers are R8G8B8A8_TYPELESS at the render resolution,
// so the back-buffer-ratio upgrade matches them too. They are written and read
// through sRGB views and hold values outside 0..1 that 8-bit storage clamps.
// As float, the lighting pass reads them unclamped and emissive materials blow
// up (glitchy TCG card borders). Post-processing and UI buffers use UNORM
// views, so resources accessed through sRGB views stay on their original
// 8-bit texture. Views are switched off when created; the resource itself is
// switched off at present, outside the resource view lock.
std::mutex srgb_clone_mutex;
std::vector<uint64_t> pending_srgb_clone_resources;

bool IsSrgbViewFormat(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::r8g8b8a8_unorm_srgb:
    case reshade::api::format::b8g8r8a8_unorm_srgb:
    case reshade::api::format::r8g8b8x8_unorm_srgb:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
      return true;
    default:
      return false;
  }
}

void OnInitResourceViewInfo(renodx::utils::resource::ResourceViewInfo* info) {
  if (info == nullptr || info->is_clone || info->is_swap_chain) return;
  if (info->clone_target == nullptr || !info->clone_enabled) return;
  if (!IsSrgbViewFormat(info->desc.format)) return;
  info->clone_enabled = false;
  const std::lock_guard lock(srgb_clone_mutex);
  pending_srgb_clone_resources.push_back(info->original_resource.handle);
}

void DisablePendingSrgbClones() {
  std::vector<uint64_t> pending;
  {
    const std::lock_guard lock(srgb_clone_mutex);
    pending.swap(pending_srgb_clone_resources);
  }
  for (const auto handle : pending) {
    std::vector<uint64_t> view_handles;
    renodx::utils::resource::UpdateResourceInfo(
        reshade::api::resource{handle},
        [&](renodx::utils::resource::ResourceInfo* info) {
          if (info->destroyed || !info->clone_enabled) return;
          info->clone_enabled = false;
          view_handles.assign(info->resource_view_handles.begin(), info->resource_view_handles.end());
        });
    if (!view_handles.empty()) {
      renodx::utils::resource::upgrade::UpdateResourceViewsCloneState(view_handles, false, false);
    }
  }
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain*,
    const reshade::api::rect*,
    const reshade::api::rect*,
    uint32_t,
    const reshade::api::rect*) {
  effects_handled_this_frame = false;
  DisablePendingSrgbClones();
  if (queue != nullptr) RenderLutBuilds(queue->get_immediate_command_list());
}

void OnDestroyDevice(reshade::api::device* device) {
  ui_composite_pass.DestroyAll(device);
  lut_builder_pass.DestroyAll(device);
  {
    const std::lock_guard lock(lut_builds_mutex);
    for (const auto& build : lut_builds) DestroyLutBuild(device, build);
    lut_builds.clear();
  }
  back_buffer_effects.encode_pass.DestroyAll(device);
  back_buffer_effects.decode_pass.DestroyAll(device);
  if (back_buffer_effects.scene_srv.handle != 0u) device->destroy_resource_view(back_buffer_effects.scene_srv);
  if (back_buffer_effects.back_buffer_copy_srv.handle != 0u) device->destroy_resource_view(back_buffer_effects.back_buffer_copy_srv);
  if (back_buffer_effects.back_buffer_copy.handle != 0u) device->destroy_resource(back_buffer_effects.back_buffer_copy);
  back_buffer_effects.scene_srv = {0u};
  back_buffer_effects.scene_resource = {0u};
  back_buffer_effects.back_buffer_copy_srv = {0u};
  back_buffer_effects.back_buffer_copy = {0u};
}

renodx::mods::shader::CustomShaders custom_shaders = {
    {
        0xBE195674,  // Uberpost (SDR tone map + encode, HDR PQ LUT sample)
        {.crc32 = 0xBE195674, .code = __0xBE195674, .on_draw = &OnLutUberpostDraw},
    },
    // Uberpost variants, not replaced; their HDR branch samples the LUT
    {0xE3118E31, {.crc32 = 0xE3118E31, .on_draw = &OnLutUberpostDraw}},  // menu / character screen camera
    {0xC225B20B, {.crc32 = 0xC225B20B, .on_draw = &OnLutUberpostDraw}},
    {0x7F4102D4, {.crc32 = 0x7F4102D4, .on_draw = &OnLutUberpostDraw}},  // underwater
    {0x8691B864, {.crc32 = 0x8691B864, .on_draw = &OnLutUberpostDraw}},  // Snowmountain (adds an SDR 2D LUT)
    {
        LUT_BUILDER_SHADER,  // HDR mode: LUT builder (compute, tone map)
        {.crc32 = LUT_BUILDER_SHADER, .code = __0xF609D63C, .on_draw = &OnLutBuilderDispatch},
    },
    {
        HDR_COMPOSITE_SHADER,  // HDR mode: final composite (scene + UI)
        {.crc32 = HDR_COMPOSITE_SHADER, .code = __0xAE711F61, .on_drawn = &OnHDRCompositeDrawn},
    },
    {
        HDR_COMPOSITE_DUAL_SHADER,  // HDR mode: final composite with two cameras (underwater)
        {.crc32 = HDR_COMPOSITE_DUAL_SHADER, .code = __0x0B519C4E, .on_drawn = &OnHDRCompositeDrawn},
    },
    {
        SCENE_COPY_SHADER,  // SDR mode: scene copy to the swapchain (not replaced)
        {.crc32 = SCENE_COPY_SHADER, .on_drawn = &OnSceneCopyDrawn},
    },
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type. Vanilla keeps the game's own SDR or HDR tone map.",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Tone Mapping",
        .tooltip = "Clamps colors to the selected color space.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Peak",
        .section = "Tone Mapping",
        .tooltip = "Clamps peak brightness to the selected color space.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Strength of the game's SDR tone curve look applied on top of the RenoDX tone map",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ReShadeBeforeUI",
        .binding = &shader_injection.custom_effects_before_ui,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "ReShade Before UI",
        .section = "Effects",
        .tooltip = "Renders ReShade effects on the game image before the UI is drawn."
                   "\nWorks in SDR and HDR mode with any anti-aliasing option."
                   "\nDisable effect toggler add-ons (REST) groups that do the same.",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Display Output",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US Modern",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Intermediate Encoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .parse = [](float value) {
          if (value == 0) return shader_injection.gamma_correction + 1.f;
          return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .parse = [](float value) {
          if (value == 0) return shader_injection.intermediate_encoding;
          return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Gamma Correction",
        .section = "Display Output",
        .labels = {"None", "2.2", "2.4"},
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 1000.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueShift", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeScene", 100.f);
  renodx::utils::settings::UpdateSetting("SwapChainCustomColorSpace", 0.f);
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Genshin Impact";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        // Both game modes end in the RenoDX intermediate encoding:
        // SDR mode from the uberpost, HDR mode from the final composite.
        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        // Genshin caches bound pipeline state across frames. Without reverting,
        // the first UI draw of a frame (menu backdrops) inherits the proxy's
        // vertex stage and renders screen UVs as vertex color.
        renodx::mods::swapchain::swapchain_proxy_revert_state = true;
        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
            {
                reshade::api::device_api::d3d12,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
                },
            },
        };

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainForceBorderless",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Force Borderless",
              .section = "Display Output",
              .tooltip = "Forces fullscreen to be borderless for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::force_borderless = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::force_borderless = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainPreventFullscreen",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Prevent Fullscreen",
              .section = "Display Output",
              .tooltip = "Prevent exclusive fullscreen for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 4.f,
              .label = "Encoding",
              .section = "Display Output",
              .tooltip = "Requires a game restart.",
              .labels = {"None", "SRGB", "2.2", "2.4", "HDR10", "scRGB"},
              .on_change_value = [](float previous, float current) {
                bool is_hdr10 = current == 4;
                shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f); },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool is_hdr10 = setting->GetValue() == 4;
          renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          renodx::mods::swapchain::use_resize_buffer = setting->GetValue() < 4;
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
          settings.push_back(setting);
        }

        // SDR mode: the uberpost output, AA/upscaler buffers and their copies
        // are 8-bit. Matched by back buffer aspect ratio so render scale and
        // any anti-aliasing option are covered. HDR mode uses the same format
        // for the UI buffer, which is harmless to upgrade.
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .aspect_ratio = static_cast<float>(renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER),
            .usage_include = reshade::api::resource_usage::render_target,
        });

        // HDR mode UI blend after effects: fullscreen triangle, premultiplied
        // blend (ONE, SRC_ALPHA) into the float back buffer clone. Views are
        // set per frame and the game's state is restored after the draw.
        ui_composite_pass.pipeline_subobjects.vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
        ui_composite_pass.pipeline_subobjects.pixel_shader = __ui_composite_pixel_shader_dx11;
        {
          reshade::api::blend_desc blend = {};
          blend.blend_enable[0] = true;
          blend.source_color_blend_factor[0] = reshade::api::blend_factor::one;
          blend.dest_color_blend_factor[0] = reshade::api::blend_factor::source_alpha;
          blend.source_alpha_blend_factor[0] = reshade::api::blend_factor::zero;
          blend.dest_alpha_blend_factor[0] = reshade::api::blend_factor::one;
          ui_composite_pass.pipeline_subobjects.blend_states = {blend};
        }
        ui_composite_pass.pipeline_subobjects.render_target_formats = {reshade::api::format::r16g16b16a16_float};
        ui_composite_pass.auto_generate_render_target_formats = false;
        ui_composite_pass.auto_generate_viewport = false;
        ui_composite_pass.auto_generate_scissors = false;
        ui_composite_pass.use_render_pass = false;
        ui_composite_pass.revert_state_after_render = true;
        ui_composite_pass.sampler_descs = {reshade::api::sampler_desc{}};
        // Fixed size so descriptor updates keep pointing at the same storage
        ui_composite_pass.render_target_slots.views = {reshade::api::resource_view{0u}};
        ui_composite_pass.shader_resource_slots.views = {reshade::api::resource_view{0u}};

        // Replays the replaced LUT builder with recorded constants; the
        // settings come from slot 13 like every replaced shader.
        lut_builder_pass.pipeline_subobjects.compute_shader = __0xF609D63C;
        lut_builder_pass.unordered_access_slots.views = {reshade::api::resource_view{0u}};
        lut_builder_pass.push_constants[{13u, 0u}] = std::span<const float>(
            reinterpret_cast<const float*>(&shader_injection),
            sizeof(shader_injection) / sizeof(float));
        lut_builder_pass.revert_state_after_render = true;

        // ReShade Before UI back buffer round trip: encode the float clone into
        // the real back buffer with the output encoding, then decode it back
        // after effects. ReShade restores the application state itself.
        for (auto* pass : {&back_buffer_effects.encode_pass, &back_buffer_effects.decode_pass}) {
          pass->pipeline_subobjects.vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
          pass->auto_generate_render_target_formats = false;
          pass->auto_generate_viewport = false;
          pass->auto_generate_scissors = false;
          pass->use_render_pass = false;
          pass->revert_state_after_render = false;
          pass->render_target_slots.views = {reshade::api::resource_view{0u}};
          pass->shader_resource_slots.views = {reshade::api::resource_view{0u}};
        }
        // The proxy pixel shader samples t0 and reads settings from slot 13
        back_buffer_effects.encode_pass.pipeline_subobjects.pixel_shader = __swap_chain_proxy_pixel_shader_dx11;
        back_buffer_effects.encode_pass.sampler_descs = {reshade::api::sampler_desc{}};
        back_buffer_effects.encode_pass.push_constants[{13u, 0u}] = std::span<const float>(
            reinterpret_cast<const float*>(&shader_injection),
            sizeof(shader_injection) / sizeof(float));
        back_buffer_effects.decode_pass.push_constants = back_buffer_effects.encode_pass.push_constants;
        back_buffer_effects.decode_pass.pipeline_subobjects.pixel_shader = __effects_decode_pixel_shader_dx11;

        initialized = true;
      }

      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      reshade::register_event<reshade::addon_event::reshade_begin_effects>(OnBeginEffects);
      reshade::register_event<reshade::addon_event::reshade_finish_effects>(OnFinishEffects);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::reshade_finish_effects>(OnFinishEffects);
      reshade::unregister_event<reshade::addon_event::reshade_begin_effects>(OnBeginEffects);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      renodx::utils::resource::UnregisterOnInitResourceViewInfoCallback(&OnInitResourceViewInfo);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  if (fdw_reason == DLL_PROCESS_ATTACH) {
    // Registered after mods::swapchain attaches utils::resource
    renodx::utils::resource::RegisterOnInitResourceViewInfoCallback(&OnInitResourceViewInfo);
  }

  return TRUE;
}
