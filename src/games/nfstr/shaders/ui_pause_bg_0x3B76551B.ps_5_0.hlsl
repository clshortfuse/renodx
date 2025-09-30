// ---- Created with 3Dmigoto v1.3.16 on Tue Aug 05 14:47:49 2025
#include "../shared.h"

cbuffer cb0 : register(b0)
{
  float4 cb0[10];
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
  if (!CUSTOM_EXTRA_UI) discard;

  o0.xyzw = cb0[9].xyzw;
  return;
}