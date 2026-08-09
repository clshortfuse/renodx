#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float2 v5 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v5.xy * cb0[6].xy + cb0[6].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.count2New >= 1.f && injectedData.isClamped != 0.f){
  r0 = saturate(r0);
  }
  r1.xy = v1.xy * cb0[6].xy + cb0[6].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if(injectedData.count2New >= 1.f && injectedData.isClamped != 0.f){
  r1 = saturate(r1);
  }
  r0.xyzw = max(r1.xyzw, r0.xyzw);
  r1.xy = v2.xy * cb0[6].xy + cb0[6].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if(injectedData.count2New >= 1.f && injectedData.isClamped != 0.f){
  r1 = saturate(r1);
  }
  r0.xyzw = max(r1.xyzw, r0.xyzw);
  r1.xy = v3.xy * cb0[6].xy + cb0[6].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if(injectedData.count2New >= 1.f && injectedData.isClamped != 0.f){
  r1 = saturate(r1);
  }
  r0.xyzw = max(r1.xyzw, r0.xyzw);
  r1.xy = v4.xy * cb0[6].xy + cb0[6].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if(injectedData.count2New >= 1.f && injectedData.isClamped != 0.f){
  r1 = saturate(r1);
  }
  o0.xyzw = max(r1.xyzw, r0.xyzw);
  return;
}