/*
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
#include <iostream>

#include "../../src/games/detroitbecomehuman/dlss_scale_transition.hpp"

namespace scale =
    renodx::games::detroitbecomehuman::dlss_scale_transition;

namespace {

bool Expect(bool condition, const char* message) {
  if (!condition) std::cerr << "FAIL: " << message << '\n';
  return condition;
}

bool TestPreflightBeforeScale() {
  bool passed = true;
  scale::Controller controller;
  controller.Reset(7u, 11u);
  passed &= Expect(
      controller.GetPhase() == scale::Phase::kWaitingForSettings,
      "reset must wait for queried NGX settings");
  passed &= Expect(
      controller.Observe({.preflight_serial = 8u}) == scale::Action::kNone,
      "preflight cannot lower resolution before settings are accepted");
  passed &= Expect(
      controller.MarkSettingsReady(),
      "settings must advance the state machine once");
  passed &= Expect(
      controller.Observe({.preflight_serial = 7u}) == scale::Action::kNone,
      "stale preflight must not lower resolution");
  passed &= Expect(
      controller.Observe({.preflight_serial = 8u})
          == scale::Action::kApplyTargetScale,
      "a new native preflight must authorize the target scale");
  passed &= Expect(
      controller.MarkTargetScaleApplied(),
      "successful runtime scale application must be acknowledged");
  return passed;
}

bool TestSuccessfulTransitionAndTransientFailure() {
  bool passed = true;
  scale::Controller controller;
  controller.Reset(1u, 10u);
  (void)controller.MarkSettingsReady();
  passed &= Expect(
      controller.Observe({.preflight_serial = 2u})
          == scale::Action::kApplyTargetScale,
      "fresh preflight must request target scale");
  (void)controller.MarkTargetScaleApplied();

  passed &= Expect(
      controller.Observe({
          .preflight_serial = 2u,
          .evaluation_serial = 11u,
          .target_extent_observed = true,
          .dlss_output_valid = false,
      }) == scale::Action::kNone,
      "first transition evaluation may safely fall back");
  passed &= Expect(
      controller.GetPhase() == scale::Phase::kWaitingForDlss,
      "observed target extent must advance to DLSS wait");
  passed &= Expect(
      controller.Observe({
          .evaluation_serial = 12u,
          .target_extent_observed = true,
          .dlss_output_valid = true,
      }) == scale::Action::kNone,
      "valid DLSS output must complete the transition");
  passed &= Expect(
      controller.GetPhase() == scale::Phase::kActive,
      "valid output must mark SR active");
  passed &= Expect(
      controller.Observe({
          .evaluation_serial = 13u,
          .target_extent_observed = true,
          .dlss_output_valid = false,
      }) == scale::Action::kNone,
      "one transient active-frame fallback must be tolerated");
  passed &= Expect(
      controller.GetPhase() == scale::Phase::kActive,
      "transient failure must not oscillate render scale");
  passed &= Expect(
      controller.Observe({
          .evaluation_serial = 14u,
          .target_extent_observed = true,
          .dlss_output_valid = true,
      }) == scale::Action::kNone
          && controller.GetFailureCount() == 0u,
      "a later success must clear the failure streak");
  return passed;
}

bool TestPersistentFailureRestoresNative() {
  bool passed = true;
  scale::Controller controller;
  controller.Reset(3u, 20u);
  (void)controller.MarkSettingsReady();
  (void)controller.Observe({.preflight_serial = 4u});
  (void)controller.MarkTargetScaleApplied();
  (void)controller.Observe({
      .evaluation_serial = 21u,
      .target_extent_observed = true,
  });

  scale::Action action = scale::Action::kNone;
  for (std::uint32_t index = 0u;
       index < scale::Controller::kMaximumConsecutiveFailures - 1u;
       ++index) {
    action = controller.Observe({
        .evaluation_serial = 22u + index,
        .target_extent_observed = true,
    });
  }
  passed &= Expect(
      action == scale::Action::kRestoreNativeScale,
      "persistent DLSS failure must restore native render scale");
  passed &= Expect(
      controller.GetPhase() == scale::Phase::kFallbackLatched,
      "fallback must stay latched until an explicit session reset");
  passed &= Expect(
      controller.Observe({
          .evaluation_serial = 99u,
          .target_extent_observed = true,
          .dlss_output_valid = true,
      }) == scale::Action::kRestoreNativeScale,
      "a late success must not silently re-enter reduced resolution");
  controller.Reset(5u, 99u);
  passed &= Expect(
      controller.GetPhase() == scale::Phase::kWaitingForSettings,
      "mode or output change must permit an explicit retry");
  return passed;
}

bool TestMissingTargetExtentTimesOut() {
  bool passed = true;
  scale::Controller controller;
  controller.Reset(1u, 1u);
  (void)controller.MarkSettingsReady();
  (void)controller.Observe({.preflight_serial = 2u});
  (void)controller.MarkTargetScaleApplied();

  scale::Action action = scale::Action::kNone;
  for (std::uint32_t index = 0u;
       index < scale::Controller::kMaximumTransitionPresents;
       ++index) {
    action = controller.Observe({
        .evaluation_serial = 1u,
        .target_extent_observed = false,
    });
  }
  passed &= Expect(
      action == scale::Action::kRestoreNativeScale,
      "an unobserved target extent must not leave low-resolution TAA active");
  return passed;
}

bool TestMissingActiveEvaluationsRestoreNative() {
  bool passed = true;
  scale::Controller controller;
  controller.Reset(1u, 1u);
  (void)controller.MarkSettingsReady();
  (void)controller.Observe({.preflight_serial = 2u});
  (void)controller.MarkTargetScaleApplied();
  (void)controller.Observe({
      .evaluation_serial = 2u,
      .target_extent_observed = true,
      .dlss_output_valid = true,
  });
  passed &= Expect(
      controller.GetPhase() == scale::Phase::kActive,
      "test setup must reach active SR");

  scale::Action action = scale::Action::kNone;
  for (std::uint32_t index = 0u;
       index < scale::Controller::kMaximumTransitionPresents;
       ++index) {
    action = controller.Observe({
        .evaluation_serial = 2u,
        .target_extent_observed = true,
        .dlss_output_valid = false,
    });
  }
  passed &= Expect(
      action == scale::Action::kRestoreNativeScale,
      "a stopped temporal path must not leave reduced native TAA active");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestPreflightBeforeScale();
  passed &= TestSuccessfulTransitionAndTransientFailure();
  passed &= TestPersistentFailureRestoresNative();
  passed &= TestMissingTargetExtentTimesOut();
  passed &= TestMissingActiveEvaluationsRestoreNative();
  std::cerr << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
