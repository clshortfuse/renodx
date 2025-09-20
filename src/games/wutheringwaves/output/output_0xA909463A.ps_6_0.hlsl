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
  float cb0_078x : packoffset(c078.x);
  float cb0_078y : packoffset(c078.y);
  float cb0_078z : packoffset(c078.z);
  float cb0_079x : packoffset(c079.x);
  float cb0_088w : packoffset(c088.w);
  uint cb0_089x : packoffset(c089.x);
  uint cb0_089y : packoffset(c089.y);
  uint cb0_089z : packoffset(c089.z);
  uint cb0_089w : packoffset(c089.w);
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
  float _246;
  float _247;
  float _248;
  float _280;
  float _281;
  float _282;
  float _329;
  float _330;
  float _331;
  float _444;
  float _445;
  float _446;
  if (cb0_079x > 0.0f) {
    _59 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _31) * 493013.0f) + 7.177000045776367f) - _35)) + _35);
    _60 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _31) * 493013.0f) + 14.298999786376953f) - _35)) + _35);
  } else {
    _59 = _35;
    _60 = _35;
  }
  float _65 = cb0_078z * (1.0f - (_35 * _35));
  float _70 = (_65 * (TEXCOORD_2.x - _29)) + _29;
  float _71 = (_65 * (TEXCOORD_2.y - _30)) + _30;
  float4 _81 = t0.Sample(s0, float2(min(max(_70, cb0_053x), cb0_053z), min(max(_71, cb0_053y), cb0_053w)));

  float4 _107 = t1.Sample(s1, float2(min(max(((cb0_068x * _70) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _71) + cb0_068w), cb0_060y), cb0_060w)));
  _107.rgb *= RENODX_WUWA_BLOOM;

  float _134 = TEXCOORD_1.z + -1.0f;
  float _136 = TEXCOORD_1.w + -1.0f;
  float _139 = ((_134 + (cb0_073x * 2.0f)) * cb0_071z) * cb0_071x;
  float _141 = ((_136 + (cb0_073y * 2.0f)) * cb0_071w) * cb0_071x;
  float _148 = 1.0f / ((((saturate(cb0_072w) * 9.0f) + 1.0f) * dot(float2(_139, _141), float2(_139, _141))) + 1.0f);
  float _149 = _148 * _148;
  float _176 = ((_134 + (cb0_076x * 2.0f)) * cb0_074z) * cb0_074x;
  float _178 = ((_136 + (cb0_076y * 2.0f)) * cb0_074w) * cb0_074x;
  float _185 = 1.0f / ((((saturate(cb0_075w) * 9.0f) + 1.0f) * dot(float2(_176, _178), float2(_176, _178))) + 1.0f);
  float _186 = _185 * _185;
  float _211 = (min(((_149 * (1.0f - cb0_072x)) + cb0_072x), ((_186 * (1.0f - cb0_075x)) + cb0_075x)) * (_107.x + ((_81.x * TEXCOORD_1.x) * cb0_069x))) * ((cb0_078x * _35) + cb0_078y);
  float _212 = (min(((_149 * (1.0f - cb0_072y)) + cb0_072y), ((_186 * (1.0f - cb0_075y)) + cb0_075y)) * (_107.y + ((_81.y * TEXCOORD_1.x) * cb0_069y))) * ((cb0_078x * _59) + cb0_078y);
  float _213 = (min(((_149 * (1.0f - cb0_072z)) + cb0_072z), ((_186 * (1.0f - cb0_075z)) + cb0_075z)) * (_107.z + ((_81.z * TEXCOORD_1.x) * cb0_069z))) * ((cb0_078x * _60) + cb0_078y);

  CAPTURE_UNTONEMAPPED(untonemapped, float3(_211, _212, _213));

  [branch]
  // if (!((uint)(cb0_089y) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    // _246 = saturate((((_211 * 1.3600000143051147f) + 0.04699999839067459f) * _211) / ((((_211 * 0.9599999785423279f) + 0.5600000023841858f) * _211) + 0.14000000059604645f));
    // _247 = saturate((((_212 * 1.3600000143051147f) + 0.04699999839067459f) * _212) / ((((_212 * 0.9599999785423279f) + 0.5600000023841858f) * _212) + 0.14000000059604645f));
    // _248 = saturate((((_213 * 1.3600000143051147f) + 0.04699999839067459f) * _213) / ((((_213 * 0.9599999785423279f) + 0.5600000023841858f) * _213) + 0.14000000059604645f));
    _246 = ((((_211 * 1.3600000143051147f) + 0.04699999839067459f) * _211) / ((((_211 * 0.9599999785423279f) + 0.5600000023841858f) * _211) + 0.14000000059604645f));
    _247 = ((((_212 * 1.3600000143051147f) + 0.04699999839067459f) * _212) / ((((_212 * 0.9599999785423279f) + 0.5600000023841858f) * _212) + 0.14000000059604645f));
    _248 = ((((_213 * 1.3600000143051147f) + 0.04699999839067459f) * _213) / ((((_213 * 0.9599999785423279f) + 0.5600000023841858f) * _213) + 0.14000000059604645f));
  } else {
    _246 = _211;
    _247 = _212;
    _248 = _213;
  }
  [branch]
  // if (!((uint)(cb0_089z) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _258 = 1.0049500465393066f - (0.16398000717163086f / (_246 + -0.19505000114440918f));
    float _259 = 1.0049500465393066f - (0.16398000717163086f / (_247 + -0.19505000114440918f));
    float _260 = 1.0049500465393066f - (0.16398000717163086f / (_248 + -0.19505000114440918f));
    // _280 = saturate(((_246 - _258) * select((_246 > 0.6000000238418579f), 0.0f, 1.0f)) + _258);
    // _281 = saturate(((_247 - _259) * select((_247 > 0.6000000238418579f), 0.0f, 1.0f)) + _259);
    // _282 = saturate(((_248 - _260) * select((_248 > 0.6000000238418579f), 0.0f, 1.0f)) + _260);
    _280 = (((_246 - _258) * select((_246 > 0.6000000238418579f), 0.0f, 1.0f)) + _258);
    _281 = (((_247 - _259) * select((_247 > 0.6000000238418579f), 0.0f, 1.0f)) + _259);
    _282 = (((_248 - _260) * select((_248 > 0.6000000238418579f), 0.0f, 1.0f)) + _260);
  } else {
    _280 = _246;
    _281 = _247;
    _282 = _248;
  }
  [branch]
  // if (!((uint)(cb0_089w) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _288 = cb0_037y * _280;
    float _289 = cb0_037y * _281;
    float _290 = cb0_037y * _282;
    float _293 = cb0_037z * cb0_037w;
    float _303 = cb0_038y * cb0_038x;
    float _314 = cb0_038z * cb0_038x;
    float _321 = cb0_038y / cb0_038z;
    // _329 = saturate(((((_293 + _288) * _280) + _303) / (_314 + ((_288 + cb0_037z) * _280))) - _321);
    // _330 = saturate(((((_293 + _289) * _281) + _303) / (_314 + ((_289 + cb0_037z) * _281))) - _321);
    // _331 = saturate(((((_293 + _290) * _282) + _303) / (_314 + ((_290 + cb0_037z) * _282))) - _321);
    _329 = (((((_293 + _288) * _280) + _303) / (_314 + ((_288 + cb0_037z) * _280))) - _321);
    _330 = (((((_293 + _289) * _281) + _303) / (_314 + ((_289 + cb0_037z) * _281))) - _321);
    _331 = (((((_293 + _290) * _282) + _303) / (_314 + ((_290 + cb0_037z) * _282))) - _321);
  } else {
    _329 = _280;
    _330 = _281;
    _331 = _282;
  }

  CLAMP_IF_SDR(_329); CLAMP_IF_SDR(_330); CLAMP_IF_SDR(_331);
  CAPTURE_TONEMAPPED(tonemapped, float3(_329, _330, _331));

  float4 _353 = t2.Sample(s2, float3(((saturate((log2(_329 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_330 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_331 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _353.rgb = HandleLUTOutput(_353.rgb, untonemapped, tonemapped);

  float _357 = _353.x * 1.0499999523162842f;
  float _358 = _353.y * 1.0499999523162842f;
  float _359 = _353.z * 1.0499999523162842f;

  // float _367 = ((_35 * 0.00390625f) + -0.001953125f) + _357;
  // float _368 = ((_59 * 0.00390625f) + -0.001953125f) + _358;
  // float _369 = ((_60 * 0.00390625f) + -0.001953125f) + _359;
  float _367 = RENODX_WUWA_GRAIN * ((_35 * 0.00390625f) + -0.001953125f) + _357;
  float _368 = RENODX_WUWA_GRAIN * ((_59 * 0.00390625f) + -0.001953125f) + _358;
  float _369 = RENODX_WUWA_GRAIN * ((_60 * 0.00390625f) + -0.001953125f) + _359;

  [branch]
  if (!((uint)(cb0_089x) == 0)) {
    float _381 = (pow(_367, 0.012683313339948654f));
    float _382 = (pow(_368, 0.012683313339948654f));
    float _383 = (pow(_369, 0.012683313339948654f));
    float _416 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_381 + -0.8359375f)) / (18.8515625f - (_381 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _417 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_382 + -0.8359375f)) / (18.8515625f - (_382 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _418 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_383 + -0.8359375f)) / (18.8515625f - (_383 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    _444 = min((_416 * 12.920000076293945f), ((exp2(log2(max(_416, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _445 = min((_417 * 12.920000076293945f), ((exp2(log2(max(_417, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _446 = min((_418 * 12.920000076293945f), ((exp2(log2(max(_418, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _444 = _367;
    _445 = _368;
    _446 = _369;
  }
  SV_Target.x = _444;
  SV_Target.y = _445;
  SV_Target.z = _446;

  // SV_Target.w = saturate(dot(float3(_357, _358, _359), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_357, _358, _359), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
