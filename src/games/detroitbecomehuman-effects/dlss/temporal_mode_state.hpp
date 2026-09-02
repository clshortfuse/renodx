/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <cstdint>
#include <mutex>
#include <unordered_map>

#include "feature_recording_registry.hpp"
#include "dlss_policy.hpp"

namespace renodx::games::detroitbecomehuman::temporal_mode_state {

struct Snapshot {
  DetroitDlssMode mode = DETROIT_DLSS_MODE_NATIVE;
  std::uint64_t generation = 1u;
};

struct SetModeResult {
  DetroitDlssMode previous = DETROIT_DLSS_MODE_NATIVE;
  Snapshot current = {};
  bool changed = false;
};

struct Authorization {
  Snapshot snapshot = {};
  bool replacement_eligible = false;
  bool authorized = false;
};

[[nodiscard]] constexpr bool CanUseNativeModeFastPath(
    DetroitDlssMode mode) noexcept {
  return mode == DETROIT_DLSS_MODE_NATIVE;
}

[[nodiscard]] constexpr bool CanUseNativePostDispatchFastPath(
    DetroitDlssMode mode, bool auxiliary_replacement_used) noexcept {
  return CanUseNativeModeFastPath(mode) && !auxiliary_replacement_used;
}

// A reusable Vulkan command buffer may retain its identity across several
// temporal-mode sessions. Tag every successful DLSS output with the mode
// generation that produced it so a Native TAA round-trip cannot authorize an
// auxiliary-only recording in a later DLAA session.
class Tracker {
 public:
  [[nodiscard]] DetroitDlssMode GetMode() const noexcept {
    return mode_.load(std::memory_order_acquire);
  }

  [[nodiscard]] Snapshot GetSnapshot() const {
    std::scoped_lock lock(mutex_);
    return {
        .mode = mode_.load(std::memory_order_relaxed),
        .generation = generation_,
    };
  }

  [[nodiscard]] SetModeResult SetMode(DetroitDlssMode mode) {
    mode = dlss_policy::NormalizeDlssMode(mode);
    std::scoped_lock lock(mutex_);
    const auto previous = mode_.load(std::memory_order_relaxed);
    if (previous == mode) {
      return {
          .previous = previous,
          .current = {
              .mode = previous,
              .generation = generation_,
          },
      };
    }
    AdvanceGenerationLocked();
    authorization_by_command_list_.clear();
    authorization_command_lists_.Clear();
    mode_.store(mode, std::memory_order_release);
    return {
        .previous = previous,
        .current = {
            .mode = mode,
            .generation = generation_,
        },
        .changed = true,
    };
  }

  void Reset(DetroitDlssMode mode = DETROIT_DLSS_MODE_NATIVE) {
    mode = dlss_policy::NormalizeDlssMode(mode);
    std::scoped_lock lock(mutex_);
    AdvanceGenerationLocked();
    authorization_by_command_list_.clear();
    authorization_command_lists_.Clear();
    mode_.store(mode, std::memory_order_release);
  }

  // A new command-buffer recording must prove its own DLSS output before CAS
  // suppression is authorized. Keep the previous successful generation only
  // for the pre-dispatch auxiliary-replacement decision.
  void BeginRecording(std::uint64_t command_list) {
    if (command_list == 0u) return;
    if (!authorization_command_lists_.Overflowed()
        && !authorization_command_lists_.Contains(command_list)) {
      return;
    }
    std::scoped_lock lock(mutex_);
    const auto found = authorization_by_command_list_.find(command_list);
    if (found != authorization_by_command_list_.end()) {
      found->second.current_recording_generation = 0u;
    }
  }

  void DiscardCommandList(std::uint64_t command_list) {
    if (command_list == 0u) return;
    std::scoped_lock lock(mutex_);
    authorization_by_command_list_.erase(command_list);
    (void)authorization_command_lists_.Erase(command_list);
  }

  [[nodiscard]] Authorization QueryAuthorization(
      std::uint64_t command_list) const {
    return QueryAuthorizationFields(command_list);
  }

  [[nodiscard]] bool Record(
      std::uint64_t command_list,
      const Snapshot& snapshot,
      bool output_valid) {
    if (command_list == 0u) return false;
    std::scoped_lock lock(mutex_);
    return RecordLocked(command_list, snapshot, output_valid);
  }

 private:
  [[nodiscard]] Authorization QueryAuthorizationFields(
      std::uint64_t command_list) const {
    std::scoped_lock lock(mutex_);
    const Snapshot snapshot = {
        .mode = mode_.load(std::memory_order_relaxed),
        .generation = generation_,
    };
    if (command_list == 0u || snapshot.mode == DETROIT_DLSS_MODE_NATIVE) {
      return {.snapshot = snapshot};
    }
    const auto found = authorization_by_command_list_.find(command_list);
    const auto replacement_generation =
        found == authorization_by_command_list_.end()
            ? 0u
            : found->second.replacement_generation;
    const auto authorized_generation =
        found == authorization_by_command_list_.end()
            ? 0u
            : found->second.current_recording_generation;
    return {
        .snapshot = snapshot,
        .replacement_eligible =
            replacement_generation == snapshot.generation,
        .authorized = authorized_generation == snapshot.generation,
    };
  }
  [[nodiscard]] bool RecordLocked(
      std::uint64_t command_list,
      const Snapshot& snapshot,
      bool output_valid) {
    if (command_list == 0u) return false;
    if (snapshot.generation != generation_
        || snapshot.mode != mode_.load(std::memory_order_relaxed)) {
      return false;
    }
    if (!output_valid || snapshot.mode == DETROIT_DLSS_MODE_NATIVE) {
      authorization_by_command_list_.erase(command_list);
      (void)authorization_command_lists_.Erase(command_list);
      return false;
    }
    authorization_by_command_list_[command_list] = {
        .replacement_generation = snapshot.generation,
        .current_recording_generation = snapshot.generation,
    };
    (void)authorization_command_lists_.Insert(command_list);
    return true;
  }
  void AdvanceGenerationLocked() noexcept {
    ++generation_;
    if (generation_ == 0u) generation_ = 1u;
  }

  mutable std::mutex mutex_;
  std::atomic<DetroitDlssMode> mode_ = DETROIT_DLSS_MODE_NATIVE;
  std::uint64_t generation_ = 1u;
  struct CommandAuthorization final {
    std::uint64_t replacement_generation = 0u;
    std::uint64_t current_recording_generation = 0u;
  };
  std::unordered_map<std::uint64_t, CommandAuthorization>
      authorization_by_command_list_;
  // ponytail: 64 exact slots cover Detroit's observed command-list rotation;
  // overflow deliberately restores the authoritative mutex path.
  dlss::FeatureRecordingRegistry<64u> authorization_command_lists_;
};

}  // namespace renodx::games::detroitbecomehuman::temporal_mode_state
