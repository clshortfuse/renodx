#include "./shared.h"

//UI 1/2 shaders

cbuffer _Globals : register(b0)
{
  float4 CONST_254 : packoffset(c0);
  float4 CONST_255 : packoffset(c1);
}

SamplerState sSam0_s : register(s0);
Texture2D<float4> sTex0 : register(t0);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sTex0.Sample(sSam0_s, v1.xy).xyzw;
  o0.xyzw = r0.xyzw * CONST_254.xyzw + CONST_255.xyzw;
  return;
}