/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <cstddef>
#include <cstdint>
#include <optional>
#include <string_view>
#include <unordered_map>

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

struct SubmissionTraceRecord final {
  std::uint32_t window = 0u;
  std::uint32_t attempt = 0u;
  std::uint64_t recording_generation = 0u;
  std::uint64_t recording_epoch = 0u;
  std::uint32_t submit_count = 0u;
  bool one_time_submit = false;
  bool completion_logged = false;
};

// The Vulkan layer supplies external synchronization for this tracker. Keeping
// the recording epoch beside the command-buffer handle prevents a completion
// from an older recording from consuming a newer attempt after handle reuse.
class SubmissionTraceTracker final {
 public:
  using Handle = std::uint64_t;
  static constexpr std::uint32_t kSubmitLogLimit = 4u;

  void Associate(
      Handle command_buffer,
      std::uint32_t window,
      std::uint32_t attempt,
      std::uint64_t recording_generation,
      bool one_time_submit) {
    if (command_buffer == 0u || window == 0u || attempt == 0u) return;
    records_.insert_or_assign(
        command_buffer,
        SubmissionTraceRecord{
            .window = window,
            .attempt = attempt,
            .recording_generation = recording_generation,
            .one_time_submit = one_time_submit,
        });
  }

  [[nodiscard]] std::optional<SubmissionTraceRecord> MarkSubmitted(
      Handle command_buffer,
      std::uint64_t recording_epoch,
      bool one_time_submit) {
    if (command_buffer == 0u || recording_epoch == 0u) return std::nullopt;
    const auto found = records_.find(command_buffer);
    if (found == records_.end()) return std::nullopt;
    auto& record = found->second;
    if (record.recording_epoch != 0u
        && record.recording_epoch != recording_epoch) {
      return std::nullopt;
    }
    record.recording_epoch = recording_epoch;
    record.one_time_submit = one_time_submit;
    return CountSubmit(record);
  }

  // A completed one-time recording is removed from FeatureLifetimeTracker, so
  // a later illegal resubmit has no core SubmissionSnapshot. Keep a small
  // diagnostic tombstone until begin/reset/free/pool lifecycle invalidates the
  // layer recording generation, and classify only that exact post-completion
  // replay. This never restores feature ownership or affects submission.
  [[nodiscard]] std::optional<SubmissionTraceRecord>
  MarkPostCompletionResubmitted(
      Handle command_buffer, std::uint64_t recording_generation) {
    if (command_buffer == 0u || recording_generation == 0u) {
      return std::nullopt;
    }
    const auto found = records_.find(command_buffer);
    if (found == records_.end()) return std::nullopt;
    auto& record = found->second;
    if (!record.completion_logged || record.submit_count == 0u
        || record.recording_generation != recording_generation) {
      return std::nullopt;
    }
    return CountSubmit(record);
  }

  [[nodiscard]] bool NeedsCompletion(
      Handle command_buffer, std::uint64_t recording_epoch) const noexcept {
    if (command_buffer == 0u || recording_epoch == 0u) return false;
    const auto found = records_.find(command_buffer);
    return found != records_.end() && !found->second.completion_logged
           && (found->second.recording_epoch == 0u
               || found->second.recording_epoch == recording_epoch);
  }

  [[nodiscard]] std::optional<SubmissionTraceRecord> Complete(
      Handle command_buffer, std::uint64_t recording_epoch = 0u) {
    if (command_buffer == 0u) return std::nullopt;
    const auto found = records_.find(command_buffer);
    if (found == records_.end() || found->second.submit_count == 0u
        || found->second.completion_logged
        || (recording_epoch != 0u && found->second.recording_epoch != 0u
            && found->second.recording_epoch != recording_epoch)) {
      return std::nullopt;
    }
    found->second.completion_logged = true;
    return found->second;
  }

  bool Discard(Handle command_buffer, std::uint64_t recording_epoch = 0u) {
    if (command_buffer == 0u) return false;
    const auto found = records_.find(command_buffer);
    if (found == records_.end()
        || (recording_epoch != 0u && found->second.recording_epoch != 0u
            && found->second.recording_epoch != recording_epoch)) {
      return false;
    }
    records_.erase(found);
    return true;
  }

  void Clear() noexcept { records_.clear(); }

  [[nodiscard]] std::size_t Size() const noexcept { return records_.size(); }

 private:
  [[nodiscard]] static std::optional<SubmissionTraceRecord> CountSubmit(
      SubmissionTraceRecord& record) noexcept {
    // Saturate one past the log limit. The record remains a bounded tombstone,
    // while every emitted line is capped at the initial submit plus three
    // repeats regardless of how often an invalid recording is replayed.
    if (record.submit_count <= kSubmitLogLimit) ++record.submit_count;
    return record.submit_count <= kSubmitLogLimit
               ? std::optional<SubmissionTraceRecord>(record)
               : std::nullopt;
  }

  std::unordered_map<Handle, SubmissionTraceRecord> records_;
};

}  // namespace renodx::games::detroitbecomehuman::dlss
