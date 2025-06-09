#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:26 2024

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = tex.Sample(sampler_tex_s, v0.xy).x;
  o0.xyzw = v1.wwww * r0.xxxx;

  // o0.rgb = pow(o0.rgb, 2.2f);
  // o0.rgb = renodx::color::bt2020::from::BT709(o0.rgb);
  // o0.xyz = renodx::color::pq::from::BT2020(o0.xyz, injectedData.toneMapGameNits);
  return;
}