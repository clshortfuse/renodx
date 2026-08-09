#include "../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TESSFACTOR1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.zy).xyzw;
  r0.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.25,0.25,0.25,0.25) + r0.xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xw).xyzw;
  r0.xyzw = r1.xyzw * float4(0.25,0.25,0.25,0.25) + r0.xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.zw).xyzw;
  r0.xyzw = r1.xyzw * float4(0.25,0.25,0.25,0.25) + r0.xyzw;
  r0.xyzw = cb0[4].zzzz * r0.xyzw * injectedData.fxBloom;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r2.x = r1.x + r1.y;
  r2.x = r2.x + r1.z;
  r2.x = -r2.x * 0.333333313 + 1;
  r2.x = max(0.219999999, r2.x);
  o0.xyzw = r0.xyzw * r2.xxxx + r1.xyzw;
  o0.w = saturate(o0.w);
  if(injectedData.toneMapType == 0.f){
    o0.xyz = saturate(o0.xyz);
  }
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz, true);
  } else {
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}