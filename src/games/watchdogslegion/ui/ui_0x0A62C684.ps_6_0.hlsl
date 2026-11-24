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

SamplerState s1 : register(s1);

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
  float4 _29;
  float _45;
  float _46;
  float _47;
  float _48;
  float _233;
  float _234;
  float _235;
  float _38;
  float _76;
  float _77;
  float _78;
  float _112;
  float _113;
  float _114;
  float _115;
  float _123;
  float _124;
  float _128;
  float _129;
  float _130;
  float _146;
  float _153;
  float _160;
  float _169;
  float _173;
  float _182;
  float _186;
  float _195;
  float _204;
  float _205;
  float _206;
  float _207;
  _29 = t0.SampleBias(s1, float2(TEXCOORD3_centroid.x, TEXCOORD3_centroid.y), cb0_836x, int2(0, 0));
  if (!(Primitive_472 == 0)) {
    _38 = 1.0f - _29.w;
    if (_38 > 0.0f) {
      _45 = (_29.x / _38);
      _46 = (_29.y / _38);
      _47 = (_29.z / _38);
      _48 = _38;
    } else {
      _45 = _29.x;
      _46 = _29.y;
      _47 = _29.z;
      _48 = _38;
    }
  } else {
    _45 = _29.x;
    _46 = _29.y;
    _47 = _29.z;
    _48 = _29.w;
  }
  _76 = (exp2(log2(abs((_45 * TEXCOORD0_centroid.x) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _77 = (exp2(log2(abs((_46 * TEXCOORD0_centroid.y) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _78 = (exp2(log2(abs((_47 * TEXCOORD0_centroid.z) * Primitive_428)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_76, _77, _78, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _233 = color.r;
    _234 = color.g;
    _235 = color.b;
#else  // original code
    _112 = saturate(select((_76 <= 0.040449999272823334f), (_76 * 0.07739938050508499f), exp2(log2(abs((_76 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _113 = saturate(select((_77 <= 0.040449999272823334f), (_77 * 0.07739938050508499f), exp2(log2(abs((_77 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _114 = saturate(select((_78 <= 0.040449999272823334f), (_78 * 0.07739938050508499f), exp2(log2(abs((_78 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _115 = dot(float3(_112, _113, _114), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _123 = select((_115 > 0.5f), (((_115 * HDROutput_016.y) / (HDROutput_016.y - _115)) + HDROutput_016.x), (_115 / (1.000100016593933f - _115)));
    _124 = _115 + 9.999999747378752e-05f;
    _128 = _123 * (_112 / _124);
    _129 = (_113 / _124) * _123;
    _130 = (_114 / _124) * _123;
    _146 = saturate(max(max(_128, _129), _130) + -1.0f);
    _153 = HDROutput_064 * 9.999999747378752e-05f;
    _160 = exp2(log2(abs(_153 * (((1.0f - _146) * mad(0.04331360012292862f, _130, mad(0.3292819857597351f, _129, (_128 * 0.627403974533081f)))) + (_146 * mad(0.047561999410390854f, _130, mad(0.19859300553798676f, _129, (_128 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _169 = exp2(log2(abs(((_160 * 18.8515625f) + 0.8359375f) / ((_160 * 18.6875f) + 1.0f))) * 78.84375f);
    _173 = exp2(log2(abs(_153 * mad(0.012477199546992779f, _130, mad(0.9417769908905029f, _129, (_128 * 0.045745600014925f))))) * 0.1593017578125f);
    _182 = exp2(log2(abs(((_173 * 18.8515625f) + 0.8359375f) / ((_173 * 18.6875f) + 1.0f))) * 78.84375f);
    _186 = exp2(log2(abs(_153 * mad(0.9836069941520691f, _130, mad(0.017604099586606026f, _129, (_128 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _195 = exp2(log2(abs(((_186 * 18.8515625f) + 0.8359375f) / ((_186 * 18.6875f) + 1.0f))) * 78.84375f);
    _204 = saturate(_169 / HDROutput_084);
    _205 = saturate(_182 / HDROutput_084);
    _206 = saturate(_195 / HDROutput_084);
    _207 = HDROutput_084 - HDROutput_036;
    _233 = select((_169 > HDROutput_076), _169, select((_169 < HDROutput_084), max((((_204 * _204) * _207) + HDROutput_036), _169), _169));
    _234 = select((_182 > HDROutput_076), _182, select((_182 < HDROutput_084), max((((_205 * _205) * _207) + HDROutput_036), _182), _182));
    _235 = select((_195 > HDROutput_076), _195, select((_195 < HDROutput_084), max((((_206 * _206) * _207) + HDROutput_036), _195), _195));
#endif
  } else {
    _233 = _76;
    _234 = _77;
    _235 = _78;
  }
  SV_Target.x = _233;
  SV_Target.y = _234;
  SV_Target.z = _235;
  SV_Target.w = (((((float4)(t1.Sample(s0, float2((abs(dot(float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y), float2(TEXCOORD3_centroid.z, TEXCOORD3_centroid.w)) + TEXCOORD1_centroid.z) + 0.015625f), TEXCOORD1_centroid.w)))).w) * TEXCOORD0_centroid.w) * _48);
  return SV_Target;
}