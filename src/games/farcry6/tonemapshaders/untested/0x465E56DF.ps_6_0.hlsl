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

Texture2D<float4> t9 : register(t9);

Texture3D<float2> t10 : register(t10);

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
  float _23 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _25 = t8.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _29 = _25.x * 6.283199787139893f;
  float _30 = cos(_29);
  float _31 = sin(_29);
  float _32 = _30 * _25.z;
  float _33 = _31 * _25.z;
  float _34 = _32 + TEXCOORD0_centroid.x;
  float _35 = _33 + TEXCOORD0_centroid.y;
  float _36 = _34 * 10.0f;
  float _37 = 10.0f - _36;
  float _38 = min(_36, _37);
  float _39 = saturate(_38);
  float _40 = _39 * _32;
  float _41 = _35 * 10.0f;
  float _42 = 10.0f - _41;
  float _43 = min(_41, _42);
  float _44 = saturate(_43);
  float _45 = _44 * _33;
  float _46 = _40 + TEXCOORD0_centroid.x;
  float _47 = _45 + TEXCOORD0_centroid.y;
  float4 _48 = t8.SampleLevel(s2_space2, float2(_46, _47), 0.0f);
  float _50 = _48.w * _40;
  float _51 = _48.w * _45;
  float _52 = 1.0f - _25.y;
  float _53 = saturate(_52);
  float _54 = _50 * _53;
  float _55 = _51 * _53;
  float _59 = cb2_015x * TEXCOORD0_centroid.x;
  float _60 = cb2_015y * TEXCOORD0_centroid.y;
  float _63 = _59 + cb2_015z;
  float _64 = _60 + cb2_015w;
  float4 _65 = t9.SampleLevel(s0_space2, float2(_63, _64), 0.0f);
  float _69 = saturate(_65.x);
  float _70 = saturate(_65.z);
  float _73 = cb2_026x * _70;
  float _74 = _69 * 6.283199787139893f;
  float _75 = cos(_74);
  float _76 = sin(_74);
  float _77 = _73 * _75;
  float _78 = _76 * _73;
  float _79 = 1.0f - _65.y;
  float _80 = saturate(_79);
  float _81 = _77 * _80;
  float _82 = _78 * _80;
  float _83 = _54 + TEXCOORD0_centroid.x;
  float _84 = _83 + _81;
  float _85 = _55 + TEXCOORD0_centroid.y;
  float _86 = _85 + _82;
  float4 _87 = t8.SampleLevel(s2_space2, float2(_84, _86), 0.0f);
  bool _89 = (_87.y > 0.0f);
  float _90 = select(_89, TEXCOORD0_centroid.x, _84);
  float _91 = select(_89, TEXCOORD0_centroid.y, _86);
  float4 _92 = t1.SampleLevel(s4_space2, float2(_90, _91), 0.0f);
  float _96 = max(_92.x, 0.0f);
  float _97 = max(_92.y, 0.0f);
  float _98 = max(_92.z, 0.0f);
  float _99 = min(_96, 65000.0f);
  float _100 = min(_97, 65000.0f);
  float _101 = min(_98, 65000.0f);
  float4 _102 = t3.SampleLevel(s2_space2, float2(_90, _91), 0.0f);
  float _107 = max(_102.x, 0.0f);
  float _108 = max(_102.y, 0.0f);
  float _109 = max(_102.z, 0.0f);
  float _110 = max(_102.w, 0.0f);
  float _111 = min(_107, 5000.0f);
  float _112 = min(_108, 5000.0f);
  float _113 = min(_109, 5000.0f);
  float _114 = min(_110, 5000.0f);
  float _117 = _23.x * cb0_028z;
  float _118 = _117 + cb0_028x;
  float _119 = cb2_027w / _118;
  float _120 = 1.0f - _119;
  float _121 = abs(_120);
  float _123 = cb2_027y * _121;
  float _125 = _123 - cb2_027z;
  float _126 = saturate(_125);
  float _127 = max(_126, _114);
  float _128 = saturate(_127);
  float _132 = cb2_006x * _90;
  float _133 = cb2_006y * _91;
  float _136 = _132 + cb2_006z;
  float _137 = _133 + cb2_006w;
  float _141 = cb2_007x * _90;
  float _142 = cb2_007y * _91;
  float _145 = _141 + cb2_007z;
  float _146 = _142 + cb2_007w;
  float _150 = cb2_008x * _90;
  float _151 = cb2_008y * _91;
  float _154 = _150 + cb2_008z;
  float _155 = _151 + cb2_008w;
  float4 _156 = t1.SampleLevel(s2_space2, float2(_136, _137), 0.0f);
  float _158 = max(_156.x, 0.0f);
  float _159 = min(_158, 65000.0f);
  float4 _160 = t1.SampleLevel(s2_space2, float2(_145, _146), 0.0f);
  float _162 = max(_160.y, 0.0f);
  float _163 = min(_162, 65000.0f);
  float4 _164 = t1.SampleLevel(s2_space2, float2(_154, _155), 0.0f);
  float _166 = max(_164.z, 0.0f);
  float _167 = min(_166, 65000.0f);
  float4 _168 = t3.SampleLevel(s2_space2, float2(_136, _137), 0.0f);
  float _170 = max(_168.x, 0.0f);
  float _171 = min(_170, 5000.0f);
  float4 _172 = t3.SampleLevel(s2_space2, float2(_145, _146), 0.0f);
  float _174 = max(_172.y, 0.0f);
  float _175 = min(_174, 5000.0f);
  float4 _176 = t3.SampleLevel(s2_space2, float2(_154, _155), 0.0f);
  float _178 = max(_176.z, 0.0f);
  float _179 = min(_178, 5000.0f);
  float4 _180 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _186 = cb2_005x * _180.x;
  float _187 = cb2_005x * _180.y;
  float _188 = cb2_005x * _180.z;
  float _189 = _159 - _99;
  float _190 = _163 - _100;
  float _191 = _167 - _101;
  float _192 = _186 * _189;
  float _193 = _187 * _190;
  float _194 = _188 * _191;
  float _195 = _192 + _99;
  float _196 = _193 + _100;
  float _197 = _194 + _101;
  float _198 = _171 - _111;
  float _199 = _175 - _112;
  float _200 = _179 - _113;
  float _201 = _186 * _198;
  float _202 = _187 * _199;
  float _203 = _188 * _200;
  float _204 = _201 + _111;
  float _205 = _202 + _112;
  float _206 = _203 + _113;
  float4 _207 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _211 = _204 - _195;
  float _212 = _205 - _196;
  float _213 = _206 - _197;
  float _214 = _211 * _128;
  float _215 = _212 * _128;
  float _216 = _213 * _128;
  float _217 = _214 + _195;
  float _218 = _215 + _196;
  float _219 = _216 + _197;
  float _220 = dot(float3(_217, _218, _219), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _224 = t0[0].SExposureData_020;
  float _226 = t0[0].SExposureData_004;
  float _228 = cb2_018x * 0.5f;
  float _229 = _228 * cb2_018y;
  float _230 = _226.x - _229;
  float _231 = cb2_018y * cb2_018x;
  float _232 = 1.0f / _231;
  float _233 = _230 * _232;
  float _234 = _220 / _224.x;
  float _235 = _234 * 5464.01611328125f;
  float _236 = _235 + 9.99999993922529e-09f;
  float _237 = log2(_236);
  float _238 = _237 - _230;
  float _239 = _238 * _232;
  float _240 = saturate(_239);
  float2 _241 = t10.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _240), 0.0f);
  float _244 = max(_241.y, 1.0000000116860974e-07f);
  float _245 = _241.x / _244;
  float _246 = _245 + _233;
  float _247 = _246 / _232;
  float _248 = _247 - _226.x;
  float _249 = -0.0f - _248;
  float _251 = _249 - cb2_027x;
  float _252 = max(0.0f, _251);
  float _254 = cb2_026z * _252;
  float _255 = _248 - cb2_027x;
  float _256 = max(0.0f, _255);
  float _258 = cb2_026w * _256;
  bool _259 = (_248 < 0.0f);
  float _260 = select(_259, _254, _258);
  float _261 = exp2(_260);
  float _262 = _261 * _217;
  float _263 = _261 * _218;
  float _264 = _261 * _219;
  float _269 = cb2_024y * _207.x;
  float _270 = cb2_024z * _207.y;
  float _271 = cb2_024w * _207.z;
  float _272 = _269 + _262;
  float _273 = _270 + _263;
  float _274 = _271 + _264;
  float _279 = _272 * cb2_025x;
  float _280 = _273 * cb2_025y;
  float _281 = _274 * cb2_025z;
  float _282 = dot(float3(_279, _280, _281), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _283 = t0[0].SExposureData_012;
  float _285 = _282 * 5464.01611328125f;
  float _286 = _285 * _283.x;
  float _287 = _286 + 9.99999993922529e-09f;
  float _288 = log2(_287);
  float _289 = _288 + 16.929765701293945f;
  float _290 = _289 * 0.05734497308731079f;
  float _291 = saturate(_290);
  float _292 = _291 * _291;
  float _293 = _291 * 2.0f;
  float _294 = 3.0f - _293;
  float _295 = _292 * _294;
  float _296 = _280 * 0.8450999855995178f;
  float _297 = _281 * 0.14589999616146088f;
  float _298 = _296 + _297;
  float _299 = _298 * 2.4890189170837402f;
  float _300 = _298 * 0.3754962384700775f;
  float _301 = _298 * 2.811495304107666f;
  float _302 = _298 * 5.519708156585693f;
  float _303 = _282 - _299;
  float _304 = _295 * _303;
  float _305 = _304 + _299;
  float _306 = _295 * 0.5f;
  float _307 = _306 + 0.5f;
  float _308 = _307 * _303;
  float _309 = _308 + _299;
  float _310 = _279 - _300;
  float _311 = _280 - _301;
  float _312 = _281 - _302;
  float _313 = _307 * _310;
  float _314 = _307 * _311;
  float _315 = _307 * _312;
  float _316 = _313 + _300;
  float _317 = _314 + _301;
  float _318 = _315 + _302;
  float _319 = 1.0f / _309;
  float _320 = _305 * _319;
  float _321 = _320 * _316;
  float _322 = _320 * _317;
  float _323 = _320 * _318;
  float _327 = cb2_020x * TEXCOORD0_centroid.x;
  float _328 = cb2_020y * TEXCOORD0_centroid.y;
  float _331 = _327 + cb2_020z;
  float _332 = _328 + cb2_020w;
  float _335 = dot(float2(_331, _332), float2(_331, _332));
  float _336 = 1.0f - _335;
  float _337 = saturate(_336);
  float _338 = log2(_337);
  float _339 = _338 * cb2_021w;
  float _340 = exp2(_339);
  float _344 = _321 - cb2_021x;
  float _345 = _322 - cb2_021y;
  float _346 = _323 - cb2_021z;
  float _347 = _344 * _340;
  float _348 = _345 * _340;
  float _349 = _346 * _340;
  float _350 = _347 + cb2_021x;
  float _351 = _348 + cb2_021y;
  float _352 = _349 + cb2_021z;
  float _353 = t0[0].SExposureData_000;
  float _355 = max(_224.x, 0.0010000000474974513f);
  float _356 = 1.0f / _355;
  float _357 = _356 * _353.x;
  bool _360 = ((uint)(cb2_069y) == 0);
  float _366;
  float _367;
  float _368;
  float _422;
  float _423;
  float _424;
  float _514;
  float _515;
  float _516;
  float _561;
  float _562;
  float _563;
  float _564;
  float _611;
  float _612;
  float _613;
  float _638;
  float _639;
  float _640;
  float _741;
  float _742;
  float _743;
  float _768;
  float _780;
  float _808;
  float _820;
  float _832;
  float _833;
  float _834;
  float _861;
  float _862;
  float _863;
  if (!_360) {
    float _362 = _357 * _350;
    float _363 = _357 * _351;
    float _364 = _357 * _352;
    _366 = _362;
    _367 = _363;
    _368 = _364;
  } else {
    _366 = _350;
    _367 = _351;
    _368 = _352;
  }
  float _369 = _366 * 0.6130970120429993f;
  float _370 = mad(0.33952298760414124f, _367, _369);
  float _371 = mad(0.04737899824976921f, _368, _370);
  float _372 = _366 * 0.07019399851560593f;
  float _373 = mad(0.9163540005683899f, _367, _372);
  float _374 = mad(0.013451999984681606f, _368, _373);
  float _375 = _366 * 0.02061600051820278f;
  float _376 = mad(0.10956999659538269f, _367, _375);
  float _377 = mad(0.8698149919509888f, _368, _376);
  float _378 = log2(_371);
  float _379 = log2(_374);
  float _380 = log2(_377);
  float _381 = _378 * 0.04211956635117531f;
  float _382 = _379 * 0.04211956635117531f;
  float _383 = _380 * 0.04211956635117531f;
  float _384 = _381 + 0.6252607107162476f;
  float _385 = _382 + 0.6252607107162476f;
  float _386 = _383 + 0.6252607107162476f;
  float4 _387 = t5.SampleLevel(s2_space2, float3(_384, _385, _386), 0.0f);
  bool _393 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_393 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _397 = cb2_017x * _387.x;
    float _398 = cb2_017x * _387.y;
    float _399 = cb2_017x * _387.z;
    float _401 = _397 + cb2_017y;
    float _402 = _398 + cb2_017y;
    float _403 = _399 + cb2_017y;
    float _404 = exp2(_401);
    float _405 = exp2(_402);
    float _406 = exp2(_403);
    float _407 = _404 + 1.0f;
    float _408 = _405 + 1.0f;
    float _409 = _406 + 1.0f;
    float _410 = 1.0f / _407;
    float _411 = 1.0f / _408;
    float _412 = 1.0f / _409;
    float _414 = cb2_017z * _410;
    float _415 = cb2_017z * _411;
    float _416 = cb2_017z * _412;
    float _418 = _414 + cb2_017w;
    float _419 = _415 + cb2_017w;
    float _420 = _416 + cb2_017w;
    _422 = _418;
    _423 = _419;
    _424 = _420;
  } else {
    _422 = _387.x;
    _423 = _387.y;
    _424 = _387.z;
  }
  float _425 = _422 * 23.0f;
  float _426 = _425 + -14.473931312561035f;
  float _427 = exp2(_426);
  float _428 = _423 * 23.0f;
  float _429 = _428 + -14.473931312561035f;
  float _430 = exp2(_429);
  float _431 = _424 * 23.0f;
  float _432 = _431 + -14.473931312561035f;
  float _433 = exp2(_432);
  float _434 = dot(float3(_427, _430, _433), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _439 = dot(float3(_427, _430, _433), float3(_427, _430, _433));
  float _440 = rsqrt(_439);
  float _441 = _440 * _427;
  float _442 = _440 * _430;
  float _443 = _440 * _433;
  float _444 = cb2_001x - _441;
  float _445 = cb2_001y - _442;
  float _446 = cb2_001z - _443;
  float _447 = dot(float3(_444, _445, _446), float3(_444, _445, _446));
  float _450 = cb2_002z * _447;
  float _452 = _450 + cb2_002w;
  float _453 = saturate(_452);
  float _455 = cb2_002x * _453;
  float _456 = _434 - _427;
  float _457 = _434 - _430;
  float _458 = _434 - _433;
  float _459 = _455 * _456;
  float _460 = _455 * _457;
  float _461 = _455 * _458;
  float _462 = _459 + _427;
  float _463 = _460 + _430;
  float _464 = _461 + _433;
  float _466 = cb2_002y * _453;
  float _467 = 0.10000000149011612f - _462;
  float _468 = 0.10000000149011612f - _463;
  float _469 = 0.10000000149011612f - _464;
  float _470 = _467 * _466;
  float _471 = _468 * _466;
  float _472 = _469 * _466;
  float _473 = _470 + _462;
  float _474 = _471 + _463;
  float _475 = _472 + _464;
  float _476 = saturate(_473);
  float _477 = saturate(_474);
  float _478 = saturate(_475);
  float _482 = cb2_004x * TEXCOORD0_centroid.x;
  float _483 = cb2_004y * TEXCOORD0_centroid.y;
  float _486 = _482 + cb2_004z;
  float _487 = _483 + cb2_004w;
  float4 _493 = t7.Sample(s2_space2, float2(_486, _487));
  float _498 = _493.x * cb2_003x;
  float _499 = _493.y * cb2_003y;
  float _500 = _493.z * cb2_003z;
  float _501 = _493.w * cb2_003w;
  float _504 = _501 + cb2_026y;
  float _505 = saturate(_504);
  bool _508 = ((uint)(cb2_069y) == 0);
  if (!_508) {
    float _510 = _498 * _357;
    float _511 = _499 * _357;
    float _512 = _500 * _357;
    _514 = _510;
    _515 = _511;
    _516 = _512;
  } else {
    _514 = _498;
    _515 = _499;
    _516 = _500;
  }
  bool _519 = ((uint)(cb2_028x) == 2);
  bool _520 = ((uint)(cb2_028x) == 3);
  int _521 = (uint)(cb2_028x) & -2;
  bool _522 = (_521 == 2);
  bool _523 = ((uint)(cb2_028x) == 6);
  bool _524 = _522 || _523;
  if (_524) {
    float _526 = _514 * _505;
    float _527 = _515 * _505;
    float _528 = _516 * _505;
    float _529 = _505 * _505;
    _561 = _526;
    _562 = _527;
    _563 = _528;
    _564 = _529;
  } else {
    bool _531 = ((uint)(cb2_028x) == 4);
    if (_531) {
      float _533 = _514 + -1.0f;
      float _534 = _515 + -1.0f;
      float _535 = _516 + -1.0f;
      float _536 = _505 + -1.0f;
      float _537 = _533 * _505;
      float _538 = _534 * _505;
      float _539 = _535 * _505;
      float _540 = _536 * _505;
      float _541 = _537 + 1.0f;
      float _542 = _538 + 1.0f;
      float _543 = _539 + 1.0f;
      float _544 = _540 + 1.0f;
      _561 = _541;
      _562 = _542;
      _563 = _543;
      _564 = _544;
    } else {
      bool _546 = ((uint)(cb2_028x) == 5);
      if (_546) {
        float _548 = _514 + -0.5f;
        float _549 = _515 + -0.5f;
        float _550 = _516 + -0.5f;
        float _551 = _505 + -0.5f;
        float _552 = _548 * _505;
        float _553 = _549 * _505;
        float _554 = _550 * _505;
        float _555 = _551 * _505;
        float _556 = _552 + 0.5f;
        float _557 = _553 + 0.5f;
        float _558 = _554 + 0.5f;
        float _559 = _555 + 0.5f;
        _561 = _556;
        _562 = _557;
        _563 = _558;
        _564 = _559;
      } else {
        _561 = _514;
        _562 = _515;
        _563 = _516;
        _564 = _505;
      }
    }
  }
  if (_519) {
    float _566 = _561 + _476;
    float _567 = _562 + _477;
    float _568 = _563 + _478;
    _611 = _566;
    _612 = _567;
    _613 = _568;
  } else {
    if (_520) {
      float _571 = 1.0f - _561;
      float _572 = 1.0f - _562;
      float _573 = 1.0f - _563;
      float _574 = _571 * _476;
      float _575 = _572 * _477;
      float _576 = _573 * _478;
      float _577 = _574 + _561;
      float _578 = _575 + _562;
      float _579 = _576 + _563;
      _611 = _577;
      _612 = _578;
      _613 = _579;
    } else {
      bool _581 = ((uint)(cb2_028x) == 4);
      if (_581) {
        float _583 = _561 * _476;
        float _584 = _562 * _477;
        float _585 = _563 * _478;
        _611 = _583;
        _612 = _584;
        _613 = _585;
      } else {
        bool _587 = ((uint)(cb2_028x) == 5);
        if (_587) {
          float _589 = _476 * 2.0f;
          float _590 = _589 * _561;
          float _591 = _477 * 2.0f;
          float _592 = _591 * _562;
          float _593 = _478 * 2.0f;
          float _594 = _593 * _563;
          _611 = _590;
          _612 = _592;
          _613 = _594;
        } else {
          if (_523) {
            float _597 = _476 - _561;
            float _598 = _477 - _562;
            float _599 = _478 - _563;
            _611 = _597;
            _612 = _598;
            _613 = _599;
          } else {
            float _601 = _561 - _476;
            float _602 = _562 - _477;
            float _603 = _563 - _478;
            float _604 = _564 * _601;
            float _605 = _564 * _602;
            float _606 = _564 * _603;
            float _607 = _604 + _476;
            float _608 = _605 + _477;
            float _609 = _606 + _478;
            _611 = _607;
            _612 = _608;
            _613 = _609;
          }
        }
      }
    }
  }
  float _619 = cb2_016x - _611;
  float _620 = cb2_016y - _612;
  float _621 = cb2_016z - _613;
  float _622 = _619 * cb2_016w;
  float _623 = _620 * cb2_016w;
  float _624 = _621 * cb2_016w;
  float _625 = _622 + _611;
  float _626 = _623 + _612;
  float _627 = _624 + _613;
  bool _630 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_630 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _634 = cb2_024x * _625;
    float _635 = cb2_024x * _626;
    float _636 = cb2_024x * _627;
    _638 = _634;
    _639 = _635;
    _640 = _636;
  } else {
    _638 = _625;
    _639 = _626;
    _640 = _627;
  }
  float _641 = _638 * 0.9708889722824097f;
  float _642 = mad(0.026962999254465103f, _639, _641);
  float _643 = mad(0.002148000057786703f, _640, _642);
  float _644 = _638 * 0.01088900025933981f;
  float _645 = mad(0.9869629740715027f, _639, _644);
  float _646 = mad(0.002148000057786703f, _640, _645);
  float _647 = mad(0.026962999254465103f, _639, _644);
  float _648 = mad(0.9621480107307434f, _640, _647);
  if (_630) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _653 = cb1_018y * 0.10000000149011612f;
        float _654 = log2(cb1_018z);
        float _655 = _654 + -13.287712097167969f;
        float _656 = _655 * 1.4929734468460083f;
        float _657 = _656 + 18.0f;
        float _658 = exp2(_657);
        float _659 = _658 * 0.18000000715255737f;
        float _660 = abs(_659);
        float _661 = log2(_660);
        float _662 = _661 * 1.5f;
        float _663 = exp2(_662);
        float _664 = _663 * _653;
        float _665 = _664 / cb1_018z;
        float _666 = _665 + -0.07636754959821701f;
        float _667 = _661 * 1.2750000953674316f;
        float _668 = exp2(_667);
        float _669 = _668 * 0.07636754959821701f;
        float _670 = cb1_018y * 0.011232397519052029f;
        float _671 = _670 * _663;
        float _672 = _671 / cb1_018z;
        float _673 = _669 - _672;
        float _674 = _668 + -0.11232396960258484f;
        float _675 = _674 * _653;
        float _676 = _675 / cb1_018z;
        float _677 = _676 * cb1_018z;
        float _678 = abs(_643);
        float _679 = abs(_646);
        float _680 = abs(_648);
        float _681 = log2(_678);
        float _682 = log2(_679);
        float _683 = log2(_680);
        float _684 = _681 * 1.5f;
        float _685 = _682 * 1.5f;
        float _686 = _683 * 1.5f;
        float _687 = exp2(_684);
        float _688 = exp2(_685);
        float _689 = exp2(_686);
        float _690 = _687 * _677;
        float _691 = _688 * _677;
        float _692 = _689 * _677;
        float _693 = _681 * 1.2750000953674316f;
        float _694 = _682 * 1.2750000953674316f;
        float _695 = _683 * 1.2750000953674316f;
        float _696 = exp2(_693);
        float _697 = exp2(_694);
        float _698 = exp2(_695);
        float _699 = _696 * _666;
        float _700 = _697 * _666;
        float _701 = _698 * _666;
        float _702 = _699 + _673;
        float _703 = _700 + _673;
        float _704 = _701 + _673;
        float _705 = _690 / _702;
        float _706 = _691 / _703;
        float _707 = _692 / _704;
        float _708 = _705 * 9.999999747378752e-05f;
        float _709 = _706 * 9.999999747378752e-05f;
        float _710 = _707 * 9.999999747378752e-05f;
        float _711 = 5000.0f / cb1_018y;
        float _712 = _708 * _711;
        float _713 = _709 * _711;
        float _714 = _710 * _711;
        _741 = _712;
        _742 = _713;
        _743 = _714;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_643, _646, _648));
      _741 = tonemapped.x, _742 = tonemapped.y, _743 = tonemapped.z;
    }
      } else {
        float _716 = _643 + 0.020616600289940834f;
        float _717 = _646 + 0.020616600289940834f;
        float _718 = _648 + 0.020616600289940834f;
        float _719 = _716 * _643;
        float _720 = _717 * _646;
        float _721 = _718 * _648;
        float _722 = _719 + -7.456949970219284e-05f;
        float _723 = _720 + -7.456949970219284e-05f;
        float _724 = _721 + -7.456949970219284e-05f;
        float _725 = _643 * 0.9837960004806519f;
        float _726 = _646 * 0.9837960004806519f;
        float _727 = _648 * 0.9837960004806519f;
        float _728 = _725 + 0.4336790144443512f;
        float _729 = _726 + 0.4336790144443512f;
        float _730 = _727 + 0.4336790144443512f;
        float _731 = _728 * _643;
        float _732 = _729 * _646;
        float _733 = _730 * _648;
        float _734 = _731 + 0.24617899954319f;
        float _735 = _732 + 0.24617899954319f;
        float _736 = _733 + 0.24617899954319f;
        float _737 = _722 / _734;
        float _738 = _723 / _735;
        float _739 = _724 / _736;
        _741 = _737;
        _742 = _738;
        _743 = _739;
      }
      float _744 = _741 * 1.6047500371932983f;
      float _745 = mad(-0.5310800075531006f, _742, _744);
      float _746 = mad(-0.07366999983787537f, _743, _745);
      float _747 = _741 * -0.10208000242710114f;
      float _748 = mad(1.1081299781799316f, _742, _747);
      float _749 = mad(-0.006049999967217445f, _743, _748);
      float _750 = _741 * -0.0032599999103695154f;
      float _751 = mad(-0.07275000214576721f, _742, _750);
      float _752 = mad(1.0760200023651123f, _743, _751);
      if (_630) {
        // float _754 = max(_746, 0.0f);
        // float _755 = max(_749, 0.0f);
        // float _756 = max(_752, 0.0f);
        // bool _757 = !(_754 >= 0.0030399328097701073f);
        // if (!_757) {
        //   float _759 = abs(_754);
        //   float _760 = log2(_759);
        //   float _761 = _760 * 0.4166666567325592f;
        //   float _762 = exp2(_761);
        //   float _763 = _762 * 1.0549999475479126f;
        //   float _764 = _763 + -0.054999999701976776f;
        //   _768 = _764;
        // } else {
        //   float _766 = _754 * 12.923210144042969f;
        //   _768 = _766;
        // }
        // bool _769 = !(_755 >= 0.0030399328097701073f);
        // if (!_769) {
        //   float _771 = abs(_755);
        //   float _772 = log2(_771);
        //   float _773 = _772 * 0.4166666567325592f;
        //   float _774 = exp2(_773);
        //   float _775 = _774 * 1.0549999475479126f;
        //   float _776 = _775 + -0.054999999701976776f;
        //   _780 = _776;
        // } else {
        //   float _778 = _755 * 12.923210144042969f;
        //   _780 = _778;
        // }
        // bool _781 = !(_756 >= 0.0030399328097701073f);
        // if (!_781) {
        //   float _783 = abs(_756);
        //   float _784 = log2(_783);
        //   float _785 = _784 * 0.4166666567325592f;
        //   float _786 = exp2(_785);
        //   float _787 = _786 * 1.0549999475479126f;
        //   float _788 = _787 + -0.054999999701976776f;
        //   _861 = _768;
        //   _862 = _780;
        //   _863 = _788;
        // } else {
        //   float _790 = _756 * 12.923210144042969f;
        //   _861 = _768;
        //   _862 = _780;
        //   _863 = _790;
        // }
        _861 = renodx::color::srgb::EncodeSafe(_746);
        _862 = renodx::color::srgb::EncodeSafe(_749);
        _863 = renodx::color::srgb::EncodeSafe(_752);

      } else {
        float _792 = saturate(_746);
        float _793 = saturate(_749);
        float _794 = saturate(_752);
        bool _795 = ((uint)(cb1_018w) == -2);
        if (!_795) {
          bool _797 = !(_792 >= 0.0030399328097701073f);
          if (!_797) {
            float _799 = abs(_792);
            float _800 = log2(_799);
            float _801 = _800 * 0.4166666567325592f;
            float _802 = exp2(_801);
            float _803 = _802 * 1.0549999475479126f;
            float _804 = _803 + -0.054999999701976776f;
            _808 = _804;
          } else {
            float _806 = _792 * 12.923210144042969f;
            _808 = _806;
          }
          bool _809 = !(_793 >= 0.0030399328097701073f);
          if (!_809) {
            float _811 = abs(_793);
            float _812 = log2(_811);
            float _813 = _812 * 0.4166666567325592f;
            float _814 = exp2(_813);
            float _815 = _814 * 1.0549999475479126f;
            float _816 = _815 + -0.054999999701976776f;
            _820 = _816;
          } else {
            float _818 = _793 * 12.923210144042969f;
            _820 = _818;
          }
          bool _821 = !(_794 >= 0.0030399328097701073f);
          if (!_821) {
            float _823 = abs(_794);
            float _824 = log2(_823);
            float _825 = _824 * 0.4166666567325592f;
            float _826 = exp2(_825);
            float _827 = _826 * 1.0549999475479126f;
            float _828 = _827 + -0.054999999701976776f;
            _832 = _808;
            _833 = _820;
            _834 = _828;
          } else {
            float _830 = _794 * 12.923210144042969f;
            _832 = _808;
            _833 = _820;
            _834 = _830;
          }
        } else {
          _832 = _792;
          _833 = _793;
          _834 = _794;
        }
        float _839 = abs(_832);
        float _840 = abs(_833);
        float _841 = abs(_834);
        float _842 = log2(_839);
        float _843 = log2(_840);
        float _844 = log2(_841);
        float _845 = _842 * cb2_000z;
        float _846 = _843 * cb2_000z;
        float _847 = _844 * cb2_000z;
        float _848 = exp2(_845);
        float _849 = exp2(_846);
        float _850 = exp2(_847);
        float _851 = _848 * cb2_000y;
        float _852 = _849 * cb2_000y;
        float _853 = _850 * cb2_000y;
        float _854 = _851 + cb2_000x;
        float _855 = _852 + cb2_000x;
        float _856 = _853 + cb2_000x;
        float _857 = saturate(_854);
        float _858 = saturate(_855);
        float _859 = saturate(_856);
        _861 = _857;
        _862 = _858;
        _863 = _859;
      }
      float _864 = dot(float3(_861, _862, _863), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _861;
      SV_Target.y = _862;
      SV_Target.z = _863;
      SV_Target.w = _864;
      SV_Target_1.x = _864;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
