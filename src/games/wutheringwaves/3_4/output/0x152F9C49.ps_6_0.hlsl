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
  float _153;
  float _154;
  float _155;
  float _167;
  float _168;
  float _169;
  float _309;
  float _310;
  float _311;
  float _343;
  float _344;
  float _345;
  float _392;
  float _393;
  float _394;
  float _409;
  float _410;
  float _411;
  float _483;
  float _484;
  float _485;
  float _573;
  float _574;
  float _575;
  float _73;
  float _78;
  float _79;
  float4 _89;
  float4 _115;
  bool _142;
  float4 _145;
  float4 _159;
  float _194;
  float _196;
  float _199;
  float _201;
  float _208;
  float _209;
  float _210;
  float _238;
  float _240;
  float _247;
  float _248;
  float _249;
  float _270;
  float _273;
  float _276;
  float _321;
  float _322;
  float _323;
  float _351;
  float _352;
  float _353;
  float _356;
  float _366;
  float _377;
  float _384;
  float _404;
  float _432;
  float _433;
  float _434;
  float4 _435;
  float _468;
  float4 _469;
  float _486;
  float _487;
  float _488;
  float _496;
  float _497;
  float _498;
  float _510;
  float _511;
  float _512;
  float _545;
  float _546;
  float _547;
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
  _89 = t0.Sample(s0, float2(min(max(_78, cb0_053x), cb0_053z), min(max(_79, cb0_053y), cb0_053w)));
  _115 = t1.Sample(s1, float2(min(max(((cb0_068x * _78) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _79) + cb0_068w), cb0_060y), cb0_060w)));
  APPLY_BLOOM(_115);
  [branch]
  if (!(cb0_085x == 0)) {
    _142 = (cb0_085z != 0);
    _145 = t2.Sample(s2, float2(select(_142, _78, min(max(((cb0_076x * _78) + cb0_076z), cb0_075x), cb0_075z)), select(_142, _79, min(max(((cb0_076y * _79) + cb0_076w), cb0_075y), cb0_075w))));
    _153 = (_145.x + _115.x);
    _154 = (_145.y + _115.y);
    _155 = (_145.z + _115.z);
  } else {
    _153 = _115.x;
    _154 = _115.y;
    _155 = _115.z;
  }
  [branch]
  if (!(cb0_085y == 0)) {
    _159 = t3.Sample(s3, float2(_78, _79));
    _167 = (_159.x + _153);
    _168 = (_159.y + _154);
    _169 = (_159.z + _155);
  } else {
    _167 = _153;
    _168 = _154;
    _169 = _155;
  }
  _194 = TEXCOORD_1.z + -1.0f;
  _196 = TEXCOORD_1.w + -1.0f;
  _199 = ((_194 + (cb0_090x * 2.0f)) * cb0_088z) * cb0_088x;
  _201 = ((_196 + (cb0_090y * 2.0f)) * cb0_088w) * cb0_088x;
  _208 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_199, _201), float2(_199, _201))) + 1.0f);
  _209 = _208 * _208;
  _210 = cb0_090z + 1.0f;
  _238 = ((_194 + (cb0_093x * 2.0f)) * cb0_091z) * cb0_091x;
  _240 = ((_196 + (cb0_093y * 2.0f)) * cb0_091w) * cb0_091x;
  _247 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_238, _240), float2(_238, _240))) + 1.0f);
  _248 = _247 * _247;
  _249 = cb0_093z + 1.0f;
  _270 = ((((_209 * (_210 - cb0_089x)) + cb0_089x) * (_167 + ((_89.x * TEXCOORD_1.x) * cb0_086x))) * ((_248 * (_249 - cb0_092x)) + cb0_092x)) * ((cb0_095x * _43) + cb0_095y);
  _273 = ((((_209 * (_210 - cb0_089y)) + cb0_089y) * (_168 + ((_89.y * TEXCOORD_1.x) * cb0_086y))) * ((_248 * (_249 - cb0_092y)) + cb0_092y)) * ((cb0_095x * _67) + cb0_095y);
  _276 = ((((_209 * (_210 - cb0_089z)) + cb0_089z) * (_169 + ((_89.z * TEXCOORD_1.x) * cb0_086z))) * ((_248 * (_249 - cb0_092z)) + cb0_092z)) * ((cb0_095x * _68) + cb0_095y);
  CAPTURE_UNTONEMAPPED(float3(_270, _273, _276));
  [branch]
  if (WUWA_TM_IS(1)) {
    _309 = ((((_270 * 1.3600000143051147f) + 0.04699999839067459f) * _270) / ((((_270 * 0.9599999785423279f) + 0.5600000023841858f) * _270) + 0.14000000059604645f));
    _310 = ((((_273 * 1.3600000143051147f) + 0.04699999839067459f) * _273) / ((((_273 * 0.9599999785423279f) + 0.5600000023841858f) * _273) + 0.14000000059604645f));
    _311 = ((((_276 * 1.3600000143051147f) + 0.04699999839067459f) * _276) / ((((_276 * 0.9599999785423279f) + 0.5600000023841858f) * _276) + 0.14000000059604645f));
  } else {
    _309 = _270;
    _310 = _273;
    _311 = _276;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _321 = 1.0049500465393066f - (0.16398000717163086f / (_309 + -0.19505000114440918f));
    _322 = 1.0049500465393066f - (0.16398000717163086f / (_310 + -0.19505000114440918f));
    _323 = 1.0049500465393066f - (0.16398000717163086f / (_311 + -0.19505000114440918f));
    _343 = ((_309 - _321) * select((_309 > 0.6000000238418579f), 0.0f, 1.0f)) + _321;
    _344 = ((_310 - _322) * select((_310 > 0.6000000238418579f), 0.0f, 1.0f)) + _322;
    _345 = ((_311 - _323) * select((_311 > 0.6000000238418579f), 0.0f, 1.0f)) + _323;
  } else {
    _343 = _309;
    _344 = _310;
    _345 = _311;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _351 = cb0_037y * _343;
    _352 = cb0_037y * _344;
    _353 = cb0_037y * _345;
    _356 = cb0_037z * cb0_037w;
    _366 = cb0_038y * cb0_038x;
    _377 = cb0_038z * cb0_038x;
    _384 = cb0_038y / cb0_038z;
    _392 = ((((_356 + _351) * _343) + _366) / (_377 + ((_351 + cb0_037z) * _343))) - _384;
    _393 = ((((_356 + _352) * _344) + _366) / (_377 + ((_352 + cb0_037z) * _344))) - _384;
    _394 = ((((_356 + _353) * _345) + _366) / (_377 + ((_353 + cb0_037z) * _345))) - _384;
  } else {
    _392 = _343;
    _393 = _344;
    _394 = _345;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _404 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _409 = (_404 * _392);
      _410 = (_404 * _393);
      _411 = (_404 * _394);
    } else {
      _409 = _392;
      _410 = _393;
      _411 = _394;
    }
  } else {
    _409 = _392;
    _410 = _393;
    _411 = _394;
  }
  APPLY_EXTENDED_TONEMAP(_409, _410, _411);
  _432 = (saturate((log2(_409 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _433 = (saturate((log2(_410 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _434 = (saturate((log2(_411 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _435 = t5.Sample(s5, float3(_432, _433, _434));
  [branch]
  if (!(cb0_107w == 0)) {
    _468 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _78) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _79) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _469 = t6.Sample(s6, float3(_432, _433, _434));
    _483 = (lerp(_469.x, _435.x, _468));
    _484 = (lerp(_469.y, _435.y, _468));
    _485 = (lerp(_469.z, _435.z, _468));
  } else {
    _483 = _435.x;
    _484 = _435.y;
    _485 = _435.z;
  }
  _486 = _485 * 1.0499999523162842f;
  _487 = _484 * 1.0499999523162842f;
  _488 = _483 * 1.0499999523162842f;
  _496 = ((_43 * 0.00390625f) + -0.001953125f) + _488;
  _497 = ((_67 * 0.00390625f) + -0.001953125f) + _487;
  _498 = ((_68 * 0.00390625f) + -0.001953125f) + _486;
  [branch]
  if (!(cb0_106w == 0)) {
    _510 = (pow(_496, 0.012683313339948654f));
    _511 = (pow(_497, 0.012683313339948654f));
    _512 = (pow(_498, 0.012683313339948654f));
    _545 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_510 + -0.8359375f)) / (18.8515625f - (_510 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _546 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_511 + -0.8359375f)) / (18.8515625f - (_511 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _547 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_512 + -0.8359375f)) / (18.8515625f - (_512 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _573 = min((_545 * 12.920000076293945f), ((exp2(log2(max(_545, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _574 = min((_546 * 12.920000076293945f), ((exp2(log2(max(_546, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _575 = min((_547 * 12.920000076293945f), ((exp2(log2(max(_547, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _573 = _496;
    _574 = _497;
    _575 = _498;
  }
  SV_Target.x = _573;
  SV_Target.y = _574;
  SV_Target.z = _575;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = (dot(float3(_488, _487, _486), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}