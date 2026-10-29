#include "UI.hlsli"

Texture2D<float4> t0 : register(t0);

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
  float4 Primitive_000 : packoffset(c000.x);
  float4 Primitive_016 : packoffset(c001.x);
  float4 Primitive_032 : packoffset(c002.x);
  float4 Primitive_048 : packoffset(c003.x);
  float4 Primitive_064 : packoffset(c004.x);
  float4 Primitive_080 : packoffset(c005.x);
  float4 Primitive_096[4] : packoffset(c006.x);
  float4 Primitive_160[4] : packoffset(c010.x);
  float4 Primitive_224[4] : packoffset(c014.x);
  float4 Primitive_288[8] : packoffset(c018.x);
  float3 Primitive_416 : packoffset(c026.x);
  float Primitive_428 : packoffset(c026.w);
  float2 Primitive_432 : packoffset(c027.x);
  float Primitive_440 : packoffset(c027.z);
  float Primitive_444 : packoffset(c027.w);
  float2 Primitive_448 : packoffset(c028.x);
  float Primitive_456 : packoffset(c028.z);
  int Primitive_460 : packoffset(c028.w);
  int Primitive_464 : packoffset(c029.x);
  int Primitive_468 : packoffset(c029.y);
  int Primitive_472 : packoffset(c029.z);
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
  float _51;
  float _52;
  float4 _88;
  float4 _90;
  float4 _92;
  float _98;
  float _300;
  float _301;
  float _302;
  float _142;
  float _143;
  float _144;
  float _179;
  float _180;
  float _181;
  float _182;
  float _190;
  float _191;
  float _195;
  float _196;
  float _197;
  float _213;
  float _220;
  float _227;
  float _236;
  float _240;
  float _249;
  float _253;
  float _262;
  float _271;
  float _272;
  float _273;
  float _274;
  _51 = frac(TEXCOORD1_centroid.x);
  _52 = frac(TEXCOORD1_centroid.y);
  _88 = t0.Sample(s0, float2(min(max(((_51 * (Primitive_288[0].x)) + (Primitive_288[0].z)), (Primitive_288[4].x)), (Primitive_288[5].x)), min(max(((_52 * (Primitive_288[0].y)) + (Primitive_288[0].w)), (Primitive_288[4].y)), (Primitive_288[5].y))));
  _90 = t0.Sample(s0, float2(min(max(((_51 * (Primitive_288[2].x)) + (Primitive_288[2].z)), (Primitive_288[6].x)), (Primitive_288[7].x)), min(max(((_52 * (Primitive_288[2].y)) + (Primitive_288[2].w)), (Primitive_288[6].y)), (Primitive_288[7].y))));
  _92 = t0.Sample(s0, float2(min(max(((_51 * (Primitive_288[3].x)) + (Primitive_288[3].z)), (Primitive_288[6].z)), (Primitive_288[7].z)), min(max(((_52 * (Primitive_288[3].y)) + (Primitive_288[3].w)), (Primitive_288[6].w)), (Primitive_288[7].w))));
  if (((Primitive_288[1].z) >= 0.0f) && ((Primitive_288[1].w) >= 0.0f)) {
    _98 = (((float4)(t0.Sample(s0, float2(min(max(((_51 * (Primitive_288[1].x)) + (Primitive_288[1].z)), (Primitive_288[4].z)), (Primitive_288[5].z)), min(max(((_52 * (Primitive_288[1].y)) + (Primitive_288[1].w)), (Primitive_288[4].w)), (Primitive_288[5].w)))))).x);
  } else {
    _98 = 1.0f;
  }
  _142 = (exp2(log2(abs((((_88.x + -0.7037500143051147f) + (_90.x * 1.4019999504089355f)) * TEXCOORD0_centroid.x) * Primitive_080.x)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _143 = (exp2(log2(abs(((((_88.x + 0.531220018863678f) - (_90.x * 0.714139997959137f)) - (_92.x * 0.3441399931907654f)) * TEXCOORD0_centroid.y) * Primitive_080.y)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _144 = (exp2(log2(abs((((_88.x + -0.8894699811935425f) + (_92.x * 1.7719999551773071f)) * TEXCOORD0_centroid.z) * Primitive_080.z)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_142, _143, _144, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _300 = color.r;
    _301 = color.g;
    _302 = color.b;
#else  // original code
    _179 = saturate(select((_142 <= 0.040449999272823334f), (_142 * 0.07739938050508499f), exp2(log2(abs((_142 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _180 = saturate(select((_143 <= 0.040449999272823334f), (_143 * 0.07739938050508499f), exp2(log2(abs((_143 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _181 = saturate(select((_144 <= 0.040449999272823334f), (_144 * 0.07739938050508499f), exp2(log2(abs((_144 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _182 = dot(float3(_179, _180, _181), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _190 = select((_182 > 0.5f), (((_182 * HDROutput_016.y) / (HDROutput_016.y - _182)) + HDROutput_016.x), (_182 / (1.000100016593933f - _182)));
    _191 = _182 + 9.999999747378752e-05f;
    _195 = _190 * (_179 / _191);
    _196 = (_180 / _191) * _190;
    _197 = (_181 / _191) * _190;
    _213 = saturate(max(max(_195, _196), _197) + -1.0f);
    _220 = HDROutput_064 * 9.999999747378752e-05f;
    _227 = exp2(log2(abs(_220 * (((1.0f - _213) * mad(0.04331360012292862f, _197, mad(0.3292819857597351f, _196, (_195 * 0.627403974533081f)))) + (_213 * mad(0.047561999410390854f, _197, mad(0.19859300553798676f, _196, (_195 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _236 = exp2(log2(abs(((_227 * 18.8515625f) + 0.8359375f) / ((_227 * 18.6875f) + 1.0f))) * 78.84375f);
    _240 = exp2(log2(abs(_220 * mad(0.012477199546992779f, _197, mad(0.9417769908905029f, _196, (_195 * 0.045745600014925f))))) * 0.1593017578125f);
    _249 = exp2(log2(abs(((_240 * 18.8515625f) + 0.8359375f) / ((_240 * 18.6875f) + 1.0f))) * 78.84375f);
    _253 = exp2(log2(abs(_220 * mad(0.9836069941520691f, _197, mad(0.017604099586606026f, _196, (_195 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _262 = exp2(log2(abs(((_253 * 18.8515625f) + 0.8359375f) / ((_253 * 18.6875f) + 1.0f))) * 78.84375f);
    _271 = saturate(_236 / HDROutput_084);
    _272 = saturate(_249 / HDROutput_084);
    _273 = saturate(_262 / HDROutput_084);
    _274 = HDROutput_084 - HDROutput_036;
    _300 = select((_236 > HDROutput_076), _236, select((_236 < HDROutput_084), max((((_271 * _271) * _274) + HDROutput_036), _236), _236));
    _301 = select((_249 > HDROutput_076), _249, select((_249 < HDROutput_084), max((((_272 * _272) * _274) + HDROutput_036), _249), _249));
    _302 = select((_262 > HDROutput_076), _262, select((_262 < HDROutput_084), max((((_273 * _273) * _274) + HDROutput_036), _262), _262));
#endif
  } else {
    _300 = _142;
    _301 = _143;
    _302 = _144;
  }
  SV_Target.x = _300;
  SV_Target.y = _301;
  SV_Target.z = _302;
  SV_Target.w = ((_98 * TEXCOORD0_centroid.w) * Primitive_080.w);
  return SV_Target;
}