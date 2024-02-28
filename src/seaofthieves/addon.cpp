/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS

#include <embed/0x1761EAE2.h>
#include <embed/0x84B99833.h>
#include <embed/0xA47671B5.h>
#include <embed/0xADD50A11.h>
#include <embed/0xD80B5194.h>
#include <embed/0xE41360A3.h>

#include <filesystem>
#include <fstream>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>

#include "./seaofthieves.h"

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - SoT";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Sea of Thieves";

struct CustomShader {
  uint32_t crc32;
  const uint8_t* code;
  uint32_t codeSize;
  bool usePipelineClone;
};

static std::unordered_map<uint32_t, CustomShader> customShaders = {
  // {0x1761EAE2, {0x1761EAE2, _0x1761EAE2, sizeof(0x1761EAE2), false}},
  {0x84B99833, {0x84B99833, _0x84B99833, sizeof(_0x84B99833), true}},
  // {0xADD50A11, {0xADD50A11, _0xADD50A11, sizeof(_0xADD50A11), true}},
  // {0xA47671B5, {0xA47671B5, _0xA47671B5, sizeof(_0xA47671B5), true}},
  // {0xD80B5194, {0xD80B5194, _0xD80B5194, sizeof(_0xD80B5194), false}},
  {0xE41360A3, {0xE41360A3, _0xE41360A3, sizeof(_0xE41360A3), true}}
};

std::shared_mutex s_mutex;
std::vector<reshade::api::pipeline_layout_param*> createdParams;
std::unordered_map<uint32_t, uint32_t> codeInjections;
std::unordered_set<uint64_t> trackedLayouts;
std::unordered_set<uint64_t> computeShaderLayouts;
std::unordered_map<uint64_t, reshade::api::pipeline_layout> pipelineToLayoutMap;
std::unordered_map<uint64_t, uint32_t> moddedPipelineRootIndexes;
std::unordered_map<uint64_t, reshade::api::pipeline> pipelineToCloneMap;
std::unordered_map<reshade::api::command_list*, reshade::api::pipeline> nextPipelineMap;  // needs stage

ShaderInjectData shaderInjectData;

static struct UserInjectData {
  float uiPaperWhite = 200.f;
} userInjectData;

static void updateShaderData() {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  // shaderInjectData.uiPaperWhite = userInjectData.uiPaperWhite;
}

static bool needsPipelineClone(uint32_t shader_hash) {
  return false;
}

static bool replaceShader(reshade::api::shader_desc* desc, bool usingPipelineClone = false) {
  if (desc->code_size == 0) return false;

  uint32_t shader_hash = compute_crc32(
    static_cast<const uint8_t*>(desc->code),
    desc->code_size
  );

  const auto pair = customShaders.find(shader_hash);
  if (pair == customShaders.end()) return false;
  const auto customShader = pair->second;

  // if (usingPipelineClone) {
  //   if (usingPipelineClone != customShader.usePipelineClone) return false;
  // }

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

// Before CreateRootSignature
static bool on_create_pipeline_layout(
  reshade::api::device* device,
  uint32_t &param_count,
  reshade::api::pipeline_layout_param*&params
) {
  uint32_t slots = sizeof(ShaderInjectData) / sizeof(uint32_t);
  if (slots == 0) return false;

  bool foundVisiblity = false;
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

#ifdef DEBUG_LEVEL_1
  logLayout(param_count, params, 0x001);
#endif

  uint32_t oldCount = param_count;
  uint32_t newCount = oldCount + 1;
  reshade::api::pipeline_layout_param* newParams = new reshade::api::pipeline_layout_param[newCount];

  // Store reference to free later
  createdParams.push_back(newParams);

  // Copy up to size of old
  memcpy(newParams, params, sizeof(reshade::api::pipeline_layout_param) * oldCount);

  // Fill in extra param
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

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "on_create_pipeline_layout++("
    << "will insert"
    << " cbuffer " << cbvIndex
    << " at root_index " << oldCount
    << " with slot count " << slots
    << " creating new size of " << (oldCount + 1u + slots)
    << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

#ifdef DEBUG_LEVEL_1
  logLayout(newCount, newParams, 0x002);
#endif

#endif

  return true;
}

// AfterCreateRootSignature
static void on_init_pipeline_layout(
  reshade::api::device* device,
  const uint32_t paramCount,
  const reshade::api::pipeline_layout_param* params,
  reshade::api::pipeline_layout layout
) {
  uint32_t slots = sizeof(ShaderInjectData) / sizeof(uint32_t);
  if (slots == 0) return;

  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  if (!createdParams.size()) return;  // No injected params
  for (auto injectedParams : createdParams) {
    free(injectedParams);
  }
  createdParams.clear();

  uint32_t foundParamIndex = -1;
  for (uint32_t paramIndex = 0; paramIndex < paramCount; ++paramIndex) {
    auto param = params[paramIndex];
    if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      if (param.push_constants.count == sizeof(ShaderInjectData) / sizeof(uint32_t)) {
        foundParamIndex = paramIndex;
      }
    }
  }
  if (foundParamIndex == -1) return;
  moddedPipelineRootIndexes.emplace(layout.handle, foundParamIndex);

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "on_init_pipeline_layout++("
    << reinterpret_cast<void*>(layout.handle)
    << " , " << foundParamIndex
    << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
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

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "on_destroy_pipeline_layout(";
  s << reinterpret_cast<void*>(layout.handle);
  s << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
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

  trackedLayouts.emplace(layout.handle);

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "tracking layout handle(" << reinterpret_cast<void*>(layout.handle) << " | " << replaced_stages << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif

  return true;
}

// After CreatePipelineState
static void on_init_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline_layout layout,
  uint32_t subobjectCount,
  const reshade::api::pipeline_subobject* subobjects,
  reshade::api::pipeline pipeline
) {
  // if (trackedLayouts.find(layout.handle) == trackedLayouts.end()) return;

  bool needsClone = false;
  bool hasReplacedShader = false;
  for (uint32_t i = 0; i < subobjectCount; ++i) {
    switch (subobjects[i].type) {
      case reshade::api::pipeline_subobject_type::compute_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:
        break;
      default:
        continue;
    }
    reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobjects[i].data);
    if (desc.code_size == 0) continue;
    // Pipeline has a pixel shader with code. Hash code and check
    auto shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);
    if (codeInjections.find(shader_hash) == codeInjections.end()) continue;

    needsClone = true;
    pipelineToLayoutMap.emplace(pipeline.handle, layout);

    if (subobjects[i].type == reshade::api::pipeline_subobject_type::compute_shader) {
      computeShaderLayouts.emplace(layout.handle);
    }

#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "found changed shader ("
      << reinterpret_cast<void*>(pipeline.handle)
      << ", " << reinterpret_cast<void*>(layout.handle)
      << ", hash: 0x" << std::hex << shader_hash << std::dec
      << ", type: 0x" << std::hex << (uint32_t)subobjects[i].type << std::dec
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
  }
  if (!needsClone) return;

  if (pipelineToCloneMap.count(pipeline.handle)) {
    std::stringstream s;
    s << "already has clone for pipeline ("
      << reinterpret_cast<void*>(pipeline.handle)
      << ", " << reinterpret_cast<void*>(layout.handle)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return;
  }

  reshade::api::pipeline_subobject* newSubobjects = new reshade::api::pipeline_subobject[subobjectCount];
  memcpy(newSubobjects, subobjects, sizeof(reshade::api::pipeline_subobject) * subobjectCount);
//   for (uint32_t i = 0; i < subobjectCount; ++i) {
//     auto newSubObject = newSubobjects[i];
//     switch (newSubObject.type) {
//       case reshade::api::pipeline_subobject_type::compute_shader:
//       case reshade::api::pipeline_subobject_type::pixel_shader:
//         break;
//       default:
//         continue;
//     }
//     reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(newSubObject.data);
//     if (desc.code_size == 0) continue;
//     // Pipeline has a pixel shader with code. Hash code and check
//     auto shader_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);
//     if (!replaceShader(&desc, true)) continue;

//     reshade::api::shader_desc newDesc;
//     newDesc.code = desc.code;
//     newDesc.code_size = desc.code_size;
//     newDesc.entry_point = desc.entry_point;
//     newSubObject.data = &newDesc;

// #ifdef DEBUG_LEVEL_0
//     std::stringstream s;
//     s << "cloning pipeline for shader("
//       << reinterpret_cast<void*>(pipeline.handle)
//       << ", " << reinterpret_cast<void*>(layout.handle)
//       << ", hash: 0x" << std::hex << shader_hash << std::dec
//       << ", type: 0x" << std::hex << (uint32_t)newSubObject.type << std::dec
//       << ")";
//     reshade::log_message(reshade::log_level::info, s.str().c_str());
// #endif
//   }
  reshade::api::pipeline newPipeline;
  bool builtPipelineOK = device->create_pipeline(layout, subobjectCount, newSubobjects, &newPipeline);
  std::stringstream s;
  
  if (builtPipelineOK) {
    pipelineToCloneMap.emplace(pipeline.handle, newPipeline);
  }
  s << "clone pipeline ("
    << reinterpret_cast<void*>(pipeline.handle)
    << ", " << reinterpret_cast<void*>(layout.handle)
    << ", " << reinterpret_cast<void*>(newPipeline.handle)
    << ", " << (builtPipelineOK ? "OK" : "FAILED!")
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

static void on_destroy_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline pipeline
) {
  uint32_t changed = false;
  changed |= pipelineToLayoutMap.erase(pipeline.handle);
  changed |= computeShaderLayouts.erase(pipeline.handle);
  if (!changed) return;

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "on_destroy_pipeline("
    << reinterpret_cast<void*>(pipeline.handle)
    << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
}

// AfterSetPipelineState
static void on_bind_pipeline(
  reshade::api::command_list* cmd_list,
  reshade::api::pipeline_stage type,
  reshade::api::pipeline pipeline
) {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  auto pipelineToClone = pipelineToCloneMap.find(pipeline.handle);
  if (pipelineToClone != pipelineToCloneMap.end()) {
    auto newPipeline = pipelineToClone->second;
    std::stringstream s;
    s << "queuing pipeline clone ("
      << reinterpret_cast<void*>(pipeline.handle)
      << ", " << reinterpret_cast<void*>(type)
      << ", " << reinterpret_cast<void*>(newPipeline.handle)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    cmd_list->bind_pipeline(type, newPipeline);
    nextPipelineMap.emplace(cmd_list, newPipeline);
    return;
  }

  uint32_t slots = sizeof(ShaderInjectData) / sizeof(uint32_t);
  if (slots == 0) return;

  // const std::unique_lock<std::shared_mutex> lock(s_mutex);
  auto pair0 = pipelineToLayoutMap.find(pipeline.handle);
  if (pair0 == pipelineToLayoutMap.end()) return;
  auto layout = pair0->second;

  auto pair2 = moddedPipelineRootIndexes.find(layout.handle);
  if (pair2 == moddedPipelineRootIndexes.end()) return;
  uint32_t paramIndex = pair2->second;

  auto stage = computeShaderLayouts.count(layout.handle) == 0
               ? reshade::api::shader_stage::all_graphics
               : reshade::api::shader_stage::all_compute;

  cmd_list->push_constants(
    stage,   // Used by reshade to specify graphics or compute
    layout,  // Unused
    paramIndex,
    0,
    sizeof(ShaderInjectData) / sizeof(uint32_t),
    &shaderInjectData
  );

  std::stringstream s;
  s << "bind_pipeline++("
    << reinterpret_cast<void*>(pipeline.handle)
    << ", " << reinterpret_cast<void*>(layout.handle)
    << ", " << paramIndex
    << ", " << std::hex << (uint32_t)stage
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

// @see https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
static void on_register_overlay(reshade::api::effect_runtime* runtime) {
  bool updateShaders = false;
  bool updateShadersOrPreset = false;

  updateShaders |= ImGui::SliderFloat(
    "UI Paper White",
    &userInjectData.uiPaperWhite,
    80.f,
    500.f,
    "%.0f"
  );
  if (updateShaders || updateShadersOrPreset) {
    updateShaderData();
  }
}

static bool on_draw(
  reshade::api::command_list* cmd_list,
  uint32_t vertex_count,
  uint32_t instance_count,
  uint32_t first_vertex,
  uint32_t first_instance
) {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  auto pair = nextPipelineMap.find(cmd_list);
  if (pair == nextPipelineMap.end()) return false;
  auto newPipeline = pair->second;
  std::stringstream s;
  nextPipelineMap.erase(pair);

  s << "ondraw: replacing pipeline("
    << reinterpret_cast<void*>(newPipeline.handle)
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all, newPipeline);
  cmd_list->draw(vertex_count, instance_count, first_vertex, first_instance);
  return true;
}

static bool on_draw_indexed(
  reshade::api::command_list* cmd_list,
  uint32_t index_count,
  uint32_t instance_count,
  uint32_t first_index,
  int32_t vertex_offset,
  uint32_t first_instance
) {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  auto pair = nextPipelineMap.find(cmd_list);
  if (pair == nextPipelineMap.end()) return false;
  auto newPipeline = pair->second;
  std::stringstream s;
  nextPipelineMap.erase(pair);

  s << "draw_indexed: replacing pipeline("
    << reinterpret_cast<void*>(newPipeline.handle)
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all, newPipeline);
  cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);
  return true;
}

static bool on_draw_or_dispatch_indirect(
  reshade::api::command_list* cmd_list,
  reshade::api::indirect_command type,
  reshade::api::resource buffer,
  uint64_t offset,
  uint32_t draw_count,
  uint32_t stride
) {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  auto pair = nextPipelineMap.find(cmd_list);
  if (pair == nextPipelineMap.end()) return false;
  auto newPipeline = pair->second;
  std::stringstream s;
  nextPipelineMap.erase(pair);

  s << "on_draw_or_dispatch_indirect: replacing pipeline("
    << reinterpret_cast<void*>(newPipeline.handle)
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all, newPipeline);
  cmd_list->draw_or_dispatch_indirect(type, buffer, offset, draw_count, stride);
  return true;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

      updateShaderData();

      // reshade::register_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
      // reshade::register_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
      // reshade::register_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

      reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
      // reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
      // reshade::register_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

      // reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

      // reshade::register_event<reshade::addon_event::draw>(on_draw);
      // reshade::register_event<reshade::addon_event::draw_indexed>(on_draw_indexed);
      // reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(on_draw_or_dispatch_indirect);

      // reshade::register_overlay("RenoDX", on_register_overlay);
      break;
    case DLL_PROCESS_DETACH:
      // reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
      // reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
      // reshade::unregister_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

      reshade::unregister_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
      // reshade::unregister_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
      // reshade::unregister_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

      // reshade::unregister_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

      // reshade::unregister_event<reshade::addon_event::draw>(on_draw);
      // reshade::unregister_event<reshade::addon_event::draw_indexed>(on_draw_indexed);
      // reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(on_draw_or_dispatch_indirect);

      // reshade::unregister_overlay("RenoDX", on_register_overlay);

      reshade::unregister_addon(hModule);
      break;
  }

  return TRUE;
}
