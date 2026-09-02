#include "./shared.h"

float3 ApplyPerChannelPurityAndHueBT2020(
    float3 source_bt2020,
    float3 target_bt2020,
    float purity_amount,
    float hue_amount) {
  const float epsilon = 1e-7f;
  float3 background_state_lms = renodx::color::lms::from::BT2020(0.18f.xxx);
  float3 source_lms = renodx::color::lms::from::BT2020(source_bt2020);
  float3 target_lms = renodx::color::lms::from::BT2020(target_bt2020);

  // Express both colors relative to the same D65 background in physiologically
  // weighted LMS, then separate carried Yf from MacLeod-Boynton chromaticity.
  float3 source_relative_weighted = renodx::math::DivideSafe(renodx::color::macleod_boynton::WeighLMS(source_lms), background_state_lms, 0.f);
  float3 target_relative_weighted = renodx::math::DivideSafe(renodx::color::macleod_boynton::WeighLMS(target_lms), background_state_lms, 0.f);
  float3 source_mb = renodx::color::macleod_boynton::from::WeightedLMS(source_relative_weighted);
  float3 target_mb = renodx::color::macleod_boynton::from::WeightedLMS(target_relative_weighted);
  float2 mb_white = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float2 source_offset = source_mb.xy - mb_white;
  float2 target_offset = target_mb.xy - mb_white;
  float source_length_squared = dot(source_offset, source_offset);
  float target_length_squared = dot(target_offset, target_offset);
  float source_radius = sqrt(max(source_length_squared, 0.f));
  float target_radius = sqrt(max(target_length_squared, 0.f));

  float2 source_direction = source_radius > epsilon
                                ? source_offset / source_radius
                                : float2(1.f, 0.f);
  float2 target_direction = target_radius > epsilon
                                ? target_offset / target_radius
                                : source_direction;
  if (source_radius <= epsilon) {
    source_direction = target_direction;
  }

  float2 output_direction = lerp(target_direction, source_direction, hue_amount);
  float output_direction_length_squared = dot(output_direction, output_direction);
  output_direction = output_direction_length_squared > epsilon
                         ? output_direction * rsqrt(output_direction_length_squared)
                         : target_direction;

  // Normalize purity against the BT.2020 boundary for each hue.
  float2 gamut_r;
  float2 gamut_g;
  float2 gamut_b;
  renodx::color::gamut::MakeRGBTriangleInMBAdaptiveWeighted(
      renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
      background_state_lms,
      gamut_r,
      gamut_g,
      gamut_b);

  bool has_source_boundary;
  bool has_target_boundary;
  bool has_output_boundary;
  float source_boundary_radius = renodx::color::gamut::RayMaxT_RGBTriangleInMB(
      mb_white,
      source_direction,
      gamut_r,
      gamut_g,
      gamut_b,
      has_source_boundary);
  float target_boundary_radius = renodx::color::gamut::RayMaxT_RGBTriangleInMB(
      mb_white,
      target_direction,
      gamut_r,
      gamut_g,
      gamut_b,
      has_target_boundary);
  float output_boundary_radius = renodx::color::gamut::RayMaxT_RGBTriangleInMB(
      mb_white,
      output_direction,
      gamut_r,
      gamut_g,
      gamut_b,
      has_output_boundary);

  float source_purity = has_source_boundary
                            ? saturate(renodx::math::DivideSafe(source_radius, source_boundary_radius, 0.f))
                            : 0.f;
  float target_purity = has_target_boundary
                            ? saturate(renodx::math::DivideSafe(target_radius, target_boundary_radius, 0.f))
                            : 0.f;
  float output_purity = lerp(target_purity, source_purity, purity_amount);
  float output_radius = has_output_boundary
                            ? output_purity * output_boundary_radius
                            : lerp(target_radius, source_radius, saturate(purity_amount));

  float3 output_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(float3(mb_white + output_direction * output_radius, target_mb.z));
  return renodx::color::bt2020::from::LMS(renodx::color::macleod_boynton::UnweighLMS(output_relative_weighted * background_state_lms));
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  // contrast & flare
  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;

  // highlights
  float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = renodx::color::grade::Shadows(y_highlighted, config.shadows, mid_gray);

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(float3 tonemapped, float3 hue_reference_color, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(renodx::color::bt709::from::AP1(color));

    float hue_correction_strength = config.hue_correction_strength;
    if (hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(renodx::color::bt709::from::AP1(hue_reference_color));

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);
      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, hue_correction_strength);
      float chrominance_post_adjust = distance(perceptual_new.yz, 0);

      // Apply back previous chrominance
      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    }

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::ap1::from::BT709(color);
    color = max(0, color);
  }
  return color;
}

float3 ApplyUserColorGradingAP1(float3 ungraded_ap1) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = 0.f;  // no hue correction
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  float ungraded_y = renodx::color::y::from::AP1(ungraded_ap1);

  float3 graded_ap1 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded_ap1, ungraded_y, cg_config);
  graded_ap1 = ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(graded_ap1, ungraded_ap1, ungraded_y, cg_config);

  return graded_ap1;
}

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float cbuffer_peak_nits, float cbuffer_diffuse_white_nits) {
  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  float3 tonemapped_bt2020;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // ACES (Customized)
#if RENODX_GAME_GAMMA_CORRECTION
    aces_min /= 2.5f;
#endif

    renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);

    float3 tonemapped_perch_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / 48.f;

    float y_in = renodx::color::y::from::AP1(untonemapped_ap1);
    float y_out = renodx::tonemap::aces::ODTToneMap(y_in, ODT_config) / 48.f;
    float3 tonemapped_lum_ap1 = (renodx::color::correct::Luminance(untonemapped_ap1, y_in, y_out));

    // Take full purity and partial hue from the per-channel tonemap.
    float3 tonemapped_source_bt2020 = renodx::color::bt2020::from::AP1(max(0.f, tonemapped_perch_ap1));
    float3 tonemapped_target_bt2020 = renodx::color::bt2020::from::AP1(max(0.f, tonemapped_lum_ap1));
    float hue_amount = lerp(0.5f, 1.f, saturate((y_out - 0.1f) / 0.9f));
    tonemapped_bt2020 = ApplyPerChannelPurityAndHueBT2020(
        tonemapped_source_bt2020,
        tonemapped_target_bt2020,
        1.f,
        hue_amount);

  } else {  // ACES
#if RENODX_GAME_GAMMA_CORRECTION
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

    renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);

    float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / 48.f);

#if RENODX_GAME_GAMMA_CORRECTION
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
#endif

    tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);
  }

  return renodx::color::pq::EncodeSafe(tonemapped_bt2020, RENODX_DIFFUSE_WHITE_NITS);
}
