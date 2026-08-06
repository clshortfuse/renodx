/*
 * SPDX-License-Identifier: MIT
 */

#include <array>
#include <bit>
#include <cstdint>
#include <iostream>
#include <limits>
#include <string_view>

#include "src/games/detroitbecomehuman/resolution_scaling.hpp"

namespace {

namespace resolution_scaling =
    renodx::games::detroitbecomehuman::resolution_scaling;
namespace supported_build =
    renodx::games::detroitbecomehuman::supported_build;

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

bool TestExactBuildGate() {
  resolution_scaling::ExecutableIdentity identity = {
      .file_size = supported_build::kExecutableSize,
      .sha256 = supported_build::kExecutableSha256,
  };
  bool passed = true;
  passed &= Expect(
      resolution_scaling::IsExactSupportedBuild(identity),
      "exact Build 12158144 identity must pass");
  --identity.file_size;
  passed &= Expect(
      !resolution_scaling::IsExactSupportedBuild(identity),
      "wrong executable size must fail closed");
  identity.file_size = supported_build::kExecutableSize;
  identity.sha256[17u] ^= 0x80u;
  passed &= Expect(
      !resolution_scaling::IsExactSupportedBuild(identity),
      "one changed hash bit must fail closed");
  return passed;
}

bool TestScalePolicy() {
  using resolution_scaling::ScaleRequestDecision;
  bool passed = true;
  for (const float accepted : {0.25f, 0.5f, 2.f / 3.f, 1.f, 2.f}) {
    passed &= Expect(
        resolution_scaling::IsSaneScale(accepted),
        "finite scale inside inclusive policy range must pass");
  }
  for (const float rejected : {
           0.f,
           0.249f,
           2.001f,
           std::numeric_limits<float>::infinity(),
           -std::numeric_limits<float>::infinity(),
           std::numeric_limits<float>::quiet_NaN()}) {
    passed &= Expect(
        !resolution_scaling::IsSaneScale(rejected),
        "non-finite or out-of-range scale must fail");
  }
  passed &= Expect(
      resolution_scaling::DecideScaleRequest(2.f / 3.f, 1.f)
          == ScaleRequestDecision::kApply,
      "DLSS Quality scale must request application from native");
  passed &= Expect(
      resolution_scaling::DecideScaleRequest(0.50005f, 0.5f)
          == ScaleRequestDecision::kApply,
      "distinct float bits must not hide an off-by-one render extent");
  passed &= Expect(
      resolution_scaling::DecideScaleRequest(
          std::numeric_limits<float>::quiet_NaN(), 1.f)
          == ScaleRequestDecision::kReject,
      "NaN request must fail closed");
  return passed;
}

bool TestHookLifecyclePolicy() {
  using resolution_scaling::HookLifecyclePhase;
  using resolution_scaling::HookOriginalRoute;
  using resolution_scaling::ProcessThreadRole;
  bool passed = true;
  passed &= Expect(
      resolution_scaling::ClassifyProcessThread(41u, 7u, 41u, 7u)
          == ProcessThreadRole::kCurrent,
      "the transaction owner thread must be classified as current");
  passed &= Expect(
      resolution_scaling::ClassifyProcessThread(41u, 7u, 41u, 9u)
          == ProcessThreadRole::kOther,
      "another thread in the process must be enlisted");
  passed &= Expect(
      resolution_scaling::ClassifyProcessThread(41u, 7u, 42u, 9u)
          == ProcessThreadRole::kIgnore,
      "threads owned by another process must be ignored");
  passed &= Expect(
      resolution_scaling::SelectHookOriginalRoute(
          HookLifecyclePhase::kClosingAttached)
          == HookOriginalRoute::kTrampoline,
      "closing calls must keep using the trampoline until detach commits");
  passed &= Expect(
      resolution_scaling::SelectHookOriginalRoute(
          HookLifecyclePhase::kDetachedDraining)
          == HookOriginalRoute::kOriginalEntry,
      "calls already redirected before detach must use the restored entry");
  passed &= Expect(
      resolution_scaling::ShouldPublishHookPostUpdate(
          HookLifecyclePhase::kRunning)
          && !resolution_scaling::ShouldPublishHookPostUpdate(
              HookLifecyclePhase::kClosingAttached)
          && !resolution_scaling::ShouldPublishHookPostUpdate(
              HookLifecyclePhase::kDetachedDraining),
      "only a running hook may publish overridden dimensions");
  return passed;
}

bool TestAddressPolicy() {
  constexpr std::uintptr_t kImageBase = UINT64_C(0x0000000140000000);
  bool passed = true;
  passed &= Expect(
      resolution_scaling::ResolveImageAddress(
          kImageBase,
          resolution_scaling::kSupportedImageSize,
          resolution_scaling::kRuntimeUpdateFunctionRva,
          resolution_scaling::kRuntimeUpdatePrologue.size())
          == kImageBase + resolution_scaling::kRuntimeUpdateFunctionRva,
      "runtime update function must resolve inside the supported image");
  passed &= Expect(
      resolution_scaling::ResolveImageAddress(
          kImageBase,
          resolution_scaling::kSupportedImageSize,
          resolution_scaling::kRendererGlobalsSlotRva,
          sizeof(std::uintptr_t))
          == kImageBase + resolution_scaling::kRendererGlobalsSlotRva,
      "renderer global slot must resolve inside the supported image");
  passed &= Expect(
      !resolution_scaling::ResolveImageAddress(
           kImageBase,
           resolution_scaling::kSupportedImageSize,
           resolution_scaling::kSupportedImageSize - 1u,
           sizeof(std::uintptr_t))
           .has_value(),
      "range crossing image end must fail");
  passed &= Expect(
      !resolution_scaling::ResolveImageAddress(
           std::numeric_limits<std::uintptr_t>::max() - 2u,
           resolution_scaling::kSupportedImageSize,
           4u,
           1u)
           .has_value(),
      "module-base addition overflow must fail");
  return passed;
}

bool TestExactTruncatedExtentScale() {
  using resolution_scaling::PixelExtent;
  bool passed = true;
  for (const PixelExtent render : {
           PixelExtent{2293u, 960u},
           PixelExtent{1995u, 835u},
           PixelExtent{1720u, 720u},
           PixelExtent{3440u, 1440u}}) {
    const auto scale =
        resolution_scaling::SelectScaleForExactTruncatedExtent(
            {3440u, 1440u}, render);
    passed &= Expect(
        scale.has_value(),
        "compatible NGX extents must have an exact shared float scale");
    passed &= Expect(
        scale.has_value()
            && resolution_scaling::ScaleProducesExactTruncatedExtent(
                {3440u, 1440u}, render, scale.value()),
        "selected float must reproduce both NGX dimensions after truncation");
  }
  passed &= Expect(
      !resolution_scaling::SelectScaleForExactTruncatedExtent(
           {100u, 100u}, {50u, 51u})
           .has_value(),
      "non-overlapping width and height intervals must be rejected");
  return passed;
}

bool TestNonPersistentRuntimeDimensions() {
  const auto performance =
      resolution_scaling::CalculateRuntimeDimensionUpdate(
          {3440u, 1440u}, {3440u, 1440u}, 0.5f);
  const auto native = resolution_scaling::CalculateRuntimeDimensionUpdate(
      {3440u, 1440u}, {1720u, 720u}, 1.f);
  bool passed = true;
  passed &= Expect(
      performance.has_value()
          && performance->target
                 == resolution_scaling::PixelExtent{1720u, 720u}
          && performance->changed,
      "Performance must change only derived dimensions to 1720x720");
  passed &= Expect(
      native.has_value()
          && native->target
                 == resolution_scaling::PixelExtent{3440u, 1440u}
          && native->changed,
      "Native restore must rebuild the unscaled derived dimensions");
  passed &= Expect(
      !resolution_scaling::CalculateRuntimeDimensionUpdate(
           {0u, 1440u}, {0u, 720u}, 0.5f)
           .has_value(),
      "zero source extent must fail closed");
  passed &= Expect(
      resolution_scaling::kSerializedScaleOffset == 0x1608u,
      "serialized scale address is documented but must not be a write target");
  return passed;
}

bool TestExactCodeContract() {
  resolution_scaling::KnownCodeSlices code = {
      .runtime_update_prologue = resolution_scaling::kRuntimeUpdatePrologue,
      .runtime_scale_load = resolution_scaling::kRuntimeScaleLoad,
      .renderer_store_sequence = resolution_scaling::kRendererStoreSequence,
      .runtime_update_call_site = resolution_scaling::kRuntimeUpdateCallSite,
  };
  const auto exact = resolution_scaling::ValidateKnownCode(code);
  bool passed = true;
  passed &= Expect(
      exact.Succeeded(),
      "runtime update, scale consumer and both global targets must validate");
  passed &= Expect(
      exact.renderer_global_slot_target_matches
          && exact.graphic_options_slot_target_matches
          && exact.runtime_update_call_target_matches,
      "RIP-relative slots and call must resolve to exact-build RVAs");

  auto changed_load = resolution_scaling::kRuntimeScaleLoad;
  changed_load[3u] ^= 0x01u;
  code.runtime_scale_load = changed_load;
  passed &= Expect(
      !resolution_scaling::ValidateKnownCode(code).Succeeded(),
      "changed serialized-scale load must fail closed");

  code.runtime_scale_load = resolution_scaling::kRuntimeScaleLoad;
  auto changed_call = resolution_scaling::kRuntimeUpdateCallSite;
  changed_call[8u] ^= 0x01u;
  code.runtime_update_call_site = changed_call;
  const auto changed_target = resolution_scaling::ValidateKnownCode(code);
  passed &= Expect(
      !changed_target.Succeeded()
          && !changed_target.runtime_update_call_target_matches,
      "changed update call target must fail semantic validation");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestExactBuildGate();
  passed &= TestScalePolicy();
  passed &= TestHookLifecyclePolicy();
  passed &= TestAddressPolicy();
  passed &= TestExactTruncatedExtentScale();
  passed &= TestNonPersistentRuntimeDimensions();
  passed &= TestExactCodeContract();
  return passed ? 0 : 1;
}
