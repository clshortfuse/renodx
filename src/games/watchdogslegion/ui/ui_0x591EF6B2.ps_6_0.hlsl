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
  float4 _11;
  float _27;
  float _28;
  float _29;
  float _30;
  float _220;
  float _221;
  float _222;
  float _20;
  float _63;
  float _64;
  float _65;
  float _99;
  float _100;
  float _101;
  float _102;
  float _110;
  float _111;
  float _115;
  float _116;
  float _117;
  float _133;
  float _140;
  float _147;
  float _156;
  float _160;
  float _169;
  float _173;
  float _182;
  float _191;
  float _192;
  float _193;
  float _194;
  _11 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  if (!(Primitive_472 == 0)) {
    _20 = 1.0f - _11.w;
    if (_20 > 0.0f) {
      _27 = (_11.x / _20);
      _28 = (_11.y / _20);
      _29 = (_11.z / _20);
      _30 = _20;
    } else {
      _27 = _11.x;
      _28 = _11.y;
      _29 = _11.z;
      _30 = _20;
    }
  } else {
    _27 = _11.x;
    _28 = _11.y;
    _29 = _11.z;
    _30 = _11.w;
  }
  _63 = (exp2(log2(abs((_27 * TEXCOORD0_centroid.x) * Primitive_080.x)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _64 = (exp2(log2(abs((_28 * TEXCOORD0_centroid.y) * Primitive_080.y)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _65 = (exp2(log2(abs((_29 * TEXCOORD0_centroid.z) * Primitive_080.z)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_63, _64, _65, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _220 = color.r;
    _221 = color.g;
    _222 = color.b;
#else  // original code
    _99 = saturate(select((_63 <= 0.040449999272823334f), (_63 * 0.07739938050508499f), exp2(log2(abs((_63 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _100 = saturate(select((_64 <= 0.040449999272823334f), (_64 * 0.07739938050508499f), exp2(log2(abs((_64 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _101 = saturate(select((_65 <= 0.040449999272823334f), (_65 * 0.07739938050508499f), exp2(log2(abs((_65 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _102 = dot(float3(_99, _100, _101), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _110 = select((_102 > 0.5f), (((_102 * HDROutput_016.y) / (HDROutput_016.y - _102)) + HDROutput_016.x), (_102 / (1.000100016593933f - _102)));
    _111 = _102 + 9.999999747378752e-05f;
    _115 = _110 * (_99 / _111);
    _116 = (_100 / _111) * _110;
    _117 = (_101 / _111) * _110;
    _133 = saturate(max(max(_115, _116), _117) + -1.0f);
    _140 = HDROutput_064 * 9.999999747378752e-05f;
    _147 = exp2(log2(abs(_140 * (((1.0f - _133) * mad(0.04331360012292862f, _117, mad(0.3292819857597351f, _116, (_115 * 0.627403974533081f)))) + (_133 * mad(0.047561999410390854f, _117, mad(0.19859300553798676f, _116, (_115 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _156 = exp2(log2(abs(((_147 * 18.8515625f) + 0.8359375f) / ((_147 * 18.6875f) + 1.0f))) * 78.84375f);
    _160 = exp2(log2(abs(_140 * mad(0.012477199546992779f, _117, mad(0.9417769908905029f, _116, (_115 * 0.045745600014925f))))) * 0.1593017578125f);
    _169 = exp2(log2(abs(((_160 * 18.8515625f) + 0.8359375f) / ((_160 * 18.6875f) + 1.0f))) * 78.84375f);
    _173 = exp2(log2(abs(_140 * mad(0.9836069941520691f, _117, mad(0.017604099586606026f, _116, (_115 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _182 = exp2(log2(abs(((_173 * 18.8515625f) + 0.8359375f) / ((_173 * 18.6875f) + 1.0f))) * 78.84375f);
    _191 = saturate(_156 / HDROutput_084);
    _192 = saturate(_169 / HDROutput_084);
    _193 = saturate(_182 / HDROutput_084);
    _194 = HDROutput_084 - HDROutput_036;
    _220 = select((_156 > HDROutput_076), _156, select((_156 < HDROutput_084), max((((_191 * _191) * _194) + HDROutput_036), _156), _156));
    _221 = select((_169 > HDROutput_076), _169, select((_169 < HDROutput_084), max((((_192 * _192) * _194) + HDROutput_036), _169), _169));
    _222 = select((_182 > HDROutput_076), _182, select((_182 < HDROutput_084), max((((_193 * _193) * _194) + HDROutput_036), _182), _182));
#endif
  } else {
    _220 = _63;
    _221 = _64;
    _222 = _65;
  }
  SV_Target.x = _220;
  SV_Target.y = _221;
  SV_Target.z = _222;
  SV_Target.w = ((_30 * TEXCOORD0_centroid.w) * Primitive_080.w);
  return SV_Target;
}