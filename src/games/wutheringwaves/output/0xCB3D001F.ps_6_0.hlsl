#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t2 : register(t2);

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
  float cb0_053x : packoffset(c053.x);
  float cb0_053y : packoffset(c053.y);
  float cb0_053z : packoffset(c053.z);
  float cb0_053w : packoffset(c053.w);
  float cb0_060x : packoffset(c060.x);
  float cb0_060y : packoffset(c060.y);
  float cb0_060z : packoffset(c060.z);
  float cb0_060w : packoffset(c060.w);
  float cb0_068x : packoffset(c068.x);
  float cb0_068y : packoffset(c068.y);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_069x : packoffset(c069.x);
  float cb0_069y : packoffset(c069.y);
  float cb0_069z : packoffset(c069.z);
  float cb0_071x : packoffset(c071.x);
  float cb0_071z : packoffset(c071.z);
  float cb0_071w : packoffset(c071.w);
  float cb0_072x : packoffset(c072.x);
  float cb0_072y : packoffset(c072.y);
  float cb0_072z : packoffset(c072.z);
  float cb0_072w : packoffset(c072.w);
  float cb0_073x : packoffset(c073.x);
  float cb0_073y : packoffset(c073.y);
  float cb0_074x : packoffset(c074.x);
  float cb0_074z : packoffset(c074.z);
  float cb0_074w : packoffset(c074.w);
  float cb0_075x : packoffset(c075.x);
  float cb0_075y : packoffset(c075.y);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_078z : packoffset(c078.z);
  float cb0_079x : packoffset(c079.x);
  float cb0_088w : packoffset(c088.w);
  uint cb0_089x : packoffset(c089.x);
  uint cb0_089y : packoffset(c089.y);
  uint cb0_089z : packoffset(c089.z);
  uint cb0_089w : packoffset(c089.w);
  float cb0_095x : packoffset(c095.x);
  float cb0_095y : packoffset(c095.y);
  float cb0_095z : packoffset(c095.z);
  float cb0_095w : packoffset(c095.w);
  float cb0_096x : packoffset(c096.x);
  float cb0_096y : packoffset(c096.y);
  float cb0_096z : packoffset(c096.z);
  float cb0_096w : packoffset(c096.w);
  float cb0_098x : packoffset(c098.x);
  float cb0_098y : packoffset(c098.y);
  float cb0_098z : packoffset(c098.z);
  float cb0_099x : packoffset(c099.x);
  float cb0_099y : packoffset(c099.y);
  float cb0_099z : packoffset(c099.z);
  float cb0_099w : packoffset(c099.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _29 = ((cb0_048x * TEXCOORD_3.x) + cb0_048z) * cb0_047z;
  float _30 = ((cb0_048y * TEXCOORD_3.y) + cb0_048w) * cb0_047w;
  float _31 = TEXCOORD_2.w * 543.3099975585938f;
  float _35 = frac(sin(_31 + TEXCOORD_2.z) * 493013.0f);
  float _59;
  float _60;
  float _132;
  float _133;
  float _224;
  float _225;
  float _375;
  float _376;
  float _377;
  float _409;
  float _410;
  float _411;
  float _458;
  float _459;
  float _460;
  float _573;
  float _574;
  float _575;
  if (cb0_079x > 0.0f) {
    _59 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _31) * 493013.0f) + 7.177000045776367f) - _35)) + _35);
    _60 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _31) * 493013.0f) + 14.298999786376953f) - _35)) + _35);
  } else {
    _59 = _35;
    _60 = _35;
  }
  float _65 = cb0_078z * (1.0f - (_35 * _35));
  float _68 = _65 * (TEXCOORD_2.x - _29);
  float _69 = _65 * (TEXCOORD_2.y - _30);
  float _70 = _68 + _29;
  float _71 = _69 + _30;
  float _81 = cb0_099z * cb0_098x;
  float _82 = cb0_099z * cb0_098y;
  bool _83 = (cb0_099x == 0.0f);
  float _93 = (cb0_095z * TEXCOORD_3.x) + cb0_095x;
  float _94 = (cb0_095w * TEXCOORD_3.y) + cb0_095y;
  float _105 = float(((int)(uint)((bool)(_93 > 0.0f))) - ((int)(uint)((bool)(_93 < 0.0f))));
  float _106 = float(((int)(uint)((bool)(_94 > 0.0f))) - ((int)(uint)((bool)(_94 < 0.0f))));
  float _111 = saturate(abs(_93) - cb0_098z);
  float _112 = saturate(abs(_94) - cb0_098z);
  float _122 = _94 - ((_112 * _81) * _106);
  float _124 = _94 - ((_112 * _82) * _106);
  bool _125 = (cb0_099x > 0.0f);
  if (_125) {
    _132 = (_122 - (cb0_099w * 0.4000000059604645f));
    _133 = (_124 - (cb0_099w * 0.20000000298023224f));
  } else {
    _132 = _122;
    _133 = _124;
  }
  float4 _168 = t0.Sample(s0, float2(min(max(_70, cb0_053x), cb0_053z), min(max(_71, cb0_053y), cb0_053w)));
  float4 _183 = t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_096z * (_93 - ((_111 * select(_83, _81, cb0_098x)) * _105))) + cb0_096x)) + cb0_048z) * cb0_047z) + _68), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_096w * _132) + cb0_096y)) + cb0_048w) * cb0_047w) + _69), cb0_053y), cb0_053w)));
  float4 _196 = t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_096z * (_93 - ((_111 * select(_83, _82, cb0_098y)) * _105))) + cb0_096x)) + cb0_048z) * cb0_047z) + _68), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_096w * _133) + cb0_096y)) + cb0_048w) * cb0_047w) + _69), cb0_053y), cb0_053w)));
  if (_125) {
    float _206 = saturate(((((_168.y * 0.5870000123977661f) - cb0_099y) + (_168.x * 0.29899999499320984f)) + (_168.z * 0.11400000005960464f)) * 10.0f);
    float _210 = (_206 * _206) * (3.0f - (_206 * 2.0f));
    // _224 = ((((_168.x - _183.x) + (_210 * (_183.x - _168.x))) * cb0_099x) + _183.x);
    // _225 = ((((_168.y - _196.y) + (_210 * (_196.y - _168.y))) * cb0_099x) + _196.y);
    _224 = (RENODX_WUWA_CA * (((_168.x - _183.x) + (_210 * (_183.x - _168.x))) * cb0_099x) + _183.x);
    _225 = (RENODX_WUWA_CA * (((_168.y - _196.y) + (_210 * (_196.y - _168.y))) * cb0_099x) + _196.y);
  } else {
    _224 = _183.x;
    _225 = _196.y;
  }

  float4 _248 = t1.Sample(s1, float2(min(max(((cb0_068x * _70) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _71) + cb0_068w), cb0_060y), cb0_060w)));
  _248.rgb *= RENODX_WUWA_BLOOM;

  float _275 = TEXCOORD_1.z + -1.0f;
  float _277 = TEXCOORD_1.w + -1.0f;
  float _280 = ((_275 + (cb0_073x * 2.0f)) * cb0_071z) * cb0_071x;
  float _282 = ((_277 + (cb0_073y * 2.0f)) * cb0_071w) * cb0_071x;
  float _289 = 1.0f / ((((saturate(cb0_072w) * 9.0f) + 1.0f) * dot(float2(_280, _282), float2(_280, _282))) + 1.0f);
  float _290 = _289 * _289;
  float _317 = ((_275 + (cb0_076x * 2.0f)) * cb0_074z) * cb0_074x;
  float _319 = ((_277 + (cb0_076y * 2.0f)) * cb0_074w) * cb0_074x;
  float _326 = 1.0f / ((((saturate(cb0_075w) * 9.0f) + 1.0f) * dot(float2(_317, _319), float2(_317, _319))) + 1.0f);
  float _327 = _326 * _326;
  float _340 = min(((_290 * (1.0f - cb0_072x)) + cb0_072x), ((_327 * (1.0f - cb0_075x)) + cb0_075x)) * (_248.x + ((_224 * TEXCOORD_1.x) * cb0_069x));
  float _341 = min(((_290 * (1.0f - cb0_072y)) + cb0_072y), ((_327 * (1.0f - cb0_075y)) + cb0_075y)) * (_248.y + ((_225 * TEXCOORD_1.x) * cb0_069y));
  float _342 = min(((_290 * (1.0f - cb0_072z)) + cb0_072z), ((_327 * (1.0f - cb0_075z)) + cb0_075z)) * (_248.z + ((_168.z * TEXCOORD_1.x) * cb0_069z));

  CAPTURE_UNTONEMAPPED(untonemapped, float3(_340, _341, _342));

  [branch]
  // if (!((uint)(cb0_089y) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    // _375 = saturate((((_340 * 1.3600000143051147f) + 0.04699999839067459f) * _340) / ((((_340 * 0.9599999785423279f) + 0.5600000023841858f) * _340) + 0.14000000059604645f));
    // _376 = saturate((((_341 * 1.3600000143051147f) + 0.04699999839067459f) * _341) / ((((_341 * 0.9599999785423279f) + 0.5600000023841858f) * _341) + 0.14000000059604645f));
    // _377 = saturate((((_342 * 1.3600000143051147f) + 0.04699999839067459f) * _342) / ((((_342 * 0.9599999785423279f) + 0.5600000023841858f) * _342) + 0.14000000059604645f));
    _375 = ((((_340 * 1.3600000143051147f) + 0.04699999839067459f) * _340) / ((((_340 * 0.9599999785423279f) + 0.5600000023841858f) * _340) + 0.14000000059604645f));
    _376 = ((((_341 * 1.3600000143051147f) + 0.04699999839067459f) * _341) / ((((_341 * 0.9599999785423279f) + 0.5600000023841858f) * _341) + 0.14000000059604645f));
    _377 = ((((_342 * 1.3600000143051147f) + 0.04699999839067459f) * _342) / ((((_342 * 0.9599999785423279f) + 0.5600000023841858f) * _342) + 0.14000000059604645f));
  } else {
    _375 = _340;
    _376 = _341;
    _377 = _342;
  }
  [branch]
  // if (!((uint)(cb0_089z) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _387 = 1.0049500465393066f - (0.16398000717163086f / (_375 + -0.19505000114440918f));
    float _388 = 1.0049500465393066f - (0.16398000717163086f / (_376 + -0.19505000114440918f));
    float _389 = 1.0049500465393066f - (0.16398000717163086f / (_377 + -0.19505000114440918f));
    // _409 = saturate(((_375 - _387) * select((_375 > 0.6000000238418579f), 0.0f, 1.0f)) + _387);
    // _410 = saturate(((_376 - _388) * select((_376 > 0.6000000238418579f), 0.0f, 1.0f)) + _388);
    // _411 = saturate(((_377 - _389) * select((_377 > 0.6000000238418579f), 0.0f, 1.0f)) + _389);
    _409 = (((_375 - _387) * select((_375 > 0.6000000238418579f), 0.0f, 1.0f)) + _387);
    _410 = (((_376 - _388) * select((_376 > 0.6000000238418579f), 0.0f, 1.0f)) + _388);
    _411 = (((_377 - _389) * select((_377 > 0.6000000238418579f), 0.0f, 1.0f)) + _389);
  } else {
    _409 = _375;
    _410 = _376;
    _411 = _377;
  }
  [branch]
  // if (!((uint)(cb0_089w) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _417 = cb0_037y * _409;
    float _418 = cb0_037y * _410;
    float _419 = cb0_037y * _411;
    float _422 = cb0_037z * cb0_037w;
    float _432 = cb0_038y * cb0_038x;
    float _443 = cb0_038z * cb0_038x;
    float _450 = cb0_038y / cb0_038z;
    // _458 = saturate(((((_422 + _417) * _409) + _432) / (_443 + ((_417 + cb0_037z) * _409))) - _450);
    // _459 = saturate(((((_422 + _418) * _410) + _432) / (_443 + ((_418 + cb0_037z) * _410))) - _450);
    // _460 = saturate(((((_422 + _419) * _411) + _432) / (_443 + ((_419 + cb0_037z) * _411))) - _450);
    _458 = (((((_422 + _417) * _409) + _432) / (_443 + ((_417 + cb0_037z) * _409))) - _450);
    _459 = (((((_422 + _418) * _410) + _432) / (_443 + ((_418 + cb0_037z) * _410))) - _450);
    _460 = (((((_422 + _419) * _411) + _432) / (_443 + ((_419 + cb0_037z) * _411))) - _450);
  } else {
    _458 = _409;
    _459 = _410;
    _460 = _411;
  }

  CLAMP_IF_SDR(_458); CLAMP_IF_SDR(_459); CLAMP_IF_SDR(_460);
  CAPTURE_TONEMAPPED(tonemapped, float3(_458, _459, _460));

  float4 _482 = t2.Sample(s2, float3(((saturate((log2(_458 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_459 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_460 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _482.rgb = HandleLUTOutput(_482.rgb, untonemapped, tonemapped);

  float _486 = _482.x * 1.0499999523162842f;
  float _487 = _482.y * 1.0499999523162842f;
  float _488 = _482.z * 1.0499999523162842f;

  // float _496 = ((_35 * 0.00390625f) + -0.001953125f) + _486;
  // float _497 = ((_59 * 0.00390625f) + -0.001953125f) + _487;
  // float _498 = ((_60 * 0.00390625f) + -0.001953125f) + _488;
  float _496 = RENODX_WUWA_GRAIN * ((_35 * 0.00390625f) + -0.001953125f) + _486;
  float _497 = RENODX_WUWA_GRAIN * ((_59 * 0.00390625f) + -0.001953125f) + _487;
  float _498 = RENODX_WUWA_GRAIN * ((_60 * 0.00390625f) + -0.001953125f) + _488;

  [branch]
  if (!((uint)(cb0_089x) == 0)) {
    float _510 = (pow(_496, 0.012683313339948654f));
    float _511 = (pow(_497, 0.012683313339948654f));
    float _512 = (pow(_498, 0.012683313339948654f));
    float _545 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_510 + -0.8359375f)) / (18.8515625f - (_510 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _546 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_511 + -0.8359375f)) / (18.8515625f - (_511 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _547 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_512 + -0.8359375f)) / (18.8515625f - (_512 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    _573 = min((_545 * 12.920000076293945f), ((exp2(log2(max(_545, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _574 = min((_546 * 12.920000076293945f), ((exp2(log2(max(_546, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _575 = min((_547 * 12.920000076293945f), ((exp2(log2(max(_547, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _573 = _496;
    _574 = _497;
    _575 = _498;
  }
  SV_Target.x = _573;
  SV_Target.y = _574;
  SV_Target.z = _575;

  // SV_Target.w = saturate(dot(float3(_486, _487, _488), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_486, _487, _488), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
