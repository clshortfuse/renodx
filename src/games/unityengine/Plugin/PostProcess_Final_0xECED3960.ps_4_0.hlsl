#include "../common.hlsli"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[21];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s1_s, v2.xy).xyzw;
  r0.xyz = float3(1.5,1.5,1.5) * r0.xyz;
  r0.xyz = cb0[6].xxx * r0.xyz * CUSTOM_BLOOM;
  r0.xyz = r0.xyz * r0.xyz;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  if(RENODX_TONE_MAP_TYPE == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r0.xyz = r1.xyz * r1.xyz + r0.xyz;
  r0.xyz = renodx::math::SignPow(r1.xyz, 2.f) + r0.xyz;
  r1.xyzw = t1.Sample(s2_s, w1.xy).xyzw;
  r1.xyz = float3(1.5,1.5,1.5) * r1.xyz;
  r1.xyz = cb0[13].zzz * r1.xyz;
  r0.xyz = r1.xyz * r1.xyz + r0.xyz;
  r0.xyz = renodx::math::SignPow(r1.xyz, 2.f) + r0.xyz;
  r0.xyz = sqrt(r0.xyz);
  r0.xyz = renodx::math::SignSqrt(r0.xyz);
  r1.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r1.xyz = -r1.xyz * cb0[20].yyy * CUSTOM_VIGNETTE + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[20].xxx * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  if(CUSTOM_GAMMA_SPACE != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz, CUSTOM_GAMMA_SPACE != 0.f);
  } else if(CUSTOM_GAMMA_SPACE != 0.f) {
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  o0.w = 1;
  return;
}