#include "../../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  /*r0.xyz = saturate(r0.xyz);
  r0.xyz = r0.xyz * float3(0.0302734375,0.96875,31) + float3(0.00048828125,0.015625,0.5);
  r0.z = floor(r0.z);
  r0.xy = r0.zz * float2(0.03125,0) + r0.xy;
  o0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;*/
  o0.w = r0.w;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.xyz = handleUserLUT(r0.xyz, t1, s1_s, float3(1 / 1024, 1 / 32, 31));
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
  return;
}