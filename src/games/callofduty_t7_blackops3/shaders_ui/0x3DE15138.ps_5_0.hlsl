// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 11:48:18 2025

#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  if (!CUSTOM_SHOW_HUD) discard;

  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.Sample(s1_s, v2.xy).w;
  r0.x = r0.x * 2 + -1;
  r1.x = ddx_coarse(r0.x);
  r1.y = ddy_coarse(r0.x);
  r0.y = dot(r1.xy, r1.xy);
  r0.y = sqrt(r0.y);
  r0.x = r0.x + r0.y;
  r0.y = r0.y + r0.y;
  r0.y = 1 / r0.y;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.w = r0.y * r0.x;
  r0.xyz = float3(1,1,1);
  o0.xyzw = v1.xyzw * r0.xyzw;
  return;
}