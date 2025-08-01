// ---- Created with 3Dmigoto v1.3.16 on Thu Jul 31 14:35:32 2025

//Fullscreen FX Slide Bottom Lens Dirt

#include "../common.hlsl"

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
  float alphaRevealSoftEdge : packoffset(c10);
  float alphaRevealRamp : packoffset(c10.y);
  float heightScale : packoffset(c10.z);
  float2 sprites : packoffset(c11);
  float2 source : packoffset(c11.z);
  float count : packoffset(c12);
  float seed : packoffset(c12.y);
  float2 scaleMin : packoffset(c12.z);
  float2 scaleMax : packoffset(c13);
  float2 lifeMaxMin : packoffset(c13.z);
  float2 fadeInMaxMin : packoffset(c14);
  float2 fadeOutMaxMin : packoffset(c14.z);
  float2 pauseMaxMin : packoffset(c15);
  float2 stretchMaxMin : packoffset(c15.z);
  float2 slideMaxMin : packoffset(c16);
  float2 heightMaxMin : packoffset(c16.z);
  float2 warpMaxMin : packoffset(c17);
  float2 jitterMaxMin : packoffset(c17.z);
  float2 rotationMaxMin : packoffset(c18);
  float falseElapsedTime : packoffset(c18.z);
  bool useOverride : packoffset(c18.w);
  float screenDistanceFade : packoffset(c19);
  float highlightFalloff : packoffset(c19.y);
  float highlightBrightness : packoffset(c19.z);
  float highlightMin : packoffset(c19.w);
}

cbuffer GenericsCBuffer : register(b3)
{
  float4 scriptVector0 : packoffset(c0);
  float4 scriptVector1 : packoffset(c1);
  float4 scriptVector2 : packoffset(c2);
  float4 scriptVector3 : packoffset(c3);
  float4 scriptVector4 : packoffset(c4);
  float4 scriptVector5 : packoffset(c5);
  float4 scriptVector6 : packoffset(c6);
  float4 scriptVector7 : packoffset(c7);
  float4 weaponParam0 : packoffset(c8);
  float4 weaponParam1 : packoffset(c9);
  float4 weaponParam2 : packoffset(c10);
  float4 weaponParam3 : packoffset(c11);
  float4 weaponParam4 : packoffset(c12);
  float4 weaponParam5 : packoffset(c13);
  float4 weaponParam6 : packoffset(c14);
  float4 weaponParam7 : packoffset(c15);
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

SamplerState trilinearSampler_s : register(s1);
Texture2D<float4> specHighlightMap : register(t0);
Texture2D<float4> maskMap : register(t6);
Texture2D<float4> colorMap : register(t7);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD3,
  float4 v2 : TEXCOORD2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(w1.xy, w1.xy);
  r0.x = rsqrt(r0.x);
  r0.yz = renderTargetSize.zw * v0.xy;
  r1.xy = r0.yz * float2(2,2) + float2(-1,-1);
  r0.xw = -w1.xy * r0.xx + r1.xy;
  r0.x = dot(r0.xw, r0.xw);
  r0.x = sqrt(r0.x);
  r0.x = 0.707213581 * r0.x;
  r0.x = min(1, r0.x);
  r1.xy = saturate(scriptVector0.wx);
  r0.w = screenDistanceFade * r1.x;
  r1.xz = float2(0.00052083336,0.00092592591) * r0.ww;
  r0.w = max(r1.x, r1.z);
  r0.x = -r0.w * 0.5 + r0.x;
  r0.w = 0.5 * r0.w;
  r0.w = 1 / r0.w;
  r0.x = saturate(r0.x * r0.w);
  r0.w = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = -r0.w * r0.x + 1;
  r0.w = maskMap.Sample(trilinearSampler_s, r0.yz).x;
  r2.xyzw = specHighlightMap.Sample(trilinearSampler_s, r0.yz).xyzw;
  r0.y = r0.w * r1.y;
  r0.x = r0.y * r0.x;
  r0.yz = float2(0.0174532924,0.0174532924) * scriptVector1.yx;
  sincos(r0.yz, r1.xy, r3.xy);
  r4.x = r3.x * r3.y;
  r4.y = r3.y * r1.x;
  r4.z = r1.y;
  r0.y = saturate(dot(cameraLook.xyz, r4.xyz));
  r0.y = log2(r0.y);
  r0.y = highlightFalloff * r0.y;
  r0.y = exp2(r0.y);
  r0.y = highlightBrightness * r0.y;
  r0.y = saturate(r2.w * r0.y + highlightMin);
  r0.y = r0.y * r0.x;
  r0.yzw = r2.xyz * r0.yyy;
  r1.xyzw = colorMap.Sample(trilinearSampler_s, v1.xy).xyzw;
  r0.x = r1.w * r0.x;
  r1.xyz = r1.xyz * r0.xxx;
  r0.x = saturate(v2.z);
  r0.xyz = r1.xyz * r0.xxx + r0.yzw;

  o0.xyz = float3(32768,32768,32768) * r0.xyz; //this causes the super bright, so scale it down
  o0.xyz *= CUSTOM_SLIDE_LENS_DIRT;

  o0.w = 0;
  return;
}