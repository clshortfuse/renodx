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
  float _27 = ((cb0_048x * TEXCOORD_3.x) + cb0_048z) * cb0_047z;
  float _28 = ((cb0_048y * TEXCOORD_3.y) + cb0_048w) * cb0_047w;
  float _29 = TEXCOORD_2.w * 543.3099975585938f;
  float _33 = frac(sin(_29 + TEXCOORD_2.z) * 493013.0f);
  float _57;
  float _58;
  float _119;
  float _120;
  float _188;
  float _189;
  float _339;
  float _340;
  float _341;
  float _373;
  float _374;
  float _375;
  float _422;
  float _423;
  float _424;
  float _537;
  float _538;
  float _539;
  if (cb0_079x > 0.0f) {
    _57 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _29) * 493013.0f) + 7.177000045776367f) - _33)) + _33);
    _58 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _29) * 493013.0f) + 14.298999786376953f) - _33)) + _33);
  } else {
    _57 = _33;
    _58 = _33;
  }
  float _68 = cb0_099z * cb0_098x;
  float _69 = cb0_099z * cb0_098y;
  bool _70 = (cb0_099x == 0.0f);
  float _80 = (cb0_095z * TEXCOORD_3.x) + cb0_095x;
  float _81 = (cb0_095w * TEXCOORD_3.y) + cb0_095y;
  float _92 = float(((int)(uint)((bool)(_80 > 0.0f))) - ((int)(uint)((bool)(_80 < 0.0f))));
  float _93 = float(((int)(uint)((bool)(_81 > 0.0f))) - ((int)(uint)((bool)(_81 < 0.0f))));
  float _98 = saturate(abs(_80) - cb0_098z);
  float _99 = saturate(abs(_81) - cb0_098z);
  float _109 = _81 - ((_99 * _68) * _93);
  float _111 = _81 - ((_99 * _69) * _93);
  bool _112 = (cb0_099x > 0.0f);
  if (_112) {
    _119 = (_109 - (cb0_099w * 0.4000000059604645f));
    _120 = (_111 - (cb0_099w * 0.20000000298023224f));
  } else {
    _119 = _109;
    _120 = _111;
  }
  float4 _154 = t0.Sample(s0, float2(_27, _28));
  float4 _158 = t0.Sample(s0, float2((((cb0_048x * ((cb0_096z * (_80 - ((_98 * select(_70, _68, cb0_098x)) * _92))) + cb0_096x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_096w * _119) + cb0_096y)) + cb0_048w) * cb0_047w)));
  float4 _160 = t0.Sample(s0, float2((((cb0_048x * ((cb0_096z * (_80 - ((_98 * select(_70, _69, cb0_098y)) * _92))) + cb0_096x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_096w * _120) + cb0_096y)) + cb0_048w) * cb0_047w)));
  if (_112) {
    float _170 = saturate(((((_154.y * 0.5870000123977661f) - cb0_099y) + (_154.x * 0.29899999499320984f)) + (_154.z * 0.11400000005960464f)) * 10.0f);
    float _174 = (_170 * _170) * (3.0f - (_170 * 2.0f));
    // _188 = ((((_154.x - _158.x) + (_174 * (_158.x - _154.x))) * cb0_099x) + _158.x);
    // _189 = ((((_154.y - _160.y) + (_174 * (_160.y - _154.y))) * cb0_099x) + _160.y);
    _188 = (RENODX_WUWA_CA * (((_154.x - _158.x) + (_174 * (_158.x - _154.x))) * cb0_099x) + _158.x);
    _189 = (RENODX_WUWA_CA * (((_154.y - _160.y) + (_174 * (_160.y - _154.y))) * cb0_099x) + _160.y);
  } else {
    _188 = _158.x;
    _189 = _160.y;
  }

  float4 _212 = t1.Sample(s1, float2(min(max(((cb0_068x * _27) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _28) + cb0_068w), cb0_060y), cb0_060w)));
  _212.rgb *= RENODX_WUWA_BLOOM;

  float _239 = TEXCOORD_1.z + -1.0f;
  float _241 = TEXCOORD_1.w + -1.0f;
  float _244 = ((_239 + (cb0_073x * 2.0f)) * cb0_071z) * cb0_071x;
  float _246 = ((_241 + (cb0_073y * 2.0f)) * cb0_071w) * cb0_071x;
  float _253 = 1.0f / ((((saturate(cb0_072w) * 9.0f) + 1.0f) * dot(float2(_244, _246), float2(_244, _246))) + 1.0f);
  float _254 = _253 * _253;
  float _281 = ((_239 + (cb0_076x * 2.0f)) * cb0_074z) * cb0_074x;
  float _283 = ((_241 + (cb0_076y * 2.0f)) * cb0_074w) * cb0_074x;
  float _290 = 1.0f / ((((saturate(cb0_075w) * 9.0f) + 1.0f) * dot(float2(_281, _283), float2(_281, _283))) + 1.0f);
  float _291 = _290 * _290;
  float _304 = min(((_254 * (1.0f - cb0_072x)) + cb0_072x), ((_291 * (1.0f - cb0_075x)) + cb0_075x)) * (_212.x + ((_188 * TEXCOORD_1.x) * cb0_069x));
  float _305 = min(((_254 * (1.0f - cb0_072y)) + cb0_072y), ((_291 * (1.0f - cb0_075y)) + cb0_075y)) * (_212.y + ((_189 * TEXCOORD_1.x) * cb0_069y));
  float _306 = min(((_254 * (1.0f - cb0_072z)) + cb0_072z), ((_291 * (1.0f - cb0_075z)) + cb0_075z)) * (_212.z + ((_154.z * TEXCOORD_1.x) * cb0_069z));

  CAPTURE_UNTONEMAPPED(untonemapped, float3(_304, _305, _306));

  [branch]
  // if (!((uint)(cb0_089y) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    // _339 = saturate((((_304 * 1.3600000143051147f) + 0.04699999839067459f) * _304) / ((((_304 * 0.9599999785423279f) + 0.5600000023841858f) * _304) + 0.14000000059604645f));
    // _340 = saturate((((_305 * 1.3600000143051147f) + 0.04699999839067459f) * _305) / ((((_305 * 0.9599999785423279f) + 0.5600000023841858f) * _305) + 0.14000000059604645f));
    // _341 = saturate((((_306 * 1.3600000143051147f) + 0.04699999839067459f) * _306) / ((((_306 * 0.9599999785423279f) + 0.5600000023841858f) * _306) + 0.14000000059604645f));
    _339 = ((((_304 * 1.3600000143051147f) + 0.04699999839067459f) * _304) / ((((_304 * 0.9599999785423279f) + 0.5600000023841858f) * _304) + 0.14000000059604645f));
    _340 = ((((_305 * 1.3600000143051147f) + 0.04699999839067459f) * _305) / ((((_305 * 0.9599999785423279f) + 0.5600000023841858f) * _305) + 0.14000000059604645f));
    _341 = ((((_306 * 1.3600000143051147f) + 0.04699999839067459f) * _306) / ((((_306 * 0.9599999785423279f) + 0.5600000023841858f) * _306) + 0.14000000059604645f));
  } else {
    _339 = _304;
    _340 = _305;
    _341 = _306;
  }
  [branch]
  // if (!((uint)(cb0_089z) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _351 = 1.0049500465393066f - (0.16398000717163086f / (_339 + -0.19505000114440918f));
    float _352 = 1.0049500465393066f - (0.16398000717163086f / (_340 + -0.19505000114440918f));
    float _353 = 1.0049500465393066f - (0.16398000717163086f / (_341 + -0.19505000114440918f));
    // _373 = saturate(((_339 - _351) * select((_339 > 0.6000000238418579f), 0.0f, 1.0f)) + _351);
    // _374 = saturate(((_340 - _352) * select((_340 > 0.6000000238418579f), 0.0f, 1.0f)) + _352);
    // _375 = saturate(((_341 - _353) * select((_341 > 0.6000000238418579f), 0.0f, 1.0f)) + _353);
    _373 = (((_339 - _351) * select((_339 > 0.6000000238418579f), 0.0f, 1.0f)) + _351);
    _374 = (((_340 - _352) * select((_340 > 0.6000000238418579f), 0.0f, 1.0f)) + _352);
    _375 = (((_341 - _353) * select((_341 > 0.6000000238418579f), 0.0f, 1.0f)) + _353);
  } else {
    _373 = _339;
    _374 = _340;
    _375 = _341;
  }
  [branch]
  // if (!((uint)(cb0_089w) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _381 = cb0_037y * _373;
    float _382 = cb0_037y * _374;
    float _383 = cb0_037y * _375;
    float _386 = cb0_037z * cb0_037w;
    float _396 = cb0_038y * cb0_038x;
    float _407 = cb0_038z * cb0_038x;
    float _414 = cb0_038y / cb0_038z;
    // _422 = saturate(((((_386 + _381) * _373) + _396) / (_407 + ((_381 + cb0_037z) * _373))) - _414);
    // _423 = saturate(((((_386 + _382) * _374) + _396) / (_407 + ((_382 + cb0_037z) * _374))) - _414);
    // _424 = saturate(((((_386 + _383) * _375) + _396) / (_407 + ((_383 + cb0_037z) * _375))) - _414);
    _422 = (((((_386 + _381) * _373) + _396) / (_407 + ((_381 + cb0_037z) * _373))) - _414);
    _423 = (((((_386 + _382) * _374) + _396) / (_407 + ((_382 + cb0_037z) * _374))) - _414);
    _424 = (((((_386 + _383) * _375) + _396) / (_407 + ((_383 + cb0_037z) * _375))) - _414);
  } else {
    _422 = _373;
    _423 = _374;
    _424 = _375;
  }

  CLAMP_IF_SDR(_422); CLAMP_IF_SDR(_423); CLAMP_IF_SDR(_424);
  CAPTURE_TONEMAPPED(tonemapped, float3(_422, _423, _424));

  float4 _446 = t2.Sample(s2, float3(((saturate((log2(_422 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_423 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_424 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _446.rgb = HandleLUTOutput(_446.rgb, untonemapped, tonemapped);

  float _450 = _446.x * 1.0499999523162842f;
  float _451 = _446.y * 1.0499999523162842f;
  float _452 = _446.z * 1.0499999523162842f;

  // float _460 = ((_33 * 0.00390625f) + -0.001953125f) + _450;
  // float _461 = ((_57 * 0.00390625f) + -0.001953125f) + _451;
  // float _462 = ((_58 * 0.00390625f) + -0.001953125f) + _452;
  float _460 = RENODX_WUWA_GRAIN * ((_33 * 0.00390625f) + -0.001953125f) + _450;
  float _461 = RENODX_WUWA_GRAIN * ((_57 * 0.00390625f) + -0.001953125f) + _451;
  float _462 = RENODX_WUWA_GRAIN * ((_58 * 0.00390625f) + -0.001953125f) + _452;

  [branch]
  if (!((uint)(cb0_089x) == 0)) {
    float _474 = (pow(_460, 0.012683313339948654f));
    float _475 = (pow(_461, 0.012683313339948654f));
    float _476 = (pow(_462, 0.012683313339948654f));
    float _509 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_474 + -0.8359375f)) / (18.8515625f - (_474 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _510 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_475 + -0.8359375f)) / (18.8515625f - (_475 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _511 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_476 + -0.8359375f)) / (18.8515625f - (_476 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    _537 = min((_509 * 12.920000076293945f), ((exp2(log2(max(_509, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _538 = min((_510 * 12.920000076293945f), ((exp2(log2(max(_510, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _539 = min((_511 * 12.920000076293945f), ((exp2(log2(max(_511, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _537 = _460;
    _538 = _461;
    _539 = _462;
  }
  SV_Target.x = _537;
  SV_Target.y = _538;
  SV_Target.z = _539;

  // SV_Target.w = saturate(dot(float3(_450, _451, _452), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_450, _451, _452), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
