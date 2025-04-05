#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);  // Grain

Texture2D<float> t11_space1 : register(t11, space1);  // Depth Buffer

Texture2D<float4> t14_space1 : register(t14, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t17_space1 : register(t17, space1);

Texture2D<float4> t19_space1 : register(t19, space1);  // Render

Texture2D<float4> t25_space1 : register(t25, space1);  // Bloom

Texture2D<float4> t29_space1 : register(t29, space1);  // Lens Flare

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
  float _59 = ((_43 * _53) * ((sqrt(_53) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
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
  float _201 = ((_43 * _195) * ((sqrt(_195) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _210 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_201 * _60) + 0.5f), ((_201 * _61) + 0.5f)));
  float _214 = cb5_014w * _210.x;
  float _295;
  float _296;
  float _297;
  float _344;
  float _345;
  float _346;
  float _738;
  float _739;
  float _740;
  if (!(cb12_space1_085x > 0.0f)) {
    float4 _219 = t19_space1.Sample(s1_space1, float2(_62, _63));
    float4 _223 = t14_space1.Sample(s2_space1, float2(_62, _63));
    float4 _227 = t30_space1.Sample(s2_space1, float2(_62, _63));
    float _258 = max(saturate(1.0f - ((_33 - cb12_space1_003x) * cb12_space1_003y)), saturate((_33 - cb12_space1_003z) * cb12_space1_003w));
    float _265 = saturate(1.0f - (_258 * 499.9999694824219f));
    float _268 = 1.0f - _265;
    float _269 = min(saturate(0.5015197396278381f - (_258 * 0.5065855979919434f)), _268);
    float _270 = _268 - _269;
    float _271 = min(saturate(100.0f - (_258 * 100.0f)), _270);
    float _272 = _270 - _271;
    _295 = ((((_269 * _219.x) + (_265 * _214)) + (_271 * ((_223.x * 0.699999988079071f) + (_219.x * 0.30000001192092896f)))) + (((_227.x + _223.x) * 0.5f) * _272));
    _296 = ((((_269 * _219.y) + (_265 * _185)) + (_271 * ((_223.y * 0.699999988079071f) + (_219.y * 0.30000001192092896f)))) + (((_227.y + _223.y) * 0.5f) * _272));
    _297 = ((((_269 * _219.z) + (_265 * _186)) + (_271 * ((_223.z * 0.699999988079071f) + (_219.z * 0.30000001192092896f)))) + (((_227.z + _223.z) * 0.5f) * _272));
  } else {
    _295 = _214;
    _296 = _185;
    _297 = _186;
  }
  float4 _298 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _310 = (cb12_space1_064x * (_298.x - _295)) + _295;
  float _311 = (cb12_space1_064x * (_298.y - _296)) + _296;
  float _312 = (cb12_space1_064x * (_298.z - _297)) + _297;
  bool _315 = (cb12_space1_007y < 0.0f);
  float _316 = select(_315, 1.0f, TEXCOORD.w);
  float4 _317 = t25_space1.Sample(s2_space1, float2(_62, _63));

  _317 *= CUSTOM_BLOOM;

  float _321 = _317.x * _316;
  float _322 = _317.y * _316;
  float _323 = _317.z * _316;
  if (cb12_space1_075z > 0.0f) {
    float4 _328 = t31_space1.Sample(s2_space1, float2(_62, _63));

    _328 = max(0, _328);  // Fix NaN

    float _330 = _328.x * _328.x;
    float _331 = _330 * _330;
    float _332 = _331 * _331;
    _344 = ((_332 * cb12_space1_046x) + _310);
    _345 = ((_332 * cb12_space1_046y) + _311);
    _346 = ((_332 * cb12_space1_046z) + _312);
  } else {
    _344 = _310;
    _345 = _311;
    _346 = _312;
  }
  float4 _347 = t29_space1.Sample(s3_space1, float2(TEXCOORD.x, TEXCOORD.y));

  _347 *= 1.f;  // Unknown

  float _369 = ((((cb12_space1_034z + -1.0f) + ((cb12_space1_034w - cb12_space1_034z) * saturate((TEXCOORD.z - cb12_space1_034x) * cb12_space1_034y))) * cb12_space1_035x) + 1.0f) * cb12_space1_036w;
  float _373 = (_369 * _347.x) + _344;
  float _374 = (_369 * _347.y) + _345;
  float _375 = (_369 * _347.z) + _346;

  float3 untonemapped = float3(_373, _374, _375);

  float _384 = abs(cb12_space1_007y);
  float _406 = TEXCOORD.x + -0.5f;
  float _407 = TEXCOORD.y + -0.5f;
  float _416 = saturate(saturate(exp2(log2(1.0f - dot(float2(_406, _407), float2(_406, _407))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);
  float _441 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _460 = ((cb12_space1_012x - cb12_space1_010x) * _441) + cb12_space1_010x;
  float _461 = ((cb12_space1_012y - cb12_space1_010y) * _441) + cb12_space1_010y;
  float _463 = ((cb12_space1_012w - cb12_space1_010w) * _441) + cb12_space1_010w;
  float _478 = ((cb12_space1_013x - cb12_space1_011x) * _441) + cb12_space1_011x;
  float _479 = ((cb12_space1_013y - cb12_space1_011y) * _441) + cb12_space1_011y;
  float _480 = ((cb12_space1_013z - cb12_space1_011z) * _441) + cb12_space1_011z;
  float _481 = _480 * _460;
  float _482 = (lerp(cb12_space1_010z, cb12_space1_012z, _441)) * _461;
  float _485 = _478 * _463;
  float _489 = _479 * _463;
  float _492 = _478 / _479;
  float _494 = 1.0f / (((((_481 + _482) * _480) + _485) / (((_481 + _461) * _480) + _489)) - _492);

  float mid_gray = 0.18f;
  float mid_gray_gamma = renodx::color::gamma::Encode(mid_gray);
  {
    float _321 = mid_gray_gamma;
    float _322 = mid_gray_gamma;
    float _323 = mid_gray_gamma;

    float _373 = mid_gray_gamma;
    float _374 = mid_gray_gamma;
    float _375 = mid_gray_gamma;

    float _498 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _416)) * (_373 + select(_315, (((cb5_014w * _321) - _373) * _384), ((_321 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _499 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _416)) * (_374 + select(_315, (((cb5_014w * _322) - _374) * _384), ((_322 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _500 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _416)) * (_375 + select(_315, (((cb5_014w * _323) - _375) * _384), ((_323 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _501 = _498 * _460;
    float _502 = _499 * _460;
    float _503 = _500 * _460;
    // Replace saturate with max
    float _531 = max(0.f, (((((_501 + _482) * _498) + _485) / (((_501 + _461) * _498) + _489)) - _492) * _494);
    float _532 = max(0.f, (((((_502 + _482) * _499) + _485) / (((_502 + _461) * _499) + _489)) - _492) * _494);
    float _533 = max(0.f, (((((_503 + _482) * _500) + _485) / (((_503 + _461) * _500) + _489)) - _492) * _494);

    mid_gray = renodx::color::y::from::BT709(renodx::color::gamma::Decode(float3(_531, _532, _533)));
  }
  float _498 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _416)) * (_373 + select(_315, (((cb5_014w * _321) - _373) * _384), ((_321 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _499 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _416)) * (_374 + select(_315, (((cb5_014w * _322) - _374) * _384), ((_322 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _500 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _416)) * (_375 + select(_315, (((cb5_014w * _323) - _375) * _384), ((_323 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _501 = _498 * _460;
  float _502 = _499 * _460;
  float _503 = _500 * _460;
  // Replace saturate with max
  float _531 = max(0.f, (((((_501 + _482) * _498) + _485) / (((_501 + _461) * _498) + _489)) - _492) * _494);
  float _532 = max(0.f, (((((_502 + _482) * _499) + _485) / (((_502 + _461) * _499) + _489)) - _492) * _494);
  float _533 = max(0.f, (((((_503 + _482) * _500) + _485) / (((_503 + _461) * _500) + _489)) - _492) * _494);
  float _534 = dot(float3(_531, _532, _533), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _543 = (cb12_space1_067x * (_531 - _534)) + _534;
  float _544 = (cb12_space1_067x * (_532 - _534)) + _534;
  float _545 = (cb12_space1_067x * (_533 - _534)) + _534;
  float _549 = saturate(_534 / cb12_space1_066w);
  float _566 = (lerp(cb12_space1_066x, cb12_space1_065x, _549)) * _543;
  float _567 = (lerp(cb12_space1_066y, cb12_space1_065y, _549)) * _544;
  float _568 = (lerp(cb12_space1_066z, cb12_space1_065z, _549)) * _545;
  float _574 = saturate(((_534 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        mid_gray,
        float3(_566, _567, _568),
        float3(_543, _544, _545),
        _574,
        cb12_space1_067y,
        TEXCOORD.xy);
  }

  float _619 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _635 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _639 = (_635.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_639, _619);

  float _646 = saturate(max(0.0f, (_639 + (_619 * exp2(log2(abs(saturate(lerp(_566, _543, _574)))) * cb12_space1_067y)))));
  float _647 = saturate(max(0.0f, (_639 + (_619 * exp2(log2(abs(saturate(lerp(_567, _544, _574)))) * cb12_space1_067y)))));
  float _648 = saturate(max(0.0f, (_639 + (_619 * exp2(log2(abs(saturate(lerp(_568, _545, _574)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _658 = (asint(cb12_space1_092w) != 0);
    float _660 = max(_646, max(_647, _648));
    float _714 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _717 = (_714.x * 2.0f) + -1.0f;
    float _723 = float(((int)(uint)((bool)(_717 > 0.0f))) - ((int)(uint)((bool)(_717 < 0.0f))));
    float _727 = 1.0f - sqrt(1.0f - abs(_717));
    _738 = (((_727 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_658, _646, _660) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _723) + _646);
    _739 = (((_727 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_658, _647, _660) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _723) + _647);
    _740 = (((_727 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_658, _648, _660) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _723) + _648);

    ConfigureVanillaDithering(
        _646, _647, _648,
        _738, _739, _740);

  } else {
    _738 = _646;
    _739 = _647;
    _740 = _648;
  }
  SV_Target.x = _738;
  SV_Target.y = _739;
  SV_Target.z = _740;
  SV_Target.w = dot(float3(_646, _647, _648), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb));
  return SV_Target;
}
