#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

Texture2D<float4> t14_space1 : register(t14, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t17_space1 : register(t17, space1);

Texture2D<float4> t19_space1 : register(t19, space1);

Texture2D<float4> t25_space1 : register(t25, space1);

Texture2D<float4> t29_space1 : register(t29, space1);

Texture2D<float4> t30_space1 : register(t30, space1);

Texture2D<float4> t31_space1 : register(t31, space1);

cbuffer cb3 : register(b3) {
  int g_rage_dynamicsamplerindices_000 : packoffset(c000.x);
  int g_rage_dynamicsamplerindices_004 : packoffset(c000.y);
  int g_rage_dynamicsamplerindices_008 : packoffset(c000.z);
  int g_rage_dynamicsamplerindices_012 : packoffset(c000.w);
  int g_rage_dynamicsamplerindices_016 : packoffset(c001.x);
  int g_rage_dynamicsamplerindices_020 : packoffset(c001.y);
  int g_rage_dynamicsamplerindices_024 : packoffset(c001.z);
  int g_rage_dynamicsamplerindices_028 : packoffset(c001.w);
  int g_rage_dynamicsamplerindices_032 : packoffset(c002.x);
  int g_rage_dynamicsamplerindices_036 : packoffset(c002.y);
  int g_rage_dynamicsamplerindices_040 : packoffset(c002.z);
  int g_rage_dynamicsamplerindices_044 : packoffset(c002.w);
  int g_rage_dynamicsamplerindices_048 : packoffset(c003.x);
  int g_rage_dynamicsamplerindices_052 : packoffset(c003.y);
  int g_rage_dynamicsamplerindices_056 : packoffset(c003.z);
  int g_rage_dynamicsamplerindices_060 : packoffset(c003.w);
  int g_rage_dynamicsamplerindices_064 : packoffset(c004.x);
  int g_rage_dynamicsamplerindices_068 : packoffset(c004.y);
  int g_rage_dynamicsamplerindices_072 : packoffset(c004.z);
  int g_rage_dynamicsamplerindices_076 : packoffset(c004.w);
  int g_rage_dynamicsamplerindices_080 : packoffset(c005.x);
  int g_rage_dynamicsamplerindices_084 : packoffset(c005.y);
};

cbuffer cb5 : register(b5) {
  float cb5_014w : packoffset(c014.w);
  float cb5_015x : packoffset(c015.x);
  float cb5_015y : packoffset(c015.y);
  uint cb5_022y : packoffset(c022.y);
};

cbuffer cb12_space1 : register(b12, space1) {
  float cb12_space1_000z : packoffset(c000.z);
  float cb12_space1_000w : packoffset(c000.w);
  float cb12_space1_003x : packoffset(c003.x);
  float cb12_space1_003y : packoffset(c003.y);
  float cb12_space1_003z : packoffset(c003.z);
  float cb12_space1_003w : packoffset(c003.w);
  float cb12_space1_004x : packoffset(c004.x);
  float cb12_space1_007y : packoffset(c007.y);
  float cb12_space1_010x : packoffset(c010.x);
  float cb12_space1_010y : packoffset(c010.y);
  float cb12_space1_010z : packoffset(c010.z);
  float cb12_space1_010w : packoffset(c010.w);
  float cb12_space1_011x : packoffset(c011.x);
  float cb12_space1_011y : packoffset(c011.y);
  float cb12_space1_011z : packoffset(c011.z);
  float cb12_space1_012x : packoffset(c012.x);
  float cb12_space1_012y : packoffset(c012.y);
  float cb12_space1_012z : packoffset(c012.z);
  float cb12_space1_012w : packoffset(c012.w);
  float cb12_space1_013x : packoffset(c013.x);
  float cb12_space1_013y : packoffset(c013.y);
  float cb12_space1_013z : packoffset(c013.z);
  float cb12_space1_014x : packoffset(c014.x);
  float cb12_space1_014y : packoffset(c014.y);
  float cb12_space1_015x : packoffset(c015.x);
  float cb12_space1_015y : packoffset(c015.y);
  float cb12_space1_015z : packoffset(c015.z);
  float cb12_space1_015w : packoffset(c015.w);
  float cb12_space1_034x : packoffset(c034.x);
  float cb12_space1_034y : packoffset(c034.y);
  float cb12_space1_034z : packoffset(c034.z);
  float cb12_space1_034w : packoffset(c034.w);
  float cb12_space1_035x : packoffset(c035.x);
  float cb12_space1_036w : packoffset(c036.w);
  float cb12_space1_046x : packoffset(c046.x);
  float cb12_space1_046y : packoffset(c046.y);
  float cb12_space1_046z : packoffset(c046.z);
  float cb12_space1_057x : packoffset(c057.x);
  float cb12_space1_057y : packoffset(c057.y);
  float cb12_space1_057z : packoffset(c057.z);
  float cb12_space1_058x : packoffset(c058.x);
  float cb12_space1_058y : packoffset(c058.y);
  float cb12_space1_058z : packoffset(c058.z);
  float cb12_space1_063x : packoffset(c063.x);
  float cb12_space1_063y : packoffset(c063.y);
  float cb12_space1_063z : packoffset(c063.z);
  float cb12_space1_063w : packoffset(c063.w);
  float cb12_space1_064x : packoffset(c064.x);
  float cb12_space1_065x : packoffset(c065.x);
  float cb12_space1_065y : packoffset(c065.y);
  float cb12_space1_065z : packoffset(c065.z);
  float cb12_space1_065w : packoffset(c065.w);
  float cb12_space1_066x : packoffset(c066.x);
  float cb12_space1_066y : packoffset(c066.y);
  float cb12_space1_066z : packoffset(c066.z);
  float cb12_space1_066w : packoffset(c066.w);
  float cb12_space1_067x : packoffset(c067.x);
  float cb12_space1_067y : packoffset(c067.y);
  float cb12_space1_069x : packoffset(c069.x);
  float cb12_space1_069y : packoffset(c069.y);
  float cb12_space1_069z : packoffset(c069.z);
  float cb12_space1_069w : packoffset(c069.w);
  float cb12_space1_072x : packoffset(c072.x);
  float cb12_space1_072y : packoffset(c072.y);
  float cb12_space1_072z : packoffset(c072.z);
  float cb12_space1_072w : packoffset(c072.w);
  float cb12_space1_075z : packoffset(c075.z);
  float cb12_space1_085x : packoffset(c085.x);
  float cb12_space1_089x : packoffset(c089.x);
  float cb12_space1_090x : packoffset(c090.x);
  float cb12_space1_090y : packoffset(c090.y);
  float cb12_space1_090z : packoffset(c090.z);
  float cb12_space1_091x : packoffset(c091.x);
  float cb12_space1_091y : packoffset(c091.y);
  float cb12_space1_091z : packoffset(c091.z);
  float cb12_space1_092x : packoffset(c092.x);
  float cb12_space1_092y : packoffset(c092.y);
  float cb12_space1_092z : packoffset(c092.z);
  float cb12_space1_092w : packoffset(c092.w);
  float cb12_space1_093x : packoffset(c093.x);
  float cb12_space1_093y : packoffset(c093.y);
  float cb12_space1_093z : packoffset(c093.z);
  float cb12_space1_093w : packoffset(c093.w);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s1_space1 : register(s1, space1);

SamplerState s2_space1 : register(s2, space1);

SamplerState s3_space1 : register(s3, space1);

SamplerState s0_space2[] : register(s0, space2);

SamplerState s8_space1 : register(s8, space1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float TEXCOORD_1: TEXCOORD1) : SV_Target {
  float4 SV_Target;
  float _26 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _33 = cb12_space1_000z / ((1.0f - _26.x) + cb12_space1_000w);
  float _43 = min(max((1.0f - saturate(((cb12_space1_072z / cb12_space1_072w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  float _50 = TEXCOORD.x + -0.5f;
  float _51 = TEXCOORD.y + -0.5f;
  float _52 = (cb12_space1_072x / cb12_space1_072y) * _50;
  float _53 = dot(float2(_52, _51), float2(_52, _51));
  float _59 = CUSTOM_LENS_DISTORTION * ((_43 * _53) * ((sqrt(_53) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
  float _60 = _59 * _50;
  float _61 = _59 * _51;
  float _62 = _60 + 0.5f;
  float _63 = _61 + 0.5f;
  float _67 = _62 * cb5_015x;
  float _68 = _63 * cb5_015y;
  float _71 = floor(_67 + -0.5f);
  float _72 = floor(_68 + -0.5f);
  float _73 = _71 + 0.5f;
  float _74 = _72 + 0.5f;
  float _75 = _67 - _73;
  float _76 = _68 - _74;
  float _77 = _75 * _75;
  float _78 = _76 * _76;
  float _79 = _77 * _75;
  float _80 = _78 * _76;
  float _85 = _77 - ((_79 + _75) * 0.5f);
  float _86 = _78 - ((_80 + _76) * 0.5f);
  float _98 = (_75 * 0.5f) * (_77 - _75);
  float _100 = (_76 * 0.5f) * (_78 - _76);
  float _102 = (1.0f - _98) - _85;
  float _105 = (1.0f - _100) - _86;
  float _117 = (((_102 - (((_79 * 1.5f) - (_77 * 2.5f)) + 1.0f)) / _102) + _73) / cb5_015x;
  float _118 = (((_105 - (((_80 * 1.5f) - (_78 * 2.5f)) + 1.0f)) / _105) + _74) / cb5_015y;
  float _121 = _102 * _86;
  float _122 = _105 * _85;
  float _123 = _102 * _105;
  float _124 = _105 * _98;
  float _125 = _102 * _100;
  float _129 = (((_121 + _122) + _123) + _124) + _125;
  float4 _134 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_117, ((_72 + -0.5f) / cb5_015y)), 0.0f);
  float4 _143 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_71 + -0.5f) / cb5_015x), _118), 0.0f);
  float4 _154 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_117, _118), 0.0f);
  float4 _165 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_71 + 2.5f) / cb5_015x), _118), 0.0f);
  float4 _176 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_117, ((_72 + 2.5f) / cb5_015y)), 0.0f);
  float _185 = max(0.0f, ((((((_143.y * _122) + (_134.y * _121)) + (_154.y * _123)) + (_165.y * _124)) + (_176.y * _125)) / _129));
  float _186 = max(0.0f, ((((((_143.z * _122) + (_134.z * _121)) + (_154.z * _123)) + (_165.z * _124)) + (_176.z * _125)) / _129));
  float _194 = (cb12_space1_072x / cb12_space1_072y) * _60;
  float _195 = dot(float2(_194, _61), float2(_194, _61));
  float _201 = CUSTOM_CHROMATIC_ABERRATION * ((_43 * _195) * ((sqrt(_195) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _210 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_201 * _60) + 0.5f), ((_201 * _61) + 0.5f)));
  float _214 = cb5_014w * _210.x;
  float _362;
  float _363;
  float _364;
  float _411;
  float _412;
  float _413;
  float _805;
  float _806;
  float _807;
  if (!(cb12_space1_085x > 0.0f)) {
    float _222 = cb12_space1_072y * 0.5f;
    float _223 = _62 - cb12_space1_072x;
    float _224 = _63 - _222;
    float4 _225 = t14_space1.Sample(s2_space1, float2(_223, _224));
    float _229 = cb12_space1_072x * 0.5f;
    float _230 = _229 + _62;
    float _231 = _63 - cb12_space1_072y;
    float4 _232 = t14_space1.Sample(s2_space1, float2(_230, _231));
    float _236 = _62 - _229;
    float _237 = cb12_space1_072y + _63;
    float4 _238 = t14_space1.Sample(s2_space1, float2(_236, _237));
    float _242 = cb12_space1_072x + _62;
    float _243 = _222 + _63;
    float4 _244 = t14_space1.Sample(s2_space1, float2(_242, _243));
    float4 _248 = t14_space1.Sample(s2_space1, float2(_62, _63));
    float4 _252 = t19_space1.Sample(s1_space1, float2(_223, _224));
    float4 _256 = t19_space1.Sample(s1_space1, float2(_230, _231));
    float4 _260 = t19_space1.Sample(s1_space1, float2(_236, _237));
    float4 _264 = t19_space1.Sample(s1_space1, float2(_242, _243));
    float4 _268 = t19_space1.Sample(s1_space1, float2(_62, _63));
    float _273 = (_268.x + _248.x) * 0.5f;
    float _275 = (_268.y + _248.y) * 0.5f;
    float _277 = (_268.z + _248.z) * 0.5f;
    bool _307 = !(cb12_space1_004x == 0.0f);
    float _326 = max(saturate(1.0f - ((_33 - cb12_space1_003x) * cb12_space1_003y)), saturate((_33 - cb12_space1_003z) * cb12_space1_003w));
    float _327 = _326 * 2.0040080547332764f;
    float _332 = saturate(1.0f - _327);
    float _335 = 1.0f - _332;
    float _336 = min(saturate(2.0020039081573486f - _327), _335);
    float _337 = _335 - _336;
    float _338 = min(saturate(999.9999389648438f - (_326 * 999.9999389648438f)), _337);
    float _339 = _337 - _338;
    _362 = ((((_336 * _268.x) + (_332 * _214)) + (_338 * select(_307, _268.x, _273))) + (_339 * select(_307, _268.x, (((((((((_232.x + _225.x) + _238.x) + _244.x) + _252.x) + _256.x) + _260.x) + _264.x) + _273) * 0.1111111119389534f))));
    _363 = ((((_336 * _268.y) + (_332 * _185)) + (_338 * select(_307, _268.y, _275))) + (_339 * select(_307, _268.y, (((((((((_232.y + _225.y) + _238.y) + _244.y) + _252.y) + _256.y) + _260.y) + _264.y) + _275) * 0.1111111119389534f))));
    _364 = ((((_336 * _268.z) + (_332 * _186)) + (_338 * select(_307, _268.z, _277))) + (_339 * select(_307, _268.z, (((((((((_232.z + _225.z) + _238.z) + _244.z) + _252.z) + _256.z) + _260.z) + _264.z) + _277) * 0.1111111119389534f))));
  } else {
    _362 = _214;
    _363 = _185;
    _364 = _186;
  }
  float4 _365 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _377 = (cb12_space1_064x * (_365.x - _362)) + _362;
  float _378 = (cb12_space1_064x * (_365.y - _363)) + _363;
  float _379 = (cb12_space1_064x * (_365.z - _364)) + _364;
  bool _382 = (cb12_space1_007y < 0.0f);
  float _383 = select(_382, 1.0f, TEXCOORD.w);
  float4 _384 = t25_space1.Sample(s2_space1, float2(_62, _63));

  _384 *= CUSTOM_BLOOM;

  float _388 = _384.x * _383;
  float _389 = _384.y * _383;
  float _390 = _384.z * _383;
  if (cb12_space1_075z > 0.0f) {
    float4 _395 = t31_space1.Sample(s2_space1, float2(_62, _63));

    _395 = max(0, _395);

    float _397 = _395.x * _395.x;
    float _398 = _397 * _397;
    float _399 = _398 * _398 * CUSTOM_SUN_BLOOM;

    _411 = ((_399 * cb12_space1_046x) + _377);
    _412 = ((_399 * cb12_space1_046y) + _378);
    _413 = ((_399 * cb12_space1_046z) + _379);
  } else {
    _411 = _377;
    _412 = _378;
    _413 = _379;
  }
  float4 _414 = t29_space1.Sample(s3_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _436 = ((((cb12_space1_034z + -1.0f) + ((cb12_space1_034w - cb12_space1_034z) * saturate((TEXCOORD.z - cb12_space1_034x) * cb12_space1_034y))) * cb12_space1_035x) + 1.0f) * cb12_space1_036w;

  _436 *= CUSTOM_LENS_FLARE;

  float _440 = (_436 * _414.x) + _411;
  float _441 = (_436 * _414.y) + _412;
  float _442 = (_436 * _414.z) + _413;

  float3 untonemapped = float3(_440, _441, _442);

  float _451 = abs(cb12_space1_007y);
  float _473 = TEXCOORD.x + -0.5f;
  float _474 = TEXCOORD.y + -0.5f;
  float _483 = saturate(saturate(exp2(log2(1.0f - dot(float2(_473, _474), float2(_473, _474))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);
  float _508 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _527 = ((cb12_space1_012x - cb12_space1_010x) * _508) + cb12_space1_010x;
  float _528 = ((cb12_space1_012y - cb12_space1_010y) * _508) + cb12_space1_010y;
  float _530 = ((cb12_space1_012w - cb12_space1_010w) * _508) + cb12_space1_010w;
  float _545 = ((cb12_space1_013x - cb12_space1_011x) * _508) + cb12_space1_011x;
  float _546 = ((cb12_space1_013y - cb12_space1_011y) * _508) + cb12_space1_011y;
  float _547 = ((cb12_space1_013z - cb12_space1_011z) * _508) + cb12_space1_011z;
  float _548 = _547 * _527;
  float _549 = (lerp(cb12_space1_010z, cb12_space1_012z, _508)) * _528;
  float _552 = _545 * _530;
  float _556 = _546 * _530;
  float _559 = _545 / _546;
  float _561 = 1.0f / (((((_548 + _549) * _547) + _552) / (((_548 + _528) * _547) + _556)) - _559);

  float mid_gray = 0.18f;
  {
    float _388 = 0.18f;
    float _389 = 0.18f;
    float _390 = 0.18f;

    float _440 = 0.18f;
    float _441 = 0.18f;
    float _442 = 0.18f;

    float _565 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _483)) * (_440 + select(_382, (((cb5_014w * _388) - _440) * _451), ((_388 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _566 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _483)) * (_441 + select(_382, (((cb5_014w * _389) - _441) * _451), ((_389 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _567 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _483)) * (_442 + select(_382, (((cb5_014w * _390) - _442) * _451), ((_390 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _568 = _565 * _527;
    float _569 = _566 * _527;
    float _570 = _567 * _527;
    // Replace saturate with max
    float _598 = max(0.f, (((((_568 + _549) * _565) + _552) / (((_568 + _528) * _565) + _556)) - _559) * _561);
    float _599 = max(0.f, (((((_569 + _549) * _566) + _552) / (((_569 + _528) * _566) + _556)) - _559) * _561);
    float _600 = max(0.f, (((((_570 + _549) * _567) + _552) / (((_570 + _528) * _567) + _556)) - _559) * _561);

    mid_gray = renodx::color::y::from::BT709(float3(_598, _599, _600));
  }

  float _565 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _483)) * (_440 + select(_382, (((cb5_014w * _388) - _440) * _451), ((_388 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _566 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _483)) * (_441 + select(_382, (((cb5_014w * _389) - _441) * _451), ((_389 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _567 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _483)) * (_442 + select(_382, (((cb5_014w * _390) - _442) * _451), ((_390 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _568 = _565 * _527;
  float _569 = _566 * _527;
  float _570 = _567 * _527;
  // Replace saturate with max
  float _598 = max(0.f, (((((_568 + _549) * _565) + _552) / (((_568 + _528) * _565) + _556)) - _559) * _561);
  float _599 = max(0.f, (((((_569 + _549) * _566) + _552) / (((_569 + _528) * _566) + _556)) - _559) * _561);
  float _600 = max(0.f, (((((_570 + _549) * _567) + _552) / (((_570 + _528) * _567) + _556)) - _559) * _561);
  float _601 = dot(float3(_598, _599, _600), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _610 = (cb12_space1_067x * (_598 - _601)) + _601;
  float _611 = (cb12_space1_067x * (_599 - _601)) + _601;
  float _612 = (cb12_space1_067x * (_600 - _601)) + _601;
  float _616 = saturate(_601 / cb12_space1_066w);
  float _633 = (lerp(cb12_space1_066x, cb12_space1_065x, _616)) * _610;
  float _634 = (lerp(cb12_space1_066y, cb12_space1_065y, _616)) * _611;
  float _635 = (lerp(cb12_space1_066z, cb12_space1_065z, _616)) * _612;
  float _641 = saturate(((_601 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        mid_gray,
        float3(_633, _634, _635),
        float3(_610, _611, _612),
        _641,
        TEXCOORD.xy);
  }

  float _686 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _702 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _706 = (_702.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_706, _686);

  float _713 = saturate(max(0.0f, (_706 + (_686 * exp2(log2(abs(saturate(lerp(_633, _610, _641)))) * cb12_space1_067y)))));
  float _714 = saturate(max(0.0f, (_706 + (_686 * exp2(log2(abs(saturate(lerp(_634, _611, _641)))) * cb12_space1_067y)))));
  float _715 = saturate(max(0.0f, (_706 + (_686 * exp2(log2(abs(saturate(lerp(_635, _612, _641)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _725 = (asint(cb12_space1_092w) != 0);
    float _727 = max(_713, max(_714, _715));
    float _781 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _784 = (_781.x * 2.0f) + -1.0f;
    float _790 = float(((int)(uint)((bool)(_784 > 0.0f))) - ((int)(uint)((bool)(_784 < 0.0f))));
    float _794 = 1.0f - sqrt(1.0f - abs(_784));
    _805 = (((_794 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_725, _713, _727) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _790) + _713);
    _806 = (((_794 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_725, _714, _727) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _790) + _714);
    _807 = (((_794 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_725, _715, _727) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _790) + _715);

    ConfigureVanillaDithering(
        _713, _714, _715,
        _805, _806, _807);
  } else {
    _805 = _713;
    _806 = _714;
    _807 = _715;
  }
  SV_Target.x = _805;
  SV_Target.y = _806;
  SV_Target.z = _807;
  SV_Target.w = dot(float3(_713, _714, _715), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}
