#pragma once

#include <cstdint>
#include <optional>
#include <type_traits>
#include <unordered_map>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "../../../utils/bitwise.hpp"
#include "../../../utils/hash.hpp"
#include "../../../utils/pipeline_layout.hpp"
#include "./pipeline_tracker.hpp"

namespace alienisolation::aliasisolation::descriptor_tracker {

using RegisterSlot = std::pair<uint32_t, uint32_t>;

struct __declspec(uuid("dce8f351-c8e0-40f9-a17d-73d7b9b37135")) CommandListData {
  pipeline_tracker::BoundShaders shaders;
  std::unordered_map<RegisterSlot, reshade::api::resource_view, renodx::utils::hash::HashPair> pixel_srvs;
  std::unordered_map<RegisterSlot, reshade::api::resource_view, renodx::utils::hash::HashPair> vertex_srvs;
  std::unordered_map<RegisterSlot, reshade::api::resource_view, renodx::utils::hash::HashPair> compute_srvs;
  std::unordered_map<RegisterSlot, reshade::api::buffer_range, renodx::utils::hash::HashPair> pixel_cbs;
  std::unordered_map<RegisterSlot, reshade::api::buffer_range, renodx::utils::hash::HashPair> vertex_cbs;
  std::unordered_map<RegisterSlot, reshade::api::buffer_range, renodx::utils::hash::HashPair> compute_cbs;
  std::vector<reshade::api::resource_view> render_targets;
  reshade::api::resource_view depth_stencil = {0};
  std::vector<reshade::api::viewport> viewports;
};

inline CommandListData* Get(reshade::api::command_list* cmd_list) {
  if (cmd_list == nullptr) return nullptr;
  auto* data = cmd_list->get_private_data<CommandListData>();
  return data != nullptr ? data : cmd_list->create_private_data<CommandListData>();
}

inline reshade::api::resource_view GetView(
    const std::unordered_map<RegisterSlot, reshade::api::resource_view, renodx::utils::hash::HashPair>& views,
    uint32_t slot,
    uint32_t space = 0u) {
  auto it = views.find({slot, space});
  return it != views.end() ? it->second : reshade::api::resource_view{0};
}

inline std::optional<reshade::api::buffer_range> GetBufferRange(
    const std::unordered_map<RegisterSlot, reshade::api::buffer_range, renodx::utils::hash::HashPair>& ranges,
    uint32_t slot,
    uint32_t space = 0u) {
  auto it = ranges.find({slot, space});
  if (it == ranges.end()) return std::nullopt;
  return it->second;
}

inline bool ResolveRegister(
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update,
    uint32_t descriptor_index,
    RegisterSlot& slot) {
  const auto* layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(layout);
  if (layout_data == nullptr || layout_param >= layout_data->params.size()) return false;

  const auto& param = layout_data->params[layout_param];
  const uint32_t binding = update.binding + descriptor_index;

  switch (param.type) {
    case reshade::api::pipeline_layout_param_type::push_descriptors:
      slot = {param.push_descriptors.dx_register_index + binding, param.push_descriptors.dx_register_space};
      return true;
    case reshade::api::pipeline_layout_param_type::descriptor_table:
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
    case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers: {
      if (layout_param >= layout_data->ranges.size()) return false;
      for (const auto& range : layout_data->ranges[layout_param]) {
        const bool in_range = binding >= range.binding && (range.count == UINT32_MAX || binding < range.binding + range.count);
        if (!in_range) continue;
        slot = {range.dx_register_index + (binding - range.binding), range.dx_register_space};
        return true;
      }
      return false;
    }
    default:
      return false;
  }
}

template <typename MapT, typename ValueT>
inline void StoreDescriptor(MapT& map, const RegisterSlot& slot, const ValueT& value) {
  if constexpr (std::is_same_v<ValueT, reshade::api::resource_view>) {
    if (value.handle == 0u) {
      map.erase(slot);
    } else {
      map[slot] = value;
    }
  } else {
    if (value.buffer.handle == 0u) {
      map.erase(slot);
    } else {
      map[slot] = value;
    }
  }
}

inline void StoreViewByStage(CommandListData* data, reshade::api::shader_stage stages, const RegisterSlot& slot, reshade::api::resource_view view) {
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::vertex)) StoreDescriptor(data->vertex_srvs, slot, view);
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) StoreDescriptor(data->pixel_srvs, slot, view);
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) StoreDescriptor(data->compute_srvs, slot, view);
}

inline void StoreConstantBufferByStage(CommandListData* data, reshade::api::shader_stage stages, const RegisterSlot& slot, reshade::api::buffer_range range) {
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::vertex)) StoreDescriptor(data->vertex_cbs, slot, range);
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) StoreDescriptor(data->pixel_cbs, slot, range);
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) StoreDescriptor(data->compute_cbs, slot, range);
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<CommandListData>();
}

inline void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

inline void OnResetCommandList(reshade::api::command_list* cmd_list) {
  auto* data = Get(cmd_list);
  if (data != nullptr) *data = {};
}

inline void OnBindPipeline(reshade::api::command_list* cmd_list, reshade::api::pipeline_stage stages, reshade::api::pipeline pipeline) {
  auto* data = Get(cmd_list);
  if (data == nullptr) return;
  pipeline_tracker::BindPipeline(data->shaders, stages, pipeline);
}

inline void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  auto* data = Get(cmd_list);
  if (data == nullptr) return;
  if (rtvs == nullptr || count == 0u) {
    data->render_targets.clear();
  } else {
    data->render_targets.assign(rtvs, rtvs + count);
  }
  data->depth_stencil = dsv;
}

inline void OnBindViewports(
    reshade::api::command_list* cmd_list,
    uint32_t first,
    uint32_t count,
    const reshade::api::viewport* viewports) {
  auto* data = Get(cmd_list);
  if (data == nullptr) return;
  if (first == 0u) data->viewports.clear();
  if (data->viewports.size() < first + count) data->viewports.resize(first + count);
  for (uint32_t i = 0; i < count; ++i) data->viewports[first + i] = viewports[i];
}

inline void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  auto* data = Get(cmd_list);
  if (data == nullptr) return;

  for (uint32_t i = 0; i < update.count; ++i) {
    RegisterSlot slot = {};
    if (!ResolveRegister(layout, layout_param, update, i, slot)) continue;

    switch (update.type) {
      case reshade::api::descriptor_type::sampler:
        break;
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        const auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i];
        StoreViewByStage(data, stages, slot, item.view);
        break;
      }
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view: {
        const auto view = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        StoreViewByStage(data, stages, slot, view);
        break;
      }
      case reshade::api::descriptor_type::unordered_access_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
        break;
      case reshade::api::descriptor_type::constant_buffer: {
        const auto range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
        StoreConstantBufferByStage(data, stages, slot, range);
        break;
      }
      default:
        break;
    }
  }
}

}  // namespace alienisolation::aliasisolation::descriptor_tracker
