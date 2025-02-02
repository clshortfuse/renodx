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
  float4 cb0[4];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[46].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1, -1) + cb1[46].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0, 0);
  r0.xyzw = t0.Load(r0.xyzw).xyzw;
  o0.w = r0.w;
  if (injectedData.fxNoise > 0.f) {
    r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
    r1.z = cb0[2].z;
    r2.xy = v1.xy * cb0[3].xy + cb0[3].zw;
    r1.xy = cb0[2].xy * r2.xy;
    r2.xy = cb1[48].xy * r2.xy;
    r0.w = t2.SampleBias(s1_s, r1.xyz, cb1[79].y).w;
    r0.w = r0.w * 2 + -1;
    r1.x = 1 + -abs(r0.w);
    r0.w = cmp(r0.w >= 0);
    r0.w = r0.w ? 1 : -1;
    r1.x = sqrt(r1.x);
    r1.x = 1 + -r1.x;
    r0.w = r1.x * r0.w;
    r0.xyz = r0.www * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r0.xyz;
    r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  }
  r2.z = 0;
  r1.xyzw = t1.SampleLevel(s0_s, r2.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.xyz + r1.xyz;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
