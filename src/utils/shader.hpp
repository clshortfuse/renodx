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
  std::optional<reshade::api::pipeline> replacement_pipeline = std::nullopt;
  reshade::api::pipeline_stage replacement_stages = reshade::api::pipeline_stage{0};
  bool destroyed = false;

  std::optional<std::vector<uint8_t>> GetShaderData(uint32_t shader_hash, size_t index = -1) {
    if (index == -1) {
      for (auto& [item_index, item_shader_hash] : shader_hashes_by_index) {
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
        shader_hash = pair->second;
        replaced_shader_hashes.emplace(shader_hash);
      }

      this->shader_hashes.emplace(shader_hash);
      this->shader_hashes_by_index.emplace(i, shader_hash);
      this->shader_hashes_by_type.emplace(subobject.type, shader_hash);
      this->shader_hashes_by_stage.emplace(stage, shader_hash);
    }
    this->subobjects = std::vector<reshade::api::pipeline_subobject>(subobjects, subobjects + subobject_count);
  }
};

struct __declspec(uuid("908f0889-64d8-4e22-bd26-ded3dd0cef77")) DeviceData {
  std::unordered_map<uint32_t, std::unordered_set<uint64_t>> shader_pipelines;
  std::unordered_map<uint64_t, PipelineShaderDetails> pipeline_shader_details;
  std::unordered_set<uint64_t> incompatible_pipelines;
  std::unordered_set<uint64_t> ignored_pipelines;

  std::unordered_map<uint32_t, uint32_t> shader_replacements;          // Old => New
  std::unordered_map<uint32_t, uint32_t> shader_replacements_inverse;  // New => Old
  std::shared_mutex mutex;
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

  void ApplyReplacements(reshade::api::command_list* cmd_list) {
    for (auto [stage, pipeline] : pending_replacements) {
      cmd_list->bind_pipeline(stage, pipeline);
    }
    pending_replacements.clear();
  }
};

namespace internal {

static std::shared_mutex mutex;
static std::unordered_map<uint32_t, std::vector<uint8_t>> compile_time_replacements;
static std::unordered_map<uint32_t, std::vector<uint8_t>> runtime_replacements;
static std::unordered_set<uint32_t> runtime_replacement_remove_queue;
}  // namespace internal

static bool BuildReplacementPipeline(reshade::api::device* device, PipelineShaderDetails& details) {
  reshade::api::pipeline_subobject* replacement_subobjects = nullptr;
  auto subobject_count = details.subobjects.size();

  for (const auto& [index, shader_hash] : details.shader_hashes_by_index) {
    // Avoid double-replacement
    if (details.replaced_shader_hashes.contains(shader_hash)) {
      std::stringstream s;
      s << "utils::shader::BuildReplacementPipeline(bypassing ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      // reshade::log_message(reshade::log_level::debug, s.str().c_str());
      continue;
    }
    const std::shared_lock util_lock(internal::mutex);
    if (auto new_shader_pair = internal::runtime_replacements.find(shader_hash);
        new_shader_pair != internal::runtime_replacements.end()) {
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
      std::stringstream s;
      s << "utils::shader::BuildReplacementPipeline(replacing ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      // reshade::log_message(reshade::log_level::debug, s.str().c_str());

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

static void AddCompileTimeReplacement(
    uint32_t shader_hash,
    const std::vector<uint8_t>& shader_data) {
  const std::unique_lock lock(internal::mutex);
  internal::compile_time_replacements[shader_hash] = shader_data;
}

static void RemoveCompileTimeReplacement(
    uint32_t shader_hash) {
  const std::unique_lock lock(internal::mutex);
  internal::compile_time_replacements.erase(shader_hash);
}

static void AddRuntimeReplacement(
    uint32_t shader_hash,
    const std::vector<uint8_t>& shader_data) {
  const std::unique_lock lock(internal::mutex);
  internal::runtime_replacements[shader_hash] = std::vector<uint8_t>(shader_data);
  runtime_replacement_count = internal::runtime_replacements.size();
}

static std::optional<PipelineShaderDetails> GetPipelineShaderDetails(reshade::api::device* device, reshade::api::pipeline pipeline) {
  auto& data = device->get_private_data<DeviceData>();
  std::unique_lock device_lock(data.mutex);
  if (auto details_pair = data.pipeline_shader_details.find(pipeline.handle);
      details_pair != data.pipeline_shader_details.end()) {
    return details_pair->second;
  }
  return std::nullopt;
}

static void RemoveQueuedRuntimeReplacements(reshade::api::device* device) {
  std::unique_lock global_lock(internal::mutex);
  auto& data = device->get_private_data<DeviceData>();
  std::unique_lock device_lock(data.mutex);
  for (auto shader_hash : internal::runtime_replacement_remove_queue) {
    if (auto entry = data.shader_pipelines.find(shader_hash);
        entry != data.shader_pipelines.end()) {
      auto& pipeline_set = entry->second;
      for (auto pipeline_handle : pipeline_set) {
        if (auto details_pair = data.pipeline_shader_details.find(pipeline_handle);
            details_pair != data.pipeline_shader_details.end()) {
          auto& details = details_pair->second;
          if (details.HasReplacementPipeline()) {
            device->destroy_pipeline(details.GetReplacementPipeline());
            details.replacement_pipeline.reset();
          }
          data.ignored_pipelines.erase(pipeline_handle);
        }
      }
    }
  }
  internal::runtime_replacement_remove_queue.clear();
}

static void OnPresentRemoveShaders(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  auto* device = swapchain->get_device();
  RemoveQueuedRuntimeReplacements(device);
  reshade::unregister_event<reshade::addon_event::present>(OnPresentRemoveShaders);
}

static void RemoveAllRuntimeReplacements(reshade::api::device* device = nullptr) {
  {
    const std::unique_lock lock(internal::mutex);
    for (auto& [shader_hash, data] : internal::runtime_replacements) {
      internal::runtime_replacement_remove_queue.insert(shader_hash);
    }
    internal::runtime_replacements.clear();
    runtime_replacement_count = 0;
  }

  if (device == nullptr) {
    // Destroy cloned pipelines on next present
    reshade::register_event<reshade::addon_event::present>(OnPresentRemoveShaders);
  } else {
    RemoveQueuedRuntimeReplacements(device);
  }
}

static void RemoveRuntimeReplacement(
    uint32_t shader_hash,
    reshade::api::device* device = nullptr) {
  {
    const std::unique_lock lock(internal::mutex);
    internal::runtime_replacements.erase(shader_hash);
    internal::runtime_replacement_remove_queue.emplace(shader_hash);
    runtime_replacement_count = internal::runtime_replacements.size();
  }

  if (device == nullptr) {
    // Destroy cloned pipelines on next present
    reshade::register_event<reshade::addon_event::present>(OnPresentRemoveShaders);
  } else {
    RemoveQueuedRuntimeReplacements(device);
  }
}

static CommandListData& GetCurrentState(reshade::api::command_list* cmd_list) {
  return cmd_list->get_private_data<CommandListData>();
}

static void OnInitDevice(reshade::api::device* device) {
  auto& data = device->create_private_data<DeviceData>();
#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "utils::shader::OnInitDevice(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
}

static void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "utils::shader::OnDestroyDevice(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  auto& data = cmd_list->create_private_data<CommandListData>();
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

static bool OnCreatePipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
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
      reshade::log_message(reshade::log_level::info, s.str().c_str());
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
  if (pipeline.handle == 0u) return;

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  auto details = PipelineShaderDetails(layout, subobjects, subobject_count, data.shader_replacements_inverse);

  if (details.shader_hashes.empty()) {
    data.incompatible_pipelines.emplace(pipeline.handle);
    return;
  }

  for (const auto shader_hash : details.shader_hashes) {
    if (auto pair = data.shader_pipelines.find(shader_hash);
        pair != data.shader_pipelines.end()) {
      auto& set = pair->second;
      set.emplace(pipeline.handle);
    } else {
      data.shader_pipelines[shader_hash] = {pipeline.handle};
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
  auto& data = device->get_private_data<DeviceData>();

  const std::unique_lock lock(data.mutex);

  data.ignored_pipelines.erase(pipeline.handle);
  data.incompatible_pipelines.erase(pipeline.handle);
  if (auto details_pair = data.pipeline_shader_details.find(pipeline.handle);
      details_pair != data.pipeline_shader_details.end()) {
    auto& details = details_pair->second;
    if (!details.destroyed) {
      if (details.HasReplacementPipeline()) {
        device->destroy_pipeline(details.GetReplacementPipeline());
        details.replacement_pipeline.reset();
      }
      for (auto shader_hash : details.shader_hashes) {
        if (auto shader_pipelines_pair = data.shader_pipelines.find(shader_hash);
            shader_pipelines_pair != data.shader_pipelines.end()) {
          auto& set = shader_pipelines_pair->second;
          set.erase(pipeline.handle);
        }
      }
      details.destroyed = true;
    }
    if (!use_replace_async) {
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
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();

  if (pipeline.handle == 0) {
    for (auto compatible_stage : COMPATIBLE_STAGES) {
      if ((stage | compatible_stage) != 0) {
        cmd_list_data.current_shaders_hashes.erase(compatible_stage);
        if (use_replace_on_bind) {
          cmd_list_data.pending_replacements.erase(compatible_stage);
        }
      }
    }
    return;
  }

  auto* device = cmd_list->get_device();
  auto& device_data = device->get_private_data<DeviceData>();

  std::shared_lock read_lock(device_data.mutex);
  if (device_data.incompatible_pipelines.contains(pipeline.handle)) return;

  auto details_pair = device_data.pipeline_shader_details.find(pipeline.handle);
  if (details_pair == device_data.pipeline_shader_details.end()) {
    read_lock.unlock();
    const std::unique_lock write_lock(device_data.mutex);
    device_data.incompatible_pipelines.emplace(pipeline.handle);
    return;
  }

  auto& details = details_pair->second;

  cmd_list_data.pipeline_layout = details.layout;

  if (details.NeedsReplacementPipeline()) {
    read_lock.unlock();
    {
      const std::unique_lock write_lock(device_data.mutex);
      BuildReplacementPipeline(device, details);
    }
    read_lock.lock();
  }

  for (auto compatible_stage : COMPATIBLE_STAGES) {
    if ((stage | compatible_stage) == 0) continue;
    if (auto pair = details.shader_hashes_by_stage.find(compatible_stage);
        pair != details.shader_hashes_by_stage.end()) {
      cmd_list_data.current_shaders_hashes[compatible_stage] = pair->second;
    }
    if (details.HasReplacementPipeline() && ((details.replacement_stages | compatible_stage) != 0)) {
      if (use_replace_on_bind) {
        cmd_list->bind_pipeline(stage, pipeline);
      } else {
        cmd_list_data.pending_replacements[compatible_stage] = details.replacement_pipeline.value();
      }
    }
  }
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log_message(reshade::log_level::info, "ShaderUtil attached.");
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
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
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::create_pipeline>(OnCreatePipeline);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
      break;
  }
}

}  // namespace renodx::utils::shader
