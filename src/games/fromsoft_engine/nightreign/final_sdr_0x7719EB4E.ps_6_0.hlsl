#include "../common.hlsl"

Texture2D<float4> HDRScene : register(t0);

Texture2D<float4> UIScene : register(t1);

cbuffer DisplayMappingData : register(b0) {
  float outputGammaForSDR : packoffset(c000.x);
  int noUIBlend : packoffset(c000.y);
  int rangeAdj : packoffset(c000.z);
  int enableDithering : packoffset(c000.w);
  float noiseIntensity : packoffset(c001.x);
  float noiseScale : packoffset(c001.y);
  float uiMaxLumScale : packoffset(c001.z);
  float uiMaxLumScaleRecp : packoffset(c001.w);
  float uiMaxNitsNormalizedLinear : packoffset(c002.x);
  float4 mtxColorConvert[3] : packoffset(c003.x);
};

SamplerState SS_ClampLinear : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  if (HandleFinal(float4(HDRScene.Sample(SS_ClampLinear, TEXCOORD_1.xy).xyz, 1.f), UIScene.Sample(SS_ClampLinear, TEXCOORD_1.xy).xyzw, SV_Target, SV_Position, true)) {
    return SV_Target;
  }

  float4 _7 = HDRScene.Sample(SS_ClampLinear, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float4 _11 = UIScene.Sample(SS_ClampLinear, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  SV_Target.x = exp2(log2((_11.w * _7.x) + _11.x) * outputGammaForSDR);
  SV_Target.y = exp2(log2((_11.w * _7.y) + _11.y) * outputGammaForSDR);
  SV_Target.z = exp2(log2((_11.w * _7.z) + _11.z) * outputGammaForSDR);
  SV_Target.w = 1.0f;
  return SV_Target;
}
