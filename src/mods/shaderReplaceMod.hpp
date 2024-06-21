/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

// #define DEBUG_LEVEL_1

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <stdio.h>

#include <filesystem>
#include <fstream>
#include <random>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "../utils/ResourceUtil.hpp"
#include "../utils/ShaderUtil.hpp"
#include "../utils/SwapchainUtil.hpp"
#include "../utils/format.hpp"
#include "../utils/mutex.hpp"

namespace ShaderReplaceMod {
  struct CustomShader {
    uint32_t crc32;
    const uint8_t* code;
    uint32_t codeSize;
    bool swapChainOnly;
    int32_t index = -1;
  };

  typedef std::unordered_map<uint32_t, CustomShader> CustomShaders;

  // clang-format off
#define CustomSwapchainShader(crc32) { crc32, { crc32, _##crc32, sizeof(_##crc32), true } }
#define CustomShaderEntry(crc32) { crc32, { crc32, _##crc32, sizeof(_##crc32) } }
#define BypassShaderEntry(crc32) { crc32, { crc32, nullptr, 0 } }
#define CustomCountedShader(crc32, index) { crc32, { crc32, _##crc32, sizeof(_##crc32), false, ##index} }
  // clang-format on

  static float* _shaderInjection = nullptr;
  static size_t _shaderInjectionSize = 0;
  static bool usePipelineLayoutCloning = false;
  static bool forcePipelineCloning = false;
  static bool traceUnmodifiedShaders = false;
  static bool allowMultiplePushConstants = false;
  static bool retainDX12LayoutParams = false;
  static float* resourceTagFloat = nullptr;
  static int32_t expectedConstantBufferIndex = -1;
  static uint32_t expectedConstantBufferSpace = 0;

  static CustomShaders _customShaders;
  static bool _usingSwapChainOnly = false;
  static bool _usingBypass = false;
  static bool _usingCountedShaders = false;

  struct __declspec(uuid("018e7b9c-23fd-7863-baf8-a8dad2a6db9d")) DeviceData {
    std::vector<reshade::api::pipeline_layout_param*> createdParams;
    std::unordered_map<uint64_t, int32_t> moddedPipelineRootIndexes;
    std::unordered_map<uint64_t, reshade::api::pipeline_layout> moddedPipelineLayouts;
    std::unordered_set<uint32_t> unmodifiedShaders;
    std::unordered_set<uint64_t> backBuffers;
    std::unordered_set<uint64_t> backBufferResourceViews;
    std::unordered_map<uint32_t, uint32_t> countedShaders;
    bool usePipelineLayoutCloning = false;
    // bool forcePipelineCloning = false;
    bool traceUnmodifiedShaders = false;
    int32_t expectedConstantBufferIndex = -1;
    uint32_t expectedConstantBufferSpace = 0;
    std::shared_mutex mutex;

    CustomShaders customShaders;
  };

  static void on_init_device(reshade::api::device* device) {
    std::stringstream s;
    s << "init_device("
      << reinterpret_cast<void*>(device)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());

    auto &data = device->create_private_data<DeviceData>();
    data.usePipelineLayoutCloning = usePipelineLayoutCloning;
    data.traceUnmodifiedShaders = traceUnmodifiedShaders;
    data.expectedConstantBufferIndex = expectedConstantBufferIndex;
    data.expectedConstantBufferSpace = expectedConstantBufferSpace;
    data.customShaders = _customShaders;
  }

  static void on_destroy_device(reshade::api::device* device) {
    std::stringstream s;
    s << "destroy_device("
      << reinterpret_cast<void*>(device)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    device->destroy_private_data<DeviceData>();
  }

  // Shader Injection
  static bool on_create_pipeline_layout(
    reshade::api::device* device,
    uint32_t &param_count,
    reshade::api::pipeline_layout_param*&params
  ) {
    uint32_t cbvIndex = 0;
    uint32_t pcCount = 0;
    if (param_count == -1) {
      std::stringstream s;
      s << "on_create_pipeline_layout("
        << "Wrong param count: " << param_count
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
      return false;
    }

    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);

    for (uint32_t paramIndex = 0; paramIndex < param_count; ++paramIndex) {
      auto param = params[paramIndex];
      if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
        for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
          auto range = param.descriptor_table.ranges[rangeIndex];
          if (range.type == reshade::api::descriptor_type::constant_buffer) {
            if (
              range.dx_register_space == data.expectedConstantBufferSpace
              && cbvIndex < range.dx_register_index + range.count
            ) {
              cbvIndex = range.dx_register_index + range.count;
            }
          }
        }
      } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
        pcCount++;
        if (
          param.push_constants.dx_register_space == data.expectedConstantBufferSpace
          && cbvIndex < param.push_constants.dx_register_index + param.push_constants.count
        ) {
          cbvIndex = param.push_constants.dx_register_index + param.push_constants.count;
        }
      } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
        if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
          if (
            param.push_descriptors.dx_register_space == data.expectedConstantBufferSpace
            && cbvIndex < param.push_descriptors.dx_register_index + param.push_descriptors.count
          ) {
            cbvIndex = param.push_descriptors.dx_register_index + param.push_descriptors.count;
          }
        }
#if RESHADE_API_VERSION >= 13
      } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers) {
        for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table_with_static_samplers.count; ++rangeIndex) {
          auto range = param.descriptor_table_with_static_samplers.ranges[rangeIndex];
          if (range.static_samplers != nullptr) {
            if (range.type == reshade::api::descriptor_type::constant_buffer) {
              if (
                range.dx_register_space == data.expectedConstantBufferSpace
                && cbvIndex < range.dx_register_index + range.count
              ) {
                cbvIndex = range.dx_register_index + range.count;
              }
            }
          }
        }
#endif
      }
    }

    if (data.expectedConstantBufferIndex != -1 && cbvIndex != data.expectedConstantBufferIndex) {
      std::stringstream s;
      s << "on_create_pipeline_layout("
        << "Pipeline layout index mismatch, actual: " << cbvIndex
        << ", expected: " << data.expectedConstantBufferIndex
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
      return false;
    }

    if (pcCount != 0 && !allowMultiplePushConstants) {
      std::stringstream s;
      s << "on_create_pipeline_layout("
        << "Pipeline layout already has push constants: " << pcCount
        << " with cbvIndex: " << cbvIndex
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      return false;
    }

    uint32_t oldCount = param_count;
    uint32_t newCount = oldCount + 1;
    reshade::api::pipeline_layout_param* newParams = new reshade::api::pipeline_layout_param[newCount];

    // Store reference to free later
    data.createdParams.push_back(newParams);

    // Copy up to size of old
    memcpy(newParams, params, sizeof(reshade::api::pipeline_layout_param) * oldCount);

    // Fill in extra param
    uint32_t slots = _shaderInjectionSize;
    uint32_t maxCount = 64u - (oldCount + 1u) + 1u;
    newParams[oldCount].type = reshade::api::pipeline_layout_param_type::push_constants;
    newParams[oldCount].push_constants.binding = 0;
    newParams[oldCount].push_constants.count = (slots > maxCount) ? maxCount : slots;
    newParams[oldCount].push_constants.dx_register_index = cbvIndex;
    newParams[oldCount].push_constants.dx_register_space = data.expectedConstantBufferSpace;
    newParams[oldCount].push_constants.visibility = reshade::api::shader_stage::all;

    param_count = newCount;
    params = newParams;

    if (slots > maxCount) {
      std::stringstream s;
      s << "on_create_pipeline_layout("
        << "shader injection oversized: "
        << slots << "/" << maxCount
        << " )";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
    }

    std::stringstream s;
    s << "on_create_pipeline_layout("
      << "will insert cbuffer " << cbvIndex
      << " at root_index " << oldCount
      << " with slot count " << slots
      << " creating new size of " << (oldCount + 1u + slots)
      << " )";
    reshade::log_message(reshade::log_level::info, s.str().c_str());

    return true;
  }

  // AfterCreateRootSignature
  static void on_init_pipeline_layout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout
  ) {
    int32_t injectionIndex = -1;
    auto device_api = device->get_api();
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    uint32_t cbvIndex = 0;
    for (uint32_t paramIndex = 0; paramIndex < param_count; paramIndex++) {
      auto param = params[paramIndex];
      if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
        for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
          auto range = param.descriptor_table.ranges[rangeIndex];
          if (range.type == reshade::api::descriptor_type::constant_buffer) {
            if (
              range.dx_register_space == data.expectedConstantBufferSpace
              && cbvIndex < range.dx_register_index + range.count
            ) {
              cbvIndex = range.dx_register_index + range.count;
            }
          }
        }
      } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
        if (
          param.push_constants.dx_register_space == data.expectedConstantBufferSpace
          && cbvIndex < param.push_constants.dx_register_index + param.push_constants.count
        ) {
          cbvIndex = param.push_constants.dx_register_index + param.push_constants.count;
        }
      } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
        if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
          if (
            param.push_descriptors.dx_register_space == data.expectedConstantBufferSpace
            && cbvIndex < param.push_descriptors.dx_register_index + param.push_descriptors.count
          ) {
            cbvIndex = param.push_descriptors.dx_register_index + param.push_descriptors.count;
          }
        }
      }
    }
    if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
      if (data.usePipelineLayoutCloning) {
        uint32_t oldCount = param_count;
        uint32_t newCount = oldCount;
        reshade::api::pipeline_layout_param* newParams = nullptr;
        if (_shaderInjectionSize) {
          newCount = oldCount + 1;
          newParams = new reshade::api::pipeline_layout_param[newCount];
          memcpy(newParams, params, sizeof(reshade::api::pipeline_layout_param) * oldCount);

          uint32_t slots = _shaderInjectionSize;
          uint32_t maxCount = 64u - (oldCount + 1u) + 1u;
          newParams[oldCount].type = reshade::api::pipeline_layout_param_type::push_constants;
          newParams[oldCount].push_constants.binding = 0;
          newParams[oldCount].push_constants.count = (slots > maxCount) ? maxCount : slots;
          newParams[oldCount].push_constants.dx_register_index = cbvIndex;
          newParams[oldCount].push_constants.dx_register_space = data.expectedConstantBufferSpace;
          newParams[oldCount].push_constants.visibility = reshade::api::shader_stage::all;

          injectionIndex = oldCount;

          if (slots > maxCount) {
            std::stringstream s;
            s << "on_init_pipeline_layout("
              << reinterpret_cast<void*>(layout.handle)
              << "shader injection oversized: "
              << slots << "/" << maxCount
              << " )";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
            free(newParams);
            return;
          }
        } else {
          newParams = new reshade::api::pipeline_layout_param[newCount];
          memcpy(newParams, params, sizeof(reshade::api::pipeline_layout_param) * oldCount);
        }

        reshade::api::pipeline_layout newLayout;
        auto result = device->create_pipeline_layout(newCount, &newParams[0], &newLayout);
        free(newParams);
        std::stringstream s;
        s << "on_init_pipeline_layout(Cloning D3D12 Layout "
          << reinterpret_cast<void*>(layout.handle)
          << " => "
          << reinterpret_cast<void*>(newLayout.handle)
          << ", cbvIndex: " << cbvIndex
          << ", paramIndex: " << injectionIndex
          << ", slots : " << _shaderInjectionSize
          << ": " << (result ? "OK" : "FAILED")
          << ")";
        reshade::log_message(result ? reshade::log_level::info : reshade::log_level::error, s.str().c_str());
        data.moddedPipelineLayouts[layout.handle] = newLayout;
      } else {
        if (!data.createdParams.size()) {
          // No injected params
          std::stringstream s;
          s << "on_init_pipeline_layout++("
            << "Params not created for: "
            << reinterpret_cast<void*>(layout.handle)
            << ")";
          reshade::log_message(reshade::log_level::warning, s.str().c_str());
          return;
        };
        if (!retainDX12LayoutParams) {
          for (auto injectedParams : data.createdParams) {
            free(injectedParams);
          }
        }
        data.createdParams.clear();

        if (param_count > 0) {
          if (params[param_count - 1].type == reshade::api::pipeline_layout_param_type::push_constants) {
            injectionIndex = param_count - 1;
          }
        }
        if (injectionIndex == -1) {
          std::stringstream s;
          s << "on_init_pipeline_layout++("
            << "Injection index not found for "
            << reinterpret_cast<void*>(layout.handle)
            << " )";
          reshade::log_message(reshade::log_level::warning, s.str().c_str());
          return;
        }
      }

    } else {
      if (data.expectedConstantBufferIndex != -1 && cbvIndex != data.expectedConstantBufferIndex) {
        std::stringstream s;
        s << "on_init_pipeline_layout("
          << "Forcing cbuffer index "
          << reinterpret_cast<void*>(layout.handle)
          << ": " << cbvIndex
          << " )";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        cbvIndex = data.expectedConstantBufferIndex;
      }
      if (cbvIndex == 14) {
        cbvIndex = 13;
        std::stringstream s;
        s << "on_init_pipeline_layout("
          << "Using last slot for buffer injection "
          << reinterpret_cast<void*>(layout.handle)
          << ": " << cbvIndex
          << " )";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
      }

      // device->create_pipeline_layout(1)

      reshade::api::pipeline_layout_param newParams;
      newParams.type = reshade::api::pipeline_layout_param_type::push_constants;
      //newParams.push_constants.binding = 0;
      newParams.push_constants.count = 1;
      newParams.push_constants.dx_register_index = cbvIndex;
      newParams.push_constants.dx_register_space = data.expectedConstantBufferSpace;
      newParams.push_constants.visibility = reshade::api::shader_stage::all;

      reshade::api::pipeline_layout newLayout;
      auto result = device->create_pipeline_layout(1, &newParams, &newLayout);
      std::stringstream s;
      s << "on_init_pipeline_layout("
        << "Creating D3D11 Layout "
        << reinterpret_cast<void*>(newLayout.handle)
        << ": " << result
        << " )";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      data.moddedPipelineLayouts[layout.handle] = newLayout;
      injectionIndex = cbvIndex;
    }

    data.moddedPipelineRootIndexes[layout.handle] = injectionIndex;

    std::stringstream s;
    s << "on_init_pipeline_layout("
      << "Using injection index for "
      << reinterpret_cast<void*>(layout.handle)
      << ": " << injectionIndex
      << ", cbvIndex:" << cbvIndex
      << " )";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  static void on_destroy_pipeline_layout(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout
  ) {
    uint32_t changed = false;
    auto &data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    changed |= data.moddedPipelineRootIndexes.erase(layout.handle);
    if (!changed) return;

    std::stringstream s;
    s << "on_destroy_pipeline_layout(";
    s << reinterpret_cast<void*>(layout.handle);
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  void on_push_constants(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    uint32_t first,
    uint32_t count,
    const void* values
  ) {
    auto &data = cmd_list->get_device()->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    auto pair = data.moddedPipelineLayouts.find(layout.handle);
    if (pair == data.moddedPipelineLayouts.end()) return;
    auto clonedLayout = pair->second;

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "push_constants(clone push "
      << reinterpret_cast<void*>(layout.handle)
      << " => " << reinterpret_cast<void*>(clonedLayout.handle)
      << ", param: " << layout_param
      << ", first: " << first
      << ", count: " << count
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif

    cmd_list->push_constants(stages, clonedLayout, layout_param, first, count, values);
  }

  void on_push_descriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update &update
  ) {
    auto &data = cmd_list->get_device()->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    auto pair = data.moddedPipelineLayouts.find(layout.handle);
    if (pair == data.moddedPipelineLayouts.end()) return;
    auto clonedLayout = pair->second;

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "push_descriptors(clone push "
      << reinterpret_cast<void*>(layout.handle)
      << " => " << reinterpret_cast<void*>(clonedLayout.handle)
      << ", param: " << layout_param
      << ", table: " << reinterpret_cast<void*>(update.table.handle)
      << ", binding: " << update.binding
      << ", array_offset: " << update.array_offset
      << ", count: " << update.count
      << ", type: " << to_string(update.type);
    switch (update.type) {
      case reshade::api::descriptor_type::constant_buffer:
        {
          reshade::api::buffer_range* range = (reshade::api::buffer_range*)update.descriptors;
          s << ", buffer: " << reinterpret_cast<void*>(range->buffer.handle);
          s << ", offset: " << range->offset;
          s << ", size: " << range->size;
        }
        break;
      default:
        break;
    }
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
    cmd_list->push_descriptors(stages, clonedLayout, layout_param, update);
  }

  void on_bind_descriptor_tables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables
  ) {
    auto &data = cmd_list->get_device()->get_private_data<DeviceData>();
    auto pair = data.moddedPipelineLayouts.find(layout.handle);
    if (pair == data.moddedPipelineLayouts.end()) return;
    auto clonedLayout = pair->second;

    for (uint32_t i = 0; i < count; ++i) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "bind_descriptor_tables(clone bind "
        << reinterpret_cast<void*>(layout.handle)
        << " => " << reinterpret_cast<void*>(clonedLayout.handle)
        << ", stages: 0x" << std::hex << (uint32_t)stages << std::dec << " (" << to_string(stages) << ")"
        << ", param: " << first + i
        << ", table: " << reinterpret_cast<void*>(tables[i].handle)
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
      cmd_list->bind_descriptor_table(stages, clonedLayout, (first + i), tables[i]);
    }
  }

  static bool handlePreDraw(reshade::api::command_list* cmd_list, bool isDispatch = false) {
    auto device = cmd_list->get_device();
    auto &device_data = device->get_private_data<DeviceData>();
    std::unique_lock localDeviceLock(device_data.mutex);

    ShaderUtil::CommandListData &shaderState = cmd_list->get_private_data<ShaderUtil::CommandListData>();

    float resourceTag = -1;

    if (!isDispatch && resourceTagFloat != nullptr) {
      SwapchainUtil::CommandListData &swapchainState = cmd_list->get_private_data<SwapchainUtil::CommandListData>();
      if (swapchainState.currentRenderTargets.size() != 0) {
        auto rv = swapchainState.currentRenderTargets.at(0);
        resourceTag = ResourceUtil::getResourceTag(device, rv);
      }
    }

    auto customShaderInfoPair = device_data.customShaders.find(shaderState.currentShaderHash);
    if (customShaderInfoPair == device_data.customShaders.end()) {
      // Unrecognized shader

      if (
        device_data.traceUnmodifiedShaders
        && SwapchainUtil::hasBackBufferRenderTarget(cmd_list)
        && !device_data.unmodifiedShaders.contains(shaderState.currentShaderHash)
        && !device_data.customShaders.contains(shaderState.currentShaderHash)
      ) {
        std::stringstream s;
        s << "handlePreDraw(unmodified shader writing to swapchain: "
          << PRINT_CRC32(shaderState.currentShaderHash)
          << ")";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        device_data.unmodifiedShaders.emplace(shaderState.currentShaderHash);
      }
      return false;
    }

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "handlePreDraw(found shader: "
      << PRINT_CRC32(shaderHash)
      << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

    auto customShaderInfo = customShaderInfoPair->second;

    if (customShaderInfo.swapChainOnly && !SwapchainUtil::hasBackBufferRenderTarget(cmd_list)) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "handlePreDraw(aborting because swapchain only: "
        << PRINT_CRC32(shaderHash)
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      return false;
    }

    ShaderUtil::DeviceData &shaderDeviceState = device->get_private_data<ShaderUtil::DeviceData>();
    std::shared_lock shaderDeviceLock(shaderDeviceState.mutex);

    if (_shaderInjectionSize != 0) {
      if (
        auto pair = shaderDeviceState.pipelineToLayoutMap.find(shaderState.currentShaderPipeline.handle);
        pair != shaderDeviceState.pipelineToLayoutMap.end()
      ) {
        reshade::api::pipeline_layout layout = {pair->second};
        auto injectionLayout = layout;
        auto device_api = device->get_api();
        reshade::api::shader_stage stage = reshade::api::shader_stage::all_graphics;
        uint32_t paramIndex = 0;
        if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
          if (
            auto pair = device_data.moddedPipelineRootIndexes.find(layout.handle);
            pair != device_data.moddedPipelineRootIndexes.end()
          ) {
            paramIndex = pair->second;
            stage = shaderDeviceState.computeShaderLayouts.contains(layout.handle)
                    ? reshade::api::shader_stage::all_compute
                    : reshade::api::shader_stage::all_graphics;
          } else {
            std::stringstream s;
            s << "handlePreDraw(did not find modded pipeline root index"
              << ", pipeline: " << reinterpret_cast<void*>(shaderState.currentShaderPipeline.handle)
              << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
            return false;
          }

        } else {
          // Must be done before draw
          stage = (shaderState.currentShaderPipelineStage == reshade::api::pipeline_stage::compute_shader)
                  ? reshade::api::shader_stage::compute
                  : reshade::api::shader_stage::pixel;

          if (
            auto pair = device_data.moddedPipelineLayouts.find(layout.handle);
            pair != device_data.moddedPipelineLayouts.end()
          ) {
            injectionLayout = pair->second;
          } else {
            std::stringstream s;
            s << "handlePreDraw(did not find modded pipeline layout"
              << ", pipeline: " << reinterpret_cast<void*>(shaderState.currentShaderPipeline.handle)
              << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
            return false;
          }
        }

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "handlePreDraw(pushing constants: "
          << PRINT_CRC32(shaderHash)
          << ", layout: " << (void*)injectionLayout.handle << "[" << paramIndex << "]"
          << ", stage: " << to_string(stage)
          << ", data: " << (void*)_shaderInjection
          << ", resourceTag: " << resourceTag
          << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

        if (resourceTagFloat != nullptr) {
          std::unique_lock lock(MutexUtil::g_mutex0);
          *resourceTagFloat = resourceTag;
        }

        std::shared_lock lock(MutexUtil::g_mutex0);
        cmd_list->push_constants(
          stage,  // Used by reshade to specify graphics or compute
          injectionLayout,
          paramIndex,
          0,
          _shaderInjectionSize,
          _shaderInjection
        );
      }
    }

    // perform bind pipeline (replace shader)

    if (
      auto pair = shaderDeviceState.pipelineToPipelineReplacement.find(shaderState.currentShaderPipeline.handle);
      pair != shaderDeviceState.pipelineToPipelineReplacement.end()
    ) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "handlePreDraw(binding pipeline: "
        << PRINT_CRC32(shaderHash)
        << ", stage: " << to_string(currentShaderPipelineStage)
        << ", handle: " << (void*)pair->second
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      cmd_list->bind_pipeline(shaderState.currentShaderPipelineStage, {pair->second});
      // has replacemnt that can be bound;
    }

    return false;
  }

  static bool on_draw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance
  ) {
    return handlePreDraw(cmd_list);
  }

  static bool on_dispatch(
    reshade::api::command_list* cmd_list,
    uint32_t group_count_x,
    uint32_t group_count_y,
    uint32_t group_count_z
  ) {
    return handlePreDraw(cmd_list, true);
  }

  static bool on_draw_indexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance
  ) {
    return handlePreDraw(cmd_list);
  }

  static bool on_draw_or_dispatch_indirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride
  ) {
    return handlePreDraw(cmd_list);
  }

  static void on_present(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects
  ) {
    auto &data = swapchain->get_device()->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    data.countedShaders.clear();
  }

  static bool attached = false;

  template <typename T = float*>
  static void use(DWORD fdwReason, CustomShaders customShaders, T* injections = nullptr) {
    ShaderUtil::use(fdwReason);
    SwapchainUtil::use(fdwReason);
    ResourceUtil::use(fdwReason);

    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        if (attached) return;
        attached = true;
        reshade::log_message(reshade::log_level::info, "ShaderReplaceMod attached.");

        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);

        if (!traceUnmodifiedShaders) {
          for (const auto &[hash, shader] : (customShaders)) {
            if (shader.swapChainOnly) _usingSwapChainOnly = true;
            if (shader.codeSize == 0) _usingBypass = true;
            if (shader.index != -1) _usingCountedShaders = true;
          }
        }

        if (_usingCountedShaders) {
          reshade::register_event<reshade::addon_event::present>(on_present);
        }

        if (forcePipelineCloning || usePipelineLayoutCloning) {
          for (const auto &[hash, shader] : (customShaders)) {
            ShaderUtil::addInitPipelineReplacement(hash, shader.codeSize, (void*)shader.code);
          }
        } else {
          for (const auto &[hash, shader] : (customShaders)) {
            if (!shader.swapChainOnly && shader.codeSize && shader.index == -1) {
              ShaderUtil::addCreatePipelineReplacement(hash, shader.codeSize, (void*)shader.code);
            }
            // Use Init as fallback
            ShaderUtil::addInitPipelineReplacement(hash, shader.codeSize, (void*)shader.code);
          }
        }

        reshade::register_event<reshade::addon_event::draw>(on_draw);
        reshade::register_event<reshade::addon_event::dispatch>(on_dispatch);
        reshade::register_event<reshade::addon_event::draw_indexed>(on_draw_indexed);
        reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(on_draw_or_dispatch_indirect);

        _customShaders = customShaders;
        {
          std::stringstream s;
          s << "Attached Custom Shaders: " << _customShaders.size()
            << " from " << (void*)&customShaders
            << " to " << (void*)&_customShaders;
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }

        if (usePipelineLayoutCloning || (injections != nullptr)) {
          if (injections != nullptr) {
            _shaderInjectionSize = sizeof(T) / sizeof(uint32_t);
            _shaderInjection = reinterpret_cast<float*>(injections);
          }

          if (!usePipelineLayoutCloning) {
            reshade::register_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
          }

          reshade::register_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
          reshade::register_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

          if (usePipelineLayoutCloning) {
            reshade::register_event<reshade::addon_event::push_constants>(on_push_constants);
            reshade::register_event<reshade::addon_event::push_descriptors>(on_push_descriptors);
            reshade::register_event<reshade::addon_event::bind_descriptor_tables>(on_bind_descriptor_tables);
          }

          std::stringstream s;
          s << "Attached Injections: " << _shaderInjectionSize
            << " at " << (void*)_shaderInjection;
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }

        break;
      case DLL_PROCESS_DETACH:

        reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
        reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);

        reshade::unregister_event<reshade::addon_event::draw>(on_draw);
        reshade::unregister_event<reshade::addon_event::dispatch>(on_dispatch);
        reshade::unregister_event<reshade::addon_event::draw_indexed>(on_draw_indexed);
        reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(on_draw_or_dispatch_indirect);

        reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);

        reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
        reshade::unregister_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

        reshade::unregister_event<reshade::addon_event::push_constants>(on_push_constants);
        reshade::unregister_event<reshade::addon_event::push_descriptors>(on_push_descriptors);
        reshade::unregister_event<reshade::addon_event::bind_descriptor_tables>(on_bind_descriptor_tables);

        break;
    }
  }
}  // namespace ShaderReplaceMod
