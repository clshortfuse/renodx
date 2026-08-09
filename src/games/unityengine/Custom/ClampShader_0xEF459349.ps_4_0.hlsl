#include "../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  o0.xyzw = min(cb0[6].xxxx, r0.xyzw);
  } else {
    o0.xyz = renodx::color::bt709::clamp::BT2020(r0.xyz);
    o0.w = saturate(r0.w);
  }
  return;
}