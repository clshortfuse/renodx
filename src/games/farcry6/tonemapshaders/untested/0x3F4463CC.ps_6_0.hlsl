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

Texture2D<float4> t8 : register(t8);

Texture3D<float2> t9 : register(t9);

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
  float _21 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _23 = t8.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _27 = _23.x * 6.283199787139893f;
  float _28 = cos(_27);
  float _29 = sin(_27);
  float _30 = _28 * _23.z;
  float _31 = _29 * _23.z;
  float _32 = _30 + TEXCOORD0_centroid.x;
  float _33 = _31 + TEXCOORD0_centroid.y;
  float _34 = _32 * 10.0f;
  float _35 = 10.0f - _34;
  float _36 = min(_34, _35);
  float _37 = saturate(_36);
  float _38 = _37 * _30;
  float _39 = _33 * 10.0f;
  float _40 = 10.0f - _39;
  float _41 = min(_39, _40);
  float _42 = saturate(_41);
  float _43 = _42 * _31;
  float _44 = _38 + TEXCOORD0_centroid.x;
  float _45 = _43 + TEXCOORD0_centroid.y;
  float4 _46 = t8.SampleLevel(s2_space2, float2(_44, _45), 0.0f);
  float _48 = _46.w * _38;
  float _49 = _46.w * _43;
  float _50 = 1.0f - _23.y;
  float _51 = saturate(_50);
  float _52 = _48 * _51;
  float _53 = _49 * _51;
  float _54 = _52 + TEXCOORD0_centroid.x;
  float _55 = _53 + TEXCOORD0_centroid.y;
  float4 _56 = t8.SampleLevel(s2_space2, float2(_54, _55), 0.0f);
  bool _58 = (_56.y > 0.0f);
  float _59 = select(_58, TEXCOORD0_centroid.x, _54);
  float _60 = select(_58, TEXCOORD0_centroid.y, _55);
  float4 _61 = t1.SampleLevel(s4_space2, float2(_59, _60), 0.0f);
  float _65 = max(_61.x, 0.0f);
  float _66 = max(_61.y, 0.0f);
  float _67 = max(_61.z, 0.0f);
  float _68 = min(_65, 65000.0f);
  float _69 = min(_66, 65000.0f);
  float _70 = min(_67, 65000.0f);
  float4 _71 = t3.SampleLevel(s2_space2, float2(_59, _60), 0.0f);
  float _76 = max(_71.x, 0.0f);
  float _77 = max(_71.y, 0.0f);
  float _78 = max(_71.z, 0.0f);
  float _79 = max(_71.w, 0.0f);
  float _80 = min(_76, 5000.0f);
  float _81 = min(_77, 5000.0f);
  float _82 = min(_78, 5000.0f);
  float _83 = min(_79, 5000.0f);
  float _86 = _21.x * cb0_028z;
  float _87 = _86 + cb0_028x;
  float _88 = cb2_027w / _87;
  float _89 = 1.0f - _88;
  float _90 = abs(_89);
  float _92 = cb2_027y * _90;
  float _94 = _92 - cb2_027z;
  float _95 = saturate(_94);
  float _96 = max(_95, _83);
  float _97 = saturate(_96);
  float _101 = cb2_006x * _59;
  float _102 = cb2_006y * _60;
  float _105 = _101 + cb2_006z;
  float _106 = _102 + cb2_006w;
  float _110 = cb2_007x * _59;
  float _111 = cb2_007y * _60;
  float _114 = _110 + cb2_007z;
  float _115 = _111 + cb2_007w;
  float _119 = cb2_008x * _59;
  float _120 = cb2_008y * _60;
  float _123 = _119 + cb2_008z;
  float _124 = _120 + cb2_008w;
  float4 _125 = t1.SampleLevel(s2_space2, float2(_105, _106), 0.0f);
  float _127 = max(_125.x, 0.0f);
  float _128 = min(_127, 65000.0f);
  float4 _129 = t1.SampleLevel(s2_space2, float2(_114, _115), 0.0f);
  float _131 = max(_129.y, 0.0f);
  float _132 = min(_131, 65000.0f);
  float4 _133 = t1.SampleLevel(s2_space2, float2(_123, _124), 0.0f);
  float _135 = max(_133.z, 0.0f);
  float _136 = min(_135, 65000.0f);
  float4 _137 = t3.SampleLevel(s2_space2, float2(_105, _106), 0.0f);
  float _139 = max(_137.x, 0.0f);
  float _140 = min(_139, 5000.0f);
  float4 _141 = t3.SampleLevel(s2_space2, float2(_114, _115), 0.0f);
  float _143 = max(_141.y, 0.0f);
  float _144 = min(_143, 5000.0f);
  float4 _145 = t3.SampleLevel(s2_space2, float2(_123, _124), 0.0f);
  float _147 = max(_145.z, 0.0f);
  float _148 = min(_147, 5000.0f);
  float4 _149 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _155 = cb2_005x * _149.x;
  float _156 = cb2_005x * _149.y;
  float _157 = cb2_005x * _149.z;
  float _158 = _128 - _68;
  float _159 = _132 - _69;
  float _160 = _136 - _70;
  float _161 = _155 * _158;
  float _162 = _156 * _159;
  float _163 = _157 * _160;
  float _164 = _161 + _68;
  float _165 = _162 + _69;
  float _166 = _163 + _70;
  float _167 = _140 - _80;
  float _168 = _144 - _81;
  float _169 = _148 - _82;
  float _170 = _155 * _167;
  float _171 = _156 * _168;
  float _172 = _157 * _169;
  float _173 = _170 + _80;
  float _174 = _171 + _81;
  float _175 = _172 + _82;
  float4 _176 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _180 = _173 - _164;
  float _181 = _174 - _165;
  float _182 = _175 - _166;
  float _183 = _180 * _97;
  float _184 = _181 * _97;
  float _185 = _182 * _97;
  float _186 = _183 + _164;
  float _187 = _184 + _165;
  float _188 = _185 + _166;
  float _189 = dot(float3(_186, _187, _188), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _193 = t0[0].SExposureData_020;
  float _195 = t0[0].SExposureData_004;
  float _197 = cb2_018x * 0.5f;
  float _198 = _197 * cb2_018y;
  float _199 = _195.x - _198;
  float _200 = cb2_018y * cb2_018x;
  float _201 = 1.0f / _200;
  float _202 = _199 * _201;
  float _203 = _189 / _193.x;
  float _204 = _203 * 5464.01611328125f;
  float _205 = _204 + 9.99999993922529e-09f;
  float _206 = log2(_205);
  float _207 = _206 - _199;
  float _208 = _207 * _201;
  float _209 = saturate(_208);
  float2 _210 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _209), 0.0f);
  float _213 = max(_210.y, 1.0000000116860974e-07f);
  float _214 = _210.x / _213;
  float _215 = _214 + _202;
  float _216 = _215 / _201;
  float _217 = _216 - _195.x;
  float _218 = -0.0f - _217;
  float _220 = _218 - cb2_027x;
  float _221 = max(0.0f, _220);
  float _224 = cb2_026z * _221;
  float _225 = _217 - cb2_027x;
  float _226 = max(0.0f, _225);
  float _228 = cb2_026w * _226;
  bool _229 = (_217 < 0.0f);
  float _230 = select(_229, _224, _228);
  float _231 = exp2(_230);
  float _232 = _231 * _186;
  float _233 = _231 * _187;
  float _234 = _231 * _188;
  float _239 = cb2_024y * _176.x;
  float _240 = cb2_024z * _176.y;
  float _241 = cb2_024w * _176.z;
  float _242 = _239 + _232;
  float _243 = _240 + _233;
  float _244 = _241 + _234;
  float _249 = _242 * cb2_025x;
  float _250 = _243 * cb2_025y;
  float _251 = _244 * cb2_025z;
  float _252 = dot(float3(_249, _250, _251), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _253 = t0[0].SExposureData_012;
  float _255 = _252 * 5464.01611328125f;
  float _256 = _255 * _253.x;
  float _257 = _256 + 9.99999993922529e-09f;
  float _258 = log2(_257);
  float _259 = _258 + 16.929765701293945f;
  float _260 = _259 * 0.05734497308731079f;
  float _261 = saturate(_260);
  float _262 = _261 * _261;
  float _263 = _261 * 2.0f;
  float _264 = 3.0f - _263;
  float _265 = _262 * _264;
  float _266 = _250 * 0.8450999855995178f;
  float _267 = _251 * 0.14589999616146088f;
  float _268 = _266 + _267;
  float _269 = _268 * 2.4890189170837402f;
  float _270 = _268 * 0.3754962384700775f;
  float _271 = _268 * 2.811495304107666f;
  float _272 = _268 * 5.519708156585693f;
  float _273 = _252 - _269;
  float _274 = _265 * _273;
  float _275 = _274 + _269;
  float _276 = _265 * 0.5f;
  float _277 = _276 + 0.5f;
  float _278 = _277 * _273;
  float _279 = _278 + _269;
  float _280 = _249 - _270;
  float _281 = _250 - _271;
  float _282 = _251 - _272;
  float _283 = _277 * _280;
  float _284 = _277 * _281;
  float _285 = _277 * _282;
  float _286 = _283 + _270;
  float _287 = _284 + _271;
  float _288 = _285 + _272;
  float _289 = 1.0f / _279;
  float _290 = _275 * _289;
  float _291 = _290 * _286;
  float _292 = _290 * _287;
  float _293 = _290 * _288;
  float _297 = cb2_020x * TEXCOORD0_centroid.x;
  float _298 = cb2_020y * TEXCOORD0_centroid.y;
  float _301 = _297 + cb2_020z;
  float _302 = _298 + cb2_020w;
  float _305 = dot(float2(_301, _302), float2(_301, _302));
  float _306 = 1.0f - _305;
  float _307 = saturate(_306);
  float _308 = log2(_307);
  float _309 = _308 * cb2_021w;
  float _310 = exp2(_309);
  float _314 = _291 - cb2_021x;
  float _315 = _292 - cb2_021y;
  float _316 = _293 - cb2_021z;
  float _317 = _314 * _310;
  float _318 = _315 * _310;
  float _319 = _316 * _310;
  float _320 = _317 + cb2_021x;
  float _321 = _318 + cb2_021y;
  float _322 = _319 + cb2_021z;
  float _323 = t0[0].SExposureData_000;
  float _325 = max(_193.x, 0.0010000000474974513f);
  float _326 = 1.0f / _325;
  float _327 = _326 * _323.x;
  bool _330 = ((uint)(cb2_069y) == 0);
  float _336;
  float _337;
  float _338;
  float _392;
  float _393;
  float _394;
  float _439;
  float _440;
  float _441;
  float _486;
  float _487;
  float _488;
  float _489;
  float _536;
  float _537;
  float _538;
  float _563;
  float _564;
  float _565;
  float _666;
  float _667;
  float _668;
  float _693;
  float _705;
  float _733;
  float _745;
  float _757;
  float _758;
  float _759;
  float _786;
  float _787;
  float _788;
  if (!_330) {
    float _332 = _327 * _320;
    float _333 = _327 * _321;
    float _334 = _327 * _322;
    _336 = _332;
    _337 = _333;
    _338 = _334;
  } else {
    _336 = _320;
    _337 = _321;
    _338 = _322;
  }
  float _339 = _336 * 0.6130970120429993f;
  float _340 = mad(0.33952298760414124f, _337, _339);
  float _341 = mad(0.04737899824976921f, _338, _340);
  float _342 = _336 * 0.07019399851560593f;
  float _343 = mad(0.9163540005683899f, _337, _342);
  float _344 = mad(0.013451999984681606f, _338, _343);
  float _345 = _336 * 0.02061600051820278f;
  float _346 = mad(0.10956999659538269f, _337, _345);
  float _347 = mad(0.8698149919509888f, _338, _346);
  float _348 = log2(_341);
  float _349 = log2(_344);
  float _350 = log2(_347);
  float _351 = _348 * 0.04211956635117531f;
  float _352 = _349 * 0.04211956635117531f;
  float _353 = _350 * 0.04211956635117531f;
  float _354 = _351 + 0.6252607107162476f;
  float _355 = _352 + 0.6252607107162476f;
  float _356 = _353 + 0.6252607107162476f;
  float4 _357 = t5.SampleLevel(s2_space2, float3(_354, _355, _356), 0.0f);
  bool _363 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_363 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _367 = cb2_017x * _357.x;
    float _368 = cb2_017x * _357.y;
    float _369 = cb2_017x * _357.z;
    float _371 = _367 + cb2_017y;
    float _372 = _368 + cb2_017y;
    float _373 = _369 + cb2_017y;
    float _374 = exp2(_371);
    float _375 = exp2(_372);
    float _376 = exp2(_373);
    float _377 = _374 + 1.0f;
    float _378 = _375 + 1.0f;
    float _379 = _376 + 1.0f;
    float _380 = 1.0f / _377;
    float _381 = 1.0f / _378;
    float _382 = 1.0f / _379;
    float _384 = cb2_017z * _380;
    float _385 = cb2_017z * _381;
    float _386 = cb2_017z * _382;
    float _388 = _384 + cb2_017w;
    float _389 = _385 + cb2_017w;
    float _390 = _386 + cb2_017w;
    _392 = _388;
    _393 = _389;
    _394 = _390;
  } else {
    _392 = _357.x;
    _393 = _357.y;
    _394 = _357.z;
  }
  float _395 = _392 * 23.0f;
  float _396 = _395 + -14.473931312561035f;
  float _397 = exp2(_396);
  float _398 = _393 * 23.0f;
  float _399 = _398 + -14.473931312561035f;
  float _400 = exp2(_399);
  float _401 = _394 * 23.0f;
  float _402 = _401 + -14.473931312561035f;
  float _403 = exp2(_402);
  float _407 = cb2_004x * TEXCOORD0_centroid.x;
  float _408 = cb2_004y * TEXCOORD0_centroid.y;
  float _411 = _407 + cb2_004z;
  float _412 = _408 + cb2_004w;
  float4 _418 = t7.Sample(s2_space2, float2(_411, _412));
  float _423 = _418.x * cb2_003x;
  float _424 = _418.y * cb2_003y;
  float _425 = _418.z * cb2_003z;
  float _426 = _418.w * cb2_003w;
  float _429 = _426 + cb2_026y;
  float _430 = saturate(_429);
  bool _433 = ((uint)(cb2_069y) == 0);
  if (!_433) {
    float _435 = _423 * _327;
    float _436 = _424 * _327;
    float _437 = _425 * _327;
    _439 = _435;
    _440 = _436;
    _441 = _437;
  } else {
    _439 = _423;
    _440 = _424;
    _441 = _425;
  }
  bool _444 = ((uint)(cb2_028x) == 2);
  bool _445 = ((uint)(cb2_028x) == 3);
  int _446 = (uint)(cb2_028x) & -2;
  bool _447 = (_446 == 2);
  bool _448 = ((uint)(cb2_028x) == 6);
  bool _449 = _447 || _448;
  if (_449) {
    float _451 = _439 * _430;
    float _452 = _440 * _430;
    float _453 = _441 * _430;
    float _454 = _430 * _430;
    _486 = _451;
    _487 = _452;
    _488 = _453;
    _489 = _454;
  } else {
    bool _456 = ((uint)(cb2_028x) == 4);
    if (_456) {
      float _458 = _439 + -1.0f;
      float _459 = _440 + -1.0f;
      float _460 = _441 + -1.0f;
      float _461 = _430 + -1.0f;
      float _462 = _458 * _430;
      float _463 = _459 * _430;
      float _464 = _460 * _430;
      float _465 = _461 * _430;
      float _466 = _462 + 1.0f;
      float _467 = _463 + 1.0f;
      float _468 = _464 + 1.0f;
      float _469 = _465 + 1.0f;
      _486 = _466;
      _487 = _467;
      _488 = _468;
      _489 = _469;
    } else {
      bool _471 = ((uint)(cb2_028x) == 5);
      if (_471) {
        float _473 = _439 + -0.5f;
        float _474 = _440 + -0.5f;
        float _475 = _441 + -0.5f;
        float _476 = _430 + -0.5f;
        float _477 = _473 * _430;
        float _478 = _474 * _430;
        float _479 = _475 * _430;
        float _480 = _476 * _430;
        float _481 = _477 + 0.5f;
        float _482 = _478 + 0.5f;
        float _483 = _479 + 0.5f;
        float _484 = _480 + 0.5f;
        _486 = _481;
        _487 = _482;
        _488 = _483;
        _489 = _484;
      } else {
        _486 = _439;
        _487 = _440;
        _488 = _441;
        _489 = _430;
      }
    }
  }
  if (_444) {
    float _491 = _486 + _397;
    float _492 = _487 + _400;
    float _493 = _488 + _403;
    _536 = _491;
    _537 = _492;
    _538 = _493;
  } else {
    if (_445) {
      float _496 = 1.0f - _486;
      float _497 = 1.0f - _487;
      float _498 = 1.0f - _488;
      float _499 = _496 * _397;
      float _500 = _497 * _400;
      float _501 = _498 * _403;
      float _502 = _499 + _486;
      float _503 = _500 + _487;
      float _504 = _501 + _488;
      _536 = _502;
      _537 = _503;
      _538 = _504;
    } else {
      bool _506 = ((uint)(cb2_028x) == 4);
      if (_506) {
        float _508 = _486 * _397;
        float _509 = _487 * _400;
        float _510 = _488 * _403;
        _536 = _508;
        _537 = _509;
        _538 = _510;
      } else {
        bool _512 = ((uint)(cb2_028x) == 5);
        if (_512) {
          float _514 = _397 * 2.0f;
          float _515 = _514 * _486;
          float _516 = _400 * 2.0f;
          float _517 = _516 * _487;
          float _518 = _403 * 2.0f;
          float _519 = _518 * _488;
          _536 = _515;
          _537 = _517;
          _538 = _519;
        } else {
          if (_448) {
            float _522 = _397 - _486;
            float _523 = _400 - _487;
            float _524 = _403 - _488;
            _536 = _522;
            _537 = _523;
            _538 = _524;
          } else {
            float _526 = _486 - _397;
            float _527 = _487 - _400;
            float _528 = _488 - _403;
            float _529 = _489 * _526;
            float _530 = _489 * _527;
            float _531 = _489 * _528;
            float _532 = _529 + _397;
            float _533 = _530 + _400;
            float _534 = _531 + _403;
            _536 = _532;
            _537 = _533;
            _538 = _534;
          }
        }
      }
    }
  }
  float _544 = cb2_016x - _536;
  float _545 = cb2_016y - _537;
  float _546 = cb2_016z - _538;
  float _547 = _544 * cb2_016w;
  float _548 = _545 * cb2_016w;
  float _549 = _546 * cb2_016w;
  float _550 = _547 + _536;
  float _551 = _548 + _537;
  float _552 = _549 + _538;
  bool _555 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_555 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _559 = cb2_024x * _550;
    float _560 = cb2_024x * _551;
    float _561 = cb2_024x * _552;
    _563 = _559;
    _564 = _560;
    _565 = _561;
  } else {
    _563 = _550;
    _564 = _551;
    _565 = _552;
  }
  float _566 = _563 * 0.9708889722824097f;
  float _567 = mad(0.026962999254465103f, _564, _566);
  float _568 = mad(0.002148000057786703f, _565, _567);
  float _569 = _563 * 0.01088900025933981f;
  float _570 = mad(0.9869629740715027f, _564, _569);
  float _571 = mad(0.002148000057786703f, _565, _570);
  float _572 = mad(0.026962999254465103f, _564, _569);
  float _573 = mad(0.9621480107307434f, _565, _572);
  if (_555) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _578 = cb1_018y * 0.10000000149011612f;
        float _579 = log2(cb1_018z);
        float _580 = _579 + -13.287712097167969f;
        float _581 = _580 * 1.4929734468460083f;
        float _582 = _581 + 18.0f;
        float _583 = exp2(_582);
        float _584 = _583 * 0.18000000715255737f;
        float _585 = abs(_584);
        float _586 = log2(_585);
        float _587 = _586 * 1.5f;
        float _588 = exp2(_587);
        float _589 = _588 * _578;
        float _590 = _589 / cb1_018z;
        float _591 = _590 + -0.07636754959821701f;
        float _592 = _586 * 1.2750000953674316f;
        float _593 = exp2(_592);
        float _594 = _593 * 0.07636754959821701f;
        float _595 = cb1_018y * 0.011232397519052029f;
        float _596 = _595 * _588;
        float _597 = _596 / cb1_018z;
        float _598 = _594 - _597;
        float _599 = _593 + -0.11232396960258484f;
        float _600 = _599 * _578;
        float _601 = _600 / cb1_018z;
        float _602 = _601 * cb1_018z;
        float _603 = abs(_568);
        float _604 = abs(_571);
        float _605 = abs(_573);
        float _606 = log2(_603);
        float _607 = log2(_604);
        float _608 = log2(_605);
        float _609 = _606 * 1.5f;
        float _610 = _607 * 1.5f;
        float _611 = _608 * 1.5f;
        float _612 = exp2(_609);
        float _613 = exp2(_610);
        float _614 = exp2(_611);
        float _615 = _612 * _602;
        float _616 = _613 * _602;
        float _617 = _614 * _602;
        float _618 = _606 * 1.2750000953674316f;
        float _619 = _607 * 1.2750000953674316f;
        float _620 = _608 * 1.2750000953674316f;
        float _621 = exp2(_618);
        float _622 = exp2(_619);
        float _623 = exp2(_620);
        float _624 = _621 * _591;
        float _625 = _622 * _591;
        float _626 = _623 * _591;
        float _627 = _624 + _598;
        float _628 = _625 + _598;
        float _629 = _626 + _598;
        float _630 = _615 / _627;
        float _631 = _616 / _628;
        float _632 = _617 / _629;
        float _633 = _630 * 9.999999747378752e-05f;
        float _634 = _631 * 9.999999747378752e-05f;
        float _635 = _632 * 9.999999747378752e-05f;
        float _636 = 5000.0f / cb1_018y;
        float _637 = _633 * _636;
        float _638 = _634 * _636;
        float _639 = _635 * _636;
        _666 = _637;
        _667 = _638;
        _668 = _639;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_568, _571, _573));
      _666 = tonemapped.x, _667 = tonemapped.y, _668 = tonemapped.z;
    }
      } else {
        float _641 = _568 + 0.020616600289940834f;
        float _642 = _571 + 0.020616600289940834f;
        float _643 = _573 + 0.020616600289940834f;
        float _644 = _641 * _568;
        float _645 = _642 * _571;
        float _646 = _643 * _573;
        float _647 = _644 + -7.456949970219284e-05f;
        float _648 = _645 + -7.456949970219284e-05f;
        float _649 = _646 + -7.456949970219284e-05f;
        float _650 = _568 * 0.9837960004806519f;
        float _651 = _571 * 0.9837960004806519f;
        float _652 = _573 * 0.9837960004806519f;
        float _653 = _650 + 0.4336790144443512f;
        float _654 = _651 + 0.4336790144443512f;
        float _655 = _652 + 0.4336790144443512f;
        float _656 = _653 * _568;
        float _657 = _654 * _571;
        float _658 = _655 * _573;
        float _659 = _656 + 0.24617899954319f;
        float _660 = _657 + 0.24617899954319f;
        float _661 = _658 + 0.24617899954319f;
        float _662 = _647 / _659;
        float _663 = _648 / _660;
        float _664 = _649 / _661;
        _666 = _662;
        _667 = _663;
        _668 = _664;
      }
      float _669 = _666 * 1.6047500371932983f;
      float _670 = mad(-0.5310800075531006f, _667, _669);
      float _671 = mad(-0.07366999983787537f, _668, _670);
      float _672 = _666 * -0.10208000242710114f;
      float _673 = mad(1.1081299781799316f, _667, _672);
      float _674 = mad(-0.006049999967217445f, _668, _673);
      float _675 = _666 * -0.0032599999103695154f;
      float _676 = mad(-0.07275000214576721f, _667, _675);
      float _677 = mad(1.0760200023651123f, _668, _676);
      if (_555) {
        // float _679 = max(_671, 0.0f);
        // float _680 = max(_674, 0.0f);
        // float _681 = max(_677, 0.0f);
        // bool _682 = !(_679 >= 0.0030399328097701073f);
        // if (!_682) {
        //   float _684 = abs(_679);
        //   float _685 = log2(_684);
        //   float _686 = _685 * 0.4166666567325592f;
        //   float _687 = exp2(_686);
        //   float _688 = _687 * 1.0549999475479126f;
        //   float _689 = _688 + -0.054999999701976776f;
        //   _693 = _689;
        // } else {
        //   float _691 = _679 * 12.923210144042969f;
        //   _693 = _691;
        // }
        // bool _694 = !(_680 >= 0.0030399328097701073f);
        // if (!_694) {
        //   float _696 = abs(_680);
        //   float _697 = log2(_696);
        //   float _698 = _697 * 0.4166666567325592f;
        //   float _699 = exp2(_698);
        //   float _700 = _699 * 1.0549999475479126f;
        //   float _701 = _700 + -0.054999999701976776f;
        //   _705 = _701;
        // } else {
        //   float _703 = _680 * 12.923210144042969f;
        //   _705 = _703;
        // }
        // bool _706 = !(_681 >= 0.0030399328097701073f);
        // if (!_706) {
        //   float _708 = abs(_681);
        //   float _709 = log2(_708);
        //   float _710 = _709 * 0.4166666567325592f;
        //   float _711 = exp2(_710);
        //   float _712 = _711 * 1.0549999475479126f;
        //   float _713 = _712 + -0.054999999701976776f;
        //   _786 = _693;
        //   _787 = _705;
        //   _788 = _713;
        // } else {
        //   float _715 = _681 * 12.923210144042969f;
        //   _786 = _693;
        //   _787 = _705;
        //   _788 = _715;
        // }
        _786 = renodx::color::srgb::EncodeSafe(_671);
        _787 = renodx::color::srgb::EncodeSafe(_674);
        _788 = renodx::color::srgb::EncodeSafe(_677);

      } else {
        float _717 = saturate(_671);
        float _718 = saturate(_674);
        float _719 = saturate(_677);
        bool _720 = ((uint)(cb1_018w) == -2);
        if (!_720) {
          bool _722 = !(_717 >= 0.0030399328097701073f);
          if (!_722) {
            float _724 = abs(_717);
            float _725 = log2(_724);
            float _726 = _725 * 0.4166666567325592f;
            float _727 = exp2(_726);
            float _728 = _727 * 1.0549999475479126f;
            float _729 = _728 + -0.054999999701976776f;
            _733 = _729;
          } else {
            float _731 = _717 * 12.923210144042969f;
            _733 = _731;
          }
          bool _734 = !(_718 >= 0.0030399328097701073f);
          if (!_734) {
            float _736 = abs(_718);
            float _737 = log2(_736);
            float _738 = _737 * 0.4166666567325592f;
            float _739 = exp2(_738);
            float _740 = _739 * 1.0549999475479126f;
            float _741 = _740 + -0.054999999701976776f;
            _745 = _741;
          } else {
            float _743 = _718 * 12.923210144042969f;
            _745 = _743;
          }
          bool _746 = !(_719 >= 0.0030399328097701073f);
          if (!_746) {
            float _748 = abs(_719);
            float _749 = log2(_748);
            float _750 = _749 * 0.4166666567325592f;
            float _751 = exp2(_750);
            float _752 = _751 * 1.0549999475479126f;
            float _753 = _752 + -0.054999999701976776f;
            _757 = _733;
            _758 = _745;
            _759 = _753;
          } else {
            float _755 = _719 * 12.923210144042969f;
            _757 = _733;
            _758 = _745;
            _759 = _755;
          }
        } else {
          _757 = _717;
          _758 = _718;
          _759 = _719;
        }
        float _764 = abs(_757);
        float _765 = abs(_758);
        float _766 = abs(_759);
        float _767 = log2(_764);
        float _768 = log2(_765);
        float _769 = log2(_766);
        float _770 = _767 * cb2_000z;
        float _771 = _768 * cb2_000z;
        float _772 = _769 * cb2_000z;
        float _773 = exp2(_770);
        float _774 = exp2(_771);
        float _775 = exp2(_772);
        float _776 = _773 * cb2_000y;
        float _777 = _774 * cb2_000y;
        float _778 = _775 * cb2_000y;
        float _779 = _776 + cb2_000x;
        float _780 = _777 + cb2_000x;
        float _781 = _778 + cb2_000x;
        float _782 = saturate(_779);
        float _783 = saturate(_780);
        float _784 = saturate(_781);
        _786 = _782;
        _787 = _783;
        _788 = _784;
      }
      float _789 = dot(float3(_786, _787, _788), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _786;
      SV_Target.y = _787;
      SV_Target.z = _788;
      SV_Target.w = _789;
      SV_Target_1.x = _789;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
