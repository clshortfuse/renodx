#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.w = saturate(r0.w);
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r1.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r2.w = saturate(r1.w);
  if(injectedData.toneMapType == 0.f){
  r2.xyz = saturate(r1.xyz);
  }
  r1.x = saturate(cb0[2].x * r1.w);
  r2.xyzw = r1.xxxx * r2.xyzw;
  r1.x = 1 + -r1.x;
  o0.xyzw = r0.xyzw * r1.xxxx + r2.xyzw;
  return;
}