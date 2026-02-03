#include "./shared.h"

void GamutCompression(inout float3 color, inout float compression_scale) {
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color);
  float grayscale = renodx::color::y::from::BT709(gamma_color.rgb);
  compression_scale = renodx::color::correct::ComputeGamutCompressionScale(gamma_color.rgb, grayscale);
  gamma_color = renodx::color::correct::GamutCompress(gamma_color, grayscale, compression_scale);
  color = renodx::color::gamma::DecodeSafe(gamma_color);
}

void GamutDecompression(inout float3 color, float compression_scale) {
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color);
  gamma_color = renodx::color::correct::GamutDecompress(gamma_color, compression_scale);
  color = renodx::color::gamma::DecodeSafe(gamma_color);
}

float3 ApplyPerChannelBlowoutHueShiftHueClip(float3 untonemapped, float mid_gray = 0.18f, float sdr_max = 1.f) {
  if (RENODX_SWAP_CHAIN_OUTPUT_PRESET == 0.f) return untonemapped;

  float max_clip = 100.f;
  float3 color = untonemapped;

  color = max(0, renodx::color::bt2020::from::BT709(color));

  if (SCENE_GRADE_PER_CHANNEL_BLOWOUT > 0.f && RENODX_SWAP_CHAIN_OUTPUT_PRESET != 0.f) {
    max_clip = SCENE_GRADE_PER_CHANNEL_BLOWOUT;
    float calculated_peak = max_clip + (sdr_max - 1.f);
    calculated_peak = max(calculated_peak, 1.f);

    // float calculated_peak_log = log2(calculated_peak);
    // float mid_gray_log = log2(mid_gray);
    // float3 untonemapped_log = log2(color);

    // untonemapped = max(0, renodx::color::bt2020::from::BT709(untonemapped));

    float3 graded_color = renodx::tonemap::ReinhardPiecewise(color, calculated_peak, mid_gray);
    // float3 graded_color = renodx::tonemap::HermiteSplinePerChannelRolloff(color, calculated_peak, 100.f);
    color = renodx::color::correct::Chrominance(color, graded_color, 1.f, 0.f, 1);
    color = renodx::color::correct::Hue(color, graded_color, SCENE_GRADE_PER_CHANNEL_HUE_SHIFT, 1);
  }
  if (SCENE_GRADE_HUE_CLIP > 0.f) {
    float3 hue_clipped_color = renodx::tonemap::ExponentialRollOff(color, 1.75f, 2.f);
    color = renodx::color::correct::Hue(color, hue_clipped_color, SCENE_GRADE_HUE_CLIP, 0);
  }
  color = renodx::color::bt709::from::BT2020(color);
  return color;
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

float HDRBoost(float color, float power = 0.20f, float normalization_point = 0.02f) {
  const float smoothing = power * 2.f;

  float boosted = max(color, lerp(color, normalization_point * pow(color / normalization_point, 1.f + power), renodx::tonemap::Reinhard(color, smoothing)));
  // float highlight_compression_scale = saturate(pow(saturate((color - highlight_compression_start) / (highlight_compression_peak - highlight_compression_start)), highlight_compression_curve));
  // float smoothed = lerp(boosted, color, highlight_compression_scale);
  return boosted;
  // return smoothed;
}

float3 HDRBoost(float3 color, float power = 0.20f, float normalization_point = 0.02f) {
  return float3(
      HDRBoost(color.r, power, normalization_point),
      HDRBoost(color.g, power, normalization_point),
      HDRBoost(color.b, power, normalization_point)
  );
}

float3 ApplyHDRBoost(float3 color, float power = 0.20f, int mode = 1, float normalization_point = 0.04f) {
  if (power == 0.f || RENODX_SWAP_CHAIN_OUTPUT_PRESET == 0) return color;

  color = max(0, renodx::color::bt2020::from::BT709(color));

  if (mode == 0) {  // Per Channel
    // color = HDRBoost(color, power, normalization_point);
    // color = renodx::tonemap::ReinhardPiecewiseExtended(color, HDRBoost(100.f, power, normalization_point), 100.f, 1.f);
    // color = ToneMapMaxCLLClip(color, 1.f, 100.f, HDRBoost(100.f, power, normalization_point));
  } 
  else if (mode == 1) {  // By Luminance
    float y_in = renodx::color::y::from::BT709(color);
    float y_out = HDRBoost(y_in, power, normalization_point);
    // float y_out = BoostHDR(y_in, 10.f, power, 0.18f);
    // y_out = exp2(renodx::tonemap::ExponentialRollOff(log2(y_out), log2(1.f), log2(100.f), log2(HDRBoost(100.f, power, normalization_point))));
    color = renodx::color::correct::Luminance(color, y_in, y_out);
    // color = ToneMapMaxCLLClip(color, 1.f, 100.f, HDRBoost(100.f, power, normalization_point));
    // color = NeuTwoMaxCLL(color, 100.f, HDRBoost(100.f, power, normalization_point));
    // color = HermiteSplineMaxCLL(color, 100.f, HDRBoost(100.f, power, normalization_point));
    // color = ReinhardPiecewiseExtendedMaxCLL(color, 100.f, HDRBoost(100.f, power, normalization_point));
  }
  color = renodx::color::bt709::from::BT2020(color);
  return color;
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

float3 PreTonemapSliders(float3 untonemapped) {
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  float y = renodx::color::y::from::BT709(untonemapped);
  float3 outputColor = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config);
  outputColor = ApplyHDRBoost(outputColor, CUSTOM_HDR_BOOST);
  outputColor = ApplyPerChannelBlowoutHueShiftHueClip(outputColor);
  return outputColor;
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

float3 HermiteSplineRolloff(float3 color) {
  return lerp(
      renodx::tonemap::HermiteSplineLuminanceRolloff(color),   // Luminance
      renodx::tonemap::HermiteSplinePerChannelRolloff(color),  // Per channel
      0.5f);
}

// float3 ReinhardPiecewise(float3 color) {
//   renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

//   float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;              // Normalizes peak
//   float diffuse_white_nits = config.diffuse_white_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes game brightness

//   return renodx::tonemap::ReinhardPiecewise(color, peak_nits / diffuse_white_nits);  // Need to divide peak_nits by diffuse_white_nits to accurately determine tonemapping peak. This is because game brightness is a linear scale that occurs after tonemapping.
// }

float3 DisplayMap(float3 color) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

  float tonemap_peak = 1.f;

  if (RENODX_SWAP_CHAIN_OUTPUT_PRESET > 0) {
    float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;              // Normalizes peak
    float diffuse_white_nits = config.diffuse_white_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes game brightness

    tonemap_peak = peak_nits / diffuse_white_nits;
    if (config.gamma_correction > 0.f) {
      tonemap_peak = renodx::color::correct::GammaSafe(tonemap_peak, config.gamma_correction > 0.f, abs(RENODX_GAMMA_CORRECTION) == 1.f ? 2.2f : 2.4f);
    }
  }

  float compression_scale;
  GamutCompression(color, compression_scale);

  //color = renodx::color::bt2020::from::BT709(color);

  float3 outputColor = color;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    // outputColor = renodx::tonemap::HermiteSplinePerChannelRolloff(color, tonemap_peak, 100.f);
    outputColor = renodx::tonemap::neutwo::MaxChannel(outputColor, tonemap_peak);
  }

  GamutDecompression(outputColor, compression_scale);

  //outputColor = renodx::color::bt709::from::BT2020(color);

  return outputColor;
}

float3 CustomSDRTonemap(float3 color) {
  //return saturate(color);
  if (RENODX_TONE_MAP_TYPE == 0.f) return saturate(color);
  // return NeutralSDRYLerp(color);
  return ToneMapMaxCLL(color);
  // return renodx::tonemap::HermiteSplinePerChannelRolloff(color, 1.f, 100.f);
  // return renodx::tonemap::HermiteSplineLuminanceRolloff(color, 1.f, 100.f);
  //return HermiteSplineRolloff(color);
}

float3 CustomUpgradeTonemap(float3 ungraded, float3 graded, float3 ungraded_sdr) {
  float3 outputColor;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    outputColor = graded;
  }
  else {
    outputColor = renodx::tonemap::UpgradeToneMap(ungraded, ungraded_sdr, graded, RENODX_COLOR_GRADE_STRENGTH);
    outputColor = PreTonemapSliders(outputColor);
    outputColor = PostTonemapSliders(outputColor); // max channel tonemap, so run before
    outputColor = DisplayMap(outputColor);
  }
  //return renodx::color::gamma::EncodeSafe(outputColor, 2.0);
  return renodx::color::srgb::EncodeSafe(outputColor);
}