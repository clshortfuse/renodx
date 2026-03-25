#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture3D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

cbuffer cb0 : register(b0) {
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  float cb0_038z : packoffset(c038.z);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_049x : packoffset(c049.x);
  float cb0_049y : packoffset(c049.y);
  float cb0_053z : packoffset(c053.z);
  float cb0_053w : packoffset(c053.w);
  float cb0_054x : packoffset(c054.x);
  float cb0_054y : packoffset(c054.y);
  float cb0_060z : packoffset(c060.z);
  float cb0_060w : packoffset(c060.w);
  float cb0_061x : packoffset(c061.x);
  float cb0_061y : packoffset(c061.y);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_069x : packoffset(c069.x);
  float cb0_069y : packoffset(c069.y);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_076z : packoffset(c076.z);
  float cb0_076w : packoffset(c076.w);
  float cb0_077x : packoffset(c077.x);
  float cb0_077y : packoffset(c077.y);
  float cb0_083z : packoffset(c083.z);
  float cb0_083w : packoffset(c083.w);
  float cb0_084x : packoffset(c084.x);
  float cb0_084y : packoffset(c084.y);
  float cb0_084z : packoffset(c084.z);
  float cb0_084w : packoffset(c084.w);
  float cb0_085x : packoffset(c085.x);
  float cb0_085y : packoffset(c085.y);
  int cb0_085z : packoffset(c085.z);
  int cb0_085w : packoffset(c085.w);
  int cb0_086x : packoffset(c086.x);
  float cb0_087x : packoffset(c087.x);
  float cb0_087y : packoffset(c087.y);
  float cb0_087z : packoffset(c087.z);
  float cb0_089x : packoffset(c089.x);
  float cb0_089z : packoffset(c089.z);
  float cb0_089w : packoffset(c089.w);
  float cb0_090x : packoffset(c090.x);
  float cb0_090y : packoffset(c090.y);
  float cb0_090z : packoffset(c090.z);
  float cb0_090w : packoffset(c090.w);
  float cb0_091x : packoffset(c091.x);
  float cb0_091y : packoffset(c091.y);
  float cb0_091z : packoffset(c091.z);
  float cb0_092x : packoffset(c092.x);
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
  float cb0_093x : packoffset(c093.x);
  float cb0_093y : packoffset(c093.y);
  float cb0_093z : packoffset(c093.z);
  float cb0_093w : packoffset(c093.w);
  float cb0_094x : packoffset(c094.x);
  float cb0_094y : packoffset(c094.y);
  float cb0_094z : packoffset(c094.z);
  float cb0_096x : packoffset(c096.x);
  float cb0_096y : packoffset(c096.y);
  float cb0_096z : packoffset(c096.z);
  float cb0_097x : packoffset(c097.x);
  int cb0_106w : packoffset(c106.w);
  float cb0_107x : packoffset(c107.x);
  float cb0_107z : packoffset(c107.z);
  int cb0_107w : packoffset(c107.w);
  int cb0_108x : packoffset(c108.x);
  int cb0_108y : packoffset(c108.y);
  int cb0_108z : packoffset(c108.z);
  int cb0_108w : packoffset(c108.w);
  float cb0_114x : packoffset(c114.x);
  float cb0_114y : packoffset(c114.y);
  float cb0_114z : packoffset(c114.z);
  float cb0_114w : packoffset(c114.w);
  float cb0_115x : packoffset(c115.x);
  float cb0_115y : packoffset(c115.y);
  float cb0_115z : packoffset(c115.z);
  float cb0_115w : packoffset(c115.w);
  float cb0_117x : packoffset(c117.x);
  float cb0_117y : packoffset(c117.y);
  float cb0_117z : packoffset(c117.z);
  float cb0_118x : packoffset(c118.x);
  float cb0_118y : packoffset(c118.y);
  float cb0_118z : packoffset(c118.z);
  float cb0_118w : packoffset(c118.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

SamplerState s4 : register(s4);

SamplerState s5 : register(s5);

SamplerState s6 : register(s6);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _37 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _38 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _39 = TEXCOORD_2.w * 543.3099975585938f;
  float _43 = frac(sin(_39 + TEXCOORD_2.z) * 493013.0f);
  float _67;
  float _68;
  float _156;
  float _157;
  float _251;
  float _252;
  float _317;
  float _318;
  float _319;
  float _331;
  float _332;
  float _333;
  float _473;
  float _474;
  float _475;
  float _507;
  float _508;
  float _509;
  float _556;
  float _557;
  float _558;
  float _573;
  float _574;
  float _575;
  float _648;
  float _649;
  float _650;
  float _738;
  float _739;
  float _740;
  if (cb0_097x > 0.0f) {
    _67 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _39) * 493013.0f) + 7.177000045776367f) - _43)) + _43);
    _68 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _39) * 493013.0f) + 14.298999786376953f) - _43)) + _43);
  } else {
    _67 = _43;
    _68 = _43;
  }
  float _73 = cb0_096z * (1.0f - (_43 * _43));
  float _78 = (_73 * (TEXCOORD_2.x - _37)) + _37;
  float _79 = (_73 * (TEXCOORD_2.y - _38)) + _38;
  float _94 = _78 - (((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x);
  float _95 = _79 - (((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y);
  float _105 = cb0_118z * cb0_117x;
  float _106 = cb0_118z * cb0_117y;
  bool _107 = (cb0_118x == 0.0f);
  float _117 = (cb0_114z * TEXCOORD_3.x) + cb0_114x;
  float _118 = (cb0_114w * TEXCOORD_3.y) + cb0_114y;
  float _129 = float((int)(((int)(uint)((bool)(_117 > 0.0f))) - ((int)(uint)((bool)(_117 < 0.0f)))));
  float _130 = float((int)(((int)(uint)((bool)(_118 > 0.0f))) - ((int)(uint)((bool)(_118 < 0.0f)))));
  float _135 = saturate(abs(_117) - cb0_117z);
  float _136 = saturate(abs(_118) - cb0_117z);
  float _146 = _118 - ((_136 * _105) * _130);
  float _148 = _118 - ((_136 * _106) * _130);
  bool _149 = (cb0_118x > 0.0f);
  if (_149) {
    _156 = (_146 - (cb0_118w * 0.4000000059604645f));
    _157 = (_148 - (cb0_118w * 0.20000000298023224f));
  } else {
    _156 = _146;
    _157 = _148;
  }
  float4 _193 = t0.Sample(s0, float2(min(max(_78, cb0_053z), cb0_054x), min(max(_79, cb0_053w), cb0_054y)));
  float4 _209 = t0.Sample(s0, float2(min(max(((((cb0_048z * ((cb0_115z * (_117 - ((_135 * select(_107, _105, cb0_117x)) * _129))) + cb0_115x)) + cb0_049x) * cb0_048x) + _94), cb0_053z), cb0_054x), min(max(((((cb0_048w * ((cb0_115w * _156) + cb0_115y)) + cb0_049y) * cb0_048y) + _95), cb0_053w), cb0_054y)));
  float4 _223 = t0.Sample(s0, float2(min(max(((((cb0_048z * ((cb0_115z * (_117 - ((_135 * select(_107, _106, cb0_117y)) * _129))) + cb0_115x)) + cb0_049x) * cb0_048x) + _94), cb0_053z), cb0_054x), min(max(((((cb0_048w * ((cb0_115w * _157) + cb0_115y)) + cb0_049y) * cb0_048y) + _95), cb0_053w), cb0_054y)));
  if (_149) {
    float _233 = saturate(((((_193.y * 0.5870000123977661f) - cb0_118y) + (_193.x * 0.29899999499320984f)) + (_193.z * 0.11400000005960464f)) * 10.0f);
    float _237 = (_233 * _233) * (3.0f - (_233 * 2.0f));
    _251 = ((((_193.x - _209.x) + (_237 * (_209.x - _193.x))) * cb0_118x) + _209.x);
    _252 = ((((_193.y - _223.y) + (_237 * (_223.y - _193.y))) * cb0_118x) + _223.y);
  } else {
    _251 = _209.x;
    _252 = _223.y;
  }
  float4 _277 = t1.Sample(s1, float2(min(max(((cb0_068z * _78) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _79) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_277);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _306 = (cb0_086x != 0);
    float4 _309 = t2.Sample(s2, float2(select(_306, _78, min(max(((cb0_076z * _78) + cb0_077x), cb0_075z), cb0_076x)), select(_306, _79, min(max(((cb0_076w * _79) + cb0_077y), cb0_075w), cb0_076y))));
    _317 = (_309.x + _277.x);
    _318 = (_309.y + _277.y);
    _319 = (_309.z + _277.z);
  } else {
    _317 = _277.x;
    _318 = _277.y;
    _319 = _277.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _323 = t3.Sample(s3, float2(_78, _79));
    _331 = (_323.x + _317);
    _332 = (_323.y + _318);
    _333 = (_323.z + _319);
  } else {
    _331 = _317;
    _332 = _318;
    _333 = _319;
  }
  float _358 = TEXCOORD_1.z + -1.0f;
  float _360 = TEXCOORD_1.w + -1.0f;
  float _363 = ((_358 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _365 = ((_360 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _372 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_363, _365), float2(_363, _365))) + 1.0f);
  float _373 = _372 * _372;
  float _374 = cb0_091z + 1.0f;
  float _402 = ((_358 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _404 = ((_360 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _411 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_402, _404), float2(_402, _404))) + 1.0f);
  float _412 = _411 * _411;
  float _413 = cb0_094z + 1.0f;
  float _434 = ((((_373 * (_374 - cb0_090x)) + cb0_090x) * (_331 + ((_251 * TEXCOORD_1.x) * cb0_087x))) * ((_412 * (_413 - cb0_093x)) + cb0_093x)) * ((cb0_096x * _43) + cb0_096y);
  float _437 = ((((_373 * (_374 - cb0_090y)) + cb0_090y) * (_332 + ((_252 * TEXCOORD_1.x) * cb0_087y))) * ((_412 * (_413 - cb0_093y)) + cb0_093y)) * ((cb0_096x * _67) + cb0_096y);
  float _440 = ((((_373 * (_374 - cb0_090z)) + cb0_090z) * (_333 + ((_193.z * TEXCOORD_1.x) * cb0_087z))) * ((_412 * (_413 - cb0_093z)) + cb0_093z)) * ((cb0_096x * _68) + cb0_096y);

  CAPTURE_UNTONEMAPPED(float3(_434, _437, _440));
  [branch]
  if (WUWA_TM_IS(1)) {
    _473 = ((((_434 * 1.3600000143051147f) + 0.04699999839067459f) * _434) / ((((_434 * 0.9599999785423279f) + 0.5600000023841858f) * _434) + 0.14000000059604645f));
    _474 = ((((_437 * 1.3600000143051147f) + 0.04699999839067459f) * _437) / ((((_437 * 0.9599999785423279f) + 0.5600000023841858f) * _437) + 0.14000000059604645f));
    _475 = ((((_440 * 1.3600000143051147f) + 0.04699999839067459f) * _440) / ((((_440 * 0.9599999785423279f) + 0.5600000023841858f) * _440) + 0.14000000059604645f));
  } else {
    _473 = _434;
    _474 = _437;
    _475 = _440;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _485 = 1.0049500465393066f - (0.16398000717163086f / (_473 + -0.19505000114440918f));
    float _486 = 1.0049500465393066f - (0.16398000717163086f / (_474 + -0.19505000114440918f));
    float _487 = 1.0049500465393066f - (0.16398000717163086f / (_475 + -0.19505000114440918f));
    _507 = (((_473 - _485) * select((_473 > 0.6000000238418579f), 0.0f, 1.0f)) + _485);
    _508 = (((_474 - _486) * select((_474 > 0.6000000238418579f), 0.0f, 1.0f)) + _486);
    _509 = (((_475 - _487) * select((_475 > 0.6000000238418579f), 0.0f, 1.0f)) + _487);
  } else {
    _507 = _473;
    _508 = _474;
    _509 = _475;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _515 = cb0_037y * _507;
    float _516 = cb0_037y * _508;
    float _517 = cb0_037y * _509;
    float _520 = cb0_037z * cb0_037w;
    float _530 = cb0_038y * cb0_038x;
    float _541 = cb0_038z * cb0_038x;
    float _548 = cb0_038y / cb0_038z;
    _556 = (((((_520 + _515) * _507) + _530) / (_541 + ((_515 + cb0_037z) * _507))) - _548);
    _557 = (((((_520 + _516) * _508) + _530) / (_541 + ((_516 + cb0_037z) * _508))) - _548);
    _558 = (((((_520 + _517) * _509) + _530) / (_541 + ((_517 + cb0_037z) * _509))) - _548);
  } else {
    _556 = _507;
    _557 = _508;
    _558 = _509;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _568 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _573 = (_568 * _556);
      _574 = (_568 * _557);
      _575 = (_568 * _558);
    } else {
      _573 = _556;
      _574 = _557;
      _575 = _558;
    }
  } else {
    _573 = _556;
    _574 = _557;
    _575 = _558;
  }
  CLAMP_IF_SDR3(_573, _574, _575);
  CAPTURE_TONEMAPPED(float3(_573, _574, _575));
  float _596 = (saturate((log2(_573 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _597 = (saturate((log2(_574 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _598 = (saturate((log2(_575 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _599 = t5.Sample(s5, float3(_596, _597, _598));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _623 = t4.Sample(s4, float2(min(max(((cb0_084z * _78) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _79) + cb0_085y), cb0_083w), cb0_084y)));
    float _633 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_623.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _634 = t6.Sample(s6, float3(_596, _597, _598));
    _648 = (lerp(_634.x, _599.x, _633));
    _649 = (lerp(_634.y, _599.y, _633));
    _650 = (lerp(_634.z, _599.z, _633));
  } else {
    _648 = _599.x;
    _649 = _599.y;
    _650 = _599.z;
  }
  HANDLE_LUT_OUTPUT3_FADE(_648, _649, _650, t5, s5);
  float _651 = _650 * 1.0499999523162842f;
  float _652 = _649 * 1.0499999523162842f;
  float _653 = _648 * 1.0499999523162842f;
  float _661 = ((_43 * 0.00390625f) + -0.001953125f) + _653;
  float _662 = ((_67 * 0.00390625f) + -0.001953125f) + _652;
  float _663 = ((_68 * 0.00390625f) + -0.001953125f) + _651;
  [branch]
  if (!(cb0_107w == 0)) {
    float _675 = (pow(_661, 0.012683313339948654f));
    float _676 = (pow(_662, 0.012683313339948654f));
    float _677 = (pow(_663, 0.012683313339948654f));
    float _710 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_675 + -0.8359375f)) / (18.8515625f - (_675 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _711 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_676 + -0.8359375f)) / (18.8515625f - (_676 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _712 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_677 + -0.8359375f)) / (18.8515625f - (_677 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _738 = min((_710 * 12.920000076293945f), ((exp2(log2(max(_710, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _739 = min((_711 * 12.920000076293945f), ((exp2(log2(max(_711, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _740 = min((_712 * 12.920000076293945f), ((exp2(log2(max(_712, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _738 = _661;
    _739 = _662;
    _740 = _663;
  }
  SV_Target.x = _738;
  SV_Target.y = _739;
  SV_Target.z = _740;
  SV_Target.w = dot(float3(_653, _652, _651), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
