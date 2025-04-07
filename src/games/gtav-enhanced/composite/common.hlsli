#include "../shared.h"

void ConfigureVanillaDithering(in float vanilla_red, in float vanilla_green,
                               in float vanilla_blue, inout float dithered_red,
                               inout float dithered_green,
                               inout float dithered_blue) {
  dithered_red = lerp(vanilla_red, dithered_red, CUSTOM_DITHERING);
  dithered_green = lerp(vanilla_green, dithered_green, CUSTOM_DITHERING);
  dithered_blue = lerp(vanilla_blue, dithered_blue, CUSTOM_DITHERING);
}

void ConfigureVanillaGrain(inout float grain_add, inout float grain_multiply) {
  grain_add *= CUSTOM_FILM_GRAIN;
  grain_multiply = lerp(1.f, grain_multiply, CUSTOM_FILM_GRAIN);
}

float4 CustomToneMap(float3 untonemapped, float midgray, float3 post_effect_a,
                     float3 post_effect_b, float post_effect_lerp,
                     float2 position) {
  untonemapped *= midgray / 0.18f;

  float3 post_process_color = lerp(post_effect_a, post_effect_b, post_effect_lerp);

  untonemapped = max(0, untonemapped);
  post_process_color = max(0, post_process_color);

  float3 tonemapped = renodx::draw::ToneMapPass(untonemapped, post_process_color);

  float tonemap_luminance = renodx::color::y::from::BT709(abs(tonemapped));
  if (CUSTOM_FILM_GRAIN != 0.f) {
    tonemapped = renodx::effects::ApplyFilmGrain(
        tonemapped, position, CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f, 1.f);
  }

  float3 output = renodx::draw::RenderIntermediatePass(tonemapped);
  return float4(output, tonemap_luminance);
}
