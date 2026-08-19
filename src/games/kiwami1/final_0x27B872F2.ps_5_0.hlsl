// ---- Created with 3Dmigoto v1.3.16 on Mon Sep 23 18:14:57 2024
// The game's vanilla shader, that also does gamma, we'll remove the pow to "break" the ingame sliders

#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb9 : register(b9)
{
  float4 cb9[1];
}

cbuffer cb13 : register(b13)
{
  float4 cb13[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyz = r0.xyz * cb9[0].xxx + cb9[0].yyy;
  o0.w = r0.w;
  
  //r0.xyz = log2(r0.xyz);
  //r0.xyz = cb9[0].zzz * r0.xyz;
  //r0.xyz = exp2(r0.xyz);
  //r0.rgb = renodx::math::SafePow(r0.rgb, 2.2f); // Game wants to be in gamma
  
  r1.xyz = r0.xyz * float3(0.858823538,0.858823538,0.858823538) + float3(0.0627451017,0.0627451017,0.0627451017);
  r0.w = 8 & asint(cb13[0].x);
  o0.xyz = r0.www ? r1.xyz : r0.xyz;
  
  return;
}