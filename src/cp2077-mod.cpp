/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <vector>
#include <fstream>
#include <filesystem>
#include <sstream>
#include "../external/reshade/include/reshade.hpp"
#include "../lib/crc32_hash.hpp"

static thread_local std::vector<std::vector<uint8_t>> s_data_to_delete;

static bool load_shader_code(
  reshade::api::device_api device_type,
  reshade::api::shader_desc& desc,
  std::vector<std::vector<uint8_t>>& data_to_delete)
{
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
  } else if (device_type == reshade::api::device_api::opengl) {
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
  s << "load_shader_code:exist(" << true << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  s.clear();

  std::ifstream file(replace_path, std::ios::binary);
  file.seekg(0, std::ios::end);
  std::vector<uint8_t> shader_code(static_cast<size_t>(file.tellg()));
  file.seekg(0, std::ios::beg).read(reinterpret_cast<char*>(shader_code.data()), shader_code.size());

  // Keep the shader code memory alive after returning from this 'create_pipeline' event callback
  // It may only be freed after the 'init_pipeline' event was called for this pipeline
  data_to_delete.push_back(std::move(shader_code));

  desc.code = data_to_delete.back().data();
  desc.code_size = data_to_delete.back().size();

  s << "load_shader_code:replace(" << hash_string << " - " << data_to_delete.back().size() << ")";
  reshade::log_message(reshade::log_level::info, s.str().c_str());
  s.clear();

  return true;
}

static bool on_create_pipeline(
  reshade::api::device* device,
  reshade::api::pipeline_layout layout,
  uint32_t subobject_count,
  const reshade::api::pipeline_subobject* subobjects)
{
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
    std::stringstream s;
    s << "create_pipeline(" << replaced_stages << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  // Return whether any shader code was replaced
  return replaced_stages;
}
static void on_after_create_pipeline(
  reshade::api::device*,
  reshade::api::pipeline_layout,
  uint32_t,
  const reshade::api::pipeline_subobject*,
  reshade::api::pipeline) {
  // Free the memory allocated in the 'load_shader_code' call above
  s_data_to_delete.clear();
}

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - CP2077";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
  case DLL_PROCESS_ATTACH:
    if (!reshade::register_addon(hModule))
      return FALSE;
    reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
    reshade::register_event<reshade::addon_event::init_pipeline>(on_after_create_pipeline);
    break;
  case DLL_PROCESS_DETACH:
    reshade::unregister_addon(hModule);
    break;
  }

  return TRUE;
}
