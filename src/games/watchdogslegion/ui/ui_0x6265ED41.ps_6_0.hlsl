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
  float cb0_836w : packoffset(c836.w);
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
  float4 FireUiPrimitive_000 : packoffset(c000.x);
  float4 FireUiPrimitive_016 : packoffset(c001.x);
  float4 FireUiPrimitive_032 : packoffset(c002.x);
  float4 FireUiPrimitive_048[4] : packoffset(c003.x);
  float4 FireUiPrimitive_112 : packoffset(c007.x);
  float4 FireUiPrimitive_128[4] : packoffset(c008.x);
  float4 FireUiPrimitive_192[8] : packoffset(c012.x);
  float3 FireUiPrimitive_320 : packoffset(c020.x);
  float FireUiPrimitive_332 : packoffset(c020.w);
  float2 FireUiPrimitive_336 : packoffset(c021.x);
  float FireUiPrimitive_344 : packoffset(c021.z);
  float FireUiPrimitive_348 : packoffset(c021.w);
  float2 FireUiPrimitive_352 : packoffset(c022.x);
  float FireUiPrimitive_360 : packoffset(c022.z);
  float FireUiPrimitive_364 : packoffset(c022.w);
  float FireUiPrimitive_368 : packoffset(c023.x);
  float FireUiPrimitive_372 : packoffset(c023.y);
  float FireUiPrimitive_376 : packoffset(c023.z);
  float FireUiPrimitive_380 : packoffset(c023.w);
  float FireUiPrimitive_384 : packoffset(c024.x);
  int FireUiPrimitive_388 : packoffset(c024.y);
  int FireUiPrimitive_392 : packoffset(c024.z);
  int FireUiPrimitive_396 : packoffset(c024.w);
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
  float _43;
  float _44;
  float4 _69;
  float4 _71;
  float4 _73;
  float _86;
  float _87;
  float _88;
  float _89;
  float _140;
  float _141;
  float _142;
  float _298;
  float _299;
  float _300;
  float _177;
  float _178;
  float _179;
  float _180;
  float _188;
  float _189;
  float _193;
  float _194;
  float _195;
  float _211;
  float _218;
  float _225;
  float _234;
  float _238;
  float _247;
  float _251;
  float _260;
  float _269;
  float _270;
  float _271;
  float _272;
  _43 = frac(TEXCOORD1_centroid.x);
  _44 = frac(TEXCOORD1_centroid.y);
  _69 = t0.Sample(s0, float2(min(max(((_43 * (FireUiPrimitive_192[0].x)) + (FireUiPrimitive_192[0].z)), (FireUiPrimitive_192[4].x)), (FireUiPrimitive_192[5].x)), min(max(((_44 * (FireUiPrimitive_192[0].y)) + (FireUiPrimitive_192[0].w)), (FireUiPrimitive_192[4].y)), (FireUiPrimitive_192[5].y))));
  _71 = t0.Sample(s0, float2(min(max(((_43 * (FireUiPrimitive_192[2].x)) + (FireUiPrimitive_192[2].z)), (FireUiPrimitive_192[6].x)), (FireUiPrimitive_192[7].x)), min(max(((_44 * (FireUiPrimitive_192[2].y)) + (FireUiPrimitive_192[2].w)), (FireUiPrimitive_192[6].y)), (FireUiPrimitive_192[7].y))));
  _73 = t0.Sample(s0, float2(min(max(((_43 * (FireUiPrimitive_192[3].x)) + (FireUiPrimitive_192[3].z)), (FireUiPrimitive_192[6].z)), (FireUiPrimitive_192[7].z)), min(max(((_44 * (FireUiPrimitive_192[3].y)) + (FireUiPrimitive_192[3].w)), (FireUiPrimitive_192[6].w)), (FireUiPrimitive_192[7].w))));
  _86 = ((_69.x + -0.7037500143051147f) + (_71.x * 1.4019999504089355f)) * TEXCOORD0_centroid.x;
  _87 = (((_69.x + 0.531220018863678f) - (_71.x * 0.714139997959137f)) - (_73.x * 0.3441399931907654f)) * TEXCOORD0_centroid.y;
  _88 = ((_69.x + -0.8894699811935425f) + (_73.x * 1.7719999551773071f)) * TEXCOORD0_centroid.z;
  _89 = dot(float3(_86, _87, _88), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _140 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (_86 - _89)) + _89) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _141 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max(((lerp(_89, _87, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _142 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max(((lerp(_89, _88, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_140, _141, _142, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _298 = color.r;
    _299 = color.g;
    _300 = color.b;
#else  // original code
    _177 = saturate(select((_140 <= 0.040449999272823334f), (_140 * 0.07739938050508499f), exp2(log2(abs((_140 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _178 = saturate(select((_141 <= 0.040449999272823334f), (_141 * 0.07739938050508499f), exp2(log2(abs((_141 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _179 = saturate(select((_142 <= 0.040449999272823334f), (_142 * 0.07739938050508499f), exp2(log2(abs((_142 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _180 = dot(float3(_177, _178, _179), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _188 = select((_180 > 0.5f), (((_180 * HDROutput_016.y) / (HDROutput_016.y - _180)) + HDROutput_016.x), (_180 / (1.000100016593933f - _180)));
    _189 = _180 + 9.999999747378752e-05f;
    _193 = _188 * (_177 / _189);
    _194 = (_178 / _189) * _188;
    _195 = (_179 / _189) * _188;
    _211 = saturate(max(max(_193, _194), _195) + -1.0f);
    _218 = HDROutput_064 * 9.999999747378752e-05f;
    _225 = exp2(log2(abs(_218 * (((1.0f - _211) * mad(0.04331360012292862f, _195, mad(0.3292819857597351f, _194, (_193 * 0.627403974533081f)))) + (_211 * mad(0.047561999410390854f, _195, mad(0.19859300553798676f, _194, (_193 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _234 = exp2(log2(abs(((_225 * 18.8515625f) + 0.8359375f) / ((_225 * 18.6875f) + 1.0f))) * 78.84375f);
    _238 = exp2(log2(abs(_218 * mad(0.012477199546992779f, _195, mad(0.9417769908905029f, _194, (_193 * 0.045745600014925f))))) * 0.1593017578125f);
    _247 = exp2(log2(abs(((_238 * 18.8515625f) + 0.8359375f) / ((_238 * 18.6875f) + 1.0f))) * 78.84375f);
    _251 = exp2(log2(abs(_218 * mad(0.9836069941520691f, _195, mad(0.017604099586606026f, _194, (_193 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _260 = exp2(log2(abs(((_251 * 18.8515625f) + 0.8359375f) / ((_251 * 18.6875f) + 1.0f))) * 78.84375f);
    _269 = saturate(_234 / HDROutput_084);
    _270 = saturate(_247 / HDROutput_084);
    _271 = saturate(_260 / HDROutput_084);
    _272 = HDROutput_084 - HDROutput_036;
    _298 = select((_234 > HDROutput_076), _234, select((_234 < HDROutput_084), max((((_269 * _269) * _272) + HDROutput_036), _234), _234));
    _299 = select((_247 > HDROutput_076), _247, select((_247 < HDROutput_084), max((((_270 * _270) * _272) + HDROutput_036), _247), _247));
    _300 = select((_260 > HDROutput_076), _260, select((_260 < HDROutput_084), max((((_271 * _271) * _272) + HDROutput_036), _260), _260));
#endif
  } else {
    _298 = _140;
    _299 = _141;
    _300 = _142;
  }
  SV_Target.x = _298;
  SV_Target.y = _299;
  SV_Target.z = _300;
  SV_Target.w = (FireUiPrimitive_016.w * TEXCOORD0_centroid.w);
  return SV_Target;
}