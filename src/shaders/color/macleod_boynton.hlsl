#ifndef SRC_SHADERS_COLOR_MACLEOD_BOYNTON_HLSL_
#define SRC_SHADERS_COLOR_MACLEOD_BOYNTON_HLSL_

#include "../math.hlsl"
#include "./rgb.hlsl"

namespace renodx {
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
                       mb_white_override, t_min, purity_adjust_mode, BT709_TO_XYZ_MAT,
                       XYZ_TO_BT709_MAT);
}

MBPurityDebug ApplyBT2020(float3 rgb2020_linear, float purity01, float curve_gamma = 1.f,
                          float2 mb_white_override = float2(-1.f, -1.f), float t_min = 1e-6f,
                          int purity_adjust_mode = MB_PURITY_ADJUST_NONE) {
  return ApplyInternal(rgb2020_linear, purity01, MB_PURITY_MODE_NORMALIZED, curve_gamma,
                       mb_white_override, t_min, purity_adjust_mode, BT2020_TO_XYZ_MAT,
                       XYZ_TO_BT2020_MAT);
}

MBPurityDebug ApplyScaleBT709(float3 rgb709_linear, float saturation_scale,
                              float2 mb_white_override = float2(-1.f, -1.f), float t_min = 1e-6f,
                              int purity_adjust_mode = MB_PURITY_ADJUST_NONE) {
  return ApplyInternal(rgb709_linear, saturation_scale, MB_PURITY_MODE_SCALE_NEUTWO, 1.f,
                       mb_white_override, t_min, purity_adjust_mode, BT709_TO_XYZ_MAT,
                       XYZ_TO_BT709_MAT);
}

MBPurityDebug ApplyScaleBT2020(float3 rgb2020_linear, float saturation_scale,
                               float2 mb_white_override = float2(-1.f, -1.f), float t_min = 1e-6f,
                               int purity_adjust_mode = MB_PURITY_ADJUST_NONE) {
  return ApplyInternal(rgb2020_linear, saturation_scale, MB_PURITY_MODE_SCALE_NEUTWO, 1.f,
                       mb_white_override, t_min, purity_adjust_mode, BT2020_TO_XYZ_MAT,
                       XYZ_TO_BT2020_MAT);
}

float3 BT709(float3 rgb709_linear, float purity_scale, float2 mb_white) {
  return ApplyInternal(rgb709_linear, purity_scale, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, 0.f,
                       MB_PURITY_ADJUST_NONE, BT709_TO_XYZ_MAT, XYZ_TO_BT709_MAT)
      .rgbOut;
}

float3 BT2020(float3 rgb2020_linear, float purity_scale, float2 mb_white) {
  return ApplyInternal(rgb2020_linear, purity_scale, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, 0.f,
                       MB_PURITY_ADJUST_NONE, BT2020_TO_XYZ_MAT, XYZ_TO_BT2020_MAT)
      .rgbOut;
}

// Explicit max-purity helpers for testing.
float3 BT709MaxPurity(float3 rgb709_linear, float2 mb_white) {
  return ApplyInternal(rgb709_linear, 0.f, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, 0.f,
                       MB_PURITY_ADJUST_CLIP_MAX, BT709_TO_XYZ_MAT, XYZ_TO_BT709_MAT)
      .rgbOut;
}

float3 BT2020MaxPurity(float3 rgb2020_linear, float2 mb_white) {
  return ApplyInternal(rgb2020_linear, 0.f, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, 0.f,
                       MB_PURITY_ADJUST_CLIP_MAX, BT2020_TO_XYZ_MAT, XYZ_TO_BT2020_MAT)
      .rgbOut;
}

// Gamut compression in MB space:
// Use the white->hue MB ray and clamp t to at most 1.0 (input point).
// - If already in gamut, color is unchanged.
// - If out of gamut, color moves toward MB white until it hits gamut edge.
float3 GamutCompressBT709(float3 rgb709_linear, float2 mb_white = float2(-1.f, -1.f),
                          float t_min = 1e-6f) {
  return ApplyInternal(rgb709_linear, 1.f, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, t_min,
                       MB_PURITY_ADJUST_NONE, BT709_TO_XYZ_MAT, XYZ_TO_BT709_MAT)
      .rgbOut;
}

float3 GamutCompressBT2020(float3 rgb2020_linear, float2 mb_white = float2(-1.f, -1.f),
                           float t_min = 1e-6f) {
  return ApplyInternal(rgb2020_linear, 1.f, MB_PURITY_MODE_DISTANCE, 1.f, mb_white, t_min,
                       MB_PURITY_ADJUST_NONE, BT2020_TO_XYZ_MAT, XYZ_TO_BT2020_MAT)
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
  return GamutCompressAddWhiteInternal(rgb709_linear, mb_white, t_min, BT709_TO_XYZ_MAT,
                                       XYZ_TO_BT709_MAT);
}

float3 GamutCompressAddWhiteBT2020(float3 rgb2020_linear, float2 mb_white = float2(-1.f, -1.f),
                                   float t_min = 1e-6f) {
  return GamutCompressAddWhiteInternal(rgb2020_linear, mb_white, t_min, BT2020_TO_XYZ_MAT,
                                       XYZ_TO_BT2020_MAT);
}

}  // namespace macleod_boynton
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_MACLEOD_BOYNTON_HLSL_
