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
  float _484;
  float _485;
  float _486;
  float _531;
  float _532;
  float _533;
  float _534;
  float _581;
  float _582;
  float _583;
  float _608;
  float _609;
  float _610;
  float _711;
  float _712;
  float _713;
  float _738;
  float _750;
  float _778;
  float _790;
  float _802;
  float _803;
  float _804;
  float _831;
  float _832;
  float _833;
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
  float _404 = dot(float3(_397, _400, _403), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _409 = dot(float3(_397, _400, _403), float3(_397, _400, _403));
  float _410 = rsqrt(_409);
  float _411 = _410 * _397;
  float _412 = _410 * _400;
  float _413 = _410 * _403;
  float _414 = cb2_001x - _411;
  float _415 = cb2_001y - _412;
  float _416 = cb2_001z - _413;
  float _417 = dot(float3(_414, _415, _416), float3(_414, _415, _416));
  float _420 = cb2_002z * _417;
  float _422 = _420 + cb2_002w;
  float _423 = saturate(_422);
  float _425 = cb2_002x * _423;
  float _426 = _404 - _397;
  float _427 = _404 - _400;
  float _428 = _404 - _403;
  float _429 = _425 * _426;
  float _430 = _425 * _427;
  float _431 = _425 * _428;
  float _432 = _429 + _397;
  float _433 = _430 + _400;
  float _434 = _431 + _403;
  float _436 = cb2_002y * _423;
  float _437 = 0.10000000149011612f - _432;
  float _438 = 0.10000000149011612f - _433;
  float _439 = 0.10000000149011612f - _434;
  float _440 = _437 * _436;
  float _441 = _438 * _436;
  float _442 = _439 * _436;
  float _443 = _440 + _432;
  float _444 = _441 + _433;
  float _445 = _442 + _434;
  float _446 = saturate(_443);
  float _447 = saturate(_444);
  float _448 = saturate(_445);
  float _452 = cb2_004x * TEXCOORD0_centroid.x;
  float _453 = cb2_004y * TEXCOORD0_centroid.y;
  float _456 = _452 + cb2_004z;
  float _457 = _453 + cb2_004w;
  float4 _463 = t7.Sample(s2_space2, float2(_456, _457));
  float _468 = _463.x * cb2_003x;
  float _469 = _463.y * cb2_003y;
  float _470 = _463.z * cb2_003z;
  float _471 = _463.w * cb2_003w;
  float _474 = _471 + cb2_026y;
  float _475 = saturate(_474);
  bool _478 = ((uint)(cb2_069y) == 0);
  if (!_478) {
    float _480 = _468 * _327;
    float _481 = _469 * _327;
    float _482 = _470 * _327;
    _484 = _480;
    _485 = _481;
    _486 = _482;
  } else {
    _484 = _468;
    _485 = _469;
    _486 = _470;
  }
  bool _489 = ((uint)(cb2_028x) == 2);
  bool _490 = ((uint)(cb2_028x) == 3);
  int _491 = (uint)(cb2_028x) & -2;
  bool _492 = (_491 == 2);
  bool _493 = ((uint)(cb2_028x) == 6);
  bool _494 = _492 || _493;
  if (_494) {
    float _496 = _484 * _475;
    float _497 = _485 * _475;
    float _498 = _486 * _475;
    float _499 = _475 * _475;
    _531 = _496;
    _532 = _497;
    _533 = _498;
    _534 = _499;
  } else {
    bool _501 = ((uint)(cb2_028x) == 4);
    if (_501) {
      float _503 = _484 + -1.0f;
      float _504 = _485 + -1.0f;
      float _505 = _486 + -1.0f;
      float _506 = _475 + -1.0f;
      float _507 = _503 * _475;
      float _508 = _504 * _475;
      float _509 = _505 * _475;
      float _510 = _506 * _475;
      float _511 = _507 + 1.0f;
      float _512 = _508 + 1.0f;
      float _513 = _509 + 1.0f;
      float _514 = _510 + 1.0f;
      _531 = _511;
      _532 = _512;
      _533 = _513;
      _534 = _514;
    } else {
      bool _516 = ((uint)(cb2_028x) == 5);
      if (_516) {
        float _518 = _484 + -0.5f;
        float _519 = _485 + -0.5f;
        float _520 = _486 + -0.5f;
        float _521 = _475 + -0.5f;
        float _522 = _518 * _475;
        float _523 = _519 * _475;
        float _524 = _520 * _475;
        float _525 = _521 * _475;
        float _526 = _522 + 0.5f;
        float _527 = _523 + 0.5f;
        float _528 = _524 + 0.5f;
        float _529 = _525 + 0.5f;
        _531 = _526;
        _532 = _527;
        _533 = _528;
        _534 = _529;
      } else {
        _531 = _484;
        _532 = _485;
        _533 = _486;
        _534 = _475;
      }
    }
  }
  if (_489) {
    float _536 = _531 + _446;
    float _537 = _532 + _447;
    float _538 = _533 + _448;
    _581 = _536;
    _582 = _537;
    _583 = _538;
  } else {
    if (_490) {
      float _541 = 1.0f - _531;
      float _542 = 1.0f - _532;
      float _543 = 1.0f - _533;
      float _544 = _541 * _446;
      float _545 = _542 * _447;
      float _546 = _543 * _448;
      float _547 = _544 + _531;
      float _548 = _545 + _532;
      float _549 = _546 + _533;
      _581 = _547;
      _582 = _548;
      _583 = _549;
    } else {
      bool _551 = ((uint)(cb2_028x) == 4);
      if (_551) {
        float _553 = _531 * _446;
        float _554 = _532 * _447;
        float _555 = _533 * _448;
        _581 = _553;
        _582 = _554;
        _583 = _555;
      } else {
        bool _557 = ((uint)(cb2_028x) == 5);
        if (_557) {
          float _559 = _446 * 2.0f;
          float _560 = _559 * _531;
          float _561 = _447 * 2.0f;
          float _562 = _561 * _532;
          float _563 = _448 * 2.0f;
          float _564 = _563 * _533;
          _581 = _560;
          _582 = _562;
          _583 = _564;
        } else {
          if (_493) {
            float _567 = _446 - _531;
            float _568 = _447 - _532;
            float _569 = _448 - _533;
            _581 = _567;
            _582 = _568;
            _583 = _569;
          } else {
            float _571 = _531 - _446;
            float _572 = _532 - _447;
            float _573 = _533 - _448;
            float _574 = _534 * _571;
            float _575 = _534 * _572;
            float _576 = _534 * _573;
            float _577 = _574 + _446;
            float _578 = _575 + _447;
            float _579 = _576 + _448;
            _581 = _577;
            _582 = _578;
            _583 = _579;
          }
        }
      }
    }
  }
  float _589 = cb2_016x - _581;
  float _590 = cb2_016y - _582;
  float _591 = cb2_016z - _583;
  float _592 = _589 * cb2_016w;
  float _593 = _590 * cb2_016w;
  float _594 = _591 * cb2_016w;
  float _595 = _592 + _581;
  float _596 = _593 + _582;
  float _597 = _594 + _583;
  bool _600 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_600 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _604 = cb2_024x * _595;
    float _605 = cb2_024x * _596;
    float _606 = cb2_024x * _597;
    _608 = _604;
    _609 = _605;
    _610 = _606;
  } else {
    _608 = _595;
    _609 = _596;
    _610 = _597;
  }
  float _611 = _608 * 0.9708889722824097f;
  float _612 = mad(0.026962999254465103f, _609, _611);
  float _613 = mad(0.002148000057786703f, _610, _612);
  float _614 = _608 * 0.01088900025933981f;
  float _615 = mad(0.9869629740715027f, _609, _614);
  float _616 = mad(0.002148000057786703f, _610, _615);
  float _617 = mad(0.026962999254465103f, _609, _614);
  float _618 = mad(0.9621480107307434f, _610, _617);
  if (_600) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _623 = cb1_018y * 0.10000000149011612f;
        float _624 = log2(cb1_018z);
        float _625 = _624 + -13.287712097167969f;
        float _626 = _625 * 1.4929734468460083f;
        float _627 = _626 + 18.0f;
        float _628 = exp2(_627);
        float _629 = _628 * 0.18000000715255737f;
        float _630 = abs(_629);
        float _631 = log2(_630);
        float _632 = _631 * 1.5f;
        float _633 = exp2(_632);
        float _634 = _633 * _623;
        float _635 = _634 / cb1_018z;
        float _636 = _635 + -0.07636754959821701f;
        float _637 = _631 * 1.2750000953674316f;
        float _638 = exp2(_637);
        float _639 = _638 * 0.07636754959821701f;
        float _640 = cb1_018y * 0.011232397519052029f;
        float _641 = _640 * _633;
        float _642 = _641 / cb1_018z;
        float _643 = _639 - _642;
        float _644 = _638 + -0.11232396960258484f;
        float _645 = _644 * _623;
        float _646 = _645 / cb1_018z;
        float _647 = _646 * cb1_018z;
        float _648 = abs(_613);
        float _649 = abs(_616);
        float _650 = abs(_618);
        float _651 = log2(_648);
        float _652 = log2(_649);
        float _653 = log2(_650);
        float _654 = _651 * 1.5f;
        float _655 = _652 * 1.5f;
        float _656 = _653 * 1.5f;
        float _657 = exp2(_654);
        float _658 = exp2(_655);
        float _659 = exp2(_656);
        float _660 = _657 * _647;
        float _661 = _658 * _647;
        float _662 = _659 * _647;
        float _663 = _651 * 1.2750000953674316f;
        float _664 = _652 * 1.2750000953674316f;
        float _665 = _653 * 1.2750000953674316f;
        float _666 = exp2(_663);
        float _667 = exp2(_664);
        float _668 = exp2(_665);
        float _669 = _666 * _636;
        float _670 = _667 * _636;
        float _671 = _668 * _636;
        float _672 = _669 + _643;
        float _673 = _670 + _643;
        float _674 = _671 + _643;
        float _675 = _660 / _672;
        float _676 = _661 / _673;
        float _677 = _662 / _674;
        float _678 = _675 * 9.999999747378752e-05f;
        float _679 = _676 * 9.999999747378752e-05f;
        float _680 = _677 * 9.999999747378752e-05f;
        float _681 = 5000.0f / cb1_018y;
        float _682 = _678 * _681;
        float _683 = _679 * _681;
        float _684 = _680 * _681;
        _711 = _682;
        _712 = _683;
        _713 = _684;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_613, _616, _618));
      _711 = tonemapped.x, _712 = tonemapped.y, _713 = tonemapped.z;
    }
      } else {
        float _686 = _613 + 0.020616600289940834f;
        float _687 = _616 + 0.020616600289940834f;
        float _688 = _618 + 0.020616600289940834f;
        float _689 = _686 * _613;
        float _690 = _687 * _616;
        float _691 = _688 * _618;
        float _692 = _689 + -7.456949970219284e-05f;
        float _693 = _690 + -7.456949970219284e-05f;
        float _694 = _691 + -7.456949970219284e-05f;
        float _695 = _613 * 0.9837960004806519f;
        float _696 = _616 * 0.9837960004806519f;
        float _697 = _618 * 0.9837960004806519f;
        float _698 = _695 + 0.4336790144443512f;
        float _699 = _696 + 0.4336790144443512f;
        float _700 = _697 + 0.4336790144443512f;
        float _701 = _698 * _613;
        float _702 = _699 * _616;
        float _703 = _700 * _618;
        float _704 = _701 + 0.24617899954319f;
        float _705 = _702 + 0.24617899954319f;
        float _706 = _703 + 0.24617899954319f;
        float _707 = _692 / _704;
        float _708 = _693 / _705;
        float _709 = _694 / _706;
        _711 = _707;
        _712 = _708;
        _713 = _709;
      }
      float _714 = _711 * 1.6047500371932983f;
      float _715 = mad(-0.5310800075531006f, _712, _714);
      float _716 = mad(-0.07366999983787537f, _713, _715);
      float _717 = _711 * -0.10208000242710114f;
      float _718 = mad(1.1081299781799316f, _712, _717);
      float _719 = mad(-0.006049999967217445f, _713, _718);
      float _720 = _711 * -0.0032599999103695154f;
      float _721 = mad(-0.07275000214576721f, _712, _720);
      float _722 = mad(1.0760200023651123f, _713, _721);
      if (_600) {
        // float _724 = max(_716, 0.0f);
        // float _725 = max(_719, 0.0f);
        // float _726 = max(_722, 0.0f);
        // bool _727 = !(_724 >= 0.0030399328097701073f);
        // if (!_727) {
        //   float _729 = abs(_724);
        //   float _730 = log2(_729);
        //   float _731 = _730 * 0.4166666567325592f;
        //   float _732 = exp2(_731);
        //   float _733 = _732 * 1.0549999475479126f;
        //   float _734 = _733 + -0.054999999701976776f;
        //   _738 = _734;
        // } else {
        //   float _736 = _724 * 12.923210144042969f;
        //   _738 = _736;
        // }
        // bool _739 = !(_725 >= 0.0030399328097701073f);
        // if (!_739) {
        //   float _741 = abs(_725);
        //   float _742 = log2(_741);
        //   float _743 = _742 * 0.4166666567325592f;
        //   float _744 = exp2(_743);
        //   float _745 = _744 * 1.0549999475479126f;
        //   float _746 = _745 + -0.054999999701976776f;
        //   _750 = _746;
        // } else {
        //   float _748 = _725 * 12.923210144042969f;
        //   _750 = _748;
        // }
        // bool _751 = !(_726 >= 0.0030399328097701073f);
        // if (!_751) {
        //   float _753 = abs(_726);
        //   float _754 = log2(_753);
        //   float _755 = _754 * 0.4166666567325592f;
        //   float _756 = exp2(_755);
        //   float _757 = _756 * 1.0549999475479126f;
        //   float _758 = _757 + -0.054999999701976776f;
        //   _831 = _738;
        //   _832 = _750;
        //   _833 = _758;
        // } else {
        //   float _760 = _726 * 12.923210144042969f;
        //   _831 = _738;
        //   _832 = _750;
        //   _833 = _760;
        // }
        _831 = renodx::color::srgb::EncodeSafe(_716);
        _832 = renodx::color::srgb::EncodeSafe(_719);
        _833 = renodx::color::srgb::EncodeSafe(_722);

      } else {
        float _762 = saturate(_716);
        float _763 = saturate(_719);
        float _764 = saturate(_722);
        bool _765 = ((uint)(cb1_018w) == -2);
        if (!_765) {
          bool _767 = !(_762 >= 0.0030399328097701073f);
          if (!_767) {
            float _769 = abs(_762);
            float _770 = log2(_769);
            float _771 = _770 * 0.4166666567325592f;
            float _772 = exp2(_771);
            float _773 = _772 * 1.0549999475479126f;
            float _774 = _773 + -0.054999999701976776f;
            _778 = _774;
          } else {
            float _776 = _762 * 12.923210144042969f;
            _778 = _776;
          }
          bool _779 = !(_763 >= 0.0030399328097701073f);
          if (!_779) {
            float _781 = abs(_763);
            float _782 = log2(_781);
            float _783 = _782 * 0.4166666567325592f;
            float _784 = exp2(_783);
            float _785 = _784 * 1.0549999475479126f;
            float _786 = _785 + -0.054999999701976776f;
            _790 = _786;
          } else {
            float _788 = _763 * 12.923210144042969f;
            _790 = _788;
          }
          bool _791 = !(_764 >= 0.0030399328097701073f);
          if (!_791) {
            float _793 = abs(_764);
            float _794 = log2(_793);
            float _795 = _794 * 0.4166666567325592f;
            float _796 = exp2(_795);
            float _797 = _796 * 1.0549999475479126f;
            float _798 = _797 + -0.054999999701976776f;
            _802 = _778;
            _803 = _790;
            _804 = _798;
          } else {
            float _800 = _764 * 12.923210144042969f;
            _802 = _778;
            _803 = _790;
            _804 = _800;
          }
        } else {
          _802 = _762;
          _803 = _763;
          _804 = _764;
        }
        float _809 = abs(_802);
        float _810 = abs(_803);
        float _811 = abs(_804);
        float _812 = log2(_809);
        float _813 = log2(_810);
        float _814 = log2(_811);
        float _815 = _812 * cb2_000z;
        float _816 = _813 * cb2_000z;
        float _817 = _814 * cb2_000z;
        float _818 = exp2(_815);
        float _819 = exp2(_816);
        float _820 = exp2(_817);
        float _821 = _818 * cb2_000y;
        float _822 = _819 * cb2_000y;
        float _823 = _820 * cb2_000y;
        float _824 = _821 + cb2_000x;
        float _825 = _822 + cb2_000x;
        float _826 = _823 + cb2_000x;
        float _827 = saturate(_824);
        float _828 = saturate(_825);
        float _829 = saturate(_826);
        _831 = _827;
        _832 = _828;
        _833 = _829;
      }
      float _834 = dot(float3(_831, _832, _833), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _831;
      SV_Target.y = _832;
      SV_Target.z = _833;
      SV_Target.w = _834;
      SV_Target_1.x = _834;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
