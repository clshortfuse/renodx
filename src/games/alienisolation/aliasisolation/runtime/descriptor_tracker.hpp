#pragma once

/*
 * Per-command-list descriptor tracker.
 *
 * ReShade callbacks tell us when SRVs and constant buffers are pushed, but the
 * TAA insertion point only sees a draw event. This tracker keeps the small
 * D3D11-like register subset Alias Isolation still needs at draw time.
 */

#include <cstdint>
#include <utility>

#include <include/reshade.hpp>

#include "../../../../utils/bitwise.hpp"
#include "../../../../utils/descriptor.hpp"
#include "../../../../utils/pipeline_layout.hpp"

namespace alienisolation::aliasisolation::descriptor_tracker {

using RegisterSlot = std::pair<uint32_t, uint32_t>;

// Stored as command-list private data so deferred/immediate command lists keep
// independent binding state.
struct __declspec(uuid("dce8f351-c8e0-40f9-a17d-73d7b9b37135")) CommandListData {
  reshade::api::resource_view pixel_srv_t0 = {0};
  reshade::api::resource_view pixel_srv_t8 = {0};
  reshade::api::buffer_range vertex_cb_b0 = {};
  reshade::api::buffer_range vertex_cb_b1 = {};
  reshade::api::buffer_range pixel_cb_b2 = {};
};

inline CommandListData* Get(reshade::api::command_list* cmd_list) {
  if (cmd_list == nullptr) return nullptr;
  auto* data = cmd_list->get_private_data<CommandListData>();
  return data != nullptr ? data : cmd_list->create_private_data<CommandListData>();
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

  // Translate ReShade's abstract pipeline-layout parameter back into the DX
  // register index/space the game's shader expects.
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

inline void StoreViewByStage(CommandListData* data, reshade::api::shader_stage stages, const RegisterSlot& slot, reshade::api::resource_view view) {
  if (!renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) return;
  if (slot.second != 0u) return;

  // Only the draw-time inputs needed by the Alias Isolation insertion are kept.
  // Null descriptors still assign through here, which clears stale state.
  if (slot.first == 0u) {
    data->pixel_srv_t0 = view;
  } else if (slot.first == 8u) {
    data->pixel_srv_t8 = view;
  }
}

inline void StoreConstantBufferByStage(CommandListData* data, reshade::api::shader_stage stages, const RegisterSlot& slot, reshade::api::buffer_range range) {
  if (slot.second != 0u) return;

  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::vertex)) {
    if (slot.first == 0u) {
      data->vertex_cb_b0 = range;
    } else if (slot.first == 1u) {
      data->vertex_cb_b1 = range;
    }
  }

  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel) && slot.first == 2u) {
    data->pixel_cb_b2 = range;
  }
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

inline void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  auto* data = Get(cmd_list);
  if (data == nullptr) return;

  const bool tracks_pixel = renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel);
  const bool tracks_vertex = renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::vertex);

  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view:
    case reshade::api::descriptor_type::shader_resource_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
      if (!tracks_pixel) return;
      break;
    case reshade::api::descriptor_type::constant_buffer:
      if (!tracks_vertex && !tracks_pixel) return;
      break;
    default:
      return;
  }

  // Only SRVs and constant buffers are tracked here. UAVs and samplers are
  // managed by the manual TAA dispatch when it binds its own compute pipeline.
  for (uint32_t i = 0; i < update.count; ++i) {
    RegisterSlot slot = {};
    if (!ResolveRegister(layout, layout_param, update, i, slot)) continue;

    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view:
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view: {
        const auto view = renodx::utils::descriptor::GetResourceViewFromDescriptorUpdate(update, i);
        StoreViewByStage(data, stages, slot, view);
        break;
      }
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
