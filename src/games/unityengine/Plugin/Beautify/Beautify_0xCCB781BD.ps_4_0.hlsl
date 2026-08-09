#include "../../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r0.w = max(0.f, r0.w);
  if(injectedData.toneMapType == 0.f){
  r0.xyz = max(float3(0,0,0), r0.xyz);
  }
  o0.xyzw = min(float4(1000000,1000000,1000000,1000000), r0.xyzw);
  return;
}