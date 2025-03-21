#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Mar 20 19:55:36 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[5];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyz = -r0.xyz * v1.xyz + cb0[3].xyz;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r0.xyz = cb0[4].xxx * r1.xyz + r0.xyz;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}