#include "./shared.h"

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
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

float3 LUTToneMap(float3 untonemapped) {
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

float3 ApplyExponentialRolloffMaxChannel(float3 untonemapped, float diffuse_nits, float peak_nits, float rolloff_start, float clip = 100.f) {
  float peak_ratio = peak_nits / diffuse_nits;

  float max_channel = renodx::math::Max(untonemapped);

  float mapped_max = exp2(renodx::tonemap::ExponentialRollOff(
      log2(max_channel),
      log2(rolloff_start),
      log2(peak_ratio),
      log2(clip)));

  float scale = renodx::math::DivideSafe(mapped_max, max_channel, 1.f);
  return untonemapped * scale;
}

float3 ApplyDisplayMap(float3 untonemapped, float diffuse_nits, float peak_nits) {
  const float peak_ratio = peak_nits / diffuse_nits;
  const float rolloff_start = 0.4f * peak_ratio;
  const float clip = 100.f;

  float3 tonemapped = untonemapped;
  if (RENODX_TONE_MAP_MAX_CHANNEL != 0.f) {
    if (RENODX_TONE_MAP_HUE_SHIFT > 0.f || RENODX_PER_CHANNEL_BLOWOUT_RESTORATION < 1.f) {
      float3 reference_color = renodx::tonemap::ReinhardPiecewise(untonemapped, 10.f, 1.f);
      untonemapped = renodx::color::bt2020::from::BT709(HueAndChrominance1ReferenceColorOKLab(
          renodx::color::bt709::from::BT2020(untonemapped),
          renodx::color::bt709::from::BT2020(reference_color),
          RENODX_TONE_MAP_HUE_SHIFT,
          (1.f - RENODX_PER_CHANNEL_BLOWOUT_RESTORATION)));
      untonemapped = max(0, untonemapped);
    }

    tonemapped = ApplyExponentialRolloffMaxChannel(untonemapped, diffuse_nits, peak_nits, rolloff_start);
  } else {
    float y_in = renodx::color::y::from::BT2020(untonemapped);
    float y_out = exp2(renodx::tonemap::ExponentialRollOff(
        log2(y_in), log2(rolloff_start), log2(peak_ratio), log2(clip)));
    float3 lum = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

    tonemapped = lum;
#if 1
    float3 ch = exp2(renodx::tonemap::ExponentialRollOff(
        log2(untonemapped), log2(rolloff_start), log2(peak_ratio), log2(clip)));
    tonemapped = renodx::color::correct::Luminance(lum, ch, 1.f);
    tonemapped = renodx::color::correct::Chrominance(tonemapped, min(lum, peak_ratio));
#endif
  }
  return tonemapped;
}
