/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <cstdint>

#include <mutex>
#include <span>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./format.hpp"
#include "./path.hpp"
#include "./shader.hpp"
#include "./shader_compiler.hpp"

namespace renodx::utils::shader::dump {

static std::atomic_bool use_auto_dump = true;
static std::atomic_size_t pending_dump_count = 0;

namespace internal {
static std::unordered_set<uint32_t> shaders_dumped;
static std::unordered_set<uint32_t> shaders_seen;
static std::unordered_map<uint32_t, std::vector<uint8_t>> shaders_pending;

static std::shared_mutex mutex;

// After CreatePipelineState
static void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  if (pipeline.handle == 0u) return;

  auto details = renodx::utils::shader::GetPipelineShaderDetails(device, pipeline);
  if (!details.has_value()) return;

  std::unique_lock lock(mutex);
  for (auto& [subobject_index, shader_hash] : details->shader_hashes_by_index) {
    // Store immediately in case pipeline destroyed before present
    if (shaders_seen.contains(shader_hash)) continue;
    shaders_seen.emplace(shader_hash);

    if (shaders_dumped.contains(shader_hash)) continue;
    if (shaders_pending.contains(shader_hash)) continue;
    auto shader_data = details->GetShaderData(shader_hash, subobject_index);
    if (!shader_data.has_value()) {
      std::stringstream s;
      s << "utils::shader::dump(Failed to retreive shader data: ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      continue;
    }
    try {
      auto shader_version = renodx::utils::shader::compiler::DecodeShaderVersion(shader_data.value());
      if (shader_version.GetMajor() == 0) {
        // No shader information found
        continue;
      }
    } catch (std::exception& e) {
      std::stringstream s;
      s << "utils::shader::dump(Failed to decode shader data: ";
      s << PRINT_CRC32(shader_hash);
      s << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      continue;
    }
    std::stringstream s;
    s << "utils::shader::dump(storing: ";
    s << PRINT_CRC32(shader_hash);
    s << ", size: " << shader_data->size();
    s << ")";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());

    shaders_pending[shader_hash] = shader_data.value();
  }
}

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  std::shared_lock lock(mutex);
  pending_dump_count = shaders_pending.size();
}

static bool attached = false;

static void CheckShadersOnDisk() {
  auto dump_path = renodx::utils::path::GetOutputPath();

  if (!std::filesystem::exists(dump_path)) return;
  dump_path /= "dump";
  if (!std::filesystem::exists(dump_path)) return;
  std::unordered_set<uint32_t> shader_hashes_found = {};

  for (const auto& entry : std::filesystem::directory_iterator(dump_path)) {
    if (!entry.is_regular_file()) continue;
    const auto& entry_path = entry.path();
    if (entry_path.extension() != ".cso") continue;
    const auto& basename = entry_path.stem().string();
    if (basename.length() < 2 + 8) continue;
    if (!basename.starts_with("0x")) continue;
    auto hash_string = basename.substr(2, 8);
    uint32_t shader_hash;
    try {
      shader_hash = std::stoul(hash_string, nullptr, 16);
    } catch (const std::exception& e) {
      std::stringstream s;
      s << "utils::shader::dump(Invalid shader string: ";
      s << hash_string;
      s << " at ";
      s << entry_path;
      s << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
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
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
    } else {
      std::stringstream s;
      s << "utils::shader::dump(Found shader: ";
      s << PRINT_CRC32(shader_hash);
      s << " at ";
      s << entry_path;
      s << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
  }

  const std::unique_lock lock(mutex);
  shaders_dumped.insert(shader_hashes_found.begin(), shader_hashes_found.end());
}
}  // namespace internal

static bool DumpShader(uint32_t shader_hash, std::span<uint8_t> shader_data) {
  auto dump_path = renodx::utils::path::GetOutputPath();

  if (!std::filesystem::exists(dump_path)) {
    std::filesystem::create_directory(dump_path);
  }
  dump_path /= "dump";
  if (!std::filesystem::exists(dump_path)) {
    std::filesystem::create_directory(dump_path);
  }

  wchar_t hash_string[11];
  swprintf_s(hash_string, L"0x%08X", shader_hash);

  dump_path /= hash_string;

  renodx::utils::shader::compiler::DxilProgramVersion shader_version;
  try {
    std::stringstream s;
    s << "utils::shader::dump(Decoding shader_data: ";
    s << PRINT_CRC32(shader_hash);
    s << ": " << shader_data.size();
    s << ")";
    reshade::log_message(reshade::log_level::error, s.str().c_str());
    shader_version = renodx::utils::shader::compiler::DecodeShaderVersion(shader_data);
  } catch (std::exception& e) {
    std::stringstream s;
    s << "utils::shader::dump(Failed to parse ";
    s << PRINT_CRC32(shader_hash);
    s << ": " << e.what();
    s << ")";
    reshade::log_message(reshade::log_level::error, s.str().c_str());
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
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
  }

  dump_path += L".cso";

  std::stringstream s;
  s << "utils::shader::dump(Dumping: ";
  s << PRINT_CRC32(shader_hash);
  s << " => " << dump_path.string();
  s << ")";
  reshade::log_message(reshade::log_level::debug, s.str().c_str());

  renodx::utils::path::WriteBinaryFile(dump_path, shader_data);
  return true;
}

static void DumpAllPending() {
  std::unique_lock lock(internal::mutex);
  for (auto& [shader_hash, shader_data] : internal::shaders_pending) {
    std::stringstream s;
    s << "utils::shader::dump(Starting dump: ";
    s << PRINT_CRC32(shader_hash);
    s << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());

    DumpShader(shader_hash, shader_data);
  }
  internal::shaders_pending.clear();
}

static void Use(DWORD fdw_reason) {
  renodx::utils::shader::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      internal::CheckShadersOnDisk();
      reshade::log_message(reshade::log_level::info, "ShaderDump attached.");
      reshade::register_event<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
      reshade::register_event<reshade::addon_event::present>(internal::OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_pipeline>(internal::OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);
      break;
  }
}

}  // namespace renodx::utils::shader::dump