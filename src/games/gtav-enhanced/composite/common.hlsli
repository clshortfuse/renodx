#include "../shared.h"

void ConfigureVanillaNoise(in float vanilla_red, in float vanilla_green,
                           in float vanilla_blue, inout float grained_red,
                           inout float grained_green,
                           inout float grained_blue) {
  grained_red = lerp(vanilla_red, grained_red, CUSTOM_NOISE_STRENGTH);
  grained_green = lerp(vanilla_green, grained_green, CUSTOM_NOISE_STRENGTH);
  grained_blue = lerp(vanilla_blue, grained_blue, CUSTOM_NOISE_STRENGTH);
}

void ConfigureAutoExposure(in float3 untonemapped, inout float auto_exposed_red, inout float auto_exposed_green, inout float auto_exposed_blue) {
  auto_exposed_red = lerp(untonemapped.r, auto_exposed_red, CUSTOM_AUTO_EXPOSURE);
  auto_exposed_green = lerp(untonemapped.g, auto_exposed_green, CUSTOM_AUTO_EXPOSURE);
  auto_exposed_blue = lerp(untonemapped.b, auto_exposed_blue, CUSTOM_AUTO_EXPOSURE);
}

void ConfigureVanillaGrain(inout float grain_add, inout float grain_multiply) {
  grain_add *= CUSTOM_FILM_GRAIN;
  grain_multiply = lerp(1.f, grain_multiply, CUSTOM_FILM_GRAIN);
}

float4 CustomToneMap(float3 untonemapped, float midgray,
                     float3 post_effect_a, float3 post_effect_b, float post_effect_lerp, float exponent,
                     float2 position) {
  untonemapped = renodx::color::gamma::Decode(untonemapped);
  untonemapped *= midgray / 0.18f;
  untonemapped = renodx::color::gamma::Encode(untonemapped);
  untonemapped = renodx::math::SignPow(untonemapped, exponent);
  untonemapped = renodx::color::gamma::Decode(untonemapped);

  float3 post_process_color = lerp(post_effect_a, post_effect_b, post_effect_lerp);
  post_process_color = renodx::math::SignPow(post_process_color, exponent);
  post_process_color = renodx::color::gamma::Decode(post_process_color);

  float3 tonemapped = renodx::draw::ToneMapPass(untonemapped, post_process_color);
  float tonemap_luminance = renodx::color::y::from::BT709(tonemapped);
  if (CUSTOM_FILM_GRAIN != 0.f) {
    tonemapped = renodx::effects::ApplyFilmGrain(
        tonemapped,
        position,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN * 0.03f,
        1.f);
  }

  float3 output = renodx::draw::RenderIntermediatePass(tonemapped);
  return float4(output, tonemap_luminance);
}
