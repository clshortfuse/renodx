#include "../common.hlsli"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s2_s, w1.xy).xyzw;
  r0.x = cb0[7].x * r0.x + cb0[7].y;
  r0.x = 1 / r0.x;
  r0.y = 0.5;
  r0.xyzw = t2.Sample(s1_s, r0.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = r1.w * r0.w;
  r0.xyz = -r1.xyz + r0.xyz;
  o0.xyz = r0.www * r0.xyz + r1.xyz;
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