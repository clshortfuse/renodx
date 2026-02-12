#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture3D<float4> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

Texture3D<float4> t7 : register(t7);

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
  float cb0_096x : packoffset(c096.x);
  int cb0_105w : packoffset(c105.w);
  float cb0_106x : packoffset(c106.x);
  float cb0_106z : packoffset(c106.z);
  int cb0_106w : packoffset(c106.w);
  int cb0_107x : packoffset(c107.x);
  int cb0_107y : packoffset(c107.y);
  int cb0_107z : packoffset(c107.z);
  int cb0_107w : packoffset(c107.w);
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

SamplerState s6 : register(s6);

SamplerState s7 : register(s7);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _40 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _41 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _43 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _46 = frac(sin(_43) * 493013.0f);
  float _68;
  float _69;
  float _132;
  float _203;
  float _204;
  float _205;
  float _326;
  float _327;
  float _328;
  float _361;
  float _362;
  float _363;
  float _395;
  float _396;
  float _397;
  float _444;
  float _445;
  float _446;
  float _461;
  float _462;
  float _463;
  float _550;
  float _551;
  float _552;
  float _637;
  float _638;
  float _639;
  if (cb0_096x > 0.0f) {
    _68 = (((frac((sin(_43 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _46) * cb0_096x) + _46);
    _69 = (((frac((sin(_43 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _46) * cb0_096x) + _46);
  } else {
    _68 = _46;
    _69 = _46;
  }
  float4 _70 = t0.Sample(s0, float2(_40, _41));
  float _82 = log2(max(dot(float3(_70.x, _70.y, _70.z), float3(cb0_043x, cb0_043y, cb0_043z)), cb0_042x));
  float4 _100 = t4.Sample(s4, float3((cb0_046z * TEXCOORD_4.x), (cb0_046w * TEXCOORD_4.y), ((((cb0_041z * _82) + cb0_041w) * 0.96875f) + 0.015625f)));
  float4 _104 = t5.Sample(s5, float2(TEXCOORD_4.x, TEXCOORD_4.y));
  float _107 = select((_100.y < 0.0010000000474974513f), _104.x, (_100.x / _100.y));
  float _110 = log2(TEXCOORD_1.x);
  float _112 = (_107 + _110) + ((_104.x - _107) * cb0_046x);
  float _117 = _110 + _82;
  float _119 = _112 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_046y);
  bool _120 = (_119 > 0.0f);
  if (_120) {
    _132 = max(0.0f, (_119 - cb0_047x));
  } else {
    _132 = min(0.0f, (_119 + cb0_047y));
  }
  float4 _164 = t1.Sample(s1, float2(min(max(((cb0_068z * _40) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _41) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_164);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _192 = (cb0_085w != 0);
    float4 _195 = t2.Sample(s2, float2(select(_192, _40, min(max(((cb0_076z * _40) + cb0_077x), cb0_075z), cb0_076x)), select(_192, _41, min(max(((cb0_076w * _41) + cb0_077y), cb0_075w), cb0_076y))));
    _203 = (_195.x + _164.x);
    _204 = (_195.y + _164.y);
    _205 = (_195.z + _164.z);
  } else {
    _203 = _164.x;
    _204 = _164.y;
    _205 = _164.z;
  }
  float _206 = exp2((((_112 - _117) + ((_117 - _112) * cb0_045w)) - _132) + (_132 * select(_120, cb0_045y, cb0_045z))) * TEXCOORD_1.x;
  float _231 = TEXCOORD_1.z + -1.0f;
  float _233 = TEXCOORD_1.w + -1.0f;
  float _236 = (((cb0_090x * 2.0f) + _231) * cb0_088z) * cb0_088x;
  float _238 = (((cb0_090y * 2.0f) + _233) * cb0_088w) * cb0_088x;
  float _245 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_236, _238), float2(_236, _238))) + 1.0f);
  float _246 = _245 * _245;
  float _247 = cb0_090z + 1.0f;
  float _275 = (((cb0_093x * 2.0f) + _231) * cb0_091z) * cb0_091x;
  float _277 = (((cb0_093y * 2.0f) + _233) * cb0_091w) * cb0_091x;
  float _284 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_275, _277), float2(_275, _277))) + 1.0f);
  float _285 = _284 * _284;
  float _286 = cb0_093z + 1.0f;
  float _297 = (((_246 * (_247 - cb0_089x)) + cb0_089x) * (_203 + ((_206 * _70.x) * cb0_086x))) * ((_285 * (_286 - cb0_092x)) + cb0_092x);
  float _299 = (((_246 * (_247 - cb0_089y)) + cb0_089y) * (_204 + ((_206 * _70.y) * cb0_086y))) * ((_285 * (_286 - cb0_092y)) + cb0_092y);
  float _301 = (((_246 * (_247 - cb0_089z)) + cb0_089z) * (_205 + ((_206 * _70.z) * cb0_086z))) * ((_285 * (_286 - cb0_092z)) + cb0_092z);

  CAPTURE_UNTONEMAPPED(float3(_297, _299, _301));
  [branch]
  if (!(cb0_111w == 0)) {
    float _315 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _326 = (1.0f - exp2(_315 * _297));
    _327 = (1.0f - exp2(_315 * _299));
    _328 = (1.0f - exp2(_315 * _301));
  } else {
    _326 = _297;
    _327 = _299;
    _328 = _301;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _361 = ((((_326 * 1.3600000143051147f) + 0.04699999839067459f) * _326) / ((((_326 * 0.9599999785423279f) + 0.5600000023841858f) * _326) + 0.14000000059604645f));
    _362 = ((((_327 * 1.3600000143051147f) + 0.04699999839067459f) * _327) / ((((_327 * 0.9599999785423279f) + 0.5600000023841858f) * _327) + 0.14000000059604645f));
    _363 = ((((_328 * 1.3600000143051147f) + 0.04699999839067459f) * _328) / ((((_328 * 0.9599999785423279f) + 0.5600000023841858f) * _328) + 0.14000000059604645f));
  } else {
    _361 = _326;
    _362 = _327;
    _363 = _328;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _373 = 1.0049500465393066f - (0.16398000717163086f / (_361 + -0.19505000114440918f));
    float _374 = 1.0049500465393066f - (0.16398000717163086f / (_362 + -0.19505000114440918f));
    float _375 = 1.0049500465393066f - (0.16398000717163086f / (_363 + -0.19505000114440918f));
    _395 = (((_361 - _373) * select((_361 > 0.6000000238418579f), 0.0f, 1.0f)) + _373);
    _396 = (((_362 - _374) * select((_362 > 0.6000000238418579f), 0.0f, 1.0f)) + _374);
    _397 = (((_363 - _375) * select((_363 > 0.6000000238418579f), 0.0f, 1.0f)) + _375);
  } else {
    _395 = _361;
    _396 = _362;
    _397 = _363;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _403 = cb0_037y * _395;
    float _404 = cb0_037y * _396;
    float _405 = cb0_037y * _397;
    float _408 = cb0_037z * cb0_037w;
    float _418 = cb0_038y * cb0_038x;
    float _429 = cb0_038z * cb0_038x;
    float _436 = cb0_038y / cb0_038z;
    _444 = (((((_408 + _403) * _395) + _418) / (((_403 + cb0_037z) * _395) + _429)) - _436);
    _445 = (((((_408 + _404) * _396) + _418) / (((_404 + cb0_037z) * _396) + _429)) - _436);
    _446 = (((((_408 + _405) * _397) + _418) / (((_405 + cb0_037z) * _397) + _429)) - _436);
  } else {
    _444 = _395;
    _445 = _396;
    _446 = _397;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _456 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _461 = (_456 * _444);
      _462 = (_456 * _445);
      _463 = (_456 * _446);
    } else {
      _461 = _444;
      _462 = _445;
      _463 = _446;
    }
  } else {
    _461 = _444;
    _462 = _445;
    _463 = _446;
  }
  CLAMP_IF_SDR3(_461, _462, _463);
  CAPTURE_TONEMAPPED(float3(_461, _462, _463));
  float _478 = (saturate((log2(_463 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _482 = (saturate((log2(_462 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _486 = (saturate((log2(_461 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!(cb0_107w == 0)) {
    float4 _507 = t3.Sample(s3, float2(min(max(((cb0_084z * _40) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _41) + cb0_085y), cb0_083w), cb0_084y)));
    float _517 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_507.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _518 = t7.Sample(s7, float3(_486, _482, _478));
    float4 _525 = t6.Sample(s6, float3(_486, _482, _478));
    _550 = ((((_525.x - _518.x) * 1.0499999523162842f) * _517) + (_518.x * 1.0499999523162842f));
    _551 = ((((_525.y - _518.y) * 1.0499999523162842f) * _517) + (_518.y * 1.0499999523162842f));
    _552 = ((((_525.z - _518.z) * 1.0499999523162842f) * _517) + (_518.z * 1.0499999523162842f));
  } else {
    float4 _542 = t6.Sample(s6, float3(_486, _482, _478));
    _550 = (_542.x * 1.0499999523162842f);
    _551 = (_542.y * 1.0499999523162842f);
    _552 = (_542.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3_FADE(_550, _551, _552, t6, s6);
  float _560 = ((_46 * 0.00390625f) + -0.001953125f) + _550;
  float _561 = ((_68 * 0.00390625f) + -0.001953125f) + _551;
  float _562 = ((_69 * 0.00390625f) + -0.001953125f) + _552;
  [branch]
  if (!(cb0_106w == 0)) {
    float _574 = (pow(_560, 0.012683313339948654f));
    float _575 = (pow(_561, 0.012683313339948654f));
    float _576 = (pow(_562, 0.012683313339948654f));
    float _609 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_574 + -0.8359375f)) / (18.8515625f - (_574 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _610 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_575 + -0.8359375f)) / (18.8515625f - (_575 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _611 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_576 + -0.8359375f)) / (18.8515625f - (_576 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _637 = min((_609 * 12.920000076293945f), ((exp2(log2(max(_609, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _638 = min((_610 * 12.920000076293945f), ((exp2(log2(max(_610, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _639 = min((_611 * 12.920000076293945f), ((exp2(log2(max(_611, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _637 = _560;
    _638 = _561;
    _639 = _562;
  }
  SV_Target.x = _637;
  SV_Target.y = _638;
  SV_Target.z = _639;
  SV_Target.w = (dot(float3(_550, _551, _552), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
