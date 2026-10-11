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

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
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

SamplerState s1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float4 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _21;
  float _25;
  float _26;
  float _27;
  float _28;
  float _68;
  float _69;
  float _70;
  float _226;
  float _227;
  float _228;
  float _105;
  float _106;
  float _107;
  float _108;
  float _116;
  float _117;
  float _121;
  float _122;
  float _123;
  float _139;
  float _146;
  float _153;
  float _162;
  float _166;
  float _175;
  float _179;
  float _188;
  float _197;
  float _198;
  float _199;
  float _200;
  _21 = t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y)));
  _25 = _21.x * 0.7400000095367432f;
  _26 = _21.y * 0.7400000095367432f;
  _27 = _21.z * 0.7400000095367432f;
  _28 = dot(float3(_25, _26, _27), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _68 = (exp2(log2(abs(((FireUiPrimitive_344 * (_25 - _28)) + _28) * FireUiPrimitive_016.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _69 = (exp2(log2(abs(((FireUiPrimitive_344 * (_26 - _28)) + _28) * FireUiPrimitive_016.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _70 = (exp2(log2(abs(((FireUiPrimitive_344 * (_27 - _28)) + _28) * FireUiPrimitive_016.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_68, _69, _70, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _226 = color.r;
    _227 = color.g;
    _228 = color.b;
#else  // original code
    _105 = saturate(select((_68 <= 0.040449999272823334f), (_68 * 0.07739938050508499f), exp2(log2(abs((_68 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _106 = saturate(select((_69 <= 0.040449999272823334f), (_69 * 0.07739938050508499f), exp2(log2(abs((_69 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _107 = saturate(select((_70 <= 0.040449999272823334f), (_70 * 0.07739938050508499f), exp2(log2(abs((_70 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _108 = dot(float3(_105, _106, _107), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _116 = select((_108 > 0.5f), (((_108 * HDROutput_016.y) / (HDROutput_016.y - _108)) + HDROutput_016.x), (_108 / (1.000100016593933f - _108)));
    _117 = _108 + 9.999999747378752e-05f;
    _121 = _116 * (_105 / _117);
    _122 = (_106 / _117) * _116;
    _123 = (_107 / _117) * _116;
    _139 = saturate(max(max(_121, _122), _123) + -1.0f);
    _146 = HDROutput_064 * 9.999999747378752e-05f;
    _153 = exp2(log2(abs(_146 * (((1.0f - _139) * mad(0.04331360012292862f, _123, mad(0.3292819857597351f, _122, (_121 * 0.627403974533081f)))) + (_139 * mad(0.047561999410390854f, _123, mad(0.19859300553798676f, _122, (_121 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _162 = exp2(log2(abs(((_153 * 18.8515625f) + 0.8359375f) / ((_153 * 18.6875f) + 1.0f))) * 78.84375f);
    _166 = exp2(log2(abs(_146 * mad(0.012477199546992779f, _123, mad(0.9417769908905029f, _122, (_121 * 0.045745600014925f))))) * 0.1593017578125f);
    _175 = exp2(log2(abs(((_166 * 18.8515625f) + 0.8359375f) / ((_166 * 18.6875f) + 1.0f))) * 78.84375f);
    _179 = exp2(log2(abs(_146 * mad(0.9836069941520691f, _123, mad(0.017604099586606026f, _122, (_121 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _188 = exp2(log2(abs(((_179 * 18.8515625f) + 0.8359375f) / ((_179 * 18.6875f) + 1.0f))) * 78.84375f);
    _197 = saturate(_162 / HDROutput_084);
    _198 = saturate(_175 / HDROutput_084);
    _199 = saturate(_188 / HDROutput_084);
    _200 = HDROutput_084 - HDROutput_036;
    _226 = select((_162 > HDROutput_076), _162, select((_162 < HDROutput_084), max((((_197 * _197) * _200) + HDROutput_036), _162), _162));
    _227 = select((_175 > HDROutput_076), _175, select((_175 < HDROutput_084), max((((_198 * _198) * _200) + HDROutput_036), _175), _175));
    _228 = select((_188 > HDROutput_076), _188, select((_188 < HDROutput_084), max((((_199 * _199) * _200) + HDROutput_036), _188), _188));
#endif
  } else {
    _226 = _68;
    _227 = _69;
    _228 = _70;
  }
  SV_Target.x = _226;
  SV_Target.y = _227;
  SV_Target.z = _228;
  SV_Target.w = (((((float4)(t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).w) * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}