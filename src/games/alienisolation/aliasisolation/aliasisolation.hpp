#pragma once

#include <windows.h>
#include <algorithm>

#include <include/reshade.hpp>

#include "../../../utils/pipeline_layout.hpp"
#include "../../../utils/resource.hpp"
#include "../../../utils/settings.hpp"
#include "../../../utils/state.hpp"
#include "../shared.h"
#include "./constant_buffers.hpp"
#include "./descriptor_tracker.hpp"
#include "./jitter.hpp"
#include "./logging.hpp"
#include "./pipeline_replacer.hpp"
#include "./pipeline_tracker.hpp"
#include "./post.hpp"
#include "./resource_view_sanitizer.hpp"
#include "./taa.hpp"

namespace alienisolation::aliasisolation {

inline ShaderInjectData* injected_data = nullptr;
inline bool attached = false;
inline constexpr bool post_effects_enabled = false;
inline constexpr bool smaa_replacement_enabled = false;
inline bool settings_appended = false;
inline bool logged_master_state = false;
inline bool last_master_state = false;
inline uint64_t last_smaa_bypass_log = UINT64_MAX;

inline void AppendSettings(renodx::utils::settings::Settings& settings, ShaderInjectData* shader_injection) {
  if (settings_appended || shader_injection == nullptr) return;
  settings_appended = true;

  auto insert_pos = std::find_if(settings.begin(), settings.end(), [](const renodx::utils::settings::Setting* setting) {
    return setting != nullptr && setting->section == "Options";
  });

  insert_pos = settings.insert(
      ++insert_pos,
      new renodx::utils::settings::Setting{
          .value_type = renodx::utils::settings::SettingValueType::TEXT,
          .label = "Requires in-game Video settings:\nAnti-aliasing = SMAA T1x\nChromatic Aberration = Off\nMotion Blur = On.",
          .section = "Alias Isolation",
      });

  insert_pos = settings.insert(
      ++insert_pos,
      new renodx::utils::settings::Setting{
          .value_type = renodx::utils::settings::SettingValueType::TEXT,
          .label = "Special thanks to Ryan J. Gray and Rick Runyon for creating Alias Isolation.",
          .section = "Alias Isolation",
      });

  insert_pos = settings.insert(
      ++insert_pos,
      new renodx::utils::settings::Setting{
          .key = "AliasIsolationTAA",
          .binding = &constant_buffers::enabled,
          .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
          .default_value = 0.f,
          .label = "Alias Isolation",
          .section = "Alias Isolation",
      });

  insert_pos = settings.insert(
      ++insert_pos,
      new renodx::utils::settings::Setting{
          .key = "FxChromaticAberration",
          .binding = &shader_injection->fxChromaticAberration,
          .default_value = 50.f,
          .label = "Chromatic Aberration",
          .section = "Alias Isolation",
          .max = 100.f,
          .is_enabled = []() { return constant_buffers::IsEnabled(); },
          .parse = [](float value) { return value * 0.01f; },
          .is_visible = []() { return post_effects_enabled; },
      });
}

inline void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("FxChromaticAberration", 0.f);
  renodx::utils::settings::UpdateSetting("AliasIsolationTAA", 0.f);
}

inline bool HandleDraw(reshade::api::command_list* cmd_list) {
  auto* data = descriptor_tracker::Get(cmd_list);
  if (data == nullptr) return false;

  const bool enabled = constant_buffers::IsEnabled();

  if (enabled) {
    jitter::CaptureConstantBuffers(cmd_list, *data);
  }

  if (enabled && data->shaders.pixel == ShaderId::CameraMotionPs) {
    taa::CaptureCameraMotion(cmd_list, *data);
  }

  if (enabled) {
    taa::MaybeRun(cmd_list, *data);
  }

  if (data->shaders.pixel == ShaderId::SmaaSpatialPs) {
    if (!enabled) return false;

    if (!smaa_replacement_enabled) {
      if (logging::ShouldLogFrame(constant_buffers::frame_state.frame_index, last_smaa_bypass_log)) {
        logging::Warn("SMAA/final pass replacement temporarily disabled; allowing original game pass frame=",
                      constant_buffers::frame_state.frame_index);
      }
      return false;
    }

    if (logging::ShouldLogFrame(constant_buffers::frame_state.frame_index, last_smaa_bypass_log)) {
      logging::Info("replacing game SMAA spatial/final pass frame=", constant_buffers::frame_state.frame_index,
                    " post_effects=", logging::Bool(post_effects_enabled));
    }

    const bool replaced = post_effects_enabled
                              ? post::Run(cmd_list, *data, injected_data)
                              : post::RunNeutralBlit(cmd_list, *data, injected_data);
    if (!replaced) {
      logging::Warn("SMAA replacement failed; allowing original game pass to draw");
      return false;
    }

    return true;
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
  post::Destroy(device);
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
  injected_data = shader_injection;

  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::pipeline_layout::Use(fdw_reason);
  renodx::utils::state::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      logging::Info("attach");

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
