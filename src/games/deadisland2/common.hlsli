#include "./shared.h"

float4 GenerateOutput(float3 untonemapped_ap1) {
  // float3 untonemapped_ap1 = mul(renodx::color::AP0_TO_AP1_MAT, untonemapped_ap0);

  if (RENODX_TONE_MAP_TYPE == 1.f) {
    float3 untonemapped_bt709 = renodx::color::ap1::from::BT709(
        renodx::color::grade::UserColorGrading(
            renodx::color::bt709::from::AP1(untonemapped_ap1),
            RENODX_TONE_MAP_EXPOSURE,
            RENODX_TONE_MAP_HIGHLIGHTS,
            RENODX_TONE_MAP_SHADOWS,
            RENODX_TONE_MAP_CONTRAST,
            RENODX_TONE_MAP_SATURATION,
            RENODX_TONE_MAP_BLOWOUT,
            0.f));
    float3 pq_untonemapped = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(untonemapped_bt709), RENODX_DIFFUSE_WHITE_NITS);
    return float4(pq_untonemapped * (1.f / 1.05f), 0.f);  // lutbuilder does this
  } else {
    const float ACES_MIN = 0.0001f;
    float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
    float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    if (RENODX_GAMMA_CORRECTION) {
      aces_max = renodx::color::correct::Gamma(aces_max, true);
      aces_min = renodx::color::correct::Gamma(aces_min, true);
    }

    // exposure, highlights, shadows, contrast
    if (RENODX_TONE_MAP_EXPOSURE != 1.f || RENODX_TONE_MAP_HIGHLIGHTS != 1.f || RENODX_TONE_MAP_SHADOWS != 1.f || RENODX_TONE_MAP_CONTRAST != 1.f) {
      untonemapped_ap1 = renodx::color::ap1::from::BT709(
          renodx::color::grade::UserColorGrading(
              renodx::color::bt709::from::AP1(untonemapped_ap1),
              RENODX_TONE_MAP_EXPOSURE,
              RENODX_TONE_MAP_HIGHLIGHTS,
              RENODX_TONE_MAP_SHADOWS,
              RENODX_TONE_MAP_CONTRAST,
              1.f,
              0.f,
              0.f));
    }

    float3 tonemapped_bt709 = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f) / 48.f;

    tonemapped_bt709 =
        renodx::color::grade::UserColorGrading(
            tonemapped_bt709,
            1.f,
            1.f,
            1.f,
            1.f,
            RENODX_TONE_MAP_SATURATION,
            RENODX_TONE_MAP_BLOWOUT,
            RENODX_TONE_MAP_HUE_CORRECTION,
            renodx::color::bt709::from::AP1(untonemapped_ap1));

    if (RENODX_GAMMA_CORRECTION) {
      tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
    }

    float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), RENODX_DIFFUSE_WHITE_NITS);
    return float4(pq_color * (1.f / 1.05f), 0.f);  // lutbuilder does this
  }
}

