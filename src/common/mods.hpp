/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atlbase.h>
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
#include "../../external/reshade/include/reshade.hpp"

namespace swapchainmod {
  std::unordered_set<uint64_t> backBuffers;

  // Before CreatePipelineState
  static bool on_create_swapchain(reshade::api::swapchain_desc &desc, void* hwnd) {
    bool changed = true;
    auto oldFormat = desc.back_buffer.texture.format;
    switch (desc.back_buffer.texture.format) {
      case reshade::api::format::r8g8b8a8_unorm:
      case reshade::api::format::r8g8b8a8_unorm_srgb:
        desc.back_buffer.texture.format = reshade::api::format::r16g16b16a16_float;
        break;
      default:
        changed = false;
    }
    if (!changed) return false;

    if (desc.back_buffer_count < 2) {
      desc.back_buffer_count = 2;
    }

    auto oldPresentMode = desc.present_mode;
    switch (desc.present_mode) {
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_SEQUENTIAL):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL);
        break;
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_DISCARD):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD);
        break;
    }

    std::stringstream s;
    s << "createSwapChain("
      << "swap: "
      << "0x" << std::hex << (uint32_t)oldFormat << std::dec
      << " => "
      << "0x" << std::hex << (uint32_t)desc.back_buffer.texture.format << std::dec
      << ", present:"
      << "0x" << std::hex << (uint32_t)oldPresentMode << std::dec
      << " => "
      << "0x" << std::hex << (uint32_t)desc.present_mode << std::dec
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return changed;
  }

  static bool changeColorSpace(reshade::api::swapchain* swapchain, DXGI_COLOR_SPACE_TYPE ColorSpace) {
    IDXGISwapChain* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    ATL::CComPtr<IDXGISwapChain4> swapchain4;

    if (!SUCCEEDED(native_swapchain->QueryInterface(__uuidof(IDXGISwapChain4), (void**)&swapchain4))) {
      reshade::log_message(reshade::log_level::error, "changeColorSpace(Failed to get native swap chain)");
      return false;
    }

    return SUCCEEDED(swapchain4->SetColorSpace1(DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709));
  }

  static void on_init_swapchain(reshade::api::swapchain* swapchain) {
    const auto device = swapchain->get_device();
    const size_t backBufferCount = swapchain->get_back_buffer_count();

    for (uint32_t index = 0; index < backBufferCount; index++) {
      auto buffer = swapchain->get_back_buffer(index);
      backBuffers.emplace(buffer.handle);

      std::stringstream s;
      s << "initSwapChain("
        << "buffer: 0x" << std::hex << (uint32_t)buffer.handle << std::dec
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }

    // Reshade doesn't actually inspect colorspace
    // auto colorspace = swapchain->get_color_space();
    if (changeColorSpace(swapchain, DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709)) {
      reshade::log_message(reshade::log_level::info, "initSwapChain(Color Space: OK)");
    } else {
      reshade::log_message(reshade::log_level::error, "initSwapChain(Color Space: Failed.)");
    }
  }

  static bool on_create_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc &desc
  ) {
    if (desc.format == reshade::api::format::unknown) return false;
    if (device == nullptr) return false;
    if (backBuffers.find(resource.handle) == backBuffers.end()) return false;

    const auto resourceDesc = device->get_resource_desc(resource);

    if (resourceDesc.texture.format != reshade::api::format::r16g16b16a16_float) return false;
    auto oldFormat = desc.format;
    desc.format = reshade::api::format::r16g16b16a16_float;
    std::stringstream s;
    s << "createResourceView("
      << "0x" << std::hex << (uint32_t)oldFormat << std::dec
      << " => "
      << "0x" << std::hex << (uint32_t)desc.format << std::dec
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return true;
  }

  void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::register_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::unregister_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::unregister_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
        break;
    }
  }
}  // namespace swapchainmod

namespace shaderreplacemod {
  struct CustomShader {
    uint32_t crc32;
    const uint8_t* code;
    uint32_t codeSize;
  };

  typedef std::unordered_map<uint32_t, CustomShader> CustomShaders;

  static float* _shaderInjection = nullptr;
  static size_t _shaderInjectionSize = 0;

  static CustomShaders* _customShaders = nullptr;

  std::shared_mutex s_mutex;
  std::vector<reshade::api::pipeline_layout_param*> createdParams;
  std::unordered_map<uint32_t, uint32_t> codeInjections;
  std::unordered_set<uint64_t> trackedLayouts;
  std::unordered_set<uint64_t> computeShaderLayouts;
  std::unordered_map<uint64_t, reshade::api::pipeline_layout> pipelineToLayoutMap;
  std::unordered_map<uint64_t, uint32_t> moddedPipelineRootIndexes;
  std::unordered_map<uint64_t, reshade::api::pipeline_layout> moddedPipelineLayouts;

  static bool replaceShader(reshade::api::shader_desc* desc, bool usingPipelineClone = false) {
    if (desc->code_size == 0) return false;

    uint32_t shader_hash = compute_crc32(
      static_cast<const uint8_t*>(desc->code),
      desc->code_size
    );

    const auto pair = _customShaders->find(shader_hash);
    if (pair == _customShaders->end()) return false;
    const auto customShader = pair->second;

    desc->code = customShader.code;
    desc->code_size = customShader.codeSize;

    uint32_t new_hash = compute_crc32(
      static_cast<const uint8_t*>(desc->code),
      desc->code_size
    );
    codeInjections.emplace(new_hash, shader_hash);

#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "replaceShader("
      << "0x" << std::hex << shader_hash << std::dec
      << " => "
      << "0x" << std::hex << new_hash << std::dec
      << " - " << desc->code_size << " bytes"
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif

    return true;
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

    for (uint32_t i = 0; i < subobject_count; ++i) {
      switch (subobjects[i].type) {
        case reshade::api::pipeline_subobject_type::compute_shader:
        case reshade::api::pipeline_subobject_type::pixel_shader:
          replaced_stages |= replaceShader(static_cast<reshade::api::shader_desc*>(subobjects[i].data));
          break;
      }
    }

    if (!replaced_stages) return false;
    if (_shaderInjectionSize != 0) {
      trackedLayouts.emplace(layout.handle);

      std::stringstream s;
      s << "onCreatePipeline(tracking " << reinterpret_cast<void*>(layout.handle) << " | " << replaced_stages << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }

    return true;
  }

  // Shader Injection
  static bool on_create_pipeline_layout(
    reshade::api::device* device,
    uint32_t &param_count,
    reshade::api::pipeline_layout_param*&params
  ) {
    reshade::log_message(reshade::log_level::debug, "oncreatepipelinelayout");
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

    if (pcCount != 0) return false;

    uint32_t oldCount = param_count;
    uint32_t newCount = oldCount + 1;
    reshade::api::pipeline_layout_param* newParams = new reshade::api::pipeline_layout_param[newCount];

    // Store reference to free later
    createdParams.push_back(newParams);

    // Copy up to size of old
    memcpy(newParams, params, sizeof(reshade::api::pipeline_layout_param) * oldCount);

    // Fill in extra param
    uint32_t slots = _shaderInjectionSize / sizeof(uint32_t);
    uint32_t maxCount = 64u - (oldCount + 1u) + 1u;
    newParams[oldCount].type = reshade::api::pipeline_layout_param_type::push_constants;
    newParams[oldCount].push_constants.binding = 0;
    newParams[oldCount].push_constants.count = min(slots, maxCount);
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
    s << "on_create_pipeline_layout++("
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
    const uint32_t paramCount,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout
  ) {
    uint32_t injectionIndex = -1;
    auto device_api = device->get_api();
    if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
      const std::unique_lock<std::shared_mutex> lock(s_mutex);
      if (!createdParams.size()) return;  // No injected params
      for (auto injectedParams : createdParams) {
        free(injectedParams);
      }
      createdParams.clear();

      for (uint32_t paramIndex = 0; paramIndex < paramCount; ++paramIndex) {
        auto param = params[paramIndex];
        if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
          if (param.push_constants.count == _shaderInjectionSize / sizeof(uint32_t)) {
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

    } else {
      injectionIndex = 0;
      for (uint32_t paramIndex = 0; paramIndex < paramCount; paramIndex++) {
        auto param = params[paramIndex];
        if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
          for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
            auto range = param.descriptor_table.ranges[rangeIndex];
            if (range.type == reshade::api::descriptor_type::constant_buffer) {
              if (injectionIndex < range.dx_register_index + range.count) {
                injectionIndex = range.dx_register_index + range.count;
              }
            }
          }
        } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
          if (injectionIndex < param.push_constants.dx_register_index + param.push_constants.count) {
            injectionIndex = param.push_constants.dx_register_index + param.push_constants.count;
          }
        } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
          if (param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer) {
            if (injectionIndex < param.push_descriptors.dx_register_index + param.push_descriptors.count) {
              injectionIndex = param.push_descriptors.dx_register_index + param.push_descriptors.count;
            }
          }
        }
      }
      if (injectionIndex == 14) {
        std::stringstream s;
        s << "on_init_pipeline_layout("
          << "Using last slot for buffer injection"
          << reinterpret_cast<void*>(layout.handle)
          << ": " << injectionIndex
          << " )";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        injectionIndex = 13;
      }
      {
        // device->create_pipeline_layout(1)

        reshade::api::pipeline_layout_param newParams;
        newParams.type = reshade::api::pipeline_layout_param_type::push_constants;
        //newParams.push_constants.binding = 0;
        newParams.push_constants.count = 1;
        newParams.push_constants.dx_register_index = injectionIndex;
        newParams.push_constants.dx_register_space = 0;
        newParams.push_constants.visibility = reshade::api::shader_stage::all;

        reshade::api::pipeline_layout newLayout;
        auto result = device->create_pipeline_layout(1, &newParams, &newLayout);
        std::stringstream s;
        s << "on_init_pipeline_layout("
          << "Creating D3D11 Layout"
          << reinterpret_cast<void*>(newLayout.handle)
          << ": " << result
          << " )";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
        moddedPipelineLayouts.emplace(layout.handle, newLayout);
      }
    }

    moddedPipelineRootIndexes.emplace(layout.handle, injectionIndex);

    std::stringstream s;
    s << "on_init_pipeline_layout("
      << "Using injection index for"
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
    const std::unique_lock<std::shared_mutex> lock(s_mutex);
    changed |= moddedPipelineRootIndexes.erase(layout.handle);
    changed |= trackedLayouts.erase(layout.handle);
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
    if (trackedLayouts.find(layout.handle) == trackedLayouts.end()) return;

    for (uint32_t i = 0; i < subobjectCount; ++i) {
      switch (subobjects[i].type) {
        case reshade::api::pipeline_subobject_type::compute_shader:
        case reshade::api::pipeline_subobject_type::pixel_shader:
          break;
        default:
          continue;
      }
      const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobjects[i].data);
      if (desc.code_size == 0) continue;
      // Pipeline has a pixel shader with code. Hash code and check
      auto shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);
      if (codeInjections.find(shader_hash) == codeInjections.end()) continue;

      pipelineToLayoutMap.emplace(pipeline.handle, layout);

      if (subobjects[i].type == reshade::api::pipeline_subobject_type::compute_shader) {
        computeShaderLayouts.emplace(layout.handle);
      }

      std::stringstream s;
      s << "onInitPipeline("
        << reinterpret_cast<void*>(pipeline.handle)
        << ", " << reinterpret_cast<void*>(layout.handle)
        << ", hash: 0x" << std::hex << shader_hash << std::dec
        << ", type: 0x" << std::hex << (uint32_t)subobjects[i].type << std::dec
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }

  static void on_destroy_pipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline
  ) {
    uint32_t changed = false;
    changed |= pipelineToLayoutMap.erase(pipeline.handle);
    changed |= computeShaderLayouts.erase(pipeline.handle);
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
    const std::unique_lock<std::shared_mutex> lock(s_mutex);
    auto pair0 = pipelineToLayoutMap.find(pipeline.handle);
    if (pair0 == pipelineToLayoutMap.end()) return;
    auto layout = pair0->second;

    auto device = cmd_list->get_device();
    auto device_api = device->get_api();
    reshade::api::shader_stage stage;
    if (device_api == reshade::api::device_api::d3d12 || device_api == reshade::api::device_api::vulkan) {
      auto pair2 = moddedPipelineRootIndexes.find(layout.handle);
      if (pair2 == moddedPipelineRootIndexes.end()) return;
      uint32_t paramIndex = pair2->second;

      stage = computeShaderLayouts.count(layout.handle) == 0
              ? reshade::api::shader_stage::all_graphics
              : reshade::api::shader_stage::all_compute;

      // Alternatively can monitor every draw event and then push
      cmd_list->push_constants(
        stage,   // Used by reshade to specify graphics or compute
        layout,  // Unused
        paramIndex,
        0,
        _shaderInjectionSize / sizeof(uint32_t),
        _shaderInjection
      );

      std::stringstream s;
      s << "bind_pipeline++("
        << reinterpret_cast<void*>(pipeline.handle)
        << ", " << reinterpret_cast<void*>(layout.handle)
        << ", " << paramIndex
        << ", " << std::hex << (uint32_t)stage
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    } else {
      stage = computeShaderLayouts.count(layout.handle) == 0
              ? reshade::api::shader_stage::pixel
              : reshade::api::shader_stage::compute;
      auto pair3 = moddedPipelineLayouts.find(layout.handle);
      if (pair3 == moddedPipelineLayouts.end()) return;
      auto newLayout = pair3->second;
      cmd_list->push_constants(
        stage,      // Used by reshade to specify graphics or compute
        newLayout,  // Unused
        0,
        0,
        _shaderInjectionSize / sizeof(uint32_t),
        _shaderInjection
      );
      std::stringstream s;
      s << "bind_pipeline++("
        << reinterpret_cast<void*>(pipeline.handle)
        << ", " << reinterpret_cast<void*>(layout.handle)
        << ", " << reinterpret_cast<void*>(newLayout.handle)
        << ", " << std::hex << (uint32_t)stage
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }

  template <typename T = float*>
  void use(DWORD fdwReason, CustomShaders* customShaders, T* injections = nullptr) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

        if (_customShaders == nullptr) {
          _customShaders = customShaders;
          std::stringstream s;
          s << "Attached Custom Shaders: " << _customShaders->size();
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }

        if (_shaderInjection == nullptr && injections != nullptr) {
          _shaderInjectionSize = sizeof(T);
          _shaderInjection = reinterpret_cast<float*>(injections);
          reshade::register_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
          reshade::register_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
          reshade::register_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

          reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
          reshade::register_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

          reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

          std::stringstream s;
          s << "Attached Injections: " << _shaderInjectionSize / sizeof(uint32_t);
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

        reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
        reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
        reshade::unregister_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

        reshade::unregister_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
        reshade::unregister_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

        reshade::unregister_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);
        break;
    }
  }
}  // namespace shaderreplacemod
