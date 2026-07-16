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
    base = rdr2_tonemap_Apply(untonemapped, A, B, C, D, E, F, white_precompute);
    tonemapped = rdr2_tonemap_ApplyExtended(untonemapped, base, pivot_point, white_precompute, A, B, C, D, E, F);
    tonemapped = mix(tonemapped, base, RENODX_TONE_MAP_BLEND_STRENGTH);

    float uncompressed_yf = renodx_color_yf_from_BT709(tonemapped);
    tonemapped = Neutwo(tonemapped, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    float compressed_yf = renodx_color_yf_from_BT709(tonemapped);
    tonemapped *= DivideSafe(uncompressed_yf, compressed_yf, 1.0);
  } else {
    vec3 _685 = max(vec3(0.0), _676 * _638);
    vec3 _688 = _685 * _488.x;
    tonemapped = clamp(((((_685 * (_688 + vec3(_489.x))) + vec3(_489.y)) / ((_685 * (_688 + vec3(_488.y))) + vec3(_489.z))) - vec3(_489.w)) * _488.z, vec3(0.0), vec3(1.0));
  }

  return tonemapped;
}

vec3 EncodeLUTInput(vec3 x, float _m11, float _m12, float _m13, float _m14, bool skip_encoding) {
  if (CUSTOM_LUT_ENCODING != 0.f && IS_TONEMAPPED == 0.f) {  // sRGB-like encoding (defaults to 2.2, controlled by the SDR gamma slider)
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

vec3 DecodeLUTInput(vec3 lut_output, vec3 lut_input, float compression_scale) {
  if (CUSTOM_LUT_ENCODING != 0.f && IS_TONEMAPPED == 0.f) {  // sRGB
    lut_output = DecodeSRGB(lut_output) / compression_scale;
    if (CUSTOM_LUT_STRENGTH != 1.f) {
      lut_output = mix(DecodeSRGB(lut_input), lut_output, CUSTOM_LUT_STRENGTH);
    }
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

vec3 CompressLUTInput(vec3 color, bool use_encoding, uint _m5, float _m7, float _m8, float _m9, out float compression_scale) {
  bool use_custom_encoding = CUSTOM_LUT_ENCODING != 0.f && IS_TONEMAPPED == 0.f;
  vec3 compression_input = use_custom_encoding ? DecodeSRGB(color) : color;

  compression_scale = CompressLUTInput(compression_input, use_encoding, _m5, _m7, _m8, _m9);
  compression_input *= compression_scale;

  return use_custom_encoding ? EncodeSRGB(compression_input) : compression_input;
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
      if (RENODX_SDR_EOTF_EMULATION != 0.f) ungraded_bt2020 = CorrectGammaMismatchBT2020ByYf(ungraded_bt2020, false);

      const UserGradingConfig cg_config = {
        RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
        RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
        RENODX_TONE_MAP_HIGHLIGHT_CONTRAST,                   // float contrast_highlights;
        RENODX_TONE_MAP_SHADOWS,                              // float shadows;
        RENODX_TONE_MAP_SHADOW_CONTRAST,                      // float contrast_shadows;
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
      graded_bt2020 = ApplyLuminosityGrading(ungraded_bt2020, yf, cg_config, 0.15f);
      graded_bt2020 = ApplyHueAndPurityGrading(graded_bt2020, ungraded_bt2020, yf, cg_config);
      graded_bt2020 = max(vec3(0.0), graded_bt2020);

      if (RENODX_TONE_MAP_TYPE == 2.f) {
        float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
        graded_bt2020 *= ComputeMaxChannelScale(graded_bt2020, peak_ratio);
      }

      if (RENODX_SDR_EOTF_EMULATION != 0.f) graded_bt2020 = CorrectGammaMismatchBT2020ByYf(graded_bt2020, true);

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
