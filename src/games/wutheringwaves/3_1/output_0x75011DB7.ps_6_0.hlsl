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
  float cb0_095x : packoffset(c095.x);
  float cb0_095y : packoffset(c095.y);
  float cb0_095z : packoffset(c095.z);
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
  float _35 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _36 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _38 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _41 = frac(sin(_38) * 493013.0f);
  float _63;
  float _64;
  float _150;
  float _151;
  float _245;
  float _246;
  float _310;
  float _311;
  float _312;
  float _444;
  float _445;
  float _446;
  float _479;
  float _480;
  float _481;
  float _513;
  float _514;
  float _515;
  float _562;
  float _563;
  float _564;
  float _579;
  float _580;
  float _581;
  float _668;
  float _669;
  float _670;
  float _755;
  float _756;
  float _757;
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
  float _90 = _74 - (((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x);
  float _91 = _75 - (((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y);
  float _101 = cb0_118z * cb0_117x;
  float _102 = cb0_118z * cb0_117y;
  bool _103 = (cb0_118x == 0.0f);
  float _113 = (cb0_114z * TEXCOORD_3.x) + cb0_114x;
  float _114 = (cb0_114w * TEXCOORD_3.y) + cb0_114y;
  float _133 = float(((int)(uint)((bool)(_113 > 0.0f))) - ((int)(uint)((bool)(_113 < 0.0f)))) * saturate(abs(_113) - cb0_117z);
  float _135 = float(((int)(uint)((bool)(_114 > 0.0f))) - ((int)(uint)((bool)(_114 < 0.0f)))) * saturate(abs(_114) - cb0_117z);
  float _140 = _114 - (_135 * _101);
  float _142 = _114 - (_135 * _102);
  bool _143 = (cb0_118x > 0.0f);
  if (_143) {
    _150 = (_140 - (cb0_118w * 0.4000000059604645f));
    _151 = (_142 - (cb0_118w * 0.20000000298023224f));
  } else {
    _150 = _140;
    _151 = _142;
  }
  float4 _187 = t0.Sample(s0, float2(min(max(_74, cb0_053z), cb0_054x), min(max(_75, cb0_053w), cb0_054y)));
  float4 _203 = t0.Sample(s0, float2(min(max(((((((cb0_115z * (_113 - (_133 * select(_103, _101, cb0_117x)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x) + _90), cb0_053z), cb0_054x), min(max(((((((cb0_115w * _150) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y) + _91), cb0_053w), cb0_054y)));
  float4 _217 = t0.Sample(s0, float2(min(max(((((((cb0_115z * (_113 - (_133 * select(_103, _102, cb0_117y)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x) + _90), cb0_053z), cb0_054x), min(max(((((((cb0_115w * _151) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y) + _91), cb0_053w), cb0_054y)));
  if (_143) {
    float _227 = saturate(((((_187.y * 0.5870000123977661f) - cb0_118y) + (_187.x * 0.29899999499320984f)) + (_187.z * 0.11400000005960464f)) * 10.0f);
    float _231 = (_227 * _227) * (3.0f - (_227 * 2.0f));
    _245 = ((((_187.x - _203.x) + (_231 * (_203.x - _187.x))) * cb0_118x) + _203.x);
    _246 = ((((_187.y - _217.y) + (_231 * (_217.y - _187.y))) * cb0_118x) + _217.y);
  } else {
    _245 = _203.x;
    _246 = _217.y;
  }

  float4 _271 = t1.Sample(s1, float2(min(max(((cb0_068z * _74) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _75) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_271);

  [branch]
  if (!((uint)(cb0_085z) == 0)) {
    bool _299 = ((uint)(cb0_085w) != 0);
    float4 _302 = t2.Sample(s2, float2(select(_299, _74, min(max(((cb0_076z * _74) + cb0_077x), cb0_075z), cb0_076x)), select(_299, _75, min(max(((cb0_076w * _75) + cb0_077y), cb0_075w), cb0_076y))));
    _310 = (_302.x + _271.x);
    _311 = (_302.y + _271.y);
    _312 = (_302.z + _271.z);
  } else {
    _310 = _271.x;
    _311 = _271.y;
    _312 = _271.z;
  }
  float _337 = TEXCOORD_1.z + -1.0f;
  float _339 = TEXCOORD_1.w + -1.0f;
  float _342 = (((cb0_090x * 2.0f) + _337) * cb0_088z) * cb0_088x;
  float _344 = (((cb0_090y * 2.0f) + _339) * cb0_088w) * cb0_088x;
  float _351 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_342, _344), float2(_342, _344))) + 1.0f);
  float _352 = _351 * _351;
  float _353 = cb0_090z + 1.0f;
  float _381 = (((cb0_093x * 2.0f) + _337) * cb0_091z) * cb0_091x;
  float _383 = (((cb0_093y * 2.0f) + _339) * cb0_091w) * cb0_091x;
  float _390 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_381, _383), float2(_381, _383))) + 1.0f);
  float _391 = _390 * _390;
  float _392 = cb0_093z + 1.0f;
  float _413 = ((((_352 * (_353 - cb0_089x)) + cb0_089x) * (_310 + ((_245 * TEXCOORD_1.x) * cb0_086x))) * ((_391 * (_392 - cb0_092x)) + cb0_092x)) * ((cb0_095x * _41) + cb0_095y);
  float _416 = ((((_352 * (_353 - cb0_089y)) + cb0_089y) * (_311 + ((_246 * TEXCOORD_1.x) * cb0_086y))) * ((_391 * (_392 - cb0_092y)) + cb0_092y)) * ((cb0_095x * _63) + cb0_095y);
  float _419 = ((((_352 * (_353 - cb0_089z)) + cb0_089z) * (_312 + ((_187.z * TEXCOORD_1.x) * cb0_086z))) * ((_391 * (_392 - cb0_092z)) + cb0_092z)) * ((cb0_095x * _64) + cb0_095y);

  CAPTURE_UNTONEMAPPED(float3(_413, _416, _419));

  [branch]
  if (false) {
    float _433 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _444 = (1.0f - exp2(_433 * _413));
    _445 = (1.0f - exp2(_433 * _416));
    _446 = (1.0f - exp2(_433 * _419));
  } else {
    _444 = _413;
    _445 = _416;
    _446 = _419;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _479 = ((((_444 * 1.3600000143051147f) + 0.04699999839067459f) * _444) / ((((_444 * 0.9599999785423279f) + 0.5600000023841858f) * _444) + 0.14000000059604645f));
    _480 = ((((_445 * 1.3600000143051147f) + 0.04699999839067459f) * _445) / ((((_445 * 0.9599999785423279f) + 0.5600000023841858f) * _445) + 0.14000000059604645f));
    _481 = ((((_446 * 1.3600000143051147f) + 0.04699999839067459f) * _446) / ((((_446 * 0.9599999785423279f) + 0.5600000023841858f) * _446) + 0.14000000059604645f));
  } else {
    _479 = _444;
    _480 = _445;
    _481 = _446;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _491 = 1.0049500465393066f - (0.16398000717163086f / (_479 + -0.19505000114440918f));
    float _492 = 1.0049500465393066f - (0.16398000717163086f / (_480 + -0.19505000114440918f));
    float _493 = 1.0049500465393066f - (0.16398000717163086f / (_481 + -0.19505000114440918f));
    _513 = (((_479 - _491) * select((_479 > 0.6000000238418579f), 0.0f, 1.0f)) + _491);
    _514 = (((_480 - _492) * select((_480 > 0.6000000238418579f), 0.0f, 1.0f)) + _492);
    _515 = (((_481 - _493) * select((_481 > 0.6000000238418579f), 0.0f, 1.0f)) + _493);
  } else {
    _513 = _479;
    _514 = _480;
    _515 = _481;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _521 = cb0_037y * _513;
    float _522 = cb0_037y * _514;
    float _523 = cb0_037y * _515;
    float _526 = cb0_037z * cb0_037w;
    float _536 = cb0_038y * cb0_038x;
    float _547 = cb0_038z * cb0_038x;
    float _554 = cb0_038y / cb0_038z;
    _562 = (((((_526 + _521) * _513) + _536) / (((_521 + cb0_037z) * _513) + _547)) - _554);
    _563 = (((((_526 + _522) * _514) + _536) / (((_522 + cb0_037z) * _514) + _547)) - _554);
    _564 = (((((_526 + _523) * _515) + _536) / (((_523 + cb0_037z) * _515) + _547)) - _554);
  } else {
    _562 = _513;
    _563 = _514;
    _564 = _515;
  }
  [branch]
  if (!((uint)(cb0_105w) == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _574 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _579 = (_574 * _562);
      _580 = (_574 * _563);
      _581 = (_574 * _564);
    } else {
      _579 = _562;
      _580 = _563;
      _581 = _564;
    }
  } else {
    _579 = _562;
    _580 = _563;
    _581 = _564;
  }

  CLAMP_IF_SDR3(_579, _580, _581);
  CAPTURE_TONEMAPPED(float3(_579, _580, _581));

  float _596 = (saturate((log2(_581 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _600 = (saturate((log2(_580 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _604 = (saturate((log2(_579 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!((uint)(cb0_107w) == 0)) {
    float4 _625 = t3.Sample(s3, float2(min(max(((cb0_084z * _74) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _75) + cb0_085y), cb0_083w), cb0_084y)));
    float _635 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_625.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _636 = t5.Sample(s5, float3(_604, _600, _596));
    float4 _643 = t4.Sample(s4, float3(_604, _600, _596));
    _668 = ((((_643.x - _636.x) * 1.0499999523162842f) * _635) + (_636.x * 1.0499999523162842f));
    _669 = ((((_643.y - _636.y) * 1.0499999523162842f) * _635) + (_636.y * 1.0499999523162842f));
    _670 = ((((_643.z - _636.z) * 1.0499999523162842f) * _635) + (_636.z * 1.0499999523162842f));
  } else {
    float4 _660 = t4.Sample(s4, float3(_604, _600, _596));
    _668 = (_660.x * 1.0499999523162842f);
    _669 = (_660.y * 1.0499999523162842f);
    _670 = (_660.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3(_668, _669, _670);

  float _678 = ((_41 * 0.00390625f) + -0.001953125f) + _668;
  float _679 = ((_63 * 0.00390625f) + -0.001953125f) + _669;
  float _680 = ((_64 * 0.00390625f) + -0.001953125f) + _670;
  [branch]
  if (!((uint)(cb0_106w) == 0)) {
    float _692 = (pow(_678, 0.012683313339948654f));
    float _693 = (pow(_679, 0.012683313339948654f));
    float _694 = (pow(_680, 0.012683313339948654f));
    float _727 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_692 + -0.8359375f)) / (18.8515625f - (_692 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _728 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_693 + -0.8359375f)) / (18.8515625f - (_693 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _729 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_694 + -0.8359375f)) / (18.8515625f - (_694 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _755 = min((_727 * 12.920000076293945f), ((exp2(log2(max(_727, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _756 = min((_728 * 12.920000076293945f), ((exp2(log2(max(_728, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _757 = min((_729 * 12.920000076293945f), ((exp2(log2(max(_729, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _755 = _678;
    _756 = _679;
    _757 = _680;
  }
  SV_Target.x = _755;
  SV_Target.y = _756;
  SV_Target.z = _757;

  SV_Target.w = (dot(float3(_668, _669, _670), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
