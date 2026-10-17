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
  float _37;
  float _38;
  float _39;
  float _40;
  float _53;
  float _54;
  float _55;
  float _56;
  float _234;
  float _235;
  float _236;
  float _76;
  float _77;
  float _78;
  float _113;
  float _114;
  float _115;
  float _116;
  float _124;
  float _125;
  float _129;
  float _130;
  float _131;
  float _147;
  float _154;
  float _161;
  float _170;
  float _174;
  float _183;
  float _187;
  float _196;
  float _205;
  float _206;
  float _207;
  float _208;
  _11 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _16 = _11.x * TEXCOORD0_centroid.x;
  _17 = _11.y * TEXCOORD0_centroid.y;
  _18 = _11.z * TEXCOORD0_centroid.z;
  _20 = dot(float3(_16, _17, _18), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _37 = ((FireUiPrimitive_344 * (_16 - _20)) + _20) * FireUiPrimitive_016.x;
  _38 = ((FireUiPrimitive_344 * (_17 - _20)) + _20) * FireUiPrimitive_016.y;
  _39 = ((FireUiPrimitive_344 * (_18 - _20)) + _20) * FireUiPrimitive_016.z;
  _40 = (_11.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_11.w > 0.0f) {
    _53 = (FireUiPrimitive_000.x + _37);
    _54 = (FireUiPrimitive_000.y + _38);
    _55 = (FireUiPrimitive_000.z + _39);
    _56 = (FireUiPrimitive_000.w + _40);
  } else {
    _53 = _37;
    _54 = _38;
    _55 = _39;
    _56 = _40;
  }
  _76 = (exp2(log2(abs(_53)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _77 = (exp2(log2(abs(_54)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _78 = (exp2(log2(abs(_55)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_76, _77, _78, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _234 = color.r;
    _235 = color.g;
    _236 = color.b;
#else  // original code
    _113 = saturate(select((_76 <= 0.040449999272823334f), (_76 * 0.07739938050508499f), exp2(log2(abs((_76 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _114 = saturate(select((_77 <= 0.040449999272823334f), (_77 * 0.07739938050508499f), exp2(log2(abs((_77 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _115 = saturate(select((_78 <= 0.040449999272823334f), (_78 * 0.07739938050508499f), exp2(log2(abs((_78 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _116 = dot(float3(_113, _114, _115), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _124 = select((_116 > 0.5f), (((_116 * HDROutput_016.y) / (HDROutput_016.y - _116)) + HDROutput_016.x), (_116 / (1.000100016593933f - _116)));
    _125 = _116 + 9.999999747378752e-05f;
    _129 = _124 * (_113 / _125);
    _130 = (_114 / _125) * _124;
    _131 = (_115 / _125) * _124;
    _147 = saturate(max(max(_129, _130), _131) + -1.0f);
    _154 = HDROutput_064 * 9.999999747378752e-05f;
    _161 = exp2(log2(abs(_154 * (((1.0f - _147) * mad(0.04331360012292862f, _131, mad(0.3292819857597351f, _130, (_129 * 0.627403974533081f)))) + (_147 * mad(0.047561999410390854f, _131, mad(0.19859300553798676f, _130, (_129 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _170 = exp2(log2(abs(((_161 * 18.8515625f) + 0.8359375f) / ((_161 * 18.6875f) + 1.0f))) * 78.84375f);
    _174 = exp2(log2(abs(_154 * mad(0.012477199546992779f, _131, mad(0.9417769908905029f, _130, (_129 * 0.045745600014925f))))) * 0.1593017578125f);
    _183 = exp2(log2(abs(((_174 * 18.8515625f) + 0.8359375f) / ((_174 * 18.6875f) + 1.0f))) * 78.84375f);
    _187 = exp2(log2(abs(_154 * mad(0.9836069941520691f, _131, mad(0.017604099586606026f, _130, (_129 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _196 = exp2(log2(abs(((_187 * 18.8515625f) + 0.8359375f) / ((_187 * 18.6875f) + 1.0f))) * 78.84375f);
    _205 = saturate(_170 / HDROutput_084);
    _206 = saturate(_183 / HDROutput_084);
    _207 = saturate(_196 / HDROutput_084);
    _208 = HDROutput_084 - HDROutput_036;
    _234 = select((_170 > HDROutput_076), _170, select((_170 < HDROutput_084), max((((_205 * _205) * _208) + HDROutput_036), _170), _170));
    _235 = select((_183 > HDROutput_076), _183, select((_183 < HDROutput_084), max((((_206 * _206) * _208) + HDROutput_036), _183), _183));
    _236 = select((_196 > HDROutput_076), _196, select((_196 < HDROutput_084), max((((_207 * _207) * _208) + HDROutput_036), _196), _196));
#endif
  } else {
    _234 = _76;
    _235 = _77;
    _236 = _78;
  }
  SV_Target.x = _234;
  SV_Target.y = _235;
  SV_Target.z = _236;
  SV_Target.w = _56;
  return SV_Target;
}