// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 11:48:19 2025

#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0)
{
  float4 cb0[11];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  if (!CUSTOM_SHOW_HUD) discard;

  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0 < cb0[10].x);
  if (r0.x != 0) {
    r0.x = ddx_coarse(v2.x);
    r0.x = -r0.x * cb0[10].x + v2.x;
    r0.z = ddy_coarse(v2.y);
    r0.y = -r0.z * cb0[10].x + v2.y;
    r0.x = t0.Sample(s1_s, r0.xy).w;
  } else {
    r0.x = 0;
  }
  r0.y = t0.Sample(s1_s, v2.xy).w;
  r0.z = 1 + -r0.y;
  r0.x = r0.x * r0.z + r0.y;
  r0.yzw = v1.xyz * r0.yyy;
  o0.xyz = r0.yzw / r0.xxx;
  o0.w = v1.w * r0.x;
  return;
}