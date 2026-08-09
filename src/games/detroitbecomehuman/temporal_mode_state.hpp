/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <cstdint>
#include <mutex>
#include <unordered_map>

#include "dlss_bridge_abi.h"

namespace renodx::games::detroitbecomehuman::temporal_mode_state {

struct Snapshot {
  DetroitDlssMode mode = DETROIT_DLSS_MODE_NATIVE;
  std::uint64_t generation = 1u;
};

struct SetModeResult {
  DetroitDlssMode previous = DETROIT_DLSS_MODE_NATIVE;
  bool changed = false;
};

struct Authorization {
  Snapshot snapshot = {};
  bool authorized = false;
};

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
    std::scoped_lock lock(mutex_);
    const auto previous = mode_.load(std::memory_order_relaxed);
    if (previous == mode) return {.previous = previous};
    AdvanceGenerationLocked();
    authorized_generation_by_command_list_.clear();
    mode_.store(mode, std::memory_order_release);
    return {.previous = previous, .changed = true};
  }

  void Reset(DetroitDlssMode mode = DETROIT_DLSS_MODE_NATIVE) {
    std::scoped_lock lock(mutex_);
    AdvanceGenerationLocked();
    authorized_generation_by_command_list_.clear();
    mode_.store(mode, std::memory_order_release);
  }

  [[nodiscard]] Authorization QueryAuthorization(
      std::uint64_t command_list) const {
    std::scoped_lock lock(mutex_);
    const Snapshot snapshot = {
        .mode = mode_.load(std::memory_order_relaxed),
        .generation = generation_,
    };
    if (command_list == 0u || snapshot.mode == DETROIT_DLSS_MODE_NATIVE) {
      return {.snapshot = snapshot};
    }
    const auto found = authorized_generation_by_command_list_.find(command_list);
    return {
        .snapshot = snapshot,
        .authorized = found != authorized_generation_by_command_list_.end()
                      && found->second == snapshot.generation,
    };
  }

  [[nodiscard]] bool Record(
      std::uint64_t command_list,
      const Snapshot& snapshot,
      bool output_valid) {
    if (command_list == 0u) return false;
    std::scoped_lock lock(mutex_);
    if (snapshot.generation != generation_
        || snapshot.mode != mode_.load(std::memory_order_relaxed)) {
      return false;
    }
    if (!output_valid || snapshot.mode == DETROIT_DLSS_MODE_NATIVE) {
      authorized_generation_by_command_list_.erase(command_list);
      return false;
    }
    authorized_generation_by_command_list_[command_list] = snapshot.generation;
    return true;
  }

 private:
  void AdvanceGenerationLocked() noexcept {
    ++generation_;
    if (generation_ == 0u) generation_ = 1u;
  }

  mutable std::mutex mutex_;
  std::atomic<DetroitDlssMode> mode_ = DETROIT_DLSS_MODE_NATIVE;
  std::uint64_t generation_ = 1u;
  std::unordered_map<std::uint64_t, std::uint64_t>
      authorized_generation_by_command_list_;
};

}  // namespace renodx::games::detroitbecomehuman::temporal_mode_state
