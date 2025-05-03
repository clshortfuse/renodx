#include "./shared.h"

float3 HueCorrectAP1(float3 incorrect_color_ap1, float3 correct_color_ap1, float hue_correct_strength = 0.5f) {
  float3 incorrect_color_bt709 = renodx::color::bt709::from::AP1(incorrect_color_ap1);
  float3 correct_color_bt709 = renodx::color::bt709::from::AP1(correct_color_ap1);

  float3 corrected_color_bt709 = renodx::color::correct::Hue(incorrect_color_bt709, correct_color_bt709, hue_correct_strength, 0u);
  float3 corrected_color_ap1 = renodx::color::ap1::from::BT709(corrected_color_bt709);
  return corrected_color_ap1;
}

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits, float diffuse_white_nits) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);

#if RENODX_GAME_GAMMA_CORRECTION
  aces_max = renodx::color::correct::Gamma(aces_max, true);
  aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

  float3 tonemapped_ap1 = renodx::tonemap::aces::RRTAndODT(untonemapped_bt709, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;

#if HUE_CORRECTION
  float3 tonemapped_hue_corrected_ap1 = HueCorrectAP1(tonemapped_ap1, untonemapped_ap1);
  tonemapped_ap1 = lerp(tonemapped_hue_corrected_ap1, tonemapped_ap1, saturate(tonemapped_hue_corrected_ap1));
#endif
  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

#if RENODX_GAME_GAMMA_CORRECTION
  tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
#endif

  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), diffuse_white_nits);

  return pq_color;
}