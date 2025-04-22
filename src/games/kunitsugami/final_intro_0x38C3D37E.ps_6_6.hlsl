#include "./common.hlsl"

Texture2D<float4> tLinearImage : register(t0);

cbuffer OutputColorAdjustment : register(b0) {
  float fGamma : packoffset(c000.x);
  float fLowerLimit : packoffset(c000.y);
  float fUpperLimit : packoffset(c000.z);
  float fConvertToLimit : packoffset(c000.w);
  float4 fConfigDrawRect : packoffset(c001.x);
  float2 fConfigDrawRectSize : packoffset(c002.x);
  uint uConfigMode : packoffset(c002.z);
  float fConfigImageIntensity : packoffset(c002.w);
  float fConfigImageAlphaScale : packoffset(c003.x);
  float fGammaForOverlay : packoffset(c003.y);
  float fLowerLimitForOverlay : packoffset(c003.z);
  float fConvertToLimitForOverlay : packoffset(c003.w);
};

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = tLinearImage.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  return float4(FinalOutput(_9.rgb), 1.f);

  float _23;
  float _34;
  float _45;
  [branch]
  if (!(!(_9.x <= 0.0031308000907301903f))) {
    _23 = (_9.x * 12.920000076293945f);
  } else {
    _23 = (((pow(_9.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  [branch]
  if (!(!(_9.y <= 0.0031308000907301903f))) {
    _34 = (_9.y * 12.920000076293945f);
  } else {
    _34 = (((pow(_9.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  [branch]
  if (!(!(_9.z <= 0.0031308000907301903f))) {
    _45 = (_9.z * 12.920000076293945f);
  } else {
    _45 = (((pow(_9.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (((pow(_23, fGamma)) * fConvertToLimit) + fLowerLimit);
  SV_Target.y = (((pow(_34, fGamma)) * fConvertToLimit) + fLowerLimit);
  SV_Target.z = (((pow(_45, fGamma)) * fConvertToLimit) + fLowerLimit);
  SV_Target.w = 1.0f;
  return SV_Target;
}
