#include "./common.hlsl"

Texture2DArray<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[49];
}
cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r0.xy = cb1[48].xy * r0.xy;
  r0.z = 0;
  r0.xyzw = t1.SampleLevel(s0_s, r0.xyz, 0).xyzw;
  r1.xy = cb1[46].xy * v1.xy;
  r1.xy = (uint2)r1.xy;
  r1.xy = (uint2)r1.xy;
  r1.zw = float2(-1, -1) + cb1[46].xy;
  r1.zw = cb0[3].zw * r1.zw;
  r1.xy = r1.xy * cb0[3].xy + r1.zw;
  r1.xy = (uint2)r1.xy;
  r1.zw = float2(0, 0);
  r2.xyz = t0.Load(r1.xyww).xyz;
  r1.x = t2.Load(r1.xyzw).x;
  o0.xyz = r0.www * r2.xyz + r0.xyz;
  if (injectedData.fxFilmGrainType == 1.f) {
    o0.rgb = applyFilmGrain(o0.rgb, v1.xy);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  o0.w = cb0[5].x == 1.0 ? r1.x : 1;
  return;
}
