#pragma once

/*
 * Alias Isolation temporal resolve implementation.
 *
 * This module captures the game's current HDR color, velocity, and depth
 * resources at the same passes the original ASI used, dispatches the embedded
 * TAA compute shader, stores ping-pong history textures, and copies the resolved
 * result back into the game's HDR color resource before later post passes run.
 */

#include <array>
#include <cstdint>
#include <limits>
#include <utility>
#include <vector>

#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../../../utils/resource.hpp"
#include "../../../../utils/state.hpp"
#include "../../shared.h"
#include "./constant_buffers.hpp"
#include "./descriptor_tracker.hpp"
#include "./logging.hpp"

namespace alienisolation::aliasisolation::taa {

enum class InsertionPoint {
  None,
  DofEncode,
  RgbmEncode,
};

inline const char* InsertionPointName(InsertionPoint insertion_point) {
  switch (insertion_point) {
    case InsertionPoint::DofEncode:
      return "DoFEncode";
    case InsertionPoint::RgbmEncode:
      return "RGBMEncode";
    default:
      return "None";
  }
}

struct HistoryTexture {
  reshade::api::resource resource = {0};
  reshade::api::resource_view srv = {0};
  reshade::api::resource_view uav = {0};
};

struct Resources {
  // History is ping-ponged each successful dispatch: one texture is read as
  // previous history while the other receives the current resolved frame.
  std::array<HistoryTexture, 2> history = {};
  uint32_t width = 0u;
  uint32_t height = 0u;
  reshade::api::format resource_format = reshade::api::format::unknown;
  reshade::api::format view_format = reshade::api::format::unknown;
  uint32_t accum_index = 0u;
  bool initialized = false;
  // Stable insertion-point color handles are cached so steady-state dispatches
  // do not have to re-query the resource and view descriptions every frame.
  reshade::api::resource_view color_srv = {0};
  reshade::api::resource color_resource = {0};

  reshade::api::pipeline_layout compute_layout = {0};
  reshade::api::pipeline compute_pipeline = {0};
  std::array<reshade::api::sampler, 2> samplers = {};

  reshade::api::resource velocity_resource = {0};
  // The camera-motion pass exposes velocity as RTV 0; this cache avoids
  // recreating the matching SRV while that RTV handle is unchanged.
  reshade::api::resource_view velocity_rtv = {0};
  reshade::api::resource_view velocity_srv = {0};
  reshade::api::format velocity_view_format = reshade::api::format::unknown;
  reshade::api::resource_view depth_srv = {0};
  // Used to reject stale velocity/depth if the camera-motion pass was not seen
  // on the same frame as the insertion point.
  uint64_t capture_frame = std::numeric_limits<uint64_t>::max();
};

inline Resources resources;
inline uint64_t last_capture_log = std::numeric_limits<uint64_t>::max();
inline uint64_t last_capture_missing_log = std::numeric_limits<uint64_t>::max();
inline uint64_t last_dispatch_log = std::numeric_limits<uint64_t>::max();
inline uint64_t last_missing_inputs_log = std::numeric_limits<uint64_t>::max();
inline uint64_t last_missing_color_log = std::numeric_limits<uint64_t>::max();
inline uint64_t last_history_format_log = std::numeric_limits<uint64_t>::max();
inline uint64_t last_history_create_fail_log = std::numeric_limits<uint64_t>::max();
inline uint64_t last_compute_fail_log = std::numeric_limits<uint64_t>::max();
inline uint64_t last_stale_capture_log = std::numeric_limits<uint64_t>::max();
inline bool logged_dof_insertion = false;
inline bool logged_rgbm_insertion = false;
inline ShaderInjectData* shader_injection = nullptr;

inline bool LogEvery(uint64_t& last_frame, uint64_t interval = 120u) {
  return logging::ShouldLogFrame(constant_buffers::frame_state.frame_index, last_frame, interval);
}

inline void OnDestroyResourceView(renodx::utils::resource::ResourceViewInfo* info) {
  if (info == nullptr) return;
  const uint64_t h = info->view.handle;
  if (h == resources.color_srv.handle) {
    resources.color_srv = {0};
    resources.color_resource = {0};
  }
  if (h == resources.velocity_rtv.handle) {
    resources.velocity_rtv = {0};
  }
  if (h == resources.depth_srv.handle) {
    resources.depth_srv = {0};
  }
}

struct PreviousComputeState {
  // The resolve is inserted before a graphics draw, but it still changes
  // compute bindings. Restore only compute state so later compute work is not
  // polluted without rebinding the graphics state the pending draw already has.
  std::array<std::pair<reshade::api::pipeline_stage, reshade::api::pipeline>, 4> pipelines = {};
  uint32_t pipeline_count = 0u;
  reshade::api::pipeline_layout layout = {0};
  std::vector<reshade::api::descriptor_table> descriptor_tables;
};

inline bool IsComputePipelineStage(reshade::api::pipeline_stage stage) {
  return (static_cast<uint32_t>(stage) & static_cast<uint32_t>(reshade::api::pipeline_stage::all_compute)) != 0u;
}

inline PreviousComputeState CaptureComputeState(reshade::api::command_list* cmd_list) {
  PreviousComputeState result = {};
  const auto* current_state = renodx::utils::state::GetCurrentState(cmd_list);
  if (current_state == nullptr) return result;

  for (const auto& [stage, pipeline] : current_state->pipelines) {
    if (!IsComputePipelineStage(stage) || result.pipeline_count >= result.pipelines.size()) continue;
    result.pipelines[result.pipeline_count++] = {stage, pipeline};
  }
  result.layout = current_state->compute_pipeline_layout;
  result.descriptor_tables = current_state->compute_descriptor_tables;
  return result;
}

inline void RestoreComputeState(reshade::api::command_list* cmd_list, const PreviousComputeState& state) {
  for (uint32_t i = 0u; i < state.pipeline_count; ++i) {
    cmd_list->bind_pipeline(state.pipelines[i].first, state.pipelines[i].second);
  }

  if (state.layout.handle != 0u) {
    cmd_list->bind_descriptor_tables(
        reshade::api::shader_stage::all_compute,
        state.layout,
        0,
        static_cast<uint32_t>(state.descriptor_tables.size()),
        state.descriptor_tables.data());
  }
}

inline void DestroyCompute(reshade::api::device* device) {
  if (device == nullptr) return;

  if (resources.compute_pipeline.handle != 0u) {
    device->destroy_pipeline(resources.compute_pipeline);
    resources.compute_pipeline = {0};
  }
  if (resources.compute_layout.handle != 0u) {
    device->destroy_pipeline_layout(resources.compute_layout);
    resources.compute_layout = {0};
  }
  for (auto& sampler : resources.samplers) {
    if (sampler.handle != 0u) device->destroy_sampler(sampler);
    sampler = {0};
  }
}

inline void DestroyHistory(reshade::api::device* device) {
  if (device == nullptr) return;

  const bool had_history = resources.history[0].resource.handle != 0u || resources.history[1].resource.handle != 0u;
  for (auto& item : resources.history) {
    if (item.srv.handle != 0u) device->destroy_resource_view(item.srv);
    if (item.uav.handle != 0u) device->destroy_resource_view(item.uav);
    if (item.resource.handle != 0u) device->destroy_resource(item.resource);
    item = {};
  }
  resources.width = 0u;
  resources.height = 0u;
  resources.resource_format = reshade::api::format::unknown;
  resources.view_format = reshade::api::format::unknown;
  resources.color_srv = {0};
  resources.color_resource = {0};
  resources.accum_index = 0u;
  resources.initialized = false;

  if (had_history) logging::Info("destroyed TAA history");
}

inline void DestroyVelocitySrv(reshade::api::device* device) {
  if (device == nullptr) return;
  if (resources.velocity_srv.handle != 0u) device->destroy_resource_view(resources.velocity_srv);
  resources.velocity_resource = {0};
  resources.velocity_rtv = {0};
  resources.velocity_srv = {0};
  resources.velocity_view_format = reshade::api::format::unknown;
}

inline void Destroy(reshade::api::device* device) {
  DestroyCompute(device);
  DestroyHistory(device);
  DestroyVelocitySrv(device);
  resources = {};
}

inline bool EnsureComputePipeline(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  if (device == nullptr) return false;

  if (resources.compute_layout.handle != 0u && resources.compute_pipeline.handle != 0u
      && resources.samplers[0].handle != 0u && resources.samplers[1].handle != 0u) {
    return true;
  }

  DestroyCompute(device);

  // Layout mirrors the shader registers:
  // s0-s1 samplers, t0-t3 inputs, u0 output history, and b11 shader injection.
  std::array<reshade::api::pipeline_layout_param, 4> params = {};
  params[0].type = reshade::api::pipeline_layout_param_type::push_descriptors;
  params[0].push_descriptors.count = 2;
  params[0].push_descriptors.type = reshade::api::descriptor_type::sampler;
  params[0].push_descriptors.dx_register_index = 0;
  params[0].push_descriptors.dx_register_space = 0;

  params[1].type = reshade::api::pipeline_layout_param_type::push_descriptors;
  params[1].push_descriptors.count = 4;
  params[1].push_descriptors.type = reshade::api::descriptor_type::texture_shader_resource_view;
  params[1].push_descriptors.dx_register_index = 0;
  params[1].push_descriptors.dx_register_space = 0;

  params[2].type = reshade::api::pipeline_layout_param_type::push_descriptors;
  params[2].push_descriptors.count = 1;
  params[2].push_descriptors.type = reshade::api::descriptor_type::texture_unordered_access_view;
  params[2].push_descriptors.dx_register_index = 0;
  params[2].push_descriptors.dx_register_space = 0;

  params[3].type = reshade::api::pipeline_layout_param_type::push_constants;
  params[3].push_constants.count = sizeof(ShaderInjectData) / sizeof(uint32_t);
  params[3].push_constants.dx_register_index = 11;
  params[3].push_constants.dx_register_space = 0;
  params[3].push_constants.visibility = reshade::api::shader_stage::compute;

  if (!device->create_pipeline_layout(static_cast<uint32_t>(params.size()), params.data(), &resources.compute_layout)) {
    if (LogEvery(last_compute_fail_log)) logging::Warn("failed to create TAA compute pipeline layout");
    DestroyCompute(device);
    return false;
  }

  const std::array<reshade::api::sampler_desc, 2> sampler_descs = {
      reshade::api::sampler_desc{.filter = reshade::api::filter_mode::min_mag_mip_linear},
      reshade::api::sampler_desc{.filter = reshade::api::filter_mode::min_mag_mip_point},
  };

  for (size_t i = 0; i < sampler_descs.size(); ++i) {
    if (!device->create_sampler(sampler_descs[i], &resources.samplers[i])) {
      if (LogEvery(last_compute_fail_log)) logging::Warn("failed to create TAA sampler index=", i);
      DestroyCompute(device);
      return false;
    }
  }

  reshade::api::shader_desc cs_desc = {
      .code = __aliasisolation_taa.data(),
      .code_size = __aliasisolation_taa.size(),
  };
  reshade::api::pipeline_subobject cs = {
      .type = reshade::api::pipeline_subobject_type::compute_shader,
      .count = 1,
      .data = &cs_desc,
  };

  if (!device->create_pipeline(resources.compute_layout, 1, &cs, &resources.compute_pipeline)) {
    if (LogEvery(last_compute_fail_log)) logging::Warn("failed to create TAA compute pipeline");
    DestroyCompute(device);
    return false;
  }

  logging::Info("created TAA compute pipeline layout=", logging::Hex(resources.compute_layout.handle),
                " pipeline=", logging::Hex(resources.compute_pipeline.handle));
  return true;
}

inline bool GetSupportedHistoryFormat(
    const reshade::api::resource_desc& color_desc,
    const reshade::api::resource_view_desc& color_view_desc,
    reshade::api::format& resource_format,
    reshade::api::format& view_format) {
  // Match the current HDR resource when possible. Typeless R16G16B16A16
  // resources use float typed SRV/UAV views so history can be sampled and
  // written by the compute resolve.
  resource_format = color_desc.texture.format;
  view_format = color_view_desc.format != reshade::api::format::unknown
                    ? color_view_desc.format
                    : reshade::api::format_to_default_typed(resource_format);

  if (resource_format == reshade::api::format::r16g16b16a16_typeless) {
    view_format = reshade::api::format::r16g16b16a16_float;
    return true;
  }
  if (resource_format == reshade::api::format::r16g16b16a16_float) {
    view_format = reshade::api::format::r16g16b16a16_float;
    return true;
  }
  if (resource_format == reshade::api::format::r11g11b10_float) {
    view_format = reshade::api::format::r11g11b10_float;
    return true;
  }

  if (view_format == reshade::api::format::r16g16b16a16_float) {
    resource_format = reshade::api::format::r16g16b16a16_typeless;
    return true;
  }
  return false;
}

inline bool EnsureHistory(reshade::api::command_list* cmd_list, reshade::api::resource_view color_srv, reshade::api::resource& color_resource) {
  auto* device = cmd_list->get_device();
  if (device == nullptr || color_srv.handle == 0u) return false;

  if (resources.history[0].resource.handle != 0u
      && resources.color_srv.handle == color_srv.handle
      && resources.color_resource.handle != 0u) {
    color_resource = resources.color_resource;
    return true;
  }

  color_resource = device->get_resource_from_view(color_srv);
  if (color_resource.handle == 0u) return false;

  const auto color_desc = device->get_resource_desc(color_resource);
  const auto color_view_desc = device->get_resource_view_desc(color_srv);
  reshade::api::format resource_format = reshade::api::format::unknown;
  reshade::api::format view_format = reshade::api::format::unknown;
  if (!GetSupportedHistoryFormat(color_desc, color_view_desc, resource_format, view_format)) {
    if (LogEvery(last_history_format_log)) {
      logging::Warn("unsupported TAA color format resource_format=", static_cast<uint32_t>(color_desc.texture.format),
                    " view_format=", static_cast<uint32_t>(color_view_desc.format),
                    " frame=", constant_buffers::frame_state.frame_index);
    }
    return false;
  }

  const bool matches = resources.history[0].resource.handle != 0u
                       && resources.width == color_desc.texture.width
                       && resources.height == color_desc.texture.height
                       && resources.resource_format == resource_format
                       && resources.view_format == view_format;
  if (matches) {
    resources.color_srv = color_srv;
    resources.color_resource = color_resource;
    return true;
  }

  // Recreate history when resolution or HDR format changes, then seed both
  // buffers from the current color so the first resolve does not blend with
  // uninitialized history.
  DestroyHistory(device);

  reshade::api::resource_desc desc = {};
  desc.type = reshade::api::resource_type::texture_2d;
  desc.texture = {
      color_desc.texture.width,
      color_desc.texture.height,
      1,
      1,
      resource_format,
      1,
  };
  desc.heap = reshade::api::memory_heap::gpu_only;
  desc.usage = reshade::api::resource_usage::shader_resource
               | reshade::api::resource_usage::unordered_access
               | reshade::api::resource_usage::copy_source
               | reshade::api::resource_usage::copy_dest;
  desc.flags = reshade::api::resource_flags::none;

  const auto srv_desc = reshade::api::resource_view_desc(reshade::api::resource_view_type::texture_2d, view_format, 0, 1, 0, 1);
  const auto uav_desc = reshade::api::resource_view_desc(reshade::api::resource_view_type::texture_2d, view_format, 0, 1, 0, 1);

  for (auto& item : resources.history) {
    if (!device->create_resource(desc, nullptr, reshade::api::resource_usage::shader_resource, &item.resource)) {
      if (LogEvery(last_history_create_fail_log)) logging::Warn("failed to create TAA history resource");
      DestroyHistory(device);
      return false;
    }
    if (!device->create_resource_view(item.resource, reshade::api::resource_usage::shader_resource, srv_desc, &item.srv)) {
      if (LogEvery(last_history_create_fail_log)) logging::Warn("failed to create TAA history SRV");
      DestroyHistory(device);
      return false;
    }
    if (!device->create_resource_view(item.resource, reshade::api::resource_usage::unordered_access, uav_desc, &item.uav)) {
      if (LogEvery(last_history_create_fail_log)) logging::Warn("failed to create TAA history UAV");
      DestroyHistory(device);
      return false;
    }
  }

  resources.width = color_desc.texture.width;
  resources.height = color_desc.texture.height;
  resources.resource_format = resource_format;
  resources.view_format = view_format;
  resources.color_srv = color_srv;
  resources.color_resource = color_resource;
  resources.accum_index = 0u;
  resources.initialized = true;

  cmd_list->barrier(color_resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::copy_source);
  for (auto& item : resources.history) {
    cmd_list->barrier(item.resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::copy_dest);
    cmd_list->copy_resource(color_resource, item.resource);
    cmd_list->barrier(item.resource, reshade::api::resource_usage::copy_dest, reshade::api::resource_usage::shader_resource);
  }
  cmd_list->barrier(color_resource, reshade::api::resource_usage::copy_source, reshade::api::resource_usage::shader_resource);

  logging::Info("created TAA history ", resources.width, "x", resources.height,
                " resource_format=", static_cast<uint32_t>(resources.resource_format),
                " view_format=", static_cast<uint32_t>(resources.view_format));
  return true;
}

inline reshade::api::format GetTypedViewFormat(reshade::api::device* device, reshade::api::resource_view view) {
  const auto view_desc = device->get_resource_view_desc(view);
  if (view_desc.format != reshade::api::format::unknown) return view_desc.format;
  const auto resource = device->get_resource_from_view(view);
  const auto desc = device->get_resource_desc(resource);
  return reshade::api::format_to_default_typed(desc.texture.format);
}

inline bool EnsureVelocitySrv(reshade::api::command_list* cmd_list, reshade::api::resource_view velocity_rtv) {
  auto* device = cmd_list->get_device();
  if (device == nullptr || velocity_rtv.handle == 0u) return false;

  if (resources.velocity_srv.handle != 0u
      && resources.velocity_rtv.handle == velocity_rtv.handle
      && resources.velocity_resource.handle != 0u) {
    return true;
  }

  const auto velocity_resource = device->get_resource_from_view(velocity_rtv);
  if (velocity_resource.handle == 0u) return false;

  const auto view_format = GetTypedViewFormat(device, velocity_rtv);
  if (resources.velocity_srv.handle != 0u
      && resources.velocity_resource.handle == velocity_resource.handle
      && resources.velocity_view_format == view_format) {
    return true;
  }

  DestroyVelocitySrv(device);

  // Camera motion writes velocity as an RTV; the TAA compute shader needs an SRV
  // of that same texture.
  const auto view_desc = reshade::api::resource_view_desc(reshade::api::resource_view_type::texture_2d, view_format, 0, 1, 0, 1);
  if (!device->create_resource_view(velocity_resource, reshade::api::resource_usage::shader_resource, view_desc, &resources.velocity_srv)) {
    resources.velocity_resource = {0};
    resources.velocity_view_format = reshade::api::format::unknown;
    logging::Warn("failed to create velocity SRV view_format=", static_cast<uint32_t>(view_format));
    return false;
  }

  resources.velocity_resource = velocity_resource;
  resources.velocity_rtv = velocity_rtv;
  resources.velocity_view_format = view_format;
  logging::Info("created velocity SRV resource=", logging::Hex(velocity_resource.handle),
                " view_format=", static_cast<uint32_t>(view_format));
  return true;
}

inline void CaptureCameraMotion(
    reshade::api::command_list* cmd_list,
    const descriptor_tracker::CommandListData& command_data,
    reshade::api::resource_view velocity_rtv) {
  if (velocity_rtv.handle == 0u) {
    if (LogEvery(last_capture_missing_log)) logging::Warn("camera motion pass has no RTVs");
    return;
  }

  // Alias Isolation uses pixel t8 from the camera-motion pass as depth.
  const auto depth_srv = command_data.pixel_srv_t8;
  if (velocity_rtv.handle == 0u || depth_srv.handle == 0u) {
    if (LogEvery(last_capture_missing_log)) {
      logging::Warn("camera motion capture missing input velocity_rtv=", logging::Hex(velocity_rtv.handle),
                    " depth_srv_t8=", logging::Hex(depth_srv.handle));
    }
    return;
  }
  if (!EnsureVelocitySrv(cmd_list, velocity_rtv)) return;

  resources.depth_srv = depth_srv;
  resources.capture_frame = constant_buffers::frame_state.frame_index;

  if (LogEvery(last_capture_log)) {
    logging::Info("captured camera motion inputs frame=", resources.capture_frame,
                  " velocity_srv=", logging::Hex(resources.velocity_srv.handle),
                  " depth_srv=", logging::Hex(resources.depth_srv.handle));
  }
}

inline bool DispatchCompute(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view color_srv,
    reshade::api::resource color_resource,
    uint32_t current,
    uint32_t previous) {
  if (!EnsureComputePipeline(cmd_list)) return false;
  if (shader_injection == nullptr) {
    if (LogEvery(last_compute_fail_log)) logging::Warn("TAA compute dispatch missing shader injection data");
    return false;
  }

  const PreviousComputeState previous_compute_state = CaptureComputeState(cmd_list);

  const std::array<reshade::api::resource_view, 4> srvs = {
      color_srv,
      resources.history[previous].srv,
      resources.velocity_srv,
      resources.depth_srv,
  };
  const std::array<reshade::api::resource_view, 1> uavs = {
      resources.history[current].uav,
  };

  const std::array<reshade::api::descriptor_table_update, 3> updates = {
      reshade::api::descriptor_table_update{
          .table = {},
          .binding = 0,
          .array_offset = 0,
          .count = static_cast<uint32_t>(resources.samplers.size()),
          .type = reshade::api::descriptor_type::sampler,
          .descriptors = resources.samplers.data(),
      },
      reshade::api::descriptor_table_update{
          .table = {},
          .binding = 0,
          .array_offset = 0,
          .count = static_cast<uint32_t>(srvs.size()),
          .type = reshade::api::descriptor_type::texture_shader_resource_view,
          .descriptors = srvs.data(),
      },
      reshade::api::descriptor_table_update{
          .table = {},
          .binding = 0,
          .array_offset = 0,
          .count = static_cast<uint32_t>(uavs.size()),
          .type = reshade::api::descriptor_type::texture_unordered_access_view,
          .descriptors = uavs.data(),
      },
  };

  cmd_list->barrier(resources.velocity_resource, reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource);
  cmd_list->barrier(resources.history[current].resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::unordered_access);

  // Bind the compute pass directly instead of using mods::shader so this port
  // stays self-contained and independent from CRC32 shader replacement.
  cmd_list->push_descriptors(reshade::api::shader_stage::all_compute, resources.compute_layout, 0, updates[0]);
  cmd_list->push_descriptors(reshade::api::shader_stage::all_compute, resources.compute_layout, 1, updates[1]);
  cmd_list->push_descriptors(reshade::api::shader_stage::all_compute, resources.compute_layout, 2, updates[2]);
  cmd_list->push_constants(
      reshade::api::shader_stage::all_compute,
      resources.compute_layout,
      3,
      0,
      sizeof(ShaderInjectData) / sizeof(uint32_t),
      shader_injection);
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_compute, resources.compute_pipeline);
  cmd_list->dispatch((resources.width + 7u) / 8u, (resources.height + 7u) / 8u, 1u);

  cmd_list->barrier(resources.history[current].resource, reshade::api::resource_usage::unordered_access, reshade::api::resource_usage::copy_source);
  cmd_list->barrier(color_resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::copy_dest);
  cmd_list->copy_resource(resources.history[current].resource, color_resource);
  cmd_list->barrier(color_resource, reshade::api::resource_usage::copy_dest, reshade::api::resource_usage::shader_resource);
  cmd_list->barrier(resources.history[current].resource, reshade::api::resource_usage::copy_source, reshade::api::resource_usage::shader_resource);
  cmd_list->barrier(resources.velocity_resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::render_target);

  RestoreComputeState(cmd_list, previous_compute_state);
  return true;
}

inline bool Run(reshade::api::command_list* cmd_list, reshade::api::resource_view color_srv) {
  if (resources.velocity_srv.handle == 0u || resources.depth_srv.handle == 0u) {
    if (LogEvery(last_missing_inputs_log)) {
      logging::Warn("TAA insertion reached without velocity/depth velocity_srv=", logging::Hex(resources.velocity_srv.handle),
                    " depth_srv=", logging::Hex(resources.depth_srv.handle));
    }
    return false;
  }
  if (resources.capture_frame != constant_buffers::frame_state.frame_index) {
    if (LogEvery(last_stale_capture_log)) {
      logging::Warn("TAA insertion reached with stale camera motion capture capture_frame=", resources.capture_frame,
                    " frame=", constant_buffers::frame_state.frame_index);
    }
    return false;
  }
  reshade::api::resource color_resource = {0};
  if (!EnsureHistory(cmd_list, color_srv, color_resource)) return false;

  const uint32_t current = resources.accum_index;
  const uint32_t previous = 1u - current;

  if (!DispatchCompute(cmd_list, color_srv, color_resource, current, previous)) {
    if (LogEvery(last_compute_fail_log)) logging::Warn("TAA compute dispatch setup failed");
    return false;
  }

  if (LogEvery(last_dispatch_log)) {
    logging::Info("dispatched TAA frame=", constant_buffers::frame_state.frame_index,
                  " size=", resources.width, "x", resources.height,
                  " history_current=", current,
                  " history_previous=", previous);
  }

  resources.accum_index = previous;
  constant_buffers::MarkTaaDispatched();
  return true;
}

inline bool MaybeRun(
    reshade::api::command_list* cmd_list,
    const descriptor_tracker::CommandListData& command_data,
    InsertionPoint insertion_point) {
  if (!constant_buffers::IsEnabled()) return false;
  if (constant_buffers::frame_state.taa_ran_this_frame) return false;
  if (insertion_point == InsertionPoint::None) return false;

  // Prefer DoF encode, matching the original mod. RGBM encode is a later
  // fallback in case the DoF path is absent for a scene/frame.
  if (insertion_point == InsertionPoint::DofEncode && !logged_dof_insertion) {
    logged_dof_insertion = true;
    logging::Info("using DoF encode insertion point for TAA");
  }
  if (insertion_point == InsertionPoint::RgbmEncode && !logged_rgbm_insertion) {
    logged_rgbm_insertion = true;
    logging::Info("using RGBM encode insertion point for TAA fallback");
  }

  const auto color_srv = command_data.pixel_srv_t0;
  if (color_srv.handle == 0u) {
    if (LogEvery(last_missing_color_log)) {
      logging::Warn("TAA insertion point has no color SRV at pixel t0 frame=", constant_buffers::frame_state.frame_index,
                    " insertion=", InsertionPointName(insertion_point));
    }
    return false;
  }
  return Run(cmd_list, color_srv);
}

}  // namespace alienisolation::aliasisolation::taa
