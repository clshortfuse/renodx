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

float3 ApplyPerChannelCorrection(
    float3 untonemapped,
    float3 per_channel_color,
    float blowout_restoration = 0.5f,
    float hue_correction_strength = 1.f,
    float chrominance_correction_strength = 0.f) {
  const float3 tonemapped_perceptual = renodx::color::ictcp::from::BT709(per_channel_color);
  const float3 untonemapped_perceptual = renodx::color::ictcp::from::BT709(untonemapped);

  float2 untonemapped_chromas = untonemapped_perceptual.yz;
  float2 tonemapped_chromas = tonemapped_perceptual.yz;

  float untonemapped_chrominance = length(untonemapped_perceptual.yz);  // eg: 0.80
  float tonemapped_chrominance = length(tonemapped_perceptual.yz);      // eg: 0.20

  // clamp saturation loss
  float chrominance_loss = max(
      renodx::math::DivideSafe(tonemapped_chrominance / untonemapped_chrominance, 1.f),  // eg: 0.25
      blowout_restoration);

  // Untonemapped hue, tonemapped chrominance (with limit)
  float2 reduced_untonemapped_chromas = untonemapped_chromas * chrominance_loss;

  const float2 reduced_hue_shifted = lerp(reduced_untonemapped_chromas, tonemapped_chromas, chrominance_loss);

  const float2 blowout_restored_chromas = reduced_hue_shifted * length(reduced_untonemapped_chromas) / length(reduced_hue_shifted);

  const float2 blended_correct_chromas = lerp(untonemapped_chromas, blowout_restored_chromas, saturate(renodx::color::y::from::BT709(untonemapped) / 0.36));

  const float2 blowout_restored_chrominance = length(blowout_restored_chromas);

  const float2 chroma_corrected = blowout_restored_chromas
                                  * lerp(blowout_restored_chrominance, length(blended_correct_chromas), chrominance_correction_strength)
                                  / blowout_restored_chrominance;

  const float2 hue_corrected_chromas = lerp(chroma_corrected, blended_correct_chromas, hue_correction_strength);

  const float2 final_chromas = hue_corrected_chromas
                               * length(chroma_corrected)
                               / length(hue_corrected_chromas);

  return renodx::color::bt709::from::ICtCp(float3(tonemapped_perceptual.x, final_chromas));
}

void ApplyPerChannelCorrection(float3 untonemapped,
                               inout float vanilla_red,
                               inout float vanilla_green,
                               inout float vanilla_blue) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  if (CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION == 0.f
      && CUSTOM_COLOR_GRADE_HUE_CORRECTION == 0.f
      && CUSTOM_COLOR_GRADE_SATURATION_CORRECTION == 0.f) {
    return;
  }
  float3 vanilla_color = float3(vanilla_red, vanilla_green, vanilla_blue);
  float3 new_vanilla_color = ApplyPerChannelCorrection(
      untonemapped,
      vanilla_color,
      CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION,
      CUSTOM_COLOR_GRADE_HUE_CORRECTION,
      CUSTOM_COLOR_GRADE_SATURATION_CORRECTION);
  vanilla_red = new_vanilla_color.r;
  vanilla_green = new_vanilla_color.g;
  vanilla_blue = new_vanilla_color.b;
}

float4 CustomToneMap(float3 untonemapped, float3 post_effect_a,
                     float3 post_effect_b, float post_effect_lerp,
                     float2 position) {
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
