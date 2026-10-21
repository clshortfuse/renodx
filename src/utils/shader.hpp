/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <d3d12sdklayers.h>
#include <dxgi.h>
#include <dxgi1_6.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <cassert>
#include <cstdint>
#include <functional>
#include <optional>
#include <shared_mutex>
#include <span>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <include/reshade.hpp>

#include "./bitwise.hpp"
#include "./cross_addon.hpp"
#include "./cstring.hpp"
#include "./data.hpp"
#include "./format.hpp"
#include "./hash.hpp"
#include "./log.hpp"
#include "./pipeline.hpp"
#include "./pipeline_layout.hpp"
#include "./state.hpp"

namespace renodx::utils::shader {

static bool use_replace_on_create = true;
static bool use_replace_on_bind = true;
static bool use_replace_async = false;
static bool use_shader_cache = false;
static bool use_pipeline_lookup = false;
static std::atomic_size_t runtime_replacement_count = 0;

static constexpr size_t VERTEX_INDEX = 0u;
static constexpr size_t PIXEL_INDEX = 1u;
static constexpr size_t COMPUTE_INDEX = 2u;
static constexpr size_t COMPATIBLE_STAGES_SIZE = 3u;

[[deprecated("Use pipeline::SHADER_STAGES for general iteration or state::GetBoundShaderPipeline for bound stages.")]]
static const std::array<reshade::api::pipeline_stage, COMPATIBLE_STAGES_SIZE> COMPATIBLE_STAGES = {
    reshade::api::pipeline_stage::vertex_shader,
    reshade::api::pipeline_stage::pixel_shader,
    reshade::api::pipeline_stage::compute_shader,
};

using PipelineShaderDetails = pipeline::PipelineShaderDetails;

static void AddShaderReplacement(
    reshade::api::pipeline_subobject* subobject,
    std::span<const uint8_t> new_shader,
    reshade::api::device_api api) {
  auto* desc = static_cast<reshade::api::shader_desc*>(subobject->data);
  assert(desc != nullptr);
  if (desc == nullptr) return;
  if (desc->entry_point != nullptr) {
    std::free(const_cast<char*>(desc->entry_point));
    desc->entry_point = nullptr;
  }
  // Vulkan may retain the original stage's entry point when the descriptor is null.
  if (api == reshade::api::device_api::vulkan) {
    desc->entry_point = renodx::utils::CloneCString("main");
  }

  if (desc->code_size != 0u) {
    free(const_cast<void*>(desc->code));  // Release clone's shader
  }
  desc->code_size = new_shader.size();
  if (desc->code_size == 0) {
    desc->code = nullptr;
  } else {
    desc->code = malloc(desc->code_size);
    memcpy(const_cast<void*>(desc->code), new_shader.data(), desc->code_size);
  }
}

using DeviceShaderKey = std::pair<reshade::api::device*, uint32_t>;
using ShaderBytecodeMap = cross_addon::parallel_flat_hash_map<DeviceShaderKey, std::span<const uint8_t>, std::shared_mutex>;
using ShaderPipelineHandleSet = cross_addon::unordered_set<uint64_t>;
using ShaderPipelineHandlesMap = cross_addon::parallel_flat_hash_map<DeviceShaderKey, ShaderPipelineHandleSet, std::shared_mutex>;

namespace internal {
struct __declspec(uuid("5034968b-31f6-401d-a43b-68841aa55dec")) SharedData {
  ShaderBytecodeMap compile_time_replacements;
  ShaderBytecodeMap runtime_replacements;
  bool use_replace_on_create = true;
  bool use_replace_on_bind = true;
  bool use_replace_async = false;
  bool use_shader_cache = false;
  bool use_pipeline_lookup = false;
  ShaderPipelineHandlesMap shader_pipeline_handles;
};

static cross_addon::Shared<SharedData> shared;
}  // namespace internal

template <typename F>
static void ForEachRuntimeReplacement(reshade::api::device* device, F&& callback) {
  if (internal::shared.data == nullptr) return;
  internal::shared.data->runtime_replacements.for_each([&](const auto& entry) {
    const auto& [key, bytecode] = entry;
    if (key.first == device) {
      std::invoke(callback, key.second, bytecode);
    }
  });
}

// Pipeline handles are borrowed only for the callback's map-lock scope.
// Copy handles before performing pipeline lookups or replacement operations.
template <typename F>
static bool GetShaderPipelineHandles(reshade::api::device* device, uint32_t shader_hash, F&& callback) {
  if (internal::shared.data == nullptr) return false;
  bool found = false;
  internal::shared.data->shader_pipeline_handles.if_contains({device, shader_hash}, [&](const auto& entry) {
    const auto& [shader_key, pipeline_handles] = entry;
    found = true;
    std::invoke(callback, std::as_const(pipeline_handles));
  });
  return found;
}

static std::optional<bool> GetReplaceOnBindPolicy() {
  if (internal::shared.data == nullptr) return std::nullopt;
  return internal::shared.data->use_replace_on_bind;
}

}  // namespace renodx::utils::shader

namespace renodx::utils::pipeline {

inline PipelineShaderDetails::PipelineShaderDetails(
    reshade::api::pipeline pipeline,
    reshade::api::device* device,
    const reshade::api::pipeline_layout& layout,
    const reshade::api::pipeline_subobject* subobjects,
    const uint32_t& subobject_count,
    std::span<const PipelineShaderHashEntry> shader_details,
    std::span<const uint32_t> replaced_shader_subobject_indexes)
    : pipeline(pipeline), device(device), layout(layout) {
  pipeline_layout::GetPipelineLayoutData(layout, [&](const auto& layout_data) {
    this->replacement_layout = layout_data->replacement_layout;
    this->injection_layout = layout_data->injection_layout;
    this->injection_index = layout_data->injection_index;
    this->injection_register_index = layout_data->injection_register_index;
    this->injection_constant_buffer_offset = layout_data->injection_constant_buffer_offset;
    if (layout_data->injection_index >= 0
        && static_cast<size_t>(layout_data->injection_index) < layout_data->params.size()
        && layout_data->params[layout_data->injection_index].type == reshade::api::pipeline_layout_param_type::push_constants) {
      this->injection_visibility = layout_data->params[layout_data->injection_index].push_constants.visibility;
    }
    this->descriptor_push_locations.clear();
    for (const auto& [binding, location] : layout_data->descriptor_push_locations) {
      this->descriptor_push_locations.emplace(binding, location);
    }
  });
  reshade::api::pipeline_subobject* replacement_subobjects = nullptr;
  for (const auto& identity : shader_details) {
    const uint32_t i = identity.subobject_index;
    if (i >= subobject_count) continue;
    const auto& subobject = subobjects[i];
    const auto is_vulkan = device->get_api() == reshade::api::device_api::vulkan;
    const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);

    std::stringstream s;
    s << "utils::shader::PipelineShaderDetails(";
    s << "Pipeline: " << PRINT_PTR(pipeline.handle);
    s << ", Index: " << i;
    s << ", Type: " << subobject.type;
    s << ", Stage: " << identity.stage;
    if (is_vulkan) {
      s << ", Entry Point: " << desc.entry_point;
    }
    s << ", Count: " << subobject.count;
    s << ", Code Size: " << desc.code_size;
    if (desc.code_size == 0) {
      s << ", Code: (empty)";
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
      continue;
    }

    const uint32_t shader_hash = identity.shader_hash;
    const auto stage = identity.stage;

    if (std::ranges::find(replaced_shader_subobject_indexes, i)
        != replaced_shader_subobject_indexes.end()) {
      this->initialized_replacement = true;
    } else {
      renodx::utils::shader::internal::shared.data->runtime_replacements.if_contains(
          {device, shader_hash},
          [&](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::span<const uint8_t>>& pair) {
            if (renodx::utils::shader::internal::shared.data->use_replace_async) {
              return;
            }
            if (replacement_subobjects == nullptr) {
              replacement_subobjects = renodx::utils::pipeline::ClonePipelineSubObjects(subobjects, subobject_count);
            }
#ifdef DEBUG_LEVEL_0
            {
              std::stringstream s;
              s << "utils::shader::BuildReplacementPipeline(Replacing ";
              s << PRINT_CRC32(shader_hash);
              s << ")";
              reshade::log::message(reshade::log::level::debug, s.str().c_str());
            }
#endif
            renodx::utils::shader::AddShaderReplacement(&replacement_subobjects[i], pair.second, device->get_api());
#ifdef DEBUG_LEVEL_1
            {
              std::stringstream s;
              s << "utils::shader::BuildReplacementPipeline(Added replacement ";
              s << PRINT_CRC32(shader_hash);
              s << ")";
              reshade::log::message(reshade::log::level::debug, s.str().c_str());
            }
#endif

            this->replacement_stages |= stage;
          });
    }
    if (replacement_subobjects != nullptr) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::shader::PipelineShaderDetails(";
      s << "Replacing pipeline for ";
      s << PRINT_CRC32(shader_hash);
      s << ", pipeline: " << PRINT_PTR(pipeline.handle);
      s << ", index: " << i;
      s << ", type: " << subobject.type;
      s << ", stage: " << stage;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    } else {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "utils::shader::PipelineShaderDetails(";
      s << "Tracking ";
      s << PRINT_CRC32(shader_hash);
      s << ", pipeline: " << PRINT_PTR(pipeline.handle);
      s << ", index: " << i;
      s << ", type: " << subobject.type;
      s << ", stage: " << stage;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    }
  }

  if (replacement_subobjects != nullptr) {
    reshade::api::pipeline new_pipeline;

    auto create_layout = this->injection_layout != 0u ? this->injection_layout : layout;
    if (this->replacement_layout.handle != 0u) {
      create_layout = this->replacement_layout;
    }

    const bool built_pipeline_ok = device->create_pipeline(
        create_layout,
        subobject_count,
        replacement_subobjects,
        &new_pipeline);

#ifndef NDEBUG
    {
      std::stringstream s;
      s << "utils::shader::PipelineShaderDetails(Replacement pipeline result: ";
      s << (built_pipeline_ok ? "success, " : "failure, ");
      s << PRINT_PTR(new_pipeline.handle);
      s << ")";
      reshade::log::message(
          built_pipeline_ok ? reshade::log::level::debug : reshade::log::level::error,
          s.str().c_str());
    }
#endif
#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::shader::BuildReplacementPipeline(Added replacement pipeline";
      s << PRINT_PTR(new_pipeline.handle);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
    renodx::utils::pipeline::DestroyPipelineSubobjects(replacement_subobjects, subobject_count);

    if (built_pipeline_ok) {
      this->initialized_replacement = true;
      this->replacement_pipeline = new_pipeline;
      return;
    }

    assert(built_pipeline_ok);
#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "utils::shader::PipelineShaderDetails(Failed to replace pipeline";
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
#endif
  }

  this->replacement_pipeline = {0};
  this->replacement_stages = static_cast<reshade::api::pipeline_stage>(0);

  // this->subobjects = std::vector<reshade::api::pipeline_subobject>(subobjects, subobjects + subobject_count);
}

}  // namespace renodx::utils::pipeline

namespace renodx::utils::shader {

struct StageState {
  reshade::api::pipeline_stage stage;
  reshade::api::pipeline_stage applied_stage;
  reshade::api::pipeline pipeline = {0u};
  PipelineShaderDetails* pipeline_details = nullptr;
};

static const std::array<StageState, 3> EMPTY_STAGE_STATES = {
    StageState({.stage = reshade::api::pipeline_stage::vertex_shader}),
    StageState({.stage = reshade::api::pipeline_stage::pixel_shader}),
    StageState({.stage = reshade::api::pipeline_stage::compute_shader}),
};

struct __declspec(uuid("8707f724-c7e5-420e-89d6-cc032c732d2d")) CommandListData {
  [[deprecated("Global last bind is not the active pipeline; use state::GetBoundShaderPipeline for the command bind point.")]]
  reshade::api::pipeline last_pipeline = {0u};  // Retained for UUID-backed ABI compatibility.
  std::array<StageState, 3> stage_states = EMPTY_STAGE_STATES;
};

[[deprecated("Use GetPipelineShaderDetails<F> or UpdatePipelineShaderDetails<F>")]] [[nodiscard]]
inline PipelineShaderDetails* GetPipelineShaderDetails(const reshade::api::pipeline& pipeline) {
  PipelineShaderDetails* details = nullptr;
  pipeline::GetPipelineShaderDetails(pipeline, [&](const PipelineShaderDetails& entry) {
    details = const_cast<PipelineShaderDetails*>(&entry);
  });

  if (details == nullptr) {
    log::e("utils::shader::GetPipelineShaderDetails(Pipeline not found for handle: ",
           log::AsPtr(pipeline.handle), ")");
    assert(details != nullptr);
  }

  return details;
}

template <typename F>
inline bool GetPipelineShaderDetails(const reshade::api::pipeline& pipeline, F&& f) {
  return pipeline::GetPipelineShaderDetails(pipeline, std::forward<F>(f));
}

template <typename F>
inline bool UpdatePipelineShaderDetails(const reshade::api::pipeline& pipeline, F&& f) {
  return pipeline::UpdatePipelineShaderDetails(pipeline, std::forward<F>(f));
}

inline void PopulateStageState(StageState* stage_state) {
  if (stage_state->pipeline == 0u) return;
  if (stage_state->pipeline_details != nullptr) return;
  GetPipelineShaderDetails(stage_state->pipeline, [&](const PipelineShaderDetails& details) {
    stage_state->pipeline_details = const_cast<PipelineShaderDetails*>(&details);
  });
}

[[deprecated("Use state::GetBoundShaderPipeline for the vertex stage; resolve details through pipeline::GetPipelineInfo.")]]
inline StageState* GetCurrentVertexState(CommandListData* cmd_list_data) {
  return &cmd_list_data->stage_states[VERTEX_INDEX];
}
[[deprecated("Use state::GetBoundShaderPipeline for the pixel stage; resolve details through pipeline::GetPipelineInfo.")]]
inline StageState* GetCurrentPixelState(CommandListData* cmd_list_data) {
  return &cmd_list_data->stage_states[PIXEL_INDEX];
}
[[deprecated("Use state::GetBoundShaderPipeline for the compute stage; resolve details through pipeline::GetPipelineInfo.")]]
inline StageState* GetCurrentComputeState(CommandListData* cmd_list_data) {
  return &cmd_list_data->stage_states[COMPUTE_INDEX];
}

[[deprecated("Use state::GetCurrentShaderHash for a command list and pipeline stage.")]]
inline uint32_t GetCurrentShaderHash(StageState* stage_state, const int& index) {
  assert(index < COMPATIBLE_STAGES_SIZE);
  return pipeline::GetPipelineShaderHash(stage_state->pipeline, COMPATIBLE_STAGES[index]);
}

inline uint32_t GetCurrentShaderHash(StageState* stage_state) {
  switch (stage_state->stage) {
    case reshade::api::pipeline_stage::vertex_shader:
      return GetCurrentShaderHash(stage_state, VERTEX_INDEX);
    case reshade::api::pipeline_stage::pixel_shader:
      return GetCurrentShaderHash(stage_state, PIXEL_INDEX);
    case reshade::api::pipeline_stage::compute_shader:
      return GetCurrentShaderHash(stage_state, COMPUTE_INDEX);
    default:
      assert(false);
      return 0u;
  }
}

[[deprecated("Use state::GetCurrentShaderHash for a command list and pipeline stage.")]]
inline uint32_t GetCurrentShaderHash(CommandListData* cmd_list_data, const int& index) {
  return GetCurrentShaderHash(&cmd_list_data->stage_states[index], index);
}

inline uint32_t GetCurrentVertexShaderHash(CommandListData* cmd_list_data) {
  return GetCurrentShaderHash(cmd_list_data, VERTEX_INDEX);
}
inline uint32_t GetCurrentPixelShaderHash(CommandListData* cmd_list_data) {
  return GetCurrentShaderHash(cmd_list_data, PIXEL_INDEX);
}
inline uint32_t GetCurrentComputeShaderHash(CommandListData* cmd_list_data) {
  return GetCurrentShaderHash(cmd_list_data, COMPUTE_INDEX);
}

inline uint32_t GetCurrentVertexShaderHash(StageState* stage_state) {
  return GetCurrentShaderHash(stage_state, VERTEX_INDEX);
}
inline uint32_t GetCurrentPixelShaderHash(StageState* stage_state) {
  return GetCurrentShaderHash(stage_state, PIXEL_INDEX);
}
inline uint32_t GetCurrentComputeShaderHash(StageState* stage_state) {
  return GetCurrentShaderHash(stage_state, COMPUTE_INDEX);
}

inline uint32_t GetCurrentShaderHash(CommandListData* cmd_list_data, reshade::api::pipeline_stage& stage) {
  switch (stage) {
    case reshade::api::pipeline_stage::vertex_shader:
      return GetCurrentVertexShaderHash(cmd_list_data);
    case reshade::api::pipeline_stage::pixel_shader:
      return GetCurrentPixelShaderHash(cmd_list_data);
    case reshade::api::pipeline_stage::compute_shader:
      return GetCurrentComputeShaderHash(cmd_list_data);
    default:
      return 0;
  }
}

template <typename F>
static bool WithReplacementPipeline(const reshade::api::pipeline& pipeline, F&& callback) {
  std::vector<pipeline::PipelineShaderHashEntry> shader_details;
  reshade::api::device* device = nullptr;
  reshade::api::pipeline_layout original_layout = {0u};
  reshade::api::pipeline_layout injection_layout = {0u};
  reshade::api::pipeline_layout replacement_layout = {0u};
  reshade::api::pipeline replacement = {0u};
  auto stages = static_cast<reshade::api::pipeline_stage>(0u);
  uint64_t generation = 0u;
  uint64_t revision = 0u;
  reshade::api::pipeline_subobject* subobjects = nullptr;
  uint32_t subobject_count = 0u;
  bool resolved = false;
  pipeline::GetPipelineInfo(pipeline, [&](const auto& info) {
    const auto& details = info.details;
    if (details.destroyed) return;
    generation = info.generation;
    revision = details.replacement_revision;
    if (details.is_replacement) {
      resolved = true;
      return;
    }
    if (details.initialized_replacement) {
      replacement = details.replacement_pipeline;
      stages = details.replacement_stages;
      resolved = stages == static_cast<reshade::api::pipeline_stage>(0u) || replacement.handle != 0u;
      return;
    }
    shader_details.assign(info.shader_details.begin(), info.shader_details.end());
    device = details.device;
    original_layout = details.layout;
    injection_layout = details.injection_layout;
    replacement_layout = details.replacement_layout;
    subobject_count = static_cast<uint32_t>(details.subobjects.size());
    if (subobject_count != 0u) {
      subobjects = pipeline::ClonePipelineSubObjects(details.subobjects.data(), subobject_count);
    }
  });
  if (generation == 0u) return false;
  if (resolved) {
    std::invoke(callback, replacement, stages);
    return true;
  }

  if (subobjects != nullptr) {
    for (const auto& shader : shader_details) {
      internal::shared.data->runtime_replacements.if_contains(
          {device, shader.shader_hash},
          [&](const auto& entry) {
            AddShaderReplacement(&subobjects[shader.subobject_index], entry.second, device->get_api());
            stages |= shader.stage;
          });
    }
  }

  reshade::api::pipeline candidate = {0u};
  bool built = true;
  if (stages != static_cast<reshade::api::pipeline_stage>(0u)) {
    auto layout = (injection_layout.handle != 0u ? injection_layout : original_layout);
    if (replacement_layout.handle != 0u) {
      layout = replacement_layout;
    }
    built = device->create_pipeline(layout, subobject_count, subobjects, &candidate);
  }
  if (subobjects != nullptr) {
    pipeline::DestroyPipelineSubobjects(subobjects, subobject_count);
  }
  if (!built) return false;

  pipeline::UpdatePipelineInfo(pipeline, [&](auto& info) {
    auto& details = info.details;
    if (details.destroyed || info.generation != generation) return;
    if (details.replacement_revision != revision) return;
    if (details.initialized_replacement) {
      replacement = details.replacement_pipeline;
      stages = details.replacement_stages;
    } else {
      details.replacement_pipeline = candidate;
      details.replacement_stages = stages;
      details.initialized_replacement = true;
      replacement = candidate;
      candidate = {0u};
    }
    resolved = stages == static_cast<reshade::api::pipeline_stage>(0u) || replacement.handle != 0u;
  });
  if (candidate.handle != 0u) {
    device->destroy_pipeline(candidate);
  }
  if (resolved) {
    std::invoke(callback, replacement, stages);
  }
  return resolved;
}

static bool BuildReplacementPipeline(const reshade::api::pipeline& pipeline) {
  return WithReplacementPipeline(pipeline, [](auto, auto) {});
}

inline bool ApplyReplacement(reshade::api::command_list* cmd_list, StageState* stage_state) {
  bool applied = false;
  if (!WithReplacementPipeline(stage_state->pipeline, [&](auto replacement, auto stages) {
        if (replacement.handle == 0u) {
          applied = true;  // The bound pipeline is itself a replacement or no replacement is needed.
          return;
        }
        if (!renodx::utils::bitwise::HasFlag(stages, stage_state->stage)) return;
        cmd_list->bind_pipeline(stage_state->applied_stage, replacement);
        applied = true;
      })) return false;
  return applied;
}

inline bool ApplyBoundReplacement(reshade::api::command_list* cmd_list, reshade::api::pipeline_stage stage) {
  state::PipelineBind bind{};
  StageState stage_state{
      .stage = stage,
      .pipeline = state::GetBoundShaderPipeline(cmd_list, stage, nullptr, &bind),
  };
  if (stage_state.pipeline.handle == 0u) return false;
  stage_state.applied_stage = bind.stages;
  return ApplyReplacement(cmd_list, &stage_state);
}

inline void ApplyDispatchReplacements(reshade::api::command_list* cmd_list, [[maybe_unused]] CommandListData* cmd_list_data) {
  ApplyBoundReplacement(cmd_list, reshade::api::pipeline_stage::compute_shader);
}

inline void ApplyDrawReplacements(reshade::api::command_list* cmd_list, [[maybe_unused]] CommandListData* cmd_list_data) {
  ApplyBoundReplacement(cmd_list, reshade::api::pipeline_stage::vertex_shader);
  ApplyBoundReplacement(cmd_list, reshade::api::pipeline_stage::pixel_shader);
}

namespace internal {
static data::ParallelFlatHashMap<uint32_t, std::span<const uint8_t>, std::shared_mutex> compile_time_replacements;
static data::ParallelFlatHashMap<uint32_t, std::span<const uint8_t>, std::shared_mutex> initial_runtime_replacements;
static std::unordered_map<reshade::api::device_api, data::ParallelFlatHashMap<uint32_t, std::span<const uint8_t>, std::shared_mutex>>
    device_based_compile_time_replacements;
static std::unordered_map<reshade::api::device_api, data::ParallelFlatHashMap<uint32_t, std::span<const uint8_t>, std::shared_mutex>>
    device_based_initial_runtime_replacements;
}  // namespace internal

static void QueueCompileTimeReplacement(
    uint32_t shader_hash,
    const std::span<const uint8_t> shader_data) {
  internal::compile_time_replacements[shader_hash] = shader_data;
}

static void UpdateReplacements(
    const std::unordered_map<uint32_t, std::span<const uint8_t>> replacements,
    bool compile_time = true,
    bool initial_runtime = true,
    const std::unordered_set<reshade::api::device_api>& devices = {}) {
  if (!compile_time && !initial_runtime) return;

  auto update = [&](auto& compile_list, auto& runtime_list) {
    for (const auto& [shader_hash, shader_data] : replacements) {
      if (compile_time) {
        compile_list[shader_hash] = shader_data;
      }
      if (initial_runtime) {
        runtime_list[shader_hash] = shader_data;
      }
    }
  };
  if (devices.empty()) {
    update(internal::compile_time_replacements, internal::initial_runtime_replacements);
  } else {
    for (const auto& device : devices) {
      auto& compile = internal::device_based_compile_time_replacements[device];
      auto& runtime = internal::device_based_initial_runtime_replacements[device];
      update(compile, runtime);
    }
  }
}

static void UnqueueCompileTimeReplacement(
    uint32_t shader_hash) {
  internal::compile_time_replacements.erase(shader_hash);
}

static void QueueRuntimeReplacement(
    uint32_t shader_hash,
    const std::span<const uint8_t> shader_data) {
  internal::initial_runtime_replacements[shader_hash] = shader_data;
}

static void UnqueueRuntimeReplacement(
    uint32_t shader_hash,
    const std::span<const uint8_t> shader_data) {
  internal::initial_runtime_replacements.erase(shader_hash);
}

// Note: Does not reset pipeline state
static void AddRuntimeReplacement(
    reshade::api::device* device,
    uint32_t shader_hash,
    const std::span<const uint8_t> shader_data) {
  internal::shared.data->runtime_replacements.insert_or_assign({device, shader_hash}, shader_data);
  runtime_replacement_count = internal::shared.data->runtime_replacements.size();
  std::vector<uint64_t> pipeline_handles;
  GetShaderPipelineHandles(device, shader_hash, [&](const auto& handles) {
    pipeline_handles.assign(handles.begin(), handles.end());
  });
  std::vector<reshade::api::pipeline> replacements_to_destroy;
  for (const auto pipeline_handle : pipeline_handles) {
    pipeline::UpdatePipelineInfo({pipeline_handle}, [&](auto& info) {
      auto& details = info.details;
      if (!std::ranges::any_of(details.subobject_shaders, [shader_hash](const auto& shader) {
            return shader.shader_hash == shader_hash;
          })) return;
      if (details.replacement_pipeline.handle != 0u) {
        replacements_to_destroy.push_back(details.replacement_pipeline);
        details.replacement_pipeline = {0u};
      }
      ++details.replacement_revision;
      details.initialized_replacement = false;
    });
  }
  for (const auto replacement : replacements_to_destroy) {
    device->destroy_pipeline(replacement);
  }
}

static void RemoveRuntimeReplacements(reshade::api::device* device, const std::unordered_set<uint32_t>& filter = {}) {
  std::vector<uint32_t> hashes_to_remove;
  std::vector<reshade::api::pipeline> replacements_to_destroy;
  ForEachRuntimeReplacement(device, [&](uint32_t shader_hash, std::span<const uint8_t> bytecode) {
    if (!filter.empty() && !filter.contains(shader_hash)) return;
    hashes_to_remove.emplace_back(shader_hash);
  });
  for (const auto shader_hash : hashes_to_remove) {
    internal::shared.data->runtime_replacements.erase({device, shader_hash});
    std::vector<uint64_t> pipeline_handles;
    GetShaderPipelineHandles(device, shader_hash, [&](const auto& handles) {
      pipeline_handles.assign(handles.begin(), handles.end());
    });
    for (const auto pipeline_handle : pipeline_handles) {
      pipeline::UpdatePipelineInfo({pipeline_handle}, [&](auto& info) {
        auto& details = info.details;
        if (!std::ranges::any_of(details.subobject_shaders, [shader_hash](const auto& shader) {
              return shader.shader_hash == shader_hash;
            })) return;
        if (details.replacement_pipeline.handle != 0u) {
          replacements_to_destroy.push_back(details.replacement_pipeline);
          details.replacement_pipeline = {0u};
        }
        ++details.replacement_revision;
        details.initialized_replacement = false;
      });
    }
  }
  for (const auto replacement : replacements_to_destroy) {
    device->destroy_pipeline(replacement);
  }

  runtime_replacement_count -= hashes_to_remove.size();
}

[[deprecated("Use state::GetBoundShaderPipeline; this reconstructed snapshot is invalidated by the next lookup on this thread.")]]
inline CommandListData* GetCurrentState(reshade::api::command_list* cmd_list) {
  if (internal::shared.data == nullptr) return nullptr;
  state::CommandListStateCache cache;
  state::GetBoundShaderPipeline(cmd_list, reshade::api::pipeline_stage::vertex_shader, &cache);
  if (!cache.has_value() || *cache == nullptr) return nullptr;
  // Compatibility only: the snapshot is not command-list-owned. Callers must not retain it
  // (or pointers to its stages) across another lookup on this thread.
  static thread_local CommandListData snapshot;
  snapshot.last_pipeline = {0u};
  snapshot.stage_states = EMPTY_STAGE_STATES;
  for (int i = 0; i < COMPATIBLE_STAGES_SIZE; ++i) {
    auto& stage_state = snapshot.stage_states[i];
    state::PipelineBind bind = {};
    stage_state.pipeline = state::GetBoundShaderPipeline(cmd_list, stage_state.stage, nullptr, &bind);
    stage_state.applied_stage = bind.stages;
    if (stage_state.pipeline.handle != 0u) {
      GetPipelineShaderDetails(stage_state.pipeline, [&](const PipelineShaderDetails& details) {
        stage_state.pipeline_details = const_cast<PipelineShaderDetails*>(&details);
      });
    }
  }
  return &snapshot;
}

static void OnInitDevice(reshade::api::device* device) {
  if (device == nullptr) return;

  std::stringstream s;
  s << "utils::shader::OnInitDevice(Hooking device: ";
  s << reinterpret_cast<uintptr_t>(device);
  s << ", api: " << device->get_api();
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());

  auto insert_shaders = [device](
                            const data::ParallelFlatHashMap<uint32_t, std::span<const uint8_t>, std::shared_mutex>& source,
                            ShaderBytecodeMap& dest,
                            const std::string& type = "") {
    for (const auto& [shader_hash, replacement] : source) {
      const auto [iterator, is_new] = dest.insert_or_assign(DeviceShaderKey{device, shader_hash}, replacement);
      std::stringstream s;
      s << "utils::shader::OnInitDevice(";
      if (is_new) {
        s << "Registered ";
      } else {
        s << "Overwriting ";
      }
      s << type;
      s << " replacement: ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      if (is_new) {
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      } else {
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
      }
    }
  };

  insert_shaders(internal::compile_time_replacements, internal::shared.data->compile_time_replacements, "compile-time");
  insert_shaders(internal::initial_runtime_replacements, internal::shared.data->runtime_replacements, "runtime");

  insert_shaders(internal::device_based_compile_time_replacements[device->get_api()], internal::shared.data->compile_time_replacements, "API-based compile-time");
  insert_shaders(internal::device_based_initial_runtime_replacements[device->get_api()], internal::shared.data->runtime_replacements, "API-based runtime");

  runtime_replacement_count = internal::shared.data->runtime_replacements.size();
};

static void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "utils::shader::OnDestroyDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  auto erase_device_entries = [device](auto& map) {
    std::vector<DeviceShaderKey> keys;
    map.for_each([&](const auto& pair) {
      if (pair.first.first == device) {
        keys.emplace_back(pair.first);
      }
    });
    for (const auto& key : keys) {
      map.erase(key);
    }
  };
  erase_device_entries(internal::shared.data->compile_time_replacements);
  erase_device_entries(internal::shared.data->runtime_replacements);
  erase_device_entries(internal::shared.data->shader_pipeline_handles);
  runtime_replacement_count = internal::shared.data->runtime_replacements.size();
}

static bool OnCreatePipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  if (!internal::shared.data->use_replace_on_create) return false;
  if (internal::shared.data->use_replace_async) return false;
  if (layout.handle == 0u) {
    // assert(layout.handle != 0u);
    // return false;
  }

  bool replaced = false;
  {
    for (uint32_t i = 0; i < subobject_count; ++i) {
      switch (subobjects[i].type) {
        case reshade::api::pipeline_subobject_type::vertex_shader:
        case reshade::api::pipeline_subobject_type::hull_shader:
        case reshade::api::pipeline_subobject_type::domain_shader:
        case reshade::api::pipeline_subobject_type::geometry_shader:
        case reshade::api::pipeline_subobject_type::pixel_shader:
        case reshade::api::pipeline_subobject_type::compute_shader:
        case reshade::api::pipeline_subobject_type::amplification_shader:
        case reshade::api::pipeline_subobject_type::mesh_shader:
          break;
        default:
          continue;
      }
      auto* desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
      if (desc->code_size == 0) continue;

      const uint32_t shader_hash = renodx::utils::hash::ComputeCRC32(
          static_cast<const uint8_t*>(desc->code),
          desc->code_size);

      internal::shared.data->compile_time_replacements.if_contains(
          {device, shader_hash},
          [&](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::span<const uint8_t>>& pair) {
            const auto replacement = pair.second;
            auto new_size = replacement.size();
            if (new_size == 0u) return;

            desc->code_size = new_size;
            // Vulkan may retain the original stage's entry point when the descriptor is null.
            desc->entry_point = (device->get_api() == reshade::api::device_api::vulkan ? "main" : nullptr);
            desc->code = replacement.data();
            replaced = true;
            std::stringstream s;
            s << "utils::shader::OnCreatePipeline(replacing ";
            s << PRINT_CRC32(shader_hash);
            s << " with " << new_size << " bytes ";
            s << " at " << const_cast<void*>(desc->code);
            s << ")";
            reshade::log::message(reshade::log::level::info, s.str().c_str());
          });
    }
  }

  return replaced;
}

static void OnInitPipeline(
    renodx::utils::pipeline::PipelineInfo* pipeline_info,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  if (!internal::shared.IsEventHandler()) return;

  auto* device = pipeline_info->device;
  const auto layout = pipeline_info->layout;
  const auto pipeline = pipeline_info->pipeline;
  if (layout.handle == 0u) {
    // assert(layout.handle != 0u);
    // return;
  }
  if (pipeline.handle == 0u) return;

  auto details = PipelineShaderDetails(
      pipeline,
      device,
      layout,
      subobjects,
      subobject_count,
      {pipeline_info->shader_details.data(), pipeline_info->shader_details.size()},
      {pipeline_info->replaced_shader_subobject_indexes.data(), pipeline_info->replaced_shader_subobject_indexes.size()});

  if (pipeline::internal::shared.data->cache_subobjects && subobject_count != 0u) {
    reshade::api::pipeline_subobject* subobjects_clone = renodx::utils::pipeline::ClonePipelineSubObjects(subobjects, subobject_count);

    // Store clone of subobjects
    details.subobjects.assign(
        subobjects_clone,
        subobjects_clone + subobject_count);

    // The shader bytecode cache may outlive the pipeline's live identity record.
    for (const auto& identity : pipeline_info->shader_details) {
      details.subobject_shaders.push_back({
          .subobject_index = identity.subobject_index,
          .shader_hash = identity.shader_hash,
          .stage = identity.stage,
      });
    }

    delete[] subobjects_clone;
  }

  pipeline_info->details = std::move(details);
  if (internal::shared.data->use_pipeline_lookup && !pipeline_info->details.subobject_shaders.empty()) {
    for (const auto& identity : pipeline_info->shader_details) {
      const DeviceShaderKey key{device, identity.shader_hash};
      internal::shared.data->shader_pipeline_handles.lazy_emplace_l(
          key,
          [&](auto& entry) {
            entry.second.emplace(pipeline.handle);
          },
          [&](const auto& ctor) {
            ctor(key, ShaderPipelineHandleSet{pipeline.handle});
          });
    }
  }
}

static void OnDestroyPipeline(
    const renodx::utils::pipeline::PipelineInfo& pipeline_info) {
  if (!internal::shared.IsEventHandler()) return;

  if (internal::shared.data->use_pipeline_lookup) {
    for (const auto& identity : pipeline_info.shader_details) {
      internal::shared.data->shader_pipeline_handles.erase_if(
          {pipeline_info.device, identity.shader_hash},
          [&](auto& entry) {
            entry.second.erase(pipeline_info.pipeline.handle);
            return entry.second.empty();
          });
    }
  }
  if (pipeline_info.details.replacement_pipeline.handle != 0u) {
    pipeline_info.device->destroy_pipeline(pipeline_info.details.replacement_pipeline);
  }
}

// AfterSetPipelineState
inline std::optional<reshade::api::pipeline> OnBindPipelineForReplacement(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stages,
    reshade::api::pipeline pipeline,
    pipeline::PipelineBindPoint bind_point,
    const pipeline::PipelineInfo* info) {
  (void)cmd_list;
  if (!internal::shared.IsEventHandler() || GetReplaceOnBindPolicy() != true || pipeline.handle == 0u) {
    return reshade::api::pipeline{0u};
  }

  auto affected_stages = stages;
  if (stages == reshade::api::pipeline_stage::all) {
    switch (bind_point) {
      case pipeline::PipelineBindPoint::GRAPHICS:
        affected_stages = reshade::api::pipeline_stage::all_graphics
                          | reshade::api::pipeline_stage::amplification_shader
                          | reshade::api::pipeline_stage::mesh_shader;
        break;
      case pipeline::PipelineBindPoint::COMPUTE:
        affected_stages = reshade::api::pipeline_stage::compute_shader;
        break;
      case pipeline::PipelineBindPoint::RAY_TRACING:
      case pipeline::PipelineBindPoint::UNKNOWN:
        return reshade::api::pipeline{0u};
    }
  }
  if (!bitwise::HasAnyFlag(
          affected_stages,
          reshade::api::pipeline_stage::all_shader_stages
              | reshade::api::pipeline_stage::amplification_shader
              | reshade::api::pipeline_stage::mesh_shader)) {
    return reshade::api::pipeline{0u};
  }

  if (info != nullptr) {
    const auto& details = info->details;
    if (details.destroyed || details.is_replacement) return reshade::api::pipeline{0u};
    if (!details.initialized_replacement
        || (details.replacement_stages != static_cast<reshade::api::pipeline_stage>(0u)
            && details.replacement_pipeline.handle == 0u)) {
      return std::nullopt;
    }
    if (bitwise::HasAnyFlag(affected_stages, details.replacement_stages)) {
      return details.replacement_pipeline;
    }
    return reshade::api::pipeline{0u};
  }

  reshade::api::pipeline replacement_pipeline = {0u};
  WithReplacementPipeline(pipeline, [&](reshade::api::pipeline replacement, reshade::api::pipeline_stage replacement_stages) {
    if (replacement.handle != 0u && bitwise::HasAnyFlag(affected_stages, replacement_stages)) {
      replacement_pipeline = replacement;
    }
  });
  return replacement_pipeline;
}

static std::optional<std::vector<uint8_t>> GetShaderData(
    const PipelineShaderDetails& details,
    const pipeline::PipelineShaderHashEntry& info) {
  const auto& subobject = details.subobjects[info.subobject_index];
  const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);
  if (desc.code_size == 0) return {};
  return std::vector<uint8_t>({
      static_cast<const uint8_t*>(desc.code),
      static_cast<const uint8_t*>(desc.code) + desc.code_size,
  });
}

static std::optional<std::vector<uint8_t>> GetShaderData(
    const reshade::api::pipeline& pipeline,
    const uint32_t& shader_hash) {
  std::optional<std::vector<uint8_t>> shader_data = std::nullopt;
  GetPipelineShaderDetails(pipeline, [&](const PipelineShaderDetails& details) {
    for (const auto& info : details.subobject_shaders) {
      if (info.shader_hash != shader_hash) continue;
      shader_data = GetShaderData(details, info);
      return;
    }
  });
  return shader_data;
}

static std::optional<std::vector<uint8_t>> GetShaderData(
    const reshade::api::pipeline& pipeline,
  const pipeline::PipelineShaderHashEntry& info) {
  std::optional<std::vector<uint8_t>> shader_data = std::nullopt;
  GetPipelineShaderDetails(pipeline, [&](const PipelineShaderDetails& details) {
    shader_data = GetShaderData(details, info);
  });
  return shader_data;
}

static std::optional<std::vector<uint8_t>> GetShaderData(const StageState* stage_state, const int& index) {
  if (stage_state->pipeline_details == nullptr) return std::nullopt;
  return GetShaderData(stage_state->pipeline, pipeline::GetPipelineShaderHash(stage_state->pipeline, COMPATIBLE_STAGES[index]));
}

static std::optional<std::vector<uint8_t>> GetShaderData(const StageState* stage_state) {
  return GetShaderData(stage_state, PIXEL_INDEX);
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      renodx::utils::pipeline::EnableShaderHashTracking();
      if (use_replace_async || use_shader_cache || use_pipeline_lookup) {
        renodx::utils::pipeline::EnableSubobjectCaching();
        renodx::utils::pipeline::EnableDestroyedSubobjectRetention();
      }
      renodx::utils::pipeline::Use(fdw_reason);
      renodx::utils::pipeline_layout::Use(fdw_reason);
      renodx::utils::state::use_pipeline_tracking = true;
      renodx::utils::state::Use(fdw_reason);
      internal::shared.RegisterModule([](internal::SharedData& data) {
        if (!use_replace_on_create) {
          data.use_replace_on_create = use_replace_on_create;
        }
        if (!use_replace_on_bind) {
          data.use_replace_on_bind = use_replace_on_bind;
        }
        if (use_replace_async) {
          data.use_replace_async = use_replace_async;
        }
        if (use_shader_cache) {
          data.use_shader_cache = use_shader_cache;
        }
        if (use_pipeline_lookup || use_replace_async) {
          data.use_pipeline_lookup = true;
        }
      });
      if (internal::shared.data->use_replace_async || internal::shared.data->use_shader_cache || internal::shared.data->use_pipeline_lookup) {
        pipeline::EnableSubobjectCaching();
        pipeline::EnableDestroyedSubobjectRetention();
      }
      internal::shared.RegisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      renodx::utils::pipeline::RegisterOnCreateCallback(
          OnCreatePipeline, internal::shared.data->use_replace_on_create && !internal::shared.data->use_replace_async);
      renodx::utils::pipeline::RegisterOnInitCallback(OnInitPipeline);
      if (internal::shared.data->use_replace_on_bind) {
        renodx::utils::pipeline::RegisterOnBindInfoCallback(OnBindPipelineForReplacement);
      }
      renodx::utils::pipeline::RegisterOnDestroyCallback(OnDestroyPipeline);

      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "utils::shader attached.");
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);

      break;
    case DLL_PROCESS_DETACH:
      internal::shared.UnregisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      renodx::utils::pipeline::UnregisterOnCreateCallback(OnCreatePipeline);
      renodx::utils::pipeline::UnregisterOnInitCallback(OnInitPipeline);
      renodx::utils::pipeline::UnregisterOnBindInfoCallback(OnBindPipelineForReplacement);
      renodx::utils::pipeline::UnregisterOnDestroyCallback(OnDestroyPipeline);
      internal::shared.UnregisterModule();
      renodx::utils::state::Use(fdw_reason);
      renodx::utils::pipeline_layout::Use(fdw_reason);
      renodx::utils::pipeline::Use(fdw_reason);
      if (!attached) return;
      attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      break;
  }
}

}  // namespace renodx::utils::shader
