#include "../../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
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

  r0.xy = v1.xy * cb0[5].xy + cb0[5].zw;
  r0.xyzw = t2.Sample(s1_s, r0.xy).xyzw;
  r1.xyzw = t0.Sample(s2_s, v1.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  r1.xyz = r2.xyz * r1.xxx;
  if (injectedData.toneMapType == 0.f) {
    r1.xyz = saturate(r1.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r1.xyz = applyUserNoTonemap(r1.xyz);
  }
  if (injectedData.fxFilmGrainType == 0.f) {
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = cb0[4].yyy * r0.xyz * injectedData.fxFilmGrain;
  r0.w = renodx::color::y::from::BT709(saturate(r1.xyz));
  r0.w = sqrt(r0.w);
  r0.w = cb0[4].x * -r0.w + 1;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  } else {
    r0.xyz = applyFilmGrain(r1.xyz, w1);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}