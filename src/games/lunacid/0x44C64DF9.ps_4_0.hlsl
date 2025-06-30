#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Apr 12 16:59:19 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float w2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyzw + v1.xyzw;
  r0.xyzw = cb0[2].xyzw * r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.x = saturate(w2.x);
  o0.xyz = r1.xxx * r0.xyz;
  o0.w = saturate(r0.w);

  //o0.rgb = renodx::draw::RenderIntermediatePass(renodx::color::srgb::DecodeSafe(o0.rgb));
  return;
}