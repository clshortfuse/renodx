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

struct SubmissionTraceRecord final {
  std::uint32_t attempt = 0u;
  std::uint64_t recording_generation = 0u;
  std::uint64_t recording_epoch = 0u;
  bool submit_logged = false;
};

// The Vulkan layer supplies external synchronization for this tracker. Keeping
// the recording epoch beside the command-buffer handle prevents a completion
// from an older recording from consuming a newer attempt after handle reuse.
class SubmissionTraceTracker final {
 public:
  using Handle = std::uint64_t;

  void Associate(
      Handle command_buffer,
      std::uint32_t attempt,
      std::uint64_t recording_generation) {
    if (command_buffer == 0u || attempt == 0u) return;
    records_.insert_or_assign(
        command_buffer,
        SubmissionTraceRecord{
            .attempt = attempt,
            .recording_generation = recording_generation,
        });
  }

  [[nodiscard]] std::optional<SubmissionTraceRecord> MarkSubmitted(
      Handle command_buffer, std::uint64_t recording_epoch) {
    if (command_buffer == 0u || recording_epoch == 0u) return std::nullopt;
    const auto found = records_.find(command_buffer);
    if (found == records_.end()) return std::nullopt;
    auto& record = found->second;
    if ((record.recording_epoch != 0u
         && record.recording_epoch != recording_epoch)
        || record.submit_logged) {
      return std::nullopt;
    }
    record.recording_epoch = recording_epoch;
    record.submit_logged = true;
    return record;
  }

  [[nodiscard]] bool NeedsCompletion(
      Handle command_buffer, std::uint64_t recording_epoch) const noexcept {
    if (command_buffer == 0u || recording_epoch == 0u) return false;
    const auto found = records_.find(command_buffer);
    return found != records_.end()
           && (found->second.recording_epoch == 0u
               || found->second.recording_epoch == recording_epoch);
  }

  [[nodiscard]] std::optional<SubmissionTraceRecord> Complete(
      Handle command_buffer, std::uint64_t recording_epoch = 0u) {
    if (command_buffer == 0u) return std::nullopt;
    const auto found = records_.find(command_buffer);
    if (found == records_.end() || !found->second.submit_logged
        || (recording_epoch != 0u && found->second.recording_epoch != 0u
            && found->second.recording_epoch != recording_epoch)) {
      return std::nullopt;
    }
    const auto record = found->second;
    records_.erase(found);
    return record;
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
  std::unordered_map<Handle, SubmissionTraceRecord> records_;
};

}  // namespace renodx::games::detroitbecomehuman::dlss
