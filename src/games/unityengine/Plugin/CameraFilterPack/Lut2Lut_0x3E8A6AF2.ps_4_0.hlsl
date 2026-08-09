#include "../../tonemap.hlsl"

Texture3D<float4> t2 : register(t2);
Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r0.w;
  r1.xyz = handleUserLUT(r0.xyz, t2, s2_s, 0, 3);
  r2.xyz = handleUserLUT(r0.xyz, t1, s1_s, 0, 3);
  r0.xyz = renodx::math::SignSqrt(r0.xyz);
  r1.xyz = -r2.xyz + r1.xyz;
  r1.xyz = cb0[2].xxx * r1.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[2].yyy * r1.xyz + r0.xyz;
  r0.xyz = renodx::math::SignPow(r0.xyz, 2.f);
  if(injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)){
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
  r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}