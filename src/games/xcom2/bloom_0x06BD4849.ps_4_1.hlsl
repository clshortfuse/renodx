#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 31 00:53:02 2025

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4 SceneShadowsAndDesaturation : packoffset(c6);
  float4 SceneInverseHighLights : packoffset(c7);
  float4 SceneMidTones : packoffset(c8);
  float4 SceneScaledLuminanceWeights : packoffset(c9);
  float4 SceneColorize : packoffset(c10);
  float4 GammaColorScaleAndInverse : packoffset(c11);
  float4 GammaOverlayColor : packoffset(c12);
  float4 RenderTargetExtent : packoffset(c13);
  float4 ImageAdjustments1 : packoffset(c14);
  float4 ImageAdjustments2 : packoffset(c15);
  float4 ImageAdjustments3 : packoffset(c16);
  float InverseGamma : packoffset(c17);
  float4 SampleWeights[7] : packoffset(c18);
  float4 SampleMaskRect : packoffset(c25);
  int MipLevel : packoffset(c26);
  float4 VisualizeParam[2] : packoffset(c27);
}

SamplerState FilterTexture_s : register(s0);
Texture2D<float4> FilterTexture : register(t0);


// Applies a weighted blur using up to seven taps, skipping samples outside SampleMaskRect.
float4 SampleWeightedTap(float2 uv, float4 weight) {
  float inside = ((uv.x >= SampleMaskRect.x) && (uv.x <= SampleMaskRect.z) &&
                  (uv.y >= SampleMaskRect.y) && (uv.y <= SampleMaskRect.w)) ? 1.f : 0.f;
  return FilterTexture.SampleLevel(FilterTexture_s, uv, float(MipLevel)) * weight * inside;
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float2 tap_uvs[7] = {
      v0.xy,
      float2(v0.w, v0.z),
      v1.xy,
      float2(v1.w, v1.z),
      v2.xy,
      float2(v2.w, v2.z),
      v3.xy,
  };

  float4 result = 0;
  [unroll]
  for (int i = 0; i < 7; ++i) {
    result += SampleWeightedTap(tap_uvs[i], SampleWeights[i]);
  }

  o0 = result * CUSTOM_BLOOM_STRENGTH;
}