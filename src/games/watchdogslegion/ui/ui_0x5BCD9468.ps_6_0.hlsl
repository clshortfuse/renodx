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
  linear float4 TEXCOORD3_centroid : TEXCOORD3_centroid,
  linear float4 TEXCOORD4_centroid : TEXCOORD4_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _22;
  float _38;
  float _39;
  float _40;
  float _41;
  float _226;
  float _227;
  float _228;
  float _31;
  float _69;
  float _70;
  float _71;
  float _105;
  float _106;
  float _107;
  float _108;
  float _116;
  float _117;
  float _121;
  float _122;
  float _123;
  float _139;
  float _146;
  float _153;
  float _162;
  float _166;
  float _175;
  float _179;
  float _188;
  float _197;
  float _198;
  float _199;
  float _200;
  _22 = t0.SampleBias(s0, float2(TEXCOORD3_centroid.z, TEXCOORD3_centroid.w), cb0_836x, int2(0, 0));
  if (!(Primitive_472 == 0)) {
    _31 = 1.0f - _22.w;
    if (_31 > 0.0f) {
      _38 = (_22.x / _31);
      _39 = (_22.y / _31);
      _40 = (_22.z / _31);
      _41 = _31;
    } else {
      _38 = _22.x;
      _39 = _22.y;
      _40 = _22.z;
      _41 = _31;
    }
  } else {
    _38 = _22.x;
    _39 = _22.y;
    _40 = _22.z;
    _41 = _22.w;
  }
  _69 = (exp2(log2(abs((_38 * TEXCOORD0_centroid.x) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _70 = (exp2(log2(abs((_39 * TEXCOORD0_centroid.y) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _71 = (exp2(log2(abs((_40 * TEXCOORD0_centroid.z) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_69, _70, _71, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _226 = color.r;
    _227 = color.g;
    _228 = color.b;
#else  // original code
    _105 = saturate(select((_69 <= 0.040449999272823334f), (_69 * 0.07739938050508499f), exp2(log2(abs((_69 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _106 = saturate(select((_70 <= 0.040449999272823334f), (_70 * 0.07739938050508499f), exp2(log2(abs((_70 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _107 = saturate(select((_71 <= 0.040449999272823334f), (_71 * 0.07739938050508499f), exp2(log2(abs((_71 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _108 = dot(float3(_105, _106, _107), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _116 = select((_108 > 0.5f), (((_108 * HDROutput_016.y) / (HDROutput_016.y - _108)) + HDROutput_016.x), (_108 / (1.000100016593933f - _108)));
    _117 = _108 + 9.999999747378752e-05f;
    _121 = _116 * (_105 / _117);
    _122 = (_106 / _117) * _116;
    _123 = (_107 / _117) * _116;
    _139 = saturate(max(max(_121, _122), _123) + -1.0f);
    _146 = HDROutput_064 * 9.999999747378752e-05f;
    _153 = exp2(log2(abs(_146 * (((1.0f - _139) * mad(0.04331360012292862f, _123, mad(0.3292819857597351f, _122, (_121 * 0.627403974533081f)))) + (_139 * mad(0.047561999410390854f, _123, mad(0.19859300553798676f, _122, (_121 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _162 = exp2(log2(abs(((_153 * 18.8515625f) + 0.8359375f) / ((_153 * 18.6875f) + 1.0f))) * 78.84375f);
    _166 = exp2(log2(abs(_146 * mad(0.012477199546992779f, _123, mad(0.9417769908905029f, _122, (_121 * 0.045745600014925f))))) * 0.1593017578125f);
    _175 = exp2(log2(abs(((_166 * 18.8515625f) + 0.8359375f) / ((_166 * 18.6875f) + 1.0f))) * 78.84375f);
    _179 = exp2(log2(abs(_146 * mad(0.9836069941520691f, _123, mad(0.017604099586606026f, _122, (_121 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _188 = exp2(log2(abs(((_179 * 18.8515625f) + 0.8359375f) / ((_179 * 18.6875f) + 1.0f))) * 78.84375f);
    _197 = saturate(_162 / HDROutput_084);
    _198 = saturate(_175 / HDROutput_084);
    _199 = saturate(_188 / HDROutput_084);
    _200 = HDROutput_084 - HDROutput_036;
    _226 = select((_162 > HDROutput_076), _162, select((_162 < HDROutput_084), max((((_197 * _197) * _200) + HDROutput_036), _162), _162));
    _227 = select((_175 > HDROutput_076), _175, select((_175 < HDROutput_084), max((((_198 * _198) * _200) + HDROutput_036), _175), _175));
    _228 = select((_188 > HDROutput_076), _188, select((_188 < HDROutput_084), max((((_199 * _199) * _200) + HDROutput_036), _188), _188));
#endif
  } else {
    _226 = _69;
    _227 = _70;
    _228 = _71;
  }
  SV_Target.x = _226;
  SV_Target.y = _227;
  SV_Target.z = _228;
  SV_Target.w = ((float((int)(((-int((bool)(int)(TEXCOORD0_centroid.w < 0.0f))) + 1) + ((int)(uint)((int)(TEXCOORD0_centroid.w > 0.0f))))) * 0.5f) * _41);
  return SV_Target;
}