#include "./shared.h"

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

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 ungraded) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = RENODX_TONE_MAP_FLARE;

  return ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded, renodx::color::y::from::BT709(ungraded), cg_config, 0.18f);
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 ungraded, float3 untonemapped) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = 0.f;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  return ApplySaturationBlowoutHueCorrectionHighlightSaturation(ungraded, ungraded, renodx::color::y::from::BT709(untonemapped), cg_config);
}

// from Pumbo
// 0 None
// 1 Reduce saturation and increase brightness until luminance is >= 0
// 2 Clip negative colors (makes luminance >= 0)
// 3 Snap to black
void FixColorGradingLUTNegativeLuminance(inout float3 col, uint type = 1)
        {
  if (type <= 0) { return; }

  float luminance = renodx::color::y::from::BT709(col.xyz);
  if (luminance < -renodx::math::FLT_MIN)  // -asfloat(0x00800000): -1.175494351e-38f
  {
    if (type == 1)
                {
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
    }
                else if (type == 2)
                {
      // This can break gradients as it snaps colors to brighter ones (it depends on how the displays clips HDR10 or scRGB invalid colors)
      col.xyz = max(col.xyz, 0.0);
    }
                else  // if (type >= 3)
    {
      col.xyz = 0.0;
    }
  }
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
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    return GammaCorrectHuePreserving(incorrect_color);
  } else {
    return renodx::color::correct::GammaSafe(incorrect_color);
  }
}