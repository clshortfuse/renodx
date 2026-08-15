/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <optional>

namespace renodx::games::detroitbecomehuman::peak_brightness {

constexpr float kFallbackPeakNits = 1000.f;
constexpr float kMinimumPeakNits = 48.f;
constexpr float kMaximumPeakNits = 4000.f;
constexpr auto kAutomaticRefreshInterval = std::chrono::seconds(1);

enum class Source : std::uint8_t {
  kAutomatic = 0u,
  kManual = 1u,
};

struct Resolution {
  float effective_peak_nits = kFallbackPeakNits;
  bool automatic = true;
  bool used_fallback = true;
};

[[nodiscard]] constexpr Source ParseSource(float value) {
  return value >= 0.5f ? Source::kManual : Source::kAutomatic;
}

[[nodiscard]] inline bool IsValidPeakNits(float value) {
  return std::isfinite(value)
         && value >= kMinimumPeakNits
         && value <= kMaximumPeakNits;
}

[[nodiscard]] inline float SanitizeManualPeakNits(float value) {
  if (!std::isfinite(value)) return kFallbackPeakNits;
  return std::clamp(value, kMinimumPeakNits, kMaximumPeakNits);
}

[[nodiscard]] inline Resolution Resolve(
    Source source,
    float manual_peak_nits,
    std::optional<float> detected_peak_nits) {
  if (source == Source::kManual) {
    return {
        .effective_peak_nits = SanitizeManualPeakNits(manual_peak_nits),
        .automatic = false,
        .used_fallback = !IsValidPeakNits(manual_peak_nits),
    };
  }

  if (detected_peak_nits.has_value()
      && IsValidPeakNits(*detected_peak_nits)) {
    return {
        .effective_peak_nits = *detected_peak_nits,
        .automatic = true,
        .used_fallback = false,
    };
  }

  return {};
}

class RefreshController {
 public:
  using Clock = std::chrono::steady_clock;

  [[nodiscard]] bool ShouldRefresh(
      Source source,
      std::uintptr_t monitor_token,
      bool output_is_hdr,
      Clock::time_point now,
      bool force = false) {
    if (source != Source::kAutomatic) return false;

    const bool interval_elapsed =
        initialized_
        && (now < last_refresh_
            || now - last_refresh_ >= kAutomaticRefreshInterval);
    const bool contract_changed =
        !initialized_
        || monitor_token != monitor_token_
        || output_is_hdr != output_is_hdr_;
    if (!force && !contract_changed && !interval_elapsed) return false;

    initialized_ = true;
    monitor_token_ = monitor_token;
    output_is_hdr_ = output_is_hdr;
    last_refresh_ = now;
    return true;
  }

  void Reset() {
    initialized_ = false;
    monitor_token_ = 0u;
    output_is_hdr_ = false;
    last_refresh_ = {};
  }

 private:
  bool initialized_ = false;
  std::uintptr_t monitor_token_ = 0u;
  bool output_is_hdr_ = false;
  Clock::time_point last_refresh_;
};

}  // namespace renodx::games::detroitbecomehuman::peak_brightness
