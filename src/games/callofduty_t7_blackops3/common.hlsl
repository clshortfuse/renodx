#include "./shared.h"

#define SDR_NOMRALIZATION_MAX 32768.0
// #define SDR_NOMRALIZATION_TRADEOFF 0.15 //TODO to reshade var instead?

/*
* in: linear
* out: srgb/gamma accounting for SDR_NOMRALIZATION_MAX
* 
* this is goofy. we have to make a tradeoff for max luminance to render fullscreen shaders.
* TODO extend LUT past 32768 instead?
*/
float3 AfterTonemapToFullscreenShadersTradeoff(float3 color) {
  if (CUSTOM_FULLSCREEN_SHADER_GAMMA == 0.f) {
    color.rgb = renodx::color::srgb::EncodeSafe(color.rgb);
  } else if (CUSTOM_FULLSCREEN_SHADER_GAMMA == 1.f) {
    color.rgb = renodx::color::gamma::EncodeSafe(color.rgb, 2.2);
  } else {
    color.rgb = renodx::color::gamma::EncodeSafe(color.rgb, 2.4);
  }

  color *= (SDR_NOMRALIZATION_MAX * CUSTOM_TRADEOFF_RATIO);

  return color;
}

/*
* in: srgb/gamma
* out: linear accounting for SDR_NOMRALIZATION_MAX
*/
float3 AfterFullscreenShaderBeforeUiTradeoff(float3 color) {
  color.rgb /= (SDR_NOMRALIZATION_MAX * CUSTOM_TRADEOFF_RATIO);

  if (CUSTOM_FULLSCREEN_SHADER_GAMMA == 0.f) {
    color.rgb = renodx::color::srgb::DecodeSafe(color.rgb);
  } else if (CUSTOM_FULLSCREEN_SHADER_GAMMA == 1.f) {
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.2);
  } else {
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.4);
  }

  return color;
}

float3 ScaleTonemappedTo01(float3 color) {
  color.rgb /= SDR_NOMRALIZATION_MAX;
  return color;
}

float3 AddBloom(float3 color, float3 bloom) {
  color += bloom * 0.0015 * CUSTOM_BLOOM;
  return color;
}

float3 ScaleBloomAfterSaturate(float3 color) {
  color.rgb *= CUSTOM_BLOOM;
  return color;
}

// Copied from: ff7rebirth
// AdvancedAutoHDR pass to generate some HDR brightess out of an SDR signal.
// This is hue conserving and only really affects highlights.
// "sdr_color" is meant to be in "SDR range", as in, a value of 1 matching SDR white (something between 80, 100, 203, 300 nits, or whatever else)
// https://github.com/Filoppi/PumboAutoHDR
float3 PumboAutoHDR(float3 sdr_color, float shoulder_pow = 2.75f) {
  const float SDRRatio = max(renodx::color::y::from::BT2020(sdr_color), 0.f);

  // Limit AutoHDR brightness, it won't look good beyond a certain level.
  // The paper white multiplier is applied later so we account for that.
  float target_max_luminance = min(RENODX_PEAK_WHITE_NITS, pow(10.f, ((log10(RENODX_DIFFUSE_WHITE_NITS) - 0.03460730900256) / 0.757737096673107)));
  target_max_luminance = lerp(1.f, target_max_luminance, .5f);
  target_max_luminance *= 2.5;

  const float auto_HDR_max_white = max(target_max_luminance / RENODX_DIFFUSE_WHITE_NITS, 1.f);
  const float auto_HDR_shoulder_ratio = 1.f - max(1.f - SDRRatio, 0.f);
  const float auto_HDR_extra_ratio = pow(max(auto_HDR_shoulder_ratio, 0.f), shoulder_pow) * (auto_HDR_max_white - 1.f);
  const float auto_HDR_total_ratio = SDRRatio + auto_HDR_extra_ratio;
  return sdr_color * renodx::math::SafeDivision(auto_HDR_total_ratio, SDRRatio, 1);  // Fallback on a value of 1 in case of division by 0
}