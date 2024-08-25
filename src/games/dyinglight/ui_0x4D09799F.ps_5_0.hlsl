#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:08 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[9];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb2[7].xy + cb2[7].zw;
  r0.x = t0.SampleLevel(s0_s, r0.xy, 0).x;
  r0.xy = r0.xx * cb2[8].xy + cb2[8].zw;
  r0.x = r0.x / -r0.y;
  r0.x = cmp(abs(r0.x) < v0.w);
  r0.y = saturate(dot(v1.xyz, float3(0.333333343,0.333333343,0.333333343)));
  r1.xyz = v1.xyz + -r0.yyy;
  r1.xyz = r1.xyz * float3(0.330000013,0.330000013,0.330000013) + r0.yyy;
  r1.w = 0.25 * v1.w;
  r0.xyzw = r0.xxxx ? r1.xyzw : v1.xyzw;
  r1.x = saturate(v2.y * 4 + -3);
  r1.x = 1 + -r1.x;
  r1.x = -v2.x * r1.x + 1;
  o0.xyz = r1.xxx * r0.xyz;
  o0.w = r0.w;

  o0.xyz = saturate(o0.xyz);
  if (injectedData.toneMapGammaCorrection) { // fix srgb 2.2 mismatch
    o0.xyz = renodx::color::srgb::from::BT709(o0.xyz);
    o0.xyz = pow(o0.xyz, 2.2f);
  }
  o0.xyz *= injectedData.toneMapUINits/80.f;
  return;
}