#include "../canvas.glsl"
#include "../common.glsl"
#include "./filmgrain.glsl"
#include "./tonemaprdr2extended.glsl"

float GetTonemapClampMax() {
  return (UNCLAMP_HIGHLIGHTS != 0.f) ? 3.40282346638528859812e+38 : 65504.0;
}

vec3 InverseReinhardScalablePiecewise(vec3 color, float channel_max, float shoulder) {
  float channel_min = 0.0;
  float exposure = (channel_max * (channel_min * shoulder + channel_min - shoulder))
                   / (shoulder * (shoulder - channel_max));

  vec3 numerator = -channel_max * (channel_min * color + channel_min - color);
  vec3 denominator = exposure * (vec3(channel_max) - color);
  vec3 inversed = DivideSafe(numerator, denominator, vec3(65504.0));

  return mix(color, inversed, step(vec3(shoulder), color));
}

// f_p(x) = (p * x) / sqrt(x*x + p*p)
float Neutwo(float x, float peak) {
  float p = peak;
  float numerator = p * x;
  float denominator_squared = fma(x, x, p * p);
  return numerator * inversesqrt(denominator_squared);
}

vec3 Neutwo(vec3 x, float peak) {
  float p = peak;
  vec3 numerator = p * x;
  vec3 denominator_squared = fma(x, x, vec3(p * p));
  return numerator * inversesqrt(denominator_squared);
}

vec3 Neutwo(vec3 x, vec3 peak) {
  vec3 numerator = peak * x;
  vec3 denominator_squared = fma(x, x, peak * peak);
  return numerator * inversesqrt(denominator_squared);
}

// f(x) = x / sqrt(x*x + 1)
float Neutwo(float x) {
  float numerator = x;
  float denominator_squared = fma(x, x, 1.0);
  return numerator * inversesqrt(denominator_squared);
}

// f_ci(x) = (c * p * x) / sqrt(-x*x*(c*c - p*p) + (c*c * p*p))
vec3 Neutwo_Inverse(vec3 x, float peak, float clip) {
  float p = peak;
  float c = clip;
  float cc = c * c;
  float pp = p * p;
  vec3 xx = x * x;

  vec3 numerator = (c * p) * x;
  vec3 denominator_squared = fma(-xx, vec3(cc - pp), vec3(cc * pp));

  return numerator * inversesqrt(denominator_squared);
}

vec3 ApplyAnchoredAdaptationContrast(
    vec3 color,
    float contrast,
    vec3 anchor_in,
    vec3 anchor_out,
    float flare,
    float highlights,
    float shadows) {
  vec3 ax = abs(color);
  vec3 normalized = ax / anchor_in;
  vec3 flare_ratio = vec3(1.0) + DivideSafe(vec3(flare), normalized + flare, vec3(0.0));
  vec3 exponent = contrast * flare_ratio;

  vec3 ax_n = pow(ax, exponent);
  vec3 anchor_n = pow(anchor_in, exponent);
  vec3 response_target = ax_n / (ax_n + anchor_n);
  vec3 response_baseline = ax / (ax + anchor_in);
  vec3 gain = DivideSafe(response_target, response_baseline, vec3(0.0));

  vec3 contrasted_normalized = ax * gain / anchor_in;

  if (highlights != 1.0) {
    vec3 highlight_distance = max(contrasted_normalized - 1.0, vec3(0.0));
    contrasted_normalized += highlight_distance * (pow(vec3(1.0) + highlight_distance * highlight_distance, vec3((highlights - 1.0) / 2.0)) - 1.0);
  }

  if (shadows != 1.0) {
    vec3 shadow_distance = max(vec3(1.0) - contrasted_normalized, vec3(0.0));
    contrasted_normalized *= pow(vec3(1.0) + shadow_distance * shadow_distance * shadow_distance, vec3(shadows - 1.0));
  }

  return sign(color) * contrasted_normalized * anchor_out;
}

// Exact power contrast through the anchor to every derivative, with C-infinity
// flare and grading joins, then smoothly bounds highlight displacement to one stop.
float ApplyAnchoredCInfinityBoundedPowerContrast(
    float color,
    float contrast,
    float anchor_in,
    float anchor_out,
    float flare,
    float highlights,
    float shadows) {
  float ax = abs(color);
  float normalized = ax / anchor_in;
  float exponent = contrast;

  if (flare > 0.0) {
    float shadow_distance = clamp(1.0 - normalized, 0.0, 1.0);
    float flat_shadow_weight = exp2(-normalized / shadow_distance);
    exponent *= fma(flat_shadow_weight, flare / (normalized + flare), 1.0);
  }

  float input_stops = log2(normalized);
  float highlight_stops = max(input_stops, 0.0);
  float contrast_displacement = (contrast - 1.0) * highlight_stops;
  float displacement_magnitude = abs(contrast_displacement);
  float bounded_displacement = contrast_displacement / fma(displacement_magnitude, exp2(-1.0 / displacement_magnitude), 1.0);
  float output_stops = fma(exponent, min(input_stops, 0.0), highlight_stops + bounded_displacement);
  float contrasted_normalized = exp2(output_stops);

  if (highlights != 1.0) {
    float highlight_distance = max(contrasted_normalized - 1.0, 0.0);
    float highlight_distance_squared = highlight_distance * highlight_distance;
    float flat_highlight_distance = (1.0 + highlight_distance_squared) * exp2(-1.0 / highlight_distance_squared);
    contrasted_normalized += highlight_distance * (pow(1.0 + flat_highlight_distance, (highlights - 1.0) / 2.0) - 1.0);
  }

  if (shadows != 1.0) {
    float shadow_distance = clamp(1.0 - contrasted_normalized, 0.0, 1.0);
    float shadow_distance_squared = shadow_distance * shadow_distance;
    float flat_shadow_distance = shadow_distance_squared * shadow_distance * exp2(1.0 - 1.0 / shadow_distance_squared);
    contrasted_normalized *= pow(1.0 + flat_shadow_distance, shadows - 1.0);
  }

  return sign(color) * contrasted_normalized * anchor_out;
}

vec3 ApplyAnchoredCInfinityBoundedPowerContrast(
    vec3 color,
    float contrast,
    vec3 anchor_in,
    vec3 anchor_out,
    float flare,
    float highlights,
    float shadows) {
  vec3 ax = abs(color);
  vec3 normalized = ax / anchor_in;
  vec3 exponent = vec3(contrast);

  if (flare > 0.0) {
    vec3 shadow_distance = clamp(vec3(1.0) - normalized, vec3(0.0), vec3(1.0));
    vec3 flat_shadow_weight = exp2(-normalized / shadow_distance);
    exponent *= fma(flat_shadow_weight, vec3(flare) / (normalized + flare), vec3(1.0));
  }

  vec3 input_stops = log2(normalized);
  vec3 highlight_stops = max(input_stops, vec3(0.0));
  vec3 contrast_displacement = (contrast - 1.0) * highlight_stops;
  vec3 displacement_magnitude = abs(contrast_displacement);
  vec3 bounded_displacement = contrast_displacement / fma(displacement_magnitude, exp2(-vec3(1.0) / displacement_magnitude), vec3(1.0));
  vec3 output_stops = fma(exponent, min(input_stops, vec3(0.0)), highlight_stops + bounded_displacement);
  vec3 contrasted_normalized = exp2(output_stops);

  if (highlights != 1.0) {
    vec3 highlight_distance = max(contrasted_normalized - 1.0, vec3(0.0));
    vec3 highlight_distance_squared = highlight_distance * highlight_distance;
    vec3 flat_highlight_distance = (vec3(1.0) + highlight_distance_squared) * exp2(-vec3(1.0) / highlight_distance_squared);
    contrasted_normalized += highlight_distance * (pow(vec3(1.0) + flat_highlight_distance, vec3((highlights - 1.0) / 2.0)) - 1.0);
  }

  if (shadows != 1.0) {
    vec3 shadow_distance = clamp(vec3(1.0) - contrasted_normalized, vec3(0.0), vec3(1.0));
    vec3 shadow_distance_squared = shadow_distance * shadow_distance;
    vec3 flat_shadow_distance = shadow_distance_squared * shadow_distance * exp2(vec3(1.0) - vec3(1.0) / shadow_distance_squared);
    contrasted_normalized *= pow(vec3(1.0) + flat_shadow_distance, vec3(shadows - 1.0));
  }

  return sign(color) * contrasted_normalized * anchor_out;
}

// Identity through anchor to every derivative; then approaches peak
// monotonically and concave down. Requires anchor < peak and compression_strength >= 1.
float ApplyAnchoredCInfinityShoulder(float color, float peak, float anchor, float compression_strength) {
  float shoulder_range = peak - anchor;
  float distance_from_anchor = max(color - anchor, 0.0);
  float flat_weight = exp2(-shoulder_range / (compression_strength * distance_from_anchor));
  float response_denominator = fma(distance_from_anchor, flat_weight, shoulder_range);
  return fma(shoulder_range, distance_from_anchor / response_denominator, color - distance_from_anchor);
}

vec3 ApplyAnchoredCInfinityShoulder(vec3 color, vec3 peak, vec3 anchor, float compression_strength) {
  vec3 shoulder_range = peak - anchor;
  vec3 distance_from_anchor = max(color - anchor, vec3(0.0));
  vec3 flat_weight = exp2(-shoulder_range / (compression_strength * distance_from_anchor));
  vec3 response_denominator = fma(distance_from_anchor, flat_weight, shoulder_range);
  return fma(shoulder_range, distance_from_anchor / response_denominator, color - distance_from_anchor);
}

float ApplyAnchoredCInfinityShoulderMaxChannelScale(vec3 color, float peak, float anchor, float compression_strength) {
  float max_channel = max(max(abs(color.r), abs(color.g)), abs(color.b));
  float compressed_max = ApplyAnchoredCInfinityShoulder(max_channel, peak, anchor, compression_strength);
  return DivideSafe(compressed_max, max_channel, 1.0);
}

vec3 ApplyToneMap(vec3 _676, bool _679, float _638, float _m6, uint _m4, float _m10, vec3 _488, vec4 _489) {
  vec3 untonemapped = _676;
  vec3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    vec3 _742;
    if (_679) {
      vec3 _719 = max(vec3(0.0), _676 * (_638 / _m6));
      vec3 _722 = _719 * _488.x;
      _742 = (((((_719 * (_722 + vec3(_489.x))) + vec3(_489.y)) / ((_719 * (_722 + vec3(_488.y))) + vec3(_489.z))) - vec3(_489.w)) * ((_m4 != 0u) ? _m10 : _488.z)) * _m6;
    } else {  // (x * (A * x + C) + D)/(x * (A * x + B) + E) - F
      vec3 _685 = max(vec3(0.0), _676 * _638);
      vec3 _688 = _685 * _488.x;
      _742 = clamp(((((_685 * (_688 + vec3(_489.x))) + vec3(_489.y)) / ((_685 * (_688 + vec3(_488.y))) + vec3(_489.z))) - vec3(_489.w)) * _488.z, vec3(0.0), vec3(1.0));
    }
    tonemapped = _742;
  } else if (RENODX_TONE_MAP_TYPE == 1.f || RENODX_TONE_MAP_TYPE == 2.f) {  // (x * (A * x + C) + D)/(x * (A * x + B) + E) - F
    // Hable/U2-ish form, values found at night in Saint Denis
    float A = abs(_488.x);                 // 0.22, A
    float B = abs(_488.y);                 // 0.3, B
    float C = abs(_489.x);                 // 0.03, C * D?
    float D = abs(_489.y);                 // 0.0, actually E?
    float E = abs(_489.z);                 // 0.06
    float F = abs(_489.w);                 // 0.0
    float white_precompute = abs(_488.z);  // 1.12
    float pivot_point = rdr2_tonemap_FindSecondDerivativeRootMax(A, B, C, D, E);

    untonemapped = max(vec3(0.0), untonemapped * _638);
    if (RENODX_TONE_MAP_TYPE == 1.f) {  // Enhanced
      vec3 bt709_white_lms = renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(1.0));
      untonemapped = renodx_tonemap_psycho22_StockmanLMSFromBT709(untonemapped);

      float anchor_out = rdr2_tonemap_Apply(pivot_point, A, B, C, D, E, F, white_precompute);
      vec3 anchor_out_lms = renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(anchor_out));
      float pivot_slope = rdr2_tonemap_Derivative(pivot_point, A, B, C, D, E, F) * white_precompute;
      tonemapped = ApplyAnchoredAdaptationContrast(untonemapped, (2.0 * pivot_slope * pivot_point / anchor_out - 1.0) * 1.22, renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(pivot_point)), anchor_out_lms, 0.10f * pow(0.72f, 10.f), 1.f, 1.f);
      // tonemapped = ApplyAnchoredCInfinityBoundedPowerContrast(untonemapped, (pivot_slope * pivot_point / anchor_out), renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(pivot_point)), anchor_out_lms, 0.10f * pow(0.72f, 10.f), 1.f, 1.f);

      vec3 precompression_lms = tonemapped;
      float precompression_yf = renodx_color_yf_from_LMS(precompression_lms);
      vec3 peak_white_lms = renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS));
      vec3 compressed_lms = ApplyAnchoredCInfinityShoulder(precompression_lms, peak_white_lms, anchor_out_lms, 2.f);

      tonemapped = renodx_tonemap_psycho23_ApplySignedOpponentRetentionAndGamutCompressionLMS(
          precompression_lms,
          compressed_lms,
          renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(pivot_point)),
          renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(anchor_out)),
          peak_white_lms,
          1.0,
          1.0);
      tonemapped *= DivideSafe(precompression_yf, renodx_color_yf_from_LMS(tonemapped), 1.0);
      tonemapped = renodx_tonemap_psycho22_BT709FromStockmanLMS(tonemapped);
    } else {  // Vanilla+
      vec3 base = rdr2_tonemap_Apply(untonemapped, A, B, C, D, E, F, white_precompute);
      tonemapped = rdr2_tonemap_ApplyExtended(untonemapped, base, pivot_point, white_precompute, A, B, C, D, E, F);
      tonemapped = mix(tonemapped, base, RENODX_TONE_MAP_BLEND_STRENGTH);

      float uncompressed_yf = renodx_color_yf_from_BT709(tonemapped);

      tonemapped = ApplyAnchoredCInfinityShoulder(tonemapped, vec3(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS), vec3(rdr2_tonemap_Apply(pivot_point, A, B, C, D, E, F, white_precompute)), 2.f);
      float compressed_yf = renodx_color_yf_from_BT709(tonemapped);

      tonemapped *= DivideSafe(uncompressed_yf, compressed_yf, 1.0);
    }
  } else {
    vec3 _685 = max(vec3(0.0), _676 * _638);
    vec3 _688 = _685 * _488.x;
    tonemapped = clamp(((((_685 * (_688 + vec3(_489.x))) + vec3(_489.y)) / ((_685 * (_688 + vec3(_488.y))) + vec3(_489.z))) - vec3(_489.w)) * _488.z, vec3(0.0), vec3(1.0));
  }

  return tonemapped;
}

vec3 EncodeLUTInput(vec3 x, float _m11, float _m12, float _m13, float _m14, bool skip_encoding) {
  if (CUSTOM_LUT_ENCODING != 0.f) {  // sRGB-like encoding (defaults to 2.2, controlled by the SDR gamma slider)
    return EncodeRDR2Gamma(x);
  } else {  // vanilla (2.2 sRGB-like in SDR, none in HDR)
    vec3 encoded = mix(
        mix(
            (pow(x, vec3(_m12)) * _m13) - vec3(_m14),
            x * _m11,
            lessThan(x, vec3(0.0031308))),
        x, bvec3(skip_encoding));

    return encoded;
  }
}

vec3 EncodeLUTInput(vec3 x) {
  return (CUSTOM_LUT_ENCODING != 0.f) ? EncodeRDR2Gamma(x) : x;
}

vec3 DecodeLUTInput(vec3 lut_output, vec3 lut_input, float compression_scale) {
  if (CUSTOM_LUT_ENCODING != 0.f) {  // Custom encoded domain
    lut_output = DecodeSRGB(lut_output) / compression_scale;
    if (CUSTOM_LUT_STRENGTH != 1.f) {
      lut_output = mix(DecodeSRGB(lut_input), lut_output, CUSTOM_LUT_STRENGTH);
    }
    // if (RENODX_TONE_MAP_TYPE == 1.f) {
    //   lut_output = DecodeRDR2Gamma(EncodeSRGB(lut_output));
    // }
  } else {
    lut_output = mix(lut_input, lut_output / compression_scale, CUSTOM_LUT_STRENGTH);
  }
  return lut_output;
}

vec3 DecodeLUTInput(vec3 lut_output, vec3 lut_input) {
  return DecodeLUTInput(lut_output, lut_input, 1.f);
}

float ComputeMaxChannelScale(vec3 color) {
  float max_channel = max(max(abs(color.r), abs(color.g)), abs(color.b));
  float new_max = ApplyAnchoredCInfinityShoulder(max_channel, 1.f, 0.18f, 2.f);
  float scale = (max_channel != 0.0) ? (new_max / max_channel) : 1.0;
  return scale;
}

float ComputeMaxChannelScale(vec3 color, float peak) {
  float max_channel = max(max(abs(color.r), abs(color.g)), abs(color.b));
  float new_max = ApplyAnchoredCInfinityShoulder(max_channel, peak, 0.18f, 2.f);
  float scale = (max_channel != 0.0) ? (new_max / max_channel) : 1.0;
  return scale;
}

float CompressLUTInput(vec3 color, bool use_encoding, uint _m5, float _m7, float _m8, float _m9) {
  float compression_scale;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float maxch = max(max(color.x, max(color.y, color.z)), 10e-05);
    compression_scale = (use_encoding && (!(_m5 != 0u))) ? 1.0 : (((maxch > _m7) ? ((maxch * _m8) + _m9) : maxch) / maxch);
  } else if (RENODX_TONE_MAP_TYPE == 1.f || RENODX_TONE_MAP_TYPE == 2.f) {
    compression_scale = ComputeMaxChannelScale(color);
  } else {
    compression_scale = 1.f;
  }

  return compression_scale;
}

vec3 CompressLUTInput(vec3 color, bool use_encoding, uint _m5, float _m7, float _m8, float _m9, out float compression_scale) {
  bool use_custom_encoding = CUSTOM_LUT_ENCODING != 0.f;
  vec3 compression_input = use_custom_encoding ? DecodeSRGB(color) : color;

  compression_scale = CompressLUTInput(compression_input, use_encoding, _m5, _m7, _m8, _m9);
  compression_input *= compression_scale;

  return use_custom_encoding ? EncodeSRGB(compression_input) : compression_input;
}

vec3 CompressLUTInputAlt(vec3 color, uint _m3, float _m7, float _m8, float _m9, out float compression_scale) {
  bool use_custom_encoding = CUSTOM_LUT_ENCODING != 0.f;
  vec3 compression_input = use_custom_encoding ? DecodeSRGB(color) : color;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float maxch = max(max(compression_input.x, max(compression_input.y, compression_input.z)), 10e-05);
    compression_scale = (_m3 != 0u) ? (((maxch > _m7) ? ((maxch * _m8) + _m9) : maxch) / maxch) : 1.0;
  } else if (RENODX_TONE_MAP_TYPE == 1.f || RENODX_TONE_MAP_TYPE == 2.f) {
    compression_scale = ComputeMaxChannelScale(compression_input);
  } else {
    compression_scale = 1.f;
  }

  compression_input *= compression_scale;

  return use_custom_encoding ? EncodeSRGB(compression_input) : compression_input;
}

vec3 ApplyGradingAndDisplayMap(vec3 ungraded_bt709, vec2 texcoord) {
  if (IS_TONEMAPPED == 0.f) {
    ungraded_bt709 = GammaSafe(ungraded_bt709, false);

    vec3 ungraded_bt2020 = BT2020FromBT709(ungraded_bt709);
    vec3 graded_bt2020;
    if (RENODX_TONE_MAP_TYPE != 0.f && RENODX_TONE_MAP_TYPE != 3.f) {
      const UserGradingConfig cg_config = {
        1.f,                                                  // float exposure;
        RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
        1.f,                                                  // float contrast_highlights;
        RENODX_TONE_MAP_SHADOWS,                              // float shadows;
        1.f,                                                  // float contrast_shadows;
        RENODX_TONE_MAP_CONTRAST,                             // float contrast;
        0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
        RENODX_TONE_MAP_GAMMA,                                // float gamma;
        RENODX_TONE_MAP_SATURATION,                           // float saturation;
        RENODX_TONE_MAP_DECHROMA,                             // float dechroma;
        -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
        0.f,                                                  // float hue_emulation;
        0.f                                                   // float purity_emulation;
      };

      float yf = renodx_color_yf_from_BT2020(ungraded_bt2020);
      graded_bt2020 = ApplyLuminanceGrading(ungraded_bt2020, yf, cg_config, 0.15f);
      graded_bt2020 = ApplyHueAndPurityGrading(graded_bt2020, ungraded_bt2020, yf, cg_config);
      graded_bt2020 = max(vec3(0.0), graded_bt2020);

      if (RENODX_TONE_MAP_TYPE == 1.f || RENODX_TONE_MAP_TYPE == 2.f) {
        float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
        graded_bt2020 *= ComputeMaxChannelScale(graded_bt2020, peak_ratio);
      }

    } else {
      graded_bt2020 = ungraded_bt2020;
    }

    if (CUSTOM_GRAIN_STRENGTH > 0.f) {
      graded_bt2020 = ApplyFilmGrainBT2020(graded_bt2020, texcoord, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.03f);
    }

    vec3 graded_bt709 = BT709FromBT2020(graded_bt2020);

    if (RENODX_TONE_MAP_TYPE != 0.f) {
      graded_bt709 *= vec3(RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);
    }

    graded_bt709 = GammaSafe(graded_bt709, true);

    return graded_bt709;
  } else {
    return ungraded_bt709;
  }
}
