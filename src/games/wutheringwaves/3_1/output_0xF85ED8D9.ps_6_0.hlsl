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
  float cb0_108y : packoffset(c108.y);
  float cb0_108z : packoffset(c108.z);
  float cb0_108w : packoffset(c108.w);
  float cb0_109x : packoffset(c109.x);
  float cb0_109y : packoffset(c109.y);
  float cb0_109z : packoffset(c109.z);
  float cb0_110x : packoffset(c110.x);
  float cb0_110y : packoffset(c110.y);
  float cb0_110z : packoffset(c110.z);
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
  float _275;
  float _276;
  float _277;
  float _310;
  float _311;
  float _312;
  float _344;
  float _345;
  float _346;
  float _393;
  float _394;
  float _395;
  float _410;
  float _411;
  float _412;
  float _499;
  float _500;
  float _501;
  float _586;
  float _587;
  float _588;
  float _637;
  float _638;
  float _639;
  float _640;
  float _641;
  float _642;
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
  float _246 = (((_195 * (_196 - cb0_089x)) + cb0_089x) * (_153 + ((_86.x * TEXCOORD_1.x) * cb0_086x))) * ((_234 * (_235 - cb0_092x)) + cb0_092x);
  float _248 = (((_195 * (_196 - cb0_089y)) + cb0_089y) * (_154 + ((_86.y * TEXCOORD_1.x) * cb0_086y))) * ((_234 * (_235 - cb0_092y)) + cb0_092y);
  float _250 = (((_195 * (_196 - cb0_089z)) + cb0_089z) * (_155 + ((_86.z * TEXCOORD_1.x) * cb0_086z))) * ((_234 * (_235 - cb0_092z)) + cb0_092z);

  CAPTURE_UNTONEMAPPED(float3(_246, _248, _250));



  [branch]
  if (!(cb0_111w == 0)) {
    float _264 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _275 = (1.0f - exp2(_264 * _246));
    _276 = (1.0f - exp2(_264 * _248));
    _277 = (1.0f - exp2(_264 * _250));
  } else {
    _275 = _246;
    _276 = _248;
    _277 = _250;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _310 = ((((_275 * 1.3600000143051147f) + 0.04699999839067459f) * _275) / ((((_275 * 0.9599999785423279f) + 0.5600000023841858f) * _275) + 0.14000000059604645f));
    _311 = ((((_276 * 1.3600000143051147f) + 0.04699999839067459f) * _276) / ((((_276 * 0.9599999785423279f) + 0.5600000023841858f) * _276) + 0.14000000059604645f));
    _312 = ((((_277 * 1.3600000143051147f) + 0.04699999839067459f) * _277) / ((((_277 * 0.9599999785423279f) + 0.5600000023841858f) * _277) + 0.14000000059604645f));
  } else {
    _310 = _275;
    _311 = _276;
    _312 = _277;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _322 = 1.0049500465393066f - (0.16398000717163086f / (_310 + -0.19505000114440918f));
    float _323 = 1.0049500465393066f - (0.16398000717163086f / (_311 + -0.19505000114440918f));
    float _324 = 1.0049500465393066f - (0.16398000717163086f / (_312 + -0.19505000114440918f));
    _344 = (((_310 - _322) * select((_310 > 0.6000000238418579f), 0.0f, 1.0f)) + _322);
    _345 = (((_311 - _323) * select((_311 > 0.6000000238418579f), 0.0f, 1.0f)) + _323);
    _346 = (((_312 - _324) * select((_312 > 0.6000000238418579f), 0.0f, 1.0f)) + _324);
  } else {
    _344 = _310;
    _345 = _311;
    _346 = _312;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _352 = cb0_037y * _344;
    float _353 = cb0_037y * _345;
    float _354 = cb0_037y * _346;
    float _357 = cb0_037z * cb0_037w;
    float _367 = cb0_038y * cb0_038x;
    float _378 = cb0_038z * cb0_038x;
    float _385 = cb0_038y / cb0_038z;
    _393 = (((((_357 + _352) * _344) + _367) / (((_352 + cb0_037z) * _344) + _378)) - _385);
    _394 = (((((_357 + _353) * _345) + _367) / (((_353 + cb0_037z) * _345) + _378)) - _385);
    _395 = (((((_357 + _354) * _346) + _367) / (((_354 + cb0_037z) * _346) + _378)) - _385);
  } else {
    _393 = _344;
    _394 = _345;
    _395 = _346;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _405 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _410 = (_405 * _393);
      _411 = (_405 * _394);
      _412 = (_405 * _395);
    } else {
      _410 = _393;
      _411 = _394;
      _412 = _395;
    }
  } else {
    _410 = _393;
    _411 = _394;
    _412 = _395;
  }
  CLAMP_IF_SDR3(_410, _411, _412);
  CAPTURE_TONEMAPPED(float3(_410, _411, _412));
  float _427 = (saturate((log2(_412 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _431 = (saturate((log2(_411 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _435 = (saturate((log2(_410 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!(cb0_107w == 0)) {
    float4 _456 = t3.Sample(s3, float2(min(max(((cb0_084z * _74) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _75) + cb0_085y), cb0_083w), cb0_084y)));
    float _466 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_456.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _467 = t5.Sample(s5, float3(_435, _431, _427));
    float4 _474 = t4.Sample(s4, float3(_435, _431, _427));
    _499 = ((((_474.x - _467.x) * 1.0499999523162842f) * _466) + (_467.x * 1.0499999523162842f));
    _500 = ((((_474.y - _467.y) * 1.0499999523162842f) * _466) + (_467.y * 1.0499999523162842f));
    _501 = ((((_474.z - _467.z) * 1.0499999523162842f) * _466) + (_467.z * 1.0499999523162842f));
  } else {
    float4 _491 = t4.Sample(s4, float3(_435, _431, _427));
    _499 = (_491.x * 1.0499999523162842f);
    _500 = (_491.y * 1.0499999523162842f);
    _501 = (_491.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3_FADE(_499, _500, _501, t4, s4);
  float _509 = ((_41 * 0.00390625f) + -0.001953125f) + _499;
  float _510 = ((_63 * 0.00390625f) + -0.001953125f) + _500;
  float _511 = ((_64 * 0.00390625f) + -0.001953125f) + _501;
  [branch]
  if (!(cb0_106w == 0)) {
    float _523 = (pow(_509, 0.012683313339948654f));
    float _524 = (pow(_510, 0.012683313339948654f));
    float _525 = (pow(_511, 0.012683313339948654f));
    float _558 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_523 + -0.8359375f)) / (18.8515625f - (_523 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _559 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_524 + -0.8359375f)) / (18.8515625f - (_524 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _560 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_525 + -0.8359375f)) / (18.8515625f - (_525 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _586 = min((_558 * 12.920000076293945f), ((exp2(log2(max(_558, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _587 = min((_559 * 12.920000076293945f), ((exp2(log2(max(_559, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _588 = min((_560 * 12.920000076293945f), ((exp2(log2(max(_560, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _586 = _509;
    _587 = _510;
    _588 = _511;
  }
  GENERATE_INVERSION(_586, _587, _588);

  float _597 = ((((_587 * 587.0f) + (_586 * 299.0f)) + (_588 * 114.0f)) * 0.0010000000474974513f) - cb0_108w;
  float _604 = saturate(float((int)(((int)(uint)((bool)(_597 > 0.0f))) - ((int)(uint)((bool)(_597 < 0.0f))))));
  float _611 = cb0_109x - _586;
  float _612 = cb0_109y - _587;
  float _613 = cb0_109z - _588;
  float _618 = (WUWA_PEAK_SCALING * cb0_110x) - _586;
  float _619 = (WUWA_PEAK_SCALING * cb0_110y) - _587;
  float _620 = (WUWA_PEAK_SCALING * cb0_110z) - _588;
  [branch]
  if (cb0_108z > 0.0f) {
    _637 = (_611 * cb0_108z);
    _638 = (_612 * cb0_108z);
    _639 = (_613 * cb0_108z);
    _640 = (_618 * cb0_108z);
    _641 = (_619 * cb0_108z);
    _642 = (_620 * cb0_108z);
  } else {
    float _629 = abs(cb0_108z);
    _637 = (_629 * _618);
    _638 = (_629 * _619);
    _639 = (_629 * _620);
    _640 = (_629 * _611);
    _641 = (_629 * _612);
    _642 = (_629 * _613);
  }
  SV_Target.x = (((lerp(_637, _640, _604)) * cb0_108y) + _586);
  SV_Target.y = (((lerp(_638, _641, _604)) * cb0_108y) + _587);
  SV_Target.z = (((lerp(_639, _642, _604)) * cb0_108y) + _588);
  SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);
  SV_Target.w = dot(float3(_499, _500, _501), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
