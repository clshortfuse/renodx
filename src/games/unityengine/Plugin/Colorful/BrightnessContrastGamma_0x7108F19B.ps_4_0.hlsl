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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = cb0[3].xyz;
  r1.w = r0.w;
  r0.xyzw = r0.xyzw * cb0[2].xxxx + -r1.xyzw;
  r0.xyzw = r0.xyzw * cb0[2].yyyy + r1.xyzw;
  r0.w = saturate(r0.w);
  if(RENODX_TONE_MAP_TYPE == 0.f){
  r0.xyzw = saturate(r0.xyzw);
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = cb0[2].zzzz * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  } else {
    r0.xyzw = renodx::math::SignPow(r0.xyzw, cb0[2].z);
  }
  if(CUSTOM_GAMMA_SPACE != 0.f){
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz, CUSTOM_GAMMA_SPACE != 0.f);
  } else if(CUSTOM_GAMMA_SPACE != 0.f){
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}