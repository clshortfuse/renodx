#include "../../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[10].y;
  r0.y = 0;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r2.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  r0.xyz = handleUserLUT(r1.xyz, t1, s1_s, cb0[10].xyz);
  r0.xyz = r0.xyz + -r2.xyz;
  r0.xyz = cb0[10].www * r0.xyz + r2.xyz;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}