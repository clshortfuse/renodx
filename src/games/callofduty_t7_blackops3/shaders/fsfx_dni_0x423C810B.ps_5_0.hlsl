// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 29 18:05:13 2025
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
  float blurRadius : packoffset(c10.z);
  float irisGlowAmount : packoffset(c10.w);
  float revealEdgeSoftness : packoffset(c11);
  float revealRamp : packoffset(c11.y);
  float desaturationPercent : packoffset(c11.z);
  float3 irisGlowColor : packoffset(c12);
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
Texture2D<float4> frameBuffer : register(t0);
Texture2D<float4> irisTexture : register(t6);
Texture2D<float4> maskTexture : register(t7);


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

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.zw = scriptVector1.yz + r0.xy;
  r1.x = dot(r0.zw, r0.zw);
  r1.x = rsqrt(r1.x);
  r0.zw = r1.xx * r0.zw;
  r1.x = maskTexture.Sample(trilinearSampler_s, v1.xy).x;
  r1.y = saturate(scriptVector0.x * r1.x);
  r1.z = cmp(0 < r1.y);
  r1.w = blurRadius * r1.y;
  r1.w = 0.200000003 * r1.w;
  r2.xy = renderTargetSize.zw * r1.ww;
  r2.zw = r0.zw * r2.xy + v1.xy;
  r3.xyz = frameBuffer.Sample(trilinearSampler_s, r2.zw).xyz;
  r4.xyzw = frameBuffer.Sample(trilinearSampler_s, v1.xy).xyzw;
  r2.zw = -r0.zw * r2.xy + v1.xy;
  r5.xyz = frameBuffer.Sample(trilinearSampler_s, r2.zw).xyz;
  r2.zw = -r0.zw * r2.xy + r2.zw;
  r6.xyz = frameBuffer.Sample(trilinearSampler_s, r2.zw).xyz;
  r0.zw = -r0.zw * r2.xy + r2.zw;
  r2.xyz = frameBuffer.Sample(trilinearSampler_s, r0.zw).xyz;
  if (r1.z != 0) {
    r3.xyz = r4.xyz + r3.xyz;
    r3.xyz = r3.xyz + r5.xyz;
    r3.xyz = r3.xyz + r6.xyz;
    r2.xyz = r3.xyz + r2.xyz;
    r2.xyz = float3(6.10351572e-006,6.10351572e-006,6.10351572e-006) * r2.xyz;
  } else {
    r2.xyz = float3(0,0,0);
  }
  r0.xy = scriptVector0.zz * r0.xy;
  r0.xy = saturate(r0.xy * float2(0.5,0.5) + float2(0.5,0.5));
  r3.xyzw = cmp(r0.xyxy == float4(0,0,1,1));
  r0.zw = (int2)r3.yw | (int2)r3.xz;
  r0.z = (int)r0.w | (int)r0.z;
  r0.z = r0.z ? 0 : scriptVector0.w;
  r3.xyzw = irisTexture.Sample(trilinearSampler_s, r0.xy).xyzw;
  r3.xyz = Tradeoff_PrepareFullWidthFsfx(r3.xyz, 0.05f, true);

  r0.xyw = irisGlowColor.xyz * r3.xyz;
  r1.z = saturate(-revealEdgeSoftness * 0.5 + scriptVector0.y);
  r1.w = saturate(scriptVector0.y);
  r2.w = r1.w + -r1.z;
  r1.z = r3.w + -r1.z;
  r2.w = 1 / r2.w;
  r1.z = saturate(r2.w * r1.z);
  r2.w = r1.z * -2 + 3;
  r1.z = r1.z * r1.z;
  r1.z = r2.w * r1.z;
  r2.w = saturate(revealEdgeSoftness * 0.5 + scriptVector0.y);
  r2.w = r2.w + -r1.w;
  r1.w = r3.w + -r1.w;
  r2.w = 1 / r2.w;
  r1.w = saturate(r2.w * r1.w);
  r2.w = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = -r2.w * r1.w + 1;
  r1.z = r1.z * r1.w;
  r1.z = log2(r1.z);
  r1.xz = desaturationPercent * r1.xz;
  r1.z = exp2(r1.z);
  r0.z = irisGlowAmount * r1.z + r0.z;
  r3.xyz = float3(3.05175781e-005,3.05175781e-005,3.05175781e-005) * r4.xyz;
  r2.xyz = -r4.xyz * float3(3.05175781e-005,3.05175781e-005,3.05175781e-005) + r2.xyz;
  r1.yzw = r1.yyy * r2.xyz + r3.xyz;
  r1.x = saturate(scriptVector1.x * r1.x);
  r2.x = dot(r1.yzw, float3(0.212599993,0.715200007,0.0722000003));
  r2.xyz = r2.xxx + -r1.yzw;
  r1.xyz = r1.xxx * r2.xyz + r1.yzw;
  r0.xyz = r0.xyw * r0.zzz + r1.xyz;
  o0.xyz = float3(32768,32768,32768) * r0.xyz;


  o0.w = r4.w;
  return;
}