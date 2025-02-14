#include "../shared.h"

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

cbuffer MaterialBuffer : register(b3)
{
  float4 MaterialParams[512] : packoffset(c0);
}

cbuffer CB_Instance : register(b4)
{
  float4 InstanceParametersBuffer[4096] : packoffset(c0);
}

SamplerState SamplerGenericAutoWrap_s : register(s6);
Texture2D<float4> p_default_Material_n25_3F51EB7028323377_Param_texture : register(t0);
Texture2D<float4> p_default_Setup_n8_Texture_texture : register(t1);
StructuredBuffer<ExposureInfo> FrameExposureBuffer : register(t57);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  nointerpolation uint v3 : PSIZE0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * ScreenExtents.zw + ScreenExtents.xy;
  r0.xyz = p_default_Material_n25_3F51EB7028323377_Param_texture.Sample(SamplerGenericAutoWrap_s, r0.xy).xyz;
  r0.xyz = r0.xyz * MaterialParams[0].www + float3(-1,-1,-1);
  r0.w = (int)v3.x * 9;
  r0.xyz = InstanceParametersBuffer[r0.w].yyy * r0.xyz + float3(1,1,1);
  r0.xyz = v1.xyz * r0.xyz;
  r0.w = FrameExposureBuffer[0].cameraExposure;
  o0.xyz = r0.xyz * r0.www;
  r0.x = p_default_Setup_n8_Texture_texture.Sample(SamplerGenericAutoWrap_s, v2.xy).x;
  o0.w = v1.w * r0.x * CUSTOM_LENS_FLARE;
  return;
}