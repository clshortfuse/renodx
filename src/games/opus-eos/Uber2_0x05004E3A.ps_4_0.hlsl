#include "./common.hlsl"

// 2D Scenes
// ---- Created with 3Dmigoto v1.4.1 on Thu Apr 17 22:54:10 2025
Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[37];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, w1.xy).xyzw;

  r1.rgb = renodx::color::srgb::DecodeSafe(r0.xyz);

  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r2.xxx * r1.xyz;
  r1.xyzw = float4(-1, -1, 1, 1) * cb0[32].xyxy;
  r2.x = 0.5 * cb0[34].x;
  r3.xyzw = saturate(r1.xyzy * r2.xxxx + v1.xyxy);
  r1.xyzw = saturate(r1.xwzw * r2.xxxx + v1.xyxy);
  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r2.xyzw = cb0[26].xxxx * r3.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r1.xyzw = t3.Sample(s3_s, r1.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = cb0[34].yyyy * r1.xyzw;
  r2.xyzw = float4(0.25, 0.25, 0.25, 1) * r1.xyzw;
  r1.xyzw = float4(0.25, 0.25, 0.25, 0.25) * r1.xyzw;
  r3.xyz = cb0[35].xyz * r2.xyz;
  r3.w = 0.25 * r2.w;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz;
  r2.w = 0;
  r0.xyzw = r2.xyzw * r1.xyzw + r0.xyzw;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = Vanilla(r0.rgb, t5, s5_s, cb0[36].xyz, v1.xy, t0, s0_s, cb0[30]);
  } else {
    o0.rgb = ApplyUserTonemap(r0.rgb, t5, s5_s, cb0[36].xyz);
  }

  o0.w = 1;
  return;
}
