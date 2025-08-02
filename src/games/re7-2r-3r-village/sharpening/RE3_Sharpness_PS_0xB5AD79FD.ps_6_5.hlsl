#include "./sharpening.hlsli"

Texture2D<float4> HDRImage : register(t0);

cbuffer SceneInfo : register(b0) {
  float4 viewProjMat[4] : packoffset(c000.x);
  float4 transposeViewMat[3] : packoffset(c004.x);
  float4 transposeViewInvMat[3] : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  float4 viewProjInvMat[4] : packoffset(c014.x);
  float4 prevViewProjMat[4] : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[6] : packoffset(c025.x);
  float4 clipplane : packoffset(c031.x);
  float2 vrsVelocityThreshold : packoffset(c032.x);
  uint renderOutputId : packoffset(c032.z);
  uint SceneInfo_Reserve : packoffset(c032.w);
};

cbuffer Tonemap : register(b1) {
  float exposureAdjustment : packoffset(c000.x);
  float tonemapRange : packoffset(c000.y);
  float sharpness : packoffset(c000.z);
  float preTonemapRange : packoffset(c000.w);
  int useAutoExposure : packoffset(c001.x);
  float echoBlend : packoffset(c001.y);
  float AABlend : packoffset(c001.z);
  float AASubPixel : packoffset(c001.w);
  float ResponsiveAARate : packoffset(c002.x);
};

SamplerState PointBorder : register(s2, space32);

SamplerState BilinearClamp : register(s5, space32);

// simple sharpening shader that is applied when CAS is turned off in settings
float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _8 = HDRImage.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  // disable sharpening altogether, only enable if CAS is enabled in settings
  if (CUSTOM_SHARPENING != 1.f) {
    SV_Target = float4(_8.rgb, 0.f);
    return SV_Target;
  }

  float _18 = screenInverseSize.x * 0.5f;
  float _19 = screenInverseSize.y * 0.5f;
  float _20 = _18 + TEXCOORD.x;
  float _21 = TEXCOORD.y - _19;
  float4 _22 = HDRImage.SampleLevel(BilinearClamp, float2(_20, _21), 0.0f);
  float _29 = _19 + TEXCOORD.y;
  float4 _30 = HDRImage.SampleLevel(BilinearClamp, float2(_20, _29), 0.0f);
  float _37 = TEXCOORD.x - _18;
  float4 _38 = HDRImage.SampleLevel(BilinearClamp, float2(_37, _21), 0.0f);
  float4 _45 = HDRImage.SampleLevel(BilinearClamp, float2(_37, _29), 0.0f);
  SV_Target.x = (((saturate(((((_8.x * 5.0f) - _22.x) - _30.x) - _38.x) - _45.x) - _8.x) * sharpness) + _8.x);
  SV_Target.y = (((saturate(((((_8.y * 5.0f) - _22.y) - _30.y) - _38.y) - _45.y) - _8.y) * sharpness) + _8.y);
  SV_Target.z = (((saturate(((((_8.z * 5.0f) - _22.z) - _30.z) - _38.z) - _45.z) - _8.z) * sharpness) + _8.z);
  SV_Target.w = 0.0f;
  return SV_Target;
}
