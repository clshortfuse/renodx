#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  2 19:21:35 2025

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
  float4 PackedParameters : packoffset(c18);
  float4 MinMaxBlurClamp : packoffset(c19);
  float4 RenderTargetClampParameter : packoffset(c20);
  float4 MotionBlurMaskScaleAndBias : packoffset(c21);
  float4x4 ScreenToWorld : packoffset(c22);
  float4x4 PrevViewProjMatrix : packoffset(c26);
  float4 StaticVelocityParameters : packoffset(c30) = {0.5,-0.5,0.0125000002,0.0222222228};
  float4 DynamicVelocityParameters : packoffset(c31) = {0.0250000004,-0.0444444455,-0.0500000007,0.088888891};
  float StepOffsetsOpaque[5] : packoffset(c32);
  float StepWeightsOpaque[5] : packoffset(c37);
  float StepOffsetsTranslucent[5] : packoffset(c42);
  float StepWeightsTranslucent[5] : packoffset(c47);
  float4 DirtyLensValues : packoffset(c52);
  float4 BloomTintAndScreenBlendThreshold : packoffset(c53);
  float4 HalfResMaskRect : packoffset(c54);
  float4 DOFKernelSize : packoffset(c55);
}

cbuffer PSOffsetConstants : register(b2)
{
  float4 ScreenPositionScaleBias : packoffset(c0);
  float4 MinZ_MaxZRatio : packoffset(c1);
  float NvStereoEnabled : packoffset(c2);
  float4 DiffuseOverrideParameter : packoffset(c3);
  float4 SpecularOverrideParameter : packoffset(c4);
  float4 CameraPositionPS : packoffset(c5);
  float4 ScreenTexelSize : packoffset(c6);
  float4 ViewportPositionScaleBias : packoffset(c7);
  float4 TransLightingVolumeMin : packoffset(c8);
  float4 TransLightingVolumeInvSize : packoffset(c9);
  float2 NumMSAASamples : packoffset(c10);
}

SamplerState SceneDepthTexture_s : register(s0);
SamplerState SceneColorTexture_s : register(s1);
SamplerState FilterColor1Texture_s : register(s2);
SamplerState BokehDOFLayerTexture_s : register(s3);
SamplerState LowResPostProcessBuffer_s : register(s4);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> SceneDepthTexture : register(t1);
Texture2D<float4> LowResPostProcessBuffer : register(t2);
Texture2D<float4> BokehDOFLayerTexture : register(t3);
Texture2D<float4> FilterColor1Texture : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, v1.xy, 0).x;
  r0.y = r0.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.y = 1 / r0.y;
  r0.z = cmp(0.999000013 < r0.x);
  o0.w = r0.x;
  r0.x = r0.z ? 1000000 : r0.y;
  r0.x = -PackedParameters.x + r0.x;
  r0.y = saturate(PackedParameters.y * abs(r0.x));
  r0.x = cmp(r0.x < 0);
  r0.x = r0.x ? MinMaxBlurClamp.x : MinMaxBlurClamp.y;
  r0.y = log2(r0.y);
  r0.y = PackedParameters.z * r0.y;
  r0.y = exp2(r0.y);
  r0.x = min(r0.x, r0.y);
  r0.x = saturate(max(PackedParameters.w, r0.x));
  r0.x = 1 + -r0.x;
  r0.yz = max(HalfResMaskRect.xy, v1.zw);
  r0.yz = min(HalfResMaskRect.zw, r0.yz);
  r1.xy = r0.yz * float2(0.5,1) + float2(0.5,0);
  r1.xyzw = BokehDOFLayerTexture.Sample(BokehDOFLayerTexture_s, r1.xy).xyzw;
  r0.w = max(0.00100000005, r1.w);
  r1.xyz = r1.xyz / r0.www;
  r0.w = saturate(DOFKernelSize.y * r1.w);
  r2.xyz = SceneColorTexture.SampleLevel(SceneColorTexture_s, v1.xy, 0).xyz;
  r2.xyz = r2.xyz;
  r3.xyzw = LowResPostProcessBuffer.Sample(LowResPostProcessBuffer_s, r0.yz).xyzw;
  r2.xyz = -r3.xyz * float3(4,4,4) + r2.xyz;
  r3.xyz = float3(4,4,4) * r3.xyz;
  r2.xyz = r3.www * r2.xyz + r3.xyz;
  r1.xyz = -r2.xyz + r1.xyz;
  r1.xyz = r0.www * r1.xyz + r2.xyz;
  r3.xyz = r2.xyz + -r1.xyz;
  r1.w = 0;
  r3.w = 1;
  r1.xyzw = r0.xxxx * r3.xyzw + r1.xyzw;
  r3.w = 0;
  r0.xw = float2(0.5,1) * r0.yz;
  r4.xyz = FilterColor1Texture.Sample(FilterColor1Texture_s, r0.yz).xyz;
  r0.xyzw = BokehDOFLayerTexture.Sample(BokehDOFLayerTexture_s, r0.xw).xyzw;
  r2.w = max(0.00100000005, r0.w);
  r3.xyz = r0.xyz / r2.www;
  r0.x = saturate(DOFKernelSize.y * r0.w);
  r3.xyzw = r3.xyzw + -r1.xyzw;
  r0.xyzw = r0.xxxx * r3.xyzw + r1.xyzw;
  r1.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  o0.xyz = r4.xyz * BloomTintAndScreenBlendThreshold.xyz + r0.xyz;
  return;
}