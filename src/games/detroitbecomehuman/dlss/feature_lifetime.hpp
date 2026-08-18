/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "../../../utils/dlss/feature_lifetime.hpp"

namespace renodx::games::detroitbecomehuman::dlss {

struct FeatureCreationGate final {
  using Handle = std::uint64_t;

  Handle command_buffer = 0u;
  bool submitted = false;

  [[nodiscard]] bool AllowsUseFrom(Handle current_command_buffer) const noexcept {
    return submitted
           || (command_buffer != 0u && current_command_buffer == command_buffer);
  }

  [[nodiscard]] bool InvalidatedByDiscard(
      Handle discarded_command_buffer) const noexcept {
    return !submitted && command_buffer != 0u
           && discarded_command_buffer == command_buffer;
  }

  void MarkSubmitted() noexcept { submitted = true; }
};

/*
 * Tracks references recorded into Vulkan command buffers separately from
 * references owned by successful queue submissions. A feature generation may
 * be destroyed only after both kinds of references have disappeared.
 *
 * Fence completion is consumed only when the Vulkan layer observes it
 * explicitly. Reusable command buffers retain their recorded reference until
 * an operation that invalidates the recording succeeds. One-time command
 * buffers may release their recording and private scratch resources after the
 * last matching submission has completed.
 */
using FeatureLifetimeTracker =
    renodx::utils::dlss::vulkan::FeatureLifetimeTracker;

}  // namespace renodx::games::detroitbecomehuman::dlss
