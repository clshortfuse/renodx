#include "./shared.h"

// CorrectPerChannelTonemapHighlightsMax Helpers
#define FLT_EPSILON 1.192092896e-07  // Smallest positive number, such that 1.0 + FLT_EPSILON != 1.0

float max3(float3 v) {
  return max(v.x, max(v.y, v.z));
}
float min3(float3 v) {
  return min(v.x, min(v.y, v.z));
}
float GetMidValue(float3 v) {
  return 0.5f * (max3(v) + min3(v));
}

float InverseLerp(float a, float b, float value) {
  return (a == b) ? 0.0f : ((value - a) / (b - a));
}

float3 SetChrominance(float3 color, float chrominance) {
  float maxVal = max3(color);
  float minVal = min3(color);
  float midVal = lerp(minVal, maxVal, 0.5f);
  return lerp(float3(midVal, midVal, midVal), color, chrominance);
}

float GetChrominance(float3 color) {
  // same as original: distance from mid toward extremes
  return max3(abs(color - GetMidValue(color)));
}

float3 RestoreLuminance(float3 targetColor, float sourceLuminance) {
  float targetLuminance = renodx::color::y::from::BT709(targetColor);
  targetLuminance = max(targetLuminance, 0.0f);
  sourceLuminance = max(sourceLuminance, 0.0f);
  return (targetLuminance <= (FLT_EPSILON * 10.0f))
             ? float3(0.0f, 0.0f, 0.0f)
             : targetColor * (sourceLuminance / targetLuminance);
}

// Emulates the highlights desaturation from a per channel tonemapper (a generic one, the math here isn't specific), up to a certain peak brightness (it doesn't need to match your display, it can be picked for consistent results independently of the user calibration).
// This doesn't perfectly match the hue shifts from games that purely lacked tonemapping and simply clipped to 0-1, but it might help with them too.
// This can also be used to increase highlights saturation ("desaturationExponent" < 1), in a way that would have matched a per channel tonemaper desaturation, in an "AutoHDR" inverse tonemapping fashion.
// Note: the result of this depends on the color space, and that is intentional as it wants to keep within the target gamut.
float3 CorrectPerChannelTonemapHighlightsMax(float3 color,
                                             float peakBrightness,
                                             float desaturationExponent = 2.0f) {
  float sourceChrominance = GetChrominance(color);

  float maxBrightness = max3(color);
  float midBrightness = GetMidValue(color);
  float minBrightness = min3(color);
  float brightnessRatio = saturate(maxBrightness / peakBrightness);
  brightnessRatio = lerp(brightnessRatio,
                         sqrt(brightnessRatio),
                         sqrt(InverseLerp(minBrightness, maxBrightness, midBrightness)));

  float chrominancePow = lerp(1.0f, 1.0f / desaturationExponent, brightnessRatio);
  float targetChrominance = (sourceChrominance > 1.0f)
                                ? pow(sourceChrominance, chrominancePow)
                                : (1.0f - pow(1.0f - sourceChrominance, chrominancePow));
  float chrominanceRatio = renodx::math::DivideSafe(targetChrominance, sourceChrominance, 1.0f);

  float3 adjusted = SetChrominance(color, chrominanceRatio);
  return RestoreLuminance(adjusted, renodx::color::y::from::BT709(color));
}
// end CorrectPerChannelTonemapHighlightsMax

float GetToneMapToe(float toe) {
  return 1.f;
}

float GetToneMapMaxNitAndLinearStart() {
  float peak = 10000.f / 100.f;  // tonemap to 4000 first, displaymap later

  if (GAMMA_CORRECTION != 0.f) {
    peak = renodx::color::correct::Gamma(peak, true);
  }

  return peak;
}

float3 HueAndChrominance1ReferenceColorOKLab(
    float3 incorrect_color, float3 hue_reference_color,
    float hue_correct_strength = 0.f,
    float chrominance_correct_strength = 0.f) {
  if (hue_correct_strength != 0.0 || chrominance_correct_strength != 0.0) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(incorrect_color);
    const float3 reference_oklab = renodx::color::oklab::from::BT709(hue_reference_color);

    float chrominance_current = length(perceptual_new.yz);
    float chrominance_ratio = 1.0;

    if (hue_correct_strength != 0.0) {
      const float chrominance_pre = chrominance_current;
      perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, hue_correct_strength);
      const float chrominancePost = length(perceptual_new.yz);
      chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
      chrominance_current = chrominancePost;
    }

    if (chrominance_correct_strength != 0.0) {
      const float reference_chrominance = length(reference_oklab.yz);
      float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
      chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_correct_strength);
    }
    perceptual_new.yz *= chrominance_ratio;

    incorrect_color = renodx::color::bt709::from::OkLab(perceptual_new);
    incorrect_color = renodx::color::bt709::clamp::AP1(incorrect_color);
  }
  return incorrect_color;
}

float3 ApplyPreDisplayMap(float3 untonemapped) {
  return untonemapped;
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.5f, float output_max = 1.f, float channel_max = 100.f) {
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, channel_max, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 0.f);

  return scale;
}

float3 LUTToneMap(float3 untonemapped) {
  if (RENODX_TONE_MAP_MAX_CHANNEL != 0.f) {
    float reference_peak = 8.f;
    float reference_shoulder = 0.5f;
    float3 reference_color = renodx::tonemap::ExponentialRollOff(untonemapped, reference_shoulder, reference_peak);
    untonemapped = HueAndChrominance1ReferenceColorOKLab(
        untonemapped, reference_color, RENODX_TONE_MAP_HUE_SHIFT, (1.f - RENODX_PER_CHANNEL_BLOWOUT_RESTORATION));
    untonemapped = max(0, untonemapped);
  }

  return untonemapped * ComputeReinhardSmoothClampScale(untonemapped);
}

float3 GammaCorrectByLuminance(float3 color, bool pow_to_srgb = false) {
  float y_in = renodx::color::y::from::BT709(color);
  float y_out = renodx::color::correct::Gamma(y_in, pow_to_srgb);

  color = renodx::color::correct::Luminance(color, y_in, y_out);

  return color;
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
  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutBlack = renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture);
    float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(0.18f, lut_config), lut_config, lut_texture);

    if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
      lutOutputColor = GammaCorrectByLuminance(lutOutputColor);
      lutBlack = GammaCorrectByLuminance(lutBlack);
      lutMid = GammaCorrectByLuminance(lutMid);
    }

    float3 unclamped_gamma = Unclamp(
        renodx::lut::GammaOutput(lutOutputColor, lut_config),
        renodx::lut::GammaOutput(lutBlack, lut_config),
        renodx::lut::GammaOutput(lutMid, lut_config),
        renodx::lut::GammaInput(color_input, lutInputColor, lut_config));

    float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

    if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
      unclamped_linear = GammaCorrectByLuminance(unclamped_linear, true);
    }

    float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
    color_output = recolored;
  } else {
  }

  return lerp(color_input, color_output, lut_config.strength);
}

float3 ApplyGammaCorrection(float3 color_input) {
  float3 color_corrected = color_input;

  if (GAMMA_CORRECTION != 0.f) {
    color_corrected = renodx::color::correct::GammaSafe(color_input);

    if (GAMMA_CORRECTION == 2.f && GAMMA_CORRECTION_HUE_CORRECTION > 0.f) {
      color_corrected = renodx::color::correct::Hue(color_corrected, color_input, GAMMA_CORRECTION_HUE_CORRECTION, 1);
    }
  }
  return color_corrected;
}

/// Piecewise linear + exponential compression to a target value starting from a specified number.
/// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite
#define EXPONENTIALROLLOFF_GENERATOR(T)                                                      \
  T ExponentialRollOffExtended(T input, float rolloff_start, float output_max, float clip) { \
    T rolloff_size = output_max - rolloff_start;                                             \
    T overage = -max((T)0, input - rolloff_start);                                           \
    T clip_size = rolloff_start - clip;                                                      \
    T rolloff_value = (T)1.0f - exp(overage / rolloff_size);                                 \
    T clip_value = (T)1.0f - exp(clip_size / rolloff_size);                                  \
    T new_overage = mad(rolloff_size, rolloff_value / clip_value, overage);                  \
    return input + new_overage;                                                              \
  }
EXPONENTIALROLLOFF_GENERATOR(float)
EXPONENTIALROLLOFF_GENERATOR(float3)
#undef EXPONENTIALROLLOFF_GENERATOR

float3 GamutCompressToBT2020BT2020InBT2020Out(float3 color_bt2020) {
  // compress to BT.2020 in gamma space
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color_bt2020);
  float grayscale = renodx::color::y::from::BT2020(gamma_color.rgb);
  float compression_scale = renodx::color::correct::ComputeGamutCompressionScale(gamma_color.rgb, grayscale);
  gamma_color = renodx::color::correct::GamutCompress(gamma_color, grayscale, compression_scale);

  // back to BT.709 linear
  color_bt2020 = renodx::color::gamma::DecodeSafe(gamma_color);

  return color_bt2020;
}

float3 ApplyExponentialRolloffMaxChannel(float3 untonemapped, float diffuse_nits, float peak_nits, float rolloff_start, float clip = 100.f) {
  float peak_ratio = peak_nits / diffuse_nits;

  float max_channel = renodx::math::Max(untonemapped);

  float mapped_max = exp2(ExponentialRollOffExtended(
      log2(max_channel),
      log2(rolloff_start),
      log2(peak_ratio),
      log2(clip)));

  float scale = renodx::math::DivideSafe(mapped_max, max_channel, 0.f);
  return untonemapped * scale;
}

float3 ApplyDisplayMap(float3 untonemapped, float diffuse_nits, float peak_nits) {
  untonemapped = GamutCompressToBT2020BT2020InBT2020Out(untonemapped);

  const float peak_ratio = peak_nits / diffuse_nits;
  const float rolloff_start = 0.4f * peak_ratio;
  const float clip = 100.f;

  float3 tonemapped = untonemapped;
  if (RENODX_TONE_MAP_MAX_CHANNEL != 0.f) {
    tonemapped = ApplyExponentialRolloffMaxChannel(untonemapped, diffuse_nits, peak_nits, rolloff_start);
  } else {
    float y_in = renodx::color::y::from::BT2020(untonemapped);
    float y_out = exp2(ExponentialRollOffExtended(
        log2(y_in),
        log2(rolloff_start),
        log2(peak_ratio),
        log2(clip)));
    float3 lum = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

    tonemapped = lum;
#if 1
    float3 ch = exp2(ExponentialRollOffExtended(
        log2(untonemapped),
        log2(rolloff_start),
        log2(peak_ratio),
        log2(clip)));
    tonemapped = renodx::color::correct::Luminance(lum, ch, 1.f);
    tonemapped = renodx::color::correct::Chrominance(tonemapped, min(lum, peak_ratio));
#endif
  }
  return tonemapped;
}
