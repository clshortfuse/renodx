#include "C:\Users\Musa\Documents\Programming Projects\renodx\src\shaders\renodx.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:39 2024

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex.Sample(sampler_tex_s, v2.xy).xyzw;
  r1.xyz = v1.xyz;
  r1.w = 1;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = v1.wwww * r0.xyzw;
  o0.xyzw = v0.xyzw * r0.wwww + r0.xyzw;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = (injectedData.toneMapGammaCorrection
                ? pow(o0.rgb, 2.2f)
                : renodx::color::bt709::from::SRGB(o0.rgb));
  float3 colorBT2020 = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::from::BT2020(colorBT2020, injectedData.toneMapUINits);
  return;
}