#include "../output.hlsli"

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
  float saturationForHDR : packoffset(c005.x);
};

SamplerState PointBorder : register(s2, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  if (TONE_MAP_TYPE != 0) {
    return GenerateOutput(tLinearImage, PointBorder, TEXCOORD);
  }

  float4 SV_Target;
  float4 _6 = tLinearImage.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _12 = mad(0.04331360012292862f, _6.z, mad(0.3292819857597351f, _6.y, (_6.x * 0.627403974533081f)));
  float _15 = mad(0.011361200362443924f, _6.z, mad(0.9195399880409241f, _6.y, (_6.x * 0.06909699738025665f)));
  float _18 = mad(0.8955950140953064f, _6.z, mad(0.08801320195198059f, _6.y, (_6.x * 0.01639159955084324f)));
  float _43 = 10000.0f / whitePaperNits;
  float _56 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_6.x - _12)) + _12) * gammaForHDR) / _43)) * 0.1593017578125f);
  float _57 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_6.y - _15)) + _15) * gammaForHDR) / _43)) * 0.1593017578125f);
  float _58 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_6.z - _18)) + _18) * gammaForHDR) / _43)) * 0.1593017578125f);
  float _83 = saturate(exp2(log2(((_56 * 18.8515625f) + 0.8359375f) / ((_56 * 18.6875f) + 1.0f)) * 78.84375f));
  float _84 = saturate(exp2(log2(((_57 * 18.8515625f) + 0.8359375f) / ((_57 * 18.6875f) + 1.0f)) * 78.84375f));
  float _85 = saturate(exp2(log2(((_58 * 18.8515625f) + 0.8359375f) / ((_58 * 18.6875f) + 1.0f)) * 78.84375f));
  float _150;
  float _151;
  float _152;
  if (!((drawMode & 2) == 0)) {
    float _96 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _105 = saturate(exp2(log2(((_96 * 18.8515625f) + 0.8359375f) / ((_96 * 18.6875f) + 1.0f)) * 78.84375f));
    float _111 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _121 = _105 - saturate(exp2(log2(((_111 * 18.8515625f) + 0.8359375f) / ((_111 * 18.6875f) + 1.0f)) * 78.84375f));
    float _125 = saturate(_83 / _105);
    float _126 = saturate(_84 / _105);
    float _127 = saturate(_85 / _105);
    _150 = min(((((2.0f - (_125 + _125)) * _121) + (_125 * _105)) * _125), _83);
    _151 = min(((((2.0f - (_126 + _126)) * _121) + (_126 * _105)) * _126), _84);
    _152 = min(((((2.0f - (_127 + _127)) * _121) + (_127 * _105)) * _127), _85);
  } else {
    _150 = _83;
    _151 = _84;
    _152 = _85;
  }
  SV_Target.x = _150;
  SV_Target.y = _151;
  SV_Target.z = _152;
  SV_Target.w = 1.0f;
  return SV_Target;
}
