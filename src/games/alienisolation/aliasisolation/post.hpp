#pragma once

#include <array>
#include <cstdint>
#include <span>

#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../../utils/render.hpp"
#include "../../../utils/resource.hpp"
#include "../shared.h"
#include "./constant_buffers.hpp"
#include "./descriptor_tracker.hpp"
#include "./logging.hpp"

namespace alienisolation::aliasisolation::post {

struct TempTexture {
  reshade::api::resource resource = {0};
  reshade::api::resource_view srv = {0};
  reshade::api::resource_view rtv = {0};
  uint32_t width = 0u;
  uint32_t height = 0u;
  reshade::api::format resource_format = reshade::api::format::unknown;
  reshade::api::format view_format = reshade::api::format::unknown;
};

struct Resources {
  renodx::utils::render::RenderPass sharpen_pass;
  renodx::utils::render::RenderPass ca_pass;
  TempTexture temp;
  reshade::api::format pipeline_format = reshade::api::format::unknown;
};

inline Resources resources;
inline uint64_t last_final_blit_log = UINT64_MAX;
inline uint64_t last_post_run_log = UINT64_MAX;
inline uint64_t last_post_failure_log = UINT64_MAX;
inline uint64_t last_temp_log = UINT64_MAX;

inline bool LogEvery(uint64_t& last_frame, uint64_t interval = 120u) {
  return logging::ShouldLogFrame(constant_buffers::frame_state.frame_index, last_frame, interval);
}

inline void DestroyTemp(reshade::api::device* device) {
  if (device == nullptr) return;
  if (resources.temp.srv.handle != 0u) device->destroy_resource_view(resources.temp.srv);
  if (resources.temp.rtv.handle != 0u) device->destroy_resource_view(resources.temp.rtv);
  if (resources.temp.resource.handle != 0u) device->destroy_resource(resources.temp.resource);
  resources.temp = {};
}

inline void Destroy(reshade::api::device* device) {
  resources.sharpen_pass.DestroyAll(device);
  resources.ca_pass.DestroyAll(device);
  DestroyTemp(device);
  resources = {};
}

inline reshade::api::format GetTypedViewFormat(reshade::api::device* device, reshade::api::resource_view view) {
  auto view_desc = device->get_resource_view_desc(view);
  if (view_desc.format != reshade::api::format::unknown) return view_desc.format;

  const auto resource = device->get_resource_from_view(view);
  const auto desc = device->get_resource_desc(resource);
  return reshade::api::format_to_default_typed(desc.texture.format);
}

inline void LogViews(
    const char* label,
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view source_srv,
    reshade::api::resource_view target_rtv,
    uint64_t& last_frame) {
  if (!LogEvery(last_frame)) return;

  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  if (device == nullptr) return;

  const auto source_resource = device->get_resource_from_view(source_srv);
  const auto target_resource = device->get_resource_from_view(target_rtv);
  const auto source_view_desc = source_srv.handle != 0u ? device->get_resource_view_desc(source_srv) : reshade::api::resource_view_desc{};
  const auto target_view_desc = target_rtv.handle != 0u ? device->get_resource_view_desc(target_rtv) : reshade::api::resource_view_desc{};
  const auto source_desc = source_resource.handle != 0u ? device->get_resource_desc(source_resource) : reshade::api::resource_desc{};
  const auto target_desc = target_resource.handle != 0u ? device->get_resource_desc(target_resource) : reshade::api::resource_desc{};

  logging::Info(label,
                " frame=", constant_buffers::frame_state.frame_index,
                " source_srv=", logging::Hex(source_srv.handle),
                " source_res=", logging::Hex(source_resource.handle),
                " source_size=", source_desc.texture.width, "x", source_desc.texture.height,
                " source_resource_format=", static_cast<uint32_t>(source_desc.texture.format),
                " source_view_format=", static_cast<uint32_t>(source_view_desc.format),
                " target_rtv=", logging::Hex(target_rtv.handle),
                " target_res=", logging::Hex(target_resource.handle),
                " target_size=", target_desc.texture.width, "x", target_desc.texture.height,
                " target_resource_format=", static_cast<uint32_t>(target_desc.texture.format),
                " target_view_format=", static_cast<uint32_t>(target_view_desc.format));
}

inline bool EnsurePasses(reshade::api::command_list* cmd_list, reshade::api::format target_format) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;

  if (resources.pipeline_format != target_format) {
    resources.sharpen_pass.DestroyAll(device);
    resources.ca_pass.DestroyAll(device);
    resources.sharpen_pass = {};
    resources.ca_pass = {};
    resources.pipeline_format = target_format;
    logging::Info("post pipeline target format changed to ", static_cast<uint32_t>(target_format));
  }

  auto setup_common = [&](renodx::utils::render::RenderPass& pass, std::span<const uint8_t> ps) {
    if (pass.pipeline_subobjects.pixel_shader.empty()) {
      pass.pipeline_subobjects.vertex_shader = __swap_chain_proxy_vertex_shader;
      pass.pipeline_subobjects.pixel_shader = ps;
      pass.pipeline_subobjects.render_target_formats = {target_format};
      pass.auto_generate_render_target_formats = false;
      pass.sampler_descs = {
          reshade::api::sampler_desc{.filter = reshade::api::filter_mode::min_mag_mip_linear},
          reshade::api::sampler_desc{.filter = reshade::api::filter_mode::min_mag_mip_point},
      };
    }
  };

  setup_common(resources.sharpen_pass, __aliasisolation_sharpen);
  setup_common(resources.ca_pass, __aliasisolation_chromatic_aberration);
  return true;
}

inline bool EnsureTemp(reshade::api::command_list* cmd_list, reshade::api::resource_view target_rtv) {
  auto* device = cmd_list->get_device();
  if (device == nullptr || target_rtv.handle == 0u) return false;

  const auto target_resource = device->get_resource_from_view(target_rtv);
  if (target_resource.handle == 0u) return false;

  const auto target_desc = device->get_resource_desc(target_resource);
  const auto view_format = GetTypedViewFormat(device, target_rtv);
  auto resource_format = reshade::api::format_to_typeless(view_format);
  if (resource_format == reshade::api::format::unknown) resource_format = view_format;

  if (resources.temp.resource.handle != 0u
      && resources.temp.width == target_desc.texture.width
      && resources.temp.height == target_desc.texture.height
      && resources.temp.resource_format == resource_format
      && resources.temp.view_format == view_format) {
    return true;
  }

  DestroyTemp(device);

  reshade::api::resource_desc desc = {};
  desc.type = reshade::api::resource_type::texture_2d;
  desc.texture = {
      target_desc.texture.width,
      target_desc.texture.height,
      1,
      1,
      resource_format,
      1,
  };
  desc.heap = reshade::api::memory_heap::gpu_only;
  desc.usage = reshade::api::resource_usage::render_target | reshade::api::resource_usage::shader_resource;
  desc.flags = reshade::api::resource_flags::none;

  if (!device->create_resource(desc, nullptr, reshade::api::resource_usage::shader_resource, &resources.temp.resource)) return false;

  const auto view_desc = reshade::api::resource_view_desc(reshade::api::resource_view_type::texture_2d, view_format, 0, 1, 0, 1);
  if (!device->create_resource_view(resources.temp.resource, reshade::api::resource_usage::render_target, view_desc, &resources.temp.rtv)) {
    DestroyTemp(device);
    return false;
  }
  if (!device->create_resource_view(resources.temp.resource, reshade::api::resource_usage::shader_resource, view_desc, &resources.temp.srv)) {
    DestroyTemp(device);
    return false;
  }

  resources.temp.width = target_desc.texture.width;
  resources.temp.height = target_desc.texture.height;
  resources.temp.resource_format = resource_format;
  resources.temp.view_format = view_format;

  if (LogEvery(last_temp_log, 1u)) {
    logging::Info("created post temp ", resources.temp.width, "x", resources.temp.height,
                  " resource_format=", static_cast<uint32_t>(resources.temp.resource_format),
                  " view_format=", static_cast<uint32_t>(resources.temp.view_format));
  }
  return true;
}

inline bool RenderPass(
    reshade::api::command_list* cmd_list,
    renodx::utils::render::RenderPass& pass,
    reshade::api::resource_view source_srv,
    reshade::api::resource_view target_rtv,
    ShaderInjectData* injected_data) {
  if (source_srv.handle == 0u || target_rtv.handle == 0u || injected_data == nullptr) {
    if (LogEvery(last_post_failure_log)) {
      logging::Warn("post render input invalid source_srv=", logging::Hex(source_srv.handle),
                    " target_rtv=", logging::Hex(target_rtv.handle),
                    " injected_data=", logging::Bool(injected_data != nullptr));
    }
    return false;
  }

  pass.render_target_slots.views = {target_rtv};
  pass.render_target_slots.render_pass_descs.clear();
  pass.shader_resource_slots.views = {source_srv};
  pass.auto_generate_descriptor_table_updates = true;
  pass.descriptor_table_updates.clear();
  pass.auto_generate_viewport = true;
  pass.viewports.clear();
  pass.auto_generate_scissors = true;
  pass.scissors.clear();
  pass.push_constants.clear();
  pass.push_constants[{11, 0}] = std::span<const float>(reinterpret_cast<const float*>(injected_data), sizeof(ShaderInjectData) / sizeof(float));

  const bool rendered = pass.Render(cmd_list);
  if (!rendered && LogEvery(last_post_failure_log)) {
    LogViews("post render pass failed", cmd_list, source_srv, target_rtv, last_post_failure_log);
  }
  return rendered;
}

inline bool RunNeutralBlit(
    reshade::api::command_list* cmd_list,
    const descriptor_tracker::CommandListData& command_data,
    ShaderInjectData* injected_data) {
  if (command_data.render_targets.empty()) {
    if (LogEvery(last_post_failure_log)) logging::Warn("neutral final blit has no RTV");
    return false;
  }

  const auto target_rtv = command_data.render_targets[0];
  const auto source_srv = descriptor_tracker::GetView(command_data.pixel_srvs, 0u);
  if (target_rtv.handle == 0u || source_srv.handle == 0u) {
    if (LogEvery(last_post_failure_log)) {
      logging::Warn("neutral final blit missing views source_srv=", logging::Hex(source_srv.handle),
                    " target_rtv=", logging::Hex(target_rtv.handle));
    }
    return false;
  }

  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;

  const auto target_format = GetTypedViewFormat(device, target_rtv);
  if (target_format == reshade::api::format::unknown) return false;
  if (!EnsurePasses(cmd_list, target_format)) return false;

  ShaderInjectData neutral = injected_data != nullptr ? *injected_data : ShaderInjectData{};
  neutral.fxSharpening = 0.f;
  neutral.fxChromaticAberration = 0.f;

  LogViews("neutral final blit", cmd_list, source_srv, target_rtv, last_final_blit_log);
  return RenderPass(cmd_list, resources.sharpen_pass, source_srv, target_rtv, &neutral);
}

inline bool Run(
    reshade::api::command_list* cmd_list,
    const descriptor_tracker::CommandListData& command_data,
    ShaderInjectData* injected_data) {
  if (command_data.render_targets.empty()) return false;
  const auto target_rtv = command_data.render_targets[0];
  const auto source_srv = descriptor_tracker::GetView(command_data.pixel_srvs, 0u);
  if (target_rtv.handle == 0u || source_srv.handle == 0u) return false;

  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;

  const auto target_format = GetTypedViewFormat(device, target_rtv);
  if (target_format == reshade::api::format::unknown) return false;
  if (!EnsurePasses(cmd_list, target_format)) return false;

  LogViews("alias post effects", cmd_list, source_srv, target_rtv, last_post_run_log);

  if (injected_data != nullptr && injected_data->fxChromaticAberration > 0.f) {
    if (!EnsureTemp(cmd_list, target_rtv)) return false;
    if (!RenderPass(cmd_list, resources.sharpen_pass, source_srv, resources.temp.rtv, injected_data)) return false;
    return RenderPass(cmd_list, resources.ca_pass, resources.temp.srv, target_rtv, injected_data);
  }

  return RenderPass(cmd_list, resources.sharpen_pass, source_srv, target_rtv, injected_data);
}

}  // namespace alienisolation::aliasisolation::post
