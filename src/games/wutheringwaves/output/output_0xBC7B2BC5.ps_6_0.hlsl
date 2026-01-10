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
  float cb0_090x : packoffset(c090.x);
  float cb0_090y : packoffset(c090.y);
  float cb0_090z : packoffset(c090.z);
  float cb0_091x : packoffset(c091.x);
  float cb0_091y : packoffset(c091.y);
  float cb0_091z : packoffset(c091.z);
  float cb0_092x : packoffset(c092.x);
  float cb0_092y : packoffset(c092.y);
  float cb0_092z : packoffset(c092.z);
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
  float _212;
  float _213;
  float _214;
  float _246;
  float _247;
  float _248;
  float _295;
  float _296;
  float _297;
  float _410;
  float _411;
  float _412;
  float _461;
  float _462;
  float _463;
  float _464;
  float _465;
  float _466;
  if (cb0_079x > 0.0f) {
    _57 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _29) * 493013.0f) + 7.177000045776367f) - _33)) + _33);
    _58 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _29) * 493013.0f) + 14.298999786376953f) - _33)) + _33);
  } else {
    _57 = _33;
    _58 = _33;
  }
  float4 _59 = t0.Sample(s0, float2(_27, _28));

  float4 _85 = t1.Sample(s1, float2(min(max(((cb0_068x * _27) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _28) + cb0_068w), cb0_060y), cb0_060w)));
  _85.rgb *= RENODX_WUWA_BLOOM;

  float _112 = TEXCOORD_1.z + -1.0f;
  float _114 = TEXCOORD_1.w + -1.0f;
  float _117 = ((_112 + (cb0_073x * 2.0f)) * cb0_071z) * cb0_071x;
  float _119 = ((_114 + (cb0_073y * 2.0f)) * cb0_071w) * cb0_071x;
  float _126 = 1.0f / ((((saturate(cb0_072w) * 9.0f) + 1.0f) * dot(float2(_117, _119), float2(_117, _119))) + 1.0f);
  float _127 = _126 * _126;
  float _154 = ((_112 + (cb0_076x * 2.0f)) * cb0_074z) * cb0_074x;
  float _156 = ((_114 + (cb0_076y * 2.0f)) * cb0_074w) * cb0_074x;
  float _163 = 1.0f / ((((saturate(cb0_075w) * 9.0f) + 1.0f) * dot(float2(_154, _156), float2(_154, _156))) + 1.0f);
  float _164 = _163 * _163;
  float _177 = min(((_127 * (1.0f - cb0_072x)) + cb0_072x), ((_164 * (1.0f - cb0_075x)) + cb0_075x)) * (_85.x + ((_59.x * TEXCOORD_1.x) * cb0_069x));
  float _178 = min(((_127 * (1.0f - cb0_072y)) + cb0_072y), ((_164 * (1.0f - cb0_075y)) + cb0_075y)) * (_85.y + ((_59.y * TEXCOORD_1.x) * cb0_069y));
  float _179 = min(((_127 * (1.0f - cb0_072z)) + cb0_072z), ((_164 * (1.0f - cb0_075z)) + cb0_075z)) * (_85.z + ((_59.z * TEXCOORD_1.x) * cb0_069z));

  CAPTURE_UNTONEMAPPED(float3(_177, _178, _179));

  [branch]
  // if (!((uint)(cb0_089y) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    // _212 = saturate((((_177 * 1.3600000143051147f) + 0.04699999839067459f) * _177) / ((((_177 * 0.9599999785423279f) + 0.5600000023841858f) * _177) + 0.14000000059604645f));
    // _213 = saturate((((_178 * 1.3600000143051147f) + 0.04699999839067459f) * _178) / ((((_178 * 0.9599999785423279f) + 0.5600000023841858f) * _178) + 0.14000000059604645f));
    // _214 = saturate((((_179 * 1.3600000143051147f) + 0.04699999839067459f) * _179) / ((((_179 * 0.9599999785423279f) + 0.5600000023841858f) * _179) + 0.14000000059604645f));
    _212 = ((((_177 * 1.3600000143051147f) + 0.04699999839067459f) * _177) / ((((_177 * 0.9599999785423279f) + 0.5600000023841858f) * _177) + 0.14000000059604645f));
    _213 = ((((_178 * 1.3600000143051147f) + 0.04699999839067459f) * _178) / ((((_178 * 0.9599999785423279f) + 0.5600000023841858f) * _178) + 0.14000000059604645f));
    _214 = ((((_179 * 1.3600000143051147f) + 0.04699999839067459f) * _179) / ((((_179 * 0.9599999785423279f) + 0.5600000023841858f) * _179) + 0.14000000059604645f));
  } else {
    _212 = _177;
    _213 = _178;
    _214 = _179;
  }
  [branch]
  // if (!((uint)(cb0_089z) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _224 = 1.0049500465393066f - (0.16398000717163086f / (_212 + -0.19505000114440918f));
    float _225 = 1.0049500465393066f - (0.16398000717163086f / (_213 + -0.19505000114440918f));
    float _226 = 1.0049500465393066f - (0.16398000717163086f / (_214 + -0.19505000114440918f));
    // _246 = saturate(((_212 - _224) * select((_212 > 0.6000000238418579f), 0.0f, 1.0f)) + _224);
    // _247 = saturate(((_213 - _225) * select((_213 > 0.6000000238418579f), 0.0f, 1.0f)) + _225);
    // _248 = saturate(((_214 - _226) * select((_214 > 0.6000000238418579f), 0.0f, 1.0f)) + _226);
    _246 = (((_212 - _224) * select((_212 > 0.6000000238418579f), 0.0f, 1.0f)) + _224);
    _247 = (((_213 - _225) * select((_213 > 0.6000000238418579f), 0.0f, 1.0f)) + _225);
    _248 = (((_214 - _226) * select((_214 > 0.6000000238418579f), 0.0f, 1.0f)) + _226);
  } else {
    _246 = _212;
    _247 = _213;
    _248 = _214;
  }
  [branch]
  // if (!((uint)(cb0_089w) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _254 = cb0_037y * _246;
    float _255 = cb0_037y * _247;
    float _256 = cb0_037y * _248;
    float _259 = cb0_037z * cb0_037w;
    float _269 = cb0_038y * cb0_038x;
    float _280 = cb0_038z * cb0_038x;
    float _287 = cb0_038y / cb0_038z;
    // _295 = saturate(((((_259 + _254) * _246) + _269) / (_280 + ((_254 + cb0_037z) * _246))) - _287);
    // _296 = saturate(((((_259 + _255) * _247) + _269) / (_280 + ((_255 + cb0_037z) * _247))) - _287);
    // _297 = saturate(((((_259 + _256) * _248) + _269) / (_280 + ((_256 + cb0_037z) * _248))) - _287);
    _295 = (((((_259 + _254) * _246) + _269) / (_280 + ((_254 + cb0_037z) * _246))) - _287);
    _296 = (((((_259 + _255) * _247) + _269) / (_280 + ((_255 + cb0_037z) * _247))) - _287);
    _297 = (((((_259 + _256) * _248) + _269) / (_280 + ((_256 + cb0_037z) * _248))) - _287);
  } else {
    _295 = _246;
    _296 = _247;
    _297 = _248;
  }

  CLAMP_IF_SDR(_295); CLAMP_IF_SDR(_296); CLAMP_IF_SDR(_297);
  CAPTURE_TONEMAPPED(float3(_295, _296, _297));

  float4 _319 = t2.Sample(s2, float3(((saturate((log2(_295 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_296 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_297 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _319.rgb = HandleLUTOutput(_319.rgb, untonemapped, tonemapped);

  float _323 = _319.x * 1.0499999523162842f;
  float _324 = _319.y * 1.0499999523162842f;
  float _325 = _319.z * 1.0499999523162842f;

  // float _333 = ((_33 * 0.00390625f) + -0.001953125f) + _323;
  // float _334 = ((_57 * 0.00390625f) + -0.001953125f) + _324;
  // float _335 = ((_58 * 0.00390625f) + -0.001953125f) + _325;
  float _333 = RENODX_WUWA_GRAIN * ((_33 * 0.00390625f) + -0.001953125f) + _323;
  float _334 = RENODX_WUWA_GRAIN * ((_57 * 0.00390625f) + -0.001953125f) + _324;
  float _335 = RENODX_WUWA_GRAIN * ((_58 * 0.00390625f) + -0.001953125f) + _325;

  [branch]
  if (!((uint)(cb0_089x) == 0)) {
    float _347 = (pow(_333, 0.012683313339948654f));
    float _348 = (pow(_334, 0.012683313339948654f));
    float _349 = (pow(_335, 0.012683313339948654f));
    float _382 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_347 + -0.8359375f)) / (18.8515625f - (_347 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _383 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_348 + -0.8359375f)) / (18.8515625f - (_348 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _384 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_349 + -0.8359375f)) / (18.8515625f - (_349 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    _410 = min((_382 * 12.920000076293945f), ((exp2(log2(max(_382, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _411 = min((_383 * 12.920000076293945f), ((exp2(log2(max(_383, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _412 = min((_384 * 12.920000076293945f), ((exp2(log2(max(_384, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _410 = _333;
    _411 = _334;
    _412 = _335;
  }

  const float3 inverted = renodx::draw::InvertIntermediatePass(float3(_410, _411, _412));
  _410 = inverted.r; _411 = inverted.g; _412 = inverted.b;

  float _421 = ((((_411 * 587.0f) + (_410 * 299.0f)) + (_412 * 114.0f)) * 0.0010000000474974513f) - cb0_090z;
  float _428 = saturate(float(((int)(uint)((bool)(_421 > 0.0f))) - ((int)(uint)((bool)(_421 < 0.0f)))));
  float _435 = cb0_091x - _410;
  float _436 = cb0_091y - _411;
  float _437 = cb0_091z - _412;

  const float peak_scaling = RENODX_PEAK_NITS / RENODX_GAME_NITS;
  // float _442 = cb0_092x - _410;
  // float _443 = cb0_092y - _411;
  // float _444 = cb0_092z - _412;
  float _442 = peak_scaling * cb0_092x - _410;
  float _443 = peak_scaling * cb0_092y - _411;
  float _444 = peak_scaling * cb0_092z - _412;

  [branch]
  if (cb0_090y > 0.0f) {
    _461 = (_435 * cb0_090y);
    _462 = (_436 * cb0_090y);
    _463 = (_437 * cb0_090y);
    _464 = (_442 * cb0_090y);
    _465 = (_443 * cb0_090y);
    _466 = (_444 * cb0_090y);
  } else {
    float _453 = abs(cb0_090y);
    _461 = (_442 * _453);
    _462 = (_443 * _453);
    _463 = (_444 * _453);
    _464 = (_435 * _453);
    _465 = (_436 * _453);
    _466 = (_437 * _453);
  }
  SV_Target.x = ((cb0_090x * (lerp(_461, _464, _428))) + _410);
  SV_Target.y = ((cb0_090x * (lerp(_462, _465, _428))) + _411);
  SV_Target.z = (((lerp(_463, _466, _428)) * cb0_090x) + _412);

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);

  // SV_Target.w = saturate(dot(float3(_323, _324, _325), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_323, _324, _325), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
