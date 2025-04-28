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

Texture3D<float2> t8 : register(t8);

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
  float _20 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _22 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _26 = max(_22.x, 0.0f);
  float _27 = max(_22.y, 0.0f);
  float _28 = max(_22.z, 0.0f);
  float _29 = min(_26, 65000.0f);
  float _30 = min(_27, 65000.0f);
  float _31 = min(_28, 65000.0f);
  float4 _32 = t3.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _37 = max(_32.x, 0.0f);
  float _38 = max(_32.y, 0.0f);
  float _39 = max(_32.z, 0.0f);
  float _40 = max(_32.w, 0.0f);
  float _41 = min(_37, 5000.0f);
  float _42 = min(_38, 5000.0f);
  float _43 = min(_39, 5000.0f);
  float _44 = min(_40, 5000.0f);
  float _47 = _20.x * cb0_028z;
  float _48 = _47 + cb0_028x;
  float _49 = cb2_027w / _48;
  float _50 = 1.0f - _49;
  float _51 = abs(_50);
  float _53 = cb2_027y * _51;
  float _55 = _53 - cb2_027z;
  float _56 = saturate(_55);
  float _57 = max(_56, _44);
  float _58 = saturate(_57);
  float _62 = cb2_006x * TEXCOORD0_centroid.x;
  float _63 = cb2_006y * TEXCOORD0_centroid.y;
  float _66 = _62 + cb2_006z;
  float _67 = _63 + cb2_006w;
  float _71 = cb2_007x * TEXCOORD0_centroid.x;
  float _72 = cb2_007y * TEXCOORD0_centroid.y;
  float _75 = _71 + cb2_007z;
  float _76 = _72 + cb2_007w;
  float _80 = cb2_008x * TEXCOORD0_centroid.x;
  float _81 = cb2_008y * TEXCOORD0_centroid.y;
  float _84 = _80 + cb2_008z;
  float _85 = _81 + cb2_008w;
  float4 _86 = t1.SampleLevel(s2_space2, float2(_66, _67), 0.0f);
  float _88 = max(_86.x, 0.0f);
  float _89 = min(_88, 65000.0f);
  float4 _90 = t1.SampleLevel(s2_space2, float2(_75, _76), 0.0f);
  float _92 = max(_90.y, 0.0f);
  float _93 = min(_92, 65000.0f);
  float4 _94 = t1.SampleLevel(s2_space2, float2(_84, _85), 0.0f);
  float _96 = max(_94.z, 0.0f);
  float _97 = min(_96, 65000.0f);
  float4 _98 = t3.SampleLevel(s2_space2, float2(_66, _67), 0.0f);
  float _100 = max(_98.x, 0.0f);
  float _101 = min(_100, 5000.0f);
  float4 _102 = t3.SampleLevel(s2_space2, float2(_75, _76), 0.0f);
  float _104 = max(_102.y, 0.0f);
  float _105 = min(_104, 5000.0f);
  float4 _106 = t3.SampleLevel(s2_space2, float2(_84, _85), 0.0f);
  float _108 = max(_106.z, 0.0f);
  float _109 = min(_108, 5000.0f);
  float4 _110 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _116 = cb2_005x * _110.x;
  float _117 = cb2_005x * _110.y;
  float _118 = cb2_005x * _110.z;
  float _119 = _89 - _29;
  float _120 = _93 - _30;
  float _121 = _97 - _31;
  float _122 = _116 * _119;
  float _123 = _117 * _120;
  float _124 = _118 * _121;
  float _125 = _122 + _29;
  float _126 = _123 + _30;
  float _127 = _124 + _31;
  float _128 = _101 - _41;
  float _129 = _105 - _42;
  float _130 = _109 - _43;
  float _131 = _116 * _128;
  float _132 = _117 * _129;
  float _133 = _118 * _130;
  float _134 = _131 + _41;
  float _135 = _132 + _42;
  float _136 = _133 + _43;
  float4 _137 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _141 = _134 - _125;
  float _142 = _135 - _126;
  float _143 = _136 - _127;
  float _144 = _141 * _58;
  float _145 = _142 * _58;
  float _146 = _143 * _58;
  float _147 = _144 + _125;
  float _148 = _145 + _126;
  float _149 = _146 + _127;
  float _150 = dot(float3(_147, _148, _149), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _154 = t0[0].SExposureData_020;
  float _156 = t0[0].SExposureData_004;
  float _158 = cb2_018x * 0.5f;
  float _159 = _158 * cb2_018y;
  float _160 = _156.x - _159;
  float _161 = cb2_018y * cb2_018x;
  float _162 = 1.0f / _161;
  float _163 = _160 * _162;
  float _164 = _150 / _154.x;
  float _165 = _164 * 5464.01611328125f;
  float _166 = _165 + 9.99999993922529e-09f;
  float _167 = log2(_166);
  float _168 = _167 - _160;
  float _169 = _168 * _162;
  float _170 = saturate(_169);
  float2 _171 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _170), 0.0f);
  float _174 = max(_171.y, 1.0000000116860974e-07f);
  float _175 = _171.x / _174;
  float _176 = _175 + _163;
  float _177 = _176 / _162;
  float _178 = _177 - _156.x;
  float _179 = -0.0f - _178;
  float _181 = _179 - cb2_027x;
  float _182 = max(0.0f, _181);
  float _185 = cb2_026z * _182;
  float _186 = _178 - cb2_027x;
  float _187 = max(0.0f, _186);
  float _189 = cb2_026w * _187;
  bool _190 = (_178 < 0.0f);
  float _191 = select(_190, _185, _189);
  float _192 = exp2(_191);
  float _193 = _192 * _147;
  float _194 = _192 * _148;
  float _195 = _192 * _149;
  float _200 = cb2_024y * _137.x;
  float _201 = cb2_024z * _137.y;
  float _202 = cb2_024w * _137.z;
  float _203 = _200 + _193;
  float _204 = _201 + _194;
  float _205 = _202 + _195;
  float _210 = _203 * cb2_025x;
  float _211 = _204 * cb2_025y;
  float _212 = _205 * cb2_025z;
  float _213 = dot(float3(_210, _211, _212), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _214 = t0[0].SExposureData_012;
  float _216 = _213 * 5464.01611328125f;
  float _217 = _216 * _214.x;
  float _218 = _217 + 9.99999993922529e-09f;
  float _219 = log2(_218);
  float _220 = _219 + 16.929765701293945f;
  float _221 = _220 * 0.05734497308731079f;
  float _222 = saturate(_221);
  float _223 = _222 * _222;
  float _224 = _222 * 2.0f;
  float _225 = 3.0f - _224;
  float _226 = _223 * _225;
  float _227 = _211 * 0.8450999855995178f;
  float _228 = _212 * 0.14589999616146088f;
  float _229 = _227 + _228;
  float _230 = _229 * 2.4890189170837402f;
  float _231 = _229 * 0.3754962384700775f;
  float _232 = _229 * 2.811495304107666f;
  float _233 = _229 * 5.519708156585693f;
  float _234 = _213 - _230;
  float _235 = _226 * _234;
  float _236 = _235 + _230;
  float _237 = _226 * 0.5f;
  float _238 = _237 + 0.5f;
  float _239 = _238 * _234;
  float _240 = _239 + _230;
  float _241 = _210 - _231;
  float _242 = _211 - _232;
  float _243 = _212 - _233;
  float _244 = _238 * _241;
  float _245 = _238 * _242;
  float _246 = _238 * _243;
  float _247 = _244 + _231;
  float _248 = _245 + _232;
  float _249 = _246 + _233;
  float _250 = 1.0f / _240;
  float _251 = _236 * _250;
  float _252 = _251 * _247;
  float _253 = _251 * _248;
  float _254 = _251 * _249;
  float _258 = cb2_020x * TEXCOORD0_centroid.x;
  float _259 = cb2_020y * TEXCOORD0_centroid.y;
  float _262 = _258 + cb2_020z;
  float _263 = _259 + cb2_020w;
  float _266 = dot(float2(_262, _263), float2(_262, _263));
  float _267 = 1.0f - _266;
  float _268 = saturate(_267);
  float _269 = log2(_268);
  float _270 = _269 * cb2_021w;
  float _271 = exp2(_270);
  float _275 = _252 - cb2_021x;
  float _276 = _253 - cb2_021y;
  float _277 = _254 - cb2_021z;
  float _278 = _275 * _271;
  float _279 = _276 * _271;
  float _280 = _277 * _271;
  float _281 = _278 + cb2_021x;
  float _282 = _279 + cb2_021y;
  float _283 = _280 + cb2_021z;
  float _284 = t0[0].SExposureData_000;
  float _286 = max(_154.x, 0.0010000000474974513f);
  float _287 = 1.0f / _286;
  float _288 = _287 * _284.x;
  bool _291 = ((uint)(cb2_069y) == 0);
  float _297;
  float _298;
  float _299;
  float _353;
  float _354;
  float _355;
  float _445;
  float _446;
  float _447;
  float _492;
  float _493;
  float _494;
  float _495;
  float _542;
  float _543;
  float _544;
  float _569;
  float _570;
  float _571;
  float _672;
  float _673;
  float _674;
  float _699;
  float _711;
  float _739;
  float _751;
  float _763;
  float _764;
  float _765;
  float _792;
  float _793;
  float _794;
  if (!_291) {
    float _293 = _288 * _281;
    float _294 = _288 * _282;
    float _295 = _288 * _283;
    _297 = _293;
    _298 = _294;
    _299 = _295;
  } else {
    _297 = _281;
    _298 = _282;
    _299 = _283;
  }
  float _300 = _297 * 0.6130970120429993f;
  float _301 = mad(0.33952298760414124f, _298, _300);
  float _302 = mad(0.04737899824976921f, _299, _301);
  float _303 = _297 * 0.07019399851560593f;
  float _304 = mad(0.9163540005683899f, _298, _303);
  float _305 = mad(0.013451999984681606f, _299, _304);
  float _306 = _297 * 0.02061600051820278f;
  float _307 = mad(0.10956999659538269f, _298, _306);
  float _308 = mad(0.8698149919509888f, _299, _307);
  float _309 = log2(_302);
  float _310 = log2(_305);
  float _311 = log2(_308);
  float _312 = _309 * 0.04211956635117531f;
  float _313 = _310 * 0.04211956635117531f;
  float _314 = _311 * 0.04211956635117531f;
  float _315 = _312 + 0.6252607107162476f;
  float _316 = _313 + 0.6252607107162476f;
  float _317 = _314 + 0.6252607107162476f;
  float4 _318 = t5.SampleLevel(s2_space2, float3(_315, _316, _317), 0.0f);
  bool _324 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_324 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _328 = cb2_017x * _318.x;
    float _329 = cb2_017x * _318.y;
    float _330 = cb2_017x * _318.z;
    float _332 = _328 + cb2_017y;
    float _333 = _329 + cb2_017y;
    float _334 = _330 + cb2_017y;
    float _335 = exp2(_332);
    float _336 = exp2(_333);
    float _337 = exp2(_334);
    float _338 = _335 + 1.0f;
    float _339 = _336 + 1.0f;
    float _340 = _337 + 1.0f;
    float _341 = 1.0f / _338;
    float _342 = 1.0f / _339;
    float _343 = 1.0f / _340;
    float _345 = cb2_017z * _341;
    float _346 = cb2_017z * _342;
    float _347 = cb2_017z * _343;
    float _349 = _345 + cb2_017w;
    float _350 = _346 + cb2_017w;
    float _351 = _347 + cb2_017w;
    _353 = _349;
    _354 = _350;
    _355 = _351;
  } else {
    _353 = _318.x;
    _354 = _318.y;
    _355 = _318.z;
  }
  float _356 = _353 * 23.0f;
  float _357 = _356 + -14.473931312561035f;
  float _358 = exp2(_357);
  float _359 = _354 * 23.0f;
  float _360 = _359 + -14.473931312561035f;
  float _361 = exp2(_360);
  float _362 = _355 * 23.0f;
  float _363 = _362 + -14.473931312561035f;
  float _364 = exp2(_363);
  float _365 = dot(float3(_358, _361, _364), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _370 = dot(float3(_358, _361, _364), float3(_358, _361, _364));
  float _371 = rsqrt(_370);
  float _372 = _371 * _358;
  float _373 = _371 * _361;
  float _374 = _371 * _364;
  float _375 = cb2_001x - _372;
  float _376 = cb2_001y - _373;
  float _377 = cb2_001z - _374;
  float _378 = dot(float3(_375, _376, _377), float3(_375, _376, _377));
  float _381 = cb2_002z * _378;
  float _383 = _381 + cb2_002w;
  float _384 = saturate(_383);
  float _386 = cb2_002x * _384;
  float _387 = _365 - _358;
  float _388 = _365 - _361;
  float _389 = _365 - _364;
  float _390 = _386 * _387;
  float _391 = _386 * _388;
  float _392 = _386 * _389;
  float _393 = _390 + _358;
  float _394 = _391 + _361;
  float _395 = _392 + _364;
  float _397 = cb2_002y * _384;
  float _398 = 0.10000000149011612f - _393;
  float _399 = 0.10000000149011612f - _394;
  float _400 = 0.10000000149011612f - _395;
  float _401 = _398 * _397;
  float _402 = _399 * _397;
  float _403 = _400 * _397;
  float _404 = _401 + _393;
  float _405 = _402 + _394;
  float _406 = _403 + _395;
  float _407 = saturate(_404);
  float _408 = saturate(_405);
  float _409 = saturate(_406);
  float _413 = cb2_004x * TEXCOORD0_centroid.x;
  float _414 = cb2_004y * TEXCOORD0_centroid.y;
  float _417 = _413 + cb2_004z;
  float _418 = _414 + cb2_004w;
  float4 _424 = t7.Sample(s2_space2, float2(_417, _418));
  float _429 = _424.x * cb2_003x;
  float _430 = _424.y * cb2_003y;
  float _431 = _424.z * cb2_003z;
  float _432 = _424.w * cb2_003w;
  float _435 = _432 + cb2_026y;
  float _436 = saturate(_435);
  bool _439 = ((uint)(cb2_069y) == 0);
  if (!_439) {
    float _441 = _429 * _288;
    float _442 = _430 * _288;
    float _443 = _431 * _288;
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
    float _497 = _492 + _407;
    float _498 = _493 + _408;
    float _499 = _494 + _409;
    _542 = _497;
    _543 = _498;
    _544 = _499;
  } else {
    if (_451) {
      float _502 = 1.0f - _492;
      float _503 = 1.0f - _493;
      float _504 = 1.0f - _494;
      float _505 = _502 * _407;
      float _506 = _503 * _408;
      float _507 = _504 * _409;
      float _508 = _505 + _492;
      float _509 = _506 + _493;
      float _510 = _507 + _494;
      _542 = _508;
      _543 = _509;
      _544 = _510;
    } else {
      bool _512 = ((uint)(cb2_028x) == 4);
      if (_512) {
        float _514 = _492 * _407;
        float _515 = _493 * _408;
        float _516 = _494 * _409;
        _542 = _514;
        _543 = _515;
        _544 = _516;
      } else {
        bool _518 = ((uint)(cb2_028x) == 5);
        if (_518) {
          float _520 = _407 * 2.0f;
          float _521 = _520 * _492;
          float _522 = _408 * 2.0f;
          float _523 = _522 * _493;
          float _524 = _409 * 2.0f;
          float _525 = _524 * _494;
          _542 = _521;
          _543 = _523;
          _544 = _525;
        } else {
          if (_454) {
            float _528 = _407 - _492;
            float _529 = _408 - _493;
            float _530 = _409 - _494;
            _542 = _528;
            _543 = _529;
            _544 = _530;
          } else {
            float _532 = _492 - _407;
            float _533 = _493 - _408;
            float _534 = _494 - _409;
            float _535 = _495 * _532;
            float _536 = _495 * _533;
            float _537 = _495 * _534;
            float _538 = _535 + _407;
            float _539 = _536 + _408;
            float _540 = _537 + _409;
            _542 = _538;
            _543 = _539;
            _544 = _540;
          }
        }
      }
    }
  }
  float _550 = cb2_016x - _542;
  float _551 = cb2_016y - _543;
  float _552 = cb2_016z - _544;
  float _553 = _550 * cb2_016w;
  float _554 = _551 * cb2_016w;
  float _555 = _552 * cb2_016w;
  float _556 = _553 + _542;
  float _557 = _554 + _543;
  float _558 = _555 + _544;
  bool _561 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_561 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _565 = cb2_024x * _556;
    float _566 = cb2_024x * _557;
    float _567 = cb2_024x * _558;
    _569 = _565;
    _570 = _566;
    _571 = _567;
  } else {
    _569 = _556;
    _570 = _557;
    _571 = _558;
  }
  float _572 = _569 * 0.9708889722824097f;
  float _573 = mad(0.026962999254465103f, _570, _572);
  float _574 = mad(0.002148000057786703f, _571, _573);
  float _575 = _569 * 0.01088900025933981f;
  float _576 = mad(0.9869629740715027f, _570, _575);
  float _577 = mad(0.002148000057786703f, _571, _576);
  float _578 = mad(0.026962999254465103f, _570, _575);
  float _579 = mad(0.9621480107307434f, _571, _578);
  if (_561) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _584 = cb1_018y * 0.10000000149011612f;
        float _585 = log2(cb1_018z);
        float _586 = _585 + -13.287712097167969f;
        float _587 = _586 * 1.4929734468460083f;
        float _588 = _587 + 18.0f;
        float _589 = exp2(_588);
        float _590 = _589 * 0.18000000715255737f;
        float _591 = abs(_590);
        float _592 = log2(_591);
        float _593 = _592 * 1.5f;
        float _594 = exp2(_593);
        float _595 = _594 * _584;
        float _596 = _595 / cb1_018z;
        float _597 = _596 + -0.07636754959821701f;
        float _598 = _592 * 1.2750000953674316f;
        float _599 = exp2(_598);
        float _600 = _599 * 0.07636754959821701f;
        float _601 = cb1_018y * 0.011232397519052029f;
        float _602 = _601 * _594;
        float _603 = _602 / cb1_018z;
        float _604 = _600 - _603;
        float _605 = _599 + -0.11232396960258484f;
        float _606 = _605 * _584;
        float _607 = _606 / cb1_018z;
        float _608 = _607 * cb1_018z;
        float _609 = abs(_574);
        float _610 = abs(_577);
        float _611 = abs(_579);
        float _612 = log2(_609);
        float _613 = log2(_610);
        float _614 = log2(_611);
        float _615 = _612 * 1.5f;
        float _616 = _613 * 1.5f;
        float _617 = _614 * 1.5f;
        float _618 = exp2(_615);
        float _619 = exp2(_616);
        float _620 = exp2(_617);
        float _621 = _618 * _608;
        float _622 = _619 * _608;
        float _623 = _620 * _608;
        float _624 = _612 * 1.2750000953674316f;
        float _625 = _613 * 1.2750000953674316f;
        float _626 = _614 * 1.2750000953674316f;
        float _627 = exp2(_624);
        float _628 = exp2(_625);
        float _629 = exp2(_626);
        float _630 = _627 * _597;
        float _631 = _628 * _597;
        float _632 = _629 * _597;
        float _633 = _630 + _604;
        float _634 = _631 + _604;
        float _635 = _632 + _604;
        float _636 = _621 / _633;
        float _637 = _622 / _634;
        float _638 = _623 / _635;
        float _639 = _636 * 9.999999747378752e-05f;
        float _640 = _637 * 9.999999747378752e-05f;
        float _641 = _638 * 9.999999747378752e-05f;
        float _642 = 5000.0f / cb1_018y;
        float _643 = _639 * _642;
        float _644 = _640 * _642;
        float _645 = _641 * _642;
        _672 = _643;
        _673 = _644;
        _674 = _645;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_574, _577, _579));
      _672 = tonemapped.x, _673 = tonemapped.y, _674 = tonemapped.z;
    }
      } else {
        float _647 = _574 + 0.020616600289940834f;
        float _648 = _577 + 0.020616600289940834f;
        float _649 = _579 + 0.020616600289940834f;
        float _650 = _647 * _574;
        float _651 = _648 * _577;
        float _652 = _649 * _579;
        float _653 = _650 + -7.456949970219284e-05f;
        float _654 = _651 + -7.456949970219284e-05f;
        float _655 = _652 + -7.456949970219284e-05f;
        float _656 = _574 * 0.9837960004806519f;
        float _657 = _577 * 0.9837960004806519f;
        float _658 = _579 * 0.9837960004806519f;
        float _659 = _656 + 0.4336790144443512f;
        float _660 = _657 + 0.4336790144443512f;
        float _661 = _658 + 0.4336790144443512f;
        float _662 = _659 * _574;
        float _663 = _660 * _577;
        float _664 = _661 * _579;
        float _665 = _662 + 0.24617899954319f;
        float _666 = _663 + 0.24617899954319f;
        float _667 = _664 + 0.24617899954319f;
        float _668 = _653 / _665;
        float _669 = _654 / _666;
        float _670 = _655 / _667;
        _672 = _668;
        _673 = _669;
        _674 = _670;
      }
      float _675 = _672 * 1.6047500371932983f;
      float _676 = mad(-0.5310800075531006f, _673, _675);
      float _677 = mad(-0.07366999983787537f, _674, _676);
      float _678 = _672 * -0.10208000242710114f;
      float _679 = mad(1.1081299781799316f, _673, _678);
      float _680 = mad(-0.006049999967217445f, _674, _679);
      float _681 = _672 * -0.0032599999103695154f;
      float _682 = mad(-0.07275000214576721f, _673, _681);
      float _683 = mad(1.0760200023651123f, _674, _682);
      if (_561) {
        // float _685 = max(_677, 0.0f);
        // float _686 = max(_680, 0.0f);
        // float _687 = max(_683, 0.0f);
        // bool _688 = !(_685 >= 0.0030399328097701073f);
        // if (!_688) {
        //   float _690 = abs(_685);
        //   float _691 = log2(_690);
        //   float _692 = _691 * 0.4166666567325592f;
        //   float _693 = exp2(_692);
        //   float _694 = _693 * 1.0549999475479126f;
        //   float _695 = _694 + -0.054999999701976776f;
        //   _699 = _695;
        // } else {
        //   float _697 = _685 * 12.923210144042969f;
        //   _699 = _697;
        // }
        // bool _700 = !(_686 >= 0.0030399328097701073f);
        // if (!_700) {
        //   float _702 = abs(_686);
        //   float _703 = log2(_702);
        //   float _704 = _703 * 0.4166666567325592f;
        //   float _705 = exp2(_704);
        //   float _706 = _705 * 1.0549999475479126f;
        //   float _707 = _706 + -0.054999999701976776f;
        //   _711 = _707;
        // } else {
        //   float _709 = _686 * 12.923210144042969f;
        //   _711 = _709;
        // }
        // bool _712 = !(_687 >= 0.0030399328097701073f);
        // if (!_712) {
        //   float _714 = abs(_687);
        //   float _715 = log2(_714);
        //   float _716 = _715 * 0.4166666567325592f;
        //   float _717 = exp2(_716);
        //   float _718 = _717 * 1.0549999475479126f;
        //   float _719 = _718 + -0.054999999701976776f;
        //   _792 = _699;
        //   _793 = _711;
        //   _794 = _719;
        // } else {
        //   float _721 = _687 * 12.923210144042969f;
        //   _792 = _699;
        //   _793 = _711;
        //   _794 = _721;
        // }
        _792 = renodx::color::srgb::EncodeSafe(_677);
        _793 = renodx::color::srgb::EncodeSafe(_680);
        _794 = renodx::color::srgb::EncodeSafe(_683);

      } else {
        float _723 = saturate(_677);
        float _724 = saturate(_680);
        float _725 = saturate(_683);
        bool _726 = ((uint)(cb1_018w) == -2);
        if (!_726) {
          bool _728 = !(_723 >= 0.0030399328097701073f);
          if (!_728) {
            float _730 = abs(_723);
            float _731 = log2(_730);
            float _732 = _731 * 0.4166666567325592f;
            float _733 = exp2(_732);
            float _734 = _733 * 1.0549999475479126f;
            float _735 = _734 + -0.054999999701976776f;
            _739 = _735;
          } else {
            float _737 = _723 * 12.923210144042969f;
            _739 = _737;
          }
          bool _740 = !(_724 >= 0.0030399328097701073f);
          if (!_740) {
            float _742 = abs(_724);
            float _743 = log2(_742);
            float _744 = _743 * 0.4166666567325592f;
            float _745 = exp2(_744);
            float _746 = _745 * 1.0549999475479126f;
            float _747 = _746 + -0.054999999701976776f;
            _751 = _747;
          } else {
            float _749 = _724 * 12.923210144042969f;
            _751 = _749;
          }
          bool _752 = !(_725 >= 0.0030399328097701073f);
          if (!_752) {
            float _754 = abs(_725);
            float _755 = log2(_754);
            float _756 = _755 * 0.4166666567325592f;
            float _757 = exp2(_756);
            float _758 = _757 * 1.0549999475479126f;
            float _759 = _758 + -0.054999999701976776f;
            _763 = _739;
            _764 = _751;
            _765 = _759;
          } else {
            float _761 = _725 * 12.923210144042969f;
            _763 = _739;
            _764 = _751;
            _765 = _761;
          }
        } else {
          _763 = _723;
          _764 = _724;
          _765 = _725;
        }
        float _770 = abs(_763);
        float _771 = abs(_764);
        float _772 = abs(_765);
        float _773 = log2(_770);
        float _774 = log2(_771);
        float _775 = log2(_772);
        float _776 = _773 * cb2_000z;
        float _777 = _774 * cb2_000z;
        float _778 = _775 * cb2_000z;
        float _779 = exp2(_776);
        float _780 = exp2(_777);
        float _781 = exp2(_778);
        float _782 = _779 * cb2_000y;
        float _783 = _780 * cb2_000y;
        float _784 = _781 * cb2_000y;
        float _785 = _782 + cb2_000x;
        float _786 = _783 + cb2_000x;
        float _787 = _784 + cb2_000x;
        float _788 = saturate(_785);
        float _789 = saturate(_786);
        float _790 = saturate(_787);
        _792 = _788;
        _793 = _789;
        _794 = _790;
      }
      float _795 = dot(float3(_792, _793, _794), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _792;
      SV_Target.y = _793;
      SV_Target.z = _794;
      SV_Target.w = _795;
      SV_Target_1.x = _795;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
