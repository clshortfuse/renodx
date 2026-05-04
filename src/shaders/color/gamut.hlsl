#ifndef SRC_SHADERS_COLOR_GAMUT_HLSL_
#define SRC_SHADERS_COLOR_GAMUT_HLSL_

#include "./macleod_boynton.hlsl"

namespace renodx {
namespace color {
namespace gamut {

// MacLeod-Boynton-space gamut logic, including the CIE 170-2 human-gamut
// boundary data and helpers built on top of it.

static const float EPSILON = 1e-20f;
float2 CIE1702WhiteChromaticity() {
  return renodx::color::macleod_boynton::from::D65XY();
}

static const float MB_NEAR_WHITE_EPSILON = 1e-14f;
static const float INTERVAL_MAX = renodx::math::FLT_MAX;
static const float CIE1702_RAY_T_MAX = 1e20f;
static const int CIE1702_EDGE_COUNT = 7;
static const float2 CIE1702_HALFSPACE_NORMALS[CIE1702_EDGE_COUNT] = {
  float2(-0.043889f, -0.006807f),
  float2(-0.007821f, -0.008564f),
  float2(-0.000604f, -0.007942f),
  float2(0.f, -0.080835f),
  float2(0.953597f, 0.307020f),
  float2(-0.060969f, 0.019752f),
  float2(-0.106895f, 0.004035f),
};
static const float CIE1702_HALFSPACE_NUMERATORS[CIE1702_EDGE_COUNT] = {
  0.0065035249f,
  0.00104900495f,
  0.000207697044f,
  0.00165556648f,
  0.252472349f,
  0.0241967351f,
  0.0199621232f,
};
static const int CIE1702_BOUNDARY_POINT_COUNT = 89;
static const float2 CIE1702_BOUNDARY_LS[CIE1702_BOUNDARY_POINT_COUNT] = {
  float2(0.690547000f, 0.855670000f),
  float2(0.684874000f, 0.835495000f),
  float2(0.677571000f, 0.858452000f),
  float2(0.670708000f, 0.915226000f),
  float2(0.662656000f, 0.953597000f),
  float2(0.645977000f, 0.991436000f),
  float2(0.627777000f, 0.996399000f),
  float2(0.605668000f, 0.959504000f),
  float2(0.585916000f, 0.898535000f),
  float2(0.565891000f, 0.807527000f),
  float2(0.551744000f, 0.731596000f),
  float2(0.539800000f, 0.641510000f),
  float2(0.531511000f, 0.548520000f),
  float2(0.527476000f, 0.441625000f),
  float2(0.524357000f, 0.343327000f),
  float2(0.525096000f, 0.258774000f),
  float2(0.528335000f, 0.184906000f),
  float2(0.533931000f, 0.125009000f),
  float2(0.540738000f, 0.081120000f),
  float2(0.547797000f, 0.052248000f),
  float2(0.555470000f, 0.033091000f),
  float2(0.563711000f, 0.020925000f),
  float2(0.572275000f, 0.013104000f),
  float2(0.580161000f, 0.007722000f),
  float2(0.588088000f, 0.004342000f),
  float2(0.596380000f, 0.002563000f),
  float2(0.603889000f, 0.001511000f),
  float2(0.611831000f, 0.000907000f),
  float2(0.619954000f, 0.000546000f),
  float2(0.627978000f, 0.000332000f),
  float2(0.636807000f, 0.000198000f),
  float2(0.646077000f, 0.000120000f),
  float2(0.655844000f, 0.000074000f),
  float2(0.666621000f, 0.000045000f),
  float2(0.679293000f, 0.000028000f),
  float2(0.692851000f, 0.000017000f),
  float2(0.708852000f, 0.000011000f),
  float2(0.726397000f, 0.000007000f),
  float2(0.746141000f, 0.000005000f),
  float2(0.767738000f, 0.000003000f),
  float2(0.788583000f, 0.000002000f),
  float2(0.810139000f, 0.000001000f),
  float2(0.831629000f, 0.000001000f),
  float2(0.852855000f, 0.000001000f),
  float2(0.871948000f, 0.000001000f),
  float2(0.888841000f, 0.000000000f),
  float2(0.903949000f, 0.000000000f),
  float2(0.917401000f, 0.000000000f),
  float2(0.927421000f, 0.000000000f),
  float2(0.935885000f, 0.000000000f),
  float2(0.943662000f, 0.000000000f),
  float2(0.950920000f, 0.000000000f),
  float2(0.954901000f, 0.000000000f),
  float2(0.958448000f, 0.000000000f),
  float2(0.961871000f, 0.000000000f),
  float2(0.964655000f, 0.000000000f),
  float2(0.966375000f, 0.000000000f),
  float2(0.967596000f, 0.000000000f),
  float2(0.968455000f, 0.000000000f),
  float2(0.969042000f, 0.000000000f),
  float2(0.969394000f, 0.000000000f),
  float2(0.969636000f, 0.000000000f),
  float2(0.969674000f, 0.000000000f),
  float2(0.969676000f, 0.000000000f),
  float2(0.969559000f, 0.000000000f),
  float2(0.969269000f, 0.000000000f),
  float2(0.968966000f, 0.000000000f),
  float2(0.968597000f, 0.000000000f),
  float2(0.968192000f, 0.000000000f),
  float2(0.967755000f, 0.000000000f),
  float2(0.967192000f, 0.000000000f),
  float2(0.966525000f, 0.000000000f),
  float2(0.965860000f, 0.000000000f),
  float2(0.965189000f, 0.000000000f),
  float2(0.964468000f, 0.000000000f),
  float2(0.963785000f, 0.000000000f),
  float2(0.963138000f, 0.000000000f),
  float2(0.962455000f, 0.000000000f),
  float2(0.961723000f, 0.000000000f),
  float2(0.960958000f, 0.000000000f),
  float2(0.960173000f, 0.000000000f),
  float2(0.959345000f, 0.000000000f),
  float2(0.958384000f, 0.000000000f),
  float2(0.957388000f, 0.000000000f),
  float2(0.956387000f, 0.000000000f),
  float2(0.955383000f, 0.000000000f),
  float2(0.954435000f, 0.000000000f),
  float2(0.953603000f, 0.000000000f),
  float2(0.952920000f, 0.000000000f),
};

float RayExitTCIE1702(float2 origin, float2 direction) {
  if (dot(direction, direction) <= MB_NEAR_WHITE_EPSILON) {
    return CIE1702_RAY_T_MAX;
  }

  float2 white_to_origin = CIE1702WhiteChromaticity() - origin;
  float t_best = CIE1702_RAY_T_MAX;
  bool hit_any = false;

  [unroll]
  for (int i = 0; i < CIE1702_EDGE_COUNT; ++i) {
    float2 halfspace_normal = CIE1702_HALFSPACE_NORMALS[i];
    float denom = dot(halfspace_normal, direction);
    float numerator =
        CIE1702_HALFSPACE_NUMERATORS[i] + dot(halfspace_normal, white_to_origin);
    float t = denom > 1e-8f
                  ? numerator * rcp(denom)
                  : CIE1702_RAY_T_MAX;
    t_best = min(t_best, t);
    hit_any = hit_any || (denom > 1e-8f);
  }

  return hit_any ? max(t_best, 0.f) : CIE1702_RAY_T_MAX;
}

float RayExitTCIE1702D(float2 direction) {
  return RayExitTCIE1702(CIE1702WhiteChromaticity(), direction);
}

float RayExitTCIE1702(float2 ls) {
  float2 direction = ls - CIE1702WhiteChromaticity();
  return RayExitTCIE1702(CIE1702WhiteChromaticity(), direction);
}

float Cross2(float2 a, float2 b) {
  return a.x * b.y - a.y * b.x;
}

bool RaySegmentHit2D(float2 origin, float2 direction, float2 a, float2 b, out float t_hit) {
  t_hit = 0.f;
  float2 edge = b - a;
  float denom = Cross2(direction, edge);
  if (abs(denom) <= EPSILON) return false;

  float2 a_origin = a - origin;
  float t = Cross2(a_origin, edge) / denom;
  float u = Cross2(a_origin, direction) / denom;
  if (t < 0.f || u < 0.f || u > 1.f) return false;

  t_hit = t;
  return true;
}

float RayExitTCIE1702Precise(float2 origin, float2 direction) {
  if (dot(direction, direction) <= MB_NEAR_WHITE_EPSILON) {
    return CIE1702_RAY_T_MAX;
  }

  float t_best = CIE1702_RAY_T_MAX;
  bool hit_any = false;

  [loop]
  for (int i = 0; i < CIE1702_BOUNDARY_POINT_COUNT; ++i) {
    int j = i + 1;
    if (j == CIE1702_BOUNDARY_POINT_COUNT) {
      j = 0;
    }

    float t_hit = 0.f;
    if (RaySegmentHit2D(
            origin,
            direction,
            CIE1702_BOUNDARY_LS[i],
            CIE1702_BOUNDARY_LS[j],
            t_hit)) {
      t_best = min(t_best, t_hit);
      hit_any = true;
    }
  }

  return hit_any ? max(t_best, 0.f) : CIE1702_RAY_T_MAX;
}

float RayExitTCIE1702PreciseD(float2 direction) {
  return RayExitTCIE1702Precise(CIE1702WhiteChromaticity(), direction);
}

float2 MBFromWeightedPrimary(float3 weighted_lms_primary) {
  return renodx::color::macleod_boynton::from::WeightedLMS(weighted_lms_primary).xy;
}

float3 RGBToWeightedLMSPrimaryColumn(float3x3 rgb_to_lms_weighted_mat, uint primary_index) {
  return float3(
      rgb_to_lms_weighted_mat[0][primary_index],
      rgb_to_lms_weighted_mat[1][primary_index],
      rgb_to_lms_weighted_mat[2][primary_index]);
}

float3 RGBToAdaptiveWeightedLMSPrimaryColumn(
    float3x3 rgb_to_lms_weighted_mat,
    uint primary_index,
    float3 current_adaptive_state_lms) {
  return RGBToWeightedLMSPrimaryColumn(rgb_to_lms_weighted_mat, primary_index) /
         current_adaptive_state_lms;
}

void MakeRGBTriangleInMBFromWeightedPrimaries(
    float3 weighted_r,
    float3 weighted_g,
    float3 weighted_b,
    out float2 r,
    out float2 g,
    out float2 b) {
  r = MBFromWeightedPrimary(weighted_r);
  g = MBFromWeightedPrimary(weighted_g);
  b = MBFromWeightedPrimary(weighted_b);
}

void MakeRGBTriangleInMBWeighted(
    float3x3 rgb_to_lms_weighted_mat,
    out float2 r,
    out float2 g,
    out float2 b) {
  MakeRGBTriangleInMBFromWeightedPrimaries(
      RGBToWeightedLMSPrimaryColumn(rgb_to_lms_weighted_mat, 0),
      RGBToWeightedLMSPrimaryColumn(rgb_to_lms_weighted_mat, 1),
      RGBToWeightedLMSPrimaryColumn(rgb_to_lms_weighted_mat, 2),
      r,
      g,
      b);
}

void MakeRGBTriangleInMBAdaptiveWeighted(
    float3x3 rgb_to_lms_weighted_mat,
    float3 current_adaptive_state_lms,
    out float2 r,
    out float2 g,
    out float2 b) {
  MakeRGBTriangleInMBFromWeightedPrimaries(
      RGBToAdaptiveWeightedLMSPrimaryColumn(
          rgb_to_lms_weighted_mat, 0, current_adaptive_state_lms),
      RGBToAdaptiveWeightedLMSPrimaryColumn(
          rgb_to_lms_weighted_mat, 1, current_adaptive_state_lms),
      RGBToAdaptiveWeightedLMSPrimaryColumn(
          rgb_to_lms_weighted_mat, 2, current_adaptive_state_lms),
      r,
      g,
      b);
}

float RayMaxT_RGBTriangleInMB(
    float2 origin,
    float2 direction,
    float2 r,
    float2 g,
    float2 b,
    out bool has_solution) {
  has_solution = false;
  if (dot(direction, direction) <= MB_NEAR_WHITE_EPSILON) return 0.f;

  float t_best = INTERVAL_MAX;
  float t_hit;
  bool hit_any = false;

  if (RaySegmentHit2D(origin, direction, r, g, t_hit)) {
    t_best = min(t_best, t_hit);
    hit_any = true;
  }
  if (RaySegmentHit2D(origin, direction, g, b, t_hit)) {
    t_best = min(t_best, t_hit);
    hit_any = true;
  }
  if (RaySegmentHit2D(origin, direction, b, r, t_hit)) {
    t_best = min(t_best, t_hit);
    hit_any = true;
  }

  has_solution = hit_any;
  return hit_any ? max(t_best, 0.f) : 0.f;
}

float NeutwoPeakClip(float x, float peak, float clip) {
  float peak_safe = max(peak, 0.f);
  float clip_safe = max(clip, peak_safe);
  float x2 = x * x;
  float clip2 = clip_safe * clip_safe;
  float peak2 = peak_safe * peak_safe;
  float denominator_squared = mad(x2, (clip2 - peak2), clip2 * peak2);
  return (clip_safe * peak_safe * x) * rsqrt(max(denominator_squared, 1e-20f));
}

float NeutwoScaleFromRayT(float t_peak, float t_clip) {
  float t_peak_safe = max(t_peak, 0.f);
  float t_clip_safe = max(t_clip, t_peak_safe);
  return saturate(NeutwoPeakClip(1.f, t_peak_safe, t_clip_safe));
}

float SoftCompressionActivationFromRayT(float t_peak, float knee = 0.08f) {
  float outside = 1.f - saturate(t_peak);
  return renodx::math::DivideSafe(outside, outside + max(knee, 1e-6f), 0.f);
}

float3 ClampWeightedLMSToCIE1702(float3 lms_weighted_input, float purity_max = 1.f) {
  float3 lms_weighted_clamped = max(lms_weighted_input, 0);
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(lms_weighted_clamped);
  float y_mb = mb.z;
  float2 ls = mb.xy;
  if (!(y_mb > EPSILON)) {
    return float3(lms_weighted_clamped.x, lms_weighted_clamped.y, 0.f);
  }

  float2 mb_white = CIE1702WhiteChromaticity();
  float2 direction = ls - mb_white;
  if (dot(direction, direction) <= MB_NEAR_WHITE_EPSILON) {
    return lms_weighted_clamped;
  }

  float t_clip = RayExitTCIE1702D(direction);
  float t_final = min(1.f, max(purity_max, 0.f) * t_clip);
  float2 ls_out = mb_white + direction * t_final;
  return renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(ls_out, y_mb);
}

float3 ClampWeightedLMSToCIE1702Precise(float3 lms_weighted_input, float purity_max = 1.f) {
  float3 lms_weighted_clamped = max(lms_weighted_input, 0);
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(lms_weighted_clamped);
  float y_mb = mb.z;
  float2 ls = mb.xy;
  if (!(y_mb > EPSILON)) {
    return float3(lms_weighted_clamped.x, lms_weighted_clamped.y, 0.f);
  }

  float2 mb_white = CIE1702WhiteChromaticity();
  float2 direction = ls - mb_white;
  if (dot(direction, direction) <= MB_NEAR_WHITE_EPSILON) {
    return lms_weighted_clamped;
  }

  float t_clip = RayExitTCIE1702PreciseD(direction);
  float t_final = min(1.f, max(purity_max, 0.f) * t_clip);
  float2 ls_out = mb_white + direction * t_final;
  return renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(ls_out, y_mb);
}

float3 GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
    float3 lms_weighted_input,
    float2 bound_r,
    float2 bound_g,
    float2 bound_b,
    float strength) {
  float3 lms_weighted_clamped = ClampWeightedLMSToCIE1702(max(lms_weighted_input, 0));
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(lms_weighted_clamped);
  float y_mb = mb.z;
  float2 ls = mb.xy;
  if (!(y_mb > EPSILON)) {
    return float3(lms_weighted_clamped.x, lms_weighted_clamped.y, 0.f);
  }

  float2 mb_white = CIE1702WhiteChromaticity();
  float2 direction = ls - mb_white;
  if (dot(direction, direction) <= MB_NEAR_WHITE_EPSILON) {
    return lms_weighted_clamped;
  }

  bool has_peak = false;
  float t_peak = RayMaxT_RGBTriangleInMB(
      mb_white, direction, bound_r, bound_g, bound_b, has_peak);
  float t_clip = RayExitTCIE1702D(direction);
  if (!has_peak) {
    t_peak = t_clip;
  }

  float t_hard = saturate(t_peak);
  float t_soft = NeutwoScaleFromRayT(min(t_peak, t_clip), t_clip);
  float soft_mix = saturate(strength) * SoftCompressionActivationFromRayT(t_peak);
  float t_final = lerp(t_hard, t_soft, soft_mix);

  float2 ls_out = mb_white + t_final * direction;
  return renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(ls_out, y_mb);
}

float3 GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
    float3 lms_weighted_input, float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  float2 bound_r;
  float2 bound_g;
  float2 bound_b;
  MakeRGBTriangleInMBWeighted(bound_rgb_to_lms_weighted_mat, bound_r, bound_g, bound_b);
  return GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
      lms_weighted_input,
      bound_r,
      bound_g,
      bound_b,
      strength);
}

float3 GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
    float3 lms_weighted_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  float2 bound_r;
  float2 bound_g;
  float2 bound_b;
  MakeRGBTriangleInMBAdaptiveWeighted(
      bound_rgb_to_lms_weighted_mat,
      current_adaptive_state_lms,
      bound_r,
      bound_g,
      bound_b);
  return GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
      lms_weighted_input,
      bound_r,
      bound_g,
      bound_b,
      strength);
}

float3 GamutCompressWeightedLMSCoreRGBBoundFromWeightedInputPrecise(
    float3 lms_weighted_input,
    float2 bound_r,
    float2 bound_g,
    float2 bound_b,
    float strength) {
  float3 lms_weighted_clamped = ClampWeightedLMSToCIE1702Precise(max(lms_weighted_input, 0));
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(lms_weighted_clamped);
  float y_mb = mb.z;
  float2 ls = mb.xy;
  if (!(y_mb > EPSILON)) {
    return float3(lms_weighted_clamped.x, lms_weighted_clamped.y, 0.f);
  }

  float2 mb_white = CIE1702WhiteChromaticity();
  float2 direction = ls - mb_white;
  if (dot(direction, direction) <= MB_NEAR_WHITE_EPSILON) {
    return lms_weighted_clamped;
  }

  bool has_peak = false;
  float t_peak = RayMaxT_RGBTriangleInMB(
      mb_white, direction, bound_r, bound_g, bound_b, has_peak);
  float t_clip = RayExitTCIE1702PreciseD(direction);
  if (!has_peak) {
    t_peak = t_clip;
  }

  float t_hard = saturate(t_peak);
  float t_soft = NeutwoScaleFromRayT(min(t_peak, t_clip), t_clip);
  float soft_mix = saturate(strength) * SoftCompressionActivationFromRayT(t_peak);
  float t_final = lerp(t_hard, t_soft, soft_mix);

  float2 ls_out = mb_white + t_final * direction;

  return renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(ls_out, y_mb);
}

float3 GamutCompressWeightedLMSCoreRGBBoundFromWeightedInputPrecise(
    float3 lms_weighted_input, float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  float2 bound_r;
  float2 bound_g;
  float2 bound_b;
  MakeRGBTriangleInMBWeighted(bound_rgb_to_lms_weighted_mat, bound_r, bound_g, bound_b);
  return GamutCompressWeightedLMSCoreRGBBoundFromWeightedInputPrecise(
      lms_weighted_input,
      bound_r,
      bound_g,
      bound_b,
      strength);
}

float3 GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInputPrecise(
    float3 lms_weighted_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  float2 bound_r;
  float2 bound_g;
  float2 bound_b;
  MakeRGBTriangleInMBAdaptiveWeighted(
      bound_rgb_to_lms_weighted_mat,
      current_adaptive_state_lms,
      bound_r,
      bound_g,
      bound_b);
  return GamutCompressWeightedLMSCoreRGBBoundFromWeightedInputPrecise(
      lms_weighted_input,
      bound_r,
      bound_g,
      bound_b,
      strength);
}

float3 GamutCompressLMS(float3 lms_input, float strength = 1.f) {
  float3 lms_weighted_input = renodx::color::macleod_boynton::WeighLMS(lms_input);
  float3 lms_weighted_clamped = max(lms_weighted_input, 0);
  float3 lms_weighted_out = lerp(
      lms_weighted_clamped,
      ClampWeightedLMSToCIE1702(lms_weighted_clamped),
      saturate(strength));
  return renodx::color::macleod_boynton::UnweighLMS(lms_weighted_out);
}

float3 GamutCompressLMSPrecise(float3 lms_input, float strength = 1.f) {
  float3 lms_weighted_input = renodx::color::macleod_boynton::WeighLMS(lms_input);
  float3 lms_weighted_clamped = max(lms_weighted_input, 0);
  float3 lms_weighted_out = lerp(
      lms_weighted_clamped,
      ClampWeightedLMSToCIE1702Precise(lms_weighted_clamped),
      saturate(strength));
  return renodx::color::macleod_boynton::UnweighLMS(lms_weighted_out);
}

float3 GamutCompressLMSBoundBT709(float3 lms_input, float strength = 1.f) {
  float3 lms_weighted_input = renodx::color::macleod_boynton::WeighLMS(lms_input);
  float3 lms_weighted_out = GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
      lms_weighted_input, renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT, strength);
  return renodx::color::macleod_boynton::UnweighLMS(lms_weighted_out);
}

float3 GamutCompressLMSBoundBT709Precise(float3 lms_input, float strength = 1.f) {
  float3 lms_weighted_input = renodx::color::macleod_boynton::WeighLMS(lms_input);
  float3 lms_weighted_out = GamutCompressWeightedLMSCoreRGBBoundFromWeightedInputPrecise(
      lms_weighted_input, renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT, strength);
  return renodx::color::macleod_boynton::UnweighLMS(lms_weighted_out);
}

float3 GamutCompressLMSBoundBT2020(float3 lms_input, float strength = 1.f) {
  float3 lms_weighted_input = renodx::color::macleod_boynton::WeighLMS(lms_input);
  float3 lms_weighted_out = GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
      lms_weighted_input, renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT, strength);
  return renodx::color::macleod_boynton::UnweighLMS(lms_weighted_out);
}

float3 GamutCompressLMSBoundBT2020Precise(float3 lms_input, float strength = 1.f) {
  float3 lms_weighted_input = renodx::color::macleod_boynton::WeighLMS(lms_input);
  float3 lms_weighted_out = GamutCompressWeightedLMSCoreRGBBoundFromWeightedInputPrecise(
      lms_weighted_input, renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT, strength);
  return renodx::color::macleod_boynton::UnweighLMS(lms_weighted_out);
}

float3 GamutCompressBT709(float3 bt709_input, float strength = 1.f) {
  float3 lms_weighted_out = GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
      mul(renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT, bt709_input),
      renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
      strength);
  return mul(renodx::color::macleod_boynton::LMS_WEIGHTED_TO_BT709_MAT, lms_weighted_out);
}

float3 GamutCompressBT709Precise(float3 bt709_input, float strength = 1.f) {
  float3 lms_weighted_out = GamutCompressWeightedLMSCoreRGBBoundFromWeightedInputPrecise(
      mul(renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT, bt709_input),
      renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
      strength);
  return mul(renodx::color::macleod_boynton::LMS_WEIGHTED_TO_BT709_MAT, lms_weighted_out);
}

float3 GamutCompressBT2020(float3 bt2020_input, float strength = 1.f) {
  float3 lms_weighted_out = GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
      mul(renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT, bt2020_input),
      renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
      strength);
  return mul(renodx::color::macleod_boynton::LMS_WEIGHTED_TO_BT2020_MAT, lms_weighted_out);
}

float3 GamutCompressBT2020Precise(float3 bt2020_input, float strength = 1.f) {
  float3 lms_weighted_out = GamutCompressWeightedLMSCoreRGBBoundFromWeightedInputPrecise(
      mul(renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT, bt2020_input),
      renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
      strength);
  return mul(renodx::color::macleod_boynton::LMS_WEIGHTED_TO_BT2020_MAT, lms_weighted_out);
}

}  // namespace gamut
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_GAMUT_HLSL_
