#ifndef RENODX_ELITEDANGEROUS_COMMON_HLSLI_
#define RENODX_ELITEDANGEROUS_COMMON_HLSLI_

#include "./shared.h"

float3 GameScaleAndGrain(float3 color, float2 screen_position) {
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color = renodx::effects::ApplyFilmGrain(
      color,
      screen_position,
      CUSTOM_RANDOM,
      CUSTOM_GRAIN_STRENGTH * 0.03f,
      1.f);

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    color = renodx::color::bt2020::from::BT709(color);
    color = min(color, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    color = renodx::color::bt709::from::BT2020(color);
  }
#endif

  color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  return color;
}

float3 GameScale(float3 color) {
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  return color;
}

float3 FinalizeOutput(float3 color) {
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color = renodx::color::bt2020::from::BT709(color);
  color = renodx::color::pq::EncodeSafe(color, RENODX_GRAPHICS_WHITE_NITS);

  return color;
}

#endif  // RENODX_ELITEDANGEROUS_COMMON_HLSLI_