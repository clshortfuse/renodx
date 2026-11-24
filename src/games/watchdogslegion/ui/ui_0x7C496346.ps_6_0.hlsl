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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float2 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _8;
  float _59;
  float _60;
  float _61;
  float _217;
  float _218;
  float _219;
  float _96;
  float _97;
  float _98;
  float _99;
  float _107;
  float _108;
  float _112;
  float _113;
  float _114;
  float _130;
  float _137;
  float _144;
  float _153;
  float _157;
  float _166;
  float _170;
  float _179;
  float _188;
  float _189;
  float _190;
  float _191;
  _8 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _59 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _8)) + _8) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _60 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _8)) + _8) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _61 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _8)) + _8) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_59, _60, _61, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _217 = color.r;
    _218 = color.g;
    _219 = color.b;
#else  // original code
    _96 = saturate(select((_59 <= 0.040449999272823334f), (_59 * 0.07739938050508499f), exp2(log2(abs((_59 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _97 = saturate(select((_60 <= 0.040449999272823334f), (_60 * 0.07739938050508499f), exp2(log2(abs((_60 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _98 = saturate(select((_61 <= 0.040449999272823334f), (_61 * 0.07739938050508499f), exp2(log2(abs((_61 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _99 = dot(float3(_96, _97, _98), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _107 = select((_99 > 0.5f), (((_99 * HDROutput_016.y) / (HDROutput_016.y - _99)) + HDROutput_016.x), (_99 / (1.000100016593933f - _99)));
    _108 = _99 + 9.999999747378752e-05f;
    _112 = _107 * (_96 / _108);
    _113 = (_97 / _108) * _107;
    _114 = (_98 / _108) * _107;
    _130 = saturate(max(max(_112, _113), _114) + -1.0f);
    _137 = HDROutput_064 * 9.999999747378752e-05f;
    _144 = exp2(log2(abs(_137 * (((1.0f - _130) * mad(0.04331360012292862f, _114, mad(0.3292819857597351f, _113, (_112 * 0.627403974533081f)))) + (_130 * mad(0.047561999410390854f, _114, mad(0.19859300553798676f, _113, (_112 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _153 = exp2(log2(abs(((_144 * 18.8515625f) + 0.8359375f) / ((_144 * 18.6875f) + 1.0f))) * 78.84375f);
    _157 = exp2(log2(abs(_137 * mad(0.012477199546992779f, _114, mad(0.9417769908905029f, _113, (_112 * 0.045745600014925f))))) * 0.1593017578125f);
    _166 = exp2(log2(abs(((_157 * 18.8515625f) + 0.8359375f) / ((_157 * 18.6875f) + 1.0f))) * 78.84375f);
    _170 = exp2(log2(abs(_137 * mad(0.9836069941520691f, _114, mad(0.017604099586606026f, _113, (_112 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _179 = exp2(log2(abs(((_170 * 18.8515625f) + 0.8359375f) / ((_170 * 18.6875f) + 1.0f))) * 78.84375f);
    _188 = saturate(_153 / HDROutput_084);
    _189 = saturate(_166 / HDROutput_084);
    _190 = saturate(_179 / HDROutput_084);
    _191 = HDROutput_084 - HDROutput_036;
    _217 = select((_153 > HDROutput_076), _153, select((_153 < HDROutput_084), max((((_188 * _188) * _191) + HDROutput_036), _153), _153));
    _218 = select((_166 > HDROutput_076), _166, select((_166 < HDROutput_084), max((((_189 * _189) * _191) + HDROutput_036), _166), _166));
    _219 = select((_179 > HDROutput_076), _179, select((_179 < HDROutput_084), max((((_190 * _190) * _191) + HDROutput_036), _179), _179));
#endif
  } else {
    _217 = _59;
    _218 = _60;
    _219 = _61;
  }
  SV_Target.x = _217;
  SV_Target.y = _218;
  SV_Target.z = _219;
  SV_Target.w = (FireUiPrimitive_016.w * TEXCOORD0_centroid.w);
  return SV_Target;
}