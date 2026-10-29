#include "UI.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

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

SamplerState s1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float3 TEXCOORD1_centroid : TEXCOORD1_centroid,
  linear float4 TEXCOORD2_centroid : TEXCOORD2_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _16;
  float _32;
  float _33;
  float _34;
  float _35;
  float _56;
  float _57;
  float _58;
  float _59;
  float _245;
  float _246;
  float _247;
  float _25;
  float _36;
  float _37;
  float _38;
  float _39;
  float4 _42;
  float _88;
  float _89;
  float _90;
  float _124;
  float _125;
  float _126;
  float _127;
  float _135;
  float _136;
  float _140;
  float _141;
  float _142;
  float _158;
  float _165;
  float _172;
  float _181;
  float _185;
  float _194;
  float _198;
  float _207;
  float _216;
  float _217;
  float _218;
  float _219;
  _16 = t0.Sample(s0, float2(TEXCOORD2_centroid.x, TEXCOORD2_centroid.y));
  if (!(Primitive_472 == 0)) {
    _25 = 1.0f - _16.w;
    if (_25 > 0.0f) {
      _32 = (_16.x / _25);
      _33 = (_16.y / _25);
      _34 = (_16.z / _25);
      _35 = _25;
    } else {
      _32 = _16.x;
      _33 = _16.y;
      _34 = _16.z;
      _35 = _25;
    }
  } else {
    _32 = _16.x;
    _33 = _16.y;
    _34 = _16.z;
    _35 = _16.w;
  }
  _36 = _32 * TEXCOORD0_centroid.x;
  _37 = _33 * TEXCOORD0_centroid.y;
  _38 = _34 * TEXCOORD0_centroid.z;
  _39 = _35 * TEXCOORD0_centroid.w;
  _42 = t1.Sample(s1, float2((TEXCOORD1_centroid.x / TEXCOORD1_centroid.z), (TEXCOORD1_centroid.y / TEXCOORD1_centroid.z)));
  if (!(Primitive_468 == 0)) {
    _56 = (_42.x * _36);
    _57 = (_42.y * _37);
    _58 = (_42.z * _38);
    _59 = _39;
  } else {
    _56 = _36;
    _57 = _37;
    _58 = _38;
    _59 = (_42.y * _39);
  }
  _88 = (exp2(log2(abs(Primitive_080.x * _56)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _89 = (exp2(log2(abs(Primitive_080.y * _57)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _90 = (exp2(log2(abs(Primitive_080.z * _58)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_88, _89, _90, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _245 = color.r;
    _246 = color.g;
    _247 = color.b;
#else  // original code
    _124 = saturate(select((_88 <= 0.040449999272823334f), (_88 * 0.07739938050508499f), exp2(log2(abs((_88 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _125 = saturate(select((_89 <= 0.040449999272823334f), (_89 * 0.07739938050508499f), exp2(log2(abs((_89 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _126 = saturate(select((_90 <= 0.040449999272823334f), (_90 * 0.07739938050508499f), exp2(log2(abs((_90 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _127 = dot(float3(_124, _125, _126), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _135 = select((_127 > 0.5f), (((_127 * HDROutput_016.y) / (HDROutput_016.y - _127)) + HDROutput_016.x), (_127 / (1.000100016593933f - _127)));
    _136 = _127 + 9.999999747378752e-05f;
    _140 = _135 * (_124 / _136);
    _141 = (_125 / _136) * _135;
    _142 = (_126 / _136) * _135;
    _158 = saturate(max(max(_140, _141), _142) + -1.0f);
    _165 = HDROutput_064 * 9.999999747378752e-05f;
    _172 = exp2(log2(abs(_165 * (((1.0f - _158) * mad(0.04331360012292862f, _142, mad(0.3292819857597351f, _141, (_140 * 0.627403974533081f)))) + (_158 * mad(0.047561999410390854f, _142, mad(0.19859300553798676f, _141, (_140 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _181 = exp2(log2(abs(((_172 * 18.8515625f) + 0.8359375f) / ((_172 * 18.6875f) + 1.0f))) * 78.84375f);
    _185 = exp2(log2(abs(_165 * mad(0.012477199546992779f, _142, mad(0.9417769908905029f, _141, (_140 * 0.045745600014925f))))) * 0.1593017578125f);
    _194 = exp2(log2(abs(((_185 * 18.8515625f) + 0.8359375f) / ((_185 * 18.6875f) + 1.0f))) * 78.84375f);
    _198 = exp2(log2(abs(_165 * mad(0.9836069941520691f, _142, mad(0.017604099586606026f, _141, (_140 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _207 = exp2(log2(abs(((_198 * 18.8515625f) + 0.8359375f) / ((_198 * 18.6875f) + 1.0f))) * 78.84375f);
    _216 = saturate(_181 / HDROutput_084);
    _217 = saturate(_194 / HDROutput_084);
    _218 = saturate(_207 / HDROutput_084);
    _219 = HDROutput_084 - HDROutput_036;
    _245 = select((_181 > HDROutput_076), _181, select((_181 < HDROutput_084), max((((_216 * _216) * _219) + HDROutput_036), _181), _181));
    _246 = select((_194 > HDROutput_076), _194, select((_194 < HDROutput_084), max((((_217 * _217) * _219) + HDROutput_036), _194), _194));
    _247 = select((_207 > HDROutput_076), _207, select((_207 < HDROutput_084), max((((_218 * _218) * _219) + HDROutput_036), _207), _207));
#endif
  } else {
    _245 = _88;
    _246 = _89;
    _247 = _90;
  }
  SV_Target.x = _245;
  SV_Target.y = _246;
  SV_Target.z = _247;
  SV_Target.w = (Primitive_080.w * _59);
  return SV_Target;
}