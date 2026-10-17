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
  uint2 _8;
  float _11;
  float _13;
  float _15;
  float4 _16;
  float _19;
  float _26;
  float _32;
  float _33;
  float _38;
  float _42;
  float _43;
  float _53;
  float4 _58;
  float _67;
  float _111;
  float _112;
  float _113;
  float _269;
  float _270;
  float _271;
  float _148;
  float _149;
  float _150;
  float _151;
  float _159;
  float _160;
  float _164;
  float _165;
  float _166;
  float _182;
  float _189;
  float _196;
  float _205;
  float _209;
  float _218;
  float _222;
  float _231;
  float _240;
  float _241;
  float _242;
  float _243;
  // uint2 _8;
  t0.GetDimensions(_8.x, _8.y);
  _11 = ddx_coarse(TEXCOORD1_centroid.x);
  _13 = ddx_coarse(TEXCOORD1_centroid.z);
  _15 = (_11 * float((int)((int)(_8.x)))) / _13;
  _16 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _19 = min(_16.x, _16.w);
  _26 = ((FireUiPrimitive_364 - FireUiPrimitive_368) * _15) + FireUiPrimitive_368;
  _32 = ((FireUiPrimitive_348 - FireUiPrimitive_360) * _15) + FireUiPrimitive_360;
  _33 = _32 * 2.0f;
  _38 = saturate((((1.0f - _19) - _26) + _32) / _33);
  _42 = (_38 * _38) * (3.0f - (_38 * 2.0f));
  _43 = 1.0f - _42;
  _53 = FireUiPrimitive_380 * (4.0f / _13);
  _58 = t0.Sample(s0, float2((TEXCOORD1_centroid.x - ((FireUiPrimitive_336.x * _11) * _53)), (TEXCOORD1_centroid.y - ((FireUiPrimitive_336.y * ddy_coarse(TEXCOORD1_centroid.y)) * _53))));
  _67 = saturate((((1.0f - _26) + _32) - max(((FireUiPrimitive_372 * _15) + _19), min(_58.x, _58.w))) / _33);
  _111 = (exp2(log2(abs(FireUiPrimitive_016.x * _43)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _112 = (exp2(log2(abs(FireUiPrimitive_016.y * _43)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _113 = (exp2(log2(abs(FireUiPrimitive_016.z * _43)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_111, _112, _113, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _269 = color.r;
    _270 = color.g;
    _271 = color.b;
#else  // original code
    _148 = saturate(select((_111 <= 0.040449999272823334f), (_111 * 0.07739938050508499f), exp2(log2(abs((_111 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _149 = saturate(select((_112 <= 0.040449999272823334f), (_112 * 0.07739938050508499f), exp2(log2(abs((_112 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _150 = saturate(select((_113 <= 0.040449999272823334f), (_113 * 0.07739938050508499f), exp2(log2(abs((_113 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _151 = dot(float3(_148, _149, _150), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _159 = select((_151 > 0.5f), (((_151 * HDROutput_016.y) / (HDROutput_016.y - _151)) + HDROutput_016.x), (_151 / (1.000100016593933f - _151)));
    _160 = _151 + 9.999999747378752e-05f;
    _164 = _159 * (_148 / _160);
    _165 = (_149 / _160) * _159;
    _166 = (_150 / _160) * _159;
    _182 = saturate(max(max(_164, _165), _166) + -1.0f);
    _189 = HDROutput_064 * 9.999999747378752e-05f;
    _196 = exp2(log2(abs(_189 * (((1.0f - _182) * mad(0.04331360012292862f, _166, mad(0.3292819857597351f, _165, (_164 * 0.627403974533081f)))) + (_182 * mad(0.047561999410390854f, _166, mad(0.19859300553798676f, _165, (_164 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _205 = exp2(log2(abs(((_196 * 18.8515625f) + 0.8359375f) / ((_196 * 18.6875f) + 1.0f))) * 78.84375f);
    _209 = exp2(log2(abs(_189 * mad(0.012477199546992779f, _166, mad(0.9417769908905029f, _165, (_164 * 0.045745600014925f))))) * 0.1593017578125f);
    _218 = exp2(log2(abs(((_209 * 18.8515625f) + 0.8359375f) / ((_209 * 18.6875f) + 1.0f))) * 78.84375f);
    _222 = exp2(log2(abs(_189 * mad(0.9836069941520691f, _166, mad(0.017604099586606026f, _165, (_164 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _231 = exp2(log2(abs(((_222 * 18.8515625f) + 0.8359375f) / ((_222 * 18.6875f) + 1.0f))) * 78.84375f);
    _240 = saturate(_205 / HDROutput_084);
    _241 = saturate(_218 / HDROutput_084);
    _242 = saturate(_231 / HDROutput_084);
    _243 = HDROutput_084 - HDROutput_036;
    _269 = select((_205 > HDROutput_076), _205, select((_205 < HDROutput_084), max((((_240 * _240) * _243) + HDROutput_036), _205), _205));
    _270 = select((_218 > HDROutput_076), _218, select((_218 < HDROutput_084), max((((_241 * _241) * _243) + HDROutput_036), _218), _218));
    _271 = select((_231 > HDROutput_076), _231, select((_231 < HDROutput_084), max((((_242 * _242) * _243) + HDROutput_036), _231), _231));
#endif
  } else {
    _269 = _111;
    _270 = _112;
    _271 = _113;
  }
  SV_Target.x = _269;
  SV_Target.y = _270;
  SV_Target.z = _271;
  SV_Target.w = ((max(_43, (((_42 - ((_67 * _67) * (3.0f - (_67 * 2.0f)))) * dot(float3(FireUiPrimitive_016.x, FireUiPrimitive_016.y, FireUiPrimitive_016.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f))) + _43)) * FireUiPrimitive_016.w) * (lerp(FireUiPrimitive_376, 1.0f, _43)));
  return SV_Target;
}