#pragma once

// Toggle this to 0 to compile out all LUT writer discovery code.
#ifndef IMMORTALS_DUMP_LUT_ENABLED
#define IMMORTALS_DUMP_LUT_ENABLED 0
#endif

#if IMMORTALS_DUMP_LUT_ENABLED
#include <array>
#include <cstdint>
#include <limits>
#include <map>
#include <optional>
#include <sstream>
#include <string>
#include <unordered_set>
#include <vector>

#include <include/reshade.hpp>

#include "../../utils/bitwise.hpp"
#include "../../utils/data.hpp"
#include "../../utils/format.hpp"
#include "../../utils/path.hpp"
#include "../../utils/pipeline_layout.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/shader_dump.hpp"
#endif

namespace dump_lut {

#if IMMORTALS_DUMP_LUT_ENABLED

inline constexpr std::uint32_t TARGET_LUT_SIZE = 32u;
inline constexpr const char* DUMP_PREFIX_KNOWN_PIXEL = "lut_writer_ps_";
inline constexpr const char* DUMP_PREFIX_NEW_PIXEL = "lut_writer_new_ps_";
inline constexpr const char* DUMP_PREFIX_KNOWN_COMPUTE = "lut_writer_cs_";
inline constexpr const char* DUMP_PREFIX_NEW_COMPUTE = "lut_writer_new_cs_";

inline std::unordered_set<std::uint64_t> target_lut_resources = {};
inline std::unordered_set<std::uint32_t> dumped_shaders = {};
inline bool (*is_shader_in_addon)(std::uint32_t shader_hash) = nullptr;

inline void SetShaderInAddonCallback(bool (*callback)(std::uint32_t shader_hash)) {
  is_shader_in_addon = callback;
}

inline bool IsShaderInAddon(std::uint32_t shader_hash) {
  return is_shader_in_addon != nullptr && is_shader_in_addon(shader_hash);
}

struct TargetMatch {
  reshade::api::resource resource = {0u};
  std::string binding;
};

struct __declspec(uuid("87f0d4b1-3374-4f4f-b266-0fffbfa70432")) CommandListData {
  std::map<std::pair<std::uint32_t, std::uint32_t>, reshade::api::resource_view> pixel_uav_binds;
  std::map<std::pair<std::uint32_t, std::uint32_t>, reshade::api::resource_view> compute_uav_binds;
  std::vector<reshade::api::resource_view> render_targets;
};

inline bool IsTargetFormat(reshade::api::format format) {
  return format == reshade::api::format::r16g16b16a16_float
         || format == reshade::api::format::r16g16b16a16_typeless;
}

inline bool IsTargetLutDesc(const reshade::api::resource_desc& desc) {
  return desc.type == reshade::api::resource_type::texture_3d
         && desc.texture.width == TARGET_LUT_SIZE
         && desc.texture.height == TARGET_LUT_SIZE
         && desc.texture.depth_or_layers == TARGET_LUT_SIZE
         && IsTargetFormat(desc.texture.format);
}

inline void LogTargetResource(const char* action, reshade::api::resource resource, const reshade::api::resource_desc& desc) {
  std::stringstream s;
  s << "Immortals LUT dump: " << action << " 32x32x32 RGBA16F Texture3D resource "
    << "0x" << std::hex << resource.handle << std::dec
    << ", format: " << desc.texture.format;
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
}

inline bool TrackIfTargetLutResource(reshade::api::resource resource, const reshade::api::resource_desc& desc) {
  if (resource.handle == 0u || !IsTargetLutDesc(desc)) return false;
  const bool inserted = target_lut_resources.emplace(resource.handle).second;
  if (inserted) LogTargetResource("created", resource, desc);
  return true;
}

inline bool IsTargetLutResource(reshade::api::device* device, reshade::api::resource resource) {
  if (device == nullptr || resource.handle == 0u) return false;
  if (target_lut_resources.contains(resource.handle)) return true;

  const auto desc = device->get_resource_desc(resource);
  return TrackIfTargetLutResource(resource, desc);
}

inline bool IsTargetLutView(reshade::api::device* device, reshade::api::resource_view view, reshade::api::resource* resource = nullptr) {
  if (device == nullptr || view.handle == 0u) return false;

  const auto original_resource = renodx::utils::resource::GetResourceFromView(device, view);
  if (original_resource.handle == 0u) return false;

  if (resource != nullptr) *resource = original_resource;
  return IsTargetLutResource(device, original_resource);
}

inline CommandListData* GetOrCreateCommandListData(reshade::api::command_list* cmd_list) {
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (data == nullptr) {
    data = renodx::utils::data::Create<CommandListData>(cmd_list);
  }
  return data;
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

inline void OnResetCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CommandListData>(cmd_list);
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

inline void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

inline void OnInitResource(
    reshade::api::device* /*device*/,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* /*initial_data*/,
    reshade::api::resource_usage /*initial_state*/,
    reshade::api::resource resource) {
  TrackIfTargetLutResource(resource, desc);
}

inline void OnDestroyResource(reshade::api::device* /*device*/, reshade::api::resource resource) {
  if (resource.handle == 0u) return;
  target_lut_resources.erase(resource.handle);
}

inline void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    std::uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view /*dsv*/) {
  auto* data = GetOrCreateCommandListData(cmd_list);
  if (data == nullptr) return;

  data->render_targets.clear();
  if (rtvs == nullptr) return;
  data->render_targets.assign(rtvs, rtvs + count);
}

inline std::pair<std::uint32_t, std::uint32_t> GetDescriptorSlot(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    std::uint32_t layout_param,
    const reshade::api::descriptor_table_update& update,
    std::uint32_t index) {
  std::uint32_t base_register = update.binding;
  std::uint32_t register_space = update.array_offset;

  const bool is_directx = device != nullptr
                          && (device->get_api() == reshade::api::device_api::d3d9
                              || device->get_api() == reshade::api::device_api::d3d10
                              || device->get_api() == reshade::api::device_api::d3d11
                              || device->get_api() == reshade::api::device_api::d3d12);
  if (!is_directx) return {base_register + index, register_space};

  (void)renodx::utils::pipeline_layout::GetPipelineLayoutData(layout, [&](const auto* layout_data) {
    if (layout_data == nullptr || layout_param >= layout_data->params.size()) return;

    const auto& param = layout_data->params[layout_param];
    auto use_range = [&](const auto& range) {
      if (range.count == 0u) return false;
      if (update.binding < range.binding) return false;
      if (range.count != std::numeric_limits<std::uint32_t>::max()
          && update.binding >= range.binding + range.count) {
        return false;
      }

      base_register = range.dx_register_index + (update.binding - range.binding);
      register_space = range.dx_register_space;
      return true;
    };

    auto use_ranges = [&](std::uint32_t count, const auto* ranges) {
      if (ranges == nullptr) return;
      for (std::uint32_t i = 0u; i < count; ++i) {
        if (use_range(ranges[i])) return;
      }
    };

    switch (param.type) {
      case reshade::api::pipeline_layout_param_type::push_descriptors:
        (void)use_range(param.push_descriptors);
        break;
      case reshade::api::pipeline_layout_param_type::descriptor_table:
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
        use_ranges(param.descriptor_table.count, param.descriptor_table.ranges);
        break;
      case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
      case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
        use_ranges(param.descriptor_table_with_static_samplers.count, param.descriptor_table_with_static_samplers.ranges);
        break;
      case reshade::api::pipeline_layout_param_type::push_constants:
      default:
        break;
    }
  });

  return {base_register + index, register_space};
}

inline void RecordUavDescriptors(
    std::map<std::pair<std::uint32_t, std::uint32_t>, reshade::api::resource_view>& destination,
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    std::uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  for (std::uint32_t i = 0u; i < update.count; ++i) {
    const auto* descriptors = static_cast<const reshade::api::resource_view*>(update.descriptors);
    const reshade::api::resource_view view = descriptors == nullptr ? reshade::api::resource_view{0u} : descriptors[i];
    const auto slot = GetDescriptorSlot(device, layout, layout_param, update, i);

    if (view.handle == 0u) {
      destination.erase(slot);
    } else {
      destination[slot] = view;
    }
  }
}

inline void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    std::uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (update.type != reshade::api::descriptor_type::unordered_access_view
      && update.type != reshade::api::descriptor_type::buffer_unordered_access_view) {
    return;
  }

  auto* data = GetOrCreateCommandListData(cmd_list);
  if (data == nullptr) return;

  auto* device = cmd_list->get_device();
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) {
    RecordUavDescriptors(data->pixel_uav_binds, device, layout, layout_param, update);
  }
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) {
    RecordUavDescriptors(data->compute_uav_binds, device, layout, layout_param, update);
  }
}

inline std::optional<TargetMatch> FindTargetView(
    reshade::api::device* device,
    const std::vector<reshade::api::resource_view>& views,
    const char* binding_prefix) {
  for (std::size_t i = 0u; i < views.size(); ++i) {
    reshade::api::resource resource = {0u};
    if (!IsTargetLutView(device, views[i], &resource)) continue;

    std::stringstream binding;
    binding << binding_prefix << i;
    return TargetMatch{.resource = resource, .binding = binding.str()};
  }
  return std::nullopt;
}

inline std::optional<TargetMatch> FindTargetView(
    reshade::api::device* device,
    const std::map<std::pair<std::uint32_t, std::uint32_t>, reshade::api::resource_view>& views,
    const char* binding_prefix) {
  for (const auto& [slot, view] : views) {
    reshade::api::resource resource = {0u};
    if (!IsTargetLutView(device, view, &resource)) continue;

    std::stringstream binding;
    binding << binding_prefix << slot.first;
    if (slot.second != 0u) binding << ", space" << slot.second;
    return TargetMatch{.resource = resource, .binding = binding.str()};
  }
  return std::nullopt;
}

inline void DumpCurrentShader(
    reshade::api::command_list* cmd_list,
    renodx::utils::shader::StageState* stage_state,
    std::int32_t shader_stage_index,
    reshade::api::pipeline_subobject_type shader_type,
    std::uint32_t shader_hash,
    const TargetMatch& match,
    const char* stage_name,
    const char* known_dump_prefix,
    const char* new_dump_prefix) {
  if (shader_hash == 0u || dumped_shaders.contains(shader_hash)) return;
  dumped_shaders.emplace(shader_hash);

  const bool is_known_shader = IsShaderInAddon(shader_hash);
  const char* dump_prefix = is_known_shader ? known_dump_prefix : new_dump_prefix;

  std::stringstream log_message;
  log_message << "Immortals LUT dump: dumping " << stage_name << " shader " << PRINT_CRC32(shader_hash)
              << (is_known_shader ? " (already in addon)" : " (new)")
              << " writing 32x32x32 RGBA16F Texture3D 0x" << std::hex << match.resource.handle << std::dec
              << " via " << match.binding;
  reshade::log::message(reshade::log::level::info, log_message.str().c_str());

  try {
    auto shader_data = renodx::utils::shader::GetShaderData(stage_state, shader_stage_index);
    if (!shader_data.has_value()) {
      std::stringstream s;
      s << "Immortals LUT dump: failed to retrieve shader data for " << PRINT_CRC32(shader_hash);
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      return;
    }

    renodx::utils::path::default_output_folder = "renodx";
    renodx::utils::shader::dump::default_dump_folder = ".";
    renodx::utils::shader::dump::DumpShader(
        shader_hash,
        shader_data.value(),
        shader_type,
        dump_prefix,
        cmd_list->get_device()->get_api());
  } catch (...) {
    std::stringstream s;
    s << "Immortals LUT dump: failed to dump shader " << PRINT_CRC32(shader_hash);
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }
}

inline bool DumpPixelShaderIfTargetBound(reshade::api::command_list* cmd_list) {
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (data == nullptr) return false;

  auto* device = cmd_list->get_device();
  auto match = FindTargetView(device, data->render_targets, "rt");
  if (!match.has_value()) {
    match = FindTargetView(device, data->pixel_uav_binds, "u");
  }
  if (!match.has_value()) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;

  auto* pixel_state = renodx::utils::shader::GetCurrentPixelState(shader_state);
  const auto shader_hash = renodx::utils::shader::GetCurrentPixelShaderHash(pixel_state);
  DumpCurrentShader(
      cmd_list,
      pixel_state,
      renodx::utils::shader::PIXEL_INDEX,
      reshade::api::pipeline_subobject_type::pixel_shader,
      shader_hash,
      match.value(),
      "pixel",
      DUMP_PREFIX_KNOWN_PIXEL,
      DUMP_PREFIX_NEW_PIXEL);
  return false;
}

inline bool OnDraw(
    reshade::api::command_list* cmd_list,
    std::uint32_t /*vertex_count*/,
    std::uint32_t /*instance_count*/,
    std::uint32_t /*first_vertex*/,
    std::uint32_t /*first_instance*/) {
  return DumpPixelShaderIfTargetBound(cmd_list);
}

inline bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    std::uint32_t /*index_count*/,
    std::uint32_t /*instance_count*/,
    std::uint32_t /*first_index*/,
    std::int32_t /*vertex_offset*/,
    std::uint32_t /*first_instance*/) {
  return DumpPixelShaderIfTargetBound(cmd_list);
}

inline bool OnDispatch(
    reshade::api::command_list* cmd_list,
    std::uint32_t /*group_count_x*/,
    std::uint32_t /*group_count_y*/,
    std::uint32_t /*group_count_z*/) {
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (data == nullptr) return false;

  auto match = FindTargetView(cmd_list->get_device(), data->compute_uav_binds, "u");
  if (!match.has_value()) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;

  auto* compute_state = renodx::utils::shader::GetCurrentComputeState(shader_state);
  const auto shader_hash = renodx::utils::shader::GetCurrentComputeShaderHash(compute_state);
  DumpCurrentShader(
      cmd_list,
      compute_state,
      renodx::utils::shader::COMPUTE_INDEX,
      reshade::api::pipeline_subobject_type::compute_shader,
      shader_hash,
      match.value(),
      "compute",
      DUMP_PREFIX_KNOWN_COMPUTE,
      DUMP_PREFIX_NEW_COMPUTE);
  return false;
}

inline renodx::utils::settings::Setting* CreateStatusSetting() {
  return new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = "LUT writer dump is ACTIVE: dumping shaders that bind a 32x32x32 RGBA16F Texture3D as RTV/UAV.",
      .section = "Debug",
      .tint = 0x00FF00,
      .is_sticky = false,
  };
}

inline void Use(DWORD fdw_reason) {
  renodx::utils::shader::use_shader_cache = true;
  renodx::utils::shader::Use(fdw_reason);
  renodx::utils::resource::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::log::message(reshade::log::level::info, "Immortals LUT writer dump enabled.");
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::dispatch>(OnDispatch);
      target_lut_resources.clear();
      dumped_shaders.clear();
      is_shader_in_addon = nullptr;
      break;
  }
}

#else

inline void Use(DWORD /*fdw_reason*/) {}
inline void SetShaderInAddonCallback(bool (*)(std::uint32_t)) {}

#endif

}  // namespace dump_lut
