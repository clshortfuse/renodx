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
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./format.hpp"
#include "./pipeline.hpp"

namespace renodx::utils::shader {

static std::atomic_bool use_replace_on_bind = true;
static std::atomic_bool use_replace_async = false;
static std::atomic_size_t runtime_replacement_count = 0;

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

static std::vector<uint8_t> GetShaderData(const reshade::api::pipeline_subobject& subobject) {
  const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);
  if (desc.code_size == 0) return {};
  return {
      static_cast<const uint8_t*>(desc.code),
      static_cast<const uint8_t*>(desc.code) + desc.code_size};
}

struct PipelineShaderDetails {
  reshade::api::pipeline_layout layout = {0};
  std::vector<reshade::api::pipeline_subobject> subobjects;
  std::unordered_set<uint32_t> shader_hashes;
  std::unordered_set<uint32_t> replaced_shader_hashes;
  std::unordered_map<size_t, uint32_t> shader_hashes_by_index;
  std::unordered_map<reshade::api::pipeline_subobject_type, uint32_t> shader_hashes_by_type;
  std::unordered_map<reshade::api::pipeline_stage, uint32_t> shader_hashes_by_stage;
  std::optional<reshade::api::pipeline> replacement_pipeline;
  reshade::api::pipeline_stage replacement_stages = reshade::api::pipeline_stage{0};
  std::optional<std::string> tag;
  bool destroyed = false;

  [[nodiscard]] std::optional<std::vector<uint8_t>> GetShaderData(uint32_t shader_hash, size_t index = -1) const {
    if (index == -1) {
      for (const auto& [item_index, item_shader_hash] : shader_hashes_by_index) {
        if (item_shader_hash != shader_hash) continue;
        index = item_index;
      }
    }
    if (index == -1) return std::nullopt;
    return renodx::utils::shader::GetShaderData(subobjects[index]);
  }

  [[nodiscard]] bool NeedsReplacementPipeline() const { return !replacement_pipeline.has_value(); }
  [[nodiscard]] bool HasReplacementPipeline() const { return replacement_pipeline.has_value() && replacement_pipeline->handle != 0u; }
  [[nodiscard]] reshade::api::pipeline GetReplacementPipeline() const { return replacement_pipeline.value(); }

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

      auto shader_data = renodx::utils::shader::GetShaderData(subobject);
      if (shader_data.empty()) continue;
      // Pipeline has a shader with code. Hash code and check

      uint32_t shader_hash = compute_crc32(shader_data.data(), shader_data.size());

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
    this->subobjects = std::vector<reshade::api::pipeline_subobject>(subobjects, subobjects + subobject_count);
  }
};

struct __declspec(uuid("908f0889-64d8-4e22-bd26-ded3dd0cef77")) DeviceData {
  std::shared_mutex mutex;

  std::unordered_map<uint32_t, std::unordered_set<uint64_t>> shader_pipeline_handles;
  std::unordered_map<uint64_t, PipelineShaderDetails> pipeline_shader_details;
  std::unordered_set<uint64_t> ignored_pipelines;
  std::unordered_map<uint32_t, std::vector<uint8_t>> compile_time_replacements;
  std::unordered_map<uint32_t, std::vector<uint8_t>> runtime_replacements;

  std::unordered_map<uint32_t, uint32_t> shader_replacements;          // Old => New
  std::unordered_map<uint32_t, uint32_t> shader_replacements_inverse;  // New => Old
  bool use_replace_on_bind = true;
  bool use_replace_async = false;
};

struct __declspec(uuid("8707f724-c7e5-420e-89d6-cc032c732d2d")) CommandListData {
  reshade::api::pipeline_layout pipeline_layout = {0};
  std::unordered_map<reshade::api::pipeline_stage, reshade::api::pipeline> pending_replacements;
  std::unordered_map<reshade::api::pipeline_stage, uint32_t> current_shaders_hashes;

  [[nodiscard]] uint32_t GetCurrentShaderHash(reshade::api::pipeline_stage stage) const {
    auto pair = current_shaders_hashes.find(stage);
    if (pair == current_shaders_hashes.end()) return 0u;
    return pair->second;
  }

  [[nodiscard]] uint32_t GetCurrentVertexShaderHash() const { return GetCurrentShaderHash(reshade::api::pipeline_stage::vertex_shader); }
  [[nodiscard]] uint32_t GetCurrentPixelShaderHash() const { return GetCurrentShaderHash(reshade::api::pipeline_stage::pixel_shader); }
  [[nodiscard]] uint32_t GetCurrentComputeShaderHash() const { return GetCurrentShaderHash(reshade::api::pipeline_stage::compute_shader); }

  void ApplyReplacement(reshade::api::command_list* cmd_list, reshade::api::pipeline_stage stage) {
    auto pair = pending_replacements.find(stage);
    if (pair == pending_replacements.end()) return;
#ifdef DEBUG_LEVEL_2
    std::stringstream s;
    s << "utils::shader::ApplyReplacements(Applying replacement ";
    s << stage;
    s << ", pipeline: " << reinterpret_cast<void*>(pair->second.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->bind_pipeline(stage, pair->second);
    pending_replacements.erase(pair);
  }

  void ApplyDispatchReplacements(reshade::api::command_list* cmd_list) {
    ApplyReplacement(cmd_list, reshade::api::pipeline_stage::compute_shader);
  }

  void ApplyDrawReplacements(reshade::api::command_list* cmd_list) {
    ApplyReplacement(cmd_list, reshade::api::pipeline_stage::vertex_shader);
    ApplyReplacement(cmd_list, reshade::api::pipeline_stage::pixel_shader);
  }
};

namespace internal {

static std::shared_mutex mutex;
static std::unordered_map<uint32_t, std::vector<uint8_t>> compile_time_replacements;
static std::unordered_map<uint32_t, std::vector<uint8_t>> initial_runtime_replacements;
}  // namespace internal

static bool BuildReplacementPipeline(reshade::api::device* device, DeviceData& data, PipelineShaderDetails& details) {
  reshade::api::pipeline_subobject* replacement_subobjects = nullptr;
  auto subobject_count = details.subobjects.size();

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
    if (auto new_shader_pair = data.runtime_replacements.find(shader_hash);
        new_shader_pair != data.runtime_replacements.end()) {
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
  }

  if (replacement_subobjects == nullptr) {
    details.replacement_stages = static_cast<reshade::api::pipeline_stage>(0);
    details.replacement_pipeline = {0};
    return false;
  }

  reshade::api::pipeline new_pipeline;
  const bool built_pipeline_ok = device->create_pipeline(
      details.layout,
      subobject_count,
      replacement_subobjects,
      &new_pipeline);
  renodx::utils::pipeline::DestroyPipelineSubobjects(replacement_subobjects, subobject_count);
  if (built_pipeline_ok) {
    details.replacement_pipeline = new_pipeline;
  } else {
    details.replacement_pipeline.reset();
  }
  return built_pipeline_ok;
}

static void QueueCompileTimeReplacement(
    uint32_t shader_hash,
    const std::vector<uint8_t>& shader_data) {
  const std::unique_lock lock(internal::mutex);
  internal::compile_time_replacements[shader_hash] = shader_data;
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
  std::unique_lock device_lock(data.mutex);
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
          if (details.HasReplacementPipeline()) {
            device->destroy_pipeline(details.GetReplacementPipeline());
          }
          details.replacement_pipeline.reset();
          data.ignored_pipelines.erase(pipeline_handle);
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

static bool is_primary_hook = false;

static void OnInitDevice(reshade::api::device* device) {
  DeviceData* data = &device->get_private_data<DeviceData>();
  if (data == nullptr) {
    data = &device->create_private_data<DeviceData>();
    std::stringstream s;
    s << "utils::shader::OnInitDevice(Hooking device: ";
    s << reinterpret_cast<void*>(device);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    is_primary_hook = true;

  } else {
    std::stringstream s;
    s << "utils::shader::OnInitDevice(Attaching to hook: ";
    s << reinterpret_cast<void*>(device);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }

  if (!use_replace_on_bind) {
    data->use_replace_on_bind = false;
  }
  if (use_replace_async) {
    data->use_replace_async = true;
  }

  std::unique_lock internal_lock(internal::mutex);
  for (auto& [shader_hash, replacement] : internal::compile_time_replacements) {
    auto [iterator, is_new] = data->compile_time_replacements.emplace(shader_hash, replacement);
    if (!is_new) {
      std::stringstream s;
      s << "utils::shader::OnInitDevice(Overwriting compile-time replacement:";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    } else {
      std::stringstream s;
      s << "utils::shader::OnInitDevice(Registered compile-time replacement: ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
  }

  for (auto& [shader_hash, replacement] : internal::initial_runtime_replacements) {
    auto [iterator, is_new] = data->runtime_replacements.emplace(shader_hash, replacement);
    if (!is_new) {
      std::stringstream s;
      s << "utils::shader::OnInitDevice(Overwriting runtime replacement: ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    } else {
      std::stringstream s;
      s << "utils::shader::OnInitDevice(Registered runtime replacement: ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
  }
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
  data.current_shaders_hashes.clear();
  data.pending_replacements.clear();
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

    const std::shared_lock lock(internal::mutex);

    if (auto pair = internal::compile_time_replacements.find(shader_hash);
        pair != internal::compile_time_replacements.end()) {
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

  data.pipeline_shader_details[pipeline.handle] = details;
}

static void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  if (!is_primary_hook) return;
  auto& data = device->get_private_data<DeviceData>();

  const std::unique_lock lock(data.mutex);

  data.ignored_pipelines.erase(pipeline.handle);
  if (auto details_pair = data.pipeline_shader_details.find(pipeline.handle);
      details_pair != data.pipeline_shader_details.end()) {
    auto& details = details_pair->second;
    if (!details.destroyed) {
      if (details.HasReplacementPipeline()) {
        device->destroy_pipeline(details.GetReplacementPipeline());
        details.replacement_pipeline.reset();
      }
      for (auto shader_hash : details.shader_hashes) {
        if (auto shader_pipelines_pair = data.shader_pipeline_handles.find(shader_hash);
            shader_pipelines_pair != data.shader_pipeline_handles.end()) {
          auto& pipeline_handles = shader_pipelines_pair->second;
          pipeline_handles.erase(pipeline.handle);
        }
      }
      details.destroyed = true;
    }
    if (!data.use_replace_async) {
      renodx::utils::pipeline::DestroyPipelineSubobjects(details.subobjects);
      data.pipeline_shader_details.erase(details_pair);
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
    if ((stage & compatible_stage) == compatible_stage) {
      found_compatible = true;
      if (pipeline.handle == 0u) {
        cmd_list_data.current_shaders_hashes.erase(compatible_stage);
        cmd_list_data.pending_replacements.erase(compatible_stage);
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

  if (details.NeedsReplacementPipeline()) {
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
    if ((stage & compatible_stage) == 0u) continue;
    if (auto pair = details.shader_hashes_by_stage.find(compatible_stage);
        pair != details.shader_hashes_by_stage.end()) {
      cmd_list_data.current_shaders_hashes[compatible_stage] = pair->second;
    }
    if (details.HasReplacementPipeline() && ((details.replacement_stages & compatible_stage) == compatible_stage)) {
      auto& replacement_pipeline = details.replacement_pipeline.value();
      if (device_data.use_replace_on_bind) {
#ifdef DEBUG_LEVEL_2
        std::stringstream s;
        s << "utils::shader::OnBindPipeline(Replacing on bind";
        s << ", stage: " << stage;
        s << ", compatible: " << compatible_stage;
        s << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle);
        s << " => " << reinterpret_cast<void*>(replacement_pipeline.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        cmd_list->bind_pipeline(compatible_stage, replacement_pipeline);
      } else {
#ifdef DEBUG_LEVEL_2
        std::stringstream s;
        s << "utils::shader::OnBindPipeline(Queuing replacement";
        s << ", stage: " << stage;
        s << ", compatible: " << compatible_stage;
        s << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle);
        s << " => " << reinterpret_cast<void*>(replacement_pipeline.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        cmd_list_data.pending_replacements[compatible_stage] = replacement_pipeline;
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
        cmd_list_data.pending_replacements.erase(compatible_stage);
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

static bool attached = false;

static void Use(DWORD fdw_reason) {
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
