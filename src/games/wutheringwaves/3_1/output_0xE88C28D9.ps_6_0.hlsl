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
  float cb0_114x : packoffset(c114.x);
  float cb0_114y : packoffset(c114.y);
  float cb0_114z : packoffset(c114.z);
  float cb0_114w : packoffset(c114.w);
  float cb0_115x : packoffset(c115.x);
  float cb0_115y : packoffset(c115.y);
  float cb0_115z : packoffset(c115.z);
  float cb0_115w : packoffset(c115.w);
  float cb0_117x : packoffset(c117.x);
  float cb0_117y : packoffset(c117.y);
  float cb0_117z : packoffset(c117.z);
  float cb0_118x : packoffset(c118.x);
  float cb0_118y : packoffset(c118.y);
  float cb0_118z : packoffset(c118.z);
  float cb0_118w : packoffset(c118.w);
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
  float _121;
  float _122;
  float _190;
  float _191;
  float _255;
  float _256;
  float _257;
  float _377;
  float _378;
  float _379;
  float _412;
  float _413;
  float _414;
  float _446;
  float _447;
  float _448;
  float _495;
  float _496;
  float _497;
  float _512;
  float _513;
  float _514;
  float _601;
  float _602;
  float _603;
  float _688;
  float _689;
  float _690;
  if (cb0_096x > 0.0f) {
    _61 = (((frac((sin(_36 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _39) * cb0_096x) + _39);
    _62 = (((frac((sin(_36 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _39) * cb0_096x) + _39);
  } else {
    _61 = _39;
    _62 = _39;
  }
  float _72 = cb0_118z * cb0_117x;
  float _73 = cb0_118z * cb0_117y;
  bool _74 = (cb0_118x == 0.0f);
  float _84 = (cb0_114z * TEXCOORD_3.x) + cb0_114x;
  float _85 = (cb0_114w * TEXCOORD_3.y) + cb0_114y;
  float _104 = float(((int)(uint)((bool)(_84 > 0.0f))) - ((int)(uint)((bool)(_84 < 0.0f)))) * saturate(abs(_84) - cb0_117z);
  float _106 = float(((int)(uint)((bool)(_85 > 0.0f))) - ((int)(uint)((bool)(_85 < 0.0f)))) * saturate(abs(_85) - cb0_117z);
  float _111 = _85 - (_106 * _72);
  float _113 = _85 - (_106 * _73);
  bool _114 = (cb0_118x > 0.0f);
  if (_114) {
    _121 = (_111 - (cb0_118w * 0.4000000059604645f));
    _122 = (_113 - (cb0_118w * 0.20000000298023224f));
  } else {
    _121 = _111;
    _122 = _113;
  }
  float4 _156 = t0.Sample(s0, float2(_33, _34));
  float4 _160 = t0.Sample(s0, float2((((((cb0_115z * (_84 - (_104 * select(_74, _72, cb0_117x)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x), (((((cb0_115w * _121) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y)));
  float4 _162 = t0.Sample(s0, float2((((((cb0_115z * (_84 - (_104 * select(_74, _73, cb0_117y)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x), (((((cb0_115w * _122) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y)));
  if (_114) {
    float _172 = saturate(((((_156.y * 0.5870000123977661f) - cb0_118y) + (_156.x * 0.29899999499320984f)) + (_156.z * 0.11400000005960464f)) * 10.0f);
    float _176 = (_172 * _172) * (3.0f - (_172 * 2.0f));
    _190 = ((((_156.x - _160.x) + (_176 * (_160.x - _156.x))) * cb0_118x) + _160.x);
    _191 = ((((_156.y - _162.y) + (_176 * (_162.y - _156.y))) * cb0_118x) + _162.y);
  } else {
    _190 = _160.x;
    _191 = _162.y;
  }

  float4 _216 = t1.Sample(s1, float2(min(max(((cb0_068z * _33) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _34) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_216);

  [branch]
  if (!((uint)(cb0_085z) == 0)) {
    bool _244 = ((uint)(cb0_085w) != 0);
    float4 _247 = t2.Sample(s2, float2(select(_244, _33, min(max(((cb0_076z * _33) + cb0_077x), cb0_075z), cb0_076x)), select(_244, _34, min(max(((cb0_076w * _34) + cb0_077y), cb0_075w), cb0_076y))));
    _255 = (_247.x + _216.x);
    _256 = (_247.y + _216.y);
    _257 = (_247.z + _216.z);
  } else {
    _255 = _216.x;
    _256 = _216.y;
    _257 = _216.z;
  }
  float _282 = TEXCOORD_1.z + -1.0f;
  float _284 = TEXCOORD_1.w + -1.0f;
  float _287 = (((cb0_090x * 2.0f) + _282) * cb0_088z) * cb0_088x;
  float _289 = (((cb0_090y * 2.0f) + _284) * cb0_088w) * cb0_088x;
  float _296 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_287, _289), float2(_287, _289))) + 1.0f);
  float _297 = _296 * _296;
  float _298 = cb0_090z + 1.0f;
  float _326 = (((cb0_093x * 2.0f) + _282) * cb0_091z) * cb0_091x;
  float _328 = (((cb0_093y * 2.0f) + _284) * cb0_091w) * cb0_091x;
  float _335 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_326, _328), float2(_326, _328))) + 1.0f);
  float _336 = _335 * _335;
  float _337 = cb0_093z + 1.0f;
  float _348 = (((_297 * (_298 - cb0_089x)) + cb0_089x) * (_255 + ((_190 * TEXCOORD_1.x) * cb0_086x))) * ((_336 * (_337 - cb0_092x)) + cb0_092x);
  float _350 = (((_297 * (_298 - cb0_089y)) + cb0_089y) * (_256 + ((_191 * TEXCOORD_1.x) * cb0_086y))) * ((_336 * (_337 - cb0_092y)) + cb0_092y);
  float _352 = (((_297 * (_298 - cb0_089z)) + cb0_089z) * (_257 + ((_156.z * TEXCOORD_1.x) * cb0_086z))) * ((_336 * (_337 - cb0_092z)) + cb0_092z);

  CAPTURE_UNTONEMAPPED(float3(_348, _350, _352));

  [branch]
  if (false) {
    float _366 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _377 = (1.0f - exp2(_366 * _348));
    _378 = (1.0f - exp2(_366 * _350));
    _379 = (1.0f - exp2(_366 * _352));
  } else {
    _377 = _348;
    _378 = _350;
    _379 = _352;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _412 = ((((_377 * 1.3600000143051147f) + 0.04699999839067459f) * _377) / ((((_377 * 0.9599999785423279f) + 0.5600000023841858f) * _377) + 0.14000000059604645f));
    _413 = ((((_378 * 1.3600000143051147f) + 0.04699999839067459f) * _378) / ((((_378 * 0.9599999785423279f) + 0.5600000023841858f) * _378) + 0.14000000059604645f));
    _414 = ((((_379 * 1.3600000143051147f) + 0.04699999839067459f) * _379) / ((((_379 * 0.9599999785423279f) + 0.5600000023841858f) * _379) + 0.14000000059604645f));
  } else {
    _412 = _377;
    _413 = _378;
    _414 = _379;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _424 = 1.0049500465393066f - (0.16398000717163086f / (_412 + -0.19505000114440918f));
    float _425 = 1.0049500465393066f - (0.16398000717163086f / (_413 + -0.19505000114440918f));
    float _426 = 1.0049500465393066f - (0.16398000717163086f / (_414 + -0.19505000114440918f));
    _446 = (((_412 - _424) * select((_412 > 0.6000000238418579f), 0.0f, 1.0f)) + _424);
    _447 = (((_413 - _425) * select((_413 > 0.6000000238418579f), 0.0f, 1.0f)) + _425);
    _448 = (((_414 - _426) * select((_414 > 0.6000000238418579f), 0.0f, 1.0f)) + _426);
  } else {
    _446 = _412;
    _447 = _413;
    _448 = _414;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _454 = cb0_037y * _446;
    float _455 = cb0_037y * _447;
    float _456 = cb0_037y * _448;
    float _459 = cb0_037z * cb0_037w;
    float _469 = cb0_038y * cb0_038x;
    float _480 = cb0_038z * cb0_038x;
    float _487 = cb0_038y / cb0_038z;
    _495 = (((((_459 + _454) * _446) + _469) / (((_454 + cb0_037z) * _446) + _480)) - _487);
    _496 = (((((_459 + _455) * _447) + _469) / (((_455 + cb0_037z) * _447) + _480)) - _487);
    _497 = (((((_459 + _456) * _448) + _469) / (((_456 + cb0_037z) * _448) + _480)) - _487);
  } else {
    _495 = _446;
    _496 = _447;
    _497 = _448;
  }
  [branch]
  if (!((uint)(cb0_105w) == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _507 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _512 = (_507 * _495);
      _513 = (_507 * _496);
      _514 = (_507 * _497);
    } else {
      _512 = _495;
      _513 = _496;
      _514 = _497;
    }
  } else {
    _512 = _495;
    _513 = _496;
    _514 = _497;
  }

  CLAMP_IF_SDR3(_512, _513, _514);
  CAPTURE_TONEMAPPED(float3(_512, _513, _514));

  float _529 = (saturate((log2(_514 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _533 = (saturate((log2(_513 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _537 = (saturate((log2(_512 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!((uint)(cb0_107w) == 0)) {
    float4 _558 = t3.Sample(s3, float2(min(max(((cb0_084z * _33) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _34) + cb0_085y), cb0_083w), cb0_084y)));
    float _568 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_558.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _569 = t5.Sample(s5, float3(_537, _533, _529));
    float4 _576 = t4.Sample(s4, float3(_537, _533, _529));
    _601 = ((((_576.x - _569.x) * 1.0499999523162842f) * _568) + (_569.x * 1.0499999523162842f));
    _602 = ((((_576.y - _569.y) * 1.0499999523162842f) * _568) + (_569.y * 1.0499999523162842f));
    _603 = ((((_576.z - _569.z) * 1.0499999523162842f) * _568) + (_569.z * 1.0499999523162842f));
  } else {
    float4 _593 = t4.Sample(s4, float3(_537, _533, _529));
    _601 = (_593.x * 1.0499999523162842f);
    _602 = (_593.y * 1.0499999523162842f);
    _603 = (_593.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3_FADE(_601, _602, _603, t4, s4);

  float _611 = ((_39 * 0.00390625f) + -0.001953125f) + _601;
  float _612 = ((_61 * 0.00390625f) + -0.001953125f) + _602;
  float _613 = ((_62 * 0.00390625f) + -0.001953125f) + _603;
  [branch]
  if (!((uint)(cb0_106w) == 0)) {
    float _625 = (pow(_611, 0.012683313339948654f));
    float _626 = (pow(_612, 0.012683313339948654f));
    float _627 = (pow(_613, 0.012683313339948654f));
    float _660 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_625 + -0.8359375f)) / (18.8515625f - (_625 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _661 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_626 + -0.8359375f)) / (18.8515625f - (_626 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _662 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_627 + -0.8359375f)) / (18.8515625f - (_627 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _688 = min((_660 * 12.920000076293945f), ((exp2(log2(max(_660, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _689 = min((_661 * 12.920000076293945f), ((exp2(log2(max(_661, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _690 = min((_662 * 12.920000076293945f), ((exp2(log2(max(_662, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _688 = _611;
    _689 = _612;
    _690 = _613;
  }
  SV_Target.x = _688;
  SV_Target.y = _689;
  SV_Target.z = _690;

  SV_Target.w = (dot(float3(_601, _602, _603), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
