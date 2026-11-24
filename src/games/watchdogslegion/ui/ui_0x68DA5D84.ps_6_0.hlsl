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
  float _56;
  float _57;
  float _58;
  float _214;
  float _215;
  float _216;
  float _93;
  float _94;
  float _95;
  float _96;
  float _104;
  float _105;
  float _109;
  float _110;
  float _111;
  float _127;
  float _134;
  float _141;
  float _150;
  float _154;
  float _163;
  float _167;
  float _176;
  float _185;
  float _186;
  float _187;
  float _188;
  _7 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _56 = (exp2(log2(abs((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _7)) + _7) * FireUiPrimitive_016.x) + FireUiPrimitive_000.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _57 = (exp2(log2(abs((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _7)) + _7) * FireUiPrimitive_016.y) + FireUiPrimitive_000.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _58 = (exp2(log2(abs((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _7)) + _7) * FireUiPrimitive_016.z) + FireUiPrimitive_000.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_56, _57, _58, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _214 = color.r;
    _215 = color.g;
    _216 = color.b;
#else  // original code
    _93 = saturate(select((_56 <= 0.040449999272823334f), (_56 * 0.07739938050508499f), exp2(log2(abs((_56 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _94 = saturate(select((_57 <= 0.040449999272823334f), (_57 * 0.07739938050508499f), exp2(log2(abs((_57 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _95 = saturate(select((_58 <= 0.040449999272823334f), (_58 * 0.07739938050508499f), exp2(log2(abs((_58 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _96 = dot(float3(_93, _94, _95), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _104 = select((_96 > 0.5f), (((_96 * HDROutput_016.y) / (HDROutput_016.y - _96)) + HDROutput_016.x), (_96 / (1.000100016593933f - _96)));
    _105 = _96 + 9.999999747378752e-05f;
    _109 = _104 * (_93 / _105);
    _110 = (_94 / _105) * _104;
    _111 = (_95 / _105) * _104;
    _127 = saturate(max(max(_109, _110), _111) + -1.0f);
    _134 = HDROutput_064 * 9.999999747378752e-05f;
    _141 = exp2(log2(abs(_134 * (((1.0f - _127) * mad(0.04331360012292862f, _111, mad(0.3292819857597351f, _110, (_109 * 0.627403974533081f)))) + (_127 * mad(0.047561999410390854f, _111, mad(0.19859300553798676f, _110, (_109 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _150 = exp2(log2(abs(((_141 * 18.8515625f) + 0.8359375f) / ((_141 * 18.6875f) + 1.0f))) * 78.84375f);
    _154 = exp2(log2(abs(_134 * mad(0.012477199546992779f, _111, mad(0.9417769908905029f, _110, (_109 * 0.045745600014925f))))) * 0.1593017578125f);
    _163 = exp2(log2(abs(((_154 * 18.8515625f) + 0.8359375f) / ((_154 * 18.6875f) + 1.0f))) * 78.84375f);
    _167 = exp2(log2(abs(_134 * mad(0.9836069941520691f, _111, mad(0.017604099586606026f, _110, (_109 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _176 = exp2(log2(abs(((_167 * 18.8515625f) + 0.8359375f) / ((_167 * 18.6875f) + 1.0f))) * 78.84375f);
    _185 = saturate(_150 / HDROutput_084);
    _186 = saturate(_163 / HDROutput_084);
    _187 = saturate(_176 / HDROutput_084);
    _188 = HDROutput_084 - HDROutput_036;
    _214 = select((_150 > HDROutput_076), _150, select((_150 < HDROutput_084), max((((_185 * _185) * _188) + HDROutput_036), _150), _150));
    _215 = select((_163 > HDROutput_076), _163, select((_163 < HDROutput_084), max((((_186 * _186) * _188) + HDROutput_036), _163), _163));
    _216 = select((_176 > HDROutput_076), _176, select((_176 < HDROutput_084), max((((_187 * _187) * _188) + HDROutput_036), _176), _176));
#endif
  } else {
    _214 = _56;
    _215 = _57;
    _216 = _58;
  }
  SV_Target.x = _214;
  SV_Target.y = _215;
  SV_Target.z = _216;
  SV_Target.w = ((FireUiPrimitive_016.w * TEXCOORD0_centroid.w) + FireUiPrimitive_000.w);
  return SV_Target;
}