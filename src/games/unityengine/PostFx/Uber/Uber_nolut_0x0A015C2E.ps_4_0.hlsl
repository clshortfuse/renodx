#include "../../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[6].xy + cb0[6].zw;
  r0.xyzw = t2.Sample(s1_s, r0.xy).xyzw;
  r0.x = r0.w * 2 + -1;
  r0.y = sign(r0.x);
  r0.x = 1 + -abs(r0.x);
  r0.x = sqrt(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.y * r0.x;
  r1.xyzw = t0.Sample(s2_s, v1.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  r0.yzw = r2.xyz * r1.xxx;
  if(injectedData.toneMapType == 0.f){
    r0.yzw = saturate(r0.yzw);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.yzw = applyUserNoTonemap(r0.yzw);
  }
  r0.xyz = applyDither(r0.yzw, r0.x * (1.0 / 510.0), 1);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}