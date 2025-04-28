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
  float4 _128 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _132 = _110 - _98;
  float _133 = _111 - _99;
  float _134 = _112 - _100;
  float _135 = _127 * _132;
  float _136 = _127 * _133;
  float _137 = _127 * _134;
  float _138 = _135 + _98;
  float _139 = _136 + _99;
  float _140 = _137 + _100;
  float _141 = dot(float3(_138, _139, _140), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _145 = t0[0].SExposureData_020;
  float _147 = t0[0].SExposureData_004;
  float _149 = cb2_018x * 0.5f;
  float _150 = _149 * cb2_018y;
  float _151 = _147.x - _150;
  float _152 = cb2_018y * cb2_018x;
  float _153 = 1.0f / _152;
  float _154 = _151 * _153;
  float _155 = _141 / _145.x;
  float _156 = _155 * 5464.01611328125f;
  float _157 = _156 + 9.99999993922529e-09f;
  float _158 = log2(_157);
  float _159 = _158 - _151;
  float _160 = _159 * _153;
  float _161 = saturate(_160);
  float2 _162 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _161), 0.0f);
  float _165 = max(_162.y, 1.0000000116860974e-07f);
  float _166 = _162.x / _165;
  float _167 = _166 + _154;
  float _168 = _167 / _153;
  float _169 = _168 - _147.x;
  float _170 = -0.0f - _169;
  float _172 = _170 - cb2_027x;
  float _173 = max(0.0f, _172);
  float _175 = cb2_026z * _173;
  float _176 = _169 - cb2_027x;
  float _177 = max(0.0f, _176);
  float _179 = cb2_026w * _177;
  bool _180 = (_169 < 0.0f);
  float _181 = select(_180, _175, _179);
  float _182 = exp2(_181);
  float _183 = _182 * _138;
  float _184 = _182 * _139;
  float _185 = _182 * _140;
  float _190 = cb2_024y * _128.x;
  float _191 = cb2_024z * _128.y;
  float _192 = cb2_024w * _128.z;
  float _193 = _190 + _183;
  float _194 = _191 + _184;
  float _195 = _192 + _185;
  float _200 = _193 * cb2_025x;
  float _201 = _194 * cb2_025y;
  float _202 = _195 * cb2_025z;
  float _203 = dot(float3(_200, _201, _202), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _204 = t0[0].SExposureData_012;
  float _206 = _203 * 5464.01611328125f;
  float _207 = _206 * _204.x;
  float _208 = _207 + 9.99999993922529e-09f;
  float _209 = log2(_208);
  float _210 = _209 + 16.929765701293945f;
  float _211 = _210 * 0.05734497308731079f;
  float _212 = saturate(_211);
  float _213 = _212 * _212;
  float _214 = _212 * 2.0f;
  float _215 = 3.0f - _214;
  float _216 = _213 * _215;
  float _217 = _201 * 0.8450999855995178f;
  float _218 = _202 * 0.14589999616146088f;
  float _219 = _217 + _218;
  float _220 = _219 * 2.4890189170837402f;
  float _221 = _219 * 0.3754962384700775f;
  float _222 = _219 * 2.811495304107666f;
  float _223 = _219 * 5.519708156585693f;
  float _224 = _203 - _220;
  float _225 = _216 * _224;
  float _226 = _225 + _220;
  float _227 = _216 * 0.5f;
  float _228 = _227 + 0.5f;
  float _229 = _228 * _224;
  float _230 = _229 + _220;
  float _231 = _200 - _221;
  float _232 = _201 - _222;
  float _233 = _202 - _223;
  float _234 = _228 * _231;
  float _235 = _228 * _232;
  float _236 = _228 * _233;
  float _237 = _234 + _221;
  float _238 = _235 + _222;
  float _239 = _236 + _223;
  float _240 = 1.0f / _230;
  float _241 = _226 * _240;
  float _242 = _241 * _237;
  float _243 = _241 * _238;
  float _244 = _241 * _239;
  float _248 = cb2_020x * TEXCOORD0_centroid.x;
  float _249 = cb2_020y * TEXCOORD0_centroid.y;
  float _252 = _248 + cb2_020z;
  float _253 = _249 + cb2_020w;
  float _256 = dot(float2(_252, _253), float2(_252, _253));
  float _257 = 1.0f - _256;
  float _258 = saturate(_257);
  float _259 = log2(_258);
  float _260 = _259 * cb2_021w;
  float _261 = exp2(_260);
  float _265 = _242 - cb2_021x;
  float _266 = _243 - cb2_021y;
  float _267 = _244 - cb2_021z;
  float _268 = _265 * _261;
  float _269 = _266 * _261;
  float _270 = _267 * _261;
  float _271 = _268 + cb2_021x;
  float _272 = _269 + cb2_021y;
  float _273 = _270 + cb2_021z;
  float _274 = t0[0].SExposureData_000;
  float _276 = max(_145.x, 0.0010000000474974513f);
  float _277 = 1.0f / _276;
  float _278 = _277 * _274.x;
  bool _281 = ((uint)(cb2_069y) == 0);
  float _287;
  float _288;
  float _289;
  float _343;
  float _344;
  float _345;
  float _435;
  float _436;
  float _437;
  float _482;
  float _483;
  float _484;
  float _485;
  float _532;
  float _533;
  float _534;
  float _559;
  float _560;
  float _561;
  float _662;
  float _663;
  float _664;
  float _689;
  float _701;
  float _729;
  float _741;
  float _753;
  float _754;
  float _755;
  float _782;
  float _783;
  float _784;
  if (!_281) {
    float _283 = _278 * _271;
    float _284 = _278 * _272;
    float _285 = _278 * _273;
    _287 = _283;
    _288 = _284;
    _289 = _285;
  } else {
    _287 = _271;
    _288 = _272;
    _289 = _273;
  }
  float _290 = _287 * 0.6130970120429993f;
  float _291 = mad(0.33952298760414124f, _288, _290);
  float _292 = mad(0.04737899824976921f, _289, _291);
  float _293 = _287 * 0.07019399851560593f;
  float _294 = mad(0.9163540005683899f, _288, _293);
  float _295 = mad(0.013451999984681606f, _289, _294);
  float _296 = _287 * 0.02061600051820278f;
  float _297 = mad(0.10956999659538269f, _288, _296);
  float _298 = mad(0.8698149919509888f, _289, _297);
  float _299 = log2(_292);
  float _300 = log2(_295);
  float _301 = log2(_298);
  float _302 = _299 * 0.04211956635117531f;
  float _303 = _300 * 0.04211956635117531f;
  float _304 = _301 * 0.04211956635117531f;
  float _305 = _302 + 0.6252607107162476f;
  float _306 = _303 + 0.6252607107162476f;
  float _307 = _304 + 0.6252607107162476f;
  float4 _308 = t5.SampleLevel(s2_space2, float3(_305, _306, _307), 0.0f);
  bool _314 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_314 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _318 = cb2_017x * _308.x;
    float _319 = cb2_017x * _308.y;
    float _320 = cb2_017x * _308.z;
    float _322 = _318 + cb2_017y;
    float _323 = _319 + cb2_017y;
    float _324 = _320 + cb2_017y;
    float _325 = exp2(_322);
    float _326 = exp2(_323);
    float _327 = exp2(_324);
    float _328 = _325 + 1.0f;
    float _329 = _326 + 1.0f;
    float _330 = _327 + 1.0f;
    float _331 = 1.0f / _328;
    float _332 = 1.0f / _329;
    float _333 = 1.0f / _330;
    float _335 = cb2_017z * _331;
    float _336 = cb2_017z * _332;
    float _337 = cb2_017z * _333;
    float _339 = _335 + cb2_017w;
    float _340 = _336 + cb2_017w;
    float _341 = _337 + cb2_017w;
    _343 = _339;
    _344 = _340;
    _345 = _341;
  } else {
    _343 = _308.x;
    _344 = _308.y;
    _345 = _308.z;
  }
  float _346 = _343 * 23.0f;
  float _347 = _346 + -14.473931312561035f;
  float _348 = exp2(_347);
  float _349 = _344 * 23.0f;
  float _350 = _349 + -14.473931312561035f;
  float _351 = exp2(_350);
  float _352 = _345 * 23.0f;
  float _353 = _352 + -14.473931312561035f;
  float _354 = exp2(_353);
  float _355 = dot(float3(_348, _351, _354), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _360 = dot(float3(_348, _351, _354), float3(_348, _351, _354));
  float _361 = rsqrt(_360);
  float _362 = _361 * _348;
  float _363 = _361 * _351;
  float _364 = _361 * _354;
  float _365 = cb2_001x - _362;
  float _366 = cb2_001y - _363;
  float _367 = cb2_001z - _364;
  float _368 = dot(float3(_365, _366, _367), float3(_365, _366, _367));
  float _371 = cb2_002z * _368;
  float _373 = _371 + cb2_002w;
  float _374 = saturate(_373);
  float _376 = cb2_002x * _374;
  float _377 = _355 - _348;
  float _378 = _355 - _351;
  float _379 = _355 - _354;
  float _380 = _376 * _377;
  float _381 = _376 * _378;
  float _382 = _376 * _379;
  float _383 = _380 + _348;
  float _384 = _381 + _351;
  float _385 = _382 + _354;
  float _387 = cb2_002y * _374;
  float _388 = 0.10000000149011612f - _383;
  float _389 = 0.10000000149011612f - _384;
  float _390 = 0.10000000149011612f - _385;
  float _391 = _388 * _387;
  float _392 = _389 * _387;
  float _393 = _390 * _387;
  float _394 = _391 + _383;
  float _395 = _392 + _384;
  float _396 = _393 + _385;
  float _397 = saturate(_394);
  float _398 = saturate(_395);
  float _399 = saturate(_396);
  float _403 = cb2_004x * TEXCOORD0_centroid.x;
  float _404 = cb2_004y * TEXCOORD0_centroid.y;
  float _407 = _403 + cb2_004z;
  float _408 = _404 + cb2_004w;
  float4 _414 = t6.Sample(s2_space2, float2(_407, _408));
  float _419 = _414.x * cb2_003x;
  float _420 = _414.y * cb2_003y;
  float _421 = _414.z * cb2_003z;
  float _422 = _414.w * cb2_003w;
  float _425 = _422 + cb2_026y;
  float _426 = saturate(_425);
  bool _429 = ((uint)(cb2_069y) == 0);
  if (!_429) {
    float _431 = _419 * _278;
    float _432 = _420 * _278;
    float _433 = _421 * _278;
    _435 = _431;
    _436 = _432;
    _437 = _433;
  } else {
    _435 = _419;
    _436 = _420;
    _437 = _421;
  }
  bool _440 = ((uint)(cb2_028x) == 2);
  bool _441 = ((uint)(cb2_028x) == 3);
  int _442 = (uint)(cb2_028x) & -2;
  bool _443 = (_442 == 2);
  bool _444 = ((uint)(cb2_028x) == 6);
  bool _445 = _443 || _444;
  if (_445) {
    float _447 = _435 * _426;
    float _448 = _436 * _426;
    float _449 = _437 * _426;
    float _450 = _426 * _426;
    _482 = _447;
    _483 = _448;
    _484 = _449;
    _485 = _450;
  } else {
    bool _452 = ((uint)(cb2_028x) == 4);
    if (_452) {
      float _454 = _435 + -1.0f;
      float _455 = _436 + -1.0f;
      float _456 = _437 + -1.0f;
      float _457 = _426 + -1.0f;
      float _458 = _454 * _426;
      float _459 = _455 * _426;
      float _460 = _456 * _426;
      float _461 = _457 * _426;
      float _462 = _458 + 1.0f;
      float _463 = _459 + 1.0f;
      float _464 = _460 + 1.0f;
      float _465 = _461 + 1.0f;
      _482 = _462;
      _483 = _463;
      _484 = _464;
      _485 = _465;
    } else {
      bool _467 = ((uint)(cb2_028x) == 5);
      if (_467) {
        float _469 = _435 + -0.5f;
        float _470 = _436 + -0.5f;
        float _471 = _437 + -0.5f;
        float _472 = _426 + -0.5f;
        float _473 = _469 * _426;
        float _474 = _470 * _426;
        float _475 = _471 * _426;
        float _476 = _472 * _426;
        float _477 = _473 + 0.5f;
        float _478 = _474 + 0.5f;
        float _479 = _475 + 0.5f;
        float _480 = _476 + 0.5f;
        _482 = _477;
        _483 = _478;
        _484 = _479;
        _485 = _480;
      } else {
        _482 = _435;
        _483 = _436;
        _484 = _437;
        _485 = _426;
      }
    }
  }
  if (_440) {
    float _487 = _482 + _397;
    float _488 = _483 + _398;
    float _489 = _484 + _399;
    _532 = _487;
    _533 = _488;
    _534 = _489;
  } else {
    if (_441) {
      float _492 = 1.0f - _482;
      float _493 = 1.0f - _483;
      float _494 = 1.0f - _484;
      float _495 = _492 * _397;
      float _496 = _493 * _398;
      float _497 = _494 * _399;
      float _498 = _495 + _482;
      float _499 = _496 + _483;
      float _500 = _497 + _484;
      _532 = _498;
      _533 = _499;
      _534 = _500;
    } else {
      bool _502 = ((uint)(cb2_028x) == 4);
      if (_502) {
        float _504 = _482 * _397;
        float _505 = _483 * _398;
        float _506 = _484 * _399;
        _532 = _504;
        _533 = _505;
        _534 = _506;
      } else {
        bool _508 = ((uint)(cb2_028x) == 5);
        if (_508) {
          float _510 = _397 * 2.0f;
          float _511 = _510 * _482;
          float _512 = _398 * 2.0f;
          float _513 = _512 * _483;
          float _514 = _399 * 2.0f;
          float _515 = _514 * _484;
          _532 = _511;
          _533 = _513;
          _534 = _515;
        } else {
          if (_444) {
            float _518 = _397 - _482;
            float _519 = _398 - _483;
            float _520 = _399 - _484;
            _532 = _518;
            _533 = _519;
            _534 = _520;
          } else {
            float _522 = _482 - _397;
            float _523 = _483 - _398;
            float _524 = _484 - _399;
            float _525 = _485 * _522;
            float _526 = _485 * _523;
            float _527 = _485 * _524;
            float _528 = _525 + _397;
            float _529 = _526 + _398;
            float _530 = _527 + _399;
            _532 = _528;
            _533 = _529;
            _534 = _530;
          }
        }
      }
    }
  }
  float _540 = cb2_016x - _532;
  float _541 = cb2_016y - _533;
  float _542 = cb2_016z - _534;
  float _543 = _540 * cb2_016w;
  float _544 = _541 * cb2_016w;
  float _545 = _542 * cb2_016w;
  float _546 = _543 + _532;
  float _547 = _544 + _533;
  float _548 = _545 + _534;
  bool _551 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_551 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _555 = cb2_024x * _546;
    float _556 = cb2_024x * _547;
    float _557 = cb2_024x * _548;
    _559 = _555;
    _560 = _556;
    _561 = _557;
  } else {
    _559 = _546;
    _560 = _547;
    _561 = _548;
  }
  float _562 = _559 * 0.9708889722824097f;
  float _563 = mad(0.026962999254465103f, _560, _562);
  float _564 = mad(0.002148000057786703f, _561, _563);
  float _565 = _559 * 0.01088900025933981f;
  float _566 = mad(0.9869629740715027f, _560, _565);
  float _567 = mad(0.002148000057786703f, _561, _566);
  float _568 = mad(0.026962999254465103f, _560, _565);
  float _569 = mad(0.9621480107307434f, _561, _568);
  if (_551) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _574 = cb1_018y * 0.10000000149011612f;
        float _575 = log2(cb1_018z);
        float _576 = _575 + -13.287712097167969f;
        float _577 = _576 * 1.4929734468460083f;
        float _578 = _577 + 18.0f;
        float _579 = exp2(_578);
        float _580 = _579 * 0.18000000715255737f;
        float _581 = abs(_580);
        float _582 = log2(_581);
        float _583 = _582 * 1.5f;
        float _584 = exp2(_583);
        float _585 = _584 * _574;
        float _586 = _585 / cb1_018z;
        float _587 = _586 + -0.07636754959821701f;
        float _588 = _582 * 1.2750000953674316f;
        float _589 = exp2(_588);
        float _590 = _589 * 0.07636754959821701f;
        float _591 = cb1_018y * 0.011232397519052029f;
        float _592 = _591 * _584;
        float _593 = _592 / cb1_018z;
        float _594 = _590 - _593;
        float _595 = _589 + -0.11232396960258484f;
        float _596 = _595 * _574;
        float _597 = _596 / cb1_018z;
        float _598 = _597 * cb1_018z;
        float _599 = abs(_564);
        float _600 = abs(_567);
        float _601 = abs(_569);
        float _602 = log2(_599);
        float _603 = log2(_600);
        float _604 = log2(_601);
        float _605 = _602 * 1.5f;
        float _606 = _603 * 1.5f;
        float _607 = _604 * 1.5f;
        float _608 = exp2(_605);
        float _609 = exp2(_606);
        float _610 = exp2(_607);
        float _611 = _608 * _598;
        float _612 = _609 * _598;
        float _613 = _610 * _598;
        float _614 = _602 * 1.2750000953674316f;
        float _615 = _603 * 1.2750000953674316f;
        float _616 = _604 * 1.2750000953674316f;
        float _617 = exp2(_614);
        float _618 = exp2(_615);
        float _619 = exp2(_616);
        float _620 = _617 * _587;
        float _621 = _618 * _587;
        float _622 = _619 * _587;
        float _623 = _620 + _594;
        float _624 = _621 + _594;
        float _625 = _622 + _594;
        float _626 = _611 / _623;
        float _627 = _612 / _624;
        float _628 = _613 / _625;
        float _629 = _626 * 9.999999747378752e-05f;
        float _630 = _627 * 9.999999747378752e-05f;
        float _631 = _628 * 9.999999747378752e-05f;
        float _632 = 5000.0f / cb1_018y;
        float _633 = _629 * _632;
        float _634 = _630 * _632;
        float _635 = _631 * _632;
        _662 = _633;
        _663 = _634;
        _664 = _635;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_564, _567, _569));
      _662 = tonemapped.x, _663 = tonemapped.y, _664 = tonemapped.z;
    }
      } else {
        float _637 = _564 + 0.020616600289940834f;
        float _638 = _567 + 0.020616600289940834f;
        float _639 = _569 + 0.020616600289940834f;
        float _640 = _637 * _564;
        float _641 = _638 * _567;
        float _642 = _639 * _569;
        float _643 = _640 + -7.456949970219284e-05f;
        float _644 = _641 + -7.456949970219284e-05f;
        float _645 = _642 + -7.456949970219284e-05f;
        float _646 = _564 * 0.9837960004806519f;
        float _647 = _567 * 0.9837960004806519f;
        float _648 = _569 * 0.9837960004806519f;
        float _649 = _646 + 0.4336790144443512f;
        float _650 = _647 + 0.4336790144443512f;
        float _651 = _648 + 0.4336790144443512f;
        float _652 = _649 * _564;
        float _653 = _650 * _567;
        float _654 = _651 * _569;
        float _655 = _652 + 0.24617899954319f;
        float _656 = _653 + 0.24617899954319f;
        float _657 = _654 + 0.24617899954319f;
        float _658 = _643 / _655;
        float _659 = _644 / _656;
        float _660 = _645 / _657;
        _662 = _658;
        _663 = _659;
        _664 = _660;
      }
      float _665 = _662 * 1.6047500371932983f;
      float _666 = mad(-0.5310800075531006f, _663, _665);
      float _667 = mad(-0.07366999983787537f, _664, _666);
      float _668 = _662 * -0.10208000242710114f;
      float _669 = mad(1.1081299781799316f, _663, _668);
      float _670 = mad(-0.006049999967217445f, _664, _669);
      float _671 = _662 * -0.0032599999103695154f;
      float _672 = mad(-0.07275000214576721f, _663, _671);
      float _673 = mad(1.0760200023651123f, _664, _672);
      if (_551) {
        // float _675 = max(_667, 0.0f);
        // float _676 = max(_670, 0.0f);
        // float _677 = max(_673, 0.0f);
        // bool _678 = !(_675 >= 0.0030399328097701073f);
        // if (!_678) {
        //   float _680 = abs(_675);
        //   float _681 = log2(_680);
        //   float _682 = _681 * 0.4166666567325592f;
        //   float _683 = exp2(_682);
        //   float _684 = _683 * 1.0549999475479126f;
        //   float _685 = _684 + -0.054999999701976776f;
        //   _689 = _685;
        // } else {
        //   float _687 = _675 * 12.923210144042969f;
        //   _689 = _687;
        // }
        // bool _690 = !(_676 >= 0.0030399328097701073f);
        // if (!_690) {
        //   float _692 = abs(_676);
        //   float _693 = log2(_692);
        //   float _694 = _693 * 0.4166666567325592f;
        //   float _695 = exp2(_694);
        //   float _696 = _695 * 1.0549999475479126f;
        //   float _697 = _696 + -0.054999999701976776f;
        //   _701 = _697;
        // } else {
        //   float _699 = _676 * 12.923210144042969f;
        //   _701 = _699;
        // }
        // bool _702 = !(_677 >= 0.0030399328097701073f);
        // if (!_702) {
        //   float _704 = abs(_677);
        //   float _705 = log2(_704);
        //   float _706 = _705 * 0.4166666567325592f;
        //   float _707 = exp2(_706);
        //   float _708 = _707 * 1.0549999475479126f;
        //   float _709 = _708 + -0.054999999701976776f;
        //   _782 = _689;
        //   _783 = _701;
        //   _784 = _709;
        // } else {
        //   float _711 = _677 * 12.923210144042969f;
        //   _782 = _689;
        //   _783 = _701;
        //   _784 = _711;
        // }
        _782 = renodx::color::srgb::EncodeSafe(_667);
        _783 = renodx::color::srgb::EncodeSafe(_670);
        _784 = renodx::color::srgb::EncodeSafe(_673);

      } else {
        float _713 = saturate(_667);
        float _714 = saturate(_670);
        float _715 = saturate(_673);
        bool _716 = ((uint)(cb1_018w) == -2);
        if (!_716) {
          bool _718 = !(_713 >= 0.0030399328097701073f);
          if (!_718) {
            float _720 = abs(_713);
            float _721 = log2(_720);
            float _722 = _721 * 0.4166666567325592f;
            float _723 = exp2(_722);
            float _724 = _723 * 1.0549999475479126f;
            float _725 = _724 + -0.054999999701976776f;
            _729 = _725;
          } else {
            float _727 = _713 * 12.923210144042969f;
            _729 = _727;
          }
          bool _730 = !(_714 >= 0.0030399328097701073f);
          if (!_730) {
            float _732 = abs(_714);
            float _733 = log2(_732);
            float _734 = _733 * 0.4166666567325592f;
            float _735 = exp2(_734);
            float _736 = _735 * 1.0549999475479126f;
            float _737 = _736 + -0.054999999701976776f;
            _741 = _737;
          } else {
            float _739 = _714 * 12.923210144042969f;
            _741 = _739;
          }
          bool _742 = !(_715 >= 0.0030399328097701073f);
          if (!_742) {
            float _744 = abs(_715);
            float _745 = log2(_744);
            float _746 = _745 * 0.4166666567325592f;
            float _747 = exp2(_746);
            float _748 = _747 * 1.0549999475479126f;
            float _749 = _748 + -0.054999999701976776f;
            _753 = _729;
            _754 = _741;
            _755 = _749;
          } else {
            float _751 = _715 * 12.923210144042969f;
            _753 = _729;
            _754 = _741;
            _755 = _751;
          }
        } else {
          _753 = _713;
          _754 = _714;
          _755 = _715;
        }
        float _760 = abs(_753);
        float _761 = abs(_754);
        float _762 = abs(_755);
        float _763 = log2(_760);
        float _764 = log2(_761);
        float _765 = log2(_762);
        float _766 = _763 * cb2_000z;
        float _767 = _764 * cb2_000z;
        float _768 = _765 * cb2_000z;
        float _769 = exp2(_766);
        float _770 = exp2(_767);
        float _771 = exp2(_768);
        float _772 = _769 * cb2_000y;
        float _773 = _770 * cb2_000y;
        float _774 = _771 * cb2_000y;
        float _775 = _772 + cb2_000x;
        float _776 = _773 + cb2_000x;
        float _777 = _774 + cb2_000x;
        float _778 = saturate(_775);
        float _779 = saturate(_776);
        float _780 = saturate(_777);
        _782 = _778;
        _783 = _779;
        _784 = _780;
      }
      float _785 = dot(float3(_782, _783, _784), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _782;
      SV_Target.y = _783;
      SV_Target.z = _784;
      SV_Target.w = _785;
      SV_Target_1.x = _785;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
