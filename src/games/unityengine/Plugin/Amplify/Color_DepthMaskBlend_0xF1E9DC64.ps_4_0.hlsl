#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s2_s, v3.zw).xyzw;
  r0.x = cb1[7].x * r0.x + cb1[7].y;
  r0.x = 1 / r0.x;
  r0.xyzw = t2.Sample(s3_s, r0.xx).xyzw;
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r1.xyz = cb0[6].yyy * r1.xyz;
  r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  r0.xyz = handleUserLUT(r0.xyz, t3, s1_s, float3(1 / 1024, 1 / 32, 31));
  r2.xyz = r0.xyz + -r1.xyz;
  r2.w = 0;
  o0.xyzw = r0.wwww * r2.xyzw + r1.xyzw;
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