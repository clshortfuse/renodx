#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float3 color = t0.Sample(s0, uv).rgb;

  // Simple passthrough: just scale to scRGB for HDR display.
  // scRGB 1.0 = 80 nits. We want SDR white (1.0 from game) = game_nits.
  // So multiply by (game_nits / 80).

  if (RENODX_TONE_MAP_TYPE == 0) {
    // Vanilla: pure passthrough, no changes
    return float4(color, 1.0f);
  }

  // Just scale SDR to HDR nits range
  // If game outputs 0-1 linear, this maps 1.0 to game_nits in scRGB
  color = max(0, color);
  color *= RENODX_DIFFUSE_WHITE_NITS / 80.f;

  return float4(color, 1.0f);
}
