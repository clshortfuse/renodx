#include "../shared.h"

Texture2DArray<float4> t0 : register(t0);
cbuffer cb1 : register(b1){
  float4 cb1[52];
}
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[51].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0,0);
  r0.xyz = t0.Load(r0.xyzw).xyz;
  r0.xyz = cb0[0].xxx * r0.xyz;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[0].yyy * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb0[0].y);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}