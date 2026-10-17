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
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    linear float4 TEXCOORD0_centroid: TEXCOORD0_centroid,
    linear float4 TEXCOORD1_centroid: TEXCOORD1_centroid,
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float _42;
  float _43;
  float4 _68;
  float4 _70;
  float4 _72;
  float _116;
  float _117;
  float _118;
  float _274;
  float _275;
  float _276;
  float _153;
  float _154;
  float _155;
  float _156;
  float _164;
  float _165;
  float _169;
  float _170;
  float _171;
  float _187;
  float _194;
  float _201;
  float _210;
  float _214;
  float _223;
  float _227;
  float _236;
  float _245;
  float _246;
  float _247;
  float _248;
  _42 = frac(TEXCOORD1_centroid.x);
  _43 = frac(TEXCOORD1_centroid.y);
  _68 = t0.Sample(s0, float2(min(max(((_42 * (Primitive_288[0].x)) + (Primitive_288[0].z)), (Primitive_288[4].x)), (Primitive_288[5].x)), min(max(((_43 * (Primitive_288[0].y)) + (Primitive_288[0].w)), (Primitive_288[4].y)), (Primitive_288[5].y))));
  _70 = t0.Sample(s0, float2(min(max(((_42 * (Primitive_288[2].x)) + (Primitive_288[2].z)), (Primitive_288[6].x)), (Primitive_288[7].x)), min(max(((_43 * (Primitive_288[2].y)) + (Primitive_288[2].w)), (Primitive_288[6].y)), (Primitive_288[7].y))));
  _72 = t0.Sample(s0, float2(min(max(((_42 * (Primitive_288[3].x)) + (Primitive_288[3].z)), (Primitive_288[6].z)), (Primitive_288[7].z)), min(max(((_43 * (Primitive_288[3].y)) + (Primitive_288[3].w)), (Primitive_288[6].w)), (Primitive_288[7].w))));
  _116 = (exp2(log2(abs((((_68.x + -0.7037500143051147f) + (_70.x * 1.4019999504089355f)) * TEXCOORD0_centroid.x) * Primitive_080.x)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _117 = (exp2(log2(abs((Primitive_080.y * TEXCOORD0_centroid.y) * (((_68.x + 0.531220018863678f) - (_70.x * 0.714139997959137f)) - (_72.x * 0.3441399931907654f)))) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _118 = (exp2(log2(abs((Primitive_080.z * TEXCOORD0_centroid.z) * ((_68.x + -0.8894699811935425f) + (_72.x * 1.7719999551773071f)))) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_116, _117, _118, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _274 = color.r;
    _275 = color.g;
    _276 = color.b;
#else  // original code
    _153 = saturate(select((_116 <= 0.040449999272823334f), (_116 * 0.07739938050508499f), exp2(log2(abs((_116 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _154 = saturate(select((_117 <= 0.040449999272823334f), (_117 * 0.07739938050508499f), exp2(log2(abs((_117 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _155 = saturate(select((_118 <= 0.040449999272823334f), (_118 * 0.07739938050508499f), exp2(log2(abs((_118 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _156 = dot(float3(_153, _154, _155), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _164 = select((_156 > 0.5f), (((_156 * HDROutput_016.y) / (HDROutput_016.y - _156)) + HDROutput_016.x), (_156 / (1.000100016593933f - _156)));
    _165 = _156 + 9.999999747378752e-05f;
    _169 = _164 * (_153 / _165);
    _170 = (_154 / _165) * _164;
    _171 = (_155 / _165) * _164;
    _187 = saturate(max(max(_169, _170), _171) + -1.0f);

    _194 = HDROutput_064 * 9.999999747378752e-05f;
    _201 = exp2(log2(abs(_194 * (((1.0f - _187) * mad(0.04331360012292862f, _171, mad(0.3292819857597351f, _170, (_169 * 0.627403974533081f)))) + (_187 * mad(0.047561999410390854f, _171, mad(0.19859300553798676f, _170, (_169 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _210 = exp2(log2(abs(((_201 * 18.8515625f) + 0.8359375f) / ((_201 * 18.6875f) + 1.0f))) * 78.84375f);
    _214 = exp2(log2(abs(_194 * mad(0.012477199546992779f, _171, mad(0.9417769908905029f, _170, (_169 * 0.045745600014925f))))) * 0.1593017578125f);
    _223 = exp2(log2(abs(((_214 * 18.8515625f) + 0.8359375f) / ((_214 * 18.6875f) + 1.0f))) * 78.84375f);
    _227 = exp2(log2(abs(_194 * mad(0.9836069941520691f, _171, mad(0.017604099586606026f, _170, (_169 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _236 = exp2(log2(abs(((_227 * 18.8515625f) + 0.8359375f) / ((_227 * 18.6875f) + 1.0f))) * 78.84375f);
    _245 = saturate(_210 / HDROutput_084);
    _246 = saturate(_223 / HDROutput_084);
    _247 = saturate(_236 / HDROutput_084);
    _248 = HDROutput_084 - HDROutput_036;
    _274 = select((_210 > HDROutput_076), _210, select((_210 < HDROutput_084), max((((_245 * _245) * _248) + HDROutput_036), _210), _210));
    _275 = select((_223 > HDROutput_076), _223, select((_223 < HDROutput_084), max((((_246 * _246) * _248) + HDROutput_036), _223), _223));
    _276 = select((_236 > HDROutput_076), _236, select((_236 < HDROutput_084), max((((_247 * _247) * _248) + HDROutput_036), _236), _236));
#endif
  } else {
    _274 = _116;
    _275 = _117;
    _276 = _118;
  }
  SV_Target.x = _274;
  SV_Target.y = _275;
  SV_Target.z = _276;
  SV_Target.w = (Primitive_080.w * TEXCOORD0_centroid.w);
  return SV_Target;
}
