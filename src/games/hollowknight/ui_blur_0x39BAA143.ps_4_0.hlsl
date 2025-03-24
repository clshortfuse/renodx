#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar 22 17:32:27 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 + cb0[3].x;
  r0.yz = v1.xy / v1.ww;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r1.xyz = r1.xyz * r0.xxx;
  r0.xyzw = cb0[2].xyzw + -r1.xyzw;
  o0.xyzw = cb0[2].wwww * r0.xyzw + r1.xyzw;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}