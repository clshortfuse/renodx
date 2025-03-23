#include "./shared.h"

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits, float diffuse_white_nits) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

  const float ACES_MID_GRAY = 0.10f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);

#if RENODX_GAME_GAMMA_CORRECTION
  aces_max = renodx::color::correct::Gamma(aces_max, true);
  aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

  float3 tonemapped = renodx::tonemap::aces::RRTAndODT(untonemapped_bt709, aces_min * 48.f, aces_max * 48.f);
  tonemapped /= 48.f;

#if RENODX_GAME_GAMMA_CORRECTION
  tonemapped = renodx::color::correct::GammaSafe(tonemapped);
#endif

  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped), diffuse_white_nits);

  return pq_color;
}
