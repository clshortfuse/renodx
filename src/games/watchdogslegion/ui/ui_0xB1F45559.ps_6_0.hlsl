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
  bool _23;
  float4 _24;
  bool _31;
  float _35;
  float _36;
  float _37;
  float _39;
  float _90;
  float _91;
  float _92;
  float _247;
  float _248;
  float _249;
  float _126;
  float _127;
  float _128;
  float _129;
  float _137;
  float _138;
  float _142;
  float _143;
  float _144;
  float _160;
  float _167;
  float _174;
  float _183;
  float _187;
  float _196;
  float _200;
  float _209;
  float _218;
  float _219;
  float _220;
  float _221;
  _23 = ((((float4)(t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_23) discard;
  _24 = t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _31 = (FireUiPrimitive_396 != 0);
  _35 = select(_31, 1.0f, _24.x) * TEXCOORD0_centroid.x;
  _36 = select(_31, 1.0f, _24.y) * TEXCOORD0_centroid.y;
  _37 = select(_31, 1.0f, _24.z) * TEXCOORD0_centroid.z;
  _39 = dot(float3(_35, _36, _37), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _90 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max(((lerp(_39, _35, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _91 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max(((lerp(_39, _36, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _92 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max(((lerp(_39, _37, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_90, _91, _92, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _247 = color.r;
    _248 = color.g;
    _249 = color.b;
#else  // original code
    _126 = saturate(select((_90 <= 0.040449999272823334f), (_90 * 0.07739938050508499f), exp2(log2(abs((_90 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _127 = saturate(select((_91 <= 0.040449999272823334f), (_91 * 0.07739938050508499f), exp2(log2(abs((_91 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _128 = saturate(select((_92 <= 0.040449999272823334f), (_92 * 0.07739938050508499f), exp2(log2(abs((_92 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _129 = dot(float3(_126, _127, _128), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _137 = select((_129 > 0.5f), (((_129 * HDROutput_016.y) / (HDROutput_016.y - _129)) + HDROutput_016.x), (_129 / (1.000100016593933f - _129)));
    _138 = _129 + 9.999999747378752e-05f;
    _142 = _137 * (_126 / _138);
    _143 = (_127 / _138) * _137;
    _144 = (_128 / _138) * _137;
    _160 = saturate(max(max(_142, _143), _144) + -1.0f);
    _167 = HDROutput_064 * 9.999999747378752e-05f;
    _174 = exp2(log2(abs(_167 * (((1.0f - _160) * mad(0.04331360012292862f, _144, mad(0.3292819857597351f, _143, (_142 * 0.627403974533081f)))) + (_160 * mad(0.047561999410390854f, _144, mad(0.19859300553798676f, _143, (_142 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _183 = exp2(log2(abs(((_174 * 18.8515625f) + 0.8359375f) / ((_174 * 18.6875f) + 1.0f))) * 78.84375f);
    _187 = exp2(log2(abs(_167 * mad(0.012477199546992779f, _144, mad(0.9417769908905029f, _143, (_142 * 0.045745600014925f))))) * 0.1593017578125f);
    _196 = exp2(log2(abs(((_187 * 18.8515625f) + 0.8359375f) / ((_187 * 18.6875f) + 1.0f))) * 78.84375f);
    _200 = exp2(log2(abs(_167 * mad(0.9836069941520691f, _144, mad(0.017604099586606026f, _143, (_142 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _209 = exp2(log2(abs(((_200 * 18.8515625f) + 0.8359375f) / ((_200 * 18.6875f) + 1.0f))) * 78.84375f);
    _218 = saturate(_183 / HDROutput_084);
    _219 = saturate(_196 / HDROutput_084);
    _220 = saturate(_209 / HDROutput_084);
    _221 = HDROutput_084 - HDROutput_036;
    _247 = select((_183 > HDROutput_076), _183, select((_183 < HDROutput_084), max((((_218 * _218) * _221) + HDROutput_036), _183), _183));
    _248 = select((_196 > HDROutput_076), _196, select((_196 < HDROutput_084), max((((_219 * _219) * _221) + HDROutput_036), _196), _196));
    _249 = select((_209 > HDROutput_076), _209, select((_209 < HDROutput_084), max((((_220 * _220) * _221) + HDROutput_036), _209), _209));
#endif
  } else {
    _247 = _90;
    _248 = _91;
    _249 = _92;
  }
  SV_Target.x = _247;
  SV_Target.y = _248;
  SV_Target.z = _249;
  SV_Target.w = ((_24.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}