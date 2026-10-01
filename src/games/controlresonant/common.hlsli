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

// Custom primaries preserve the chosen hue angles while enclosing BT.2020 and reducing uneven per-channel highlight blowout.
static const float3x3 CUSTOM_PRIMARIES_TO_XYZ_MAT = float3x3(
    0.621829884f, 0.149360609f, 0.179265434f,
    0.183793709f, 0.779045165f, 0.037161125f,
    0.008268489f, -0.081634929f, 1.162424191f);

static const float3x3 BT2020_TO_CUSTOM_PRIMARIES_MAT = float3x3(
    1.000000000f, 0.000000000f, 0.000000000f,
    0.101286172f, 0.866239827f, 0.032474001f,
    0.000000000f, 0.084984570f, 0.915015430f);

static const float3x3 CUSTOM_PRIMARIES_TO_BT2020_MAT = float3x3(
    1.000000000f, 0.000000000f, 0.000000000f,
    -0.117334788f, 1.158448248f, -0.041113459f,
    0.010897791f, -0.107594061f, 1.096696271f);

static const float3 CUSTOM_PRIMARIES_NEUTRAL_WEIGHTS = float3(
    0.267770495f,
    0.278587608f,
    0.453641897f);

float3 CompressCustomPrimariesRadial(float3 color, float fit_strength = 1.f) {
  const float3 lower_rgb = max(-color, 0.f);
  const float lower_scale = renodx::math::Max(lower_rgb);

  if (lower_scale == 0.f) {
    return color;
  }

  const float3 clipped = max(color, 0.f);
  const float y = dot(CUSTOM_PRIMARIES_TO_XYZ_MAT[1], color);

  if (y <= 0.f) {
    return clipped;
  }

  float3 normalized_lower = lower_rgb / lower_scale;
  normalized_lower *= normalized_lower;
  normalized_lower *= normalized_lower;

  const float lower_norm = lower_scale * sqrt(sqrt(sqrt(dot(normalized_lower, normalized_lower))));
  const float radial_scale = rcp(1.f + lower_norm / y);

  const float3 fitted = mad(color - y, radial_scale, y);

  return lerp(clipped, fitted, fit_strength);
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