/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#if defined(RESHADE_API_LIBRARY) || (defined(__has_include) && __has_include(<include/reshade.hpp>))
#include <include/reshade.hpp>
#define RENODX_HAS_RESHADE_HEADERS 1
#endif

#include <Windows.h>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <span>
#include <string>
#include <string_view>
#include <vector>

namespace renodx::utils::path {

static std::string default_output_folder = "renodx-dev";
static constexpr std::string_view default_live_subdirectory = "live";
static constexpr std::string_view default_dump_subdirectory = "dump";

static std::filesystem::path GetExecutableBasePath() {
  auto module_path = std::wstring(32768, L'\0');
  SetLastError(ERROR_SUCCESS);
  auto module_path_size = GetModuleFileNameW(
      nullptr,
      module_path.data(),
      static_cast<DWORD>(module_path.size()));
  if (module_path_size > 0 && GetLastError() != ERROR_INSUFFICIENT_BUFFER) {
    module_path.resize(module_path_size);
    return std::filesystem::path(module_path).parent_path();
  }
  return {};
}

static std::filesystem::path GetReShadeBasePath() {
  std::filesystem::path base_path;

#if defined(RENODX_HAS_RESHADE_HEADERS)
  bool is_reshade_addon =
#ifdef RESHADE_API_LIBRARY
      true;
#else
      (reshade::internal::get_reshade_module_handle() != nullptr);
#endif
  if (is_reshade_addon) {
    size_t path_size = 0;
    reshade::get_reshade_base_path(nullptr, &path_size);
    if (path_size > 1) {
      auto reshade_base_path = std::string(path_size, '\0');
      reshade::get_reshade_base_path(reshade_base_path.data(), &path_size);
      reshade_base_path.resize(path_size);
      if (!reshade_base_path.empty()) {
        base_path = std::filesystem::path(std::u8string(
            reshade_base_path.begin(), reshade_base_path.end()));
      }
    }
  }
#endif  // RENODX_HAS_RESHADE_HEADERS

  if (base_path.empty()) {
    base_path = GetExecutableBasePath();
  }

  return base_path;
}

static std::filesystem::path GetOutputPath() {
  return GetReShadeBasePath() / default_output_folder;
}

static std::filesystem::path GetOutputSubdirectory(std::string_view subdirectory) {
  auto path = GetOutputPath();
  path /= std::filesystem::path(subdirectory);
  return path;
}

static std::filesystem::path GetLiveOutputPath() {
  return GetOutputSubdirectory(default_live_subdirectory);
}

static std::filesystem::path GetDumpOutputPath() {
  return GetOutputSubdirectory(default_dump_subdirectory);
}

static bool CheckExistsFile(const std::filesystem::path& path) {
  std::ifstream file(path, std::ios::binary);
  return file.good();
}

static std::vector<uint8_t> ReadBinaryFile(const std::filesystem::path& path) {
  std::ifstream file(path, std::ios::binary);
  file.seekg(0, std::ios::end);
  const size_t file_size = file.tellg();
  if (file_size == 0) return {};

  auto result = std::vector<uint8_t>(file_size);
  file.seekg(0, std::ios::beg).read(reinterpret_cast<char*>(result.data()), file_size);
  return result;
}

static std::string ReadTextFile(const std::filesystem::path& path) {
  const auto& data = ReadBinaryFile(path);
  if (data.empty()) return "";
  return {reinterpret_cast<const char*>(data.data()), data.size()};
}

static void WriteBinaryFile(const std::filesystem::path& path, std::span<uint8_t> data) {
  std::ofstream file(path, std::ios::binary);
  file.write(reinterpret_cast<const char*>(data.data()), data.size());
}

static void WriteTextFile(const std::filesystem::path& path, std::string& string) {
  std::ofstream file(path);
  file << string;
}

}  // namespace renodx::utils::path

#undef RENODX_HAS_RESHADE_HEADERS