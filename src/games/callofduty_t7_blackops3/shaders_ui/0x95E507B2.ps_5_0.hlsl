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
  
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;
  return;
}