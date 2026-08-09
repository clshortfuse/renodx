#include "../../tonemap.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t3.Sample(s2_s, v2.xy).xyzw;
  r1.xyz = float3(0.6,0.6,0.6) * r0.xyz;
  r2.xyzw = t2.Sample(s1_s, v2.xy).xyzw;
  r1.xyz = r2.xyz * float3(0.5,0.5,0.5) + r1.xyz;
  r0.xyz = r0.xyz * float3(0.8,0.8,0.8) + r2.xyz;
  r2.xyzw = t4.Sample(s3_s, v2.xy).xyzw;
  r1.xyz = r2.xyz * float3(0.6,0.6,0.6) + r1.xyz;
  r0.xyz = r2.xyz * float3(0.6,0.6,0.6) + r0.xyz;
  r2.xyzw = t5.Sample(s4_s, v2.xy).xyzw;
  r1.xyz = r2.xyz * float3(0.45,0.45,0.45) + r1.xyz;
  r0.xyz = r2.xyz * float3(0.45,0.45,0.45) + r0.xyz;
  r2.xyzw = t6.Sample(s5_s, v2.xy).xyzw;
  r1.xyz = r2.xyz * float3(0.35,0.35,0.35) + r1.xyz;
  r0.xyz = r2.xyz * float3(0.35,0.35,0.35) + r0.xyz;
  r2.xyzw = t7.Sample(s6_s, v2.xy).xyzw;
  r1.xyz = r2.xyz * float3(0.23,0.23,0.23) + r1.xyz;
  r0.xyz = r2.xyz * float3(0.23,0.23,0.23) + r0.xyz;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = r1.xyz * float3(0.45454545,0.45454545,0.45454545) + -r2.xyz;
  r1.xyz = cb0[3].yyy * r1.xyz * injectedData.fxBloom + r2.xyz;
  o0.w = r2.w;
  r0.xyz = r0.xyz * float3(0.3125,0.3125,0.3125) + -r1.xyz;
  r2.xyzw = t1.Sample(s7_s, v1.xy).xyzw;
  r2.xyz = saturate(cb0[3].zzz * r2.xyz);
  o0.xyz = r2.xyz * r0.xyz + r1.xyz;
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