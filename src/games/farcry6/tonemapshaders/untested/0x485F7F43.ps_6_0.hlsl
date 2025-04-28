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
  float _395;
  float _396;
  float _397;
  float _442;
  float _443;
  float _444;
  float _445;
  float _494;
  float _495;
  float _496;
  float _497;
  float _522;
  float _523;
  float _524;
  float _625;
  float _626;
  float _627;
  float _652;
  float _664;
  float _692;
  float _704;
  float _716;
  float _717;
  float _718;
  float _745;
  float _746;
  float _747;
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
  float _363 = cb2_004x * TEXCOORD0_centroid.x;
  float _364 = cb2_004y * TEXCOORD0_centroid.y;
  float _367 = _363 + cb2_004z;
  float _368 = _364 + cb2_004w;
  float4 _374 = t7.Sample(s2_space2, float2(_367, _368));
  float _379 = _374.x * cb2_003x;
  float _380 = _374.y * cb2_003y;
  float _381 = _374.z * cb2_003z;
  float _382 = _374.w * cb2_003w;
  float _385 = _382 + cb2_026y;
  float _386 = saturate(_385);
  bool _389 = ((uint)(cb2_069y) == 0);
  if (!_389) {
    float _391 = _379 * _282;
    float _392 = _380 * _282;
    float _393 = _381 * _282;
    _395 = _391;
    _396 = _392;
    _397 = _393;
  } else {
    _395 = _379;
    _396 = _380;
    _397 = _381;
  }
  bool _400 = ((uint)(cb2_028x) == 2);
  bool _401 = ((uint)(cb2_028x) == 3);
  int _402 = (uint)(cb2_028x) & -2;
  bool _403 = (_402 == 2);
  bool _404 = ((uint)(cb2_028x) == 6);
  bool _405 = _403 || _404;
  if (_405) {
    float _407 = _395 * _386;
    float _408 = _396 * _386;
    float _409 = _397 * _386;
    float _410 = _386 * _386;
    _442 = _407;
    _443 = _408;
    _444 = _409;
    _445 = _410;
  } else {
    bool _412 = ((uint)(cb2_028x) == 4);
    if (_412) {
      float _414 = _395 + -1.0f;
      float _415 = _396 + -1.0f;
      float _416 = _397 + -1.0f;
      float _417 = _386 + -1.0f;
      float _418 = _414 * _386;
      float _419 = _415 * _386;
      float _420 = _416 * _386;
      float _421 = _417 * _386;
      float _422 = _418 + 1.0f;
      float _423 = _419 + 1.0f;
      float _424 = _420 + 1.0f;
      float _425 = _421 + 1.0f;
      _442 = _422;
      _443 = _423;
      _444 = _424;
      _445 = _425;
    } else {
      bool _427 = ((uint)(cb2_028x) == 5);
      if (_427) {
        float _429 = _395 + -0.5f;
        float _430 = _396 + -0.5f;
        float _431 = _397 + -0.5f;
        float _432 = _386 + -0.5f;
        float _433 = _429 * _386;
        float _434 = _430 * _386;
        float _435 = _431 * _386;
        float _436 = _432 * _386;
        float _437 = _433 + 0.5f;
        float _438 = _434 + 0.5f;
        float _439 = _435 + 0.5f;
        float _440 = _436 + 0.5f;
        _442 = _437;
        _443 = _438;
        _444 = _439;
        _445 = _440;
      } else {
        _442 = _395;
        _443 = _396;
        _444 = _397;
        _445 = _386;
      }
    }
  }
  if (_400) {
    float _447 = _442 + _352;
    float _448 = _443 + _355;
    float _449 = _444 + _358;
    _494 = _447;
    _495 = _448;
    _496 = _449;
    _497 = cb2_025w;
  } else {
    if (_401) {
      float _452 = 1.0f - _442;
      float _453 = 1.0f - _443;
      float _454 = 1.0f - _444;
      float _455 = _452 * _352;
      float _456 = _453 * _355;
      float _457 = _454 * _358;
      float _458 = _455 + _442;
      float _459 = _456 + _443;
      float _460 = _457 + _444;
      _494 = _458;
      _495 = _459;
      _496 = _460;
      _497 = cb2_025w;
    } else {
      bool _462 = ((uint)(cb2_028x) == 4);
      if (_462) {
        float _464 = _442 * _352;
        float _465 = _443 * _355;
        float _466 = _444 * _358;
        _494 = _464;
        _495 = _465;
        _496 = _466;
        _497 = cb2_025w;
      } else {
        bool _468 = ((uint)(cb2_028x) == 5);
        if (_468) {
          float _470 = _352 * 2.0f;
          float _471 = _470 * _442;
          float _472 = _355 * 2.0f;
          float _473 = _472 * _443;
          float _474 = _358 * 2.0f;
          float _475 = _474 * _444;
          _494 = _471;
          _495 = _473;
          _496 = _475;
          _497 = cb2_025w;
        } else {
          if (_404) {
            float _478 = _352 - _442;
            float _479 = _355 - _443;
            float _480 = _358 - _444;
            _494 = _478;
            _495 = _479;
            _496 = _480;
            _497 = cb2_025w;
          } else {
            float _482 = _442 - _352;
            float _483 = _443 - _355;
            float _484 = _444 - _358;
            float _485 = _445 * _482;
            float _486 = _445 * _483;
            float _487 = _445 * _484;
            float _488 = _485 + _352;
            float _489 = _486 + _355;
            float _490 = _487 + _358;
            float _491 = 1.0f - _445;
            float _492 = _491 * cb2_025w;
            _494 = _488;
            _495 = _489;
            _496 = _490;
            _497 = _492;
          }
        }
      }
    }
  }
  float _503 = cb2_016x - _494;
  float _504 = cb2_016y - _495;
  float _505 = cb2_016z - _496;
  float _506 = _503 * cb2_016w;
  float _507 = _504 * cb2_016w;
  float _508 = _505 * cb2_016w;
  float _509 = _506 + _494;
  float _510 = _507 + _495;
  float _511 = _508 + _496;
  bool _514 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_514 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _518 = cb2_024x * _509;
    float _519 = cb2_024x * _510;
    float _520 = cb2_024x * _511;
    _522 = _518;
    _523 = _519;
    _524 = _520;
  } else {
    _522 = _509;
    _523 = _510;
    _524 = _511;
  }
  float _525 = _522 * 0.9708889722824097f;
  float _526 = mad(0.026962999254465103f, _523, _525);
  float _527 = mad(0.002148000057786703f, _524, _526);
  float _528 = _522 * 0.01088900025933981f;
  float _529 = mad(0.9869629740715027f, _523, _528);
  float _530 = mad(0.002148000057786703f, _524, _529);
  float _531 = mad(0.026962999254465103f, _523, _528);
  float _532 = mad(0.9621480107307434f, _524, _531);
  if (_514) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _537 = cb1_018y * 0.10000000149011612f;
        float _538 = log2(cb1_018z);
        float _539 = _538 + -13.287712097167969f;
        float _540 = _539 * 1.4929734468460083f;
        float _541 = _540 + 18.0f;
        float _542 = exp2(_541);
        float _543 = _542 * 0.18000000715255737f;
        float _544 = abs(_543);
        float _545 = log2(_544);
        float _546 = _545 * 1.5f;
        float _547 = exp2(_546);
        float _548 = _547 * _537;
        float _549 = _548 / cb1_018z;
        float _550 = _549 + -0.07636754959821701f;
        float _551 = _545 * 1.2750000953674316f;
        float _552 = exp2(_551);
        float _553 = _552 * 0.07636754959821701f;
        float _554 = cb1_018y * 0.011232397519052029f;
        float _555 = _554 * _547;
        float _556 = _555 / cb1_018z;
        float _557 = _553 - _556;
        float _558 = _552 + -0.11232396960258484f;
        float _559 = _558 * _537;
        float _560 = _559 / cb1_018z;
        float _561 = _560 * cb1_018z;
        float _562 = abs(_527);
        float _563 = abs(_530);
        float _564 = abs(_532);
        float _565 = log2(_562);
        float _566 = log2(_563);
        float _567 = log2(_564);
        float _568 = _565 * 1.5f;
        float _569 = _566 * 1.5f;
        float _570 = _567 * 1.5f;
        float _571 = exp2(_568);
        float _572 = exp2(_569);
        float _573 = exp2(_570);
        float _574 = _571 * _561;
        float _575 = _572 * _561;
        float _576 = _573 * _561;
        float _577 = _565 * 1.2750000953674316f;
        float _578 = _566 * 1.2750000953674316f;
        float _579 = _567 * 1.2750000953674316f;
        float _580 = exp2(_577);
        float _581 = exp2(_578);
        float _582 = exp2(_579);
        float _583 = _580 * _550;
        float _584 = _581 * _550;
        float _585 = _582 * _550;
        float _586 = _583 + _557;
        float _587 = _584 + _557;
        float _588 = _585 + _557;
        float _589 = _574 / _586;
        float _590 = _575 / _587;
        float _591 = _576 / _588;
        float _592 = _589 * 9.999999747378752e-05f;
        float _593 = _590 * 9.999999747378752e-05f;
        float _594 = _591 * 9.999999747378752e-05f;
        float _595 = 5000.0f / cb1_018y;
        float _596 = _592 * _595;
        float _597 = _593 * _595;
        float _598 = _594 * _595;
        _625 = _596;
        _626 = _597;
        _627 = _598;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_527, _530, _532));
      _625 = tonemapped.x, _626 = tonemapped.y, _627 = tonemapped.z;
    }
      } else {
        float _600 = _527 + 0.020616600289940834f;
        float _601 = _530 + 0.020616600289940834f;
        float _602 = _532 + 0.020616600289940834f;
        float _603 = _600 * _527;
        float _604 = _601 * _530;
        float _605 = _602 * _532;
        float _606 = _603 + -7.456949970219284e-05f;
        float _607 = _604 + -7.456949970219284e-05f;
        float _608 = _605 + -7.456949970219284e-05f;
        float _609 = _527 * 0.9837960004806519f;
        float _610 = _530 * 0.9837960004806519f;
        float _611 = _532 * 0.9837960004806519f;
        float _612 = _609 + 0.4336790144443512f;
        float _613 = _610 + 0.4336790144443512f;
        float _614 = _611 + 0.4336790144443512f;
        float _615 = _612 * _527;
        float _616 = _613 * _530;
        float _617 = _614 * _532;
        float _618 = _615 + 0.24617899954319f;
        float _619 = _616 + 0.24617899954319f;
        float _620 = _617 + 0.24617899954319f;
        float _621 = _606 / _618;
        float _622 = _607 / _619;
        float _623 = _608 / _620;
        _625 = _621;
        _626 = _622;
        _627 = _623;
      }
      float _628 = _625 * 1.6047500371932983f;
      float _629 = mad(-0.5310800075531006f, _626, _628);
      float _630 = mad(-0.07366999983787537f, _627, _629);
      float _631 = _625 * -0.10208000242710114f;
      float _632 = mad(1.1081299781799316f, _626, _631);
      float _633 = mad(-0.006049999967217445f, _627, _632);
      float _634 = _625 * -0.0032599999103695154f;
      float _635 = mad(-0.07275000214576721f, _626, _634);
      float _636 = mad(1.0760200023651123f, _627, _635);
      if (_514) {
        // float _638 = max(_630, 0.0f);
        // float _639 = max(_633, 0.0f);
        // float _640 = max(_636, 0.0f);
        // bool _641 = !(_638 >= 0.0030399328097701073f);
        // if (!_641) {
        //   float _643 = abs(_638);
        //   float _644 = log2(_643);
        //   float _645 = _644 * 0.4166666567325592f;
        //   float _646 = exp2(_645);
        //   float _647 = _646 * 1.0549999475479126f;
        //   float _648 = _647 + -0.054999999701976776f;
        //   _652 = _648;
        // } else {
        //   float _650 = _638 * 12.923210144042969f;
        //   _652 = _650;
        // }
        // bool _653 = !(_639 >= 0.0030399328097701073f);
        // if (!_653) {
        //   float _655 = abs(_639);
        //   float _656 = log2(_655);
        //   float _657 = _656 * 0.4166666567325592f;
        //   float _658 = exp2(_657);
        //   float _659 = _658 * 1.0549999475479126f;
        //   float _660 = _659 + -0.054999999701976776f;
        //   _664 = _660;
        // } else {
        //   float _662 = _639 * 12.923210144042969f;
        //   _664 = _662;
        // }
        // bool _665 = !(_640 >= 0.0030399328097701073f);
        // if (!_665) {
        //   float _667 = abs(_640);
        //   float _668 = log2(_667);
        //   float _669 = _668 * 0.4166666567325592f;
        //   float _670 = exp2(_669);
        //   float _671 = _670 * 1.0549999475479126f;
        //   float _672 = _671 + -0.054999999701976776f;
        //   _745 = _652;
        //   _746 = _664;
        //   _747 = _672;
        // } else {
        //   float _674 = _640 * 12.923210144042969f;
        //   _745 = _652;
        //   _746 = _664;
        //   _747 = _674;
        // }
        _745 = renodx::color::srgb::EncodeSafe(_630);
        _746 = renodx::color::srgb::EncodeSafe(_633);
        _747 = renodx::color::srgb::EncodeSafe(_636);

      } else {
        float _676 = saturate(_630);
        float _677 = saturate(_633);
        float _678 = saturate(_636);
        bool _679 = ((uint)(cb1_018w) == -2);
        if (!_679) {
          bool _681 = !(_676 >= 0.0030399328097701073f);
          if (!_681) {
            float _683 = abs(_676);
            float _684 = log2(_683);
            float _685 = _684 * 0.4166666567325592f;
            float _686 = exp2(_685);
            float _687 = _686 * 1.0549999475479126f;
            float _688 = _687 + -0.054999999701976776f;
            _692 = _688;
          } else {
            float _690 = _676 * 12.923210144042969f;
            _692 = _690;
          }
          bool _693 = !(_677 >= 0.0030399328097701073f);
          if (!_693) {
            float _695 = abs(_677);
            float _696 = log2(_695);
            float _697 = _696 * 0.4166666567325592f;
            float _698 = exp2(_697);
            float _699 = _698 * 1.0549999475479126f;
            float _700 = _699 + -0.054999999701976776f;
            _704 = _700;
          } else {
            float _702 = _677 * 12.923210144042969f;
            _704 = _702;
          }
          bool _705 = !(_678 >= 0.0030399328097701073f);
          if (!_705) {
            float _707 = abs(_678);
            float _708 = log2(_707);
            float _709 = _708 * 0.4166666567325592f;
            float _710 = exp2(_709);
            float _711 = _710 * 1.0549999475479126f;
            float _712 = _711 + -0.054999999701976776f;
            _716 = _692;
            _717 = _704;
            _718 = _712;
          } else {
            float _714 = _678 * 12.923210144042969f;
            _716 = _692;
            _717 = _704;
            _718 = _714;
          }
        } else {
          _716 = _676;
          _717 = _677;
          _718 = _678;
        }
        float _723 = abs(_716);
        float _724 = abs(_717);
        float _725 = abs(_718);
        float _726 = log2(_723);
        float _727 = log2(_724);
        float _728 = log2(_725);
        float _729 = _726 * cb2_000z;
        float _730 = _727 * cb2_000z;
        float _731 = _728 * cb2_000z;
        float _732 = exp2(_729);
        float _733 = exp2(_730);
        float _734 = exp2(_731);
        float _735 = _732 * cb2_000y;
        float _736 = _733 * cb2_000y;
        float _737 = _734 * cb2_000y;
        float _738 = _735 + cb2_000x;
        float _739 = _736 + cb2_000x;
        float _740 = _737 + cb2_000x;
        float _741 = saturate(_738);
        float _742 = saturate(_739);
        float _743 = saturate(_740);
        _745 = _741;
        _746 = _742;
        _747 = _743;
      }
      float _751 = cb2_023x * TEXCOORD0_centroid.x;
      float _752 = cb2_023y * TEXCOORD0_centroid.y;
      float _755 = _751 + cb2_023z;
      float _756 = _752 + cb2_023w;
      float4 _759 = t11.SampleLevel(s0_space2, float2(_755, _756), 0.0f);
      float _761 = _759.x + -0.5f;
      float _762 = _761 * cb2_022x;
      float _763 = _762 + 0.5f;
      float _764 = _763 * 2.0f;
      float _765 = _764 * _745;
      float _766 = _764 * _746;
      float _767 = _764 * _747;
      float _771 = float((uint)(cb2_019z));
      float _772 = float((uint)(cb2_019w));
      float _773 = _771 + SV_Position.x;
      float _774 = _772 + SV_Position.y;
      uint _775 = uint(_773);
      uint _776 = uint(_774);
      uint _779 = cb2_019x + -1u;
      uint _780 = cb2_019y + -1u;
      int _781 = _775 & _779;
      int _782 = _776 & _780;
      float4 _783 = t3.Load(int3(_781, _782, 0));
      float _787 = _783.x * 2.0f;
      float _788 = _783.y * 2.0f;
      float _789 = _783.z * 2.0f;
      float _790 = _787 + -1.0f;
      float _791 = _788 + -1.0f;
      float _792 = _789 + -1.0f;
      float _793 = _790 * _497;
      float _794 = _791 * _497;
      float _795 = _792 * _497;
      float _796 = _793 + _765;
      float _797 = _794 + _766;
      float _798 = _795 + _767;
      float _799 = dot(float3(_796, _797, _798), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _796;
      SV_Target.y = _797;
      SV_Target.z = _798;
      SV_Target.w = _799;
      SV_Target_1.x = _799;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
