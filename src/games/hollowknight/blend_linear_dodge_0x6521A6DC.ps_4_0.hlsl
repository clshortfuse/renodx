#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Mar 21 00:58:54 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
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

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.x = r0.w * v1.w + -0.00999999978;
  r1.x = cmp(r1.x < 0);
  if (r1.x != 0) discard;
  r1.xy = v3.xy / v3.ww;
  r1.xy = float2(1, 1) + r1.xy;
  r1.x = 0.5 * r1.x;
  r1.z = -r1.y * 0.5 + 1;
  r1.xyzw = t1.Sample(s1_s, r1.xz).xyzw;
  o0.xyz = r0.xyz * v1.xyz + r1.xyz;
  r0.x = v1.w * r0.w;
  o0.w = r0.x;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}
