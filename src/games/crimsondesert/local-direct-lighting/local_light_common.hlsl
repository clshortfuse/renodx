#ifndef RENODX_LOCAL_LIGHT_COMMON_HLSL_
#define RENODX_LOCAL_LIGHT_COMMON_HLSL_

#include "../psycho_test11_custom.hlsl"

// ============================================================================
// Local Light Hue Correction — MB Space (Stockman-Sharp LMS + BT.2020)
// ============================================================================
// Corrects authored pink/red flame light colour toward warm orange/yellow via MacLeod-Boynton chromaticity rotation.
//
// Reference fire colours in MB space (precomputed from Stockman-Sharp LMS):
//   ~2000K blackbody → warm orange, low S (blue cone), high L/(L+M)
//   Pink/magenta    → elevated S, shifted r from white
//
// The correction rotates the MB hue direction from white toward a target
// warm-fire hue, preserving MB luminosity (weighted L+M) and modulating
// purity independently.
//
static const float2 FIRE_TARGET_MB_DIR = float2(0.91618f, -0.40076f);
//
// Applies MB hue rotation toward warm fire target + optional purity scaling.
//
// hue_strength: 0 = no hue change, 1 = fully rotate to fire target direction.
// purity_scale: 1 = unchanged, >1 = more saturated, <1 = desaturated.
// Input/output: BT.709 linear, scene-referred (HDR values > 1.0 OK).
float3 ApplyLocalLightHueCorrection(float3 color_bt709, float hue_strength, float purity_scale) {
  const float kEps = 1e-6f;
  const float kNearWhiteEps = 1e-14f;

  if (hue_strength <= 0.f && abs(purity_scale - 1.f) <= kEps) {
    return color_bt709;
  }

  // BT.709 → BT.2020 → Stockman-Sharp LMS
  float3 bt2020 = psycho11_BT2020FromBT709(color_bt709);
  float3 lms = psycho11_LMSFromBT2020(bt2020);

  // Pre-correct gamut (pull any negatives into valid range)
  lms = psycho11_GamutCompressAddWhiteBT2020Bounded(lms);

  float3 mb = psycho11_MB2FromLMS(lms);
  float2 white = psycho11_WhiteD65Chromaticity();

  float2 color_offset = mb.xy - white;
  float color_dist_sq = dot(color_offset, color_offset);

  // Near-achromatic: nothing to rotate
  if (color_dist_sq <= kNearWhiteEps) {
    return color_bt709;
  }

  float color_radius = sqrt(color_dist_sq);
  float2 color_dir = color_offset * rsqrt(color_dist_sq);

  // Hue rotation: blend current MB direction toward fire target direction
  float hue_blend = saturate(hue_strength);
  float2 blended_dir = lerp(color_dir, FIRE_TARGET_MB_DIR, hue_blend);
  float blended_len_sq = dot(blended_dir, blended_dir);
  if (blended_len_sq <= kNearWhiteEps) {
    blended_dir = color_dir;
  } else {
    blended_dir *= rsqrt(blended_len_sq);
  }

  // Reconstruct MB chromaticity at same radius (preserves purity distance)
  float final_radius = color_radius;

  // Optional purity scaling
  if (abs(purity_scale - 1.f) > kEps) {
    final_radius *= max(purity_scale, 0.f);
  }

  float2 mb_corrected_xy = white + blended_dir * final_radius;
  float3 mb_corrected = float3(mb_corrected_xy, mb.z);

  // MB → LMS → gamut compress → BT.2020 → BT.709
  float3 lms_corrected = psycho11_LMSFromMB2(mb_corrected);
  lms_corrected = psycho11_GamutCompressAddWhiteBT2020Bounded(lms_corrected);
  float3 bt2020_corrected = psycho11_BT2020FromLMS(lms_corrected);
  return max(psycho11_BT709FromBT2020(bt2020_corrected), 0.f);
}

#endif  // RENODX_LOCAL_LIGHT_COMMON_HLSL_
