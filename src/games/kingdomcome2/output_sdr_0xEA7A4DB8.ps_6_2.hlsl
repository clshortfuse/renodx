#include "./shared.h"

Texture2D<float4> luminanceTex : register(t1);

Texture2D<float4> sunShaftsTex : register(t6);

Texture2D<float4> vignettingTex : register(t4);

Texture3D<float4> PostAA_Grain : register(t3);

Texture2D<float3> bloomTex : register(t2);

Texture2D<float4> colorChartTex : register(t5);

Texture2D<float3> hdrTex : register(t0);

cbuffer PER_BATCH : register(b0, space3) {
  float4 GrainParams : packoffset(c000.x);
  float4 HDRColorBalance : packoffset(c001.x);
  float4 SunShafts_SunCol : packoffset(c002.x);
  float4 HDRUserModification : packoffset(c003.x);
  float4 HDREyeAdaptation : packoffset(c004.x);
  float4 HDRFilmCurve : packoffset(c005.x);
  float3 HDRBloomColor : packoffset(c006.x);
  float4 HDRWhiteBalance : packoffset(c007.x);
  float4 PS_ScreenSize : packoffset(c008.x);
  float Time : packoffset(c009.x);
};

SamplerState linearClampSS : register(s7);

SamplerState PostAA_GrainSS : register(s8);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float3 color_bt2020;
  float3 color_bt709;

  float4 _17 = vignettingTex.Sample(linearClampSS, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float3 _19 = bloomTex.Sample(linearClampSS, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float4 _23 = luminanceTex.Load(int3(0, 0, 0));
  float3 _27 = hdrTex.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
  float4 _31 = sunShaftsTex.Sample(linearClampSS, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float _45 = ((_31.x * 0.1599999964237213f) * SunShafts_SunCol.x) + _27.x;
  float _46 = ((_31.y * 0.1599999964237213f) * SunShafts_SunCol.y) + _27.y;
  float _47 = ((_31.z * 0.1599999964237213f) * SunShafts_SunCol.z) + _27.z;
  float _70 = (8333.3330078125f / exp2(min(max((log2(_23.y * 3030.30322265625f) - ((HDREyeAdaptation.z * 0.5f) * (min(max((log2((_23.y * 10000.0f) + 1.0f) * 0.3010300099849701f), 0.10000000149011612f), 5.199999809265137f) + -3.0f))), HDREyeAdaptation.x), HDREyeAdaptation.y) - HDREyeAdaptation.w)) * _17.x;
  float _87 = ((saturate(HDRBloomColor.x) * (_19.x - _45)) + _45) * _70;
  float _88 = ((saturate(HDRBloomColor.y) * (_19.y - _46)) + _46) * _70;
  float _89 = ((saturate(HDRBloomColor.z) * (_19.z - _47)) + _47) * _70;
  float _90 = dot(float3(_87, _88, _89), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _110 = max((((HDRColorBalance.w * (_87 - _90)) + _90) * HDRColorBalance.x), 0.0f);
  float _111 = max((((HDRColorBalance.w * (_88 - _90)) + _90) * HDRColorBalance.y), 0.0f);
  float _112 = max(((lerp(_90, _89, HDRColorBalance.w)) * HDRColorBalance.z), 0.0f);
  float _114 = HDRFilmCurve.x * 0.2199999988079071f;
  float _116 = HDRFilmCurve.y * 0.30000001192092896f;
  float _118 = _114 * _110;
  float _119 = _114 * _111;
  float _120 = _114 * _112;
  float _121 = _114 * HDRFilmCurve.w;
  float _122 = HDRFilmCurve.y * 0.030000001192092896f;
  float _131 = HDRFilmCurve.z * 0.0020000000949949026f;
  float _152 = HDRFilmCurve.z * 0.03333333134651184f;
  float _156 = ((((_121 + _122) * HDRFilmCurve.w) + _131) / (((_121 + _116) * HDRFilmCurve.w) + 0.06000000238418579f)) - _152;
  float _163 = saturate(saturate((((((_118 + _122) * _110) + _131) / (((_118 + _116) * _110) + 0.06000000238418579f)) - _152) / _156));
  float _164 = saturate(saturate((((((_119 + _122) * _111) + _131) / (((_119 + _116) * _111) + 0.06000000238418579f)) - _152) / _156));
  float _165 = saturate(saturate((((((_120 + _122) * _112) + _131) / (((_120 + _116) * _112) + 0.06000000238418579f)) - _152) / _156));
  float _195 = (saturate(select((_164 < 0.0031308000907301903f), (_164 * 12.920000076293945f), (((pow(_164, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f))) * 0.9375f) + 0.03125f;
  float _196 = saturate(select((_165 < 0.0031308000907301903f), (_165 * 12.920000076293945f), (((pow(_165, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f))) * 15.0f;
  float _197 = frac(_196);
  float _201 = ((((saturate(select((_163 < 0.0031308000907301903f), (_163 * 12.920000076293945f), (((pow(_163, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f))) * 0.9375f) + 0.03125f) - _197) + _196) * 0.0625f;
  float4 _202 = colorChartTex.Sample(linearClampSS, float2(_201, _195));
  float4 _207 = colorChartTex.Sample(linearClampSS, float2((_201 + 0.0625f), _195));
  float _217 = ((_207.x - _202.x) * _197) + _202.x;
  float _218 = ((_207.y - _202.y) * _197) + _202.y;
  float _219 = ((_207.z - _202.z) * _197) + _202.z;
  float4 _232 = PostAA_Grain.Sample(PostAA_GrainSS, float3(((GrainParams.y * TEXCOORD.x) * (PS_ScreenSize.x / PS_ScreenSize.y)), (GrainParams.y * TEXCOORD.y), (Time * 3.0f)));
  float _237 = GrainParams.x * (_232.x + -0.5f);
  float _238 = _237 + 0.5f;
  float _251 = 0.5f - _237;
  float _259 = (_217 * 2.0f) * _238;
  float _261 = (_218 * 2.0f) * _238;
  float _263 = (_219 * 2.0f) * _238;
  float _270 = (((1.0f - (((1.0f - _217) * 2.0f) * _251)) - _259) * select((_217 < 0.5f), 0.0f, 1.0f)) + _259;
  float _271 = (((1.0f - (((1.0f - _218) * 2.0f) * _251)) - _261) * select((_218 < 0.5f), 0.0f, 1.0f)) + _261;
  float _272 = (((1.0f - (((1.0f - _219) * 2.0f) * _251)) - _263) * select((_219 < 0.5f), 0.0f, 1.0f)) + _263;

  float _286 = HDRWhiteBalance.x * mad(0.008926319889724255f, _272, mad(0.5499410033226013f, _271, (_270 * 0.39040499925613403f)));
  float _287 = HDRWhiteBalance.y * mad(0.0013577500358223915f, _272, mad(0.9631720185279846f, _271, (_270 * 0.07084160298109055f)));
  float _288 = HDRWhiteBalance.z * mad(0.9362450242042542f, _272, mad(0.1280210018157959f, _271, (_270 * 0.02310819923877716f)));
  float _299 = sin(dot(float2(SV_Position.x, SV_Position.y), float2(34.483001708984375f, 89.63700103759766f)));
  float _309 = sin(dot(float2((SV_Position.x + 0.5788999795913696f), (SV_Position.y + 0.5788999795913696f)), float2(34.483001708984375f, 89.63700103759766f)));
  SV_Target.x = saturate((HDRUserModification.y * exp2(log2((((frac(_299 * 29156.4765625f) + -0.5f) + frac(_309 * 29156.4765625f)) * 0.0019607844296842813f) + mad(-0.024891000241041183f, _288, mad(-1.628790020942688f, _287, (_286 * 2.8584699630737305f)))) * HDRUserModification.x)) + HDRUserModification.z);
  SV_Target.y = saturate((HDRUserModification.y * exp2(log2((((frac(_299 * 38273.5625f) + -0.5f) + frac(_309 * 38273.5625f)) * 0.0019607844296842813f) + mad(0.00032428099075332284f, _288, mad(1.1582000255584717f, _287, (_286 * -0.21018199622631073f)))) * HDRUserModification.x)) + HDRUserModification.z);
  SV_Target.z = saturate((HDRUserModification.y * exp2(log2((((frac(_299 * 47843.75390625f) + -0.5f) + frac(_309 * 47843.75390625f)) * 0.0019607844296842813f) + mad(1.0686700344085693f, _288, mad(-0.11816900223493576f, _287, (_286 * -0.041811998933553696f)))) * HDRUserModification.x)) + HDRUserModification.z);
  SV_Target.w = 1.0f;
  return SV_Target;
}
