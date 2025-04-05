#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);  // Grain

Texture2D<float> t11_space1 : register(t11, space1);  // Depth Buffer

Texture2D<float4> t14_space1 : register(t14, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t16_space1 : register(t16, space1);

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
  float cb12_space1_030y : packoffset(c030.y);
  float cb12_space1_030z : packoffset(c030.z);
  float cb12_space1_030w : packoffset(c030.w);
  float cb12_space1_031x : packoffset(c031.x);
  float cb12_space1_031y : packoffset(c031.y);
  float cb12_space1_031z : packoffset(c031.z);
  float cb12_space1_031w : packoffset(c031.w);
  float cb12_space1_032x : packoffset(c032.x);
  float cb12_space1_032y : packoffset(c032.y);
  float cb12_space1_032z : packoffset(c032.z);
  float cb12_space1_032w : packoffset(c032.w);
  float cb12_space1_033x : packoffset(c033.x);
  float cb12_space1_033y : packoffset(c033.y);
  float cb12_space1_033z : packoffset(c033.z);
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
  float _27 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _34 = cb12_space1_000z / ((1.0f - _27.x) + cb12_space1_000w);
  float4 _41 = t16_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _51 = (((_41.x * float((bool)((bool)((bool)(_34 > cb12_space1_030y) && (bool)(_34 < cb12_space1_030y))))) * cb12_space1_033z) * (cb12_space1_030w - cb12_space1_030z)) + cb12_space1_030z;
  float4 _70 = t29_space1.Sample(s3_space1, float2(((cb12_space1_031x * TEXCOORD.x) + cb12_space1_031z), ((cb12_space1_031y * TEXCOORD.y) + cb12_space1_031w)));
  float4 _73 = t29_space1.Sample(s3_space1, float2(((cb12_space1_032x * TEXCOORD.x) + cb12_space1_032z), ((cb12_space1_032y * TEXCOORD.y) + cb12_space1_032w)));
  float _97 = min(max((1.0f - saturate(((cb12_space1_072z / cb12_space1_072w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  float _104 = (((cb12_space1_033x * _51) * ((_70.x + -1.0f) + _73.x)) + TEXCOORD.x) + -0.5f;
  float _105 = (((cb12_space1_033y * _51) * ((_70.y + -1.0f) + _73.y)) + TEXCOORD.y) + -0.5f;
  float _106 = (cb12_space1_072x / cb12_space1_072y) * _104;
  float _107 = dot(float2(_106, _105), float2(_106, _105));
  float _113 = ((_97 * _107) * ((sqrt(_107) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
  float _114 = _113 * _104;
  float _115 = _113 * _105;
  float _116 = _114 + 0.5f;
  float _117 = _115 + 0.5f;
  float _121 = _116 * cb5_015x;
  float _122 = _117 * cb5_015y;
  float _125 = floor(_121 + -0.5f);
  float _126 = floor(_122 + -0.5f);
  float _127 = _125 + 0.5f;
  float _128 = _126 + 0.5f;
  float _129 = _121 - _127;
  float _130 = _122 - _128;
  float _131 = _129 * _129;
  float _132 = _130 * _130;
  float _133 = _131 * _129;
  float _134 = _132 * _130;
  float _139 = _131 - ((_133 + _129) * 0.5f);
  float _140 = _132 - ((_134 + _130) * 0.5f);
  float _152 = (_129 * 0.5f) * (_131 - _129);
  float _154 = (_130 * 0.5f) * (_132 - _130);
  float _156 = (1.0f - _152) - _139;
  float _159 = (1.0f - _154) - _140;
  float _171 = (((_156 - (((_133 * 1.5f) - (_131 * 2.5f)) + 1.0f)) / _156) + _127) / cb5_015x;
  float _172 = (((_159 - (((_134 * 1.5f) - (_132 * 2.5f)) + 1.0f)) / _159) + _128) / cb5_015y;
  float _175 = _156 * _140;
  float _176 = _159 * _139;
  float _177 = _156 * _159;
  float _178 = _159 * _152;
  float _179 = _156 * _154;
  float _183 = (((_175 + _176) + _177) + _178) + _179;
  float4 _188 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_171, ((_126 + -0.5f) / cb5_015y)), 0.0f);
  float4 _197 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_125 + -0.5f) / cb5_015x), _172), 0.0f);
  float4 _208 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_171, _172), 0.0f);
  float4 _219 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_125 + 2.5f) / cb5_015x), _172), 0.0f);
  float4 _230 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_171, ((_126 + 2.5f) / cb5_015y)), 0.0f);
  float _239 = max(0.0f, ((((((_197.y * _176) + (_188.y * _175)) + (_208.y * _177)) + (_219.y * _178)) + (_230.y * _179)) / _183));
  float _240 = max(0.0f, ((((((_197.z * _176) + (_188.z * _175)) + (_208.z * _177)) + (_219.z * _178)) + (_230.z * _179)) / _183));
  float _248 = (cb12_space1_072x / cb12_space1_072y) * _114;
  float _249 = dot(float2(_248, _115), float2(_248, _115));
  float _255 = ((_97 * _249) * ((sqrt(_249) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _264 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_255 * _114) + 0.5f), ((_255 * _115) + 0.5f)));
  float _268 = cb5_014w * _264.x;
  float _349;
  float _350;
  float _351;
  float _398;
  float _399;
  float _400;
  float _763;
  float _764;
  float _765;
  if (!(cb12_space1_085x > 0.0f)) {
    float4 _273 = t19_space1.Sample(s1_space1, float2(_116, _117));
    float4 _277 = t14_space1.Sample(s2_space1, float2(_116, _117));
    float4 _281 = t30_space1.Sample(s2_space1, float2(_116, _117));
    float _312 = max(saturate(1.0f - ((_34 - cb12_space1_003x) * cb12_space1_003y)), saturate((_34 - cb12_space1_003z) * cb12_space1_003w));
    float _319 = saturate(1.0f - (_312 * 499.9999694824219f));
    float _322 = 1.0f - _319;
    float _323 = min(saturate(0.5015197396278381f - (_312 * 0.5065855979919434f)), _322);
    float _324 = _322 - _323;
    float _325 = min(saturate(100.0f - (_312 * 100.0f)), _324);
    float _326 = _324 - _325;
    _349 = ((((_323 * _273.x) + (_319 * _268)) + (_325 * ((_277.x * 0.699999988079071f) + (_273.x * 0.30000001192092896f)))) + (((_281.x + _277.x) * 0.5f) * _326));
    _350 = ((((_323 * _273.y) + (_319 * _239)) + (_325 * ((_277.y * 0.699999988079071f) + (_273.y * 0.30000001192092896f)))) + (((_281.y + _277.y) * 0.5f) * _326));
    _351 = ((((_323 * _273.z) + (_319 * _240)) + (_325 * ((_277.z * 0.699999988079071f) + (_273.z * 0.30000001192092896f)))) + (((_281.z + _277.z) * 0.5f) * _326));
  } else {
    _349 = _268;
    _350 = _239;
    _351 = _240;
  }
  float4 _352 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _364 = (cb12_space1_064x * (_352.x - _349)) + _349;
  float _365 = (cb12_space1_064x * (_352.y - _350)) + _350;
  float _366 = (cb12_space1_064x * (_352.z - _351)) + _351;
  bool _369 = (cb12_space1_007y < 0.0f);
  float _370 = select(_369, 1.0f, TEXCOORD.w);
  float4 _371 = t25_space1.Sample(s2_space1, float2(_116, _117));

  _371 *= CUSTOM_BLOOM;

  float _375 = _371.x * _370;
  float _376 = _371.y * _370;
  float _377 = _371.z * _370;
  if (cb12_space1_075z > 0.0f) {
    float4 _382 = t31_space1.Sample(s2_space1, float2(_116, _117));

    _382 = max(0, _382);  // Fix NaN

    float _384 = _382.x * _382.x;
    float _385 = _384 * _384;
    float _386 = _385 * _385;
    _398 = ((_386 * cb12_space1_046x) + _364);
    _399 = ((_386 * cb12_space1_046y) + _365);
    _400 = ((_386 * cb12_space1_046z) + _366);
  } else {
    _398 = _364;
    _399 = _365;
    _400 = _366;
  }

  float3 untonemapped = float3(_398, _399, _400);

  float _409 = abs(cb12_space1_007y);
  float _431 = TEXCOORD.x + -0.5f;
  float _432 = TEXCOORD.y + -0.5f;
  float _441 = saturate(saturate(exp2(log2(1.0f - dot(float2(_431, _432), float2(_431, _432))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);
  float _466 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _485 = ((cb12_space1_012x - cb12_space1_010x) * _466) + cb12_space1_010x;
  float _486 = ((cb12_space1_012y - cb12_space1_010y) * _466) + cb12_space1_010y;
  float _488 = ((cb12_space1_012w - cb12_space1_010w) * _466) + cb12_space1_010w;
  float _503 = ((cb12_space1_013x - cb12_space1_011x) * _466) + cb12_space1_011x;
  float _504 = ((cb12_space1_013y - cb12_space1_011y) * _466) + cb12_space1_011y;
  float _505 = ((cb12_space1_013z - cb12_space1_011z) * _466) + cb12_space1_011z;
  float _506 = _505 * _485;
  float _507 = (lerp(cb12_space1_010z, cb12_space1_012z, _466)) * _486;
  float _510 = _503 * _488;
  float _514 = _504 * _488;
  float _517 = _503 / _504;
  float _519 = 1.0f / (((((_506 + _507) * _505) + _510) / (((_506 + _486) * _505) + _514)) - _517);

  float mid_gray = 0.18f;
  float mid_gray_gamma = renodx::color::gamma::Encode(mid_gray);
  {
    float _375 = mid_gray_gamma;
    float _376 = mid_gray_gamma;
    float _377 = mid_gray_gamma;

    float _398 = mid_gray_gamma;
    float _399 = mid_gray_gamma;
    float _400 = mid_gray_gamma;

    float _523 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _441)) * (_398 + select(_369, (((cb5_014w * _375) - _398) * _409), ((_375 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _524 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _441)) * (_399 + select(_369, (((cb5_014w * _376) - _399) * _409), ((_376 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _525 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _441)) * (_400 + select(_369, (((cb5_014w * _377) - _400) * _409), ((_377 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _526 = _523 * _485;
    float _527 = _524 * _485;
    float _528 = _525 * _485;
    // Replace saturate with max
    float _556 = max(0.f, (((((_526 + _507) * _523) + _510) / (((_526 + _486) * _523) + _514)) - _517) * _519);
    float _557 = max(0.f, (((((_527 + _507) * _524) + _510) / (((_527 + _486) * _524) + _514)) - _517) * _519);
    float _558 = max(0.f, (((((_528 + _507) * _525) + _510) / (((_528 + _486) * _525) + _514)) - _517) * _519);

    mid_gray = renodx::color::y::from::BT709(renodx::color::gamma::Decode(float3(_556, _557, _558)));
  }

  float _523 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _441)) * (_398 + select(_369, (((cb5_014w * _375) - _398) * _409), ((_375 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _524 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _441)) * (_399 + select(_369, (((cb5_014w * _376) - _399) * _409), ((_376 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _525 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _441)) * (_400 + select(_369, (((cb5_014w * _377) - _400) * _409), ((_377 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _526 = _523 * _485;
  float _527 = _524 * _485;
  float _528 = _525 * _485;
  // Replace saturate with max
  float _556 = max(0.f, (((((_526 + _507) * _523) + _510) / (((_526 + _486) * _523) + _514)) - _517) * _519);
  float _557 = max(0.f, (((((_527 + _507) * _524) + _510) / (((_527 + _486) * _524) + _514)) - _517) * _519);
  float _558 = max(0.f, (((((_528 + _507) * _525) + _510) / (((_528 + _486) * _525) + _514)) - _517) * _519);
  float _559 = dot(float3(_556, _557, _558), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _568 = (cb12_space1_067x * (_556 - _559)) + _559;
  float _569 = (cb12_space1_067x * (_557 - _559)) + _559;
  float _570 = (cb12_space1_067x * (_558 - _559)) + _559;
  float _574 = saturate(_559 / cb12_space1_066w);
  float _591 = (lerp(cb12_space1_066x, cb12_space1_065x, _574)) * _568;
  float _592 = (lerp(cb12_space1_066y, cb12_space1_065y, _574)) * _569;
  float _593 = (lerp(cb12_space1_066z, cb12_space1_065z, _574)) * _570;
  float _599 = saturate(((_559 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        mid_gray,
        float3(_591, _592, _593),
        float3(_568, _569, _570),
        _599,
        cb12_space1_067y,
        TEXCOORD.xy);
  }
  float _644 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _660 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _664 = (_660.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_664, _644);

  float _671 = saturate(max(0.0f, (_664 + (_644 * exp2(log2(abs(saturate(lerp(_591, _568, _599)))) * cb12_space1_067y)))));
  float _672 = saturate(max(0.0f, (_664 + (_644 * exp2(log2(abs(saturate(lerp(_592, _569, _599)))) * cb12_space1_067y)))));
  float _673 = saturate(max(0.0f, (_664 + (_644 * exp2(log2(abs(saturate(lerp(_593, _570, _599)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _683 = (asint(cb12_space1_092w) != 0);
    float _685 = max(_671, max(_672, _673));
    float _739 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _742 = (_739.x * 2.0f) + -1.0f;
    float _748 = float(((int)(uint)((bool)(_742 > 0.0f))) - ((int)(uint)((bool)(_742 < 0.0f))));
    float _752 = 1.0f - sqrt(1.0f - abs(_742));
    _763 = (((_752 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_683, _671, _685) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _748) + _671);
    _764 = (((_752 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_683, _672, _685) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _748) + _672);
    _765 = (((_752 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_683, _673, _685) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _748) + _673);

    ConfigureVanillaDithering(
        _671, _672, _673,
        _763, _764, _765);

  } else {
    _763 = _671;
    _764 = _672;
    _765 = _673;
  }
  SV_Target.x = _763;
  SV_Target.y = _764;
  SV_Target.z = _765;
  SV_Target.w = dot(float3(_671, _672, _673), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb));
  return SV_Target;
}
