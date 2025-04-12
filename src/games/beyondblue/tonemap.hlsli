#include "./shared.h"

static const float3x3 SRGB_to_ACES_MAT = float3x3(
    0.4397010, 0.3829780, 0.1773350,
    0.0897923, 0.8134230, 0.0967616,
    0.0175440, 0.1115440, 0.8707040);

static const float3x3 ACES_to_SRGB_MAT = float3x3(
    2.52169, -1.13413, -0.38756,
    -0.27648, 1.37272, -0.09624,
    -0.01538, -0.15298, 1.16835);

float3 ApplyUserColorGrading(float3 ungraded, uint preset = 0u) {
  if (preset == 1u) {  // Match Unity Neutral ToneMap
    return renodx::color::grade::UserColorGrading(
        ungraded,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS * 0.84f,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_BLOWOUT);
  } else {
    return renodx::color::grade::UserColorGrading(
        ungraded,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_BLOWOUT);
  }
}

float3 vanillaACES(float3 color) {
  static const float a = 278.5085;
  static const float b = 10.7772;
  static const float c = 293.6045;
  static const float d = 88.7122;
  static const float e = 80.6889;
  color = mul(renodx::color::BT709_TO_AP0_MAT, color);  // Convert to AP0
  color = renodx::tonemap::aces::RRT(color);
  color = (color * (a * color + b)) / (color * (c * color + d) + e);
  color = renodx::tonemap::aces::DarkToDim(color);
  float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;
  color = lerp(dot(color, AP1_RGB2Y).rrr, color, 0.93);
  color = renodx::color::bt709::from::AP1(color);
  color = max(0, color);
  return color;
}

float3 ApplyUserToneMapACES(float3 untonemapped_bt709) {
  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    const float ACES_MID_GRAY = 0.10f;
    const float ACES_MIN = 0.0001f;
    float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
    float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    if (RENODX_GAMMA_CORRECTION) {
      aces_max = renodx::color::correct::Gamma(aces_max, true);
      aces_min = renodx::color::correct::Gamma(aces_min, true);
    }
    untonemapped_bt709 = ApplyUserColorGrading(untonemapped_bt709);
    tonemapped = renodx::tonemap::aces::RRTAndODT(untonemapped_bt709, aces_min * 48.f, aces_max * 48.f) / 48.f;
    tonemapped = renodx::color::correct::Hue(tonemapped, untonemapped_bt709, RENODX_TONE_MAP_HUE_CORRECTION);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    return ApplyUserColorGrading(untonemapped_bt709);
  } else {
    tonemapped = vanillaACES(untonemapped_bt709);
  }

  return tonemapped;
}

float3 ApplyToneMapNeutral(float3 untonemapped_bt709) {
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    float peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION) peak_nits = renodx::color::correct::Gamma(peak_nits, true);
    untonemapped_bt709 = ApplyUserColorGrading(untonemapped_bt709, 1u);
    float3 tonemapped = renodx::tonemap::ExponentialRollOff(untonemapped_bt709, min(1.f, peak_nits * 0.5f), peak_nits);
    tonemapped = renodx::color::correct::Hue(tonemapped, untonemapped_bt709, RENODX_TONE_MAP_HUE_CORRECTION);
    return tonemapped;
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    return ApplyUserColorGrading(untonemapped_bt709);
  } else {
    return renodx::tonemap::unity::BT709(untonemapped_bt709);
  }
}
