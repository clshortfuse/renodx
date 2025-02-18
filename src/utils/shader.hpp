/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <atomic>
#include <cstdint>
#include <cstdio>

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

static const auto COMPATIBLE_STAGES = {
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

struct PipelineShaderDetails {
  reshade::api::pipeline_layout layout = {0};
  std::vector<reshade::api::pipeline_subobject> subobjects;
  std::unordered_set<uint32_t> shader_hashes;
  std::unordered_set<uint32_t> replaced_shader_hashes;
  std::unordered_map<size_t, uint32_t> shader_hashes_by_index;
  std::unordered_map<reshade::api::pipeline_subobject_type, uint32_t> shader_hashes_by_type;
  std::unordered_map<reshade::api::pipeline_stage, uint32_t> shader_hashes_by_stage;
  reshade::api::pipeline replacement_pipeline = {0};
  reshade::api::pipeline_stage replacement_stages = static_cast<reshade::api::pipeline_stage>(0u);
  bool initialized_replacement = false;

  std::optional<std::string> tag;
  bool destroyed = false;

  PipelineShaderDetails() = default;

  PipelineShaderDetails(
      reshade::api::pipeline_layout layout,
      const reshade::api::pipeline_subobject* subobjects,
      uint32_t subobject_count,
      std::unordered_map<uint32_t, uint32_t> shader_replacements_inverse) {
    this->layout = layout;
    for (uint32_t i = 0; i < subobject_count; ++i) {
      const auto& subobject = subobjects[i];

      auto pair = COMPATIBLE_SUBOBJECT_TYPE_TO_STAGE.find(subobject.type);
      if (pair == COMPATIBLE_SUBOBJECT_TYPE_TO_STAGE.end()) continue;
      const auto& stage = pair->second;

      const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);
      if (desc.code_size == 0) continue;

      // Pipeline has a shader with code. Hash code and check

      uint32_t shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);

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
        replaced_shader_hashes.emplace(shader_hash);
      }

      this->shader_hashes.emplace(shader_hash);
      this->shader_hashes_by_index.emplace(i, shader_hash);
      this->shader_hashes_by_type.emplace(subobject.type, shader_hash);
      this->shader_hashes_by_stage.emplace(stage, shader_hash);

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
    // this->subobjects = std::vector<reshade::api::pipeline_subobject>(subobjects, subobjects + subobject_count);
  }
};

struct __declspec(uuid("908f0889-64d8-4e22-bd26-ded3dd0cef77")) DeviceData {
  std::shared_mutex mutex;

  std::unordered_map<uint32_t, std::unordered_set<uint64_t>> shader_pipeline_handles;
  std::unordered_map<uint64_t, PipelineShaderDetails> pipeline_shader_details;
  std::unordered_map<uint32_t, std::vector<uint8_t>> compile_time_replacements;
  std::unordered_map<uint32_t, std::vector<uint8_t>> runtime_replacements;

  std::unordered_map<uint32_t, uint32_t> shader_replacements;          // Old => New
  std::unordered_map<uint32_t, uint32_t> shader_replacements_inverse;  // New => Old
  bool use_replace_on_bind = true;
  bool use_replace_async = false;
};

struct StageState {
  reshade::api::pipeline pending_replacement = {0};
  uint32_t shader_hash = 0u;
  reshade::api::pipeline pipeline = {0};
};

struct __declspec(uuid("8707f724-c7e5-420e-89d6-cc032c732d2d")) CommandListData {
  reshade::api::pipeline_layout pipeline_layout = {0};
  std::unordered_map<reshade::api::pipeline_stage, StageState> stage_state;

  [[nodiscard]] uint32_t GetCurrentShaderHash(reshade::api::pipeline_stage stage) const {
    auto pair = stage_state.find(stage);
    if (pair == stage_state.end()) return 0u;
    return pair->second.shader_hash;
  }

  [[nodiscard]] uint32_t GetCurrentVertexShaderHash() const { return GetCurrentShaderHash(reshade::api::pipeline_stage::vertex_shader); }
  [[nodiscard]] uint32_t GetCurrentPixelShaderHash() const { return GetCurrentShaderHash(reshade::api::pipeline_stage::pixel_shader); }
  [[nodiscard]] uint32_t GetCurrentComputeShaderHash() const { return GetCurrentShaderHash(reshade::api::pipeline_stage::compute_shader); }

  void ApplyReplacements(reshade::api::command_list* cmd_list, reshade::api::pipeline_stage replacement_stages) {
    std::vector<reshade::api::pipeline_stage> applied_stages;
    for (auto& [stage, state] : stage_state) {
#ifdef DEBUG_LEVEL_2
      std::stringstream s;
      s << "utils::shader::ApplyReplacements(Applying replacement ";
      s << stage;
      s << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      if (renodx::utils::bitwise::HasFlag(stage, replacement_stages)) {
        if (state.pending_replacement.handle != 0u) {
          cmd_list->bind_pipeline(stage, state.pending_replacement);
          state.pending_replacement = {0u};
        }
      }
    }
  }

  void ApplyDispatchReplacements(reshade::api::command_list* cmd_list) {
    ApplyReplacements(cmd_list, reshade::api::pipeline_stage::compute_shader);
  }

  void ApplyDrawReplacements(reshade::api::command_list* cmd_list) {
    ApplyReplacements(
        cmd_list,
        reshade::api::pipeline_stage::vertex_shader | reshade::api::pipeline_stage::pixel_shader);
  }
};

namespace internal {

static std::shared_mutex mutex;
static std::unordered_map<uint32_t, std::vector<uint8_t>> compile_time_replacements;
static std::unordered_map<uint32_t, std::vector<uint8_t>> initial_runtime_replacements;
static std::unordered_map<reshade::api::device_api, std::unordered_map<uint32_t, std::vector<uint8_t>>>
    device_based_compile_time_replacements;
static std::unordered_map<reshade::api::device_api, std::unordered_map<uint32_t, std::vector<uint8_t>>>
    device_based_initial_runtime_replacements;
}  // namespace internal

static bool BuildReplacementPipeline(reshade::api::device* device, DeviceData& data, PipelineShaderDetails& details) {
  details.initialized_replacement = true;

  auto subobject_count = details.subobjects.size();

  reshade::api::pipeline_subobject* replacement_subobjects = nullptr;
  details.replacement_stages = static_cast<reshade::api::pipeline_stage>(0);

  for (const auto& [index, shader_hash] : details.shader_hashes_by_index) {
    // Avoid double-replacement
    if (details.replaced_shader_hashes.contains(shader_hash)) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "utils::shader::BuildReplacementPipeline(Bypassing ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      continue;
    }
#ifdef DEBUG_LEVEL_2
    std::stringstream s;
    s << "utils::shader::BuildReplacementPipeline(Checking ";
    s << PRINT_CRC32(shader_hash);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    auto new_shader_pair = data.runtime_replacements.find(shader_hash);
    if (new_shader_pair == data.runtime_replacements.end()) continue;
    auto& new_shader = new_shader_pair->second;

    if (replacement_subobjects == nullptr) {
      replacement_subobjects = renodx::utils::pipeline::ClonePipelineSubObjects(details.subobjects.data(), subobject_count);
    }
    auto& subobject = replacement_subobjects[index];
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
#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "utils::shader::BuildReplacementPipeline(Replacing ";
    s << PRINT_CRC32(shader_hash);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

    if (auto pair = COMPATIBLE_SUBOBJECT_TYPE_TO_STAGE.find(subobject.type);
        pair != COMPATIBLE_SUBOBJECT_TYPE_TO_STAGE.end()) {
      details.replacement_stages |= pair->second;
    }
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

static std::optional<const PipelineShaderDetails> GetPipelineShaderDetails(reshade::api::device* device, reshade::api::pipeline pipeline) {
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock device_lock(data.mutex);
  if (auto details_pair = data.pipeline_shader_details.find(pipeline.handle);
      details_pair != data.pipeline_shader_details.end()) {
    return details_pair->second;
  }
  return std::nullopt;
}

static void RemoveRuntimeReplacements(reshade::api::device* device, const std::unordered_set<uint32_t>& filter = {}) {
  auto& data = device->get_private_data<DeviceData>();
  std::unique_lock device_lock(data.mutex);
  for (auto& [shader_hash, replacement] : data.runtime_replacements) {
    if (!filter.empty() && !filter.contains(shader_hash)) continue;
    if (auto pair = data.shader_pipeline_handles.find(shader_hash);
        pair != data.shader_pipeline_handles.end()) {
      auto& pipeline_handles = pair->second;
      for (auto pipeline_handle : pipeline_handles) {
        if (auto details_pair = data.pipeline_shader_details.find(pipeline_handle);
            details_pair != data.pipeline_shader_details.end()) {
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
    data->use_replace_on_bind = false;
  }
  if (use_replace_async) {
    data->use_replace_async = true;
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
  cmd_list->create_private_data<CommandListData>();
}

static void OnResetCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  auto& data = cmd_list->get_private_data<CommandListData>();
  data.stage_state.clear();
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
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  if (data.use_replace_async) return false;

  bool changed = false;

  for (uint32_t i = 0; i < subobject_count; ++i) {
    if (!COMPATIBLE_SUBOBJECT_TYPE_TO_STAGE.contains(subobjects[i].type)) continue;
    auto* desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
    if (desc->code_size == 0) continue;

    const uint32_t shader_hash = compute_crc32(
        static_cast<const uint8_t*>(desc->code),
        desc->code_size);

    if (auto pair = data.compile_time_replacements.find(shader_hash);
        pair != data.compile_time_replacements.end()) {
      changed = true;
      const auto& replacement = pair->second;
      auto new_size = replacement.size();

      desc->code_size = new_size;

      if (new_size == 0) {
        desc->code = nullptr;
      } else {
        desc->code = malloc(new_size);
        memcpy(const_cast<void*>(desc->code), replacement.data(), new_size);
        const uint32_t new_hash = compute_crc32(
            replacement.data(),
            new_size);
        data.shader_replacements[shader_hash] = new_hash;
        data.shader_replacements_inverse[new_hash] = shader_hash;
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
  return changed;
}

static void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  if (!is_primary_hook) return;
  if (pipeline.handle == 0u) return;

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  auto details = PipelineShaderDetails(layout, subobjects, subobject_count, data.shader_replacements_inverse);

  if (details.shader_hashes.empty()) return;

  for (const auto shader_hash : details.shader_hashes) {
    if (auto pair = data.shader_pipeline_handles.find(shader_hash);
        pair != data.shader_pipeline_handles.end()) {
      auto& pipeline_handles = pair->second;
      pipeline_handles.emplace(pipeline.handle);
    } else {
      data.shader_pipeline_handles[shader_hash] = {pipeline.handle};
    }
  }

  reshade::api::pipeline_subobject* subobjects_clone = renodx::utils::pipeline::ClonePipelineSubObjects(subobjects, subobject_count);

  // Store clone of subobjects
  details.subobjects = std::vector<reshade::api::pipeline_subobject>(
      subobjects_clone,
      subobjects_clone + subobject_count);

  // details.replacement_pipeline = {0u};
  // details.replacement_stages = static_cast<reshade::api::pipeline_stage>(0u),
  // details.initialized_replacement = false,

  data.pipeline_shader_details[pipeline.handle] = details;
}

static void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  if (!is_primary_hook) return;
  auto& data = device->get_private_data<DeviceData>();

  const std::unique_lock lock(data.mutex);

  if (auto details_pair = data.pipeline_shader_details.find(pipeline.handle);
      details_pair != data.pipeline_shader_details.end()) {
    auto& details = details_pair->second;
    if (details.replacement_pipeline.handle != 0u) {
      device->destroy_pipeline(details.replacement_pipeline);
      details.replacement_pipeline = {0u};
    }
    if (!data.use_replace_async) {
      renodx::utils::pipeline::DestroyPipelineSubobjects(details.subobjects);
      data.pipeline_shader_details.erase(details_pair);
    } else {
      if (!details.destroyed) {
        for (auto shader_hash : details.shader_hashes) {
          if (auto shader_pipelines_pair = data.shader_pipeline_handles.find(shader_hash);
              shader_pipelines_pair != data.shader_pipeline_handles.end()) {
            auto& pipeline_handles = shader_pipelines_pair->second;
            pipeline_handles.erase(pipeline.handle);
          }
        }
        details.destroyed = true;
      }
    }
  }
}

// AfterSetPipelineState
static void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    reshade::api::pipeline pipeline) {
  if (!is_primary_hook) return;
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();

  bool found_compatible = false;
  for (auto compatible_stage : COMPATIBLE_STAGES) {
    if (stage == reshade::api::pipeline_stage::all || (stage & compatible_stage) == compatible_stage) {
      found_compatible = true;
      if (pipeline.handle == 0u) {
        cmd_list_data.stage_state.erase(compatible_stage);
      } else {
        break;
      }
    }
  }
  if (pipeline.handle == 0) return;
  if (!found_compatible) return;

  auto* device = cmd_list->get_device();
  auto& device_data = device->get_private_data<DeviceData>();
  std::shared_lock read_lock(device_data.mutex);

  auto details_pair = device_data.pipeline_shader_details.find(pipeline.handle);
  if (details_pair == device_data.pipeline_shader_details.end()) {
#ifdef DEBUG_LEVEL_2
    std::stringstream s;
    s << "utils::shader::OnBindPipeline(No details: ";
    s << (void*)pipeline.handle;
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    return;
  }

  auto& details = details_pair->second;

  cmd_list_data.pipeline_layout = details.layout;

  if (!details.initialized_replacement) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::shader::OnBindPipeline(NeedsReplacementPipeline: ";
    s << (void*)pipeline.handle;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    read_lock.unlock();
    {
      const std::unique_lock write_lock(device_data.mutex);
      BuildReplacementPipeline(device, device_data, details);
    }
    read_lock.lock();
  }

  for (auto compatible_stage : COMPATIBLE_STAGES) {
    if (!renodx::utils::bitwise::HasFlag(stage, compatible_stage)) continue;
    StageState* stage_state = nullptr;
    if (auto pair = details.shader_hashes_by_stage.find(compatible_stage);
        pair != details.shader_hashes_by_stage.end()) {
      stage_state = &cmd_list_data.stage_state[compatible_stage];
      stage_state->shader_hash = pair->second;
      stage_state->pipeline = pipeline;
    }
    if (((details.replacement_stages & compatible_stage) == compatible_stage)) {
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
        if (stage_state == nullptr) {
          stage_state = &cmd_list_data.stage_state[compatible_stage];
        }
        stage_state->pending_replacement = details.replacement_pipeline;
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
        if (stage_state == nullptr) {
          stage_state = &cmd_list_data.stage_state[compatible_stage];
        }
        stage_state->pending_replacement = {0u};
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

inline std::optional<std::vector<uint8_t>> GetShaderData(reshade::api::device* device, reshade::api::pipeline pipeline, uint32_t shader_hash) {
  auto& data = device->get_private_data<DeviceData>();
  std::shared_lock device_lock(data.mutex);
  if (auto details_pair = data.pipeline_shader_details.find(pipeline.handle);
      details_pair != data.pipeline_shader_details.end()) {
    auto details = details_pair->second;

    for (const auto& [item_index, item_shader_hash] : details.shader_hashes_by_index) {
      if (item_shader_hash != shader_hash) continue;
      auto& subobject = details.subobjects[item_index];
      const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);
      if (desc.code_size == 0) return {};
      return std::vector<uint8_t>({
          static_cast<const uint8_t*>(desc.code),
          static_cast<const uint8_t*>(desc.code) + desc.code_size,
      });
    }
  }

  return std::nullopt;
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
