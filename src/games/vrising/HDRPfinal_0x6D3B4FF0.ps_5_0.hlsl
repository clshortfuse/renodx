#include "./common.hlsl"

Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
cbuffer cb1 : register(b1) {
  float4 cb1[49];
}
cbuffer cb0 : register(b0) {
  float4 cb0[9];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[48].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1, -1) + cb1[48].xy;
  r0.zw = cb0[6].zw * r0.zw;
  r0.xy = r0.xy * cb0[6].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0, 0);
  r1.xyz = t0.Load(r0.xyww).xyz;
  r0.x = t1.Load(r0.xyzw).x;
  if (injectedData.fxFilmGrain > 0.f) {
    r1.rgb = applyFilmGrain(r1.rgb, v1.xy, injectedData.fxFilmGrainType != 0.f);
  }
  o0.rgb = PostToneMapScale(r1.rgb);
  o0.w = cb0[8].x == 1.0 ? r0.x : 1;
  return;
}
