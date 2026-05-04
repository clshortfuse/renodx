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
  float cb0_097x : packoffset(c097.x);
  int cb0_106w : packoffset(c106.w);
  float cb0_107x : packoffset(c107.x);
  float cb0_107z : packoffset(c107.z);
  int cb0_107w : packoffset(c107.w);
  int cb0_108x : packoffset(c108.x);
  int cb0_108y : packoffset(c108.y);
  int cb0_108z : packoffset(c108.z);
  int cb0_108w : packoffset(c108.w);
  float cb0_109x : packoffset(c109.x);
  float cb0_109y : packoffset(c109.y);
  float cb0_109z : packoffset(c109.z);
  float cb0_110x : packoffset(c110.x);
  float cb0_110y : packoffset(c110.y);
  float cb0_110z : packoffset(c110.z);
  float cb0_111x : packoffset(c111.x);
  float cb0_111y : packoffset(c111.y);
  float cb0_111z : packoffset(c111.z);
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
  float _42 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _43 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _44 = TEXCOORD_2.w * 543.3099975585938f;
  float _48 = frac(sin(_44 + TEXCOORD_2.z) * 493013.0f);
  float _72;
  float _73;
  float _134;
  float _135;
  float _203;
  float _204;
  float _263;
  float _335;
  float _336;
  float _337;
  float _349;
  float _350;
  float _351;
  float _480;
  float _481;
  float _482;
  float _514;
  float _515;
  float _516;
  float _563;
  float _564;
  float _565;
  float _580;
  float _581;
  float _582;
  float _655;
  float _656;
  float _657;
  float _745;
  float _746;
  float _747;
  float _796;
  float _797;
  float _798;
  float _799;
  float _800;
  float _801;
  if (cb0_097x > 0.0f) {
    _72 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _44) * 493013.0f) + 7.177000045776367f) - _48)) + _48);
    _73 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _44) * 493013.0f) + 14.298999786376953f) - _48)) + _48);
  } else {
    _72 = _48;
    _73 = _48;
  }
  float _83 = cb0_118z * cb0_117x;
  float _84 = cb0_118z * cb0_117y;
  bool _85 = (cb0_118x == 0.0f);
  float _95 = (cb0_114z * TEXCOORD_3.x) + cb0_114x;
  float _96 = (cb0_114w * TEXCOORD_3.y) + cb0_114y;
  float _107 = float((int)(((int)(uint)((bool)(_95 > 0.0f))) - ((int)(uint)((bool)(_95 < 0.0f)))));
  float _108 = float((int)(((int)(uint)((bool)(_96 > 0.0f))) - ((int)(uint)((bool)(_96 < 0.0f)))));
  float _113 = saturate(abs(_95) - cb0_117z);
  float _114 = saturate(abs(_96) - cb0_117z);
  float _124 = _96 - ((_114 * _83) * _108);
  float _126 = _96 - ((_114 * _84) * _108);
  bool _127 = (cb0_118x > 0.0f);
  if (_127) {
    _134 = (_124 - (cb0_118w * 0.4000000059604645f));
    _135 = (_126 - (cb0_118w * 0.20000000298023224f));
  } else {
    _134 = _124;
    _135 = _126;
  }
  float4 _169 = t0.Sample(s0, float2(_42, _43));
  float4 _173 = t0.Sample(s0, float2((((cb0_048z * ((cb0_115z * (_95 - ((_113 * select(_85, _83, cb0_117x)) * _107))) + cb0_115x)) + cb0_049x) * cb0_048x), (((cb0_048w * ((cb0_115w * _134) + cb0_115y)) + cb0_049y) * cb0_048y)));
  float4 _175 = t0.Sample(s0, float2((((cb0_048z * ((cb0_115z * (_95 - ((_113 * select(_85, _84, cb0_117y)) * _107))) + cb0_115x)) + cb0_049x) * cb0_048x), (((cb0_048w * ((cb0_115w * _135) + cb0_115y)) + cb0_049y) * cb0_048y)));
  if (_127) {
    float _185 = saturate(((((_169.y * 0.5870000123977661f) - cb0_118y) + (_169.x * 0.29899999499320984f)) + (_169.z * 0.11400000005960464f)) * 10.0f);
    float _189 = (_185 * _185) * (3.0f - (_185 * 2.0f));
    _203 = ((((_169.x - _173.x) + (_189 * (_173.x - _169.x))) * cb0_118x) + _173.x);
    _204 = ((((_169.y - _175.y) + (_189 * (_175.y - _169.y))) * cb0_118x) + _175.y);
  } else {
    _203 = _173.x;
    _204 = _175.y;
  }
  float _213 = log2(max(dot(float3(_203, _204, _169.z), float3(cb0_043x, cb0_043y, cb0_043z)), cb0_042x));
  float4 _231 = t5.Sample(s5, float3((cb0_046z * TEXCOORD_4.x), (cb0_046w * TEXCOORD_4.y), ((((cb0_041z * _213) + cb0_041w) * 0.96875f) + 0.015625f)));
  float4 _235 = t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y));
  float _238 = select((_231.y < 0.0010000000474974513f), _235.x, (_231.x / _231.y));
  float _241 = log2(TEXCOORD_1.x);
  float _243 = (_238 + _241) + ((_235.x - _238) * cb0_046x);
  float _248 = _241 + _213;
  float _250 = _243 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_046y);
  bool _251 = (_250 > 0.0f);
  if (_251) {
    _263 = max(0.0f, (_250 - cb0_047x));
  } else {
    _263 = min(0.0f, (cb0_047y + _250));
  }
  float4 _295 = t1.Sample(s1, float2(min(max(((cb0_068z * _42) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _43) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_295);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _324 = (cb0_086x != 0);
    float4 _327 = t2.Sample(s2, float2(select(_324, _42, min(max(((cb0_076z * _42) + cb0_077x), cb0_075z), cb0_076x)), select(_324, _43, min(max(((cb0_076w * _43) + cb0_077y), cb0_075w), cb0_076y))));
    _335 = (_327.x + _295.x);
    _336 = (_327.y + _295.y);
    _337 = (_327.z + _295.z);
  } else {
    _335 = _295.x;
    _336 = _295.y;
    _337 = _295.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _341 = t3.Sample(s3, float2(_42, _43));
    _349 = (_341.x + _335);
    _350 = (_341.y + _336);
    _351 = (_341.z + _337);
  } else {
    _349 = _335;
    _350 = _336;
    _351 = _337;
  }
  float _352 = exp2((((_243 - _248) + ((_248 - _243) * cb0_045w)) - _263) + (_263 * select(_251, cb0_045y, cb0_045z))) * TEXCOORD_1.x;
  float _377 = TEXCOORD_1.z + -1.0f;
  float _379 = TEXCOORD_1.w + -1.0f;
  float _382 = ((_377 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _384 = ((_379 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _391 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_382, _384), float2(_382, _384))) + 1.0f);
  float _392 = _391 * _391;
  float _393 = cb0_091z + 1.0f;
  float _421 = ((_377 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _423 = ((_379 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _430 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_421, _423), float2(_421, _423))) + 1.0f);
  float _431 = _430 * _430;
  float _432 = cb0_094z + 1.0f;
  float _443 = (((_392 * (_393 - cb0_090x)) + cb0_090x) * (_349 + ((_352 * _203) * cb0_087x))) * ((_431 * (_432 - cb0_093x)) + cb0_093x);
  float _445 = (((_392 * (_393 - cb0_090y)) + cb0_090y) * (_350 + ((_352 * _204) * cb0_087y))) * ((_431 * (_432 - cb0_093y)) + cb0_093y);
  float _447 = (((_392 * (_393 - cb0_090z)) + cb0_090z) * (_351 + ((_352 * _169.z) * cb0_087z))) * ((_431 * (_432 - cb0_093z)) + cb0_093z);

  CAPTURE_UNTONEMAPPED(float3(_443, _445, _447));
  [branch]
  if (WUWA_TM_IS(1)) {
    _480 = ((((_443 * 1.3600000143051147f) + 0.04699999839067459f) * _443) / ((((_443 * 0.9599999785423279f) + 0.5600000023841858f) * _443) + 0.14000000059604645f));
    _481 = ((((_445 * 1.3600000143051147f) + 0.04699999839067459f) * _445) / ((((_445 * 0.9599999785423279f) + 0.5600000023841858f) * _445) + 0.14000000059604645f));
    _482 = ((((_447 * 1.3600000143051147f) + 0.04699999839067459f) * _447) / ((((_447 * 0.9599999785423279f) + 0.5600000023841858f) * _447) + 0.14000000059604645f));
  } else {
    _480 = _443;
    _481 = _445;
    _482 = _447;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _492 = 1.0049500465393066f - (0.16398000717163086f / (_480 + -0.19505000114440918f));
    float _493 = 1.0049500465393066f - (0.16398000717163086f / (_481 + -0.19505000114440918f));
    float _494 = 1.0049500465393066f - (0.16398000717163086f / (_482 + -0.19505000114440918f));
    _514 = (((_480 - _492) * select((_480 > 0.6000000238418579f), 0.0f, 1.0f)) + _492);
    _515 = (((_481 - _493) * select((_481 > 0.6000000238418579f), 0.0f, 1.0f)) + _493);
    _516 = (((_482 - _494) * select((_482 > 0.6000000238418579f), 0.0f, 1.0f)) + _494);
  } else {
    _514 = _480;
    _515 = _481;
    _516 = _482;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _522 = cb0_037y * _514;
    float _523 = cb0_037y * _515;
    float _524 = cb0_037y * _516;
    float _527 = cb0_037z * cb0_037w;
    float _537 = cb0_038y * cb0_038x;
    float _548 = cb0_038z * cb0_038x;
    float _555 = cb0_038y / cb0_038z;
    _563 = (((((_527 + _522) * _514) + _537) / (_548 + ((_522 + cb0_037z) * _514))) - _555);
    _564 = (((((_527 + _523) * _515) + _537) / (_548 + ((_523 + cb0_037z) * _515))) - _555);
    _565 = (((((_527 + _524) * _516) + _537) / (_548 + ((_524 + cb0_037z) * _516))) - _555);
  } else {
    _563 = _514;
    _564 = _515;
    _565 = _516;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _575 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _580 = (_575 * _563);
      _581 = (_575 * _564);
      _582 = (_575 * _565);
    } else {
      _580 = _563;
      _581 = _564;
      _582 = _565;
    }
  } else {
    _580 = _563;
    _581 = _564;
    _582 = _565;
  }
  APPLY_EXTENDED_TONEMAP(_580, _581, _582);
  float _603 = (saturate((log2(_580 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _604 = (saturate((log2(_581 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _605 = (saturate((log2(_582 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _606 = t7.Sample(s7, float3(_603, _604, _605));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _630 = t4.Sample(s4, float2(min(max(((cb0_084z * _42) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _43) + cb0_085y), cb0_083w), cb0_084y)));
    float _640 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_630.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _641 = t8.Sample(s8, float3(_603, _604, _605));
    _655 = (lerp(_641.x, _606.x, _640));
    _656 = (lerp(_641.y, _606.y, _640));
    _657 = (lerp(_641.z, _606.z, _640));
  } else {
    _655 = _606.x;
    _656 = _606.y;
    _657 = _606.z;
  }
  float _658 = _657 * 1.0499999523162842f;
  float _659 = _656 * 1.0499999523162842f;
  float _660 = _655 * 1.0499999523162842f;
  float _668 = ((_48 * 0.00390625f) + -0.001953125f) + _660;
  float _669 = ((_72 * 0.00390625f) + -0.001953125f) + _659;
  float _670 = ((_73 * 0.00390625f) + -0.001953125f) + _658;
  [branch]
  if (!(cb0_107w == 0)) {
    float _682 = (pow(_668, 0.012683313339948654f));
    float _683 = (pow(_669, 0.012683313339948654f));
    float _684 = (pow(_670, 0.012683313339948654f));
    float _717 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_682 + -0.8359375f)) / (18.8515625f - (_682 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _718 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_683 + -0.8359375f)) / (18.8515625f - (_683 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _719 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_684 + -0.8359375f)) / (18.8515625f - (_684 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _745 = min((_717 * 12.920000076293945f), ((exp2(log2(max(_717, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _746 = min((_718 * 12.920000076293945f), ((exp2(log2(max(_718, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _747 = min((_719 * 12.920000076293945f), ((exp2(log2(max(_719, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _745 = _668;
    _746 = _669;
    _747 = _670;
  }
  GENERATE_INVERSION(_745, _746, _747);
  float _756 = ((((_746 * 587.0f) + (_745 * 299.0f)) + (_747 * 114.0f)) * 0.0010000000474974513f) - cb0_109z;
  float _763 = saturate(float((int)(((int)(uint)((bool)(_756 > 0.0f))) - ((int)(uint)((bool)(_756 < 0.0f))))));
  float _770 = cb0_110x - _745;
  float _771 = cb0_110y - _746;
  float _772 = cb0_110z - _747;
  float _777 = WUWA_PEAK_SCALING * cb0_111x - _745;
  float _778 = WUWA_PEAK_SCALING * cb0_111y - _746;
  float _779 = WUWA_PEAK_SCALING * cb0_111z - _747;
  [branch]
  if (cb0_109y > 0.0f) {
    _796 = (_770 * cb0_109y);
    _797 = (_771 * cb0_109y);
    _798 = (_772 * cb0_109y);
    _799 = (_777 * cb0_109y);
    _800 = (_778 * cb0_109y);
    _801 = (_779 * cb0_109y);
  } else {
    float _788 = abs(cb0_109y);
    _796 = (_777 * _788);
    _797 = (_778 * _788);
    _798 = (_779 * _788);
    _799 = (_770 * _788);
    _800 = (_771 * _788);
    _801 = (_772 * _788);
  }
  SV_Target.x = ((cb0_109x * (lerp(_796, _799, _763))) + _745);
  SV_Target.y = ((cb0_109x * (lerp(_797, _800, _763))) + _746);
  SV_Target.z = (((lerp(_798, _801, _763)) * cb0_109x) + _747);
  SV_Target.xyz = wuwa::ApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = dot(float3(_660, _659, _658), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
