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
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
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
  linear float2 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  bool _19;
  float _20;
  float _80;
  float _81;
  float _82;
  float _238;
  float _239;
  float _240;
  float _117;
  float _118;
  float _119;
  float _120;
  float _128;
  float _129;
  float _133;
  float _134;
  float _135;
  float _151;
  float _158;
  float _165;
  float _174;
  float _178;
  float _187;
  float _191;
  float _200;
  float _209;
  float _210;
  float _211;
  float _212;
  _19 = ((((float4)(t0.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_19) discard;
  _20 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _80 = (exp2(log2(abs((FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _20)) + _20) * cb0_836w), 0.0f), 64512.0f)) + FireUiPrimitive_000.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _81 = (exp2(log2(abs((FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _20)) + _20) * cb0_836w), 0.0f), 64512.0f)) + FireUiPrimitive_000.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _82 = (exp2(log2(abs((FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _20)) + _20) * cb0_836w), 0.0f), 64512.0f)) + FireUiPrimitive_000.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_80, _81, _82, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _238 = color.r;
    _239 = color.g;
    _240 = color.b;
#else  // original code
    _117 = saturate(select((_80 <= 0.040449999272823334f), (_80 * 0.07739938050508499f), exp2(log2(abs((_80 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _118 = saturate(select((_81 <= 0.040449999272823334f), (_81 * 0.07739938050508499f), exp2(log2(abs((_81 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _119 = saturate(select((_82 <= 0.040449999272823334f), (_82 * 0.07739938050508499f), exp2(log2(abs((_82 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _120 = dot(float3(_117, _118, _119), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _128 = select((_120 > 0.5f), (((_120 * HDROutput_016.y) / (HDROutput_016.y - _120)) + HDROutput_016.x), (_120 / (1.000100016593933f - _120)));
    _129 = _120 + 9.999999747378752e-05f;
    _133 = _128 * (_117 / _129);
    _134 = (_118 / _129) * _128;
    _135 = (_119 / _129) * _128;
    _151 = saturate(max(max(_133, _134), _135) + -1.0f);
    _158 = HDROutput_064 * 9.999999747378752e-05f;
    _165 = exp2(log2(abs(_158 * (((1.0f - _151) * mad(0.04331360012292862f, _135, mad(0.3292819857597351f, _134, (_133 * 0.627403974533081f)))) + (_151 * mad(0.047561999410390854f, _135, mad(0.19859300553798676f, _134, (_133 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _174 = exp2(log2(abs(((_165 * 18.8515625f) + 0.8359375f) / ((_165 * 18.6875f) + 1.0f))) * 78.84375f);
    _178 = exp2(log2(abs(_158 * mad(0.012477199546992779f, _135, mad(0.9417769908905029f, _134, (_133 * 0.045745600014925f))))) * 0.1593017578125f);
    _187 = exp2(log2(abs(((_178 * 18.8515625f) + 0.8359375f) / ((_178 * 18.6875f) + 1.0f))) * 78.84375f);
    _191 = exp2(log2(abs(_158 * mad(0.9836069941520691f, _135, mad(0.017604099586606026f, _134, (_133 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _200 = exp2(log2(abs(((_191 * 18.8515625f) + 0.8359375f) / ((_191 * 18.6875f) + 1.0f))) * 78.84375f);
    _209 = saturate(_174 / HDROutput_084);
    _210 = saturate(_187 / HDROutput_084);
    _211 = saturate(_200 / HDROutput_084);
    _212 = HDROutput_084 - HDROutput_036;
    _238 = select((_174 > HDROutput_076), _174, select((_174 < HDROutput_084), max((((_209 * _209) * _212) + HDROutput_036), _174), _174));
    _239 = select((_187 > HDROutput_076), _187, select((_187 < HDROutput_084), max((((_210 * _210) * _212) + HDROutput_036), _187), _187));
    _240 = select((_200 > HDROutput_076), _200, select((_200 < HDROutput_084), max((((_211 * _211) * _212) + HDROutput_036), _200), _200));
#endif
  } else {
    _238 = _80;
    _239 = _81;
    _240 = _82;
  }
  SV_Target.x = _238;
  SV_Target.y = _239;
  SV_Target.z = _240;
  SV_Target.w = ((FireUiPrimitive_016.w * TEXCOORD0_centroid.w) + FireUiPrimitive_000.w);
  return SV_Target;
}