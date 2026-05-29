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

#include <array>
#include <atomic>
#include <cassert>
#include <cstdint>
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
#include "./data.hpp"
#include "./directx.hpp"
#include "./format.hpp"
#include "./hash.hpp"
#include "./log.hpp"
#include "./pipeline.hpp"
#include "./pipeline_layout.hpp"

namespace renodx::utils::shader {

static bool use_replace_on_create = true;
static bool use_replace_on_bind = true;
static bool use_replace_async = false;
static bool use_shader_cache = false;
static std::atomic_size_t runtime_replacement_count = 0;

enum ShaderStageIndex : std::uint8_t {
  VERTEX_INDEX = 0,
  PIXEL_INDEX,
  COMPUTE_INDEX,
  COMPATIBLE_STAGES_SIZE,
};

static const std::array<reshade::api::pipeline_stage, COMPATIBLE_STAGES_SIZE> COMPATIBLE_STAGES = {
    reshade::api::pipeline_stage::vertex_shader,
    reshade::api::pipeline_stage::pixel_shader,
    reshade::api::pipeline_stage::compute_shader,
};

static const std::unordered_map<reshade::api::pipeline_stage, reshade::api::pipeline_subobject_type> COMPATIBLE_STAGE_TO_SUBOBJECT_TYPE = {
    {reshade::api::pipeline_stage::vertex_shader, reshade::api::pipeline_subobject_type::vertex_shader},
    {reshade::api::pipeline_stage::pixel_shader, reshade::api::pipeline_subobject_type::pixel_shader},
    {reshade::api::pipeline_stage::compute_shader, reshade::api::pipeline_subobject_type::compute_shader},
};

static const std::unordered_map<reshade::api::pipeline_subobject_type, reshade::api::pipeline_stage> COMPATIBLE_SUBOBJECT_TYPE_TO_STAGE = {
    {reshade::api::pipeline_subobject_type::vertex_shader, reshade::api::pipeline_stage::vertex_shader},
    {reshade::api::pipeline_subobject_type::pixel_shader, reshade::api::pipeline_stage::pixel_shader},
    {reshade::api::pipeline_subobject_type::compute_shader, reshade::api::pipeline_stage::compute_shader},
};

struct PipelineSubobjectShaderInfo {
  uint32_t index;
  uint32_t shader_hash = 0u;
  uint32_t replacement_shader_hash;
  reshade::api::pipeline_stage stage = static_cast<reshade::api::pipeline_stage>(0u);
  cross_addon::vector<std::uint8_t> replacement_shader;
};

static void AddShaderReplacement(
    reshade::api::pipeline_subobject* subobject,
    std::span<const uint8_t> new_shader) {
  auto* desc = static_cast<reshade::api::shader_desc*>(subobject->data);
  assert(desc != nullptr);
  if (desc == nullptr) return;
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

struct PipelineShaderDetails;  // Forward declaration

using DeviceShaderKey = std::pair<reshade::api::device*, uint32_t>;
using PipelineShaderDetailsMap = cross_addon::parallel_node_hash_map<uint64_t, PipelineShaderDetails, std::shared_mutex>;
using ShaderPipelineHandleSet = cross_addon::unordered_set<uint64_t>;
using ShaderPipelineHandlesMap = cross_addon::parallel_node_hash_map<DeviceShaderKey, ShaderPipelineHandleSet, std::shared_mutex>;
using ShaderBytecodeMap = cross_addon::parallel_flat_hash_map<DeviceShaderKey, std::span<const uint8_t>, std::shared_mutex>;
using ShaderReplacementMap = cross_addon::parallel_flat_hash_map<DeviceShaderKey, uint32_t, std::shared_mutex>;

struct __declspec(uuid("95658d72-99a7-49da-89d6-b5d3ecb21f06")) SharedData {
  PipelineShaderDetailsMap pipeline_shader_details;
  ShaderPipelineHandlesMap shader_pipeline_handles;
  ShaderBytecodeMap compile_time_replacements;
  ShaderBytecodeMap runtime_replacements;
  ShaderReplacementMap shader_replacements;          // Old => New
  ShaderReplacementMap shader_replacements_inverse;  // New => Old
  bool use_replace_on_create = true;
  bool use_replace_on_bind = true;
  bool use_replace_async = false;
  bool use_shader_cache = false;
};

static cross_addon::Shared<SharedData> shared;

struct PipelineShaderDetails {
  reshade::api::pipeline pipeline = {0u};
  reshade::api::device* device = nullptr;
  reshade::api::pipeline_layout layout = {0};
  cross_addon::vector<reshade::api::pipeline_subobject> subobjects;
  cross_addon::vector<PipelineSubobjectShaderInfo> subobject_shaders;
  std::array<PipelineSubobjectShaderInfo, COMPATIBLE_STAGES_SIZE> compatible_shader_infos = {};
  cross_addon::unordered_set<uint32_t> shader_hashes;
  reshade::api::pipeline replacement_pipeline = {0};
  reshade::api::pipeline_stage replacement_stages = static_cast<reshade::api::pipeline_stage>(0u);
  [[deprecated("Use injection_layout and injection_index instead.")]]
  const renodx::utils::pipeline_layout::PipelineLayoutData* layout_data = nullptr;
  bool initialized_replacement = false;

  std::optional<cross_addon::string> tag;
  bool destroyed = false;
  bool is_replacement = false;

  reshade::api::pipeline_layout injection_layout = {0u};
  int32_t injection_index = -1;
  int32_t injection_register_index = -1;
  cross_addon::unordered_map<
      renodx::utils::pipeline_layout::DescriptorBindingKey,
      renodx::utils::pipeline_layout::DescriptorPushLocation,
      renodx::utils::pipeline_layout::DescriptorBindingKeyHash>
      descriptor_push_locations;

  PipelineShaderDetails() = default;

  PipelineShaderDetails(
      reshade::api::pipeline pipeline,
      reshade::api::device* device,
      const reshade::api::pipeline_layout& layout,
      const reshade::api::pipeline_subobject* subobjects,
      const uint32_t& subobject_count)
      : pipeline(pipeline),
        device(device),
        layout(layout) {
    pipeline_layout::GetPipelineLayoutData(layout, [&](const auto& layout_data) {
      this->injection_layout = layout_data->injection_layout;
      this->injection_index = layout_data->injection_index;
      this->injection_register_index = layout_data->injection_register_index;
      this->descriptor_push_locations.clear();
      this->descriptor_push_locations.insert(
          layout_data->descriptor_push_locations.begin(),
          layout_data->descriptor_push_locations.end());

      this->layout_data = layout_data;
    });
    reshade::api::pipeline_subobject* replacement_subobjects = nullptr;
    for (uint32_t i = 0; i < subobject_count; ++i) {
      const auto& subobject = subobjects[i];
      int shader_type_index;
      switch (subobject.type) {
        case reshade::api::pipeline_subobject_type::vertex_shader:
          shader_type_index = VERTEX_INDEX;
          break;
        case reshade::api::pipeline_subobject_type::pixel_shader:
          shader_type_index = PIXEL_INDEX;
          break;
        case reshade::api::pipeline_subobject_type::compute_shader:
          shader_type_index = COMPUTE_INDEX;
          break;
        default:
          continue;
      }

      const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);

      std::stringstream s;
      s << "utils::shader::PipelineShaderDetails(";
      s << "Pipeline: " << PRINT_PTR(pipeline.handle);
      s << ", Index: " << i;
      s << ", Type: " << subobject.type;
      s << ", Stage: " << COMPATIBLE_STAGES[shader_type_index];
      s << ", Count: " << subobject.count;
      s << ", Code Size: " << desc.code_size;

      if (desc.code_size == 0) {
        s << ", Code: (empty)";
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
        continue;
      }

      // Pipeline has a shader with code. Hash code and check

      uint32_t shader_hash = renodx::utils::hash::ComputeCRC32(static_cast<const uint8_t*>(desc.code), desc.code_size);
      // if (this->layout_data.has_value() && this->layout_data->params.empty()) {
      //   s << ", Layout: " << PRINT_PTR(this->layout_data->layout.handle);
      //   s << ", Layout Params: " << this->layout_data->params.size();
      //   s << ", Shader Hash: " << PRINT_CRC32(shader_hash);
      //   s << ")";
      //   reshade::log::message(reshade::log::level::debug, s.str().c_str());
      // }
      const auto& stage = COMPATIBLE_STAGES[shader_type_index];

      // Shader may have been replaced. Get original hash
      if (shared.data->shader_replacements_inverse.if_contains(
              {device, shader_hash},
              [&](const std::pair<const std::pair<reshade::api::device*, uint32_t>, uint32_t>& pair) {
#ifdef DEBUG_LEVEL_1
                std::stringstream s;
                s << "utils::shader::PipelineShaderDetails(Storing original ";
                s << PRINT_CRC32(shader_hash);
                s << "=>";
                s << PRINT_CRC32(pair.second);
                s << ", pipeline: " << static_cast<uintptr_t>(this->pipeline.handle);
                s << ")";
                reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
                shader_hash = pair.second;
              })) {
        this->initialized_replacement = true;
      } else {
        if (!shared.data->use_replace_async) {
          shared.data->runtime_replacements.if_contains(
              {device, shader_hash},
              [&](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::span<const uint8_t>>& pair) {
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
                AddShaderReplacement(&replacement_subobjects[i], pair.second);
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
      }
      this->shader_hashes.emplace(shader_hash);

      this->subobject_shaders.push_back({
          .index = i,
          .shader_hash = shader_hash,
          .stage = stage,
      });
      this->compatible_shader_infos[shader_type_index] = this->subobject_shaders.back();

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
      if (this->layout_data != nullptr && this->layout_data->replacement_layout.handle != 0u) {
        create_layout = this->layout_data->replacement_layout;
      }

      const bool built_pipeline_ok = device->create_pipeline(
          create_layout,
          subobject_count,
          replacement_subobjects,
          &new_pipeline);

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
        PipelineShaderDetails new_details = PipelineShaderDetails();
        new_details.pipeline = new_pipeline;
        new_details.device = device;
        new_details.layout = create_layout;
        new_details.is_replacement = true;
        shared.data->pipeline_shader_details.insert_or_assign(
            new_pipeline.handle,
            std::move(new_details));

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
};

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
  reshade::api::pipeline last_pipeline;
  std::array<StageState, 3> stage_states = EMPTY_STAGE_STATES;
};

inline PipelineShaderDetails* GetPipelineShaderDetails(const reshade::api::pipeline& pipeline) {
  PipelineShaderDetails* details = nullptr;

  shared.data->pipeline_shader_details.if_contains(
      pipeline.handle,
      [&](std::pair<const uint64_t, PipelineShaderDetails>& pair) {
        details = &pair.second;
      });

  if (details == nullptr) {
    log::e("utils::shader::GetPipelineShaderDetails(Pipeline not found for handle: ",
           log::AsPtr(pipeline.handle), ")");
    assert(details != nullptr);
  }

  return details;
}

inline void PopulateStageState(StageState* stage_state) {
  if (stage_state->pipeline == 0u) return;
  if (stage_state->pipeline_details != nullptr) return;
  stage_state->pipeline_details = GetPipelineShaderDetails(stage_state->pipeline);
}

inline StageState* GetCurrentVertexState(CommandListData* cmd_list_data) {
  return &cmd_list_data->stage_states[VERTEX_INDEX];
}
inline StageState* GetCurrentPixelState(CommandListData* cmd_list_data) {
  return &cmd_list_data->stage_states[PIXEL_INDEX];
}
inline StageState* GetCurrentComputeState(CommandListData* cmd_list_data) {
  return &cmd_list_data->stage_states[COMPUTE_INDEX];
}

inline uint32_t GetCurrentShaderHash(StageState* stage_state, const int& index) {
  PopulateStageState(stage_state);
  if (stage_state->pipeline_details == nullptr) return 0u;
  assert(index < COMPATIBLE_STAGES_SIZE);
  return stage_state->pipeline_details->compatible_shader_infos[index].shader_hash;
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

static bool BuildReplacementPipeline(PipelineShaderDetails* details) {
  if (details->initialized_replacement) return true;
  details->initialized_replacement = true;
  details->replacement_pipeline = {0};
  details->replacement_stages = static_cast<reshade::api::pipeline_stage>(0);
  if (details->subobject_shaders.empty()) return true;

  auto subobject_count = details->subobjects.size();

  reshade::api::pipeline_subobject* replacement_subobjects = nullptr;
  details->replacement_stages = static_cast<reshade::api::pipeline_stage>(0);
  for (const auto& info : details->subobject_shaders) {
    shared.data->runtime_replacements.if_contains(
        {details->device, info.shader_hash},
        [&](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::span<const uint8_t>>& new_shader_pair) {
          if (replacement_subobjects == nullptr) {
            replacement_subobjects = renodx::utils::pipeline::ClonePipelineSubObjects(
                details->subobjects.data(),
                subobject_count);
          }
          auto& subobject = replacement_subobjects[info.index];
#ifdef DEBUG_LEVEL_0
          {
            std::stringstream s;
            s << "utils::shader::BuildReplacementPipeline(Replacing ";
            s << PRINT_CRC32(info.shader_hash);
            s << ")";
            reshade::log::message(reshade::log::level::debug, s.str().c_str());
          }
#endif
          AddShaderReplacement(&subobject, new_shader_pair.second);
          details->replacement_stages |= info.stage;
        });
  }

  if (replacement_subobjects != nullptr) {
    reshade::api::pipeline new_pipeline;
    auto layout = details->injection_layout != 0u ? details->injection_layout : details->layout;
    if (details->layout_data != nullptr && details->layout_data->replacement_layout.handle != 0u) {
      layout = details->layout_data->replacement_layout;
    }

    const bool built_pipeline_ok = details->device->create_pipeline(
        layout,
        subobject_count,
        replacement_subobjects,
        &new_pipeline);
    renodx::utils::pipeline::DestroyPipelineSubobjects(replacement_subobjects, subobject_count);
    if (built_pipeline_ok) {
#ifdef DEBUG_LEVEL_0
      {
        std::stringstream s;
        s << "utils::shader::BuildReplacementPipeline(New pipeline ";
        s << PRINT_PTR(new_pipeline.handle);
        s << " on layout ";
        s << PRINT_PTR(layout.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      }
#endif
      details->replacement_pipeline = new_pipeline;
      PipelineShaderDetails new_details = PipelineShaderDetails();
      new_details.pipeline = new_pipeline;
      new_details.device = details->device;
      new_details.layout = layout;
      new_details.injection_layout = details->injection_layout;
      new_details.injection_index = details->injection_index;
      new_details.injection_register_index = details->injection_register_index;
      new_details.descriptor_push_locations = details->descriptor_push_locations;
      new_details.is_replacement = true;
      shared.data->pipeline_shader_details.insert_or_assign(
          new_pipeline.handle,
          std::move(new_details));
      return true;
    };

#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "utils::shader::BuildReplacementPipeline(Failed to replace pipeline";
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
#endif
  }

  details->replacement_pipeline = {0};
  details->replacement_stages = static_cast<reshade::api::pipeline_stage>(0);
  return false;
}

inline bool ApplyReplacement(reshade::api::command_list* cmd_list, StageState* stage_state) {
  PopulateStageState(stage_state);
  if (stage_state->pipeline_details == nullptr) return false;
  if (stage_state->pipeline_details->is_replacement) return true;

  auto* details = stage_state->pipeline_details;
  BuildReplacementPipeline(details);

  if (details->replacement_pipeline.handle != 0u) {
#ifdef DEBUG_LEVEL_2
    std::stringstream s;
    s << "utils::shader::ApplyReplacement(Applying replacement ";
    s << stage_state->stage;
    s << ", pipeline: " << static_cast<uintptr_t>(details->replacement_pipeline.handle);
    s << ", shader: " << PRINT_CRC32(GetCurrentShaderHash(stage_state));
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    if (renodx::utils::bitwise::HasFlag(details->replacement_stages, stage_state->stage)) {
      cmd_list->bind_pipeline(stage_state->applied_stage, details->replacement_pipeline);
      return true;
      // state.pending_replacement = {0u};
    }
  }
  return false;
}

inline void ApplyDispatchReplacements(reshade::api::command_list* cmd_list, CommandListData* cmd_list_data) {
  ApplyReplacement(cmd_list, GetCurrentComputeState(cmd_list_data));
}

inline void ApplyDrawReplacements(reshade::api::command_list* cmd_list, CommandListData* cmd_list_data) {
  ApplyReplacement(cmd_list, GetCurrentVertexState(cmd_list_data));
  ApplyReplacement(cmd_list, GetCurrentPixelState(cmd_list_data));
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
  shared.data->runtime_replacements[{device, shader_hash}] = shader_data;
  runtime_replacement_count = shared.data->runtime_replacements.size();
  shared.data->shader_pipeline_handles.modify_if(
      {device, shader_hash},
      [&](std::pair<const DeviceShaderKey, ShaderPipelineHandleSet>& pair) {
        auto& handles = pair.second;
        for (auto pipeline_handle : handles) {
          shared.data->pipeline_shader_details.modify_if(pipeline_handle, [&](std::pair<const uint64_t, PipelineShaderDetails>& pair) {
            auto& details = pair.second;
            if (details.replacement_pipeline.handle != 0u) {
              device->destroy_pipeline(details.replacement_pipeline);
              details.replacement_pipeline = {0u};
            }
            details.initialized_replacement = false;
          });
        }
      });
}

static void RemoveRuntimeReplacements(reshade::api::device* device, const std::unordered_set<uint32_t>& filter = {}) {
  std::vector<uint32_t> hashes_to_remove;
  shared.data->runtime_replacements.for_each_m(
      [&](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::span<const uint8_t>>& pair) {
        const auto& [item_device, shader_hash] = pair.first;
        if (item_device != device) return;  // Only remove replacements for the specified device
        if (!filter.empty() && !filter.contains(shader_hash)) return;
        shared.data->shader_pipeline_handles.modify_if(
            {device, shader_hash},
            [&](std::pair<const DeviceShaderKey, ShaderPipelineHandleSet>& pair) {
              auto& handles = pair.second;
              if (handles.empty()) return;
              for (auto pipeline_handle : handles) {
                shared.data->pipeline_shader_details.modify_if(pipeline_handle, [&](std::pair<const uint64_t, PipelineShaderDetails>& details_pair) {
                  auto& details = details_pair.second;
                  if (details.replacement_pipeline.handle != 0u) {
                    device->destroy_pipeline(details.replacement_pipeline);
                    details.replacement_pipeline = {0u};
                  }
                  details.initialized_replacement = false;
                });
              }
            });
        hashes_to_remove.emplace_back(shader_hash);
      });
  for (const auto& hash : hashes_to_remove) {
    shared.data->runtime_replacements.erase({device, hash});
  }

  runtime_replacement_count -= hashes_to_remove.size();
}

inline CommandListData* GetCurrentState(reshade::api::command_list* cmd_list) {
  return renodx::utils::data::Get<CommandListData>(cmd_list);
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
      auto [iterator, is_new] = dest.emplace(std::pair<reshade::api::device*, uint32_t>({device, shader_hash}), replacement);
      std::stringstream s;
      s << "utils::shader::OnInitDevice(";
      if (is_new) {
        s << "Registered ";
      } else {
        s << "Ovewriting ";
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

  insert_shaders(internal::compile_time_replacements, shared.data->compile_time_replacements, "compile-time");
  insert_shaders(internal::initial_runtime_replacements, shared.data->runtime_replacements, "runtime");

  insert_shaders(internal::device_based_compile_time_replacements[device->get_api()], shared.data->compile_time_replacements, "API-based compile-time");
  insert_shaders(internal::device_based_initial_runtime_replacements[device->get_api()], shared.data->runtime_replacements, "API-based runtime");

  runtime_replacement_count = shared.data->runtime_replacements.size();
};

static void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "utils::shader::OnDestroyDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  std::vector<uint64_t> pipeline_handles;
  shared.data->pipeline_shader_details.for_each_m(
      [&](std::pair<const uint64_t, PipelineShaderDetails>& pair) {
        auto& [pipeline_handle, details] = pair;
        if (details.device != device) return;
        // DestroyPipelineSubobjects is concurrency-safe
        pipeline_handles.emplace_back(pipeline_handle);
        renodx::utils::pipeline::DestroyPipelineSubobjects(details.subobjects);
      });
  for (const auto& pipeline_handle : pipeline_handles) {
    shared.data->pipeline_shader_details.erase(pipeline_handle);
  }
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

static void OnResetCommandList(reshade::api::command_list* cmd_list) {
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (data == nullptr) return;
  data->last_pipeline = {0u};
  data->stage_states[0].pipeline = {0u};
  data->stage_states[1].pipeline = {0u};
  data->stage_states[2].pipeline = {0u};

  data->stage_states[0].pipeline_details = nullptr;
  data->stage_states[1].pipeline_details = nullptr;
  data->stage_states[2].pipeline_details = nullptr;
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

static bool OnCreatePipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  if (!shared.data->use_replace_on_create) return false;
  if (shared.data->use_replace_async) return false;
  if (layout.handle == 0u) {
    // assert(layout.handle != 0u);
    // return false;
  }

  std::vector<std::pair<uint32_t, uint32_t>> hash_changes;

  {
    for (uint32_t i = 0; i < subobject_count; ++i) {
      if (!COMPATIBLE_SUBOBJECT_TYPE_TO_STAGE.contains(subobjects[i].type)) continue;
      auto* desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
      if (desc->code_size == 0) continue;

      const uint32_t shader_hash = renodx::utils::hash::ComputeCRC32(
          static_cast<const uint8_t*>(desc->code),
          desc->code_size);

      shared.data->compile_time_replacements.if_contains(
          {device, shader_hash},
          [&](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::span<const uint8_t>>& pair) {
            const auto replacement = pair.second;
            auto new_size = replacement.size();

            desc->code_size = new_size;

            if (new_size == 0) {
              desc->code = nullptr;
              hash_changes.emplace_back(shader_hash, 0);
            } else {
              desc->code = malloc(new_size);
              memcpy(const_cast<void*>(desc->code), replacement.data(), new_size);
              const uint32_t new_hash = renodx::utils::hash::ComputeCRC32(
                  replacement.data(),
                  new_size);
              hash_changes.emplace_back(shader_hash, new_hash);
            }
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

  if (hash_changes.empty()) return false;

  for (auto& [shader_hash, new_hash] : hash_changes) {
    shared.data->shader_replacements[{device, shader_hash}] = new_hash;
    if (new_hash != 0u) {
      shared.data->shader_replacements_inverse[{device, new_hash}] = shader_hash;
    }
  }
  return true;
}

static void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
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
      subobject_count);

  bool has_useful_details = !details.subobject_shaders.empty();
  if (has_useful_details && (shared.data->use_replace_async || shared.data->use_shader_cache)) {
    reshade::api::pipeline_subobject* subobjects_clone = renodx::utils::pipeline::ClonePipelineSubObjects(subobjects, subobject_count);

    // Store clone of subobjects
    details.subobjects.assign(
        subobjects_clone,
        subobjects_clone + subobject_count);

    free(subobjects_clone);
  }

  if (shared.data->use_replace_async) {
    for (const auto shader_hash : details.shader_hashes) {
      shared.data->shader_pipeline_handles.try_emplace_l(
          std::pair<reshade::api::device*, uint32_t>{device, shader_hash},
          [pipeline](std::pair<const DeviceShaderKey, ShaderPipelineHandleSet>& pair) { pair.second.emplace(pipeline.handle); },
          ShaderPipelineHandleSet({pipeline.handle}));
    }
  }

  bool was_destroyed = false;
  auto [pair, inserted] = shared.data->pipeline_shader_details.try_emplace_p(pipeline.handle, details);
  if (!inserted) {
    assert(pair->second.pipeline.handle == pipeline.handle);
    was_destroyed = pair->second.destroyed;
    if (!pair->second.destroyed) {
#ifdef DEBUG_LEVEL_3
      std::stringstream s;
      s << "utils::shader::OnInitPipeline(Reinserted pipeline: ";
      s << PRINT_PTR(pipeline.handle);
      s << ", Device: " << PRINT_PTR(reinterpret_cast<uintptr_t>(device));
      s << ", Layout: " << PRINT_PTR(layout.handle);
      s << ", Subobjects: " << pair->second.subobjects.size() << " => " << subobject_count;
      s << ", Shader hashes: " << pair->second.shader_hashes.size() << " => " << details.shader_hashes.size();
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
      if (pair->second.replacement_pipeline.handle != 0u) {
        device->destroy_pipeline(pair->second.replacement_pipeline);
      }
      if (shared.data->use_replace_async || shared.data->use_shader_cache) {
        // Retain subobjects for async replacement or shader cache
      } else {
        renodx::utils::pipeline::DestroyPipelineSubobjects(pair->second.subobjects);
      }
    }
    if (shared.data->use_replace_async) {
      for (const auto shader_hash : pair->second.shader_hashes) {
        shared.data->shader_pipeline_handles.modify_if(
            {device, shader_hash},
            [&](std::pair<const DeviceShaderKey, ShaderPipelineHandleSet>& pair) {
              pair.second.erase(pipeline.handle);
            });
      }
    }
    pair->second = details;
  }
}

static void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  if (shared.data->use_replace_async || shared.data->use_shader_cache) {
    shared.data->pipeline_shader_details.modify_if(pipeline.handle, [&](std::pair<const uint64_t, PipelineShaderDetails>& pair) {
      auto& details = pair.second;
      details.destroyed = true;
      if (details.replacement_pipeline.handle != 0u) {
        device->destroy_pipeline(details.replacement_pipeline);
        details.replacement_pipeline = {0u};
      }
    });
  } else {
    shared.data->pipeline_shader_details.erase_if(pipeline.handle, [&](std::pair<const uint64_t, PipelineShaderDetails>& pair) {
      auto& details = pair.second;
      details.destroyed = true;
      if (details.replacement_pipeline.handle != 0u) {
        device->destroy_pipeline(details.replacement_pipeline);
        details.replacement_pipeline = {0u};
      }
      // DestroyPipelineSubobjects is concurrency-safe
      renodx::utils::pipeline::DestroyPipelineSubobjects(details.subobjects);
      return true;
    });
  }
}

// AfterSetPipelineState
inline void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    reshade::api::pipeline pipeline) {
  CommandListData* cmd_list_data = nullptr;
  for (int i = 0; i < COMPATIBLE_STAGES_SIZE; ++i) {
    auto compatible_stage = COMPATIBLE_STAGES[i];
    if (stage == reshade::api::pipeline_stage::all
        || renodx::utils::bitwise::HasFlag(stage, compatible_stage)) {
      if (cmd_list_data == nullptr) {
        cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
      }
      if (pipeline.handle != 0u) {
        // Track only pipeline changes that can cause layout change
        cmd_list_data->last_pipeline = pipeline;
      } else {
        // Reset last pipeline if no pipeline is bound
        cmd_list_data->last_pipeline = cmd_list_data->last_pipeline;
      }

      if (cmd_list_data->stage_states[i].pipeline != pipeline) {
        cmd_list_data->stage_states[i].pipeline = pipeline;
        cmd_list_data->stage_states[i].pipeline_details = nullptr;
      }
      cmd_list_data->stage_states[i].applied_stage = stage;
      if (pipeline.handle != 0 && shared.data->use_replace_on_bind) {
        ApplyReplacement(cmd_list, &cmd_list_data->stage_states[i]);
      }
    }
  }
}

static std::optional<std::vector<uint8_t>> GetShaderData(
    const PipelineShaderDetails& details,
    const PipelineSubobjectShaderInfo& info) {
  const auto& subobject = details.subobjects[info.index];
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
  auto* details = GetPipelineShaderDetails(pipeline);
  if (details != nullptr) {
    for (const auto& info : details->subobject_shaders) {
      if (info.shader_hash != shader_hash) continue;
      return GetShaderData(*details, info);
    }
  }
  return std::nullopt;
}

static std::optional<std::vector<uint8_t>> GetShaderData(
    const reshade::api::pipeline& pipeline,
    const PipelineSubobjectShaderInfo& info) {
  auto* details = GetPipelineShaderDetails(pipeline);
  if (details != nullptr) {
    return GetShaderData(*details, info);
  }
  return std::nullopt;
}

static std::optional<std::vector<uint8_t>> GetShaderData(const StageState* stage_state, const int& index) {
  if (stage_state->pipeline_details == nullptr) return std::nullopt;
  return GetShaderData(
      *stage_state->pipeline_details,
      stage_state->pipeline_details->compatible_shader_infos[index]);
}

static std::optional<std::vector<uint8_t>> GetShaderData(const StageState* stage_state) {
  return GetShaderData(stage_state, PIXEL_INDEX);
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  renodx::utils::pipeline_layout::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      shared.RegisterModule([](SharedData& data) {
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
      });
      shared.RegisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      shared.RegisterEvent<reshade::addon_event::init_command_list>(OnInitCommandList);
      shared.RegisterEvent<reshade::addon_event::reset_command_list>(OnResetCommandList);
      shared.RegisterEvent<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      shared.RegisterEvent<reshade::addon_event::create_pipeline>(OnCreatePipeline);
      shared.RegisterEvent<reshade::addon_event::init_pipeline>(OnInitPipeline);
      shared.RegisterEvent<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      shared.RegisterEvent<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);

      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "utils::shader attached.");
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);

      break;
    case DLL_PROCESS_DETACH:
      shared.UnregisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      shared.UnregisterEvent<reshade::addon_event::init_command_list>(OnInitCommandList);
      shared.UnregisterEvent<reshade::addon_event::reset_command_list>(OnResetCommandList);
      shared.UnregisterEvent<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      shared.UnregisterEvent<reshade::addon_event::create_pipeline>(OnCreatePipeline);
      shared.UnregisterEvent<reshade::addon_event::init_pipeline>(OnInitPipeline);
      shared.UnregisterEvent<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      shared.UnregisterEvent<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
      shared.UnregisterModule();
      if (!attached) return;
      attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      break;
  }
}

}  // namespace renodx::utils::shader
