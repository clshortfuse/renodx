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
  float cb0_096z : packoffset(c096.z);
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
  float _44 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _45 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _46 = TEXCOORD_2.w * 543.3099975585938f;
  float _50 = frac(sin(_46 + TEXCOORD_2.z) * 493013.0f);
  float _74;
  float _75;
  float _159;
  float _231;
  float _232;
  float _233;
  float _245;
  float _246;
  float _247;
  float _376;
  float _377;
  float _378;
  float _410;
  float _411;
  float _412;
  float _459;
  float _460;
  float _461;
  float _476;
  float _477;
  float _478;
  float _551;
  float _552;
  float _553;
  float _641;
  float _642;
  float _643;
  if (cb0_097x > 0.0f) {
    _74 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _46) * 493013.0f) + 7.177000045776367f) - _50)) + _50);
    _75 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _46) * 493013.0f) + 14.298999786376953f) - _50)) + _50);
  } else {
    _74 = _50;
    _75 = _50;
  }
  float _80 = cb0_096z * (1.0f - (_50 * _50));
  float _85 = (_80 * (TEXCOORD_2.x - _44)) + _44;
  float _86 = (_80 * (TEXCOORD_2.y - _45)) + _45;
  float4 _97 = t0.Sample(s0, float2(min(max(_85, cb0_053z), cb0_054x), min(max(_86, cb0_053w), cb0_054y)));
  float _109 = log2(max(dot(float3(_97.x, _97.y, _97.z), float3(cb0_043x, cb0_043y, cb0_043z)), cb0_042x));
  float4 _127 = t5.Sample(s5, float3((cb0_046z * TEXCOORD_4.x), (cb0_046w * TEXCOORD_4.y), ((((cb0_041z * _109) + cb0_041w) * 0.96875f) + 0.015625f)));
  float4 _131 = t6.Sample(s6, float2(TEXCOORD_4.x, TEXCOORD_4.y));
  float _134 = select((_127.y < 0.0010000000474974513f), _131.x, (_127.x / _127.y));
  float _137 = log2(TEXCOORD_1.x);
  float _139 = (_134 + _137) + ((_131.x - _134) * cb0_046x);
  float _144 = _137 + _109;
  float _146 = _139 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_046y);
  bool _147 = (_146 > 0.0f);
  if (_147) {
    _159 = max(0.0f, (_146 - cb0_047x));
  } else {
    _159 = min(0.0f, (cb0_047y + _146));
  }
  float4 _191 = t1.Sample(s1, float2(min(max(((cb0_068z * _85) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _86) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_191);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _220 = (cb0_086x != 0);
    float4 _223 = t2.Sample(s2, float2(select(_220, _85, min(max(((cb0_076z * _85) + cb0_077x), cb0_075z), cb0_076x)), select(_220, _86, min(max(((cb0_076w * _86) + cb0_077y), cb0_075w), cb0_076y))));
    _231 = (_223.x + _191.x);
    _232 = (_223.y + _191.y);
    _233 = (_223.z + _191.z);
  } else {
    _231 = _191.x;
    _232 = _191.y;
    _233 = _191.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _237 = t3.Sample(s3, float2(_85, _86));
    _245 = (_237.x + _231);
    _246 = (_237.y + _232);
    _247 = (_237.z + _233);
  } else {
    _245 = _231;
    _246 = _232;
    _247 = _233;
  }
  float _248 = exp2((((_139 - _144) + ((_144 - _139) * cb0_045w)) - _159) + (_159 * select(_147, cb0_045y, cb0_045z))) * TEXCOORD_1.x;
  float _273 = TEXCOORD_1.z + -1.0f;
  float _275 = TEXCOORD_1.w + -1.0f;
  float _278 = ((_273 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _280 = ((_275 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _287 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_278, _280), float2(_278, _280))) + 1.0f);
  float _288 = _287 * _287;
  float _289 = cb0_091z + 1.0f;
  float _317 = ((_273 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _319 = ((_275 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _326 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_317, _319), float2(_317, _319))) + 1.0f);
  float _327 = _326 * _326;
  float _328 = cb0_094z + 1.0f;
  float _339 = (((_288 * (_289 - cb0_090x)) + cb0_090x) * (_245 + ((_248 * _97.x) * cb0_087x))) * ((_327 * (_328 - cb0_093x)) + cb0_093x);
  float _341 = (((_288 * (_289 - cb0_090y)) + cb0_090y) * (_246 + ((_248 * _97.y) * cb0_087y))) * ((_327 * (_328 - cb0_093y)) + cb0_093y);
  float _343 = (((_288 * (_289 - cb0_090z)) + cb0_090z) * (_247 + ((_248 * _97.z) * cb0_087z))) * ((_327 * (_328 - cb0_093z)) + cb0_093z);

  CAPTURE_UNTONEMAPPED(float3(_339, _341, _343));
  [branch]
  if (WUWA_TM_IS(1)) {
    _376 = ((((_339 * 1.3600000143051147f) + 0.04699999839067459f) * _339) / ((((_339 * 0.9599999785423279f) + 0.5600000023841858f) * _339) + 0.14000000059604645f));
    _377 = ((((_341 * 1.3600000143051147f) + 0.04699999839067459f) * _341) / ((((_341 * 0.9599999785423279f) + 0.5600000023841858f) * _341) + 0.14000000059604645f));
    _378 = ((((_343 * 1.3600000143051147f) + 0.04699999839067459f) * _343) / ((((_343 * 0.9599999785423279f) + 0.5600000023841858f) * _343) + 0.14000000059604645f));
  } else {
    _376 = _339;
    _377 = _341;
    _378 = _343;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _388 = 1.0049500465393066f - (0.16398000717163086f / (_376 + -0.19505000114440918f));
    float _389 = 1.0049500465393066f - (0.16398000717163086f / (_377 + -0.19505000114440918f));
    float _390 = 1.0049500465393066f - (0.16398000717163086f / (_378 + -0.19505000114440918f));
    _410 = (((_376 - _388) * select((_376 > 0.6000000238418579f), 0.0f, 1.0f)) + _388);
    _411 = (((_377 - _389) * select((_377 > 0.6000000238418579f), 0.0f, 1.0f)) + _389);
    _412 = (((_378 - _390) * select((_378 > 0.6000000238418579f), 0.0f, 1.0f)) + _390);
  } else {
    _410 = _376;
    _411 = _377;
    _412 = _378;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _418 = cb0_037y * _410;
    float _419 = cb0_037y * _411;
    float _420 = cb0_037y * _412;
    float _423 = cb0_037z * cb0_037w;
    float _433 = cb0_038y * cb0_038x;
    float _444 = cb0_038z * cb0_038x;
    float _451 = cb0_038y / cb0_038z;
    _459 = (((((_423 + _418) * _410) + _433) / (_444 + ((_418 + cb0_037z) * _410))) - _451);
    _460 = (((((_423 + _419) * _411) + _433) / (_444 + ((_419 + cb0_037z) * _411))) - _451);
    _461 = (((((_423 + _420) * _412) + _433) / (_444 + ((_420 + cb0_037z) * _412))) - _451);
  } else {
    _459 = _410;
    _460 = _411;
    _461 = _412;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _471 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _476 = (_471 * _459);
      _477 = (_471 * _460);
      _478 = (_471 * _461);
    } else {
      _476 = _459;
      _477 = _460;
      _478 = _461;
    }
  } else {
    _476 = _459;
    _477 = _460;
    _478 = _461;
  }
  APPLY_EXTENDED_TONEMAP(_476, _477, _478);
  float _499 = (saturate((log2(_476 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _500 = (saturate((log2(_477 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _501 = (saturate((log2(_478 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _502 = t7.Sample(s7, float3(_499, _500, _501));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _526 = t4.Sample(s4, float2(min(max(((cb0_084z * _85) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _86) + cb0_085y), cb0_083w), cb0_084y)));
    float _536 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_526.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _537 = t8.Sample(s8, float3(_499, _500, _501));
    _551 = (lerp(_537.x, _502.x, _536));
    _552 = (lerp(_537.y, _502.y, _536));
    _553 = (lerp(_537.z, _502.z, _536));
  } else {
    _551 = _502.x;
    _552 = _502.y;
    _553 = _502.z;
  }
  float _554 = _553 * 1.0499999523162842f;
  float _555 = _552 * 1.0499999523162842f;
  float _556 = _551 * 1.0499999523162842f;
  float _564 = ((_50 * 0.00390625f) + -0.001953125f) + _556;
  float _565 = ((_74 * 0.00390625f) + -0.001953125f) + _555;
  float _566 = ((_75 * 0.00390625f) + -0.001953125f) + _554;
  [branch]
  if (!(cb0_107w == 0)) {
    float _578 = (pow(_564, 0.012683313339948654f));
    float _579 = (pow(_565, 0.012683313339948654f));
    float _580 = (pow(_566, 0.012683313339948654f));
    float _613 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_578 + -0.8359375f)) / (18.8515625f - (_578 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _614 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_579 + -0.8359375f)) / (18.8515625f - (_579 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _615 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_580 + -0.8359375f)) / (18.8515625f - (_580 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _641 = min((_613 * 12.920000076293945f), ((exp2(log2(max(_613, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _642 = min((_614 * 12.920000076293945f), ((exp2(log2(max(_614, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _643 = min((_615 * 12.920000076293945f), ((exp2(log2(max(_615, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _641 = _564;
    _642 = _565;
    _643 = _566;
  }
  SV_Target.x = _641;
  SV_Target.y = _642;
  SV_Target.z = _643;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = dot(float3(_556, _555, _554), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
