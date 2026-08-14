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
  float cb0_095x : packoffset(c095.x);
  float cb0_095y : packoffset(c095.y);
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
  float _466;
  float _467;
  float _468;
  float _500;
  float _501;
  float _502;
  float _549;
  float _550;
  float _551;
  float _566;
  float _567;
  float _568;
  float _640;
  float _641;
  float _642;
  float _730;
  float _731;
  float _732;
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
  float _427;
  float _430;
  float _433;
  float _478;
  float _479;
  float _480;
  float _508;
  float _509;
  float _510;
  float _513;
  float _523;
  float _534;
  float _541;
  float _561;
  float _589;
  float _590;
  float _591;
  float4 _592;
  float _625;
  float4 _626;
  float _643;
  float _644;
  float _645;
  float _653;
  float _654;
  float _655;
  float _667;
  float _668;
  float _669;
  float _702;
  float _703;
  float _704;
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
  _427 = ((((_366 * (_367 - cb0_089x)) + cb0_089x) * (_324 + ((_248 * TEXCOORD_1.x) * cb0_086x))) * ((_405 * (_406 - cb0_092x)) + cb0_092x)) * ((cb0_095x * _43) + cb0_095y);
  _430 = ((((_366 * (_367 - cb0_089y)) + cb0_089y) * (_325 + ((_249 * TEXCOORD_1.x) * cb0_086y))) * ((_405 * (_406 - cb0_092y)) + cb0_092y)) * ((cb0_095x * _67) + cb0_095y);
  _433 = ((((_366 * (_367 - cb0_089z)) + cb0_089z) * (_326 + ((_192.z * TEXCOORD_1.x) * cb0_086z))) * ((_405 * (_406 - cb0_092z)) + cb0_092z)) * ((cb0_095x * _68) + cb0_095y);
  CAPTURE_UNTONEMAPPED(float3(_427, _430, _433));
  [branch]
  if (WUWA_TM_IS(1)) {
    _466 = ((((_427 * 1.3600000143051147f) + 0.04699999839067459f) * _427) / ((((_427 * 0.9599999785423279f) + 0.5600000023841858f) * _427) + 0.14000000059604645f));
    _467 = ((((_430 * 1.3600000143051147f) + 0.04699999839067459f) * _430) / ((((_430 * 0.9599999785423279f) + 0.5600000023841858f) * _430) + 0.14000000059604645f));
    _468 = ((((_433 * 1.3600000143051147f) + 0.04699999839067459f) * _433) / ((((_433 * 0.9599999785423279f) + 0.5600000023841858f) * _433) + 0.14000000059604645f));
  } else {
    _466 = _427;
    _467 = _430;
    _468 = _433;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _478 = 1.0049500465393066f - (0.16398000717163086f / (_466 + -0.19505000114440918f));
    _479 = 1.0049500465393066f - (0.16398000717163086f / (_467 + -0.19505000114440918f));
    _480 = 1.0049500465393066f - (0.16398000717163086f / (_468 + -0.19505000114440918f));
    _500 = ((_466 - _478) * select((_466 > 0.6000000238418579f), 0.0f, 1.0f)) + _478;
    _501 = ((_467 - _479) * select((_467 > 0.6000000238418579f), 0.0f, 1.0f)) + _479;
    _502 = ((_468 - _480) * select((_468 > 0.6000000238418579f), 0.0f, 1.0f)) + _480;
  } else {
    _500 = _466;
    _501 = _467;
    _502 = _468;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _508 = cb0_037y * _500;
    _509 = cb0_037y * _501;
    _510 = cb0_037y * _502;
    _513 = cb0_037z * cb0_037w;
    _523 = cb0_038y * cb0_038x;
    _534 = cb0_038z * cb0_038x;
    _541 = cb0_038y / cb0_038z;
    _549 = ((((_513 + _508) * _500) + _523) / (_534 + ((_508 + cb0_037z) * _500))) - _541;
    _550 = ((((_513 + _509) * _501) + _523) / (_534 + ((_509 + cb0_037z) * _501))) - _541;
    _551 = ((((_513 + _510) * _502) + _523) / (_534 + ((_510 + cb0_037z) * _502))) - _541;
  } else {
    _549 = _500;
    _550 = _501;
    _551 = _502;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _561 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _566 = (_561 * _549);
      _567 = (_561 * _550);
      _568 = (_561 * _551);
    } else {
      _566 = _549;
      _567 = _550;
      _568 = _551;
    }
  } else {
    _566 = _549;
    _567 = _550;
    _568 = _551;
  }
  APPLY_EXTENDED_TONEMAP(_566, _567, _568);
  _589 = (saturate((log2(_566 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _590 = (saturate((log2(_567 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _591 = (saturate((log2(_568 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _592 = t5.Sample(s5, float3(_589, _590, _591));
  [branch]
  if (!(cb0_107w == 0)) {
    _625 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _78) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _79) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _626 = t6.Sample(s6, float3(_589, _590, _591));
    _640 = (lerp(_626.x, _592.x, _625));
    _641 = (lerp(_626.y, _592.y, _625));
    _642 = (lerp(_626.z, _592.z, _625));
  } else {
    _640 = _592.x;
    _641 = _592.y;
    _642 = _592.z;
  }
  _643 = _642 * 1.0499999523162842f;
  _644 = _641 * 1.0499999523162842f;
  _645 = _640 * 1.0499999523162842f;
  _653 = ((_43 * 0.00390625f) + -0.001953125f) + _645;
  _654 = ((_67 * 0.00390625f) + -0.001953125f) + _644;
  _655 = ((_68 * 0.00390625f) + -0.001953125f) + _643;
  [branch]
  if (!(cb0_106w == 0)) {
    _667 = (pow(_653, 0.012683313339948654f));
    _668 = (pow(_654, 0.012683313339948654f));
    _669 = (pow(_655, 0.012683313339948654f));
    _702 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_667 + -0.8359375f)) / (18.8515625f - (_667 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _703 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_668 + -0.8359375f)) / (18.8515625f - (_668 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _704 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_669 + -0.8359375f)) / (18.8515625f - (_669 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _730 = min((_702 * 12.920000076293945f), ((exp2(log2(max(_702, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _731 = min((_703 * 12.920000076293945f), ((exp2(log2(max(_703, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _732 = min((_704 * 12.920000076293945f), ((exp2(log2(max(_704, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _730 = _653;
    _731 = _654;
    _732 = _655;
  }
  SV_Target.x = _730;
  SV_Target.y = _731;
  SV_Target.z = _732;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = (dot(float3(_645, _644, _643), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}