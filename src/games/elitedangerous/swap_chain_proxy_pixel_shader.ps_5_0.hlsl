#include "./common.hlsli"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float4 color = t0.Sample(s0, uv);
  color.rgb = FinalizeOutput(color.rgb);
  color.a = saturate(color.a);
  return color;
}
