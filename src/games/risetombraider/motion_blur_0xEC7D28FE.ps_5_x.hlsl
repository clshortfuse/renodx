#include "./shared.h"


cbuffer SceneBuffer : register(b2)
{
  row_major float4x4 View : packoffset(c0);
  row_major float4x4 ScreenMatrix : packoffset(c4);
  float2 DepthExportScale : packoffset(c8);
  float2 __padding0 : packoffset(c8.z);
  float4 FogParams : packoffset(c9);
  float3 __CameraPosition : packoffset(c10);
  float __padding12 : packoffset(c10.w);
  float3 CameraDirection : packoffset(c11);
  float __padding9 : packoffset(c11.w);
  float3 DepthFactors : packoffset(c12);
  float __padding10 : packoffset(c12.w);
  float3 ShadowDepthBiasAndLightType : packoffset(c13);
  float __padding11 : packoffset(c13.w);
  float4 SubframeViewport : packoffset(c14);
  row_major float3x4 DepthToWorld : packoffset(c15);
  float4 DepthToView : packoffset(c18);
  float4 OneOverDepthToView : packoffset(c19);
  float4 DepthToW : packoffset(c20);
  float4 ClipPlane : packoffset(c21);
  float2 ViewportDepthScaleOffset : packoffset(c22);
  float2 __padding1 : packoffset(c22.z);
  float2 ColorDOFDepthScaleOffset : packoffset(c23);
  float2 __padding2 : packoffset(c23.z);
  float4 TimeVector : packoffset(c24);
  float4 FogParams2 : packoffset(c25);
  float4 FogParams3 : packoffset(c26);
  float3 GlobalAmbient : packoffset(c27);
  float __padding8 : packoffset(c27.w);
  float4 GlobalParams[16] : packoffset(c28);
  float4 ViewToFogH : packoffset(c44);
  float4 ScreenExtents : packoffset(c45);
  float2 ScreenResolution : packoffset(c46);
  float2 __padding3 : packoffset(c46.z);
  float4 PSSMToMap1Lin : packoffset(c47);
  float4 PSSMToMap1Const : packoffset(c48);
  float4 PSSMToMap2Lin : packoffset(c49);
  float4 PSSMToMap2Const : packoffset(c50);
  float4 PSSMToMap3Lin : packoffset(c51);
  float4 PSSMToMap3Const : packoffset(c52);
  float4 PSSMDistances : packoffset(c53);
  row_major float4x4 WorldToPSSM0 : packoffset(c54);
  row_major float4x4 PrevViewProject : packoffset(c58);
  row_major float4x4 PrevWorld : packoffset(c62);
  row_major float4x4 ViewT : packoffset(c66);
  float4 PSSMExtents : packoffset(c70);
  float4 ShadowAtlasResolution : packoffset(c71);
  float4 UnitRimData[3] : packoffset(c72);
  float3 __CameraPositionForCorrection : packoffset(c75);
  float __padding7 : packoffset(c75.w);
  row_major float4x4 CameraViewProject : packoffset(c76);
  float4 BackBufferResolution : packoffset(c80);
  row_major float4x4 InverseProjection : packoffset(c81);
  float4 StereoOffset : packoffset(c85);
  row_major float4x4 Projection : packoffset(c86);
  row_major float4x4 ViewInv : packoffset(c90);
  float4 ColorSSAO : packoffset(c94);
  float4 GlobalFogColor : packoffset(c95);
  float4 VolumetricLightGlobalParams : packoffset(c96);
  float4 SnowParams01 : packoffset(c97);
  float4 SnowParams02 : packoffset(c98);
  float4 SnowParams03 : packoffset(c99);
  int SSREnabled : packoffset(c100);
  int __padding4 : packoffset(c100.y);
  int __padding5 : packoffset(c100.z);
  int __padding6 : packoffset(c100.w);
  float LFAOEnabled : packoffset(c101);
  float LFAODarkening : packoffset(c101.y);
  float LFAODirectionalDarkening : packoffset(c101.z);
  float LFAONormalAdjustStrength : packoffset(c101.w);
  float2 NdcOffset : packoffset(c102);
  float VelocityScale : packoffset(c102.z);
  float __padding13 : packoffset(c102.w);
}

cbuffer cbMotionBlurBilateralUpSample : register(b5)
{
  float4 g_vTexelSize : packoffset(c0);
  float4 g_vLowTexelSize : packoffset(c1);
  float4 g_vResolutionAndLowResolution : packoffset(c2);
  float g_nStencilTestValue : packoffset(c3);
  float g_nStencilTestMask : packoffset(c3.y);
}

SamplerState SamplerGenericPointClamp_s : register(s10);
Texture2D<float4> colorBuffer : register(t0);
Texture2D<float4> depthBuffer : register(t1);
Texture2D<float4> smallDepthBuffer : register(t2);
Texture2D<float4> blendFactorBuffer : register(t3);


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

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r0.x = depthBuffer.Load(r0.xyz).x;
  r0.x = r0.x * DepthToW.x + DepthToW.y;
  r0.x = 1 / r0.x;
  r1.xyzw = smallDepthBuffer.Gather(SamplerGenericPointClamp_s, v1.xy).xyzw;
  r1.xyzw = r1.wzyx * DepthToW.xxxx + DepthToW.yyyy;
  r1.xyzw = float4(1,1,1,1) / r1.xyzw;
  r0.xyzw = r1.xyzw + -r0.xxxx;
  r0.xyzw = r0.xyzw * r0.xyzw;
  r0.xyzw = float4(-0.0144269504,-0.0144269504,-0.0144269504,-0.0144269504) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r1.x = r0.x + r0.y;
  r1.x = r1.x + r0.z;
  r1.x = r1.x + r0.w;
  r1.x = cmp(r1.x < 9.99999975e-06);
  r0.xyzw = r1.xxxx ? float4(0.25,0.25,0.25,0.25) : r0.xyzw;
  r1.xy = g_vResolutionAndLowResolution.zw * v1.xy + float2(-0.5,-0.5);
  r1.xy = frac(r1.xy);
  r1.zw = float2(1,1) + -r1.yx;
  r2.xy = r1.xy * r1.zw;
  r1.x = r1.x * r1.y;
  r1.y = r1.w * r1.z;
  r1.zw = r2.xy * r0.yw;
  r0.y = r1.y * r0.x + r1.z;
  r0.y = r1.x * r0.z + r0.y;
  r0.xz = r1.yx * r0.xz;
  r0.y = r2.y * r0.w + r0.y;
  r2.xz = r0.xz / r0.yy;
  r2.yw = r1.zw / r0.yy;
  r0.x = cmp(r0.y < 9.99999975e-06);
  r0.xyzw = r0.xxxx ? float4(0.25,0.25,0.25,0.25) : r2.xyzw;
  r1.xyzw = colorBuffer.GatherRed(SamplerGenericPointClamp_s, v1.xy).xyzw;
  r2.x = r1.z;
  r3.xyzw = colorBuffer.GatherGreen(SamplerGenericPointClamp_s, v1.xy).xyzw;
  r2.y = r3.z;
  r4.xyzw = colorBuffer.GatherBlue(SamplerGenericPointClamp_s, v1.xy).xyzw;
  r2.z = r4.z;
  r5.xyzw = blendFactorBuffer.GatherRed(SamplerGenericPointClamp_s, v1.xy).xyzw;
  r2.w = r5.z;
  r2.xyzw = r2.xyzw * r0.yyyy;
  r6.x = r1.w;
  r6.y = r3.w;
  r6.z = r4.w;
  r6.w = r5.w;
  r2.xyzw = r0.xxxx * r6.xyzw + r2.xyzw;
  r6.x = r1.y;
  r6.y = r3.y;
  r1.y = r3.x;
  r6.z = r4.y;
  r1.z = r4.x;
  r6.w = r5.y;
  r1.w = r5.x;
  r2.xyzw = r0.zzzz * r6.xyzw + r2.xyzw;
  o0.xyzw = r0.wwww * r1.xyzw + r2.xyzw;
  o0.xyzw *= CUSTOM_MOTION_BLUR;
  return;
}