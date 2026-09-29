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

#endif  // SRC_GAMES_CONTROL_RESONANT_COMMON_HLSLI_