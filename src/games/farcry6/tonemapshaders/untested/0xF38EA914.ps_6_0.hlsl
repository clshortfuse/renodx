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
  float4 _22 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _26 = _22.x * 6.283199787139893f;
  float _27 = cos(_26);
  float _28 = sin(_26);
  float _29 = _27 * _22.z;
  float _30 = _28 * _22.z;
  float _31 = _29 + TEXCOORD0_centroid.x;
  float _32 = _30 + TEXCOORD0_centroid.y;
  float _33 = _31 * 10.0f;
  float _34 = 10.0f - _33;
  float _35 = min(_33, _34);
  float _36 = saturate(_35);
  float _37 = _36 * _29;
  float _38 = _32 * 10.0f;
  float _39 = 10.0f - _38;
  float _40 = min(_38, _39);
  float _41 = saturate(_40);
  float _42 = _41 * _30;
  float _43 = _37 + TEXCOORD0_centroid.x;
  float _44 = _42 + TEXCOORD0_centroid.y;
  float4 _45 = t7.SampleLevel(s2_space2, float2(_43, _44), 0.0f);
  float _47 = _45.w * _37;
  float _48 = _45.w * _42;
  float _49 = 1.0f - _22.y;
  float _50 = saturate(_49);
  float _51 = _47 * _50;
  float _52 = _48 * _50;
  float _53 = _51 + TEXCOORD0_centroid.x;
  float _54 = _52 + TEXCOORD0_centroid.y;
  float4 _55 = t7.SampleLevel(s2_space2, float2(_53, _54), 0.0f);
  bool _57 = (_55.y > 0.0f);
  float _58 = select(_57, TEXCOORD0_centroid.x, _53);
  float _59 = select(_57, TEXCOORD0_centroid.y, _54);
  float4 _60 = t1.SampleLevel(s4_space2, float2(_58, _59), 0.0f);
  float _64 = max(_60.x, 0.0f);
  float _65 = max(_60.y, 0.0f);
  float _66 = max(_60.z, 0.0f);
  float _67 = min(_64, 65000.0f);
  float _68 = min(_65, 65000.0f);
  float _69 = min(_66, 65000.0f);
  float4 _70 = t3.SampleLevel(s2_space2, float2(_58, _59), 0.0f);
  float _75 = max(_70.x, 0.0f);
  float _76 = max(_70.y, 0.0f);
  float _77 = max(_70.z, 0.0f);
  float _78 = max(_70.w, 0.0f);
  float _79 = min(_75, 5000.0f);
  float _80 = min(_76, 5000.0f);
  float _81 = min(_77, 5000.0f);
  float _82 = min(_78, 5000.0f);
  float _85 = _20.x * cb0_028z;
  float _86 = _85 + cb0_028x;
  float _87 = cb2_027w / _86;
  float _88 = 1.0f - _87;
  float _89 = abs(_88);
  float _91 = cb2_027y * _89;
  float _93 = _91 - cb2_027z;
  float _94 = saturate(_93);
  float _95 = max(_94, _82);
  float _96 = saturate(_95);
  float4 _97 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _101 = _79 - _67;
  float _102 = _80 - _68;
  float _103 = _81 - _69;
  float _104 = _96 * _101;
  float _105 = _96 * _102;
  float _106 = _96 * _103;
  float _107 = _104 + _67;
  float _108 = _105 + _68;
  float _109 = _106 + _69;
  float _110 = dot(float3(_107, _108, _109), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _114 = t0[0].SExposureData_020;
  float _116 = t0[0].SExposureData_004;
  float _118 = cb2_018x * 0.5f;
  float _119 = _118 * cb2_018y;
  float _120 = _116.x - _119;
  float _121 = cb2_018y * cb2_018x;
  float _122 = 1.0f / _121;
  float _123 = _120 * _122;
  float _124 = _110 / _114.x;
  float _125 = _124 * 5464.01611328125f;
  float _126 = _125 + 9.99999993922529e-09f;
  float _127 = log2(_126);
  float _128 = _127 - _120;
  float _129 = _128 * _122;
  float _130 = saturate(_129);
  float2 _131 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _130), 0.0f);
  float _134 = max(_131.y, 1.0000000116860974e-07f);
  float _135 = _131.x / _134;
  float _136 = _135 + _123;
  float _137 = _136 / _122;
  float _138 = _137 - _116.x;
  float _139 = -0.0f - _138;
  float _141 = _139 - cb2_027x;
  float _142 = max(0.0f, _141);
  float _145 = cb2_026z * _142;
  float _146 = _138 - cb2_027x;
  float _147 = max(0.0f, _146);
  float _149 = cb2_026w * _147;
  bool _150 = (_138 < 0.0f);
  float _151 = select(_150, _145, _149);
  float _152 = exp2(_151);
  float _153 = _152 * _107;
  float _154 = _152 * _108;
  float _155 = _152 * _109;
  float _160 = cb2_024y * _97.x;
  float _161 = cb2_024z * _97.y;
  float _162 = cb2_024w * _97.z;
  float _163 = _160 + _153;
  float _164 = _161 + _154;
  float _165 = _162 + _155;
  float _170 = _163 * cb2_025x;
  float _171 = _164 * cb2_025y;
  float _172 = _165 * cb2_025z;
  float _173 = dot(float3(_170, _171, _172), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _174 = t0[0].SExposureData_012;
  float _176 = _173 * 5464.01611328125f;
  float _177 = _176 * _174.x;
  float _178 = _177 + 9.99999993922529e-09f;
  float _179 = log2(_178);
  float _180 = _179 + 16.929765701293945f;
  float _181 = _180 * 0.05734497308731079f;
  float _182 = saturate(_181);
  float _183 = _182 * _182;
  float _184 = _182 * 2.0f;
  float _185 = 3.0f - _184;
  float _186 = _183 * _185;
  float _187 = _171 * 0.8450999855995178f;
  float _188 = _172 * 0.14589999616146088f;
  float _189 = _187 + _188;
  float _190 = _189 * 2.4890189170837402f;
  float _191 = _189 * 0.3754962384700775f;
  float _192 = _189 * 2.811495304107666f;
  float _193 = _189 * 5.519708156585693f;
  float _194 = _173 - _190;
  float _195 = _186 * _194;
  float _196 = _195 + _190;
  float _197 = _186 * 0.5f;
  float _198 = _197 + 0.5f;
  float _199 = _198 * _194;
  float _200 = _199 + _190;
  float _201 = _170 - _191;
  float _202 = _171 - _192;
  float _203 = _172 - _193;
  float _204 = _198 * _201;
  float _205 = _198 * _202;
  float _206 = _198 * _203;
  float _207 = _204 + _191;
  float _208 = _205 + _192;
  float _209 = _206 + _193;
  float _210 = 1.0f / _200;
  float _211 = _196 * _210;
  float _212 = _211 * _207;
  float _213 = _211 * _208;
  float _214 = _211 * _209;
  float _218 = cb2_020x * TEXCOORD0_centroid.x;
  float _219 = cb2_020y * TEXCOORD0_centroid.y;
  float _222 = _218 + cb2_020z;
  float _223 = _219 + cb2_020w;
  float _226 = dot(float2(_222, _223), float2(_222, _223));
  float _227 = 1.0f - _226;
  float _228 = saturate(_227);
  float _229 = log2(_228);
  float _230 = _229 * cb2_021w;
  float _231 = exp2(_230);
  float _235 = _212 - cb2_021x;
  float _236 = _213 - cb2_021y;
  float _237 = _214 - cb2_021z;
  float _238 = _235 * _231;
  float _239 = _236 * _231;
  float _240 = _237 * _231;
  float _241 = _238 + cb2_021x;
  float _242 = _239 + cb2_021y;
  float _243 = _240 + cb2_021z;
  float _244 = t0[0].SExposureData_000;
  float _246 = max(_114.x, 0.0010000000474974513f);
  float _247 = 1.0f / _246;
  float _248 = _247 * _244.x;
  bool _251 = ((uint)(cb2_069y) == 0);
  float _257;
  float _258;
  float _259;
  float _313;
  float _314;
  float _315;
  float _405;
  float _406;
  float _407;
  float _452;
  float _453;
  float _454;
  float _455;
  float _502;
  float _503;
  float _504;
  float _529;
  float _530;
  float _531;
  float _632;
  float _633;
  float _634;
  float _659;
  float _671;
  float _699;
  float _711;
  float _723;
  float _724;
  float _725;
  float _752;
  float _753;
  float _754;
  if (!_251) {
    float _253 = _248 * _241;
    float _254 = _248 * _242;
    float _255 = _248 * _243;
    _257 = _253;
    _258 = _254;
    _259 = _255;
  } else {
    _257 = _241;
    _258 = _242;
    _259 = _243;
  }
  float _260 = _257 * 0.6130970120429993f;
  float _261 = mad(0.33952298760414124f, _258, _260);
  float _262 = mad(0.04737899824976921f, _259, _261);
  float _263 = _257 * 0.07019399851560593f;
  float _264 = mad(0.9163540005683899f, _258, _263);
  float _265 = mad(0.013451999984681606f, _259, _264);
  float _266 = _257 * 0.02061600051820278f;
  float _267 = mad(0.10956999659538269f, _258, _266);
  float _268 = mad(0.8698149919509888f, _259, _267);
  float _269 = log2(_262);
  float _270 = log2(_265);
  float _271 = log2(_268);
  float _272 = _269 * 0.04211956635117531f;
  float _273 = _270 * 0.04211956635117531f;
  float _274 = _271 * 0.04211956635117531f;
  float _275 = _272 + 0.6252607107162476f;
  float _276 = _273 + 0.6252607107162476f;
  float _277 = _274 + 0.6252607107162476f;
  float4 _278 = t5.SampleLevel(s2_space2, float3(_275, _276, _277), 0.0f);
  bool _284 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_284 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _288 = cb2_017x * _278.x;
    float _289 = cb2_017x * _278.y;
    float _290 = cb2_017x * _278.z;
    float _292 = _288 + cb2_017y;
    float _293 = _289 + cb2_017y;
    float _294 = _290 + cb2_017y;
    float _295 = exp2(_292);
    float _296 = exp2(_293);
    float _297 = exp2(_294);
    float _298 = _295 + 1.0f;
    float _299 = _296 + 1.0f;
    float _300 = _297 + 1.0f;
    float _301 = 1.0f / _298;
    float _302 = 1.0f / _299;
    float _303 = 1.0f / _300;
    float _305 = cb2_017z * _301;
    float _306 = cb2_017z * _302;
    float _307 = cb2_017z * _303;
    float _309 = _305 + cb2_017w;
    float _310 = _306 + cb2_017w;
    float _311 = _307 + cb2_017w;
    _313 = _309;
    _314 = _310;
    _315 = _311;
  } else {
    _313 = _278.x;
    _314 = _278.y;
    _315 = _278.z;
  }
  float _316 = _313 * 23.0f;
  float _317 = _316 + -14.473931312561035f;
  float _318 = exp2(_317);
  float _319 = _314 * 23.0f;
  float _320 = _319 + -14.473931312561035f;
  float _321 = exp2(_320);
  float _322 = _315 * 23.0f;
  float _323 = _322 + -14.473931312561035f;
  float _324 = exp2(_323);
  float _325 = dot(float3(_318, _321, _324), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _330 = dot(float3(_318, _321, _324), float3(_318, _321, _324));
  float _331 = rsqrt(_330);
  float _332 = _331 * _318;
  float _333 = _331 * _321;
  float _334 = _331 * _324;
  float _335 = cb2_001x - _332;
  float _336 = cb2_001y - _333;
  float _337 = cb2_001z - _334;
  float _338 = dot(float3(_335, _336, _337), float3(_335, _336, _337));
  float _341 = cb2_002z * _338;
  float _343 = _341 + cb2_002w;
  float _344 = saturate(_343);
  float _346 = cb2_002x * _344;
  float _347 = _325 - _318;
  float _348 = _325 - _321;
  float _349 = _325 - _324;
  float _350 = _346 * _347;
  float _351 = _346 * _348;
  float _352 = _346 * _349;
  float _353 = _350 + _318;
  float _354 = _351 + _321;
  float _355 = _352 + _324;
  float _357 = cb2_002y * _344;
  float _358 = 0.10000000149011612f - _353;
  float _359 = 0.10000000149011612f - _354;
  float _360 = 0.10000000149011612f - _355;
  float _361 = _358 * _357;
  float _362 = _359 * _357;
  float _363 = _360 * _357;
  float _364 = _361 + _353;
  float _365 = _362 + _354;
  float _366 = _363 + _355;
  float _367 = saturate(_364);
  float _368 = saturate(_365);
  float _369 = saturate(_366);
  float _373 = cb2_004x * TEXCOORD0_centroid.x;
  float _374 = cb2_004y * TEXCOORD0_centroid.y;
  float _377 = _373 + cb2_004z;
  float _378 = _374 + cb2_004w;
  float4 _384 = t6.Sample(s2_space2, float2(_377, _378));
  float _389 = _384.x * cb2_003x;
  float _390 = _384.y * cb2_003y;
  float _391 = _384.z * cb2_003z;
  float _392 = _384.w * cb2_003w;
  float _395 = _392 + cb2_026y;
  float _396 = saturate(_395);
  bool _399 = ((uint)(cb2_069y) == 0);
  if (!_399) {
    float _401 = _389 * _248;
    float _402 = _390 * _248;
    float _403 = _391 * _248;
    _405 = _401;
    _406 = _402;
    _407 = _403;
  } else {
    _405 = _389;
    _406 = _390;
    _407 = _391;
  }
  bool _410 = ((uint)(cb2_028x) == 2);
  bool _411 = ((uint)(cb2_028x) == 3);
  int _412 = (uint)(cb2_028x) & -2;
  bool _413 = (_412 == 2);
  bool _414 = ((uint)(cb2_028x) == 6);
  bool _415 = _413 || _414;
  if (_415) {
    float _417 = _405 * _396;
    float _418 = _406 * _396;
    float _419 = _407 * _396;
    float _420 = _396 * _396;
    _452 = _417;
    _453 = _418;
    _454 = _419;
    _455 = _420;
  } else {
    bool _422 = ((uint)(cb2_028x) == 4);
    if (_422) {
      float _424 = _405 + -1.0f;
      float _425 = _406 + -1.0f;
      float _426 = _407 + -1.0f;
      float _427 = _396 + -1.0f;
      float _428 = _424 * _396;
      float _429 = _425 * _396;
      float _430 = _426 * _396;
      float _431 = _427 * _396;
      float _432 = _428 + 1.0f;
      float _433 = _429 + 1.0f;
      float _434 = _430 + 1.0f;
      float _435 = _431 + 1.0f;
      _452 = _432;
      _453 = _433;
      _454 = _434;
      _455 = _435;
    } else {
      bool _437 = ((uint)(cb2_028x) == 5);
      if (_437) {
        float _439 = _405 + -0.5f;
        float _440 = _406 + -0.5f;
        float _441 = _407 + -0.5f;
        float _442 = _396 + -0.5f;
        float _443 = _439 * _396;
        float _444 = _440 * _396;
        float _445 = _441 * _396;
        float _446 = _442 * _396;
        float _447 = _443 + 0.5f;
        float _448 = _444 + 0.5f;
        float _449 = _445 + 0.5f;
        float _450 = _446 + 0.5f;
        _452 = _447;
        _453 = _448;
        _454 = _449;
        _455 = _450;
      } else {
        _452 = _405;
        _453 = _406;
        _454 = _407;
        _455 = _396;
      }
    }
  }
  if (_410) {
    float _457 = _452 + _367;
    float _458 = _453 + _368;
    float _459 = _454 + _369;
    _502 = _457;
    _503 = _458;
    _504 = _459;
  } else {
    if (_411) {
      float _462 = 1.0f - _452;
      float _463 = 1.0f - _453;
      float _464 = 1.0f - _454;
      float _465 = _462 * _367;
      float _466 = _463 * _368;
      float _467 = _464 * _369;
      float _468 = _465 + _452;
      float _469 = _466 + _453;
      float _470 = _467 + _454;
      _502 = _468;
      _503 = _469;
      _504 = _470;
    } else {
      bool _472 = ((uint)(cb2_028x) == 4);
      if (_472) {
        float _474 = _452 * _367;
        float _475 = _453 * _368;
        float _476 = _454 * _369;
        _502 = _474;
        _503 = _475;
        _504 = _476;
      } else {
        bool _478 = ((uint)(cb2_028x) == 5);
        if (_478) {
          float _480 = _367 * 2.0f;
          float _481 = _480 * _452;
          float _482 = _368 * 2.0f;
          float _483 = _482 * _453;
          float _484 = _369 * 2.0f;
          float _485 = _484 * _454;
          _502 = _481;
          _503 = _483;
          _504 = _485;
        } else {
          if (_414) {
            float _488 = _367 - _452;
            float _489 = _368 - _453;
            float _490 = _369 - _454;
            _502 = _488;
            _503 = _489;
            _504 = _490;
          } else {
            float _492 = _452 - _367;
            float _493 = _453 - _368;
            float _494 = _454 - _369;
            float _495 = _455 * _492;
            float _496 = _455 * _493;
            float _497 = _455 * _494;
            float _498 = _495 + _367;
            float _499 = _496 + _368;
            float _500 = _497 + _369;
            _502 = _498;
            _503 = _499;
            _504 = _500;
          }
        }
      }
    }
  }
  float _510 = cb2_016x - _502;
  float _511 = cb2_016y - _503;
  float _512 = cb2_016z - _504;
  float _513 = _510 * cb2_016w;
  float _514 = _511 * cb2_016w;
  float _515 = _512 * cb2_016w;
  float _516 = _513 + _502;
  float _517 = _514 + _503;
  float _518 = _515 + _504;
  bool _521 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_521 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _525 = cb2_024x * _516;
    float _526 = cb2_024x * _517;
    float _527 = cb2_024x * _518;
    _529 = _525;
    _530 = _526;
    _531 = _527;
  } else {
    _529 = _516;
    _530 = _517;
    _531 = _518;
  }
  float _532 = _529 * 0.9708889722824097f;
  float _533 = mad(0.026962999254465103f, _530, _532);
  float _534 = mad(0.002148000057786703f, _531, _533);
  float _535 = _529 * 0.01088900025933981f;
  float _536 = mad(0.9869629740715027f, _530, _535);
  float _537 = mad(0.002148000057786703f, _531, _536);
  float _538 = mad(0.026962999254465103f, _530, _535);
  float _539 = mad(0.9621480107307434f, _531, _538);
  if (_521) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _544 = cb1_018y * 0.10000000149011612f;
        float _545 = log2(cb1_018z);
        float _546 = _545 + -13.287712097167969f;
        float _547 = _546 * 1.4929734468460083f;
        float _548 = _547 + 18.0f;
        float _549 = exp2(_548);
        float _550 = _549 * 0.18000000715255737f;
        float _551 = abs(_550);
        float _552 = log2(_551);
        float _553 = _552 * 1.5f;
        float _554 = exp2(_553);
        float _555 = _554 * _544;
        float _556 = _555 / cb1_018z;
        float _557 = _556 + -0.07636754959821701f;
        float _558 = _552 * 1.2750000953674316f;
        float _559 = exp2(_558);
        float _560 = _559 * 0.07636754959821701f;
        float _561 = cb1_018y * 0.011232397519052029f;
        float _562 = _561 * _554;
        float _563 = _562 / cb1_018z;
        float _564 = _560 - _563;
        float _565 = _559 + -0.11232396960258484f;
        float _566 = _565 * _544;
        float _567 = _566 / cb1_018z;
        float _568 = _567 * cb1_018z;
        float _569 = abs(_534);
        float _570 = abs(_537);
        float _571 = abs(_539);
        float _572 = log2(_569);
        float _573 = log2(_570);
        float _574 = log2(_571);
        float _575 = _572 * 1.5f;
        float _576 = _573 * 1.5f;
        float _577 = _574 * 1.5f;
        float _578 = exp2(_575);
        float _579 = exp2(_576);
        float _580 = exp2(_577);
        float _581 = _578 * _568;
        float _582 = _579 * _568;
        float _583 = _580 * _568;
        float _584 = _572 * 1.2750000953674316f;
        float _585 = _573 * 1.2750000953674316f;
        float _586 = _574 * 1.2750000953674316f;
        float _587 = exp2(_584);
        float _588 = exp2(_585);
        float _589 = exp2(_586);
        float _590 = _587 * _557;
        float _591 = _588 * _557;
        float _592 = _589 * _557;
        float _593 = _590 + _564;
        float _594 = _591 + _564;
        float _595 = _592 + _564;
        float _596 = _581 / _593;
        float _597 = _582 / _594;
        float _598 = _583 / _595;
        float _599 = _596 * 9.999999747378752e-05f;
        float _600 = _597 * 9.999999747378752e-05f;
        float _601 = _598 * 9.999999747378752e-05f;
        float _602 = 5000.0f / cb1_018y;
        float _603 = _599 * _602;
        float _604 = _600 * _602;
        float _605 = _601 * _602;
        _632 = _603;
        _633 = _604;
        _634 = _605;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_534, _537, _539));
      _632 = tonemapped.x, _633 = tonemapped.y, _634 = tonemapped.z;
    }
      } else {
        float _607 = _534 + 0.020616600289940834f;
        float _608 = _537 + 0.020616600289940834f;
        float _609 = _539 + 0.020616600289940834f;
        float _610 = _607 * _534;
        float _611 = _608 * _537;
        float _612 = _609 * _539;
        float _613 = _610 + -7.456949970219284e-05f;
        float _614 = _611 + -7.456949970219284e-05f;
        float _615 = _612 + -7.456949970219284e-05f;
        float _616 = _534 * 0.9837960004806519f;
        float _617 = _537 * 0.9837960004806519f;
        float _618 = _539 * 0.9837960004806519f;
        float _619 = _616 + 0.4336790144443512f;
        float _620 = _617 + 0.4336790144443512f;
        float _621 = _618 + 0.4336790144443512f;
        float _622 = _619 * _534;
        float _623 = _620 * _537;
        float _624 = _621 * _539;
        float _625 = _622 + 0.24617899954319f;
        float _626 = _623 + 0.24617899954319f;
        float _627 = _624 + 0.24617899954319f;
        float _628 = _613 / _625;
        float _629 = _614 / _626;
        float _630 = _615 / _627;
        _632 = _628;
        _633 = _629;
        _634 = _630;
      }
      float _635 = _632 * 1.6047500371932983f;
      float _636 = mad(-0.5310800075531006f, _633, _635);
      float _637 = mad(-0.07366999983787537f, _634, _636);
      float _638 = _632 * -0.10208000242710114f;
      float _639 = mad(1.1081299781799316f, _633, _638);
      float _640 = mad(-0.006049999967217445f, _634, _639);
      float _641 = _632 * -0.0032599999103695154f;
      float _642 = mad(-0.07275000214576721f, _633, _641);
      float _643 = mad(1.0760200023651123f, _634, _642);
      if (_521) {
        // float _645 = max(_637, 0.0f);
        // float _646 = max(_640, 0.0f);
        // float _647 = max(_643, 0.0f);
        // bool _648 = !(_645 >= 0.0030399328097701073f);
        // if (!_648) {
        //   float _650 = abs(_645);
        //   float _651 = log2(_650);
        //   float _652 = _651 * 0.4166666567325592f;
        //   float _653 = exp2(_652);
        //   float _654 = _653 * 1.0549999475479126f;
        //   float _655 = _654 + -0.054999999701976776f;
        //   _659 = _655;
        // } else {
        //   float _657 = _645 * 12.923210144042969f;
        //   _659 = _657;
        // }
        // bool _660 = !(_646 >= 0.0030399328097701073f);
        // if (!_660) {
        //   float _662 = abs(_646);
        //   float _663 = log2(_662);
        //   float _664 = _663 * 0.4166666567325592f;
        //   float _665 = exp2(_664);
        //   float _666 = _665 * 1.0549999475479126f;
        //   float _667 = _666 + -0.054999999701976776f;
        //   _671 = _667;
        // } else {
        //   float _669 = _646 * 12.923210144042969f;
        //   _671 = _669;
        // }
        // bool _672 = !(_647 >= 0.0030399328097701073f);
        // if (!_672) {
        //   float _674 = abs(_647);
        //   float _675 = log2(_674);
        //   float _676 = _675 * 0.4166666567325592f;
        //   float _677 = exp2(_676);
        //   float _678 = _677 * 1.0549999475479126f;
        //   float _679 = _678 + -0.054999999701976776f;
        //   _752 = _659;
        //   _753 = _671;
        //   _754 = _679;
        // } else {
        //   float _681 = _647 * 12.923210144042969f;
        //   _752 = _659;
        //   _753 = _671;
        //   _754 = _681;
        // }
        _752 = renodx::color::srgb::EncodeSafe(_637);
        _753 = renodx::color::srgb::EncodeSafe(_640);
        _754 = renodx::color::srgb::EncodeSafe(_643);

      } else {
        float _683 = saturate(_637);
        float _684 = saturate(_640);
        float _685 = saturate(_643);
        bool _686 = ((uint)(cb1_018w) == -2);
        if (!_686) {
          bool _688 = !(_683 >= 0.0030399328097701073f);
          if (!_688) {
            float _690 = abs(_683);
            float _691 = log2(_690);
            float _692 = _691 * 0.4166666567325592f;
            float _693 = exp2(_692);
            float _694 = _693 * 1.0549999475479126f;
            float _695 = _694 + -0.054999999701976776f;
            _699 = _695;
          } else {
            float _697 = _683 * 12.923210144042969f;
            _699 = _697;
          }
          bool _700 = !(_684 >= 0.0030399328097701073f);
          if (!_700) {
            float _702 = abs(_684);
            float _703 = log2(_702);
            float _704 = _703 * 0.4166666567325592f;
            float _705 = exp2(_704);
            float _706 = _705 * 1.0549999475479126f;
            float _707 = _706 + -0.054999999701976776f;
            _711 = _707;
          } else {
            float _709 = _684 * 12.923210144042969f;
            _711 = _709;
          }
          bool _712 = !(_685 >= 0.0030399328097701073f);
          if (!_712) {
            float _714 = abs(_685);
            float _715 = log2(_714);
            float _716 = _715 * 0.4166666567325592f;
            float _717 = exp2(_716);
            float _718 = _717 * 1.0549999475479126f;
            float _719 = _718 + -0.054999999701976776f;
            _723 = _699;
            _724 = _711;
            _725 = _719;
          } else {
            float _721 = _685 * 12.923210144042969f;
            _723 = _699;
            _724 = _711;
            _725 = _721;
          }
        } else {
          _723 = _683;
          _724 = _684;
          _725 = _685;
        }
        float _730 = abs(_723);
        float _731 = abs(_724);
        float _732 = abs(_725);
        float _733 = log2(_730);
        float _734 = log2(_731);
        float _735 = log2(_732);
        float _736 = _733 * cb2_000z;
        float _737 = _734 * cb2_000z;
        float _738 = _735 * cb2_000z;
        float _739 = exp2(_736);
        float _740 = exp2(_737);
        float _741 = exp2(_738);
        float _742 = _739 * cb2_000y;
        float _743 = _740 * cb2_000y;
        float _744 = _741 * cb2_000y;
        float _745 = _742 + cb2_000x;
        float _746 = _743 + cb2_000x;
        float _747 = _744 + cb2_000x;
        float _748 = saturate(_745);
        float _749 = saturate(_746);
        float _750 = saturate(_747);
        _752 = _748;
        _753 = _749;
        _754 = _750;
      }
      float _755 = dot(float3(_752, _753, _754), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _752;
      SV_Target.y = _753;
      SV_Target.z = _754;
      SV_Target.w = _755;
      SV_Target_1.x = _755;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
