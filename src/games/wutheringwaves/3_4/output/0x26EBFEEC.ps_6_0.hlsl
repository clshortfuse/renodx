#include "../../common.hlsl"
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
  float cb0_047z : packoffset(c047.z);
  float cb0_047w : packoffset(c047.w);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_053x : packoffset(c053.x);
  float cb0_053y : packoffset(c053.y);
  float cb0_053z : packoffset(c053.z);
  float cb0_053w : packoffset(c053.w);
  float cb0_060x : packoffset(c060.x);
  float cb0_060y : packoffset(c060.y);
  float cb0_060z : packoffset(c060.z);
  float cb0_060w : packoffset(c060.w);
  float cb0_068x : packoffset(c068.x);
  float cb0_068y : packoffset(c068.y);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_075x : packoffset(c075.x);
  float cb0_075y : packoffset(c075.y);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_076z : packoffset(c076.z);
  float cb0_076w : packoffset(c076.w);
  float cb0_083x : packoffset(c083.x);
  float cb0_083y : packoffset(c083.y);
  float cb0_083z : packoffset(c083.z);
  float cb0_083w : packoffset(c083.w);
  float cb0_084x : packoffset(c084.x);
  float cb0_084y : packoffset(c084.y);
  float cb0_084z : packoffset(c084.z);
  float cb0_084w : packoffset(c084.w);
  int cb0_085x : packoffset(c085.x);
  int cb0_085y : packoffset(c085.y);
  int cb0_085z : packoffset(c085.z);
  float cb0_086x : packoffset(c086.x);
  float cb0_086y : packoffset(c086.y);
  float cb0_086z : packoffset(c086.z);
  float cb0_088x : packoffset(c088.x);
  float cb0_088z : packoffset(c088.z);
  float cb0_088w : packoffset(c088.w);
  float cb0_089x : packoffset(c089.x);
  float cb0_089y : packoffset(c089.y);
  float cb0_089z : packoffset(c089.z);
  float cb0_089w : packoffset(c089.w);
  float cb0_090x : packoffset(c090.x);
  float cb0_090y : packoffset(c090.y);
  float cb0_090z : packoffset(c090.z);
  float cb0_091x : packoffset(c091.x);
  float cb0_091z : packoffset(c091.z);
  float cb0_091w : packoffset(c091.w);
  float cb0_092x : packoffset(c092.x);
  float cb0_092y : packoffset(c092.y);
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
  float cb0_093x : packoffset(c093.x);
  float cb0_093y : packoffset(c093.y);
  float cb0_093z : packoffset(c093.z);
  float cb0_095z : packoffset(c095.z);
  float cb0_096x : packoffset(c096.x);
  int cb0_105w : packoffset(c105.w);
  float cb0_106x : packoffset(c106.x);
  float cb0_106z : packoffset(c106.z);
  int cb0_106w : packoffset(c106.w);
  int cb0_107x : packoffset(c107.x);
  int cb0_107y : packoffset(c107.y);
  int cb0_107z : packoffset(c107.z);
  int cb0_107w : packoffset(c107.w);
  float cb0_113x : packoffset(c113.x);
  float cb0_113y : packoffset(c113.y);
  float cb0_113z : packoffset(c113.z);
  float cb0_113w : packoffset(c113.w);
  float cb0_114x : packoffset(c114.x);
  float cb0_114y : packoffset(c114.y);
  float cb0_114z : packoffset(c114.z);
  float cb0_114w : packoffset(c114.w);
  float cb0_116x : packoffset(c116.x);
  float cb0_116y : packoffset(c116.y);
  float cb0_116z : packoffset(c116.z);
  float cb0_117x : packoffset(c117.x);
  float cb0_117y : packoffset(c117.y);
  float cb0_117z : packoffset(c117.z);
  float cb0_117w : packoffset(c117.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

SamplerState s4 : register(s4);

SamplerState s5 : register(s5);

SamplerState s6 : register(s6);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _37;
  float _38;
  float _39;
  float _43;
  float _67;
  float _68;
  float _156;
  float _157;
  float _248;
  float _249;
  float _310;
  float _311;
  float _312;
  float _324;
  float _325;
  float _326;
  float _454;
  float _455;
  float _456;
  float _488;
  float _489;
  float _490;
  float _537;
  float _538;
  float _539;
  float _554;
  float _555;
  float _556;
  float _628;
  float _629;
  float _630;
  float _718;
  float _719;
  float _720;
  float _73;
  float _78;
  float _79;
  float _94;
  float _95;
  float _105;
  float _106;
  bool _107;
  float _117;
  float _118;
  float _129;
  float _130;
  float _135;
  float _136;
  float _146;
  float _148;
  bool _149;
  float4 _192;
  float _230;
  float _234;
  float4 _272;
  bool _299;
  float4 _302;
  float4 _316;
  float _351;
  float _353;
  float _356;
  float _358;
  float _365;
  float _366;
  float _367;
  float _395;
  float _397;
  float _404;
  float _405;
  float _406;
  float _417;
  float _419;
  float _421;
  float _466;
  float _467;
  float _468;
  float _496;
  float _497;
  float _498;
  float _501;
  float _511;
  float _522;
  float _529;
  float _549;
  float _577;
  float _578;
  float _579;
  float4 _580;
  float _613;
  float4 _614;
  float _631;
  float _632;
  float _633;
  float _641;
  float _642;
  float _643;
  float _655;
  float _656;
  float _657;
  float _690;
  float _691;
  float _692;
  _37 = ((cb0_048x * TEXCOORD_3.x) + cb0_048z) * cb0_047z;
  _38 = ((cb0_048y * TEXCOORD_3.y) + cb0_048w) * cb0_047w;
  _39 = TEXCOORD_2.w * 543.3099975585938f;
  _43 = frac(sin(_39 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_096x > 0.0f) {
    _67 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _39) * 493013.0f) + 7.177000045776367f) - _43)) + _43);
    _68 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _39) * 493013.0f) + 14.298999786376953f) - _43)) + _43);
  } else {
    _67 = _43;
    _68 = _43;
  }
  _73 = cb0_095z * (1.0f - (_43 * _43));
  _78 = (_73 * (TEXCOORD_2.x - _37)) + _37;
  _79 = (_73 * (TEXCOORD_2.y - _38)) + _38;
  _94 = _78 - (((cb0_048x * TEXCOORD_3.x) + cb0_048z) * cb0_047z);
  _95 = _79 - (((cb0_048y * TEXCOORD_3.y) + cb0_048w) * cb0_047w);
  _105 = cb0_117z * cb0_116x;
  _106 = cb0_117z * cb0_116y;
  _107 = (cb0_117x == 0.0f);
  _117 = (cb0_113z * TEXCOORD_3.x) + cb0_113x;
  _118 = (cb0_113w * TEXCOORD_3.y) + cb0_113y;
  _129 = float((int)(((int)(uint)((bool)(_117 > 0.0f))) - ((int)(uint)((bool)(_117 < 0.0f)))));
  _130 = float((int)(((int)(uint)((bool)(_118 > 0.0f))) - ((int)(uint)((bool)(_118 < 0.0f)))));
  _135 = saturate(abs(_117) - cb0_116z);
  _136 = saturate(abs(_118) - cb0_116z);
  _146 = _118 - ((_136 * _105) * _130);
  _148 = _118 - ((_136 * _106) * _130);
  _149 = (cb0_117x > 0.0f);
  if (_149) {
    _156 = (_146 - (cb0_117w * 0.4000000059604645f));
    _157 = (_148 - (cb0_117w * 0.20000000298023224f));
  } else {
    _156 = _146;
    _157 = _148;
  }
  _192 = t0.Sample(s0, float2(min(max(_78, cb0_053x), cb0_053z), min(max(_79, cb0_053y), cb0_053w)));
  if (_149) {
    _230 = saturate(((((_192.y * 0.5870000123977661f) - cb0_117y) + (_192.x * 0.29899999499320984f)) + (_192.z * 0.11400000005960464f)) * 10.0f);
    _234 = (_230 * _230) * (3.0f - (_230 * 2.0f));
    _248 = ((((_192.x - (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_117 - ((_135 * select(_107, _105, cb0_116x)) * _129))) + cb0_114x)) + cb0_048z) * cb0_047z) + _94), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _156) + cb0_114y)) + cb0_048w) * cb0_047w) + _95), cb0_053y), cb0_053w))))).x)) + (_234 * ((((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_117 - ((_135 * select(_107, _105, cb0_116x)) * _129))) + cb0_114x)) + cb0_048z) * cb0_047z) + _94), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _156) + cb0_114y)) + cb0_048w) * cb0_047w) + _95), cb0_053y), cb0_053w))))).x) - _192.x))) * cb0_117x) + (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_117 - ((_135 * select(_107, _105, cb0_116x)) * _129))) + cb0_114x)) + cb0_048z) * cb0_047z) + _94), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _156) + cb0_114y)) + cb0_048w) * cb0_047w) + _95), cb0_053y), cb0_053w))))).x));
    _249 = ((((_192.y - (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_117 - ((_135 * select(_107, _106, cb0_116y)) * _129))) + cb0_114x)) + cb0_048z) * cb0_047z) + _94), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _157) + cb0_114y)) + cb0_048w) * cb0_047w) + _95), cb0_053y), cb0_053w))))).y)) + (_234 * ((((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_117 - ((_135 * select(_107, _106, cb0_116y)) * _129))) + cb0_114x)) + cb0_048z) * cb0_047z) + _94), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _157) + cb0_114y)) + cb0_048w) * cb0_047w) + _95), cb0_053y), cb0_053w))))).y) - _192.y))) * cb0_117x) + (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_117 - ((_135 * select(_107, _106, cb0_116y)) * _129))) + cb0_114x)) + cb0_048z) * cb0_047z) + _94), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _157) + cb0_114y)) + cb0_048w) * cb0_047w) + _95), cb0_053y), cb0_053w))))).y));
  } else {
    _248 = (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_117 - ((_135 * select(_107, _105, cb0_116x)) * _129))) + cb0_114x)) + cb0_048z) * cb0_047z) + _94), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _156) + cb0_114y)) + cb0_048w) * cb0_047w) + _95), cb0_053y), cb0_053w))))).x);
    _249 = (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_117 - ((_135 * select(_107, _106, cb0_116y)) * _129))) + cb0_114x)) + cb0_048z) * cb0_047z) + _94), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _157) + cb0_114y)) + cb0_048w) * cb0_047w) + _95), cb0_053y), cb0_053w))))).y);
  }
  _272 = t1.Sample(s1, float2(min(max(((cb0_068x * _78) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _79) + cb0_068w), cb0_060y), cb0_060w)));
  APPLY_BLOOM(_272);
  [branch]
  if (!(cb0_085x == 0)) {
    _299 = (cb0_085z != 0);
    _302 = t2.Sample(s2, float2(select(_299, _78, min(max(((cb0_076x * _78) + cb0_076z), cb0_075x), cb0_075z)), select(_299, _79, min(max(((cb0_076y * _79) + cb0_076w), cb0_075y), cb0_075w))));
    _310 = (_302.x + _272.x);
    _311 = (_302.y + _272.y);
    _312 = (_302.z + _272.z);
  } else {
    _310 = _272.x;
    _311 = _272.y;
    _312 = _272.z;
  }
  [branch]
  if (!(cb0_085y == 0)) {
    _316 = t3.Sample(s3, float2(_78, _79));
    _324 = (_316.x + _310);
    _325 = (_316.y + _311);
    _326 = (_316.z + _312);
  } else {
    _324 = _310;
    _325 = _311;
    _326 = _312;
  }
  _351 = TEXCOORD_1.z + -1.0f;
  _353 = TEXCOORD_1.w + -1.0f;
  _356 = ((_351 + (cb0_090x * 2.0f)) * cb0_088z) * cb0_088x;
  _358 = ((_353 + (cb0_090y * 2.0f)) * cb0_088w) * cb0_088x;
  _365 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_356, _358), float2(_356, _358))) + 1.0f);
  _366 = _365 * _365;
  _367 = cb0_090z + 1.0f;
  _395 = ((_351 + (cb0_093x * 2.0f)) * cb0_091z) * cb0_091x;
  _397 = ((_353 + (cb0_093y * 2.0f)) * cb0_091w) * cb0_091x;
  _404 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_395, _397), float2(_395, _397))) + 1.0f);
  _405 = _404 * _404;
  _406 = cb0_093z + 1.0f;
  _417 = (((_366 * (_367 - cb0_089x)) + cb0_089x) * (_324 + ((_248 * TEXCOORD_1.x) * cb0_086x))) * ((_405 * (_406 - cb0_092x)) + cb0_092x);
  _419 = (((_366 * (_367 - cb0_089y)) + cb0_089y) * (_325 + ((_249 * TEXCOORD_1.x) * cb0_086y))) * ((_405 * (_406 - cb0_092y)) + cb0_092y);
  _421 = (((_366 * (_367 - cb0_089z)) + cb0_089z) * (_326 + ((_192.z * TEXCOORD_1.x) * cb0_086z))) * ((_405 * (_406 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_417, _419, _421));
  [branch]
  if (WUWA_TM_IS(1)) {
    _454 = ((((_417 * 1.3600000143051147f) + 0.04699999839067459f) * _417) / ((((_417 * 0.9599999785423279f) + 0.5600000023841858f) * _417) + 0.14000000059604645f));
    _455 = ((((_419 * 1.3600000143051147f) + 0.04699999839067459f) * _419) / ((((_419 * 0.9599999785423279f) + 0.5600000023841858f) * _419) + 0.14000000059604645f));
    _456 = ((((_421 * 1.3600000143051147f) + 0.04699999839067459f) * _421) / ((((_421 * 0.9599999785423279f) + 0.5600000023841858f) * _421) + 0.14000000059604645f));
  } else {
    _454 = _417;
    _455 = _419;
    _456 = _421;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _466 = 1.0049500465393066f - (0.16398000717163086f / (_454 + -0.19505000114440918f));
    _467 = 1.0049500465393066f - (0.16398000717163086f / (_455 + -0.19505000114440918f));
    _468 = 1.0049500465393066f - (0.16398000717163086f / (_456 + -0.19505000114440918f));
    _488 = ((_454 - _466) * select((_454 > 0.6000000238418579f), 0.0f, 1.0f)) + _466;
    _489 = ((_455 - _467) * select((_455 > 0.6000000238418579f), 0.0f, 1.0f)) + _467;
    _490 = ((_456 - _468) * select((_456 > 0.6000000238418579f), 0.0f, 1.0f)) + _468;
  } else {
    _488 = _454;
    _489 = _455;
    _490 = _456;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _496 = cb0_037y * _488;
    _497 = cb0_037y * _489;
    _498 = cb0_037y * _490;
    _501 = cb0_037z * cb0_037w;
    _511 = cb0_038y * cb0_038x;
    _522 = cb0_038z * cb0_038x;
    _529 = cb0_038y / cb0_038z;
    _537 = ((((_501 + _496) * _488) + _511) / (_522 + ((_496 + cb0_037z) * _488))) - _529;
    _538 = ((((_501 + _497) * _489) + _511) / (_522 + ((_497 + cb0_037z) * _489))) - _529;
    _539 = ((((_501 + _498) * _490) + _511) / (_522 + ((_498 + cb0_037z) * _490))) - _529;
  } else {
    _537 = _488;
    _538 = _489;
    _539 = _490;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _549 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _554 = (_549 * _537);
      _555 = (_549 * _538);
      _556 = (_549 * _539);
    } else {
      _554 = _537;
      _555 = _538;
      _556 = _539;
    }
  } else {
    _554 = _537;
    _555 = _538;
    _556 = _539;
  }
  APPLY_EXTENDED_TONEMAP(_554, _555, _556);
  _577 = (saturate((log2(_554 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _578 = (saturate((log2(_555 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _579 = (saturate((log2(_556 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _580 = t5.Sample(s5, float3(_577, _578, _579));
  [branch]
  if (!(cb0_107w == 0)) {
    _613 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _78) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _79) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _614 = t6.Sample(s6, float3(_577, _578, _579));
    _628 = (lerp(_614.x, _580.x, _613));
    _629 = (lerp(_614.y, _580.y, _613));
    _630 = (lerp(_614.z, _580.z, _613));
  } else {
    _628 = _580.x;
    _629 = _580.y;
    _630 = _580.z;
  }
  _631 = _630 * 1.0499999523162842f;
  _632 = _629 * 1.0499999523162842f;
  _633 = _628 * 1.0499999523162842f;
  _641 = ((_43 * 0.00390625f) + -0.001953125f) + _633;
  _642 = ((_67 * 0.00390625f) + -0.001953125f) + _632;
  _643 = ((_68 * 0.00390625f) + -0.001953125f) + _631;
  [branch]
  if (!(cb0_106w == 0)) {
    _655 = (pow(_641, 0.012683313339948654f));
    _656 = (pow(_642, 0.012683313339948654f));
    _657 = (pow(_643, 0.012683313339948654f));
    _690 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_655 + -0.8359375f)) / (18.8515625f - (_655 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _691 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_656 + -0.8359375f)) / (18.8515625f - (_656 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _692 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_657 + -0.8359375f)) / (18.8515625f - (_657 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _718 = min((_690 * 12.920000076293945f), ((exp2(log2(max(_690, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _719 = min((_691 * 12.920000076293945f), ((exp2(log2(max(_691, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _720 = min((_692 * 12.920000076293945f), ((exp2(log2(max(_692, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _718 = _641;
    _719 = _642;
    _720 = _643;
  }
  SV_Target.x = _718;
  SV_Target.y = _719;
  SV_Target.z = _720;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = (dot(float3(_633, _632, _631), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}