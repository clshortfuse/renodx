#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[121];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[120].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0,0);
  r0.xyzw = t0.Load(r0.xyz).xyzw;
  //r0.xyz = cb1[0].xxx * r0.xyz + float3(-0.217637643,-0.217637643,-0.217637643);
  //o0.xyz = r0.xyz * cb1[0].yyy + float3(0.217637643,0.217637643,0.217637643);
  o0.xyz = PostToneMapScale(r0.xyz);
  o0.w = 1;
  return;
}