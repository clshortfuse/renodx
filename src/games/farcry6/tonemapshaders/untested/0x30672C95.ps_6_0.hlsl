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
  float _26 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _28 = t8.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
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
  float4 _51 = t8.SampleLevel(s2_space2, float2(_49, _50), 0.0f);
  float _53 = _51.w * _43;
  float _54 = _51.w * _48;
  float _55 = 1.0f - _28.y;
  float _56 = saturate(_55);
  float _57 = _53 * _56;
  float _58 = _54 * _56;
  float _62 = cb2_015x * TEXCOORD0_centroid.x;
  float _63 = cb2_015y * TEXCOORD0_centroid.y;
  float _66 = _62 + cb2_015z;
  float _67 = _63 + cb2_015w;
  float4 _68 = t9.SampleLevel(s0_space2, float2(_66, _67), 0.0f);
  float _72 = saturate(_68.x);
  float _73 = saturate(_68.z);
  float _76 = cb2_026x * _73;
  float _77 = _72 * 6.283199787139893f;
  float _78 = cos(_77);
  float _79 = sin(_77);
  float _80 = _76 * _78;
  float _81 = _79 * _76;
  float _82 = 1.0f - _68.y;
  float _83 = saturate(_82);
  float _84 = _80 * _83;
  float _85 = _81 * _83;
  float _86 = _57 + TEXCOORD0_centroid.x;
  float _87 = _86 + _84;
  float _88 = _58 + TEXCOORD0_centroid.y;
  float _89 = _88 + _85;
  float4 _90 = t8.SampleLevel(s2_space2, float2(_87, _89), 0.0f);
  bool _92 = (_90.y > 0.0f);
  float _93 = select(_92, TEXCOORD0_centroid.x, _87);
  float _94 = select(_92, TEXCOORD0_centroid.y, _89);
  float4 _95 = t1.SampleLevel(s4_space2, float2(_93, _94), 0.0f);
  float _99 = max(_95.x, 0.0f);
  float _100 = max(_95.y, 0.0f);
  float _101 = max(_95.z, 0.0f);
  float _102 = min(_99, 65000.0f);
  float _103 = min(_100, 65000.0f);
  float _104 = min(_101, 65000.0f);
  float4 _105 = t4.SampleLevel(s2_space2, float2(_93, _94), 0.0f);
  float _110 = max(_105.x, 0.0f);
  float _111 = max(_105.y, 0.0f);
  float _112 = max(_105.z, 0.0f);
  float _113 = max(_105.w, 0.0f);
  float _114 = min(_110, 5000.0f);
  float _115 = min(_111, 5000.0f);
  float _116 = min(_112, 5000.0f);
  float _117 = min(_113, 5000.0f);
  float _120 = _26.x * cb0_028z;
  float _121 = _120 + cb0_028x;
  float _122 = cb2_027w / _121;
  float _123 = 1.0f - _122;
  float _124 = abs(_123);
  float _126 = cb2_027y * _124;
  float _128 = _126 - cb2_027z;
  float _129 = saturate(_128);
  float _130 = max(_129, _117);
  float _131 = saturate(_130);
  float4 _132 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _136 = _114 - _102;
  float _137 = _115 - _103;
  float _138 = _116 - _104;
  float _139 = _131 * _136;
  float _140 = _131 * _137;
  float _141 = _131 * _138;
  float _142 = _139 + _102;
  float _143 = _140 + _103;
  float _144 = _141 + _104;
  float _145 = dot(float3(_142, _143, _144), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _149 = t0[0].SExposureData_020;
  float _151 = t0[0].SExposureData_004;
  float _153 = cb2_018x * 0.5f;
  float _154 = _153 * cb2_018y;
  float _155 = _151.x - _154;
  float _156 = cb2_018y * cb2_018x;
  float _157 = 1.0f / _156;
  float _158 = _155 * _157;
  float _159 = _145 / _149.x;
  float _160 = _159 * 5464.01611328125f;
  float _161 = _160 + 9.99999993922529e-09f;
  float _162 = log2(_161);
  float _163 = _162 - _155;
  float _164 = _163 * _157;
  float _165 = saturate(_164);
  float2 _166 = t10.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _165), 0.0f);
  float _169 = max(_166.y, 1.0000000116860974e-07f);
  float _170 = _166.x / _169;
  float _171 = _170 + _158;
  float _172 = _171 / _157;
  float _173 = _172 - _151.x;
  float _174 = -0.0f - _173;
  float _176 = _174 - cb2_027x;
  float _177 = max(0.0f, _176);
  float _179 = cb2_026z * _177;
  float _180 = _173 - cb2_027x;
  float _181 = max(0.0f, _180);
  float _183 = cb2_026w * _181;
  bool _184 = (_173 < 0.0f);
  float _185 = select(_184, _179, _183);
  float _186 = exp2(_185);
  float _187 = _186 * _142;
  float _188 = _186 * _143;
  float _189 = _186 * _144;
  float _194 = cb2_024y * _132.x;
  float _195 = cb2_024z * _132.y;
  float _196 = cb2_024w * _132.z;
  float _197 = _194 + _187;
  float _198 = _195 + _188;
  float _199 = _196 + _189;
  float _204 = _197 * cb2_025x;
  float _205 = _198 * cb2_025y;
  float _206 = _199 * cb2_025z;
  float _207 = dot(float3(_204, _205, _206), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _208 = t0[0].SExposureData_012;
  float _210 = _207 * 5464.01611328125f;
  float _211 = _210 * _208.x;
  float _212 = _211 + 9.99999993922529e-09f;
  float _213 = log2(_212);
  float _214 = _213 + 16.929765701293945f;
  float _215 = _214 * 0.05734497308731079f;
  float _216 = saturate(_215);
  float _217 = _216 * _216;
  float _218 = _216 * 2.0f;
  float _219 = 3.0f - _218;
  float _220 = _217 * _219;
  float _221 = _205 * 0.8450999855995178f;
  float _222 = _206 * 0.14589999616146088f;
  float _223 = _221 + _222;
  float _224 = _223 * 2.4890189170837402f;
  float _225 = _223 * 0.3754962384700775f;
  float _226 = _223 * 2.811495304107666f;
  float _227 = _223 * 5.519708156585693f;
  float _228 = _207 - _224;
  float _229 = _220 * _228;
  float _230 = _229 + _224;
  float _231 = _220 * 0.5f;
  float _232 = _231 + 0.5f;
  float _233 = _232 * _228;
  float _234 = _233 + _224;
  float _235 = _204 - _225;
  float _236 = _205 - _226;
  float _237 = _206 - _227;
  float _238 = _232 * _235;
  float _239 = _232 * _236;
  float _240 = _232 * _237;
  float _241 = _238 + _225;
  float _242 = _239 + _226;
  float _243 = _240 + _227;
  float _244 = 1.0f / _234;
  float _245 = _230 * _244;
  float _246 = _245 * _241;
  float _247 = _245 * _242;
  float _248 = _245 * _243;
  float _252 = cb2_020x * TEXCOORD0_centroid.x;
  float _253 = cb2_020y * TEXCOORD0_centroid.y;
  float _256 = _252 + cb2_020z;
  float _257 = _253 + cb2_020w;
  float _260 = dot(float2(_256, _257), float2(_256, _257));
  float _261 = 1.0f - _260;
  float _262 = saturate(_261);
  float _263 = log2(_262);
  float _264 = _263 * cb2_021w;
  float _265 = exp2(_264);
  float _269 = _246 - cb2_021x;
  float _270 = _247 - cb2_021y;
  float _271 = _248 - cb2_021z;
  float _272 = _269 * _265;
  float _273 = _270 * _265;
  float _274 = _271 * _265;
  float _275 = _272 + cb2_021x;
  float _276 = _273 + cb2_021y;
  float _277 = _274 + cb2_021z;
  float _278 = t0[0].SExposureData_000;
  float _280 = max(_149.x, 0.0010000000474974513f);
  float _281 = 1.0f / _280;
  float _282 = _281 * _278.x;
  bool _285 = ((uint)(cb2_069y) == 0);
  float _291;
  float _292;
  float _293;
  float _347;
  float _348;
  float _349;
  float _440;
  float _441;
  float _442;
  float _487;
  float _488;
  float _489;
  float _490;
  float _539;
  float _540;
  float _541;
  float _542;
  float _567;
  float _568;
  float _569;
  float _670;
  float _671;
  float _672;
  float _697;
  float _709;
  float _737;
  float _749;
  float _761;
  float _762;
  float _763;
  float _790;
  float _791;
  float _792;
  if (!_285) {
    float _287 = _282 * _275;
    float _288 = _282 * _276;
    float _289 = _282 * _277;
    _291 = _287;
    _292 = _288;
    _293 = _289;
  } else {
    _291 = _275;
    _292 = _276;
    _293 = _277;
  }
  float _294 = _291 * 0.6130970120429993f;
  float _295 = mad(0.33952298760414124f, _292, _294);
  float _296 = mad(0.04737899824976921f, _293, _295);
  float _297 = _291 * 0.07019399851560593f;
  float _298 = mad(0.9163540005683899f, _292, _297);
  float _299 = mad(0.013451999984681606f, _293, _298);
  float _300 = _291 * 0.02061600051820278f;
  float _301 = mad(0.10956999659538269f, _292, _300);
  float _302 = mad(0.8698149919509888f, _293, _301);
  float _303 = log2(_296);
  float _304 = log2(_299);
  float _305 = log2(_302);
  float _306 = _303 * 0.04211956635117531f;
  float _307 = _304 * 0.04211956635117531f;
  float _308 = _305 * 0.04211956635117531f;
  float _309 = _306 + 0.6252607107162476f;
  float _310 = _307 + 0.6252607107162476f;
  float _311 = _308 + 0.6252607107162476f;
  float4 _312 = t6.SampleLevel(s2_space2, float3(_309, _310, _311), 0.0f);
  bool _318 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_318 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _322 = cb2_017x * _312.x;
    float _323 = cb2_017x * _312.y;
    float _324 = cb2_017x * _312.z;
    float _326 = _322 + cb2_017y;
    float _327 = _323 + cb2_017y;
    float _328 = _324 + cb2_017y;
    float _329 = exp2(_326);
    float _330 = exp2(_327);
    float _331 = exp2(_328);
    float _332 = _329 + 1.0f;
    float _333 = _330 + 1.0f;
    float _334 = _331 + 1.0f;
    float _335 = 1.0f / _332;
    float _336 = 1.0f / _333;
    float _337 = 1.0f / _334;
    float _339 = cb2_017z * _335;
    float _340 = cb2_017z * _336;
    float _341 = cb2_017z * _337;
    float _343 = _339 + cb2_017w;
    float _344 = _340 + cb2_017w;
    float _345 = _341 + cb2_017w;
    _347 = _343;
    _348 = _344;
    _349 = _345;
  } else {
    _347 = _312.x;
    _348 = _312.y;
    _349 = _312.z;
  }
  float _350 = _347 * 23.0f;
  float _351 = _350 + -14.473931312561035f;
  float _352 = exp2(_351);
  float _353 = _348 * 23.0f;
  float _354 = _353 + -14.473931312561035f;
  float _355 = exp2(_354);
  float _356 = _349 * 23.0f;
  float _357 = _356 + -14.473931312561035f;
  float _358 = exp2(_357);
  float _359 = dot(float3(_352, _355, _358), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _364 = dot(float3(_352, _355, _358), float3(_352, _355, _358));
  float _365 = rsqrt(_364);
  float _366 = _365 * _352;
  float _367 = _365 * _355;
  float _368 = _365 * _358;
  float _369 = cb2_001x - _366;
  float _370 = cb2_001y - _367;
  float _371 = cb2_001z - _368;
  float _372 = dot(float3(_369, _370, _371), float3(_369, _370, _371));
  float _375 = cb2_002z * _372;
  float _377 = _375 + cb2_002w;
  float _378 = saturate(_377);
  float _380 = cb2_002x * _378;
  float _381 = _359 - _352;
  float _382 = _359 - _355;
  float _383 = _359 - _358;
  float _384 = _380 * _381;
  float _385 = _380 * _382;
  float _386 = _380 * _383;
  float _387 = _384 + _352;
  float _388 = _385 + _355;
  float _389 = _386 + _358;
  float _391 = cb2_002y * _378;
  float _392 = 0.10000000149011612f - _387;
  float _393 = 0.10000000149011612f - _388;
  float _394 = 0.10000000149011612f - _389;
  float _395 = _392 * _391;
  float _396 = _393 * _391;
  float _397 = _394 * _391;
  float _398 = _395 + _387;
  float _399 = _396 + _388;
  float _400 = _397 + _389;
  float _401 = saturate(_398);
  float _402 = saturate(_399);
  float _403 = saturate(_400);
  float _408 = cb2_004x * TEXCOORD0_centroid.x;
  float _409 = cb2_004y * TEXCOORD0_centroid.y;
  float _412 = _408 + cb2_004z;
  float _413 = _409 + cb2_004w;
  float4 _419 = t7.Sample(s2_space2, float2(_412, _413));
  float _424 = _419.x * cb2_003x;
  float _425 = _419.y * cb2_003y;
  float _426 = _419.z * cb2_003z;
  float _427 = _419.w * cb2_003w;
  float _430 = _427 + cb2_026y;
  float _431 = saturate(_430);
  bool _434 = ((uint)(cb2_069y) == 0);
  if (!_434) {
    float _436 = _424 * _282;
    float _437 = _425 * _282;
    float _438 = _426 * _282;
    _440 = _436;
    _441 = _437;
    _442 = _438;
  } else {
    _440 = _424;
    _441 = _425;
    _442 = _426;
  }
  bool _445 = ((uint)(cb2_028x) == 2);
  bool _446 = ((uint)(cb2_028x) == 3);
  int _447 = (uint)(cb2_028x) & -2;
  bool _448 = (_447 == 2);
  bool _449 = ((uint)(cb2_028x) == 6);
  bool _450 = _448 || _449;
  if (_450) {
    float _452 = _440 * _431;
    float _453 = _441 * _431;
    float _454 = _442 * _431;
    float _455 = _431 * _431;
    _487 = _452;
    _488 = _453;
    _489 = _454;
    _490 = _455;
  } else {
    bool _457 = ((uint)(cb2_028x) == 4);
    if (_457) {
      float _459 = _440 + -1.0f;
      float _460 = _441 + -1.0f;
      float _461 = _442 + -1.0f;
      float _462 = _431 + -1.0f;
      float _463 = _459 * _431;
      float _464 = _460 * _431;
      float _465 = _461 * _431;
      float _466 = _462 * _431;
      float _467 = _463 + 1.0f;
      float _468 = _464 + 1.0f;
      float _469 = _465 + 1.0f;
      float _470 = _466 + 1.0f;
      _487 = _467;
      _488 = _468;
      _489 = _469;
      _490 = _470;
    } else {
      bool _472 = ((uint)(cb2_028x) == 5);
      if (_472) {
        float _474 = _440 + -0.5f;
        float _475 = _441 + -0.5f;
        float _476 = _442 + -0.5f;
        float _477 = _431 + -0.5f;
        float _478 = _474 * _431;
        float _479 = _475 * _431;
        float _480 = _476 * _431;
        float _481 = _477 * _431;
        float _482 = _478 + 0.5f;
        float _483 = _479 + 0.5f;
        float _484 = _480 + 0.5f;
        float _485 = _481 + 0.5f;
        _487 = _482;
        _488 = _483;
        _489 = _484;
        _490 = _485;
      } else {
        _487 = _440;
        _488 = _441;
        _489 = _442;
        _490 = _431;
      }
    }
  }
  if (_445) {
    float _492 = _487 + _401;
    float _493 = _488 + _402;
    float _494 = _489 + _403;
    _539 = _492;
    _540 = _493;
    _541 = _494;
    _542 = cb2_025w;
  } else {
    if (_446) {
      float _497 = 1.0f - _487;
      float _498 = 1.0f - _488;
      float _499 = 1.0f - _489;
      float _500 = _497 * _401;
      float _501 = _498 * _402;
      float _502 = _499 * _403;
      float _503 = _500 + _487;
      float _504 = _501 + _488;
      float _505 = _502 + _489;
      _539 = _503;
      _540 = _504;
      _541 = _505;
      _542 = cb2_025w;
    } else {
      bool _507 = ((uint)(cb2_028x) == 4);
      if (_507) {
        float _509 = _487 * _401;
        float _510 = _488 * _402;
        float _511 = _489 * _403;
        _539 = _509;
        _540 = _510;
        _541 = _511;
        _542 = cb2_025w;
      } else {
        bool _513 = ((uint)(cb2_028x) == 5);
        if (_513) {
          float _515 = _401 * 2.0f;
          float _516 = _515 * _487;
          float _517 = _402 * 2.0f;
          float _518 = _517 * _488;
          float _519 = _403 * 2.0f;
          float _520 = _519 * _489;
          _539 = _516;
          _540 = _518;
          _541 = _520;
          _542 = cb2_025w;
        } else {
          if (_449) {
            float _523 = _401 - _487;
            float _524 = _402 - _488;
            float _525 = _403 - _489;
            _539 = _523;
            _540 = _524;
            _541 = _525;
            _542 = cb2_025w;
          } else {
            float _527 = _487 - _401;
            float _528 = _488 - _402;
            float _529 = _489 - _403;
            float _530 = _490 * _527;
            float _531 = _490 * _528;
            float _532 = _490 * _529;
            float _533 = _530 + _401;
            float _534 = _531 + _402;
            float _535 = _532 + _403;
            float _536 = 1.0f - _490;
            float _537 = _536 * cb2_025w;
            _539 = _533;
            _540 = _534;
            _541 = _535;
            _542 = _537;
          }
        }
      }
    }
  }
  float _548 = cb2_016x - _539;
  float _549 = cb2_016y - _540;
  float _550 = cb2_016z - _541;
  float _551 = _548 * cb2_016w;
  float _552 = _549 * cb2_016w;
  float _553 = _550 * cb2_016w;
  float _554 = _551 + _539;
  float _555 = _552 + _540;
  float _556 = _553 + _541;
  bool _559 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_559 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _563 = cb2_024x * _554;
    float _564 = cb2_024x * _555;
    float _565 = cb2_024x * _556;
    _567 = _563;
    _568 = _564;
    _569 = _565;
  } else {
    _567 = _554;
    _568 = _555;
    _569 = _556;
  }
  float _570 = _567 * 0.9708889722824097f;
  float _571 = mad(0.026962999254465103f, _568, _570);
  float _572 = mad(0.002148000057786703f, _569, _571);
  float _573 = _567 * 0.01088900025933981f;
  float _574 = mad(0.9869629740715027f, _568, _573);
  float _575 = mad(0.002148000057786703f, _569, _574);
  float _576 = mad(0.026962999254465103f, _568, _573);
  float _577 = mad(0.9621480107307434f, _569, _576);
  if (_559) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _582 = cb1_018y * 0.10000000149011612f;
        float _583 = log2(cb1_018z);
        float _584 = _583 + -13.287712097167969f;
        float _585 = _584 * 1.4929734468460083f;
        float _586 = _585 + 18.0f;
        float _587 = exp2(_586);
        float _588 = _587 * 0.18000000715255737f;
        float _589 = abs(_588);
        float _590 = log2(_589);
        float _591 = _590 * 1.5f;
        float _592 = exp2(_591);
        float _593 = _592 * _582;
        float _594 = _593 / cb1_018z;
        float _595 = _594 + -0.07636754959821701f;
        float _596 = _590 * 1.2750000953674316f;
        float _597 = exp2(_596);
        float _598 = _597 * 0.07636754959821701f;
        float _599 = cb1_018y * 0.011232397519052029f;
        float _600 = _599 * _592;
        float _601 = _600 / cb1_018z;
        float _602 = _598 - _601;
        float _603 = _597 + -0.11232396960258484f;
        float _604 = _603 * _582;
        float _605 = _604 / cb1_018z;
        float _606 = _605 * cb1_018z;
        float _607 = abs(_572);
        float _608 = abs(_575);
        float _609 = abs(_577);
        float _610 = log2(_607);
        float _611 = log2(_608);
        float _612 = log2(_609);
        float _613 = _610 * 1.5f;
        float _614 = _611 * 1.5f;
        float _615 = _612 * 1.5f;
        float _616 = exp2(_613);
        float _617 = exp2(_614);
        float _618 = exp2(_615);
        float _619 = _616 * _606;
        float _620 = _617 * _606;
        float _621 = _618 * _606;
        float _622 = _610 * 1.2750000953674316f;
        float _623 = _611 * 1.2750000953674316f;
        float _624 = _612 * 1.2750000953674316f;
        float _625 = exp2(_622);
        float _626 = exp2(_623);
        float _627 = exp2(_624);
        float _628 = _625 * _595;
        float _629 = _626 * _595;
        float _630 = _627 * _595;
        float _631 = _628 + _602;
        float _632 = _629 + _602;
        float _633 = _630 + _602;
        float _634 = _619 / _631;
        float _635 = _620 / _632;
        float _636 = _621 / _633;
        float _637 = _634 * 9.999999747378752e-05f;
        float _638 = _635 * 9.999999747378752e-05f;
        float _639 = _636 * 9.999999747378752e-05f;
        float _640 = 5000.0f / cb1_018y;
        float _641 = _637 * _640;
        float _642 = _638 * _640;
        float _643 = _639 * _640;
        _670 = _641;
        _671 = _642;
        _672 = _643;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_572, _575, _577));
      _670 = tonemapped.x, _671 = tonemapped.y, _672 = tonemapped.z;
    }
      } else {
        float _645 = _572 + 0.020616600289940834f;
        float _646 = _575 + 0.020616600289940834f;
        float _647 = _577 + 0.020616600289940834f;
        float _648 = _645 * _572;
        float _649 = _646 * _575;
        float _650 = _647 * _577;
        float _651 = _648 + -7.456949970219284e-05f;
        float _652 = _649 + -7.456949970219284e-05f;
        float _653 = _650 + -7.456949970219284e-05f;
        float _654 = _572 * 0.9837960004806519f;
        float _655 = _575 * 0.9837960004806519f;
        float _656 = _577 * 0.9837960004806519f;
        float _657 = _654 + 0.4336790144443512f;
        float _658 = _655 + 0.4336790144443512f;
        float _659 = _656 + 0.4336790144443512f;
        float _660 = _657 * _572;
        float _661 = _658 * _575;
        float _662 = _659 * _577;
        float _663 = _660 + 0.24617899954319f;
        float _664 = _661 + 0.24617899954319f;
        float _665 = _662 + 0.24617899954319f;
        float _666 = _651 / _663;
        float _667 = _652 / _664;
        float _668 = _653 / _665;
        _670 = _666;
        _671 = _667;
        _672 = _668;
      }
      float _673 = _670 * 1.6047500371932983f;
      float _674 = mad(-0.5310800075531006f, _671, _673);
      float _675 = mad(-0.07366999983787537f, _672, _674);
      float _676 = _670 * -0.10208000242710114f;
      float _677 = mad(1.1081299781799316f, _671, _676);
      float _678 = mad(-0.006049999967217445f, _672, _677);
      float _679 = _670 * -0.0032599999103695154f;
      float _680 = mad(-0.07275000214576721f, _671, _679);
      float _681 = mad(1.0760200023651123f, _672, _680);
      if (_559) {
        // float _683 = max(_675, 0.0f);
        // float _684 = max(_678, 0.0f);
        // float _685 = max(_681, 0.0f);
        // bool _686 = !(_683 >= 0.0030399328097701073f);
        // if (!_686) {
        //   float _688 = abs(_683);
        //   float _689 = log2(_688);
        //   float _690 = _689 * 0.4166666567325592f;
        //   float _691 = exp2(_690);
        //   float _692 = _691 * 1.0549999475479126f;
        //   float _693 = _692 + -0.054999999701976776f;
        //   _697 = _693;
        // } else {
        //   float _695 = _683 * 12.923210144042969f;
        //   _697 = _695;
        // }
        // bool _698 = !(_684 >= 0.0030399328097701073f);
        // if (!_698) {
        //   float _700 = abs(_684);
        //   float _701 = log2(_700);
        //   float _702 = _701 * 0.4166666567325592f;
        //   float _703 = exp2(_702);
        //   float _704 = _703 * 1.0549999475479126f;
        //   float _705 = _704 + -0.054999999701976776f;
        //   _709 = _705;
        // } else {
        //   float _707 = _684 * 12.923210144042969f;
        //   _709 = _707;
        // }
        // bool _710 = !(_685 >= 0.0030399328097701073f);
        // if (!_710) {
        //   float _712 = abs(_685);
        //   float _713 = log2(_712);
        //   float _714 = _713 * 0.4166666567325592f;
        //   float _715 = exp2(_714);
        //   float _716 = _715 * 1.0549999475479126f;
        //   float _717 = _716 + -0.054999999701976776f;
        //   _790 = _697;
        //   _791 = _709;
        //   _792 = _717;
        // } else {
        //   float _719 = _685 * 12.923210144042969f;
        //   _790 = _697;
        //   _791 = _709;
        //   _792 = _719;
        // }
        _790 = renodx::color::srgb::EncodeSafe(_675);
        _791 = renodx::color::srgb::EncodeSafe(_678);
        _792 = renodx::color::srgb::EncodeSafe(_681);

      } else {
        float _721 = saturate(_675);
        float _722 = saturate(_678);
        float _723 = saturate(_681);
        bool _724 = ((uint)(cb1_018w) == -2);
        if (!_724) {
          bool _726 = !(_721 >= 0.0030399328097701073f);
          if (!_726) {
            float _728 = abs(_721);
            float _729 = log2(_728);
            float _730 = _729 * 0.4166666567325592f;
            float _731 = exp2(_730);
            float _732 = _731 * 1.0549999475479126f;
            float _733 = _732 + -0.054999999701976776f;
            _737 = _733;
          } else {
            float _735 = _721 * 12.923210144042969f;
            _737 = _735;
          }
          bool _738 = !(_722 >= 0.0030399328097701073f);
          if (!_738) {
            float _740 = abs(_722);
            float _741 = log2(_740);
            float _742 = _741 * 0.4166666567325592f;
            float _743 = exp2(_742);
            float _744 = _743 * 1.0549999475479126f;
            float _745 = _744 + -0.054999999701976776f;
            _749 = _745;
          } else {
            float _747 = _722 * 12.923210144042969f;
            _749 = _747;
          }
          bool _750 = !(_723 >= 0.0030399328097701073f);
          if (!_750) {
            float _752 = abs(_723);
            float _753 = log2(_752);
            float _754 = _753 * 0.4166666567325592f;
            float _755 = exp2(_754);
            float _756 = _755 * 1.0549999475479126f;
            float _757 = _756 + -0.054999999701976776f;
            _761 = _737;
            _762 = _749;
            _763 = _757;
          } else {
            float _759 = _723 * 12.923210144042969f;
            _761 = _737;
            _762 = _749;
            _763 = _759;
          }
        } else {
          _761 = _721;
          _762 = _722;
          _763 = _723;
        }
        float _768 = abs(_761);
        float _769 = abs(_762);
        float _770 = abs(_763);
        float _771 = log2(_768);
        float _772 = log2(_769);
        float _773 = log2(_770);
        float _774 = _771 * cb2_000z;
        float _775 = _772 * cb2_000z;
        float _776 = _773 * cb2_000z;
        float _777 = exp2(_774);
        float _778 = exp2(_775);
        float _779 = exp2(_776);
        float _780 = _777 * cb2_000y;
        float _781 = _778 * cb2_000y;
        float _782 = _779 * cb2_000y;
        float _783 = _780 + cb2_000x;
        float _784 = _781 + cb2_000x;
        float _785 = _782 + cb2_000x;
        float _786 = saturate(_783);
        float _787 = saturate(_784);
        float _788 = saturate(_785);
        _790 = _786;
        _791 = _787;
        _792 = _788;
      }
      float _796 = cb2_023x * TEXCOORD0_centroid.x;
      float _797 = cb2_023y * TEXCOORD0_centroid.y;
      float _800 = _796 + cb2_023z;
      float _801 = _797 + cb2_023w;
      float4 _804 = t11.SampleLevel(s0_space2, float2(_800, _801), 0.0f);
      float _806 = _804.x + -0.5f;
      float _807 = _806 * cb2_022x;
      float _808 = _807 + 0.5f;
      float _809 = _808 * 2.0f;
      float _810 = _809 * _790;
      float _811 = _809 * _791;
      float _812 = _809 * _792;
      float _816 = float((uint)(cb2_019z));
      float _817 = float((uint)(cb2_019w));
      float _818 = _816 + SV_Position.x;
      float _819 = _817 + SV_Position.y;
      uint _820 = uint(_818);
      uint _821 = uint(_819);
      uint _824 = cb2_019x + -1u;
      uint _825 = cb2_019y + -1u;
      int _826 = _820 & _824;
      int _827 = _821 & _825;
      float4 _828 = t3.Load(int3(_826, _827, 0));
      float _832 = _828.x * 2.0f;
      float _833 = _828.y * 2.0f;
      float _834 = _828.z * 2.0f;
      float _835 = _832 + -1.0f;
      float _836 = _833 + -1.0f;
      float _837 = _834 + -1.0f;
      float _838 = _835 * _542;
      float _839 = _836 * _542;
      float _840 = _837 * _542;
      float _841 = _838 + _810;
      float _842 = _839 + _811;
      float _843 = _840 + _812;
      float _844 = dot(float3(_841, _842, _843), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _841;
      SV_Target.y = _842;
      SV_Target.z = _843;
      SV_Target.w = _844;
      SV_Target_1.x = _844;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
