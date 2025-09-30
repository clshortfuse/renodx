// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 09 12:08:09 2025
#include "./!common.hlsl"
cbuffer _Globals : register(b0)
{
  float2 invPixelSize : packoffset(c0);
  float4 depthFactors : packoffset(c1);
  float2 fadeParams : packoffset(c2);
  float4 color : packoffset(c3);
  float4 colorMatrix0 : packoffset(c4);
  float4 colorMatrix1 : packoffset(c5);
  float4 colorMatrix2 : packoffset(c6);
  float exponent : packoffset(c7);
  float4 combineTextureWeights[2] : packoffset(c8);
  float4 colorScale : packoffset(c10);
  float2 invTexelSize : packoffset(c11);
  float4 downsampleQuarterZOffset : packoffset(c12);
  int sampleCount : packoffset(c13);
  float filterWidth : packoffset(c13.y);
  float mipLevelSource : packoffset(c13.z);
  float4 HexDOF_Params : packoffset(c14);
  float4 HexDOF_Params2 : packoffset(c15);
  float4 radialBlurScales : packoffset(c16);
  float2 radialBlurCenter : packoffset(c17);
  float4 poissonRadialBlurConstants : packoffset(c18);
  float blendFactor : packoffset(c19);
  float3 filmGrainColorScale : packoffset(c19.y);
  float4 filmGrainTextureScaleAndOffset : packoffset(c20);
  float4 depthScaleFactors : packoffset(c21);
  float4 dofParams : packoffset(c22);
  float3 bloomScale : packoffset(c23);
  float3 invGamma : packoffset(c24);
  float3 luminanceVector : packoffset(c25);
  float4 temporalAAWeight : packoffset(c26);
  float3 vignetteParams : packoffset(c27);
  float4 vignetteColor : packoffset(c28);
  float4 vignetteColorAdditiveLeft : packoffset(c29);
  float4 vignetteColorAdditiveRight : packoffset(c30);
  float4 chromostereopsisParams : packoffset(c31);
  float4 cameraMotionBlur_XXX : packoffset(c32);
  float4 cameraMotionBlur_YYY : packoffset(c33);
  float4 cameraMotionBlur_WWW : packoffset(c34);
  float4 cameraMotionBlur_ZZZ : packoffset(c35);
  float cocgbias : packoffset(c36) = {2};
}

SamplerState mainTexture_s : register(s0);
Texture2D<float4> mainTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = mainTexture.Sample(mainTexture_s, v1.xy).xyzw;
  float3 colorUntonemapped = r0.xyz;
  o0.w = r0.w;
  r0.w = 1;
  o0.x = dot(r0.xyzw, colorMatrix0.xyzw);
  o0.y = dot(r0.xyzw, colorMatrix1.xyzw);
  o0.z = dot(r0.xyzw, colorMatrix2.xyzw);
  o0.xyz = Tonemap_Do(colorUntonemapped, o0.xyz);
  return;
}