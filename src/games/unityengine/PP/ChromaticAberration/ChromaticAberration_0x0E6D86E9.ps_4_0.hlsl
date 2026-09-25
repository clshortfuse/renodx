#include "../../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[7].xx * cb0[6].xy;
  r0.zw = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.zw + r0.zw;
  r0.xy = r0.xy * r0.zw;
  r0.z = dot(r0.zw, r0.zw);
  r0.xy = -r0.xy * r0.zz + v1.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  o0.y = r0.y;
  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.xzw = r0.xzw;
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