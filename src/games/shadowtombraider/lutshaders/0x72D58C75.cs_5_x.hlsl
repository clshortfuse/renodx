#include "../shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Feb  4 18:09:47 2025

cbuffer SceneBuffer : register(b2) {
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

cbuffer ColorGradingCB : register(b0) {
  float g_lutSize : packoffset(c0);
  float g_saturation : packoffset(c0.y);
  float g_pmBrightness : packoffset(c0.z);
  float g_pmSaturation : packoffset(c0.w);
  float g_dvBlend : packoffset(c1);
  float g_dvScale1 : packoffset(c1.y);
  float g_dvScale2 : packoffset(c1.z);
  float __colorGrading_pad0 : packoffset(c1.w);
  float2 g_dvOffset1 : packoffset(c2);
  float2 g_dvOffset2 : packoffset(c2.z);
  float2 g_vigParams : packoffset(c3);
  float2 g_vigCenterPoint : packoffset(c3.z);
  float4 g_vigColInner : packoffset(c4);
  float4 g_vigColOuter : packoffset(c5);
}

SamplerState SamplerGenericBilinearClamp_s : register(s13);
Texture3D<float4> lut : register(t1);
Texture2D<float3> colorBuffer_in : register(t6);
RWTexture2D<float3> colorBuffer : register(u0);

// 3Dmigoto declarations
#define cmp -

[numthreads(8, 8, 1)]
void main(uint2 vThreadID: SV_DispatchThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 8, 8, 1
  r0.xy = (uint2)ScreenResolution.xy;
  r0.xy = cmp((uint2)vThreadID.xy < (uint2)r0.xy);
  r0.x = r0.y ? r0.x : 0;
  if (r0.x != 0) {
    r0.xy = vThreadID.xy;
    r0.zw = float2(0, 0);
    r0.xyz = colorBuffer_in.Load(r0.xyz).xyz;

    float3 input_color = r0.xyz;

    r1.x = dot(float3(0.412390888, 0.357584298, 0.180480838), r0.xyz);
    r1.y = dot(float3(0.212639064, 0.715168595, 0.0721923336), r0.xyz);
    r1.z = dot(float3(0.0193308201, 0.119194724, 0.950532317), r0.xyz);
    r0.x = dot(float3(1.01303494, 0.00610530004, -0.0149709601), r1.xyz);
    r0.y = dot(float3(0.00769822998, 0.998164833, -0.0050321999), r1.xyz);
    r0.z = dot(float3(-0.00284131011, 0.00468514999, 0.924506664), r1.xyz);
    r1.x = dot(float3(1.6410234, -0.324803293, -0.236424699), r0.xyz);
    r1.y = dot(float3(-0.663662851, 1.61533165, 0.0167563483), r0.xyz);
    r1.z = dot(float3(0.0117218941, -0.00828444213, 0.988394856), r0.xyz);
    r0.xyz = cmp(r1.xyz < float3(1.52587891e-05, 1.52587891e-05, 1.52587891e-05));
    r2.xyz = r1.xyz * float3(0.5, 0.5, 0.5) + float3(1.52587891e-05, 1.52587891e-05, 1.52587891e-05);
    r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(9.72000027, 9.72000027, 9.72000027) + r0.xyz;
    r0.xyz = float3(0.0570776239, 0.0570776239, 0.0570776239) * r0.xyz;
    r0.w = -1 + g_lutSize;
    r0.w = r0.w / g_lutSize;
    r1.x = 0.5 / g_lutSize;
    r0.xyz = r0.xyz * r0.www + r1.xxx;
    r0.xyz = lut.SampleLevel(SamplerGenericBilinearClamp_s, r0.xyz, 0).xyz;
    r0.xyz = max(float3(-0.301369876, -0.301369876, -0.301369876), r0.xyz);
    r0.xyz = r0.xyz * float3(17.5200005, 17.5200005, 17.5200005) + float3(-9.72000027, -9.72000027, -9.72000027);
    r0.xyz = exp2(r0.xyz);
    r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);
    r1.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r0.xyz);
    r1.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r0.xyz);
    r1.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r0.xyz);
    r0.x = dot(float3(0.987223983, -0.00611326983, 0.0159533005), r1.xyz);
    r0.y = dot(float3(-0.00759836007, 1.00186002, 0.00533019984), r1.xyz);
    r0.z = dot(float3(0.00307257008, -0.00509594986, 1.08168006), r1.xyz);
    r1.x = dot(float3(3.2409699, -1.5373832, -0.498610765), r0.xyz);
    r1.y = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r0.xyz);
    r1.z = dot(float3(0.0556300804, -0.203976959, 1.05697155), r0.xyz);
    
    r1.xyz = lerp(input_color, r1.xyz, CUSTOM_LUT_STRENGTH);

    r0.x = dot(r1.xyz, float3(0.212599993, 0.715300024, 0.0722000003));
    r1.xyzw = r1.xyzx + -r0.xxxx;
    r0.xyzw = g_saturation * r1.xyzw + r0.xxxx;
    r0.xyzw = g_pmBrightness * r0.xyzw;
    // No code for instruction (needs manual fix):
    // store_uav_typed u0.xyzw, vThreadID.xyyy, r0.xyzw
    colorBuffer[vThreadID.xy] = r0.xyz;
  }
  return;
}
