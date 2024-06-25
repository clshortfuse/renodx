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
    std::unordered_map<uint64_t, uint64_t> pipelineToLayoutMap;
    std::unordered_map<uint32_t, std::pair<uint64_t, reshade::api::pipeline_subobject_type>> shaderToPipelineReplacement;
    std::unordered_map<uint64_t, std::pair<uint64_t, reshade::api::pipeline_subobject_type>> pipelineToPipelineReplacement;
    std::unordered_map<uint64_t, std::pair<uint32_t, reshade::api::pipeline_subobject_type>> pipelineToShaderHashMap;
    std::unordered_map<uint32_t, uint32_t> shaderReplacements;         // Old => New
    std::unordered_map<uint32_t, uint32_t> shaderReplacementsInverse;  // New => Old
    std::shared_mutex mutex;
  };

  struct __declspec(uuid("8707f724-c7e5-420e-89d6-cc032c732d2d")) CommandListData {
    uint32_t pixelShaderHash = 0;
    uint32_t computeShaderHash = 0;
    reshade::api::pipeline_layout pipelineLayout = {0};
    reshade::api::pipeline_stage pipeline_stage = reshade::api::pipeline_stage::all;
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

  static uint32_t getPixelShaderHash(reshade::api::command_list* cmd_list) {
    auto &cmd_list_data = cmd_list->get_private_data<CommandListData>();
    return cmd_list_data.pixelShaderHash;
  }

  static uint32_t getComputeShaderHash(reshade::api::command_list* cmd_list) {
    auto &cmd_list_data = cmd_list->get_private_data<CommandListData>();
    return cmd_list_data.computeShaderHash;
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
  }

  static void on_destroy_command_list(reshade::api::command_list* cmd_list) {
    cmd_list->destroy_private_data<CommandListData>();
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
        const auto &[code_size, code] = pair->second;
        desc->code_size = code_size;

        if (code_size) {
          void* copy = (void*)malloc(desc->code_size);  // leak;
          memcpy(copy, code, desc->code_size);
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
          << " with " << code_size << " bytes "
          << " at " << (void*)desc->code
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
    }
    return changed;
  }

  static void trace_shader(
    reshade::api::device* device,
    DeviceData &data,
    const reshade::api::pipeline &original_pipeline,
    const reshade::api::pipeline_layout &original_layout,
    const reshade::api::pipeline_subobject &original_subobject,
    const uint32_t original_hash
  ) {
    data.pipelineToLayoutMap[original_pipeline.handle] = original_layout.handle;
    data.pipelineToShaderHashMap[original_pipeline.handle] = {
      original_hash,
      original_subobject.type,
    };
  }

  static reshade::api::pipeline create_shader_replacement(
    reshade::api::device* device,
    DeviceData &data,
    reshade::api::pipeline &original_pipeline,
    reshade::api::pipeline_layout &original_layout,
    size_t subobject_count,
    const reshade::api::pipeline_subobject* original_subobjects,
    size_t index,
    uint32_t original_hash,
    size_t new_size,
    void* new_code
  ) {
    reshade::api::pipeline_subobject* new_pipeline_subobjects = new reshade::api::pipeline_subobject[subobject_count];
    memcpy(new_pipeline_subobjects, original_subobjects, sizeof(reshade::api::pipeline_subobject) * subobject_count);

    reshade::api::pipeline_subobject_type type = new_pipeline_subobjects[index].type;
    reshade::api::shader_desc* desc = (reshade::api::shader_desc*)(new_pipeline_subobjects[index].data);

    desc->code_size = new_size;
    if (new_size) {
      void* copy = (void*)malloc(new_size);  // leak;
      memcpy(copy, new_code, new_size);
      desc->code = copy;
    } else {
      desc->code = nullptr;
    }

    reshade::api::pipeline new_pipeline;
    bool builtPipelineOK = device->create_pipeline(original_layout, subobject_count, new_pipeline_subobjects, &new_pipeline);
    if (builtPipelineOK) {
      data.pipelineToLayoutMap[new_pipeline.handle] = original_layout.handle;
      data.pipelineToShaderHashMap[new_pipeline.handle] = {
        original_hash,
        type,
      };
      data.pipelineToPipelineReplacement[original_pipeline.handle] = {
        new_pipeline.handle,
        type
      };
      data.shaderToPipelineReplacement[original_hash] = {
        new_pipeline.handle,
        type
      };

      std::stringstream s;
      s << "ShaderUtil::on_init_pipeline(clone pipeline "
        << (void*)original_pipeline.handle
        << " => "
        << (void*)new_pipeline.handle
        << ", layout: " << reinterpret_cast<void*>(original_layout.handle)
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    } else {
      std::stringstream s;
      s << "ShaderUtil::on_init_pipeline(failed to clone pipeline "
        << reinterpret_cast<void*>(original_pipeline.handle)
        << ", layout: " << reinterpret_cast<void*>(original_layout.handle)
        << ", hash: " << PRINT_CRC32(original_hash)
        << ", type: " << to_string(type)
        << ", size: " << new_size
        << ", data: " << reinterpret_cast<void*>(new_code)
        << ")";
      reshade::log_message(reshade::log_level::error, s.str().c_str());
      // Log error
    }
    return new_pipeline;
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
    for (uint32_t i = 0; i < subobjectCount; ++i) {
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
      uint32_t foundShader = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);
      std::unique_lock lock(data.mutex);
      if (
        auto pair = data.shaderReplacementsInverse.find(foundShader);
        pair != data.shaderReplacementsInverse.end()
      ) {
        uint32_t original_hash = pair->second;
        trace_shader(device, data, pipeline, layout, subobject, original_hash);

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
        trace_shader(device, data, pipeline, layout, subobject, foundShader);

        if (
          auto pair = initPipelineReplacements.find(foundShader);
          pair != initPipelineReplacements.end()
        ) {
          const auto &[code_size, code] = pair->second;
          uint32_t new_shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);

          std::stringstream s;
          s << "ShaderUtil::on_init_pipeline(prep replacement: "
            << PRINT_CRC32(foundShader)
            << ", code_size: " << code_size
            << ", code: " << reinterpret_cast<void*>(code)
            << ", layout: " << reinterpret_cast<void*>(layout.handle)
            << ", new_shader_hash: " << PRINT_CRC32(new_shader_hash)
            << ")";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
          create_shader_replacement(
            device,
            data,
            pipeline,
            layout,
            subobjectCount,
            subobjects,
            i,
            foundShader,
            code_size,
            code
          );
        }
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
        uint32_t shader_hash = std::get<uint32_t>(pair->second);
        data.shaderToPipelineReplacement.erase(shader_hash);
      }
      data.pipelineToShaderHashMap.erase(pipeline.handle);
    }

    {
      if (
        auto pair = data.pipelineToPipelineReplacement.find(pipeline.handle);
        pair != data.pipelineToPipelineReplacement.end()
      ) {
        uint64_t replacement_handle = std::get<uint64_t>(pair->second);
        device->destroy_pipeline({replacement_handle});
        data.pipelineToLayoutMap.erase(replacement_handle);
        data.pipelineToShaderHashMap.erase(replacement_handle);
      }
      data.pipelineToPipelineReplacement.erase(pipeline.handle);
    }

    data.pipelineToLayoutMap.erase(pipeline.handle);
  }

  // AfterSetPipelineState
  static void on_bind_pipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
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
      const auto &[shader_hash, shader_type] = pair->second;
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "ShaderUtil::on_bind_pipeline(shader: "
        << PRINT_CRC32(shader_hash)
        << ", type: " << to_string(shader_type)
        << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle)
        << ")";
      // reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

      if (shader_type == reshade::api::pipeline_subobject_type::pixel_shader) {
        cmd_list_data.pixelShaderHash = shader_hash;
        cmd_list_data.computeShaderHash = 0;
      } else {
        cmd_list_data.pixelShaderHash = 0;
        cmd_list_data.computeShaderHash = shader_hash;
      }
      cmd_list_data.pipeline_stage = stage;
      if (
        auto pair2 = device_data.pipelineToLayoutMap.find(pipeline.handle);
        pair2 != device_data.pipelineToLayoutMap.end()
      ) {
        uint64_t pipeline_layout_handle = pair2->second;
        cmd_list_data.pipelineLayout = {pipeline_layout_handle};
      }
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
