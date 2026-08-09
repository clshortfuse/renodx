#include "../../common.hlsl"

Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[43];
}
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r0.xy = cb0[2].xy * r0.xy;
  r0.z = cb0[2].z;
  r0.x = t1.Sample(s0_s, r0.xyz).w;
  r0.x = r0.x * 2 + -1;
  r0.y = 1 + -abs(r0.x);
  r0.x = r0.x >= 0 ? 1 : -1;
  r0.y = sqrt(r0.y);
  r0.y = 1 + -r0.y;
  r0.x = r0.x * r0.y;
  r0.yz = cb1[42].xy * v1.xy;
  r0.yz = (uint2)r0.yz;
  r0.yz = (uint2)r0.yz;
  r1.xy = float2(-1,-1) + cb1[42].xy;
  r1.xy = cb0[3].zw * r1.xy;
  r0.yz = r0.yz * cb0[3].xy + r1.xy;
  r1.xy = (uint2)r0.yz;
  r1.zw = float2(0,0);
  r1.xyzw = t0.Load(r1.xyzw).xyzw;
  r1.w = saturate(r1.w);
  o0.w = r1.w;
  r0.xyz = applyDither(r1.xyz, r0.x * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}