#include "./shared.h"

static const float3x3 ACES_to_ACEScg_MAT = float3x3(
    1.4514393161f, -0.2365107469f, -0.2149285693f,
    -0.0765537734f, 1.1762296998f, -0.0996759264f,
    0.0083161484f, -0.0060324498f, 0.9977163014f);

static const float3x3 SRGB_to_ACES_MAT = float3x3(
    0.4397010, 0.3829780, 0.1773350,
    0.0897923, 0.8134230, 0.0967616,
    0.0175440, 0.1115440, 0.8707040);

static const float3x3 ACES_to_SRGB_MAT = float3x3(
    2.52169, -1.13413, -0.38756,
    -0.27648, 1.37272, -0.09624,
    -0.01538, -0.15298, 1.16835);

float3 ApplyToneMap(float3 untonemapped_bt709, float peak_nits, float diffuse_white_nits) {

    float3 untonemapped_ap1 = renodx::color::ap1::from::BT709(untonemapped_bt709);

  const float ACES_MID_GRAY = 0.10f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);

#if RENODX_GAMMA_CORRECTION
  aces_max = renodx::color::correct::Gamma(aces_max, true);
  aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

  float3 tonemapped = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f);
  tonemapped /= 48.f;

// #if RENODX_GAMMA_CORRECTION
//   tonemapped = renodx::color::correct::GammaSafe(tonemapped);
// #endif

  return tonemapped;
}