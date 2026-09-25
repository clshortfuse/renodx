#include "../../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
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

  o0.w = 1;
  r0.xyz = float3(1,1,1) + -cb0[3].xyz;
  r1.xyz = float3(0,0,-1) * r0.zzz;
  r0.xyzw = float4(0,-1,0,-1) * r0.xxyy;
  r2.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r2.z = 1;
  r1.xyz = cb0[3].zzz * r2.xyz + -r1.xyz;
  r1.xy = r1.xy / r1.zz;
  r1.xy = float2(1,1) + r1.xy;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  o0.z = r1.z;
  r1.xyz = cb0[3].xxx * r2.xyz + -r0.xxy;
  r0.xyz = cb0[3].yyy * r2.xyz + -r0.zzw;
  r0.xy = r0.xy / r0.zz;
  r0.xy = float2(1,1) + r0.xy;
  r0.xy = float2(0.5,0.5) * r0.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  o0.y = r0.y;
  r0.xy = r1.xy / r1.zz;
  r0.xy = float2(1,1) + r0.xy;
  r0.xy = float2(0.5,0.5) * r0.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  o0.x = r0.x;
  if(CUSTOM_GAMMA_SPACE != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
  o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
  o0.xyz = PostToneMapScale(o0.xyz, CUSTOM_GAMMA_SPACE != 0.f);
  } else if(CUSTOM_GAMMA_SPACE != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}