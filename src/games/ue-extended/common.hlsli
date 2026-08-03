#ifndef SRC_GAMES_UE_EXTENDED_COMMON_HLSLI_
#define SRC_GAMES_UE_EXTENDED_COMMON_HLSLI_

#include "./shared.h"

#define RENODX_BT709_LMS_WHITE renodx::color::lms::from::BT709(1.f.xxx)

// Pumbo's "accurate blue correct"
float3 ApplyBlueCorrectionPrePumbo(float3 untonemapped_ap1, float blue_correction) {
  if (FORCE_BLUE_CORRECT == 1.f) {
    blue_correction = 0.6f;
  }

  float R = lerp(1.0, 0.9387864139, blue_correction);
  float G = lerp(1.0, 0.8308209395, blue_correction);

  // Forward blue correction
  float corrected_r = lerp(untonemapped_ap1.b, untonemapped_ap1.r, R);
  float corrected_g = lerp(untonemapped_ap1.b, untonemapped_ap1.g, G);

  return float3(corrected_r, corrected_g, untonemapped_ap1.b);
}

float3 ApplyBlueCorrectionPostPumbo(float3 tonemapped_ap1, float blue_correction) {
  if (FORCE_BLUE_CORRECT == 1.f) {
    blue_correction = 0.6f;
  }

  float R = lerp(1.0, 0.9387864139, blue_correction);
  float G = lerp(1.0, 0.8308209395, blue_correction);

  float InvR = rcp(R);
  float InvG = rcp(G);

  float corrected_r = lerp(tonemapped_ap1.b, tonemapped_ap1.r, InvR);
  float corrected_g = lerp(tonemapped_ap1.b, tonemapped_ap1.g, InvG);

  return float3(corrected_r, corrected_g, tonemapped_ap1.b);
}

///

float3 ApplyBlueCorrectionPre(float3 untonemapped_ap1, float blue_correction) {
  return (ApplyBlueCorrectionPrePumbo(untonemapped_ap1, blue_correction));

#if 0
  if (FORCE_BLUE_CORRECT == 1.f) {
    blue_correction = 0.6f;
  }

  float r = untonemapped_ap1.r, g = untonemapped_ap1.g, b = untonemapped_ap1.b;

  float corrected_r = ((mad(0.061360642313957214f, b, mad(-4.540197551250458e-09f, g, (r * 0.9386394023895264f))) - r) * blue_correction) + r;
  float corrected_g = ((mad(0.169205904006958f, b, mad(0.8307942152023315f, g, (r * 6.775371730327606e-08f))) - g) * blue_correction) + g;
  float corrected_b = (mad(-2.3283064365386963e-10f, g, (r * -9.313225746154785e-10f)) * blue_correction) + b;

  return float3(corrected_r, corrected_g, corrected_b);
#endif
}

float3 ApplyBlueCorrectionPost(float3 tonemapped_ap1, float blue_correction) {
  return (ApplyBlueCorrectionPostPumbo(tonemapped_ap1, blue_correction));

#if 0
  if (FORCE_BLUE_CORRECT == 1.f) {
    blue_correction = 0.6f;
  }

  float r = tonemapped_ap1.r, g = tonemapped_ap1.g, b = tonemapped_ap1.b;

  float corrected_r = ((mad(-0.06537103652954102f, b, mad(1.451815478503704e-06f, g, (r * 1.065374732017517f))) - r) * blue_correction) + r;
  float corrected_g = ((mad(-0.20366770029067993f, b, mad(1.2036634683609009f, g, (r * -2.57161445915699e-07f))) - g) * blue_correction) + g;
  float corrected_b = ((mad(0.9999996423721313f, b, mad(2.0954757928848267e-08f, g, (r * 1.862645149230957e-08f))) - b) * blue_correction) + b;

  return float3(corrected_r, corrected_g, corrected_b);
#endif
}

float3 BlueCorrectedAP1FromBT709(float3 color_bt709, float blue_correction) {
  return ApplyBlueCorrectionPre(
      renodx::color::ap1::from::BT709(color_bt709),
      blue_correction);
}

float3 BT709FromBlueCorrectedAP1(float3 color_ap1, float blue_correction) {
  return renodx::color::bt709::from::AP1(
      ApplyBlueCorrectionPost(color_ap1, blue_correction));
}

float3 BlueCorrectedAP1FromLMS(float3 color_lms, float blue_correction) {
  return ApplyBlueCorrectionPre(
      renodx::color::ap1::from::LMS(color_lms),
      blue_correction);
}

float3 LMSFromBlueCorrectedAP1(float3 color_ap1, float blue_correction) {
  return renodx::color::lms::from::AP1(
      ApplyBlueCorrectionPost(color_ap1, blue_correction));
}

// input: BT.709 linear
// output: BT.709 linear
float3 ApplyGammaCorrectionAP1(float3 color_bt709, bool inverse, float blue_correction) {
  float3 color_blue_corrected_ap1 = BlueCorrectedAP1FromBT709(color_bt709, blue_correction);
  return BT709FromBlueCorrectedAP1(
      renodx::color::correct::GammaSafe(color_blue_corrected_ap1, inverse),
      blue_correction);
}

// input: BT.709 linear
// output: BT.709 linear
float3 ApplyGammaCorrectionLMS(float3 color_bt709, bool inverse) {
  float3 color_lms_normalized = renodx::color::lms::from::BT709(color_bt709) / RENODX_BT709_LMS_WHITE;
  return renodx::color::bt709::from::LMS(
      renodx::color::correct::GammaSafe(color_lms_normalized, inverse) * RENODX_BT709_LMS_WHITE);
}

// input: BT.709 linear
// output: BT.709 linear
float3 ApplyGammaCorrection(float3 color_bt709, bool inverse = false, float blue_correction = 0.f) {
  if (RENODX_GAMMA_CORRECTION == 0.f) return color_bt709;

  if (RENODX_GAMMA_CORRECTION_WORKING_SPACE == 0.f || RENODX_TONE_MAP_TYPE == 0.f) {
    return renodx::color::correct::GammaSafe(color_bt709, inverse);
  }

  if (RENODX_TONE_MAP_SCALING <= 1.f) {
    return ApplyGammaCorrectionAP1(color_bt709, inverse, blue_correction);
  }
  return ApplyGammaCorrectionLMS(color_bt709, inverse);
}

#endif  // SRC_GAMES_UE_EXTENDED_COMMON_HLSLI_

