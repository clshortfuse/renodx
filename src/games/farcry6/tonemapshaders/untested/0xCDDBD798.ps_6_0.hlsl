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
  float cb2_015x : packoffset(c015.x);
  float cb2_015y : packoffset(c015.y);
  float cb2_015z : packoffset(c015.z);
  float cb2_015w : packoffset(c015.w);
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
  float cb2_026x : packoffset(c026.x);
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
  float _22 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _24 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _28 = _24.x * 6.283199787139893f;
  float _29 = cos(_28);
  float _30 = sin(_28);
  float _31 = _29 * _24.z;
  float _32 = _30 * _24.z;
  float _33 = _31 + TEXCOORD0_centroid.x;
  float _34 = _32 + TEXCOORD0_centroid.y;
  float _35 = _33 * 10.0f;
  float _36 = 10.0f - _35;
  float _37 = min(_35, _36);
  float _38 = saturate(_37);
  float _39 = _38 * _31;
  float _40 = _34 * 10.0f;
  float _41 = 10.0f - _40;
  float _42 = min(_40, _41);
  float _43 = saturate(_42);
  float _44 = _43 * _32;
  float _45 = _39 + TEXCOORD0_centroid.x;
  float _46 = _44 + TEXCOORD0_centroid.y;
  float4 _47 = t7.SampleLevel(s2_space2, float2(_45, _46), 0.0f);
  float _49 = _47.w * _39;
  float _50 = _47.w * _44;
  float _51 = 1.0f - _24.y;
  float _52 = saturate(_51);
  float _53 = _49 * _52;
  float _54 = _50 * _52;
  float _58 = cb2_015x * TEXCOORD0_centroid.x;
  float _59 = cb2_015y * TEXCOORD0_centroid.y;
  float _62 = _58 + cb2_015z;
  float _63 = _59 + cb2_015w;
  float4 _64 = t8.SampleLevel(s0_space2, float2(_62, _63), 0.0f);
  float _68 = saturate(_64.x);
  float _69 = saturate(_64.z);
  float _72 = cb2_026x * _69;
  float _73 = _68 * 6.283199787139893f;
  float _74 = cos(_73);
  float _75 = sin(_73);
  float _76 = _72 * _74;
  float _77 = _75 * _72;
  float _78 = 1.0f - _64.y;
  float _79 = saturate(_78);
  float _80 = _76 * _79;
  float _81 = _77 * _79;
  float _82 = _53 + TEXCOORD0_centroid.x;
  float _83 = _82 + _80;
  float _84 = _54 + TEXCOORD0_centroid.y;
  float _85 = _84 + _81;
  float4 _86 = t7.SampleLevel(s2_space2, float2(_83, _85), 0.0f);
  bool _88 = (_86.y > 0.0f);
  float _89 = select(_88, TEXCOORD0_centroid.x, _83);
  float _90 = select(_88, TEXCOORD0_centroid.y, _85);
  float4 _91 = t1.SampleLevel(s4_space2, float2(_89, _90), 0.0f);
  float _95 = max(_91.x, 0.0f);
  float _96 = max(_91.y, 0.0f);
  float _97 = max(_91.z, 0.0f);
  float _98 = min(_95, 65000.0f);
  float _99 = min(_96, 65000.0f);
  float _100 = min(_97, 65000.0f);
  float4 _101 = t3.SampleLevel(s2_space2, float2(_89, _90), 0.0f);
  float _106 = max(_101.x, 0.0f);
  float _107 = max(_101.y, 0.0f);
  float _108 = max(_101.z, 0.0f);
  float _109 = max(_101.w, 0.0f);
  float _110 = min(_106, 5000.0f);
  float _111 = min(_107, 5000.0f);
  float _112 = min(_108, 5000.0f);
  float _113 = min(_109, 5000.0f);
  float _116 = _22.x * cb0_028z;
  float _117 = _116 + cb0_028x;
  float _118 = cb2_027w / _117;
  float _119 = 1.0f - _118;
  float _120 = abs(_119);
  float _122 = cb2_027y * _120;
  float _124 = _122 - cb2_027z;
  float _125 = saturate(_124);
  float _126 = max(_125, _113);
  float _127 = saturate(_126);
  float _131 = cb2_013x * _89;
  float _132 = cb2_013y * _90;
  float _135 = _131 + cb2_013z;
  float _136 = _132 + cb2_013w;
  float _139 = dot(float2(_135, _136), float2(_135, _136));
  float _140 = abs(_139);
  float _141 = log2(_140);
  float _142 = _141 * cb2_014x;
  float _143 = exp2(_142);
  float _144 = saturate(_143);
  float _148 = cb2_011x * _89;
  float _149 = cb2_011y * _90;
  float _152 = _148 + cb2_011z;
  float _153 = _149 + cb2_011w;
  float _154 = _152 * _144;
  float _155 = _153 * _144;
  float _156 = _154 + _89;
  float _157 = _155 + _90;
  float _161 = cb2_012x * _89;
  float _162 = cb2_012y * _90;
  float _165 = _161 + cb2_012z;
  float _166 = _162 + cb2_012w;
  float _167 = _165 * _144;
  float _168 = _166 * _144;
  float _169 = _167 + _89;
  float _170 = _168 + _90;
  float4 _171 = t1.SampleLevel(s2_space2, float2(_156, _157), 0.0f);
  float _175 = max(_171.x, 0.0f);
  float _176 = max(_171.y, 0.0f);
  float _177 = max(_171.z, 0.0f);
  float _178 = min(_175, 65000.0f);
  float _179 = min(_176, 65000.0f);
  float _180 = min(_177, 65000.0f);
  float4 _181 = t1.SampleLevel(s2_space2, float2(_169, _170), 0.0f);
  float _185 = max(_181.x, 0.0f);
  float _186 = max(_181.y, 0.0f);
  float _187 = max(_181.z, 0.0f);
  float _188 = min(_185, 65000.0f);
  float _189 = min(_186, 65000.0f);
  float _190 = min(_187, 65000.0f);
  float4 _191 = t3.SampleLevel(s2_space2, float2(_156, _157), 0.0f);
  float _195 = max(_191.x, 0.0f);
  float _196 = max(_191.y, 0.0f);
  float _197 = max(_191.z, 0.0f);
  float _198 = min(_195, 5000.0f);
  float _199 = min(_196, 5000.0f);
  float _200 = min(_197, 5000.0f);
  float4 _201 = t3.SampleLevel(s2_space2, float2(_169, _170), 0.0f);
  float _205 = max(_201.x, 0.0f);
  float _206 = max(_201.y, 0.0f);
  float _207 = max(_201.z, 0.0f);
  float _208 = min(_205, 5000.0f);
  float _209 = min(_206, 5000.0f);
  float _210 = min(_207, 5000.0f);
  float _215 = 1.0f - cb2_009x;
  float _216 = 1.0f - cb2_009y;
  float _217 = 1.0f - cb2_009z;
  float _222 = _215 - cb2_010x;
  float _223 = _216 - cb2_010y;
  float _224 = _217 - cb2_010z;
  float _225 = saturate(_222);
  float _226 = saturate(_223);
  float _227 = saturate(_224);
  float _228 = _225 * _98;
  float _229 = _226 * _99;
  float _230 = _227 * _100;
  float _231 = cb2_009x * _178;
  float _232 = cb2_009y * _179;
  float _233 = cb2_009z * _180;
  float _234 = _231 + _228;
  float _235 = _232 + _229;
  float _236 = _233 + _230;
  float _237 = cb2_010x * _188;
  float _238 = cb2_010y * _189;
  float _239 = cb2_010z * _190;
  float _240 = _234 + _237;
  float _241 = _235 + _238;
  float _242 = _236 + _239;
  float _243 = _225 * _110;
  float _244 = _226 * _111;
  float _245 = _227 * _112;
  float _246 = cb2_009x * _198;
  float _247 = cb2_009y * _199;
  float _248 = cb2_009z * _200;
  float _249 = cb2_010x * _208;
  float _250 = cb2_010y * _209;
  float _251 = cb2_010z * _210;
  float4 _252 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _256 = _243 - _240;
  float _257 = _256 + _246;
  float _258 = _257 + _249;
  float _259 = _244 - _241;
  float _260 = _259 + _247;
  float _261 = _260 + _250;
  float _262 = _245 - _242;
  float _263 = _262 + _248;
  float _264 = _263 + _251;
  float _265 = _258 * _127;
  float _266 = _261 * _127;
  float _267 = _264 * _127;
  float _268 = _265 + _240;
  float _269 = _266 + _241;
  float _270 = _267 + _242;
  float _271 = dot(float3(_268, _269, _270), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _275 = t0[0].SExposureData_020;
  float _277 = t0[0].SExposureData_004;
  float _279 = cb2_018x * 0.5f;
  float _280 = _279 * cb2_018y;
  float _281 = _277.x - _280;
  float _282 = cb2_018y * cb2_018x;
  float _283 = 1.0f / _282;
  float _284 = _281 * _283;
  float _285 = _271 / _275.x;
  float _286 = _285 * 5464.01611328125f;
  float _287 = _286 + 9.99999993922529e-09f;
  float _288 = log2(_287);
  float _289 = _288 - _281;
  float _290 = _289 * _283;
  float _291 = saturate(_290);
  float2 _292 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _291), 0.0f);
  float _295 = max(_292.y, 1.0000000116860974e-07f);
  float _296 = _292.x / _295;
  float _297 = _296 + _284;
  float _298 = _297 / _283;
  float _299 = _298 - _277.x;
  float _300 = -0.0f - _299;
  float _302 = _300 - cb2_027x;
  float _303 = max(0.0f, _302);
  float _305 = cb2_026z * _303;
  float _306 = _299 - cb2_027x;
  float _307 = max(0.0f, _306);
  float _309 = cb2_026w * _307;
  bool _310 = (_299 < 0.0f);
  float _311 = select(_310, _305, _309);
  float _312 = exp2(_311);
  float _313 = _312 * _268;
  float _314 = _312 * _269;
  float _315 = _312 * _270;
  float _320 = cb2_024y * _252.x;
  float _321 = cb2_024z * _252.y;
  float _322 = cb2_024w * _252.z;
  float _323 = _320 + _313;
  float _324 = _321 + _314;
  float _325 = _322 + _315;
  float _330 = _323 * cb2_025x;
  float _331 = _324 * cb2_025y;
  float _332 = _325 * cb2_025z;
  float _333 = dot(float3(_330, _331, _332), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _334 = t0[0].SExposureData_012;
  float _336 = _333 * 5464.01611328125f;
  float _337 = _336 * _334.x;
  float _338 = _337 + 9.99999993922529e-09f;
  float _339 = log2(_338);
  float _340 = _339 + 16.929765701293945f;
  float _341 = _340 * 0.05734497308731079f;
  float _342 = saturate(_341);
  float _343 = _342 * _342;
  float _344 = _342 * 2.0f;
  float _345 = 3.0f - _344;
  float _346 = _343 * _345;
  float _347 = _331 * 0.8450999855995178f;
  float _348 = _332 * 0.14589999616146088f;
  float _349 = _347 + _348;
  float _350 = _349 * 2.4890189170837402f;
  float _351 = _349 * 0.3754962384700775f;
  float _352 = _349 * 2.811495304107666f;
  float _353 = _349 * 5.519708156585693f;
  float _354 = _333 - _350;
  float _355 = _346 * _354;
  float _356 = _355 + _350;
  float _357 = _346 * 0.5f;
  float _358 = _357 + 0.5f;
  float _359 = _358 * _354;
  float _360 = _359 + _350;
  float _361 = _330 - _351;
  float _362 = _331 - _352;
  float _363 = _332 - _353;
  float _364 = _358 * _361;
  float _365 = _358 * _362;
  float _366 = _358 * _363;
  float _367 = _364 + _351;
  float _368 = _365 + _352;
  float _369 = _366 + _353;
  float _370 = 1.0f / _360;
  float _371 = _356 * _370;
  float _372 = _371 * _367;
  float _373 = _371 * _368;
  float _374 = _371 * _369;
  float _378 = cb2_020x * TEXCOORD0_centroid.x;
  float _379 = cb2_020y * TEXCOORD0_centroid.y;
  float _382 = _378 + cb2_020z;
  float _383 = _379 + cb2_020w;
  float _386 = dot(float2(_382, _383), float2(_382, _383));
  float _387 = 1.0f - _386;
  float _388 = saturate(_387);
  float _389 = log2(_388);
  float _390 = _389 * cb2_021w;
  float _391 = exp2(_390);
  float _395 = _372 - cb2_021x;
  float _396 = _373 - cb2_021y;
  float _397 = _374 - cb2_021z;
  float _398 = _395 * _391;
  float _399 = _396 * _391;
  float _400 = _397 * _391;
  float _401 = _398 + cb2_021x;
  float _402 = _399 + cb2_021y;
  float _403 = _400 + cb2_021z;
  float _404 = t0[0].SExposureData_000;
  float _406 = max(_275.x, 0.0010000000474974513f);
  float _407 = 1.0f / _406;
  float _408 = _407 * _404.x;
  bool _411 = ((uint)(cb2_069y) == 0);
  float _417;
  float _418;
  float _419;
  float _473;
  float _474;
  float _475;
  float _520;
  float _521;
  float _522;
  float _567;
  float _568;
  float _569;
  float _570;
  float _617;
  float _618;
  float _619;
  float _644;
  float _645;
  float _646;
  float _747;
  float _748;
  float _749;
  float _774;
  float _786;
  float _814;
  float _826;
  float _838;
  float _839;
  float _840;
  float _867;
  float _868;
  float _869;
  if (!_411) {
    float _413 = _408 * _401;
    float _414 = _408 * _402;
    float _415 = _408 * _403;
    _417 = _413;
    _418 = _414;
    _419 = _415;
  } else {
    _417 = _401;
    _418 = _402;
    _419 = _403;
  }
  float _420 = _417 * 0.6130970120429993f;
  float _421 = mad(0.33952298760414124f, _418, _420);
  float _422 = mad(0.04737899824976921f, _419, _421);
  float _423 = _417 * 0.07019399851560593f;
  float _424 = mad(0.9163540005683899f, _418, _423);
  float _425 = mad(0.013451999984681606f, _419, _424);
  float _426 = _417 * 0.02061600051820278f;
  float _427 = mad(0.10956999659538269f, _418, _426);
  float _428 = mad(0.8698149919509888f, _419, _427);
  float _429 = log2(_422);
  float _430 = log2(_425);
  float _431 = log2(_428);
  float _432 = _429 * 0.04211956635117531f;
  float _433 = _430 * 0.04211956635117531f;
  float _434 = _431 * 0.04211956635117531f;
  float _435 = _432 + 0.6252607107162476f;
  float _436 = _433 + 0.6252607107162476f;
  float _437 = _434 + 0.6252607107162476f;
  float4 _438 = t5.SampleLevel(s2_space2, float3(_435, _436, _437), 0.0f);
  bool _444 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_444 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _448 = cb2_017x * _438.x;
    float _449 = cb2_017x * _438.y;
    float _450 = cb2_017x * _438.z;
    float _452 = _448 + cb2_017y;
    float _453 = _449 + cb2_017y;
    float _454 = _450 + cb2_017y;
    float _455 = exp2(_452);
    float _456 = exp2(_453);
    float _457 = exp2(_454);
    float _458 = _455 + 1.0f;
    float _459 = _456 + 1.0f;
    float _460 = _457 + 1.0f;
    float _461 = 1.0f / _458;
    float _462 = 1.0f / _459;
    float _463 = 1.0f / _460;
    float _465 = cb2_017z * _461;
    float _466 = cb2_017z * _462;
    float _467 = cb2_017z * _463;
    float _469 = _465 + cb2_017w;
    float _470 = _466 + cb2_017w;
    float _471 = _467 + cb2_017w;
    _473 = _469;
    _474 = _470;
    _475 = _471;
  } else {
    _473 = _438.x;
    _474 = _438.y;
    _475 = _438.z;
  }
  float _476 = _473 * 23.0f;
  float _477 = _476 + -14.473931312561035f;
  float _478 = exp2(_477);
  float _479 = _474 * 23.0f;
  float _480 = _479 + -14.473931312561035f;
  float _481 = exp2(_480);
  float _482 = _475 * 23.0f;
  float _483 = _482 + -14.473931312561035f;
  float _484 = exp2(_483);
  float _488 = cb2_004x * TEXCOORD0_centroid.x;
  float _489 = cb2_004y * TEXCOORD0_centroid.y;
  float _492 = _488 + cb2_004z;
  float _493 = _489 + cb2_004w;
  float4 _499 = t6.Sample(s2_space2, float2(_492, _493));
  float _504 = _499.x * cb2_003x;
  float _505 = _499.y * cb2_003y;
  float _506 = _499.z * cb2_003z;
  float _507 = _499.w * cb2_003w;
  float _510 = _507 + cb2_026y;
  float _511 = saturate(_510);
  bool _514 = ((uint)(cb2_069y) == 0);
  if (!_514) {
    float _516 = _504 * _408;
    float _517 = _505 * _408;
    float _518 = _506 * _408;
    _520 = _516;
    _521 = _517;
    _522 = _518;
  } else {
    _520 = _504;
    _521 = _505;
    _522 = _506;
  }
  bool _525 = ((uint)(cb2_028x) == 2);
  bool _526 = ((uint)(cb2_028x) == 3);
  int _527 = (uint)(cb2_028x) & -2;
  bool _528 = (_527 == 2);
  bool _529 = ((uint)(cb2_028x) == 6);
  bool _530 = _528 || _529;
  if (_530) {
    float _532 = _520 * _511;
    float _533 = _521 * _511;
    float _534 = _522 * _511;
    float _535 = _511 * _511;
    _567 = _532;
    _568 = _533;
    _569 = _534;
    _570 = _535;
  } else {
    bool _537 = ((uint)(cb2_028x) == 4);
    if (_537) {
      float _539 = _520 + -1.0f;
      float _540 = _521 + -1.0f;
      float _541 = _522 + -1.0f;
      float _542 = _511 + -1.0f;
      float _543 = _539 * _511;
      float _544 = _540 * _511;
      float _545 = _541 * _511;
      float _546 = _542 * _511;
      float _547 = _543 + 1.0f;
      float _548 = _544 + 1.0f;
      float _549 = _545 + 1.0f;
      float _550 = _546 + 1.0f;
      _567 = _547;
      _568 = _548;
      _569 = _549;
      _570 = _550;
    } else {
      bool _552 = ((uint)(cb2_028x) == 5);
      if (_552) {
        float _554 = _520 + -0.5f;
        float _555 = _521 + -0.5f;
        float _556 = _522 + -0.5f;
        float _557 = _511 + -0.5f;
        float _558 = _554 * _511;
        float _559 = _555 * _511;
        float _560 = _556 * _511;
        float _561 = _557 * _511;
        float _562 = _558 + 0.5f;
        float _563 = _559 + 0.5f;
        float _564 = _560 + 0.5f;
        float _565 = _561 + 0.5f;
        _567 = _562;
        _568 = _563;
        _569 = _564;
        _570 = _565;
      } else {
        _567 = _520;
        _568 = _521;
        _569 = _522;
        _570 = _511;
      }
    }
  }
  if (_525) {
    float _572 = _567 + _478;
    float _573 = _568 + _481;
    float _574 = _569 + _484;
    _617 = _572;
    _618 = _573;
    _619 = _574;
  } else {
    if (_526) {
      float _577 = 1.0f - _567;
      float _578 = 1.0f - _568;
      float _579 = 1.0f - _569;
      float _580 = _577 * _478;
      float _581 = _578 * _481;
      float _582 = _579 * _484;
      float _583 = _580 + _567;
      float _584 = _581 + _568;
      float _585 = _582 + _569;
      _617 = _583;
      _618 = _584;
      _619 = _585;
    } else {
      bool _587 = ((uint)(cb2_028x) == 4);
      if (_587) {
        float _589 = _567 * _478;
        float _590 = _568 * _481;
        float _591 = _569 * _484;
        _617 = _589;
        _618 = _590;
        _619 = _591;
      } else {
        bool _593 = ((uint)(cb2_028x) == 5);
        if (_593) {
          float _595 = _478 * 2.0f;
          float _596 = _595 * _567;
          float _597 = _481 * 2.0f;
          float _598 = _597 * _568;
          float _599 = _484 * 2.0f;
          float _600 = _599 * _569;
          _617 = _596;
          _618 = _598;
          _619 = _600;
        } else {
          if (_529) {
            float _603 = _478 - _567;
            float _604 = _481 - _568;
            float _605 = _484 - _569;
            _617 = _603;
            _618 = _604;
            _619 = _605;
          } else {
            float _607 = _567 - _478;
            float _608 = _568 - _481;
            float _609 = _569 - _484;
            float _610 = _570 * _607;
            float _611 = _570 * _608;
            float _612 = _570 * _609;
            float _613 = _610 + _478;
            float _614 = _611 + _481;
            float _615 = _612 + _484;
            _617 = _613;
            _618 = _614;
            _619 = _615;
          }
        }
      }
    }
  }
  float _625 = cb2_016x - _617;
  float _626 = cb2_016y - _618;
  float _627 = cb2_016z - _619;
  float _628 = _625 * cb2_016w;
  float _629 = _626 * cb2_016w;
  float _630 = _627 * cb2_016w;
  float _631 = _628 + _617;
  float _632 = _629 + _618;
  float _633 = _630 + _619;
  bool _636 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_636 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _640 = cb2_024x * _631;
    float _641 = cb2_024x * _632;
    float _642 = cb2_024x * _633;
    _644 = _640;
    _645 = _641;
    _646 = _642;
  } else {
    _644 = _631;
    _645 = _632;
    _646 = _633;
  }
  float _647 = _644 * 0.9708889722824097f;
  float _648 = mad(0.026962999254465103f, _645, _647);
  float _649 = mad(0.002148000057786703f, _646, _648);
  float _650 = _644 * 0.01088900025933981f;
  float _651 = mad(0.9869629740715027f, _645, _650);
  float _652 = mad(0.002148000057786703f, _646, _651);
  float _653 = mad(0.026962999254465103f, _645, _650);
  float _654 = mad(0.9621480107307434f, _646, _653);
  if (_636) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _659 = cb1_018y * 0.10000000149011612f;
        float _660 = log2(cb1_018z);
        float _661 = _660 + -13.287712097167969f;
        float _662 = _661 * 1.4929734468460083f;
        float _663 = _662 + 18.0f;
        float _664 = exp2(_663);
        float _665 = _664 * 0.18000000715255737f;
        float _666 = abs(_665);
        float _667 = log2(_666);
        float _668 = _667 * 1.5f;
        float _669 = exp2(_668);
        float _670 = _669 * _659;
        float _671 = _670 / cb1_018z;
        float _672 = _671 + -0.07636754959821701f;
        float _673 = _667 * 1.2750000953674316f;
        float _674 = exp2(_673);
        float _675 = _674 * 0.07636754959821701f;
        float _676 = cb1_018y * 0.011232397519052029f;
        float _677 = _676 * _669;
        float _678 = _677 / cb1_018z;
        float _679 = _675 - _678;
        float _680 = _674 + -0.11232396960258484f;
        float _681 = _680 * _659;
        float _682 = _681 / cb1_018z;
        float _683 = _682 * cb1_018z;
        float _684 = abs(_649);
        float _685 = abs(_652);
        float _686 = abs(_654);
        float _687 = log2(_684);
        float _688 = log2(_685);
        float _689 = log2(_686);
        float _690 = _687 * 1.5f;
        float _691 = _688 * 1.5f;
        float _692 = _689 * 1.5f;
        float _693 = exp2(_690);
        float _694 = exp2(_691);
        float _695 = exp2(_692);
        float _696 = _693 * _683;
        float _697 = _694 * _683;
        float _698 = _695 * _683;
        float _699 = _687 * 1.2750000953674316f;
        float _700 = _688 * 1.2750000953674316f;
        float _701 = _689 * 1.2750000953674316f;
        float _702 = exp2(_699);
        float _703 = exp2(_700);
        float _704 = exp2(_701);
        float _705 = _702 * _672;
        float _706 = _703 * _672;
        float _707 = _704 * _672;
        float _708 = _705 + _679;
        float _709 = _706 + _679;
        float _710 = _707 + _679;
        float _711 = _696 / _708;
        float _712 = _697 / _709;
        float _713 = _698 / _710;
        float _714 = _711 * 9.999999747378752e-05f;
        float _715 = _712 * 9.999999747378752e-05f;
        float _716 = _713 * 9.999999747378752e-05f;
        float _717 = 5000.0f / cb1_018y;
        float _718 = _714 * _717;
        float _719 = _715 * _717;
        float _720 = _716 * _717;
        _747 = _718;
        _748 = _719;
        _749 = _720;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_649, _652, _654));
      _747 = tonemapped.x, _748 = tonemapped.y, _749 = tonemapped.z;
    }
      } else {
        float _722 = _649 + 0.020616600289940834f;
        float _723 = _652 + 0.020616600289940834f;
        float _724 = _654 + 0.020616600289940834f;
        float _725 = _722 * _649;
        float _726 = _723 * _652;
        float _727 = _724 * _654;
        float _728 = _725 + -7.456949970219284e-05f;
        float _729 = _726 + -7.456949970219284e-05f;
        float _730 = _727 + -7.456949970219284e-05f;
        float _731 = _649 * 0.9837960004806519f;
        float _732 = _652 * 0.9837960004806519f;
        float _733 = _654 * 0.9837960004806519f;
        float _734 = _731 + 0.4336790144443512f;
        float _735 = _732 + 0.4336790144443512f;
        float _736 = _733 + 0.4336790144443512f;
        float _737 = _734 * _649;
        float _738 = _735 * _652;
        float _739 = _736 * _654;
        float _740 = _737 + 0.24617899954319f;
        float _741 = _738 + 0.24617899954319f;
        float _742 = _739 + 0.24617899954319f;
        float _743 = _728 / _740;
        float _744 = _729 / _741;
        float _745 = _730 / _742;
        _747 = _743;
        _748 = _744;
        _749 = _745;
      }
      float _750 = _747 * 1.6047500371932983f;
      float _751 = mad(-0.5310800075531006f, _748, _750);
      float _752 = mad(-0.07366999983787537f, _749, _751);
      float _753 = _747 * -0.10208000242710114f;
      float _754 = mad(1.1081299781799316f, _748, _753);
      float _755 = mad(-0.006049999967217445f, _749, _754);
      float _756 = _747 * -0.0032599999103695154f;
      float _757 = mad(-0.07275000214576721f, _748, _756);
      float _758 = mad(1.0760200023651123f, _749, _757);
      if (_636) {
        // float _760 = max(_752, 0.0f);
        // float _761 = max(_755, 0.0f);
        // float _762 = max(_758, 0.0f);
        // bool _763 = !(_760 >= 0.0030399328097701073f);
        // if (!_763) {
        //   float _765 = abs(_760);
        //   float _766 = log2(_765);
        //   float _767 = _766 * 0.4166666567325592f;
        //   float _768 = exp2(_767);
        //   float _769 = _768 * 1.0549999475479126f;
        //   float _770 = _769 + -0.054999999701976776f;
        //   _774 = _770;
        // } else {
        //   float _772 = _760 * 12.923210144042969f;
        //   _774 = _772;
        // }
        // bool _775 = !(_761 >= 0.0030399328097701073f);
        // if (!_775) {
        //   float _777 = abs(_761);
        //   float _778 = log2(_777);
        //   float _779 = _778 * 0.4166666567325592f;
        //   float _780 = exp2(_779);
        //   float _781 = _780 * 1.0549999475479126f;
        //   float _782 = _781 + -0.054999999701976776f;
        //   _786 = _782;
        // } else {
        //   float _784 = _761 * 12.923210144042969f;
        //   _786 = _784;
        // }
        // bool _787 = !(_762 >= 0.0030399328097701073f);
        // if (!_787) {
        //   float _789 = abs(_762);
        //   float _790 = log2(_789);
        //   float _791 = _790 * 0.4166666567325592f;
        //   float _792 = exp2(_791);
        //   float _793 = _792 * 1.0549999475479126f;
        //   float _794 = _793 + -0.054999999701976776f;
        //   _867 = _774;
        //   _868 = _786;
        //   _869 = _794;
        // } else {
        //   float _796 = _762 * 12.923210144042969f;
        //   _867 = _774;
        //   _868 = _786;
        //   _869 = _796;
        // }
        _867 = renodx::color::srgb::EncodeSafe(_752);
        _868 = renodx::color::srgb::EncodeSafe(_755);
        _869 = renodx::color::srgb::EncodeSafe(_758);

      } else {
        float _798 = saturate(_752);
        float _799 = saturate(_755);
        float _800 = saturate(_758);
        bool _801 = ((uint)(cb1_018w) == -2);
        if (!_801) {
          bool _803 = !(_798 >= 0.0030399328097701073f);
          if (!_803) {
            float _805 = abs(_798);
            float _806 = log2(_805);
            float _807 = _806 * 0.4166666567325592f;
            float _808 = exp2(_807);
            float _809 = _808 * 1.0549999475479126f;
            float _810 = _809 + -0.054999999701976776f;
            _814 = _810;
          } else {
            float _812 = _798 * 12.923210144042969f;
            _814 = _812;
          }
          bool _815 = !(_799 >= 0.0030399328097701073f);
          if (!_815) {
            float _817 = abs(_799);
            float _818 = log2(_817);
            float _819 = _818 * 0.4166666567325592f;
            float _820 = exp2(_819);
            float _821 = _820 * 1.0549999475479126f;
            float _822 = _821 + -0.054999999701976776f;
            _826 = _822;
          } else {
            float _824 = _799 * 12.923210144042969f;
            _826 = _824;
          }
          bool _827 = !(_800 >= 0.0030399328097701073f);
          if (!_827) {
            float _829 = abs(_800);
            float _830 = log2(_829);
            float _831 = _830 * 0.4166666567325592f;
            float _832 = exp2(_831);
            float _833 = _832 * 1.0549999475479126f;
            float _834 = _833 + -0.054999999701976776f;
            _838 = _814;
            _839 = _826;
            _840 = _834;
          } else {
            float _836 = _800 * 12.923210144042969f;
            _838 = _814;
            _839 = _826;
            _840 = _836;
          }
        } else {
          _838 = _798;
          _839 = _799;
          _840 = _800;
        }
        float _845 = abs(_838);
        float _846 = abs(_839);
        float _847 = abs(_840);
        float _848 = log2(_845);
        float _849 = log2(_846);
        float _850 = log2(_847);
        float _851 = _848 * cb2_000z;
        float _852 = _849 * cb2_000z;
        float _853 = _850 * cb2_000z;
        float _854 = exp2(_851);
        float _855 = exp2(_852);
        float _856 = exp2(_853);
        float _857 = _854 * cb2_000y;
        float _858 = _855 * cb2_000y;
        float _859 = _856 * cb2_000y;
        float _860 = _857 + cb2_000x;
        float _861 = _858 + cb2_000x;
        float _862 = _859 + cb2_000x;
        float _863 = saturate(_860);
        float _864 = saturate(_861);
        float _865 = saturate(_862);
        _867 = _863;
        _868 = _864;
        _869 = _865;
      }
      float _870 = dot(float3(_867, _868, _869), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _867;
      SV_Target.y = _868;
      SV_Target.z = _869;
      SV_Target.w = _870;
      SV_Target_1.x = _870;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
