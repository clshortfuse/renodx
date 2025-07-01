#include "./shared.h"

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

float3 CustomTonemap(float3 untonemapped, float3 tonemapped_bt709) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return tonemapped_bt709;
  }
  float3 outputColor = renodx::draw::ToneMapPass(untonemapped);
  return outputColor;
}

float3 CustomTonemapSDR(float3 untonemapped) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return saturate(untonemapped);
  }
  //untonemapped = renodx::color::srgb::DecodeSafe(untonemapped);
  float3 outputColor = ToneMapMaxCLL(untonemapped);

  return outputColor;
  //return renodx::color::srgb::EncodeSafe(outputColor);
}

float3 CustomUncharted2(float3 untonemapped) {
  float3 outputColor = renodx::tonemap::uncharted2::BT709(untonemapped, 1); //thanks voosh
  return outputColor;
}

float3 CustomUpgradeTonemap(float3 untonemapped, float3 tonemapped_bt709, float scaling = 1.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return tonemapped_bt709;
  }
  //untonemapped = renodx::color::srgb::DecodeSafe(untonemapped);
  //tonemapped_bt709 = renodx::color::srgb::DecodeSafe(tonemapped_bt709);
  tonemapped_bt709 = renodx::draw::ApplyPerChannelCorrection(
      untonemapped,
      tonemapped_bt709,
      CUSTOM_SCENE_GRADE_BLOWOUT_RESTORATION,
      CUSTOM_SCENE_GRADE_HUE_CORRECTION,
      CUSTOM_SCENE_GRADE_SATURATION_CORRECTION,
      CUSTOM_SCENE_GRADE_HUE_SHIFT);
  float3 outputColor;
  float3 sdr_color = ToneMapMaxCLL(untonemapped);
  outputColor = renodx::tonemap::UpgradeToneMap(untonemapped, sdr_color, tonemapped_bt709, scaling);

  return outputColor;
  //return renodx::color::srgb::EncodeSafe(outputColor);
}

float3 CustomUpgradeGrading(float3 ungraded, float3 ungraded_sdr, float3 graded, float scaling = 1.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return graded;
  }
  // ungraded = renodx::color::srgb::DecodeSafe(ungraded);
  // ungraded_sdr = renodx::color::srgb::DecodeSafe(ungraded_sdr);
  // graded = renodx::color::srgb::DecodeSafe(graded);
  float3 outputColor = renodx::tonemap::UpgradeToneMap(ungraded, ungraded_sdr, graded, scaling);

  return outputColor;
  //return renodx::color::srgb::EncodeSafe(outputColor);
}

float3 CustomPostProcessing(float3 color, float2 coords) {
  float3 outputColor = renodx::color::srgb::DecodeSafe(color);
  outputColor = renodx::effects::ApplyFilmGrain(outputColor, coords, CUSTOM_RANDOM, CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);

  return renodx::color::srgb::EncodeSafe(outputColor);
}

float3 CustomIntermediatePass(float3 color) {
  return renodx::draw::RenderIntermediatePass(color);
  return color;
}

float3 CustomSwapChainPass(float3 color) {
  float3 linear_color = renodx::color::srgb::DecodeSafe(color);
  linear_color = renodx::color::correct::GammaSafe(linear_color, false, 2.2f);
  linear_color = renodx::color::bt709::clamp::BT2020(linear_color);
  return color;
  return linear_color;
}