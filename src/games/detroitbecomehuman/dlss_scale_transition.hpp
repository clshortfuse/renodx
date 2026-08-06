/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>

namespace renodx::games::detroitbecomehuman::dlss_scale_transition {

enum class Phase : std::uint32_t {
  kIdle = 0u,
  kWaitingForSettings,
  kWaitingForNativePreflight,
  kWaitingForTargetExtent,
  kWaitingForDlss,
  kActive,
  kFallbackLatched,
};

enum class Action : std::uint32_t {
  kNone = 0u,
  kApplyTargetScale,
  kRestoreNativeScale,
};

struct Observation {
  std::uint64_t preflight_serial = 0u;
  std::uint64_t evaluation_serial = 0u;
  bool target_extent_observed = false;
  bool dlss_output_valid = false;
};

// The scale transition deliberately requires a full-resolution temporal pass
// before lowering Detroit's derived render dimensions. Once lowered, failure
// is bounded: native TAA is restored instead of being left at DLSS's input
// resolution without a valid DLSS output.
class Controller {
 public:
  static constexpr std::uint32_t kMaximumTransitionPresents = 600u;
  static constexpr std::uint32_t kMaximumConsecutiveFailures = 4u;

  void Reset(
      std::uint64_t preflight_serial,
      std::uint64_t evaluation_serial) noexcept {
    phase_ = Phase::kWaitingForSettings;
    baseline_preflight_serial_ = preflight_serial;
    last_evaluation_serial_ = evaluation_serial;
    transition_presents_ = 0u;
    consecutive_failures_ = 0u;
  }

  void SetIdle() noexcept {
    phase_ = Phase::kIdle;
    transition_presents_ = 0u;
    consecutive_failures_ = 0u;
  }

  [[nodiscard]] bool MarkSettingsReady() noexcept {
    if (phase_ != Phase::kWaitingForSettings) return false;
    phase_ = Phase::kWaitingForNativePreflight;
    transition_presents_ = 0u;
    return true;
  }

  [[nodiscard]] bool MarkTargetScaleApplied() noexcept {
    if (phase_ != Phase::kWaitingForNativePreflight) return false;
    phase_ = Phase::kWaitingForTargetExtent;
    transition_presents_ = 0u;
    consecutive_failures_ = 0u;
    return true;
  }

  void LatchFallback() noexcept {
    phase_ = Phase::kFallbackLatched;
    transition_presents_ = 0u;
    consecutive_failures_ = 0u;
  }

  [[nodiscard]] Action Observe(const Observation& observation) noexcept {
    switch (phase_) {
      case Phase::kWaitingForNativePreflight:
        if (observation.preflight_serial != 0u
            && observation.preflight_serial
                   != baseline_preflight_serial_) {
          return Action::kApplyTargetScale;
        }
        return Action::kNone;

      case Phase::kWaitingForTargetExtent:
        ++transition_presents_;
        (void)ObserveEvaluation(observation);
        if (observation.target_extent_observed) {
          phase_ = Phase::kWaitingForDlss;
          transition_presents_ = 0u;
          if (observation.dlss_output_valid
              && observation.evaluation_serial != 0u) {
            phase_ = Phase::kActive;
            consecutive_failures_ = 0u;
          }
          return Action::kNone;
        }
        if (transition_presents_ >= kMaximumTransitionPresents) {
          LatchFallback();
          return Action::kRestoreNativeScale;
        }
        return Action::kNone;

      case Phase::kWaitingForDlss:
      case Phase::kActive:         {
        ++transition_presents_;
        const bool new_evaluation = ObserveEvaluation(observation);
        if (new_evaluation && observation.dlss_output_valid) {
          phase_ = Phase::kActive;
          transition_presents_ = 0u;
          consecutive_failures_ = 0u;
          return Action::kNone;
        }
        if (new_evaluation
            && consecutive_failures_ >= kMaximumConsecutiveFailures) {
          LatchFallback();
          return Action::kRestoreNativeScale;
        }
        if (transition_presents_ >= kMaximumTransitionPresents) {
          LatchFallback();
          return Action::kRestoreNativeScale;
        }
        return Action::kNone;
      }

      case Phase::kFallbackLatched:
        return Action::kRestoreNativeScale;

      case Phase::kIdle:
      case Phase::kWaitingForSettings:
      default:
        return Action::kNone;
    }
  }

  [[nodiscard]] Phase GetPhase() const noexcept { return phase_; }
  [[nodiscard]] std::uint32_t GetFailureCount() const noexcept {
    return consecutive_failures_;
  }

 private:
  [[nodiscard]] bool ObserveEvaluation(
      const Observation& observation) noexcept {
    if (observation.evaluation_serial == 0u
        || observation.evaluation_serial == last_evaluation_serial_) {
      return false;
    }
    last_evaluation_serial_ = observation.evaluation_serial;
    if (observation.dlss_output_valid) {
      consecutive_failures_ = 0u;
    } else {
      ++consecutive_failures_;
    }
    return true;
  }

  Phase phase_ = Phase::kIdle;
  std::uint64_t baseline_preflight_serial_ = 0u;
  std::uint64_t last_evaluation_serial_ = 0u;
  std::uint32_t transition_presents_ = 0u;
  std::uint32_t consecutive_failures_ = 0u;
};

}  // namespace renodx::games::detroitbecomehuman::dlss_scale_transition
