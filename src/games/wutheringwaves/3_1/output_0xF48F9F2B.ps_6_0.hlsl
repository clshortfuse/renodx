#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture3D<float4> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

Texture3D<float4> t7 : register(t7);

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
  float cb0_111x : packoffset(c111.x);
  float cb0_111y : packoffset(c111.y);
  float cb0_111z : packoffset(c111.z);
  int cb0_111w : packoffset(c111.w);
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
  float _45 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _48 = frac(sin(_45) * 493013.0f);
  float _70;
  float _71;
  float _157;
  float _158;
  float _252;
  float _253;
  float _312;
  float _383;
  float _384;
  float _385;
  float _518;
  float _519;
  float _520;
  float _553;
  float _554;
  float _555;
  float _587;
  float _588;
  float _589;
  float _636;
  float _637;
  float _638;
  float _653;
  float _654;
  float _655;
  float _742;
  float _743;
  float _744;
  float _829;
  float _830;
  float _831;
  if (cb0_096x > 0.0f) {
    _70 = (((frac((sin(_45 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _48) * cb0_096x) + _48);
    _71 = (((frac((sin(_45 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _48) * cb0_096x) + _48);
  } else {
    _70 = _48;
    _71 = _48;
  }
  float _76 = cb0_095z * (1.0f - (_48 * _48));
  float _81 = (_76 * (TEXCOORD_2.x - _42)) + _42;
  float _82 = (_76 * (TEXCOORD_2.y - _43)) + _43;
  float _97 = _81 - (((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x);
  float _98 = _82 - (((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y);
  float _108 = cb0_118z * cb0_117x;
  float _109 = cb0_118z * cb0_117y;
  bool _110 = (cb0_118x == 0.0f);
  float _120 = (cb0_114z * TEXCOORD_3.x) + cb0_114x;
  float _121 = (cb0_114w * TEXCOORD_3.y) + cb0_114y;
  float _140 = float((int)(((int)(uint)((bool)(_120 > 0.0f))) - ((int)(uint)((bool)(_120 < 0.0f))))) * saturate(abs(_120) - cb0_117z);
  float _142 = float((int)(((int)(uint)((bool)(_121 > 0.0f))) - ((int)(uint)((bool)(_121 < 0.0f))))) * saturate(abs(_121) - cb0_117z);
  float _147 = _121 - (_142 * _108);
  float _149 = _121 - (_142 * _109);
  bool _150 = (cb0_118x > 0.0f);
  if (_150) {
    _157 = (_147 - (cb0_118w * 0.4000000059604645f));
    _158 = (_149 - (cb0_118w * 0.20000000298023224f));
  } else {
    _157 = _147;
    _158 = _149;
  }
  float4 _194 = t0.Sample(s0, float2(min(max(_81, cb0_053z), cb0_054x), min(max(_82, cb0_053w), cb0_054y)));
  float4 _210 = t0.Sample(s0, float2(min(max(((((((cb0_115z * (_120 - (_140 * select(_110, _108, cb0_117x)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x) + _97), cb0_053z), cb0_054x), min(max(((((((cb0_115w * _157) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y) + _98), cb0_053w), cb0_054y)));
  float4 _224 = t0.Sample(s0, float2(min(max(((((((cb0_115z * (_120 - (_140 * select(_110, _109, cb0_117y)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x) + _97), cb0_053z), cb0_054x), min(max(((((((cb0_115w * _158) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y) + _98), cb0_053w), cb0_054y)));
  if (_150) {
    float _234 = saturate(((((_194.y * 0.5870000123977661f) - cb0_118y) + (_194.x * 0.29899999499320984f)) + (_194.z * 0.11400000005960464f)) * 10.0f);
    float _238 = (_234 * _234) * (3.0f - (_234 * 2.0f));
    _252 = ((((_194.x - _210.x) + (_238 * (_210.x - _194.x))) * cb0_118x) + _210.x);
    _253 = ((((_194.y - _224.y) + (_238 * (_224.y - _194.y))) * cb0_118x) + _224.y);
  } else {
    _252 = _210.x;
    _253 = _224.y;
  }
  float _262 = log2(max(dot(float3(_252, _253, _194.z), float3(cb0_043x, cb0_043y, cb0_043z)), cb0_042x));
  float4 _280 = t4.Sample(s4, float3((cb0_046z * TEXCOORD_4.x), (cb0_046w * TEXCOORD_4.y), ((((cb0_041z * _262) + cb0_041w) * 0.96875f) + 0.015625f)));
  float4 _284 = t5.Sample(s5, float2(TEXCOORD_4.x, TEXCOORD_4.y));
  float _287 = select((_280.y < 0.0010000000474974513f), _284.x, (_280.x / _280.y));
  float _290 = log2(TEXCOORD_1.x);
  float _292 = (_287 + _290) + ((_284.x - _287) * cb0_046x);
  float _297 = _290 + _262;
  float _299 = _292 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_046y);
  bool _300 = (_299 > 0.0f);
  if (_300) {
    _312 = max(0.0f, (_299 - cb0_047x));
  } else {
    _312 = min(0.0f, (_299 + cb0_047y));
  }
  float4 _344 = t1.Sample(s1, float2(min(max(((cb0_068z * _81) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _82) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_344);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _372 = (cb0_085w != 0);
    float4 _375 = t2.Sample(s2, float2(select(_372, _81, min(max(((cb0_076z * _81) + cb0_077x), cb0_075z), cb0_076x)), select(_372, _82, min(max(((cb0_076w * _82) + cb0_077y), cb0_075w), cb0_076y))));
    _383 = (_375.x + _344.x);
    _384 = (_375.y + _344.y);
    _385 = (_375.z + _344.z);
  } else {
    _383 = _344.x;
    _384 = _344.y;
    _385 = _344.z;
  }
  float _386 = exp2((((_292 - _297) + ((_297 - _292) * cb0_045w)) - _312) + (_312 * select(_300, cb0_045y, cb0_045z))) * TEXCOORD_1.x;
  float _411 = TEXCOORD_1.z + -1.0f;
  float _413 = TEXCOORD_1.w + -1.0f;
  float _416 = (((cb0_090x * 2.0f) + _411) * cb0_088z) * cb0_088x;
  float _418 = (((cb0_090y * 2.0f) + _413) * cb0_088w) * cb0_088x;
  float _425 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_416, _418), float2(_416, _418))) + 1.0f);
  float _426 = _425 * _425;
  float _427 = cb0_090z + 1.0f;
  float _455 = (((cb0_093x * 2.0f) + _411) * cb0_091z) * cb0_091x;
  float _457 = (((cb0_093y * 2.0f) + _413) * cb0_091w) * cb0_091x;
  float _464 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_455, _457), float2(_455, _457))) + 1.0f);
  float _465 = _464 * _464;
  float _466 = cb0_093z + 1.0f;
  float _487 = ((((_426 * (_427 - cb0_089x)) + cb0_089x) * (_383 + ((_386 * _252) * cb0_086x))) * ((_465 * (_466 - cb0_092x)) + cb0_092x)) * ((cb0_095x * _48) + cb0_095y);
  float _490 = ((((_426 * (_427 - cb0_089y)) + cb0_089y) * (_384 + ((_386 * _253) * cb0_086y))) * ((_465 * (_466 - cb0_092y)) + cb0_092y)) * ((cb0_095x * _70) + cb0_095y);
  float _493 = ((((_426 * (_427 - cb0_089z)) + cb0_089z) * (_385 + ((_386 * _194.z) * cb0_086z))) * ((_465 * (_466 - cb0_092z)) + cb0_092z)) * ((cb0_095x * _71) + cb0_095y);
  [branch]
  if (!(cb0_111w == 0)) {
    float _507 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _518 = (1.0f - exp2(_507 * _487));
    _519 = (1.0f - exp2(_507 * _490));
    _520 = (1.0f - exp2(_507 * _493));
  } else {
    _518 = _487;
    _519 = _490;
    _520 = _493;
  }

  CAPTURE_UNTONEMAPPED(float3(_518, _519, _520));
  [branch]
  if (WUWA_TM_IS(1)) {
    _553 = ((((_518 * 1.3600000143051147f) + 0.04699999839067459f) * _518) / ((((_518 * 0.9599999785423279f) + 0.5600000023841858f) * _518) + 0.14000000059604645f));
    _554 = ((((_519 * 1.3600000143051147f) + 0.04699999839067459f) * _519) / ((((_519 * 0.9599999785423279f) + 0.5600000023841858f) * _519) + 0.14000000059604645f));
    _555 = ((((_520 * 1.3600000143051147f) + 0.04699999839067459f) * _520) / ((((_520 * 0.9599999785423279f) + 0.5600000023841858f) * _520) + 0.14000000059604645f));
  } else {
    _553 = _518;
    _554 = _519;
    _555 = _520;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _565 = 1.0049500465393066f - (0.16398000717163086f / (_553 + -0.19505000114440918f));
    float _566 = 1.0049500465393066f - (0.16398000717163086f / (_554 + -0.19505000114440918f));
    float _567 = 1.0049500465393066f - (0.16398000717163086f / (_555 + -0.19505000114440918f));
    _587 = (((_553 - _565) * select((_553 > 0.6000000238418579f), 0.0f, 1.0f)) + _565);
    _588 = (((_554 - _566) * select((_554 > 0.6000000238418579f), 0.0f, 1.0f)) + _566);
    _589 = (((_555 - _567) * select((_555 > 0.6000000238418579f), 0.0f, 1.0f)) + _567);
  } else {
    _587 = _553;
    _588 = _554;
    _589 = _555;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _595 = cb0_037y * _587;
    float _596 = cb0_037y * _588;
    float _597 = cb0_037y * _589;
    float _600 = cb0_037z * cb0_037w;
    float _610 = cb0_038y * cb0_038x;
    float _621 = cb0_038z * cb0_038x;
    float _628 = cb0_038y / cb0_038z;
    _636 = (((((_600 + _595) * _587) + _610) / (((_595 + cb0_037z) * _587) + _621)) - _628);
    _637 = (((((_600 + _596) * _588) + _610) / (((_596 + cb0_037z) * _588) + _621)) - _628);
    _638 = (((((_600 + _597) * _589) + _610) / (((_597 + cb0_037z) * _589) + _621)) - _628);
  } else {
    _636 = _587;
    _637 = _588;
    _638 = _589;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _648 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _653 = (_648 * _636);
      _654 = (_648 * _637);
      _655 = (_648 * _638);
    } else {
      _653 = _636;
      _654 = _637;
      _655 = _638;
    }
  } else {
    _653 = _636;
    _654 = _637;
    _655 = _638;
  }
  CLAMP_IF_SDR3(_653, _654, _655);
  CAPTURE_TONEMAPPED(float3(_653, _654, _655));
  float _670 = (saturate((log2(_655 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _674 = (saturate((log2(_654 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _678 = (saturate((log2(_653 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!(cb0_107w == 0)) {
    float4 _699 = t3.Sample(s3, float2(min(max(((cb0_084z * _81) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _82) + cb0_085y), cb0_083w), cb0_084y)));
    float _709 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_699.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _710 = t7.Sample(s7, float3(_678, _674, _670));
    float4 _717 = t6.Sample(s6, float3(_678, _674, _670));
    _742 = ((((_717.x - _710.x) * 1.0499999523162842f) * _709) + (_710.x * 1.0499999523162842f));
    _743 = ((((_717.y - _710.y) * 1.0499999523162842f) * _709) + (_710.y * 1.0499999523162842f));
    _744 = ((((_717.z - _710.z) * 1.0499999523162842f) * _709) + (_710.z * 1.0499999523162842f));
  } else {
    float4 _734 = t6.Sample(s6, float3(_678, _674, _670));
    _742 = (_734.x * 1.0499999523162842f);
    _743 = (_734.y * 1.0499999523162842f);
    _744 = (_734.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3_FADE(_742, _743, _744, t6, s6);
  float _752 = ((_48 * 0.00390625f) + -0.001953125f) + _742;
  float _753 = ((_70 * 0.00390625f) + -0.001953125f) + _743;
  float _754 = ((_71 * 0.00390625f) + -0.001953125f) + _744;
  [branch]
  if (!(cb0_106w == 0)) {
    float _766 = (pow(_752, 0.012683313339948654f));
    float _767 = (pow(_753, 0.012683313339948654f));
    float _768 = (pow(_754, 0.012683313339948654f));
    float _801 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_766 + -0.8359375f)) / (18.8515625f - (_766 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _802 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_767 + -0.8359375f)) / (18.8515625f - (_767 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _803 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_768 + -0.8359375f)) / (18.8515625f - (_768 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _829 = min((_801 * 12.920000076293945f), ((exp2(log2(max(_801, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _830 = min((_802 * 12.920000076293945f), ((exp2(log2(max(_802, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _831 = min((_803 * 12.920000076293945f), ((exp2(log2(max(_803, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _829 = _752;
    _830 = _753;
    _831 = _754;
  }
  SV_Target.x = _829;
  SV_Target.y = _830;
  SV_Target.z = _831;
  SV_Target.w = dot(float3(_742, _743, _744), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
