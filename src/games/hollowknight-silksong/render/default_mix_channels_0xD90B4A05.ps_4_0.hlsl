#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:46:27 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.x = 1;
  r0.xyzw = v1.xyzw * r0.xxxw;
  r1.xyz = r0.xyz * r0.www;
  r0.x = 0;
  r1.w = 1 + -cb0[3].y;
  r0.xyzw = -r1.xyzw + r0.xxxw;
  r0.xyzw = cb0[3].xxxx * r0.xyzw + r1.xyzw;
  r1.xyz = r0.www * float3(0, 0.200000003, 0.200000003) + -r0.xyz;
  r1.xyz = cb0[3].xxx * r1.xyz + r0.xyz;
  r1.w = r0.w;
  r0.xyzw = -r1.xyzw + r0.xyzw;
  o0.xyzw = cb0[3].yyyy * r0.xyzw + r1.xyzw;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}
