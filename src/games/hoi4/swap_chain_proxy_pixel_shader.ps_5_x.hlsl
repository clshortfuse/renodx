#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float3 color = t0.Sample(s0, uv).rgb;
  color = renodx::color::gamma::Decode(color, 2.2f);
  color *= 203.f / 80.f;
  return float4(color, 1.f);
}