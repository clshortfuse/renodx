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
  float _360;
  float _361;
  float _362;
  float _407;
  float _408;
  float _409;
  float _410;
  float _457;
  float _458;
  float _459;
  float _484;
  float _485;
  float _486;
  float _587;
  float _588;
  float _589;
  float _614;
  float _626;
  float _654;
  float _666;
  float _678;
  float _679;
  float _680;
  float _707;
  float _708;
  float _709;
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
  float _328 = cb2_004x * TEXCOORD0_centroid.x;
  float _329 = cb2_004y * TEXCOORD0_centroid.y;
  float _332 = _328 + cb2_004z;
  float _333 = _329 + cb2_004w;
  float4 _339 = t6.Sample(s2_space2, float2(_332, _333));
  float _344 = _339.x * cb2_003x;
  float _345 = _339.y * cb2_003y;
  float _346 = _339.z * cb2_003z;
  float _347 = _339.w * cb2_003w;
  float _350 = _347 + cb2_026y;
  float _351 = saturate(_350);
  bool _354 = ((uint)(cb2_069y) == 0);
  if (!_354) {
    float _356 = _344 * _248;
    float _357 = _345 * _248;
    float _358 = _346 * _248;
    _360 = _356;
    _361 = _357;
    _362 = _358;
  } else {
    _360 = _344;
    _361 = _345;
    _362 = _346;
  }
  bool _365 = ((uint)(cb2_028x) == 2);
  bool _366 = ((uint)(cb2_028x) == 3);
  int _367 = (uint)(cb2_028x) & -2;
  bool _368 = (_367 == 2);
  bool _369 = ((uint)(cb2_028x) == 6);
  bool _370 = _368 || _369;
  if (_370) {
    float _372 = _360 * _351;
    float _373 = _361 * _351;
    float _374 = _362 * _351;
    float _375 = _351 * _351;
    _407 = _372;
    _408 = _373;
    _409 = _374;
    _410 = _375;
  } else {
    bool _377 = ((uint)(cb2_028x) == 4);
    if (_377) {
      float _379 = _360 + -1.0f;
      float _380 = _361 + -1.0f;
      float _381 = _362 + -1.0f;
      float _382 = _351 + -1.0f;
      float _383 = _379 * _351;
      float _384 = _380 * _351;
      float _385 = _381 * _351;
      float _386 = _382 * _351;
      float _387 = _383 + 1.0f;
      float _388 = _384 + 1.0f;
      float _389 = _385 + 1.0f;
      float _390 = _386 + 1.0f;
      _407 = _387;
      _408 = _388;
      _409 = _389;
      _410 = _390;
    } else {
      bool _392 = ((uint)(cb2_028x) == 5);
      if (_392) {
        float _394 = _360 + -0.5f;
        float _395 = _361 + -0.5f;
        float _396 = _362 + -0.5f;
        float _397 = _351 + -0.5f;
        float _398 = _394 * _351;
        float _399 = _395 * _351;
        float _400 = _396 * _351;
        float _401 = _397 * _351;
        float _402 = _398 + 0.5f;
        float _403 = _399 + 0.5f;
        float _404 = _400 + 0.5f;
        float _405 = _401 + 0.5f;
        _407 = _402;
        _408 = _403;
        _409 = _404;
        _410 = _405;
      } else {
        _407 = _360;
        _408 = _361;
        _409 = _362;
        _410 = _351;
      }
    }
  }
  if (_365) {
    float _412 = _407 + _318;
    float _413 = _408 + _321;
    float _414 = _409 + _324;
    _457 = _412;
    _458 = _413;
    _459 = _414;
  } else {
    if (_366) {
      float _417 = 1.0f - _407;
      float _418 = 1.0f - _408;
      float _419 = 1.0f - _409;
      float _420 = _417 * _318;
      float _421 = _418 * _321;
      float _422 = _419 * _324;
      float _423 = _420 + _407;
      float _424 = _421 + _408;
      float _425 = _422 + _409;
      _457 = _423;
      _458 = _424;
      _459 = _425;
    } else {
      bool _427 = ((uint)(cb2_028x) == 4);
      if (_427) {
        float _429 = _407 * _318;
        float _430 = _408 * _321;
        float _431 = _409 * _324;
        _457 = _429;
        _458 = _430;
        _459 = _431;
      } else {
        bool _433 = ((uint)(cb2_028x) == 5);
        if (_433) {
          float _435 = _318 * 2.0f;
          float _436 = _435 * _407;
          float _437 = _321 * 2.0f;
          float _438 = _437 * _408;
          float _439 = _324 * 2.0f;
          float _440 = _439 * _409;
          _457 = _436;
          _458 = _438;
          _459 = _440;
        } else {
          if (_369) {
            float _443 = _318 - _407;
            float _444 = _321 - _408;
            float _445 = _324 - _409;
            _457 = _443;
            _458 = _444;
            _459 = _445;
          } else {
            float _447 = _407 - _318;
            float _448 = _408 - _321;
            float _449 = _409 - _324;
            float _450 = _410 * _447;
            float _451 = _410 * _448;
            float _452 = _410 * _449;
            float _453 = _450 + _318;
            float _454 = _451 + _321;
            float _455 = _452 + _324;
            _457 = _453;
            _458 = _454;
            _459 = _455;
          }
        }
      }
    }
  }
  float _465 = cb2_016x - _457;
  float _466 = cb2_016y - _458;
  float _467 = cb2_016z - _459;
  float _468 = _465 * cb2_016w;
  float _469 = _466 * cb2_016w;
  float _470 = _467 * cb2_016w;
  float _471 = _468 + _457;
  float _472 = _469 + _458;
  float _473 = _470 + _459;
  bool _476 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_476 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _480 = cb2_024x * _471;
    float _481 = cb2_024x * _472;
    float _482 = cb2_024x * _473;
    _484 = _480;
    _485 = _481;
    _486 = _482;
  } else {
    _484 = _471;
    _485 = _472;
    _486 = _473;
  }
  float _487 = _484 * 0.9708889722824097f;
  float _488 = mad(0.026962999254465103f, _485, _487);
  float _489 = mad(0.002148000057786703f, _486, _488);
  float _490 = _484 * 0.01088900025933981f;
  float _491 = mad(0.9869629740715027f, _485, _490);
  float _492 = mad(0.002148000057786703f, _486, _491);
  float _493 = mad(0.026962999254465103f, _485, _490);
  float _494 = mad(0.9621480107307434f, _486, _493);
  if (_476) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _499 = cb1_018y * 0.10000000149011612f;
        float _500 = log2(cb1_018z);
        float _501 = _500 + -13.287712097167969f;
        float _502 = _501 * 1.4929734468460083f;
        float _503 = _502 + 18.0f;
        float _504 = exp2(_503);
        float _505 = _504 * 0.18000000715255737f;
        float _506 = abs(_505);
        float _507 = log2(_506);
        float _508 = _507 * 1.5f;
        float _509 = exp2(_508);
        float _510 = _509 * _499;
        float _511 = _510 / cb1_018z;
        float _512 = _511 + -0.07636754959821701f;
        float _513 = _507 * 1.2750000953674316f;
        float _514 = exp2(_513);
        float _515 = _514 * 0.07636754959821701f;
        float _516 = cb1_018y * 0.011232397519052029f;
        float _517 = _516 * _509;
        float _518 = _517 / cb1_018z;
        float _519 = _515 - _518;
        float _520 = _514 + -0.11232396960258484f;
        float _521 = _520 * _499;
        float _522 = _521 / cb1_018z;
        float _523 = _522 * cb1_018z;
        float _524 = abs(_489);
        float _525 = abs(_492);
        float _526 = abs(_494);
        float _527 = log2(_524);
        float _528 = log2(_525);
        float _529 = log2(_526);
        float _530 = _527 * 1.5f;
        float _531 = _528 * 1.5f;
        float _532 = _529 * 1.5f;
        float _533 = exp2(_530);
        float _534 = exp2(_531);
        float _535 = exp2(_532);
        float _536 = _533 * _523;
        float _537 = _534 * _523;
        float _538 = _535 * _523;
        float _539 = _527 * 1.2750000953674316f;
        float _540 = _528 * 1.2750000953674316f;
        float _541 = _529 * 1.2750000953674316f;
        float _542 = exp2(_539);
        float _543 = exp2(_540);
        float _544 = exp2(_541);
        float _545 = _542 * _512;
        float _546 = _543 * _512;
        float _547 = _544 * _512;
        float _548 = _545 + _519;
        float _549 = _546 + _519;
        float _550 = _547 + _519;
        float _551 = _536 / _548;
        float _552 = _537 / _549;
        float _553 = _538 / _550;
        float _554 = _551 * 9.999999747378752e-05f;
        float _555 = _552 * 9.999999747378752e-05f;
        float _556 = _553 * 9.999999747378752e-05f;
        float _557 = 5000.0f / cb1_018y;
        float _558 = _554 * _557;
        float _559 = _555 * _557;
        float _560 = _556 * _557;
        _587 = _558;
        _588 = _559;
        _589 = _560;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_489, _492, _494));
      _587 = tonemapped.x, _588 = tonemapped.y, _589 = tonemapped.z;
    }
      } else {
        float _562 = _489 + 0.020616600289940834f;
        float _563 = _492 + 0.020616600289940834f;
        float _564 = _494 + 0.020616600289940834f;
        float _565 = _562 * _489;
        float _566 = _563 * _492;
        float _567 = _564 * _494;
        float _568 = _565 + -7.456949970219284e-05f;
        float _569 = _566 + -7.456949970219284e-05f;
        float _570 = _567 + -7.456949970219284e-05f;
        float _571 = _489 * 0.9837960004806519f;
        float _572 = _492 * 0.9837960004806519f;
        float _573 = _494 * 0.9837960004806519f;
        float _574 = _571 + 0.4336790144443512f;
        float _575 = _572 + 0.4336790144443512f;
        float _576 = _573 + 0.4336790144443512f;
        float _577 = _574 * _489;
        float _578 = _575 * _492;
        float _579 = _576 * _494;
        float _580 = _577 + 0.24617899954319f;
        float _581 = _578 + 0.24617899954319f;
        float _582 = _579 + 0.24617899954319f;
        float _583 = _568 / _580;
        float _584 = _569 / _581;
        float _585 = _570 / _582;
        _587 = _583;
        _588 = _584;
        _589 = _585;
      }
      float _590 = _587 * 1.6047500371932983f;
      float _591 = mad(-0.5310800075531006f, _588, _590);
      float _592 = mad(-0.07366999983787537f, _589, _591);
      float _593 = _587 * -0.10208000242710114f;
      float _594 = mad(1.1081299781799316f, _588, _593);
      float _595 = mad(-0.006049999967217445f, _589, _594);
      float _596 = _587 * -0.0032599999103695154f;
      float _597 = mad(-0.07275000214576721f, _588, _596);
      float _598 = mad(1.0760200023651123f, _589, _597);
      if (_476) {
        // float _600 = max(_592, 0.0f);
        // float _601 = max(_595, 0.0f);
        // float _602 = max(_598, 0.0f);
        // bool _603 = !(_600 >= 0.0030399328097701073f);
        // if (!_603) {
        //   float _605 = abs(_600);
        //   float _606 = log2(_605);
        //   float _607 = _606 * 0.4166666567325592f;
        //   float _608 = exp2(_607);
        //   float _609 = _608 * 1.0549999475479126f;
        //   float _610 = _609 + -0.054999999701976776f;
        //   _614 = _610;
        // } else {
        //   float _612 = _600 * 12.923210144042969f;
        //   _614 = _612;
        // }
        // bool _615 = !(_601 >= 0.0030399328097701073f);
        // if (!_615) {
        //   float _617 = abs(_601);
        //   float _618 = log2(_617);
        //   float _619 = _618 * 0.4166666567325592f;
        //   float _620 = exp2(_619);
        //   float _621 = _620 * 1.0549999475479126f;
        //   float _622 = _621 + -0.054999999701976776f;
        //   _626 = _622;
        // } else {
        //   float _624 = _601 * 12.923210144042969f;
        //   _626 = _624;
        // }
        // bool _627 = !(_602 >= 0.0030399328097701073f);
        // if (!_627) {
        //   float _629 = abs(_602);
        //   float _630 = log2(_629);
        //   float _631 = _630 * 0.4166666567325592f;
        //   float _632 = exp2(_631);
        //   float _633 = _632 * 1.0549999475479126f;
        //   float _634 = _633 + -0.054999999701976776f;
        //   _707 = _614;
        //   _708 = _626;
        //   _709 = _634;
        // } else {
        //   float _636 = _602 * 12.923210144042969f;
        //   _707 = _614;
        //   _708 = _626;
        //   _709 = _636;
        // }
        _707 = renodx::color::srgb::EncodeSafe(_592);
        _708 = renodx::color::srgb::EncodeSafe(_595);
        _709 = renodx::color::srgb::EncodeSafe(_598);

      } else {
        float _638 = saturate(_592);
        float _639 = saturate(_595);
        float _640 = saturate(_598);
        bool _641 = ((uint)(cb1_018w) == -2);
        if (!_641) {
          bool _643 = !(_638 >= 0.0030399328097701073f);
          if (!_643) {
            float _645 = abs(_638);
            float _646 = log2(_645);
            float _647 = _646 * 0.4166666567325592f;
            float _648 = exp2(_647);
            float _649 = _648 * 1.0549999475479126f;
            float _650 = _649 + -0.054999999701976776f;
            _654 = _650;
          } else {
            float _652 = _638 * 12.923210144042969f;
            _654 = _652;
          }
          bool _655 = !(_639 >= 0.0030399328097701073f);
          if (!_655) {
            float _657 = abs(_639);
            float _658 = log2(_657);
            float _659 = _658 * 0.4166666567325592f;
            float _660 = exp2(_659);
            float _661 = _660 * 1.0549999475479126f;
            float _662 = _661 + -0.054999999701976776f;
            _666 = _662;
          } else {
            float _664 = _639 * 12.923210144042969f;
            _666 = _664;
          }
          bool _667 = !(_640 >= 0.0030399328097701073f);
          if (!_667) {
            float _669 = abs(_640);
            float _670 = log2(_669);
            float _671 = _670 * 0.4166666567325592f;
            float _672 = exp2(_671);
            float _673 = _672 * 1.0549999475479126f;
            float _674 = _673 + -0.054999999701976776f;
            _678 = _654;
            _679 = _666;
            _680 = _674;
          } else {
            float _676 = _640 * 12.923210144042969f;
            _678 = _654;
            _679 = _666;
            _680 = _676;
          }
        } else {
          _678 = _638;
          _679 = _639;
          _680 = _640;
        }
        float _685 = abs(_678);
        float _686 = abs(_679);
        float _687 = abs(_680);
        float _688 = log2(_685);
        float _689 = log2(_686);
        float _690 = log2(_687);
        float _691 = _688 * cb2_000z;
        float _692 = _689 * cb2_000z;
        float _693 = _690 * cb2_000z;
        float _694 = exp2(_691);
        float _695 = exp2(_692);
        float _696 = exp2(_693);
        float _697 = _694 * cb2_000y;
        float _698 = _695 * cb2_000y;
        float _699 = _696 * cb2_000y;
        float _700 = _697 + cb2_000x;
        float _701 = _698 + cb2_000x;
        float _702 = _699 + cb2_000x;
        float _703 = saturate(_700);
        float _704 = saturate(_701);
        float _705 = saturate(_702);
        _707 = _703;
        _708 = _704;
        _709 = _705;
      }
      float _710 = dot(float3(_707, _708, _709), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _707;
      SV_Target.y = _708;
      SV_Target.z = _709;
      SV_Target.w = _710;
      SV_Target_1.x = _710;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
