#include "../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[13];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s1_s, v2.xy).xyzw;
  r0.xyz = saturate(r0.xyz);
  r0.xyz = float3(1,1,1) + -r0.xyz;
  r1.xyzw = t3.Sample(s2_s, v2.xy).xyzw;
  r1.xyz = saturate(r1.xyz);
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r0.xyz = -r0.xyz * r1.xyz + float3(1,1,1);
  r0.xyz = saturate(cb0[5].zzz * r0.xyz);
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  if (injectedData.toneMapType == 0.f) {
  r0.xyz = float3(1,1,1) + -r0.xyz;
  r1.xyz = saturate(r1.xyz);
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyzw = t1.Sample(s3_s, w1.xy).xyzw;
  r1.xyz = saturate(cb0[12].zzz * r1.xyz);
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r0.xyz = -r0.xyz * r1.xyz + float3(1,1,1);
  } else {
    r0.xyz = r1.xyz + (r0.xyz / (1 + r1.xyz)) + (saturate(cb0[12].zzz * t1.Sample(s3_s, w1.xy).xyz) / (1 + r1.xyz + (r0.xyz / (1 + r1.xyz))));
  }
  if (injectedData.gammaSpace != 0.f) {
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  } else if (injectedData.gammaSpace != 0.f) {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}