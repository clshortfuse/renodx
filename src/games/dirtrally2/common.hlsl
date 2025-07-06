#include "./shared.h"

float3 SDRColor(float3 color) {
  if (RENODX_TONE_MAP_TYPE > 0) {
    float3 neutral_sdr_color = renodx::tonemap::renodrt::NeutralSDR(color);
    float color_y = renodx::color::y::from::BT709(color);
    color = saturate(lerp(color, neutral_sdr_color, saturate(color_y)));
  } else {
    color = color;
  }
  return color;
}

float3 TonemappedUngraded(float3 untonemapped, float3 tonemapped, float3 tonemapped_y, float mid_gray) {
  untonemapped *= mid_gray / 0.18f;
  untonemapped = lerp(tonemapped_y, untonemapped, saturate(tonemapped_y));
  float3 tonemapped_color;
  if (RENODX_TONE_MAP_TYPE > 0) {
    tonemapped_color = untonemapped;
  } else {
    tonemapped_color = tonemapped;
  }
  return tonemapped_color;
}

float3 TonemappedGraded(float3 ungraded, float3 sdr_color, float3 lut) {
  float3 color;
  if (RENODX_TONE_MAP_TYPE > 0) {
    color = renodx::tonemap::UpgradeToneMap(ungraded, sdr_color, lut, RENODX_COLOR_GRADE_STRENGTH);
  } else {
    color = lerp(sdr_color, lut, RENODX_COLOR_GRADE_STRENGTH);
  }
  return color;
}

float3 Tonemap(float3 color) {
  float3 output;
  if (RENODX_TONE_MAP_TYPE > 0) {
    output = renodx::draw::ToneMapPass(color);
  } else {
    output = saturate(color);
  }
  return renodx::draw::RenderIntermediatePass(output);
}