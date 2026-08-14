/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <algorithm>
#include <array>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <string>
#include <vector>

namespace {

std::vector<std::uint8_t> ReadBinary(const std::filesystem::path& path) {
  std::ifstream stream(path, std::ios::binary);
  return {std::istreambuf_iterator<char>(stream), std::istreambuf_iterator<char>()};
}

}  // namespace

int main(int argc, char** argv) {
  if (argc != 5) return 1;

  const auto plain_source = ReadBinary(argv[1]);
  if (plain_source.empty() || plain_source != ReadBinary(argv[2])) return 1;

  const auto vulkan_spirv = ReadBinary(argv[3]);
  constexpr std::array<std::uint8_t, 4> spirv_magic = {0x03, 0x02, 0x23, 0x07};
  if (vulkan_spirv.size() < spirv_magic.size()
      || !std::equal(spirv_magic.begin(), spirv_magic.end(), vulkan_spirv.begin())) {
    return 1;
  }

  const auto shader_header_bytes = ReadBinary(argv[4]);
  const std::string shader_header(shader_header_bytes.begin(), shader_header_bytes.end());
  const auto contains = [&](const std::string& value) {
    return shader_header.find(value) != std::string::npos;
  };
  if (!contains("#include \"./0xA0A0A0A0.h\"")
      || !contains("#include \"./0xB0B0B0B0.h\"")
      || !contains("CustomShaderEntry(0xA0A0A0A0)")
      || !contains("CustomShaderEntry(0xB0B0B0B0)")
      || !contains("__ALL_CUSTOM_SHADERS")) {
    return 1;
  }

  return 0;
}