#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

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
  float cb12_space1_002x : packoffset(c002.x);
  float cb12_space1_002y : packoffset(c002.y);
  float cb12_space1_002z : packoffset(c002.z);
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
  float _25 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _27 = 1.0f - _25.x;
  float _53 = min(max((1.0f - saturate(((cb12_space1_072z / cb12_space1_072w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  float _60 = TEXCOORD.x + -0.5f;
  float _61 = TEXCOORD.y + -0.5f;
  float _62 = (cb12_space1_072x / cb12_space1_072y) * _60;
  float _63 = dot(float2(_62, _61), float2(_62, _61));
  float _69 = CUSTOM_LENS_DISTORTION * ((_53 * _63) * ((sqrt(_63) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
  float _70 = _69 * _60;
  float _71 = _69 * _61;
  float _72 = _70 + 0.5f;
  float _73 = _71 + 0.5f;
  float _77 = _72 * cb5_015x;
  float _78 = _73 * cb5_015y;
  float _81 = floor(_77 + -0.5f);
  float _82 = floor(_78 + -0.5f);
  float _83 = _81 + 0.5f;
  float _84 = _82 + 0.5f;
  float _85 = _77 - _83;
  float _86 = _78 - _84;
  float _87 = _85 * _85;
  float _88 = _86 * _86;
  float _89 = _87 * _85;
  float _90 = _88 * _86;
  float _95 = _87 - ((_89 + _85) * 0.5f);
  float _96 = _88 - ((_90 + _86) * 0.5f);
  float _108 = (_85 * 0.5f) * (_87 - _85);
  float _110 = (_86 * 0.5f) * (_88 - _86);
  float _112 = (1.0f - _108) - _95;
  float _115 = (1.0f - _110) - _96;
  float _127 = (((_112 - (((_89 * 1.5f) - (_87 * 2.5f)) + 1.0f)) / _112) + _83) / cb5_015x;
  float _128 = (((_115 - (((_90 * 1.5f) - (_88 * 2.5f)) + 1.0f)) / _115) + _84) / cb5_015y;
  float _131 = _112 * _96;
  float _132 = _115 * _95;
  float _133 = _112 * _115;
  float _134 = _115 * _108;
  float _135 = _112 * _110;
  float _139 = (((_131 + _132) + _133) + _134) + _135;
  float4 _144 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_127, ((_82 + -0.5f) / cb5_015y)), 0.0f);
  float4 _153 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_81 + -0.5f) / cb5_015x), _128), 0.0f);
  float4 _164 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_127, _128), 0.0f);
  float4 _175 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_81 + 2.5f) / cb5_015x), _128), 0.0f);
  float4 _186 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_127, ((_82 + 2.5f) / cb5_015y)), 0.0f);
  float _195 = max(0.0f, ((((((_153.y * _132) + (_144.y * _131)) + (_164.y * _133)) + (_175.y * _134)) + (_186.y * _135)) / _139));
  float _196 = max(0.0f, ((((((_153.z * _132) + (_144.z * _131)) + (_164.z * _133)) + (_175.z * _134)) + (_186.z * _135)) / _139));
  float _204 = (cb12_space1_072x / cb12_space1_072y) * _70;
  float _205 = dot(float2(_204, _71), float2(_204, _71));
  float _211 = CUSTOM_CHROMATIC_ABERRATION * ((_53 * _205) * ((sqrt(_205) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _220 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_211 * _70) + 0.5f), ((_211 * _71) + 0.5f)));
  float _224 = cb5_014w * _220.x;
  float4 _225 = t19_space1.Sample(s1_space1, float2(_72, _73));
  float _229 = saturate((saturate(cb12_space1_002y * ((cb12_space1_000z / (_27 + cb12_space1_000w)) - cb12_space1_002x)) * float((bool)((bool)(!(_27 == 0.0f))))) * cb12_space1_002z);
  float _236 = ((_225.x - _224) * _229) + _224;
  float _237 = ((_225.y - _195) * _229) + _195;
  float _238 = ((_225.z - _196) * _229) + _196;
  float4 _239 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _251 = (cb12_space1_064x * (_239.x - _236)) + _236;
  float _252 = (cb12_space1_064x * (_239.y - _237)) + _237;
  float _253 = (cb12_space1_064x * (_239.z - _238)) + _238;
  bool _256 = (cb12_space1_007y < 0.0f);
  float _257 = select(_256, 1.0f, TEXCOORD.w);
  float4 _258 = t25_space1.Sample(s2_space1, float2(_72, _73));

  _258 *= CUSTOM_BLOOM;

  float _262 = _258.x * _257;
  float _263 = _258.y * _257;
  float _264 = _258.z * _257;
  float _285;
  float _286;
  float _287;
  float _679;
  float _680;
  float _681;
  if (cb12_space1_075z > 0.0f) {
    float4 _269 = t31_space1.Sample(s2_space1, float2(_72, _73));

    _269 = max(0.f, _269);

    float _271 = _269.x * _269.x;
    float _272 = _271 * _271;
    float _273 = _272 * _272 * CUSTOM_SUN_BLOOM;

    _285 = ((_273 * cb12_space1_046x) + _251);
    _286 = ((_273 * cb12_space1_046y) + _252);
    _287 = ((_273 * cb12_space1_046z) + _253);
  } else {
    _285 = _251;
    _286 = _252;
    _287 = _253;
  }
  float4 _288 = t29_space1.Sample(s3_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _310 = ((((cb12_space1_034z + -1.0f) + ((cb12_space1_034w - cb12_space1_034z) * saturate((TEXCOORD.z - cb12_space1_034x) * cb12_space1_034y))) * cb12_space1_035x) + 1.0f) * cb12_space1_036w;

  _310 *= CUSTOM_LENS_FLARE;

  float _314 = (_310 * _288.x) + _285;
  float _315 = (_310 * _288.y) + _286;
  float _316 = (_310 * _288.z) + _287;

  float _325 = abs(cb12_space1_007y);
  float _347 = TEXCOORD.x + -0.5f;
  float _348 = TEXCOORD.y + -0.5f;
  float _357 = saturate(saturate(exp2(log2(1.0f - dot(float2(_347, _348), float2(_347, _348))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);

  _357 = lerp(1.f, _357, CUSTOM_VIGNETTE);

  float _382 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _401 = ((cb12_space1_012x - cb12_space1_010x) * _382) + cb12_space1_010x;
  float _402 = ((cb12_space1_012y - cb12_space1_010y) * _382) + cb12_space1_010y;
  float _404 = ((cb12_space1_012w - cb12_space1_010w) * _382) + cb12_space1_010w;
  float _419 = ((cb12_space1_013x - cb12_space1_011x) * _382) + cb12_space1_011x;
  float _420 = ((cb12_space1_013y - cb12_space1_011y) * _382) + cb12_space1_011y;
  float _421 = ((cb12_space1_013z - cb12_space1_011z) * _382) + cb12_space1_011z;
  float _422 = _421 * _401;
  float _423 = (lerp(cb12_space1_010z, cb12_space1_012z, _382)) * _402;
  float _426 = _419 * _404;
  float _430 = _420 * _404;
  float _433 = _419 / _420;
  float _435 = 1.0f / (((((_422 + _423) * _421) + _426) / (((_422 + _402) * _421) + _430)) - _433);

  float mid_gray = 0.18f;
  {
    float _262 = 0.18f;
    float _263 = 0.18f;
    float _264 = 0.18f;

    float _314 = 0.18f;
    float _315 = 0.18f;
    float _316 = 0.18f;

    float _439 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _357)) * (_314 + select(_256, (((cb5_014w * _262) - _314) * _325), ((_262 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _440 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _357)) * (_315 + select(_256, (((cb5_014w * _263) - _315) * _325), ((_263 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _441 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _357)) * (_316 + select(_256, (((cb5_014w * _264) - _316) * _325), ((_264 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _442 = _439 * _401;
    float _443 = _440 * _401;
    float _444 = _441 * _401;
    // Replace saturate with max
    float _472 = max(0.f, (((((_442 + _423) * _439) + _426) / (((_442 + _402) * _439) + _430)) - _433) * _435);
    float _473 = max(0.f, (((((_443 + _423) * _440) + _426) / (((_443 + _402) * _440) + _430)) - _433) * _435);
    float _474 = max(0.f, (((((_444 + _423) * _441) + _426) / (((_444 + _402) * _441) + _430)) - _433) * _435);

    mid_gray = renodx::color::y::from::BT709(float3(_472, _473, _474));
  }

  float _439 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _357)) * (_314 + select(_256, (((cb5_014w * _262) - _314) * _325), ((_262 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _440 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _357)) * (_315 + select(_256, (((cb5_014w * _263) - _315) * _325), ((_263 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _441 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _357)) * (_316 + select(_256, (((cb5_014w * _264) - _316) * _325), ((_264 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _442 = _439 * _401;
  float _443 = _440 * _401;
  float _444 = _441 * _401;

  float3 untonemapped = float3(_442, _443, _444) * mid_gray / 0.18f;

  // Replace saturate with max
  float _472 = max(0.f, (((((_442 + _423) * _439) + _426) / (((_442 + _402) * _439) + _430)) - _433) * _435);
  float _473 = max(0.f, (((((_443 + _423) * _440) + _426) / (((_443 + _402) * _440) + _430)) - _433) * _435);
  float _474 = max(0.f, (((((_444 + _423) * _441) + _426) / (((_444 + _402) * _441) + _430)) - _433) * _435);

  ApplyPerChannelCorrection(untonemapped, _472, _473, _474);

  float _475 = dot(float3(_472, _473, _474), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _484 = (cb12_space1_067x * (_472 - _475)) + _475;
  float _485 = (cb12_space1_067x * (_473 - _475)) + _475;
  float _486 = (cb12_space1_067x * (_474 - _475)) + _475;
  float _490 = saturate(_475 / cb12_space1_066w);
  float _507 = (lerp(cb12_space1_066x, cb12_space1_065x, _490)) * _484;
  float _508 = (lerp(cb12_space1_066y, cb12_space1_065y, _490)) * _485;
  float _509 = (lerp(cb12_space1_066z, cb12_space1_065z, _490)) * _486;
  float _515 = saturate(((_475 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        float3(_507, _508, _509),
        float3(_484, _485, _486),
        _515,
        TEXCOORD.xy);
  }

  float _560 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _576 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _580 = (_576.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_580, _560);

  float _587 = saturate(max(0.0f, (_580 + (_560 * exp2(log2(abs(saturate(lerp(_507, _484, _515)))) * cb12_space1_067y)))));
  float _588 = saturate(max(0.0f, (_580 + (_560 * exp2(log2(abs(saturate(lerp(_508, _485, _515)))) * cb12_space1_067y)))));
  float _589 = saturate(max(0.0f, (_580 + (_560 * exp2(log2(abs(saturate(lerp(_509, _486, _515)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _599 = (asint(cb12_space1_092w) != 0);
    float _601 = max(_587, max(_588, _589));
    float _655 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _658 = (_655.x * 2.0f) + -1.0f;
    float _664 = float(((int)(uint)((bool)(_658 > 0.0f))) - ((int)(uint)((bool)(_658 < 0.0f))));
    float _668 = 1.0f - sqrt(1.0f - abs(_658));
    _679 = (((_668 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_599, _587, _601) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _664) + _587);
    _680 = (((_668 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_599, _588, _601) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _664) + _588);
    _681 = (((_668 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_599, _589, _601) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _664) + _589);

    ConfigureVanillaDithering(
        _587, _588, _589,
        _679, _680, _681);
  } else {
    _679 = _587;
    _680 = _588;
    _681 = _589;
  }
  SV_Target.x = _679;
  SV_Target.y = _680;
  SV_Target.z = _681;
  SV_Target.w = dot(float3(_587, _588, _589), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}
