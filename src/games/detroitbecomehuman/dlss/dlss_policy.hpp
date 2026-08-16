/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cmath>
#include <cstdint>
#include <string_view>

#include "dlss_bridge_abi.h"
#include "../supported_build.hpp"

namespace renodx::games::detroitbecomehuman::dlss_policy {

enum class FallbackReason : std::uint32_t {
  kNone = 0u,
  kNativeMode,
  kUnknownMode,
  kUnsupportedExecutable,
  kAbiMismatch,
  kBridgeUnavailable,
  kNgxUnavailable,
  kTemporalInterfaceUnverified,
  kModeUnsupported,
  kFrameAbiMismatch,
  kVerificationIncomplete,
  kShaderMismatch,
  kTemporalInputsNotReady,
  kInvalidCommandBuffer,
  kInvalidDescriptorSnapshot,
  kInvalidConstantsSnapshot,
  kMissingCurrentColor,
  kMissingDepth,
  kMissingMotionVectors,
  kMissingExposure,
  kMissingOutput,
  kAliasedColorOutput,
  kInvalidExtent,
  kExtentMismatch,
  kInvalidTemporalConstants,
  kInvalidModeSettings,
  kEvaluateFallback,
  kEvaluateError,
  kInvalidEvaluateResult,
};

[[nodiscard]] constexpr std::string_view FallbackReasonName(
    FallbackReason reason) noexcept {
  switch (reason) {
    case FallbackReason::kNone: return "none";
    case FallbackReason::kNativeMode: return "native_mode";
    case FallbackReason::kUnknownMode: return "unknown_mode";
    case FallbackReason::kUnsupportedExecutable: return "unsupported_executable";
    case FallbackReason::kAbiMismatch: return "abi_mismatch";
    case FallbackReason::kBridgeUnavailable: return "bridge_unavailable";
    case FallbackReason::kNgxUnavailable: return "ngx_unavailable";
    case FallbackReason::kTemporalInterfaceUnverified:
      return "temporal_interface_unverified";
    case FallbackReason::kModeUnsupported: return "mode_unsupported";
    case FallbackReason::kFrameAbiMismatch: return "frame_abi_mismatch";
    case FallbackReason::kVerificationIncomplete:
      return "verification_incomplete";
    case FallbackReason::kShaderMismatch: return "shader_mismatch";
    case FallbackReason::kTemporalInputsNotReady:
      return "temporal_inputs_not_ready";
    case FallbackReason::kInvalidCommandBuffer: return "invalid_command_buffer";
    case FallbackReason::kInvalidDescriptorSnapshot:
      return "invalid_descriptor_snapshot";
    case FallbackReason::kInvalidConstantsSnapshot:
      return "invalid_constants_snapshot";
    case FallbackReason::kMissingCurrentColor: return "missing_current_color";
    case FallbackReason::kMissingDepth: return "missing_depth";
    case FallbackReason::kMissingMotionVectors: return "missing_motion_vectors";
    case FallbackReason::kMissingExposure: return "missing_exposure";
    case FallbackReason::kMissingOutput: return "missing_output";
    case FallbackReason::kAliasedColorOutput: return "aliased_color_output";
    case FallbackReason::kInvalidExtent: return "invalid_extent";
    case FallbackReason::kExtentMismatch: return "extent_mismatch";
    case FallbackReason::kInvalidTemporalConstants:
      return "invalid_temporal_constants";
    case FallbackReason::kInvalidModeSettings: return "invalid_mode_settings";
    case FallbackReason::kEvaluateFallback: return "evaluate_fallback";
    case FallbackReason::kEvaluateError: return "evaluate_error";
    case FallbackReason::kInvalidEvaluateResult:
      return "invalid_evaluate_result";
  }
  return "invalid";
}

struct RuntimeSupport {
  bool executable_supported = false;
  bool bridge_available = false;
  bool ngx_initialized = false;
  bool temporal_interface_verified = false;
  bool dlaa_available = false;
  bool auto_exposure_available = false;
  std::uint32_t bridge_abi_version = 0u;
};

struct ModeAvailability {
  bool available = false;
  FallbackReason reason = FallbackReason::kUnknownMode;
};

[[nodiscard]] constexpr DetroitDlssMode NormalizeDlssMode(
    DetroitDlssMode mode) noexcept {
  return mode == DETROIT_DLSS_MODE_DLAA ? DETROIT_DLSS_MODE_DLAA
                                        : DETROIT_DLSS_MODE_NATIVE;
}

// ReShade persists integer settings as floats. Accept only the exact DLAA
// wire value so legacy SR values, fractions, NaN and infinities fail closed.
[[nodiscard]] constexpr DetroitDlssMode ParsePersistedDlssMode(
    float value) noexcept {
  return value == static_cast<float>(DETROIT_DLSS_MODE_DLAA)
             ? DETROIT_DLSS_MODE_DLAA
             : DETROIT_DLSS_MODE_NATIVE;
}

[[nodiscard]] constexpr bool IsDlssMode(DetroitDlssMode mode) noexcept {
  return mode == DETROIT_DLSS_MODE_DLAA;
}

[[nodiscard]] constexpr ModeAvailability CheckModeAvailability(
    DetroitDlssMode mode,
    const RuntimeSupport& support) noexcept {
  if (mode == DETROIT_DLSS_MODE_NATIVE) {
    return {.available = true, .reason = FallbackReason::kNativeMode};
  }
  if (!IsDlssMode(mode)) {
    return {.available = false, .reason = FallbackReason::kUnknownMode};
  }
  if (!support.executable_supported) {
    return {.available = false, .reason = FallbackReason::kUnsupportedExecutable};
  }
  if (support.bridge_abi_version != DETROIT_DLSS_ABI_VERSION) {
    return {.available = false, .reason = FallbackReason::kAbiMismatch};
  }
  if (!support.bridge_available) {
    return {.available = false, .reason = FallbackReason::kBridgeUnavailable};
  }
  if (!support.ngx_initialized) {
    return {.available = false, .reason = FallbackReason::kNgxUnavailable};
  }
  if (!support.temporal_interface_verified) {
    return {.available = false, .reason = FallbackReason::kTemporalInterfaceUnverified};
  }
  if (!support.dlaa_available) {
    return {.available = false, .reason = FallbackReason::kModeUnsupported};
  }
  return {.available = true, .reason = FallbackReason::kNone};
}

[[nodiscard]] constexpr bool HasFrameFlag(
    const DetroitDlssTemporalFrameInputs& inputs,
    DetroitDlssFrameFlags flag) noexcept {
  return (inputs.flags & flag) == flag;
}

[[nodiscard]] constexpr bool IsUsableResource(const DetroitDlssResource& resource) noexcept {
  return resource.image != 0u
         && resource.image_view != 0u
         && resource.format != 0u
         && resource.layout != 0u
         && resource.width != 0u
         && resource.height != 0u;
}

[[nodiscard]] constexpr bool ResourceMatchesExtent(
    const DetroitDlssResource& resource,
    std::uint32_t width,
    std::uint32_t height) noexcept {
  return resource.width == width && resource.height == height;
}

[[nodiscard]] constexpr bool HasFixedNativeExtent(
    const DetroitDlssModeSettings& settings) noexcept {
  return settings.output_width != 0u && settings.output_height != 0u
         && settings.render_width == settings.output_width
         && settings.render_height == settings.output_height
         && settings.min_render_width == settings.output_width
         && settings.min_render_height == settings.output_height
         && settings.max_render_width == settings.output_width
         && settings.max_render_height == settings.output_height;
}

struct FrameEligibility {
  bool evaluate_dlss = false;
  bool preserve_native_taa = true;
  bool use_auto_exposure = false;
  FallbackReason reason = FallbackReason::kNativeMode;
};

[[nodiscard]] inline FrameEligibility CheckFrameEligibility(
    DetroitDlssMode mode,
    const RuntimeSupport& support,
    const DetroitDlssModeSettings& settings,
    const DetroitDlssTemporalFrameInputs& inputs) noexcept {
  const ModeAvailability availability = CheckModeAvailability(mode, support);
  if (!availability.available || mode == DETROIT_DLSS_MODE_NATIVE) {
    return {.reason = availability.reason};
  }

  if (inputs.struct_size < sizeof(DetroitDlssTemporalFrameInputs)
      || inputs.abi_version != DETROIT_DLSS_ABI_VERSION) {
    return {.reason = FallbackReason::kFrameAbiMismatch};
  }
  if ((inputs.verification_flags & DETROIT_DLSS_VERIFY_MANDATORY_MASK)
      != DETROIT_DLSS_VERIFY_MANDATORY_MASK) {
    return {.reason = FallbackReason::kVerificationIncomplete};
  }
  if (inputs.shader_crc != supported_build::kTemporalAaShaderCrc) {
    return {.reason = FallbackReason::kShaderMismatch};
  }
  if (!HasFrameFlag(
          inputs, DETROIT_DLSS_FRAME_TEMPORAL_INPUTS_READY)) {
    return {.reason = FallbackReason::kTemporalInputsNotReady};
  }
  if (inputs.command_buffer == 0u) {
    return {.reason = FallbackReason::kInvalidCommandBuffer};
  }
  if (inputs.descriptor_set_index != DETROIT_DLSS_TAA_DESCRIPTOR_SET
      || inputs.descriptor_set == 0u
      || inputs.pipeline_layout == 0u
      || inputs.compute_pipeline == 0u) {
    return {.reason = FallbackReason::kInvalidDescriptorSnapshot};
  }
  if (inputs.constants_buffer == 0u || inputs.constants_size == 0u) {
    return {.reason = FallbackReason::kInvalidConstantsSnapshot};
  }
  if (settings.struct_size < sizeof(DetroitDlssModeSettings)
      || settings.abi_version != DETROIT_DLSS_ABI_VERSION
      || settings.mode != mode
      || (settings.create_flags & ~DETROIT_DLSS_CREATE_KNOWN_MASK) != 0u) {
    return {.reason = FallbackReason::kInvalidModeSettings};
  }
  if (!IsUsableResource(inputs.current_color)) {
    return {.reason = FallbackReason::kMissingCurrentColor};
  }
  if (!IsUsableResource(inputs.depth)) {
    return {.reason = FallbackReason::kMissingDepth};
  }
  if (!IsUsableResource(inputs.motion_vectors)) {
    return {.reason = FallbackReason::kMissingMotionVectors};
  }
  if (!IsUsableResource(inputs.output)) {
    return {.reason = FallbackReason::kMissingOutput};
  }
  if (inputs.current_color.image == inputs.output.image) {
    return {.reason = FallbackReason::kAliasedColorOutput};
  }

  const bool use_auto_exposure =
      (settings.create_flags & DETROIT_DLSS_CREATE_AUTO_EXPOSURE) != 0u;
  if (use_auto_exposure) {
    if (!HasFrameFlag(inputs, DETROIT_DLSS_FRAME_ALLOW_AUTO_EXPOSURE)
        || !support.auto_exposure_available) {
      return {.reason = FallbackReason::kMissingExposure};
    }
  } else if (!IsUsableResource(inputs.exposure)) {
    return {.reason = FallbackReason::kMissingExposure};
  }

  if (inputs.render_width == 0u
      || inputs.render_height == 0u
      || inputs.output_width == 0u
      || inputs.output_height == 0u) {
    return {.reason = FallbackReason::kInvalidExtent};
  }
  if (!ResourceMatchesExtent(inputs.current_color, inputs.render_width, inputs.render_height)
      || !ResourceMatchesExtent(inputs.depth, inputs.render_width, inputs.render_height)
      || !ResourceMatchesExtent(inputs.motion_vectors, inputs.render_width, inputs.render_height)
      || !ResourceMatchesExtent(inputs.output, inputs.output_width, inputs.output_height)) {
    return {.reason = FallbackReason::kExtentMismatch};
  }

  if (!std::isfinite(inputs.jitter_x)
      || !std::isfinite(inputs.jitter_y)
      || !std::isfinite(inputs.motion_vector_scale_x)
      || !std::isfinite(inputs.motion_vector_scale_y)
      || !std::isfinite(inputs.pre_exposure)
      || !std::isfinite(inputs.dlaa_sharpening)
      || !std::isfinite(inputs.dlaa_sharpening_normalization)
      || inputs.motion_vector_scale_x == 0.f
      || inputs.motion_vector_scale_y == 0.f
      || inputs.pre_exposure <= 0.f
      || inputs.dlaa_sharpening < 0.f
      || inputs.dlaa_sharpening > 1.f
      || inputs.dlaa_sharpening_normalization < 1.f) {
    return {.reason = FallbackReason::kInvalidTemporalConstants};
  }

  if (settings.output_width != inputs.output_width
      || settings.output_height != inputs.output_height
      || settings.render_width != inputs.render_width
      || settings.render_height != inputs.render_height) {
    return {.reason = FallbackReason::kInvalidModeSettings};
  }

  if (settings.min_render_width != 0u
      && (inputs.render_width < settings.min_render_width
          || inputs.render_height < settings.min_render_height)) {
    return {.reason = FallbackReason::kInvalidModeSettings};
  }
  if (settings.max_render_width != 0u
      && (inputs.render_width > settings.max_render_width
          || inputs.render_height > settings.max_render_height)) {
    return {.reason = FallbackReason::kInvalidModeSettings};
  }

  if (inputs.render_width != inputs.output_width
      || inputs.render_height != inputs.output_height
      || !HasFixedNativeExtent(settings)) {
    return {.reason = FallbackReason::kInvalidModeSettings};
  }

  return {
      .evaluate_dlss = true,
      .preserve_native_taa = true,
      .use_auto_exposure = use_auto_exposure,
      .reason = FallbackReason::kNone,
  };
}

struct FrameOutcome {
  bool use_dlss_output = false;
  bool preserve_native_taa = true;
  bool suppress_final_cas = false;
  FallbackReason reason = FallbackReason::kInvalidEvaluateResult;
};

[[nodiscard]] constexpr FrameOutcome FinalizeFrame(
    const FrameEligibility& eligibility,
    const DetroitDlssEvaluateResult& result,
    std::uint64_t expected_frame_id) noexcept {
  if (!eligibility.evaluate_dlss) {
    return {.reason = eligibility.reason};
  }
  if (result.struct_size < sizeof(DetroitDlssEvaluateResult)
      || result.abi_version != DETROIT_DLSS_ABI_VERSION
      || result.frame_id != expected_frame_id) {
    return {.reason = FallbackReason::kInvalidEvaluateResult};
  }
  if (result.status == DETROIT_DLSS_RESULT_FALLBACK) {
    return {.reason = FallbackReason::kEvaluateFallback};
  }
  if (result.status == DETROIT_DLSS_RESULT_ERROR) {
    return {.reason = FallbackReason::kEvaluateError};
  }
  if (result.status != DETROIT_DLSS_RESULT_SUCCESS
      || (result.flags & DETROIT_DLSS_EVALUATE_OUTPUT_VALID) == 0u) {
    return {.reason = FallbackReason::kInvalidEvaluateResult};
  }
  return {
      .use_dlss_output = true,
      .preserve_native_taa = true,
      .suppress_final_cas = true,
      .reason = FallbackReason::kNone,
  };
}

struct FeatureTransition {
  bool feature_exists = false;
  bool mode_changed = false;
  bool render_extent_changed = false;
  bool output_extent_changed = false;
  bool camera_cut = false;
  bool scene_loaded = false;
  bool manual_reset = false;
};

struct FeatureLifecycleDecision {
  bool create_feature = false;
  bool recreate_feature = false;
  bool release_feature = false;
  bool reset_history = false;
};

[[nodiscard]] constexpr FeatureLifecycleDecision PlanFeatureLifecycle(
    DetroitDlssMode mode,
    const ModeAvailability& availability,
    const FeatureTransition& transition) noexcept {
  if (!IsDlssMode(mode) || !availability.available) {
    return {.release_feature = transition.feature_exists};
  }
  if (!transition.feature_exists) {
    return {.create_feature = true, .reset_history = true};
  }

  const bool recreate = transition.mode_changed
                        || transition.render_extent_changed
                        || transition.output_extent_changed
                        || transition.camera_cut
                        || transition.scene_loaded;
  return {
      .recreate_feature = recreate,
      .reset_history = recreate || transition.manual_reset,
  };
}

}  // namespace renodx::games::detroitbecomehuman::dlss_policy
