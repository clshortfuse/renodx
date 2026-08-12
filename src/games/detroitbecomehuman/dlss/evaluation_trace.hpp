/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <cstdint>
#include <optional>
#include <string_view>

namespace renodx::games::detroitbecomehuman::dlss {

enum class EvaluationTerminal : std::uint8_t {
  kDeviceIdentityMismatch,
  kNotConfigured,
  kNativeMode,
  kAdapterUnavailable,
  kInvalidFrame,
  kCommandStateUnrestorable,
  kNgxInitializationFailed,
  kFeatureCreationPending,
  kFeatureCreationFailed,
  kResourceRejected,
  kPrepareFailed,
  kEvaluateFailed,
  kCommitFailed,
  kSuccess,
};

[[nodiscard]] constexpr std::string_view EvaluationTerminalName(
    EvaluationTerminal terminal) noexcept {
  switch (terminal) {
    case EvaluationTerminal::kDeviceIdentityMismatch:
      return "device_identity_mismatch";
    case EvaluationTerminal::kNotConfigured:
      return "not_configured";
    case EvaluationTerminal::kNativeMode:
      return "native_mode";
    case EvaluationTerminal::kAdapterUnavailable:
      return "adapter_unavailable";
    case EvaluationTerminal::kInvalidFrame:
      return "invalid_frame";
    case EvaluationTerminal::kCommandStateUnrestorable:
      return "command_state_unrestorable";
    case EvaluationTerminal::kNgxInitializationFailed:
      return "ngx_initialization_failed";
    case EvaluationTerminal::kFeatureCreationPending:
      return "feature_creation_pending";
    case EvaluationTerminal::kFeatureCreationFailed:
      return "feature_creation_failed";
    case EvaluationTerminal::kResourceRejected:
      return "resource_rejected";
    case EvaluationTerminal::kPrepareFailed:
      return "prepare_failed";
    case EvaluationTerminal::kEvaluateFailed:
      return "evaluate_failed";
    case EvaluationTerminal::kCommitFailed:
      return "commit_failed";
    case EvaluationTerminal::kSuccess:
      return "success";
  }
  return "invalid_terminal";
}

class FirstThreeAttemptWindow final {
 public:
  static constexpr std::uint32_t kAttemptLimit = 3u;

  struct Attempt final {
    std::uint32_t window = 0u;
    std::uint32_t attempt = 0u;

    bool operator==(const Attempt&) const = default;
  };

  [[nodiscard]] std::uint32_t Arm() noexcept {
    std::uint64_t current = state_.load(std::memory_order_relaxed);
    for (;;) {
      auto next_window = static_cast<std::uint32_t>(current >> 32u) + 1u;
      if (next_window == 0u) next_window = 1u;
      const std::uint64_t next = static_cast<std::uint64_t>(next_window) << 32u;
      if (state_.compare_exchange_weak(
              current,
              next,
              std::memory_order_acq_rel,
              std::memory_order_relaxed)) {
        return next_window;
      }
    }
  }

  [[nodiscard]] std::optional<Attempt> Begin() noexcept {
    std::uint64_t current = state_.load(std::memory_order_relaxed);
    for (;;) {
      const auto window = static_cast<std::uint32_t>(current >> 32u);
      const auto attempt = static_cast<std::uint32_t>(current);
      if (window == 0u || attempt >= kAttemptLimit) return std::nullopt;
      const std::uint64_t next =
          (static_cast<std::uint64_t>(window) << 32u) | (attempt + 1u);
      if (state_.compare_exchange_weak(
              current,
              next,
              std::memory_order_acq_rel,
              std::memory_order_relaxed)) {
        return Attempt{.window = window, .attempt = attempt + 1u};
      }
    }
  }

  [[nodiscard]] std::uint32_t Count() const noexcept {
    return static_cast<std::uint32_t>(state_.load(std::memory_order_acquire));
  }

  [[nodiscard]] std::uint32_t Window() const noexcept {
    return static_cast<std::uint32_t>(
        state_.load(std::memory_order_acquire) >> 32u);
  }

 private:
  // The high word is the activation window; the low word is its attempt count.
  // Packing both values makes a mode-transition re-arm atomic with Begin().
  std::atomic<std::uint64_t> state_ = 0u;
};

}  // namespace renodx::games::detroitbecomehuman::dlss
