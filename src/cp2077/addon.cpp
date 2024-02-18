/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <embed/0x5DF649A9.h>
#include <embed/0x61DBBA5C.h>
#include <embed/0x71F27445.h>
#include <embed/0x745E34E1.h>
#include <embed/0x97CA5A85.h>
#include <embed/0xA61F2FEE.h>
#include <embed/0xC783FBA1.h>
#include <embed/0xC83E64DF.h>
#include <embed/0xCBFFC2A3.h>
#include <embed/0xD2BBEBD9.h>

#include <filesystem>
#include <fstream>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>

#include "./cp2077.h"

#if 0
#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"
#else
#include "C:/Users/clsho/Documents/GitHub/reshade/deps/imgui/imgui.h"
#include "C:/Users/clsho/Documents/GitHub/reshade/include/reshade.hpp"
#endif

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - CP2077";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

std::shared_mutex s_mutex;
std::vector<reshade::api::pipeline_layout_param*> createdParams;
std::unordered_set<uint32_t> codeInjections;
std::unordered_set<uint64_t> trackedLayouts;
std::unordered_set<uint64_t> computeShaderLayouts;
std::unordered_map<uint64_t, reshade::api::pipeline_layout> pipelineToLayoutMap;
std::unordered_map<uint64_t, uint32_t> moddedPipelineRootIndexes;

ShaderInjectData shaderInjectData;

static struct UserInjectData {
  int presetIndex = 1;
  float toneMapperPaperWhite = 203.f;
  int toneMapperType = 2;
  float toneMapperExposure = 1.f;
  float toneMapperContrast = 50.f;
  float toneMapperHighlights = 50.f;
  float toneMapperShadows = 50.f;
  float toneMapperDechroma = 50.f;
  int toneMapperWhitePoint = 1;
  int colorGradingWorkflow = 1;
  float colorGradingStrength = 100.f;
  int colorGradingScaling = 0;
  float colorGradingSaturation = 50.f;
  float effectBloom = 50.f;
  float effectVignette = 50.f;
  float effectFilmGrain = 50.f;
  float debugValue00 = 1.f;
  float debugValue01 = 1.f;
  float debugValue02 = 1.f;
  float debugValue03 = 1.f;
} userInjectData;

static void updateShaderData() {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  shaderInjectData.toneMapperType = static_cast<float>(userInjectData.toneMapperType);
  shaderInjectData.toneMapperPaperWhite = userInjectData.toneMapperPaperWhite;
  shaderInjectData.toneMapperExposure = userInjectData.toneMapperExposure;
  shaderInjectData.toneMapperContrast = userInjectData.toneMapperContrast * 0.02f;
  shaderInjectData.toneMapperHighlights = userInjectData.toneMapperHighlights * 0.02f;
  shaderInjectData.toneMapperShadows = userInjectData.toneMapperShadows * 0.02f;
  shaderInjectData.toneMapperDechroma = userInjectData.toneMapperDechroma * 0.02f;
  shaderInjectData.toneMapperWhitePoint = static_cast<float>(userInjectData.toneMapperWhitePoint - 1);
  shaderInjectData.colorGradingWorkflow = static_cast<float>(userInjectData.colorGradingWorkflow - 1);
  shaderInjectData.colorGradingStrength = userInjectData.colorGradingStrength * 0.01f;
  shaderInjectData.colorGradingScaling = static_cast<float>(userInjectData.colorGradingScaling);
  shaderInjectData.colorGradingSaturation = userInjectData.colorGradingSaturation * 0.02f;
  shaderInjectData.effectBloom = userInjectData.effectBloom * 0.02f;
  shaderInjectData.effectVignette = userInjectData.effectVignette * 0.02f;
  shaderInjectData.effectFilmGrain = userInjectData.effectFilmGrain * 0.02f;
  shaderInjectData.debugValue00 = userInjectData.debugValue00;
  shaderInjectData.debugValue01 = userInjectData.debugValue01;
  shaderInjectData.debugValue02 = userInjectData.debugValue02;
  shaderInjectData.debugValue03 = userInjectData.debugValue03;
}

static const char* presetStrings[] = {
  "Off",
  "Preset #1",
  "Preset #2",
  "Preset #3",
};

static const char* toneMapperTypeStrings[] = {
  "None",
  "Vanilla",
  "OpenDRT",
  "DICE",
  "ACES",
};

static const char* toneMapperWhitePointStrings[] = {
  "D60",
  "Vanilla",
  "D65"
};

static const char* colorGradingWorkflowStrings[] = {
  "Before Tonemapping",
  "Vanilla",
  "After Tonemapping",
};

static const char* colorGradingScalingStrings[] = {
  "None",
  "Vanilla",
};

void logLayout(
  const uint32_t paramCount,
  const reshade::api::pipeline_layout_param* params,
  uint32_t tag
) {
  for (uint32_t paramIndex = 0; paramIndex < paramCount; ++paramIndex) {
    auto param = params[paramIndex];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
        auto range = param.descriptor_table.ranges[rangeIndex];
        std::stringstream s;
        s << "pipeline_layout(";
        s << tag;
        s << " | TBL";
        s << " | " << reinterpret_cast<void*>(&param.descriptor_table.ranges);
        s << " | ";
        switch (range.type) {
          case reshade::api::descriptor_type::sampler:
            s << "SMP";
            break;
          case reshade::api::descriptor_type::sampler_with_resource_view:
            s << "SRV";
            break;
          case reshade::api::descriptor_type::shader_resource_view:
            s << "SRV2";
            break;
          case reshade::api::descriptor_type::unordered_access_view:
            s << "UAV";
            break;
          case reshade::api::descriptor_type::constant_buffer:
            s << "CBV";
            break;
          case reshade::api::descriptor_type::shader_storage_buffer:
            s << "SSB";
            break;
          case reshade::api::descriptor_type::acceleration_structure:
            s << "ACC";
            break;
          default:
            s << "???";
        }

        s << " | " << range.array_size
          << " | " << range.binding
          << " | " << range.count
          << " | " << range.dx_register_index
          << " | " << range.dx_register_space
          << " | " << (uint32_t)range.visibility
          << ")"
          << " [" << rangeIndex << "/" << param.descriptor_table.count << "]"
          << " [" << paramIndex << "/" << paramCount << "]";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      std::stringstream s;
      s << "pipeline_layout(";
      s << tag;
      s << " | PC"
        << " | " << param.push_constants.binding
        << " | " << param.push_constants.count
        << " | " << param.push_constants.dx_register_index
        << " | " << param.push_constants.dx_register_space
        << " | " << (uint32_t)param.push_constants.visibility
        << ")"
        << " [" << paramIndex << "/" << paramCount << "]";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
      std::stringstream s;
      s << "pipeline_layout(";
      s << tag;
      s << " | PD"
        << " | " << param.push_descriptors.array_size
        << " | " << param.push_descriptors.binding
        << " | " << param.push_descriptors.count
        << " | " << param.push_descriptors.dx_register_index
        << " | " << param.push_descriptors.dx_register_space
        << " | " << (uint32_t)param.push_descriptors.type
        << " | " << (uint32_t)param.push_descriptors.visibility
        << ")"
        << " [" << paramIndex << "/" << paramCount << "]";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges) {
      std::stringstream s;
      s << "pipeline_layout("
        << tag
        << " | PDR?? | "
        << ")"
        << " [" << paramIndex << "/" << paramCount << "]";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    } else {
      std::stringstream s;
      s << "pipeline_layout("
        << tag
        << " | ???"
        << " | " << (uint32_t)param.type
        << ")"
        << " [" << paramIndex << "/" << paramCount << "]";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }
}

static bool load_embedded_shader(
  reshade::api::device_api device_type,
  reshade::api::shader_desc* desc
) {
  if (desc->code_size == 0) return false;

  uint32_t shader_hash = compute_crc32(
    static_cast<const uint8_t*>(desc->code),
    desc->code_size
  );

  switch (shader_hash) {
    case 0x71F27445:
      desc->code = &_0x71F27445;
      desc->code_size = sizeof(_0x71F27445);
      break;
    case 0xA61F2FEE:
      desc->code = &_0xA61F2FEE;
      desc->code_size = sizeof(_0xA61F2FEE);
      break;
    case 0x5DF649A9:
      desc->code = &_0x5DF649A9;
      desc->code_size = sizeof(_0x5DF649A9);
      break;
    case 0x61DBBA5C:
      desc->code = &_0x61DBBA5C;
      desc->code_size = sizeof(_0x61DBBA5C);
    case 0x745E34E1:
      desc->code = &_0x745E34E1;
      desc->code_size = sizeof(_0x745E34E1);
      break;
    case 0x97CA5A85:
      desc->code = &_0x97CA5A85;
      desc->code_size = sizeof(_0x97CA5A85);
      break;
    case 0xCBFFC2A3:
      desc->code = &_0xCBFFC2A3;
      desc->code_size = sizeof(_0xCBFFC2A3);
      break;
    case 0xC83E64DF:
      desc->code = &_0xC83E64DF;
      desc->code_size = sizeof(_0xC83E64DF);
      break;
    case 0xD2BBEBD9:
      desc->code = &_0xD2BBEBD9;
      desc->code_size = sizeof(_0xD2BBEBD9);
      break;
    case 0xC783FBA1:
      desc->code = &_0xC783FBA1;
      desc->code_size = sizeof(_0xC783FBA1);
      break;
    default:
      return false;
  }

  uint32_t new_hash = compute_crc32(
    static_cast<const uint8_t*>(desc->code),
    desc->code_size
  );
  codeInjections.emplace(new_hash);

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "load_shader_code:replace("
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
  reshade::api::pipeline_layout_desc* desc
) {
  bool foundVisiblity = false;
  uint32_t cbvIndex = 0;
  uint32_t pcCount = 0;

  for (uint32_t paramIndex = 0; paramIndex < desc->count; ++paramIndex) {
    auto param = desc->params[paramIndex];
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
  if (cbvIndex != 14) return false;

#ifdef DEBUG_LEVEL_1
  logLayout(desc->count, desc->params, 0x001);
#endif

  uint32_t oldCount = (desc->count);
  uint32_t newCount = oldCount + 1;
  reshade::api::pipeline_layout_param* newParams = new reshade::api::pipeline_layout_param[newCount];

  // Store reference to free later
  createdParams.push_back(newParams);

  // Copy up to size of old
  memcpy(newParams, desc->params, sizeof(reshade::api::pipeline_layout_param) * oldCount);

  // Fill in extra param
  newParams[oldCount].type = reshade::api::pipeline_layout_param_type::push_constants;
  newParams[oldCount].push_constants.binding = 0;
  newParams[oldCount].push_constants.count = sizeof(ShaderInjectData) / sizeof(uint32_t);
  newParams[oldCount].push_constants.dx_register_index = cbvIndex;
  newParams[oldCount].push_constants.dx_register_space = 0;
  newParams[oldCount].push_constants.visibility = reshade::api::shader_stage::all;

  desc->count = newCount;
  desc->params = newParams;

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "on_create_pipeline_layout++(";
  s << "will insert new push_constant at ";
  s << cbvIndex;
  s << " )";
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
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
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
        replaced_stages |= load_embedded_shader(
          device_type,
          static_cast<reshade::api::shader_desc*>(subobjects[i].data)
        );
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
  auto pair0 = pipelineToLayoutMap.find(pipeline.handle);
  if (pair0 == pipelineToLayoutMap.end()) return;
  auto layout = pair0->second;

  auto pair2 = moddedPipelineRootIndexes.find(layout.handle);
  if (pair2 == moddedPipelineRootIndexes.end()) return;
  uint32_t paramIndex = pair2->second;

  auto stage = computeShaderLayouts.count(layout.handle) == 0
               ? reshade::api::shader_stage::all_graphics
               : reshade::api::shader_stage::all_compute;

  const std::shared_lock<std::shared_mutex> lock(s_mutex);
  cmd_list->push_constants(
    stage,   // Used by reshade to specify graphics or compute
    layout,  // Unused
    paramIndex,
    0,
    sizeof(ShaderInjectData) / sizeof(uint32_t),
    &shaderInjectData
  );

#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "bind_pipeline++("
    << reinterpret_cast<void*>(pipeline.handle)
    << ", " << reinterpret_cast<void*>(layout.handle)
    << ", " << desc.index
    << ", " << std::hex << (uint32_t)desc.visibility
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
}

static void load_settings(
  reshade::api::effect_runtime* runtime = nullptr,
  const char* section = "renodx-cp2077-preset1"
) {
  UserInjectData newData = {};
  reshade::get_config_value(runtime, section, "toneMapperType", newData.toneMapperType);
  reshade::get_config_value(runtime, section, "toneMapperExposure", newData.toneMapperExposure);
  reshade::get_config_value(runtime, section, "toneMapperPaperWhite", newData.toneMapperPaperWhite);
  reshade::get_config_value(runtime, section, "toneMapperExposure", newData.toneMapperExposure);
  reshade::get_config_value(runtime, section, "toneMapperContrast", newData.toneMapperContrast);
  reshade::get_config_value(runtime, section, "toneMapperHighlights", newData.toneMapperHighlights);
  reshade::get_config_value(runtime, section, "toneMapperShadows", newData.toneMapperShadows);
  reshade::get_config_value(runtime, section, "toneMapperDechroma", newData.toneMapperDechroma);
  reshade::get_config_value(runtime, section, "toneMapperWhitePoint", newData.toneMapperWhitePoint);
  reshade::get_config_value(runtime, section, "colorGradingWorkflow", newData.colorGradingWorkflow);
  reshade::get_config_value(runtime, section, "colorGradingStrength", newData.colorGradingStrength);
  reshade::get_config_value(runtime, section, "colorGradingScaling", newData.colorGradingScaling);
  reshade::get_config_value(runtime, section, "colorGradingSaturation", newData.colorGradingSaturation);
  reshade::get_config_value(runtime, section, "effectBloom", newData.effectBloom);
  reshade::get_config_value(runtime, section, "effectVignette", newData.effectVignette);
  reshade::get_config_value(runtime, section, "effectFilmGrain", newData.effectFilmGrain);
  userInjectData.toneMapperType = newData.toneMapperType;
  userInjectData.toneMapperExposure = newData.toneMapperExposure;
  userInjectData.toneMapperPaperWhite = newData.toneMapperPaperWhite;
  userInjectData.toneMapperExposure = newData.toneMapperExposure;
  userInjectData.toneMapperContrast = newData.toneMapperContrast;
  userInjectData.toneMapperHighlights = newData.toneMapperHighlights;
  userInjectData.toneMapperShadows = newData.toneMapperShadows;
  userInjectData.toneMapperDechroma = newData.toneMapperDechroma;
  userInjectData.toneMapperWhitePoint = newData.toneMapperWhitePoint;
  userInjectData.colorGradingWorkflow = newData.colorGradingWorkflow;
  userInjectData.colorGradingStrength = newData.colorGradingStrength;
  userInjectData.colorGradingScaling = newData.colorGradingScaling;
  userInjectData.colorGradingSaturation = newData.colorGradingSaturation;
  userInjectData.effectBloom = newData.effectBloom;
  userInjectData.effectVignette = newData.effectVignette;
  userInjectData.effectFilmGrain = newData.effectFilmGrain;
}

static void save_settings(reshade::api::effect_runtime* runtime, char* section = "renodx-cp2077-preset1") {
  reshade::set_config_value(runtime, section, "toneMapperType", userInjectData.toneMapperType);
  reshade::set_config_value(runtime, section, "toneMapperPaperWhite", userInjectData.toneMapperPaperWhite);
  reshade::set_config_value(runtime, section, "toneMapperExposure", userInjectData.toneMapperExposure);
  reshade::set_config_value(runtime, section, "toneMapperContrast", userInjectData.toneMapperContrast);
  reshade::set_config_value(runtime, section, "toneMapperHighlights", userInjectData.toneMapperHighlights);
  reshade::set_config_value(runtime, section, "toneMapperShadows", userInjectData.toneMapperShadows);
  reshade::set_config_value(runtime, section, "toneMapperDechroma", userInjectData.toneMapperDechroma);
  reshade::set_config_value(runtime, section, "toneMapperWhitePoint", userInjectData.toneMapperWhitePoint);
  reshade::set_config_value(runtime, section, "colorGradingWorkflow", userInjectData.colorGradingWorkflow);
  reshade::set_config_value(runtime, section, "colorGradingStrength", userInjectData.colorGradingStrength);
  reshade::set_config_value(runtime, section, "colorGradingScaling", userInjectData.colorGradingScaling);
  reshade::set_config_value(runtime, section, "colorGradingSaturation", userInjectData.colorGradingSaturation);
  reshade::set_config_value(runtime, section, "effectBloom", userInjectData.effectBloom);
  reshade::set_config_value(runtime, section, "effectVignette", userInjectData.effectVignette);
  reshade::set_config_value(runtime, section, "effectFilmGrain", userInjectData.effectFilmGrain);
}

static void on_register_overlay(reshade::api::effect_runtime* runtime) {
  bool updateShaders = false;
  bool updateShadersOrPreset = false;

  bool changedPreset = ImGui::SliderInt(
    "Preset",
    &userInjectData.presetIndex,
    0,
    (sizeof(presetStrings) / sizeof(char*)) - 1,
    presetStrings[userInjectData.presetIndex],
    ImGuiSliderFlags_NoInput
  );
  if (changedPreset) {
    switch (userInjectData.presetIndex) {
      case 0:
        userInjectData.toneMapperPaperWhite = 203.f;
        userInjectData.toneMapperType = 1;
        userInjectData.toneMapperExposure = 1.f;
        userInjectData.toneMapperContrast = 50.f;
        userInjectData.toneMapperHighlights = 50.f;
        userInjectData.toneMapperShadows = 50.f;
        userInjectData.toneMapperDechroma = 50.f;
        userInjectData.toneMapperWhitePoint = 1;
        userInjectData.colorGradingWorkflow = 1;
        userInjectData.colorGradingStrength = 100.f;
        userInjectData.colorGradingScaling = 1;
        userInjectData.colorGradingSaturation = 50.f;
        userInjectData.effectBloom = 50.f;
        userInjectData.effectVignette = 50.f;
        userInjectData.effectFilmGrain = 0.f;
        break;
      case 1:
        load_settings(runtime);
        break;
      case 2:
        load_settings(runtime, "renodx-cp2077-preset2");
        break;
      case 3:
        load_settings(runtime, "renodx-cp2077-preset3");
        break;
    }
    updateShaders = true;
  }

  ImGui::BeginDisabled(userInjectData.presetIndex == 0);
  ImGui::SeparatorText("HDR Tone Mapping");
  {
    updateShadersOrPreset |= ImGui::SliderInt(
      "Tone Mapper",
      &userInjectData.toneMapperType,
      0,
      (sizeof(toneMapperTypeStrings) / sizeof(char*)) - 1,
      toneMapperTypeStrings[userInjectData.toneMapperType],
      ImGuiSliderFlags_NoInput
    );

    ImGui::BeginDisabled(userInjectData.toneMapperType <= 1);
    updateShadersOrPreset |= ImGui::SliderFloat(
      "Exposure",
      &userInjectData.toneMapperExposure,
      0.f,
      10.f,
      "%.2f"
    );
    ImGui::SetItemTooltip("Input scaling factor before passing to tone mapper.");
    ImGui::EndDisabled();

    ImGui::BeginDisabled(userInjectData.toneMapperType != 2 && userInjectData.toneMapperType != 4);
    updateShadersOrPreset |= ImGui::SliderFloat(
      "Paperwhite",
      &userInjectData.toneMapperPaperWhite,
      80.f,
      500.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Adjusts the brightness of 100%% white.");
    ImGui::EndDisabled();

    ImGui::BeginDisabled(userInjectData.toneMapperType != 2);
    updateShadersOrPreset |= ImGui::SliderFloat(
      "Contrast",
      &userInjectData.toneMapperContrast,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Adjusts tone mapper's contrast factor (if avilable).");
    ImGui::EndDisabled();

    ImGui::BeginDisabled(userInjectData.toneMapperType != 2);
    updateShadersOrPreset |= ImGui::SliderFloat(
      "Highlights",
      &userInjectData.toneMapperHighlights,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::EndDisabled();

    ImGui::BeginDisabled(userInjectData.toneMapperType != 2 && userInjectData.toneMapperType != 4);
    updateShadersOrPreset |= ImGui::SliderFloat(
      "Shadows",
      &userInjectData.toneMapperShadows,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Adjusts tone mapper's shadows or black level (if available).");
    ImGui::EndDisabled();

    ImGui::BeginDisabled(userInjectData.toneMapperType != 2);
    updateShadersOrPreset |= ImGui::SliderFloat(
      "Dechroma",
      &userInjectData.toneMapperDechroma,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Adjusts tone mapper's dechroma strength (if available).");
    ImGui::EndDisabled();

    updateShadersOrPreset |= ImGui::SliderInt(
      "White Point",
      &userInjectData.toneMapperWhitePoint,
      0,
      (sizeof(toneMapperWhitePointStrings) / sizeof(char*)) - 1,
      toneMapperWhitePointStrings[userInjectData.toneMapperWhitePoint],
      ImGuiSliderFlags_NoInput
    );
  }

  ImGui::SeparatorText("Color Grading");
  {
    updateShadersOrPreset |= ImGui::SliderInt(
      "Workflow",
      &userInjectData.colorGradingWorkflow,
      0,
      (sizeof(colorGradingWorkflowStrings) / sizeof(char*)) - 1,
      colorGradingWorkflowStrings[userInjectData.colorGradingWorkflow],
      ImGuiSliderFlags_NoInput
    );
    ImGui::SetItemTooltip("Modifies order of when color grading is applied.");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "LUT Strength",
      &userInjectData.colorGradingStrength,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Modifies the strength of the LUT application.");

    updateShadersOrPreset |= ImGui::SliderInt(
      "LUT Scaling",
      &userInjectData.colorGradingScaling,
      0,
      (sizeof(colorGradingScalingStrings) / sizeof(char*)) - 1,
      colorGradingScalingStrings[userInjectData.colorGradingScaling]
    );
    ImGui::SetItemTooltip("Enables the game's original LUT scaling.");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "Saturation",
      &userInjectData.colorGradingSaturation,
      0,
      100.f,
      "%.0f"
    );
  }

  ImGui::SeparatorText("Effects");
  {
    updateShadersOrPreset |= ImGui::SliderFloat(
      "Bloom",
      &userInjectData.effectBloom,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Controls the strength of the bloom effect.");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "Vignette",
      &userInjectData.effectVignette,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Controls the strength of the vignette effect.");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "Film Grain",
      &userInjectData.effectFilmGrain,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Controls the strength of the custom perceptual film grain.");
  }

  ImGui::EndDisabled();

#ifdef DEBUG_SLIDERS
  ImGui::SeparatorText("Debug Tools");
  {
    updateShaders |= ImGui::SliderFloat(
      "Debug Value 00",
      &userInjectData.debugValue00,
      0.f,
      2.f,
      "%.2f"
    );

    updateShaders |= ImGui::SliderFloat(
      "Debug Value 01",
      &userInjectData.debugValue01,
      0.f,
      2.f,
      "%.2f"
    );
    updateShaders |= ImGui::SliderFloat(
      "Debug Value 02",
      &userInjectData.debugValue02,
      0.f,
      2.f,
      "%.2f"
    );
    updateShaders |= ImGui::SliderFloat(
      "Debug Value 03",
      &userInjectData.debugValue03,
      0.f,
      2.f,
      "%.2f"
    );
  }
#endif

  if (updateShaders || updateShadersOrPreset) {
    updateShaderData();
  }
  if (!changedPreset && updateShadersOrPreset) {
    switch (userInjectData.presetIndex) {
      case 1:
        save_settings(runtime, "renodx-cp2077-preset1");
        break;
      case 2:
        save_settings(runtime, "renodx-cp2077-preset2");
        break;
      case 3:
        save_settings(runtime, "renodx-cp2077-preset3");
        break;
    }
  }
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

      load_settings();
      updateShaderData();

      reshade::register_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
      reshade::register_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

      reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
      reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

      reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

      reshade::register_overlay("RenoDX", on_register_overlay);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline_layout>(on_destroy_pipeline_layout);

      reshade::unregister_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

      reshade::unregister_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

      reshade::register_overlay("RenoDX", on_register_overlay);

      reshade::unregister_addon(hModule);
      break;
  }

  return TRUE;
}
