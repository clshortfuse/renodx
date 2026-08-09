/*
 * SPDX-License-Identifier: MIT
 */

#include <array>
#include <cstdint>
#include <iostream>
#include <string_view>
#include <utility>

#include "src/games/detroitbecomehuman/retinal_observability.hpp"

namespace {

using namespace std::string_view_literals;

namespace retinal = renodx::games::detroitbecomehuman::retinal;
namespace capture = renodx::games::detroitbecomehuman::retinal_capture;
namespace embedded = renodx::games::detroitbecomehuman::dlss::embedded;
namespace observability =
    renodx::games::detroitbecomehuman::retinal_observability;

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

bool TestExactRunResultText() {
  constexpr std::array expected = {
      std::pair{retinal::RunResult::kDispatched, "kDispatched"sv},
      std::pair{retinal::RunResult::kNotRetinalMode, "kNotRetinalMode"sv},
      std::pair{
          retinal::RunResult::kMissingCompositeCapture,
          "kMissingCompositeCapture"sv},
      std::pair{retinal::RunResult::kUnsupportedDevice, "kUnsupportedDevice"sv},
      std::pair{retinal::RunResult::kInvalidResource, "kInvalidResource"sv},
      std::pair{
          retinal::RunResult::kUnsupportedResource,
          "kUnsupportedResource"sv},
      std::pair{
          retinal::RunResult::kResourceCapacityExceeded,
          "kResourceCapacityExceeded"sv},
      std::pair{
          retinal::RunResult::kResourceCreationFailed,
          "kResourceCreationFailed"sv},
      std::pair{
          retinal::RunResult::kPipelineCreationFailed,
          "kPipelineCreationFailed"sv},
      std::pair{
          retinal::RunResult::kDebugOverlayActive,
          "kDebugOverlayActive"sv},
      std::pair{
          retinal::RunResult::kBypassedZeroEffect,
          "kBypassedZeroEffect"sv},
      std::pair{
          retinal::RunResult::kBarrierUnavailable,
          "kBarrierUnavailable"sv},
      std::pair{
          retinal::RunResult::kStateRestoreFailed,
          "kStateRestoreFailed"sv},
  };

  bool passed = true;
  for (const auto& [result, text] : expected) {
    passed &= Expect(
        observability::GetRunResultText(result) == text,
        "every RunResult must retain its exact enum spelling");
  }
  passed &= Expect(
      observability::GetRunResultText(
          static_cast<retinal::RunResult>(UINT32_C(0xFFFFFFFF)))
          == "UnknownRunResult",
      "unknown RunResult values must remain explicit");
  return passed;
}

bool TestExactCaptureText() {
  using Result = capture::CaptureResult;
  constexpr std::array expected_results = {
      std::pair{Result::kNotAttempted, "kNotAttempted"sv},
      std::pair{Result::kSuccess, "kSuccess"sv},
      std::pair{Result::kNullCommandList, "kNullCommandList"sv},
      std::pair{Result::kMissingDevice, "kMissingDevice"sv},
      std::pair{Result::kUnsupportedDeviceApi, "kUnsupportedDeviceApi"sv},
      std::pair{Result::kSnapshotUnavailable, "kSnapshotUnavailable"sv},
      std::pair{Result::kCommandStateInvalid, "kCommandStateInvalid"sv},
      std::pair{
          Result::kPipelineContractMismatch,
          "kPipelineContractMismatch"sv},
      std::pair{
          Result::kPushConstantContractMismatch,
          "kPushConstantContractMismatch"sv},
      std::pair{
          Result::kOutputDescriptorContractMismatch,
          "kOutputDescriptorContractMismatch"sv},
      std::pair{
          Result::kOutputMetadataIncomplete,
          "kOutputMetadataIncomplete"sv},
      std::pair{Result::kOutputResourceMissing, "kOutputResourceMissing"sv},
      std::pair{Result::kOutputFormatMismatch, "kOutputFormatMismatch"sv},
      std::pair{Result::kOutputLayoutMismatch, "kOutputLayoutMismatch"sv},
      std::pair{Result::kOutputExtentInvalid, "kOutputExtentInvalid"sv},
      std::pair{
          Result::kOutputSubresourceMismatch,
          "kOutputSubresourceMismatch"sv},
      std::pair{
          Result::kOutputImageContractMismatch,
          "kOutputImageContractMismatch"sv},
      std::pair{Result::kOutputUsageMismatch, "kOutputUsageMismatch"sv},
      std::pair{
          Result::kDepthDescriptorContractMismatch,
          "kDepthDescriptorContractMismatch"sv},
      std::pair{
          Result::kDepthMetadataIncomplete,
          "kDepthMetadataIncomplete"sv},
      std::pair{Result::kDepthResourceMissing, "kDepthResourceMissing"sv},
      std::pair{Result::kDepthExtentMismatch, "kDepthExtentMismatch"sv},
      std::pair{
          Result::kDepthSubresourceMismatch,
          "kDepthSubresourceMismatch"sv},
      std::pair{
          Result::kSnapshotReleaseFailed,
          "kSnapshotReleaseFailed"sv},
  };

  using Detail = embedded::DofCompositeCaptureDetail;
  constexpr std::array expected_details = {
      std::pair{Detail::kNotAttempted, "kNotAttempted"sv},
      std::pair{Detail::kSuccess, "kSuccess"sv},
      std::pair{Detail::kInvalidArgument, "kInvalidArgument"sv},
      std::pair{
          Detail::kDeviceStateUnavailable,
          "kDeviceStateUnavailable"sv},
      std::pair{
          Detail::kUnsupportedExecutable,
          "kUnsupportedExecutable"sv},
      std::pair{Detail::kDeviceDestroying, "kDeviceDestroying"sv},
      std::pair{
          Detail::kPushConstantsUnavailable,
          "kPushConstantsUnavailable"sv},
      std::pair{Detail::kCommandStateMissing, "kCommandStateMissing"sv},
      std::pair{
          Detail::kCommandStateIncomplete,
          "kCommandStateIncomplete"sv},
      std::pair{Detail::kDescriptorSetMissing, "kDescriptorSetMissing"sv},
      std::pair{
          Detail::kDescriptorSetLayoutMissing,
          "kDescriptorSetLayoutMissing"sv},
      std::pair{
          Detail::kDescriptorSetLayoutMismatch,
          "kDescriptorSetLayoutMismatch"sv},
      std::pair{Detail::kPipelineLayoutMissing, "kPipelineLayoutMissing"sv},
      std::pair{
          Detail::kPipelineLayoutMismatch,
          "kPipelineLayoutMismatch"sv},
      std::pair{
          Detail::kOutputBindingUnavailable,
          "kOutputBindingUnavailable"sv},
      std::pair{
          Detail::kDepthBindingUnavailable,
          "kDepthBindingUnavailable"sv},
      std::pair{
          Detail::kOutputDescriptorTypeMismatch,
          "kOutputDescriptorTypeMismatch"sv},
      std::pair{Detail::kOutputLayoutMismatch, "kOutputLayoutMismatch"sv},
      std::pair{
          Detail::kDepthDescriptorTypeMismatch,
          "kDepthDescriptorTypeMismatch"sv},
  };

  bool passed = true;
  for (const auto& [result, text] : expected_results) {
    passed &= Expect(
        observability::GetCaptureResultText(result) == text,
        "every CaptureResult must retain its exact enum spelling");
  }
  for (const auto& [detail, text] : expected_details) {
    passed &= Expect(
        observability::GetEmbeddedCaptureDetailText(detail) == text,
        "every embedded capture detail must retain its exact enum spelling");
  }
  return passed;
}

bool TestTransitionSuppression() {
  observability::RunResultState state(retinal::RunResult::kNotRetinalMode);
  bool passed = true;

  auto transition = state.Update(retinal::RunResult::kNotRetinalMode);
  passed &= Expect(
      !transition.changed,
      "repeating the initial state must not request another log message");

  transition = state.Update(retinal::RunResult::kDispatched);
  passed &= Expect(
      transition.changed
          && transition.previous == retinal::RunResult::kNotRetinalMode
          && transition.current == retinal::RunResult::kDispatched
          && state.Get() == retinal::RunResult::kDispatched,
      "a real state change must retain both exact RunResult values");

  transition = state.Update(retinal::RunResult::kDispatched);
  passed &= Expect(
      !transition.changed,
      "a stable dispatched state must be logged only once");

  transition = state.Update(retinal::RunResult::kMissingCompositeCapture);
  passed &= Expect(
      transition.changed
          && transition.previous == retinal::RunResult::kDispatched
          && transition.current
                 == retinal::RunResult::kMissingCompositeCapture,
      "each distinct runtime state transition must be observable");
  return passed;
}

bool TestCaptureTransitionSuppression() {
  observability::CaptureDiagnosticState state;
  bool passed = true;
  const observability::CaptureDiagnostic success = {
      .result = capture::CaptureResult::kSuccess,
      .embedded_detail = embedded::DofCompositeCaptureDetail::kSuccess,
  };

  auto transition = state.Update({});
  passed &= Expect(
      !transition.changed,
      "an unattempted capture must not emit a duplicate transition");
  transition = state.Update(success);
  passed &= Expect(
      transition.changed && transition.current == success
          && state.Get() == success,
      "a successful capture must retain both typed diagnostic values");
  transition = state.Update(success);
  passed &= Expect(
      !transition.changed,
      "a stable capture diagnostic must be logged only once");
  transition = state.Update({
      .result = capture::CaptureResult::kSnapshotUnavailable,
      .embedded_detail =
          embedded::DofCompositeCaptureDetail::kCommandStateMissing,
  });
  passed &= Expect(
      transition.changed
          && transition.current.result
                 == capture::CaptureResult::kSnapshotUnavailable
          && transition.current.embedded_detail
                 == embedded::DofCompositeCaptureDetail::kCommandStateMissing,
      "an embedded capture failure must preserve its exact detail");
  return passed;
}

bool TestLogClassification() {
  bool passed = true;
  passed &= Expect(
      observability::GetLogClass(retinal::RunResult::kDispatched)
              == observability::LogClass::kInfo
          && observability::GetLogClass(
                 retinal::RunResult::kDebugOverlayActive)
                 == observability::LogClass::kInfo
          && observability::GetLogClass(
                 retinal::RunResult::kBypassedZeroEffect)
                 == observability::LogClass::kInfo,
      "expected Retinal states must use informational logging");
  passed &= Expect(
      observability::GetLogClass(
          retinal::RunResult::kMissingCompositeCapture)
          == observability::LogClass::kWarning,
      "recoverable Retinal validation failures must use warning logging");
  passed &= Expect(
      observability::GetLogClass(retinal::RunResult::kStateRestoreFailed)
          == observability::LogClass::kError,
      "state restoration failure must use error logging");
  passed &= Expect(
      observability::GetLogClass(capture::CaptureResult::kSuccess)
              == observability::LogClass::kInfo
          && observability::GetLogClass(
                 capture::CaptureResult::kSnapshotUnavailable)
                 == observability::LogClass::kWarning
          && observability::GetLogClass(
                 capture::CaptureResult::kSnapshotReleaseFailed)
                 == observability::LogClass::kError,
      "capture diagnostics must retain their expected log severity");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestExactRunResultText();
  passed &= TestExactCaptureText();
  passed &= TestTransitionSuppression();
  passed &= TestCaptureTransitionSuppression();
  passed &= TestLogClassification();
  if (!passed) return 1;
  std::cout << "PASS: Detroit Retinal runtime observability contract\n";
  return 0;
}
