#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
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
  r0.xyz = max(float3(0,0,0), r0.xyz);
  if(injectedData.isClamped != 0.f){
    r0.xyz = rolloffSdr(r0.xyz);
  }
  r0.xyz = min(cb0[7].zzz, r0.xyz);
  r0.w = max(r0.y, r0.z);
  o0.w = max(r0.x, r0.w);
  r0.xyz = -cb0[5].www + r0.xyz;
  o0.xyz = max(float3(0,0,0), r0.xyz);
  return;
}