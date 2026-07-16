#ifndef SRC_GAMES_RDR2VK_PERCEPTUAL_COLOR_GLSL_
#define SRC_GAMES_RDR2VK_PERCEPTUAL_COLOR_GLSL_

// RDR2VK perceptual color transforms, grading, Yf, and PsychoV gamut mapping.
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

const mat3 renodx_color_XYZ_TO_STOCKMAN_SHARP_LMS_MAT = mat3(
  vec3(0.2670502842655792, -0.38706882411220156, 0.026727793989083093),
  vec3(0.8471990148492798, 1.165429935890458, -0.02729131667566509),
  vec3(-0.03470416612462053, 0.10302286696614202, 0.5333267257603284));

const mat3 renodx_color_STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT = mat3(
  vec3(1.94735469, 0.68990272, 0.0),
  vec3(-1.41445123, 0.34832189, 0.0),
  vec3(0.36476327, 0.0, 1.93485343));

const vec2 renodx_color_macleod_boynton_WHITE_POINT_D65 = vec2(0.31272, 0.32903);

const float renodx_color_macleod_boynton_EPSILON = 1e-20;
const float renodx_color_macleod_boynton_INTERVAL_MAX = 1e30;
const float renodx_color_macleod_boynton_MB_NEAR_WHITE_EPSILON = 1e-14;

vec3 renodx_color_macleod_boynton_LMS_From_BT709(vec3 bt709_linear) {
  return renodx_color_macleod_boynton_XYZ_TO_LMS_2006
         * (renodx_color_macleod_boynton_BT709_TO_XYZ_MAT * bt709_linear);
}

vec3 renodx_color_macleod_boynton_BT709_From_LMS(vec3 lms) {
  return renodx_color_macleod_boynton_XYZ_TO_BT709_MAT
         * (renodx_color_macleod_boynton_LMS_TO_XYZ_2006 * lms);
}

float renodx_color_macleod_boynton_DivideSafe(float a, float b, float fallback) {
  return (b == 0.0) ? fallback : (a / b);
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
  float purityCur01;
};

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyInternal(
    vec3 rgb_linear, float purity_value, float curve_gamma,
    vec2 mb_white_override, float t_min,
    mat3 rgb_to_xyz_mat, mat3 xyz_to_rgb_mat) {
  renodx_color_macleod_boynton_MBPurityDebug result;
  result.rgbOut = rgb_linear;
  result.purityCur01 = 0.0;

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
    return result;
  }

  float t_max = max(0.0, t_hi);
  float p_cur = (t_max > renodx_color_macleod_boynton_EPSILON)
                    ? renodx_color_macleod_boynton_DivideSafe(1.0, t_max, 0.0)
                    : 0.0;
  result.purityCur01 = clamp(p_cur, 0.0, 1.0);

  float purity = pow(clamp(purity_value, 0.0, 1.0), max(curve_gamma, 1e-6));
  float t_final = purity * t_max;

  vec2 mb_final = white + t_final * direction;
  vec3 lms_final = renodx_color_macleod_boynton_LMS_From_MB_T(mb_final, t);
  vec3 xyz_final = renodx_color_macleod_boynton_LMS_TO_XYZ_2006 * lms_final;
  vec3 rgb_final = xyz_to_rgb_mat * xyz_final;
  result.rgbOut = max(rgb_final, vec3(0.0));
  return result;
}

renodx_color_macleod_boynton_MBPurityDebug renodx_color_macleod_boynton_ApplyBT2020(
    vec3 rgb2020_linear, float purity01, float curve_gamma, vec2 mb_white_override,
    float t_min) {
  return renodx_color_macleod_boynton_ApplyInternal(
      rgb2020_linear, purity01, curve_gamma, mb_white_override, t_min,
      renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT,
      renodx_color_macleod_boynton_XYZ_TO_BT2020_MAT);
}

float renodx_color_yf_from_LMS(vec3 lms) {
  return (renodx_color_STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT * lms).y;
}

float renodx_color_yf_from_BT709(vec3 bt709_linear) {
  vec3 xyz = renodx_color_macleod_boynton_BT709_TO_XYZ_MAT * bt709_linear;
  return renodx_color_yf_from_LMS(renodx_color_XYZ_TO_STOCKMAN_SHARP_LMS_MAT * xyz);
}

float renodx_color_yf_from_BT2020(vec3 bt2020_linear) {
  vec3 xyz = renodx_color_macleod_boynton_BT2020_TO_XYZ_MAT * bt2020_linear;
  return renodx_color_yf_from_LMS(renodx_color_XYZ_TO_STOCKMAN_SHARP_LMS_MAT * xyz);
}

struct UserGradingConfig {
  float exposure;
  float highlights;
  float contrast_highlights;
  float shadows;
  float contrast_shadows;
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
    float t = 0.0;
    if (x > mid_gray) {
      t = renodx_usergrading_saturate(log2(x / mid_gray) / log2(1.0 / mid_gray));
    }
    t = t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
    return mix(x, mid_gray * pow(x / mid_gray, highlights), t);
  } else {
    float b = mid_gray * pow(x / mid_gray, 2.0 - highlights);
    float t = 0.0;
    if (x > mid_gray) {
      t = renodx_usergrading_saturate(log2(x / mid_gray) / log2(1.0 / mid_gray));
    }
    t = t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
    return renodx_usergrading_DivideSafe(x * x, mix(x, b, t), x);
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
    float shadow_floor = mid_gray / 16.0;
    float t = 1.0;
    if (x > shadow_floor) {
      t = renodx_usergrading_saturate(log2(x / mid_gray) / log2(shadow_floor / mid_gray));
    }
    t = t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
    return x + (raised - reference) * t;
  } else {
    float lowered = x * (1.0 - renodx_usergrading_DivideSafe(base_term, pow(ratio, 2.0 - shadows), 0.0));
    float reference = x * (1.0 - base_scale);
    float shadow_floor = mid_gray / 16.0;
    float t = 1.0;
    if (x > shadow_floor) {
      t = renodx_usergrading_saturate(log2(x / mid_gray) / log2(shadow_floor / mid_gray));
    }
    t = t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
    return x + (lowered - reference) * t;
  }
}

float ContrastAndFlare(
    float x, float contrast, float contrast_highlights, float contrast_shadows,
    float flare, float mid_gray) {
  if (contrast == 1.0 && flare == 0.0 && contrast_highlights == 1.0 && contrast_shadows == 1.0) {
    return x;
  }

  float x_normalized = x / mid_gray;
  float split_contrast = (x < mid_gray) ? contrast_shadows : contrast_highlights;
  float flare_ratio = renodx_usergrading_DivideSafe(x_normalized + flare, x_normalized, 1.0);
  float exponent = contrast * split_contrast * flare_ratio;
  return pow(x_normalized, exponent) * mid_gray;
}

vec3 ApplyLuminosityGrading(vec3 untonemapped, float lum, UserGradingConfig config, float mid_gray) {
  if (config.exposure == 1.0 && config.shadows == 1.0 && config.highlights == 1.0 && config.contrast == 1.0
      && config.contrast_highlights == 1.0 && config.contrast_shadows == 1.0 && config.flare == 0.0 && config.gamma == 1.0) {
    return untonemapped;
  }

  vec3 color = untonemapped;
  color *= config.exposure;

  float lum_gamma_adjusted = (lum < 1.0) ? pow(lum, config.gamma) : lum;

  float lum_contrasted = ContrastAndFlare(
      lum_gamma_adjusted,
      config.contrast,
      config.contrast_highlights,
      config.contrast_shadows,
      config.flare,
      mid_gray);

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
                             color_bt2020, 1.0, 1.0, mb_white_override, t_min)
                             .purityCur01;

  if (config.hue_emulation != 0.0 || config.purity_emulation != 0.0) {
    float reference_purity01 = renodx_color_macleod_boynton_ApplyBT2020(
                                   reference_bt2020, 1.0, 1.0, mb_white_override, t_min)
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
                                  hue_seed_bt2020, 1.0, 1.0, mb_white_override, t_min)
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
                       hue_seed_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
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
                       color_bt2020, scaled_purity01, curve_gamma, mb_white_override, t_min)
                       .rgbOut;
  }

  return color_bt2020;
}



// GLSL port of the BT.709-bound device-hull compression used by PsychoV test22.
const vec3 renodx_tonemap_psycho22_LMS_WEIGHTS = vec3(
    0.68990272,
    0.34832189,
    0.0371597069161);

const mat3 renodx_tonemap_psycho22_STOCKMAN_LMS_TO_XYZ_MAT = mat3(
    vec3(1.8114629636873623, 0.6069124057314326, -0.0597250591701978),
    vec3(-1.3081492612535468, 0.4159062592830001, 0.08684090099781155),
    vec3(0.37056946406094754, -0.04084825533137022, 1.8543617734965625));

const float renodx_tonemap_psycho22_GAMUT_EPSILON = 1e-20;
const float renodx_tonemap_psycho22_MB_NEAR_WHITE_EPSILON = 1e-14;
const float renodx_tonemap_psycho22_CIE1702_RAY_T_MAX = 1e20;
const int renodx_tonemap_psycho22_CIE1702_EDGE_COUNT = 7;

const vec2 renodx_tonemap_psycho22_CIE1702_HALFSPACE_NORMALS[renodx_tonemap_psycho22_CIE1702_EDGE_COUNT] = vec2[](
    vec2(-0.043889, -0.006807),
    vec2(-0.007821, -0.008564),
    vec2(-0.000604, -0.007942),
    vec2(0.0, -0.080835),
    vec2(0.953597, 0.307020),
    vec2(-0.060969, 0.019752),
    vec2(-0.106895, 0.004035));

const float renodx_tonemap_psycho22_CIE1702_HALFSPACE_NUMERATORS[renodx_tonemap_psycho22_CIE1702_EDGE_COUNT] = float[](
    0.0065035249,
    0.00104900495,
    0.000207697044,
    0.00165556648,
    0.252472349,
    0.0241967351,
    0.0199621232);

vec3 renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3 bt709) {
  return renodx_color_XYZ_TO_STOCKMAN_SHARP_LMS_MAT
         * (renodx_color_macleod_boynton_BT709_TO_XYZ_MAT * bt709);
}

vec3 renodx_tonemap_psycho22_BT709FromStockmanLMS(vec3 lms) {
  return renodx_color_macleod_boynton_XYZ_TO_BT709_MAT
         * (renodx_tonemap_psycho22_STOCKMAN_LMS_TO_XYZ_MAT * lms);
}

vec3 renodx_tonemap_psycho22_WeighLMS(vec3 lms) {
  return lms * renodx_tonemap_psycho22_LMS_WEIGHTS;
}

vec3 renodx_tonemap_psycho22_UnweighLMS(vec3 weighted_lms) {
  return weighted_lms / renodx_tonemap_psycho22_LMS_WEIGHTS;
}

vec3 renodx_tonemap_psycho22_DivideSafe(vec3 numerator, vec3 denominator, vec3 fallback) {
  return vec3(
      renodx_color_macleod_boynton_DivideSafe(numerator.x, denominator.x, fallback.x),
      renodx_color_macleod_boynton_DivideSafe(numerator.y, denominator.y, fallback.y),
      renodx_color_macleod_boynton_DivideSafe(numerator.z, denominator.z, fallback.z));
}

vec3 renodx_tonemap_psycho22_MBFromWeightedLMS(vec3 weighted_lms) {
  float y_mb = max(weighted_lms.x + weighted_lms.y, 0.0);
  float inverse_y = renodx_color_macleod_boynton_DivideSafe(1.0, y_mb, 0.0);
  return vec3(weighted_lms.x * inverse_y, weighted_lms.z * inverse_y, y_mb);
}

vec3 renodx_tonemap_psycho22_WeightedLMSFromMB(vec2 mb, float y_mb) {
  return vec3(mb.x, 1.0 - mb.x, mb.y) * y_mb;
}

vec2 renodx_tonemap_psycho22_CIE1702WhiteChromaticity() {
  vec3 d65_xyz = renodx_color_macleod_boynton_xyz_from_xyY(
      vec3(renodx_color_macleod_boynton_WHITE_POINT_D65, 1.0));
  return renodx_tonemap_psycho22_MBFromWeightedLMS(
             renodx_tonemap_psycho22_WeighLMS(
                 renodx_color_XYZ_TO_STOCKMAN_SHARP_LMS_MAT * d65_xyz))
      .xy;
}

float renodx_tonemap_psycho22_RayExitTCIE1702(vec2 origin, vec2 direction) {
  if (dot(direction, direction) <= renodx_tonemap_psycho22_MB_NEAR_WHITE_EPSILON) {
    return renodx_tonemap_psycho22_CIE1702_RAY_T_MAX;
  }

  vec2 white_to_origin = renodx_tonemap_psycho22_CIE1702WhiteChromaticity() - origin;
  float t_best = renodx_tonemap_psycho22_CIE1702_RAY_T_MAX;
  bool hit_any = false;

  for (int i = 0; i < renodx_tonemap_psycho22_CIE1702_EDGE_COUNT; ++i) {
    vec2 halfspace_normal = renodx_tonemap_psycho22_CIE1702_HALFSPACE_NORMALS[i];
    float denominator = dot(halfspace_normal, direction);
    float numerator = renodx_tonemap_psycho22_CIE1702_HALFSPACE_NUMERATORS[i]
                      + dot(halfspace_normal, white_to_origin);
    float t = denominator > 1e-8
                  ? numerator / denominator
                  : renodx_tonemap_psycho22_CIE1702_RAY_T_MAX;
    t_best = min(t_best, t);
    hit_any = hit_any || (denominator > 1e-8);
  }

  return hit_any ? max(t_best, 0.0) : renodx_tonemap_psycho22_CIE1702_RAY_T_MAX;
}

float renodx_tonemap_psycho22_Cross2(vec2 a, vec2 b) {
  return a.x * b.y - a.y * b.x;
}

bool renodx_tonemap_psycho22_RaySegmentHit2D(
    vec2 origin, vec2 direction, vec2 a, vec2 b, out float t_hit) {
  t_hit = 0.0;
  vec2 edge = b - a;
  float denominator = renodx_tonemap_psycho22_Cross2(direction, edge);
  if (abs(denominator) <= renodx_tonemap_psycho22_GAMUT_EPSILON) return false;

  vec2 a_origin = a - origin;
  float t = renodx_tonemap_psycho22_Cross2(a_origin, edge) / denominator;
  float u = renodx_tonemap_psycho22_Cross2(a_origin, direction) / denominator;
  if (t < 0.0 || u < 0.0 || u > 1.0) return false;

  t_hit = t;
  return true;
}

float renodx_tonemap_psycho22_RayMaxTRGBTriangleInMB(
    vec2 origin, vec2 direction, vec2 r, vec2 g, vec2 b, out bool has_solution) {
  has_solution = false;
  if (dot(direction, direction) <= renodx_tonemap_psycho22_MB_NEAR_WHITE_EPSILON) return 0.0;

  float t_best = 3.402823466e38;
  float t_hit;
  bool hit_any = false;

  if (renodx_tonemap_psycho22_RaySegmentHit2D(origin, direction, r, g, t_hit)) {
    t_best = min(t_best, t_hit);
    hit_any = true;
  }
  if (renodx_tonemap_psycho22_RaySegmentHit2D(origin, direction, g, b, t_hit)) {
    t_best = min(t_best, t_hit);
    hit_any = true;
  }
  if (renodx_tonemap_psycho22_RaySegmentHit2D(origin, direction, b, r, t_hit)) {
    t_best = min(t_best, t_hit);
    hit_any = true;
  }

  has_solution = hit_any;
  return hit_any ? max(t_best, 0.0) : 0.0;
}

float renodx_tonemap_psycho22_NeutwoPeakClip(float x, float peak, float clip) {
  float peak_safe = max(peak, 0.0);
  float clip_safe = max(clip, peak_safe);
  float x_squared = x * x;
  float clip_squared = clip_safe * clip_safe;
  float peak_squared = peak_safe * peak_safe;
  float denominator_squared = fma(
      x_squared, clip_squared - peak_squared, clip_squared * peak_squared);
  return (clip_safe * peak_safe * x)
         * inversesqrt(max(denominator_squared, renodx_tonemap_psycho22_GAMUT_EPSILON));
}

float renodx_tonemap_psycho22_NeutwoScaleFromRayT(float t_peak, float t_clip) {
  float t_peak_safe = max(t_peak, 0.0);
  float t_clip_safe = max(t_clip, t_peak_safe);
  return clamp(
      renodx_tonemap_psycho22_NeutwoPeakClip(1.0, t_peak_safe, t_clip_safe),
      0.0,
      1.0);
}

float renodx_tonemap_psycho22_SoftCompressionActivationFromRayT(float t_peak) {
  float outside = 1.0 - clamp(t_peak, 0.0, 1.0);
  return renodx_color_macleod_boynton_DivideSafe(outside, outside + 0.08, 0.0);
}

vec3 renodx_tonemap_psycho22_ClampWeightedLMSToCIE1702(vec3 weighted_lms) {
  vec3 weighted_lms_clamped = max(weighted_lms, vec3(0.0));
  vec3 mb = renodx_tonemap_psycho22_MBFromWeightedLMS(weighted_lms_clamped);
  float y_mb = mb.z;
  if (!(y_mb > renodx_tonemap_psycho22_GAMUT_EPSILON)) {
    return vec3(weighted_lms_clamped.xy, 0.0);
  }

  vec2 white = renodx_tonemap_psycho22_CIE1702WhiteChromaticity();
  vec2 direction = mb.xy - white;
  if (dot(direction, direction) <= renodx_tonemap_psycho22_MB_NEAR_WHITE_EPSILON) {
    return weighted_lms_clamped;
  }

  float t_clip = renodx_tonemap_psycho22_RayExitTCIE1702(white, direction);
  float t_final = min(1.0, t_clip);
  return renodx_tonemap_psycho22_WeightedLMSFromMB(white + direction * t_final, y_mb);
}

void renodx_tonemap_psycho22_MakeBT709TriangleInAdaptiveMB(
    vec3 current_adaptive_state_lms, out vec2 r, out vec2 g, out vec2 b) {
  vec3 weighted_r = renodx_tonemap_psycho22_WeighLMS(
                        renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(1.0, 0.0, 0.0)))
                    / current_adaptive_state_lms;
  vec3 weighted_g = renodx_tonemap_psycho22_WeighLMS(
                        renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(0.0, 1.0, 0.0)))
                    / current_adaptive_state_lms;
  vec3 weighted_b = renodx_tonemap_psycho22_WeighLMS(
                        renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(0.0, 0.0, 1.0)))
                    / current_adaptive_state_lms;

  r = renodx_tonemap_psycho22_MBFromWeightedLMS(weighted_r).xy;
  g = renodx_tonemap_psycho22_MBFromWeightedLMS(weighted_g).xy;
  b = renodx_tonemap_psycho22_MBFromWeightedLMS(weighted_b).xy;
}

vec3 renodx_tonemap_psycho22_GamutCompressAdaptiveRelativeWeightedLMSBoundBT709(
    vec3 relative_weighted_lms, vec3 current_adaptive_state_lms, float strength) {
  vec3 weighted_lms_clamped = renodx_tonemap_psycho22_ClampWeightedLMSToCIE1702(
      max(relative_weighted_lms, vec3(0.0)));
  vec3 mb = renodx_tonemap_psycho22_MBFromWeightedLMS(weighted_lms_clamped);
  float y_mb = mb.z;
  if (!(y_mb > renodx_tonemap_psycho22_GAMUT_EPSILON)) {
    return vec3(weighted_lms_clamped.xy, 0.0);
  }

  vec2 white = renodx_tonemap_psycho22_CIE1702WhiteChromaticity();
  vec2 direction = mb.xy - white;
  if (dot(direction, direction) <= renodx_tonemap_psycho22_MB_NEAR_WHITE_EPSILON) {
    return weighted_lms_clamped;
  }

  vec2 bound_r;
  vec2 bound_g;
  vec2 bound_b;
  renodx_tonemap_psycho22_MakeBT709TriangleInAdaptiveMB(
      current_adaptive_state_lms, bound_r, bound_g, bound_b);

  bool has_peak = false;
  float t_peak = renodx_tonemap_psycho22_RayMaxTRGBTriangleInMB(
      white, direction, bound_r, bound_g, bound_b, has_peak);
  float t_clip = renodx_tonemap_psycho22_RayExitTCIE1702(white, direction);
  if (!has_peak) {
    t_peak = t_clip;
  }

  float t_hard = clamp(t_peak, 0.0, 1.0);
  float t_soft = renodx_tonemap_psycho22_NeutwoScaleFromRayT(
      min(t_peak, t_clip), t_clip);
  float soft_mix = clamp(strength, 0.0, 1.0)
                   * renodx_tonemap_psycho22_SoftCompressionActivationFromRayT(t_peak);
  float t_final = mix(t_hard, t_soft, soft_mix);

  return renodx_tonemap_psycho22_WeightedLMSFromMB(
      white + t_final * direction, y_mb);
}

vec3 renodx_tonemap_psycho22_GamutCompressBT709(
    vec3 bt709, vec3 current_adaptive_state_bt709, float strength) {
  vec3 current_adaptive_state_lms = renodx_tonemap_psycho22_StockmanLMSFromBT709(
      current_adaptive_state_bt709);
  vec3 relative_weighted_lms = renodx_tonemap_psycho22_DivideSafe(
      renodx_tonemap_psycho22_WeighLMS(
          renodx_tonemap_psycho22_StockmanLMSFromBT709(bt709)),
      current_adaptive_state_lms,
      vec3(0.0));

  relative_weighted_lms = renodx_tonemap_psycho22_GamutCompressAdaptiveRelativeWeightedLMSBoundBT709(
      relative_weighted_lms,
      current_adaptive_state_lms,
      strength);

  vec3 output_lms = renodx_tonemap_psycho22_UnweighLMS(
      relative_weighted_lms * max(current_adaptive_state_lms, vec3(1e-6)));
  return renodx_tonemap_psycho22_BT709FromStockmanLMS(output_lms);
}


#endif  // SRC_GAMES_RDR2VK_PERCEPTUAL_COLOR_GLSL_
