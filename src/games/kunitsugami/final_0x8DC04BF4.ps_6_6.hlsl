#include "./common.hlsl"

Texture2D<float4> tLinearImage : register(t0);

cbuffer HDRMapping : register(b0) {
  float whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 standardMaxNitsRect : packoffset(c002.x);
  float2 displayMaxNitsRectSize : packoffset(c003.x);
  float2 standardMaxNitsRectSize : packoffset(c003.z);
  float4 mdrOutRangeRect : packoffset(c004.x);
  uint drawMode : packoffset(c005.x);
  float gammaForHDR : packoffset(c005.y);
  float displayMaxNitsST2084 : packoffset(c005.z);
  float displayMinNitsST2084 : packoffset(c005.w);
  uint drawModeOnMDRPass : packoffset(c006.x);
  float saturationForHDR : packoffset(c006.y);
  float2 targetInvSize : packoffset(c006.z);
  float whitePaperNitsForOverlay : packoffset(c007.x);
  float HDRMapping_reserve0 : packoffset(c007.y);
  float HDRMapping_reserve1 : packoffset(c007.z);
  float HDRMapping_reserve2 : packoffset(c007.w);
};

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = tLinearImage.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  return float4(FinalOutput(_9.rgb), 1.f);

  float _17 = mad(0.04331360012292862f, _9.z, mad(0.3292819857597351f, _9.y, (_9.x * 0.627403974533081f)));
  float _20 = mad(0.011361200362443924f, _9.z, mad(0.9195399880409241f, _9.y, (_9.x * 0.06909699738025665f)));
  float _23 = mad(0.8955950140953064f, _9.z, mad(0.08801320195198059f, _9.y, (_9.x * 0.01639159955084324f)));
  float _46 = 10000.0f / whitePaperNits;
  float _59 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_9.x - _17)) + _17) * gammaForHDR) / _46)) * 0.1593017578125f);
  float _60 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_9.y - _20)) + _20) * gammaForHDR) / _46)) * 0.1593017578125f);
  float _61 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_9.z - _23)) + _23) * gammaForHDR) / _46)) * 0.1593017578125f);
  float _86 = saturate(exp2(log2(((_59 * 18.8515625f) + 0.8359375f) / ((_59 * 18.6875f) + 1.0f)) * 78.84375f));
  float _87 = saturate(exp2(log2(((_60 * 18.8515625f) + 0.8359375f) / ((_60 * 18.6875f) + 1.0f)) * 78.84375f));
  float _88 = saturate(exp2(log2(((_61 * 18.8515625f) + 0.8359375f) / ((_61 * 18.6875f) + 1.0f)) * 78.84375f));
  float _153;
  float _154;
  float _155;
  if (!(((uint)(drawMode) & 2) == 0)) {
    float _99 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _108 = saturate(exp2(log2(((_99 * 18.8515625f) + 0.8359375f) / ((_99 * 18.6875f) + 1.0f)) * 78.84375f));
    float _114 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _124 = _108 - saturate(exp2(log2(((_114 * 18.8515625f) + 0.8359375f) / ((_114 * 18.6875f) + 1.0f)) * 78.84375f));
    float _128 = saturate(_86 / _108);
    float _129 = saturate(_87 / _108);
    float _130 = saturate(_88 / _108);
    _153 = min(((((2.0f - (_128 + _128)) * _124) + (_128 * _108)) * _128), _86);
    _154 = min(((((2.0f - (_129 + _129)) * _124) + (_129 * _108)) * _129), _87);
    _155 = min(((((2.0f - (_130 + _130)) * _124) + (_130 * _108)) * _130), _88);
  } else {
    _153 = _86;
    _154 = _87;
    _155 = _88;
  }
  SV_Target.x = _153;
  SV_Target.y = _154;
  SV_Target.z = _155;
  SV_Target.w = 1.0f;
  return SV_Target;
}
