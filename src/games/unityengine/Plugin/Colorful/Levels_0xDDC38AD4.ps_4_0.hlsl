#include "../../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
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
  r0.xyzw = -cb0[3].xyzw + r0.xyzw;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = max(float3(0,0,0), r0.xyz);
  }
  r0.w = max(0.f, r0.w);
  r1.xyzw = cb0[4].xyzw + -cb0[3].xyzw;
  r0.xyzw = r0.xyzw / r1.xyzw;
  r1.xyzw = float4(1,1,1,1) / cb0[5].xyzw;
  if(RENODX_TONE_MAP_TYPE == 0.f){
    r0.xyzw = min(float4(1,1,1,1), r0.xyzw);
    r0.xyzw = log2(r0.xyzw);
    r0.xyzw = r1.xyzw * r0.xyzw;
    r0.xyzw = exp2(r0.xyzw);
  } else {
    r0.x = renodx::math::SignPow(r0.x, r1.x);
    r0.y = renodx::math::SignPow(r0.y, r1.y);
    r0.x = renodx::math::SignPow(r0.x, r1.x);
    r0.w = pow(r0.w, r1.w);
  }
  r1.xyzw = cb0[7].xyzw + -cb0[6].xyzw;
  o0.xyzw = r0.xyzw * r1.xyzw + cb0[6].xyzw;
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
  o0.w = saturate(o0.w);
  return;
}