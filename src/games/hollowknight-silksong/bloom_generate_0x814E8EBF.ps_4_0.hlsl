#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:46:26 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 0.020500, 0, 0, 0},
                              { 0.085500, 0, 0, 0},
                              { 0.232000, 0, 0, 0},
                              { 0.324000, 0, 0, 1.000000},
                              { 0.232000, 0, 0, 0},
                              { 0.085500, 0, 0, 0},
                              { 0.020500, 0, 0, 0} };
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -v2.xy * float2(3,3) + v1.xy;
  r1.xyzw = float4(0,0,0,0);
  r0.zw = r0.xy;
  r2.x = 0;
  while (true) {
    r2.y = cmp((int)r2.x >= 7);
    if (r2.y != 0) break;
    r3.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
    r1.xyzw = r3.xyzw * icb[r2.x+0].xxxw + r1.xyzw;
    r0.zw = v2.xy + r0.zw;
    r2.x = (int)r2.x + 1;
  }
  o0.xyzw = r1.xyzw;

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}