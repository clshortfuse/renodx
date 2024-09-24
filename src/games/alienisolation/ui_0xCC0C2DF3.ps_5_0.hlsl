#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 01:30:32 2024

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex.Sample(sampler_tex_s, v1.xy).xyzw;
  o0.w = saturate(v0.w * r0.w);
  o0.xyz = saturate(r0.xyz);

  o0.rgb = pow(o0.rgb, 2.2f);
  o0.rgb = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::from::BT2020(o0.rgb, injectedData.toneMapUINits);
  return;
}