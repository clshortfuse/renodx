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
  float cb0_041z : packoffset(c041.z);
  float cb0_041w : packoffset(c041.w);
  float cb0_042x : packoffset(c042.x);
  float cb0_043x : packoffset(c043.x);
  float cb0_043y : packoffset(c043.y);
  float cb0_043z : packoffset(c043.z);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_045w : packoffset(c045.w);
  float cb0_046x : packoffset(c046.x);
  float cb0_046y : packoffset(c046.y);
  float cb0_046z : packoffset(c046.z);
  float cb0_046w : packoffset(c046.w);
  float cb0_047x : packoffset(c047.x);
  float cb0_047y : packoffset(c047.y);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_049x : packoffset(c049.x);
  float cb0_049y : packoffset(c049.y);
  float cb0_053z : packoffset(c053.z);
  float cb0_053w : packoffset(c053.w);
  float cb0_054x : packoffset(c054.x);
  float cb0_054y : packoffset(c054.y);
  float cb0_060z : packoffset(c060.z);
  float cb0_060w : packoffset(c060.w);
  float cb0_061x : packoffset(c061.x);
  float cb0_061y : packoffset(c061.y);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_069x : packoffset(c069.x);
  float cb0_069y : packoffset(c069.y);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_076z : packoffset(c076.z);
  float cb0_076w : packoffset(c076.w);
  float cb0_077x : packoffset(c077.x);
  float cb0_077y : packoffset(c077.y);
  float cb0_083z : packoffset(c083.z);
  float cb0_083w : packoffset(c083.w);
  float cb0_084x : packoffset(c084.x);
  float cb0_084y : packoffset(c084.y);
  float cb0_084z : packoffset(c084.z);
  float cb0_084w : packoffset(c084.w);
  float cb0_085x : packoffset(c085.x);
  float cb0_085y : packoffset(c085.y);
  int cb0_085z : packoffset(c085.z);
  int cb0_085w : packoffset(c085.w);
  int cb0_086x : packoffset(c086.x);
  float cb0_087x : packoffset(c087.x);
  float cb0_087y : packoffset(c087.y);
  float cb0_087z : packoffset(c087.z);
  float cb0_089x : packoffset(c089.x);
  float cb0_089z : packoffset(c089.z);
  float cb0_089w : packoffset(c089.w);
  float cb0_090x : packoffset(c090.x);
  float cb0_090y : packoffset(c090.y);
  float cb0_090z : packoffset(c090.z);
  float cb0_090w : packoffset(c090.w);
  float cb0_091x : packoffset(c091.x);
  float cb0_091y : packoffset(c091.y);
  float cb0_091z : packoffset(c091.z);
  float cb0_092x : packoffset(c092.x);
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
  float cb0_093x : packoffset(c093.x);
  float cb0_093y : packoffset(c093.y);
  float cb0_093z : packoffset(c093.z);
  float cb0_093w : packoffset(c093.w);
  float cb0_094x : packoffset(c094.x);
  float cb0_094y : packoffset(c094.y);
  float cb0_094z : packoffset(c094.z);
  float cb0_096z : packoffset(c096.z);
  float cb0_097x : packoffset(c097.x);
  int cb0_106w : packoffset(c106.w);
  float cb0_107x : packoffset(c107.x);
  float cb0_107z : packoffset(c107.z);
  int cb0_107w : packoffset(c107.w);
  int cb0_108x : packoffset(c108.x);
  int cb0_108y : packoffset(c108.y);
  int cb0_108z : packoffset(c108.z);
  int cb0_108w : packoffset(c108.w);
  float cb0_114x : packoffset(c114.x);
  float cb0_114y : packoffset(c114.y);
  float cb0_114z : packoffset(c114.z);
  float cb0_114w : packoffset(c114.w);
  float cb0_115x : packoffset(c115.x);
  float cb0_115y : packoffset(c115.y);
  float cb0_115z : packoffset(c115.z);
  float cb0_115w : packoffset(c115.w);
  float cb0_117x : packoffset(c117.x);
  float cb0_117y : packoffset(c117.y);
  float cb0_117z : packoffset(c117.z);
  float cb0_118x : packoffset(c118.x);
  float cb0_118y : packoffset(c118.y);
  float cb0_118z : packoffset(c118.z);
  float cb0_118w : packoffset(c118.w);
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

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _44 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _45 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _46 = TEXCOORD_2.w * 543.3099975585938f;
  float _50 = frac(sin(_46 + TEXCOORD_2.z) * 493013.0f);
  float _74;
  float _75;
  float _163;
  float _164;
  float _258;
  float _259;
  float _318;
  float _390;
  float _391;
  float _392;
  float _404;
  float _405;
  float _406;
  float _535;
  float _536;
  float _537;
  float _569;
  float _570;
  float _571;
  float _618;
  float _619;
  float _620;
  float _635;
  float _636;
  float _637;
  float _710;
  float _711;
  float _712;
  float _800;
  float _801;
  float _802;
  if (cb0_097x > 0.0f) {
    _74 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _46) * 493013.0f) + 7.177000045776367f) - _50)) + _50);
    _75 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _46) * 493013.0f) + 14.298999786376953f) - _50)) + _50);
  } else {
    _74 = _50;
    _75 = _50;
  }
  float _80 = cb0_096z * (1.0f - (_50 * _50));
  float _85 = (_80 * (TEXCOORD_2.x - _44)) + _44;
  float _86 = (_80 * (TEXCOORD_2.y - _45)) + _45;
  float _101 = _85 - (((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x);
  float _102 = _86 - (((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y);
  float _112 = cb0_118z * cb0_117x;
  float _113 = cb0_118z * cb0_117y;
  bool _114 = (cb0_118x == 0.0f);
  float _124 = (cb0_114z * TEXCOORD_3.x) + cb0_114x;
  float _125 = (cb0_114w * TEXCOORD_3.y) + cb0_114y;
  float _136 = float((int)(((int)(uint)((bool)(_124 > 0.0f))) - ((int)(uint)((bool)(_124 < 0.0f)))));
  float _137 = float((int)(((int)(uint)((bool)(_125 > 0.0f))) - ((int)(uint)((bool)(_125 < 0.0f)))));
  float _142 = saturate(abs(_124) - cb0_117z);
  float _143 = saturate(abs(_125) - cb0_117z);
  float _153 = _125 - ((_143 * _112) * _137);
  float _155 = _125 - ((_143 * _113) * _137);
  bool _156 = (cb0_118x > 0.0f);
  if (_156) {
    _163 = (_153 - (cb0_118w * 0.4000000059604645f));
    _164 = (_155 - (cb0_118w * 0.20000000298023224f));
  } else {
    _163 = _153;
    _164 = _155;
  }
  float4 _200 = t0.Sample(s0, float2(min(max(_85, cb0_053z), cb0_054x), min(max(_86, cb0_053w), cb0_054y)));
  float4 _216 = t0.Sample(s0, float2(min(max(((((cb0_048z * ((cb0_115z * (_124 - ((_142 * select(_114, _112, cb0_117x)) * _136))) + cb0_115x)) + cb0_049x) * cb0_048x) + _101), cb0_053z), cb0_054x), min(max(((((cb0_048w * ((cb0_115w * _163) + cb0_115y)) + cb0_049y) * cb0_048y) + _102), cb0_053w), cb0_054y)));
  float4 _230 = t0.Sample(s0, float2(min(max(((((cb0_048z * ((cb0_115z * (_124 - ((_142 * select(_114, _113, cb0_117y)) * _136))) + cb0_115x)) + cb0_049x) * cb0_048x) + _101), cb0_053z), cb0_054x), min(max(((((cb0_048w * ((cb0_115w * _164) + cb0_115y)) + cb0_049y) * cb0_048y) + _102), cb0_053w), cb0_054y)));
  if (_156) {
    float _240 = saturate(((((_200.y * 0.5870000123977661f) - cb0_118y) + (_200.x * 0.29899999499320984f)) + (_200.z * 0.11400000005960464f)) * 10.0f);
    float _244 = (_240 * _240) * (3.0f - (_240 * 2.0f));
    _258 = ((((_200.x - _216.x) + (_244 * (_216.x - _200.x))) * cb0_118x) + _216.x);
    _259 = ((((_200.y - _230.y) + (_244 * (_230.y - _200.y))) * cb0_118x) + _230.y);
  } else {
    _258 = _216.x;
    _259 = _230.y;
  }
  float _268 = log2(max(dot(float3(_258, _259, _200.z), float3(cb0_043x, cb0_043y, cb0_043z)), cb0_042x));
  float4 _286 = t5.Sample(s5, float3((cb0_046z * TEXCOORD_4.x), (cb0_046w * TEXCOORD_4.y), ((((cb0_041z * _268) + cb0_041w) * 0.96875f) + 0.015625f)));
  float4 _290 = t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y));
  float _293 = select((_286.y < 0.0010000000474974513f), _290.x, (_286.x / _286.y));
  float _296 = log2(TEXCOORD_1.x);
  float _298 = (_293 + _296) + ((_290.x - _293) * cb0_046x);
  float _303 = _296 + _268;
  float _305 = _298 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_046y);
  bool _306 = (_305 > 0.0f);
  if (_306) {
    _318 = max(0.0f, (_305 - cb0_047x));
  } else {
    _318 = min(0.0f, (cb0_047y + _305));
  }
  float4 _350 = t1.Sample(s1, float2(min(max(((cb0_068z * _85) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _86) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_350);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _379 = (cb0_086x != 0);
    float4 _382 = t2.Sample(s2, float2(select(_379, _85, min(max(((cb0_076z * _85) + cb0_077x), cb0_075z), cb0_076x)), select(_379, _86, min(max(((cb0_076w * _86) + cb0_077y), cb0_075w), cb0_076y))));
    _390 = (_382.x + _350.x);
    _391 = (_382.y + _350.y);
    _392 = (_382.z + _350.z);
  } else {
    _390 = _350.x;
    _391 = _350.y;
    _392 = _350.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _396 = t3.Sample(s3, float2(_85, _86));
    _404 = (_396.x + _390);
    _405 = (_396.y + _391);
    _406 = (_396.z + _392);
  } else {
    _404 = _390;
    _405 = _391;
    _406 = _392;
  }
  float _407 = exp2((((_298 - _303) + ((_303 - _298) * cb0_045w)) - _318) + (_318 * select(_306, cb0_045y, cb0_045z))) * TEXCOORD_1.x;
  float _432 = TEXCOORD_1.z + -1.0f;
  float _434 = TEXCOORD_1.w + -1.0f;
  float _437 = ((_432 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _439 = ((_434 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _446 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_437, _439), float2(_437, _439))) + 1.0f);
  float _447 = _446 * _446;
  float _448 = cb0_091z + 1.0f;
  float _476 = ((_432 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _478 = ((_434 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _485 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_476, _478), float2(_476, _478))) + 1.0f);
  float _486 = _485 * _485;
  float _487 = cb0_094z + 1.0f;
  float _498 = (((_447 * (_448 - cb0_090x)) + cb0_090x) * (_404 + ((_407 * _258) * cb0_087x))) * ((_486 * (_487 - cb0_093x)) + cb0_093x);
  float _500 = (((_447 * (_448 - cb0_090y)) + cb0_090y) * (_405 + ((_407 * _259) * cb0_087y))) * ((_486 * (_487 - cb0_093y)) + cb0_093y);
  float _502 = (((_447 * (_448 - cb0_090z)) + cb0_090z) * (_406 + ((_407 * _200.z) * cb0_087z))) * ((_486 * (_487 - cb0_093z)) + cb0_093z);

  CAPTURE_UNTONEMAPPED(float3(_498, _500, _502));
  [branch]
  if (WUWA_TM_IS(1)) {
    _535 = ((((_498 * 1.3600000143051147f) + 0.04699999839067459f) * _498) / ((((_498 * 0.9599999785423279f) + 0.5600000023841858f) * _498) + 0.14000000059604645f));
    _536 = ((((_500 * 1.3600000143051147f) + 0.04699999839067459f) * _500) / ((((_500 * 0.9599999785423279f) + 0.5600000023841858f) * _500) + 0.14000000059604645f));
    _537 = ((((_502 * 1.3600000143051147f) + 0.04699999839067459f) * _502) / ((((_502 * 0.9599999785423279f) + 0.5600000023841858f) * _502) + 0.14000000059604645f));
  } else {
    _535 = _498;
    _536 = _500;
    _537 = _502;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _547 = 1.0049500465393066f - (0.16398000717163086f / (_535 + -0.19505000114440918f));
    float _548 = 1.0049500465393066f - (0.16398000717163086f / (_536 + -0.19505000114440918f));
    float _549 = 1.0049500465393066f - (0.16398000717163086f / (_537 + -0.19505000114440918f));
    _569 = (((_535 - _547) * select((_535 > 0.6000000238418579f), 0.0f, 1.0f)) + _547);
    _570 = (((_536 - _548) * select((_536 > 0.6000000238418579f), 0.0f, 1.0f)) + _548);
    _571 = (((_537 - _549) * select((_537 > 0.6000000238418579f), 0.0f, 1.0f)) + _549);
  } else {
    _569 = _535;
    _570 = _536;
    _571 = _537;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _577 = cb0_037y * _569;
    float _578 = cb0_037y * _570;
    float _579 = cb0_037y * _571;
    float _582 = cb0_037z * cb0_037w;
    float _592 = cb0_038y * cb0_038x;
    float _603 = cb0_038z * cb0_038x;
    float _610 = cb0_038y / cb0_038z;
    _618 = (((((_582 + _577) * _569) + _592) / (_603 + ((_577 + cb0_037z) * _569))) - _610);
    _619 = (((((_582 + _578) * _570) + _592) / (_603 + ((_578 + cb0_037z) * _570))) - _610);
    _620 = (((((_582 + _579) * _571) + _592) / (_603 + ((_579 + cb0_037z) * _571))) - _610);
  } else {
    _618 = _569;
    _619 = _570;
    _620 = _571;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _630 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _635 = (_630 * _618);
      _636 = (_630 * _619);
      _637 = (_630 * _620);
    } else {
      _635 = _618;
      _636 = _619;
      _637 = _620;
    }
  } else {
    _635 = _618;
    _636 = _619;
    _637 = _620;
  }
  CLAMP_IF_SDR3(_635, _636, _637);
  CAPTURE_TONEMAPPED(float3(_635, _636, _637));
  float _658 = (saturate((log2(_635 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _659 = (saturate((log2(_636 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _660 = (saturate((log2(_637 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _661 = t7.Sample(s7, float3(_658, _659, _660));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _685 = t4.Sample(s4, float2(min(max(((cb0_084z * _85) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _86) + cb0_085y), cb0_083w), cb0_084y)));
    float _695 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_685.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _696 = t8.Sample(s8, float3(_658, _659, _660));
    _710 = (lerp(_696.x, _661.x, _695));
    _711 = (lerp(_696.y, _661.y, _695));
    _712 = (lerp(_696.z, _661.z, _695));
  } else {
    _710 = _661.x;
    _711 = _661.y;
    _712 = _661.z;
  }
  HANDLE_LUT_OUTPUT3_FADE(_710, _711, _712, t7, s7);
  float _713 = _712 * 1.0499999523162842f;
  float _714 = _711 * 1.0499999523162842f;
  float _715 = _710 * 1.0499999523162842f;
  float _723 = ((_50 * 0.00390625f) + -0.001953125f) + _715;
  float _724 = ((_74 * 0.00390625f) + -0.001953125f) + _714;
  float _725 = ((_75 * 0.00390625f) + -0.001953125f) + _713;
  [branch]
  if (!(cb0_107w == 0)) {
    float _737 = (pow(_723, 0.012683313339948654f));
    float _738 = (pow(_724, 0.012683313339948654f));
    float _739 = (pow(_725, 0.012683313339948654f));
    float _772 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_737 + -0.8359375f)) / (18.8515625f - (_737 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _773 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_738 + -0.8359375f)) / (18.8515625f - (_738 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _774 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_739 + -0.8359375f)) / (18.8515625f - (_739 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _800 = min((_772 * 12.920000076293945f), ((exp2(log2(max(_772, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _801 = min((_773 * 12.920000076293945f), ((exp2(log2(max(_773, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _802 = min((_774 * 12.920000076293945f), ((exp2(log2(max(_774, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _800 = _723;
    _801 = _724;
    _802 = _725;
  }
  SV_Target.x = _800;
  SV_Target.y = _801;
  SV_Target.z = _802;
  SV_Target.w = dot(float3(_715, _714, _713), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
