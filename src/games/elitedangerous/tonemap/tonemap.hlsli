#include "../common.hlsli"
#include "./test20.hlsli"

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

float ContrastAndFlare(float x, float contrast, float flare, float mid_gray = 0.18f) {
  if (contrast == 1.f && flare == 0.f) return x;
  float x_normalized = x / mid_gray;
  float flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, 1.f);
  return pow(x_normalized, contrast * flare_ratio) * mid_gray;
}

float3 ApplyLuminanceGradingLMS(float3 color_lms, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float yf = max(0.f, renodx::color::yf::from::LMS(color_lms));
  float yf_adjusted = Highlights(yf, highlights, mid_gray_yf);
  yf_adjusted = Shadows(yf_adjusted, shadows, mid_gray_yf);
  yf_adjusted = ContrastAndFlare(yf_adjusted, contrast, flare, mid_gray_yf);
  return color_lms * renodx::math::DivideSafe(yf_adjusted, yf, 1.f);
}

float3 ApplyLuminanceGradingBT2020(float3 color_bt2020, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyLuminanceGradingLMS(color_lms, highlights, shadows, contrast, flare, mid_gray_yf);
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
    color_lms = renodx::tonemap::psychovtest20::psycho20_ApplyAdaptiveMBPurity(color_lms, mid_gray_lms, purity_scale);
  }

  return color_lms;
}

float3 ApplyPurityGradingBT2020(float3 color_bt2020, float purity_scale, float purity_highlights, float dechroma) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyPurityGradingLMS(color_lms, purity_scale, purity_highlights, dechroma, renodx::color::lms::from::BT2020(0.18f.xxx));
  return renodx::color::bt2020::from::LMS(color_lms);
}

float3 ApplyAnchoredAdaptationContrast(float3 color, float contrast,
                                       float3 anchor_in = 0.18f, float3 anchor_out = 0.18f,
                                       float flare = 0.f) {
  float3 ax = abs(color);
  float3 normalized = ax / anchor_in;
  float3 flare_ratio = renodx::math::DivideSafe(normalized + flare, normalized, 1.f);
  float3 exponent = contrast * flare_ratio;

  float3 ax_n = pow(ax, exponent);
  float3 s_n = pow(anchor_in, exponent);
  float3 response_target = ax_n / (ax_n + s_n);
  float3 response_baseline = ax / (ax + anchor_in);
  float3 gain = renodx::math::DivideSafe(response_target, response_baseline, 0.f);

  float3 contrasted = renodx::math::CopySign(ax * gain, color);
  return contrasted * (anchor_out / anchor_in);
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

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    untonemapped = renodx::color::bt2020::from::BT709(untonemapped);

    // Apply BT.2020 luminance and purity grading.
    untonemapped = ApplyLuminanceGradingBT2020(untonemapped,
                                               RENODX_TONE_MAP_HIGHLIGHTS,
                                               RENODX_TONE_MAP_SHADOWS,
                                               RENODX_TONE_MAP_CONTRAST,
                                               0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                               0.18f);
    untonemapped = ApplyPurityGradingBT2020(untonemapped,
                                            RENODX_TONE_MAP_SATURATION,
                                            -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
                                            RENODX_TONE_MAP_DECHROMA);

    tonemapped = renodx::tonemap::neutwo::PerChannel(untonemapped, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    tonemapped = renodx::color::bt709::from::BT2020(tonemapped);
  } else {
    const float MID_GRAY_IN = 0.119121851127f;
    const float MID_GRAY_OUT = 0.163979921774f;

    float3 untonemapped_lms = max(0, renodx::color::lms::from::BT709(untonemapped));
    float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(MID_GRAY_IN);
    float3 desired_background_state_lms = renodx::color::lms::from::BT709(MID_GRAY_OUT);
    float3 peak_lms = renodx::color::lms::from::BT709(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    // Apply anchored LMS contrast.
    float3 tonemapped_lms = ApplyAnchoredAdaptationContrast(untonemapped_lms, 1.78107f, current_adaptive_state_lms, desired_background_state_lms, 0.0025f);

    // Apply LMS luminance and purity grading.
    float output_mid_gray = renodx::color::yf::from::LMS(desired_background_state_lms);
    tonemapped_lms = ApplyLuminanceGradingLMS(tonemapped_lms,
                                              RENODX_TONE_MAP_HIGHLIGHTS,
                                              RENODX_TONE_MAP_SHADOWS,
                                              RENODX_TONE_MAP_CONTRAST,
                                              0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                              output_mid_gray);
    tonemapped_lms = ApplyPurityGradingLMS(tonemapped_lms,
                                           RENODX_TONE_MAP_SATURATION,
                                           -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
                                           RENODX_TONE_MAP_DECHROMA,
                                           desired_background_state_lms);

    // Convert source to adapted weighted LMS.
    float3 source_relative_weighted = renodx::tonemap::psychovtest20::psycho20_ToAdaptiveRelativeWeightedLMS(untonemapped_lms, current_adaptive_state_lms);

    // Convert target to adapted weighted LMS.
    float3 display_scaled_relative_weighted = renodx::tonemap::psychovtest20::psycho20_ToAdaptiveRelativeWeightedLMS(tonemapped_lms, desired_background_state_lms);

    // psychotm_test20-style MB hue direction restore.
    {
      float3 mb_source = renodx::color::macleod_boynton::from::WeightedLMS(source_relative_weighted);
      float3 mb_display_target = renodx::color::macleod_boynton::from::WeightedLMS(display_scaled_relative_weighted);
      float3 mb_adapted_bg = renodx::color::macleod_boynton::from::LMS(1.f);

      float2 source_offset = mb_source.xy - mb_adapted_bg.xy;
      float2 display_target_offset = mb_display_target.xy - mb_adapted_bg.xy;

      float src2 = dot(source_offset, source_offset);
      float display_tgt2 = dot(display_target_offset, display_target_offset);

      if (src2 > 1e-7f && display_tgt2 > 1e-7f) {
        float target_radius = sqrt(display_tgt2);
        float2 source_dir = source_offset * rsqrt(src2);
        float2 display_target_dir = display_target_offset * rsqrt(display_tgt2);

        float restore_weight = 0.5f;

        float2 blended_dir = lerp(display_target_dir, source_dir, restore_weight);
        float blended_len2 = dot(blended_dir, blended_dir);
        blended_dir = (blended_len2 > 1e-7f) ? (blended_dir * rsqrt(blended_len2)) : display_target_dir;

        float2 mb_restored_xy = mb_adapted_bg.xy + blended_dir * target_radius;
        float3 mb_restored = float3(mb_restored_xy, mb_display_target.z);

        display_scaled_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_restored);
      }
    }

    // psychotm_test20-style BT.2020-bound adaptive weighted LMS gamut compression.
    display_scaled_relative_weighted = renodx::tonemap::psychovtest20::psycho20_GamutCompressAdaptiveRelativeWeightedLMSBound(
        display_scaled_relative_weighted,
        desired_background_state_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);

    // Return compressed target to LMS.
    tonemapped_lms = renodx::color::macleod_boynton::UnweighLMS(
        renodx::tonemap::psychovtest20::psycho20_FromAdaptiveRelativeWeightedLMS(display_scaled_relative_weighted, desired_background_state_lms));

    // Compress channels to desaturate and hue shift highlights, then restore luminance.
    float tonemapped_yf = renodx::color::yf::from::LMS(tonemapped_lms);
    tonemapped_lms = renodx::tonemap::neutwo::PerChannel(tonemapped_lms, peak_lms);
    float tonemapped_neutwo_yf = renodx::color::yf::from::LMS(tonemapped_lms);
    tonemapped_lms *= renodx::math::DivideSafe(tonemapped_yf, tonemapped_neutwo_yf, 1.f);

    // Convert to BT.2020 for max channel peak limiting.
    float3 tonemapped_bt2020 = renodx::color::bt2020::from::LMS(tonemapped_lms);
    tonemapped_bt2020 = renodx::tonemap::neutwo::MaxChannel(
        max(0, tonemapped_bt2020),
        RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    tonemapped = renodx::color::bt709::from::BT2020(tonemapped_bt2020);
  }

  return renodx::color::gamma::EncodeSafe(tonemapped, 2.2f);
}
