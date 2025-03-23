#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-1,-1,-1,-1) + cb0[5].xyzw;
  r0.xyzw = cb0[5].wwww * r0.xyzw + float4(1,1,1,1);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * r0.xyzw;
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = r0.w;
  return;
}