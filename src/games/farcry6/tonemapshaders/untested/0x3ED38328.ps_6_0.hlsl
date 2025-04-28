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

Texture2D<float4> t9 : register(t9);

Texture2D<float4> t10 : register(t10);

Texture3D<float2> t11 : register(t11);

Texture2D<float4> t12 : register(t12);

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
  float _27 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _29 = t9.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _33 = _29.x * 6.283199787139893f;
  float _34 = cos(_33);
  float _35 = sin(_33);
  float _36 = _34 * _29.z;
  float _37 = _35 * _29.z;
  float _38 = _36 + TEXCOORD0_centroid.x;
  float _39 = _37 + TEXCOORD0_centroid.y;
  float _40 = _38 * 10.0f;
  float _41 = 10.0f - _40;
  float _42 = min(_40, _41);
  float _43 = saturate(_42);
  float _44 = _43 * _36;
  float _45 = _39 * 10.0f;
  float _46 = 10.0f - _45;
  float _47 = min(_45, _46);
  float _48 = saturate(_47);
  float _49 = _48 * _37;
  float _50 = _44 + TEXCOORD0_centroid.x;
  float _51 = _49 + TEXCOORD0_centroid.y;
  float4 _52 = t9.SampleLevel(s2_space2, float2(_50, _51), 0.0f);
  float _54 = _52.w * _44;
  float _55 = _52.w * _49;
  float _56 = 1.0f - _29.y;
  float _57 = saturate(_56);
  float _58 = _54 * _57;
  float _59 = _55 * _57;
  float _63 = cb2_015x * TEXCOORD0_centroid.x;
  float _64 = cb2_015y * TEXCOORD0_centroid.y;
  float _67 = _63 + cb2_015z;
  float _68 = _64 + cb2_015w;
  float4 _69 = t10.SampleLevel(s0_space2, float2(_67, _68), 0.0f);
  float _73 = saturate(_69.x);
  float _74 = saturate(_69.z);
  float _77 = cb2_026x * _74;
  float _78 = _73 * 6.283199787139893f;
  float _79 = cos(_78);
  float _80 = sin(_78);
  float _81 = _77 * _79;
  float _82 = _80 * _77;
  float _83 = 1.0f - _69.y;
  float _84 = saturate(_83);
  float _85 = _81 * _84;
  float _86 = _82 * _84;
  float _87 = _58 + TEXCOORD0_centroid.x;
  float _88 = _87 + _85;
  float _89 = _59 + TEXCOORD0_centroid.y;
  float _90 = _89 + _86;
  float4 _91 = t9.SampleLevel(s2_space2, float2(_88, _90), 0.0f);
  bool _93 = (_91.y > 0.0f);
  float _94 = select(_93, TEXCOORD0_centroid.x, _88);
  float _95 = select(_93, TEXCOORD0_centroid.y, _90);
  float4 _96 = t1.SampleLevel(s4_space2, float2(_94, _95), 0.0f);
  float _100 = max(_96.x, 0.0f);
  float _101 = max(_96.y, 0.0f);
  float _102 = max(_96.z, 0.0f);
  float _103 = min(_100, 65000.0f);
  float _104 = min(_101, 65000.0f);
  float _105 = min(_102, 65000.0f);
  float4 _106 = t4.SampleLevel(s2_space2, float2(_94, _95), 0.0f);
  float _111 = max(_106.x, 0.0f);
  float _112 = max(_106.y, 0.0f);
  float _113 = max(_106.z, 0.0f);
  float _114 = max(_106.w, 0.0f);
  float _115 = min(_111, 5000.0f);
  float _116 = min(_112, 5000.0f);
  float _117 = min(_113, 5000.0f);
  float _118 = min(_114, 5000.0f);
  float _121 = _27.x * cb0_028z;
  float _122 = _121 + cb0_028x;
  float _123 = cb2_027w / _122;
  float _124 = 1.0f - _123;
  float _125 = abs(_124);
  float _127 = cb2_027y * _125;
  float _129 = _127 - cb2_027z;
  float _130 = saturate(_129);
  float _131 = max(_130, _118);
  float _132 = saturate(_131);
  float _136 = cb2_006x * _94;
  float _137 = cb2_006y * _95;
  float _140 = _136 + cb2_006z;
  float _141 = _137 + cb2_006w;
  float _145 = cb2_007x * _94;
  float _146 = cb2_007y * _95;
  float _149 = _145 + cb2_007z;
  float _150 = _146 + cb2_007w;
  float _154 = cb2_008x * _94;
  float _155 = cb2_008y * _95;
  float _158 = _154 + cb2_008z;
  float _159 = _155 + cb2_008w;
  float4 _160 = t1.SampleLevel(s2_space2, float2(_140, _141), 0.0f);
  float _162 = max(_160.x, 0.0f);
  float _163 = min(_162, 65000.0f);
  float4 _164 = t1.SampleLevel(s2_space2, float2(_149, _150), 0.0f);
  float _166 = max(_164.y, 0.0f);
  float _167 = min(_166, 65000.0f);
  float4 _168 = t1.SampleLevel(s2_space2, float2(_158, _159), 0.0f);
  float _170 = max(_168.z, 0.0f);
  float _171 = min(_170, 65000.0f);
  float4 _172 = t4.SampleLevel(s2_space2, float2(_140, _141), 0.0f);
  float _174 = max(_172.x, 0.0f);
  float _175 = min(_174, 5000.0f);
  float4 _176 = t4.SampleLevel(s2_space2, float2(_149, _150), 0.0f);
  float _178 = max(_176.y, 0.0f);
  float _179 = min(_178, 5000.0f);
  float4 _180 = t4.SampleLevel(s2_space2, float2(_158, _159), 0.0f);
  float _182 = max(_180.z, 0.0f);
  float _183 = min(_182, 5000.0f);
  float4 _184 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _190 = cb2_005x * _184.x;
  float _191 = cb2_005x * _184.y;
  float _192 = cb2_005x * _184.z;
  float _193 = _163 - _103;
  float _194 = _167 - _104;
  float _195 = _171 - _105;
  float _196 = _190 * _193;
  float _197 = _191 * _194;
  float _198 = _192 * _195;
  float _199 = _196 + _103;
  float _200 = _197 + _104;
  float _201 = _198 + _105;
  float _202 = _175 - _115;
  float _203 = _179 - _116;
  float _204 = _183 - _117;
  float _205 = _190 * _202;
  float _206 = _191 * _203;
  float _207 = _192 * _204;
  float _208 = _205 + _115;
  float _209 = _206 + _116;
  float _210 = _207 + _117;
  float4 _211 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _215 = _208 - _199;
  float _216 = _209 - _200;
  float _217 = _210 - _201;
  float _218 = _215 * _132;
  float _219 = _216 * _132;
  float _220 = _217 * _132;
  float _221 = _218 + _199;
  float _222 = _219 + _200;
  float _223 = _220 + _201;
  float _224 = dot(float3(_221, _222, _223), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _228 = t0[0].SExposureData_020;
  float _230 = t0[0].SExposureData_004;
  float _232 = cb2_018x * 0.5f;
  float _233 = _232 * cb2_018y;
  float _234 = _230.x - _233;
  float _235 = cb2_018y * cb2_018x;
  float _236 = 1.0f / _235;
  float _237 = _234 * _236;
  float _238 = _224 / _228.x;
  float _239 = _238 * 5464.01611328125f;
  float _240 = _239 + 9.99999993922529e-09f;
  float _241 = log2(_240);
  float _242 = _241 - _234;
  float _243 = _242 * _236;
  float _244 = saturate(_243);
  float2 _245 = t11.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _244), 0.0f);
  float _248 = max(_245.y, 1.0000000116860974e-07f);
  float _249 = _245.x / _248;
  float _250 = _249 + _237;
  float _251 = _250 / _236;
  float _252 = _251 - _230.x;
  float _253 = -0.0f - _252;
  float _255 = _253 - cb2_027x;
  float _256 = max(0.0f, _255);
  float _258 = cb2_026z * _256;
  float _259 = _252 - cb2_027x;
  float _260 = max(0.0f, _259);
  float _262 = cb2_026w * _260;
  bool _263 = (_252 < 0.0f);
  float _264 = select(_263, _258, _262);
  float _265 = exp2(_264);
  float _266 = _265 * _221;
  float _267 = _265 * _222;
  float _268 = _265 * _223;
  float _273 = cb2_024y * _211.x;
  float _274 = cb2_024z * _211.y;
  float _275 = cb2_024w * _211.z;
  float _276 = _273 + _266;
  float _277 = _274 + _267;
  float _278 = _275 + _268;
  float _283 = _276 * cb2_025x;
  float _284 = _277 * cb2_025y;
  float _285 = _278 * cb2_025z;
  float _286 = dot(float3(_283, _284, _285), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _287 = t0[0].SExposureData_012;
  float _289 = _286 * 5464.01611328125f;
  float _290 = _289 * _287.x;
  float _291 = _290 + 9.99999993922529e-09f;
  float _292 = log2(_291);
  float _293 = _292 + 16.929765701293945f;
  float _294 = _293 * 0.05734497308731079f;
  float _295 = saturate(_294);
  float _296 = _295 * _295;
  float _297 = _295 * 2.0f;
  float _298 = 3.0f - _297;
  float _299 = _296 * _298;
  float _300 = _284 * 0.8450999855995178f;
  float _301 = _285 * 0.14589999616146088f;
  float _302 = _300 + _301;
  float _303 = _302 * 2.4890189170837402f;
  float _304 = _302 * 0.3754962384700775f;
  float _305 = _302 * 2.811495304107666f;
  float _306 = _302 * 5.519708156585693f;
  float _307 = _286 - _303;
  float _308 = _299 * _307;
  float _309 = _308 + _303;
  float _310 = _299 * 0.5f;
  float _311 = _310 + 0.5f;
  float _312 = _311 * _307;
  float _313 = _312 + _303;
  float _314 = _283 - _304;
  float _315 = _284 - _305;
  float _316 = _285 - _306;
  float _317 = _311 * _314;
  float _318 = _311 * _315;
  float _319 = _311 * _316;
  float _320 = _317 + _304;
  float _321 = _318 + _305;
  float _322 = _319 + _306;
  float _323 = 1.0f / _313;
  float _324 = _309 * _323;
  float _325 = _324 * _320;
  float _326 = _324 * _321;
  float _327 = _324 * _322;
  float _331 = cb2_020x * TEXCOORD0_centroid.x;
  float _332 = cb2_020y * TEXCOORD0_centroid.y;
  float _335 = _331 + cb2_020z;
  float _336 = _332 + cb2_020w;
  float _339 = dot(float2(_335, _336), float2(_335, _336));
  float _340 = 1.0f - _339;
  float _341 = saturate(_340);
  float _342 = log2(_341);
  float _343 = _342 * cb2_021w;
  float _344 = exp2(_343);
  float _348 = _325 - cb2_021x;
  float _349 = _326 - cb2_021y;
  float _350 = _327 - cb2_021z;
  float _351 = _348 * _344;
  float _352 = _349 * _344;
  float _353 = _350 * _344;
  float _354 = _351 + cb2_021x;
  float _355 = _352 + cb2_021y;
  float _356 = _353 + cb2_021z;
  float _357 = t0[0].SExposureData_000;
  float _359 = max(_228.x, 0.0010000000474974513f);
  float _360 = 1.0f / _359;
  float _361 = _360 * _357.x;
  bool _364 = ((uint)(cb2_069y) == 0);
  float _370;
  float _371;
  float _372;
  float _426;
  float _427;
  float _428;
  float _474;
  float _475;
  float _476;
  float _521;
  float _522;
  float _523;
  float _524;
  float _573;
  float _574;
  float _575;
  float _576;
  float _601;
  float _602;
  float _603;
  float _704;
  float _705;
  float _706;
  float _731;
  float _743;
  float _771;
  float _783;
  float _795;
  float _796;
  float _797;
  float _824;
  float _825;
  float _826;
  if (!_364) {
    float _366 = _361 * _354;
    float _367 = _361 * _355;
    float _368 = _361 * _356;
    _370 = _366;
    _371 = _367;
    _372 = _368;
  } else {
    _370 = _354;
    _371 = _355;
    _372 = _356;
  }
  float _373 = _370 * 0.6130970120429993f;
  float _374 = mad(0.33952298760414124f, _371, _373);
  float _375 = mad(0.04737899824976921f, _372, _374);
  float _376 = _370 * 0.07019399851560593f;
  float _377 = mad(0.9163540005683899f, _371, _376);
  float _378 = mad(0.013451999984681606f, _372, _377);
  float _379 = _370 * 0.02061600051820278f;
  float _380 = mad(0.10956999659538269f, _371, _379);
  float _381 = mad(0.8698149919509888f, _372, _380);
  float _382 = log2(_375);
  float _383 = log2(_378);
  float _384 = log2(_381);
  float _385 = _382 * 0.04211956635117531f;
  float _386 = _383 * 0.04211956635117531f;
  float _387 = _384 * 0.04211956635117531f;
  float _388 = _385 + 0.6252607107162476f;
  float _389 = _386 + 0.6252607107162476f;
  float _390 = _387 + 0.6252607107162476f;
  float4 _391 = t6.SampleLevel(s2_space2, float3(_388, _389, _390), 0.0f);
  bool _397 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_397 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _401 = cb2_017x * _391.x;
    float _402 = cb2_017x * _391.y;
    float _403 = cb2_017x * _391.z;
    float _405 = _401 + cb2_017y;
    float _406 = _402 + cb2_017y;
    float _407 = _403 + cb2_017y;
    float _408 = exp2(_405);
    float _409 = exp2(_406);
    float _410 = exp2(_407);
    float _411 = _408 + 1.0f;
    float _412 = _409 + 1.0f;
    float _413 = _410 + 1.0f;
    float _414 = 1.0f / _411;
    float _415 = 1.0f / _412;
    float _416 = 1.0f / _413;
    float _418 = cb2_017z * _414;
    float _419 = cb2_017z * _415;
    float _420 = cb2_017z * _416;
    float _422 = _418 + cb2_017w;
    float _423 = _419 + cb2_017w;
    float _424 = _420 + cb2_017w;
    _426 = _422;
    _427 = _423;
    _428 = _424;
  } else {
    _426 = _391.x;
    _427 = _391.y;
    _428 = _391.z;
  }
  float _429 = _426 * 23.0f;
  float _430 = _429 + -14.473931312561035f;
  float _431 = exp2(_430);
  float _432 = _427 * 23.0f;
  float _433 = _432 + -14.473931312561035f;
  float _434 = exp2(_433);
  float _435 = _428 * 23.0f;
  float _436 = _435 + -14.473931312561035f;
  float _437 = exp2(_436);
  float _442 = cb2_004x * TEXCOORD0_centroid.x;
  float _443 = cb2_004y * TEXCOORD0_centroid.y;
  float _446 = _442 + cb2_004z;
  float _447 = _443 + cb2_004w;
  float4 _453 = t8.Sample(s2_space2, float2(_446, _447));
  float _458 = _453.x * cb2_003x;
  float _459 = _453.y * cb2_003y;
  float _460 = _453.z * cb2_003z;
  float _461 = _453.w * cb2_003w;
  float _464 = _461 + cb2_026y;
  float _465 = saturate(_464);
  bool _468 = ((uint)(cb2_069y) == 0);
  if (!_468) {
    float _470 = _458 * _361;
    float _471 = _459 * _361;
    float _472 = _460 * _361;
    _474 = _470;
    _475 = _471;
    _476 = _472;
  } else {
    _474 = _458;
    _475 = _459;
    _476 = _460;
  }
  bool _479 = ((uint)(cb2_028x) == 2);
  bool _480 = ((uint)(cb2_028x) == 3);
  int _481 = (uint)(cb2_028x) & -2;
  bool _482 = (_481 == 2);
  bool _483 = ((uint)(cb2_028x) == 6);
  bool _484 = _482 || _483;
  if (_484) {
    float _486 = _474 * _465;
    float _487 = _475 * _465;
    float _488 = _476 * _465;
    float _489 = _465 * _465;
    _521 = _486;
    _522 = _487;
    _523 = _488;
    _524 = _489;
  } else {
    bool _491 = ((uint)(cb2_028x) == 4);
    if (_491) {
      float _493 = _474 + -1.0f;
      float _494 = _475 + -1.0f;
      float _495 = _476 + -1.0f;
      float _496 = _465 + -1.0f;
      float _497 = _493 * _465;
      float _498 = _494 * _465;
      float _499 = _495 * _465;
      float _500 = _496 * _465;
      float _501 = _497 + 1.0f;
      float _502 = _498 + 1.0f;
      float _503 = _499 + 1.0f;
      float _504 = _500 + 1.0f;
      _521 = _501;
      _522 = _502;
      _523 = _503;
      _524 = _504;
    } else {
      bool _506 = ((uint)(cb2_028x) == 5);
      if (_506) {
        float _508 = _474 + -0.5f;
        float _509 = _475 + -0.5f;
        float _510 = _476 + -0.5f;
        float _511 = _465 + -0.5f;
        float _512 = _508 * _465;
        float _513 = _509 * _465;
        float _514 = _510 * _465;
        float _515 = _511 * _465;
        float _516 = _512 + 0.5f;
        float _517 = _513 + 0.5f;
        float _518 = _514 + 0.5f;
        float _519 = _515 + 0.5f;
        _521 = _516;
        _522 = _517;
        _523 = _518;
        _524 = _519;
      } else {
        _521 = _474;
        _522 = _475;
        _523 = _476;
        _524 = _465;
      }
    }
  }
  if (_479) {
    float _526 = _521 + _431;
    float _527 = _522 + _434;
    float _528 = _523 + _437;
    _573 = _526;
    _574 = _527;
    _575 = _528;
    _576 = cb2_025w;
  } else {
    if (_480) {
      float _531 = 1.0f - _521;
      float _532 = 1.0f - _522;
      float _533 = 1.0f - _523;
      float _534 = _531 * _431;
      float _535 = _532 * _434;
      float _536 = _533 * _437;
      float _537 = _534 + _521;
      float _538 = _535 + _522;
      float _539 = _536 + _523;
      _573 = _537;
      _574 = _538;
      _575 = _539;
      _576 = cb2_025w;
    } else {
      bool _541 = ((uint)(cb2_028x) == 4);
      if (_541) {
        float _543 = _521 * _431;
        float _544 = _522 * _434;
        float _545 = _523 * _437;
        _573 = _543;
        _574 = _544;
        _575 = _545;
        _576 = cb2_025w;
      } else {
        bool _547 = ((uint)(cb2_028x) == 5);
        if (_547) {
          float _549 = _431 * 2.0f;
          float _550 = _549 * _521;
          float _551 = _434 * 2.0f;
          float _552 = _551 * _522;
          float _553 = _437 * 2.0f;
          float _554 = _553 * _523;
          _573 = _550;
          _574 = _552;
          _575 = _554;
          _576 = cb2_025w;
        } else {
          if (_483) {
            float _557 = _431 - _521;
            float _558 = _434 - _522;
            float _559 = _437 - _523;
            _573 = _557;
            _574 = _558;
            _575 = _559;
            _576 = cb2_025w;
          } else {
            float _561 = _521 - _431;
            float _562 = _522 - _434;
            float _563 = _523 - _437;
            float _564 = _524 * _561;
            float _565 = _524 * _562;
            float _566 = _524 * _563;
            float _567 = _564 + _431;
            float _568 = _565 + _434;
            float _569 = _566 + _437;
            float _570 = 1.0f - _524;
            float _571 = _570 * cb2_025w;
            _573 = _567;
            _574 = _568;
            _575 = _569;
            _576 = _571;
          }
        }
      }
    }
  }
  float _582 = cb2_016x - _573;
  float _583 = cb2_016y - _574;
  float _584 = cb2_016z - _575;
  float _585 = _582 * cb2_016w;
  float _586 = _583 * cb2_016w;
  float _587 = _584 * cb2_016w;
  float _588 = _585 + _573;
  float _589 = _586 + _574;
  float _590 = _587 + _575;
  bool _593 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_593 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _597 = cb2_024x * _588;
    float _598 = cb2_024x * _589;
    float _599 = cb2_024x * _590;
    _601 = _597;
    _602 = _598;
    _603 = _599;
  } else {
    _601 = _588;
    _602 = _589;
    _603 = _590;
  }
  float _604 = _601 * 0.9708889722824097f;
  float _605 = mad(0.026962999254465103f, _602, _604);
  float _606 = mad(0.002148000057786703f, _603, _605);
  float _607 = _601 * 0.01088900025933981f;
  float _608 = mad(0.9869629740715027f, _602, _607);
  float _609 = mad(0.002148000057786703f, _603, _608);
  float _610 = mad(0.026962999254465103f, _602, _607);
  float _611 = mad(0.9621480107307434f, _603, _610);
  if (_593) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _616 = cb1_018y * 0.10000000149011612f;
        float _617 = log2(cb1_018z);
        float _618 = _617 + -13.287712097167969f;
        float _619 = _618 * 1.4929734468460083f;
        float _620 = _619 + 18.0f;
        float _621 = exp2(_620);
        float _622 = _621 * 0.18000000715255737f;
        float _623 = abs(_622);
        float _624 = log2(_623);
        float _625 = _624 * 1.5f;
        float _626 = exp2(_625);
        float _627 = _626 * _616;
        float _628 = _627 / cb1_018z;
        float _629 = _628 + -0.07636754959821701f;
        float _630 = _624 * 1.2750000953674316f;
        float _631 = exp2(_630);
        float _632 = _631 * 0.07636754959821701f;
        float _633 = cb1_018y * 0.011232397519052029f;
        float _634 = _633 * _626;
        float _635 = _634 / cb1_018z;
        float _636 = _632 - _635;
        float _637 = _631 + -0.11232396960258484f;
        float _638 = _637 * _616;
        float _639 = _638 / cb1_018z;
        float _640 = _639 * cb1_018z;
        float _641 = abs(_606);
        float _642 = abs(_609);
        float _643 = abs(_611);
        float _644 = log2(_641);
        float _645 = log2(_642);
        float _646 = log2(_643);
        float _647 = _644 * 1.5f;
        float _648 = _645 * 1.5f;
        float _649 = _646 * 1.5f;
        float _650 = exp2(_647);
        float _651 = exp2(_648);
        float _652 = exp2(_649);
        float _653 = _650 * _640;
        float _654 = _651 * _640;
        float _655 = _652 * _640;
        float _656 = _644 * 1.2750000953674316f;
        float _657 = _645 * 1.2750000953674316f;
        float _658 = _646 * 1.2750000953674316f;
        float _659 = exp2(_656);
        float _660 = exp2(_657);
        float _661 = exp2(_658);
        float _662 = _659 * _629;
        float _663 = _660 * _629;
        float _664 = _661 * _629;
        float _665 = _662 + _636;
        float _666 = _663 + _636;
        float _667 = _664 + _636;
        float _668 = _653 / _665;
        float _669 = _654 / _666;
        float _670 = _655 / _667;
        float _671 = _668 * 9.999999747378752e-05f;
        float _672 = _669 * 9.999999747378752e-05f;
        float _673 = _670 * 9.999999747378752e-05f;
        float _674 = 5000.0f / cb1_018y;
        float _675 = _671 * _674;
        float _676 = _672 * _674;
        float _677 = _673 * _674;
        _704 = _675;
        _705 = _676;
        _706 = _677;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_606, _609, _611));
      _704 = tonemapped.x, _705 = tonemapped.y, _706 = tonemapped.z;
    }
      } else {
        float _679 = _606 + 0.020616600289940834f;
        float _680 = _609 + 0.020616600289940834f;
        float _681 = _611 + 0.020616600289940834f;
        float _682 = _679 * _606;
        float _683 = _680 * _609;
        float _684 = _681 * _611;
        float _685 = _682 + -7.456949970219284e-05f;
        float _686 = _683 + -7.456949970219284e-05f;
        float _687 = _684 + -7.456949970219284e-05f;
        float _688 = _606 * 0.9837960004806519f;
        float _689 = _609 * 0.9837960004806519f;
        float _690 = _611 * 0.9837960004806519f;
        float _691 = _688 + 0.4336790144443512f;
        float _692 = _689 + 0.4336790144443512f;
        float _693 = _690 + 0.4336790144443512f;
        float _694 = _691 * _606;
        float _695 = _692 * _609;
        float _696 = _693 * _611;
        float _697 = _694 + 0.24617899954319f;
        float _698 = _695 + 0.24617899954319f;
        float _699 = _696 + 0.24617899954319f;
        float _700 = _685 / _697;
        float _701 = _686 / _698;
        float _702 = _687 / _699;
        _704 = _700;
        _705 = _701;
        _706 = _702;
      }
      float _707 = _704 * 1.6047500371932983f;
      float _708 = mad(-0.5310800075531006f, _705, _707);
      float _709 = mad(-0.07366999983787537f, _706, _708);
      float _710 = _704 * -0.10208000242710114f;
      float _711 = mad(1.1081299781799316f, _705, _710);
      float _712 = mad(-0.006049999967217445f, _706, _711);
      float _713 = _704 * -0.0032599999103695154f;
      float _714 = mad(-0.07275000214576721f, _705, _713);
      float _715 = mad(1.0760200023651123f, _706, _714);
      if (_593) {
        // float _717 = max(_709, 0.0f);
        // float _718 = max(_712, 0.0f);
        // float _719 = max(_715, 0.0f);
        // bool _720 = !(_717 >= 0.0030399328097701073f);
        // if (!_720) {
        //   float _722 = abs(_717);
        //   float _723 = log2(_722);
        //   float _724 = _723 * 0.4166666567325592f;
        //   float _725 = exp2(_724);
        //   float _726 = _725 * 1.0549999475479126f;
        //   float _727 = _726 + -0.054999999701976776f;
        //   _731 = _727;
        // } else {
        //   float _729 = _717 * 12.923210144042969f;
        //   _731 = _729;
        // }
        // bool _732 = !(_718 >= 0.0030399328097701073f);
        // if (!_732) {
        //   float _734 = abs(_718);
        //   float _735 = log2(_734);
        //   float _736 = _735 * 0.4166666567325592f;
        //   float _737 = exp2(_736);
        //   float _738 = _737 * 1.0549999475479126f;
        //   float _739 = _738 + -0.054999999701976776f;
        //   _743 = _739;
        // } else {
        //   float _741 = _718 * 12.923210144042969f;
        //   _743 = _741;
        // }
        // bool _744 = !(_719 >= 0.0030399328097701073f);
        // if (!_744) {
        //   float _746 = abs(_719);
        //   float _747 = log2(_746);
        //   float _748 = _747 * 0.4166666567325592f;
        //   float _749 = exp2(_748);
        //   float _750 = _749 * 1.0549999475479126f;
        //   float _751 = _750 + -0.054999999701976776f;
        //   _824 = _731;
        //   _825 = _743;
        //   _826 = _751;
        // } else {
        //   float _753 = _719 * 12.923210144042969f;
        //   _824 = _731;
        //   _825 = _743;
        //   _826 = _753;
        // }
        _824 = renodx::color::srgb::EncodeSafe(_709);
        _825 = renodx::color::srgb::EncodeSafe(_712);
        _826 = renodx::color::srgb::EncodeSafe(_715);

      } else {
        float _755 = saturate(_709);
        float _756 = saturate(_712);
        float _757 = saturate(_715);
        bool _758 = ((uint)(cb1_018w) == -2);
        if (!_758) {
          bool _760 = !(_755 >= 0.0030399328097701073f);
          if (!_760) {
            float _762 = abs(_755);
            float _763 = log2(_762);
            float _764 = _763 * 0.4166666567325592f;
            float _765 = exp2(_764);
            float _766 = _765 * 1.0549999475479126f;
            float _767 = _766 + -0.054999999701976776f;
            _771 = _767;
          } else {
            float _769 = _755 * 12.923210144042969f;
            _771 = _769;
          }
          bool _772 = !(_756 >= 0.0030399328097701073f);
          if (!_772) {
            float _774 = abs(_756);
            float _775 = log2(_774);
            float _776 = _775 * 0.4166666567325592f;
            float _777 = exp2(_776);
            float _778 = _777 * 1.0549999475479126f;
            float _779 = _778 + -0.054999999701976776f;
            _783 = _779;
          } else {
            float _781 = _756 * 12.923210144042969f;
            _783 = _781;
          }
          bool _784 = !(_757 >= 0.0030399328097701073f);
          if (!_784) {
            float _786 = abs(_757);
            float _787 = log2(_786);
            float _788 = _787 * 0.4166666567325592f;
            float _789 = exp2(_788);
            float _790 = _789 * 1.0549999475479126f;
            float _791 = _790 + -0.054999999701976776f;
            _795 = _771;
            _796 = _783;
            _797 = _791;
          } else {
            float _793 = _757 * 12.923210144042969f;
            _795 = _771;
            _796 = _783;
            _797 = _793;
          }
        } else {
          _795 = _755;
          _796 = _756;
          _797 = _757;
        }
        float _802 = abs(_795);
        float _803 = abs(_796);
        float _804 = abs(_797);
        float _805 = log2(_802);
        float _806 = log2(_803);
        float _807 = log2(_804);
        float _808 = _805 * cb2_000z;
        float _809 = _806 * cb2_000z;
        float _810 = _807 * cb2_000z;
        float _811 = exp2(_808);
        float _812 = exp2(_809);
        float _813 = exp2(_810);
        float _814 = _811 * cb2_000y;
        float _815 = _812 * cb2_000y;
        float _816 = _813 * cb2_000y;
        float _817 = _814 + cb2_000x;
        float _818 = _815 + cb2_000x;
        float _819 = _816 + cb2_000x;
        float _820 = saturate(_817);
        float _821 = saturate(_818);
        float _822 = saturate(_819);
        _824 = _820;
        _825 = _821;
        _826 = _822;
      }
      float _830 = cb2_023x * TEXCOORD0_centroid.x;
      float _831 = cb2_023y * TEXCOORD0_centroid.y;
      float _834 = _830 + cb2_023z;
      float _835 = _831 + cb2_023w;
      float4 _838 = t12.SampleLevel(s0_space2, float2(_834, _835), 0.0f);
      float _840 = _838.x + -0.5f;
      float _841 = _840 * cb2_022x;
      float _842 = _841 + 0.5f;
      float _843 = _842 * 2.0f;
      float _844 = _843 * _824;
      float _845 = _843 * _825;
      float _846 = _843 * _826;
      float _850 = float((uint)(cb2_019z));
      float _851 = float((uint)(cb2_019w));
      float _852 = _850 + SV_Position.x;
      float _853 = _851 + SV_Position.y;
      uint _854 = uint(_852);
      uint _855 = uint(_853);
      uint _858 = cb2_019x + -1u;
      uint _859 = cb2_019y + -1u;
      int _860 = _854 & _858;
      int _861 = _855 & _859;
      float4 _862 = t3.Load(int3(_860, _861, 0));
      float _866 = _862.x * 2.0f;
      float _867 = _862.y * 2.0f;
      float _868 = _862.z * 2.0f;
      float _869 = _866 + -1.0f;
      float _870 = _867 + -1.0f;
      float _871 = _868 + -1.0f;
      float _872 = _869 * _576;
      float _873 = _870 * _576;
      float _874 = _871 * _576;
      float _875 = _872 + _844;
      float _876 = _873 + _845;
      float _877 = _874 + _846;
      float _878 = dot(float3(_875, _876, _877), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _875;
      SV_Target.y = _876;
      SV_Target.z = _877;
      SV_Target.w = _878;
      SV_Target_1.x = _878;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
