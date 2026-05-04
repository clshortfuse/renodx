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

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _35 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _36 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _38 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _41 = frac(sin(_38) * 493013.0f);
  float _63;
  float _64;
  float _153;
  float _154;
  float _155;
  float _287;
  float _288;
  float _289;
  float _322;
  float _323;
  float _324;
  float _356;
  float _357;
  float _358;
  float _405;
  float _406;
  float _407;
  float _422;
  float _423;
  float _424;
  float _511;
  float _512;
  float _513;
  float _598;
  float _599;
  float _600;
  if (cb0_096x > 0.0f) {
    _63 = (((frac((sin(_38 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _41) * cb0_096x) + _41);
    _64 = (((frac((sin(_38 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _41) * cb0_096x) + _41);
  } else {
    _63 = _41;
    _64 = _41;
  }
  float _69 = cb0_095z * (1.0f - (_41 * _41));
  float _74 = (_69 * (TEXCOORD_2.x - _35)) + _35;
  float _75 = (_69 * (TEXCOORD_2.y - _36)) + _36;
  float4 _86 = t0.Sample(s0, float2(min(max(_74, cb0_053z), cb0_054x), min(max(_75, cb0_053w), cb0_054y)));
  float4 _114 = t1.Sample(s1, float2(min(max(((cb0_068z * _74) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _75) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_114);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _142 = (cb0_085w != 0);
    float4 _145 = t2.Sample(s2, float2(select(_142, _74, min(max(((cb0_076z * _74) + cb0_077x), cb0_075z), cb0_076x)), select(_142, _75, min(max(((cb0_076w * _75) + cb0_077y), cb0_075w), cb0_076y))));
    _153 = (_145.x + _114.x);
    _154 = (_145.y + _114.y);
    _155 = (_145.z + _114.z);
  } else {
    _153 = _114.x;
    _154 = _114.y;
    _155 = _114.z;
  }
  float _180 = TEXCOORD_1.z + -1.0f;
  float _182 = TEXCOORD_1.w + -1.0f;
  float _185 = (((cb0_090x * 2.0f) + _180) * cb0_088z) * cb0_088x;
  float _187 = (((cb0_090y * 2.0f) + _182) * cb0_088w) * cb0_088x;
  float _194 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_185, _187), float2(_185, _187))) + 1.0f);
  float _195 = _194 * _194;
  float _196 = cb0_090z + 1.0f;
  float _224 = (((cb0_093x * 2.0f) + _180) * cb0_091z) * cb0_091x;
  float _226 = (((cb0_093y * 2.0f) + _182) * cb0_091w) * cb0_091x;
  float _233 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_224, _226), float2(_224, _226))) + 1.0f);
  float _234 = _233 * _233;
  float _235 = cb0_093z + 1.0f;
  float _256 = ((((_195 * (_196 - cb0_089x)) + cb0_089x) * (_153 + ((_86.x * TEXCOORD_1.x) * cb0_086x))) * ((_234 * (_235 - cb0_092x)) + cb0_092x)) * ((cb0_095x * _41) + cb0_095y);
  float _259 = ((((_195 * (_196 - cb0_089y)) + cb0_089y) * (_154 + ((_86.y * TEXCOORD_1.x) * cb0_086y))) * ((_234 * (_235 - cb0_092y)) + cb0_092y)) * ((cb0_095x * _63) + cb0_095y);
  float _262 = ((((_195 * (_196 - cb0_089z)) + cb0_089z) * (_155 + ((_86.z * TEXCOORD_1.x) * cb0_086z))) * ((_234 * (_235 - cb0_092z)) + cb0_092z)) * ((cb0_095x * _64) + cb0_095y);

  CAPTURE_UNTONEMAPPED(float3(_256, _259, _262));
  [branch]
  if (!(cb0_111w == 0)) {
    float _276 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _287 = (1.0f - exp2(_276 * _256));
    _288 = (1.0f - exp2(_276 * _259));
    _289 = (1.0f - exp2(_276 * _262));
  } else {
    _287 = _256;
    _288 = _259;
    _289 = _262;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _322 = ((((_287 * 1.3600000143051147f) + 0.04699999839067459f) * _287) / ((((_287 * 0.9599999785423279f) + 0.5600000023841858f) * _287) + 0.14000000059604645f));
    _323 = ((((_288 * 1.3600000143051147f) + 0.04699999839067459f) * _288) / ((((_288 * 0.9599999785423279f) + 0.5600000023841858f) * _288) + 0.14000000059604645f));
    _324 = ((((_289 * 1.3600000143051147f) + 0.04699999839067459f) * _289) / ((((_289 * 0.9599999785423279f) + 0.5600000023841858f) * _289) + 0.14000000059604645f));
  } else {
    _322 = _287;
    _323 = _288;
    _324 = _289;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _334 = 1.0049500465393066f - (0.16398000717163086f / (_322 + -0.19505000114440918f));
    float _335 = 1.0049500465393066f - (0.16398000717163086f / (_323 + -0.19505000114440918f));
    float _336 = 1.0049500465393066f - (0.16398000717163086f / (_324 + -0.19505000114440918f));
    _356 = (((_322 - _334) * select((_322 > 0.6000000238418579f), 0.0f, 1.0f)) + _334);
    _357 = (((_323 - _335) * select((_323 > 0.6000000238418579f), 0.0f, 1.0f)) + _335);
    _358 = (((_324 - _336) * select((_324 > 0.6000000238418579f), 0.0f, 1.0f)) + _336);
  } else {
    _356 = _322;
    _357 = _323;
    _358 = _324;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _364 = cb0_037y * _356;
    float _365 = cb0_037y * _357;
    float _366 = cb0_037y * _358;
    float _369 = cb0_037z * cb0_037w;
    float _379 = cb0_038y * cb0_038x;
    float _390 = cb0_038z * cb0_038x;
    float _397 = cb0_038y / cb0_038z;
    _405 = (((((_369 + _364) * _356) + _379) / (((_364 + cb0_037z) * _356) + _390)) - _397);
    _406 = (((((_369 + _365) * _357) + _379) / (((_365 + cb0_037z) * _357) + _390)) - _397);
    _407 = (((((_369 + _366) * _358) + _379) / (((_366 + cb0_037z) * _358) + _390)) - _397);
  } else {
    _405 = _356;
    _406 = _357;
    _407 = _358;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _417 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _422 = (_417 * _405);
      _423 = (_417 * _406);
      _424 = (_417 * _407);
    } else {
      _422 = _405;
      _423 = _406;
      _424 = _407;
    }
  } else {
    _422 = _405;
    _423 = _406;
    _424 = _407;
  }
  CLAMP_IF_SDR3(_422, _423, _424);
  CAPTURE_TONEMAPPED(float3(_422, _423, _424));
  float _439 = (saturate((log2(_424 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _443 = (saturate((log2(_423 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _447 = (saturate((log2(_422 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!(cb0_107w == 0)) {
    float4 _468 = t3.Sample(s3, float2(min(max(((cb0_084z * _74) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _75) + cb0_085y), cb0_083w), cb0_084y)));
    float _478 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_468.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _479 = t5.Sample(s5, float3(_447, _443, _439));
    float4 _486 = t4.Sample(s4, float3(_447, _443, _439));
    _511 = ((((_486.x - _479.x) * 1.0499999523162842f) * _478) + (_479.x * 1.0499999523162842f));
    _512 = ((((_486.y - _479.y) * 1.0499999523162842f) * _478) + (_479.y * 1.0499999523162842f));
    _513 = ((((_486.z - _479.z) * 1.0499999523162842f) * _478) + (_479.z * 1.0499999523162842f));
  } else {
    float4 _503 = t4.Sample(s4, float3(_447, _443, _439));
    _511 = (_503.x * 1.0499999523162842f);
    _512 = (_503.y * 1.0499999523162842f);
    _513 = (_503.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3_FADE(_511, _512, _513, t4, s4);
  float _521 = ((_41 * 0.00390625f) + -0.001953125f) + _511;
  float _522 = ((_63 * 0.00390625f) + -0.001953125f) + _512;
  float _523 = ((_64 * 0.00390625f) + -0.001953125f) + _513;
  [branch]
  if (!(cb0_106w == 0)) {
    float _535 = (pow(_521, 0.012683313339948654f));
    float _536 = (pow(_522, 0.012683313339948654f));
    float _537 = (pow(_523, 0.012683313339948654f));
    float _570 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_535 + -0.8359375f)) / (18.8515625f - (_535 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _571 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_536 + -0.8359375f)) / (18.8515625f - (_536 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _572 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_537 + -0.8359375f)) / (18.8515625f - (_537 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _598 = min((_570 * 12.920000076293945f), ((exp2(log2(max(_570, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _599 = min((_571 * 12.920000076293945f), ((exp2(log2(max(_571, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _600 = min((_572 * 12.920000076293945f), ((exp2(log2(max(_572, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _598 = _521;
    _599 = _522;
    _600 = _523;
  }
  SV_Target.x = _598;
  SV_Target.y = _599;
  SV_Target.z = _600;
  SV_Target.w = (dot(float3(_511, _512, _513), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
