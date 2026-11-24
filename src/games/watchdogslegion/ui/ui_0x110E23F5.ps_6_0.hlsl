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
  float4 _25;
  float _29;
  float _30;
  float _31;
  float _32;
  float _72;
  float _73;
  float _74;
  float _230;
  float _231;
  float _232;
  float _109;
  float _110;
  float _111;
  float _112;
  float _120;
  float _121;
  float _125;
  float _126;
  float _127;
  float _143;
  float _150;
  float _157;
  float _166;
  float _170;
  float _179;
  float _183;
  float _192;
  float _201;
  float _202;
  float _203;
  float _204;
  _25 = t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y)));
  _29 = _25.x * 0.7400000095367432f;
  _30 = _25.y * 0.7400000095367432f;
  _31 = _25.z * 0.7400000095367432f;
  _32 = dot(float3(_29, _30, _31), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _72 = (exp2(log2(abs(((FireUiPrimitive_344 * (_29 - _32)) + _32) * FireUiPrimitive_016.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _73 = (exp2(log2(abs(((FireUiPrimitive_344 * (_30 - _32)) + _32) * FireUiPrimitive_016.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _74 = (exp2(log2(abs(((FireUiPrimitive_344 * (_31 - _32)) + _32) * FireUiPrimitive_016.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_72, _73, _74, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _230 = color.r;
    _231 = color.g;
    _232 = color.b;
#else  // original code
    _109 = saturate(select((_72 <= 0.040449999272823334f), (_72 * 0.07739938050508499f), exp2(log2(abs((_72 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _110 = saturate(select((_73 <= 0.040449999272823334f), (_73 * 0.07739938050508499f), exp2(log2(abs((_73 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _111 = saturate(select((_74 <= 0.040449999272823334f), (_74 * 0.07739938050508499f), exp2(log2(abs((_74 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _112 = dot(float3(_109, _110, _111), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _120 = select((_112 > 0.5f), (((_112 * HDROutput_016.y) / (HDROutput_016.y - _112)) + HDROutput_016.x), (_112 / (1.000100016593933f - _112)));
    _121 = _112 + 9.999999747378752e-05f;
    _125 = _120 * (_109 / _121);
    _126 = (_110 / _121) * _120;
    _127 = (_111 / _121) * _120;
    _143 = saturate(max(max(_125, _126), _127) + -1.0f);
    _150 = HDROutput_064 * 9.999999747378752e-05f;
    _157 = exp2(log2(abs(_150 * (((1.0f - _143) * mad(0.04331360012292862f, _127, mad(0.3292819857597351f, _126, (_125 * 0.627403974533081f)))) + (_143 * mad(0.047561999410390854f, _127, mad(0.19859300553798676f, _126, (_125 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _166 = exp2(log2(abs(((_157 * 18.8515625f) + 0.8359375f) / ((_157 * 18.6875f) + 1.0f))) * 78.84375f);
    _170 = exp2(log2(abs(_150 * mad(0.012477199546992779f, _127, mad(0.9417769908905029f, _126, (_125 * 0.045745600014925f))))) * 0.1593017578125f);
    _179 = exp2(log2(abs(((_170 * 18.8515625f) + 0.8359375f) / ((_170 * 18.6875f) + 1.0f))) * 78.84375f);
    _183 = exp2(log2(abs(_150 * mad(0.9836069941520691f, _127, mad(0.017604099586606026f, _126, (_125 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _192 = exp2(log2(abs(((_183 * 18.8515625f) + 0.8359375f) / ((_183 * 18.6875f) + 1.0f))) * 78.84375f);
    _201 = saturate(_166 / HDROutput_084);
    _202 = saturate(_179 / HDROutput_084);
    _203 = saturate(_192 / HDROutput_084);
    _204 = HDROutput_084 - HDROutput_036;
    _230 = select((_166 > HDROutput_076), _166, select((_166 < HDROutput_084), max((((_201 * _201) * _204) + HDROutput_036), _166), _166));
    _231 = select((_179 > HDROutput_076), _179, select((_179 < HDROutput_084), max((((_202 * _202) * _204) + HDROutput_036), _179), _179));
    _232 = select((_192 > HDROutput_076), _192, select((_192 < HDROutput_084), max((((_203 * _203) * _204) + HDROutput_036), _192), _192));
#endif
  } else {
    _230 = _72;
    _231 = _73;
    _232 = _74;
  }
  SV_Target.x = _230;
  SV_Target.y = _231;
  SV_Target.z = _232;
  SV_Target.w = ((select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y)) * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}