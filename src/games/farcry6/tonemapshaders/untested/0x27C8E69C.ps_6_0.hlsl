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
  float _469;
  float _470;
  float _471;
  float _516;
  float _517;
  float _518;
  float _519;
  float _566;
  float _567;
  float _568;
  float _593;
  float _594;
  float _595;
  float _696;
  float _697;
  float _698;
  float _723;
  float _735;
  float _763;
  float _775;
  float _787;
  float _788;
  float _789;
  float _816;
  float _817;
  float _818;
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
  float _437 = cb2_004x * TEXCOORD0_centroid.x;
  float _438 = cb2_004y * TEXCOORD0_centroid.y;
  float _441 = _437 + cb2_004z;
  float _442 = _438 + cb2_004w;
  float4 _448 = t7.Sample(s2_space2, float2(_441, _442));
  float _453 = _448.x * cb2_003x;
  float _454 = _448.y * cb2_003y;
  float _455 = _448.z * cb2_003z;
  float _456 = _448.w * cb2_003w;
  float _459 = _456 + cb2_026y;
  float _460 = saturate(_459);
  bool _463 = ((uint)(cb2_069y) == 0);
  if (!_463) {
    float _465 = _453 * _357;
    float _466 = _454 * _357;
    float _467 = _455 * _357;
    _469 = _465;
    _470 = _466;
    _471 = _467;
  } else {
    _469 = _453;
    _470 = _454;
    _471 = _455;
  }
  bool _474 = ((uint)(cb2_028x) == 2);
  bool _475 = ((uint)(cb2_028x) == 3);
  int _476 = (uint)(cb2_028x) & -2;
  bool _477 = (_476 == 2);
  bool _478 = ((uint)(cb2_028x) == 6);
  bool _479 = _477 || _478;
  if (_479) {
    float _481 = _469 * _460;
    float _482 = _470 * _460;
    float _483 = _471 * _460;
    float _484 = _460 * _460;
    _516 = _481;
    _517 = _482;
    _518 = _483;
    _519 = _484;
  } else {
    bool _486 = ((uint)(cb2_028x) == 4);
    if (_486) {
      float _488 = _469 + -1.0f;
      float _489 = _470 + -1.0f;
      float _490 = _471 + -1.0f;
      float _491 = _460 + -1.0f;
      float _492 = _488 * _460;
      float _493 = _489 * _460;
      float _494 = _490 * _460;
      float _495 = _491 * _460;
      float _496 = _492 + 1.0f;
      float _497 = _493 + 1.0f;
      float _498 = _494 + 1.0f;
      float _499 = _495 + 1.0f;
      _516 = _496;
      _517 = _497;
      _518 = _498;
      _519 = _499;
    } else {
      bool _501 = ((uint)(cb2_028x) == 5);
      if (_501) {
        float _503 = _469 + -0.5f;
        float _504 = _470 + -0.5f;
        float _505 = _471 + -0.5f;
        float _506 = _460 + -0.5f;
        float _507 = _503 * _460;
        float _508 = _504 * _460;
        float _509 = _505 * _460;
        float _510 = _506 * _460;
        float _511 = _507 + 0.5f;
        float _512 = _508 + 0.5f;
        float _513 = _509 + 0.5f;
        float _514 = _510 + 0.5f;
        _516 = _511;
        _517 = _512;
        _518 = _513;
        _519 = _514;
      } else {
        _516 = _469;
        _517 = _470;
        _518 = _471;
        _519 = _460;
      }
    }
  }
  if (_474) {
    float _521 = _516 + _427;
    float _522 = _517 + _430;
    float _523 = _518 + _433;
    _566 = _521;
    _567 = _522;
    _568 = _523;
  } else {
    if (_475) {
      float _526 = 1.0f - _516;
      float _527 = 1.0f - _517;
      float _528 = 1.0f - _518;
      float _529 = _526 * _427;
      float _530 = _527 * _430;
      float _531 = _528 * _433;
      float _532 = _529 + _516;
      float _533 = _530 + _517;
      float _534 = _531 + _518;
      _566 = _532;
      _567 = _533;
      _568 = _534;
    } else {
      bool _536 = ((uint)(cb2_028x) == 4);
      if (_536) {
        float _538 = _516 * _427;
        float _539 = _517 * _430;
        float _540 = _518 * _433;
        _566 = _538;
        _567 = _539;
        _568 = _540;
      } else {
        bool _542 = ((uint)(cb2_028x) == 5);
        if (_542) {
          float _544 = _427 * 2.0f;
          float _545 = _544 * _516;
          float _546 = _430 * 2.0f;
          float _547 = _546 * _517;
          float _548 = _433 * 2.0f;
          float _549 = _548 * _518;
          _566 = _545;
          _567 = _547;
          _568 = _549;
        } else {
          if (_478) {
            float _552 = _427 - _516;
            float _553 = _430 - _517;
            float _554 = _433 - _518;
            _566 = _552;
            _567 = _553;
            _568 = _554;
          } else {
            float _556 = _516 - _427;
            float _557 = _517 - _430;
            float _558 = _518 - _433;
            float _559 = _519 * _556;
            float _560 = _519 * _557;
            float _561 = _519 * _558;
            float _562 = _559 + _427;
            float _563 = _560 + _430;
            float _564 = _561 + _433;
            _566 = _562;
            _567 = _563;
            _568 = _564;
          }
        }
      }
    }
  }
  float _574 = cb2_016x - _566;
  float _575 = cb2_016y - _567;
  float _576 = cb2_016z - _568;
  float _577 = _574 * cb2_016w;
  float _578 = _575 * cb2_016w;
  float _579 = _576 * cb2_016w;
  float _580 = _577 + _566;
  float _581 = _578 + _567;
  float _582 = _579 + _568;
  bool _585 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_585 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _589 = cb2_024x * _580;
    float _590 = cb2_024x * _581;
    float _591 = cb2_024x * _582;
    _593 = _589;
    _594 = _590;
    _595 = _591;
  } else {
    _593 = _580;
    _594 = _581;
    _595 = _582;
  }
  float _596 = _593 * 0.9708889722824097f;
  float _597 = mad(0.026962999254465103f, _594, _596);
  float _598 = mad(0.002148000057786703f, _595, _597);
  float _599 = _593 * 0.01088900025933981f;
  float _600 = mad(0.9869629740715027f, _594, _599);
  float _601 = mad(0.002148000057786703f, _595, _600);
  float _602 = mad(0.026962999254465103f, _594, _599);
  float _603 = mad(0.9621480107307434f, _595, _602);
  if (_585) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _608 = cb1_018y * 0.10000000149011612f;
        float _609 = log2(cb1_018z);
        float _610 = _609 + -13.287712097167969f;
        float _611 = _610 * 1.4929734468460083f;
        float _612 = _611 + 18.0f;
        float _613 = exp2(_612);
        float _614 = _613 * 0.18000000715255737f;
        float _615 = abs(_614);
        float _616 = log2(_615);
        float _617 = _616 * 1.5f;
        float _618 = exp2(_617);
        float _619 = _618 * _608;
        float _620 = _619 / cb1_018z;
        float _621 = _620 + -0.07636754959821701f;
        float _622 = _616 * 1.2750000953674316f;
        float _623 = exp2(_622);
        float _624 = _623 * 0.07636754959821701f;
        float _625 = cb1_018y * 0.011232397519052029f;
        float _626 = _625 * _618;
        float _627 = _626 / cb1_018z;
        float _628 = _624 - _627;
        float _629 = _623 + -0.11232396960258484f;
        float _630 = _629 * _608;
        float _631 = _630 / cb1_018z;
        float _632 = _631 * cb1_018z;
        float _633 = abs(_598);
        float _634 = abs(_601);
        float _635 = abs(_603);
        float _636 = log2(_633);
        float _637 = log2(_634);
        float _638 = log2(_635);
        float _639 = _636 * 1.5f;
        float _640 = _637 * 1.5f;
        float _641 = _638 * 1.5f;
        float _642 = exp2(_639);
        float _643 = exp2(_640);
        float _644 = exp2(_641);
        float _645 = _642 * _632;
        float _646 = _643 * _632;
        float _647 = _644 * _632;
        float _648 = _636 * 1.2750000953674316f;
        float _649 = _637 * 1.2750000953674316f;
        float _650 = _638 * 1.2750000953674316f;
        float _651 = exp2(_648);
        float _652 = exp2(_649);
        float _653 = exp2(_650);
        float _654 = _651 * _621;
        float _655 = _652 * _621;
        float _656 = _653 * _621;
        float _657 = _654 + _628;
        float _658 = _655 + _628;
        float _659 = _656 + _628;
        float _660 = _645 / _657;
        float _661 = _646 / _658;
        float _662 = _647 / _659;
        float _663 = _660 * 9.999999747378752e-05f;
        float _664 = _661 * 9.999999747378752e-05f;
        float _665 = _662 * 9.999999747378752e-05f;
        float _666 = 5000.0f / cb1_018y;
        float _667 = _663 * _666;
        float _668 = _664 * _666;
        float _669 = _665 * _666;
        _696 = _667;
        _697 = _668;
        _698 = _669;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_598, _601, _603));
      _696 = tonemapped.x, _697 = tonemapped.y, _698 = tonemapped.z;
    }
      } else {
        float _671 = _598 + 0.020616600289940834f;
        float _672 = _601 + 0.020616600289940834f;
        float _673 = _603 + 0.020616600289940834f;
        float _674 = _671 * _598;
        float _675 = _672 * _601;
        float _676 = _673 * _603;
        float _677 = _674 + -7.456949970219284e-05f;
        float _678 = _675 + -7.456949970219284e-05f;
        float _679 = _676 + -7.456949970219284e-05f;
        float _680 = _598 * 0.9837960004806519f;
        float _681 = _601 * 0.9837960004806519f;
        float _682 = _603 * 0.9837960004806519f;
        float _683 = _680 + 0.4336790144443512f;
        float _684 = _681 + 0.4336790144443512f;
        float _685 = _682 + 0.4336790144443512f;
        float _686 = _683 * _598;
        float _687 = _684 * _601;
        float _688 = _685 * _603;
        float _689 = _686 + 0.24617899954319f;
        float _690 = _687 + 0.24617899954319f;
        float _691 = _688 + 0.24617899954319f;
        float _692 = _677 / _689;
        float _693 = _678 / _690;
        float _694 = _679 / _691;
        _696 = _692;
        _697 = _693;
        _698 = _694;
      }
      float _699 = _696 * 1.6047500371932983f;
      float _700 = mad(-0.5310800075531006f, _697, _699);
      float _701 = mad(-0.07366999983787537f, _698, _700);
      float _702 = _696 * -0.10208000242710114f;
      float _703 = mad(1.1081299781799316f, _697, _702);
      float _704 = mad(-0.006049999967217445f, _698, _703);
      float _705 = _696 * -0.0032599999103695154f;
      float _706 = mad(-0.07275000214576721f, _697, _705);
      float _707 = mad(1.0760200023651123f, _698, _706);
      if (_585) {
        // float _709 = max(_701, 0.0f);
        // float _710 = max(_704, 0.0f);
        // float _711 = max(_707, 0.0f);
        // bool _712 = !(_709 >= 0.0030399328097701073f);
        // if (!_712) {
        //   float _714 = abs(_709);
        //   float _715 = log2(_714);
        //   float _716 = _715 * 0.4166666567325592f;
        //   float _717 = exp2(_716);
        //   float _718 = _717 * 1.0549999475479126f;
        //   float _719 = _718 + -0.054999999701976776f;
        //   _723 = _719;
        // } else {
        //   float _721 = _709 * 12.923210144042969f;
        //   _723 = _721;
        // }
        // bool _724 = !(_710 >= 0.0030399328097701073f);
        // if (!_724) {
        //   float _726 = abs(_710);
        //   float _727 = log2(_726);
        //   float _728 = _727 * 0.4166666567325592f;
        //   float _729 = exp2(_728);
        //   float _730 = _729 * 1.0549999475479126f;
        //   float _731 = _730 + -0.054999999701976776f;
        //   _735 = _731;
        // } else {
        //   float _733 = _710 * 12.923210144042969f;
        //   _735 = _733;
        // }
        // bool _736 = !(_711 >= 0.0030399328097701073f);
        // if (!_736) {
        //   float _738 = abs(_711);
        //   float _739 = log2(_738);
        //   float _740 = _739 * 0.4166666567325592f;
        //   float _741 = exp2(_740);
        //   float _742 = _741 * 1.0549999475479126f;
        //   float _743 = _742 + -0.054999999701976776f;
        //   _816 = _723;
        //   _817 = _735;
        //   _818 = _743;
        // } else {
        //   float _745 = _711 * 12.923210144042969f;
        //   _816 = _723;
        //   _817 = _735;
        //   _818 = _745;
        // }
        _816 = renodx::color::srgb::EncodeSafe(_701);
        _817 = renodx::color::srgb::EncodeSafe(_704);
        _818 = renodx::color::srgb::EncodeSafe(_707);

      } else {
        float _747 = saturate(_701);
        float _748 = saturate(_704);
        float _749 = saturate(_707);
        bool _750 = ((uint)(cb1_018w) == -2);
        if (!_750) {
          bool _752 = !(_747 >= 0.0030399328097701073f);
          if (!_752) {
            float _754 = abs(_747);
            float _755 = log2(_754);
            float _756 = _755 * 0.4166666567325592f;
            float _757 = exp2(_756);
            float _758 = _757 * 1.0549999475479126f;
            float _759 = _758 + -0.054999999701976776f;
            _763 = _759;
          } else {
            float _761 = _747 * 12.923210144042969f;
            _763 = _761;
          }
          bool _764 = !(_748 >= 0.0030399328097701073f);
          if (!_764) {
            float _766 = abs(_748);
            float _767 = log2(_766);
            float _768 = _767 * 0.4166666567325592f;
            float _769 = exp2(_768);
            float _770 = _769 * 1.0549999475479126f;
            float _771 = _770 + -0.054999999701976776f;
            _775 = _771;
          } else {
            float _773 = _748 * 12.923210144042969f;
            _775 = _773;
          }
          bool _776 = !(_749 >= 0.0030399328097701073f);
          if (!_776) {
            float _778 = abs(_749);
            float _779 = log2(_778);
            float _780 = _779 * 0.4166666567325592f;
            float _781 = exp2(_780);
            float _782 = _781 * 1.0549999475479126f;
            float _783 = _782 + -0.054999999701976776f;
            _787 = _763;
            _788 = _775;
            _789 = _783;
          } else {
            float _785 = _749 * 12.923210144042969f;
            _787 = _763;
            _788 = _775;
            _789 = _785;
          }
        } else {
          _787 = _747;
          _788 = _748;
          _789 = _749;
        }
        float _794 = abs(_787);
        float _795 = abs(_788);
        float _796 = abs(_789);
        float _797 = log2(_794);
        float _798 = log2(_795);
        float _799 = log2(_796);
        float _800 = _797 * cb2_000z;
        float _801 = _798 * cb2_000z;
        float _802 = _799 * cb2_000z;
        float _803 = exp2(_800);
        float _804 = exp2(_801);
        float _805 = exp2(_802);
        float _806 = _803 * cb2_000y;
        float _807 = _804 * cb2_000y;
        float _808 = _805 * cb2_000y;
        float _809 = _806 + cb2_000x;
        float _810 = _807 + cb2_000x;
        float _811 = _808 + cb2_000x;
        float _812 = saturate(_809);
        float _813 = saturate(_810);
        float _814 = saturate(_811);
        _816 = _812;
        _817 = _813;
        _818 = _814;
      }
      float _819 = dot(float3(_816, _817, _818), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _816;
      SV_Target.y = _817;
      SV_Target.z = _818;
      SV_Target.w = _819;
      SV_Target_1.x = _819;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
