#include "OnCopy.hlsl"

SamplerState sInputS_s : register(s0);
Texture2D<float4> sInputT : register(t0);


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  o0.xyzw = sInputT.Sample(sInputS_s, v1.xy).xyzw;
  
  OnCopy(o0.rgb);
  
  return;
}