#include "../common.hlsli"

/// Identity through anchor to every derivative; then approaches peak
/// monotonically and concave down. Requires anchor < peak and compression_strength >= 1.
#define APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(T)                                                      \
  T ApplyAnchoredCInfinityShoulder(T color, T peak, T anchor, float compression_strength) {                \
    T shoulder_range = peak - anchor;                                                                      \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                  \
    T flat_weight = exp2(-shoulder_range / (compression_strength * distance_from_anchor));                 \
    T response_denominator = mad(distance_from_anchor, flat_weight, shoulder_range);                       \
    return mad(shoulder_range, distance_from_anchor / response_denominator, color - distance_from_anchor); \
  }

APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(float)
APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(float3)
#undef APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR

float ApplyAnchoredCInfinityShoulderMaxChannelScale(float3 color, float peak, float anchor, float compression_strength) {
  float max_channel = renodx::math::Max(abs(color));
  float compressed_max = ApplyAnchoredCInfinityShoulder(max_channel, peak, anchor, compression_strength);
  return renodx::math::DivideSafe(compressed_max, max_channel, 1.f);
}

float3 ComputeCInfinityTransition(float3 position) {
  position = saturate(position);
  return 1.f / (1.f + exp2((1.f - 2.f * position) / (position * (1.f - position))));
}

// Monotonic and C-infinity continuous anchored tonal grading
float3 ApplyAnchoredTonalGrading(
    float3 color,
    float3 anchor_in = 0.18f,
    float3 anchor_out = 0.18f,
    float contrast = 1.f,
    float flare = 0.f,
    float highlight_contrast = 1.f,
    float shadow_contrast = 1.f,
    float highlights = 1.f,
    float shadows = 1.f) {
  [branch]
  if (contrast == 1.f
      && flare == 0.f
      && highlight_contrast == 1.f
      && shadow_contrast == 1.f
      && highlights == 1.f
      && shadows == 1.f
      && all(anchor_in == anchor_out)) {
    return color;
  }

  float3 ax = abs(color);
  float3 normalized = ax / anchor_in;
  float3 contrasted_normalized = normalized;

  // power contrast and shadow flare with bounded highlights
  [branch]
  if (contrast != 1.f || flare > 0.f) {
    float3 exponent = contrast;

    [branch]
    if (flare > 0.f) {
      float3 shadow_distance = saturate(1.f - normalized);
      float3 flat_shadow_weight = exp2(-normalized / shadow_distance);
      exponent *= mad(flat_shadow_weight, flare / (normalized + flare), 1.f);
    }

    float3 input_stops = log2(normalized);
    float3 highlight_stops = max(input_stops, 0.f);
    float3 output_highlight_stops = highlight_stops;

    [branch]
    if (contrast != 1.f) {
      float3 contrast_displacement = (contrast - 1.f) * highlight_stops;
      float3 displacement_magnitude = abs(contrast_displacement);
      output_highlight_stops += contrast_displacement / mad(displacement_magnitude, exp2(-1.f / displacement_magnitude), 1.f);
    }

    contrasted_normalized = exp2(mad(exponent, min(input_stops, 0.f), output_highlight_stops));
  }

  // broad highlight contrast.
  [branch]
  if (highlight_contrast != 1.f) {
    float3 highlight_distance = max(contrasted_normalized - 1.f, 0.f);
    float3 highlight_distance_squared = highlight_distance * highlight_distance;
    float3 flat_highlight_distance = (1.f + highlight_distance_squared) * exp2(-1.f / highlight_distance_squared);
    contrasted_normalized += highlight_distance * (pow(1.f + flat_highlight_distance, 0.5f * (highlight_contrast - 1.f)) - 1.f);
  }

  // broad shadow contrast.
  [branch]
  if (shadow_contrast != 1.f) {
    float3 shadow_distance = saturate(1.f - contrasted_normalized);
    float3 shadow_distance_squared = shadow_distance * shadow_distance;
    float3 flat_shadow_distance = shadow_distance_squared * shadow_distance * exp2(1.f - 1.f / shadow_distance_squared);
    contrasted_normalized *= pow(1.f + flat_shadow_distance, shadow_contrast - 1.f);
  }

  // mirror offsets about the anchor: start at one stop and reach full strength at eight stops
  [branch]
  if (highlights != 1.f || shadows != 1.f) {
    float3 tonal_stops = log2(contrasted_normalized);
    float3 tonal_displacement = 0.f;

    [branch]
    if (highlights != 1.f) {
      float highlight_adjustment = highlights - 1.f;
      float highlight_displacement = highlight_adjustment * mad(1.5f, abs(highlight_adjustment), 0.5f);
      float3 highlight_weight = ComputeCInfinityTransition((tonal_stops - 1.f) * 0.125f);
      tonal_displacement = mad(highlight_displacement, highlight_weight, tonal_displacement);
    }

    [branch]
    if (shadows != 1.f) {
      float shadow_adjustment = shadows - 1.f;
      float shadow_displacement = shadow_adjustment * mad(1.5f, abs(shadow_adjustment), 0.5f);
      float3 shadow_weight = ComputeCInfinityTransition((-1.f - tonal_stops) * 0.125f);
      tonal_displacement = mad(shadow_displacement, shadow_weight, tonal_displacement);
    }

    contrasted_normalized *= exp2(tonal_displacement);
  }

  return renodx::math::CopySign(contrasted_normalized * anchor_out, color);
}

float3 ApplyAdaptiveMBPurity(float3 lms_input, float3 adaptive_neutral_lms, float purity_scale) {
  if (abs(purity_scale - 1.f) <= 1e-5f) return lms_input;

  float3 relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(lms_input, adaptive_neutral_lms);
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(relative_weighted);
  float3 mb_neutral = renodx::color::macleod_boynton::from::LMS(1.f.xxx);
  float2 mb_scaled_xy = lerp(mb_neutral.xy, mb.xy, purity_scale);
  float3 relative_weighted_out = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(float3(mb_scaled_xy, mb.z));

  return renodx::color::macleod_boynton::UnweighLMS(renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(relative_weighted_out, adaptive_neutral_lms));
}

float3 ApplyPurityGradingLMS(float3 color_lms, float purity_scale, float highlight_saturation, float dechroma, float3 adaptive_neutral_lms = 0.18f) {
  if (purity_scale == 1.f && highlight_saturation == 1.f && dechroma == 0.f) return color_lms;

  if (dechroma != 0.f || highlight_saturation != 1.f) {
    float luminance = renodx::color::yf::from::LMS(color_lms);
    float neutral_luminance = renodx::color::yf::from::LMS(adaptive_neutral_lms);

    // Ramp purity grading over 2.75 decades above the adaptive neutral.
    static const float INVERSE_HIGHLIGHT_RANGE_STOPS = 1.f / (2.75f * log2(10.f));
    static const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5f;
    static const float HIGHLIGHT_PURITY_STRENGTH = 2.f / 3.f;

    float luminance_from_neutral = max(luminance, neutral_luminance) / neutral_luminance;
    float rolloff_position = saturate(log2(luminance_from_neutral) * INVERSE_HIGHLIGHT_RANGE_STOPS);

    float rolloff_position_squared = rolloff_position * rolloff_position;
    float rolloff = rolloff_position_squared * rolloff_position * mad(rolloff_position, mad(6.f, rolloff_position, -15.f), 10.f);

    // Base smootherstep brings dechroma into the midtones while remaining monotonic and C2.
    if (dechroma != 0.f) {
      purity_scale *= mad(-dechroma, rolloff, 1.f);
    }

    // Blend smootherstep squared and cubed for a later, gentler C2 progression.
    if (highlight_saturation != 1.f) {
      float highlight_rolloff = rolloff * rolloff * mad(HIGHLIGHT_ROLLOFF_CUBIC_BLEND, rolloff, 1.f - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);
      purity_scale *= mad(highlight_saturation - 1.f, highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH, 1.f);
    }
  }

  if (purity_scale != 1.f) {
    color_lms = ApplyAdaptiveMBPurity(color_lms, adaptive_neutral_lms, purity_scale);
  }

  return color_lms;
}

float3 ApplyGammaCorrectionForToneMap(float3 color_input) {
  float3 color_corrected;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    if (RENODX_TONE_MAP_WORKING_COLOR_SPACE == 0.f) {
      color_corrected = renodx::color::correct::GammaSafe(color_input);
    } else {
      const float3 BT709_WHITE_LMS = renodx::color::lms::from::BT709(1.f);
      color_corrected = renodx::color::bt709::from::LMS(renodx::color::correct::GammaSafe(renodx::color::lms::from::BT709(color_input) / BT709_WHITE_LMS) * BT709_WHITE_LMS);
    }
  } else {
    color_corrected = color_input;
  }

  return color_corrected;
}

float3 SampleGamma2LUT(float3 color_input, Texture3D<float4> _29,
                       SamplerState lut_sampler,
                       float _40_m0_10u_z, float _40_m0_10u_w) {
  float3 lut_input = sqrt(color_input);
  float3 lutted = _29.SampleLevel(lut_sampler, lut_input * _40_m0_10u_z + _40_m0_10u_w, 0.f).rgb;
  lutted = lutted * lutted;

  return lutted;
}

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 SampleGamma2LUTWithScaling(
    float3 color_input, Texture3D<float4> _29,
    SamplerState lut_sampler,
    float _40_m0_10u_z, float _40_m0_10u_w) {
  const float3 color_output_original = SampleGamma2LUT(color_input, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);

  float3 color_output = color_output_original;

  if (RENODX_COLOR_GRADE_SCALING > 0.f) {
    float3 lut_black = SampleGamma2LUT(0.f, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);

    float lut_black_y = renodx::color::yf::from::BT709(lut_black);
    if (lut_black_y > 0.f) {
      float3 lut_mid = SampleGamma2LUT(lut_black_y, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);

      float3 unclamped_gamma = Unclamp(
          sqrt(color_output),
          sqrt(lut_black),
          sqrt(lut_mid),
          sqrt(color_input));

      float3 unclamped_linear = unclamped_gamma * unclamped_gamma;

      color_output = renodx::lut::RecolorUnclamped(color_output_original, unclamped_linear, RENODX_COLOR_GRADE_SCALING);
    }
  }

  return color_output;
}

void ApplyTonemapGamma2LUTAndInverseTonemap(
    SamplerState lut_sampler,
    Texture3D<float4> _29,
    float _643, float _644, float _645,
    float _40_m0_2u_w,
    float _40_m0_2u_x, float _40_m0_2u_y, float _40_m0_2u_z,
    float _40_m0_3u_x, float _40_m0_3u_y, float _40_m0_3u_z, float _40_m0_3u_w,
    float _40_m0_10u_z, float _40_m0_10u_w,
    inout float frontier_phi_14_15_ladder,
    inout float frontier_phi_14_15_ladder_1,
    inout float frontier_phi_14_15_ladder_2) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    // tonemap + gamma 2 encode + sample LUT
    float _729 = (-0.0f) - _40_m0_2u_w;
    float4 _762 = _29.SampleLevel(lut_sampler,
                                  float3((clamp(sqrt(max((_643 < _40_m0_3u_z) ? ((_643 * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_643 + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w,
                                         (clamp(sqrt(max((_644 < _40_m0_3u_z) ? ((_644 * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_644 + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w,
                                         (clamp(sqrt(max((_645 < _40_m0_3u_z) ? ((_645 * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_645 + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w),
                                  0.0f);

    // gamma 2 -> linear with clamp
    float _770 = min(_762.x * _762.x, _40_m0_2u_x);
    float _771 = min(_762.y * _762.y, _40_m0_2u_x);
    float _772 = min(_762.z * _762.z, _40_m0_2u_x);

    // inverse tonemap
    frontier_phi_14_15_ladder = (_772 < _40_m0_3u_w) ? ((_772 - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_772 - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_1 = (_771 < _40_m0_3u_w) ? ((_771 - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_771 - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_2 = (_770 < _40_m0_3u_w) ? ((_770 - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_770 - _40_m0_3u_y)) - _40_m0_3u_x);
  } else {
    float3 color = float3(_643, _644, _645);
    color = max(0, color);

    {  // apply gamma 2 lut
      float scale = ApplyAnchoredCInfinityShoulderMaxChannelScale(color, 1.f, 0.18f, 1.5f);
      float3 lutted = SampleGamma2LUTWithScaling(color * scale, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);
      //   lutted = min(lutted, _40_m0_2u_x);
      lutted /= scale;

      color = lerp(color, lutted, RENODX_COLOR_GRADE_STRENGTH);
    }

    frontier_phi_14_15_ladder = color.b, frontier_phi_14_15_ladder_1 = color.g, frontier_phi_14_15_ladder_2 = color.r;
  }
}

// Dual-path variant used by DLSSFG-style pipelines:
// - `frontier_phi_14_15_ladder{,_1,_2}`: inverse-tonemapped non-LUT path (B, G, R)
// - `frontier_phi_14_15_ladder{_3,_4,_5}`: inverse-tonemapped LUT path (B, G, R)
void ApplyTonemapGamma2LUTAndInverseTonemapDualOutputsOld(
    SamplerState lut_sampler,
    Texture3D<float4> _29,
    float _643_no_lut, float _644_no_lut, float _645_no_lut,
    float _643_lut, float _644_lut, float _645_lut,
    float _40_m0_2u_w,
    float _40_m0_2u_x, float _40_m0_2u_y, float _40_m0_2u_z,
    float _40_m0_3u_x, float _40_m0_3u_y, float _40_m0_3u_z, float _40_m0_3u_w,
    float _40_m0_10u_z, float _40_m0_10u_w,
    inout float frontier_phi_14_15_ladder,
    inout float frontier_phi_14_15_ladder_1,
    inout float frontier_phi_14_15_ladder_2,
    inout float frontier_phi_14_15_ladder_3,
    inout float frontier_phi_14_15_ladder_4,
    inout float frontier_phi_14_15_ladder_5) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float _729 = (-0.0f) - _40_m0_2u_w;

    // Non-LUT path: tonemap + gamma2 encode/decode.
    float _no_lut_r_gamma = sqrt(max((_643_no_lut < _40_m0_3u_z) ? ((_643_no_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_643_no_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f));
    float _no_lut_g_gamma = sqrt(max((_644_no_lut < _40_m0_3u_z) ? ((_644_no_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_644_no_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f));
    float _no_lut_b_gamma = sqrt(max((_645_no_lut < _40_m0_3u_z) ? ((_645_no_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_645_no_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f));

    float _no_lut_r_linear = _no_lut_r_gamma * _no_lut_r_gamma;
    float _no_lut_g_linear = _no_lut_g_gamma * _no_lut_g_gamma;
    float _no_lut_b_linear = _no_lut_b_gamma * _no_lut_b_gamma;

    // LUT path: tonemap + gamma2 encode + sample LUT + gamma2 decode.
    float4 _762 = _29.SampleLevel(lut_sampler,
                                  float3((clamp(sqrt(max((_643_lut < _40_m0_3u_z) ? ((_643_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_643_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w,
                                         (clamp(sqrt(max((_644_lut < _40_m0_3u_z) ? ((_644_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_644_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w,
                                         (clamp(sqrt(max((_645_lut < _40_m0_3u_z) ? ((_645_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_645_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w),
                                  0.0f);

    float _lut_r_linear = _762.x * _762.x;
    float _lut_g_linear = _762.y * _762.y;
    float _lut_b_linear = _762.z * _762.z;

    float _no_lut_r_clamped = min(_no_lut_r_linear, _40_m0_2u_x);
    float _no_lut_g_clamped = min(_no_lut_g_linear, _40_m0_2u_x);
    float _no_lut_b_clamped = min(_no_lut_b_linear, _40_m0_2u_x);

    float _lut_r_clamped = min(_lut_r_linear, _40_m0_2u_x);
    float _lut_g_clamped = min(_lut_g_linear, _40_m0_2u_x);
    float _lut_b_clamped = min(_lut_b_linear, _40_m0_2u_x);

    // Inverse tonemap: non-LUT output set.
    frontier_phi_14_15_ladder = (_no_lut_b_clamped < _40_m0_3u_w) ? ((_no_lut_b_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_no_lut_b_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_1 = (_no_lut_g_clamped < _40_m0_3u_w) ? ((_no_lut_g_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_no_lut_g_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_2 = (_no_lut_r_clamped < _40_m0_3u_w) ? ((_no_lut_r_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_no_lut_r_clamped - _40_m0_3u_y)) - _40_m0_3u_x);

    // Inverse tonemap: LUT output set.
    frontier_phi_14_15_ladder_3 = (_lut_b_clamped < _40_m0_3u_w) ? ((_lut_b_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_lut_b_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_4 = (_lut_g_clamped < _40_m0_3u_w) ? ((_lut_g_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_lut_g_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_5 = (_lut_r_clamped < _40_m0_3u_w) ? ((_lut_r_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_lut_r_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
  } else {
    float3 no_lut_color = max(0, float3(_643_no_lut, _644_no_lut, _645_no_lut));
    float3 color = max(0, float3(_643_lut, _644_lut, _645_lut));

    {  // apply gamma 2 lut
      float scale = ApplyAnchoredCInfinityShoulderMaxChannelScale(color, 1.f, 0.18f, 1.5f);
      float3 lutted = SampleGamma2LUTWithScaling(color * scale, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);
      //   lutted = min(lutted, _40_m0_2u_x);
      lutted /= scale;

      color = lerp(color, lutted, RENODX_COLOR_GRADE_STRENGTH);
    }

    frontier_phi_14_15_ladder = no_lut_color.b, frontier_phi_14_15_ladder_1 = no_lut_color.g, frontier_phi_14_15_ladder_2 = no_lut_color.r;
    frontier_phi_14_15_ladder_3 = color.b, frontier_phi_14_15_ladder_4 = color.g, frontier_phi_14_15_ladder_5 = color.r;
  }
}

void ApplyTonemapGamma2LUTAndInverseTonemapDualOutputs(
    SamplerState lut_sampler,
    Texture3D<float4> _19,
    float _262, float _266, float _270,
    float _394, float _396, float _398,
    float _26_m0_14_x, float _26_m0_14_y, float _26_m0_14_z, float _26_m0_14_w,
    float _26_m0_15_x, float _26_m0_15_y, float _26_m0_15_z, float _26_m0_15_w,
    float _26_m0_18_x, float _26_m0_18_y,
    inout float frontier_phi_10_11_ladder,
    inout float frontier_phi_10_11_ladder_1,
    inout float frontier_phi_10_11_ladder_2,
    inout float frontier_phi_10_11_ladder_3,
    inout float frontier_phi_10_11_ladder_4,
    inout float frontier_phi_10_11_ladder_5) {
  ApplyTonemapGamma2LUTAndInverseTonemap(
      lut_sampler,
      _19,
      _262, _266, _270,
      _26_m0_14_w,
      _26_m0_14_x, _26_m0_14_y, _26_m0_14_z,
      _26_m0_15_x, _26_m0_15_y, _26_m0_15_z, _26_m0_15_w,
      _26_m0_18_x, _26_m0_18_y,
      frontier_phi_10_11_ladder,
      frontier_phi_10_11_ladder_1,
      frontier_phi_10_11_ladder_2);

  ApplyTonemapGamma2LUTAndInverseTonemap(
      lut_sampler,
      _19,
      _394, _396, _398,
      _26_m0_14_w,
      _26_m0_14_x, _26_m0_14_y, _26_m0_14_z,
      _26_m0_15_x, _26_m0_15_y, _26_m0_15_z, _26_m0_15_w,
      _26_m0_18_x, _26_m0_18_y,
      frontier_phi_10_11_ladder_3,
      frontier_phi_10_11_ladder_4,
      frontier_phi_10_11_ladder_5);
}

float3 ApplyVanillaToneMap(float3 untonemapped_bt709,
                           float InUniform_Constant_064_y,
                           float InUniform_Constant_064_z,
                           float InUniform_Constant_080_z,
                           float InUniform_Constant_096_x,
                           float InUniform_Constant_096_y,
                           float InUniform_Constant_096_z) {
  float InUniform_Constant_096_x_neg = -InUniform_Constant_096_x;
  return select(untonemapped_bt709 < InUniform_Constant_080_z,
                (untonemapped_bt709 * InUniform_Constant_064_y) + InUniform_Constant_064_z,
                (InUniform_Constant_096_x_neg / (untonemapped_bt709 + InUniform_Constant_096_y)) + InUniform_Constant_096_z);
}

float3 ApplyUserGradingAndToneMapAndScale(float3 untonemapped_bt709,
                                          float InUniform_Constant_064_y,
                                          float InUniform_Constant_064_z,
                                          float InUniform_Constant_080_z,
                                          float InUniform_Constant_096_x,
                                          float InUniform_Constant_096_y,
                                          float InUniform_Constant_096_z,
                                          bool use_scaling = true) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return ApplyVanillaToneMap(
        untonemapped_bt709,
        InUniform_Constant_064_y, InUniform_Constant_064_z,
        InUniform_Constant_080_z,
        InUniform_Constant_096_x, InUniform_Constant_096_y, InUniform_Constant_096_z);
  } else {
    untonemapped_bt709 = ApplyGammaCorrectionForToneMap(untonemapped_bt709);

    float3 tonemapped_bt709;
    if (RENODX_TONE_MAP_WORKING_COLOR_SPACE == 0.f) {  // BT.709
      float3 untonemapped_graded_bt709 = ApplyAnchoredTonalGrading(
          untonemapped_bt709,
          0.18f, 0.18f,
          RENODX_TONE_MAP_CONTRAST, 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
          1.f, 1.f, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS);

      const float3 anchor_lms = renodx::color::lms::from::BT709(0.18f);
      float3 untonemapped_graded_lms = ApplyPurityGradingLMS(
          renodx::color::lms::from::BT709(untonemapped_graded_bt709),
          RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, 0.f, anchor_lms);
      untonemapped_graded_bt709 = renodx::color::bt709::from::LMS(max(0, untonemapped_graded_lms));

      tonemapped_bt709 = renodx::math::CopySign(
          ApplyAnchoredCInfinityShoulder(abs(untonemapped_graded_bt709), RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 0.18f, 1.5f),
          untonemapped_graded_bt709);

    } else {  // LMS
      float3 untonemapped_lms = renodx::color::lms::from::BT709(untonemapped_bt709);
      const float3 anchor_lms = renodx::color::lms::from::BT709(0.18f);

      float3 untonemapped_graded_lms = ApplyAnchoredTonalGrading(
          untonemapped_lms,
          anchor_lms, anchor_lms,
          RENODX_TONE_MAP_CONTRAST, 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
          1.f, 1.f, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS);
      untonemapped_graded_lms = ApplyPurityGradingLMS(untonemapped_graded_lms, RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, 0.f, anchor_lms);

      const float3 peak_lms = renodx::color::lms::from::BT2020(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
      float3 tonemapped_lms = ApplyAnchoredCInfinityShoulder(max(0, untonemapped_graded_lms), peak_lms, anchor_lms, 1.5f);

      tonemapped_bt709 = renodx::color::bt709::from::LMS(tonemapped_lms);
    }

    tonemapped_bt709 = renodx::color::bt709::clamp::BT2020(tonemapped_bt709);

    if (use_scaling) {
      tonemapped_bt709 *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    }

    if (RENODX_GAMMA_CORRECTION != 0.f) {
      tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709, true);
    }

    return tonemapped_bt709;
  }
}

void ApplyUserGradingAndToneMapAndScale(
    float untonemapped_bt709_r, float untonemapped_bt709_g, float untonemapped_bt709_b,
    float InUniform_Constant_064_y, float InUniform_Constant_064_z,
    float InUniform_Constant_080_z,
    float InUniform_Constant_096_x, float InUniform_Constant_096_y, float InUniform_Constant_096_z,
    inout float tonemapped_bt709_r, inout float tonemapped_bt709_g, inout float tonemapped_bt709_b, bool use_scaling = true) {
  float3 untonemapped_bt709 = float3(untonemapped_bt709_r, untonemapped_bt709_g, untonemapped_bt709_b);

  float3 tonemapped_bt709 = ApplyUserGradingAndToneMapAndScale(
      untonemapped_bt709,
      InUniform_Constant_064_y, InUniform_Constant_064_z,
      InUniform_Constant_080_z,
      InUniform_Constant_096_x, InUniform_Constant_096_y, InUniform_Constant_096_z,
      use_scaling);

  tonemapped_bt709_r = tonemapped_bt709.r, tonemapped_bt709_g = tonemapped_bt709.g, tonemapped_bt709_b = tonemapped_bt709.b;
  return;
}

void ApplyUserGradingAndToneMapAndScaleDual(
    float untonemapped_bt709_r_0, float untonemapped_bt709_g_0, float untonemapped_bt709_b_0,
    float untonemapped_bt709_r_1, float untonemapped_bt709_g_1, float untonemapped_bt709_b_1,
    float InUniform_Constant_064_y, float InUniform_Constant_064_z,
    float InUniform_Constant_080_z,
    float InUniform_Constant_096_x, float InUniform_Constant_096_y, float InUniform_Constant_096_z,
    inout float tonemapped_bt709_r_0, inout float tonemapped_bt709_g_0, inout float tonemapped_bt709_b_0,
    inout float tonemapped_bt709_r_1, inout float tonemapped_bt709_g_1, inout float tonemapped_bt709_b_1) {
  ApplyUserGradingAndToneMapAndScale(
      untonemapped_bt709_r_0, untonemapped_bt709_g_0, untonemapped_bt709_b_0,
      InUniform_Constant_064_y, InUniform_Constant_064_z,
      InUniform_Constant_080_z,
      InUniform_Constant_096_x, InUniform_Constant_096_y, InUniform_Constant_096_z,
      tonemapped_bt709_r_0, tonemapped_bt709_g_0, tonemapped_bt709_b_0);

  ApplyUserGradingAndToneMapAndScale(
      untonemapped_bt709_r_1, untonemapped_bt709_g_1, untonemapped_bt709_b_1,
      InUniform_Constant_064_y, InUniform_Constant_064_z,
      InUniform_Constant_080_z,
      InUniform_Constant_096_x, InUniform_Constant_096_y, InUniform_Constant_096_z,
      tonemapped_bt709_r_1, tonemapped_bt709_g_1, tonemapped_bt709_b_1);

  return;
}
