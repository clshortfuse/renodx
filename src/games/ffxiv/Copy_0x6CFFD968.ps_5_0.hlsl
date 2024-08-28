#include "OnCopy.hlsl"

SamplerState sSamplerS_s : register(s0);
Texture2D<float4> sSamplerT : register(t0);


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  o0.xyzw = sSamplerT.Sample(sSamplerS_s, v1.xy).xyzw;

  OnCopy(o0.rgb);

  return;
}