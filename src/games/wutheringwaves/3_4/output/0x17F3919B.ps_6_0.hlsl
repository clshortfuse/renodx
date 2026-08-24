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
  float _137;
  float _205;
  float _206;
  float _207;
  float _219;
  float _220;
  float _221;
  float _350;
  float _351;
  float _352;
  float _384;
  float _385;
  float _386;
  float _433;
  float _434;
  float _435;
  float _450;
  float _451;
  float _452;
  float _524;
  float _525;
  float _526;
  float _614;
  float _615;
  float _616;
  float4 _74;
  float _86;
  float4 _104;
  float _111;
  float _114;
  float _116;
  float _122;
  float _124;
  bool _125;
  float4 _167;
  bool _194;
  float4 _197;
  float4 _211;
  float _222;
  float _247;
  float _249;
  float _252;
  float _254;
  float _261;
  float _262;
  float _263;
  float _291;
  float _293;
  float _300;
  float _301;
  float _302;
  float _313;
  float _315;
  float _317;
  float _362;
  float _363;
  float _364;
  float _392;
  float _393;
  float _394;
  float _397;
  float _407;
  float _418;
  float _425;
  float _445;
  float _473;
  float _474;
  float _475;
  float4 _476;
  float _509;
  float4 _510;
  float _527;
  float _528;
  float _529;
  float _537;
  float _538;
  float _539;
  float _551;
  float _552;
  float _553;
  float _586;
  float _587;
  float _588;
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
  _74 = t0.Sample(s0, float2(_42, _43));
  _86 = log2(max(dot(float3(_74.x, _74.y, _74.z), float3(cb0_042y, cb0_042z, cb0_042w)), cb0_041z));
  _104 = t5.Sample(s5, float3((cb0_046x * TEXCOORD_4.x), (cb0_046y * TEXCOORD_4.y), ((((cb0_041x * _86) + cb0_041y) * 0.96875f) + 0.015625f)));
  _111 = select((_104.y < 0.0010000000474974513f), (((float4)(t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x), (_104.x / _104.y));
  _114 = log2(TEXCOORD_1.x);
  _116 = (_111 + _114) + (((((float4)(t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x) - _111) * cb0_045y);
  _122 = _114 + _86;
  _124 = _116 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_045z);
  _125 = (_124 > 0.0f);
  if (_125) {
    _137 = max(0.0f, (_124 - cb0_046z));
  } else {
    _137 = min(0.0f, (cb0_046w + _124));
  }
  _167 = t1.Sample(s1, float2(min(max(((cb0_068x * _42) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _43) + cb0_068w), cb0_060y), cb0_060w)));
  APPLY_BLOOM(_167);
  [branch]
  if (!(cb0_085x == 0)) {
    _194 = (cb0_085z != 0);
    _197 = t2.Sample(s2, float2(select(_194, _42, min(max(((cb0_076x * _42) + cb0_076z), cb0_075x), cb0_075z)), select(_194, _43, min(max(((cb0_076y * _43) + cb0_076w), cb0_075y), cb0_075w))));
    _205 = (_197.x + _167.x);
    _206 = (_197.y + _167.y);
    _207 = (_197.z + _167.z);
  } else {
    _205 = _167.x;
    _206 = _167.y;
    _207 = _167.z;
  }
  [branch]
  if (!(cb0_085y == 0)) {
    _211 = t3.Sample(s3, float2(_42, _43));
    _219 = (_211.x + _205);
    _220 = (_211.y + _206);
    _221 = (_211.z + _207);
  } else {
    _219 = _205;
    _220 = _206;
    _221 = _207;
  }
  _222 = exp2((((_116 - _122) + ((_122 - _116) * cb0_045x)) - _137) + (_137 * select(_125, cb0_044z, cb0_044w))) * TEXCOORD_1.x;
  _247 = TEXCOORD_1.z + -1.0f;
  _249 = TEXCOORD_1.w + -1.0f;
  _252 = ((_247 + (cb0_090x * 2.0f)) * cb0_088z) * cb0_088x;
  _254 = ((_249 + (cb0_090y * 2.0f)) * cb0_088w) * cb0_088x;
  _261 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_252, _254), float2(_252, _254))) + 1.0f);
  _262 = _261 * _261;
  _263 = cb0_090z + 1.0f;
  _291 = ((_247 + (cb0_093x * 2.0f)) * cb0_091z) * cb0_091x;
  _293 = ((_249 + (cb0_093y * 2.0f)) * cb0_091w) * cb0_091x;
  _300 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_291, _293), float2(_291, _293))) + 1.0f);
  _301 = _300 * _300;
  _302 = cb0_093z + 1.0f;
  _313 = (((_262 * (_263 - cb0_089x)) + cb0_089x) * (_219 + ((_222 * _74.x) * cb0_086x))) * ((_301 * (_302 - cb0_092x)) + cb0_092x);
  _315 = (((_262 * (_263 - cb0_089y)) + cb0_089y) * (_220 + ((_222 * _74.y) * cb0_086y))) * ((_301 * (_302 - cb0_092y)) + cb0_092y);
  _317 = (((_262 * (_263 - cb0_089z)) + cb0_089z) * (_221 + ((_222 * _74.z) * cb0_086z))) * ((_301 * (_302 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_313, _315, _317));
  [branch]
  if (WUWA_TM_IS(1)) {
    _350 = ((((_313 * 1.3600000143051147f) + 0.04699999839067459f) * _313) / ((((_313 * 0.9599999785423279f) + 0.5600000023841858f) * _313) + 0.14000000059604645f));
    _351 = ((((_315 * 1.3600000143051147f) + 0.04699999839067459f) * _315) / ((((_315 * 0.9599999785423279f) + 0.5600000023841858f) * _315) + 0.14000000059604645f));
    _352 = ((((_317 * 1.3600000143051147f) + 0.04699999839067459f) * _317) / ((((_317 * 0.9599999785423279f) + 0.5600000023841858f) * _317) + 0.14000000059604645f));
  } else {
    _350 = _313;
    _351 = _315;
    _352 = _317;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _362 = 1.0049500465393066f - (0.16398000717163086f / (_350 + -0.19505000114440918f));
    _363 = 1.0049500465393066f - (0.16398000717163086f / (_351 + -0.19505000114440918f));
    _364 = 1.0049500465393066f - (0.16398000717163086f / (_352 + -0.19505000114440918f));
    _384 = ((_350 - _362) * select((_350 > 0.6000000238418579f), 0.0f, 1.0f)) + _362;
    _385 = ((_351 - _363) * select((_351 > 0.6000000238418579f), 0.0f, 1.0f)) + _363;
    _386 = ((_352 - _364) * select((_352 > 0.6000000238418579f), 0.0f, 1.0f)) + _364;
  } else {
    _384 = _350;
    _385 = _351;
    _386 = _352;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _392 = cb0_037y * _384;
    _393 = cb0_037y * _385;
    _394 = cb0_037y * _386;
    _397 = cb0_037z * cb0_037w;
    _407 = cb0_038y * cb0_038x;
    _418 = cb0_038z * cb0_038x;
    _425 = cb0_038y / cb0_038z;
    _433 = ((((_397 + _392) * _384) + _407) / (_418 + ((_392 + cb0_037z) * _384))) - _425;
    _434 = ((((_397 + _393) * _385) + _407) / (_418 + ((_393 + cb0_037z) * _385))) - _425;
    _435 = ((((_397 + _394) * _386) + _407) / (_418 + ((_394 + cb0_037z) * _386))) - _425;
  } else {
    _433 = _384;
    _434 = _385;
    _435 = _386;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _445 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _450 = (_445 * _433);
      _451 = (_445 * _434);
      _452 = (_445 * _435);
    } else {
      _450 = _433;
      _451 = _434;
      _452 = _435;
    }
  } else {
    _450 = _433;
    _451 = _434;
    _452 = _435;
  }
  APPLY_EXTENDED_TONEMAP(_450, _451, _452);
  _473 = (saturate((log2(_450 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _474 = (saturate((log2(_451 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _475 = (saturate((log2(_452 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _476 = t7.Sample(s7, float3(_473, _474, _475));
  [branch]
  if (!(cb0_107w == 0)) {
    _509 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _42) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _43) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _510 = t8.Sample(s8, float3(_473, _474, _475));
    _524 = (lerp(_510.x, _476.x, _509));
    _525 = (lerp(_510.y, _476.y, _509));
    _526 = (lerp(_510.z, _476.z, _509));
  } else {
    _524 = _476.x;
    _525 = _476.y;
    _526 = _476.z;
  }
  _527 = _526 * 1.0499999523162842f;
  _528 = _525 * 1.0499999523162842f;
  _529 = _524 * 1.0499999523162842f;
  _537 = ((_48 * 0.00390625f) + -0.001953125f) + _529;
  _538 = ((_72 * 0.00390625f) + -0.001953125f) + _528;
  _539 = ((_73 * 0.00390625f) + -0.001953125f) + _527;
  [branch]
  if (!(cb0_106w == 0)) {
    _551 = (pow(_537, 0.012683313339948654f));
    _552 = (pow(_538, 0.012683313339948654f));
    _553 = (pow(_539, 0.012683313339948654f));
    _586 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_551 + -0.8359375f)) / (18.8515625f - (_551 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _587 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_552 + -0.8359375f)) / (18.8515625f - (_552 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _588 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_553 + -0.8359375f)) / (18.8515625f - (_553 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _614 = min((_586 * 12.920000076293945f), ((exp2(log2(max(_586, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _615 = min((_587 * 12.920000076293945f), ((exp2(log2(max(_587, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _616 = min((_588 * 12.920000076293945f), ((exp2(log2(max(_588, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _614 = _537;
    _615 = _538;
    _616 = _539;
  }
  SV_Target.x = _614;
  SV_Target.y = _615;
  SV_Target.z = _616;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = (dot(float3(_529, _528, _527), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}