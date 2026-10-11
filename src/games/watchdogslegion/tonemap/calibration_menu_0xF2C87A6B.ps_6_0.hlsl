#include "tonemap.hlsli"

Texture2D<float4> t0 : register(t0);

Texture3D<float4> t1 : register(t1);

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
  float _18;
  float _19;
  float4 _20;
  float4 _30;
  float4 _40;
  float4 _50;
  float4 _60;
  float _69;
  float _70;
  float _71;
  float _73;
  float _113;
  float _114;
  float _115;
  float _247;
  float _248;
  float _249;
  float4 _123;
  float _130;
  float _131;
  float _132;
  float _133;
  float _165;
  float _166;
  float _172;
  float _178;
  float _179;
  float _180;
  float _196;
  float _203;
  float _210;
  float _223;
  float _236;
  _18 = FireUiPrimitive_384 * FireUiPrimitive_032.z;
  _19 = FireUiPrimitive_384 * FireUiPrimitive_032.w;
  _20 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _30 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, (TEXCOORD1_centroid.y - _19)));
  _40 = t0.Sample(s0, float2((TEXCOORD1_centroid.x - _18), TEXCOORD1_centroid.y));
  _50 = t0.Sample(s0, float2((_18 + TEXCOORD1_centroid.x), TEXCOORD1_centroid.y));
  _60 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, (_19 + TEXCOORD1_centroid.y)));
  _69 = (((((_20.x * 5.0f) - _30.x) - _40.x) - _50.x) - _60.x) * TEXCOORD0_centroid.x;
  _70 = (((((_20.y * 5.0f) - _30.y) - _40.y) - _50.y) - _60.y) * TEXCOORD0_centroid.y;
  _71 = (((((_20.z * 5.0f) - _30.z) - _40.z) - _50.z) - _60.z) * TEXCOORD0_centroid.z;
  _73 = dot(float3(_69, _70, _71), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _113 = (exp2(log2(abs((lerp(_73, _69, FireUiPrimitive_344)) * FireUiPrimitive_016.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _114 = (exp2(log2(abs((lerp(_73, _70, FireUiPrimitive_344)) * FireUiPrimitive_016.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _115 = (exp2(log2(abs((lerp(_73, _71, FireUiPrimitive_344)) * FireUiPrimitive_016.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
    _123 = t1.SampleLevel(s1, float3(saturate(_113), saturate(_114), saturate(_115)), 0.0f);
#if 1  // custom code
    _130 = (_123.x);
    _131 = (_123.y);
    _132 = (_123.z);
    float3 color = EncodeHDRLUT(_130, _131, _132, HDROutput_000, HDROutput_064).rgb;
    _247 = color.r;
    _248 = color.g;
    _249 = color.b;
#else  // original code
    _130 = saturate(_123.x);
    _131 = saturate(_123.y);
    _132 = saturate(_123.z);
    _133 = dot(float3(_130, _131, _132), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _165 = select((_133 > 0.5f), (((_133 * HDROutput_000.y) / (HDROutput_000.y - _133)) + HDROutput_000.x), (_133 / (1.000100016593933f - _133)));
    _166 = _133 + 9.999999747378752e-05f;
    _172 = _165 * 0.75f;
    _178 = (((_130 / _166) * 0.75f) * _165) + (select((_130 > 0.5f), (((HDROutput_000.y * _130) / (HDROutput_000.y - _130)) + HDROutput_000.x), (_130 / (1.000100016593933f - _130))) * 0.25f);
    _179 = (_172 * (_131 / _166)) + (select((_131 > 0.5f), (((_131 * HDROutput_000.y) / (HDROutput_000.y - _131)) + HDROutput_000.x), (_131 / (1.000100016593933f - _131))) * 0.25f);
    _180 = (_172 * (_132 / _166)) + (select((_132 > 0.5f), (((_132 * HDROutput_000.y) / (HDROutput_000.y - _132)) + HDROutput_000.x), (_132 / (1.000100016593933f - _132))) * 0.25f);
    _196 = saturate(max(max(_178, _179), _180) + -1.0f);
    _203 = HDROutput_064 * 9.999999747378752e-05f;
    _210 = exp2(log2(abs(_203 * (((1.0f - _196) * mad(0.04331360012292862f, _180, mad(0.3292819857597351f, _179, (_178 * 0.627403974533081f)))) + (_196 * mad(0.047561999410390854f, _180, mad(0.19859300553798676f, _179, (_178 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _223 = exp2(log2(abs(_203 * mad(0.012477199546992779f, _180, mad(0.9417769908905029f, _179, (_178 * 0.045745600014925f))))) * 0.1593017578125f);
    _236 = exp2(log2(abs(_203 * mad(0.9836069941520691f, _180, mad(0.017604099586606026f, _179, (_178 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _247 = exp2(log2(abs(((_210 * 18.8515625f) + 0.8359375f) / ((_210 * 18.6875f) + 1.0f))) * 78.84375f);
    _248 = exp2(log2(abs(((_223 * 18.8515625f) + 0.8359375f) / ((_223 * 18.6875f) + 1.0f))) * 78.84375f);
    _249 = exp2(log2(abs(((_236 * 18.8515625f) + 0.8359375f) / ((_236 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
  } else {
    _247 = _113;
    _248 = _114;
    _249 = _115;
  }
  SV_Target.x = _247;
  SV_Target.y = _248;
  SV_Target.z = _249;
  SV_Target.w = (((((((_20.w * 5.0f) - _30.w) - _40.w) - _50.w) - _60.w) * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}
