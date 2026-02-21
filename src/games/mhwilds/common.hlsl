#include "./shared.h"

float3 AP1toAP0(float3 color) {
  float _387 = mad(color.b, 0.1638689935207367f, mad(color.g, 0.1406790018081665f, (color.r * 0.6954519748687744f)));
  float _390 = mad(color.b, 0.0955343022942543f, mad(color.g, 0.8596709966659546f, (color.r * 0.04479460045695305f)));
  float _393 = mad(color.b, 1.0015000104904175f, mad(color.g, 0.004025210160762072f, (color.r * -0.00552588002756238f)));
  return float3(_387, _390, _393);
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.375f, float output_max = 1.f, float white_clip = 100.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return 1.f;
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  // color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

float3 HermiteSplineMaxCLL(float3 color, float tonemap_peak, float white_clip) {
  float rgb_max = renodx::math::Max(color);
  float rgb_max_log = log2(rgb_max);
  float tonemap_peak_log = log2(tonemap_peak);

  float tonemapped_log = renodx::tonemap::HermiteSplineRolloff(rgb_max_log, tonemap_peak_log, log2(white_clip));
  float tonemapped = exp2(tonemapped_log);

  float scale = renodx::math::DivideSafe(tonemapped, rgb_max, 1.f);
  return color * scale;
}

// float3 NeutwoMaxCLL(float3 color, float tonemap_peak, float white_clip) {
//   float rgb_max = renodx::math::Max(color);
//   float rgb_max_log = log2(rgb_max);
//   float tonemap_peak_log = log2(tonemap_peak);

//   float tonemapped_log = renodx::tonemap::Neutwo(rgb_max_log, tonemap_peak_log, log2(white_clip));
//   float tonemapped = exp2(tonemapped_log);

//   float scale = renodx::math::DivideSafe(tonemapped, rgb_max, 1.f);
//   return color * scale;
// }

float3 ReinhardPiecewiseExtendedMaxCLL(float3 color, float rolloff_start, float tonemap_peak, float white_clip) {
  float rgb_max = renodx::math::Max(color);
  // float rgb_max = renodx::color::y::from::BT709(color); // by luminance for testing
  float rgb_max_log = log2(rgb_max);
  float tonemap_peak_log = log2(tonemap_peak);

  float tonemapped_log = renodx::tonemap::ReinhardPiecewiseExtended(rgb_max_log, log2(white_clip), tonemap_peak_log, log2(rolloff_start));
  float tonemapped = exp2(tonemapped_log);

  float scale = renodx::math::DivideSafe(tonemapped, rgb_max, 1.f);
  return color * scale;
}

// float HDRBoost(float color, float power = 0.20f, float normalization_point = 0.02f) {
//   const float smoothing = abs(power) * 2.f;

//   float target = normalization_point * pow(color / normalization_point, 1.f + power);
//   float blended = lerp(color, target, renodx::tonemap::Reinhard(color, smoothing));
//   return (power >= 0.f) ? max(color, blended) : min(color, blended);
//   // float highlight_compression_scale = saturate(pow(saturate((color - highlight_compression_start) / (highlight_compression_peak - highlight_compression_start)), highlight_compression_curve));
//   // float smoothed = lerp(blended, color, highlight_compression_scale);
//   // return smoothed;
// }

// float3 HDRBoost(float3 color, float power = 0.20f, float normalization_point = 0.02f) {
//   return float3(
//       HDRBoost(color.r, power, normalization_point),
//       HDRBoost(color.g, power, normalization_point),
//       HDRBoost(color.b, power, normalization_point)
//   );
// }

// float3 ApplyHDRBoost(float3 color, float power = 0.20f, int mode = 0, float normalization_point = 0.02f) {
//   if (power == 0.f) return color;

//   color = max(0, renodx::color::bt2020::from::BT709(color));

//   if (mode == 0) {  // Per Channel
//     color = HDRBoost(color, power, normalization_point);
//   } 
//   else if (mode == 1) {  // By Luminance
//     float y_in = renodx::color::y::from::BT709(color);
//     float y_out = HDRBoost(y_in, power, normalization_point);
//     color = renodx::color::correct::Luminance(color, y_in, y_out);
//   }

//   color = renodx::color::bt709::from::BT2020(color);
//   return color;
// }

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
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
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
  //float y_highlighted = HDRBoost(y_contrasted, config.highlights - 1.f, mid_gray);
  //float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = renodx::color::grade::Shadows(y_highlighted, config.shadows, mid_gray);
  y_shadowed = max(0, y_shadowed);  // clamp to prevent artifacts

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHighlightSaturation(float3 tonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
      // perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(exp2(y) / (10000.f / 100.f), (1.f - config.dechroma))));
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

float3 PreTonemapSliders(float3 untonemapped, float mid_gray = 0.18f) {
  // if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped;

  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  float y = renodx::color::y::from::BT709(untonemapped);
  float3 outputColor = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config, mid_gray);
  return outputColor;
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

float3 DisplayMap(float3 color, float white_clip) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

  // if (CUSTOM_TONE_MAP_PARAMETERS == 0) {
  //   config.swap_chain_scaling_nits = renodx::color::correct::GammaSafe(config.swap_chain_scaling_nits);
  // }

  float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes peak
  float diffuse_white_nits = config.swap_chain_scaling_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes game brightness | swap chain scaling nits because of use in shared.h

  //peak_nits = renodx::color::correct::GammaSafe(peak_nits);
  //diffuse_white_nits = renodx::color::correct::GammaSafe(diffuse_white_nits);

  color = max(0, renodx::color::bt2020::from::BT709(color));
  float tonemap_peak = peak_nits / diffuse_white_nits;

  if (CUSTOM_TONE_MAP_PARAMETERS == 0) {
    tonemap_peak = renodx::color::correct::GammaSafe(tonemap_peak, true);
  }

  float3 outputColor = color;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    white_clip = max(100.f, white_clip);
    outputColor = renodx::tonemap::neutwo::MaxChannel(color, tonemap_peak, white_clip);
  }

  outputColor = renodx::color::bt709::from::BT2020(outputColor);

  if (CUSTOM_TONE_MAP_PARAMETERS == 0) {
    outputColor = renodx::color::correct::GammaSafe(outputColor);
  }

  return outputColor;
}

float3 SDRDisplayMap(float3 color, float white_clip) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

  float peak = 1.f;

  if (CUSTOM_TONE_MAP_PARAMETERS == 1) {
    peak = renodx::color::correct::GammaSafe(peak, false);
  }

  color = max(0, renodx::color::bt2020::from::BT709(color));

  float3 outputColor = color;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    white_clip = max(20.f, white_clip);
    outputColor = renodx::tonemap::neutwo::MaxChannel(color, peak, white_clip);
  }

  outputColor = renodx::color::bt709::from::BT2020(outputColor);
  return outputColor;
}