#include "UI.hlsli"

cbuffer cb0 : register(b0) {
  float4 HDROutput_000 : packoffset(c000.x);
  float4 HDROutput_016 : packoffset(c001.x);
  float HDROutput_032 : packoffset(c002.x);
  float HDROutput_036 : packoffset(c002.y);
  float HDROutput_040 : packoffset(c002.z);
  float HDROutput_044 : packoffset(c002.w);
  float HDROutput_048 : packoffset(c003.x);
  float HDROutput_052 : packoffset(c003.y);
  float HDROutput_056 : packoffset(c003.z);
  float HDROutput_060 : packoffset(c003.w);
  float HDROutput_064 : packoffset(c004.x);
  float HDROutput_068 : packoffset(c004.y);
  float HDROutput_072 : packoffset(c004.z);
  float HDROutput_076 : packoffset(c004.w);
  float HDROutput_080 : packoffset(c005.x);
  float HDROutput_084 : packoffset(c005.y);
};

cbuffer cb1 : register(b1) {
  float4 FireUiPrimitive_000 : packoffset(c000.x);
  float4 FireUiPrimitive_016 : packoffset(c001.x);
  float4 FireUiPrimitive_032 : packoffset(c002.x);
  float4 FireUiPrimitive_048[4] : packoffset(c003.x);
  float4 FireUiPrimitive_112 : packoffset(c007.x);
  float4 FireUiPrimitive_128[4] : packoffset(c008.x);
  float4 FireUiPrimitive_192[8] : packoffset(c012.x);
  float3 FireUiPrimitive_320 : packoffset(c020.x);
  float FireUiPrimitive_332 : packoffset(c020.w);
  float2 FireUiPrimitive_336 : packoffset(c021.x);
  float FireUiPrimitive_344 : packoffset(c021.z);
  float FireUiPrimitive_348 : packoffset(c021.w);
  float2 FireUiPrimitive_352 : packoffset(c022.x);
  float FireUiPrimitive_360 : packoffset(c022.z);
  float FireUiPrimitive_364 : packoffset(c022.w);
  float FireUiPrimitive_368 : packoffset(c023.x);
  float FireUiPrimitive_372 : packoffset(c023.y);
  float FireUiPrimitive_376 : packoffset(c023.z);
  float FireUiPrimitive_380 : packoffset(c023.w);
  float FireUiPrimitive_384 : packoffset(c024.x);
  int FireUiPrimitive_388 : packoffset(c024.y);
  int FireUiPrimitive_392 : packoffset(c024.z);
  int FireUiPrimitive_396 : packoffset(c024.w);
};

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float2 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _7;
  float _47;
  float _48;
  float _49;
  float _205;
  float _206;
  float _207;
  float _84;
  float _85;
  float _86;
  float _87;
  float _95;
  float _96;
  float _100;
  float _101;
  float _102;
  float _118;
  float _125;
  float _132;
  float _141;
  float _145;
  float _154;
  float _158;
  float _167;
  float _176;
  float _177;
  float _178;
  float _179;
  _7 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _47 = (exp2(log2(abs(((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _7)) + _7) * FireUiPrimitive_016.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _48 = (exp2(log2(abs(((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _7)) + _7) * FireUiPrimitive_016.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _49 = (exp2(log2(abs(((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _7)) + _7) * FireUiPrimitive_016.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_47, _48, _49, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _205 = color.r;
    _206 = color.g;
    _207 = color.b;
#else  // original code
    _84 = saturate(select((_47 <= 0.040449999272823334f), (_47 * 0.07739938050508499f), exp2(log2(abs((_47 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _85 = saturate(select((_48 <= 0.040449999272823334f), (_48 * 0.07739938050508499f), exp2(log2(abs((_48 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _86 = saturate(select((_49 <= 0.040449999272823334f), (_49 * 0.07739938050508499f), exp2(log2(abs((_49 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _87 = dot(float3(_84, _85, _86), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _95 = select((_87 > 0.5f), (((_87 * HDROutput_016.y) / (HDROutput_016.y - _87)) + HDROutput_016.x), (_87 / (1.000100016593933f - _87)));
    _96 = _87 + 9.999999747378752e-05f;
    _100 = _95 * (_84 / _96);
    _101 = (_85 / _96) * _95;
    _102 = (_86 / _96) * _95;
    _118 = saturate(max(max(_100, _101), _102) + -1.0f);
    _125 = HDROutput_064 * 9.999999747378752e-05f;
    _132 = exp2(log2(abs(_125 * (((1.0f - _118) * mad(0.04331360012292862f, _102, mad(0.3292819857597351f, _101, (_100 * 0.627403974533081f)))) + (_118 * mad(0.047561999410390854f, _102, mad(0.19859300553798676f, _101, (_100 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _141 = exp2(log2(abs(((_132 * 18.8515625f) + 0.8359375f) / ((_132 * 18.6875f) + 1.0f))) * 78.84375f);
    _145 = exp2(log2(abs(_125 * mad(0.012477199546992779f, _102, mad(0.9417769908905029f, _101, (_100 * 0.045745600014925f))))) * 0.1593017578125f);
    _154 = exp2(log2(abs(((_145 * 18.8515625f) + 0.8359375f) / ((_145 * 18.6875f) + 1.0f))) * 78.84375f);
    _158 = exp2(log2(abs(_125 * mad(0.9836069941520691f, _102, mad(0.017604099586606026f, _101, (_100 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _167 = exp2(log2(abs(((_158 * 18.8515625f) + 0.8359375f) / ((_158 * 18.6875f) + 1.0f))) * 78.84375f);
    _176 = saturate(_141 / HDROutput_084);
    _177 = saturate(_154 / HDROutput_084);
    _178 = saturate(_167 / HDROutput_084);
    _179 = HDROutput_084 - HDROutput_036;
    _205 = select((_141 > HDROutput_076), _141, select((_141 < HDROutput_084), max((((_176 * _176) * _179) + HDROutput_036), _141), _141));
    _206 = select((_154 > HDROutput_076), _154, select((_154 < HDROutput_084), max((((_177 * _177) * _179) + HDROutput_036), _154), _154));
    _207 = select((_167 > HDROutput_076), _167, select((_167 < HDROutput_084), max((((_178 * _178) * _179) + HDROutput_036), _167), _167));
#endif
  } else {
    _205 = _47;
    _206 = _48;
    _207 = _49;
  }
  SV_Target.x = _205;
  SV_Target.y = _206;
  SV_Target.z = _207;
  SV_Target.w = (FireUiPrimitive_016.w * TEXCOORD0_centroid.w);
  return SV_Target;
}