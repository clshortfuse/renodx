#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 01:30:20 2024

SamplerState sampler_tex_0__s : register(s0);
SamplerState sampler_tex_1__s : register(s1);
SamplerState sampler_tex_2__s : register(s2);
Texture2D<float4> tex_0_ : register(t0);
Texture2D<float4> tex_1_ : register(t1);
Texture2D<float4> tex_2_ : register(t2);


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

  r0.x = tex_2_.Sample(sampler_tex_2__s, v1.xy).x;
  r0.x = -0.501960814 + r0.x;
  r0.xyz = float3(1.59599996,-0.813000023,0) * r0.xxx;
  r0.w = tex_0_.Sample(sampler_tex_0__s, v1.xy).x;
  r0.w = -0.0627451017 + r0.w;
  r0.xyz = r0.www * float3(1.16400003,1.16400003,1.16400003) + r0.xyz;
  r0.w = tex_1_.Sample(sampler_tex_1__s, v1.xy).x;
  r0.w = -0.501960814 + r0.w;
  o0.xyz = r0.www * float3(0,-0.39199999,2.01699996) + r0.xyz;
  o0.w = v0.w;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::bt709::from::SRGB(o0.rgb);
  float3 colorBT2020 = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::from::BT2020(colorBT2020, injectedData.toneMapGameNits);
  return;
}