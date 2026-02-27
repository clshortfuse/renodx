#include "../common.glsl"
#include "./filmgrain.glsl"
#include "./tonemaprdr2extended.glsl"

float GetTonemapClampMax() {
  return (UNCLAMP_HIGHLIGHTS != 0.f) ? 3.40282346638528859812e+38 : 65504.0;
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
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    tonemapped = untonemapped * _638;
  } else if (RENODX_TONE_MAP_TYPE == 2.f) {  // (x * (A * x + C) + D)/(x * (A * x + B) + E) - F
    untonemapped = max(vec3(0.0), untonemapped * _638);

    // Hable/U2-ish form, values found at night in Saint Denis
    float A = _488.x;                 // 0.22, A
    float B = _488.y;                 // 0.3, B
    float C = _489.x;                 // 0.03, C * D?
    float D = _489.y;                 // 0.0, actually E?
    float E = _489.z;                 // 0.06
    float F = _489.w;                 // 0.0
    float white_precompute = _488.z;  // 1.12
    float pivot_point = rdr2_tonemap_FindSecondDerivativeRootMax(A, B, C, D, E);

    vec3 base;
    if (RENODX_TONE_MAP_PER_CHANNEL == 0.f) {
      float y_in = renodx_color_macleod_boynton_LuminosityFromBT709LuminanceNormalized(untonemapped);
      float base_y = rdr2_tonemap_Apply(y_in, A, B, C, D, E, F, white_precompute);

      float y_out = rdr2_tonemap_ApplyExtended(
          y_in, base_y, pivot_point, white_precompute,
          A, B, C, D, E, F);

      // tonemapped = correctluminance(untonemapped, y_in, y_out);
      tonemapped = untonemapped * DivideSafe(y_out, y_in, 1.f);
    } else {
      base = rdr2_tonemap_Apply(untonemapped, A, B, C, D, E, F, white_precompute);
      tonemapped = rdr2_tonemap_ApplyExtended(
          untonemapped, base, pivot_point, white_precompute,
          A, B, C, D, E, F);
    }
  } else {
    vec3 _685 = max(vec3(0.0), _676 * _638);
    vec3 _688 = _685 * _488.x;
    tonemapped = clamp(((((_685 * (_688 + vec3(_489.x))) + vec3(_489.y)) / ((_685 * (_688 + vec3(_488.y))) + vec3(_489.z))) - vec3(_489.w)) * _488.z, vec3(0.0), vec3(1.0));
  }

  return tonemapped;
}

vec3 EncodeLUTInput(vec3 x, float _m11, float _m12, float _m13, float _m14, bool skip_encoding) {
  if (CUSTOM_LUT_ENCODING == 2.f) {  // sRGB
    return mix(
        x * 12.92,
        1.055 * pow(x, vec3(1.0 / 2.4)) - 0.055,
        step(vec3(0.0031308), x));
  } else if (CUSTOM_LUT_ENCODING == 1.f) {  // sRGB-like encoding (defaults to 2.2, controlled by the SDR gamma slider)
    return mix(
        (pow(x, vec3(_m12)) * _m13) - vec3(_m14),
        x * _m11,
        lessThan(x, vec3(0.0031308)));
  } else {  // vanilla (2.2 sRGB-like in SDR, none in HDR)
    return mix(
        mix(
            (pow(x, vec3(_m12)) * _m13) - vec3(_m14),
            x * _m11,
            lessThan(x, vec3(0.0031308))),
        x, bvec3(skip_encoding));
  }
}

vec3 DecodeLUTInput(vec3 lut_output, vec3 lut_input) {
  if (CUSTOM_LUT_ENCODING != 0.f) {  // sRGB
    lut_output = DecodeSRGB(lut_output);
    if (CUSTOM_LUT_STRENGTH != 1.f) {
      lut_output = mix(DecodeSRGB(lut_input), lut_output, CUSTOM_LUT_STRENGTH);
    }
  } else {
    lut_output = mix(lut_input, lut_output, CUSTOM_LUT_STRENGTH);
  }
  return lut_output;
}

float ComputeReinhardScale(float peak, float minimum, float gray_in, float gray_out) {
  // s = (p * y - p * m) / (x * p - x * y)
  float num = peak * (gray_out - minimum);  // p * (y - m)
  float den = gray_in * (peak - gray_out);  // x * (p - y)
  return num / den;
}

// Overload for default args: peak=1, minimum=0, gray_in=0.18, gray_out=0.18
float ComputeReinhardScale() {
  return ComputeReinhardScale(1.0, 0.0, 0.18, 0.18);
}

vec3 ReinhardPiecewise(vec3 x, float x_max, float shoulder) {
  const float x_min = 0.0;
  float exposure = ComputeReinhardScale(x_max, x_min, shoulder, shoulder);

  vec3 tonemapped =
      (x * exposure + x_min) / (x * (exposure / x_max) + (1.0 - x_min));

  return mix(x, tonemapped, step(vec3(shoulder), x));
}

// f_p(x) = (p * x) / sqrt(x*x + p*p)
float Neutwo(float x, float peak) {
  float p = peak;
  float numerator = p * x;
  float denominator_squared = fma(x, x, p * p);
  return numerator * inversesqrt(denominator_squared);
}

// f(x) = x / sqrt(x*x + 1)
float Neutwo(float x) {
  float numerator = x;
  float denominator_squared = fma(x, x, 1.0);
  return numerator * inversesqrt(denominator_squared);
}

float ComputeMaxChannelScale(vec3 color) {
  float max_channel = max(max(abs(color.r), abs(color.g)), abs(color.b));
  float new_max = Neutwo(max_channel);
  float scale = (max_channel != 0.0) ? (new_max / max_channel) : 1.0;
  return scale;
}

float ComputeMaxChannelScale(vec3 color, float peak) {
  float max_channel = max(max(abs(color.r), abs(color.g)), abs(color.b));
  float new_max = Neutwo(max_channel, peak);
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

float CompressLUTInputAlt(vec3 color, uint _m3, float _m7, float _m8, float _m9) {
  float compression_scale;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float maxch = max(max(color.x, max(color.y, color.z)), 10e-05);
    compression_scale = (_m3 != 0u) ? (((maxch > _m7) ? ((maxch * _m8) + _m9) : maxch) / maxch) : 1.0;
  } else if (RENODX_TONE_MAP_TYPE == 1.f || RENODX_TONE_MAP_TYPE == 2.f) {
    compression_scale = ComputeMaxChannelScale(color);
  } else {
    compression_scale = 1.f;
  }

  return compression_scale;
}

vec3 ApplyGradingAndDisplayMap(vec3 ungraded_bt709, vec2 texcoord) {
  if (IS_TONEMAPPED == 0.f) {
    vec3 ungraded_bt2020 = BT2020FromBT709(ungraded_bt709);
    vec3 graded_bt2020;
    if (RENODX_TONE_MAP_TYPE != 0.f && RENODX_TONE_MAP_TYPE != 3.f) {
      const UserGradingConfig cg_config = {
        RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
        RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
        RENODX_TONE_MAP_SHADOWS,                              // float shadows;
        RENODX_TONE_MAP_CONTRAST,                             // float contrast;
        0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
        1.f,                                                  // float gamma;
        RENODX_TONE_MAP_SATURATION,                           // float saturation;
        RENODX_TONE_MAP_DECHROMA,                             // float dechroma;
        -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
        RENODX_TONE_MAP_HUE_SHIFT,                            // float hue_emulation;
        RENODX_TONE_MAP_BLOWOUT                               // float purity_emulation;
      };

      vec3 hue_purity_reference_bt2020 = ReinhardPiecewise(ungraded_bt2020, 6.f, 1.f);

      float lum = renodx_color_macleod_boynton_LuminosityFromBT2020LuminanceNormalized(ungraded_bt2020);
      graded_bt2020 = ApplyLuminosityGrading(ungraded_bt2020, lum, cg_config, 0.18f);
      graded_bt2020 = ApplyHueAndPurityGrading(graded_bt2020, hue_purity_reference_bt2020, lum, cg_config);
      graded_bt2020 = max(vec3(0.0), graded_bt2020);

      if (RENODX_TONE_MAP_TYPE == 2.f) {
        float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
        if (RENODX_SDR_EOTF_EMULATION != 0.f) peak_ratio = CorrectGammaMismatch(peak_ratio, true);
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
      if (RENODX_SDR_EOTF_EMULATION == 0.f) {
        graded_bt709 *= vec3(RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);
      } else {
        graded_bt709 = CorrectGammaMismatch(graded_bt709, false);
        graded_bt709 *= vec3(RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);
        graded_bt709 = CorrectGammaMismatch(graded_bt709, true);
      }
    }

    return graded_bt709;
  } else {
    return ungraded_bt709;
  }
}
