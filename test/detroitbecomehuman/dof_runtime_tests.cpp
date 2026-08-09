/*
 * SPDX-License-Identifier: MIT
 */

#include <cmath>
#include <iostream>
#include <limits>
#include <string_view>

#include "src/games/detroitbecomehuman/dof_runtime.hpp"
#include "src/games/detroitbecomehuman/retinal_math.hpp"

namespace {

namespace dof = renodx::games::detroitbecomehuman::dof;
namespace retinal = renodx::games::detroitbecomehuman::retinal;

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

  ObserveCompleteChain(&controller);
  frame = controller.FinishFrame(
      dof::RuntimeStyle::kRetinal, false, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kRetinalBalanced
          && frame.status == dof::RuntimeStatus::kActiveRetinalBalanced,
      "a complete chain must select Retinal Balanced explicitly");

  ObserveCompleteChain(&controller);
  frame = controller.FinishFrame(
      dof::RuntimeStyle::kRetinal, true, true);
  passed &= Expect(
      frame.mode == dof::RuntimeMode::kRetinalHigh
          && frame.status == dof::RuntimeStatus::kActiveRetinalHigh,
      "a complete chain must select Retinal High explicitly");

  frame = controller.FinishFrame(
      dof::RuntimeStyle::kRetinal, true, true);
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
              .far_strength_percent = 0.f,
              .edge_bokeh_width_pixels = 16.f,
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
                 bits, dof::kFarShift, dof::kFarMask, dof::kFarNeutral)
                 == 1.f
          && dof::UnpackEdgeWidthPixels(bits) == 8u
          && ((bits >> dof::kReservedEdgeShift)
                  & dof::kReservedEdgeMask)
                 == 0u,
      "neutral controls must decode exact scales, an 8 px Edge width, and zero reserved bits");

  const dof::RuntimeControls maximum = {
      .focus_distance_percent = 200.f,
      .blur_radius_percent = 200.f,
      .far_strength_percent = 200.f,
      .edge_bokeh_width_pixels = 16.f,
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
          && dof::UnpackEdgeWidthPixels(maximum_bits) == 16u
          && ((maximum_bits >> dof::kReservedEdgeShift)
                  & dof::kReservedEdgeMask)
                 == 0u,
      "maximum controls must decode a 16 px Edge width while old Edge bits stay zero");

  const dof::RuntimeControls no_edge = {
      .focus_distance_percent = 100.f,
      .blur_radius_percent = 100.f,
      .far_strength_percent = 100.f,
      .edge_bokeh_width_pixels = 0.f,
  };
  const std::uint32_t no_edge_bits = dof::PackRuntimeBits(
      dof::RuntimeMode::kCinematicHigh, no_edge);
  passed &= Expect(
      dof::UnpackEdgeWidthPixels(no_edge_bits) == 0u,
      "Edge Bokeh zero must decode to an exact post-resolve bypass");

  for (std::uint32_t width = 0u;
       width <= dof::kEdgeWidthMaximum;
       ++width) {
    const auto exact_bits = dof::PackRuntimeBits(
        dof::RuntimeMode::kCinematicHigh,
        {
            .edge_bokeh_width_pixels = static_cast<float>(width),
        });
    passed &= Expect(
        dof::UnpackEdgeWidthPixels(exact_bits) == width,
        "every exposed Edge Bokeh pixel width must round-trip exactly");
  }
  passed &= Expect(
      dof::QuantizeEdgeWidthPixels(-10.f) == 0u
          && dof::QuantizeEdgeWidthPixels(99.f) == 16u
          && dof::QuantizeEdgeWidthPixels(1.49f) == 1u
          && dof::QuantizeEdgeWidthPixels(1.5f) == 2u
          && dof::QuantizeEdgeWidthPixels(
                 std::numeric_limits<float>::quiet_NaN())
                 == dof::kEdgeWidthDefault,
      "Edge Bokeh pixel encoding must clamp, round, and sanitize deterministically");

  const std::uint32_t retinal_bits = dof::PackRuntimeBits(
      dof::RuntimeMode::kRetinalHigh, neutral);
  passed &= Expect(
      (retinal_bits & dof::kModeMask)
          == static_cast<std::uint32_t>(dof::RuntimeMode::kRetinalHigh),
      "the existing three-bit payload must preserve Retinal High mode 6");
  return passed;
}

bool TestExplicitModePredicates() {
  bool passed = true;
  passed &= Expect(
      dof::IsKnownRuntimeMode(dof::RuntimeMode::kVanilla)
          && dof::IsKnownRuntimeMode(dof::RuntimeMode::kRetinalHigh)
          && !dof::IsKnownRuntimeMode(
              static_cast<dof::RuntimeMode>(7u)),
      "known mode validation must cover exactly modes 0 through 6");
  passed &= Expect(
      dof::IsKnownRuntimeStyle(dof::RuntimeStyle::kVanilla)
          && dof::IsKnownRuntimeStyle(dof::RuntimeStyle::kRetinal)
          && !dof::IsKnownRuntimeStyle(
              static_cast<dof::RuntimeStyle>(4u)),
      "known style validation must cover exactly Vanilla, Clean, Cinematic, and Retinal");
  passed &= Expect(
      !dof::IsEnhancedMode(dof::RuntimeMode::kVanilla)
          && dof::IsEnhancedMode(dof::RuntimeMode::kCleanBalanced)
          && dof::IsEnhancedMode(dof::RuntimeMode::kRetinalHigh),
      "only known nonzero modes are enhanced");
  passed &= Expect(
      !dof::UsesCinematicBase(dof::RuntimeMode::kCleanHigh)
          && dof::UsesCinematicBase(
              dof::RuntimeMode::kCinematicBalanced)
          && dof::UsesCinematicBase(
              dof::RuntimeMode::kRetinalBalanced),
      "Retinal must retain the Cinematic DOF base");
  passed &= Expect(
      !dof::IsHighQualityMode(dof::RuntimeMode::kCleanBalanced)
          && dof::IsHighQualityMode(dof::RuntimeMode::kCleanHigh)
          && !dof::IsHighQualityMode(
              dof::RuntimeMode::kCinematicBalanced)
          && dof::IsHighQualityMode(dof::RuntimeMode::kCinematicHigh)
          && !dof::IsHighQualityMode(
              dof::RuntimeMode::kRetinalBalanced)
          && dof::IsHighQualityMode(dof::RuntimeMode::kRetinalHigh),
      "High quality must be decoded explicitly rather than by numeric range");
  passed &= Expect(
      dof::IsBalancedQualityMode(dof::RuntimeMode::kCleanBalanced)
          && !dof::IsBalancedQualityMode(dof::RuntimeMode::kCleanHigh)
          && dof::IsBalancedQualityMode(
              dof::RuntimeMode::kCinematicBalanced)
          && dof::IsBalancedQualityMode(
              dof::RuntimeMode::kRetinalBalanced)
          && !dof::IsBalancedQualityMode(dof::RuntimeMode::kRetinalHigh),
      "Balanced quality must be decoded explicitly for each style");
  passed &= Expect(
      !dof::IsRetinalMode(dof::RuntimeMode::kCinematicHigh)
          && dof::IsRetinalMode(dof::RuntimeMode::kRetinalBalanced)
          && dof::IsRetinalMode(dof::RuntimeMode::kRetinalHigh),
      "only modes 5 and 6 may execute the Retinal post-filter");
  return passed;
}

bool TestWatsonRetinalModel() {
  bool passed = true;
  const float foveal_nyquist =
      retinal::ComputeRetinalNyquistCyclesPerDegree(0.f, 0.f);
  passed &= Expect(
      std::isfinite(foveal_nyquist)
          && std::abs(foveal_nyquist - 65.37f) < 0.1f,
      "Watson model must reproduce the approximately 65.37 cpd foveal peak");

  const float peripheral_nyquist =
      retinal::ComputeRetinalNyquistCyclesPerDegree(30.f, 0.f);
  passed &= Expect(
      std::isfinite(peripheral_nyquist)
          && peripheral_nyquist > 0.f
          && peripheral_nyquist < foveal_nyquist,
      "retinal Nyquist must decrease away from fixation");
  passed &= Expect(
      std::abs(
          retinal::ComputeRetinalNyquistCyclesPerDegree(-30.f, 0.f)
          - peripheral_nyquist)
          < 1.0e-4f,
      "binocular horizontal density must be symmetric around fixation");

  const auto center = retinal::ComputeFilterSample(
      {0.5f, 0.5f},
      {0.5f, 0.5f},
      3440u,
      1440u,
      retinal::kDefaultHorizontalScreenAngleDegrees,
      1.f);
  const auto edge = retinal::ComputeFilterSample(
      {1.f, 0.5f},
      {0.5f, 0.5f},
      3440u,
      1440u,
      retinal::kDefaultHorizontalScreenAngleDegrees,
      1.f);
  passed &= Expect(
      center.eccentricity_degrees < 1.0e-3f
          && center.horizontal_sigma_pixels == 0.f
          && center.vertical_sigma_pixels == 0.f,
      "the fixation point must remain pixel-sharp");
  passed &= Expect(
      edge.eccentricity_degrees > 20.f
          && edge.retinal_nyquist_cycles_per_degree
                 < center.retinal_nyquist_cycles_per_degree
          && edge.horizontal_sigma_pixels > 0.f
          && edge.vertical_sigma_pixels > 0.f,
      "peripheral samples must receive a finite additional Gaussian blur");

  const auto mirrored_edge = retinal::ComputeFilterSample(
      {0.f, 0.5f},
      {0.5f, 0.5f},
      3440u,
      1440u,
      70.f,
      1.f);
  passed &= Expect(
      std::abs(
          mirrored_edge.horizontal_sigma_pixels
          - edge.horizontal_sigma_pixels)
          < 1.0e-4f,
      "center fixation must produce symmetric horizontal filtering");
  return passed;
}

bool TestRetinalMathIsFiniteAndClamped() {
  bool passed = true;
  const float nan = std::numeric_limits<float>::quiet_NaN();
  const float infinity = std::numeric_limits<float>::infinity();
  passed &= Expect(
      retinal::SanitizeHorizontalScreenAngle(nan)
              == retinal::kDefaultHorizontalScreenAngleDegrees
          && retinal::SanitizeHorizontalScreenAngle(1.f)
                 == retinal::kMinimumHorizontalScreenAngleDegrees
          && retinal::SanitizeHorizontalScreenAngle(infinity)
                 == retinal::kDefaultHorizontalScreenAngleDegrees,
      "invalid viewing angles must use the finite 70 degree default and clamps");

  const auto invalid = retinal::ComputeFilterSample(
      {nan, infinity},
      {-infinity, nan},
      3440u,
      1440u,
      nan,
      infinity,
      infinity);
  passed &= Expect(
      std::isfinite(invalid.eccentricity_degrees)
          && std::isfinite(invalid.retinal_nyquist_cycles_per_degree)
          && std::isfinite(invalid.horizontal_sigma_pixels)
          && std::isfinite(invalid.vertical_sigma_pixels)
          && invalid.horizontal_sigma_pixels >= 0.f
          && invalid.horizontal_sigma_pixels
                 <= retinal::kMaximumSigmaPixels
          && invalid.vertical_sigma_pixels >= 0.f
          && invalid.vertical_sigma_pixels
                 <= retinal::kMaximumSigmaPixels,
      "invalid runtime inputs must never generate NaN, infinity, or unbounded sigma");

  passed &= Expect(
      retinal::ComputeGaussianWeight(0.f, 2.f) == 1.f
          && retinal::ComputeGaussianWeight(2.f, 2.f)
                 == retinal::ComputeGaussianWeight(-2.f, 2.f)
          && retinal::ComputeGaussianWeight(1.f, 2.f)
                 > retinal::ComputeGaussianWeight(2.f, 2.f),
      "Gaussian weights must be positive, symmetric, and decrease with distance");
  passed &= Expect(
      retinal::ComputeKernelRadius(2.f, false) == 6u
          && retinal::ComputeKernelRadius(2.f, true) == 8u
          && retinal::ComputeKernelRadius(infinity, true)
                 <= retinal::kMaximumKernelRadius,
      "Balanced and High support radii must remain explicit and bounded");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestFailClosedLifecycle();
  passed &= TestModeAndBuildGates();
  passed &= TestPackedControls();
  passed &= TestExplicitModePredicates();
  passed &= TestWatsonRetinalModel();
  passed &= TestRetinalMathIsFiniteAndClamped();
  if (!passed) return 1;
  std::cout << "PASS: Detroit DOF runtime gates\n";
  return 0;
}
