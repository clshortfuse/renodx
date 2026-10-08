#include "../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[29];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[28].y;
  r0.y = 0;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r1.w = saturate(r1.w);
  r0.xyz = handleUserLUT(r1.xyz, t1, s1_s, cb0[28].xyz, 0, true);
  r0.xyz = r0.xyz + -r1.xyz;
  r1.xyz = cb0[28].www * r0.xyz + r1.xyz;
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r1.xyz = GradeAndDisplayMap(r1.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r1.xyz = PostToneMapScale(r1.xyz);
  }
  o0.xyzw = r1.xyzw;
  return;
}