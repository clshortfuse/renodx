// Helpers from marat569/renodx 377ce8a59d6371b29c5ccfe9f0157af2536408bf
// src/shaders/tonemap/psychov/test22.hlsl
// Copyright (C) 2026 Carlos Lopez; SPDX-License-Identifier: MIT
#ifndef GEARS4_UE_EXTENDED_COMPAT_HLSLI_
#define GEARS4_UE_EXTENDED_COMPAT_HLSLI_
namespace gears4_ue_extended {
float3 psycho22_ToAdaptiveRelativeWeightedLMS(float3 lms_input, float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 psycho22_FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float3 psycho22_GamutCompressAdaptiveRelativeWeightedLMSBound(
    float3 lms_weighted_relative_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  return renodx::color::gamut::GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
      lms_weighted_relative_input,
      current_adaptive_state_lms,
      bound_rgb_to_lms_weighted_mat,
      strength);
}

float3 psycho22_AdaptiveRelativeWeightedNeutral() {
  // In psycho22_ToAdaptiveRelativeWeightedLMS():
  //   adapted background LMS -> WeighLMS(adapted) / adapted = LMS_WEIGHTS
  return renodx::color::macleod_boynton::WeighLMS(1.f.xxx);
}


}
#endif
