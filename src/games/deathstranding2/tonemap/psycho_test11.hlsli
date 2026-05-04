#ifndef RENODX_SHADERS_TONEMAP_PSYCHO_TEST11_HLSL_
#define RENODX_SHADERS_TONEMAP_PSYCHO_TEST11_HLSL_

namespace renodx_custom {
namespace tonemap {
namespace psycho {

static const float3x3 PSYCHO11_BT709_TO_XYZ_MAT = float3x3(
    0.4123907993f, 0.3575843394f, 0.1804807884f,
    0.2126390059f, 0.7151686788f, 0.0721923154f,
    0.0193308187f, 0.1191947798f, 0.9505321522f);

static const float3x3 PSYCHO11_XYZ_TO_BT709_MAT = float3x3(
    3.2409699419f, -1.5373831776f, -0.4986107603f,
    -0.9692436363f, 1.8759675015f, 0.0415550574f,
    0.0556300797f, -0.2039769589f, 1.0569715142f);

static const float3x3 PSYCHO11_BT2020_TO_XYZ_MAT = float3x3(
    0.6369580483f, 0.1446169036f, 0.1688809752f,
    0.2627002120f, 0.6779980715f, 0.0593017165f,
    0.0000000000f, 0.0280726930f, 1.0609850577f);

static const float3x3 PSYCHO11_XYZ_TO_BT2020_MAT = float3x3(
    1.7166511880f, -0.3556707838f, -0.2533662814f,
    -0.6666843518f, 1.6164812366f, 0.0157685458f,
    0.0176398574f, -0.0427706133f, 0.9421031212f);

static const float3x3 PSYCHO11_XYZ_TO_STOCKMAN_SHARP_LMS_MAT = float3x3(
    0.2670502842655792f, 0.8471990148492798f, -0.03470416612462053f,
    -0.38706882411220156f, 1.165429935890458f, 0.10302286696614202f,
    0.026727793989083093f, -0.02729131667566509f, 0.5333267257603284f);

static const float3 PSYCHO11_CIE1702_MB_CIE_WEIGHTS = float3(
    0.68990272f, 0.34832189f, 0.0371597f);

static const float2 PSYCHO11_WHITE_POINT_D65 = float2(0.31272f, 0.32903f);
// Precomputed psycho11_MB2FromLMS(XYZ_TO_LMS(xyY(D65, 1))).xy
static const float2 PSYCHO11_WHITE_D65_MB = float2(0.6983281224f, 0.0204761309f);

float psycho11_DivideSafe(float dividend, float divisor, float fallback) {
  return divisor == 0.f ? fallback : (dividend / divisor);
}

float3 psycho11_SignPow(float3 x, float3 exponent) {
  return float3(
      (x.x < 0.f ? -1.f : 1.f) * pow(abs(x.x), exponent.x),
      (x.y < 0.f ? -1.f : 1.f) * pow(abs(x.y), exponent.y),
      (x.z < 0.f ? -1.f : 1.f) * pow(abs(x.z), exponent.z));
}

float3x3 psycho11_Invert3x3(float3x3 m) {
  float a = m[0][0], b = m[0][1], c = m[0][2];
  float d = m[1][0], e = m[1][1], f = m[1][2];
  float g = m[2][0], h = m[2][1], i = m[2][2];

  float A = (e * i - f * h);
  float B = -(d * i - f * g);
  float C = (d * h - e * g);
  float D = -(b * i - c * h);
  float E = (a * i - c * g);
  float F = -(a * h - b * g);
  float G = (b * f - c * e);
  float H = -(a * f - c * d);
  float I = (a * e - b * d);

  float det = a * A + b * B + c * C;
  float inv_det = psycho11_DivideSafe(1.f, det, 0.f);

  return float3x3(
             A, D, G,
             B, E, H,
             C, F, I)
         * inv_det;
}

float3 psycho11_XYZFromxyY(float3 xyY) {
  float3 xyz;
  xyz.xz = float2(xyY.x, (1.f - xyY.x - xyY.y)) / xyY.y * xyY.z;
  xyz.y = xyY.z;
  return xyz;
}

float3 psycho11_BT2020FromBT709(float3 bt709) {
  return mul(PSYCHO11_XYZ_TO_BT2020_MAT, mul(PSYCHO11_BT709_TO_XYZ_MAT, bt709));
}

float3 psycho11_BT709FromBT2020(float3 bt2020) {
  return mul(PSYCHO11_XYZ_TO_BT709_MAT, mul(PSYCHO11_BT2020_TO_XYZ_MAT, bt2020));
}

float3 psycho11_LMSFromBT2020(float3 bt2020) {
  float3 xyz = mul(PSYCHO11_BT2020_TO_XYZ_MAT, bt2020);
  return mul(PSYCHO11_XYZ_TO_STOCKMAN_SHARP_LMS_MAT, xyz);
}

float3 psycho11_BT2020FromLMS(float3 lms_abs) {
  float3x3 lms_to_xyz = psycho11_Invert3x3(PSYCHO11_XYZ_TO_STOCKMAN_SHARP_LMS_MAT);
  float3 xyz = mul(lms_to_xyz, lms_abs);
  return mul(PSYCHO11_XYZ_TO_BT2020_MAT, xyz);
}

float psycho11_StockmanLuminanceFromLMS(float3 lms_abs) {
  return dot(lms_abs, float3(0.68990272f, 0.34832189f, 0.0f));
}

float psycho11_StockmanLuminanceFromBT2020(float3 bt2020) {
  float3 lms_abs = psycho11_LMSFromBT2020(bt2020);
  return psycho11_StockmanLuminanceFromLMS(lms_abs);
}

float psycho11_StockmanLuminanceFromBT709(float3 bt709) {
  float3 bt2020 = psycho11_BT2020FromBT709(bt709);
  return psycho11_StockmanLuminanceFromBT2020(bt2020);
}

float3 psycho11_MB2FromLMS(float3 lms_abs) {
  const float mb2_eps = 1e-12f;

  float weighted_l = PSYCHO11_CIE1702_MB_CIE_WEIGHTS.x * lms_abs.x;
  float weighted_m = PSYCHO11_CIE1702_MB_CIE_WEIGHTS.y * lms_abs.y;
  float y_mb = weighted_l + weighted_m;
  if (y_mb <= mb2_eps) return 0.f.xxx;

  float inv = psycho11_DivideSafe(1.f, y_mb, 0.f);
  return float3(
      weighted_l * inv,
      PSYCHO11_CIE1702_MB_CIE_WEIGHTS.z * lms_abs.z * inv,
      y_mb);
}

float3 psycho11_LMSFromMB2(float3 mb2_lsy) {
  float l = mb2_lsy.x;
  float s = mb2_lsy.y;
  float y = max(mb2_lsy.z, 0.f);

  float L = psycho11_DivideSafe(l * y, PSYCHO11_CIE1702_MB_CIE_WEIGHTS.x, 0.f);
  float M = psycho11_DivideSafe((1.f - l) * y, PSYCHO11_CIE1702_MB_CIE_WEIGHTS.y, 0.f);
  float S = psycho11_DivideSafe(s * y, PSYCHO11_CIE1702_MB_CIE_WEIGHTS.z, 0.f);
  return float3(L, M, S);
}

float2 psycho11_WhiteD65Chromaticity() {
  return PSYCHO11_WHITE_D65_MB;
}

float psycho11_Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {  // highlights < 1
    float b = mid_gray * pow(x / mid_gray, 2.f - highlights);
    float t = min(x, 1.f);
    return min(x, psycho11_DivideSafe(x * x, lerp(x, b, t), x));
  }
}

float psycho11_Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(psycho11_DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = psycho11_DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + psycho11_DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {  // shadows < 1
    float lowered = x * (1.f - psycho11_DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float psycho11_ContrastAndFlare(
    float x,
    float contrast,
    float contrast_highlights,
    float contrast_shadows,
    float flare,
    float mid_gray = 0.18f) {
  if (contrast == 1.f && flare == 0.f && contrast_highlights == 1.f && contrast_shadows == 1.f) return x;

  const float x_normalized = x / mid_gray;
  const float split_contrast = (x < mid_gray) ? contrast_shadows : contrast_highlights;
  float flare_ratio = psycho11_DivideSafe(x_normalized + flare, x_normalized, 1.f);
  float exponent = contrast * split_contrast * flare_ratio;
  return pow(x_normalized, exponent) * mid_gray;
}

float psycho11_Neutwo(float x) {
  return x * rsqrt(mad(x, x, 1.f));
}

float psycho11_Neutwo(float x, float peak) {
  return (peak * x) * rsqrt(mad(x, x, peak * peak));
}

float psycho11_Neutwo(float x, float peak, float clip) {
  float cc = clip * clip;
  float pp = peak * peak;
  float xx = x * x;
  float numerator = clip * peak * x;
  float denominator_squared = mad(xx, (cc - pp), cc * pp);
  return numerator * rsqrt(denominator_squared);
}

// f_{mi}\left(x\right)=\frac{qzx\left(cc-gg\right)}{\sqrt{\left(cc-gg\right)\cdot\left(-xx\cdot\left(cczz-qqgg\right)+ccgg\cdot\left(qq-zz\right)\right)}}-m
float psycho11_NeutwoMin(float x, float peak, float clip, float gray_in, float gray_out, float minimum) {
  float m = minimum;
  float g = gray_in;
  float z = gray_out - m;
  float q = peak - m;
  float c = clip;

  float cc = c * c;
  float gg = g * g;
  float cc_minus_gg = cc - gg;

  float numerator = q * z * x * cc_minus_gg;

  float xx = x * x;
  float zz = z * z;
  float qq = q * q;

  float cczz = cc * zz;
  float qqgg = qq * gg;
  float ccgg = cc * gg;

  float denominator_squared = cc_minus_gg * mad(-xx, (cczz - qqgg), ccgg * (qq - zz));

  return mad(numerator, rsqrt(denominator_squared), -m);
}

float3 psycho11_NeutwoPerChannel(float3 color, float3 peak) {
  return float3(
      psycho11_Neutwo(color.r, peak.r),
      psycho11_Neutwo(color.g, peak.g),
      psycho11_Neutwo(color.b, peak.b));
}

float3 psycho11_NeutwoPerChannel(float3 color, float3 peak, float3 clip) {
  return float3(
      psycho11_Neutwo(color.r, peak.r, clip.r),
      psycho11_Neutwo(color.g, peak.g, clip.g),
      psycho11_Neutwo(color.b, peak.b, clip.b));
}

float3 psycho11_NeutwoPerChannelMin(float3 color, float3 peak, float3 clip, float gray_in, float gray_out, float minimum) {
  return float3(
      psycho11_NeutwoMin(color.r, peak.r, clip.r, gray_in, gray_out, minimum),
      psycho11_NeutwoMin(color.g, peak.g, clip.g, gray_in, gray_out, minimum),
      psycho11_NeutwoMin(color.b, peak.b, clip.b, gray_in, gray_out, minimum));
}

float3 psycho11_NakaRushton(float3 x, float3 peak, float3 gray, float cone_response_exponent) {
  float3 n = cone_response_exponent * peak / (peak - gray);
  float3 x_n = psycho11_SignPow(x, n);
  float3 num = peak * x_n;
  float3 den = mad(pow(gray, n - 1.f), (peak - gray), x_n);
  return num / den;
}

float3 psycho11_ComputeReinhardScale(float3 peak = 1.f, float minimum = 0.f, float3 gray_in = 0.18f, float3 gray_out = 0.18f) {
  //  s = (p * y - p * m) / (x * p - x * y)

  float3 num = peak * (gray_out - minimum);  // p * (y - m)
  float3 den = gray_in * (peak - gray_out);  // x * (p - y)

  return num / den;
}

float3 psycho11_ReinhardPiecewise(float3 x, float3 x_max = 1.f, float3 shoulder = 0.18f) {
  const float x_min = 0.f;
  float3 exposure = psycho11_ComputeReinhardScale(x_max, x_min, shoulder, shoulder);
  float3 tonemapped = mad(x, exposure, x_min) / mad(x, exposure / x_max, 1.f - x_min);

  return lerp(x, tonemapped, step(shoulder, x));
}

float psycho11_MBYFromLMS(float3 lms) {
  return PSYCHO11_CIE1702_MB_CIE_WEIGHTS.x * lms.x + PSYCHO11_CIE1702_MB_CIE_WEIGHTS.y * lms.y;
}

float2 psycho11_MBFromLMS(float3 lms) {
  float y_mb = psycho11_MBYFromLMS(lms);
  if (y_mb <= 0.f) {
    return float2(0.f, 0.f);
  }

  return float2(
      psycho11_DivideSafe(PSYCHO11_CIE1702_MB_CIE_WEIGHTS.x * lms.x, y_mb, 0.f),
      psycho11_DivideSafe(PSYCHO11_CIE1702_MB_CIE_WEIGHTS.z * lms.z, y_mb, 0.f));
}

float2 psycho11_MBFromBT2020Primary(float3 primary_rgb) {
  float3 xyz = mul(PSYCHO11_BT2020_TO_XYZ_MAT, primary_rgb);
  float3 lms = mul(PSYCHO11_XYZ_TO_STOCKMAN_SHARP_LMS_MAT, xyz);
  return psycho11_MBFromLMS(lms);
}

float psycho11_Cross2(float2 a, float2 b) {
  return a.x * b.y - a.y * b.x;
}

bool psycho11_RaySegmentHit2D(float2 origin, float2 direction, float2 a, float2 b, out float t_hit) {
  const float eps = 1e-20f;

  t_hit = 0.f;
  float2 e = b - a;
  float denom = psycho11_Cross2(direction, e);
  if (abs(denom) <= eps) return false;

  float2 ao = a - origin;
  float t = psycho11_Cross2(ao, e) / denom;
  float u = psycho11_Cross2(ao, direction) / denom;
  if (t < 0.f || u < 0.f || u > 1.f) return false;

  t_hit = t;
  return true;
}

float psycho11_RayMaxT_BT2020TriangleInMB(float2 origin, float2 direction, out bool has_solution) {
  const float interval_max = 1e30f;
  const float mb_near_white_epsilon = 1e-14f;

  has_solution = false;
  if (dot(direction, direction) <= mb_near_white_epsilon) return 0.f;

  float2 r = psycho11_MBFromBT2020Primary(float3(1.f, 0.f, 0.f));
  float2 g = psycho11_MBFromBT2020Primary(float3(0.f, 1.f, 0.f));
  float2 b = psycho11_MBFromBT2020Primary(float3(0.f, 0.f, 1.f));

  float t_best = interval_max;
  float t;
  bool hit_any = false;

  if (psycho11_RaySegmentHit2D(origin, direction, r, g, t)) {
    t_best = min(t_best, t);
    hit_any = true;
  }
  if (psycho11_RaySegmentHit2D(origin, direction, g, b, t)) {
    t_best = min(t_best, t);
    hit_any = true;
  }
  if (psycho11_RaySegmentHit2D(origin, direction, b, r, t)) {
    t_best = min(t_best, t);
    hit_any = true;
  }

  has_solution = hit_any;
  return hit_any ? max(t_best, 0.f) : 0.f;
}

float3 psycho11_GamutCompressAddWhiteBT2020Bounded(float3 lms) {
  const float mb_near_white_epsilon = 1e-14f;

  float y_mb = psycho11_MBYFromLMS(abs(lms));
  float2 white = psycho11_WhiteD65Chromaticity();

  float2 mb0 = psycho11_MBFromLMS(lms);
  float2 direction = mb0 - white;
  if (dot(direction, direction) < mb_near_white_epsilon) {
    return lms;
  }

  bool has_solution;
  float t_max = psycho11_RayMaxT_BT2020TriangleInMB(white, direction, has_solution);
  if (!has_solution) {
    return lms;
  }

  float white_ratio = max(psycho11_DivideSafe(1.f - t_max, t_max, 0.f), 0.f);
  float white_add = y_mb * white_ratio;
  float3 white_unit_lms = psycho11_LMSFromMB2(float3(white, 1.f));
  return lms + white_unit_lms * white_add;
}

float3 psycho11_RestoreHueMB2(
    float3 lms_source_raw_d65,
    float3 lms_target_raw_d65,
    float amount,
    float eps = 1e-7f) {
  if (amount <= 0.f) return lms_target_raw_d65;

  float3 mb_source = psycho11_MB2FromLMS(lms_source_raw_d65);
  float3 mb_target = psycho11_MB2FromLMS(lms_target_raw_d65);
  float2 mb_white = psycho11_WhiteD65Chromaticity();

  float2 source_offset = mb_source.xy - mb_white;
  float2 target_offset = mb_target.xy - mb_white;
  float src2 = dot(source_offset, source_offset);
  float tgt2 = dot(target_offset, target_offset);
  if (src2 <= eps || tgt2 <= eps) {
    return lms_target_raw_d65;
  }

  float2 source_dir = source_offset * rsqrt(src2);
  float2 target_dir = target_offset * rsqrt(tgt2);
  float2 blended_dir = lerp(target_dir, source_dir, amount);
  float blended_len2 = dot(blended_dir, blended_dir);
  if (blended_len2 <= eps) {
    blended_dir = target_dir;
  } else {
    blended_dir *= rsqrt(blended_len2);
  }

  float target_radius = sqrt(tgt2);
  float2 mb_restored_xy = mb_white + blended_dir * target_radius;
  float3 mb_restored = float3(mb_restored_xy, mb_target.z);
  return psycho11_LMSFromMB2(mb_restored);
}

float3 psycho11_RestoreHueBT2020(
    float3 bt2020_source,
    float3 bt2020_target,
    float amount = 1.f,
    float eps = 1e-7f) {
  if (amount == 0.f) return bt2020_target;

  float3 lms_target_raw_d65 = psycho11_LMSFromBT2020(bt2020_target);

  float3 lms_source_raw_d65 = psycho11_LMSFromBT2020(bt2020_source);
  float3 lms_out_raw_d65 = psycho11_RestoreHueMB2(
      lms_source_raw_d65,
      lms_target_raw_d65,
      amount,
      eps);

  // Keep final output inside a BT.2020-feasible region.
  lms_out_raw_d65 = psycho11_GamutCompressAddWhiteBT2020Bounded(lms_out_raw_d65);
  return psycho11_BT2020FromLMS(lms_out_raw_d65);
}

float3 psycho11_ScalePurityMB2(float3 lms_raw_d65, float purity_scale, float eps = 1e-7f) {
  if (abs(purity_scale - 1.f) <= eps) return lms_raw_d65;

  float3 mb = psycho11_MB2FromLMS(lms_raw_d65);
  float2 mb_white = psycho11_WhiteD65Chromaticity();
  float2 mb_offset = mb.xy - mb_white;
  float2 mb_scaled = mb_white + mb_offset * purity_scale;
  return psycho11_LMSFromMB2(float3(mb_scaled, mb.z));
}

float3 psycho11_ApplyPurityFromLMS(
    float3 lms_source_raw_d65,
    float3 lms_target_raw_d65,
    float amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f) {
  float3 mb_source = psycho11_MB2FromLMS(lms_source_raw_d65);
  float3 mb_target = psycho11_MB2FromLMS(lms_target_raw_d65);
  float2 mb_white = psycho11_WhiteD65Chromaticity();

  float2 source_offset = mb_source.xy - mb_white;
  float2 target_offset = mb_target.xy - mb_white;
  float src_radius = length(source_offset);
  float tgt_radius = length(target_offset);
  if (tgt_radius <= eps) return lms_target_raw_d65;

  float transfer_scale = src_radius / max(tgt_radius, eps);
  float no_purity_loss_scale = max(transfer_scale, 1.f);
  transfer_scale = lerp(transfer_scale, no_purity_loss_scale, clamp_purity_loss);
  float scale = lerp(1.f, transfer_scale, amount);
  float2 mb_scaled = mb_white + target_offset * scale;
  return psycho11_LMSFromMB2(float3(mb_scaled, mb_target.z));
}

float3 psycho11_ApplyPurityFromBT2020(
    float3 bt2020_source,
    float3 bt2020_target,
    float amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f) {
  float3 lms_target_raw_d65 = psycho11_LMSFromBT2020(bt2020_target);
  float blend = amount;

  if (blend <= 0.f) {
    float3 lms_bounded_target = psycho11_GamutCompressAddWhiteBT2020Bounded(lms_target_raw_d65);
    return psycho11_BT2020FromLMS(lms_bounded_target);
  }

  float3 lms_source_raw_d65 = psycho11_LMSFromBT2020(bt2020_source);

  float3 lms_out_raw_d65 = psycho11_ApplyPurityFromLMS(
      lms_source_raw_d65,
      lms_target_raw_d65,
      blend,
      clamp_purity_loss,
      eps);

  // Keep final output inside a BT.2020-feasible region.
  lms_out_raw_d65 = psycho11_GamutCompressAddWhiteBT2020Bounded(lms_out_raw_d65);
  return psycho11_BT2020FromLMS(lms_out_raw_d65);
}

namespace config {

struct Config {
  bool apply_tonemap;
  float peak_value;
  float exposure;
  float gamma;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float contrast_highlights;
  float contrast_shadows;
  float purity_scale;
  float purity_highlights;
  float adaptation_contrast;
  float hue_restore;
  float bleaching_intensity;
  float clip_point;
  float mid_gray;
  bool pre_gamut_compress;
  bool post_gamut_compress;
};

Config Create(
    bool apply_tonemap = true,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,
    float gamma = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float flare = 0.f,
    float contrast_highlights = 1.f,
    float contrast_shadows = 1.f,
    float purity_scale = 1.f,
    float purity_highlights = 1.f,
    float adaptation_contrast = 1.f,
    float hue_restore = 1.f,
    float bleaching_intensity = 0.f,
    float clip_point = 100.f,
    float mid_gray = 0.18f,
    bool pre_gamut_compress = true,
    bool post_gamut_compress = true) {
  const Config cg_config = {
    apply_tonemap,
    peak_value,
    exposure,
    gamma,
    highlights,
    shadows,
    contrast,
    flare,
    contrast_highlights,
    contrast_shadows,
    purity_scale,
    purity_highlights,
    adaptation_contrast,
    hue_restore,
    bleaching_intensity,
    clip_point,
    mid_gray,
    pre_gamut_compress,
    post_gamut_compress
  };
  return cg_config;
}
}  // namespace config

float3 ApplyBT2020(float3 color_bt2020, config::Config psycho_config) {
  const float kEps = 1e-7f;

  const float3 midgray_lms = psycho11_LMSFromBT2020(psycho_config.mid_gray);

  float3 color_lms_raw = psycho11_LMSFromBT2020(color_bt2020);
  if (psycho_config.pre_gamut_compress) {
    color_lms_raw = psycho11_GamutCompressAddWhiteBT2020Bounded(color_lms_raw);
  }

  float3 color_lms = color_lms_raw;
  float lum_original = renodx_custom::tonemap::psycho::psycho11_StockmanLuminanceFromLMS(color_lms_raw);

  if (psycho_config.bleaching_intensity != 0.f) {
    const float kHalfBleachTrolands = 20000.f;

    float adapted_lum = max(
        lum_original,
        0.18f);
    float3 adapted_bt2020 = adapted_lum.xxx;
    float3 lms_adapted_unit = psycho11_LMSFromBT2020(adapted_bt2020);
    float3 lms_signal_unit = color_lms;

    float3 stimulus_nits = max(lms_adapted_unit, 0.f) * 100.f;
    float3 stimulus_trolands = stimulus_nits * 4.f;
    float3 availability_raw = 1.f / (1.f + stimulus_trolands / max(kHalfBleachTrolands, kEps));
    float3 availability = lerp(1.f, availability_raw, psycho_config.bleaching_intensity);
    color_lms = lms_signal_unit * max(availability, 0.f);
  }

  if (psycho_config.apply_tonemap) {  // apply hue shift and blowout
    // tonemap
    float3 lms_peak_unit = psycho11_LMSFromBT2020(psycho_config.peak_value.xxx);

    color_lms = psycho11_ReinhardPiecewise(color_lms, lms_peak_unit, midgray_lms);

    color_lms = psycho11_RestoreHueMB2(
        color_lms_raw,
        color_lms,
        psycho_config.hue_restore,
        kEps);

    // restore original luminance
    color_lms *= psycho11_DivideSafe(
        lum_original,
        renodx_custom::tonemap::psycho::psycho11_StockmanLuminanceFromLMS(color_lms),
        1.f);
  }

  if (psycho_config.adaptation_contrast != 1.f) {
    float3 source_lms = color_lms;
    float3 lms_sigma_unit = max(midgray_lms, kEps.xxx);
    float exponent = max(psycho_config.adaptation_contrast, kEps);

    float3 ax = abs(color_lms);
    float3 ax_n = pow(ax, exponent);
    float3 s_n = pow(lms_sigma_unit, exponent);
    float3 response_target = ax_n / max(ax_n + s_n, kEps.xxx);
    float3 response_baseline = ax / max(ax + lms_sigma_unit, kEps.xxx);
    float3 gain = response_target / max(response_baseline, kEps.xxx);
    float3 sign_raw = float3(
        color_lms.x < 0.f ? -1.f : 1.f,
        color_lms.y < 0.f ? -1.f : 1.f,
        color_lms.z < 0.f ? -1.f : 1.f);
    color_lms = sign_raw * (ax * gain);

    color_lms = psycho11_RestoreHueMB2(
        source_lms,
        color_lms,
        1.f,
        kEps);
  }

  if (psycho_config.exposure != 1.f
      || psycho_config.gamma != 1.f
      || psycho_config.highlights != 1.f
      || psycho_config.shadows != 1.f
      || psycho_config.contrast != 1.f
      || psycho_config.contrast_highlights != 1.f
      || psycho_config.contrast_shadows != 1.f
      || psycho_config.flare != 0.f
      || psycho_config.purity_scale != 1.f
      || psycho_config.purity_highlights != 0.f) {
    const float midgray_lum = psycho11_StockmanLuminanceFromLMS(midgray_lms);
    float lum_target = lum_original;

    lum_target *= psycho_config.exposure;
    if (psycho_config.gamma != 1.f) {
      lum_target = select(lum_target < 1.f, pow(lum_target, psycho_config.gamma), lum_target);
    }

    if (psycho_config.highlights != 1.f) {
      lum_target = psycho11_Highlights(lum_target, psycho_config.highlights, midgray_lum);
    }

    if (psycho_config.shadows != 1.f) {
      lum_target = psycho11_Shadows(lum_target, psycho_config.shadows, midgray_lum);
    }

    if (psycho_config.contrast != 1.f
        || psycho_config.contrast_highlights != 1.f
        || psycho_config.contrast_shadows != 1.f
        || psycho_config.flare != 0.f) {
      lum_target = psycho11_ContrastAndFlare(
          lum_target,
          psycho_config.contrast,
          psycho_config.contrast_highlights,
          psycho_config.contrast_shadows,
          psycho_config.flare,
          midgray_lum);
    }

    float lum_scale = psycho11_DivideSafe(lum_target, lum_original, 1.f);
    psycho_config.clip_point *= lum_scale;
    color_lms *= lum_scale;

    float purity_scale = psycho_config.purity_scale;

    if (psycho_config.purity_highlights != 0.f) {
      float percent_max = saturate(lum_target * 100.f / 10000.f);
      float blowout_change = pow(1.f - percent_max, 100.f * abs(psycho_config.purity_highlights));
      if (psycho_config.purity_highlights < 0.f) {
        blowout_change = 2.f - blowout_change;
      }

      purity_scale *= blowout_change;
    }

    if (purity_scale != 1.f) {
      color_lms = psycho11_ScalePurityMB2(color_lms, purity_scale, kEps);
    }
  }

  if (psycho_config.post_gamut_compress) {
    color_lms = psycho11_GamutCompressAddWhiteBT2020Bounded(color_lms);
  }

  color_bt2020 = psycho11_BT2020FromLMS(color_lms);

  if (psycho_config.apply_tonemap) {  // apply maxch tonemap
    color_bt2020 = max(0, color_bt2020);
    float max_channel = max(max(color_bt2020.r, color_bt2020.g), color_bt2020.b);
    float new_max = psycho11_Neutwo(max_channel, psycho_config.peak_value, psycho_config.clip_point);
    color_bt2020 *= psycho11_DivideSafe(new_max, max_channel, 1.f);
  }

  return color_bt2020;
}

}  // namespace psycho
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_PSYCHO_TEST11_HLSL_
