#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.zw).xyzw;
  r0.rgb = renodx::math::SignPow(r0.rgb, 2.f);
  if (injectedData.fxFilmGrainType == 0.f) {
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = r1.xyzw * cb0[6].zzzz + cb0[6].wwww;
  r0.xyzw = r1.xyzw * r0.xyzw;
  } else {
    r0.rgb = applyFilmGrain(r0.rgb, v1.zw);
  }
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = r0.w;
  return;
}