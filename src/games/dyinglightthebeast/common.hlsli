#include "./shared.h"

// From Pumbo
// This basically does gamut mapping, however it's not focused on gamut as primaries, but on peak white.
// The color is expected to be in the specified color space and in linear.
//
// The sum of "DesaturationAmount" and "DarkeningAmount" needs to be <= 1, both within 0 and 1.
// The closer the sum is to 1, the more each color channel will be containted within its peak range.
float3 CorrectOutOfRangeColor(float3 Color, bool FixNegatives = true, bool FixPositives = true, float Peak = 1.0, float DesaturationAmount = 0.5, float DarkeningAmount = 0.5, bool use_bt2020 = true) {
  if (FixNegatives && any(Color < 0.0))  // Optional "optimization" branch
  {
    float colorLuminance = use_bt2020 ? renodx::color::y::from::BT2020(Color) : renodx::color::y::from::BT709(Color);

    float3 positiveColor = max(Color.xyz, 0.0);
    float3 negativeColor = min(Color.xyz, 0.0);
    float positiveLuminance = use_bt2020 ? renodx::color::y::from::BT2020(positiveColor) : renodx::color::y::from::BT709(positiveColor);
    float negativeLuminance = use_bt2020 ? renodx::color::y::from::BT2020(negativeColor) : renodx::color::y::from::BT709(negativeColor);
    // Desaturate until we are not out of gamut anymore
    if (colorLuminance > renodx::math::FLT32_MIN) {
#if 0
	  float negativePositiveLuminanceRatio = -negativeLuminance / positiveLuminance;
	  float3 positiveColorRestoredLuminance = RestoreLuminance(positiveColor, colorLuminance, true, ColorSpace);
	  Color = lerp(lerp(Color, positiveColorRestoredLuminance, sqrt(DesaturationAmount)), colorLuminance, negativePositiveLuminanceRatio * sqrt(DesaturationAmount));
#else  // This should look better and be faster
      const float3 luminanceRatio = use_bt2020 ? renodx::color::BT2020_TO_XYZ_MAT[1].rgb : renodx::color::BT709_TO_XYZ_MAT[1].rgb;
      float3 negativePositiveLuminanceRatio = -(negativeColor / luminanceRatio) / (positiveLuminance / luminanceRatio);
      Color = lerp(Color, colorLuminance, negativePositiveLuminanceRatio * DesaturationAmount);
#endif
      // TODO: "DarkeningAmount" isn't normalized with "DesaturationAmount", so setting both to 50% won't perfectly stop gamut clip
      positiveColor = max(Color.xyz, 0.0);
      negativeColor = min(Color.xyz, 0.0);
      Color = positiveColor + (negativeColor * (1.0 - DarkeningAmount));  // It's not darkening but brightening in this case
    }
    // Increase luminance until it's 0 if we were below 0 (it will clip out the negative gamut)
    else if (colorLuminance < -renodx::math::FLT32_MIN) {
      float negativePositiveLuminanceRatio = positiveLuminance / -negativeLuminance;
      negativeColor.xyz *= negativePositiveLuminanceRatio;
      Color.xyz = positiveColor + negativeColor;
    }
    // Snap to 0 if the overall luminance was zero, there's nothing to savage, no valid information on rgb ratio
    else {
      Color.xyz = 0.0;
    }
  }

  if (FixPositives && any(Color > Peak))  // Optional "optimization" branch
  {
    float colorLuminance = renodx::color::y::from::BT2020(Color);
    float colorLuminanceInExcess = colorLuminance - Peak;
    float maxColorInExcess = renodx::math::Max(Color.r, Color.g, Color.b) - Peak;                                                  // This is guaranteed to be >= "colorLuminanceInExcess"
    float brightnessReduction = saturate(renodx::math::SafeDivision(Peak, renodx::math::Max(Color.r, Color.g, Color.b), 1));       // Fall back to one in case of division by zero
    float desaturateAlpha = saturate(renodx::math::SafeDivision(maxColorInExcess, maxColorInExcess - colorLuminanceInExcess, 0));  // Fall back to zero in case of division by zero
    Color = lerp(Color, colorLuminance, desaturateAlpha * DesaturationAmount);
    Color = lerp(Color, Color * brightnessReduction, DarkeningAmount);  // Also reduce the brightness to partially maintain the hue, at the cost of brightness
  }

  return Color;
}

float ReinhardPiecewiseExtended(float x, float white_max, float x_max = 1.f, float shoulder = 0.18f) {
  const float x_min = 0.f;
  float exposure = renodx::tonemap::ComputeReinhardExtendableScale(white_max, x_max, x_min, shoulder, shoulder);
  float extended = renodx::tonemap::ReinhardExtended(x * exposure, white_max * exposure, x_max);
  extended = min(extended, x_max);

  return lerp(x, extended, step(shoulder, x));
}

float3 ReinhardPiecewiseExtended(float3 x, float white_max, float x_max = 1.f, float shoulder = 0.18f) {
  const float x_min = 0.f;
  float exposure = renodx::tonemap::ComputeReinhardExtendableScale(white_max, x_max, x_min, shoulder, shoulder);
  float3 extended = renodx::tonemap::ReinhardExtended(x * exposure, white_max * exposure, x_max);
  extended = min(extended, x_max);

  return lerp(x, extended, step(shoulder, x));
}

float3 GradingCorrectBlack(float3 color_input, float3 color_output, float3 grading_color) {
  if (RENODX_COLOR_GRADE_SCALING) {
    float lut_min_y = (renodx::color::y::from::BT709(grading_color));
    if (lut_min_y > 0) {
      float mid_gray_shift = renodx::color::y::from::BT709(0.18.xxx + grading_color) / 0.18f;
      float3 corrected_black = renodx::lut::CorrectBlack(color_input * mid_gray_shift, color_output, lut_min_y, 100.f);

      float scaling_strength = 0.87f;
      color_output = lerp(color_output, corrected_black, RENODX_COLOR_GRADE_SCALING * scaling_strength);
    }
  }

  return color_output;
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  float shadow_mask = 1.f;
  if (config.shadows < 1.f) shadow_mask = mid_gray;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted / highlight_mask));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted / shadow_mask));

  const float y_final = y_shadowed * mid_gray;

  color *= (y > 0 ? (y_final / y) : 0);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 untonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(untonemapped);

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, config.hue_correction_strength);

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

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 RestoreHueAndChrominanceBT2020(float3 incorrect_color, float3 reference_color, float y,
                                      float hue_strength = 0.5, float chrominance_strength = 1.0,
                                      float dechroma = 0.f, float blowout = 0.f, float saturation = 1.f) {
  if (hue_strength == 0.f && chrominance_strength == 0.f && dechroma == 0.f && blowout == 0.f && saturation == 0.f) return incorrect_color;

  reference_color = renodx::color::bt709::from::BT2020(reference_color);
  incorrect_color = renodx::color::bt709::from::BT2020(incorrect_color);

  const float3 reference_oklab = renodx::color::oklab::from::BT709(reference_color);
  float3 incorrect_oklab = renodx::color::oklab::from::BT709(incorrect_color);

  float chrominance_current = length(incorrect_oklab.yz);
  float chrominance_ratio = 1.0;

  if (hue_strength != 0.0) {
    const float chrominance_pre = chrominance_current;
    incorrect_oklab.yz = lerp(incorrect_oklab.yz, reference_oklab.yz, hue_strength);
    const float chrominancePost = length(incorrect_oklab.yz);
    chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
    chrominance_current = chrominancePost;
  }

  if (chrominance_strength != 0.0) {
    const float reference_chrominance = length(reference_oklab.yz);
    float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
    chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_strength);
  }
  incorrect_oklab.yz *= chrominance_ratio;

  if (dechroma != 0.f) {
    incorrect_oklab.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - dechroma))));
  }

  if (blowout != 0.f) {
    float percent_max = saturate(y * 100.f / 10000.f);
    // positive = 1 to 0, negative = 1 to 2
    float blowout_strength = 100.f;
    float blowout_change = pow(1.f - percent_max, blowout_strength * abs(blowout));
    if (blowout < 0) {
      blowout_change = (2.f - blowout_change);
    }

    incorrect_oklab.yz *= blowout_change;
  }

  incorrect_oklab.yz *= saturation;

  return renodx::color::bt2020::from::BT709(renodx::color::bt709::from::OkLab(incorrect_oklab));
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = max(0, renodx::color::y::from::BT709(incorrect_color));
  const float y_out = renodx::color::correct::Gamma(y_in);

  float3 lum = renodx::color::correct::Luminance(incorrect_color, y_in, y_out);

  // use chrominance from per channel gamma correction
  float3 result = renodx::color::correct::ChrominanceOKLab(lum, ch, 1.f, 1.f);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

renodx::color::grade::Config CreateColorGradingConfig() {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  return cg_config;
}

float3 ApplyToneMap(float3 untonemapped_bt2020) {
  renodx::color::grade::Config cg_config = CreateColorGradingConfig();
  untonemapped_bt2020 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_bt2020, renodx::color::y::from::BT2020(untonemapped_bt2020), cg_config);

  float3 tonemapped_bt2020 = untonemapped_bt2020;
  float y = renodx::color::y::from::BT2020(untonemapped_bt2020);
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    cg_config.hue_correction_strength = 0.f;
    tonemapped_bt2020 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(untonemapped_bt2020, untonemapped_bt2020,
                                                                               y, cg_config);
  } else {
    if (RENODX_TONE_MAP_PER_CHANNEL) {
      tonemapped_bt2020 = ReinhardPiecewiseExtended(untonemapped_bt2020, RENODX_TONE_MAP_WHITE_CLIP, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 0.5f);
      tonemapped_bt2020 = RestoreHueAndChrominanceBT2020(tonemapped_bt2020, untonemapped_bt2020, renodx::color::y::from::BT2020(untonemapped_bt2020),
                                                         RENODX_TONE_MAP_HUE_CORRECTION, RENODX_PER_CHANNEL_BLOWOUT_RESTORATION,
                                                         cg_config.dechroma, cg_config.blowout, cg_config.saturation);
    } else {
      float y_out = ReinhardPiecewiseExtended(y, RENODX_TONE_MAP_WHITE_CLIP, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 0.5f);
      tonemapped_bt2020 = renodx::color::correct::Luminance(untonemapped_bt2020, y, y_out);
      tonemapped_bt2020 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(tonemapped_bt2020, untonemapped_bt2020, y, cg_config);
    }

    tonemapped_bt2020 = CorrectOutOfRangeColor(tonemapped_bt2020, true, true, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  }

  tonemapped_bt2020 = max(0, tonemapped_bt2020);
  return tonemapped_bt2020;
}

float3 ApplyGammaCorrectionAndToneMap(float3 untonemapped_bt2020) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped_bt2020;
  untonemapped_bt2020 /= RENODX_DIFFUSE_WHITE_NITS;

  float3 untonemapped_bt709 = renodx::color::bt709::from::BT2020(untonemapped_bt2020);
  untonemapped_bt709 = ApplyGammaCorrection(untonemapped_bt709);
  untonemapped_bt2020 = renodx::color::bt2020::from::BT709(untonemapped_bt709);

  float3 tonemapped_bt2020 = ApplyToneMap(untonemapped_bt2020);  // clamp to BT.2020 required for skills menu
  tonemapped_bt2020 *= RENODX_DIFFUSE_WHITE_NITS;

  return tonemapped_bt2020;
}
