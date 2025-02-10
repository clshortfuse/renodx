#include "./common.hlsl"

Texture2D<float4> luminanceTex : register(t1);

Texture2D<float4> sunShaftsTex : register(t5);

Texture2D<float4> vignettingTex : register(t3);

Texture2D<float3> bloomTex : register(t2);

Texture2D<float4> colorChartTex : register(t4);

Texture2D<float3> hdrTex : register(t0);

/*
float4 HDRColorBalance;
float4 SunShafts_SunCol;
float4 HDRUserModification;
float4 HDREyeAdaptation;
float4 HDRFilmCurve;
float3 HDRBloomColor;
 */
cbuffer PER_BATCH : register(b0, space3) {
  float PER_BATCH_000x : packoffset(c000.x);
  float PER_BATCH_000y : packoffset(c000.y);
  float PER_BATCH_000z : packoffset(c000.z);
  float PER_BATCH_000w : packoffset(c000.w);
  float PER_BATCH_001x : packoffset(c001.x);
  float PER_BATCH_001y : packoffset(c001.y);
  float PER_BATCH_001z : packoffset(c001.z);
  float PER_BATCH_002x : packoffset(c002.x);
  float PER_BATCH_002y : packoffset(c002.y);
  float PER_BATCH_002z : packoffset(c002.z);
  float PER_BATCH_003x : packoffset(c003.x);
  float PER_BATCH_003y : packoffset(c003.y);
  float PER_BATCH_003z : packoffset(c003.z);
  float PER_BATCH_004x : packoffset(c004.x);
  float PER_BATCH_004y : packoffset(c004.y);
  float PER_BATCH_004z : packoffset(c004.z);
  float PER_BATCH_004w : packoffset(c004.w);
  float PER_BATCH_005x : packoffset(c005.x);
  float PER_BATCH_005y : packoffset(c005.y);
  float PER_BATCH_005z : packoffset(c005.z);
};

SamplerState linearClampSS : register(s6);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float3 untonemapped;
  float4 SV_Target;
  float3 _15 = bloomTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y)));
  // float3 _23 = hdrTex.Load(int3((int(21)), (int(22)), 0));
  float3 _23 = hdrTex.Load(int3((int(SV_Position.x)), (int(SV_Position.y)), 0));

  KingdomOptions options;
  options.gamma = float3(PER_BATCH_002x, PER_BATCH_002y, PER_BATCH_002z);
  options.bloom = float3(PER_BATCH_005x, PER_BATCH_005y, PER_BATCH_005z);

  ModifyOptions(options);

  float3 adjustEyeAdaptation = float3(PER_BATCH_003x, PER_BATCH_003y, PER_BATCH_003z);

  float _47 = (8333.3330078125f / (exp2((min((max(((log2(((((float4)(luminanceTex.Load(int3(0, 0, 0)))).y) * 3030.30322265625f))) - (((adjustEyeAdaptation.z) * 0.5f) * ((min((max(((log2((((((float4)(luminanceTex.Load(int3(0, 0, 0)))).y) * 10000.0f) + 1.0f))) * 0.3010300099849701f), 0.10000000149011612f)), 5.199999809265137f)) + -3.0f))), (adjustEyeAdaptation.x))), (adjustEyeAdaptation.y)))))) * (((float4)(vignettingTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y))))).x * options.vignette);
  float _64 = (((saturate((options.bloom.x))) * ((_15.x) - (_23.x))) + (_23.x)) * _47;
  float _65 = (((saturate((options.bloom.y))) * ((_15.y) - (_23.y))) + (_23.y)) * _47;
  float _66 = (((saturate((options.bloom.z))) * ((_15.z) - (_23.z))) + (_23.z)) * _47;
  // untonemapped = float3(_64, _65, _66);

  float _67 = dot(float3(_64, _65, _66), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));

  float _85 = max(((((PER_BATCH_000w) * (_64 - _67)) + _67) * (PER_BATCH_000x)), 0.0f);
  float _86 = max(((((PER_BATCH_000w) * (_65 - _67)) + _67) * (PER_BATCH_000y)), 0.0f);
  float _87 = max(((((_66 - _67) * (PER_BATCH_000w)) + _67) * (PER_BATCH_000z)), 0.0f);
  float _91 = (PER_BATCH_004x) * 0.2199999988079071f;
  float _93 = (PER_BATCH_004y) * 0.30000001192092896f;
  float _95 = _91 * _85;
  float _96 = _91 * _86;
  float _97 = _91 * _87;
  float _98 = _91 * (PER_BATCH_004w);

  untonemapped = float3(_95, _96, _97);

  float _99 = (PER_BATCH_004y) * 0.030000001192092896f;
  float _108 = (PER_BATCH_004z) * 0.0020000000949949026f;
  float _129 = (PER_BATCH_004z) * 0.03333333134651184f;
  float _133 = ((((_98 + _99) * (PER_BATCH_004w)) + _108) / (((_98 + _93) * (PER_BATCH_004w)) + 0.06000000238418579f)) - _129;
  float _143 = saturate((saturate((saturate(((((((_95 + _99) * _85) + _108) / (((_95 + _93) * _85) + 0.06000000238418579f)) - _129) / _133))))));
  float _144 = saturate((saturate((saturate(((((((_96 + _99) * _86) + _108) / (((_96 + _93) * _86) + 0.06000000238418579f)) - _129) / _133))))));
  float _145 = saturate((saturate((saturate(((((((_97 + _99) * _87) + _108) / (((_97 + _93) * _87) + 0.06000000238418579f)) - _129) / _133))))));
  /* float _143 = ((((((_95 + _99) * _85) + _108) / (((_95 + _93) * _85) + 0.06000000238418579f)) - _129) / _133);
  float _144 = ((((((_96 + _99) * _86) + _108) / (((_96 + _93) * _86) + 0.06000000238418579f)) - _129) / _133);
  float _145 = ((((((_97 + _99) * _87) + _108) / (((_97 + _93) * _87) + 0.06000000238418579f)) - _129) / _133);
  untonemapped = float3(_143, _144, _145); */

  float _167 = (((bool)((_143 < 0.0031308000907301903f))) ? (_143 * 12.920000076293945f) : (((exp2(((log2(_143)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f));
  float _168 = (((bool)((_144 < 0.0031308000907301903f))) ? (_144 * 12.920000076293945f) : (((exp2(((log2(_144)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f));
  float _169 = (((bool)((_145 < 0.0031308000907301903f))) ? (_145 * 12.920000076293945f) : (((exp2(((log2(_145)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f));

  float4 _170 = sunShaftsTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y)));
  float _195 = ((saturate(((((_170.y) * (1.0f - _168)) * (PER_BATCH_001y)) + _168))) * 0.9375f) + 0.03125f;
  float _196 = (saturate(((((_170.z) * (1.0f - _169)) * (PER_BATCH_001z)) + _169))) * 15.0f;
  float _197 = frac(_196);
  float _201 = (((((saturate(((((_170.x) * (1.0f - _167)) * (PER_BATCH_001x)) + _167))) * 0.9375f) + 0.03125f) - _197) + _196) * 0.0625f;

  float4 _202 = colorChartTex.Sample(linearClampSS, float2(_201, _195));
  float4 _207 = colorChartTex.Sample(linearClampSS, float2((_201 + 0.0625f), _195));
  float _221 = sin((dot(float2((SV_Position.x), (SV_Position.y)), float2(34.483001708984375f, 89.63700103759766f))));
  float _231 = sin((dot(float2(((SV_Position.x) + 0.5788999795913696f), ((SV_Position.y) + 0.5788999795913696f)), float2(34.483001708984375f, 89.63700103759766f))));

  /* SV_Target.x = (saturate((((PER_BATCH_002y) * (exp2(((log2((((((_207.x) - (_202.x)) * _197) + (_202.x)) + ((((frac((_221 * 29156.4765625f))) + -0.5f) + (frac((_231 * 29156.4765625f)))) * 0.0019607844296842813f)))) * (PER_BATCH_002x))))) + (PER_BATCH_002z))));
  SV_Target.y = (saturate((((PER_BATCH_002y) * (exp2(((log2((((((_207.y) - (_202.y)) * _197) + (_202.y)) + ((((frac((_221 * 38273.5625f))) + -0.5f) + (frac((_231 * 38273.5625f)))) * 0.0019607844296842813f)))) * (PER_BATCH_002x))))) + (PER_BATCH_002z))));
  SV_Target.z = (saturate((((PER_BATCH_002y) * (exp2(((log2((((((_207.z) - (_202.z)) * _197) + (_202.z)) + ((((frac((_221 * 47843.75390625f))) + -0.5f) + (frac((_231 * 47843.75390625f)))) * 0.0019607844296842813f)))) * (PER_BATCH_002x))))) + (PER_BATCH_002z)))); */

  SV_Target.x = (saturate((((options.gamma.y) * (exp2(((log2((((((_207.x) - (_202.x)) * _197) + (_202.x)) + ((((frac((_221 * 29156.4765625f))) + -0.5f) + (frac((_231 * 29156.4765625f)))) * 0.0019607844296842813f)))) * (options.gamma.x))))) + (options.gamma.z))));
  SV_Target.y = (saturate((((options.gamma.y) * (exp2(((log2((((((_207.y) - (_202.y)) * _197) + (_202.y)) + ((((frac((_221 * 38273.5625f))) + -0.5f) + (frac((_231 * 38273.5625f)))) * 0.0019607844296842813f)))) * (options.gamma.x))))) + (options.gamma.z))));
  SV_Target.z = (saturate((((options.gamma.y) * (exp2(((log2((((((_207.z) - (_202.z)) * _197) + (_202.z)) + ((((frac((_221 * 47843.75390625f))) + -0.5f) + (frac((_231 * 47843.75390625f)))) * 0.0019607844296842813f)))) * (options.gamma.x))))) + (options.gamma.z))));

  SV_Target.rgb = Tonemap(SV_Target.rgb, untonemapped);
  SV_Target.w = 1.0f;
  return SV_Target;
}
