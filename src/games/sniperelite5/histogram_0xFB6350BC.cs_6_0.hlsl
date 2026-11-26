#include "./shared.h"

Texture2D<float4> g_xTexture : register(t0);

RWTexture2D<uint> g_xHistogramUAV : register(u0);

cbuffer FrameConstants : register(b0) {
  column_major float4x4 g_xView;
  column_major float4x4 g_xProj;
  column_major float4x4 g_xViewProj;
  column_major float4x4 g_xInvView;
  column_major float4x4 g_xInvProj;
  column_major float4x4 g_xInvViewProj;
  float3 g_xCamPos;
  float g_fScaledTime;
  float4 g_xTwoOverScreenDimensions;
  float2 g_xCameraTanHalfFOV;
  float2 g_xCameraFarClipValues;
  float2 g_xRcpScreenDims;
  float2 g_xDepthProjViewUnpack;
  float4 g_axViewFrustumPlanes[6];
  int4 g_xScreenDimensions;
  float4 g_xTessCutoffAndFactors;
  float g_fTessMaxDist;
  float g_fTessRcpRange;
  float g_fDisplacementScale;
  float g_fBackFaceCutoff;
  float g_fFoliageFadeInvDistance;
  float g_fFoliageFadePower;
  bool g_bFoliageFadeEnabled;
  float g_fEnvironmentDecalBias;
  float g_fInstanceDecalBias;
  float3 g_xWindDirection;
  float g_fWindStrength;
  float3 g_xSubsurfaceScatteringWeight;
  float g_fGlobalSamplerBias;
  float3 g_xDeformationWindowCentre;
  float g_fDeformationWindowSize;
  float g_fDeformationUVDensity;
  float g_fDeformationNormalIntensity;
  float g_fRainfallIntensity;
  float g_fRainBaseWetness;
  float3 g_xRainDirection;
};

groupshared uint g_auHistogramEntry[256];

void AddToHistogram(int2 pos) {
  float luma = dot(g_xTexture.Load(int3(pos, 0)).rgb, float3(0.2127f, 0.7152f, 0.0722f));
  // RenoDX: skip non-finite samples so one NaN cannot pin the exposure
  if (!isfinite(luma)) return;
  uint bin = 0;
  if (luma < 0.002f) {
  } else {
    bin = (uint)(saturate((log2(luma) + 8.965784072875977f) * 0.07160356640815735f) * 255.0f);
  }
  // RenoDX: centre-weighted bin increment; CUSTOM_AUTO_EXPOSURE_CENTRE_WEIGHT 0 keeps the vanilla +1
  float2 uv = (float2(pos) + 0.5f) / float2(g_xScreenDimensions.xy);
  float2 d = (uv - 0.5f) * 2.0f;
  float falloff = exp(-2.0f * dot(d, d));
  InterlockedAdd(g_auHistogramEntry[bin], CUSTOM_AUTO_EXPOSURE_CENTRE_WEIGHT > 0.f ? (uint)(lerp(1.0f, falloff, CUSTOM_AUTO_EXPOSURE_CENTRE_WEIGHT) * 16.f + 0.5f) : 1u);
}

[numthreads(16, 16, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  g_auHistogramEntry[SV_GroupIndex] = 0;
  GroupMemoryBarrierWithGroupSync();

  int2 pos = int2(SV_DispatchThreadID.xy) << 1;
  if (pos.x < g_xScreenDimensions.x && pos.y < g_xScreenDimensions.y) {
    [loop]
    for (int row = 0; row < 2; row++) {
      AddToHistogram(int2(pos.x, pos.y + row));
      AddToHistogram(int2(pos.x | 1, pos.y + row));
    }
  }

  GroupMemoryBarrierWithGroupSync();
  InterlockedAdd(g_xHistogramUAV[int2(SV_GroupIndex, 0)], g_auHistogramEntry[SV_GroupIndex]);
}
