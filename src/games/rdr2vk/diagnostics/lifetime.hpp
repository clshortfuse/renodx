/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "../diagnostics_config.hpp"

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS

#include <cstdint>

namespace rdr2vk::diagnostics::lifetime {

enum class Event : std::uint8_t {
  CREATE,
  DESTROY_ENTER,
  DESTROY_EVENT,
  DESTROY_RETURN,
};

enum class Problem : std::uint8_t {
  NONE,
  RECREATE_DURING_DESTROY,
  OVERLAPPING_DESTROY,
  REPEATED_NATIVE_DESTROY,
  DUPLICATE_CALLBACK,
  REPEATED_UNBRACKETED_EVENT,
  RETURN_FROM_OLDER_LIFETIME,
  REFERENCE_AFTER_DESTROY,
  REFERENCE_DURING_DESTROY,
};

// These are observations, not permission to skip a destroy or reuse a view.
// A native return is CPU-side completion of that call, NOT GPU completion.
struct LifetimeState {
  std::uint64_t generation = 0;
  std::uint64_t last_event_request = 0;
  std::uint32_t active_destroys = 0;
  bool destruction_requested = false;
  bool event_seen = false;
  bool native_completed = false;

  constexpr Problem Apply(Event event, std::uint64_t request, std::uint64_t request_generation = 0) {
    switch (event) {
      case Event::CREATE: {
        const bool overlap = active_destroys != 0;
        const auto next_generation = generation + 1;
        *this = {.generation = next_generation};
        return (overlap ? Problem::RECREATE_DURING_DESTROY : Problem::NONE);
      }
      case Event::DESTROY_ENTER: {
        Problem problem = Problem::NONE;
        if (active_destroys != 0) {
          problem = Problem::OVERLAPPING_DESTROY;
        } else if (destruction_requested || event_seen || native_completed) {
          problem = Problem::REPEATED_NATIVE_DESTROY;
        }
        ++active_destroys;
        destruction_requested = true;
        return problem;
      }
      case Event::DESTROY_EVENT: {
        Problem problem = Problem::NONE;
        if (event_seen) {
          problem = (request != 0 && request == last_event_request
                         ? Problem::DUPLICATE_CALLBACK
                         : Problem::REPEATED_UNBRACKETED_EVENT);
        }
        event_seen = true;
        last_event_request = request;
        return problem;
      }
      case Event::DESTROY_RETURN:
        if (request_generation != generation) return Problem::RETURN_FROM_OLDER_LIFETIME;
        if (active_destroys != 0) {
          --active_destroys;
        }
        native_completed = true;
        return Problem::NONE;
    }
    return Problem::NONE;
  }

  [[nodiscard]] constexpr Problem ReferenceProblem() const {
    if (active_destroys != 0) return Problem::REFERENCE_DURING_DESTROY;
    if (native_completed || event_seen) return Problem::REFERENCE_AFTER_DESTROY;
    return Problem::NONE;
  }
};

// Pure models only: never exercise duplicate native destruction in the driver.
static_assert([] {
  LifetimeState state;
  state.Apply(Event::CREATE, 0);
  if (state.ReferenceProblem() != Problem::NONE) return false;
  if (state.Apply(Event::DESTROY_ENTER, 1) != Problem::NONE) return false;
  if (state.ReferenceProblem() != Problem::REFERENCE_DURING_DESTROY) return false;
  if (state.Apply(Event::DESTROY_EVENT, 1) != Problem::NONE) return false;
  if (state.Apply(Event::DESTROY_EVENT, 1) != Problem::DUPLICATE_CALLBACK) return false;
  if (state.Apply(Event::DESTROY_RETURN, 1, 1) != Problem::NONE) return false;
  if (state.ReferenceProblem() != Problem::REFERENCE_AFTER_DESTROY) return false;
  if (state.Apply(Event::DESTROY_ENTER, 2) != Problem::REPEATED_NATIVE_DESTROY) return false;
  state.Apply(Event::DESTROY_RETURN, 2, 1);
  state.Apply(Event::CREATE, 0);
  if (state.Apply(Event::DESTROY_ENTER, 3) != Problem::NONE) return false;
  if (state.Apply(Event::DESTROY_ENTER, 4) != Problem::OVERLAPPING_DESTROY) return false;
  if (state.Apply(Event::CREATE, 0) != Problem::RECREATE_DURING_DESTROY) return false;
  return state.Apply(Event::DESTROY_RETURN, 3, 2) == Problem::RETURN_FROM_OLDER_LIFETIME
         && !state.native_completed && state.ReferenceProblem() == Problem::NONE;
}());

static_assert([] {
  LifetimeState unknown;
  if (unknown.Apply(Event::DESTROY_EVENT, 0) != Problem::NONE) return false;
  if (unknown.Apply(Event::DESTROY_EVENT, 0) != Problem::REPEATED_UNBRACKETED_EVENT) return false;
  unknown.Apply(Event::CREATE, 0);
  return unknown.generation == 1 && unknown.ReferenceProblem() == Problem::NONE;
}());

}  // namespace rdr2vk::diagnostics::lifetime

#endif  // RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS