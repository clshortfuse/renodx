#include "./common.hlsl"

Texture2DArray<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[80];
}
cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = cb0[2].z;
  r1.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r0.xy = cb0[2].xy * r1.xy;
  r0.x = t2.SampleBias(s1_s, r0.xyz, cb1[79].y).w;
  r0.x = r0.x * 2 + -1;
  r0.y = 1 + -abs(r0.x);
  r0.x = (r0.x >= 0) ? 1 : -1;
  r0.y = sqrt(r0.y);
  r0.y = 1 + -r0.y;
  r0.x = r0.x * r0.y;
  r0.yz = cb0[4].xy * r1.xy;
  r1.xy = cb1[48].xy * r1.xy;
  r2.xy = (uint2)r0.yz;
  r2.zw = float2(0, 0);
  r2.xyzw = t0.Load(r2.xyzw).xyzw;
  o0.w = r2.w;
  if (injectedData.fxNoise > 0.f) {
    r0.gba = renodx::color::srgb::EncodeSafe(r2.rgb);
    r0.xyz = r0.xxx * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r0.yzw;
    r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  } else {
    r0.rgb = r2.rgb;
  }
  r1.z = 0;
  r1.xyzw = t1.SampleLevel(s0_s, r1.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.xyz + r1.xyz;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
