#include "./shared.h"

float3 NeutralSDRYLerp(float3 color) {
  float color_y = renodx::color::y::from::BT709(color);
  color = lerp(color, renodx::tonemap::renodrt::NeutralSDR(color), saturate(color_y));
  return color;
}

float3 ToneMapPass(float3 color_in, float3 color_out) {
  if (RENODX_TONE_MAP_TYPE == 0) {
    color_out = saturate(color_out);
  } else {
    color_out = renodx::draw::ToneMapPass(color_in, color_out, NeutralSDRYLerp(color_in));
  }
  return color_out;
}

float3 FilmGrain(float3 color_out, float2 v1) {
  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    color_out = renodx::effects::ApplyFilmGrain(
        color_out,
        v1.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }
  return color_out;
}