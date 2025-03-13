/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>

#include <include/reshade_api_device.hpp>

#include <array>
#include <atomic>
#include <cstdint>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./bitwise.hpp"
#include "./data.hpp"
#include "./format.hpp"
#include "./pipeline.hpp"
#include "./pipeline_layout.hpp"

namespace renodx::utils::shader {

static bool use_replace_on_bind = true;
static bool use_replace_async = false;
static bool use_shader_cache = false;
static bool initialized_device = false;
static std::atomic_size_t runtime_replacement_count = 0;

static bool is_primary_hook = false;

static const int VERTEX_INDEX = 0;
static const int PIXEL_INDEX = 1;
static const int COMPUTE_INDEX = 2;
static const auto COMPATIBLE_STAGES_SIZE = 3;

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
  std::vector<std::uint8_t> replacement_shader;
};

static void AddShaderReplacement(
    reshade::api::pipeline_subobject* subobject,
    std::span<const uint8_t> new_shader) {
  auto* desc = static_cast<reshade::api::shader_desc*>(subobject->data);
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

struct PipelineShaderDetails {
  reshade::api::pipeline pipeline = {0u};
  reshade::api::device* device = nullptr;
  reshade::api::pipeline_layout layout = {0};
  std::vector<reshade::api::pipeline_subobject> subobjects;
  std::vector<PipelineSubobjectShaderInfo> subobject_shaders;
  std::array<PipelineSubobjectShaderInfo, COMPATIBLE_STAGES_SIZE> compatible_shader_infos = {};
  std::unordered_set<uint32_t> shader_hashes;
  reshade::api::pipeline replacement_pipeline = {0};
  reshade::api::pipeline_stage replacement_stages = static_cast<reshade::api::pipeline_stage>(0u);
  renodx::utils::pipeline_layout::PipelineLayoutData* layout_data = nullptr;
  bool initialized_replacement = false;
  const std::unordered_map<uint32_t, std::vector<uint8_t>>* runtime_replacements;

  std::optional<std::string> tag;
  bool destroyed = false;

  PipelineShaderDetails() = default;

  PipelineShaderDetails(
      reshade::api::pipeline pipeline,
      reshade::api::device* device,
      const reshade::api::pipeline_layout& layout,
      const reshade::api::pipeline_subobject* subobjects,
      const uint32_t& subobject_count,
      const std::unordered_map<uint32_t, uint32_t>* shader_replacements_inverse,
      const std::unordered_map<uint32_t, std::vector<uint8_t>>* runtime_replacements) {
    this->pipeline = pipeline;
    this->device = device;
    this->layout = layout;
    this->layout_data = pipeline_layout::GetPipelineLayoutData(layout);
    this->runtime_replacements = runtime_replacements;
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
      if (desc.code_size == 0) continue;

      // Pipeline has a shader with code. Hash code and check

      uint32_t shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);
      const auto& stage = COMPATIBLE_STAGES[shader_type_index];

      // Shader may have been replaced. Get original hash
      if (shader_replacements_inverse == nullptr) continue;
      if (auto pair = shader_replacements_inverse->find(shader_hash);
          pair != shader_replacements_inverse->end()) {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::shader::PipelineShaderDetails(Storing original ";
        s << PRINT_CRC32(shader_hash);
        s << "=>";
        s << PRINT_CRC32(pair->second);
        s << ", pipeline: " << static_cast<uintptr_t>(this->pipeline.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        shader_hash = pair->second;
        this->initialized_replacement = true;
      } else {
        if (!use_replace_async) {
          auto pair = this->runtime_replacements->find(shader_hash);
          if (pair != this->runtime_replacements->end()) {
            const auto& new_shader = pair->second;
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
            AddShaderReplacement(&replacement_subobjects[i], new_shader);
#ifdef DEBUG_LEVEL_0
            {
              std::stringstream s;
              s << "utils::shader::BuildReplacementPipeline(Added replacement ";
              s << PRINT_CRC32(shader_hash);
              s << ")";
              reshade::log::message(reshade::log::level::debug, s.str().c_str());
            }
#endif

            this->replacement_stages |= stage;
          }
        }
      }
      this->shader_hashes.emplace(shader_hash);

      this->subobject_shaders.push_back({
          .index = i,
          .shader_hash = shader_hash,
          .stage = stage,
      });
      this->compatible_shader_infos[shader_type_index] = this->subobject_shaders.back();

#ifdef DEBUG_LEVEL_1
      {
        std::stringstream s;
        s << "utils::shader::PipelineShaderDetails(Tracking ";
        s << PRINT_CRC32(shader_hash);
        s << ", index: " << i;
        s << ", type: " << subobject.type;
        s << ", stage: " << stage;
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      }
#endif
    }

    if (replacement_subobjects != nullptr) {
      reshade::api::pipeline new_pipeline;

      auto create_layout = layout;
      if (this->layout_data != nullptr && this->layout_data->replacement_layout != 0u) {
        create_layout = layout;
      }

      const bool built_pipeline_ok = device->create_pipeline(
          create_layout,
          subobject_count,
          replacement_subobjects,
          &new_pipeline);

#ifdef DEBUG_LEVEL_0
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

static struct Store {
  std::shared_mutex pipeline_shader_details_mutex;
  std::unordered_map<uint64_t, PipelineShaderDetails> pipeline_shader_details;
} local_store;

static Store* store = &local_store;

struct __declspec(uuid("908f0889-64d8-4e22-bd26-ded3dd0cef77")) DeviceData {
  std::shared_mutex mutex;

  Store* store;
  std::unordered_map<uint32_t, std::unordered_set<uint64_t>> shader_pipeline_handles;
  std::unordered_map<uint32_t, std::vector<uint8_t>> compile_time_replacements;
  std::unordered_map<uint32_t, std::vector<uint8_t>> runtime_replacements;

  std::unordered_map<uint32_t, uint32_t> shader_replacements;          // Old => New
  std::unordered_map<uint32_t, uint32_t> shader_replacements_inverse;  // New => Old
  bool use_replace_on_bind = true;
  bool use_replace_async = false;
  bool use_shader_cache = false;
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
  DeviceData* device_data = nullptr;
};

inline PipelineShaderDetails* GetPipelineShaderDetails(const reshade::api::pipeline& pipeline) {
  std::shared_lock read_lock(store->pipeline_shader_details_mutex);
  if (auto details_pair = store->pipeline_shader_details.find(pipeline.handle);
      details_pair != store->pipeline_shader_details.end()) {
    return &details_pair->second;
  }
  return nullptr;
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
    auto new_shader_pair = details->runtime_replacements->find(info.shader_hash);
    if (new_shader_pair == details->runtime_replacements->end()) continue;
    const auto& new_shader = new_shader_pair->second;

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
    AddShaderReplacement(&subobject, new_shader);
    details->replacement_stages |= info.stage;
  }

  if (replacement_subobjects != nullptr) {
    reshade::api::pipeline new_pipeline;
    auto layout = details->layout;
    if (details->layout_data != nullptr) {
      if (details->layout_data->replacement_layout.handle != 0u) {
        layout = details->layout_data->replacement_layout;
      }
    }

    const bool built_pipeline_ok = details->device->create_pipeline(
        layout,
        subobject_count,
        replacement_subobjects,
        &new_pipeline);
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
    renodx::utils::pipeline::DestroyPipelineSubobjects(replacement_subobjects, subobject_count);
    if (built_pipeline_ok) {
      details->replacement_pipeline = new_pipeline;
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

static std::shared_mutex mutex;
static std::unordered_map<uint32_t, std::vector<uint8_t>> compile_time_replacements;
static std::unordered_map<uint32_t, std::vector<uint8_t>> initial_runtime_replacements;
static std::unordered_map<reshade::api::device_api, std::unordered_map<uint32_t, std::vector<uint8_t>>>
    device_based_compile_time_replacements;
static std::unordered_map<reshade::api::device_api, std::unordered_map<uint32_t, std::vector<uint8_t>>>
    device_based_initial_runtime_replacements;
}  // namespace internal

static void QueueCompileTimeReplacement(
    uint32_t shader_hash,
    const std::vector<uint8_t>& shader_data) {
  const std::unique_lock lock(internal::mutex);
  internal::compile_time_replacements[shader_hash] = shader_data;
}

static void UpdateReplacements(
    const std::unordered_map<uint32_t, std::vector<uint8_t>>& replacements,
    bool compile_time = true,
    bool initial_runtime = true,
    const std::unordered_set<reshade::api::device_api>& devices = {}) {
  if (!compile_time && !initial_runtime) return;
  const std::unique_lock lock(internal::mutex);

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
  const std::unique_lock lock(internal::mutex);
  internal::compile_time_replacements.erase(shader_hash);
}

static void QueueRuntimeReplacement(
    uint32_t shader_hash,
    const std::vector<uint8_t>& shader_data) {
  const std::unique_lock lock(internal::mutex);
  internal::initial_runtime_replacements[shader_hash] = std::vector<uint8_t>(shader_data);
}

static void UnqueueRuntimeReplacement(
    uint32_t shader_hash,
    const std::vector<uint8_t>& shader_data) {
  const std::unique_lock lock(internal::mutex);
  internal::initial_runtime_replacements.erase(shader_hash);
}

// Note: Does not reset pipeline state
static void AddRuntimeReplacement(
    reshade::api::device* device,
    uint32_t shader_hash,
    const std::vector<uint8_t>& shader_data) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  data->runtime_replacements[shader_hash] = std::vector<uint8_t>(shader_data);
  runtime_replacement_count = data->runtime_replacements.size();
}

static void RemoveRuntimeReplacements(reshade::api::device* device, const std::unordered_set<uint32_t>& filter = {}) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  std::unique_lock device_lock(data->mutex);
  for (auto& [shader_hash, replacement] : data->runtime_replacements) {
    if (!filter.empty() && !filter.contains(shader_hash)) continue;
    if (auto pair = data->shader_pipeline_handles.find(shader_hash);
        pair != data->shader_pipeline_handles.end()) {
      auto& pipeline_handles = pair->second;
      if (pipeline_handles.empty()) continue;
      std::shared_lock read_lock(store->pipeline_shader_details_mutex);
      for (auto pipeline_handle : pipeline_handles) {
        if (auto details_pair = store->pipeline_shader_details.find(pipeline_handle);
            details_pair != store->pipeline_shader_details.end()) {
          auto& details = details_pair->second;
          if (details.replacement_pipeline.handle != 0u) {
            device->destroy_pipeline(details.replacement_pipeline);
            details.replacement_pipeline = {0u};
          }
          details.initialized_replacement = false;
        }
      }
    }
  }
  if (filter.empty()) {
    data->runtime_replacements.clear();
  } else {
    for (auto shader_hash : filter) {
      data->runtime_replacements.erase(shader_hash);
    }
  }
  runtime_replacement_count = data->runtime_replacements.size();
}

inline CommandListData* GetCurrentState(reshade::api::command_list* cmd_list) {
  return renodx::utils::data::Get<CommandListData>(cmd_list);
}

static void OnInitDevice(reshade::api::device* device) {
  DeviceData* data;
  bool created = renodx::utils::data::CreateOrGet(device, data);

  if (created) {
    std::stringstream s;
    s << "utils::shader::OnInitDevice(Hooking device: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    is_primary_hook = true;
    data->store = store;
  } else {
    std::stringstream s;
    s << "utils::shader::OnInitDevice(Attaching to hook: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
    store = data->store;
  }

  if (!use_replace_on_bind) {
    // write
    data->use_replace_on_bind = false;
  } else {
    // read
    use_replace_on_bind = data->use_replace_on_bind;
  }

  if (use_replace_async) {
    // write
    data->use_replace_async = true;
  } else {
    // read
    use_replace_async = data->use_replace_async;
  }

  if (use_shader_cache) {
    // write
    data->use_shader_cache = true;
  } else {
    // read
    use_shader_cache = data->use_shader_cache;
  }

  auto insert_shaders = [](
                            const std::unordered_map<uint32_t, std::vector<uint8_t>>& source,
                            std::unordered_map<uint32_t, std::vector<uint8_t>>& dest,
                            const std::string& type = "") {
    for (const auto& [shader_hash, replacement] : source) {
      auto [iterator, is_new] = dest.emplace(shader_hash, replacement);
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

  std::shared_lock local_lock(internal::mutex);
  std::unique_lock device_lock(data->mutex);
  insert_shaders(internal::compile_time_replacements, data->compile_time_replacements, "compile-time");
  insert_shaders(internal::initial_runtime_replacements, data->runtime_replacements, "runtime");

  insert_shaders(internal::device_based_compile_time_replacements[device->get_api()], data->compile_time_replacements, "API-based compile-time");
  insert_shaders(internal::device_based_initial_runtime_replacements[device->get_api()], data->runtime_replacements, "API-based runtime");

  runtime_replacement_count = data->runtime_replacements.size();
};

static void OnDestroyDevice(reshade::api::device* device) {
  if (!is_primary_hook) return;
  std::stringstream s;
  s << "utils::shader::OnDestroyDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

inline DeviceData* GetDeviceData(reshade::api::command_list* cmd_list, CommandListData* cmd_list_data) {
  if (cmd_list_data->device_data == nullptr) {
    cmd_list_data->device_data = renodx::utils::data::Get<DeviceData>(cmd_list->get_device());
  }
  return cmd_list_data->device_data;
}

static void OnResetCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  data->last_pipeline = {0u};
  data->stage_states[0].pipeline = {0u};
  data->stage_states[1].pipeline = {0u};
  data->stage_states[2].pipeline = {0u};

  data->stage_states[0].pipeline_details = nullptr;
  data->stage_states[1].pipeline_details = nullptr;
  data->stage_states[2].pipeline_details = nullptr;
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

static bool OnCreatePipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  if (!is_primary_hook) return false;
  if (initialized_device) {
    if (use_replace_async) return false;
  }
  auto* data = renodx::utils::data::Get<DeviceData>(device);

  if (!initialized_device) {
    use_replace_async = data->use_replace_async;
    use_shader_cache = data->use_shader_cache;
    initialized_device = true;
  }
  std::vector<std::pair<uint32_t, uint32_t>> hash_changes;

  {
    std::shared_lock read_lock(data->mutex);
    for (uint32_t i = 0; i < subobject_count; ++i) {
      if (!COMPATIBLE_SUBOBJECT_TYPE_TO_STAGE.contains(subobjects[i].type)) continue;
      auto* desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
      if (desc->code_size == 0) continue;

      const uint32_t shader_hash = compute_crc32(
          static_cast<const uint8_t*>(desc->code),
          desc->code_size);

      if (auto pair = data->compile_time_replacements.find(shader_hash);
          pair != data->compile_time_replacements.end()) {
        const auto& replacement = pair->second;
        auto new_size = replacement.size();

        desc->code_size = new_size;

        if (new_size == 0) {
          desc->code = nullptr;
          hash_changes.emplace_back(shader_hash, 0);
        } else {
          desc->code = malloc(new_size);
          memcpy(const_cast<void*>(desc->code), replacement.data(), new_size);
          const uint32_t new_hash = compute_crc32(
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
      }
    }
  }

  if (hash_changes.empty()) return false;

  std::unique_lock lock(data->mutex);
  for (auto& [shader_hash, new_hash] : hash_changes) {
    data->shader_replacements[shader_hash] = new_hash;
    if (new_hash != 0u) {
      data->shader_replacements_inverse[new_hash] = shader_hash;
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
  if (!is_primary_hook) return;
  if (pipeline.handle == 0u) return;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  bool locking = !data->compile_time_replacements.empty();

  if (locking) {
    data->mutex.lock_shared();
  }
  auto details = PipelineShaderDetails(
      pipeline,
      device,
      layout,
      subobjects,
      subobject_count,
      &data->shader_replacements_inverse,
      &data->runtime_replacements);

  if (locking) {
    data->mutex.unlock_shared();
  }
  bool has_useful_details = !details.subobject_shaders.empty();
  if (!has_useful_details) return;

  if (data->use_replace_async || data->use_shader_cache) {
    reshade::api::pipeline_subobject* subobjects_clone = renodx::utils::pipeline::ClonePipelineSubObjects(subobjects, subobject_count);

    // Store clone of subobjects
    details.subobjects.assign(
        subobjects_clone,
        subobjects_clone + subobject_count);

    free(subobjects_clone);
  }

  {
    const std::unique_lock write_lock(store->pipeline_shader_details_mutex);
    store->pipeline_shader_details[pipeline.handle] = details;

    if (data->use_replace_async) {
      for (const auto shader_hash : details.shader_hashes) {
        if (auto pair = data->shader_pipeline_handles.find(shader_hash);
            pair != data->shader_pipeline_handles.end()) {
          auto& pipeline_handles = pair->second;
          pipeline_handles.emplace(pipeline.handle);
        } else {
          data->shader_pipeline_handles[shader_hash] = {pipeline.handle};
        }
      }
    }
  }
}

static void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  if (!is_primary_hook) return;

  // Prefer read-only and orphaning data

  if (use_replace_async || use_shader_cache) {
    std::shared_lock read_lock(store->pipeline_shader_details_mutex);
    auto details_pair = store->pipeline_shader_details.find(pipeline.handle);
    if (details_pair == store->pipeline_shader_details.end()) return;
    auto* details = &details_pair->second;
    details->destroyed = true;
    if (details->replacement_pipeline.handle != 0u) {
      device->destroy_pipeline(details->replacement_pipeline);
      details->replacement_pipeline = {0u};
    }
  } else {
    std::unique_lock write_lock(store->pipeline_shader_details_mutex);
    auto details_pair = store->pipeline_shader_details.find(pipeline.handle);
    if (details_pair == store->pipeline_shader_details.end()) return;
    auto* details = &details_pair->second;
    if (details->replacement_pipeline.handle != 0u) {
      device->destroy_pipeline(details->replacement_pipeline);
    }
    renodx::utils::pipeline::DestroyPipelineSubobjects(details->subobjects);
    store->pipeline_shader_details.erase(details_pair);
  }
}

// AfterSetPipelineState
inline void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    reshade::api::pipeline pipeline) {
  if (!is_primary_hook) return;
  CommandListData* cmd_list_data = nullptr;
  for (int i = 0; i < COMPATIBLE_STAGES_SIZE; ++i) {
    auto compatible_stage = COMPATIBLE_STAGES[i];
    if (stage == reshade::api::pipeline_stage::all
        || renodx::utils::bitwise::HasFlag(stage, compatible_stage)) {
      if (cmd_list_data == nullptr) {
        cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
      }
      cmd_list_data->last_pipeline = pipeline;

      if (cmd_list_data->stage_states[i].pipeline != pipeline) {
        cmd_list_data->stage_states[i].pipeline = pipeline;
        cmd_list_data->stage_states[i].pipeline_details = nullptr;
      }
      cmd_list_data->stage_states[i].applied_stage = stage;
      if (pipeline.handle != 0 && use_replace_on_bind) {
        ApplyReplacement(cmd_list, &cmd_list_data->stage_states[i]);
      }
    }
  }
}

inline DeviceData* GetShaderDeviceData(reshade::api::device* device) {
  return renodx::utils::data::Get<DeviceData>(device);
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
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "utils::shader attached.");
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::create_pipeline>(OnCreatePipeline);
      reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);

      break;
    case DLL_PROCESS_DETACH:

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::create_pipeline>(OnCreatePipeline);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
      break;
  }
}

}  // namespace renodx::utils::shader
