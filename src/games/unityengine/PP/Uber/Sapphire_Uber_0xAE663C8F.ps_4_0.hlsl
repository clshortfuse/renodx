#include "../../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[26];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[22].xy + cb0[22].zw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.x = r0.w * 2 + -1;
  float sign1 = sign(r0.x);
  r0.x = 1 + -abs(r0.x);
  r0.x = sqrt(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = sign1 * r0.x;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.w = saturate(r1.w);
  r0.yzw = applyUserTonemapSapphire(r1.xyz);
  r1.xyz = applyDither(r0.yzw, r0.x * (1.0 / 765.0), 1);
  r1.xyz = PostToneMapScale(r1.xyz);
  o0.xyzw = r1.xyzw;
  return;
}