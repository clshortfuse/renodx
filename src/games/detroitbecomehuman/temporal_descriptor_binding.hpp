/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>

namespace renodx::games::detroitbecomehuman::temporal_descriptor_binding {

struct Snapshot {
  std::uint64_t pipeline_layout = 0u;
  std::uint64_t descriptor_set = 0u;

  [[nodiscard]] constexpr bool IsValid() const noexcept {
    return pipeline_layout != 0u && descriptor_set != 0u;
  }
};

// Tracks only Vulkan compute set 0. Detroit's temporal resources ping-pong
// between two long-lived descriptor sets, so descriptor-update recency cannot
// identify the set consumed by the current dispatch.
class Tracker final {
 public:
  void Reset() noexcept {
    tracking_epoch_ = 0u;
    pipeline_layout_ = 0u;
    descriptor_set_ = 0u;
  }

  void ObserveComputeBind(
      std::uint64_t tracking_epoch,
      std::uint64_t pipeline_layout,
      std::uint32_t first_set,
      std::uint32_t descriptor_set_count,
      std::uint64_t first_descriptor_set) noexcept {
    if (tracking_epoch == 0u) {
      Reset();
      return;
    }
    if (tracking_epoch_ != tracking_epoch) {
      Reset();
      tracking_epoch_ = tracking_epoch;
    }
    if (pipeline_layout_ != pipeline_layout) {
      descriptor_set_ = 0u;
    }
    pipeline_layout_ = pipeline_layout;

    if (pipeline_layout == 0u) {
      descriptor_set_ = 0u;
      return;
    }
    if (first_set == 0u && descriptor_set_count != 0u) {
      descriptor_set_ = first_descriptor_set;
    }
  }

  [[nodiscard]] Snapshot Resolve(
      std::uint64_t tracking_epoch,
      std::uint64_t expected_pipeline_layout) const noexcept {
    if (tracking_epoch == 0u
        || tracking_epoch_ != tracking_epoch
        || expected_pipeline_layout == 0u
        || pipeline_layout_ != expected_pipeline_layout
        || descriptor_set_ == 0u) {
      return {};
    }
    return {
        .pipeline_layout = pipeline_layout_,
        .descriptor_set = descriptor_set_,
    };
  }

 private:
  std::uint64_t tracking_epoch_ = 0u;
  std::uint64_t pipeline_layout_ = 0u;
  std::uint64_t descriptor_set_ = 0u;
};

}  // namespace renodx::games::detroitbecomehuman::temporal_descriptor_binding
