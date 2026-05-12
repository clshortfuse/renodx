/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <charconv>
#include <cstdint>
#include <filesystem>
#include <shared_mutex>
#include <span>
#include <sstream>
#include <string>
#include <unordered_set>
#include <utility>

#include <include/reshade.hpp>

#include "./cross_addon.hpp"
#include "./device.hpp"
#include "./format.hpp"
#include "./path.hpp"
#include "./shader.hpp"
#include "./shader_compiler_directx.hpp"

namespace renodx::utils::shader::dump {

namespace internal {
struct ShaderInfo {
  cross_addon::vector<uint8_t> data;
  reshade::api::pipeline_subobject_type type = reshade::api::pipeline_subobject_type::unknown;
  reshade::api::device_api device_api = reshade::api::device_api::d3d11;
  bool dumped = false;
  bool pending = false;
};

using ShaderInfoMap = cross_addon::parallel_node_hash_map<uint32_t, ShaderInfo, std::shared_mutex>;

struct __declspec(uuid("26b8e4e9-8ed4-4fc5-b3e6-d7e64d7f7a9f")) SharedData {
  ShaderInfoMap shaders;
  std::atomic_size_t pending_dump_count = 0;
  std::atomic_bool scanned_disk = false;
};

static cross_addon::Shared<SharedData> shared;

static constexpr std::string GetFileExtensionFromDeviceApi(reshade::api::device_api device_api) {
  switch (device_api) {
    case reshade::api::device_api::d3d9:
    case reshade::api::device_api::d3d10:
    case reshade::api::device_api::d3d11:
    case reshade::api::device_api::d3d12:
      return ".cso";
    case reshade::api::device_api::vulkan:
      return ".spv";
    case reshade::api::device_api::opengl:
      return ".glsl";
    default:
      return ".bin";
  }
}

static void CheckShadersOnDisk(const reshade::api::device_api device_api = reshade::api::device_api::d3d11) {
  auto* data = shared.data;
  if (data == nullptr) return;

  data->scanned_disk = true;

  auto dump_path = renodx::utils::path::GetOutputPath();

  if (!std::filesystem::exists(dump_path)) return;
  dump_path /= "dump";
  if (!std::filesystem::exists(dump_path)) return;
  std::unordered_set<uint32_t> shader_hashes_found = {};

  auto extension = GetFileExtensionFromDeviceApi(device_api);
  for (const auto& entry : std::filesystem::directory_iterator(dump_path)) {
    if (!entry.is_regular_file()) continue;
    const auto& entry_path = entry.path();
    if (entry_path.extension() != extension) continue;
    const auto& basename = entry_path.stem().string();
    if (basename.length() < 2 + 8) continue;
    if (!basename.starts_with("0x")) continue;
    auto hash_string = basename.substr(2, 8);
    uint32_t shader_hash = 0u;
    const auto [hash_end, hash_error] = std::from_chars(
        hash_string.data(),
        hash_string.data() + hash_string.size(),
        shader_hash,
        16);
    if (hash_error != std::errc{} || hash_end != hash_string.data() + hash_string.size()) {
      std::stringstream s;
      s << "utils::shader::dump(Invalid shader string: ";
      s << hash_string;
      s << " at ";
      s << entry_path;
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      continue;
    }
    auto [iterator, new_insert] = shader_hashes_found.insert(shader_hash);
    if (!new_insert) {
      std::stringstream s;
      s << "utils::shader::dump(Found duplicate shader: ";
      s << PRINT_CRC32(shader_hash);
      s << " at ";
      s << entry_path;
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    } else {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "utils::shader::dump(Found shader: ";
      s << PRINT_CRC32(shader_hash);
      s << " at ";
      s << entry_path;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    }
  }

  for (const auto& shader_hash : shader_hashes_found) {
    data->shaders.lazy_emplace_l(
        shader_hash,
        [data](std::pair<const uint32_t, ShaderInfo>& pair) {
          if (pair.second.pending && data->pending_dump_count.load() > 0u) {
            data->pending_dump_count.fetch_sub(1u);
          }
          pair.second.data.clear();
          pair.second.dumped = true;
          pair.second.pending = false;
        },
        [shader_hash](const ShaderInfoMap::constructor& ctor) {
          ShaderInfo shader_info = {};
          shader_info.dumped = true;
          ctor(shader_hash, std::move(shader_info));
        });
  }
}

static void OnInitDevice(reshade::api::device* device) {
  if (internal::shared.data->scanned_disk.load()) return;
  internal::CheckShadersOnDisk(device->get_api());
}

// After CreatePipelineState
static void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  if (device == nullptr || subobjects == nullptr) return;
  if (pipeline.handle == 0u) return;

  auto* data = internal::shared.data;
  if (data == nullptr) return;

  auto* details = renodx::utils::shader::GetPipelineShaderDetails(pipeline);
  if (details == nullptr) return;

  for (const auto& info : details->subobject_shaders) {
    // Store immediately in case pipeline destroyed before present
    const auto& shader_hash = info.shader_hash;
    if (info.index >= subobject_count) continue;

    bool skip_shader = false;
    data->shaders.if_contains(shader_hash, [&skip_shader](std::pair<const uint32_t, ShaderInfo>& pair) {
      skip_shader = pair.second.dumped || pair.second.pending;
    });
    if (skip_shader) continue;

    const auto& subobject = subobjects[info.index];
    if (subobject.data == nullptr) continue;
    const reshade::api::shader_desc desc = *static_cast<const reshade::api::shader_desc*>(subobject.data);
    if (desc.code == nullptr || desc.code_size == 0) continue;
    auto shader_data = cross_addon::vector<uint8_t>(
        static_cast<const uint8_t*>(desc.code),
        static_cast<const uint8_t*>(desc.code) + desc.code_size);

    if (device::IsDirectX(device)) {
      try {
        auto shader_version = renodx::utils::shader::compiler::directx::DecodeShaderVersion(shader_data);
        if (shader_version.GetMajor() == 0) {
          // No shader information found
          continue;
        }
      } catch (std::exception& e) {
        std::stringstream s;
        s << "utils::shader::dump(Failed to decode shader data: ";
        s << PRINT_CRC32(shader_hash);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        continue;
      }
    } else {
      // Assume Vulkan
    }
    std::stringstream s;
    s << "utils::shader::dump(storing: ";
    s << PRINT_CRC32(shader_hash);
    s << ", size: " << shader_data.size();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    bool queued = false;
    data->shaders.lazy_emplace_l(
        shader_hash,
        [&](std::pair<const uint32_t, ShaderInfo>& pair) {
          if (pair.second.dumped || pair.second.pending) return;
          pair.second.data = std::move(shader_data);
          pair.second.type = subobject.type;
          pair.second.device_api = device->get_api();
          pair.second.pending = true;
          queued = true;
        },
        [&](const ShaderInfoMap::constructor& ctor) {
          ShaderInfo shader_info = {};
          shader_info.data = std::move(shader_data);
          shader_info.type = subobject.type;
          shader_info.device_api = device->get_api();
          shader_info.pending = true;
          ctor(shader_hash, std::move(shader_info));
          queued = true;
        });

    if (queued) data->pending_dump_count.fetch_add(1u);
  }
}

}  // namespace internal

static size_t GetPendingDumpCount() {
  auto* data = internal::shared.data;
  if (data == nullptr) return 0u;
  return data->pending_dump_count.load();
}

static std::string default_dump_folder = "dump";

static std::filesystem::path GetShaderDumpPath(
    uint32_t shader_hash,
    std::span<uint8_t> shader_data,
    reshade::api::pipeline_subobject_type shader_type = reshade::api::pipeline_subobject_type::unknown,
    const std::string& prefix = "",
    const reshade::api::device_api& device_api = reshade::api::device_api::d3d11) {
  auto dump_path = renodx::utils::path::GetOutputPath();
  std::filesystem::create_directories(dump_path);
  dump_path /= default_dump_folder;
  std::filesystem::create_directories(dump_path);

  wchar_t hash_string[11];
  swprintf_s(hash_string, L"0x%08X", shader_hash);

  if (prefix.empty()) {
    dump_path /= hash_string;
  } else {
    dump_path /= prefix;
    dump_path += hash_string;
  }

  std::string extension = ".bin";
  switch (device_api) {
    case reshade::api::device_api::d3d9:
    case reshade::api::device_api::d3d10:
    case reshade::api::device_api::d3d11:
    case reshade::api::device_api::d3d12: {
      renodx::utils::shader::compiler::directx::DxilProgramVersion shader_version;
      extension = ".cso";
      try {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::shader::dump(Decoding shader_data: ";
        s << PRINT_CRC32(shader_hash);
        s << ": " << shader_data.size();
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        shader_version = renodx::utils::shader::compiler::directx::DecodeShaderVersion(shader_data);
      } catch (std::exception& e) {
        std::stringstream s;
        s << "utils::shader::dump(Failed to parse ";
        s << PRINT_CRC32(shader_hash);
        s << ": " << e.what();
        s << ")";
        reshade::log::message(reshade::log::level::error, s.str().c_str());
      }
      std::string kind = shader_version.GetKindAbbr();
      if (kind != "??") {
        dump_path += L".";
        dump_path += kind;
        dump_path += L"_";
        dump_path += std::to_string(shader_version.GetMajor());
        dump_path += L"_";
        dump_path += std::to_string(shader_version.GetMinor());
      } else {
        std::stringstream s;
        s << "utils::shader::dump(Unknown shader type: ";
        s << PRINT_CRC32(shader_hash);
        s << ", type: " << shader_version.GetKind();
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
      }
      break;
    }
    case reshade::api::device_api::opengl:
      extension = ".glsl";
      switch (shader_type) {
        case reshade::api::pipeline_subobject_type::pixel_shader:
          dump_path += L".frag";
          break;
        case reshade::api::pipeline_subobject_type::vertex_shader:
          dump_path += L".vert";
          break;
        case reshade::api::pipeline_subobject_type::compute_shader:
          dump_path += L".comp";
          break;
        default:
          break;
      }
      break;
    case reshade::api::device_api::vulkan:
      extension = ".spv";
      // Vulkan
      switch (shader_type) {
        case reshade::api::pipeline_subobject_type::pixel_shader:
          dump_path += L".frag";
          break;
        case reshade::api::pipeline_subobject_type::vertex_shader:
          dump_path += L".vert";
          break;
        case reshade::api::pipeline_subobject_type::compute_shader:
          dump_path += L".comp";
          break;
        default:
          break;
      }
    default:
      break;
  }

  dump_path += extension;
  return dump_path;
}

static bool DumpShader(
    uint32_t shader_hash,
    std::span<uint8_t> shader_data,
    reshade::api::pipeline_subobject_type shader_type = reshade::api::pipeline_subobject_type::unknown,
    const std::string& prefix = "",
    const reshade::api::device_api& device_api = reshade::api::device_api::d3d11) {
  auto dump_path = GetShaderDumpPath(shader_hash, shader_data, shader_type, prefix, device_api);
  auto is_binary = device_api != reshade::api::device_api::opengl;

  if (is_binary) {
    renodx::utils::path::WriteBinaryFile(dump_path, shader_data);
  } else {
    // trim null
    renodx::utils::path::WriteBinaryFile(dump_path, shader_data.subspan(0, shader_data.size() - 1));
  }
  return true;
}

static bool DumpShader(
    uint32_t shader_hash,
    std::span<uint8_t> shader_data,
    reshade::api::pipeline_stage shader_stage = static_cast<reshade::api::pipeline_stage>(0u),
    const std::string& prefix = "",
    const reshade::api::device_api& device_api = reshade::api::device_api::d3d11) {
  auto shader_type =
      reshade::api::pipeline_subobject_type::unknown;
  switch (shader_stage) {
    case reshade::api::pipeline_stage::pixel_shader:
      shader_type = reshade::api::pipeline_subobject_type::pixel_shader;
      break;
    case reshade::api::pipeline_stage::vertex_shader:
      shader_type = reshade::api::pipeline_subobject_type::vertex_shader;
      break;
    case reshade::api::pipeline_stage::compute_shader:
      shader_type = reshade::api::pipeline_subobject_type::compute_shader;
      break;
    default:
      break;
  }
  return DumpShader(shader_hash, shader_data, shader_type, prefix, device_api);
}

static std::filesystem::path GetShaderDumpPath(
    uint32_t shader_hash,
    std::span<uint8_t> shader_data,
    reshade::api::pipeline_stage shader_stage = static_cast<reshade::api::pipeline_stage>(0u),
    const std::string& prefix = "",
    const reshade::api::device_api& device_api = reshade::api::device_api::d3d11) {
  auto shader_type =
      reshade::api::pipeline_subobject_type::unknown;
  switch (shader_stage) {
    case reshade::api::pipeline_stage::pixel_shader:
      shader_type = reshade::api::pipeline_subobject_type::pixel_shader;
      break;
    case reshade::api::pipeline_stage::vertex_shader:
      shader_type = reshade::api::pipeline_subobject_type::vertex_shader;
      break;
    case reshade::api::pipeline_stage::compute_shader:
      shader_type = reshade::api::pipeline_subobject_type::compute_shader;
      break;
    default:
      break;
  }

  return GetShaderDumpPath(shader_hash, shader_data, shader_type, prefix, device_api);
}

static void DumpAllPending() {
  auto* data = internal::shared.data;
  if (data == nullptr) return;

  uint32_t dumped_count = 0u;
  data->shaders.for_each_m([&](std::pair<const uint32_t, internal::ShaderInfo>& pair) {
    const auto& shader_hash = pair.first;
    auto& shader_info = pair.second;
    if (!shader_info.pending || shader_info.dumped) return;

    std::stringstream s;
    s << "utils::shader::dump(Starting dump: ";
    s << PRINT_CRC32(shader_hash);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    if (!DumpShader(shader_hash, shader_info.data, shader_info.type, "", shader_info.device_api)) {
      return;
    }

    shader_info.data.clear();
    shader_info.pending = false;
    shader_info.dumped = true;
    ++dumped_count;
  });

  if (dumped_count != 0u) data->pending_dump_count.fetch_sub(dumped_count);
}

static void Use(DWORD fdw_reason) {
  renodx::utils::shader::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::shared.RegisterModule()) {
        reshade::log::message(reshade::log::level::info, "ShaderDump attached.");
      }
      internal::shared.RegisterEvent<reshade::addon_event::init_device>(internal::OnInitDevice);
      internal::shared.RegisterEvent<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);

      break;
    case DLL_PROCESS_DETACH:
      internal::shared.UnregisterEvent<reshade::addon_event::init_device>(internal::OnInitDevice);
      internal::shared.UnregisterEvent<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
      internal::shared.UnregisterModule();
      break;
  }
}

}  // namespace renodx::utils::shader::dump
