// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 11:48:19 2025

#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  if (!CUSTOM_SHOW_HUD) discard;

  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = ddy_coarse(v2.y);
  r0.y = v2.y + -r0.x;
  r0.x = v2.y + r0.x;
  r0.x = -1 + r0.x;
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.z = fDest.y;
  r0.w = 1 / r0.z;
  r0.y = r0.y + r0.w;
  r0.xy = saturate(r0.xy * r0.zz);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = -r0.z * r0.y + 1;
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.x = max(r0.x, r0.y);
  r0.x = 0.5 * r0.x;
  r0.x = sqrt(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r1.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r1.w = r1.w * r0.x;
  o0.xyzw = v1.xyzw * r1.xyzw;
  return;
}