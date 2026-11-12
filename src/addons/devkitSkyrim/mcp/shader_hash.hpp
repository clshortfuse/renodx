/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <charconv>
#include <cstdint>
#include <format>
#include <stdexcept>
#include <string>
#include <string_view>

#include "../../../utils/mcp/types.hpp"
#include "../../../utils/mcp/arguments.hpp"

namespace renodx::addons::devkit::mcp::shader_hash {

[[nodiscard]] inline std::uint32_t GetRequired(
    const renodx::utils::mcp::json& arguments,
    std::string_view key) {
  const auto* value = renodx::utils::mcp::arguments::FindValue(arguments, key);
  if (value == nullptr || value->is_null()) {
    throw std::runtime_error(std::format("{} is required.", key));
  }

  if (value->is_number_unsigned()) {
    const auto value64 = value->get<std::uint64_t>();
    if (value64 > 0xFFFFFFFFull) {
      throw std::runtime_error(std::format("{} must fit in a 32-bit shader hash.", key));
    }
    return static_cast<std::uint32_t>(value64);
  }
  if (value->is_number_integer()) {
    const auto signed_value = value->get<std::int64_t>();
    if (signed_value < 0) {
      throw std::runtime_error(std::format("{} must be non-negative.", key));
    }
    if (static_cast<std::uint64_t>(signed_value) > 0xFFFFFFFFull) {
      throw std::runtime_error(std::format("{} must fit in a 32-bit shader hash.", key));
    }
    return static_cast<std::uint32_t>(signed_value);
  }
  if (!value->is_string()) {
    throw std::runtime_error(std::format("{} must be a string or integer.", key));
  }

  auto text = value->get<std::string>();
  auto base = 10;
  if (text.starts_with("0x") || text.starts_with("0X")) {
    text = text.substr(2);
    base = 16;
  }
  if (text.empty()) {
    throw std::runtime_error(std::format("{} must be a valid 32-bit shader hash.", key));
  }

  std::uint64_t parsed = 0u;
  const auto [parsed_end, parsed_error] = std::from_chars(text.data(), text.data() + text.size(), parsed, base);
  if (parsed_error != std::errc{} || parsed_end != text.data() + text.size()) {
    throw std::runtime_error(std::format("{} must be a valid 32-bit shader hash.", key));
  }
  if (parsed > 0xFFFFFFFFull) {
    throw std::runtime_error(std::format("{} must fit in a 32-bit shader hash.", key));
  }
  return static_cast<std::uint32_t>(parsed);
}

}  // namespace renodx::addons::devkit::mcp::shader_hash
