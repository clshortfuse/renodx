/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <atomic>
#include <cstddef>
#include <cstdint>

namespace renodx::games::detroitbecomehuman::dlss {

// Writers are serialized by the owner. Readers stay lock-free so an unrelated
// command-buffer lifecycle hook does not need to enter the owner mutex.
template <std::size_t Capacity>
class FeatureRecordingRegistry final {
  static_assert(Capacity != 0u);
  static_assert(std::atomic<std::uint64_t>::is_always_lock_free);

 public:
  FeatureRecordingRegistry() noexcept { Clear(); }

  [[nodiscard]] bool Insert(std::uint64_t handle) noexcept {
    if (handle == 0u) return false;
    for (auto& slot : slots_) {
      auto current = slot.handle.load(std::memory_order_acquire);
      if (current == handle) return true;
      if (current != 0u) continue;
      if (slot.handle.compare_exchange_strong(
              current,
              handle,
              std::memory_order_release,
              std::memory_order_acquire)) {
        return true;
      }
      if (current == handle) return true;
    }
    // Capacity covers both live scratch owners and stale slots awaiting a
    // serialized lifecycle erase. Preserve correctness if that invariant ever
    // drifts by falling back to Bloom-only filtering for this device lifetime.
    overflowed_.store(true, std::memory_order_release);
    return false;
  }

  [[nodiscard]] bool Contains(std::uint64_t handle) const noexcept {
    if (handle == 0u) return false;
    for (const auto& slot : slots_) {
      if (slot.handle.load(std::memory_order_acquire) == handle) return true;
    }
    return false;
  }

  [[nodiscard]] bool Erase(std::uint64_t handle) noexcept {
    if (handle == 0u) return false;
    for (auto& slot : slots_) {
      if (slot.handle.load(std::memory_order_acquire) != handle) continue;
      slot.handle.store(0u, std::memory_order_release);
      return true;
    }
    return false;
  }

  [[nodiscard]] bool Empty() const noexcept {
    for (const auto& slot : slots_) {
      if (slot.handle.load(std::memory_order_acquire) != 0u) return false;
    }
    return true;
  }

  [[nodiscard]] bool HasLifecycleCandidates() const noexcept {
    // Overflow means at least one Bloom-only owner was not published in an
    // exact slot. Keep lifecycle hooks conservative for the rest of the device
    // lifetime even after every exact slot has subsequently been erased.
    return Overflowed() || !Empty();
  }

  [[nodiscard]] bool Overflowed() const noexcept {
    return overflowed_.load(std::memory_order_acquire);
  }

  void Clear() noexcept {
    for (auto& slot : slots_) {
      slot.handle.store(0u, std::memory_order_relaxed);
    }
    overflowed_.store(false, std::memory_order_release);
  }

 private:
  struct Slot final {
    std::atomic<std::uint64_t> handle = 0u;
  };

  std::array<Slot, Capacity> slots_ = {};
  std::atomic<bool> overflowed_ = false;
};

}  // namespace renodx::games::detroitbecomehuman::dlss
