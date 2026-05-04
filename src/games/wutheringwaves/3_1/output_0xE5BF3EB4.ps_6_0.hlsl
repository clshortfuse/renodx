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
  float _155;
  float _226;
  float _227;
  float _228;
  float _361;
  float _362;
  float _363;
  float _396;
  float _397;
  float _398;
  float _430;
  float _431;
  float _432;
  float _479;
  float _480;
  float _481;
  float _496;
  float _497;
  float _498;
  float _585;
  float _586;
  float _587;
  float _672;
  float _673;
  float _674;
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
  float4 _93 = t0.Sample(s0, float2(min(max(_81, cb0_053z), cb0_054x), min(max(_82, cb0_053w), cb0_054y)));
  float _105 = log2(max(dot(float3(_93.x, _93.y, _93.z), float3(cb0_043x, cb0_043y, cb0_043z)), cb0_042x));
  float4 _123 = t4.Sample(s4, float3((cb0_046z * TEXCOORD_4.x), (cb0_046w * TEXCOORD_4.y), ((((cb0_041z * _105) + cb0_041w) * 0.96875f) + 0.015625f)));
  float4 _127 = t5.Sample(s5, float2(TEXCOORD_4.x, TEXCOORD_4.y));
  float _130 = select((_123.y < 0.0010000000474974513f), _127.x, (_123.x / _123.y));
  float _133 = log2(TEXCOORD_1.x);
  float _135 = (_130 + _133) + ((_127.x - _130) * cb0_046x);
  float _140 = _133 + _105;
  float _142 = _135 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_046y);
  bool _143 = (_142 > 0.0f);
  if (_143) {
    _155 = max(0.0f, (_142 - cb0_047x));
  } else {
    _155 = min(0.0f, (_142 + cb0_047y));
  }
  float4 _187 = t1.Sample(s1, float2(min(max(((cb0_068z * _81) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _82) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_187);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _215 = (cb0_085w != 0);
    float4 _218 = t2.Sample(s2, float2(select(_215, _81, min(max(((cb0_076z * _81) + cb0_077x), cb0_075z), cb0_076x)), select(_215, _82, min(max(((cb0_076w * _82) + cb0_077y), cb0_075w), cb0_076y))));
    _226 = (_218.x + _187.x);
    _227 = (_218.y + _187.y);
    _228 = (_218.z + _187.z);
  } else {
    _226 = _187.x;
    _227 = _187.y;
    _228 = _187.z;
  }
  float _229 = exp2((((_135 - _140) + ((_140 - _135) * cb0_045w)) - _155) + (_155 * select(_143, cb0_045y, cb0_045z))) * TEXCOORD_1.x;
  float _254 = TEXCOORD_1.z + -1.0f;
  float _256 = TEXCOORD_1.w + -1.0f;
  float _259 = (((cb0_090x * 2.0f) + _254) * cb0_088z) * cb0_088x;
  float _261 = (((cb0_090y * 2.0f) + _256) * cb0_088w) * cb0_088x;
  float _268 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_259, _261), float2(_259, _261))) + 1.0f);
  float _269 = _268 * _268;
  float _270 = cb0_090z + 1.0f;
  float _298 = (((cb0_093x * 2.0f) + _254) * cb0_091z) * cb0_091x;
  float _300 = (((cb0_093y * 2.0f) + _256) * cb0_091w) * cb0_091x;
  float _307 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_298, _300), float2(_298, _300))) + 1.0f);
  float _308 = _307 * _307;
  float _309 = cb0_093z + 1.0f;
  float _330 = ((((_269 * (_270 - cb0_089x)) + cb0_089x) * (_226 + ((_229 * _93.x) * cb0_086x))) * ((_308 * (_309 - cb0_092x)) + cb0_092x)) * ((cb0_095x * _48) + cb0_095y);
  float _333 = ((((_269 * (_270 - cb0_089y)) + cb0_089y) * (_227 + ((_229 * _93.y) * cb0_086y))) * ((_308 * (_309 - cb0_092y)) + cb0_092y)) * ((cb0_095x * _70) + cb0_095y);
  float _336 = ((((_269 * (_270 - cb0_089z)) + cb0_089z) * (_228 + ((_229 * _93.z) * cb0_086z))) * ((_308 * (_309 - cb0_092z)) + cb0_092z)) * ((cb0_095x * _71) + cb0_095y);

  CAPTURE_UNTONEMAPPED(float3(_330, _333, _336));
  [branch]
  if (!(cb0_111w == 0)) {
    float _350 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _361 = (1.0f - exp2(_350 * _330));
    _362 = (1.0f - exp2(_350 * _333));
    _363 = (1.0f - exp2(_350 * _336));
  } else {
    _361 = _330;
    _362 = _333;
    _363 = _336;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _396 = ((((_361 * 1.3600000143051147f) + 0.04699999839067459f) * _361) / ((((_361 * 0.9599999785423279f) + 0.5600000023841858f) * _361) + 0.14000000059604645f));
    _397 = ((((_362 * 1.3600000143051147f) + 0.04699999839067459f) * _362) / ((((_362 * 0.9599999785423279f) + 0.5600000023841858f) * _362) + 0.14000000059604645f));
    _398 = ((((_363 * 1.3600000143051147f) + 0.04699999839067459f) * _363) / ((((_363 * 0.9599999785423279f) + 0.5600000023841858f) * _363) + 0.14000000059604645f));
  } else {
    _396 = _361;
    _397 = _362;
    _398 = _363;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _408 = 1.0049500465393066f - (0.16398000717163086f / (_396 + -0.19505000114440918f));
    float _409 = 1.0049500465393066f - (0.16398000717163086f / (_397 + -0.19505000114440918f));
    float _410 = 1.0049500465393066f - (0.16398000717163086f / (_398 + -0.19505000114440918f));
    _430 = (((_396 - _408) * select((_396 > 0.6000000238418579f), 0.0f, 1.0f)) + _408);
    _431 = (((_397 - _409) * select((_397 > 0.6000000238418579f), 0.0f, 1.0f)) + _409);
    _432 = (((_398 - _410) * select((_398 > 0.6000000238418579f), 0.0f, 1.0f)) + _410);
  } else {
    _430 = _396;
    _431 = _397;
    _432 = _398;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _438 = cb0_037y * _430;
    float _439 = cb0_037y * _431;
    float _440 = cb0_037y * _432;
    float _443 = cb0_037z * cb0_037w;
    float _453 = cb0_038y * cb0_038x;
    float _464 = cb0_038z * cb0_038x;
    float _471 = cb0_038y / cb0_038z;
    _479 = (((((_443 + _438) * _430) + _453) / (((_438 + cb0_037z) * _430) + _464)) - _471);
    _480 = (((((_443 + _439) * _431) + _453) / (((_439 + cb0_037z) * _431) + _464)) - _471);
    _481 = (((((_443 + _440) * _432) + _453) / (((_440 + cb0_037z) * _432) + _464)) - _471);
  } else {
    _479 = _430;
    _480 = _431;
    _481 = _432;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _491 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _496 = (_491 * _479);
      _497 = (_491 * _480);
      _498 = (_491 * _481);
    } else {
      _496 = _479;
      _497 = _480;
      _498 = _481;
    }
  } else {
    _496 = _479;
    _497 = _480;
    _498 = _481;
  }
  CLAMP_IF_SDR3(_496, _497, _498);
  CAPTURE_TONEMAPPED(float3(_496, _497, _498));
  float _513 = (saturate((log2(_498 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _517 = (saturate((log2(_497 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _521 = (saturate((log2(_496 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!(cb0_107w == 0)) {
    float4 _542 = t3.Sample(s3, float2(min(max(((cb0_084z * _81) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _82) + cb0_085y), cb0_083w), cb0_084y)));
    float _552 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_542.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _553 = t7.Sample(s7, float3(_521, _517, _513));
    float4 _560 = t6.Sample(s6, float3(_521, _517, _513));
    _585 = ((((_560.x - _553.x) * 1.0499999523162842f) * _552) + (_553.x * 1.0499999523162842f));
    _586 = ((((_560.y - _553.y) * 1.0499999523162842f) * _552) + (_553.y * 1.0499999523162842f));
    _587 = ((((_560.z - _553.z) * 1.0499999523162842f) * _552) + (_553.z * 1.0499999523162842f));
  } else {
    float4 _577 = t6.Sample(s6, float3(_521, _517, _513));
    _585 = (_577.x * 1.0499999523162842f);
    _586 = (_577.y * 1.0499999523162842f);
    _587 = (_577.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3_FADE(_585, _586, _587, t6, s6);
  float _595 = ((_48 * 0.00390625f) + -0.001953125f) + _585;
  float _596 = ((_70 * 0.00390625f) + -0.001953125f) + _586;
  float _597 = ((_71 * 0.00390625f) + -0.001953125f) + _587;
  [branch]
  if (!(cb0_106w == 0)) {
    float _609 = (pow(_595, 0.012683313339948654f));
    float _610 = (pow(_596, 0.012683313339948654f));
    float _611 = (pow(_597, 0.012683313339948654f));
    float _644 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_609 + -0.8359375f)) / (18.8515625f - (_609 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _645 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_610 + -0.8359375f)) / (18.8515625f - (_610 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _646 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_611 + -0.8359375f)) / (18.8515625f - (_611 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _672 = min((_644 * 12.920000076293945f), ((exp2(log2(max(_644, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _673 = min((_645 * 12.920000076293945f), ((exp2(log2(max(_645, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _674 = min((_646 * 12.920000076293945f), ((exp2(log2(max(_646, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _672 = _595;
    _673 = _596;
    _674 = _597;
  }
  SV_Target.x = _672;
  SV_Target.y = _673;
  SV_Target.z = _674;
  SV_Target.w = (dot(float3(_585, _586, _587), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
