#include "./shared.h"

float3 BT709FromHueMethod(float3 color) {
  if (CUSTOM_SCENE_HUE_METHOD == 0) {  // OKLab
    color = renodx::color::bt709::from::OkLab(color);
  } else if (CUSTOM_SCENE_HUE_METHOD == 1) {  // ICtCp
    color = renodx::color::bt709::from::ICtCp(color);
  } else if (CUSTOM_SCENE_HUE_METHOD == 2) {  // OKLCH
    color = renodx::color::bt709::from::OkLCh(color);
  }
  return color;
}

float3 HueMethodFromBT709(float3 color) {
  if (CUSTOM_SCENE_HUE_METHOD == 0) {  // OKLab
    color = renodx::color::oklab::from::BT709(color);
  } else if (CUSTOM_SCENE_HUE_METHOD == 1) {  // ICtCp
    color = renodx::color::ictcp::from::BT709(color);
  } else if (CUSTOM_SCENE_HUE_METHOD == 2) {  // OKLCH
    color = renodx::color::oklch::from::BT709(color);
  }
  return color;
}

void GamutCompression(inout float3 color, inout float compression_scale) {
  color = renodx::color::bt709::clamp::AP1(color);
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color);
  float grayscale = renodx::color::y::from::BT709(gamma_color.rgb);
  compression_scale = renodx::color::correct::ComputeGamutCompressionScale(gamma_color.rgb, grayscale);
  gamma_color = renodx::color::correct::GamutCompress(gamma_color, grayscale, compression_scale);
  color = renodx::color::gamma::DecodeSafe(gamma_color);
  color = renodx::color::bt709::clamp::BT709(color);
}

void GamutDecompression(inout float3 color, float compression_scale) {
  color = renodx::color::bt709::clamp::BT709(color);
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color);
  gamma_color = renodx::color::correct::GamutDecompress(gamma_color, compression_scale);
  color = renodx::color::gamma::DecodeSafe(gamma_color);
}

float3 HDRBoost(float3 color, float power = 0.20f, int mode = 0, float normalization_point = 0.02f) {
  if (power == 0.f) return color;
  // return lerp(color, normalization_point * renodx::math::SafePow(color / normalization_point, 1.f + power), color);

  //float compression_scale;
  //GamutCompression(color, compression_scale);

  color = max(0, renodx::color::bt2020::from::BT709(color));

  float smoothing = power * 2.f;

  if (mode == 0) {  // Per Channel
    color = max(color, lerp(color, normalization_point * pow(color / normalization_point, 1.f + power), color / ((color / smoothing) + 1)));
  } 
  else if (mode == 1) {  // By Luminance
    float y_in = renodx::color::y::from::BT709(color);
    float y_out = max(y_in, lerp(y_in, normalization_point * pow(y_in / normalization_point, 1.f + power), y_in / ((y_in / smoothing) + 1)));
    color = renodx::color::correct::Luminance(color, y_in, y_out);
  }

  //GamutDecompression(color, compression_scale);
  color = renodx::color::bt709::from::BT2020(color);
  return color;
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
  y_shadowed = max(0, y_shadowed); //clamp to prevent artifacts

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHighlightSaturation(float3 tonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = HueMethodFromBT709(color);

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
      //perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(exp2(y) / (10000.f / 100.f), (1.f - config.dechroma))));
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

    color = BT709FromHueMethod(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 ApplyPerChannelBlowoutHueShift(float3 untonemapped, float mid_gray = 0.18f, float max_value = 1.f) {
  if (LAST_IS_HDR && RENODX_TONE_MAP_PER_CHANNEL == 0 && CUSTOM_SCENE_GRADE_PER_CHANNEL_BLOWOUT > 0.f) {
    float calculated_peak = (0.01f * pow(100.f - CUSTOM_SCENE_GRADE_PER_CHANNEL_BLOWOUT, 2.f)) + (max_value - 1.f);
    calculated_peak = max(calculated_peak, 1.f);

    //float compression_scale;
    //GamutCompression(untonemapped, compression_scale);
    untonemapped = max(0, renodx::color::bt2020::from::BT709(untonemapped));

    // float3 graded_color = renodx::tonemap::HermiteSplinePerChannelRolloff(untonemapped, calculated_peak, 100.f);
    // float3 graded_color = renodx::tonemap::ReinhardPiecewise(untonemapped, calculated_peak, 0.5f + ((mid_gray / 0.18f) - 1.f));
    float3 graded_color = renodx::tonemap::ReinhardPiecewise(untonemapped, calculated_peak, mid_gray);
    //float3 graded_color = renodx::tonemap::ReinhardScalableExtended(untonemapped, 11.2f, calculated_peak, 0.f, mid_gray, mid_gray);
    // float3 graded_color = renodx::tonemap::dice::BT709(untonemapped, calculated_peak);
    //float3 graded_color = renodx::tonemap::HermiteSplinePerChannelRolloff(untonemapped, calculated_peak, 11.2f);
    float3 color = renodx::color::correct::Chrominance(untonemapped, graded_color, 1.f, 0.f, CUSTOM_SCENE_HUE_METHOD);
    color = renodx::color::correct::Hue(color, graded_color, CUSTOM_SCENE_GRADE_HUE_SHIFT, CUSTOM_SCENE_HUE_METHOD);

    //GamutDecompression(color, compression_scale);
    color = renodx::color::bt709::from::BT2020(color);
    return color;
  }
  return untonemapped;
}

// float3 ColorPicker(float3 color, float3 sdr_color) {
//   if (RENODX_TONE_MAP_TYPE < 2.f) {
//     return sdr_color;
//   }
//   return color;
// }

// float GetPostProcessingMaxCLL() {
//   return CUSTOM_POST_MAXCLL;
// }

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

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

float3 NeutralSDRYLerp(float3 color) {
  float color_y = renodx::color::y::from::BT709(color);
  color = lerp(color, renodx::tonemap::renodrt::NeutralSDR(color), saturate(color_y));
  return color;
}

float3 PreTonemapSliders(float3 untonemapped) {
  if (RENODX_TONE_MAP_TYPE == 1.f) return untonemapped;
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  float y = renodx::color::y::from::BT709(untonemapped);
  float3 outputColor = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config);
  outputColor = HDRBoost(outputColor, CUSTOM_INVERSE_TONEMAP, 1, 0.04f);
  //if (RENODX_TONE_MAP_TYPE < 2.f) return outputColor;
  //outputColor = ApplyPerChannelBlowoutHueShift(outputColor);
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

// Smoothly clamp x to 1.0

float ColorGradeSmoothClamp(float x)
{
  const float u = 0.525;

  float q = (2.0 - u - 1.0 / u + x * (2.0 + 2.0 / u - x / u)) / 4.0;

  return (abs(1.0 - x) < u) ? q : saturate(x);
}

// Approximate SDR color grading with an HDR image

float4 ColorGradingSDR(float3 rgbHdr)
{
  if (RENODX_TONE_MAP_TYPE < 2) return float4(rgbHdr, 0.f);
  // Find the maximum component

  // float gMax = max3(rgbHdr);
  float gMax = max(rgbHdr.x, max(rgbHdr.y, rgbHdr.z));
  gMax = max(gMax, 1e-6);

  // Clamp HDR to 0-1 range, and calculate scale for re-expansion

  float gClamped = ColorGradeSmoothClamp(gMax);
  float rScale = gClamped / gMax;

  // Perform standard SDR color grading

  return float4(rgbHdr * rScale, rScale);
}

float3 ColorGradeHDR(float4 rgbGraded) {
  if (RENODX_TONE_MAP_TYPE < 2) return rgbGraded.rgb;
  return rgbGraded.rgb / rgbGraded.w;
}

float3 CustomGradingSDR(float3 ungraded) {
  if (RENODX_TONE_MAP_TYPE < 2.f) {
    return ungraded;
  }
  // return NeutralSDRYLerp(ungraded);
  return ToneMapMaxCLL(ungraded);
  // return renodx::tonemap::ReinhardPiecewise(ungraded);
}

float3 CustomUpgradeGrading(float3 ungraded, float3 ungraded_sdr, float3 graded) {
  if (RENODX_TONE_MAP_TYPE < 2.f) {
    return lerp(ungraded, graded, CUSTOM_LUT_STRENGTH);
  }
  // float3 neutral_sdr = ToneMapMaxCLL(ungraded);
  return renodx::tonemap::UpgradeToneMap(ungraded, ungraded_sdr, graded, CUSTOM_LUT_STRENGTH);
}

float3 applyDice(float3 color, float paperWhite = RENODX_DIFFUSE_WHITE_NITS, float peakWhite = RENODX_PEAK_WHITE_NITS) {
  paperWhite = paperWhite / renodx::color::srgb::REFERENCE_WHITE;
  peakWhite = peakWhite / renodx::color::srgb::REFERENCE_WHITE;
  const float highlightsShoulderStart = paperWhite;
  return renodx::tonemap::dice::BT709(color * paperWhite, peakWhite, highlightsShoulderStart) / paperWhite;
}

renodx::draw::Config SdrConfig() {
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.peak_white_nits = renodx::color::srgb::REFERENCE_WHITE;
  config.diffuse_white_nits = renodx::color::srgb::REFERENCE_WHITE;
  config.graphics_white_nits = renodx::color::srgb::REFERENCE_WHITE;
  //config.reno_drt_white_clip = 1.f;
  return config;
}

float3 HDRDisplayMap(float3 color, float tonemapper) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

   float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;              // Normalizes peak
   float diffuse_white_nits = config.diffuse_white_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes game brightness
  //float peak_nits = config.peak_white_nits / 80.f;
  //float diffuse_white_nits = config.diffuse_white_nits / 80.f;

  //float compression_scale;
  //GamutCompression(color, compression_scale);

   
   color = max(0, renodx::color::bt2020::from::BT709(color));
   float tonemap_peak = peak_nits / diffuse_white_nits;

   float3 outputColor = color;
  if (tonemapper == 2.f) {
    if (RENODX_TONE_MAP_PER_CHANNEL == 0) {
      // outputColor = renodx::tonemap::HermiteSplineLuminanceRolloff(color, tonemap_peak, 100.f);
      // outputColor = renodx::color::correct::Chrominance(outputColor, min(outputColor, tonemap_peak), 1.f, 0.f, 1);

      float rgb_max = renodx::math::Max(color);
      float rgb_max_log = log2(rgb_max);
      float tonemap_peak_log = log2(tonemap_peak);

      float tonemapped_log = renodx::tonemap::HermiteSplineRolloff(rgb_max_log, tonemap_peak_log, log2(100.f));
      float tonemapped = exp2(tonemapped_log);

      float scale = renodx::math::DivideSafe(tonemapped, rgb_max, 1.f);
      outputColor = color * scale;
    }
    else {
      outputColor = renodx::tonemap::HermiteSplinePerChannelRolloff(color, tonemap_peak, 100.f);
    }
  }

  //GamutDecompression(outputColor, compression_scale);

  outputColor = renodx::color::bt709::from::BT2020(outputColor);

  return outputColor;
}

float3 SDRDisplayMap(float3 color, float tonemapper) {
  // float compression_scale;
  // GamutCompression(color, compression_scale);
  color = renodx::color::bt709::clamp::BT709(color);

  float3 outputColor = color;
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    // if (RENODX_TONE_MAP_PER_CHANNEL == 0) {
    //   // outputColor = renodx::tonemap::HermiteSplineLuminanceRolloff(color, tonemap_peak, 100.f);

    //   float rgb_max = renodx::math::Max(color);
    //   // rgb_max = lerp(rgb_max, renodx::color::y::from::BT709(color), 0.f); // adjust hue clip
    //   // rgb_max = min(rgb_max, 100.f);
    //   float rgb_max_log = log2(rgb_max);
    //   float tonemap_peak_log = log2(1.f);

    //   float tonemapped_log = renodx::tonemap::HermiteSplineRolloff(rgb_max_log, tonemap_peak_log, log2(20.f));
    //   // float scale = max(0, exp2(tonemapped_log - rgb_max_log));
    //   // outputColor = color * scale;
    //   outputColor = renodx::color::correct::Luminance(color, rgb_max, exp2(tonemapped_log));
    // }
    //else {
      outputColor = renodx::tonemap::HermiteSplinePerChannelRolloff(color, 1.f, 20.f);
    //}
  }
  //GamutDecompression(outputColor, compression_scale);
  return outputColor;
}

float3 CustomTonemap(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 1.f) {
      return saturate(color);
  }
  float3 outputColor = color;
  outputColor = renodx::color::bt709::clamp::BT2020(color);
  outputColor = PreTonemapSliders(outputColor);

  // Find new white clip from peak after slider code and tonemap back down to 10k
  float white_clip = 100.f;
  white_clip = PreTonemapSliders(white_clip).x;
  if (white_clip > 100.f) outputColor = ReinhardPiecewiseExtendedMaxCLL(outputColor, 4.f, 100.f, white_clip);

  if (LAST_IS_HDR) {
    outputColor = HDRDisplayMap(outputColor, RENODX_TONE_MAP_TYPE);
  }
  else {
    outputColor = SDRDisplayMap(outputColor, RENODX_TONE_MAP_TYPE);
  }
  outputColor = PostTonemapSliders(outputColor);
  return outputColor;
}

float GetSunshaftScale() {
  return 1.f;
  //return CUSTOM_SUNSHAFTS_STRENGTH;
}

float GetBloomScale() {
  return CUSTOM_BLOOM;
}

float3 CustomBloomTonemap(float3 color, float exposure = 0.2f) {
  if (RENODX_TONE_MAP_TYPE < 2.f) {
    return color;
  }
  return min(color, CUSTOM_BLOOM);
}

float3 CustomSunshaftsTonemap(float3 color) {
  if (RENODX_TONE_MAP_TYPE < 2.f) {
    return color;
  }
  return min(color, CUSTOM_SUNSHAFTS_STRENGTH);
}

float hdrSaturate(float color) {
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    return saturate(color);
  }
  color = max(color, 0.f);
  // color = min(color, 100.f);
  return color;
}

float4 ClampPostProcessing(float4 value, float clamp_value) {
  float y_in = renodx::color::y::from::BT709(value.rgb);
  float y_out = renodx::tonemap::ReinhardPiecewise(y_in, clamp_value, 0.18f);
  value.rgb = renodx::color::correct::Luminance(value.rgb, y_in, y_out);
  return value;
}

float4 HandleUICompositing(float4 ui_color_linear, float4 scene_color_linear) {
  float3 ui_color;
  ui_color.rgb = renodx::color::srgb::EncodeSafe(ui_color_linear.rgb);

  float3 scene_color_srgb = renodx::color::srgb::EncodeSafe(scene_color_linear.rgb);

  // Blend in SRGB based on opacity
  float3 composited_color = lerp(scene_color_srgb, ui_color.rgb, saturate(ui_color_linear.a));
  float3 linear_color = renodx::color::srgb::DecodeSafe(composited_color);

  float4 output_color;
  output_color.rgb = linear_color;
  output_color.a = ui_color_linear.a;

  return output_color;
}

float4 HandleUICompositingHDR(float4 ui_color_linear, float4 scene_color_linear) {
  return HandleUICompositing(ui_color_linear * (RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS), scene_color_linear);
}

float CustomGammaEncode(float color) {
  if (CUSTOM_GAMUT_UNCLAMP == 1 && LAST_IS_HDR) {
     return renodx::color::gamma::EncodeSafe(color);
  }
  color = max(0, color);
  return renodx::color::gamma::Encode(color);
}

float3 CustomGammaEncode(float3 color) {
  color.r = CustomGammaEncode(color.r);
  color.g = CustomGammaEncode(color.g);
  color.b = CustomGammaEncode(color.b);
  return color;
}

float CustomGammaDecode(float color) {
  if (CUSTOM_GAMUT_UNCLAMP == 1 && LAST_IS_HDR) {
     return renodx::color::gamma::DecodeSafe(color);
  }
  color = max(0, color);
  return renodx::color::gamma::Decode(color);
}

float3 CustomGammaDecode(float3 color) {
  color.r = CustomGammaDecode(color.r);
  color.g = CustomGammaDecode(color.g);
  color.b = CustomGammaDecode(color.b);
  return color;
}

float3 CustomColorGrading(float3 ungraded, float3 graded) {
  if (RENODX_TONE_MAP_TYPE == 1.f) return graded;
  // graded = renodx::color::correct::Hue(graded, ungraded);
  return lerp(ungraded, graded, CUSTOM_COLOR_GRADING);
}