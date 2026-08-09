#include "../../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[3].xy + v1.xy;
  r0.xy = cb1[6].xy * r0.xy;
  r0.xy = float2(0.015625,0.015625) * r0.xy;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = float3(0.001953125,0.001953125,0.001953125) * r0.xyz;
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r1.xy = r1.xy + r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r1.x = r0.w * 2 + 1;
  r0.w = cb0[2].z * r0.w * injectedData.fxVignette;
  r0.w = -r0.w * 0.1 + 1;
  r1.x = saturate(cb0[2].w * r1.x + -1);
  r2.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.yzw = -r3.xyz + r2.xyz;
  r1.xyz = r1.xxx * r1.yzw + r3.xyz;
  o0.xyz = r1.xyz * r0.www + r0.xyz;
  o0.w = 1;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}