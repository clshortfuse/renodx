#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Jun  2 12:04:06 2025

cbuffer _Globals : register(b0)
{
  float4 cmatrix[4] : packoffset(c0);
  float4 alpha_mult : packoffset(c4);
  float4 hdr : packoffset(c5);
  float4 ctcp : packoffset(c6);
}

SamplerState YTexSampler_s : register(s0);
SamplerState CrCbTexSampler_s : register(s1);
Texture2D<float4> YTex : register(t0);
Texture2D<float4> CrCbTex : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = YTex.Sample(YTexSampler_s, v0.xy).x;
  r0.yz = CrCbTex.Sample(CrCbTexSampler_s, v0.xy).xy;
  r1.xyz = cmatrix[0].xyz * r0.yyy;
  r0.xyw = r0.xxx * cmatrix[3].xyz + r1.xyz;
  r0.xyz = r0.zzz * cmatrix[1].xyz + r0.xyw;
  r0.xyz = cmatrix[2].xyz + r0.xyz;
  r0.w = 1;
  o0.xyzw = alpha_mult.xyzw * r0.xyzw;
  o0.rgb = saturate(o0.rgb);
  return;
}