#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 13 18:40:36 2025

cbuffer ColourCorrectionPSConstants : register(b9)
{
  float g_fIntensity : packoffset(c0);
}

SamplerState g_xBilinearClamp_s : register(s3);
Texture2D<float4> g_xSceneTextureLinear : register(t2);
Texture3D<float4> g_xCCLutTexture : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r0.xyz = g_xSceneTextureLinear.Load(r0.xyz).xyz;

  float3 untonemapped = r0.rgb;

  // r0.xyz = r0.xyz * float3(0.9375,0.9375,0.9375) + float3(0.03125,0.03125,0.03125);
  // r0.xyz = g_xCCLutTexture.Sample(g_xBilinearClamp_s, r0.xyz).xyz;
  r0.rgb = lutSample(r0.rgb, g_xBilinearClamp_s, g_xCCLutTexture);

  o0.xyz = r0.xyz;
  o0.w = g_fIntensity; // no lerp here for some reason

  o0.rgb = applyToneMapScaling(untonemapped, o0.rgb);

  return;
}