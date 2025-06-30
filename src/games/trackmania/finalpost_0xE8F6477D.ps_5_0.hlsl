#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Apr 11 23:28:54 2025

SamplerState SGbxClamp_Aniso_s : register(s0);
Texture2D<float4> TMapPrevAccumulator : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = TMapPrevAccumulator.Sample(SGbxClamp_Aniso_s, v1.xy).xyzw;
  o0.xyzw = float4(0.0500000007,0.0500000007,0.0500000007,0.0500000007) * r0.xyzw;

  //o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}