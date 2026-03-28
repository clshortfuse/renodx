#include "../../common.hlsl"

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
  float cb0_096x : packoffset(c096.x);
  float cb0_096y : packoffset(c096.y);
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

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _37 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _38 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _39 = TEXCOORD_2.w * 543.3099975585938f;
  float _43 = frac(sin(_39 + TEXCOORD_2.z) * 493013.0f);
  float _67;
  float _68;
  float _158;
  float _159;
  float _160;
  float _172;
  float _173;
  float _174;
  float _314;
  float _315;
  float _316;
  float _348;
  float _349;
  float _350;
  float _397;
  float _398;
  float _399;
  float _414;
  float _415;
  float _416;
  float _489;
  float _490;
  float _491;
  float _579;
  float _580;
  float _581;
  if (cb0_097x > 0.0f) {
    _67 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _39) * 493013.0f) + 7.177000045776367f) - _43)) + _43);
    _68 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _39) * 493013.0f) + 14.298999786376953f) - _43)) + _43);
  } else {
    _67 = _43;
    _68 = _43;
  }
  float _73 = cb0_096z * (1.0f - (_43 * _43));
  float _78 = (_73 * (TEXCOORD_2.x - _37)) + _37;
  float _79 = (_73 * (TEXCOORD_2.y - _38)) + _38;
  float4 _90 = t0.Sample(s0, float2(min(max(_78, cb0_053z), cb0_054x), min(max(_79, cb0_053w), cb0_054y)));
  float4 _118 = t1.Sample(s1, float2(min(max(((cb0_068z * _78) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _79) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_118);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _147 = (cb0_086x != 0);
    float4 _150 = t2.Sample(s2, float2(select(_147, _78, min(max(((cb0_076z * _78) + cb0_077x), cb0_075z), cb0_076x)), select(_147, _79, min(max(((cb0_076w * _79) + cb0_077y), cb0_075w), cb0_076y))));
    _158 = (_150.x + _118.x);
    _159 = (_150.y + _118.y);
    _160 = (_150.z + _118.z);
  } else {
    _158 = _118.x;
    _159 = _118.y;
    _160 = _118.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _164 = t3.Sample(s3, float2(_78, _79));
    _172 = (_164.x + _158);
    _173 = (_164.y + _159);
    _174 = (_164.z + _160);
  } else {
    _172 = _158;
    _173 = _159;
    _174 = _160;
  }
  float _199 = TEXCOORD_1.z + -1.0f;
  float _201 = TEXCOORD_1.w + -1.0f;
  float _204 = ((_199 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _206 = ((_201 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _213 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_204, _206), float2(_204, _206))) + 1.0f);
  float _214 = _213 * _213;
  float _215 = cb0_091z + 1.0f;
  float _243 = ((_199 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _245 = ((_201 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _252 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_243, _245), float2(_243, _245))) + 1.0f);
  float _253 = _252 * _252;
  float _254 = cb0_094z + 1.0f;
  float _275 = ((((_214 * (_215 - cb0_090x)) + cb0_090x) * (_172 + ((_90.x * TEXCOORD_1.x) * cb0_087x))) * ((_253 * (_254 - cb0_093x)) + cb0_093x)) * ((cb0_096x * _43) + cb0_096y);
  float _278 = ((((_214 * (_215 - cb0_090y)) + cb0_090y) * (_173 + ((_90.y * TEXCOORD_1.x) * cb0_087y))) * ((_253 * (_254 - cb0_093y)) + cb0_093y)) * ((cb0_096x * _67) + cb0_096y);
  float _281 = ((((_214 * (_215 - cb0_090z)) + cb0_090z) * (_174 + ((_90.z * TEXCOORD_1.x) * cb0_087z))) * ((_253 * (_254 - cb0_093z)) + cb0_093z)) * ((cb0_096x * _68) + cb0_096y);

  CAPTURE_UNTONEMAPPED(float3(_275, _278, _281));
  [branch]
  if (WUWA_TM_IS(1)) {
    _314 = ((((_275 * 1.3600000143051147f) + 0.04699999839067459f) * _275) / ((((_275 * 0.9599999785423279f) + 0.5600000023841858f) * _275) + 0.14000000059604645f));
    _315 = ((((_278 * 1.3600000143051147f) + 0.04699999839067459f) * _278) / ((((_278 * 0.9599999785423279f) + 0.5600000023841858f) * _278) + 0.14000000059604645f));
    _316 = ((((_281 * 1.3600000143051147f) + 0.04699999839067459f) * _281) / ((((_281 * 0.9599999785423279f) + 0.5600000023841858f) * _281) + 0.14000000059604645f));
  } else {
    _314 = _275;
    _315 = _278;
    _316 = _281;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _326 = 1.0049500465393066f - (0.16398000717163086f / (_314 + -0.19505000114440918f));
    float _327 = 1.0049500465393066f - (0.16398000717163086f / (_315 + -0.19505000114440918f));
    float _328 = 1.0049500465393066f - (0.16398000717163086f / (_316 + -0.19505000114440918f));
    _348 = (((_314 - _326) * select((_314 > 0.6000000238418579f), 0.0f, 1.0f)) + _326);
    _349 = (((_315 - _327) * select((_315 > 0.6000000238418579f), 0.0f, 1.0f)) + _327);
    _350 = (((_316 - _328) * select((_316 > 0.6000000238418579f), 0.0f, 1.0f)) + _328);
  } else {
    _348 = _314;
    _349 = _315;
    _350 = _316;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _356 = cb0_037y * _348;
    float _357 = cb0_037y * _349;
    float _358 = cb0_037y * _350;
    float _361 = cb0_037z * cb0_037w;
    float _371 = cb0_038y * cb0_038x;
    float _382 = cb0_038z * cb0_038x;
    float _389 = cb0_038y / cb0_038z;
    _397 = (((((_361 + _356) * _348) + _371) / (_382 + ((_356 + cb0_037z) * _348))) - _389);
    _398 = (((((_361 + _357) * _349) + _371) / (_382 + ((_357 + cb0_037z) * _349))) - _389);
    _399 = (((((_361 + _358) * _350) + _371) / (_382 + ((_358 + cb0_037z) * _350))) - _389);
  } else {
    _397 = _348;
    _398 = _349;
    _399 = _350;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _409 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _414 = (_409 * _397);
      _415 = (_409 * _398);
      _416 = (_409 * _399);
    } else {
      _414 = _397;
      _415 = _398;
      _416 = _399;
    }
  } else {
    _414 = _397;
    _415 = _398;
    _416 = _399;
  }
  CLAMP_IF_SDR3(_414, _415, _416);
  CAPTURE_TONEMAPPED(float3(_414, _415, _416));
  float _437 = (saturate((log2(_414 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _438 = (saturate((log2(_415 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _439 = (saturate((log2(_416 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _440 = t5.Sample(s5, float3(_437, _438, _439));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _464 = t4.Sample(s4, float2(min(max(((cb0_084z * _78) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _79) + cb0_085y), cb0_083w), cb0_084y)));
    float _474 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_464.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _475 = t6.Sample(s6, float3(_437, _438, _439));
    _489 = (lerp(_475.x, _440.x, _474));
    _490 = (lerp(_475.y, _440.y, _474));
    _491 = (lerp(_475.z, _440.z, _474));
  } else {
    _489 = _440.x;
    _490 = _440.y;
    _491 = _440.z;
  }
  HANDLE_LUT_OUTPUT3_FADE(_489, _490, _491, t5, s5);
  float _492 = _491 * 1.0499999523162842f;
  float _493 = _490 * 1.0499999523162842f;
  float _494 = _489 * 1.0499999523162842f;
  float _502 = ((_43 * 0.00390625f) + -0.001953125f) + _494;
  float _503 = ((_67 * 0.00390625f) + -0.001953125f) + _493;
  float _504 = ((_68 * 0.00390625f) + -0.001953125f) + _492;
  [branch]
  if (!(cb0_107w == 0)) {
    float _516 = (pow(_502, 0.012683313339948654f));
    float _517 = (pow(_503, 0.012683313339948654f));
    float _518 = (pow(_504, 0.012683313339948654f));
    float _551 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_516 + -0.8359375f)) / (18.8515625f - (_516 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _552 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_517 + -0.8359375f)) / (18.8515625f - (_517 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _553 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_518 + -0.8359375f)) / (18.8515625f - (_518 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _579 = min((_551 * 12.920000076293945f), ((exp2(log2(max(_551, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _580 = min((_552 * 12.920000076293945f), ((exp2(log2(max(_552, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _581 = min((_553 * 12.920000076293945f), ((exp2(log2(max(_553, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _579 = _502;
    _580 = _503;
    _581 = _504;
  }
  SV_Target.x = _579;
  SV_Target.y = _580;
  SV_Target.z = _581;
  SV_Target.w = dot(float3(_494, _493, _492), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
