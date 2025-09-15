// ---- Created with 3Dmigoto v1.3.16 on Tue Aug 05 13:09:08 2025
#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[12];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float4 v2 : COLOR1,
  float2 v3 : TEXCOORD0,
  float2 w3 : TEXCOORD1,
  float2 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_EXTRA_UI) discard;

  r0.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  o0.xyzw = r0.xyzw * cb0[10].xyzw + cb0[11].xyzw;
  return;
}