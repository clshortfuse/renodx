#include "./common.hlsl"

Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[49];
}
cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = 0;
  r1.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r0.xy = cb1[48].xy * r1.xy;
  r1.xy = cb0[4].xy * r1.xy;
  r1.xy = (uint2)r1.xy;
  r0.xyzw = t1.SampleLevel(s0_s, r0.xyz, 0).xyzw;
  r1.zw = float2(0, 0);
  r1.xyzw = t0.Load(r1.xyzw).xyzw;
  o0.xyz = r0.www * r1.xyz + r0.xyz;
  o0.w = r1.w;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
