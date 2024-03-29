/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#define DEBUG_LEVEL_0

#include <atlbase.h>
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

#include "./format.hpp"

namespace ShaderReplaceMod {
  struct CustomShader {
    uint32_t crc32;
    const uint8_t* code;
    uint32_t codeSize;
  };

  typedef std::unordered_map<uint32_t, CustomShader> CustomShaders;

  // clang-format off
#define CustomShaderEntry(crc32) { crc32, { crc32, _##crc32, sizeof(_##crc32) } }
#define BypassShaderEntry(crc32) { crc32, { crc32, nullptr, 0 } }
  // clang-format on

  static float* _shaderInjection = nullptr;
  static size_t _shaderInjectionSize = 0;
  static bool usePipelineLayoutCloning = false;
  static int32_t expectedConstantBufferIndex = -1;

  static CustomShaders* _customShaders = nullptr;

  struct __declspec(uuid("018e7b9c-23fd-7863-baf8-a8dad2a6db9d")) device_data {
    std::vector<reshade::api::pipeline_layout_param*> createdParams;
    std::unordered_map<uint32_t, uint32_t> codeInjections;
    std::unordered_set<uint64_t> trackedLayouts;
    std::unordered_set<uint64_t> computeShaderLayouts;
    std::unordered_map<uint64_t, reshade::api::pipeline_layout> pipelineToLayoutMap;
    std::unordered_map<uint64_t, reshade::api::pipeline> pipelineCloneMap;
    std::unordered_map<uint64_t, int32_t> moddedPipelineRootIndexes;
    std::unordered_map<uint64_t, reshade::api::pipeline_layout> moddedPipelineLayouts;
    std::unordered_map<uint64_t, uint32_t> pipelineToShaderHashMap;
    std::unordered_set<uint32_t> bypassedShaders;
    uint32_t currentShader;
  };

  static void on_init_device(reshade::api::device* device) {
    std::stringstream s;
    s << "init_device("
      << reinterpret_cast<void*>(device->get_native())
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    device->create_private_data<device_data>();
  }

  static void on_destroy_device(reshade::api::device* device) {
    std::stringstream s;
    s << "destroy_device("
      << reinterpret_cast<void*>(device->get_native())
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    device->destroy_private_data<device_data>();
  }

  // Before CreatePipelineState
  static bool on_create_pipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects
  ) {
    bool replaced_stages = false;
    const reshade::api::device_api device_type = device->get_api();
    auto &data = device->get_private_data<device_data>();

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

      const auto pair = _customShaders->find(shader_hash);
      if (pair == _customShaders->end()) continue;
      const auto customShader = pair->second;

      desc->code = customShader.code;
      desc->code_size = customShader.codeSize;

      if (customShader.codeSize) {
        uint32_t new_hash = compute_crc32(
          static_cast<const uint8_t*>(desc->code),
          desc->code_size
        );
        data.codeInjections.emplace(new_hash, shader_hash);
#ifdef DEBUG_LEVEL_0
        std::stringstream s;
        s << "create_pipeline(replace shader "
          << "0x" << std::hex << shader_hash << std::dec
          << " => "
          << "0x" << std::hex << new_hash << std::dec
          << " - " << desc->code_size << " bytes"
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif

      } else {
        data.codeInjections.emplace(shader_hash, shader_hash);
        data.bypassedShaders.emplace(shader_hash);
#ifdef DEBUG_LEVEL_0
        std::stringstream s;
        s << "create_pipeline(bypass shader"
          << "0x" << std::hex << shader_hash << std::dec
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
      }
      replaced_stages = true;
    }

    return replaced_stages;
  }

  // Shader Injection
  static bool on_create_pipeline_layout(
    reshade::api::device* device,
    uint32_t &param_count,
    reshade::api::pipeline_layout_param*&params
  ) {
    uint32_t cbvIndex = 0;
    uint32_t pcCount = 0;

    for (uint32_t paramIndex = 0; paramIndex < param_count; ++paramIndex) {
      auto param = params[paramIndex];
      if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
        for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
          auto range = param.descriptor_table.ranges[rangeIndex];
          if (range.type == reshade::api::descriptor_type::constant_buffer) {
            if (cbvIndex < range.dx_register_index + range.count) {
              cbvIndex = range.dx_register_index + range.count;
            }
          }
        }
      } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
        pcCount++;
        if (cbvIndex < param.push_constants.dx_register_index + param.push_constants.count) {
          cbvIndex = param.push_constants.dx_register_index + param.push_constants.count;
        }
      } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
        if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
          if (cbvIndex < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
            cbvIndex = param.push_descriptors.dx_register_index + param.push_descriptors.count;
          }
        }
      }
    }

    if (expectedConstantBufferIndex != -1 && cbvIndex != expectedConstantBufferIndex) {
      std::stringstream s;
      s << "on_create_pipeline_layout("
        << "Pipeline layout index mismatch, actual: " << cbvIndex
        << ", expected: " << expectedConstantBufferIndex
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
      return false;
    }

    if (pcCount != 0) {
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
    auto &data = device->get_private_data<device_data>();
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
    newParams[oldCount].push_constants.dx_register_space = 0;
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
      << "will insert"
      << " cbuffer " << cbvIndex
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
    auto &data = device->get_private_data<device_data>();
    uint32_t cbvIndex = 0;
    for (uint32_t paramIndex = 0; paramIndex < param_count; paramIndex++) {
      auto param = params[paramIndex];
      if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
        for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
          auto range = param.descriptor_table.ranges[rangeIndex];
          if (range.type == reshade::api::descriptor_type::constant_buffer) {
            if (cbvIndex < range.dx_register_index + range.count) {
              cbvIndex = range.dx_register_index + range.count;
            }
          }
        }
      } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
        if (cbvIndex < param.push_constants.dx_register_index + param.push_constants.count) {
          cbvIndex = param.push_constants.dx_register_index + param.push_constants.count;
        }
      } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
        if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
          if (cbvIndex < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
            cbvIndex = param.push_descriptors.dx_register_index + param.push_descriptors.count;
          }
        }
      }
    }
    if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
      if (usePipelineLayoutCloning) {
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
          newParams[oldCount].push_constants.dx_register_space = 0;
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
        data.moddedPipelineLayouts.emplace(layout.handle, newLayout);
      } else {
        if (!data.createdParams.size()) return;  // No injected params
        for (auto injectedParams : data.createdParams) {
          free(injectedParams);
        }
        data.createdParams.clear();

        for (uint32_t paramIndex = 0; paramIndex < param_count; ++paramIndex) {
          auto param = params[paramIndex];
          if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
            if (param.push_constants.count == _shaderInjectionSize) {
              injectionIndex = paramIndex;
            }
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
      if (expectedConstantBufferIndex != -1 && cbvIndex != expectedConstantBufferIndex) {
        std::stringstream s;
        s << "on_init_pipeline_layout("
          << "Forcing cbuffer index "
          << reinterpret_cast<void*>(layout.handle)
          << ": " << cbvIndex
          << " )";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        cbvIndex = expectedConstantBufferIndex;
      }
      if (cbvIndex == 14) {
        std::stringstream s;
        s << "on_init_pipeline_layout("
          << "Using last slot for buffer injection "
          << reinterpret_cast<void*>(layout.handle)
          << ": " << cbvIndex
          << " )";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        cbvIndex = 13;
      }

      // device->create_pipeline_layout(1)

      reshade::api::pipeline_layout_param newParams;
      newParams.type = reshade::api::pipeline_layout_param_type::push_constants;
      //newParams.push_constants.binding = 0;
      newParams.push_constants.count = 1;
      newParams.push_constants.dx_register_index = cbvIndex;
      newParams.push_constants.dx_register_space = 0;
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
      data.moddedPipelineLayouts.emplace(layout.handle, newLayout);
      injectionIndex = cbvIndex;
    }

    data.moddedPipelineRootIndexes.emplace(layout.handle, injectionIndex);

    std::stringstream s;
    s << "on_init_pipeline_layout("
      << "Using injection index for "
      << reinterpret_cast<void*>(layout.handle)
      << ": " << injectionIndex
      << " )";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  static void on_destroy_pipeline_layout(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout
  ) {
    uint32_t changed = false;
    auto &data = device->get_private_data<device_data>();
    changed |= data.moddedPipelineRootIndexes.erase(layout.handle);
    if (!changed) return;

    std::stringstream s;
    s << "on_destroy_pipeline_layout(";
    s << reinterpret_cast<void*>(layout.handle);
    s << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  // After CreatePipelineState
  static void on_init_pipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobjectCount,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline
  ) {
    // DX12 can use PSO objects that need to be cloned
    reshade::api::pipeline_subobject* newSubobjects = nullptr;

    auto &data = device->get_private_data<device_data>();
    bool needsClone = false;
    bool foundComputeShader = false;
    uint32_t foundInjection = 0;
    for (uint32_t i = 0; i < subobjectCount; ++i) {
      const auto subobject = subobjects[i];
      switch (subobject.type) {
        // case reshade::api::pipeline_subobject_type::render_target_formats:
        //   {
        //     const reshade::api::format* formats = (reshade::api::format*)subobject.data;
        //     for (uint32_t j = 0; j < subobject.count; j++) {
        //       auto format = formats[j];
        //       std::stringstream s;
        //       s << "on_init_pipeline(found format:"
        //         << (uint32_t)format << "(" << to_string(format) << ")"
        //         << ") [" << j << "/" << subobject.count << "]";
        //       reshade::log_message(reshade::log_level::info, s.str().c_str());
        //       if (format == reshade::api::format::r10g10b10a2_unorm) {
        //         if (!needsClone) {
        //           newSubobjects = new reshade::api::pipeline_subobject[subobjectCount];
        //           memcpy(newSubobjects, subobjects, sizeof(reshade::api::pipeline_subobject) * subobjectCount);
        //           needsClone = true;
        //         }
        //         auto cloneSubject = &newSubobjects[i];
        //         const auto cloneFormats = static_cast<reshade::api::format*>(cloneSubject->data);
        //         cloneFormats[j] = reshade::api::format::r16g16b16a16_float;
        //         reshade::log_message(reshade::log_level::info, "on_init_pipeline(changed format)");
        //       }
        //     }
        //   }
        //   continue;
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
      auto shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);

      auto codeInjectionPair = data.codeInjections.find(shader_hash);
      if (codeInjectionPair != data.codeInjections.end()) {
        foundInjection = codeInjectionPair->second;
      } else {
        const auto pair = _customShaders->find(shader_hash);
        if (pair != _customShaders->end()) {
          foundInjection = shader_hash;
          const auto customShader = pair->second;

          if (!needsClone) {
            newSubobjects = new reshade::api::pipeline_subobject[subobjectCount];
            memcpy(newSubobjects, subobjects, sizeof(reshade::api::pipeline_subobject) * subobjectCount);
            needsClone = true;
          }
          auto cloneSubject = &newSubobjects[i];

          auto newDesc = static_cast<reshade::api::shader_desc*>(cloneSubject->data);

          std::stringstream s;
          if (customShader.codeSize) {
            newDesc->code = customShader.code;
            newDesc->code_size = customShader.codeSize;
            s << "on_init_pipeline(injecting shader:";
          } else {
            data.bypassedShaders.emplace(shader_hash);
            s << "on_init_pipeline(bypassing shader:";
          }
          s << std::hex << shader_hash << std::dec
            << ", layout: " << reinterpret_cast<void*>(layout.handle)
            << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle)
            << ")";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
      }
    }
    if (usePipelineLayoutCloning && !needsClone) {
      newSubobjects = new reshade::api::pipeline_subobject[subobjectCount];
      memcpy(newSubobjects, subobjects, sizeof(reshade::api::pipeline_subobject) * subobjectCount);
      needsClone = true;
    }
    if (!foundInjection && !needsClone) return;
    if (foundInjection) {
      data.pipelineToShaderHashMap.emplace(pipeline.handle, foundInjection);
    }
    data.pipelineToLayoutMap.emplace(pipeline.handle, layout);
    if (foundComputeShader) {
      data.computeShaderLayouts.emplace(layout.handle);
    }
    if (needsClone) {
      reshade::api::pipeline newPipeline;
      reshade::api::pipeline_layout cloneLayout = layout;

      if (usePipelineLayoutCloning) {
        auto device_api = device->get_api();
        if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
          auto pair3 = data.moddedPipelineLayouts.find(layout.handle);
          if (pair3 != data.moddedPipelineLayouts.end()) {
            cloneLayout = pair3->second;
          }
        }
      }

      bool builtPipelineOK = device->create_pipeline(cloneLayout, subobjectCount, &newSubobjects[0], &newPipeline);
      if (builtPipelineOK) {
        data.pipelineCloneMap.emplace(pipeline.handle, newPipeline);
        data.pipelineToLayoutMap.emplace(newPipeline.handle, cloneLayout);
        data.pipelineToShaderHashMap.emplace(newPipeline.handle, foundInjection);
      }
      // free(newSubobjects);
      std::stringstream s;
      s << "init_pipeline(cloned "
        << reinterpret_cast<void*>(pipeline.handle)
        << " => " << reinterpret_cast<void*>(newPipeline.handle)
        << ", layout: " << reinterpret_cast<void*>(layout.handle)
        << " (" << reinterpret_cast<void*>(cloneLayout.handle) << ")"
        << ", size: " << subobjectCount
        << ", " << (builtPipelineOK ? "OK" : "FAILED!")
        << ")";
      reshade::log_message(
        builtPipelineOK ? reshade::log_level::info : reshade::log_level::error,
        s.str().c_str()
      );
      if (!builtPipelineOK) {
        for (uint32_t i = 0; i < subobjectCount; ++i) {
          const auto subobject = subobjects[i];
          for (uint32_t j = 0; (j < subobject.count) || (subobject.count == 0 && j == 0); j++) {
            std::stringstream s;
            s << "on_init_pipeline(debug:"
              << reinterpret_cast<void*>(pipeline.handle)
              << ", type: " << to_string(subobject.type);
            switch (subobject.type) {
              case reshade::api::pipeline_subobject_type::raygen_shader:
                {
                  if (subobject.data != nullptr) {
                    auto desc = static_cast<const reshade::api::shader_desc*>(subobject.data);
                    s << ", size: " << desc->code_size;
                  } else {
                    s << " (no data)";
                  }
                }
                break;
              case reshade::api::pipeline_subobject_type::primitive_topology:
                {
                  auto topology = *static_cast<const reshade::api::primitive_topology*>(subobject.data);
                  s << ", topology: " << uint32_t(topology);
                }
                break;
              case reshade::api::pipeline_subobject_type::dynamic_pipeline_states:
                {
                  const auto dynamicState = static_cast<const reshade::api::dynamic_state*>(subobject.data)[j];
                  s << ", state: " << uint32_t(dynamicState) << "(" << to_string(dynamicState) << ")";
                }
                break;
              default:
                break;
            }
            s << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
          }
        }
      }
    } else {
      std::stringstream s;
      s << "init_pipeline(injected "
        << reinterpret_cast<void*>(pipeline.handle)
        << ", layout: " << reinterpret_cast<void*>(layout.handle)
        << ", injection: " << std::hex << foundInjection
        << ", compute: " << foundComputeShader
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }

  static void on_destroy_pipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline
  ) {
    uint32_t changed = false;
    auto &data = device->get_private_data<device_data>();
    changed |= data.pipelineToLayoutMap.erase(pipeline.handle);
    changed |= data.computeShaderLayouts.erase(pipeline.handle);
    auto pipelineClonePair = data.pipelineCloneMap.find(pipeline.handle);
    if (pipelineClonePair != data.pipelineCloneMap.end()) {
      data.pipelineCloneMap.erase(pipeline.handle);
      device->destroy_pipeline(pipelineClonePair->second);
      changed = true;
    }
    if (!changed) return;

    std::stringstream s;
    s << "on_destroy_pipeline("
      << reinterpret_cast<void*>(pipeline.handle)
      << " )";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  // AfterSetPipelineState
  static void on_bind_pipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage type,
    reshade::api::pipeline pipeline
  ) {
    auto device = cmd_list->get_device();
    auto &data = device->get_private_data<device_data>();
    auto pipelineToShaderHashPair = data.pipelineToShaderHashMap.find(pipeline.handle);
    if (pipelineToShaderHashPair != data.pipelineToShaderHashMap.end()) {
      data.currentShader = pipelineToShaderHashPair->second;
    } else {
      data.currentShader = 0;
    }

    if (usePipelineLayoutCloning || _shaderInjectionSize != 0) {
      auto pair0 = data.pipelineToLayoutMap.find(pipeline.handle);
      if (pair0 != data.pipelineToLayoutMap.end()) {
        auto layout = pair0->second;

        auto injectionLayout = layout;
        auto device_api = device->get_api();
        reshade::api::shader_stage stage;
        uint32_t paramIndex = 0;
        if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
          auto pair2 = data.moddedPipelineRootIndexes.find(layout.handle);
          if (pair2 == data.moddedPipelineRootIndexes.end()) {
            std::stringstream s;
            s << "bind_pipeline(did not find modded pipeline root index"
              << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle)
              << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
            return;
          }
          paramIndex = pair2->second;

          stage = data.computeShaderLayouts.count(layout.handle) == 0
                  ? reshade::api::shader_stage::all_graphics
                  : reshade::api::shader_stage::all_compute;

          if (usePipelineLayoutCloning) {
            auto pair3 = data.moddedPipelineLayouts.find(layout.handle);
            if (pair3 == data.moddedPipelineLayouts.end()) {
              std::stringstream s;
              s << "bind_pipeline(did not find modded pipeline layout"
                << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle)
                << ")";
              reshade::log_message(reshade::log_level::warning, s.str().c_str());
              return;
            }
            injectionLayout = pair3->second;
          }
        } else {
          stage = (type == reshade::api::pipeline_stage::compute_shader)
                  ? reshade::api::shader_stage::compute
                  : reshade::api::shader_stage::pixel;
          auto pair3 = data.moddedPipelineLayouts.find(layout.handle);
          if (pair3 == data.moddedPipelineLayouts.end()) {
            std::stringstream s;
            s << "bind_pipeline(did not find modded pipeline layout"
              << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle)
              << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
            return;
          }
          injectionLayout = pair3->second;
        }

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "bind_pipeline(pushing "
          << _shaderInjectionSize << " buffers"
          << " into " << reinterpret_cast<void*>(injectionLayout.handle)
          << "[" << paramIndex << "]"
          << ", pipeline: " << reinterpret_cast<void*>(pipeline.handle)
          << ", stage: " << (uint32_t)stage
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif

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

    auto pipelineToClone = data.pipelineCloneMap.find(pipeline.handle);
    if (pipelineToClone != data.pipelineCloneMap.end()) {
      auto newPipeline = pipelineToClone->second;
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "bind_pipeline(swapping pipeline "
        << reinterpret_cast<void*>(pipeline.handle)
        << " => " << reinterpret_cast<void*>(newPipeline.handle)
        << ", stage: " << std::hex << (uint32_t)type
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
      // Must set pipelinelayout first
      cmd_list->bind_pipeline(type, newPipeline);
      // Safe to call now or write before draw
    }
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
    auto &data = cmd_list->get_device()->get_private_data<device_data>();
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
    auto &data = cmd_list->get_device()->get_private_data<device_data>();
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
    auto &data = cmd_list->get_device()->get_private_data<device_data>();
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

  static bool on_draw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance
  ) {
    auto &data = cmd_list->get_device()->get_private_data<device_data>();
    if (data.bypassedShaders.count(data.currentShader)) return true;
    return false;
  }

  static bool on_dispatch(reshade::api::command_list* cmd_list, uint32_t group_count_x, uint32_t group_count_y, uint32_t group_count_z) {
    auto &data = cmd_list->get_device()->get_private_data<device_data>();
    if (data.bypassedShaders.count(data.currentShader)) return true;
    return false;
  }

  static bool on_draw_indexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance
  ) {
    auto &data = cmd_list->get_device()->get_private_data<device_data>();
    if (data.bypassedShaders.count(data.currentShader)) return true;
    return false;
  }

  static bool on_draw_or_dispatch_indirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride
  ) {
    auto &data = cmd_list->get_device()->get_private_data<device_data>();
    if (data.bypassedShaders.count(data.currentShader)) return true;
    return false;
  }

  template <typename T = float*>
  void use(DWORD fdwReason, CustomShaders* customShaders, T* injections = nullptr) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);

        if (!usePipelineLayoutCloning) {
          reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
        }
        reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
        reshade::register_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

        reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

        reshade::register_event<reshade::addon_event::draw>(on_draw);
        reshade::register_event<reshade::addon_event::dispatch>(on_dispatch);
        reshade::register_event<reshade::addon_event::draw_indexed>(on_draw_indexed);
        reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(on_draw_or_dispatch_indirect);

        if (_customShaders == nullptr) {
          _customShaders = customShaders;
          std::stringstream s;
          s << "Attached Custom Shaders: " << _customShaders->size();
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }

        if (usePipelineLayoutCloning || (injections != nullptr)) {
          if (injections != nullptr) {
            _shaderInjectionSize = sizeof(T) / sizeof(uint32_t);
            _shaderInjection = reinterpret_cast<float*>(injections);
          }
#if RESHADE_API_VERSION >= 11
          if (!usePipelineLayoutCloning) {
            reshade::register_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
          }
#endif
          reshade::register_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
          reshade::register_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

          if (usePipelineLayoutCloning) {
            reshade::register_event<reshade::addon_event::push_constants>(on_push_constants);
            reshade::register_event<reshade::addon_event::push_descriptors>(on_push_descriptors);
            reshade::register_event<reshade::addon_event::bind_descriptor_tables>(on_bind_descriptor_tables);
          }

          std::stringstream s;
          s << "Attached Injections: " << _shaderInjectionSize;
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }

        break;
      case DLL_PROCESS_DETACH:

        reshade::unregister_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
        reshade::unregister_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
        reshade::unregister_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

        reshade::unregister_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);
#if RESHADE_API_VERSION >= 11
        reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
#endif
        reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
        reshade::unregister_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

        break;
    }
  }
}  // namespace ShaderReplaceMod
