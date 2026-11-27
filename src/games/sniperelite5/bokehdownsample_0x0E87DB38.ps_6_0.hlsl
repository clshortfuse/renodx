#include "./shared.h"

Texture2D<float4> g_xUserTexture0 : register(t3);

Texture2D<float4> g_xUserTexture1 : register(t4);

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

cbuffer BokehPSConstants : register(b9) {
  float4 g_xFocusPlaneParams : packoffset(c000.x);
  float2 g_xBlurDir0 : packoffset(c001.x);
  float2 g_xBlurDir1 : packoffset(c001.z);
  float2 g_xBlurDir2 : packoffset(c002.x);
  float g_fPower : packoffset(c002.z);
  float g_fInversePower : packoffset(c002.w);
  float g_fDesaturationFactor : packoffset(c003.x);
  float g_fIntensity : packoffset(c003.y);
  float g_fSkyFarPlane : packoffset(c003.z);
};

SamplerState g_xPointClamp : register(s1);

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = g_xUserTexture0.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _13 = g_xUserTexture1.SampleLevel(g_xPointClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _18 = g_xDepthProjViewUnpack.y - _13.x;
  float _19 = g_xDepthProjViewUnpack.x / _18;
  float _22 = _19 - g_xFocusPlaneParams.x;
  float _24 = _22 * g_xFocusPlaneParams.y;
  float _25 = saturate(_24);
  float _26 = 1.0f - _25;
  float _28 = _19 - g_xFocusPlaneParams.z;
  float _30 = _28 * g_xFocusPlaneParams.w;
  float _31 = saturate(_30);
  float _32 = _26 + _31;
  float _33 = saturate(_32);
  float _34 = dot(float3(_9.x, _9.y, _9.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
  float _37 = _34 - _9.x;
  float _38 = _34 - _9.y;
  float _39 = _34 - _9.z;
  float _40 = g_fDesaturationFactor * _37;
  float _41 = g_fDesaturationFactor * _38;
  float _42 = g_fDesaturationFactor * _39;
  float _43 = _40 + _9.x;
  float _44 = _41 + _9.y;
  float _45 = _42 + _9.z;
  float _48 = abs(_43);
  float _49 = abs(_44);
  float _50 = abs(_45);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float _cap = exp2(15.0f / max(g_fPower, 1e-3f));
    _48 = min(_48, _cap);
    _49 = min(_49, _cap);
    _50 = min(_50, _cap);
  }
  float _51 = log2(_48);
  float _52 = log2(_49);
  float _53 = log2(_50);
  float _54 = _51 * g_fPower;
  float _55 = _52 * g_fPower;
  float _56 = _53 * g_fPower;
  float _57 = exp2(_54);
  float _58 = exp2(_55);
  float _59 = exp2(_56);
  float _60 = max(_33, 0.0010000000474974513f);
  float _61 = _60 * _57;
  float _62 = _60 * _58;
  float _63 = _60 * _59;
  SV_Target.x = _61;
  SV_Target.y = _62;
  SV_Target.z = _63;
  SV_Target.w = _60;
  return SV_Target;
}
