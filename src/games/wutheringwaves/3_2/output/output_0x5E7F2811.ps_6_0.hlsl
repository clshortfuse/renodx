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

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _37 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _38 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _39 = TEXCOORD_2.w * 543.3099975585938f;
  float _43 = frac(sin(_39 + TEXCOORD_2.z) * 493013.0f);
  float _67;
  float _68;
  float _156;
  float _157;
  float _251;
  float _252;
  float _317;
  float _318;
  float _319;
  float _331;
  float _332;
  float _333;
  float _461;
  float _462;
  float _463;
  float _495;
  float _496;
  float _497;
  float _544;
  float _545;
  float _546;
  float _561;
  float _562;
  float _563;
  float _636;
  float _637;
  float _638;
  float _726;
  float _727;
  float _728;
  float _777;
  float _778;
  float _779;
  float _780;
  float _781;
  float _782;
  if (cb0_097x > 0.0f) {
    _67 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _39) * 493013.0f) + 7.177000045776367f) - _43)) + _43);
    _68 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _39) * 493013.0f) + 14.298999786376953f) - _43)) + _43);
  } else {
    _67 = _43;
    _68 = _43;
  }
  float _73 = cb0_096z * (1.0f - (_43 * _43));
  float _78 = (_73 * (TEXCOORD_2.x - _37)) + _37;
  float _79 = (_73 * (TEXCOORD_2.y - _38)) + _38;
  float _94 = _78 - (((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x);
  float _95 = _79 - (((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y);
  float _105 = cb0_118z * cb0_117x;
  float _106 = cb0_118z * cb0_117y;
  bool _107 = (cb0_118x == 0.0f);
  float _117 = (cb0_114z * TEXCOORD_3.x) + cb0_114x;
  float _118 = (cb0_114w * TEXCOORD_3.y) + cb0_114y;
  float _129 = float((int)(((int)(uint)((bool)(_117 > 0.0f))) - ((int)(uint)((bool)(_117 < 0.0f)))));
  float _130 = float((int)(((int)(uint)((bool)(_118 > 0.0f))) - ((int)(uint)((bool)(_118 < 0.0f)))));
  float _135 = saturate(abs(_117) - cb0_117z);
  float _136 = saturate(abs(_118) - cb0_117z);
  float _146 = _118 - ((_136 * _105) * _130);
  float _148 = _118 - ((_136 * _106) * _130);
  bool _149 = (cb0_118x > 0.0f);
  if (_149) {
    _156 = (_146 - (cb0_118w * 0.4000000059604645f));
    _157 = (_148 - (cb0_118w * 0.20000000298023224f));
  } else {
    _156 = _146;
    _157 = _148;
  }
  float4 _193 = t0.Sample(s0, float2(min(max(_78, cb0_053z), cb0_054x), min(max(_79, cb0_053w), cb0_054y)));
  float4 _209 = t0.Sample(s0, float2(min(max(((((cb0_048z * ((cb0_115z * (_117 - ((_135 * select(_107, _105, cb0_117x)) * _129))) + cb0_115x)) + cb0_049x) * cb0_048x) + _94), cb0_053z), cb0_054x), min(max(((((cb0_048w * ((cb0_115w * _156) + cb0_115y)) + cb0_049y) * cb0_048y) + _95), cb0_053w), cb0_054y)));
  float4 _223 = t0.Sample(s0, float2(min(max(((((cb0_048z * ((cb0_115z * (_117 - ((_135 * select(_107, _106, cb0_117y)) * _129))) + cb0_115x)) + cb0_049x) * cb0_048x) + _94), cb0_053z), cb0_054x), min(max(((((cb0_048w * ((cb0_115w * _157) + cb0_115y)) + cb0_049y) * cb0_048y) + _95), cb0_053w), cb0_054y)));
  if (_149) {
    float _233 = saturate(((((_193.y * 0.5870000123977661f) - cb0_118y) + (_193.x * 0.29899999499320984f)) + (_193.z * 0.11400000005960464f)) * 10.0f);
    float _237 = (_233 * _233) * (3.0f - (_233 * 2.0f));
    _251 = ((((_193.x - _209.x) + (_237 * (_209.x - _193.x))) * cb0_118x) + _209.x);
    _252 = ((((_193.y - _223.y) + (_237 * (_223.y - _193.y))) * cb0_118x) + _223.y);
  } else {
    _251 = _209.x;
    _252 = _223.y;
  }
  float4 _277 = t1.Sample(s1, float2(min(max(((cb0_068z * _78) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _79) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_277);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _306 = (cb0_086x != 0);
    float4 _309 = t2.Sample(s2, float2(select(_306, _78, min(max(((cb0_076z * _78) + cb0_077x), cb0_075z), cb0_076x)), select(_306, _79, min(max(((cb0_076w * _79) + cb0_077y), cb0_075w), cb0_076y))));
    _317 = (_309.x + _277.x);
    _318 = (_309.y + _277.y);
    _319 = (_309.z + _277.z);
  } else {
    _317 = _277.x;
    _318 = _277.y;
    _319 = _277.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _323 = t3.Sample(s3, float2(_78, _79));
    _331 = (_323.x + _317);
    _332 = (_323.y + _318);
    _333 = (_323.z + _319);
  } else {
    _331 = _317;
    _332 = _318;
    _333 = _319;
  }
  float _358 = TEXCOORD_1.z + -1.0f;
  float _360 = TEXCOORD_1.w + -1.0f;
  float _363 = ((_358 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _365 = ((_360 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _372 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_363, _365), float2(_363, _365))) + 1.0f);
  float _373 = _372 * _372;
  float _374 = cb0_091z + 1.0f;
  float _402 = ((_358 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _404 = ((_360 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _411 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_402, _404), float2(_402, _404))) + 1.0f);
  float _412 = _411 * _411;
  float _413 = cb0_094z + 1.0f;
  float _424 = (((_373 * (_374 - cb0_090x)) + cb0_090x) * (_331 + ((_251 * TEXCOORD_1.x) * cb0_087x))) * ((_412 * (_413 - cb0_093x)) + cb0_093x);
  float _426 = (((_373 * (_374 - cb0_090y)) + cb0_090y) * (_332 + ((_252 * TEXCOORD_1.x) * cb0_087y))) * ((_412 * (_413 - cb0_093y)) + cb0_093y);
  float _428 = (((_373 * (_374 - cb0_090z)) + cb0_090z) * (_333 + ((_193.z * TEXCOORD_1.x) * cb0_087z))) * ((_412 * (_413 - cb0_093z)) + cb0_093z);

  CAPTURE_UNTONEMAPPED(float3(_424, _426, _428));
  [branch]
  if (WUWA_TM_IS(1)) {
    _461 = ((((_424 * 1.3600000143051147f) + 0.04699999839067459f) * _424) / ((((_424 * 0.9599999785423279f) + 0.5600000023841858f) * _424) + 0.14000000059604645f));
    _462 = ((((_426 * 1.3600000143051147f) + 0.04699999839067459f) * _426) / ((((_426 * 0.9599999785423279f) + 0.5600000023841858f) * _426) + 0.14000000059604645f));
    _463 = ((((_428 * 1.3600000143051147f) + 0.04699999839067459f) * _428) / ((((_428 * 0.9599999785423279f) + 0.5600000023841858f) * _428) + 0.14000000059604645f));
  } else {
    _461 = _424;
    _462 = _426;
    _463 = _428;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _473 = 1.0049500465393066f - (0.16398000717163086f / (_461 + -0.19505000114440918f));
    float _474 = 1.0049500465393066f - (0.16398000717163086f / (_462 + -0.19505000114440918f));
    float _475 = 1.0049500465393066f - (0.16398000717163086f / (_463 + -0.19505000114440918f));
    _495 = (((_461 - _473) * select((_461 > 0.6000000238418579f), 0.0f, 1.0f)) + _473);
    _496 = (((_462 - _474) * select((_462 > 0.6000000238418579f), 0.0f, 1.0f)) + _474);
    _497 = (((_463 - _475) * select((_463 > 0.6000000238418579f), 0.0f, 1.0f)) + _475);
  } else {
    _495 = _461;
    _496 = _462;
    _497 = _463;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _503 = cb0_037y * _495;
    float _504 = cb0_037y * _496;
    float _505 = cb0_037y * _497;
    float _508 = cb0_037z * cb0_037w;
    float _518 = cb0_038y * cb0_038x;
    float _529 = cb0_038z * cb0_038x;
    float _536 = cb0_038y / cb0_038z;
    _544 = (((((_508 + _503) * _495) + _518) / (_529 + ((_503 + cb0_037z) * _495))) - _536);
    _545 = (((((_508 + _504) * _496) + _518) / (_529 + ((_504 + cb0_037z) * _496))) - _536);
    _546 = (((((_508 + _505) * _497) + _518) / (_529 + ((_505 + cb0_037z) * _497))) - _536);
  } else {
    _544 = _495;
    _545 = _496;
    _546 = _497;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _556 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _561 = (_556 * _544);
      _562 = (_556 * _545);
      _563 = (_556 * _546);
    } else {
      _561 = _544;
      _562 = _545;
      _563 = _546;
    }
  } else {
    _561 = _544;
    _562 = _545;
    _563 = _546;
  }
  CLAMP_IF_SDR3(_561, _562, _563);
  CAPTURE_TONEMAPPED(float3(_561, _562, _563));
  float _584 = (saturate((log2(_561 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _585 = (saturate((log2(_562 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _586 = (saturate((log2(_563 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _587 = t5.Sample(s5, float3(_584, _585, _586));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _611 = t4.Sample(s4, float2(min(max(((cb0_084z * _78) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _79) + cb0_085y), cb0_083w), cb0_084y)));
    float _621 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_611.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _622 = t6.Sample(s6, float3(_584, _585, _586));
    _636 = (lerp(_622.x, _587.x, _621));
    _637 = (lerp(_622.y, _587.y, _621));
    _638 = (lerp(_622.z, _587.z, _621));
  } else {
    _636 = _587.x;
    _637 = _587.y;
    _638 = _587.z;
  }
  HANDLE_LUT_OUTPUT3_FADE(_636, _637, _638, t5, s5);
  float _639 = _638 * 1.0499999523162842f;
  float _640 = _637 * 1.0499999523162842f;
  float _641 = _636 * 1.0499999523162842f;
  float _649 = ((_43 * 0.00390625f) + -0.001953125f) + _641;
  float _650 = ((_67 * 0.00390625f) + -0.001953125f) + _640;
  float _651 = ((_68 * 0.00390625f) + -0.001953125f) + _639;
  [branch]
  if (!(cb0_107w == 0)) {
    float _663 = (pow(_649, 0.012683313339948654f));
    float _664 = (pow(_650, 0.012683313339948654f));
    float _665 = (pow(_651, 0.012683313339948654f));
    float _698 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_663 + -0.8359375f)) / (18.8515625f - (_663 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _699 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_664 + -0.8359375f)) / (18.8515625f - (_664 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _700 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_665 + -0.8359375f)) / (18.8515625f - (_665 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _726 = min((_698 * 12.920000076293945f), ((exp2(log2(max(_698, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _727 = min((_699 * 12.920000076293945f), ((exp2(log2(max(_699, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _728 = min((_700 * 12.920000076293945f), ((exp2(log2(max(_700, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _726 = _649;
    _727 = _650;
    _728 = _651;
  }
  float _737 = ((((_727 * 587.0f) + (_726 * 299.0f)) + (_728 * 114.0f)) * 0.0010000000474974513f) - cb0_109z;
  float _744 = saturate(float((int)(((int)(uint)((bool)(_737 > 0.0f))) - ((int)(uint)((bool)(_737 < 0.0f))))));
  float _751 = cb0_110x - _726;
  float _752 = cb0_110y - _727;
  float _753 = cb0_110z - _728;
  float _758 = cb0_111x - _726;
  float _759 = cb0_111y - _727;
  float _760 = cb0_111z - _728;
  [branch]
  if (cb0_109y > 0.0f) {
    _777 = (_751 * cb0_109y);
    _778 = (_752 * cb0_109y);
    _779 = (_753 * cb0_109y);
    _780 = (_758 * cb0_109y);
    _781 = (_759 * cb0_109y);
    _782 = (_760 * cb0_109y);
  } else {
    float _769 = abs(cb0_109y);
    _777 = (_758 * _769);
    _778 = (_759 * _769);
    _779 = (_760 * _769);
    _780 = (_751 * _769);
    _781 = (_752 * _769);
    _782 = (_753 * _769);
  }
  SV_Target.x = ((cb0_109x * (lerp(_777, _780, _744))) + _726);
  SV_Target.y = ((cb0_109x * (lerp(_778, _781, _744))) + _727);
  SV_Target.z = (((lerp(_779, _782, _744)) * cb0_109x) + _728);
  SV_Target.w = dot(float3(_641, _640, _639), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
