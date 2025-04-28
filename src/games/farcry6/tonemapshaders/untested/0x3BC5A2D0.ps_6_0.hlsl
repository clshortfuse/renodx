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

Texture3D<float2> t10 : register(t10);

Texture2D<float4> t11 : register(t11);

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
  float _26 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _28 = t9.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _32 = _28.x * 6.283199787139893f;
  float _33 = cos(_32);
  float _34 = sin(_32);
  float _35 = _33 * _28.z;
  float _36 = _34 * _28.z;
  float _37 = _35 + TEXCOORD0_centroid.x;
  float _38 = _36 + TEXCOORD0_centroid.y;
  float _39 = _37 * 10.0f;
  float _40 = 10.0f - _39;
  float _41 = min(_39, _40);
  float _42 = saturate(_41);
  float _43 = _42 * _35;
  float _44 = _38 * 10.0f;
  float _45 = 10.0f - _44;
  float _46 = min(_44, _45);
  float _47 = saturate(_46);
  float _48 = _47 * _36;
  float _49 = _43 + TEXCOORD0_centroid.x;
  float _50 = _48 + TEXCOORD0_centroid.y;
  float4 _51 = t9.SampleLevel(s2_space2, float2(_49, _50), 0.0f);
  float _53 = _51.w * _43;
  float _54 = _51.w * _48;
  float _55 = 1.0f - _28.y;
  float _56 = saturate(_55);
  float _57 = _53 * _56;
  float _58 = _54 * _56;
  float _59 = _57 + TEXCOORD0_centroid.x;
  float _60 = _58 + TEXCOORD0_centroid.y;
  float4 _61 = t9.SampleLevel(s2_space2, float2(_59, _60), 0.0f);
  bool _63 = (_61.y > 0.0f);
  float _64 = select(_63, TEXCOORD0_centroid.x, _59);
  float _65 = select(_63, TEXCOORD0_centroid.y, _60);
  float4 _66 = t1.SampleLevel(s4_space2, float2(_64, _65), 0.0f);
  float _70 = max(_66.x, 0.0f);
  float _71 = max(_66.y, 0.0f);
  float _72 = max(_66.z, 0.0f);
  float _73 = min(_70, 65000.0f);
  float _74 = min(_71, 65000.0f);
  float _75 = min(_72, 65000.0f);
  float4 _76 = t4.SampleLevel(s2_space2, float2(_64, _65), 0.0f);
  float _81 = max(_76.x, 0.0f);
  float _82 = max(_76.y, 0.0f);
  float _83 = max(_76.z, 0.0f);
  float _84 = max(_76.w, 0.0f);
  float _85 = min(_81, 5000.0f);
  float _86 = min(_82, 5000.0f);
  float _87 = min(_83, 5000.0f);
  float _88 = min(_84, 5000.0f);
  float _91 = _26.x * cb0_028z;
  float _92 = _91 + cb0_028x;
  float _93 = cb2_027w / _92;
  float _94 = 1.0f - _93;
  float _95 = abs(_94);
  float _97 = cb2_027y * _95;
  float _99 = _97 - cb2_027z;
  float _100 = saturate(_99);
  float _101 = max(_100, _88);
  float _102 = saturate(_101);
  float _106 = cb2_006x * _64;
  float _107 = cb2_006y * _65;
  float _110 = _106 + cb2_006z;
  float _111 = _107 + cb2_006w;
  float _115 = cb2_007x * _64;
  float _116 = cb2_007y * _65;
  float _119 = _115 + cb2_007z;
  float _120 = _116 + cb2_007w;
  float _124 = cb2_008x * _64;
  float _125 = cb2_008y * _65;
  float _128 = _124 + cb2_008z;
  float _129 = _125 + cb2_008w;
  float4 _130 = t1.SampleLevel(s2_space2, float2(_110, _111), 0.0f);
  float _132 = max(_130.x, 0.0f);
  float _133 = min(_132, 65000.0f);
  float4 _134 = t1.SampleLevel(s2_space2, float2(_119, _120), 0.0f);
  float _136 = max(_134.y, 0.0f);
  float _137 = min(_136, 65000.0f);
  float4 _138 = t1.SampleLevel(s2_space2, float2(_128, _129), 0.0f);
  float _140 = max(_138.z, 0.0f);
  float _141 = min(_140, 65000.0f);
  float4 _142 = t4.SampleLevel(s2_space2, float2(_110, _111), 0.0f);
  float _144 = max(_142.x, 0.0f);
  float _145 = min(_144, 5000.0f);
  float4 _146 = t4.SampleLevel(s2_space2, float2(_119, _120), 0.0f);
  float _148 = max(_146.y, 0.0f);
  float _149 = min(_148, 5000.0f);
  float4 _150 = t4.SampleLevel(s2_space2, float2(_128, _129), 0.0f);
  float _152 = max(_150.z, 0.0f);
  float _153 = min(_152, 5000.0f);
  float4 _154 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _160 = cb2_005x * _154.x;
  float _161 = cb2_005x * _154.y;
  float _162 = cb2_005x * _154.z;
  float _163 = _133 - _73;
  float _164 = _137 - _74;
  float _165 = _141 - _75;
  float _166 = _160 * _163;
  float _167 = _161 * _164;
  float _168 = _162 * _165;
  float _169 = _166 + _73;
  float _170 = _167 + _74;
  float _171 = _168 + _75;
  float _172 = _145 - _85;
  float _173 = _149 - _86;
  float _174 = _153 - _87;
  float _175 = _160 * _172;
  float _176 = _161 * _173;
  float _177 = _162 * _174;
  float _178 = _175 + _85;
  float _179 = _176 + _86;
  float _180 = _177 + _87;
  float4 _181 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _185 = _178 - _169;
  float _186 = _179 - _170;
  float _187 = _180 - _171;
  float _188 = _185 * _102;
  float _189 = _186 * _102;
  float _190 = _187 * _102;
  float _191 = _188 + _169;
  float _192 = _189 + _170;
  float _193 = _190 + _171;
  float _194 = dot(float3(_191, _192, _193), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _198 = t0[0].SExposureData_020;
  float _200 = t0[0].SExposureData_004;
  float _202 = cb2_018x * 0.5f;
  float _203 = _202 * cb2_018y;
  float _204 = _200.x - _203;
  float _205 = cb2_018y * cb2_018x;
  float _206 = 1.0f / _205;
  float _207 = _204 * _206;
  float _208 = _194 / _198.x;
  float _209 = _208 * 5464.01611328125f;
  float _210 = _209 + 9.99999993922529e-09f;
  float _211 = log2(_210);
  float _212 = _211 - _204;
  float _213 = _212 * _206;
  float _214 = saturate(_213);
  float2 _215 = t10.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _214), 0.0f);
  float _218 = max(_215.y, 1.0000000116860974e-07f);
  float _219 = _215.x / _218;
  float _220 = _219 + _207;
  float _221 = _220 / _206;
  float _222 = _221 - _200.x;
  float _223 = -0.0f - _222;
  float _225 = _223 - cb2_027x;
  float _226 = max(0.0f, _225);
  float _229 = cb2_026z * _226;
  float _230 = _222 - cb2_027x;
  float _231 = max(0.0f, _230);
  float _233 = cb2_026w * _231;
  bool _234 = (_222 < 0.0f);
  float _235 = select(_234, _229, _233);
  float _236 = exp2(_235);
  float _237 = _236 * _191;
  float _238 = _236 * _192;
  float _239 = _236 * _193;
  float _244 = cb2_024y * _181.x;
  float _245 = cb2_024z * _181.y;
  float _246 = cb2_024w * _181.z;
  float _247 = _244 + _237;
  float _248 = _245 + _238;
  float _249 = _246 + _239;
  float _254 = _247 * cb2_025x;
  float _255 = _248 * cb2_025y;
  float _256 = _249 * cb2_025z;
  float _257 = dot(float3(_254, _255, _256), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _258 = t0[0].SExposureData_012;
  float _260 = _257 * 5464.01611328125f;
  float _261 = _260 * _258.x;
  float _262 = _261 + 9.99999993922529e-09f;
  float _263 = log2(_262);
  float _264 = _263 + 16.929765701293945f;
  float _265 = _264 * 0.05734497308731079f;
  float _266 = saturate(_265);
  float _267 = _266 * _266;
  float _268 = _266 * 2.0f;
  float _269 = 3.0f - _268;
  float _270 = _267 * _269;
  float _271 = _255 * 0.8450999855995178f;
  float _272 = _256 * 0.14589999616146088f;
  float _273 = _271 + _272;
  float _274 = _273 * 2.4890189170837402f;
  float _275 = _273 * 0.3754962384700775f;
  float _276 = _273 * 2.811495304107666f;
  float _277 = _273 * 5.519708156585693f;
  float _278 = _257 - _274;
  float _279 = _270 * _278;
  float _280 = _279 + _274;
  float _281 = _270 * 0.5f;
  float _282 = _281 + 0.5f;
  float _283 = _282 * _278;
  float _284 = _283 + _274;
  float _285 = _254 - _275;
  float _286 = _255 - _276;
  float _287 = _256 - _277;
  float _288 = _282 * _285;
  float _289 = _282 * _286;
  float _290 = _282 * _287;
  float _291 = _288 + _275;
  float _292 = _289 + _276;
  float _293 = _290 + _277;
  float _294 = 1.0f / _284;
  float _295 = _280 * _294;
  float _296 = _295 * _291;
  float _297 = _295 * _292;
  float _298 = _295 * _293;
  float _302 = cb2_020x * TEXCOORD0_centroid.x;
  float _303 = cb2_020y * TEXCOORD0_centroid.y;
  float _306 = _302 + cb2_020z;
  float _307 = _303 + cb2_020w;
  float _310 = dot(float2(_306, _307), float2(_306, _307));
  float _311 = 1.0f - _310;
  float _312 = saturate(_311);
  float _313 = log2(_312);
  float _314 = _313 * cb2_021w;
  float _315 = exp2(_314);
  float _319 = _296 - cb2_021x;
  float _320 = _297 - cb2_021y;
  float _321 = _298 - cb2_021z;
  float _322 = _319 * _315;
  float _323 = _320 * _315;
  float _324 = _321 * _315;
  float _325 = _322 + cb2_021x;
  float _326 = _323 + cb2_021y;
  float _327 = _324 + cb2_021z;
  float _328 = t0[0].SExposureData_000;
  float _330 = max(_198.x, 0.0010000000474974513f);
  float _331 = 1.0f / _330;
  float _332 = _331 * _328.x;
  bool _335 = ((uint)(cb2_069y) == 0);
  float _341;
  float _342;
  float _343;
  float _397;
  float _398;
  float _399;
  float _445;
  float _446;
  float _447;
  float _492;
  float _493;
  float _494;
  float _495;
  float _544;
  float _545;
  float _546;
  float _547;
  float _572;
  float _573;
  float _574;
  float _675;
  float _676;
  float _677;
  float _702;
  float _714;
  float _742;
  float _754;
  float _766;
  float _767;
  float _768;
  float _795;
  float _796;
  float _797;
  if (!_335) {
    float _337 = _332 * _325;
    float _338 = _332 * _326;
    float _339 = _332 * _327;
    _341 = _337;
    _342 = _338;
    _343 = _339;
  } else {
    _341 = _325;
    _342 = _326;
    _343 = _327;
  }
  float _344 = _341 * 0.6130970120429993f;
  float _345 = mad(0.33952298760414124f, _342, _344);
  float _346 = mad(0.04737899824976921f, _343, _345);
  float _347 = _341 * 0.07019399851560593f;
  float _348 = mad(0.9163540005683899f, _342, _347);
  float _349 = mad(0.013451999984681606f, _343, _348);
  float _350 = _341 * 0.02061600051820278f;
  float _351 = mad(0.10956999659538269f, _342, _350);
  float _352 = mad(0.8698149919509888f, _343, _351);
  float _353 = log2(_346);
  float _354 = log2(_349);
  float _355 = log2(_352);
  float _356 = _353 * 0.04211956635117531f;
  float _357 = _354 * 0.04211956635117531f;
  float _358 = _355 * 0.04211956635117531f;
  float _359 = _356 + 0.6252607107162476f;
  float _360 = _357 + 0.6252607107162476f;
  float _361 = _358 + 0.6252607107162476f;
  float4 _362 = t6.SampleLevel(s2_space2, float3(_359, _360, _361), 0.0f);
  bool _368 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_368 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _372 = cb2_017x * _362.x;
    float _373 = cb2_017x * _362.y;
    float _374 = cb2_017x * _362.z;
    float _376 = _372 + cb2_017y;
    float _377 = _373 + cb2_017y;
    float _378 = _374 + cb2_017y;
    float _379 = exp2(_376);
    float _380 = exp2(_377);
    float _381 = exp2(_378);
    float _382 = _379 + 1.0f;
    float _383 = _380 + 1.0f;
    float _384 = _381 + 1.0f;
    float _385 = 1.0f / _382;
    float _386 = 1.0f / _383;
    float _387 = 1.0f / _384;
    float _389 = cb2_017z * _385;
    float _390 = cb2_017z * _386;
    float _391 = cb2_017z * _387;
    float _393 = _389 + cb2_017w;
    float _394 = _390 + cb2_017w;
    float _395 = _391 + cb2_017w;
    _397 = _393;
    _398 = _394;
    _399 = _395;
  } else {
    _397 = _362.x;
    _398 = _362.y;
    _399 = _362.z;
  }
  float _400 = _397 * 23.0f;
  float _401 = _400 + -14.473931312561035f;
  float _402 = exp2(_401);
  float _403 = _398 * 23.0f;
  float _404 = _403 + -14.473931312561035f;
  float _405 = exp2(_404);
  float _406 = _399 * 23.0f;
  float _407 = _406 + -14.473931312561035f;
  float _408 = exp2(_407);
  float _413 = cb2_004x * TEXCOORD0_centroid.x;
  float _414 = cb2_004y * TEXCOORD0_centroid.y;
  float _417 = _413 + cb2_004z;
  float _418 = _414 + cb2_004w;
  float4 _424 = t8.Sample(s2_space2, float2(_417, _418));
  float _429 = _424.x * cb2_003x;
  float _430 = _424.y * cb2_003y;
  float _431 = _424.z * cb2_003z;
  float _432 = _424.w * cb2_003w;
  float _435 = _432 + cb2_026y;
  float _436 = saturate(_435);
  bool _439 = ((uint)(cb2_069y) == 0);
  if (!_439) {
    float _441 = _429 * _332;
    float _442 = _430 * _332;
    float _443 = _431 * _332;
    _445 = _441;
    _446 = _442;
    _447 = _443;
  } else {
    _445 = _429;
    _446 = _430;
    _447 = _431;
  }
  bool _450 = ((uint)(cb2_028x) == 2);
  bool _451 = ((uint)(cb2_028x) == 3);
  int _452 = (uint)(cb2_028x) & -2;
  bool _453 = (_452 == 2);
  bool _454 = ((uint)(cb2_028x) == 6);
  bool _455 = _453 || _454;
  if (_455) {
    float _457 = _445 * _436;
    float _458 = _446 * _436;
    float _459 = _447 * _436;
    float _460 = _436 * _436;
    _492 = _457;
    _493 = _458;
    _494 = _459;
    _495 = _460;
  } else {
    bool _462 = ((uint)(cb2_028x) == 4);
    if (_462) {
      float _464 = _445 + -1.0f;
      float _465 = _446 + -1.0f;
      float _466 = _447 + -1.0f;
      float _467 = _436 + -1.0f;
      float _468 = _464 * _436;
      float _469 = _465 * _436;
      float _470 = _466 * _436;
      float _471 = _467 * _436;
      float _472 = _468 + 1.0f;
      float _473 = _469 + 1.0f;
      float _474 = _470 + 1.0f;
      float _475 = _471 + 1.0f;
      _492 = _472;
      _493 = _473;
      _494 = _474;
      _495 = _475;
    } else {
      bool _477 = ((uint)(cb2_028x) == 5);
      if (_477) {
        float _479 = _445 + -0.5f;
        float _480 = _446 + -0.5f;
        float _481 = _447 + -0.5f;
        float _482 = _436 + -0.5f;
        float _483 = _479 * _436;
        float _484 = _480 * _436;
        float _485 = _481 * _436;
        float _486 = _482 * _436;
        float _487 = _483 + 0.5f;
        float _488 = _484 + 0.5f;
        float _489 = _485 + 0.5f;
        float _490 = _486 + 0.5f;
        _492 = _487;
        _493 = _488;
        _494 = _489;
        _495 = _490;
      } else {
        _492 = _445;
        _493 = _446;
        _494 = _447;
        _495 = _436;
      }
    }
  }
  if (_450) {
    float _497 = _492 + _402;
    float _498 = _493 + _405;
    float _499 = _494 + _408;
    _544 = _497;
    _545 = _498;
    _546 = _499;
    _547 = cb2_025w;
  } else {
    if (_451) {
      float _502 = 1.0f - _492;
      float _503 = 1.0f - _493;
      float _504 = 1.0f - _494;
      float _505 = _502 * _402;
      float _506 = _503 * _405;
      float _507 = _504 * _408;
      float _508 = _505 + _492;
      float _509 = _506 + _493;
      float _510 = _507 + _494;
      _544 = _508;
      _545 = _509;
      _546 = _510;
      _547 = cb2_025w;
    } else {
      bool _512 = ((uint)(cb2_028x) == 4);
      if (_512) {
        float _514 = _492 * _402;
        float _515 = _493 * _405;
        float _516 = _494 * _408;
        _544 = _514;
        _545 = _515;
        _546 = _516;
        _547 = cb2_025w;
      } else {
        bool _518 = ((uint)(cb2_028x) == 5);
        if (_518) {
          float _520 = _402 * 2.0f;
          float _521 = _520 * _492;
          float _522 = _405 * 2.0f;
          float _523 = _522 * _493;
          float _524 = _408 * 2.0f;
          float _525 = _524 * _494;
          _544 = _521;
          _545 = _523;
          _546 = _525;
          _547 = cb2_025w;
        } else {
          if (_454) {
            float _528 = _402 - _492;
            float _529 = _405 - _493;
            float _530 = _408 - _494;
            _544 = _528;
            _545 = _529;
            _546 = _530;
            _547 = cb2_025w;
          } else {
            float _532 = _492 - _402;
            float _533 = _493 - _405;
            float _534 = _494 - _408;
            float _535 = _495 * _532;
            float _536 = _495 * _533;
            float _537 = _495 * _534;
            float _538 = _535 + _402;
            float _539 = _536 + _405;
            float _540 = _537 + _408;
            float _541 = 1.0f - _495;
            float _542 = _541 * cb2_025w;
            _544 = _538;
            _545 = _539;
            _546 = _540;
            _547 = _542;
          }
        }
      }
    }
  }
  float _553 = cb2_016x - _544;
  float _554 = cb2_016y - _545;
  float _555 = cb2_016z - _546;
  float _556 = _553 * cb2_016w;
  float _557 = _554 * cb2_016w;
  float _558 = _555 * cb2_016w;
  float _559 = _556 + _544;
  float _560 = _557 + _545;
  float _561 = _558 + _546;
  bool _564 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_564 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _568 = cb2_024x * _559;
    float _569 = cb2_024x * _560;
    float _570 = cb2_024x * _561;
    _572 = _568;
    _573 = _569;
    _574 = _570;
  } else {
    _572 = _559;
    _573 = _560;
    _574 = _561;
  }
  float _575 = _572 * 0.9708889722824097f;
  float _576 = mad(0.026962999254465103f, _573, _575);
  float _577 = mad(0.002148000057786703f, _574, _576);
  float _578 = _572 * 0.01088900025933981f;
  float _579 = mad(0.9869629740715027f, _573, _578);
  float _580 = mad(0.002148000057786703f, _574, _579);
  float _581 = mad(0.026962999254465103f, _573, _578);
  float _582 = mad(0.9621480107307434f, _574, _581);
  if (_564) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _587 = cb1_018y * 0.10000000149011612f;
        float _588 = log2(cb1_018z);
        float _589 = _588 + -13.287712097167969f;
        float _590 = _589 * 1.4929734468460083f;
        float _591 = _590 + 18.0f;
        float _592 = exp2(_591);
        float _593 = _592 * 0.18000000715255737f;
        float _594 = abs(_593);
        float _595 = log2(_594);
        float _596 = _595 * 1.5f;
        float _597 = exp2(_596);
        float _598 = _597 * _587;
        float _599 = _598 / cb1_018z;
        float _600 = _599 + -0.07636754959821701f;
        float _601 = _595 * 1.2750000953674316f;
        float _602 = exp2(_601);
        float _603 = _602 * 0.07636754959821701f;
        float _604 = cb1_018y * 0.011232397519052029f;
        float _605 = _604 * _597;
        float _606 = _605 / cb1_018z;
        float _607 = _603 - _606;
        float _608 = _602 + -0.11232396960258484f;
        float _609 = _608 * _587;
        float _610 = _609 / cb1_018z;
        float _611 = _610 * cb1_018z;
        float _612 = abs(_577);
        float _613 = abs(_580);
        float _614 = abs(_582);
        float _615 = log2(_612);
        float _616 = log2(_613);
        float _617 = log2(_614);
        float _618 = _615 * 1.5f;
        float _619 = _616 * 1.5f;
        float _620 = _617 * 1.5f;
        float _621 = exp2(_618);
        float _622 = exp2(_619);
        float _623 = exp2(_620);
        float _624 = _621 * _611;
        float _625 = _622 * _611;
        float _626 = _623 * _611;
        float _627 = _615 * 1.2750000953674316f;
        float _628 = _616 * 1.2750000953674316f;
        float _629 = _617 * 1.2750000953674316f;
        float _630 = exp2(_627);
        float _631 = exp2(_628);
        float _632 = exp2(_629);
        float _633 = _630 * _600;
        float _634 = _631 * _600;
        float _635 = _632 * _600;
        float _636 = _633 + _607;
        float _637 = _634 + _607;
        float _638 = _635 + _607;
        float _639 = _624 / _636;
        float _640 = _625 / _637;
        float _641 = _626 / _638;
        float _642 = _639 * 9.999999747378752e-05f;
        float _643 = _640 * 9.999999747378752e-05f;
        float _644 = _641 * 9.999999747378752e-05f;
        float _645 = 5000.0f / cb1_018y;
        float _646 = _642 * _645;
        float _647 = _643 * _645;
        float _648 = _644 * _645;
        _675 = _646;
        _676 = _647;
        _677 = _648;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_577, _580, _582));
      _675 = tonemapped.x, _676 = tonemapped.y, _677 = tonemapped.z;
    }
      } else {
        float _650 = _577 + 0.020616600289940834f;
        float _651 = _580 + 0.020616600289940834f;
        float _652 = _582 + 0.020616600289940834f;
        float _653 = _650 * _577;
        float _654 = _651 * _580;
        float _655 = _652 * _582;
        float _656 = _653 + -7.456949970219284e-05f;
        float _657 = _654 + -7.456949970219284e-05f;
        float _658 = _655 + -7.456949970219284e-05f;
        float _659 = _577 * 0.9837960004806519f;
        float _660 = _580 * 0.9837960004806519f;
        float _661 = _582 * 0.9837960004806519f;
        float _662 = _659 + 0.4336790144443512f;
        float _663 = _660 + 0.4336790144443512f;
        float _664 = _661 + 0.4336790144443512f;
        float _665 = _662 * _577;
        float _666 = _663 * _580;
        float _667 = _664 * _582;
        float _668 = _665 + 0.24617899954319f;
        float _669 = _666 + 0.24617899954319f;
        float _670 = _667 + 0.24617899954319f;
        float _671 = _656 / _668;
        float _672 = _657 / _669;
        float _673 = _658 / _670;
        _675 = _671;
        _676 = _672;
        _677 = _673;
      }
      float _678 = _675 * 1.6047500371932983f;
      float _679 = mad(-0.5310800075531006f, _676, _678);
      float _680 = mad(-0.07366999983787537f, _677, _679);
      float _681 = _675 * -0.10208000242710114f;
      float _682 = mad(1.1081299781799316f, _676, _681);
      float _683 = mad(-0.006049999967217445f, _677, _682);
      float _684 = _675 * -0.0032599999103695154f;
      float _685 = mad(-0.07275000214576721f, _676, _684);
      float _686 = mad(1.0760200023651123f, _677, _685);
      if (_564) {
        // float _688 = max(_680, 0.0f);
        // float _689 = max(_683, 0.0f);
        // float _690 = max(_686, 0.0f);
        // bool _691 = !(_688 >= 0.0030399328097701073f);
        // if (!_691) {
        //   float _693 = abs(_688);
        //   float _694 = log2(_693);
        //   float _695 = _694 * 0.4166666567325592f;
        //   float _696 = exp2(_695);
        //   float _697 = _696 * 1.0549999475479126f;
        //   float _698 = _697 + -0.054999999701976776f;
        //   _702 = _698;
        // } else {
        //   float _700 = _688 * 12.923210144042969f;
        //   _702 = _700;
        // }
        // bool _703 = !(_689 >= 0.0030399328097701073f);
        // if (!_703) {
        //   float _705 = abs(_689);
        //   float _706 = log2(_705);
        //   float _707 = _706 * 0.4166666567325592f;
        //   float _708 = exp2(_707);
        //   float _709 = _708 * 1.0549999475479126f;
        //   float _710 = _709 + -0.054999999701976776f;
        //   _714 = _710;
        // } else {
        //   float _712 = _689 * 12.923210144042969f;
        //   _714 = _712;
        // }
        // bool _715 = !(_690 >= 0.0030399328097701073f);
        // if (!_715) {
        //   float _717 = abs(_690);
        //   float _718 = log2(_717);
        //   float _719 = _718 * 0.4166666567325592f;
        //   float _720 = exp2(_719);
        //   float _721 = _720 * 1.0549999475479126f;
        //   float _722 = _721 + -0.054999999701976776f;
        //   _795 = _702;
        //   _796 = _714;
        //   _797 = _722;
        // } else {
        //   float _724 = _690 * 12.923210144042969f;
        //   _795 = _702;
        //   _796 = _714;
        //   _797 = _724;
        // }
        _795 = renodx::color::srgb::EncodeSafe(_680);
        _796 = renodx::color::srgb::EncodeSafe(_683);
        _797 = renodx::color::srgb::EncodeSafe(_686);

      } else {
        float _726 = saturate(_680);
        float _727 = saturate(_683);
        float _728 = saturate(_686);
        bool _729 = ((uint)(cb1_018w) == -2);
        if (!_729) {
          bool _731 = !(_726 >= 0.0030399328097701073f);
          if (!_731) {
            float _733 = abs(_726);
            float _734 = log2(_733);
            float _735 = _734 * 0.4166666567325592f;
            float _736 = exp2(_735);
            float _737 = _736 * 1.0549999475479126f;
            float _738 = _737 + -0.054999999701976776f;
            _742 = _738;
          } else {
            float _740 = _726 * 12.923210144042969f;
            _742 = _740;
          }
          bool _743 = !(_727 >= 0.0030399328097701073f);
          if (!_743) {
            float _745 = abs(_727);
            float _746 = log2(_745);
            float _747 = _746 * 0.4166666567325592f;
            float _748 = exp2(_747);
            float _749 = _748 * 1.0549999475479126f;
            float _750 = _749 + -0.054999999701976776f;
            _754 = _750;
          } else {
            float _752 = _727 * 12.923210144042969f;
            _754 = _752;
          }
          bool _755 = !(_728 >= 0.0030399328097701073f);
          if (!_755) {
            float _757 = abs(_728);
            float _758 = log2(_757);
            float _759 = _758 * 0.4166666567325592f;
            float _760 = exp2(_759);
            float _761 = _760 * 1.0549999475479126f;
            float _762 = _761 + -0.054999999701976776f;
            _766 = _742;
            _767 = _754;
            _768 = _762;
          } else {
            float _764 = _728 * 12.923210144042969f;
            _766 = _742;
            _767 = _754;
            _768 = _764;
          }
        } else {
          _766 = _726;
          _767 = _727;
          _768 = _728;
        }
        float _773 = abs(_766);
        float _774 = abs(_767);
        float _775 = abs(_768);
        float _776 = log2(_773);
        float _777 = log2(_774);
        float _778 = log2(_775);
        float _779 = _776 * cb2_000z;
        float _780 = _777 * cb2_000z;
        float _781 = _778 * cb2_000z;
        float _782 = exp2(_779);
        float _783 = exp2(_780);
        float _784 = exp2(_781);
        float _785 = _782 * cb2_000y;
        float _786 = _783 * cb2_000y;
        float _787 = _784 * cb2_000y;
        float _788 = _785 + cb2_000x;
        float _789 = _786 + cb2_000x;
        float _790 = _787 + cb2_000x;
        float _791 = saturate(_788);
        float _792 = saturate(_789);
        float _793 = saturate(_790);
        _795 = _791;
        _796 = _792;
        _797 = _793;
      }
      float _801 = cb2_023x * TEXCOORD0_centroid.x;
      float _802 = cb2_023y * TEXCOORD0_centroid.y;
      float _805 = _801 + cb2_023z;
      float _806 = _802 + cb2_023w;
      float4 _809 = t11.SampleLevel(s0_space2, float2(_805, _806), 0.0f);
      float _811 = _809.x + -0.5f;
      float _812 = _811 * cb2_022x;
      float _813 = _812 + 0.5f;
      float _814 = _813 * 2.0f;
      float _815 = _814 * _795;
      float _816 = _814 * _796;
      float _817 = _814 * _797;
      float _821 = float((uint)(cb2_019z));
      float _822 = float((uint)(cb2_019w));
      float _823 = _821 + SV_Position.x;
      float _824 = _822 + SV_Position.y;
      uint _825 = uint(_823);
      uint _826 = uint(_824);
      uint _829 = cb2_019x + -1u;
      uint _830 = cb2_019y + -1u;
      int _831 = _825 & _829;
      int _832 = _826 & _830;
      float4 _833 = t3.Load(int3(_831, _832, 0));
      float _837 = _833.x * 2.0f;
      float _838 = _833.y * 2.0f;
      float _839 = _833.z * 2.0f;
      float _840 = _837 + -1.0f;
      float _841 = _838 + -1.0f;
      float _842 = _839 + -1.0f;
      float _843 = _840 * _547;
      float _844 = _841 * _547;
      float _845 = _842 * _547;
      float _846 = _843 + _815;
      float _847 = _844 + _816;
      float _848 = _845 + _817;
      float _849 = dot(float3(_846, _847, _848), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _846;
      SV_Target.y = _847;
      SV_Target.z = _848;
      SV_Target.w = _849;
      SV_Target_1.x = _849;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
