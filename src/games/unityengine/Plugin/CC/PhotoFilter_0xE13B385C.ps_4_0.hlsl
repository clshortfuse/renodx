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
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(CUSTOM_IS_CLAMPED != 0.f){
    r1.x = dot(saturate(r0.xyz), float3(0.300,0.590,0.110));
  } else {
    r1.x = dot(r0.xyz, float3(0.300,0.590,0.110));
  }
  r1.y = saturate(-0.5 + r1.x);
  r1.y = r1.y + r1.y;
  r1.z = saturate(r1.x + r1.x);
  r1.x = saturate(cb0[7].x * r1.x);
  r2.xyz = cb0[6].xyz * r1.zzz;
  r3.xyz = -r1.zzz * cb0[6].xyz + float3(1,1,1);
  r1.yzw = r1.yyy * r3.xyz + r2.xyz;
  r1.yzw = r1.yzw + -r0.xyz;
  o0.xyz = r1.xxx * r1.yzw + r0.xyz;
  o0.w = r0.w;
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