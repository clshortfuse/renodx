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

Texture2D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t8 : register(t8);

Texture3D<float2> t9 : register(t9);

Texture2D<float4> t10 : register(t10);

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
  float cb2_001x : packoffset(c001.x);
  float cb2_001y : packoffset(c001.y);
  float cb2_001z : packoffset(c001.z);
  float cb2_002x : packoffset(c002.x);
  float cb2_002y : packoffset(c002.y);
  float cb2_002z : packoffset(c002.z);
  float cb2_002w : packoffset(c002.w);
  float cb2_003x : packoffset(c003.x);
  float cb2_003y : packoffset(c003.y);
  float cb2_003z : packoffset(c003.z);
  float cb2_003w : packoffset(c003.w);
  float cb2_004x : packoffset(c004.x);
  float cb2_004y : packoffset(c004.y);
  float cb2_004z : packoffset(c004.z);
  float cb2_004w : packoffset(c004.w);
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
  uint cb2_019x : packoffset(c019.x);
  uint cb2_019y : packoffset(c019.y);
  uint cb2_019z : packoffset(c019.z);
  uint cb2_019w : packoffset(c019.w);
  float cb2_020x : packoffset(c020.x);
  float cb2_020y : packoffset(c020.y);
  float cb2_020z : packoffset(c020.z);
  float cb2_020w : packoffset(c020.w);
  float cb2_021x : packoffset(c021.x);
  float cb2_021y : packoffset(c021.y);
  float cb2_021z : packoffset(c021.z);
  float cb2_021w : packoffset(c021.w);
  float cb2_022x : packoffset(c022.x);
  float cb2_023x : packoffset(c023.x);
  float cb2_023y : packoffset(c023.y);
  float cb2_023z : packoffset(c023.z);
  float cb2_023w : packoffset(c023.w);
  float cb2_024x : packoffset(c024.x);
  float cb2_024y : packoffset(c024.y);
  float cb2_024z : packoffset(c024.z);
  float cb2_024w : packoffset(c024.w);
  float cb2_025x : packoffset(c025.x);
  float cb2_025y : packoffset(c025.y);
  float cb2_025z : packoffset(c025.z);
  float cb2_025w : packoffset(c025.w);
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

SamplerState s0_space2 : register(s0, space2);

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
  float _25 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _27 = t8.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _31 = _27.x * 6.283199787139893f;
  float _32 = cos(_31);
  float _33 = sin(_31);
  float _34 = _32 * _27.z;
  float _35 = _33 * _27.z;
  float _36 = _34 + TEXCOORD0_centroid.x;
  float _37 = _35 + TEXCOORD0_centroid.y;
  float _38 = _36 * 10.0f;
  float _39 = 10.0f - _38;
  float _40 = min(_38, _39);
  float _41 = saturate(_40);
  float _42 = _41 * _34;
  float _43 = _37 * 10.0f;
  float _44 = 10.0f - _43;
  float _45 = min(_43, _44);
  float _46 = saturate(_45);
  float _47 = _46 * _35;
  float _48 = _42 + TEXCOORD0_centroid.x;
  float _49 = _47 + TEXCOORD0_centroid.y;
  float4 _50 = t8.SampleLevel(s2_space2, float2(_48, _49), 0.0f);
  float _52 = _50.w * _42;
  float _53 = _50.w * _47;
  float _54 = 1.0f - _27.y;
  float _55 = saturate(_54);
  float _56 = _52 * _55;
  float _57 = _53 * _55;
  float _58 = _56 + TEXCOORD0_centroid.x;
  float _59 = _57 + TEXCOORD0_centroid.y;
  float4 _60 = t8.SampleLevel(s2_space2, float2(_58, _59), 0.0f);
  bool _62 = (_60.y > 0.0f);
  float _63 = select(_62, TEXCOORD0_centroid.x, _58);
  float _64 = select(_62, TEXCOORD0_centroid.y, _59);
  float4 _65 = t1.SampleLevel(s4_space2, float2(_63, _64), 0.0f);
  float _69 = max(_65.x, 0.0f);
  float _70 = max(_65.y, 0.0f);
  float _71 = max(_65.z, 0.0f);
  float _72 = min(_69, 65000.0f);
  float _73 = min(_70, 65000.0f);
  float _74 = min(_71, 65000.0f);
  float4 _75 = t4.SampleLevel(s2_space2, float2(_63, _64), 0.0f);
  float _80 = max(_75.x, 0.0f);
  float _81 = max(_75.y, 0.0f);
  float _82 = max(_75.z, 0.0f);
  float _83 = max(_75.w, 0.0f);
  float _84 = min(_80, 5000.0f);
  float _85 = min(_81, 5000.0f);
  float _86 = min(_82, 5000.0f);
  float _87 = min(_83, 5000.0f);
  float _90 = _25.x * cb0_028z;
  float _91 = _90 + cb0_028x;
  float _92 = cb2_027w / _91;
  float _93 = 1.0f - _92;
  float _94 = abs(_93);
  float _96 = cb2_027y * _94;
  float _98 = _96 - cb2_027z;
  float _99 = saturate(_98);
  float _100 = max(_99, _87);
  float _101 = saturate(_100);
  float4 _102 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _106 = _84 - _72;
  float _107 = _85 - _73;
  float _108 = _86 - _74;
  float _109 = _101 * _106;
  float _110 = _101 * _107;
  float _111 = _101 * _108;
  float _112 = _109 + _72;
  float _113 = _110 + _73;
  float _114 = _111 + _74;
  float _115 = dot(float3(_112, _113, _114), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _119 = t0[0].SExposureData_020;
  float _121 = t0[0].SExposureData_004;
  float _123 = cb2_018x * 0.5f;
  float _124 = _123 * cb2_018y;
  float _125 = _121.x - _124;
  float _126 = cb2_018y * cb2_018x;
  float _127 = 1.0f / _126;
  float _128 = _125 * _127;
  float _129 = _115 / _119.x;
  float _130 = _129 * 5464.01611328125f;
  float _131 = _130 + 9.99999993922529e-09f;
  float _132 = log2(_131);
  float _133 = _132 - _125;
  float _134 = _133 * _127;
  float _135 = saturate(_134);
  float2 _136 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _135), 0.0f);
  float _139 = max(_136.y, 1.0000000116860974e-07f);
  float _140 = _136.x / _139;
  float _141 = _140 + _128;
  float _142 = _141 / _127;
  float _143 = _142 - _121.x;
  float _144 = -0.0f - _143;
  float _146 = _144 - cb2_027x;
  float _147 = max(0.0f, _146);
  float _150 = cb2_026z * _147;
  float _151 = _143 - cb2_027x;
  float _152 = max(0.0f, _151);
  float _154 = cb2_026w * _152;
  bool _155 = (_143 < 0.0f);
  float _156 = select(_155, _150, _154);
  float _157 = exp2(_156);
  float _158 = _157 * _112;
  float _159 = _157 * _113;
  float _160 = _157 * _114;
  float _165 = cb2_024y * _102.x;
  float _166 = cb2_024z * _102.y;
  float _167 = cb2_024w * _102.z;
  float _168 = _165 + _158;
  float _169 = _166 + _159;
  float _170 = _167 + _160;
  float _175 = _168 * cb2_025x;
  float _176 = _169 * cb2_025y;
  float _177 = _170 * cb2_025z;
  float _178 = dot(float3(_175, _176, _177), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _179 = t0[0].SExposureData_012;
  float _181 = _178 * 5464.01611328125f;
  float _182 = _181 * _179.x;
  float _183 = _182 + 9.99999993922529e-09f;
  float _184 = log2(_183);
  float _185 = _184 + 16.929765701293945f;
  float _186 = _185 * 0.05734497308731079f;
  float _187 = saturate(_186);
  float _188 = _187 * _187;
  float _189 = _187 * 2.0f;
  float _190 = 3.0f - _189;
  float _191 = _188 * _190;
  float _192 = _176 * 0.8450999855995178f;
  float _193 = _177 * 0.14589999616146088f;
  float _194 = _192 + _193;
  float _195 = _194 * 2.4890189170837402f;
  float _196 = _194 * 0.3754962384700775f;
  float _197 = _194 * 2.811495304107666f;
  float _198 = _194 * 5.519708156585693f;
  float _199 = _178 - _195;
  float _200 = _191 * _199;
  float _201 = _200 + _195;
  float _202 = _191 * 0.5f;
  float _203 = _202 + 0.5f;
  float _204 = _203 * _199;
  float _205 = _204 + _195;
  float _206 = _175 - _196;
  float _207 = _176 - _197;
  float _208 = _177 - _198;
  float _209 = _203 * _206;
  float _210 = _203 * _207;
  float _211 = _203 * _208;
  float _212 = _209 + _196;
  float _213 = _210 + _197;
  float _214 = _211 + _198;
  float _215 = 1.0f / _205;
  float _216 = _201 * _215;
  float _217 = _216 * _212;
  float _218 = _216 * _213;
  float _219 = _216 * _214;
  float _223 = cb2_020x * TEXCOORD0_centroid.x;
  float _224 = cb2_020y * TEXCOORD0_centroid.y;
  float _227 = _223 + cb2_020z;
  float _228 = _224 + cb2_020w;
  float _231 = dot(float2(_227, _228), float2(_227, _228));
  float _232 = 1.0f - _231;
  float _233 = saturate(_232);
  float _234 = log2(_233);
  float _235 = _234 * cb2_021w;
  float _236 = exp2(_235);
  float _240 = _217 - cb2_021x;
  float _241 = _218 - cb2_021y;
  float _242 = _219 - cb2_021z;
  float _243 = _240 * _236;
  float _244 = _241 * _236;
  float _245 = _242 * _236;
  float _246 = _243 + cb2_021x;
  float _247 = _244 + cb2_021y;
  float _248 = _245 + cb2_021z;
  float _249 = t0[0].SExposureData_000;
  float _251 = max(_119.x, 0.0010000000474974513f);
  float _252 = 1.0f / _251;
  float _253 = _252 * _249.x;
  bool _256 = ((uint)(cb2_069y) == 0);
  float _262;
  float _263;
  float _264;
  float _318;
  float _319;
  float _320;
  float _411;
  float _412;
  float _413;
  float _458;
  float _459;
  float _460;
  float _461;
  float _510;
  float _511;
  float _512;
  float _513;
  float _538;
  float _539;
  float _540;
  float _641;
  float _642;
  float _643;
  float _668;
  float _680;
  float _708;
  float _720;
  float _732;
  float _733;
  float _734;
  float _761;
  float _762;
  float _763;
  if (!_256) {
    float _258 = _253 * _246;
    float _259 = _253 * _247;
    float _260 = _253 * _248;
    _262 = _258;
    _263 = _259;
    _264 = _260;
  } else {
    _262 = _246;
    _263 = _247;
    _264 = _248;
  }
  float _265 = _262 * 0.6130970120429993f;
  float _266 = mad(0.33952298760414124f, _263, _265);
  float _267 = mad(0.04737899824976921f, _264, _266);
  float _268 = _262 * 0.07019399851560593f;
  float _269 = mad(0.9163540005683899f, _263, _268);
  float _270 = mad(0.013451999984681606f, _264, _269);
  float _271 = _262 * 0.02061600051820278f;
  float _272 = mad(0.10956999659538269f, _263, _271);
  float _273 = mad(0.8698149919509888f, _264, _272);
  float _274 = log2(_267);
  float _275 = log2(_270);
  float _276 = log2(_273);
  float _277 = _274 * 0.04211956635117531f;
  float _278 = _275 * 0.04211956635117531f;
  float _279 = _276 * 0.04211956635117531f;
  float _280 = _277 + 0.6252607107162476f;
  float _281 = _278 + 0.6252607107162476f;
  float _282 = _279 + 0.6252607107162476f;
  float4 _283 = t6.SampleLevel(s2_space2, float3(_280, _281, _282), 0.0f);
  bool _289 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_289 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _293 = cb2_017x * _283.x;
    float _294 = cb2_017x * _283.y;
    float _295 = cb2_017x * _283.z;
    float _297 = _293 + cb2_017y;
    float _298 = _294 + cb2_017y;
    float _299 = _295 + cb2_017y;
    float _300 = exp2(_297);
    float _301 = exp2(_298);
    float _302 = exp2(_299);
    float _303 = _300 + 1.0f;
    float _304 = _301 + 1.0f;
    float _305 = _302 + 1.0f;
    float _306 = 1.0f / _303;
    float _307 = 1.0f / _304;
    float _308 = 1.0f / _305;
    float _310 = cb2_017z * _306;
    float _311 = cb2_017z * _307;
    float _312 = cb2_017z * _308;
    float _314 = _310 + cb2_017w;
    float _315 = _311 + cb2_017w;
    float _316 = _312 + cb2_017w;
    _318 = _314;
    _319 = _315;
    _320 = _316;
  } else {
    _318 = _283.x;
    _319 = _283.y;
    _320 = _283.z;
  }
  float _321 = _318 * 23.0f;
  float _322 = _321 + -14.473931312561035f;
  float _323 = exp2(_322);
  float _324 = _319 * 23.0f;
  float _325 = _324 + -14.473931312561035f;
  float _326 = exp2(_325);
  float _327 = _320 * 23.0f;
  float _328 = _327 + -14.473931312561035f;
  float _329 = exp2(_328);
  float _330 = dot(float3(_323, _326, _329), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _335 = dot(float3(_323, _326, _329), float3(_323, _326, _329));
  float _336 = rsqrt(_335);
  float _337 = _336 * _323;
  float _338 = _336 * _326;
  float _339 = _336 * _329;
  float _340 = cb2_001x - _337;
  float _341 = cb2_001y - _338;
  float _342 = cb2_001z - _339;
  float _343 = dot(float3(_340, _341, _342), float3(_340, _341, _342));
  float _346 = cb2_002z * _343;
  float _348 = _346 + cb2_002w;
  float _349 = saturate(_348);
  float _351 = cb2_002x * _349;
  float _352 = _330 - _323;
  float _353 = _330 - _326;
  float _354 = _330 - _329;
  float _355 = _351 * _352;
  float _356 = _351 * _353;
  float _357 = _351 * _354;
  float _358 = _355 + _323;
  float _359 = _356 + _326;
  float _360 = _357 + _329;
  float _362 = cb2_002y * _349;
  float _363 = 0.10000000149011612f - _358;
  float _364 = 0.10000000149011612f - _359;
  float _365 = 0.10000000149011612f - _360;
  float _366 = _363 * _362;
  float _367 = _364 * _362;
  float _368 = _365 * _362;
  float _369 = _366 + _358;
  float _370 = _367 + _359;
  float _371 = _368 + _360;
  float _372 = saturate(_369);
  float _373 = saturate(_370);
  float _374 = saturate(_371);
  float _379 = cb2_004x * TEXCOORD0_centroid.x;
  float _380 = cb2_004y * TEXCOORD0_centroid.y;
  float _383 = _379 + cb2_004z;
  float _384 = _380 + cb2_004w;
  float4 _390 = t7.Sample(s2_space2, float2(_383, _384));
  float _395 = _390.x * cb2_003x;
  float _396 = _390.y * cb2_003y;
  float _397 = _390.z * cb2_003z;
  float _398 = _390.w * cb2_003w;
  float _401 = _398 + cb2_026y;
  float _402 = saturate(_401);
  bool _405 = ((uint)(cb2_069y) == 0);
  if (!_405) {
    float _407 = _395 * _253;
    float _408 = _396 * _253;
    float _409 = _397 * _253;
    _411 = _407;
    _412 = _408;
    _413 = _409;
  } else {
    _411 = _395;
    _412 = _396;
    _413 = _397;
  }
  bool _416 = ((uint)(cb2_028x) == 2);
  bool _417 = ((uint)(cb2_028x) == 3);
  int _418 = (uint)(cb2_028x) & -2;
  bool _419 = (_418 == 2);
  bool _420 = ((uint)(cb2_028x) == 6);
  bool _421 = _419 || _420;
  if (_421) {
    float _423 = _411 * _402;
    float _424 = _412 * _402;
    float _425 = _413 * _402;
    float _426 = _402 * _402;
    _458 = _423;
    _459 = _424;
    _460 = _425;
    _461 = _426;
  } else {
    bool _428 = ((uint)(cb2_028x) == 4);
    if (_428) {
      float _430 = _411 + -1.0f;
      float _431 = _412 + -1.0f;
      float _432 = _413 + -1.0f;
      float _433 = _402 + -1.0f;
      float _434 = _430 * _402;
      float _435 = _431 * _402;
      float _436 = _432 * _402;
      float _437 = _433 * _402;
      float _438 = _434 + 1.0f;
      float _439 = _435 + 1.0f;
      float _440 = _436 + 1.0f;
      float _441 = _437 + 1.0f;
      _458 = _438;
      _459 = _439;
      _460 = _440;
      _461 = _441;
    } else {
      bool _443 = ((uint)(cb2_028x) == 5);
      if (_443) {
        float _445 = _411 + -0.5f;
        float _446 = _412 + -0.5f;
        float _447 = _413 + -0.5f;
        float _448 = _402 + -0.5f;
        float _449 = _445 * _402;
        float _450 = _446 * _402;
        float _451 = _447 * _402;
        float _452 = _448 * _402;
        float _453 = _449 + 0.5f;
        float _454 = _450 + 0.5f;
        float _455 = _451 + 0.5f;
        float _456 = _452 + 0.5f;
        _458 = _453;
        _459 = _454;
        _460 = _455;
        _461 = _456;
      } else {
        _458 = _411;
        _459 = _412;
        _460 = _413;
        _461 = _402;
      }
    }
  }
  if (_416) {
    float _463 = _458 + _372;
    float _464 = _459 + _373;
    float _465 = _460 + _374;
    _510 = _463;
    _511 = _464;
    _512 = _465;
    _513 = cb2_025w;
  } else {
    if (_417) {
      float _468 = 1.0f - _458;
      float _469 = 1.0f - _459;
      float _470 = 1.0f - _460;
      float _471 = _468 * _372;
      float _472 = _469 * _373;
      float _473 = _470 * _374;
      float _474 = _471 + _458;
      float _475 = _472 + _459;
      float _476 = _473 + _460;
      _510 = _474;
      _511 = _475;
      _512 = _476;
      _513 = cb2_025w;
    } else {
      bool _478 = ((uint)(cb2_028x) == 4);
      if (_478) {
        float _480 = _458 * _372;
        float _481 = _459 * _373;
        float _482 = _460 * _374;
        _510 = _480;
        _511 = _481;
        _512 = _482;
        _513 = cb2_025w;
      } else {
        bool _484 = ((uint)(cb2_028x) == 5);
        if (_484) {
          float _486 = _372 * 2.0f;
          float _487 = _486 * _458;
          float _488 = _373 * 2.0f;
          float _489 = _488 * _459;
          float _490 = _374 * 2.0f;
          float _491 = _490 * _460;
          _510 = _487;
          _511 = _489;
          _512 = _491;
          _513 = cb2_025w;
        } else {
          if (_420) {
            float _494 = _372 - _458;
            float _495 = _373 - _459;
            float _496 = _374 - _460;
            _510 = _494;
            _511 = _495;
            _512 = _496;
            _513 = cb2_025w;
          } else {
            float _498 = _458 - _372;
            float _499 = _459 - _373;
            float _500 = _460 - _374;
            float _501 = _461 * _498;
            float _502 = _461 * _499;
            float _503 = _461 * _500;
            float _504 = _501 + _372;
            float _505 = _502 + _373;
            float _506 = _503 + _374;
            float _507 = 1.0f - _461;
            float _508 = _507 * cb2_025w;
            _510 = _504;
            _511 = _505;
            _512 = _506;
            _513 = _508;
          }
        }
      }
    }
  }
  float _519 = cb2_016x - _510;
  float _520 = cb2_016y - _511;
  float _521 = cb2_016z - _512;
  float _522 = _519 * cb2_016w;
  float _523 = _520 * cb2_016w;
  float _524 = _521 * cb2_016w;
  float _525 = _522 + _510;
  float _526 = _523 + _511;
  float _527 = _524 + _512;
  bool _530 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_530 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _534 = cb2_024x * _525;
    float _535 = cb2_024x * _526;
    float _536 = cb2_024x * _527;
    _538 = _534;
    _539 = _535;
    _540 = _536;
  } else {
    _538 = _525;
    _539 = _526;
    _540 = _527;
  }
  float _541 = _538 * 0.9708889722824097f;
  float _542 = mad(0.026962999254465103f, _539, _541);
  float _543 = mad(0.002148000057786703f, _540, _542);
  float _544 = _538 * 0.01088900025933981f;
  float _545 = mad(0.9869629740715027f, _539, _544);
  float _546 = mad(0.002148000057786703f, _540, _545);
  float _547 = mad(0.026962999254465103f, _539, _544);
  float _548 = mad(0.9621480107307434f, _540, _547);
  if (_530) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _553 = cb1_018y * 0.10000000149011612f;
        float _554 = log2(cb1_018z);
        float _555 = _554 + -13.287712097167969f;
        float _556 = _555 * 1.4929734468460083f;
        float _557 = _556 + 18.0f;
        float _558 = exp2(_557);
        float _559 = _558 * 0.18000000715255737f;
        float _560 = abs(_559);
        float _561 = log2(_560);
        float _562 = _561 * 1.5f;
        float _563 = exp2(_562);
        float _564 = _563 * _553;
        float _565 = _564 / cb1_018z;
        float _566 = _565 + -0.07636754959821701f;
        float _567 = _561 * 1.2750000953674316f;
        float _568 = exp2(_567);
        float _569 = _568 * 0.07636754959821701f;
        float _570 = cb1_018y * 0.011232397519052029f;
        float _571 = _570 * _563;
        float _572 = _571 / cb1_018z;
        float _573 = _569 - _572;
        float _574 = _568 + -0.11232396960258484f;
        float _575 = _574 * _553;
        float _576 = _575 / cb1_018z;
        float _577 = _576 * cb1_018z;
        float _578 = abs(_543);
        float _579 = abs(_546);
        float _580 = abs(_548);
        float _581 = log2(_578);
        float _582 = log2(_579);
        float _583 = log2(_580);
        float _584 = _581 * 1.5f;
        float _585 = _582 * 1.5f;
        float _586 = _583 * 1.5f;
        float _587 = exp2(_584);
        float _588 = exp2(_585);
        float _589 = exp2(_586);
        float _590 = _587 * _577;
        float _591 = _588 * _577;
        float _592 = _589 * _577;
        float _593 = _581 * 1.2750000953674316f;
        float _594 = _582 * 1.2750000953674316f;
        float _595 = _583 * 1.2750000953674316f;
        float _596 = exp2(_593);
        float _597 = exp2(_594);
        float _598 = exp2(_595);
        float _599 = _596 * _566;
        float _600 = _597 * _566;
        float _601 = _598 * _566;
        float _602 = _599 + _573;
        float _603 = _600 + _573;
        float _604 = _601 + _573;
        float _605 = _590 / _602;
        float _606 = _591 / _603;
        float _607 = _592 / _604;
        float _608 = _605 * 9.999999747378752e-05f;
        float _609 = _606 * 9.999999747378752e-05f;
        float _610 = _607 * 9.999999747378752e-05f;
        float _611 = 5000.0f / cb1_018y;
        float _612 = _608 * _611;
        float _613 = _609 * _611;
        float _614 = _610 * _611;
        _641 = _612;
        _642 = _613;
        _643 = _614;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_543, _546, _548));
      _641 = tonemapped.x, _642 = tonemapped.y, _643 = tonemapped.z;
    }
      } else {
        float _616 = _543 + 0.020616600289940834f;
        float _617 = _546 + 0.020616600289940834f;
        float _618 = _548 + 0.020616600289940834f;
        float _619 = _616 * _543;
        float _620 = _617 * _546;
        float _621 = _618 * _548;
        float _622 = _619 + -7.456949970219284e-05f;
        float _623 = _620 + -7.456949970219284e-05f;
        float _624 = _621 + -7.456949970219284e-05f;
        float _625 = _543 * 0.9837960004806519f;
        float _626 = _546 * 0.9837960004806519f;
        float _627 = _548 * 0.9837960004806519f;
        float _628 = _625 + 0.4336790144443512f;
        float _629 = _626 + 0.4336790144443512f;
        float _630 = _627 + 0.4336790144443512f;
        float _631 = _628 * _543;
        float _632 = _629 * _546;
        float _633 = _630 * _548;
        float _634 = _631 + 0.24617899954319f;
        float _635 = _632 + 0.24617899954319f;
        float _636 = _633 + 0.24617899954319f;
        float _637 = _622 / _634;
        float _638 = _623 / _635;
        float _639 = _624 / _636;
        _641 = _637;
        _642 = _638;
        _643 = _639;
      }
      float _644 = _641 * 1.6047500371932983f;
      float _645 = mad(-0.5310800075531006f, _642, _644);
      float _646 = mad(-0.07366999983787537f, _643, _645);
      float _647 = _641 * -0.10208000242710114f;
      float _648 = mad(1.1081299781799316f, _642, _647);
      float _649 = mad(-0.006049999967217445f, _643, _648);
      float _650 = _641 * -0.0032599999103695154f;
      float _651 = mad(-0.07275000214576721f, _642, _650);
      float _652 = mad(1.0760200023651123f, _643, _651);
      if (_530) {
        // float _654 = max(_646, 0.0f);
        // float _655 = max(_649, 0.0f);
        // float _656 = max(_652, 0.0f);
        // bool _657 = !(_654 >= 0.0030399328097701073f);
        // if (!_657) {
        //   float _659 = abs(_654);
        //   float _660 = log2(_659);
        //   float _661 = _660 * 0.4166666567325592f;
        //   float _662 = exp2(_661);
        //   float _663 = _662 * 1.0549999475479126f;
        //   float _664 = _663 + -0.054999999701976776f;
        //   _668 = _664;
        // } else {
        //   float _666 = _654 * 12.923210144042969f;
        //   _668 = _666;
        // }
        // bool _669 = !(_655 >= 0.0030399328097701073f);
        // if (!_669) {
        //   float _671 = abs(_655);
        //   float _672 = log2(_671);
        //   float _673 = _672 * 0.4166666567325592f;
        //   float _674 = exp2(_673);
        //   float _675 = _674 * 1.0549999475479126f;
        //   float _676 = _675 + -0.054999999701976776f;
        //   _680 = _676;
        // } else {
        //   float _678 = _655 * 12.923210144042969f;
        //   _680 = _678;
        // }
        // bool _681 = !(_656 >= 0.0030399328097701073f);
        // if (!_681) {
        //   float _683 = abs(_656);
        //   float _684 = log2(_683);
        //   float _685 = _684 * 0.4166666567325592f;
        //   float _686 = exp2(_685);
        //   float _687 = _686 * 1.0549999475479126f;
        //   float _688 = _687 + -0.054999999701976776f;
        //   _761 = _668;
        //   _762 = _680;
        //   _763 = _688;
        // } else {
        //   float _690 = _656 * 12.923210144042969f;
        //   _761 = _668;
        //   _762 = _680;
        //   _763 = _690;
        // }
        _761 = renodx::color::srgb::EncodeSafe(_646);
        _762 = renodx::color::srgb::EncodeSafe(_649);
        _763 = renodx::color::srgb::EncodeSafe(_652);

      } else {
        float _692 = saturate(_646);
        float _693 = saturate(_649);
        float _694 = saturate(_652);
        bool _695 = ((uint)(cb1_018w) == -2);
        if (!_695) {
          bool _697 = !(_692 >= 0.0030399328097701073f);
          if (!_697) {
            float _699 = abs(_692);
            float _700 = log2(_699);
            float _701 = _700 * 0.4166666567325592f;
            float _702 = exp2(_701);
            float _703 = _702 * 1.0549999475479126f;
            float _704 = _703 + -0.054999999701976776f;
            _708 = _704;
          } else {
            float _706 = _692 * 12.923210144042969f;
            _708 = _706;
          }
          bool _709 = !(_693 >= 0.0030399328097701073f);
          if (!_709) {
            float _711 = abs(_693);
            float _712 = log2(_711);
            float _713 = _712 * 0.4166666567325592f;
            float _714 = exp2(_713);
            float _715 = _714 * 1.0549999475479126f;
            float _716 = _715 + -0.054999999701976776f;
            _720 = _716;
          } else {
            float _718 = _693 * 12.923210144042969f;
            _720 = _718;
          }
          bool _721 = !(_694 >= 0.0030399328097701073f);
          if (!_721) {
            float _723 = abs(_694);
            float _724 = log2(_723);
            float _725 = _724 * 0.4166666567325592f;
            float _726 = exp2(_725);
            float _727 = _726 * 1.0549999475479126f;
            float _728 = _727 + -0.054999999701976776f;
            _732 = _708;
            _733 = _720;
            _734 = _728;
          } else {
            float _730 = _694 * 12.923210144042969f;
            _732 = _708;
            _733 = _720;
            _734 = _730;
          }
        } else {
          _732 = _692;
          _733 = _693;
          _734 = _694;
        }
        float _739 = abs(_732);
        float _740 = abs(_733);
        float _741 = abs(_734);
        float _742 = log2(_739);
        float _743 = log2(_740);
        float _744 = log2(_741);
        float _745 = _742 * cb2_000z;
        float _746 = _743 * cb2_000z;
        float _747 = _744 * cb2_000z;
        float _748 = exp2(_745);
        float _749 = exp2(_746);
        float _750 = exp2(_747);
        float _751 = _748 * cb2_000y;
        float _752 = _749 * cb2_000y;
        float _753 = _750 * cb2_000y;
        float _754 = _751 + cb2_000x;
        float _755 = _752 + cb2_000x;
        float _756 = _753 + cb2_000x;
        float _757 = saturate(_754);
        float _758 = saturate(_755);
        float _759 = saturate(_756);
        _761 = _757;
        _762 = _758;
        _763 = _759;
      }
      float _767 = cb2_023x * TEXCOORD0_centroid.x;
      float _768 = cb2_023y * TEXCOORD0_centroid.y;
      float _771 = _767 + cb2_023z;
      float _772 = _768 + cb2_023w;
      float4 _775 = t10.SampleLevel(s0_space2, float2(_771, _772), 0.0f);
      float _777 = _775.x + -0.5f;
      float _778 = _777 * cb2_022x;
      float _779 = _778 + 0.5f;
      float _780 = _779 * 2.0f;
      float _781 = _780 * _761;
      float _782 = _780 * _762;
      float _783 = _780 * _763;
      float _787 = float((uint)(cb2_019z));
      float _788 = float((uint)(cb2_019w));
      float _789 = _787 + SV_Position.x;
      float _790 = _788 + SV_Position.y;
      uint _791 = uint(_789);
      uint _792 = uint(_790);
      uint _795 = cb2_019x + -1u;
      uint _796 = cb2_019y + -1u;
      int _797 = _791 & _795;
      int _798 = _792 & _796;
      float4 _799 = t3.Load(int3(_797, _798, 0));
      float _803 = _799.x * 2.0f;
      float _804 = _799.y * 2.0f;
      float _805 = _799.z * 2.0f;
      float _806 = _803 + -1.0f;
      float _807 = _804 + -1.0f;
      float _808 = _805 + -1.0f;
      float _809 = _806 * _513;
      float _810 = _807 * _513;
      float _811 = _808 * _513;
      float _812 = _809 + _781;
      float _813 = _810 + _782;
      float _814 = _811 + _783;
      float _815 = dot(float3(_812, _813, _814), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _812;
      SV_Target.y = _813;
      SV_Target.z = _814;
      SV_Target.w = _815;
      SV_Target_1.x = _815;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
