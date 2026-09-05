#include "../common.hlsli"
#include "./customtest30.hlsli"

#define ANVIL_ENGINE_TONEMAP_GENERATOR(T)                                                                                                \
  T EvaluateAnvilEngineToeAndLinear(T input, float linear_slope, float toe_end, float toe_power, float toe_offset) {                     \
    T input_abs = abs(input);                                                                                                            \
    bool toe_enabled = toe_end > 1e-5f;                                                                                                  \
    T toe_progress_unclamped = input_abs / toe_end;                                                                                      \
    T toe_progress = saturate(toe_progress_unclamped);                                                                                   \
    T toe_progress_squared = toe_progress * toe_progress;                                                                                \
    T smoothstep_factor = mad(toe_progress, -2.f, 3.f);                                                                                  \
    T toe_output = renodx::math::Select(toe_enabled, mad(pow(abs(toe_progress_unclamped), toe_power), toe_end, toe_offset), toe_offset); \
    T toe_blend_weight = mad(-smoothstep_factor, toe_progress_squared, 1.f);                                                             \
    T linear_output = mad(input_abs - toe_end, linear_slope, toe_end);                                                                   \
    T toe_to_linear_blend = mad(smoothstep_factor, toe_progress_squared, -1.f) + 1.f;                                                    \
    T toe_linear_output = (toe_blend_weight * toe_output) + (toe_to_linear_blend * linear_output);                                       \
    return toe_linear_output;                                                                                                            \
  }                                                                                                                                      \
  T ApplyAnvilEngineToneMapShoulder(T toe_linear_output, float toe_end, float peak_ratio, float shoulder_start) {                        \
    float toe_to_peak_output_range = peak_ratio - toe_end;                                                                               \
    float shoulder_start_output = mad(toe_to_peak_output_range, shoulder_start, toe_end);                                                \
    return renodx::tonemap::ExponentialRollOff(toe_linear_output, shoulder_start_output, peak_ratio);                                    \
  }                                                                                                                                      \
  T ApplyAnvilEngineToneMap(                                                                                                             \
      T input, float linear_slope, float toe_end, float toe_power, float toe_offset, float peak_ratio, float shoulder_start) {           \
    return ApplyAnvilEngineToneMapShoulder(                                                                                              \
        EvaluateAnvilEngineToeAndLinear(input, linear_slope, toe_end, toe_power, toe_offset), toe_end, peak_ratio, shoulder_start);      \
  }

ANVIL_ENGINE_TONEMAP_GENERATOR(float)
ANVIL_ENGINE_TONEMAP_GENERATOR(float3)
#undef ANVIL_ENGINE_TONEMAP_GENERATOR

#define CUSTOM_ANVIL_ENGINE_TONEMAP_GENERATOR(T)                                                                                            \
  T EvaluateCustomAnvilEngineToeAndLinear(T input, float linear_slope, float toe_end, float toe_power, float toe_offset, float toe_flare) { \
    T linear_output = mad(input - toe_end, linear_slope, toe_end);                                                                          \
    if (toe_end <= 1e-5f) return linear_output;                                                                                             \
    T toe_progress = saturate(input / toe_end);                                                                                             \
    T effective_toe_power = toe_power;                                                                                                      \
    [branch]                                                                                                                                \
    if (toe_flare > 0.f) {                                                                                                                  \
      T shadow_distance = 1.f - toe_progress;                                                                                               \
      T flat_shadow_weight = exp2(-toe_progress / shadow_distance);                                                                         \
      effective_toe_power *= mad(flat_shadow_weight, toe_flare / (toe_progress + toe_flare), 1.f);                                          \
    }                                                                                                                                       \
    T toe_output = mad(pow(toe_progress, effective_toe_power), toe_end, toe_offset);                                                        \
    T toe_to_linear_blend = rcp(1.f + exp2((1.f - 2.f * toe_progress) / (toe_progress * (1.f - toe_progress))));                            \
    return mad(toe_to_linear_blend, linear_output - toe_output, toe_output);                                                                \
  }

CUSTOM_ANVIL_ENGINE_TONEMAP_GENERATOR(float)
CUSTOM_ANVIL_ENGINE_TONEMAP_GENERATOR(float3)
#undef CUSTOM_ANVIL_ENGINE_TONEMAP_GENERATOR

float3 ApplyCustomAnvilEnginePsychoV30ToneMap(
    float3 untonemapped_ap1,
    float peak_value,
    float linear_slope,
    float toe_end,
    float toe_power,
    float toe_offset,
    float toe_flare,
    float post_saturation,
    float shoulder_start,
    float mean_a2_source_weight = 1.f,
    int target_gamut_mode = renodx::tonemap::psychov::PSYCHO30_TARGET_GAMUT_BT2020,
    float compression = 1.5f,
    float gamut_compression = 1.f) {
  float3 finite_ap1_input = renodx::math::ZeroNaN(untonemapped_ap1);
  finite_ap1_input = renodx::math::Select(
      isinf(finite_ap1_input),
      renodx::math::CopySign(renodx::tonemap::psychov::PSYCHO30_MAX_FINITE_INPUT.xxx, finite_ap1_input),
      finite_ap1_input);
  float3 finite_bt709_input = renodx::math::ZeroNaN(renodx::color::bt709::from::AP1(finite_ap1_input));
  finite_bt709_input = renodx::math::Select(
      isinf(finite_bt709_input),
      renodx::math::CopySign(renodx::tonemap::psychov::PSYCHO30_MAX_FINITE_INPUT.xxx, finite_bt709_input),
      finite_bt709_input);

  float3 source_lms = renodx::tonemap::psychov::psycho30_AnchorSourcePositiveTotalToYf(finite_bt709_input);
  if (all(source_lms == 0.f.xxx)) return 0.f.xxx;

  float input_adaptive_anchor = toe_end + ((shoulder_start - toe_end) / linear_slope);
  float3 input_adaptive_anchor_lms = input_adaptive_anchor * renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS;
  float3 output_adaptive_anchor_lms = shoulder_start * renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS;
  float3 target_peak_lms = peak_value * renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS;

  float3 toe_linear_lms =
      EvaluateCustomAnvilEngineToeAndLinear(
          source_lms / renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS,
          linear_slope,
          toe_end,
          toe_power,
          toe_offset,
          toe_flare)
      * renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS;
  float3 response_lms = renodx::tonemap::psychov::psycho30_ApplyAnchoredCInfinityShoulder(
      toe_linear_lms,
      target_peak_lms,
      output_adaptive_anchor_lms,
      compression);
  if (post_saturation != 1.f) {
    response_lms = renodx::tonemap::psychov::psycho30_ApplyAdaptiveLMSPurity(
        response_lms,
        output_adaptive_anchor_lms,
        post_saturation);
    response_lms = max(response_lms, 0.f);
  }

  float response_yf;
  uint response_valid;
  float3 desired_coord = renodx::tonemap::psychov::psycho30_MeanA2ResponseFromCustomResponse(
      source_lms / input_adaptive_anchor_lms,
      response_lms / target_peak_lms,
      mean_a2_source_weight,
      response_yf,
      response_valid);
  if (response_valid == 0u) return 0.f.xxx;

  float3 selected_coord = desired_coord;
  if (gamut_compression != 0.f) {
    uint solve_valid;
    float3 solved_coord = renodx::tonemap::psychov::psycho30_ApplyCustomSoftRadialGamutCompression(
        desired_coord,
        response_yf,
        target_gamut_mode,
        solve_valid);
    if (solve_valid == 0u) return 0.f.xxx;
    selected_coord = gamut_compression == 1.f
                         ? solved_coord
                         : lerp(desired_coord, solved_coord, gamut_compression);
  }

  float output_a = selected_coord.y * rsqrt(3.f)
                   + renodx::tonemap::psychov::PSYCHO30_D65_ALPHA_DELTA
                         * selected_coord.x * rsqrt(2.f)
                   - selected_coord.z * rsqrt(6.f);
  float3 output_bt709 = peak_value
                        * (output_a
                           + selected_coord.x * renodx::tonemap::psychov::PSYCHO30_BT709_A2_X_RGB
                           + selected_coord.z * renodx::tonemap::psychov::PSYCHO30_BT709_A2_Z_RGB);
  float3 output_ap1 = renodx::color::ap1::from::BT709(output_bt709);
  return !any(isnan(output_ap1)) && !any(isinf(output_ap1))
             ? output_ap1
             : 0.f.xxx;
}

float3 Psycho23ToAdaptiveRelativeWeightedLMS(
    float3 lms_input,
    float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 Psycho23FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float3 Psycho23GamutCompressAdaptiveRelativeWeightedLMSBound(
    float3 lms_weighted_relative_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  return renodx::color::gamut::GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
      lms_weighted_relative_input,
      current_adaptive_state_lms,
      bound_rgb_to_lms_weighted_mat,
      strength);
}

float3 BuildToneMapLUTOutput(float3 untonemapped_ap1, float exposure, float display_peak_nits, bool hdr_enabled) {
  untonemapped_ap1 /= 100.f;

  // The game uses twice the SDR exposure by default when HDR is enabled.
  float diffuse_white_nits = (exposure / 64.f) * 203.f;
  float target_peak_ratio = display_peak_nits / diffuse_white_nits;
  float3 tonemapped_bt709;

  if (RENODX_TONE_MAP_TYPE == 2.f) {
    int target_gamut_mode = renodx::tonemap::psychov::PSYCHO30_TARGET_GAMUT_DISPLAY_P3;
    if (!hdr_enabled) {
      target_peak_ratio = 1.f;
      target_gamut_mode = renodx::tonemap::psychov::PSYCHO30_TARGET_GAMUT_BT709;
    }

    float linear_slope = 1.625f;
    float shoulder_start = 0.18f;
    float toe_end = 0.05f;
    float toe_power = 1.15f;
    float toe_offset = 0.f;
    float toe_flare = 0.1f * pow(0.875f, 10.f);
    float post_saturation = 1.f;

    float3 tonemapped_ap1 = ApplyCustomAnvilEnginePsychoV30ToneMap(
        untonemapped_ap1,
        target_peak_ratio,
        linear_slope,
        toe_end,
        toe_power,
        toe_offset,
        toe_flare,
        post_saturation,
        shoulder_start,
        1.f,
        target_gamut_mode);
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

  } else {
    if (RENODX_GAME_GAMMA_CORRECTION != 0.f) {
      target_peak_ratio = renodx::color::correct::GammaSafe(target_peak_ratio, true);
    }

    float linear_slope = 1.5f;
    float shoulder_start = 0.5f;
    float toe_end = 0.05f;
    float toe_power = 1.f;
    float toe_offset = 0.f;
    if (!hdr_enabled) {
      target_peak_ratio = 1.f;
    }

    float3 tonemapped_ap1 = ApplyAnvilEngineToneMap(untonemapped_ap1, linear_slope, toe_end, toe_power, toe_offset, target_peak_ratio, shoulder_start);
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

    const float output_anchor = 0.18f;
    const float input_adaptive_anchor = toe_end + ((output_anchor - toe_end) / linear_slope);
    float3 input_adaptive_anchor_lms = renodx::color::lms::from::AP1(input_adaptive_anchor.xxx);
    float3 tonemapped_lms = renodx::color::lms::from::BT709(tonemapped_bt709);
    float3 tonemapped_relative_weighted = Psycho23ToAdaptiveRelativeWeightedLMS(
        tonemapped_lms,
        input_adaptive_anchor_lms);
    tonemapped_relative_weighted = Psycho23GamutCompressAdaptiveRelativeWeightedLMSBound(
        tonemapped_relative_weighted,
        input_adaptive_anchor_lms,
        hdr_enabled ? renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT
                    : renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
        1.f);
    tonemapped_bt709 = renodx::color::bt709::from::LMS(
        renodx::color::macleod_boynton::UnweighLMS(
            Psycho23FromAdaptiveRelativeWeightedLMS(
                tonemapped_relative_weighted,
                input_adaptive_anchor_lms)));

    if (RENODX_GAME_GAMMA_CORRECTION != 0.f) {
      tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
    }
  }

  if (hdr_enabled) {
    return renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), diffuse_white_nits);
  }
  return renodx::color::gamma::EncodeSafe(tonemapped_bt709);
}
