#include "./shared.h"

float ReinhardPiecewiseExtended(float x, float white_max, float x_max = 1.f, float shoulder = 0.18f) {
  const float x_min = 0.f;
  float exposure = renodx::tonemap::ComputeReinhardExtendableScale(white_max, x_max, x_min, shoulder, shoulder);
  float extended = renodx::tonemap::ReinhardExtended(x * exposure, white_max * exposure, x_max);
  extended = min(extended, x_max);

  return lerp(x, extended, step(shoulder, x));
}

float3 ReinhardPiecewiseExtended(float3 x, float white_max, float x_max = 1.f, float shoulder = 0.18f) {
  const float x_min = 0.f;
  float exposure = renodx::tonemap::ComputeReinhardExtendableScale(white_max, x_max, x_min, shoulder, shoulder);
  float3 extended = renodx::tonemap::ReinhardExtended(x * exposure, white_max * exposure, x_max);
  extended = min(extended, x_max);

  return lerp(x, extended, step(shoulder, x));
}

float3 RestoreHueAndChrominance(float3 incorrect_color, float3 reference_color, float hue_strength = 0.5, float chrominance_strength = 1.0) {
  const float3 reference_oklab = renodx::color::oklab::from::BT709(reference_color);
  float3 incorrect_oklab = renodx::color::oklab::from::BT709(incorrect_color);

  float chrominance_current = length(incorrect_oklab.yz);
  float chrominance_ratio = 1.0;

  if (hue_strength != 0.0) {
    const float chrominance_pre = chrominance_current;
    incorrect_oklab.yz = lerp(incorrect_oklab.yz, reference_oklab.yz, hue_strength);
    const float chrominancePost = length(incorrect_oklab.yz);
    chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
    chrominance_current = chrominancePost;
  }

  if (chrominance_strength != 0.0) {
    const float reference_chrominance = length(reference_oklab.yz);
    float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
    chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_strength);
  }
  incorrect_oklab.yz *= chrominance_ratio;

  return renodx::color::bt709::from::OkLab(incorrect_oklab);
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = renodx::color::y::from::BT709(incorrect_color);
  const float y_out = max(0, renodx::color::correct::Gamma(y_in));

  float3 lum = renodx::color::correct::Luminance(incorrect_color, y_in, y_out);

  // use chrominance from per channel gamma correction
  float3 result = renodx::color::correct::ChrominanceOKLab(lum, ch, 1.f, 1.f);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

float3 GenerateOutput(inout float3 untonemapped_bt709, float game_min_nits, float game_max_nits, float game_shadows) {
  float3 tonemapped_bt709 = untonemapped_bt709;

  float diffuse_white = game_shadows * 200.f + 100.f;  // at 0.5 shadows, diffuse white is 200 nits
  float peak_nits = game_max_nits / diffuse_white;
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    const float ACES_MIN = 0.0001f;
    const float ACES_MID_GRAY = 0.10f;
    // const float mid_gray_scale = (0.18f / ACES_MID_GRAY);
    float aces_min = ACES_MIN / diffuse_white;
    float aces_max = peak_nits;
    // aces_max /= mid_gray_scale;
    // aces_min /= mid_gray_scale;
    if (RENODX_GAMMA_CORRECTION) {
      aces_max = renodx::color::correct::Gamma(aces_max, true);
      aces_min = renodx::color::correct::Gamma(aces_min, true);
    }

    renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);

    float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(renodx::color::ap1::from::BT709(untonemapped_bt709), ODT_config) / 48.f;
    // tonemapped_ap1 *= mid_gray_scale;
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);
  } else if (RENODX_TONE_MAP_TYPE == 3.f) {
    if (RENODX_GAMMA_CORRECTION) {
      peak_nits = renodx::color::correct::GammaSafe(peak_nits, true);
    }

    if (RENODX_TONE_MAP_PER_CHANNEL) {
      tonemapped_bt709 = ReinhardPiecewiseExtended(untonemapped_bt709, 100.f, peak_nits, 1.f);
      tonemapped_bt709 = renodx::color::correct::Hue(tonemapped_bt709, untonemapped_bt709, RENODX_TONE_MAP_HUE_CORRECTION);
      tonemapped_bt709 = RestoreHueAndChrominance(tonemapped_bt709, untonemapped_bt709, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_PER_CHANNEL_BLOWOUT_RESTORATION);
    } else {
      float y_in = renodx::color::y::from::BT709(untonemapped_bt709);
      float y_out = ReinhardPiecewiseExtended(y_in, 100.f, peak_nits, 1.f);
      tonemapped_bt709 = renodx::color::correct::Luminance(tonemapped_bt709, y_in, y_out);
    }
  }

  // if (RENODX_GAMMA_CORRECTION) {
  //   tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
  // }
  tonemapped_bt709 = ApplyGammaCorrection(tonemapped_bt709);

  return renodx::color::pq::EncodeSafe(tonemapped_bt709, diffuse_white);
}
