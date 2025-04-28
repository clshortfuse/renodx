#include "../../common.hlsli"
struct SExposureData {
  float SExposureData_000;
  float SExposureData_004;
  float SExposureData_008;
  float SExposureData_012;
  float SExposureData_016;
  float SExposureData_020;
};

StructuredBuffer<SExposureData> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture3D<float4> t5 : register(t5);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t7 : register(t7);

Texture3D<float2> t8 : register(t8);

cbuffer cb0 : register(b0) {
  float cb0_028x : packoffset(c028.x);
  float cb0_028z : packoffset(c028.z);
};

cbuffer cb1 : register(b1) {
  float cb1_018y : packoffset(c018.y);
  float cb1_018z : packoffset(c018.z);
  uint cb1_018w : packoffset(c018.w);
};

cbuffer cb2 : register(b2) {
  float cb2_000x : packoffset(c000.x);
  float cb2_000y : packoffset(c000.y);
  float cb2_000z : packoffset(c000.z);
  float cb2_003x : packoffset(c003.x);
  float cb2_003y : packoffset(c003.y);
  float cb2_003z : packoffset(c003.z);
  float cb2_003w : packoffset(c003.w);
  float cb2_004x : packoffset(c004.x);
  float cb2_004y : packoffset(c004.y);
  float cb2_004z : packoffset(c004.z);
  float cb2_004w : packoffset(c004.w);
  float cb2_005x : packoffset(c005.x);
  float cb2_006x : packoffset(c006.x);
  float cb2_006y : packoffset(c006.y);
  float cb2_006z : packoffset(c006.z);
  float cb2_006w : packoffset(c006.w);
  float cb2_007x : packoffset(c007.x);
  float cb2_007y : packoffset(c007.y);
  float cb2_007z : packoffset(c007.z);
  float cb2_007w : packoffset(c007.w);
  float cb2_008x : packoffset(c008.x);
  float cb2_008y : packoffset(c008.y);
  float cb2_008z : packoffset(c008.z);
  float cb2_008w : packoffset(c008.w);
  float cb2_016x : packoffset(c016.x);
  float cb2_016y : packoffset(c016.y);
  float cb2_016z : packoffset(c016.z);
  float cb2_016w : packoffset(c016.w);
  float cb2_017x : packoffset(c017.x);
  float cb2_017y : packoffset(c017.y);
  float cb2_017z : packoffset(c017.z);
  float cb2_017w : packoffset(c017.w);
  float cb2_018x : packoffset(c018.x);
  float cb2_018y : packoffset(c018.y);
  float cb2_020x : packoffset(c020.x);
  float cb2_020y : packoffset(c020.y);
  float cb2_020z : packoffset(c020.z);
  float cb2_020w : packoffset(c020.w);
  float cb2_021x : packoffset(c021.x);
  float cb2_021y : packoffset(c021.y);
  float cb2_021z : packoffset(c021.z);
  float cb2_021w : packoffset(c021.w);
  float cb2_024x : packoffset(c024.x);
  float cb2_024y : packoffset(c024.y);
  float cb2_024z : packoffset(c024.z);
  float cb2_024w : packoffset(c024.w);
  float cb2_025x : packoffset(c025.x);
  float cb2_025y : packoffset(c025.y);
  float cb2_025z : packoffset(c025.z);
  float cb2_026y : packoffset(c026.y);
  float cb2_026z : packoffset(c026.z);
  float cb2_026w : packoffset(c026.w);
  float cb2_027x : packoffset(c027.x);
  float cb2_027y : packoffset(c027.y);
  float cb2_027z : packoffset(c027.z);
  float cb2_027w : packoffset(c027.w);
  uint cb2_028x : packoffset(c028.x);
  uint cb2_069y : packoffset(c069.y);
};

SamplerState s2_space2 : register(s2, space2);

SamplerState s4_space2 : register(s4, space2);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
  linear float2 TEXCOORD0_centroid : TEXCOORD0_centroid,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float _20 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _22 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _26 = max(_22.x, 0.0f);
  float _27 = max(_22.y, 0.0f);
  float _28 = max(_22.z, 0.0f);
  float _29 = min(_26, 65000.0f);
  float _30 = min(_27, 65000.0f);
  float _31 = min(_28, 65000.0f);
  float4 _32 = t3.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _37 = max(_32.x, 0.0f);
  float _38 = max(_32.y, 0.0f);
  float _39 = max(_32.z, 0.0f);
  float _40 = max(_32.w, 0.0f);
  float _41 = min(_37, 5000.0f);
  float _42 = min(_38, 5000.0f);
  float _43 = min(_39, 5000.0f);
  float _44 = min(_40, 5000.0f);
  float _47 = _20.x * cb0_028z;
  float _48 = _47 + cb0_028x;
  float _49 = cb2_027w / _48;
  float _50 = 1.0f - _49;
  float _51 = abs(_50);
  float _53 = cb2_027y * _51;
  float _55 = _53 - cb2_027z;
  float _56 = saturate(_55);
  float _57 = max(_56, _44);
  float _58 = saturate(_57);
  float _62 = cb2_006x * TEXCOORD0_centroid.x;
  float _63 = cb2_006y * TEXCOORD0_centroid.y;
  float _66 = _62 + cb2_006z;
  float _67 = _63 + cb2_006w;
  float _71 = cb2_007x * TEXCOORD0_centroid.x;
  float _72 = cb2_007y * TEXCOORD0_centroid.y;
  float _75 = _71 + cb2_007z;
  float _76 = _72 + cb2_007w;
  float _80 = cb2_008x * TEXCOORD0_centroid.x;
  float _81 = cb2_008y * TEXCOORD0_centroid.y;
  float _84 = _80 + cb2_008z;
  float _85 = _81 + cb2_008w;
  float4 _86 = t1.SampleLevel(s2_space2, float2(_66, _67), 0.0f);
  float _88 = max(_86.x, 0.0f);
  float _89 = min(_88, 65000.0f);
  float4 _90 = t1.SampleLevel(s2_space2, float2(_75, _76), 0.0f);
  float _92 = max(_90.y, 0.0f);
  float _93 = min(_92, 65000.0f);
  float4 _94 = t1.SampleLevel(s2_space2, float2(_84, _85), 0.0f);
  float _96 = max(_94.z, 0.0f);
  float _97 = min(_96, 65000.0f);
  float4 _98 = t3.SampleLevel(s2_space2, float2(_66, _67), 0.0f);
  float _100 = max(_98.x, 0.0f);
  float _101 = min(_100, 5000.0f);
  float4 _102 = t3.SampleLevel(s2_space2, float2(_75, _76), 0.0f);
  float _104 = max(_102.y, 0.0f);
  float _105 = min(_104, 5000.0f);
  float4 _106 = t3.SampleLevel(s2_space2, float2(_84, _85), 0.0f);
  float _108 = max(_106.z, 0.0f);
  float _109 = min(_108, 5000.0f);
  float4 _110 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _116 = cb2_005x * _110.x;
  float _117 = cb2_005x * _110.y;
  float _118 = cb2_005x * _110.z;
  float _119 = _89 - _29;
  float _120 = _93 - _30;
  float _121 = _97 - _31;
  float _122 = _116 * _119;
  float _123 = _117 * _120;
  float _124 = _118 * _121;
  float _125 = _122 + _29;
  float _126 = _123 + _30;
  float _127 = _124 + _31;
  float _128 = _101 - _41;
  float _129 = _105 - _42;
  float _130 = _109 - _43;
  float _131 = _116 * _128;
  float _132 = _117 * _129;
  float _133 = _118 * _130;
  float _134 = _131 + _41;
  float _135 = _132 + _42;
  float _136 = _133 + _43;
  float4 _137 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _141 = _134 - _125;
  float _142 = _135 - _126;
  float _143 = _136 - _127;
  float _144 = _141 * _58;
  float _145 = _142 * _58;
  float _146 = _143 * _58;
  float _147 = _144 + _125;
  float _148 = _145 + _126;
  float _149 = _146 + _127;
  float _150 = dot(float3(_147, _148, _149), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _154 = t0[0].SExposureData_020;
  float _156 = t0[0].SExposureData_004;
  float _158 = cb2_018x * 0.5f;
  float _159 = _158 * cb2_018y;
  float _160 = _156.x - _159;
  float _161 = cb2_018y * cb2_018x;
  float _162 = 1.0f / _161;
  float _163 = _160 * _162;
  float _164 = _150 / _154.x;
  float _165 = _164 * 5464.01611328125f;
  float _166 = _165 + 9.99999993922529e-09f;
  float _167 = log2(_166);
  float _168 = _167 - _160;
  float _169 = _168 * _162;
  float _170 = saturate(_169);
  float2 _171 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _170), 0.0f);
  float _174 = max(_171.y, 1.0000000116860974e-07f);
  float _175 = _171.x / _174;
  float _176 = _175 + _163;
  float _177 = _176 / _162;
  float _178 = _177 - _156.x;
  float _179 = -0.0f - _178;
  float _181 = _179 - cb2_027x;
  float _182 = max(0.0f, _181);
  float _185 = cb2_026z * _182;
  float _186 = _178 - cb2_027x;
  float _187 = max(0.0f, _186);
  float _189 = cb2_026w * _187;
  bool _190 = (_178 < 0.0f);
  float _191 = select(_190, _185, _189);
  float _192 = exp2(_191);
  float _193 = _192 * _147;
  float _194 = _192 * _148;
  float _195 = _192 * _149;
  float _200 = cb2_024y * _137.x;
  float _201 = cb2_024z * _137.y;
  float _202 = cb2_024w * _137.z;
  float _203 = _200 + _193;
  float _204 = _201 + _194;
  float _205 = _202 + _195;
  float _210 = _203 * cb2_025x;
  float _211 = _204 * cb2_025y;
  float _212 = _205 * cb2_025z;
  float _213 = dot(float3(_210, _211, _212), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _214 = t0[0].SExposureData_012;
  float _216 = _213 * 5464.01611328125f;
  float _217 = _216 * _214.x;
  float _218 = _217 + 9.99999993922529e-09f;
  float _219 = log2(_218);
  float _220 = _219 + 16.929765701293945f;
  float _221 = _220 * 0.05734497308731079f;
  float _222 = saturate(_221);
  float _223 = _222 * _222;
  float _224 = _222 * 2.0f;
  float _225 = 3.0f - _224;
  float _226 = _223 * _225;
  float _227 = _211 * 0.8450999855995178f;
  float _228 = _212 * 0.14589999616146088f;
  float _229 = _227 + _228;
  float _230 = _229 * 2.4890189170837402f;
  float _231 = _229 * 0.3754962384700775f;
  float _232 = _229 * 2.811495304107666f;
  float _233 = _229 * 5.519708156585693f;
  float _234 = _213 - _230;
  float _235 = _226 * _234;
  float _236 = _235 + _230;
  float _237 = _226 * 0.5f;
  float _238 = _237 + 0.5f;
  float _239 = _238 * _234;
  float _240 = _239 + _230;
  float _241 = _210 - _231;
  float _242 = _211 - _232;
  float _243 = _212 - _233;
  float _244 = _238 * _241;
  float _245 = _238 * _242;
  float _246 = _238 * _243;
  float _247 = _244 + _231;
  float _248 = _245 + _232;
  float _249 = _246 + _233;
  float _250 = 1.0f / _240;
  float _251 = _236 * _250;
  float _252 = _251 * _247;
  float _253 = _251 * _248;
  float _254 = _251 * _249;
  float _258 = cb2_020x * TEXCOORD0_centroid.x;
  float _259 = cb2_020y * TEXCOORD0_centroid.y;
  float _262 = _258 + cb2_020z;
  float _263 = _259 + cb2_020w;
  float _266 = dot(float2(_262, _263), float2(_262, _263));
  float _267 = 1.0f - _266;
  float _268 = saturate(_267);
  float _269 = log2(_268);
  float _270 = _269 * cb2_021w;
  float _271 = exp2(_270);
  float _275 = _252 - cb2_021x;
  float _276 = _253 - cb2_021y;
  float _277 = _254 - cb2_021z;
  float _278 = _275 * _271;
  float _279 = _276 * _271;
  float _280 = _277 * _271;
  float _281 = _278 + cb2_021x;
  float _282 = _279 + cb2_021y;
  float _283 = _280 + cb2_021z;
  float _284 = t0[0].SExposureData_000;
  float _286 = max(_154.x, 0.0010000000474974513f);
  float _287 = 1.0f / _286;
  float _288 = _287 * _284.x;
  bool _291 = ((uint)(cb2_069y) == 0);
  float _297;
  float _298;
  float _299;
  float _353;
  float _354;
  float _355;
  float _400;
  float _401;
  float _402;
  float _447;
  float _448;
  float _449;
  float _450;
  float _497;
  float _498;
  float _499;
  float _524;
  float _525;
  float _526;
  float _627;
  float _628;
  float _629;
  float _654;
  float _666;
  float _694;
  float _706;
  float _718;
  float _719;
  float _720;
  float _747;
  float _748;
  float _749;
  if (!_291) {
    float _293 = _288 * _281;
    float _294 = _288 * _282;
    float _295 = _288 * _283;
    _297 = _293;
    _298 = _294;
    _299 = _295;
  } else {
    _297 = _281;
    _298 = _282;
    _299 = _283;
  }
  float _300 = _297 * 0.6130970120429993f;
  float _301 = mad(0.33952298760414124f, _298, _300);
  float _302 = mad(0.04737899824976921f, _299, _301);
  float _303 = _297 * 0.07019399851560593f;
  float _304 = mad(0.9163540005683899f, _298, _303);
  float _305 = mad(0.013451999984681606f, _299, _304);
  float _306 = _297 * 0.02061600051820278f;
  float _307 = mad(0.10956999659538269f, _298, _306);
  float _308 = mad(0.8698149919509888f, _299, _307);
  float _309 = log2(_302);
  float _310 = log2(_305);
  float _311 = log2(_308);
  float _312 = _309 * 0.04211956635117531f;
  float _313 = _310 * 0.04211956635117531f;
  float _314 = _311 * 0.04211956635117531f;
  float _315 = _312 + 0.6252607107162476f;
  float _316 = _313 + 0.6252607107162476f;
  float _317 = _314 + 0.6252607107162476f;
  float4 _318 = t5.SampleLevel(s2_space2, float3(_315, _316, _317), 0.0f);
  bool _324 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_324 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _328 = cb2_017x * _318.x;
    float _329 = cb2_017x * _318.y;
    float _330 = cb2_017x * _318.z;
    float _332 = _328 + cb2_017y;
    float _333 = _329 + cb2_017y;
    float _334 = _330 + cb2_017y;
    float _335 = exp2(_332);
    float _336 = exp2(_333);
    float _337 = exp2(_334);
    float _338 = _335 + 1.0f;
    float _339 = _336 + 1.0f;
    float _340 = _337 + 1.0f;
    float _341 = 1.0f / _338;
    float _342 = 1.0f / _339;
    float _343 = 1.0f / _340;
    float _345 = cb2_017z * _341;
    float _346 = cb2_017z * _342;
    float _347 = cb2_017z * _343;
    float _349 = _345 + cb2_017w;
    float _350 = _346 + cb2_017w;
    float _351 = _347 + cb2_017w;
    _353 = _349;
    _354 = _350;
    _355 = _351;
  } else {
    _353 = _318.x;
    _354 = _318.y;
    _355 = _318.z;
  }
  float _356 = _353 * 23.0f;
  float _357 = _356 + -14.473931312561035f;
  float _358 = exp2(_357);
  float _359 = _354 * 23.0f;
  float _360 = _359 + -14.473931312561035f;
  float _361 = exp2(_360);
  float _362 = _355 * 23.0f;
  float _363 = _362 + -14.473931312561035f;
  float _364 = exp2(_363);
  float _368 = cb2_004x * TEXCOORD0_centroid.x;
  float _369 = cb2_004y * TEXCOORD0_centroid.y;
  float _372 = _368 + cb2_004z;
  float _373 = _369 + cb2_004w;
  float4 _379 = t7.Sample(s2_space2, float2(_372, _373));
  float _384 = _379.x * cb2_003x;
  float _385 = _379.y * cb2_003y;
  float _386 = _379.z * cb2_003z;
  float _387 = _379.w * cb2_003w;
  float _390 = _387 + cb2_026y;
  float _391 = saturate(_390);
  bool _394 = ((uint)(cb2_069y) == 0);
  if (!_394) {
    float _396 = _384 * _288;
    float _397 = _385 * _288;
    float _398 = _386 * _288;
    _400 = _396;
    _401 = _397;
    _402 = _398;
  } else {
    _400 = _384;
    _401 = _385;
    _402 = _386;
  }
  bool _405 = ((uint)(cb2_028x) == 2);
  bool _406 = ((uint)(cb2_028x) == 3);
  int _407 = (uint)(cb2_028x) & -2;
  bool _408 = (_407 == 2);
  bool _409 = ((uint)(cb2_028x) == 6);
  bool _410 = _408 || _409;
  if (_410) {
    float _412 = _400 * _391;
    float _413 = _401 * _391;
    float _414 = _402 * _391;
    float _415 = _391 * _391;
    _447 = _412;
    _448 = _413;
    _449 = _414;
    _450 = _415;
  } else {
    bool _417 = ((uint)(cb2_028x) == 4);
    if (_417) {
      float _419 = _400 + -1.0f;
      float _420 = _401 + -1.0f;
      float _421 = _402 + -1.0f;
      float _422 = _391 + -1.0f;
      float _423 = _419 * _391;
      float _424 = _420 * _391;
      float _425 = _421 * _391;
      float _426 = _422 * _391;
      float _427 = _423 + 1.0f;
      float _428 = _424 + 1.0f;
      float _429 = _425 + 1.0f;
      float _430 = _426 + 1.0f;
      _447 = _427;
      _448 = _428;
      _449 = _429;
      _450 = _430;
    } else {
      bool _432 = ((uint)(cb2_028x) == 5);
      if (_432) {
        float _434 = _400 + -0.5f;
        float _435 = _401 + -0.5f;
        float _436 = _402 + -0.5f;
        float _437 = _391 + -0.5f;
        float _438 = _434 * _391;
        float _439 = _435 * _391;
        float _440 = _436 * _391;
        float _441 = _437 * _391;
        float _442 = _438 + 0.5f;
        float _443 = _439 + 0.5f;
        float _444 = _440 + 0.5f;
        float _445 = _441 + 0.5f;
        _447 = _442;
        _448 = _443;
        _449 = _444;
        _450 = _445;
      } else {
        _447 = _400;
        _448 = _401;
        _449 = _402;
        _450 = _391;
      }
    }
  }
  if (_405) {
    float _452 = _447 + _358;
    float _453 = _448 + _361;
    float _454 = _449 + _364;
    _497 = _452;
    _498 = _453;
    _499 = _454;
  } else {
    if (_406) {
      float _457 = 1.0f - _447;
      float _458 = 1.0f - _448;
      float _459 = 1.0f - _449;
      float _460 = _457 * _358;
      float _461 = _458 * _361;
      float _462 = _459 * _364;
      float _463 = _460 + _447;
      float _464 = _461 + _448;
      float _465 = _462 + _449;
      _497 = _463;
      _498 = _464;
      _499 = _465;
    } else {
      bool _467 = ((uint)(cb2_028x) == 4);
      if (_467) {
        float _469 = _447 * _358;
        float _470 = _448 * _361;
        float _471 = _449 * _364;
        _497 = _469;
        _498 = _470;
        _499 = _471;
      } else {
        bool _473 = ((uint)(cb2_028x) == 5);
        if (_473) {
          float _475 = _358 * 2.0f;
          float _476 = _475 * _447;
          float _477 = _361 * 2.0f;
          float _478 = _477 * _448;
          float _479 = _364 * 2.0f;
          float _480 = _479 * _449;
          _497 = _476;
          _498 = _478;
          _499 = _480;
        } else {
          if (_409) {
            float _483 = _358 - _447;
            float _484 = _361 - _448;
            float _485 = _364 - _449;
            _497 = _483;
            _498 = _484;
            _499 = _485;
          } else {
            float _487 = _447 - _358;
            float _488 = _448 - _361;
            float _489 = _449 - _364;
            float _490 = _450 * _487;
            float _491 = _450 * _488;
            float _492 = _450 * _489;
            float _493 = _490 + _358;
            float _494 = _491 + _361;
            float _495 = _492 + _364;
            _497 = _493;
            _498 = _494;
            _499 = _495;
          }
        }
      }
    }
  }
  float _505 = cb2_016x - _497;
  float _506 = cb2_016y - _498;
  float _507 = cb2_016z - _499;
  float _508 = _505 * cb2_016w;
  float _509 = _506 * cb2_016w;
  float _510 = _507 * cb2_016w;
  float _511 = _508 + _497;
  float _512 = _509 + _498;
  float _513 = _510 + _499;
  bool _516 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_516 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _520 = cb2_024x * _511;
    float _521 = cb2_024x * _512;
    float _522 = cb2_024x * _513;
    _524 = _520;
    _525 = _521;
    _526 = _522;
  } else {
    _524 = _511;
    _525 = _512;
    _526 = _513;
  }
  float _527 = _524 * 0.9708889722824097f;
  float _528 = mad(0.026962999254465103f, _525, _527);
  float _529 = mad(0.002148000057786703f, _526, _528);
  float _530 = _524 * 0.01088900025933981f;
  float _531 = mad(0.9869629740715027f, _525, _530);
  float _532 = mad(0.002148000057786703f, _526, _531);
  float _533 = mad(0.026962999254465103f, _525, _530);
  float _534 = mad(0.9621480107307434f, _526, _533);
  if (_516) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _539 = cb1_018y * 0.10000000149011612f;
        float _540 = log2(cb1_018z);
        float _541 = _540 + -13.287712097167969f;
        float _542 = _541 * 1.4929734468460083f;
        float _543 = _542 + 18.0f;
        float _544 = exp2(_543);
        float _545 = _544 * 0.18000000715255737f;
        float _546 = abs(_545);
        float _547 = log2(_546);
        float _548 = _547 * 1.5f;
        float _549 = exp2(_548);
        float _550 = _549 * _539;
        float _551 = _550 / cb1_018z;
        float _552 = _551 + -0.07636754959821701f;
        float _553 = _547 * 1.2750000953674316f;
        float _554 = exp2(_553);
        float _555 = _554 * 0.07636754959821701f;
        float _556 = cb1_018y * 0.011232397519052029f;
        float _557 = _556 * _549;
        float _558 = _557 / cb1_018z;
        float _559 = _555 - _558;
        float _560 = _554 + -0.11232396960258484f;
        float _561 = _560 * _539;
        float _562 = _561 / cb1_018z;
        float _563 = _562 * cb1_018z;
        float _564 = abs(_529);
        float _565 = abs(_532);
        float _566 = abs(_534);
        float _567 = log2(_564);
        float _568 = log2(_565);
        float _569 = log2(_566);
        float _570 = _567 * 1.5f;
        float _571 = _568 * 1.5f;
        float _572 = _569 * 1.5f;
        float _573 = exp2(_570);
        float _574 = exp2(_571);
        float _575 = exp2(_572);
        float _576 = _573 * _563;
        float _577 = _574 * _563;
        float _578 = _575 * _563;
        float _579 = _567 * 1.2750000953674316f;
        float _580 = _568 * 1.2750000953674316f;
        float _581 = _569 * 1.2750000953674316f;
        float _582 = exp2(_579);
        float _583 = exp2(_580);
        float _584 = exp2(_581);
        float _585 = _582 * _552;
        float _586 = _583 * _552;
        float _587 = _584 * _552;
        float _588 = _585 + _559;
        float _589 = _586 + _559;
        float _590 = _587 + _559;
        float _591 = _576 / _588;
        float _592 = _577 / _589;
        float _593 = _578 / _590;
        float _594 = _591 * 9.999999747378752e-05f;
        float _595 = _592 * 9.999999747378752e-05f;
        float _596 = _593 * 9.999999747378752e-05f;
        float _597 = 5000.0f / cb1_018y;
        float _598 = _594 * _597;
        float _599 = _595 * _597;
        float _600 = _596 * _597;
        _627 = _598;
        _628 = _599;
        _629 = _600;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_529, _532, _534));
      _627 = tonemapped.x, _628 = tonemapped.y, _629 = tonemapped.z;
    }
      } else {
        float _602 = _529 + 0.020616600289940834f;
        float _603 = _532 + 0.020616600289940834f;
        float _604 = _534 + 0.020616600289940834f;
        float _605 = _602 * _529;
        float _606 = _603 * _532;
        float _607 = _604 * _534;
        float _608 = _605 + -7.456949970219284e-05f;
        float _609 = _606 + -7.456949970219284e-05f;
        float _610 = _607 + -7.456949970219284e-05f;
        float _611 = _529 * 0.9837960004806519f;
        float _612 = _532 * 0.9837960004806519f;
        float _613 = _534 * 0.9837960004806519f;
        float _614 = _611 + 0.4336790144443512f;
        float _615 = _612 + 0.4336790144443512f;
        float _616 = _613 + 0.4336790144443512f;
        float _617 = _614 * _529;
        float _618 = _615 * _532;
        float _619 = _616 * _534;
        float _620 = _617 + 0.24617899954319f;
        float _621 = _618 + 0.24617899954319f;
        float _622 = _619 + 0.24617899954319f;
        float _623 = _608 / _620;
        float _624 = _609 / _621;
        float _625 = _610 / _622;
        _627 = _623;
        _628 = _624;
        _629 = _625;
      }
      float _630 = _627 * 1.6047500371932983f;
      float _631 = mad(-0.5310800075531006f, _628, _630);
      float _632 = mad(-0.07366999983787537f, _629, _631);
      float _633 = _627 * -0.10208000242710114f;
      float _634 = mad(1.1081299781799316f, _628, _633);
      float _635 = mad(-0.006049999967217445f, _629, _634);
      float _636 = _627 * -0.0032599999103695154f;
      float _637 = mad(-0.07275000214576721f, _628, _636);
      float _638 = mad(1.0760200023651123f, _629, _637);
      if (_516) {
        // float _640 = max(_632, 0.0f);
        // float _641 = max(_635, 0.0f);
        // float _642 = max(_638, 0.0f);
        // bool _643 = !(_640 >= 0.0030399328097701073f);
        // if (!_643) {
        //   float _645 = abs(_640);
        //   float _646 = log2(_645);
        //   float _647 = _646 * 0.4166666567325592f;
        //   float _648 = exp2(_647);
        //   float _649 = _648 * 1.0549999475479126f;
        //   float _650 = _649 + -0.054999999701976776f;
        //   _654 = _650;
        // } else {
        //   float _652 = _640 * 12.923210144042969f;
        //   _654 = _652;
        // }
        // bool _655 = !(_641 >= 0.0030399328097701073f);
        // if (!_655) {
        //   float _657 = abs(_641);
        //   float _658 = log2(_657);
        //   float _659 = _658 * 0.4166666567325592f;
        //   float _660 = exp2(_659);
        //   float _661 = _660 * 1.0549999475479126f;
        //   float _662 = _661 + -0.054999999701976776f;
        //   _666 = _662;
        // } else {
        //   float _664 = _641 * 12.923210144042969f;
        //   _666 = _664;
        // }
        // bool _667 = !(_642 >= 0.0030399328097701073f);
        // if (!_667) {
        //   float _669 = abs(_642);
        //   float _670 = log2(_669);
        //   float _671 = _670 * 0.4166666567325592f;
        //   float _672 = exp2(_671);
        //   float _673 = _672 * 1.0549999475479126f;
        //   float _674 = _673 + -0.054999999701976776f;
        //   _747 = _654;
        //   _748 = _666;
        //   _749 = _674;
        // } else {
        //   float _676 = _642 * 12.923210144042969f;
        //   _747 = _654;
        //   _748 = _666;
        //   _749 = _676;
        // }
        _747 = renodx::color::srgb::EncodeSafe(_632);
        _748 = renodx::color::srgb::EncodeSafe(_635);
        _749 = renodx::color::srgb::EncodeSafe(_638);

      } else {
        float _678 = saturate(_632);
        float _679 = saturate(_635);
        float _680 = saturate(_638);
        bool _681 = ((uint)(cb1_018w) == -2);
        if (!_681) {
          bool _683 = !(_678 >= 0.0030399328097701073f);
          if (!_683) {
            float _685 = abs(_678);
            float _686 = log2(_685);
            float _687 = _686 * 0.4166666567325592f;
            float _688 = exp2(_687);
            float _689 = _688 * 1.0549999475479126f;
            float _690 = _689 + -0.054999999701976776f;
            _694 = _690;
          } else {
            float _692 = _678 * 12.923210144042969f;
            _694 = _692;
          }
          bool _695 = !(_679 >= 0.0030399328097701073f);
          if (!_695) {
            float _697 = abs(_679);
            float _698 = log2(_697);
            float _699 = _698 * 0.4166666567325592f;
            float _700 = exp2(_699);
            float _701 = _700 * 1.0549999475479126f;
            float _702 = _701 + -0.054999999701976776f;
            _706 = _702;
          } else {
            float _704 = _679 * 12.923210144042969f;
            _706 = _704;
          }
          bool _707 = !(_680 >= 0.0030399328097701073f);
          if (!_707) {
            float _709 = abs(_680);
            float _710 = log2(_709);
            float _711 = _710 * 0.4166666567325592f;
            float _712 = exp2(_711);
            float _713 = _712 * 1.0549999475479126f;
            float _714 = _713 + -0.054999999701976776f;
            _718 = _694;
            _719 = _706;
            _720 = _714;
          } else {
            float _716 = _680 * 12.923210144042969f;
            _718 = _694;
            _719 = _706;
            _720 = _716;
          }
        } else {
          _718 = _678;
          _719 = _679;
          _720 = _680;
        }
        float _725 = abs(_718);
        float _726 = abs(_719);
        float _727 = abs(_720);
        float _728 = log2(_725);
        float _729 = log2(_726);
        float _730 = log2(_727);
        float _731 = _728 * cb2_000z;
        float _732 = _729 * cb2_000z;
        float _733 = _730 * cb2_000z;
        float _734 = exp2(_731);
        float _735 = exp2(_732);
        float _736 = exp2(_733);
        float _737 = _734 * cb2_000y;
        float _738 = _735 * cb2_000y;
        float _739 = _736 * cb2_000y;
        float _740 = _737 + cb2_000x;
        float _741 = _738 + cb2_000x;
        float _742 = _739 + cb2_000x;
        float _743 = saturate(_740);
        float _744 = saturate(_741);
        float _745 = saturate(_742);
        _747 = _743;
        _748 = _744;
        _749 = _745;
      }
      float _750 = dot(float3(_747, _748, _749), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _747;
      SV_Target.y = _748;
      SV_Target.z = _749;
      SV_Target.w = _750;
      SV_Target_1.x = _750;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
