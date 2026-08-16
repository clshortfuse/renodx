/*
 * SPDX-License-Identifier: MIT
 */

#include <bit>
#include <cmath>
#include <iostream>
#include <string_view>

#include "src/games/detroitbecomehuman/debug/render_debug.hpp"

namespace {

namespace debug = renodx::games::detroitbecomehuman::render_debug;

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

bool TestPresetResolution() {
  bool passed = true;
  auto resolved = debug::Resolve({
      .mode = debug::OverlayMode::kSingle,
      .single_source = debug::Source::kTemporalMotionVectors,
  });
  passed &= Expect(
      resolved.slot_count == 1u
          && resolved.slots[0u] == debug::Source::kTemporalMotionVectors,
      "Single must resolve only its selected source");

  resolved = debug::Resolve({
      .mode = debug::OverlayMode::kDashboard,
      .dashboard = debug::DashboardPreset::kDof,
  });
  passed &= Expect(
      resolved.slot_count == 3u
          && resolved.slots[0u] == debug::Source::kDofCoarseCoc
          && resolved.slots[1u] == debug::Source::kDofFullResolutionCoc
          && resolved.slots[2u] == debug::Source::kDofGatherFillLayers,
      "DOF dashboard must preserve the established three-panel diagnostic");

  resolved = debug::Resolve({
      .mode = debug::OverlayMode::kDashboard,
      .dashboard = debug::DashboardPreset::kDofVanillaTransition,
  });
  passed &= Expect(
      resolved.slot_count == 3u
          && resolved.slots[0u] == debug::Source::kDofFullResolutionCoc
          && resolved.slots[1u]
                 == debug::Source::kDofVanillaTransitionControl
          && resolved.slots[2u]
                 == debug::Source::kDofVanillaTransitionContribution,
      "Vanilla-transition dashboard must expose CoC, decoded control, and final contribution");

  const std::array custom = {
      debug::Source::kSceneLuminance,
      debug::Source::kTemporalDepth,
      debug::Source::kDofGatherFillLayers,
  };
  resolved = debug::Resolve({
      .mode = debug::OverlayMode::kDashboard,
      .dashboard = debug::DashboardPreset::kCustom,
      .custom_slots = custom,
  });
  passed &= Expect(
      resolved.slots == custom,
      "Custom dashboard must preserve all three user slots");
  return passed;
}

bool TestPackedContract() {
  bool passed = true;
  debug::Config config = {
      .mode = debug::OverlayMode::kDashboard,
      .dashboard = debug::DashboardPreset::kTemporal,
      .channel = debug::Channel::kVector,
      .mapping = debug::Mapping::kSigned,
      .opacity = 0.5f,
      .temporal_source_unavailable = true,
      .show_fixation = true,
  };
  const auto resolved = debug::Resolve(config);
  const auto bits = debug::PackBits(resolved);
  passed &= Expect(
      bits != 0u && (bits & ~debug::kFinitePayloadMask) == 0u,
      "debug payload must reserve the float sign and top exponent bit");
  passed &= Expect(
      std::isfinite(debug::PackPayload(config)),
      "every packed debug payload must remain finite");
  passed &= Expect(
      ((bits >> debug::kSlot0Shift) & debug::kSourceMask)
              == static_cast<std::uint32_t>(debug::Source::kTemporalDepth)
          && ((bits >> debug::kSlot1Shift) & debug::kSourceMask)
                 == static_cast<std::uint32_t>(
                     debug::Source::kTemporalMotionVectors)
          && ((bits >> debug::kSlot2Shift) & debug::kSourceMask)
                 == static_cast<std::uint32_t>(debug::Source::kTemporalHistory),
      "packed slots must match shader source IDs");
  passed &= Expect(
      ((bits >> debug::kTemporalUnavailableShift) & 1u) != 0u
          && ((bits >> debug::kShowFixationShift) & 1u) != 0u,
      "packed state must retain temporal fallback and fixation state");
  passed &= Expect(
      std::bit_cast<std::uint32_t>(debug::PackPayload({})) == 0u,
      "Off must be a literal zero payload");
  return passed;
}

bool TestSourceContracts() {
  bool passed = true;
  passed &= Expect(
      !debug::kFreezeFrameSupported,
      "inline propagation must not claim resource-backed frame freezing");
  const auto& depth = debug::GetSourceContract(debug::Source::kTemporalDepth);
  passed &= Expect(
      depth.IsAvailable()
          && depth.binding.shader_crc == debug::kTemporalShaderCrc
          && depth.binding.descriptor_set == 0u
          && depth.binding.binding == 3u,
      "TAA depth must retain its verified set 0 binding 3 contract");
  const auto& motion = debug::GetSourceContract(
      debug::Source::kTemporalMotionVectors);
  passed &= Expect(
      motion.binding.binding == 4u
          && motion.decoder == debug::Decoder::kMotionVectors,
      "TAA motion vectors must retain binding 4 and vector decoding");
  const auto& far = debug::GetSourceContract(debug::Source::kDofFarLayer);
  passed &= Expect(
      far.binding.shader_crc == debug::kDofCompositeShaderCrc
          && far.binding.binding == 5u,
      "DOF far gather/fill layer must retain composite binding 5");
  const auto& transition_control = debug::GetSourceContract(
      debug::Source::kDofVanillaTransitionControl);
  const auto& transition_contribution = debug::GetSourceContract(
      debug::Source::kDofVanillaTransitionContribution);
  passed &= Expect(
      transition_control.IsAvailable()
          && transition_control.access == debug::Access::kDerivedInline
          && transition_control.decoder == debug::Decoder::kScalar
          && transition_control.default_channel == debug::Channel::kRed
          && transition_control.range_min == 0.f
          && transition_control.range_max == 1.f,
      "Vanilla-transition control must expose the shader-decoded 0..1 strength");
  passed &= Expect(
      transition_contribution.IsAvailable()
          && transition_contribution.producer
                 == debug::ProducerPass::kDofComposite
          && transition_contribution.access == debug::Access::kDerivedInline
          && transition_contribution.decoder == debug::Decoder::kScalar
          && transition_contribution.range_min == 0.f
          && transition_contribution.range_max == 1.f,
      "Vanilla transition must expose the final post-resolve 0..1 contribution");
  passed &= Expect(
      !debug::GetSourceContract(debug::Source::kGtao).IsAvailable()
          && !debug::GetSourceContract(
                  debug::Source::kLightingDiffuse)
                  .IsAvailable()
          && !debug::GetSourceContract(
                  debug::Source::kRetinalEccentricity)
                  .IsAvailable(),
      "unverified lighting and Retinal UAVs must remain unavailable");
  return passed;
}

bool TestRuntimeGateAndReset() {
  bool passed = true;
  debug::RuntimeController controller;
  controller.SetConfig({
      .mode = debug::OverlayMode::kDashboard,
      .dashboard = debug::DashboardPreset::kTemporal,
  });

  controller.Observe(debug::ProducerPass::kTemporal);
  auto frame = controller.FinishFrame(true);
  passed &= Expect(
      frame.status == debug::RuntimeStatus::kWaitingForPasses
          && std::bit_cast<std::uint32_t>(frame.payload) == 0u,
      "an incomplete inline chain must keep the overlay disabled");

  controller.Observe(debug::ProducerPass::kTemporal);
  controller.Observe(debug::ProducerPass::kSceneComposite);
  frame = controller.FinishFrame(true);
  passed &= Expect(
      frame.status == debug::RuntimeStatus::kActive
          && std::bit_cast<std::uint32_t>(frame.payload) != 0u,
      "verified temporal and scene passes must arm the temporal dashboard");

  controller.SetConfig({
      .mode = debug::OverlayMode::kDashboard,
      .dashboard = debug::DashboardPreset::kLighting,
  });
  controller.Observe(debug::ProducerPass::kSceneComposite);
  frame = controller.FinishFrame(true);
  passed &= Expect(
      frame.status == debug::RuntimeStatus::kActiveWithUnavailableSources,
      "unverified sources must resolve to an explicit unavailable dashboard");

  controller.ResetDevice();
  passed &= Expect(
      controller.GetStatus() == debug::RuntimeStatus::kOff
          && std::bit_cast<std::uint32_t>(controller.GetPayload()) == 0u
          && controller.GetLastObservedPassMask() == 0u,
      "device reset must clear all inline overlay state");

  controller.SetConfig({
      .mode = debug::OverlayMode::kDashboard,
      .dashboard = debug::DashboardPreset::kDof,
  });
  controller.Observe(debug::ProducerPass::kDofComposite);
  controller.Observe(debug::ProducerPass::kSceneComposite);
  frame = controller.FinishFrame(false);
  passed &= Expect(
      frame.status == debug::RuntimeStatus::kUnsupportedBuild
          && std::bit_cast<std::uint32_t>(frame.payload) == 0u,
      "an unsupported executable must keep Render Debug disabled");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestPresetResolution();
  passed &= TestPackedContract();
  passed &= TestSourceContracts();
  passed &= TestRuntimeGateAndReset();
  if (!passed) return 1;
  std::cout << "PASS: Detroit render debug runtime contract\n";
  return 0;
}
