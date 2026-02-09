// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 11:53:21 2026
#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[11];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0.000000 != cb0[10].z);
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.w = r0.x ? 1 : r1.w;
  r0.xyzw = cb0[3].xyzw + r1.xyzw;
  r1.x = 255 * v1.w;
  r1.x = round(r1.x);
  r1.w = 0.00392156886 * r1.x;
  r1.xyz = v1.xyz;
  r0.xyzw = r1.xyzw * r0.xyzw;
  o0.xyz = r0.xyz * r0.www;
  o0.w = cb0[9].z * -r0.w + r0.w;
  if (UI_VISIBILITY < 0.5f) o0 = 0;
  return;
}