#include "../common.hlsli"

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
  if(RENODX_TONE_MAP_TYPE == 0.f){
  r1.xyz = log2(r0.xyz);
  r1.xyz = cb0[3].xxx * r1.xyz;
  r0.xyz = exp2(r1.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb0[3].x);
  }
  r1.x = dot(r0.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r1.x = min(1, r1.x);
  r1.x = r1.x * -cb0[3].y + cb0[3].y;
  o0.xyzw = r1.xxxx + r0.xyzw;
  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
  o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
  o0.xyz = PostToneMapScale(o0.xyz, true);
  }
  return;
}