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
  float cb2_009x : packoffset(c009.x);
  float cb2_009y : packoffset(c009.y);
  float cb2_009z : packoffset(c009.z);
  float cb2_010x : packoffset(c010.x);
  float cb2_010y : packoffset(c010.y);
  float cb2_010z : packoffset(c010.z);
  float cb2_011x : packoffset(c011.x);
  float cb2_011y : packoffset(c011.y);
  float cb2_011z : packoffset(c011.z);
  float cb2_011w : packoffset(c011.w);
  float cb2_012x : packoffset(c012.x);
  float cb2_012y : packoffset(c012.y);
  float cb2_012z : packoffset(c012.z);
  float cb2_012w : packoffset(c012.w);
  float cb2_013x : packoffset(c013.x);
  float cb2_013y : packoffset(c013.y);
  float cb2_013z : packoffset(c013.z);
  float cb2_013w : packoffset(c013.w);
  float cb2_014x : packoffset(c014.x);
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
  float4 _22 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _26 = _22.x * 6.283199787139893f;
  float _27 = cos(_26);
  float _28 = sin(_26);
  float _29 = _27 * _22.z;
  float _30 = _28 * _22.z;
  float _31 = _29 + TEXCOORD0_centroid.x;
  float _32 = _30 + TEXCOORD0_centroid.y;
  float _33 = _31 * 10.0f;
  float _34 = 10.0f - _33;
  float _35 = min(_33, _34);
  float _36 = saturate(_35);
  float _37 = _36 * _29;
  float _38 = _32 * 10.0f;
  float _39 = 10.0f - _38;
  float _40 = min(_38, _39);
  float _41 = saturate(_40);
  float _42 = _41 * _30;
  float _43 = _37 + TEXCOORD0_centroid.x;
  float _44 = _42 + TEXCOORD0_centroid.y;
  float4 _45 = t7.SampleLevel(s2_space2, float2(_43, _44), 0.0f);
  float _47 = _45.w * _37;
  float _48 = _45.w * _42;
  float _49 = 1.0f - _22.y;
  float _50 = saturate(_49);
  float _51 = _47 * _50;
  float _52 = _48 * _50;
  float _53 = _51 + TEXCOORD0_centroid.x;
  float _54 = _52 + TEXCOORD0_centroid.y;
  float4 _55 = t7.SampleLevel(s2_space2, float2(_53, _54), 0.0f);
  bool _57 = (_55.y > 0.0f);
  float _58 = select(_57, TEXCOORD0_centroid.x, _53);
  float _59 = select(_57, TEXCOORD0_centroid.y, _54);
  float4 _60 = t1.SampleLevel(s4_space2, float2(_58, _59), 0.0f);
  float _64 = max(_60.x, 0.0f);
  float _65 = max(_60.y, 0.0f);
  float _66 = max(_60.z, 0.0f);
  float _67 = min(_64, 65000.0f);
  float _68 = min(_65, 65000.0f);
  float _69 = min(_66, 65000.0f);
  float4 _70 = t3.SampleLevel(s2_space2, float2(_58, _59), 0.0f);
  float _75 = max(_70.x, 0.0f);
  float _76 = max(_70.y, 0.0f);
  float _77 = max(_70.z, 0.0f);
  float _78 = max(_70.w, 0.0f);
  float _79 = min(_75, 5000.0f);
  float _80 = min(_76, 5000.0f);
  float _81 = min(_77, 5000.0f);
  float _82 = min(_78, 5000.0f);
  float _85 = _20.x * cb0_028z;
  float _86 = _85 + cb0_028x;
  float _87 = cb2_027w / _86;
  float _88 = 1.0f - _87;
  float _89 = abs(_88);
  float _91 = cb2_027y * _89;
  float _93 = _91 - cb2_027z;
  float _94 = saturate(_93);
  float _95 = max(_94, _82);
  float _96 = saturate(_95);
  float _100 = cb2_013x * _58;
  float _101 = cb2_013y * _59;
  float _104 = _100 + cb2_013z;
  float _105 = _101 + cb2_013w;
  float _108 = dot(float2(_104, _105), float2(_104, _105));
  float _109 = abs(_108);
  float _110 = log2(_109);
  float _111 = _110 * cb2_014x;
  float _112 = exp2(_111);
  float _113 = saturate(_112);
  float _117 = cb2_011x * _58;
  float _118 = cb2_011y * _59;
  float _121 = _117 + cb2_011z;
  float _122 = _118 + cb2_011w;
  float _123 = _121 * _113;
  float _124 = _122 * _113;
  float _125 = _123 + _58;
  float _126 = _124 + _59;
  float _130 = cb2_012x * _58;
  float _131 = cb2_012y * _59;
  float _134 = _130 + cb2_012z;
  float _135 = _131 + cb2_012w;
  float _136 = _134 * _113;
  float _137 = _135 * _113;
  float _138 = _136 + _58;
  float _139 = _137 + _59;
  float4 _140 = t1.SampleLevel(s2_space2, float2(_125, _126), 0.0f);
  float _144 = max(_140.x, 0.0f);
  float _145 = max(_140.y, 0.0f);
  float _146 = max(_140.z, 0.0f);
  float _147 = min(_144, 65000.0f);
  float _148 = min(_145, 65000.0f);
  float _149 = min(_146, 65000.0f);
  float4 _150 = t1.SampleLevel(s2_space2, float2(_138, _139), 0.0f);
  float _154 = max(_150.x, 0.0f);
  float _155 = max(_150.y, 0.0f);
  float _156 = max(_150.z, 0.0f);
  float _157 = min(_154, 65000.0f);
  float _158 = min(_155, 65000.0f);
  float _159 = min(_156, 65000.0f);
  float4 _160 = t3.SampleLevel(s2_space2, float2(_125, _126), 0.0f);
  float _164 = max(_160.x, 0.0f);
  float _165 = max(_160.y, 0.0f);
  float _166 = max(_160.z, 0.0f);
  float _167 = min(_164, 5000.0f);
  float _168 = min(_165, 5000.0f);
  float _169 = min(_166, 5000.0f);
  float4 _170 = t3.SampleLevel(s2_space2, float2(_138, _139), 0.0f);
  float _174 = max(_170.x, 0.0f);
  float _175 = max(_170.y, 0.0f);
  float _176 = max(_170.z, 0.0f);
  float _177 = min(_174, 5000.0f);
  float _178 = min(_175, 5000.0f);
  float _179 = min(_176, 5000.0f);
  float _184 = 1.0f - cb2_009x;
  float _185 = 1.0f - cb2_009y;
  float _186 = 1.0f - cb2_009z;
  float _191 = _184 - cb2_010x;
  float _192 = _185 - cb2_010y;
  float _193 = _186 - cb2_010z;
  float _194 = saturate(_191);
  float _195 = saturate(_192);
  float _196 = saturate(_193);
  float _197 = _194 * _67;
  float _198 = _195 * _68;
  float _199 = _196 * _69;
  float _200 = cb2_009x * _147;
  float _201 = cb2_009y * _148;
  float _202 = cb2_009z * _149;
  float _203 = _200 + _197;
  float _204 = _201 + _198;
  float _205 = _202 + _199;
  float _206 = cb2_010x * _157;
  float _207 = cb2_010y * _158;
  float _208 = cb2_010z * _159;
  float _209 = _203 + _206;
  float _210 = _204 + _207;
  float _211 = _205 + _208;
  float _212 = _194 * _79;
  float _213 = _195 * _80;
  float _214 = _196 * _81;
  float _215 = cb2_009x * _167;
  float _216 = cb2_009y * _168;
  float _217 = cb2_009z * _169;
  float _218 = cb2_010x * _177;
  float _219 = cb2_010y * _178;
  float _220 = cb2_010z * _179;
  float4 _221 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _225 = _212 - _209;
  float _226 = _225 + _215;
  float _227 = _226 + _218;
  float _228 = _213 - _210;
  float _229 = _228 + _216;
  float _230 = _229 + _219;
  float _231 = _214 - _211;
  float _232 = _231 + _217;
  float _233 = _232 + _220;
  float _234 = _227 * _96;
  float _235 = _230 * _96;
  float _236 = _233 * _96;
  float _237 = _234 + _209;
  float _238 = _235 + _210;
  float _239 = _236 + _211;
  float _240 = dot(float3(_237, _238, _239), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _244 = t0[0].SExposureData_020;
  float _246 = t0[0].SExposureData_004;
  float _248 = cb2_018x * 0.5f;
  float _249 = _248 * cb2_018y;
  float _250 = _246.x - _249;
  float _251 = cb2_018y * cb2_018x;
  float _252 = 1.0f / _251;
  float _253 = _250 * _252;
  float _254 = _240 / _244.x;
  float _255 = _254 * 5464.01611328125f;
  float _256 = _255 + 9.99999993922529e-09f;
  float _257 = log2(_256);
  float _258 = _257 - _250;
  float _259 = _258 * _252;
  float _260 = saturate(_259);
  float2 _261 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _260), 0.0f);
  float _264 = max(_261.y, 1.0000000116860974e-07f);
  float _265 = _261.x / _264;
  float _266 = _265 + _253;
  float _267 = _266 / _252;
  float _268 = _267 - _246.x;
  float _269 = -0.0f - _268;
  float _271 = _269 - cb2_027x;
  float _272 = max(0.0f, _271);
  float _275 = cb2_026z * _272;
  float _276 = _268 - cb2_027x;
  float _277 = max(0.0f, _276);
  float _279 = cb2_026w * _277;
  bool _280 = (_268 < 0.0f);
  float _281 = select(_280, _275, _279);
  float _282 = exp2(_281);
  float _283 = _282 * _237;
  float _284 = _282 * _238;
  float _285 = _282 * _239;
  float _290 = cb2_024y * _221.x;
  float _291 = cb2_024z * _221.y;
  float _292 = cb2_024w * _221.z;
  float _293 = _290 + _283;
  float _294 = _291 + _284;
  float _295 = _292 + _285;
  float _300 = _293 * cb2_025x;
  float _301 = _294 * cb2_025y;
  float _302 = _295 * cb2_025z;
  float _303 = dot(float3(_300, _301, _302), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _304 = t0[0].SExposureData_012;
  float _306 = _303 * 5464.01611328125f;
  float _307 = _306 * _304.x;
  float _308 = _307 + 9.99999993922529e-09f;
  float _309 = log2(_308);
  float _310 = _309 + 16.929765701293945f;
  float _311 = _310 * 0.05734497308731079f;
  float _312 = saturate(_311);
  float _313 = _312 * _312;
  float _314 = _312 * 2.0f;
  float _315 = 3.0f - _314;
  float _316 = _313 * _315;
  float _317 = _301 * 0.8450999855995178f;
  float _318 = _302 * 0.14589999616146088f;
  float _319 = _317 + _318;
  float _320 = _319 * 2.4890189170837402f;
  float _321 = _319 * 0.3754962384700775f;
  float _322 = _319 * 2.811495304107666f;
  float _323 = _319 * 5.519708156585693f;
  float _324 = _303 - _320;
  float _325 = _316 * _324;
  float _326 = _325 + _320;
  float _327 = _316 * 0.5f;
  float _328 = _327 + 0.5f;
  float _329 = _328 * _324;
  float _330 = _329 + _320;
  float _331 = _300 - _321;
  float _332 = _301 - _322;
  float _333 = _302 - _323;
  float _334 = _328 * _331;
  float _335 = _328 * _332;
  float _336 = _328 * _333;
  float _337 = _334 + _321;
  float _338 = _335 + _322;
  float _339 = _336 + _323;
  float _340 = 1.0f / _330;
  float _341 = _326 * _340;
  float _342 = _341 * _337;
  float _343 = _341 * _338;
  float _344 = _341 * _339;
  float _348 = cb2_020x * TEXCOORD0_centroid.x;
  float _349 = cb2_020y * TEXCOORD0_centroid.y;
  float _352 = _348 + cb2_020z;
  float _353 = _349 + cb2_020w;
  float _356 = dot(float2(_352, _353), float2(_352, _353));
  float _357 = 1.0f - _356;
  float _358 = saturate(_357);
  float _359 = log2(_358);
  float _360 = _359 * cb2_021w;
  float _361 = exp2(_360);
  float _365 = _342 - cb2_021x;
  float _366 = _343 - cb2_021y;
  float _367 = _344 - cb2_021z;
  float _368 = _365 * _361;
  float _369 = _366 * _361;
  float _370 = _367 * _361;
  float _371 = _368 + cb2_021x;
  float _372 = _369 + cb2_021y;
  float _373 = _370 + cb2_021z;
  float _374 = t0[0].SExposureData_000;
  float _376 = max(_244.x, 0.0010000000474974513f);
  float _377 = 1.0f / _376;
  float _378 = _377 * _374.x;
  bool _381 = ((uint)(cb2_069y) == 0);
  float _387;
  float _388;
  float _389;
  float _443;
  float _444;
  float _445;
  float _490;
  float _491;
  float _492;
  float _537;
  float _538;
  float _539;
  float _540;
  float _587;
  float _588;
  float _589;
  float _614;
  float _615;
  float _616;
  float _717;
  float _718;
  float _719;
  float _744;
  float _756;
  float _784;
  float _796;
  float _808;
  float _809;
  float _810;
  float _837;
  float _838;
  float _839;
  if (!_381) {
    float _383 = _378 * _371;
    float _384 = _378 * _372;
    float _385 = _378 * _373;
    _387 = _383;
    _388 = _384;
    _389 = _385;
  } else {
    _387 = _371;
    _388 = _372;
    _389 = _373;
  }
  float _390 = _387 * 0.6130970120429993f;
  float _391 = mad(0.33952298760414124f, _388, _390);
  float _392 = mad(0.04737899824976921f, _389, _391);
  float _393 = _387 * 0.07019399851560593f;
  float _394 = mad(0.9163540005683899f, _388, _393);
  float _395 = mad(0.013451999984681606f, _389, _394);
  float _396 = _387 * 0.02061600051820278f;
  float _397 = mad(0.10956999659538269f, _388, _396);
  float _398 = mad(0.8698149919509888f, _389, _397);
  float _399 = log2(_392);
  float _400 = log2(_395);
  float _401 = log2(_398);
  float _402 = _399 * 0.04211956635117531f;
  float _403 = _400 * 0.04211956635117531f;
  float _404 = _401 * 0.04211956635117531f;
  float _405 = _402 + 0.6252607107162476f;
  float _406 = _403 + 0.6252607107162476f;
  float _407 = _404 + 0.6252607107162476f;
  float4 _408 = t5.SampleLevel(s2_space2, float3(_405, _406, _407), 0.0f);
  bool _414 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_414 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _418 = cb2_017x * _408.x;
    float _419 = cb2_017x * _408.y;
    float _420 = cb2_017x * _408.z;
    float _422 = _418 + cb2_017y;
    float _423 = _419 + cb2_017y;
    float _424 = _420 + cb2_017y;
    float _425 = exp2(_422);
    float _426 = exp2(_423);
    float _427 = exp2(_424);
    float _428 = _425 + 1.0f;
    float _429 = _426 + 1.0f;
    float _430 = _427 + 1.0f;
    float _431 = 1.0f / _428;
    float _432 = 1.0f / _429;
    float _433 = 1.0f / _430;
    float _435 = cb2_017z * _431;
    float _436 = cb2_017z * _432;
    float _437 = cb2_017z * _433;
    float _439 = _435 + cb2_017w;
    float _440 = _436 + cb2_017w;
    float _441 = _437 + cb2_017w;
    _443 = _439;
    _444 = _440;
    _445 = _441;
  } else {
    _443 = _408.x;
    _444 = _408.y;
    _445 = _408.z;
  }
  float _446 = _443 * 23.0f;
  float _447 = _446 + -14.473931312561035f;
  float _448 = exp2(_447);
  float _449 = _444 * 23.0f;
  float _450 = _449 + -14.473931312561035f;
  float _451 = exp2(_450);
  float _452 = _445 * 23.0f;
  float _453 = _452 + -14.473931312561035f;
  float _454 = exp2(_453);
  float _458 = cb2_004x * TEXCOORD0_centroid.x;
  float _459 = cb2_004y * TEXCOORD0_centroid.y;
  float _462 = _458 + cb2_004z;
  float _463 = _459 + cb2_004w;
  float4 _469 = t6.Sample(s2_space2, float2(_462, _463));
  float _474 = _469.x * cb2_003x;
  float _475 = _469.y * cb2_003y;
  float _476 = _469.z * cb2_003z;
  float _477 = _469.w * cb2_003w;
  float _480 = _477 + cb2_026y;
  float _481 = saturate(_480);
  bool _484 = ((uint)(cb2_069y) == 0);
  if (!_484) {
    float _486 = _474 * _378;
    float _487 = _475 * _378;
    float _488 = _476 * _378;
    _490 = _486;
    _491 = _487;
    _492 = _488;
  } else {
    _490 = _474;
    _491 = _475;
    _492 = _476;
  }
  bool _495 = ((uint)(cb2_028x) == 2);
  bool _496 = ((uint)(cb2_028x) == 3);
  int _497 = (uint)(cb2_028x) & -2;
  bool _498 = (_497 == 2);
  bool _499 = ((uint)(cb2_028x) == 6);
  bool _500 = _498 || _499;
  if (_500) {
    float _502 = _490 * _481;
    float _503 = _491 * _481;
    float _504 = _492 * _481;
    float _505 = _481 * _481;
    _537 = _502;
    _538 = _503;
    _539 = _504;
    _540 = _505;
  } else {
    bool _507 = ((uint)(cb2_028x) == 4);
    if (_507) {
      float _509 = _490 + -1.0f;
      float _510 = _491 + -1.0f;
      float _511 = _492 + -1.0f;
      float _512 = _481 + -1.0f;
      float _513 = _509 * _481;
      float _514 = _510 * _481;
      float _515 = _511 * _481;
      float _516 = _512 * _481;
      float _517 = _513 + 1.0f;
      float _518 = _514 + 1.0f;
      float _519 = _515 + 1.0f;
      float _520 = _516 + 1.0f;
      _537 = _517;
      _538 = _518;
      _539 = _519;
      _540 = _520;
    } else {
      bool _522 = ((uint)(cb2_028x) == 5);
      if (_522) {
        float _524 = _490 + -0.5f;
        float _525 = _491 + -0.5f;
        float _526 = _492 + -0.5f;
        float _527 = _481 + -0.5f;
        float _528 = _524 * _481;
        float _529 = _525 * _481;
        float _530 = _526 * _481;
        float _531 = _527 * _481;
        float _532 = _528 + 0.5f;
        float _533 = _529 + 0.5f;
        float _534 = _530 + 0.5f;
        float _535 = _531 + 0.5f;
        _537 = _532;
        _538 = _533;
        _539 = _534;
        _540 = _535;
      } else {
        _537 = _490;
        _538 = _491;
        _539 = _492;
        _540 = _481;
      }
    }
  }
  if (_495) {
    float _542 = _537 + _448;
    float _543 = _538 + _451;
    float _544 = _539 + _454;
    _587 = _542;
    _588 = _543;
    _589 = _544;
  } else {
    if (_496) {
      float _547 = 1.0f - _537;
      float _548 = 1.0f - _538;
      float _549 = 1.0f - _539;
      float _550 = _547 * _448;
      float _551 = _548 * _451;
      float _552 = _549 * _454;
      float _553 = _550 + _537;
      float _554 = _551 + _538;
      float _555 = _552 + _539;
      _587 = _553;
      _588 = _554;
      _589 = _555;
    } else {
      bool _557 = ((uint)(cb2_028x) == 4);
      if (_557) {
        float _559 = _537 * _448;
        float _560 = _538 * _451;
        float _561 = _539 * _454;
        _587 = _559;
        _588 = _560;
        _589 = _561;
      } else {
        bool _563 = ((uint)(cb2_028x) == 5);
        if (_563) {
          float _565 = _448 * 2.0f;
          float _566 = _565 * _537;
          float _567 = _451 * 2.0f;
          float _568 = _567 * _538;
          float _569 = _454 * 2.0f;
          float _570 = _569 * _539;
          _587 = _566;
          _588 = _568;
          _589 = _570;
        } else {
          if (_499) {
            float _573 = _448 - _537;
            float _574 = _451 - _538;
            float _575 = _454 - _539;
            _587 = _573;
            _588 = _574;
            _589 = _575;
          } else {
            float _577 = _537 - _448;
            float _578 = _538 - _451;
            float _579 = _539 - _454;
            float _580 = _540 * _577;
            float _581 = _540 * _578;
            float _582 = _540 * _579;
            float _583 = _580 + _448;
            float _584 = _581 + _451;
            float _585 = _582 + _454;
            _587 = _583;
            _588 = _584;
            _589 = _585;
          }
        }
      }
    }
  }
  float _595 = cb2_016x - _587;
  float _596 = cb2_016y - _588;
  float _597 = cb2_016z - _589;
  float _598 = _595 * cb2_016w;
  float _599 = _596 * cb2_016w;
  float _600 = _597 * cb2_016w;
  float _601 = _598 + _587;
  float _602 = _599 + _588;
  float _603 = _600 + _589;
  bool _606 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_606 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _610 = cb2_024x * _601;
    float _611 = cb2_024x * _602;
    float _612 = cb2_024x * _603;
    _614 = _610;
    _615 = _611;
    _616 = _612;
  } else {
    _614 = _601;
    _615 = _602;
    _616 = _603;
  }
  float _617 = _614 * 0.9708889722824097f;
  float _618 = mad(0.026962999254465103f, _615, _617);
  float _619 = mad(0.002148000057786703f, _616, _618);
  float _620 = _614 * 0.01088900025933981f;
  float _621 = mad(0.9869629740715027f, _615, _620);
  float _622 = mad(0.002148000057786703f, _616, _621);
  float _623 = mad(0.026962999254465103f, _615, _620);
  float _624 = mad(0.9621480107307434f, _616, _623);
  if (_606) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _629 = cb1_018y * 0.10000000149011612f;
        float _630 = log2(cb1_018z);
        float _631 = _630 + -13.287712097167969f;
        float _632 = _631 * 1.4929734468460083f;
        float _633 = _632 + 18.0f;
        float _634 = exp2(_633);
        float _635 = _634 * 0.18000000715255737f;
        float _636 = abs(_635);
        float _637 = log2(_636);
        float _638 = _637 * 1.5f;
        float _639 = exp2(_638);
        float _640 = _639 * _629;
        float _641 = _640 / cb1_018z;
        float _642 = _641 + -0.07636754959821701f;
        float _643 = _637 * 1.2750000953674316f;
        float _644 = exp2(_643);
        float _645 = _644 * 0.07636754959821701f;
        float _646 = cb1_018y * 0.011232397519052029f;
        float _647 = _646 * _639;
        float _648 = _647 / cb1_018z;
        float _649 = _645 - _648;
        float _650 = _644 + -0.11232396960258484f;
        float _651 = _650 * _629;
        float _652 = _651 / cb1_018z;
        float _653 = _652 * cb1_018z;
        float _654 = abs(_619);
        float _655 = abs(_622);
        float _656 = abs(_624);
        float _657 = log2(_654);
        float _658 = log2(_655);
        float _659 = log2(_656);
        float _660 = _657 * 1.5f;
        float _661 = _658 * 1.5f;
        float _662 = _659 * 1.5f;
        float _663 = exp2(_660);
        float _664 = exp2(_661);
        float _665 = exp2(_662);
        float _666 = _663 * _653;
        float _667 = _664 * _653;
        float _668 = _665 * _653;
        float _669 = _657 * 1.2750000953674316f;
        float _670 = _658 * 1.2750000953674316f;
        float _671 = _659 * 1.2750000953674316f;
        float _672 = exp2(_669);
        float _673 = exp2(_670);
        float _674 = exp2(_671);
        float _675 = _672 * _642;
        float _676 = _673 * _642;
        float _677 = _674 * _642;
        float _678 = _675 + _649;
        float _679 = _676 + _649;
        float _680 = _677 + _649;
        float _681 = _666 / _678;
        float _682 = _667 / _679;
        float _683 = _668 / _680;
        float _684 = _681 * 9.999999747378752e-05f;
        float _685 = _682 * 9.999999747378752e-05f;
        float _686 = _683 * 9.999999747378752e-05f;
        float _687 = 5000.0f / cb1_018y;
        float _688 = _684 * _687;
        float _689 = _685 * _687;
        float _690 = _686 * _687;
        _717 = _688;
        _718 = _689;
        _719 = _690;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_619, _622, _624));
      _717 = tonemapped.x, _718 = tonemapped.y, _719 = tonemapped.z;
    }
      } else {
        float _692 = _619 + 0.020616600289940834f;
        float _693 = _622 + 0.020616600289940834f;
        float _694 = _624 + 0.020616600289940834f;
        float _695 = _692 * _619;
        float _696 = _693 * _622;
        float _697 = _694 * _624;
        float _698 = _695 + -7.456949970219284e-05f;
        float _699 = _696 + -7.456949970219284e-05f;
        float _700 = _697 + -7.456949970219284e-05f;
        float _701 = _619 * 0.9837960004806519f;
        float _702 = _622 * 0.9837960004806519f;
        float _703 = _624 * 0.9837960004806519f;
        float _704 = _701 + 0.4336790144443512f;
        float _705 = _702 + 0.4336790144443512f;
        float _706 = _703 + 0.4336790144443512f;
        float _707 = _704 * _619;
        float _708 = _705 * _622;
        float _709 = _706 * _624;
        float _710 = _707 + 0.24617899954319f;
        float _711 = _708 + 0.24617899954319f;
        float _712 = _709 + 0.24617899954319f;
        float _713 = _698 / _710;
        float _714 = _699 / _711;
        float _715 = _700 / _712;
        _717 = _713;
        _718 = _714;
        _719 = _715;
      }
      float _720 = _717 * 1.6047500371932983f;
      float _721 = mad(-0.5310800075531006f, _718, _720);
      float _722 = mad(-0.07366999983787537f, _719, _721);
      float _723 = _717 * -0.10208000242710114f;
      float _724 = mad(1.1081299781799316f, _718, _723);
      float _725 = mad(-0.006049999967217445f, _719, _724);
      float _726 = _717 * -0.0032599999103695154f;
      float _727 = mad(-0.07275000214576721f, _718, _726);
      float _728 = mad(1.0760200023651123f, _719, _727);
      if (_606) {
        // float _730 = max(_722, 0.0f);
        // float _731 = max(_725, 0.0f);
        // float _732 = max(_728, 0.0f);
        // bool _733 = !(_730 >= 0.0030399328097701073f);
        // if (!_733) {
        //   float _735 = abs(_730);
        //   float _736 = log2(_735);
        //   float _737 = _736 * 0.4166666567325592f;
        //   float _738 = exp2(_737);
        //   float _739 = _738 * 1.0549999475479126f;
        //   float _740 = _739 + -0.054999999701976776f;
        //   _744 = _740;
        // } else {
        //   float _742 = _730 * 12.923210144042969f;
        //   _744 = _742;
        // }
        // bool _745 = !(_731 >= 0.0030399328097701073f);
        // if (!_745) {
        //   float _747 = abs(_731);
        //   float _748 = log2(_747);
        //   float _749 = _748 * 0.4166666567325592f;
        //   float _750 = exp2(_749);
        //   float _751 = _750 * 1.0549999475479126f;
        //   float _752 = _751 + -0.054999999701976776f;
        //   _756 = _752;
        // } else {
        //   float _754 = _731 * 12.923210144042969f;
        //   _756 = _754;
        // }
        // bool _757 = !(_732 >= 0.0030399328097701073f);
        // if (!_757) {
        //   float _759 = abs(_732);
        //   float _760 = log2(_759);
        //   float _761 = _760 * 0.4166666567325592f;
        //   float _762 = exp2(_761);
        //   float _763 = _762 * 1.0549999475479126f;
        //   float _764 = _763 + -0.054999999701976776f;
        //   _837 = _744;
        //   _838 = _756;
        //   _839 = _764;
        // } else {
        //   float _766 = _732 * 12.923210144042969f;
        //   _837 = _744;
        //   _838 = _756;
        //   _839 = _766;
        // }
        _837 = renodx::color::srgb::EncodeSafe(_722);
        _838 = renodx::color::srgb::EncodeSafe(_725);
        _839 = renodx::color::srgb::EncodeSafe(_728);

      } else {
        float _768 = saturate(_722);
        float _769 = saturate(_725);
        float _770 = saturate(_728);
        bool _771 = ((uint)(cb1_018w) == -2);
        if (!_771) {
          bool _773 = !(_768 >= 0.0030399328097701073f);
          if (!_773) {
            float _775 = abs(_768);
            float _776 = log2(_775);
            float _777 = _776 * 0.4166666567325592f;
            float _778 = exp2(_777);
            float _779 = _778 * 1.0549999475479126f;
            float _780 = _779 + -0.054999999701976776f;
            _784 = _780;
          } else {
            float _782 = _768 * 12.923210144042969f;
            _784 = _782;
          }
          bool _785 = !(_769 >= 0.0030399328097701073f);
          if (!_785) {
            float _787 = abs(_769);
            float _788 = log2(_787);
            float _789 = _788 * 0.4166666567325592f;
            float _790 = exp2(_789);
            float _791 = _790 * 1.0549999475479126f;
            float _792 = _791 + -0.054999999701976776f;
            _796 = _792;
          } else {
            float _794 = _769 * 12.923210144042969f;
            _796 = _794;
          }
          bool _797 = !(_770 >= 0.0030399328097701073f);
          if (!_797) {
            float _799 = abs(_770);
            float _800 = log2(_799);
            float _801 = _800 * 0.4166666567325592f;
            float _802 = exp2(_801);
            float _803 = _802 * 1.0549999475479126f;
            float _804 = _803 + -0.054999999701976776f;
            _808 = _784;
            _809 = _796;
            _810 = _804;
          } else {
            float _806 = _770 * 12.923210144042969f;
            _808 = _784;
            _809 = _796;
            _810 = _806;
          }
        } else {
          _808 = _768;
          _809 = _769;
          _810 = _770;
        }
        float _815 = abs(_808);
        float _816 = abs(_809);
        float _817 = abs(_810);
        float _818 = log2(_815);
        float _819 = log2(_816);
        float _820 = log2(_817);
        float _821 = _818 * cb2_000z;
        float _822 = _819 * cb2_000z;
        float _823 = _820 * cb2_000z;
        float _824 = exp2(_821);
        float _825 = exp2(_822);
        float _826 = exp2(_823);
        float _827 = _824 * cb2_000y;
        float _828 = _825 * cb2_000y;
        float _829 = _826 * cb2_000y;
        float _830 = _827 + cb2_000x;
        float _831 = _828 + cb2_000x;
        float _832 = _829 + cb2_000x;
        float _833 = saturate(_830);
        float _834 = saturate(_831);
        float _835 = saturate(_832);
        _837 = _833;
        _838 = _834;
        _839 = _835;
      }
      float _840 = dot(float3(_837, _838, _839), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _837;
      SV_Target.y = _838;
      SV_Target.z = _839;
      SV_Target.w = _840;
      SV_Target_1.x = _840;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
