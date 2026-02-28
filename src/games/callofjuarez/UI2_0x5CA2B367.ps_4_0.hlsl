#include "./shared.h"

//UI 2/2 shaders

cbuffer _Globals : register(b0)
{
  float4 CONST : packoffset(c0);
}

SamplerState samTex0_s : register(s0);
Texture2D<float4> sTex0 : register(t0);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sTex0.Sample(samTex0_s, v1.xy).xyzw;
  o0.xyz = saturate(r0.xyz * CONST.www + CONST.xyz);
  o0.w = r0.w;
  o0.xyzw = renodx::color::srgb::Decode(o0.xyzw);
  return;
}