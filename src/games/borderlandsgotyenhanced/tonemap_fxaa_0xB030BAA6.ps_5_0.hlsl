#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Mon Jun  2 09:44:30 2025

cbuffer _Globals : register(b0)
{
  float4 PackedParameters : packoffset(c0);
  float2 MinMaxBlurClamp : packoffset(c1);
  float4 SceneShadowsAndDesaturation : packoffset(c2);
  float4 SceneInverseHighLights : packoffset(c3);
  float4 SceneMidTones : packoffset(c4);
  float4 SceneScaledLuminanceWeights : packoffset(c5);
  float4 GammaColorScaleAndInverse : packoffset(c6);
  float4 GammaOverlayColor : packoffset(c7);
}

cbuffer PSOffsetConstants : register(b2)
{
  float4 ScreenPositionScaleBias : packoffset(c0);
  float4 MinZ_MaxZRatio : packoffset(c1);
  float4 DynamicScale : packoffset(c2);
}

SamplerState SceneColorTextureSampler_s : register(s0);
SamplerState BlurredImageSampler_s : register(s1);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> BlurredImage : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0,
  out float o1 : SV_Target1)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = DynamicScale.xy * v0.zw;
  r0.xyz = SceneColorTexture.Sample(SceneColorTextureSampler_s, r0.xy).xyz;
  r1.xyzw = BlurredImage.Sample(BlurredImageSampler_s, v1.xy).xyzw;
  r0.w = saturate(1 + -r1.w);
  r0.xyz = r0.xyz * r0.www + r1.xyz;

  float3 hdr_color = r0.rgb;
  float3 hdr_color_tm = HermiteSplineRolloff(r0.rgb);

  if (SHADOWS_DESATURATION == 0) {
    r0.xyz = saturate(-SceneShadowsAndDesaturation.xyz) + r0.xyz;
  } else {
    r0.xyz = saturate(-SceneShadowsAndDesaturation.xyz + r0.xyz);
  }
  r0.xyz = SceneInverseHighLights.xyz * r0.xyz;
  r0.xyz = max(float3(9.99999975e-05,9.99999975e-05,9.99999975e-05), abs(r0.xyz));
  r0.xyz = log2(r0.xyz);
  r0.xyz = SceneMidTones.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.w = dot(r0.xyz, SceneScaledLuminanceWeights.xyz);
  r1.xyz = r0.xyz * SceneShadowsAndDesaturation.www + GammaOverlayColor.xyz;
  r0.x = dot(r0.xyz, float3(0.212670997,0.715160012,0.0721689984));
  r0.x = r0.x * 15 + 1;
  r0.x = log2(r0.x);
  o1.x = 0.25 * r0.x;
  r0.xyz = r1.xyz + r0.www;
  if (RENODX_TONE_MAP_TYPE == 0) {
    r0.xyz = saturate(GammaColorScaleAndInverse.xyz * r0.xyz);
  } else {
    r0.xyz = GammaColorScaleAndInverse.xyz * r0.xyz;
  }
  r0.xyz = max(float3(9.99999975e-05,9.99999975e-05,9.99999975e-05), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = GammaColorScaleAndInverse.www * r0.xyz;
  o0.xyz = exp2(r0.xyz);

  float3 sdr_color = renodx::color::srgb::DecodeSafe(o0.rgb);
  o0.rgb = ToneMapPass(hdr_color, sdr_color, hdr_color_tm, v1);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  
  o0.w = 0;
  return;
}