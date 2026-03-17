/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>
#include <format>
#include <limits>
#include <memory>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <type_traits>

#include "./types.hpp"

namespace renodx::utils::mcp::arguments {

using json = renodx::utils::mcp::json;

template <typename T>
inline constexpr bool ALWAYS_FALSE = false;

[[nodiscard]] inline const json* FindValue(
    const json& arguments,
    std::string_view key) {
  if (!arguments.is_object()) return nullptr;

  for (auto iterator = arguments.begin(); iterator != arguments.end(); ++iterator) {
    if (iterator.key() == key) {
      return std::addressof(iterator.value());
    }
  }
  return nullptr;
}

template <typename T>
[[nodiscard]] inline T ParseRequired(
    const json& value,
    std::string_view key) {
  if constexpr (std::is_same_v<T, std::string>) {
    if (!value.is_string()) {
      throw std::runtime_error(std::format("{} must be a string.", key));
    }
    return value.get<std::string>();
  } else if constexpr (std::is_same_v<T, bool>) {
    if (!value.is_boolean()) {
      throw std::runtime_error(std::format("{} must be a boolean.", key));
    }
    return value.get<bool>();
  } else if constexpr (std::is_integral_v<T> && !std::is_same_v<T, bool>) {
    if (!value.is_number_integer() && !value.is_number_unsigned()) {
      throw std::runtime_error(std::format("{} must be an integer.", key));
    }

    if (value.is_number_unsigned()) {
      const auto unsigned_value = value.get<std::uint64_t>();
      if (unsigned_value > static_cast<std::uint64_t>((std::numeric_limits<T>::max)())) {
        throw std::runtime_error(std::format("{} is out of range.", key));
      }
      return static_cast<T>(unsigned_value);
    }

    const auto signed_value = value.get<std::int64_t>();
    if constexpr (std::is_unsigned_v<T>) {
      if (signed_value < 0
          || static_cast<std::uint64_t>(signed_value) > static_cast<std::uint64_t>((std::numeric_limits<T>::max)())) {
        throw std::runtime_error(std::format("{} is out of range.", key));
      }
    } else {
      if (signed_value < static_cast<std::int64_t>((std::numeric_limits<T>::min)())
          || signed_value > static_cast<std::int64_t>((std::numeric_limits<T>::max)())) {
        throw std::runtime_error(std::format("{} is out of range.", key));
      }
    }

    return static_cast<T>(signed_value);
  } else {
    static_assert(ALWAYS_FALSE<T>, "Argument access only supports std::string, bool, and integral types.");
  }
}

template <typename T>
[[nodiscard]] inline std::optional<T> GetOptional(
    const json& arguments,
    std::string_view key) {
  const auto* value = FindValue(arguments, key);
  if (value == nullptr || value->is_null()) {
    return std::nullopt;
  }

  return ParseRequired<T>(*value, key);
}

template <typename T>
[[nodiscard]] inline T GetRequired(
    const json& arguments,
    std::string_view key) {
  const auto* value = FindValue(arguments, key);
  if (value == nullptr || value->is_null()) {
    throw std::runtime_error(std::format("{} is required.", key));
  }

  return ParseRequired<T>(*value, key);
}

template <typename T>
[[nodiscard]] inline T ValidateRange(
    std::string_view key,
    T value,
    T min_value,
    T max_value) {
  static_assert(std::is_integral_v<T> && !std::is_same_v<T, bool>, "ValidateRange requires an integral type.");
  if (value < min_value || value > max_value) {
    throw std::runtime_error(std::format("{} must be between {} and {}.", key, min_value, max_value));
  }
  return value;
}

}  // namespace renodx::utils::mcp::arguments
