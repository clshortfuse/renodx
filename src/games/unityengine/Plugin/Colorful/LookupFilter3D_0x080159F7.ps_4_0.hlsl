#include "../../tonemap.hlsl"

Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[6].x * cb0[3].w;
  r0.x = r0.x / cb1[6].y;
  r0.y = cb0[3].w;
  r0.zw = v1.xy * r0.xy;
  r0.zw = floor(r0.zw);
  r0.xy = r0.zw / r0.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.w = saturate(r0.w);
  /*r1.xyz = r1.xyz * cb0[3].xxx + cb0[3].yyy;
  r1.xyzw = t1.Sample(s1_s, r1.xyz).xyzw;*/
  r1.xyz = handleUserLUT(r0.xyz, t1, s1_s, 0.5 / cb0[3].y, 0, true);
  r1.xyz = r1.xyz + -r0.xyz;
  r1.w = 0;
  r0.xyzw = cb0[3].zzzz * r1.xyzw + r0.xyzw;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}