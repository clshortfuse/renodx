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
  float _79;
  float _80;
  float _81;
  float _237;
  float _238;
  float _239;
  float _116;
  float _117;
  float _118;
  float _119;
  float _127;
  float _128;
  float _132;
  float _133;
  float _134;
  float _150;
  float _157;
  float _164;
  float _173;
  float _177;
  float _186;
  float _190;
  float _199;
  float _208;
  float _209;
  float _210;
  float _211;
  _21 = t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y)));
  _25 = _21.x * 0.7400000095367432f;
  _26 = _21.y * 0.7400000095367432f;
  _27 = _21.z * 0.7400000095367432f;
  _28 = dot(float3(_25, _26, _27), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _79 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (_25 - _28)) + _28) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _80 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (_26 - _28)) + _28) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _81 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (_27 - _28)) + _28) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_79, _80, _81, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _237 = color.r;
    _238 = color.g;
    _239 = color.b;
#else  // original code
    _116 = saturate(select((_79 <= 0.040449999272823334f), (_79 * 0.07739938050508499f), exp2(log2(abs((_79 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _117 = saturate(select((_80 <= 0.040449999272823334f), (_80 * 0.07739938050508499f), exp2(log2(abs((_80 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _118 = saturate(select((_81 <= 0.040449999272823334f), (_81 * 0.07739938050508499f), exp2(log2(abs((_81 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _119 = dot(float3(_116, _117, _118), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _127 = select((_119 > 0.5f), (((_119 * HDROutput_016.y) / (HDROutput_016.y - _119)) + HDROutput_016.x), (_119 / (1.000100016593933f - _119)));
    _128 = _119 + 9.999999747378752e-05f;
    _132 = _127 * (_116 / _128);
    _133 = (_117 / _128) * _127;
    _134 = (_118 / _128) * _127;
    _150 = saturate(max(max(_132, _133), _134) + -1.0f);
    _157 = HDROutput_064 * 9.999999747378752e-05f;
    _164 = exp2(log2(abs(_157 * (((1.0f - _150) * mad(0.04331360012292862f, _134, mad(0.3292819857597351f, _133, (_132 * 0.627403974533081f)))) + (_150 * mad(0.047561999410390854f, _134, mad(0.19859300553798676f, _133, (_132 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _173 = exp2(log2(abs(((_164 * 18.8515625f) + 0.8359375f) / ((_164 * 18.6875f) + 1.0f))) * 78.84375f);
    _177 = exp2(log2(abs(_157 * mad(0.012477199546992779f, _134, mad(0.9417769908905029f, _133, (_132 * 0.045745600014925f))))) * 0.1593017578125f);
    _186 = exp2(log2(abs(((_177 * 18.8515625f) + 0.8359375f) / ((_177 * 18.6875f) + 1.0f))) * 78.84375f);
    _190 = exp2(log2(abs(_157 * mad(0.9836069941520691f, _134, mad(0.017604099586606026f, _133, (_132 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _199 = exp2(log2(abs(((_190 * 18.8515625f) + 0.8359375f) / ((_190 * 18.6875f) + 1.0f))) * 78.84375f);
    _208 = saturate(_173 / HDROutput_084);
    _209 = saturate(_186 / HDROutput_084);
    _210 = saturate(_199 / HDROutput_084);
    _211 = HDROutput_084 - HDROutput_036;
    _237 = select((_173 > HDROutput_076), _173, select((_173 < HDROutput_084), max((((_208 * _208) * _211) + HDROutput_036), _173), _173));
    _238 = select((_186 > HDROutput_076), _186, select((_186 < HDROutput_084), max((((_209 * _209) * _211) + HDROutput_036), _186), _186));
    _239 = select((_199 > HDROutput_076), _199, select((_199 < HDROutput_084), max((((_210 * _210) * _211) + HDROutput_036), _199), _199));
#endif
  } else {
    _237 = _79;
    _238 = _80;
    _239 = _81;
  }
  SV_Target.x = _237;
  SV_Target.y = _238;
  SV_Target.z = _239;
  SV_Target.w = (((((float4)(t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).w) * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}