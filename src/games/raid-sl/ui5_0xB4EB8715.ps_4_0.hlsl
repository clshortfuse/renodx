#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan  7 08:54:07 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = cb0[3].xyzw + r0.xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;
  o0 *= CUSTOM_UI_ENABLED;
  return;
}