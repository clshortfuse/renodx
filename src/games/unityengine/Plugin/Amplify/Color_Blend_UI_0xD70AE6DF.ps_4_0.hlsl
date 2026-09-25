#include "../../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[2].zw * v1.xy;
  r0.x = dot(float2(171,231), r0.xy);
  r0.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r0.xxx;
  r0.xyz = frac(r0.xyz);
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  if(CUSTOM_COUNT_OLD < CUSTOM_COUNT_NEW){
    r1.xyz = InvertToneMapScale(r1.xyz);
  }
  r1.xyz = cb0[6].yyy * r1.xyz;
  o0.w = r1.w;
  r0.xyz = handleUserLUT(r1.xyz, t1, s1_s, float3(1 / 1024, 1 / 32, 31), 1, true);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD <= CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}