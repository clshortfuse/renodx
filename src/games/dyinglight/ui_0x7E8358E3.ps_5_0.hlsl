#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:20 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.Sample(s0_s, v2.xy).w;
  r0.x = log2(r0.x);
  r0.x = 2.20000005 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = saturate(cb0[0].x + r0.x);
  r1.xyzw = t0.Sample(s0_s, v2.zw).xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  r0.y = log2(r1.w);
  o0.xyz = r1.xyz;
  r0.y = 2.20000005 * r0.y;
  r0.y = exp2(r0.y);
  o0.w = r0.y * r0.x;

  o0.xyz = saturate(o0.xyz);
  if (injectedData.toneMapGammaCorrection) { // fix srgb 2.2 mismatch
    o0.xyz = renodx::color::srgb::from::BT709(o0.xyz);
    o0.xyz = pow(o0.xyz, 2.2f);
  }
  o0.xyz *= injectedData.toneMapUINits/80.f;
  return;
}