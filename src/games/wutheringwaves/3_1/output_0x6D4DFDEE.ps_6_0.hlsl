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
  float _349;
  float _350;
  float _351;
  float _384;
  float _385;
  float _386;
  float _418;
  float _419;
  float _420;
  float _467;
  float _468;
  float _469;
  float _484;
  float _485;
  float _486;
  float _573;
  float _574;
  float _575;
  float _660;
  float _661;
  float _662;
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
  float _320 = (((_269 * (_270 - cb0_089x)) + cb0_089x) * (_226 + ((_229 * _93.x) * cb0_086x))) * ((_308 * (_309 - cb0_092x)) + cb0_092x);
  float _322 = (((_269 * (_270 - cb0_089y)) + cb0_089y) * (_227 + ((_229 * _93.y) * cb0_086y))) * ((_308 * (_309 - cb0_092y)) + cb0_092y);
  float _324 = (((_269 * (_270 - cb0_089z)) + cb0_089z) * (_228 + ((_229 * _93.z) * cb0_086z))) * ((_308 * (_309 - cb0_092z)) + cb0_092z);

  CAPTURE_UNTONEMAPPED(float3(_320, _322, _324));
  [branch]
  if (!(cb0_111w == 0)) {
    float _338 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _349 = (1.0f - exp2(_338 * _320));
    _350 = (1.0f - exp2(_338 * _322));
    _351 = (1.0f - exp2(_338 * _324));
  } else {
    _349 = _320;
    _350 = _322;
    _351 = _324;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _384 = ((((_349 * 1.3600000143051147f) + 0.04699999839067459f) * _349) / ((((_349 * 0.9599999785423279f) + 0.5600000023841858f) * _349) + 0.14000000059604645f));
    _385 = ((((_350 * 1.3600000143051147f) + 0.04699999839067459f) * _350) / ((((_350 * 0.9599999785423279f) + 0.5600000023841858f) * _350) + 0.14000000059604645f));
    _386 = ((((_351 * 1.3600000143051147f) + 0.04699999839067459f) * _351) / ((((_351 * 0.9599999785423279f) + 0.5600000023841858f) * _351) + 0.14000000059604645f));
  } else {
    _384 = _349;
    _385 = _350;
    _386 = _351;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _396 = 1.0049500465393066f - (0.16398000717163086f / (_384 + -0.19505000114440918f));
    float _397 = 1.0049500465393066f - (0.16398000717163086f / (_385 + -0.19505000114440918f));
    float _398 = 1.0049500465393066f - (0.16398000717163086f / (_386 + -0.19505000114440918f));
    _418 = (((_384 - _396) * select((_384 > 0.6000000238418579f), 0.0f, 1.0f)) + _396);
    _419 = (((_385 - _397) * select((_385 > 0.6000000238418579f), 0.0f, 1.0f)) + _397);
    _420 = (((_386 - _398) * select((_386 > 0.6000000238418579f), 0.0f, 1.0f)) + _398);
  } else {
    _418 = _384;
    _419 = _385;
    _420 = _386;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _426 = cb0_037y * _418;
    float _427 = cb0_037y * _419;
    float _428 = cb0_037y * _420;
    float _431 = cb0_037z * cb0_037w;
    float _441 = cb0_038y * cb0_038x;
    float _452 = cb0_038z * cb0_038x;
    float _459 = cb0_038y / cb0_038z;
    _467 = (((((_431 + _426) * _418) + _441) / (((_426 + cb0_037z) * _418) + _452)) - _459);
    _468 = (((((_431 + _427) * _419) + _441) / (((_427 + cb0_037z) * _419) + _452)) - _459);
    _469 = (((((_431 + _428) * _420) + _441) / (((_428 + cb0_037z) * _420) + _452)) - _459);
  } else {
    _467 = _418;
    _468 = _419;
    _469 = _420;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _479 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _484 = (_479 * _467);
      _485 = (_479 * _468);
      _486 = (_479 * _469);
    } else {
      _484 = _467;
      _485 = _468;
      _486 = _469;
    }
  } else {
    _484 = _467;
    _485 = _468;
    _486 = _469;
  }
  CLAMP_IF_SDR3(_484, _485, _486);
  CAPTURE_TONEMAPPED(float3(_484, _485, _486));
  float _501 = (saturate((log2(_486 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _505 = (saturate((log2(_485 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _509 = (saturate((log2(_484 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!(cb0_107w == 0)) {
    float4 _530 = t3.Sample(s3, float2(min(max(((cb0_084z * _81) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _82) + cb0_085y), cb0_083w), cb0_084y)));
    float _540 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_530.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _541 = t7.Sample(s7, float3(_509, _505, _501));
    float4 _548 = t6.Sample(s6, float3(_509, _505, _501));
    _573 = ((((_548.x - _541.x) * 1.0499999523162842f) * _540) + (_541.x * 1.0499999523162842f));
    _574 = ((((_548.y - _541.y) * 1.0499999523162842f) * _540) + (_541.y * 1.0499999523162842f));
    _575 = ((((_548.z - _541.z) * 1.0499999523162842f) * _540) + (_541.z * 1.0499999523162842f));
  } else {
    float4 _565 = t6.Sample(s6, float3(_509, _505, _501));
    _573 = (_565.x * 1.0499999523162842f);
    _574 = (_565.y * 1.0499999523162842f);
    _575 = (_565.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3_FADE(_573, _574, _575, t6, s6);
  float _583 = ((_48 * 0.00390625f) + -0.001953125f) + _573;
  float _584 = ((_70 * 0.00390625f) + -0.001953125f) + _574;
  float _585 = ((_71 * 0.00390625f) + -0.001953125f) + _575;
  [branch]
  if (!(cb0_106w == 0)) {
    float _597 = (pow(_583, 0.012683313339948654f));
    float _598 = (pow(_584, 0.012683313339948654f));
    float _599 = (pow(_585, 0.012683313339948654f));
    float _632 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_597 + -0.8359375f)) / (18.8515625f - (_597 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _633 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_598 + -0.8359375f)) / (18.8515625f - (_598 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _634 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_599 + -0.8359375f)) / (18.8515625f - (_599 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _660 = min((_632 * 12.920000076293945f), ((exp2(log2(max(_632, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _661 = min((_633 * 12.920000076293945f), ((exp2(log2(max(_633, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _662 = min((_634 * 12.920000076293945f), ((exp2(log2(max(_634, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _660 = _583;
    _661 = _584;
    _662 = _585;
  }
  SV_Target.x = _660;
  SV_Target.y = _661;
  SV_Target.z = _662;
  SV_Target.w = (dot(float3(_573, _574, _575), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
