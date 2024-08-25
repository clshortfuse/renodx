#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:10 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float3 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.SampleLevel(s0_s, v2.xy, 0).y;
  r0.y = t0.SampleLevel(s0_s, v1.zw, 0).y;
  r0.x = r0.x + r0.y;
  r0.y = v2.z * 2 + -1;
  r0.x = r0.x * 0.5 + r0.y;
  r0.x = saturate(20 * r0.x);
  r1.xyzw = t1.SampleLevel(s1_s, v1.xy, 0).wxyz;
  r1.x = saturate(r1.x);
  r0.yzw = r1.xxx * r1.yzw;
  o0.xyz = r0.yzw * r0.xxx;
  o0.w = 1;

  o0.xyz = saturate(o0.xyz);
  if (injectedData.toneMapGammaCorrection) { // fix srgb 2.2 mismatch
    o0.xyz = renodx::color::srgb::from::BT709(o0.xyz);
    o0.xyz = pow(o0.xyz, 2.2f);
  }
  o0.xyz *= injectedData.toneMapUINits/80.f;
  return;
}