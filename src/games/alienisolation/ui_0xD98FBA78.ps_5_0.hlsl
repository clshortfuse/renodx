#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 01:30:33 2024

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = saturate(tex.Sample(sampler_tex_s, v0.xy).xyzw);

  o0.rgb = pow(o0.rgb, 2.2f);
  o0.rgb = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::from::BT2020(o0.rgb, injectedData.toneMapUINits);
  return;
}