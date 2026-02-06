#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture3D<float4> t4 : register(t4);

Texture3D<float4> t5 : register(t5);

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
  uint cb0_085z : packoffset(c085.z);
  uint cb0_085w : packoffset(c085.w);
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
  uint cb0_105w : packoffset(c105.w);
  float cb0_106x : packoffset(c106.x);
  float cb0_106z : packoffset(c106.z);
  uint cb0_106w : packoffset(c106.w);
  uint cb0_107x : packoffset(c107.x);
  uint cb0_107y : packoffset(c107.y);
  uint cb0_107z : packoffset(c107.z);
  uint cb0_107w : packoffset(c107.w);
  float cb0_111x : packoffset(c111.x);
  float cb0_111y : packoffset(c111.y);
  float cb0_111z : packoffset(c111.z);
  uint cb0_111w : packoffset(c111.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

SamplerState s4 : register(s4);

SamplerState s5 : register(s5);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _33 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _34 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _36 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _39 = frac(sin(_36) * 493013.0f);
  float _61;
  float _62;
  float _130;
  float _131;
  float _132;
  float _252;
  float _253;
  float _254;
  float _287;
  float _288;
  float _289;
  float _321;
  float _322;
  float _323;
  float _370;
  float _371;
  float _372;
  float _387;
  float _388;
  float _389;
  float _476;
  float _477;
  float _478;
  float _563;
  float _564;
  float _565;
  if (cb0_096x > 0.0f) {
    _61 = (((frac((sin(_36 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _39) * cb0_096x) + _39);
    _62 = (((frac((sin(_36 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _39) * cb0_096x) + _39);
  } else {
    _61 = _39;
    _62 = _39;
  }
  float4 _63 = t0.Sample(s0, float2(_33, _34));

  float4 _91 = t1.Sample(s1, float2(min(max(((cb0_068z * _33) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _34) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_91);

  [branch]
  if (!((uint)(cb0_085z) == 0)) {
    bool _119 = ((uint)(cb0_085w) != 0);
    float4 _122 = t2.Sample(s2, float2(select(_119, _33, min(max(((cb0_076z * _33) + cb0_077x), cb0_075z), cb0_076x)), select(_119, _34, min(max(((cb0_076w * _34) + cb0_077y), cb0_075w), cb0_076y))));
    _130 = (_122.x + _91.x);
    _131 = (_122.y + _91.y);
    _132 = (_122.z + _91.z);
  } else {
    _130 = _91.x;
    _131 = _91.y;
    _132 = _91.z;
  }
  float _157 = TEXCOORD_1.z + -1.0f;
  float _159 = TEXCOORD_1.w + -1.0f;
  float _162 = (((cb0_090x * 2.0f) + _157) * cb0_088z) * cb0_088x;
  float _164 = (((cb0_090y * 2.0f) + _159) * cb0_088w) * cb0_088x;
  float _171 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_162, _164), float2(_162, _164))) + 1.0f);
  float _172 = _171 * _171;
  float _173 = cb0_090z + 1.0f;
  float _201 = (((cb0_093x * 2.0f) + _157) * cb0_091z) * cb0_091x;
  float _203 = (((cb0_093y * 2.0f) + _159) * cb0_091w) * cb0_091x;
  float _210 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_201, _203), float2(_201, _203))) + 1.0f);
  float _211 = _210 * _210;
  float _212 = cb0_093z + 1.0f;
  float _223 = (((_172 * (_173 - cb0_089x)) + cb0_089x) * (_130 + ((_63.x * TEXCOORD_1.x) * cb0_086x))) * ((_211 * (_212 - cb0_092x)) + cb0_092x);
  float _225 = (((_172 * (_173 - cb0_089y)) + cb0_089y) * (_131 + ((_63.y * TEXCOORD_1.x) * cb0_086y))) * ((_211 * (_212 - cb0_092y)) + cb0_092y);
  float _227 = (((_172 * (_173 - cb0_089z)) + cb0_089z) * (_132 + ((_63.z * TEXCOORD_1.x) * cb0_086z))) * ((_211 * (_212 - cb0_092z)) + cb0_092z);

  CAPTURE_UNTONEMAPPED(float3(_223, _225, _227));

  [branch]
  if (false) {
    float _241 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _252 = (1.0f - exp2(_241 * _223));
    _253 = (1.0f - exp2(_241 * _225));
    _254 = (1.0f - exp2(_241 * _227));
  } else {
    _252 = _223;
    _253 = _225;
    _254 = _227;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _287 = ((((_252 * 1.3600000143051147f) + 0.04699999839067459f) * _252) / ((((_252 * 0.9599999785423279f) + 0.5600000023841858f) * _252) + 0.14000000059604645f));
    _288 = ((((_253 * 1.3600000143051147f) + 0.04699999839067459f) * _253) / ((((_253 * 0.9599999785423279f) + 0.5600000023841858f) * _253) + 0.14000000059604645f));
    _289 = ((((_254 * 1.3600000143051147f) + 0.04699999839067459f) * _254) / ((((_254 * 0.9599999785423279f) + 0.5600000023841858f) * _254) + 0.14000000059604645f));
  } else {
    _287 = _252;
    _288 = _253;
    _289 = _254;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _299 = 1.0049500465393066f - (0.16398000717163086f / (_287 + -0.19505000114440918f));
    float _300 = 1.0049500465393066f - (0.16398000717163086f / (_288 + -0.19505000114440918f));
    float _301 = 1.0049500465393066f - (0.16398000717163086f / (_289 + -0.19505000114440918f));
    _321 = (((_287 - _299) * select((_287 > 0.6000000238418579f), 0.0f, 1.0f)) + _299);
    _322 = (((_288 - _300) * select((_288 > 0.6000000238418579f), 0.0f, 1.0f)) + _300);
    _323 = (((_289 - _301) * select((_289 > 0.6000000238418579f), 0.0f, 1.0f)) + _301);
  } else {
    _321 = _287;
    _322 = _288;
    _323 = _289;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _329 = cb0_037y * _321;
    float _330 = cb0_037y * _322;
    float _331 = cb0_037y * _323;
    float _334 = cb0_037z * cb0_037w;
    float _344 = cb0_038y * cb0_038x;
    float _355 = cb0_038z * cb0_038x;
    float _362 = cb0_038y / cb0_038z;
    _370 = (((((_334 + _329) * _321) + _344) / (((_329 + cb0_037z) * _321) + _355)) - _362);
    _371 = (((((_334 + _330) * _322) + _344) / (((_330 + cb0_037z) * _322) + _355)) - _362);
    _372 = (((((_334 + _331) * _323) + _344) / (((_331 + cb0_037z) * _323) + _355)) - _362);
  } else {
    _370 = _321;
    _371 = _322;
    _372 = _323;
  }
  [branch]
  if (!((uint)(cb0_105w) == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _382 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _387 = (_382 * _370);
      _388 = (_382 * _371);
      _389 = (_382 * _372);
    } else {
      _387 = _370;
      _388 = _371;
      _389 = _372;
    }
  } else {
    _387 = _370;
    _388 = _371;
    _389 = _372;
  }

  CLAMP_IF_SDR3(_387, _388, _389);
  CAPTURE_TONEMAPPED(float3(_387, _388, _389));

  float _404 = (saturate((log2(_389 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _408 = (saturate((log2(_388 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _412 = (saturate((log2(_387 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!((uint)(cb0_107w) == 0)) {
    float4 _433 = t3.Sample(s3, float2(min(max(((cb0_084z * _33) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _34) + cb0_085y), cb0_083w), cb0_084y)));
    float _443 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_433.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _444 = t5.Sample(s5, float3(_412, _408, _404));
    float4 _451 = t4.Sample(s4, float3(_412, _408, _404));
    _476 = ((((_451.x - _444.x) * 1.0499999523162842f) * _443) + (_444.x * 1.0499999523162842f));
    _477 = ((((_451.y - _444.y) * 1.0499999523162842f) * _443) + (_444.y * 1.0499999523162842f));
    _478 = ((((_451.z - _444.z) * 1.0499999523162842f) * _443) + (_444.z * 1.0499999523162842f));
  } else {
    float4 _468 = t4.Sample(s4, float3(_412, _408, _404));
    _476 = (_468.x * 1.0499999523162842f);
    _477 = (_468.y * 1.0499999523162842f);
    _478 = (_468.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3(_476, _477, _478);

  float _486 = ((_39 * 0.00390625f) + -0.001953125f) + _476;
  float _487 = ((_61 * 0.00390625f) + -0.001953125f) + _477;
  float _488 = ((_62 * 0.00390625f) + -0.001953125f) + _478;
  [branch]
  if (!((uint)(cb0_106w) == 0)) {
    float _500 = (pow(_486, 0.012683313339948654f));
    float _501 = (pow(_487, 0.012683313339948654f));
    float _502 = (pow(_488, 0.012683313339948654f));
    float _535 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_500 + -0.8359375f)) / (18.8515625f - (_500 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _536 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_501 + -0.8359375f)) / (18.8515625f - (_501 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _537 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_502 + -0.8359375f)) / (18.8515625f - (_502 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _563 = min((_535 * 12.920000076293945f), ((exp2(log2(max(_535, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _564 = min((_536 * 12.920000076293945f), ((exp2(log2(max(_536, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _565 = min((_537 * 12.920000076293945f), ((exp2(log2(max(_537, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _563 = _486;
    _564 = _487;
    _565 = _488;
  }
  SV_Target.x = _563;
  SV_Target.y = _564;
  SV_Target.z = _565;

  SV_Target.w = (dot(float3(_476, _477, _478), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
