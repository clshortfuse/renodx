#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

Texture2D<float4> t14_space1 : register(t14, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t16_space1 : register(t16, space1);

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
  float _113 = CUSTOM_LENS_DISTORTION * ((_97 * _107) * ((sqrt(_107) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
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
  float _255 = CUSTOM_CHROMATIC_ABERRATION * ((_97 * _249) * ((sqrt(_249) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _264 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_255 * _114) + 0.5f), ((_255 * _115) + 0.5f)));
  float _268 = cb5_014w * _264.x;
  float _416;
  float _417;
  float _418;
  float _465;
  float _466;
  float _467;
  float _830;
  float _831;
  float _832;
  if (!(cb12_space1_085x > 0.0f)) {
    float _276 = cb12_space1_072y * 0.5f;
    float _277 = _116 - cb12_space1_072x;
    float _278 = _117 - _276;
    float4 _279 = t14_space1.Sample(s2_space1, float2(_277, _278));
    float _283 = cb12_space1_072x * 0.5f;
    float _284 = _283 + _116;
    float _285 = _117 - cb12_space1_072y;
    float4 _286 = t14_space1.Sample(s2_space1, float2(_284, _285));
    float _290 = _116 - _283;
    float _291 = cb12_space1_072y + _117;
    float4 _292 = t14_space1.Sample(s2_space1, float2(_290, _291));
    float _296 = cb12_space1_072x + _116;
    float _297 = _276 + _117;
    float4 _298 = t14_space1.Sample(s2_space1, float2(_296, _297));
    float4 _302 = t14_space1.Sample(s2_space1, float2(_116, _117));
    float4 _306 = t19_space1.Sample(s1_space1, float2(_277, _278));
    float4 _310 = t19_space1.Sample(s1_space1, float2(_284, _285));
    float4 _314 = t19_space1.Sample(s1_space1, float2(_290, _291));
    float4 _318 = t19_space1.Sample(s1_space1, float2(_296, _297));
    float4 _322 = t19_space1.Sample(s1_space1, float2(_116, _117));
    float _327 = (_322.x + _302.x) * 0.5f;
    float _329 = (_322.y + _302.y) * 0.5f;
    float _331 = (_322.z + _302.z) * 0.5f;
    bool _361 = !(cb12_space1_004x == 0.0f);
    float _380 = max(saturate(1.0f - ((_34 - cb12_space1_003x) * cb12_space1_003y)), saturate((_34 - cb12_space1_003z) * cb12_space1_003w));
    float _381 = _380 * 2.0040080547332764f;
    float _386 = saturate(1.0f - _381);
    float _389 = 1.0f - _386;
    float _390 = min(saturate(2.0020039081573486f - _381), _389);
    float _391 = _389 - _390;
    float _392 = min(saturate(999.9999389648438f - (_380 * 999.9999389648438f)), _391);
    float _393 = _391 - _392;
    _416 = ((((_390 * _322.x) + (_386 * _268)) + (_392 * select(_361, _322.x, _327))) + (_393 * select(_361, _322.x, (((((((((_286.x + _279.x) + _292.x) + _298.x) + _306.x) + _310.x) + _314.x) + _318.x) + _327) * 0.1111111119389534f))));
    _417 = ((((_390 * _322.y) + (_386 * _239)) + (_392 * select(_361, _322.y, _329))) + (_393 * select(_361, _322.y, (((((((((_286.y + _279.y) + _292.y) + _298.y) + _306.y) + _310.y) + _314.y) + _318.y) + _329) * 0.1111111119389534f))));
    _418 = ((((_390 * _322.z) + (_386 * _240)) + (_392 * select(_361, _322.z, _331))) + (_393 * select(_361, _322.z, (((((((((_286.z + _279.z) + _292.z) + _298.z) + _306.z) + _310.z) + _314.z) + _318.z) + _331) * 0.1111111119389534f))));
  } else {
    _416 = _268;
    _417 = _239;
    _418 = _240;
  }
  float4 _419 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _431 = (cb12_space1_064x * (_419.x - _416)) + _416;
  float _432 = (cb12_space1_064x * (_419.y - _417)) + _417;
  float _433 = (cb12_space1_064x * (_419.z - _418)) + _418;
  bool _436 = (cb12_space1_007y < 0.0f);
  float _437 = select(_436, 1.0f, TEXCOORD.w);
  float4 _438 = t25_space1.Sample(s2_space1, float2(_116, _117));

  _438 *= CUSTOM_BLOOM;

  float _442 = _438.x * _437;
  float _443 = _438.y * _437;
  float _444 = _438.z * _437;
  if (cb12_space1_075z > 0.0f) {
    float4 _449 = t31_space1.Sample(s2_space1, float2(_116, _117));

    _449 = max(0, _449);

    float _451 = _449.x * _449.x;
    float _452 = _451 * _451;
    float _453 = _452 * _452 * CUSTOM_SUN_BLOOM;

    _465 = ((_453 * cb12_space1_046x) + _431);
    _466 = ((_453 * cb12_space1_046y) + _432);
    _467 = ((_453 * cb12_space1_046z) + _433);
  } else {
    _465 = _431;
    _466 = _432;
    _467 = _433;
  }
  float _476 = abs(cb12_space1_007y);
  float _498 = TEXCOORD.x + -0.5f;
  float _499 = TEXCOORD.y + -0.5f;
  float _508 = saturate(saturate(exp2(log2(1.0f - dot(float2(_498, _499), float2(_498, _499))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);

  _508 = lerp(1.f, _508, CUSTOM_VIGNETTE);

  float _533 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _552 = ((cb12_space1_012x - cb12_space1_010x) * _533) + cb12_space1_010x;
  float _553 = ((cb12_space1_012y - cb12_space1_010y) * _533) + cb12_space1_010y;
  float _555 = ((cb12_space1_012w - cb12_space1_010w) * _533) + cb12_space1_010w;
  float _570 = ((cb12_space1_013x - cb12_space1_011x) * _533) + cb12_space1_011x;
  float _571 = ((cb12_space1_013y - cb12_space1_011y) * _533) + cb12_space1_011y;
  float _572 = ((cb12_space1_013z - cb12_space1_011z) * _533) + cb12_space1_011z;
  float _573 = _572 * _552;
  float _574 = (lerp(cb12_space1_010z, cb12_space1_012z, _533)) * _553;
  float _577 = _570 * _555;
  float _581 = _571 * _555;
  float _584 = _570 / _571;
  float _586 = 1.0f / (((((_573 + _574) * _572) + _577) / (((_573 + _553) * _572) + _581)) - _584);

  float mid_gray = 0.18f;
  {
    float _442 = 0.18f;
    float _443 = 0.18f;
    float _444 = 0.18f;

    float _465 = 0.18f;
    float _466 = 0.18f;
    float _467 = 0.18f;

    float _590 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _508)) * (_465 + select(_436, (((cb5_014w * _442) - _465) * _476), ((_442 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _591 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _508)) * (_466 + select(_436, (((cb5_014w * _443) - _466) * _476), ((_443 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _592 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _508)) * (_467 + select(_436, (((cb5_014w * _444) - _467) * _476), ((_444 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _593 = _590 * _552;
    float _594 = _591 * _552;
    float _595 = _592 * _552;
    // Replace saturate with max
    float _623 = max(0.f, (((((_593 + _574) * _590) + _577) / (((_593 + _553) * _590) + _581)) - _584) * _586);
    float _624 = max(0.f, (((((_594 + _574) * _591) + _577) / (((_594 + _553) * _591) + _581)) - _584) * _586);
    float _625 = max(0.f, (((((_595 + _574) * _592) + _577) / (((_595 + _553) * _592) + _581)) - _584) * _586);

    mid_gray = renodx::color::y::from::BT709(float3(_623, _624, _625));
  }

  float _590 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _508)) * (_465 + select(_436, (((cb5_014w * _442) - _465) * _476), ((_442 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _591 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _508)) * (_466 + select(_436, (((cb5_014w * _443) - _466) * _476), ((_443 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _592 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _508)) * (_467 + select(_436, (((cb5_014w * _444) - _467) * _476), ((_444 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _593 = _590 * _552;
  float _594 = _591 * _552;
  float _595 = _592 * _552;

  float3 untonemapped = float3(_593, _594, _595) * mid_gray / 0.18f;

  // Replace saturate with max
  float _623 = max(0.f, (((((_593 + _574) * _590) + _577) / (((_593 + _553) * _590) + _581)) - _584) * _586);
  float _624 = max(0.f, (((((_594 + _574) * _591) + _577) / (((_594 + _553) * _591) + _581)) - _584) * _586);
  float _625 = max(0.f, (((((_595 + _574) * _592) + _577) / (((_595 + _553) * _592) + _581)) - _584) * _586);

  ApplyPerChannelCorrection(untonemapped, _623, _624, _625);

  float _626 = dot(float3(_623, _624, _625), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _635 = (cb12_space1_067x * (_623 - _626)) + _626;
  float _636 = (cb12_space1_067x * (_624 - _626)) + _626;
  float _637 = (cb12_space1_067x * (_625 - _626)) + _626;
  float _641 = saturate(_626 / cb12_space1_066w);
  float _658 = (lerp(cb12_space1_066x, cb12_space1_065x, _641)) * _635;
  float _659 = (lerp(cb12_space1_066y, cb12_space1_065y, _641)) * _636;
  float _660 = (lerp(cb12_space1_066z, cb12_space1_065z, _641)) * _637;
  float _666 = saturate(((_626 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        float3(_658, _659, _660),
        float3(_635, _636, _637),
        _666,
        TEXCOORD.xy);
  }

  float _711 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _727 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _731 = (_727.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_731, _711);

  float _738 = saturate(max(0.0f, (_731 + (_711 * exp2(log2(abs(saturate(lerp(_658, _635, _666)))) * cb12_space1_067y)))));
  float _739 = saturate(max(0.0f, (_731 + (_711 * exp2(log2(abs(saturate(lerp(_659, _636, _666)))) * cb12_space1_067y)))));
  float _740 = saturate(max(0.0f, (_731 + (_711 * exp2(log2(abs(saturate(lerp(_660, _637, _666)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _750 = (asint(cb12_space1_092w) != 0);
    float _752 = max(_738, max(_739, _740));
    float _806 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _809 = (_806.x * 2.0f) + -1.0f;
    float _815 = float(((int)(uint)((bool)(_809 > 0.0f))) - ((int)(uint)((bool)(_809 < 0.0f))));
    float _819 = 1.0f - sqrt(1.0f - abs(_809));
    _830 = (((_819 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_750, _738, _752) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _815) + _738);
    _831 = (((_819 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_750, _739, _752) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _815) + _739);
    _832 = (((_819 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_750, _740, _752) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _815) + _740);

    ConfigureVanillaDithering(
        _738, _739, _740,
        _830, _831, _832);

  } else {
    _830 = _738;
    _831 = _739;
    _832 = _740;
  }
  SV_Target.x = _830;
  SV_Target.y = _831;
  SV_Target.z = _832;
  SV_Target.w = dot(float3(_738, _739, _740), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}
