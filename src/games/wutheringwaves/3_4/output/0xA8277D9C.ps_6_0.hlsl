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
  float _159;
  float _227;
  float _228;
  float _229;
  float _241;
  float _242;
  float _243;
  float _372;
  float _373;
  float _374;
  float _406;
  float _407;
  float _408;
  float _455;
  float _456;
  float _457;
  float _472;
  float _473;
  float _474;
  float _546;
  float _547;
  float _548;
  float _636;
  float _637;
  float _638;
  float _80;
  float _85;
  float _86;
  float4 _96;
  float _108;
  float4 _126;
  float _133;
  float _136;
  float _138;
  float _144;
  float _146;
  bool _147;
  float4 _189;
  bool _216;
  float4 _219;
  float4 _233;
  float _244;
  float _269;
  float _271;
  float _274;
  float _276;
  float _283;
  float _284;
  float _285;
  float _313;
  float _315;
  float _322;
  float _323;
  float _324;
  float _335;
  float _337;
  float _339;
  float _384;
  float _385;
  float _386;
  float _414;
  float _415;
  float _416;
  float _419;
  float _429;
  float _440;
  float _447;
  float _467;
  float _495;
  float _496;
  float _497;
  float4 _498;
  float _531;
  float4 _532;
  float _549;
  float _550;
  float _551;
  float _559;
  float _560;
  float _561;
  float _573;
  float _574;
  float _575;
  float _608;
  float _609;
  float _610;
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
  _96 = t0.Sample(s0, float2(min(max(_85, cb0_053x), cb0_053z), min(max(_86, cb0_053y), cb0_053w)));
  _108 = log2(max(dot(float3(_96.x, _96.y, _96.z), float3(cb0_042y, cb0_042z, cb0_042w)), cb0_041z));
  _126 = t5.Sample(s5, float3((cb0_046x * TEXCOORD_4.x), (cb0_046y * TEXCOORD_4.y), ((((cb0_041x * _108) + cb0_041y) * 0.96875f) + 0.015625f)));
  _133 = select((_126.y < 0.0010000000474974513f), (((float4)(t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x), (_126.x / _126.y));
  _136 = log2(TEXCOORD_1.x);
  _138 = (_133 + _136) + (((((float4)(t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x) - _133) * cb0_045y);
  _144 = _136 + _108;
  _146 = _138 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_045z);
  _147 = (_146 > 0.0f);
  if (_147) {
    _159 = max(0.0f, (_146 - cb0_046z));
  } else {
    _159 = min(0.0f, (cb0_046w + _146));
  }
  _189 = t1.Sample(s1, float2(min(max(((cb0_068x * _85) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _86) + cb0_068w), cb0_060y), cb0_060w)));
  APPLY_BLOOM(_189);
  [branch]
  if (!(cb0_085x == 0)) {
    _216 = (cb0_085z != 0);
    _219 = t2.Sample(s2, float2(select(_216, _85, min(max(((cb0_076x * _85) + cb0_076z), cb0_075x), cb0_075z)), select(_216, _86, min(max(((cb0_076y * _86) + cb0_076w), cb0_075y), cb0_075w))));
    _227 = (_219.x + _189.x);
    _228 = (_219.y + _189.y);
    _229 = (_219.z + _189.z);
  } else {
    _227 = _189.x;
    _228 = _189.y;
    _229 = _189.z;
  }
  [branch]
  if (!(cb0_085y == 0)) {
    _233 = t3.Sample(s3, float2(_85, _86));
    _241 = (_233.x + _227);
    _242 = (_233.y + _228);
    _243 = (_233.z + _229);
  } else {
    _241 = _227;
    _242 = _228;
    _243 = _229;
  }
  _244 = exp2((((_138 - _144) + ((_144 - _138) * cb0_045x)) - _159) + (_159 * select(_147, cb0_044z, cb0_044w))) * TEXCOORD_1.x;
  _269 = TEXCOORD_1.z + -1.0f;
  _271 = TEXCOORD_1.w + -1.0f;
  _274 = ((_269 + (cb0_090x * 2.0f)) * cb0_088z) * cb0_088x;
  _276 = ((_271 + (cb0_090y * 2.0f)) * cb0_088w) * cb0_088x;
  _283 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_274, _276), float2(_274, _276))) + 1.0f);
  _284 = _283 * _283;
  _285 = cb0_090z + 1.0f;
  _313 = ((_269 + (cb0_093x * 2.0f)) * cb0_091z) * cb0_091x;
  _315 = ((_271 + (cb0_093y * 2.0f)) * cb0_091w) * cb0_091x;
  _322 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_313, _315), float2(_313, _315))) + 1.0f);
  _323 = _322 * _322;
  _324 = cb0_093z + 1.0f;
  _335 = (((_284 * (_285 - cb0_089x)) + cb0_089x) * (_241 + ((_244 * _96.x) * cb0_086x))) * ((_323 * (_324 - cb0_092x)) + cb0_092x);
  _337 = (((_284 * (_285 - cb0_089y)) + cb0_089y) * (_242 + ((_244 * _96.y) * cb0_086y))) * ((_323 * (_324 - cb0_092y)) + cb0_092y);
  _339 = (((_284 * (_285 - cb0_089z)) + cb0_089z) * (_243 + ((_244 * _96.z) * cb0_086z))) * ((_323 * (_324 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_335, _337, _339));
  [branch]
  if (WUWA_TM_IS(1)) {
    _372 = ((((_335 * 1.3600000143051147f) + 0.04699999839067459f) * _335) / ((((_335 * 0.9599999785423279f) + 0.5600000023841858f) * _335) + 0.14000000059604645f));
    _373 = ((((_337 * 1.3600000143051147f) + 0.04699999839067459f) * _337) / ((((_337 * 0.9599999785423279f) + 0.5600000023841858f) * _337) + 0.14000000059604645f));
    _374 = ((((_339 * 1.3600000143051147f) + 0.04699999839067459f) * _339) / ((((_339 * 0.9599999785423279f) + 0.5600000023841858f) * _339) + 0.14000000059604645f));
  } else {
    _372 = _335;
    _373 = _337;
    _374 = _339;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _384 = 1.0049500465393066f - (0.16398000717163086f / (_372 + -0.19505000114440918f));
    _385 = 1.0049500465393066f - (0.16398000717163086f / (_373 + -0.19505000114440918f));
    _386 = 1.0049500465393066f - (0.16398000717163086f / (_374 + -0.19505000114440918f));
    _406 = ((_372 - _384) * select((_372 > 0.6000000238418579f), 0.0f, 1.0f)) + _384;
    _407 = ((_373 - _385) * select((_373 > 0.6000000238418579f), 0.0f, 1.0f)) + _385;
    _408 = ((_374 - _386) * select((_374 > 0.6000000238418579f), 0.0f, 1.0f)) + _386;
  } else {
    _406 = _372;
    _407 = _373;
    _408 = _374;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _414 = cb0_037y * _406;
    _415 = cb0_037y * _407;
    _416 = cb0_037y * _408;
    _419 = cb0_037z * cb0_037w;
    _429 = cb0_038y * cb0_038x;
    _440 = cb0_038z * cb0_038x;
    _447 = cb0_038y / cb0_038z;
    _455 = ((((_419 + _414) * _406) + _429) / (_440 + ((_414 + cb0_037z) * _406))) - _447;
    _456 = ((((_419 + _415) * _407) + _429) / (_440 + ((_415 + cb0_037z) * _407))) - _447;
    _457 = ((((_419 + _416) * _408) + _429) / (_440 + ((_416 + cb0_037z) * _408))) - _447;
  } else {
    _455 = _406;
    _456 = _407;
    _457 = _408;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _467 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _472 = (_467 * _455);
      _473 = (_467 * _456);
      _474 = (_467 * _457);
    } else {
      _472 = _455;
      _473 = _456;
      _474 = _457;
    }
  } else {
    _472 = _455;
    _473 = _456;
    _474 = _457;
  }
  APPLY_EXTENDED_TONEMAP(_472, _473, _474);
  _495 = (saturate((log2(_472 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _496 = (saturate((log2(_473 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _497 = (saturate((log2(_474 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _498 = t7.Sample(s7, float3(_495, _496, _497));
  [branch]
  if (!(cb0_107w == 0)) {
    _531 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _85) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _86) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _532 = t8.Sample(s8, float3(_495, _496, _497));
    _546 = (lerp(_532.x, _498.x, _531));
    _547 = (lerp(_532.y, _498.y, _531));
    _548 = (lerp(_532.z, _498.z, _531));
  } else {
    _546 = _498.x;
    _547 = _498.y;
    _548 = _498.z;
  }
  _549 = _548 * 1.0499999523162842f;
  _550 = _547 * 1.0499999523162842f;
  _551 = _546 * 1.0499999523162842f;
  _559 = ((_50 * 0.00390625f) + -0.001953125f) + _551;
  _560 = ((_74 * 0.00390625f) + -0.001953125f) + _550;
  _561 = ((_75 * 0.00390625f) + -0.001953125f) + _549;
  [branch]
  if (!(cb0_106w == 0)) {
    _573 = (pow(_559, 0.012683313339948654f));
    _574 = (pow(_560, 0.012683313339948654f));
    _575 = (pow(_561, 0.012683313339948654f));
    _608 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_573 + -0.8359375f)) / (18.8515625f - (_573 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _609 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_574 + -0.8359375f)) / (18.8515625f - (_574 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _610 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_575 + -0.8359375f)) / (18.8515625f - (_575 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _636 = min((_608 * 12.920000076293945f), ((exp2(log2(max(_608, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _637 = min((_609 * 12.920000076293945f), ((exp2(log2(max(_609, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _638 = min((_610 * 12.920000076293945f), ((exp2(log2(max(_610, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _636 = _559;
    _637 = _560;
    _638 = _561;
  }
  SV_Target.x = _636;
  SV_Target.y = _637;
  SV_Target.z = _638;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = (dot(float3(_551, _550, _549), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}