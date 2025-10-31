#include "./shared.h"

float3 HermiteSplineRolloff(float3 hdr_color) {
  return lerp(
      renodx::tonemap::HermiteSplineLuminanceRolloff(hdr_color),
      renodx::tonemap::HermiteSplinePerChannelRolloff(hdr_color),
      RENODX_TONE_MAP_HUE_SHIFT);
}

float3 NeutralSDRYLerp(float3 color) {
  float color_y = renodx::color::y::from::BT709(color);
  color = lerp(color, renodx::tonemap::renodrt::NeutralSDR(color), saturate(color_y));
  return color;
}

float3 ToneMapPass(float3 hdr_color, float3 sdr_color, float3 hdr_color_tm, float4 texcoord) {
  float3 output_color;
  if (RENODX_TONE_MAP_TYPE == 0) {
    output_color = saturate(sdr_color);
  } else {
    output_color = renodx::draw::ToneMapPass(hdr_color, sdr_color, hdr_color_tm);
  }
  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    output_color = renodx::effects::ApplyFilmGrain(
        output_color,
        texcoord.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }
  return output_color;
}