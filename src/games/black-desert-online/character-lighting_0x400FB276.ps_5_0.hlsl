// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 25 03:07:17 2025

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4x4 matFroxelViewProj : packoffset(c0);
  float4x4 matFarCloudShadowProjectionTexScale : packoffset(c4);
  float fTextureSampleBias : packoffset(c8) = {0};
  bool isGridLight : packoffset(c8.y);
  float4 vecSectorConstInfo : packoffset(c9);
  float3 vecViewPosition : packoffset(c10);
  float4 gridStartPosition : packoffset(c11);
  float rainAmount : packoffset(c12);
  float4x4 matViewProjectionTexScale : packoffset(c13);
  float fCharacterLightMultiplySample : packoffset(c17);
}

cbuffer outdoorScatteringConst : register(b2)
{
  float4 vecSunColorConst : packoffset(c0);
  float4 vecSunGlareColorConst : packoffset(c1);
  float4 vecHorizon0ColorConst : packoffset(c2);
  float4 vecHorizon1ColorConst : packoffset(c3);
  float4 vecSkyBaseColorConst : packoffset(c4);
  float4 vecExtinctionColorConst : packoffset(c5);
  float4 vecReighColorConst : packoffset(c6);
  float4 vecSunScatterColorConst : packoffset(c7);
  float4 vecAmbientColorConst[2] : packoffset(c8);
  float4 vecAmbientOcclusionColorConst : packoffset(c10);
  float4 vecDeepAOColorConst : packoffset(c11);
  float4 vecSkinAmbientColorConst : packoffset(c12);
  float4 vecHairAmbientColorConst : packoffset(c13);
  float4 vecEffectAmbientColorAlphaConst : packoffset(c14);
  float4 vecEffectAmbientColorConst : packoffset(c15);
  float4 vecEffectAmbientColorHit : packoffset(c16);
  float4 vecEffectAmbientColorHitAlpha : packoffset(c17);
  float3 vecSunDirection : packoffset(c18);
  float fSeaHeightConst : packoffset(c18.w);
  float3 vecMoonDirection : packoffset(c19);
  float IndoorRateRegion : packoffset(c19.w);
  float fSunScatterExpConst : packoffset(c20);
  float fSunGlareExpConst : packoffset(c20.y);
  float fSunExpConst : packoffset(c20.z);
  float fScatterDistanceFalloffConst : packoffset(c20.w);
  float fMieDistanceFalloffConst : packoffset(c21);
  float fMieHeightConst : packoffset(c21.y);
  float fReighDistanceFalloffConst : packoffset(c21.z);
  float fEnvIntensityConst : packoffset(c21.w);
  float fHorizonColorExp0Const : packoffset(c22);
  float fHorizonColorExp1Const : packoffset(c22.y);
  float fCharacterLightMultiply : packoffset(c22.z);
  float fCharacterLightMultiply2 : packoffset(c22.w);
  float RainAmount : packoffset(c23);
  float AirTemperature : packoffset(c23.y);
  float AirTemperatureForParticle : packoffset(c23.z);
  float IndoorRateRoof : packoffset(c23.w);
  float3 vecLightDirection : packoffset(c24);
  float fCloudLayer0Const : packoffset(c24.w);
  float fCloudLayer1Const : packoffset(c25);
  float fCloudLayer2Const : packoffset(c25.y);
  float fCloudLayer3Const : packoffset(c25.z);
  float fCloudLayer4Const : packoffset(c25.w);
  float fCloudLayer5Const : packoffset(c26);
  float fCloudLayer6Const : packoffset(c26.y);
  float fCloudLayer7Const : packoffset(c26.z);
  float fCloudLayer8Const : packoffset(c26.w);
  float fCloudLayer9Const : packoffset(c27);
  float fCloudLayer10Const : packoffset(c27.y);
  float fCloudLayer11Const : packoffset(c27.z);
  float fCloudLayer12Const : packoffset(c27.w);
  float4 fShaderTest : packoffset(c28) = {1,1,1,1};
  float4 vecCloudColorConst : packoffset(c29);
  float3 vecColorMultiply : packoffset(c30);
  float fBrightnessMultiply : packoffset(c30.w);
  float fScatteringScale : packoffset(c31);
  float fAerosolDensityScale : packoffset(c31.y);
  float fAerosolPhaseFunG : packoffset(c31.z);
  float fAerosolAbsorbtionScale : packoffset(c31.w);
  float fTurbidity : packoffset(c32);
  float fRayleighHeight : packoffset(c32.y);
  float fMieHeight2 : packoffset(c32.z);
  float fCloudAltitude : packoffset(c32.w);
  float fCloudThickness : packoffset(c33);
  float fCloudDensity : packoffset(c33.y);
  float fCloudDensityContrast : packoffset(c33.z);
  float fCloudBaseScale : packoffset(c33.w);
  float fCloudDetailScale : packoffset(c34);
  bool isSceneScatter : packoffset(c34.y);
  float fRainPoolAmount : packoffset(c34.z);
  float fSnowPoolAmount : packoffset(c34.w);
}



// 3Dmigoto declarations
#define cmp -


// Simple lighting helper exporting per-channel multipliers for forward lighting.
void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float3 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1,
  out float4 o2 : SV_TARGET2,
  out float4 o3 : SV_TARGET3)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Normalize sun color so the downstream passes work with consistent luminance ranges.
  r0.xyz = rsqrt(vecSunColorConst.xyz);
  r0.xyz = float3(1,1,1) / r0.xyz;
  // Scale character light weights by fCharacterLightMultiplySample across RGB sets.
  r1.xyzw = float4(0.5,1.70000005,1.70000005,1.70000005) * fCharacterLightMultiplySample;
  r2.xyzw = r1.xwxw * r0.xxyy;
  o2.xyzw = r1.xyzw * r0.zzzz;
  // Write out the slices used by the tiled-light accumulation buffers.
  o0.xyzw = r2.xyyy;
  o1.xyzw = r2.zwww;
  o3.xyzw = float4(0,0,0,0);
  return;
}