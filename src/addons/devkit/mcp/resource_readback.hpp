/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>

#include <include/reshade.hpp>

namespace renodx::addons::devkit::mcp::resource_readback {

struct Plan {
  bool use_buffer = false;
  std::uint32_t row_pitch = 0u;
  std::uint32_t slice_pitch = 0u;
  reshade::api::resource_usage source_before_copy = reshade::api::resource_usage::undefined;
  reshade::api::resource_usage source_during_copy = reshade::api::resource_usage::undefined;
  reshade::api::resource_usage source_after_copy = reshade::api::resource_usage::undefined;
};

[[nodiscard]] inline Plan BuildPlan(
    reshade::api::device_api device_api,
    bool is_swap_chain,
    reshade::api::format format,
    std::uint32_t width,
    std::uint32_t height) {
  if (device_api != reshade::api::device_api::vulkan || !is_swap_chain) {
    return {};
  }

  const auto row_pitch = reshade::api::format_row_pitch(format, width);
  return {
      .use_buffer = true,
      .row_pitch = row_pitch,
      .slice_pitch = reshade::api::format_slice_pitch(format, row_pitch, height),
      .source_before_copy = reshade::api::resource_usage::present,
      .source_during_copy = reshade::api::resource_usage::copy_source,
      .source_after_copy = reshade::api::resource_usage::present,
  };
}

}  // namespace renodx::addons::devkit::mcp::resource_readback
