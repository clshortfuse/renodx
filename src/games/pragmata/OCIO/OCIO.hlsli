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

    // Derive exp-shift from a fixed reference curve so peak changes are stable.
    if (stable_peak_exp_shift) {
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
float3 GenerateOutput(float3 untonemapped_ap1, float2 uv, uint output_mode) {
  float3 tonemapped_bt2020;

  float peak_nits = RENODX_PEAK_WHITE_NITS;
  float diffuse_white_nits = RENODX_DIFFUSE_WHITE_NITS;
  int gamut_compression_mode = renodx::tonemap::psychov::PSYCHO30_TARGET_GAMUT_DISPLAY_P3;
  if (output_mode == 0u) {
    peak_nits = 203.f;
    diffuse_white_nits = 203.f;
    gamut_compression_mode = renodx::tonemap::psychov::PSYCHO30_TARGET_GAMUT_BT709;
  }

  if (TONE_MAP_TYPE == 1.f) {  // RenoDX (Enhanced)
    const float mid_gray_in = 0.195652f;
    const float mid_gray_out = 0.102317f;
    const float highlight_contrast = 45.f / 50.f;
    const float cone_response_exponent = 1.255f;
    const float shadow_contrast = 1.55f;
    const float shadows = 0.5f;
    const float flare = 0.72f;

    float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
    float3 tonemapped_bt709 = renodx::tonemap::psychov::psychotm_custom_test30(
        untonemapped_bt709,
        peak_nits / diffuse_white_nits, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, shadows * RENODX_TONE_MAP_SHADOWS,
        cone_response_exponent * RENODX_TONE_MAP_CONTRAST, 0.10f * pow(flare, 10.f) + 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
        highlight_contrast * RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS, shadow_contrast * RENODX_TONE_MAP_CONTRAST_SHADOWS,
        RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, RENODX_TONE_MAP_DECHROMA,
        mid_gray_in, mid_gray_out, 0.f, 1.f, gamut_compression_mode, 1.5f, 0.35f);
    tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);

  } else {  // RenoDX (Vanilla+)
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
    const float ACES_MIN = 0.0001f;
    float aces_min = ACES_MIN / diffuse_white_nits;
    float aces_max = (peak_nits / diffuse_white_nits);
    if (TONE_MAP_TYPE == 3.f) {  // RenoDX (Vanilla+, Matches SDR)
      // fudged ACES coefficients to match SDR
      const float ACES_MID = 8.f;
      const float EXP_SHIFT_REFERENCE_MAX = 28.f;
      const float EXP_SHIFT_REFERENCE_MIN = 0.0001f;
      const float ACES_DIFFUSE = ACES_MID * 10.f;

      {
        aces_max = renodx::color::correct::Gamma(aces_max, true);
        aces_min = renodx::color::correct::Gamma(aces_min, true);
      }

      renodx::tonemap::aces::ODTConfig ODT_config = renodx_custom::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, EXP_SHIFT_REFERENCE_MAX, EXP_SHIFT_REFERENCE_MIN);

      float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / ACES_DIFFUSE;
      tonemapped_ap1 = lerp(renodx::color::y::from::AP1(tonemapped_ap1), tonemapped_ap1, 0.96f);
      float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

      {
        tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
      }

      tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);

    } else {  // RenoDX (Vanilla+, Matches HDR)
      const float ACES_MID = 15.f;
      const float EXP_SHIFT_REFERENCE_MAX = 1000.f;
      const float EXP_SHIFT_REFERENCE_MIN = 0.0001f;
      const float ACES_DIFFUSE = ACES_MID * 10.f;

      renodx::tonemap::aces::ODTConfig ODT_config = renodx_custom::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, EXP_SHIFT_REFERENCE_MAX, EXP_SHIFT_REFERENCE_MIN);

      float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / ACES_DIFFUSE;
      tonemapped_bt2020 = renodx::color::bt2020::from::AP1(tonemapped_ap1);
    }
  }

  if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    tonemapped_bt2020 = renodx::effects::ApplyFilmGrain(
        tonemapped_bt2020, uv, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.06f,
        1.f, false, renodx::color::BT2020_TO_XYZ_MAT);
  }

  float3 output;
  if (output_mode == 1u) {  // HDR
    output = renodx::color::pq::EncodeSafe(tonemapped_bt2020, RENODX_DIFFUSE_WHITE_NITS);
  } else {  // SDR
    output = renodx::color::gamma::Encode(max(0, renodx::color::bt709::from::BT2020(tonemapped_bt2020)), 2.2f);
  }

  return output;
}
