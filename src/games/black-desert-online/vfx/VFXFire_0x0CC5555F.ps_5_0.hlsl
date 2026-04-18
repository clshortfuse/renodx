// ---- Created with 3Dmigoto v1.4.1 on Tue Jan 13 08:42:21 2026

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4x4 matFroxelViewProj : packoffset(c0);
  float4x4 matInvViewProjection : packoffset(c4);
  float4x4 matFarCloudShadowProjectionTexScale : packoffset(c8);
  float fTextureSampleBias : packoffset(c12) = {0};
  float2 viewportJitter : packoffset(c12.y);
  float TimeAttachValue : packoffset(c12.w);
  float4x4 matRelativeViewProj : packoffset(c13);
  float4 positionOffset : packoffset(c17);
  float4 positionClipRect : packoffset(c18);
  float3 vecViewPosition : packoffset(c19);
  float4 invScreenSize : packoffset(c20);
  float4 vecViewRight : packoffset(c21);
  float4 vecViewUp : packoffset(c22);
  float4 vecViewFoward : packoffset(c23);
  float4x4 matWorld : packoffset(c24);
  int seaHeightOffsetIndex : packoffset(c28) = {-1};
  float3 vecWindDirection : packoffset(c28.y);
  float4 uvMainSubOffset0 : packoffset(c29);
  float4 uvMainSubOffset1 : packoffset(c30);
  float4 uvMainSubMul0 : packoffset(c31);
  float4 uvMainSubMul1 : packoffset(c32);
  float4x4 matRelativeWorldView : packoffset(c33);
  float4x4 matProjection : packoffset(c37);
  float4x4 matViewProjection : packoffset(c41);
  float4x4 matViewOriginProjection : packoffset(c45);
  bool isUseNormal : packoffset(c49);
  bool bRotateCameraPositionBase : packoffset(c49.y);
  bool isDisableRenderUnderRoof : packoffset(c49.z);
  float4x4 matRelativeWorld : packoffset(c50);
  float3 vecRate : packoffset(c54);
  int bCalcWeatherColor : packoffset(c54.w);
  int ribbonUVType : packoffset(c55);
  float2 vecInvScreenSize : packoffset(c55.y);
  bool debug_flip : packoffset(c55.w);
  float debug_gpuSpawnerCountRatio : packoffset(c56);
  float debug_gpuBufferOffsetRatio : packoffset(c56.y);
  float debug_gpuParticleCountRatio : packoffset(c56.z);
  int gpu_particle_spawnParticleCount : packoffset(c56.w);
  int gpu_particle_accSpawnParticleCount : packoffset(c57);
  int gpuSpawnerClearStartOffset : packoffset(c57.y);
  int gpuSpawnerClearCount : packoffset(c57.z);
  float3x3 editorViewOrigin : packoffset(c58);
  float3 editorViewPosition : packoffset(c61);
  int gpuParticleConstantOffset : packoffset(c61.w);
  int gpuParticleBufferOffset : packoffset(c62);
  int gpuParticleBufferOffsetStore : packoffset(c62.y);
  int batchBufferOffset : packoffset(c62.z);
  int batch_call_count : packoffset(c62.w);
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

cbuffer dynamicResolutionConst : register(b3)
{
  float2 fDynamicResolution : packoffset(c0);
  float2 fDynamicResolutionPrev : packoffset(c0.z);
}

cbuffer HDRConst : register(b4)
{
  float4 MaxEffectOutput : packoffset(c0);
  float MaxEffectColorBrightness : packoffset(c1);
  float hdrEncodeMulti : packoffset(c1.y);
  float hdrEncodeMulti_Effect : packoffset(c1.z);
  float gammaConst : packoffset(c1.w);
}

cbuffer ViewProjectionShaderConst : register(b5)
{
  row_major float4x4 VIEW : packoffset(c0);
  row_major float4x4 PROJECTION : packoffset(c4);
  row_major float4x4 VIEW_PROJECTION : packoffset(c8);
  row_major float4x4 VIEW_ORIGIN_PROJECTION : packoffset(c12);
  row_major float4x4 INV_PROJECTION : packoffset(c16);
  row_major float4x4 INV_VIEW_PROJECTION : packoffset(c20);
  row_major float4x4 INV_VIEW_ORIGIN_PROJECTION : packoffset(c24);
  float3 VIEW_POSITION : packoffset(c28);
  uint ViewProjectionShaderConst_dummy0 : packoffset(c28.w);
}

cbuffer effectScene : register(b6)
{
  float4 vecBlendOP[4] : packoffset(c0);
}

cbuffer effectOptionalAlpha : register(b7)
{
  float gEffectOptionalAlpha : packoffset(c0);
  float3 effectOptionalAlphaFloatDummy : packoffset(c0.y);
}

SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s0);
SamplerState samDiffuseHH_s : register(s10);
SamplerState samNormal_s : register(s11);
SamplerState samDepth_s : register(s13);
Texture2D<float4> texDiffuse : register(t7);
Texture2D<float4> texNormal : register(t8);
Texture2D<float4> texDepth : register(t9);
TextureCube<float4> texEnv : register(t10);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float2 v7 : TEXCOORD5,
  uint v8 : COLOR1,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -0.5 + TimeAttachValue;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xyz = cmp(vecBlendOP[1].yyy == float3(2,1,3));
  r1.xy = v7.xy * v3.ww + v2.xy;
  r1.xy = r0.xx ? r1.xy : v2.xy;
  r1.xyz = texNormal.Sample(samNormal_s, r1.xy).xyz;
  r2.xyz = v2.www * r1.xyz;
  r3.xy = v2.xy * float2(2,2) + float2(-1,-1);
  r3.xy = -abs(r3.xy) * abs(r3.xy) + float2(1,1);
  r3.z = r3.x * r3.y;
  r4.xy = float2(-0.5,-0.5) + r1.xy;
  r4.zw = r4.xy * v2.ww + v2.xy;
  r3.xy = r4.xy * v2.ww + v6.xy;
  r5.xy = v6.xy;
  r5.z = 1;
  r3.xyz = r0.xxx ? r3.xyz : r5.xyz;
  r0.xw = r0.xx ? r4.zw : v2.xy;
  r2.xyz = r0.yyy ? r2.xyz : 0;
  r0.xw = r0.yy ? v2.xy : r0.xw;
  r3.xyz = r0.yyy ? r5.xyz : r3.xyz;
  r4.xyzw = texDiffuse.Sample(samDiffuseHH_s, r0.xw).xyzw;
  r5.xyzw = texDiffuse.Sample(samDiffuseHH_s, r3.xy).xyzw;
  r5.xyzw = r5.xyzw + -r4.xyzw;
  r4.xyzw = v6.zzzz * r5.xyzw + r4.xyzw;
  r0.xyw = log2(r4.xyz);
  r0.xyw = float3(2.20000005,2.20000005,2.20000005) * r0.xyw;
  r0.xyw = exp2(r0.xyw);
  r1.w = saturate(vecBlendOP[0].y + r3.z);
  r0.xyw = r1.www * r0.xyw;
  r3.w = r4.w * r3.z;
  r1.w = cmp(0.99000001 < vecBlendOP[1].w);
  r4.xyz = vecEffectAmbientColorHit.xyz + vecEffectAmbientColorHit.xyz;
  r5.xyz = vecEffectAmbientColorHitAlpha.xyz * float3(3,3,3) + -r4.xyz;
  r5.xyz = vecBlendOP[0].yyy * r5.xyz + r4.xyz;
  r5.xyz = r5.xyz * r0.xyw;
  r6.xyz = vecEffectAmbientColorHitAlpha.xyz * float3(2,2,2) + -r4.xyz;
  r4.xyz = vecBlendOP[0].yyy * r6.xyz + r4.xyz;
  r4.xyz = v1.xyz * r4.xyz;
  r6.xyz = vecEffectAmbientColorConst.xyz + vecEffectAmbientColorConst.xyz;
  r7.xyz = vecEffectAmbientColorAlphaConst.xyz * float3(2,2,2) + -r6.xyz;
  r6.xyz = vecBlendOP[0].yyy * r7.xyz + r6.xyz;
  r0.xyw = r6.xyz * r0.xyw;
  r4.xyz = r1.www ? r4.xyz : v1.xyz;
  r3.xyz = r1.www ? r5.xyz : r0.xyw;
  r4.w = v1.w;
  r5.xyzw = r4.xyzw * r3.xyzw;
  r0.x = r3.w * r4.w + -v2.z;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  if (r0.z != 0) {
    r0.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r0.xyz = -r0.xyz;
    r0.xyz = texEnv.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r0.xyz, 0).xyz;
    r1.xyz = r0.xyz * r0.xyz;
    r1.xyz = r1.xyz * r1.xyz;
    r3.xyz = r1.xyz * r0.xyz;
    r0.w = dot(r3.xyz, float3(0.300000012,0.589999974,0.109999999));
    r0.xyz = -r0.xyz * r1.xyz + r0.www;
    r0.xyz = r0.xyz * float3(0.800000012,0.800000012,0.800000012) + r3.xyz;
    r1.xyz = v2.www + r4.xyz;
    r0.xyz = r1.xyz * r0.xyz;
    r0.w = saturate(vecLightDirection.y * 0.5 + 0.300000012);
    r5.xyz = r0.xyz * r0.www + r5.xyz;
  }
  r0.x = 0.0500000007 * vecBlendOP[0].y;
  r0.xyz = v5.xyz * r0.xxx;
  r0.xyz = r5.xyz * v4.xyz + r0.xyz;
  r0.xyz = r0.xyz + r2.xyz;
  r0.w = v4.w * r5.w;
  r1.x = saturate(r5.w * v4.w + vecBlendOP[0].z);
  r0.xyz = r1.xxx * r0.xyz;
  r1.xy = invScreenSize.xy * v0.xy;
  r1.z = dot(v3.xyz, v3.xyz);
  r1.z = sqrt(r1.z);
  r2.xy = r1.xy / fDynamicResolution.xy;
  r1.x = texDepth.Sample(samDepth_s, r1.xy).x;
  r1.y = cmp(0.00100000005 < r1.x);
  r1.x = r1.y ? r1.x : 0;
  r1.y = r2.x * 2 + -1;
  r1.w = r2.y * -2 + 1;
  r2.xyzw = INV_VIEW_ORIGIN_PROJECTION._m10_m11_m12_m13 * r1.wwww;
  r2.xyzw = r1.yyyy * INV_VIEW_ORIGIN_PROJECTION._m00_m01_m02_m03 + r2.xyzw;
  r2.xyzw = r1.xxxx * INV_VIEW_ORIGIN_PROJECTION._m20_m21_m22_m23 + r2.xyzw;
  r2.xyzw = INV_VIEW_ORIGIN_PROJECTION._m30_m31_m32_m33 + r2.xyzw;
  r1.xyw = r2.xyz / r2.www;
  r1.x = dot(r1.xyw, r1.xyw);
  r1.x = sqrt(r1.x);
  r1.x = r1.x + -r1.z;
  r1.x = saturate(vecBlendOP[1].x * r1.x);
  r1.y = r1.z / vecBlendOP[1].z;
  r1.z = r1.y * r1.y;
  r1.y = saturate(-r1.y * r1.z + 1);
  r1.x = r1.x * r1.y;
  r1.y = r1.x * r1.x;
  r1.z = r1.x * r1.x + -0.00100000005;
  r1.z = cmp(r1.z < 0);
  if (r1.z != 0) discard;
  r2.w = r1.y * r0.w;
  r0.w = saturate(r1.x * r1.x + vecBlendOP[0].y);
  r0.xyz = r0.xyz * r0.www;
  r0.w = saturate(0.0399999991 + vecBlendOP[0].y);
  r0.xyz = r0.xyz * r0.www;
  r0.w = 1 / gammaConst;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.www * r0.xyz;
  r2.xyz = exp2(r0.xyz);
  r0.xyzw = gEffectOptionalAlpha * r2.xyzw;
  r0.xyzw = v5.wwww * r0.xyzw;
  r0.xyzw = min(MaxEffectOutput.xyzw, r0.xyzw);
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  
// Hue shifting for fires (affects other VFX as well sadly)

  if (RENODX_TONE_MAP_TYPE != 0.f && shader_injection.tone_map_hue_correction > 0.f) {
    r0.xyz = renodx::color::correct::HueOKLab(r0.xyz, r2.xyz, shader_injection.tone_map_hue_correction);
  }
  
  o0.xyzw = r0.xyzw;
  o1.xyzw = r2.xyzw;
  return;
}