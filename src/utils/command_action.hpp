/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <cassert>
#include <concepts>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <optional>
#include <set>
#include <shared_mutex>
#include <span>
#include <type_traits>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "./cross_addon.hpp"
#include "./shader.hpp"
#include "./state.hpp"
#include "./swapchain.hpp"

namespace renodx::utils::command_action {

enum CommandType : uint8_t {
  COMMAND_TYPE_DRAW = 0b00001u,
  COMMAND_TYPE_DRAW_INDEXED = 0b00010u,
  COMMAND_TYPE_DISPATCH = 0b00100u,
  COMMAND_TYPE_INDIRECT = 0b01000u,
  COMMAND_TYPE_DISPATCH_MESH = 0b10000u,
  COMMAND_TYPE_DIRECT_DRAW = COMMAND_TYPE_DRAW | COMMAND_TYPE_DRAW_INDEXED,
  COMMAND_TYPE_DIRECT_DISPATCH = COMMAND_TYPE_DISPATCH | COMMAND_TYPE_DISPATCH_MESH,
  COMMAND_TYPE_ALL = COMMAND_TYPE_DRAW | COMMAND_TYPE_DRAW_INDEXED | COMMAND_TYPE_DISPATCH | COMMAND_TYPE_INDIRECT | COMMAND_TYPE_DISPATCH_MESH,
};

enum CommandIndex : uint8_t {
  COMMAND_INDEX_DRAW,
  COMMAND_INDEX_DRAW_INDEXED,
  COMMAND_INDEX_DISPATCH,
  COMMAND_INDEX_INDIRECT,
  COMMAND_INDEX_DISPATCH_MESH,
  COMMAND_INDEX_COUNT,
};

struct DrawArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_DRAW;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_DRAW;

  uint32_t vertex_count = 0u;
  uint32_t instance_count = 0u;
  uint32_t first_vertex = 0u;
  uint32_t first_instance = 0u;
};

struct DrawIndexedArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_DRAW_INDEXED;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_DRAW_INDEXED;

  uint32_t index_count = 0u;
  uint32_t instance_count = 0u;
  uint32_t first_index = 0u;
  int32_t vertex_offset = 0;
  uint32_t first_instance = 0u;
};

struct DispatchArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_DISPATCH;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_DISPATCH;

  uint32_t group_count_x = 0u;
  uint32_t group_count_y = 0u;
  uint32_t group_count_z = 0u;
};

struct DispatchMeshArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_DISPATCH_MESH;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_DISPATCH_MESH;

  uint32_t group_count_x = 0u;
  uint32_t group_count_y = 0u;
  uint32_t group_count_z = 0u;
};

struct IndirectArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_INDIRECT;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_INDIRECT;

  reshade::api::indirect_command command = reshade::api::indirect_command::unknown;
  reshade::api::resource buffer = {0u};
  uint64_t offset = 0u;
  uint32_t draw_count = 0u;
  uint32_t stride = 0u;
  bool unknown_command_is_dispatch = false;
};

template <typename Arguments>
struct CommandContext {
  using ArgumentType = Arguments;

  reshade::api::command_list* cmd_list = nullptr;
  Arguments arguments = {};

  std::optional<renodx::utils::swapchain::CommandListData*> swapchain_state = std::nullopt;
  uint32_t matched_shader_hash = 0u;
  std::optional<reshade::api::pipeline_stage> matched_shader_stage = std::nullopt;
  const void* callback_data = nullptr;
  uint64_t command_id = 0u;
  renodx::utils::state::CommandListStateCache bound_state_cache = std::nullopt;
  std::optional<renodx::utils::shader::StageState> matched_stage_state = std::nullopt;

  template <typename T>
  [[nodiscard]] const T& GetCallbackData() const {
    assert(callback_data != nullptr);
    return *static_cast<const T*>(callback_data);
  }

  [[nodiscard]] constexpr bool IsDispatch() const {
    if constexpr (std::is_same_v<Arguments, DispatchArguments>) {
      return true;
    } else if constexpr (std::is_same_v<Arguments, DispatchMeshArguments>) {
      return false;
    } else if constexpr (std::is_same_v<Arguments, IndirectArguments>) {
      switch (arguments.command) {
        case reshade::api::indirect_command::unknown:
          return arguments.unknown_command_is_dispatch;
        case reshade::api::indirect_command::dispatch:
        case reshade::api::indirect_command::dispatch_rays:
          return true;
        default:
          return false;
      }
    } else {
      return false;
    }
  }
};

template <typename Arguments>
inline renodx::utils::swapchain::CommandListData* GetSwapchainState(CommandContext<Arguments>* context) {
  assert(context != nullptr);
  if (context == nullptr) return nullptr;
  if (!context->swapchain_state.has_value()) {
    context->swapchain_state = (context->cmd_list != nullptr
                                    ? renodx::utils::swapchain::GetCurrentState(context->cmd_list)
                                    : nullptr);
  }
  return *context->swapchain_state;
}

template <typename Context>
struct CallbackResult {
  using PostCallback = void (*)(Context& context, const void* data);

  PostCallback post_callback = nullptr;
  const void* post_data = nullptr;
  bool bypass = false;
  bool replay = false;
  PostCallback finalize_callback = nullptr;
};

struct Filter {
  uint32_t shader_hash = 0u;
  uint32_t command_types = COMMAND_TYPE_ALL;
};

using CallbackThunk = void (*)(void* context, const void* callback_data, void* result);

namespace internal {

struct CallbackRegistration {
  uint32_t command_types = COMMAND_TYPE_ALL;
  CallbackThunk invoke = nullptr;
  const void* callback = nullptr;
  const void* callback_data = nullptr;
  uint32_t registration_command_types = COMMAND_TYPE_ALL;
};

static thread_local uint64_t command_sequence = 0u;

struct PipelineRegistration {
  CallbackRegistration callback;
  renodx::utils::shader::PipelineShaderDetails* pipeline_details = nullptr;
  uint32_t eligible_stages = 0u;
  std::array<uint32_t, pipeline::SHADER_STAGES.size()> shader_hash_by_stage = {};
  std::array<size_t, pipeline::SHADER_STAGES.size()> registration_position_by_stage = {};
};

struct PipelineRegistrations {
  cross_addon::parallel_node_hash_map<uint32_t, cross_addon::vector<PipelineRegistration>> registrations_by_command_type;
  uint64_t generation = 0u;
};

struct __declspec(uuid("afecb945-902a-40e7-a32d-399becd4628b")) SharedData {
  cross_addon::parallel_node_hash_map<uint32_t, cross_addon::vector<CallbackRegistration>, std::shared_mutex> callback_registrations_by_shader_hash;
  cross_addon::parallel_node_hash_map<uint32_t, cross_addon::vector<CallbackRegistration>> global_callbacks_by_command_type;
  cross_addon::parallel_node_hash_map<uint64_t, PipelineRegistrations, std::shared_mutex> registrations_by_pipeline_handle;
  uint32_t shader_command_types = 0u;
};

static cross_addon::Shared<SharedData> shared;

inline void OnInitPipeline(
    renodx::utils::pipeline::PipelineInfo* info,
    [[maybe_unused]] uint32_t subobject_count,
    [[maybe_unused]] const reshade::api::pipeline_subobject* subobjects) {
  if (shared.data == nullptr) return;
  PipelineRegistrations prepared{.generation = info->generation};
  for (const auto& identity : info->shader_details) {
    const auto stage_index = pipeline::GetShaderStageIndex(identity.stage);
    if (stage_index >= pipeline::SHADER_STAGES.size()) continue;
    shared.data->callback_registrations_by_shader_hash.if_contains(identity.shader_hash, [&](const auto& entry) {
      const auto& [shader_hash, registrations] = entry;
      for (size_t position = 0u; position < registrations.size(); ++position) {
        const auto& registration = registrations[position];
        auto& matches = prepared.registrations_by_command_type[registration.command_types];
        auto match = std::ranges::find_if(matches, [&](const auto& existing) {
          return existing.callback.callback == registration.callback
                 && existing.callback.callback_data == registration.callback_data
                 && existing.callback.invoke == registration.invoke;
        });
        if (match == matches.end()) {
          matches.push_back({.callback = registration,
                             .pipeline_details = &info->details});
          match = matches.end() - 1;
        }
        match->eligible_stages |= static_cast<uint32_t>(identity.stage);
        if (match->shader_hash_by_stage[stage_index] == 0u) {
          match->shader_hash_by_stage[stage_index] = identity.shader_hash;
          match->registration_position_by_stage[stage_index] = position;
        }
      }
    });
  }
  if (!prepared.registrations_by_command_type.empty()) {
    shared.data->registrations_by_pipeline_handle.insert_or_assign(info->pipeline.handle, std::move(prepared));
  } else {
    shared.data->registrations_by_pipeline_handle.erase(info->pipeline.handle);
  }
}

inline void OnDestroyPipeline(const renodx::utils::pipeline::PipelineInfo& info) {
  if (shared.data != nullptr) {
    shared.data->registrations_by_pipeline_handle.erase_if(info.pipeline.handle, [&](const auto& entry) {
      const auto& [pipeline_handle, matches] = entry;
      return matches.generation == info.generation;
    });
  }
}

template <typename Callback>
inline constexpr uint8_t CALLBACK_IDENTITY = 0u;

template <typename Callback, typename Context, typename T>
inline constexpr bool IS_DATA_TEMPLATE_CALLBACK = requires(Callback callback, Context& context) {
  { callback.template operator()<T>(context) } -> std::convertible_to<CallbackResult<Context>>;
};

template <typename Callback, typename Context>
inline void InvokeCallback(void* context, const void* /*callback_data*/, void* result) {
  if constexpr (std::is_invocable_r_v<CallbackResult<Context>, Callback, Context&>) {
    *static_cast<CallbackResult<Context>*>(result) = Callback{}(*static_cast<Context*>(context));
  } else {
    assert(false);
    *static_cast<CallbackResult<Context>*>(result) = {};
  }
}

template <typename Callback, typename Context, typename T>
inline void InvokeCallback(void* context, const void* callback_data, void* result) {
  assert(callback_data != nullptr);
  auto* typed_context = static_cast<Context*>(context);
  const auto* previous_callback_data = typed_context->callback_data;
  typed_context->callback_data = callback_data;
  if constexpr (IS_DATA_TEMPLATE_CALLBACK<Callback, Context, T>) {
    *static_cast<CallbackResult<Context>*>(result) = Callback{}.template operator()<T>(*typed_context);
  } else if constexpr (std::is_invocable_r_v<CallbackResult<Context>, Callback, Context&>) {
    *static_cast<CallbackResult<Context>*>(result) = Callback{}(*typed_context);
  } else {
    assert(false);
    *static_cast<CallbackResult<Context>*>(result) = {};
  }
  typed_context->callback_data = previous_callback_data;
}

constexpr bool IsValidCommandTypeMask(uint32_t command_types) {
  return command_types != 0u && (command_types & ~COMMAND_TYPE_ALL) == 0u;
}

template <typename Arguments>
inline bool RunCallbacks(CommandContext<Arguments> context) {
  const auto* data = shared.data;
  if (data == nullptr) return false;

  context.command_id = ++command_sequence;

  struct PendingPostResult {
    CallbackResult<CommandContext<Arguments>> result = {};
    const void* callback_data = nullptr;
    uint32_t matched_shader_hash = 0u;
    std::optional<reshade::api::pipeline_stage> matched_shader_stage = std::nullopt;
    std::optional<renodx::utils::shader::StageState> matched_stage_state = std::nullopt;
  };

  static thread_local std::vector<PendingPostResult> pending_post_results;
  size_t pending_post_result_count = 0u;

  bool ran_callback = false;
  bool should_replay = false;

  const auto run_deferred_result = [&](const PendingPostResult& pending, bool finalize) {
    const auto callback = (finalize ? pending.result.finalize_callback : pending.result.post_callback);
    if (callback == nullptr) return;
    context.callback_data = pending.callback_data;
    context.matched_shader_hash = pending.matched_shader_hash;
    context.matched_shader_stage = pending.matched_shader_stage;
    context.matched_stage_state = pending.matched_stage_state;
    callback(context, pending.result.post_data);
  };

  const auto finalize_post_results = [&] {
    for (size_t i = pending_post_result_count; i != 0u; --i) {
      run_deferred_result(pending_post_results[i - 1u], true);
    }
  };

  const auto run_registration_list = [&](std::span<const CallbackRegistration> registrations) {
    for (const auto& registration : registrations) {
      ran_callback = true;
      CallbackResult<CommandContext<Arguments>> result = {};
      registration.invoke(&context, registration.callback_data, &result);
      should_replay |= result.replay || result.post_callback != nullptr || result.finalize_callback != nullptr;
      if (result.post_callback != nullptr || result.finalize_callback != nullptr) {
        PendingPostResult pending = {
            .result = result,
            .callback_data = registration.callback_data,
            .matched_shader_hash = context.matched_shader_hash,
            .matched_shader_stage = context.matched_shader_stage,
            .matched_stage_state = context.matched_stage_state,
        };
        if (pending_post_result_count == pending_post_results.size()) {
          pending_post_results.push_back(std::move(pending));
        } else {
          pending_post_results[pending_post_result_count] = std::move(pending);
        }
        ++pending_post_result_count;
      }
      if (result.bypass) {
        finalize_post_results();
        return true;
      }
    }

    return false;
  };

  // Borrow the node-owned vector: registrations are immutable during rendering.
  // Module load/unload may mutate or erase it and must not overlap dispatch.
  const cross_addon::vector<CallbackRegistration>* globals = nullptr;
  data->global_callbacks_by_command_type.if_contains(Arguments::COMMAND_TYPE, [&](const auto& entry) {
    const auto& [command_type, actions] = entry;
    globals = &actions;
  });
  if (globals != nullptr && run_registration_list(*globals)) return true;

  if ((data->shader_command_types & Arguments::COMMAND_TYPE) != 0u) {
    // Reuse node allocations across commands; ordering compares pointer identity
    // with std::less, not unspecified relational comparisons between objects.
    struct IdentityLess {
      bool operator()(const std::pair<const void*, const void*>& first,
                      const std::pair<const void*, const void*>& second) const {
        const auto& [first_callback, first_configuration] = first;
        const auto& [second_callback, second_configuration] = second;
        if (first_callback == second_callback) {
          return std::less<const void*>{}(first_configuration, second_configuration);
        }
        return std::less<const void*>{}(first_callback, second_callback);
      }
    };
    static thread_local std::set<std::pair<const void*, const void*>, IdentityLess> called_shader_callbacks;
    static thread_local std::vector<typename decltype(called_shader_callbacks)::node_type> reusable_identity_nodes;
    struct BoundStage {
      reshade::api::pipeline pipeline = {};
      reshade::api::pipeline_stage stage = {};
      size_t stage_index = 0u;
      renodx::utils::state::PipelineBind bind;
    };
    std::array<BoundStage, pipeline::SHADER_STAGES.size()> bound_stages;
    size_t bound_stage_count = 0u;
    const auto collect_stage = [&](reshade::api::pipeline_stage stage) {
      renodx::utils::state::PipelineBind bound_bind;
      const auto pipeline = renodx::utils::state::GetBoundShaderPipeline(
          context.cmd_list, stage, &context.bound_state_cache, &bound_bind);
      if (pipeline.handle == 0u) return;
      bound_stages[bound_stage_count++] = {
          .pipeline = pipeline,
          .stage = stage,
          .stage_index = pipeline::GetShaderStageIndex(stage),
          .bind = bound_bind,
      };
    };
    bool is_mesh = std::is_same_v<Arguments, DispatchMeshArguments>;
    if constexpr (std::is_same_v<Arguments, IndirectArguments>) {
      is_mesh = context.arguments.command == reshade::api::indirect_command::dispatch_mesh;
    }
    if (is_mesh) {
      collect_stage(reshade::api::pipeline_stage::amplification_shader);
      collect_stage(reshade::api::pipeline_stage::mesh_shader);
      collect_stage(reshade::api::pipeline_stage::pixel_shader);
    } else if (context.IsDispatch()) {
      collect_stage(reshade::api::pipeline_stage::compute_shader);
    } else {
      for (const auto stage : pipeline::SHADER_STAGES) {
        if (stage == reshade::api::pipeline_stage::compute_shader
            || stage == reshade::api::pipeline_stage::amplification_shader
            || stage == reshade::api::pipeline_stage::mesh_shader) continue;
        collect_stage(stage);
      }
    }
    static thread_local std::array<std::vector<const PipelineRegistration*>, pipeline::SHADER_STAGES.size()> stage_buckets;
    std::array<size_t, pipeline::SHADER_STAGES.size()> stage_bucket_extents = {};
    size_t contributing_pipeline_count = 0u;
    for (size_t pipeline_slot = 0u; pipeline_slot < bound_stage_count; ++pipeline_slot) {
      const auto previous = std::span(bound_stages.data(), pipeline_slot);
      if (std::ranges::any_of(previous, [&](const auto& bound) {
            return bound.pipeline == bound_stages[pipeline_slot].pipeline;
          })) continue;
      uint32_t active_stages = 0u;
      for (size_t stage_slot = pipeline_slot; stage_slot < bound_stage_count; ++stage_slot) {
        if (bound_stages[stage_slot].pipeline == bound_stages[pipeline_slot].pipeline) {
          active_stages |= static_cast<uint32_t>(bound_stages[stage_slot].stage);
        }
      }
      // Borrow the pipeline-owned vector and its elements for stage_buckets.
      // Prepared actions remain immutable while the pipeline is in use; destruction,
      // replacement, and callback unregistration must not overlap this dispatch.
      const cross_addon::vector<PipelineRegistration>* pipeline_matches = nullptr;
      data->registrations_by_pipeline_handle.if_contains(bound_stages[pipeline_slot].pipeline.handle, [&](const auto& entry) {
        const auto& [pipeline_handle, matches] = entry;
        matches.registrations_by_command_type.if_contains(Arguments::COMMAND_TYPE, [&](const auto& group) {
          const auto& [command_type, actions] = group;
          pipeline_matches = &actions;
        });
      });
      if (pipeline_matches == nullptr || pipeline_matches->empty()) continue;
      bool contributes = false;
      for (const auto& match : *pipeline_matches) {
        const uint32_t eligible_stages = match.eligible_stages & active_stages;
        if (eligible_stages == 0u) continue;
        for (size_t stage_slot = pipeline_slot; stage_slot < bound_stage_count; ++stage_slot) {
          if ((eligible_stages & static_cast<uint32_t>(bound_stages[stage_slot].stage)) == 0u) continue;
          const size_t position = match.registration_position_by_stage[bound_stages[stage_slot].stage_index];
          if (stage_bucket_extents[stage_slot] <= position) {
            if (stage_buckets[stage_slot].size() <= position) {
              stage_buckets[stage_slot].resize(position + 1u);
            }
            const auto newly_active_slots = std::span(stage_buckets[stage_slot]).subspan(stage_bucket_extents[stage_slot], position + 1u - stage_bucket_extents[stage_slot]);
            std::ranges::fill(newly_active_slots, nullptr);
            stage_bucket_extents[stage_slot] = position + 1u;
          }
          stage_buckets[stage_slot][position] = &match;
          contributes = true;
          break;
        }
      }
      if (contributes) {
        ++contributing_pipeline_count;
      }
    }
    size_t reusable_identity_node_count = reusable_identity_nodes.size();
    const auto recycle_identity_nodes = [&] {
      for (size_t slot = reusable_identity_node_count; !called_shader_callbacks.empty(); ++slot) {
        auto node = called_shader_callbacks.extract(called_shader_callbacks.begin());
        if (slot == reusable_identity_nodes.size()) {
          reusable_identity_nodes.push_back(std::move(node));
        } else {
          reusable_identity_nodes[slot] = std::move(node);
        }
      }
    };
    for (size_t stage_slot = 0u; stage_slot < bound_stage_count; ++stage_slot) {
      for (const auto* registration : std::span(stage_buckets[stage_slot].data(), stage_bucket_extents[stage_slot])) {
        if (registration == nullptr) continue;
        const auto& match = *registration;
        const auto& bound = bound_stages[stage_slot];
        const auto stage = bound.stage;
        const auto stage_index = bound.stage_index;
        if (contributing_pipeline_count > 1u) {
          const auto callback_identity = std::pair{match.callback.callback, match.callback.callback_data};
          if (called_shader_callbacks.contains(callback_identity)) continue;
          if (reusable_identity_node_count != 0u) {
            auto node = std::move(reusable_identity_nodes[--reusable_identity_node_count]);
            node.value() = callback_identity;
            called_shader_callbacks.insert(std::move(node));
          } else {
            called_shader_callbacks.insert(callback_identity);
          }
        }
        context.matched_shader_hash = match.shader_hash_by_stage[stage_index];
        context.matched_shader_stage = stage;
        context.matched_stage_state = renodx::utils::shader::StageState{
            .stage = stage,
            .applied_stage = bound.bind.stages,
            .pipeline = bound.pipeline,
            .pipeline_details = match.pipeline_details,
        };
        const bool bypass = run_registration_list({&match.callback, 1u});
        context.matched_shader_hash = 0u;
        context.matched_shader_stage = std::nullopt;
        context.matched_stage_state = std::nullopt;
        if (bypass) {
          recycle_identity_nodes();
          return true;
        }
      }
    }
    recycle_identity_nodes();
  }

  if (!ran_callback) return false;
  if (!should_replay) return false;
  assert(context.cmd_list != nullptr);

  if constexpr (std::is_same_v<Arguments, DrawArguments>) {
    context.cmd_list->draw(
        context.arguments.vertex_count,
        context.arguments.instance_count,
        context.arguments.first_vertex,
        context.arguments.first_instance);
  } else if constexpr (std::is_same_v<Arguments, DrawIndexedArguments>) {
    context.cmd_list->draw_indexed(
        context.arguments.index_count,
        context.arguments.instance_count,
        context.arguments.first_index,
        context.arguments.vertex_offset,
        context.arguments.first_instance);
  } else if constexpr (std::is_same_v<Arguments, DispatchArguments>) {
    context.cmd_list->dispatch(
        context.arguments.group_count_x,
        context.arguments.group_count_y,
        context.arguments.group_count_z);
  } else if constexpr (std::is_same_v<Arguments, IndirectArguments>) {
    context.cmd_list->draw_or_dispatch_indirect(
        context.arguments.command,
        context.arguments.buffer,
        context.arguments.offset,
        context.arguments.draw_count,
        context.arguments.stride);
  } else if constexpr (std::is_same_v<Arguments, DispatchMeshArguments>) {
    context.cmd_list->dispatch_mesh(
        context.arguments.group_count_x,
        context.arguments.group_count_y,
        context.arguments.group_count_z);
  }

  for (size_t i = 0u; i < pending_post_result_count; ++i) {
    run_deferred_result(pending_post_results[i], false);
  }
  finalize_post_results();

  return true;
}

inline bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  return RunCallbacks<DrawArguments>({
      .cmd_list = cmd_list,
      .arguments = DrawArguments{
          .vertex_count = vertex_count,
          .instance_count = instance_count,
          .first_vertex = first_vertex,
          .first_instance = first_instance,
      },
  });
}

inline bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  return RunCallbacks<DrawIndexedArguments>({
      .cmd_list = cmd_list,
      .arguments = DrawIndexedArguments{
          .index_count = index_count,
          .instance_count = instance_count,
          .first_index = first_index,
          .vertex_offset = vertex_offset,
          .first_instance = first_instance,
      },
  });
}

inline bool OnDispatch(
    reshade::api::command_list* cmd_list,
    uint32_t group_count_x,
    uint32_t group_count_y,
    uint32_t group_count_z) {
  return RunCallbacks<DispatchArguments>({
      .cmd_list = cmd_list,
      .arguments = DispatchArguments{
          .group_count_x = group_count_x,
          .group_count_y = group_count_y,
          .group_count_z = group_count_z,
      },
  });
}

inline bool OnDispatchMesh(
    reshade::api::command_list* cmd_list,
    uint32_t group_count_x,
    uint32_t group_count_y,
    uint32_t group_count_z) {
  return RunCallbacks<DispatchMeshArguments>({
      .cmd_list = cmd_list,
      .arguments = DispatchMeshArguments{
          .group_count_x = group_count_x,
          .group_count_y = group_count_y,
          .group_count_z = group_count_z,
      },
  });
}

inline bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride) {
  CommandContext<IndirectArguments> context = {
      .cmd_list = cmd_list,
      .arguments = IndirectArguments{
          .command = type,
          .buffer = buffer,
          .offset = offset,
          .draw_count = draw_count,
          .stride = stride,
      },
  };
  if (type == reshade::api::indirect_command::unknown) {
    context.arguments.unknown_command_is_dispatch = renodx::utils::state::GetBoundShaderPipeline(
                                                        cmd_list, reshade::api::pipeline_stage::compute_shader, &context.bound_state_cache)
                                                        .handle
                                                    != 0u;
  }
  return RunCallbacks<IndirectArguments>(context);
}

}  // namespace internal

template <typename Callback>
inline void RegisterCallback(Callback&& callback, Filter filter) {
  using CallbackType = std::remove_cvref_t<Callback>;
  (void)callback;

  static_assert(std::is_empty_v<CallbackType>);
  static_assert(std::is_default_constructible_v<CallbackType>);

  constexpr bool supports_draw = std::is_invocable_r_v<
      CallbackResult<CommandContext<DrawArguments>>, CallbackType, CommandContext<DrawArguments>&>;
  constexpr bool supports_draw_indexed = std::is_invocable_r_v<
      CallbackResult<CommandContext<DrawIndexedArguments>>, CallbackType, CommandContext<DrawIndexedArguments>&>;
  constexpr bool supports_dispatch = std::is_invocable_r_v<
      CallbackResult<CommandContext<DispatchArguments>>, CallbackType, CommandContext<DispatchArguments>&>;
  constexpr bool supports_indirect = std::is_invocable_r_v<
      CallbackResult<CommandContext<IndirectArguments>>, CallbackType, CommandContext<IndirectArguments>&>;
  constexpr bool supports_dispatch_mesh = std::is_invocable_r_v<
      CallbackResult<CommandContext<DispatchMeshArguments>>, CallbackType, CommandContext<DispatchMeshArguments>&>;
  constexpr uint32_t supported_command_types = (supports_draw ? COMMAND_TYPE_DRAW : 0u)
                                               | (supports_draw_indexed ? COMMAND_TYPE_DRAW_INDEXED : 0u)
                                               | (supports_dispatch ? COMMAND_TYPE_DISPATCH : 0u)
                                               | (supports_indirect ? COMMAND_TYPE_INDIRECT : 0u)
                                               | (supports_dispatch_mesh ? COMMAND_TYPE_DISPATCH_MESH : 0u);
  const uint32_t command_types = filter.command_types & supported_command_types;

  internal::shared.RegisterModule();
  auto* data = internal::shared.data;
  if (data == nullptr) return;
  assert(internal::IsValidCommandTypeMask(filter.command_types));
  assert(internal::IsValidCommandTypeMask(command_types));
  if (!internal::IsValidCommandTypeMask(filter.command_types) || !internal::IsValidCommandTypeMask(command_types)) return;

  const void* const callback_identity = &internal::CALLBACK_IDENTITY<CallbackType>;
  const auto update_registrations = [&](auto* registrations, uint32_t selected_commands = COMMAND_TYPE_ALL) {
    std::erase_if(*registrations, [&](const internal::CallbackRegistration& existing_registration) {
      return existing_registration.callback == callback_identity
             && existing_registration.callback_data == nullptr
             && existing_registration.registration_command_types == command_types;
    });
    const std::array<CallbackThunk, COMMAND_INDEX_COUNT> invocations = {
        supports_draw ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<DrawArguments>>) : nullptr,
        supports_draw_indexed ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<DrawIndexedArguments>>) : nullptr,
        supports_dispatch ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<DispatchArguments>>) : nullptr,
        supports_indirect ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<IndirectArguments>>) : nullptr,
        supports_dispatch_mesh ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<DispatchMeshArguments>>) : nullptr,
    };
    for (size_t index = 0u; index < invocations.size(); ++index) {
      if ((command_types & selected_commands & (1u << index)) == 0u) continue;
      registrations->push_back({
          .command_types = 1u << index,
          .invoke = invocations[index],
          .callback = callback_identity,
          .callback_data = nullptr,
          .registration_command_types = command_types,
      });
    }
  };
  if (filter.shader_hash == 0u) {
    for (uint32_t command_type = 1u; command_type <= COMMAND_TYPE_DISPATCH_MESH; command_type <<= 1u) {
      if ((command_types & command_type) == 0u) continue;
      auto& registrations = data->global_callbacks_by_command_type[command_type];
      update_registrations(&registrations, command_type);
    }
    return;
  }
  data->callback_registrations_by_shader_hash.lazy_emplace_l(
      filter.shader_hash,
      [&](auto& entry) {
        auto& [shader_hash, registrations] = entry;
        update_registrations(&registrations);
      },
      [&](const auto& ctor) {
        cross_addon::vector<internal::CallbackRegistration> registrations;
        update_registrations(&registrations);
        ctor(filter.shader_hash, std::move(registrations));
      });
  data->shader_command_types |= command_types;
}

template <typename Callback, typename T>
inline void RegisterCallback(Callback&& callback, Filter filter, const T* callback_data) {
  using CallbackType = std::remove_cvref_t<Callback>;
  using DataType = std::remove_cv_t<T>;
  (void)callback;

  static_assert(std::is_empty_v<CallbackType>);
  static_assert(std::is_default_constructible_v<CallbackType>);

  constexpr bool supports_draw =
      internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<DrawArguments>, DataType>
      || std::is_invocable_r_v<
          CallbackResult<CommandContext<DrawArguments>>, CallbackType, CommandContext<DrawArguments>&>;
  constexpr bool supports_draw_indexed =
      internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<DrawIndexedArguments>, DataType>
      || std::is_invocable_r_v<
          CallbackResult<CommandContext<DrawIndexedArguments>>, CallbackType, CommandContext<DrawIndexedArguments>&>;
  constexpr bool supports_dispatch =
      internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<DispatchArguments>, DataType>
      || std::is_invocable_r_v<
          CallbackResult<CommandContext<DispatchArguments>>, CallbackType, CommandContext<DispatchArguments>&>;
  constexpr bool supports_indirect =
      internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<IndirectArguments>, DataType>
      || std::is_invocable_r_v<
          CallbackResult<CommandContext<IndirectArguments>>, CallbackType, CommandContext<IndirectArguments>&>;
  constexpr bool supports_dispatch_mesh =
      internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<DispatchMeshArguments>, DataType>
      || std::is_invocable_r_v<
          CallbackResult<CommandContext<DispatchMeshArguments>>, CallbackType, CommandContext<DispatchMeshArguments>&>;
  constexpr uint32_t supported_command_types = (supports_draw ? COMMAND_TYPE_DRAW : 0u)
                                               | (supports_draw_indexed ? COMMAND_TYPE_DRAW_INDEXED : 0u)
                                               | (supports_dispatch ? COMMAND_TYPE_DISPATCH : 0u)
                                               | (supports_indirect ? COMMAND_TYPE_INDIRECT : 0u)
                                               | (supports_dispatch_mesh ? COMMAND_TYPE_DISPATCH_MESH : 0u);
  const uint32_t command_types = filter.command_types & supported_command_types;

  internal::shared.RegisterModule();
  auto* data = internal::shared.data;
  if (data == nullptr) return;
  assert(callback_data != nullptr);
  assert(internal::IsValidCommandTypeMask(filter.command_types));
  assert(internal::IsValidCommandTypeMask(command_types));
  if (callback_data == nullptr || !internal::IsValidCommandTypeMask(filter.command_types) || !internal::IsValidCommandTypeMask(command_types)) return;

  const void* const callback_identity = &internal::CALLBACK_IDENTITY<CallbackType>;
  const void* const erased_data = callback_data;
  const auto update_registrations = [&](auto* registrations, uint32_t selected_commands = COMMAND_TYPE_ALL) {
    std::erase_if(*registrations, [&](const internal::CallbackRegistration& existing_registration) {
      return existing_registration.callback == callback_identity
             && existing_registration.callback_data == erased_data
             && existing_registration.registration_command_types == command_types;
    });
    const std::array<CallbackThunk, COMMAND_INDEX_COUNT> invocations = {
        supports_draw ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<DrawArguments>, DataType>) : nullptr,
        supports_draw_indexed ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<DrawIndexedArguments>, DataType>) : nullptr,
        supports_dispatch ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<DispatchArguments>, DataType>) : nullptr,
        supports_indirect ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<IndirectArguments>, DataType>) : nullptr,
        supports_dispatch_mesh ? static_cast<CallbackThunk>(&internal::InvokeCallback<CallbackType, CommandContext<DispatchMeshArguments>, DataType>) : nullptr,
    };
    for (size_t index = 0u; index < invocations.size(); ++index) {
      if ((command_types & selected_commands & (1u << index)) == 0u) continue;
      registrations->push_back({
          .command_types = 1u << index,
          .invoke = invocations[index],
          .callback = callback_identity,
          .callback_data = erased_data,
          .registration_command_types = command_types,
      });
    }
  };
  if (filter.shader_hash == 0u) {
    for (uint32_t command_type = 1u; command_type <= COMMAND_TYPE_DISPATCH_MESH; command_type <<= 1u) {
      if ((command_types & command_type) == 0u) continue;
      auto& registrations = data->global_callbacks_by_command_type[command_type];
      update_registrations(&registrations, command_type);
    }
    return;
  }
  data->callback_registrations_by_shader_hash.lazy_emplace_l(
      filter.shader_hash,
      [&](auto& entry) {
        auto& [shader_hash, registrations] = entry;
        update_registrations(&registrations);
      },
      [&](const auto& ctor) {
        cross_addon::vector<internal::CallbackRegistration> registrations;
        update_registrations(&registrations);
        ctor(filter.shader_hash, std::move(registrations));
      });
  data->shader_command_types |= command_types;
}

template <typename Callback>
  requires(!std::is_pointer_v<std::remove_reference_t<Callback>>)
inline void Register(Callback&& callback, Filter filter) {
  RegisterCallback(callback, filter);
}

template <typename T, typename Callback>
  requires(!std::is_pointer_v<std::remove_reference_t<Callback>>)
inline void Register(Callback&& callback, Filter filter, const T* callback_data) {
  RegisterCallback(callback, filter, callback_data);
}

template <typename Callback>
inline void UnregisterCallback(Callback&& callback) {
  using CallbackType = std::remove_cvref_t<Callback>;
  (void)callback;

  auto* data = internal::shared.data;
  if (data == nullptr) return;

  const void* const callback_identity = &internal::CALLBACK_IDENTITY<CallbackType>;

  std::vector<uint32_t> empty_global_groups;
  data->global_callbacks_by_command_type.for_each_m([&](auto& entry) {
    auto& [command_type, registrations] = entry;
    std::erase_if(registrations, [&](const auto& registration) { return registration.callback == callback_identity; });
    if (registrations.empty()) {
      empty_global_groups.push_back(command_type);
    }
  });
  for (const auto command_type : empty_global_groups) {
    data->global_callbacks_by_command_type.erase(command_type);
  }
  std::vector<uint32_t> empty_shader_hashes;
  data->callback_registrations_by_shader_hash.for_each_m([&](auto& entry) {
    auto& [shader_hash, registrations] = entry;
    std::erase_if(registrations, [&](const internal::CallbackRegistration& registration) {
      return registration.callback == callback_identity;
    });
    if (registrations.empty()) {
      empty_shader_hashes.push_back(shader_hash);
    }
  });
  for (const auto shader_hash : empty_shader_hashes) {
    data->callback_registrations_by_shader_hash.erase_if(shader_hash, [](const auto& entry) {
      const auto& [shader_hash, registrations] = entry;
      return registrations.empty();
    });
  }

  // Pipeline matches own copies of the module's thunks; discard them before its code unloads.
  data->shader_command_types = 0u;
  data->callback_registrations_by_shader_hash.for_each([&](const auto& entry) {
    const auto& [shader_hash, registrations] = entry;
    for (const auto& registration : registrations) {
      data->shader_command_types |= registration.command_types;
    }
  });
  std::vector<uint64_t> empty_pipelines;
  data->registrations_by_pipeline_handle.for_each_m([&](auto& entry) {
    auto& [pipeline_handle, matches] = entry;
    std::vector<uint32_t> empty_groups;
    matches.registrations_by_command_type.for_each_m([&](auto& group) {
      auto& [command_type, actions] = group;
      std::erase_if(actions, [&](const auto& match) { return match.callback.callback == callback_identity; });
      if (actions.empty()) {
        empty_groups.push_back(command_type);
      }
    });
    for (const auto command_type : empty_groups) {
      matches.registrations_by_command_type.erase(command_type);
    }
    if (matches.registrations_by_command_type.empty()) {
      empty_pipelines.push_back(pipeline_handle);
    }
  });
  for (const auto pipeline_handle : empty_pipelines) {
    data->registrations_by_pipeline_handle.erase(pipeline_handle);
  }
}

template <typename Callback>
  requires(!std::is_pointer_v<std::remove_reference_t<Callback>>)
inline void Unregister(Callback&& callback) {
  UnregisterCallback(callback);
}

inline void Use(DWORD fdw_reason) {
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    state::use_pipeline_tracking = true;
  }
  state::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::shared.RegisterModule()) {
        reshade::log::message(reshade::log::level::info, "utils::command_action attached...");
      }
      renodx::utils::pipeline::RegisterOnInitCallback(internal::OnInitPipeline);
      renodx::utils::pipeline::RegisterOnDestroyCallback(internal::OnDestroyPipeline);
      {
        std::array<bool, COMMAND_INDEX_COUNT> command_event_active = {};
        const auto update_command_event_active = [&](const internal::CallbackRegistration& registration) {
          command_event_active[COMMAND_INDEX_DRAW] |= (registration.command_types & COMMAND_TYPE_DRAW) != 0u;
          command_event_active[COMMAND_INDEX_DRAW_INDEXED] |= (registration.command_types & COMMAND_TYPE_DRAW_INDEXED) != 0u;
          command_event_active[COMMAND_INDEX_DISPATCH] |= (registration.command_types & COMMAND_TYPE_DISPATCH) != 0u;
          command_event_active[COMMAND_INDEX_INDIRECT] |= (registration.command_types & COMMAND_TYPE_INDIRECT) != 0u;
          command_event_active[COMMAND_INDEX_DISPATCH_MESH] |= (registration.command_types & COMMAND_TYPE_DISPATCH_MESH) != 0u;
        };
        internal::shared.data->callback_registrations_by_shader_hash.for_each([&](const auto& entry) {
          const auto& [shader_hash, registrations] = entry;
          for (const auto& registration : registrations) {
            update_command_event_active(registration);
          }
        });
        internal::shared.data->global_callbacks_by_command_type.for_each([&](const auto& entry) {
          const auto& [command_type, registrations] = entry;
          for (const auto& registration : registrations) {
            update_command_event_active(registration);
          }
        });
        internal::shared.RegisterEvent<reshade::addon_event::draw>(internal::OnDraw, command_event_active[COMMAND_INDEX_DRAW]);
        internal::shared.RegisterEvent<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed, command_event_active[COMMAND_INDEX_DRAW_INDEXED]);
        internal::shared.RegisterEvent<reshade::addon_event::dispatch>(internal::OnDispatch, command_event_active[COMMAND_INDEX_DISPATCH]);
        internal::shared.RegisterEvent<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect, command_event_active[COMMAND_INDEX_INDIRECT]);
        internal::shared.RegisterEvent<reshade::addon_event::dispatch_mesh>(internal::OnDispatchMesh, command_event_active[COMMAND_INDEX_DISPATCH_MESH]);
      }
      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::pipeline::UnregisterOnInitCallback(internal::OnInitPipeline);
      renodx::utils::pipeline::UnregisterOnDestroyCallback(internal::OnDestroyPipeline);
      internal::shared.UnregisterEvent<reshade::addon_event::draw>(internal::OnDraw);
      internal::shared.UnregisterEvent<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed);
      internal::shared.UnregisterEvent<reshade::addon_event::dispatch>(internal::OnDispatch);
      internal::shared.UnregisterEvent<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect);
      internal::shared.UnregisterEvent<reshade::addon_event::dispatch_mesh>(internal::OnDispatchMesh);
      internal::shared.UnregisterModule();
      break;
  }
}

}  // namespace renodx::utils::command_action
