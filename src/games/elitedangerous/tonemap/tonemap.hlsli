#include "../common.hlsli"
#include "./test24.hlsli"

static const float MID_GRAY_IN = 0.119121851127f;
static const float MID_GRAY_OUT = 0.163979921774f;
static const float MID_GRAY_SLOPE = 1.95752308422f;

float3 ApplyAdaptiveMBPurity(float3 lms_input, float3 adaptive_neutral_lms, float purity_scale) {
  if (abs(purity_scale - 1.f) <= 1e-5f) return lms_input;

  float3 relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(lms_input, adaptive_neutral_lms);
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(relative_weighted);
  float3 mb_neutral = renodx::color::macleod_boynton::from::LMS(1.f.xxx);
  float2 mb_scaled_xy = lerp(mb_neutral.xy, mb.xy, purity_scale);
  float3 relative_weighted_out = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(float3(mb_scaled_xy, mb.z));

  return renodx::color::macleod_boynton::UnweighLMS(
      renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(relative_weighted_out, adaptive_neutral_lms));
}

float Highlights(float x, float highlights, float mid_gray = 0.18f) {
  if (highlights == 1.f) return x;
  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {
    float b = mid_gray * pow(x / mid_gray, 2.f - highlights);
    float t = min(x, 1.f);
    return min(x, renodx::math::DivideSafe(x * x, lerp(x, b, t), x));
  }
}

float Shadows(float x, float shadows, float mid_gray = 0.18f) {
  if (shadows == 1.f) return x;
  float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  float base_term = x * mid_gray;
  float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);
  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

#define CONTRAST_AND_FLARE_GENERATOR(T)                                                                       \
  T ContrastAndFlare(T x, float contrast, float flare, T mid_gray_in = (T)0.18f, T mid_gray_out = (T)0.18f) { \
    T x_normalized = x / mid_gray_in;                                                                         \
    T flare_ratio = (T)1.f + renodx::math::DivideSafe(flare, x_normalized + flare, (T)0.f);                   \
    return pow(x_normalized, contrast * flare_ratio) * mid_gray_out;                                          \
  }

CONTRAST_AND_FLARE_GENERATOR(float)
CONTRAST_AND_FLARE_GENERATOR(float3)
#undef CONTRAST_AND_FLARE_GENERATOR

float3 ApplyLuminanceGradingLMS(float3 color_lms, float exposure, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float yf = max(0.f, renodx::color::yf::from::LMS(color_lms));
  float yf_adjusted = yf * exposure;
  yf_adjusted = renodx::color::grade::Highlights(yf_adjusted, highlights, mid_gray_yf);
  yf_adjusted = renodx::color::grade::Shadows(yf_adjusted, shadows, mid_gray_yf);
  yf_adjusted = ContrastAndFlare(yf_adjusted, contrast, flare, mid_gray_yf, mid_gray_yf);
  return color_lms * renodx::math::DivideSafe(yf_adjusted, yf, 1.f);
}

float3 ApplyLuminanceGradingBT2020(float3 color_bt2020, float exposure, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyLuminanceGradingLMS(color_lms, exposure, highlights, shadows, contrast, flare, mid_gray_yf);
  return renodx::color::bt2020::from::LMS(color_lms);
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

    if (highlight_saturation != 1.f) {
      // Blend smootherstep squared and cubed for a later, gentler C2 progression.
      float highlight_rolloff = rolloff * rolloff * mad(HIGHLIGHT_ROLLOFF_CUBIC_BLEND, rolloff, 1.f - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);
      purity_scale *= mad(highlight_saturation - 1.f, highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH, 1.f);
    }
  }

  if (purity_scale != 1.f) {
    color_lms = ApplyAdaptiveMBPurity(color_lms, adaptive_neutral_lms, purity_scale);
  }

  return color_lms;
}

float3 ApplyPurityGradingBT2020(float3 color_bt2020, float purity_scale, float highlight_saturation, float dechroma) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyPurityGradingLMS(color_lms, purity_scale, highlight_saturation, dechroma, renodx::color::lms::from::BT2020(0.18f.xxx));
  return renodx::color::bt2020::from::LMS(color_lms);
}

float3 ApplyAnchoredAdaptationContrast(
    float3 color,
    float contrast,
    float3 anchor_in = 0.18f,
    float3 anchor_out = 0.18f,
    float flare = 0.f,
    float highlights = 1.f,
    float shadows = 1.f) {
  float3 ax = abs(color);
  float3 normalized = ax / anchor_in;
  float3 flare_ratio = 1.f + renodx::math::DivideSafe(flare, normalized + flare, 0.f);
  float3 exponent = contrast * flare_ratio;

  float3 ax_n = pow(ax, exponent);
  float3 s_n = pow(anchor_in, exponent);
  float3 response_target = ax_n / (ax_n + s_n);
  float3 response_baseline = ax / (ax + anchor_in);
  float3 gain = renodx::math::DivideSafe(response_target, response_baseline, 0.f);

  float3 contrasted_normalized = ax * gain / anchor_in;

  if (highlights != 1.f) {
    float3 highlight_distance = max(contrasted_normalized - 1.f, 0.f);
    contrasted_normalized += highlight_distance * (pow(1.f + highlight_distance * highlight_distance, (highlights - 1.f) / 2.f) - 1.f);
  }

  if (shadows != 1.f) {
    float3 shadow_distance = max(1.f - contrasted_normalized, 0.f);
    contrasted_normalized *= pow(1.f + shadow_distance * shadow_distance * shadow_distance, shadows - 1.f);
  }

  return renodx::math::CopySign(contrasted_normalized * anchor_out, color);
}

float3 ApplyAnchoredPowerContrast(
    float3 color,
    float contrast,
    float3 anchor_in = 0.18f,
    float3 anchor_out = 0.18f,
    float flare = 0.f,
    float highlights = 1.f,
    float shadows = 1.f) {
  float3 ax = abs(color);
  float3 normalized = ax / anchor_in;
  float3 flare_ratio = 1.f + renodx::math::DivideSafe(flare, normalized + flare, 0.f);

  float3 contrasted_normalized = pow(normalized, contrast * flare_ratio);

  if (highlights != 1.f) {
    float3 highlight_distance = max(contrasted_normalized - 1.f, 0.f);
    contrasted_normalized += highlight_distance * (pow(1.f + highlight_distance * highlight_distance, (highlights - 1.f) / 2.f) - 1.f);
  }

  if (shadows != 1.f) {
    float3 shadow_distance = max(1.f - contrasted_normalized, 0.f);
    contrasted_normalized *= pow(1.f + shadow_distance * shadow_distance * shadow_distance, shadows - 1.f);
  }

  return renodx::math::CopySign(contrasted_normalized * anchor_out, color);
}

// Exact power contrast through the anchor, then C2 divisive normalization of
// highlight contrast displacement to a maximum magnitude of one stop.
float3 ApplyAnchoredBoundedPowerContrast(
    float3 color,
    float contrast,
    float3 anchor_in = 0.18f,
    float3 anchor_out = 0.18f,
    float flare = 0.f,
    float highlights = 1.f,
    float shadows = 1.f) {
  float3 ax = abs(color);
  float3 normalized = ax / anchor_in;
  float3 exponent = contrast;

  if (flare > 0.f) {
    float3 shadow_weight = saturate(1.f - normalized);
    shadow_weight *= shadow_weight;
    exponent *= 1.f + flare * shadow_weight / (normalized + flare);
  }

  float3 input_stops = log2(normalized);
  float3 highlight_stops = max(input_stops, 0.f);
  float3 contrast_displacement = (contrast - 1.f) * highlight_stops;
  float3 normalized_displacement = contrast_displacement * rsqrt(mad(contrast_displacement, contrast_displacement, 1.f));
  float3 output_stops = mad(exponent, min(input_stops, 0.f), highlight_stops + normalized_displacement);
  float3 contrasted_normalized = exp2(output_stops);

  if (highlights != 1.f) {
    float3 highlight_distance = max(contrasted_normalized - 1.f, 0.f);
    contrasted_normalized += highlight_distance * (pow(1.f + highlight_distance * highlight_distance, (highlights - 1.f) / 2.f) - 1.f);
  }

  if (shadows != 1.f) {
    float3 shadow_distance = max(1.f - contrasted_normalized, 0.f);
    contrasted_normalized *= pow(1.f + shadow_distance * shadow_distance * shadow_distance, shadows - 1.f);
  }

  return renodx::math::CopySign(contrasted_normalized * anchor_out, color);
}

// Exact power contrast through the anchor to every derivative, with C-infinity
// flare and grading joins, then smoothly bounds highlight displacement to one stop.
float3 ApplyAnchoredCInfinityBoundedPowerContrast(
    float3 color,
    float contrast,
    float3 anchor_in = 0.18f,
    float3 anchor_out = 0.18f,
    float flare = 0.f,
    float highlights = 1.f,
    float shadows = 1.f) {
  float3 ax = abs(color);
  float3 normalized = ax / anchor_in;
  float3 exponent = contrast;

  [branch]
  if (flare > 0.f) {
    float3 shadow_distance = saturate(1.f - normalized);
    float3 flat_shadow_weight = exp2(-normalized / shadow_distance);
    exponent *= mad(flat_shadow_weight, flare / (normalized + flare), 1.f);
  }

  float3 input_stops = log2(normalized);
  float3 highlight_stops = max(input_stops, 0.f);
  float3 contrast_displacement = (contrast - 1.f) * highlight_stops;
  float3 displacement_magnitude = abs(contrast_displacement);
  float3 bounded_displacement = contrast_displacement / mad(displacement_magnitude, exp2(-1.f / displacement_magnitude), 1.f);
  float3 output_stops = mad(exponent, min(input_stops, 0.f), highlight_stops + bounded_displacement);
  float3 contrasted_normalized = exp2(output_stops);

  [branch]
  if (highlights != 1.f) {
    float3 highlight_distance = max(contrasted_normalized - 1.f, 0.f);
    float3 highlight_distance_squared = highlight_distance * highlight_distance;
    float3 flat_highlight_distance = (1.f + highlight_distance_squared) * exp2(-1.f / highlight_distance_squared);
    contrasted_normalized += highlight_distance * (pow(1.f + flat_highlight_distance, (highlights - 1.f) / 2.f) - 1.f);
  }

  [branch]
  if (shadows != 1.f) {
    float3 shadow_distance = saturate(1.f - contrasted_normalized);
    float3 shadow_distance_squared = shadow_distance * shadow_distance;
    float3 flat_shadow_distance = shadow_distance_squared * shadow_distance * exp2(1.f - 1.f / shadow_distance_squared);
    contrasted_normalized *= pow(1.f + flat_shadow_distance, shadows - 1.f);
  }

  return renodx::math::CopySign(contrasted_normalized * anchor_out, color);
}

/// Identity through anchor; then approaches peak monotonically and concave down.
/// The anchor join is C2 continuous. Requires anchor < peak and compression_strength >= 1.
#define APPLYANCHOREDCUBICSHOULDER_GENERATOR(T)                                                          \
  T ApplyAnchoredCubicShoulder(T color, T peak, T anchor, float compression_strength) {                  \
    T shoulder_range = peak - anchor;                                                                    \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                \
    T weighted_distance = compression_strength * distance_from_anchor;                                   \
    T response_numerator = distance_from_anchor * (shoulder_range + weighted_distance);                  \
    T response_denominator = mad(                                                                        \
        shoulder_range, shoulder_range, weighted_distance * (shoulder_range + distance_from_anchor));    \
    return mad(shoulder_range, response_numerator / response_denominator, color - distance_from_anchor); \
  }

/// Identity through anchor; reaches peak at clip, then remains flat.
/// Monotonic, concave down, and C2 when clip meets the calculated minimum.
#define APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(T)                                                                        \
  T ApplyAnchoredCubicShoulder(T color, T peak, T anchor, float compression_strength, T clip) {                             \
    T shoulder_range = peak - anchor;                                                                                       \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                                   \
    T input_range = clip - anchor;                                                                                          \
    T clipped_distance = min(distance_from_anchor, input_range);                                                            \
    T clip_position = clipped_distance / input_range;                                                                       \
    T clip_position_squared = clip_position * clip_position;                                                                \
    T clip_position_cubed = clip_position_squared * clip_position;                                                          \
    T residual_weight = (T)1.f - clip_position_cubed * mad(clip_position, mad((T)6.f, clip_position, (T) - 15.f), (T)10.f); \
    T weighted_distance = compression_strength * clipped_distance;                                                          \
    T response_numerator = clipped_distance * (shoulder_range + weighted_distance);                                         \
    T remaining_distance = shoulder_range * mad(compression_strength - 1.f, clipped_distance, shoulder_range);              \
    T response_denominator = mad(residual_weight, remaining_distance, response_numerator);                                  \
    return mad(shoulder_range, response_numerator / response_denominator, color - distance_from_anchor);                    \
  }

APPLYANCHOREDCUBICSHOULDER_GENERATOR(float)
APPLYANCHOREDCUBICSHOULDER_GENERATOR(float3)
APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(float)
APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(float3)
#undef APPLYANCHOREDCUBICSHOULDER_GENERATOR
#undef APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR

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

/// Elite Dangerous vanilla SDR tonemapper.
/// Output is in gamma space.
#define APPLY_VANILLA_TONEMAP_GENERATOR(T)                        \
  T ApplyVanillaTonemap(T untonemapped, float N4 = -1.274e-7f) {  \
    const float N0 = 8.46800041f;                                 \
    const float N1 = 1.0f;                                        \
    const float N2 = -0.00295699993f;                             \
    const float N3 = 0.000100400001f;                             \
                                                                  \
    const float D0 = 8.3604002f;                                  \
    const float D1 = 1.82270002f;                                 \
    const float D2 = 0.218899995f;                                \
    const float D3 = -0.00211700005f;                             \
    const float D4 = 3.67300017e-5f;                              \
                                                                  \
    T x = untonemapped;                                           \
    T numerator = (((x * N0 + N1) * x + N2) * x + N3) * x + N4;   \
    T denominator = (((x * D0 + D1) * x + D2) * x + D3) * x + D4; \
    return max((T)0.0f, numerator / denominator);                 \
  }

APPLY_VANILLA_TONEMAP_GENERATOR(float)
APPLY_VANILLA_TONEMAP_GENERATOR(float3)
#undef APPLY_VANILLA_TONEMAP_GENERATOR

#define APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR(T)                                            \
  T ApplyExtendedVanillaTonemap(T x, float sdr_blend_strength = 0.f) {                         \
    const float INFLECTION_X = 0.119121851127f;                                                \
    const float INFLECTION_Y = 0.163979921774f;                                                \
    const float INFLECTION_SLOPE = 1.95752308422f;                                             \
                                                                                               \
    /* N4 = 0 removes the black clip. */                                                       \
    T vanilla_gamma = ApplyVanillaTonemap(x, 0.f);                                             \
    T vanilla_linear = pow(vanilla_gamma, 2.2f);                                               \
                                                                                               \
    T extended_linear = INFLECTION_Y + INFLECTION_SLOPE * (x - INFLECTION_X);                  \
                                                                                               \
    T restored_linear = lerp(extended_linear, vanilla_linear, sdr_blend_strength);             \
                                                                                               \
    T output_linear = renodx::math::Select(x > INFLECTION_X, restored_linear, vanilla_linear); \
                                                                                               \
    return max((T)0.f, output_linear);                                                         \
  }

APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR(float)
APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR(float3)
#undef APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR

float3 ApplyPreLUTToneMapAndGammaEncode(float3 untonemapped) {
  float3 tonemapped_gamma;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    tonemapped_gamma = ApplyVanillaTonemap(untonemapped);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    float sdr_blend_strength = 0.f;
    float3 tonemapped = ApplyExtendedVanillaTonemap(untonemapped, sdr_blend_strength);
    if (RENODX_TONE_MAP_PER_CHANNEL == 0.f) {
      float perch_yf = renodx::color::yf::from::BT709(tonemapped);
      float lum_yf = ApplyExtendedVanillaTonemap(renodx::color::yf::from::BT709(untonemapped), sdr_blend_strength);
      tonemapped = renodx::color::correct::Luminance(tonemapped, perch_yf, lum_yf);
    }
    tonemapped_gamma = renodx::color::gamma::Encode(tonemapped, 2.2f);
  } else {
    tonemapped_gamma = renodx::color::gamma::Encode(max(0, untonemapped), 2.2f);
  }

  return tonemapped_gamma;
}

float3 ApplyLUT(float3 lut_input_gamma, Texture3D<float4> lut_texture, SamplerState lut_sampler, float texel_size, float lut_strength) {
  if (CUSTOM_LUT_STRENGTH == 0.f || lut_strength == 0.f) return lut_input_gamma;

  float3 lut_input_linear = renodx::color::gamma::Decode(lut_input_gamma, 2.2f);

  float maxch_scale = 1.f;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
      maxch_scale = ApplyAnchoredCInfinityShoulderMaxChannelScale(lut_input_linear, 1.f, MID_GRAY_OUT, 1.5f);
    } else {  // Custom
      maxch_scale = ApplyAnchoredCInfinityShoulderMaxChannelScale(lut_input_linear, 1.f, MID_GRAY_IN, 1.5f);
    }
    lut_input_linear *= maxch_scale;
    lut_input_gamma = renodx::color::gamma::Encode(lut_input_linear, 2.2f);
  }

  float3 lut_output_gamma;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    lut_output_gamma = lut_texture.Sample(lut_sampler, saturate(lut_input_gamma) * (1 - texel_size) + (0.5 * texel_size)).rgb;  // LUT
  } else {
    lut_output_gamma = renodx::lut::SampleTetrahedral(lut_texture, lut_input_gamma, uint(1.f / texel_size));
  }
  lut_output_gamma = lerp(lut_input_gamma, lut_output_gamma, lut_strength * CUSTOM_LUT_STRENGTH);  // Blend in LUT as a percentage

  float3 lut_output_linear = renodx::color::gamma::Decode(lut_output_gamma, 2.2f) / maxch_scale;

  return renodx::color::gamma::Encode(lut_output_linear, 2.2f);
}

float3 ApplyPostLUTToneMap(float3 untonemapped_gamma) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped_gamma;

  float3 untonemapped = renodx::color::gamma::DecodeSafe(untonemapped_gamma, 2.2f);

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
    untonemapped = max(0, renodx::color::bt2020::from::BT709(untonemapped));

    // Apply BT.2020 luminance and purity grading.
    untonemapped = ApplyLuminanceGradingBT2020(untonemapped,
                                               1.f,
                                               RENODX_TONE_MAP_HIGHLIGHTS,
                                               RENODX_TONE_MAP_SHADOWS,
                                               RENODX_TONE_MAP_CONTRAST,
                                               0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                               MID_GRAY_OUT);
    untonemapped = ApplyPurityGradingBT2020(untonemapped,
                                            RENODX_TONE_MAP_SATURATION,
                                            RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
                                            RENODX_TONE_MAP_DECHROMA);
    untonemapped = max(untonemapped, 1e-7f);

    tonemapped = ApplyAnchoredCInfinityShoulder(untonemapped, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, MID_GRAY_OUT, 1.5f);
    tonemapped = renodx::color::bt709::from::BT2020(tonemapped);
  } else {  // Custom
    float3 untonemapped_lms = max(0, renodx::color::lms::from::BT709(untonemapped));
    float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(MID_GRAY_IN);
    float3 desired_background_state_lms = renodx::color::lms::from::BT709(MID_GRAY_OUT);
    float3 peak_lms = renodx::color::lms::from::BT2020(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

// Apply anchored LMS contrast.
#if 0
    float3 graded_lms = ApplyAnchoredAdaptationContrast(untonemapped_lms,
                                                        (1.745f) * RENODX_TONE_MAP_CONTRAST,
                                                        current_adaptive_state_lms, desired_background_state_lms,
                                                        0.10f * pow(0.77f, 10.f) + 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                                        RENODX_TONE_MAP_HIGHLIGHTS,
                                                        RENODX_TONE_MAP_SHADOWS);
#else
    float3 graded_lms = ApplyAnchoredCInfinityBoundedPowerContrast(untonemapped_lms,
                                                                   (1.55f) * RENODX_TONE_MAP_CONTRAST,
                                                                   current_adaptive_state_lms, desired_background_state_lms,
                                                                   0.10f * pow(0.85f, 10.f) + 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                                                   RENODX_TONE_MAP_HIGHLIGHTS,
                                                                   RENODX_TONE_MAP_SHADOWS);
#endif

    // Apply LMS luminance and purity grading.
    graded_lms = ApplyPurityGradingLMS(graded_lms,
                                       RENODX_TONE_MAP_SATURATION,
                                       RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
                                       RENODX_TONE_MAP_DECHROMA,
                                       desired_background_state_lms);

#if 1
    // Restore the pre-contrast adaptive-MB hue direction before compression,
    // using input midgray rather than peak as full to-white progress.
    float to_white_progress = renodx::math::DivideSafe(
        renodx::color::yf::from::LMS(untonemapped_lms),
        renodx::color::yf::from::LMS(current_adaptive_state_lms),
        1.f);
    float3 hue_corrected_lms = renodx_custom::tonemap::psychov::psycho24_ApplyManualHueDirection(
        graded_lms,
        untonemapped_lms,
        current_adaptive_state_lms,
        to_white_progress);
    float3 shoulder_input_lms = lerp(graded_lms, hue_corrected_lms, 0.3f);
#else
    float3 shoulder_input_lms = graded_lms;
#endif

    float3 compressed_lms = ApplyAnchoredCInfinityShoulder(
        shoulder_input_lms,
        peak_lms,
        desired_background_state_lms,
        1.5f);

    // Test24 adaptive weighted-LMS compression against the BT.2020 boundary.
    float3 display_scaled_relative_weighted = renodx_custom::tonemap::psychov::psycho24_ToAdaptiveRelativeWeightedLMS(
        compressed_lms,
        desired_background_state_lms);
    display_scaled_relative_weighted = renodx::color::gamut::GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
        display_scaled_relative_weighted,
        desired_background_state_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);

    float3 gamut_mapped_bt709 = renodx::color::bt709::from::LMS(
        renodx::color::macleod_boynton::UnweighLMS(
            renodx_custom::tonemap::psychov::psycho24_FromAdaptiveRelativeWeightedLMS(
                display_scaled_relative_weighted,
                desired_background_state_lms)));

    tonemapped = gamut_mapped_bt709;
  }

  return renodx::color::gamma::EncodeSafe(tonemapped, 2.2f);
}
