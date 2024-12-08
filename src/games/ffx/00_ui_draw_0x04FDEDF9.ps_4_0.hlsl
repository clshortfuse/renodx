#include "./shared.h"
#include "./common.hlsl"

cbuffer PSc : register(b0)
{
  float4 color_mul : packoffset(c0);
  float4 color_add : packoffset(c1);
  float4 focal : packoffset(c2);
  float4 rescale1 : packoffset(c3);
}

SamplerState s_tex0_s : register(s0);
SamplerState s_tex1_s : register(s7);
Texture2D<float4> tex0 : register(t0);
Texture2D<float4> tex1 : register(t7);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 / v1.w;
  r0.xy = v1.xy * r0.xx;
  r0.xyzw = tex0.Sample(s_tex0_s, r0.xy).xyzw;
  r1.xyz = color_mul.xyz * color_mul.www;
  r1.w = color_mul.w;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.x = v1.z / v1.w;
  r1.y = v1.w;
  r1.xyzw = tex1.Sample(s_tex1_s, r1.xy).xyzw;
  o0.xyzw = r1.xyzw * r0.xyzw;

  o0.rgb = saturate(o0.rgb);
  return;
}