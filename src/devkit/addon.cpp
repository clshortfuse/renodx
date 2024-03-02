/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H

#include <array>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <memory>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <Windows.h>

#include <crc32_hash.hpp>

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - DevKit";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX DevKit Module";

struct CachedShader {
  void* data = nullptr;
  size_t size = 0;
  int32_t index = -1;
  std::string source = "";
};

std::shared_mutex s_mutex;
std::unordered_set<uint64_t> computeShaderLayouts;
std::unordered_map<uint64_t, reshade::api::pipeline_layout> pipelineToLayoutMap;
std::unordered_map<uint64_t, uint32_t> pipelineToShaderHash;
std::unordered_map<uint32_t, CachedShader> shaderCache;
std::vector<uint32_t> traceHashes;

static bool traceScheduled = false;
static bool traceRunning = false;
static uint32_t shaderCacheCount = 0;
static uint32_t shaderCacheSize = 0;
static uint32_t traceCount = 0;

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

static void on_init_swapchain(reshade::api::swapchain* swapchain) {
  std::stringstream s;
  s << "init_swapchain"
    << "(colorspace: " << (uint32_t)swapchain->get_color_space()
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

// AfterCreateRootSignature
static void on_init_pipeline_layout(
  reshade::api::device* device,
  const uint32_t paramCount,
  const reshade::api::pipeline_layout_param* params,
  reshade::api::pipeline_layout layout
) {
  logLayout(paramCount, params, layout.handle);

  bool foundVisiblity = false;
  uint32_t cbvIndex = 0;
  uint32_t pcCount = 0;

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

  uint32_t maxCount = 64u - (paramCount + 1u) + 1u;

  std::stringstream s;
  s << "on_init_pipeline_layout++("
    << reinterpret_cast<void*>(layout.handle)
    << " , max injections: " << (maxCount)
    << " )";
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

    // Cache shader

    if (shaderCache.count(shader_hash) == 0) {
      CachedShader cache = {malloc(desc.code_size), desc.code_size};
      memcpy(cache.data, desc.code, cache.size);
      shaderCache.emplace(shader_hash, cache);
      shaderCacheCount++;
      shaderCacheSize += cache.size;
      std::stringstream s;
      s << "caching shader("
        << "hash: 0x" << std::hex << shader_hash << std::dec
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
    pipelineToLayoutMap.emplace(pipeline.handle, layout);
    pipelineToLayoutMap.emplace(pipeline.handle, layout);
    pipelineToShaderHash.emplace(pipeline.handle, shader_hash);

    bool isComputeShader = subobjects[i].type == reshade::api::pipeline_subobject_type::compute_shader;
    if (isComputeShader) {
      computeShaderLayouts.emplace(layout.handle);
    }

    std::stringstream s;
    s << "on_init_pipeline("
      << reinterpret_cast<void*>(pipeline.handle)
      << ", " << reinterpret_cast<void*>(layout.handle)
      << ", hash: 0x" << std::hex << shader_hash << std::dec
      << ", type: " << (isComputeShader ? "compute" : "graphics")
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

static void on_destroy_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline pipeline
) {
  pipelineToLayoutMap.erase(pipeline.handle);
  computeShaderLayouts.erase(pipeline.handle);
  pipelineToShaderHash.erase(pipeline.handle);
}

// AfterSetPipelineState
static void on_bind_pipeline(
  reshade::api::command_list* cmd_list,
  reshade::api::pipeline_stage type,
  reshade::api::pipeline pipeline
) {
  if (!traceRunning) return;
  const std::unique_lock<std::shared_mutex> lock(s_mutex);
  auto pair0 = pipelineToLayoutMap.find(pipeline.handle);
  if (pair0 == pipelineToLayoutMap.end()) return;
  auto layout = pair0->second;

  bool isComputeShader = (computeShaderLayouts.count(layout.handle) != 0);

  uint32_t shader_hash = 0;
  auto pair1 = pipelineToShaderHash.find(pipeline.handle);
  if (pair1 != pipelineToShaderHash.end()) {
    shader_hash = pair1->second;
  }
  if (shader_hash) {
    traceHashes.push_back(shader_hash);
  }

  std::stringstream s;
  s << "bind_pipeline("
    << reinterpret_cast<void*>(pipeline.handle)
    << ", " << reinterpret_cast<void*>(layout.handle)
    << ", " << (isComputeShader ? "compute" : "graphics")
    << ", 0x" << std::hex << shader_hash << std::dec
    << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
}

static void on_bind_pipeline_states(
  reshade::api::command_list* cmd_list,
  uint32_t count,
  const reshade::api::dynamic_state* states,
  const uint32_t* values
) {
  if (!traceRunning) return;

  for (uint32_t i = 0; i < count; i++) {
    std::stringstream s;
    s << "bind_pipeline_state"
      << "(" << uint32_t(states[i])
      << ", " << values[i]
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
}

static bool on_draw(
  reshade::api::command_list* cmd_list,
  uint32_t vertex_count,
  uint32_t instance_count,
  uint32_t first_vertex,
  uint32_t first_instance
) {
  if (traceRunning) {
    std::stringstream s;
    s << "on_draw"
      << "(" << vertex_count
      << ", " << instance_count
      << ", " << first_vertex
      << ", " << first_instance
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
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
  if (traceRunning) {
    std::stringstream s;
    s << "on_draw_indexed"
      << "(" << index_count
      << ", " << instance_count
      << ", " << first_index
      << ", " << vertex_offset
      << ", " << first_instance
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
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
  if (traceRunning) {
    std::stringstream s;
    s << "on_draw_or_dispatch_indirect"
      << "(" << (uint32_t)type
      << ", " << reinterpret_cast<void*>(buffer.handle)
      << ", " << offset
      << ", " << draw_count
      << ", " << stride
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }
  return false;
}

static void on_reshade_present(reshade::api::effect_runtime* runtime) {
  if (traceRunning) {
    reshade::log_message(reshade::log_level::info, "present()");
    reshade::log_message(reshade::log_level::info, "--- End Frame ---");
    traceCount = traceHashes.size();
    traceRunning = false;
  } else if (traceScheduled) {
    traceScheduled = false;
    traceHashes.clear();
    traceRunning = true;
    reshade::log_message(reshade::log_level::info, "--- Frame ---");
  }
}

static const char* findFXC() {
  std::string path = "C:\\Program Files (x86)\\Windows Kits\\10\\bin";
  if (std::filesystem::exists(path) == false) return NULL;

  for (const auto &entry : std::filesystem::directory_iterator(path)) {
    auto fullPath = entry.path();
    fullPath.append(".\\x64\\fxc.exe");
    if (std::filesystem::exists(fullPath)) {
      return fullPath.generic_string().c_str();
    }
  }
  return NULL;
}

std::string exec(const char* cmd) {
  std::array<char, 128> buffer;
  std::string result;
  std::unique_ptr<FILE, decltype(&_pclose)> pipe(_popen(cmd, "r"), _pclose);
  if (!pipe) {
    throw std::runtime_error("popen() failed!");
  }
  while (fgets(buffer.data(), static_cast<int>(buffer.size()), pipe.get()) != nullptr) {
    result += buffer.data();
  }
  return result;
}

std::filesystem::path getShaderPath() {
  wchar_t file_prefix[MAX_PATH] = L"";
  GetModuleFileNameW(nullptr, file_prefix, ARRAYSIZE(file_prefix));

  std::filesystem::path dump_path = file_prefix;
  dump_path = dump_path.parent_path();
  dump_path /= ".\\renodx-dev";
  return dump_path;
}

void dumpShader(uint32_t shader_hash) {
  auto dump_path = getShaderPath();

  if (std::filesystem::exists(dump_path) == false) {
    std::filesystem::create_directory(dump_path);
  }
  wchar_t hash_string[11];
  swprintf_s(hash_string, L"0x%08X", shader_hash);

  dump_path /= hash_string;
  dump_path += L".cso";

  auto cachedShader = shaderCache.find(shader_hash)->second;

  std::ofstream file(dump_path, std::ios::binary);

  file.write(static_cast<const char*>(cachedShader.data), cachedShader.size);
}

char* dumpFXC(uint32_t shader_hash, bool force = false) {
  auto fxcExePath = findFXC();
  if (fxcExePath == NULL) {
    reshade::log_message(reshade::log_level::warning, "fxc.exe not found.");
  }

  // Prepend executable directory to image files
  auto shaderPath = getShaderPath();
  if (std::filesystem::exists(shaderPath) == false) {
    std::filesystem::create_directory(shaderPath);
  }

  auto csoPath = shaderPath;
  wchar_t hash_string[11];
  swprintf_s(hash_string, L"0x%08X", shader_hash);

  csoPath /= hash_string;
  auto fxcPath = csoPath;

  csoPath += L".cso";
  fxcPath += L".fxc";

  if (std::filesystem::exists(fxcPath) == false) {
    if (std::filesystem::exists(csoPath) == false) {
      dumpShader(shader_hash);
    }

    std::stringstream command;
    command << "\""
            << "\""
            << fxcExePath
            << "\""
            << " -dumpbin "
            << "\""
            << csoPath.generic_string()
            << "\" > \""
            << fxcPath.generic_string()
            << "\""
            << "\"";

    // Causes application focus to blur
    std::system(command.str().c_str());
  }

  std::ifstream file(fxcPath, std::ios::binary);

  file.seekg(0, std::ios::end);
  size_t fileSize = file.tellg();
  char* code = reinterpret_cast<char*>(malloc((fileSize + 1) * sizeof(char)));
  file.seekg(0, std::ios::beg).read(code, fileSize);
  code[fileSize] = NULL;

  return code;
}

// @see https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
static void on_register_overlay(reshade::api::effect_runtime* runtime) {
  if (ImGui::Button("Trace")) {
    traceScheduled = true;
  }
  ImGui::SameLine();
  ImGui::Text("Traced Shaders: %d", traceCount);

  ImGui::Text("Cached Shaders: %d", shaderCacheCount);
  ImGui::Text("Cached Shaders Size: %d", shaderCacheSize);
  static int32_t selectedIndex = -1;
  bool changedSelected = false;
  if (ImGui::BeginChild("HashList", ImVec2(100, -FLT_MIN), ImGuiChildFlags_ResizeX)) {
    if (ImGui::BeginListBox("##HashesListbox", ImVec2(-FLT_MIN, -FLT_MIN))) {
      if (!traceRunning) {
        for (auto index = 0; index < traceCount; index++) {
          auto hash = traceHashes.at(index);
          const bool isSelected = (selectedIndex == index);
          std::stringstream name;
          name << std::setfill('0') << std::setw(3) << index << std::setw(0)
               << " - 0x" << std::hex << hash;
          if (ImGui::Selectable(name.str().c_str(), isSelected)) {
            selectedIndex = index;
            changedSelected = true;
          }

          if (isSelected) {
            ImGui::SetItemDefaultFocus();
          }
        }
      }
      ImGui::EndListBox();
    }
    ImGui::EndChild();
  }

  ImGui::SameLine();

  static std::string sourceCode = "";
  if (ImGui::BeginChild("HashDetails", ImVec2(-FLT_MIN, -FLT_MIN))) {
    ImGui::BeginDisabled(selectedIndex == -1);
    if (changedSelected) {
      auto hash = traceHashes.at(selectedIndex);
      auto cache = shaderCache.find(hash)->second;
      if (cache.source.length() == 0) {
        char* fxc = dumpFXC(hash);
        cache.source.assign(fxc);
        free(fxc);
      }
      sourceCode.assign(cache.source);
    }

    if (ImGui::BeginChild("HashSourceCode", ImVec2(-FLT_MIN, -FLT_MIN), ImGuiChildFlags_None, ImGuiWindowFlags_HorizontalScrollbar | ImGuiWindowFlags_AlwaysVerticalScrollbar)) {
      ImGui::InputTextMultiline(
        "##source",
        (char*)sourceCode.c_str(),
        sourceCode.length(),
        ImVec2(-FLT_MIN, -FLT_MIN),
        ImGuiInputTextFlags_ReadOnly
      );
      ImGui::EndChild();
    }
    ImGui::EndChild();
    ImGui::EndDisabled();
  }
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

      reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);
      reshade::register_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

      reshade::register_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline_states>(on_bind_pipeline_states);

      reshade::register_event<reshade::addon_event::draw>(on_draw);
      reshade::register_event<reshade::addon_event::draw_indexed>(on_draw_indexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(on_draw_or_dispatch_indirect);

      reshade::register_event<reshade::addon_event::reshade_present>(on_reshade_present);

      reshade::register_overlay("RenoDX (DevKit)", on_register_overlay);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(on_init_pipeline_layout);

      reshade::unregister_event<reshade::addon_event::init_pipeline>(on_init_pipeline);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(on_destroy_pipeline);

      reshade::unregister_event<reshade::addon_event::bind_pipeline>(on_bind_pipeline);

      reshade::unregister_event<reshade::addon_event::reshade_present>(on_reshade_present);

      reshade::unregister_overlay("RenoDX (DevKit)", on_register_overlay);

      reshade::unregister_addon(hModule);
      break;
  }

  return TRUE;
}
