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
  float4 _27 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _31 = max(_27.x, 0.0f);
  float _32 = max(_27.y, 0.0f);
  float _33 = max(_27.z, 0.0f);
  float _34 = min(_31, 65000.0f);
  float _35 = min(_32, 65000.0f);
  float _36 = min(_33, 65000.0f);
  float4 _37 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _42 = max(_37.x, 0.0f);
  float _43 = max(_37.y, 0.0f);
  float _44 = max(_37.z, 0.0f);
  float _45 = max(_37.w, 0.0f);
  float _46 = min(_42, 5000.0f);
  float _47 = min(_43, 5000.0f);
  float _48 = min(_44, 5000.0f);
  float _49 = min(_45, 5000.0f);
  float _52 = _25.x * cb0_028z;
  float _53 = _52 + cb0_028x;
  float _54 = cb2_027w / _53;
  float _55 = 1.0f - _54;
  float _56 = abs(_55);
  float _58 = cb2_027y * _56;
  float _60 = _58 - cb2_027z;
  float _61 = saturate(_60);
  float _62 = max(_61, _49);
  float _63 = saturate(_62);
  float _67 = cb2_006x * TEXCOORD0_centroid.x;
  float _68 = cb2_006y * TEXCOORD0_centroid.y;
  float _71 = _67 + cb2_006z;
  float _72 = _68 + cb2_006w;
  float _76 = cb2_007x * TEXCOORD0_centroid.x;
  float _77 = cb2_007y * TEXCOORD0_centroid.y;
  float _80 = _76 + cb2_007z;
  float _81 = _77 + cb2_007w;
  float _85 = cb2_008x * TEXCOORD0_centroid.x;
  float _86 = cb2_008y * TEXCOORD0_centroid.y;
  float _89 = _85 + cb2_008z;
  float _90 = _86 + cb2_008w;
  float4 _91 = t1.SampleLevel(s2_space2, float2(_71, _72), 0.0f);
  float _93 = max(_91.x, 0.0f);
  float _94 = min(_93, 65000.0f);
  float4 _95 = t1.SampleLevel(s2_space2, float2(_80, _81), 0.0f);
  float _97 = max(_95.y, 0.0f);
  float _98 = min(_97, 65000.0f);
  float4 _99 = t1.SampleLevel(s2_space2, float2(_89, _90), 0.0f);
  float _101 = max(_99.z, 0.0f);
  float _102 = min(_101, 65000.0f);
  float4 _103 = t4.SampleLevel(s2_space2, float2(_71, _72), 0.0f);
  float _105 = max(_103.x, 0.0f);
  float _106 = min(_105, 5000.0f);
  float4 _107 = t4.SampleLevel(s2_space2, float2(_80, _81), 0.0f);
  float _109 = max(_107.y, 0.0f);
  float _110 = min(_109, 5000.0f);
  float4 _111 = t4.SampleLevel(s2_space2, float2(_89, _90), 0.0f);
  float _113 = max(_111.z, 0.0f);
  float _114 = min(_113, 5000.0f);
  float4 _115 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _121 = cb2_005x * _115.x;
  float _122 = cb2_005x * _115.y;
  float _123 = cb2_005x * _115.z;
  float _124 = _94 - _34;
  float _125 = _98 - _35;
  float _126 = _102 - _36;
  float _127 = _121 * _124;
  float _128 = _122 * _125;
  float _129 = _123 * _126;
  float _130 = _127 + _34;
  float _131 = _128 + _35;
  float _132 = _129 + _36;
  float _133 = _106 - _46;
  float _134 = _110 - _47;
  float _135 = _114 - _48;
  float _136 = _121 * _133;
  float _137 = _122 * _134;
  float _138 = _123 * _135;
  float _139 = _136 + _46;
  float _140 = _137 + _47;
  float _141 = _138 + _48;
  float4 _142 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _146 = _139 - _130;
  float _147 = _140 - _131;
  float _148 = _141 - _132;
  float _149 = _146 * _63;
  float _150 = _147 * _63;
  float _151 = _148 * _63;
  float _152 = _149 + _130;
  float _153 = _150 + _131;
  float _154 = _151 + _132;
  float _155 = dot(float3(_152, _153, _154), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _159 = t0[0].SExposureData_020;
  float _161 = t0[0].SExposureData_004;
  float _163 = cb2_018x * 0.5f;
  float _164 = _163 * cb2_018y;
  float _165 = _161.x - _164;
  float _166 = cb2_018y * cb2_018x;
  float _167 = 1.0f / _166;
  float _168 = _165 * _167;
  float _169 = _155 / _159.x;
  float _170 = _169 * 5464.01611328125f;
  float _171 = _170 + 9.99999993922529e-09f;
  float _172 = log2(_171);
  float _173 = _172 - _165;
  float _174 = _173 * _167;
  float _175 = saturate(_174);
  float2 _176 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _175), 0.0f);
  float _179 = max(_176.y, 1.0000000116860974e-07f);
  float _180 = _176.x / _179;
  float _181 = _180 + _168;
  float _182 = _181 / _167;
  float _183 = _182 - _161.x;
  float _184 = -0.0f - _183;
  float _186 = _184 - cb2_027x;
  float _187 = max(0.0f, _186);
  float _190 = cb2_026z * _187;
  float _191 = _183 - cb2_027x;
  float _192 = max(0.0f, _191);
  float _194 = cb2_026w * _192;
  bool _195 = (_183 < 0.0f);
  float _196 = select(_195, _190, _194);
  float _197 = exp2(_196);
  float _198 = _197 * _152;
  float _199 = _197 * _153;
  float _200 = _197 * _154;
  float _205 = cb2_024y * _142.x;
  float _206 = cb2_024z * _142.y;
  float _207 = cb2_024w * _142.z;
  float _208 = _205 + _198;
  float _209 = _206 + _199;
  float _210 = _207 + _200;
  float _215 = _208 * cb2_025x;
  float _216 = _209 * cb2_025y;
  float _217 = _210 * cb2_025z;
  float _218 = dot(float3(_215, _216, _217), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _219 = t0[0].SExposureData_012;
  float _221 = _218 * 5464.01611328125f;
  float _222 = _221 * _219.x;
  float _223 = _222 + 9.99999993922529e-09f;
  float _224 = log2(_223);
  float _225 = _224 + 16.929765701293945f;
  float _226 = _225 * 0.05734497308731079f;
  float _227 = saturate(_226);
  float _228 = _227 * _227;
  float _229 = _227 * 2.0f;
  float _230 = 3.0f - _229;
  float _231 = _228 * _230;
  float _232 = _216 * 0.8450999855995178f;
  float _233 = _217 * 0.14589999616146088f;
  float _234 = _232 + _233;
  float _235 = _234 * 2.4890189170837402f;
  float _236 = _234 * 0.3754962384700775f;
  float _237 = _234 * 2.811495304107666f;
  float _238 = _234 * 5.519708156585693f;
  float _239 = _218 - _235;
  float _240 = _231 * _239;
  float _241 = _240 + _235;
  float _242 = _231 * 0.5f;
  float _243 = _242 + 0.5f;
  float _244 = _243 * _239;
  float _245 = _244 + _235;
  float _246 = _215 - _236;
  float _247 = _216 - _237;
  float _248 = _217 - _238;
  float _249 = _243 * _246;
  float _250 = _243 * _247;
  float _251 = _243 * _248;
  float _252 = _249 + _236;
  float _253 = _250 + _237;
  float _254 = _251 + _238;
  float _255 = 1.0f / _245;
  float _256 = _241 * _255;
  float _257 = _256 * _252;
  float _258 = _256 * _253;
  float _259 = _256 * _254;
  float _263 = cb2_020x * TEXCOORD0_centroid.x;
  float _264 = cb2_020y * TEXCOORD0_centroid.y;
  float _267 = _263 + cb2_020z;
  float _268 = _264 + cb2_020w;
  float _271 = dot(float2(_267, _268), float2(_267, _268));
  float _272 = 1.0f - _271;
  float _273 = saturate(_272);
  float _274 = log2(_273);
  float _275 = _274 * cb2_021w;
  float _276 = exp2(_275);
  float _280 = _257 - cb2_021x;
  float _281 = _258 - cb2_021y;
  float _282 = _259 - cb2_021z;
  float _283 = _280 * _276;
  float _284 = _281 * _276;
  float _285 = _282 * _276;
  float _286 = _283 + cb2_021x;
  float _287 = _284 + cb2_021y;
  float _288 = _285 + cb2_021z;
  float _289 = t0[0].SExposureData_000;
  float _291 = max(_159.x, 0.0010000000474974513f);
  float _292 = 1.0f / _291;
  float _293 = _292 * _289.x;
  bool _296 = ((uint)(cb2_069y) == 0);
  float _302;
  float _303;
  float _304;
  float _358;
  float _359;
  float _360;
  float _451;
  float _452;
  float _453;
  float _498;
  float _499;
  float _500;
  float _501;
  float _550;
  float _551;
  float _552;
  float _553;
  float _578;
  float _579;
  float _580;
  float _681;
  float _682;
  float _683;
  float _708;
  float _720;
  float _748;
  float _760;
  float _772;
  float _773;
  float _774;
  float _801;
  float _802;
  float _803;
  if (!_296) {
    float _298 = _293 * _286;
    float _299 = _293 * _287;
    float _300 = _293 * _288;
    _302 = _298;
    _303 = _299;
    _304 = _300;
  } else {
    _302 = _286;
    _303 = _287;
    _304 = _288;
  }
  float _305 = _302 * 0.6130970120429993f;
  float _306 = mad(0.33952298760414124f, _303, _305);
  float _307 = mad(0.04737899824976921f, _304, _306);
  float _308 = _302 * 0.07019399851560593f;
  float _309 = mad(0.9163540005683899f, _303, _308);
  float _310 = mad(0.013451999984681606f, _304, _309);
  float _311 = _302 * 0.02061600051820278f;
  float _312 = mad(0.10956999659538269f, _303, _311);
  float _313 = mad(0.8698149919509888f, _304, _312);
  float _314 = log2(_307);
  float _315 = log2(_310);
  float _316 = log2(_313);
  float _317 = _314 * 0.04211956635117531f;
  float _318 = _315 * 0.04211956635117531f;
  float _319 = _316 * 0.04211956635117531f;
  float _320 = _317 + 0.6252607107162476f;
  float _321 = _318 + 0.6252607107162476f;
  float _322 = _319 + 0.6252607107162476f;
  float4 _323 = t6.SampleLevel(s2_space2, float3(_320, _321, _322), 0.0f);
  bool _329 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_329 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _333 = cb2_017x * _323.x;
    float _334 = cb2_017x * _323.y;
    float _335 = cb2_017x * _323.z;
    float _337 = _333 + cb2_017y;
    float _338 = _334 + cb2_017y;
    float _339 = _335 + cb2_017y;
    float _340 = exp2(_337);
    float _341 = exp2(_338);
    float _342 = exp2(_339);
    float _343 = _340 + 1.0f;
    float _344 = _341 + 1.0f;
    float _345 = _342 + 1.0f;
    float _346 = 1.0f / _343;
    float _347 = 1.0f / _344;
    float _348 = 1.0f / _345;
    float _350 = cb2_017z * _346;
    float _351 = cb2_017z * _347;
    float _352 = cb2_017z * _348;
    float _354 = _350 + cb2_017w;
    float _355 = _351 + cb2_017w;
    float _356 = _352 + cb2_017w;
    _358 = _354;
    _359 = _355;
    _360 = _356;
  } else {
    _358 = _323.x;
    _359 = _323.y;
    _360 = _323.z;
  }
  float _361 = _358 * 23.0f;
  float _362 = _361 + -14.473931312561035f;
  float _363 = exp2(_362);
  float _364 = _359 * 23.0f;
  float _365 = _364 + -14.473931312561035f;
  float _366 = exp2(_365);
  float _367 = _360 * 23.0f;
  float _368 = _367 + -14.473931312561035f;
  float _369 = exp2(_368);
  float _370 = dot(float3(_363, _366, _369), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _375 = dot(float3(_363, _366, _369), float3(_363, _366, _369));
  float _376 = rsqrt(_375);
  float _377 = _376 * _363;
  float _378 = _376 * _366;
  float _379 = _376 * _369;
  float _380 = cb2_001x - _377;
  float _381 = cb2_001y - _378;
  float _382 = cb2_001z - _379;
  float _383 = dot(float3(_380, _381, _382), float3(_380, _381, _382));
  float _386 = cb2_002z * _383;
  float _388 = _386 + cb2_002w;
  float _389 = saturate(_388);
  float _391 = cb2_002x * _389;
  float _392 = _370 - _363;
  float _393 = _370 - _366;
  float _394 = _370 - _369;
  float _395 = _391 * _392;
  float _396 = _391 * _393;
  float _397 = _391 * _394;
  float _398 = _395 + _363;
  float _399 = _396 + _366;
  float _400 = _397 + _369;
  float _402 = cb2_002y * _389;
  float _403 = 0.10000000149011612f - _398;
  float _404 = 0.10000000149011612f - _399;
  float _405 = 0.10000000149011612f - _400;
  float _406 = _403 * _402;
  float _407 = _404 * _402;
  float _408 = _405 * _402;
  float _409 = _406 + _398;
  float _410 = _407 + _399;
  float _411 = _408 + _400;
  float _412 = saturate(_409);
  float _413 = saturate(_410);
  float _414 = saturate(_411);
  float _419 = cb2_004x * TEXCOORD0_centroid.x;
  float _420 = cb2_004y * TEXCOORD0_centroid.y;
  float _423 = _419 + cb2_004z;
  float _424 = _420 + cb2_004w;
  float4 _430 = t8.Sample(s2_space2, float2(_423, _424));
  float _435 = _430.x * cb2_003x;
  float _436 = _430.y * cb2_003y;
  float _437 = _430.z * cb2_003z;
  float _438 = _430.w * cb2_003w;
  float _441 = _438 + cb2_026y;
  float _442 = saturate(_441);
  bool _445 = ((uint)(cb2_069y) == 0);
  if (!_445) {
    float _447 = _435 * _293;
    float _448 = _436 * _293;
    float _449 = _437 * _293;
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
    float _503 = _498 + _412;
    float _504 = _499 + _413;
    float _505 = _500 + _414;
    _550 = _503;
    _551 = _504;
    _552 = _505;
    _553 = cb2_025w;
  } else {
    if (_457) {
      float _508 = 1.0f - _498;
      float _509 = 1.0f - _499;
      float _510 = 1.0f - _500;
      float _511 = _508 * _412;
      float _512 = _509 * _413;
      float _513 = _510 * _414;
      float _514 = _511 + _498;
      float _515 = _512 + _499;
      float _516 = _513 + _500;
      _550 = _514;
      _551 = _515;
      _552 = _516;
      _553 = cb2_025w;
    } else {
      bool _518 = ((uint)(cb2_028x) == 4);
      if (_518) {
        float _520 = _498 * _412;
        float _521 = _499 * _413;
        float _522 = _500 * _414;
        _550 = _520;
        _551 = _521;
        _552 = _522;
        _553 = cb2_025w;
      } else {
        bool _524 = ((uint)(cb2_028x) == 5);
        if (_524) {
          float _526 = _412 * 2.0f;
          float _527 = _526 * _498;
          float _528 = _413 * 2.0f;
          float _529 = _528 * _499;
          float _530 = _414 * 2.0f;
          float _531 = _530 * _500;
          _550 = _527;
          _551 = _529;
          _552 = _531;
          _553 = cb2_025w;
        } else {
          if (_460) {
            float _534 = _412 - _498;
            float _535 = _413 - _499;
            float _536 = _414 - _500;
            _550 = _534;
            _551 = _535;
            _552 = _536;
            _553 = cb2_025w;
          } else {
            float _538 = _498 - _412;
            float _539 = _499 - _413;
            float _540 = _500 - _414;
            float _541 = _501 * _538;
            float _542 = _501 * _539;
            float _543 = _501 * _540;
            float _544 = _541 + _412;
            float _545 = _542 + _413;
            float _546 = _543 + _414;
            float _547 = 1.0f - _501;
            float _548 = _547 * cb2_025w;
            _550 = _544;
            _551 = _545;
            _552 = _546;
            _553 = _548;
          }
        }
      }
    }
  }
  float _559 = cb2_016x - _550;
  float _560 = cb2_016y - _551;
  float _561 = cb2_016z - _552;
  float _562 = _559 * cb2_016w;
  float _563 = _560 * cb2_016w;
  float _564 = _561 * cb2_016w;
  float _565 = _562 + _550;
  float _566 = _563 + _551;
  float _567 = _564 + _552;
  bool _570 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_570 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _574 = cb2_024x * _565;
    float _575 = cb2_024x * _566;
    float _576 = cb2_024x * _567;
    _578 = _574;
    _579 = _575;
    _580 = _576;
  } else {
    _578 = _565;
    _579 = _566;
    _580 = _567;
  }
  float _581 = _578 * 0.9708889722824097f;
  float _582 = mad(0.026962999254465103f, _579, _581);
  float _583 = mad(0.002148000057786703f, _580, _582);
  float _584 = _578 * 0.01088900025933981f;
  float _585 = mad(0.9869629740715027f, _579, _584);
  float _586 = mad(0.002148000057786703f, _580, _585);
  float _587 = mad(0.026962999254465103f, _579, _584);
  float _588 = mad(0.9621480107307434f, _580, _587);
  if (_570) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _593 = cb1_018y * 0.10000000149011612f;
        float _594 = log2(cb1_018z);
        float _595 = _594 + -13.287712097167969f;
        float _596 = _595 * 1.4929734468460083f;
        float _597 = _596 + 18.0f;
        float _598 = exp2(_597);
        float _599 = _598 * 0.18000000715255737f;
        float _600 = abs(_599);
        float _601 = log2(_600);
        float _602 = _601 * 1.5f;
        float _603 = exp2(_602);
        float _604 = _603 * _593;
        float _605 = _604 / cb1_018z;
        float _606 = _605 + -0.07636754959821701f;
        float _607 = _601 * 1.2750000953674316f;
        float _608 = exp2(_607);
        float _609 = _608 * 0.07636754959821701f;
        float _610 = cb1_018y * 0.011232397519052029f;
        float _611 = _610 * _603;
        float _612 = _611 / cb1_018z;
        float _613 = _609 - _612;
        float _614 = _608 + -0.11232396960258484f;
        float _615 = _614 * _593;
        float _616 = _615 / cb1_018z;
        float _617 = _616 * cb1_018z;
        float _618 = abs(_583);
        float _619 = abs(_586);
        float _620 = abs(_588);
        float _621 = log2(_618);
        float _622 = log2(_619);
        float _623 = log2(_620);
        float _624 = _621 * 1.5f;
        float _625 = _622 * 1.5f;
        float _626 = _623 * 1.5f;
        float _627 = exp2(_624);
        float _628 = exp2(_625);
        float _629 = exp2(_626);
        float _630 = _627 * _617;
        float _631 = _628 * _617;
        float _632 = _629 * _617;
        float _633 = _621 * 1.2750000953674316f;
        float _634 = _622 * 1.2750000953674316f;
        float _635 = _623 * 1.2750000953674316f;
        float _636 = exp2(_633);
        float _637 = exp2(_634);
        float _638 = exp2(_635);
        float _639 = _636 * _606;
        float _640 = _637 * _606;
        float _641 = _638 * _606;
        float _642 = _639 + _613;
        float _643 = _640 + _613;
        float _644 = _641 + _613;
        float _645 = _630 / _642;
        float _646 = _631 / _643;
        float _647 = _632 / _644;
        float _648 = _645 * 9.999999747378752e-05f;
        float _649 = _646 * 9.999999747378752e-05f;
        float _650 = _647 * 9.999999747378752e-05f;
        float _651 = 5000.0f / cb1_018y;
        float _652 = _648 * _651;
        float _653 = _649 * _651;
        float _654 = _650 * _651;
        _681 = _652;
        _682 = _653;
        _683 = _654;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_583, _586, _588));
      _681 = tonemapped.x, _682 = tonemapped.y, _683 = tonemapped.z;
    }
      } else {
        float _656 = _583 + 0.020616600289940834f;
        float _657 = _586 + 0.020616600289940834f;
        float _658 = _588 + 0.020616600289940834f;
        float _659 = _656 * _583;
        float _660 = _657 * _586;
        float _661 = _658 * _588;
        float _662 = _659 + -7.456949970219284e-05f;
        float _663 = _660 + -7.456949970219284e-05f;
        float _664 = _661 + -7.456949970219284e-05f;
        float _665 = _583 * 0.9837960004806519f;
        float _666 = _586 * 0.9837960004806519f;
        float _667 = _588 * 0.9837960004806519f;
        float _668 = _665 + 0.4336790144443512f;
        float _669 = _666 + 0.4336790144443512f;
        float _670 = _667 + 0.4336790144443512f;
        float _671 = _668 * _583;
        float _672 = _669 * _586;
        float _673 = _670 * _588;
        float _674 = _671 + 0.24617899954319f;
        float _675 = _672 + 0.24617899954319f;
        float _676 = _673 + 0.24617899954319f;
        float _677 = _662 / _674;
        float _678 = _663 / _675;
        float _679 = _664 / _676;
        _681 = _677;
        _682 = _678;
        _683 = _679;
      }
      float _684 = _681 * 1.6047500371932983f;
      float _685 = mad(-0.5310800075531006f, _682, _684);
      float _686 = mad(-0.07366999983787537f, _683, _685);
      float _687 = _681 * -0.10208000242710114f;
      float _688 = mad(1.1081299781799316f, _682, _687);
      float _689 = mad(-0.006049999967217445f, _683, _688);
      float _690 = _681 * -0.0032599999103695154f;
      float _691 = mad(-0.07275000214576721f, _682, _690);
      float _692 = mad(1.0760200023651123f, _683, _691);
      if (_570) {
        // float _694 = max(_686, 0.0f);
        // float _695 = max(_689, 0.0f);
        // float _696 = max(_692, 0.0f);
        // bool _697 = !(_694 >= 0.0030399328097701073f);
        // if (!_697) {
        //   float _699 = abs(_694);
        //   float _700 = log2(_699);
        //   float _701 = _700 * 0.4166666567325592f;
        //   float _702 = exp2(_701);
        //   float _703 = _702 * 1.0549999475479126f;
        //   float _704 = _703 + -0.054999999701976776f;
        //   _708 = _704;
        // } else {
        //   float _706 = _694 * 12.923210144042969f;
        //   _708 = _706;
        // }
        // bool _709 = !(_695 >= 0.0030399328097701073f);
        // if (!_709) {
        //   float _711 = abs(_695);
        //   float _712 = log2(_711);
        //   float _713 = _712 * 0.4166666567325592f;
        //   float _714 = exp2(_713);
        //   float _715 = _714 * 1.0549999475479126f;
        //   float _716 = _715 + -0.054999999701976776f;
        //   _720 = _716;
        // } else {
        //   float _718 = _695 * 12.923210144042969f;
        //   _720 = _718;
        // }
        // bool _721 = !(_696 >= 0.0030399328097701073f);
        // if (!_721) {
        //   float _723 = abs(_696);
        //   float _724 = log2(_723);
        //   float _725 = _724 * 0.4166666567325592f;
        //   float _726 = exp2(_725);
        //   float _727 = _726 * 1.0549999475479126f;
        //   float _728 = _727 + -0.054999999701976776f;
        //   _801 = _708;
        //   _802 = _720;
        //   _803 = _728;
        // } else {
        //   float _730 = _696 * 12.923210144042969f;
        //   _801 = _708;
        //   _802 = _720;
        //   _803 = _730;
        // }
        _801 = renodx::color::srgb::EncodeSafe(_686);
        _802 = renodx::color::srgb::EncodeSafe(_689);
        _803 = renodx::color::srgb::EncodeSafe(_692);

      } else {
        float _732 = saturate(_686);
        float _733 = saturate(_689);
        float _734 = saturate(_692);
        bool _735 = ((uint)(cb1_018w) == -2);
        if (!_735) {
          bool _737 = !(_732 >= 0.0030399328097701073f);
          if (!_737) {
            float _739 = abs(_732);
            float _740 = log2(_739);
            float _741 = _740 * 0.4166666567325592f;
            float _742 = exp2(_741);
            float _743 = _742 * 1.0549999475479126f;
            float _744 = _743 + -0.054999999701976776f;
            _748 = _744;
          } else {
            float _746 = _732 * 12.923210144042969f;
            _748 = _746;
          }
          bool _749 = !(_733 >= 0.0030399328097701073f);
          if (!_749) {
            float _751 = abs(_733);
            float _752 = log2(_751);
            float _753 = _752 * 0.4166666567325592f;
            float _754 = exp2(_753);
            float _755 = _754 * 1.0549999475479126f;
            float _756 = _755 + -0.054999999701976776f;
            _760 = _756;
          } else {
            float _758 = _733 * 12.923210144042969f;
            _760 = _758;
          }
          bool _761 = !(_734 >= 0.0030399328097701073f);
          if (!_761) {
            float _763 = abs(_734);
            float _764 = log2(_763);
            float _765 = _764 * 0.4166666567325592f;
            float _766 = exp2(_765);
            float _767 = _766 * 1.0549999475479126f;
            float _768 = _767 + -0.054999999701976776f;
            _772 = _748;
            _773 = _760;
            _774 = _768;
          } else {
            float _770 = _734 * 12.923210144042969f;
            _772 = _748;
            _773 = _760;
            _774 = _770;
          }
        } else {
          _772 = _732;
          _773 = _733;
          _774 = _734;
        }
        float _779 = abs(_772);
        float _780 = abs(_773);
        float _781 = abs(_774);
        float _782 = log2(_779);
        float _783 = log2(_780);
        float _784 = log2(_781);
        float _785 = _782 * cb2_000z;
        float _786 = _783 * cb2_000z;
        float _787 = _784 * cb2_000z;
        float _788 = exp2(_785);
        float _789 = exp2(_786);
        float _790 = exp2(_787);
        float _791 = _788 * cb2_000y;
        float _792 = _789 * cb2_000y;
        float _793 = _790 * cb2_000y;
        float _794 = _791 + cb2_000x;
        float _795 = _792 + cb2_000x;
        float _796 = _793 + cb2_000x;
        float _797 = saturate(_794);
        float _798 = saturate(_795);
        float _799 = saturate(_796);
        _801 = _797;
        _802 = _798;
        _803 = _799;
      }
      float _807 = cb2_023x * TEXCOORD0_centroid.x;
      float _808 = cb2_023y * TEXCOORD0_centroid.y;
      float _811 = _807 + cb2_023z;
      float _812 = _808 + cb2_023w;
      float4 _815 = t10.SampleLevel(s0_space2, float2(_811, _812), 0.0f);
      float _817 = _815.x + -0.5f;
      float _818 = _817 * cb2_022x;
      float _819 = _818 + 0.5f;
      float _820 = _819 * 2.0f;
      float _821 = _820 * _801;
      float _822 = _820 * _802;
      float _823 = _820 * _803;
      float _827 = float((uint)(cb2_019z));
      float _828 = float((uint)(cb2_019w));
      float _829 = _827 + SV_Position.x;
      float _830 = _828 + SV_Position.y;
      uint _831 = uint(_829);
      uint _832 = uint(_830);
      uint _835 = cb2_019x + -1u;
      uint _836 = cb2_019y + -1u;
      int _837 = _831 & _835;
      int _838 = _832 & _836;
      float4 _839 = t3.Load(int3(_837, _838, 0));
      float _843 = _839.x * 2.0f;
      float _844 = _839.y * 2.0f;
      float _845 = _839.z * 2.0f;
      float _846 = _843 + -1.0f;
      float _847 = _844 + -1.0f;
      float _848 = _845 + -1.0f;
      float _849 = _846 * _553;
      float _850 = _847 * _553;
      float _851 = _848 * _553;
      float _852 = _849 + _821;
      float _853 = _850 + _822;
      float _854 = _851 + _823;
      float _855 = dot(float3(_852, _853, _854), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _852;
      SV_Target.y = _853;
      SV_Target.z = _854;
      SV_Target.w = _855;
      SV_Target_1.x = _855;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
