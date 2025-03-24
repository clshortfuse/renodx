#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar 22 17:32:27 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;
  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xy = float2(0.390625,1.984375) * r0.ww;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.x = r1.w * 1.15625 + -r0.x;
  r0.y = r1.w * 1.15625 + r0.y;
  o0.z = -1.06861997 + r0.y;
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.x = -r2.w * 0.8125 + r0.x;
  r0.y = 1.59375 * r2.w;
  r0.y = r1.w * 1.15625 + r0.y;
  o0.xy = float2(-0.872539997,0.531369984) + r0.yx;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}