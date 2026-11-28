#include "./shared.h"
#include "./finite.hlsli"

cbuffer BackgroundConstants : register(b0) {
  float4 background_color : packoffset(c141);
}

float4 main() : SV_Target0 {
  float4 color = background_color;
  if (RENODX_PEAK_WHITE_NITS > 0.f) {
    // The native RTV is sRGB. Its FP16 clone needs the original hardware
    // write conversion explicitly, preserving HDR values above one.
    color.rgb = min(renodx::color::srgb::EncodeSafe(max(RogueFinite(color.rgb), 0.f)), ROGUE_FP16_MAX);
  }
  return color;
}
