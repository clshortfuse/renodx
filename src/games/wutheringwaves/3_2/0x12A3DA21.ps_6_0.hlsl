#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture3D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

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
  float cb0_109x : packoffset(c109.x);
  float cb0_109y : packoffset(c109.y);
  float cb0_109z : packoffset(c109.z);
  float cb0_110x : packoffset(c110.x);
  float cb0_110y : packoffset(c110.y);
  float cb0_110z : packoffset(c110.z);
  float cb0_111x : packoffset(c111.x);
  float cb0_111y : packoffset(c111.y);
  float cb0_111z : packoffset(c111.z);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

SamplerState s4 : register(s4);

SamplerState s5 : register(s5);

SamplerState s6 : register(s6);

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
  float _37 = TEXCOORD_2.w * 543.3099975585938f;
  float _41 = frac(sin(_37 + TEXCOORD_2.z) * 493013.0f);
  float _65;
  float _66;
  float _135;
  float _136;
  float _137;
  float _149;
  float _150;
  float _151;
  float _279;
  float _280;
  float _281;
  float _313;
  float _314;
  float _315;
  float _362;
  float _363;
  float _364;
  float _379;
  float _380;
  float _381;
  float _454;
  float _455;
  float _456;
  float _544;
  float _545;
  float _546;
  float _595;
  float _596;
  float _597;
  float _598;
  float _599;
  float _600;
  if (cb0_097x > 0.0f) {
    _65 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _37) * 493013.0f) + 7.177000045776367f) - _41)) + _41);
    _66 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _37) * 493013.0f) + 14.298999786376953f) - _41)) + _41);
  } else {
    _65 = _41;
    _66 = _41;
  }
  float4 _67 = t0.Sample(s0, float2(_35, _36));
  float4 _95 = t1.Sample(s1, float2(min(max(((cb0_068z * _35) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _36) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_95);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _124 = (cb0_086x != 0);
    float4 _127 = t2.Sample(s2, float2(select(_124, _35, min(max(((cb0_076z * _35) + cb0_077x), cb0_075z), cb0_076x)), select(_124, _36, min(max(((cb0_076w * _36) + cb0_077y), cb0_075w), cb0_076y))));
    _135 = (_127.x + _95.x);
    _136 = (_127.y + _95.y);
    _137 = (_127.z + _95.z);
  } else {
    _135 = _95.x;
    _136 = _95.y;
    _137 = _95.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _141 = t3.Sample(s3, float2(_35, _36));
    _149 = (_141.x + _135);
    _150 = (_141.y + _136);
    _151 = (_141.z + _137);
  } else {
    _149 = _135;
    _150 = _136;
    _151 = _137;
  }
  float _176 = TEXCOORD_1.z + -1.0f;
  float _178 = TEXCOORD_1.w + -1.0f;
  float _181 = ((_176 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _183 = ((_178 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _190 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_181, _183), float2(_181, _183))) + 1.0f);
  float _191 = _190 * _190;
  float _192 = cb0_091z + 1.0f;
  float _220 = ((_176 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _222 = ((_178 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _229 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_220, _222), float2(_220, _222))) + 1.0f);
  float _230 = _229 * _229;
  float _231 = cb0_094z + 1.0f;
  float _242 = (((_191 * (_192 - cb0_090x)) + cb0_090x) * (_149 + ((_67.x * TEXCOORD_1.x) * cb0_087x))) * ((_230 * (_231 - cb0_093x)) + cb0_093x);
  float _244 = (((_191 * (_192 - cb0_090y)) + cb0_090y) * (_150 + ((_67.y * TEXCOORD_1.x) * cb0_087y))) * ((_230 * (_231 - cb0_093y)) + cb0_093y);
  float _246 = (((_191 * (_192 - cb0_090z)) + cb0_090z) * (_151 + ((_67.z * TEXCOORD_1.x) * cb0_087z))) * ((_230 * (_231 - cb0_093z)) + cb0_093z);

  CAPTURE_UNTONEMAPPED(float3(_242, _244, _246));
  [branch]
  if (WUWA_TM_IS(1)) {
    _279 = ((((_242 * 1.3600000143051147f) + 0.04699999839067459f) * _242) / ((((_242 * 0.9599999785423279f) + 0.5600000023841858f) * _242) + 0.14000000059604645f));
    _280 = ((((_244 * 1.3600000143051147f) + 0.04699999839067459f) * _244) / ((((_244 * 0.9599999785423279f) + 0.5600000023841858f) * _244) + 0.14000000059604645f));
    _281 = ((((_246 * 1.3600000143051147f) + 0.04699999839067459f) * _246) / ((((_246 * 0.9599999785423279f) + 0.5600000023841858f) * _246) + 0.14000000059604645f));
  } else {
    _279 = _242;
    _280 = _244;
    _281 = _246;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _291 = 1.0049500465393066f - (0.16398000717163086f / (_279 + -0.19505000114440918f));
    float _292 = 1.0049500465393066f - (0.16398000717163086f / (_280 + -0.19505000114440918f));
    float _293 = 1.0049500465393066f - (0.16398000717163086f / (_281 + -0.19505000114440918f));
    _313 = (((_279 - _291) * select((_279 > 0.6000000238418579f), 0.0f, 1.0f)) + _291);
    _314 = (((_280 - _292) * select((_280 > 0.6000000238418579f), 0.0f, 1.0f)) + _292);
    _315 = (((_281 - _293) * select((_281 > 0.6000000238418579f), 0.0f, 1.0f)) + _293);
  } else {
    _313 = _279;
    _314 = _280;
    _315 = _281;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _321 = cb0_037y * _313;
    float _322 = cb0_037y * _314;
    float _323 = cb0_037y * _315;
    float _326 = cb0_037z * cb0_037w;
    float _336 = cb0_038y * cb0_038x;
    float _347 = cb0_038z * cb0_038x;
    float _354 = cb0_038y / cb0_038z;
    _362 = (((((_326 + _321) * _313) + _336) / (_347 + ((_321 + cb0_037z) * _313))) - _354);
    _363 = (((((_326 + _322) * _314) + _336) / (_347 + ((_322 + cb0_037z) * _314))) - _354);
    _364 = (((((_326 + _323) * _315) + _336) / (_347 + ((_323 + cb0_037z) * _315))) - _354);
  } else {
    _362 = _313;
    _363 = _314;
    _364 = _315;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _374 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _379 = (_374 * _362);
      _380 = (_374 * _363);
      _381 = (_374 * _364);
    } else {
      _379 = _362;
      _380 = _363;
      _381 = _364;
    }
  } else {
    _379 = _362;
    _380 = _363;
    _381 = _364;
  }
  CLAMP_IF_SDR3(_379, _380, _381);
  CAPTURE_TONEMAPPED(float3(_379, _380, _381));
  float _402 = (saturate((log2(_379 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _403 = (saturate((log2(_380 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _404 = (saturate((log2(_381 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _405 = t5.Sample(s5, float3(_402, _403, _404));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _429 = t4.Sample(s4, float2(min(max(((cb0_084z * _35) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _36) + cb0_085y), cb0_083w), cb0_084y)));
    float _439 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_429.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _440 = t6.Sample(s6, float3(_402, _403, _404));
    _454 = (lerp(_440.x, _405.x, _439));
    _455 = (lerp(_440.y, _405.y, _439));
    _456 = (lerp(_440.z, _405.z, _439));
  } else {
    _454 = _405.x;
    _455 = _405.y;
    _456 = _405.z;
  }
  HANDLE_LUT_OUTPUT3_FADE(_454, _455, _456, t5, s5);
  float _457 = _456 * 1.0499999523162842f;
  float _458 = _455 * 1.0499999523162842f;
  float _459 = _454 * 1.0499999523162842f;
  float _467 = ((_41 * 0.00390625f) + -0.001953125f) + _459;
  float _468 = ((_65 * 0.00390625f) + -0.001953125f) + _458;
  float _469 = ((_66 * 0.00390625f) + -0.001953125f) + _457;
  [branch]
  if (!(cb0_107w == 0)) {
    float _481 = (pow(_467, 0.012683313339948654f));
    float _482 = (pow(_468, 0.012683313339948654f));
    float _483 = (pow(_469, 0.012683313339948654f));
    float _516 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_481 + -0.8359375f)) / (18.8515625f - (_481 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _517 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_482 + -0.8359375f)) / (18.8515625f - (_482 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _518 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_483 + -0.8359375f)) / (18.8515625f - (_483 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _544 = min((_516 * 12.920000076293945f), ((exp2(log2(max(_516, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _545 = min((_517 * 12.920000076293945f), ((exp2(log2(max(_517, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _546 = min((_518 * 12.920000076293945f), ((exp2(log2(max(_518, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _544 = _467;
    _545 = _468;
    _546 = _469;
  }
  GENERATE_INVERSION(_544, _545, _546);

  float _555 = ((((_545 * 587.0f) + (_544 * 299.0f)) + (_546 * 114.0f)) * 0.0010000000474974513f) - cb0_109z;
  float _562 = saturate(float((int)(((int)(uint)((bool)(_555 > 0.0f))) - ((int)(uint)((bool)(_555 < 0.0f))))));
  float _569 = cb0_110x - _544;
  float _570 = cb0_110y - _545;
  float _571 = cb0_110z - _546;
  float _576 = (WUWA_PEAK_SCALING * cb0_111x) - _544;
  float _577 = (WUWA_PEAK_SCALING * cb0_111y) - _545;
  float _578 = (WUWA_PEAK_SCALING * cb0_111z) - _546;
  [branch]
  if (cb0_109y > 0.0f) {
    _595 = (_569 * cb0_109y);
    _596 = (_570 * cb0_109y);
    _597 = (_571 * cb0_109y);
    _598 = (_576 * cb0_109y);
    _599 = (_577 * cb0_109y);
    _600 = (_578 * cb0_109y);
  } else {
    float _587 = abs(cb0_109y);
    _595 = (_576 * _587);
    _596 = (_577 * _587);
    _597 = (_578 * _587);
    _598 = (_569 * _587);
    _599 = (_570 * _587);
    _600 = (_571 * _587);
  }
  SV_Target.x = ((cb0_109x * (lerp(_595, _598, _562))) + _544);
  SV_Target.y = ((cb0_109x * (lerp(_596, _599, _562))) + _545);
  SV_Target.z = (((lerp(_597, _600, _562)) * cb0_109x) + _546);
  SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);
  SV_Target.w = dot(float3(_459, _458, _457), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
