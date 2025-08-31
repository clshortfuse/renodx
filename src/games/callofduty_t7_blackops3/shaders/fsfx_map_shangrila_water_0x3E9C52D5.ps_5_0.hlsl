// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 02 14:38:56 2025

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
  float refractionAmount : packoffset(c10.z);
  float2 normalScroll : packoffset(c11);
  float2 normalTile : packoffset(c11.z);
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

SamplerState bilinearSampler_s : register(s1);
Texture2D<float4> frameBuffer : register(t0);
Texture2D<float4> revealMap : register(t6);
Texture2D<float4> colorMap : register(t7);
Texture2D<float4> normalMap : register(t9);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = revealMap.Sample(bilinearSampler_s, v1.xy).x;
  r0.y = cmp(0.5 < scriptVector0.y);
  r0.z = 1 + -r0.x;
  r0.x = r0.y ? r0.z : r0.x;
  r0.y = saturate(scriptVector0.x * 0.998000026 + 0.00100000005);
  r0.z = 1 + -r0.y;
  r0.w = saturate(alphaRevealRamp);
  r0.y = log2(r0.y);
  r0.y = r0.w * r0.y;
  r0.y = exp2(r0.y);
  r1.x = -r0.y;
  r0.y = log2(r0.z);
  r0.y = r0.w * r0.y;
  r1.y = exp2(r0.y);
  r0.yz = saturate(alphaRevealSoftEdge * r1.xy + r0.zz);
  r0.x = r0.x + -r0.y;
  r0.y = r0.z + -r0.y;
  r0.x = saturate(r0.x / r0.y);
  r0.yz = gameTime.ww * normalScroll.xy;
  r0.yz = v1.xy * normalTile.xy + r0.yz;
  r0.w = cmp(0 < r0.x);
  r1.x = cmp(0 < refractionAmount);
  r0.w = r0.w ? r1.x : 0;
  r1.xy = normalMap.Sample(bilinearSampler_s, r0.yz).xy;
  if (r0.w != 0) {
    r1.zw = renderTargetSize.zw * refractionAmount;
    r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
    r1.xy = r1.xy * r0.xx;
    r1.xy = r1.zw * r1.xy;
  } else {
    r1.xy = float2(0,0);
  }
  
  r2.xyzw = colorMap.Sample(bilinearSampler_s, r0.yz).xyzw;
  r2.xyzw = float4(1,1,1,0.5); //clear water texture
  // r2.xyz = Tradeoff_PrepareFullWidthFsfx(r2.xyz, 0.05f, true);


  r0.yz = saturate(v1.xy + r1.xy);
  r1.xyzw = frameBuffer.Sample(bilinearSampler_s, r0.yz).xyzw;
  r0.yzw = float3(3.05175781e-005,3.05175781e-005,3.05175781e-005) * r1.xyz;
  r0.x = r2.w * r0.x;
  r3.xyz = r2.xyz * r0.xxx;
  r4.xyz = cmp(r3.xyz < float3(0.5,0.5,0.5));
  r1.xyz = float3(6.10351563e-005,6.10351563e-005,6.10351563e-005) * r1.xyz;
  r5.xyz = r0.yzw * r0.yzw;
  r6.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r5.xyz = r6.xyz * r5.xyz;
  r5.xyz = r1.xyz * r3.xyz + r5.xyz;
  r0.yzw = sqrt(r0.yzw);
  r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.xyz = -r2.xyz * r0.xxx + float3(1,1,1);
  r1.xyz = r2.xyz * r1.xyz;
  r0.xyz = r0.yzw * r3.xyz + r1.xyz;
  r0.xyz = r4.xyz ? r5.xyz : r0.xyz;

  o0.xyz = float3(32768,32768,32768) * r0.xyz ;
  o0.w = r1.w;
  return;
}