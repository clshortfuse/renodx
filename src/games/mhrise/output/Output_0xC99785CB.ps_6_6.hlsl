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
  float saturationForHDR : packoffset(c005.x);
};

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  if (TONE_MAP_TYPE != 0.f) {
    float3 bt709Color = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f).rgb;
    float3 bt2020Color = max(0.f, renodx::color::bt2020::from::BT709(bt709Color));
    float3 pqColor = renodx::color::pq::Encode(bt2020Color, RENODX_GRAPHICS_WHITE_NITS);

    return float4(pqColor, 1.f);
  } else {
    float4 SV_Target;
    float4 _9 = tLinearImage.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
    float _15 = mad(0.04331360012292862f, _9.z, mad(0.3292819857597351f, _9.y, (_9.x * 0.627403974533081f)));
    float _18 = mad(0.011361200362443924f, _9.z, mad(0.9195399880409241f, _9.y, (_9.x * 0.06909699738025665f)));
    float _21 = mad(0.8955950140953064f, _9.z, mad(0.08801320195198059f, _9.y, (_9.x * 0.01639159955084324f)));
    float _46 = 4761.90478515625f / whitePaperNits;
    float _59 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_9.x - _15)) + _15) * gammaForHDR) / _46)) * 0.17156982421875f);
    float _60 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_9.y - _18)) + _18) * gammaForHDR) / _46)) * 0.17156982421875f);
    float _61 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_9.z - _21)) + _21) * gammaForHDR) / _46)) * 0.17156982421875f);
    float _86 = saturate(exp2(log2(((_59 * 16.71875f) + 0.84375f) / ((_59 * 16.5625f) + 1.0f)) * 82.53125f));
    float _87 = saturate(exp2(log2(((_60 * 16.71875f) + 0.84375f) / ((_60 * 16.5625f) + 1.0f)) * 82.53125f));
    float _88 = saturate(exp2(log2(((_61 * 16.71875f) + 0.84375f) / ((_61 * 16.5625f) + 1.0f)) * 82.53125f));
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
}
