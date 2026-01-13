#include "./shared.h"
//#include "./lilium_rcas.hlsl"

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.375f, float output_max = 1.f, float white_clip = 100.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return 1.f;
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
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

float tonemap_peakMinClipScaleDelay(
    float x,
    float clip,
    float peak,
    float minimum,
    float gray_in,
    float gray_out
) {
  float m = minimum;
  float q = peak - minimum;      // q = p - m
  float z = gray_out - minimum;  // z = y - m
  float g = gray_in;
  float c = clip;

  float c2 = c * c;
  float g2 = g * g;
  float p2 = peak * peak;
  float z2 = z * z;

  // numerator
  float num = q * z * sqrt(c2 - g2);

  // denominator polynomial coefficients
  float A = c2 * z2 - p2 * g2;
  float B = c2 * g2 * (p2 - z2);

  // rsqrt argument
  float denom2 = x * x * A + B;

  // inverse sqrt (no safety clamp)
  float invDenom = rsqrt(denom2);

  return num * x * invDenom + m;
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
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

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

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 ApplyPerChannelBlowoutHueShift(float3 untonemapped, float mid_gray = 0.18f, float max_value = 1.f) {
  if (SCENE_GRADE_PER_CHANNEL_BLOWOUT > 0.f) {
    float calculated_peak = SCENE_GRADE_PER_CHANNEL_BLOWOUT + (max_value - 1.f);
    calculated_peak = max(calculated_peak, 1.f);

    untonemapped = max(0, renodx::color::bt2020::from::BT709(untonemapped));

    float3 graded_color = renodx::tonemap::ReinhardPiecewise(untonemapped, calculated_peak, mid_gray);
    float3 color = renodx::color::correct::Chrominance(untonemapped, graded_color, 1.f, 0.f, 1);
    color = renodx::color::correct::Hue(color, graded_color, SCENE_GRADE_PER_CHANNEL_HUE_SHIFT, 1);

    color = renodx::color::bt709::from::BT2020(color);
    return color;
  }
  return untonemapped;
}


float3 PreTonemapSliders(float3 untonemapped) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped;
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  float y = renodx::color::y::from::BT709(untonemapped);
  float3 outputColor = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config);
  outputColor = HDRBoost(outputColor, CUSTOM_HDR_BOOST, 1);
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

float3 HDRDisplayMap(float3 color) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

   float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;              // Normalizes peak
   float diffuse_white_nits = config.diffuse_white_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes game brightness

   color = max(0, renodx::color::bt2020::from::BT709(color));
   float tonemap_peak = peak_nits / diffuse_white_nits;

   float3 outputColor = color;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
      float rgb_max = renodx::math::Max(color);
      float rgb_max_log = log2(rgb_max);
      float tonemap_peak_log = log2(tonemap_peak);

      float tonemapped_log = renodx::tonemap::HermiteSplineRolloff(rgb_max_log, tonemap_peak_log, log2(100.f));
      float tonemapped = exp2(tonemapped_log);

      float scale = renodx::math::DivideSafe(tonemapped, rgb_max, 1.f);
      outputColor = color * scale;
  }

  outputColor = renodx::color::bt709::from::BT2020(outputColor);

  return outputColor;
}

// float3 ApplyRenoDXPostProcessing(float3 color, float2 TEXCOORD, Texture2D t0, SamplerState s0) {
//   float3 outputColor = color;
//   outputColor = ApplyRCAS(outputColor, TEXCOORD, t0, s0);
//   outputColor = renodx::effects::ApplyFilmGrain(
//       outputColor,
//       float2(TEXCOORD.x, TEXCOORD.y),
//       CUSTOM_RANDOM,
//       CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
//   return outputColor;
// }

float3 CustomDisplayMap(float3 color, float2 TEXCOORD, Texture2D t0, SamplerState s0) {
  float3 outputColor = renodx::color::gamma::DecodeSafe(color);
  if (RENODX_TONE_MAP_TYPE == 0.f) return renodx::draw::RenderIntermediatePass(saturate(outputColor));
  outputColor = ApplyPerChannelBlowoutHueShift(outputColor);
  outputColor = HDRDisplayMap(outputColor);
  outputColor = PostTonemapSliders(outputColor);
  //outputColor = ApplyRenoDXPostProcessing(outputColor, TEXCOORD, t0, s0);
  return renodx::draw::RenderIntermediatePass(outputColor);
}