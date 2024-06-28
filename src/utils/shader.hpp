/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <cstdio>

#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./format.hpp"

namespace renodx::utils::shader {

struct __declspec(uuid("908f0889-64d8-4e22-bd26-ded3dd0cef77")) DeviceData {
  std::unordered_map<uint64_t, uint64_t> pipeline_to_layout_map;
  std::unordered_map<uint32_t, std::pair<uint64_t, reshade::api::pipeline_subobject_type>> shader_to_pipeline_replacement;
  std::unordered_map<uint64_t, std::pair<uint64_t, reshade::api::pipeline_subobject_type>> pipeline_to_pipeline_replacement;
  std::unordered_map<uint64_t, std::pair<uint32_t, reshade::api::pipeline_subobject_type>> pipeline_to_shader_hash_map;
  std::unordered_map<uint32_t, uint32_t> shader_replacements;          // Old => New
  std::unordered_map<uint32_t, uint32_t> shader_replacements_inverse;  // New => Old
  std::shared_mutex mutex;
};

struct __declspec(uuid("8707f724-c7e5-420e-89d6-cc032c732d2d")) CommandListData {
  uint32_t pixel_shader_hash = 0;
  uint32_t compute_shader_hash = 0;
  reshade::api::pipeline_layout pipeline_layout = {0};
  reshade::api::pipeline_stage pipeline_stage = reshade::api::pipeline_stage::all;
};

static std::shared_mutex mutex;

static std::unordered_map<uint32_t, std::vector<uint8_t>> create_pipeline_replacements;
static std::unordered_map<uint32_t, std::vector<uint8_t>> init_pipeline_replacements;

static void AddCreatePipelineReplacement(
    uint32_t shader_hash,
    uint32_t size,
    const uint8_t* data) {
  const std::unique_lock lock(mutex);
  create_pipeline_replacements[shader_hash] = std::vector<uint8_t>(data, data + size);
}

static void RemoveCreatePipelineReplacement(
    uint32_t shader_hash) {
  const std::unique_lock lock(mutex);
  create_pipeline_replacements.erase(shader_hash);
}

static void AddInitPipelineReplacement(
    uint32_t shader_hash,
    uint32_t size,
    const uint8_t* data) {
  const std::unique_lock lock(mutex);
  init_pipeline_replacements[shader_hash] = std::vector<uint8_t>(data, data + size);
}

static void RemoveInitPipelineReplacement(
    uint32_t shader_hash) {
  const std::unique_lock lock(mutex);
  // Leak
  init_pipeline_replacements.erase(shader_hash);
}

static uint32_t GetPixelShaderHash(reshade::api::command_list* cmd_list) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
  return cmd_list_data.pixel_shader_hash;
}

static uint32_t GetComputeShaderHash(reshade::api::command_list* cmd_list) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
  return cmd_list_data.compute_shader_hash;
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

// Before CreatePipelineState
static bool OnCreatePipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  bool changed = false;

  for (uint32_t i = 0; i < subobject_count; ++i) {
    switch (subobjects[i].type) {
      case reshade::api::pipeline_subobject_type::compute_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:
        break;
      default:
        continue;
    }
    auto* desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
    if (desc->code_size == 0) continue;

    const uint32_t shader_hash = compute_crc32(
        static_cast<const uint8_t*>(desc->code),
        desc->code_size);

    const std::shared_lock lock(mutex);

    if (
        auto pair = create_pipeline_replacements.find(shader_hash);
        pair != create_pipeline_replacements.end()) {
      changed = true;
      const auto replacement = pair->second;
      auto new_size = replacement.size();
      desc->code_size = new_size;

      if (new_size != 0) {
        void* copy = malloc(new_size);  // leak;
        memcpy(copy, replacement.data(), desc->code_size);
        desc->code = copy;
        const uint32_t new_hash = compute_crc32(
            replacement.data(),
            new_size);
        data.shader_replacements[shader_hash] = new_hash;
        data.shader_replacements_inverse[new_hash] = shader_hash;

      } else {
        desc->code = nullptr;
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

static void TraceShader(
    reshade::api::device* device,
    DeviceData& data,
    const reshade::api::pipeline& original_pipeline,
    const reshade::api::pipeline_layout& original_layout,
    const reshade::api::pipeline_subobject& original_subobject,
    const uint32_t original_hash) {
  data.pipeline_to_layout_map[original_pipeline.handle] = original_layout.handle;
  data.pipeline_to_shader_hash_map[original_pipeline.handle] = {
      original_hash,
      original_subobject.type,
  };
}

static reshade::api::pipeline CreateShaderReplacement(
    reshade::api::device* device,
    DeviceData& data,
    reshade::api::pipeline& original_pipeline,
    reshade::api::pipeline_layout& original_layout,
    size_t subobject_count,
    const reshade::api::pipeline_subobject* original_subobjects,
    size_t index,
    uint32_t original_hash,
    size_t new_size,
    const uint8_t* new_code) {
  auto* new_pipeline_subobjects = new reshade::api::pipeline_subobject[subobject_count];
  memcpy(new_pipeline_subobjects, original_subobjects, sizeof(reshade::api::pipeline_subobject) * subobject_count);

  const reshade::api::pipeline_subobject_type type = new_pipeline_subobjects[index].type;
  auto* desc = static_cast<reshade::api::shader_desc*>(new_pipeline_subobjects[index].data);

  desc->code_size = new_size;
  if (new_size != 0) {
    void* copy = malloc(new_size);  // leak;
    memcpy(copy, new_code, new_size);
    desc->code = copy;
  } else {
    desc->code = nullptr;
  }

  reshade::api::pipeline new_pipeline;
  const bool built_pipeline_ok = device->create_pipeline(
      original_layout,
      subobject_count,
      new_pipeline_subobjects,
      &new_pipeline);
  if (built_pipeline_ok) {
    data.pipeline_to_layout_map[new_pipeline.handle] = original_layout.handle;
    data.pipeline_to_shader_hash_map[new_pipeline.handle] = {
        original_hash,
        type,
    };
    data.pipeline_to_pipeline_replacement[original_pipeline.handle] = {
        new_pipeline.handle,
        type,
    };
    data.shader_to_pipeline_replacement[original_hash] = {
        new_pipeline.handle,
        type,
    };

    std::stringstream s;
    s << "utils::shader::OnInitPipeline(clone pipeline ";
    s << reinterpret_cast<void*>(original_pipeline.handle);
    s << " => ";
    s << reinterpret_cast<void*>(new_pipeline.handle);
    s << ", layout: " << reinterpret_cast<void*>(original_layout.handle);
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
  } else {
    std::stringstream s;
    s << "utils::shader::OnInitPipeline(failed to clone pipeline ";
    s << reinterpret_cast<void*>(original_pipeline.handle);
    s << ", layout: " << reinterpret_cast<void*>(original_layout.handle);
    s << ", hash: " << PRINT_CRC32(original_hash);
    s << ", type: " << type;
    s << ", size: " << new_size;
    s << ", data: " << new_code;
    s << ")";
    reshade::log_message(reshade::log_level::error, s.str().c_str());
    // Log error
  }
  return new_pipeline;
}

// After CreatePipelineState
static void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  auto& data = device->get_private_data<DeviceData>();
  for (uint32_t i = 0; i < subobject_count; ++i) {
    const auto subobject = subobjects[i];
    switch (subobject.type) {
      case reshade::api::pipeline_subobject_type::compute_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:
        break;
      default:
        continue;
    }
    const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);
    if (desc.code_size == 0) continue;

    // Pipeline has a pixel shader with code. Hash code and check
    const uint32_t found_shader = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);
    const std::unique_lock lock(data.mutex);
    if (
        auto pair = data.shader_replacements_inverse.find(found_shader);
        pair != data.shader_replacements_inverse.end()) {
      const uint32_t original_hash = pair->second;
      TraceShader(device, data, pipeline, layout, subobject, original_hash);

      std::stringstream s;
      s << "utils::shader::OnInitPipeline(found replacement: ";
      s << PRINT_CRC32(original_hash);
      s << " => ";
      s << PRINT_CRC32(found_shader);
      s << " on " << reinterpret_cast<void*>(pipeline.handle);
      s << ", layout: " << reinterpret_cast<void*>(layout.handle);
      s << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    } else {
      TraceShader(device, data, pipeline, layout, subobject, found_shader);

      if (
          auto pair = init_pipeline_replacements.find(found_shader);
          pair != init_pipeline_replacements.end()) {
        const auto replacement = pair->second;
        const uint32_t new_size = replacement.size();
        const uint32_t new_shader_hash = compute_crc32(replacement.data(), new_size);

        std::stringstream s;
        s << "utils::shader::OnInitPipeline(prep replacement: ";
        s << PRINT_CRC32(found_shader);
        s << ", code_size: " << new_size;
        s << ", code: " << reinterpret_cast<const void*>(replacement.data());
        s << ", layout: " << reinterpret_cast<void*>(layout.handle);
        s << ", new_shader_hash: " << PRINT_CRC32(new_shader_hash);
        s << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
        CreateShaderReplacement(
            device,
            data,
            pipeline,
            layout,
            subobject_count,
            subobjects,
            i,
            found_shader,
            new_size,
            replacement.data());
      }
    }
  }
}

static void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  {
    if (
        auto pair = data.pipeline_to_shader_hash_map.find(pipeline.handle);
        pair != data.pipeline_to_shader_hash_map.end()) {
      const uint32_t shader_hash = std::get<uint32_t>(pair->second);
      data.shader_to_pipeline_replacement.erase(shader_hash);
    }
    data.pipeline_to_shader_hash_map.erase(pipeline.handle);
  }

  {
    if (
        auto pair = data.pipeline_to_pipeline_replacement.find(pipeline.handle);
        pair != data.pipeline_to_pipeline_replacement.end()) {
      const uint64_t replacement_handle = std::get<uint64_t>(pair->second);
      device->destroy_pipeline({replacement_handle});
      data.pipeline_to_layout_map.erase(replacement_handle);
      data.pipeline_to_shader_hash_map.erase(replacement_handle);
    }
    data.pipeline_to_pipeline_replacement.erase(pipeline.handle);
  }

  data.pipeline_to_layout_map.erase(pipeline.handle);
}

// AfterSetPipelineState
static void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    reshade::api::pipeline pipeline) {
  auto* device = cmd_list->get_device();
  auto& device_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(device_data.mutex);

  if (
      auto pair = device_data.pipeline_to_shader_hash_map.find(pipeline.handle);
      pair != device_data.pipeline_to_shader_hash_map.end()) {
    auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
    const auto& [shader_hash, shader_type] = pair->second;
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::shader::OnBindPipeline(shader: ";
    s << PRINT_CRC32(shader_hash);
    s << ", type: " << shader_type;
    s << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle);
    s << ")";
    // reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

    if (shader_type == reshade::api::pipeline_subobject_type::pixel_shader) {
      cmd_list_data.pixel_shader_hash = shader_hash;
      cmd_list_data.compute_shader_hash = 0;
    } else {
      cmd_list_data.pixel_shader_hash = 0;
      cmd_list_data.compute_shader_hash = shader_hash;
    }
    cmd_list_data.pipeline_stage = stage;
    if (
        auto pair2 = device_data.pipeline_to_layout_map.find(pipeline.handle);
        pair2 != device_data.pipeline_to_layout_map.end()) {
      const uint64_t pipeline_layout_handle = pair2->second;
      cmd_list_data.pipeline_layout = {pipeline_layout_handle};
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
