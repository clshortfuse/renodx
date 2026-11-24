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
  linear float4 TEXCOORD2_centroid : TEXCOORD2_centroid,
  linear float4 TEXCOORD3_centroid : TEXCOORD3_centroid,
  linear float2 TEXCOORD4_centroid : TEXCOORD4_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _23;
  float _28;
  float _36;
  float _219;
  float _220;
  float _221;
  float _61;
  float _62;
  float _63;
  float _98;
  float _99;
  float _100;
  float _101;
  float _109;
  float _110;
  float _114;
  float _115;
  float _116;
  float _132;
  float _139;
  float _146;
  float _155;
  float _159;
  float _168;
  float _172;
  float _181;
  float _190;
  float _191;
  float _192;
  float _193;
  _23 = t0.Sample(s0, float2((abs(dot(float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y), float2(TEXCOORD3_centroid.z, TEXCOORD3_centroid.w)) + TEXCOORD1_centroid.z) + 0.015625f), TEXCOORD1_centroid.w));
  _28 = abs(dot(float2(TEXCOORD2_centroid.x, TEXCOORD2_centroid.y), float2(TEXCOORD3_centroid.z, TEXCOORD3_centroid.w)) + TEXCOORD2_centroid.z) - TEXCOORD2_centroid.w;
  if (_28 > 0.0f) {
    _36 = ((((float4)(t0.Sample(s0, float2((_28 + 0.015625f), TEXCOORD1_centroid.w)))).w) * _23.w);
  } else {
    _36 = _23.w;
  }
  _61 = (exp2(log2(abs(Primitive_428 * TEXCOORD0_centroid.x)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _62 = (exp2(log2(abs(Primitive_428 * TEXCOORD0_centroid.y)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _63 = (exp2(log2(abs(Primitive_428 * TEXCOORD0_centroid.z)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_61, _62, _63, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _219 = color.r;
    _220 = color.g;
    _221 = color.b;
#else  // original code
    _98 = saturate(select((_61 <= 0.040449999272823334f), (_61 * 0.07739938050508499f), exp2(log2(abs((_61 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _99 = saturate(select((_62 <= 0.040449999272823334f), (_62 * 0.07739938050508499f), exp2(log2(abs((_62 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _100 = saturate(select((_63 <= 0.040449999272823334f), (_63 * 0.07739938050508499f), exp2(log2(abs((_63 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _101 = dot(float3(_98, _99, _100), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _109 = select((_101 > 0.5f), (((_101 * HDROutput_016.y) / (HDROutput_016.y - _101)) + HDROutput_016.x), (_101 / (1.000100016593933f - _101)));
    _110 = _101 + 9.999999747378752e-05f;
    _114 = _109 * (_98 / _110);
    _115 = (_99 / _110) * _109;
    _116 = (_100 / _110) * _109;
    _132 = saturate(max(max(_114, _115), _116) + -1.0f);
    _139 = HDROutput_064 * 9.999999747378752e-05f;
    _146 = exp2(log2(abs(_139 * (((1.0f - _132) * mad(0.04331360012292862f, _116, mad(0.3292819857597351f, _115, (_114 * 0.627403974533081f)))) + (_132 * mad(0.047561999410390854f, _116, mad(0.19859300553798676f, _115, (_114 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _155 = exp2(log2(abs(((_146 * 18.8515625f) + 0.8359375f) / ((_146 * 18.6875f) + 1.0f))) * 78.84375f);
    _159 = exp2(log2(abs(_139 * mad(0.012477199546992779f, _116, mad(0.9417769908905029f, _115, (_114 * 0.045745600014925f))))) * 0.1593017578125f);
    _168 = exp2(log2(abs(((_159 * 18.8515625f) + 0.8359375f) / ((_159 * 18.6875f) + 1.0f))) * 78.84375f);
    _172 = exp2(log2(abs(_139 * mad(0.9836069941520691f, _116, mad(0.017604099586606026f, _115, (_114 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _181 = exp2(log2(abs(((_172 * 18.8515625f) + 0.8359375f) / ((_172 * 18.6875f) + 1.0f))) * 78.84375f);
    _190 = saturate(_155 / HDROutput_084);
    _191 = saturate(_168 / HDROutput_084);
    _192 = saturate(_181 / HDROutput_084);
    _193 = HDROutput_084 - HDROutput_036;
    _219 = select((_155 > HDROutput_076), _155, select((_155 < HDROutput_084), max((((_190 * _190) * _193) + HDROutput_036), _155), _155));
    _220 = select((_168 > HDROutput_076), _168, select((_168 < HDROutput_084), max((((_191 * _191) * _193) + HDROutput_036), _168), _168));
    _221 = select((_181 > HDROutput_076), _181, select((_181 < HDROutput_084), max((((_192 * _192) * _193) + HDROutput_036), _181), _181));
#endif
  } else {
    _219 = _61;
    _220 = _62;
    _221 = _63;
  }
  SV_Target.x = _219;
  SV_Target.y = _220;
  SV_Target.z = _221;
  SV_Target.w = (_36 * TEXCOORD0_centroid.w);
  return SV_Target;
}