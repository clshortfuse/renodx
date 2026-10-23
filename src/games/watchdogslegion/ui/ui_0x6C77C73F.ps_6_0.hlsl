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
  float _16;
  float _17;
  float _18;
  float _20;
  float _60;
  float _61;
  float _62;
  float _218;
  float _219;
  float _220;
  float _97;
  float _98;
  float _99;
  float _100;
  float _108;
  float _109;
  float _113;
  float _114;
  float _115;
  float _131;
  float _138;
  float _145;
  float _154;
  float _158;
  float _167;
  float _171;
  float _180;
  float _189;
  float _190;
  float _191;
  float _192;
  _11 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _16 = _11.x * TEXCOORD0_centroid.x;
  _17 = _11.y * TEXCOORD0_centroid.y;
  _18 = _11.z * TEXCOORD0_centroid.z;
  _20 = dot(float3(_16, _17, _18), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _60 = (exp2(log2(abs(((FireUiPrimitive_344 * (_16 - _20)) + _20) * FireUiPrimitive_016.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _61 = (exp2(log2(abs(((FireUiPrimitive_344 * (_17 - _20)) + _20) * FireUiPrimitive_016.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _62 = (exp2(log2(abs(((FireUiPrimitive_344 * (_18 - _20)) + _20) * FireUiPrimitive_016.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_60, _61, _62, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _218 = color.r;
    _219 = color.g;
    _220 = color.b;
#else  // original code
    _97 = saturate(select((_60 <= 0.040449999272823334f), (_60 * 0.07739938050508499f), exp2(log2(abs((_60 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _98 = saturate(select((_61 <= 0.040449999272823334f), (_61 * 0.07739938050508499f), exp2(log2(abs((_61 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _99 = saturate(select((_62 <= 0.040449999272823334f), (_62 * 0.07739938050508499f), exp2(log2(abs((_62 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _100 = dot(float3(_97, _98, _99), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _108 = select((_100 > 0.5f), (((_100 * HDROutput_016.y) / (HDROutput_016.y - _100)) + HDROutput_016.x), (_100 / (1.000100016593933f - _100)));
    _109 = _100 + 9.999999747378752e-05f;
    _113 = _108 * (_97 / _109);
    _114 = (_98 / _109) * _108;
    _115 = (_99 / _109) * _108;
    _131 = saturate(max(max(_113, _114), _115) + -1.0f);
    _138 = HDROutput_064 * 9.999999747378752e-05f;
    _145 = exp2(log2(abs(_138 * (((1.0f - _131) * mad(0.04331360012292862f, _115, mad(0.3292819857597351f, _114, (_113 * 0.627403974533081f)))) + (_131 * mad(0.047561999410390854f, _115, mad(0.19859300553798676f, _114, (_113 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _154 = exp2(log2(abs(((_145 * 18.8515625f) + 0.8359375f) / ((_145 * 18.6875f) + 1.0f))) * 78.84375f);
    _158 = exp2(log2(abs(_138 * mad(0.012477199546992779f, _115, mad(0.9417769908905029f, _114, (_113 * 0.045745600014925f))))) * 0.1593017578125f);
    _167 = exp2(log2(abs(((_158 * 18.8515625f) + 0.8359375f) / ((_158 * 18.6875f) + 1.0f))) * 78.84375f);
    _171 = exp2(log2(abs(_138 * mad(0.9836069941520691f, _115, mad(0.017604099586606026f, _114, (_113 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _180 = exp2(log2(abs(((_171 * 18.8515625f) + 0.8359375f) / ((_171 * 18.6875f) + 1.0f))) * 78.84375f);
    _189 = saturate(_154 / HDROutput_084);
    _190 = saturate(_167 / HDROutput_084);
    _191 = saturate(_180 / HDROutput_084);
    _192 = HDROutput_084 - HDROutput_036;
    _218 = select((_154 > HDROutput_076), _154, select((_154 < HDROutput_084), max((((_189 * _189) * _192) + HDROutput_036), _154), _154));
    _219 = select((_167 > HDROutput_076), _167, select((_167 < HDROutput_084), max((((_190 * _190) * _192) + HDROutput_036), _167), _167));
    _220 = select((_180 > HDROutput_076), _180, select((_180 < HDROutput_084), max((((_191 * _191) * _192) + HDROutput_036), _180), _180));
#endif
  } else {
    _218 = _60;
    _219 = _61;
    _220 = _62;
  }
  SV_Target.x = _218;
  SV_Target.y = _219;
  SV_Target.z = _220;
  SV_Target.w = ((_11.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}