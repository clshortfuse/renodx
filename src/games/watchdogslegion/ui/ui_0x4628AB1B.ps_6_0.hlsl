#include "UI.hlsli"

struct SCameraDistances {
  float SCameraDistances_000;
  float SCameraDistances_004;
  float SCameraDistances_008;
  float SCameraDistances_012;
};

struct SLCMFrustumPlanes {
  float4 SLCMFrustumPlanes_000[6];
};


Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float cb0_836w : packoffset(c836.w);
};

cbuffer cb1 : register(b1) {
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

cbuffer cb2 : register(b2) {
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
  float _17;
  float _19;
  float _47;
  float _48;
  float _49;
  float _50;
  float _63;
  float _64;
  float _65;
  float _66;
  float _243;
  float _244;
  float _245;
  float _86;
  float _87;
  float _88;
  float _122;
  float _123;
  float _124;
  float _125;
  float _133;
  float _134;
  float _138;
  float _139;
  float _140;
  float _156;
  float _163;
  float _170;
  float _179;
  float _183;
  float _192;
  float _196;
  float _205;
  float _214;
  float _215;
  float _216;
  float _217;
  _17 = select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y));
  _19 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _47 = FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _19)) + _19) * cb0_836w), 0.0f), 64512.0f);
  _48 = FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _19)) + _19) * cb0_836w), 0.0f), 64512.0f);
  _49 = FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _19)) + _19) * cb0_836w), 0.0f), 64512.0f);
  _50 = (_17 * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_17 > 0.0f) {
    _63 = (FireUiPrimitive_000.x + _47);
    _64 = (FireUiPrimitive_000.y + _48);
    _65 = (FireUiPrimitive_000.z + _49);
    _66 = (FireUiPrimitive_000.w + _50);
  } else {
    _63 = _47;
    _64 = _48;
    _65 = _49;
    _66 = _50;
  }
  _86 = (exp2(log2(abs(_63)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _87 = (exp2(log2(abs(_64)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _88 = (exp2(log2(abs(_65)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_86, _87, _88, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _243 = color.r;
    _244 = color.g;
    _245 = color.b;
#else  // original code
    _122 = saturate(select((_86 <= 0.040449999272823334f), (_86 * 0.07739938050508499f), exp2(log2(abs((_86 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _123 = saturate(select((_87 <= 0.040449999272823334f), (_87 * 0.07739938050508499f), exp2(log2(abs((_87 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _124 = saturate(select((_88 <= 0.040449999272823334f), (_88 * 0.07739938050508499f), exp2(log2(abs((_88 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _125 = dot(float3(_122, _123, _124), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _133 = select((_125 > 0.5f), (((_125 * HDROutput_016.y) / (HDROutput_016.y - _125)) + HDROutput_016.x), (_125 / (1.000100016593933f - _125)));
    _134 = _125 + 9.999999747378752e-05f;
    _138 = _133 * (_122 / _134);
    _139 = (_123 / _134) * _133;
    _140 = (_124 / _134) * _133;
    _156 = saturate(max(max(_138, _139), _140) + -1.0f);
    _163 = HDROutput_064 * 9.999999747378752e-05f;
    _170 = exp2(log2(abs(_163 * (((1.0f - _156) * mad(0.04331360012292862f, _140, mad(0.3292819857597351f, _139, (_138 * 0.627403974533081f)))) + (_156 * mad(0.047561999410390854f, _140, mad(0.19859300553798676f, _139, (_138 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _179 = exp2(log2(abs(((_170 * 18.8515625f) + 0.8359375f) / ((_170 * 18.6875f) + 1.0f))) * 78.84375f);
    _183 = exp2(log2(abs(_163 * mad(0.012477199546992779f, _140, mad(0.9417769908905029f, _139, (_138 * 0.045745600014925f))))) * 0.1593017578125f);
    _192 = exp2(log2(abs(((_183 * 18.8515625f) + 0.8359375f) / ((_183 * 18.6875f) + 1.0f))) * 78.84375f);
    _196 = exp2(log2(abs(_163 * mad(0.9836069941520691f, _140, mad(0.017604099586606026f, _139, (_138 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _205 = exp2(log2(abs(((_196 * 18.8515625f) + 0.8359375f) / ((_196 * 18.6875f) + 1.0f))) * 78.84375f);
    _214 = saturate(_179 / HDROutput_084);
    _215 = saturate(_192 / HDROutput_084);
    _216 = saturate(_205 / HDROutput_084);
    _217 = HDROutput_084 - HDROutput_036;
    _243 = select((_179 > HDROutput_076), _179, select((_179 < HDROutput_084), max((((_214 * _214) * _217) + HDROutput_036), _179), _179));
    _244 = select((_192 > HDROutput_076), _192, select((_192 < HDROutput_084), max((((_215 * _215) * _217) + HDROutput_036), _192), _192));
    _245 = select((_205 > HDROutput_076), _205, select((_205 < HDROutput_084), max((((_216 * _216) * _217) + HDROutput_036), _205), _205));
#endif
  } else {
    _243 = _86;
    _244 = _87;
    _245 = _88;
  }
  SV_Target.x = _243;
  SV_Target.y = _244;
  SV_Target.z = _245;
  SV_Target.w = _66;
  return SV_Target;
}