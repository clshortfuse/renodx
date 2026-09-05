#ifndef SRC_SHADERS_COLOR_BLEACHING_HLSL_
#define SRC_SHADERS_COLOR_BLEACHING_HLSL_

#include "../common.hlsli"

namespace renodx {
namespace color {
namespace bleaching {

namespace rushton_henry {

static const float CONE_HALF_BLEACH_TROLANDS = 20000.f;

// One-sided availability limiter in adapted units.
// p(r) = 1 / (1 + r / r0)
// Source direction: same algebraic form as the steady-state cone bleaching law
// used by Rushton & Henry (1968), commonly written for fraction bleached as
//   p_bleached(I) = I / (I + I0)
// with I in photopic trolands and I0 ~ 10^4.3 Td for cones. This helper uses
// the complementary fraction
//   p_available(I) = 1 - p_bleached(I) = I0 / (I + I0)
// because the shader attenuates available cone drive rather than tracking the
// bleached fraction directly.
// Secondary source with the equation stated explicitly:
// Stockman, Henning, Smithson, & Rider (JOV 2018, 18(6):12), appendix note:
// "p = I / (I + I0)", with I0 = 10^4.3 Td, citing Rushton & Henry (1968).
float AvailabilityFromRelativeDrive(float relative_drive, float knee_ratio) {
  return 1.f / (1.f + relative_drive / knee_ratio);
}

// Absolute trolands form of the same availability law.
// p(I) = 1 / (1 + I / I0)
float AvailabilityFromTrolands(float retinal_illuminance_trolands,
                               float half_bleach_trolands = CONE_HALF_BLEACH_TROLANDS) {
  return 1.f / (1.f + retinal_illuminance_trolands / half_bleach_trolands);
}

float3 AvailabilityFromTrolands(float3 retinal_illuminance_trolands,
                                float half_bleach_trolands = CONE_HALF_BLEACH_TROLANDS) {
  return float3(
      AvailabilityFromTrolands(retinal_illuminance_trolands.x, half_bleach_trolands),
      AvailabilityFromTrolands(retinal_illuminance_trolands.y, half_bleach_trolands),
      AvailabilityFromTrolands(retinal_illuminance_trolands.z, half_bleach_trolands));
}

}  // namespace rushton_henry

// White-relative per-cone attenuation:
// - Keeps a white anchor at the same L+M level as the input.
// - Applies independent cone gains to LMS deltas around that anchor.
// Engineering interpretation:
// - The bleaching source law above constrains available pigment / sensitivity.
// - The specific "bleach toward white at the same carried achromatic level"
//   behavior implemented here is the repo's rendering model for color signals,
//   not a literal equation from Rushton & Henry. It is chosen so that strong
//   bleaching suppresses cone-opponent excursions while preserving the
//   achromatic anchor.
// - CVRL notes that bleaching also reduces effective photopigment density and
//   therefore narrows spectral sensitivity without shifting lambda_max. This
//   helper does not model that wavelength-dependent narrowing; it is a
//   first-order scalar availability approximation intended for rendering.
// - CVRL also notes that a reliable S-cone half-bleaching constant has not
//   been established. The shared cone knee used here is therefore an
//   engineering approximation rather than a fully resolved per-cone
//   physiological model.
float3 ApplyAvailabilityToLMSPerConeWhiteRelative(float3 lms, float3 availability_lms,
                                                  float3 white_lms) {
  float y = lms.x + lms.y;
  float white_y = white_lms.x + white_lms.y;
  float3 white_at_y = white_lms * (y / white_y);
  float3 delta = lms - white_at_y;
  delta *= availability_lms;

  return white_at_y + delta;
}

float3 ComputeAvailabilityFromAdaptedLMS(float3 adapted_lms, float blend,
                                         float diffuse_white_nits = 100.f,
                                         float pupil_area_mm2 = 10.f,
                                         float half_bleach_trolands =
                                             rushton_henry::CONE_HALF_BLEACH_TROLANDS) {
  float3 stimulus_trolands = max(adapted_lms, 0) * diffuse_white_nits * pupil_area_mm2;
  float3 availability = rushton_henry::AvailabilityFromTrolands(
      stimulus_trolands, half_bleach_trolands);

  return lerp(1.f, availability, blend);
}



}  // namespace bleaching
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_BLEACHING_HLSL_
