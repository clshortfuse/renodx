/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <stdio.h>

#include <filesystem>
#include <fstream>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./format.hpp"
#include "./mutex.hpp"
#include "./pipelineUtil.hpp"

namespace ShaderUtil {

  struct __declspec(uuid("908f0889-64d8-4e22-bd26-ded3dd0cef77")) DeviceData {
    std::unordered_set<uint64_t> computeShaderLayouts;
    std::unordered_map<uint64_t, uint64_t> pipelineToLayoutMap;
    std::unordered_map<uint32_t, uint64_t> shaderToPipelineReplacement;
    std::unordered_map<uint64_t, uint64_t> pipelineToPipelineReplacement;
    std::unordered_map<uint64_t, uint32_t> pipelineToShaderHashMap;
    std::unordered_map<uint32_t, uint32_t> shaderReplacements;         // Old => New
    std::unordered_map<uint32_t, uint32_t> shaderReplacementsInverse;  // New => Old
    std::shared_mutex mutex;
  };

  struct __declspec(uuid("8707f724-c7e5-420e-89d6-cc032c732d2d")) CommandListData {
    uint32_t currentShaderHash;
    reshade::api::pipeline_stage currentShaderPipelineStage = reshade::api::pipeline_stage::all;
    reshade::api::pipeline currentShaderPipeline = {0};
  };

  static std::shared_mutex mutex;

  static std::unordered_map<uint32_t, std::tuple<size_t, void*>> createPipelineReplacements;
  static std::unordered_map<uint32_t, std::tuple<size_t, void*>> initPipelineReplacements;

  static void addCreatePipelineReplacement(
    uint32_t shader_hash,
    uint32_t size,
    void* data
  ) {
    void* newData = nullptr;
    if (size) {
      newData = malloc(size);
      memcpy(newData, data, size);
    }
    std::unique_lock lock(mutex);
    createPipelineReplacements[shader_hash] = std::tuple<size_t, void*>(size, newData);
  }

  static void removeCreatePipelineReplacement(
    uint32_t shader_hash,
    uint32_t size,
    void* data
  ) {
    std::unique_lock lock(mutex);
    // Leak
    createPipelineReplacements.erase(shader_hash);
  }

  static void addInitPipelineReplacement(
    uint32_t shader_hash,
    uint32_t size,
    void* data
  ) {
    void* newData = nullptr;
    if (size) {
      newData = malloc(size);
      memcpy(newData, data, size);
    }
    std::unique_lock lock(mutex);
    initPipelineReplacements[shader_hash] = std::tuple<size_t, void*>(size, newData);
  }

  static void removeInitPipelineReplacement(
    uint32_t shader_hash,
    uint32_t size,
    void* data
  ) {
    std::unique_lock lock(mutex);
    // Leak
    initPipelineReplacements.erase(shader_hash);
  }

  static void addShaderToPipelineTrace(
    reshade::api::device* device,
    uint32_t shader_hash,
    reshade::api::pipeline pipeline
  ) {
    auto &device_data = device->get_private_data<DeviceData>();
    std::unique_lock lock(device_data.mutex);
    device_data.pipelineToShaderHashMap[pipeline.handle] = shader_hash;
  }

  static uint32_t getCurrentShader(reshade::api::command_list* cmd_list) {
    auto &cmd_list_data = cmd_list->get_private_data<CommandListData>();
    return cmd_list_data.currentShaderHash;
  }

  static void on_init_device(reshade::api::device* device) {
    auto &data = device->create_private_data<DeviceData>();
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "ShaderUtil::on_init_device("
      << reinterpret_cast<void*>(device)
      << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
  }

  static void on_destroy_device(reshade::api::device* device) {
    std::stringstream s;
    s << "ShaderUtil::on_destroy_device("
      << reinterpret_cast<void*>(device)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    device->destroy_private_data<DeviceData>();
  }

  static void on_init_command_list(reshade::api::command_list* cmd_list) {
    auto &data = cmd_list->create_private_data<CommandListData>();
#ifdef DEBUG_LEVEL_1

    std::stringstream s;
    s << "ShaderUtil::on_init_command_list("
      << reinterpret_cast<void*>(cmd_list)
      << ", currentShaderHash " << (void*)&data.currentShaderHash
      << ", currentShaderPipeline " << (void*)&data.currentShaderPipeline
      << ", currentShaderPipelineStage " << (void*)&data.currentShaderPipelineStage
      << ", mutex " << (void*)&data.mutex
      << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
  }

  static void on_destroy_command_list(reshade::api::command_list* cmd_list) {
    cmd_list->destroy_private_data<CommandListData>();
  }

  static uint32_t getShaderHashByPipeline(reshade::api::device* device, reshade::api::pipeline pipeline) {
    auto &device_data = device->get_private_data<DeviceData>();
    std::shared_lock lock(device_data.mutex);

    if (
      auto pair = device_data.pipelineToShaderHashMap.find(pipeline.handle);
      pair != device_data.pipelineToShaderHashMap.end()
    ) return pair->second;

    return 0;
  }

  // Before CreatePipelineState
  static bool on_create_pipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects
  ) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    bool changed = false;

    for (uint32_t i = 0; i < subobject_count; ++i) {
      switch (subobjects[i].type) {
        case reshade::api::pipeline_subobject_type::compute_shader:
        case reshade::api::pipeline_subobject_type::pixel_shader:
          break;
        default:
          continue;
      }
      auto desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
      if (desc->code_size == 0) continue;

      uint32_t shader_hash = compute_crc32(
        static_cast<const uint8_t*>(desc->code),
        desc->code_size
      );

      std::shared_lock lock(mutex);

      if (
        auto pair = createPipelineReplacements.find(shader_hash);
        pair != createPipelineReplacements.end()
      ) {
        changed = true;
        size_t size = std::get<size_t>(pair->second);
        desc->code_size = size;

        if (size) {
          void* copy = (void*)malloc(desc->code_size);  // leak;
          memcpy(copy, std::get<void*>(pair->second), desc->code_size);
          desc->code = copy;
          uint32_t new_hash = compute_crc32(
            static_cast<const uint8_t*>(desc->code),
            desc->code_size
          );
          data.shaderReplacements[shader_hash] = new_hash;
          data.shaderReplacementsInverse[new_hash] = shader_hash;

        } else {
          desc->code = nullptr;
        }
        std::stringstream s;
        s << "ShaderUtil::on_create_pipeline(replacing "
          << PRINT_CRC32(shader_hash)
          << " with " << size << " bytes "
          << " at " << (void*)desc->code
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
    }
    return changed;
  }

  // After CreatePipelineState
  static void on_init_pipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobjectCount,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline
  ) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);

    bool foundComputeShader = false;
    uint32_t foundShader = 0;
    reshade::api::pipeline_subobject* newSubobjects = nullptr;

    for (uint32_t i = 0; i < subobjectCount; ++i) {
      const auto subobject = subobjects[i];
      switch (subobject.type) {
        case reshade::api::pipeline_subobject_type::compute_shader:
          foundComputeShader = true;
          // fallthrough
        case reshade::api::pipeline_subobject_type::pixel_shader:
          break;
        default:
          continue;
      }
      const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);
      if (desc.code_size == 0) continue;

      // Pipeline has a pixel shader with code. Hash code and check
      foundShader = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);

      std::shared_lock lock(mutex);

      if (
        auto pair = data.shaderReplacementsInverse.find(foundShader);
        pair != data.shaderReplacementsInverse.end()
      ) {
        uint32_t original_hash = pair->second;
        data.pipelineToShaderHashMap[pipeline.handle] = original_hash;

        std::stringstream s;
        s << "ShaderUtil::on_init_pipeline(found replacement: "
          << PRINT_CRC32(original_hash)
          << " => "
          << PRINT_CRC32(foundShader)
          << " on " << (void*)pipeline.handle
          << ", layout: " << reinterpret_cast<void*>(layout.handle)
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      } else {
        data.pipelineToShaderHashMap[pipeline.handle] = foundShader;

        if (
          auto pair = initPipelineReplacements.find(foundShader);
          pair != initPipelineReplacements.end()
        ) {
          if (newSubobjects == nullptr) {
            newSubobjects = PipelineUtil::clonePipelineSubObjects(subobjectCount, subobjects);
          }
          reshade::api::shader_desc* desc = (reshade::api::shader_desc*)(newSubobjects[i].data);
          desc->code_size = std::get<size_t>(pair->second);
          if (desc->code_size) {
            void* copy = (void*)malloc(desc->code_size);  // leak;
            memcpy(copy, std::get<void*>(pair->second), desc->code_size);
            desc->code = copy;
          } else {
            desc->code = nullptr;
          }

          std::stringstream s;
          s << "ShaderUtil::on_init_pipeline(clone replacement "
            << PRINT_CRC32(foundShader)
            << ", compute: " << (foundComputeShader ? "true" : "false")
            << ", loc: " << (void*)desc->code
            << ", layout: " << reinterpret_cast<void*>(layout.handle)
            << ")";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
      }
    }
    if (data.pipelineToLayoutMap.contains(pipeline.handle)) {
      std::stringstream s;
      s << "ShaderUtil::on_init_pipeline(pipeline already exists?"
        << PRINT_CRC32(foundShader)
        << ", compute: " << (foundComputeShader ? "true" : "false")
        << ", layout: " << reinterpret_cast<void*>(layout.handle)
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
    data.pipelineToLayoutMap[pipeline.handle] = layout.handle;
    if (foundComputeShader) {
      data.computeShaderLayouts.emplace(layout.handle);
    }
    if (newSubobjects != nullptr) {
      reshade::api::pipeline newPipeline;
      bool builtPipelineOK = device->create_pipeline(layout, subobjectCount, newSubobjects, &newPipeline);
      if (builtPipelineOK) {
        data.pipelineToLayoutMap[newPipeline.handle] = layout.handle;
        data.pipelineToShaderHashMap[newPipeline.handle] = foundShader;
        data.pipelineToPipelineReplacement[pipeline.handle] = newPipeline.handle;
        data.shaderToPipelineReplacement[foundShader] = newPipeline.handle;

        std::stringstream s;
        s << "ShaderUtil::on_init_pipeline(clone pipeline "
          << (void*)pipeline.handle
          << " => "
          << (void*)newPipeline.handle
          << ", layout: " << reinterpret_cast<void*>(layout.handle)
          << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      } else {
        std::stringstream s;
        s << "ShaderUtil::on_init_pipeline(failed to clone pipeline "
          << reinterpret_cast<void*>(pipeline.handle)
          << ", layout: " << reinterpret_cast<void*>(layout.handle)
          << ")";
        reshade::log_message(reshade::log_level::error, s.str().c_str());
        // Log error
      }
    }
  }

  static void on_destroy_pipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline
  ) {
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    {
      if (
        auto pair = data.pipelineToShaderHashMap.find(pipeline.handle);
        pair != data.pipelineToShaderHashMap.end()
      ) {
        uint32_t shader_hash = pair->second;
        data.shaderToPipelineReplacement.erase(shader_hash);
      }
      data.pipelineToShaderHashMap.erase(pipeline.handle);
    }

    {
      if (
        auto pair = data.pipelineToPipelineReplacement.find(pipeline.handle);
        pair != data.pipelineToPipelineReplacement.end()
      ) {
        uint64_t pipelineReplacementHandle = pair->second;
        device->destroy_pipeline({pipelineReplacementHandle});
        data.pipelineToLayoutMap.erase(pipelineReplacementHandle);
        data.pipelineToShaderHashMap.erase(pipelineReplacementHandle);
      }
      data.pipelineToPipelineReplacement.erase(pipeline.handle);
    }

    data.pipelineToLayoutMap.erase(pipeline.handle);
  }

  // AfterSetPipelineState
  static void on_bind_pipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage type,
    reshade::api::pipeline pipeline
  ) {
    auto device = cmd_list->get_device();
    auto &device_data = device->get_private_data<DeviceData>();
    std::unique_lock lock(device_data.mutex);

    if (
      auto pair = device_data.pipelineToShaderHashMap.find(pipeline.handle);
      pair != device_data.pipelineToShaderHashMap.end()
    ) {
      auto &cmd_list_data = cmd_list->get_private_data<CommandListData>();
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "ShaderUtil::on_bind_pipeline(shader: "
        << PRINT_CRC32(pair->second)
        << ", type: " << to_string(type)
        << ", pipeline: " << (void*)pipeline.handle
        << ")";
      // reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      cmd_list_data.currentShaderHash = pair->second;
      cmd_list_data.currentShaderPipelineStage = type;
      cmd_list_data.currentShaderPipeline = pipeline;
    }
  }

  static bool attached = false;

  static void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        if (attached) return;
        attached = true;
        reshade::log_message(reshade::log_level::info, "ShaderUtil attached.");
        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::register_event<reshade::addon_event::init_command_list>(on_init_command_list);
        reshade::register_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);
        reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
        reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
        reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);
        reshade::register_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

        break;
      case DLL_PROCESS_DETACH:

        reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
        reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::unregister_event<reshade::addon_event::init_command_list>(on_init_command_list);
        reshade::unregister_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);
        reshade::unregister_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
        reshade::unregister_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
        reshade::unregister_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);
        reshade::unregister_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);
        break;
    }
  }
}  // namespace ShaderUtil
