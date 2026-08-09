#include "../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v2.xy * cb0[5].xy + cb0[5].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.xyz = cb0[6].xxx * r0.xyz;
  r0.xyz = r1.xyz * float3(-0.3,-0.3,-0.3) + r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  } else {
    r0.xyz = renodx::color::bt709::clamp::AP1(r0.xyz);
  }
  r0.w = 1;
  r1.xyzw = cb0[7].xyzw + -r0.xyzw;
  o0.xyzw = v1.yyyy * r1.xyzw + r0.xyzw;
  return;
}