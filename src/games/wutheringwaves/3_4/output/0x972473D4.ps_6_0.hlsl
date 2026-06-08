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
  float _44;
  float _45;
  float _46;
  float _50;
  float _74;
  float _75;
  float _163;
  float _164;
  float _255;
  float _256;
  float _316;
  float _384;
  float _385;
  float _386;
  float _398;
  float _399;
  float _400;
  float _529;
  float _530;
  float _531;
  float _563;
  float _564;
  float _565;
  float _612;
  float _613;
  float _614;
  float _629;
  float _630;
  float _631;
  float _703;
  float _704;
  float _705;
  float _793;
  float _794;
  float _795;
  float _80;
  float _85;
  float _86;
  float _101;
  float _102;
  float _112;
  float _113;
  bool _114;
  float _124;
  float _125;
  float _136;
  float _137;
  float _142;
  float _143;
  float _153;
  float _155;
  bool _156;
  float4 _199;
  float _237;
  float _241;
  float _265;
  float4 _283;
  float _290;
  float _293;
  float _295;
  float _301;
  float _303;
  bool _304;
  float4 _346;
  bool _373;
  float4 _376;
  float4 _390;
  float _401;
  float _426;
  float _428;
  float _431;
  float _433;
  float _440;
  float _441;
  float _442;
  float _470;
  float _472;
  float _479;
  float _480;
  float _481;
  float _492;
  float _494;
  float _496;
  float _541;
  float _542;
  float _543;
  float _571;
  float _572;
  float _573;
  float _576;
  float _586;
  float _597;
  float _604;
  float _624;
  float _652;
  float _653;
  float _654;
  float4 _655;
  float _688;
  float4 _689;
  float _706;
  float _707;
  float _708;
  float _716;
  float _717;
  float _718;
  float _730;
  float _731;
  float _732;
  float _765;
  float _766;
  float _767;
  _44 = ((cb0_048x * TEXCOORD_3.x) + cb0_048z) * cb0_047z;
  _45 = ((cb0_048y * TEXCOORD_3.y) + cb0_048w) * cb0_047w;
  _46 = TEXCOORD_2.w * 543.3099975585938f;
  _50 = frac(sin(_46 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_096x > 0.0f) {
    _74 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _46) * 493013.0f) + 7.177000045776367f) - _50)) + _50);
    _75 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _46) * 493013.0f) + 14.298999786376953f) - _50)) + _50);
  } else {
    _74 = _50;
    _75 = _50;
  }
  _80 = cb0_095z * (1.0f - (_50 * _50));
  _85 = (_80 * (TEXCOORD_2.x - _44)) + _44;
  _86 = (_80 * (TEXCOORD_2.y - _45)) + _45;
  _101 = _85 - (((cb0_048x * TEXCOORD_3.x) + cb0_048z) * cb0_047z);
  _102 = _86 - (((cb0_048y * TEXCOORD_3.y) + cb0_048w) * cb0_047w);
  _112 = cb0_117z * cb0_116x;
  _113 = cb0_117z * cb0_116y;
  _114 = (cb0_117x == 0.0f);
  _124 = (cb0_113z * TEXCOORD_3.x) + cb0_113x;
  _125 = (cb0_113w * TEXCOORD_3.y) + cb0_113y;
  _136 = float((int)(((int)(uint)((bool)(_124 > 0.0f))) - ((int)(uint)((bool)(_124 < 0.0f)))));
  _137 = float((int)(((int)(uint)((bool)(_125 > 0.0f))) - ((int)(uint)((bool)(_125 < 0.0f)))));
  _142 = saturate(abs(_124) - cb0_116z);
  _143 = saturate(abs(_125) - cb0_116z);
  _153 = _125 - ((_143 * _112) * _137);
  _155 = _125 - ((_143 * _113) * _137);
  _156 = (cb0_117x > 0.0f);
  if (_156) {
    _163 = (_153 - (cb0_117w * 0.4000000059604645f));
    _164 = (_155 - (cb0_117w * 0.20000000298023224f));
  } else {
    _163 = _153;
    _164 = _155;
  }
  _199 = t0.Sample(s0, float2(min(max(_85, cb0_053x), cb0_053z), min(max(_86, cb0_053y), cb0_053w)));
  if (_156) {
    _237 = saturate(((((_199.y * 0.5870000123977661f) - cb0_117y) + (_199.x * 0.29899999499320984f)) + (_199.z * 0.11400000005960464f)) * 10.0f);
    _241 = (_237 * _237) * (3.0f - (_237 * 2.0f));
    _255 = ((((_199.x - (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_124 - ((_142 * select(_114, _112, cb0_116x)) * _136))) + cb0_114x)) + cb0_048z) * cb0_047z) + _101), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _163) + cb0_114y)) + cb0_048w) * cb0_047w) + _102), cb0_053y), cb0_053w))))).x)) + (_241 * ((((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_124 - ((_142 * select(_114, _112, cb0_116x)) * _136))) + cb0_114x)) + cb0_048z) * cb0_047z) + _101), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _163) + cb0_114y)) + cb0_048w) * cb0_047w) + _102), cb0_053y), cb0_053w))))).x) - _199.x))) * cb0_117x) + (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_124 - ((_142 * select(_114, _112, cb0_116x)) * _136))) + cb0_114x)) + cb0_048z) * cb0_047z) + _101), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _163) + cb0_114y)) + cb0_048w) * cb0_047w) + _102), cb0_053y), cb0_053w))))).x));
    _256 = ((((_199.y - (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_124 - ((_142 * select(_114, _113, cb0_116y)) * _136))) + cb0_114x)) + cb0_048z) * cb0_047z) + _101), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _164) + cb0_114y)) + cb0_048w) * cb0_047w) + _102), cb0_053y), cb0_053w))))).y)) + (_241 * ((((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_124 - ((_142 * select(_114, _113, cb0_116y)) * _136))) + cb0_114x)) + cb0_048z) * cb0_047z) + _101), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _164) + cb0_114y)) + cb0_048w) * cb0_047w) + _102), cb0_053y), cb0_053w))))).y) - _199.y))) * cb0_117x) + (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_124 - ((_142 * select(_114, _113, cb0_116y)) * _136))) + cb0_114x)) + cb0_048z) * cb0_047z) + _101), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _164) + cb0_114y)) + cb0_048w) * cb0_047w) + _102), cb0_053y), cb0_053w))))).y));
  } else {
    _255 = (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_124 - ((_142 * select(_114, _112, cb0_116x)) * _136))) + cb0_114x)) + cb0_048z) * cb0_047z) + _101), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _163) + cb0_114y)) + cb0_048w) * cb0_047w) + _102), cb0_053y), cb0_053w))))).x);
    _256 = (((float4)(t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_114z * (_124 - ((_142 * select(_114, _113, cb0_116y)) * _136))) + cb0_114x)) + cb0_048z) * cb0_047z) + _101), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_114w * _164) + cb0_114y)) + cb0_048w) * cb0_047w) + _102), cb0_053y), cb0_053w))))).y);
  }
  _265 = log2(max(dot(float3(_255, _256, _199.z), float3(cb0_042y, cb0_042z, cb0_042w)), cb0_041z));
  _283 = t5.Sample(s5, float3((cb0_046x * TEXCOORD_4.x), (cb0_046y * TEXCOORD_4.y), ((((cb0_041x * _265) + cb0_041y) * 0.96875f) + 0.015625f)));
  _290 = select((_283.y < 0.0010000000474974513f), (((float4)(t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x), (_283.x / _283.y));
  _293 = log2(TEXCOORD_1.x);
  _295 = (_290 + _293) + (((((float4)(t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x) - _290) * cb0_045y);
  _301 = _293 + _265;
  _303 = _295 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_045z);
  _304 = (_303 > 0.0f);
  if (_304) {
    _316 = max(0.0f, (_303 - cb0_046z));
  } else {
    _316 = min(0.0f, (cb0_046w + _303));
  }
  _346 = t1.Sample(s1, float2(min(max(((cb0_068x * _85) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _86) + cb0_068w), cb0_060y), cb0_060w)));
  APPLY_BLOOM(_346);
  [branch]
  if (!(cb0_085x == 0)) {
    _373 = (cb0_085z != 0);
    _376 = t2.Sample(s2, float2(select(_373, _85, min(max(((cb0_076x * _85) + cb0_076z), cb0_075x), cb0_075z)), select(_373, _86, min(max(((cb0_076y * _86) + cb0_076w), cb0_075y), cb0_075w))));
    _384 = (_376.x + _346.x);
    _385 = (_376.y + _346.y);
    _386 = (_376.z + _346.z);
  } else {
    _384 = _346.x;
    _385 = _346.y;
    _386 = _346.z;
  }
  [branch]
  if (!(cb0_085y == 0)) {
    _390 = t3.Sample(s3, float2(_85, _86));
    _398 = (_390.x + _384);
    _399 = (_390.y + _385);
    _400 = (_390.z + _386);
  } else {
    _398 = _384;
    _399 = _385;
    _400 = _386;
  }
  _401 = exp2((((_295 - _301) + ((_301 - _295) * cb0_045x)) - _316) + (_316 * select(_304, cb0_044z, cb0_044w))) * TEXCOORD_1.x;
  _426 = TEXCOORD_1.z + -1.0f;
  _428 = TEXCOORD_1.w + -1.0f;
  _431 = ((_426 + (cb0_090x * 2.0f)) * cb0_088z) * cb0_088x;
  _433 = ((_428 + (cb0_090y * 2.0f)) * cb0_088w) * cb0_088x;
  _440 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_431, _433), float2(_431, _433))) + 1.0f);
  _441 = _440 * _440;
  _442 = cb0_090z + 1.0f;
  _470 = ((_426 + (cb0_093x * 2.0f)) * cb0_091z) * cb0_091x;
  _472 = ((_428 + (cb0_093y * 2.0f)) * cb0_091w) * cb0_091x;
  _479 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_470, _472), float2(_470, _472))) + 1.0f);
  _480 = _479 * _479;
  _481 = cb0_093z + 1.0f;
  _492 = (((_441 * (_442 - cb0_089x)) + cb0_089x) * (_398 + ((_401 * _255) * cb0_086x))) * ((_480 * (_481 - cb0_092x)) + cb0_092x);
  _494 = (((_441 * (_442 - cb0_089y)) + cb0_089y) * (_399 + ((_401 * _256) * cb0_086y))) * ((_480 * (_481 - cb0_092y)) + cb0_092y);
  _496 = (((_441 * (_442 - cb0_089z)) + cb0_089z) * (_400 + ((_401 * _199.z) * cb0_086z))) * ((_480 * (_481 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_492, _494, _496));
  [branch]
  if (WUWA_TM_IS(1)) {
    _529 = ((((_492 * 1.3600000143051147f) + 0.04699999839067459f) * _492) / ((((_492 * 0.9599999785423279f) + 0.5600000023841858f) * _492) + 0.14000000059604645f));
    _530 = ((((_494 * 1.3600000143051147f) + 0.04699999839067459f) * _494) / ((((_494 * 0.9599999785423279f) + 0.5600000023841858f) * _494) + 0.14000000059604645f));
    _531 = ((((_496 * 1.3600000143051147f) + 0.04699999839067459f) * _496) / ((((_496 * 0.9599999785423279f) + 0.5600000023841858f) * _496) + 0.14000000059604645f));
  } else {
    _529 = _492;
    _530 = _494;
    _531 = _496;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _541 = 1.0049500465393066f - (0.16398000717163086f / (_529 + -0.19505000114440918f));
    _542 = 1.0049500465393066f - (0.16398000717163086f / (_530 + -0.19505000114440918f));
    _543 = 1.0049500465393066f - (0.16398000717163086f / (_531 + -0.19505000114440918f));
    _563 = ((_529 - _541) * select((_529 > 0.6000000238418579f), 0.0f, 1.0f)) + _541;
    _564 = ((_530 - _542) * select((_530 > 0.6000000238418579f), 0.0f, 1.0f)) + _542;
    _565 = ((_531 - _543) * select((_531 > 0.6000000238418579f), 0.0f, 1.0f)) + _543;
  } else {
    _563 = _529;
    _564 = _530;
    _565 = _531;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _571 = cb0_037y * _563;
    _572 = cb0_037y * _564;
    _573 = cb0_037y * _565;
    _576 = cb0_037z * cb0_037w;
    _586 = cb0_038y * cb0_038x;
    _597 = cb0_038z * cb0_038x;
    _604 = cb0_038y / cb0_038z;
    _612 = ((((_576 + _571) * _563) + _586) / (_597 + ((_571 + cb0_037z) * _563))) - _604;
    _613 = ((((_576 + _572) * _564) + _586) / (_597 + ((_572 + cb0_037z) * _564))) - _604;
    _614 = ((((_576 + _573) * _565) + _586) / (_597 + ((_573 + cb0_037z) * _565))) - _604;
  } else {
    _612 = _563;
    _613 = _564;
    _614 = _565;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _624 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _629 = (_624 * _612);
      _630 = (_624 * _613);
      _631 = (_624 * _614);
    } else {
      _629 = _612;
      _630 = _613;
      _631 = _614;
    }
  } else {
    _629 = _612;
    _630 = _613;
    _631 = _614;
  }
  APPLY_EXTENDED_TONEMAP(_629, _630, _631);
  _652 = (saturate((log2(_629 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _653 = (saturate((log2(_630 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _654 = (saturate((log2(_631 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _655 = t7.Sample(s7, float3(_652, _653, _654));
  [branch]
  if (!(cb0_107w == 0)) {
    _688 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _85) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _86) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _689 = t8.Sample(s8, float3(_652, _653, _654));
    _703 = (lerp(_689.x, _655.x, _688));
    _704 = (lerp(_689.y, _655.y, _688));
    _705 = (lerp(_689.z, _655.z, _688));
  } else {
    _703 = _655.x;
    _704 = _655.y;
    _705 = _655.z;
  }
  _706 = _705 * 1.0499999523162842f;
  _707 = _704 * 1.0499999523162842f;
  _708 = _703 * 1.0499999523162842f;
  _716 = ((_50 * 0.00390625f) + -0.001953125f) + _708;
  _717 = ((_74 * 0.00390625f) + -0.001953125f) + _707;
  _718 = ((_75 * 0.00390625f) + -0.001953125f) + _706;
  [branch]
  if (!(cb0_106w == 0)) {
    _730 = (pow(_716, 0.012683313339948654f));
    _731 = (pow(_717, 0.012683313339948654f));
    _732 = (pow(_718, 0.012683313339948654f));
    _765 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_730 + -0.8359375f)) / (18.8515625f - (_730 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _766 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_731 + -0.8359375f)) / (18.8515625f - (_731 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _767 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_732 + -0.8359375f)) / (18.8515625f - (_732 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _793 = min((_765 * 12.920000076293945f), ((exp2(log2(max(_765, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _794 = min((_766 * 12.920000076293945f), ((exp2(log2(max(_766, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _795 = min((_767 * 12.920000076293945f), ((exp2(log2(max(_767, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _793 = _716;
    _794 = _717;
    _795 = _718;
  }
  SV_Target.x = _793;
  SV_Target.y = _794;
  SV_Target.z = _795;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = (dot(float3(_708, _707, _706), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}