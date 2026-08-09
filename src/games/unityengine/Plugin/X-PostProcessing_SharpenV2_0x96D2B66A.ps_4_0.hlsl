#include "../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[31];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1,1) / cb0[22].xy;
  r0.zw = -r0.xy * float2(1.5,1.5) + v1.xy;
  r1.xy = float2(1.5,1.5) * r0.xy;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.zw = -r1.yx;
  r2.xyzw = v1.xyxy + r1.xzxy;
  r1.xy = v1.xy + r1.wy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r2.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = -r0.xyzw * float4(0.25,0.25,0.25,0.25) + r1.xyzw;
  o0.xyzw = r0.xyzw * cb0[30].xxxx + r1.xyzw;
  o0.w = saturate(o0.w);
  if(injectedData.toneMapType != 0.f){
  o0.xyz = renodx::color::bt709::clamp::AP1(o0.xyz);
  }
  return;
}