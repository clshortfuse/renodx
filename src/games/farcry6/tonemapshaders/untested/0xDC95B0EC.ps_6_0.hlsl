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
  float4 _27 = t8.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _31 = _27.x * 6.283199787139893f;
  float _32 = cos(_31);
  float _33 = sin(_31);
  float _34 = _32 * _27.z;
  float _35 = _33 * _27.z;
  float _36 = _34 + TEXCOORD0_centroid.x;
  float _37 = _35 + TEXCOORD0_centroid.y;
  float _38 = _36 * 10.0f;
  float _39 = 10.0f - _38;
  float _40 = min(_38, _39);
  float _41 = saturate(_40);
  float _42 = _41 * _34;
  float _43 = _37 * 10.0f;
  float _44 = 10.0f - _43;
  float _45 = min(_43, _44);
  float _46 = saturate(_45);
  float _47 = _46 * _35;
  float _48 = _42 + TEXCOORD0_centroid.x;
  float _49 = _47 + TEXCOORD0_centroid.y;
  float4 _50 = t8.SampleLevel(s2_space2, float2(_48, _49), 0.0f);
  float _52 = _50.w * _42;
  float _53 = _50.w * _47;
  float _54 = 1.0f - _27.y;
  float _55 = saturate(_54);
  float _56 = _52 * _55;
  float _57 = _53 * _55;
  float _58 = _56 + TEXCOORD0_centroid.x;
  float _59 = _57 + TEXCOORD0_centroid.y;
  float4 _60 = t8.SampleLevel(s2_space2, float2(_58, _59), 0.0f);
  bool _62 = (_60.y > 0.0f);
  float _63 = select(_62, TEXCOORD0_centroid.x, _58);
  float _64 = select(_62, TEXCOORD0_centroid.y, _59);
  float4 _65 = t1.SampleLevel(s4_space2, float2(_63, _64), 0.0f);
  float _69 = max(_65.x, 0.0f);
  float _70 = max(_65.y, 0.0f);
  float _71 = max(_65.z, 0.0f);
  float _72 = min(_69, 65000.0f);
  float _73 = min(_70, 65000.0f);
  float _74 = min(_71, 65000.0f);
  float4 _75 = t4.SampleLevel(s2_space2, float2(_63, _64), 0.0f);
  float _80 = max(_75.x, 0.0f);
  float _81 = max(_75.y, 0.0f);
  float _82 = max(_75.z, 0.0f);
  float _83 = max(_75.w, 0.0f);
  float _84 = min(_80, 5000.0f);
  float _85 = min(_81, 5000.0f);
  float _86 = min(_82, 5000.0f);
  float _87 = min(_83, 5000.0f);
  float _90 = _25.x * cb0_028z;
  float _91 = _90 + cb0_028x;
  float _92 = cb2_027w / _91;
  float _93 = 1.0f - _92;
  float _94 = abs(_93);
  float _96 = cb2_027y * _94;
  float _98 = _96 - cb2_027z;
  float _99 = saturate(_98);
  float _100 = max(_99, _87);
  float _101 = saturate(_100);
  float4 _102 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _106 = _84 - _72;
  float _107 = _85 - _73;
  float _108 = _86 - _74;
  float _109 = _101 * _106;
  float _110 = _101 * _107;
  float _111 = _101 * _108;
  float _112 = _109 + _72;
  float _113 = _110 + _73;
  float _114 = _111 + _74;
  float _115 = dot(float3(_112, _113, _114), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _119 = t0[0].SExposureData_020;
  float _121 = t0[0].SExposureData_004;
  float _123 = cb2_018x * 0.5f;
  float _124 = _123 * cb2_018y;
  float _125 = _121.x - _124;
  float _126 = cb2_018y * cb2_018x;
  float _127 = 1.0f / _126;
  float _128 = _125 * _127;
  float _129 = _115 / _119.x;
  float _130 = _129 * 5464.01611328125f;
  float _131 = _130 + 9.99999993922529e-09f;
  float _132 = log2(_131);
  float _133 = _132 - _125;
  float _134 = _133 * _127;
  float _135 = saturate(_134);
  float2 _136 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _135), 0.0f);
  float _139 = max(_136.y, 1.0000000116860974e-07f);
  float _140 = _136.x / _139;
  float _141 = _140 + _128;
  float _142 = _141 / _127;
  float _143 = _142 - _121.x;
  float _144 = -0.0f - _143;
  float _146 = _144 - cb2_027x;
  float _147 = max(0.0f, _146);
  float _150 = cb2_026z * _147;
  float _151 = _143 - cb2_027x;
  float _152 = max(0.0f, _151);
  float _154 = cb2_026w * _152;
  bool _155 = (_143 < 0.0f);
  float _156 = select(_155, _150, _154);
  float _157 = exp2(_156);
  float _158 = _157 * _112;
  float _159 = _157 * _113;
  float _160 = _157 * _114;
  float _165 = cb2_024y * _102.x;
  float _166 = cb2_024z * _102.y;
  float _167 = cb2_024w * _102.z;
  float _168 = _165 + _158;
  float _169 = _166 + _159;
  float _170 = _167 + _160;
  float _175 = _168 * cb2_025x;
  float _176 = _169 * cb2_025y;
  float _177 = _170 * cb2_025z;
  float _178 = dot(float3(_175, _176, _177), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _179 = t0[0].SExposureData_012;
  float _181 = _178 * 5464.01611328125f;
  float _182 = _181 * _179.x;
  float _183 = _182 + 9.99999993922529e-09f;
  float _184 = log2(_183);
  float _185 = _184 + 16.929765701293945f;
  float _186 = _185 * 0.05734497308731079f;
  float _187 = saturate(_186);
  float _188 = _187 * _187;
  float _189 = _187 * 2.0f;
  float _190 = 3.0f - _189;
  float _191 = _188 * _190;
  float _192 = _176 * 0.8450999855995178f;
  float _193 = _177 * 0.14589999616146088f;
  float _194 = _192 + _193;
  float _195 = _194 * 2.4890189170837402f;
  float _196 = _194 * 0.3754962384700775f;
  float _197 = _194 * 2.811495304107666f;
  float _198 = _194 * 5.519708156585693f;
  float _199 = _178 - _195;
  float _200 = _191 * _199;
  float _201 = _200 + _195;
  float _202 = _191 * 0.5f;
  float _203 = _202 + 0.5f;
  float _204 = _203 * _199;
  float _205 = _204 + _195;
  float _206 = _175 - _196;
  float _207 = _176 - _197;
  float _208 = _177 - _198;
  float _209 = _203 * _206;
  float _210 = _203 * _207;
  float _211 = _203 * _208;
  float _212 = _209 + _196;
  float _213 = _210 + _197;
  float _214 = _211 + _198;
  float _215 = 1.0f / _205;
  float _216 = _201 * _215;
  float _217 = _216 * _212;
  float _218 = _216 * _213;
  float _219 = _216 * _214;
  float _223 = cb2_020x * TEXCOORD0_centroid.x;
  float _224 = cb2_020y * TEXCOORD0_centroid.y;
  float _227 = _223 + cb2_020z;
  float _228 = _224 + cb2_020w;
  float _231 = dot(float2(_227, _228), float2(_227, _228));
  float _232 = 1.0f - _231;
  float _233 = saturate(_232);
  float _234 = log2(_233);
  float _235 = _234 * cb2_021w;
  float _236 = exp2(_235);
  float _240 = _217 - cb2_021x;
  float _241 = _218 - cb2_021y;
  float _242 = _219 - cb2_021z;
  float _243 = _240 * _236;
  float _244 = _241 * _236;
  float _245 = _242 * _236;
  float _246 = _243 + cb2_021x;
  float _247 = _244 + cb2_021y;
  float _248 = _245 + cb2_021z;
  float _249 = t0[0].SExposureData_000;
  float _251 = max(_119.x, 0.0010000000474974513f);
  float _252 = 1.0f / _251;
  float _253 = _252 * _249.x;
  bool _256 = ((uint)(cb2_069y) == 0);
  float _262;
  float _263;
  float _264;
  float _318;
  float _319;
  float _320;
  float _366;
  float _367;
  float _368;
  float _413;
  float _414;
  float _415;
  float _416;
  float _465;
  float _466;
  float _467;
  float _468;
  float _493;
  float _494;
  float _495;
  float _596;
  float _597;
  float _598;
  float _623;
  float _635;
  float _663;
  float _675;
  float _687;
  float _688;
  float _689;
  float _716;
  float _717;
  float _718;
  if (!_256) {
    float _258 = _253 * _246;
    float _259 = _253 * _247;
    float _260 = _253 * _248;
    _262 = _258;
    _263 = _259;
    _264 = _260;
  } else {
    _262 = _246;
    _263 = _247;
    _264 = _248;
  }
  float _265 = _262 * 0.6130970120429993f;
  float _266 = mad(0.33952298760414124f, _263, _265);
  float _267 = mad(0.04737899824976921f, _264, _266);
  float _268 = _262 * 0.07019399851560593f;
  float _269 = mad(0.9163540005683899f, _263, _268);
  float _270 = mad(0.013451999984681606f, _264, _269);
  float _271 = _262 * 0.02061600051820278f;
  float _272 = mad(0.10956999659538269f, _263, _271);
  float _273 = mad(0.8698149919509888f, _264, _272);
  float _274 = log2(_267);
  float _275 = log2(_270);
  float _276 = log2(_273);
  float _277 = _274 * 0.04211956635117531f;
  float _278 = _275 * 0.04211956635117531f;
  float _279 = _276 * 0.04211956635117531f;
  float _280 = _277 + 0.6252607107162476f;
  float _281 = _278 + 0.6252607107162476f;
  float _282 = _279 + 0.6252607107162476f;
  float4 _283 = t6.SampleLevel(s2_space2, float3(_280, _281, _282), 0.0f);
  bool _289 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_289 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _293 = cb2_017x * _283.x;
    float _294 = cb2_017x * _283.y;
    float _295 = cb2_017x * _283.z;
    float _297 = _293 + cb2_017y;
    float _298 = _294 + cb2_017y;
    float _299 = _295 + cb2_017y;
    float _300 = exp2(_297);
    float _301 = exp2(_298);
    float _302 = exp2(_299);
    float _303 = _300 + 1.0f;
    float _304 = _301 + 1.0f;
    float _305 = _302 + 1.0f;
    float _306 = 1.0f / _303;
    float _307 = 1.0f / _304;
    float _308 = 1.0f / _305;
    float _310 = cb2_017z * _306;
    float _311 = cb2_017z * _307;
    float _312 = cb2_017z * _308;
    float _314 = _310 + cb2_017w;
    float _315 = _311 + cb2_017w;
    float _316 = _312 + cb2_017w;
    _318 = _314;
    _319 = _315;
    _320 = _316;
  } else {
    _318 = _283.x;
    _319 = _283.y;
    _320 = _283.z;
  }
  float _321 = _318 * 23.0f;
  float _322 = _321 + -14.473931312561035f;
  float _323 = exp2(_322);
  float _324 = _319 * 23.0f;
  float _325 = _324 + -14.473931312561035f;
  float _326 = exp2(_325);
  float _327 = _320 * 23.0f;
  float _328 = _327 + -14.473931312561035f;
  float _329 = exp2(_328);
  float _334 = cb2_004x * TEXCOORD0_centroid.x;
  float _335 = cb2_004y * TEXCOORD0_centroid.y;
  float _338 = _334 + cb2_004z;
  float _339 = _335 + cb2_004w;
  float4 _345 = t7.Sample(s2_space2, float2(_338, _339));
  float _350 = _345.x * cb2_003x;
  float _351 = _345.y * cb2_003y;
  float _352 = _345.z * cb2_003z;
  float _353 = _345.w * cb2_003w;
  float _356 = _353 + cb2_026y;
  float _357 = saturate(_356);
  bool _360 = ((uint)(cb2_069y) == 0);
  if (!_360) {
    float _362 = _350 * _253;
    float _363 = _351 * _253;
    float _364 = _352 * _253;
    _366 = _362;
    _367 = _363;
    _368 = _364;
  } else {
    _366 = _350;
    _367 = _351;
    _368 = _352;
  }
  bool _371 = ((uint)(cb2_028x) == 2);
  bool _372 = ((uint)(cb2_028x) == 3);
  int _373 = (uint)(cb2_028x) & -2;
  bool _374 = (_373 == 2);
  bool _375 = ((uint)(cb2_028x) == 6);
  bool _376 = _374 || _375;
  if (_376) {
    float _378 = _366 * _357;
    float _379 = _367 * _357;
    float _380 = _368 * _357;
    float _381 = _357 * _357;
    _413 = _378;
    _414 = _379;
    _415 = _380;
    _416 = _381;
  } else {
    bool _383 = ((uint)(cb2_028x) == 4);
    if (_383) {
      float _385 = _366 + -1.0f;
      float _386 = _367 + -1.0f;
      float _387 = _368 + -1.0f;
      float _388 = _357 + -1.0f;
      float _389 = _385 * _357;
      float _390 = _386 * _357;
      float _391 = _387 * _357;
      float _392 = _388 * _357;
      float _393 = _389 + 1.0f;
      float _394 = _390 + 1.0f;
      float _395 = _391 + 1.0f;
      float _396 = _392 + 1.0f;
      _413 = _393;
      _414 = _394;
      _415 = _395;
      _416 = _396;
    } else {
      bool _398 = ((uint)(cb2_028x) == 5);
      if (_398) {
        float _400 = _366 + -0.5f;
        float _401 = _367 + -0.5f;
        float _402 = _368 + -0.5f;
        float _403 = _357 + -0.5f;
        float _404 = _400 * _357;
        float _405 = _401 * _357;
        float _406 = _402 * _357;
        float _407 = _403 * _357;
        float _408 = _404 + 0.5f;
        float _409 = _405 + 0.5f;
        float _410 = _406 + 0.5f;
        float _411 = _407 + 0.5f;
        _413 = _408;
        _414 = _409;
        _415 = _410;
        _416 = _411;
      } else {
        _413 = _366;
        _414 = _367;
        _415 = _368;
        _416 = _357;
      }
    }
  }
  if (_371) {
    float _418 = _413 + _323;
    float _419 = _414 + _326;
    float _420 = _415 + _329;
    _465 = _418;
    _466 = _419;
    _467 = _420;
    _468 = cb2_025w;
  } else {
    if (_372) {
      float _423 = 1.0f - _413;
      float _424 = 1.0f - _414;
      float _425 = 1.0f - _415;
      float _426 = _423 * _323;
      float _427 = _424 * _326;
      float _428 = _425 * _329;
      float _429 = _426 + _413;
      float _430 = _427 + _414;
      float _431 = _428 + _415;
      _465 = _429;
      _466 = _430;
      _467 = _431;
      _468 = cb2_025w;
    } else {
      bool _433 = ((uint)(cb2_028x) == 4);
      if (_433) {
        float _435 = _413 * _323;
        float _436 = _414 * _326;
        float _437 = _415 * _329;
        _465 = _435;
        _466 = _436;
        _467 = _437;
        _468 = cb2_025w;
      } else {
        bool _439 = ((uint)(cb2_028x) == 5);
        if (_439) {
          float _441 = _323 * 2.0f;
          float _442 = _441 * _413;
          float _443 = _326 * 2.0f;
          float _444 = _443 * _414;
          float _445 = _329 * 2.0f;
          float _446 = _445 * _415;
          _465 = _442;
          _466 = _444;
          _467 = _446;
          _468 = cb2_025w;
        } else {
          if (_375) {
            float _449 = _323 - _413;
            float _450 = _326 - _414;
            float _451 = _329 - _415;
            _465 = _449;
            _466 = _450;
            _467 = _451;
            _468 = cb2_025w;
          } else {
            float _453 = _413 - _323;
            float _454 = _414 - _326;
            float _455 = _415 - _329;
            float _456 = _416 * _453;
            float _457 = _416 * _454;
            float _458 = _416 * _455;
            float _459 = _456 + _323;
            float _460 = _457 + _326;
            float _461 = _458 + _329;
            float _462 = 1.0f - _416;
            float _463 = _462 * cb2_025w;
            _465 = _459;
            _466 = _460;
            _467 = _461;
            _468 = _463;
          }
        }
      }
    }
  }
  float _474 = cb2_016x - _465;
  float _475 = cb2_016y - _466;
  float _476 = cb2_016z - _467;
  float _477 = _474 * cb2_016w;
  float _478 = _475 * cb2_016w;
  float _479 = _476 * cb2_016w;
  float _480 = _477 + _465;
  float _481 = _478 + _466;
  float _482 = _479 + _467;
  bool _485 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_485 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _489 = cb2_024x * _480;
    float _490 = cb2_024x * _481;
    float _491 = cb2_024x * _482;
    _493 = _489;
    _494 = _490;
    _495 = _491;
  } else {
    _493 = _480;
    _494 = _481;
    _495 = _482;
  }
  float _496 = _493 * 0.9708889722824097f;
  float _497 = mad(0.026962999254465103f, _494, _496);
  float _498 = mad(0.002148000057786703f, _495, _497);
  float _499 = _493 * 0.01088900025933981f;
  float _500 = mad(0.9869629740715027f, _494, _499);
  float _501 = mad(0.002148000057786703f, _495, _500);
  float _502 = mad(0.026962999254465103f, _494, _499);
  float _503 = mad(0.9621480107307434f, _495, _502);
  if (_485) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _508 = cb1_018y * 0.10000000149011612f;
        float _509 = log2(cb1_018z);
        float _510 = _509 + -13.287712097167969f;
        float _511 = _510 * 1.4929734468460083f;
        float _512 = _511 + 18.0f;
        float _513 = exp2(_512);
        float _514 = _513 * 0.18000000715255737f;
        float _515 = abs(_514);
        float _516 = log2(_515);
        float _517 = _516 * 1.5f;
        float _518 = exp2(_517);
        float _519 = _518 * _508;
        float _520 = _519 / cb1_018z;
        float _521 = _520 + -0.07636754959821701f;
        float _522 = _516 * 1.2750000953674316f;
        float _523 = exp2(_522);
        float _524 = _523 * 0.07636754959821701f;
        float _525 = cb1_018y * 0.011232397519052029f;
        float _526 = _525 * _518;
        float _527 = _526 / cb1_018z;
        float _528 = _524 - _527;
        float _529 = _523 + -0.11232396960258484f;
        float _530 = _529 * _508;
        float _531 = _530 / cb1_018z;
        float _532 = _531 * cb1_018z;
        float _533 = abs(_498);
        float _534 = abs(_501);
        float _535 = abs(_503);
        float _536 = log2(_533);
        float _537 = log2(_534);
        float _538 = log2(_535);
        float _539 = _536 * 1.5f;
        float _540 = _537 * 1.5f;
        float _541 = _538 * 1.5f;
        float _542 = exp2(_539);
        float _543 = exp2(_540);
        float _544 = exp2(_541);
        float _545 = _542 * _532;
        float _546 = _543 * _532;
        float _547 = _544 * _532;
        float _548 = _536 * 1.2750000953674316f;
        float _549 = _537 * 1.2750000953674316f;
        float _550 = _538 * 1.2750000953674316f;
        float _551 = exp2(_548);
        float _552 = exp2(_549);
        float _553 = exp2(_550);
        float _554 = _551 * _521;
        float _555 = _552 * _521;
        float _556 = _553 * _521;
        float _557 = _554 + _528;
        float _558 = _555 + _528;
        float _559 = _556 + _528;
        float _560 = _545 / _557;
        float _561 = _546 / _558;
        float _562 = _547 / _559;
        float _563 = _560 * 9.999999747378752e-05f;
        float _564 = _561 * 9.999999747378752e-05f;
        float _565 = _562 * 9.999999747378752e-05f;
        float _566 = 5000.0f / cb1_018y;
        float _567 = _563 * _566;
        float _568 = _564 * _566;
        float _569 = _565 * _566;
        _596 = _567;
        _597 = _568;
        _598 = _569;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_498, _501, _503));
      _596 = tonemapped.x, _597 = tonemapped.y, _598 = tonemapped.z;
    }
      } else {
        float _571 = _498 + 0.020616600289940834f;
        float _572 = _501 + 0.020616600289940834f;
        float _573 = _503 + 0.020616600289940834f;
        float _574 = _571 * _498;
        float _575 = _572 * _501;
        float _576 = _573 * _503;
        float _577 = _574 + -7.456949970219284e-05f;
        float _578 = _575 + -7.456949970219284e-05f;
        float _579 = _576 + -7.456949970219284e-05f;
        float _580 = _498 * 0.9837960004806519f;
        float _581 = _501 * 0.9837960004806519f;
        float _582 = _503 * 0.9837960004806519f;
        float _583 = _580 + 0.4336790144443512f;
        float _584 = _581 + 0.4336790144443512f;
        float _585 = _582 + 0.4336790144443512f;
        float _586 = _583 * _498;
        float _587 = _584 * _501;
        float _588 = _585 * _503;
        float _589 = _586 + 0.24617899954319f;
        float _590 = _587 + 0.24617899954319f;
        float _591 = _588 + 0.24617899954319f;
        float _592 = _577 / _589;
        float _593 = _578 / _590;
        float _594 = _579 / _591;
        _596 = _592;
        _597 = _593;
        _598 = _594;
      }
      float _599 = _596 * 1.6047500371932983f;
      float _600 = mad(-0.5310800075531006f, _597, _599);
      float _601 = mad(-0.07366999983787537f, _598, _600);
      float _602 = _596 * -0.10208000242710114f;
      float _603 = mad(1.1081299781799316f, _597, _602);
      float _604 = mad(-0.006049999967217445f, _598, _603);
      float _605 = _596 * -0.0032599999103695154f;
      float _606 = mad(-0.07275000214576721f, _597, _605);
      float _607 = mad(1.0760200023651123f, _598, _606);
      if (_485) {
        // float _609 = max(_601, 0.0f);
        // float _610 = max(_604, 0.0f);
        // float _611 = max(_607, 0.0f);
        // bool _612 = !(_609 >= 0.0030399328097701073f);
        // if (!_612) {
        //   float _614 = abs(_609);
        //   float _615 = log2(_614);
        //   float _616 = _615 * 0.4166666567325592f;
        //   float _617 = exp2(_616);
        //   float _618 = _617 * 1.0549999475479126f;
        //   float _619 = _618 + -0.054999999701976776f;
        //   _623 = _619;
        // } else {
        //   float _621 = _609 * 12.923210144042969f;
        //   _623 = _621;
        // }
        // bool _624 = !(_610 >= 0.0030399328097701073f);
        // if (!_624) {
        //   float _626 = abs(_610);
        //   float _627 = log2(_626);
        //   float _628 = _627 * 0.4166666567325592f;
        //   float _629 = exp2(_628);
        //   float _630 = _629 * 1.0549999475479126f;
        //   float _631 = _630 + -0.054999999701976776f;
        //   _635 = _631;
        // } else {
        //   float _633 = _610 * 12.923210144042969f;
        //   _635 = _633;
        // }
        // bool _636 = !(_611 >= 0.0030399328097701073f);
        // if (!_636) {
        //   float _638 = abs(_611);
        //   float _639 = log2(_638);
        //   float _640 = _639 * 0.4166666567325592f;
        //   float _641 = exp2(_640);
        //   float _642 = _641 * 1.0549999475479126f;
        //   float _643 = _642 + -0.054999999701976776f;
        //   _716 = _623;
        //   _717 = _635;
        //   _718 = _643;
        // } else {
        //   float _645 = _611 * 12.923210144042969f;
        //   _716 = _623;
        //   _717 = _635;
        //   _718 = _645;
        // }
        _716 = renodx::color::srgb::EncodeSafe(_601);
        _717 = renodx::color::srgb::EncodeSafe(_604);
        _718 = renodx::color::srgb::EncodeSafe(_607);

      } else {
        float _647 = saturate(_601);
        float _648 = saturate(_604);
        float _649 = saturate(_607);
        bool _650 = ((uint)(cb1_018w) == -2);
        if (!_650) {
          bool _652 = !(_647 >= 0.0030399328097701073f);
          if (!_652) {
            float _654 = abs(_647);
            float _655 = log2(_654);
            float _656 = _655 * 0.4166666567325592f;
            float _657 = exp2(_656);
            float _658 = _657 * 1.0549999475479126f;
            float _659 = _658 + -0.054999999701976776f;
            _663 = _659;
          } else {
            float _661 = _647 * 12.923210144042969f;
            _663 = _661;
          }
          bool _664 = !(_648 >= 0.0030399328097701073f);
          if (!_664) {
            float _666 = abs(_648);
            float _667 = log2(_666);
            float _668 = _667 * 0.4166666567325592f;
            float _669 = exp2(_668);
            float _670 = _669 * 1.0549999475479126f;
            float _671 = _670 + -0.054999999701976776f;
            _675 = _671;
          } else {
            float _673 = _648 * 12.923210144042969f;
            _675 = _673;
          }
          bool _676 = !(_649 >= 0.0030399328097701073f);
          if (!_676) {
            float _678 = abs(_649);
            float _679 = log2(_678);
            float _680 = _679 * 0.4166666567325592f;
            float _681 = exp2(_680);
            float _682 = _681 * 1.0549999475479126f;
            float _683 = _682 + -0.054999999701976776f;
            _687 = _663;
            _688 = _675;
            _689 = _683;
          } else {
            float _685 = _649 * 12.923210144042969f;
            _687 = _663;
            _688 = _675;
            _689 = _685;
          }
        } else {
          _687 = _647;
          _688 = _648;
          _689 = _649;
        }
        float _694 = abs(_687);
        float _695 = abs(_688);
        float _696 = abs(_689);
        float _697 = log2(_694);
        float _698 = log2(_695);
        float _699 = log2(_696);
        float _700 = _697 * cb2_000z;
        float _701 = _698 * cb2_000z;
        float _702 = _699 * cb2_000z;
        float _703 = exp2(_700);
        float _704 = exp2(_701);
        float _705 = exp2(_702);
        float _706 = _703 * cb2_000y;
        float _707 = _704 * cb2_000y;
        float _708 = _705 * cb2_000y;
        float _709 = _706 + cb2_000x;
        float _710 = _707 + cb2_000x;
        float _711 = _708 + cb2_000x;
        float _712 = saturate(_709);
        float _713 = saturate(_710);
        float _714 = saturate(_711);
        _716 = _712;
        _717 = _713;
        _718 = _714;
      }
      float _722 = cb2_023x * TEXCOORD0_centroid.x;
      float _723 = cb2_023y * TEXCOORD0_centroid.y;
      float _726 = _722 + cb2_023z;
      float _727 = _723 + cb2_023w;
      float4 _730 = t10.SampleLevel(s0_space2, float2(_726, _727), 0.0f);
      float _732 = _730.x + -0.5f;
      float _733 = _732 * cb2_022x;
      float _734 = _733 + 0.5f;
      float _735 = _734 * 2.0f;
      float _736 = _735 * _716;
      float _737 = _735 * _717;
      float _738 = _735 * _718;
      float _742 = float((uint)(cb2_019z));
      float _743 = float((uint)(cb2_019w));
      float _744 = _742 + SV_Position.x;
      float _745 = _743 + SV_Position.y;
      uint _746 = uint(_744);
      uint _747 = uint(_745);
      uint _750 = cb2_019x + -1u;
      uint _751 = cb2_019y + -1u;
      int _752 = _746 & _750;
      int _753 = _747 & _751;
      float4 _754 = t3.Load(int3(_752, _753, 0));
      float _758 = _754.x * 2.0f;
      float _759 = _754.y * 2.0f;
      float _760 = _754.z * 2.0f;
      float _761 = _758 + -1.0f;
      float _762 = _759 + -1.0f;
      float _763 = _760 + -1.0f;
      float _764 = _761 * _468;
      float _765 = _762 * _468;
      float _766 = _763 * _468;
      float _767 = _764 + _736;
      float _768 = _765 + _737;
      float _769 = _766 + _738;
      float _770 = dot(float3(_767, _768, _769), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _767;
      SV_Target.y = _768;
      SV_Target.z = _769;
      SV_Target.w = _770;
      SV_Target_1.x = _770;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
