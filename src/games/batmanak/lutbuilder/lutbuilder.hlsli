#include "../shared.h"

float3 ConditionalMax(float3 min_value, float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = max(min_value, color);
  } else {
    color = max(0.f, color);
  }
  return color;
}

float4 ConditionalMax(float4 min_value, float4 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = max(min_value, color);
  } else {
    color = max(0.f, color);
  }
  return color;
}

float3 ConditionalSaturate(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = saturate(color);
  } else {
    color = max(0.f, color);
  }
  return color;
}
