#include "./shared.h"

cbuffer CBToneMapping : register(b3)
{
  uint iToneMapType : packoffset(c0);
  bool bLuminanceVersion : packoffset(c0.y);
  float fShouldStr : packoffset(c0.z);
  float fLinearStr : packoffset(c0.w);
  float fIntermediate : packoffset(c1);
  float fS1 : packoffset(c1.y);
  float fS2 : packoffset(c1.z);
  float fS3 : packoffset(c1.w);
  float fS4 : packoffset(c2);
  uint iLUTSize : packoffset(c2.y);
  bool bIsLinearToPQ : packoffset(c2.z);
  bool bIsPQToLinear : packoffset(c2.w);
  bool bEnableColorGrading : packoffset(c3);
}

void GamutCompression(inout float3 color, inout float compression_scale) {
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color);
  float grayscale = renodx::color::y::from::BT709(gamma_color.rgb);
  compression_scale = renodx::color::correct::ComputeGamutCompressionScale(gamma_color.rgb, grayscale);
  gamma_color = renodx::color::correct::GamutCompress(gamma_color, grayscale, compression_scale);
  color = renodx::color::gamma::DecodeSafe(gamma_color);
  color = renodx::color::bt709::clamp::BT709(color);
}

void GamutDecompression(inout float3 color, float compression_scale) {
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color);
  gamma_color = renodx::color::correct::GamutDecompress(gamma_color, compression_scale);
  color = renodx::color::gamma::DecodeSafe(gamma_color);
}

float3 HDRBoost(float3 color, float power = 0.20f, float normalization_point = 0.02f) {
  if (power == 0.f) return color;
  // return lerp(color, normalization_point * renodx::math::SafePow(color / normalization_point, 1.f + power), color);

  //float compression_scale;
  //GamutCompression(color, compression_scale);

  float smoothing = power * 2.f;
  color = max(color, lerp(color, normalization_point * pow(color / normalization_point, 1.f + power), color / ((color / smoothing) + 1)));

  //GamutDecompression(color, compression_scale);
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

float3 ApplyPerChannelBlowoutHueShift(float3 untonemapped) {
  if (RENODX_TONE_MAP_PER_CHANNEL == 0 && CUSTOM_SCENE_GRADE_PER_CHANNEL_BLOWOUT > 0.f) {
    float calculated_peak = (0.01f * pow(100.f - CUSTOM_SCENE_GRADE_PER_CHANNEL_BLOWOUT, 2.f));

    float compression_scale;
    GamutCompression(untonemapped, compression_scale);

    float3 graded_color = renodx::tonemap::HermiteSplinePerChannelRolloff(untonemapped, calculated_peak, 100.f);
    float3 color = renodx::color::correct::Chrominance(untonemapped, graded_color, 1.f, 0.f, CUSTOM_SCENE_GRADE_METHOD);
    color = renodx::color::correct::Hue(color, graded_color, CUSTOM_SCENE_GRADE_HUE_SHIFT, CUSTOM_SCENE_GRADE_METHOD);

    GamutDecompression(color, compression_scale);
    return color;
  }
  return untonemapped;
}

float3 PreTonemapSliders(float3 untonemapped) {
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  untonemapped = ApplyPerChannelBlowoutHueShift(untonemapped);
  untonemapped = HDRBoost(untonemapped, CUSTOM_HDR_BOOST);

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

float3 Dice(float3 color, float rolloff_start = 0.5f, float output_max = 1.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color;
  }
  return renodx::tonemap::dice::BT709(color, output_max, rolloff_start);
}

float3 NeutralSDRYLerp(float3 color) {
  float color_y = renodx::color::y::from::BT709(color);
  color = lerp(color, renodx::tonemap::renodrt::NeutralSDR(color), saturate(color_y));
  return color;
}

float3 HDRDisplayMap(float3 color) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

  float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;              // Normalizes peak
  float diffuse_white_nits = config.diffuse_white_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes game brightness

  float peak_tonemap = peak_nits / diffuse_white_nits;

  color = renodx::color::bt709::clamp::AP1(color);

  float compression_scale;
  GamutCompression(color, compression_scale);

  // color = renodx::color::bt2020::from::BT709(color);

  float3 outputColor;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    if (RENODX_TONE_MAP_PER_CHANNEL == 0) {
      outputColor = renodx::tonemap::HermiteSplineLuminanceRolloff(color, peak_tonemap, RENODX_TONE_MAP_WHITE_CLIP);
    }
    else {
      outputColor = renodx::tonemap::HermiteSplinePerChannelRolloff(color, peak_tonemap, RENODX_TONE_MAP_WHITE_CLIP);
    }
    //outputColor = renodx::tonemap::ReinhardPiecewiseExtended(outputColor, RENODX_TONE_MAP_WHITE_CLIP, peak_tonemap, 0.5f);
  }

  GamutDecompression(outputColor, compression_scale);

  // outputColor = renodx::color::bt709::from::BT2020(color);

  return outputColor;
}

float3 CustomTonemap(float3 untonemapped, float2 coords) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return renodx::draw::RenderIntermediatePass(saturate(untonemapped));
  }
  
  untonemapped = PreTonemapSliders(untonemapped);
  float3 hdr_color = HDRDisplayMap(untonemapped);
  hdr_color = PostTonemapSliders(hdr_color);

  hdr_color = renodx::effects::ApplyFilmGrain(hdr_color, coords, CUSTOM_RANDOM, CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);

  return renodx::draw::RenderIntermediatePass(hdr_color);
}

float3 CustomGradingBegin(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0) return color;

  //color = Dice(color, 0.5f, 1.f);
  //color = renodx::tonemap::HermiteSplinePerChannelRolloff(color, 1.f, 100.f);
  color = ToneMapMaxCLL(color);

  return color;
}

float3 CustomGradingEnd(float3 ungraded_color, float3 sdr_color, float3 graded_color) {
  if (RENODX_TONE_MAP_TYPE == 0) return graded_color;
  return renodx::tonemap::UpgradeToneMap(ungraded_color, sdr_color, graded_color, CUSTOM_GRADING_STRENGTH);
}