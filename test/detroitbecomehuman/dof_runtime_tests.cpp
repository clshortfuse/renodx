/*
 * SPDX-License-Identifier: MIT
 */

#include <iostream>
#include <string_view>

#include "src/games/detroitbecomehuman/dof_runtime.hpp"

namespace {

namespace dof = renodx::games::detroitbecomehuman::dof;

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

void ObserveCompleteChain(dof::RuntimeController* controller) {
  controller->Observe(dof::Pass::kSplit);
  controller->Observe(dof::Pass::kGather);
  controller->Observe(dof::Pass::kFill);
  controller->Observe(dof::Pass::kComposite);
}

bool TestFailClosedLifecycle() {
  dof::RuntimeController controller;
  bool passed = true;

  auto frame = controller.FinishFrame(
      dof::RuntimeStyle::kClean, false, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kVanilla
          && frame.status == dof::RuntimeStatus::kWaitingForChain,
      "Enhanced must wait in Vanilla when no DOF chain was observed");

  controller.Observe(dof::Pass::kSplit);
  controller.Observe(dof::Pass::kComposite);
  frame = controller.FinishFrame(
      dof::RuntimeStyle::kClean, false, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kVanilla
          && frame.status == dof::RuntimeStatus::kIncompleteChain,
      "a partial chain must fail closed");

  ObserveCompleteChain(&controller);
  frame = controller.FinishFrame(
      dof::RuntimeStyle::kClean, false, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kCleanBalanced
          && frame.status == dof::RuntimeStatus::kActiveCleanBalanced
          && frame.observed_pass_mask == dof::kCompletePassMask,
      "the first complete Vanilla frame must arm Clean Balanced for the next frame");

  ObserveCompleteChain(&controller);
  frame = controller.FinishFrame(
      dof::RuntimeStyle::kClean, true, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kCleanHigh
          && frame.status == dof::RuntimeStatus::kActiveCleanHigh,
      "a complete chain must select Clean High explicitly");

  ObserveCompleteChain(&controller);
  frame = controller.FinishFrame(
      dof::RuntimeStyle::kCinematic, false, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kCinematicBalanced
          && frame.status == dof::RuntimeStatus::kActiveCinematicBalanced,
      "a complete chain must select Cinematic Balanced explicitly");

  ObserveCompleteChain(&controller);
  frame = controller.FinishFrame(
      dof::RuntimeStyle::kCinematic, true, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kCinematicHigh
          && frame.status == dof::RuntimeStatus::kActiveCinematicHigh,
      "a complete chain must select Cinematic High explicitly");

  frame = controller.FinishFrame(
      dof::RuntimeStyle::kCinematic, true, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kVanilla
          && frame.status == dof::RuntimeStatus::kWaitingForChain,
      "a missing chain after activation must return to Vanilla");
  return passed;
}

bool TestModeAndBuildGates() {
  dof::RuntimeController controller;
  bool passed = true;

  ObserveCompleteChain(&controller);
  auto frame = controller.FinishFrame(
      dof::RuntimeStyle::kVanilla, true, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kVanilla
          && frame.status == dof::RuntimeStatus::kVanilla,
      "Vanilla selection must override a complete chain and quality setting");

  ObserveCompleteChain(&controller);
  frame = controller.FinishFrame(
      dof::RuntimeStyle::kCinematic, false, false);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kVanilla
          && frame.status == dof::RuntimeStatus::kUnsupportedBuild,
      "unsupported builds must fail closed after a complete chain");

  controller.Reset();
  passed &= Expect(
      controller.GetMode() == dof::RuntimeMode::kVanilla
          && controller.GetStatus() == dof::RuntimeStatus::kVanilla
          && !controller.IsChainReady()
          && controller.GetLastObservedPassMask() == 0u,
      "device reset must clear all DOF runtime state");
  return passed;
}

bool TestPackedControls() {
  bool passed = true;
  const dof::RuntimeControls neutral;
  passed &= Expect(
      dof::UnpackRuntimeBits(dof::PackRuntimePayload(
          dof::RuntimeMode::kVanilla,
          {
              .focus_distance_percent = 200.f,
              .blur_radius_percent = 0.f,
              .near_strength_percent = 200.f,
              .far_strength_percent = 0.f,
              .edge_bokeh_percent = 200.f,
          }))
          == 0u,
      "Vanilla must ignore every custom control and keep a zero payload");
  const float payload = dof::PackRuntimePayload(
      dof::RuntimeMode::kCleanHigh, neutral);
  const std::uint32_t bits = dof::UnpackRuntimeBits(payload);
  passed &= Expect(
      (bits & dof::kModeMask)
          == static_cast<std::uint32_t>(dof::RuntimeMode::kCleanHigh),
      "packed payload must preserve the runtime mode");
  passed &= Expect(
      dof::UnpackPercentScale(
          bits, dof::kFocusShift, dof::kFocusMask, dof::kFocusNeutral)
          == 1.f
          && dof::UnpackPercentScale(
                 bits,
                 dof::kRadiusShift,
                 dof::kRadiusMask,
                 dof::kRadiusNeutral)
              == 1.f
          && dof::UnpackPercentScale(
                 bits, dof::kNearShift, dof::kNearMask, dof::kNearNeutral)
              == 1.f
          && dof::UnpackPercentScale(
                 bits, dof::kFarShift, dof::kFarMask, dof::kFarNeutral)
              == 1.f
          && dof::UnpackPercentScale(
                 bits, dof::kEdgeShift, dof::kEdgeMask, dof::kEdgeNeutral)
              == 1.f,
      "neutral controls must decode to exact 1.0 scales");

  const dof::RuntimeControls maximum = {
      .focus_distance_percent = 200.f,
      .blur_radius_percent = 200.f,
      .near_strength_percent = 200.f,
      .far_strength_percent = 200.f,
      .edge_bokeh_percent = 200.f,
  };
  const std::uint32_t maximum_bits = dof::PackRuntimeBits(
      dof::RuntimeMode::kCinematicHigh, maximum);
  passed &= Expect(
      dof::UnpackPercentScale(
          maximum_bits,
          dof::kFocusShift,
          dof::kFocusMask,
          dof::kFocusNeutral)
          == 2.f
          && dof::UnpackPercentScale(
                 maximum_bits,
                 dof::kEdgeShift,
                 dof::kEdgeMask,
                 dof::kEdgeNeutral)
              == 2.f,
      "maximum controls must decode to exact 2.0 scales");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestFailClosedLifecycle();
  passed &= TestModeAndBuildGates();
  passed &= TestPackedControls();
  if (!passed) return 1;
  std::cout << "PASS: Detroit DOF runtime gates\n";
  return 0;
}
