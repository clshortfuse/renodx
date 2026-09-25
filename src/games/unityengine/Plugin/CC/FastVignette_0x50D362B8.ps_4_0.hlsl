#include "../../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[2].xy + v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.y = cb0[2].w + cb0[2].z;
  r0.x = r0.x * r0.y + -0.8;
  r0.y = cb0[2].z * 0.799 + -0.8;
  r0.y = 1 / r0.y;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.xyz = r1.xyz * r0.xxx;
  o0.w = r1.w;
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