/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <Windows.h>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <span>

namespace renodx::utils::path {

static std::string default_output_folder = "renodx-dev";

static std::filesystem::path GetOutputPath() {
  // NOLINTNEXTLINE(modernize-avoid-c-arrays)
  wchar_t file_prefix[MAX_PATH] = L"";
  GetModuleFileNameW(nullptr, file_prefix, ARRAYSIZE(file_prefix));

  std::filesystem::path dump_path = file_prefix;
  dump_path = dump_path.parent_path();
  dump_path /= default_output_folder;
  return dump_path;
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
  auto data = ReadBinaryFile(path);
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