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

namespace renodx::addons::devkit::mcp::resource_handle {

[[nodiscard]] inline std::uint64_t GetRequired(
    const renodx::utils::mcp::json& arguments,
  std::string_view key) {
  const auto* value = renodx::utils::mcp::arguments::FindValue(arguments, key);
  if (value == nullptr || value->is_null()) {
    throw std::runtime_error(std::format("{} is required.", key));
  }

  if (value->is_number_unsigned()) {
    return value->get<std::uint64_t>();
  }
  if (value->is_number_integer()) {
    const auto signed_value = value->get<std::int64_t>();
    if (signed_value < 0) {
      throw std::runtime_error(std::format("{} must be non-negative.", key));
    }
    return static_cast<std::uint64_t>(signed_value);
  }
  if (!value->is_string()) {
    throw std::runtime_error(std::format("{} must be a string handle like 0x1234.", key));
  }

  auto text = value->get<std::string>();
  if (text.starts_with("0x") || text.starts_with("0X")) {
    text.erase(0, 2);
  }
  if (text.empty()) {
    throw std::runtime_error(std::format("{} must not be empty.", key));
  }

  std::uint64_t parsed = 0u;
  const auto [parsed_end, parsed_error] = std::from_chars(text.data(), text.data() + text.size(), parsed, 16);
  if (parsed_error != std::errc{} || parsed_end != text.data() + text.size()) {
    throw std::runtime_error(std::format("{} '{}' is not a valid hexadecimal handle.", key, value->get<std::string>()));
  }

  return parsed;
}

}  // namespace renodx::addons::devkit::mcp::resource_handle
