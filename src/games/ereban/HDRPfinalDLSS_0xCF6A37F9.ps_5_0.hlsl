#include "./common.hlsl"

Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[80];
}
cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r0.zw = r0.xy * cb0[1].xy + cb0[1].zw;
  r0.z = t1.SampleBias(s1_s, r0.zw, cb1[79].y).w;
  r0.z = -0.5 + r0.z;
  r0.z = r0.z + r0.z;
  r1.xy = cb0[4].xy * r0.xy;
  r2.xy = cb1[48].xy * r0.xy;
  r1.xy = (uint2)r1.xy;
  r1.zw = float2(0, 0);
  r0.xyw = t0.Load(r1.xyzw).xyz;
  r1.xyz = r0.xyw * r0.zzz;
  r1.xyz = cb0[0].xxx * r1.xyz * injectedData.fxFilmGrain;
  r0.z = renodx::color::y::from::BT709(r0.rga);
  r0.b = renodx::math::SignSqrt(r0.b);
  r0.z = cb0[0].y * -r0.z + 1;
  if (injectedData.fxFilmGrainType == 0.f) {
    r0.xyz = r1.xyz * r0.zzz + r0.xyw;
  } else {
    r0.rgb = applyFilmGrain(r0.rga, v1);
  }
  r2.z = 0;
  r1.xyzw = t2.SampleLevel(s0_s, r2.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.xyz + r1.xyz;
  o0.rgb = PostToneMapScale(o0.rgb);
  r0.xy = cb1[46].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1, -1) + cb1[46].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0, 0);
  r0.x = t3.Load(r0.xyzw).x;
  r0.y = cmp(cb0[5].x == 1.000000);
  o0.w = r0.y ? r0.x : 1;
  return;
}
