#ifndef SRC_GAMES_RDR2_TONEMAP_GLSL_
#define SRC_GAMES_RDR2_TONEMAP_GLSL_

#extension GL_EXT_samplerless_texture_functions : require

#include "../common.glsl"
#include "./tonemaprdr2extended.glsl"
#include "./c_infinity_rolloff.glsl"
#include "./filmgrain.glsl"
#include "../customtest31.glsl"

vec3 CompressWeaponWheelInput(
    vec3 color, out float compression_scale) {
  compression_scale = 1.0;
  float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_TONE_MAP_TYPE == 0.f || peak <= 1.0) return color;

  vec3 linear_color = pow(max(color, vec3(0.0)), vec3(2.2));
  compression_scale = CInfinityRollOffComputeMaxChannelScale(linear_color, 1.0, 0.05363781, 1.5, peak);
  return pow(max(linear_color * compression_scale, vec3(0.0)), vec3(1.0 / 2.2));
}

vec3 RestoreWeaponWheelOutput(vec3 color, float compression_scale) {
  if (RENODX_TONE_MAP_TYPE == 0.f || RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS <= 1.0) return color;
  vec3 linear_color = pow(max(color, vec3(0.0)), vec3(2.2));
  linear_color = DivideSafe(linear_color, vec3(compression_scale));
  return pow(max(linear_color, vec3(0.0)), vec3(1.0 / 2.2));
}

vec3 ConditionalClampMax(vec3 color) {
  if (UNCLAMP_HIGHLIGHTS == 0.f) {
    return min(color, vec3(65504.0));
  }
  return color;
}

vec3 ApplyToneMap(
    vec3 color, float exposure, bool native_hdr,
    float native_hdr_scale, uint use_hdr_normalization, float hdr_normalization,
    float a, float b, float c_times_b, float d_times_e,
    float d_times_f, float e_over_f, float white_precompute,
    out float midgray_in, out float midgray_out, out float slope) {
  midgray_in = 0.0;
  midgray_out = 0.0;
  slope = 0.0;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    if (native_hdr) {
      vec3 exposed = max(vec3(0.0), color * (exposure / native_hdr_scale));
      return rdr2_tonemap_Apply(exposed, a, b, c_times_b, d_times_e, d_times_f, e_over_f,
                                (use_hdr_normalization != 0u) ? hdr_normalization : white_precompute)
             * native_hdr_scale;
    } else {
      vec3 exposed = max(vec3(0.0), color * exposure);
      return clamp(rdr2_tonemap_Apply(exposed, a, b, c_times_b, d_times_e, d_times_f, e_over_f, white_precompute), vec3(0.0), vec3(1.0));
    }
  } else {
    vec3 exposed = max(vec3(0.0), color * exposure);

    if (RENODX_TONE_MAP_TYPE == 1.f) {
      vec3 base = rdr2_tonemap_Apply(exposed, a, b, c_times_b, d_times_e, d_times_f, e_over_f, white_precompute);
      float pivot = rdr2_tonemap_FindSecondDerivativeRootMax(a, b, c_times_b, d_times_e, d_times_f);
      return rdr2_tonemap_ApplyExtended(exposed, base, pivot, white_precompute, a, b, c_times_b, d_times_e, d_times_f, e_over_f);
    } else {
      midgray_in = rdr2_tonemap_FindSecondDerivativeRootMax(a, b, c_times_b, d_times_e, d_times_f);
      midgray_out = rdr2_tonemap_Apply(
          midgray_in, a, b, c_times_b, d_times_e, d_times_f, e_over_f, white_precompute);
      slope = rdr2_tonemap_Derivative(
                  midgray_in, a, b, c_times_b, d_times_e, d_times_f, e_over_f)
              * white_precompute;
      return exposed * DivideSafe(midgray_out, midgray_in, 1.0);
    }
  }
}

vec3 EncodeRDR2Gamma(vec3 color_linear) {
  float curve_gamma = 2.2;
  float curve_toe_threshold = 0.0031308;
  float curve_power = 1.0 / curve_gamma;
  float curve_offset = 0.055 * (curve_gamma - 1.0) / (2.4 - 1.0);
  float curve_scale = 1.0 + curve_offset;
  float curve_toe_slope = (pow(curve_toe_threshold, curve_power) * curve_scale - curve_offset) / curve_toe_threshold;
  return mix(
      pow(color_linear, vec3(curve_power)) * curve_scale - vec3(curve_offset),
      color_linear * curve_toe_slope,
      lessThan(color_linear, vec3(curve_toe_threshold)));
}

vec3 DecodeRDR2Gamma(vec3 color_encoded) {
  float curve_gamma = 2.2;
  float curve_toe_threshold = 0.0031308;
  float curve_power = 1.0 / curve_gamma;
  float curve_offset = 0.055 * (curve_gamma - 1.0) / (2.4 - 1.0);
  float curve_scale = 1.0 + curve_offset;
  float curve_toe_slope = (pow(curve_toe_threshold, curve_power) * curve_scale - curve_offset) / curve_toe_threshold;
  float encoded_toe_threshold = curve_toe_threshold * curve_toe_slope;  // Approximately 0.0290067

  return mix(
      pow((color_encoded + vec3(curve_offset)) / curve_scale, vec3(curve_gamma)),
      color_encoded / curve_toe_slope,
      lessThan(color_encoded, vec3(encoded_toe_threshold)));
}

float Gamma(float color, bool pow_to_srgb) {
  if (pow_to_srgb) {
    float encoded = pow(color, 1.0 / 2.2);
    return encoded <= 0.04045 ? encoded / 12.92 : pow((encoded + 0.055) / 1.055, 2.4);
  }
  return pow(SRGBEncode(vec3(color)).x, 2.2);
}

vec3 ApplyAnchoredTonalGrading(
    vec3 color, vec3 anchor_in, vec3 anchor_out,
    float contrast, float flare, float highlight_contrast, float shadow_contrast,
    float highlights, float shadows) {
  if (contrast == 1.0 && flare == 0.0
      && highlight_contrast == 1.0 && shadow_contrast == 1.0
      && highlights == 1.0 && shadows == 1.0
      && all(equal(anchor_in, anchor_out))) return color;

  vec3 normalized = color / anchor_in;
  vec3 graded_normalized = normalized;
  if (contrast != 1.0 || flare > 0.0) {
    vec3 exponent = vec3(contrast);
    if (flare > 0.0) {
      vec3 shadow_distance = clamp(1.0 - normalized, vec3(0.0), vec3(1.0));
      vec3 flat_shadow_weight = exp2(-normalized / shadow_distance);
      exponent *= fma(flat_shadow_weight, flare / (normalized + flare), vec3(1.0));
    }
    vec3 input_stops = log2(normalized);
    vec3 highlight_stops = max(input_stops, vec3(0.0));
    vec3 output_highlight_stops = highlight_stops;
    if (contrast != 1.0) {
      vec3 displacement = (contrast - 1.0) * highlight_stops;
      vec3 displacement_magnitude = abs(displacement);
      output_highlight_stops += displacement
                                / fma(displacement_magnitude, exp2(-1.0 / displacement_magnitude), vec3(1.0));
    }
    graded_normalized = exp2(fma(exponent, min(input_stops, vec3(0.0)), output_highlight_stops));
  }
  if (highlight_contrast != 1.0) {
    vec3 distance = max(graded_normalized - 1.0, vec3(0.0));
    vec3 distance_squared = distance * distance;
    vec3 flat_distance = (1.0 + distance_squared) * exp2(-1.0 / distance_squared);
    graded_normalized += distance * (pow(1.0 + flat_distance, vec3(0.5 * (highlight_contrast - 1.0))) - 1.0);
  }
  if (shadow_contrast != 1.0) {
    vec3 distance = clamp(1.0 - graded_normalized, vec3(0.0), vec3(1.0));
    vec3 distance_squared = distance * distance;
    vec3 flat_distance = distance_squared * distance * exp2(1.0 - 1.0 / distance_squared);
    graded_normalized *= pow(1.0 + flat_distance, vec3(1.0 - shadow_contrast));
  }
  if (highlights != 1.0 || shadows != 1.0) {
    vec3 tonal_stops = log2(graded_normalized);
    vec3 tonal_displacement = vec3(0.0);
    if (highlights != 1.0) {
      float adjustment = highlights - 1.0;
      vec3 weight = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_0(
          (tonal_stops - 1.0) / 7.0);
      tonal_displacement = fma(vec3(adjustment * fma(1.5, abs(adjustment), 0.5)), weight, tonal_displacement);
    }
    if (shadows != 1.0) {
      float adjustment = shadows - 1.0;
      vec3 weight = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_0(
          (-1.0 - tonal_stops) / 7.0);
      tonal_displacement = fma(vec3(adjustment * fma(1.5, abs(adjustment), 0.5)), weight, tonal_displacement);
    }
    graded_normalized *= exp2(tonal_displacement);
  }
  return graded_normalized * anchor_out;
}

// Linear BT.709 grading; anchor_y is the positive input anchor of grading_source.
vec3 ApplyAnchoredSaturationGrading(
    vec3 color, vec3 grading_source, float anchor_y,
    float saturation, float highlight_saturation, float dechroma) {
  if (saturation == 1.0 && highlight_saturation == 1.0 && dechroma == 0.0) return color;

  // Transpose row-listed HLSL matrices for GLSL matrix * column-vector multiplication.
  const mat3 bt709_to_xyz = transpose(mat3(
      0.4123907993, 0.3575843394, 0.1804807884,
      0.2126390059, 0.7151686788, 0.0721923154,
      0.0193308187, 0.1191947798, 0.9505321522));
  const mat3 xyz_to_lms = transpose(mat3(
      0.2670502842655792, 0.8471990148492798, -0.03470416612462053,
      -0.38706882411220156, 1.165429935890458, 0.10302286696614202,
      0.026727793989083093, -0.02729131667566509, 0.5333267257603284));
  const mat3 xyz_to_bt709 = transpose(mat3(
      3.2409699419, -1.5373831776, -0.4986107603,
      -0.9692436363, 1.8759675015, 0.0415550574,
      0.0556300797, -0.2039769589, 1.0569715142));
  const mat3 bt709_to_lms = xyz_to_lms * bt709_to_xyz;
  vec3 anchor_lms = bt709_to_lms * vec3(anchor_y);
  float effective_purity_scale = saturation;

  if (dechroma != 0.0 || highlight_saturation != 1.0) {
    const float INVERSE_HIGHLIGHT_RANGE_STOPS = 1.0 / (2.75 * log2(10.0));
    const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5;
    const float HIGHLIGHT_PURITY_STRENGTH = 2.0 / 3.0;

    float source_relative_yf = max(
        rdr2_test31_renodx_color_yf_from_LMS_0((bt709_to_lms * grading_source) / anchor_lms)
            / rdr2_test31_renodx_color_yf_from_LMS_0(vec3(1.0)),
        0.0);
    float rolloff_position = clamp(log2(max(source_relative_yf, 1.0)) * INVERSE_HIGHLIGHT_RANGE_STOPS, 0.0, 1.0);
    float rolloff_position_squared = rolloff_position * rolloff_position;
    float rolloff = rolloff_position_squared * rolloff_position
        * fma(rolloff_position, fma(6.0, rolloff_position, -15.0), 10.0);

    if (dechroma != 0.0) {
      effective_purity_scale *= fma(-dechroma, rolloff, 1.0);
    }
    if (highlight_saturation != 1.0) {
      float highlight_rolloff = rolloff * rolloff
          * fma(HIGHLIGHT_ROLLOFF_CUBIC_BLEND, rolloff, 1.0 - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);
      effective_purity_scale *= fma(highlight_saturation - 1.0, highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH, 1.0);
    }
  }
  if (effective_purity_scale == 1.0) return color;

  // Preserve physiological Yf, including signed and zero-Yf colors, without dividing by pixel Yf.
  vec3 graded_lms = rdr2_test31_renodx_tonemap_psychov_psycho30_ApplyAdaptiveRelativePurity_0(
      bt709_to_lms * color, anchor_lms, effective_purity_scale) * anchor_lms;
  return xyz_to_bt709 * (inverse(xyz_to_lms) * graded_lms);
}

vec3 ApplyFinalToneMap(vec3 color, vec2 texcoord, float midgray_in, float midgray_out, float slope) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return color;

  float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  float clip = 100.f;
  vec3 linear_color;
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    linear_color = DecodeRDR2Gamma(max(color, vec3(0.0)));
    // PsychoV contrast is a log slope, not the raw derivative.
    float contrast = DivideSafe(midgray_in * slope, midgray_out, 1.0);
    float encoded_midgray = EncodeRDR2Gamma(vec3(midgray_out)).x;
    // Match the vanilla gamma-2.2 display value using anchored grading, not an output gamma transform.
    contrast *= midgray_out < 0.0031308
                    ? 2.2
                    : DivideSafe(encoded_midgray + 0.055 * (2.2 - 1.0) / (2.4 - 1.0), encoded_midgray, 1.0);
    vec3 grading_anchor_in = vec3(midgray_out);
    vec3 grading_anchor_out = vec3(pow(encoded_midgray, 2.2));
    float flare = 0.1f * pow(0.64f, 10.f);
    float shadow_contrast = 60.f / 50.f;
    float highlight_contrast = 49.f / 50.f;
    linear_color = custom_psychotm_test31(
        linear_color, peak_ratio,
        1.0, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS, contrast * RENODX_TONE_MAP_CONTRAST,
        flare + 0.1f * pow(RENODX_TONE_MAP_FLARE, 10.f), highlight_contrast * RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
        shadow_contrast * RENODX_TONE_MAP_CONTRAST_SHADOWS, RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, RENODX_TONE_MAP_DECHROMA,
        grading_anchor_in, grading_anchor_out, 0.0, 1.0, 1, 100.f, 1.0, 0.5, 0.0, 1, 1.0, clip);
  } else {
    if (RENODX_SDR_EOTF_EMULATION != 0.f) {
      peak_ratio = Gamma(peak_ratio, true);
      clip = Gamma(clip, true);
    }
    linear_color = SRGBDecode(max(color, vec3(0.0)));
    vec3 grading_source = linear_color;
    linear_color = ApplyAnchoredTonalGrading(
        linear_color, vec3(0.07207985), vec3(0.07207985),
        RENODX_TONE_MAP_CONTRAST, 0.1f * pow(RENODX_TONE_MAP_FLARE, 10.f),
        RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS, RENODX_TONE_MAP_CONTRAST_SHADOWS,
        RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS);
    linear_color = CInfinityRollOff(linear_color, vec3(peak_ratio), vec3(0.07207985), 100.f, vec3(clip));
    linear_color = ApplyAnchoredSaturationGrading(
      linear_color, grading_source, 0.07207985,
      RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, RENODX_TONE_MAP_DECHROMA);
  }
  if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    linear_color = ApplyFilmGrain(linear_color, texcoord, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.03f, 1.0);
  }
  return SRGBEncodeSafe(linear_color);
}

vec4 ConditionalClampOutput(vec4 color, bool native_hdr) {
  if (!native_hdr && RENODX_TONE_MAP_TYPE == 0.f) {
    return clamp(color, vec4(0.0), vec4(1.0));
  }
  return color;
}

vec3 ApplyDither(
    vec3 color, vec2 pixel_position, uint frame_index, texture2DArray noise_texture,
    bool native_hdr, vec3 amplitude_low, vec3 amplitude_high,
    vec4 amplitude_scale, vec4 amplitude_offset) {
  if (CUSTOM_DITHERING == 0.f) return color;

  ivec4 noise_position = ivec4(uvec4(
      uvec2(ivec2(uvec2(pixel_position))) & uvec2(63u),
      uint(int(frame_index) & 31), 0u));
  vec3 noise = (vec3(texelFetch(noise_texture, noise_position.xyz, noise_position.w).x) * 2.0) - vec3(1.0);
  if (native_hdr) {
    noise = vec3(ivec3(sign(noise))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(noise)));
  }
  return color + CUSTOM_DITHERING * (noise * mix(amplitude_low, amplitude_high, pow(clamp((mix(vec3(max(color.x, max(color.y, color.z))), color, bvec3(floatBitsToInt(amplitude_scale.w) != 0)) - amplitude_offset.xyz) * amplitude_scale.xyz, vec3(0.0), vec3(1.0)), vec3(amplitude_offset.w))));
}

vec3 CompressLUTInput(
    vec3 color, bool linear_lut_input, uint enable_hdr_compression,
    float compression_threshold, float compression_slope, float compression_offset,
    out float compression_scale) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float max_channel = max(max(color.x, max(color.y, color.z)), 9.9999997473787516355514526367188e-05);
    compression_scale = (linear_lut_input && (!(enable_hdr_compression != 0u)))
                            ? 1.0
                            : (((max_channel > compression_threshold)
                                    ? ((max_channel * compression_slope) + compression_offset)
                                    : max_channel)
                               / max_channel);
    return color * compression_scale;
  } else {
    vec3 linear_color = pow(max(color, vec3(0.0)), vec3(2.2));
    float max_channel = max(max(linear_color.x, max(linear_color.y, linear_color.z)), 0.0);
    compression_scale = DivideSafe(CInfinityRollOff(max_channel, 1.0, 0.06952595, 6.f), max_channel, 1.f);
    linear_color *= compression_scale;
    return pow(max(linear_color, vec3(0.0)), vec3(1.0 / 2.2));
  }
}

vec3 RestoreLUTOutput(
    vec3 color, float compression_scale, vec3 original_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color / vec3(compression_scale);
  } else {
    if (CUSTOM_LUT_STRENGTH == 0.f) return original_color;
    vec3 linear_color = pow(max(color, vec3(0.0)), vec3(2.2));
    linear_color = DivideSafe(linear_color, vec3(compression_scale));
    if (CUSTOM_LUT_STRENGTH != 1.f) {
      linear_color = mix(pow(max(original_color, vec3(0.0)), vec3(2.2)), linear_color, CUSTOM_LUT_STRENGTH);
    }
    return pow(max(linear_color, vec3(0.0)), vec3(1.0 / 2.2));
  }
}

#endif
