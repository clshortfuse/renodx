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

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float3 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _5 = min(0.9998999834060669f, ((TEXCOORD.x * 1.0009775161743164f) + -0.0004887585528194904f));
  float _15 = exp2(log2(g_ReinhardParam.y * ((_5 * 0.20000000298023224f) / (1.0f - _5))) * g_ReinhardParam.x);
  float _23 = exp2(log2(_15 / (_15 + 1.0f)) * (1.0f / g_ToneMapParam.y));
  SV_Target.x = _23;
  SV_Target.y = _23;
  SV_Target.z = _23;
  SV_Target.w = 1.0f;
  return SV_Target;
}
