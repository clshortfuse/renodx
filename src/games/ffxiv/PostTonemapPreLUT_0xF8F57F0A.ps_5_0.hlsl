#include "./shared.h"

SamplerState sInputS_s : register(s0);
Texture2D<float4> sInputT : register(t0);


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 outColor : SV_TARGET0)
{
  float4 r0;

  r0.xyzw = sInputT.Sample(sInputS_s, v1.xy).xyzw;  
  outColor.xyzw = injectedData.toneMapType == 0 ? saturate(r0.xyzw) : max(r0.xyzw, 0);
  
  return;
}