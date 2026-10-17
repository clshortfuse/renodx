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
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    linear float4 TEXCOORD0_centroid: TEXCOORD0_centroid,
    linear float4 TEXCOORD1_centroid: TEXCOORD1_centroid,
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  bool _23;
  float _29;
  float _31;
  float _59;
  float _60;
  float _61;
  float _62;
  float _75;
  float _76;
  float _77;
  float _78;
  float _255;
  float _256;
  float _257;
  float _98;
  float _99;
  float _100;
  float _134;
  float _135;
  float _136;
  float _137;
  float _145;
  float _146;
  float _150;
  float _151;
  float _152;
  float _168;
  float _175;
  float _182;
  float _191;
  float _195;
  float _204;
  float _208;
  float _217;
  float _226;
  float _227;
  float _228;
  float _229;
  _23 = ((((float4)(t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_23) discard;
  _29 = select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y));
  _31 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _59 = FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _31)) + _31) * cb0_836w), 0.0f), 64512.0f);
  _60 = FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _31)) + _31) * cb0_836w), 0.0f), 64512.0f);
  _61 = FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _31)) + _31) * cb0_836w), 0.0f), 64512.0f);
  _62 = (_29 * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_29 > 0.0f) {
    _75 = (FireUiPrimitive_000.x + _59);
    _76 = (FireUiPrimitive_000.y + _60);
    _77 = (FireUiPrimitive_000.z + _61);
    _78 = (FireUiPrimitive_000.w + _62);
  } else {
    _75 = _59;
    _76 = _60;
    _77 = _61;
    _78 = _62;
  }
  _98 = (exp2(log2(abs(_75)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _99 = (exp2(log2(abs(_76)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _100 = (exp2(log2(abs(_77)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_98, _99, _100, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _255 = color.r;
    _256 = color.g;
    _257 = color.b;
#else  // original code
    _134 = saturate(select((_98 <= 0.040449999272823334f), (_98 * 0.07739938050508499f), exp2(log2(abs((_98 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _135 = saturate(select((_99 <= 0.040449999272823334f), (_99 * 0.07739938050508499f), exp2(log2(abs((_99 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _136 = saturate(select((_100 <= 0.040449999272823334f), (_100 * 0.07739938050508499f), exp2(log2(abs((_100 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _137 = dot(float3(_134, _135, _136), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _145 = select((_137 > 0.5f), (((_137 * HDROutput_016.y) / (HDROutput_016.y - _137)) + HDROutput_016.x), (_137 / (1.000100016593933f - _137)));
    _146 = _137 + 9.999999747378752e-05f;
    _150 = _145 * (_134 / _146);
    _151 = (_135 / _146) * _145;
    _152 = (_136 / _146) * _145;
    _168 = saturate(max(max(_150, _151), _152) + -1.0f);
    _175 = HDROutput_064 * 9.999999747378752e-05f;
    _182 = exp2(log2(abs(_175 * (((1.0f - _168) * mad(0.04331360012292862f, _152, mad(0.3292819857597351f, _151, (_150 * 0.627403974533081f)))) + (_168 * mad(0.047561999410390854f, _152, mad(0.19859300553798676f, _151, (_150 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _191 = exp2(log2(abs(((_182 * 18.8515625f) + 0.8359375f) / ((_182 * 18.6875f) + 1.0f))) * 78.84375f);
    _195 = exp2(log2(abs(_175 * mad(0.012477199546992779f, _152, mad(0.9417769908905029f, _151, (_150 * 0.045745600014925f))))) * 0.1593017578125f);
    _204 = exp2(log2(abs(((_195 * 18.8515625f) + 0.8359375f) / ((_195 * 18.6875f) + 1.0f))) * 78.84375f);
    _208 = exp2(log2(abs(_175 * mad(0.9836069941520691f, _152, mad(0.017604099586606026f, _151, (_150 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _217 = exp2(log2(abs(((_208 * 18.8515625f) + 0.8359375f) / ((_208 * 18.6875f) + 1.0f))) * 78.84375f);
    _226 = saturate(_191 / HDROutput_084);
    _227 = saturate(_204 / HDROutput_084);
    _228 = saturate(_217 / HDROutput_084);
    _229 = HDROutput_084 - HDROutput_036;
    _255 = select((_191 > HDROutput_076), _191, select((_191 < HDROutput_084), max((((_226 * _226) * _229) + HDROutput_036), _191), _191));
    _256 = select((_204 > HDROutput_076), _204, select((_204 < HDROutput_084), max((((_227 * _227) * _229) + HDROutput_036), _204), _204));
    _257 = select((_217 > HDROutput_076), _217, select((_217 < HDROutput_084), max((((_228 * _228) * _229) + HDROutput_036), _217), _217));
#endif
  } else {
    _255 = _98;
    _256 = _99;
    _257 = _100;
  }
  SV_Target.x = _255;
  SV_Target.y = _256;
  SV_Target.z = _257;
  SV_Target.w = _78;
  return SV_Target;
}
