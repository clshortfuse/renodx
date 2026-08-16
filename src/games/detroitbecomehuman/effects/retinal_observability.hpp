/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atomic>
#include <string_view>

#include "retinal_capture.hpp"

namespace renodx::games::detroitbecomehuman::retinal_observability {

enum class LogClass : std::uint32_t {
  kInfo = 0u,
  kWarning,
  kError,
};

[[nodiscard]] constexpr std::string_view GetRunResultText(
    retinal::RunResult result) noexcept {
  switch (result) {
    case retinal::RunResult::kDispatched:
      return "kDispatched";
    case retinal::RunResult::kNotRetinalMode:
      return "kNotRetinalMode";
    case retinal::RunResult::kMissingCompositeCapture:
      return "kMissingCompositeCapture";
    case retinal::RunResult::kUnsupportedDevice:
      return "kUnsupportedDevice";
    case retinal::RunResult::kInvalidResource:
      return "kInvalidResource";
    case retinal::RunResult::kUnsupportedResource:
      return "kUnsupportedResource";
    case retinal::RunResult::kResourceCapacityExceeded:
      return "kResourceCapacityExceeded";
    case retinal::RunResult::kResourceCreationFailed:
      return "kResourceCreationFailed";
    case retinal::RunResult::kPipelineCreationFailed:
      return "kPipelineCreationFailed";
    case retinal::RunResult::kDebugOverlayActive:
      return "kDebugOverlayActive";
    case retinal::RunResult::kBypassedZeroEffect:
      return "kBypassedZeroEffect";
    case retinal::RunResult::kBarrierUnavailable:
      return "kBarrierUnavailable";
    case retinal::RunResult::kStateRestoreFailed:
      return "kStateRestoreFailed";
  }
  return "UnknownRunResult";
}

[[nodiscard]] constexpr LogClass GetLogClass(
    retinal::RunResult result) noexcept {
  switch (result) {
    case retinal::RunResult::kDispatched:
    case retinal::RunResult::kNotRetinalMode:
    case retinal::RunResult::kDebugOverlayActive:
    case retinal::RunResult::kBypassedZeroEffect:
      return LogClass::kInfo;
    case retinal::RunResult::kStateRestoreFailed:
      return LogClass::kError;
    case retinal::RunResult::kMissingCompositeCapture:
    case retinal::RunResult::kUnsupportedDevice:
    case retinal::RunResult::kInvalidResource:
    case retinal::RunResult::kUnsupportedResource:
    case retinal::RunResult::kResourceCapacityExceeded:
    case retinal::RunResult::kResourceCreationFailed:
    case retinal::RunResult::kPipelineCreationFailed:
    case retinal::RunResult::kBarrierUnavailable:
      return LogClass::kWarning;
  }
  return LogClass::kWarning;
}

[[nodiscard]] constexpr std::string_view GetCaptureResultText(
    retinal_capture::CaptureResult result) noexcept {
  using Result = retinal_capture::CaptureResult;
  switch (result) {
    case Result::kNotAttempted:
      return "kNotAttempted";
    case Result::kSuccess:
      return "kSuccess";
    case Result::kNullCommandList:
      return "kNullCommandList";
    case Result::kMissingDevice:
      return "kMissingDevice";
    case Result::kUnsupportedDeviceApi:
      return "kUnsupportedDeviceApi";
    case Result::kSnapshotUnavailable:
      return "kSnapshotUnavailable";
    case Result::kCommandStateInvalid:
      return "kCommandStateInvalid";
    case Result::kPipelineContractMismatch:
      return "kPipelineContractMismatch";
    case Result::kPushConstantContractMismatch:
      return "kPushConstantContractMismatch";
    case Result::kOutputDescriptorContractMismatch:
      return "kOutputDescriptorContractMismatch";
    case Result::kOutputMetadataIncomplete:
      return "kOutputMetadataIncomplete";
    case Result::kOutputResourceMissing:
      return "kOutputResourceMissing";
    case Result::kOutputFormatMismatch:
      return "kOutputFormatMismatch";
    case Result::kOutputLayoutMismatch:
      return "kOutputLayoutMismatch";
    case Result::kOutputExtentInvalid:
      return "kOutputExtentInvalid";
    case Result::kOutputSubresourceMismatch:
      return "kOutputSubresourceMismatch";
    case Result::kOutputImageContractMismatch:
      return "kOutputImageContractMismatch";
    case Result::kOutputUsageMismatch:
      return "kOutputUsageMismatch";
    case Result::kDepthDescriptorContractMismatch:
      return "kDepthDescriptorContractMismatch";
    case Result::kDepthMetadataIncomplete:
      return "kDepthMetadataIncomplete";
    case Result::kDepthResourceMissing:
      return "kDepthResourceMissing";
    case Result::kDepthExtentMismatch:
      return "kDepthExtentMismatch";
    case Result::kDepthSubresourceMismatch:
      return "kDepthSubresourceMismatch";
    case Result::kSnapshotReleaseFailed:
      return "kSnapshotReleaseFailed";
  }
  return "UnknownCaptureResult";
}

[[nodiscard]] constexpr std::string_view GetEmbeddedCaptureDetailText(
    dlss::embedded::DofCompositeCaptureDetail detail) noexcept {
  using Detail = dlss::embedded::DofCompositeCaptureDetail;
  switch (detail) {
    case Detail::kNotAttempted:
      return "kNotAttempted";
    case Detail::kSuccess:
      return "kSuccess";
    case Detail::kInvalidArgument:
      return "kInvalidArgument";
    case Detail::kDeviceStateUnavailable:
      return "kDeviceStateUnavailable";
    case Detail::kUnsupportedExecutable:
      return "kUnsupportedExecutable";
    case Detail::kDeviceDestroying:
      return "kDeviceDestroying";
    case Detail::kPushConstantsUnavailable:
      return "kPushConstantsUnavailable";
    case Detail::kCommandStateMissing:
      return "kCommandStateMissing";
    case Detail::kCommandStateIncomplete:
      return "kCommandStateIncomplete";
    case Detail::kDescriptorSetMissing:
      return "kDescriptorSetMissing";
    case Detail::kDescriptorSetLayoutMissing:
      return "kDescriptorSetLayoutMissing";
    case Detail::kDescriptorSetLayoutMismatch:
      return "kDescriptorSetLayoutMismatch";
    case Detail::kPipelineLayoutMissing:
      return "kPipelineLayoutMissing";
    case Detail::kPipelineLayoutMismatch:
      return "kPipelineLayoutMismatch";
    case Detail::kOutputBindingUnavailable:
      return "kOutputBindingUnavailable";
    case Detail::kDepthBindingUnavailable:
      return "kDepthBindingUnavailable";
    case Detail::kOutputDescriptorTypeMismatch:
      return "kOutputDescriptorTypeMismatch";
    case Detail::kOutputLayoutMismatch:
      return "kOutputLayoutMismatch";
    case Detail::kDepthDescriptorTypeMismatch:
      return "kDepthDescriptorTypeMismatch";
  }
  return "UnknownDofCompositeCaptureDetail";
}

[[nodiscard]] constexpr LogClass GetLogClass(
    retinal_capture::CaptureResult result) noexcept {
  if (result == retinal_capture::CaptureResult::kNotAttempted
      || result == retinal_capture::CaptureResult::kSuccess) {
    return LogClass::kInfo;
  }
  return result == retinal_capture::CaptureResult::kSnapshotReleaseFailed
             ? LogClass::kError
             : LogClass::kWarning;
}

struct RunResultTransition {
  retinal::RunResult previous = retinal::RunResult::kNotRetinalMode;
  retinal::RunResult current = retinal::RunResult::kNotRetinalMode;
  bool changed = false;
};

class RunResultState {
 public:
  explicit RunResultState(retinal::RunResult initial) noexcept
      : value_(initial) {}

  [[nodiscard]] RunResultTransition Update(
      retinal::RunResult current) noexcept {
    const auto previous = value_.exchange(current, std::memory_order_acq_rel);
    return {
        .previous = previous,
        .current = current,
        .changed = previous != current,
    };
  }

  [[nodiscard]] retinal::RunResult Get() const noexcept {
    return value_.load(std::memory_order_acquire);
  }

 private:
  std::atomic<retinal::RunResult> value_;
};

struct CaptureDiagnostic {
  retinal_capture::CaptureResult result =
      retinal_capture::CaptureResult::kNotAttempted;
  dlss::embedded::DofCompositeCaptureDetail embedded_detail =
      dlss::embedded::DofCompositeCaptureDetail::kNotAttempted;

  [[nodiscard]] constexpr bool operator==(
      const CaptureDiagnostic&) const noexcept = default;
};

struct CaptureDiagnosticTransition {
  CaptureDiagnostic previous = {};
  CaptureDiagnostic current = {};
  bool changed = false;
};

class CaptureDiagnosticState {
 public:
  explicit CaptureDiagnosticState(CaptureDiagnostic initial = {}) noexcept
      : bits_(Pack(initial)) {}

  [[nodiscard]] CaptureDiagnosticTransition Update(
      CaptureDiagnostic current) noexcept {
    const auto previous_bits = bits_.exchange(
        Pack(current), std::memory_order_acq_rel);
    const auto previous = Unpack(previous_bits);
    return {
        .previous = previous,
        .current = current,
        .changed = previous != current,
    };
  }

  [[nodiscard]] CaptureDiagnostic Get() const noexcept {
    return Unpack(bits_.load(std::memory_order_acquire));
  }

 private:
  [[nodiscard]] static constexpr std::uint64_t Pack(
      CaptureDiagnostic value) noexcept {
    return static_cast<std::uint64_t>(value.result)
           | (static_cast<std::uint64_t>(value.embedded_detail) << 32u);
  }

  [[nodiscard]] static constexpr CaptureDiagnostic Unpack(
      std::uint64_t bits) noexcept {
    return {
        .result = static_cast<retinal_capture::CaptureResult>(
            static_cast<std::uint32_t>(bits)),
        .embedded_detail =
            static_cast<dlss::embedded::DofCompositeCaptureDetail>(
                static_cast<std::uint32_t>(bits >> 32u)),
    };
  }

  std::atomic<std::uint64_t> bits_;
};

}  // namespace renodx::games::detroitbecomehuman::retinal_observability
