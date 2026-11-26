#include "./shared.h"

Texture2D<float4> g_xBlurredSkinTexture : register(t0);

Texture2D<float4> g_xAlbedoMaterialTexture : register(t1);

cbuffer FrameConstants : register(b0) {
  float4 g_xView[4] : packoffset(c000.x);
  float4 g_xProj[4] : packoffset(c004.x);
  float4 g_xViewProj[4] : packoffset(c008.x);
  float4 g_xInvView[4] : packoffset(c012.x);
  float4 g_xInvProj[4] : packoffset(c016.x);
  float4 g_xInvViewProj[4] : packoffset(c020.x);
  float3 g_xCamPos : packoffset(c024.x);
  float g_fScaledTime : packoffset(c024.w);
  float4 g_xTwoOverScreenDimensions : packoffset(c025.x);
  float2 g_xCameraTanHalfFOV : packoffset(c026.x);
  float2 g_xCameraFarClipValues : packoffset(c026.z);
  float2 g_xRcpScreenDims : packoffset(c027.x);
  float2 g_xDepthProjViewUnpack : packoffset(c027.z);
  float4 g_axViewFrustumPlanes[6] : packoffset(c028.x);
  int4 g_xScreenDimensions : packoffset(c034.x);
  float4 g_xTessCutoffAndFactors : packoffset(c035.x);
  float g_fTessMaxDist : packoffset(c036.x);
  float g_fTessRcpRange : packoffset(c036.y);
  float g_fDisplacementScale : packoffset(c036.z);
  float g_fBackFaceCutoff : packoffset(c036.w);
  float g_fFoliageFadeInvDistance : packoffset(c037.x);
  float g_fFoliageFadePower : packoffset(c037.y);
  int g_bFoliageFadeEnabled : packoffset(c037.z);
  float g_fEnvironmentDecalBias : packoffset(c037.w);
  float g_fInstanceDecalBias : packoffset(c038.x);
  float3 g_xWindDirection : packoffset(c038.y);
  float g_fWindStrength : packoffset(c039.x);
  float3 g_xSubsurfaceScatteringWeight : packoffset(c039.y);
  float g_fGlobalSamplerBias : packoffset(c040.x);
  float3 g_xDeformationWindowCentre : packoffset(c040.y);
  float g_fDeformationWindowSize : packoffset(c041.x);
  float g_fDeformationUVDensity : packoffset(c041.y);
  float g_fDeformationNormalIntensity : packoffset(c041.z);
  float g_fRainfallIntensity : packoffset(c041.w);
  float g_fRainBaseWetness : packoffset(c042.x);
  float3 g_xRainDirection : packoffset(c042.y);
};

SamplerState g_xPointClamp : register(s1);

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _11 = g_xRcpScreenDims.x * SV_Position.x;
  float _12 = g_xRcpScreenDims.y * SV_Position.y;
  float4 _13 = g_xAlbedoMaterialTexture.SampleLevel(g_xPointClamp, float2(_11, _12), 0.0f);
  // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
  bool _15 = MaterialIdEquals(_13.w, 0.007843137718737125f);
  float _23;
  float _24;
  float _25;
  float _26;
  [branch]
  if (_15) {
    float4 _17 = g_xBlurredSkinTexture.SampleLevel(g_xBilinearClamp, float2(_11, _12), 0.0f);
    _23 = _17.x;
    _24 = _17.y;
    _25 = _17.z;
    _26 = _17.w;
  } else {
    _23 = 0.0f;
    _24 = 0.0f;
    _25 = 0.0f;
    _26 = 0.0f;
  }
  SV_Target.x = _23;
  SV_Target.y = _24;
  SV_Target.z = _25;
  SV_Target.w = _26;
  return SV_Target;
}
