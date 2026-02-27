#ifndef SRC_GAMES_RDR2VK_MACLEOD_BOYNTON_GLSL_
#define SRC_GAMES_RDR2VK_MACLEOD_BOYNTON_GLSL_

// Self-contained GLSL port of macleod_boynton.hlsli.
// Names are prefixed to replace HLSL namespaces.

const mat3 renodx_color_macleod_boynton_XYZ_TO_LMS_2006 = mat3(
    vec3(0.185082982238733, -0.134433056469973, 0.000789456671966863),
    vec3(0.584081279463687, 0.405752392775348, -0.000912281325916184),
    vec3(-0.0240722415044404, 0.0358252602217631, 0.0198490812339463));

const mat3 renodx_color_macleod_boynton_LMS_TO_XYZ_2006 = mat3(
    vec3(2.628474773947687, 0.8765342837340055, -0.06425592569153735),
    vec3(-3.761263499279893, 1.2003038085515867, 0.20476359921126536),
    vec3(9.9763571339745, -1.1033785928646218, 49.93266413348867));

const mat3 renodx_color_macleod_boynton_BT709_TO_XYZ_MAT = mat3(
    vec3(0.4123907993, 0.2126390059, 0.0193308187),
    vec3(0.3575843394, 0.7151686788, 0.1191947798),
    vec3(0.1804807884, 0.0721923154, 0.9505321522));

const mat3 renodx_color_macleod_boynton_XYZ_TO_BT709_MAT = mat3(
    vec3(3.2409699419, -0.9692436363, 0.0556300797),
    vec3(-1.5373831776, 1.8759675015, -0.2039769589),
    vec3(-0.4986107603, 0.0415550574, 1.0569715142));

const mat3 renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT = mat3(
    vec3(0.6369580483, 0.2627002120, 0.0000000000),
    vec3(0.1446169036, 0.6779980715, 0.0280726930),
    vec3(0.1688809752, 0.0593017165, 1.0609850577));

const mat3 renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT = mat3(
    vec3(1.7166511880, -0.6666843518, 0.0176398574),
    vec3(-0.3556707838, 1.6164812366, -0.0427706133),
    vec3(-0.2533662814, 0.0157685458, 0.9421031212));

const vec2 renodx_color_macleod_boynton_WHITE_POINT_D65 = vec2(0.31272, 0.32903);

const float renodx_color_macleod_boynton_EPSILON = 1e-20;
const float renodx_color_macleod_boynton_INTERVAL_MAX = 1e30;
const float renodx_color_macleod_boynton_MB_NEAR_WHITE_EPSILON = 1e-14;
const float renodx_color_macleod_boynton_ONE_MINUS_EPSILON = 1.0 - 1e-6;

const int renodx_color_macleod_boynton_MB_PURITY_MODE_DISTANCE = 0;
const int renodx_color_macleod_boynton_MB_PURITY_MODE_NORMALIZED = 1;
const int renodx_color_macleod_boynton_MB_PURITY_MODE_SCALE_NEUTWO = 2;
const int renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE = 0;
const int renodx_color_macleod_boynton_MB_PURITY_ADJUST_CLIP_MAX = 1;

float renodx_color_macleod_boynton_DivideSafe(float a, float b, float fallback) {
  return (b == 0.0) ? fallback : (a / b);
}

float renodx_color_macleod_boynton_saturate(float x) {
  return clamp(x, 0.0, 1.0);
}

vec3 renodx_color_macleod_boynton_xyz_from_xyY(vec3 xyY) {
  float x = xyY.x;
  float y = xyY.y;
  float Y = xyY.z;
  float safe_y = max(y, 1e-10);

  float X = x * Y / safe_y;
  float Z = (1.0 - x - y) * Y / safe_y;
  return vec3(X, Y, Z);
}

float renodx_color_macleod_boynton_Neutwo(float x) {
  float denominator_squared = x * x + 1.0;
  return x * inversesqrt(denominator_squared);
}

float renodx_color_macleod_boynton_InverseNeutwo(float x) {
  float clamped = min(max(x, 0.0), renodx_color_macleod_boynton_ONE_MINUS_EPSILON);
  float denominator_squared = 1.0 - clamped * clamped;
  return clamped * inversesqrt(denominator_squared);
}

vec2 renodx_color_macleod_boynton_MB_From_LMS(vec3 lms) {
  float t = lms.x + lms.y;
  if (t <= 0.0) {
    return vec2(0.0);
  }

  return vec2(
      renodx_color_macleod_boynton_DivideSafe(lms.x, t, 0.0),
      renodx_color_macleod_boynton_DivideSafe(lms.z, t, 0.0));
}

vec3 renodx_color_macleod_boynton_LMS_From_MB_T(vec2 mb, float t) {
  float r = mb.x;
  float b = mb.y;
  return vec3(r * t, (1.0 - r) * t, b * t);
}

vec2 renodx_color_macleod_boynton_MB_White_D65() {
  vec3 d65_xyz = renodx_color_macleod_boynton_xyz_from_xyY(
      vec3(renodx_color_macleod_boynton_WHITE_POINT_D65, 1.0));
  vec3 d65_lms = renodx_color_macleod_boynton_XYZ_TO_LMS_2006 * d65_xyz;
  return renodx_color_macleod_boynton_MB_From_LMS(d65_lms);
}

vec3 renodx_color_macleod_boynton_TransferPurityBT2020(
    vec3 rgb_target_bt2020_linear, vec3 rgb_source_bt2020_linear, float strength) {
  if (strength <= 0.0) {
    return max(rgb_target_bt2020_linear, vec3(0.0));
  }

  const float t_min = 1e-7;
  vec2 white = renodx_color_macleod_boynton_MB_White_D65();

  vec3 xyz_target = renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT * rgb_target_bt2020_linear;
  vec3 lms_target = renodx_color_macleod_boynton_XYZ_TO_LMS_2006 * xyz_target;
  float target_t = lms_target.x + lms_target.y;
  if (target_t <= t_min) {
    return max(rgb_target_bt2020_linear, vec3(0.0));
  }

  vec3 xyz_source = renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT * rgb_source_bt2020_linear;
  vec3 lms_source = renodx_color_macleod_boynton_XYZ_TO_LMS_2006 * xyz_source;
  float source_t = lms_source.x + lms_source.y;
  if (source_t <= t_min) {
    return max(rgb_target_bt2020_linear, vec3(0.0));
  }

  vec2 mb_target = renodx_color_macleod_boynton_MB_From_LMS(lms_target);
  vec2 mb_source = renodx_color_macleod_boynton_MB_From_LMS(lms_source);

  vec2 target_offset = mb_target - white;
  float target_len = length(target_offset);
  if (target_len < renodx_color_macleod_boynton_MB_NEAR_WHITE_EPSILON) {
    return max(rgb_target_bt2020_linear, vec3(0.0));
  }

  float source_len = length(mb_source - white);
  float out_len = (strength >= 1.0)
                      ? source_len
                      : mix(target_len, source_len, clamp(strength, 0.0, 1.0));

  vec2 target_dir = target_offset / target_len;
  vec2 mb_out = white + target_dir * out_len;
  vec3 lms_out = renodx_color_macleod_boynton_LMS_From_MB_T(mb_out, target_t);
  vec3 xyz_out = renodx_color_macleod_boynton_LMS_TO_XYZ_2006 * lms_out;
  vec3 rgb_out = renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT * xyz_out;
  return max(rgb_out, vec3(0.0));
}

void renodx_color_macleod_boynton_IntervalLower0(float a, float b, out float lo, out float hi) {
  if (abs(a) < renodx_color_macleod_boynton_EPSILON) {
    if (b >= 0.0) {
      lo = -renodx_color_macleod_boynton_INTERVAL_MAX;
      hi = renodx_color_macleod_boynton_INTERVAL_MAX;
    } else {
      lo = 1.0;
      hi = 0.0;
    }
    return;
  }

  float t0 = renodx_color_macleod_boynton_DivideSafe(-b, a, 0.0);
  if (a > 0.0) {
    lo = t0;
    hi = renodx_color_macleod_boynton_INTERVAL_MAX;
  } else {
    lo = -renodx_color_macleod_boynton_INTERVAL_MAX;
    hi = t0;
  }
}

struct renodx_color_macleod_boynton_MBPurityDebug {
  vec3 rgbOut;
  vec3 rgbT0;
  vec3 rgbEdgeGamut;
  float tMaxGamut;
  float tFinal;
  float purityCur01;
  float purity01_in;
  float purity01_used;
};

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyInternal(
    vec3 rgb_linear, float purity_value, int purity_input_mode, float curve_gamma,
    vec2 mb_white_override, float t_min, int purity_adjust_mode,
    mat3 rgb_to_xyz_mat, mat3 xyz_to_rgb_mat) {
  renodx_color_macleod_boynton_MBPurityDebug result;
  result.rgbOut = rgb_linear;
  result.rgbT0 = rgb_linear;
  result.rgbEdgeGamut = rgb_linear;
  result.tMaxGamut = 0.0;
  result.tFinal = 0.0;
  result.purityCur01 = 0.0;
  result.purity01_in = 0.0;
  result.purity01_used = 0.0;

  vec3 xyz = rgb_to_xyz_mat * rgb_linear;
  vec3 lms = renodx_color_macleod_boynton_XYZ_TO_LMS_2006 * xyz;

  float t = lms.x + lms.y;
  if (t <= t_min) {
    return result;
  }

  vec2 white = (mb_white_override.x >= 0.0 && mb_white_override.y >= 0.0)
                   ? mb_white_override
                   : renodx_color_macleod_boynton_MB_White_D65();

  vec2 mb0 = renodx_color_macleod_boynton_MB_From_LMS(lms);
  vec2 direction = mb0 - white;
  if (dot(direction, direction) < renodx_color_macleod_boynton_MB_NEAR_WHITE_EPSILON) {
    return result;
  }

  vec3 lms_t0 = renodx_color_macleod_boynton_LMS_From_MB_T(white, t);
  vec3 xyz_t0 = renodx_color_macleod_boynton_LMS_TO_XYZ_2006 * lms_t0;
  vec3 rgb_t0 = xyz_to_rgb_mat * xyz_t0;
  result.rgbT0 = rgb_t0;

  vec3 a = rgb_linear - rgb_t0;

  float t_lo = 0.0;
  float t_hi = renodx_color_macleod_boynton_INTERVAL_MAX;
  float lo;
  float hi;

  renodx_color_macleod_boynton_IntervalLower0(a.x, rgb_t0.x, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);
  renodx_color_macleod_boynton_IntervalLower0(a.y, rgb_t0.y, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);
  renodx_color_macleod_boynton_IntervalLower0(a.z, rgb_t0.z, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  if (t_hi < t_lo) {
    result.rgbOut = max(rgb_linear, vec3(0.0));
    result.rgbEdgeGamut = rgb_t0;
    return result;
  }

  float t_max = max(0.0, t_hi);
  result.tMaxGamut = t_max;

  float p_cur = (t_max > renodx_color_macleod_boynton_EPSILON)
                    ? renodx_color_macleod_boynton_DivideSafe(1.0, t_max, 0.0)
                    : 0.0;
  result.purityCur01 = renodx_color_macleod_boynton_saturate(p_cur);
  result.rgbEdgeGamut = a * t_max + rgb_t0;

  float t_final = 0.0;
  if (purity_adjust_mode == renodx_color_macleod_boynton_MB_PURITY_ADJUST_CLIP_MAX) {
    result.purity01_used = 1.0;
    result.purity01_in = 1.0;
    t_final = t_max;
  } else if (purity_input_mode == renodx_color_macleod_boynton_MB_PURITY_MODE_NORMALIZED) {
    result.purity01_in = renodx_color_macleod_boynton_saturate(purity_value);
    float gamma = max(curve_gamma, 1e-6);
    float purity01 = pow(result.purity01_in, gamma);
    result.purity01_used = purity01;
    t_final = purity01 * t_max;
  } else if (purity_input_mode == renodx_color_macleod_boynton_MB_PURITY_MODE_SCALE_NEUTWO) {
    float saturation_scale = max(purity_value, 0.0);
    float purity01_target;
    if (result.purityCur01 >= renodx_color_macleod_boynton_ONE_MINUS_EPSILON && saturation_scale >= 1.0) {
      purity01_target = 1.0;
    } else {
      float z = renodx_color_macleod_boynton_InverseNeutwo(result.purityCur01);
      float z_scaled = z * saturation_scale;
      purity01_target = renodx_color_macleod_boynton_saturate(
          renodx_color_macleod_boynton_Neutwo(z_scaled));
    }
    result.purity01_in = result.purityCur01;
    result.purity01_used = purity01_target;
    t_final = purity01_target * t_max;
  } else {
    float t_user = max(purity_value, 0.0);
    t_final = min(t_user, t_max);
    result.purity01_used = (t_max > renodx_color_macleod_boynton_EPSILON)
                               ? renodx_color_macleod_boynton_saturate(
                                     renodx_color_macleod_boynton_DivideSafe(t_final, t_max, 0.0))
                               : 0.0;
    result.purity01_in = result.purity01_used;
  }

  result.tFinal = t_final;

  vec2 mb_final = white + t_final * direction;
  vec3 lms_final = renodx_color_macleod_boynton_LMS_From_MB_T(mb_final, t);
  vec3 xyz_final = renodx_color_macleod_boynton_LMS_TO_XYZ_2006 * lms_final;
  vec3 rgb_final = xyz_to_rgb_mat * xyz_final;
  result.rgbOut = max(rgb_final, vec3(0.0));
  return result;
}

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyBT709(
    vec3 rgb709_linear, float purity01, float curve_gamma, vec2 mb_white_override,
    float t_min, int purity_adjust_mode) {
  return renodx_color_macleod_boynton_ApplyInternal(
      rgb709_linear, purity01,
      renodx_color_macleod_boynton_MB_PURITY_MODE_NORMALIZED,
      curve_gamma, mb_white_override, t_min, purity_adjust_mode,
      renodx_color_macleod_boynton_BT709_TO_XYZ_MAT,
      renodx_color_macleod_boynton_XYZ_TO_BT709_MAT);
}

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyBT709(vec3 rgb709_linear, float purity01) {
  return renodx_color_macleod_boynton_ApplyBT709(
      rgb709_linear, purity01, 1.0, vec2(-1.0), 1e-6,
      renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE);
}

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyBT2020(
    vec3 rgb2020_linear, float purity01, float curve_gamma, vec2 mb_white_override,
    float t_min, int purity_adjust_mode) {
  return renodx_color_macleod_boynton_ApplyInternal(
      rgb2020_linear, purity01,
      renodx_color_macleod_boynton_MB_PURITY_MODE_NORMALIZED,
      curve_gamma, mb_white_override, t_min, purity_adjust_mode,
      renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT,
      renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT);
}

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyBT2020(vec3 rgb2020_linear, float purity01) {
  return renodx_color_macleod_boynton_ApplyBT2020(
      rgb2020_linear, purity01, 1.0, vec2(-1.0), 1e-6,
      renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE);
}

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyScaleBT709(
    vec3 rgb709_linear, float saturation_scale, vec2 mb_white_override, float t_min,
    int purity_adjust_mode) {
  return renodx_color_macleod_boynton_ApplyInternal(
      rgb709_linear, saturation_scale,
      renodx_color_macleod_boynton_MB_PURITY_MODE_SCALE_NEUTWO,
      1.0, mb_white_override, t_min, purity_adjust_mode,
      renodx_color_macleod_boynton_BT709_TO_XYZ_MAT,
      renodx_color_macleod_boynton_XYZ_TO_BT709_MAT);
}

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyScaleBT709(vec3 rgb709_linear, float saturation_scale) {
  return renodx_color_macleod_boynton_ApplyScaleBT709(
      rgb709_linear, saturation_scale, vec2(-1.0), 1e-6,
      renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE);
}

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyScaleBT2020(
    vec3 rgb2020_linear, float saturation_scale, vec2 mb_white_override, float t_min,
    int purity_adjust_mode) {
  return renodx_color_macleod_boynton_ApplyInternal(
      rgb2020_linear, saturation_scale,
      renodx_color_macleod_boynton_MB_PURITY_MODE_SCALE_NEUTWO,
      1.0, mb_white_override, t_min, purity_adjust_mode,
      renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT,
      renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT);
}

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyScaleBT2020(vec3 rgb2020_linear, float saturation_scale) {
  return renodx_color_macleod_boynton_ApplyScaleBT2020(
      rgb2020_linear, saturation_scale, vec2(-1.0), 1e-6,
      renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE);
}

vec3 renodx_color_macleod_boynton_BT709(vec3 rgb709_linear, float purity_scale, vec2 mb_white) {
  return renodx_color_macleod_boynton_ApplyInternal(
             rgb709_linear, purity_scale,
             renodx_color_macleod_boynton_MB_PURITY_MODE_DISTANCE,
             1.0, mb_white, 0.0,
             renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE,
             renodx_color_macleod_boynton_BT709_TO_XYZ_MAT,
             renodx_color_macleod_boynton_XYZ_TO_BT709_MAT)
      .rgbOut;
}

vec3 renodx_color_macleod_boynton_BT2020(vec3 rgb2020_linear, float purity_scale, vec2 mb_white) {
  return renodx_color_macleod_boynton_ApplyInternal(
             rgb2020_linear, purity_scale,
             renodx_color_macleod_boynton_MB_PURITY_MODE_DISTANCE,
             1.0, mb_white, 0.0,
             renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE,
             renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT,
             renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT)
      .rgbOut;
}

vec3 renodx_color_macleod_boynton_BT709MaxPurity(vec3 rgb709_linear, vec2 mb_white) {
  return renodx_color_macleod_boynton_ApplyInternal(
             rgb709_linear, 0.0,
             renodx_color_macleod_boynton_MB_PURITY_MODE_DISTANCE,
             1.0, mb_white, 0.0,
             renodx_color_macleod_boynton_MB_PURITY_ADJUST_CLIP_MAX,
             renodx_color_macleod_boynton_BT709_TO_XYZ_MAT,
             renodx_color_macleod_boynton_XYZ_TO_BT709_MAT)
      .rgbOut;
}

vec3 renodx_color_macleod_boynton_BT2020MaxPurity(vec3 rgb2020_linear, vec2 mb_white) {
  return renodx_color_macleod_boynton_ApplyInternal(
             rgb2020_linear, 0.0,
             renodx_color_macleod_boynton_MB_PURITY_MODE_DISTANCE,
             1.0, mb_white, 0.0,
             renodx_color_macleod_boynton_MB_PURITY_ADJUST_CLIP_MAX,
             renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT,
             renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT)
      .rgbOut;
}

vec3 renodx_color_macleod_boynton_GamutCompressBT709(vec3 rgb709_linear, vec2 mb_white, float t_min) {
  return renodx_color_macleod_boynton_ApplyInternal(
             rgb709_linear, 1.0,
             renodx_color_macleod_boynton_MB_PURITY_MODE_DISTANCE,
             1.0, mb_white, t_min,
             renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE,
             renodx_color_macleod_boynton_BT709_TO_XYZ_MAT,
             renodx_color_macleod_boynton_XYZ_TO_BT709_MAT)
      .rgbOut;
}

vec3 renodx_color_macleod_boynton_GamutCompressBT709(vec3 rgb709_linear) {
  return renodx_color_macleod_boynton_GamutCompressBT709(rgb709_linear, vec2(-1.0), 1e-6);
}

vec3 renodx_color_macleod_boynton_GamutCompressBT2020(vec3 rgb2020_linear, vec2 mb_white, float t_min) {
  return renodx_color_macleod_boynton_ApplyInternal(
             rgb2020_linear, 1.0,
             renodx_color_macleod_boynton_MB_PURITY_MODE_DISTANCE,
             1.0, mb_white, t_min,
             renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE,
             renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT,
             renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT)
      .rgbOut;
}

vec3 renodx_color_macleod_boynton_GamutCompressBT2020(vec3 rgb2020_linear) {
  return renodx_color_macleod_boynton_GamutCompressBT2020(rgb2020_linear, vec2(-1.0), 1e-6);
}

vec3 renodx_color_macleod_boynton_GamutCompressAddWhiteInternal(
    vec3 rgb_linear, vec2 mb_white_override, float t_min, mat3 rgb_to_xyz_mat, mat3 xyz_to_rgb_mat) {
  vec3 xyz = rgb_to_xyz_mat * rgb_linear;
  vec3 lms = renodx_color_macleod_boynton_XYZ_TO_LMS_2006 * xyz;
  float t = lms.x + lms.y;
  if (t <= t_min) {
    return max(rgb_linear, vec3(0.0));
  }

  vec2 white = (mb_white_override.x >= 0.0 && mb_white_override.y >= 0.0)
                   ? mb_white_override
                   : renodx_color_macleod_boynton_MB_White_D65();
  vec2 mb0 = renodx_color_macleod_boynton_MB_From_LMS(lms);
  vec2 direction = mb0 - white;
  if (dot(direction, direction) < renodx_color_macleod_boynton_MB_NEAR_WHITE_EPSILON) {
    return max(rgb_linear, vec3(0.0));
  }

  vec3 lms_t0 = renodx_color_macleod_boynton_LMS_From_MB_T(white, t);
  vec3 xyz_t0 = renodx_color_macleod_boynton_LMS_TO_XYZ_2006 * lms_t0;
  vec3 rgb_t0 = xyz_to_rgb_mat * xyz_t0;
  vec3 ray_a = rgb_linear - rgb_t0;

  float t_lo = 0.0;
  float t_hi = renodx_color_macleod_boynton_INTERVAL_MAX;
  float lo;
  float hi;

  renodx_color_macleod_boynton_IntervalLower0(ray_a.x, rgb_t0.x, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);
  renodx_color_macleod_boynton_IntervalLower0(ray_a.y, rgb_t0.y, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);
  renodx_color_macleod_boynton_IntervalLower0(ray_a.z, rgb_t0.z, lo, hi);
  t_lo = max(t_lo, lo);
  t_hi = min(t_hi, hi);

  if (t_hi < t_lo) {
    return max(rgb_linear, vec3(0.0));
  }

  float t_max = max(0.0, t_hi);
  float white_ratio = max(
      renodx_color_macleod_boynton_DivideSafe(1.0 - t_max, t_max, 0.0), 0.0);
  float white_add = t * white_ratio;

  vec3 white_unit_lms = renodx_color_macleod_boynton_LMS_From_MB_T(white, 1.0);
  vec3 lms_out = lms + white_unit_lms * white_add;
  vec3 xyz_out = renodx_color_macleod_boynton_LMS_TO_XYZ_2006 * lms_out;
  vec3 rgb_out = xyz_to_rgb_mat * xyz_out;
  return max(rgb_out, vec3(0.0));
}

vec3 renodx_color_macleod_boynton_GamutCompressAddWhiteBT709(
    vec3 rgb709_linear, vec2 mb_white, float t_min) {
  return renodx_color_macleod_boynton_GamutCompressAddWhiteInternal(
      rgb709_linear, mb_white, t_min,
      renodx_color_macleod_boynton_BT709_TO_XYZ_MAT,
      renodx_color_macleod_boynton_XYZ_TO_BT709_MAT);
}

vec3 renodx_color_macleod_boynton_GamutCompressAddWhiteBT709(vec3 rgb709_linear) {
  return renodx_color_macleod_boynton_GamutCompressAddWhiteBT709(rgb709_linear, vec2(-1.0), 1e-6);
}

vec3 renodx_color_macleod_boynton_GamutCompressAddWhiteBT2020(
    vec3 rgb2020_linear, vec2 mb_white, float t_min) {
  return renodx_color_macleod_boynton_GamutCompressAddWhiteInternal(
      rgb2020_linear, mb_white, t_min,
      renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT,
      renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT);
}

vec3 renodx_color_macleod_boynton_GamutCompressAddWhiteBT2020(vec3 rgb2020_linear) {
  return renodx_color_macleod_boynton_GamutCompressAddWhiteBT2020(rgb2020_linear, vec2(-1.0), 1e-6);
}

float renodx_color_macleod_boynton_LuminosityFromBT709(vec3 bt709_linear) {
  vec3 xyz = renodx_color_macleod_boynton_BT709_TO_XYZ_MAT * bt709_linear;
  vec3 lms = renodx_color_macleod_boynton_XYZ_TO_LMS_2006 * xyz;
  return 1.55 * lms.x + lms.y;
}

float renodx_color_macleod_boynton_LuminosityFromBT709LuminanceNormalized(vec3 bt709_linear) {
  float luminosity = renodx_color_macleod_boynton_LuminosityFromBT709(bt709_linear);
  return luminosity / renodx_color_macleod_boynton_LuminosityFromBT709(vec3(1.0));
}

float renodx_color_macleod_boynton_LuminosityFromBT2020(vec3 bt2020_linear) {
  vec3 xyz = renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT * bt2020_linear;
  vec3 lms = renodx_color_macleod_boynton_XYZ_TO_LMS_2006 * xyz;
  return 1.55 * lms.x + lms.y;
}

float renodx_color_macleod_boynton_LuminosityFromBT2020LuminanceNormalized(vec3 bt2020_linear) {
  float luminosity = renodx_color_macleod_boynton_LuminosityFromBT2020(bt2020_linear);
  return luminosity / renodx_color_macleod_boynton_LuminosityFromBT2020(vec3(1.0));
}

struct UserGradingConfig {
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float gamma;
  float saturation;
  float dechroma;
  float highlight_saturation;
  float hue_emulation;
  float purity_emulation;
};

float renodx_usergrading_DivideSafe(float a, float b, float fallback) {
  return (b == 0.0) ? fallback : (a / b);
}

float renodx_usergrading_SafeDivision(float quotient, float divisor, float fallback) {
  return renodx_usergrading_DivideSafe(quotient, divisor, fallback);
}

float renodx_usergrading_saturate(float x) {
  return clamp(x, 0.0, 1.0);
}

vec3 renodx_usergrading_Luminance(vec3 color, float incorrect_y, float correct_y, float strength) {
  float ratio = renodx_usergrading_DivideSafe(correct_y, incorrect_y, 1.0);
  return color * mix(1.0, ratio, strength);
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.0) return x;

  if (highlights > 1.0) {
    return max(x, mix(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.0)));
  } else {
    x /= mid_gray;
    return mix(x, pow(x, highlights), step(1.0, x)) * mid_gray;
  }
}

float Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.0) return x;

  float ratio = max(renodx_usergrading_DivideSafe(x, mid_gray, 0.0), 0.0);
  float base_term = x * mid_gray;
  float base_scale = renodx_usergrading_DivideSafe(base_term, ratio, 0.0);

  if (shadows > 1.0) {
    float raised = x * (1.0 + renodx_usergrading_DivideSafe(base_term, pow(ratio, shadows), 0.0));
    float reference = x * (1.0 + base_scale);
    return max(x, x + (raised - reference));
  } else {
    float lowered = x * (1.0 + renodx_usergrading_DivideSafe(-base_term, pow(ratio, 2.0 - shadows), 0.0));
    float reference = x * (1.0 - base_scale);
    return clamp(x + (lowered - reference), 0.0, x);
  }
}

vec3 ApplyLuminosityGrading(vec3 untonemapped, float lum, UserGradingConfig config, float mid_gray) {
  if (config.exposure == 1.0 && config.shadows == 1.0 && config.highlights == 1.0 && config.contrast == 1.0 && config.flare == 0.0 && config.gamma == 1.0) {
    return untonemapped;
  }

  vec3 color = untonemapped;
  color *= config.exposure;

  float lum_gamma_adjusted = (lum < 1.0) ? pow(lum, config.gamma) : lum;

  float lum_normalized = lum_gamma_adjusted / mid_gray;
  float flare = renodx_usergrading_DivideSafe(lum_normalized + config.flare, lum_normalized, 1.0);
  float exponent = config.contrast * flare;
  float lum_contrasted = pow(lum_normalized, exponent) * mid_gray;

  float lum_highlighted = Highlights(lum_contrasted, config.highlights, mid_gray);
  float lum_shadowed = Shadows(lum_highlighted, config.shadows, mid_gray);
  float lum_final = lum_shadowed;

  color = renodx_usergrading_Luminance(color, lum, lum_final, 1.0);
  return color;
}

vec3 ApplyHueAndPurityGrading(
    vec3 ungraded_bt2020,
    vec3 reference_bt2020,
    float lum,
    UserGradingConfig config) {
  vec3 color_bt2020 = ungraded_bt2020;
  if (config.saturation == 1.0 && config.dechroma == 0.0 && config.hue_emulation == 0.0 && config.purity_emulation == 0.0 && config.highlight_saturation == 0.0) {
    return color_bt2020;
  }

  float curve_gamma = 1.0;
  vec2 mb_white_override = vec2(-1.0);
  float t_min = 1e-7;

  float kNearWhiteEpsilon = renodx_color_macleod_boynton_MB_NEAR_WHITE_EPSILON;
  vec2 white = (mb_white_override.x >= 0.0 && mb_white_override.y >= 0.0)
                   ? mb_white_override
                   : renodx_color_macleod_boynton_MB_White_D65();

  float color_purity01 = renodx_color_macleod_boynton_ApplyBT2020(
                             color_bt2020, 1.0, 1.0, mb_white_override, t_min,
                             renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE)
                             .purityCur01;

  if (config.hue_emulation != 0.0 || config.purity_emulation != 0.0) {
    float reference_purity01 = renodx_color_macleod_boynton_ApplyBT2020(
                                   reference_bt2020, 1.0, 1.0, mb_white_override, t_min,
                                   renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE)
                                   .purityCur01;

    float purity_current = color_purity01;
    float purity_ratio = 1.0;
    vec3 hue_seed_bt2020 = color_bt2020;

    if (config.hue_emulation != 0.0) {
      vec3 target_lms =
          renodx_color_macleod_boynton_XYZ_TO_LMS_2006 * (renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT * color_bt2020);
      vec3 reference_lms =
          renodx_color_macleod_boynton_XYZ_TO_LMS_2006 * (renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT * reference_bt2020);

      float target_t = target_lms.x + target_lms.y;
      if (target_t > t_min) {
        vec2 target_direction = renodx_color_macleod_boynton_MB_From_LMS(target_lms) - white;
        vec2 reference_direction = renodx_color_macleod_boynton_MB_From_LMS(reference_lms) - white;

        float target_len_sq = dot(target_direction, target_direction);
        float reference_len_sq = dot(reference_direction, reference_direction);

        if (target_len_sq > kNearWhiteEpsilon || reference_len_sq > kNearWhiteEpsilon) {
          vec2 target_unit = (target_len_sq > kNearWhiteEpsilon)
                                 ? target_direction * inversesqrt(target_len_sq)
                                 : vec2(0.0);
          vec2 reference_unit = (reference_len_sq > kNearWhiteEpsilon)
                                    ? reference_direction * inversesqrt(reference_len_sq)
                                    : target_unit;

          if (target_len_sq <= kNearWhiteEpsilon) {
            target_unit = reference_unit;
          }

          vec2 blended_unit = mix(target_unit, reference_unit, config.hue_emulation);
          float blended_len_sq = dot(blended_unit, blended_unit);
          if (blended_len_sq <= kNearWhiteEpsilon) {
            blended_unit = (config.hue_emulation >= 0.5) ? reference_unit : target_unit;
            blended_len_sq = dot(blended_unit, blended_unit);
          }
          blended_unit *= inversesqrt(max(blended_len_sq, 1e-20));

          float seed_len = sqrt(max(target_len_sq, 0.0));
          if (seed_len <= 1e-6) {
            seed_len = sqrt(max(reference_len_sq, 0.0));
          }
          seed_len = max(seed_len, 1e-6);

          hue_seed_bt2020 =
              renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT * (renodx_color_macleod_boynton_LMS_TO_XYZ_2006 * renodx_color_macleod_boynton_LMS_From_MB_T(white + blended_unit * seed_len, target_t));

          float purity_post = renodx_color_macleod_boynton_ApplyBT2020(
                                  hue_seed_bt2020, 1.0, 1.0, mb_white_override, t_min,
                                  renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE)
                                  .purityCur01;
          purity_ratio = renodx_usergrading_SafeDivision(purity_current, purity_post, 1.0);
          purity_current = purity_post;
        }
      }
    }

    if (config.purity_emulation != 0.0) {
      float target_purity_ratio = renodx_usergrading_SafeDivision(reference_purity01, purity_current, 1.0);
      purity_ratio = mix(purity_ratio, target_purity_ratio, config.purity_emulation);
    }

    float applied_purity01 = renodx_usergrading_saturate(purity_current * max(purity_ratio, 0.0));
    color_bt2020 = renodx_color_macleod_boynton_ApplyBT2020(
                       hue_seed_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min,
                       renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE)
                       .rgbOut;
    color_purity01 = applied_purity01;
  }

  float purity_scale = 1.0;

  if (config.dechroma != 0.0) {
    purity_scale *= mix(1.0, 0.0, renodx_usergrading_saturate(pow(lum / (10000.0 / 100.0), (1.0 - config.dechroma))));
  }

  if (config.highlight_saturation != 0.0) {
    float percent_max = renodx_usergrading_saturate(lum * 100.0 / 10000.0);
    float blowout_strength = 100.0;
    float blowout_change = pow(1.0 - percent_max, blowout_strength * abs(config.highlight_saturation));
    if (config.highlight_saturation < 0.0) {
      blowout_change = 2.0 - blowout_change;
    }

    purity_scale *= blowout_change;
  }

  purity_scale *= config.saturation;

  if (purity_scale != 1.0) {
    float scaled_purity01 = renodx_usergrading_saturate(color_purity01 * max(purity_scale, 0.0));
    color_bt2020 = renodx_color_macleod_boynton_ApplyBT2020(
                       color_bt2020, scaled_purity01, curve_gamma, mb_white_override, t_min,
                       renodx_color_macleod_boynton_MB_PURITY_ADJUST_NONE)
                       .rgbOut;
  }

  return color_bt2020;
}

#endif  // SRC_GAMES_RDR2VK_MACLEOD_BOYNTON_GLSL_
