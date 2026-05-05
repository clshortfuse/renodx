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
#include <cstdint>

#include <include/reshade.hpp>

#include "../../../utils/pipeline_layout.hpp"
#include "../../../utils/resource.hpp"
#include "../../../utils/settings.hpp"
#include "../../../utils/shader.hpp"
#include "../../../utils/state.hpp"
#include "../shared.h"
#include "./runtime/config.hpp"
#include "./runtime/constant_buffers.hpp"
#include "./runtime/descriptor_tracker.hpp"
#include "./runtime/jitter.hpp"
#include "./runtime/logging.hpp"
#include "./runtime/taa.hpp"

namespace alienisolation::aliasisolation {

inline bool attached = false;
inline bool settings_appended = false;
inline bool logged_master_state = false;
inline bool last_master_state = false;
inline bool logged_texture_3d_default_view = false;
inline bool logged_smaa_vs = false;
inline bool logged_rgbm_encode_vs = false;
inline bool logged_rgbm_encode_ps = false;
inline bool logged_dof_encode_ps = false;
inline bool logged_camera_motion_ps = false;

namespace shader_hashes {

#if ALIENISOLATION_ENABLE_BARREL_DISTORTION_REMOVAL
inline constexpr uint32_t MAIN_POST_VS = 0x5D907E29u;
#endif
inline constexpr uint32_t SMAA_VS = 0x5C784290u;
inline constexpr uint32_t RGBM_ENCODE_VS = 0x901CDB44u;
inline constexpr uint32_t RGBM_ENCODE_PS = 0x7B682313u;
inline constexpr uint32_t DOF_ENCODE_PS = 0x39E3BE10u;
inline constexpr uint32_t CAMERA_MOTION_PS = 0xC33A92A2u;
inline constexpr uint32_t SHADOW_LINEARIZE_PS = 0xF4DCB0D4u;
inline constexpr uint32_t SHADOW_DOWNSAMPLE_PS = 0x098D6289u;
#if ALIENISOLATION_ENABLE_BLOOM_MERGE_REPLACEMENT
inline constexpr uint32_t BLOOM_MERGE_PS = 0xA8200442u;
#endif

}  // namespace shader_hashes

inline void LogObservedShader(const char* stage, const char* name, uint32_t hash, bool& logged) {
  if (logged) return;
  logged = true;
  logging::Info("observed ", stage, " shader ", name, " hash=", logging::Crc32(hash));
}

inline reshade::api::resource_view CurrentRenderTarget0(reshade::api::command_list* cmd_list) {
  const auto* state = renodx::utils::state::GetCurrentState(cmd_list);
  if (state == nullptr || state->render_targets.empty()) return {0};
  return state->render_targets[0];
}

inline bool OnCreateResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc& desc) {
  if (device == nullptr || resource.handle == 0u) return false;
  if (desc.type != reshade::api::resource_view_type::unknown) return false;

  const auto resource_desc = device->get_resource_desc(resource);
  if (resource_desc.type != reshade::api::resource_type::texture_3d) return false;

  desc.type = reshade::api::resource_view_type::texture_3d;
  if (desc.format == reshade::api::format::unknown) {
    desc.format = resource_desc.texture.format;
  }
  desc.texture.first_level = 0u;
  desc.texture.level_count = usage_type == reshade::api::resource_usage::unordered_access ? 1u : UINT32_MAX;
  desc.texture.first_layer = 0u;
  desc.texture.layer_count = UINT32_MAX;

  if (!logged_texture_3d_default_view) {
    logged_texture_3d_default_view = true;
    logging::Info("populated default Texture3D resource view before resource upgrade hook resource=", logging::Hex(resource.handle),
                  " format=", static_cast<uint32_t>(desc.format),
                  " usage=", static_cast<uint32_t>(usage_type));
  }
  return true;
}

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
              .binding = &shader_injection->custom_alias_isolation_taa,
              .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
              .default_value = 1.f,
              .label = "Alias Isolation TAA",
              .section = "Alias Isolation",
          },
          new renodx::utils::settings::Setting{
              .key = "FxSharpening",
              .binding = &shader_injection->custom_sharpening,
              .default_value = 100.f,
              .label = "Lilium RCAS Sharpening",
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
  if (!enabled) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;

  const uint32_t vertex_hash = renodx::utils::shader::GetCurrentVertexShaderHash(shader_state);
  const uint32_t pixel_hash = renodx::utils::shader::GetCurrentPixelShaderHash(shader_state);
  const bool is_smaa_vs = vertex_hash == shader_hashes::SMAA_VS;
  const bool is_rgbm_encode_vs = vertex_hash == shader_hashes::RGBM_ENCODE_VS;
  const bool is_rgbm_encode_ps = pixel_hash == shader_hashes::RGBM_ENCODE_PS;
  const bool is_dof_encode_ps = pixel_hash == shader_hashes::DOF_ENCODE_PS;
  const bool is_camera_motion_ps = pixel_hash == shader_hashes::CAMERA_MOTION_PS;

  if (is_smaa_vs) LogObservedShader("vertex", "SMAA VS", vertex_hash, logged_smaa_vs);
  if (is_rgbm_encode_vs) LogObservedShader("vertex", "RGBM encode VS", vertex_hash, logged_rgbm_encode_vs);
  if (is_rgbm_encode_ps) LogObservedShader("pixel", "RGBM encode PS", pixel_hash, logged_rgbm_encode_ps);
  if (is_dof_encode_ps) LogObservedShader("pixel", "DoF encode PS", pixel_hash, logged_dof_encode_ps);
  if (is_camera_motion_ps) LogObservedShader("pixel", "camera motion PS", pixel_hash, logged_camera_motion_ps);

  // All three paths are draw-driven because the original game provides the
  // needed resources during ordinary post-processing draws, not standalone
  // compute passes.
  const bool captures_constant_buffer = is_smaa_vs || is_rgbm_encode_vs || is_camera_motion_ps;
  if (captures_constant_buffer) {
    jitter::CaptureConstantBuffers(*data, is_smaa_vs, is_rgbm_encode_vs, is_camera_motion_ps);
  }

  if (is_camera_motion_ps) {
    taa::CaptureCameraMotion(cmd_list, *data, CurrentRenderTarget0(cmd_list));
  }

  taa::InsertionPoint insertion_point = taa::InsertionPoint::None;
  if (is_dof_encode_ps) {
    insertion_point = taa::InsertionPoint::DofEncode;
  } else if (is_rgbm_encode_vs && is_rgbm_encode_ps) {
    insertion_point = taa::InsertionPoint::RgbmEncode;
  }

  if (!constant_buffers::frame_state.taa_ran_this_frame && insertion_point != taa::InsertionPoint::None) {
    taa::MaybeRun(cmd_list, *data, insertion_point);
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
  taa::shader_injection = shader_injection;
  constant_buffers::enabled_binding = shader_injection != nullptr ? &shader_injection->custom_alias_isolation_taa : &constant_buffers::enabled;

  // The runtime uses RenoDX's resource, pipeline-layout, and state helpers but
  // keeps all game-specific behavior in this folder.
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::pipeline_layout::Use(fdw_reason);
  renodx::utils::shader::Use(fdw_reason);
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
      reshade::register_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(jitter::OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::bind_viewports>(jitter::OnBindViewports);
      reshade::register_event<reshade::addon_event::push_descriptors>(descriptor_tracker::OnPushDescriptors);
      reshade::register_event<reshade::addon_event::map_buffer_region>(jitter::OnMapBufferRegion);
      reshade::register_event<reshade::addon_event::unmap_buffer_region>(jitter::OnUnmapBufferRegion);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      renodx::utils::resource::RegisterOnDestroyResourceViewInfoCallback(taa::OnDestroyResourceView);
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
      reshade::unregister_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(jitter::OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::bind_viewports>(jitter::OnBindViewports);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(descriptor_tracker::OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::map_buffer_region>(jitter::OnMapBufferRegion);
      reshade::unregister_event<reshade::addon_event::unmap_buffer_region>(jitter::OnUnmapBufferRegion);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      renodx::utils::resource::UnregisterOnDestroyResourceViewInfoCallback(taa::OnDestroyResourceView);
      break;
  }
}

}  // namespace alienisolation::aliasisolation
