#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: TEXCOORD0,
    float4 v3: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cmp(v3.xy >= cb0[2].xy);
  r0.zw = cmp(cb0[2].zw >= v3.xy);
  r0.xyzw = r0.xyzw ? float4(1, 1, 1, 1) : 0;
  r0.xy = r0.xy * r0.zw;
  r0.x = r0.x * r0.y;
  r1.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r0.x = r1.x * r0.x;
  r1.xyzw = t1.Sample(s0_s, v2.xy).xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
