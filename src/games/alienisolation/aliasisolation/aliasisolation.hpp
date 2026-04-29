#pragma once

/*
 * Entry point for the self-contained Alias Isolation integration.
 *
 * addon.cpp includes this file only; the rest of the Alias Isolation port stays
 * under aliasisolation/runtime. This header wires the RenoDX setting, registers
 * the ReShade callbacks, and routes draw-time events to the jitter and TAA
 * systems.
 */

#include <windows.h>
#include <algorithm>
#include <cmath>

#include <include/reshade.hpp>

#include "../../../utils/pipeline_layout.hpp"
#include "../../../utils/resource.hpp"
#include "../../../utils/settings.hpp"
#include "../../../utils/state.hpp"
#include "../shared.h"
#include "./runtime/constant_buffers.hpp"
#include "./runtime/descriptor_tracker.hpp"
#include "./runtime/jitter.hpp"
#include "./runtime/logging.hpp"
#include "./runtime/pipeline_replacer.hpp"
#include "./runtime/pipeline_tracker.hpp"
#include "./runtime/resource_view_sanitizer.hpp"
#include "./runtime/taa.hpp"

namespace alienisolation::aliasisolation {

inline bool attached = false;
inline bool settings_appended = false;
inline bool logged_master_state = false;
inline bool last_master_state = false;

inline void AppendSettings(renodx::utils::settings::Settings& settings, ShaderInjectData* shader_injection) {
  if (settings_appended || shader_injection == nullptr) return;
  settings_appended = true;

  // Keep the Alias Isolation controls above the generic Options section so the
  // game-setting requirements are visible before the reset buttons.
  settings.insert(
      std::find_if(settings.begin(), settings.end(), [](const renodx::utils::settings::Setting* setting) {
        return setting != nullptr && setting->section == "Options";
      }),
      {
          new renodx::utils::settings::Setting{
              .value_type = renodx::utils::settings::SettingValueType::TEXT,
              .label = "Requires in-game video settings:\nAnti-aliasing = SMAA T1x\nMotion Blur = On.",
              .section = "Alias Isolation",
          },
          new renodx::utils::settings::Setting{
              .value_type = renodx::utils::settings::SettingValueType::TEXT,
              .label = "Special thanks to Ryan J. Gray and Rick Runyon for creating Alias Isolation.",
              .section = "Alias Isolation",
          },
          new renodx::utils::settings::Setting{
              .key = "AliasIsolationTAA",
              .binding = &shader_injection->fxAliasIsolation,
              .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
              .default_value = 1.f,
              .label = "Alias Isolation TAA",
              .section = "Alias Isolation",
          },
          new renodx::utils::settings::Setting{
              .key = "FxSharpening",
              .binding = &shader_injection->fxSharpening,
              .default_value = 100.f,
              .label = "Sharpening",
              .section = "Alias Isolation",
              .max = 100.f,
              .is_enabled = []() { return constant_buffers::IsEnabled(); },
              .parse = [](float value) { return value == 0 ? 0.f : std::exp2(-(1.f - (value * 0.01f))); },
          },
      });
}

inline void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("FxSharpening", 0.f);
  renodx::utils::settings::UpdateSetting("AliasIsolationTAA", 0.f);
}

inline bool HandleDraw(reshade::api::command_list* cmd_list) {
  auto* data = descriptor_tracker::Get(cmd_list);
  if (data == nullptr) return false;

  const bool enabled = constant_buffers::IsEnabled();

  // All three paths are draw-driven because the original game provides the
  // needed resources during ordinary post-processing draws, not standalone
  // compute passes.
  if (enabled) {
    jitter::CaptureConstantBuffers(cmd_list, *data);
  }

  if (enabled && data->shaders.pixel == ShaderId::CameraMotionPs) {
    taa::CaptureCameraMotion(cmd_list, *data);
  }

  if (enabled) {
    taa::MaybeRun(cmd_list, *data);
  }

  return false;
}

inline bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t,
    uint32_t,
    uint32_t,
    uint32_t) {
  return HandleDraw(cmd_list);
}

inline bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t,
    uint32_t,
    uint32_t,
    int32_t,
    uint32_t) {
  return HandleDraw(cmd_list);
}

inline bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command,
    reshade::api::resource,
    uint64_t,
    uint32_t,
    uint32_t) {
  return HandleDraw(cmd_list);
}

inline void OnDestroyDevice(reshade::api::device* device) {
  logging::Info("destroy device");
  taa::Destroy(device);
  pipeline_replacer::Destroy(device);
  pipeline_tracker::pipelines.clear();
  jitter::Reset();
}

inline void OnPresent(
    reshade::api::command_queue*,
    reshade::api::swapchain*,
    const reshade::api::rect*,
    const reshade::api::rect*,
    uint32_t,
    const reshade::api::rect*) {
  // Advance the frame after presentation. The next frame's jitter must be based
  // on whether TAA actually dispatched during the frame that just ended.
  jitter::FinishFrame();
  constant_buffers::BeginFrame();

  const bool enabled = constant_buffers::IsEnabled();
  if (!logged_master_state || last_master_state != enabled) {
    logged_master_state = true;
    last_master_state = enabled;
    logging::Info("master toggle ", logging::Bool(enabled), " frame=", constant_buffers::frame_state.frame_index,
                  " live_setting=on");
  }
}

inline void Use(DWORD fdw_reason, ShaderInjectData* shader_injection) {
  constant_buffers::enabled_binding = shader_injection != nullptr ? &shader_injection->fxAliasIsolation : &constant_buffers::enabled;

  // The runtime uses RenoDX's resource, pipeline-layout, and state helpers but
  // keeps all game-specific behavior in this folder.
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::pipeline_layout::Use(fdw_reason);
  renodx::utils::state::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      logging::Info("attach");

      // Registration is intentionally centralized here so detach mirrors attach
      // exactly and addon.cpp does not need to know about the internal modules.
      reshade::register_event<reshade::addon_event::init_swapchain>(jitter::OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(jitter::OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::init_command_list>(descriptor_tracker::OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(descriptor_tracker::OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::reset_command_list>(descriptor_tracker::OnResetCommandList);
      reshade::register_event<reshade::addon_event::create_resource_view>(resource_view_sanitizer::OnCreateResourceView);
      reshade::register_event<reshade::addon_event::init_pipeline>(pipeline_replacer::OnInitPipeline);
      reshade::register_event<reshade::addon_event::init_pipeline>(pipeline_tracker::OnInitPipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(pipeline_replacer::OnDestroyPipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(pipeline_tracker::OnDestroyPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline>(pipeline_replacer::OnBindPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline>(descriptor_tracker::OnBindPipeline);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(jitter::OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(descriptor_tracker::OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::bind_viewports>(jitter::OnBindViewports);
      reshade::register_event<reshade::addon_event::bind_viewports>(descriptor_tracker::OnBindViewports);
      reshade::register_event<reshade::addon_event::push_descriptors>(descriptor_tracker::OnPushDescriptors);
      reshade::register_event<reshade::addon_event::map_buffer_region>(jitter::OnMapBufferRegion);
      reshade::register_event<reshade::addon_event::unmap_buffer_region>(jitter::OnUnmapBufferRegion);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;

    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      logging::Info("detach");

      reshade::unregister_event<reshade::addon_event::init_swapchain>(jitter::OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(jitter::OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::init_command_list>(descriptor_tracker::OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(descriptor_tracker::OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::reset_command_list>(descriptor_tracker::OnResetCommandList);
      reshade::unregister_event<reshade::addon_event::create_resource_view>(resource_view_sanitizer::OnCreateResourceView);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(pipeline_replacer::OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(pipeline_tracker::OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(pipeline_replacer::OnDestroyPipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(pipeline_tracker::OnDestroyPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(pipeline_replacer::OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(descriptor_tracker::OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(jitter::OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(descriptor_tracker::OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::bind_viewports>(jitter::OnBindViewports);
      reshade::unregister_event<reshade::addon_event::bind_viewports>(descriptor_tracker::OnBindViewports);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(descriptor_tracker::OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::map_buffer_region>(jitter::OnMapBufferRegion);
      reshade::unregister_event<reshade::addon_event::unmap_buffer_region>(jitter::OnUnmapBufferRegion);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      break;
  }
}

}  // namespace alienisolation::aliasisolation
