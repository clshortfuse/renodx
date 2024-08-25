#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:10 2024
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
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  o0.xyzw = r0.xyzw;

  if (injectedData.toneMapType == 0) {  // vanilla tonemap flickers if left unclamped
    o0.xyz = saturate(o0.xyz);
  }

  if (injectedData.toneMapGammaCorrection) { // fix srgb 2.2 mismatch
    o0.xyz = renodx::color::srgb::from::BT709(o0.xyz);
    o0.xyz = sign(o0.xyz) * pow(abs(o0.xyz), 2.2f);
  }
  // apply game gamma adjustment slider
  o0.xyz = sign(o0.xyz) * pow(abs(o0.xyz), cb0[0].xxx);

  o0.xyz *= injectedData.toneMapGameNits/80.f;
  o0.w = saturate(o0.w);
  return;
}