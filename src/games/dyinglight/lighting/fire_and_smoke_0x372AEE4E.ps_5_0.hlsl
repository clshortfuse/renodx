#include "./lighting.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:44:16 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[9];
}

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float2 v3: TEXCOORD2,
    out float4 o0: SV_TARGET0,
    out float4 o1: SV_TARGET1) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb2[7].xy + cb2[7].zw;
  r0.x = t0.SampleLevel(s1_s, r0.xy, 0).x;
  r0.xy = r0.xx * cb2[8].xy + cb2[8].zw;
  r0.x = r0.x / -r0.y;

  r0.x = saturate(abs(r0.x) * cb0[0].y + -v2.w);  //   r0.x = saturate(abs(r0.x) * cb0[0].y + -v2.w);

  r0.x = v1.w * r0.x;
  r1.xyzw = t1.Sample(s0_s, v3.xy).xyzw;
  r0.x = r1.w * r0.x;
  o0.xyz = r1.xyz * v1.xyz + v2.xyz;
  o0.w = r0.x;
  o1.xyzw = float4(0, 0, 0, 1) * r0.xxxx;

  o0.rgb = ApplyCustomHueShiftFire(o0.rgb);
  return;
}
