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
  float _27 = cb2_015x * TEXCOORD0_centroid.x;
  float _28 = cb2_015y * TEXCOORD0_centroid.y;
  float _31 = _27 + cb2_015z;
  float _32 = _28 + cb2_015w;
  float4 _33 = t8.SampleLevel(s0_space2, float2(_31, _32), 0.0f);
  float _37 = saturate(_33.x);
  float _38 = saturate(_33.z);
  float _41 = cb2_026x * _38;
  float _42 = _37 * 6.283199787139893f;
  float _43 = cos(_42);
  float _44 = sin(_42);
  float _45 = _41 * _43;
  float _46 = _44 * _41;
  float _47 = 1.0f - _33.y;
  float _48 = saturate(_47);
  float _49 = _45 * _48;
  float _50 = _46 * _48;
  float _51 = _49 + TEXCOORD0_centroid.x;
  float _52 = _50 + TEXCOORD0_centroid.y;
  float4 _53 = t1.SampleLevel(s4_space2, float2(_51, _52), 0.0f);
  float _57 = max(_53.x, 0.0f);
  float _58 = max(_53.y, 0.0f);
  float _59 = max(_53.z, 0.0f);
  float _60 = min(_57, 65000.0f);
  float _61 = min(_58, 65000.0f);
  float _62 = min(_59, 65000.0f);
  float4 _63 = t3.SampleLevel(s2_space2, float2(_51, _52), 0.0f);
  float _68 = max(_63.x, 0.0f);
  float _69 = max(_63.y, 0.0f);
  float _70 = max(_63.z, 0.0f);
  float _71 = max(_63.w, 0.0f);
  float _72 = min(_68, 5000.0f);
  float _73 = min(_69, 5000.0f);
  float _74 = min(_70, 5000.0f);
  float _75 = min(_71, 5000.0f);
  float _78 = _22.x * cb0_028z;
  float _79 = _78 + cb0_028x;
  float _80 = cb2_027w / _79;
  float _81 = 1.0f - _80;
  float _82 = abs(_81);
  float _84 = cb2_027y * _82;
  float _86 = _84 - cb2_027z;
  float _87 = saturate(_86);
  float _88 = max(_87, _75);
  float _89 = saturate(_88);
  float _93 = cb2_006x * _51;
  float _94 = cb2_006y * _52;
  float _97 = _93 + cb2_006z;
  float _98 = _94 + cb2_006w;
  float _102 = cb2_007x * _51;
  float _103 = cb2_007y * _52;
  float _106 = _102 + cb2_007z;
  float _107 = _103 + cb2_007w;
  float _111 = cb2_008x * _51;
  float _112 = cb2_008y * _52;
  float _115 = _111 + cb2_008z;
  float _116 = _112 + cb2_008w;
  float4 _117 = t1.SampleLevel(s2_space2, float2(_97, _98), 0.0f);
  float _119 = max(_117.x, 0.0f);
  float _120 = min(_119, 65000.0f);
  float4 _121 = t1.SampleLevel(s2_space2, float2(_106, _107), 0.0f);
  float _123 = max(_121.y, 0.0f);
  float _124 = min(_123, 65000.0f);
  float4 _125 = t1.SampleLevel(s2_space2, float2(_115, _116), 0.0f);
  float _127 = max(_125.z, 0.0f);
  float _128 = min(_127, 65000.0f);
  float4 _129 = t3.SampleLevel(s2_space2, float2(_97, _98), 0.0f);
  float _131 = max(_129.x, 0.0f);
  float _132 = min(_131, 5000.0f);
  float4 _133 = t3.SampleLevel(s2_space2, float2(_106, _107), 0.0f);
  float _135 = max(_133.y, 0.0f);
  float _136 = min(_135, 5000.0f);
  float4 _137 = t3.SampleLevel(s2_space2, float2(_115, _116), 0.0f);
  float _139 = max(_137.z, 0.0f);
  float _140 = min(_139, 5000.0f);
  float4 _141 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _147 = cb2_005x * _141.x;
  float _148 = cb2_005x * _141.y;
  float _149 = cb2_005x * _141.z;
  float _150 = _120 - _60;
  float _151 = _124 - _61;
  float _152 = _128 - _62;
  float _153 = _147 * _150;
  float _154 = _148 * _151;
  float _155 = _149 * _152;
  float _156 = _153 + _60;
  float _157 = _154 + _61;
  float _158 = _155 + _62;
  float _159 = _132 - _72;
  float _160 = _136 - _73;
  float _161 = _140 - _74;
  float _162 = _147 * _159;
  float _163 = _148 * _160;
  float _164 = _149 * _161;
  float _165 = _162 + _72;
  float _166 = _163 + _73;
  float _167 = _164 + _74;
  float4 _168 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _172 = _165 - _156;
  float _173 = _166 - _157;
  float _174 = _167 - _158;
  float _175 = _172 * _89;
  float _176 = _173 * _89;
  float _177 = _174 * _89;
  float _178 = _175 + _156;
  float _179 = _176 + _157;
  float _180 = _177 + _158;
  float _181 = dot(float3(_178, _179, _180), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _185 = t0[0].SExposureData_020;
  float _187 = t0[0].SExposureData_004;
  float _189 = cb2_018x * 0.5f;
  float _190 = _189 * cb2_018y;
  float _191 = _187.x - _190;
  float _192 = cb2_018y * cb2_018x;
  float _193 = 1.0f / _192;
  float _194 = _191 * _193;
  float _195 = _181 / _185.x;
  float _196 = _195 * 5464.01611328125f;
  float _197 = _196 + 9.99999993922529e-09f;
  float _198 = log2(_197);
  float _199 = _198 - _191;
  float _200 = _199 * _193;
  float _201 = saturate(_200);
  float2 _202 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _201), 0.0f);
  float _205 = max(_202.y, 1.0000000116860974e-07f);
  float _206 = _202.x / _205;
  float _207 = _206 + _194;
  float _208 = _207 / _193;
  float _209 = _208 - _187.x;
  float _210 = -0.0f - _209;
  float _212 = _210 - cb2_027x;
  float _213 = max(0.0f, _212);
  float _215 = cb2_026z * _213;
  float _216 = _209 - cb2_027x;
  float _217 = max(0.0f, _216);
  float _219 = cb2_026w * _217;
  bool _220 = (_209 < 0.0f);
  float _221 = select(_220, _215, _219);
  float _222 = exp2(_221);
  float _223 = _222 * _178;
  float _224 = _222 * _179;
  float _225 = _222 * _180;
  float _230 = cb2_024y * _168.x;
  float _231 = cb2_024z * _168.y;
  float _232 = cb2_024w * _168.z;
  float _233 = _230 + _223;
  float _234 = _231 + _224;
  float _235 = _232 + _225;
  float _240 = _233 * cb2_025x;
  float _241 = _234 * cb2_025y;
  float _242 = _235 * cb2_025z;
  float _243 = dot(float3(_240, _241, _242), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _244 = t0[0].SExposureData_012;
  float _246 = _243 * 5464.01611328125f;
  float _247 = _246 * _244.x;
  float _248 = _247 + 9.99999993922529e-09f;
  float _249 = log2(_248);
  float _250 = _249 + 16.929765701293945f;
  float _251 = _250 * 0.05734497308731079f;
  float _252 = saturate(_251);
  float _253 = _252 * _252;
  float _254 = _252 * 2.0f;
  float _255 = 3.0f - _254;
  float _256 = _253 * _255;
  float _257 = _241 * 0.8450999855995178f;
  float _258 = _242 * 0.14589999616146088f;
  float _259 = _257 + _258;
  float _260 = _259 * 2.4890189170837402f;
  float _261 = _259 * 0.3754962384700775f;
  float _262 = _259 * 2.811495304107666f;
  float _263 = _259 * 5.519708156585693f;
  float _264 = _243 - _260;
  float _265 = _256 * _264;
  float _266 = _265 + _260;
  float _267 = _256 * 0.5f;
  float _268 = _267 + 0.5f;
  float _269 = _268 * _264;
  float _270 = _269 + _260;
  float _271 = _240 - _261;
  float _272 = _241 - _262;
  float _273 = _242 - _263;
  float _274 = _268 * _271;
  float _275 = _268 * _272;
  float _276 = _268 * _273;
  float _277 = _274 + _261;
  float _278 = _275 + _262;
  float _279 = _276 + _263;
  float _280 = 1.0f / _270;
  float _281 = _266 * _280;
  float _282 = _281 * _277;
  float _283 = _281 * _278;
  float _284 = _281 * _279;
  float _288 = cb2_020x * TEXCOORD0_centroid.x;
  float _289 = cb2_020y * TEXCOORD0_centroid.y;
  float _292 = _288 + cb2_020z;
  float _293 = _289 + cb2_020w;
  float _296 = dot(float2(_292, _293), float2(_292, _293));
  float _297 = 1.0f - _296;
  float _298 = saturate(_297);
  float _299 = log2(_298);
  float _300 = _299 * cb2_021w;
  float _301 = exp2(_300);
  float _305 = _282 - cb2_021x;
  float _306 = _283 - cb2_021y;
  float _307 = _284 - cb2_021z;
  float _308 = _305 * _301;
  float _309 = _306 * _301;
  float _310 = _307 * _301;
  float _311 = _308 + cb2_021x;
  float _312 = _309 + cb2_021y;
  float _313 = _310 + cb2_021z;
  float _314 = t0[0].SExposureData_000;
  float _316 = max(_185.x, 0.0010000000474974513f);
  float _317 = 1.0f / _316;
  float _318 = _317 * _314.x;
  bool _321 = ((uint)(cb2_069y) == 0);
  float _327;
  float _328;
  float _329;
  float _383;
  float _384;
  float _385;
  float _475;
  float _476;
  float _477;
  float _522;
  float _523;
  float _524;
  float _525;
  float _572;
  float _573;
  float _574;
  float _599;
  float _600;
  float _601;
  float _702;
  float _703;
  float _704;
  float _729;
  float _741;
  float _769;
  float _781;
  float _793;
  float _794;
  float _795;
  float _822;
  float _823;
  float _824;
  if (!_321) {
    float _323 = _318 * _311;
    float _324 = _318 * _312;
    float _325 = _318 * _313;
    _327 = _323;
    _328 = _324;
    _329 = _325;
  } else {
    _327 = _311;
    _328 = _312;
    _329 = _313;
  }
  float _330 = _327 * 0.6130970120429993f;
  float _331 = mad(0.33952298760414124f, _328, _330);
  float _332 = mad(0.04737899824976921f, _329, _331);
  float _333 = _327 * 0.07019399851560593f;
  float _334 = mad(0.9163540005683899f, _328, _333);
  float _335 = mad(0.013451999984681606f, _329, _334);
  float _336 = _327 * 0.02061600051820278f;
  float _337 = mad(0.10956999659538269f, _328, _336);
  float _338 = mad(0.8698149919509888f, _329, _337);
  float _339 = log2(_332);
  float _340 = log2(_335);
  float _341 = log2(_338);
  float _342 = _339 * 0.04211956635117531f;
  float _343 = _340 * 0.04211956635117531f;
  float _344 = _341 * 0.04211956635117531f;
  float _345 = _342 + 0.6252607107162476f;
  float _346 = _343 + 0.6252607107162476f;
  float _347 = _344 + 0.6252607107162476f;
  float4 _348 = t5.SampleLevel(s2_space2, float3(_345, _346, _347), 0.0f);
  bool _354 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_354 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _358 = cb2_017x * _348.x;
    float _359 = cb2_017x * _348.y;
    float _360 = cb2_017x * _348.z;
    float _362 = _358 + cb2_017y;
    float _363 = _359 + cb2_017y;
    float _364 = _360 + cb2_017y;
    float _365 = exp2(_362);
    float _366 = exp2(_363);
    float _367 = exp2(_364);
    float _368 = _365 + 1.0f;
    float _369 = _366 + 1.0f;
    float _370 = _367 + 1.0f;
    float _371 = 1.0f / _368;
    float _372 = 1.0f / _369;
    float _373 = 1.0f / _370;
    float _375 = cb2_017z * _371;
    float _376 = cb2_017z * _372;
    float _377 = cb2_017z * _373;
    float _379 = _375 + cb2_017w;
    float _380 = _376 + cb2_017w;
    float _381 = _377 + cb2_017w;
    _383 = _379;
    _384 = _380;
    _385 = _381;
  } else {
    _383 = _348.x;
    _384 = _348.y;
    _385 = _348.z;
  }
  float _386 = _383 * 23.0f;
  float _387 = _386 + -14.473931312561035f;
  float _388 = exp2(_387);
  float _389 = _384 * 23.0f;
  float _390 = _389 + -14.473931312561035f;
  float _391 = exp2(_390);
  float _392 = _385 * 23.0f;
  float _393 = _392 + -14.473931312561035f;
  float _394 = exp2(_393);
  float _395 = dot(float3(_388, _391, _394), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _400 = dot(float3(_388, _391, _394), float3(_388, _391, _394));
  float _401 = rsqrt(_400);
  float _402 = _401 * _388;
  float _403 = _401 * _391;
  float _404 = _401 * _394;
  float _405 = cb2_001x - _402;
  float _406 = cb2_001y - _403;
  float _407 = cb2_001z - _404;
  float _408 = dot(float3(_405, _406, _407), float3(_405, _406, _407));
  float _411 = cb2_002z * _408;
  float _413 = _411 + cb2_002w;
  float _414 = saturate(_413);
  float _416 = cb2_002x * _414;
  float _417 = _395 - _388;
  float _418 = _395 - _391;
  float _419 = _395 - _394;
  float _420 = _416 * _417;
  float _421 = _416 * _418;
  float _422 = _416 * _419;
  float _423 = _420 + _388;
  float _424 = _421 + _391;
  float _425 = _422 + _394;
  float _427 = cb2_002y * _414;
  float _428 = 0.10000000149011612f - _423;
  float _429 = 0.10000000149011612f - _424;
  float _430 = 0.10000000149011612f - _425;
  float _431 = _428 * _427;
  float _432 = _429 * _427;
  float _433 = _430 * _427;
  float _434 = _431 + _423;
  float _435 = _432 + _424;
  float _436 = _433 + _425;
  float _437 = saturate(_434);
  float _438 = saturate(_435);
  float _439 = saturate(_436);
  float _443 = cb2_004x * TEXCOORD0_centroid.x;
  float _444 = cb2_004y * TEXCOORD0_centroid.y;
  float _447 = _443 + cb2_004z;
  float _448 = _444 + cb2_004w;
  float4 _454 = t7.Sample(s2_space2, float2(_447, _448));
  float _459 = _454.x * cb2_003x;
  float _460 = _454.y * cb2_003y;
  float _461 = _454.z * cb2_003z;
  float _462 = _454.w * cb2_003w;
  float _465 = _462 + cb2_026y;
  float _466 = saturate(_465);
  bool _469 = ((uint)(cb2_069y) == 0);
  if (!_469) {
    float _471 = _459 * _318;
    float _472 = _460 * _318;
    float _473 = _461 * _318;
    _475 = _471;
    _476 = _472;
    _477 = _473;
  } else {
    _475 = _459;
    _476 = _460;
    _477 = _461;
  }
  bool _480 = ((uint)(cb2_028x) == 2);
  bool _481 = ((uint)(cb2_028x) == 3);
  int _482 = (uint)(cb2_028x) & -2;
  bool _483 = (_482 == 2);
  bool _484 = ((uint)(cb2_028x) == 6);
  bool _485 = _483 || _484;
  if (_485) {
    float _487 = _475 * _466;
    float _488 = _476 * _466;
    float _489 = _477 * _466;
    float _490 = _466 * _466;
    _522 = _487;
    _523 = _488;
    _524 = _489;
    _525 = _490;
  } else {
    bool _492 = ((uint)(cb2_028x) == 4);
    if (_492) {
      float _494 = _475 + -1.0f;
      float _495 = _476 + -1.0f;
      float _496 = _477 + -1.0f;
      float _497 = _466 + -1.0f;
      float _498 = _494 * _466;
      float _499 = _495 * _466;
      float _500 = _496 * _466;
      float _501 = _497 * _466;
      float _502 = _498 + 1.0f;
      float _503 = _499 + 1.0f;
      float _504 = _500 + 1.0f;
      float _505 = _501 + 1.0f;
      _522 = _502;
      _523 = _503;
      _524 = _504;
      _525 = _505;
    } else {
      bool _507 = ((uint)(cb2_028x) == 5);
      if (_507) {
        float _509 = _475 + -0.5f;
        float _510 = _476 + -0.5f;
        float _511 = _477 + -0.5f;
        float _512 = _466 + -0.5f;
        float _513 = _509 * _466;
        float _514 = _510 * _466;
        float _515 = _511 * _466;
        float _516 = _512 * _466;
        float _517 = _513 + 0.5f;
        float _518 = _514 + 0.5f;
        float _519 = _515 + 0.5f;
        float _520 = _516 + 0.5f;
        _522 = _517;
        _523 = _518;
        _524 = _519;
        _525 = _520;
      } else {
        _522 = _475;
        _523 = _476;
        _524 = _477;
        _525 = _466;
      }
    }
  }
  if (_480) {
    float _527 = _522 + _437;
    float _528 = _523 + _438;
    float _529 = _524 + _439;
    _572 = _527;
    _573 = _528;
    _574 = _529;
  } else {
    if (_481) {
      float _532 = 1.0f - _522;
      float _533 = 1.0f - _523;
      float _534 = 1.0f - _524;
      float _535 = _532 * _437;
      float _536 = _533 * _438;
      float _537 = _534 * _439;
      float _538 = _535 + _522;
      float _539 = _536 + _523;
      float _540 = _537 + _524;
      _572 = _538;
      _573 = _539;
      _574 = _540;
    } else {
      bool _542 = ((uint)(cb2_028x) == 4);
      if (_542) {
        float _544 = _522 * _437;
        float _545 = _523 * _438;
        float _546 = _524 * _439;
        _572 = _544;
        _573 = _545;
        _574 = _546;
      } else {
        bool _548 = ((uint)(cb2_028x) == 5);
        if (_548) {
          float _550 = _437 * 2.0f;
          float _551 = _550 * _522;
          float _552 = _438 * 2.0f;
          float _553 = _552 * _523;
          float _554 = _439 * 2.0f;
          float _555 = _554 * _524;
          _572 = _551;
          _573 = _553;
          _574 = _555;
        } else {
          if (_484) {
            float _558 = _437 - _522;
            float _559 = _438 - _523;
            float _560 = _439 - _524;
            _572 = _558;
            _573 = _559;
            _574 = _560;
          } else {
            float _562 = _522 - _437;
            float _563 = _523 - _438;
            float _564 = _524 - _439;
            float _565 = _525 * _562;
            float _566 = _525 * _563;
            float _567 = _525 * _564;
            float _568 = _565 + _437;
            float _569 = _566 + _438;
            float _570 = _567 + _439;
            _572 = _568;
            _573 = _569;
            _574 = _570;
          }
        }
      }
    }
  }
  float _580 = cb2_016x - _572;
  float _581 = cb2_016y - _573;
  float _582 = cb2_016z - _574;
  float _583 = _580 * cb2_016w;
  float _584 = _581 * cb2_016w;
  float _585 = _582 * cb2_016w;
  float _586 = _583 + _572;
  float _587 = _584 + _573;
  float _588 = _585 + _574;
  bool _591 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_591 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _595 = cb2_024x * _586;
    float _596 = cb2_024x * _587;
    float _597 = cb2_024x * _588;
    _599 = _595;
    _600 = _596;
    _601 = _597;
  } else {
    _599 = _586;
    _600 = _587;
    _601 = _588;
  }
  float _602 = _599 * 0.9708889722824097f;
  float _603 = mad(0.026962999254465103f, _600, _602);
  float _604 = mad(0.002148000057786703f, _601, _603);
  float _605 = _599 * 0.01088900025933981f;
  float _606 = mad(0.9869629740715027f, _600, _605);
  float _607 = mad(0.002148000057786703f, _601, _606);
  float _608 = mad(0.026962999254465103f, _600, _605);
  float _609 = mad(0.9621480107307434f, _601, _608);
  if (_591) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _614 = cb1_018y * 0.10000000149011612f;
        float _615 = log2(cb1_018z);
        float _616 = _615 + -13.287712097167969f;
        float _617 = _616 * 1.4929734468460083f;
        float _618 = _617 + 18.0f;
        float _619 = exp2(_618);
        float _620 = _619 * 0.18000000715255737f;
        float _621 = abs(_620);
        float _622 = log2(_621);
        float _623 = _622 * 1.5f;
        float _624 = exp2(_623);
        float _625 = _624 * _614;
        float _626 = _625 / cb1_018z;
        float _627 = _626 + -0.07636754959821701f;
        float _628 = _622 * 1.2750000953674316f;
        float _629 = exp2(_628);
        float _630 = _629 * 0.07636754959821701f;
        float _631 = cb1_018y * 0.011232397519052029f;
        float _632 = _631 * _624;
        float _633 = _632 / cb1_018z;
        float _634 = _630 - _633;
        float _635 = _629 + -0.11232396960258484f;
        float _636 = _635 * _614;
        float _637 = _636 / cb1_018z;
        float _638 = _637 * cb1_018z;
        float _639 = abs(_604);
        float _640 = abs(_607);
        float _641 = abs(_609);
        float _642 = log2(_639);
        float _643 = log2(_640);
        float _644 = log2(_641);
        float _645 = _642 * 1.5f;
        float _646 = _643 * 1.5f;
        float _647 = _644 * 1.5f;
        float _648 = exp2(_645);
        float _649 = exp2(_646);
        float _650 = exp2(_647);
        float _651 = _648 * _638;
        float _652 = _649 * _638;
        float _653 = _650 * _638;
        float _654 = _642 * 1.2750000953674316f;
        float _655 = _643 * 1.2750000953674316f;
        float _656 = _644 * 1.2750000953674316f;
        float _657 = exp2(_654);
        float _658 = exp2(_655);
        float _659 = exp2(_656);
        float _660 = _657 * _627;
        float _661 = _658 * _627;
        float _662 = _659 * _627;
        float _663 = _660 + _634;
        float _664 = _661 + _634;
        float _665 = _662 + _634;
        float _666 = _651 / _663;
        float _667 = _652 / _664;
        float _668 = _653 / _665;
        float _669 = _666 * 9.999999747378752e-05f;
        float _670 = _667 * 9.999999747378752e-05f;
        float _671 = _668 * 9.999999747378752e-05f;
        float _672 = 5000.0f / cb1_018y;
        float _673 = _669 * _672;
        float _674 = _670 * _672;
        float _675 = _671 * _672;
        _702 = _673;
        _703 = _674;
        _704 = _675;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_604, _607, _609));
      _702 = tonemapped.x, _703 = tonemapped.y, _704 = tonemapped.z;
    }
      } else {
        float _677 = _604 + 0.020616600289940834f;
        float _678 = _607 + 0.020616600289940834f;
        float _679 = _609 + 0.020616600289940834f;
        float _680 = _677 * _604;
        float _681 = _678 * _607;
        float _682 = _679 * _609;
        float _683 = _680 + -7.456949970219284e-05f;
        float _684 = _681 + -7.456949970219284e-05f;
        float _685 = _682 + -7.456949970219284e-05f;
        float _686 = _604 * 0.9837960004806519f;
        float _687 = _607 * 0.9837960004806519f;
        float _688 = _609 * 0.9837960004806519f;
        float _689 = _686 + 0.4336790144443512f;
        float _690 = _687 + 0.4336790144443512f;
        float _691 = _688 + 0.4336790144443512f;
        float _692 = _689 * _604;
        float _693 = _690 * _607;
        float _694 = _691 * _609;
        float _695 = _692 + 0.24617899954319f;
        float _696 = _693 + 0.24617899954319f;
        float _697 = _694 + 0.24617899954319f;
        float _698 = _683 / _695;
        float _699 = _684 / _696;
        float _700 = _685 / _697;
        _702 = _698;
        _703 = _699;
        _704 = _700;
      }
      float _705 = _702 * 1.6047500371932983f;
      float _706 = mad(-0.5310800075531006f, _703, _705);
      float _707 = mad(-0.07366999983787537f, _704, _706);
      float _708 = _702 * -0.10208000242710114f;
      float _709 = mad(1.1081299781799316f, _703, _708);
      float _710 = mad(-0.006049999967217445f, _704, _709);
      float _711 = _702 * -0.0032599999103695154f;
      float _712 = mad(-0.07275000214576721f, _703, _711);
      float _713 = mad(1.0760200023651123f, _704, _712);
      if (_591) {
        // float _715 = max(_707, 0.0f);
        // float _716 = max(_710, 0.0f);
        // float _717 = max(_713, 0.0f);
        // bool _718 = !(_715 >= 0.0030399328097701073f);
        // if (!_718) {
        //   float _720 = abs(_715);
        //   float _721 = log2(_720);
        //   float _722 = _721 * 0.4166666567325592f;
        //   float _723 = exp2(_722);
        //   float _724 = _723 * 1.0549999475479126f;
        //   float _725 = _724 + -0.054999999701976776f;
        //   _729 = _725;
        // } else {
        //   float _727 = _715 * 12.923210144042969f;
        //   _729 = _727;
        // }
        // bool _730 = !(_716 >= 0.0030399328097701073f);
        // if (!_730) {
        //   float _732 = abs(_716);
        //   float _733 = log2(_732);
        //   float _734 = _733 * 0.4166666567325592f;
        //   float _735 = exp2(_734);
        //   float _736 = _735 * 1.0549999475479126f;
        //   float _737 = _736 + -0.054999999701976776f;
        //   _741 = _737;
        // } else {
        //   float _739 = _716 * 12.923210144042969f;
        //   _741 = _739;
        // }
        // bool _742 = !(_717 >= 0.0030399328097701073f);
        // if (!_742) {
        //   float _744 = abs(_717);
        //   float _745 = log2(_744);
        //   float _746 = _745 * 0.4166666567325592f;
        //   float _747 = exp2(_746);
        //   float _748 = _747 * 1.0549999475479126f;
        //   float _749 = _748 + -0.054999999701976776f;
        //   _822 = _729;
        //   _823 = _741;
        //   _824 = _749;
        // } else {
        //   float _751 = _717 * 12.923210144042969f;
        //   _822 = _729;
        //   _823 = _741;
        //   _824 = _751;
        // }
        _822 = renodx::color::srgb::EncodeSafe(_707);
        _823 = renodx::color::srgb::EncodeSafe(_710);
        _824 = renodx::color::srgb::EncodeSafe(_713);

      } else {
        float _753 = saturate(_707);
        float _754 = saturate(_710);
        float _755 = saturate(_713);
        bool _756 = ((uint)(cb1_018w) == -2);
        if (!_756) {
          bool _758 = !(_753 >= 0.0030399328097701073f);
          if (!_758) {
            float _760 = abs(_753);
            float _761 = log2(_760);
            float _762 = _761 * 0.4166666567325592f;
            float _763 = exp2(_762);
            float _764 = _763 * 1.0549999475479126f;
            float _765 = _764 + -0.054999999701976776f;
            _769 = _765;
          } else {
            float _767 = _753 * 12.923210144042969f;
            _769 = _767;
          }
          bool _770 = !(_754 >= 0.0030399328097701073f);
          if (!_770) {
            float _772 = abs(_754);
            float _773 = log2(_772);
            float _774 = _773 * 0.4166666567325592f;
            float _775 = exp2(_774);
            float _776 = _775 * 1.0549999475479126f;
            float _777 = _776 + -0.054999999701976776f;
            _781 = _777;
          } else {
            float _779 = _754 * 12.923210144042969f;
            _781 = _779;
          }
          bool _782 = !(_755 >= 0.0030399328097701073f);
          if (!_782) {
            float _784 = abs(_755);
            float _785 = log2(_784);
            float _786 = _785 * 0.4166666567325592f;
            float _787 = exp2(_786);
            float _788 = _787 * 1.0549999475479126f;
            float _789 = _788 + -0.054999999701976776f;
            _793 = _769;
            _794 = _781;
            _795 = _789;
          } else {
            float _791 = _755 * 12.923210144042969f;
            _793 = _769;
            _794 = _781;
            _795 = _791;
          }
        } else {
          _793 = _753;
          _794 = _754;
          _795 = _755;
        }
        float _800 = abs(_793);
        float _801 = abs(_794);
        float _802 = abs(_795);
        float _803 = log2(_800);
        float _804 = log2(_801);
        float _805 = log2(_802);
        float _806 = _803 * cb2_000z;
        float _807 = _804 * cb2_000z;
        float _808 = _805 * cb2_000z;
        float _809 = exp2(_806);
        float _810 = exp2(_807);
        float _811 = exp2(_808);
        float _812 = _809 * cb2_000y;
        float _813 = _810 * cb2_000y;
        float _814 = _811 * cb2_000y;
        float _815 = _812 + cb2_000x;
        float _816 = _813 + cb2_000x;
        float _817 = _814 + cb2_000x;
        float _818 = saturate(_815);
        float _819 = saturate(_816);
        float _820 = saturate(_817);
        _822 = _818;
        _823 = _819;
        _824 = _820;
      }
      float _825 = dot(float3(_822, _823, _824), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _822;
      SV_Target.y = _823;
      SV_Target.z = _824;
      SV_Target.w = _825;
      SV_Target_1.x = _825;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
