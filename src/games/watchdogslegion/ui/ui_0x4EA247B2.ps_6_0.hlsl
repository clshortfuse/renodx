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
  float _80;
  float _81;
  float _82;
  float _120;
  float _121;
  float _122;
  float _278;
  float _279;
  float _280;
  float _157;
  float _158;
  float _159;
  float _160;
  float _168;
  float _169;
  float _173;
  float _174;
  float _175;
  float _191;
  float _198;
  float _205;
  float _214;
  float _218;
  float _227;
  float _231;
  float _240;
  float _249;
  float _250;
  float _251;
  float _252;
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
  _80 = FireUiPrimitive_000.x + FireUiPrimitive_016.x;
  _81 = FireUiPrimitive_000.y + FireUiPrimitive_016.y;
  _82 = FireUiPrimitive_000.z + FireUiPrimitive_016.z;
  _120 = (exp2(log2(abs(_80 * _43)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _121 = (exp2(log2(abs(_81 * _43)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _122 = (exp2(log2(abs(_82 * _43)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_120, _121, _122, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _278 = color.r;
    _279 = color.g;
    _280 = color.b;
#else  // original code
    _157 = saturate(select((_120 <= 0.040449999272823334f), (_120 * 0.07739938050508499f), exp2(log2(abs((_120 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _158 = saturate(select((_121 <= 0.040449999272823334f), (_121 * 0.07739938050508499f), exp2(log2(abs((_121 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _159 = saturate(select((_122 <= 0.040449999272823334f), (_122 * 0.07739938050508499f), exp2(log2(abs((_122 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _160 = dot(float3(_157, _158, _159), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _168 = select((_160 > 0.5f), (((_160 * HDROutput_016.y) / (HDROutput_016.y - _160)) + HDROutput_016.x), (_160 / (1.000100016593933f - _160)));
    _169 = _160 + 9.999999747378752e-05f;
    _173 = _168 * (_157 / _169);
    _174 = (_158 / _169) * _168;
    _175 = (_159 / _169) * _168;
    _191 = saturate(max(max(_173, _174), _175) + -1.0f);
    _198 = HDROutput_064 * 9.999999747378752e-05f;
    _205 = exp2(log2(abs(_198 * (((1.0f - _191) * mad(0.04331360012292862f, _175, mad(0.3292819857597351f, _174, (_173 * 0.627403974533081f)))) + (_191 * mad(0.047561999410390854f, _175, mad(0.19859300553798676f, _174, (_173 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _214 = exp2(log2(abs(((_205 * 18.8515625f) + 0.8359375f) / ((_205 * 18.6875f) + 1.0f))) * 78.84375f);
    _218 = exp2(log2(abs(_198 * mad(0.012477199546992779f, _175, mad(0.9417769908905029f, _174, (_173 * 0.045745600014925f))))) * 0.1593017578125f);
    _227 = exp2(log2(abs(((_218 * 18.8515625f) + 0.8359375f) / ((_218 * 18.6875f) + 1.0f))) * 78.84375f);
    _231 = exp2(log2(abs(_198 * mad(0.9836069941520691f, _175, mad(0.017604099586606026f, _174, (_173 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _240 = exp2(log2(abs(((_231 * 18.8515625f) + 0.8359375f) / ((_231 * 18.6875f) + 1.0f))) * 78.84375f);
    _249 = saturate(_214 / HDROutput_084);
    _250 = saturate(_227 / HDROutput_084);
    _251 = saturate(_240 / HDROutput_084);
    _252 = HDROutput_084 - HDROutput_036;
    _278 = select((_214 > HDROutput_076), _214, select((_214 < HDROutput_084), max((((_249 * _249) * _252) + HDROutput_036), _214), _214));
    _279 = select((_227 > HDROutput_076), _227, select((_227 < HDROutput_084), max((((_250 * _250) * _252) + HDROutput_036), _227), _227));
    _280 = select((_240 > HDROutput_076), _240, select((_240 < HDROutput_084), max((((_251 * _251) * _252) + HDROutput_036), _240), _240));
#endif
  } else {
    _278 = _120;
    _279 = _121;
    _280 = _122;
  }
  SV_Target.x = _278;
  SV_Target.y = _279;
  SV_Target.z = _280;
  SV_Target.w = ((max(_43, (((_42 - ((_67 * _67) * (3.0f - (_67 * 2.0f)))) * dot(float3(_80, _81, _82), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f))) + _43)) * (FireUiPrimitive_000.w + FireUiPrimitive_016.w)) * (lerp(FireUiPrimitive_376, 1.0f, _43)));
  return SV_Target;
}