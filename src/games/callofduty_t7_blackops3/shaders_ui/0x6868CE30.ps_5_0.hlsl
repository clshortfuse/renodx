// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 16:55:42 2025

//Pause screen: Menu title

#include "../shared.h"

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

SamplerState tileMipBilinearSampler_s : register(s1);
Texture2D<float4> colorMapSampler : register(t0);
Texture2D<float4> colorMapSampler1 : register(t6);
Texture2D<float4> colorMapSampler2 : register(t7);
Texture2D<float4> colorMapSampler3 : register(t9);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  if (!CUSTOM_SHOW_HUD) discard;

  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = gameTime.z;
  r1.x = dot(gameTime.zz, float2(81.2394867,17.3480244));
  r0.y = frac(r1.x);
  r0.z = dot(r0.yz, float2(81.2394867,17.3480244));
  r0.w = frac(r0.z);
  r0.z = dot(r0.yw, float2(81.2394867,17.3480244));
  r0.x = frac(r0.z);
  r0.z = dot(r0.xw, float2(81.2394867,17.3480244));
  r0.y = frac(r0.z);
  r0.zw = v0.xy / scriptVector4.yy;
  colorMapSampler3.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
  r1.xy = uiDest.xy;
  r1.xy = (uint2)r1.xy;
  r0.xy = r0.xy * r1.xy + r0.zw;
  r0.zw = r0.xy * r1.xy;
  r0.zw = cmp(r0.zw >= -r0.zw);
  r0.zw = r0.zw ? r1.xy : -r1.xy;
  r1.xy = float2(1,1) / r0.zw;
  r0.xy = r1.xy * r0.xy;
  r0.xy = frac(r0.xy);
  r0.xy = r0.zw * r0.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r0.xyz = colorMapSampler3.Load(r0.xyz).xyz;
  r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.xyz = scriptVector4.xxx * r0.xyz;
  r1.xy = scriptVector0.xx * float2(-0.00133333332,-0.00133333332) + v2.xy;
  r1.xyz = colorMapSampler.Sample(tileMipBilinearSampler_s, r1.xy).xyz;
  r0.w = dot(r1.xyz, float3(1,1,1));
  r0.w = 0.200000003 * r0.w;
  r1.xyzw = scriptVector0.xxxx * float4(-0.00399999972,-0.00399999972,-0.0106666666,-0.0106666666) + v2.xyxy;
  r1.z = colorMapSampler.Sample(tileMipBilinearSampler_s, r1.zw).z;
  r1.y = colorMapSampler.Sample(tileMipBilinearSampler_s, r1.xy).y;
  r1.w = max(r1.z, r0.w);
  r1.x = colorMapSampler.Sample(tileMipBilinearSampler_s, v2.xy).x;
  r0.w = dot(r1.xyw, float3(0.349999994,0.5,0.150000006));
  r0.w = max(r1.x, r0.w);
  r1.z = saturate(r0.w);
  r0.w = r0.w + r0.w;
  r2.x = 1 + -r1.z;
  r2.y = 0;
  r2.xyz = colorMapSampler2.Sample(tileMipBilinearSampler_s, r2.xy).xyz;
  r2.xyz = r2.xyz + -r1.xyw;
  r1.z = 0.200000003 * scriptVector0.y;
  r1.xyz = r1.zzz * r2.xyz + r1.xyw;
  r2.xy = renderTargetSize.zw * scriptVector2.xy;
  r2.xy = float2(1.33333337,1.33333337) * r2.xy;
  r2.zw = renderTargetSize.zw * v0.xy;
  r1.w = cmp(0.5 < r2.z);
  r2.z = cmp(r2.w < 0.5);
  r3.y = r2.z ? -r2.y : r2.y;
  r3.x = r1.w ? -r2.x : r2.x;
  r2.xy = v2.xy + r3.xy;
  r2.xy = max(scriptVector7.xy, r2.xy);
  r2.xy = min(scriptVector7.zw, r2.xy);
  r2.xyz = colorMapSampler.Sample(tileMipBilinearSampler_s, r2.xy).xyz;
  r2.xyz = scriptVector1.xxx * r2.xyz;
  r1.xyz = r2.xyz * float3(0.699999988,0.699999988,1) + r1.xyz;
  r1.w = dot(r2.xyz, float3(0.349999994,0.5,0.150000006));
  r0.w = saturate(max(r1.w, r0.w));
  o0.w = v1.w * r0.w;
  r2.xy = frac(v2.xy);
  r2.xyzw = colorMapSampler1.Sample(tileMipBilinearSampler_s, r2.xy).xyzw;
  r2.xyz = float3(1.99999999e-006,1.99999999e-006,1.99999999e-006) * r2.xyz;
  r0.w = saturate(r2.w + r2.w);
  r1.xyz = r2.xyz * r0.www + r1.xyz;
  o0.xyz = saturate(r0.xyz * r1.xyz + r1.xyz);
  return;
}