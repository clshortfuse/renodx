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
  float _128;
  float _129;
  float _197;
  float _198;
  float _257;
  float _328;
  float _329;
  float _330;
  float _451;
  float _452;
  float _453;
  float _486;
  float _487;
  float _488;
  float _520;
  float _521;
  float _522;
  float _569;
  float _570;
  float _571;
  float _586;
  float _587;
  float _588;
  float _675;
  float _676;
  float _677;
  float _762;
  float _763;
  float _764;
  if (cb0_096x > 0.0f) {
    _68 = (((frac((sin(_43 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _46) * cb0_096x) + _46);
    _69 = (((frac((sin(_43 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _46) * cb0_096x) + _46);
  } else {
    _68 = _46;
    _69 = _46;
  }
  float _79 = cb0_118z * cb0_117x;
  float _80 = cb0_118z * cb0_117y;
  bool _81 = (cb0_118x == 0.0f);
  float _91 = (cb0_114z * TEXCOORD_3.x) + cb0_114x;
  float _92 = (cb0_114w * TEXCOORD_3.y) + cb0_114y;
  float _111 = float((int)(((int)(uint)((bool)(_91 > 0.0f))) - ((int)(uint)((bool)(_91 < 0.0f))))) * saturate(abs(_91) - cb0_117z);
  float _113 = float((int)(((int)(uint)((bool)(_92 > 0.0f))) - ((int)(uint)((bool)(_92 < 0.0f))))) * saturate(abs(_92) - cb0_117z);
  float _118 = _92 - (_113 * _79);
  float _120 = _92 - (_113 * _80);
  bool _121 = (cb0_118x > 0.0f);
  if (_121) {
    _128 = (_118 - (cb0_118w * 0.4000000059604645f));
    _129 = (_120 - (cb0_118w * 0.20000000298023224f));
  } else {
    _128 = _118;
    _129 = _120;
  }
  float4 _163 = t0.Sample(s0, float2(_40, _41));
  float4 _167 = t0.Sample(s0, float2((((((cb0_115z * (_91 - (_111 * select(_81, _79, cb0_117x)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x), (((((cb0_115w * _128) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y)));
  float4 _169 = t0.Sample(s0, float2((((((cb0_115z * (_91 - (_111 * select(_81, _80, cb0_117y)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x), (((((cb0_115w * _129) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y)));
  if (_121) {
    float _179 = saturate(((((_163.y * 0.5870000123977661f) - cb0_118y) + (_163.x * 0.29899999499320984f)) + (_163.z * 0.11400000005960464f)) * 10.0f);
    float _183 = (_179 * _179) * (3.0f - (_179 * 2.0f));
    _197 = ((((_163.x - _167.x) + (_183 * (_167.x - _163.x))) * cb0_118x) + _167.x);
    _198 = ((((_163.y - _169.y) + (_183 * (_169.y - _163.y))) * cb0_118x) + _169.y);
  } else {
    _197 = _167.x;
    _198 = _169.y;
  }
  float _207 = log2(max(dot(float3(_197, _198, _163.z), float3(cb0_043x, cb0_043y, cb0_043z)), cb0_042x));
  float4 _225 = t4.Sample(s4, float3((cb0_046z * TEXCOORD_4.x), (cb0_046w * TEXCOORD_4.y), ((((cb0_041z * _207) + cb0_041w) * 0.96875f) + 0.015625f)));
  float4 _229 = t5.Sample(s5, float2(TEXCOORD_4.x, TEXCOORD_4.y));
  float _232 = select((_225.y < 0.0010000000474974513f), _229.x, (_225.x / _225.y));
  float _235 = log2(TEXCOORD_1.x);
  float _237 = (_232 + _235) + ((_229.x - _232) * cb0_046x);
  float _242 = _235 + _207;
  float _244 = _237 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_046y);
  bool _245 = (_244 > 0.0f);
  if (_245) {
    _257 = max(0.0f, (_244 - cb0_047x));
  } else {
    _257 = min(0.0f, (_244 + cb0_047y));
  }
  float4 _289 = t1.Sample(s1, float2(min(max(((cb0_068z * _40) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _41) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_289);

  [branch]
  if (!(cb0_085z == 0)) {
    bool _317 = (cb0_085w != 0);
    float4 _320 = t2.Sample(s2, float2(select(_317, _40, min(max(((cb0_076z * _40) + cb0_077x), cb0_075z), cb0_076x)), select(_317, _41, min(max(((cb0_076w * _41) + cb0_077y), cb0_075w), cb0_076y))));
    _328 = (_320.x + _289.x);
    _329 = (_320.y + _289.y);
    _330 = (_320.z + _289.z);
  } else {
    _328 = _289.x;
    _329 = _289.y;
    _330 = _289.z;
  }
  float _331 = exp2((((_237 - _242) + ((_242 - _237) * cb0_045w)) - _257) + (_257 * select(_245, cb0_045y, cb0_045z))) * TEXCOORD_1.x;
  float _356 = TEXCOORD_1.z + -1.0f;
  float _358 = TEXCOORD_1.w + -1.0f;
  float _361 = (((cb0_090x * 2.0f) + _356) * cb0_088z) * cb0_088x;
  float _363 = (((cb0_090y * 2.0f) + _358) * cb0_088w) * cb0_088x;
  float _370 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_361, _363), float2(_361, _363))) + 1.0f);
  float _371 = _370 * _370;
  float _372 = cb0_090z + 1.0f;
  float _400 = (((cb0_093x * 2.0f) + _356) * cb0_091z) * cb0_091x;
  float _402 = (((cb0_093y * 2.0f) + _358) * cb0_091w) * cb0_091x;
  float _409 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_400, _402), float2(_400, _402))) + 1.0f);
  float _410 = _409 * _409;
  float _411 = cb0_093z + 1.0f;
  float _422 = (((_371 * (_372 - cb0_089x)) + cb0_089x) * (_328 + ((_331 * _197) * cb0_086x))) * ((_410 * (_411 - cb0_092x)) + cb0_092x);
  float _424 = (((_371 * (_372 - cb0_089y)) + cb0_089y) * (_329 + ((_331 * _198) * cb0_086y))) * ((_410 * (_411 - cb0_092y)) + cb0_092y);
  float _426 = (((_371 * (_372 - cb0_089z)) + cb0_089z) * (_330 + ((_331 * _163.z) * cb0_086z))) * ((_410 * (_411 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_422, _424, _426));

  [branch]
  if (false) {
    float _440 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _451 = (1.0f - exp2(_440 * _422));
    _452 = (1.0f - exp2(_440 * _424));
    _453 = (1.0f - exp2(_440 * _426));
  } else {
    _451 = _422;
    _452 = _424;
    _453 = _426;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _486 = ((((_451 * 1.3600000143051147f) + 0.04699999839067459f) * _451) / ((((_451 * 0.9599999785423279f) + 0.5600000023841858f) * _451) + 0.14000000059604645f));
    _487 = ((((_452 * 1.3600000143051147f) + 0.04699999839067459f) * _452) / ((((_452 * 0.9599999785423279f) + 0.5600000023841858f) * _452) + 0.14000000059604645f));
    _488 = ((((_453 * 1.3600000143051147f) + 0.04699999839067459f) * _453) / ((((_453 * 0.9599999785423279f) + 0.5600000023841858f) * _453) + 0.14000000059604645f));
  } else {
    _486 = _451;
    _487 = _452;
    _488 = _453;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _498 = 1.0049500465393066f - (0.16398000717163086f / (_486 + -0.19505000114440918f));
    float _499 = 1.0049500465393066f - (0.16398000717163086f / (_487 + -0.19505000114440918f));
    float _500 = 1.0049500465393066f - (0.16398000717163086f / (_488 + -0.19505000114440918f));
    _520 = (((_486 - _498) * select((_486 > 0.6000000238418579f), 0.0f, 1.0f)) + _498);
    _521 = (((_487 - _499) * select((_487 > 0.6000000238418579f), 0.0f, 1.0f)) + _499);
    _522 = (((_488 - _500) * select((_488 > 0.6000000238418579f), 0.0f, 1.0f)) + _500);
  } else {
    _520 = _486;
    _521 = _487;
    _522 = _488;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _528 = cb0_037y * _520;
    float _529 = cb0_037y * _521;
    float _530 = cb0_037y * _522;
    float _533 = cb0_037z * cb0_037w;
    float _543 = cb0_038y * cb0_038x;
    float _554 = cb0_038z * cb0_038x;
    float _561 = cb0_038y / cb0_038z;
    _569 = (((((_533 + _528) * _520) + _543) / (((_528 + cb0_037z) * _520) + _554)) - _561);
    _570 = (((((_533 + _529) * _521) + _543) / (((_529 + cb0_037z) * _521) + _554)) - _561);
    _571 = (((((_533 + _530) * _522) + _543) / (((_530 + cb0_037z) * _522) + _554)) - _561);
  } else {
    _569 = _520;
    _570 = _521;
    _571 = _522;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _581 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _586 = (_581 * _569);
      _587 = (_581 * _570);
      _588 = (_581 * _571);
    } else {
      _586 = _569;
      _587 = _570;
      _588 = _571;
    }
  } else {
    _586 = _569;
    _587 = _570;
    _588 = _571;
  }
  CLAMP_IF_SDR3(_586, _587, _588);
  CAPTURE_TONEMAPPED(float3(_586, _587, _588));

  float _603 = (saturate((log2(_588 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _607 = (saturate((log2(_587 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _611 = (saturate((log2(_586 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!(cb0_107w == 0)) {
    float4 _632 = t3.Sample(s3, float2(min(max(((cb0_084z * _40) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _41) + cb0_085y), cb0_083w), cb0_084y)));
    float _642 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_632.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _643 = t7.Sample(s7, float3(_611, _607, _603));
    float4 _650 = t6.Sample(s6, float3(_611, _607, _603));
    _675 = ((((_650.x - _643.x) * 1.0499999523162842f) * _642) + (_643.x * 1.0499999523162842f));
    _676 = ((((_650.y - _643.y) * 1.0499999523162842f) * _642) + (_643.y * 1.0499999523162842f));
    _677 = ((((_650.z - _643.z) * 1.0499999523162842f) * _642) + (_643.z * 1.0499999523162842f));
  } else {
    float4 _667 = t6.Sample(s6, float3(_611, _607, _603));
    _675 = (_667.x * 1.0499999523162842f);
    _676 = (_667.y * 1.0499999523162842f);
    _677 = (_667.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3_FADE(_675, _676, _677, t6, s6);

  float _685 = ((_46 * 0.00390625f) + -0.001953125f) + _675;
  float _686 = ((_68 * 0.00390625f) + -0.001953125f) + _676;
  float _687 = ((_69 * 0.00390625f) + -0.001953125f) + _677;
  [branch]
  if (!(cb0_106w == 0)) {
    float _699 = (pow(_685, 0.012683313339948654f));
    float _700 = (pow(_686, 0.012683313339948654f));
    float _701 = (pow(_687, 0.012683313339948654f));
    float _734 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_699 + -0.8359375f)) / (18.8515625f - (_699 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _735 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_700 + -0.8359375f)) / (18.8515625f - (_700 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _736 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_701 + -0.8359375f)) / (18.8515625f - (_701 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _762 = min((_734 * 12.920000076293945f), ((exp2(log2(max(_734, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _763 = min((_735 * 12.920000076293945f), ((exp2(log2(max(_735, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _764 = min((_736 * 12.920000076293945f), ((exp2(log2(max(_736, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _762 = _685;
    _763 = _686;
    _764 = _687;
  }
  SV_Target.x = _762;
  SV_Target.y = _763;
  SV_Target.z = _764;
  SV_Target.w = (dot(float3(_675, _676, _677), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  
  return SV_Target;
}
