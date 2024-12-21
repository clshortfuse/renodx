#include "./common.hlsl"
#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  float4 color = t0.Sample(s0, uv);

  color.rgb = renodx::math::PowSafe(color.rgb, 2.2f);
  color.rgb *= injectedData.toneMapUINits / 80.f;

  color.a = 1.f;
  return color;
}