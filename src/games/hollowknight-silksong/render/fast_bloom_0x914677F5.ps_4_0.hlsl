#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 14:18:18 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    float2 v2: TEXCOORD2,
    float2 w2: TEXCOORD3,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[3].xyxy * float4(0.440510005, 0.108919993, 0.472079962, 0.494199961) + v1.xyxy;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = cb0[3].xyxy * float4(0.0894600004, -0.139719993, -0.375760019, -0.387800008) + v1.xyxy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = cb0[3].xyxy * float4(-0.109269999, 0.521640003, -0.533469975, -0.173179999) + v1.xyxy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = cb0[3].xyxy * float4(0.456049979, -0.41069001, 0.161559999, 0.632239997) + v1.xyxy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r0.xyzw = r0.xyzw * float4(0.125, 0.125, 0.125, 0.125) + -cb0[4].zzzz;
  r0.xyzw = max(float4(0, 0, 0, 0), r0.xyzw);
  o0.xyzw = cb0[4].wwww * r0.xyzw;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}
