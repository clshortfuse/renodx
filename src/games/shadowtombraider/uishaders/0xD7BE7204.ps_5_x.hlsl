#include "../shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Feb  4 18:10:00 2025

cbuffer DrawableBuffer : register(b1)
{
  float4 FogColor : packoffset(c0);
  float4 DebugColor : packoffset(c1);
  float AlphaThreshold : packoffset(c2);
  float UseSSR : packoffset(c2.y);
  uint OcclusionQueryIndex : packoffset(c2.z);
  uint DrawableFlags : packoffset(c2.w);
  float4 __InstancedMaterialOpacity[256] : packoffset(c3);
}

cbuffer SceneBuffer : register(b2)
{
  row_major float4x4 View : packoffset(c0);
  row_major float4x4 ScreenMatrix : packoffset(c4);
  float4 FogParams : packoffset(c8);
  float3 __CameraPosition : packoffset(c9);
  float DebugColorAttenuation : packoffset(c9.w);
  float3 CameraDirection : packoffset(c10);
  float SkyDomeBrightness : packoffset(c10.w);
  float3 DepthFactors : packoffset(c11);
  float MSMLocalShadowDownSizeFactor : packoffset(c11.w);
  float3 ShadowDepthBiasAndLightType : packoffset(c12);
  float SkyDomeRotation : packoffset(c12.w);
  float4 SubframeViewport : packoffset(c13);
  row_major float3x4 DepthToWorld : packoffset(c14);
  float4 DepthToView : packoffset(c17);
  float4 DepthToW : packoffset(c18);
  float4 ClipPlane : packoffset(c19);
  float2 ViewportDepthScaleOffset : packoffset(c20);
  float2 ColorDOFDepthScaleOffset : packoffset(c20.z);
  float Time : packoffset(c21);
  float DeltaTime : packoffset(c21.y);
  float PreviousTime : packoffset(c21.z);
  uint GlobalRenderDebugFlags : packoffset(c21.w);
  float4 FogParams2 : packoffset(c22);
  float4 FogParams3 : packoffset(c23);
  float4 GlobalAmbient : packoffset(c24);
  float4 GlobalParams[16] : packoffset(c25);
  float4 ViewToFogH : packoffset(c41);
  float4 ScreenExtents : packoffset(c42);
  float4 ScreenResolution : packoffset(c43);
  float4 PSSMToMap1Lin : packoffset(c44);
  float4 PSSMToMap1Const : packoffset(c45);
  float4 PSSMToMap2Lin : packoffset(c46);
  float4 PSSMToMap2Const : packoffset(c47);
  float4 PSSMToMap3Lin : packoffset(c48);
  float4 PSSMToMap3Const : packoffset(c49);
  float4 PSSMDistance : packoffset(c50);
  row_major float4x4 ViewToPSSM0 : packoffset(c51);
  row_major float4x4 ViewToPSSMLastCascade : packoffset(c55);
  float4 ShadowAtlasResolution : packoffset(c59);
  float4 UnitRimData[3] : packoffset(c60);
  float3 __CameraPositionForCorrection : packoffset(c63);
  float VfxHdrScale : packoffset(c63.w);
  row_major float4x4 CameraViewProject : packoffset(c64);
  float4 BackBufferResolution : packoffset(c68);
  row_major float4x4 InverseProjection : packoffset(c69);
  float4 StereoOffset : packoffset(c73);
  float4 StereoOffsetY : packoffset(c74);
  row_major float4x4 Projection : packoffset(c75);
  row_major float4x4 ViewInv : packoffset(c79);
  float4 ColorSSAO : packoffset(c83);
  float4 GlobalFogColor : packoffset(c84);
  float4 VolumetricLightGlobalParams : packoffset(c85);
  float4 SnowParams01 : packoffset(c86);
  float4 SnowParams02 : packoffset(c87);
  float4 SnowParams03 : packoffset(c88);
  float4 FogFactorNoiseBlendScrollParams : packoffset(c89);
  float4 FogNoiseScaleParams : packoffset(c90);
  float4 UnitWindParams : packoffset(c91);
  float3 FluidSimulationParams : packoffset(c92);
  float UiAlphaMultiplier : packoffset(c92.w);
  uint GlobalRenderFlags : packoffset(c93);
  uint SunCascadeEndIndex : packoffset(c93.y);
  float2 ScreenResolutionScaleFactor : packoffset(c93.z);
  float3 CameraWaterExtinction : packoffset(c94);
  float CameraWaterLevel : packoffset(c94.w);
  float2 NdcOffset : packoffset(c95);
  float HairMaxElements : packoffset(c95.z);
  float GGXDebugMode : packoffset(c95.w);
  float2 DitheringPatternOffset : packoffset(c96);
  float TranslucentVelocityAlphaThreshold : packoffset(c96.z);
  float GlobalRenderFrameIndex : packoffset(c96.w);
  float4 GazeConfig : packoffset(c97);
  float4 GazeParams : packoffset(c98);
  uint msaaCoverageTestMask : packoffset(c99);
  float Padding[3] : packoffset(c100);
}

cbuffer CB_Instance : register(b4)
{
  float4 InstanceParametersBuffer[4096] : packoffset(c0);
}



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  nointerpolation uint v2 : PSIZE0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = mad((int3)v2.xxx, int3(9,9,9), int3(2,3,4));
  r0.yz = InstanceParametersBuffer[r0.y].xw * v1.xw + InstanceParametersBuffer[r0.z].xw;
  r0.y = -1 + r0.y;
  r0.y = r0.z * r0.y + 1;
  r0.x = -r0.y * InstanceParametersBuffer[r0.x].x + 1;
  r0.x = UiAlphaMultiplier * r0.x * RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  r0.y = v2.x;
  o0.w = __InstancedMaterialOpacity[r0.y].x * r0.x;
  o0.xyz = float3(0,0,0);
  return;
}