/*
 * SPDX-License-Identifier: MIT
 */

#include <array>
#include <bit>
#include <cstdint>
#include <iostream>
#include <limits>
#include <string_view>

#include "src/games/detroitbecomehuman/dlss_policy.hpp"

namespace {

namespace policy = renodx::games::detroitbecomehuman::dlss_policy;

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

policy::RuntimeSupport MakeSupport() {
  return {
      .executable_supported = true,
      .bridge_available = true,
      .ngx_initialized = true,
      .temporal_interface_verified = true,
      .dlaa_available = true,
      .super_resolution_available = true,
      .render_scale_control_available = true,
      .auto_exposure_available = true,
      .bridge_abi_version = DETROIT_DLSS_ABI_VERSION,
  };
}

DetroitDlssResource MakeResource(
    std::uint64_t identity,
    std::uint32_t width,
    std::uint32_t height) {
  return {
      .image = identity,
      .image_view = identity + UINT64_C(0x1000),
      .format = 97u,
      .layout = 5u,
      .width = width,
      .height = height,
      .mip_level = 0u,
      .array_layer = 0u,
      .flags = 0u,
      .reserved = 0u,
  };
}

DetroitDlssModeSettings MakeSettings(DetroitDlssMode mode) {
  const bool dlaa = mode == DETROIT_DLSS_MODE_DLAA;
  return {
      .struct_size = sizeof(DetroitDlssModeSettings),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .mode = mode,
      .create_flags = DETROIT_DLSS_CREATE_HDR
                      | DETROIT_DLSS_CREATE_MOTION_VECTORS_LOW_RESOLUTION,
      .output_width = 3440u,
      .output_height = 1440u,
      .render_width = dlaa ? 3440u : 2293u,
      .render_height = dlaa ? 1440u : 960u,
      .min_render_width = 0u,
      .min_render_height = 0u,
      .max_render_width = 0u,
      .max_render_height = 0u,
  };
}

DetroitDlssTemporalFrameInputs MakeInputs(const DetroitDlssModeSettings& settings) {
  return {
      .struct_size = sizeof(DetroitDlssTemporalFrameInputs),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .shader_crc = DETROIT_DLSS_TEMPORAL_AA_SHADER_CRC,
      .descriptor_set_index = DETROIT_DLSS_TAA_DESCRIPTOR_SET,
      .command_buffer = UINT64_C(0x10000001),
      .descriptor_set = UINT64_C(0x10000002),
      .pipeline_layout = UINT64_C(0x10000003),
      .constants_buffer = UINT64_C(0x10000004),
      .constants_offset = 0u,
      .constants_size = 496u,
      .current_color = MakeResource(0x2001u, settings.render_width, settings.render_height),
      .depth = MakeResource(0x2002u, settings.render_width, settings.render_height),
      .motion_vectors = MakeResource(0x2003u, settings.render_width, settings.render_height),
      .exposure = MakeResource(0x2004u, 1u, 1u),
      .output = MakeResource(0x2005u, settings.output_width, settings.output_height),
      .render_width = settings.render_width,
      .render_height = settings.render_height,
      .output_width = settings.output_width,
      .output_height = settings.output_height,
      .jitter_x = 0.25f,
      .jitter_y = -0.25f,
      .motion_vector_scale_x = static_cast<float>(settings.render_width),
      .motion_vector_scale_y = static_cast<float>(settings.render_height),
      .pre_exposure = 1.f,
      .reset = 0u,
      .frame_id = 42u,
      .flags = DETROIT_DLSS_FRAME_NATIVE_TAA_COMPLETED,
      .verification_flags = DETROIT_DLSS_VERIFY_MANDATORY_MASK,
      .dlaa_sharpening = 0.f,
      .dlaa_sharpening_normalization = 1.f,
  };
}

policy::FrameEligibility Check(
    DetroitDlssMode mode,
    const policy::RuntimeSupport& support,
    const DetroitDlssModeSettings& settings,
    const DetroitDlssTemporalFrameInputs& inputs) {
  return policy::CheckFrameEligibility(mode, support, settings, inputs);
}

bool ExpectReason(
    const policy::FrameEligibility& eligibility,
    policy::FallbackReason reason,
    std::string_view description) {
  return Expect(
      !eligibility.evaluate_dlss
          && eligibility.preserve_native_taa
          && eligibility.reason == reason,
      description);
}

bool TestModeAvailability() {
  bool passed = true;
  const auto full = MakeSupport();

  const auto native = policy::CheckModeAvailability(DETROIT_DLSS_MODE_NATIVE, {});
  passed &= Expect(
      native.available && native.reason == policy::FallbackReason::kNativeMode,
      "Native mode must remain available without DLSS support");
  for (DetroitDlssMode mode : {
           DETROIT_DLSS_MODE_DLAA,
           DETROIT_DLSS_MODE_QUALITY,
           DETROIT_DLSS_MODE_BALANCED,
           DETROIT_DLSS_MODE_PERFORMANCE,
       }) {
    const auto availability = policy::CheckModeAvailability(mode, full);
    passed &= Expect(
        availability.available && availability.reason == policy::FallbackReason::kNone,
        "fully supported DLSS mode must be available");
  }
  passed &= Expect(
      policy::CheckModeAvailability(99u, full).reason == policy::FallbackReason::kUnknownMode,
      "unknown mode must fail closed");

  auto support = full;
  support.executable_supported = false;
  passed &= Expect(
      policy::CheckModeAvailability(DETROIT_DLSS_MODE_DLAA, support).reason
          == policy::FallbackReason::kUnsupportedExecutable,
      "unsupported executable must fail closed");
  support = full;
  support.bridge_abi_version = DETROIT_DLSS_ABI_VERSION + 1u;
  passed &= Expect(
      policy::CheckModeAvailability(DETROIT_DLSS_MODE_DLAA, support).reason
          == policy::FallbackReason::kAbiMismatch,
      "ABI mismatch must fail closed");
  support = full;
  support.bridge_available = false;
  passed &= Expect(
      policy::CheckModeAvailability(DETROIT_DLSS_MODE_DLAA, support).reason
          == policy::FallbackReason::kBridgeUnavailable,
      "missing bridge must fail closed");
  support = full;
  support.ngx_initialized = false;
  passed &= Expect(
      policy::CheckModeAvailability(DETROIT_DLSS_MODE_DLAA, support).reason
          == policy::FallbackReason::kNgxUnavailable,
      "missing NGX must fail closed");
  support = full;
  support.temporal_interface_verified = false;
  passed &= Expect(
      policy::CheckModeAvailability(DETROIT_DLSS_MODE_DLAA, support).reason
          == policy::FallbackReason::kTemporalInterfaceUnverified,
      "unverified temporal interface must fail closed");
  support = full;
  support.dlaa_available = false;
  passed &= Expect(
      policy::CheckModeAvailability(DETROIT_DLSS_MODE_DLAA, support).reason
          == policy::FallbackReason::kModeUnsupported,
      "missing DLAA capability must fail closed");
  support = full;
  support.super_resolution_available = false;
  passed &= Expect(
      policy::CheckModeAvailability(DETROIT_DLSS_MODE_QUALITY, support).reason
          == policy::FallbackReason::kModeUnsupported,
      "missing SR capability must fail closed");
  support = full;
  support.render_scale_control_available = false;
  passed &= Expect(
      policy::CheckModeAvailability(DETROIT_DLSS_MODE_QUALITY, support).reason
          == policy::FallbackReason::kRenderScaleUnavailable,
      "SR without safe render-scale control must fail closed");
  passed &= Expect(
      policy::CheckModeAvailability(DETROIT_DLSS_MODE_DLAA, support).available,
      "DLAA must not require render-scale control");
  return passed;
}

bool TestValidFramesAndMandatoryEvidence() {
  bool passed = true;
  const auto support = MakeSupport();

  passed &= ExpectReason(
      Check(DETROIT_DLSS_MODE_NATIVE, {}, {}, {}),
      policy::FallbackReason::kNativeMode,
      "Native mode must bypass every DLSS frame requirement");

  for (DetroitDlssMode mode : {DETROIT_DLSS_MODE_DLAA, DETROIT_DLSS_MODE_QUALITY}) {
    auto settings = MakeSettings(mode);
    auto inputs = MakeInputs(settings);
    const auto eligibility = Check(mode, support, settings, inputs);
    passed &= Expect(
        eligibility.evaluate_dlss
            && eligibility.preserve_native_taa
            && !eligibility.use_auto_exposure
            && eligibility.reason == policy::FallbackReason::kNone,
        "complete DLSS frame must be eligible while retaining native TAA");
  }

  constexpr std::array<DetroitDlssVerificationFlags, 11u> required_bits = {{
      DETROIT_DLSS_VERIFY_RESOURCE_SEMANTICS,
      DETROIT_DLSS_VERIFY_DESCRIPTOR_SET_AND_LAYOUTS,
      DETROIT_DLSS_VERIFY_CONSTANTS_DECODED,
      DETROIT_DLSS_VERIFY_JITTER_DECODED,
      DETROIT_DLSS_VERIFY_DEPTH_CONVENTION,
      DETROIT_DLSS_VERIFY_MOTION_VECTOR_DIRECTION_AND_SCALE,
      DETROIT_DLSS_VERIFY_MOTION_VECTORS_INCLUDE_CAMERA,
      DETROIT_DLSS_VERIFY_CURRENT_COLOR_IS_UI_FREE,
      DETROIT_DLSS_VERIFY_EXPOSURE,
      DETROIT_DLSS_VERIFY_DIMENSIONS,
      DETROIT_DLSS_VERIFY_HISTORY,
  }};

  DetroitDlssVerificationFlags reconstructed_mask = 0u;
  for (const auto bit : required_bits) {
    passed &= Expect(
        std::popcount(bit) == 1,
        "every mandatory verification flag must be one nonzero bit");
    passed &= Expect(
        (reconstructed_mask & bit) == 0u,
        "mandatory verification flags must be unique");
    reconstructed_mask |= bit;
  }
  passed &= Expect(
      reconstructed_mask == DETROIT_DLSS_VERIFY_MANDATORY_MASK,
      "mandatory mask must contain every named proof bit and no implicit bits");

  auto settings = MakeSettings(DETROIT_DLSS_MODE_DLAA);
  const auto baseline = MakeInputs(settings);

  // Exhaust every subset of the mandatory mask. Only the full set of current-
  // frame proofs may authorize evaluation; the runtime-wide verified bit in
  // RuntimeSupport must never substitute for a missing frame proof.
  auto subset = DETROIT_DLSS_VERIFY_MANDATORY_MASK;
  for (;;) {
    auto inputs = baseline;
    inputs.verification_flags = subset;
    const auto eligibility =
        Check(DETROIT_DLSS_MODE_DLAA, support, settings, inputs);
    if (subset == DETROIT_DLSS_VERIFY_MANDATORY_MASK) {
      passed &= Expect(
          eligibility.evaluate_dlss
              && eligibility.reason == policy::FallbackReason::kNone,
          "the exact mandatory verification mask must authorize evaluation");
    } else {
      passed &= ExpectReason(
          eligibility,
          policy::FallbackReason::kVerificationIncomplete,
          "every incomplete verification subset must fail closed");
    }
    if (subset == 0u) break;
    subset = (subset - 1u) & DETROIT_DLSS_VERIFY_MANDATORY_MASK;
  }

  for (const auto missing_bit : required_bits) {
    auto inputs = baseline;
    inputs.verification_flags =
        (DETROIT_DLSS_VERIFY_MANDATORY_MASK & ~missing_bit)
        | (UINT64_C(1) << 63u);
    passed &= ExpectReason(
        Check(DETROIT_DLSS_MODE_DLAA, support, settings, inputs),
        policy::FallbackReason::kVerificationIncomplete,
        "an unknown flag must not replace a missing mandatory proof");
  }
  return passed;
}

bool TestFrameIdentityAndSnapshots() {
  bool passed = true;
  const auto support = MakeSupport();
  auto settings = MakeSettings(DETROIT_DLSS_MODE_DLAA);
  const auto baseline = MakeInputs(settings);

  auto inputs = baseline;
  inputs.struct_size -= 1u;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kFrameAbiMismatch,
      "short frame struct must fail closed");
  inputs = baseline;
  inputs.abi_version += 1u;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kFrameAbiMismatch,
      "frame ABI mismatch must fail closed");
  inputs = baseline;
  inputs.shader_crc ^= 1u;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kShaderMismatch,
      "wrong temporal shader CRC must fail closed");
  inputs = baseline;
  inputs.flags &= ~DETROIT_DLSS_FRAME_NATIVE_TAA_COMPLETED;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kNativeTaaNotCompleted,
      "safe prototype requires native TAA completion");
  inputs = baseline;
  inputs.command_buffer = 0u;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kInvalidCommandBuffer,
      "missing command buffer must fail closed");

  for (std::uint32_t variant = 0u; variant < 3u; ++variant) {
    inputs = baseline;
    if (variant == 0u) inputs.descriptor_set_index = 1u;
    if (variant == 1u) inputs.descriptor_set = 0u;
    if (variant == 2u) inputs.pipeline_layout = 0u;
    passed &= ExpectReason(
        Check(settings.mode, support, settings, inputs),
        policy::FallbackReason::kInvalidDescriptorSnapshot,
        "descriptor set-0 snapshot must be complete");
  }
  for (std::uint32_t variant = 0u; variant < 2u; ++variant) {
    inputs = baseline;
    if (variant == 0u) inputs.constants_buffer = 0u;
    if (variant == 1u) inputs.constants_size = 0u;
    passed &= ExpectReason(
        Check(settings.mode, support, settings, inputs),
        policy::FallbackReason::kInvalidConstantsSnapshot,
        "b52 snapshot metadata must be complete");
  }
  return passed;
}

bool TestResourcesExposureAndDimensions() {
  bool passed = true;
  auto support = MakeSupport();
  auto settings = MakeSettings(DETROIT_DLSS_MODE_DLAA);
  const auto baseline = MakeInputs(settings);

  struct ResourceCase {
    policy::FallbackReason reason;
    void (*clear)(DetroitDlssTemporalFrameInputs&);
  };
  const std::array<ResourceCase, 4u> cases = {{
      {policy::FallbackReason::kMissingCurrentColor,
       [](DetroitDlssTemporalFrameInputs& value) { value.current_color.image = 0u; }},
      {policy::FallbackReason::kMissingDepth,
       [](DetroitDlssTemporalFrameInputs& value) { value.depth.image_view = 0u; }},
      {policy::FallbackReason::kMissingMotionVectors,
       [](DetroitDlssTemporalFrameInputs& value) { value.motion_vectors.format = 0u; }},
      {policy::FallbackReason::kMissingOutput,
       [](DetroitDlssTemporalFrameInputs& value) { value.output.layout = 0u; }},
  }};
  for (const auto& test_case : cases) {
    auto inputs = baseline;
    test_case.clear(inputs);
    passed &= ExpectReason(
        Check(settings.mode, support, settings, inputs),
        test_case.reason,
        "missing mandatory resource must fail closed");
  }

  auto inputs = baseline;
  inputs.output.image = inputs.current_color.image;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kAliasedColorOutput,
      "input and output images must not alias");

  inputs = baseline;
  inputs.exposure = {};
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kMissingExposure,
      "missing exposure must fail without configured auto-exposure");
  settings.create_flags |= DETROIT_DLSS_CREATE_AUTO_EXPOSURE;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kMissingExposure,
      "auto-exposure must be allowed by the current frame");
  inputs.flags |= DETROIT_DLSS_FRAME_ALLOW_AUTO_EXPOSURE;
  auto eligibility = Check(settings.mode, support, settings, inputs);
  passed &= Expect(
      eligibility.evaluate_dlss && eligibility.use_auto_exposure,
      "explicit supported auto-exposure fallback must be eligible");
  support.auto_exposure_available = false;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kMissingExposure,
      "unsupported auto-exposure request must fail closed");

  support = MakeSupport();
  settings = MakeSettings(DETROIT_DLSS_MODE_DLAA);
  inputs = baseline;
  inputs.render_width = 0u;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kInvalidExtent,
      "zero frame extent must fail closed");
  inputs = baseline;
  inputs.motion_vectors.width -= 1u;
  passed &= ExpectReason(
      Check(settings.mode, support, settings, inputs),
      policy::FallbackReason::kExtentMismatch,
      "resource/frame extent mismatch must fail closed");
  return passed;
}

bool TestTemporalConstantsAndModeSettings() {
  bool passed = true;
  const auto support = MakeSupport();
  auto settings = MakeSettings(DETROIT_DLSS_MODE_DLAA);
  const auto baseline = MakeInputs(settings);

  for (std::uint32_t variant = 0u; variant < 9u; ++variant) {
    auto inputs = baseline;
    if (variant == 0u) inputs.jitter_x = std::numeric_limits<float>::quiet_NaN();
    if (variant == 1u) inputs.jitter_y = std::numeric_limits<float>::infinity();
    if (variant == 2u) inputs.motion_vector_scale_x = 0.f;
    if (variant == 3u) inputs.motion_vector_scale_y = -std::numeric_limits<float>::infinity();
    if (variant == 4u) inputs.pre_exposure = 0.f;
    if (variant == 5u) inputs.dlaa_sharpening = -0.01f;
    if (variant == 6u) inputs.dlaa_sharpening = 1.01f;
    if (variant == 7u) {
      inputs.dlaa_sharpening_normalization =
          std::numeric_limits<float>::quiet_NaN();
    }
    if (variant == 8u) inputs.dlaa_sharpening_normalization = 0.99f;
    passed &= ExpectReason(
        Check(settings.mode, support, settings, inputs),
        policy::FallbackReason::kInvalidTemporalConstants,
        "invalid temporal constant must fail closed");
  }

  auto bad_settings = settings;
  bad_settings.struct_size -= 1u;
  passed &= ExpectReason(
      Check(settings.mode, support, bad_settings, baseline),
      policy::FallbackReason::kInvalidModeSettings,
      "short mode-settings struct must fail closed");
  bad_settings = settings;
  bad_settings.abi_version += 1u;
  passed &= ExpectReason(
      Check(settings.mode, support, bad_settings, baseline),
      policy::FallbackReason::kInvalidModeSettings,
      "mode-settings ABI mismatch must fail closed");
  bad_settings = settings;
  bad_settings.mode = DETROIT_DLSS_MODE_QUALITY;
  passed &= ExpectReason(
      Check(settings.mode, support, bad_settings, baseline),
      policy::FallbackReason::kInvalidModeSettings,
      "mode-settings selection mismatch must fail closed");
  bad_settings = settings;
  bad_settings.create_flags |= UINT32_C(0x80000000);
  passed &= ExpectReason(
      Check(settings.mode, support, bad_settings, baseline),
      policy::FallbackReason::kInvalidModeSettings,
      "unknown NGX create flag must fail closed");
  bad_settings = settings;
  bad_settings.render_width -= 1u;
  passed &= ExpectReason(
      Check(settings.mode, support, bad_settings, baseline),
      policy::FallbackReason::kInvalidModeSettings,
      "mode/frame dimension mismatch must fail closed");

  auto non_native_inputs = baseline;
  non_native_inputs.render_width -= 1u;
  non_native_inputs.current_color.width -= 1u;
  non_native_inputs.depth.width -= 1u;
  non_native_inputs.motion_vectors.width -= 1u;
  bad_settings = settings;
  bad_settings.render_width -= 1u;
  passed &= ExpectReason(
      Check(DETROIT_DLSS_MODE_DLAA, support, bad_settings, non_native_inputs),
      policy::FallbackReason::kInvalidModeSettings,
      "DLAA must remain 1:1");

  auto sr_settings = MakeSettings(DETROIT_DLSS_MODE_QUALITY);
  auto sr_inputs = MakeInputs(sr_settings);
  sr_settings.render_width = sr_settings.output_width;
  sr_settings.render_height = sr_settings.output_height;
  sr_inputs = MakeInputs(sr_settings);
  passed &= ExpectReason(
      Check(DETROIT_DLSS_MODE_QUALITY, support, sr_settings, sr_inputs),
      policy::FallbackReason::kInvalidModeSettings,
      "SR must use a smaller render extent");

  sr_settings = MakeSettings(DETROIT_DLSS_MODE_QUALITY);
  sr_settings.min_render_width = sr_settings.render_width + 1u;
  sr_settings.min_render_height = sr_settings.render_height + 1u;
  sr_inputs = MakeInputs(sr_settings);
  passed &= ExpectReason(
      Check(DETROIT_DLSS_MODE_QUALITY, support, sr_settings, sr_inputs),
      policy::FallbackReason::kInvalidModeSettings,
      "render extent below queried minimum must fail closed");
  sr_settings = MakeSettings(DETROIT_DLSS_MODE_QUALITY);
  sr_settings.max_render_width = sr_settings.render_width - 1u;
  sr_settings.max_render_height = sr_settings.render_height - 1u;
  sr_inputs = MakeInputs(sr_settings);
  passed &= ExpectReason(
      Check(DETROIT_DLSS_MODE_QUALITY, support, sr_settings, sr_inputs),
      policy::FallbackReason::kInvalidModeSettings,
      "render extent above queried maximum must fail closed");
  return passed;
}

bool TestFinalOutcomeIsFailClosed() {
  bool passed = true;
  policy::FrameEligibility eligible = {
      .evaluate_dlss = true,
      .preserve_native_taa = true,
      .reason = policy::FallbackReason::kNone,
  };
  DetroitDlssEvaluateResult result = {
      .struct_size = sizeof(DetroitDlssEvaluateResult),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .status = DETROIT_DLSS_RESULT_SUCCESS,
      .detail_code = 0u,
      .frame_id = 42u,
      .flags = DETROIT_DLSS_EVALUATE_OUTPUT_VALID,
  };
  auto outcome = policy::FinalizeFrame(eligible, result, 42u);
  passed &= Expect(
      outcome.use_dlss_output
          && outcome.preserve_native_taa
          && outcome.suppress_final_cas
          && outcome.reason == policy::FallbackReason::kNone,
      "only a valid successful evaluation may select DLSS and suppress CAS");

  result.status = DETROIT_DLSS_RESULT_FALLBACK;
  outcome = policy::FinalizeFrame(eligible, result, 42u);
  passed &= Expect(
      !outcome.use_dlss_output
          && !outcome.suppress_final_cas
          && outcome.preserve_native_taa
          && outcome.reason == policy::FallbackReason::kEvaluateFallback,
      "bridge fallback must retain native output and CAS");
  result.status = DETROIT_DLSS_RESULT_ERROR;
  outcome = policy::FinalizeFrame(eligible, result, 42u);
  passed &= Expect(
      !outcome.use_dlss_output
          && !outcome.suppress_final_cas
          && outcome.reason == policy::FallbackReason::kEvaluateError,
      "bridge error must retain native output and CAS");

  result.status = DETROIT_DLSS_RESULT_SUCCESS;
  result.flags = 0u;
  passed &= Expect(
      policy::FinalizeFrame(eligible, result, 42u).reason
          == policy::FallbackReason::kInvalidEvaluateResult,
      "success without output-valid proof must fail closed");
  result.flags = DETROIT_DLSS_EVALUATE_OUTPUT_VALID;
  result.frame_id = 43u;
  passed &= Expect(
      policy::FinalizeFrame(eligible, result, 42u).reason
          == policy::FallbackReason::kInvalidEvaluateResult,
      "stale evaluation frame ID must fail closed");
  result.frame_id = 42u;
  result.struct_size -= 1u;
  passed &= Expect(
      policy::FinalizeFrame(eligible, result, 42u).reason
          == policy::FallbackReason::kInvalidEvaluateResult,
      "short evaluation result must fail closed");
  result.struct_size = sizeof(DetroitDlssEvaluateResult);
  result.abi_version += 1u;
  passed &= Expect(
      policy::FinalizeFrame(eligible, result, 42u).reason
          == policy::FallbackReason::kInvalidEvaluateResult,
      "evaluation ABI mismatch must fail closed");
  result.abi_version = DETROIT_DLSS_ABI_VERSION;
  result.status = 99u;
  passed &= Expect(
      policy::FinalizeFrame(eligible, result, 42u).reason
          == policy::FallbackReason::kInvalidEvaluateResult,
      "unknown evaluation status must fail closed");

  eligible.evaluate_dlss = false;
  eligible.reason = policy::FallbackReason::kVerificationIncomplete;
  result.struct_size = sizeof(DetroitDlssEvaluateResult);
  outcome = policy::FinalizeFrame(eligible, result, 42u);
  passed &= Expect(
      !outcome.use_dlss_output
          && outcome.reason == policy::FallbackReason::kVerificationIncomplete,
      "successful-looking result cannot override ineligible frame");
  return passed;
}

bool TestFeatureLifecycle() {
  bool passed = true;
  const policy::ModeAvailability available = {
      .available = true,
      .reason = policy::FallbackReason::kNone,
  };
  const policy::ModeAvailability unavailable = {
      .available = false,
      .reason = policy::FallbackReason::kNgxUnavailable,
  };

  auto decision = policy::PlanFeatureLifecycle(
      DETROIT_DLSS_MODE_NATIVE,
      available,
      {.feature_exists = true});
  passed &= Expect(
      decision.release_feature && !decision.create_feature && !decision.recreate_feature,
      "Native mode must release an existing DLSS feature");
  decision = policy::PlanFeatureLifecycle(
      DETROIT_DLSS_MODE_DLAA,
      unavailable,
      {.feature_exists = true});
  passed &= Expect(decision.release_feature, "unavailable DLSS mode must release its feature");
  decision = policy::PlanFeatureLifecycle(
      DETROIT_DLSS_MODE_DLAA,
      available,
      {.feature_exists = false});
  passed &= Expect(
      decision.create_feature && decision.reset_history,
      "first eligible frame must create a feature with reset history");
  decision = policy::PlanFeatureLifecycle(
      DETROIT_DLSS_MODE_DLAA,
      available,
      {.feature_exists = true});
  passed &= Expect(
      !decision.create_feature
          && !decision.recreate_feature
          && !decision.release_feature
          && !decision.reset_history,
      "stable frame must not churn the feature");

  const std::array<policy::FeatureTransition, 5u> recreate_cases = {{
      {.feature_exists = true, .mode_changed = true},
      {.feature_exists = true, .render_extent_changed = true},
      {.feature_exists = true, .output_extent_changed = true},
      {.feature_exists = true, .camera_cut = true},
      {.feature_exists = true, .scene_loaded = true},
  }};
  for (const auto& transition : recreate_cases) {
    decision = policy::PlanFeatureLifecycle(
        DETROIT_DLSS_MODE_DLAA,
        available,
        transition);
    passed &= Expect(
        decision.recreate_feature && decision.reset_history,
        "mode/extent/cut/load transition must recreate and reset");
  }
  decision = policy::PlanFeatureLifecycle(
      DETROIT_DLSS_MODE_DLAA,
      available,
      {.feature_exists = true, .manual_reset = true});
  passed &= Expect(
      !decision.recreate_feature && decision.reset_history,
      "manual reset alone must reset history without recreating");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestModeAvailability();
  passed &= TestValidFramesAndMandatoryEvidence();
  passed &= TestFrameIdentityAndSnapshots();
  passed &= TestResourcesExposureAndDimensions();
  passed &= TestTemporalConstantsAndModeSettings();
  passed &= TestFinalOutcomeIsFailClosed();
  passed &= TestFeatureLifecycle();
  std::cerr << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
