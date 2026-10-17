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

cbuffer cb0 : register(b0) {
  float cb0_836x : packoffset(c836.x);
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
  linear float3 TEXCOORD3_centroid : TEXCOORD3_centroid,
  linear float4 TEXCOORD4_centroid : TEXCOORD4_centroid,
  linear float2 TEXCOORD5_centroid : TEXCOORD5_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _26;
  float _27;
  float _41;
  float4 _54;
  float _70;
  float _71;
  float _72;
  float _73;
  float _258;
  float _259;
  float _260;
  float _63;
  float _101;
  float _102;
  float _103;
  float _137;
  float _138;
  float _139;
  float _140;
  float _148;
  float _149;
  float _153;
  float _154;
  float _155;
  float _171;
  float _178;
  float _185;
  float _194;
  float _198;
  float _207;
  float _211;
  float _220;
  float _229;
  float _230;
  float _231;
  float _232;
  _26 = (TEXCOORD1_centroid.y * TEXCOORD1_centroid.y) + (TEXCOORD1_centroid.x * TEXCOORD1_centroid.x);
  _27 = (Primitive_096[2].z) - _26;
  _41 = 1.0f - min(max((((_26 + 300.0f) - (Primitive_096[2].z)) * 0.05000000074505806f), 0.0f), 1.0f);
  _54 = t0.SampleBias(s0, float2(TEXCOORD4_centroid.x, TEXCOORD4_centroid.y), cb0_836x, int2(0, 0));
  if (!(Primitive_472 == 0)) {
    _63 = 1.0f - _54.w;
    if (_63 > 0.0f) {
      _70 = (_54.x / _63);
      _71 = (_54.y / _63);
      _72 = (_54.z / _63);
      _73 = _63;
    } else {
      _70 = _54.x;
      _71 = _54.y;
      _72 = _54.z;
      _73 = _63;
    }
  } else {
    _70 = _54.x;
    _71 = _54.y;
    _72 = _54.z;
    _73 = _54.w;
  }
  _101 = (exp2(log2(abs((_70 * ((_41 * (TEXCOORD0_centroid.x + -1.0f)) + 1.0f)) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _102 = (exp2(log2(abs((_71 * ((_41 * (TEXCOORD0_centroid.y + -1.0f)) + 1.0f)) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _103 = (exp2(log2(abs((_72 * ((_41 * (TEXCOORD0_centroid.z + -1.0f)) + 1.0f)) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_101, _102, _103, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _258 = color.r;
    _259 = color.g;
    _260 = color.b;
#else  // original code
    _137 = saturate(select((_101 <= 0.040449999272823334f), (_101 * 0.07739938050508499f), exp2(log2(abs((_101 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _138 = saturate(select((_102 <= 0.040449999272823334f), (_102 * 0.07739938050508499f), exp2(log2(abs((_102 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _139 = saturate(select((_103 <= 0.040449999272823334f), (_103 * 0.07739938050508499f), exp2(log2(abs((_103 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _140 = dot(float3(_137, _138, _139), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _148 = select((_140 > 0.5f), (((_140 * HDROutput_016.y) / (HDROutput_016.y - _140)) + HDROutput_016.x), (_140 / (1.000100016593933f - _140)));
    _149 = _140 + 9.999999747378752e-05f;
    _153 = _148 * (_137 / _149);
    _154 = (_138 / _149) * _148;
    _155 = (_139 / _149) * _148;
    _171 = saturate(max(max(_153, _154), _155) + -1.0f);
    _178 = HDROutput_064 * 9.999999747378752e-05f;
    _185 = exp2(log2(abs(_178 * (((1.0f - _171) * mad(0.04331360012292862f, _155, mad(0.3292819857597351f, _154, (_153 * 0.627403974533081f)))) + (_171 * mad(0.047561999410390854f, _155, mad(0.19859300553798676f, _154, (_153 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _194 = exp2(log2(abs(((_185 * 18.8515625f) + 0.8359375f) / ((_185 * 18.6875f) + 1.0f))) * 78.84375f);
    _198 = exp2(log2(abs(_178 * mad(0.012477199546992779f, _155, mad(0.9417769908905029f, _154, (_153 * 0.045745600014925f))))) * 0.1593017578125f);
    _207 = exp2(log2(abs(((_198 * 18.8515625f) + 0.8359375f) / ((_198 * 18.6875f) + 1.0f))) * 78.84375f);
    _211 = exp2(log2(abs(_178 * mad(0.9836069941520691f, _155, mad(0.017604099586606026f, _154, (_153 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _220 = exp2(log2(abs(((_211 * 18.8515625f) + 0.8359375f) / ((_211 * 18.6875f) + 1.0f))) * 78.84375f);
    _229 = saturate(_194 / HDROutput_084);
    _230 = saturate(_207 / HDROutput_084);
    _231 = saturate(_220 / HDROutput_084);
    _232 = HDROutput_084 - HDROutput_036;
    _258 = select((_194 > HDROutput_076), _194, select((_194 < HDROutput_084), max((((_229 * _229) * _232) + HDROutput_036), _194), _194));
    _259 = select((_207 > HDROutput_076), _207, select((_207 < HDROutput_084), max((((_230 * _230) * _232) + HDROutput_036), _207), _207));
    _260 = select((_220 > HDROutput_076), _220, select((_220 < HDROutput_084), max((((_231 * _231) * _232) + HDROutput_036), _220), _220));
#endif
  } else {
    _258 = _101;
    _259 = _102;
    _260 = _103;
  }
  SV_Target.x = _258;
  SV_Target.y = _259;
  SV_Target.z = _260;
  SV_Target.w = (_73 * min((float((int)(((-int((bool)(int)(TEXCOORD0_centroid.w < 0.0f))) + 1) + ((int)(uint)((int)(TEXCOORD0_centroid.w > 0.0f))))) * 0.5f), (float((int)(((-int((bool)(int)(_27 < 0.0f))) + 1) + ((int)(uint)((int)(_27 > 0.0f))))) * 0.5f)));
  return SV_Target;
}