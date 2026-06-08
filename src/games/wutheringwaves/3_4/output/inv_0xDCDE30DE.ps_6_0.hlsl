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
  float cb0_108x : packoffset(c108.x);
  float cb0_108y : packoffset(c108.y);
  float cb0_108z : packoffset(c108.z);
  float cb0_109x : packoffset(c109.x);
  float cb0_109y : packoffset(c109.y);
  float cb0_109z : packoffset(c109.z);
  float cb0_110x : packoffset(c110.x);
  float cb0_110y : packoffset(c110.y);
  float cb0_110z : packoffset(c110.z);
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
  float _297;
  float _298;
  float _299;
  float _331;
  float _332;
  float _333;
  float _380;
  float _381;
  float _382;
  float _397;
  float _398;
  float _399;
  float _471;
  float _472;
  float _473;
  float _561;
  float _562;
  float _563;
  float _612;
  float _613;
  float _614;
  float _615;
  float _616;
  float _617;
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
  float _260;
  float _262;
  float _264;
  float _309;
  float _310;
  float _311;
  float _339;
  float _340;
  float _341;
  float _344;
  float _354;
  float _365;
  float _372;
  float _392;
  float _420;
  float _421;
  float _422;
  float4 _423;
  float _456;
  float4 _457;
  float _474;
  float _475;
  float _476;
  float _484;
  float _485;
  float _486;
  float _498;
  float _499;
  float _500;
  float _533;
  float _534;
  float _535;
  float _572;
  float _579;
  float _586;
  float _587;
  float _588;
  float _593;
  float _594;
  float _595;
  float _604;
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
  _260 = (((_209 * (_210 - cb0_089x)) + cb0_089x) * (_167 + ((_89.x * TEXCOORD_1.x) * cb0_086x))) * ((_248 * (_249 - cb0_092x)) + cb0_092x);
  _262 = (((_209 * (_210 - cb0_089y)) + cb0_089y) * (_168 + ((_89.y * TEXCOORD_1.x) * cb0_086y))) * ((_248 * (_249 - cb0_092y)) + cb0_092y);
  _264 = (((_209 * (_210 - cb0_089z)) + cb0_089z) * (_169 + ((_89.z * TEXCOORD_1.x) * cb0_086z))) * ((_248 * (_249 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_260, _262, _264));
  [branch]
  if (WUWA_TM_IS(1)) {
    _297 = ((((_260 * 1.3600000143051147f) + 0.04699999839067459f) * _260) / ((((_260 * 0.9599999785423279f) + 0.5600000023841858f) * _260) + 0.14000000059604645f));
    _298 = ((((_262 * 1.3600000143051147f) + 0.04699999839067459f) * _262) / ((((_262 * 0.9599999785423279f) + 0.5600000023841858f) * _262) + 0.14000000059604645f));
    _299 = ((((_264 * 1.3600000143051147f) + 0.04699999839067459f) * _264) / ((((_264 * 0.9599999785423279f) + 0.5600000023841858f) * _264) + 0.14000000059604645f));
  } else {
    _297 = _260;
    _298 = _262;
    _299 = _264;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _309 = 1.0049500465393066f - (0.16398000717163086f / (_297 + -0.19505000114440918f));
    _310 = 1.0049500465393066f - (0.16398000717163086f / (_298 + -0.19505000114440918f));
    _311 = 1.0049500465393066f - (0.16398000717163086f / (_299 + -0.19505000114440918f));
    _331 = ((_297 - _309) * select((_297 > 0.6000000238418579f), 0.0f, 1.0f)) + _309;
    _332 = ((_298 - _310) * select((_298 > 0.6000000238418579f), 0.0f, 1.0f)) + _310;
    _333 = ((_299 - _311) * select((_299 > 0.6000000238418579f), 0.0f, 1.0f)) + _311;
  } else {
    _331 = _297;
    _332 = _298;
    _333 = _299;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _339 = cb0_037y * _331;
    _340 = cb0_037y * _332;
    _341 = cb0_037y * _333;
    _344 = cb0_037z * cb0_037w;
    _354 = cb0_038y * cb0_038x;
    _365 = cb0_038z * cb0_038x;
    _372 = cb0_038y / cb0_038z;
    _380 = ((((_344 + _339) * _331) + _354) / (_365 + ((_339 + cb0_037z) * _331))) - _372;
    _381 = ((((_344 + _340) * _332) + _354) / (_365 + ((_340 + cb0_037z) * _332))) - _372;
    _382 = ((((_344 + _341) * _333) + _354) / (_365 + ((_341 + cb0_037z) * _333))) - _372;
  } else {
    _380 = _331;
    _381 = _332;
    _382 = _333;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _392 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _397 = (_392 * _380);
      _398 = (_392 * _381);
      _399 = (_392 * _382);
    } else {
      _397 = _380;
      _398 = _381;
      _399 = _382;
    }
  } else {
    _397 = _380;
    _398 = _381;
    _399 = _382;
  }
  APPLY_EXTENDED_TONEMAP(_397, _398, _399);
  _420 = (saturate((log2(_397 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _421 = (saturate((log2(_398 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _422 = (saturate((log2(_399 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _423 = t5.Sample(s5, float3(_420, _421, _422));
  [branch]
  if (!(cb0_107w == 0)) {
    _456 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _78) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _79) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _457 = t6.Sample(s6, float3(_420, _421, _422));
    _471 = (lerp(_457.x, _423.x, _456));
    _472 = (lerp(_457.y, _423.y, _456));
    _473 = (lerp(_457.z, _423.z, _456));
  } else {
    _471 = _423.x;
    _472 = _423.y;
    _473 = _423.z;
  }
  _474 = _473 * 1.0499999523162842f;
  _475 = _472 * 1.0499999523162842f;
  _476 = _471 * 1.0499999523162842f;
  _484 = ((_43 * 0.00390625f) + -0.001953125f) + _476;
  _485 = ((_67 * 0.00390625f) + -0.001953125f) + _475;
  _486 = ((_68 * 0.00390625f) + -0.001953125f) + _474;
  [branch]
  if (!(cb0_106w == 0)) {
    _498 = (pow(_484, 0.012683313339948654f));
    _499 = (pow(_485, 0.012683313339948654f));
    _500 = (pow(_486, 0.012683313339948654f));
    _533 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_498 + -0.8359375f)) / (18.8515625f - (_498 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _534 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_499 + -0.8359375f)) / (18.8515625f - (_499 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _535 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_500 + -0.8359375f)) / (18.8515625f - (_500 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _561 = min((_533 * 12.920000076293945f), ((exp2(log2(max(_533, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _562 = min((_534 * 12.920000076293945f), ((exp2(log2(max(_534, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _563 = min((_535 * 12.920000076293945f), ((exp2(log2(max(_535, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _561 = _484;
    _562 = _485;
    _563 = _486;
  }
  GENERATE_INVERSION(_561, _562, _563);
  _572 = ((((_562 * 587.0f) + (_561 * 299.0f)) + (_563 * 114.0f)) * 0.0010000000474974513f) - cb0_108z;
  _579 = saturate(float((int)(((int)(uint)((bool)(_572 > 0.0f))) - ((int)(uint)((bool)(_572 < 0.0f))))));
  _586 = cb0_109x - _561;
  _587 = cb0_109y - _562;
  _588 = cb0_109z - _563;
  _593 = WUWA_PEAK_SCALING * cb0_110x - _561;
  _594 = WUWA_PEAK_SCALING * cb0_110y - _562;
  _595 = WUWA_PEAK_SCALING * cb0_110z - _563;
  [branch]
  if (cb0_108y > 0.0f) {
    _612 = (_586 * cb0_108y);
    _613 = (_587 * cb0_108y);
    _614 = (_588 * cb0_108y);
    _615 = (_593 * cb0_108y);
    _616 = (_594 * cb0_108y);
    _617 = (_595 * cb0_108y);
  } else {
    _604 = abs(cb0_108y);
    _612 = (_593 * _604);
    _613 = (_594 * _604);
    _614 = (_595 * _604);
    _615 = (_586 * _604);
    _616 = (_587 * _604);
    _617 = (_588 * _604);
  }
  SV_Target.x = ((cb0_108x * (lerp(_612, _615, _579))) + _561);
  SV_Target.y = ((cb0_108x * (lerp(_613, _616, _579))) + _562);
  SV_Target.z = (((lerp(_614, _617, _579)) * cb0_108x) + _563);
  SV_Target.rgb = wuwa::ApplyDisplayMap(SV_Target.rgb);
  SV_Target.w = (dot(float3(_476, _475, _474), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}