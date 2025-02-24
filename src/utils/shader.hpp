/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>

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
#include "./format.hpp"
#include "./pipeline.hpp"
#include "./pipeline_layout.hpp"

namespace renodx::utils::shader {

static std::atomic_bool use_replace_on_bind = true;
static std::atomic_bool use_replace_async = false;
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
    reshade::api::pipeline_subobject& subobject,
    std::span<uint8_t> new_shader) {
  auto* desc = static_cast<reshade::api::shader_desc*>(subobject.data);
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
  reshade::api::device* device = nullptr;
  reshade::api::pipeline_layout layout = {0};
  std::vector<reshade::api::pipeline_subobject> subobjects;
  std::vector<PipelineSubobjectShaderInfo> subobject_shaders;
  std::array<PipelineSubobjectShaderInfo, COMPATIBLE_STAGES_SIZE> compatible_shader_infos = {};
  std::unordered_set<uint32_t> shader_hashes;
  reshade::api::pipeline replacement_pipeline = {0};
  reshade::api::pipeline_stage replacement_stages = static_cast<reshade::api::pipeline_stage>(0u);
  bool initialized_replacement = false;

  std::optional<std::string> tag;
  bool destroyed = false;

  PipelineShaderDetails() = default;

  PipelineShaderDetails(
      reshade::api::device* device,
      reshade::api::pipeline_layout layout,
      const reshade::api::pipeline_subobject* subobjects,
      uint32_t subobject_count,
      std::unordered_map<uint32_t, uint32_t>& shader_replacements_inverse,
      std::unordered_map<uint32_t, std::vector<uint8_t>>* runtime_replacements) {
    this->device = device;
    this->layout = layout;
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
      if (auto pair = shader_replacements_inverse.find(shader_hash);
          pair != shader_replacements_inverse.end()) {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::shader::PipelineShaderDetails(Storing original ";
        s << PRINT_CRC32(shader_hash);
        s << "=>";
        s << PRINT_CRC32(pair->second);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        shader_hash = pair->second;
        this->initialized_replacement = true;
      } else {
        if (runtime_replacements != nullptr) {
          this->initialized_replacement = true;

          auto pair = runtime_replacements->find(shader_hash);
          if (pair != runtime_replacements->end()) {
            auto& new_shader = pair->second;
            if (replacement_subobjects == nullptr) {
              replacement_subobjects = renodx::utils::pipeline::ClonePipelineSubObjects(subobjects, subobject_count);
            }
#ifdef DEBUG_LEVEL_0
            std::stringstream s;
            s << "utils::shader::BuildReplacementPipeline(Replacing ";
            s << PRINT_CRC32(shader_hash);
            s << ")";
            reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
            AddShaderReplacement(replacement_subobjects[i], new_shader);

            this->replacement_stages |= stage;
          }
        }
      }

      this->subobject_shaders.push_back({
          .index = i,
          .shader_hash = shader_hash,
          .stage = stage,
      });
      this->compatible_shader_infos[shader_type_index] = this->subobject_shaders.back();

#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "utils::shader::PipelineShaderDetails(Storing ";
      s << PRINT_CRC32(shader_hash);
      s << ", index: " << i;
      s << ", type: " << subobject.type;
      s << ", stage: " << stage;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    }
    if (replacement_subobjects != nullptr) {
      reshade::api::pipeline new_pipeline;
      auto create_layout = renodx::utils::pipeline_layout::GetPipelineLayoutClone(device, layout);
      if (create_layout.handle == 0u) {
        create_layout = layout;
      }

      const bool built_pipeline_ok = device->create_pipeline(
          create_layout,
          subobject_count,
          replacement_subobjects,
          &new_pipeline);
      renodx::utils::pipeline::DestroyPipelineSubobjects(replacement_subobjects, subobject_count);

      if (built_pipeline_ok) {
        this->replacement_pipeline = new_pipeline;
      };

#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::shader::BuildReplacementPipeline(Failed to replace pipeline";
      s << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
#endif
      return;
    }

    this->replacement_pipeline = {0};
    this->replacement_stages = static_cast<reshade::api::pipeline_stage>(0);

    // this->subobjects = std::vector<reshade::api::pipeline_subobject>(subobjects, subobjects + subobject_count);
  }
};

static std::shared_mutex pipeline_shader_details_mutex;
static std::unordered_map<uint64_t, PipelineShaderDetails> pipeline_shader_details;

struct __declspec(uuid("908f0889-64d8-4e22-bd26-ded3dd0cef77")) DeviceData {
  std::shared_mutex mutex;

  std::unordered_map<uint32_t, std::unordered_set<uint64_t>> shader_pipeline_handles;
  std::unordered_map<uint32_t, std::vector<uint8_t>> compile_time_replacements;
  std::unordered_map<uint32_t, std::vector<uint8_t>> runtime_replacements;

  std::unordered_map<uint32_t, uint32_t> shader_replacements;          // Old => New
  std::unordered_map<uint32_t, uint32_t> shader_replacements_inverse;  // New => Old
  bool use_replace_on_bind = true;
  bool use_replace_async = false;
};

struct StageState {
  reshade::api::pipeline_stage stage;
  reshade::api::pipeline replacement_pipeline = {0};
  uint32_t shader_hash = 0u;
  reshade::api::pipeline pipeline = {0};
};

struct __declspec(uuid("8707f724-c7e5-420e-89d6-cc032c732d2d")) CommandListData {
  reshade::api::pipeline_layout pipeline_layout = {0};
  std::array<StageState, 3> stage_states = {};
  DeviceData* device_data = nullptr;
};

inline StageState& GetCurrentVertexState(CommandListData& cmd_list_data) {
  return cmd_list_data.stage_states[VERTEX_INDEX];
}
inline StageState& GetCurrentPixelState(CommandListData& cmd_list_data) {
  return cmd_list_data.stage_states[PIXEL_INDEX];
}
inline StageState& GetCurrentComputeState(CommandListData& cmd_list_data) {
  return cmd_list_data.stage_states[COMPUTE_INDEX];
}

inline uint32_t GetCurrentVertexShaderHash(CommandListData& cmd_list_data) {
  return GetCurrentVertexState(cmd_list_data).shader_hash;
}
inline uint32_t GetCurrentPixelShaderHash(CommandListData& cmd_list_data) {
  return GetCurrentPixelState(cmd_list_data).shader_hash;
}
inline uint32_t GetCurrentComputeShaderHash(CommandListData& cmd_list_data) {
  return GetCurrentComputeState(cmd_list_data).shader_hash;
}

inline uint32_t GetCurrentShaderHash(CommandListData& cmd_list_data, reshade::api::pipeline_stage& stage) {
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

static void ApplyReplacement(reshade::api::command_list* cmd_list, StageState& state) {
  if (state.replacement_pipeline.handle != 0u) {
#ifdef DEBUG_LEVEL_2
    std::stringstream s;
    s << "utils::shader::ApplyDispatchReplacements(Applying replacement ";
    s << state.stage;
    s << ", pipeline: " << reinterpret_cast<void*>(state.pending_replacement.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->bind_pipeline(state.stage, state.replacement_pipeline);
    // state.pending_replacement = {0u};
  }
}

inline void ApplyDispatchReplacements(reshade::api::command_list* cmd_list, CommandListData& cmd_list_data) {
  ApplyReplacement(cmd_list, GetCurrentComputeState(cmd_list_data));
}

inline void ApplyDrawReplacements(reshade::api::command_list* cmd_list, CommandListData& cmd_list_data) {
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

static bool BuildReplacementPipeline(
    reshade::api::device* device,
    DeviceData& data,
    PipelineShaderDetails& details) {
  details.initialized_replacement = true;

  auto subobject_count = details.subobjects.size();

  reshade::api::pipeline_subobject* replacement_subobjects = nullptr;
  details.replacement_stages = static_cast<reshade::api::pipeline_stage>(0);
  for (const auto& info : details.subobject_shaders) {
    auto new_shader_pair = data.runtime_replacements.find(info.shader_hash);
    if (new_shader_pair == data.runtime_replacements.end()) continue;
    auto& new_shader = new_shader_pair->second;

    if (replacement_subobjects == nullptr) {
      replacement_subobjects = renodx::utils::pipeline::ClonePipelineSubObjects(details.subobjects.data(), subobject_count);
    }
    auto& subobject = replacement_subobjects[info.index];
#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "utils::shader::BuildReplacementPipeline(Replacing ";
    s << PRINT_CRC32(info.shader_hash);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    AddShaderReplacement(subobject, new_shader);
    details.replacement_stages |= info.stage;
  }

  if (replacement_subobjects != nullptr) {
    reshade::api::pipeline new_pipeline;
    auto layout = renodx::utils::pipeline_layout::GetPipelineLayoutClone(device, details.layout);
    if (layout.handle == 0u) {
      layout = details.layout;
    }

    const bool built_pipeline_ok = device->create_pipeline(
        layout,
        subobject_count,
        replacement_subobjects,
        &new_pipeline);
    renodx::utils::pipeline::DestroyPipelineSubobjects(replacement_subobjects, subobject_count);
    if (built_pipeline_ok) {
      details.replacement_pipeline = new_pipeline;
      return true;
    };

#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "utils::shader::BuildReplacementPipeline(Failed to replace pipeline";
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
#endif
  }

  details.replacement_pipeline = {0};
  details.replacement_stages = static_cast<reshade::api::pipeline_stage>(0);
  return false;
}

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
  auto& data = device->get_private_data<DeviceData>();
  data.runtime_replacements[shader_hash] = std::vector<uint8_t>(shader_data);
  runtime_replacement_count = data.runtime_replacements.size();
}

static PipelineShaderDetails* GetPipelineShaderDetails(reshade::api::pipeline pipeline) {
  std::shared_lock read_lock(pipeline_shader_details_mutex);
  if (auto details_pair = pipeline_shader_details.find(pipeline.handle);
      details_pair != pipeline_shader_details.end()) {
    return &details_pair->second;
  }
  return nullptr;
}

static void RemoveRuntimeReplacements(reshade::api::device* device, const std::unordered_set<uint32_t>& filter = {}) {
  auto& data = device->get_private_data<DeviceData>();
  std::unique_lock device_lock(data.mutex);
  for (auto& [shader_hash, replacement] : data.runtime_replacements) {
    if (!filter.empty() && !filter.contains(shader_hash)) continue;
    if (auto pair = data.shader_pipeline_handles.find(shader_hash);
        pair != data.shader_pipeline_handles.end()) {
      auto& pipeline_handles = pair->second;
      if (pipeline_handles.empty()) continue;
      std::shared_lock read_lock(pipeline_shader_details_mutex);
      for (auto pipeline_handle : pipeline_handles) {
        if (auto details_pair = pipeline_shader_details.find(pipeline_handle);
            details_pair != pipeline_shader_details.end()) {
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
    data.runtime_replacements.clear();
  } else {
    for (auto shader_hash : filter) {
      data.runtime_replacements.erase(shader_hash);
    }
  }
  runtime_replacement_count = data.runtime_replacements.size();
}

static CommandListData& GetCurrentState(reshade::api::command_list* cmd_list) {
  return cmd_list->get_private_data<CommandListData>();
}

static void OnInitDevice(reshade::api::device* device) {
  DeviceData* data = &device->get_private_data<DeviceData>();
  if (data == nullptr) {
    data = &device->create_private_data<DeviceData>();
    std::stringstream s;
    s << "utils::shader::OnInitDevice(Hooking device: ";
    s << reinterpret_cast<void*>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    is_primary_hook = true;

  } else {
    std::stringstream s;
    s << "utils::shader::OnInitDevice(Attaching to hook: ";
    s << reinterpret_cast<void*>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
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

  std::shared_lock lock(internal::mutex);
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
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  auto& data = cmd_list->create_private_data<CommandListData>();
}

inline DeviceData& GetDeviceData(reshade::api::command_list* cmd_list, CommandListData& cmd_list_data) {
  if (cmd_list_data.device_data == nullptr) {
    cmd_list_data.device_data = &cmd_list->get_device()->get_private_data<DeviceData>();
  }
  return *cmd_list_data.device_data;
}

static void OnResetCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  auto& data = cmd_list->get_private_data<CommandListData>();
  data.stage_states = {};
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  cmd_list->destroy_private_data<CommandListData>();
}

static bool OnCreatePipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  if (!is_primary_hook) return false;
  if (use_replace_async) return false;
  auto& data = device->get_private_data<DeviceData>();
  std::shared_lock read_lock(data.mutex);

  std::vector<std::pair<uint32_t, uint32_t>> hash_changes;

  for (uint32_t i = 0; i < subobject_count; ++i) {
    if (!COMPATIBLE_SUBOBJECT_TYPE_TO_STAGE.contains(subobjects[i].type)) continue;
    auto* desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
    if (desc->code_size == 0) continue;

    const uint32_t shader_hash = compute_crc32(
        static_cast<const uint8_t*>(desc->code),
        desc->code_size);

    if (auto pair = data.compile_time_replacements.find(shader_hash);
        pair != data.compile_time_replacements.end()) {
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

  if (hash_changes.empty()) return false;

  read_lock.unlock();
  std::unique_lock lock(data.mutex);
  for (auto& [shader_hash, new_hash] : hash_changes) {
    data.shader_replacements[shader_hash] = new_hash;
    if (new_hash != 0u) {
      data.shader_replacements_inverse[new_hash] = shader_hash;
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
  if (pipeline.handle == 0u) return;

  auto& data = device->get_private_data<DeviceData>();
  bool locking = !data.compile_time_replacements.empty();
  std::shared_lock<std::shared_mutex>* read_lock;
  if (locking) {
    read_lock = new std::shared_lock<std::shared_mutex>(data.mutex);
  }
  auto details = PipelineShaderDetails(
      device,
      layout,
      subobjects,
      subobject_count,
      data.shader_replacements_inverse,
      data.use_replace_async ? nullptr : &data.runtime_replacements);

  if (locking) {
    read_lock->unlock();
    free(read_lock);
  }
  bool has_useful_details = !details.subobject_shaders.empty();
  if (!has_useful_details) return;

  reshade::api::pipeline_subobject* subobjects_clone = renodx::utils::pipeline::ClonePipelineSubObjects(subobjects, subobject_count);

  // Store clone of subobjects
  details.subobjects = std::vector<reshade::api::pipeline_subobject>(
      subobjects_clone,
      subobjects_clone + subobject_count);

  const std::unique_lock write_lock(pipeline_shader_details_mutex);
  pipeline_shader_details[pipeline.handle] = details;
}

static void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  if (!is_primary_hook) return;

  // Prefer read-only and orphaning data

  auto* details_ptr = GetPipelineShaderDetails(pipeline);

  if (details_ptr == nullptr) {
    // assert(details_pair != pipeline_shader_details.end());
    return;
  }

  auto& details = *details_ptr;

  // pipeline_shader_details.erase(details_pair);
  details.destroyed = true;

  if (details.replacement_pipeline.handle != 0u) {
    device->destroy_pipeline(details.replacement_pipeline);
    details.replacement_pipeline = {0u};
  }
  if (!use_replace_async) {
    renodx::utils::pipeline::DestroyPipelineSubobjects(details.subobjects);
  }
}

// AfterSetPipelineState
static void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    reshade::api::pipeline pipeline) {
  if (!is_primary_hook) return;
  CommandListData* cmd_list_data_ptr = nullptr;

  bool found_compatible = false;

  for (int i = 0; i < COMPATIBLE_STAGES_SIZE; ++i) {
    auto compatible_stage = COMPATIBLE_STAGES[i];
    if (stage == reshade::api::pipeline_stage::all
        || renodx::utils::bitwise::HasFlag(stage, compatible_stage)) {
      if (cmd_list_data_ptr == nullptr) {
        cmd_list_data_ptr = &cmd_list->get_private_data<CommandListData>();
      }
      found_compatible = true;
      cmd_list_data_ptr->stage_states[i].shader_hash = 0u;
      cmd_list_data_ptr->stage_states[i].pipeline = pipeline;
      cmd_list_data_ptr->stage_states[i].stage = stage;
    }
  }

  if (pipeline.handle == 0) return;
  if (!found_compatible) return;

  if (cmd_list_data_ptr == nullptr) {
    cmd_list_data_ptr = &cmd_list->get_private_data<CommandListData>();
  }

  auto& cmd_list_data = *cmd_list_data_ptr;

  auto* details_ptr = GetPipelineShaderDetails(pipeline);

  if (details_ptr == nullptr) {
#ifdef DEBUG_LEVEL_2
    std::stringstream s;
    s << "utils::shader::OnBindPipeline(No details: ";
    s << (void*)pipeline.handle;
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    assert(details_ptr != nullptr);
    return;
  }

  auto& details = *details_ptr;

  cmd_list_data.pipeline_layout = details.layout;

  if (!details.initialized_replacement && !details.subobject_shaders.empty()) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::shader::OnBindPipeline(NeedsReplacementPipeline: ";
    s << (void*)pipeline.handle;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    auto* device = cmd_list->get_device();
    auto& device_data = GetDeviceData(cmd_list, cmd_list_data);
    if (device_data.use_replace_async) {
      const std::shared_lock lock(device_data.mutex);
      BuildReplacementPipeline(device, device_data, details);
    } else {
      BuildReplacementPipeline(device, device_data, details);
    }
  }

  for (int i = 0; i < COMPATIBLE_STAGES_SIZE; ++i) {
    auto compatible_stage = COMPATIBLE_STAGES[i];
    if (!renodx::utils::bitwise::HasFlag(stage, compatible_stage)) continue;
    StageState& stage_state = cmd_list_data.stage_states[i];
    stage_state.stage = stage;
    stage_state.shader_hash = details.compatible_shader_infos[i].shader_hash;
    stage_state.pipeline = pipeline;
    // stage_state.layout = details.layout;
    auto& device_data = GetDeviceData(cmd_list, cmd_list_data);

    if (renodx::utils::bitwise::HasFlag(details.replacement_stages, compatible_stage)) {
      if (device_data.use_replace_on_bind) {
#ifdef DEBUG_LEVEL_2
        std::stringstream s;
        s << "utils::shader::OnBindPipeline(Replacing on bind";
        s << ", stage: " << stage;
        s << ", compatible: " << compatible_stage;
        s << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle);
        s << " => " << reinterpret_cast<void*>(pipeline_data->replacement_pipeline.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        cmd_list->bind_pipeline(stage, details.replacement_pipeline);
      } else {
#ifdef DEBUG_LEVEL_2
        std::stringstream s;
        s << "utils::shader::OnBindPipeline(Queuing replacement";
        s << ", stage: " << stage;
        s << ", compatible: " << compatible_stage;
        s << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle);
        s << " => " << reinterpret_cast<void*>(pipeline_data->replacement_pipeline.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        stage_state.replacement_pipeline = details.replacement_pipeline;
      }
    } else {
      if (!device_data.use_replace_on_bind) {
#ifdef DEBUG_LEVEL_2
        std::stringstream s;
        s << "utils::shader::OnBindPipeline(Erasing pending replacement: ";
        s << (void*)pipeline.handle;
        s << ", stage: " << stage;
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
        stage_state.replacement_pipeline = {0u};
      }
    }
  }
#ifdef DEBUG_LEVEL_2
  std::stringstream s;
  s << "utils::shader::OnBindPipeline(Done";
  s << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle);
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
}

inline DeviceData& GetShaderDeviceData(reshade::api::device* device) {
  return device->get_private_data<DeviceData>();
}

inline std::optional<std::vector<uint8_t>> GetShaderData(const PipelineShaderDetails& details, const PipelineSubobjectShaderInfo& info) {
  const auto& subobject = details.subobjects[info.index];
  const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);
  if (desc.code_size == 0) return {};
  return std::vector<uint8_t>({
      static_cast<const uint8_t*>(desc.code),
      static_cast<const uint8_t*>(desc.code) + desc.code_size,
  });
}

inline std::optional<std::vector<uint8_t>> GetShaderData(
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

inline std::optional<std::vector<uint8_t>> GetShaderData(
    const reshade::api::pipeline& pipeline,
    const PipelineSubobjectShaderInfo& info) {
  auto* details = GetPipelineShaderDetails(pipeline);
  if (details != nullptr) {
    return GetShaderData(*details, info);
  }
  return std::nullopt;
}

inline std::optional<std::vector<uint8_t>> GetShaderData(StageState stage_state) {
  return GetShaderData(stage_state.pipeline, stage_state.shader_hash);
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
