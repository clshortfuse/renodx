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

// Narkowicz
float3 ACESFittedBT709(float3 color) {
  float3 r1, r2, r3;

  r1.xyz = color;

  r2.xyz = r1.xyz * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r2.xyz = r2.xyz * r1.xyz;
  r3.xyz = r1.xyz * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
  r1.xyz = r1.xyz * r3.xyz + float3(0.140000001,0.140000001,0.140000001);
  r1.xyz = r2.xyz / r1.xyz;
  return r1.xyz;
}

float3 ReinhardPiecewise(float3 color) {
  renodx::draw::Config config = renodx::draw::BuildConfig(); // Pulls config values

  float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;              // Normalizes peak
  float diffuse_white_nits = config.diffuse_white_nits / renodx::color::srgb::REFERENCE_WHITE; // Normalizes game brightness

  float tonemap_peak = peak_nits / diffuse_white_nits;
  if (config.gamma_correction > 0.f) {
    tonemap_peak = renodx::color::correct::GammaSafe(tonemap_peak, config.gamma_correction > 0.f, abs(RENODX_GAMMA_CORRECTION) == 1.f ? 2.2f : 2.4f);
  }

  return renodx::tonemap::ReinhardPiecewise(color, tonemap_peak); // Need to divide peak_nits by diffuse_white_nits to accurately determine tonemapping peak. This is because game brightness is a linear scale that occurs after tonemapping.
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

float3 CustomTonemap(float3 untonemapped) {
  if (RENODX_TONE_MAP_TYPE == 0) return ACESFittedBT709(untonemapped);

  //untonemapped = PreTonemapSliders(untonemapped); // Applies exposure, contrast, flare, shadows, highlights before tonemapping

  float3 tonemapped_bt709_ch = ACESFittedBT709(untonemapped);  // Narkowicz ACES, per channel tonemap

  float out_mid_gray = ACESFittedBT709(0.18f).x;                                 // Get the mid gray value by tonemapping 0.18. Single value, so only need the one channel. Technically this would be a known value and you don't need to calculate it, I just don't know it.
  float3 untonemapped_midgray_adjusted = untonemapped * (out_mid_gray / 0.18f);  // Adjusts untonemapped to match the luminance of tonemapped

  float3 hdr_color;
  if (CUSTOM_TONE_MAP_CONFIGURATION == 0.f) {
    hdr_color = renodx::tonemap::UpgradeToneMap(untonemapped_midgray_adjusted, NeutralSDRYLerp(untonemapped_midgray_adjusted), tonemapped_bt709_ch);
  }
  else {    
    float y_in = renodx::color::y::from::BT709(untonemapped);                                    // Calculates luminance value from the 3 color channels
    float y_out = ACESFittedBT709(y_in).x;                                                       // Gets Luminance value resulting from the tonemap. Since luminance is a single value, we just need the result from any one channel.
    float3 tonemapped_bt709_lum = renodx::color::correct::Luminance(untonemapped, y_in, y_out);  // Apply the above calculations to get a by luminance tonemap
    float tonemapped_bt709_lum_y = renodx::color::y::from::BT709(tonemapped_bt709_lum);          // Get the luminance value of the luminance tonemap. Tbh, you may not need this and might be able to use y_out, I don't know how the math works out.

    hdr_color = lerp(tonemapped_bt709_lum, untonemapped_midgray_adjusted, saturate(tonemapped_bt709_lum_y));  // Blends the luminance tonemap and the midgray adjusted untonemapped color based on the luminance of the luminance tonemap, giving you HDR, but it won't look quite right yet.

    hdr_color = renodx::color::correct::Chrominance(hdr_color, tonemapped_bt709_ch, 1.f, 1.f);  // Applies the chrominance of per channel tonemapping to the HDR color
  }
  //hdr_color = ReinhardPiecewise(hdr_color);
  //hdr_color = PostTonemapSliders(hdr_color);                                                                                                  // Applies saturation, blowout, highlight saturation after tonemapping
  hdr_color = renodx::color::correct::Hue(hdr_color, tonemapped_bt709_ch, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_HUE_PROCESSOR);  // Hue correct towards SDR per channel tonemap
  return hdr_color;
}

float3 CustomGradingBegin(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0) return color;
  return NeutralSDRYLerp(color);
}

float3 CustomGradingEnd(float3 ungraded_color, float3 sdr_color, float3 graded_color) {
  if (RENODX_TONE_MAP_TYPE == 0) return graded_color;
  return renodx::tonemap::UpgradeToneMap(ungraded_color, sdr_color, graded_color, CUSTOM_GRADING_STRENGTH);
}

float3 CustomIntermediatePass(float3 color) {
  if (RENODX_TONE_MAP_TYPE != 0) {
    color = PreTonemapSliders(color);
    color = ReinhardPiecewise(color);
    color = PostTonemapSliders(color);
  }
  return renodx::draw::RenderIntermediatePass(color);
}