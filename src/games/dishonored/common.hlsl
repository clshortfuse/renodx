#include "./shared.h"
#include "./luma/Color.hlsl"

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

float3 ApplySaturationBlowoutHighlightSaturation(float3 tonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

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

float3 PreTonemapSliders(float3 untonemapped) {
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  float y = renodx::color::y::from::BT709(untonemapped);
  return ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config);
}

float3 PostTonemapSliders(float3 hdr_color) {
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  float y = renodx::color::y::from::BT709(hdr_color);
  return ApplySaturationBlowoutHighlightSaturation(hdr_color, y, config);
}

float3 FakeHDR(float3 Color, float NormalizationPoint = 0.02, float FakeHDRIntensity = 0.5, float SaturationExpansionIntensity = 0.0, uint Method = 0, uint ColorSpace = CS_DEFAULT)
{
  if (Method == 0)  // Per channel (and optionally restores the luminance of the per channel boosted, given that this naturally expands saturation)
  {
    float3 normalizedColor = Color / NormalizationPoint;
    // Expand highlights with a power curve
    //normalizedColor = select(normalizedColor > 1., pow(normalizedColor, 1. + FakeHDRIntensity), normalizedColor);
    normalizedColor = normalizedColor > 1.0 ? pow(normalizedColor, 1.0 + FakeHDRIntensity) : normalizedColor;
    Color = lerp(RestoreLuminance(Color, normalizedColor * NormalizationPoint, (bool)ColorSpace), normalizedColor * NormalizationPoint, SaturationExpansionIntensity);
  }
  else if (Method == 1 || Method == 2)
  {
    float colorValue = 0.0;
    if (Method == 1)  // By rgb max (will not boost whites any more than pure colors, and results depend on the color space)
      colorValue = max3(Color);
    else if (Method == 2)  // By luminance (will mostly ignore blues)
      colorValue = GetLuminance(Color, ColorSpace);
    float normalizedColorValue = colorValue / NormalizationPoint;
    normalizedColorValue = normalizedColorValue > 1.0 ? pow(normalizedColorValue, 1.0 + FakeHDRIntensity) : normalizedColorValue;
    float expansionRatio = safeDivision(normalizedColorValue * NormalizationPoint, colorValue, 1);  // Fallback to 1
    Color *= expansionRatio;

    // Expand saturation as well, on highlights only
    if (SaturationExpansionIntensity != 0.0)  // Optional optimization, given this would usually be hardcoded to 0
      Color = Saturation(Color, lerp(1.0, expansionRatio, SaturationExpansionIntensity), ColorSpace);
  }
  return Color;
}

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color;
  }
  color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

float3 NeutralSDRYLerp(float3 color) {
  float color_y = renodx::color::y::from::BT709(color);
  color = lerp(color, renodx::tonemap::renodrt::NeutralSDR(color), saturate(color_y));
  return color;
}

float3 ReinhardPiecewise(float3 color) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

  float peak_nits = config.peak_white_nits / renodx::color::bt709::REFERENCE_WHITE;              // Normalizes peak
  float diffuse_white_nits = config.diffuse_white_nits / renodx::color::bt709::REFERENCE_WHITE;  // Normalizes game brightness

  return renodx::tonemap::ReinhardPiecewise(color, peak_nits / diffuse_white_nits);  // Need to divide peak_nits by diffuse_white_nits to accurately determine tonemapping peak. This is because game brightness is a linear scale that occurs after tonemapping.
}

float3 CustomSDRTonemap(float3 color) {
  //return saturate(color);
  if (RENODX_TONE_MAP_TYPE == 0.f) return saturate(color);
  return NeutralSDRYLerp(color);
  //return ToneMapMaxCLL(color);
}

float3 CustomUpgradeTonemap(float3 ungraded, float3 graded, float3 ungraded_sdr) {
  float3 outputColor;
  if (RENODX_TONE_MAP_TYPE < 2.f) {
    outputColor = graded;
  }
  else {
    outputColor = renodx::tonemap::UpgradeToneMap(ungraded, ungraded_sdr, graded, RENODX_COLOR_GRADE_STRENGTH);
    outputColor = PreTonemapSliders(outputColor);
    outputColor = ReinhardPiecewise(outputColor);
    outputColor = PostTonemapSliders(outputColor);
    outputColor = FakeHDR(outputColor, 0.1f, CUSTOM_HDR_BOOST, 1.f, 0);
  }
  //return renodx::color::gamma::EncodeSafe(outputColor, 2.0);
  return renodx::color::srgb::EncodeSafe(outputColor);
}