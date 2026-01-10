#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan  7 06:23:08 2026
cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = cb0[2].xyzw * v1.xyzw;
  o0.w *= RENODX_VIGNETTE_STRENGTH;
  return;
}