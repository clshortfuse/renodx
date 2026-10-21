#ifndef SRC_GAMES_CONTROL_RESONANT_COMMON_HLSLI_
#define SRC_GAMES_CONTROL_RESONANT_COMMON_HLSLI_

#include "./shared.h"
#include "./customtest31.hlsli"

float3 ClampBT709ToPositiveXYZ(float3 color) {
  float3 xyz = renodx::color::xyz::from::BT709(color);
  xyz = max(xyz, 0.f);
  return renodx::color::bt709::from::XYZ(xyz);
}

float3 ClampBT2020ToPositiveXYZ(float3 color) {
  float3 xyz = mul(renodx::color::BT2020_TO_XYZ_MAT, color);
  xyz = max(xyz, 0.f);
  return mul(renodx::color::XYZ_TO_BT2020_MAT, xyz);
}

float3 ClampBT2020ToLMS(float3 color) {
  float3 lms = renodx::color::lms::from::BT2020(color);
  lms = max(lms, 0.f);
  return renodx::color::bt2020::from::LMS(lms);
}

float3 FixNegativeLuminanceBT2020(float3 color) {
  const float3 luminance_weights = renodx::color::BT2020_TO_XYZ_MAT[1];
  const float y = dot(color, luminance_weights);

  [branch]
  if (y >= 0.f) {
    return color;
  }

  const float3 positive = max(color, 0.f);
  const float positive_y = dot(positive, luminance_weights);
  const float scale = positive_y / (positive_y - y);

  return mad(color - positive, scale, positive);
}

float3 FixNegativeLuminanceLMS(float3 lms) {
  const float3 luminance_weights = renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1];
  const float yf = dot(lms, luminance_weights);

  [branch]
  if (yf >= 0.f) {
    return lms;
  }

  const float3 positive = max(lms, 0.f);
  const float positive_yf = dot(positive, luminance_weights);
  const float scale = positive_yf / (positive_yf - yf);

  return mad(lms - positive, scale, positive);
}

#endif  // SRC_GAMES_CONTROL_RESONANT_COMMON_HLSLI_