#pragma once

#include <atomic>
#include <cstdint>
#include <limits>
#include <map>
#include <optional>
#include <sstream>
#include <string>
#include <unordered_set>
#include <utility>

#include <include/reshade.hpp>

#include "../../utils/bitwise.hpp"
#include "../../utils/data.hpp"
#include "../../utils/descriptor.hpp"
#include "../../utils/format.hpp"
#include "../../utils/path.hpp"
#include "../../utils/pipeline_layout.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/shader_compiler_directx.hpp"
#include "../../utils/shader_dump.hpp"
#include "../../utils/state.hpp"
#include "../../utils/swapchain.hpp"

namespace dump_uber {

inline std::atomic_bool dump_enabled = false;
inline std::atomic_uint64_t activation_generation = 0u;
inline std::unordered_set<std::uint32_t> checked_shaders = {};
inline bool (*is_shader_in_addon)(std::uint32_t shader_hash) = nullptr;

inline constexpr const char* DUMP_PREFIX_KNOWN = "uber_old_";
inline constexpr const char* DUMP_PREFIX_NEW = "uber_new_";

inline void SetDumpEnabled(bool enabled, const char* reason) {
  const bool was_enabled = dump_enabled.load(std::memory_order_acquire);
  if (was_enabled == enabled) return;

  if (enabled) {
    activation_generation.fetch_add(1u, std::memory_order_release);
  }
  dump_enabled.store(enabled, std::memory_order_release);

  std::stringstream message;
  message << "[DUMP OUTPUT] Unity uber dump search " << (enabled ? "started" : "stopped");
  if (reason != nullptr && reason[0] != '\0') {
    message << ": " << reason;
  }
  reshade::log::message(reshade::log::level::info, message.str().c_str());
}

inline void SetShaderInAddonCallback(bool (*callback)(std::uint32_t shader_hash)) {
  is_shader_in_addon = callback;
}

inline bool IsDumpEnabled() {
  return dump_enabled.load(std::memory_order_acquire);
}

inline bool IsShaderInAddon(std::uint32_t shader_hash) {
  return is_shader_in_addon != nullptr && is_shader_in_addon(shader_hash);
}

struct TargetMatch {
  reshade::api::resource resource = {0u};
  std::string binding;
};

struct DetectionSignals {
  bool has_swapchain_sized_srv = false;
  bool has_swapchain_sized_render_target = false;
  bool is_fullscreen_draw = false;

  [[nodiscard]] bool IsConfirmed() const {
    return has_swapchain_sized_srv
           && has_swapchain_sized_render_target
           && is_fullscreen_draw;
  }
};

struct __declspec(uuid("a4c8e2f1-6b3d-4a9e-8f7c-1d2e3b4c5d6e")) CommandListData {
  std::uint64_t activation_generation = 0u;
  std::map<std::pair<std::uint32_t, std::uint32_t>, reshade::api::resource_view> pixel_srv_binds;
  std::map<std::pair<std::uint32_t, std::uint32_t>, reshade::api::resource_view> compute_srv_binds;
};

inline bool IsInternalLutDimensions(std::uint32_t width, std::uint32_t height) {
  return (width == 1024u && height == 32u) || (width == 256u && height == 16u);
}

inline bool IsInternalLutDesc(const reshade::api::resource_desc& desc) {
  switch (desc.type) {
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      return IsInternalLutDimensions(desc.texture.width, desc.texture.height);
    default:
      return false;
  }
}

inline bool IsInternalLutResource(reshade::api::device* device, reshade::api::resource resource) {
  if (device == nullptr || resource.handle == 0u) return false;
  return IsInternalLutDesc(device->get_resource_desc(resource));
}

inline bool IsSwapchainSizedDesc(
    const reshade::api::resource_desc& desc,
    const reshade::api::resource_desc& back_buffer_desc) {
  switch (desc.type) {
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      break;
    default:
      return false;
  }

  if (back_buffer_desc.texture.width == 0u || back_buffer_desc.texture.height == 0u) return false;
  return desc.texture.width == back_buffer_desc.texture.width
         && desc.texture.height == back_buffer_desc.texture.height;
}

inline bool IsSwapchainSizedView(
    reshade::api::device* device,
    reshade::api::resource_view view,
    const reshade::api::resource_desc& back_buffer_desc) {
  if (device == nullptr || view.handle == 0u) return false;

  const auto resource = renodx::utils::resource::GetResourceFromView(device, view);
  if (resource.handle == 0u) return false;
  return IsSwapchainSizedDesc(device->get_resource_desc(resource), back_buffer_desc);
}

inline bool IsInternalLutView(
    reshade::api::device* device,
    reshade::api::resource_view view,
    reshade::api::resource* resource = nullptr) {
  if (device == nullptr || view.handle == 0u) return false;

  const auto original_resource = renodx::utils::resource::GetResourceFromView(device, view);
  if (original_resource.handle == 0u) return false;

  if (resource != nullptr) *resource = original_resource;
  return IsInternalLutResource(device, original_resource);
}

inline CommandListData* GetOrCreateCommandListData(reshade::api::command_list* cmd_list) {
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (data == nullptr) {
    data = renodx::utils::data::Create<CommandListData>(cmd_list);
  }
  if (data == nullptr) return nullptr;

  const auto current_generation = activation_generation.load(std::memory_order_acquire);
  if (data->activation_generation != current_generation) {
    data->activation_generation = current_generation;
    data->pixel_srv_binds.clear();
    data->compute_srv_binds.clear();
  }
  return data;
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (IsDumpEnabled()) GetOrCreateCommandListData(cmd_list);
}

inline void OnResetCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CommandListData>(cmd_list);
  if (IsDumpEnabled()) GetOrCreateCommandListData(cmd_list);
}

inline void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CommandListData>(cmd_list);
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

inline void RecordSrvDescriptors(
    std::map<std::pair<std::uint32_t, std::uint32_t>, reshade::api::resource_view>& destination,
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    std::uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  for (std::uint32_t i = 0u; i < update.count; ++i) {
    reshade::api::resource_view view = {0u};
    if (update.type == reshade::api::descriptor_type::sampler_with_resource_view) {
      const auto* descriptors = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors);
      view = descriptors == nullptr ? reshade::api::resource_view{0u} : descriptors[i].view;
    } else {
      const auto* descriptors = static_cast<const reshade::api::resource_view*>(update.descriptors);
      view = descriptors == nullptr ? reshade::api::resource_view{0u} : descriptors[i];
    }

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
  if (!IsDumpEnabled()) return;

  switch (update.type) {
    case reshade::api::descriptor_type::shader_resource_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::sampler_with_resource_view:
      break;
    default:
      return;
  }

  auto* data = GetOrCreateCommandListData(cmd_list);
  if (data == nullptr) return;

  auto* device = cmd_list->get_device();
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) {
    RecordSrvDescriptors(data->pixel_srv_binds, device, layout, layout_param, update);
  }
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) {
    RecordSrvDescriptors(data->compute_srv_binds, device, layout, layout_param, update);
  }
}

inline std::optional<TargetMatch> FindInternalLutSrv(
    reshade::api::device* device,
    const std::map<std::pair<std::uint32_t, std::uint32_t>, reshade::api::resource_view>& srv_binds) {
  for (const auto& [slot, view] : srv_binds) {
    reshade::api::resource resource = {0u};
    if (!IsInternalLutView(device, view, &resource)) continue;

    const auto desc = device->get_resource_desc(resource);
    std::stringstream binding;
    binding << "t" << slot.first;
    if (slot.second != 0u) binding << ", space" << slot.second;
    binding << " (" << desc.texture.width << "x" << desc.texture.height << ")";
    return TargetMatch{.resource = resource, .binding = binding.str()};
  }
  return std::nullopt;
}

inline DetectionSignals GetDetectionSignals(
    reshade::api::command_list* cmd_list,
    const std::map<std::pair<std::uint32_t, std::uint32_t>, reshade::api::resource_view>& srv_binds) {
  DetectionSignals signals;
  if (cmd_list == nullptr) return signals;

  auto* device = cmd_list->get_device();
  if (device == nullptr) return signals;

  const auto back_buffer_desc = renodx::utils::swapchain::GetBackBufferDesc(device);
  if (back_buffer_desc.texture.width == 0u || back_buffer_desc.texture.height == 0u) return signals;

  for (const auto& [slot, view] : srv_binds) {
    (void)slot;
    if (IsSwapchainSizedView(device, view, back_buffer_desc)) {
      signals.has_swapchain_sized_srv = true;
      break;
    }
  }

  auto* state = renodx::utils::state::GetCurrentState(cmd_list);
  if (state == nullptr) return signals;

  for (const auto& rtv : state->render_targets) {
    if (IsSwapchainSizedView(device, rtv, back_buffer_desc)) {
      signals.has_swapchain_sized_render_target = true;
      break;
    }
  }

  return signals;
}

inline void DumpCurrentShader(
    reshade::api::command_list* cmd_list,
    renodx::utils::shader::StageState* stage_state,
    std::int32_t shader_stage_index,
    reshade::api::pipeline_subobject_type shader_type,
    std::uint32_t shader_hash,
    const TargetMatch& match,
    const DetectionSignals& signals,
    const char* stage_name) {
  if (shader_hash == 0u) return;

  const bool is_known_shader = IsShaderInAddon(shader_hash);
  if (!is_known_shader && !signals.IsConfirmed()) return;

  const char* dump_prefix = is_known_shader ? DUMP_PREFIX_KNOWN : DUMP_PREFIX_NEW;
  const char* classification = is_known_shader ? "already in addon" : "new";

  std::stringstream log_message;
  log_message << "Unity uber dump: matched " << stage_name << " shader " << PRINT_CRC32(shader_hash)
              << " (" << classification << ")"
              << " with internal LUT SRV 0x" << std::hex << match.resource.handle << std::dec
              << " via " << match.binding
              << ", swapchain-sized SRV: " << (signals.has_swapchain_sized_srv ? "yes" : "no")
              << ", swapchain-sized RTV: " << (signals.has_swapchain_sized_render_target ? "yes" : "no")
              << ", fullscreen draw: " << (signals.is_fullscreen_draw ? "yes" : "no");
  reshade::log::message(reshade::log::level::info, log_message.str().c_str());

  try {
    auto shader_data = renodx::utils::shader::GetShaderData(stage_state, shader_stage_index);
    if (!shader_data.has_value()) {
      std::stringstream s;
      s << "Unity uber dump: failed to retrieve shader data for " << PRINT_CRC32(shader_hash);
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      return;
    }

    const auto shader_version = renodx::utils::shader::compiler::directx::DecodeShaderVersion(shader_data.value());
    if (shader_version.GetMajor() == 0) return;

    renodx::utils::path::default_output_folder = "renodx";
    renodx::utils::shader::dump::default_dump_folder = ".";
    const auto dump_path = renodx::utils::shader::dump::GetShaderDumpPath(
        shader_hash,
        shader_data.value(),
        shader_type,
        dump_prefix,
        cmd_list->get_device()->get_api());
    if (renodx::utils::path::CheckExistsFile(dump_path)) {
      std::stringstream s;
      s << "Unity uber dump: file already exists for " << PRINT_CRC32(shader_hash)
        << "; skipping " << dump_path.string();
      reshade::log::message(reshade::log::level::info, s.str().c_str());
      return;
    }
    renodx::utils::shader::dump::DumpShader(
        shader_hash,
        shader_data.value(),
        shader_type,
        dump_prefix,
        cmd_list->get_device()->get_api());
  } catch (...) {
    std::stringstream s;
    s << "Unity uber dump: failed to dump shader " << PRINT_CRC32(shader_hash);
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }
}

inline bool DumpPixelShaderIfLutSrvBound(
    reshade::api::command_list* cmd_list,
    bool is_fullscreen_draw) {
  if (!IsDumpEnabled()) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;

  auto* pixel_state = renodx::utils::shader::GetCurrentPixelState(shader_state);
  const auto shader_hash = renodx::utils::shader::GetCurrentPixelShaderHash(pixel_state);
  if (shader_hash == 0u || !checked_shaders.emplace(shader_hash).second) return false;

  auto* data = GetOrCreateCommandListData(cmd_list);
  if (data == nullptr) return false;

  auto match = FindInternalLutSrv(cmd_list->get_device(), data->pixel_srv_binds);
  if (!match.has_value()) return false;

  auto signals = GetDetectionSignals(cmd_list, data->pixel_srv_binds);
  signals.is_fullscreen_draw = is_fullscreen_draw;
  DumpCurrentShader(
      cmd_list,
      pixel_state,
      renodx::utils::shader::PIXEL_INDEX,
      reshade::api::pipeline_subobject_type::pixel_shader,
      shader_hash,
      match.value(),
      signals,
      "pixel");
  return false;
}

inline bool DumpComputeShaderIfLutSrvBound(reshade::api::command_list* cmd_list) {
  if (!IsDumpEnabled()) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;

  auto* compute_state = renodx::utils::shader::GetCurrentComputeState(shader_state);
  const auto shader_hash = renodx::utils::shader::GetCurrentComputeShaderHash(compute_state);
  if (shader_hash == 0u || !checked_shaders.emplace(shader_hash).second) return false;

  auto* data = GetOrCreateCommandListData(cmd_list);
  if (data == nullptr) return false;

  auto match = FindInternalLutSrv(cmd_list->get_device(), data->compute_srv_binds);
  if (!match.has_value()) return false;

  const auto signals = GetDetectionSignals(cmd_list, data->compute_srv_binds);
  DumpCurrentShader(
      cmd_list,
      compute_state,
      renodx::utils::shader::COMPUTE_INDEX,
      reshade::api::pipeline_subobject_type::compute_shader,
      shader_hash,
      match.value(),
      signals,
      "compute");
  return false;
}

inline bool OnDraw(
    reshade::api::command_list* cmd_list,
    std::uint32_t vertex_count,
    std::uint32_t instance_count,
    std::uint32_t /*first_vertex*/,
    std::uint32_t /*first_instance*/) {
  const bool is_fullscreen_draw = instance_count == 1u
                                  && (vertex_count == 3u || vertex_count == 4u || vertex_count == 6u);
  return DumpPixelShaderIfLutSrvBound(cmd_list, is_fullscreen_draw);
}

inline bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    std::uint32_t index_count,
    std::uint32_t instance_count,
    std::uint32_t /*first_index*/,
    std::int32_t /*vertex_offset*/,
    std::uint32_t /*first_instance*/) {
  const bool is_fullscreen_draw = instance_count == 1u
                                  && (index_count == 3u || index_count == 6u);
  return DumpPixelShaderIfLutSrvBound(cmd_list, is_fullscreen_draw);
}

inline bool OnDispatch(
    reshade::api::command_list* cmd_list,
    std::uint32_t /*group_count_x*/,
    std::uint32_t /*group_count_y*/,
    std::uint32_t /*group_count_z*/) {
  return DumpComputeShaderIfLutSrvBound(cmd_list);
}

inline void Use(DWORD fdw_reason) {
  renodx::utils::descriptor::trace_descriptor_tables = true;
  renodx::utils::shader::use_shader_cache = true;
  renodx::utils::shader::Use(fdw_reason);
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::pipeline_layout::Use(fdw_reason);
  renodx::utils::descriptor::Use(fdw_reason);
  renodx::utils::state::Use(fdw_reason);
  renodx::utils::swapchain::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
        reshade::log::message(
          reshade::log::level::info,
          "[DUMP OUTPUT] Unity uber dumper initialized and waiting for activation.");
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::dispatch>(OnDispatch);
      dump_enabled.store(false, std::memory_order_release);
      activation_generation.store(0u, std::memory_order_release);
      checked_shaders.clear();
      is_shader_in_addon = nullptr;
      break;
  }
}

}  // namespace dump_uber
