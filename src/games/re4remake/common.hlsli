#include "./shared.h"

// from Pumbo
// 0 None
// 1 Reduce saturation and increase brightness until luminance is >= 0
// 2 Clip negative colors (makes luminance >= 0)
// 3 Snap to black
void FixColorGradingLUTNegativeLuminance(inout float3 col, uint type = 1) {
  if (type <= 0) {
    return;
  }

  float luminance = renodx::color::y::from::BT709(col.xyz);
  if (luminance < -renodx::math::FLT_MIN)  // -asfloat(0x00800000): -1.175494351e-38f
  {
    if (type == 1) {
      // Make the color more "SDR" (less saturated, and thus less beyond Rec.709) until the luminance is not negative anymore (negative luminance means the color was beyond Rec.709 to begin with, unless all components were negative).
      // This is preferrable to simply clipping all negative colors or snapping to black, because it keeps some HDR colors, even if overall it's still "black", luminance wise.
      // This should work even in case "positiveLuminance" was <= 0, as it will simply make the color black.
      float3 positiveColor = max(col.xyz, 0.0);
      float3 negativeColor = min(col.xyz, 0.0);
      float positiveLuminance = renodx::color::y::from::BT709(positiveColor);
      float negativeLuminance = renodx::color::y::from::BT709(negativeColor);
#pragma warning(disable: 4008)
      float negativePositiveLuminanceRatio = positiveLuminance / -negativeLuminance;
#pragma warning(default: 4008)
      negativeColor.xyz *= negativePositiveLuminanceRatio;
      col.xyz = positiveColor + negativeColor;
    } else if (type == 2) {
      // This can break gradients as it snaps colors to brighter ones (it depends on how the displays clips HDR10 or scRGB invalid colors)
      col.xyz = max(col.xyz, 0.0);
    } else  // if (type >= 3)
    {
      col.xyz = 0.0;
    }
  }
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

float3 LUTBlackCorrection(float3 color_input, Texture3D lut_texture, renodx::lut::Config lut_config) {
  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = renodx::lut::SampleColor(lut_input_color, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    const float lut_scaling_factor = 1.f;

    float3 lut_black = renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      float3 lut_mid = renodx::lut::SampleColor(renodx::lut::ConvertInput(lut_black_y, lut_config), lut_config, lut_texture);  // set midpoint based on black to avoid black crush
      float lut_shift = (renodx::color::y::from::BT709(lut_mid) / lut_black_y);

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input * lut_shift, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling * lut_scaling_factor);
      color_output = recolored;
    }
  } else {
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  }

  return lerp(color_input, color_output, lut_config.strength);
}

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.5f, float output_max = 1.f) {
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return color * scale;
}

float3 LUTToneMap(float3 untonemapped) {
  return ToneMapMaxCLL(untonemapped);
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  const float shadow_mask = mid_gray;

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

float3 ApplyCustomGrading(float3 ungraded) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = 0.f;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  float ungraded_y = renodx::color::y::from::BT709(ungraded);

  float3 graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded, ungraded_y, cg_config, 0.1f);
  graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded, ungraded, ungraded_y, cg_config);

  return graded;
}

float3 AdjustGammaByChannel(float3 linearColor, float gammaAdjustmentFactor) {
  if (gammaAdjustmentFactor == 1.f) return linearColor;  // No adjustment if factor is 1

  // Create a mask to identify components less than 1
  float3 mask = step(linearColor, float3(1.0f, 1.0f, 1.0f));  // 1 where linearColor < 1, 0 otherwise
  // Adjust gamma only for components where the value is less than 1
  return mask * renodx::color::gamma::EncodeSafe(linearColor, 1.f / gammaAdjustmentFactor) + (1.f - mask) * linearColor;
}

float3 ChrominanceOKLab(
    float3 incorrect_color,
    float3 reference_color,
    float strength = 1.f,
    float clamp_chrominance_loss = 0.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 reference_lab = renodx::color::oklab::from::BT709(reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 reference_ab = reference_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(reference_ab);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
  float scale = lerp(1.f, chrominance_ratio, strength);

  float t = 1.0f - step(1.0f, scale);  // t = 1 when scale < 1, 0 when scale >= 1
  scale = lerp(scale, 1.0f, t * clamp_chrominance_loss);

  incorrect_lab.yz = incorrect_ab * scale;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  FixColorGradingLUTNegativeLuminance(result);
  return result;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = max(0, renodx::color::y::from::BT709(incorrect_color));
  const float y_out = renodx::color::correct::Gamma(y_in);

  float3 lum = incorrect_color * (y_in > 0 ? y_out / y_in : 0.f);

  // use chrominance from per channel gamma correction
  float3 result = ChrominanceOKLab(lum, ch, 1.f, 1.f);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

float3 ApplyExponentialRolloff(float3 untonemapped, float diffuse_nits, float peak_nits) {
  // const float diffuse_nits = whitePaperNits;
  // const float peak_nits = max(displayMaxNits, whitePaperNits);
  const float rolloff_start = peak_nits * 0.465f;
  // const float rolloff_modulation = 1.25f;
  return exp2(renodx::tonemap::ExponentialRollOff(log2(untonemapped * diffuse_nits), log2(rolloff_start), log2(peak_nits))) / diffuse_nits;
}
