#include "./shared.h"

Texture2D<float4> g_xLightingTexture : register(t0);

Texture2D<float4> g_xAlbedoMaterialTexture : register(t1);

Texture2D<float4> g_xPBRTexture : register(t2);

Texture2D<float4> g_xDepthStencilTexture : register(t3);

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

cbuffer ExtractScaleConstants : register(b1) {
  float2 g_xScale : packoffset(c000.x);
  float g_fMinimumStrength : packoffset(c000.z);
  float g_fStrengthScale : packoffset(c000.w);
  int g_bIncludeHair : packoffset(c001.x);
  float3 g_xPadding : packoffset(c001.y);
};

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _12 = g_xScale.x * SV_Position.x;
  float _13 = g_xScale.y * SV_Position.y;
  int _14 = int(_12);
  int _15 = int(_13);
  float4 _16 = g_xLightingTexture.Load(int3(_14, _15, 0));
  float4 _20 = g_xAlbedoMaterialTexture.Load(int3(_14, _15, 0));
  float4 _22 = g_xPBRTexture.Load(int3(_14, _15, 0));
  float4 _24 = g_xDepthStencilTexture.Load(int3(_14, _15, 0));
  float _29 = g_xDepthProjViewUnpack.y - _24.x;
  float _30 = g_xDepthProjViewUnpack.x / _29;
  // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
  bool _31 = MaterialIdEquals(_20.w, 0.007843137718737125f);
  bool _34 = (g_bIncludeHair != 0);
  bool _35 = MaterialIdEquals(_20.w, 0.01568627543747425f);
  bool _36 = _35 && _34;
  bool _37 = _31 || _36;
  bool _38 = (_30 < 3.0f);
  bool _39 = _38 && _37;
  float _43;
  float _46;
  float _60;
  float _61;
  float _62;
  float _63;
  [branch]
  if (_39) {
    [branch]
    if (_31) {
      _43 = _22.x;
    } else {
      _43 = 0.0f;
    }
    [branch]
    if (_35) {
      _46 = 1.0f;
    } else {
      _46 = _43;
    }
    float _47 = _30 + -2.0f;
    float _48 = max(_47, 0.0f);
    float _49 = 1.0f - _48;
    float _50 = _49 * _16.x;
    float _51 = _49 * _16.y;
    float _52 = _49 * _16.z;
    float _55 = g_fStrengthScale * _46;
    float _56 = _55 + g_fMinimumStrength;
    float _57 = saturate(_56);
    float _58 = _57 * _49;
    _60 = _50;
    _61 = _51;
    _62 = _52;
    _63 = _58;
  } else {
    _60 = 0.0f;
    _61 = 0.0f;
    _62 = 0.0f;
    _63 = 0.0f;
  }
  SV_Target.x = _60;
  SV_Target.y = _61;
  SV_Target.z = _62;
  SV_Target.w = _63;
  return SV_Target;
}
