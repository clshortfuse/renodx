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
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_032x : packoffset(c032.x);
  float cb0_032y : packoffset(c032.y);
  float cb0_032z : packoffset(c032.z);
  float cb0_032w : packoffset(c032.w);
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_034z : packoffset(c034.z);
  float cb0_034w : packoffset(c034.w);
  float cb0_071z : packoffset(c071.z);
  float cb0_071w : packoffset(c071.w);
  float cb0_072z : packoffset(c072.z);
  float cb0_072w : packoffset(c072.w);
  float cb0_094y : packoffset(c094.y);
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
  linear float2 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _36;
  float _37;
  float _38;
  float _194;
  float _195;
  float _196;
  float _73;
  float _74;
  float _75;
  float _76;
  float _84;
  float _85;
  float _89;
  float _90;
  float _91;
  float _107;
  float _114;
  float _121;
  float _130;
  float _134;
  float _143;
  float _147;
  float _156;
  float _165;
  float _166;
  float _167;
  float _168;
  float _220;
  float _221;
  float _222;
  float _262;
  float _263;
  float _266;
  float _267;
  float _268;
  float _269;
  float _270;
  float _271;
  float _272;
  float _273;
  float _274;
  float _278;
  float _279;
  float _282;
  float _286;
  float _290;
  float _291;
  float _292;
  float _296;
  float _297;
  float _300;
  float _304;
  float _312;
  float _313;
  float _322;
  float _323;
  float _324;
  float _325;
  float4 _328;
  float4 _332;
  float _334;
  float _341;
  float _344;
  float _358;
  _36 = (exp2(log2(abs(Primitive_428 * TEXCOORD0_centroid.x)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _37 = (exp2(log2(abs(Primitive_428 * TEXCOORD0_centroid.y)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  _38 = (exp2(log2(abs(Primitive_428 * TEXCOORD0_centroid.z)) * Primitive_416.x) * Primitive_416.y) + Primitive_416.z;
  if (!(Primitive_464 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_36, _37, _38, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _194 = color.r;
    _195 = color.g;
    _196 = color.b;
#else  // original code
    _73 = saturate(select((_36 <= 0.040449999272823334f), (_36 * 0.07739938050508499f), exp2(log2(abs((_36 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _74 = saturate(select((_37 <= 0.040449999272823334f), (_37 * 0.07739938050508499f), exp2(log2(abs((_37 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _75 = saturate(select((_38 <= 0.040449999272823334f), (_38 * 0.07739938050508499f), exp2(log2(abs((_38 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _76 = dot(float3(_73, _74, _75), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _84 = select((_76 > 0.5f), (((_76 * HDROutput_016.y) / (HDROutput_016.y - _76)) + HDROutput_016.x), (_76 / (1.000100016593933f - _76)));
    _85 = _76 + 9.999999747378752e-05f;
    _89 = _84 * (_73 / _85);
    _90 = (_74 / _85) * _84;
    _91 = (_75 / _85) * _84;
    _107 = saturate(max(max(_89, _90), _91) + -1.0f);
    _114 = HDROutput_064 * 9.999999747378752e-05f;
    _121 = exp2(log2(abs(_114 * (((1.0f - _107) * mad(0.04331360012292862f, _91, mad(0.3292819857597351f, _90, (_89 * 0.627403974533081f)))) + (_107 * mad(0.047561999410390854f, _91, mad(0.19859300553798676f, _90, (_89 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _130 = exp2(log2(abs(((_121 * 18.8515625f) + 0.8359375f) / ((_121 * 18.6875f) + 1.0f))) * 78.84375f);
    _134 = exp2(log2(abs(_114 * mad(0.012477199546992779f, _91, mad(0.9417769908905029f, _90, (_89 * 0.045745600014925f))))) * 0.1593017578125f);
    _143 = exp2(log2(abs(((_134 * 18.8515625f) + 0.8359375f) / ((_134 * 18.6875f) + 1.0f))) * 78.84375f);
    _147 = exp2(log2(abs(_114 * mad(0.9836069941520691f, _91, mad(0.017604099586606026f, _90, (_89 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _156 = exp2(log2(abs(((_147 * 18.8515625f) + 0.8359375f) / ((_147 * 18.6875f) + 1.0f))) * 78.84375f);
    _165 = saturate(_130 / HDROutput_084);
    _166 = saturate(_143 / HDROutput_084);
    _167 = saturate(_156 / HDROutput_084);
    _168 = HDROutput_084 - HDROutput_036;
    _194 = select((_130 > HDROutput_076), _130, select((_130 < HDROutput_084), max((((_165 * _165) * _168) + HDROutput_036), _130), _130));
    _195 = select((_143 > HDROutput_076), _143, select((_143 < HDROutput_084), max((((_166 * _166) * _168) + HDROutput_036), _143), _143));
    _196 = select((_156 > HDROutput_076), _156, select((_156 < HDROutput_084), max((((_167 * _167) * _168) + HDROutput_036), _156), _156));
#endif
  } else {
    _194 = _36;
    _195 = _37;
    _196 = _38;
  }
  _220 = -0.0f - ((1.0f / ((cb0_005y * (((float4)(t0.Load(int3(int(SV_Position.x), int(SV_Position.y), 0)))).x)) + cb0_005x)) * cb0_094y);
  _221 = ((cb0_072z * SV_Position.x) + cb0_071z) * _220;
  _222 = ((cb0_072w * SV_Position.y) + cb0_071w) * _220;
  _262 = 1.0f / Primitive_432.x;
  _263 = 1.0f / Primitive_432.y;
  _266 = (Primitive_432.x * abs((Primitive_448.x * (mad(_220, cb0_032z, mad(_222, cb0_032y, (_221 * cb0_032x))) + cb0_032w)) - Primitive_448.y)) + -0.5f;
  _267 = (Primitive_432.y * abs((Primitive_448.x * (mad(_220, cb0_033z, mad(_222, cb0_033y, (_221 * cb0_033x))) + cb0_033w)) - Primitive_448.y)) + -0.5f;
  _268 = frac(_266);
  _269 = frac(_267);
  _270 = _266 - _268;
  _271 = _267 - _269;
  _272 = 1.0f - _268;
  _273 = 2.0f - _268;
  _274 = 3.0f - _268;
  _278 = (_272 * _272) * _272;
  _279 = (_273 * _273) * _273;
  _282 = _279 - (_278 * 4.0f);
  _286 = (6.0f - _278) - _282;
  _290 = 1.0f - _269;
  _291 = 2.0f - _269;
  _292 = 3.0f - _269;
  _296 = (_290 * _290) * _290;
  _297 = (_291 * _291) * _291;
  _300 = _297 - (_296 * 4.0f);
  _304 = (6.0f - _296) - _300;
  _312 = _282 + _278;
  _313 = _300 + _296;
  _322 = ((_270 + -0.5f) + (_282 / _312)) * _262;
  _323 = ((_270 + 1.5f) + (((((_279 * 4.0f) - ((_274 * _274) * _274)) - (_278 * 6.0f)) + _286) / _286)) * _262;
  _324 = ((_271 + -0.5f) + (_300 / _313)) * _263;
  _325 = ((_271 + 1.5f) + (((((_297 * 4.0f) - ((_292 * _292) * _292)) - (_296 * 6.0f)) + _304) / _304)) * _263;
  _328 = t1.SampleLevel(s0, float2(_323, _324), 0.0f);
  _332 = t1.SampleLevel(s0, float2(_323, _325), 0.0f);
  _334 = _312 * 0.1666666716337204f;
  _341 = (((((float4)(t1.SampleLevel(s0, float2(_322, _325), 0.0f))).x) - _332.x) * _334) + _332.x;
  _344 = ((_313 * 0.1666666716337204f) * (((((((float4)(t1.SampleLevel(s0, float2(_322, _324), 0.0f))).x) - _328.x) * _334) + _328.x) - _341)) + _341;
  _358 = saturate((mad(_220, cb0_034z, mad(_222, cb0_034y, (cb0_034x * _221))) + cb0_034w) * 0.03333333507180214f);
  SV_Target.x = ((_344 * (0.10000000149011612f - _194)) + _194);
  SV_Target.y = ((_344 * (0.10000000149011612f - _195)) + _195);
  SV_Target.z = ((_344 * (0.10000000149011612f - _196)) + _196);
  SV_Target.w = ((((TEXCOORD0_centroid.w * -0.6499999761581421f) * _344) + TEXCOORD0_centroid.w) * ((_344 * (((_358 * _358) * (3.0f - (_358 * 2.0f))) + -1.0f)) + 1.0f));
  return SV_Target;
}