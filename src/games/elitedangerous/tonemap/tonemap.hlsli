#include "../common.hlsli"
#include "./test24.hlsli"

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
    T flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, (T)1.f);                     \
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

float3 ApplyPurityGradingLMS(float3 color_lms, float purity_scale, float purity_highlights, float dechroma, float3 mid_gray_lms = 0.18f) {
  if (purity_scale == 1.f && purity_highlights == 0.f && dechroma == 0.f) return color_lms;

  float lum_target = max(0.f, renodx::color::yf::from::LMS(color_lms));

  if (dechroma != 0.f) {
    purity_scale *= lerp(1.f, 0.f, saturate(pow(lum_target / (10000.f / 100.f), 1.f - dechroma)));
  }

  if (purity_highlights != 0.f) {
    float percent_max = saturate(lum_target * 100.f / 10000.f);
    float blowout_change = pow(1.f - percent_max, 100.f * abs(purity_highlights));
    if (purity_highlights < 0.f) {
      blowout_change = 2.f - blowout_change;
    }
    purity_scale *= blowout_change;
  }

  if (purity_scale != 1.f) {
    color_lms = ApplyAdaptiveMBPurity(color_lms, mid_gray_lms, purity_scale);
  }

  return color_lms;
}

float3 ApplyPurityGradingBT2020(float3 color_bt2020, float purity_scale, float purity_highlights, float dechroma) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyPurityGradingLMS(color_lms, purity_scale, purity_highlights, dechroma, renodx::color::lms::from::BT2020(0.18f.xxx));
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
  float3 flare_ratio = renodx::math::DivideSafe(
      normalized + flare,
      normalized,
      1.f);
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
  float3 flare_ratio = renodx::math::DivideSafe(normalized + flare, normalized, 1.f);

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

float psycho24_AutoCompressionFromCenteredReferenceRange(
    float anchor_out_yf,
    float peak_yf) {
  static const float PSYCHO24_REFERENCE_CENTERED_RANGE_SIDE_COUNT = 2.f;
  static const float PSYCHO24_REFERENCE_SIMULTANEOUS_RANGE_LOG10 = 3.7f;
  static const float PSYCHO24_MIN_AUTO_COMPRESSION = 1.f;

  float peak_over_anchor = peak_yf / anchor_out_yf;
  float reference_one_side_range_log10 = PSYCHO24_REFERENCE_SIMULTANEOUS_RANGE_LOG10 / PSYCHO24_REFERENCE_CENTERED_RANGE_SIDE_COUNT;
  float actual_above_adaptation_range_log10 = log10(peak_over_anchor);
  return max(reference_one_side_range_log10 / actual_above_adaptation_range_log10, PSYCHO24_MIN_AUTO_COMPRESSION);
}

float3 ComputePeakCompressionRolloff(
    float3 color_lms,
    float3 anchor_lms,
    float3 peak_lms) {
  float compression_power = psycho24_AutoCompressionFromCenteredReferenceRange(renodx::color::yf::from::LMS(anchor_lms),
                                                                               renodx::color::yf::from::LMS(peak_lms));

  float3 anchor_over_peak = anchor_lms / peak_lms;
  float3 compression_slope_norm = 1.f - pow(anchor_over_peak, compression_power);

  float3 compression_input = pow(max(color_lms / anchor_lms, 0.f), compression_power / compression_slope_norm);

  float3 compression_white_offset = pow(peak_lms / anchor_lms, compression_power) - 1.f;

  return pow(compression_input / (compression_input + compression_white_offset), rcp(compression_power));
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
    float sdr_blend_strength = 0.5f;
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
    maxch_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(lut_input_linear);
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

  const float MID_GRAY_IN = 0.119121851127f;
  const float MID_GRAY_OUT = 0.163979921774f;
  const float MID_GRAY_SLOPE = 1.95752308422f;

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
    untonemapped = renodx::color::bt2020::from::BT709(untonemapped);

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
                                            -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
                                            RENODX_TONE_MAP_DECHROMA);

    tonemapped = renodx::tonemap::neutwo::PerChannel(untonemapped, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    tonemapped = renodx::color::bt709::from::BT2020(tonemapped);
  } else {  // Custom
    float3 untonemapped_lms = max(0, renodx::color::lms::from::BT709(untonemapped));
    float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(MID_GRAY_IN);
    float3 desired_background_state_lms = renodx::color::lms::from::BT709(MID_GRAY_OUT);
    float3 peak_lms = renodx::color::lms::from::BT2020(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    // Apply anchored LMS contrast.
    float3 graded_lms = ApplyAnchoredAdaptationContrast(untonemapped_lms, 1.78107f * RENODX_TONE_MAP_CONTRAST, current_adaptive_state_lms, desired_background_state_lms, 0.0025f + 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f), RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS);
    // float3 graded_lms = ApplyAnchoredPowerContrast(untonemapped_lms, 1.2823704 * RENODX_TONE_MAP_CONTRAST, current_adaptive_state_lms, desired_background_state_lms, 0.0025f + 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f), RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS);

    // Apply LMS luminance and purity grading.
    graded_lms = ApplyPurityGradingLMS(graded_lms,
                                       RENODX_TONE_MAP_SATURATION,
                                       -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
                                       RENODX_TONE_MAP_DECHROMA,
                                       desired_background_state_lms);

    // Apply Test24 peak compression with compression = 0 auto behavior.
    float3 anchor_out = desired_background_state_lms;
    float3 contrast_lms = graded_lms;
    float3 compression_rolloff = ComputePeakCompressionRolloff(contrast_lms, anchor_out, peak_lms);
    float3 compressed_lms = peak_lms * compression_rolloff;

    // Test24 authored adaptive MacLeod-Boynton hue-direction restoration.
    float to_white_progress = max(compression_rolloff.x, max(compression_rolloff.y, compression_rolloff.z));
    float3 hue_restored_lms = renodx_custom::tonemap::psychov::psycho24_ApplyManualHueDirection(
        compressed_lms,
        contrast_lms,
        desired_background_state_lms,
        to_white_progress);

    // Test24 adaptive weighted-LMS compression against the BT.2020 boundary.
    float3 display_scaled_relative_weighted = renodx_custom::tonemap::psychov::psycho24_ToAdaptiveRelativeWeightedLMS(
        hue_restored_lms,
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

    // Match Test24's default-disabled post-gamut OKLab hue repair.
    const float gamut_hue_restore = 0.f;
    if (gamut_hue_restore != 0.f) {
      float3 pre_gamut_bt709 = renodx::color::bt709::from::LMS(hue_restored_lms);
      float3 hue_fixed_bt709 = renodx_custom::tonemap::psychov::psycho24_ApplyOKLabGamutHueDirection(
          gamut_mapped_bt709,
          pre_gamut_bt709,
          1);
      gamut_mapped_bt709 = lerp(gamut_mapped_bt709, hue_fixed_bt709, gamut_hue_restore);
    }

    tonemapped = gamut_mapped_bt709;
  }

  return renodx::color::gamma::EncodeSafe(tonemapped, 2.2f);
}
