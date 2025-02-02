#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s1_s, v1.xy).x;
  r0.y = cb1[2].x * r0.x + -0.00999999978;
  r0.y = cmp(r0.y < 0);
  if (r0.y != 0) discard;
  r0.yzw = t0.Sample(s0_s, v1.xy).xyz;
  o0.xyz = r0.yzw * r0.xxx;
  o0.w = 1 + -cb1[2].x;
    o0.rgb = PostToneMapScale(o0.rgb);
  return;
}