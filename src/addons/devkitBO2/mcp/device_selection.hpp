/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstddef>
#include <cstdint>
#include <format>
#include <stdexcept>

#include "../../../utils/mcp/types.hpp"
#include "../../../utils/mcp/arguments.hpp"

namespace renodx::addons::devkit::mcp::device_selection {

[[nodiscard]] inline std::uint32_t ResolveRequestedDeviceIndex(
    const renodx::utils::mcp::json& arguments,
    std::size_t device_count,
    std::uint32_t selected_index) {
  if (device_count == 0u) {
    throw std::runtime_error("No devices are currently tracked.");
  }

  const auto requested_index = renodx::utils::mcp::arguments::GetOptional<std::uint32_t>(arguments, "deviceIndex");
  if (!requested_index.has_value()) {
    return selected_index;
  }

  if (static_cast<std::size_t>(requested_index.value()) >= device_count) {
    throw std::runtime_error(std::format("deviceIndex {} is out of range.", requested_index.value()));
  }

  return requested_index.value();
}

}  // namespace renodx::addons::devkit::mcp::device_selection
