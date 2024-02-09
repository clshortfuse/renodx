/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H

#include <vector>
#include <fstream>
#include <filesystem>
#include <sstream>
#include <shared_mutex>
#include <unordered_set>
#include <unordered_map>
#include "../external/reshade/deps/imgui/imgui.h"
#include "../external/reshade/include/reshade.hpp"
#include "../lib/crc32_hash.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - CP2077";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

static thread_local std::vector<std::vector<uint8_t>> s_data_to_delete;

std::shared_mutex s_mutex;
std::unordered_set<uint32_t> codeInjections;
std::unordered_set<uint64_t> trackedLayouts;
std::unordered_set<uint64_t> trackedPipelines;
std::unordered_set<uint64_t> loggedTables;
std::unordered_map<uint32_t, uint64_t> replacedComputerShadersToPipelineMap;
std::unordered_map<uint64_t, uint64_t> pipeLineToLayoutMap;
std::unordered_map<uint64_t, reshade::api::pipeline_layout> moddedPipelineLayouts;
std::unordered_map<uint64_t, uint32_t> moddedPipelineLayoutsIndex;
std::unordered_map<uint64_t, reshade::api::pipeline> pipelineReplacements;
std::unordered_map<reshade::api::command_list*, reshade::api::pipeline_layout> commandListQueue;


struct InjectData {
  int32_t toneMapperType;
};

static InjectData injectData;


static int toneMapperType = 0;
#define TONE_MAPPER_COUNT 5

static const char* toneMapperTypeStrings[TONE_MAPPER_COUNT] = {
  "None",
  "Vanilla",
  "OpenDRT",
  "DICE",
  "ACES",
};

// AfterCreateRootSignature
void on_init_pipeline_layout(
  reshade::api::device* device,
  const uint32_t paramCount,
  const reshade::api::pipeline_layout_param* params,
  reshade::api::pipeline_layout layout) {
  // Clone params with extra slot
  reshade::api::pipeline_layout_param* newParams = new reshade::api::pipeline_layout_param[paramCount + 1];
  memcpy(newParams, params, sizeof(params));

  bool foundVisiblity = false;
  reshade::api::shader_stage defaultVisibility = reshade::api::shader_stage::all;
  uint32_t cbvIndex = 0;

  for (uint32_t paramIndex = 0; paramIndex < paramCount; ++paramIndex) {
    auto param = params[paramIndex];
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      // Copy ranges
      // reshade::api::descriptor_range* newRanges = new reshade::api::descriptor_range[param.descriptor_table.count];
      // memcpy(
      //   newRanges,
      //   param.descriptor_table.ranges,
      //   sizeof(reshade::api::descriptor_range) * param.descriptor_table.count);
      // newParams[paramIndex].descriptor_table.ranges = newRanges;

      for (uint32_t rangeIndex = 0; rangeIndex < param.descriptor_table.count; ++rangeIndex) {
        auto range = param.descriptor_table.ranges[rangeIndex];
        std::stringstream s;
        s << "on_init_pipeline_layout(";
        s << reinterpret_cast<void*>(layout.handle);
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
          if (cbvIndex < range.dx_register_index + range.count) {
            cbvIndex = range.dx_register_index + range.count;
          }
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

        if (!foundVisiblity) {
          defaultVisibility = range.visibility;
          foundVisiblity = true;
        }
        s << " | " << range.array_size
          << " | " << range.binding
          << " | " << range.count
          << " | " << range.dx_register_index
          << " | " << range.dx_register_space
          << " | " << (uint32_t)range.visibility
          << ")"
          << " [" << paramIndex << "/" << paramCount << "]"
          << " [" << rangeIndex << "/" << param.descriptor_table.count << "]";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
    } else if (param.type == reshade::api::pipeline_layout_param_type::push_constants) {
      if (cbvIndex < param.push_constants.dx_register_index + param.push_constants.count) {
        cbvIndex = param.push_constants.dx_register_index + param.push_constants.count;
      }
    }
  }
  newParams[paramCount].type = reshade::api::pipeline_layout_param_type::push_constants;
  newParams[paramCount].push_constants.binding = 0;
  newParams[paramCount].push_constants.count = 1;
  newParams[paramCount].push_constants.dx_register_index = cbvIndex;
  newParams[paramCount].push_constants.dx_register_space = 0;
  newParams[paramCount].push_constants.visibility = defaultVisibility;
  std::stringstream s;
  s << "on_init_pipeline_layout++(";
  s << reinterpret_cast<void*>(layout.handle);
  s << " will insert new push_constant at ";
  s << cbvIndex;
  s << " )";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  // Making new rootsig...
  reshade::api::pipeline_layout newLayout = {};
  std::stringstream s2;
  s2 << "on_init_pipeline_layout+++("
    << reinterpret_cast<void*>(layout.handle);
  if (!device->create_pipeline_layout(paramCount + 1, newParams, &newLayout)) {
    s2 << " failed to";
  }
  s2 << " created new pipeline layout "
    << reinterpret_cast<void*>(newLayout.handle)
    << " )";
  reshade::log_message(reshade::log_level::info, s2.str().c_str());

  moddedPipelineLayouts.emplace(layout.handle, newLayout);
  moddedPipelineLayoutsIndex.emplace(newLayout.handle, cbvIndex);
}

static bool load_shader_code(
  reshade::api::device_api device_type,
  reshade::api::shader_desc& desc,
  std::vector<std::vector<uint8_t>>& data_to_delete) {
  if (desc.code_size == 0) return false;

  uint32_t shader_hash = compute_crc32(
    static_cast<const uint8_t*>(desc.code),
    desc.code_size);

  const wchar_t* extension = L".cso";
  if (device_type == reshade::api::device_api::vulkan ||
    (device_type == reshade::api::device_api::opengl
      && desc.code_size > sizeof(uint32_t)
      && *static_cast<const uint32_t*>(desc.code) == 0x07230203 /* SPIR-V magic */)
    ) {
    // Vulkan uses SPIR-V (and sometimes OpenGL does too)
    extension = L".spv";
  }
  else if (device_type == reshade::api::device_api::opengl) {
    // OpenGL otherwise uses plain text GLSL
    extension = L".glsl";
  }

  // Prepend executable file name to image files
  wchar_t file_prefix[MAX_PATH] = L"";
  GetModuleFileNameW(nullptr, file_prefix, ARRAYSIZE(file_prefix));

  std::filesystem::path replace_path = file_prefix;
  replace_path = replace_path.parent_path();
  replace_path /= ".\\shaderreplace";

  wchar_t hash_string[11];
  swprintf_s(hash_string, L"0x%08X", shader_hash);

  replace_path /= hash_string;
  replace_path += extension;

  // Check if a replacement file for this shader hash exists and if so, overwrite the shader code with its contents
  if (!std::filesystem::exists(replace_path))
    return false;

  std::stringstream s;

  std::ifstream file(replace_path, std::ios::binary);
  file.seekg(0, std::ios::end);
  std::vector<uint8_t> shader_code(static_cast<size_t>(file.tellg()));
  file.seekg(0, std::ios::beg).read(reinterpret_cast<char*>(shader_code.data()), shader_code.size());



  // Keep the shader code memory alive after returning from this 'create_pipeline' event callback
  // It may only be freed after the 'init_pipeline' event was called for this pipeline
  data_to_delete.push_back(std::move(shader_code));

  desc.code = data_to_delete.back().data();
  desc.code_size = data_to_delete.back().size();

  uint32_t new_hash = compute_crc32(static_cast<const uint8_t*>(desc.code), desc.code_size);

  codeInjections.emplace(new_hash);

  s << "load_shader_code:replace("
    << "0x" << std::hex << shader_hash << std::dec
    << " => "
    << "0x" << std::hex << new_hash << std::dec
    << " - " << desc.code_size << " bytes"
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  s.clear();

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

  // Go through all shader stages that are in this pipeline and potentially replace the associated shader code

  for (uint32_t i = 0; i < subobject_count; ++i) {
    switch (subobjects[i].type) {
    case reshade::api::pipeline_subobject_type::compute_shader:
    case reshade::api::pipeline_subobject_type::pixel_shader:
      replaced_stages |= load_shader_code(
        device_type,
        *static_cast<reshade::api::shader_desc*>(subobjects[i].data), s_data_to_delete);
      break;
    }
  }

  if (replaced_stages) {
    // Create clone pipeline with new layout

    std::stringstream s;
    s << "tracking layout handle(" << reinterpret_cast<void*>(layout.handle) << " | " << replaced_stages << ")";

    trackedLayouts.emplace(layout.handle);

    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  // Return whether any shader code was replaced
  return replaced_stages;
}

// After CreatePipelineState
static void on_init_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline_layout layout,
  uint32_t subobjectCount,
  const reshade::api::pipeline_subobject* subobjects,
  reshade::api::pipeline pipeline) {
  // Free the memory allocated in the 'load_shader_code' call above
  s_data_to_delete.clear();

  // Ignore unmodified layouts...
  if (trackedLayouts.find(layout.handle) == trackedLayouts.end()) return;

  // const std::unique_lock<std::shared_mutex> lock(s_mutex);

  pipeLineToLayoutMap.emplace(pipeline.handle, layout.handle);

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

    uint64_t newPipelineLayoutHandle = 0;
    auto pair = moddedPipelineLayouts.find(layout.handle);

    if (pair != moddedPipelineLayouts.end()) {
      reshade::api::pipeline_layout newLayout = (pair->second);
      newPipelineLayoutHandle = newLayout.handle;
    }

    trackedPipelines.emplace(pipeline.handle);

    std::stringstream s;
    s << "found changed shader ("
      << reinterpret_cast<void*>(pipeline.handle)
      << ", " << reinterpret_cast<void*>(layout.handle)
      << ", " << reinterpret_cast<void*>(newPipelineLayoutHandle)
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
  // Skip if not tracked
  if (trackedPipelines.find(pipeline.handle) == trackedPipelines.end()) return;

  // Find expected layout
  auto pair0 = pipeLineToLayoutMap.find(pipeline.handle);
  if (pair0 == pipeLineToLayoutMap.end()) return;
  auto layoutHandle = pair0->second;
  // Should now replace pipeline layout for pipeline

  auto pair1 = moddedPipelineLayouts.find(layoutHandle);
  if (pair1 == moddedPipelineLayouts.end()) return;
  auto newLayout = pair1->second;

  auto pair2 = moddedPipelineLayoutsIndex.find(newLayout.handle);
  if (pair2 == moddedPipelineLayoutsIndex.end()) return;
  uint32_t param_index = pair2->second;

  commandListQueue.emplace(cmd_list, newLayout);

  // cmd_list->push_constants(
  //   reshade::api::shader_stage::all_compute,
  //   newLayout,
  //   param_index,
  //   0,
  //   1,
  //   &injectData);

  std::stringstream s;
  s << "bind_pipeline++("
    << reinterpret_cast<void*>(pipeline.handle)
    << " , " << reinterpret_cast<void*>(layoutHandle)
    << " => "
    << reinterpret_cast<void*>(newLayout.handle)
    << " , " << param_index
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

}

// Before Dispatch
bool on_dispatch(
  reshade::api::command_list* cmd_list,
  uint32_t group_count_x,
  uint32_t group_count_y,
  uint32_t group_count_z) {
  auto pair = commandListQueue.find(cmd_list);
  if (pair == commandListQueue.end()) return false;
  auto newLayout = pair->second;
  commandListQueue.erase(pair);

  auto pair2 = moddedPipelineLayoutsIndex.find(newLayout.handle);
  if (pair2 == moddedPipelineLayoutsIndex.end()) return false;
  uint32_t param_index = pair2->second;

  injectData.toneMapperType = toneMapperType;

  cmd_list->push_constants(
    reshade::api::shader_stage::all,
    newLayout,
    param_index,
    0,
    sizeof(injectData) / sizeof(uint32_t),
    &injectData);

  std::stringstream s;
  s << "dispatch++("
    << reinterpret_cast<void*>(newLayout.handle)
    << ", " << group_count_x
    << ", " << group_count_y
    << ", " << group_count_z
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());

  return false;
}


static void onRegisterOverlay(reshade::api::effect_runtime*) {
  ImGui::SliderInt(
    "Tone Mapper",
    &toneMapperType,
    0,
    TONE_MAPPER_COUNT - 1,
    toneMapperTypeStrings[toneMapperType],
    ImGuiSliderFlags_NoInput);
}


BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
  case DLL_PROCESS_ATTACH:
    if (!reshade::register_addon(hModule))
      return FALSE;

    // AfterCreateRootSignature
    reshade::register_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);

    // Before CreatePipelineState
    reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

    // After CreatePipelineState
    reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);


    reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

    // reshade::register_event<reshade::addon_event::push_constants>(on_push_constants);

    // reshade::register_event<reshade::addon_event::bind_descriptor_tables>(on_bind_descriptor_tables);

    reshade::register_event<reshade::addon_event::dispatch>(on_dispatch);


    reshade::register_overlay("RenoDX", onRegisterOverlay);
    break;
  case DLL_PROCESS_DETACH:
    reshade::unregister_addon(hModule);
    break;
  }

  return TRUE;
}
