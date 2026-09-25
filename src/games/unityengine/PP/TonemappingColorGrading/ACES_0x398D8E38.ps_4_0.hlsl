#include "../../common.hlsli"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = cb0[9].y;
  r1.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  o0.w = r1.w;
  r2.xyz = Bt709AcesTonemap(r1.xyz, cb0[4].y);
  r1.xyz = Bt709AcesTonemap(r1.xyz, cb0[4].x);
  r3.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = lerp(r1.xyz, r2.xyz, r3.x);
  r4.xyz = handleUserLUT(r1.xyz, t3, s3_s, cb0[9].xyz, 1, true);
  r3.yzw = lerp(r1.xyz, r4.xyz, cb0[9].w);
  r2.xyz = handleUserLUT(r1.xyz, t2, s2_s, cb0[8].xyz, 1, true);
  r0.xyz = lerp(r1.xyz, r2.xyz, cb0[8].w);
  r0.xyz = lerp(r0.xyz, r3.yzw, r3.x);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}