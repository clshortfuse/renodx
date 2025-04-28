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

Texture3D<float2> t7 : register(t7);

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
  float _19 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _21 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _25 = max(_21.x, 0.0f);
  float _26 = max(_21.y, 0.0f);
  float _27 = max(_21.z, 0.0f);
  float _28 = min(_25, 65000.0f);
  float _29 = min(_26, 65000.0f);
  float _30 = min(_27, 65000.0f);
  float4 _31 = t3.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _36 = max(_31.x, 0.0f);
  float _37 = max(_31.y, 0.0f);
  float _38 = max(_31.z, 0.0f);
  float _39 = max(_31.w, 0.0f);
  float _40 = min(_36, 5000.0f);
  float _41 = min(_37, 5000.0f);
  float _42 = min(_38, 5000.0f);
  float _43 = min(_39, 5000.0f);
  float _46 = _19.x * cb0_028z;
  float _47 = _46 + cb0_028x;
  float _48 = cb2_027w / _47;
  float _49 = 1.0f - _48;
  float _50 = abs(_49);
  float _52 = cb2_027y * _50;
  float _54 = _52 - cb2_027z;
  float _55 = saturate(_54);
  float _56 = max(_55, _43);
  float _57 = saturate(_56);
  float4 _58 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _62 = _40 - _28;
  float _63 = _41 - _29;
  float _64 = _42 - _30;
  float _65 = _57 * _62;
  float _66 = _57 * _63;
  float _67 = _57 * _64;
  float _68 = _65 + _28;
  float _69 = _66 + _29;
  float _70 = _67 + _30;
  float _71 = dot(float3(_68, _69, _70), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _75 = t0[0].SExposureData_020;
  float _77 = t0[0].SExposureData_004;
  float _79 = cb2_018x * 0.5f;
  float _80 = _79 * cb2_018y;
  float _81 = _77.x - _80;
  float _82 = cb2_018y * cb2_018x;
  float _83 = 1.0f / _82;
  float _84 = _81 * _83;
  float _85 = _71 / _75.x;
  float _86 = _85 * 5464.01611328125f;
  float _87 = _86 + 9.99999993922529e-09f;
  float _88 = log2(_87);
  float _89 = _88 - _81;
  float _90 = _89 * _83;
  float _91 = saturate(_90);
  float2 _92 = t7.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _91), 0.0f);
  float _95 = max(_92.y, 1.0000000116860974e-07f);
  float _96 = _92.x / _95;
  float _97 = _96 + _84;
  float _98 = _97 / _83;
  float _99 = _98 - _77.x;
  float _100 = -0.0f - _99;
  float _102 = _100 - cb2_027x;
  float _103 = max(0.0f, _102);
  float _106 = cb2_026z * _103;
  float _107 = _99 - cb2_027x;
  float _108 = max(0.0f, _107);
  float _110 = cb2_026w * _108;
  bool _111 = (_99 < 0.0f);
  float _112 = select(_111, _106, _110);
  float _113 = exp2(_112);
  float _114 = _113 * _68;
  float _115 = _113 * _69;
  float _116 = _113 * _70;
  float _121 = cb2_024y * _58.x;
  float _122 = cb2_024z * _58.y;
  float _123 = cb2_024w * _58.z;
  float _124 = _121 + _114;
  float _125 = _122 + _115;
  float _126 = _123 + _116;
  float _131 = _124 * cb2_025x;
  float _132 = _125 * cb2_025y;
  float _133 = _126 * cb2_025z;
  float _134 = dot(float3(_131, _132, _133), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _135 = t0[0].SExposureData_012;
  float _137 = _134 * 5464.01611328125f;
  float _138 = _137 * _135.x;
  float _139 = _138 + 9.99999993922529e-09f;
  float _140 = log2(_139);
  float _141 = _140 + 16.929765701293945f;
  float _142 = _141 * 0.05734497308731079f;
  float _143 = saturate(_142);
  float _144 = _143 * _143;
  float _145 = _143 * 2.0f;
  float _146 = 3.0f - _145;
  float _147 = _144 * _146;
  float _148 = _132 * 0.8450999855995178f;
  float _149 = _133 * 0.14589999616146088f;
  float _150 = _148 + _149;
  float _151 = _150 * 2.4890189170837402f;
  float _152 = _150 * 0.3754962384700775f;
  float _153 = _150 * 2.811495304107666f;
  float _154 = _150 * 5.519708156585693f;
  float _155 = _134 - _151;
  float _156 = _147 * _155;
  float _157 = _156 + _151;
  float _158 = _147 * 0.5f;
  float _159 = _158 + 0.5f;
  float _160 = _159 * _155;
  float _161 = _160 + _151;
  float _162 = _131 - _152;
  float _163 = _132 - _153;
  float _164 = _133 - _154;
  float _165 = _159 * _162;
  float _166 = _159 * _163;
  float _167 = _159 * _164;
  float _168 = _165 + _152;
  float _169 = _166 + _153;
  float _170 = _167 + _154;
  float _171 = 1.0f / _161;
  float _172 = _157 * _171;
  float _173 = _172 * _168;
  float _174 = _172 * _169;
  float _175 = _172 * _170;
  float _179 = cb2_020x * TEXCOORD0_centroid.x;
  float _180 = cb2_020y * TEXCOORD0_centroid.y;
  float _183 = _179 + cb2_020z;
  float _184 = _180 + cb2_020w;
  float _187 = dot(float2(_183, _184), float2(_183, _184));
  float _188 = 1.0f - _187;
  float _189 = saturate(_188);
  float _190 = log2(_189);
  float _191 = _190 * cb2_021w;
  float _192 = exp2(_191);
  float _196 = _173 - cb2_021x;
  float _197 = _174 - cb2_021y;
  float _198 = _175 - cb2_021z;
  float _199 = _196 * _192;
  float _200 = _197 * _192;
  float _201 = _198 * _192;
  float _202 = _199 + cb2_021x;
  float _203 = _200 + cb2_021y;
  float _204 = _201 + cb2_021z;
  float _205 = t0[0].SExposureData_000;
  float _207 = max(_75.x, 0.0010000000474974513f);
  float _208 = 1.0f / _207;
  float _209 = _208 * _205.x;
  bool _212 = ((uint)(cb2_069y) == 0);
  float _218;
  float _219;
  float _220;
  float _274;
  float _275;
  float _276;
  float _366;
  float _367;
  float _368;
  float _413;
  float _414;
  float _415;
  float _416;
  float _463;
  float _464;
  float _465;
  float _490;
  float _491;
  float _492;
  float _593;
  float _594;
  float _595;
  float _620;
  float _632;
  float _660;
  float _672;
  float _684;
  float _685;
  float _686;
  float _713;
  float _714;
  float _715;
  if (!_212) {
    float _214 = _209 * _202;
    float _215 = _209 * _203;
    float _216 = _209 * _204;
    _218 = _214;
    _219 = _215;
    _220 = _216;
  } else {
    _218 = _202;
    _219 = _203;
    _220 = _204;
  }
  float _221 = _218 * 0.6130970120429993f;
  float _222 = mad(0.33952298760414124f, _219, _221);
  float _223 = mad(0.04737899824976921f, _220, _222);
  float _224 = _218 * 0.07019399851560593f;
  float _225 = mad(0.9163540005683899f, _219, _224);
  float _226 = mad(0.013451999984681606f, _220, _225);
  float _227 = _218 * 0.02061600051820278f;
  float _228 = mad(0.10956999659538269f, _219, _227);
  float _229 = mad(0.8698149919509888f, _220, _228);
  float _230 = log2(_223);
  float _231 = log2(_226);
  float _232 = log2(_229);
  float _233 = _230 * 0.04211956635117531f;
  float _234 = _231 * 0.04211956635117531f;
  float _235 = _232 * 0.04211956635117531f;
  float _236 = _233 + 0.6252607107162476f;
  float _237 = _234 + 0.6252607107162476f;
  float _238 = _235 + 0.6252607107162476f;
  float4 _239 = t5.SampleLevel(s2_space2, float3(_236, _237, _238), 0.0f);
  bool _245 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_245 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _249 = cb2_017x * _239.x;
    float _250 = cb2_017x * _239.y;
    float _251 = cb2_017x * _239.z;
    float _253 = _249 + cb2_017y;
    float _254 = _250 + cb2_017y;
    float _255 = _251 + cb2_017y;
    float _256 = exp2(_253);
    float _257 = exp2(_254);
    float _258 = exp2(_255);
    float _259 = _256 + 1.0f;
    float _260 = _257 + 1.0f;
    float _261 = _258 + 1.0f;
    float _262 = 1.0f / _259;
    float _263 = 1.0f / _260;
    float _264 = 1.0f / _261;
    float _266 = cb2_017z * _262;
    float _267 = cb2_017z * _263;
    float _268 = cb2_017z * _264;
    float _270 = _266 + cb2_017w;
    float _271 = _267 + cb2_017w;
    float _272 = _268 + cb2_017w;
    _274 = _270;
    _275 = _271;
    _276 = _272;
  } else {
    _274 = _239.x;
    _275 = _239.y;
    _276 = _239.z;
  }
  float _277 = _274 * 23.0f;
  float _278 = _277 + -14.473931312561035f;
  float _279 = exp2(_278);
  float _280 = _275 * 23.0f;
  float _281 = _280 + -14.473931312561035f;
  float _282 = exp2(_281);
  float _283 = _276 * 23.0f;
  float _284 = _283 + -14.473931312561035f;
  float _285 = exp2(_284);
  float _286 = dot(float3(_279, _282, _285), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _291 = dot(float3(_279, _282, _285), float3(_279, _282, _285));
  float _292 = rsqrt(_291);
  float _293 = _292 * _279;
  float _294 = _292 * _282;
  float _295 = _292 * _285;
  float _296 = cb2_001x - _293;
  float _297 = cb2_001y - _294;
  float _298 = cb2_001z - _295;
  float _299 = dot(float3(_296, _297, _298), float3(_296, _297, _298));
  float _302 = cb2_002z * _299;
  float _304 = _302 + cb2_002w;
  float _305 = saturate(_304);
  float _307 = cb2_002x * _305;
  float _308 = _286 - _279;
  float _309 = _286 - _282;
  float _310 = _286 - _285;
  float _311 = _307 * _308;
  float _312 = _307 * _309;
  float _313 = _307 * _310;
  float _314 = _311 + _279;
  float _315 = _312 + _282;
  float _316 = _313 + _285;
  float _318 = cb2_002y * _305;
  float _319 = 0.10000000149011612f - _314;
  float _320 = 0.10000000149011612f - _315;
  float _321 = 0.10000000149011612f - _316;
  float _322 = _319 * _318;
  float _323 = _320 * _318;
  float _324 = _321 * _318;
  float _325 = _322 + _314;
  float _326 = _323 + _315;
  float _327 = _324 + _316;
  float _328 = saturate(_325);
  float _329 = saturate(_326);
  float _330 = saturate(_327);
  float _334 = cb2_004x * TEXCOORD0_centroid.x;
  float _335 = cb2_004y * TEXCOORD0_centroid.y;
  float _338 = _334 + cb2_004z;
  float _339 = _335 + cb2_004w;
  float4 _345 = t6.Sample(s2_space2, float2(_338, _339));
  float _350 = _345.x * cb2_003x;
  float _351 = _345.y * cb2_003y;
  float _352 = _345.z * cb2_003z;
  float _353 = _345.w * cb2_003w;
  float _356 = _353 + cb2_026y;
  float _357 = saturate(_356);
  bool _360 = ((uint)(cb2_069y) == 0);
  if (!_360) {
    float _362 = _350 * _209;
    float _363 = _351 * _209;
    float _364 = _352 * _209;
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
    float _418 = _413 + _328;
    float _419 = _414 + _329;
    float _420 = _415 + _330;
    _463 = _418;
    _464 = _419;
    _465 = _420;
  } else {
    if (_372) {
      float _423 = 1.0f - _413;
      float _424 = 1.0f - _414;
      float _425 = 1.0f - _415;
      float _426 = _423 * _328;
      float _427 = _424 * _329;
      float _428 = _425 * _330;
      float _429 = _426 + _413;
      float _430 = _427 + _414;
      float _431 = _428 + _415;
      _463 = _429;
      _464 = _430;
      _465 = _431;
    } else {
      bool _433 = ((uint)(cb2_028x) == 4);
      if (_433) {
        float _435 = _413 * _328;
        float _436 = _414 * _329;
        float _437 = _415 * _330;
        _463 = _435;
        _464 = _436;
        _465 = _437;
      } else {
        bool _439 = ((uint)(cb2_028x) == 5);
        if (_439) {
          float _441 = _328 * 2.0f;
          float _442 = _441 * _413;
          float _443 = _329 * 2.0f;
          float _444 = _443 * _414;
          float _445 = _330 * 2.0f;
          float _446 = _445 * _415;
          _463 = _442;
          _464 = _444;
          _465 = _446;
        } else {
          if (_375) {
            float _449 = _328 - _413;
            float _450 = _329 - _414;
            float _451 = _330 - _415;
            _463 = _449;
            _464 = _450;
            _465 = _451;
          } else {
            float _453 = _413 - _328;
            float _454 = _414 - _329;
            float _455 = _415 - _330;
            float _456 = _416 * _453;
            float _457 = _416 * _454;
            float _458 = _416 * _455;
            float _459 = _456 + _328;
            float _460 = _457 + _329;
            float _461 = _458 + _330;
            _463 = _459;
            _464 = _460;
            _465 = _461;
          }
        }
      }
    }
  }
  float _471 = cb2_016x - _463;
  float _472 = cb2_016y - _464;
  float _473 = cb2_016z - _465;
  float _474 = _471 * cb2_016w;
  float _475 = _472 * cb2_016w;
  float _476 = _473 * cb2_016w;
  float _477 = _474 + _463;
  float _478 = _475 + _464;
  float _479 = _476 + _465;
  bool _482 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_482 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _486 = cb2_024x * _477;
    float _487 = cb2_024x * _478;
    float _488 = cb2_024x * _479;
    _490 = _486;
    _491 = _487;
    _492 = _488;
  } else {
    _490 = _477;
    _491 = _478;
    _492 = _479;
  }
  float _493 = _490 * 0.9708889722824097f;
  float _494 = mad(0.026962999254465103f, _491, _493);
  float _495 = mad(0.002148000057786703f, _492, _494);
  float _496 = _490 * 0.01088900025933981f;
  float _497 = mad(0.9869629740715027f, _491, _496);
  float _498 = mad(0.002148000057786703f, _492, _497);
  float _499 = mad(0.026962999254465103f, _491, _496);
  float _500 = mad(0.9621480107307434f, _492, _499);
  if (_482) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _505 = cb1_018y * 0.10000000149011612f;
        float _506 = log2(cb1_018z);
        float _507 = _506 + -13.287712097167969f;
        float _508 = _507 * 1.4929734468460083f;
        float _509 = _508 + 18.0f;
        float _510 = exp2(_509);
        float _511 = _510 * 0.18000000715255737f;
        float _512 = abs(_511);
        float _513 = log2(_512);
        float _514 = _513 * 1.5f;
        float _515 = exp2(_514);
        float _516 = _515 * _505;
        float _517 = _516 / cb1_018z;
        float _518 = _517 + -0.07636754959821701f;
        float _519 = _513 * 1.2750000953674316f;
        float _520 = exp2(_519);
        float _521 = _520 * 0.07636754959821701f;
        float _522 = cb1_018y * 0.011232397519052029f;
        float _523 = _522 * _515;
        float _524 = _523 / cb1_018z;
        float _525 = _521 - _524;
        float _526 = _520 + -0.11232396960258484f;
        float _527 = _526 * _505;
        float _528 = _527 / cb1_018z;
        float _529 = _528 * cb1_018z;
        float _530 = abs(_495);
        float _531 = abs(_498);
        float _532 = abs(_500);
        float _533 = log2(_530);
        float _534 = log2(_531);
        float _535 = log2(_532);
        float _536 = _533 * 1.5f;
        float _537 = _534 * 1.5f;
        float _538 = _535 * 1.5f;
        float _539 = exp2(_536);
        float _540 = exp2(_537);
        float _541 = exp2(_538);
        float _542 = _539 * _529;
        float _543 = _540 * _529;
        float _544 = _541 * _529;
        float _545 = _533 * 1.2750000953674316f;
        float _546 = _534 * 1.2750000953674316f;
        float _547 = _535 * 1.2750000953674316f;
        float _548 = exp2(_545);
        float _549 = exp2(_546);
        float _550 = exp2(_547);
        float _551 = _548 * _518;
        float _552 = _549 * _518;
        float _553 = _550 * _518;
        float _554 = _551 + _525;
        float _555 = _552 + _525;
        float _556 = _553 + _525;
        float _557 = _542 / _554;
        float _558 = _543 / _555;
        float _559 = _544 / _556;
        float _560 = _557 * 9.999999747378752e-05f;
        float _561 = _558 * 9.999999747378752e-05f;
        float _562 = _559 * 9.999999747378752e-05f;
        float _563 = 5000.0f / cb1_018y;
        float _564 = _560 * _563;
        float _565 = _561 * _563;
        float _566 = _562 * _563;
        _593 = _564;
        _594 = _565;
        _595 = _566;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_495, _498, _500));
      _593 = tonemapped.x, _594 = tonemapped.y, _595 = tonemapped.z;
    }
      } else {
        float _568 = _495 + 0.020616600289940834f;
        float _569 = _498 + 0.020616600289940834f;
        float _570 = _500 + 0.020616600289940834f;
        float _571 = _568 * _495;
        float _572 = _569 * _498;
        float _573 = _570 * _500;
        float _574 = _571 + -7.456949970219284e-05f;
        float _575 = _572 + -7.456949970219284e-05f;
        float _576 = _573 + -7.456949970219284e-05f;
        float _577 = _495 * 0.9837960004806519f;
        float _578 = _498 * 0.9837960004806519f;
        float _579 = _500 * 0.9837960004806519f;
        float _580 = _577 + 0.4336790144443512f;
        float _581 = _578 + 0.4336790144443512f;
        float _582 = _579 + 0.4336790144443512f;
        float _583 = _580 * _495;
        float _584 = _581 * _498;
        float _585 = _582 * _500;
        float _586 = _583 + 0.24617899954319f;
        float _587 = _584 + 0.24617899954319f;
        float _588 = _585 + 0.24617899954319f;
        float _589 = _574 / _586;
        float _590 = _575 / _587;
        float _591 = _576 / _588;
        _593 = _589;
        _594 = _590;
        _595 = _591;
      }
      float _596 = _593 * 1.6047500371932983f;
      float _597 = mad(-0.5310800075531006f, _594, _596);
      float _598 = mad(-0.07366999983787537f, _595, _597);
      float _599 = _593 * -0.10208000242710114f;
      float _600 = mad(1.1081299781799316f, _594, _599);
      float _601 = mad(-0.006049999967217445f, _595, _600);
      float _602 = _593 * -0.0032599999103695154f;
      float _603 = mad(-0.07275000214576721f, _594, _602);
      float _604 = mad(1.0760200023651123f, _595, _603);
      if (_482) {
        // float _606 = max(_598, 0.0f);
        // float _607 = max(_601, 0.0f);
        // float _608 = max(_604, 0.0f);
        // bool _609 = !(_606 >= 0.0030399328097701073f);
        // if (!_609) {
        //   float _611 = abs(_606);
        //   float _612 = log2(_611);
        //   float _613 = _612 * 0.4166666567325592f;
        //   float _614 = exp2(_613);
        //   float _615 = _614 * 1.0549999475479126f;
        //   float _616 = _615 + -0.054999999701976776f;
        //   _620 = _616;
        // } else {
        //   float _618 = _606 * 12.923210144042969f;
        //   _620 = _618;
        // }
        // bool _621 = !(_607 >= 0.0030399328097701073f);
        // if (!_621) {
        //   float _623 = abs(_607);
        //   float _624 = log2(_623);
        //   float _625 = _624 * 0.4166666567325592f;
        //   float _626 = exp2(_625);
        //   float _627 = _626 * 1.0549999475479126f;
        //   float _628 = _627 + -0.054999999701976776f;
        //   _632 = _628;
        // } else {
        //   float _630 = _607 * 12.923210144042969f;
        //   _632 = _630;
        // }
        // bool _633 = !(_608 >= 0.0030399328097701073f);
        // if (!_633) {
        //   float _635 = abs(_608);
        //   float _636 = log2(_635);
        //   float _637 = _636 * 0.4166666567325592f;
        //   float _638 = exp2(_637);
        //   float _639 = _638 * 1.0549999475479126f;
        //   float _640 = _639 + -0.054999999701976776f;
        //   _713 = _620;
        //   _714 = _632;
        //   _715 = _640;
        // } else {
        //   float _642 = _608 * 12.923210144042969f;
        //   _713 = _620;
        //   _714 = _632;
        //   _715 = _642;
        // }
        _713 = renodx::color::srgb::EncodeSafe(_598);
        _714 = renodx::color::srgb::EncodeSafe(_601);
        _715 = renodx::color::srgb::EncodeSafe(_604);

      } else {
        float _644 = saturate(_598);
        float _645 = saturate(_601);
        float _646 = saturate(_604);
        bool _647 = ((uint)(cb1_018w) == -2);
        if (!_647) {
          bool _649 = !(_644 >= 0.0030399328097701073f);
          if (!_649) {
            float _651 = abs(_644);
            float _652 = log2(_651);
            float _653 = _652 * 0.4166666567325592f;
            float _654 = exp2(_653);
            float _655 = _654 * 1.0549999475479126f;
            float _656 = _655 + -0.054999999701976776f;
            _660 = _656;
          } else {
            float _658 = _644 * 12.923210144042969f;
            _660 = _658;
          }
          bool _661 = !(_645 >= 0.0030399328097701073f);
          if (!_661) {
            float _663 = abs(_645);
            float _664 = log2(_663);
            float _665 = _664 * 0.4166666567325592f;
            float _666 = exp2(_665);
            float _667 = _666 * 1.0549999475479126f;
            float _668 = _667 + -0.054999999701976776f;
            _672 = _668;
          } else {
            float _670 = _645 * 12.923210144042969f;
            _672 = _670;
          }
          bool _673 = !(_646 >= 0.0030399328097701073f);
          if (!_673) {
            float _675 = abs(_646);
            float _676 = log2(_675);
            float _677 = _676 * 0.4166666567325592f;
            float _678 = exp2(_677);
            float _679 = _678 * 1.0549999475479126f;
            float _680 = _679 + -0.054999999701976776f;
            _684 = _660;
            _685 = _672;
            _686 = _680;
          } else {
            float _682 = _646 * 12.923210144042969f;
            _684 = _660;
            _685 = _672;
            _686 = _682;
          }
        } else {
          _684 = _644;
          _685 = _645;
          _686 = _646;
        }
        float _691 = abs(_684);
        float _692 = abs(_685);
        float _693 = abs(_686);
        float _694 = log2(_691);
        float _695 = log2(_692);
        float _696 = log2(_693);
        float _697 = _694 * cb2_000z;
        float _698 = _695 * cb2_000z;
        float _699 = _696 * cb2_000z;
        float _700 = exp2(_697);
        float _701 = exp2(_698);
        float _702 = exp2(_699);
        float _703 = _700 * cb2_000y;
        float _704 = _701 * cb2_000y;
        float _705 = _702 * cb2_000y;
        float _706 = _703 + cb2_000x;
        float _707 = _704 + cb2_000x;
        float _708 = _705 + cb2_000x;
        float _709 = saturate(_706);
        float _710 = saturate(_707);
        float _711 = saturate(_708);
        _713 = _709;
        _714 = _710;
        _715 = _711;
      }
      float _716 = dot(float3(_713, _714, _715), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _713;
      SV_Target.y = _714;
      SV_Target.z = _715;
      SV_Target.w = _716;
      SV_Target_1.x = _716;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
