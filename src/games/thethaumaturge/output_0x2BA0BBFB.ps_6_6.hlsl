#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
struct _t2 {
  float data[4];
};
StructuredBuffer<_t2> t2 : register(t2);
Texture2D<float3> t3 : register(t3);
struct _t4 {
  float data[4];
};
StructuredBuffer<_t4> t4 : register(t4);
Texture2D<float4> t5 : register(t5);
Texture3D<float4> t6 : register(t6);

cbuffer _cb0 : register(b0) {
  float4 cb0[47] : packoffset(c0);
};
cbuffer _cb1 : register(b1) {
  float4 cb1[331] : packoffset(c0);
};

SamplerState s0 : register(s0);
SamplerState s1 : register(s1);
SamplerState s2 : register(s2);
SamplerState s3 : register(s3);
SamplerState s4 : register(s4);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  // texture _1 = t6;
  // texture _2 = t5;
  // texture _3 = t4;
  // texture _4 = t3;
  // texture _5 = t2;
  // texture _6 = t1;
  // texture _7 = t0;
  // SamplerState _8 = s4;
  // SamplerState _9 = s3;
  // SamplerState _10 = s2;
  // SamplerState _11 = s1;
  // SamplerState _12 = s0;
  // cbuffer _13 = cb1; // index=1
  // cbuffer _14 = cb0; // index=0
  // _15 = _13;
  // _16 = _14;
  float _17 = TEXCOORD_3.x;
  float _18 = TEXCOORD_3.y;
  float _19 = TEXCOORD_2.z;
  float _20 = TEXCOORD_2.w;
  float _21 = TEXCOORD_1.x;
  float _22 = TEXCOORD_1.z;
  float _23 = TEXCOORD_1.w;
  float _24 = TEXCOORD.x;
  float _25 = TEXCOORD.y;
  float4 _26 = cb0[42u];
  float _27 = _26.x;
  float _28 = _26.y;
  float _29 = _26.z;
  float4 _30 = cb0[44u];
  float _31 = _30.x;
  float _32 = _30.y;
  float _33 = _30.z;
  float _34 = _30.w;
  float _35 = _33 * _17;
  float _36 = _34 * _18;
  float _37 = _35 + _31;
  float _38 = _36 + _32;
  bool _39 = (_37 > 0.0f);
  bool _40 = (_38 > 0.0f);
  bool _41 = (_37 < 0.0f);
  bool _42 = (_38 < 0.0f);
  int _43 = int(_39);
  int _44 = int(_40);
  int _45 = int(_41);
  int _46 = int(_42);
  int _47 = _43 - _45;
  int _48 = _44 - _46;
  float _49 = float(_47);
  float _50 = float(_48);
  float _51 = abs(_37);
  float _52 = abs(_38);
  float _53 = _51 - _29;
  float _54 = _52 - _29;
  float _55 = saturate(_53);
  float _56 = saturate(_54);
  float _57 = _55 * _27;
  float _58 = _57 * _49;
  float _59 = _56 * _27;
  float _60 = _59 * _50;
  float _61 = _55 * _28;
  float _62 = _61 * _49;
  float _63 = _56 * _28;
  float _64 = _63 * _50;
  float _65 = _37 - _58;
  float _66 = _38 - _60;
  float _67 = _37 - _62;
  float _68 = _38 - _64;
  float4 _69 = cb0[45u];
  float _70 = _69.x;
  float _71 = _69.y;
  float _72 = _69.z;
  float _73 = _69.w;
  float _74 = _65 * _72;
  float _75 = _66 * _73;
  float _76 = _74 + _70;
  float _77 = _75 + _71;
  float _78 = _67 * _72;
  float _79 = _68 * _73;
  float _80 = _78 + _70;
  float _81 = _79 + _71;
  float4 _82 = cb0[9u];
  float _83 = _82.z;
  float _84 = _82.w;
  float4 _85 = cb0[10u];
  float _86 = _85.x;
  float _87 = _85.y;
  float _88 = _76 * _86;
  float _89 = _77 * _87;
  float _90 = _85.z;
  float _91 = _85.w;
  float _92 = _88 + _90;
  float _93 = _89 + _91;
  float _94 = _92 * _83;
  float _95 = _93 * _84;
  float _96 = _86 * _80;
  float _97 = _87 * _81;
  float _98 = _96 + _90;
  float _99 = _97 + _91;
  float _100 = _98 * _83;
  float _101 = _99 * _84;
  float4 _102 = cb0[15u];
  float _103 = _102.z;
  float _104 = _102.w;
  float _105 = _102.x;
  float _106 = _102.y;
  float _107 = max(_94, _105);
  float _108 = max(_95, _106);
  float _109 = min(_107, _103);
  float _110 = min(_108, _104);
  // _111 = _7;
  // _112 = _12;
  float4 _113 = t0.Sample(s0, float2(_109, _110));
  float _114 = _113.x;
  float4 _115 = cb0[15u];
  float _116 = _115.z;
  float _117 = _115.w;
  float _118 = _115.x;
  float _119 = _115.y;
  float _120 = max(_100, _118);
  float _121 = max(_101, _119);
  float _122 = min(_120, _116);
  float _123 = min(_121, _117);
  // _124 = _7;
  // _125 = _12;
  float4 _126 = t0.Sample(s0, float2(_122, _123));
  float _127 = _126.y;
  float4 _128 = cb0[15u];
  float _129 = _128.z;
  float _130 = _128.w;
  float _131 = _128.x;
  float _132 = _128.y;
  float _133 = max(_24, _131);
  float _134 = max(_25, _132);
  float _135 = min(_133, _129);
  float _136 = min(_134, _130);
  // _137 = _7;
  // _138 = _12;
  float4 _139 = t0.Sample(s0, float2(_135, _136));
  float _140 = _139.z;
  float4 _141 = cb1[136u];
  float _142 = _141.w;
  float _143 = _142 * _114;
  float _144 = _142 * _127;
  float _145 = _142 * _140;
  float4 _146 = cb0[43u];
  float _147 = _146.y;
  float _148 = dot(
      float3(_143, _144, _145),
      float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
  float4 _149 = cb0[9u];
  float _150 = _149.x;
  float _151 = _149.y;
  float _152 = _150 * _24;
  float _153 = _151 * _25;
  float _154 = floor(_152);
  float _155 = floor(_153);
  uint _156 = uint(_154);
  uint _157 = uint(_155);
  int _158 = _156 & 1;
  float _159 = float(_158);
  float _160 = _159 * 2.0f;
  float _161 = _160 + -1.0f;
  int _162 = _157 & 1;
  float _163 = float(_162);
  float _164 = _163 * 2.0f;
  float _165 = _164 + -1.0f;
  float _166 = _149.z;
  float _167 = _161 * _166;
  float _168 = _167 + _24;
  float4 _169 = cb0[15u];
  float _170 = _169.z;
  float _171 = _169.w;
  float _172 = _169.x;
  float _173 = _169.y;
  float _174 = max(_168, _172);
  float _175 = max(_25, _173);
  float _176 = min(_174, _170);
  float _177 = min(_175, _171);
  // _178 = _7;
  // _179 = _12;
  float4 _180 = t0.Sample(s0, float2(_176, _177));
  float _181 = _180.x;
  float _182 = _180.y;
  float _183 = _180.z;
  float _184 = _181 * _142;
  float _185 = _182 * _142;
  float _186 = _183 * _142;
  float4 _187 = cb0[9u];
  float _188 = _187.w;
  float _189 = _188 * _165;
  float _190 = _189 + _25;
  float4 _191 = cb0[15u];
  float _192 = _191.z;
  float _193 = _191.w;
  float _194 = _191.x;
  float _195 = _191.y;
  float _196 = max(_24, _194);
  float _197 = max(_190, _195);
  float _198 = min(_196, _192);
  float _199 = min(_197, _193);
  // _200 = _7;
  // _201 = _12;
  float4 _202 = t0.Sample(s0, float2(_198, _199));
  float _203 = _202.x;
  float _204 = _202.y;
  float _205 = _202.z;
  float _206 = _203 * _142;
  float _207 = _204 * _142;
  float _208 = _205 * _142;
  float _209 = dot(
      float3(_184, _185, _186),
      float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
  float _210 = dot(
      float3(_206, _207, _208),
      float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
  float _211 = ddx_fine(_143);
  float _212 = _211 * _161;
  float _213 = ddx_fine(_144);
  float _214 = _213 * _161;
  float _215 = ddx_fine(_145);
  float _216 = _215 * _161;
  float _217 = ddy_fine(_143);
  float _218 = _217 * _165;
  float _219 = ddy_fine(_144);
  float _220 = _219 * _165;
  float _221 = ddy_fine(_145);
  float _222 = _221 * _165;
  float _223 = ddx_fine(_148);
  float _224 = _223 * _161;
  float _225 = ddy_fine(_148);
  float _226 = _225 * _165;
  float _227 = _148 - _209;
  float _228 = _148 - _210;
  float _229 = abs(_227);
  float _230 = abs(_228);
  float _231 = abs(_224);
  float _232 = abs(_226);
  float _233 = max(_231, _232);
  float _234 = max(_229, _230);
  float _235 = max(_234, _233);
  float _236 = _235 * _21;
  float _237 = 1.0f - _236;
  float _238 = saturate(_237);
  float _239 = _147 * _238;
  float _240 = -0.0f - _239;
  float _241 = _143 * 4.0f;
  float _242 = _144 * 4.0f;
  float _243 = _145 * 4.0f;
  float _244 = _184 - _241;
  float _245 = _244 + _206;
  float _246 = _245 + _143;
  float _247 = _246 - _212;
  float _248 = _247 + _143;
  float _249 = _248 - _218;
  float _250 = _185 - _242;
  float _251 = _250 + _207;
  float _252 = _251 + _144;
  float _253 = _252 - _214;
  float _254 = _253 + _144;
  float _255 = _254 - _220;
  float _256 = _186 - _243;
  float _257 = _256 + _208;
  float _258 = _257 + _145;
  float _259 = _258 - _216;
  float _260 = _259 + _145;
  float _261 = _260 - _222;
  float _262 = _249 * _240;
  float _263 = _255 * _240;
  float _264 = _261 * _240;
  float _265 = _262 + _143;
  float _266 = _263 + _144;
  float _267 = _264 + _145;
  float4 _268 = cb0[40u];
  float _269 = _268.x;
  float _270 = _268.y;
  float _271 = _268.z;
  float _272 = _265 * _269;
  float _273 = _266 * _270;
  float _274 = _267 * _271;
  // _275 = _5;
  float4 _276 = t2[0].data[0 / 4];
  float _277 = _276.x;
  float _278 = _276.y;
  float _279 = _276.z;
  float _280 = _272 * _277;
  float _281 = _273 * _278;
  float _282 = _274 * _279;
  float4 _283 = cb0[32u];
  float _284 = _283.x;
  float _285 = _283.y;
  float _286 = _283.z;
  float _287 = _283.w;
  float _288 = _284 * _24;
  float _289 = _285 * _25;
  float _290 = _288 + _286;
  float _291 = _289 + _287;
  float4 _292 = cb0[33u];
  float _293 = _292.z;
  float _294 = _292.w;
  float _295 = _292.x;
  float _296 = _292.y;
  float _297 = max(_290, _295);
  float _298 = max(_291, _296);
  float _299 = min(_297, _293);
  float _300 = min(_298, _294);
  // _301 = _6;
  // _302 = _11;
  float4 _303 = t1.Sample(s1, float2(_299, _300));
  float _304 = _303.x;
  float _305 = _303.y;
  float _306 = _303.z;
  float4 _307 = cb1[136u];
  float _308 = _307.w;
  float _309 = _308 * _304;
  float _310 = _308 * _305;
  float _311 = _308 * _306;
  float4 _312 = cb0[44u];
  float _313 = _312.x;
  float _314 = _312.y;
  float _315 = _312.z;
  float _316 = _312.w;
  float _317 = _315 * _17;
  float _318 = _316 * _18;
  float _319 = _317 + _313;
  float _320 = _318 + _314;
  float _321 = _319 * 0.5f;
  float _322 = _320 * 0.5f;
  float _323 = _321 + 0.5f;
  float _324 = 0.5f - _322;
  // _325 = _2;
  // _326 = _9;
  float4 _327 = t5.Sample(s3, float2(_323, _324));
  float _328 = _327.x;
  float _329 = _327.y;
  float _330 = _327.z;
  float4 _331 = cb0[41u];
  float _332 = _331.x;
  float _333 = _331.y;
  float _334 = _331.z;
  float _335 = _332 * _328;
  float _336 = _333 * _329;
  float _337 = _334 * _330;
  float _338 = _335 + 1.0f;
  float _339 = _336 + 1.0f;
  float _340 = _337 + 1.0f;
  float _341 = _309 * _338;
  float _342 = _310 * _339;
  float _343 = _311 * _340;
  float _344 = _341 + _280;
  float _345 = _342 + _281;
  float _346 = _343 + _282;
  float4 _347 = cb0[43u];
  float _348 = _347.x;
  float _349 = _348 * _22;
  float _350 = _348 * _23;
  float _351 = dot(float2(_349, _350), float2(_349, _350));
  float _352 = _351 + 1.0f;
  float _353 = 1.0f / _352;
  float _354 = _353 * _353;
  float _355 = _354 * _21;
  float _356 = _355 * _344;
  float _357 = _355 * _345;
  float _358 = _355 * _346;
  // _359 = _3;
  float4 _360 = t4[0].data[0 / 4];
  float _361 = _360.x;
  float _362 = _360.y;
  float _363 = _360.z;
  float _364 = dot(float3(_356, _357, _358),
                   float3(0.04055619612336159f, 0.7329681515693665f,
                          -0.031567368656396866f));
  float4 _365 = cb0[2u];
  float _366 = _365.z;
  float _367 = _364 / _366;
  float _368 = saturate(_367);
  float _369 = _368 * 2.0f;
  float _370 = 3.0f - _369;
  float _371 = _368 * _368;
  float _372 = _371 * _370;
  float _373 = 1.0f - _372;
  float4 _374 = cb0[3u];
  float _375 = _374.x;
  float _376 = _365.w;
  float _377 = _375 - _376;
  float _378 = _364 - _376;
  float _379 = _378 / _377;
  float _380 = saturate(_379);
  float _381 = _380 * 2.0f;
  float _382 = 3.0f - _381;
  float _383 = _380 * _380;
  float _384 = _383 * _382;
  float _385 = _372 - _384;
  float4 _386 = cb0[1u];
  float _387 = _386.w;
  float _388 = _387 * _373;
  float _389 = _365.x;
  float _390 = _385 * _389;
  float _391 = _390 + _388;
  float _392 = _365.y;
  float _393 = _392 * _384;
  float _394 = _391 + _393;
  float4 _395 = cb0[5u];
  float _396 = _395.x;
  float _397 = _395.y;
  float _398 = _395.z;
  float _399 = _395.w;
  float _400 = _396 * _17;
  float _401 = _397 * _18;
  float _402 = _400 + _398;
  float _403 = _401 + _399;
  // _404 = _4;
  // _405 = _10;
  float3 _406 = t3.SampleLevel(s2, float2(_402, _403), 0.0f);
  float _407 = _406.x;
  float _408 = _406.y;
  float _409 = _406.z;
  float _410 = _407 * _361;
  float _411 = _408 * _362;
  float _412 = _409 * _363;
  float _413 = _410 + -1.0f;
  float _414 = _411 + -1.0f;
  float _415 = _412 + -1.0f;
  float _416 = _413 * _394;
  float _417 = _414 * _394;
  float _418 = _415 * _394;
  float _419 = _416 + 1.0f;
  float _420 = _417 + 1.0f;
  float _421 = _418 + 1.0f;
  float _422 = _419 * _356;
  float _423 = _420 * _357;
  float _424 = _421 * _358;

  float3 untonemapped = float3(_422, _423, _424);

  float _425 = _422 + 0.002667719265446067f;
  float _426 = _423 + 0.002667719265446067f;
  float _427 = _424 + 0.002667719265446067f;
  float _428 = log2(_425);
  float _429 = log2(_426);
  float _430 = log2(_427);
  float _431 = _428 * 0.0714285746216774f;
  float _432 = _429 * 0.0714285746216774f;
  float _433 = _430 * 0.0714285746216774f;
  float _434 = _431 + 0.6107269525527954f;
  float _435 = _432 + 0.6107269525527954f;
  float _436 = _433 + 0.6107269525527954f;
  float _437 = saturate(_434);
  float _438 = saturate(_435);
  float _439 = saturate(_436);
  float _440 = _437 * 0.96875f;
  float _441 = _438 * 0.96875f;
  float _442 = _439 * 0.96875f;
  float _443 = _440 + 0.015625f;
  float _444 = _441 + 0.015625f;
  float _445 = _442 + 0.015625f;
  // _446 = _1;
  // _447 = _8;
  float4 _448 = t6.Sample(s4, float3(_443, _444, _445));
  float _449 = _448.x;
  float _450 = _448.y;
  float _451 = _448.z;

  float _452 = _449 * 1.0499999523162842f;
  float _453 = _450 * 1.0499999523162842f;
  float _454 = _451 * 1.0499999523162842f;

  float3 post_lut = float3(_452, _453, _454);

  // Custom
  float3 lut_input = renodx::color::pq::from::BT2020(untonemapped, 100.f);
  float3 sampled = renodx::lut::Sample(t6, s4, lut_input);
  post_lut = renodx::color::bt2020::from::PQ(sampled, 100.f);

  float _455 = _20 * 543.3099975585938f;
  float _456 = _455 + _19;
  float _457 = sin(_456);
  float _458 = _457 * 493013.0f;
  float _459 = frac(_458);

  float _460 = _459 * 0.00390625f;
  float _461 = _460 + -0.001953125f;
  float _462 = _461 + _452;
  float _463 = _461 + _453;
  float _464 = _461 + _454;
  int4 _465 = cb0[46u];
  int _466 = _465.z;
  bool _467 = (_466 == 0);
  float _538;
  _538 = _462;
  float _539;
  _539 = _463;
  float _540;
  _540 = _464;

  _467 = true;  // disable custom pq/srgb

  if (!_467) {
    float _469 = log2(_462);
    float _470 = log2(_463);
    float _471 = log2(_464);
    float _472 = _469 * 0.012683313339948654f;
    float _473 = _470 * 0.012683313339948654f;
    float _474 = _471 * 0.012683313339948654f;
    float _475 = exp2(_472);
    float _476 = exp2(_473);
    float _477 = exp2(_474);
    float _478 = _475 + -0.8359375f;
    float _479 = _476 + -0.8359375f;
    float _480 = _477 + -0.8359375f;
    float _481 = max(0.0f, _478);
    float _482 = max(0.0f, _479);
    float _483 = max(0.0f, _480);
    float _484 = _475 * 18.6875f;
    float _485 = _476 * 18.6875f;
    float _486 = _477 * 18.6875f;
    float _487 = 18.8515625f - _484;
    float _488 = 18.8515625f - _485;
    float _489 = 18.8515625f - _486;
    float _490 = _481 / _487;
    float _491 = _482 / _488;
    float _492 = _483 / _489;
    float _493 = log2(_490);
    float _494 = log2(_491);
    float _495 = log2(_492);
    float _496 = _493 * 6.277394771575928f;
    float _497 = _494 * 6.277394771575928f;
    float _498 = _495 * 6.277394771575928f;
    float _499 = exp2(_496);
    float _500 = exp2(_497);
    float _501 = exp2(_498);
    float _502 = _499 * 10000.0f;
    float _503 = _500 * 10000.0f;
    float _504 = _501 * 10000.0f;
    float4 _505 = cb0[46u];
    float _506 = _505.y;
    float _507 = _502 / _506;
    float _508 = _503 / _506;
    float _509 = _504 / _506;
    float _510 = max(6.103519990574569e-05f, _507);
    float _511 = max(6.103519990574569e-05f, _508);
    float _512 = max(6.103519990574569e-05f, _509);
    float _513 = max(_510, 0.0031306699384003878f);
    float _514 = max(_511, 0.0031306699384003878f);
    float _515 = max(_512, 0.0031306699384003878f);
    float _516 = log2(_513);
    float _517 = log2(_514);
    float _518 = log2(_515);
    float _519 = _516 * 0.4166666567325592f;
    float _520 = _517 * 0.4166666567325592f;
    float _521 = _518 * 0.4166666567325592f;
    float _522 = exp2(_519);
    float _523 = exp2(_520);
    float _524 = exp2(_521);
    float _525 = _522 * 1.0549999475479126f;
    float _526 = _523 * 1.0549999475479126f;
    float _527 = _524 * 1.0549999475479126f;
    float _528 = _525 + -0.054999999701976776f;
    float _529 = _526 + -0.054999999701976776f;
    float _530 = _527 + -0.054999999701976776f;
    float _531 = _510 * 12.920000076293945f;
    float _532 = _511 * 12.920000076293945f;
    float _533 = _512 * 12.920000076293945f;
    float _534 = min(_531, _528);
    float _535 = min(_532, _529);
    float _536 = min(_533, _530);
    _538 = _534;
    _539 = _535;
    _540 = _536;
  }
  SV_Target.x = _538;
  SV_Target.y = _539;
  SV_Target.z = _540;
  SV_Target.w = 0.0f;

  // Custom logic
  SV_Target.rgb = post_lut;
  SV_Target.rgb = renodx::color::bt2020::from::BT709(SV_Target.rgb);
  SV_Target.rgb *= 203.f;
  SV_Target.rgb /= 10000.f;
  SV_Target.rgb = renodx::color::pq::from::BT2020(SV_Target.rgb);
  return SV_Target;
}
