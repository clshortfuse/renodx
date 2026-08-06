/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cmath>
#include <cstdint>

namespace renodx::games::detroitbecomehuman::gtao_temporal_contract {

inline constexpr std::uint32_t kWorkgroupSize = 8u;
inline constexpr std::uint32_t kPixelsPerInvocationAxis = 2u;
inline constexpr std::uint32_t kPixelsPerWorkgroupAxis =
    kWorkgroupSize * kPixelsPerInvocationAxis;

struct Extent {
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;

  [[nodiscard]] constexpr bool IsValid() const noexcept {
    return width != 0u && height != 0u;
  }

  bool operator==(const Extent&) const = default;
};

[[nodiscard]] constexpr Extent GetDispatchCoverage(
    std::uint32_t group_count_x,
    std::uint32_t group_count_y) noexcept {
  return {
      group_count_x * kPixelsPerWorkgroupAxis,
      group_count_y * kPixelsPerWorkgroupAxis,
  };
}

[[nodiscard]] constexpr bool IsCoveredByDispatch(
    Extent candidate,
    std::uint32_t group_count_x,
    std::uint32_t group_count_y) noexcept {
  if (!candidate.IsValid() || group_count_x == 0u || group_count_y == 0u) {
    return false;
  }
  const auto coverage = GetDispatchCoverage(group_count_x, group_count_y);
  const auto minimum_width =
      (group_count_x - 1u) * kPixelsPerWorkgroupAxis + 1u;
  const auto minimum_height =
      (group_count_y - 1u) * kPixelsPerWorkgroupAxis + 1u;
  return candidate.width >= minimum_width && candidate.width <= coverage.width
         && candidate.height >= minimum_height
         && candidate.height <= coverage.height;
}

[[nodiscard]] constexpr Extent SelectHistoryExtent(
    std::uint32_t group_count_x,
    std::uint32_t group_count_y,
    Extent temporal_extent,
    Extent output_extent) noexcept {
  if (IsCoveredByDispatch(temporal_extent, group_count_x, group_count_y)) {
    return temporal_extent;
  }
  if (IsCoveredByDispatch(output_extent, group_count_x, group_count_y)) {
    return output_extent;
  }
  return GetDispatchCoverage(group_count_x, group_count_y);
}

[[nodiscard]] inline float DepthDisocclusionThreshold(
    float view_depth) noexcept {
  return std::max(0.002f, std::abs(view_depth) * 0.02f);
}

[[nodiscard]] inline float TemporalHistoryWeight(
    float motion_pixels,
    float relative_depth_error) noexcept {
  if (!std::isfinite(motion_pixels) || !std::isfinite(relative_depth_error)
      || relative_depth_error >= 1.f) {
    return 0.f;
  }
  const float motion_factor = std::clamp(motion_pixels / 16.f, 0.f, 1.f);
  const float base_weight = 0.92f + (0.72f - 0.92f) * motion_factor;
  return base_weight * (1.f - std::clamp(relative_depth_error, 0.f, 1.f));
}

[[nodiscard]] constexpr bool ShouldResetHistory(
    bool camera_reset,
    bool previous_depth_present,
    bool previous_color_present,
    bool previous_speed_flags_present) noexcept {
  // GTAO owns its AO/depth history. Native TAA history is only a reliable
  // resource-recreation boundary when the actual image handles disappear;
  // incomplete sampler metadata must not reset independent AO accumulation.
  return camera_reset || !previous_depth_present || !previous_color_present
         || !previous_speed_flags_present;
}

}  // namespace renodx::games::detroitbecomehuman::gtao_temporal_contract
