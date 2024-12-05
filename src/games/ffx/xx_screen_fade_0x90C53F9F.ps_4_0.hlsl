#include "./common.hlsl"
#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 globalColorMask : packoffset(c0) = {1,1,1,1};
  float4 globalColorMaskN : packoffset(c1) = {0,0,0,0};
  float4 ScreenFadeColor : packoffset(c2);
}



// 3Dmigoto declarations
#define cmp -


void main(
  out float4 o0 : SV_TARGET0)
{
  o0.xyzw = ScreenFadeColor.xyzw;
  o0.xyz *= injectedData.toneMapGameNits / injectedData.toneMapPeakNits;
  // o0.w = saturate(o0.w);
  return;
}