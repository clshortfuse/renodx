#ifndef GEARS4_LUT_DOMAIN_HLSL_
#define GEARS4_LUT_DOMAIN_HLSL_

#include "./shared.h"

// Keep the first 21 nodes of the native 32^3 LUT at their original inputs.
// Above that node, extend the log domain with a continuous unit-slope join.
static const float GEARS4_LUT_DOMAIN_PIVOT = 20.f / 31.f;
static const float GEARS4_LUT_DOMAIN_MAX = 65504.f;
static const float GEARS4_LUT_DOMAIN_CURVATURE =
    ((log2(GEARS4_LUT_DOMAIN_MAX / 0.18f) / 14.f + 0.434017599f) - 1.f)
    / ((1.f - GEARS4_LUT_DOMAIN_PIVOT) * (1.f - GEARS4_LUT_DOMAIN_PIVOT));

float3 ExpandGearsLutCoordinates(float3 coordinates) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return coordinates;
  float3 distance = max(coordinates - GEARS4_LUT_DOMAIN_PIVOT, 0.f);
  return coordinates + GEARS4_LUT_DOMAIN_CURVATURE * distance * distance;
}

#endif  // GEARS4_LUT_DOMAIN_HLSL_
