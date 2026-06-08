#include "../../common.hlsl"
Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture3D<float4> t5 : register(t5);

Texture2D<float4> t6 : register(t6);

Texture3D<float4> t7 : register(t7);

Texture3D<float4> t8 : register(t8);

cbuffer cb0 : register(b0) {
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  float cb0_038z : packoffset(c038.z);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  float cb0_042w : packoffset(c042.w);
  float cb0_044z : packoffset(c044.z);
  float cb0_044w : packoffset(c044.w);
  float cb0_045x : packoffset(c045.x);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_046x : packoffset(c046.x);
  float cb0_046y : packoffset(c046.y);
  float cb0_046z : packoffset(c046.z);
  float cb0_046w : packoffset(c046.w);
  float cb0_047z : packoffset(c047.z);
  float cb0_047w : packoffset(c047.w);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
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

SamplerState s7 : register(s7);

SamplerState s8 : register(s8);

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
  float _42;
  float _43;
  float _44;
  float _48;
  float _72;
  float _73;
  float _134;
  float _135;
  float _203;
  float _204;
  float _264;
  float _332;
  float _333;
  float _334;
  float _346;
  float _347;
  float _348;
  float _477;
  float _478;
  float _479;
  float _511;
  float _512;
  float _513;
  float _560;
  float _561;
  float _562;
  float _577;
  float _578;
  float _579;
  float _651;
  float _652;
  float _653;
  float _741;
  float _742;
  float _743;
  float _83;
  float _84;
  bool _85;
  float _95;
  float _96;
  float _107;
  float _108;
  float _113;
  float _114;
  float _124;
  float _126;
  bool _127;
  float4 _169;
  float _185;
  float _189;
  float _213;
  float4 _231;
  float _238;
  float _241;
  float _243;
  float _249;
  float _251;
  bool _252;
  float4 _294;
  bool _321;
  float4 _324;
  float4 _338;
  float _349;
  float _374;
  float _376;
  float _379;
  float _381;
  float _388;
  float _389;
  float _390;
  float _418;
  float _420;
  float _427;
  float _428;
  float _429;
  float _440;
  float _442;
  float _444;
  float _489;
  float _490;
  float _491;
  float _519;
  float _520;
  float _521;
  float _524;
  float _534;
  float _545;
  float _552;
  float _572;
  float _600;
  float _601;
  float _602;
  float4 _603;
  float _636;
  float4 _637;
  float _654;
  float _655;
  float _656;
  float _664;
  float _665;
  float _666;
  float _678;
  float _679;
  float _680;
  float _713;
  float _714;
  float _715;
  _42 = ((cb0_048x * TEXCOORD_3.x) + cb0_048z) * cb0_047z;
  _43 = ((cb0_048y * TEXCOORD_3.y) + cb0_048w) * cb0_047w;
  _44 = TEXCOORD_2.w * 543.3099975585938f;
  _48 = frac(sin(_44 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_096x > 0.0f) {
    _72 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _44) * 493013.0f) + 7.177000045776367f) - _48)) + _48);
    _73 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _44) * 493013.0f) + 14.298999786376953f) - _48)) + _48);
  } else {
    _72 = _48;
    _73 = _48;
  }
  _83 = cb0_117z * cb0_116x;
  _84 = cb0_117z * cb0_116y;
  _85 = (cb0_117x == 0.0f);
  _95 = (cb0_113z * TEXCOORD_3.x) + cb0_113x;
  _96 = (cb0_113w * TEXCOORD_3.y) + cb0_113y;
  _107 = float((int)(((int)(uint)((bool)(_95 > 0.0f))) - ((int)(uint)((bool)(_95 < 0.0f)))));
  _108 = float((int)(((int)(uint)((bool)(_96 > 0.0f))) - ((int)(uint)((bool)(_96 < 0.0f)))));
  _113 = saturate(abs(_95) - cb0_116z);
  _114 = saturate(abs(_96) - cb0_116z);
  _124 = _96 - ((_114 * _83) * _108);
  _126 = _96 - ((_114 * _84) * _108);
  _127 = (cb0_117x > 0.0f);
  if (_127) {
    _134 = (_124 - (cb0_117w * 0.4000000059604645f));
    _135 = (_126 - (cb0_117w * 0.20000000298023224f));
  } else {
    _134 = _124;
    _135 = _126;
  }
  _169 = t0.Sample(s0, float2(_42, _43));
  if (_127) {
    _185 = saturate(((((_169.y * 0.5870000123977661f) - cb0_117y) + (_169.x * 0.29899999499320984f)) + (_169.z * 0.11400000005960464f)) * 10.0f);
    _189 = (_185 * _185) * (3.0f - (_185 * 2.0f));
    _203 = ((((_169.x - (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_95 - ((_113 * select(_85, _83, cb0_116x)) * _107))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _134) + cb0_114y)) + cb0_048w) * cb0_047w))))).x)) + (_189 * ((((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_95 - ((_113 * select(_85, _83, cb0_116x)) * _107))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _134) + cb0_114y)) + cb0_048w) * cb0_047w))))).x) - _169.x))) * cb0_117x) + (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_95 - ((_113 * select(_85, _83, cb0_116x)) * _107))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _134) + cb0_114y)) + cb0_048w) * cb0_047w))))).x));
    _204 = ((((_169.y - (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_95 - ((_113 * select(_85, _84, cb0_116y)) * _107))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _135) + cb0_114y)) + cb0_048w) * cb0_047w))))).y)) + (_189 * ((((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_95 - ((_113 * select(_85, _84, cb0_116y)) * _107))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _135) + cb0_114y)) + cb0_048w) * cb0_047w))))).y) - _169.y))) * cb0_117x) + (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_95 - ((_113 * select(_85, _84, cb0_116y)) * _107))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _135) + cb0_114y)) + cb0_048w) * cb0_047w))))).y));
  } else {
    _203 = (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_95 - ((_113 * select(_85, _83, cb0_116x)) * _107))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _134) + cb0_114y)) + cb0_048w) * cb0_047w))))).x);
    _204 = (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_95 - ((_113 * select(_85, _84, cb0_116y)) * _107))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _135) + cb0_114y)) + cb0_048w) * cb0_047w))))).y);
  }
  _213 = log2(max(dot(float3(_203, _204, _169.z), float3(cb0_042y, cb0_042z, cb0_042w)), cb0_041z));
  _231 = t5.Sample(s5, float3((cb0_046x * TEXCOORD_4.x), (cb0_046y * TEXCOORD_4.y), ((((cb0_041x * _213) + cb0_041y) * 0.96875f) + 0.015625f)));
  _238 = select((_231.y < 0.0010000000474974513f), (((float4)(t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x), (_231.x / _231.y));
  _241 = log2(TEXCOORD_1.x);
  _243 = (_238 + _241) + (((((float4)(t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x) - _238) * cb0_045y);
  _249 = _241 + _213;
  _251 = _243 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_045z);
  _252 = (_251 > 0.0f);
  if (_252) {
    _264 = max(0.0f, (_251 - cb0_046z));
  } else {
    _264 = min(0.0f, (cb0_046w + _251));
  }
  _294 = t1.Sample(s1, float2(min(max(((cb0_068x * _42) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _43) + cb0_068w), cb0_060y), cb0_060w)));
  APPLY_BLOOM(_294);
  [branch]
  if (!(cb0_085x == 0)) {
    _321 = (cb0_085z != 0);
    _324 = t2.Sample(s2, float2(select(_321, _42, min(max(((cb0_076x * _42) + cb0_076z), cb0_075x), cb0_075z)), select(_321, _43, min(max(((cb0_076y * _43) + cb0_076w), cb0_075y), cb0_075w))));
    _332 = (_324.x + _294.x);
    _333 = (_324.y + _294.y);
    _334 = (_324.z + _294.z);
  } else {
    _332 = _294.x;
    _333 = _294.y;
    _334 = _294.z;
  }
  [branch]
  if (!(cb0_085y == 0)) {
    _338 = t3.Sample(s3, float2(_42, _43));
    _346 = (_338.x + _332);
    _347 = (_338.y + _333);
    _348 = (_338.z + _334);
  } else {
    _346 = _332;
    _347 = _333;
    _348 = _334;
  }
  _349 = exp2((((_243 - _249) + ((_249 - _243) * cb0_045x)) - _264) + (_264 * select(_252, cb0_044z, cb0_044w))) * TEXCOORD_1.x;
  _374 = TEXCOORD_1.z + -1.0f;
  _376 = TEXCOORD_1.w + -1.0f;
  _379 = ((_374 + (cb0_090x * 2.0f)) * cb0_088z) * cb0_088x;
  _381 = ((_376 + (cb0_090y * 2.0f)) * cb0_088w) * cb0_088x;
  _388 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_379, _381), float2(_379, _381))) + 1.0f);
  _389 = _388 * _388;
  _390 = cb0_090z + 1.0f;
  _418 = ((_374 + (cb0_093x * 2.0f)) * cb0_091z) * cb0_091x;
  _420 = ((_376 + (cb0_093y * 2.0f)) * cb0_091w) * cb0_091x;
  _427 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_418, _420), float2(_418, _420))) + 1.0f);
  _428 = _427 * _427;
  _429 = cb0_093z + 1.0f;
  _440 = (((_389 * (_390 - cb0_089x)) + cb0_089x) * (_346 + ((_349 * _203) * cb0_086x))) * ((_428 * (_429 - cb0_092x)) + cb0_092x);
  _442 = (((_389 * (_390 - cb0_089y)) + cb0_089y) * (_347 + ((_349 * _204) * cb0_086y))) * ((_428 * (_429 - cb0_092y)) + cb0_092y);
  _444 = (((_389 * (_390 - cb0_089z)) + cb0_089z) * (_348 + ((_349 * _169.z) * cb0_086z))) * ((_428 * (_429 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_440, _442, _444));
  [branch]
  if (WUWA_TM_IS(1)) {
    _477 = ((((_440 * 1.3600000143051147f) + 0.04699999839067459f) * _440) / ((((_440 * 0.9599999785423279f) + 0.5600000023841858f) * _440) + 0.14000000059604645f));
    _478 = ((((_442 * 1.3600000143051147f) + 0.04699999839067459f) * _442) / ((((_442 * 0.9599999785423279f) + 0.5600000023841858f) * _442) + 0.14000000059604645f));
    _479 = ((((_444 * 1.3600000143051147f) + 0.04699999839067459f) * _444) / ((((_444 * 0.9599999785423279f) + 0.5600000023841858f) * _444) + 0.14000000059604645f));
  } else {
    _477 = _440;
    _478 = _442;
    _479 = _444;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _489 = 1.0049500465393066f - (0.16398000717163086f / (_477 + -0.19505000114440918f));
    _490 = 1.0049500465393066f - (0.16398000717163086f / (_478 + -0.19505000114440918f));
    _491 = 1.0049500465393066f - (0.16398000717163086f / (_479 + -0.19505000114440918f));
    _511 = ((_477 - _489) * select((_477 > 0.6000000238418579f), 0.0f, 1.0f)) + _489;
    _512 = ((_478 - _490) * select((_478 > 0.6000000238418579f), 0.0f, 1.0f)) + _490;
    _513 = ((_479 - _491) * select((_479 > 0.6000000238418579f), 0.0f, 1.0f)) + _491;
  } else {
    _511 = _477;
    _512 = _478;
    _513 = _479;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _519 = cb0_037y * _511;
    _520 = cb0_037y * _512;
    _521 = cb0_037y * _513;
    _524 = cb0_037z * cb0_037w;
    _534 = cb0_038y * cb0_038x;
    _545 = cb0_038z * cb0_038x;
    _552 = cb0_038y / cb0_038z;
    _560 = ((((_524 + _519) * _511) + _534) / (_545 + ((_519 + cb0_037z) * _511))) - _552;
    _561 = ((((_524 + _520) * _512) + _534) / (_545 + ((_520 + cb0_037z) * _512))) - _552;
    _562 = ((((_524 + _521) * _513) + _534) / (_545 + ((_521 + cb0_037z) * _513))) - _552;
  } else {
    _560 = _511;
    _561 = _512;
    _562 = _513;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _572 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _577 = (_572 * _560);
      _578 = (_572 * _561);
      _579 = (_572 * _562);
    } else {
      _577 = _560;
      _578 = _561;
      _579 = _562;
    }
  } else {
    _577 = _560;
    _578 = _561;
    _579 = _562;
  }
  APPLY_EXTENDED_TONEMAP(_577, _578, _579);
  _600 = (saturate((log2(_577 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _601 = (saturate((log2(_578 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _602 = (saturate((log2(_579 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _603 = t7.Sample(s7, float3(_600, _601, _602));
  [branch]
  if (!(cb0_107w == 0)) {
    _636 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _42) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _43) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _637 = t8.Sample(s8, float3(_600, _601, _602));
    _651 = (lerp(_637.x, _603.x, _636));
    _652 = (lerp(_637.y, _603.y, _636));
    _653 = (lerp(_637.z, _603.z, _636));
  } else {
    _651 = _603.x;
    _652 = _603.y;
    _653 = _603.z;
  }
  _654 = _653 * 1.0499999523162842f;
  _655 = _652 * 1.0499999523162842f;
  _656 = _651 * 1.0499999523162842f;
  _664 = ((_48 * 0.00390625f) + -0.001953125f) + _656;
  _665 = ((_72 * 0.00390625f) + -0.001953125f) + _655;
  _666 = ((_73 * 0.00390625f) + -0.001953125f) + _654;
  [branch]
  if (!(cb0_106w == 0)) {
    _678 = (pow(_664, 0.012683313339948654f));
    _679 = (pow(_665, 0.012683313339948654f));
    _680 = (pow(_666, 0.012683313339948654f));
    _713 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_678 + -0.8359375f)) / (18.8515625f - (_678 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _714 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_679 + -0.8359375f)) / (18.8515625f - (_679 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _715 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_680 + -0.8359375f)) / (18.8515625f - (_680 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _741 = min((_713 * 12.920000076293945f), ((exp2(log2(max(_713, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _742 = min((_714 * 12.920000076293945f), ((exp2(log2(max(_714, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _743 = min((_715 * 12.920000076293945f), ((exp2(log2(max(_715, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _741 = _664;
    _742 = _665;
    _743 = _666;
  }
  SV_Target.x = _741;
  SV_Target.y = _742;
  SV_Target.z = _743;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = (dot(float3(_656, _655, _654), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}