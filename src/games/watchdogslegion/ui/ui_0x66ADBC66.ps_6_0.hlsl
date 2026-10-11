#include "UI.hlsli"

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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float2 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _35;
  float _36;
  float _37;
  float _193;
  float _194;
  float _195;
  float _72;
  float _73;
  float _74;
  float _75;
  float _83;
  float _84;
  float _88;
  float _89;
  float _90;
  float _106;
  float _113;
  float _120;
  float _129;
  float _133;
  float _142;
  float _146;
  float _155;
  float _164;
  float _165;
  float _166;
  float _167;
  _35 = (exp2(log2(abs(Primitive_080.x * TEXCOORD0_centroid.x)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _36 = (exp2(log2(abs(Primitive_080.y * TEXCOORD0_centroid.y)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _37 = (exp2(log2(abs(Primitive_080.z * TEXCOORD0_centroid.z)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_35, _36, _37, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _193 = color.r;
    _194 = color.g;
    _195 = color.b;
#else  // original code
    _72 = saturate(select((_35 <= 0.040449999272823334f), (_35 * 0.07739938050508499f), exp2(log2(abs((_35 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _73 = saturate(select((_36 <= 0.040449999272823334f), (_36 * 0.07739938050508499f), exp2(log2(abs((_36 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _74 = saturate(select((_37 <= 0.040449999272823334f), (_37 * 0.07739938050508499f), exp2(log2(abs((_37 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _75 = dot(float3(_72, _73, _74), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _83 = select((_75 > 0.5f), (((_75 * HDROutput_016.y) / (HDROutput_016.y - _75)) + HDROutput_016.x), (_75 / (1.000100016593933f - _75)));
    _84 = _75 + 9.999999747378752e-05f;
    _88 = _83 * (_72 / _84);
    _89 = (_73 / _84) * _83;
    _90 = (_74 / _84) * _83;
    _106 = saturate(max(max(_88, _89), _90) + -1.0f);
    _113 = HDROutput_064 * 9.999999747378752e-05f;
    _120 = exp2(log2(abs(_113 * (((1.0f - _106) * mad(0.04331360012292862f, _90, mad(0.3292819857597351f, _89, (_88 * 0.627403974533081f)))) + (_106 * mad(0.047561999410390854f, _90, mad(0.19859300553798676f, _89, (_88 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _129 = exp2(log2(abs(((_120 * 18.8515625f) + 0.8359375f) / ((_120 * 18.6875f) + 1.0f))) * 78.84375f);
    _133 = exp2(log2(abs(_113 * mad(0.012477199546992779f, _90, mad(0.9417769908905029f, _89, (_88 * 0.045745600014925f))))) * 0.1593017578125f);
    _142 = exp2(log2(abs(((_133 * 18.8515625f) + 0.8359375f) / ((_133 * 18.6875f) + 1.0f))) * 78.84375f);
    _146 = exp2(log2(abs(_113 * mad(0.9836069941520691f, _90, mad(0.017604099586606026f, _89, (_88 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _155 = exp2(log2(abs(((_146 * 18.8515625f) + 0.8359375f) / ((_146 * 18.6875f) + 1.0f))) * 78.84375f);
    _164 = saturate(_129 / HDROutput_084);
    _165 = saturate(_142 / HDROutput_084);
    _166 = saturate(_155 / HDROutput_084);
    _167 = HDROutput_084 - HDROutput_036;
    _193 = select((_129 > HDROutput_076), _129, select((_129 < HDROutput_084), max((((_164 * _164) * _167) + HDROutput_036), _129), _129));
    _194 = select((_142 > HDROutput_076), _142, select((_142 < HDROutput_084), max((((_165 * _165) * _167) + HDROutput_036), _142), _142));
    _195 = select((_155 > HDROutput_076), _155, select((_155 < HDROutput_084), max((((_166 * _166) * _167) + HDROutput_036), _155), _155));
#endif
  } else {
    _193 = _35;
    _194 = _36;
    _195 = _37;
  }
  SV_Target.x = _193;
  SV_Target.y = _194;
  SV_Target.z = _195;
  SV_Target.w = (Primitive_080.w * TEXCOORD0_centroid.w);
  return SV_Target;
}