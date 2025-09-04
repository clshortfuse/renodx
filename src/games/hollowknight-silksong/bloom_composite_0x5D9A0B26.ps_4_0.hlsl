#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:46:26 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw * CUSTOM_BLOOM;
  o0.xyzw = r1.xyzw + r0.xyzw;
  return;
}