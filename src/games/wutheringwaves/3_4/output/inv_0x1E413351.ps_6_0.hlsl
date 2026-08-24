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
  float cb0_108x : packoffset(c108.x);
  float cb0_108y : packoffset(c108.y);
  float cb0_108z : packoffset(c108.z);
  float cb0_109x : packoffset(c109.x);
  float cb0_109y : packoffset(c109.y);
  float cb0_109z : packoffset(c109.z);
  float cb0_110x : packoffset(c110.x);
  float cb0_110y : packoffset(c110.y);
  float cb0_110z : packoffset(c110.z);
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
  float _35;
  float _36;
  float _37;
  float _41;
  float _65;
  float _66;
  float _127;
  float _128;
  float _196;
  float _197;
  float _258;
  float _259;
  float _260;
  float _272;
  float _273;
  float _274;
  float _402;
  float _403;
  float _404;
  float _436;
  float _437;
  float _438;
  float _485;
  float _486;
  float _487;
  float _502;
  float _503;
  float _504;
  float _576;
  float _577;
  float _578;
  float _666;
  float _667;
  float _668;
  float _717;
  float _718;
  float _719;
  float _720;
  float _721;
  float _722;
  float _76;
  float _77;
  bool _78;
  float _88;
  float _89;
  float _100;
  float _101;
  float _106;
  float _107;
  float _117;
  float _119;
  bool _120;
  float4 _162;
  float _178;
  float _182;
  float4 _220;
  bool _247;
  float4 _250;
  float4 _264;
  float _299;
  float _301;
  float _304;
  float _306;
  float _313;
  float _314;
  float _315;
  float _343;
  float _345;
  float _352;
  float _353;
  float _354;
  float _365;
  float _367;
  float _369;
  float _414;
  float _415;
  float _416;
  float _444;
  float _445;
  float _446;
  float _449;
  float _459;
  float _470;
  float _477;
  float _497;
  float _525;
  float _526;
  float _527;
  float4 _528;
  float _561;
  float4 _562;
  float _579;
  float _580;
  float _581;
  float _589;
  float _590;
  float _591;
  float _603;
  float _604;
  float _605;
  float _638;
  float _639;
  float _640;
  float _677;
  float _684;
  float _691;
  float _692;
  float _693;
  float _698;
  float _699;
  float _700;
  float _709;
  _35 = ((cb0_048x * TEXCOORD_3.x) + cb0_048z) * cb0_047z;
  _36 = ((cb0_048y * TEXCOORD_3.y) + cb0_048w) * cb0_047w;
  _37 = TEXCOORD_2.w * 543.3099975585938f;
  _41 = frac(sin(_37 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_096x > 0.0f) {
    _65 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _37) * 493013.0f) + 7.177000045776367f) - _41)) + _41);
    _66 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _37) * 493013.0f) + 14.298999786376953f) - _41)) + _41);
  } else {
    _65 = _41;
    _66 = _41;
  }
  _76 = cb0_117z * cb0_116x;
  _77 = cb0_117z * cb0_116y;
  _78 = (cb0_117x == 0.0f);
  _88 = (cb0_113z * TEXCOORD_3.x) + cb0_113x;
  _89 = (cb0_113w * TEXCOORD_3.y) + cb0_113y;
  _100 = float((int)(((int)(uint)((bool)(_88 > 0.0f))) - ((int)(uint)((bool)(_88 < 0.0f)))));
  _101 = float((int)(((int)(uint)((bool)(_89 > 0.0f))) - ((int)(uint)((bool)(_89 < 0.0f)))));
  _106 = saturate(abs(_88) - cb0_116z);
  _107 = saturate(abs(_89) - cb0_116z);
  _117 = _89 - ((_107 * _76) * _101);
  _119 = _89 - ((_107 * _77) * _101);
  _120 = (cb0_117x > 0.0f);
  if (_120) {
    _127 = (_117 - (cb0_117w * 0.4000000059604645f));
    _128 = (_119 - (cb0_117w * 0.20000000298023224f));
  } else {
    _127 = _117;
    _128 = _119;
  }
  _162 = t0.Sample(s0, float2(_35, _36));
  if (_120) {
    _178 = saturate(((((_162.y * 0.5870000123977661f) - cb0_117y) + (_162.x * 0.29899999499320984f)) + (_162.z * 0.11400000005960464f)) * 10.0f);
    _182 = (_178 * _178) * (3.0f - (_178 * 2.0f));
    _196 = ((((_162.x - (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_88 - ((_106 * select(_78, _76, cb0_116x)) * _100))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _127) + cb0_114y)) + cb0_048w) * cb0_047w))))).x)) + (_182 * ((((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_88 - ((_106 * select(_78, _76, cb0_116x)) * _100))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _127) + cb0_114y)) + cb0_048w) * cb0_047w))))).x) - _162.x))) * cb0_117x) + (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_88 - ((_106 * select(_78, _76, cb0_116x)) * _100))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _127) + cb0_114y)) + cb0_048w) * cb0_047w))))).x));
    _197 = ((((_162.y - (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_88 - ((_106 * select(_78, _77, cb0_116y)) * _100))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _128) + cb0_114y)) + cb0_048w) * cb0_047w))))).y)) + (_182 * ((((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_88 - ((_106 * select(_78, _77, cb0_116y)) * _100))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _128) + cb0_114y)) + cb0_048w) * cb0_047w))))).y) - _162.y))) * cb0_117x) + (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_88 - ((_106 * select(_78, _77, cb0_116y)) * _100))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _128) + cb0_114y)) + cb0_048w) * cb0_047w))))).y));
  } else {
    _196 = (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_88 - ((_106 * select(_78, _76, cb0_116x)) * _100))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _127) + cb0_114y)) + cb0_048w) * cb0_047w))))).x);
    _197 = (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_88 - ((_106 * select(_78, _77, cb0_116y)) * _100))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _128) + cb0_114y)) + cb0_048w) * cb0_047w))))).y);
  }
  _220 = t1.Sample(s1, float2(min(max(((cb0_068x * _35) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _36) + cb0_068w), cb0_060y), cb0_060w)));
  APPLY_BLOOM(_220);
  [branch]
  if (!(cb0_085x == 0)) {
    _247 = (cb0_085z != 0);
    _250 = t2.Sample(s2, float2(select(_247, _35, min(max(((cb0_076x * _35) + cb0_076z), cb0_075x), cb0_075z)), select(_247, _36, min(max(((cb0_076y * _36) + cb0_076w), cb0_075y), cb0_075w))));
    _258 = (_250.x + _220.x);
    _259 = (_250.y + _220.y);
    _260 = (_250.z + _220.z);
  } else {
    _258 = _220.x;
    _259 = _220.y;
    _260 = _220.z;
  }
  [branch]
  if (!(cb0_085y == 0)) {
    _264 = t3.Sample(s3, float2(_35, _36));
    _272 = (_264.x + _258);
    _273 = (_264.y + _259);
    _274 = (_264.z + _260);
  } else {
    _272 = _258;
    _273 = _259;
    _274 = _260;
  }
  _299 = TEXCOORD_1.z + -1.0f;
  _301 = TEXCOORD_1.w + -1.0f;
  _304 = ((_299 + (cb0_090x * 2.0f)) * cb0_088z) * cb0_088x;
  _306 = ((_301 + (cb0_090y * 2.0f)) * cb0_088w) * cb0_088x;
  _313 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_304, _306), float2(_304, _306))) + 1.0f);
  _314 = _313 * _313;
  _315 = cb0_090z + 1.0f;
  _343 = ((_299 + (cb0_093x * 2.0f)) * cb0_091z) * cb0_091x;
  _345 = ((_301 + (cb0_093y * 2.0f)) * cb0_091w) * cb0_091x;
  _352 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_343, _345), float2(_343, _345))) + 1.0f);
  _353 = _352 * _352;
  _354 = cb0_093z + 1.0f;
  _365 = (((_314 * (_315 - cb0_089x)) + cb0_089x) * (_272 + ((_196 * TEXCOORD_1.x) * cb0_086x))) * ((_353 * (_354 - cb0_092x)) + cb0_092x);
  _367 = (((_314 * (_315 - cb0_089y)) + cb0_089y) * (_273 + ((_197 * TEXCOORD_1.x) * cb0_086y))) * ((_353 * (_354 - cb0_092y)) + cb0_092y);
  _369 = (((_314 * (_315 - cb0_089z)) + cb0_089z) * (_274 + ((_162.z * TEXCOORD_1.x) * cb0_086z))) * ((_353 * (_354 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_365, _367, _369));
  [branch]
  if (WUWA_TM_IS(1)) {
    _402 = ((((_365 * 1.3600000143051147f) + 0.04699999839067459f) * _365) / ((((_365 * 0.9599999785423279f) + 0.5600000023841858f) * _365) + 0.14000000059604645f));
    _403 = ((((_367 * 1.3600000143051147f) + 0.04699999839067459f) * _367) / ((((_367 * 0.9599999785423279f) + 0.5600000023841858f) * _367) + 0.14000000059604645f));
    _404 = ((((_369 * 1.3600000143051147f) + 0.04699999839067459f) * _369) / ((((_369 * 0.9599999785423279f) + 0.5600000023841858f) * _369) + 0.14000000059604645f));
  } else {
    _402 = _365;
    _403 = _367;
    _404 = _369;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _414 = 1.0049500465393066f - (0.16398000717163086f / (_402 + -0.19505000114440918f));
    _415 = 1.0049500465393066f - (0.16398000717163086f / (_403 + -0.19505000114440918f));
    _416 = 1.0049500465393066f - (0.16398000717163086f / (_404 + -0.19505000114440918f));
    _436 = ((_402 - _414) * select((_402 > 0.6000000238418579f), 0.0f, 1.0f)) + _414;
    _437 = ((_403 - _415) * select((_403 > 0.6000000238418579f), 0.0f, 1.0f)) + _415;
    _438 = ((_404 - _416) * select((_404 > 0.6000000238418579f), 0.0f, 1.0f)) + _416;
  } else {
    _436 = _402;
    _437 = _403;
    _438 = _404;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _444 = cb0_037y * _436;
    _445 = cb0_037y * _437;
    _446 = cb0_037y * _438;
    _449 = cb0_037z * cb0_037w;
    _459 = cb0_038y * cb0_038x;
    _470 = cb0_038z * cb0_038x;
    _477 = cb0_038y / cb0_038z;
    _485 = ((((_449 + _444) * _436) + _459) / (_470 + ((_444 + cb0_037z) * _436))) - _477;
    _486 = ((((_449 + _445) * _437) + _459) / (_470 + ((_445 + cb0_037z) * _437))) - _477;
    _487 = ((((_449 + _446) * _438) + _459) / (_470 + ((_446 + cb0_037z) * _438))) - _477;
  } else {
    _485 = _436;
    _486 = _437;
    _487 = _438;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _497 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _502 = (_497 * _485);
      _503 = (_497 * _486);
      _504 = (_497 * _487);
    } else {
      _502 = _485;
      _503 = _486;
      _504 = _487;
    }
  } else {
    _502 = _485;
    _503 = _486;
    _504 = _487;
  }
  APPLY_EXTENDED_TONEMAP(_502, _503, _504);
  _525 = (saturate((log2(_502 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _526 = (saturate((log2(_503 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _527 = (saturate((log2(_504 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _528 = t5.Sample(s5, float3(_525, _526, _527));
  [branch]
  if (!(cb0_107w == 0)) {
    _561 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _35) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _36) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _562 = t6.Sample(s6, float3(_525, _526, _527));
    _576 = (lerp(_562.x, _528.x, _561));
    _577 = (lerp(_562.y, _528.y, _561));
    _578 = (lerp(_562.z, _528.z, _561));
  } else {
    _576 = _528.x;
    _577 = _528.y;
    _578 = _528.z;
  }
  _579 = _578 * 1.0499999523162842f;
  _580 = _577 * 1.0499999523162842f;
  _581 = _576 * 1.0499999523162842f;
  _589 = ((_41 * 0.00390625f) + -0.001953125f) + _581;
  _590 = ((_65 * 0.00390625f) + -0.001953125f) + _580;
  _591 = ((_66 * 0.00390625f) + -0.001953125f) + _579;
  [branch]
  if (!(cb0_106w == 0)) {
    _603 = (pow(_589, 0.012683313339948654f));
    _604 = (pow(_590, 0.012683313339948654f));
    _605 = (pow(_591, 0.012683313339948654f));
    _638 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_603 + -0.8359375f)) / (18.8515625f - (_603 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _639 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_604 + -0.8359375f)) / (18.8515625f - (_604 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _640 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_605 + -0.8359375f)) / (18.8515625f - (_605 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _666 = min((_638 * 12.920000076293945f), ((exp2(log2(max(_638, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _667 = min((_639 * 12.920000076293945f), ((exp2(log2(max(_639, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _668 = min((_640 * 12.920000076293945f), ((exp2(log2(max(_640, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _666 = _589;
    _667 = _590;
    _668 = _591;
  }
  GENERATE_INVERSION(_666, _667, _668);
  _677 = ((((_667 * 587.0f) + (_666 * 299.0f)) + (_668 * 114.0f)) * 0.0010000000474974513f) - cb0_108z;
  _684 = saturate(float((int)(((int)(uint)((bool)(_677 > 0.0f))) - ((int)(uint)((bool)(_677 < 0.0f))))));
  _691 = cb0_109x - _666;
  _692 = cb0_109y - _667;
  _693 = cb0_109z - _668;
  _698 = WUWA_PEAK_SCALING * cb0_110x - _666;
  _699 = WUWA_PEAK_SCALING * cb0_110y - _667;
  _700 = WUWA_PEAK_SCALING * cb0_110z - _668;
  [branch]
  if (cb0_108y > 0.0f) {
    _717 = (_691 * cb0_108y);
    _718 = (_692 * cb0_108y);
    _719 = (_693 * cb0_108y);
    _720 = (_698 * cb0_108y);
    _721 = (_699 * cb0_108y);
    _722 = (_700 * cb0_108y);
  } else {
    _709 = abs(cb0_108y);
    _717 = (_698 * _709);
    _718 = (_699 * _709);
    _719 = (_700 * _709);
    _720 = (_691 * _709);
    _721 = (_692 * _709);
    _722 = (_693 * _709);
  }
  SV_Target.x = ((cb0_108x * (lerp(_717, _720, _684))) + _666);
  SV_Target.y = ((cb0_108x * (lerp(_718, _721, _684))) + _667);
  SV_Target.z = (((lerp(_719, _722, _684)) * cb0_108x) + _668);
  SV_Target.rgb = wuwa::ApplyDisplayMap(SV_Target.rgb);
  SV_Target.w = (dot(float3(_581, _580, _579), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}