/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define DEBUG_LEVEL_0

#include <embed/0x71F27445.h>
#include <embed/0x97CA5A85.h>

#include <vector>
#include <fstream>
#include <filesystem>
#include <sstream>
#include <shared_mutex>
#include <unordered_set>
#include <unordered_map>

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
std::unordered_set<uint32_t> codeInjections;
std::unordered_set<uint64_t> trackedLayouts;
std::unordered_set<uint64_t> computeShaderLayouts;
std::unordered_map<uint64_t, reshade::api::pipeline_layout> pipelineToLayoutMap;
std::unordered_map<uint64_t, uint32_t> moddedPipelineLayoutsIndex;

// MUST be 4x32bit aligned
ShaderInjectData shaderInjectData;

struct UserInjectData {
  float toneMapperPaperWhite = 203.f;
  int toneMapperType = 2;
  float toneMapperExposure = 1.f;
  float toneMapperContrast = 50.f;
  float toneMapperHighlights = 50.f;
  float toneMapperShadows = 50.f;
  int colorGradingWorkflow = 1;
  float colorGradingStrength = 100.f;
  int colorGradingScaling = 0;
  float colorGradingLift = 0.f;
  float colorGradingGamma = 1.f;
  float colorGradingGain = 1.f;
} userInjectData;

static void updateShaderData() {
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  shaderInjectData.toneMapperType = static_cast<float>(userInjectData.toneMapperType);
  shaderInjectData.toneMapperPaperWhite = userInjectData.toneMapperPaperWhite;
  shaderInjectData.toneMapperExposure = userInjectData.toneMapperExposure;
  shaderInjectData.toneMapperContrast = userInjectData.toneMapperContrast * 0.02f;
  shaderInjectData.toneMapperHighlights = userInjectData.toneMapperHighlights * 0.02f;
  shaderInjectData.toneMapperShadows = userInjectData.toneMapperShadows * 0.02f;
  shaderInjectData.colorGradingWorkflow = static_cast<float>(userInjectData.colorGradingWorkflow - 1);
  shaderInjectData.colorGradingStrength = userInjectData.colorGradingStrength * 0.01f;
  shaderInjectData.colorGradingScaling = static_cast<float>(userInjectData.colorGradingScaling);
  shaderInjectData.colorGradingLift = userInjectData.colorGradingLift;
  shaderInjectData.colorGradingGamma = userInjectData.colorGradingGamma;
  shaderInjectData.colorGradingGain = userInjectData.colorGradingGain;
}

static const char* toneMapperTypeStrings[] = {
  "None",
  "Vanilla",
  "OpenDRT",
  "DICE",
  "ACES",
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
  uint32_t tag) {
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
  reshade::api::shader_desc* desc) {
  if (desc->code_size == 0) return false;

  uint32_t shader_hash = compute_crc32(
    static_cast<const uint8_t*>(desc->code),
    desc->code_size);

  switch (shader_hash) {
    case 0x71F27445:
      desc->code = &_0x71F27445;
      desc->code_size = sizeof(_0x71F27445);
      break;
    case 0x97CA5A85:
      desc->code = &_0x97CA5A85;
      desc->code_size = sizeof(_0x97CA5A85);
      break;
    default:
      return false;
  }

  uint32_t new_hash = compute_crc32(static_cast<const uint8_t*>(desc->code), desc->code_size);
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
  reshade::api::pipeline_layout_desc* desc) {
  bool foundVisiblity = false;
  reshade::api::shader_stage defaultVisibility = reshade::api::shader_stage::all;
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

        if (!foundVisiblity) {
          defaultVisibility = range.visibility;
          foundVisiblity = true;
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

  // Copy up to size of old
  memcpy(newParams, desc->params, sizeof(reshade::api::pipeline_layout_param) * oldCount);

  // Fill in extra param
  newParams[oldCount].type = reshade::api::pipeline_layout_param_type::push_constants;
  newParams[oldCount].push_constants.binding = 0;
  newParams[oldCount].push_constants.count = sizeof(ShaderInjectData) / sizeof(uint32_t);
  newParams[oldCount].push_constants.dx_register_index = cbvIndex;
  newParams[oldCount].push_constants.dx_register_space = 0;
  newParams[oldCount].push_constants.visibility = defaultVisibility;

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
  reshade::api::pipeline_layout layout) {
  uint32_t cbvIndex = 0;
  for (uint32_t paramIndex = 0; paramIndex < paramCount; ++paramIndex) {
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
      // TODO(clshortfuse): Log actual index (and not assume)
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
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  moddedPipelineLayoutsIndex.emplace(layout.handle, cbvIndex);

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "on_init_pipeline_layout++(";
  s << reinterpret_cast<void*>(layout.handle);
  s << " final CBV index is ";
  s << cbvIndex;
  s << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
}

static void on_destroy_pipeline_layout(
  reshade::api::device* device,
  reshade::api::pipeline_layout layout) {
  uint32_t changed = false;
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  changed |= moddedPipelineLayoutsIndex.erase(layout.handle);
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
  const reshade::api::pipeline_subobject* subobjects) {
  bool replaced_stages = false;
  const reshade::api::device_api device_type = device->get_api();

  for (uint32_t i = 0; i < subobject_count; ++i) {
    switch (subobjects[i].type) {
      case reshade::api::pipeline_subobject_type::compute_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:
        replaced_stages |= load_embedded_shader(
          device_type,
          static_cast<reshade::api::shader_desc*>(subobjects[i].data));
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
  reshade::api::pipeline pipeline) {
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
      << ", " << "0x" << std::hex << shader_hash << std::dec
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
  }
}

static void on_destroy_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline pipeline) {
  uint32_t changed = false;
  changed |= pipelineToLayoutMap.erase(pipeline.handle);
  changed |= computeShaderLayouts.erase(pipeline.handle);
  if (!changed) return;

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "on_destroy_pipeline(";
  s << reinterpret_cast<void*>(pipeline.handle);
  s << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
}



// AfterSetPipelineState
static void on_bind_pipeline(
  reshade::api::command_list* cmd_list,
  reshade::api::pipeline_stage type,
  reshade::api::pipeline pipeline) {
  auto pair0 = pipelineToLayoutMap.find(pipeline.handle);
  if (pair0 == pipelineToLayoutMap.end()) return;
  auto layout = pair0->second;

  auto pair2 = moddedPipelineLayoutsIndex.find(layout.handle);
  if (pair2 == moddedPipelineLayoutsIndex.end()) return;
  uint32_t param_index = pair2->second;

  reshade::api::shader_stage stage = (computeShaderLayouts.find(layout.handle) != computeShaderLayouts.end())
    ? reshade::api::shader_stage::all_compute
    : reshade::api::shader_stage::all_graphics;

  const std::shared_lock<std::shared_mutex> lock(s_mutex);
  cmd_list->push_constants(
    stage,
    layout,
    param_index,
    0,
    sizeof(ShaderInjectData) / sizeof(uint32_t),
    &shaderInjectData);

#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "bind_pipeline++("
    << reinterpret_cast<void*>(pipeline.handle)
    << ", " << reinterpret_cast<void*>(layout.handle)
    << ", " << param_index
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
}

static void on_register_overlay(reshade::api::effect_runtime*) {
  bool updated = false;

  ImGui::SeparatorText("Tone Mapping");
  {
    updated |= ImGui::SliderInt(
      "Tone Mapper",
      &userInjectData.toneMapperType,
      0,
      (sizeof(toneMapperTypeStrings) / sizeof(char*)) - 1,
      toneMapperTypeStrings[userInjectData.toneMapperType],
      ImGuiSliderFlags_NoInput);

    updated |= ImGui::SliderFloat(
      "Exposure",
      &userInjectData.toneMapperExposure,
      0.f,
      10.f,
      "%.0f");
    ImGui::SetItemTooltip("Input scaling factor before passing to tone mapper.");


    ImGui::BeginDisabled(userInjectData.toneMapperType != 2 && userInjectData.toneMapperType != 4);
    updated |= ImGui::SliderFloat(
      "Paperwhite",
      &userInjectData.toneMapperPaperWhite,
      80.f,
      500.f,
      "%.0f");
    ImGui::SetItemTooltip("Adjusts the brightness of 100%% white.");
    ImGui::EndDisabled();

    ImGui::BeginDisabled(userInjectData.toneMapperType != 2);
    updated |= ImGui::SliderFloat(
      "Contrast",
      &userInjectData.toneMapperContrast,
      0.f,
      100.f,
      "%.0f");
    ImGui::SetItemTooltip("Adjusts tone mapper's contrast factor (if avilable).");
    ImGui::EndDisabled();

    ImGui::BeginDisabled(userInjectData.toneMapperType != 2);
    updated |= ImGui::SliderFloat(
      "Highlights",
      &userInjectData.toneMapperHighlights,
      0.f,
      100.f,
      "%.0f");
    ImGui::EndDisabled();

    ImGui::BeginDisabled(userInjectData.toneMapperType != 2 && userInjectData.toneMapperType != 4);
    updated |= ImGui::SliderFloat(
      "Shadows",
      &userInjectData.toneMapperShadows,
      0.f,
      100.f,
      "%.0f");
    ImGui::SetItemTooltip("Adjusts tone mapper's shadows or black level (if avilable).");
    ImGui::EndDisabled();
  }

  ImGui::SeparatorText("Color Grading");
  {
    updated |= ImGui::SliderInt(
      "Workflow",
      &userInjectData.colorGradingWorkflow,
      0,
      (sizeof(colorGradingWorkflowStrings) / sizeof(char*)) - 1,
      colorGradingWorkflowStrings[userInjectData.colorGradingWorkflow],
      ImGuiSliderFlags_NoInput);
    ImGui::SetItemTooltip("Modifies order of when color grading is applied.");

    updated |= ImGui::SliderFloat(
      "Strength",
      &userInjectData.colorGradingStrength,
      0.f,
      100.f,
      "%.0f");
    ImGui::SetItemTooltip("Modifies the strength of the LUT application.");

    updated |= ImGui::SliderInt(
      "Scaling",
      &userInjectData.colorGradingScaling,
      0,
      (sizeof(colorGradingScalingStrings) / sizeof(char*)) - 1,
      colorGradingScalingStrings[userInjectData.colorGradingScaling]);
    ImGui::SetItemTooltip("Enables the game's original LUT scaling.");


    ImGui::BeginDisabled();
    updated |= ImGui::SliderFloat(
      "Lift",
      &userInjectData.colorGradingLift,
      -2.f,
      2.f,
      "%.1f");

    updated |= ImGui::SliderFloat(
      "Gamma",
      &userInjectData.colorGradingGamma,
      0.f,
      4.f,
      "%.1f");

    updated |= ImGui::SliderFloat(
      "Gain",
      &userInjectData.colorGradingGain,
      0.f,
      4.f,
      "%.1f");

    ImGui::EndDisabled();
  }

  if (updated) {
    updateShaderData();
  }
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

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
