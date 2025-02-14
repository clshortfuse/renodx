#include "../shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Feb  4 18:09:49 2025

struct ExposureInfo
{
    float frameLuminanceAverage;   // Offset:    0
    float currentAverageEv;        // Offset:    4
    float frameOptimalEv;          // Offset:    8
    float previousCameraExposure;  // Offset:   12
    float previousCameraInvExposure;// Offset:   16
    float cameraExposure;          // Offset:   20
    float cameraInvExposure;       // Offset:   24
    float _exposureInfo_pad0;      // Offset:   28
    float cameraExposureInternal;  // Offset:   32
    float cameraInvExposureInternal;// Offset:   36
    float previousCameraExposureInternal;// Offset:   40
    float previousCameraInvExposureInternal;// Offset:   44
    uint luminanceIndex;           // Offset:   48
    uint luminanceCount;           // Offset:   52
    float frameHistogramMax;       // Offset:   56
    float frameHistogramPixelCount;// Offset:   60
    float luminanceHistory[16];    // Offset:   64
    uint frameHistogram[64];       // Offset:  128
};

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

SamplerState SamplerGenericAutoWrap_s : register(s6);
Texture2D<float4> p_default_Material_051164A4424935531_Param_texture : register(t0);
StructuredBuffer<ExposureInfo> FrameExposureBuffer : register(t57);
RWTexture2D<uint4> VelocityBuffer_uav : register(u1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : POSITION1,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD0,
  nointerpolation uint v4 : PSIZE0,
  uint v5 : SV_SampleIndex0,
  out float4 o0 : SV_TARGET0)
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture2d (uint,uint,uint,uint) u1
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = mad((int3)v4.xxx, int3(9,9,9), int3(3,4,5));
  r0.w = p_default_Material_051164A4424935531_Param_texture.Sample(SamplerGenericAutoWrap_s, v3.xy).w;
  r1.w = v2.w * r0.w;
  r1.xyz = v2.xyz;
  r1.xyzw = r1.xyzw * InstanceParametersBuffer[r0.x].xyzw + InstanceParametersBuffer[r0.y].xyzw;
  r0.xyw = r1.xyz * r1.www;
  r0.xyw = UiAlphaMultiplier * r0.xyw * RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  r0.z = cmp(0.000000 == InstanceParametersBuffer[r0.z].x);
  r1.x = v4.x;
  r1.x = __InstancedMaterialOpacity[r1.x].x * r1.w;
  r1.y = FrameExposureBuffer[0].cameraExposure;
  o0.xyz = r1.yyy * r0.xyw;
  r0.x = GlobalRenderFlags & 2048;
  r0.x = cmp((int)r0.x == 0);
  r0.x = r0.x ? r0.z : 0;
  r0.y = cmp(TranslucentVelocityAlphaThreshold < r1.x);
  r0.x = r0.y ? r0.x : 0;
  if (r0.x != 0) {
    r0.xy = v0.xy * ScreenExtents.zw + ScreenExtents.xy;
    r0.xy = float2(-0.5,-0.5) + r0.xy;
    r0.zw = v1.xy / v1.ww;
    r0.xy = r0.xy * float2(2,-2) + -NdcOffset.xy;
    r0.xy = r0.xy + -r0.zw;
    r0.xy = float2(0.5,-0.5) * r0.xy;
    r0.z = -v1.w + v0.w;
    // r1.yz = DrawableFlags & int2(1,2);
    // r0.w = GlobalRenderFlags & 4096;
    // r1.yz = r1.yz ? float2(1.40129846e-45,1.40129846e-45) : float2(0,0);
    r1.yz = DrawableFlags & int2(1, 2) ? int2(1, 1) : float2(0, 0);
    r1.y = mad((int)r1.z, 2, (int)r1.y);
    // r0.w = r0.w ? 1 : 0;
    r0.w = GlobalRenderFlags & 4096 ? 1 : 0;
    r2.w = mad((int)r0.w, 4, (int)r1.y);
    r0.xyz = max(float3(-65504,-65504,-65504), r0.xyz);
    r0.xyz = min(float3(65504,65504,65504), r0.xyz);
    r2.xyz = f32tof16(r0.xyz);
    r0.xyzw = (uint4)v0.xyyy;
    // No code for instruction (needs manual fix):
    // store_uav_typed u1.xyzw, r0.xyzw, r2.xyzw
    VelocityBuffer_uav[r0.xy] = r2;
  }
  o0.w = r1.x;
  return;
}