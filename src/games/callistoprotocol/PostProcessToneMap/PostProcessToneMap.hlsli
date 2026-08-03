#ifndef SRC_GAMES_CALLISTOPROTOCOL_POST_PROCESS_TONE_MAP_HLSLI_
#define SRC_GAMES_CALLISTOPROTOCOL_POST_PROCESS_TONE_MAP_HLSLI_

#include "../common.hlsli"

float3 ApplyPerceptualFilmGrainBT709(float3 color, float2 screen_uv, bool is_srgb_encoded) {
  if (is_srgb_encoded) {
    color = renodx::color::srgb::DecodeSafe(color);
  }

  color = renodx::effects::ApplyFilmGrain(
      color,
      screen_uv,
      CUSTOM_RANDOM,
      CUSTOM_GRAIN_STRENGTH * 0.03f,
      1.f,
      false,
      renodx::color::BT709_TO_XYZ_MAT);

  if (is_srgb_encoded) {
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 ApplyPerceptualFilmGrainBT2020PQ(float3 color_pq, float2 screen_uv) {
  float3 color = renodx::color::pq::DecodeSafe(color_pq, 250.f);
  color = renodx::effects::ApplyFilmGrain(
      color,
      screen_uv,
      CUSTOM_RANDOM,
      CUSTOM_GRAIN_STRENGTH * 0.03f,
      1.f,
      false,
      renodx::color::BT2020_TO_XYZ_MAT);
  return renodx::color::pq::EncodeSafe(color, 250.f);
}

#endif  // SRC_GAMES_CALLISTOPROTOCOL_POST_PROCESS_TONE_MAP_HLSLI_