/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>
#include <format>
#include <sstream>
#include <string>
#include <string_view>

namespace renodx::addons::devkit::formatting {

template <typename T>
[[nodiscard]] inline std::string StreamToString(const T& value) {
  std::ostringstream stream;
  stream << value;
  return stream.str();
}

[[nodiscard]] inline std::string NarrowAscii(std::wstring_view value) {
  std::string result;
  result.reserve(value.size());
  for (auto character : value) {
    result.push_back(static_cast<char>(character));
  }
  return result;
}

[[nodiscard]] inline std::string FormatPointer(const void* value) {
  return std::format("0x{:0{}X}", reinterpret_cast<uintptr_t>(value), sizeof(uintptr_t) * 2u);
}

[[nodiscard]] inline std::string FormatHandle(std::uint64_t value) {
  return std::format("0x{:016X}", value);
}

[[nodiscard]] inline std::string FormatShaderHash(std::uint32_t shader_hash) {
  return std::format("0x{:08X}", shader_hash);
}

}  // namespace renodx::addons::devkit::formatting
