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
  float _136;
  float _208;
  float _209;
  float _210;
  float _222;
  float _223;
  float _224;
  float _353;
  float _354;
  float _355;
  float _387;
  float _388;
  float _389;
  float _436;
  float _437;
  float _438;
  float _453;
  float _454;
  float _455;
  float _528;
  float _529;
  float _530;
  float _618;
  float _619;
  float _620;
  if (cb0_097x > 0.0f) {
    _72 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _44) * 493013.0f) + 7.177000045776367f) - _48)) + _48);
    _73 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _44) * 493013.0f) + 14.298999786376953f) - _48)) + _48);
  } else {
    _72 = _48;
    _73 = _48;
  }
  float4 _74 = t0.Sample(s0, float2(_42, _43));
  float _86 = log2(max(dot(float3(_74.x, _74.y, _74.z), float3(cb0_043x, cb0_043y, cb0_043z)), cb0_042x));
  float4 _104 = t5.Sample(s5, float3((cb0_046z * TEXCOORD_4.x), (cb0_046w * TEXCOORD_4.y), ((((cb0_041z * _86) + cb0_041w) * 0.96875f) + 0.015625f)));
  float4 _108 = t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y));
  float _111 = select((_104.y < 0.0010000000474974513f), _108.x, (_104.x / _104.y));
  float _114 = log2(TEXCOORD_1.x);
  float _116 = (_111 + _114) + ((_108.x - _111) * cb0_046x);
  float _121 = _114 + _86;
  float _123 = _116 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_046y);
  bool _124 = (_123 > 0.0f);
  if (_124) {
    _136 = max(0.0f, (_123 - cb0_047x));
  } else {
    _136 = min(0.0f, (cb0_047y + _123));
  }
  float4 _168 = t1.Sample(s1, float2(min(max(((cb0_068z * _42) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _43) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_168);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _197 = (cb0_086x != 0);
    float4 _200 = t2.Sample(s2, float2(select(_197, _42, min(max(((cb0_076z * _42) + cb0_077x), cb0_075z), cb0_076x)), select(_197, _43, min(max(((cb0_076w * _43) + cb0_077y), cb0_075w), cb0_076y))));
    _208 = (_200.x + _168.x);
    _209 = (_200.y + _168.y);
    _210 = (_200.z + _168.z);
  } else {
    _208 = _168.x;
    _209 = _168.y;
    _210 = _168.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _214 = t3.Sample(s3, float2(_42, _43));
    _222 = (_214.x + _208);
    _223 = (_214.y + _209);
    _224 = (_214.z + _210);
  } else {
    _222 = _208;
    _223 = _209;
    _224 = _210;
  }
  float _225 = exp2((((_116 - _121) + ((_121 - _116) * cb0_045w)) - _136) + (_136 * select(_124, cb0_045y, cb0_045z))) * TEXCOORD_1.x;
  float _250 = TEXCOORD_1.z + -1.0f;
  float _252 = TEXCOORD_1.w + -1.0f;
  float _255 = ((_250 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _257 = ((_252 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _264 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_255, _257), float2(_255, _257))) + 1.0f);
  float _265 = _264 * _264;
  float _266 = cb0_091z + 1.0f;
  float _294 = ((_250 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _296 = ((_252 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _303 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_294, _296), float2(_294, _296))) + 1.0f);
  float _304 = _303 * _303;
  float _305 = cb0_094z + 1.0f;
  float _316 = (((_265 * (_266 - cb0_090x)) + cb0_090x) * (_222 + ((_225 * _74.x) * cb0_087x))) * ((_304 * (_305 - cb0_093x)) + cb0_093x);
  float _318 = (((_265 * (_266 - cb0_090y)) + cb0_090y) * (_223 + ((_225 * _74.y) * cb0_087y))) * ((_304 * (_305 - cb0_093y)) + cb0_093y);
  float _320 = (((_265 * (_266 - cb0_090z)) + cb0_090z) * (_224 + ((_225 * _74.z) * cb0_087z))) * ((_304 * (_305 - cb0_093z)) + cb0_093z);

  CAPTURE_UNTONEMAPPED(float3(_316, _318, _320));
  [branch]
  if (WUWA_TM_IS(1)) {
    _353 = ((((_316 * 1.3600000143051147f) + 0.04699999839067459f) * _316) / ((((_316 * 0.9599999785423279f) + 0.5600000023841858f) * _316) + 0.14000000059604645f));
    _354 = ((((_318 * 1.3600000143051147f) + 0.04699999839067459f) * _318) / ((((_318 * 0.9599999785423279f) + 0.5600000023841858f) * _318) + 0.14000000059604645f));
    _355 = ((((_320 * 1.3600000143051147f) + 0.04699999839067459f) * _320) / ((((_320 * 0.9599999785423279f) + 0.5600000023841858f) * _320) + 0.14000000059604645f));
  } else {
    _353 = _316;
    _354 = _318;
    _355 = _320;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _365 = 1.0049500465393066f - (0.16398000717163086f / (_353 + -0.19505000114440918f));
    float _366 = 1.0049500465393066f - (0.16398000717163086f / (_354 + -0.19505000114440918f));
    float _367 = 1.0049500465393066f - (0.16398000717163086f / (_355 + -0.19505000114440918f));
    _387 = (((_353 - _365) * select((_353 > 0.6000000238418579f), 0.0f, 1.0f)) + _365);
    _388 = (((_354 - _366) * select((_354 > 0.6000000238418579f), 0.0f, 1.0f)) + _366);
    _389 = (((_355 - _367) * select((_355 > 0.6000000238418579f), 0.0f, 1.0f)) + _367);
  } else {
    _387 = _353;
    _388 = _354;
    _389 = _355;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _395 = cb0_037y * _387;
    float _396 = cb0_037y * _388;
    float _397 = cb0_037y * _389;
    float _400 = cb0_037z * cb0_037w;
    float _410 = cb0_038y * cb0_038x;
    float _421 = cb0_038z * cb0_038x;
    float _428 = cb0_038y / cb0_038z;
    _436 = (((((_400 + _395) * _387) + _410) / (_421 + ((_395 + cb0_037z) * _387))) - _428);
    _437 = (((((_400 + _396) * _388) + _410) / (_421 + ((_396 + cb0_037z) * _388))) - _428);
    _438 = (((((_400 + _397) * _389) + _410) / (_421 + ((_397 + cb0_037z) * _389))) - _428);
  } else {
    _436 = _387;
    _437 = _388;
    _438 = _389;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _448 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _453 = (_448 * _436);
      _454 = (_448 * _437);
      _455 = (_448 * _438);
    } else {
      _453 = _436;
      _454 = _437;
      _455 = _438;
    }
  } else {
    _453 = _436;
    _454 = _437;
    _455 = _438;
  }
  CLAMP_IF_SDR3(_453, _454, _455);
  CAPTURE_TONEMAPPED(float3(_453, _454, _455));
  float _476 = (saturate((log2(_453 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _477 = (saturate((log2(_454 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _478 = (saturate((log2(_455 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _479 = t7.Sample(s7, float3(_476, _477, _478));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _503 = t4.Sample(s4, float2(min(max(((cb0_084z * _42) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _43) + cb0_085y), cb0_083w), cb0_084y)));
    float _513 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_503.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _514 = t8.Sample(s8, float3(_476, _477, _478));
    _528 = (lerp(_514.x, _479.x, _513));
    _529 = (lerp(_514.y, _479.y, _513));
    _530 = (lerp(_514.z, _479.z, _513));
  } else {
    _528 = _479.x;
    _529 = _479.y;
    _530 = _479.z;
  }
  HANDLE_LUT_OUTPUT3_FADE(_528, _529, _530, t7, s7);
  float _531 = _530 * 1.0499999523162842f;
  float _532 = _529 * 1.0499999523162842f;
  float _533 = _528 * 1.0499999523162842f;
  float _541 = ((_48 * 0.00390625f) + -0.001953125f) + _533;
  float _542 = ((_72 * 0.00390625f) + -0.001953125f) + _532;
  float _543 = ((_73 * 0.00390625f) + -0.001953125f) + _531;
  [branch]
  if (!(cb0_107w == 0)) {
    float _555 = (pow(_541, 0.012683313339948654f));
    float _556 = (pow(_542, 0.012683313339948654f));
    float _557 = (pow(_543, 0.012683313339948654f));
    float _590 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_555 + -0.8359375f)) / (18.8515625f - (_555 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _591 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_556 + -0.8359375f)) / (18.8515625f - (_556 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _592 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_557 + -0.8359375f)) / (18.8515625f - (_557 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _618 = min((_590 * 12.920000076293945f), ((exp2(log2(max(_590, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _619 = min((_591 * 12.920000076293945f), ((exp2(log2(max(_591, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _620 = min((_592 * 12.920000076293945f), ((exp2(log2(max(_592, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _618 = _541;
    _619 = _542;
    _620 = _543;
  }
  SV_Target.x = _618;
  SV_Target.y = _619;
  SV_Target.z = _620;
  SV_Target.w = dot(float3(_533, _532, _531), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
