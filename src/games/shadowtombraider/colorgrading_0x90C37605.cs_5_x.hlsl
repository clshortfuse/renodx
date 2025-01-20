#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 03 06:54:28 2024

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
RWTexture2D<float3> colorBuffer : register(u0);

// 3Dmigoto declarations
#define cmp -

float3 LinearToACEScc(float3 value) {
  const float THRESHOLD = 0.0078125f;

  float3 logRegion = (log2(value) + 9.72f) / 17.52f;
  float3 linearRegion = 17.52f * value + 0.0729055341958355f;

  return lerp(logRegion, linearRegion, step(value, THRESHOLD));
}

float3 ACESccToLinear(float3 value) {
  const float THRESHOLD1 = 0.155251141552511f;
  const float OFFSET = 0.0729055341958355f;
  const float SCALE = 10.5402377416545f;

  float3 linearResult = (value - OFFSET) / SCALE;         // For values <= THRESHOLD1
  linearResult = lerp(pow(2.0f, value * 17.52f - 9.72f),  // For intermediate values
                      linearResult,
                      step(value, THRESHOLD1));
  return min(linearResult, 65504.0f);  // Clamp to max
}

[numthreads(8, 8, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0, r1, r2;

  r0.xy = (uint2)ScreenResolution.xy;
  r0.xy = cmp((uint2)vThreadID.xy < (uint2)r0.xy);
  r0.x = r0.y ? r0.x : 0;
  if (r0.x != 0) {
    r0.xyz = colorBuffer.Load(int3(vThreadID.xy, 0)).xyz;  // ld_uav_typed_indexable(texture2d)(float, float, float, float)r0.xyz, vThreadID.xyyy, u0.xyzw

    r1.rgb = renodx::color::ap1::from::BT709(r0.rgb);

    // AP1 -> ACEScc? seems to be different
#if 1
    r0.xyz = cmp(r1.xyz < 1.52587891e-005);
    r2.xyz = r1.xyz * 0.5 + 1.52587891e-005;
    r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = 9.72000027 + r0.xyz;
    r0.xyz = 0.0570776239 * r0.xyz;
#else
    r0.rgb = LinearToACEScc(r1.rgb);
#endif

    // LUT Sample
    r0.xyz = renodx::lut::Sample(lut, SamplerGenericBilinearClamp_s, r0.rgb, g_lutSize);
    // clamp?
    r0.xyz = max(-0.301369876, r0.xyz);

    // ACEScc -> AP1? seems to be different
#if 1
    r0.xyz = r0.xyz * 17.5200005 - 9.72000027;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = min(65504, r0.xyz);
#else
    r0.rgb = ACESccToLinear(r0.rgb);
#endif

    r1.rgb = renodx::color::bt709::from::AP1(r0.rgb);

    float grayscale = renodx::color::y::from::BT709(r1.xyz);
    r0.xyz = lerp(grayscale, r1.xyz, g_saturation);

    r0.xyz = g_pmBrightness * r0.xyz;

    colorBuffer[vThreadID.xy] = r0.xyz;  // store_uav_typed u0.xyzw, vThreadID.xyyy, r0.xyzw
  }
  return;
}
