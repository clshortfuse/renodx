#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Wed Sep 10 00:31:35 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    float2 w2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = v1.wxyz * r0.wxyz;
  r1.xyzw = t1.Sample(s1_s, w2.xy).xyzw;
  r0.xyzw = r1.wxyz * r0.xyzw;
  o0.xyz = r0.yzw * r0.xxx;
  o0.w = r0.x;

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}
