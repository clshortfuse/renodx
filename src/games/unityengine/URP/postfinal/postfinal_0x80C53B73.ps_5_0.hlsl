#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[140];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[139].xy + cb0[139].zw;
  r0.x = t1.SampleBias(s1_s, r0.xy, cb0[4].x).w;
  r0.x = r0.x * 2 + -1;
  r0.y = 1 + -abs(r0.x);
  r0.x = r0.x >= 0 ? 1 : -1;
  r0.y = sqrt(r0.y);
  r0.y = 1 + -r0.y;
  r0.x = r0.x * r0.y;
  r0.yzw = t0.SampleBias(s0_s, v1.xy, cb0[4].x).xyz;
  r0.xyz = applyDither(r0.yzw, r0.x * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}