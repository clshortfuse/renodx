#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri Jan  3 12:33:59 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = w1.xy * cb0[5].xy + cb0[5].zw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyz = cb0[6].xxx * r0.xyz * injectedData.fxBloom;
  r1.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  o0.xyz = r0.xyz * cb0[6].yzw + r1.xyz;
  if (injectedData.fxFilmGrain > 0.f) {
    o0.rgb = applyFilmGrain(o0.rgb, w1);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  o0.w = 1;
  return;
}
