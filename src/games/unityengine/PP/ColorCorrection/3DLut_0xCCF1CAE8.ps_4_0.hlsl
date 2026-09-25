#include "../../common.hlsli"

Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r0.w;
  //r0.xyz = r0.xyz * cb0[6].xxx + cb0[6].yyy;
  //r0.xyzw = t1.Sample(s1_s, r0.xyz).xyzw;
  if(CUSTOM_GAMMA_SPACE != 0.f){
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  r0.xyz = handleUserLUT(r0.xyz, t1, s1_s, 0.5 / cb0[6].y, CUSTOM_GAMMA_SPACE != 0.f ? 0 : 2, true);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz, CUSTOM_GAMMA_SPACE != 0.f);
  } else if(CUSTOM_GAMMA_SPACE != 0.f){
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}