#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t0.Sample(s0_s, v1.xy).xz;
  r0.xy = saturate(r0.xy);
  r0.y = 0.00999999978 * r0.y;
  o0.x = sqrt(r0.x);
  o0.z = sqrt(r0.y);
  o0.w = 0.00999999978 * cb0[6].y;
  o0.y = 0;
  return;
}