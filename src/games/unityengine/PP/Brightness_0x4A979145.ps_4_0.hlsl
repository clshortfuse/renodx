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

  r0.x = cb0[2].x;
  r0.w = 0;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = cb0[3].xyz * r1.xyz;
  o0.xyzw = r1.xyzw + r0.xxxw;
  if(RENODX_TONE_MAP_TYPE == 0.f){
    o0 = saturate(o0);
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}