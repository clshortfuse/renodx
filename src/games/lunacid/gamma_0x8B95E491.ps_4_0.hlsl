#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Apr 12 15:39:53 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[6];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[4].xy + cb0[4].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;

  //r0.xyz = renodx::draw::InvertIntermediatePass(renodx::color::srgb::EncodeSafe(r0.xyz));

  r0.w = saturate(cb0[5].y);
  r0.xyz = r0.xyz + r0.www;

  //r0.xyz = saturate(float3(-1, -1, -1) + r0.xyz);
  r0.xyz = float3(-1, -1, -1) + r0.xyz;

  r0.w = max(1, cb0[5].y);
  r0.w = min(4, r0.w);

  //r0.xyz = saturate(r0.xyz * r0.www + -cb0[5].xxx);
  r0.xyz = r0.xyz * r0.www + (-cb0[5].xxx * 1);

  r1.xy = cb0[5].xx * float2(-14,-14) + float2(16,15);
  r1.xzw = r1.xxx * r0.xyz;
  r1.xzw = floor(r1.xzw);
  r1.xyz = r1.xzw / r1.yyy;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.w = 1.33333302 * cb0[5].x;
  o0.xyz = r0.www * r1.xyz + r0.xyz;
  o0.w = 1;

  o0.rgb = renodx::draw::RenderIntermediatePass(renodx::color::srgb::DecodeSafe(o0.rgb));
  //o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  return;
}