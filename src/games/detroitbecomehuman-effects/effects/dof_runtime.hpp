/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <atomic>
#include <bit>
#include <cmath>
#include <cstdint>

namespace renodx::games::detroitbecomehuman::dof {

enum class Pass : std::uint32_t {
  kSplit = 1u << 0u,
  kGather = 1u << 1u,
  kFill = 1u << 2u,
  kComposite = 1u << 3u,
};

inline constexpr std::uint32_t kCompletePassMask =
    static_cast<std::uint32_t>(Pass::kSplit)
    | static_cast<std::uint32_t>(Pass::kGather)
    | static_cast<std::uint32_t>(Pass::kFill)
    | static_cast<std::uint32_t>(Pass::kComposite);

enum class RuntimeMode : std::uint32_t {
  kVanilla = 0u,
  kCleanBalanced = 1u,
  kCleanHigh = 2u,
  kCinematicBalanced = 3u,
  kCinematicHigh = 4u,
  kRetinalBalanced = 5u,
  kRetinalHigh = 6u,
};

enum class RuntimeStyle : std::uint32_t {
  kVanilla = 0u,
  kClean = 1u,
  kCinematic = 2u,
  kRetinal = 3u,
};

[[nodiscard]] constexpr bool IsKnownRuntimeStyle(
    RuntimeStyle style) noexcept {
  return static_cast<std::uint32_t>(style)
         <= static_cast<std::uint32_t>(RuntimeStyle::kRetinal);
}

[[nodiscard]] constexpr bool IsKnownRuntimeMode(RuntimeMode mode) noexcept {
  return static_cast<std::uint32_t>(mode)
         <= static_cast<std::uint32_t>(RuntimeMode::kRetinalHigh);
}

[[nodiscard]] constexpr bool IsEnhancedMode(RuntimeMode mode) noexcept {
  return IsKnownRuntimeMode(mode) && mode != RuntimeMode::kVanilla;
}

[[nodiscard]] constexpr bool UsesCinematicBase(RuntimeMode mode) noexcept {
  return mode == RuntimeMode::kCinematicBalanced
         || mode == RuntimeMode::kCinematicHigh
         || mode == RuntimeMode::kRetinalBalanced
         || mode == RuntimeMode::kRetinalHigh;
}

[[nodiscard]] constexpr bool IsHighQualityMode(RuntimeMode mode) noexcept {
  return mode == RuntimeMode::kCleanHigh
         || mode == RuntimeMode::kCinematicHigh
         || mode == RuntimeMode::kRetinalHigh;
}

[[nodiscard]] constexpr bool IsBalancedQualityMode(
    RuntimeMode mode) noexcept {
  return mode == RuntimeMode::kCleanBalanced
         || mode == RuntimeMode::kCinematicBalanced
         || mode == RuntimeMode::kRetinalBalanced;
}

[[nodiscard]] constexpr bool IsRetinalMode(RuntimeMode mode) noexcept {
  return mode == RuntimeMode::kRetinalBalanced
         || mode == RuntimeMode::kRetinalHigh;
}

enum class RuntimeStatus : std::uint32_t {
  kVanilla = 0u,
  kWaitingForChain,
  kIncompleteChain,
  kActiveCleanBalanced,
  kActiveCleanHigh,
  kActiveCinematicBalanced,
  kActiveCinematicHigh,
  kActiveRetinalBalanced,
  kActiveRetinalHigh,
  kUnsupportedBuild,
};

struct FrameResult {
  RuntimeMode mode = RuntimeMode::kVanilla;
  RuntimeStatus status = RuntimeStatus::kVanilla;
  std::uint32_t observed_pass_mask = 0u;
};

struct RuntimeControls {
  float focus_distance_percent = 100.f;
  float blur_radius_percent = 100.f;
  float far_strength_percent = 100.f;
  float vanilla_transition_percent = 100.f;
  bool fill_edge_aware_coc = false;
  bool fill_adaptive_transition = false;
  bool fill_dense_rgb = false;
};

inline constexpr std::uint32_t kModeMask = 0x7u;
inline constexpr std::uint32_t kFocusShift = 3u;
inline constexpr std::uint32_t kFocusMask = 0x7Fu;
inline constexpr std::uint32_t kFocusNeutral = 64u;
inline constexpr std::uint32_t kRadiusShift = 10u;
inline constexpr std::uint32_t kRadiusMask = 0x3Fu;
inline constexpr std::uint32_t kRadiusNeutral = 32u;
// Foreground bokeh always uses Detroit's authored Vanilla strength and needs
// no runtime control. These five bits blend Detroit's authored far coverage
// into Cinematic through the smooth full-resolution small-CoC handoff.
inline constexpr std::uint32_t kVanillaTransitionShift = 16u;
inline constexpr std::uint32_t kVanillaTransitionMask = 0x1Fu;
inline constexpr std::uint32_t kVanillaTransitionDefault =
    kVanillaTransitionMask;
inline constexpr std::uint32_t kFarShift = 21u;
inline constexpr std::uint32_t kFarMask = 0x1Fu;
inline constexpr std::uint32_t kFarNeutral = 16u;
// Former Edge Bokeh bits now select optional High Fill reconstruction paths.
// Zero retains the currently validated Bilinear + Fixed 2-4 + 3x3 behavior,
// so existing presets remain compatible. Bit 29 and bits 30..31 stay zero;
// every packed payload therefore remains a finite positive float.
inline constexpr std::uint32_t kFillEdgeAwareCocShift = 26u;
inline constexpr std::uint32_t kFillAdaptiveTransitionShift = 27u;
inline constexpr std::uint32_t kFillDenseRgbShift = 28u;
inline constexpr std::uint32_t kReservedHighShift = 29u;
inline constexpr std::uint32_t kReservedHighMask = 0x7u;

[[nodiscard]] inline std::uint32_t QuantizePercentScale(
    float percent,
    std::uint32_t neutral,
    std::uint32_t mask) noexcept {
  if (!std::isfinite(percent)) percent = 100.f;
  const float scale = std::clamp(percent * 0.01f, 0.f, 2.f);
  if (scale <= 1.f) {
    return static_cast<std::uint32_t>(std::lround(
        scale * static_cast<float>(neutral)));
  }
  return neutral + static_cast<std::uint32_t>(std::lround((scale - 1.f) * static_cast<float>(mask - neutral)));
}

[[nodiscard]] inline std::uint32_t QuantizeVanillaTransition(
    float percent) noexcept {
  if (!std::isfinite(percent)) percent = 100.f;
  return static_cast<std::uint32_t>(std::lround(
      std::clamp(percent, 0.f, 100.f)
      * static_cast<float>(kVanillaTransitionMask) / 100.f));
}

[[nodiscard]] inline std::uint32_t PackRuntimeBits(
    RuntimeMode mode,
    const RuntimeControls& controls) noexcept {
  return (static_cast<std::uint32_t>(mode) & kModeMask)
         | (QuantizePercentScale(
                controls.focus_distance_percent, kFocusNeutral, kFocusMask)
            << kFocusShift)
         | (QuantizePercentScale(
                controls.blur_radius_percent, kRadiusNeutral, kRadiusMask)
            << kRadiusShift)
         | (QuantizeVanillaTransition(controls.vanilla_transition_percent)
            << kVanillaTransitionShift)
         | (QuantizePercentScale(
                controls.far_strength_percent, kFarNeutral, kFarMask)
            << kFarShift)
         | (static_cast<std::uint32_t>(controls.fill_edge_aware_coc)
            << kFillEdgeAwareCocShift)
         | (static_cast<std::uint32_t>(controls.fill_adaptive_transition)
            << kFillAdaptiveTransitionShift)
         | (static_cast<std::uint32_t>(controls.fill_dense_rgb)
            << kFillDenseRgbShift);
}

[[nodiscard]] inline float PackRuntimePayload(
    RuntimeMode mode,
    const RuntimeControls& controls) noexcept {
  // Keep Vanilla byte-for-byte neutral. The replacement shaders branch on
  // mode zero before decoding or applying any of the packed controls.
  if (!IsEnhancedMode(mode)) return 0.f;
  return std::bit_cast<float>(PackRuntimeBits(mode, controls));
}

[[nodiscard]] inline std::uint32_t UnpackRuntimeBits(float payload) noexcept {
  return std::bit_cast<std::uint32_t>(payload);
}

[[nodiscard]] inline float UnpackPercentScale(
    std::uint32_t bits,
    std::uint32_t shift,
    std::uint32_t mask,
    std::uint32_t neutral) noexcept {
  const std::uint32_t code = (bits >> shift) & mask;
  if (code <= neutral) {
    return static_cast<float>(code) / static_cast<float>(neutral);
  }
  return 1.f + static_cast<float>(code - neutral) / static_cast<float>(mask - neutral);
}

[[nodiscard]] inline float UnpackVanillaTransition(
    std::uint32_t bits) noexcept {
  return static_cast<float>(
             (bits >> kVanillaTransitionShift) & kVanillaTransitionMask)
         / static_cast<float>(kVanillaTransitionMask);
}

class RuntimeController {
 public:
  void Observe(Pass pass) noexcept {
    observed_pass_mask_.fetch_or(
        static_cast<std::uint32_t>(pass), std::memory_order_relaxed);
  }

  [[nodiscard]] FrameResult FinishFrame(
      RuntimeStyle requested_style,
      bool high_quality_requested,
      bool supported_build) noexcept {
    const std::uint32_t observed = observed_pass_mask_.exchange(
        0u, std::memory_order_acq_rel);
    const bool complete = observed == kCompletePassMask;
    chain_ready_.store(complete, std::memory_order_release);

    FrameResult result = {
        .mode = RuntimeMode::kVanilla,
        .status = RuntimeStatus::kVanilla,
        .observed_pass_mask = observed,
    };
    if (requested_style == RuntimeStyle::kVanilla) {
      Store(result);
      return result;
    }
    if (!IsKnownRuntimeStyle(requested_style)) {
      Store(result);
      return result;
    }
    if (!supported_build) {
      result.status = RuntimeStatus::kUnsupportedBuild;
      Store(result);
      return result;
    }
    if (!complete) {
      result.status = observed == 0u
                          ? RuntimeStatus::kWaitingForChain
                          : RuntimeStatus::kIncompleteChain;
      Store(result);
      return result;
    }

    if (requested_style == RuntimeStyle::kRetinal) {
      result.mode = high_quality_requested
                        ? RuntimeMode::kRetinalHigh
                        : RuntimeMode::kRetinalBalanced;
      result.status = high_quality_requested
                          ? RuntimeStatus::kActiveRetinalHigh
                          : RuntimeStatus::kActiveRetinalBalanced;
    } else if (requested_style == RuntimeStyle::kCinematic) {
      result.mode = high_quality_requested
                        ? RuntimeMode::kCinematicHigh
                        : RuntimeMode::kCinematicBalanced;
      result.status = high_quality_requested
                          ? RuntimeStatus::kActiveCinematicHigh
                          : RuntimeStatus::kActiveCinematicBalanced;
    } else if (requested_style == RuntimeStyle::kClean) {
      result.mode = high_quality_requested
                        ? RuntimeMode::kCleanHigh
                        : RuntimeMode::kCleanBalanced;
      result.status = high_quality_requested
                          ? RuntimeStatus::kActiveCleanHigh
                          : RuntimeStatus::kActiveCleanBalanced;
    }
    Store(result);
    return result;
  }

  void Reset() noexcept {
    observed_pass_mask_.store(0u, std::memory_order_release);
    chain_ready_.store(false, std::memory_order_release);
    runtime_mode_.store(RuntimeMode::kVanilla, std::memory_order_release);
    status_.store(RuntimeStatus::kVanilla, std::memory_order_release);
    last_observed_pass_mask_.store(0u, std::memory_order_release);
  }

  [[nodiscard]] RuntimeMode GetMode() const noexcept {
    return runtime_mode_.load(std::memory_order_acquire);
  }

  [[nodiscard]] RuntimeStatus GetStatus() const noexcept {
    return status_.load(std::memory_order_acquire);
  }

  [[nodiscard]] bool IsChainReady() const noexcept {
    return chain_ready_.load(std::memory_order_acquire);
  }

  [[nodiscard]] std::uint32_t GetLastObservedPassMask() const noexcept {
    return last_observed_pass_mask_.load(std::memory_order_acquire);
  }

 private:
  void Store(const FrameResult& result) noexcept {
    runtime_mode_.store(result.mode, std::memory_order_release);
    status_.store(result.status, std::memory_order_release);
    last_observed_pass_mask_.store(
        result.observed_pass_mask, std::memory_order_release);
  }

  std::atomic_uint32_t observed_pass_mask_ = 0u;
  std::atomic_bool chain_ready_ = false;
  std::atomic<RuntimeMode> runtime_mode_ = RuntimeMode::kVanilla;
  std::atomic<RuntimeStatus> status_ = RuntimeStatus::kVanilla;
  std::atomic_uint32_t last_observed_pass_mask_ = 0u;
};

}  // namespace renodx::games::detroitbecomehuman::dof
