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
  float _30;
  float _31;
  float _32;
  float _188;
  float _189;
  float _190;
  float _67;
  float _68;
  float _69;
  float _70;
  float _78;
  float _79;
  float _83;
  float _84;
  float _85;
  float _101;
  float _108;
  float _115;
  float _124;
  float _128;
  float _137;
  float _141;
  float _150;
  float _159;
  float _160;
  float _161;
  float _162;
  _30 = (exp2(log2(abs(Primitive_428 * TEXCOORD0_centroid.x)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _31 = (exp2(log2(abs(Primitive_428 * TEXCOORD0_centroid.y)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _32 = (exp2(log2(abs(Primitive_428 * TEXCOORD0_centroid.z)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_30, _31, _32, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _188 = color.r;
    _189 = color.g;
    _190 = color.b;
#else  // original code
    _67 = saturate(select((_30 <= 0.040449999272823334f), (_30 * 0.07739938050508499f), exp2(log2(abs((_30 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _68 = saturate(select((_31 <= 0.040449999272823334f), (_31 * 0.07739938050508499f), exp2(log2(abs((_31 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _69 = saturate(select((_32 <= 0.040449999272823334f), (_32 * 0.07739938050508499f), exp2(log2(abs((_32 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _70 = dot(float3(_67, _68, _69), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _78 = select((_70 > 0.5f), (((_70 * HDROutput_016.y) / (HDROutput_016.y - _70)) + HDROutput_016.x), (_70 / (1.000100016593933f - _70)));
    _79 = _70 + 9.999999747378752e-05f;
    _83 = _78 * (_67 / _79);
    _84 = (_68 / _79) * _78;
    _85 = (_69 / _79) * _78;
    _101 = saturate(max(max(_83, _84), _85) + -1.0f);
    _108 = HDROutput_064 * 9.999999747378752e-05f;
    _115 = exp2(log2(abs(_108 * (((1.0f - _101) * mad(0.04331360012292862f, _85, mad(0.3292819857597351f, _84, (_83 * 0.627403974533081f)))) + (_101 * mad(0.047561999410390854f, _85, mad(0.19859300553798676f, _84, (_83 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _124 = exp2(log2(abs(((_115 * 18.8515625f) + 0.8359375f) / ((_115 * 18.6875f) + 1.0f))) * 78.84375f);
    _128 = exp2(log2(abs(_108 * mad(0.012477199546992779f, _85, mad(0.9417769908905029f, _84, (_83 * 0.045745600014925f))))) * 0.1593017578125f);
    _137 = exp2(log2(abs(((_128 * 18.8515625f) + 0.8359375f) / ((_128 * 18.6875f) + 1.0f))) * 78.84375f);
    _141 = exp2(log2(abs(_108 * mad(0.9836069941520691f, _85, mad(0.017604099586606026f, _84, (_83 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _150 = exp2(log2(abs(((_141 * 18.8515625f) + 0.8359375f) / ((_141 * 18.6875f) + 1.0f))) * 78.84375f);
    _159 = saturate(_124 / HDROutput_084);
    _160 = saturate(_137 / HDROutput_084);
    _161 = saturate(_150 / HDROutput_084);
    _162 = HDROutput_084 - HDROutput_036;
    _188 = select((_124 > HDROutput_076), _124, select((_124 < HDROutput_084), max((((_159 * _159) * _162) + HDROutput_036), _124), _124));
    _189 = select((_137 > HDROutput_076), _137, select((_137 < HDROutput_084), max((((_160 * _160) * _162) + HDROutput_036), _137), _137));
    _190 = select((_150 > HDROutput_076), _150, select((_150 < HDROutput_084), max((((_161 * _161) * _162) + HDROutput_036), _150), _150));
#endif
  } else {
    _188 = _30;
    _189 = _31;
    _190 = _32;
  }
  SV_Target.x = _188;
  SV_Target.y = _189;
  SV_Target.z = _190;
  SV_Target.w = TEXCOORD0_centroid.w;
  return SV_Target;
}