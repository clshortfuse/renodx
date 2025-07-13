#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 13 17:06:45 2025

cbuffer ColourCorrectionConstants : register(b2)
{
  float g_fIntensity : packoffset(c0);
}

SamplerState g_xFilteredClamp_s : register(s5);
Texture2D<float4> g_xSceneTextureLinear : register(t3);
Texture3D<float4> g_xColourCorrectionLutTexture : register(t4);
Texture2D<float4> g_xSceneTextureSRGB : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r1.xyz = g_xSceneTextureLinear.Load(r0.xyw).xyz; // linear (w/ upgrades)
  r0.xyzw = g_xSceneTextureSRGB.Load(r0.xyz).xyzw; // linear

  float3 untonemapped = r1.rgb;

  r0.rgb = neutralToneMap(r0.rgb);

  //r1.xyz = r1.xyz * float3(0.9375,0.9375,0.9375) + float3(0.03125,0.03125,0.03125);
  //r1.xyz = g_xColourCorrectionLutTexture.Sample(g_xFilteredClamp_s, r1.xyz).xyz;  // sRGB input, linear output
  r1.rgb = lutSample(r1.rgb, g_xFilteredClamp_s, g_xColourCorrectionLutTexture);

  //r1.xyz = r1.xyz + -r0.xyz;
  //o0.xyz = g_fIntensity * r1.xyz + r0.xyz; // lerp, linear
  o0.rgb = lerp(r0.rgb, r1.rgb, g_fIntensity);
  
  o0.w = r0.w;

  o0.rgb = applyToneMapScaling(untonemapped, o0.rgb);

  return;
}