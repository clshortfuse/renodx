#include "../OCIO.hlsli"

Texture2D<float4> SrcTexture : register(t0);

cbuffer OutputColorAdjustment : register(b0) {
  float fGamma : packoffset(c000.x);
  float fLowerLimit : packoffset(c000.y);
  float fUpperLimit : packoffset(c000.z);
  float fConvertToLimit : packoffset(c000.w);
  float4 fConfigDrawRect : packoffset(c001.x);
  float4 fSecondaryConfigDrawRect : packoffset(c002.x);
  float2 fConfigDrawRectSize : packoffset(c003.x);
  float2 fSecondaryConfigDrawRectSize : packoffset(c003.z);
  uint uConfigMode : packoffset(c004.x);
  float fConfigImageIntensity : packoffset(c004.y);
  float fSecondaryConfigImageIntensity : packoffset(c004.z);
  float fConfigImageAlphaScale : packoffset(c004.w);
  float fGammaForOverlay : packoffset(c005.x);
  float fLowerLimitForOverlay : packoffset(c005.y);
  float fConvertToLimitForOverlay : packoffset(c005.z);
};

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  SV_Target.x = ((exp2(log2(mad(_9.z, 0.047374799847602844f, mad(_9.y, 0.33951008319854736f, (_9.x * 0.6131157279014587f)))) * fGamma) * fConvertToLimit) + fLowerLimit);
  SV_Target.y = ((exp2(log2(mad(_9.z, 0.013449129648506641f, mad(_9.y, 0.9163550138473511f, (_9.x * 0.07019715756177902f)))) * fGamma) * fConvertToLimit) + fLowerLimit);
  SV_Target.z = ((exp2(log2(mad(_9.z, 0.8698007464408875f, mad(_9.y, 0.10957999527454376f, (_9.x * 0.020619075745344162f)))) * fGamma) * fConvertToLimit) + fLowerLimit);
  SV_Target.w = 1.0f;

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}


