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
  float _19;
  float _70;
  float _71;
  float _72;
  float _227;
  float _228;
  float _229;
  float _106;
  float _107;
  float _108;
  float _109;
  float _117;
  float _118;
  float _122;
  float _123;
  float _124;
  float _140;
  float _147;
  float _154;
  float _163;
  float _167;
  float _176;
  float _180;
  float _189;
  float _198;
  float _199;
  float _200;
  float _201;
  _19 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _70 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _19)) + _19) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _71 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _19)) + _19) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _72 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _19)) + _19) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_70, _71, _72, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _227 = color.r;
    _228 = color.g;
    _229 = color.b;
#else  // original code
    _106 = saturate(select((_70 <= 0.040449999272823334f), (_70 * 0.07739938050508499f), exp2(log2(abs((_70 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _107 = saturate(select((_71 <= 0.040449999272823334f), (_71 * 0.07739938050508499f), exp2(log2(abs((_71 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _108 = saturate(select((_72 <= 0.040449999272823334f), (_72 * 0.07739938050508499f), exp2(log2(abs((_72 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _109 = dot(float3(_106, _107, _108), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _117 = select((_109 > 0.5f), (((_109 * HDROutput_016.y) / (HDROutput_016.y - _109)) + HDROutput_016.x), (_109 / (1.000100016593933f - _109)));
    _118 = _109 + 9.999999747378752e-05f;
    _122 = _117 * (_106 / _118);
    _123 = (_107 / _118) * _117;
    _124 = (_108 / _118) * _117;
    _140 = saturate(max(max(_122, _123), _124) + -1.0f);
    _147 = HDROutput_064 * 9.999999747378752e-05f;
    _154 = exp2(log2(abs(_147 * (((1.0f - _140) * mad(0.04331360012292862f, _124, mad(0.3292819857597351f, _123, (_122 * 0.627403974533081f)))) + (_140 * mad(0.047561999410390854f, _124, mad(0.19859300553798676f, _123, (_122 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _163 = exp2(log2(abs(((_154 * 18.8515625f) + 0.8359375f) / ((_154 * 18.6875f) + 1.0f))) * 78.84375f);
    _167 = exp2(log2(abs(_147 * mad(0.012477199546992779f, _124, mad(0.9417769908905029f, _123, (_122 * 0.045745600014925f))))) * 0.1593017578125f);
    _176 = exp2(log2(abs(((_167 * 18.8515625f) + 0.8359375f) / ((_167 * 18.6875f) + 1.0f))) * 78.84375f);
    _180 = exp2(log2(abs(_147 * mad(0.9836069941520691f, _124, mad(0.017604099586606026f, _123, (_122 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _189 = exp2(log2(abs(((_180 * 18.8515625f) + 0.8359375f) / ((_180 * 18.6875f) + 1.0f))) * 78.84375f);
    _198 = saturate(_163 / HDROutput_084);
    _199 = saturate(_176 / HDROutput_084);
    _200 = saturate(_189 / HDROutput_084);
    _201 = HDROutput_084 - HDROutput_036;
    _227 = select((_163 > HDROutput_076), _163, select((_163 < HDROutput_084), max((((_198 * _198) * _201) + HDROutput_036), _163), _163));
    _228 = select((_176 > HDROutput_076), _176, select((_176 < HDROutput_084), max((((_199 * _199) * _201) + HDROutput_036), _176), _176));
    _229 = select((_189 > HDROutput_076), _189, select((_189 < HDROutput_084), max((((_200 * _200) * _201) + HDROutput_036), _189), _189));
#endif
  } else {
    _227 = _70;
    _228 = _71;
    _229 = _72;
  }
  SV_Target.x = _227;
  SV_Target.y = _228;
  SV_Target.z = _229;
  SV_Target.w = ((select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y)) * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}