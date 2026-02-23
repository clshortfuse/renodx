#ifndef SRC_SHADERS_COLOR_MACLEOD_BOYNTON_HLSL_
#define SRC_SHADERS_COLOR_MACLEOD_BOYNTON_HLSL_

#include "./shared.h"

namespace renodx_custom {
namespace color {
namespace macleod_boynton {

// MacLeod-Boynton purity model in RGB gamut space.
//
// Core idea:
// 1) Convert RGB -> XYZ -> LMS.
// 2) Represent hue as MB ratios at fixed T = L + M.
// 3) Move along the MB ray from adapted white toward the input hue.
// 4) Solve exactly where that ray intersects the selected RGB gamut boundary.
//
// This gives a saturation/purity control that is geometrically bounded by gamut,
// instead of scaling perceptual coordinates and clipping later.
//
// Reference material:
// - MacLeod & Boynton (1979), MB chromaticity:
//   https://pubmed.ncbi.nlm.nih.gov/490231/
// - Derrington, Krauskopf, Lennie (1984), DKL axes:
//   https://pubmed.ncbi.nlm.nih.gov/6512691/
// - Stockman & Sharpe (2000), cone fundamentals:
//   https://pubmed.ncbi.nlm.nih.gov/10814758/
// - CIE 170-1:2006 (physiological axes / LMS standardization context):
//   https://cie.co.at/publications/fundamental-chromaticity-diagram-physiological-axes-part-1
// - ITU-R BT.709-6 (HDTV primaries / transfer context):
//   https://www.itu.int/rec/R-REC-BT.709-6-201506-I
// - ITU-R BT.2020-2 (UHDTV wide-gamut primaries):
//   https://www.itu.int/rec/R-REC-BT.2020-2-201510-I/en
//
// Comparison context from discussion:
// - Oklab (Ottosson): https://bottosson.github.io/posts/oklab/
// - Oklab critique (Levien): https://raphlinus.github.io/color/2021/01/18/oklab-critique.html
static const float3x3 XYZ_TO_LMS_2006 = float3x3(
    0.185082982238733f, 0.584081279463687f, -0.0240722415044404f,
    -0.134433056469973f, 0.405752392775348f, 0.0358252602217631f,
    0.000789456671966863f, -0.000912281325916184f, 0.0198490812339463f);

static const float3x3 LMS_TO_XYZ_2006 = renodx::math::Invert3x3(XYZ_TO_LMS_2006);

static const float EPSILON = 1e-20f;
static const float INTERVAL_MAX = 1e30f;
static const float MB_NEAR_WHITE_EPSILON = 1e-14f;

static const int MB_PURITY_MODE_DISTANCE = 0;
static const int MB_PURITY_MODE_NORMALIZED = 1;
static const int MB_PURITY_MODE_SCALE_NEUTWO = 2;
static const int MB_PURITY_ADJUST_NONE = 0;
static const int MB_PURITY_ADJUST_CLIP_MAX = 1;
static const float ONE_MINUS_EPSILON = 1.f - 1e-6f;

// Neutwo (x / sqrt(x^2 + 1)) and its inverse.
// Used to shape purity scaling with a smooth shoulder near gamut edge.
float Neutwo(float x) {
  float denominator_squared = mad(x, x, 1.f);
  return x * rsqrt(denominator_squared);
}

float InverseNeutwo(float x) {
  float clamped = min(max(x, 0.f), ONE_MINUS_EPSILON);
  float denominator_squared = mad(-clamped, clamped, 1.f);
  return clamped * rsqrt(denominator_squared);
}

// MB coordinate from LMS.
// r = L / (L + M), b = S / (L + M)
// T = (L + M) is intensity anchor and is preserved while changing purity.
float2 MB_From_LMS(float3 lms) {
  float t = lms.x + lms.y;

  if (t <= 0.f) {
    return float2(0.f, 0.f);
  }

  return float2(
      renodx::math::DivideSafe(lms.x, t, 0.f),
      renodx::math::DivideSafe(lms.z, t, 0.f));
}

// Reconstruct LMS from MB coordinates while holding T = L + M fixed.
float3 LMS_From_MB_T(float2 mb, float t) {
  float r = mb.x;
  float b = mb.y;
  return float3(r * t, (1.f - r) * t, b * t);
}

// Default adaptation white in MB space.
float2 MB_White_D65() {
  float3 d65_xyz = renodx::color::xyz::from::xyY(float3(renodx::color::WHITE_POINT_D65, 1.f));
  float3 d65_lms = mul(XYZ_TO_LMS_2006, d65_xyz);
  return MB_From_LMS(d65_lms);
}

// Half-space constraint for one channel in affine form:
// rgb(t) = a * t + b, and we require rgb(t) >= 0.
// Returns interval [lo, hi] where that channel is valid.
void IntervalLower0(float a, float b, out float lo, out float hi) {
  if (abs(a) < EPSILON) {
    if (b >= 0.f) {
      lo = -INTERVAL_MAX;
      hi = INTERVAL_MAX;
    } else {
      lo = 1.f;
      hi = 0.f;
    }
    return;
  }

  float t0 = renodx::math::DivideSafe(-b, a, 0.f);

  if (a > 0.f) {
    lo = t0;
    hi = INTERVAL_MAX;
  } else {
    lo = -INTERVAL_MAX;
    hi = t0;
  }
}

struct MBPurityDebug {
  float3 rgbOut;
  float3 rgbT0;
  float3 rgbEdgeGamut;

  // Max reachable t before first channel becomes negative.
  float tMaxGamut;
  // Applied t after user control mapping.
  float tFinal;

  // Purity for input color in normalized 0..1 form (1 / tMax for input at t=1).
  float purityCur01;
  // Requested normalized purity (user input).
  float purity01_in;
  // Effective normalized purity after shaping curve.
  float purity01_used;
};

// Main solver.
//
// There are three control modes:
// - purity_input_mode == MB_PURITY_MODE_NORMALIZED:
//     purity_value is 0..1 "fraction of available purity headroom".
// - purity_input_mode == MB_PURITY_MODE_DISTANCE:
//     purity_value is direct MB ray distance t.
// - purity_input_mode == MB_PURITY_MODE_SCALE_NEUTWO:
//     purity_value is a scale multiplier in Neutwo inverse space (1 = unchanged).
//
// Optional adjust mode:
// - MB_PURITY_ADJUST_NONE:
//     use selected input mode as-is.
// - MB_PURITY_ADJUST_CLIP_MAX:
//     force max purity for this hue/gamut (tFinal = tMaxGamut).
//
// Important behavior:
// - Constraint is gamut-only (RGB >= 0), no arbitrary <= 1 clamp.
// - This allows scene-linear HDR values above 1.0 to pass through naturally.
MBPurityDebug ApplyInternal(float3 rgb_linear, float purity_value, int purity_input_mode,
                            float curve_gamma, float2 mb_white_override, float t_min,
                            int purity_adjust_mode, float3x3 rgb_to_xyz_mat, float3x3 xyz_to_rgb_mat) {
  MBPurityDebug output;

  output.purity01_in = 0.f;

  // 1) RGB -> XYZ -> LMS
  float3 xyz = mul(rgb_to_xyz_mat, rgb_linear);
  float3 lms = mul(XYZ_TO_LMS_2006, xyz);

  // T = L + M is the intensity anchor for MB purity moves.
  float t = lms.x + lms.y;

  if (t <= t_min) {
    output.rgbOut = rgb_linear;
    output.rgbT0 = rgb_linear;
    output.rgbEdgeGamut = rgb_linear;
    output.tMaxGamut = 0.f;
    output.purityCur01 = 0.f;
    output.purity01_used = 0.f;
    return output;
  }

  float2 white =
      (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f) ? mb_white_override : MB_White_D65();

  // 2) MB ray from adapted white to input hue.
  float2 mb0 = MB_From_LMS(lms);
  float2 direction = mb0 - white;

  if (dot(direction, direction) < MB_NEAR_WHITE_EPSILON) {
    output.rgbOut = rgb_linear;
    output.rgbT0 = rgb_linear;
    output.rgbEdgeGamut = rgb_linear;
    output.tMaxGamut = 0.f;
    output.tFinal = 0.f;
    output.purityCur01 = 0.f;
    output.purity01_used = 0.f;
    return output;
  }

  float3 lms_t0 = LMS_From_MB_T(white, t);
  float3 xyz_t0 = mul(LMS_TO_XYZ_2006, lms_t0);
  float3 rgb_t0 = mul(xyz_to_rgb_mat, xyz_t0);
  output.rgbT0 = rgb_t0;

  // 4) Affine form of RGB along the MB ray at fixed T.
  // t = 0 -> white in MB space, t = 1 -> original input.
  float3 a = rgb_linear - rgb_t0;

  // 5) Intersect channel constraints RGB(t) >= 0 across R,G,B.
  float t_lo = 0.f;
  float t_hi = INTERVAL_MAX;

  float lo;
  float hi;

  IntervalLower0(a.x, rgb_t0.x, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  IntervalLower0(a.y, rgb_t0.y, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  IntervalLower0(a.z, rgb_t0.z, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  if (t_hi < t_lo) {
    output.rgbOut = max(rgb_linear, 0.f);
    output.rgbEdgeGamut = rgb_t0;
    output.tMaxGamut = 0.f;
    output.tFinal = 0.f;
    output.purityCur01 = 0.f;
    output.purity01_used = 0.f;
    return output;
  }

  float t_max = max(0.f, t_hi);
  output.tMaxGamut = t_max;

  // Current normalized purity for the input (which is at t = 1).
  float p_cur = (t_max > EPSILON) ? renodx::math::DivideSafe(1.f, t_max, 0.f) : 0.f;
  output.purityCur01 = saturate(p_cur);

  // Useful validation output: point on the gamut edge for this MB ray.
  float3 rgb_edge = a * t_max + rgb_t0;
  output.rgbEdgeGamut = rgb_edge;

  float t_final = 0.f;

  if (purity_adjust_mode == MB_PURITY_ADJUST_CLIP_MAX) {
    output.purity01_used = 1.f;
    output.purity01_in = 1.f;
    t_final = t_max;
  } else {
    if (purity_input_mode == MB_PURITY_MODE_NORMALIZED) {
      // Normalized mode: user operates in [0,1] of available gamut headroom.
      output.purity01_in = saturate(purity_value);
      float gamma = max(curve_gamma, 1e-6f);
      float purity01 = pow(output.purity01_in, gamma);
      output.purity01_used = purity01;
      t_final = purity01 * t_max;
    } else if (purity_input_mode == MB_PURITY_MODE_SCALE_NEUTWO) {
      // Scale mode: user controls a saturation multiplier around current purity.
      // 1 = no change, >1 increases, <1 decreases, with a smooth shoulder near edge.
      float saturation_scale = max(purity_value, 0.f);
      float purity01_target;
      if (output.purityCur01 >= ONE_MINUS_EPSILON && saturation_scale >= 1.f) {
        purity01_target = 1.f;
      } else {
        float z = InverseNeutwo(output.purityCur01);
        float z_scaled = z * saturation_scale;
        purity01_target = saturate(Neutwo(z_scaled));
      }
      output.purity01_in = output.purityCur01;
      output.purity01_used = purity01_target;
      t_final = purity01_target * t_max;
    } else {
      // Distance mode: user value is interpreted as MB ray distance t.
      float t_user = max(purity_value, 0.f);
      t_final = min(t_user, t_max);
      output.purity01_used =
          (t_max > EPSILON) ? saturate(renodx::math::DivideSafe(t_final, t_max, 0.f)) : 0.f;
      output.purity01_in = output.purity01_used;
    }
  }

  output.tFinal = t_final;

  float2 mb_final = white + t_final * direction;

  float3 lms_final = LMS_From_MB_T(mb_final, t);
  float3 xyz_final = mul(LMS_TO_XYZ_2006, lms_final);
  float3 rgb_final = mul(xyz_to_rgb_mat, xyz_final);

  // Clean up float math
  output.rgbOut = max(rgb_final, 0.f);

  return output;
}

MBPurityDebug ApplyBT709(float3 rgb709_linear, float purity01, float curve_gamma = 1.f,
                         float2 mb_white_override = float2(-1.f, -1.f), float t_min = 1e-6f,
                         int purity_adjust_mode = MB_PURITY_ADJUST_NONE) {
  return ApplyInternal(rgb709_linear, purity01, MB_PURITY_MODE_NORMALIZED, curve_gamma,
                       mb_white_override, t_min, purity_adjust_mode, renodx::color::BT709_TO_XYZ_MAT,
                       renodx::color::XYZ_TO_BT709_MAT);
}

MBPurityDebug ApplyBT2020(float3 rgb2020_linear, float purity01, float curve_gamma = 1.f,
                          float2 mb_white_override = float2(-1.f, -1.f), float t_min = 1e-6f,
                          int purity_adjust_mode = MB_PURITY_ADJUST_NONE) {
  return ApplyInternal(rgb2020_linear, purity01, MB_PURITY_MODE_NORMALIZED, curve_gamma,
                       mb_white_override, t_min, purity_adjust_mode, renodx::color::BT2020_TO_XYZ_MAT,
                       renodx::color::XYZ_TO_BT2020_MAT);
}

MBPurityDebug ApplyScaleBT709(float3 rgb709_linear, float saturation_scale,
                              float2 mb_white_override = float2(-1.f, -1.f), float t_min = 1e-6f,
                              int purity_adjust_mode = MB_PURITY_ADJUST_NONE) {
  return ApplyInternal(rgb709_linear, saturation_scale, MB_PURITY_MODE_SCALE_NEUTWO, 1.f,
                       mb_white_override, t_min, purity_adjust_mode, renodx::color::BT709_TO_XYZ_MAT,
                       renodx::color::XYZ_TO_BT709_MAT);
}

MBPurityDebug ApplyScaleBT2020(float3 rgb2020_linear, float saturation_scale,
                               float2 mb_white_override = float2(-1.f, -1.f), float t_min = 1e-6f,
                               int purity_adjust_mode = MB_PURITY_ADJUST_NONE) {
  return ApplyInternal(rgb2020_linear, saturation_scale, MB_PURITY_MODE_SCALE_NEUTWO, 1.f,
                       mb_white_override, t_min, purity_adjust_mode, renodx::color::BT2020_TO_XYZ_MAT,
                       renodx::color::XYZ_TO_BT2020_MAT);
}

float3 BT709(float3 rgb709_linear, float purity_scale, float2 mb_white) {
  return ApplyInternal(rgb709_linear, purity_scale, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, 0.f,
                       MB_PURITY_ADJUST_NONE, renodx::color::BT709_TO_XYZ_MAT, renodx::color::XYZ_TO_BT709_MAT)
      .rgbOut;
}

float3 BT2020(float3 rgb2020_linear, float purity_scale, float2 mb_white) {
  return ApplyInternal(rgb2020_linear, purity_scale, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, 0.f,
                       MB_PURITY_ADJUST_NONE, renodx::color::BT2020_TO_XYZ_MAT, renodx::color::XYZ_TO_BT2020_MAT)
      .rgbOut;
}

// Explicit max-purity helpers for testing.
float3 BT709MaxPurity(float3 rgb709_linear, float2 mb_white) {
  return ApplyInternal(rgb709_linear, 0.f, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, 0.f,
                       MB_PURITY_ADJUST_CLIP_MAX, renodx::color::BT709_TO_XYZ_MAT, renodx::color::XYZ_TO_BT709_MAT)
      .rgbOut;
}

float3 BT2020MaxPurity(float3 rgb2020_linear, float2 mb_white) {
  return ApplyInternal(rgb2020_linear, 0.f, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, 0.f,
                       MB_PURITY_ADJUST_CLIP_MAX, renodx::color::BT2020_TO_XYZ_MAT, renodx::color::XYZ_TO_BT2020_MAT)
      .rgbOut;
}

// Gamut compression in MB space:
// Use the white->hue MB ray and clamp t to at most 1.0 (input point).
// - If already in gamut, color is unchanged.
// - If out of gamut, color moves toward MB white until it hits gamut edge.
float3 GamutCompressBT709(float3 rgb709_linear, float2 mb_white = float2(-1.f, -1.f),
                          float t_min = 1e-6f) {
  return ApplyInternal(rgb709_linear, 1.f, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, t_min,
                       MB_PURITY_ADJUST_NONE, renodx::color::BT709_TO_XYZ_MAT, renodx::color::XYZ_TO_BT709_MAT)
      .rgbOut;
}

float3 GamutCompressBT2020(float3 rgb2020_linear, float2 mb_white = float2(-1.f, -1.f),
                           float t_min = 1e-6f) {
  return ApplyInternal(rgb2020_linear, 1.f, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, t_min,
                       MB_PURITY_ADJUST_NONE, renodx::color::BT2020_TO_XYZ_MAT, renodx::color::XYZ_TO_BT2020_MAT)
      .rgbOut;
}

// MB-space gamut compression with additive white in LMS.
// Derivation:
// - Let t_max be the white->input MB ray limit (input is at t=1).
// - To move input toward white to exactly t_max, MB blend weight is a = 1 - t_max.
// - Adding white in LMS with MB unit-T white vector gives:
//     white_add = T * a / (1 - a) = T * (1 - t_max) / t_max
//   where T = L + M of input.
// This preserves MB hue direction while compressing out-of-gamut colors by "adding white".
float3 GamutCompressAddWhiteInternal(float3 rgb_linear, float2 mb_white_override, float t_min,
                                     float3x3 rgb_to_xyz_mat, float3x3 xyz_to_rgb_mat) {
  float3 xyz = mul(rgb_to_xyz_mat, rgb_linear);
  float3 lms = mul(XYZ_TO_LMS_2006, xyz);
  float t = lms.x + lms.y;

  if (t <= t_min) {
    return max(rgb_linear, 0.f);
  }

  float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                     ? mb_white_override
                     : MB_White_D65();

  float2 mb0 = MB_From_LMS(lms);
  float2 direction = mb0 - white;
  if (dot(direction, direction) < MB_NEAR_WHITE_EPSILON) {
    return max(rgb_linear, 0.f);
  }

  float3 lms_t0 = LMS_From_MB_T(white, t);
  float3 xyz_t0 = mul(LMS_TO_XYZ_2006, lms_t0);
  float3 rgb_t0 = mul(xyz_to_rgb_mat, xyz_t0);
  float3 ray_a = rgb_linear - rgb_t0;

  float t_lo = 0.f;
  float t_hi = INTERVAL_MAX;
  float lo;
  float hi;

  IntervalLower0(ray_a.x, rgb_t0.x, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  IntervalLower0(ray_a.y, rgb_t0.y, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  IntervalLower0(ray_a.z, rgb_t0.z, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  if (t_hi < t_lo) {
    return max(rgb_linear, 0.f);
  }

  float t_max = max(0.f, t_hi);
  float white_ratio = max(renodx::math::DivideSafe(1.f - t_max, t_max, 0.f), 0.f);
  float white_add = t * white_ratio;

  // MB unit-T white vector in LMS (T = L+M = 1).
  float3 white_unit_lms = LMS_From_MB_T(white, 1.f);
  float3 lms_out = lms + white_unit_lms * white_add;
  float3 xyz_out = mul(LMS_TO_XYZ_2006, lms_out);
  float3 rgb_out = mul(xyz_to_rgb_mat, xyz_out);
  return max(rgb_out, 0.f);
}

float3 GamutCompressAddWhiteBT709(float3 rgb709_linear, float2 mb_white = float2(-1.f, -1.f),
                                  float t_min = 1e-6f) {
  return GamutCompressAddWhiteInternal(rgb709_linear, mb_white, t_min, renodx::color::BT709_TO_XYZ_MAT,
                                       renodx::color::XYZ_TO_BT709_MAT);
}

float3 GamutCompressAddWhiteBT2020(float3 rgb2020_linear, float2 mb_white = float2(-1.f, -1.f),
                                   float t_min = 1e-6f) {
  return GamutCompressAddWhiteInternal(rgb2020_linear, mb_white, t_min, renodx::color::BT2020_TO_XYZ_MAT,
                                       renodx::color::XYZ_TO_BT2020_MAT);
}

}  // namespace macleod_boynton
}  // namespace color
}  // namespace renodx

float3 ApplyPurityOnlyMBToBT709(
    float3 target_color_bt2020,
    float purity01,
    float curve_gamma,
    float2 mb_white_override,
    float t_min) {
  return renodx::color::bt709::from::BT2020(
      renodx_custom::color::macleod_boynton::ApplyBT2020(
          target_color_bt2020, purity01, curve_gamma, mb_white_override, t_min)
          .rgbOut);
}

// Purity-only MB solve:
// Computes the same purityCur01 as ApplyBT2020(...).purityCur01, but skips final RGB reconstruction.
float Purity01FromBT2020MB(
    float3 rgb2020_linear,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f) {
  float3 xyz = mul(renodx::color::BT2020_TO_XYZ_MAT, rgb2020_linear);
  float3 lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006, xyz);
  float t = lms.x + lms.y;
  if (t <= t_min) return 0.f;

  float2 white =
      (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
          ? mb_white_override
          : renodx_custom::color::macleod_boynton::MB_White_D65();

  float2 mb0 = renodx_custom::color::macleod_boynton::MB_From_LMS(lms);
  float2 direction = mb0 - white;
  if (dot(direction, direction) < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) return 0.f;

  float3 lms_t0 = renodx_custom::color::macleod_boynton::LMS_From_MB_T(white, t);
  float3 xyz_t0 = mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006, lms_t0);
  float3 rgb_t0 = mul(renodx::color::XYZ_TO_BT2020_MAT, xyz_t0);
  float3 a = rgb2020_linear - rgb_t0;

  float t_lo = 0.f;
  float t_hi = renodx_custom::color::macleod_boynton::INTERVAL_MAX;
  float lo;
  float hi;

  renodx_custom::color::macleod_boynton::IntervalLower0(a.x, rgb_t0.x, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  renodx_custom::color::macleod_boynton::IntervalLower0(a.y, rgb_t0.y, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  renodx_custom::color::macleod_boynton::IntervalLower0(a.z, rgb_t0.z, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  if (t_hi < t_lo) return 0.f;

  float t_max = max(0.f, t_hi);
  float p_cur = (t_max > renodx_custom::color::macleod_boynton::EPSILON)
                    ? renodx::math::DivideSafe(1.f, t_max, 0.f)
                    : 0.f;
  return saturate(p_cur);
}

float3 CorrectPurityMBBT709WithBT2020(
    float3 target_color_bt709,
    float3 purity_reference_bt709,
    float strength = 1.f,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f,
    float clamp_purity_loss = 0.f) {
  if (strength <= 0.f) return target_color_bt709;

  float3 target_color_bt2020 = renodx::color::bt2020::from::BT709(target_color_bt709);
  float3 purity_reference_bt2020 = renodx::color::bt2020::from::BT709(purity_reference_bt709);

  float reference_purity01 =
      renodx_custom::color::macleod_boynton::ApplyBT2020(purity_reference_bt2020, 1.f, 1.f,
                                                         mb_white_override, t_min)
          .purityCur01;

  float applied_purity01;
  if (strength == 1.f && clamp_purity_loss <= 0.f) {
    // Fast path: full transfer only needs donor purity.
    applied_purity01 = reference_purity01;
  } else {
    float target_purity01 =
        renodx_custom::color::macleod_boynton::ApplyBT2020(target_color_bt2020, 1.f, 1.f,
                                                           mb_white_override, t_min)
            .purityCur01;

    applied_purity01 = lerp(target_purity01, reference_purity01, strength);

    if (clamp_purity_loss > 0.f) {
      float clamp_strength = saturate(clamp_purity_loss);
      // Only clamp purity reductions: if applied < target, pull back toward target.
      float t = 1.f - step(target_purity01, applied_purity01);
      applied_purity01 = lerp(applied_purity01, target_purity01, t * clamp_strength);
    }
  }

  return renodx::color::bt709::from::BT2020(
      renodx_custom::color::macleod_boynton::ApplyBT2020(
          target_color_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
          .rgbOut);
}

float3 CorrectHueAndPurityMBBT709WithBT2020(
    float3 target_color_bt709,
    float3 reference_color_bt709,
    float hue_strength = 1.f,
    float purity_strength = 1.f,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f) {
  if (purity_strength <= 0.f && hue_strength <= 0.f) {
    return target_color_bt709;
  }

  if (hue_strength <= 0.f) {
    return CorrectPurityMBBT709WithBT2020(target_color_bt709, reference_color_bt709, purity_strength, curve_gamma,
                                          mb_white_override, t_min);
  }

  float3 target_color_bt2020 = renodx::color::bt2020::from::BT709(target_color_bt709);
  float3 reference_color_bt2020 = renodx::color::bt2020::from::BT709(reference_color_bt709);

  float3 target_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                          mul(renodx::color::BT2020_TO_XYZ_MAT, target_color_bt2020));
  float target_t = target_lms.x + target_lms.y;
  if (target_t <= t_min) {
    return target_color_bt709;
  }

  float hue_blend = saturate(hue_strength);

  if (hue_blend <= 0.f) {
    return CorrectPurityMBBT709WithBT2020(target_color_bt709, reference_color_bt709, purity_strength, curve_gamma,
                                          mb_white_override, t_min);
  }

  float target_purity01 =
      renodx_custom::color::macleod_boynton::ApplyBT2020(target_color_bt2020, 1.f, 1.f,
                                                         mb_white_override, t_min)
          .purityCur01;
  float applied_purity01 = target_purity01;
  if (purity_strength > 0.f) {
    float reference_purity01 =
        renodx_custom::color::macleod_boynton::ApplyBT2020(reference_color_bt2020, 1.f, 1.f,
                                                           mb_white_override, t_min)
            .purityCur01;
    applied_purity01 = lerp(target_purity01, reference_purity01, saturate(purity_strength));
  }

  float3 reference_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                             mul(renodx::color::BT2020_TO_XYZ_MAT, reference_color_bt2020));

  float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                     ? mb_white_override
                     : renodx_custom::color::macleod_boynton::MB_White_D65();

  float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - white;
  float2 reference_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_lms) - white;

  float target_len_sq = dot(target_direction, target_direction);
  float reference_len_sq = dot(reference_direction, reference_direction);

  if (target_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON && reference_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    return CorrectPurityMBBT709WithBT2020(target_color_bt709, reference_color_bt709, purity_strength, curve_gamma,
                                          mb_white_override, t_min);
  }

  float2 target_unit = (target_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                           ? target_direction * rsqrt(target_len_sq)
                           : float2(0.f, 0.f);
  float2 reference_unit = (reference_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                              ? reference_direction * rsqrt(reference_len_sq)
                              : target_unit;
  if (target_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    target_unit = reference_unit;
  }

  float2 blended_unit = lerp(target_unit, reference_unit, hue_blend);
  float blended_len_sq = dot(blended_unit, blended_unit);
  if (blended_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    blended_unit = (hue_blend >= 0.5f) ? reference_unit : target_unit;
    blended_len_sq = dot(blended_unit, blended_unit);
  }
  blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));

  float seed_len = sqrt(max(target_len_sq, 0.f));
  if (seed_len <= 1e-6f) {
    seed_len = sqrt(max(reference_len_sq, 0.f));
  }
  seed_len = max(seed_len, 1e-6f);

  float3 seed_bt2020 = mul(
      renodx::color::XYZ_TO_BT2020_MAT,
      mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006,
          renodx_custom::color::macleod_boynton::LMS_From_MB_T(white + blended_unit * seed_len, target_t)));

  return renodx::color::bt709::from::BT2020(
      renodx_custom::color::macleod_boynton::ApplyBT2020(
          seed_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
          .rgbOut);
}

float3 CorrectHueAndPurityMB_BT2020(
    float3 target_color_bt2020,
    float3 reference_color_bt2020,
    float hue_strength = 1.f,
    float purity_strength = 1.f,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-7f) {
  if (purity_strength <= 0.f && hue_strength <= 0.f) {
    return target_color_bt2020;
  }

  float applied_purity01 = lerp(
      renodx_custom::color::macleod_boynton::ApplyBT2020(target_color_bt2020, 1.f, 1.f,
                                                         mb_white_override, t_min)
          .purityCur01,
      renodx_custom::color::macleod_boynton::ApplyBT2020(reference_color_bt2020, 1.f, 1.f,
                                                         mb_white_override, t_min)
          .purityCur01,
      saturate(purity_strength));

  if (hue_strength <= 0.f) {
    return renodx_custom::color::macleod_boynton::ApplyBT2020(
               target_color_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
        .rgbOut;
  }

  float3 target_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                          mul(renodx::color::BT2020_TO_XYZ_MAT, target_color_bt2020));
  float target_t = target_lms.x + target_lms.y;
  if (target_t <= t_min) {
    return target_color_bt2020;
  }

  float hue_blend = saturate(hue_strength);

  if (hue_blend <= 0.f) {
    return renodx_custom::color::macleod_boynton::ApplyBT2020(
               target_color_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
        .rgbOut;
  }

  float3 reference_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                             mul(renodx::color::BT2020_TO_XYZ_MAT, reference_color_bt2020));

  float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                     ? mb_white_override
                     : renodx_custom::color::macleod_boynton::MB_White_D65();

  float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - white;
  float2 reference_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_lms) - white;

  float target_len_sq = dot(target_direction, target_direction);
  float reference_len_sq = dot(reference_direction, reference_direction);

  if (target_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON && reference_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    return renodx_custom::color::macleod_boynton::ApplyBT2020(
               target_color_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
        .rgbOut;
  }

  float2 target_unit = (target_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                           ? target_direction * rsqrt(target_len_sq)
                           : float2(0.f, 0.f);
  float2 reference_unit = (reference_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                              ? reference_direction * rsqrt(reference_len_sq)
                              : target_unit;
  if (target_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    target_unit = reference_unit;
  }

  float2 blended_unit = lerp(target_unit, reference_unit, hue_blend);
  float blended_len_sq = dot(blended_unit, blended_unit);
  if (blended_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    blended_unit = (hue_blend >= 0.5f) ? reference_unit : target_unit;
    blended_len_sq = dot(blended_unit, blended_unit);
  }
  blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));

  float seed_len = sqrt(max(target_len_sq, 0.f));
  if (seed_len <= 1e-6f) {
    seed_len = sqrt(max(reference_len_sq, 0.f));
  }
  seed_len = max(seed_len, 1e-6f);

  float3 seed_bt2020 = mul(
      renodx::color::XYZ_TO_BT2020_MAT,
      mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006,
          renodx_custom::color::macleod_boynton::LMS_From_MB_T(white + blended_unit * seed_len, target_t)));

  return renodx_custom::color::macleod_boynton::ApplyBT2020(
             seed_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
      .rgbOut;
}

float3 CorrectHueAndPurityMBGated(
    float3 target_color_bt709,
    float3 reference_color_bt709,
    float hue_strength = 1.f,
    float hue_t_ramp_start = 0.5f,
    float hue_t_ramp_end = 1.f,
    float purity_strength = 1.f,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f) {
  if (purity_strength <= 0.f && hue_strength <= 0.f) {
    return target_color_bt709;
  }

  if (hue_strength <= 0.f) {
    return CorrectPurityMBBT709WithBT2020(target_color_bt709, reference_color_bt709, purity_strength, curve_gamma,
                                          mb_white_override, t_min);
  }

  float3 target_color_bt2020 = renodx::color::bt2020::from::BT709(target_color_bt709);
  float3 reference_color_bt2020 = renodx::color::bt2020::from::BT709(reference_color_bt709);

  float3 target_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                          mul(renodx::color::BT2020_TO_XYZ_MAT, target_color_bt2020));
  float target_t = target_lms.x + target_lms.y;
  if (target_t <= t_min) {
    return target_color_bt709;
  }

  // Hue gating ramp in MB intensity anchor space (T = L + M).
  float hue_blend = hue_strength * saturate((target_t - hue_t_ramp_start) / (hue_t_ramp_end - hue_t_ramp_start));

  if (hue_blend <= 0.f) {
    return CorrectPurityMBBT709WithBT2020(target_color_bt709, reference_color_bt709, purity_strength, curve_gamma,
                                          mb_white_override, t_min);
  }

  float applied_purity01 = lerp(
      renodx_custom::color::macleod_boynton::ApplyBT2020(target_color_bt2020, 1.f, 1.f,
                                                         mb_white_override, t_min)
          .purityCur01,
      renodx_custom::color::macleod_boynton::ApplyBT2020(reference_color_bt2020, 1.f, 1.f,
                                                         mb_white_override, t_min)
          .purityCur01,
      purity_strength);

  float3 reference_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                             mul(renodx::color::BT2020_TO_XYZ_MAT, reference_color_bt2020));

  float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                     ? mb_white_override
                     : renodx_custom::color::macleod_boynton::MB_White_D65();

  float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - white;
  float2 reference_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_lms) - white;

  float target_len_sq = dot(target_direction, target_direction);
  float reference_len_sq = dot(reference_direction, reference_direction);

  if (target_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON && reference_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    return CorrectPurityMBBT709WithBT2020(target_color_bt709, reference_color_bt709, purity_strength, curve_gamma,
                                          mb_white_override, t_min);
  }

  float2 target_unit = (target_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                           ? target_direction * rsqrt(target_len_sq)
                           : float2(0.f, 0.f);
  float2 reference_unit = (reference_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                              ? reference_direction * rsqrt(reference_len_sq)
                              : target_unit;
  if (target_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    target_unit = reference_unit;
  }

  float2 blended_unit = lerp(target_unit, reference_unit, hue_blend);
  float blended_len_sq = dot(blended_unit, blended_unit);
  if (blended_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    blended_unit = (hue_blend >= 0.5f) ? reference_unit : target_unit;
    blended_len_sq = dot(blended_unit, blended_unit);
  }
  blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));

  float seed_len = sqrt(max(target_len_sq, 0.f));
  if (seed_len <= 1e-6f) {
    seed_len = sqrt(max(reference_len_sq, 0.f));
  }
  seed_len = max(seed_len, 1e-6f);

  float3 seed_bt2020 = mul(
      renodx::color::XYZ_TO_BT2020_MAT,
      mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006,
          renodx_custom::color::macleod_boynton::LMS_From_MB_T(white + blended_unit * seed_len, target_t)));

  return renodx::color::bt709::from::BT2020(
      renodx_custom::color::macleod_boynton::ApplyBT2020(
          seed_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
          .rgbOut);
}

// Single-reference MB correction with luminosity-gated hue:
// - Purity from reference is always applied at full strength.
// - Hue from reference is gated by LMS luminosity ramp (1.55 * L + M).
float3 CorrectHueLuminosityGatedAndPurityMB(
    float3 target_color_bt709,
    float3 reference_color_bt709,
    float hue_lum_ramp_start = 0.5f,
    float hue_lum_ramp_end = 1.f,
    float purity_scale = 1.f,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f) {
  const float kNearWhiteEpsilon = renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON;

  float3 target_color_bt2020 = renodx::color::bt2020::from::BT709(target_color_bt709);

  float3 target_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                          mul(renodx::color::BT2020_TO_XYZ_MAT, target_color_bt2020));
  float target_t = target_lms.x + target_lms.y;
  if (target_t <= t_min) {
    return target_color_bt709;
  }

  float target_luminosity = 1.55f * target_lms.x + target_lms.y;
  float hue_blend = saturate(renodx::math::DivideSafe(
      target_luminosity - hue_lum_ramp_start, hue_lum_ramp_end - hue_lum_ramp_start, 0.f));

  float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                     ? mb_white_override
                     : renodx_custom::color::macleod_boynton::MB_White_D65();

  float3 reference_color_bt2020 = renodx::color::bt2020::from::BT709(reference_color_bt709);
  float reference_purity01 = saturate(Purity01FromBT2020MB(reference_color_bt2020, white, t_min) * purity_scale);

  if (hue_blend <= 0.f) {
    return ApplyPurityOnlyMBToBT709(
        target_color_bt2020, reference_purity01, curve_gamma, mb_white_override, t_min);
  }

  float3 reference_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                             mul(renodx::color::BT2020_TO_XYZ_MAT, reference_color_bt2020));

  float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - white;
  float2 reference_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_lms) - white;

  float target_len_sq = dot(target_direction, target_direction);
  float reference_len_sq = dot(reference_direction, reference_direction);

  if (target_len_sq < kNearWhiteEpsilon && reference_len_sq < kNearWhiteEpsilon) {
    return ApplyPurityOnlyMBToBT709(
        target_color_bt2020, reference_purity01, curve_gamma, mb_white_override, t_min);
  }

  float2 target_unit = (target_len_sq > kNearWhiteEpsilon)
                           ? target_direction * rsqrt(target_len_sq)
                           : float2(0.f, 0.f);
  float2 reference_unit = (reference_len_sq > kNearWhiteEpsilon)
                              ? reference_direction * rsqrt(reference_len_sq)
                              : target_unit;
  if (target_len_sq <= kNearWhiteEpsilon) {
    target_unit = reference_unit;
  }

  float2 blended_unit = lerp(target_unit, reference_unit, hue_blend);
  float blended_len_sq = dot(blended_unit, blended_unit);
  if (blended_len_sq <= kNearWhiteEpsilon) {
    blended_unit = (hue_blend >= 0.5f) ? reference_unit : target_unit;
    blended_len_sq = dot(blended_unit, blended_unit);
  }
  blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));

  float seed_len = sqrt(max(target_len_sq, 0.f));
  if (seed_len <= 1e-6f) {
    seed_len = sqrt(max(reference_len_sq, 0.f));
  }
  seed_len = max(seed_len, 1e-6f);

  float3 seed_bt2020 = mul(
      renodx::color::XYZ_TO_BT2020_MAT,
      mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006,
          renodx_custom::color::macleod_boynton::LMS_From_MB_T(white + blended_unit * seed_len, target_t)));

  return ApplyPurityOnlyMBToBT709(
      seed_bt2020, reference_purity01, curve_gamma, mb_white_override, t_min);
}

// Single-reference MB correction with split low/high strengths:
// - One reference color drives both hue and purity donors.
// - Hue and purity each have independent low/high strengths.
// - A shared ramp drives both strengths, anchored to reference luminosity.
float3 CorrectHueAndPurityMBSplitStrength(
    float3 target_color_bt709,
    float3 reference_color_bt709,
    float hue_strength_low = 0.f,
    float hue_strength_high = 1.f,
    float purity_strength_low = 0.f,
    float purity_strength_high = 1.f,
    float ramp_start_offset = 0.5f,
    float ramp_end_offset = 1.f,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f) {
  const float kNearWhiteEpsilon = renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON;

  float3 target_color_bt2020 = renodx::color::bt2020::from::BT709(target_color_bt709);
  float3 reference_color_bt2020 = renodx::color::bt2020::from::BT709(reference_color_bt709);

  float3 target_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                          mul(renodx::color::BT2020_TO_XYZ_MAT, target_color_bt2020));
  float target_t = target_lms.x + target_lms.y;
  if (target_t <= t_min) {
    return target_color_bt709;
  }

  float3 reference_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                             mul(renodx::color::BT2020_TO_XYZ_MAT, reference_color_bt2020));
  float3 white_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                         mul(renodx::color::BT2020_TO_XYZ_MAT, float3(1.f, 1.f, 1.f)));

  float white_luminosity = max(1e-6f, 1.55f * white_lms.x + white_lms.y);
  float target_luminosity = (1.55f * target_lms.x + target_lms.y) / white_luminosity;
  float reference_luminosity = (1.55f * reference_lms.x + reference_lms.y) / white_luminosity;

  float ramp_start = reference_luminosity + ramp_start_offset;
  float ramp_end = reference_luminosity + ramp_end_offset;
  float ramp_t = saturate(renodx::math::DivideSafe(
      target_luminosity - ramp_start, ramp_end - ramp_start, 0.f));

  float hue_strength = saturate(lerp(hue_strength_low, hue_strength_high, ramp_t));
  float purity_strength = saturate(lerp(purity_strength_low, purity_strength_high, ramp_t));

  if (purity_strength <= 0.f && hue_strength <= 0.f) {
    return target_color_bt709;
  }

  float target_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                              target_color_bt2020, 1.f, 1.f, mb_white_override, t_min)
                              .purityCur01;
  float reference_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                                 reference_color_bt2020, 1.f, 1.f, mb_white_override, t_min)
                                 .purityCur01;
  float applied_purity01 = lerp(target_purity01, reference_purity01, purity_strength);

  if (hue_strength <= 0.f) {
    return renodx::color::bt709::from::BT2020(
        renodx_custom::color::macleod_boynton::ApplyBT2020(
            target_color_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
            .rgbOut);
  }

  float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                     ? mb_white_override
                     : renodx_custom::color::macleod_boynton::MB_White_D65();

  float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - white;
  float2 reference_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_lms) - white;

  float target_len_sq = dot(target_direction, target_direction);
  float reference_len_sq = dot(reference_direction, reference_direction);

  if (target_len_sq < kNearWhiteEpsilon && reference_len_sq < kNearWhiteEpsilon) {
    return renodx::color::bt709::from::BT2020(
        renodx_custom::color::macleod_boynton::ApplyBT2020(
            target_color_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
            .rgbOut);
  }

  float2 target_unit = (target_len_sq > kNearWhiteEpsilon)
                           ? target_direction * rsqrt(target_len_sq)
                           : float2(0.f, 0.f);
  float2 reference_unit = (reference_len_sq > kNearWhiteEpsilon)
                              ? reference_direction * rsqrt(reference_len_sq)
                              : target_unit;
  if (target_len_sq <= kNearWhiteEpsilon) {
    target_unit = reference_unit;
  }

  float2 blended_unit = lerp(target_unit, reference_unit, hue_strength);
  float blended_len_sq = dot(blended_unit, blended_unit);
  if (blended_len_sq <= kNearWhiteEpsilon) {
    blended_unit = (hue_strength >= 0.5f) ? reference_unit : target_unit;
    blended_len_sq = dot(blended_unit, blended_unit);
  }
  blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));

  float seed_len = sqrt(max(target_len_sq, 0.f));
  if (seed_len <= 1e-6f) {
    seed_len = sqrt(max(reference_len_sq, 0.f));
  }
  seed_len = max(seed_len, 1e-6f);

  float3 seed_bt2020 = mul(
      renodx::color::XYZ_TO_BT2020_MAT,
      mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006,
          renodx_custom::color::macleod_boynton::LMS_From_MB_T(white + blended_unit * seed_len, target_t)));

  return renodx::color::bt709::from::BT2020(
      renodx_custom::color::macleod_boynton::ApplyBT2020(
          seed_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
          .rgbOut);
}

float3 CorrectHueAndPurityMB2References(
    float3 target_color_bt709,
    float3 reference_low_bt709,
    float3 reference_high_bt709,
    float hue_strength = 1.f,
    float hue_t_ramp_start = 0.5f,
    float hue_t_ramp_end = 1.f,
    float purity_strength = 1.f,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f) {
  if (purity_strength <= 0.f && hue_strength <= 0.f) {
    return target_color_bt709;
  }

  float3 target_color_bt2020 = renodx::color::bt2020::from::BT709(target_color_bt709);
  float3 reference_low_bt2020 = renodx::color::bt2020::from::BT709(reference_low_bt709);
  float3 reference_high_bt2020 = renodx::color::bt2020::from::BT709(reference_high_bt709);

  float3 target_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                          mul(renodx::color::BT2020_TO_XYZ_MAT, target_color_bt2020));
  float target_t = target_lms.x + target_lms.y;
  if (target_t <= t_min) {
    return target_color_bt709;
  }

  float ramp_t = saturate((target_t - hue_t_ramp_start) / (hue_t_ramp_end - hue_t_ramp_start));

  float target_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                              target_color_bt2020, 1.f, 1.f, mb_white_override, t_min)
                              .purityCur01;
  float low_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                           reference_low_bt2020, 1.f, 1.f, mb_white_override, t_min)
                           .purityCur01;
  float high_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                            reference_high_bt2020, 1.f, 1.f, mb_white_override, t_min)
                            .purityCur01;
  float applied_purity01 = lerp(target_purity01, lerp(low_purity01, high_purity01, ramp_t), purity_strength);

  if (hue_strength <= 0.f) {
    return renodx::color::bt709::from::BT2020(
        renodx_custom::color::macleod_boynton::ApplyBT2020(
            target_color_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
            .rgbOut);
  }

  float3 reference_low_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                                 mul(renodx::color::BT2020_TO_XYZ_MAT, reference_low_bt2020));
  float3 reference_high_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                                  mul(renodx::color::BT2020_TO_XYZ_MAT, reference_high_bt2020));

  float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                     ? mb_white_override
                     : renodx_custom::color::macleod_boynton::MB_White_D65();

  float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - white;
  float2 low_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_low_lms) - white;
  float2 high_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_high_lms) - white;

  float target_len_sq = dot(target_direction, target_direction);
  float low_len_sq = dot(low_direction, low_direction);
  float high_len_sq = dot(high_direction, high_direction);

  if (low_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON && high_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    return renodx::color::bt709::from::BT2020(
        renodx_custom::color::macleod_boynton::ApplyBT2020(
            target_color_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
            .rgbOut);
  }

  float2 target_unit = (target_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                           ? target_direction * rsqrt(target_len_sq)
                           : float2(0.f, 0.f);
  float2 low_unit = (low_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                        ? low_direction * rsqrt(low_len_sq)
                        : target_unit;
  float2 high_unit = (high_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                         ? high_direction * rsqrt(high_len_sq)
                         : low_unit;

  float2 reference_unit = lerp(low_unit, high_unit, ramp_t);
  float reference_len_sq = dot(reference_unit, reference_unit);
  if (reference_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    reference_unit *= rsqrt(reference_len_sq);
  } else {
    reference_unit = high_unit;
  }

  if (target_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    target_unit = reference_unit;
  }

  float2 blended_unit = lerp(target_unit, reference_unit, hue_strength);
  float blended_len_sq = dot(blended_unit, blended_unit);
  if (blended_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    blended_unit = (hue_strength >= 0.5f) ? reference_unit : target_unit;
    blended_len_sq = dot(blended_unit, blended_unit);
  }
  blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));

  float seed_len = sqrt(max(target_len_sq, 0.f));
  if (seed_len <= 1e-6f) {
    seed_len = sqrt(max(lerp(low_len_sq, high_len_sq, ramp_t), 0.f));
  }
  seed_len = max(seed_len, 1e-6f);

  float3 seed_bt2020 = mul(
      renodx::color::XYZ_TO_BT2020_MAT,
      mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006,
          renodx_custom::color::macleod_boynton::LMS_From_MB_T(white + blended_unit * seed_len, target_t)));

  return renodx::color::bt709::from::BT2020(
      renodx_custom::color::macleod_boynton::ApplyBT2020(
          seed_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
          .rgbOut);
}

// Fused variant:
// 1) Low reference hue is the full-strength base hue.
// 2) High reference hue is layered by ramp in MB T = L + M space.
// 3) High reference purity is applied at full strength over full range.
float3 CorrectLowHueThenHighHueAndPurityMB(
    float3 target_color_bt709,
    float3 reference_low_bt709,
    float3 reference_high_bt709,
    float high_hue_strength = 1.f,
    float hue_t_ramp_start = 0.5f,
    float hue_t_ramp_end = 1.f,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f) {
  const float kNearWhiteEpsilon = renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON;

  float3 target_color_bt2020 = renodx::color::bt2020::from::BT709(target_color_bt709);
  float3 reference_low_bt2020 = renodx::color::bt2020::from::BT709(reference_low_bt709);
  float3 reference_high_bt2020 = renodx::color::bt2020::from::BT709(reference_high_bt709);

  float3 target_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                          mul(renodx::color::BT2020_TO_XYZ_MAT, target_color_bt2020));
  float target_t = target_lms.x + target_lms.y;
  if (target_t <= t_min) {
    return target_color_bt709;
  }

  float ramp_t = saturate(renodx::math::DivideSafe(target_t - hue_t_ramp_start, hue_t_ramp_end - hue_t_ramp_start, 0.f));
  float high_hue_blend = saturate(high_hue_strength) * ramp_t;

  // Full-strength purity from high reference (one donor purity solve).
  float high_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                            reference_high_bt2020, 1.f, 1.f, mb_white_override, t_min)
                            .purityCur01;

  float3 reference_low_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                                 mul(renodx::color::BT2020_TO_XYZ_MAT, reference_low_bt2020));
  float3 reference_high_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                                  mul(renodx::color::BT2020_TO_XYZ_MAT, reference_high_bt2020));

  float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                     ? mb_white_override
                     : renodx_custom::color::macleod_boynton::MB_White_D65();

  float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - white;
  float2 low_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_low_lms) - white;
  float2 high_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_high_lms) - white;

  float target_len_sq = dot(target_direction, target_direction);
  float low_len_sq = dot(low_direction, low_direction);
  float high_len_sq = dot(high_direction, high_direction);

  float2 low_unit = float2(0.f, 0.f);
  if (low_len_sq > kNearWhiteEpsilon) {
    low_unit = low_direction * rsqrt(low_len_sq);
  } else if (target_len_sq > kNearWhiteEpsilon) {
    low_unit = target_direction * rsqrt(target_len_sq);
  } else if (high_len_sq > kNearWhiteEpsilon) {
    low_unit = high_direction * rsqrt(high_len_sq);
  }

  float2 high_unit = (high_len_sq > kNearWhiteEpsilon) ? high_direction * rsqrt(high_len_sq) : low_unit;

  float2 blended_unit = lerp(low_unit, high_unit, high_hue_blend);
  float blended_len_sq = dot(blended_unit, blended_unit);
  if (blended_len_sq <= kNearWhiteEpsilon) {
    return renodx::color::bt709::from::BT2020(
        renodx_custom::color::macleod_boynton::ApplyBT2020(
            target_color_bt2020, high_purity01, curve_gamma, mb_white_override, t_min)
            .rgbOut);
  }
  blended_unit *= rsqrt(blended_len_sq);

  float seed_len = sqrt(max(target_len_sq, 0.f));
  if (seed_len <= 1e-6f) {
    seed_len = sqrt(max(lerp(low_len_sq, high_len_sq, ramp_t), 0.f));
  }
  seed_len = max(seed_len, 1e-6f);

  float3 seed_bt2020 = mul(
      renodx::color::XYZ_TO_BT2020_MAT,
      mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006,
          renodx_custom::color::macleod_boynton::LMS_From_MB_T(white + blended_unit * seed_len, target_t)));

  return renodx::color::bt709::from::BT2020(
      renodx_custom::color::macleod_boynton::ApplyBT2020(
          seed_bt2020, high_purity01, curve_gamma, mb_white_override, t_min)
          .rgbOut);
}

float LuminosityFromBT709(float3 bt709_linear) {
  float3 xyz = mul(renodx::color::BT709_TO_XYZ_MAT, bt709_linear);
  float3 lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006, xyz);
  return 1.55f * lms.x + lms.y;
}

float LuminosityFromBT709LuminanceNormalized(float3 bt709_linear) {
  float luminosity = LuminosityFromBT709(bt709_linear);

  return luminosity / LuminosityFromBT709(1.f);
}

float LuminosityFromBT2020(float3 bt2020_linear) {
  float3 xyz = mul(renodx::color::BT2020_TO_XYZ_MAT, bt2020_linear);
  float3 lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006, xyz);
  return 1.55f * lms.x + lms.y;
}

float LuminosityFromBT2020LuminanceNormalized(float3 bt2020_linear) {
  float luminosity = LuminosityFromBT2020(bt2020_linear);

  return luminosity / LuminosityFromBT2020(1.f);
}

#endif  // SRC_SHADERS_COLOR_MACLEOD_BOYNTON_HLSL_
