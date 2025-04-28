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
  float4 _93 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _97 = _75 - _63;
  float _98 = _76 - _64;
  float _99 = _77 - _65;
  float _100 = _92 * _97;
  float _101 = _92 * _98;
  float _102 = _92 * _99;
  float _103 = _100 + _63;
  float _104 = _101 + _64;
  float _105 = _102 + _65;
  float _106 = dot(float3(_103, _104, _105), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _110 = t0[0].SExposureData_020;
  float _112 = t0[0].SExposureData_004;
  float _114 = cb2_018x * 0.5f;
  float _115 = _114 * cb2_018y;
  float _116 = _112.x - _115;
  float _117 = cb2_018y * cb2_018x;
  float _118 = 1.0f / _117;
  float _119 = _116 * _118;
  float _120 = _106 / _110.x;
  float _121 = _120 * 5464.01611328125f;
  float _122 = _121 + 9.99999993922529e-09f;
  float _123 = log2(_122);
  float _124 = _123 - _116;
  float _125 = _124 * _118;
  float _126 = saturate(_125);
  float2 _127 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _126), 0.0f);
  float _130 = max(_127.y, 1.0000000116860974e-07f);
  float _131 = _127.x / _130;
  float _132 = _131 + _119;
  float _133 = _132 / _118;
  float _134 = _133 - _112.x;
  float _135 = -0.0f - _134;
  float _137 = _135 - cb2_027x;
  float _138 = max(0.0f, _137);
  float _140 = cb2_026z * _138;
  float _141 = _134 - cb2_027x;
  float _142 = max(0.0f, _141);
  float _144 = cb2_026w * _142;
  bool _145 = (_134 < 0.0f);
  float _146 = select(_145, _140, _144);
  float _147 = exp2(_146);
  float _148 = _147 * _103;
  float _149 = _147 * _104;
  float _150 = _147 * _105;
  float _155 = cb2_024y * _93.x;
  float _156 = cb2_024z * _93.y;
  float _157 = cb2_024w * _93.z;
  float _158 = _155 + _148;
  float _159 = _156 + _149;
  float _160 = _157 + _150;
  float _165 = _158 * cb2_025x;
  float _166 = _159 * cb2_025y;
  float _167 = _160 * cb2_025z;
  float _168 = dot(float3(_165, _166, _167), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _169 = t0[0].SExposureData_012;
  float _171 = _168 * 5464.01611328125f;
  float _172 = _171 * _169.x;
  float _173 = _172 + 9.99999993922529e-09f;
  float _174 = log2(_173);
  float _175 = _174 + 16.929765701293945f;
  float _176 = _175 * 0.05734497308731079f;
  float _177 = saturate(_176);
  float _178 = _177 * _177;
  float _179 = _177 * 2.0f;
  float _180 = 3.0f - _179;
  float _181 = _178 * _180;
  float _182 = _166 * 0.8450999855995178f;
  float _183 = _167 * 0.14589999616146088f;
  float _184 = _182 + _183;
  float _185 = _184 * 2.4890189170837402f;
  float _186 = _184 * 0.3754962384700775f;
  float _187 = _184 * 2.811495304107666f;
  float _188 = _184 * 5.519708156585693f;
  float _189 = _168 - _185;
  float _190 = _181 * _189;
  float _191 = _190 + _185;
  float _192 = _181 * 0.5f;
  float _193 = _192 + 0.5f;
  float _194 = _193 * _189;
  float _195 = _194 + _185;
  float _196 = _165 - _186;
  float _197 = _166 - _187;
  float _198 = _167 - _188;
  float _199 = _193 * _196;
  float _200 = _193 * _197;
  float _201 = _193 * _198;
  float _202 = _199 + _186;
  float _203 = _200 + _187;
  float _204 = _201 + _188;
  float _205 = 1.0f / _195;
  float _206 = _191 * _205;
  float _207 = _206 * _202;
  float _208 = _206 * _203;
  float _209 = _206 * _204;
  float _213 = cb2_020x * TEXCOORD0_centroid.x;
  float _214 = cb2_020y * TEXCOORD0_centroid.y;
  float _217 = _213 + cb2_020z;
  float _218 = _214 + cb2_020w;
  float _221 = dot(float2(_217, _218), float2(_217, _218));
  float _222 = 1.0f - _221;
  float _223 = saturate(_222);
  float _224 = log2(_223);
  float _225 = _224 * cb2_021w;
  float _226 = exp2(_225);
  float _230 = _207 - cb2_021x;
  float _231 = _208 - cb2_021y;
  float _232 = _209 - cb2_021z;
  float _233 = _230 * _226;
  float _234 = _231 * _226;
  float _235 = _232 * _226;
  float _236 = _233 + cb2_021x;
  float _237 = _234 + cb2_021y;
  float _238 = _235 + cb2_021z;
  float _239 = t0[0].SExposureData_000;
  float _241 = max(_110.x, 0.0010000000474974513f);
  float _242 = 1.0f / _241;
  float _243 = _242 * _239.x;
  bool _246 = ((uint)(cb2_069y) == 0);
  float _252;
  float _253;
  float _254;
  float _308;
  float _309;
  float _310;
  float _401;
  float _402;
  float _403;
  float _448;
  float _449;
  float _450;
  float _451;
  float _500;
  float _501;
  float _502;
  float _503;
  float _528;
  float _529;
  float _530;
  float _631;
  float _632;
  float _633;
  float _658;
  float _670;
  float _698;
  float _710;
  float _722;
  float _723;
  float _724;
  float _751;
  float _752;
  float _753;
  if (!_246) {
    float _248 = _243 * _236;
    float _249 = _243 * _237;
    float _250 = _243 * _238;
    _252 = _248;
    _253 = _249;
    _254 = _250;
  } else {
    _252 = _236;
    _253 = _237;
    _254 = _238;
  }
  float _255 = _252 * 0.6130970120429993f;
  float _256 = mad(0.33952298760414124f, _253, _255);
  float _257 = mad(0.04737899824976921f, _254, _256);
  float _258 = _252 * 0.07019399851560593f;
  float _259 = mad(0.9163540005683899f, _253, _258);
  float _260 = mad(0.013451999984681606f, _254, _259);
  float _261 = _252 * 0.02061600051820278f;
  float _262 = mad(0.10956999659538269f, _253, _261);
  float _263 = mad(0.8698149919509888f, _254, _262);
  float _264 = log2(_257);
  float _265 = log2(_260);
  float _266 = log2(_263);
  float _267 = _264 * 0.04211956635117531f;
  float _268 = _265 * 0.04211956635117531f;
  float _269 = _266 * 0.04211956635117531f;
  float _270 = _267 + 0.6252607107162476f;
  float _271 = _268 + 0.6252607107162476f;
  float _272 = _269 + 0.6252607107162476f;
  float4 _273 = t6.SampleLevel(s2_space2, float3(_270, _271, _272), 0.0f);
  bool _279 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_279 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _283 = cb2_017x * _273.x;
    float _284 = cb2_017x * _273.y;
    float _285 = cb2_017x * _273.z;
    float _287 = _283 + cb2_017y;
    float _288 = _284 + cb2_017y;
    float _289 = _285 + cb2_017y;
    float _290 = exp2(_287);
    float _291 = exp2(_288);
    float _292 = exp2(_289);
    float _293 = _290 + 1.0f;
    float _294 = _291 + 1.0f;
    float _295 = _292 + 1.0f;
    float _296 = 1.0f / _293;
    float _297 = 1.0f / _294;
    float _298 = 1.0f / _295;
    float _300 = cb2_017z * _296;
    float _301 = cb2_017z * _297;
    float _302 = cb2_017z * _298;
    float _304 = _300 + cb2_017w;
    float _305 = _301 + cb2_017w;
    float _306 = _302 + cb2_017w;
    _308 = _304;
    _309 = _305;
    _310 = _306;
  } else {
    _308 = _273.x;
    _309 = _273.y;
    _310 = _273.z;
  }
  float _311 = _308 * 23.0f;
  float _312 = _311 + -14.473931312561035f;
  float _313 = exp2(_312);
  float _314 = _309 * 23.0f;
  float _315 = _314 + -14.473931312561035f;
  float _316 = exp2(_315);
  float _317 = _310 * 23.0f;
  float _318 = _317 + -14.473931312561035f;
  float _319 = exp2(_318);
  float _320 = dot(float3(_313, _316, _319), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _325 = dot(float3(_313, _316, _319), float3(_313, _316, _319));
  float _326 = rsqrt(_325);
  float _327 = _326 * _313;
  float _328 = _326 * _316;
  float _329 = _326 * _319;
  float _330 = cb2_001x - _327;
  float _331 = cb2_001y - _328;
  float _332 = cb2_001z - _329;
  float _333 = dot(float3(_330, _331, _332), float3(_330, _331, _332));
  float _336 = cb2_002z * _333;
  float _338 = _336 + cb2_002w;
  float _339 = saturate(_338);
  float _341 = cb2_002x * _339;
  float _342 = _320 - _313;
  float _343 = _320 - _316;
  float _344 = _320 - _319;
  float _345 = _341 * _342;
  float _346 = _341 * _343;
  float _347 = _341 * _344;
  float _348 = _345 + _313;
  float _349 = _346 + _316;
  float _350 = _347 + _319;
  float _352 = cb2_002y * _339;
  float _353 = 0.10000000149011612f - _348;
  float _354 = 0.10000000149011612f - _349;
  float _355 = 0.10000000149011612f - _350;
  float _356 = _353 * _352;
  float _357 = _354 * _352;
  float _358 = _355 * _352;
  float _359 = _356 + _348;
  float _360 = _357 + _349;
  float _361 = _358 + _350;
  float _362 = saturate(_359);
  float _363 = saturate(_360);
  float _364 = saturate(_361);
  float _369 = cb2_004x * TEXCOORD0_centroid.x;
  float _370 = cb2_004y * TEXCOORD0_centroid.y;
  float _373 = _369 + cb2_004z;
  float _374 = _370 + cb2_004w;
  float4 _380 = t7.Sample(s2_space2, float2(_373, _374));
  float _385 = _380.x * cb2_003x;
  float _386 = _380.y * cb2_003y;
  float _387 = _380.z * cb2_003z;
  float _388 = _380.w * cb2_003w;
  float _391 = _388 + cb2_026y;
  float _392 = saturate(_391);
  bool _395 = ((uint)(cb2_069y) == 0);
  if (!_395) {
    float _397 = _385 * _243;
    float _398 = _386 * _243;
    float _399 = _387 * _243;
    _401 = _397;
    _402 = _398;
    _403 = _399;
  } else {
    _401 = _385;
    _402 = _386;
    _403 = _387;
  }
  bool _406 = ((uint)(cb2_028x) == 2);
  bool _407 = ((uint)(cb2_028x) == 3);
  int _408 = (uint)(cb2_028x) & -2;
  bool _409 = (_408 == 2);
  bool _410 = ((uint)(cb2_028x) == 6);
  bool _411 = _409 || _410;
  if (_411) {
    float _413 = _401 * _392;
    float _414 = _402 * _392;
    float _415 = _403 * _392;
    float _416 = _392 * _392;
    _448 = _413;
    _449 = _414;
    _450 = _415;
    _451 = _416;
  } else {
    bool _418 = ((uint)(cb2_028x) == 4);
    if (_418) {
      float _420 = _401 + -1.0f;
      float _421 = _402 + -1.0f;
      float _422 = _403 + -1.0f;
      float _423 = _392 + -1.0f;
      float _424 = _420 * _392;
      float _425 = _421 * _392;
      float _426 = _422 * _392;
      float _427 = _423 * _392;
      float _428 = _424 + 1.0f;
      float _429 = _425 + 1.0f;
      float _430 = _426 + 1.0f;
      float _431 = _427 + 1.0f;
      _448 = _428;
      _449 = _429;
      _450 = _430;
      _451 = _431;
    } else {
      bool _433 = ((uint)(cb2_028x) == 5);
      if (_433) {
        float _435 = _401 + -0.5f;
        float _436 = _402 + -0.5f;
        float _437 = _403 + -0.5f;
        float _438 = _392 + -0.5f;
        float _439 = _435 * _392;
        float _440 = _436 * _392;
        float _441 = _437 * _392;
        float _442 = _438 * _392;
        float _443 = _439 + 0.5f;
        float _444 = _440 + 0.5f;
        float _445 = _441 + 0.5f;
        float _446 = _442 + 0.5f;
        _448 = _443;
        _449 = _444;
        _450 = _445;
        _451 = _446;
      } else {
        _448 = _401;
        _449 = _402;
        _450 = _403;
        _451 = _392;
      }
    }
  }
  if (_406) {
    float _453 = _448 + _362;
    float _454 = _449 + _363;
    float _455 = _450 + _364;
    _500 = _453;
    _501 = _454;
    _502 = _455;
    _503 = cb2_025w;
  } else {
    if (_407) {
      float _458 = 1.0f - _448;
      float _459 = 1.0f - _449;
      float _460 = 1.0f - _450;
      float _461 = _458 * _362;
      float _462 = _459 * _363;
      float _463 = _460 * _364;
      float _464 = _461 + _448;
      float _465 = _462 + _449;
      float _466 = _463 + _450;
      _500 = _464;
      _501 = _465;
      _502 = _466;
      _503 = cb2_025w;
    } else {
      bool _468 = ((uint)(cb2_028x) == 4);
      if (_468) {
        float _470 = _448 * _362;
        float _471 = _449 * _363;
        float _472 = _450 * _364;
        _500 = _470;
        _501 = _471;
        _502 = _472;
        _503 = cb2_025w;
      } else {
        bool _474 = ((uint)(cb2_028x) == 5);
        if (_474) {
          float _476 = _362 * 2.0f;
          float _477 = _476 * _448;
          float _478 = _363 * 2.0f;
          float _479 = _478 * _449;
          float _480 = _364 * 2.0f;
          float _481 = _480 * _450;
          _500 = _477;
          _501 = _479;
          _502 = _481;
          _503 = cb2_025w;
        } else {
          if (_410) {
            float _484 = _362 - _448;
            float _485 = _363 - _449;
            float _486 = _364 - _450;
            _500 = _484;
            _501 = _485;
            _502 = _486;
            _503 = cb2_025w;
          } else {
            float _488 = _448 - _362;
            float _489 = _449 - _363;
            float _490 = _450 - _364;
            float _491 = _451 * _488;
            float _492 = _451 * _489;
            float _493 = _451 * _490;
            float _494 = _491 + _362;
            float _495 = _492 + _363;
            float _496 = _493 + _364;
            float _497 = 1.0f - _451;
            float _498 = _497 * cb2_025w;
            _500 = _494;
            _501 = _495;
            _502 = _496;
            _503 = _498;
          }
        }
      }
    }
  }
  float _509 = cb2_016x - _500;
  float _510 = cb2_016y - _501;
  float _511 = cb2_016z - _502;
  float _512 = _509 * cb2_016w;
  float _513 = _510 * cb2_016w;
  float _514 = _511 * cb2_016w;
  float _515 = _512 + _500;
  float _516 = _513 + _501;
  float _517 = _514 + _502;
  bool _520 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_520 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _524 = cb2_024x * _515;
    float _525 = cb2_024x * _516;
    float _526 = cb2_024x * _517;
    _528 = _524;
    _529 = _525;
    _530 = _526;
  } else {
    _528 = _515;
    _529 = _516;
    _530 = _517;
  }
  float _531 = _528 * 0.9708889722824097f;
  float _532 = mad(0.026962999254465103f, _529, _531);
  float _533 = mad(0.002148000057786703f, _530, _532);
  float _534 = _528 * 0.01088900025933981f;
  float _535 = mad(0.9869629740715027f, _529, _534);
  float _536 = mad(0.002148000057786703f, _530, _535);
  float _537 = mad(0.026962999254465103f, _529, _534);
  float _538 = mad(0.9621480107307434f, _530, _537);
  if (_520) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _543 = cb1_018y * 0.10000000149011612f;
        float _544 = log2(cb1_018z);
        float _545 = _544 + -13.287712097167969f;
        float _546 = _545 * 1.4929734468460083f;
        float _547 = _546 + 18.0f;
        float _548 = exp2(_547);
        float _549 = _548 * 0.18000000715255737f;
        float _550 = abs(_549);
        float _551 = log2(_550);
        float _552 = _551 * 1.5f;
        float _553 = exp2(_552);
        float _554 = _553 * _543;
        float _555 = _554 / cb1_018z;
        float _556 = _555 + -0.07636754959821701f;
        float _557 = _551 * 1.2750000953674316f;
        float _558 = exp2(_557);
        float _559 = _558 * 0.07636754959821701f;
        float _560 = cb1_018y * 0.011232397519052029f;
        float _561 = _560 * _553;
        float _562 = _561 / cb1_018z;
        float _563 = _559 - _562;
        float _564 = _558 + -0.11232396960258484f;
        float _565 = _564 * _543;
        float _566 = _565 / cb1_018z;
        float _567 = _566 * cb1_018z;
        float _568 = abs(_533);
        float _569 = abs(_536);
        float _570 = abs(_538);
        float _571 = log2(_568);
        float _572 = log2(_569);
        float _573 = log2(_570);
        float _574 = _571 * 1.5f;
        float _575 = _572 * 1.5f;
        float _576 = _573 * 1.5f;
        float _577 = exp2(_574);
        float _578 = exp2(_575);
        float _579 = exp2(_576);
        float _580 = _577 * _567;
        float _581 = _578 * _567;
        float _582 = _579 * _567;
        float _583 = _571 * 1.2750000953674316f;
        float _584 = _572 * 1.2750000953674316f;
        float _585 = _573 * 1.2750000953674316f;
        float _586 = exp2(_583);
        float _587 = exp2(_584);
        float _588 = exp2(_585);
        float _589 = _586 * _556;
        float _590 = _587 * _556;
        float _591 = _588 * _556;
        float _592 = _589 + _563;
        float _593 = _590 + _563;
        float _594 = _591 + _563;
        float _595 = _580 / _592;
        float _596 = _581 / _593;
        float _597 = _582 / _594;
        float _598 = _595 * 9.999999747378752e-05f;
        float _599 = _596 * 9.999999747378752e-05f;
        float _600 = _597 * 9.999999747378752e-05f;
        float _601 = 5000.0f / cb1_018y;
        float _602 = _598 * _601;
        float _603 = _599 * _601;
        float _604 = _600 * _601;
        _631 = _602;
        _632 = _603;
        _633 = _604;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_533, _536, _538));
      _631 = tonemapped.x, _632 = tonemapped.y, _633 = tonemapped.z;
    }
      } else {
        float _606 = _533 + 0.020616600289940834f;
        float _607 = _536 + 0.020616600289940834f;
        float _608 = _538 + 0.020616600289940834f;
        float _609 = _606 * _533;
        float _610 = _607 * _536;
        float _611 = _608 * _538;
        float _612 = _609 + -7.456949970219284e-05f;
        float _613 = _610 + -7.456949970219284e-05f;
        float _614 = _611 + -7.456949970219284e-05f;
        float _615 = _533 * 0.9837960004806519f;
        float _616 = _536 * 0.9837960004806519f;
        float _617 = _538 * 0.9837960004806519f;
        float _618 = _615 + 0.4336790144443512f;
        float _619 = _616 + 0.4336790144443512f;
        float _620 = _617 + 0.4336790144443512f;
        float _621 = _618 * _533;
        float _622 = _619 * _536;
        float _623 = _620 * _538;
        float _624 = _621 + 0.24617899954319f;
        float _625 = _622 + 0.24617899954319f;
        float _626 = _623 + 0.24617899954319f;
        float _627 = _612 / _624;
        float _628 = _613 / _625;
        float _629 = _614 / _626;
        _631 = _627;
        _632 = _628;
        _633 = _629;
      }
      float _634 = _631 * 1.6047500371932983f;
      float _635 = mad(-0.5310800075531006f, _632, _634);
      float _636 = mad(-0.07366999983787537f, _633, _635);
      float _637 = _631 * -0.10208000242710114f;
      float _638 = mad(1.1081299781799316f, _632, _637);
      float _639 = mad(-0.006049999967217445f, _633, _638);
      float _640 = _631 * -0.0032599999103695154f;
      float _641 = mad(-0.07275000214576721f, _632, _640);
      float _642 = mad(1.0760200023651123f, _633, _641);
      if (_520) {
        // float _644 = max(_636, 0.0f);
        // float _645 = max(_639, 0.0f);
        // float _646 = max(_642, 0.0f);
        // bool _647 = !(_644 >= 0.0030399328097701073f);
        // if (!_647) {
        //   float _649 = abs(_644);
        //   float _650 = log2(_649);
        //   float _651 = _650 * 0.4166666567325592f;
        //   float _652 = exp2(_651);
        //   float _653 = _652 * 1.0549999475479126f;
        //   float _654 = _653 + -0.054999999701976776f;
        //   _658 = _654;
        // } else {
        //   float _656 = _644 * 12.923210144042969f;
        //   _658 = _656;
        // }
        // bool _659 = !(_645 >= 0.0030399328097701073f);
        // if (!_659) {
        //   float _661 = abs(_645);
        //   float _662 = log2(_661);
        //   float _663 = _662 * 0.4166666567325592f;
        //   float _664 = exp2(_663);
        //   float _665 = _664 * 1.0549999475479126f;
        //   float _666 = _665 + -0.054999999701976776f;
        //   _670 = _666;
        // } else {
        //   float _668 = _645 * 12.923210144042969f;
        //   _670 = _668;
        // }
        // bool _671 = !(_646 >= 0.0030399328097701073f);
        // if (!_671) {
        //   float _673 = abs(_646);
        //   float _674 = log2(_673);
        //   float _675 = _674 * 0.4166666567325592f;
        //   float _676 = exp2(_675);
        //   float _677 = _676 * 1.0549999475479126f;
        //   float _678 = _677 + -0.054999999701976776f;
        //   _751 = _658;
        //   _752 = _670;
        //   _753 = _678;
        // } else {
        //   float _680 = _646 * 12.923210144042969f;
        //   _751 = _658;
        //   _752 = _670;
        //   _753 = _680;
        // }
        _751 = renodx::color::srgb::EncodeSafe(_636);
        _752 = renodx::color::srgb::EncodeSafe(_639);
        _753 = renodx::color::srgb::EncodeSafe(_642);

      } else {
        float _682 = saturate(_636);
        float _683 = saturate(_639);
        float _684 = saturate(_642);
        bool _685 = ((uint)(cb1_018w) == -2);
        if (!_685) {
          bool _687 = !(_682 >= 0.0030399328097701073f);
          if (!_687) {
            float _689 = abs(_682);
            float _690 = log2(_689);
            float _691 = _690 * 0.4166666567325592f;
            float _692 = exp2(_691);
            float _693 = _692 * 1.0549999475479126f;
            float _694 = _693 + -0.054999999701976776f;
            _698 = _694;
          } else {
            float _696 = _682 * 12.923210144042969f;
            _698 = _696;
          }
          bool _699 = !(_683 >= 0.0030399328097701073f);
          if (!_699) {
            float _701 = abs(_683);
            float _702 = log2(_701);
            float _703 = _702 * 0.4166666567325592f;
            float _704 = exp2(_703);
            float _705 = _704 * 1.0549999475479126f;
            float _706 = _705 + -0.054999999701976776f;
            _710 = _706;
          } else {
            float _708 = _683 * 12.923210144042969f;
            _710 = _708;
          }
          bool _711 = !(_684 >= 0.0030399328097701073f);
          if (!_711) {
            float _713 = abs(_684);
            float _714 = log2(_713);
            float _715 = _714 * 0.4166666567325592f;
            float _716 = exp2(_715);
            float _717 = _716 * 1.0549999475479126f;
            float _718 = _717 + -0.054999999701976776f;
            _722 = _698;
            _723 = _710;
            _724 = _718;
          } else {
            float _720 = _684 * 12.923210144042969f;
            _722 = _698;
            _723 = _710;
            _724 = _720;
          }
        } else {
          _722 = _682;
          _723 = _683;
          _724 = _684;
        }
        float _729 = abs(_722);
        float _730 = abs(_723);
        float _731 = abs(_724);
        float _732 = log2(_729);
        float _733 = log2(_730);
        float _734 = log2(_731);
        float _735 = _732 * cb2_000z;
        float _736 = _733 * cb2_000z;
        float _737 = _734 * cb2_000z;
        float _738 = exp2(_735);
        float _739 = exp2(_736);
        float _740 = exp2(_737);
        float _741 = _738 * cb2_000y;
        float _742 = _739 * cb2_000y;
        float _743 = _740 * cb2_000y;
        float _744 = _741 + cb2_000x;
        float _745 = _742 + cb2_000x;
        float _746 = _743 + cb2_000x;
        float _747 = saturate(_744);
        float _748 = saturate(_745);
        float _749 = saturate(_746);
        _751 = _747;
        _752 = _748;
        _753 = _749;
      }
      float _757 = cb2_023x * TEXCOORD0_centroid.x;
      float _758 = cb2_023y * TEXCOORD0_centroid.y;
      float _761 = _757 + cb2_023z;
      float _762 = _758 + cb2_023w;
      float4 _765 = t10.SampleLevel(s0_space2, float2(_761, _762), 0.0f);
      float _767 = _765.x + -0.5f;
      float _768 = _767 * cb2_022x;
      float _769 = _768 + 0.5f;
      float _770 = _769 * 2.0f;
      float _771 = _770 * _751;
      float _772 = _770 * _752;
      float _773 = _770 * _753;
      float _777 = float((uint)(cb2_019z));
      float _778 = float((uint)(cb2_019w));
      float _779 = _777 + SV_Position.x;
      float _780 = _778 + SV_Position.y;
      uint _781 = uint(_779);
      uint _782 = uint(_780);
      uint _785 = cb2_019x + -1u;
      uint _786 = cb2_019y + -1u;
      int _787 = _781 & _785;
      int _788 = _782 & _786;
      float4 _789 = t3.Load(int3(_787, _788, 0));
      float _793 = _789.x * 2.0f;
      float _794 = _789.y * 2.0f;
      float _795 = _789.z * 2.0f;
      float _796 = _793 + -1.0f;
      float _797 = _794 + -1.0f;
      float _798 = _795 + -1.0f;
      float _799 = _796 * _503;
      float _800 = _797 * _503;
      float _801 = _798 * _503;
      float _802 = _799 + _771;
      float _803 = _800 + _772;
      float _804 = _801 + _773;
      float _805 = dot(float3(_802, _803, _804), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _802;
      SV_Target.y = _803;
      SV_Target.z = _804;
      SV_Target.w = _805;
      SV_Target_1.x = _805;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
