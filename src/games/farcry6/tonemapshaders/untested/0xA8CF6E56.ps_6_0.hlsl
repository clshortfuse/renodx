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
  float _25 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _27 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _31 = max(_27.x, 0.0f);
  float _32 = max(_27.y, 0.0f);
  float _33 = max(_27.z, 0.0f);
  float _34 = min(_31, 65000.0f);
  float _35 = min(_32, 65000.0f);
  float _36 = min(_33, 65000.0f);
  float4 _37 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _42 = max(_37.x, 0.0f);
  float _43 = max(_37.y, 0.0f);
  float _44 = max(_37.z, 0.0f);
  float _45 = max(_37.w, 0.0f);
  float _46 = min(_42, 5000.0f);
  float _47 = min(_43, 5000.0f);
  float _48 = min(_44, 5000.0f);
  float _49 = min(_45, 5000.0f);
  float _52 = _25.x * cb0_028z;
  float _53 = _52 + cb0_028x;
  float _54 = cb2_027w / _53;
  float _55 = 1.0f - _54;
  float _56 = abs(_55);
  float _58 = cb2_027y * _56;
  float _60 = _58 - cb2_027z;
  float _61 = saturate(_60);
  float _62 = max(_61, _49);
  float _63 = saturate(_62);
  float _67 = cb2_006x * TEXCOORD0_centroid.x;
  float _68 = cb2_006y * TEXCOORD0_centroid.y;
  float _71 = _67 + cb2_006z;
  float _72 = _68 + cb2_006w;
  float _76 = cb2_007x * TEXCOORD0_centroid.x;
  float _77 = cb2_007y * TEXCOORD0_centroid.y;
  float _80 = _76 + cb2_007z;
  float _81 = _77 + cb2_007w;
  float _85 = cb2_008x * TEXCOORD0_centroid.x;
  float _86 = cb2_008y * TEXCOORD0_centroid.y;
  float _89 = _85 + cb2_008z;
  float _90 = _86 + cb2_008w;
  float4 _91 = t1.SampleLevel(s2_space2, float2(_71, _72), 0.0f);
  float _93 = max(_91.x, 0.0f);
  float _94 = min(_93, 65000.0f);
  float4 _95 = t1.SampleLevel(s2_space2, float2(_80, _81), 0.0f);
  float _97 = max(_95.y, 0.0f);
  float _98 = min(_97, 65000.0f);
  float4 _99 = t1.SampleLevel(s2_space2, float2(_89, _90), 0.0f);
  float _101 = max(_99.z, 0.0f);
  float _102 = min(_101, 65000.0f);
  float4 _103 = t4.SampleLevel(s2_space2, float2(_71, _72), 0.0f);
  float _105 = max(_103.x, 0.0f);
  float _106 = min(_105, 5000.0f);
  float4 _107 = t4.SampleLevel(s2_space2, float2(_80, _81), 0.0f);
  float _109 = max(_107.y, 0.0f);
  float _110 = min(_109, 5000.0f);
  float4 _111 = t4.SampleLevel(s2_space2, float2(_89, _90), 0.0f);
  float _113 = max(_111.z, 0.0f);
  float _114 = min(_113, 5000.0f);
  float4 _115 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _121 = cb2_005x * _115.x;
  float _122 = cb2_005x * _115.y;
  float _123 = cb2_005x * _115.z;
  float _124 = _94 - _34;
  float _125 = _98 - _35;
  float _126 = _102 - _36;
  float _127 = _121 * _124;
  float _128 = _122 * _125;
  float _129 = _123 * _126;
  float _130 = _127 + _34;
  float _131 = _128 + _35;
  float _132 = _129 + _36;
  float _133 = _106 - _46;
  float _134 = _110 - _47;
  float _135 = _114 - _48;
  float _136 = _121 * _133;
  float _137 = _122 * _134;
  float _138 = _123 * _135;
  float _139 = _136 + _46;
  float _140 = _137 + _47;
  float _141 = _138 + _48;
  float4 _142 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _146 = _139 - _130;
  float _147 = _140 - _131;
  float _148 = _141 - _132;
  float _149 = _146 * _63;
  float _150 = _147 * _63;
  float _151 = _148 * _63;
  float _152 = _149 + _130;
  float _153 = _150 + _131;
  float _154 = _151 + _132;
  float _155 = dot(float3(_152, _153, _154), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _159 = t0[0].SExposureData_020;
  float _161 = t0[0].SExposureData_004;
  float _163 = cb2_018x * 0.5f;
  float _164 = _163 * cb2_018y;
  float _165 = _161.x - _164;
  float _166 = cb2_018y * cb2_018x;
  float _167 = 1.0f / _166;
  float _168 = _165 * _167;
  float _169 = _155 / _159.x;
  float _170 = _169 * 5464.01611328125f;
  float _171 = _170 + 9.99999993922529e-09f;
  float _172 = log2(_171);
  float _173 = _172 - _165;
  float _174 = _173 * _167;
  float _175 = saturate(_174);
  float2 _176 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _175), 0.0f);
  float _179 = max(_176.y, 1.0000000116860974e-07f);
  float _180 = _176.x / _179;
  float _181 = _180 + _168;
  float _182 = _181 / _167;
  float _183 = _182 - _161.x;
  float _184 = -0.0f - _183;
  float _186 = _184 - cb2_027x;
  float _187 = max(0.0f, _186);
  float _190 = cb2_026z * _187;
  float _191 = _183 - cb2_027x;
  float _192 = max(0.0f, _191);
  float _194 = cb2_026w * _192;
  bool _195 = (_183 < 0.0f);
  float _196 = select(_195, _190, _194);
  float _197 = exp2(_196);
  float _198 = _197 * _152;
  float _199 = _197 * _153;
  float _200 = _197 * _154;
  float _205 = cb2_024y * _142.x;
  float _206 = cb2_024z * _142.y;
  float _207 = cb2_024w * _142.z;
  float _208 = _205 + _198;
  float _209 = _206 + _199;
  float _210 = _207 + _200;
  float _215 = _208 * cb2_025x;
  float _216 = _209 * cb2_025y;
  float _217 = _210 * cb2_025z;
  float _218 = dot(float3(_215, _216, _217), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _219 = t0[0].SExposureData_012;
  float _221 = _218 * 5464.01611328125f;
  float _222 = _221 * _219.x;
  float _223 = _222 + 9.99999993922529e-09f;
  float _224 = log2(_223);
  float _225 = _224 + 16.929765701293945f;
  float _226 = _225 * 0.05734497308731079f;
  float _227 = saturate(_226);
  float _228 = _227 * _227;
  float _229 = _227 * 2.0f;
  float _230 = 3.0f - _229;
  float _231 = _228 * _230;
  float _232 = _216 * 0.8450999855995178f;
  float _233 = _217 * 0.14589999616146088f;
  float _234 = _232 + _233;
  float _235 = _234 * 2.4890189170837402f;
  float _236 = _234 * 0.3754962384700775f;
  float _237 = _234 * 2.811495304107666f;
  float _238 = _234 * 5.519708156585693f;
  float _239 = _218 - _235;
  float _240 = _231 * _239;
  float _241 = _240 + _235;
  float _242 = _231 * 0.5f;
  float _243 = _242 + 0.5f;
  float _244 = _243 * _239;
  float _245 = _244 + _235;
  float _246 = _215 - _236;
  float _247 = _216 - _237;
  float _248 = _217 - _238;
  float _249 = _243 * _246;
  float _250 = _243 * _247;
  float _251 = _243 * _248;
  float _252 = _249 + _236;
  float _253 = _250 + _237;
  float _254 = _251 + _238;
  float _255 = 1.0f / _245;
  float _256 = _241 * _255;
  float _257 = _256 * _252;
  float _258 = _256 * _253;
  float _259 = _256 * _254;
  float _263 = cb2_020x * TEXCOORD0_centroid.x;
  float _264 = cb2_020y * TEXCOORD0_centroid.y;
  float _267 = _263 + cb2_020z;
  float _268 = _264 + cb2_020w;
  float _271 = dot(float2(_267, _268), float2(_267, _268));
  float _272 = 1.0f - _271;
  float _273 = saturate(_272);
  float _274 = log2(_273);
  float _275 = _274 * cb2_021w;
  float _276 = exp2(_275);
  float _280 = _257 - cb2_021x;
  float _281 = _258 - cb2_021y;
  float _282 = _259 - cb2_021z;
  float _283 = _280 * _276;
  float _284 = _281 * _276;
  float _285 = _282 * _276;
  float _286 = _283 + cb2_021x;
  float _287 = _284 + cb2_021y;
  float _288 = _285 + cb2_021z;
  float _289 = t0[0].SExposureData_000;
  float _291 = max(_159.x, 0.0010000000474974513f);
  float _292 = 1.0f / _291;
  float _293 = _292 * _289.x;
  bool _296 = ((uint)(cb2_069y) == 0);
  float _302;
  float _303;
  float _304;
  float _358;
  float _359;
  float _360;
  float _406;
  float _407;
  float _408;
  float _453;
  float _454;
  float _455;
  float _456;
  float _505;
  float _506;
  float _507;
  float _508;
  float _533;
  float _534;
  float _535;
  float _636;
  float _637;
  float _638;
  float _663;
  float _675;
  float _703;
  float _715;
  float _727;
  float _728;
  float _729;
  float _756;
  float _757;
  float _758;
  if (!_296) {
    float _298 = _293 * _286;
    float _299 = _293 * _287;
    float _300 = _293 * _288;
    _302 = _298;
    _303 = _299;
    _304 = _300;
  } else {
    _302 = _286;
    _303 = _287;
    _304 = _288;
  }
  float _305 = _302 * 0.6130970120429993f;
  float _306 = mad(0.33952298760414124f, _303, _305);
  float _307 = mad(0.04737899824976921f, _304, _306);
  float _308 = _302 * 0.07019399851560593f;
  float _309 = mad(0.9163540005683899f, _303, _308);
  float _310 = mad(0.013451999984681606f, _304, _309);
  float _311 = _302 * 0.02061600051820278f;
  float _312 = mad(0.10956999659538269f, _303, _311);
  float _313 = mad(0.8698149919509888f, _304, _312);
  float _314 = log2(_307);
  float _315 = log2(_310);
  float _316 = log2(_313);
  float _317 = _314 * 0.04211956635117531f;
  float _318 = _315 * 0.04211956635117531f;
  float _319 = _316 * 0.04211956635117531f;
  float _320 = _317 + 0.6252607107162476f;
  float _321 = _318 + 0.6252607107162476f;
  float _322 = _319 + 0.6252607107162476f;
  float4 _323 = t6.SampleLevel(s2_space2, float3(_320, _321, _322), 0.0f);
  bool _329 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_329 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _333 = cb2_017x * _323.x;
    float _334 = cb2_017x * _323.y;
    float _335 = cb2_017x * _323.z;
    float _337 = _333 + cb2_017y;
    float _338 = _334 + cb2_017y;
    float _339 = _335 + cb2_017y;
    float _340 = exp2(_337);
    float _341 = exp2(_338);
    float _342 = exp2(_339);
    float _343 = _340 + 1.0f;
    float _344 = _341 + 1.0f;
    float _345 = _342 + 1.0f;
    float _346 = 1.0f / _343;
    float _347 = 1.0f / _344;
    float _348 = 1.0f / _345;
    float _350 = cb2_017z * _346;
    float _351 = cb2_017z * _347;
    float _352 = cb2_017z * _348;
    float _354 = _350 + cb2_017w;
    float _355 = _351 + cb2_017w;
    float _356 = _352 + cb2_017w;
    _358 = _354;
    _359 = _355;
    _360 = _356;
  } else {
    _358 = _323.x;
    _359 = _323.y;
    _360 = _323.z;
  }
  float _361 = _358 * 23.0f;
  float _362 = _361 + -14.473931312561035f;
  float _363 = exp2(_362);
  float _364 = _359 * 23.0f;
  float _365 = _364 + -14.473931312561035f;
  float _366 = exp2(_365);
  float _367 = _360 * 23.0f;
  float _368 = _367 + -14.473931312561035f;
  float _369 = exp2(_368);
  float _374 = cb2_004x * TEXCOORD0_centroid.x;
  float _375 = cb2_004y * TEXCOORD0_centroid.y;
  float _378 = _374 + cb2_004z;
  float _379 = _375 + cb2_004w;
  float4 _385 = t8.Sample(s2_space2, float2(_378, _379));
  float _390 = _385.x * cb2_003x;
  float _391 = _385.y * cb2_003y;
  float _392 = _385.z * cb2_003z;
  float _393 = _385.w * cb2_003w;
  float _396 = _393 + cb2_026y;
  float _397 = saturate(_396);
  bool _400 = ((uint)(cb2_069y) == 0);
  if (!_400) {
    float _402 = _390 * _293;
    float _403 = _391 * _293;
    float _404 = _392 * _293;
    _406 = _402;
    _407 = _403;
    _408 = _404;
  } else {
    _406 = _390;
    _407 = _391;
    _408 = _392;
  }
  bool _411 = ((uint)(cb2_028x) == 2);
  bool _412 = ((uint)(cb2_028x) == 3);
  int _413 = (uint)(cb2_028x) & -2;
  bool _414 = (_413 == 2);
  bool _415 = ((uint)(cb2_028x) == 6);
  bool _416 = _414 || _415;
  if (_416) {
    float _418 = _406 * _397;
    float _419 = _407 * _397;
    float _420 = _408 * _397;
    float _421 = _397 * _397;
    _453 = _418;
    _454 = _419;
    _455 = _420;
    _456 = _421;
  } else {
    bool _423 = ((uint)(cb2_028x) == 4);
    if (_423) {
      float _425 = _406 + -1.0f;
      float _426 = _407 + -1.0f;
      float _427 = _408 + -1.0f;
      float _428 = _397 + -1.0f;
      float _429 = _425 * _397;
      float _430 = _426 * _397;
      float _431 = _427 * _397;
      float _432 = _428 * _397;
      float _433 = _429 + 1.0f;
      float _434 = _430 + 1.0f;
      float _435 = _431 + 1.0f;
      float _436 = _432 + 1.0f;
      _453 = _433;
      _454 = _434;
      _455 = _435;
      _456 = _436;
    } else {
      bool _438 = ((uint)(cb2_028x) == 5);
      if (_438) {
        float _440 = _406 + -0.5f;
        float _441 = _407 + -0.5f;
        float _442 = _408 + -0.5f;
        float _443 = _397 + -0.5f;
        float _444 = _440 * _397;
        float _445 = _441 * _397;
        float _446 = _442 * _397;
        float _447 = _443 * _397;
        float _448 = _444 + 0.5f;
        float _449 = _445 + 0.5f;
        float _450 = _446 + 0.5f;
        float _451 = _447 + 0.5f;
        _453 = _448;
        _454 = _449;
        _455 = _450;
        _456 = _451;
      } else {
        _453 = _406;
        _454 = _407;
        _455 = _408;
        _456 = _397;
      }
    }
  }
  if (_411) {
    float _458 = _453 + _363;
    float _459 = _454 + _366;
    float _460 = _455 + _369;
    _505 = _458;
    _506 = _459;
    _507 = _460;
    _508 = cb2_025w;
  } else {
    if (_412) {
      float _463 = 1.0f - _453;
      float _464 = 1.0f - _454;
      float _465 = 1.0f - _455;
      float _466 = _463 * _363;
      float _467 = _464 * _366;
      float _468 = _465 * _369;
      float _469 = _466 + _453;
      float _470 = _467 + _454;
      float _471 = _468 + _455;
      _505 = _469;
      _506 = _470;
      _507 = _471;
      _508 = cb2_025w;
    } else {
      bool _473 = ((uint)(cb2_028x) == 4);
      if (_473) {
        float _475 = _453 * _363;
        float _476 = _454 * _366;
        float _477 = _455 * _369;
        _505 = _475;
        _506 = _476;
        _507 = _477;
        _508 = cb2_025w;
      } else {
        bool _479 = ((uint)(cb2_028x) == 5);
        if (_479) {
          float _481 = _363 * 2.0f;
          float _482 = _481 * _453;
          float _483 = _366 * 2.0f;
          float _484 = _483 * _454;
          float _485 = _369 * 2.0f;
          float _486 = _485 * _455;
          _505 = _482;
          _506 = _484;
          _507 = _486;
          _508 = cb2_025w;
        } else {
          if (_415) {
            float _489 = _363 - _453;
            float _490 = _366 - _454;
            float _491 = _369 - _455;
            _505 = _489;
            _506 = _490;
            _507 = _491;
            _508 = cb2_025w;
          } else {
            float _493 = _453 - _363;
            float _494 = _454 - _366;
            float _495 = _455 - _369;
            float _496 = _456 * _493;
            float _497 = _456 * _494;
            float _498 = _456 * _495;
            float _499 = _496 + _363;
            float _500 = _497 + _366;
            float _501 = _498 + _369;
            float _502 = 1.0f - _456;
            float _503 = _502 * cb2_025w;
            _505 = _499;
            _506 = _500;
            _507 = _501;
            _508 = _503;
          }
        }
      }
    }
  }
  float _514 = cb2_016x - _505;
  float _515 = cb2_016y - _506;
  float _516 = cb2_016z - _507;
  float _517 = _514 * cb2_016w;
  float _518 = _515 * cb2_016w;
  float _519 = _516 * cb2_016w;
  float _520 = _517 + _505;
  float _521 = _518 + _506;
  float _522 = _519 + _507;
  bool _525 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_525 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _529 = cb2_024x * _520;
    float _530 = cb2_024x * _521;
    float _531 = cb2_024x * _522;
    _533 = _529;
    _534 = _530;
    _535 = _531;
  } else {
    _533 = _520;
    _534 = _521;
    _535 = _522;
  }
  float _536 = _533 * 0.9708889722824097f;
  float _537 = mad(0.026962999254465103f, _534, _536);
  float _538 = mad(0.002148000057786703f, _535, _537);
  float _539 = _533 * 0.01088900025933981f;
  float _540 = mad(0.9869629740715027f, _534, _539);
  float _541 = mad(0.002148000057786703f, _535, _540);
  float _542 = mad(0.026962999254465103f, _534, _539);
  float _543 = mad(0.9621480107307434f, _535, _542);
  if (_525) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _548 = cb1_018y * 0.10000000149011612f;
        float _549 = log2(cb1_018z);
        float _550 = _549 + -13.287712097167969f;
        float _551 = _550 * 1.4929734468460083f;
        float _552 = _551 + 18.0f;
        float _553 = exp2(_552);
        float _554 = _553 * 0.18000000715255737f;
        float _555 = abs(_554);
        float _556 = log2(_555);
        float _557 = _556 * 1.5f;
        float _558 = exp2(_557);
        float _559 = _558 * _548;
        float _560 = _559 / cb1_018z;
        float _561 = _560 + -0.07636754959821701f;
        float _562 = _556 * 1.2750000953674316f;
        float _563 = exp2(_562);
        float _564 = _563 * 0.07636754959821701f;
        float _565 = cb1_018y * 0.011232397519052029f;
        float _566 = _565 * _558;
        float _567 = _566 / cb1_018z;
        float _568 = _564 - _567;
        float _569 = _563 + -0.11232396960258484f;
        float _570 = _569 * _548;
        float _571 = _570 / cb1_018z;
        float _572 = _571 * cb1_018z;
        float _573 = abs(_538);
        float _574 = abs(_541);
        float _575 = abs(_543);
        float _576 = log2(_573);
        float _577 = log2(_574);
        float _578 = log2(_575);
        float _579 = _576 * 1.5f;
        float _580 = _577 * 1.5f;
        float _581 = _578 * 1.5f;
        float _582 = exp2(_579);
        float _583 = exp2(_580);
        float _584 = exp2(_581);
        float _585 = _582 * _572;
        float _586 = _583 * _572;
        float _587 = _584 * _572;
        float _588 = _576 * 1.2750000953674316f;
        float _589 = _577 * 1.2750000953674316f;
        float _590 = _578 * 1.2750000953674316f;
        float _591 = exp2(_588);
        float _592 = exp2(_589);
        float _593 = exp2(_590);
        float _594 = _591 * _561;
        float _595 = _592 * _561;
        float _596 = _593 * _561;
        float _597 = _594 + _568;
        float _598 = _595 + _568;
        float _599 = _596 + _568;
        float _600 = _585 / _597;
        float _601 = _586 / _598;
        float _602 = _587 / _599;
        float _603 = _600 * 9.999999747378752e-05f;
        float _604 = _601 * 9.999999747378752e-05f;
        float _605 = _602 * 9.999999747378752e-05f;
        float _606 = 5000.0f / cb1_018y;
        float _607 = _603 * _606;
        float _608 = _604 * _606;
        float _609 = _605 * _606;
        _636 = _607;
        _637 = _608;
        _638 = _609;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_538, _541, _543));
      _636 = tonemapped.x, _637 = tonemapped.y, _638 = tonemapped.z;
    }
      } else {
        float _611 = _538 + 0.020616600289940834f;
        float _612 = _541 + 0.020616600289940834f;
        float _613 = _543 + 0.020616600289940834f;
        float _614 = _611 * _538;
        float _615 = _612 * _541;
        float _616 = _613 * _543;
        float _617 = _614 + -7.456949970219284e-05f;
        float _618 = _615 + -7.456949970219284e-05f;
        float _619 = _616 + -7.456949970219284e-05f;
        float _620 = _538 * 0.9837960004806519f;
        float _621 = _541 * 0.9837960004806519f;
        float _622 = _543 * 0.9837960004806519f;
        float _623 = _620 + 0.4336790144443512f;
        float _624 = _621 + 0.4336790144443512f;
        float _625 = _622 + 0.4336790144443512f;
        float _626 = _623 * _538;
        float _627 = _624 * _541;
        float _628 = _625 * _543;
        float _629 = _626 + 0.24617899954319f;
        float _630 = _627 + 0.24617899954319f;
        float _631 = _628 + 0.24617899954319f;
        float _632 = _617 / _629;
        float _633 = _618 / _630;
        float _634 = _619 / _631;
        _636 = _632;
        _637 = _633;
        _638 = _634;
      }
      float _639 = _636 * 1.6047500371932983f;
      float _640 = mad(-0.5310800075531006f, _637, _639);
      float _641 = mad(-0.07366999983787537f, _638, _640);
      float _642 = _636 * -0.10208000242710114f;
      float _643 = mad(1.1081299781799316f, _637, _642);
      float _644 = mad(-0.006049999967217445f, _638, _643);
      float _645 = _636 * -0.0032599999103695154f;
      float _646 = mad(-0.07275000214576721f, _637, _645);
      float _647 = mad(1.0760200023651123f, _638, _646);
      if (_525) {
        // float _649 = max(_641, 0.0f);
        // float _650 = max(_644, 0.0f);
        // float _651 = max(_647, 0.0f);
        // bool _652 = !(_649 >= 0.0030399328097701073f);
        // if (!_652) {
        //   float _654 = abs(_649);
        //   float _655 = log2(_654);
        //   float _656 = _655 * 0.4166666567325592f;
        //   float _657 = exp2(_656);
        //   float _658 = _657 * 1.0549999475479126f;
        //   float _659 = _658 + -0.054999999701976776f;
        //   _663 = _659;
        // } else {
        //   float _661 = _649 * 12.923210144042969f;
        //   _663 = _661;
        // }
        // bool _664 = !(_650 >= 0.0030399328097701073f);
        // if (!_664) {
        //   float _666 = abs(_650);
        //   float _667 = log2(_666);
        //   float _668 = _667 * 0.4166666567325592f;
        //   float _669 = exp2(_668);
        //   float _670 = _669 * 1.0549999475479126f;
        //   float _671 = _670 + -0.054999999701976776f;
        //   _675 = _671;
        // } else {
        //   float _673 = _650 * 12.923210144042969f;
        //   _675 = _673;
        // }
        // bool _676 = !(_651 >= 0.0030399328097701073f);
        // if (!_676) {
        //   float _678 = abs(_651);
        //   float _679 = log2(_678);
        //   float _680 = _679 * 0.4166666567325592f;
        //   float _681 = exp2(_680);
        //   float _682 = _681 * 1.0549999475479126f;
        //   float _683 = _682 + -0.054999999701976776f;
        //   _756 = _663;
        //   _757 = _675;
        //   _758 = _683;
        // } else {
        //   float _685 = _651 * 12.923210144042969f;
        //   _756 = _663;
        //   _757 = _675;
        //   _758 = _685;
        // }
        _756 = renodx::color::srgb::EncodeSafe(_641);
        _757 = renodx::color::srgb::EncodeSafe(_644);
        _758 = renodx::color::srgb::EncodeSafe(_647);

      } else {
        float _687 = saturate(_641);
        float _688 = saturate(_644);
        float _689 = saturate(_647);
        bool _690 = ((uint)(cb1_018w) == -2);
        if (!_690) {
          bool _692 = !(_687 >= 0.0030399328097701073f);
          if (!_692) {
            float _694 = abs(_687);
            float _695 = log2(_694);
            float _696 = _695 * 0.4166666567325592f;
            float _697 = exp2(_696);
            float _698 = _697 * 1.0549999475479126f;
            float _699 = _698 + -0.054999999701976776f;
            _703 = _699;
          } else {
            float _701 = _687 * 12.923210144042969f;
            _703 = _701;
          }
          bool _704 = !(_688 >= 0.0030399328097701073f);
          if (!_704) {
            float _706 = abs(_688);
            float _707 = log2(_706);
            float _708 = _707 * 0.4166666567325592f;
            float _709 = exp2(_708);
            float _710 = _709 * 1.0549999475479126f;
            float _711 = _710 + -0.054999999701976776f;
            _715 = _711;
          } else {
            float _713 = _688 * 12.923210144042969f;
            _715 = _713;
          }
          bool _716 = !(_689 >= 0.0030399328097701073f);
          if (!_716) {
            float _718 = abs(_689);
            float _719 = log2(_718);
            float _720 = _719 * 0.4166666567325592f;
            float _721 = exp2(_720);
            float _722 = _721 * 1.0549999475479126f;
            float _723 = _722 + -0.054999999701976776f;
            _727 = _703;
            _728 = _715;
            _729 = _723;
          } else {
            float _725 = _689 * 12.923210144042969f;
            _727 = _703;
            _728 = _715;
            _729 = _725;
          }
        } else {
          _727 = _687;
          _728 = _688;
          _729 = _689;
        }
        float _734 = abs(_727);
        float _735 = abs(_728);
        float _736 = abs(_729);
        float _737 = log2(_734);
        float _738 = log2(_735);
        float _739 = log2(_736);
        float _740 = _737 * cb2_000z;
        float _741 = _738 * cb2_000z;
        float _742 = _739 * cb2_000z;
        float _743 = exp2(_740);
        float _744 = exp2(_741);
        float _745 = exp2(_742);
        float _746 = _743 * cb2_000y;
        float _747 = _744 * cb2_000y;
        float _748 = _745 * cb2_000y;
        float _749 = _746 + cb2_000x;
        float _750 = _747 + cb2_000x;
        float _751 = _748 + cb2_000x;
        float _752 = saturate(_749);
        float _753 = saturate(_750);
        float _754 = saturate(_751);
        _756 = _752;
        _757 = _753;
        _758 = _754;
      }
      float _762 = cb2_023x * TEXCOORD0_centroid.x;
      float _763 = cb2_023y * TEXCOORD0_centroid.y;
      float _766 = _762 + cb2_023z;
      float _767 = _763 + cb2_023w;
      float4 _770 = t10.SampleLevel(s0_space2, float2(_766, _767), 0.0f);
      float _772 = _770.x + -0.5f;
      float _773 = _772 * cb2_022x;
      float _774 = _773 + 0.5f;
      float _775 = _774 * 2.0f;
      float _776 = _775 * _756;
      float _777 = _775 * _757;
      float _778 = _775 * _758;
      float _782 = float((uint)(cb2_019z));
      float _783 = float((uint)(cb2_019w));
      float _784 = _782 + SV_Position.x;
      float _785 = _783 + SV_Position.y;
      uint _786 = uint(_784);
      uint _787 = uint(_785);
      uint _790 = cb2_019x + -1u;
      uint _791 = cb2_019y + -1u;
      int _792 = _786 & _790;
      int _793 = _787 & _791;
      float4 _794 = t3.Load(int3(_792, _793, 0));
      float _798 = _794.x * 2.0f;
      float _799 = _794.y * 2.0f;
      float _800 = _794.z * 2.0f;
      float _801 = _798 + -1.0f;
      float _802 = _799 + -1.0f;
      float _803 = _800 + -1.0f;
      float _804 = _801 * _508;
      float _805 = _802 * _508;
      float _806 = _803 * _508;
      float _807 = _804 + _776;
      float _808 = _805 + _777;
      float _809 = _806 + _778;
      float _810 = dot(float3(_807, _808, _809), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _807;
      SV_Target.y = _808;
      SV_Target.z = _809;
      SV_Target.w = _810;
      SV_Target_1.x = _810;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
