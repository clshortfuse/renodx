/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <include/reshade.hpp>
#include <memory>
#include <optional>
#include <unordered_map>
#include <vector>

namespace renodx::utils::state {

struct CommandListState {
  std::vector<reshade::api::resource_view> render_targets;
  reshade::api::resource_view depth_stencil = {0};
  std::unordered_map<reshade::api::pipeline_stage, reshade::api::pipeline> pipelines;
  reshade::api::primitive_topology primitive_topology = reshade::api::primitive_topology::undefined;
  uint32_t blend_constant = 0;
  uint32_t sample_mask = 0xFFFFFFFF;
  uint32_t front_stencil_reference_value = 0;
  uint32_t back_stencil_reference_value = 0;
  std::vector<reshade::api::viewport> viewports;
  std::vector<reshade::api::rect> scissor_rects;
  std::unordered_map<reshade::api::shader_stage, std::pair<reshade::api::pipeline_layout, std::vector<reshade::api::descriptor_table>>> descriptor_tables;

  void Apply(reshade::api::command_list* cmd_list) const {
    if (!render_targets.empty() || depth_stencil != 0) {
      bool has_rtv = std::ranges::any_of(render_targets, [](auto rtv) {
        return rtv.handle != 0u;
      });
      if (has_rtv) {
        cmd_list->bind_render_targets_and_depth_stencil(
            static_cast<uint32_t>(render_targets.size()),
            render_targets.data(),
            depth_stencil);
      } else if (depth_stencil != 0) {
        cmd_list->bind_render_targets_and_depth_stencil(0, nullptr, depth_stencil);
      }
    }

    for (const auto& [stages, pipeline] : pipelines) {
      cmd_list->bind_pipeline(stages, pipeline);
    }

    if (primitive_topology != reshade::api::primitive_topology::undefined) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::primitive_topology, static_cast<uint32_t>(primitive_topology));
    }
    if (blend_constant != 0) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::blend_constant, blend_constant);
    }
    if (sample_mask != 0xFFFFFFFF) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::sample_mask, sample_mask);
    }
    if (front_stencil_reference_value != 0) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::front_stencil_reference_value, front_stencil_reference_value);
    }
    if (back_stencil_reference_value != 0) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::back_stencil_reference_value, back_stencil_reference_value);
    }

    if (!viewports.empty()) {
      cmd_list->bind_viewports(0, static_cast<uint32_t>(viewports.size()), viewports.data());
    }
    if (!scissor_rects.empty()) {
      cmd_list->bind_scissor_rects(0, static_cast<uint32_t>(scissor_rects.size()), scissor_rects.data());
    }

    for (const auto& [stages, descriptor_state] : descriptor_tables) {
      cmd_list->bind_descriptor_tables(stages, descriptor_state.first, 0, static_cast<uint32_t>(descriptor_state.second.size()), descriptor_state.second.data());
    }
  }

  void Clear() {
    render_targets.clear();
    depth_stencil = {0};
    pipelines.clear();
    primitive_topology = reshade::api::primitive_topology::undefined;
    blend_constant = 0;
    sample_mask = 0xFFFFFFFF;
    front_stencil_reference_value = 0;
    back_stencil_reference_value = 0;
    viewports.clear();
    scissor_rects.clear();
    descriptor_tables.clear();
  }
};

struct __declspec(uuid("019382d7-4364-7f3f-a42c-1a2619748db0")) CommandListData {
  CommandListState current_state;
};

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<CommandListData>();
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

static void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  auto& data = cmd_list->get_private_data<CommandListData>();
  auto& state = data.current_state;
  state.render_targets.assign(rtvs, rtvs + count);
  state.depth_stencil = dsv;
}

static void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stages,
    reshade::api::pipeline pipeline) {
  auto& data = cmd_list->get_private_data<CommandListData>();
  auto& state = data.current_state;
  state.pipelines[stages] = pipeline;
}

static void OnBindPipelineStates(
    reshade::api::command_list* cmd_list,
    uint32_t count, const reshade::api::dynamic_state* states,
    const uint32_t* values) {
  auto& data = cmd_list->get_private_data<CommandListData>();
  auto& state = data.current_state;

  for (uint32_t i = 0; i < count; ++i) {
    switch (states[i]) {
      case reshade::api::dynamic_state::primitive_topology:
        state.primitive_topology = static_cast<reshade::api::primitive_topology>(values[i]);
        break;
      case reshade::api::dynamic_state::blend_constant:
        state.blend_constant = values[i];
        break;
      case reshade::api::dynamic_state::sample_mask:
        state.sample_mask = values[i];
        break;
      case reshade::api::dynamic_state::front_stencil_reference_value:
        state.front_stencil_reference_value = values[i];
        break;
      case reshade::api::dynamic_state::back_stencil_reference_value:
        state.back_stencil_reference_value = values[i];
        break;
      case reshade::api::dynamic_state::unknown:
      case reshade::api::dynamic_state::alpha_test_enable:
      case reshade::api::dynamic_state::alpha_reference_value:
      case reshade::api::dynamic_state::alpha_func:
      case reshade::api::dynamic_state::srgb_write_enable:
      case reshade::api::dynamic_state::alpha_to_coverage_enable:
      case reshade::api::dynamic_state::blend_enable:
      case reshade::api::dynamic_state::logic_op_enable:
      case reshade::api::dynamic_state::source_color_blend_factor:
      case reshade::api::dynamic_state::dest_color_blend_factor:
      case reshade::api::dynamic_state::color_blend_op:
      case reshade::api::dynamic_state::source_alpha_blend_factor:
      case reshade::api::dynamic_state::dest_alpha_blend_factor:
      case reshade::api::dynamic_state::alpha_blend_op:
      case reshade::api::dynamic_state::logic_op:
      case reshade::api::dynamic_state::render_target_write_mask:
      case reshade::api::dynamic_state::fill_mode:
      case reshade::api::dynamic_state::cull_mode:
      case reshade::api::dynamic_state::front_counter_clockwise:
      case reshade::api::dynamic_state::depth_bias:
      case reshade::api::dynamic_state::depth_bias_clamp:
      case reshade::api::dynamic_state::depth_bias_slope_scaled:
      case reshade::api::dynamic_state::depth_clip_enable:
      case reshade::api::dynamic_state::scissor_enable:
      case reshade::api::dynamic_state::multisample_enable:
      case reshade::api::dynamic_state::antialiased_line_enable:
      case reshade::api::dynamic_state::depth_enable:
      case reshade::api::dynamic_state::depth_write_mask:
      case reshade::api::dynamic_state::depth_func:
      case reshade::api::dynamic_state::stencil_enable:
      case reshade::api::dynamic_state::front_stencil_read_mask:
      case reshade::api::dynamic_state::front_stencil_write_mask:
      case reshade::api::dynamic_state::front_stencil_func:
      case reshade::api::dynamic_state::front_stencil_pass_op:
      case reshade::api::dynamic_state::front_stencil_fail_op:
      case reshade::api::dynamic_state::front_stencil_depth_fail_op:
      case reshade::api::dynamic_state::back_stencil_read_mask:
      case reshade::api::dynamic_state::back_stencil_write_mask:
      case reshade::api::dynamic_state::back_stencil_func:
      case reshade::api::dynamic_state::back_stencil_pass_op:
      case reshade::api::dynamic_state::back_stencil_fail_op:
      case reshade::api::dynamic_state::back_stencil_depth_fail_op:
      case reshade::api::dynamic_state::ray_tracing_pipeline_stack_size:
        // Unused?
        break;
    }
  }
}

static void OnBindViewports(
    reshade::api::command_list* cmd_list,
    uint32_t first, uint32_t count,
    const reshade::api::viewport* viewports) {
  auto& data = cmd_list->get_private_data<CommandListData>();
  auto& state = data.current_state;

  const uint32_t total_count = first + count;
  if (state.viewports.size() < total_count) {
    state.viewports.resize(total_count);
  }

  for (uint32_t i = 0; i < count; ++i) {
    state.viewports[i + first] = viewports[i];
  }
}

static void OnBindScissorRects(
    reshade::api::command_list* cmd_list,
    uint32_t first, uint32_t count,
    const reshade::api::rect* rects) {
  auto& data = cmd_list->get_private_data<CommandListData>();
  auto& state = data.current_state;

  const uint32_t total_count = first + count;
  if (state.scissor_rects.size() < total_count) {
    state.scissor_rects.resize(total_count);
  }

  for (uint32_t i = 0; i < count; ++i) {
    state.scissor_rects[i + first] = rects[i];
  }
}

static void OnBindDescriptorTables(reshade::api::command_list* cmd_list,
                                   reshade::api::shader_stage stages,
                                   reshade::api::pipeline_layout layout,
                                   uint32_t first, uint32_t count,
                                   const reshade::api::descriptor_table* tables) {
  auto& state = cmd_list->get_private_data<CommandListData>().current_state.descriptor_tables[stages];

  if (layout != state.first) {
    state.second.clear();  // Layout changed, which resets all descriptor table bindings
  }
  state.first = layout;

  const uint32_t total_count = first + count;
  if (state.second.size() < total_count) {
    state.second.resize(total_count);
  }

  for (uint32_t i = 0; i < count; ++i) {
    state.second[i + first] = tables[i];
  }
}

static void OnResetCommandList(reshade::api::command_list* cmd_list) {
  auto& data = cmd_list->get_private_data<CommandListData>();
  if (std::addressof(data) == nullptr) return;
  auto& state = data.current_state;
  state.Clear();
}

static std::optional<CommandListState> GetCurrentState(reshade::api::command_list* cmd_list) {
  auto& data = cmd_list->get_private_data<CommandListData>();
  if (std::addressof(data) == nullptr) return std::nullopt;
  return data.current_state;
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "State attached.");

      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);
      reshade::register_event<reshade::addon_event::bind_viewports>(OnBindViewports);
      reshade::register_event<reshade::addon_event::bind_scissor_rects>(OnBindScissorRects);
      reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);

      reshade::register_event<reshade::addon_event::reset_command_list>(OnResetCommandList);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);
      reshade::unregister_event<reshade::addon_event::bind_viewports>(OnBindViewports);
      reshade::unregister_event<reshade::addon_event::bind_scissor_rects>(OnBindScissorRects);
      reshade::unregister_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);

      reshade::unregister_event<reshade::addon_event::reset_command_list>(OnResetCommandList);

      break;
  }
}

}  // namespace renodx::utils::state
