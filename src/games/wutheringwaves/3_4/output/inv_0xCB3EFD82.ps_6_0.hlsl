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
  float _131;
  float _132;
  float _133;
  float _145;
  float _146;
  float _147;
  float _275;
  float _276;
  float _277;
  float _309;
  float _310;
  float _311;
  float _358;
  float _359;
  float _360;
  float _375;
  float _376;
  float _377;
  float _449;
  float _450;
  float _451;
  float _539;
  float _540;
  float _541;
  float _590;
  float _591;
  float _592;
  float _593;
  float _594;
  float _595;
  float4 _67;
  float4 _93;
  bool _120;
  float4 _123;
  float4 _137;
  float _172;
  float _174;
  float _177;
  float _179;
  float _186;
  float _187;
  float _188;
  float _216;
  float _218;
  float _225;
  float _226;
  float _227;
  float _238;
  float _240;
  float _242;
  float _287;
  float _288;
  float _289;
  float _317;
  float _318;
  float _319;
  float _322;
  float _332;
  float _343;
  float _350;
  float _370;
  float _398;
  float _399;
  float _400;
  float4 _401;
  float _434;
  float4 _435;
  float _452;
  float _453;
  float _454;
  float _462;
  float _463;
  float _464;
  float _476;
  float _477;
  float _478;
  float _511;
  float _512;
  float _513;
  float _550;
  float _557;
  float _564;
  float _565;
  float _566;
  float _571;
  float _572;
  float _573;
  float _582;
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
  _67 = t0.Sample(s0, float2(_35, _36));
  _93 = t1.Sample(s1, float2(min(max(((cb0_068x * _35) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _36) + cb0_068w), cb0_060y), cb0_060w)));
  APPLY_BLOOM(_93);
  [branch]
  if (!(cb0_085x == 0)) {
    _120 = (cb0_085z != 0);
    _123 = t2.Sample(s2, float2(select(_120, _35, min(max(((cb0_076x * _35) + cb0_076z), cb0_075x), cb0_075z)), select(_120, _36, min(max(((cb0_076y * _36) + cb0_076w), cb0_075y), cb0_075w))));
    _131 = (_123.x + _93.x);
    _132 = (_123.y + _93.y);
    _133 = (_123.z + _93.z);
  } else {
    _131 = _93.x;
    _132 = _93.y;
    _133 = _93.z;
  }
  [branch]
  if (!(cb0_085y == 0)) {
    _137 = t3.Sample(s3, float2(_35, _36));
    _145 = (_137.x + _131);
    _146 = (_137.y + _132);
    _147 = (_137.z + _133);
  } else {
    _145 = _131;
    _146 = _132;
    _147 = _133;
  }
  _172 = TEXCOORD_1.z + -1.0f;
  _174 = TEXCOORD_1.w + -1.0f;
  _177 = ((_172 + (cb0_090x * 2.0f)) * cb0_088z) * cb0_088x;
  _179 = ((_174 + (cb0_090y * 2.0f)) * cb0_088w) * cb0_088x;
  _186 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_177, _179), float2(_177, _179))) + 1.0f);
  _187 = _186 * _186;
  _188 = cb0_090z + 1.0f;
  _216 = ((_172 + (cb0_093x * 2.0f)) * cb0_091z) * cb0_091x;
  _218 = ((_174 + (cb0_093y * 2.0f)) * cb0_091w) * cb0_091x;
  _225 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_216, _218), float2(_216, _218))) + 1.0f);
  _226 = _225 * _225;
  _227 = cb0_093z + 1.0f;
  _238 = (((_187 * (_188 - cb0_089x)) + cb0_089x) * (_145 + ((_67.x * TEXCOORD_1.x) * cb0_086x))) * ((_226 * (_227 - cb0_092x)) + cb0_092x);
  _240 = (((_187 * (_188 - cb0_089y)) + cb0_089y) * (_146 + ((_67.y * TEXCOORD_1.x) * cb0_086y))) * ((_226 * (_227 - cb0_092y)) + cb0_092y);
  _242 = (((_187 * (_188 - cb0_089z)) + cb0_089z) * (_147 + ((_67.z * TEXCOORD_1.x) * cb0_086z))) * ((_226 * (_227 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_238, _240, _242));
  [branch]
  if (WUWA_TM_IS(1)) {
    _275 = ((((_238 * 1.3600000143051147f) + 0.04699999839067459f) * _238) / ((((_238 * 0.9599999785423279f) + 0.5600000023841858f) * _238) + 0.14000000059604645f));
    _276 = ((((_240 * 1.3600000143051147f) + 0.04699999839067459f) * _240) / ((((_240 * 0.9599999785423279f) + 0.5600000023841858f) * _240) + 0.14000000059604645f));
    _277 = ((((_242 * 1.3600000143051147f) + 0.04699999839067459f) * _242) / ((((_242 * 0.9599999785423279f) + 0.5600000023841858f) * _242) + 0.14000000059604645f));
  } else {
    _275 = _238;
    _276 = _240;
    _277 = _242;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _287 = 1.0049500465393066f - (0.16398000717163086f / (_275 + -0.19505000114440918f));
    _288 = 1.0049500465393066f - (0.16398000717163086f / (_276 + -0.19505000114440918f));
    _289 = 1.0049500465393066f - (0.16398000717163086f / (_277 + -0.19505000114440918f));
    _309 = ((_275 - _287) * select((_275 > 0.6000000238418579f), 0.0f, 1.0f)) + _287;
    _310 = ((_276 - _288) * select((_276 > 0.6000000238418579f), 0.0f, 1.0f)) + _288;
    _311 = ((_277 - _289) * select((_277 > 0.6000000238418579f), 0.0f, 1.0f)) + _289;
  } else {
    _309 = _275;
    _310 = _276;
    _311 = _277;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _317 = cb0_037y * _309;
    _318 = cb0_037y * _310;
    _319 = cb0_037y * _311;
    _322 = cb0_037z * cb0_037w;
    _332 = cb0_038y * cb0_038x;
    _343 = cb0_038z * cb0_038x;
    _350 = cb0_038y / cb0_038z;
    _358 = ((((_322 + _317) * _309) + _332) / (_343 + ((_317 + cb0_037z) * _309))) - _350;
    _359 = ((((_322 + _318) * _310) + _332) / (_343 + ((_318 + cb0_037z) * _310))) - _350;
    _360 = ((((_322 + _319) * _311) + _332) / (_343 + ((_319 + cb0_037z) * _311))) - _350;
  } else {
    _358 = _309;
    _359 = _310;
    _360 = _311;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _370 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _375 = (_370 * _358);
      _376 = (_370 * _359);
      _377 = (_370 * _360);
    } else {
      _375 = _358;
      _376 = _359;
      _377 = _360;
    }
  } else {
    _375 = _358;
    _376 = _359;
    _377 = _360;
  }
  APPLY_EXTENDED_TONEMAP(_375, _376, _377);
  _398 = (saturate((log2(_375 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _399 = (saturate((log2(_376 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _400 = (saturate((log2(_377 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _401 = t5.Sample(s5, float3(_398, _399, _400));
  [branch]
  if (!(cb0_107w == 0)) {
    _434 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t4.Sample(s4, float2(min(max(((cb0_084x * _35) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _36) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _435 = t6.Sample(s6, float3(_398, _399, _400));
    _449 = (lerp(_435.x, _401.x, _434));
    _450 = (lerp(_435.y, _401.y, _434));
    _451 = (lerp(_435.z, _401.z, _434));
  } else {
    _449 = _401.x;
    _450 = _401.y;
    _451 = _401.z;
  }
  _452 = _451 * 1.0499999523162842f;
  _453 = _450 * 1.0499999523162842f;
  _454 = _449 * 1.0499999523162842f;
  _462 = ((_41 * 0.00390625f) + -0.001953125f) + _454;
  _463 = ((_65 * 0.00390625f) + -0.001953125f) + _453;
  _464 = ((_66 * 0.00390625f) + -0.001953125f) + _452;
  [branch]
  if (!(cb0_106w == 0)) {
    _476 = (pow(_462, 0.012683313339948654f));
    _477 = (pow(_463, 0.012683313339948654f));
    _478 = (pow(_464, 0.012683313339948654f));
    _511 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_476 + -0.8359375f)) / (18.8515625f - (_476 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _512 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_477 + -0.8359375f)) / (18.8515625f - (_477 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _513 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_478 + -0.8359375f)) / (18.8515625f - (_478 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _539 = min((_511 * 12.920000076293945f), ((exp2(log2(max(_511, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _540 = min((_512 * 12.920000076293945f), ((exp2(log2(max(_512, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _541 = min((_513 * 12.920000076293945f), ((exp2(log2(max(_513, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _539 = _462;
    _540 = _463;
    _541 = _464;
  }
  GENERATE_INVERSION(_539, _540, _541);
  _550 = ((((_540 * 587.0f) + (_539 * 299.0f)) + (_541 * 114.0f)) * 0.0010000000474974513f) - cb0_108z;
  _557 = saturate(float((int)(((int)(uint)((bool)(_550 > 0.0f))) - ((int)(uint)((bool)(_550 < 0.0f))))));
  _564 = cb0_109x - _539;
  _565 = cb0_109y - _540;
  _566 = cb0_109z - _541;
  _571 = WUWA_PEAK_SCALING * cb0_110x - _539;
  _572 = WUWA_PEAK_SCALING * cb0_110y - _540;
  _573 = WUWA_PEAK_SCALING * cb0_110z - _541;
  [branch]
  if (cb0_108y > 0.0f) {
    _590 = (_564 * cb0_108y);
    _591 = (_565 * cb0_108y);
    _592 = (_566 * cb0_108y);
    _593 = (_571 * cb0_108y);
    _594 = (_572 * cb0_108y);
    _595 = (_573 * cb0_108y);
  } else {
    _582 = abs(cb0_108y);
    _590 = (_571 * _582);
    _591 = (_572 * _582);
    _592 = (_573 * _582);
    _593 = (_564 * _582);
    _594 = (_565 * _582);
    _595 = (_566 * _582);
  }
  SV_Target.x = ((cb0_108x * (lerp(_590, _593, _557))) + _539);
  SV_Target.y = ((cb0_108x * (lerp(_591, _594, _557))) + _540);
  SV_Target.z = (((lerp(_592, _595, _557)) * cb0_108x) + _541);
  SV_Target.rgb = wuwa::ApplyDisplayMap(SV_Target.rgb);
  SV_Target.w = (dot(float3(_454, _453, _452), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}