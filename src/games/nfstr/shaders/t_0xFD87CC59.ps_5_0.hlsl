// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 09 12:08:16 2025
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
SamplerState mainTexture2_s : register(s1);
SamplerState tonemapBloomTexture_s : register(s2);
Texture2D<float4> mainTexture : register(t0);
Texture2D<float4> tonemapBloomTexture : register(t1);
Texture2D<float4> mainTexture2 : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = mainTexture.Sample(mainTexture_s, v1.xy).xyz;
  r1.xyzw = mainTexture2.Sample(mainTexture2_s, v1.xy).xyzw;
  r0.w = 1 + -r1.w;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = tonemapBloomTexture.Sample(tonemapBloomTexture_s, v1.xy).xyz;
  Bloom_User(r1.xyz);
  r0.xyz = r1.xyz * bloomScale.xyz + r0.xyz;
  r0.xyz = colorScale.xyz * r0.xyz;
  float3 colorUntonemapped = r0.xyz;
  r1.xyz = float3(0.985521019,0.985521019,0.985521019) * r0.xyz;
  r2.xyz = r0.xyz * float3(0.985521019,0.985521019,0.985521019) + float3(0.058662001,0.058662001,0.058662001);
  r1.xyz = r2.xyz * r1.xyz;
  r2.xyz = r0.xyz * float3(0.774596989,0.774596989,0.774596989) + float3(0.0482814983,0.0482814983,0.0482814983);
  r0.xyz = r0.xyz * float3(0.774596989,0.774596989,0.774596989) + float3(1.24270999,1.24270999,1.24270999);
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = sqrt(r0.xyz);
  r1.xy = -radialBlurCenter.xy + v1.xy;
  r1.xy = vignetteParams.xy * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = log2(r0.w);
  r0.w = vignetteParams.z * r0.w;
  r0.w = exp2(r0.w);
  r0.w = vignetteColor.w * r0.w;
  r1.x = saturate(r0.w);
  r1.yzw = float3(-1,-1,-1) + vignetteColor.xyz;
  r1.xyz = r1.xxx * r1.yzw + float3(1,1,1);
  r2.xyz = vignetteColorAdditiveRight.xyz + -vignetteColorAdditiveLeft.xyz;
  r2.xyz = v1.xxx * r2.xyz + vignetteColorAdditiveLeft.xyz;
  r2.xyz = r2.xyz * r0.www;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  r0.w = 1;
  o0.x = dot(r0.xyzw, colorMatrix0.xyzw);
  o0.y = dot(r0.xyzw, colorMatrix1.xyzw);
  o0.z = dot(r0.xyzw, colorMatrix2.xyzw);
  o0.w = 0;
  o0.xyz = Tonemap_Do(colorUntonemapped, o0.xyz);
  return;
}