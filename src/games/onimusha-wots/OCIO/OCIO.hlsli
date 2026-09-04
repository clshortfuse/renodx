#include "../common.hlsli"
#include "./customtest30.hlsli"

namespace renodx_custom {
namespace tonemap {
namespace aces {

renodx::tonemap::aces::ODTConfig CreateODTConfig(
    float min_y,
    float max_y,
    float mid_y,
    bool stable_peak_exp_shift = false,
    float exp_shift_max_reference = 1000.f,
    float exp_shift_min_reference = 0.0001f) {
  renodx::tonemap::aces::ODTConfig config = renodx::tonemap::aces::CreateODTConfig(min_y, max_y);

  if (mid_y != 4.8f) {
    renodx::tonemap::aces::ODTConfig exp_shift_config;

    // derive exp-shift from a fixed reference curve so peak changes are stable
    const bool use_stable_reference =
        stable_peak_exp_shift && (exp_shift_max_reference != max_y || exp_shift_min_reference != min_y);
    if (use_stable_reference) {
      exp_shift_config = renodx::tonemap::aces::CreateODTConfig(exp_shift_min_reference, exp_shift_max_reference);
    } else {
      exp_shift_config = config;
    }
    float exp_shift = log2(renodx::tonemap::aces::InvSSTS(mid_y, exp_shift_config)) - log2(0.18f);
    float shift_log10 = exp_shift * log10(2.f);

    config.y_min.x -= shift_log10;
    config.y_mid.x -= shift_log10;
    config.y_max.x -= shift_log10;
  }

  return config;
}

}  // namespace aces
}  // namespace tonemap
}  // namespace renodx

// User grading -> ACES -> 2.2 EOTF emulation -> apply per channel purity onto luminance curve -> grain -> diffuse white scale + PQ encode
float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float cbuffer_peak_nits, float cbuffer_diffuse_white_nits, float2 uv) {
  float3 tonemapped_bt2020;
  if (TONE_MAP_TYPE == 1.f) {
    untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

    float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
    untonemapped_bt709 = renodx::tonemap::psychov::psychograde_custom_test30(
        untonemapped_bt709, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST, 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f), RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS, RENODX_TONE_MAP_CONTRAST_SHADOWS,
        RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, RENODX_TONE_MAP_DECHROMA, 0.18f, 0.18f);
    untonemapped_ap1 = renodx::color::ap1::from::BT709(untonemapped_bt709);
    untonemapped_ap1 = max(0, untonemapped_ap1);

    // In order to change ACES_MID, we use The Academy's exp-shift system
    // The curve is built around 4.8 ACES_MID however, so changing it causes the curve to break
    // Values other than 4.8 make it so that increasing peak causes midtones to compress and vice-versa
    // We fix this by basing the exp-shifted curve on reference ACES_MAX and ACES_MIN values
    // We then scale brightness like SDR as a linear scalar
    // ACES_MAX and ACES_MIN are pre-adjusted in order to account for the post-tonemap diffuse white scalar which we define as `10.f * ACES_MID`
    float ACES_MID;
    float EXP_SHIFT_REFERENCE_MAX;
    float EXP_SHIFT_REFERENCE_MIN;
    if (TONE_MAP_ACES_MID_GRAY == 0.f) {
      ACES_MID = 4.8f;
      EXP_SHIFT_REFERENCE_MAX = 48.f;
      EXP_SHIFT_REFERENCE_MIN = 0.02f;
    } else if (TONE_MAP_ACES_MID_GRAY == 1.f) {
      ACES_MID = 10.f;
      EXP_SHIFT_REFERENCE_MAX = 100.f;
      EXP_SHIFT_REFERENCE_MIN = 0.02f;
    } else {
      ACES_MID = 15.f;
      EXP_SHIFT_REFERENCE_MAX = 1000.f;
      EXP_SHIFT_REFERENCE_MIN = 0.0001f;
    }
    const float ACES_DIFFUSE = ACES_MID * 10.f;
    const float ACES_MIN = 0.0001f;
    float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
    float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    if (RENODX_GAMMA_CORRECTION == 1.f) {
      aces_max = renodx::color::correct::Gamma(aces_max, true);
      aces_min = renodx::color::correct::Gamma(aces_min, true);
    } else if (RENODX_GAMMA_CORRECTION == 2.f) {
      aces_min /= 10.f;
    }

    renodx::tonemap::aces::ODTConfig ODT_config = renodx_custom::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, EXP_SHIFT_REFERENCE_MAX, EXP_SHIFT_REFERENCE_MIN);

    float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / ACES_DIFFUSE;
    float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

    if (RENODX_GAMMA_CORRECTION == 1.f) {
      tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
    }

    tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);
  } else {
    float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
    float3 tonemapped_bt709 = renodx::tonemap::psychov::psychotm_custom_test30(
        untonemapped_bt709,
        RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST, 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f), RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS, RENODX_TONE_MAP_CONTRAST_SHADOWS,
        RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, RENODX_TONE_MAP_DECHROMA,
        0.45f, 0.1f, 0.f, 1.f, renodx::tonemap::psychov::PSYCHO30_TARGET_GAMUT_BT2020, 1.5f, 0.7f);
    tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);
  }

  if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    tonemapped_bt2020 = renodx::effects::ApplyFilmGrain(
        tonemapped_bt2020, uv, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.06f,
        1.f, false, renodx::color::BT2020_TO_XYZ_MAT);
  }

  return renodx::color::pq::EncodeSafe(tonemapped_bt2020, RENODX_DIFFUSE_WHITE_NITS);
}
