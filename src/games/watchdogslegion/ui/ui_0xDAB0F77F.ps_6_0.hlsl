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
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _14;
  float _30;
  float _31;
  float _32;
  float _33;
  float _218;
  float _219;
  float _220;
  float _23;
  float _61;
  float _62;
  float _63;
  float _97;
  float _98;
  float _99;
  float _100;
  float _108;
  float _109;
  float _113;
  float _114;
  float _115;
  float _131;
  float _138;
  float _145;
  float _154;
  float _158;
  float _167;
  float _171;
  float _180;
  float _189;
  float _190;
  float _191;
  float _192;
  _14 = t0.SampleBias(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y), cb0_836x, int2(0, 0));
  if (!(Primitive_472 == 0)) {
    _23 = 1.0f - _14.w;
    if (_23 > 0.0f) {
      _30 = (_14.x / _23);
      _31 = (_14.y / _23);
      _32 = (_14.z / _23);
      _33 = _23;
    } else {
      _30 = _14.x;
      _31 = _14.y;
      _32 = _14.z;
      _33 = _23;
    }
  } else {
    _30 = _14.x;
    _31 = _14.y;
    _32 = _14.z;
    _33 = _14.w;
  }
  _61 = (exp2(log2(abs((_30 * TEXCOORD0_centroid.x) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _62 = (exp2(log2(abs((_31 * TEXCOORD0_centroid.y) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _63 = (exp2(log2(abs((_32 * TEXCOORD0_centroid.z) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_61, _62, _63, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _218 = color.r;
    _219 = color.g;
    _220 = color.b;
#else  // original code
    _97 = saturate(select((_61 <= 0.040449999272823334f), (_61 * 0.07739938050508499f), exp2(log2(abs((_61 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _98 = saturate(select((_62 <= 0.040449999272823334f), (_62 * 0.07739938050508499f), exp2(log2(abs((_62 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _99 = saturate(select((_63 <= 0.040449999272823334f), (_63 * 0.07739938050508499f), exp2(log2(abs((_63 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _100 = dot(float3(_97, _98, _99), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _108 = select((_100 > 0.5f), (((_100 * HDROutput_016.y) / (HDROutput_016.y - _100)) + HDROutput_016.x), (_100 / (1.000100016593933f - _100)));
    _109 = _100 + 9.999999747378752e-05f;
    _113 = _108 * (_97 / _109);
    _114 = (_98 / _109) * _108;
    _115 = (_99 / _109) * _108;
    _131 = saturate(max(max(_113, _114), _115) + -1.0f);
    _138 = HDROutput_064 * 9.999999747378752e-05f;
    _145 = exp2(log2(abs(_138 * (((1.0f - _131) * mad(0.04331360012292862f, _115, mad(0.3292819857597351f, _114, (_113 * 0.627403974533081f)))) + (_131 * mad(0.047561999410390854f, _115, mad(0.19859300553798676f, _114, (_113 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _154 = exp2(log2(abs(((_145 * 18.8515625f) + 0.8359375f) / ((_145 * 18.6875f) + 1.0f))) * 78.84375f);
    _158 = exp2(log2(abs(_138 * mad(0.012477199546992779f, _115, mad(0.9417769908905029f, _114, (_113 * 0.045745600014925f))))) * 0.1593017578125f);
    _167 = exp2(log2(abs(((_158 * 18.8515625f) + 0.8359375f) / ((_158 * 18.6875f) + 1.0f))) * 78.84375f);
    _171 = exp2(log2(abs(_138 * mad(0.9836069941520691f, _115, mad(0.017604099586606026f, _114, (_113 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _180 = exp2(log2(abs(((_171 * 18.8515625f) + 0.8359375f) / ((_171 * 18.6875f) + 1.0f))) * 78.84375f);
    _189 = saturate(_154 / HDROutput_084);
    _190 = saturate(_167 / HDROutput_084);
    _191 = saturate(_180 / HDROutput_084);
    _192 = HDROutput_084 - HDROutput_036;
    _218 = select((_154 > HDROutput_076), _154, select((_154 < HDROutput_084), max((((_189 * _189) * _192) + HDROutput_036), _154), _154));
    _219 = select((_167 > HDROutput_076), _167, select((_167 < HDROutput_084), max((((_190 * _190) * _192) + HDROutput_036), _167), _167));
    _220 = select((_180 > HDROutput_076), _180, select((_180 < HDROutput_084), max((((_191 * _191) * _192) + HDROutput_036), _180), _180));
#endif
  } else {
    _218 = _61;
    _219 = _62;
    _220 = _63;
  }
  SV_Target.x = _218;
  SV_Target.y = _219;
  SV_Target.z = _220;
  SV_Target.w = (_33 * TEXCOORD0_centroid.w);
  return SV_Target;
}