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

Texture3D<float2> t7 : register(t7);

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
  float _19 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _21 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _25 = max(_21.x, 0.0f);
  float _26 = max(_21.y, 0.0f);
  float _27 = max(_21.z, 0.0f);
  float _28 = min(_25, 65000.0f);
  float _29 = min(_26, 65000.0f);
  float _30 = min(_27, 65000.0f);
  float4 _31 = t3.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _36 = max(_31.x, 0.0f);
  float _37 = max(_31.y, 0.0f);
  float _38 = max(_31.z, 0.0f);
  float _39 = max(_31.w, 0.0f);
  float _40 = min(_36, 5000.0f);
  float _41 = min(_37, 5000.0f);
  float _42 = min(_38, 5000.0f);
  float _43 = min(_39, 5000.0f);
  float _46 = _19.x * cb0_028z;
  float _47 = _46 + cb0_028x;
  float _48 = cb2_027w / _47;
  float _49 = 1.0f - _48;
  float _50 = abs(_49);
  float _52 = cb2_027y * _50;
  float _54 = _52 - cb2_027z;
  float _55 = saturate(_54);
  float _56 = max(_55, _43);
  float _57 = saturate(_56);
  float _61 = cb2_013x * TEXCOORD0_centroid.x;
  float _62 = cb2_013y * TEXCOORD0_centroid.y;
  float _65 = _61 + cb2_013z;
  float _66 = _62 + cb2_013w;
  float _69 = dot(float2(_65, _66), float2(_65, _66));
  float _70 = abs(_69);
  float _71 = log2(_70);
  float _72 = _71 * cb2_014x;
  float _73 = exp2(_72);
  float _74 = saturate(_73);
  float _78 = cb2_011x * TEXCOORD0_centroid.x;
  float _79 = cb2_011y * TEXCOORD0_centroid.y;
  float _82 = _78 + cb2_011z;
  float _83 = _79 + cb2_011w;
  float _84 = _82 * _74;
  float _85 = _83 * _74;
  float _86 = _84 + TEXCOORD0_centroid.x;
  float _87 = _85 + TEXCOORD0_centroid.y;
  float _91 = cb2_012x * TEXCOORD0_centroid.x;
  float _92 = cb2_012y * TEXCOORD0_centroid.y;
  float _95 = _91 + cb2_012z;
  float _96 = _92 + cb2_012w;
  float _97 = _95 * _74;
  float _98 = _96 * _74;
  float _99 = _97 + TEXCOORD0_centroid.x;
  float _100 = _98 + TEXCOORD0_centroid.y;
  float4 _101 = t1.SampleLevel(s2_space2, float2(_86, _87), 0.0f);
  float _105 = max(_101.x, 0.0f);
  float _106 = max(_101.y, 0.0f);
  float _107 = max(_101.z, 0.0f);
  float _108 = min(_105, 65000.0f);
  float _109 = min(_106, 65000.0f);
  float _110 = min(_107, 65000.0f);
  float4 _111 = t1.SampleLevel(s2_space2, float2(_99, _100), 0.0f);
  float _115 = max(_111.x, 0.0f);
  float _116 = max(_111.y, 0.0f);
  float _117 = max(_111.z, 0.0f);
  float _118 = min(_115, 65000.0f);
  float _119 = min(_116, 65000.0f);
  float _120 = min(_117, 65000.0f);
  float4 _121 = t3.SampleLevel(s2_space2, float2(_86, _87), 0.0f);
  float _125 = max(_121.x, 0.0f);
  float _126 = max(_121.y, 0.0f);
  float _127 = max(_121.z, 0.0f);
  float _128 = min(_125, 5000.0f);
  float _129 = min(_126, 5000.0f);
  float _130 = min(_127, 5000.0f);
  float4 _131 = t3.SampleLevel(s2_space2, float2(_99, _100), 0.0f);
  float _135 = max(_131.x, 0.0f);
  float _136 = max(_131.y, 0.0f);
  float _137 = max(_131.z, 0.0f);
  float _138 = min(_135, 5000.0f);
  float _139 = min(_136, 5000.0f);
  float _140 = min(_137, 5000.0f);
  float _145 = 1.0f - cb2_009x;
  float _146 = 1.0f - cb2_009y;
  float _147 = 1.0f - cb2_009z;
  float _152 = _145 - cb2_010x;
  float _153 = _146 - cb2_010y;
  float _154 = _147 - cb2_010z;
  float _155 = saturate(_152);
  float _156 = saturate(_153);
  float _157 = saturate(_154);
  float _158 = _155 * _28;
  float _159 = _156 * _29;
  float _160 = _157 * _30;
  float _161 = cb2_009x * _108;
  float _162 = cb2_009y * _109;
  float _163 = cb2_009z * _110;
  float _164 = _161 + _158;
  float _165 = _162 + _159;
  float _166 = _163 + _160;
  float _167 = cb2_010x * _118;
  float _168 = cb2_010y * _119;
  float _169 = cb2_010z * _120;
  float _170 = _164 + _167;
  float _171 = _165 + _168;
  float _172 = _166 + _169;
  float _173 = _155 * _40;
  float _174 = _156 * _41;
  float _175 = _157 * _42;
  float _176 = cb2_009x * _128;
  float _177 = cb2_009y * _129;
  float _178 = cb2_009z * _130;
  float _179 = cb2_010x * _138;
  float _180 = cb2_010y * _139;
  float _181 = cb2_010z * _140;
  float4 _182 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _186 = _173 - _170;
  float _187 = _186 + _176;
  float _188 = _187 + _179;
  float _189 = _174 - _171;
  float _190 = _189 + _177;
  float _191 = _190 + _180;
  float _192 = _175 - _172;
  float _193 = _192 + _178;
  float _194 = _193 + _181;
  float _195 = _188 * _57;
  float _196 = _191 * _57;
  float _197 = _194 * _57;
  float _198 = _195 + _170;
  float _199 = _196 + _171;
  float _200 = _197 + _172;
  float _201 = dot(float3(_198, _199, _200), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _205 = t0[0].SExposureData_020;
  float _207 = t0[0].SExposureData_004;
  float _209 = cb2_018x * 0.5f;
  float _210 = _209 * cb2_018y;
  float _211 = _207.x - _210;
  float _212 = cb2_018y * cb2_018x;
  float _213 = 1.0f / _212;
  float _214 = _211 * _213;
  float _215 = _201 / _205.x;
  float _216 = _215 * 5464.01611328125f;
  float _217 = _216 + 9.99999993922529e-09f;
  float _218 = log2(_217);
  float _219 = _218 - _211;
  float _220 = _219 * _213;
  float _221 = saturate(_220);
  float2 _222 = t7.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _221), 0.0f);
  float _225 = max(_222.y, 1.0000000116860974e-07f);
  float _226 = _222.x / _225;
  float _227 = _226 + _214;
  float _228 = _227 / _213;
  float _229 = _228 - _207.x;
  float _230 = -0.0f - _229;
  float _232 = _230 - cb2_027x;
  float _233 = max(0.0f, _232);
  float _236 = cb2_026z * _233;
  float _237 = _229 - cb2_027x;
  float _238 = max(0.0f, _237);
  float _240 = cb2_026w * _238;
  bool _241 = (_229 < 0.0f);
  float _242 = select(_241, _236, _240);
  float _243 = exp2(_242);
  float _244 = _243 * _198;
  float _245 = _243 * _199;
  float _246 = _243 * _200;
  float _251 = cb2_024y * _182.x;
  float _252 = cb2_024z * _182.y;
  float _253 = cb2_024w * _182.z;
  float _254 = _251 + _244;
  float _255 = _252 + _245;
  float _256 = _253 + _246;
  float _261 = _254 * cb2_025x;
  float _262 = _255 * cb2_025y;
  float _263 = _256 * cb2_025z;
  float _264 = dot(float3(_261, _262, _263), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _265 = t0[0].SExposureData_012;
  float _267 = _264 * 5464.01611328125f;
  float _268 = _267 * _265.x;
  float _269 = _268 + 9.99999993922529e-09f;
  float _270 = log2(_269);
  float _271 = _270 + 16.929765701293945f;
  float _272 = _271 * 0.05734497308731079f;
  float _273 = saturate(_272);
  float _274 = _273 * _273;
  float _275 = _273 * 2.0f;
  float _276 = 3.0f - _275;
  float _277 = _274 * _276;
  float _278 = _262 * 0.8450999855995178f;
  float _279 = _263 * 0.14589999616146088f;
  float _280 = _278 + _279;
  float _281 = _280 * 2.4890189170837402f;
  float _282 = _280 * 0.3754962384700775f;
  float _283 = _280 * 2.811495304107666f;
  float _284 = _280 * 5.519708156585693f;
  float _285 = _264 - _281;
  float _286 = _277 * _285;
  float _287 = _286 + _281;
  float _288 = _277 * 0.5f;
  float _289 = _288 + 0.5f;
  float _290 = _289 * _285;
  float _291 = _290 + _281;
  float _292 = _261 - _282;
  float _293 = _262 - _283;
  float _294 = _263 - _284;
  float _295 = _289 * _292;
  float _296 = _289 * _293;
  float _297 = _289 * _294;
  float _298 = _295 + _282;
  float _299 = _296 + _283;
  float _300 = _297 + _284;
  float _301 = 1.0f / _291;
  float _302 = _287 * _301;
  float _303 = _302 * _298;
  float _304 = _302 * _299;
  float _305 = _302 * _300;
  float _309 = cb2_020x * TEXCOORD0_centroid.x;
  float _310 = cb2_020y * TEXCOORD0_centroid.y;
  float _313 = _309 + cb2_020z;
  float _314 = _310 + cb2_020w;
  float _317 = dot(float2(_313, _314), float2(_313, _314));
  float _318 = 1.0f - _317;
  float _319 = saturate(_318);
  float _320 = log2(_319);
  float _321 = _320 * cb2_021w;
  float _322 = exp2(_321);
  float _326 = _303 - cb2_021x;
  float _327 = _304 - cb2_021y;
  float _328 = _305 - cb2_021z;
  float _329 = _326 * _322;
  float _330 = _327 * _322;
  float _331 = _328 * _322;
  float _332 = _329 + cb2_021x;
  float _333 = _330 + cb2_021y;
  float _334 = _331 + cb2_021z;
  float _335 = t0[0].SExposureData_000;
  float _337 = max(_205.x, 0.0010000000474974513f);
  float _338 = 1.0f / _337;
  float _339 = _338 * _335.x;
  bool _342 = ((uint)(cb2_069y) == 0);
  float _348;
  float _349;
  float _350;
  float _404;
  float _405;
  float _406;
  float _496;
  float _497;
  float _498;
  float _543;
  float _544;
  float _545;
  float _546;
  float _593;
  float _594;
  float _595;
  float _620;
  float _621;
  float _622;
  float _723;
  float _724;
  float _725;
  float _750;
  float _762;
  float _790;
  float _802;
  float _814;
  float _815;
  float _816;
  float _843;
  float _844;
  float _845;
  if (!_342) {
    float _344 = _339 * _332;
    float _345 = _339 * _333;
    float _346 = _339 * _334;
    _348 = _344;
    _349 = _345;
    _350 = _346;
  } else {
    _348 = _332;
    _349 = _333;
    _350 = _334;
  }
  float _351 = _348 * 0.6130970120429993f;
  float _352 = mad(0.33952298760414124f, _349, _351);
  float _353 = mad(0.04737899824976921f, _350, _352);
  float _354 = _348 * 0.07019399851560593f;
  float _355 = mad(0.9163540005683899f, _349, _354);
  float _356 = mad(0.013451999984681606f, _350, _355);
  float _357 = _348 * 0.02061600051820278f;
  float _358 = mad(0.10956999659538269f, _349, _357);
  float _359 = mad(0.8698149919509888f, _350, _358);
  float _360 = log2(_353);
  float _361 = log2(_356);
  float _362 = log2(_359);
  float _363 = _360 * 0.04211956635117531f;
  float _364 = _361 * 0.04211956635117531f;
  float _365 = _362 * 0.04211956635117531f;
  float _366 = _363 + 0.6252607107162476f;
  float _367 = _364 + 0.6252607107162476f;
  float _368 = _365 + 0.6252607107162476f;
  float4 _369 = t5.SampleLevel(s2_space2, float3(_366, _367, _368), 0.0f);
  bool _375 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_375 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _379 = cb2_017x * _369.x;
    float _380 = cb2_017x * _369.y;
    float _381 = cb2_017x * _369.z;
    float _383 = _379 + cb2_017y;
    float _384 = _380 + cb2_017y;
    float _385 = _381 + cb2_017y;
    float _386 = exp2(_383);
    float _387 = exp2(_384);
    float _388 = exp2(_385);
    float _389 = _386 + 1.0f;
    float _390 = _387 + 1.0f;
    float _391 = _388 + 1.0f;
    float _392 = 1.0f / _389;
    float _393 = 1.0f / _390;
    float _394 = 1.0f / _391;
    float _396 = cb2_017z * _392;
    float _397 = cb2_017z * _393;
    float _398 = cb2_017z * _394;
    float _400 = _396 + cb2_017w;
    float _401 = _397 + cb2_017w;
    float _402 = _398 + cb2_017w;
    _404 = _400;
    _405 = _401;
    _406 = _402;
  } else {
    _404 = _369.x;
    _405 = _369.y;
    _406 = _369.z;
  }
  float _407 = _404 * 23.0f;
  float _408 = _407 + -14.473931312561035f;
  float _409 = exp2(_408);
  float _410 = _405 * 23.0f;
  float _411 = _410 + -14.473931312561035f;
  float _412 = exp2(_411);
  float _413 = _406 * 23.0f;
  float _414 = _413 + -14.473931312561035f;
  float _415 = exp2(_414);
  float _416 = dot(float3(_409, _412, _415), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _421 = dot(float3(_409, _412, _415), float3(_409, _412, _415));
  float _422 = rsqrt(_421);
  float _423 = _422 * _409;
  float _424 = _422 * _412;
  float _425 = _422 * _415;
  float _426 = cb2_001x - _423;
  float _427 = cb2_001y - _424;
  float _428 = cb2_001z - _425;
  float _429 = dot(float3(_426, _427, _428), float3(_426, _427, _428));
  float _432 = cb2_002z * _429;
  float _434 = _432 + cb2_002w;
  float _435 = saturate(_434);
  float _437 = cb2_002x * _435;
  float _438 = _416 - _409;
  float _439 = _416 - _412;
  float _440 = _416 - _415;
  float _441 = _437 * _438;
  float _442 = _437 * _439;
  float _443 = _437 * _440;
  float _444 = _441 + _409;
  float _445 = _442 + _412;
  float _446 = _443 + _415;
  float _448 = cb2_002y * _435;
  float _449 = 0.10000000149011612f - _444;
  float _450 = 0.10000000149011612f - _445;
  float _451 = 0.10000000149011612f - _446;
  float _452 = _449 * _448;
  float _453 = _450 * _448;
  float _454 = _451 * _448;
  float _455 = _452 + _444;
  float _456 = _453 + _445;
  float _457 = _454 + _446;
  float _458 = saturate(_455);
  float _459 = saturate(_456);
  float _460 = saturate(_457);
  float _464 = cb2_004x * TEXCOORD0_centroid.x;
  float _465 = cb2_004y * TEXCOORD0_centroid.y;
  float _468 = _464 + cb2_004z;
  float _469 = _465 + cb2_004w;
  float4 _475 = t6.Sample(s2_space2, float2(_468, _469));
  float _480 = _475.x * cb2_003x;
  float _481 = _475.y * cb2_003y;
  float _482 = _475.z * cb2_003z;
  float _483 = _475.w * cb2_003w;
  float _486 = _483 + cb2_026y;
  float _487 = saturate(_486);
  bool _490 = ((uint)(cb2_069y) == 0);
  if (!_490) {
    float _492 = _480 * _339;
    float _493 = _481 * _339;
    float _494 = _482 * _339;
    _496 = _492;
    _497 = _493;
    _498 = _494;
  } else {
    _496 = _480;
    _497 = _481;
    _498 = _482;
  }
  bool _501 = ((uint)(cb2_028x) == 2);
  bool _502 = ((uint)(cb2_028x) == 3);
  int _503 = (uint)(cb2_028x) & -2;
  bool _504 = (_503 == 2);
  bool _505 = ((uint)(cb2_028x) == 6);
  bool _506 = _504 || _505;
  if (_506) {
    float _508 = _496 * _487;
    float _509 = _497 * _487;
    float _510 = _498 * _487;
    float _511 = _487 * _487;
    _543 = _508;
    _544 = _509;
    _545 = _510;
    _546 = _511;
  } else {
    bool _513 = ((uint)(cb2_028x) == 4);
    if (_513) {
      float _515 = _496 + -1.0f;
      float _516 = _497 + -1.0f;
      float _517 = _498 + -1.0f;
      float _518 = _487 + -1.0f;
      float _519 = _515 * _487;
      float _520 = _516 * _487;
      float _521 = _517 * _487;
      float _522 = _518 * _487;
      float _523 = _519 + 1.0f;
      float _524 = _520 + 1.0f;
      float _525 = _521 + 1.0f;
      float _526 = _522 + 1.0f;
      _543 = _523;
      _544 = _524;
      _545 = _525;
      _546 = _526;
    } else {
      bool _528 = ((uint)(cb2_028x) == 5);
      if (_528) {
        float _530 = _496 + -0.5f;
        float _531 = _497 + -0.5f;
        float _532 = _498 + -0.5f;
        float _533 = _487 + -0.5f;
        float _534 = _530 * _487;
        float _535 = _531 * _487;
        float _536 = _532 * _487;
        float _537 = _533 * _487;
        float _538 = _534 + 0.5f;
        float _539 = _535 + 0.5f;
        float _540 = _536 + 0.5f;
        float _541 = _537 + 0.5f;
        _543 = _538;
        _544 = _539;
        _545 = _540;
        _546 = _541;
      } else {
        _543 = _496;
        _544 = _497;
        _545 = _498;
        _546 = _487;
      }
    }
  }
  if (_501) {
    float _548 = _543 + _458;
    float _549 = _544 + _459;
    float _550 = _545 + _460;
    _593 = _548;
    _594 = _549;
    _595 = _550;
  } else {
    if (_502) {
      float _553 = 1.0f - _543;
      float _554 = 1.0f - _544;
      float _555 = 1.0f - _545;
      float _556 = _553 * _458;
      float _557 = _554 * _459;
      float _558 = _555 * _460;
      float _559 = _556 + _543;
      float _560 = _557 + _544;
      float _561 = _558 + _545;
      _593 = _559;
      _594 = _560;
      _595 = _561;
    } else {
      bool _563 = ((uint)(cb2_028x) == 4);
      if (_563) {
        float _565 = _543 * _458;
        float _566 = _544 * _459;
        float _567 = _545 * _460;
        _593 = _565;
        _594 = _566;
        _595 = _567;
      } else {
        bool _569 = ((uint)(cb2_028x) == 5);
        if (_569) {
          float _571 = _458 * 2.0f;
          float _572 = _571 * _543;
          float _573 = _459 * 2.0f;
          float _574 = _573 * _544;
          float _575 = _460 * 2.0f;
          float _576 = _575 * _545;
          _593 = _572;
          _594 = _574;
          _595 = _576;
        } else {
          if (_505) {
            float _579 = _458 - _543;
            float _580 = _459 - _544;
            float _581 = _460 - _545;
            _593 = _579;
            _594 = _580;
            _595 = _581;
          } else {
            float _583 = _543 - _458;
            float _584 = _544 - _459;
            float _585 = _545 - _460;
            float _586 = _546 * _583;
            float _587 = _546 * _584;
            float _588 = _546 * _585;
            float _589 = _586 + _458;
            float _590 = _587 + _459;
            float _591 = _588 + _460;
            _593 = _589;
            _594 = _590;
            _595 = _591;
          }
        }
      }
    }
  }
  float _601 = cb2_016x - _593;
  float _602 = cb2_016y - _594;
  float _603 = cb2_016z - _595;
  float _604 = _601 * cb2_016w;
  float _605 = _602 * cb2_016w;
  float _606 = _603 * cb2_016w;
  float _607 = _604 + _593;
  float _608 = _605 + _594;
  float _609 = _606 + _595;
  bool _612 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_612 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _616 = cb2_024x * _607;
    float _617 = cb2_024x * _608;
    float _618 = cb2_024x * _609;
    _620 = _616;
    _621 = _617;
    _622 = _618;
  } else {
    _620 = _607;
    _621 = _608;
    _622 = _609;
  }
  float _623 = _620 * 0.9708889722824097f;
  float _624 = mad(0.026962999254465103f, _621, _623);
  float _625 = mad(0.002148000057786703f, _622, _624);
  float _626 = _620 * 0.01088900025933981f;
  float _627 = mad(0.9869629740715027f, _621, _626);
  float _628 = mad(0.002148000057786703f, _622, _627);
  float _629 = mad(0.026962999254465103f, _621, _626);
  float _630 = mad(0.9621480107307434f, _622, _629);
  if (_612) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _635 = cb1_018y * 0.10000000149011612f;
        float _636 = log2(cb1_018z);
        float _637 = _636 + -13.287712097167969f;
        float _638 = _637 * 1.4929734468460083f;
        float _639 = _638 + 18.0f;
        float _640 = exp2(_639);
        float _641 = _640 * 0.18000000715255737f;
        float _642 = abs(_641);
        float _643 = log2(_642);
        float _644 = _643 * 1.5f;
        float _645 = exp2(_644);
        float _646 = _645 * _635;
        float _647 = _646 / cb1_018z;
        float _648 = _647 + -0.07636754959821701f;
        float _649 = _643 * 1.2750000953674316f;
        float _650 = exp2(_649);
        float _651 = _650 * 0.07636754959821701f;
        float _652 = cb1_018y * 0.011232397519052029f;
        float _653 = _652 * _645;
        float _654 = _653 / cb1_018z;
        float _655 = _651 - _654;
        float _656 = _650 + -0.11232396960258484f;
        float _657 = _656 * _635;
        float _658 = _657 / cb1_018z;
        float _659 = _658 * cb1_018z;
        float _660 = abs(_625);
        float _661 = abs(_628);
        float _662 = abs(_630);
        float _663 = log2(_660);
        float _664 = log2(_661);
        float _665 = log2(_662);
        float _666 = _663 * 1.5f;
        float _667 = _664 * 1.5f;
        float _668 = _665 * 1.5f;
        float _669 = exp2(_666);
        float _670 = exp2(_667);
        float _671 = exp2(_668);
        float _672 = _669 * _659;
        float _673 = _670 * _659;
        float _674 = _671 * _659;
        float _675 = _663 * 1.2750000953674316f;
        float _676 = _664 * 1.2750000953674316f;
        float _677 = _665 * 1.2750000953674316f;
        float _678 = exp2(_675);
        float _679 = exp2(_676);
        float _680 = exp2(_677);
        float _681 = _678 * _648;
        float _682 = _679 * _648;
        float _683 = _680 * _648;
        float _684 = _681 + _655;
        float _685 = _682 + _655;
        float _686 = _683 + _655;
        float _687 = _672 / _684;
        float _688 = _673 / _685;
        float _689 = _674 / _686;
        float _690 = _687 * 9.999999747378752e-05f;
        float _691 = _688 * 9.999999747378752e-05f;
        float _692 = _689 * 9.999999747378752e-05f;
        float _693 = 5000.0f / cb1_018y;
        float _694 = _690 * _693;
        float _695 = _691 * _693;
        float _696 = _692 * _693;
        _723 = _694;
        _724 = _695;
        _725 = _696;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_625, _628, _630));
      _723 = tonemapped.x, _724 = tonemapped.y, _725 = tonemapped.z;
    }
      } else {
        float _698 = _625 + 0.020616600289940834f;
        float _699 = _628 + 0.020616600289940834f;
        float _700 = _630 + 0.020616600289940834f;
        float _701 = _698 * _625;
        float _702 = _699 * _628;
        float _703 = _700 * _630;
        float _704 = _701 + -7.456949970219284e-05f;
        float _705 = _702 + -7.456949970219284e-05f;
        float _706 = _703 + -7.456949970219284e-05f;
        float _707 = _625 * 0.9837960004806519f;
        float _708 = _628 * 0.9837960004806519f;
        float _709 = _630 * 0.9837960004806519f;
        float _710 = _707 + 0.4336790144443512f;
        float _711 = _708 + 0.4336790144443512f;
        float _712 = _709 + 0.4336790144443512f;
        float _713 = _710 * _625;
        float _714 = _711 * _628;
        float _715 = _712 * _630;
        float _716 = _713 + 0.24617899954319f;
        float _717 = _714 + 0.24617899954319f;
        float _718 = _715 + 0.24617899954319f;
        float _719 = _704 / _716;
        float _720 = _705 / _717;
        float _721 = _706 / _718;
        _723 = _719;
        _724 = _720;
        _725 = _721;
      }
      float _726 = _723 * 1.6047500371932983f;
      float _727 = mad(-0.5310800075531006f, _724, _726);
      float _728 = mad(-0.07366999983787537f, _725, _727);
      float _729 = _723 * -0.10208000242710114f;
      float _730 = mad(1.1081299781799316f, _724, _729);
      float _731 = mad(-0.006049999967217445f, _725, _730);
      float _732 = _723 * -0.0032599999103695154f;
      float _733 = mad(-0.07275000214576721f, _724, _732);
      float _734 = mad(1.0760200023651123f, _725, _733);
      if (_612) {
        // float _736 = max(_728, 0.0f);
        // float _737 = max(_731, 0.0f);
        // float _738 = max(_734, 0.0f);
        // bool _739 = !(_736 >= 0.0030399328097701073f);
        // if (!_739) {
        //   float _741 = abs(_736);
        //   float _742 = log2(_741);
        //   float _743 = _742 * 0.4166666567325592f;
        //   float _744 = exp2(_743);
        //   float _745 = _744 * 1.0549999475479126f;
        //   float _746 = _745 + -0.054999999701976776f;
        //   _750 = _746;
        // } else {
        //   float _748 = _736 * 12.923210144042969f;
        //   _750 = _748;
        // }
        // bool _751 = !(_737 >= 0.0030399328097701073f);
        // if (!_751) {
        //   float _753 = abs(_737);
        //   float _754 = log2(_753);
        //   float _755 = _754 * 0.4166666567325592f;
        //   float _756 = exp2(_755);
        //   float _757 = _756 * 1.0549999475479126f;
        //   float _758 = _757 + -0.054999999701976776f;
        //   _762 = _758;
        // } else {
        //   float _760 = _737 * 12.923210144042969f;
        //   _762 = _760;
        // }
        // bool _763 = !(_738 >= 0.0030399328097701073f);
        // if (!_763) {
        //   float _765 = abs(_738);
        //   float _766 = log2(_765);
        //   float _767 = _766 * 0.4166666567325592f;
        //   float _768 = exp2(_767);
        //   float _769 = _768 * 1.0549999475479126f;
        //   float _770 = _769 + -0.054999999701976776f;
        //   _843 = _750;
        //   _844 = _762;
        //   _845 = _770;
        // } else {
        //   float _772 = _738 * 12.923210144042969f;
        //   _843 = _750;
        //   _844 = _762;
        //   _845 = _772;
        // }
        _843 = renodx::color::srgb::EncodeSafe(_728);
        _844 = renodx::color::srgb::EncodeSafe(_731);
        _845 = renodx::color::srgb::EncodeSafe(_734);

      } else {
        float _774 = saturate(_728);
        float _775 = saturate(_731);
        float _776 = saturate(_734);
        bool _777 = ((uint)(cb1_018w) == -2);
        if (!_777) {
          bool _779 = !(_774 >= 0.0030399328097701073f);
          if (!_779) {
            float _781 = abs(_774);
            float _782 = log2(_781);
            float _783 = _782 * 0.4166666567325592f;
            float _784 = exp2(_783);
            float _785 = _784 * 1.0549999475479126f;
            float _786 = _785 + -0.054999999701976776f;
            _790 = _786;
          } else {
            float _788 = _774 * 12.923210144042969f;
            _790 = _788;
          }
          bool _791 = !(_775 >= 0.0030399328097701073f);
          if (!_791) {
            float _793 = abs(_775);
            float _794 = log2(_793);
            float _795 = _794 * 0.4166666567325592f;
            float _796 = exp2(_795);
            float _797 = _796 * 1.0549999475479126f;
            float _798 = _797 + -0.054999999701976776f;
            _802 = _798;
          } else {
            float _800 = _775 * 12.923210144042969f;
            _802 = _800;
          }
          bool _803 = !(_776 >= 0.0030399328097701073f);
          if (!_803) {
            float _805 = abs(_776);
            float _806 = log2(_805);
            float _807 = _806 * 0.4166666567325592f;
            float _808 = exp2(_807);
            float _809 = _808 * 1.0549999475479126f;
            float _810 = _809 + -0.054999999701976776f;
            _814 = _790;
            _815 = _802;
            _816 = _810;
          } else {
            float _812 = _776 * 12.923210144042969f;
            _814 = _790;
            _815 = _802;
            _816 = _812;
          }
        } else {
          _814 = _774;
          _815 = _775;
          _816 = _776;
        }
        float _821 = abs(_814);
        float _822 = abs(_815);
        float _823 = abs(_816);
        float _824 = log2(_821);
        float _825 = log2(_822);
        float _826 = log2(_823);
        float _827 = _824 * cb2_000z;
        float _828 = _825 * cb2_000z;
        float _829 = _826 * cb2_000z;
        float _830 = exp2(_827);
        float _831 = exp2(_828);
        float _832 = exp2(_829);
        float _833 = _830 * cb2_000y;
        float _834 = _831 * cb2_000y;
        float _835 = _832 * cb2_000y;
        float _836 = _833 + cb2_000x;
        float _837 = _834 + cb2_000x;
        float _838 = _835 + cb2_000x;
        float _839 = saturate(_836);
        float _840 = saturate(_837);
        float _841 = saturate(_838);
        _843 = _839;
        _844 = _840;
        _845 = _841;
      }
      float _846 = dot(float3(_843, _844, _845), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _843;
      SV_Target.y = _844;
      SV_Target.z = _845;
      SV_Target.w = _846;
      SV_Target_1.x = _846;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
