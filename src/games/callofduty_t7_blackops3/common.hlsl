#include "./shared.h"

#define SDR_NOMRALIZATION_MAX 32769.0 //32768 has floating point error
// #define SDR_NOMRALIZATION_TRADEOFF 0.15 //TODO to reshade var instead?

// float3 LUT_CorrectBlack(float3 color_input, float3 lut_color) {
//   // if (CUSTOM_LUT_BLACK_THRESHOLD <= 0) return lut_color;
//   return renodx::lut::CorrectBlack(color_input, lut_color, SDR_NOMRALIZATION_MAX * 0.01f * CUSTOM_LUT_BLACK_THRESHOLD, CUSTOM_LUT_BLACK_AMOUNT);
//   // return color_input;
// }

// float3 LUT_CorrectWhite(float3 color_input, float3 lut_color) {
//   // if (CUSTOM_LUT_WHITE_THRESHOLD <= 0) return lut_color;
//   return renodx::lut::CorrectWhite(color_input, lut_color, (SDR_NOMRALIZATION_MAX) - (SDR_NOMRALIZATION_MAX * CUSTOM_LUT_WHITE_THRESHOLD), SDR_NOMRALIZATION_MAX, CUSTOM_LUT_WHITE_AMOUNT);
// }

float3 Tonemap_FixInColor(float3 color) {
  // color /= 0.01;
  return color;
}

float3 Tradeoff_LinearToTradeoffSpace(float3 color) {
  if (CUSTOM_TRADEOFF_MODE == 0.f) {
    return renodx::color::srgb::EncodeSafe(color);
  } else if (CUSTOM_TRADEOFF_MODE == 1.f) {
    return renodx::color::gamma::EncodeSafe(color, CUSTOM_TRADEOFF_GAMMA_AMOUNT);
  } else if (CUSTOM_TRADEOFF_MODE == 2.f) {
    return renodx::color::pq::EncodeSafe(color);
  } else {
    return color;
  }
}

float3 Tradeoff_TradeoffSpaceToLinear(float3 color) {
  if (CUSTOM_TRADEOFF_MODE == 0.f) {
    return renodx::color::srgb::DecodeSafe(color);
  } else if (CUSTOM_TRADEOFF_MODE == 1.f) {
    return renodx::color::gamma::DecodeSafe(color, CUSTOM_TRADEOFF_GAMMA_AMOUNT);
  } else if (CUSTOM_TRADEOFF_MODE == 2.f) {
    return renodx::color::pq::DecodeSafe(color);
  } else {
    return color;
  }
}


float3 Tradeoff_TonemappedTo01(float3 color) {
  color.rgb /= SDR_NOMRALIZATION_MAX;
  return color;
}

/*
* in: scaled tradeoff color space normalized up to SDR_NOMRALIZATION_MAX
* out: linear for RenderImmediatePass
*/
float3 Tradeoff_AfterFullscreenShaders(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0) return color;

  //scale down from 32768
  if (CUSTOM_TRADEOFF_RATIO > 0) color.rgb /= (SDR_NOMRALIZATION_MAX * CUSTOM_TRADEOFF_RATIO);

  //to linear
  color = Tradeoff_TradeoffSpaceToLinear(color);

  return color;
}

/*
* in: linear untonemapped & tonemapped
* out: scaled tradeoff color space normalized up to SDR_NOMRALIZATION_MAX
*/
float3 Tradeoff_Tonemap(float3 colorUntonemapped, float3 colorTonemapped, float3 colorSDRNeutral) {
  //color untonemap to tonemapped
  if (RENODX_TONE_MAP_TYPE != 0) {
    colorTonemapped = Tradeoff_TonemappedTo01(colorTonemapped);
    // if (colorTonemapped.x > 1) colorTonemapped.x = 100000;
    // if (colorTonemapped.y > 1) colorTonemapped.y = 100000;
    // if (colorTonemapped.z > 1) colorTonemapped.z = 100000;
    colorSDRNeutral = Tradeoff_TonemappedTo01(colorSDRNeutral);
    colorTonemapped = renodx::draw::ToneMapPass(colorUntonemapped * CUSTOM_TONE_MAP_PREEXPOSURE, colorTonemapped, colorSDRNeutral);
    // colorTonemapped = renodx::color::bt2020::from::BT709(colorTonemapped);
  }
  
  //gatekeep: skip tradeoff
  if (RENODX_TONE_MAP_TYPE == 0) return colorTonemapped;

  //to srgb/gamma
  colorTonemapped = Tradeoff_LinearToTradeoffSpace(colorTonemapped); //we do this before the next to not immediately clip the values

  //scale up to 32768
  if (CUSTOM_TRADEOFF_RATIO > 0) colorTonemapped *= (SDR_NOMRALIZATION_MAX * CUSTOM_TRADEOFF_RATIO);

  return colorTonemapped;
}

float3 Bloom_AddScaled(float3 color, float3 bloom) {
  color += bloom * 0.0015 * CUSTOM_BLOOM;
  return color;
}

float3 Bloom_ScaleTonemappedAfterSaturate(float3 color) {
  color.rgb *= CUSTOM_BLOOM;
  return color;
}

float3 Tradeoff_PrepareFullWidthFsfx(float3 color, float scale = 1) {
  color.xyz /= 32768.0;
  if (RENODX_TONE_MAP_TYPE == 0) return color;
  color.xyz = Tradeoff_LinearToTradeoffSpace(color.xyz);
  if (CUSTOM_TRADEOFF_RATIO > 0) color.xyz *= (SDR_NOMRALIZATION_MAX * CUSTOM_TRADEOFF_RATIO);;
  color.xyz *= scale;

  return color;
}


// (Copied from: ff7rebirth)
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

  const float auto_HDR_max_white = max(target_max_luminance / RENODX_DIFFUSE_WHITE_NITS, 1.f);
  const float auto_HDR_shoulder_ratio = 1.f - max(1.f - SDRRatio, 0.f);
  const float auto_HDR_extra_ratio = pow(max(auto_HDR_shoulder_ratio, 0.f), shoulder_pow) * (auto_HDR_max_white - 1.f);
  const float auto_HDR_total_ratio = SDRRatio + auto_HDR_extra_ratio;
  return sdr_color * renodx::math::SafeDivision(auto_HDR_total_ratio, SDRRatio, 1);  // Fallback on a value of 1 in case of division by 0
}