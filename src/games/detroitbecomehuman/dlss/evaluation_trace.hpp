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

  [[nodiscard]] std::optional<std::uint32_t> Begin() noexcept {
    std::uint32_t current = attempts_.load(std::memory_order_relaxed);
    while (current < kAttemptLimit) {
      if (attempts_.compare_exchange_weak(
              current,
              current + 1u,
              std::memory_order_acq_rel,
              std::memory_order_relaxed)) {
        return current + 1u;
      }
    }
    return std::nullopt;
  }

  [[nodiscard]] std::uint32_t Count() const noexcept {
    return attempts_.load(std::memory_order_acquire);
  }

 private:
  std::atomic<std::uint32_t> attempts_ = 0u;
};

}  // namespace renodx::games::detroitbecomehuman::dlss
