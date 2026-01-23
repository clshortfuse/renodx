#ifndef SRC_COMMON_HLSLI
#define SRC_COMMON_HLSLI

#include "./shared.h"

float3 ScaleScene(float3 color) {
  if (RENODX_DIFFUSE_WHITE_NITS != RENODX_GRAPHICS_WHITE_NITS) {
    color = renodx::color::gamma::DecodeSafe(color);
    color *= (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);
    color = renodx::color::gamma::EncodeSafe(color);
  }
  return color;
}

void ScaleScene(inout float r, inout float g, inout float b) {
  float3 color = ScaleScene(float3(r, g, b));
  r = color.r, g = color.g, b = color.b;
  return;
}

float3 ScaleSceneInverse(float3 color) {
  if (RENODX_DIFFUSE_WHITE_NITS != RENODX_GRAPHICS_WHITE_NITS) {
    color = renodx::color::gamma::DecodeSafe(color);
    color /= (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);
    color = renodx::color::gamma::EncodeSafe(color);
  }
  return color;
}

float3 LinearizeAndClampMaxChannel(float3 color) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    color = renodx::color::gamma::DecodeSafe(color);
    color = renodx::color::bt2020::from::BT709(color);
    color = max(0, color);

    if (RENODX_TONE_MAP_TYPE != 1.f) {
      float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      float max_channel = max(max(max(color.r, color.g), color.b), peak_ratio);
      color *= peak_ratio / max_channel;  // Clamp ringing
    }
    color = renodx::color::bt709::from::BT2020(color);

    color = renodx::color::gamma::EncodeSafe(color);
  } else {
    color = saturate(color);
  }
  return color;
}

#endif  // SRC_COMMON_HLSLI