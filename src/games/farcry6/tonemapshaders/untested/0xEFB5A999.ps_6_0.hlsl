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
  float _25 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _30 = cb2_015x * TEXCOORD0_centroid.x;
  float _31 = cb2_015y * TEXCOORD0_centroid.y;
  float _34 = _30 + cb2_015z;
  float _35 = _31 + cb2_015w;
  float4 _36 = t8.SampleLevel(s0_space2, float2(_34, _35), 0.0f);
  float _40 = saturate(_36.x);
  float _41 = saturate(_36.z);
  float _44 = cb2_026x * _41;
  float _45 = _40 * 6.283199787139893f;
  float _46 = cos(_45);
  float _47 = sin(_45);
  float _48 = _44 * _46;
  float _49 = _47 * _44;
  float _50 = 1.0f - _36.y;
  float _51 = saturate(_50);
  float _52 = _48 * _51;
  float _53 = _49 * _51;
  float _54 = _52 + TEXCOORD0_centroid.x;
  float _55 = _53 + TEXCOORD0_centroid.y;
  float4 _56 = t1.SampleLevel(s4_space2, float2(_54, _55), 0.0f);
  float _60 = max(_56.x, 0.0f);
  float _61 = max(_56.y, 0.0f);
  float _62 = max(_56.z, 0.0f);
  float _63 = min(_60, 65000.0f);
  float _64 = min(_61, 65000.0f);
  float _65 = min(_62, 65000.0f);
  float4 _66 = t4.SampleLevel(s2_space2, float2(_54, _55), 0.0f);
  float _71 = max(_66.x, 0.0f);
  float _72 = max(_66.y, 0.0f);
  float _73 = max(_66.z, 0.0f);
  float _74 = max(_66.w, 0.0f);
  float _75 = min(_71, 5000.0f);
  float _76 = min(_72, 5000.0f);
  float _77 = min(_73, 5000.0f);
  float _78 = min(_74, 5000.0f);
  float _81 = _25.x * cb0_028z;
  float _82 = _81 + cb0_028x;
  float _83 = cb2_027w / _82;
  float _84 = 1.0f - _83;
  float _85 = abs(_84);
  float _87 = cb2_027y * _85;
  float _89 = _87 - cb2_027z;
  float _90 = saturate(_89);
  float _91 = max(_90, _78);
  float _92 = saturate(_91);
  float _96 = cb2_013x * _54;
  float _97 = cb2_013y * _55;
  float _100 = _96 + cb2_013z;
  float _101 = _97 + cb2_013w;
  float _104 = dot(float2(_100, _101), float2(_100, _101));
  float _105 = abs(_104);
  float _106 = log2(_105);
  float _107 = _106 * cb2_014x;
  float _108 = exp2(_107);
  float _109 = saturate(_108);
  float _113 = cb2_011x * _54;
  float _114 = cb2_011y * _55;
  float _117 = _113 + cb2_011z;
  float _118 = _114 + cb2_011w;
  float _119 = _117 * _109;
  float _120 = _118 * _109;
  float _121 = _119 + _54;
  float _122 = _120 + _55;
  float _126 = cb2_012x * _54;
  float _127 = cb2_012y * _55;
  float _130 = _126 + cb2_012z;
  float _131 = _127 + cb2_012w;
  float _132 = _130 * _109;
  float _133 = _131 * _109;
  float _134 = _132 + _54;
  float _135 = _133 + _55;
  float4 _136 = t1.SampleLevel(s2_space2, float2(_121, _122), 0.0f);
  float _140 = max(_136.x, 0.0f);
  float _141 = max(_136.y, 0.0f);
  float _142 = max(_136.z, 0.0f);
  float _143 = min(_140, 65000.0f);
  float _144 = min(_141, 65000.0f);
  float _145 = min(_142, 65000.0f);
  float4 _146 = t1.SampleLevel(s2_space2, float2(_134, _135), 0.0f);
  float _150 = max(_146.x, 0.0f);
  float _151 = max(_146.y, 0.0f);
  float _152 = max(_146.z, 0.0f);
  float _153 = min(_150, 65000.0f);
  float _154 = min(_151, 65000.0f);
  float _155 = min(_152, 65000.0f);
  float4 _156 = t4.SampleLevel(s2_space2, float2(_121, _122), 0.0f);
  float _160 = max(_156.x, 0.0f);
  float _161 = max(_156.y, 0.0f);
  float _162 = max(_156.z, 0.0f);
  float _163 = min(_160, 5000.0f);
  float _164 = min(_161, 5000.0f);
  float _165 = min(_162, 5000.0f);
  float4 _166 = t4.SampleLevel(s2_space2, float2(_134, _135), 0.0f);
  float _170 = max(_166.x, 0.0f);
  float _171 = max(_166.y, 0.0f);
  float _172 = max(_166.z, 0.0f);
  float _173 = min(_170, 5000.0f);
  float _174 = min(_171, 5000.0f);
  float _175 = min(_172, 5000.0f);
  float _180 = 1.0f - cb2_009x;
  float _181 = 1.0f - cb2_009y;
  float _182 = 1.0f - cb2_009z;
  float _187 = _180 - cb2_010x;
  float _188 = _181 - cb2_010y;
  float _189 = _182 - cb2_010z;
  float _190 = saturate(_187);
  float _191 = saturate(_188);
  float _192 = saturate(_189);
  float _193 = _190 * _63;
  float _194 = _191 * _64;
  float _195 = _192 * _65;
  float _196 = cb2_009x * _143;
  float _197 = cb2_009y * _144;
  float _198 = cb2_009z * _145;
  float _199 = _196 + _193;
  float _200 = _197 + _194;
  float _201 = _198 + _195;
  float _202 = cb2_010x * _153;
  float _203 = cb2_010y * _154;
  float _204 = cb2_010z * _155;
  float _205 = _199 + _202;
  float _206 = _200 + _203;
  float _207 = _201 + _204;
  float _208 = _190 * _75;
  float _209 = _191 * _76;
  float _210 = _192 * _77;
  float _211 = cb2_009x * _163;
  float _212 = cb2_009y * _164;
  float _213 = cb2_009z * _165;
  float _214 = cb2_010x * _173;
  float _215 = cb2_010y * _174;
  float _216 = cb2_010z * _175;
  float4 _217 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _221 = _208 - _205;
  float _222 = _221 + _211;
  float _223 = _222 + _214;
  float _224 = _209 - _206;
  float _225 = _224 + _212;
  float _226 = _225 + _215;
  float _227 = _210 - _207;
  float _228 = _227 + _213;
  float _229 = _228 + _216;
  float _230 = _223 * _92;
  float _231 = _226 * _92;
  float _232 = _229 * _92;
  float _233 = _230 + _205;
  float _234 = _231 + _206;
  float _235 = _232 + _207;
  float _236 = dot(float3(_233, _234, _235), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _240 = t0[0].SExposureData_020;
  float _242 = t0[0].SExposureData_004;
  float _244 = cb2_018x * 0.5f;
  float _245 = _244 * cb2_018y;
  float _246 = _242.x - _245;
  float _247 = cb2_018y * cb2_018x;
  float _248 = 1.0f / _247;
  float _249 = _246 * _248;
  float _250 = _236 / _240.x;
  float _251 = _250 * 5464.01611328125f;
  float _252 = _251 + 9.99999993922529e-09f;
  float _253 = log2(_252);
  float _254 = _253 - _246;
  float _255 = _254 * _248;
  float _256 = saturate(_255);
  float2 _257 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _256), 0.0f);
  float _260 = max(_257.y, 1.0000000116860974e-07f);
  float _261 = _257.x / _260;
  float _262 = _261 + _249;
  float _263 = _262 / _248;
  float _264 = _263 - _242.x;
  float _265 = -0.0f - _264;
  float _267 = _265 - cb2_027x;
  float _268 = max(0.0f, _267);
  float _270 = cb2_026z * _268;
  float _271 = _264 - cb2_027x;
  float _272 = max(0.0f, _271);
  float _274 = cb2_026w * _272;
  bool _275 = (_264 < 0.0f);
  float _276 = select(_275, _270, _274);
  float _277 = exp2(_276);
  float _278 = _277 * _233;
  float _279 = _277 * _234;
  float _280 = _277 * _235;
  float _285 = cb2_024y * _217.x;
  float _286 = cb2_024z * _217.y;
  float _287 = cb2_024w * _217.z;
  float _288 = _285 + _278;
  float _289 = _286 + _279;
  float _290 = _287 + _280;
  float _295 = _288 * cb2_025x;
  float _296 = _289 * cb2_025y;
  float _297 = _290 * cb2_025z;
  float _298 = dot(float3(_295, _296, _297), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _299 = t0[0].SExposureData_012;
  float _301 = _298 * 5464.01611328125f;
  float _302 = _301 * _299.x;
  float _303 = _302 + 9.99999993922529e-09f;
  float _304 = log2(_303);
  float _305 = _304 + 16.929765701293945f;
  float _306 = _305 * 0.05734497308731079f;
  float _307 = saturate(_306);
  float _308 = _307 * _307;
  float _309 = _307 * 2.0f;
  float _310 = 3.0f - _309;
  float _311 = _308 * _310;
  float _312 = _296 * 0.8450999855995178f;
  float _313 = _297 * 0.14589999616146088f;
  float _314 = _312 + _313;
  float _315 = _314 * 2.4890189170837402f;
  float _316 = _314 * 0.3754962384700775f;
  float _317 = _314 * 2.811495304107666f;
  float _318 = _314 * 5.519708156585693f;
  float _319 = _298 - _315;
  float _320 = _311 * _319;
  float _321 = _320 + _315;
  float _322 = _311 * 0.5f;
  float _323 = _322 + 0.5f;
  float _324 = _323 * _319;
  float _325 = _324 + _315;
  float _326 = _295 - _316;
  float _327 = _296 - _317;
  float _328 = _297 - _318;
  float _329 = _323 * _326;
  float _330 = _323 * _327;
  float _331 = _323 * _328;
  float _332 = _329 + _316;
  float _333 = _330 + _317;
  float _334 = _331 + _318;
  float _335 = 1.0f / _325;
  float _336 = _321 * _335;
  float _337 = _336 * _332;
  float _338 = _336 * _333;
  float _339 = _336 * _334;
  float _343 = cb2_020x * TEXCOORD0_centroid.x;
  float _344 = cb2_020y * TEXCOORD0_centroid.y;
  float _347 = _343 + cb2_020z;
  float _348 = _344 + cb2_020w;
  float _351 = dot(float2(_347, _348), float2(_347, _348));
  float _352 = 1.0f - _351;
  float _353 = saturate(_352);
  float _354 = log2(_353);
  float _355 = _354 * cb2_021w;
  float _356 = exp2(_355);
  float _360 = _337 - cb2_021x;
  float _361 = _338 - cb2_021y;
  float _362 = _339 - cb2_021z;
  float _363 = _360 * _356;
  float _364 = _361 * _356;
  float _365 = _362 * _356;
  float _366 = _363 + cb2_021x;
  float _367 = _364 + cb2_021y;
  float _368 = _365 + cb2_021z;
  float _369 = t0[0].SExposureData_000;
  float _371 = max(_240.x, 0.0010000000474974513f);
  float _372 = 1.0f / _371;
  float _373 = _372 * _369.x;
  bool _376 = ((uint)(cb2_069y) == 0);
  float _382;
  float _383;
  float _384;
  float _438;
  float _439;
  float _440;
  float _486;
  float _487;
  float _488;
  float _533;
  float _534;
  float _535;
  float _536;
  float _585;
  float _586;
  float _587;
  float _588;
  float _613;
  float _614;
  float _615;
  float _716;
  float _717;
  float _718;
  float _743;
  float _755;
  float _783;
  float _795;
  float _807;
  float _808;
  float _809;
  float _836;
  float _837;
  float _838;
  if (!_376) {
    float _378 = _373 * _366;
    float _379 = _373 * _367;
    float _380 = _373 * _368;
    _382 = _378;
    _383 = _379;
    _384 = _380;
  } else {
    _382 = _366;
    _383 = _367;
    _384 = _368;
  }
  float _385 = _382 * 0.6130970120429993f;
  float _386 = mad(0.33952298760414124f, _383, _385);
  float _387 = mad(0.04737899824976921f, _384, _386);
  float _388 = _382 * 0.07019399851560593f;
  float _389 = mad(0.9163540005683899f, _383, _388);
  float _390 = mad(0.013451999984681606f, _384, _389);
  float _391 = _382 * 0.02061600051820278f;
  float _392 = mad(0.10956999659538269f, _383, _391);
  float _393 = mad(0.8698149919509888f, _384, _392);
  float _394 = log2(_387);
  float _395 = log2(_390);
  float _396 = log2(_393);
  float _397 = _394 * 0.04211956635117531f;
  float _398 = _395 * 0.04211956635117531f;
  float _399 = _396 * 0.04211956635117531f;
  float _400 = _397 + 0.6252607107162476f;
  float _401 = _398 + 0.6252607107162476f;
  float _402 = _399 + 0.6252607107162476f;
  float4 _403 = t6.SampleLevel(s2_space2, float3(_400, _401, _402), 0.0f);
  bool _409 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_409 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _413 = cb2_017x * _403.x;
    float _414 = cb2_017x * _403.y;
    float _415 = cb2_017x * _403.z;
    float _417 = _413 + cb2_017y;
    float _418 = _414 + cb2_017y;
    float _419 = _415 + cb2_017y;
    float _420 = exp2(_417);
    float _421 = exp2(_418);
    float _422 = exp2(_419);
    float _423 = _420 + 1.0f;
    float _424 = _421 + 1.0f;
    float _425 = _422 + 1.0f;
    float _426 = 1.0f / _423;
    float _427 = 1.0f / _424;
    float _428 = 1.0f / _425;
    float _430 = cb2_017z * _426;
    float _431 = cb2_017z * _427;
    float _432 = cb2_017z * _428;
    float _434 = _430 + cb2_017w;
    float _435 = _431 + cb2_017w;
    float _436 = _432 + cb2_017w;
    _438 = _434;
    _439 = _435;
    _440 = _436;
  } else {
    _438 = _403.x;
    _439 = _403.y;
    _440 = _403.z;
  }
  float _441 = _438 * 23.0f;
  float _442 = _441 + -14.473931312561035f;
  float _443 = exp2(_442);
  float _444 = _439 * 23.0f;
  float _445 = _444 + -14.473931312561035f;
  float _446 = exp2(_445);
  float _447 = _440 * 23.0f;
  float _448 = _447 + -14.473931312561035f;
  float _449 = exp2(_448);
  float _454 = cb2_004x * TEXCOORD0_centroid.x;
  float _455 = cb2_004y * TEXCOORD0_centroid.y;
  float _458 = _454 + cb2_004z;
  float _459 = _455 + cb2_004w;
  float4 _465 = t7.Sample(s2_space2, float2(_458, _459));
  float _470 = _465.x * cb2_003x;
  float _471 = _465.y * cb2_003y;
  float _472 = _465.z * cb2_003z;
  float _473 = _465.w * cb2_003w;
  float _476 = _473 + cb2_026y;
  float _477 = saturate(_476);
  bool _480 = ((uint)(cb2_069y) == 0);
  if (!_480) {
    float _482 = _470 * _373;
    float _483 = _471 * _373;
    float _484 = _472 * _373;
    _486 = _482;
    _487 = _483;
    _488 = _484;
  } else {
    _486 = _470;
    _487 = _471;
    _488 = _472;
  }
  bool _491 = ((uint)(cb2_028x) == 2);
  bool _492 = ((uint)(cb2_028x) == 3);
  int _493 = (uint)(cb2_028x) & -2;
  bool _494 = (_493 == 2);
  bool _495 = ((uint)(cb2_028x) == 6);
  bool _496 = _494 || _495;
  if (_496) {
    float _498 = _486 * _477;
    float _499 = _487 * _477;
    float _500 = _488 * _477;
    float _501 = _477 * _477;
    _533 = _498;
    _534 = _499;
    _535 = _500;
    _536 = _501;
  } else {
    bool _503 = ((uint)(cb2_028x) == 4);
    if (_503) {
      float _505 = _486 + -1.0f;
      float _506 = _487 + -1.0f;
      float _507 = _488 + -1.0f;
      float _508 = _477 + -1.0f;
      float _509 = _505 * _477;
      float _510 = _506 * _477;
      float _511 = _507 * _477;
      float _512 = _508 * _477;
      float _513 = _509 + 1.0f;
      float _514 = _510 + 1.0f;
      float _515 = _511 + 1.0f;
      float _516 = _512 + 1.0f;
      _533 = _513;
      _534 = _514;
      _535 = _515;
      _536 = _516;
    } else {
      bool _518 = ((uint)(cb2_028x) == 5);
      if (_518) {
        float _520 = _486 + -0.5f;
        float _521 = _487 + -0.5f;
        float _522 = _488 + -0.5f;
        float _523 = _477 + -0.5f;
        float _524 = _520 * _477;
        float _525 = _521 * _477;
        float _526 = _522 * _477;
        float _527 = _523 * _477;
        float _528 = _524 + 0.5f;
        float _529 = _525 + 0.5f;
        float _530 = _526 + 0.5f;
        float _531 = _527 + 0.5f;
        _533 = _528;
        _534 = _529;
        _535 = _530;
        _536 = _531;
      } else {
        _533 = _486;
        _534 = _487;
        _535 = _488;
        _536 = _477;
      }
    }
  }
  if (_491) {
    float _538 = _533 + _443;
    float _539 = _534 + _446;
    float _540 = _535 + _449;
    _585 = _538;
    _586 = _539;
    _587 = _540;
    _588 = cb2_025w;
  } else {
    if (_492) {
      float _543 = 1.0f - _533;
      float _544 = 1.0f - _534;
      float _545 = 1.0f - _535;
      float _546 = _543 * _443;
      float _547 = _544 * _446;
      float _548 = _545 * _449;
      float _549 = _546 + _533;
      float _550 = _547 + _534;
      float _551 = _548 + _535;
      _585 = _549;
      _586 = _550;
      _587 = _551;
      _588 = cb2_025w;
    } else {
      bool _553 = ((uint)(cb2_028x) == 4);
      if (_553) {
        float _555 = _533 * _443;
        float _556 = _534 * _446;
        float _557 = _535 * _449;
        _585 = _555;
        _586 = _556;
        _587 = _557;
        _588 = cb2_025w;
      } else {
        bool _559 = ((uint)(cb2_028x) == 5);
        if (_559) {
          float _561 = _443 * 2.0f;
          float _562 = _561 * _533;
          float _563 = _446 * 2.0f;
          float _564 = _563 * _534;
          float _565 = _449 * 2.0f;
          float _566 = _565 * _535;
          _585 = _562;
          _586 = _564;
          _587 = _566;
          _588 = cb2_025w;
        } else {
          if (_495) {
            float _569 = _443 - _533;
            float _570 = _446 - _534;
            float _571 = _449 - _535;
            _585 = _569;
            _586 = _570;
            _587 = _571;
            _588 = cb2_025w;
          } else {
            float _573 = _533 - _443;
            float _574 = _534 - _446;
            float _575 = _535 - _449;
            float _576 = _536 * _573;
            float _577 = _536 * _574;
            float _578 = _536 * _575;
            float _579 = _576 + _443;
            float _580 = _577 + _446;
            float _581 = _578 + _449;
            float _582 = 1.0f - _536;
            float _583 = _582 * cb2_025w;
            _585 = _579;
            _586 = _580;
            _587 = _581;
            _588 = _583;
          }
        }
      }
    }
  }
  float _594 = cb2_016x - _585;
  float _595 = cb2_016y - _586;
  float _596 = cb2_016z - _587;
  float _597 = _594 * cb2_016w;
  float _598 = _595 * cb2_016w;
  float _599 = _596 * cb2_016w;
  float _600 = _597 + _585;
  float _601 = _598 + _586;
  float _602 = _599 + _587;
  bool _605 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_605 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _609 = cb2_024x * _600;
    float _610 = cb2_024x * _601;
    float _611 = cb2_024x * _602;
    _613 = _609;
    _614 = _610;
    _615 = _611;
  } else {
    _613 = _600;
    _614 = _601;
    _615 = _602;
  }
  float _616 = _613 * 0.9708889722824097f;
  float _617 = mad(0.026962999254465103f, _614, _616);
  float _618 = mad(0.002148000057786703f, _615, _617);
  float _619 = _613 * 0.01088900025933981f;
  float _620 = mad(0.9869629740715027f, _614, _619);
  float _621 = mad(0.002148000057786703f, _615, _620);
  float _622 = mad(0.026962999254465103f, _614, _619);
  float _623 = mad(0.9621480107307434f, _615, _622);
  if (_605) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _628 = cb1_018y * 0.10000000149011612f;
        float _629 = log2(cb1_018z);
        float _630 = _629 + -13.287712097167969f;
        float _631 = _630 * 1.4929734468460083f;
        float _632 = _631 + 18.0f;
        float _633 = exp2(_632);
        float _634 = _633 * 0.18000000715255737f;
        float _635 = abs(_634);
        float _636 = log2(_635);
        float _637 = _636 * 1.5f;
        float _638 = exp2(_637);
        float _639 = _638 * _628;
        float _640 = _639 / cb1_018z;
        float _641 = _640 + -0.07636754959821701f;
        float _642 = _636 * 1.2750000953674316f;
        float _643 = exp2(_642);
        float _644 = _643 * 0.07636754959821701f;
        float _645 = cb1_018y * 0.011232397519052029f;
        float _646 = _645 * _638;
        float _647 = _646 / cb1_018z;
        float _648 = _644 - _647;
        float _649 = _643 + -0.11232396960258484f;
        float _650 = _649 * _628;
        float _651 = _650 / cb1_018z;
        float _652 = _651 * cb1_018z;
        float _653 = abs(_618);
        float _654 = abs(_621);
        float _655 = abs(_623);
        float _656 = log2(_653);
        float _657 = log2(_654);
        float _658 = log2(_655);
        float _659 = _656 * 1.5f;
        float _660 = _657 * 1.5f;
        float _661 = _658 * 1.5f;
        float _662 = exp2(_659);
        float _663 = exp2(_660);
        float _664 = exp2(_661);
        float _665 = _662 * _652;
        float _666 = _663 * _652;
        float _667 = _664 * _652;
        float _668 = _656 * 1.2750000953674316f;
        float _669 = _657 * 1.2750000953674316f;
        float _670 = _658 * 1.2750000953674316f;
        float _671 = exp2(_668);
        float _672 = exp2(_669);
        float _673 = exp2(_670);
        float _674 = _671 * _641;
        float _675 = _672 * _641;
        float _676 = _673 * _641;
        float _677 = _674 + _648;
        float _678 = _675 + _648;
        float _679 = _676 + _648;
        float _680 = _665 / _677;
        float _681 = _666 / _678;
        float _682 = _667 / _679;
        float _683 = _680 * 9.999999747378752e-05f;
        float _684 = _681 * 9.999999747378752e-05f;
        float _685 = _682 * 9.999999747378752e-05f;
        float _686 = 5000.0f / cb1_018y;
        float _687 = _683 * _686;
        float _688 = _684 * _686;
        float _689 = _685 * _686;
        _716 = _687;
        _717 = _688;
        _718 = _689;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_618, _621, _623));
      _716 = tonemapped.x, _717 = tonemapped.y, _718 = tonemapped.z;
    }
      } else {
        float _691 = _618 + 0.020616600289940834f;
        float _692 = _621 + 0.020616600289940834f;
        float _693 = _623 + 0.020616600289940834f;
        float _694 = _691 * _618;
        float _695 = _692 * _621;
        float _696 = _693 * _623;
        float _697 = _694 + -7.456949970219284e-05f;
        float _698 = _695 + -7.456949970219284e-05f;
        float _699 = _696 + -7.456949970219284e-05f;
        float _700 = _618 * 0.9837960004806519f;
        float _701 = _621 * 0.9837960004806519f;
        float _702 = _623 * 0.9837960004806519f;
        float _703 = _700 + 0.4336790144443512f;
        float _704 = _701 + 0.4336790144443512f;
        float _705 = _702 + 0.4336790144443512f;
        float _706 = _703 * _618;
        float _707 = _704 * _621;
        float _708 = _705 * _623;
        float _709 = _706 + 0.24617899954319f;
        float _710 = _707 + 0.24617899954319f;
        float _711 = _708 + 0.24617899954319f;
        float _712 = _697 / _709;
        float _713 = _698 / _710;
        float _714 = _699 / _711;
        _716 = _712;
        _717 = _713;
        _718 = _714;
      }
      float _719 = _716 * 1.6047500371932983f;
      float _720 = mad(-0.5310800075531006f, _717, _719);
      float _721 = mad(-0.07366999983787537f, _718, _720);
      float _722 = _716 * -0.10208000242710114f;
      float _723 = mad(1.1081299781799316f, _717, _722);
      float _724 = mad(-0.006049999967217445f, _718, _723);
      float _725 = _716 * -0.0032599999103695154f;
      float _726 = mad(-0.07275000214576721f, _717, _725);
      float _727 = mad(1.0760200023651123f, _718, _726);
      if (_605) {
        // float _729 = max(_721, 0.0f);
        // float _730 = max(_724, 0.0f);
        // float _731 = max(_727, 0.0f);
        // bool _732 = !(_729 >= 0.0030399328097701073f);
        // if (!_732) {
        //   float _734 = abs(_729);
        //   float _735 = log2(_734);
        //   float _736 = _735 * 0.4166666567325592f;
        //   float _737 = exp2(_736);
        //   float _738 = _737 * 1.0549999475479126f;
        //   float _739 = _738 + -0.054999999701976776f;
        //   _743 = _739;
        // } else {
        //   float _741 = _729 * 12.923210144042969f;
        //   _743 = _741;
        // }
        // bool _744 = !(_730 >= 0.0030399328097701073f);
        // if (!_744) {
        //   float _746 = abs(_730);
        //   float _747 = log2(_746);
        //   float _748 = _747 * 0.4166666567325592f;
        //   float _749 = exp2(_748);
        //   float _750 = _749 * 1.0549999475479126f;
        //   float _751 = _750 + -0.054999999701976776f;
        //   _755 = _751;
        // } else {
        //   float _753 = _730 * 12.923210144042969f;
        //   _755 = _753;
        // }
        // bool _756 = !(_731 >= 0.0030399328097701073f);
        // if (!_756) {
        //   float _758 = abs(_731);
        //   float _759 = log2(_758);
        //   float _760 = _759 * 0.4166666567325592f;
        //   float _761 = exp2(_760);
        //   float _762 = _761 * 1.0549999475479126f;
        //   float _763 = _762 + -0.054999999701976776f;
        //   _836 = _743;
        //   _837 = _755;
        //   _838 = _763;
        // } else {
        //   float _765 = _731 * 12.923210144042969f;
        //   _836 = _743;
        //   _837 = _755;
        //   _838 = _765;
        // }
        _836 = renodx::color::srgb::EncodeSafe(_721);
        _837 = renodx::color::srgb::EncodeSafe(_724);
        _838 = renodx::color::srgb::EncodeSafe(_727);

      } else {
        float _767 = saturate(_721);
        float _768 = saturate(_724);
        float _769 = saturate(_727);
        bool _770 = ((uint)(cb1_018w) == -2);
        if (!_770) {
          bool _772 = !(_767 >= 0.0030399328097701073f);
          if (!_772) {
            float _774 = abs(_767);
            float _775 = log2(_774);
            float _776 = _775 * 0.4166666567325592f;
            float _777 = exp2(_776);
            float _778 = _777 * 1.0549999475479126f;
            float _779 = _778 + -0.054999999701976776f;
            _783 = _779;
          } else {
            float _781 = _767 * 12.923210144042969f;
            _783 = _781;
          }
          bool _784 = !(_768 >= 0.0030399328097701073f);
          if (!_784) {
            float _786 = abs(_768);
            float _787 = log2(_786);
            float _788 = _787 * 0.4166666567325592f;
            float _789 = exp2(_788);
            float _790 = _789 * 1.0549999475479126f;
            float _791 = _790 + -0.054999999701976776f;
            _795 = _791;
          } else {
            float _793 = _768 * 12.923210144042969f;
            _795 = _793;
          }
          bool _796 = !(_769 >= 0.0030399328097701073f);
          if (!_796) {
            float _798 = abs(_769);
            float _799 = log2(_798);
            float _800 = _799 * 0.4166666567325592f;
            float _801 = exp2(_800);
            float _802 = _801 * 1.0549999475479126f;
            float _803 = _802 + -0.054999999701976776f;
            _807 = _783;
            _808 = _795;
            _809 = _803;
          } else {
            float _805 = _769 * 12.923210144042969f;
            _807 = _783;
            _808 = _795;
            _809 = _805;
          }
        } else {
          _807 = _767;
          _808 = _768;
          _809 = _769;
        }
        float _814 = abs(_807);
        float _815 = abs(_808);
        float _816 = abs(_809);
        float _817 = log2(_814);
        float _818 = log2(_815);
        float _819 = log2(_816);
        float _820 = _817 * cb2_000z;
        float _821 = _818 * cb2_000z;
        float _822 = _819 * cb2_000z;
        float _823 = exp2(_820);
        float _824 = exp2(_821);
        float _825 = exp2(_822);
        float _826 = _823 * cb2_000y;
        float _827 = _824 * cb2_000y;
        float _828 = _825 * cb2_000y;
        float _829 = _826 + cb2_000x;
        float _830 = _827 + cb2_000x;
        float _831 = _828 + cb2_000x;
        float _832 = saturate(_829);
        float _833 = saturate(_830);
        float _834 = saturate(_831);
        _836 = _832;
        _837 = _833;
        _838 = _834;
      }
      float _842 = cb2_023x * TEXCOORD0_centroid.x;
      float _843 = cb2_023y * TEXCOORD0_centroid.y;
      float _846 = _842 + cb2_023z;
      float _847 = _843 + cb2_023w;
      float4 _850 = t10.SampleLevel(s0_space2, float2(_846, _847), 0.0f);
      float _852 = _850.x + -0.5f;
      float _853 = _852 * cb2_022x;
      float _854 = _853 + 0.5f;
      float _855 = _854 * 2.0f;
      float _856 = _855 * _836;
      float _857 = _855 * _837;
      float _858 = _855 * _838;
      float _862 = float((uint)(cb2_019z));
      float _863 = float((uint)(cb2_019w));
      float _864 = _862 + SV_Position.x;
      float _865 = _863 + SV_Position.y;
      uint _866 = uint(_864);
      uint _867 = uint(_865);
      uint _870 = cb2_019x + -1u;
      uint _871 = cb2_019y + -1u;
      int _872 = _866 & _870;
      int _873 = _867 & _871;
      float4 _874 = t3.Load(int3(_872, _873, 0));
      float _878 = _874.x * 2.0f;
      float _879 = _874.y * 2.0f;
      float _880 = _874.z * 2.0f;
      float _881 = _878 + -1.0f;
      float _882 = _879 + -1.0f;
      float _883 = _880 + -1.0f;
      float _884 = _881 * _588;
      float _885 = _882 * _588;
      float _886 = _883 * _588;
      float _887 = _884 + _856;
      float _888 = _885 + _857;
      float _889 = _886 + _858;
      float _890 = dot(float3(_887, _888, _889), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _887;
      SV_Target.y = _888;
      SV_Target.z = _889;
      SV_Target.w = _890;
      SV_Target_1.x = _890;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
