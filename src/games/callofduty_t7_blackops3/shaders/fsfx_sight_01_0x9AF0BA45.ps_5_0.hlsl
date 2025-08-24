// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 07 14:48:02 2025

#include "../shared.h"
#include "../common.hlsl"

struct GpuShaderConstantSet
{
    float4 scriptVector0;          // Offset:    0
    float4 scriptVector1;          // Offset:   16
    float4 scriptVector2;          // Offset:   32
    float4 scriptVector3;          // Offset:   48
    float4 scriptVector4;          // Offset:   64
    float4 scriptVector5;          // Offset:   80
    float4 scriptVector6;          // Offset:   96
    float4 scriptVector7;          // Offset:  112
    float4 weaponParam0;           // Offset:  128
    float4 weaponParam1;           // Offset:  144
    float4 weaponParam2;           // Offset:  160
    float4 weaponParam3;           // Offset:  176
    float4 weaponParam4;           // Offset:  192
    float4 weaponParam5;           // Offset:  208
    float4 weaponParam6;           // Offset:  224
    float4 weaponParam7;           // Offset:  240
    float4 characterParam0;        // Offset:  256
    float4 characterParam1;        // Offset:  272
    float4 characterParam2;        // Offset:  288
    float4 characterParam3;        // Offset:  304
    float4 characterParam4;        // Offset:  320
    float4 characterParam5;        // Offset:  336
    float4 characterParam6;        // Offset:  352
    float4 characterParam7;        // Offset:  368
};

struct ModelInstanceData
{
    uint boneArrayIndex;           // Offset:    0
    uint shaderConstantSet;        // Offset:    4
    uint flagsAndPrevFrameIndex;   // Offset:    8
    uint worldMatrix;              // Offset:   12
    uint siegeAnimStateOffset;     // Offset:   16
    uint prevFrameSiegeAnimStateOffset;// Offset:   20
};

cbuffer _Globals : register(b0)
{
  float4 flagParams : packoffset(c0);
  float4 colorObjMin : packoffset(c1);
  float4 colorObjMax : packoffset(c2);
  float colorObjMinBaseBlend : packoffset(c3);
  float colorObjMaxBaseBlend : packoffset(c3.y);
  float2 uvScroll : packoffset(c3.z);
  float4 detailScale : packoffset(c4);
  float4 detailScale1 : packoffset(c5);
  float4 detailScale2 : packoffset(c6);
  float4 detailScale3 : packoffset(c7);
  float4 alphaRevealParms : packoffset(c8);
  float4 colorDetailScale : packoffset(c9);
  float3 Glow_Color : packoffset(c10);
  float Noise_Scale : packoffset(c10.w);
  float Color_Map_Scale : packoffset(c11);
  float Glow_Falloff : packoffset(c11.y);
  float Color_Map_Noise : packoffset(c11.z);
  float Background : packoffset(c11.w);
  float3 Reticle_Color : packoffset(c12);
  float Reticle_Color_Multiplier : packoffset(c12.w);
  float Glow_Color_Multiplier : packoffset(c13);
}

cbuffer PerSceneConsts : register(b1)
{
  row_major float4x4 projectionMatrix : packoffset(c0);
  row_major float4x4 viewMatrix : packoffset(c4);
  row_major float4x4 viewProjectionMatrix : packoffset(c8);
  row_major float4x4 inverseProjectionMatrix : packoffset(c12);
  row_major float4x4 inverseViewMatrix : packoffset(c16);
  row_major float4x4 inverseViewProjectionMatrix : packoffset(c20);
  float4 eyeOffset : packoffset(c24);
  float4 adsZScale : packoffset(c25);
  float4 hdrControl0 : packoffset(c26);
  float4 hdrControl1 : packoffset(c27);
  float4 fogColor : packoffset(c28);
  float4 fogConsts : packoffset(c29);
  float4 fogConsts2 : packoffset(c30);
  float4 fogConsts3 : packoffset(c31);
  float4 fogConsts4 : packoffset(c32);
  float4 fogConsts5 : packoffset(c33);
  float4 fogConsts6 : packoffset(c34);
  float4 fogConsts7 : packoffset(c35);
  float4 fogConsts8 : packoffset(c36);
  float4 fogConsts9 : packoffset(c37);
  float3 sunFogDir : packoffset(c38);
  float4 sunFogColor : packoffset(c39);
  float2 sunFog : packoffset(c40);
  float4 zNear : packoffset(c41);
  float3 clothPrimaryTint : packoffset(c42);
  float3 clothSecondaryTint : packoffset(c43);
  float4 renderTargetSize : packoffset(c44);
  float4 upscaledTargetSize : packoffset(c45);
  float4 materialColor : packoffset(c46);
  float4 cameraUp : packoffset(c47);
  float4 cameraLook : packoffset(c48);
  float4 cameraSide : packoffset(c49);
  float4 cameraVelocity : packoffset(c50);
  float4 skyMxR : packoffset(c51);
  float4 skyMxG : packoffset(c52);
  float4 skyMxB : packoffset(c53);
  float4 sunMxR : packoffset(c54);
  float4 sunMxG : packoffset(c55);
  float4 sunMxB : packoffset(c56);
  float4 skyRotationTransition : packoffset(c57);
  float4 debugColorOverride : packoffset(c58);
  float4 debugAlphaOverride : packoffset(c59);
  float4 debugNormalOverride : packoffset(c60);
  float4 debugSpecularOverride : packoffset(c61);
  float4 debugGlossOverride : packoffset(c62);
  float4 debugOcclusionOverride : packoffset(c63);
  float4 debugStreamerControl : packoffset(c64);
  float4 emblemLUTSelector : packoffset(c65);
  float4 colorMatrixR : packoffset(c66);
  float4 colorMatrixG : packoffset(c67);
  float4 colorMatrixB : packoffset(c68);
  float4 gameTime : packoffset(c69);
  float4 gameTick : packoffset(c70);
  float4 subpixelOffset : packoffset(c71);
  float4 viewportDimensions : packoffset(c72);
  float4 viewSpaceScaleBias : packoffset(c73);
  float4 ui3dUVSetup0 : packoffset(c74);
  float4 ui3dUVSetup1 : packoffset(c75);
  float4 ui3dUVSetup2 : packoffset(c76);
  float4 ui3dUVSetup3 : packoffset(c77);
  float4 ui3dUVSetup4 : packoffset(c78);
  float4 ui3dUVSetup5 : packoffset(c79);
  float4 clipSpaceLookupScale : packoffset(c80);
  float4 clipSpaceLookupOffset : packoffset(c81);
  uint4 computeSpriteControl : packoffset(c82);
  float4 invBcTexSizes : packoffset(c83);
  float4 invMaskTexSizes : packoffset(c84);
  float4 relHDRExposure : packoffset(c85);
  uint4 triDensityFlags : packoffset(c86);
  float4 triDensityParams : packoffset(c87);
  float4 voldecalRevealTextureInfo : packoffset(c88);
  float4 extraClipPlane0 : packoffset(c89);
  float4 extraClipPlane1 : packoffset(c90);
  float4 shaderDebug : packoffset(c91);
  uint isDepthHack : packoffset(c92);
}

SamplerState Detail_Map_Sampler_s : register(s1);
SamplerState Color_Map_Sampler_s : register(s2);
StructuredBuffer<GpuShaderConstantSet> shaderConstantSetBuffer : register(t0);
StructuredBuffer<ModelInstanceData> modelInstanceBuffer : register(t4);
Texture2D<float4> Detail_Map : register(t6);
Texture2D<float4> Color_Map : register(t7);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  nointerpolation uint v3 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cmp(w1.xy < float2(0,0));
  r0.zw = cmp(float2(1,1) < w1.xy);
  r0.x = (int)r0.z | (int)r0.x;
  r0.x = (int)r0.y | (int)r0.x;
  r0.x = (int)r0.w | (int)r0.x;
  r0.yzw = Color_Map.Sample(Color_Map_Sampler_s, w1.xy).xyz;
  r0.xyz = r0.xxx ? float3(0,0,0) : r0.yzw;
  r0.y = log2(abs(r0.y));
  r0.y = Glow_Falloff * r0.y;
  r0.y = exp2(r0.y);
  r1.xyz = Glow_Color.xyz * r0.yyy;
  r1.xyz = Glow_Color_Multiplier * r1.xyz;
  r0.yw = Noise_Scale * v1.xy;
  r0.y = Detail_Map.Sample(Detail_Map_Sampler_s, r0.yw, int2(0, 0)).x;
  r1.xyz = r1.xyz * r0.yyy;
  r0.y = -Color_Map_Noise * r0.y + 1;
  r2.xyz = Reticle_Color.xyz * r0.xxx;
  r3.w = Background * r0.z;
  r0.xzw = Reticle_Color_Multiplier * r2.xyz;
  r3.xyz = r0.xzw * r0.yyy + r1.xyz;
  r0.x = modelInstanceBuffer[v3.x].shaderConstantSet;
  r0.y = shaderConstantSetBuffer[r0.x].weaponParam0.y;
  r0.x = shaderConstantSetBuffer[r0.x].weaponParam0.w;
  r0.x = saturate(r0.x + r0.x);
  r0.y = 1 + -r0.y;
  r1.xyzw = r3.xyzw * r0.yyyy;
  r0.xyzw = r1.xyzw * r0.xxxx;
  r1.xyz = saturate(r0.xyz);
  r1.xyz = float3(32768,32768,32768) * r1.xyz;
  r1.w = cmp(0 < relHDRExposure.w);
  o0.xyz = r1.www ? r1.xyz : r0.xyz;
  o0.w = r0.w;

  o0.xyz = Tradeoff_PrepareFullWidthFsfx(o0.xyz, CUSTOM_ADS_SIGHTS, false);

  return;
}