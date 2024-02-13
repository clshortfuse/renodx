/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H

#include <embed/cp2077.h>

#include <vector>
#include <fstream>
#include <filesystem>
#include <sstream>
#include <shared_mutex>
#include <unordered_set>
#include <unordered_map>
#if 0
  #include "../external/reshade/deps/imgui/imgui.h"
  #include "../external/reshade/include/reshade.hpp"
#else
  #include "C:/Users/clsho/Documents/GitHub/reshade/deps/imgui/imgui.h"
  #include "C:/Users/clsho/Documents/GitHub/reshade/include/reshade.hpp"
#endif

#include "../lib/crc32_hash.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - CP2077";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

std::shared_mutex s_mutex;
std::unordered_set<uint32_t> codeInjections;
std::unordered_set<uint64_t> trackedLayouts;
std::unordered_set<uint64_t> trackedPipelines;
std::unordered_set<uint64_t> loggedTables;
std::unordered_map<uint32_t, uint64_t> replacedComputerShadersToPipelineMap;
std::unordered_map<uint64_t, reshade::api::pipeline_layout> pipeLineToLayoutMap;
std::unordered_map<uint64_t, reshade::api::pipeline_layout> moddedPipelineLayouts;
std::unordered_map<uint64_t, uint32_t> moddedPipelineLayoutsIndex;
std::unordered_map<uint64_t, reshade::api::pipeline> pipelineReplacements;
std::unordered_map<reshade::api::command_list*, reshade::api::pipeline> commandListQueue;

// MUST be 32bit aligned
struct InjectData {
  float toneMapperType;
  float contrast;
  float highlights;
  float shadows;
  float colorGrading;
  float pad02;
  float pad03;
  float pad04;
};

struct UserInjectData {
  int toneMapperType;
  float contrast;
  float highlights;
  float shadows;
  float colorGrading;
};

static UserInjectData userInjectData = {
  2,
  50.0f,
  50.0f,
  50.0f,
  100.f
};

static InjectData injectData = {};

#define TONE_MAPPER_COUNT 5

static const char* toneMapperTypeStrings[TONE_MAPPER_COUNT] = {
  "None",
  "Vanilla",
  "OpenDRT",
  "DICE",
  "ACES",
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

// Before CreateRootSignature
bool on_create_pipeline_layout(
  reshade::api::device* device,
  reshade::api::pipeline_layout_desc* desc) {
  // Clone params with extra slot
  reshade::api::pipeline_layout_param* newParams = new reshade::api::pipeline_layout_param[desc->count + 1];

  const std::unique_lock<std::shared_mutex> lock(s_mutex);

  // Copy up to size of old
  memcpy(newParams, desc->params, sizeof(reshade::api::pipeline_layout_param) * desc->count);

  bool foundVisiblity = false;
  reshade::api::shader_stage defaultVisibility = reshade::api::shader_stage::all;
  uint32_t cbvIndex = 0;

  for (uint32_t paramIndex = 0; paramIndex < desc->count; ++paramIndex) {
    auto param = desc->params[paramIndex];
    auto newParam = desc->params[paramIndex];
    newParam.type = param.type;
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      // Copy ranges should not be needed
      // reshade::api::descriptor_range* newRanges = new reshade::api::descriptor_range[param.descriptor_table.count];
      // memcpy(
      //   newRanges,
      //   param.descriptor_table.ranges,
      //   sizeof(reshade::api::descriptor_range) * param.descriptor_table.count);
      // newParam.descriptor_table.ranges = newRanges;
      // newParam.descriptor_table.count = param.descriptor_table.count;

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
  logLayout(desc->count, desc->params, 0x001);

  // Fill in extra param
  newParams[desc->count].type = reshade::api::pipeline_layout_param_type::push_constants;
  newParams[desc->count].push_constants.binding = 0;
  newParams[desc->count].push_constants.count = sizeof(InjectData) / sizeof(uint32_t);
  newParams[desc->count].push_constants.dx_register_index = cbvIndex;
  newParams[desc->count].push_constants.dx_register_space = 0;
  newParams[desc->count].push_constants.visibility = defaultVisibility;

  std::stringstream s;
  s << "on_init_pipeline_layout++(";
  s << "will insert new push_constant at ";
  s << cbvIndex;
  s << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  logLayout(desc->count + 1, newParams, 0x002);

  desc->count = desc->count + 1;
  desc->params = newParams;

  return true;

  // Write over pointer
  // ID3D12RootSignature*& previousSigPtr = (ID3D12RootSignature*&)layout.handle;
  // ID3D12RootSignature*& newSigPtr = (ID3D12RootSignature*&)newLayout.handle;
  // memcpy(previousSigPtr, newSigPtr, sizeof(ID3D12RootSignature*&));
}

// AfterCreateRootSignature
void on_init_pipeline_layout(
  reshade::api::device* device,
  const uint32_t paramCount,
  const reshade::api::pipeline_layout_param* params,
  reshade::api::pipeline_layout layout) {
  uint32_t cbvIndex = 0;
  for (uint32_t paramIndex = 0; paramIndex < paramCount; ++paramIndex) {
    auto param = params[paramIndex];
    auto newParam = params[paramIndex];
    newParam.type = param.type;
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      // Copy ranges should not be needed
      // reshade::api::descriptor_range* newRanges = new reshade::api::descriptor_range[param.descriptor_table.count];
      // memcpy(
      //   newRanges,
      //   param.descriptor_table.ranges,
      //   sizeof(reshade::api::descriptor_range) * param.descriptor_table.count);
      // newParam.descriptor_table.ranges = newRanges;
      // newParam.descriptor_table.count = param.descriptor_table.count;

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


  std::stringstream s;
  s << "on_init_pipeline_layout++(";
  s << reinterpret_cast<void*>(layout.handle);
  s << " final CBV index is ";
  s << cbvIndex;
  s << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  moddedPipelineLayoutsIndex.emplace(layout.handle, cbvIndex);
}



// Returns shader hash if can be replaced
static uint32_t hasShaderReplacement(
  reshade::api::device_api device_type,
  const reshade::api::shader_desc& desc) {
  if (desc.code_size == 0) return false;


  uint32_t shader_hash = compute_crc32(
    static_cast<const uint8_t*>(desc.code),
    desc.code_size);

  switch (shader_hash) {
    case 0x71f27445: return true;
  }
  return false;
}
static bool injectShader(
  uint32_t shader_hash,
  reshade::api::device_api device_type,
  reshade::api::shader_desc* desc) {
  switch (shader_hash) {
    case 0x71f27445:
      desc->code = &_0x71f27445;
      desc->code_size = sizeof(_0x71f27445);
      break;
    default:
      return false;
  }

  uint32_t new_hash = compute_crc32(static_cast<const uint8_t*>(desc->code), desc->code_size);

  codeInjections.emplace(new_hash);

  std::stringstream s;
  s << "injectShader:replace("
    << "0x" << std::hex << shader_hash << std::dec
    << " => "
    << "0x" << std::hex << new_hash << std::dec
    << " - " << desc->code_size << " bytes"
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  s.clear();

  return true;
}

static bool load_shader_code(
  reshade::api::device_api device_type,
  reshade::api::shader_desc* desc) {
  if (desc->code_size == 0) return false;

  uint32_t shader_hash = compute_crc32(
    static_cast<const uint8_t*>(desc->code),
    desc->code_size);

  switch (shader_hash) {
    case 0x71f27445:
      desc->code = &_0x71f27445;
      desc->code_size = sizeof(_0x71f27445);
      break;
    default:
      return false;
  }

  std::stringstream s;

  uint32_t new_hash = compute_crc32(static_cast<const uint8_t*>(desc->code), desc->code_size);
  codeInjections.emplace(new_hash);
  s << "load_shader_code:replace("
    << "0x" << std::hex << shader_hash << std::dec
    << " => "
    << "0x" << std::hex << new_hash << std::dec
    << " - " << desc->code_size << " bytes"
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());


  return true;
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
        replaced_stages |= load_shader_code(
          device_type,
          static_cast<reshade::api::shader_desc*>(subobjects[i].data));
        break;
    }
  }

  if (replaced_stages) {
    trackedLayouts.emplace(layout.handle);

    std::stringstream s;
    s << "tracking layout handle(" << reinterpret_cast<void*>(layout.handle) << " | " << replaced_stages << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  return replaced_stages;
}

// After CreatePipelineState
static void on_init_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline_layout layout,
  uint32_t subobjectCount,
  const reshade::api::pipeline_subobject* subobjects,
  reshade::api::pipeline pipeline) {
  if (trackedLayouts.find(layout.handle) == trackedLayouts.end()) return;

  pipeLineToLayoutMap.emplace(pipeline.handle, layout);

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

    trackedPipelines.emplace(pipeline.handle);

    std::stringstream s;
    s << "found changed shader ("
      << reinterpret_cast<void*>(pipeline.handle)
      << ", " << reinterpret_cast<void*>(layout.handle)
      << ", " << "0x" << std::hex << shader_hash << std::dec
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    if (subobjects[i].type == reshade::api::pipeline_subobject_type::compute_shader) {
      replacedComputerShadersToPipelineMap.emplace(shader_hash, pipeline.handle);
    }
  }
}

// AfterSetPipelineState
static void on_bind_pipeline(
  reshade::api::command_list* cmd_list,
  reshade::api::pipeline_stage type,
  reshade::api::pipeline pipeline) {
  if (trackedPipelines.find(pipeline.handle) == trackedPipelines.end()) return;

  // const std::unique_lock<std::shared_mutex> lock(s_mutex);

  auto pair0 = pipeLineToLayoutMap.find(pipeline.handle);
  if (pair0 == pipeLineToLayoutMap.end()) return;
  auto layout = pair0->second;

  auto pair2 = moddedPipelineLayoutsIndex.find(layout.handle);
  if (pair2 == moddedPipelineLayoutsIndex.end()) return;
  uint32_t param_index = pair2->second;

  injectData.toneMapperType = static_cast<float>(userInjectData.toneMapperType);
  injectData.contrast = userInjectData.contrast * 0.02f;
  injectData.highlights = userInjectData.highlights * 0.02f;
  injectData.shadows = userInjectData.shadows * 0.02f;
  injectData.colorGrading = userInjectData.colorGrading * 0.01f;

  cmd_list->push_constants(
    reshade::api::shader_stage::all_compute,
    layout,
    param_index,
    0,
    sizeof(InjectData) / sizeof(uint32_t),
    &injectData);
}


static void onRegisterOverlay(reshade::api::effect_runtime*) {
  ImGui::SliderInt(
    "Tone Mapper",
    &userInjectData.toneMapperType,
    0,
    TONE_MAPPER_COUNT - 1,
    toneMapperTypeStrings[userInjectData.toneMapperType],
    ImGuiSliderFlags_NoInput);

  ImGui::SliderFloat(
    "Contrast",
    &userInjectData.contrast,
    0.f,
    100.f,
    "%.0f");

  ImGui::SliderFloat(
    "Highlights",
    &userInjectData.highlights,
    0.f,
    100.f,
    "%.0f");

  ImGui::SliderFloat(
    "Shadows",
    &userInjectData.shadows,
    0.f,
    100.f,
    "%.0f");

  ImGui::SliderFloat(
    "Color Grading",
    &userInjectData.colorGrading,
    0.f,
    100.f,
    "%.0f");
}


BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

      // Before CreateRootSignature
      reshade::register_event<reshade::addon_event::create_pipeline_layout>(on_create_pipeline_layout);

      // After CreateRootSignature
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);

      // Before CreatePipelineState
      reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

      // After CreatePipelineState
      reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);

      // After SetPipelineState
      reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

      reshade::register_overlay("RenoDX", onRegisterOverlay);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(hModule);
      break;
  }

  return TRUE;
}
