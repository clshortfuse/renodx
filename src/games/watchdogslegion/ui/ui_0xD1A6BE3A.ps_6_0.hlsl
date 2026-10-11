#include "UI.hlsli"

Texture2D<float4> t0 : register(t0);

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

SamplerState s0 : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float4 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _11;
  bool _18;
  float _22;
  float _23;
  float _24;
  float _26;
  float _43;
  float _44;
  float _45;
  float _46;
  float _59;
  float _60;
  float _61;
  float _62;
  float _239;
  float _240;
  float _241;
  float _82;
  float _83;
  float _84;
  float _118;
  float _119;
  float _120;
  float _121;
  float _129;
  float _130;
  float _134;
  float _135;
  float _136;
  float _152;
  float _159;
  float _166;
  float _175;
  float _179;
  float _188;
  float _192;
  float _201;
  float _210;
  float _211;
  float _212;
  float _213;
  _11 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _18 = (FireUiPrimitive_396 != 0);
  _22 = select(_18, 1.0f, _11.x) * TEXCOORD0_centroid.x;
  _23 = select(_18, 1.0f, _11.y) * TEXCOORD0_centroid.y;
  _24 = select(_18, 1.0f, _11.z) * TEXCOORD0_centroid.z;
  _26 = dot(float3(_22, _23, _24), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _43 = (lerp(_26, _22, FireUiPrimitive_344)) * FireUiPrimitive_016.x;
  _44 = (lerp(_26, _23, FireUiPrimitive_344)) * FireUiPrimitive_016.y;
  _45 = (lerp(_26, _24, FireUiPrimitive_344)) * FireUiPrimitive_016.z;
  _46 = (_11.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_11.w > 0.0f) {
    _59 = (FireUiPrimitive_000.x + _43);
    _60 = (FireUiPrimitive_000.y + _44);
    _61 = (FireUiPrimitive_000.z + _45);
    _62 = (FireUiPrimitive_000.w + _46);
  } else {
    _59 = _43;
    _60 = _44;
    _61 = _45;
    _62 = _46;
  }
  _82 = (exp2(log2(abs(_59)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _83 = (exp2(log2(abs(_60)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _84 = (exp2(log2(abs(_61)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_82, _83, _84, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _239 = color.r;
    _240 = color.g;
    _241 = color.b;
#else  // original code
    _118 = saturate(select((_82 <= 0.040449999272823334f), (_82 * 0.07739938050508499f), exp2(log2(abs((_82 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _119 = saturate(select((_83 <= 0.040449999272823334f), (_83 * 0.07739938050508499f), exp2(log2(abs((_83 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _120 = saturate(select((_84 <= 0.040449999272823334f), (_84 * 0.07739938050508499f), exp2(log2(abs((_84 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _121 = dot(float3(_118, _119, _120), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _129 = select((_121 > 0.5f), (((_121 * HDROutput_016.y) / (HDROutput_016.y - _121)) + HDROutput_016.x), (_121 / (1.000100016593933f - _121)));
    _130 = _121 + 9.999999747378752e-05f;
    _134 = _129 * (_118 / _130);
    _135 = (_119 / _130) * _129;
    _136 = (_120 / _130) * _129;
    _152 = saturate(max(max(_134, _135), _136) + -1.0f);
    _159 = HDROutput_064 * 9.999999747378752e-05f;
    _166 = exp2(log2(abs(_159 * (((1.0f - _152) * mad(0.04331360012292862f, _136, mad(0.3292819857597351f, _135, (_134 * 0.627403974533081f)))) + (_152 * mad(0.047561999410390854f, _136, mad(0.19859300553798676f, _135, (_134 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _175 = exp2(log2(abs(((_166 * 18.8515625f) + 0.8359375f) / ((_166 * 18.6875f) + 1.0f))) * 78.84375f);
    _179 = exp2(log2(abs(_159 * mad(0.012477199546992779f, _136, mad(0.9417769908905029f, _135, (_134 * 0.045745600014925f))))) * 0.1593017578125f);
    _188 = exp2(log2(abs(((_179 * 18.8515625f) + 0.8359375f) / ((_179 * 18.6875f) + 1.0f))) * 78.84375f);
    _192 = exp2(log2(abs(_159 * mad(0.9836069941520691f, _136, mad(0.017604099586606026f, _135, (_134 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _201 = exp2(log2(abs(((_192 * 18.8515625f) + 0.8359375f) / ((_192 * 18.6875f) + 1.0f))) * 78.84375f);
    _210 = saturate(_175 / HDROutput_084);
    _211 = saturate(_188 / HDROutput_084);
    _212 = saturate(_201 / HDROutput_084);
    _213 = HDROutput_084 - HDROutput_036;
    _239 = select((_175 > HDROutput_076), _175, select((_175 < HDROutput_084), max((((_210 * _210) * _213) + HDROutput_036), _175), _175));
    _240 = select((_188 > HDROutput_076), _188, select((_188 < HDROutput_084), max((((_211 * _211) * _213) + HDROutput_036), _188), _188));
    _241 = select((_201 > HDROutput_076), _201, select((_201 < HDROutput_084), max((((_212 * _212) * _213) + HDROutput_036), _201), _201));
#endif
  } else {
    _239 = _82;
    _240 = _83;
    _241 = _84;
  }
  SV_Target.x = _239;
  SV_Target.y = _240;
  SV_Target.z = _241;
  SV_Target.w = _62;
  return SV_Target;
}