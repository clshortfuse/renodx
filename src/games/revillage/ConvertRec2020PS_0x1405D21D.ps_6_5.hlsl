#include "./DICE.hlsl"
#include "./shared.h"

Texture2D<float4> tLinearImage : register(t0);

cbuffer HDRMapping : register(b0) {
  float whitePaperNits : packoffset(c000.x);
  float displayMaxNits : packoffset(c000.z);
  float HDRMapping_000w : packoffset(c000.w);
  uint HDRMapping_004x : packoffset(c004.x);
  float HDRMapping_004y : packoffset(c004.y);
};

SamplerState PointBorder : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
#if 1
  float3 bt709Color = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f).rgb;
#if 1
  bt709Color = renodx::color::correct::GammaSafe(bt709Color);
#endif

#if 1
  DICESettings config = DefaultDICESettings();
  config.Type = 3;
  config.ShoulderStart = 0.5;
  const float dicePaperWhite = whitePaperNits / renodx::color::srgb::REFERENCE_WHITE;
  const float dicePeakWhite = max(displayMaxNits, whitePaperNits) / renodx::color::srgb::REFERENCE_WHITE;
  bt709Color.rgb = DICETonemap(bt709Color.rgb * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
#endif

  float3 bt2020Color = renodx::color::bt2020::from::BT709(bt709Color.rgb);

  float3 pqColor = renodx::color::pq::Encode(bt2020Color, whitePaperNits);

  return float4(pqColor, 1.0);

#else
  float4 SV_Target;
  float4 _6 = tLinearImage.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _7 = _6.x;
  float _8 = _6.y;
  float _9 = _6.z;
  float _20 = HDRMapping_004y;
  float _32 = 10000.0f / (whitePaperNits);
  float _45 = exp2(((log2((saturate(((exp2(((log2((mad(0.04331360012292862f, (_6.z), (mad(0.3292819857597351f, (_6.y), ((_6.x) * 0.627403974533081f))))))) * (HDRMapping_004y)))) / _32))))) * 0.1593017578125f));
  float _46 = exp2(((log2((saturate(((exp2(((log2((mad(0.011361200362443924f, (_6.z), (mad(0.9195399880409241f, (_6.y), ((_6.x) * 0.06909699738025665f))))))) * (HDRMapping_004y)))) / _32))))) * 0.1593017578125f));
  float _47 = exp2(((log2((saturate(((exp2(((log2((mad(0.8955950140953064f, (_6.z), (mad(0.08801320195198059f, (_6.y), ((_6.x) * 0.01639159955084324f))))))) * (HDRMapping_004y)))) / _32))))) * 0.1593017578125f));
  float _72 = saturate((exp2(((log2((((_45 * 18.8515625f) + 0.8359375f) / ((_45 * 18.6875f) + 1.0f)))) * 78.84375f))));
  float _73 = saturate((exp2(((log2((((_46 * 18.8515625f) + 0.8359375f) / ((_46 * 18.6875f) + 1.0f)))) * 78.84375f))));
  float _74 = saturate((exp2(((log2((((_47 * 18.8515625f) + 0.8359375f) / ((_47 * 18.6875f) + 1.0f)))) * 78.84375f))));

  float _139, _140, _141;
  if (!(((((uint)(HDRMapping_004x)) & 2) == 0))) {
    float _85 = exp2(((log2((saturate(((displayMaxNits) * 9.999999747378752e-05f))))) * 0.1593017578125f));
    float _94 = saturate((exp2(((log2((((_85 * 18.8515625f) + 0.8359375f) / ((_85 * 18.6875f) + 1.0f)))) * 78.84375f))));
    float _100 = exp2(((log2((saturate(((HDRMapping_000w) * 9.999999747378752e-05f))))) * 0.1593017578125f));
    float _110 = _94 - (saturate((exp2(((log2((((_100 * 18.8515625f) + 0.8359375f) / ((_100 * 18.6875f) + 1.0f)))) * 78.84375f)))));
    float _114 = saturate((_72 / _94));
    float _115 = saturate((_73 / _94));
    float _116 = saturate((_74 / _94));
    _139 = (min(((((2.0f - (_114 + _114)) * _110) + (_114 * _94)) * _114), _72));
    _140 = (min(((((2.0f - (_115 + _115)) * _110) + (_115 * _94)) * _115), _73));
    _141 = (min(((((2.0f - (_116 + _116)) * _110) + (_116 * _94)) * _116), _74));
  }
  SV_Target.x = _139;
  SV_Target.y = _140;
  SV_Target.z = _141;
  SV_Target.w = 1.0f;
  return SV_Target;
#endif
}
