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

// D65-normalized custom working gamut enclosing BT.2020.
// R: -22.00° from D65 at the original radius, between the -26° and -20° tests.
// G: +102.99° from D65, unchanged.
// B: -121.17° from D65, unchanged near the zero-Y boundary.
// Luminance weights are the XYZ Y row.
static const float3x3 CUSTOM_PRIMARIES_TO_XYZ_MAT = float3x3(
    0.612967501f, 0.182980916f, 0.154481636f,
    0.045506479f, 0.954404231f, 0.000089290f,
    -0.014696686f, -0.100010531f, 1.203513710f);

static const float3x3 BT2020_TO_CUSTOM_PRIMARIES_MAT = float3x3(
    0.962911598f, 0.003151046f, 0.033926831f,
    0.229335471f, 0.710230844f, 0.060434168f,
    0.030816078f, 0.082383413f, 0.887009192f);

static const float3x3 CUSTOM_PRIMARIES_TO_BT2020_MAT = float3x3(
    1.039789708f, 0.000000002f, -0.039770468f,
    -0.335327217f, 1.419208998f, -0.083868493f,
    -0.004979475f, -0.131812931f, 1.136555237f);

static const float3 CUSTOM_PRIMARIES_LUMINANCE_WEIGHTS = float3(
    0.045506479f,
    0.954404231f,
    0.000089290f);

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

// BT.709 expanded uniformly around D65 until red reaches Z = 0.
// Clipping gamut only; input and returned color are linear BT.709.
static const float3x3 BT709_TO_XYZ_EXPANDED_BT709_MAT = float3x3(
    0.9340213211f, 0.0328342863f, 0.0331443926f,
    0.0177500401f, 0.9491055673f, 0.0331443926f,
    0.0177500401f, 0.0328342863f, 0.9494156737f);

static const float3x3 XYZ_EXPANDED_BT709_TO_BT709_MAT = float3x3(
    1.0720077997f, -0.0358346779f, -0.0361731218f,
    -0.0193720358f, 1.0555451576f, -0.0361731218f,
    -0.0193720358f, -0.0358346779f, 1.0552067137f);

float3 ApplyXYZExpandedBT709GamutClip(float3 color, float strength = 1.f) {
  if (strength == 0.f) {
    return color;
  }

  const float3 expanded_color = mul(BT709_TO_XYZ_EXPANDED_BT709_MAT, color);
  const float3 clipped_color = mul(XYZ_EXPANDED_BT709_TO_BT709_MAT, max(expanded_color, 0.f));

  return lerp(color, clipped_color, strength);
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