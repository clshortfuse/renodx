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
  float _222;
  float _223;
  float _224;
  float _23;
  float _65;
  float _66;
  float _67;
  float _101;
  float _102;
  float _103;
  float _104;
  float _112;
  float _113;
  float _117;
  float _118;
  float _119;
  float _135;
  float _142;
  float _149;
  float _158;
  float _162;
  float _171;
  float _175;
  float _184;
  float _193;
  float _194;
  float _195;
  float _196;
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
  _65 = (exp2(log2(abs(((_30 * TEXCOORD0_centroid.x) * _33) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _66 = (exp2(log2(abs(((_31 * TEXCOORD0_centroid.y) * _33) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _67 = (exp2(log2(abs(((_32 * TEXCOORD0_centroid.z) * _33) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_65, _66, _67, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _222 = color.r;
    _223 = color.g;
    _224 = color.b;
#else  // original code
    _101 = saturate(select((_65 <= 0.040449999272823334f), (_65 * 0.07739938050508499f), exp2(log2(abs((_65 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _102 = saturate(select((_66 <= 0.040449999272823334f), (_66 * 0.07739938050508499f), exp2(log2(abs((_66 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _103 = saturate(select((_67 <= 0.040449999272823334f), (_67 * 0.07739938050508499f), exp2(log2(abs((_67 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _104 = dot(float3(_101, _102, _103), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _112 = select((_104 > 0.5f), (((_104 * HDROutput_016.y) / (HDROutput_016.y - _104)) + HDROutput_016.x), (_104 / (1.000100016593933f - _104)));
    _113 = _104 + 9.999999747378752e-05f;
    _117 = _112 * (_101 / _113);
    _118 = (_102 / _113) * _112;
    _119 = (_103 / _113) * _112;
    _135 = saturate(max(max(_117, _118), _119) + -1.0f);
    _142 = HDROutput_064 * 9.999999747378752e-05f;
    _149 = exp2(log2(abs(_142 * (((1.0f - _135) * mad(0.04331360012292862f, _119, mad(0.3292819857597351f, _118, (_117 * 0.627403974533081f)))) + (_135 * mad(0.047561999410390854f, _119, mad(0.19859300553798676f, _118, (_117 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _158 = exp2(log2(abs(((_149 * 18.8515625f) + 0.8359375f) / ((_149 * 18.6875f) + 1.0f))) * 78.84375f);
    _162 = exp2(log2(abs(_142 * mad(0.012477199546992779f, _119, mad(0.9417769908905029f, _118, (_117 * 0.045745600014925f))))) * 0.1593017578125f);
    _171 = exp2(log2(abs(((_162 * 18.8515625f) + 0.8359375f) / ((_162 * 18.6875f) + 1.0f))) * 78.84375f);
    _175 = exp2(log2(abs(_142 * mad(0.9836069941520691f, _119, mad(0.017604099586606026f, _118, (_117 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _184 = exp2(log2(abs(((_175 * 18.8515625f) + 0.8359375f) / ((_175 * 18.6875f) + 1.0f))) * 78.84375f);
    _193 = saturate(_158 / HDROutput_084);
    _194 = saturate(_171 / HDROutput_084);
    _195 = saturate(_184 / HDROutput_084);
    _196 = HDROutput_084 - HDROutput_036;
    _222 = select((_158 > HDROutput_076), _158, select((_158 < HDROutput_084), max((((_193 * _193) * _196) + HDROutput_036), _158), _158));
    _223 = select((_171 > HDROutput_076), _171, select((_171 < HDROutput_084), max((((_194 * _194) * _196) + HDROutput_036), _171), _171));
    _224 = select((_184 > HDROutput_076), _184, select((_184 < HDROutput_084), max((((_195 * _195) * _196) + HDROutput_036), _184), _184));
#endif
  } else {
    _222 = _65;
    _223 = _66;
    _224 = _67;
  }
  SV_Target.x = _222;
  SV_Target.y = _223;
  SV_Target.z = _224;
  SV_Target.w = ((_33 * _33) * TEXCOORD0_centroid.w);
  return SV_Target;
}