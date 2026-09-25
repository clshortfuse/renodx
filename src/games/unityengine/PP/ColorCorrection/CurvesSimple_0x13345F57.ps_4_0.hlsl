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
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yw = float2(0.125,0.375);
  r1.xyzw = t0.Sample(s0_s, v1.xy).zxyw;
  o0.w = r1.w;
  float3 preCG = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(r1.yzx) : r1.yzx;
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(preCG);
  float3 lutInput = RENODX_TONE_MAP_TYPE <= 1.f ? preCG : sdrColor;
  if(RENODX_TONE_MAP_TYPE >= 2.f){
    r1.yzx = lutInput;
  }
  r0.xz = r1.yz;
  r2.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r2.xyz = float3(0,1,0) * r2.xyz;
  r0.xyz = r0.xyz * float3(1,0,0) + r2.xyz;
  r1.y = 0.625;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.xyz = r1.xyz * float3(0,0,1) + r0.xyz;
  if(RENODX_TONE_MAP_TYPE != 0.f){
    r0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = RestoreSaturationLoss(lutInput, r0.xyz);
    r0.xyz = renodx::tonemap::UpgradeToneMap(preCG, min(1.f, lutInput), r0.xyz, 1.f);
    r0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  r1.xyz = cb0[3].xyz * r0.xyz;
  r1.xz = r1.xx + r1.yz;
  r0.w = r1.y * r1.z;
  r1.x = r0.z * cb0[3].z + r1.x;
  r0.w = renodx::math::SignSqrt(r0.w);
  r0.w = dot(cb0[3].ww, r0.ww);
  r0.w = r1.x + r0.w;
  r0.xyz = r0.xyz + -r0.www;
  o0.xyz = cb0[6].xxx * r0.xyz + r0.www;
  if(CUSTOM_GAMMA_SPACE != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  o0.xyz = lerp(preCG, o0.xyz, CUSTOM_USER_LUT_STRENGTH);
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