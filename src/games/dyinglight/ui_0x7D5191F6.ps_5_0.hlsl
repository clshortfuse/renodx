#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:20 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.400000006 * cb0[1].y;
  r0.x = frac(r0.x);
  r0.xyz = float3(0.5,-0.0399999991,0.0399999991) + r0.xxx;
  r0.w = -v1.y * 0.333299994 + v1.x;
  r0.w = r0.w * 0.375 + 0.5;
  r0.yz = cmp(r0.yw < r0.wz);
  r0.x = frac(r0.x);
  r1.xy = float2(-0.0399999991,0.0399999991) + r0.xx;
  r0.x = r0.z ? r0.y : 0;
  r0.y = cmp(r1.x < r0.w);
  r0.z = cmp(r0.w < r1.y);
  r0.y = r0.z ? r0.y : 0;
  r0.x = (int)r0.y | (int)r0.x;
  r0.x = r0.x ? 1 : 0.400000006;
  o0.xyz = cb0[0].xyz * r0.xxx;
  r0.x = t0.Sample(s0_s, v1.zw).w;
  o0.w = cb0[0].w * r0.x;

  o0.xyz = saturate(o0.xyz);
  if (injectedData.toneMapGammaCorrection) { // fix srgb 2.2 mismatch
    o0.xyz = renodx::color::srgb::from::BT709(o0.xyz);
    o0.xyz = pow(o0.xyz, 2.2f);
  }
  o0.xyz *= injectedData.toneMapUINits/80.f;
  return;
}