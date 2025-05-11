#include "./common.hlsl"

Texture2DArray<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[80];
}
cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r0.zw = r0.xy * cb0[1].xy + cb0[1].zw;
  r1.xy = cb1[48].xy * r0.xy;
  r0.x = t1.SampleBias(s1_s, r0.zw, cb1[79].y).w;
  r0.x = -0.5 + r0.x;
  r0.x = r0.x + r0.x;
  r0.yz = cb1[46].xy * v1.xy;
  r0.yz = (uint2)r0.yz;
  r0.yz = (uint2)r0.yz;
  r2.xy = float2(-1, -1) + cb1[46].xy;
  r2.xy = cb0[3].zw * r2.xy;
  r0.yz = r0.yz * cb0[3].xy + r2.xy;
  r2.xy = (uint2)r0.yz;
  r2.zw = float2(0, 0);
  r2.xyzw = t0.Load(r2.xyzw).xyzw;
  r0.xyz = r2.xyz * r0.xxx;
  r0.xyz = cb0[0].xxx * r0.xyz * injectedData.fxFilmGrain;
  r0.w = renodx::color::y::from::BT709(r2.rgb);
  r0.a = renodx::math::SignSqrt(r0.a);
  r0.w = cb0[0].y * -r0.w + 1;
  if (injectedData.fxFilmGrainType == 0.f) {
    r0.xyz = r0.xyz * r0.www + r2.xyz;
  } else {
    r0.rgb = applyFilmGrain(r2.rgb, v1);
  }
  o0.w = r2.w;
  r1.z = 0;
  r1.xyzw = t2.SampleLevel(s0_s, r1.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.xyz + r1.xyz;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
