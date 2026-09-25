#include "./shared.h"

float3 applyFilmGrain(float3 outputColor, float2 screen, float intensity = -1) {
  if (intensity == -1) {
    intensity = CUSTOM_FILM_GRAIN;
  } else {}
  float3 grainedColor = renodx::effects::ApplyFilmGrain(
        outputColor,
        screen,
        CUSTOM_RANDOM,
        intensity * 0.03f,
        1.f);
  return grainedColor;
}

// 0 = srgb, 1 = linear
float3 applyDither(float3 linear_input, float3 dither, int encoding = 0){
  if(CUSTOM_NOISE == 0.f){return linear_input;} else {
  float3 encoded_color;
  float3 dithered_color;
  float3 output_color;
  float3 scaled_dither = dither * CUSTOM_NOISE;
  float compression_scale = 1.f;
  [branch]
  if(RENODX_TONE_MAP_TYPE == 0.f){
    encoded_color = encoding == 0 ? renodx::color::srgb::EncodeSafe(linear_input) : linear_input;
    dithered_color = encoded_color + scaled_dither;
    output_color = encoding == 0 ? renodx::color::srgb::DecodeSafe(dithered_color) : dithered_color;
  } else {
    float3 bt2020_color = renodx::color::bt2020::from::BT709(linear_input);
    encoded_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS);
    dithered_color = encoded_color + scaled_dither;
    bt2020_color = renodx::color::pq::DecodeSafe(dithered_color, RENODX_DIFFUSE_WHITE_NITS);
    output_color = renodx::color::bt709::from::BT2020(bt2020_color);
  }
  return output_color;
  }
}