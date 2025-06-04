#include "../common.hlsl"

Texture2D<float4> g_SourceTexture : register(t0);

cbuffer cbPostProcessCommon : register(b4) {
  float2 g_dynamicScreenPercentage : packoffset(c000.x);
  float2 g_texSizeReciprocal : packoffset(c000.z);
  float2 g_dynamicScreenPercentage_Primary : packoffset(c001.x);
  float2 g_primaryTexSizeReciprocal : packoffset(c001.z);
  float2 g_dynamicScreenPercentage_Prev : packoffset(c002.x);
  float2 g_prevTexSizeReciprocal : packoffset(c002.z);
  float2 g_dynamicScreenPercentage_PrevPrimary : packoffset(c003.x);
  float2 g_prevPrimaryTexSizeReciprocal : packoffset(c003.z);
};

cbuffer cbToneMap : register(b1) {
  float3 g_ToneMapInvSceneLumScale : packoffset(c000.x);
  float4 g_ReinhardParam : packoffset(c001.x);
  float4 g_ToneMapParam : packoffset(c002.x);
  float4 g_ToneMapSceneLumScale : packoffset(c003.x);
  float4 g_AdaptParam : packoffset(c004.x);
  float4 g_AdaptCenterWeight : packoffset(c005.x);
  float4 g_BrightPassThreshold : packoffset(c006.x);
  float4 g_GlareLuminance : packoffset(c007.x);
  float4 g_BloomBoostColor : packoffset(c008.x);
  float4 g_vBloomFinalColor : packoffset(c009.x);
  float4 g_vBloomScaleParam : packoffset(c010.x);
  float4 g_mtxColorMultiplyer[3] : packoffset(c011.x);
  float4 g_vChromaticAberrationRG : packoffset(c014.x);
  float4 g_vChromaticAberrationB : packoffset(c015.x);
  int4 g_bEnableFlags : packoffset(c016.x);
  float4 g_vFeedBackBlurParam : packoffset(c017.x);
  float4 g_vVignettingParam : packoffset(c018.x);
  float4 g_vHDRDisplayParam : packoffset(c019.x);
  float4 g_vChromaticAberrationShapeParam : packoffset(c020.x);
  float4 g_vScreenSize : packoffset(c021.x);
  float4 g_vSampleDistanceAdjust : packoffset(c022.x);
  uint4 g_vMaxSampleCount : packoffset(c023.x);
  float4 g_vScenePreExposure : packoffset(c024.x);
  float4 g_vCameraParam : packoffset(c025.x);
  float4 g_vLocalExposureParam : packoffset(c026.x);
  float4 g_vLocalExposureTexScale : packoffset(c027.x);
  uint g_LocalExposureMode : packoffset(c028.x);
  float g_LocalExposureDetailBoost : packoffset(c028.y);
  float2 g_LocalExposureLumMinMax : packoffset(c028.z);
  float g_LocalExposureModeRate : packoffset(c029.x);
  uint padd0 : packoffset(c029.y);
  uint2 padd1 : packoffset(c029.z);
  float4 g_vVignettingColor : packoffset(c030.x);
};

SamplerState SS_ClampLinear : register(s3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float3 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  if (CUSTOM_FX_CHROMATIC_ABERRATION) {
    float _9 = (TEXCOORD.x * 2.0f) + -1.0f;
    float _10 = (TEXCOORD.y * 2.0f) + -1.0f;
    float _27 = g_dynamicScreenPercentage.x - (g_texSizeReciprocal.x * 0.5f);
    float _28 = g_dynamicScreenPercentage.y - (g_texSizeReciprocal.y * 0.5f);
    float4 _31 = g_SourceTexture.SampleLevel(SS_ClampLinear, float2(min((((g_vChromaticAberrationRG.x * _9) + TEXCOORD.x) * g_dynamicScreenPercentage.x), _27), min((((_10 * g_vChromaticAberrationRG.y) + TEXCOORD.y) * g_dynamicScreenPercentage.y), _28)), 0.0f);
    float4 _43 = g_SourceTexture.SampleLevel(SS_ClampLinear, float2(min((((g_vChromaticAberrationRG.z * _9) + TEXCOORD.x) * g_dynamicScreenPercentage.x), _27), min((((g_vChromaticAberrationRG.w * _10) + TEXCOORD.y) * g_dynamicScreenPercentage.y), _28)), 0.0f);
    float4 _56 = g_SourceTexture.SampleLevel(SS_ClampLinear, float2(min((((g_vChromaticAberrationB.x * _9) + TEXCOORD.x) * g_dynamicScreenPercentage.x), _27), min((((g_vChromaticAberrationB.y * _10) + TEXCOORD.y) * g_dynamicScreenPercentage.y), _28)), 0.0f);
    SV_Target.x = _31.x;
    SV_Target.y = _43.y;
    SV_Target.z = _56.z;
  } else {
    SV_Target.rgb = g_SourceTexture.SampleLevel(SS_ClampLinear, float2(g_dynamicScreenPercentage.x * TEXCOORD.x, g_dynamicScreenPercentage.y * TEXCOORD.y), 0.0f).rgb;
  }
  SV_Target.w = 1.0f;
  return SV_Target;
}
