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
  float _451;
  float _452;
  float _453;
  float _498;
  float _499;
  float _500;
  float _501;
  float _548;
  float _549;
  float _550;
  float _575;
  float _576;
  float _577;
  float _678;
  float _679;
  float _680;
  float _705;
  float _717;
  float _745;
  float _757;
  float _769;
  float _770;
  float _771;
  float _798;
  float _799;
  float _800;
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
  float _419 = cb2_004x * TEXCOORD0_centroid.x;
  float _420 = cb2_004y * TEXCOORD0_centroid.y;
  float _423 = _419 + cb2_004z;
  float _424 = _420 + cb2_004w;
  float4 _430 = t6.Sample(s2_space2, float2(_423, _424));
  float _435 = _430.x * cb2_003x;
  float _436 = _430.y * cb2_003y;
  float _437 = _430.z * cb2_003z;
  float _438 = _430.w * cb2_003w;
  float _441 = _438 + cb2_026y;
  float _442 = saturate(_441);
  bool _445 = ((uint)(cb2_069y) == 0);
  if (!_445) {
    float _447 = _435 * _339;
    float _448 = _436 * _339;
    float _449 = _437 * _339;
    _451 = _447;
    _452 = _448;
    _453 = _449;
  } else {
    _451 = _435;
    _452 = _436;
    _453 = _437;
  }
  bool _456 = ((uint)(cb2_028x) == 2);
  bool _457 = ((uint)(cb2_028x) == 3);
  int _458 = (uint)(cb2_028x) & -2;
  bool _459 = (_458 == 2);
  bool _460 = ((uint)(cb2_028x) == 6);
  bool _461 = _459 || _460;
  if (_461) {
    float _463 = _451 * _442;
    float _464 = _452 * _442;
    float _465 = _453 * _442;
    float _466 = _442 * _442;
    _498 = _463;
    _499 = _464;
    _500 = _465;
    _501 = _466;
  } else {
    bool _468 = ((uint)(cb2_028x) == 4);
    if (_468) {
      float _470 = _451 + -1.0f;
      float _471 = _452 + -1.0f;
      float _472 = _453 + -1.0f;
      float _473 = _442 + -1.0f;
      float _474 = _470 * _442;
      float _475 = _471 * _442;
      float _476 = _472 * _442;
      float _477 = _473 * _442;
      float _478 = _474 + 1.0f;
      float _479 = _475 + 1.0f;
      float _480 = _476 + 1.0f;
      float _481 = _477 + 1.0f;
      _498 = _478;
      _499 = _479;
      _500 = _480;
      _501 = _481;
    } else {
      bool _483 = ((uint)(cb2_028x) == 5);
      if (_483) {
        float _485 = _451 + -0.5f;
        float _486 = _452 + -0.5f;
        float _487 = _453 + -0.5f;
        float _488 = _442 + -0.5f;
        float _489 = _485 * _442;
        float _490 = _486 * _442;
        float _491 = _487 * _442;
        float _492 = _488 * _442;
        float _493 = _489 + 0.5f;
        float _494 = _490 + 0.5f;
        float _495 = _491 + 0.5f;
        float _496 = _492 + 0.5f;
        _498 = _493;
        _499 = _494;
        _500 = _495;
        _501 = _496;
      } else {
        _498 = _451;
        _499 = _452;
        _500 = _453;
        _501 = _442;
      }
    }
  }
  if (_456) {
    float _503 = _498 + _409;
    float _504 = _499 + _412;
    float _505 = _500 + _415;
    _548 = _503;
    _549 = _504;
    _550 = _505;
  } else {
    if (_457) {
      float _508 = 1.0f - _498;
      float _509 = 1.0f - _499;
      float _510 = 1.0f - _500;
      float _511 = _508 * _409;
      float _512 = _509 * _412;
      float _513 = _510 * _415;
      float _514 = _511 + _498;
      float _515 = _512 + _499;
      float _516 = _513 + _500;
      _548 = _514;
      _549 = _515;
      _550 = _516;
    } else {
      bool _518 = ((uint)(cb2_028x) == 4);
      if (_518) {
        float _520 = _498 * _409;
        float _521 = _499 * _412;
        float _522 = _500 * _415;
        _548 = _520;
        _549 = _521;
        _550 = _522;
      } else {
        bool _524 = ((uint)(cb2_028x) == 5);
        if (_524) {
          float _526 = _409 * 2.0f;
          float _527 = _526 * _498;
          float _528 = _412 * 2.0f;
          float _529 = _528 * _499;
          float _530 = _415 * 2.0f;
          float _531 = _530 * _500;
          _548 = _527;
          _549 = _529;
          _550 = _531;
        } else {
          if (_460) {
            float _534 = _409 - _498;
            float _535 = _412 - _499;
            float _536 = _415 - _500;
            _548 = _534;
            _549 = _535;
            _550 = _536;
          } else {
            float _538 = _498 - _409;
            float _539 = _499 - _412;
            float _540 = _500 - _415;
            float _541 = _501 * _538;
            float _542 = _501 * _539;
            float _543 = _501 * _540;
            float _544 = _541 + _409;
            float _545 = _542 + _412;
            float _546 = _543 + _415;
            _548 = _544;
            _549 = _545;
            _550 = _546;
          }
        }
      }
    }
  }
  float _556 = cb2_016x - _548;
  float _557 = cb2_016y - _549;
  float _558 = cb2_016z - _550;
  float _559 = _556 * cb2_016w;
  float _560 = _557 * cb2_016w;
  float _561 = _558 * cb2_016w;
  float _562 = _559 + _548;
  float _563 = _560 + _549;
  float _564 = _561 + _550;
  bool _567 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_567 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _571 = cb2_024x * _562;
    float _572 = cb2_024x * _563;
    float _573 = cb2_024x * _564;
    _575 = _571;
    _576 = _572;
    _577 = _573;
  } else {
    _575 = _562;
    _576 = _563;
    _577 = _564;
  }
  float _578 = _575 * 0.9708889722824097f;
  float _579 = mad(0.026962999254465103f, _576, _578);
  float _580 = mad(0.002148000057786703f, _577, _579);
  float _581 = _575 * 0.01088900025933981f;
  float _582 = mad(0.9869629740715027f, _576, _581);
  float _583 = mad(0.002148000057786703f, _577, _582);
  float _584 = mad(0.026962999254465103f, _576, _581);
  float _585 = mad(0.9621480107307434f, _577, _584);
  if (_567) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _590 = cb1_018y * 0.10000000149011612f;
        float _591 = log2(cb1_018z);
        float _592 = _591 + -13.287712097167969f;
        float _593 = _592 * 1.4929734468460083f;
        float _594 = _593 + 18.0f;
        float _595 = exp2(_594);
        float _596 = _595 * 0.18000000715255737f;
        float _597 = abs(_596);
        float _598 = log2(_597);
        float _599 = _598 * 1.5f;
        float _600 = exp2(_599);
        float _601 = _600 * _590;
        float _602 = _601 / cb1_018z;
        float _603 = _602 + -0.07636754959821701f;
        float _604 = _598 * 1.2750000953674316f;
        float _605 = exp2(_604);
        float _606 = _605 * 0.07636754959821701f;
        float _607 = cb1_018y * 0.011232397519052029f;
        float _608 = _607 * _600;
        float _609 = _608 / cb1_018z;
        float _610 = _606 - _609;
        float _611 = _605 + -0.11232396960258484f;
        float _612 = _611 * _590;
        float _613 = _612 / cb1_018z;
        float _614 = _613 * cb1_018z;
        float _615 = abs(_580);
        float _616 = abs(_583);
        float _617 = abs(_585);
        float _618 = log2(_615);
        float _619 = log2(_616);
        float _620 = log2(_617);
        float _621 = _618 * 1.5f;
        float _622 = _619 * 1.5f;
        float _623 = _620 * 1.5f;
        float _624 = exp2(_621);
        float _625 = exp2(_622);
        float _626 = exp2(_623);
        float _627 = _624 * _614;
        float _628 = _625 * _614;
        float _629 = _626 * _614;
        float _630 = _618 * 1.2750000953674316f;
        float _631 = _619 * 1.2750000953674316f;
        float _632 = _620 * 1.2750000953674316f;
        float _633 = exp2(_630);
        float _634 = exp2(_631);
        float _635 = exp2(_632);
        float _636 = _633 * _603;
        float _637 = _634 * _603;
        float _638 = _635 * _603;
        float _639 = _636 + _610;
        float _640 = _637 + _610;
        float _641 = _638 + _610;
        float _642 = _627 / _639;
        float _643 = _628 / _640;
        float _644 = _629 / _641;
        float _645 = _642 * 9.999999747378752e-05f;
        float _646 = _643 * 9.999999747378752e-05f;
        float _647 = _644 * 9.999999747378752e-05f;
        float _648 = 5000.0f / cb1_018y;
        float _649 = _645 * _648;
        float _650 = _646 * _648;
        float _651 = _647 * _648;
        _678 = _649;
        _679 = _650;
        _680 = _651;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_580, _583, _585));
      _678 = tonemapped.x, _679 = tonemapped.y, _680 = tonemapped.z;
    }
      } else {
        float _653 = _580 + 0.020616600289940834f;
        float _654 = _583 + 0.020616600289940834f;
        float _655 = _585 + 0.020616600289940834f;
        float _656 = _653 * _580;
        float _657 = _654 * _583;
        float _658 = _655 * _585;
        float _659 = _656 + -7.456949970219284e-05f;
        float _660 = _657 + -7.456949970219284e-05f;
        float _661 = _658 + -7.456949970219284e-05f;
        float _662 = _580 * 0.9837960004806519f;
        float _663 = _583 * 0.9837960004806519f;
        float _664 = _585 * 0.9837960004806519f;
        float _665 = _662 + 0.4336790144443512f;
        float _666 = _663 + 0.4336790144443512f;
        float _667 = _664 + 0.4336790144443512f;
        float _668 = _665 * _580;
        float _669 = _666 * _583;
        float _670 = _667 * _585;
        float _671 = _668 + 0.24617899954319f;
        float _672 = _669 + 0.24617899954319f;
        float _673 = _670 + 0.24617899954319f;
        float _674 = _659 / _671;
        float _675 = _660 / _672;
        float _676 = _661 / _673;
        _678 = _674;
        _679 = _675;
        _680 = _676;
      }
      float _681 = _678 * 1.6047500371932983f;
      float _682 = mad(-0.5310800075531006f, _679, _681);
      float _683 = mad(-0.07366999983787537f, _680, _682);
      float _684 = _678 * -0.10208000242710114f;
      float _685 = mad(1.1081299781799316f, _679, _684);
      float _686 = mad(-0.006049999967217445f, _680, _685);
      float _687 = _678 * -0.0032599999103695154f;
      float _688 = mad(-0.07275000214576721f, _679, _687);
      float _689 = mad(1.0760200023651123f, _680, _688);
      if (_567) {
        // float _691 = max(_683, 0.0f);
        // float _692 = max(_686, 0.0f);
        // float _693 = max(_689, 0.0f);
        // bool _694 = !(_691 >= 0.0030399328097701073f);
        // if (!_694) {
        //   float _696 = abs(_691);
        //   float _697 = log2(_696);
        //   float _698 = _697 * 0.4166666567325592f;
        //   float _699 = exp2(_698);
        //   float _700 = _699 * 1.0549999475479126f;
        //   float _701 = _700 + -0.054999999701976776f;
        //   _705 = _701;
        // } else {
        //   float _703 = _691 * 12.923210144042969f;
        //   _705 = _703;
        // }
        // bool _706 = !(_692 >= 0.0030399328097701073f);
        // if (!_706) {
        //   float _708 = abs(_692);
        //   float _709 = log2(_708);
        //   float _710 = _709 * 0.4166666567325592f;
        //   float _711 = exp2(_710);
        //   float _712 = _711 * 1.0549999475479126f;
        //   float _713 = _712 + -0.054999999701976776f;
        //   _717 = _713;
        // } else {
        //   float _715 = _692 * 12.923210144042969f;
        //   _717 = _715;
        // }
        // bool _718 = !(_693 >= 0.0030399328097701073f);
        // if (!_718) {
        //   float _720 = abs(_693);
        //   float _721 = log2(_720);
        //   float _722 = _721 * 0.4166666567325592f;
        //   float _723 = exp2(_722);
        //   float _724 = _723 * 1.0549999475479126f;
        //   float _725 = _724 + -0.054999999701976776f;
        //   _798 = _705;
        //   _799 = _717;
        //   _800 = _725;
        // } else {
        //   float _727 = _693 * 12.923210144042969f;
        //   _798 = _705;
        //   _799 = _717;
        //   _800 = _727;
        // }
        _798 = renodx::color::srgb::EncodeSafe(_683);
        _799 = renodx::color::srgb::EncodeSafe(_686);
        _800 = renodx::color::srgb::EncodeSafe(_689);

      } else {
        float _729 = saturate(_683);
        float _730 = saturate(_686);
        float _731 = saturate(_689);
        bool _732 = ((uint)(cb1_018w) == -2);
        if (!_732) {
          bool _734 = !(_729 >= 0.0030399328097701073f);
          if (!_734) {
            float _736 = abs(_729);
            float _737 = log2(_736);
            float _738 = _737 * 0.4166666567325592f;
            float _739 = exp2(_738);
            float _740 = _739 * 1.0549999475479126f;
            float _741 = _740 + -0.054999999701976776f;
            _745 = _741;
          } else {
            float _743 = _729 * 12.923210144042969f;
            _745 = _743;
          }
          bool _746 = !(_730 >= 0.0030399328097701073f);
          if (!_746) {
            float _748 = abs(_730);
            float _749 = log2(_748);
            float _750 = _749 * 0.4166666567325592f;
            float _751 = exp2(_750);
            float _752 = _751 * 1.0549999475479126f;
            float _753 = _752 + -0.054999999701976776f;
            _757 = _753;
          } else {
            float _755 = _730 * 12.923210144042969f;
            _757 = _755;
          }
          bool _758 = !(_731 >= 0.0030399328097701073f);
          if (!_758) {
            float _760 = abs(_731);
            float _761 = log2(_760);
            float _762 = _761 * 0.4166666567325592f;
            float _763 = exp2(_762);
            float _764 = _763 * 1.0549999475479126f;
            float _765 = _764 + -0.054999999701976776f;
            _769 = _745;
            _770 = _757;
            _771 = _765;
          } else {
            float _767 = _731 * 12.923210144042969f;
            _769 = _745;
            _770 = _757;
            _771 = _767;
          }
        } else {
          _769 = _729;
          _770 = _730;
          _771 = _731;
        }
        float _776 = abs(_769);
        float _777 = abs(_770);
        float _778 = abs(_771);
        float _779 = log2(_776);
        float _780 = log2(_777);
        float _781 = log2(_778);
        float _782 = _779 * cb2_000z;
        float _783 = _780 * cb2_000z;
        float _784 = _781 * cb2_000z;
        float _785 = exp2(_782);
        float _786 = exp2(_783);
        float _787 = exp2(_784);
        float _788 = _785 * cb2_000y;
        float _789 = _786 * cb2_000y;
        float _790 = _787 * cb2_000y;
        float _791 = _788 + cb2_000x;
        float _792 = _789 + cb2_000x;
        float _793 = _790 + cb2_000x;
        float _794 = saturate(_791);
        float _795 = saturate(_792);
        float _796 = saturate(_793);
        _798 = _794;
        _799 = _795;
        _800 = _796;
      }
      float _801 = dot(float3(_798, _799, _800), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _798;
      SV_Target.y = _799;
      SV_Target.z = _800;
      SV_Target.w = _801;
      SV_Target_1.x = _801;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
