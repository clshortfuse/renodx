#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Jul 03 01:29:41 2025

SamplerState screenSampler_s : register(s0);
SamplerState gammaSampler_s : register(s1);
Texture2D<float4> screenSamplerTex : register(t0);
Texture2D<float4> gammaSamplerTex : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = 0.5;
  r1.xyz = screenSamplerTex.SampleLevel(screenSampler_s, v1.xy, 0).xzy;

  float3 untonemapped = renodx::color::srgb::DecodeSafe(r1.xzy);
  float3 sdr_color = saturate(untonemapped);

  r0.x = r1.y;
  r0.x = gammaSamplerTex.SampleLevel(gammaSampler_s, r0.xy, 0).x;
  o0.z = r0.x;
  o0.w = 1;
  r1.yw = float2(0.5,0.5);
  r0.x = gammaSamplerTex.SampleLevel(gammaSampler_s, r1.xy, 0).x;
  r0.y = gammaSamplerTex.SampleLevel(gammaSampler_s, r1.zw, 0).x;
  o0.xy = r0.xy;

  o0.rgb = CustomTonemapIntermediate(untonemapped, sdr_color);
  return;
}