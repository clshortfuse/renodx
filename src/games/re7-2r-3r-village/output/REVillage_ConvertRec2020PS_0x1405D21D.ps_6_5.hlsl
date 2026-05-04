#include "../common.hlsli"

Texture2D<float4> tLinearImage : register(t0);

cbuffer HDRMapping : register(b0) {
  float whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 standardMaxNitsRect : packoffset(c002.x);
  float4 mdrOutRangeRect : packoffset(c003.x);
  uint drawMode : packoffset(c004.x);
  float gammaForHDR : packoffset(c004.y);
  float2 configDrawRectSize : packoffset(c004.z);
};

SamplerState PointBorder : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _6 = tLinearImage.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return GenerateOutput(_6.rgb, whitePaperNits, displayMaxNits);
  }

  float _32 = 10000.0f / whitePaperNits;
  float _45 = exp2(log2(saturate(exp2(log2(mad(0.04331360012292862f, _6.z, mad(0.3292819857597351f, _6.y, (_6.x * 0.627403974533081f)))) * gammaForHDR) / _32)) * 0.1593017578125f);
  float _46 = exp2(log2(saturate(exp2(log2(mad(0.011361200362443924f, _6.z, mad(0.9195399880409241f, _6.y, (_6.x * 0.06909699738025665f)))) * gammaForHDR) / _32)) * 0.1593017578125f);
  float _47 = exp2(log2(saturate(exp2(log2(mad(0.8955950140953064f, _6.z, mad(0.08801320195198059f, _6.y, (_6.x * 0.01639159955084324f)))) * gammaForHDR) / _32)) * 0.1593017578125f);
  float _72 = saturate(exp2(log2(((_45 * 18.8515625f) + 0.8359375f) / ((_45 * 18.6875f) + 1.0f)) * 78.84375f));
  float _73 = saturate(exp2(log2(((_46 * 18.8515625f) + 0.8359375f) / ((_46 * 18.6875f) + 1.0f)) * 78.84375f));
  float _74 = saturate(exp2(log2(((_47 * 18.8515625f) + 0.8359375f) / ((_47 * 18.6875f) + 1.0f)) * 78.84375f));
  float _139;
  float _140;
  float _141;
  if (!((drawMode & 2) == 0)) {
    float _85 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _94 = saturate(exp2(log2(((_85 * 18.8515625f) + 0.8359375f) / ((_85 * 18.6875f) + 1.0f)) * 78.84375f));
    float _100 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _110 = _94 - saturate(exp2(log2(((_100 * 18.8515625f) + 0.8359375f) / ((_100 * 18.6875f) + 1.0f)) * 78.84375f));
    float _114 = saturate(_72 / _94);
    float _115 = saturate(_73 / _94);
    float _116 = saturate(_74 / _94);
    _139 = min(((((2.0f - (_114 + _114)) * _110) + (_114 * _94)) * _114), _72);
    _140 = min(((((2.0f - (_115 + _115)) * _110) + (_115 * _94)) * _115), _73);
    _141 = min(((((2.0f - (_116 + _116)) * _110) + (_116 * _94)) * _116), _74);
  } else {
    _139 = _72;
    _140 = _73;
    _141 = _74;
  }
  SV_Target.x = _139;
  SV_Target.y = _140;
  SV_Target.z = _141;
  SV_Target.w = 1.0f;
  return SV_Target;
}
